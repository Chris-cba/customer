CREATE OR REPLACE PACKAGE BODY mai AS
/********************************************************
|| EAM BESPOKE VERSION BASED ON STANDARD PVCS VERSION 2.0
*********************************************************/
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/admin/pck/mai.pkb-arc   1.0   Nov 28 2008 11:01:22   mhuitson  $
--       Module Name      : $Workfile:   mai.pkb  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:01:22  $
--       Date fetched Out : $Modtime:   Nov 28 2008 10:36:58  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on Standard MAI version 2.0
--
--
-- MAINTENANCE MANAGER application generic utilities
--
-----------------------------------------------------------------------------
--   Originally taken from '@(#)mai.pck 1.35 05/08/03'
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
-- Return the SCCS id of the package
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   1.0  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name      CONSTANT  varchar2(30)   := 'mai';
   g_tab_register_wols nm3type.tab_varchar30;
   g_parent_asset_tab  parent_asset_tab;
   g_child_asset_type  nm_inv_types_all.nit_inv_type%TYPE;
   
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_wo_no(pi_wo_no IN work_orders.wor_works_order_no%TYPE) IS
BEGIN
  --
  g_wo_no := pi_wo_no;
  --
END set_wo_no;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wo_no RETURN work_orders.wor_works_order_no%TYPE IS
BEGIN
  --
  RETURN g_wo_no;
  --
END get_wo_no;
--
-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.
FUNCTION contract_still_in_date(p_wo_no work_order_lines.wol_works_order_no%TYPE)
  RETURN BOOLEAN IS
  --
cursor get_contract_details is
select distinct con.con_year_end_date
from work_orders wo,     
	   contracts con,
	   work_order_lines wol	 
where con.con_id = wo.wor_con_id
and wol.wol_id = p_wo_no -- 34177
and con.con_year_end_date is not null
and wo.wor_works_order_no = wol.wol_works_order_no;  
  --
l_con_year_end_date contracts.con_year_end_date%TYPE := sysdate;
BEGIN
  --
  open get_contract_details;
  fetch get_contract_details into l_con_year_end_date;
  close get_contract_details;
  --
  if l_con_year_end_date <= sysdate then
    return FALSE;
  else
    return TRUE;
  end if;
  --
END;
-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.
FUNCTION parse_inv_condition(instring VARCHAR2)
  RETURN VARCHAR2 IS
  --
  dummycursor   INTEGER;
  --
BEGIN
  --
  dummycursor := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(dummycursor,
                'select null from inv_items_all where '||instring,
                dbms_sql.native);
  --
  RETURN('PARSED');
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN('NOT PARSED');
END;
--
-------------------------------------------------------------------------------
-- Parse an inventory condition for budget allocation rules.
FUNCTION parse_inv_condition(p_instring   VARCHAR2
                            ,p_asset_type nm_inv_types_all.nit_inv_type%TYPE)
  RETURN VARCHAR2 IS
  --
  lv_sel_str    VARCHAR2(4100);
  dummycursor   INTEGER;
  lv_table      nm_inv_types_all.nit_table_name%TYPE := nm3get.get_nit(p_asset_type).NIT_TABLE_NAME;
  --
BEGIN
  --
  IF lv_table IS NULL
   THEN
      lv_sel_str := 'select null from nm_inv_items_all where ';
  ELSE
      lv_sel_str := 'select null from '||lv_table||' where ';
  END IF;
  --
  dummycursor := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(dummycursor,
                lv_sel_str||p_instring,
                dbms_sql.native);
  --
  RETURN('PARSED');
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RETURN('NOT PARSED');
END;
  -----------------------------------------------------------------------------
  -- Function to set the Context. SM-07102004
  PROCEDURE set_context (pi_namespace IN varchar2
                        ,pi_attribute IN varchar2
                        ,pi_value     IN varchar2
                        ) IS
  BEGIN
  --
      dbms_session.set_context(namespace => pi_namespace
                              ,ATTRIBUTE => pi_attribute
                              ,VALUE     => pi_value
                              );
  --
  END set_context;
  --
  -----------------------------------------------------------------------------
  -- Function to retrieve Context. SM-07102004
  FUNCTION get_context (pi_namespace IN varchar2
                       ,pi_attribute IN varchar2
                       ) RETURN varchar2 IS
  --
  BEGIN
  --
     RETURN sys_context(pi_namespace, pi_attribute);
  --
  END get_context;
  --
  -----------------------------------------------------------------------------
  FUNCTION wol_id_nextseq
           RETURN number
           IS

    cursor c1 is
    select wol_id_seq.nextval
    from   sys.dual;

    l_wol_id work_order_lines.wol_id%TYPE;

  BEGIN
    open c1;
    fetch c1 into l_wol_id;
    close c1;

    return l_wol_id;
  END wol_id_nextseq;
-----------------------------------------------------------------------------
FUNCTION boq_id_nextseq RETURN number IS
  --
  cursor c1 is
  select boq_id_seq.nextval
  from   sys.dual;
  --
  l_boq_id boq_items.boq_id%TYPE;
  --
BEGIN
  open  c1;
  fetch c1 into l_boq_id;
  close c1;
  --
  return l_boq_id;
END boq_id_nextseq;
-----------------------------------------------------------------------------
-- Function to Create BOQ Items
-----------------------------------------------------------------------------
FUNCTION cre_boq_items(p_defect_id          IN boq_items.boq_defect_id%TYPE
                      ,p_rep_action_cat     IN boq_items.boq_rep_action_cat%TYPE
                      ,p_oun_org_id         IN hig_admin_units.hau_admin_unit%TYPE
                      ,p_treat_code         IN treatments.tre_treat_code%TYPE
                      ,p_defect_code        IN defects.def_defect_code%TYPE
                      ,p_sys_flag           IN road_segments_all.rse_sys_flag%TYPE
                      ,p_atv_acty_area_code IN activities.atv_acty_area_code%TYPE
                      ,p_tremodlev          IN NUMBER
                      ,p_attr_value         IN NUMBER) RETURN NUMBER IS
  --
  l_return    NUMBER;
  --
BEGIN
  --
--  nm_debug.debug('p_defect_id : '||p_defect_id);
--  nm_debug.debug('p_rep_action_cat : '||p_rep_action_cat);
--  nm_debug.debug('p_oun_org_id : '||p_oun_org_id);
--  nm_debug.debug('p_treat_code : '||p_treat_code);
--  nm_debug.debug('p_defect_code : '||p_defect_code);
--  nm_debug.debug('p_sys_flag : '||p_sys_flag);
--  nm_debug.debug('p_atv_acty_area_code : '||p_atv_acty_area_code);
--  nm_debug.debug('p_tremodlev : '||p_tremodlev);
--  nm_debug.debug('p_attr_value : '||p_attr_value);
  --
  INSERT
    INTO boq_items
        (boq_work_flag
        ,boq_defect_id
        ,boq_rep_action_cat
        ,boq_wol_id
        ,boq_sta_item_code
        ,boq_item_name
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
        ,sta.sta_item_name
        ,SYSDATE
        ,NVL(tmi.tmi_default_quantity,
             NVL(tmi.tmi_multiplier,1) * NVL(p_attr_value,0) )
        ,DECODE( sta_dim2_text, NULL, NULL, 1 )
        ,DECODE( sta_dim3_text, NULL, NULL, 1 )
        ,NVL(tmi.tmi_default_quantity,
             NVL(tmi.tmi_multiplier,1) * NVL(p_attr_value,0) )
        ,sta.sta_rate
        ,sta.sta_rate * NVL(tmi.tmi_default_quantity,
             NVL(tmi.tmi_multiplier,1) * NVL(p_attr_value,0) )
        ,NVL(tmi.tmi_default_quantity,
             NVL(tmi.tmi_multiplier,1) * NVL(p_attr_value,0) ) * sta_labour_units
        ,boq_id_seq.NEXTVAL
    FROM standard_items         sta
        ,treatment_model_items  tmi
        ,treatment_models       tmo
        ,def_types              dty
        ,hig_admin_units        hau
        ,hig_admin_groups       hag
   WHERE hau.hau_level              = p_tremodlev
     AND hau.hau_admin_unit         = hag.hag_parent_admin_unit
     AND tmo.tmo_oun_org_id         = hau.hau_admin_unit
     AND hag.hag_child_admin_unit   = p_oun_org_id
     AND tmo.tmo_tre_treat_code     = p_treat_code
     AND tmo.tmo_atv_acty_area_code = p_atv_acty_area_code
     AND tmo.tmo_dty_defect_code    = p_defect_code
     AND tmo.tmo_sys_flag           = p_sys_flag
     AND dty.dty_defect_code        = p_defect_code
     AND dty.dty_atv_acty_area_code = p_atv_acty_area_code
     AND dty.dty_dtp_flag           = p_sys_flag
     AND tmi.tmi_tmo_id             = tmo.tmo_id
     AND tmi.tmi_sta_item_code      = sta.sta_item_code
       ;
  --
  RETURN(SQL%rowcount);
  --
EXCEPTION
  WHEN NO_DATA_FOUND
   THEN
      RETURN (0);
  WHEN OTHERS
   THEN
      RETURN (-1);
END cre_boq_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE calculate_inv_quantity(he_id     IN     road_segments_all.rse_he_id%TYPE
                                ,calc_type IN     standard_items.sta_calc_type%TYPE
                                ,item_code IN     schedule_items.schi_sta_item_code%TYPE
                                ,quantity  IN OUT schedule_items.schi_calc_quantity%TYPE) IS
  --
  CURSOR c1(cp_he_id     road_segments_all.rse_he_id%TYPE
           ,cp_item_code schedule_items.schi_sta_item_code%TYPE)
      IS
  SELECT 'SELECT i1.iit_end_chain,i1.iit_st_chain,i1.iit_width,i1.iit_height'
        ||',i1.iit_ity_inv_code,i1.iit_ity_sys_flag,i1.iit_x_sect,r1.rel_factor'
        ||' FROM road_segments_all,inv_items_all i1,related_inventory r1'
        ||' WHERE r1.rel_sta_item_code = '||''''||cp_item_code||''''
        ||' AND r1.rel_ity_inv_code = i1.iit_ity_inv_code'
        ||' AND r1.rel_ity_sys_flag = i1.iit_ity_sys_flag'
        ||' AND '||''''||SYSDATE||''''||' BETWEEN i1.iit_cre_date AND NVL(i1.iit_end_date, sysdate)'
        ||' AND i1.iit_rse_he_id = rse_he_id'
        ||' AND i1.iit_ity_sys_flag = rse_sys_flag'
        ||' AND '||''''||SYSDATE||''''||' BETWEEN rse_start_date AND NVL(rse_end_date,sysdate)'
        ||' AND rse_he_id = '||TO_CHAR(cp_he_id)
        ||DECODE(r2.rel_condition, NULL, NULL,' AND '||REPLACE(LOWER(r2.rel_condition),'iit','i1.iit'))
    FROM related_inventory r2
   WHERE r2.rel_sta_item_code = cp_item_code
       ;
  --
  CURSOR c2(cp_he_id            nm_elements_all.ne_id%TYPE
           ,cp_iit_ity_inv_code inv_items_all.iit_ity_inv_code%TYPE
           ,cp_iit_ity_sys_flag inv_items_all.iit_ity_sys_flag%TYPE
           ,cp_iit_end_chain    inv_items_all.iit_end_chain%TYPE
           ,cp_iit_x_sect       inv_items_all.iit_x_sect%TYPE)
      IS
  SELECT iit_width
    FROM inv_items_all
   WHERE iit_rse_he_id       = cp_he_id
     AND iit_ity_inv_code    = cp_iit_ity_inv_code
     AND iit_ity_sys_flag    = cp_iit_ity_sys_flag
     AND iit_st_chain        = cp_iit_end_chain
     AND NVL(iit_x_sect,'Z') = NVL(cp_iit_x_sect,'Z')
     AND SYSDATE BETWEEN iit_cre_date
                     AND NVL(iit_end_date,SYSDATE)
       ;
  --
  lv_query             VARCHAR2(32767);
  lv_cursor_id         INTEGER;
  lv_row_count         INTEGER;
  lv_tot_qty           NUMBER;
  lv_iit_end_chain     inv_items_all.iit_end_chain%TYPE;
  lv_iit_st_chain      inv_items_all.iit_st_chain%TYPE;
  lv_iit_width         inv_items_all.iit_width%TYPE;
  lv_iit_width2        inv_items_all.iit_width%TYPE;
  lv_iit_height        inv_items_all.iit_height%TYPE;
  lv_iit_ity_inv_code  inv_items_all.iit_ity_inv_code%TYPE;
  lv_iit_ity_sys_flag  inv_items_all.iit_ity_sys_flag%TYPE;
  lv_iit_x_sect        inv_items_all.iit_x_sect%TYPE;
  lv_rel_factor        related_inventory.rel_factor%TYPE;
  --
BEGIN
  --
  nm_debug.debug_on;
  --
  OPEN  c1(he_id,item_code);
  FETCH c1
   INTO lv_query;
  CLOSE c1;
  --
  higgri.parse_query(lv_query,lv_cursor_id);          -- parse the query
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,1,lv_iit_end_chain);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,2,lv_iit_st_chain);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,3,lv_iit_width);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,4,lv_iit_height);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,5,lv_iit_ity_inv_code,4);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,6,lv_iit_ity_sys_flag,1);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,7,lv_iit_x_sect,4);
  DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,8,lv_rel_factor);
  --
  lv_row_count := DBMS_SQL.EXECUTE(lv_cursor_id);    -- execute query
  --
  nm_debug.debug('row count : '||to_char(lv_row_count));
  --
  LOOP
    --
    IF DBMS_SQL.FETCH_ROWS(lv_cursor_id) > 0         -- fetch back from cursor
     THEN
        --
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,1,lv_iit_end_chain);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,2,lv_iit_st_chain);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,3,lv_iit_width);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,4,lv_iit_height);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,5,lv_iit_ity_inv_code);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,6,lv_iit_ity_sys_flag);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,7,lv_iit_x_sect);
        DBMS_SQL.COLUMN_VALUE(lv_cursor_id,8,lv_rel_factor);
        --
        IF calc_type = 'N'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + (1 * lv_rel_factor);
        ELSIF calc_type = 'L'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + ((NVL(lv_iit_end_chain,lv_iit_st_chain) - lv_iit_st_chain)
                                          * lv_rel_factor);
        ELSIF calc_type = 'A'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + ((NVL(lv_iit_width, 0) * NVL(lv_iit_height, 0))
                                          * lv_rel_factor);
        ELSIF calc_type = 'T'
         THEN
            --
            OPEN  c2(he_id,lv_iit_ity_inv_code,lv_iit_ity_sys_flag,lv_iit_end_chain,lv_iit_x_sect);
            FETCH c2
             INTO lv_iit_width2;
            CLOSE c2;
            --
            IF NVL(lv_iit_width2,0) = 0
             THEN
                lv_iit_width2 := NVL(lv_iit_width,0);
            END IF;
            --
            lv_tot_qty := NVL(lv_tot_qty,0) + ((NVL(lv_iit_width,0) + lv_iit_width2) * 0.5
                                               *(NVL(lv_iit_end_chain,lv_iit_st_chain) - lv_iit_st_chain)
                                               *lv_rel_factor);
            --
        END IF;
        --
    ELSE
        --
        EXIT;
        --
    END IF;
    --
  END LOOP;
  --
  DBMS_SQL.CLOSE_CURSOR(lv_cursor_id);               -- close cursor
  --
  quantity := NVL(lv_tot_qty,0);                     -- pass calculated value back
  --
  nm_debug.debug('quantity : '||to_char(quantity));
  nm_debug.debug_off;
  --
END calculate_inv_quantity;
--
--
PROCEDURE pop_schd_roads(pi_schd_id IN schedules.schd_id%type
                        ,pi_group_id IN road_groups.rse_he_id%type
                        ,pi_item_code IN standard_items.sta_item_code%type) IS
BEGIN
  insert into schedule_roads
             (schr_schd_id
             ,schr_sta_item_code
             ,schr_rse_he_id
             ,schr_act_quantity
             ,schr_last_updated
             )
  select      pi_schd_id
             ,pi_item_code
             ,rsm_rse_he_id_of
             ,'0'
             ,sysdate
  from        road_seg_membs
  where       rsm_type = 'S'
  and         rsm_end_date is null
  connect by prior rsm_rse_he_id_of = rsm_rse_he_id_in
  start with rsm_rse_he_id_in = pi_group_id;
END pop_schd_roads;
--
--
PROCEDURE upd_schedule_quantity_assets(pi_schd_id  IN schedules.schd_id%TYPE
                                      ,pi_group_id IN road_segs.rse_he_id%TYPE
                                      ,pi_item_code IN standard_items.sta_item_code%TYPE) IS

  /*
  || This Procedure Was Created To Move The Bulk Of The Program
  || Unit pop_schd_items_assets From mai3860 To The Server.
  */
  lv_item_code schedule_items.schi_sta_item_code%type;
  lv_calc_type standard_items.sta_calc_type%type:='N';
  lv_item_id   inv_items_all.iit_item_id%type;
  lv_quantity  number:=0;
  lv_tot       number:=0;
  --
  CURSOR Get_Network(cp_group_id road_segs.rse_he_id%TYPE)
      IS
  SELECT rsm_rse_he_id_of  section
    FROM road_seg_membs
   WHERE rsm_type = 'S'
     AND rsm_end_date IS NULL
 CONNECT BY PRIOR rsm_rse_he_id_of = rsm_rse_he_id_in
   START WITH rsm_rse_he_id_in = cp_group_id
       ;
  --
  CURSOR c1(cp_schd_id schedules.schd_id%TYPE)
      IS
  SELECT schi_sta_item_code
        ,sta_calc_type
    FROM related_inventory
        ,standard_items
        ,schedules
        ,schedule_items
   WHERE schd_id            = cp_schd_id
     AND schi_schd_id       = schd_id
     AND rel_sta_item_code  = sta_item_code
     AND sta_item_code      = schi_sta_item_code
       ;
  --
BEGIN
  --
  DELETE
    FROM schedule_roads
   WHERE schr_schd_id=pi_schd_id
       ;

     --
     -- NM 04-AUG-2005: Changes made to replicate those done by SM for v2.
     --
     pop_schd_roads(pi_schd_id
                   ,pi_group_id
                   ,pi_item_code);

  --
  FOR i IN get_network(pi_group_id) LOOP
    --
    FOR j IN c1(pi_schd_id) LOOP
      --
      calculate_inv_quantity_assets(pi_schd_id
                                   ,i.section
                                   ,lv_calc_type
                                   ,j.schi_sta_item_code
                                   ,lv_item_id
                                   ,lv_quantity);
    END LOOP;
    --
  END LOOP;
  --
  UPDATE schedule_items schi
     SET schi.schi_calc_quantity =(SELECT NVL(SUM(schr_calc_quantity),0)
                                     FROM schedule_roads schr
                                    WHERE schr.schr_schd_id=schi.schi_schd_id
                                      AND schr.schr_sta_item_code = schi.schi_sta_item_code)
        ,schi.schi_last_updated = SYSDATE
   WHERE schi.schi_schd_id=pi_schd_id
       ;
  --
END upd_schedule_quantity_assets;
--
PROCEDURE calculate_inv_quantity_assets(p_schd_id    IN     schedules.schd_id%TYPE
                                       ,he_id        IN     road_segments_all.rse_he_id%TYPE
                                       ,calc_type    IN     standard_items.sta_calc_type%TYPE
                                       ,item_code    IN     schedule_items.schi_sta_item_code%TYPE
                                       ,item_id      IN OUT inv_items_all.iit_item_id%TYPE
                                       ,quantity     IN OUT schedule_items.schi_calc_quantity%TYPE) IS
  --
  CURSOR c1(cp_he_id     road_segments_all.rse_he_id%TYPE
           ,cp_item_code schedule_items.schi_sta_item_code%TYPE)
      IS
  SELECT 'select iit_item_id,count(*) '
        ||'from inv_items_all,road_segments_all,related_inventory r1 '
        ||'where rse_he_id ='||TO_CHAR(cp_he_id)
        ||' and iit_ity_inv_code = r1.rel_ity_inv_code'
        ||' and iit_ity_sys_flag = r1.rel_ity_sys_flag'
        ||' and iit_rse_he_id='||TO_CHAR(cp_he_id)
        ||' and r1.rel_sta_item_code = '||''''||cp_item_code||''''
        ||' and '||''''||SYSDATE||''''||' between iit_cre_date and nvl(iit_end_date, sysdate)'
        ||' and '||''''||SYSDATE||''''||' between rse_start_date and nvl(rse_end_date,sysdate)'
        ||' and iit_ity_sys_flag = rse_sys_flag '
        ||DECODE(r2.rel_condition, NULL, NULL,' AND '||r2.rel_condition)
        ||' group by iit_item_id'
    FROM related_inventory r2
   WHERE r2.rel_sta_item_code = cp_item_code
       ;
  --
  l_query     VARCHAR2(32767);
  l_cursor_id INTEGER;
  l_status    INTEGER;
  lcnt        NUMBER;
  lid         NUMBER;
  --
BEGIN
  --
  nm_debug.debug_on;
  --
  OPEN  c1(he_id,item_code);
  FETCH c1
   INTO l_query;
  CLOSE c1;
  nm_debug.debug(l_query);
  higgri.parse_query(l_query,l_cursor_id);          -- parse the query
  DBMS_SQL.DEFINE_COLUMN(l_cursor_id,1,lid);        -- define col to return
  DBMS_SQL.DEFINE_COLUMN(l_cursor_id,2,lcnt);       -- define col to return
  l_status := DBMS_SQL.EXECUTE(l_cursor_id);        -- execute query
  LOOP
    --
    IF DBMS_SQL.FETCH_ROWS(l_cursor_id) > 0
     THEN
        --
        DBMS_SQL.COLUMN_VALUE(l_cursor_id,1,lid);  -- assign to variable
        DBMS_SQL.COLUMN_VALUE(l_cursor_id,2,lcnt); -- assign to variable
        --
        IF lcnt>0
         THEN
            INSERT
              INTO schedule_roads
                  (schr_schd_id
                  ,schr_sta_item_code
                  ,schr_rse_he_id
                  ,schr_calc_quantity
                  ,schr_act_quantity
                  ,schr_last_updated
                  ,schr_iit_item_id)
            VALUES(p_schd_id
                  ,item_code
                  ,he_id
                  ,lcnt
                  ,0
                  ,SYSDATE
                  ,lid)
                 ;
        END IF;
        --
    ELSE
        --
        EXIT;
        --
    END IF;
    --
  END LOOP;
  --
  DBMS_SQL.CLOSE_CURSOR(l_cursor_id);  -- close cursor
  --
  quantity := NVL(lcnt,0);             -- pass calculated value back
  item_id  := NVL(lid,0);              -- pass the asset id's back
  --
  nm_debug.debug_off;
  --
END calculate_inv_quantity_assets;


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
       v_stg          VARCHAR2(2000) := 'Create or Replace force view '||view_name||
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
          nm_debug.debug(v_stg);
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

FUNCTION activities_report_id( p_rse_he_id    IN road_segs.rse_he_id%TYPE
          ,p_maint_insp_flag  IN activities_report.are_maint_insp_flag%TYPE
          ,p_date_work_done   IN activities_report.are_date_work_done%TYPE
          ,p_initiation_type  IN activities_report.are_initiation_type%TYPE
          ,p_person_id_actioned IN activities_report.are_peo_person_id_actioned%TYPE
          ,p_person_id_insp2  IN activities_report.are_peo_person_id_insp2%TYPE
          ,p_surface      IN activities_report.are_surface_condition%TYPE
          ,p_weather      IN activities_report.are_weather_condition%TYPE
          ,p_acty_area_code   IN activities.atv_acty_area_code%TYPE
          ,p_start_chain    IN activities_report.are_st_chain%TYPE
          ,p_end_chain    IN activities_report.are_end_chain%TYPE
) RETURN NUMBER IS

  l_report_id activities_report.are_report_id%TYPE;
  l_rse_length  road_segs.rse_length%TYPE;
  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;

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

FUNCTION activities_report_id( p_rse_he_id    IN road_segs.rse_he_id%TYPE
          ,p_maint_insp_flag  IN activities_report.are_maint_insp_flag%TYPE
          ,p_date_work_done   IN activities_report.are_date_work_done%TYPE
          ,p_initiation_type  IN activities_report.are_initiation_type%TYPE
          ,p_person_id_actioned IN activities_report.are_peo_person_id_actioned%TYPE
          ,p_person_id_insp2  IN activities_report.are_peo_person_id_insp2%TYPE
          ,p_surface      IN activities_report.are_surface_condition%TYPE
          ,p_weather      IN activities_report.are_weather_condition%TYPE
          ,p_acty_area_code   IN activities.atv_acty_area_code%TYPE
          ,p_start_chain    IN activities_report.are_st_chain%TYPE
          ,p_end_chain    IN activities_report.are_end_chain%TYPE
          ,p_created_date         IN activities_report.are_created_date%TYPE
) RETURN NUMBER IS

  l_report_id activities_report.are_report_id%TYPE;
  l_rse_length  road_segs.rse_length%TYPE;
  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;

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

FUNCTION activities_report_id(p_batch_id            IN activities_report.are_batch_id%TYPE
                             ,p_rse_he_id           IN road_segs.rse_he_id%TYPE
                             ,p_maint_insp_flag     IN activities_report.are_maint_insp_flag%TYPE
                             ,p_date_work_done      IN activities_report.are_date_work_done%TYPE
                             ,p_initiation_type     IN activities_report.are_initiation_type%TYPE
                             ,p_person_id_actioned  IN activities_report.are_peo_person_id_actioned%TYPE
                             ,p_person_id_insp2     IN activities_report.are_peo_person_id_insp2%TYPE
                             ,p_surface             IN activities_report.are_surface_condition%TYPE
                             ,p_weather             IN activities_report.are_weather_condition%TYPE
                             ,p_acty_area_code      IN activities.atv_acty_area_code%TYPE
                             ,p_start_chain         IN activities_report.are_st_chain%TYPE
                             ,p_end_chain           IN activities_report.are_end_chain%TYPE
                             ,p_created_date        IN activities_report.are_created_date%TYPE) RETURN NUMBER IS
  --
  l_report_id activities_report.are_report_id%TYPE;
  l_rse_length  road_segs.rse_length%TYPE;
  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;
  --
  CURSOR c1(cp_rse_he_id nm_elements.ne_id%TYPE)
      IS
  SELECT rse_length
    FROM road_segs
   WHERE rse_he_id = cp_rse_he_id;

BEGIN
  --
  SELECT are_report_id_seq.NEXTVAL
    INTO l_report_id
    FROM dual;
  --
  OPEN  c1(p_rse_he_id);
  FETCH c1
   INTO l_rse_length;
  CLOSE c1;
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
  VALUES(l_report_id
        ,p_rse_he_id
        ,p_batch_id
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
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
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
  VALUES('C'
        ,l_report_id
        ,p_acty_area_code
        ,l_today
        ,l_today
        ,''
        ,'');
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
  --
  RETURN l_report_id;
  --
EXCEPTION
  WHEN insert_error THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Activities Report');

END activities_report_id;
--
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
    p_rse_he_id       IN  defects.def_rse_he_id%TYPE
    ,p_iit_item_id      IN  defects.def_iit_item_id%TYPE
    ,p_st_chain       IN  defects.def_st_chain%TYPE
    ,p_report_id      IN  defects.def_are_report_id%TYPE
    ,p_acty_area_code     IN  defects.def_atv_acty_area_code%TYPE
    ,p_siss_id        IN  defects.def_siss_id%TYPE
    ,p_works_order_no     IN  defects.def_works_order_no%TYPE
    ,p_defect_code      IN  defects.def_defect_code%TYPE
    ,p_orig_priority      IN  defects.def_orig_priority%TYPE
    ,p_priority       IN  defects.def_priority%TYPE
    ,p_status_code      IN  defects.def_status_code%TYPE
    ,p_area       IN  defects.def_area%TYPE
    ,p_are_id_not_found   IN  defects.def_are_id_not_found%TYPE
    ,p_coord_flag     IN  defects.def_coord_flag%TYPE
    ,p_defect_class     IN  defects.def_defect_class%TYPE
    ,p_defect_descr     IN  defects.def_defect_descr%TYPE
    ,p_defect_type_descr    IN  defects.def_defect_type_descr%TYPE
    ,p_diagram_no     IN  defects.def_diagram_no%TYPE
    ,p_height       IN  defects.def_height%TYPE
    ,p_ident_code     IN  defects.def_ident_code%TYPE
    ,p_ity_inv_code     IN  defects.def_ity_inv_code%TYPE
    ,p_ity_sys_flag     IN  defects.def_ity_sys_flag%TYPE
    ,p_length       IN  defects.def_length%TYPE
    ,p_locn_descr     IN  defects.def_locn_descr%TYPE
    ,p_maint_wo       IN  defects.def_maint_wo%TYPE
    ,p_mand_adv       IN  defects.def_mand_adv%TYPE
    ,p_notify_org_id      IN  defects.def_notify_org_id%TYPE
    ,p_number       IN  defects.def_number%TYPE
    ,p_per_cent       IN  defects.def_per_cent%TYPE
    ,p_per_cent_orig      IN  defects.def_per_cent_orig%TYPE
    ,p_per_cent_rem     IN  defects.def_per_cent_rem%TYPE
    ,p_rechar_org_id      IN  defects.def_rechar_org_id%TYPE
    ,p_serial_no      IN  defects.def_serial_no%TYPE
    ,p_skid_coeff     IN  defects.def_skid_coeff%TYPE
    ,p_special_instr      IN  defects.def_special_instr%TYPE
    ,p_time_hrs       IN  defects.def_time_hrs%TYPE
    ,p_time_mins      IN  defects.def_time_mins%TYPE
    ,p_update_inv     IN  defects.def_update_inv%TYPE
    ,p_x_sect       IN  defects.def_x_sect%TYPE
            ,p_easting        IN  defects.def_easting%TYPE
    ,p_northing       IN  defects.def_northing%TYPE
    ,p_response_category    IN  defects.def_response_category%TYPE
) RETURN NUMBER IS

  l_defect_id defects.def_defect_id%TYPE;
  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;

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
    p_rse_he_id       IN  defects.def_rse_he_id%TYPE
    ,p_iit_item_id      IN  defects.def_iit_item_id%TYPE
    ,p_st_chain       IN  defects.def_st_chain%TYPE
    ,p_report_id      IN  defects.def_are_report_id%TYPE
    ,p_acty_area_code     IN  defects.def_atv_acty_area_code%TYPE
    ,p_siss_id        IN  defects.def_siss_id%TYPE
    ,p_works_order_no     IN  defects.def_works_order_no%TYPE
    ,p_defect_code      IN  defects.def_defect_code%TYPE
    ,p_orig_priority      IN  defects.def_orig_priority%TYPE
    ,p_priority       IN  defects.def_priority%TYPE
    ,p_status_code      IN  defects.def_status_code%TYPE
    ,p_area       IN  defects.def_area%TYPE
    ,p_are_id_not_found   IN  defects.def_are_id_not_found%TYPE
    ,p_coord_flag     IN  defects.def_coord_flag%TYPE
    ,p_defect_class     IN  defects.def_defect_class%TYPE
    ,p_defect_descr     IN  defects.def_defect_descr%TYPE
    ,p_defect_type_descr    IN  defects.def_defect_type_descr%TYPE
    ,p_diagram_no     IN  defects.def_diagram_no%TYPE
    ,p_height       IN  defects.def_height%TYPE
    ,p_ident_code     IN  defects.def_ident_code%TYPE
    ,p_ity_inv_code     IN  defects.def_ity_inv_code%TYPE
    ,p_ity_sys_flag     IN  defects.def_ity_sys_flag%TYPE
    ,p_length       IN  defects.def_length%TYPE
    ,p_locn_descr     IN  defects.def_locn_descr%TYPE
    ,p_maint_wo       IN  defects.def_maint_wo%TYPE
    ,p_mand_adv       IN  defects.def_mand_adv%TYPE
    ,p_notify_org_id      IN  defects.def_notify_org_id%TYPE
    ,p_number       IN  defects.def_number%TYPE
    ,p_per_cent       IN  defects.def_per_cent%TYPE
    ,p_per_cent_orig      IN  defects.def_per_cent_orig%TYPE
    ,p_per_cent_rem     IN  defects.def_per_cent_rem%TYPE
    ,p_rechar_org_id      IN  defects.def_rechar_org_id%TYPE
    ,p_serial_no      IN  defects.def_serial_no%TYPE
    ,p_skid_coeff     IN  defects.def_skid_coeff%TYPE
    ,p_special_instr      IN  defects.def_special_instr%TYPE
    ,p_time_hrs       IN  defects.def_time_hrs%TYPE
    ,p_time_mins      IN  defects.def_time_mins%TYPE
    ,p_update_inv     IN  defects.def_update_inv%TYPE
    ,p_x_sect       IN  defects.def_x_sect%TYPE
            ,p_easting        IN  defects.def_easting%TYPE
    ,p_northing       IN  defects.def_northing%TYPE
    ,p_response_category    IN  defects.def_response_category%TYPE
    ,p_date_created     in  defects.def_created_date%TYPE
) RETURN NUMBER IS

  l_defect_id defects.def_defect_id%TYPE;
  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;

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
                      ,p_date_created      => p_defect_rec.def_created_date);
END create_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(pi_insp_rec           IN activities_report%ROWTYPE
                      ,pi_defect_rec         IN defects%ROWTYPE
                      ,pi_repair_tab         IN rep_tab
                      ,pi_boq_tab            IN boq_tab) RETURN NUMBER IS
  --
  lv_repsetperd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERD');
  lv_usedefchnd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHND');
  lv_usetremodd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODD');
  lv_repsetperl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERL');
  lv_usedefchnl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHNL');
  lv_usetremodl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODL');
  lv_tremodlev    hig_options.hop_value%TYPE := hig.get_sysopt('TREMODLEV');
  lv_insp_init    hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_INIT'),'DUM');
  lv_insp_sdf     hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_SDF'),'D');
  lv_siss         hig_options.hop_value%TYPE := NVL(hig.get_sysopt('DEF_SISS'),'ALL');
  lv_locdefboqs   hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('LOCDEFBOQS');
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
  lt_boq_tab      boq_tab;
  i               NUMBER;
  --
  CURSOR get_sys_flag(cp_he_id road_segs.rse_he_id%TYPE)
      IS
  SELECT rse_sys_flag
    FROM road_segs
   WHERE rse_he_id = cp_he_id
       ;
  --
  CURSOR get_initial_status
      IS
  SELECT hsc_status_code
    FROM hig_status_codes
   WHERE hsc_domain_code = 'DEFECTS'
     AND hsc_allow_feature1 = 'Y'
       ;
  --
  FUNCTION get_admin_unit(pi_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE
                         ,pi_rse_he_id IN nm_elements_all.ne_id%TYPE)
    RETURN nm_admin_units.nau_admin_unit%TYPE IS
    --
    lv_retval nm_admin_units.nau_admin_unit%TYPE;
    --
  BEGIN
    IF pi_iit_ne_id IS NOT NULL
     THEN
        --
        lv_retval := nm3inv.get_inv_item_all(pi_iit_ne_id).iit_admin_unit;
        --
    ELSIF pi_rse_he_id IS NOT NULL
     THEN
        --
        lv_retval := nm3net.get_ne(pi_rse_he_id).ne_admin_unit;
        --
    END IF;
    --
    RETURN lv_retval;
    --
  END get_admin_unit;
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
  lv_insp_id := mai.activities_report_id(pi_insp_rec.are_batch_id
                                        ,pi_insp_rec.are_rse_he_id
                                        ,NVL(pi_insp_rec.are_maint_insp_flag,lv_insp_sdf)
                                        ,pi_insp_rec.are_date_work_done
                                        ,NVL(pi_insp_rec.are_initiation_type,lv_insp_init)
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
      RAISE_APPLICATION_ERROR(-20002,'Cannot Find Initial Defect Status');
  END IF;
  CLOSE get_initial_status;
  --
  lr_defect_rec.def_status_code := lv_def_status;
  --
  IF lr_defect_rec.def_siss_id IS NULL
   THEN
      lr_defect_rec.def_siss_id := lv_siss;
  END IF;
  lv_defect_id := mai.create_defect(lr_defect_rec);
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
    lv_date_due := lr_repair_rec.rep_date_due;
    lv_dummy := 0;
    --
    IF lv_date_due IS NULL
     THEN
        mai.rep_date_due(lr_defect_rec.def_created_date
                        ,lr_defect_rec.def_atv_acty_area_code
                        ,lr_defect_rec.def_orig_priority
                        ,lv_action_cat
                        ,pi_insp_rec.are_rse_he_id
                        ,lv_date_due
                        ,lv_dummy);
    END IF;
    --
    IF lv_dummy <> 0
     THEN
        IF lv_dummy = 8509
         THEN
            hig.raise_ner(nm3type.c_mai,904); --Cannot Find Interval For Priority/Repair Category
        ELSIF lv_dummy = 8213
         THEN
            hig.raise_ner(nm3type.c_mai,905); --Cannot Find Interval For Road
        ELSE
            hig.raise_ner(nm3type.c_mai,906); --Cannot Find Due Date From Interval
        END IF;
    END IF;
    --
    lv_dummy := mai.create_repair(lv_defect_id
                                 ,lr_repair_rec.rep_action_cat
                                 ,pi_insp_rec.are_rse_he_id
                                 ,lr_repair_rec.rep_tre_treat_code
                                 ,lr_defect_rec.def_atv_acty_area_code
                                 ,lv_date_due
                                 ,lr_repair_rec.rep_descr
                                 ,lv_date_due
                                 ,'');
    --
    -- Create BOQs.
    --
    IF pi_boq_tab.count > 0
     THEN
        --
        lt_boq_tab := pi_boq_tab;
        --
        FOR i IN 1..lt_boq_tab.COUNT LOOP
          --
          lt_boq_tab(i).boq_work_flag      := 'D';
          lt_boq_tab(i).boq_defect_id      := lv_defect_id;
          lt_boq_tab(i).boq_rep_action_cat := lr_repair_rec.rep_action_cat;
          lt_boq_tab(i).boq_wol_id         := 0;
          lt_boq_tab(i).boq_date_created   := sysdate;
          --
          SELECT boq_id_seq.nextval
            INTO lt_boq_tab(i).boq_id
            FROM dual
               ;
          --
        END LOOP;
        --
        FORALL i IN 1 .. lt_boq_tab.COUNT
          INSERT
            INTO boq_items
          VALUES lt_boq_tab(i)
               ;
        --
    ELSE
        IF((lv_sys_flag = 'D' and lv_usetremodd = 'Y') OR
           (lv_sys_flag = 'L' and lv_usetremodl = 'Y'))
         THEN
            --
            lv_entity_type := 'BOQ';
            --
            lv_admin_unit := get_admin_unit(lr_defect_rec.def_iit_item_id
                                           ,lr_defect_rec.def_rse_he_id);
            --
            lv_boqs_created := mai.cre_boq_items(lv_defect_id
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
                RAISE_APPLICATION_ERROR(-20006,''||chr(10)||to_char(SQLCODE)||':'||SQLERRM);
            END IF;
            --
        END IF;
    END IF;
  END LOOP;
  --
  --COMMIT;
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
    p_defect_id       IN  repairs.rep_def_defect_id%TYPE
    ,p_action_cat     IN  repairs.rep_action_cat%TYPE
    ,p_rse_he_id      IN  repairs.rep_rse_he_id%TYPE
    ,p_treat_code     IN  repairs.rep_tre_treat_code%TYPE
    ,p_acty_area_code     IN  repairs.rep_atv_acty_area_code%TYPE
    ,p_date_due       IN  repairs.rep_date_due%TYPE
    ,p_descr        IN  repairs.rep_descr%TYPE
    ,p_local_date_due     IN  repairs.rep_local_date_due%TYPE
    ,p_old_due_date     IN  repairs.rep_old_due_date%TYPE
) RETURN NUMBER IS

  l_today   DATE := SYSDATE;
  insert_error  EXCEPTION;

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
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tre_boqs(pi_admin_unit         IN     nm_admin_units_all.nau_admin_unit%TYPE
                      ,pi_treat_code         IN     treatment_models.tmo_tre_treat_code%TYPE
                      ,pi_atv_acty_area_code IN     treatment_models.tmo_atv_acty_area_code%TYPE
                      ,pi_defect_code        IN     treatment_models.tmo_dty_defect_code%TYPE
                      ,pi_sys_flag           IN     treatment_models.tmo_sys_flag%TYPE
                      ,po_results            IN OUT tre_boqs_tab) IS
  --
  lv_tremodlev   hig_options.hop_value%TYPE := hig.GET_SYSOPT('TREMODLEV');
  --
  lt_retval      tre_boqs_tab;
  --
BEGIN
--nm_debug.debug_on;
--nm_debug.debug('pi_treat_code         : '||pi_treat_code);
--nm_debug.debug('pi_atv_acty_area_code : '||pi_atv_acty_area_code);
--nm_debug.debug('pi_defect_code        : '||pi_defect_code);
--nm_debug.debug('pi_sys_flag           : '||pi_sys_flag);
--nm_debug.debug('pi_admin_unit         : '||pi_admin_unit);
  --
  SELECT sta.sta_item_code                                                   sta_item_code
        ,sta.sta_item_name                                                   sta_item_name
        ,sta.sta_unit                                                        sta_unit
        ,sta.sta_dim1_text                                                   sta_dim1_text
        ,sta.sta_dim2_text                                                   sta_dim2_text
        ,sta.sta_dim3_text                                                   sta_dim3_text
        ,sta.sta_min_quantity                                                sta_min_quantity
        ,sta.sta_max_quantity                                                sta_max_quantity
        ,sta.sta_rogue_flag                                                  sta_rogue_flag
        ,sta.sta_labour_units                                                sta_labour_units
        ,NVL(tmi.tmi_default_quantity,0)                                     boq_est_dim1
        ,DECODE(sta.sta_dim2_text,NULL,NULL,1)                               boq_est_dim2
        ,DECODE(sta.sta_dim3_text,NULL,NULL,1)                               boq_est_dim3
        ,NVL(tmi.tmi_default_quantity,0)                                     boq_est_quantity
        ,sta.sta_rate                                                        boq_est_rate
        ,ROUND(sta.sta_rate * NVL(tmi.tmi_default_quantity,0),2)             boq_est_cost
        ,ROUND(NVL(tmi.tmi_default_quantity,0) * NVL(sta_labour_units,1),2)  boq_est_labour
    BULK COLLECT
    INTO lt_retval
    FROM standard_items         sta
        ,treatment_model_items  tmi
        ,treatment_models       tmo
        ,def_types              dty
        ,hig_admin_units        hau
        ,hig_admin_groups       hag
   WHERE hag.hag_child_admin_unit   = pi_admin_unit
     AND hag.hag_parent_admin_unit  = hau.hau_admin_unit
     AND hau.hau_level              = lv_tremodlev
     AND hau.hau_admin_unit         = tmo.tmo_oun_org_id
     AND tmo.tmo_tre_treat_code     = pi_treat_code
     AND tmo.tmo_atv_acty_area_code = pi_atv_acty_area_code
     AND tmo.tmo_dty_defect_code    = pi_defect_code
     AND tmo.tmo_sys_flag           = pi_sys_flag
     AND tmo.tmo_dty_defect_code    = dty.dty_defect_code
     AND tmo.tmo_atv_acty_area_code = dty.dty_atv_acty_area_code
     AND tmo.tmo_sys_flag           = dty.dty_dtp_flag
     AND tmo.tmo_id                 = tmi.tmi_tmo_id
     AND tmi.tmi_sta_item_code      = sta.sta_item_code
   ORDER
      BY sta.sta_item_code
       ;
  --
--nm_debug.debug('records returned      : '||to_char(lt_retval.count));
  po_results := lt_retval;
  --
--nm_debug.debug_off;
EXCEPTION
  WHEN NO_DATA_FOUND
    THEN po_results := lt_retval;
  WHEN OTHERS
    THEN RAISE;
END get_tre_boqs;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_defects_created(pi_batch_id IN     activities_report.are_batch_id%TYPE
                             ,po_results  IN OUT defects_tab) IS
  --
  lt_def_inv_tab def_inv_tab;
  lr_iit_rec     nm_inv_items_all%ROWTYPE;
  lt_retval      defects_tab;
  lv_inv_type    nm_inv_types_all.nit_inv_type%TYPE;
  --
BEGIN
  --
  SELECT def_defect_id
        ,def_iit_item_id
        ,def_ity_inv_code
        ,rep_date_due
    BULK COLLECT
    INTO lt_def_inv_tab
    FROM repairs
        ,defects
        ,activities_report
   WHERE are_batch_id = pi_batch_id
     AND are_report_id = def_are_report_id
     AND def_defect_id = rep_def_defect_id
     AND rep_action_cat = 'P'
       ;
  --
  FOR i IN 1 .. lt_def_inv_tab.count LOOP
    /*
    ||Check For FT Asset.
    */
    lv_inv_type := translate_mai_inv_type(lt_def_inv_tab(i).def_ity_inv_code);
    IF nm3get.get_nit(lv_inv_type).nit_table_name IS NOT NULL
     THEN
        lt_retval(i).iit_inv_type    := lv_inv_type;
        lt_retval(i).nit_descr       := nm3inv.get_inv_type(lv_inv_type).nit_descr;
        lt_retval(i).iit_descr       := NULL;
        lt_retval(i).iit_primary_key := lt_def_inv_tab(i).def_iit_item_id;
        lt_retval(i).def_defect_id   := lt_def_inv_tab(i).def_defect_id;
        lt_retval(i).rep_date_due    := lt_def_inv_tab(i).rep_date_due;
    ELSE
        lr_iit_rec := nm3inv.get_inv_item_all(lt_def_inv_tab(i).def_iit_item_id);
        --
        lt_retval(i).iit_inv_type    := lv_inv_type;
        lt_retval(i).nit_descr       := nm3inv.get_inv_type(lv_inv_type).nit_descr;
        lt_retval(i).iit_descr       := lr_iit_rec.iit_descr;
        lt_retval(i).iit_primary_key := lr_iit_rec.iit_primary_key;
        lt_retval(i).def_defect_id   := lt_def_inv_tab(i).def_defect_id;
        lt_retval(i).rep_date_due    := lt_def_inv_tab(i).rep_date_due;
    END IF;
    --
  END LOOP;
  --
  po_results := lt_retval;
  --
EXCEPTION
  WHEN NO_DATA_FOUND
    THEN po_results := lt_retval;
  WHEN OTHERS
    THEN RAISE;
END get_defects_created;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_net_defect_created(pi_batch_id IN     activities_report.are_batch_id%TYPE
                                ,po_results  IN OUT net_defects_tab) IS
  --
  lt_def_tab  def_net_tab;
  lt_retval   net_defects_tab;
  lr_ne       nm_elements%ROWTYPE;
  --
BEGIN
  --
  SELECT def_defect_id
        ,def_rse_he_id
        ,def_easting
        ,def_northing
        ,rep_date_due
    BULK COLLECT
    INTO lt_def_tab
    FROM repairs
        ,defects
        ,activities_report
   WHERE are_batch_id   = pi_batch_id
     AND are_report_id  = def_are_report_id
     AND def_defect_id  = rep_def_defect_id
     AND rep_action_cat = 'P'
       ;
  --
  FOR i IN 1 .. lt_def_tab.count LOOP
    --
    lr_ne := nm3net.get_ne(lt_def_tab(i).def_rse_he_id);
    --
    lt_retval(i).ne_unique     := lr_ne.ne_unique;
    lt_retval(i).ne_descr      := lr_ne.ne_descr;
    lt_retval(i).def_defect_id := lt_def_tab(i).def_defect_id;
    lt_retval(i).def_easting   := lt_def_tab(i).def_easting;
    lt_retval(i).def_northing  := lt_def_tab(i).def_northing;
    lt_retval(i).rep_date_due  := lt_def_tab(i).rep_date_due;
    --
  END LOOP;
  --
  po_results := lt_retval;
  --
EXCEPTION
  WHEN NO_DATA_FOUND
    THEN po_results := lt_retval;
  WHEN OTHERS
    THEN RAISE;
END get_net_defect_created;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_gdo_for_mai3801(pi_batch_id   IN  activities_report.are_batch_id%TYPE
                                ,po_session_id OUT gis_data_objects.gdo_session_id%TYPE) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  --
  TYPE gdo_rec IS RECORD(gdo_session_id    gis_data_objects.gdo_session_id    %TYPE
                        ,gdo_pk_id         gis_data_objects.gdo_pk_id         %TYPE
                        ,gdo_rse_he_id     gis_data_objects.gdo_rse_he_id     %TYPE
                        ,gdo_st_chain      gis_data_objects.gdo_st_chain      %TYPE
                        ,gdo_end_chain     gis_data_objects.gdo_end_chain     %TYPE
                        ,gdo_x_val         gis_data_objects.gdo_x_val         %TYPE
                        ,gdo_y_val         gis_data_objects.gdo_y_val         %TYPE
                        ,gdo_theme_name    gis_data_objects.gdo_theme_name    %TYPE
                        ,gdo_feature_id    gis_data_objects.gdo_feature_id    %TYPE
                        ,gdo_xsp           gis_data_objects.gdo_xsp           %TYPE
                        ,gdo_offset        gis_data_objects.gdo_offset        %TYPE
                        ,gdo_seq_no        gis_data_objects.gdo_seq_no        %TYPE
                        ,gdo_dynamic_theme gis_data_objects.gdo_dynamic_theme %TYPE
                        ,gdo_string        gis_data_objects.gdo_string        %TYPE);
  TYPE gdo_tab IS TABLE OF gdo_rec INDEX BY BINARY_INTEGER;
  lt_gdo gdo_tab;
  --
  lv_session_id gis_data_objects.gdo_session_id%TYPE;
  lv_theme_id   nm_themes_all.nth_theme_id%TYPE := hig.get_user_or_sys_opt('SDODEFNTH');
  lv_theme_name nm_themes_all.nth_theme_name%TYPE;
  --
BEGIN
  --
  SELECT NULL          -- gdo_session_id
        ,def_defect_id -- gdo_pk_id
        ,NULL          -- gdo_rse_he_id
        ,NULL          -- gdo_st_chain
        ,NULL          -- gdo_end_chain
        ,0             -- gdo_x_val
        ,0             -- gdo_y_val
        ,NULL          -- gdo_theme_name
        ,NULL          -- gdo_feature_id
        ,NULL          -- gdo_xsp
        ,NULL          -- gdo_offset
        ,0             -- gdo_seq_no
        ,'N'           -- gdo_dynamic_theme
        ,NULL          -- gdo_string
    BULK COLLECT
    INTO lt_gdo
    FROM defects
        ,activities_report
   WHERE are_batch_id  = pi_batch_id
     AND are_report_id = def_are_report_id
       ;
  --
  BEGIN
    IF lt_gdo.count > 0
     THEN
        SELECT gis_session_id.nextval
          INTO lv_session_id
          FROM dual
             ;
    END IF;
  EXCEPTION
   WHEN no_data_found
    THEN
       RAISE_APPLICATION_ERROR(-20001,'Cannot Get Next GDO_SESSION_ID');
   WHEN others
    THEN
       RAISE;
  END;
  --
  BEGIN
    IF lt_gdo.count > 0
     THEN
        SELECT nth_theme_name
          INTO lv_theme_name
          FROM nm_themes_all
         WHERE nth_theme_id = lv_theme_id
             ;
    END IF;
  EXCEPTION
   WHEN no_data_found
    THEN
       RAISE_APPLICATION_ERROR(-20002,'Please Set The User/Product Option SDODEFNTH To The Id Of A Valid Defect Layer.');
   WHEN others
    THEN
       RAISE;
  END;
  --
  FOR i IN 1..lt_gdo.count LOOP
    --
    lt_gdo(i).gdo_session_id := lv_session_id;
    lt_gdo(i).gdo_theme_name := lv_theme_name;
    --
  END LOOP;
  --
  FORALL i IN 1..lt_gdo.count
    INSERT
      INTO gis_data_objects
    VALUES lt_gdo(i)
         ;
  --
  COMMIT;
  --
  po_session_id := lv_session_id;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RAISE_APPLICATION_ERROR(-20003,'No Defects Found For Batch Id ['
                                     ||TO_CHAR(pi_batch_id)||'].');
  WHEN others
   THEN
      RAISE;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION create_doc_assocs (
    p_table_name      IN  doc_assocs.das_table_name%TYPE
    ,p_rec_id         IN  doc_assocs.das_rec_id%TYPE
    ,p_doc_id         IN  doc_assocs.das_doc_id%TYPE
) RETURN NUMBER IS

  insert_error  EXCEPTION;

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
    p_table_name      IN  doc_assocs.das_table_name%TYPE
    ,p_rec_id         IN  doc_assocs.das_rec_id%TYPE
    ,p_doc_id         IN  doc_assocs.das_doc_id%TYPE
) RETURN NUMBER IS

  delete_error  EXCEPTION;

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
  ( a_object_name IN  VARCHAR2
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
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  IF hig.get_sysopt('ICBFGAC') = 'Y' THEN
    set_context(g_context, 'Agency', get_icb_fgac_context(Top,''));
    --DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', get_icb_fgac_context(Top,''));
  END IF;
  --
  RETURN MAI.GET_ICB_FGAC_CONTEXT(Top,NULL);
END;

FUNCTION GET_ICB_FGAC_CONTEXT(lc_agency VARCHAR2) RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  IF hig.get_sysopt('ICBFGAC') = 'Y' THEN
    set_context(g_context, 'Agency', lc_agency);
    --DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', lc_agency);
  END IF;
  --
  RETURN MAI.GET_ICB_FGAC_CONTEXT(FALSE, lc_agency);
END;

FUNCTION ICB_FGAC_PREDICATE(schema_in VARCHAR2,
                            name_in   VARCHAR2)
                             RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
      --IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
      IF get_context(g_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      RETURN 'icb_agency_code = NVL(SYS_CONTEXT('''||g_context||''',''AGENCY''),icb_agency_code)';
END;

FUNCTION ICB_BUDGET_FGAC_PREDICATE(schema_in VARCHAR2,
                                   name_in   VARCHAR2)
                                   RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
      --IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
      IF get_context(g_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      RETURN 'bud_agency = NVL(SYS_CONTEXT('''||g_context||''',''AGENCY''),bud_agency)';
END;

FUNCTION ICB_WO_FGAC_PREDICATE(schema_in VARCHAR2,
                               name_in   VARCHAR2)
                               RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
      --
      --IF SYS_CONTEXT(c_context,'AGENCY') IS NULL THEN
      IF get_context(g_context,'AGENCY') IS NULL THEN
        lc_dummy := get_icb_fgac_context(FALSE);
      END IF;
      --
      IF get_icb_fgac_context(FALSE) IS NULL THEN
        RETURN '1 = 1';
      ELSE
        RETURN 'wor_agency = SYS_CONTEXT('''||g_context||''',''AGENCY'')';
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

   l_adsp_rowid       adsp_rowid;
   l_adsp_attrib      adsp_attrib;
   l_adsp_cntrl_value     adsp_cntrl_value;

   cur_string         VARCHAR2(30000) := NULL;
   cur_string_x       VARCHAR2(30000) := NULL;
   v_priority         defect_priorities.dpr_priority%TYPE;

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
-----------------------------------------------------------------------------
--
FUNCTION get_view_name (p_inv_code IN inv_item_types.ity_inv_code%TYPE
                       ,p_sys_flag IN inv_item_types.ity_sys_flag%TYPE) RETURN varchar2 IS
BEGIN
   RETURN 'BPR_'||p_sys_flag||p_inv_code;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION asset_is_located(p_inv_type  nm_inv_types_all.nit_inv_type%TYPE
                         ,p_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE) RETURN BOOLEAN IS
  --
  CURSOR chk_locn(cp_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE)
      IS
  SELECT 1
    FROM road_sections
   WHERE rse_he_id IN(SELECT nm_ne_id_in  /* Section Is A Group Of ESU Datums  */
                        FROM nm_members   /* With Assets Located On The ESUs   */
                       WHERE nm_type = 'G'
                         AND nm_ne_id_of in(SELECT nm_ne_id_of
                                              FROM nm_members
                                           CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in
                                             START WITH nm_ne_id_in = cp_iit_ne_id)
                       UNION
                      SELECT nm_ne_id_of  /* Section Is A Datum                  */
                        FROM nm_members   /* With Assets Located On The Sections */
                     CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in
                       START WITH nm_ne_id_in = cp_iit_ne_id)
       ;
  --
  lv_dummy  NUMBER(1);
  lv_retval BOOLEAN := FALSE;
  lv_tab_name  nm_inv_types.nit_table_name%TYPE := nm3get.get_nit(p_inv_type).nit_table_name;
  --
BEGIN
  /*
  || If Not A Foreign Table Asset Then Check NM_MEMBERS For A Location.
  */
  IF lv_tab_name IS NULL
   THEN
      OPEN  chk_locn(p_iit_ne_id);
      FETCH chk_locn
       INTO lv_dummy;
      lv_retval := chk_locn%FOUND;
      CLOSE chk_locn;
  END IF;
  --
  RETURN lv_retval;
  --
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_budget_allocation(p_inv_type  nm_inv_types_all.nit_inv_type%TYPE
                              ,p_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE) RETURN nm_elements_all.ne_id%TYPE IS
  --
  CURSOR chk_locn(cp_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE)
      IS
  SELECT rse_he_id
    FROM road_sections
   WHERE rse_he_id IN(SELECT nm_ne_id_in  /* Section Is A Group Of ESU Datums  */
                        FROM nm_members   /* With Assets Located On The ESUs   */
                       WHERE nm_type = 'G'
                         AND nm_ne_id_of in(SELECT nm_ne_id_of
                                              FROM nm_members
                                           CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in
                                             START WITH nm_ne_id_in = cp_iit_ne_id)
                       UNION
                      SELECT nm_ne_id_of  /* Section Is A Datum                  */
                        FROM nm_members   /* With Assets Located On The Sections */
                     CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in
                       START WITH nm_ne_id_in = cp_iit_ne_id)
       ;
  --
  CURSOR get_criteria(cp_inv_type  nm_inv_types_all.nit_inv_type%TYPE
                     ,cp_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE)
      IS
  SELECT mba_ne_id
        ,'SELECT '||DECODE(nit_table_name,NULL,'IIT_NE_ID',nit_foreign_pk_column)
         ||' FROM '||DECODE(nit_table_name,NULL,'NM_INV_ITEMS_ALL',nit_table_name)
         ||' WHERE '||DECODE(nit_table_name,NULL,'IIT_INV_TYPE = '||nm3flx.string(cp_inv_type)||' AND IIT_NE_ID = '||cp_iit_ne_id
                                           ,nit_foreign_pk_column||' = '||cp_iit_ne_id)
         ||DECODE(mba_criteria, NULL, NULL,' AND '||mba_criteria) test_str
    FROM mai_budget_allocations
        ,nm_inv_types_all
   WHERE nit_inv_type = cp_inv_type
     AND nit_inv_type = mba_nit_inv_type
       ;
  --
  lv_cursor_id INTEGER;
  lv_row_count INTEGER;
  lv_dummy     nm_inv_items_all.iit_ne_id%TYPE;
  lv_retval    nm_elements_all.ne_id%TYPE;
  lv_tab_name  nm_inv_types.nit_table_name%TYPE := nm3get.get_nit(p_inv_type).nit_table_name;
  --
BEGIN
  /*
  ||If Not FT Asset Then Check That Item Is Not Located
  */
  nm_debug.debug_on;
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_budget_allocation');
  nm_debug.debug('Checking Network, p_inv_type : '||p_inv_type||' p_iit_ne_id : '||to_char(p_iit_ne_id));
  IF lv_tab_name IS NULL
   THEN
      OPEN  chk_locn(p_iit_ne_id);
      FETCH chk_locn
       INTO lv_retval;
      IF chk_locn%NOTFOUND
       THEN
          lv_retval := NULL;
      END IF;
  CLOSE chk_locn;
  END IF;
  nm_debug.debug('Net Check Returned : '||to_char(lv_retval));
  /*
  ||Item Is Not Located So Get The Dummy Element.
  */
  IF lv_retval IS NULL
   THEN
      --
      FOR cur_rec IN get_criteria(p_inv_type,p_iit_ne_id) LOOP
        nm_debug.debug(cur_rec.test_str);
        --
        lv_dummy := NULL;
        --
        higgri.parse_query(cur_rec.test_str,lv_cursor_id);
        --
        DBMS_SQL.DEFINE_COLUMN(lv_cursor_id,1,lv_dummy);
        --
        lv_row_count := DBMS_SQL.EXECUTE(lv_cursor_id);
        nm_debug.debug('Rowcount : '||to_char(lv_row_count));
        --
        LOOP
          --
          IF DBMS_SQL.FETCH_ROWS(lv_cursor_id) > 0
           THEN
              --
              DBMS_SQL.COLUMN_VALUE(lv_cursor_id,1,lv_dummy);
              --
              IF lv_dummy IS NOT NULL AND lv_retval IS NULL
               THEN
                  lv_retval := cur_rec.mba_ne_id;
              ELSIF lv_dummy IS NOT NULL AND lv_retval IS NOT NULL
               THEN
                  /*
                  ||More Than One Match Found.
                  */
                  hig.raise_ner(nm3type.c_mai,901);
              ELSE
                  /*
                  ||No Match Found.
                  */
                  hig.raise_ner(nm3type.c_mai,902);
              END IF;
              --
          ELSE
              --
              EXIT;
              --
          END IF;
          --
        END LOOP;
        --
        DBMS_SQL.CLOSE_CURSOR(lv_cursor_id);
        --
      END LOOP;
  END IF;
  --
  IF lv_retval IS NULL
   THEN
      /*
      ||No Match Found.
      */
      hig.raise_ner(nm3type.c_mai,902);
  ELSE
     RETURN lv_retval;
  END IF;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_budget_allocation');
  nm_debug.debug_off;
  --
EXCEPTION
  WHEN OTHERS
    THEN
       RAISE;
END get_budget_allocation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_budget_allocation(p_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE) RETURN nm_elements_all.ne_id%TYPE IS
  --
  lv_retval    nm_elements_all.ne_id%TYPE;
  --
BEGIN
  --
  lv_retval := get_budget_allocation(nm3inv.get_inv_type_all(p_iit_ne_id),p_iit_ne_id);
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN OTHERS
    THEN
       RAISE;
END get_budget_allocation;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_nm_inv_type(p_inv_type nm_inv_types_all.nit_inv_type%TYPE) RETURN inv_type_translations.ity_inv_code%TYPE IS
  --
  CURSOR get_inv_code(cp_inv_type nm_inv_types_all.nit_inv_type%TYPE)
      IS
  SELECT ity_inv_code
    FROM inv_type_translations
   WHERE nit_inv_type = cp_inv_type
       ;
  --
  lv_retval inv_type_translations.ity_inv_code%TYPE;
  --
BEGIN
  --
  OPEN  get_inv_code(p_inv_type);
  FETCH get_inv_code
   INTO lv_retval;
  IF get_inv_code%NOTFOUND
   THEN
      lv_retval := NULL;
  END IF;
  CLOSE get_inv_code;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN OTHERS
    THEN
       RAISE;
END translate_nm_inv_type;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_mai_inv_type(p_inv_type inv_type_translations.ity_inv_code%TYPE) RETURN inv_type_translations.nit_inv_type%TYPE IS
  --
  CURSOR get_inv_code(cp_inv_type inv_type_translations.ity_inv_code%TYPE)
      IS
  SELECT nit_inv_type
    FROM inv_type_translations
   WHERE ity_inv_code = cp_inv_type
       ;
  --
  lv_retval inv_type_translations.nit_inv_type%TYPE;
  --
BEGIN
  --
  OPEN  get_inv_code(p_inv_type);
  FETCH get_inv_code
   INTO lv_retval;
  IF get_inv_code%NOTFOUND
   THEN
      lv_retval := NULL;
  END IF;
  CLOSE get_inv_code;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN OTHERS
    THEN
       RAISE;
END translate_mai_inv_type;
--
-----------------------------------------------------------------------------
--
FUNCTION budget_allocation_used(p_nit_inv_type nm_inv_types_all.nit_inv_type%TYPE
                               ,p_ne_id        nm_elements_all.ne_id%TYPE) RETURN BOOLEAN IS
  --
  CURSOR mba_used(cp_nit_inv_type nm_inv_types_all.nit_inv_type%TYPE
                 ,cp_ne_id        nm_elements_all.ne_id%TYPE)
      IS
  SELECT 1
    FROM mai_budget_allocations
   WHERE mba_nit_inv_type = cp_nit_inv_type
     AND mba_ne_id = cp_ne_id
       ;
  --
  lv_dummy  NUMBER;
  lv_retval BOOLEAN := FALSE;
  --
BEGIN
  --
  OPEN  mba_used(p_nit_inv_type,p_ne_id);
  FETCH mba_used
   INTO lv_dummy;
  IF mba_used%FOUND
   THEN
      lv_retval := TRUE;
  END IF;
  CLOSE mba_used;
  --
  RETURN lv_retval;
  --
END budget_allocation_used;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE get_def_asset_fields(pi_nit_inv_type IN  nm_inv_types_all.nit_inv_type%TYPE
                              ,pi_iit_ne_id    IN  nm_inv_items_all.iit_ne_id%TYPE
                              ,po_iit_primary  OUT VARCHAR2
                              ,po_iit_descr    OUT VARCHAR2) IS
  --
  CURSOR get_nm_item(cp_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE)
      IS
  SELECT iit_primary_key
        ,iit_descr
    FROM nm_inv_items_all
   WHERE iit_ne_id = cp_iit_ne_id
       ;
  --
  lv_tab_name    nm_inv_types.nit_table_name%TYPE := nm3get.get_nit(pi_nit_inv_type).nit_table_name;
  lv_iit_primary nm_inv_items_all.iit_primary_key%TYPE;
  lv_iit_descr   nm_inv_items_all.iit_descr%TYPE;
  --
BEGIN
  --
  IF lv_tab_name IS NOT NULL  -- FT ASSET
   THEN
      lv_iit_primary := pi_iit_ne_id;
      lv_iit_descr   := NULL;
  ELSE
      OPEN  get_nm_item(pi_iit_ne_id);
      FETCH get_nm_item
       INTO lv_iit_primary
           ,lv_iit_descr;
      CLOSE get_nm_item;
  END IF;
  --
  po_iit_primary := lv_iit_primary;
  po_iit_descr   := lv_iit_descr;
  --
END get_def_asset_fields;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm3extent_c_route RETURN nm_pbi_query_results.nqr_source%TYPE IS
BEGIN
  --
  RETURN nm3extent.c_route;
  --
END get_nm3extent_c_route;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm3extent_c_roi_temp_ne RETURN VARCHAR2 IS
BEGIN
  --
  RETURN nm3extent.c_roi_temp_ne;
  --
END get_nm3extent_c_roi_temp_ne;
--
-----------------------------------------------------------------------------
--
FUNCTION get_gis_sys_flag(p_gis_session_id IN gis_data_objects.gdo_session_id%TYPE) RETURN VARCHAR2 IS
  --
  CURSOR get_flag(cp_gis_session_id gis_data_objects.gdo_session_id%TYPE)
      IS
  SELECT NVL(def_ity_sys_flag,rse_sys_flag) sys_flag
    FROM road_sections
        ,defects
        ,gis_data_objects
   WHERE gdo_session_id = cp_gis_session_id
     AND gdo_pk_id      = def_defect_id
     AND def_rse_he_id  = rse_he_id
       ;
  --
  lv_retval VARCHAR2(1);
  --
BEGIN
  --
  OPEN  get_flag(p_gis_session_id);
  FETCH get_flag
   INTO lv_retval;
  IF get_flag%NOTFOUND
   THEN
      lv_retval := NULL;
  END IF;
  CLOSE get_flag;
  --
  RETURN lv_retval;
  --
END get_gis_sys_flag;
--
---------------------------------------------------------------------------------------------------
--
  PROCEDURE make_defect_secure_view
  IS
    nl                           VARCHAR2(10)               := CHR(10);
  BEGIN
    --------------------------------------------------------------
    -- Create an admin unit restricted view to base the theme on
    --------------------------------------------------------------
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW V_NM_MAI_DEFECTS '||nl||
                      'AS  '||nl||
                      'SELECT * FROM DEFECTS '||nl||
                      '   WHERE EXISTS  '||nl||
                      '         (SELECT '||Nm3flx.string('EXISTS')||nl||
                      '            FROM hig_admin_units o '||nl||
                      '               , HIG_USERS h  '||nl||
                      '               , hig_admin_groups a  '||nl||
                      '               , road_sections rse1  '||nl||
                      '           WHERE h.hus_username = USER  '||nl||
                      '             AND a.hag_parent_admin_unit = h.hus_admin_unit '||nl||
                      '             AND a.hag_child_admin_unit = o.hau_admin_unit  '||nl||
                      '             AND a.hag_direct_link = '||Nm3flx.string('N')||'  '||nl||
                      '             AND a.hag_child_admin_unit = rse1.rse_admin_unit '||nl||
                      '             AND rse1.rse_he_id = def_rse_he_id) ';

    Nm3ddl.create_synonym_for_object ('V_NM_MAI_DEFECTS');

  END make_defect_secure_view;
--
---------------------------------------------------------------------------------------------------
--
--   PROCEDURE make_defect_spatial_layer
--               ( pi_theme_name      IN NM_THEMES_ALL.nth_theme_name%TYPE
--               , pi_base_layer      IN NM_THEMES_ALL.nth_base_theme%TYPE DEFAULT NULL
--               , pi_use_xy          IN BOOLEAN DEFAULT FALSE
--               )
--   IS
--     l_theme_name                 NM_THEMES_ALL.nth_theme_name%TYPE   := UPPER(pi_theme_name);
--     l_base_theme                 NM_THEMES_ALL.nth_base_theme%TYPE   := NVL(pi_base_layer,Nm3sdo.get_base_layer);
--     l_tolerance                  NM_THEMES_ALL.nth_tolerance%TYPE    := 10;
--     l_tolerance_units            NM_THEMES_ALL.nth_tol_units%TYPE    := 1;
--     l_rec_nth                    NM_THEMES_ALL%ROWTYPE;
--     l_rec_nth_v                  NM_THEMES_ALL%ROWTYPE;
--     l_rec_ntg                    NM_THEME_GTYPES%ROWTYPE;
--     l_rec_ntg_v                  NM_THEME_GTYPES%ROWTYPE;
--     l_rec_nthr                   NM_THEME_ROLES%ROWTYPE;
--     l_mai_view_sql               Nm3type.max_varchar2;
--     l_mai_sdo_view_sql           Nm3type.max_varchar2;
--     nl                           VARCHAR2(10)               := CHR(10);
--     l_dummy                      PLS_INTEGER;
--     e_create_view_fail           EXCEPTION;
--     e_create_sdo_view_fail       EXCEPTION;
--     e_create_theme_fail          EXCEPTION;
--     e_create_view_theme_fail     EXCEPTION;
--     e_create_sdo_from_locl       EXCEPTION;
--     e_create_view_sdo_mdata_fail EXCEPTION;
--     e_creating_sdo_trigger       EXCEPTION;
--   --
--   BEGIN
--   --
--     BEGIN
--         make_defect_secure_view;
--     EXCEPTION
--         WHEN OTHERS THEN RAISE e_create_view_fail;
--     END;
--   --
--   --------------------------------------------------------------
--   -- Create theme  nm_themes_all
--   --------------------------------------------------------------
--     l_rec_nth.nth_theme_id                 := Nm3seq.next_nth_theme_id_seq;
--     l_rec_nth.nth_theme_name               := l_theme_name||'_TAB';
--     l_rec_nth.nth_table_name               := 'DEFECTS';
--     l_rec_nth.nth_pk_column                := 'DEF_DEFECT_ID';
--     l_rec_nth.nth_label_column             := 'DEF_DEFECT_ID';
--     l_rec_nth.nth_rse_table_name           := 'ROAD_SECTIONS';
--     l_rec_nth.nth_rse_fk_column            := 'DEF_RSE_HE_ID';
--     l_rec_nth.nth_st_chain_column          := 'DEF_ST_CHAIN';
--     l_rec_nth.nth_end_chain_column         := NULL;
--
--     IF pi_use_xy
--       THEN
--       l_rec_nth.nth_x_column                 := 'DEF_EASTING';
--       l_rec_nth.nth_y_column                 := 'DEF_NORTHING';
--       l_rec_nth.nth_where                    := 'DEF_EASTING IS NOT NULL AND DEF_NORTHING IS NOT NULL';
--     ELSE
--       l_rec_nth.nth_x_column                 := NULL;
--       l_rec_nth.nth_y_column                 := NULL;
--       l_rec_nth.nth_where                    := 'DEF_ST_CHAIN IS NOT NULL';
--     END IF;
--
--     l_rec_nth.nth_offset_field             := NULL;
--     l_rec_nth.nth_feature_table            := 'NM_MAI_DEFECTS_SDO';
--     l_rec_nth.nth_feature_pk_column        := 'DEF_DEFECT_ID';
--     l_rec_nth.nth_feature_fk_column        := 'DEF_RSE_HE_ID';
--     l_rec_nth.nth_xsp_column               := NULL;
--     l_rec_nth.nth_feature_shape_column     := 'GEOLOC';
--     l_rec_nth.nth_hpr_product              := 'MAI';
--     l_rec_nth.nth_location_updatable       := 'Y';
--     l_rec_nth.nth_theme_type               := 'LOCL';
--     l_rec_nth.nth_base_theme               := l_base_theme;
--     l_rec_nth.nth_dependency               := 'I';
--     l_rec_nth.nth_storage                  := 'S';
--     l_rec_nth.nth_update_on_edit           := 'I';
--     l_rec_nth.nth_use_history              := 'N';--'Y';
--     l_rec_nth.nth_start_date_column        := NULL;--'DEF_START_DATE';
--     l_rec_nth.nth_end_date_column          := NULL;--'DEF_END_DATE';
--     l_rec_nth.nth_base_table_theme         := NULL;
--     l_rec_nth.nth_sequence_name            := 'NTH_'||TO_CHAR(l_rec_nth.nth_theme_id)||'_SEQ';
--     l_rec_nth.nth_snap_to_theme            := 'S';
--     l_rec_nth.nth_lref_mandatory           := 'Y';
--     l_rec_nth.nth_tolerance                := l_tolerance;
--     l_rec_nth.nth_tol_units                := l_tolerance_units;
--   --
--     l_rec_ntg.ntg_theme_id                 := l_rec_nth.nth_theme_id;
--     l_rec_ntg.ntg_gtype                    := '2001';
--     l_rec_ntg.ntg_seq_no                   := 1;
--   --
--     BEGIN
--       Nm3ins.ins_nth ( l_rec_nth );
--       Nm3ins.ins_ntg ( l_rec_ntg );
--     EXCEPTION
--       WHEN OTHERS
--         THEN ROLLBACK;
--         RAISE ;--e_create_theme_fail;
--     END;
--   --
--   --------------------------------------------------------------
--   -- Create sdo layer from locl theme
--   --------------------------------------------------------------
--   --
--     BEGIN
--       Nm3sdo.create_sdo_layer_from_locl (l_rec_nth.nth_theme_id);
--     EXCEPTION
--       WHEN OTHERS
--         THEN RAISE;-- e_create_sdo_from_locl;
--     END;
--   --------------------------------------------------------------
--   -- Create a spatial joined view
--   --------------------------------------------------------------
--   --
--     l_mai_sdo_view_sql := ' CREATE OR REPLACE VIEW V_NM_MAI_DEFECTS_SDO'||nl||
--                           ' AS '||nl||
--                           '  (SELECT a.* '||nl||
--                           '        , b.geoloc '||nl||
--                           '     FROM v_nm_mai_defects a '||nl||
--                           '        , nm_mai_defects_sdo b '||nl||
--                           '    WHERE a.def_defect_id = b.def_defect_id ) ';
--     BEGIN
--       EXECUTE IMMEDIATE l_mai_sdo_view_sql;
--       Nm3ddl.create_synonym_for_object ('V_NM_MAI_DEFECTS_SDO');
--     EXCEPTION
--       WHEN OTHERS
--         THEN RAISE e_create_sdo_view_fail;
--     END;
--   ---------------------------------------------------------------
--   -- Create a theme for the view
--   ---------------------------------------------------------------
--   --
--     l_rec_nth_v := l_rec_nth;
--   --
--     l_rec_nth_v.nth_theme_id               := Nm3seq.next_nth_theme_id_seq;
--     l_rec_nth_v.nth_theme_name             := l_theme_name;
--     l_rec_nth_v.nth_table_name             := 'V_NM_MAI_DEFECTS';
--     l_rec_nth_v.nth_feature_table          := 'V_NM_MAI_DEFECTS_SDO';
--     l_rec_nth_v.nth_theme_type             := 'SDO';
--     l_rec_nth_v.nth_base_table_theme       := l_rec_nth.nth_theme_id;
--   --
--     l_rec_ntg_v.ntg_theme_id               := l_rec_nth_v.nth_theme_id;
--     l_rec_ntg_v.ntg_gtype                  := '2001';
--     l_rec_ntg_v.ntg_seq_no                 := 1;
--   --
--     BEGIN
--       Nm3ins.ins_nth ( l_rec_nth_v );
--       Nm3ins.ins_ntg ( l_rec_ntg_v );
--     EXCEPTION
--       WHEN OTHERS
--         THEN ROLLBACK;
--         RAISE e_create_view_theme_fail;
--     END;
--   --
--   ---------------------------------------------------------------
--   -- Create SDO metadata for view theme
--   ---------------------------------------------------------------
--     BEGIN
--       l_dummy := Nm3sdo.create_sdo_layer
--                    ( pi_table_name   => l_rec_nth_v.nth_feature_table
--                    , pi_column_name  => l_rec_nth_v.nth_feature_shape_column
--                    , pi_gtype        => l_rec_ntg_v.ntg_gtype);
--     EXCEPTION
--       WHEN OTHERS
--         THEN RAISE e_create_view_sdo_mdata_fail;
--     END;
--   ---------------------------------------------------------------
--   -- Create a theme role - this will copy metadata to subordinate
--   -- users if SDMREGULAY is set, and users have the END_USER role
--   ----------------------------------------------------------------
--   --
--     l_rec_nthr.nthr_theme_id  := l_rec_nth_v.nth_theme_id;
--     l_rec_nthr.nthr_role      := 'MAI_USER';
--     l_rec_nthr.nthr_mode      := 'NORMAL';
--   --
--     Nm3ins.ins_nthr ( l_rec_nthr );
--   --
--   ----------------------------------------------------------------
--   --  Create Triggers to maintain shapes
--   ----------------------------------------------------------------
--   --
--     BEGIN
--       Nm3sdm.create_nth_sdo_trigger ( l_rec_nth_v.nth_theme_id );
--     NULL;
--     EXCEPTION
--       WHEN OTHERS
--         THEN RAISE e_creating_sdo_trigger;
--     END;
--   --
--   EXCEPTION
--     WHEN e_create_view_fail
--       THEN RAISE_APPLICATION_ERROR (-20411, 'Error creating defects view - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_create_theme_fail
--       THEN RAISE_APPLICATION_ERROR (-20412, 'Error creating defects theme - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_create_sdo_view_fail
--       THEN RAISE_APPLICATION_ERROR (-20413, 'Error creating sdo view - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_create_sdo_from_locl
--       THEN RAISE_APPLICATION_ERROR (-20414, 'Error creating defects layer from local theme - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_create_view_theme_fail
--       THEN RAISE_APPLICATION_ERROR (-20415, 'Error creating defects view theme - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_create_view_sdo_mdata_fail
--       THEN RAISE_APPLICATION_ERROR (-20416, 'Error creating defects view SDO metadata - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN e_creating_sdo_trigger
--       THEN RAISE_APPLICATION_ERROR (-20417, 'Error creating sdo triggers for defects theme - '
--                                             ||SQLCODE||'-'||SQLERRM);
--     WHEN OTHERS
--       THEN ROLLBACK; RAISE;
--   END make_defect_spatial_layer;
--
---------------------------------------------------------------------------------------------------
--
  FUNCTION generate_works_order_no( p_con_id         IN contracts.con_id%type
                                  , p_admin_unit     IN hig_admin_units.hau_admin_unit%type
                                  , p_worrefgen      IN varchar2 DEFAULT hig.get_user_or_sys_opt('WORREFGEN')
								  , p_raise_not_found IN BOOLEAN DEFAULT FALSE
                                   ) RETURN VARCHAR2 IS
  cursor c1 is
    select con_code
          ,nvl(con_last_wor_no,0) + 1
    from   contracts
    where  con_id = p_con_id
    for    update of con_last_wor_no
           nowait;
--
  cursor c2 is
    select hau_unit_code
          ,nvl(hau_last_wor_no,0) + 1
    from   hig_admin_units
    where  hau_admin_unit = p_admin_unit
    for    update of hau_last_wor_no
           nowait;

--
  l_wor_no      work_orders.wor_works_order_no%type;
  l_con_code    contracts.con_code%type;
  l_con_wor_no  contracts.con_last_wor_no%type;
  l_unit_code   hig_admin_units.hau_unit_code%type;
  l_hau_wor_no  hig_admin_units.hau_last_wor_no%type;
  record_locked exception;
  pragma        exception_init(record_locked, -54);
  nm_error      exception;
  l_error       number;
begin
  if p_worrefgen = 'C' then
    open  c1;
    fetch c1 into l_con_code
                 ,l_con_wor_no;
    if c1%found then
      if length(l_con_code||'/'||to_char(l_con_wor_no)) > 16 then
        l_error := '291';
        raise nm_error;
        --plib$error(291, 'M_MGR'); -- error in generating WO no
        --plib$fail;
      end if;
      l_wor_no := l_con_code||'/'||to_char(l_con_wor_no);
      update contracts
      set    con_last_wor_no = nvl(con_last_wor_no, 0) + 1
      where  current of c1;
    end if;
    close c1;
    return l_wor_no;
  elsif p_worrefgen = 'A' then
    open  c2;
    fetch c2 into l_unit_code
                 ,l_hau_wor_no;
    if c2%found then
      if length(l_unit_code||'/'||to_char(l_hau_wor_no)) > 16 then
        l_error := '291';
        raise nm_error;
        --plib$error(291, 'M_MGR'); -- error in generating WO no
        --plib$fail;
      end if;
      l_wor_no := l_unit_code||'/'||to_char(l_hau_wor_no);
      update hig_admin_units
      set    hau_last_wor_no = nvl(hau_last_wor_no, 0) + 1
      where  current of c2;
    end if;
    close c2;
  end if;

  IF l_wor_no IS NULL AND p_raise_not_found THEN
      hig.raise_ner(pi_appl => 'MAI'
	               ,pi_id   => 917);
  END IF;
  
  return l_wor_no;
exception
  when record_locked then
    l_error := 138;
    if p_worrefgen = 'C' then
      --:b1.con_code := null;
      null;
    elsif p_worrefgen = 'A' then
    null;
      --:b1.rse_group := null;
      --:b1.h_rse_admin_unit := -1;
    end if;
    raise nm_error;
  when nm_error then
    return l_wor_no;
end;

--
---------------------------------------------------------------------------------------------------
--
   FUNCTION cre_boq_items2( p_boq_work_flag      IN boq_items.boq_work_flag%TYPE
                          , p_boq_defect_id      IN boq_items.boq_defect_id%TYPE
                          , p_boq_rep_action_cat IN boq_items.boq_rep_action_cat%TYPE
                          , p_boq_wol_id         IN boq_items.boq_wol_id%TYPE
                          , p_boq_sta_item_code  IN boq_items.boq_sta_item_code%TYPE
                          , p_boq_date_created   IN boq_items.boq_date_created%TYPE
                          , p_boq_est_dim1       IN boq_items.boq_est_dim1%TYPE
                          , p_boq_est_dim2       IN boq_items.boq_est_dim2%TYPE
                          , p_boq_est_dim3       IN boq_items.boq_est_dim3%TYPE
                          , p_boq_est_quantity   IN boq_items.boq_est_quantity%TYPE
                          , p_boq_est_rate       IN boq_items.boq_est_rate%TYPE
                          , p_boq_est_cost       IN boq_items.boq_est_cost%TYPE
                          , p_boq_est_labour     IN boq_items.boq_est_labour%TYPE
                          , p_boq_id             IN boq_items.boq_id%TYPE
                          ) RETURN NUMBER IS

l_ret    NUMBER;

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
VALUES ( p_boq_work_flag
       , p_boq_defect_id
       , p_boq_rep_action_cat
       , p_boq_wol_id
       , p_boq_sta_item_code
       , p_boq_date_created
       , p_boq_est_dim1
       , p_boq_est_dim2
       , p_boq_est_dim3
       , p_boq_est_quantity
       , p_boq_est_rate
       , p_boq_est_cost
       , p_boq_est_labour
       , p_boq_id
       );

RETURN( SQL%rowcount );

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN (0);
   WHEN OTHERS THEN
      RETURN (-1);
END;
--
---------------------------------------------------------------------------------------------------
--
  FUNCTION create_wo_header
        ( P_WOR_WORKS_ORDER_NO             IN WORK_ORDERS.WOR_WORKS_ORDER_NO%TYPE
        , P_WOR_SYS_FLAG                   IN WORK_ORDERS.WOR_SYS_FLAG%TYPE
        , P_WOR_RSE_HE_ID_GROUP            IN WORK_ORDERS.WOR_RSE_HE_ID_GROUP%TYPE
        , P_WOR_FLAG                       IN WORK_ORDERS.WOR_FLAG%TYPE
        , P_WOR_CON_ID                     IN WORK_ORDERS.WOR_CON_ID%TYPE
        , P_WOR_ACT_COST_CODE              IN WORK_ORDERS.WOR_ACT_COST_CODE%TYPE
        , P_WOR_ACT_BALANCING_SUM          IN WORK_ORDERS.WOR_ACT_BALANCING_SUM%TYPE
        , P_WOR_ACT_COST                   IN WORK_ORDERS.WOR_ACT_COST%TYPE
        , P_WOR_ACT_LABOUR                 IN WORK_ORDERS.WOR_ACT_LABOUR%TYPE
        , P_WOR_AGENCY                     IN WORK_ORDERS.WOR_AGENCY%TYPE
        , P_WOR_ARE_SCHED_ACT_FLAG         IN WORK_ORDERS.WOR_ARE_SCHED_ACT_FLAG%TYPE
        , P_WOR_CHEAPEST_FLAG              IN WORK_ORDERS.WOR_CHEAPEST_FLAG%TYPE
        , P_WOR_CLOSED_BY_ID               IN WORK_ORDERS.WOR_CLOSED_BY_ID%TYPE
        , P_WOR_COC_COST_CENTRE            IN WORK_ORDERS.WOR_COC_COST_CENTRE%TYPE
        , P_WOR_COST_RECHARG               IN WORK_ORDERS.WOR_COST_RECHARG%TYPE
        , P_WOR_DATE_CLOSED                IN WORK_ORDERS.WOR_DATE_CLOSED%TYPE
        , P_WOR_DATE_CONFIRMED             IN WORK_ORDERS.WOR_DATE_CONFIRMED%TYPE
        , P_WOR_DATE_MOD                   IN WORK_ORDERS.WOR_DATE_MOD%TYPE
        , P_WOR_DATE_RAISED                IN WORK_ORDERS.WOR_DATE_RAISED%TYPE
        , P_WOR_DESCR                      IN WORK_ORDERS.WOR_DESCR%TYPE
        , P_WOR_DIV_CODE                   IN WORK_ORDERS.WOR_DIV_CODE%TYPE
        , P_WOR_DTP_EXPEND_CODE            IN WORK_ORDERS.WOR_DTP_EXPEND_CODE%TYPE
        , P_WOR_EST_BALANCING_SUM          IN WORK_ORDERS.WOR_EST_BALANCING_SUM%TYPE
        , P_WOR_EST_COMPLETE               IN WORK_ORDERS.WOR_EST_COMPLETE%TYPE
        , P_WOR_EST_COST                   IN WORK_ORDERS.WOR_EST_COST%TYPE
        , P_WOR_EST_LABOUR                 IN WORK_ORDERS.WOR_EST_LABOUR%TYPE
        , P_WOR_ICB_ITEM_CODE              IN WORK_ORDERS.WOR_ICB_ITEM_CODE%TYPE
        , P_WOR_ICB_SUB_ITEM_CODE          IN WORK_ORDERS.WOR_ICB_SUB_ITEM_CODE%TYPE
        , P_WOR_ICB_SUB_SUB_ITEM_CODE      IN WORK_ORDERS.WOR_ICB_SUB_SUB_ITEM_CODE%TYPE
        , P_WOR_JOB_NUMBER                 IN WORK_ORDERS.WOR_JOB_NUMBER%TYPE
        , P_WOR_LAST_PRINT_DATE            IN WORK_ORDERS.WOR_LAST_PRINT_DATE%TYPE
        , P_WOR_LA_EXPEND_CODE             IN WORK_ORDERS.WOR_LA_EXPEND_CODE%TYPE
        , P_WOR_MOD_BY_ID                  IN WORK_ORDERS.WOR_MOD_BY_ID%TYPE
        , P_WOR_OUN_ORG_ID                 IN WORK_ORDERS.WOR_OUN_ORG_ID%TYPE
        , P_WOR_PEO_PERSON_ID              IN WORK_ORDERS.WOR_PEO_PERSON_ID%TYPE
        , P_WOR_PRICE_TYPE                 IN WORK_ORDERS.WOR_PRICE_TYPE%TYPE
        , P_WOR_REMARKS                    IN WORK_ORDERS.WOR_REMARKS%TYPE
        , P_WOR_ROAD_TYPE                  IN WORK_ORDERS.WOR_ROAD_TYPE%TYPE
        , P_WOR_RSE_HE_ID_LINK             IN WORK_ORDERS.WOR_RSE_HE_ID_LINK%TYPE
        , P_WOR_SCHEME_REF                 IN WORK_ORDERS.WOR_SCHEME_REF%TYPE
        , P_WOR_SCHEME_TYPE                IN WORK_ORDERS.WOR_SCHEME_TYPE%TYPE
        , P_WOR_SCORE                      IN WORK_ORDERS.WOR_SCORE%TYPE
        , P_WOR_YEAR_CODE                  IN WORK_ORDERS.WOR_YEAR_CODE%TYPE
        , P_WOR_INTERIM_PAYMENT_FLAG       IN WORK_ORDERS.WOR_INTERIM_PAYMENT_FLAG%TYPE
        , P_WOR_RISK_ASSESSMENT_FLAG       IN WORK_ORDERS.WOR_RISK_ASSESSMENT_FLAG%TYPE
        , P_WOR_METHOD_STATEMENT_FLAG      IN WORK_ORDERS.WOR_METHOD_STATEMENT_FLAG%TYPE
        , P_WOR_WORKS_PROGRAMME_FLAG       IN WORK_ORDERS.WOR_WORKS_PROGRAMME_FLAG%TYPE
        , P_WOR_ADDITIONAL_SAFETY_FLAG     IN WORK_ORDERS.WOR_ADDITIONAL_SAFETY_FLAG%TYPE
        , P_WOR_DEF_CORRECTION             IN WORK_ORDERS.WOR_DEF_CORRECTION%TYPE
        , P_WOR_DEF_CORRECTION_ACCEPT      IN WORK_ORDERS.WOR_DEF_CORRECTION_ACCEPTABLE%TYPE
        , P_WOR_CORR_EXTENSION_TIME        IN WORK_ORDERS.WOR_CORR_EXTENSION_TIME%TYPE
        , P_WOR_REVISED_COMP_DATE          IN WORK_ORDERS.WOR_REVISED_COMP_DATE%TYPE
        , P_WOR_PRICE_VARIATION            IN WORK_ORDERS.WOR_PRICE_VARIATION%TYPE
        , P_WOR_COMMENCE_BY                IN WORK_ORDERS.WOR_COMMENCE_BY%TYPE
        , P_WOR_ACT_COMMENCE_BY            IN WORK_ORDERS.WOR_ACT_COMMENCE_BY%TYPE
        , P_WOR_DEF_CORRECTION_PERIOD      IN WORK_ORDERS.WOR_DEF_CORRECTION_PERIOD%TYPE
        , P_WOR_REASON_NOT_CHEAPEST        IN WORK_ORDERS.WOR_REASON_NOT_CHEAPEST%TYPE
        , P_WOR_PRIORITY                   IN WORK_ORDERS.WOR_PRIORITY%TYPE
        , P_WOR_PERC_ITEM_COMP             IN WORK_ORDERS.WOR_PERC_ITEM_COMP%TYPE
        , P_WOR_CONTACT                    IN WORK_ORDERS.WOR_CONTACT%TYPE
        , P_WOR_DATE_RECEIVED              IN WORK_ORDERS.WOR_DATE_RECEIVED%TYPE
        , P_WOR_RECEIVED_BY                IN WORK_ORDERS.WOR_RECEIVED_BY%TYPE
        , P_WOR_RECHARGEABLE               IN WORK_ORDERS.WOR_RECHARGEABLE%TYPE
        , P_WOR_SUPP_DOCUMENTS             IN WORK_ORDERS.WOR_SUPP_DOCUMENTS%TYPE
        , P_WOR_EARLIEST_START_DATE        IN WORK_ORDERS.WOR_EARLIEST_START_DATE%TYPE
        , P_WOR_PLANNED_COMP_DATE          IN WORK_ORDERS.WOR_PLANNED_COMP_DATE%TYPE
        , P_WOR_LATEST_COMP_DATE           IN WORK_ORDERS.WOR_LATEST_COMP_DATE%TYPE
        , P_WOR_SITE_COMPLETE_DATE         IN WORK_ORDERS.WOR_SITE_COMPLETE_DATE%TYPE
        , P_WOR_EST_DURATION               IN WORK_ORDERS.WOR_EST_DURATION%TYPE
        , P_WOR_ACT_DURATION               IN WORK_ORDERS.WOR_ACT_DURATION%TYPE
        , P_WOR_CERT_COMPLETE              IN WORK_ORDERS.WOR_CERT_COMPLETE%TYPE
        , P_WOR_CON_CERT_COMPLETE          IN WORK_ORDERS.WOR_CON_CERT_COMPLETE%TYPE
        , P_WOR_AGREED_BY                  IN WORK_ORDERS.WOR_AGREED_BY%TYPE
        , P_WOR_AGREED_BY_DATE             IN WORK_ORDERS.WOR_AGREED_BY_DATE%TYPE
        , P_WOR_CON_AGREED_BY              IN WORK_ORDERS.WOR_CON_AGREED_BY%TYPE
        , P_WOR_CON_AGREED_BY_DATE         IN WORK_ORDERS.WOR_CON_AGREED_BY_DATE%TYPE
        , P_WOR_LATE_COSTS                 IN WORK_ORDERS.WOR_LATE_COSTS%TYPE
        , P_WOR_LATE_COST_CERTIFIED_BY     IN WORK_ORDERS.WOR_LATE_COST_CERTIFIED_BY%TYPE
        , P_WOR_LATE_COST_CERTIFIED_DATE   IN WORK_ORDERS.WOR_LATE_COST_CERTIFIED_DATE%TYPE
        , P_WOR_LOCATION_PLAN              IN WORK_ORDERS.WOR_LOCATION_PLAN%TYPE
        , P_WOR_UTILITY_PLANS              IN WORK_ORDERS.WOR_UTILITY_PLANS%TYPE
--        , P_WOR_STREETWORK_NOTICE          IN WORK_ORDERS.WOR_STREETWORK_NOTICE%TYPE
        , P_WOR_WORK_RESTRICTIONS          IN WORK_ORDERS.WOR_WORK_RESTRICTIONS%TYPE
		, P_WOR_REGISTER_FLAG              IN work_orders.wor_register_flag%TYPE
		, P_WOR_REGISTER_STATUS            IN work_orders.wor_register_status%TYPE      
        )  RETURN NUMBER IS

    l_works_order_no    work_orders.wor_works_order_no%TYPE;

  BEGIN

  	g_works_order_no := generate_works_order_no(p_con_id          => P_WOR_CON_ID
                                              , p_admin_unit      => nm3get.get_hus(pi_hus_username => USER, pi_raise_not_found => FALSE).hus_admin_unit
                                              , p_raise_not_found => TRUE);											   
												   
  	insert into work_orders
  	          ( WOR_WORKS_ORDER_NO
                  , WOR_SYS_FLAG
                  , WOR_RSE_HE_ID_GROUP
                  , WOR_FLAG
                  , WOR_CON_ID
                  , WOR_ACT_COST_CODE
                  , WOR_ACT_BALANCING_SUM
                  , WOR_ACT_COST
                  , WOR_ACT_LABOUR
                  , WOR_AGENCY
                  , WOR_ARE_SCHED_ACT_FLAG
                  , WOR_CHEAPEST_FLAG
                  , WOR_CLOSED_BY_ID
                  , WOR_COC_COST_CENTRE
                  , WOR_COST_RECHARG
                  , WOR_DATE_CLOSED
                  , WOR_DATE_CONFIRMED
                  , WOR_DATE_MOD
                  , WOR_DATE_RAISED
                  , WOR_DESCR
                  , WOR_DIV_CODE
                  , WOR_DTP_EXPEND_CODE
                  , WOR_EST_BALANCING_SUM
                  , WOR_EST_COMPLETE
                  , WOR_EST_COST
                  , WOR_EST_LABOUR
                  , WOR_ICB_ITEM_CODE
                  , WOR_ICB_SUB_ITEM_CODE
                  , WOR_ICB_SUB_SUB_ITEM_CODE
                  , WOR_JOB_NUMBER
                  , WOR_LAST_PRINT_DATE
                  , WOR_LA_EXPEND_CODE
                  , WOR_MOD_BY_ID
                  , WOR_OUN_ORG_ID
                  , WOR_PEO_PERSON_ID
                  , WOR_PRICE_TYPE
                  , WOR_REMARKS
                  , WOR_ROAD_TYPE
                  , WOR_RSE_HE_ID_LINK
                  , WOR_SCHEME_REF
                  , WOR_SCHEME_TYPE
                  , WOR_SCORE
                  , WOR_YEAR_CODE
                  , WOR_INTERIM_PAYMENT_FLAG
                  , WOR_RISK_ASSESSMENT_FLAG
                  , WOR_METHOD_STATEMENT_FLAG
                  , WOR_WORKS_PROGRAMME_FLAG
                  , WOR_ADDITIONAL_SAFETY_FLAG
                  , WOR_DEF_CORRECTION
                  , WOR_DEF_CORRECTION_ACCEPTABLE
                  , WOR_CORR_EXTENSION_TIME
                  , WOR_REVISED_COMP_DATE
                  , WOR_PRICE_VARIATION
                  , WOR_COMMENCE_BY
                  , WOR_ACT_COMMENCE_BY
                  , WOR_DEF_CORRECTION_PERIOD
                  , WOR_REASON_NOT_CHEAPEST
                  , WOR_PRIORITY
                  , WOR_PERC_ITEM_COMP
                  , WOR_CONTACT
                  , WOR_DATE_RECEIVED
                  , WOR_RECEIVED_BY
                  , WOR_RECHARGEABLE
                  , WOR_SUPP_DOCUMENTS
                  , WOR_EARLIEST_START_DATE
                  , WOR_PLANNED_COMP_DATE
                  , WOR_LATEST_COMP_DATE
                  , WOR_SITE_COMPLETE_DATE
                  , WOR_EST_DURATION
                  , WOR_ACT_DURATION
                  , WOR_CERT_COMPLETE
                  , WOR_CON_CERT_COMPLETE
                  , WOR_AGREED_BY
                  , WOR_AGREED_BY_DATE
                  , WOR_CON_AGREED_BY
                  , WOR_CON_AGREED_BY_DATE
                  , WOR_LATE_COSTS
                  , WOR_LATE_COST_CERTIFIED_BY
                  , WOR_LATE_COST_CERTIFIED_DATE
                  , WOR_LOCATION_PLAN
                  , WOR_UTILITY_PLANS
--                  , WOR_STREETWORK_NOTICE
                  , WOR_WORK_RESTRICTIONS
		          , WOR_REGISTER_FLAG
       		      , WOR_REGISTER_STATUS	      
                  ) VALUES
                  ( g_works_order_no
                  , P_WOR_SYS_FLAG
                  , P_WOR_RSE_HE_ID_GROUP
                  , P_WOR_FLAG
                  , P_WOR_CON_ID
                  , P_WOR_ACT_COST_CODE
                  , P_WOR_ACT_BALANCING_SUM
                  , P_WOR_ACT_COST
                  , P_WOR_ACT_LABOUR
                  , P_WOR_AGENCY
                  , P_WOR_ARE_SCHED_ACT_FLAG
                  , P_WOR_CHEAPEST_FLAG
                  , P_WOR_CLOSED_BY_ID
                  , P_WOR_COC_COST_CENTRE
                  , P_WOR_COST_RECHARG
                  , P_WOR_DATE_CLOSED
                  , P_WOR_DATE_CONFIRMED
                  , P_WOR_DATE_MOD
                  , P_WOR_DATE_RAISED
--                  , P_WOR_DESCR||'/'||P_WOR_WORKS_ORDER_NO||'/'||g_works_order_no
                  , P_WOR_DESCR 
                  , P_WOR_DIV_CODE
                  , P_WOR_DTP_EXPEND_CODE
                  , P_WOR_EST_BALANCING_SUM
                  , P_WOR_EST_COMPLETE
                  , P_WOR_EST_COST
                  , P_WOR_EST_LABOUR
                  , P_WOR_ICB_ITEM_CODE
                  , P_WOR_ICB_SUB_ITEM_CODE
                  , P_WOR_ICB_SUB_SUB_ITEM_CODE
                  , P_WOR_JOB_NUMBER
                  , P_WOR_LAST_PRINT_DATE
                  , P_WOR_LA_EXPEND_CODE
                  , P_WOR_MOD_BY_ID
                  , P_WOR_OUN_ORG_ID
                  , P_WOR_PEO_PERSON_ID
                  , P_WOR_PRICE_TYPE
                  , P_WOR_REMARKS
                  , P_WOR_ROAD_TYPE
                  , P_WOR_RSE_HE_ID_LINK
                  , P_WOR_SCHEME_REF
                  , P_WOR_SCHEME_TYPE
                  , P_WOR_SCORE
                  , P_WOR_YEAR_CODE
                  , P_WOR_INTERIM_PAYMENT_FLAG
                  , P_WOR_RISK_ASSESSMENT_FLAG
                  , P_WOR_METHOD_STATEMENT_FLAG
                  , P_WOR_WORKS_PROGRAMME_FLAG
                  , P_WOR_ADDITIONAL_SAFETY_FLAG
                  , P_WOR_DEF_CORRECTION
                  , P_WOR_DEF_CORRECTION_ACCEPT
                  , P_WOR_CORR_EXTENSION_TIME
                  , P_WOR_REVISED_COMP_DATE
                  , P_WOR_PRICE_VARIATION
                  , P_WOR_COMMENCE_BY
                  , P_WOR_ACT_COMMENCE_BY
                  , P_WOR_DEF_CORRECTION_PERIOD
                  , P_WOR_REASON_NOT_CHEAPEST
                  , P_WOR_PRIORITY
                  , P_WOR_PERC_ITEM_COMP
                  , P_WOR_CONTACT
                  , P_WOR_DATE_RECEIVED
                  , P_WOR_RECEIVED_BY
                  , P_WOR_RECHARGEABLE
                  , P_WOR_SUPP_DOCUMENTS
                  , P_WOR_EARLIEST_START_DATE
                  , P_WOR_PLANNED_COMP_DATE
                  , P_WOR_LATEST_COMP_DATE
                  , P_WOR_SITE_COMPLETE_DATE
                  , P_WOR_EST_DURATION
                  , P_WOR_ACT_DURATION
                  , P_WOR_CERT_COMPLETE
                  , P_WOR_CON_CERT_COMPLETE
                  , P_WOR_AGREED_BY
                  , P_WOR_AGREED_BY_DATE
                  , P_WOR_CON_AGREED_BY
                  , P_WOR_CON_AGREED_BY_DATE
                  , P_WOR_LATE_COSTS
                  , P_WOR_LATE_COST_CERTIFIED_BY
                  , P_WOR_LATE_COST_CERTIFIED_DATE
                  , P_WOR_LOCATION_PLAN
                  , P_WOR_UTILITY_PLANS
--                  , P_WOR_STREETWORK_NOTICE
                  , P_WOR_WORK_RESTRICTIONS
                  , P_WOR_REGISTER_FLAG
       		      , P_WOR_REGISTER_STATUS	
                  );
				  
RETURN( SQL%rowcount );

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN (0);
--   WHEN OTHERS THEN
--      RETURN (-1);
  END create_wo_header;
--
---------------------------------------------------------------------------------------------------
--
--
---------------------------------------------------------------------------------------------------
--
FUNCTION wol_can_be_copied(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE
                          ,pi_wol_id             IN work_order_lines.wol_id%TYPE) RETURN VARCHAR IS

                        
BEGIN

--
-- If the current line is a DEFECT OR if Work Order is COMPLETED then copy not permitted
-- 
  IF maiwo.get_wo(pi_wor_works_order_no => pi_wol_works_order_no).WOR_DATE_CLOSED IS NULL AND maiwo.get_wol(pi_wol_id => pi_wol_id).wol_flag != 'D' THEN
    RETURN(nm3type.c_true);
  ELSE
    RETURN(nm3type.c_false);
  END IF;    


END wol_can_be_copied;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE check_wol_can_be_copied(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE
                                 ,pi_wol_id             IN work_order_lines.wol_id%TYPE) IS
                                 
BEGIN

 IF wol_can_be_copied(pi_wol_works_order_no => pi_wol_works_order_no
                     ,pi_wol_id             => pi_wol_id) = nm3type.c_false THEN
   hig.raise_ner(pi_appl => 'MAI'
                ,pi_id   => 916
                ,pi_supplementary_info => 'wol_id => '||pi_wol_id ); 
                     
 END IF;                     

END check_wol_can_be_copied;
--
---------------------------------------------------------------------------------------------------
-- 
FUNCTION wo_can_be_copied(pi_wor_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN VARCHAR IS

                        
BEGIN

--
-- If Work Order ONLY has DEFECT Lines on it then COPY should be greyed out.
-- 
  IF NVL(hig.get_user_or_sys_opt('WORREFGEN'),'M') != 'M'
  AND (wols_of_given_type_exist(pi_works_order_no => pi_wor_works_order_no
                             ,pi_wol_flag       => 'M') -- cyclic maintenance lines
       OR
       wols_of_given_type_exist(pi_works_order_no => pi_wor_works_order_no
                               ,pi_wol_flag       => 'O')  -- scheme lines 
      ) THEN                           
    RETURN(nm3type.c_TRUE);
  ELSE
    RETURN(nm3type.c_FALSE);

  END IF;    


END wo_can_be_copied;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE check_wo_can_be_copied(pi_wor_works_order_no IN work_orders.wor_works_order_no%TYPE) IS

BEGIN

 IF wo_can_be_copied(pi_wor_works_order_no => pi_wor_works_order_no) = nm3type.c_FALSE THEN
    hig.raise_ner(pi_appl => 'MAI'
                 ,pi_id   => 915 
                 ,pi_supplementary_info => 'wor_works_order_no => '||pi_wor_works_order_no ); 
 END IF;

END check_wo_can_be_copied;
--
---------------------------------------------------------------------------------------------------
--
-- GJ 9th August 2006
-- Not sure if create_wol is used by anything other than copy_wol - but I didn't want
-- to be invasive which is why I added a new parameter pi_zeroize_boq_items which is defaulted
-- 
-- if you set this to TRUE - which is what it is set to by copy_wol - it will copy boq items
-- across with zero/null quantities
--
  FUNCTION create_wol
        ( P_WOL_ID                 IN WORK_ORDER_LINES.WOL_ID%TYPE default 0
        , P_WOL_WORKS_ORDER_NO     IN WORK_ORDER_LINES.WOL_WORKS_ORDER_NO%TYPE default 0
        , P_WOL_RSE_HE_ID          IN WORK_ORDER_LINES.WOL_RSE_HE_ID%TYPE default 0
        , P_WOL_SISS_ID            IN WORK_ORDER_LINES.WOL_SISS_ID%TYPE default 0
        , P_WOL_ICB_WORK_CODE      IN WORK_ORDER_LINES.WOL_ICB_WORK_CODE%TYPE default 0
        , P_WOL_DEF_DEFECT_ID      IN WORK_ORDER_LINES.WOL_DEF_DEFECT_ID%TYPE default null
        , P_WOL_REP_ACTION_CAT     IN WORK_ORDER_LINES.WOL_REP_ACTION_CAT%TYPE default null
        , P_WOL_SCHD_ID            IN WORK_ORDER_LINES.WOL_SCHD_ID%TYPE default null
        , P_WOL_CNP_ID             IN WORK_ORDER_LINES.WOL_CNP_ID%TYPE default null
        , P_WOL_ACT_AREA_CODE      IN WORK_ORDER_LINES.WOL_ACT_AREA_CODE%TYPE default null
        , P_WOL_ACT_COST           IN WORK_ORDER_LINES.WOL_ACT_COST%TYPE default null
        , P_WOL_ACT_LABOUR         IN WORK_ORDER_LINES.WOL_ACT_LABOUR%TYPE default null
        , P_WOL_ARE_END_CHAIN      IN WORK_ORDER_LINES.WOL_ARE_END_CHAIN%TYPE default null
        , P_WOL_ARE_REPORT_ID      IN WORK_ORDER_LINES.WOL_ARE_REPORT_ID%TYPE default null
        , P_WOL_ARE_ST_CHAIN       IN WORK_ORDER_LINES.WOL_ARE_ST_CHAIN%TYPE default null
        , P_WOL_CHECK_CODE         IN WORK_ORDER_LINES.WOL_CHECK_CODE%TYPE default null
        , P_WOL_CHECK_COMMENTS     IN WORK_ORDER_LINES.WOL_CHECK_COMMENTS%TYPE default null
        , P_WOL_CHECK_DATE         IN WORK_ORDER_LINES.WOL_CHECK_DATE%TYPE default null
        , P_WOL_CHECK_ID           IN WORK_ORDER_LINES.WOL_CHECK_ID%TYPE default null
        , P_WOL_CHECK_PEO_ID       IN WORK_ORDER_LINES.WOL_CHECK_PEO_ID%TYPE default null
        , P_WOL_CHECK_RESULT       IN WORK_ORDER_LINES.WOL_CHECK_RESULT%TYPE default null
        , P_WOL_DATE_COMPLETE      IN WORK_ORDER_LINES.WOL_DATE_COMPLETE%TYPE default null
        , P_WOL_DATE_CREATED       IN WORK_ORDER_LINES.WOL_DATE_CREATED%TYPE default null
        , P_WOL_DATE_PAID          IN WORK_ORDER_LINES.WOL_DATE_PAID%TYPE default null
        , P_WOL_DESCR              IN WORK_ORDER_LINES.WOL_DESCR%TYPE default null
        , P_WOL_DISCOUNT           IN WORK_ORDER_LINES.WOL_DISCOUNT%TYPE default null
        , P_WOL_EST_COST           IN WORK_ORDER_LINES.WOL_EST_COST%TYPE default null
        , P_WOL_EST_LABOUR         IN WORK_ORDER_LINES.WOL_EST_LABOUR%TYPE default null
        , P_WOL_FLAG               IN WORK_ORDER_LINES.WOL_FLAG%TYPE default null
        , P_WOL_MONTH_DUE          IN WORK_ORDER_LINES.WOL_MONTH_DUE%TYPE default null
        , P_WOL_ORIG_EST           IN WORK_ORDER_LINES.WOL_ORIG_EST%TYPE default null
        , P_WOL_PAYMENT_CODE       IN WORK_ORDER_LINES.WOL_PAYMENT_CODE%TYPE default null
        , P_WOL_QUANTITY           IN WORK_ORDER_LINES.WOL_QUANTITY%TYPE default null
        , P_WOL_RATE               IN WORK_ORDER_LINES.WOL_RATE%TYPE default null
        , P_WOL_SS_TRE_TREAT_CODE  IN WORK_ORDER_LINES.WOL_SS_TRE_TREAT_CODE%TYPE default null
        , P_WOL_STATUS             IN WORK_ORDER_LINES.WOL_STATUS%TYPE default null
        , P_WOL_STATUS_CODE        IN WORK_ORDER_LINES.WOL_STATUS_CODE%TYPE default null
        , P_WOL_UNIQUE_FLAG        IN WORK_ORDER_LINES.WOL_UNIQUE_FLAG%TYPE default null
        , P_WOL_WORK_SHEET_DATE    IN WORK_ORDER_LINES.WOL_WORK_SHEET_DATE%TYPE default null
        , P_WOL_WORK_SHEET_ISSUE   IN WORK_ORDER_LINES.WOL_WORK_SHEET_ISSUE%TYPE default null
        , P_WOL_WORK_SHEET_NO      IN WORK_ORDER_LINES.WOL_WORK_SHEET_NO%TYPE default null
        , P_WOL_WOR_FLAG           IN WORK_ORDER_LINES.WOL_WOR_FLAG%TYPE default null
        , P_WOL_DATE_REPAIRED      IN WORK_ORDER_LINES.WOL_DATE_REPAIRED%TYPE default null
        , P_WOL_INVOICE_STATUS     IN WORK_ORDER_LINES.WOL_INVOICE_STATUS%TYPE default null
        , P_WOL_BUD_ID             IN WORK_ORDER_LINES.WOL_BUD_ID%TYPE default null
        , P_WOL_UNPOSTED_EST       IN WORK_ORDER_LINES.WOL_UNPOSTED_EST%TYPE default null
        , P_WOL_IIT_ITEM_ID        IN WORK_ORDER_LINES.WOL_IIT_ITEM_ID%TYPE default null
        , P_WOL_GANG               IN WORK_ORDER_LINES.WOL_GANG%TYPE default null
        , pi_zeroize               IN BOOLEAN DEFAULT FALSE
        ) RETURN NUMBER IS

  CURSOR C1 ( p_wol_id boq_items.boq_wol_id%TYPE
            )IS
  select *
  from boq_items
  where boq_wol_id = p_wol_id;

  l_boq_rec   boq_items%ROWTYPE;
  
  l_wol_id          work_order_lines.wol_id%TYPE := wol_id_nextseq;
  l_wol_act_cost    work_order_lines.wol_act_cost%TYPE;
  l_wol_act_labour  work_order_lines.wol_act_labour%TYPE;
  l_wol_est_cost    work_order_lines.wol_est_cost%TYPE;   
  l_wol_est_labour  work_order_lines.wol_est_labour%TYPE;


  cursor c2 IS
  select hsc_status_code
  from hig_status_codes
  where hsc_domain_code = 'WORK_ORDER_LINES'
  and hsc_allow_feature1 = 'Y';

  l_status_code hig_status_codes.hsc_status_code%TYPE;
  l_error number;

  BEGIN
  
 
      open c2;
      fetch c2 into l_status_code;
      close c2;
      
      IF pi_zeroize THEN
        l_wol_act_cost    := 0;
        l_wol_act_labour  := 0;
        l_wol_est_cost    := 0;   
        l_wol_est_labour  := 0;
      ELSE
        l_wol_act_cost    := p_wol_act_cost;
        l_wol_act_labour  := p_wol_act_labour;
        l_wol_est_cost    := p_wol_est_cost;   
        l_wol_est_labour  := p_wol_est_labour;
      END IF;                               
      
      insert into work_order_lines
                ( WOL_ID
                , WOL_WORKS_ORDER_NO
                , WOL_RSE_HE_ID
                , WOL_SISS_ID
                , WOL_ICB_WORK_CODE
                , WOL_DEF_DEFECT_ID
                , WOL_REP_ACTION_CAT
                , WOL_SCHD_ID
                , WOL_CNP_ID
                , WOL_ACT_AREA_CODE
                , WOL_ACT_COST
                , WOL_ACT_LABOUR
                , WOL_ARE_END_CHAIN
                , WOL_ARE_REPORT_ID
                , WOL_ARE_ST_CHAIN
                , WOL_CHECK_CODE
                , WOL_CHECK_COMMENTS
                , WOL_CHECK_DATE
                , WOL_CHECK_ID
                , WOL_CHECK_PEO_ID
                , WOL_CHECK_RESULT
                , WOL_DATE_COMPLETE
                , WOL_DATE_CREATED
                , WOL_DATE_PAID
                , WOL_DESCR
                , WOL_DISCOUNT
                , WOL_EST_COST
                , WOL_EST_LABOUR
                , WOL_FLAG
                , WOL_MONTH_DUE
                , WOL_ORIG_EST
                , WOL_PAYMENT_CODE
                , WOL_QUANTITY
                , WOL_RATE
                , WOL_SS_TRE_TREAT_CODE
                , WOL_STATUS
                , WOL_STATUS_CODE
                , WOL_UNIQUE_FLAG
                , WOL_WORK_SHEET_DATE
                , WOL_WORK_SHEET_ISSUE
                , WOL_WORK_SHEET_NO
                , WOL_WOR_FLAG
                , WOL_DATE_REPAIRED
                , WOL_INVOICE_STATUS
                , WOL_BUD_ID
                , WOL_UNPOSTED_EST
                , WOL_IIT_ITEM_ID
                , WOL_GANG
                ) values (
                  l_wol_id
                , P_WOL_WORKS_ORDER_NO
                , P_WOL_RSE_HE_ID
                , P_WOL_SISS_ID
                , P_WOL_ICB_WORK_CODE
                , P_WOL_DEF_DEFECT_ID
                , P_WOL_REP_ACTION_CAT
                , P_WOL_SCHD_ID
                , P_WOL_CNP_ID
                , P_WOL_ACT_AREA_CODE
                , l_wol_act_cost
                , l_wol_act_labour
                , P_WOL_ARE_END_CHAIN
                , P_WOL_ARE_REPORT_ID
                , P_WOL_ARE_ST_CHAIN
                , P_WOL_CHECK_CODE
                , P_WOL_CHECK_COMMENTS
                , P_WOL_CHECK_DATE
                , P_WOL_CHECK_ID
                , P_WOL_CHECK_PEO_ID
                , P_WOL_CHECK_RESULT
                , P_WOL_DATE_COMPLETE
                , P_WOL_DATE_CREATED
                , P_WOL_DATE_PAID
                , P_WOL_DESCR
                , P_WOL_DISCOUNT
                , l_wol_est_cost
                , l_wol_est_labour
                , P_WOL_FLAG
                , P_WOL_MONTH_DUE
                , P_WOL_ORIG_EST
                , P_WOL_PAYMENT_CODE
                , P_WOL_QUANTITY
                , P_WOL_RATE
                , P_WOL_SS_TRE_TREAT_CODE
                , P_WOL_STATUS
                , l_status_code  -- INSTRUCTED
                , P_WOL_UNIQUE_FLAG
                , P_WOL_WORK_SHEET_DATE
                , P_WOL_WORK_SHEET_ISSUE
                , P_WOL_WORK_SHEET_NO
                , P_WOL_WOR_FLAG
                , P_WOL_DATE_REPAIRED
                , P_WOL_INVOICE_STATUS
                , P_WOL_BUD_ID
                , P_WOL_UNPOSTED_EST
                , P_WOL_IIT_ITEM_ID
                , P_WOL_GANG
                );
      for c1rec in c1(p_wol_id) loop
      
        IF pi_zeroize THEN

           --
           -- GJ 9th August 2006
           -- Logic used when copying BOQ's and zeroizing the figures
           --
           --
           --   boq_est_quantity     0
           --   boq_est_rate         bring thru
           --   boq_est_cost         0 
           --   boq_est_labour       0
           -- 
           --   boq_est_dim1         0
           --   boq_est_dim2         0 if there is a value already otherwise null
           --   boq_est_dim3         0 if there is a value already otherwise null
           --
           -- all of actual's are inserted as null
 
          c1rec.boq_est_quantity := 0;
          c1rec.boq_est_cost := 0;
          c1rec.boq_est_labour := 0;                     
          c1rec.boq_est_dim1 := 0;

          IF c1rec.boq_est_dim2 IS NOT NULL THEN
           c1rec.boq_est_dim2 := 0;
          ELSE
           c1rec.boq_est_dim2 := Null;
          END IF;
          
          IF c1rec.boq_est_dim3 IS NOT NULL THEN
           c1rec.boq_est_dim3 := 0;
          ELSE
           c1rec.boq_est_dim3 := Null;
          END IF; 
          
        END IF;        

        l_error := cre_boq_items2( p_boq_work_flag      => c1rec.boq_work_flag
                                 , p_boq_defect_id      => c1rec.boq_defect_id
                                 , p_boq_rep_action_cat => c1rec.boq_rep_action_cat
                                 , p_boq_wol_id         => l_wol_id
                                 , p_boq_sta_item_code  => c1rec.boq_sta_item_code
                                 , p_boq_date_created   => sysdate
                                 , p_boq_est_dim1       => c1rec.boq_est_dim1
                                 , p_boq_est_dim2       => c1rec.boq_est_dim2
                                 , p_boq_est_dim3       => c1rec.boq_est_dim3
                                 , p_boq_est_quantity   => c1rec.boq_est_quantity
                                 , p_boq_est_rate       => c1rec.boq_est_rate
                                 , p_boq_est_cost       => c1rec.boq_est_cost
                                 , p_boq_est_labour     => c1rec.boq_est_labour
                                 , p_boq_id             => boq_id_nextseq);
                                

      end loop;
RETURN( SQL%rowcount );

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN (0);
--   WHEN OTHERS THEN
--      RETURN (-1);
  END create_wol;
--
---------------------------------------------------------------------------------------------------
--
  FUNCTION copy_works_order
        ( pi_wor_works_order_no             IN work_orders.wor_works_order_no%TYPE
        ) RETURN work_orders.wor_works_order_no%TYPE IS



    CURSOR c1 ( p_works_order_no work_order_lines.wol_works_order_no%TYPE
              ) IS
    select *
    from work_order_lines
    where wol_works_order_no = p_works_order_no
    and  wol_flag != 'D'; -- exclude any defect lines

    l_wor_rec           work_orders%ROWTYPE;
    l_error             number;
    l_retval            work_orders.wor_works_order_no%TYPE;

  BEGIN
  
   --
   -- belt and braces cos in MAI3800 a when-new-record instance trigger on B1 should
   -- disable the Copy button 
   --
    check_wo_can_be_copied(pi_wor_works_order_no => pi_wor_works_order_no);				   
	    
    l_wor_rec := maiwo.get_wo(pi_wor_works_order_no => pi_wor_works_order_no);


    l_wor_rec.wor_act_cost_code := null;
    l_wor_rec.wor_act_balancing_sum := null;
    l_wor_rec.wor_act_cost := null;
    l_wor_rec.wor_act_labour := null;
    l_wor_rec.wor_cheapest_flag := null;
    l_wor_rec.wor_closed_by_id := null;
    l_wor_rec.wor_date_closed := null;
    l_wor_rec.wor_date_confirmed := null;
    l_wor_rec.wor_date_mod := SYSDATE;
    l_wor_rec.wor_date_raised := SYSDATE;
    l_wor_rec.wor_descr       := pi_wor_works_order_no||' COPY';	
    l_wor_rec.wor_est_balancing_sum := null;
    l_wor_rec.wor_est_complete := null;
    l_wor_rec.wor_est_cost := null;
    l_wor_rec.wor_est_labour := null;
    l_wor_rec.wor_last_print_date := null;
    l_wor_rec.wor_year_code := null;
    l_wor_rec.wor_def_correction := null;
    l_wor_rec.wor_def_correction_acceptable := null;
    l_wor_rec.wor_corr_extension_time := null;
    l_wor_rec.wor_revised_comp_date := null;
    l_wor_rec.wor_commence_by := null;
    l_wor_rec.wor_act_commence_by := null;
    l_wor_rec.wor_def_correction_period := null;
    l_wor_rec.wor_reason_not_cheapest := null;
    l_wor_rec.wor_date_received := null;
    l_wor_rec.wor_received_by := null;
    l_wor_rec.wor_earliest_start_date := null;
    l_wor_rec.wor_planned_comp_date := null;
    l_wor_rec.wor_latest_comp_date := null;
    l_wor_rec.wor_site_complete_date := null;
    l_wor_rec.wor_est_duration := null;
    l_wor_rec.wor_act_duration := null;
    l_wor_rec.wor_cert_complete := null;
    l_wor_rec.wor_con_cert_complete := null;
    l_wor_rec.wor_agreed_by := null;
    l_wor_rec.wor_agreed_by_date := null;
    l_wor_rec.wor_con_agreed_by := null;
    l_wor_rec.wor_con_agreed_by_date := null;
    l_wor_rec.wor_late_costs := null;
    l_wor_rec.wor_late_cost_certified_by := null;
    l_wor_rec.wor_late_cost_certified_date := null;
    
    l_error := create_wo_header( p_wor_works_order_no             => l_wor_rec.wor_works_order_no
                               , p_wor_sys_flag                   => l_wor_rec.wor_sys_flag
                               , p_wor_rse_he_id_group            => l_wor_rec.wor_rse_he_id_group
                               , p_wor_flag                       => l_wor_rec.wor_flag
                               , p_wor_con_id                     => l_wor_rec.wor_con_id
                               , p_wor_act_cost_code              => l_wor_rec.wor_act_cost_code
                               , p_wor_act_balancing_sum          => l_wor_rec.wor_act_balancing_sum
                               , p_wor_act_cost                   => l_wor_rec.wor_act_cost
                               , p_wor_act_labour                 => l_wor_rec.wor_act_labour
                               , p_wor_agency                     => l_wor_rec.wor_agency
                               , p_wor_are_sched_act_flag         => l_wor_rec.wor_are_sched_act_flag
                               , p_wor_cheapest_flag              => l_wor_rec.wor_cheapest_flag
                               , p_wor_closed_by_id               => l_wor_rec.wor_closed_by_id
                               , p_wor_coc_cost_centre            => l_wor_rec.wor_coc_cost_centre
                               , p_wor_cost_recharg               => l_wor_rec.wor_cost_recharg
                               , p_wor_date_closed                => l_wor_rec.wor_date_closed
                               , p_wor_date_confirmed             => l_wor_rec.wor_date_confirmed
                               , p_wor_date_mod                   => l_wor_rec.wor_date_mod
                               , p_wor_date_raised                => l_wor_rec.wor_date_raised
                               , p_wor_descr                      => l_wor_rec.wor_descr
                               , p_wor_div_code                   => l_wor_rec.wor_div_code
                               , p_wor_dtp_expend_code            => l_wor_rec.wor_dtp_expend_code
                               , p_wor_est_balancing_sum          => l_wor_rec.wor_est_balancing_sum
                               , p_wor_est_complete               => l_wor_rec.wor_est_complete
                               , p_wor_est_cost                   => l_wor_rec.wor_est_cost
                               , p_wor_est_labour                 => l_wor_rec.wor_est_labour
                               , p_wor_icb_item_code              => l_wor_rec.wor_icb_item_code
                               , p_wor_icb_sub_item_code          => l_wor_rec.wor_icb_sub_item_code
                               , p_wor_icb_sub_sub_item_code      => l_wor_rec.wor_icb_sub_sub_item_code
                               , p_wor_job_number                 => l_wor_rec.wor_job_number
                               , p_wor_last_print_date            => l_wor_rec.wor_last_print_date
                               , p_wor_la_expend_code             => l_wor_rec.wor_la_expend_code
                               , p_wor_mod_by_id                  => l_wor_rec.wor_mod_by_id
                               , p_wor_oun_org_id                 => l_wor_rec.wor_oun_org_id
                               , p_wor_peo_person_id              => l_wor_rec.wor_peo_person_id
                               , p_wor_price_type                 => l_wor_rec.wor_price_type
                               , p_wor_remarks                    => l_wor_rec.wor_remarks
                               , p_wor_road_type                  => l_wor_rec.wor_road_type
                               , p_wor_rse_he_id_link             => l_wor_rec.wor_rse_he_id_link
                               , p_wor_scheme_ref                 => l_wor_rec.wor_scheme_ref
                               , p_wor_scheme_type                => l_wor_rec.wor_scheme_type
                               , p_wor_score                      => l_wor_rec.wor_score
                               , p_wor_year_code                  => l_wor_rec.wor_year_code
                               , p_wor_interim_payment_flag       => l_wor_rec.wor_interim_payment_flag
                               , p_wor_risk_assessment_flag       => l_wor_rec.wor_risk_assessment_flag
                               , p_wor_method_statement_flag      => l_wor_rec.wor_method_statement_flag
                               , p_wor_works_programme_flag       => l_wor_rec.wor_works_programme_flag
                               , p_wor_additional_safety_flag     => l_wor_rec.wor_additional_safety_flag
                               , p_wor_def_correction             => l_wor_rec.wor_def_correction
                               , p_wor_def_correction_accept      => l_wor_rec.wor_def_correction_acceptable
                               , p_wor_corr_extension_time        => l_wor_rec.wor_corr_extension_time
                               , p_wor_revised_comp_date          => l_wor_rec.wor_revised_comp_date
                               , p_wor_price_variation            => l_wor_rec.wor_price_variation
                               , p_wor_commence_by                => l_wor_rec.wor_commence_by
                               , p_wor_act_commence_by            => l_wor_rec.wor_act_commence_by
                               , p_wor_def_correction_period      => l_wor_rec.wor_def_correction_period
                               , p_wor_reason_not_cheapest        => l_wor_rec.wor_reason_not_cheapest
                               , p_wor_priority                   => l_wor_rec.wor_priority
                               , p_wor_perc_item_comp             => l_wor_rec.wor_perc_item_comp
                               , p_wor_contact                    => l_wor_rec.wor_contact
                               , p_wor_date_received              => l_wor_rec.wor_date_received
                               , p_wor_received_by                => l_wor_rec.wor_received_by
                               , p_wor_rechargeable               => l_wor_rec.wor_rechargeable
                               , p_wor_supp_documents             => l_wor_rec.wor_supp_documents
                               , p_wor_earliest_start_date        => l_wor_rec.wor_earliest_start_date
                               , p_wor_planned_comp_date          => l_wor_rec.wor_planned_comp_date
                               , p_wor_latest_comp_date           => l_wor_rec.wor_latest_comp_date
                               , p_wor_site_complete_date         => l_wor_rec.wor_site_complete_date
                               , p_wor_est_duration               => l_wor_rec.wor_est_duration
                               , p_wor_act_duration               => l_wor_rec.wor_act_duration
                               , p_wor_cert_complete              => l_wor_rec.wor_cert_complete
                               , p_wor_con_cert_complete          => l_wor_rec.wor_con_cert_complete
                               , p_wor_agreed_by                  => l_wor_rec.wor_agreed_by
                               , p_wor_agreed_by_date             => l_wor_rec.wor_agreed_by_date
                               , p_wor_con_agreed_by              => l_wor_rec.wor_con_agreed_by
                               , p_wor_con_agreed_by_date         => l_wor_rec.wor_con_agreed_by_date
                               , p_wor_late_costs                 => l_wor_rec.wor_late_costs
                               , p_wor_late_cost_certified_by     => l_wor_rec.wor_late_cost_certified_by
                               , p_wor_late_cost_certified_date   => l_wor_rec.wor_late_cost_certified_date
                               , p_wor_location_plan              => l_wor_rec.wor_location_plan
                               , p_wor_utility_plans              => l_wor_rec.wor_utility_plans
--                               , p_wor_streetwork_notice          => l_wor_rec.wor_streetwork_notice
                               , p_wor_work_restrictions          => l_wor_rec.wor_work_restrictions
                               , p_wor_register_flag              => l_wor_rec.wor_register_flag							   
                               , p_wor_register_status            => l_wor_rec.wor_register_status);							   

    l_retval :=  g_works_order_no;  -- set by calling mai.create_wo_header;


    for c1rec in c1(pi_wor_works_order_no) loop
    
     l_error := create_wol(p_wol_id                 => c1rec.wol_id
                         , p_wol_works_order_no     => l_retval
                         , p_wol_rse_he_id          => c1rec.wol_rse_he_id
                         , p_wol_siss_id            => c1rec.wol_siss_id
                         , p_wol_icb_work_code      => c1rec.wol_icb_work_code
                         , p_wol_def_defect_id      => Null
                         , p_wol_rep_action_cat     => Null
                         , p_wol_schd_id            => c1rec.wol_schd_id
                         , p_wol_cnp_id             => c1rec.wol_cnp_id
                         , p_wol_act_area_code      => c1rec.wol_act_area_code
                         , p_wol_act_cost           => 0
                         , p_wol_act_labour         => 0
                         , p_wol_are_end_chain      => Null
                         , p_wol_are_report_id      => Null
                         , p_wol_are_st_chain       => Null
                         , p_wol_check_code         => c1rec.wol_check_code
                         , p_wol_check_comments     => c1rec.wol_check_comments
                         , p_wol_check_date         => c1rec.wol_check_date
                         , p_wol_check_id           => c1rec.wol_check_id
                         , p_wol_check_peo_id       => c1rec.wol_check_peo_id
                         , p_wol_check_result       => c1rec.wol_check_result
                         , p_wol_date_complete      => Null
                         , p_wol_date_created       => sysdate
                         , p_wol_date_paid          => Null
                         , p_wol_descr              => c1rec.wol_descr 
                         , p_wol_discount           => c1rec.wol_discount
                         , p_wol_est_cost           => 0
                         , p_wol_est_labour         => 0
                         , p_wol_flag               => c1rec.wol_flag
                         , p_wol_month_due          => c1rec.wol_month_due
                         , p_wol_orig_est           => c1rec.wol_orig_est
                         , p_wol_payment_code       => c1rec.wol_payment_code
                         , p_wol_quantity           => c1rec.wol_quantity
                         , p_wol_rate               => c1rec.wol_rate
                         , p_wol_ss_tre_treat_code  => c1rec.wol_ss_tre_treat_code
                         , p_wol_status             => c1rec.wol_status
                         , p_wol_status_code        => c1rec.wol_status_code -- actually ignored by create_wol cos it uses 'INSTRUCTUED' by default
                         , p_wol_unique_flag        => c1rec.wol_unique_flag
                         , p_wol_work_sheet_date    => c1rec.wol_work_sheet_date
                         , p_wol_work_sheet_issue   => c1rec.wol_work_sheet_issue
                         , p_wol_work_sheet_no      => c1rec.wol_work_sheet_no
                         , p_wol_wor_flag           => c1rec.wol_wor_flag
                         , p_wol_date_repaired      => Null
                         , p_wol_invoice_status     => Null
                         , p_wol_bud_id             => c1rec.wol_bud_id
                         , p_wol_unposted_est       => 0
                         , p_wol_iit_item_id        => c1rec.wol_iit_item_id
                         , p_wol_gang               => c1rec.wol_gang
                         , pi_zeroize               => TRUE);    
    
    end loop;

  RETURN(l_retval);

  END copy_works_order;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE copy_wol(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE
                  ,pi_wol_id IN work_order_lines.wol_id%TYPE) IS

 l_wol_rec work_order_lines%ROWTYPE;
 l_integer PLS_INTEGER;
                  
BEGIN
 
   check_wol_can_be_copied(pi_wol_works_order_no => pi_wol_works_order_no
                          ,pi_wol_id             => pi_wol_id);

   l_wol_rec := maiwo.get_wol(pi_wol_id => pi_wol_id);
   
  
   l_integer := create_wol(p_wol_id                 => l_wol_rec.wol_id
                         , p_wol_works_order_no     => l_wol_rec.wol_works_order_no
                         , p_wol_rse_he_id          => l_wol_rec.wol_rse_he_id
                         , p_wol_siss_id            => l_wol_rec.wol_siss_id
                         , p_wol_icb_work_code      => l_wol_rec.wol_icb_work_code
                         , p_wol_def_defect_id      => Null
                         , p_wol_rep_action_cat     => Null
                         , p_wol_schd_id            => l_wol_rec.wol_schd_id
                         , p_wol_cnp_id             => l_wol_rec.wol_cnp_id
                         , p_wol_act_area_code      => l_wol_rec.wol_act_area_code
                         , p_wol_act_cost           => 0
                         , p_wol_act_labour         => 0
                         , p_wol_are_end_chain      => Null
                         , p_wol_are_report_id      => Null
                         , p_wol_are_st_chain       => Null
                         , p_wol_check_code         => l_wol_rec.wol_check_code
                         , p_wol_check_comments     => l_wol_rec.wol_check_comments
                         , p_wol_check_date         => l_wol_rec.wol_check_date
                         , p_wol_check_id           => l_wol_rec.wol_check_id
                         , p_wol_check_peo_id       => l_wol_rec.wol_check_peo_id
                         , p_wol_check_result       => l_wol_rec.wol_check_result
                         , p_wol_date_complete      => Null
                         , p_wol_date_created       => sysdate
                         , p_wol_date_paid          => Null
                         , p_wol_descr              => 'COPY OF '||l_wol_rec.wol_id 
                         , p_wol_discount           => l_wol_rec.wol_discount
                         , p_wol_est_cost           => 0
                         , p_wol_est_labour         => 0
                         , p_wol_flag               => l_wol_rec.wol_flag
                         , p_wol_month_due          => l_wol_rec.wol_month_due
                         , p_wol_orig_est           => l_wol_rec.wol_orig_est
                         , p_wol_payment_code       => l_wol_rec.wol_payment_code
                         , p_wol_quantity           => l_wol_rec.wol_quantity
                         , p_wol_rate               => l_wol_rec.wol_rate
                         , p_wol_ss_tre_treat_code  => l_wol_rec.wol_ss_tre_treat_code
                         , p_wol_status             => l_wol_rec.wol_status
                         , p_wol_status_code        => l_wol_rec.wol_status_code -- actually ignored by create_wol cos it uses 'INSTRUCTUED' by default
                         , p_wol_unique_flag        => l_wol_rec.wol_unique_flag
                         , p_wol_work_sheet_date    => l_wol_rec.wol_work_sheet_date
                         , p_wol_work_sheet_issue   => l_wol_rec.wol_work_sheet_issue
                         , p_wol_work_sheet_no      => l_wol_rec.wol_work_sheet_no
                         , p_wol_wor_flag           => l_wol_rec.wol_wor_flag
                         , p_wol_date_repaired      => Null
                         , p_wol_invoice_status     => Null
                         , p_wol_bud_id             => l_wol_rec.wol_bud_id
                         , p_wol_unposted_est       => 0
                         , p_wol_iit_item_id        => l_wol_rec.wol_iit_item_id
                         , p_wol_gang               => l_wol_rec.wol_gang
                         , pi_zeroize               => TRUE);

END copy_wol;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_wols_for_register (pi_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN PLS_INTEGER IS

 l_refcur nm3type.ref_cursor;
 l_retval PLS_INTEGER;
 l_sql    VARCHAR2(2000);


BEGIN

     --
     --
     -- refcursor is used cos cannot directly reference swr_id_mapping table
     -- cos we cannot guarantee that this SWM table is installed when MAI is
     -- installed
     --
      l_sql := 'select  count(*)
                from   work_order_lines wol
                where  wol.wol_works_order_no = :1
                and    wol.wol_status_code = (SELECT hsc_status_code  -- instructed
                                              FROM hig_status_codes
                                              WHERE hsc_domain_code = ''WORK_ORDER_LINES''
                                              AND hsc_allow_feature1 = ''Y'')
				and not exists (select 1 from swr_id_mapping where sim_origin = ''WOL'' and sim_primary_key_value = wol_id)';

      OPEN l_refcur FOR l_sql
      USING pi_works_order_no;
      FETCH l_refcur INTO l_retval;
      CLOSE l_refcur;

	  RETURN(l_retval);

END count_wols_for_register;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_notices_for_works_order(pi_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN PLS_INTEGER IS

 l_refcur nm3type.ref_cursor;
 l_retval PLS_INTEGER;
 l_sql    VARCHAR2(2000);


BEGIN

     --
     --
     -- refcursor is used cos cannot directly reference swr_id_mapping table
     -- cos we cannot guarantee that this SWM table is installed when MAI is
     -- installed
     --
      l_sql := 'select  count(*)
                from   swr_id_mapping
				      ,work_order_lines
                where  sim_origin = ''WOL''
				and    sim_primary_key_value = wol_id
				and    wol_works_order_no = :1';

      OPEN l_refcur FOR l_sql
      USING pi_works_order_no;
      FETCH l_refcur INTO l_retval;
      CLOSE l_refcur;

	  RETURN(NVL(l_retval,0));


END count_notices_for_works_order;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_wols(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE
                   ,pi_wol_flag           IN work_order_lines.wol_flag%TYPE DEFAULT NULL) 
  RETURN PLS_INTEGER 
IS

 l_retval PLS_INTEGER;
 l_sql    VARCHAR2(1000);
BEGIN
--
  l_sql:= 'SELECT COUNT(wol_id) FROM work_order_lines WHERE  wol_works_order_no = :pi_wol_works_order_no ';
--
  IF pi_wol_flag IS NOT NULL
    THEN
    l_sql := l_sql ||' AND wol_flag = UPPER(:pi_wol_flag) ';
    EXECUTE IMMEDIATE l_sql INTO l_retval USING IN pi_wol_works_order_no, pi_wol_flag;
  ELSE
    EXECUTE IMMEDIATE l_sql INTO l_retval USING IN pi_wol_works_order_no;
  END IF;
--
  RETURN(l_retval);
--
END count_wols;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION wols_of_given_type_exist(pi_works_order_no IN work_orders.wor_works_order_no%TYPE
                                 ,pi_wol_flag       IN work_order_lines.wol_flag%TYPE) RETURN BOOLEAN IS

BEGIN
 
  RETURN(count_wols(pi_wol_works_order_no => pi_works_order_no
                   ,pi_wol_flag           => pi_wol_flag) >0);
 
END wols_of_given_type_exist;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION determine_reg_status(pi_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN work_orders.wor_register_status%TYPE IS 

 l_retval work_orders.wor_register_status%TYPE; 

 l_wols_to_be_sent   PLS_INTEGER;
 l_wols_already_sent PLS_INTEGER; 
  
BEGIN

   --
   -- if there are work order lines still to be registered then we are Outstanding
   --
   l_wols_to_be_sent := mai.count_wols_for_register(pi_works_order_no => pi_works_order_no);

   IF l_wols_to_be_sent > 0 THEN
     l_retval := 'O'; -- 'Outstanding'
   ELSE

    l_wols_already_sent := mai.count_notices_for_works_order(pi_works_order_no => pi_works_order_no);   

    IF NVL(l_wols_already_sent,0) > 0 THEN
      l_retval := 'C'; -- 'Completed'
    END IF;
		  		  
   END IF;

   RETURN(NVL(l_retval,'N')); -- if all else fails e.g. no lines to send and none already sent then return 'N' - which signifies 'Nothing to Register' 

END determine_reg_status;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION determine_reg_status_for_flag(pi_works_order_no    IN work_orders.wor_works_order_no%TYPE
                                      ,pi_wor_register_flag IN work_orders.wor_register_flag%TYPE) RETURN work_orders.wor_register_status%TYPE IS

 l_retval work_orders.wor_register_status%TYPE;

BEGIN

 IF pi_wor_register_flag = 'Y' AND NOT hig.is_product_licensed(pi_product => 'SWR') THEN
   hig.raise_ner(pi_appl => 'MAI'
                ,pi_id   => 918);
 END IF;

 IF pi_wor_register_flag = 'N' THEN
    l_retval := Null;
 ELSE
    l_retval := mai.determine_reg_status(pi_works_order_no => pi_works_order_no);
 END IF;

 RETURN(l_retval);
 
END determine_reg_status_for_flag;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE wol_register_bs_trg IS

BEGIN

 --
 -- Clear out the global pl/sql table that will be populated by 
 -- wol_register_iud_trg
 --
 g_tab_register_wols.DELETE;

END wol_register_bs_trg;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE wol_register_iud_trg(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE) IS

 i PLS_INTEGER := g_tab_register_wols.COUNT+1;

BEGIN

 --
 -- Add details of the works order line into the global pl/sql table
 -- that will be processed by wol_register_as_trg
 --
 g_tab_register_wols(i) := pi_wol_works_order_no;

END wol_register_iud_trg;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE wol_register_as_trg IS

 l_last_wol_works_order_no work_order_lines.wol_works_order_no%TYPE := nm3type.c_nvl;

BEGIN

 FOR i IN 1..g_tab_register_wols.COUNT LOOP

   IF g_tab_register_wols(i) !=  l_last_wol_works_order_no THEN
    
       l_last_wol_works_order_no := g_tab_register_wols(i);
	 
       --
       -- touch the associated work order so that the 
       -- work_order_register_trg trigger cuts in and re-evaluates
       -- the wor_register_status flag
       -- 
       update work_orders
       set    wor_register_flag = wor_register_flag
       where  wor_works_order_no = l_last_wol_works_order_no
       and    wor_register_flag = 'Y';
	   
   END IF;	    	   

 END LOOP;

END wol_register_as_trg;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE date_from_priority (
   p_wpr_id        IN       WORK_ORDER_PRIORITIES.wpr_id%TYPE,
   p_date          IN       DATE,
   p_target_date   OUT      DATE,
   p_error         OUT      VARCHAR2
)
IS
   CURSOR c1
   IS
      SELECT wpr_int_code, wpr_use_working_days
        FROM WORK_ORDER_PRIORITIES
       WHERE wpr_id = p_wpr_id;

   l_int_code        WORK_ORDER_PRIORITIES.wpr_int_code%TYPE;
   l_use_work_days   WORK_ORDER_PRIORITIES.wpr_use_working_days%TYPE;
BEGIN
   IF p_wpr_id IS NOT NULL
   THEN
      OPEN c1;

      FETCH c1
       INTO l_int_code, l_use_work_days;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         p_error := Hig.get_error_message ('HWAYS', 128);
         RETURN;
      END IF;

      CLOSE c1;

      IF l_use_work_days = 'Y'
      THEN
         p_target_date := Higddue.date_due (p_date, l_int_code, TRUE);
--  if not form_success then plib$fail; end if;
      ELSE
         p_target_date := Higddue.date_due (p_date, l_int_code, FALSE);
--  if not form_success then plib$fail; end if;
      END IF;
   ELSE
      p_target_date := NULL;
   END IF;
END date_from_priority;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE set_child_asset_params(pi_parent_tab IN parent_asset_tab
                                ,pi_child_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
BEGIN
  --
  g_parent_asset_tab := pi_parent_tab;
  g_child_asset_type := pi_child_type;
  --
END set_child_asset_params;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE get_child_assets(po_child_assets IN OUT child_asset_tab) IS
  --
  TYPE child_fetch_rec IS RECORD(child_item_id   nm_inv_items_all.iit_ne_id%TYPE
                                ,child_inv_type  nm_inv_types_all.nit_inv_type%TYPE
                                ,child_primary   nm_inv_items_all.iit_primary_key%TYPE
                                ,child_descr     nm_inv_items_all.iit_descr%TYPE);


  TYPE child_fetch_tab IS TABLE OF child_fetch_rec INDEX BY BINARY_INTEGER;
  lt_child_fetch child_fetch_tab;
  --
  lt_retval child_asset_tab;
  lv_retind PLS_INTEGER:=0;
  --
  PROCEDURE get_children(pi_parent_id  nm_inv_items_all.iit_ne_id%TYPE
                        ,pi_child_type nm_inv_types_all.nit_inv_type%TYPE) IS
  BEGIN
    --
    SELECT iit_ne_id
          ,iit_inv_type
          ,iit_primary_key
          ,iit_descr
      BULK COLLECT
      INTO lt_child_fetch
      FROM nm_inv_items
     WHERE iit_ne_id IN(SELECT iig_item_id
                          FROM nm_inv_item_groupings
                         WHERE iig_top_id = pi_parent_id)
       AND iit_inv_type = pi_child_type
         ;
    --
  END get_children;
BEGIN
nm_debug.debug_on;
  /*
  ||Loop Throug The Parent Assets.
  */
  FOR i IN 1..g_parent_asset_tab.count LOOP
    /*
    ||Fetch The Child Assets.
    */
    get_children(pi_parent_id  => g_parent_asset_tab(i).item_id
                ,pi_child_type => g_child_asset_type);
nm_debug.debug('Parent = '||g_parent_asset_tab(i).item_id
             ||' Child Type = '||g_child_asset_type
             ||' Number Of Records = '||lt_child_fetch.count);
    --
    FOR j IN 1..lt_child_fetch.count LOOP
      /*
      ||Increment The Index For lt_retval.
      */
      lv_retind := lv_retind+1;
      /*
      ||Set The Parent Details.
      */
      lt_retval(lv_retind).parent_inv_type := g_parent_asset_tab(i).inv_type;
      lt_retval(lv_retind).parent_primary  := g_parent_asset_tab(i).primary_key;
      lt_retval(lv_retind).parent_descr    := g_parent_asset_tab(i).descr;
      lt_retval(lv_retind).ne_id           := g_parent_asset_tab(i).road_id;
      lt_retval(lv_retind).x               := g_parent_asset_tab(i).x;
      lt_retval(lv_retind).y               := g_parent_asset_tab(i).y;
      /*
      ||Set The Child Details.
      */
      lt_retval(lv_retind).child_item_id  := lt_child_fetch(j).child_item_id;
      lt_retval(lv_retind).child_inv_type := lt_child_fetch(j).child_inv_type;
      lt_retval(lv_retind).child_primary  := lt_child_fetch(j).child_primary;
      lt_retval(lv_retind).child_descr    := lt_child_fetch(j).child_descr;
      --
    END LOOP;
    --
  END LOOP;
  --
  po_child_assets := lt_retval;
  --
nm_debug.debug_off;
END get_child_assets;
--
---------------------------------------------------------------------------------------------------
--
BEGIN  /* mai - automatic variables */
  /*
    return the Oracle user who is owner of the MAI application
    (use 'DEFECTS' as the sample HIGHWAYS object)
  */
  g_application_owner := get_owner( 'DEFECTS');
  IF    (g_application_owner IS NULL) THEN
    RAISE_APPLICATION_ERROR( -20000 ,'MAI.G_APPLICATION_OWNER is null.');
  END IF;

  /* return the language under which the application is running */
  g_language := 'ENGLISH';

  /* instantiate common error messages */

END mai;
/
