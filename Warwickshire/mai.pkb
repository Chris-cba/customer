CREATE OR REPLACE PACKAGE BODY mai AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/Warwickshire/mai.pkb-arc   1.0   Nov 19 2015 10:24:14   Chris.Baugh  $
--       Module Name      : $Workfile:   mai.pkb  $
--       Date into SCCS   : $Date:   Nov 19 2015 10:24:14  $
--       Date fetched Out : $Modtime:   Nov 19 2015 10:11:40  $
--       SCCS Version     : $Revision:   1.0  $
--       Based on SCCS Version     : 1.33
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

   g_swr_licenced      BOOLEAN;
   g_tma_licenced      BOOLEAN;
--
   insert_error  EXCEPTION;
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
---------------------------------------------------------------------------------------------------
--
  -- SM 29092008 714910 based on log below.
  -- PT log 711850
  -- this checks on admin units that the road segment can be selected
  --  from road_segments_all by the current user
  -- if p_ne_id is null then does nothing
  procedure check_rse_admin_unit(
     p_ne_id in nm_elements.ne_id%type
    ,p_user in varchar2
  )
  is
    l_dummy   varchar2(1);
    l_user    varchar2(30) := p_user;
  begin
    if p_ne_id is not null then
      if l_user is null then
        l_user := Sys_Context('NM3_SECURITY_CTX','USERNAME');
      end if;
      -- the criteria taken from the road_segments_all view
      select 'x' dummy
      into l_dummy
      from road_segs s
      where s.rse_he_id = p_ne_id
        and (s.rse_admin_unit in (
          select hag_child_admin_unit
          from
             hig_admin_groups
            ,hig_users
          where hag_parent_admin_unit = hus_admin_unit
            and hus_username = l_user
          )
          or rse_admin_unit in (
            select hau_admin_unit
            from hig_admin_units
            where hau_level = 1
          )
        );
      end if;
    exception
      when no_data_found then
        begin
          select 'x' dummy
          into l_dummy
          from road_segs s
          where s.rse_he_id = p_ne_id;
          hig.raise_ner(
              pi_appl     => nm3type.c_hig
             ,pi_id       => 48 -- The admin unit is inconsistent with this road segment
             ,pi_sqlcode  => -20000
          );
        exception
          when no_data_found then
            raise_application_error(-20001, 'Road segment not found: rse_he_id='||p_ne_id);
        end;
    end;
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
END parse_inv_condition;
--
-----------------------------------------------------------------------------
-- Function to retrieve Context. SM-07102004
FUNCTION get_context(pi_namespace IN varchar2
                    ,pi_attribute IN varchar2)
  RETURN varchar2 IS
  --
BEGIN
  --
  RETURN SYS_CONTEXT(pi_namespace,pi_attribute);
  --
END get_context;
--
-----------------------------------------------------------------------------
--
FUNCTION wol_id_nextseq
  RETURN NUMBER IS
  --
  cursor c1
      is
  select wol_id_seq.nextval
    from sys.dual
       ;
  --
  l_wol_id work_order_lines.wol_id%TYPE;
  --
BEGIN
  --
  OPEN  c1;
  FETCH c1
   INTO l_wol_id;
  CLOSE c1;
  --
  RETURN l_wol_id;
  --
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
  lt_query nm3type.tab_varchar32767;
  --
  lv_tot_qty     NUMBER;
  lv_iit_width2  inv_items_all.iit_width%TYPE;
  --
  TYPE calc_rec IS RECORD(iit_end_chain     inv_items_all.iit_end_chain%TYPE
                         ,iit_st_chain      inv_items_all.iit_st_chain%TYPE
                         ,iit_width         inv_items_all.iit_width%TYPE
                         ,iit_height        inv_items_all.iit_height%TYPE
                         ,iit_ity_inv_code  inv_items_all.iit_ity_inv_code%TYPE
                         ,iit_ity_sys_flag  inv_items_all.iit_ity_sys_flag%TYPE
                         ,iit_x_sect        inv_items_all.iit_x_sect%TYPE
                         ,rel_factor        related_inventory.rel_factor%TYPE);
  TYPE calc_tab IS TABLE OF calc_rec;
  lt_calc calc_tab;
  --
  CURSOR c2(cp_he_id             nm_elements_all.ne_id%TYPE
           ,cp_iit_ity_inv_code  inv_items_all.iit_ity_inv_code%TYPE
           ,cp_iit_ity_sys_flag  inv_items_all.iit_ity_sys_flag%TYPE
           ,cp_iit_end_chain     inv_items_all.iit_end_chain%TYPE
           ,cp_iit_x_sect        inv_items_all.iit_x_sect%TYPE)
      IS
  SELECT iit_width
    FROM inv_items_all_section
   WHERE iit_rse_he_id       = cp_he_id
     AND iit_ity_inv_code    = cp_iit_ity_inv_code
     AND iit_ity_sys_flag    = cp_iit_ity_sys_flag
     AND iit_st_chain        = cp_iit_end_chain
     AND NVL(iit_x_sect,'Z') = NVL(cp_iit_x_sect,'Z')
     AND SYSDATE BETWEEN iit_cre_date
                     AND NVL(iit_end_date,SYSDATE)
       ;
  --
  PROCEDURE get_rel
    IS
  BEGIN
    --
    SELECT 'SELECT iit_end_chain,iit_st_chain,iit_width,iit_height'
          ||',iit_ity_inv_code,iit_ity_sys_flag,iit_x_sect,'||to_char(rel_factor)
          ||' FROM inv_items_all_section,nm_elements '
          ||' WHERE ne_id = '||TO_CHAR(he_id)
          ||' AND ne_id = iit_rse_he_id'
          ||' AND iit_ity_inv_code = '||nm3flx.string(rel_ity_inv_code)
          ||' AND iit_ity_sys_flag = '||nm3flx.string(rel_ity_sys_flag)
          ||DECODE(rel_condition, NULL, NULL,' AND '||rel_condition)
          ||' AND SYSDATE BETWEEN iit_cre_date AND NVL(iit_end_date,SYSDATE)'
      BULK COLLECT
      INTO lt_query
      FROM related_inventory
     WHERE rel_sta_item_code = item_code
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_rel;
  --
BEGIN
  /*
  ||Get The Query To Return The Assets Related
  ||To The Standard Item And Section.
  */
  get_rel;
  /*
  ||Execute Each Query Returned And Calaculate
  ||The Cumulative Quatity.
  */
  FOR i IN 1..lt_query.count LOOP
    --
    BEGIN
      /*
      ||Execute The Query.
      */
      EXECUTE IMMEDIATE lt_query(i) BULK COLLECT INTO lt_calc;
      /*
      ||Calculate The Quantity.
      */
      FOR j IN 1..lt_calc.count LOOP
        IF calc_type = 'N'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + (1 * lt_calc(j).rel_factor);
        ELSIF calc_type = 'L'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + ((NVL(lt_calc(j).iit_end_chain,lt_calc(j).iit_st_chain)-lt_calc(j).iit_st_chain)
                                               * lt_calc(j).rel_factor);
        ELSIF calc_type = 'A'
         THEN
            lv_tot_qty := nvl(lv_tot_qty,0) + ((NVL(lt_calc(j).iit_width,0) * NVL(lt_calc(j).iit_height,0))
                                               * lt_calc(j).rel_factor);
        ELSIF calc_type = 'T'
         THEN
            --
            OPEN  c2(he_id
                    ,lt_calc(j).iit_ity_inv_code
                    ,lt_calc(j).iit_ity_sys_flag
                    ,lt_calc(j).iit_end_chain
                    ,lt_calc(j).iit_x_sect);
            FETCH c2
             INTO lv_iit_width2;
            CLOSE c2;
            --
            IF NVL(lv_iit_width2,0) = 0
             THEN
                lv_iit_width2 := NVL(lt_calc(j).iit_width,0);
            END IF;
            --
            lv_tot_qty := NVL(lv_tot_qty,0) + ((NVL(lt_calc(j).iit_width,0) + lv_iit_width2)
                                               * 0.5
                                               *(NVL(lt_calc(j).iit_end_chain,lt_calc(j).iit_st_chain)-lt_calc(j).iit_st_chain)
                                               *lt_calc(j).rel_factor);
            --
        END IF;
      END LOOP;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          NULL;
      WHEN others
       THEN
          RAISE;
    END;
  END LOOP;
  /*
  ||Return The Total Quantity.
  */
  quantity := NVL(lv_tot_qty,0);
  --
END calculate_inv_quantity;
--
PROCEDURE upd_schd_items_and_roads(pi_schd_id IN schedules.schd_id%TYPE)
  IS
  --
  lv_qty     schedule_items.schi_calc_quantity%type:=0;
  lv_total_qty  schedule_items.schi_calc_quantity%type:=0;
  --
  TYPE items_rec IS RECORD(schr_sta_item_code schedule_roads.schr_sta_item_code%TYPE
                          ,sta_calc_type      standard_items.sta_calc_type%TYPE);
  TYPE items_tab IS TABLE OF items_rec;
  lt_items items_tab;
  --
  TYPE roads_tab IS TABLE OF schedule_roads.schr_rse_he_id%TYPE;
  lt_roads roads_tab;
  --
  TYPE qty_tab IS TABLE OF schedule_roads.schr_calc_quantity%TYPE INDEX BY BINARY_INTEGER;
  lt_qty qty_tab;
  --
  PROCEDURE get_items
    IS
  BEGIN
    SELECT DISTINCT schr_sta_item_code
          ,sta_calc_type
      BULK COLLECT
      INTO lt_items
      FROM related_inventory
          ,standard_items
          ,schedule_roads
     WHERE rel_sta_item_code = sta_item_code
       AND sta_item_code = schr_sta_item_code
       AND schr_schd_id = pi_schd_id
         ;
  END get_items;
  --
  PROCEDURE get_roads
    IS
  BEGIN
    SELECT DISTINCT schr_rse_he_id
      BULK COLLECT
      INTO lt_roads
      FROM schedule_roads
     WHERE schr_schd_id = pi_schd_id
         ;
  END get_roads;
  --
BEGIN
  /*
  ||Get The Standard Items To Calculate Quantities For.
  */
  get_items;
  /*
  ||Get The Sections To Be Processed.
  */
  get_roads;
  /*
  ||Calculate The Quantities For Each Standard Item.
  */
  FOR i IN 1..lt_items.count LOOP
    /*
    ||Zero The Item Total Quantity.
    */
    lv_total_qty := 0;
    /*
    ||Calaculate The Items Quantity For Each Section.
    */
    FOR j IN 1..lt_roads.count LOOP
      --
      mai.calculate_inv_quantity(lt_roads(j)
                                ,lt_items(i).sta_calc_type
                                ,lt_items(i).schr_sta_item_code
                                ,lv_qty);
      --
      lt_qty(j) := lv_qty;
      lv_total_qty := lv_total_qty + lt_qty(j);
      --
    END LOOP;
    /*
    ||Update The Section Quantities.
    */
    FORALL k IN 1..lt_roads.count
    UPDATE schedule_roads
       SET schr_act_quantity  = lt_qty(k)
          ,schr_calc_quantity = lt_qty(k)
          ,schr_last_updated  = SYSDATE
     WHERE schr_sta_item_code = lt_items(i).schr_sta_item_code
       AND schr_rse_he_id     = lt_roads(k)
       AND schr_schd_id       = pi_schd_id
           ;
    /*
    ||Update The Standard Item Total Quantity.
    */
    UPDATE schedule_items
       SET schi_last_updated  = SYSDATE
          ,schi_act_quantity  = lv_total_qty
          ,schi_calc_quantity = lv_total_qty
     WHERE schi_sta_item_code = lt_items(i).schr_sta_item_code
       and schi_schd_id       = pi_schd_id
         ;
    --
  END LOOP;
  --
END upd_schd_items_and_roads;
--
PROCEDURE pop_schd_roads(pi_schd_id   IN schedules.schd_id%type
                        ,pi_group_id  IN road_groups.rse_he_id%type
                        ,pi_item_code IN standard_items.sta_item_code%type) IS
BEGIN
  insert
    into schedule_roads
        (schr_schd_id
        ,schr_sta_item_code
        ,schr_rse_he_id
        ,schr_act_quantity
        ,schr_last_updated)
  select pi_schd_id
        ,pi_item_code
        ,rsm_rse_he_id_of
        ,'0'
        ,sysdate
    from road_seg_membs
   where rsm_type = 'S'
     and rsm_end_date is null
 connect by prior rsm_rse_he_id_of = rsm_rse_he_id_in
   start with rsm_rse_he_id_in = pi_group_id
       ;
END pop_schd_roads;
--
--
PROCEDURE upd_schedule_quantity_assets(pi_schd_id   IN schedules.schd_id%TYPE
                                      ,pi_group_id  IN road_segs.rse_he_id%TYPE
                                      ,pi_item_code IN standard_items.sta_item_code%TYPE) IS

  /*
  || This Procedure Was Created To Move The Bulk Of The Program
  || Unit pop_schd_items_assets From mai3860 To The Server.
  */
  lv_item_id   inv_items_all.iit_item_id%type;
  lv_quantity  number:=0;
  --
  TYPE items_tab IS TABLE of schedule_items.schi_sta_item_code%TYPE;
  lt_items items_tab;
  --
  TYPE roads_tab IS TABLE of nm_elements_all.ne_id%TYPE;
  lt_roads roads_tab;
  --
  PROCEDURE get_items
    IS
  BEGIN
    --
    SELECT schi_sta_item_code
      BULK COLLECT
      INTO lt_items
      FROM schedule_items
          ,schedules
     WHERE schd_id = pi_schd_id
       AND schd_id = schi_schd_id
       AND EXISTS(SELECT 1
                    FROM related_inventory
                   WHERE rel_sta_item_code = schi_sta_item_code)
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_items;
  --
  PROCEDURE get_network
    IS
  BEGIN
    --
    SELECT rsm_rse_he_id_of
      BULK COLLECT
      INTO lt_roads
      FROM road_seg_membs
     WHERE rsm_type = 'S'
       AND rsm_end_date is null
   CONNECT BY PRIOR rsm_rse_he_id_of = rsm_rse_he_id_in
     START WITH rsm_rse_he_id_in = pi_group_id
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_network;
  --
BEGIN
  --
  DELETE
    FROM schedule_roads
   WHERE schr_schd_id=pi_schd_id
       ;
  --
  get_network;
  get_items;
  --
  FOR i IN 1..lt_roads.count LOOP
    --
    FOR j IN 1..lt_items.count LOOP
      --
      calculate_inv_quantity_assets(pi_schd_id
                                   ,lt_roads(i)
                                   ,'N'
                                   ,lt_items(j)
                                   ,lv_item_id
                                   ,lv_quantity);
      --
    END LOOP;
    --
  END LOOP;
  --
  UPDATE schedule_items schi
     SET schi.schi_calc_quantity = (SELECT NVL(SUM(schr_calc_quantity),0)
                                      FROM schedule_roads schr
                                     WHERE schr.schr_schd_id=schi.schi_schd_id
                                       AND schr.schr_sta_item_code = schi.schi_sta_item_code)
        ,schi.schi_last_updated = SYSDATE
   WHERE schi.schi_schd_id=pi_schd_id
       ;
  --
  UPDATE schedule_items schi
     SET schi.schi_act_quantity = schi.schi_calc_quantity
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
  lt_query nm3type.tab_varchar32767;
  --
  TYPE iit_item_id_tab IS TABLE OF inv_items_all.iit_item_id%TYPE;
  lt_iit_item_id iit_item_id_tab;
  lt_count nm3type.tab_number;
  --
  l_query     VARCHAR2(32767);
  l_cursor_id INTEGER;
  l_status    INTEGER;
  lcnt        NUMBER;
  lid         NUMBER;
  --
  PROCEDURE get_rel
    IS
  BEGIN
    --
    SELECT 'SELECT iit_item_id,count(*)'
         ||' FROM inv_items_all_section,nm_elements'
         ||' WHERE ne_id ='||TO_CHAR(he_id)
         ||' AND ne_id = iit_rse_he_id'
         ||' AND iit_ity_inv_code = '||nm3flx.string(rel_ity_inv_code)
         ||' AND iit_ity_sys_flag = '||nm3flx.string(rel_ity_sys_flag)
         ||' AND SYSDATE BETWEEN iit_cre_date AND NVL(iit_end_date, sysdate)'
         ||DECODE(rel_condition,NULL,NULL,' AND '||rel_condition)
         ||' GROUP BY iit_item_id'
      BULK COLLECT
      INTO lt_query
      FROM related_inventory
     WHERE rel_sta_item_code = item_code
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        NULL;
    WHEN others
     THEN
        RAISE;
  END get_rel;
  --
BEGIN
  --
  --nm_debug.debug_on;
  --
  get_rel;
  --
  FOR i IN 1..lt_query.count LOOP
    --
    --nm_debug.debug(lt_query(i));
    BEGIN
      EXECUTE IMMEDIATE lt_query(i) BULK COLLECT INTO lt_iit_item_id
                                                     ,lt_count
                                                     ;
      --
      FOR j IN 1..lt_iit_item_id.count LOOP
        --
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
              ,lt_count(j)
              ,lt_count(j)
              ,SYSDATE
              ,lt_iit_item_id(j))
             ;
        --
      END LOOP;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          NULL;
      WHEN others
       THEN
          RAISE;
    END;
  END LOOP;
  /*
  ||Doesn't make any sense to pass these back.
  ||Previous code was just passing back the last
  ||Asset processed.
  */
  quantity := 0;             -- pass calculated value back
  item_id  := 0;             -- pass the asset id's back
  --
  --nm_debug.debug_off;
  --
END calculate_inv_quantity_assets;
--
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
       --SM 26032009 719068
       --Increased the size of v_stg from 2000 to max.
       v_stg          nm3type.max_varchar2 := 'Create or Replace force view '||view_name||
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
      AND owner = Sys_Context('NM3_SECURITY_CTX','USERNAME');
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
         l_top_user := Sys_Context('NM3_SECURITY_CTX','USERNAME');
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
--
-------------------------------------------------------------------------------
--
FUNCTION get_insp_date(pi_report_id IN activities_report.are_report_id%TYPE)
  RETURN activities_report.are_date_work_done%TYPE IS
  --
  lv_retval  activities_report.are_date_work_done%TYPE;
  --
BEGIN
  --
  SELECT are_date_work_done
    INTO lv_retval
    FROM activities_report
   WHERE are_report_id = pi_report_id
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20001,'Invalid Inspection Id Supplied: '||pi_report_id);
  WHEN others
   THEN
      RAISE;
END get_insp_date;
--
-------------------------------------------------------------------------------
--
FUNCTION create_defect(p_rse_he_id         IN defects.def_rse_he_id%TYPE
                      ,p_iit_item_id       IN defects.def_iit_item_id%TYPE
                      ,p_st_chain          IN defects.def_st_chain%TYPE
                      ,p_report_id         IN defects.def_are_report_id%TYPE
                      ,p_acty_area_code    IN defects.def_atv_acty_area_code%TYPE
                      ,p_siss_id           IN defects.def_siss_id%TYPE
                      ,p_works_order_no    IN defects.def_works_order_no%TYPE
                      ,p_defect_code       IN defects.def_defect_code%TYPE
                      ,p_orig_priority     IN defects.def_orig_priority%TYPE
                      ,p_priority          IN defects.def_priority%TYPE
                      ,p_status_code       IN defects.def_status_code%TYPE
                      ,p_area              IN defects.def_area%TYPE
                      ,p_are_id_not_found  IN defects.def_are_id_not_found%TYPE
                      ,p_coord_flag        IN defects.def_coord_flag%TYPE
                      ,p_defect_class      IN defects.def_defect_class%TYPE
                      ,p_defect_descr      IN defects.def_defect_descr%TYPE
                      ,p_defect_type_descr IN defects.def_defect_type_descr%TYPE
                      ,p_diagram_no        IN defects.def_diagram_no%TYPE
                      ,p_height            IN defects.def_height%TYPE
                      ,p_ident_code        IN defects.def_ident_code%TYPE
                      ,p_ity_inv_code      IN defects.def_ity_inv_code%TYPE
                      ,p_ity_sys_flag      IN defects.def_ity_sys_flag%TYPE
                      ,p_length            IN defects.def_length%TYPE
                      ,p_locn_descr        IN defects.def_locn_descr%TYPE
                      ,p_maint_wo          IN defects.def_maint_wo%TYPE
                      ,p_mand_adv          IN defects.def_mand_adv%TYPE
                      ,p_notify_org_id     IN defects.def_notify_org_id%TYPE
                      ,p_number            IN defects.def_number%TYPE
                      ,p_per_cent          IN defects.def_per_cent%TYPE
                      ,p_per_cent_orig     IN defects.def_per_cent_orig%TYPE
                      ,p_per_cent_rem      IN defects.def_per_cent_rem%TYPE
                      ,p_rechar_org_id     IN defects.def_rechar_org_id%TYPE
                      ,p_serial_no         IN defects.def_serial_no%TYPE
                      ,p_skid_coeff        IN defects.def_skid_coeff%TYPE
                      ,p_special_instr     IN defects.def_special_instr%TYPE
                      ,p_time_hrs          IN defects.def_time_hrs%TYPE
                      ,p_time_mins         IN defects.def_time_mins%TYPE
                      ,p_update_inv        IN defects.def_update_inv%TYPE
                      ,p_x_sect            IN defects.def_x_sect%TYPE
                      ,p_easting           IN defects.def_easting%TYPE
                      ,p_northing          IN defects.def_northing%TYPE
                      ,p_response_category IN defects.def_response_category%TYPE)
  RETURN NUMBER IS
  --
  l_defect_id   defects.def_defect_id%TYPE;
  l_today       DATE := SYSDATE;
  l_insp_date   activities_report.are_date_work_done%TYPE;
  insert_error  EXCEPTION;
  --
BEGIN
  --SM 29082008 714910
  check_rse_admin_unit(p_ne_id  => p_rse_he_id
                      ,p_user   => Sys_Context('NM3_SECURITY_CTX','USERNAME'));
  /*
  ||Get The Inspection Date.
  */
  l_insp_date := get_insp_date(pi_report_id => p_report_id);
  --
  SELECT def_defect_id_seq.NEXTVAL
  INTO   l_defect_id
  FROM   dual;
  --
  INSERT
    INTO defects
        (def_defect_id
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
        ,def_inspection_date)
  VALUES(l_defect_id
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
        ,l_insp_date)
       ;
  --
  IF SQL%rowcount != 1
   THEN
      RAISE insert_error;
  END IF;
  --
  RETURN l_defect_id;
  --
EXCEPTION
  WHEN insert_error
   THEN
      RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Defect');
END;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(p_rse_he_id         IN defects.def_rse_he_id%TYPE
                      ,p_iit_item_id       IN defects.def_iit_item_id%TYPE
                      ,p_st_chain          IN defects.def_st_chain%TYPE
                      ,p_report_id         IN defects.def_are_report_id%TYPE
                      ,p_acty_area_code    IN defects.def_atv_acty_area_code%TYPE
                      ,p_siss_id           IN defects.def_siss_id%TYPE
                      ,p_works_order_no    IN defects.def_works_order_no%TYPE
                      ,p_defect_code       IN defects.def_defect_code%TYPE
                      ,p_orig_priority     IN defects.def_orig_priority%TYPE
                      ,p_priority          IN defects.def_priority%TYPE
                      ,p_status_code       IN defects.def_status_code%TYPE
                      ,p_area              IN defects.def_area%TYPE
                      ,p_are_id_not_found  IN defects.def_are_id_not_found%TYPE
                      ,p_coord_flag        IN defects.def_coord_flag%TYPE
                      ,p_defect_class      IN defects.def_defect_class%TYPE
                      ,p_defect_descr      IN defects.def_defect_descr%TYPE
                      ,p_defect_type_descr IN defects.def_defect_type_descr%TYPE
                      ,p_diagram_no        IN defects.def_diagram_no%TYPE
                      ,p_height            IN defects.def_height%TYPE
                      ,p_ident_code        IN defects.def_ident_code%TYPE
                      ,p_ity_inv_code      IN defects.def_ity_inv_code%TYPE
                      ,p_ity_sys_flag      IN defects.def_ity_sys_flag%TYPE
                      ,p_length            IN defects.def_length%TYPE
                      ,p_locn_descr        IN defects.def_locn_descr%TYPE
                      ,p_maint_wo          IN defects.def_maint_wo%TYPE
                      ,p_mand_adv          IN defects.def_mand_adv%TYPE
                      ,p_notify_org_id     IN defects.def_notify_org_id%TYPE
                      ,p_number            IN defects.def_number%TYPE
                      ,p_per_cent          IN defects.def_per_cent%TYPE
                      ,p_per_cent_orig     IN defects.def_per_cent_orig%TYPE
                      ,p_per_cent_rem      IN defects.def_per_cent_rem%TYPE
                      ,p_rechar_org_id     IN defects.def_rechar_org_id%TYPE
                      ,p_serial_no         IN defects.def_serial_no%TYPE
                      ,p_skid_coeff        IN defects.def_skid_coeff%TYPE
                      ,p_special_instr     IN defects.def_special_instr%TYPE
                      ,p_time_hrs          IN defects.def_time_hrs%TYPE
                      ,p_time_mins         IN defects.def_time_mins%TYPE
                      ,p_update_inv        IN defects.def_update_inv%TYPE
                      ,p_x_sect            IN defects.def_x_sect%TYPE
                      ,p_easting           IN defects.def_easting%TYPE
                      ,p_northing          IN defects.def_northing%TYPE
                      ,p_response_category IN defects.def_response_category%TYPE
                      ,p_date_created      IN defects.def_created_date%TYPE)
  RETURN NUMBER IS
  --
  l_defect_id   defects.def_defect_id%TYPE;
  l_today       DATE := SYSDATE;
  l_insp_date   activities_report.are_date_work_done%TYPE;
  v_f_table  varchar2(200);
  v_f_shape_col  varchar2(200);
  sql1 varchar2(2000);
  v_chainage defects.def_st_chain%TYPE;
  insert_error  EXCEPTION;
  --
BEGIN
  --SM 29082008 714910
  check_rse_admin_unit(p_ne_id  => p_rse_he_id
                      ,p_user   => Sys_Context('NM3_SECURITY_CTX','USERNAME'));
  /*
  ||Get The Inspection Date.
  */
  l_insp_date := get_insp_date(pi_report_id => p_report_id);
  --
  /* Get chainage from ne_id , easting  northing 21-OCT-2015
  start block */
  if (p_st_chain=0 and p_easting is not null and p_northing is not null) then
  select 	nth_feature_table,
			nth_feature_shape_column
			into
			v_f_table,
			v_f_shape_col
	from nm_themes_all,
		nm_linear_types,
		nm_nw_themes,
		nm_elements
	where nth_theme_id = nnth_nth_theme_id 
	and	nnth_nlt_id = nlt_id
	and ne_id = p_rse_he_id
	and ne_nt_type = nlt_nt_type
	and nvl(ne_gty_group_type,'&$%^') = NVL(nlt_gty_type,'&$%^') 
	and nth_base_table_theme is null;
	
	sql1 := 'SELECT
		min(sdo_lrs.GEOM_SEGMENT_START_MEASURE(sdo_lrs.project_pt('||v_f_shape_col||',nm3sdo.get_2d_pt('||p_easting||','||p_northing||'),0.05)))
		from '||v_f_table|| ' s, nm_elements e
		where e.ne_id = s.ne_id
		and s.ne_id = '||p_rse_he_id;
		
	execute immediate sql1 into v_chainage;
	v_chainage := nvl(v_chainage,0);
  else 
	v_chainage := p_st_chain;
  end if;
  -- end block
 
  SELECT def_defect_id_seq.NEXTVAL
    INTO l_defect_id
    FROM dual;
  --
  INSERT
    INTO defects
        (def_defect_id
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
        ,def_inspection_date)
  VALUES(l_defect_id
        ,p_rse_he_id
        ,p_iit_item_id
        ,v_chainage     /* Get chainage from ne_id , easting northing 21-OCT-2015 */
        ,p_report_id
        ,p_acty_area_code
        ,p_siss_id
        ,p_works_order_no
        --,p_date_created  --ignore the date passed in, it should always be the date/time the defects record is inserted
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
        ,l_insp_date)
       ;
  --
  IF SQL%rowcount != 1
   THEN
      RAISE insert_error;
  END IF;
  --
  RETURN l_defect_id;
  --
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
FUNCTION ins_defect(pi_defect_rec defects%ROWTYPE)
  RETURN defects.def_defect_id%TYPE IS
  --
  lv_defect_id   defects.def_defect_id%TYPE;
  --
BEGIN
  /*
  ||Check The Defect Id (Primary Key).
  */
  IF pi_defect_rec.def_defect_id IS NULL
   THEN
      lv_defect_id := mai_inspection_api.get_next_id('def_defect_id_seq');
  ELSE
      lv_defect_id := pi_defect_rec.def_defect_id;
  END IF;
  /*
  ||Insert The Defect.
  */
  INSERT
    INTO defects
        (def_defect_id
        ,def_rse_he_id
        ,def_iit_item_id
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
        ,def_inspection_date)
 VALUES (lv_defect_id
        ,pi_defect_rec.def_rse_he_id
        ,pi_defect_rec.def_iit_item_id
        ,pi_defect_rec.def_st_chain
        ,pi_defect_rec.def_are_report_id
        ,pi_defect_rec.def_atv_acty_area_code
        ,pi_defect_rec.def_siss_id
        ,pi_defect_rec.def_works_order_no
        ,pi_defect_rec.def_created_date
        ,pi_defect_rec.def_defect_code
        ,sysdate
        ,pi_defect_rec.def_orig_priority
        ,pi_defect_rec.def_priority
        ,pi_defect_rec.def_status_code
        ,NVL(pi_defect_rec.def_superseded_flag,'N')
        ,pi_defect_rec.def_area
        ,pi_defect_rec.def_are_id_not_found
        ,pi_defect_rec.def_coord_flag
        ,pi_defect_rec.def_date_compl
        ,pi_defect_rec.def_date_not_found
        ,pi_defect_rec.def_defect_class
        ,pi_defect_rec.def_defect_descr
        ,pi_defect_rec.def_defect_type_descr
        ,pi_defect_rec.def_diagram_no
        ,pi_defect_rec.def_height
        ,pi_defect_rec.def_ident_code
        ,pi_defect_rec.def_ity_inv_code
        ,pi_defect_rec.def_ity_sys_flag
        ,pi_defect_rec.def_length
        ,pi_defect_rec.def_locn_descr
        ,pi_defect_rec.def_maint_wo
        ,pi_defect_rec.def_mand_adv
        ,pi_defect_rec.def_notify_org_id
        ,pi_defect_rec.def_number
        ,pi_defect_rec.def_per_cent
        ,pi_defect_rec.def_per_cent_orig
        ,pi_defect_rec.def_per_cent_rem
        ,pi_defect_rec.def_rechar_org_id
        ,pi_defect_rec.def_serial_no
        ,pi_defect_rec.def_skid_coeff
        ,pi_defect_rec.def_special_instr
        ,pi_defect_rec.def_superseded_id
        ,pi_defect_rec.def_time_hrs
        ,pi_defect_rec.def_time_mins
        ,pi_defect_rec.def_update_inv
        ,pi_defect_rec.def_x_sect
        ,pi_defect_rec.def_easting
        ,pi_defect_rec.def_northing
        ,pi_defect_rec.def_response_category
        ,pi_defect_rec.def_inspection_date);
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
  --
  RETURN lv_defect_id;
  --
EXCEPTION
  WHEN insert_error
   THEN
      raise_application_error(-20040, 'Error occured while creating Activities Report.');
  WHEN others
   THEN
      RAISE;
END ins_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(pi_insp_rec   IN activities_report%ROWTYPE
                      ,pi_defect_rec IN defects%ROWTYPE
                      ,pi_repair_tab IN rep_tab
                      ,pi_boq_tab    IN boq_tab)
  RETURN NUMBER IS
  --
  lv_repsetperd       hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERD');
  lv_usedefchnd       hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHND');
  lv_usetremodd       hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODD');
  lv_repsetperl       hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERL');
  lv_usedefchnl       hig_options.hop_value%TYPE := hig.GET_SYSOPT('USEDEFCHNL');
  lv_usetremodl       hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODL');
  lv_tremodlev        hig_options.hop_value%TYPE := hig.get_sysopt('TREMODLEV');
  lv_insp_init        hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_INIT'),'DUM');
  lv_insp_sdf         hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_SDF'),'D');
  lv_siss             hig_options.hop_value%TYPE := NVL(hig.get_sysopt('DEF_SISS'),'ALL');
  lv_locdefboqs       hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('LOCDEFBOQS');
  lv_insp_id          activities_report.are_report_id%TYPE;
  lv_defect_id        defects.def_defect_id%TYPE;
  lv_action_cat       repairs.rep_action_cat%TYPE;
  lv_entity_type      VARCHAR2(10);
  lv_date_due         repairs.rep_date_due%TYPE;
  lv_sys_flag         road_segs.rse_sys_flag%TYPE;
  lv_admin_unit       hig_admin_units.hau_admin_unit%TYPE;
  lv_compl_rep_count  PLS_INTEGER := 0;
  lv_def_date_compl   DATE;
  lv_def_status       hig_status_codes.hsc_status_code%type;
  lv_boqs_created     NUMBER;
  lv_dummy            NUMBER;
  --
  lr_defect_rec     defects%ROWTYPE;
  lr_repair_rec     repairs%ROWTYPE;
  --
  lt_boq_tab        boq_tab;
  lt_empty_boq_tab  boq_tab;
  --
  insert_error  EXCEPTION;
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
  --SM 29082008 714910
  check_rse_admin_unit(
     p_ne_id  => pi_insp_rec.are_rse_he_id
    ,p_user   => Sys_Context('NM3_SECURITY_CTX','USERNAME')
  );
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
  /*
  ||If All The Repairs Passed In Are Complete Then
  ||The Defect Should Be Created With The Complete
  ||Status And The Defect Completion Date Should
  ||Be Populated.
  */
  FOR i IN 1..pi_repair_tab.count LOOP
    --
    IF pi_repair_tab(i).rep_date_completed IS NOT NULL
     THEN
        lv_compl_rep_count := lv_compl_rep_count+1;
        IF lv_def_date_compl IS NULL
         OR pi_repair_tab(i).rep_date_completed > lv_def_date_compl
         THEN
            IF pi_repair_tab(i).rep_completed_hrs IS NOT NULL
             AND pi_repair_tab(i).rep_completed_mins IS NOT NULL
             THEN
                lv_def_date_compl := TO_DATE(TO_CHAR(pi_repair_tab(i).rep_date_completed,'DD-MON-RRRR')
                                              ||pi_repair_tab(i).rep_completed_hrs
                                              ||':'||pi_repair_tab(i).rep_completed_mins
                                            ,'DD-MON-RRRRHH24:MI');
            ELSE
                lv_def_date_compl := pi_repair_tab(i).rep_date_completed;
            END IF;
        END IF;
    END IF;
    --
  END LOOP;
  /*
  ||If all repairs are complete then create the Defect as completed.
  */
  IF lv_compl_rep_count = pi_repair_tab.count
   THEN
      lr_defect_rec.def_date_compl := lv_def_date_compl;
  END IF;
  --
  IF lr_defect_rec.def_date_compl IS NULL
   THEN
      lv_def_status := mai_inspection_api.get_initial_defect_status(pi_effective_date => pi_insp_rec.are_date_work_done);
  ELSE
      lv_def_status := mai_inspection_api.get_complete_defect_status(pi_effective_date => pi_insp_rec.are_date_work_done);
  END IF;
  --
  lr_defect_rec.def_status_code := lv_def_status;
  --
  IF lr_defect_rec.def_siss_id IS NULL
   THEN
      lr_defect_rec.def_siss_id := lv_siss;
  END IF;
  /*
  ||Create The Defect.
  */
  lv_defect_id := ins_defect(pi_defect_rec => lr_defect_rec);
  --
  lr_defect_rec.def_defect_id := lv_defect_id;
  --
  -- Create Repair.
  --
  FOR i IN 1..pi_repair_tab.COUNT LOOP
    --
    lv_entity_type := 'Repair';
    --
    lr_repair_rec := pi_repair_tab(i);
    --
    IF ((lv_sys_flag = 'D' and lv_repsetperd = 'Y')
        OR (lv_sys_flag = 'L' and lv_repsetperl = 'Y'))
     AND lr_repair_rec.rep_action_cat = 'P'
     AND lr_defect_rec.def_orig_priority = '1'
     AND pi_repair_tab.COUNT = 1  -- ie. No Other Repairs To Be Created.
     THEN
       lv_action_cat := 'T';
    ELSE
       lv_action_cat := lr_repair_rec.rep_action_cat;
    END IF;
    --
    mai.rep_date_due(lr_defect_rec.def_inspection_date
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
            hig.raise_ner(nm3type.c_mai,904); --Cannot Find Interval For Priority/Repair Category
        ELSIF lv_dummy = 8213
         THEN
            hig.raise_ner(nm3type.c_mai,905); --Cannot Find Interval For Road
        ELSE
            hig.raise_ner(nm3type.c_mai,906); --Cannot Find Due Date From Interval
        END IF;
    END IF;
    --
    IF lr_repair_rec.rep_date_completed IS NOT NULL
     AND (lr_repair_rec.rep_completed_hrs IS NOT NULL
          AND lr_repair_rec.rep_completed_mins IS NOT NULL)
     THEN
        lr_repair_rec.rep_date_completed := TO_DATE(TO_CHAR(lr_repair_rec.rep_date_completed,'DD-MON-RRRR')
                                                      ||lr_repair_rec.rep_completed_hrs
                                                      ||':'||lr_repair_rec.rep_completed_mins
                                                   ,'DD-MON-RRRRHH24:MI');
    END IF;
    /*
    ||Local Copy Of mai.create_repair That Populates
    ||The Completed Date and Time For Immediate Repairs.
    */
    BEGIN
      --
      INSERT
        INTO repairs
            (rep_def_defect_id
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
            ,rep_boq_perc_item_code
            ,rep_wol_perc_item_code)
      VALUES(lv_defect_id
            ,lr_repair_rec.rep_action_cat
            ,pi_insp_rec.are_rse_he_id
            ,lr_repair_rec.rep_tre_treat_code
            ,lr_defect_rec.def_atv_acty_area_code
            ,SYSDATE
            ,lv_date_due
            ,SYSDATE
            ,'N'
            ,lr_repair_rec.rep_completed_hrs
            ,lr_repair_rec.rep_completed_mins
            ,lr_repair_rec.rep_date_completed
            ,lr_repair_rec.rep_descr
            ,lv_date_due
            ,NULL
            ,lr_repair_rec.rep_boq_perc_item_code
            ,lr_repair_rec.rep_wol_perc_item_code)
            ;
      --
      IF SQL%rowcount != 1
       THEN
          RAISE insert_error;
      END IF;
      --
    EXCEPTION
      WHEN insert_error
       THEN
          RAISE_APPLICATION_ERROR(-20001, 'Error occured while creating Repair');
      WHEN others
       THEN
          RAISE;
    END;
    --
    -- Create BOQs.
    --
    IF pi_boq_tab.count > 0
     THEN
        --
        lv_entity_type := 'BOQ';
        /*
        ||Clear the BOQ PLSQL Table used for the insert.
        */
        lt_boq_tab := lt_empty_boq_tab;
        --
        FOR i IN 1..pi_boq_tab.COUNT LOOP
          /*
          ||Process BOQs That Are Explicitly Linked To
          ||The Repair Being Processed.
          ||
          ||If A BOQ Has Been Passed In With No Repair Action
          ||Category Assigned (boq_rep_action_cat) Assume It
          ||Is To Be Added To Each Repair Created.
          */
          IF NVL(pi_boq_tab(i).boq_rep_action_cat,lr_repair_rec.rep_action_cat) = lr_repair_rec.rep_action_cat
           THEN
              /*
              ||If BOQ Is relevent to the current Repair
              ||Add it to the list for insertion.
              */
              lt_boq_tab(lt_boq_tab.count+1) := pi_boq_tab(i);
              /*
              ||Add some default values.
              */
              lt_boq_tab(lt_boq_tab.count).boq_work_flag      := 'D';
              lt_boq_tab(lt_boq_tab.count).boq_defect_id      := lv_defect_id;
              lt_boq_tab(lt_boq_tab.count).boq_wol_id         := 0;
              lt_boq_tab(lt_boq_tab.count).boq_date_created   := sysdate;
              /*
              ||If this BOQ is being added because it is
              ||generic associate it with the current Repair.
              */
              IF lt_boq_tab(lt_boq_tab.count).boq_rep_action_cat IS NULL
               THEN
                  lt_boq_tab(lt_boq_tab.count).boq_rep_action_cat := lr_repair_rec.rep_action_cat;
              END IF;
              --
              SELECT boq_id_seq.nextval
                INTO lt_boq_tab(lt_boq_tab.count).boq_id
                FROM dual
                   ;
              --
          END IF;
        END LOOP;
        /*
        ||Insert The BOQs for the current Repair.
        */
        FORALL i IN 1..lt_boq_tab.COUNT
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
    ,p_acty_area_code IN  repairs.rep_atv_acty_area_code%TYPE
    ,p_date_due       IN  repairs.rep_date_due%TYPE
    ,p_descr          IN  repairs.rep_descr%TYPE
    ,p_local_date_due IN  repairs.rep_local_date_due%TYPE
    ,p_old_due_date   IN  repairs.rep_old_due_date%TYPE
    ,p_date_completed IN  repairs.rep_date_completed%TYPE default NULL
    ,p_completed_hrs  IN  repairs.rep_completed_hrs%TYPE default NULL
    ,p_completed_mins IN  repairs.rep_completed_mins%TYPE default NULL
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
    ,DECODE(p_action_cat, 'I', p_completed_hrs, NULL)
    ,DECODE(p_action_cat, 'I', p_completed_mins, NULL)
    ,DECODE(p_action_cat, 'I', p_date_completed, NULL)
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
        ,(SELECT MIN(rep_date_due)
            FROM repairs
           WHERE rep_def_defect_id = def_defect_id) rep_date_due
    BULK COLLECT
    INTO lt_def_inv_tab
    FROM defects
        ,activities_report
   WHERE are_batch_id = pi_batch_id
     AND are_report_id = def_are_report_id
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
        ,(SELECT MIN(rep_date_due)
            FROM repairs
           WHERE rep_def_defect_id = def_defect_id) rep_date_due
    BULK COLLECT
    INTO lt_def_tab
    FROM defects
        ,activities_report
   WHERE are_batch_id   = pi_batch_id
     AND are_report_id  = def_are_report_id
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
--    CURSOR c_uo IS
--      SELECT USER
--      FROM   user_objects
--      WHERE  object_name = UPPER( a_object_name)
--        AND  object_type <> 'SYNONYM';
--Cursor above has been replaced as part of a general
--task to replace the use of the oracle reserved word "user"
--with a call to nm3context.
    CURSOR c_uo IS
      SELECT owner
        FROM all_objects
       WHERE owner = Sys_Context('NM3_SECURITY_CTX','USERNAME')
         AND object_name = UPPER(a_object_name)
         AND object_type <> 'SYNONYM';

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
------------------------------------------------------------------------------------------
--
FUNCTION GET_ICB_FGAC_CONTEXT(Top       BOOLEAN
                             ,lc_agency VARCHAR2)
  RETURN VARCHAR2 IS
  --
  CURSOR C2
      IS
  SELECT hau_authority_code
    FROM hig_admin_groups
        ,hig_admin_units
        ,hig_users
   WHERE hau_level = 2
     AND hag_parent_admin_unit = hau_admin_unit
     AND hag_child_admin_unit = hus_admin_unit
     AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
       ;
  --
  CURSOR C3
      IS
  SELECT hau_authority_code
    FROM hig_admin_units
   WHERE hau_admin_unit = 1
       ;
  --
  l_dummy           VARCHAR2(1);
  l_default_agency  VARCHAR2(4);
  --
BEGIN
  --
  OPEN  C3;
  FETCH C3
   INTO l_default_agency;
  CLOSE C3;
  --
  IF NOT top
   THEN
      IF hig.get_sysopt('ICBFGAC') = 'Y'
       AND Sys_Context('NM3CORE','APPLICATION_OWNER') != Sys_Context('NM3_SECURITY_CTX','USERNAME')
       THEN
          IF lc_agency IS NULL
           THEN
              --
              -- Now need to set agency level restriction
              --
              OPEN  C2;
              FETCH C2
               INTO l_default_agency;
              CLOSE C2;
              --
          ELSE
              l_default_agency := lc_agency;
          END IF;
      ELSE
          IF hig.get_sysopt('ICBFGAC') = 'Y'
           AND lc_agency IS NOT NULL
           THEN
              l_default_agency := lc_agency;
          ELSE
              l_default_agency := NULL;
          END IF;
      END IF;
  END IF;
  --
  RETURN l_default_agency;
  --
END;
--
------------------------------------------------------------------------------------------
--
FUNCTION GET_ICB_FGAC_CONTEXT(Top BOOLEAN) RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  --
  IF hig.get_sysopt('ICBFGAC') = 'Y'
   THEN
      --
      nm3ctx.set_context(g_ctx_agency_attr,get_icb_fgac_context(Top,NULL));
      --set_context(g_context, 'Agency', get_icb_fgac_context(Top,''));
      --DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', get_icb_fgac_context(Top,''));
  END IF;
  --
  RETURN mai.get_icb_fgac_context(Top,NULL);
  --
END;

FUNCTION GET_ICB_FGAC_CONTEXT(lc_agency VARCHAR2) RETURN VARCHAR2 IS
  --
  --c_context CONSTANT VARCHAR2(30) := 'Item_Code_Breakdown_'||HIG.GET_OWNER('HIG_PRODUCTS');
  --
BEGIN
  --
  IF hig.get_sysopt('ICBFGAC') = 'Y'
   THEN
      --
      nm3ctx.set_context(g_ctx_agency_attr,lc_agency);
      --set_context(g_context, 'Agency', lc_agency);
      --DBMS_SESSION.SET_CONTEXT (c_context, 'Agency', lc_agency);
  END IF;
  --
  RETURN mai.get_icb_fgac_context(FALSE,lc_agency);
  --
END;
--
------------------------------------------------------------------------------------------
--
FUNCTION ICB_FGAC_PREDICATE(schema_in VARCHAR2
                           ,name_in   VARCHAR2)
  RETURN VARCHAR2 IS
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
  --
  IF get_context(g_context,g_ctx_agency_attr) IS NULL
   THEN
      lc_dummy := get_icb_fgac_context(FALSE);
  END IF;
  --
  RETURN 'icb_agency_code = NVL(SYS_CONTEXT('''||g_context||''','''||g_ctx_agency_attr||'''),icb_agency_code)';
  --
END;
--
------------------------------------------------------------------------------------------
--
FUNCTION ICB_BUDGET_FGAC_PREDICATE(schema_in VARCHAR2
                                  ,name_in   VARCHAR2)
  RETURN VARCHAR2 IS
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
  --
  IF get_context(g_context,g_ctx_agency_attr) IS NULL
   THEN
      lc_dummy := get_icb_fgac_context(FALSE);
  END IF;
  --
  RETURN 'bud_agency = NVL(SYS_CONTEXT('''||g_context||''','''||g_ctx_agency_attr||'''),bud_agency)';
  --
END;
--
------------------------------------------------------------------------------------------
--
FUNCTION ICB_WO_FGAC_PREDICATE(schema_in VARCHAR2
                              ,name_in   VARCHAR2)
  RETURN VARCHAR2 IS
  --
  lc_dummy HIG_USERS.HUS_AGENT_CODE%TYPE;
  --
BEGIN
  --
  IF get_context(g_context,g_ctx_agency_attr) IS NULL
   THEN
      lc_dummy := get_icb_fgac_context(FALSE);
  END IF;
  --
  IF get_icb_fgac_context(FALSE) IS NULL
   THEN
      RETURN '1 = 1';
  ELSE
      RETURN 'wor_agency = SYS_CONTEXT('''||g_context||''','''||g_ctx_agency_attr||''')';
  END IF;
  --
END;
------------------------------------------------------------------------------------------
--
-- End Wag Changes
--

-----------------------------------------------------------------------------------
-- Auto Defect Prioritisation Changes
-- A.E. March 2003
-----------------------------------------------------------------------------------
FUNCTION get_auto_def_priority(p_rse_he_id     IN NUMBER
                              ,p_network_type  IN VARCHAR2
                              ,p_activity_code IN VARCHAR2
                              ,p_defect_code   IN VARCHAR2)
  RETURN VARCHAR2
IS
  TYPE adsp_rowid IS TABLE OF ROWID
                       INDEX BY BINARY_INTEGER;
  TYPE adsp_attrib IS TABLE OF VARCHAR2(500)
                        INDEX BY BINARY_INTEGER;
  TYPE adsp_cntrl_value IS TABLE OF VARCHAR2(500)
                             INDEX BY BINARY_INTEGER;
  l_adsp_rowid        adsp_rowid;
  l_adsp_attrib       adsp_attrib;
  l_adsp_cntrl_value  adsp_cntrl_value;
  cur_string          VARCHAR2(30000) := NULL;
  cur_string_x        VARCHAR2(30000) := NULL;
  v_priority          defect_priorities.dpr_priority%TYPE;
  l_count             PLS_INTEGER;
BEGIN
  cur_string := 'select adsp_priority' || CHR(10);
  cur_string :=
    cur_string || ' from auto_defect_selection_priority, road_segs' || CHR(10);
  cur_string :=
    cur_string || ' where adsp_dtp_flag = :p_network_type' || CHR(10);
  cur_string :=
    cur_string || ' and adsp_atv_acty_area_code = :p_activity_code' || CHR(10);
  cur_string :=
    cur_string || ' and adsp_defect_code = :p_defect_code' || CHR(10);
  cur_string := cur_string || ' and rse_he_id = :p_rse_he_id';
  SELECT adsp.ROWID
        ,hco.hco_meaning
        ,adsp.adsp_cntrl_value
    BULK COLLECT INTO l_adsp_rowid
        ,l_adsp_attrib
        ,l_adsp_cntrl_value
    FROM hig_codes hco
        ,auto_defect_selection_priority adsp
   WHERE hco.hco_domain = 'ADSP_RSE_ATTS'
     AND hco.hco_code = adsp.adsp_flex_attrib
     AND adsp.adsp_atv_acty_area_code = p_activity_code
     AND adsp.adsp_defect_code = p_defect_code
     AND adsp.adsp_dtp_flag = p_network_type
     AND adsp.adsp_priority_rank IN
           (SELECT MIN(adsp.adsp_priority_rank)
              FROM auto_defect_selection_priority adsp
             WHERE adsp.adsp_atv_acty_area_code = p_activity_code
               AND adsp.adsp_defect_code = p_defect_code
               AND adsp.adsp_dtp_flag = p_network_type);
  l_count := l_adsp_rowid.COUNT;
  IF l_count > 0
  THEN
    -- Will never loop since entered ranking.. but it works OK
    FOR l_i IN 1 .. l_count LOOP
      -- Add rse attrib to sql statement
      cur_string_x :=
           cur_string
        || CHR(10)
        || ' and '
        || l_adsp_attrib(l_i)
        || ' = adsp_cntrl_value';
      -- Get priority for current attrib
      EXECUTE IMMEDIATE cur_string_x
        INTO v_priority
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
                      '           WHERE h.hus_username = Sys_Context(''NM3_SECURITY_CTX'', ''USERNAME'')  '||nl||
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
FUNCTION generate_works_order_no(p_con_id         IN contracts.con_id%type
                                ,p_admin_unit     IN hig_admin_units.hau_admin_unit%type
                                ,p_worrefgen      IN varchar2 DEFAULT hig.get_user_or_sys_opt('WORREFGEN')
                                ,p_raise_not_found IN BOOLEAN DEFAULT FALSE)
  RETURN VARCHAR2 IS
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
FUNCTION create_wo_header(p_wor_works_order_no             in work_orders.wor_works_order_no%TYPE
                         ,p_wor_sys_flag                   in work_orders.wor_sys_flag%TYPE
                         ,p_wor_rse_he_id_group            in work_orders.wor_rse_he_id_group%TYPE
                         ,p_wor_flag                       in work_orders.wor_flag%TYPE
                         ,p_wor_con_id                     in work_orders.wor_con_id%TYPE
                         ,p_wor_act_cost_code              in work_orders.wor_act_cost_code%TYPE
                         ,p_wor_act_balancing_sum          in work_orders.wor_act_balancing_sum%TYPE
                         ,p_wor_act_cost                   in work_orders.wor_act_cost%TYPE
                         ,p_wor_act_labour                 in work_orders.wor_act_labour%TYPE
                         ,p_wor_agency                     in work_orders.wor_agency%TYPE
                         ,p_wor_are_sched_act_flag         in work_orders.wor_are_sched_act_flag%TYPE
                         ,p_wor_cheapest_flag              in work_orders.wor_cheapest_flag%TYPE
                         ,p_wor_closed_by_id               in work_orders.wor_closed_by_id%TYPE
                         ,p_wor_coc_cost_centre            in work_orders.wor_coc_cost_centre%TYPE
                         ,p_wor_cost_recharg               in work_orders.wor_cost_recharg%TYPE
                         ,p_wor_date_closed                in work_orders.wor_date_closed%TYPE
                         ,p_wor_date_confirmed             in work_orders.wor_date_confirmed%TYPE
                         ,p_wor_date_mod                   in work_orders.wor_date_mod%TYPE
                         ,p_wor_date_raised                in work_orders.wor_date_raised%TYPE
                         ,p_wor_descr                      in work_orders.wor_descr%TYPE
                         ,p_wor_div_code                   in work_orders.wor_div_code%TYPE
                         ,p_wor_dtp_expend_code            in work_orders.wor_dtp_expend_code%TYPE
                         ,p_wor_est_balancing_sum          in work_orders.wor_est_balancing_sum%TYPE
                         ,p_wor_est_complete               in work_orders.wor_est_complete%TYPE
                         ,p_wor_est_cost                   in work_orders.wor_est_cost%TYPE
                         ,p_wor_est_labour                 in work_orders.wor_est_labour%TYPE
                         ,p_wor_icb_item_code              in work_orders.wor_icb_item_code%TYPE
                         ,p_wor_icb_sub_item_code          in work_orders.wor_icb_sub_item_code%TYPE
                         ,p_wor_icb_sub_sub_item_code      in work_orders.wor_icb_sub_sub_item_code%TYPE
                         ,p_wor_job_number                 in work_orders.wor_job_number%TYPE
                         ,p_wor_last_print_date            in work_orders.wor_last_print_date%TYPE
                         ,p_wor_la_expend_code             in work_orders.wor_la_expend_code%TYPE
                         ,p_wor_mod_by_id                  in work_orders.wor_mod_by_id%TYPE
                         ,p_wor_oun_org_id                 in work_orders.wor_oun_org_id%TYPE
                         ,p_wor_peo_person_id              in work_orders.wor_peo_person_id%TYPE
                         ,p_wor_price_TYPE                 in work_orders.wor_price_TYPE%TYPE
                         ,p_wor_remarks                    in work_orders.wor_remarks%TYPE
                         ,p_wor_road_TYPE                  in work_orders.wor_road_TYPE%TYPE
                         ,p_wor_rse_he_id_link             in work_orders.wor_rse_he_id_link%TYPE
                         ,p_wor_scheme_ref                 in work_orders.wor_scheme_ref%TYPE
                         ,p_wor_scheme_TYPE                in work_orders.wor_scheme_TYPE%TYPE
                         ,p_wor_score                      in work_orders.wor_score%TYPE
                         ,p_wor_year_code                  in work_orders.wor_year_code%TYPE
                         ,p_wor_interim_payment_flag       in work_orders.wor_interim_payment_flag%TYPE
                         ,p_wor_risk_assessment_flag       in work_orders.wor_risk_assessment_flag%TYPE
                         ,p_wor_method_statement_flag      in work_orders.wor_method_statement_flag%TYPE
                         ,p_wor_works_programme_flag       in work_orders.wor_works_programme_flag%TYPE
                         ,p_wor_additional_safety_flag     in work_orders.wor_additional_safety_flag%TYPE
                         ,p_wor_def_correction             in work_orders.wor_def_correction%TYPE
                         ,p_wor_def_correction_accept      in work_orders.wor_def_correction_acceptable%TYPE
                         ,p_wor_corr_extension_time        in work_orders.wor_corr_extension_time%TYPE
                         ,p_wor_revised_comp_date          in work_orders.wor_revised_comp_date%TYPE
                         ,p_wor_price_variation            in work_orders.wor_price_variation%TYPE
                         ,p_wor_commence_by                in work_orders.wor_commence_by%TYPE
                         ,p_wor_act_commence_by            in work_orders.wor_act_commence_by%TYPE
                         ,p_wor_def_correction_period      in work_orders.wor_def_correction_period%TYPE
                         ,p_wor_reason_not_cheapest        in work_orders.wor_reason_not_cheapest%TYPE
                         ,p_wor_priority                   in work_orders.wor_priority%TYPE
                         ,p_wor_perc_item_comp             in work_orders.wor_perc_item_comp%TYPE
                         ,p_wor_contact                    in work_orders.wor_contact%TYPE
                         ,p_wor_date_received              in work_orders.wor_date_received%TYPE
                         ,p_wor_received_by                in work_orders.wor_received_by%TYPE
                         ,p_wor_rechargeable               in work_orders.wor_rechargeable%TYPE
                         ,p_wor_supp_documents             in work_orders.wor_supp_documents%TYPE
                         ,p_wor_earliest_start_date        in work_orders.wor_earliest_start_date%TYPE
                         ,p_wor_planned_comp_date          in work_orders.wor_planned_comp_date%TYPE
                         ,p_wor_latest_comp_date           in work_orders.wor_latest_comp_date%TYPE
                         ,p_wor_site_complete_date         in work_orders.wor_site_complete_date%TYPE
                         ,p_wor_est_duration               in work_orders.wor_est_duration%TYPE
                         ,p_wor_act_duration               in work_orders.wor_act_duration%TYPE
                         ,p_wor_cert_complete              in work_orders.wor_cert_complete%TYPE
                         ,p_wor_con_cert_complete          in work_orders.wor_con_cert_complete%TYPE
                         ,p_wor_agreed_by                  in work_orders.wor_agreed_by%TYPE
                         ,p_wor_agreed_by_date             in work_orders.wor_agreed_by_date%TYPE
                         ,p_wor_con_agreed_by              in work_orders.wor_con_agreed_by%TYPE
                         ,p_wor_con_agreed_by_date         in work_orders.wor_con_agreed_by_date%TYPE
                         ,p_wor_late_costs                 in work_orders.wor_late_costs%TYPE
                         ,p_wor_late_cost_certified_by     in work_orders.wor_late_cost_certified_by%TYPE
                         ,p_wor_late_cost_certified_date   in work_orders.wor_late_cost_certified_date%TYPE
                         ,p_wor_location_plan              in work_orders.wor_location_plan%TYPE
                         ,p_wor_utility_plans              in work_orders.wor_utility_plans%TYPE
                         ,p_wor_work_restrictions          in work_orders.wor_work_restrictions%TYPE
                         ,p_wor_register_flag              in work_orders.wor_register_flag%TYPE
                         ,p_wor_register_status            in work_orders.wor_register_status%TYPE)
  RETURN NUMBER IS
  --
  l_works_order_no    work_orders.wor_works_order_no%TYPE;
  --
  lv_worrefuser  hig_option_values.hov_value%TYPE := hig.get_user_or_sys_opt('WORREFUSER');
  lv_dumconcode  hig_option_values.hov_value%TYPE := hig.get_user_or_sys_opt('DUMCONCODE');
  lv_con_code    contracts.con_code%TYPE;
  lv_admin_unit  nm_admin_units.nau_admin_unit%TYPE;
  --
  CURSOR get_con_code(cp_con_id contracts.con_id%TYPE)
      IS
  SELECT con_code
        ,con_admin_org_id
    FROM contracts
   WHERE con_id = cp_con_id
       ;
  --
BEGIN
  --
  OPEN  get_con_code(p_wor_con_id);
  FETCH get_con_code
   INTO lv_con_code
       ,lv_admin_unit;
  CLOSE get_con_code;
  --
  IF (lv_dumconcode IS NOT NULL AND lv_dumconcode = lv_con_code)
   OR NVL(lv_worrefuser,'N') = 'Y'
   THEN
      lv_admin_unit := nm3get.get_hus(pi_hus_username => Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                     ,pi_raise_not_found => FALSE).hus_admin_unit;
  END IF;
  --
  g_works_order_no := generate_works_order_no(p_con_id          => p_wor_con_id
                                             ,p_admin_unit      => lv_admin_unit
                                             ,p_raise_not_found => TRUE);
  --
  INSERT
    INTO work_orders
        (wor_works_order_no
        ,wor_sys_flag
        ,wor_rse_he_id_group
        ,wor_flag
        ,wor_con_id
        ,wor_act_cost_code
        ,wor_act_balancing_sum
        ,wor_act_cost
        ,wor_act_labour
        ,wor_agency
        ,wor_are_sched_act_flag
        ,wor_cheapest_flag
        ,wor_closed_by_id
        ,wor_coc_cost_centre
        ,wor_cost_recharg
        ,wor_date_closed
        ,wor_date_confirmed
        ,wor_date_mod
        ,wor_date_raised
        ,wor_descr
        ,wor_div_code
        ,wor_dtp_expend_code
        ,wor_est_balancing_sum
        ,wor_est_complete
        ,wor_est_cost
        ,wor_est_labour
        ,wor_icb_item_code
        ,wor_icb_sub_item_code
        ,wor_icb_sub_sub_item_code
        ,wor_job_number
        ,wor_last_print_date
        ,wor_la_expend_code
        ,wor_mod_by_id
        ,wor_oun_org_id
        ,wor_peo_person_id
        ,wor_price_type
        ,wor_remarks
        ,wor_road_type
        ,wor_rse_he_id_link
        ,wor_scheme_ref
        ,wor_scheme_type
        ,wor_score
        ,wor_year_code
        ,wor_interim_payment_flag
        ,wor_risk_assessment_flag
        ,wor_method_statement_flag
        ,wor_works_programme_flag
        ,wor_additional_safety_flag
        ,wor_def_correction
        ,wor_def_correction_acceptable
        ,wor_corr_extension_time
        ,wor_revised_comp_date
        ,wor_price_variation
        ,wor_commence_by
        ,wor_act_commence_by
        ,wor_def_correction_period
        ,wor_reason_not_cheapest
        ,wor_priority
        ,wor_perc_item_comp
        ,wor_contact
        ,wor_date_received
        ,wor_received_by
        ,wor_rechargeable
        ,wor_supp_documents
        ,wor_earliest_start_date
        ,wor_planned_comp_date
        ,wor_latest_comp_date
        ,wor_site_complete_date
        ,wor_est_duration
        ,wor_act_duration
        ,wor_cert_complete
        ,wor_con_cert_complete
        ,wor_agreed_by
        ,wor_agreed_by_date
        ,wor_con_agreed_by
        ,wor_con_agreed_by_date
        ,wor_late_costs
        ,wor_late_cost_certified_by
        ,wor_late_cost_certified_date
        ,wor_location_plan
        ,wor_utility_plans
        ,wor_work_restrictions
        ,wor_register_flag
        ,wor_register_status)
  VALUES(g_works_order_no
        ,p_wor_sys_flag
        ,p_wor_rse_he_id_group
        ,p_wor_flag
        ,p_wor_con_id
        ,p_wor_act_cost_code
        ,p_wor_act_balancing_sum
        ,p_wor_act_cost
        ,p_wor_act_labour
        ,p_wor_agency
        ,p_wor_are_sched_act_flag
        ,p_wor_cheapest_flag
        ,p_wor_closed_by_id
        ,p_wor_coc_cost_centre
        ,p_wor_cost_recharg
        ,p_wor_date_closed
        ,p_wor_date_confirmed
        ,p_wor_date_mod
        ,p_wor_date_raised
        ,p_wor_descr
        ,p_wor_div_code
        ,p_wor_dtp_expend_code
        ,p_wor_est_balancing_sum
        ,p_wor_est_complete
        ,p_wor_est_cost
        ,p_wor_est_labour
        ,p_wor_icb_item_code
        ,p_wor_icb_sub_item_code
        ,p_wor_icb_sub_sub_item_code
        ,p_wor_job_number
        ,p_wor_last_print_date
        ,p_wor_la_expend_code
        ,p_wor_mod_by_id
        ,p_wor_oun_org_id
        ,p_wor_peo_person_id
        ,p_wor_price_type
        ,p_wor_remarks
        ,p_wor_road_type
        ,p_wor_rse_he_id_link
        ,p_wor_scheme_ref
        ,p_wor_scheme_type
        ,p_wor_score
        ,p_wor_year_code
        ,p_wor_interim_payment_flag
        ,p_wor_risk_assessment_flag
        ,p_wor_method_statement_flag
        ,p_wor_works_programme_flag
        ,p_wor_additional_safety_flag
        ,p_wor_def_correction
        ,p_wor_def_correction_accept
        ,p_wor_corr_extension_time
        ,p_wor_revised_comp_date
        ,p_wor_price_variation
        ,p_wor_commence_by
        ,p_wor_act_commence_by
        ,p_wor_def_correction_period
        ,p_wor_reason_not_cheapest
        ,p_wor_priority
        ,p_wor_perc_item_comp
        ,p_wor_contact
        ,p_wor_date_received
        ,p_wor_received_by
        ,p_wor_rechargeable
        ,p_wor_supp_documents
        ,p_wor_earliest_start_date
        ,p_wor_planned_comp_date
        ,p_wor_latest_comp_date
        ,p_wor_site_complete_date
        ,p_wor_est_duration
        ,p_wor_act_duration
        ,p_wor_cert_complete
        ,p_wor_con_cert_complete
        ,p_wor_agreed_by
        ,p_wor_agreed_by_date
        ,p_wor_con_agreed_by
        ,p_wor_con_agreed_by_date
        ,p_wor_late_costs
        ,p_wor_late_cost_certified_by
        ,p_wor_late_cost_certified_date
        ,p_wor_location_plan
        ,p_wor_utility_plans
        ,p_wor_work_restrictions
        ,p_wor_register_flag
        ,p_wor_register_status)
       ;
  --
  RETURN( SQL%rowcount );
  --
EXCEPTION
  WHEN NO_DATA_FOUND
   THEN
      RETURN (0);
--   WHEN OTHERS THEN
--      RETURN (-1);
END create_wo_header;
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
PROCEDURE create_wol(p_old_wol_id             IN     work_order_lines.wol_id%TYPE default 0
                    ,p_new_wol_id             IN OUT work_order_lines.wol_id%TYPE
                    ,p_wol_works_order_no     IN     work_order_lines.wol_works_order_no%TYPE default 0
                    ,p_wol_rse_he_id          IN     work_order_lines.wol_rse_he_id%TYPE default 0
                    ,p_wol_siss_id            IN     work_order_lines.wol_siss_id%TYPE default 0
                    ,p_wol_icb_work_code      IN     work_order_lines.wol_icb_work_code%TYPE default 0
                    ,p_wol_def_defect_id      IN     work_order_lines.wol_def_defect_id%TYPE default null
                    ,p_wol_rep_action_cat     IN     work_order_lines.wol_rep_action_cat%TYPE default null
                    ,p_wol_schd_id            IN     work_order_lines.wol_schd_id%TYPE default null
                    ,p_wol_cnp_id             IN     work_order_lines.wol_cnp_id%TYPE default null
                    ,p_wol_act_area_code      IN     work_order_lines.wol_act_area_code%TYPE default null
                    ,p_wol_act_cost           IN     work_order_lines.wol_act_cost%TYPE default null
                    ,p_wol_act_labour         IN     work_order_lines.wol_act_labour%TYPE default null
                    ,p_wol_are_end_chain      IN     work_order_lines.wol_are_end_chain%TYPE default null
                    ,p_wol_are_report_id      IN     work_order_lines.wol_are_report_id%TYPE default null
                    ,p_wol_are_st_chain       IN     work_order_lines.wol_are_st_chain%TYPE default null
                    ,p_wol_check_code         IN     work_order_lines.wol_check_code%TYPE default null
                    ,p_wol_check_comments     IN     work_order_lines.wol_check_comments%TYPE default null
                    ,p_wol_check_date         IN     work_order_lines.wol_check_date%TYPE default null
                    ,p_wol_check_id           IN     work_order_lines.wol_check_id%TYPE default null
                    ,p_wol_check_peo_id       IN     work_order_lines.wol_check_peo_id%TYPE default null
                    ,p_wol_check_result       IN     work_order_lines.wol_check_result%TYPE default null
                    ,p_wol_date_complete      IN     work_order_lines.wol_date_complete%TYPE default null
                    ,p_wol_date_created       IN     work_order_lines.wol_date_created%TYPE default null
                    ,p_wol_date_paid          IN     work_order_lines.wol_date_paid%TYPE default null
                    ,p_wol_descr              IN     work_order_lines.wol_descr%TYPE default null
                    ,p_wol_discount           IN     work_order_lines.wol_discount%TYPE default null
                    ,p_wol_est_cost           IN     work_order_lines.wol_est_cost%TYPE default null
                    ,p_wol_est_labour         IN     work_order_lines.wol_est_labour%TYPE default null
                    ,p_wol_flag               IN     work_order_lines.wol_flag%TYPE default null
                    ,p_wol_month_due          IN     work_order_lines.wol_month_due%TYPE default null
                    ,p_wol_orig_est           IN     work_order_lines.wol_orig_est%TYPE default null
                    ,p_wol_payment_code       IN     work_order_lines.wol_payment_code%TYPE default null
                    ,p_wol_quantity           IN     work_order_lines.wol_quantity%TYPE default null
                    ,p_wol_rate               IN     work_order_lines.wol_rate%TYPE default null
                    ,p_wol_ss_tre_treat_code  IN     work_order_lines.wol_ss_tre_treat_code%TYPE default null
                    ,p_wol_status             IN     work_order_lines.wol_status%TYPE default null
                    ,p_wol_status_code        IN     work_order_lines.wol_status_code%TYPE default null
                    ,p_wol_unique_flag        IN     work_order_lines.wol_unique_flag%TYPE default null
                    ,p_wol_work_sheet_date    IN     work_order_lines.wol_work_sheet_date%TYPE default null
                    ,p_wol_work_sheet_issue   IN     work_order_lines.wol_work_sheet_issue%TYPE default null
                    ,p_wol_work_sheet_no      IN     work_order_lines.wol_work_sheet_no%TYPE default null
                    ,p_wol_wor_flag           IN     work_order_lines.wol_wor_flag%TYPE default null
                    ,p_wol_date_repaired      IN     work_order_lines.wol_date_repaired%TYPE default null
                    ,p_wol_invoice_status     IN     work_order_lines.wol_invoice_status%TYPE default null
                    ,p_wol_bud_id             IN     work_order_lines.wol_bud_id%TYPE default null
                    ,p_wol_unposted_est       IN     work_order_lines.wol_unposted_est%TYPE default null
                    ,p_wol_iit_item_id        IN     work_order_lines.wol_iit_item_id%TYPE default null
                    ,p_wol_gang               IN     work_order_lines.wol_gang%TYPE default null
                    ,p_wol_register_flag      IN     work_order_lines.wol_register_flag%TYPE default 'N'
					,p_wol_boq_perc_item      IN     work_order_lines.wol_boq_perc_item_code%TYPE default null
					,p_wol_wol_perc_item      IN     work_order_lines.wol_wol_perc_item_code%TYPE default null
                    ,pi_zeroize               IN     BOOLEAN DEFAULT FALSE
                    ,pi_copy_boqs             IN     BOOLEAN DEFAULT TRUE)
  IS
  --
  lt_boqs mai_wo_api.boq_tab;
  --
  lr_wo  work_orders%ROWTYPE;
  --
  lv_status_code     hig_status_codes.hsc_status_code%TYPE;
  lv_error           NUMBER;
  lv_perc_item       hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  lv_new_boq_id      boq_items.boq_id%TYPE;
  lv_wol_id          work_order_lines.wol_id%TYPE;
  lv_wol_est_cost    work_order_lines.wol_est_cost%TYPE := 0;
  lv_wol_est_labour  work_order_lines.wol_est_labour%TYPE := 0;
  --
  CURSOR C1(cp_wol_id boq_items.boq_wol_id%TYPE)
      IS
  SELECT *
    FROM boq_items
   WHERE boq_wol_id = cp_wol_id
       ;
  --
  CURSOR get_inst_status
      IS
  SELECT hsc_status_code
    FROM hig_status_codes
   WHERE hsc_domain_code = 'WORK_ORDER_LINES'
     AND hsc_allow_feature1 = 'Y'
     AND hsc_allow_feature10 != 'Y'
       ;
  --
  CURSOR get_initial_status
      IS
  SELECT hsc_status_code
    FROM hig_status_codes
   WHERE hsc_domain_code = 'WORK_ORDER_LINES'
     AND hsc_allow_feature1 = 'Y'
     AND hsc_allow_feature10 = 'Y'
       ;
  --
  FUNCTION a_percent_item(pi_sta_item_code IN standard_items.sta_item_code%TYPE)
    RETURN BOOLEAN IS
    --
    lv_unit    standard_items.sta_unit%TYPE;
    lv_retval  BOOLEAN := FALSE;
    --
  BEGIN
    --
    SELECT sta_unit
      INTO lv_unit
      FROM standard_items
     WHERE sta_item_code = pi_sta_item_code
         ;
    --
    IF lv_unit = lv_perc_item
     THEN
        lv_retval := TRUE;
    END IF;
    --
    RETURN lv_retval;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20053,'Invalid Standard Item Code.');
    WHEN others
     THEN
        RAISE;

  END a_percent_item;
  --
  PROCEDURE get_wol_draft_status(pi_date_raised IN DATE)
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_status_code
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature1 = 'Y'
       AND hsc_allow_feature10 = 'Y'
       AND TRUNC(pi_date_raised) BETWEEN NVL(hsc_start_date,TRUNC(pi_date_raised))
                                     AND NVL(hsc_end_date  ,TRUNC(pi_date_raised))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20058,'Too Many Values Defined For Work Order Line DRAFT Status');
    WHEN no_data_found
     THEN
        raise_application_error(-20054,'Cannot Obtain Value For Work Order Line DRAFT Status');
    WHEN others
     THEN
        RAISE;
  END get_wol_draft_status;
  --
  PROCEDURE get_wol_instructed_status(pi_date_raised IN DATE)
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_status_code
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature1 = 'Y'
       AND hsc_allow_feature10 != 'Y'
       AND TRUNC(pi_date_raised) BETWEEN NVL(hsc_start_date,TRUNC(pi_date_raised))
                                     AND NVL(hsc_end_date  ,TRUNC(pi_date_raised))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20058,'Too Many Values Defined For Work Order Line DRAFT Status');
    WHEN no_data_found
     THEN
        raise_application_error(-20054,'Cannot Obtain Value For Work Order Line DRAFT Status');
    WHEN others
     THEN
        RAISE;
  END get_wol_instructed_status;
  --
BEGIN
  nm_debug.debug_on;
  nm_debug.debug('Start of create_wol');
  /*
  ||If WO has been instructed then the new line status should
  ||be INSTRUCTED otherwise the line status should be DRAFT.
  */
  lr_wo := maiwo.get_wo(pi_wor_works_order_no => p_wol_works_order_no);
  --
  IF lr_wo.wor_date_confirmed IS NOT NULL
   THEN
      get_wol_instructed_status(pi_date_raised => lr_wo.wor_date_raised);
  ELSE
      get_wol_draft_status(pi_date_raised => lr_wo.wor_date_raised);
  END IF;
  --
  lv_wol_id := NVL(p_new_wol_id,wol_id_nextseq);
  --
  INSERT
    INTO work_order_lines
        (wol_id
        ,wol_works_order_no
        ,wol_rse_he_id
        ,wol_siss_id
        ,wol_icb_work_code
        ,wol_def_defect_id
        ,wol_rep_action_cat
        ,wol_schd_id
        ,wol_cnp_id
        ,wol_act_area_code
        ,wol_act_cost
        ,wol_act_labour
        ,wol_are_end_chain
        ,wol_are_report_id
        ,wol_are_st_chain
        ,wol_check_code
        ,wol_check_comments
        ,wol_check_date
        ,wol_check_id
        ,wol_check_peo_id
        ,wol_check_result
        ,wol_date_complete
        ,wol_date_created
        ,wol_date_paid
        ,wol_descr
        ,wol_discount
        ,wol_est_cost
        ,wol_est_labour
        ,wol_flag
        ,wol_month_due
        ,wol_orig_est
        ,wol_payment_code
        ,wol_quantity
        ,wol_rate
        ,wol_ss_tre_treat_code
        ,wol_status
        ,wol_status_code
        ,wol_unique_flag
        ,wol_work_sheet_date
        ,wol_work_sheet_issue
        ,wol_work_sheet_no
        ,wol_wor_flag
        ,wol_date_repaired
        ,wol_invoice_status
        ,wol_bud_id
        ,wol_unposted_est
        ,wol_iit_item_id
        ,wol_gang
        ,wol_register_flag
        ,wol_boq_perc_item_code
        ,wol_wol_perc_item_code)
  VALUES(lv_wol_id
        ,p_wol_works_order_no
        ,p_wol_rse_he_id
        ,p_wol_siss_id
        ,p_wol_icb_work_code
        ,p_wol_def_defect_id
        ,p_wol_rep_action_cat
        ,p_wol_schd_id
        ,p_wol_cnp_id
        ,p_wol_act_area_code
        ,0
        ,0
        ,p_wol_are_end_chain
        ,p_wol_are_report_id
        ,p_wol_are_st_chain
        ,p_wol_check_code
        ,p_wol_check_comments
        ,p_wol_check_date
        ,p_wol_check_id
        ,p_wol_check_peo_id
        ,p_wol_check_result
        ,p_wol_date_complete
        ,p_wol_date_created
        ,p_wol_date_paid
        ,p_wol_descr
        ,p_wol_discount
        ,lv_wol_est_cost
        ,lv_wol_est_labour
        ,p_wol_flag
        ,p_wol_month_due
        ,p_wol_orig_est
        ,p_wol_payment_code
        ,p_wol_quantity
        ,p_wol_rate
        ,p_wol_ss_tre_treat_code
        ,p_wol_status
        ,lv_status_code
        ,p_wol_unique_flag
        ,p_wol_work_sheet_date
        ,p_wol_work_sheet_issue
        ,p_wol_work_sheet_no
        ,p_wol_wor_flag
        ,p_wol_date_repaired
        ,p_wol_invoice_status
        ,p_wol_bud_id
        ,lv_wol_est_cost
        ,p_wol_iit_item_id
        ,p_wol_gang
        ,p_wol_register_flag
        ,p_wol_boq_perc_item
        ,p_wol_wol_perc_item)
       ;
  /*
  ||Copy the BOQs if required.
  */
  IF pi_copy_boqs
   THEN
      nm_debug.debug('Copying BOQs');
      FOR c1rec IN c1(p_old_wol_id) LOOP
        --
        IF pi_zeroize
         THEN
            --
            IF a_percent_item(pi_sta_item_code => c1rec.boq_sta_item_code)
             THEN
                c1rec.boq_est_quantity := 1;
            ELSE
                c1rec.boq_est_quantity := 0;
            END IF;
            --
            c1rec.boq_est_cost := 0;
            c1rec.boq_est_labour := 0;
            c1rec.boq_est_dim1 := 0;
            --
            IF c1rec.boq_est_dim2 IS NOT NULL
             THEN
                c1rec.boq_est_dim2 := 0;
            END IF;
            --
            IF c1rec.boq_est_dim3 IS NOT NULL
             THEN
                c1rec.boq_est_dim3 := 0;
            END IF;
            --
        END IF;
        --
        lt_boqs(lt_boqs.count+1).boq_id           := c1rec.boq_id;
        lt_boqs(lt_boqs.count).boq_parent_id      := c1rec.boq_parent_id;
        lt_boqs(lt_boqs.count).boq_work_flag      := c1rec.boq_work_flag;
        lt_boqs(lt_boqs.count).boq_defect_id      := c1rec.boq_defect_id;
        lt_boqs(lt_boqs.count).boq_rep_action_cat := c1rec.boq_rep_action_cat;
        lt_boqs(lt_boqs.count).boq_wol_id         := lv_wol_id;
        lt_boqs(lt_boqs.count).boq_date_created   := SYSDATE;
        lt_boqs(lt_boqs.count).boq_sta_item_code  := c1rec.boq_sta_item_code;
        lt_boqs(lt_boqs.count).boq_item_name      := c1rec.boq_item_name;
        lt_boqs(lt_boqs.count).boq_est_dim1       := c1rec.boq_est_dim1;
        lt_boqs(lt_boqs.count).boq_est_dim2       := c1rec.boq_est_dim2;
        lt_boqs(lt_boqs.count).boq_est_dim3       := c1rec.boq_est_dim3;
        lt_boqs(lt_boqs.count).boq_est_quantity   := c1rec.boq_est_quantity;
        lt_boqs(lt_boqs.count).boq_est_rate       := c1rec.boq_est_rate;
        lt_boqs(lt_boqs.count).boq_est_cost       := c1rec.boq_est_cost;
        lt_boqs(lt_boqs.count).boq_est_labour     := c1rec.boq_est_labour;
        --
        lv_wol_est_cost := lv_wol_est_cost + c1rec.boq_est_cost;
        lv_wol_est_labour := lv_wol_est_labour + c1rec.boq_est_labour;
        --
      END LOOP;
      --
      /*
      ||Assign new BOQ_IDs
      */
      FOR parent_index IN 1..lt_boqs.count LOOP
        --
        lv_new_boq_id := boq_id_nextseq;
        /*
        ||Find child items and update the parent id.
        */
        FOR child_index IN 1..lt_boqs.count LOOP
          --
          IF lt_boqs(child_index).boq_parent_id = lt_boqs(parent_index).boq_id
           THEN
              lt_boqs(child_index).boq_parent_id := lv_new_boq_id;
          END IF;
          --
        END LOOP;
        --
        lt_boqs(parent_index).boq_id := lv_new_boq_id;
        --
      END LOOP;
      /*
      ||Insert the BOQs.
      */
      FORALL i IN 1 .. lt_boqs.COUNT
      INSERT
        INTO boq_items
      VALUES lt_boqs(i)
           ;
      /*
      ||Update the WOL Totals and associated Budget if required.
      */
      IF NOT pi_zeroize
       THEN
          /*
          ||Update the totals.
          */
          UPDATE work_order_lines
             SET wol_est_cost = lv_wol_est_cost
                ,wol_est_labour = lv_wol_est_labour
           WHERE wol_id = lv_wol_id
               ;
          /*
          ||Update the Budgets if required.
          */
          IF lr_wo.wor_date_confirmed IS NOT NULL
           THEN
              --
              IF mai_wo_api.within_budget(pi_bud_id => p_wol_bud_id
                                         ,pi_con_id => lr_wo.wor_con_id
                                         ,pi_est    => lv_wol_est_cost
                                         ,pi_act    => 0
                                         ,pi_wol_id => lv_wol_id)
               THEN
                  mai_wo_api.add_to_budget(pi_wol_id => lv_wol_id
                                          ,pi_bud_id => p_wol_bud_id
                                          ,pi_con_id => lr_wo.wor_con_id
                                          ,pi_est    => lv_wol_est_cost
                                          ,pi_act    => 0);
              ELSE
                  raise_application_error(-20047,'Budget Exceeded.');
              END IF;
          END IF;
      END IF;
      --
  END IF;
  --
  p_new_wol_id := lv_wol_id;
  --
EXCEPTION
  WHEN others
   THEN
      RAISE;
END create_wol;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION copy_works_order(pi_wor_works_order_no  IN work_orders.wor_works_order_no%TYPE
                         ,pi_zeroize             IN BOOLEAN DEFAULT TRUE
                         ,pi_copy_boqs           IN BOOLEAN DEFAULT TRUE)
  RETURN work_orders.wor_works_order_no%TYPE IS
  --
  CURSOR c1(cp_works_order_no work_order_lines.wol_works_order_no%TYPE)
      IS
  SELECT *
    FROM work_order_lines
   WHERE wol_works_order_no = cp_works_order_no
     AND wol_flag != 'D' -- exclude any defect lines
       ;
  --
  CURSOR c_user
      IS
  SELECT hus_user_id
    FROM hig_users
   WHERE hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
       ;
  --
  l_wor_rec      work_orders%ROWTYPE;
  l_error        NUMBER;
  lv_new_wol_id  work_order_lines.wol_id%TYPE;
  lv_user_id     hig_users.hus_user_id%TYPE;
  l_retval       work_orders.wor_works_order_no%TYPE;
  --
  PROCEDURE update_wor_totals(pi_wo_no  IN work_orders.wor_works_order_no%TYPE
                             ,pi_con_id IN contracts.con_id%TYPE)
    IS
    --
    lv_discount_group         org_units.oun_cng_disc_group%TYPE;
    lv_wor_est_cost           work_orders.wor_est_cost%type;
    lv_wor_act_cost           work_orders.wor_act_cost%type;
    lv_wor_est_labour         work_orders.wor_est_labour%type;
    lv_wor_est_balancing_sum  work_orders.wor_est_balancing_sum%TYPE;
    --
    CURSOR discount_group(cp_con_id      IN contracts.con_id%TYPE)
        IS
    SELECT oun_cng_disc_group
      FROM org_units
          ,contracts
     WHERE con_id = cp_con_id
       AND TRUNC(SYSDATE) BETWEEN NVL(con_start_date,TRUNC(SYSDATE))
                              AND NVL(con_end_date,TRUNC(SYSDATE))
       AND con_contr_org_id = oun_org_id
         ;
    --
    CURSOR wor_totals(cp_wo_no work_orders.wor_works_order_no%TYPE)
        IS
    SELECT SUM(boq_est_labour)
          ,DECODE(COUNT(0),COUNT(boq_est_cost),SUM(boq_est_cost)
                                              ,NULL)
      FROM boq_items
          ,work_order_lines
     WHERE wol_id = boq_wol_id
       AND wol_works_order_no = cp_wo_no
         ;
    --
  BEGIN
    --
    OPEN  discount_group(pi_con_id);
    FETCH discount_group
     INTO lv_discount_group;
    CLOSE discount_group;
    --
    OPEN  wor_totals(pi_wo_no);
    FETCH wor_totals
     INTO lv_wor_est_labour
         ,lv_wor_est_cost;
    CLOSE wor_totals;
    --
    lv_wor_est_balancing_sum := maiwo.bal_sum(lv_wor_est_cost
                                             ,lv_discount_group);
    --
    UPDATE work_orders
       SET wor_est_labour        = lv_wor_est_labour
          ,wor_est_cost          = lv_wor_est_cost
          ,wor_est_balancing_sum = lv_wor_est_balancing_sum
     WHERE wor_works_order_no = pi_wo_no
         ;
    --
  END update_wor_totals;
  --
BEGIN
  --
  -- belt and braces cos in MAI3800 a when-new-record instance trigger on B1 should
  -- disable the Copy button
  --
  check_wo_can_be_copied(pi_wor_works_order_no => pi_wor_works_order_no);
  --
  l_wor_rec := maiwo.get_wo(pi_wor_works_order_no => pi_wor_works_order_no);
  --
  l_wor_rec.wor_act_cost_code := null;
  l_wor_rec.wor_act_balancing_sum := null;
  l_wor_rec.wor_act_cost := null;
  l_wor_rec.wor_act_labour := null;
  l_wor_rec.wor_cheapest_flag := null;
  l_wor_rec.wor_closed_by_id := null;
  l_wor_rec.wor_date_closed := null;
  l_wor_rec.wor_date_confirmed := null;
  l_wor_rec.wor_mod_by_id := null;
  l_wor_rec.wor_date_mod := SYSDATE;
  l_wor_rec.wor_date_raised := SYSDATE;
  l_wor_rec.wor_descr := pi_wor_works_order_no||' COPY';
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
  --
  OPEN c_user;
  FETCH c_user into lv_user_id;
  CLOSE c_user;
  -- 
  l_error := create_wo_header(p_wor_works_order_no             => l_wor_rec.wor_works_order_no
                             ,p_wor_sys_flag                   => l_wor_rec.wor_sys_flag
                             ,p_wor_rse_he_id_group            => l_wor_rec.wor_rse_he_id_group
                             ,p_wor_flag                       => l_wor_rec.wor_flag
                             ,p_wor_con_id                     => l_wor_rec.wor_con_id
                             ,p_wor_act_cost_code              => l_wor_rec.wor_act_cost_code
                             ,p_wor_act_balancing_sum          => l_wor_rec.wor_act_balancing_sum
                             ,p_wor_act_cost                   => l_wor_rec.wor_act_cost
                             ,p_wor_act_labour                 => l_wor_rec.wor_act_labour
                             ,p_wor_agency                     => l_wor_rec.wor_agency
                             ,p_wor_are_sched_act_flag         => l_wor_rec.wor_are_sched_act_flag
                             ,p_wor_cheapest_flag              => l_wor_rec.wor_cheapest_flag
                             ,p_wor_closed_by_id               => l_wor_rec.wor_closed_by_id
                             ,p_wor_coc_cost_centre            => l_wor_rec.wor_coc_cost_centre
                             ,p_wor_cost_recharg               => l_wor_rec.wor_cost_recharg
                             ,p_wor_date_closed                => l_wor_rec.wor_date_closed
                             ,p_wor_date_confirmed             => l_wor_rec.wor_date_confirmed
                             ,p_wor_date_mod                   => l_wor_rec.wor_date_mod
                             ,p_wor_date_raised                => l_wor_rec.wor_date_raised
                             ,p_wor_descr                      => l_wor_rec.wor_descr
                             ,p_wor_div_code                   => l_wor_rec.wor_div_code
                             ,p_wor_dtp_expend_code            => l_wor_rec.wor_dtp_expend_code
                             ,p_wor_est_balancing_sum          => l_wor_rec.wor_est_balancing_sum
                             ,p_wor_est_complete               => l_wor_rec.wor_est_complete
                             ,p_wor_est_cost                   => l_wor_rec.wor_est_cost
                             ,p_wor_est_labour                 => l_wor_rec.wor_est_labour
                             ,p_wor_icb_item_code              => l_wor_rec.wor_icb_item_code
                             ,p_wor_icb_sub_item_code          => l_wor_rec.wor_icb_sub_item_code
                             ,p_wor_icb_sub_sub_item_code      => l_wor_rec.wor_icb_sub_sub_item_code
                             ,p_wor_job_number                 => l_wor_rec.wor_job_number
                             ,p_wor_last_print_date            => l_wor_rec.wor_last_print_date
                             ,p_wor_la_expend_code             => l_wor_rec.wor_la_expend_code
                             ,p_wor_mod_by_id                  => l_wor_rec.wor_mod_by_id
                             ,p_wor_oun_org_id                 => l_wor_rec.wor_oun_org_id
                             ,p_wor_peo_person_id              => lv_user_id     
                             ,p_wor_price_type                 => l_wor_rec.wor_price_type
                             ,p_wor_remarks                    => l_wor_rec.wor_remarks
                             ,p_wor_road_type                  => l_wor_rec.wor_road_type
                             ,p_wor_rse_he_id_link             => l_wor_rec.wor_rse_he_id_link
                             ,p_wor_scheme_ref                 => l_wor_rec.wor_scheme_ref
                             ,p_wor_scheme_type                => l_wor_rec.wor_scheme_type
                             ,p_wor_score                      => l_wor_rec.wor_score
                             ,p_wor_year_code                  => l_wor_rec.wor_year_code
                             ,p_wor_interim_payment_flag       => l_wor_rec.wor_interim_payment_flag
                             ,p_wor_risk_assessment_flag       => l_wor_rec.wor_risk_assessment_flag
                             ,p_wor_method_statement_flag      => l_wor_rec.wor_method_statement_flag
                             ,p_wor_works_programme_flag       => l_wor_rec.wor_works_programme_flag
                             ,p_wor_additional_safety_flag     => l_wor_rec.wor_additional_safety_flag
                             ,p_wor_def_correction             => l_wor_rec.wor_def_correction
                             ,p_wor_def_correction_accept      => l_wor_rec.wor_def_correction_acceptable
                             ,p_wor_corr_extension_time        => l_wor_rec.wor_corr_extension_time
                             ,p_wor_revised_comp_date          => l_wor_rec.wor_revised_comp_date
                             ,p_wor_price_variation            => l_wor_rec.wor_price_variation
                             ,p_wor_commence_by                => l_wor_rec.wor_commence_by
                             ,p_wor_act_commence_by            => l_wor_rec.wor_act_commence_by
                             ,p_wor_def_correction_period      => l_wor_rec.wor_def_correction_period
                             ,p_wor_reason_not_cheapest        => l_wor_rec.wor_reason_not_cheapest
                             ,p_wor_priority                   => l_wor_rec.wor_priority
                             ,p_wor_perc_item_comp             => l_wor_rec.wor_perc_item_comp
                             ,p_wor_contact                    => l_wor_rec.wor_contact
                             ,p_wor_date_received              => l_wor_rec.wor_date_received
                             ,p_wor_received_by                => l_wor_rec.wor_received_by
                             ,p_wor_rechargeable               => l_wor_rec.wor_rechargeable
                             ,p_wor_supp_documents             => l_wor_rec.wor_supp_documents
                             ,p_wor_earliest_start_date        => l_wor_rec.wor_earliest_start_date
                             ,p_wor_planned_comp_date          => l_wor_rec.wor_planned_comp_date
                             ,p_wor_latest_comp_date           => l_wor_rec.wor_latest_comp_date
                             ,p_wor_site_complete_date         => l_wor_rec.wor_site_complete_date
                             ,p_wor_est_duration               => l_wor_rec.wor_est_duration
                             ,p_wor_act_duration               => l_wor_rec.wor_act_duration
                             ,p_wor_cert_complete              => l_wor_rec.wor_cert_complete
                             ,p_wor_con_cert_complete          => l_wor_rec.wor_con_cert_complete
                             ,p_wor_agreed_by                  => l_wor_rec.wor_agreed_by
                             ,p_wor_agreed_by_date             => l_wor_rec.wor_agreed_by_date
                             ,p_wor_con_agreed_by              => l_wor_rec.wor_con_agreed_by
                             ,p_wor_con_agreed_by_date         => l_wor_rec.wor_con_agreed_by_date
                             ,p_wor_late_costs                 => l_wor_rec.wor_late_costs
                             ,p_wor_late_cost_certified_by     => l_wor_rec.wor_late_cost_certified_by
                             ,p_wor_late_cost_certified_date   => l_wor_rec.wor_late_cost_certified_date
                             ,p_wor_location_plan              => l_wor_rec.wor_location_plan
                             ,p_wor_utility_plans              => l_wor_rec.wor_utility_plans
--                             ,p_wor_streetwork_notice          => l_wor_rec.wor_streetwork_notice
                             ,p_wor_work_restrictions          => l_wor_rec.wor_work_restrictions
                             ,p_wor_register_flag              => l_wor_rec.wor_register_flag
                             ,p_wor_register_status            => l_wor_rec.wor_register_status);
  l_retval := g_works_order_no;  -- set by calling mai.create_wo_header;
  --
  FOR c1rec IN c1(pi_wor_works_order_no) LOOP
    /*
    ||Initialise the new WOL ID.
    */
    lv_new_wol_id := NULL;
    /*
    ||Create the new WOL.
    */
    create_wol(p_old_wol_id             => c1rec.wol_id
              ,p_new_wol_id             => lv_new_wol_id
              ,p_wol_works_order_no     => l_retval
              ,p_wol_rse_he_id          => c1rec.wol_rse_he_id
              ,p_wol_siss_id            => c1rec.wol_siss_id
              ,p_wol_icb_work_code      => c1rec.wol_icb_work_code
              ,p_wol_def_defect_id      => Null
              ,p_wol_rep_action_cat     => Null
              ,p_wol_schd_id            => c1rec.wol_schd_id
              ,p_wol_cnp_id             => c1rec.wol_cnp_id
              ,p_wol_act_area_code      => c1rec.wol_act_area_code
              ,p_wol_act_cost           => 0
              ,p_wol_act_labour         => 0
              ,p_wol_are_end_chain      => Null
              ,p_wol_are_report_id      => Null
              ,p_wol_are_st_chain       => Null
              ,p_wol_check_code         => c1rec.wol_check_code
              ,p_wol_check_comments     => c1rec.wol_check_comments
              ,p_wol_check_date         => c1rec.wol_check_date
              ,p_wol_check_id           => c1rec.wol_check_id
              ,p_wol_check_peo_id       => c1rec.wol_check_peo_id
              ,p_wol_check_result       => c1rec.wol_check_result
              ,p_wol_date_complete      => Null
              ,p_wol_date_created       => sysdate
              ,p_wol_date_paid          => NULL
              ,p_wol_descr              => c1rec.wol_descr
              ,p_wol_discount           => c1rec.wol_discount
              ,p_wol_est_cost           => 0
              ,p_wol_est_labour         => 0
              ,p_wol_flag               => c1rec.wol_flag
              ,p_wol_month_due          => c1rec.wol_month_due
              ,p_wol_orig_est           => c1rec.wol_orig_est
              ,p_wol_payment_code       => c1rec.wol_payment_code
              ,p_wol_quantity           => c1rec.wol_quantity
              ,p_wol_rate               => c1rec.wol_rate
              ,p_wol_ss_tre_treat_code  => c1rec.wol_ss_tre_treat_code
              ,p_wol_status             => c1rec.wol_status
              ,p_wol_status_code        => c1rec.wol_status_code -- actually ignored by create_wol cos it uses 'INSTRUCTUED' by default
              ,p_wol_unique_flag        => c1rec.wol_unique_flag
              ,p_wol_work_sheet_date    => c1rec.wol_work_sheet_date
              ,p_wol_work_sheet_issue   => c1rec.wol_work_sheet_issue
              ,p_wol_work_sheet_no      => c1rec.wol_work_sheet_no
              ,p_wol_wor_flag           => c1rec.wol_wor_flag
              ,p_wol_date_repaired      => Null
              ,p_wol_invoice_status     => Null
              ,p_wol_bud_id             => c1rec.wol_bud_id
              ,p_wol_unposted_est       => 0
              ,p_wol_iit_item_id        => c1rec.wol_iit_item_id
              ,p_wol_gang               => c1rec.wol_gang
              ,p_wol_register_flag      => c1rec.wol_register_flag
			  ,p_wol_boq_perc_item      => c1rec.wol_boq_perc_item_code
			  ,p_wol_wol_perc_item      => c1rec.wol_wol_perc_item_code
              ,pi_zeroize               => pi_zeroize
              ,pi_copy_boqs             => pi_copy_boqs);
  END LOOP;
  /*
  ||Update The Works Order Cost Totals.
  */
  update_wor_totals(pi_wo_no  => l_retval
                   ,pi_con_id => l_wor_rec.wor_con_id);
  --
  RETURN(l_retval);
  --
EXCEPTION
  WHEN others
   THEN
      ROLLBACK;
      RAISE;
END copy_works_order;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION copy_wol(pi_wol_works_order_no IN work_order_lines.wol_works_order_no%TYPE
                 ,pi_wol_id             IN work_order_lines.wol_id%TYPE
                 ,pi_zeroize            IN BOOLEAN DEFAULT TRUE
                 ,pi_copy_boqs          IN BOOLEAN DEFAULT TRUE)
  RETURN work_order_lines.wol_id%TYPE IS
  --
  l_wol_rec work_order_lines%ROWTYPE;
  --
  l_wol_id  work_order_lines.wol_id%TYPE;
  l_integer PLS_INTEGER;
  --
BEGIN
  --
  check_wol_can_be_copied(pi_wol_works_order_no => pi_wol_works_order_no
                         ,pi_wol_id             => pi_wol_id);
  --
  l_wol_rec := maiwo.get_wol(pi_wol_id => pi_wol_id);
  --
  l_wol_id := wol_id_nextseq;
  --
  create_wol(p_old_wol_id             => pi_wol_id
            ,p_new_wol_id             => l_wol_id
            ,p_wol_works_order_no     => l_wol_rec.wol_works_order_no
            ,p_wol_rse_he_id          => l_wol_rec.wol_rse_he_id
            ,p_wol_siss_id            => l_wol_rec.wol_siss_id
            ,p_wol_icb_work_code      => l_wol_rec.wol_icb_work_code
            ,p_wol_def_defect_id      => Null
            ,p_wol_rep_action_cat     => Null
            ,p_wol_schd_id            => l_wol_rec.wol_schd_id
            ,p_wol_cnp_id             => l_wol_rec.wol_cnp_id
            ,p_wol_act_area_code      => l_wol_rec.wol_act_area_code
            ,p_wol_act_cost           => 0
            ,p_wol_act_labour         => 0
            ,p_wol_are_end_chain      => Null
            ,p_wol_are_report_id      => Null
            ,p_wol_are_st_chain       => Null
            ,p_wol_check_code         => l_wol_rec.wol_check_code
            ,p_wol_check_comments     => l_wol_rec.wol_check_comments
            ,p_wol_check_date         => l_wol_rec.wol_check_date
            ,p_wol_check_id           => l_wol_rec.wol_check_id
            ,p_wol_check_peo_id       => l_wol_rec.wol_check_peo_id
            ,p_wol_check_result       => l_wol_rec.wol_check_result
            ,p_wol_date_complete      => Null
            ,p_wol_date_created       => sysdate
            ,p_wol_date_paid          => Null
            ,p_wol_descr              => 'COPY OF '||l_wol_rec.wol_id
            ,p_wol_discount           => l_wol_rec.wol_discount
            ,p_wol_est_cost           => 0
            ,p_wol_est_labour         => 0
            ,p_wol_flag               => l_wol_rec.wol_flag
            ,p_wol_month_due          => l_wol_rec.wol_month_due
            ,p_wol_orig_est           => l_wol_rec.wol_orig_est
            ,p_wol_payment_code       => l_wol_rec.wol_payment_code
            ,p_wol_quantity           => l_wol_rec.wol_quantity
            ,p_wol_rate               => l_wol_rec.wol_rate
            ,p_wol_ss_tre_treat_code  => l_wol_rec.wol_ss_tre_treat_code
            ,p_wol_status             => l_wol_rec.wol_status
            ,p_wol_status_code        => l_wol_rec.wol_status_code -- actually ignored by create_wol cos it uses 'INSTRUCTUED' by default
            ,p_wol_unique_flag        => l_wol_rec.wol_unique_flag
            ,p_wol_work_sheet_date    => l_wol_rec.wol_work_sheet_date
            ,p_wol_work_sheet_issue   => l_wol_rec.wol_work_sheet_issue
            ,p_wol_work_sheet_no      => l_wol_rec.wol_work_sheet_no
            ,p_wol_wor_flag           => l_wol_rec.wol_wor_flag
            ,p_wol_date_repaired      => Null
            ,p_wol_invoice_status     => Null
            ,p_wol_bud_id             => l_wol_rec.wol_bud_id
            ,p_wol_unposted_est       => 0
            ,p_wol_iit_item_id        => l_wol_rec.wol_iit_item_id
            ,p_wol_gang               => l_wol_rec.wol_gang
            ,p_wol_register_flag      => l_wol_rec.wol_register_flag
			,p_wol_boq_perc_item      => l_wol_rec.wol_boq_perc_item_code
			,p_wol_wol_perc_item      => l_wol_rec.wol_wol_perc_item_code
            ,pi_zeroize               => pi_zeroize
            ,pi_copy_boqs             => pi_copy_boqs);
  --
  RETURN l_wol_id;
  --
EXCEPTION
  WHEN others
   THEN
      ROLLBACK;
      RAISE;
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
     -- refcursor is used cos cannot directly reference SWR/TMA objects
     --
      l_sql := 'select count(*)
                  from work_order_lines wol
                 where wol.wol_works_order_no = :1
                   and NVL(wol.wol_register_flag,''N'') = ''Y''
                   and wol.wol_status_code IN (SELECT hsc_status_code  -- instructed/draft
                                                 FROM hig_status_codes
                                                WHERE hsc_domain_code = ''WORK_ORDER_LINES''
                                                  AND hsc_allow_feature1 = ''Y'')';

      IF g_swr_licenced THEN
        l_sql := l_sql ||' and not exists (select 1 from swr_id_mapping where sim_origin = ''WOL'' and sim_primary_key_value = wol_id)';
      END IF;

/* Comented out for 4100
      IF g_tma_licenced THEN
        l_sql := l_sql ||' and not exists (select 1 from tma_id_mapping where tidm_origin = ''WOL'' and tidm_primary_key_value = wol_id)';
      END IF;
*/
      OPEN l_refcur FOR l_sql
      USING pi_works_order_no;
      FETCH l_refcur INTO l_retval;
      CLOSE l_refcur;

    RETURN(l_retval);

END count_wols_for_register;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_swm_notices_for_wo(pi_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN PLS_INTEGER IS

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
     IF g_swr_licenced THEN
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

     END IF;

     RETURN(NVL(l_retval,0));


END count_swm_notices_for_wo;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_tma_notices_for_wo(pi_works_order_no IN work_orders.wor_works_order_no%TYPE) RETURN PLS_INTEGER IS
  --
  l_refcur nm3type.ref_cursor;
  l_retval PLS_INTEGER;
  l_sql    VARCHAR2(2000);
  --
BEGIN
     --
     -- refcursor is used cos cannot directly reference tma_id_mapping table
     -- because we cannot guarantee that this TMA table exists when MAI is
     -- installed
     --
     /*
     ||Despite it's name this function returns a count of TMA Works
     ||Created for the given Work Order.
     */
     IF g_tma_licenced
      THEN
         --
         l_sql := 'select count(distinct tidm_resultant_works_id)
                     from tma_id_mapping
                         ,work_order_lines
                    where tidm_origin = ''WOL''
                      and tidm_primary_key_value = wol_id
                      and wol_works_order_no = :1';
         --
         OPEN  l_refcur FOR l_sql
         USING pi_works_order_no;
         FETCH l_refcur INTO l_retval;
         CLOSE l_refcur;
         --
     END IF;
     --
     RETURN(NVL(l_retval,0));
     --
END count_tma_notices_for_wo;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION count_tma_notices_for_wol(pi_wol_id IN work_order_lines.wol_id%TYPE)
  RETURN PLS_INTEGER IS
  --
  l_refcur nm3type.ref_cursor;
  l_retval PLS_INTEGER;
  l_sql    VARCHAR2(2000);
  --
BEGIN
  --
  --
  -- refcursor is used cos cannot directly reference swr_id_mapping table
  -- cos we cannot guarantee that this TMA table is installed when MAI is
  -- installed
  --
  IF g_tma_licenced
   THEN
      --
      l_sql := 'select count(*)
                  from tma_id_mapping
                 where tidm_origin = ''WOL''
                   and tidm_primary_key_value = :1'
                     ;

      OPEN  l_refcur FOR l_sql USING pi_wol_id;
      FETCH l_refcur
       INTO l_retval;
      CLOSE l_refcur;
      --
  END IF;
  --
  RETURN(NVL(l_retval,0));
  --
END count_tma_notices_for_wol;
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
FUNCTION determine_reg_status(pi_works_order_no IN work_orders.wor_works_order_no%TYPE
                             ,pi_wol_id         IN work_order_lines.wol_id%TYPE DEFAULT NULL)
  RETURN work_orders.wor_register_status%TYPE IS
  --
  l_sql    nm3type.max_varchar2;
  l_retval work_orders.wor_register_status%TYPE;
  --
BEGIN
  --
  IF g_tma_licenced
   THEN
      --
      l_sql := 'SELECT CASE WHEN stopped = register_lines_count THEN ''C'''
    ||CHR(10)||'            WHEN started > 0 and register_lines_count > 0 THEN ''O'''
    ||CHR(10)||'            WHEN started = 0 and register_lines_count > 0 THEN ''N'''
    ||CHR(10)||'            ELSE NULL'
    ||CHR(10)||'       END register_status'
    ||CHR(10)||'  FROM (SELECT SUM(started) started'
    ||CHR(10)||'              ,SUM(stopped) stopped'
    ||CHR(10)||'              ,COUNT(*)     register_lines_count'
    ||CHR(10)||'          FROM (SELECT wol_id'
    ||CHR(10)||'                      ,(SELECT COUNT(*)'
    ||CHR(10)||'                          FROM tma_id_mapping'
    ||CHR(10)||'                         WHERE tidm_origin            = ''WOL'''
    ||CHR(10)||'                           AND tidm_primary_key_value = wol_id) started'
    ||CHR(10)||'                      ,(SELECT COUNT(*)'
    ||CHR(10)||'                          FROM tma_notices'
    ||CHR(10)||'                              ,tma_phases'
    ||CHR(10)||'                              ,tma_id_mapping'
    ||CHR(10)||'                         WHERE tidm_origin            = ''WOL'''
    ||CHR(10)||'                           AND tidm_primary_key_value = wol_id'
    ||CHR(10)||'                           AND tphs_works_id          = tidm_resultant_works_id'
    ||CHR(10)||'                           AND tphs_active_flag       = ''Y'''
    ||CHR(10)||'                           AND tnot_works_id          = tphs_works_id'
    ||CHR(10)||'                           AND tnot_phase_no          = tphs_phase_no'
    ||CHR(10)||'                           AND tnot_notice_type       = ''0600'') stopped'
    ||CHR(10)||'                  FROM work_order_lines'
    ||CHR(10)||'                 WHERE wol_works_order_no = :works_order_no'
    ||CHR(10)||'                   AND wol_id             = NVL(:wol_id, wol_id)'
    ||CHR(10)||'                   AND wol_register_flag  = ''Y''))'
           ;
      --
      EXECUTE IMMEDIATE l_sql INTO l_retval USING pi_works_order_no, pi_wol_id;
      --
  END IF;
  --
  RETURN l_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN NULL;
  WHEN others
   THEN
      RAISE;
END determine_reg_status;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION determine_reg_status_for_flag(pi_works_order_no    IN work_orders.wor_works_order_no%TYPE
                                      ,pi_wor_register_flag IN work_orders.wor_register_flag%TYPE
                                      ,pi_wol_id            IN work_order_lines.wol_id%TYPE DEFAULT NULL)
  RETURN work_orders.wor_register_status%TYPE IS
  --
  l_retval work_orders.wor_register_status%TYPE;
  --
BEGIN
  --
  IF pi_wor_register_flag = 'Y'
   AND NOT hig.is_product_licensed(pi_product => 'TMA')
   THEN
      hig.raise_ner(pi_appl => 'MAI'
                   ,pi_id   => 918);
  END IF;
  --
  IF pi_wor_register_flag = 'N'
   THEN
      l_retval := NULL;
  ELSE
      l_retval := mai.determine_reg_status(pi_works_order_no => pi_works_order_no
                                          ,pi_wol_id         => pi_wol_id);
  END IF;
  --
  RETURN(l_retval);
  --
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
FUNCTION get_wo_wol_ids(pi_works_order_no IN work_orders.wor_works_order_no%TYPE)
  RETURN wol_id_tab IS
  --
  lt_retval  wol_id_tab;
  --
BEGIN
  --
  SELECT wol_id
    BULK COLLECT
    INTO lt_retval
    FROM work_order_lines
   WHERE wol_works_order_no = pi_works_order_no
       ;
  --
  RETURN lt_retval;
  --
END get_wo_wol_ids;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_feature_flags_rec(pi_domain          IN VARCHAR2
                              ,pi_status_code     IN hig_status_codes.hsc_status_code%TYPE
                              ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN feature_flags_rec IS

 l_refcursor nm3type.ref_cursor;

 l_sql VARCHAR2(2000);
 l_retval feature_flags_rec;

BEGIN

  l_sql := 'SELECT hsc_allow_feature1,hsc_allow_feature2,hsc_allow_feature3,hsc_allow_feature4,hsc_allow_feature5,hsc_allow_feature6,hsc_allow_feature7,hsc_allow_feature8,hsc_allow_feature9,hsc_allow_feature10'||chr(10)
         ||'  FROM hig_status_codes'||chr(10)
         ||' WHERE hsc_domain_code = :1'||chr(10)
         ||'   AND hsc_status_code = :2'||chr(10)
         ||'   AND :3 BETWEEN NVL(hsc_start_date,:4) AND NVL(hsc_end_date,:5)';

 OPEN l_refcursor FOR l_sql USING pi_domain, pi_status_code, pi_as_at_date,pi_as_at_date,pi_as_at_date;

 FETCH l_refcursor INTO l_retval;
 CLOSE l_refcursor;

 RETURN(l_retval);

END get_feature_flags_rec;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION expected_and_actual_the_same(pi_expected_rec IN feature_flags_rec
                                     ,pi_actual_rec   IN feature_flags_rec) RETURN BOOLEAN IS

BEGIN


 RETURN(  pi_actual_rec.hsc_allow_feature1 = NVL(pi_expected_rec.hsc_allow_feature1,pi_actual_rec.hsc_allow_feature1)
      AND pi_actual_rec.hsc_allow_feature2 = NVL(pi_expected_rec.hsc_allow_feature2,pi_actual_rec.hsc_allow_feature2)
      AND pi_actual_rec.hsc_allow_feature3 = NVL(pi_expected_rec.hsc_allow_feature3,pi_actual_rec.hsc_allow_feature3)
      AND pi_actual_rec.hsc_allow_feature4 = NVL(pi_expected_rec.hsc_allow_feature4,pi_actual_rec.hsc_allow_feature4)
      AND pi_actual_rec.hsc_allow_feature5 = NVL(pi_expected_rec.hsc_allow_feature5,pi_actual_rec.hsc_allow_feature5)
      AND pi_actual_rec.hsc_allow_feature6 = NVL(pi_expected_rec.hsc_allow_feature6,pi_actual_rec.hsc_allow_feature6)
      AND pi_actual_rec.hsc_allow_feature7 = NVL(pi_expected_rec.hsc_allow_feature7,pi_actual_rec.hsc_allow_feature7)
      AND pi_actual_rec.hsc_allow_feature8 = NVL(pi_expected_rec.hsc_allow_feature8,pi_actual_rec.hsc_allow_feature8)
      AND pi_actual_rec.hsc_allow_feature9 = NVL(pi_expected_rec.hsc_allow_feature9,pi_actual_rec.hsc_allow_feature9)
      );


END expected_and_actual_the_same;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION defect_is_AMENDABLE(pi_defect_status   IN defects.def_status_code%TYPE
                            ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN BOOLEAN IS


 l_expected_rec feature_flags_rec;

BEGIN


 l_expected_rec.hsc_allow_feature5 := 'Y';

  RETURN(
         expected_and_actual_the_same(pi_expected_rec => l_expected_rec
                                     ,pi_actual_rec   => get_feature_flags_rec(pi_domain         => 'DEFECTS'
                                                                              ,pi_status_code     => pi_defect_status
                                                                              ,pi_as_at_date      => pi_as_at_date)
                                      )
         );


END defect_is_AMENDABLE;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION defect_is_INSTRUCTED(pi_defect_status   IN defects.def_status_code%TYPE
                             ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN BOOLEAN IS


 l_expected_rec feature_flags_rec;

BEGIN


 l_expected_rec.hsc_allow_feature3 := 'Y';

  RETURN(
         expected_and_actual_the_same(pi_expected_rec => l_expected_rec
                                     ,pi_actual_rec   => get_feature_flags_rec(pi_domain         => 'DEFECTS'
                                                                              ,pi_status_code     => pi_defect_status
                                                                              ,pi_as_at_date      => pi_as_at_date)
                                      )
         );





END defect_is_INSTRUCTED;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION defect_is_COMPLETED(pi_defect_status   IN defects.def_status_code%TYPE
                            ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN BOOLEAN IS


 l_expected_rec feature_flags_rec;

BEGIN


   l_expected_rec.hsc_allow_feature4 := 'Y';

  RETURN(
         expected_and_actual_the_same(pi_expected_rec => l_expected_rec
                                     ,pi_actual_rec   => get_feature_flags_rec(pi_domain         => 'DEFECTS'
                                                                              ,pi_status_code     => pi_defect_status
                                                                              ,pi_as_at_date      => pi_as_at_date)
                                      )
         );


END defect_is_COMPLETED;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION defect_is_REPAIRED(pi_defect_status   IN defects.def_status_code%TYPE
                           ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN BOOLEAN IS


 l_expected_rec feature_flags_rec;

BEGIN


 l_expected_rec.hsc_allow_feature6 := 'Y';

  RETURN(
         expected_and_actual_the_same(pi_expected_rec => l_expected_rec
                                     ,pi_actual_rec   => get_feature_flags_rec(pi_domain         => 'DEFECTS'
                                                                              ,pi_status_code     => pi_defect_status
                                                                              ,pi_as_at_date      => pi_as_at_date)
                                      )
         );


END defect_is_REPAIRED;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION defect_is_SUPERSEDED(pi_defect_status   IN defects.def_status_code%TYPE
                             ,pi_as_at_date      IN DATE DEFAULT TRUNC(SYSDATE)) RETURN BOOLEAN IS


 l_expected_rec feature_flags_rec;

BEGIN


 l_expected_rec.hsc_allow_feature8 := 'Y';

  RETURN(
         expected_and_actual_the_same(pi_expected_rec => l_expected_rec
                                     ,pi_actual_rec   => get_feature_flags_rec(pi_domain         => 'DEFECTS'
                                                                              ,pi_status_code     => pi_defect_status
                                                                              ,pi_as_at_date      => pi_as_at_date)
                                      )
         );


END defect_is_SUPERSEDED;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION select_defects_for_wo(pi_defect_id           IN defects.def_defect_id%TYPE
                              ,pi_from_date           IN DATE
                              ,pi_to_date             IN DATE
                              ,pi_wor_date_raised     IN DATE
                              ,pi_con_admin_org_id    IN contracts.con_admin_org_id%TYPE
                              ,pi_xsp                 IN defects.def_x_sect%TYPE
                              ,pi_qry_id              IN pbi_query.qry_id%TYPE
                              ,pi_sys_flag            IN work_orders.wor_sys_flag%TYPE
                              ,pi_icb_id              IN item_code_breakdowns.icb_id%TYPE
                              ,pi_item_id             IN nm_inv_items_all.iit_ne_id%TYPE
                              ,pi_inv_code            IN inv_items_all.iit_ity_inv_code%TYPE
                              ,pi_priority_1          IN defects.def_priority%TYPE
                              ,pi_priority_2          IN defects.def_priority%TYPE
                              ,pi_priority_3          IN defects.def_priority%TYPE
                              ,pi_priority_4          IN defects.def_priority%TYPE
                              ,pi_priority_5          IN defects.def_priority%TYPE
                              ,pi_priority_6          IN defects.def_priority%TYPE
                              ,pi_sta_item_code       IN standard_items.sta_item_code%TYPE
                              ,pi_siss_id_1           IN defects.def_siss_id%TYPE
                              ,pi_siss_id_2           IN defects.def_siss_id%TYPE
                              ,pi_siss_id_3           IN defects.def_siss_id%TYPE
                              ,pi_siss_id_4           IN defects.def_siss_id%TYPE
                              ,pi_siss_id_5           IN defects.def_siss_id%TYPE
                              ,pi_siss_id_6           IN defects.def_siss_id%TYPE
                              ,pi_defect_code_1       IN defects.def_defect_code%TYPE
                              ,pi_defect_code_2       IN defects.def_defect_code%TYPE
                              ,pi_defect_code_3       IN defects.def_defect_code%TYPE
                              ,pi_defect_code_4       IN defects.def_defect_code%TYPE
                              ,pi_defect_code_5       IN defects.def_defect_code%TYPE
                              ,pi_defect_code_6       IN defects.def_defect_code%TYPE
                              ,pi_rse_he_id_1         IN nm_elements_all.ne_id%TYPE
                              ,pi_rse_he_id_2         IN nm_elements_all.ne_id%TYPE
                              ,pi_rse_he_id_3         IN nm_elements_all.ne_id%TYPE
                              ,pi_rse_he_id_4         IN nm_elements_all.ne_id%TYPE
                              ,pi_rse_he_id_5         IN nm_elements_all.ne_id%TYPE
                              ,pi_rse_he_id_6         IN nm_elements_all.ne_id%TYPE
                              ,pi_bud_rse_he_id       IN nm_elements_all.ne_id%TYPE
                              ,pi_wor_rse_he_id_group IN nm_elements_all.ne_id%TYPE
                              ,pi_tre_treat_code_1    IN treatments.tre_treat_code%TYPE
                              ,pi_tre_treat_code_2    IN treatments.tre_treat_code%TYPE
                              ,pi_tre_treat_code_3    IN treatments.tre_treat_code%TYPE
                              ,pi_tre_treat_code_4    IN treatments.tre_treat_code%TYPE
                              ,pi_tre_treat_code_5    IN treatments.tre_treat_code%TYPE
                              ,pi_tre_treat_code_6    IN treatments.tre_treat_code%TYPE
                              ,pi_include_permanent   IN VARCHAR2
                              ,pi_include_temporary   IN VARCHAR2)
  RETURN NUMBER IS
  --
  TYPE defect_rep_tab IS TABLE OF mai_def_selection_temp%ROWTYPE;
  lt_defects  defect_rep_tab;
  --
  lv_query   nm3type.max_varchar2;
  lv_in_list nm3type.max_varchar2;
  --
  FUNCTION get_in_list(pi_value1         IN VARCHAR2
                      ,pi_value2         IN VARCHAR2
                      ,pi_value3         IN VARCHAR2
                      ,pi_value4         IN VARCHAR2
                      ,pi_value5         IN VARCHAR2
                      ,pi_value6         IN VARCHAR2
                      ,pi_enclose_values IN BOOLEAN DEFAULT TRUE)
    RETURN VARCHAR2 IS
    --
    lv_retval nm3type.max_varchar2;
    --
    PROCEDURE add_to_list(pi_value IN VARCHAR2)
      IS
      --
    BEGIN
      IF pi_value IS NOT NULL
       THEN
          IF lv_retval IS NOT NULL
           THEN
              IF pi_enclose_values
               THEN
                  lv_retval := lv_retval||','||nm3flx.string(pi_value);
              ELSE
                  lv_retval := lv_retval||','||pi_value;
              END IF;
          ELSE
              IF pi_enclose_values
               THEN
                  lv_retval := nm3flx.string(pi_value);
              ELSE
                  lv_retval := pi_value;
              END IF;
          END IF;
      END IF;
    END add_to_list;
    --
  BEGIN
    --
    IF pi_value1 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value1);
    END IF;
    --
    IF pi_value2 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value2);
    END IF;
    --
    IF pi_value3 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value3);
    END IF;
    --
    IF pi_value4 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value4);
    END IF;
    --
    IF pi_value5 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value5);
    END IF;
    --
    IF pi_value6 IS NOT NULL
     THEN
        add_to_list(pi_value => pi_value6);
    END IF;
    --
    RETURN lv_retval;
    --
  END get_in_list;
  --
BEGIN
  /*
  ||Build the select statement.
  */
  lv_query := 'SELECT def_defect_id '
                  ||',rep_action_cat '
              ||'FROM repairs '
                  ||',defects '
             ||'WHERE def_status_code IN(SELECT hsc_status_code '
                                        ||'FROM hig_status_codes '
                                       ||'WHERE hsc_domain_code = ''DEFECTS'' '
                                         ||'AND (hsc_allow_feature2 = ''Y'' '
                                              ||'OR (hsc_allow_feature3 = ''Y'' AND hsc_allow_feature10 = ''Y'') '
                                              ||'OR (hsc_allow_feature3 = ''Y'' AND hsc_allow_feature10 != ''Y''))) '
               ||'AND def_date_compl IS NULL '
               ||'AND (def_notify_org_id IS NULL OR def_rechar_org_id IS NOT NULL) '
               ||'AND def_defect_id = rep_def_defect_id '
               ||'AND rep_date_completed IS NULL '
               ||'AND NVL(rep_superseded_flag,''N'') = ''N'' '
               ||'AND TRUNC(rep_created_date) <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'') '
               ||'AND NOT EXISTS(SELECT 1 '
                                ||'FROM work_order_lines '
                               ||'WHERE wol_def_defect_id = rep_def_defect_id '
                                 ||'AND wol_rep_action_cat = rep_action_cat '
                                 ||'AND wol_status_code != (SELECT hsc_status_code '
                                                           ||'FROM hig_status_codes '
                                                          ||'WHERE hsc_domain_code = ''WORK_ORDER_LINES'' '
                                                            ||'AND hsc_allow_feature5 = ''Y'')) '
               ||'AND EXISTS(SELECT 1 '
                            ||'FROM hig_admin_groups hag '
                                ||',road_sections rse1 '
                           ||'WHERE hag.hag_parent_admin_unit = '||pi_con_admin_org_id||' '
                           ||'AND hag.hag_child_admin_unit = rse1.rse_admin_unit '
                           ||'AND rse1.rse_he_id = def_rse_he_id) '
               ||'AND EXISTS(SELECT 1 '
                            ||'FROM ihms_conversions '
                            ||'WHERE ihc_atv_acty_area_code = rep_atv_acty_area_code '
                            ||'AND ihc_atv_acty_area_code = def_atv_acty_area_code '
                            ||'AND ihc_icb_id = '||pi_icb_id||') '
               ||'AND EXISTS(SELECT 1 '
                            ||'FROM activities_report '
                           ||'WHERE TRUNC(are_date_work_done) BETWEEN NVL(:pi_from_date,TRUNC(are_date_work_done)) '
                                                               ||'AND NVL(:pi_to_date,TRUNC(are_date_work_done)) '
                             ||'AND TRUNC(are_date_work_done) <= TRUNC(:pi_wor_date_raised) '
                             ||'AND are_report_id = def_are_report_id) '

  ;
  /*
  ||Check the sys_flag parameter.
  */
  IF pi_sys_flag != 'L'
   THEN
      lv_query := lv_query||'AND EXISTS(SELECT 1 '
                                       ||'FROM road_segments_all '
                                           ||',item_code_breakdowns '
                                      ||'WHERE rse_road_environment = DECODE(icb_rse_road_environment,NULL,rse_road_environment '
                                                                                                  ||',''R'' ,DECODE(rse_road_environment,''S'',''S'' '
                                                                                                                                           ||',''R'') '
                                                                                                  ||',''S'' ,DECODE(rse_road_environment,''R'',''R'' '
                                                                                                                                           ||',''S'') '
                                                                                                       ||',icb_rse_road_environment) '
                                        ||'AND icb_id = '||pi_icb_id||' '
                                        ||'AND rse_he_id = def_rse_he_id) '
      ;
  END IF;
  /*
  ||Check the XSP parameter.
  */
  IF pi_xsp IS NOT NULL
   THEN
      lv_query := lv_query||'AND NVL(def_x_sect,''@'') = '||pi_xsp||' ';
  END IF;
  /*
  ||Check the PBI Query Id parameter.
  */
  IF pi_qry_id IS NOT NULL
   THEN
      lv_query := lv_query||'AND def_iit_item_id IN(SELECT pbi_item_id '
                                                   ||'FROM pbi_results_inv '
                                                  ||'WHERE pbi_qry_id = '||pi_qry_id||' '
                                                    ||'AND pbi_user_name = Sys_Context(''NM3_SECURITY_CTX'', ''USERNAME'')) '
      ;
  END IF;
  /*
  ||Check the Asset Id parameter.
  */
  IF pi_item_id IS NOT NULL
   THEN
      lv_query := lv_query||'AND def_iit_item_id = '||pi_item_id||' ';
  END IF;
  /*
  ||Check the Asset Type parameter.
  */
  IF pi_inv_code IS NOT NULL
   THEN
      lv_query := lv_query||'AND EXISTS(SELECT 1 '
                                       ||'FROM inv_items_all '
                                      ||'WHERE iit_item_id = def_iit_item_id '
                                        ||'AND iit_ity_inv_code = '||nm3flx.string(pi_inv_code)||') '
      ;
  END IF;
  /*
  ||Check the Treatment Code parameters.
  */
  lv_in_list := get_in_list(pi_value1         => pi_priority_1
                           ,pi_value2         => pi_priority_2
                           ,pi_value3         => pi_priority_3
                           ,pi_value4         => pi_priority_4
                           ,pi_value5         => pi_priority_5
                           ,pi_value6         => pi_priority_6
                           ,pi_enclose_values => TRUE);
  IF lv_in_list IS NOT NULL
   THEN
      lv_query := lv_query||'AND def_priority IN('||lv_in_list||') ';
  END IF;            
  /*
  ||Check the Standard Item Code parameter.
  */
  IF pi_sta_item_code IS NOT NULL
   THEN
      lv_query := lv_query||'AND EXISTS(SELECT 1 '
                                       ||'FROM boq_items '
                                      ||'WHERE boq_defect_id = def_defect_id '
                                        ||'AND boq_sta_item_code LIKE '||nm3flx.string(pi_sta_item_code)||') '
      ;
  END IF;
  /*
  ||Check the SISS Code parameters.
  */
  lv_in_list := get_in_list(pi_value1         => pi_siss_id_1
                           ,pi_value2         => pi_siss_id_2
                           ,pi_value3         => pi_siss_id_3
                           ,pi_value4         => pi_siss_id_4
                           ,pi_value5         => pi_siss_id_5
                           ,pi_value6         => pi_siss_id_6
                           ,pi_enclose_values => TRUE);
  IF lv_in_list IS NOT NULL
   THEN
      lv_query := lv_query||'AND NVL(def_siss_id,''@'') IN('||lv_in_list||') ';
  END IF;
  /*
  ||Check the Defect Code parameters.
  */
  lv_in_list := get_in_list(pi_value1         => pi_defect_code_1
                           ,pi_value2         => pi_defect_code_2
                           ,pi_value3         => pi_defect_code_3
                           ,pi_value4         => pi_defect_code_4
                           ,pi_value5         => pi_defect_code_5
                           ,pi_value6         => pi_defect_code_6
                           ,pi_enclose_values => TRUE);
  IF lv_in_list IS NOT NULL
   THEN
      lv_query := lv_query||'AND def_defect_code IN('||lv_in_list||') ';
  END IF;
  /*
  ||Check the Defect Id parameter.
  */
  IF pi_defect_id IS NOT NULL
   THEN
      lv_query := lv_query||'AND def_defect_id = '||pi_defect_id||' ';
  END IF;
  /*
  ||Build the network subquery.
  */
  lv_query := lv_query||'AND def_rse_he_id IN(';
  --
  lv_in_list := get_in_list(pi_value1         => pi_rse_he_id_1
                           ,pi_value2         => pi_rse_he_id_2
                           ,pi_value3         => pi_rse_he_id_3
                           ,pi_value4         => pi_rse_he_id_4
                           ,pi_value5         => pi_rse_he_id_5
                           ,pi_value6         => pi_rse_he_id_6
                           ,pi_enclose_values => FALSE);
  --
  IF pi_defect_id IS NOT NULL
   THEN
      lv_query := lv_query||'SELECT def_rse_he_id '
                            ||'FROM defects '
                           ||'WHERE def_defect_id = '||pi_defect_id||' '
      ;
  ELSE
      IF lv_in_list IS NOT NULL
       THEN
          lv_in_list := 'IN('||lv_in_list||') ';
      ELSE
          lv_in_list := '= '||pi_wor_rse_he_id_group||' ';
      END IF;
      --
      lv_query := lv_query||'(SELECT nm_ne_id_of '
            ||'FROM nm_members '
            ||'WHERE nm_type = ''G'' '
            ||'CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in '
            ||'AND nm_end_date IS NULL '
            ||'START WITH nm_ne_id_in '||lv_in_list||' '
            ||'UNION '
            ||'SELECT ne_id '
            ||'FROM nm_elements '
            ||'WHERE ne_id '||lv_in_list||') '
      ;
  END IF;
  --
  lv_query := lv_query||'INTERSECT '
            ||'SELECT nm_ne_id_of '
            ||'FROM nm_members '
            ||'WHERE nm_type = ''G'' '
            ||'CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in '
            ||'AND nm_end_date IS NULL '
            ||'START with nm_ne_id_in = '||NVL(pi_bud_rse_he_id,pi_wor_rse_he_id_group)||') '
  ;
  /*
            ||'     AND def_rse_he_id IN((SELECT nm_ne_id_of'
            ||'                             FROM nm_members'
            ||'                            WHERE nm_type = ''G'''
            ||'                              AND cp_defect_id IS NULL'
            ||'                          CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
            ||'                                       AND nm_end_date IS NULL'
            ||'                            START WITH nm_ne_id_in IN(NVL(cp_rse_he_id_1,pi_wor_rse_he_id_group)'
            ||'                                                     ,cp_rse_he_id_2'
            ||'                                                     ,cp_rse_he_id_3'
            ||'                                                     ,cp_rse_he_id_4'
            ||'                                                     ,cp_rse_he_id_5'
            ||'                                                     ,cp_rse_he_id_6)'
            ||'                            UNION'
            ||'                           SELECT ne_id'
            ||'                             FROM nm_elements'
            ||'                            WHERE ne_id IN(NVL(cp_rse_he_id_1,pi_wor_rse_he_id_group)'
            ||'                                          ,cp_rse_he_id_2'
            ||'                                          ,cp_rse_he_id_3'
            ||'                                          ,cp_rse_he_id_4'
            ||'                                          ,cp_rse_he_id_5'
            ||'                                          ,cp_rse_he_id_6)'
            ||'                              AND cp_defect_id IS NULL'
            ||'                            UNION'
            ||'                           SELECT def_rse_he_id'
            ||'                             FROM defects'
            ||'                            WHERE def_defect_id = cp_defect_id)'
            ||'                        INTERSECT'
            ||'                           SELECT nm_ne_id_of'
            ||'                             FROM nm_members'
            ||'                            WHERE nm_type = ''G'''
            ||'                          CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
            ||'                                       AND nm_end_date IS NULL'
            ||'                            START with nm_ne_id_in = NVL(cp_bud_rse_he_id,cp_wor_rse_he_id_group))'
*/

  /*
  ||Check the Treatment Code parameters.
  */
  lv_in_list := get_in_list(pi_value1         => pi_tre_treat_code_1
                           ,pi_value2         => pi_tre_treat_code_2
                           ,pi_value3         => pi_tre_treat_code_3
                           ,pi_value4         => pi_tre_treat_code_4
                           ,pi_value5         => pi_tre_treat_code_5
                           ,pi_value6         => pi_tre_treat_code_6
                           ,pi_enclose_values => TRUE);
  IF lv_in_list IS NOT NULL
   THEN
      lv_query := lv_query||'AND NVL(rep_tre_treat_code,''@'') IN('||lv_in_list||') ';
  END IF;            
  /*
  ||Check the Include Repair Category flags.
  */  
  IF (NVL(pi_include_permanent,'N') = 'Y' AND NVL(pi_include_temporary,'N') = 'Y')
   THEN
      --
      lv_query := lv_query||'AND rep_action_cat IN(''P'',''T'') ';
      --
  ELSE
      IF NVL(pi_include_permanent,'N') = 'Y'
       THEN
          --
          lv_query := lv_query||'AND rep_action_cat = ''P'' ';
          --
      ELSIF NVL(pi_include_temporary,'N') = 'Y'
       THEN
          --
          lv_query := lv_query||'AND rep_action_cat = ''T'' ';
          --
      END IF;
  END IF;
  --  
  lv_query := lv_query||'FOR UPDATE '
                       ||'OF def_status_code '
                         ||',def_works_order_no '
                      ||'NOWAIT '
  ;
  
  nm_debug.debug_on;
  nm_debug.debug(lv_query);
  /*
  ||Execute the query.
  */
  EXECUTE IMMEDIATE lv_query 
  BULK COLLECT INTO lt_defects
  USING pi_from_date
       ,pi_to_date
       ,pi_wor_date_raised;
  /*
  ||Clear any records from previous searches.
  */
  DELETE FROM mai_def_selection_temp;
  /*
  ||Insert the Defect Id's into the temp table to be picked up by the calling code.
  */
  FORALL i IN 1..lt_defects.COUNT
    INSERT
      INTO mai_def_selection_temp
    VALUES lt_defects(i)
         ;
  /*
  ||Return the number of defects selected.
  */
  nm_debug.debug_off;
  RETURN lt_defects.COUNT;
  --
END select_defects_for_wo;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE calc_wol_totals
   (p_wol_id                              IN    work_order_lines.wol_id%TYPE
   ,p_wol_boq_perc_item_code   IN  work_order_lines.wol_boq_perc_item_code%TYPE
   ,p_wol_wol_perc_item_code   IN work_order_lines.wol_wol_perc_item_code%TYPE
   ,p_wol_est_cost                     OUT work_order_lines.wol_est_cost%TYPE
   ,p_wol_act_cost                     OUT work_order_lines.wol_act_cost%TYPE
   ,p_wol_est_labour                  OUT work_order_lines.wol_est_labour%TYPE)
   
  IS
  --
  cursor boq_uplift_rate(p_sta_item_code   standard_items.sta_item_code%TYPE) is
    select sta_rate
      from standard_items
    where sta_item_code = p_sta_item_code;
  --
  cursor wol_totals is
    select sum(nvl(boq_est_labour,0)),
             decode(count(0), count(boq_est_cost), sum(boq_est_cost), null) ,
             sum(boq_act_cost)
      from boq_items
    where boq_wol_id = p_wol_id;
--
  cursor wol_boq_uplift_totals(p_boq_uplift_rate   standard_items.sta_rate%TYPE) is
   select NVL(sum(boq_est_cost) * (p_boq_uplift_rate / 100),0)
           ,NVL(sum(boq_act_cost) * (p_boq_uplift_rate / 100),0)
     from standard_items,
             boq_items
    where boq_sta_item_code = sta_item_code
      and NVL(sta_allow_percent, 'Y') = 'Y'
      and boq_wol_id = p_wol_id;
--
  lv_boq_uplift_rate                  standard_items.sta_rate%TYPE;
  lv_wol_uplift_rate                  standard_items.sta_rate%TYPE;
  --
  lv_wol_est_cost      work_order_lines.wol_est_cost%TYPE;
  lv_wol_act_cost      work_order_lines.wol_act_cost%TYPE;
  lv_wol_est_labour    work_order_lines.wol_est_labour%TYPE;
--
  lv_wol_est_uplift    NUMBER := 0;
  lv_wol_act_uplift    NUMBER := 0;
--
begin
  /*
  || Get WOL percent Uplift Item Codes rates
  */
  if p_wol_boq_perc_item_code IS NOT NULL
  then
    open boq_uplift_rate(p_wol_boq_perc_item_code);
    fetch boq_uplift_rate into lv_boq_uplift_rate;
    close boq_uplift_rate;
  end if;
  
  if p_wol_wol_perc_item_code IS NOT NULL
  then
    open boq_uplift_rate(p_wol_wol_perc_item_code);
    fetch boq_uplift_rate into lv_wol_uplift_rate;
    close boq_uplift_rate;
  end if;
 
   /*
  || Get WOL totals
  */
  open  wol_totals;
  fetch wol_totals into lv_wol_est_labour
                               ,lv_wol_est_cost
                               ,lv_wol_act_cost;
  close wol_totals;
  
  if p_wol_boq_perc_item_code IS NOT NULL
      then
         open wol_boq_uplift_totals(lv_boq_uplift_rate);
         fetch wol_boq_uplift_totals into lv_wol_est_uplift,
                                                       lv_wol_act_uplift;
         close wol_boq_uplift_totals;
       
         lv_wol_est_cost := lv_wol_est_cost + lv_wol_est_uplift;
         lv_wol_act_cost := lv_wol_act_cost + lv_wol_act_uplift;
       
  end if;
  
  if p_wol_wol_perc_item_code IS NOT NULL
      then
        lv_wol_est_cost := lv_wol_est_cost + (lv_wol_est_cost * (lv_wol_uplift_rate / 100));
        lv_wol_act_cost := lv_wol_act_cost + (lv_wol_act_cost * (lv_wol_uplift_rate / 100));
  end if;

  p_wol_est_labour := lv_wol_est_labour;
  p_wol_est_cost    := lv_wol_est_cost;
  p_wol_act_cost    := lv_wol_act_cost;
  
end calc_wol_totals;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE get_wor_uplift_costs
   (p_wor_works_order_no   IN    work_orders.wor_works_order_no%TYPE,
    p_wor_est_cost               IN    work_orders.wor_est_cost%TYPE,
    p_wor_act_cost               IN    work_orders.wor_act_cost%TYPE,
    p_wor_est_uplift_cost      OUT NUMBER,
    p_wor_act_uplift_cost      OUT NUMBER)
   
  IS
  --
  cursor c_wol is
  select wol_id,
            wol_boq_perc_item_code,
            wol_wol_perc_item_code
    from work_order_lines
  where wol_works_order_no = p_wor_works_order_no;
  --
  lv_wol_est_cost        work_order_lines.wol_est_cost%TYPE;
  lv_wol_act_cost        work_order_lines.wol_act_cost%TYPE;
  lv_wol_est_labour     work_order_lines.wol_est_labour%TYPE;
  lv_tot_est_cost         work_order_lines.wol_est_cost%TYPE := 0;
  lv_tot_act_cost         work_order_lines.wol_act_cost%TYPE := 0;
  --
begin
  for wol_rec in c_wol loop
  
       calc_wol_totals(p_wol_id                             => wol_rec.wol_id
                             ,p_wol_boq_perc_item_code  => wol_rec.wol_boq_perc_item_code
                             ,p_wol_wol_perc_item_code  => wol_rec.wol_wol_perc_item_code
                             ,p_wol_est_cost                    => lv_wol_est_cost
                             ,p_wol_act_cost                    => lv_wol_act_cost
                             ,p_wol_est_labour                 => lv_wol_est_labour);

        lv_tot_est_cost := lv_tot_est_cost + lv_wol_est_cost;
        lv_tot_act_cost := lv_tot_act_cost + lv_wol_act_cost;
  end loop;

  p_wor_est_uplift_cost := lv_tot_est_cost - NVL(p_wor_est_cost,0);
  p_wor_act_uplift_cost := lv_tot_act_cost - NVL(p_wor_act_cost,0);
  
end get_wor_uplift_costs;
--
---------------------------------------------------------------------------------------------------
--
BEGIN  /* mai - automatic variables */
  /*
    return the Oracle user who is owner of the MAI application
    (use 'DEFECTS' as the sample HIGHWAYS object)
  */
  IF    (Sys_Context('NM3CORE','APPLICATION_OWNER') IS NULL) THEN
    RAISE_APPLICATION_ERROR( -20000 ,'MAI.G_APPLICATION_OWNER is null.');
  END IF;

  /* return the language under which the application is running */
  g_language := 'ENGLISH';


  g_swr_licenced := nm3ddl.does_object_exist(p_object_name => 'SWR_ID_MAPPING'
                                            ,p_object_type => 'TABLE');


  g_tma_licenced := nm3ddl.does_object_exist(p_object_name => 'TMA_ID_MAPPING'
                                            ,p_object_type => 'TABLE');

END mai;
/
