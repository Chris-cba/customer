CREATE OR REPLACE PACKAGE BODY mai_act AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mai_act.pkb	1.1 06/23/04
--       Module Name      : mai_act.pkb
--       Date into SCCS   : 04/06/23 10:53:25
--       Date fetched Out : 07/06/06 14:33:29
--       SCCS Version     : 1.1
--
-- MAINTENANCE MANAGER application generic utilities
--
-----------------------------------------------------------------------------
--   Originally taken from '@(#)mai.pkb	1.3'
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
-- Return the SCCS id of the package
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
    RETURN g_sccsid;
END;
-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.
FUNCTION parse_inv_condition
	(instring            VARCHAR2)
	 RETURN VARCHAR2 IS

  dummycursor		INTEGER;
BEGIN

  dummycursor	:= DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(dummycursor,
                'select null from inv_items_all where '||instring,
                dbms_sql.native);

  RETURN('PARSED');

EXCEPTION
  WHEN OTHERS THEN RETURN('NOT PARSED');
END;

  -----------------------------------------------------------------------------
   -- Function to Create BOQ Items
   --
   FUNCTION cre_boq_items(
        p_defect_id          IN		boq_items.boq_defect_id%TYPE
       ,p_rep_action_cat     IN		boq_items.boq_rep_action_cat%TYPE
       ,p_oun_org_id         IN		hig_admin_units.hau_admin_unit%TYPE
       ,p_treat_code         IN		treatments.tre_treat_code%TYPE
       ,p_defect_code        IN		defects.def_defect_code%TYPE
       ,p_sys_flag           IN	        road_segments_all.rse_sys_flag%TYPE
       ,p_atv_acty_area_code IN		activities.atv_acty_area_code%TYPE
       ,p_tremodlev          IN		NUMBER
       ,p_attr_value         IN		NUMBER )
   RETURN NUMBER IS

l_return    NUMBER;

BEGIN

INSERT INTO boq_items
(      boq_work_flag
      ,boq_defect_id
      ,boq_rep_action_cat
      ,boq_wol_id
      ,boq_sta_item_code
      ,boq_date_created
      ,boq_est_dim1
      ,boq_est_dim2
      ,boq_est_dim3
      ,boq_est_quantity
      ,boq_est_rate
      ,boq_est_cost
      ,boq_est_labour
      ,boq_id)
SELECT 'D'
      ,p_defect_id
      ,p_rep_action_cat
      ,0
      ,sta.sta_item_code
      ,SYSDATE
      ,NVL(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * NVL(p_attr_value,0) )
      ,DECODE( sta_dim2_text, NULL, NULL, 1 )
      ,DECODE( sta_dim3_text, NULL, NULL, 1 )
      ,NVL(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * NVL(p_attr_value,0) )
      ,sta.sta_rate
      ,sta.sta_rate * NVL(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * NVL(p_attr_value,0) )
      ,NVL(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * NVL(p_attr_value,0) ) * sta_labour_units
      ,boq_id_seq.NEXTVAL
FROM standard_items         sta
    ,treatment_model_items  tmi
    ,treatment_models       tmo
    ,def_types              dty
    ,hig_admin_units        hau
    ,hig_admin_groups       hag
WHERE hau.hau_level              = p_tremodlev
AND   hau.hau_admin_unit         = hag.hag_parent_admin_unit
AND   tmo.tmo_oun_org_id         = hau.hau_admin_unit
AND   hag.hag_child_admin_unit   = p_oun_org_id
AND   tmo.tmo_tre_treat_code     = p_treat_code
AND   tmo.tmo_atv_acty_area_code = p_atv_acty_area_code
AND   tmo.tmo_dty_defect_code    = p_defect_code
AND   tmo.tmo_sys_flag           = p_sys_flag
AND   dty.dty_defect_code        = p_defect_code
AND   dty.dty_atv_acty_area_code = p_atv_acty_area_code
AND   dty.dty_dtp_flag           = p_sys_flag
AND   tmi.tmi_tmo_id             = tmo.tmo_id
AND   tmi.tmi_sta_item_code      = sta.sta_item_code;

RETURN( SQL%rowcount );

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN (0);
   WHEN OTHERS THEN
      RETURN (-1);
END;

PROCEDURE calculate_inv_quantity
        (he_id        IN     road_segments_all.rse_he_id%TYPE ,
         calc_type    IN     standard_items.sta_calc_type%TYPE,
         item_code    IN     schedule_items.schi_sta_item_code%TYPE,
         quantity     IN OUT schedule_items.schi_calc_quantity%TYPE) IS
      CURSOR c1 IS
      SELECT
         'select nvl('||'sum( nvl('||
         'decode ('|| '''' || calc_type || '''' ||','
         ||
         ''''|| 'L'|| ''''
         ||
         ',nvl(i1.iit_end_chain,i1.iit_st_chain)-i1.iit_st_chain,'
         ||
         ''''|| 'A'|| ''''
         ||
         ',nvl(i1.iit_width,0) * nvl(i1.iit_height,0),'
         ||
         ''''|| 'N'|| ''''||',1,'
         ||
         ''''|| 'T'||''''
         ||
       ',(nvl(i1.iit_width,0)+ decode(nvl(i2.iit_width,0),0,nvl(i1.iit_width,0)
             ,i2.iit_width) )*0.5* (i1.iit_end_chain - i1.iit_st_chain)),0 ) * '
         ||'r1.rel_factor'||
         '),0 ) from inv_items_all i1, inv_items_all i2, road_segments_all,
             related_inventory r1 WHERE rse_he_id = '
         || TO_CHAR(he_id)
         ||
         ' and i1.iit_ity_inv_code     = r1.rel_ity_inv_code
	   AND i1.iit_ity_sys_flag     = r1.rel_ity_sys_flag
                AND i1.iit_rse_he_id        = '
         || TO_CHAR(he_id)
         ||
         ' and r1.rel_sta_item_code    = '
         ||
         ''''|| item_code || ''''
         ||
         ' and ' || '''' || SYSDATE || '''' ||
               ' between i1.iit_cre_date and nvl(i1.iit_end_date, sysdate) '
         ||
         ' and ' || '''' || SYSDATE || '''' ||
               ' between rse_start_date and nvl(rse_end_date,sysdate) '
         ||
         ' and ' || '''' || SYSDATE || '''' ||
               ' between i2.iit_cre_date(+) and  nvl(i2.iit_end_date(+), sysdate) '
         ||
         ' and i1.iit_ity_sys_flag     = rse_sys_flag
               AND i2.iit_rse_he_id(+)     = '
         || TO_CHAR(he_id)
         ||
         ' and i2.iit_ity_inv_code (+) = i1.iit_ity_inv_code
	   AND i2.iit_ity_sys_flag (+) = i1.iit_ity_sys_flag
               AND i2.iit_st_chain (+)     = i1.iit_end_chain
               AND NVL(i2.iit_x_sect(+),'
         ||
         ''''||'Z'||''''
         ||
         ') = nvl(i1.iit_x_sect,'
         ||
         ''''||'Z'||''''||')'||
       ' and '||DECODE(r2.rel_condition, NULL, '1=1', 'i1.'||r2.rel_condition)||
       ' and '||DECODE(r2.rel_condition, NULL, '1=1', 'i2.'||r2.rel_condition)
         FROM related_inventory r2
         WHERE r2.rel_sta_item_code = item_code;

      l_query VARCHAR2(32767);
      l_cursor_id INTEGER;
      l_status INTEGER;
      lcnt NUMBER;

      BEGIN
      OPEN c1;
      FETCH c1 INTO l_query;
      CLOSE c1;
      higgri.parse_query(l_query,l_cursor_id);   -- parse the query
      DBMS_SQL.DEFINE_COLUMN(l_cursor_id,1,lcnt);   -- define col to return
      l_status := DBMS_SQL.EXECUTE(l_cursor_id);    -- execute query
      LOOP
        IF DBMS_SQL.FETCH_ROWS(l_cursor_id) > 0 THEN  -- fetch back from cursor
          DBMS_SQL.COLUMN_VALUE(l_cursor_id,1,lcnt);    -- assign to variable
        ELSE
          EXIT;
        END IF;
      END LOOP;
      DBMS_SQL.CLOSE_CURSOR(l_cursor_id);           -- close cursor
      quantity := lcnt;           -- pass calculated value back
      END;

PROCEDURE calculate_inv_quantity_assets
        (p_schd_id    IN     schedules.schd_id%TYPE,
         he_id        IN     road_segments_all.rse_he_id%TYPE ,
         calc_type    IN     standard_items.sta_calc_type%TYPE,
         item_code    IN     schedule_items.schi_sta_item_code%TYPE,
         item_id      IN OUT inv_items_all.iit_item_id%TYPE,
         quantity     IN OUT schedule_items.schi_calc_quantity%TYPE)
  IS
      CURSOR c1 IS
      SELECT
         'select iit_item_id,count(*) '||
         'from   inv_items_all        '||
         '      ,road_segments_all    '||
         '      ,related_inventory r1 '||
         ' where rse_he_id         =     '||TO_CHAR(he_id)||' '||
         ' and iit_ity_inv_code = r1.rel_ity_inv_code '||
	   ' and iit_ity_sys_flag = r1.rel_ity_sys_flag '||
         ' and iit_rse_he_id    = '||TO_CHAR(he_id)||
         ' and r1.rel_sta_item_code= '||''''||item_code||''''||
         ' and '|| '''' ||SYSDATE|| '''' ||' between iit_cre_date and nvl(iit_end_date, sysdate) '||
         ' and '|| '''' ||SYSDATE|| '''' ||' between rse_start_date and nvl(rse_end_date,sysdate) '||
         ' and iit_ity_sys_flag     = rse_sys_flag '||
         ' and '||r2.rel_condition||
         ' group by iit_item_id'
         FROM related_inventory r2
         WHERE r2.rel_sta_item_code = item_code;
      l_query     VARCHAR2(32767);
      l_cursor_id INTEGER;
      l_status    INTEGER;
      lcnt        NUMBER;
      lid         NUMBER;
   BEGIN
      OPEN  c1;
      FETCH c1 INTO l_query;
      CLOSE c1;
	-- insert into m_query values (l_query); commit;
      higgri.parse_query(l_query,l_cursor_id);          -- parse the query
	DBMS_SQL.DEFINE_COLUMN(l_cursor_id,1,lid);        -- define col to return
      DBMS_SQL.DEFINE_COLUMN(l_cursor_id,2,lcnt);       -- define col to return
      l_status := DBMS_SQL.EXECUTE(l_cursor_id);        -- execute query
      LOOP
        IF DBMS_SQL.FETCH_ROWS(l_cursor_id) > 0
		THEN DBMS_SQL.COLUMN_VALUE(l_cursor_id,1,lid);  -- assign to variable
		     DBMS_SQL.COLUMN_VALUE(l_cursor_id,2,lcnt); -- assign to variable
        --
          IF lcnt>0
          THEN
            INSERT INTO schedule_roads
            ( schr_schd_id
            , schr_sta_item_code
            , schr_rse_he_id
            , schr_calc_quantity
            , schr_act_quantity
            , schr_last_updated
            , schr_iit_item_id )
            VALUES
           ( p_schd_id
            , item_code
            , he_id
            , lcnt
            , 0
            , SYSDATE
            , lid);
          END IF;
        --
        ELSE EXIT;
        END IF;
      END LOOP;
      DBMS_SQL.CLOSE_CURSOR(l_cursor_id);  -- close cursor
      quantity := NVL(lcnt,0);             -- pass calculated value back
      item_id  := NVL(lid,0);              -- pass the asset id's back
   END;


PROCEDURE rep_date_due (
           p_date               IN DATE
          ,p_atv_acty_area_code IN defect_priorities.dpr_atv_acty_area_code%TYPE
          ,p_dpr_priority       IN defect_priorities.dpr_priority%TYPE
          ,p_dpr_action_cat     IN defect_priorities.dpr_action_cat%TYPE
          ,p_heid               IN road_segments_all.rse_he_id%TYPE
          ,p_out_date           OUT DATE
          ,p_error              OUT NUMBER) IS

 CURSOR c_int_code IS
    SELECT dpr_int_code
          ,dpr_use_working_days
          ,dpr_use_next_insp
    FROM   defect_priorities
    WHERE  dpr_atv_acty_area_code = p_atv_acty_area_code
    AND    dpr_priority           = p_dpr_priority
    AND    dpr_action_cat         = p_dpr_action_cat;
 --
 CURSOR get_rse_int_code IS
    SELECT  rse.rse_int_code
    FROM    road_segments_all rse
           ,intervals         INT
    WHERE   rse.rse_int_code      = INT.int_code
    AND     rse.rse_he_id         = p_heid
    AND     p_date
    BETWEEN NVL(INT.int_start_date,p_date)
    AND     NVL(INT.int_end_date,p_date);
 --
    l_int_code               defect_priorities.dpr_int_code%TYPE;
    l_use_working_days       defect_priorities.dpr_use_working_days%TYPE;
    l_use_next_insp          defect_priorities.dpr_use_next_insp%TYPE;
 --
    v_error    NUMBER:=0;
 --
 BEGIN
    l_use_working_days:='N'; -- Initialize Use Working Days
    l_use_next_insp:='N';    -- Initialize Use Next Inspection
 --
    OPEN  c_int_code;
    FETCH c_int_code INTO l_int_code
                         ,l_use_working_days
                         ,l_use_next_insp;
--
    IF  c_int_code%NOTFOUND
    THEN v_error:=8509;
    END IF;
 --
    CLOSE c_int_code;
 --
 -- The inspection interval can be obtained from the defect_prriorities
 -- table OR form the road_segs table for the specified sectioin.
 -- The flag dpr_use_next_insp should be obtained from the defect_
 -- priorities table and if the flag is 'Y' then the interval code to
 -- be used should be obtained from the road_segs table otherwise the
 -- default interval code from the defect_priorities table should be
 -- used.
 --
    IF v_error = 0 THEN
    IF l_use_next_insp = 'Y'
    THEN -- obtain the interval code from the road_segs table for the
         -- selected section.
         -- the intervals table is used in the query so that a check
         -- for existance is made against the interval code since
         -- the interval code may be null.
         OPEN get_rse_int_code;
         FETCH get_rse_int_code INTO l_int_code;
         IF get_rse_int_code%NOTFOUND
         THEN v_error:=8213;             -- Unable to obtain interval code
         END IF;
         CLOSE get_rse_int_code;
    END IF;
 --
    IF l_use_working_days = 'Y'
    THEN p_out_date:=hig.date_due(p_date,l_int_code,TRUE);
    ELSE p_out_date:=hig.date_due(p_date,l_int_code,FALSE);
    END IF;
	p_error := v_error;
  ELSE

-- Invalid interval - no need to try and find date due.

	p_error := v_error;
  END IF;
END;

----------------------------------------------------------------------------
-- Start of functions and procedures required for inventory view creattion
-- via mai1400
--
FUNCTION view_exists ( inv_view_name IN inv_item_types.ity_view_name%TYPE )
RETURN BOOLEAN
IS
      CURSOR user_view_exists
      IS SELECT 1
         FROM    all_objects
         WHERE   object_name = inv_view_name
         AND     object_type = 'VIEW'
         AND     status      = 'VALID';
--
v_exists INTEGER;
--
BEGIN
     OPEN user_view_exists;
     FETCH user_view_exists INTO v_exists;
     IF user_view_exists%FOUND
     THEN   CLOSE user_view_exists;
            RETURN TRUE;
     ELSE   CLOSE user_view_exists;
            RETURN FALSE;
     END IF;
END view_exists;
--
-- Check if the existing view is in use within the database.
--
FUNCTION view_in_use ( view_name IN inv_item_types.ity_view_name%TYPE )
RETURN BOOLEAN
IS
   exclusive_mode INTEGER:=6;
   ID             INTEGER:=100;
   --
   CURSOR in_use -- Dummy cursor for the present.
   IS SELECT 1
      FROM dual;
   --
   v_in_use INTEGER;
   --
BEGIN
     OPEN in_use;
     FETCH in_use INTO v_in_use;
     IF in_use%FOUND
     THEN CLOSE in_use;
            RETURN FALSE; -- Reversed logic so that function
     ELSE CLOSE in_use;   -- does not fail.
            RETURN TRUE;
     END IF;
END view_in_use;
--
--
-- When called, this procedure should perform the actual creation of the
-- specified inventory view. A return code should be provided if there were any -- problems when creating the view object. ( Such as insufficient privelages ).
--
FUNCTION synonym_exists( p_SYNONYM IN inv_item_types.ity_view_name%TYPE )
RETURN BOOLEAN
IS
    CURSOR syn_exists
    IS SELECT 1
       FROM   all_synonyms
       WHERE  synonym_name= p_SYNONYM
       AND    owner       = 'PUBLIC';
--
v_exists INTEGER;
--
BEGIN
    OPEN  syn_exists;
    FETCH syn_exists INTO v_exists;
    IF syn_exists%FOUND
    THEN  CLOSE syn_exists;
          RETURN TRUE;
    ELSE  CLOSE syn_exists;
          RETURN FALSE;
    END IF;
END synonym_exists;
--
PROCEDURE create_view ( view_name      IN inv_item_types.ity_view_name%TYPE
                       ,inventory_type IN inv_item_types.ity_inv_code%TYPE
                       ,sys_flag       IN inv_item_types.ity_sys_flag%TYPE)IS
       --
       v_stg          VARCHAR2(2000) := 'Create or Replace view '||view_name||
                                        ' as select /* INDEX (INV_ITEMS_ALL IIT_INDEX_P2) */';
       lc_from        VARCHAR2(2000);
       s_stg          VARCHAR2(2000);
       v_query        INTEGER;
       exec_ok        INTEGER;
       l_p_or_c       inv_item_types.ity_pnt_or_cont%TYPE;
       incl_road_segs inv_item_types.ity_incl_road_segs%TYPE;

       TYPE view_attribs IS RECORD
      (ita_attrib_name   VARCHAR2(30),
       ita_view_col_name VARCHAR2(30));
      --
      TYPE view_attribs_table IS TABLE OF view_attribs
      INDEX BY BINARY_INTEGER;

      view_attribs_tab view_attribs_table;

       --
       -- get type of inventory item so end-chain can be included/excluded
       --
       CURSOR get_p_or_c IS
          SELECT ity_pnt_or_cont,
                 ity_incl_road_segs
          FROM inv_item_types
          WHERE ity_inv_code = inventory_type
          AND ity_sys_flag = sys_flag ;
       --
       -- Obtain all specified inventory columns for the selected inventory
       -- type.
       --
       CURSOR all_attributes
       IS SELECT ita_attrib_name
                    ,ita_view_col_name
                    ,ita_dtp_code
          FROM     inv_type_attribs
          WHERE    ita_iit_inv_code = inventory_type
          AND      ita_ity_sys_flag = sys_flag
          ORDER BY ita_disp_seq_no;
       --
       CURSOR top_user
	 IS SELECT table_owner
	    FROM dba_synonyms
	    WHERE synonym_name = 'HIG_OPTIONS'
	    AND owner = USER;
	 --
   l_top_user dba_synonyms.table_owner%TYPE;
   invalid_item_type EXCEPTION;
   ln_array_count    NUMBER;
   --
   FUNCTION in_view_col_list (ita_attrib_name VARCHAR2,
                              ita_view_col_name VARCHAR2) RETURN BOOLEAN IS
     ln_return_value BOOLEAN := FALSE;
   BEGIN
     FOR i IN 1..view_attribs_tab.COUNT LOOP
       IF UPPER(NVL(ita_view_col_name,ita_attrib_name)) = UPPER(NVL(view_attribs_tab(i).ita_view_col_name,view_attribs_tab(i).ita_attrib_name)) THEN
         ln_return_value := TRUE;
         EXIT;
       END IF;
     END LOOP;
     --
     RETURN ln_return_value;
   END;
   --
BEGIN
   --
   DBMS_OUTPUT.ENABLE (1000000);
   --
   view_attribs_tab.DELETE;
   --
   OPEN get_p_or_c;
   FETCH get_p_or_c INTO l_p_or_c,incl_road_segs;
   IF get_p_or_c%NOTFOUND THEN
      CLOSE get_p_or_c;
      RAISE invalid_item_type;
   ELSE
      CLOSE get_p_or_c;
      IF l_p_or_c = 'P' THEN

         view_attribs_tab(1).ita_attrib_name   := 'iit_created_date';
         view_attribs_tab(1).ita_view_col_name := '';
         view_attribs_tab(2).ita_attrib_name   := 'iit_cre_date';
         view_attribs_tab(2).ita_view_col_name := '';
         view_attribs_tab(3).ita_attrib_name   := 'iit_item_id';
         view_attribs_tab(3).ita_view_col_name := '';
         view_attribs_tab(4).ita_attrib_name   := 'iit_ity_inv_code';
         view_attribs_tab(4).ita_view_col_name := '';
         view_attribs_tab(5).ita_attrib_name   := 'iit_ity_sys_flag';
         view_attribs_tab(5).ita_view_col_name := '';
         view_attribs_tab(6).ita_attrib_name   := 'iit_last_updated_date';
         view_attribs_tab(6).ita_view_col_name := '';
         view_attribs_tab(7).ita_attrib_name   := 'iit_description';
         view_attribs_tab(7).ita_view_col_name := '';
         view_attribs_tab(8).ita_attrib_name   := 'iit_rse_he_id';
         view_attribs_tab(8).ita_view_col_name := '';
         view_attribs_tab(9).ita_attrib_name   := 'iit_st_chain';
         view_attribs_tab(9).ita_view_col_name := '';
         view_attribs_tab(10).ita_attrib_name   := 'iit_x_sect';
         view_attribs_tab(10).ita_view_col_name := '';
         view_attribs_tab(11).ita_attrib_name   := 'iit_width';
         view_attribs_tab(11).ita_view_col_name := '';
         view_attribs_tab(12).ita_attrib_name   := 'iit_end_date';
         view_attribs_tab(12).ita_view_col_name := '';
         --
       ELSE
         view_attribs_tab(1).ita_attrib_name   := 'iit_created_date';
         view_attribs_tab(1).ita_view_col_name := '';
         view_attribs_tab(2).ita_attrib_name   := 'iit_cre_date';
         view_attribs_tab(2).ita_view_col_name := '';
         view_attribs_tab(3).ita_attrib_name   := 'iit_item_id';
         view_attribs_tab(3).ita_view_col_name := '';
         view_attribs_tab(4).ita_attrib_name   := 'iit_ity_inv_code';
         view_attribs_tab(4).ita_view_col_name := '';
         view_attribs_tab(5).ita_attrib_name   := 'iit_ity_sys_flag';
         view_attribs_tab(5).ita_view_col_name := '';
         view_attribs_tab(6).ita_attrib_name   := 'iit_last_updated_date';
         view_attribs_tab(6).ita_view_col_name := '';
         view_attribs_tab(7).ita_attrib_name   := 'iit_description';
         view_attribs_tab(7).ita_view_col_name := '';
         view_attribs_tab(8).ita_attrib_name   := 'iit_rse_he_id';
         view_attribs_tab(8).ita_view_col_name := '';
         view_attribs_tab(9).ita_attrib_name   := 'iit_st_chain';
         view_attribs_tab(9).ita_view_col_name := '';
         view_attribs_tab(10).ita_attrib_name   := 'iit_end_chain';
         view_attribs_tab(10).ita_view_col_name := '';
         view_attribs_tab(11).ita_attrib_name   := 'iit_x_sect';
         view_attribs_tab(11).ita_view_col_name := '';
         view_attribs_tab(12).ita_attrib_name   := 'iit_width';
         view_attribs_tab(12).ita_view_col_name := '';
         view_attribs_tab(13).ita_attrib_name   := 'iit_end_date';
         view_attribs_tab(13).ita_view_col_name := '';
       END IF;
       --

--
          FOR each_attribute IN all_attributes
          LOOP
            IF NOT in_view_col_list(each_attribute.ita_attrib_name,each_attribute.ita_view_col_name) THEN
              ln_array_count := view_attribs_tab.COUNT +1;
              view_attribs_tab(ln_array_count).ita_attrib_name   := each_attribute.ita_attrib_name;
              view_attribs_tab(ln_array_count).ita_view_col_name := each_attribute.ita_view_col_name;
            END IF;
          END LOOP;
          --
          IF incl_road_segs = 'Y' THEN
            ln_array_count := view_attribs_tab.COUNT +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_LENGTH_STATUS';
            view_attribs_tab(ln_array_count).ita_view_col_name := 'SEC_LEN_STAT';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_UNIQUE';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_DESCR';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_LENGTH';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_ROAD_ENVIRONMENT';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_END_DATE';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            ln_array_count := ln_array_count +1;
            view_attribs_tab(ln_array_count).ita_attrib_name   := 'RSE_ADMIN_UNIT';
            view_attribs_tab(ln_array_count).ita_view_col_name := '';
            lc_from := ' from inv_items_all, road_sections_all where iit_rse_he_id = rse_he_id and iit_ity_inv_code='||''''
                       ||inventory_type||''''||' and
                       iit_ity_sys_flag='||''''||sys_flag||'''';
          ELSE
            lc_from := ' from inv_items_all where iit_ity_inv_code='||''''
                        ||inventory_type||''''||' and
                          iit_ity_sys_flag='||''''||sys_flag||'''';
          END IF;
          --
          v_query:=DBMS_SQL.OPEN_CURSOR;
          FOR i IN 1..view_attribs_tab.COUNT LOOP
            v_stg := v_stg||' '||view_attribs_tab(i).ita_attrib_name||' '||view_attribs_tab(i).ita_view_col_name;
            IF i <> view_attribs_tab.COUNT THEN
              v_stg := v_stg||',';
            END IF;
          END LOOP;
          v_stg := v_stg||' '||lc_from;
          DBMS_SQL.PARSE(v_query,v_stg,dbms_sql.v7);
          exec_ok:=DBMS_SQL.EXECUTE(v_query);
          DBMS_SQL.CLOSE_CURSOR(v_query);
          --
          IF hig.get_sysopt('HIGPUBSYN') = 'Y'
          THEN   --
               IF synonym_exists(view_name)
               THEN s_stg:='drop public synonym '||view_name;
                    --
                    v_query:=DBMS_SQL.OPEN_CURSOR;
                    DBMS_SQL.PARSE(v_query,s_stg,dbms_sql.v7);
                    exec_ok:=DBMS_SQL.EXECUTE(v_query);
                    DBMS_SQL.CLOSE_CURSOR(v_query);
                    --
               END IF;
               --
               -- Create the public synonym for the previouslry created view.
               --
		   OPEN top_user;
		   FETCH top_user INTO l_top_user;
		   IF top_user%NOTFOUND THEN
		     CLOSE top_user;
		     l_top_user := USER;
		   ELSE
		     CLOSE top_user;
               END IF;
               --
               s_stg:='create public synonym '||
                       view_name||
                      ' for '||l_top_user||'.'||view_name;
               --
               v_query:=DBMS_SQL.OPEN_CURSOR;
               DBMS_SQL.PARSE(v_query,s_stg,dbms_sql.v7);
               exec_ok:=DBMS_SQL.EXECUTE(v_query);
               DBMS_SQL.CLOSE_CURSOR(v_query);
               --
          END IF;
  END IF;
          --
EXCEPTION
  WHEN invalid_item_type THEN
     RAISE_APPLICATION_ERROR( -20001, 'Invalid Item Type - View cannot be created');
END create_view;
--
PROCEDURE create_inv_view (  view_name     IN inv_item_types.ity_view_name%TYPE
                            ,inventory_type IN inv_item_types.ity_inv_code%TYPE
                            ,sys_flag       IN inv_item_types.ity_sys_flag%TYPE)
IS
  specified_view_in_use EXCEPTION;
  PRAGMA EXCEPTION_INIT (specified_view_in_use,-20002);
BEGIN
    --
    -- Logic : If the specified view doew NOT exist
    --         then Create the specified view.
    --         else If the view is In-Use
    --         then return and error indicating usage
    --         else Create the view.
    --
    IF NOT view_exists(view_name)
    THEN   create_view(view_name,inventory_type,sys_flag);
    ELSIF  view_in_use(view_name)
    THEN   RAISE_APPLICATION_ERROR( -20002,'Specified_View_In_Use');
    ELSE   create_view(view_name,inventory_type,sys_flag);
    END IF;
  EXCEPTION
  WHEN OTHERS
  THEN
     RAISE_APPLICATION_ERROR( -20002, SQLERRM );
END create_inv_view;


-------------------------------------------------------------------------------
--
-- Start off functions and procedures used in mai3899, the manual inspection
-- entry screen
--

FUNCTION activities_report_id( p_rse_he_id		IN road_segs.rse_he_id%TYPE
					,p_maint_insp_flag	IN activities_report.are_maint_insp_flag%TYPE
					,p_date_work_done		IN activities_report.are_date_work_done%TYPE
					,p_initiation_type	IN activities_report.are_initiation_type%TYPE
					,p_person_id_actioned	IN activities_report.are_peo_person_id_actioned%TYPE
					,p_person_id_insp2	IN activities_report.are_peo_person_id_insp2%TYPE
					,p_surface			IN activities_report.are_surface_condition%TYPE
					,p_weather			IN activities_report.are_weather_condition%TYPE
					,p_acty_area_code		IN activities.atv_acty_area_code%TYPE
					,p_start_chain		IN activities_report.are_st_chain%TYPE
					,p_end_chain		IN activities_report.are_end_chain%TYPE
) RETURN NUMBER IS

  l_report_id	activities_report.are_report_id%TYPE;
  l_rse_length	road_segs.rse_length%TYPE;
  l_today		DATE := SYSDATE;
  insert_error	EXCEPTION;

  CURSOR c1 IS
    SELECT rse_length
    FROM   road_segs
    WHERE  rse_he_id = p_rse_he_id;

BEGIN

  SELECT are_report_id_seq.NEXTVAL
  INTO   l_report_id
  FROM   dual;

  OPEN c1;
  FETCH c1 INTO l_rse_length;
  CLOSE c1;

  INSERT INTO activities_report (
			 are_report_id
			,are_rse_he_id
			,are_batch_id
			,are_created_date
			,are_last_updated_date
			,are_maint_insp_flag
			,are_sched_act_flag
			,are_date_work_done
			,are_end_chain
			,are_initiation_type
			,are_insp_load_date
			,are_peo_person_id_actioned
			,are_peo_person_id_insp2
			,are_st_chain
			,are_surface_condition
			,are_weather_condition
			,are_wol_works_order_no)
  VALUES (
			 l_report_id
			,p_rse_he_id
			,''
			,l_today
			,l_today
			,p_maint_insp_flag
			,'Y'
			,p_date_work_done
			,NVL(p_end_chain,l_rse_length)
			,p_initiation_type
			,''
			,p_person_id_actioned
			,p_person_id_insp2
			,NVL(p_start_chain,0)
			,p_surface
			,p_weather
			,'');

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  INSERT INTO act_report_lines (
			 arl_act_status
			,arl_are_report_id
			,arl_atv_acty_area_code
			,arl_created_date
			,arl_last_updated_date
			,arl_not_seq_flag
			,arl_report_id_part_of)
  VALUES (
			 'C'
			,l_report_id
			,p_acty_area_code
			,l_today
			,l_today
			,''
			,'');

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN l_report_id;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Activities Report');

END;

FUNCTION activities_report_id( p_rse_he_id		IN road_segs.rse_he_id%TYPE
					,p_maint_insp_flag	IN activities_report.are_maint_insp_flag%TYPE
					,p_date_work_done		IN activities_report.are_date_work_done%TYPE
					,p_initiation_type	IN activities_report.are_initiation_type%TYPE
					,p_person_id_actioned	IN activities_report.are_peo_person_id_actioned%TYPE
					,p_person_id_insp2	IN activities_report.are_peo_person_id_insp2%TYPE
					,p_surface			IN activities_report.are_surface_condition%TYPE
					,p_weather			IN activities_report.are_weather_condition%TYPE
					,p_acty_area_code		IN activities.atv_acty_area_code%TYPE
					,p_start_chain		IN activities_report.are_st_chain%TYPE
					,p_end_chain		IN activities_report.are_end_chain%TYPE
					,p_created_date         IN activities_report.are_created_date%TYPE
) RETURN NUMBER IS

  l_report_id	activities_report.are_report_id%TYPE;
  l_rse_length	road_segs.rse_length%TYPE;
  l_today		DATE := SYSDATE;
  insert_error	EXCEPTION;

  CURSOR c1 IS
    SELECT rse_length
    FROM   road_segs
    WHERE  rse_he_id = p_rse_he_id;

BEGIN

  SELECT are_report_id_seq.NEXTVAL
  INTO   l_report_id
  FROM   dual;

  OPEN c1;
  FETCH c1 INTO l_rse_length;
  CLOSE c1;

  INSERT INTO activities_report (
			 are_report_id
			,are_rse_he_id
			,are_batch_id
			,are_created_date
			,are_last_updated_date
			,are_maint_insp_flag
			,are_sched_act_flag
			,are_date_work_done
			,are_end_chain
			,are_initiation_type
			,are_insp_load_date
			,are_peo_person_id_actioned
			,are_peo_person_id_insp2
			,are_st_chain
			,are_surface_condition
			,are_weather_condition
			,are_wol_works_order_no)
  VALUES (
			 l_report_id
			,p_rse_he_id
			,''
			,p_created_date
			,p_created_date
			,p_maint_insp_flag
			,'Y'
			,p_date_work_done
			,NVL(p_end_chain,l_rse_length)
			,p_initiation_type
			,''
			,p_person_id_actioned
			,p_person_id_insp2
			,NVL(p_start_chain,0)
			,p_surface
			,p_weather
			,'');

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  INSERT INTO act_report_lines (
			 arl_act_status
			,arl_are_report_id
			,arl_atv_acty_area_code
			,arl_created_date
			,arl_last_updated_date
			,arl_not_seq_flag
			,arl_report_id_part_of)
  VALUES (
			 'C'
			,l_report_id
			,p_acty_area_code
			,l_today
			,l_today
			,''
			,'');

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN l_report_id;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Activities Report');

END;

PROCEDURE get_activities_report(pi_report_rec IN OUT activities_report%ROWTYPE) IS
  --
  CURSOR get_report(cp_are_report_id activities_report.are_report_id%TYPE)
      IS
  SELECT *
    FROM activities_report
   WHERE are_report_id = cp_are_report_id
       ;
  -- 
BEGIN
  --
  OPEN  get_report(pi_report_rec.are_report_id);
  FETCH get_report
   INTO pi_report_rec;
  CLOSE get_report;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR(-20001,'Error : '||SQLCODE||' : '||SQLERRM);
END;

FUNCTION create_activities_report(pr_are_rec IN activities_report%ROWTYPE) RETURN NUMBER IS
  --
  lv_report_id	activities_report.are_report_id%TYPE;
  lv_rse_length	road_segs.rse_length%TYPE;
  lv_today		DATE := SYSDATE;
  insert_error	EXCEPTION;
  --
  CURSOR c1 (cp_he_id road_segs.rse_he_id%TYPE)
      IS
  SELECT rse_length
    FROM road_segs
   WHERE rse_he_id = cp_he_id;
  --
BEGIN
  --
  nm_debug.debug_on;
  nm_debug.debug('mai_act.create_activities_report');
  --
  OPEN  c1(pr_are_rec.are_rse_he_id);
  FETCH c1
   INTO lv_rse_length;
  CLOSE c1;
  --
  nm_debug.debug('rse_length = '||to_char(lv_rse_length));
  --
  SELECT are_report_id_seq.NEXTVAL
  INTO   lv_report_id
  FROM   dual;
  --
  nm_debug.debug('report_id = '||to_char(lv_report_id));
  --
  INSERT
    INTO activities_report
        (are_report_id
        ,are_rse_he_id
        ,are_batch_id
        ,are_created_date
        ,are_last_updated_date
        ,are_maint_insp_flag
        ,are_sched_act_flag
        ,are_date_work_done
        ,are_end_chain
        ,are_initiation_type
        ,are_insp_load_date
        ,are_peo_person_id_actioned
        ,are_peo_person_id_insp2
        ,are_st_chain
        ,are_surface_condition
        ,are_weather_condition
        ,are_wol_works_order_no)
  VALUES(lv_report_id
        ,pr_are_rec.are_rse_he_id
        ,pr_are_rec.are_batch_id
        ,NVL(pr_are_rec.are_created_date,lv_today)
        ,NVL(pr_are_rec.are_last_updated_date,lv_today)
        ,pr_are_rec.are_maint_insp_flag
        ,NVL(pr_are_rec.are_sched_act_flag,'Y')
        ,pr_are_rec.are_date_work_done
        ,NVL(pr_are_rec.are_end_chain,lv_rse_length)
        ,pr_are_rec.are_initiation_type
        ,pr_are_rec.are_insp_load_date
        ,pr_are_rec.are_peo_person_id_actioned
        ,pr_are_rec.are_peo_person_id_insp2
        ,NVL(pr_are_rec.are_st_chain,0)
        ,pr_are_rec.are_surface_condition
        ,pr_are_rec.are_weather_condition
        ,pr_are_rec.are_wol_works_order_no);
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
  --
  nm_debug.debug('rowcount = '||to_char(SQL%rowcount));
  --
  nm_debug.debug_off;
  --
  RETURN lv_report_id;
  --
EXCEPTION
  WHEN insert_error
   THEN
      RAISE_APPLICATION_ERROR(-20001, 'Error Occured While Creating Inspection');
  WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR(-20002, 'Error : '||SQLCODE||' : '||SQLERRM);
END;

PROCEDURE create_act_report_lines(pr_arl_rec IN act_report_lines%ROWTYPE) IS
  --
  lv_today		DATE := SYSDATE;
  insert_error	EXCEPTION;
  --
BEGIN
  --
  INSERT
    INTO act_report_lines
	    (arl_act_status
        ,arl_are_report_id
        ,arl_atv_acty_area_code
        ,arl_created_date
        ,arl_last_updated_date
        ,arl_not_seq_flag
        ,arl_report_id_part_of)
  VALUES(NVL(pr_arl_rec.arl_act_status,'C')
        ,pr_arl_rec.arl_are_report_id
        ,pr_arl_rec.arl_atv_acty_area_code
        ,NVL(pr_arl_rec.arl_created_date,lv_today)
        ,NVL(pr_arl_rec.arl_last_updated_date,lv_today)
        ,pr_arl_rec.arl_not_seq_flag
        ,pr_arl_rec.arl_report_id_part_of);
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
  --
EXCEPTION
  WHEN insert_error
   THEN
      RAISE_APPLICATION_ERROR(-20001, 'Error Occured While Creating Inspection Line');
  WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR(-20002, 'Error : '||SQLCODE||' : '||SQLERRM);
END;

PROCEDURE delete_activities_report(p_report_id IN activities_report.are_report_id%TYPE) IS
BEGIN

  DELETE FROM act_report_lines
  WHERE  arl_are_report_id = p_report_id;

  DELETE FROM activities_report
  WHERE  are_report_id= p_report_id;

END;


PROCEDURE delete_are_defects(p_report_id IN activities_report.are_report_id%TYPE) IS
BEGIN

  DELETE FROM boq_items
  WHERE  boq_defect_id IN (SELECT def_defect_id
				   FROM   defects
				   WHERE  def_are_report_id = p_report_id);

  DELETE FROM repairs
  WHERE  rep_def_defect_id IN (SELECT def_defect_id
					 FROM   defects
					 WHERE  def_are_report_id = p_report_id);

  DELETE FROM defects
  WHERE  def_are_report_id = p_report_id;

END;

-------------------------------------------------------------------------------

FUNCTION create_defect(
		p_rse_he_id				IN	defects.def_rse_he_id%TYPE
		,p_iit_item_id			IN	defects.def_iit_item_id%TYPE
		,p_st_chain				IN	defects.def_st_chain%TYPE
		,p_report_id			IN	defects.def_are_report_id%TYPE
		,p_acty_area_code			IN	defects.def_atv_acty_area_code%TYPE
		,p_siss_id				IN	defects.def_siss_id%TYPE
		,p_works_order_no			IN	defects.def_works_order_no%TYPE
		,p_defect_code			IN	defects.def_defect_code%TYPE
		,p_orig_priority			IN	defects.def_orig_priority%TYPE
		,p_priority				IN	defects.def_priority%TYPE
		,p_status_code			IN	defects.def_status_code%TYPE
		,p_area				IN	defects.def_area%TYPE
		,p_are_id_not_found		IN	defects.def_are_id_not_found%TYPE
		,p_coord_flag			IN	defects.def_coord_flag%TYPE
		,p_defect_class			IN	defects.def_defect_class%TYPE
		,p_defect_descr			IN	defects.def_defect_descr%TYPE
		,p_defect_type_descr		IN	defects.def_defect_type_descr%TYPE
		,p_diagram_no			IN	defects.def_diagram_no%TYPE
		,p_height				IN	defects.def_height%TYPE
		,p_ident_code			IN	defects.def_ident_code%TYPE
		,p_ity_inv_code			IN	defects.def_ity_inv_code%TYPE
		,p_ity_sys_flag			IN	defects.def_ity_sys_flag%TYPE
		,p_length				IN	defects.def_length%TYPE
		,p_locn_descr			IN	defects.def_locn_descr%TYPE
		,p_maint_wo				IN	defects.def_maint_wo%TYPE
		,p_mand_adv				IN	defects.def_mand_adv%TYPE
		,p_notify_org_id			IN	defects.def_notify_org_id%TYPE
		,p_number				IN	defects.def_number%TYPE
		,p_per_cent				IN	defects.def_per_cent%TYPE
		,p_per_cent_orig			IN	defects.def_per_cent_orig%TYPE
		,p_per_cent_rem			IN	defects.def_per_cent_rem%TYPE
		,p_rechar_org_id			IN	defects.def_rechar_org_id%TYPE
		,p_serial_no			IN	defects.def_serial_no%TYPE
		,p_skid_coeff			IN	defects.def_skid_coeff%TYPE
		,p_special_instr			IN	defects.def_special_instr%TYPE
		,p_time_hrs				IN	defects.def_time_hrs%TYPE
		,p_time_mins			IN	defects.def_time_mins%TYPE
		,p_update_inv			IN	defects.def_update_inv%TYPE
		,p_x_sect				IN	defects.def_x_sect%TYPE
            ,p_easting				IN	defects.def_easting%TYPE
		,p_northing				IN	defects.def_northing%TYPE
		,p_response_category		IN	defects.def_response_category%TYPE
) RETURN NUMBER IS

  l_defect_id	defects.def_defect_id%TYPE;
  l_today		DATE := SYSDATE;
  insert_error	EXCEPTION;

BEGIN

  SELECT def_defect_id_seq.NEXTVAL
  INTO   l_defect_id
  FROM   dual;

  INSERT INTO defects (
		def_defect_id
		,def_rse_he_id
	      ,def_iit_item_id             ----- New
		,def_st_chain
		,def_are_report_id
		,def_atv_acty_area_code
		,def_siss_id
		,def_works_order_no
		,def_created_date
		,def_defect_code
		,def_last_updated_date
		,def_orig_priority
		,def_priority
		,def_status_code
		,def_superseded_flag
		,def_area
		,def_are_id_not_found
		,def_coord_flag
		,def_date_compl
		,def_date_not_found
		,def_defect_class
		,def_defect_descr
		,def_defect_type_descr
		,def_diagram_no
		,def_height
		,def_ident_code
		,def_ity_inv_code
		,def_ity_sys_flag
		,def_length
		,def_locn_descr
		,def_maint_wo
		,def_mand_adv
		,def_notify_org_id
		,def_number
		,def_per_cent
		,def_per_cent_orig
		,def_per_cent_rem
		,def_rechar_org_id
		,def_serial_no
		,def_skid_coeff
		,def_special_instr
		,def_superseded_id
		,def_time_hrs
		,def_time_mins
		,def_update_inv
		,def_x_sect
            ,def_easting
            ,def_northing
            ,def_response_category
		)
  VALUES (
		l_defect_id
		,p_rse_he_id
		,p_iit_item_id
		,p_st_chain
		,p_report_id
		,p_acty_area_code
		,p_siss_id
		,p_works_order_no
		,l_today
		,p_defect_code
		,l_today
		,p_orig_priority
		,p_priority
		,p_status_code
		,'N'
		,p_area
		,p_are_id_not_found
		,p_coord_flag
		,''
		,''
		,p_defect_class
		,p_defect_descr
		,p_defect_type_descr
		,p_diagram_no
		,p_height
		,p_ident_code
		,p_ity_inv_code
		,p_ity_sys_flag
		,p_length
		,p_locn_descr
		,p_maint_wo
		,p_mand_adv
		,p_notify_org_id
		,p_number
		,p_per_cent
		,p_per_cent_orig
		,p_per_cent_rem
		,p_rechar_org_id
		,p_serial_no
		,p_skid_coeff
		,p_special_instr
		,''
		,p_time_hrs
		,p_time_mins
		,p_update_inv
		,p_x_sect
            ,p_easting
            ,p_northing
            ,p_response_category
		);

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN l_defect_id;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Defect');

END;

FUNCTION create_defect(
		p_rse_he_id				IN	defects.def_rse_he_id%TYPE
		,p_iit_item_id			IN	defects.def_iit_item_id%TYPE
		,p_st_chain				IN	defects.def_st_chain%TYPE
		,p_report_id			IN	defects.def_are_report_id%TYPE
		,p_acty_area_code			IN	defects.def_atv_acty_area_code%TYPE
		,p_siss_id				IN	defects.def_siss_id%TYPE
		,p_works_order_no			IN	defects.def_works_order_no%TYPE
		,p_defect_code			IN	defects.def_defect_code%TYPE
		,p_orig_priority			IN	defects.def_orig_priority%TYPE
		,p_priority				IN	defects.def_priority%TYPE
		,p_status_code			IN	defects.def_status_code%TYPE
		,p_area				IN	defects.def_area%TYPE
		,p_are_id_not_found		IN	defects.def_are_id_not_found%TYPE
		,p_coord_flag			IN	defects.def_coord_flag%TYPE
		,p_defect_class			IN	defects.def_defect_class%TYPE
		,p_defect_descr			IN	defects.def_defect_descr%TYPE
		,p_defect_type_descr		IN	defects.def_defect_type_descr%TYPE
		,p_diagram_no			IN	defects.def_diagram_no%TYPE
		,p_height				IN	defects.def_height%TYPE
		,p_ident_code			IN	defects.def_ident_code%TYPE
		,p_ity_inv_code			IN	defects.def_ity_inv_code%TYPE
		,p_ity_sys_flag			IN	defects.def_ity_sys_flag%TYPE
		,p_length				IN	defects.def_length%TYPE
		,p_locn_descr			IN	defects.def_locn_descr%TYPE
		,p_maint_wo				IN	defects.def_maint_wo%TYPE
		,p_mand_adv				IN	defects.def_mand_adv%TYPE
		,p_notify_org_id			IN	defects.def_notify_org_id%TYPE
		,p_number				IN	defects.def_number%TYPE
		,p_per_cent				IN	defects.def_per_cent%TYPE
		,p_per_cent_orig			IN	defects.def_per_cent_orig%TYPE
		,p_per_cent_rem			IN	defects.def_per_cent_rem%TYPE
		,p_rechar_org_id			IN	defects.def_rechar_org_id%TYPE
		,p_serial_no			IN	defects.def_serial_no%TYPE
		,p_skid_coeff			IN	defects.def_skid_coeff%TYPE
		,p_special_instr			IN	defects.def_special_instr%TYPE
		,p_time_hrs				IN	defects.def_time_hrs%TYPE
		,p_time_mins			IN	defects.def_time_mins%TYPE
		,p_update_inv			IN	defects.def_update_inv%TYPE
		,p_x_sect				IN	defects.def_x_sect%TYPE
            ,p_easting				IN	defects.def_easting%TYPE
		,p_northing				IN	defects.def_northing%TYPE
		,p_response_category		IN	defects.def_response_category%TYPE
		,p_date_created			in	defects.def_created_date%TYPE
        ,p_def_admin_unit       IN  defects.def_admin_unit%TYPE) RETURN NUMBER IS

  l_defect_id	defects.def_defect_id%TYPE;
  l_today		DATE := SYSDATE;
  insert_error	EXCEPTION;

BEGIN

  SELECT def_defect_id_seq.NEXTVAL
  INTO   l_defect_id
  FROM   dual;

  INSERT INTO defects (
		def_defect_id
		,def_rse_he_id
	      ,def_iit_item_id             ----- New
		,def_st_chain
		,def_are_report_id
		,def_atv_acty_area_code
		,def_siss_id
		,def_works_order_no
		,def_created_date
		,def_defect_code
		,def_last_updated_date
		,def_orig_priority
		,def_priority
		,def_status_code
		,def_superseded_flag
		,def_area
		,def_are_id_not_found
		,def_coord_flag
		,def_date_compl
		,def_date_not_found
		,def_defect_class
		,def_defect_descr
		,def_defect_type_descr
		,def_diagram_no
		,def_height
		,def_ident_code
		,def_ity_inv_code
		,def_ity_sys_flag
		,def_length
		,def_locn_descr
		,def_maint_wo
		,def_mand_adv
		,def_notify_org_id
		,def_number
		,def_per_cent
		,def_per_cent_orig
		,def_per_cent_rem
		,def_rechar_org_id
		,def_serial_no
		,def_skid_coeff
		,def_special_instr
		,def_superseded_id
		,def_time_hrs
		,def_time_mins
		,def_update_inv
		,def_x_sect
            ,def_easting
            ,def_northing
            ,def_response_category
		,def_admin_unit)
  VALUES (
		l_defect_id
		,p_rse_he_id
		,p_iit_item_id
		,p_st_chain
		,p_report_id
		,p_acty_area_code
		,p_siss_id
		,p_works_order_no
		,p_date_created
		,p_defect_code
		,l_today
		,p_orig_priority
		,p_priority
		,p_status_code
		,'N'
		,p_area
		,p_are_id_not_found
		,p_coord_flag
		,''
		,''
		,p_defect_class
		,p_defect_descr
		,p_defect_type_descr
		,p_diagram_no
		,p_height
		,p_ident_code
		,p_ity_inv_code
		,p_ity_sys_flag
		,p_length
		,p_locn_descr
		,p_maint_wo
		,p_mand_adv
		,p_notify_org_id
		,p_number
		,p_per_cent
		,p_per_cent_orig
		,p_per_cent_rem
		,p_rechar_org_id
		,p_serial_no
		,p_skid_coeff
		,p_special_instr
		,''
		,p_time_hrs
		,p_time_mins
		,p_update_inv
		,p_x_sect
            ,p_easting
            ,p_northing
            ,p_response_category
	    ,p_def_admin_unit
		);

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN l_defect_id;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Defect');

END;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(p_defect_rec IN defects%ROWTYPE) RETURN NUMBER IS
BEGIN
  RETURN create_defect(p_rse_he_id         => p_defect_rec.def_rse_he_id
                      ,p_iit_item_id       => p_defect_rec.def_iit_item_id
                      ,p_st_chain          => p_defect_rec.def_st_chain
                      ,p_report_id         => p_defect_rec.def_are_report_id
                      ,p_acty_area_code    => p_defect_rec.def_atv_acty_area_code
                      ,p_siss_id           => p_defect_rec.def_siss_id
                      ,p_works_order_no    => p_defect_rec.def_works_order_no
                      ,p_defect_code       => p_defect_rec.def_defect_code
                      ,p_orig_priority     => p_defect_rec.def_orig_priority
                      ,p_priority          => p_defect_rec.def_priority
                      ,p_status_code       => p_defect_rec.def_status_code
                      ,p_area              => p_defect_rec.def_area
                      ,p_are_id_not_found  => p_defect_rec.def_are_id_not_found
                      ,p_coord_flag        => p_defect_rec.def_coord_flag
                      ,p_defect_class      => p_defect_rec.def_defect_class
                      ,p_defect_descr      => p_defect_rec.def_defect_descr
                      ,p_defect_type_descr => p_defect_rec.def_defect_type_descr
                      ,p_diagram_no        => p_defect_rec.def_diagram_no
                      ,p_height            => p_defect_rec.def_height
                      ,p_ident_code        => p_defect_rec.def_ident_code
                      ,p_ity_inv_code      => p_defect_rec.def_ity_inv_code
                      ,p_ity_sys_flag      => p_defect_rec.def_ity_sys_flag
                      ,p_length            => p_defect_rec.def_length
                      ,p_locn_descr        => p_defect_rec.def_locn_descr
                      ,p_maint_wo          => p_defect_rec.def_maint_wo
                      ,p_mand_adv          => p_defect_rec.def_mand_adv
                      ,p_notify_org_id     => p_defect_rec.def_notify_org_id
                      ,p_number            => p_defect_rec.def_number
                      ,p_per_cent          => p_defect_rec.def_per_cent
                      ,p_per_cent_orig     => p_defect_rec.def_per_cent_orig
                      ,p_per_cent_rem      => p_defect_rec.def_per_cent_rem
                      ,p_rechar_org_id     => p_defect_rec.def_rechar_org_id
                      ,p_serial_no         => p_defect_rec.def_serial_no
                      ,p_skid_coeff        => p_defect_rec.def_skid_coeff
                      ,p_special_instr     => p_defect_rec.def_special_instr
                      ,p_time_hrs          => p_defect_rec.def_time_hrs
                      ,p_time_mins         => p_defect_rec.def_time_mins
                      ,p_update_inv        => p_defect_rec.def_update_inv
                      ,p_x_sect            => p_defect_rec.def_x_sect
                      ,p_easting           => p_defect_rec.def_easting
                      ,p_northing          => p_defect_rec.def_northing
                      ,p_response_category => p_defect_rec.def_response_category
                      ,p_date_created      => p_defect_rec.def_created_date
					  ,p_def_admin_unit    => p_defect_rec.def_admin_unit);
END create_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(pi_insp_rec           IN activities_report%ROWTYPE
                      ,pi_defect_rec         IN defects%ROWTYPE
                      ,pi_repair_tab         IN rep_tab) RETURN NUMBER IS
  --
  lv_repsetperd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERD');
  lv_usedefchnd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHND');
  lv_usetremodd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODD');  				
  lv_repsetperl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERL');
  lv_usedefchnl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHNL');
  lv_usetremodl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODL');  				
  lv_tremodlev    hig_options.hop_value%TYPE := hig.get_sysopt('TREMODLEV');
  lv_insp_id      activities_report.are_report_id%TYPE;
  lv_defect_id    defects.def_defect_id%TYPE;
  lv_action_cat   repairs.rep_action_cat%TYPE;
  lv_entity_type  VARCHAR2(10);
  lv_date_due     repairs.rep_date_due%TYPE;
  lv_sys_flag     road_segs.rse_sys_flag%TYPE;
  lv_admin_unit   hig_admin_units.hau_admin_unit%TYPE;
  lv_def_status   hig_status_codes.hsc_status_code%type;
  lv_boqs_created NUMBER;
  lv_dummy        NUMBER;   
  lr_defect_rec   defects%ROWTYPE;
  lr_repair_rec   repairs%ROWTYPE;
  i               NUMBER;
  --
  CURSOR get_sys_flag(cp_he_id road_segs.rse_he_id%TYPE)
      IS
  SELECT rse_sys_flag
    FROM road_segs
   WHERE rse_he_id = cp_he_id
       ;
  --
  CURSOR get_admin_unit
      IS
  SELECT hau_admin_unit
    FROM hig_admin_units
	    ,hig_users
   WHERE hau_admin_unit = hus_admin_unit
     AND hus_username = USER
	  ;
  --
  CURSOR get_initial_status
      IS
  SELECT hsc_status_code
    FROM hig_status_codes
   WHERE hsc_domain_code = 'DEFECTS'
     AND hsc_allow_feature1 = 'Y';
  --
BEGIN
  --
  -- Create Inspection.
  --
  lv_entity_type := 'Inspection';
  --
  OPEN  get_sys_flag(pi_insp_rec.are_rse_he_id);
  FETCH get_sys_flag
   INTO lv_sys_flag;
  CLOSE get_sys_flag;
  --
  lv_insp_id := mai_act.activities_report_id(pi_insp_rec.are_rse_he_id
                                            ,pi_insp_rec.are_maint_insp_flag
			                                ,pi_insp_rec.are_date_work_done
			                                ,pi_insp_rec.are_initiation_type
			                                ,pi_insp_rec.are_peo_person_id_actioned
    			                            ,pi_insp_rec.are_peo_person_id_insp2
    			                            ,pi_insp_rec.are_surface_condition
    			                            ,pi_insp_rec.are_weather_condition
    			                            ,pi_defect_rec.def_atv_acty_area_code
                                            ,pi_insp_rec.are_st_chain
    			                            ,pi_insp_rec.are_end_chain
    			                            ,pi_insp_rec.are_created_date);
  --
  -- Create Defect.
  --
  lv_entity_type := 'Defect';
  --
  lr_defect_rec := pi_defect_rec;
  lr_defect_rec.def_are_report_id := lv_insp_id;
  --
  OPEN  get_initial_status;
  FETCH get_initial_status
   INTO lv_def_status;
  IF get_initial_status%NOTFOUND
   THEN
      RAISE_APPLICATION_ERROR(-20001,'Cannot Find Initial Defect Status');
  END IF;
  CLOSE get_initial_status;
  lr_defect_rec.def_status_code := lv_def_status;
  --
  lv_defect_id := mai_act.create_defect(lr_defect_rec);
  --
  lr_defect_rec.def_defect_id := lv_defect_id;
  --
  -- Create Repair.
  --
  lv_entity_type := 'Repair';
  --
  FOR i IN 1..pi_repair_tab.COUNT LOOP
    --
	lr_repair_rec := pi_repair_tab(i);
	--
    IF ((lv_sys_flag = 'D' and lv_repsetperd = 'Y') OR
        (lv_sys_flag = 'L' and lv_repsetperl = 'Y')) AND
       lr_repair_rec.rep_action_cat = 'P' AND
       lr_defect_rec.def_orig_priority = '1' AND
	   pi_repair_tab.COUNT = 1  -- ie. No Other Repairs To Be Created.
     THEN
       lv_action_cat := 'T';
    ELSE
       lv_action_cat := lr_repair_rec.rep_action_cat;
    END IF;
	--
	DBMS_OUTPUT.PUT_LINE('Rep Action Cat Is     : '||lr_repair_rec.rep_action_cat);
	DBMS_OUTPUT.PUT_LINE('Rep Action Cat Passed : '||lv_action_cat);
    mai_act.rep_date_due(sysdate
                    ,lr_defect_rec.def_atv_acty_area_code
                    ,lr_defect_rec.def_orig_priority
                    ,lv_action_cat
                    ,pi_insp_rec.are_rse_he_id
                    ,lv_date_due
                    ,lv_dummy);
    IF lv_dummy <> 0
     THEN
        IF lv_dummy = 8509
  	   THEN
            RAISE_APPLICATION_ERROR(-20001,'Cannot Find Interval For Priority/Repair Category');
        ELSIF lv_dummy = 8213
  	   THEN
            RAISE_APPLICATION_ERROR(-20001,'Cannot Find Interval For Road');
        ELSE
            RAISE_APPLICATION_ERROR(-20001,'Cannot Find Due Date From Interval');
        END IF;
    END IF;
    --
    lv_dummy := mai_act.create_repair(lv_defect_id
                                     ,lr_repair_rec.rep_action_cat
                                     ,pi_insp_rec.are_rse_he_id
                                     ,lr_repair_rec.rep_tre_treat_code
                                     ,lr_defect_rec.def_atv_acty_area_code
                                     ,lv_date_due
                                     ,lr_repair_rec.rep_descr
                                     ,''
                                     ,'');  
    --
    -- Create BOQs.
    --
    IF((lv_sys_flag = 'D' and lv_usetremodd = 'Y') OR
       (lv_sys_flag = 'L' and lv_usetremodl = 'Y'))
     THEN
        --
        lv_entity_type := 'BOQ';
        --
        OPEN  get_admin_unit;
        FETCH get_admin_unit
         INTO lv_admin_unit;
        CLOSE get_admin_unit;
        --
        lv_boqs_created := mai_act.cre_boq_items(lv_defect_id
                                                ,lr_repair_rec.rep_action_cat
                                                ,lv_admin_unit
                                                ,lr_repair_rec.rep_tre_treat_code
                                                ,lr_defect_rec.def_defect_code
                                                ,lv_sys_flag
                                                ,lr_defect_rec.def_atv_acty_area_code
                                                ,lv_tremodlev
                                                ,'');
        --
        IF lv_boqs_created < 0
         THEN
            RAISE_APPLICATION_ERROR(-20001,''||chr(10)||to_char(SQLCODE)||':'||SQLERRM);
        END IF;
        --
    END IF;
  END LOOP;
  --
  COMMIT;
  --
  RETURN lv_defect_id;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE_APPLICATION_ERROR(-20001,'Error Occured Whilst Creating '||lv_entity_type
	                                 ||chr(10)||to_char(SQLCODE)||':'||SQLERRM);
END create_defect;

--
-----------------------------------------------------------------------------
--
FUNCTION create_repair (
		p_defect_id				IN	repairs.rep_def_defect_id%TYPE
		,p_action_cat			IN	repairs.rep_action_cat%TYPE
		,p_rse_he_id			IN	repairs.rep_rse_he_id%TYPE
		,p_treat_code			IN	repairs.rep_tre_treat_code%TYPE
		,p_acty_area_code			IN	repairs.rep_atv_acty_area_code%TYPE
		,p_date_due				IN	repairs.rep_date_due%TYPE
		,p_descr				IN	repairs.rep_descr%TYPE
		,p_local_date_due			IN	repairs.rep_local_date_due%TYPE
		,p_old_due_date			IN	repairs.rep_old_due_date%TYPE
) RETURN NUMBER IS

  l_today		DATE := SYSDATE;
  insert_error	EXCEPTION;

BEGIN

 INSERT INTO repairs (
		rep_def_defect_id
		,rep_action_cat
		,rep_rse_he_id
		,rep_tre_treat_code
		,rep_atv_acty_area_code
		,rep_created_date
		,rep_date_due
		,rep_last_updated_date
		,rep_superseded_flag
		,rep_completed_hrs
		,rep_completed_mins
		,rep_date_completed
		,rep_descr
		,rep_local_date_due
		,rep_old_due_date
		)
  VALUES (
		p_defect_id
		,p_action_cat
		,p_rse_he_id
		,p_treat_code
		,p_acty_area_code
		,l_today
		,p_date_due
		,l_today
		,'N'
		,''
		,''
		,''
		,p_descr
		,p_local_date_due
		,p_old_due_date
		);

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN 0;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Repair');

END;

-------------------------------------------------------------------------------

FUNCTION create_doc_assocs (
		p_table_name			IN	doc_assocs.das_table_name%TYPE
		,p_rec_id    			IN	doc_assocs.das_rec_id%TYPE
		,p_doc_id   			IN	doc_assocs.das_doc_id%TYPE
) RETURN NUMBER IS

  insert_error	EXCEPTION;

BEGIN

 INSERT INTO doc_assocs (
		das_table_name
		,das_rec_id
		,das_doc_id
		)
 VALUES (
		p_table_name
		,p_rec_id
		,p_doc_id
		);

  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;

  RETURN 0;

EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Doc_Assocs');

END;

-------------------------------------------------------------------------------

FUNCTION delete_doc_assocs (
		p_table_name			IN	doc_assocs.das_table_name%TYPE
		,p_rec_id    			IN	doc_assocs.das_rec_id%TYPE
		,p_doc_id   			IN	doc_assocs.das_doc_id%TYPE
) RETURN NUMBER IS

  delete_error	EXCEPTION;

BEGIN

 DELETE FROM doc_assocs
 WHERE das_rec_id = p_rec_id
   AND das_doc_id = p_doc_id
   AND das_table_name = p_table_name;

 IF SQL%rowcount = 0 THEN
    RAISE delete_error;
 END IF;

 RETURN 0;

EXCEPTION
  WHEN delete_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while deleting Doc_Assocs');

END;

-------------------------------------------------------------------------------

FUNCTION get_hco_seq ( domain_value IN hig_codes.hco_domain%TYPE
                      ,code_value   IN hig_codes.hco_code%TYPE )
RETURN NUMBER IS
tmpvar NUMBER;
--
  CURSOR get_code_seq
  IS SELECT hco_seq
     FROM   hig_codes
     WHERE  hco_domain= domain_value
     AND    hco_code  = code_value;
BEGIN
   --
   tmpvar:=0;
   --
   IF code_value IS NOT NULL
   THEN OPEN  get_code_seq;
        FETCH get_code_seq INTO tmpvar;
        IF   get_code_seq%NOTFOUND
        THEN CLOSE get_code_seq;
        ELSE CLOSE get_code_seq;
        END IF;
   END IF;
   --
   RETURN tmpvar;
   --
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RETURN 0;
  WHEN OTHERS
  THEN RETURN 0;
END;


-------------------------------------------------------------------------------

/* MAIN */

  -----------------------------------------------------------------------------
  -- Function to get the <owner> of a database object (table,view,cluster)
  -- (PRIVATE)
  --
  FUNCTION get_owner
	( a_object_name	IN	VARCHAR2
  ) RETURN VARCHAR2 AS

  /* either user owns the object (table,view,cluster) */
    CURSOR c_uo IS
      SELECT USER
      FROM   user_objects
      WHERE  object_name = UPPER( a_object_name)
        AND  object_type <> 'SYNONYM';

 /* or user has the use of a synonym for an object owned by another user */
    CURSOR c_as IS
      SELECT table_owner
      FROM   all_synonyms
      WHERE  synonym_name = UPPER( a_object_name);

 /* or user has no access to an object with this name */
    v_owner VARCHAR2(30);
    b_found BOOLEAN DEFAULT FALSE;

  BEGIN
    DBMS_OUTPUT.PUT_LINE( 'get_owner( '||a_object_name||')');

    OPEN  c_uo;
    FETCH c_uo INTO v_owner;
    b_found := c_uo%FOUND;
    CLOSE c_uo;
    IF    (NOT b_found) THEN
      OPEN  c_as;
      FETCH c_as INTO v_owner;
      b_found := c_as%FOUND;
      CLOSE c_as;
    END IF;

    DBMS_OUTPUT.PUT_LINE( 'RETURN( '||v_owner||')');
    RETURN( v_owner);
  END get_owner;

  -- Perform re-chainage of section related objects.
PROCEDURE reverse_chain_inventory(pn_rse_he_id           IN     NUMBER,
                                  pc_road_characteristic IN     VARCHAR2,
                                  pd_start_date          IN     DATE,
                                  pd_end_date            IN     DATE,
                                  pc_ukpms               IN     VARCHAR2,
                                  pc_item_id             IN     VARCHAR2,
                                  pc_new_xsp             IN     VARCHAR2,
                                  pc_dummy1              IN     VARCHAR2,
                                  pc_dummy2              IN     VARCHAR2,
                                  pc_dummy3              IN     VARCHAR2,
                                  pn_rows_processed      IN OUT NUMBER)    IS
  --
  -- Do not ship this to Pn rows processed returens a value
  --
  lc_x_sect_upd      VARCHAR2(2000);
  lr_rowid           ROWID;
  --
  CURSOR c1 IS
    SELECT ROWID,
           'Y' ukpms_flag
    FROM   hhinv_item_err_2 a
    WHERE  a.he_id = NVL(pn_rse_he_id,a.he_id)
    AND    (invent_date BETWEEN pd_start_date AND pd_end_date
            OR pd_start_date IS NULL)
    AND    (hhinv_ity_sys_flag||inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                FROM   ukpms_view_definitions
                                                WHERE  uvd_xsp_method_in_use = 'U')
            AND NVL(pc_ukpms,'N') = 'N')
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = a.inv_code
                 AND    ity_sys_flag            = hhinv_ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic))
    UNION
    SELECT ROWID,'N' ukpms_flag
    FROM   hhinv_item_err_2 a
    WHERE  a.he_id            = NVL(pn_rse_he_id,a.he_id)
    AND    (invent_date BETWEEN pd_start_date AND pd_end_date
            OR pd_start_date IS NULL)
    AND    (hhinv_ity_sys_flag||inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                            FROM   ukpms_view_definitions
                                            WHERE  uvd_xsp_method_in_use = 'U')
            AND NVL(pc_ukpms,'Y') = 'Y')
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = a.inv_code
                 AND    ity_sys_flag            = hhinv_ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic));

  CURSOR c2 IS
    SELECT ROWID,'Y' ukpms_flag
    FROM hhinv_load_2 a
    WHERE  he_id  = NVL(pn_rse_he_id,a.he_id)
    AND    (invent_date BETWEEN pd_start_date AND pd_end_date
            OR pd_start_date IS NULL)
    AND   (hhinv_ity_sys_flag||a.inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                             FROM   ukpms_view_definitions
                                             WHERE  uvd_xsp_method_in_use = 'U')
            AND NVL(pc_ukpms,'Y') = 'Y')
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = a.inv_code
                 AND    ity_sys_flag            = hhinv_ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic))
    UNION
    SELECT ROWID,'N' ukpms_flag
    FROM hhinv_load_2 a
    WHERE  he_id           = NVL(pn_rse_he_id,a.he_id)
    AND    (invent_date BETWEEN pd_start_date AND pd_end_date
            OR pd_start_date IS NULL)
    AND   (hhinv_ity_sys_flag||a.inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                 FROM ukpms_view_definitions
                                                 WHERE uvd_xsp_method_in_use = 'U')
           AND NVL(pc_ukpms,'N') = 'N')
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = a.inv_code
                 AND    ity_sys_flag            = hhinv_ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic));
    --

  FUNCTION f_det_xsp(pc_table_name IN VARCHAR2,
                     pr_rowid      IN ROWID) RETURN VARCHAR2 IS
    CURSOR c4 IS
      SELECT column_name
      FROM   cols
      WHERE table_name = pc_table_name
      AND   SUBSTR(column_name,1,6) = 'HHATTR'
      ORDER BY TO_NUMBER(SUBSTR(column_name,7));
    --
    lc_column_name     VARCHAR2(30);
    lc_column_contents VARCHAR2(2000);
    lc_det_xsp         VARCHAR2(4);
    --
    c INTEGER;
    execute_feedback INTEGER;
    --
    ln_fetched_rows     INTEGER;
    --
  BEGIN
    --
    pn_rows_processed := 0;
    --
    FOR c4_rec IN c4 LOOP
      --
      c := DBMS_SQL.OPEN_CURSOR;
      --
      lc_column_name := c4_rec.column_name;

      DBMS_SQL.PARSE(c,'SELECT '||lc_column_name||' FROM '||pc_table_name||' WHERE ROWID = '''||ROWIDTOCHAR(pr_rowid)||'''',DBMS_SQL.V7);
      --
      DBMS_SQL.DEFINE_COLUMN(c,1,lc_column_contents,2000);
      --
      execute_feedback := DBMS_SQL.EXECUTE (c);
      --
      ln_fetched_rows := DBMS_SQL.FETCH_ROWS(c);
      DBMS_SQL.COLUMN_VALUE(c,1,lc_column_contents);
      --
      DBMS_SQL.CLOSE_CURSOR(c);
      --
      IF lc_column_contents = 'DET_XSP' THEN
        lc_column_name := 'HHFLD'||SUBSTR(lc_column_name,7);
        RETURN ','||lc_column_name||' = '||' (select uxr_reversed_xsp '||
                                           ' from ukpms_xsp_reversal '||
                                           ' where a.'||lc_column_name||' = uxr_normal_xsp)';
      END IF;
    END LOOP;
    RETURN NULL;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RETURN NULL;
  END;

BEGIN
  IF pn_rse_he_id           IS NULL AND
     pc_road_characteristic IS NULL AND
     pd_start_date          IS NULL AND
     pc_ukpms               IS NULL AND
     pc_item_id             IS NULL THEN
     RAISE_APPLICATION_ERROR( -20001,'No reversal to take place without any query restrictions');
  END IF;
-- The following two SQL statements would be required where a Coordinate
-- (other GIS interface like RoMIS 1.4 Coordinate Interface) is in use.
-- They are included in the comments in the anticipation that bespoke work
-- may be required to configure the above described interface.
--
-- The two tables are used by batch programs maintaining the synchronisation
-- of the defect/inventory information held by the GIS.
--
--
  --
  UPDATE inv_items_all
  SET    iit_st_chain    = (SELECT rse_length -NVL(iit_end_chain,0)
                            FROM   road_segs
                            WHERE  rse_he_id = iit_rse_he_id)
          ,iit_end_chain = (SELECT rse_length -NVL(iit_st_chain,0)
                            FROM   road_segs
                            WHERE  rse_he_id = iit_rse_he_id)
          ,iit_last_updated_date  = SYSDATE
          ,iit_x_sect = (SELECT uxr_reversed_xsp
                         FROM   ukpms_xsp_reversal
                         WHERE  iit_x_sect = uxr_normal_xsp
                         AND    iit_ity_sys_flag||iit_ity_inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                      FROM   ukpms_view_definitions
                                                                      WHERE  uvd_xsp_method_in_use = 'U')
                         UNION
                         SELECT NVL(pc_new_xsp,xrv_new_xsp)
                         FROM   xsp_reversal
                         WHERE  iit_x_sect          = xrv_old_xsp
                         AND    xrv_manual_override = 'N'
                         AND    iit_ity_sys_flag||iit_ity_inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                          FROM   ukpms_view_definitions
                                                                          WHERE  uvd_xsp_method_in_use = 'U'))
          ,iit_det_xsp = (SELECT uxr_reversed_xsp
                          FROM   ukpms_xsp_reversal
                          WHERE  iit_det_xsp = uxr_normal_xsp)
    WHERE  iit_rse_he_id = NVL(pn_rse_he_id,iit_rse_he_id)
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = iit_ity_inv_code
                 AND    ity_sys_flag            = iit_ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic))
    AND (   (iit_ity_sys_flag||iit_ity_inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                                FROM   ukpms_view_definitions
                                                WHERE  uvd_xsp_method_in_use = 'U')
             AND pc_ukpms = 'Y')
         OR (iit_ity_sys_flag||iit_ity_inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                       FROM ukpms_view_definitions
                                                       WHERE uvd_xsp_method_in_use = 'U')
             AND pc_ukpms = 'N')
         OR pc_ukpms IS NULL)
    AND (iit_cre_date BETWEEN pd_start_date AND pd_end_date
         OR pd_start_date IS NULL)
    AND  iit_item_id = NVL(pc_item_id,iit_item_id);

  pn_rows_processed := pn_rows_processed+ SQL%rowcount;

  IF pc_item_id IS NULL THEN
  BEGIN
    FOR cur_c1_rec IN c1 LOOP
      lr_rowid := cur_c1_rec.ROWID;
        --
        --
        lc_x_sect_upd := ',x_sect = ((SELECT uxr_reversed_xsp '||
                                    'FROM   ukpms_xsp_reversal '||
                                    'WHERE  x_sect = uxr_normal_xsp '||
                                    'AND    hhinv_ity_sys_flag||inv_code IN(SELECT uvd_sys_flag||uvd_inv_code '||
                                                                           'FROM   ukpms_view_definitions '||
                                                                           'WHERE  uvd_xsp_method_in_usE = ''U''))'||
                                    'UNION '||
                                    '(SELECT nvl(pc_new_xsp,xrv_new_xsp) '||
                                     'FROM   xsp_reversal '||
                                     'WHERE  x_sect = xrv_old_xsp '||
                                     'AND    xrv_manual_override = ''N'''||
                                     'AND    hhinv_ity_sys_flag||inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code '||
                                                                                'FROM   ukpms_view_definitions '||
                                                                                'WHERE  uvd_xsp_method_in_use = ''U'')))';
       hig.execute_sql('UPDATE hhinv_item_err_2 a '||
                       'SET    st_chain        = (SELECT rse_length -nvl(a.end_chain,0) '||
                                                 'FROM   road_segs '||
                                                 'WHERE  rse_he_id = a.he_id) '||
                             ',end_chain       = (SELECT rse_length -nvl(a.st_chain,0) '||
                                                 'FROM   road_segs '||
                                                 'WHERE  rse_he_id = a.he_id) '||
                       lc_x_sect_upd||
                       f_det_xsp('HHINV_ITEM_ERR_2',cur_c1_rec.ROWID)||' '||
                      'WHERE rowid = '''||ROWIDTOCHAR(cur_c1_rec.ROWID)||'''' ,pn_rows_processed);
      --
      pn_rows_processed := pn_rows_processed+ SQL%rowcount;
      --
    END LOOP;
      EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UPDATE hhinv_item_err_2 a '||
                       'SET    st_chain        = (SELECT rse_length -nvl(a.end_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) '||
                             ',end_chain       = (SELECT rse_length -nvl(a.st_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) ');
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,1,200));
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,201,200));
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,401,200));
        DBMS_OUTPUT.PUT_LINE(f_det_xsp('HHINV_ITEM_ERR_2',lr_rowid));
        DBMS_OUTPUT.PUT_LINE('WHERE rowid = '''||ROWIDTOCHAR(lr_rowid)||'''');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;

  BEGIN
    FOR cur_c2_rec IN c2 LOOP
        lr_rowid := cur_c2_rec.ROWID;
        lc_x_sect_upd := ',x_sect = ((SELECT uxr_reversed_xsp '||
                                    'FROM   ukpms_xsp_reversal '||
                                    'WHERE  a.x_sect = uxr_normal_xsp '||
                                    'AND    hhinv_ity_sys_flag||inv_code IN(SELECT uvd_sys_flag||uvd_inv_code '||
                                                                                 'FROM ukpms_view_definitions '||
                                                                                 'WHERE uvd_xsp_method_in_use = ''U''))'||
                                    ' UNION '||
                                    '(SELECT nvl(pc_new_xsp,xrv_new_xsp) '||
                                     'FROM   xsp_reversal '||
                                     'WHERE  a.x_sect = xrv_old_xsp '||
                                     'AND    xrv_manual_override = ''N'''||
                                     'AND    hhinv_ity_sys_flag||inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code '||
                                                                                      'FROM   ukpms_view_definitions '||
                                                                                      'WHERE  uvd_xsp_method_in_use = ''U'')))';
       hig.execute_sql('UPDATE hhinv_load_2 a '||
                       'SET    st_chain        = (SELECT rse_length -nvl(a.end_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) '||
                             ',end_chain       = (SELECT rse_length -nvl(a.st_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) '||
                       lc_x_sect_upd||
                       f_det_xsp('HHINV_LOAD_2',cur_c2_rec.ROWID)||' '||
                      'WHERE rowid = '''||ROWIDTOCHAR(cur_c2_rec.ROWID)||'''' ,pn_rows_processed);
      --
      pn_rows_processed := pn_rows_processed+ SQL%rowcount;
      --
    END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('UPDATE hhinv_load_2 a '||
                       'SET    st_chain        = (SELECT rse_length -nvl(a.end_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) '||
                             ',end_chain       = (SELECT rse_length -nvl(a.st_chain,0) '||
                                                 'FROM road_segs '||
                                                 'WHERE rse_he_id = a.he_id) ');
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,1,200));
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,201,200));
        DBMS_OUTPUT.PUT_LINE(SUBSTR(lc_x_sect_upd,401,200));
        DBMS_OUTPUT.PUT_LINE(f_det_xsp('HHINV_LOAD_2',lr_rowid));
        DBMS_OUTPUT.PUT_LINE('WHERE rowid = '''||ROWIDTOCHAR(lr_rowid)||'''');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
      END;
    --
    UPDATE hhinv_load_3 a
    SET    st_chain  = (SELECT rse_length -NVL(a.end_chain,0)
                        FROM   road_segs
                        WHERE   rse_he_id = a.he_id)
          ,end_chain = (SELECT rse_length -NVL(a.st_chain,0)
                        FROM   road_segs
                        WHERE  rse_he_id = a.he_id)
          ,x_sect    = (SELECT uxr_reversed_xsp
                        FROM   ukpms_xsp_reversal
                        WHERE  a.x_sect = uxr_normal_xsp
                        AND    a.ity_sys_flag||a.inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                                             FROM   ukpms_view_definitions
                                                             WHERE  uvd_xsp_method_in_use = 'U')
                        UNION
                        SELECT NVL(pc_new_xsp,xrv_new_xsp)
                        FROM   xsp_reversal
                        WHERE  a.x_sect          = xrv_old_xsp
                        AND    xrv_manual_override = 'N'
                        AND    a.ity_sys_flag||a.inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                 FROM   ukpms_view_definitions
                                                                 WHERE  uvd_xsp_method_in_use = 'U'))
          ,det_xsp   = (SELECT uxr_reversed_xsp
                        FROM   ukpms_xsp_reversal
                        WHERE  a.det_xsp = uxr_normal_xsp)
          ,VALUE     = ((SELECT uxr_reversed_xsp
                        FROM   ukpms_xsp_reversal
                        WHERE  a.det_xsp = uxr_normal_xsp
                        AND    a.ATTRIBUTE = 'DET_XSP')
                        UNION
                       (SELECT a.VALUE
                        FROM dual
                        WHERE a.ATTRIBUTE <> 'DET_XSP'))
    WHERE  he_id = NVL(pn_rse_he_id,a.he_id)
    AND    (invent_date BETWEEN pd_start_date AND pd_end_date
                                 OR pd_start_date IS NULL)
    AND   ity_sys_flag||inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                    FROM   ukpms_view_definitions
                                    WHERE  uvd_xsp_method_in_use = 'U')
    AND (  (ity_sys_flag||inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                    FROM   ukpms_view_definitions
                                    WHERE  uvd_xsp_method_in_use = 'U')
            AND pc_ukpms = 'Y')
         OR (ity_sys_flag||inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                           FROM   ukpms_view_definitions
                                           WHERE  uvd_xsp_method_in_use = 'U')
             AND pc_ukpms = 'N')
         OR pc_ukpms IS NULL)
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types b
                 WHERE  b.ity_inv_code          = a.inv_code
                 AND    b.ity_sys_flag          = a.ity_sys_flag
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic));
    --
    UPDATE inv_mp_errors a
    SET ime_start_chain    = (SELECT rse_length -NVL(a.ime_end_chain,0)
                              FROM   road_segs
                              WHERE  rse_he_id = a.ime_rse_he_id)
       ,ime_end_chain      = (SELECT rse_length -NVL(a.ime_start_chain,0)
                              FROM   road_segs
                              WHERE  rse_he_id = a.ime_rse_he_id)
       ,ime_xsp            = (SELECT uxr_reversed_xsp
                              FROM   ukpms_xsp_reversal
                              WHERE  a.ime_xsp = uxr_normal_xsp
                              AND    a.ime_item_id IN(SELECT iit_item_id
                                                    FROM   inv_items_all
                                                    WHERE  iit_ity_sys_flag||iit_ity_inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                                                 FROM   ukpms_view_definitions
                                                                                                 WHERE  uvd_xsp_method_in_use = 'U'))
                              UNION
                              SELECT NVL(pc_new_xsp,xrv_new_xsp)
                              FROM   xsp_reversal
                              WHERE  a.ime_xsp          = xrv_old_xsp
                              AND    xrv_manual_override = 'N'
                              AND    a.ime_item_id IN(SELECT iit_item_id
                                                    FROM inv_items_all
                                                    WHERE iit_ity_sys_flag||iit_ity_inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                               FROM   ukpms_view_definitions
                                                                               WHERE  uvd_xsp_method_in_use = 'U')))
    WHERE ime_rse_he_id    = NVL(pn_rse_he_id,a.ime_rse_he_id)
    AND ime_item_id IN (SELECT iit_item_id
                        FROM inv_items_all
                        WHERE (iit_cre_date BETWEEN pd_start_date AND pd_end_date
                               OR pd_start_date IS NULL)
                        AND   (   (iit_ity_sys_flag||iit_ity_inv_code IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                         FROM   ukpms_view_definitions
                                                                         WHERE  uvd_xsp_method_in_use = 'U')
                                   AND pc_ukpms = 'Y')
                               OR (iit_ity_sys_flag||iit_ity_inv_code NOT IN(SELECT uvd_sys_flag||uvd_inv_code
                                                                             FROM   ukpms_view_definitions
                                                                             WHERE  uvd_xsp_method_in_use = 'U')
                                   AND pc_ukpms = 'N')
                               OR pc_ukpms IS NULL)
                               )
    AND EXISTS ( SELECT 'exists'
                 FROM   inv_item_types
                 WHERE  ity_inv_code            = a.ime_inv_code
                 AND    ity_sys_flag            = (SELECT rse_sys_flag
                                                   FROM road_segs
                                                   WHERE rse_he_id = NVL(pn_rse_he_id,a.ime_rse_he_id ))
                 AND    ity_road_characteristic = NVL(pc_road_characteristic,ity_road_characteristic));
  END IF;
END;

   FUNCTION calc_st_chain( p_st_chain road_sections.rse_length%TYPE
                         , p_end_chain road_sections.rse_length%TYPE
                         , p_he_id road_sections.rse_he_id%TYPE)
   RETURN NUMBER
   IS
   --
   -- Used in r2mainy.pc mai2110c load inv stage 2
   --
      CURSOR c_length (c_he_id  road_sections.rse_he_id%TYPE)
      IS
      SELECT rse.rse_length
      FROM road_sections rse
      WHERE rse.rse_he_id = c_he_id;

      l_length road_sections.rse_he_id%TYPE;
      l_percent NUMBER;
      l_diff NUMBER;
      retval NUMBER;
   BEGIN
      OPEN c_length(p_he_id);
      FETCH c_length INTO l_length;
      CLOSE c_length;

      l_percent := ((p_end_chain-l_length)/p_end_chain)*100;

      l_diff := (l_percent/100)*p_st_chain;

      IF ROUND(p_st_chain - l_diff,3) < 0
       THEN
         retval := 0;
      ELSE
         retval := ROUND(p_st_chain - l_diff,3);
      END IF;

      RETURN retval;
   END calc_st_chain;
--
-- Start WAG changes.
--
FUNCTION GET_ICB_FGAC_CONTEXT(Top BOOLEAN, lc_agency VARCHAR2) RETURN VARCHAR2 IS
--
  CURSOR C2 IS
     select hau_authority_code
     from hig_admin_groups, hig_admin_units, hig_users
     where hau_level = 2
     and  hag_parent_admin_unit = hau_admin_unit
     and  hag_child_admin_unit = hus_admin_unit
     and hus_username = user;
  --
  CURSOR C3 IS
    SELECT hau_authority_code
    FROM hig_admin_units
    WHERE hau_admin_unit = 1;
  --
  l_dummy VARCHAR2(1);
  --
  l_default_agency VARCHAR2(4);
  --
BEGIN
  --
  OPEN C3;
  FETCH C3
  INTO l_default_agency;
  CLOSE C3;
  --
  IF NOT top then
    IF hig.get_sysopt('ICBFGAC') = 'Y' AND HIG.GET_OWNER('HIG_PRODUCTS') != User THEN
        IF lc_agency IS NULL THEN
          --
	  -- Now need to set agency level restriction
	  --
	  OPEN C2;
	  FETCH C2
	  INTO  l_default_agency;
	  CLOSE C2;
	  --
	ELSE
	  l_default_agency := lc_agency;
	END IF;
    ELSE
      IF hig.get_sysopt('ICBFGAC') = 'Y' AND lc_agency IS NOT NULL THEN
        --
	l_default_agency := lc_agency;
      ELSE
        l_default_agency := NULL;
      END IF;
    END IF;
  END IF;
  --
  RETURN l_default_agency;
END;
--
FUNCTION GET_ICB_FGAC_CONTEXT(Top BOOLEAN) RETURN VARCHAR2 IS
  --
  c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  IF hig.get_sysopt('ICBFGAC') = 'Y' THEN
    DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', get_icb_fgac_context(Top,''));
  END IF;
  --
  RETURN MAI_ACT.GET_ICB_FGAC_CONTEXT(Top,NULL);
END;

FUNCTION GET_ICB_FGAC_CONTEXT(lc_agency VARCHAR2) RETURN VARCHAR2 IS
  --
  c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  IF hig.get_sysopt('ICBFGAC') = 'Y' THEN
    DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', lc_agency);
  END IF;
  --
  RETURN MAI_ACT.GET_ICB_FGAC_CONTEXT(FALSE, lc_agency);
END;

FUNCTION ICB_FGAC_PREDICATE(schema_in VARCHAR2,
                            name_in   VARCHAR2)
                             RETURN VARCHAR2 IS
  --
  c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy VARCHAR2(4);
  --
BEGIN
      IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      RETURN 'icb_agency_code = NVL(SYS_CONTEXT('''||c_context||''',''AGENCY''),icb_agency_code)';
END;

FUNCTION ICB_BUDGET_FGAC_PREDICATE(schema_in VARCHAR2,
                                   name_in   VARCHAR2)
                                   RETURN VARCHAR2 IS
  --
  c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy VARCHAR2(4);
  --
BEGIN
      IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      RETURN 'bud_agency = NVL(SYS_CONTEXT('''||c_context||''',''AGENCY''),bud_agency)';
END;

FUNCTION ICB_WO_FGAC_PREDICATE(schema_in VARCHAR2,
                               name_in   VARCHAR2)
                               RETURN VARCHAR2 IS
  --
  c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy VARCHAR2(4);
  --
BEGIN
      --
      IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      IF get_icb_fgac_context(FALSE) IS NULL THEN
        RETURN '1 = 1';
      ELSE
        RETURN 'wor_agency = SYS_CONTEXT('''||c_context||''',''AGENCY'')';
      END IF;
END;
--
-- End Wag Changes
--

-----------------------------------------------------------------------------------
-- Auto Defect Prioritisation Changes
-- A.E. March 2003
-----------------------------------------------------------------------------------
FUNCTION GET_AUTO_DEF_PRIORITY(p_rse_he_id     IN NUMBER,
                               p_network_type  IN VARCHAR2,
                               p_activity_code IN VARCHAR2,
                               p_defect_code   IN VARCHAR2
) RETURN VARCHAR2 IS


   TYPE adsp_rowid        IS TABLE OF ROWID           INDEX BY binary_integer;
   TYPE adsp_attrib       IS TABLE OF varchar2(500)   INDEX BY binary_integer;
   TYPE adsp_cntrl_value  IS TABLE OF varchar2(500)   INDEX BY binary_integer;

   l_adsp_rowid 		  adsp_rowid;
   l_adsp_attrib 		  adsp_attrib;
   l_adsp_cntrl_value 	  adsp_cntrl_value;

   cur_string 			  VARCHAR2(30000) := NULL;
   cur_string_x 		  VARCHAR2(30000) := NULL;
   v_priority 			  defect_priorities.dpr_priority%TYPE;

   l_count pls_integer;

BEGIN

  cur_string := 'select adsp_priority'||chr(10);
  cur_string := cur_string||' from auto_defect_selection_priority, road_segs'||chr(10);
  cur_string := cur_string||' where adsp_dtp_flag = :p_network_type'||chr(10);
  cur_string := cur_string||' and adsp_atv_acty_area_code = :p_activity_code'||chr(10);
  cur_string := cur_string||' and adsp_defect_code = :p_defect_code'||chr(10);
  cur_string := cur_string||' and rse_he_id = :p_rse_he_id';

  SELECT
     adsp.ROWID,
	 hco.hco_meaning,
	 adsp.adsp_cntrl_value
  BULK COLLECT INTO
     l_adsp_rowid,
	 l_adsp_attrib,
	 l_adsp_cntrl_value
  FROM
     hig_codes hco,
	 auto_defect_selection_priority adsp
  WHERE
     hco.hco_domain = 'ADSP_RSE_ATTS'
  AND
     hco.hco_code = adsp.adsp_flex_attrib
  AND
     adsp.adsp_atv_acty_area_code = p_activity_code
  AND
     adsp.adsp_defect_code = p_defect_code
  AND
     adsp.adsp_dtp_flag = p_network_type
  AND
     adsp.adsp_priority_rank in (select min(adsp.adsp_priority_rank)
	                           from auto_defect_selection_priority adsp
				  where adsp.adsp_atv_acty_area_code = p_activity_code
                                    and adsp.adsp_defect_code = p_defect_code
				    and adsp.adsp_dtp_flag = p_network_type)
								   ;

  l_count := l_adsp_rowid.COUNT;


  IF l_count > 0
     THEN
       -- Will never loop since entered ranking.. but it works OK
       FOR l_i IN 1..l_count
       LOOP
	   	   -- Add rse attrib to sql statement
           cur_string_x := cur_string||chr(10)||' and '||l_adsp_attrib(l_i)||' = adsp_cntrl_value';

		   -- Get priority for current attrib
	       EXECUTE IMMEDIATE cur_string_x INTO v_priority
               USING p_network_type
                    ,p_activity_code
                    ,p_defect_code
					,p_rse_he_id;


	   END LOOP;
  END IF;


-- RETURN to_char(v_date_due);
 RETURN (v_priority);

END;

-----------------------------------------------------------------------------------
-- END of Auto Defect Prioritisation Changes
-----------------------------------------------------------------------------------
--
FUNCTION get_iit_admin_unit(pi_iit_ne_id         nm_inv_items_all.iit_ne_id%type
                           ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                           ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000) RETURN NUMBER IS
  --
  CURSOR get_admin_unit(cp_iit_ne_id nm_inv_items_all.iit_ne_id%type)
      IS
  SELECT iit_admin_unit
    FROM nm_inv_items_all
   WHERE iit_ne_id = cp_iit_ne_id
       ;
  --
  lv_admin_unit nm_inv_items_all.iit_ne_id%type;
  lv_found      BOOLEAN;
  --
BEGIN
  --
  OPEN  get_admin_unit(pi_iit_ne_id);
  FETCH get_admin_unit
   INTO lv_admin_unit;
  lv_found := get_admin_unit%FOUND;
  CLOSE get_admin_unit;
  --
  IF pi_raise_not_found AND NOT lv_found
   THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_sqlcode            => pi_not_found_sqlcode
                   ,pi_supplementary_info => 'nm_inv_items_all (INV_ITEMS_ALL_PK)'
                                             ||CHR(10)||'iit_ne_id => '||to_char(pi_iit_ne_id)
                   );
  END IF;
  --
  RETURN(lv_admin_unit);
  --
END;
--
FUNCTION get_bud_admin_unit(pi_bud_id            budgets.bud_id%type
                           ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
                           ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000) RETURN NUMBER IS
  --
  CURSOR get_admin_unit(cp_bud_id budgets.bud_id%type)
      IS
  SELECT nau_admin_unit
    FROM budgets
        ,nm_admin_units
   WHERE bud_id = cp_bud_id
     AND bud_agency = nau_authority_code
     AND nau_admin_type ='NET'
       ;
  --
  lv_admin_unit nm_inv_items_all.iit_ne_id%type;
  lv_found      BOOLEAN;
  --
BEGIN
  --
  OPEN  get_admin_unit(pi_bud_id);
  FETCH get_admin_unit
   INTO lv_admin_unit;
  lv_found := get_admin_unit%FOUND;
  CLOSE get_admin_unit;
  --
  IF pi_raise_not_found AND NOT lv_found
   THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_sqlcode            => pi_not_found_sqlcode
                   ,pi_supplementary_info => 'budgets'
                                             ||CHR(10)||'bud_id => '||to_char(pi_bud_id)
                   );
  END IF;
  --
  RETURN(lv_admin_unit);
  --
END;
--
FUNCTION get_nm3type_c_big_number RETURN NUMBER IS
BEGIN
  --
  RETURN(nm3type.c_big_number);
  --
END;
--
PROCEDURE get_wor_totals (pi_wor_works_order_no in  work_orders.wor_works_order_no%type
                         ,po_wor_est_labour     out work_orders.wor_est_labour%type
                         ,po_wor_est_cost       out work_orders.wor_est_cost%type
                         ,po_wor_act_cost       out work_orders.wor_act_cost%type)IS
  --
  cursor get_wols(cp_works_order_no work_orders.wor_works_order_no%type)
      is
  select wol_id
        ,wol_fixed_cost
        ,wol_est_cost
        ,wol_est_labour
        ,wol_act_cost
    from work_order_lines
   where wol_works_order_no = cp_works_order_no
       ;
  --
  cursor get_boqs(cp_wol_id work_order_lines.wol_id%type)
      is
  select decode(count(0),count(boq_est_labour),sum(boq_est_labour),null)
        ,decode(count(0),count(boq_est_cost)  ,sum(boq_est_cost)  ,null)
        ,sum(boq_act_cost)
    from boq_items
   where boq_wol_id = cp_wol_id
       ;
  --
  lv_wol_tot_est_labour work_order_lines.wol_est_labour%type;
  lv_wol_tot_est_cost   work_order_lines.wol_est_cost%type;
  lv_wol_tot_act_cost   work_order_lines.wol_act_cost%type;
  lv_wor_tot_est_labour work_orders.wor_est_labour%type;
  lv_wor_tot_est_cost   work_orders.wor_est_cost%type;
  lv_wor_tot_act_cost   work_orders.wor_act_cost%type;
BEGIN
  --
  -- Loop through WOLS.
  --
  for wol_rec in get_wols(pi_wor_works_order_no) loop
    if nvl(wol_rec.wol_fixed_cost,'N') = 'Y'
     then
	    --
		-- Fixed Costs Entered Directly Onto The WOL.
		--
        if wol_rec.wol_est_labour is not null
         then
            lv_wor_tot_est_labour := nvl(lv_wor_tot_est_labour,0) + wol_rec.wol_est_labour;
        end if;
        if wol_rec.wol_est_cost is not null
         then
            lv_wor_tot_est_cost := nvl(lv_wor_tot_est_cost,0) + wol_rec.wol_est_cost;
        end if;
        if wol_rec.wol_act_cost is not null
         then
            lv_wor_tot_act_cost := nvl(lv_wor_tot_act_cost,0) + wol_rec.wol_act_cost;
        end if;
    else
	    --
		-- Costs Entered Via BOQs.
		--
        open  get_boqs(wol_rec.wol_id);
        fetch get_boqs
         into lv_wol_tot_est_labour
             ,lv_wol_tot_est_cost
             ,lv_wol_tot_act_cost;
        close get_boqs;
        if lv_wol_tot_est_labour is not null
         then
            lv_wor_tot_est_labour := nvl(lv_wor_tot_est_labour,0) + lv_wol_tot_est_labour;
        end if;
        if lv_wol_tot_est_cost is not null
         then
            lv_wor_tot_est_cost := nvl(lv_wor_tot_est_cost,0) + lv_wol_tot_est_cost;
        end if;
        if lv_wol_tot_act_cost is not null
         then
            lv_wor_tot_act_cost := nvl(lv_wor_tot_act_cost,0) + lv_wol_tot_act_cost;
        end if;
    end if;
  end loop;
  --
  -- Return Totals.
  --
  po_wor_est_labour := lv_wor_tot_est_labour;
  po_wor_est_cost   := lv_wor_tot_est_cost;
  po_wor_act_cost   := lv_wor_tot_act_cost;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE;
END;
--
BEGIN  /* mai - automatic variables */
  /*
    return the Oracle user who is owner of the MAI application
    (use 'DEFECTS' as the sample HIGHWAYS object)
  */
  g_application_owner := get_owner( 'DEFECTS');
  IF    (g_application_owner IS NULL) THEN
    RAISE_APPLICATION_ERROR( -20000 ,'MAI_ACT.G_APPLICATION_OWNER is null.');
  END IF;

  /* return the language under which the application is running */
  g_language := 'ENGLISH';

  /* instantiate common error messages */

END mai_act;
/
