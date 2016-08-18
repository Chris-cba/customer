CREATE OR REPLACE PACKAGE BODY nem_dcm_interface
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/dcm_interface/nem_dcm_interface.pkb-arc   1.1   Aug 18 2016 14:22:32   Peter.Bibby  $
  --       Module Name      : $Workfile:   nem_dcm_interface.pkb  $
  --       Date into PVCS   : $Date:   Aug 18 2016 14:22:32  $
  --       Date fetched Out : $Modtime:   Aug 18 2016 14:03:10  $
  --       Version          : $Revision:   1.1  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.1  $';
  g_package_name   CONSTANT VARCHAR2 (30) := 'nem_dcm_interface';
  --
  c_impact_group_level  CONSTANT PLS_INTEGER := 2;
  c_schedule_level      CONSTANT PLS_INTEGER := 1;
  --  
  TYPE speed_limit_map_tab IS TABLE OF nem_dcm_speed_limit_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_speed_limit_map  speed_limit_map_tab;
  --
  TYPE lane_status_map_tab IS TABLE OF nem_dcm_lane_status_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_lane_status_map  lane_status_map_tab;
  --
  TYPE diversion_quality_map_tab IS TABLE OF nem_dcm_diversion_quality_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_diversion_quality_map  diversion_quality_map_tab;
  --  
  TYPE asset_types IS TABLE OF nm_inv_types_all.nit_inv_type%TYPE INDEX BY BINARY_INTEGER;
  g_asset_types_tab  asset_types;
  --  
  TYPE speed_limit_rec IS RECORD(limit_level   PLS_INTEGER
                                ,limit_rank    PLS_INTEGER
                                ,dcm_meaning   nem_dcm_speed_limit_map.dcm_meaning%TYPE
                                ,dcm_enforced_at_all_times CHAR(1));
  --
  TYPE traffic_man_rec IS RECORD(traffic_value  VARCHAR2(100)
                                ,traffic_rank   PLS_INTEGER);
  --
  TYPE location_rec IS RECORD(asset_id           nm_members_all.nm_ne_id_in%TYPE
                             ,element_id         nm_members_all.nm_ne_id_of%TYPE
                             ,element_type       nm_elements_all.ne_nt_type%TYPE
                             ,element_unique     nm_elements_all.ne_unique%TYPE
                             ,element_descr      nm_elements_all.ne_descr%TYPE
                             ,from_offset        nm_members_all.nm_begin_mp%TYPE
                             ,to_offset          nm_members_all.nm_end_mp%TYPE
                             ,offset_length      nm_elements_all.ne_length%TYPE
                             ,element_length     nm_elements_all.ne_length%TYPE   
                             ,element_unit_id    nm_units.un_unit_id%TYPE
                             ,element_unit_name  nm_units.un_unit_name%TYPE
                             ,element_admin_unit nm_admin_units_all.nau_name%TYPE);
  TYPE location_tab IS TABLE OF location_rec INDEX BY BINARY_INTEGER;
  --
  TYPE section_rec IS RECORD(section_label       nm_elements.ne_unique%TYPE
                            ,section_length      nm_elements.ne_id%TYPE
                            ,number_of_lanes     nm_inv_items.iit_num_attrib22%TYPE
                            ,road_type           nm_elements.ne_sub_class%TYPE
                            ,section_function    nm_inv_items.iit_chr_attrib57%TYPE
                            ,single_or_dual      nm_inv_items.iit_chr_attrib27%TYPE
                            ,environment         nm_inv_items.iit_chr_attrib41%TYPE
                            ,diversion_quality   nm_inv_items.iit_chr_attrib69%TYPE
                            ,psa_rout            CHAR(1));
  --
  TYPE asset_rec IS RECORD(asset_id           nm_members_all.nm_ne_id_in%TYPE
                             ,from_offset        nm_members_all.nm_begin_mp%TYPE
                             ,to_offset          nm_members_all.nm_end_mp%TYPE
                             ,object_type        nm_members_all.nm_obj_type%TYPE);
  TYPE asset_tab IS TABLE OF asset_rec INDEX BY BINARY_INTEGER;  
  --  
  TYPE diqu_asset_rec IS RECORD(asset_id           nm_members_all.nm_ne_id_in%TYPE
                               ,from_offset        nm_members_all.nm_begin_mp%TYPE
                               ,to_offset          nm_members_all.nm_end_mp%TYPE
                               ,diversion_quality  VARCHAR2(4));
  TYPE diqu_asset_tab IS TABLE OF diqu_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE spee_asset_rec IS RECORD(asset_id          nm_members_all.nm_ne_id_in%TYPE
                               ,st_date           nm_inv_items_all.iit_start_date%TYPE
                               ,end_date          nm_inv_items_all.iit_end_date%TYPE
                               ,from_offset       nm_members_all.nm_begin_mp%TYPE
                               ,to_offset         nm_members_all.nm_end_mp%TYPE
                               ,speed_limit       VARCHAR(4));
  TYPE spee_asset_tab IS TABLE OF spee_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE tr1_asset_rec IS RECORD(asset_id           nm_members_all.nm_ne_id_in%TYPE
                              ,from_offset        nm_members_all.nm_begin_mp%TYPE
                              ,to_offset          nm_members_all.nm_end_mp%TYPE
                              ,effective_date     nm_inv_items_all.iit_date_attrib86%TYPE
                              ,cv                NUMBER
                              ,non_cv            NUMBER
                          );
  TYPE tr1_asset_tab IS TABLE OF tr1_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE tr2_asset_rec IS RECORD(asset_id  NUMBER
                              ,from_offset       nm_members_all.nm_begin_mp%TYPE
                              ,to_offset         nm_members_all.nm_end_mp%TYPE  
                              ,effective_date    DATE
                              ,psv               NUMBER
                              ,ogv1              NUMBER
                              ,ogv2              NUMBER
                              ,lgv               NUMBER
                              ,cars              NUMBER);
  TYPE tr2_asset_tab IS TABLE OF tr2_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE tr3_asset_rec IS RECORD(asset_id      NUMBER
                              ,from_offset       nm_members_all.nm_begin_mp%TYPE
                              ,to_offset         nm_members_all.nm_end_mp%TYPE    
                              ,effective_date    DATE
                              ,psv               NUMBER
                              ,r2                NUMBER
                              ,r3                NUMBER
                              ,a3                NUMBER
                              ,r4                NUMBER
                              ,a4                NUMBER
                              ,a5                NUMBER
                              ,a6                NUMBER
                              ,lgv               NUMBER
                              ,cars              NUMBER);
  TYPE tr3_asset_tab IS TABLE OF tr3_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE trt_asset_rec IS RECORD(asset_id        NUMBER
                              ,from_offset     nm_members_all.nm_begin_mp%TYPE
                              ,to_offset       nm_members_all.nm_end_mp%TYPE 
                              ,day_type        NUMBER
                              ,tf_00_01        NUMBER
                              ,tf_01_02        NUMBER
                              ,tf_02_03        NUMBER
                              ,tf_03_04        NUMBER
                              ,tf_04_05        NUMBER
                              ,tf_05_06        NUMBER
                              ,tf_06_07        NUMBER
                              ,tf_07_08        NUMBER
                              ,tf_08_09        NUMBER
                              ,tf_09_10        NUMBER
                              ,tf_10_11        NUMBER
                              ,tf_11_12        NUMBER
                              ,tf_12_13        NUMBER
                              ,tf_13_14        NUMBER
                              ,tf_14_15        NUMBER
                              ,tf_15_16        NUMBER
                              ,tf_16_17        NUMBER
                              ,tf_17_18        NUMBER
                              ,tf_18_19        NUMBER
                              ,tf_19_20        NUMBER
                              ,tf_20_21        NUMBER
                              ,tf_21_22        NUMBER
                              ,tf_22_23        NUMBER
                              ,tf_23_24        NUMBER);
  TYPE trt_asset_tab IS TABLE OF trt_asset_rec INDEX BY BINARY_INTEGER;
  --
  TYPE nigs_diary_rec IS RECORD (nig_name nem_impact_groups.nig_name%TYPE
                           ,nigs_planned_startdate nem_impact_group_schedules.nigs_planned_startdate%TYPE
                           ,nigs_actual_startdate nem_impact_group_schedules.nigs_actual_startdate%TYPE
                           ,nigs_planned_enddate nem_impact_group_schedules.nigs_planned_enddate%TYPE
                           ,nigs_actual_enddate nem_impact_group_schedules.nigs_actual_enddate%TYPE);
  TYPE nigs_diary_tab IS TABLE OF nigs_diary_rec INDEX BY BINARY_INTEGER;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;
  --
  -----------------------------------------------------------------------------
  --  
  PROCEDURE process_log_entry(pi_message      IN hig_process_log.hpl_message%TYPE
                             ,pi_message_type IN hig_process_log.hpl_message_type%TYPE DEFAULT 'I'
                             ,pi_summary_flag IN hig_process_log.hpl_summary_flag%TYPE default 'Y')
    IS
    --
  BEGIN
    --
    hig_process_api.log_it(pi_message_type => pi_message_type
                          ,pi_message      => pi_message
                          ,pi_summary_flag => pi_summary_flag);
    --
  END process_log_entry;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION execute_gaz_query(pi_ne_id   IN nm_elements_all.ne_id%TYPE)
    RETURN NUMBER IS
    --
    lv_job_id    NUMBER := nm3ddl.sequence_nextval('RTG_JOB_ID_SEQ');
    lv_query_id  NUMBER;
    --
  BEGIN
    --
    INSERT
      INTO nm_gaz_query
          (ngq_id
          ,ngq_source_id
          ,ngq_source
          ,ngq_open_or_closed
          ,ngq_items_or_area
          ,ngq_query_all_items)
    VALUES(lv_job_id
          ,pi_ne_id
          ,'ROUTE'
          ,'C'
          ,'I'
          ,'N')
         ;
    --Pass all asset types in.
    FOR i in 1..g_asset_types_tab.COUNT LOOP      
      --
      INSERT
        INTO nm_gaz_query_types
            (ngqt_ngq_id
            ,ngqt_seq_no
            ,ngqt_item_type_type
            ,ngqt_item_type)
      VALUES(lv_job_id
            ,i
            ,'I'
            ,g_asset_types_tab(i));
      --
    END LOOP;
    --
    lv_query_id := nm3gaz_qry.perform_query (lv_job_id);
    --
    RETURN lv_query_id;
    --
  END execute_gaz_query;
  --
  -----------------------------------------------------------------------------
  --  
  PROCEDURE set_speed_limit(pi_speed_limit  IN nem_impact_groups.nig_speed_limit%TYPE
                           ,pi_level        IN PLS_INTEGER
                           ,po_lowest_limit IN OUT speed_limit_rec)
    IS
    --
    lv_temp_limit  speed_limit_rec;
    --
  BEGIN
    /*
    ||Speed Limits can be set at Impact Group Level and at Schedule Level.
    ||Schedule Level Speed Limits override Impact Group Speed Limits.
    ||The values are ranked in the table nem_dcm_speed_limit_map
    ||and the lowest rank wins.
    */
    lv_temp_limit.dcm_enforced_at_all_times :='N';
    --
    FOR i IN 1..g_speed_limit_map.COUNT LOOP
      --
      IF g_speed_limit_map(i).nem_code = pi_speed_limit
       THEN
          lv_temp_limit.limit_level := pi_level;
          lv_temp_limit.limit_rank  := g_speed_limit_map(i).dcm_rank;
          lv_temp_limit.dcm_meaning := g_speed_limit_map(i).dcm_meaning;
          /*
          ||If Unchanged or N/A Is selected in NEM against Impact Group return enforced at all times N. 
          */
          IF lv_temp_limit.dcm_meaning != 0 
           AND pi_level = c_impact_group_level
           THEN
             lv_temp_limit.dcm_enforced_at_all_times := 'Y';
          END IF;
          EXIT;
      END IF;
      --        
    END LOOP;
    --
    IF po_lowest_limit.dcm_meaning IS NULL
     OR (lv_temp_limit.limit_level < po_lowest_limit.limit_level
         AND lv_temp_limit.dcm_meaning != 'Unchanged')
     OR (lv_temp_limit.limit_level = po_lowest_limit.limit_level
         AND lv_temp_limit.limit_rank < po_lowest_limit.limit_rank)
     THEN
        po_lowest_limit := lv_temp_limit;
    END IF;
    --
    po_lowest_limit.dcm_enforced_at_all_times:=lv_temp_limit.dcm_enforced_at_all_times;
    --
  END set_speed_limit;
  --
  -----------------------------------------------------------------------------
  --  
  PROCEDURE set_traffic_management(pi_nig_rec             IN     nem_impact_groups%ROWTYPE
                                  ,pi_speed_limit         IN     nem_dcm_speed_limit_map.dcm_meaning%TYPE
                                  ,pi_mobile_lane_closure IN     VARCHAR2
                                  ,po_traffic_management  IN OUT traffic_man_rec)
    IS
    --
    lr_temp_value  traffic_man_rec;
    --
    FUNCTION includes_lane_closure(pi_nig_id IN nem_impact_groups.nig_id%TYPE)
      RETURN BOOLEAN IS
      --
      lv_dummy   NUMBER;
      lv_retval  BOOLEAN;
      --
      CURSOR lane_chk(cp_nig_id IN nem_impact_groups.nig_id%TYPE)
          IS
      SELECT 1
        FROM nem_impact_group_xsps
       WHERE nigx_nig_id = cp_nig_id
         AND nigx_reason = 'CLOSED'
           ;
    BEGIN
      --
      OPEN  lane_chk(pi_nig_id);
      FETCH lane_chk
       INTO lv_dummy;
      lv_retval := lane_chk%FOUND;
      CLOSE lane_chk;
      --
      RETURN lv_retval;
      --
    END includes_lane_closure;
    --
  BEGIN
    --
    CASE
      WHEN pi_nig_rec.nig_carriageway_closure = 'Y'
       THEN
          --Carriageway Closure
          lr_temp_value.traffic_value := '2';
          lr_temp_value.traffic_rank := 1;
      WHEN includes_lane_closure(pi_nig_id => pi_nig_rec.nig_id)
       THEN
          --Lane Closure
          lr_temp_value.traffic_value := '4';
          lr_temp_value.traffic_rank := 2;
      WHEN pi_nig_rec.nig_contraflow = 'Y'
       THEN
          --Contraflow
          lr_temp_value.traffic_value := '1';
          lr_temp_value.traffic_rank := 3;
      WHEN pi_nig_rec.nig_width_restriction = 'Y'
       THEN
          --Width Restriction
          lr_temp_value.traffic_value := '9';
          lr_temp_value.traffic_rank := 4;
      WHEN pi_speed_limit != 'Unchanged'
       THEN
          --Speed Restriction
          lr_temp_value.traffic_value := '11';
          lr_temp_value.traffic_rank := 5;
      WHEN pi_nig_rec.nig_traffic_management = 'CONVOY WORKING'
       THEN
          --Convoy Working
          lr_temp_value.traffic_value := '3';
          lr_temp_value.traffic_rank := 6;
      WHEN pi_mobile_lane_closure = 'Y'
       THEN
          --Mobile Lane Closure
          lr_temp_value.traffic_value := '6';
          lr_temp_value.traffic_rank := 7;
      WHEN pi_nig_rec.nig_traffic_management = 'TRAFFIC SIGNALS'
       THEN
          --Traffic Signals
          lr_temp_value.traffic_value := '7';
          lr_temp_value.traffic_rank := 8;
      WHEN pi_nig_rec.nig_weight_restriction = 'Y'
       THEN
          --Weight Restriction
          lr_temp_value.traffic_value := '12';
          lr_temp_value.traffic_rank := 9;
      WHEN pi_nig_rec.nig_height_restriction = 'Y'
       THEN
          --Height Restriction
          lr_temp_value.traffic_value := '10';
          lr_temp_value.traffic_rank := 10;
      ELSE
          --None
          lr_temp_value.traffic_value := '14';
          lr_temp_value.traffic_rank := 11;
    END CASE;
    --
    IF po_traffic_management.traffic_value IS NULL
     OR lr_temp_value.traffic_rank < po_traffic_management.traffic_rank
     THEN
        po_traffic_management := lr_temp_value;
    END IF;
    --
  END set_traffic_management;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION gen_get_events_sql
    RETURN nm3type.max_varchar2 IS
    --
    lv_sql nm3type.max_varchar2;
    --
  BEGIN
    --
    lv_sql :=  'SELECT nevt_id'
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'DESCRIPTION')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'PLANNED_START_DATE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'PLANNED_COMPLETE_DATE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'ACTUAL_START_DATE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'ACTUAL_COMPLETE_DATE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'VERSION_NUMBER')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'NATURE_OF_WORKS')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'DISTRIBUTE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'DELAY')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'NOTES')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'USER_RESPONSIBLE')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'HE_REF')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'WORKS_REF')
    ||CHR(10)||'      ,'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'MOBILE_LANE_CLOSURE')
    ||CHR(10)||'      ,iit_date_modified'
    ||CHR(10)||'  FROM nm_inv_items_all'
    ||CHR(10)||'      ,nem_events'
    ||CHR(10)||' WHERE nevt_id = iit_ne_id'
    ;
    --
    RETURN lv_sql;
    --
  END gen_get_events_sql;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE init_lookups
    IS
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO g_speed_limit_map
      FROM nem_dcm_speed_limit_map
     ORDER
        BY dcm_rank
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_lane_status_map
      FROM nem_dcm_lane_status_map
         ;         
    --    
    SELECT *
      BULK COLLECT
      INTO g_diversion_quality_map
      FROM nem_dcm_diversion_quality_map
         ;   
    --         
    g_asset_types_tab(1) := 'DIQU';
    g_asset_types_tab(2) := 'SPEE';
    g_asset_types_tab(3) := 'TR1C';
    g_asset_types_tab(4) := 'TR2C';
    g_asset_types_tab(5) := 'TR3C';   
    g_asset_types_tab(6) := 'TR1L';
    g_asset_types_tab(7) := 'TR2L';   
    g_asset_types_tab(8) := 'TR3L';   
    g_asset_types_tab(9) := 'TRT'; 
    --     
  END init_lookups;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_lvm
    RETURN nem_lvms.nlvm_id%TYPE IS
    --
    lv_retval  nem_lvms.nlvm_id%TYPE;
    --
  BEGIN
    --
    SELECT nlvm_id
      INTO lv_retval
      FROM nem_lvms
     WHERE NLVM_DATUM_NT_TYPE = 'ESU'
       AND NLVM_TARGET_NT_TYPE = 'D'
       AND NLVM_TARGET_GTY_TYPE = 'SECT'
         ;
    --
    RETURN lv_retval;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Unable to establish the LVM ID for the SECT Group Type.');
    WHEN others
     THEN
        RAISE;
  END get_lvm;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_asset(pi_section_label IN  nm_elements_all.ne_unique%TYPE
                     ,po_diqu_details  IN OUT diqu_asset_tab
                     ,po_spee_details  IN OUT spee_asset_tab
                     ,po_tr1l_details  IN OUT tr1_asset_tab
                     ,po_tr1c_details  IN OUT tr1_asset_tab
                     ,po_tr2l_details  IN OUT tr2_asset_tab
                     ,po_tr2c_details  IN OUT tr2_asset_tab
                     ,po_tr3l_details  IN OUT tr3_asset_tab
                     ,po_tr3c_details  IN OUT tr3_asset_tab
                     ,po_trt_details   IN OUT trt_asset_tab)
    IS
    --
    lv_job_id  PLS_INTEGER;
    lv_lvm_id  nem_lvms.nlvm_id%TYPE := get_lvm;
    lt_active_lvm     nem_lvm_api.lvm_id_tab;
    lt_asset           asset_tab;
    lr_diqu            diqu_asset_rec;
    lr_tr1c            tr1_asset_rec;
    lr_tr1l            tr1_asset_rec;
    lr_tr2c            tr2_asset_rec;
    lr_tr2l            tr2_asset_rec;
    lr_tr3c            tr3_asset_rec;
    lr_tr3l            tr3_asset_rec;
    lr_trt             trt_asset_rec;  
    lr_spee            spee_asset_rec;
    lt_diqu            diqu_asset_tab;    
    lt_tr1c            tr1_asset_tab;
    lt_tr1l            tr1_asset_tab;
    lt_tr2c            tr2_asset_tab;
    lt_tr2l            tr2_asset_tab;
    lt_tr3c            tr3_asset_tab;
    lt_tr3l            tr3_asset_tab;
    lt_trt             trt_asset_tab;  
    lt_spee            spee_asset_tab;
    --
  BEGIN
    lt_diqu.DELETE;
    lt_spee.DELETE;
    lt_tr1l.DELETE;
    lt_tr1c.DELETE;
    lt_tr2l.DELETE;
    lt_tr2c.DELETE;
    lt_tr3l.DELETE;    
    lt_tr3c.DELETE;
    lt_trt.DELETE;  
    /*
    ||Set the Section LVM.
    */
    lt_active_lvm(1) := lv_lvm_id;
    /*
    ||Use Gaz Query to find the Assets at the given location.
    */
    lv_job_id := execute_gaz_query(pi_ne_id    => nem_util.get_ne_id(pi_section_label));
    /*
    ||Select the Assets and their Datum Locations.
    */
    SELECT im.nm_ne_id_in asset_id
          ,pl.pl_start    from_offset
          ,pl.pl_end      to_offset
          ,im.nm_obj_type object_type
     BULK COLLECT
     INTO lt_asset
     FROM nm_members rm
         ,nm_members im
         ,TABLE(nm3pla.get_connected_chunks(im.nm_ne_id_in,rm.nm_ne_id_in).npa_placement_array) pl
    WHERE im.nm_ne_id_in IN(SELECT ngqi_item_id FROM nm_gaz_query_item_list WHERE ngqi_job_id = lv_job_id)
      AND im.nm_ne_id_of = rm.nm_ne_id_of
      AND rm.nm_obj_type = 'SECT'
    GROUP
       BY im.nm_ne_id_in
         ,rm.nm_ne_id_in
         ,pl.pl_start
         ,pl.pl_end
         ,im.nm_obj_type;
    --    
    FOR i in 1..lt_asset.COUNT LOOP
      CASE 
      WHEN lt_asset(i).object_type = 'DIQU' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_chr_attrib26 Diversion_quality
          INTO lr_diqu
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;
        --           
        lt_diqu(lt_diqu.COUNT+1) := lr_diqu;
       --
      WHEN lt_asset(i).object_type = 'TR1C' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 cv
              ,iit_num_attrib101 non_cv
          INTO lr_tr1c
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
          AND iit_inv_type = lt_asset(i).object_type;   
        --
        lt_tr1c(lt_tr1c.COUNT+1) := lr_tr1c;
        --
      WHEN lt_asset(i).object_type = 'TR1L' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 cv
              ,iit_num_attrib101 non_cv
          INTO lr_tr1l
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;  
        --
        lt_tr1l(lt_tr1l.COUNT+1) := lr_tr1l;   
        --
      WHEN lt_asset(i).object_type = 'TR2C' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 psv
              ,iit_num_attrib101 ogv1
              ,iit_num_attrib102 ogv2
              ,iit_num_attrib103 lgv
              ,iit_num_attrib104 cars
          INTO lr_tr2c
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;
        --          
        lt_tr2c(lt_tr2c.COUNT+1) := lr_tr2c;        
        --
      WHEN lt_asset(i).object_type = 'TR2L' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 psv
              ,iit_num_attrib101 ogv1
              ,iit_num_attrib102 ogv2
              ,iit_num_attrib103 lgv
              ,iit_num_attrib104 cars
          INTO lr_tr2l
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;  
        --
        lt_tr2l(lt_tr2l.COUNT+1) := lr_tr2l;   
        --
      WHEN lt_asset(i).object_type = 'TR3C' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 psv
              ,iit_num_attrib101 r2
              ,iit_num_attrib102 r3
              ,iit_num_attrib103 a3
              ,iit_num_attrib104 r4
              ,iit_num_attrib105 a4
              ,iit_num_attrib106 a5
              ,iit_num_attrib107 a6
              ,iit_num_attrib108 lgv
              ,iit_num_attrib109 cars
          INTO lr_tr3c
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;  
         --
         lt_tr3c(lt_tr3c.COUNT+1) := lr_tr3c;            
         --
      WHEN lt_asset(i).object_type = 'TR3L' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_date_attrib86 effective_date
              ,iit_num_attrib100 psv
              ,iit_num_attrib101 r2
              ,iit_num_attrib102 r3
              ,iit_num_attrib103 a3
              ,iit_num_attrib104 r4
              ,iit_num_attrib105 a4
              ,iit_num_attrib106 a5
              ,iit_num_attrib107 a6
              ,iit_num_attrib108 lgv
              ,iit_num_attrib109 cars
          INTO lr_tr3l
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type; 
        --          
        lt_tr3l(lt_tr3l.COUNT+1) := lr_tr3l;        
        --
      WHEN lt_asset(i).object_type = 'SPEE' THEN
        SELECT lt_asset(i).asset_id
              ,iit_start_date
              ,iit_end_date 
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_chr_attrib26 speed_limit
          INTO lr_spee
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;    
        --
        lt_spee(lt_spee.COUNT+1) := lr_spee;
        --
      WHEN lt_asset(i).object_type = 'TRT' THEN
        SELECT lt_asset(i).asset_id
              ,lt_asset(i).from_offset
              ,lt_asset(i).to_offset
              ,iit_num_attrib16 day_type
              ,iit_num_attrib100 tf_00_01
              ,iit_num_attrib101 tf_01_02
              ,iit_num_attrib102 tf_02_03
              ,iit_num_attrib103 tf_03_04
              ,iit_num_attrib104 tf_04_05
              ,iit_num_attrib105 tf_05_06
              ,iit_num_attrib106 tf_06_07
              ,iit_num_attrib107 tf_07_08
              ,iit_num_attrib108 tf_08_09
              ,iit_num_attrib109 tf_09_10
              ,iit_num_attrib110 tf_10_11
              ,iit_num_attrib111 tf_11_12
              ,iit_num_attrib112 tf_12_13
              ,iit_num_attrib113 tf_13_14
              ,iit_num_attrib114 tf_14_15
              ,iit_num_attrib115 tf_15_16
              ,iit_num_attrib80 tf_16_17
              ,iit_num_attrib81 tf_17_18
              ,iit_num_attrib82 tf_18_19
              ,iit_num_attrib83 tf_19_20
              ,iit_num_attrib84 tf_20_21
              ,iit_num_attrib85 tf_21_22
              ,iit_num_attrib96 tf_22_23
              ,iit_num_attrib97 tf_23_24
          INTO lr_trt
          FROM nm_inv_items_all 
         WHERE iit_ne_id = lt_asset(i).asset_id
           AND iit_inv_type = lt_asset(i).object_type;
        --
        lt_trt(lt_trt.COUNT+1) := lr_trt;           
        --
      END CASE;
    END LOOP;
    --
    po_diqu_details := lt_diqu;
    po_tr1l_details := lt_tr1l;
    po_tr1c_details := lt_tr1c;
    po_tr2l_details := lt_tr2l;
    po_tr2c_details := lt_tr2c;
    po_tr3l_details := lt_tr3l;
    po_tr3c_details := lt_tr3c;    
    po_spee_details := lt_spee;
    po_trt_details  := lt_trt;
    --
  END get_asset;  
  --
  -----------------------------------------------------------------------------
  --  
  FUNCTION get_locations(pi_asset_id IN nm_members_all.nm_ne_id_in%TYPE
                        ,pi_lvm_id   IN nem_lvms.nlvm_id%TYPE)
    RETURN location_tab IS
    --
    lv_cursor             sys_refcursor;
    --
    lt_active_lvm  nem_lvm_api.lvm_id_tab;
    lt_locations   location_tab;
    --
  BEGIN
    --
    lt_active_lvm(1) := pi_lvm_id;
    --
    nem_lvm_api.get_locations_for_display(pi_iit_ne_id      => pi_asset_id
                                         ,pi_active_lvm_ids => lt_active_lvm
                                         ,po_cursor         => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_locations;
    CLOSE lv_cursor;
    --
    RETURN lt_locations;
    --
  END get_locations;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE remove_duplicate_sects(po_locations IN OUT location_tab)
    IS
    --
    lv_found  BOOLEAN;
    --
    lt_retval  location_tab;
    --
  BEGIN
    --
    FOR i IN 1..po_locations.COUNT LOOP
      --
      lv_found := FALSE;
      --
      FOR j IN 1..lt_retval.COUNT LOOP
        --
        IF lt_retval(j).element_id = po_locations(i).element_id
         THEN
            lv_found := TRUE;
            EXIT;
        END IF;
        --
      END LOOP;
      --
      IF NOT lv_found
       THEN
          lt_retval(lt_retval.COUNT+1) := po_locations(i);
      END IF;
      --
    END LOOP;
    --
    po_locations := lt_retval;
    --
  END remove_duplicate_sects;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE add_value(pi_text    IN     VARCHAR2
                     ,pi_tab     IN OUT NOCOPY nm3type.tab_varchar32767)
    IS
  BEGIN  
    --
    pi_tab(pi_tab.COUNT+1) := pi_text;
    --
  END add_value;  
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE add_line(pi_text    IN OUT    VARCHAR2
                    ,pi_tab     IN OUT NOCOPY nm3type.tab_varchar32767)
    IS
  BEGIN  
    --
    pi_tab(pi_tab.COUNT+1) := pi_text;
    pi_text :='';
    --
  END add_line;    
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE update_queue_file_success(pi_dcmq_id    IN NUMBER)
    IS
  BEGIN  
    --
    UPDATE nem_dcm_queue
       SET dcmq_file_success = 'Y'
     WHERE dcmq_id = pi_dcmq_id;
    --
  END update_queue_file_success; 
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE update_queue_ftp_success(pi_dcmq_id    IN NUMBER)
    IS
  BEGIN  
    --
    UPDATE nem_dcm_queue
       SET dcmq_ftp_success = 'Y'
     WHERE dcmq_id = pi_dcmq_id;
    --
  END update_queue_ftp_success;  
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_diversion_quality(pi_diversion_current    IN OUT VARCHAR2
                                 ,pi_diversion_new        IN VARCHAR2)
    IS
      lv_current_rank NUMBER;
      lv_new_rank     NUMBER;
  BEGIN  
    --
    SELECT dcm_rank
      INTO lv_current_rank
      FROM nem_dcm_diversion_quality_map
     WHERE dcm_meaning = pi_diversion_current;
    --
    SELECT dcm_rank
      INTO lv_new_rank
      FROM nem_dcm_diversion_quality_map
     WHERE dcm_meaning = pi_diversion_new;    
    --
    IF lv_new_rank < lv_current_rank THEN
      pi_diversion_current := pi_diversion_new;
    END IF;
    --
  END set_diversion_quality;   
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE update_queue_complete(pi_dcmq    IN nem_dcm_queue%ROWTYPE)
    IS
      lv_summary_result nem_action_executions.naex_summary_result%TYPE;
      lv_execution_id   nem_action_executions.naex_id%TYPE;
      lv_error_flag nm3type.max_varchar2;
      lv_error_text       nm3type.max_varchar2;
      --
  BEGIN  
    --
   
    SELECT naex_summary_result
      INTO lv_summary_result
      FROM nem_action_executions
     WHERE naex_id = pi_dcmq.dcmq_naex_id; 
    --     
    lv_execution_id := nem_execution_api.start_execution(pi_parent_execution_id => pi_dcmq.dcmq_naex_id);
    --      
    nem_execution_api.update_action_executions(pi_naex_id                => pi_dcmq.dcmq_naex_id
                                              ,pi_old_success            => 'Yes'
                                              ,pi_new_success            => 'Yes'
                                              ,pi_old_summary_result     => lv_summary_result
                                              ,pi_new_summary_result     => 'Submitted to DCM, awaiting results'
                                              ,pi_commit                 => 'Y'
                                              ,po_error_flag             => lv_error_flag
                                              ,po_error_text             => lv_error_text);       
    --
    DELETE FROM  nem_dcm_queue
     WHERE dcmq_id = pi_dcmq.dcmq_id; 
    --
  EXCEPTION
    WHEN others THEN
      raise_application_error(-20001,'Unable to match DCM Results with an Action:'||pi_dcmq.dcmq_naex_id);
  END update_queue_complete;    
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE append_value(pi_text    IN     VARCHAR2
                        ,pi_type    IN     VARCHAR2 
                        ,pi_length  IN     NUMBER
                        ,pi_output  IN OUT NOCOPY VARCHAR2)
    IS
  BEGIN  
    --
    CASE pi_type
      WHEN 'A' THEN
        pi_output := pi_output || RPAD(pi_text,pi_length);
      WHEN 'I' THEN
        pi_output := pi_output || LPAD(pi_text,pi_length);
      WHEN 'F' THEN
        CASE pi_length
          WHEN 12.3 THEN         
            pi_output := pi_output || LPAD(TO_CHAR(pi_text,'FM99999990.000'),12);            
          WHEN 8.2 THEN
            pi_output := pi_output || TO_CHAR(pi_text,'FM99990.00');  
        END CASE;
    END CASE;
    --
  END append_value;    
  --
  -----------------------------------------------------------------------------
  --  
 PROCEDURE upload_files(pi_ftp_details IN ftp_con_rec
                        ,pi_file IN VARCHAR2)
    IS
    --
    lv_conn  utl_tcp.connection;
    --
  BEGIN   
    --
    IF SYS_CONTEXT('NM3SQL','NM3FTPPASSWORD') = 'N' or sys_context('NM3SQL','NM3FTPPASSWORD') IS NULL THEN
      nm3ctx.set_context('NM3FTPPASSWORD','Y');
    END IF;
    --    
    IF pi_ftp_details.conn_id IS NOT NULL
     THEN
       lv_conn := nm3ftp.login(p_host => pi_ftp_details.hostname
                              ,p_port => pi_ftp_details.port
                              ,p_user => pi_ftp_details.username
                              ,p_pass => nm3ftp.get_password(pi_ftp_details.password));
      /*
      ||Upload the file.
      ||Dont send as ascii as it was stripping CR from file even though it was Windows box.
      */
      -- nm3ftp.ascii(p_conn => lv_conn);
      nm3ftp.put(p_conn      => lv_conn
                ,p_from_dir  => c_dcm_export_dir
                ,p_from_file => pi_file
                ,p_to_file   => pi_ftp_details.out_dir||pi_file||'$');
      --            
      nm3ftp.rename(p_conn => lv_conn
                   ,p_from => pi_ftp_details.out_dir||pi_file||'$'
                   ,p_to   => pi_ftp_details.out_dir||pi_file);
      --     
      /*
      ||Close FTP Connection.
      */
      nm3ftp.logout(p_conn => lv_conn);
      --
    END IF;
    --
  EXCEPTION
    WHEN others THEN
      --
      process_log_entry(pi_message => '--------------------------------------------------------');         
      process_log_entry(pi_message => 'Error uploading File'||sqlerrm);    
      --      
  END upload_files;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_edate(pi_actual_complete_date  IN     DATE --null
                     ,pi_actual_start_date     IN     DATE --27/07/2016 00:00
                     ,pi_planned_complete_date IN     DATE --06/06/2016 13:00
                     ,pi_planned_start_date    IN     DATE --06/06/2016 04:00
                     ,po_end_date              IN OUT DATE)
    IS
    --
  BEGIN
    /*
    ||SRW had no concept of Actual and Planned dates so derive the End Date to send.
    */
    IF pi_actual_complete_date IS NOT NULL
     THEN
        po_end_date := pi_actual_complete_date;
    ELSE
        IF pi_actual_start_date IS NOT NULL
         AND pi_actual_start_date > pi_planned_complete_date
         THEN
            po_end_date := pi_actual_start_date + (pi_planned_complete_date - pi_planned_start_date);
        ELSE
            po_end_date := pi_planned_complete_date;
        END IF;
    END IF;
    --
  END set_edate;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_lane_status(pi_nem_code IN nem_dcm_lane_status_map.nem_code%TYPE)
    RETURN nem_dcm_lane_status_map.dcm_meaning%TYPE IS
    --
    lv_retval  nem_dcm_lane_status_map.dcm_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_lane_status_map.COUNT LOOP
      --
      IF g_lane_status_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_lane_status_map(i).dcm_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Lane Status Code ['||pi_nem_code||'] to an DCM value, please add a valid translation to the table NEM_DCM_LANE_STATUS_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_lane_status;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_event_in_dcm_format(pi_events   IN nem_event_tab) 
   RETURN nm3type.tab_varchar32767 IS
    lt_output              nm3type.tab_varchar32767;
    lt_sections_output     nm3type.tab_varchar32767;
    lt_component_output    nm3type.tab_varchar32767;
    lt_layout_output       nm3type.tab_varchar32767;
    lt_lanes_output        nm3type.tab_varchar32767;
    lt_diaries             nigs_diary_tab;
    lt_diary_output        nm3type.tab_varchar32767;
    --
    lt_impacted_network    location_tab;
    lt_group_locations     location_tab ;
    lt_diqu                diqu_asset_tab;
    lt_spee                spee_asset_tab;
    lt_tr1l                tr1_asset_tab;
    lt_tr1c                tr1_asset_tab;
    lt_tr2l                tr2_asset_tab;
    lt_tr2c                tr2_asset_tab;
    lt_tr3l                tr3_asset_tab;    
    lt_tr3c                tr3_asset_tab;
    lt_trt                 trt_asset_tab;
    --
    lv_lvm_id                 nem_lvms.nlvm_id%TYPE := get_lvm;
    lv_edate                  DATE;
    lv_extra_notes            VARCHAR2(500);
    lv_dummy                  VARCHAR2(500);
    lv_lane_action            CHAR(1);
    lv_number_of_lanes        INT;
    lv_total_number_of_lanes  INT;
    lv_header_line            VARCHAR2(4000);
    lv_section_line           VARCHAR2(4000);
    lv_component_line         VARCHAR2(4000);
    lv_lanes_line             VARCHAR2(4000);
    lv_diary_line             VARCHAR2(4000);    
    lv_layout_line            VARCHAR2(4000);   
    lv_speedlimit_line        VARCHAR2(4000);      
    lv_traffic_cnt_line       VARCHAR2(4000);
    lv_day_traffic_cnt_line   VARCHAR2(4000);           
    lv_diversion_quality      VARCHAR2(50);
    lv_width_restriction      VARCHAR2(1);
    lv_schedule_cnt           INT := 0;
    --                   
    lr_lowest_limit          speed_limit_rec;
    lr_traffic_man           traffic_man_rec;
    lr_section_rec           section_rec;
    --
    /* Hard coded for HE network */
    CURSOR get_sections_info(cp_ne_id nm_elements.ne_id%TYPE)
        IS
    SELECT ne_unique section_label
          ,nm3net.get_ne_length(ne_id) section_length
          ,iit_num_attrib22 number_of_lanes
          ,ne_sub_class     road_type
          ,iit_chr_attrib57 section_function
          ,iit_chr_attrib27 single_or_dual
          ,iit_chr_attrib41 environment
          ,NVL(iit_chr_attrib69,'N/S') diversion_quality
          ,'N' psa_rout /* PB TODO As far as I know we don't do PSA Routes */
      FROM nm_inv_items
          ,nm_nw_ad_link
          ,nm_elements
     WHERE ne_id = cp_ne_id
       AND ne_id = nad_ne_id
       AND nad_primary_ad = 'Y'
       AND nad_iit_ne_id = iit_ne_id
    ;
    /* 
    ||Hard coded for HE network 
    */
    CURSOR get_total_number_of_lanes(cp_ne_id nm_elements.ne_id%TYPE)
        IS
    SELECT sum(iit_num_attrib22) number_of_lanes
      FROM nm_inv_items
          ,nm_nw_ad_link
          ,nm_elements
    WHERE ne_id IN(SELECT rm.nm_ne_id_in
                      FROM nm_members rm
                     WHERE nm_obj_type = 'SECT'
                       AND rm.nm_ne_id_of IN(SELECT im.nm_ne_id_of
                                               FROM nm_members im
                                              WHERE im.nm_ne_id_in = cp_ne_id))
       AND ne_id = nad_ne_id
       AND nad_primary_ad = 'Y'
       AND nad_iit_ne_id = iit_ne_id
    ;
    --
    /*
    ||Included No impact group as to allow contiguous Schedules as per NL  
    ||"There need to be contiguous diary records covering the entire period from the closure start date to the closure end date. 
    ||In SRW there is always a “No traffic management” layout which is used (if needed) to fill in between other layouts.  
    ||If you do not have an equivalent in NOMS, you will need to generate it for the DCM input."
    */
    --    
    CURSOR get_impact_groups(cp_nevt_id nem_events.nevt_id%TYPE)
        IS
    SELECT *
      FROM nem_impact_groups
     WHERE nig_nevt_id = cp_nevt_id
       --AND nig_name != nem_util.get_no_impact_group_name
         ;
    --
    TYPE nig_tab IS TABLE OF nem_impact_groups%ROWTYPE;
    lt_nig  nig_tab;
    --
    CURSOR get_schedules(cp_nig_id nem_impact_groups.nig_id%TYPE)
        IS
    SELECT *
      FROM nem_impact_group_schedules
     WHERE nigs_nig_id = cp_nig_id
       AND nigs_cancel_date IS NULL
         ;
    --
    CURSOR get_all_schedules(cp_nevt_id nem_events.nevt_id%TYPE)
        IS
    SELECT nig_name
          ,nigs_planned_startdate
          ,nigs_actual_startdate
          ,nigs_planned_enddate
          ,nigs_actual_enddate
      FROM nem_impact_groups
          ,nem_impact_group_schedules
     WHERE nig_nevt_id = cp_nevt_id
       AND nig_id = nigs_nig_id
       AND nigs_cancel_date IS NULL
      ORDER BY nvl(nigs_actual_startdate,nigs_planned_startdate),nvl(nigs_actual_enddate,nigs_planned_enddate)
         ;       
    --
    TYPE nigs_tab IS TABLE OF nem_impact_group_schedules%ROWTYPE;
    lt_nigs  nigs_tab;
    --
    CURSOR get_xsps(cp_nig_id nem_impact_groups.nig_id%TYPE)
        IS
    SELECT *
      FROM nem_impact_group_xsps
     WHERE nigx_nig_id = cp_nig_id
         ;
    --
    TYPE nigx_tab IS TABLE OF nem_impact_group_xsps%ROWTYPE;
    lt_nigx  nigx_tab;
    --   
  BEGIN
    --
    FOR i IN 1..pi_events.COUNT LOOP
      --
      /*
      ||Init variables.
      */
      lv_edate := NULL;
      lr_lowest_limit := NULL;
      lr_traffic_man := NULL;
      lv_extra_notes := NULL;
      lt_output.DELETE;
      lt_sections_output.DELETE;
      lt_component_output.DELETE;
      lt_layout_output.DELETE;
      lt_lanes_output.DELETE;
      /*
      ||Get the components (Impacted Network).
      */
      lt_impacted_network := get_locations(pi_asset_id => pi_events(i).nevt_id
                                          ,pi_lvm_id   => lv_lvm_id);
      --
      remove_duplicate_sects(po_locations => lt_impacted_network);
      --
      FOR j IN 1..lt_impacted_network.COUNT LOOP
        --
        OPEN get_sections_info(lt_impacted_network(j).element_id);
        FETCH get_sections_info
        INTO lr_section_rec;
        CLOSE get_sections_info; 
        --
        get_asset(pi_section_label =>  lr_section_rec.section_label
                 ,po_diqu_details  =>  lt_diqu
                 ,po_spee_details  =>  lt_spee     
                 ,po_tr1l_details  =>  lt_tr1l
                 ,po_tr1c_details  =>  lt_tr1c
                 ,po_tr2l_details  =>  lt_tr2l
                 ,po_tr2c_details  =>  lt_tr2c
                 ,po_tr3l_details  =>  lt_tr3l
                 ,po_tr3c_details  =>  lt_tr3c
                 ,po_trt_details   =>  lt_trt);
        --    
        /*
        ||Sections Output
        */
        append_value(pi_text   => lr_section_rec.section_label
                    ,pi_type   => 'A'
                    ,pi_length => 20
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.section_length
                    ,pi_type   => 'F'
                    ,pi_length => 12.3
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.number_of_lanes
                    ,pi_type   => 'I'
                    ,pi_length => 2
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.road_type
                    ,pi_type   => 'A'
                    ,pi_length => 2
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.section_function
                    ,pi_type   => 'A'
                    ,pi_length => 4
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.single_or_dual
                    ,pi_type   => 'A'
                    ,pi_length => 4
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text => lr_section_rec.environment
                    ,pi_type   => 'A'
                    ,pi_length => 1
                    ,pi_output => lv_section_line);        
        --
        /*
        ||PB to do check Ranking order
        ||Make lowest ranked value in nem_dcm_diversion_quality_map table.
        */
        lv_diversion_quality := null;
        FOR i in 1..lt_diqu.COUNT LOOP
          IF lv_diversion_quality IS NULL THEN
            lv_diversion_quality := lt_diqu(i).diversion_quality;
          ELSE
            IF lv_diversion_quality <> lt_diqu(i).diversion_quality THEN
              --lv_diversion_quality := lr_section_rec.diversion_quality;
              set_diversion_quality(pi_diversion_current => lv_diversion_quality
                                   ,pi_diversion_new     => lt_diqu(i).diversion_quality);
            END IF;
          END IF;
        END LOOP;
        --
        /*
        ||pb todo should this be N/S nvl not the section value?
        */
        append_value(pi_text   => nvl(lv_diversion_quality,lr_section_rec.diversion_quality)
                    ,pi_type   => 'A'
                    ,pi_length => 4
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lr_section_rec.psa_rout
                    ,pi_type   => 'A'
                    ,pi_length => 1
                    ,pi_output => lv_section_line);               
        --
        append_value(pi_text   => lt_spee.COUNT
                    ,pi_type   => 'I'
                    ,pi_length => 3
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => nvl(lt_tr1c.COUNT + lt_tr1l.COUNT + lt_tr2c.COUNT + lt_tr2l.COUNT + lt_tr3c.COUNT + lt_tr3l.COUNT,0)
                    ,pi_type   => 'I'
                    ,pi_length => 3
                    ,pi_output => lv_section_line);        
        --
        append_value(pi_text   => lt_trt.COUNT
                    ,pi_type   => 'I'
                    ,pi_length => 3
                    ,pi_output => lv_section_line);      
        --                    
        add_line(pi_text   => lv_section_line
                ,pi_tab    => lt_sections_output);
        /*
        ||Speed Limit Data from SPEE Asset.
        */
        FOR i in 1..lt_spee.COUNT LOOP
          --
          append_value(pi_text   => to_char(lt_spee(i).st_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_speedlimit_line); 
          --                      
          append_value(pi_text   => nvl(to_char(lt_spee(i).end_date,c_datefmt),' ')
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_speedlimit_line);  
          --
          append_value(pi_text   => lt_spee(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_speedlimit_line);
          --
          append_value(pi_text   => lt_spee(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_speedlimit_line);
          --
          append_value(pi_text   => lt_spee(i).speed_limit
                      ,pi_type   => 'I'
                      ,pi_length => 2
                      ,pi_output => lv_speedlimit_line);   
          --
          add_line(pi_text   => lv_speedlimit_line
                  ,pi_tab    => lt_sections_output);
          --                  
        END LOOP;
        /*
        ||Add Traffic Count Data TODO TRT (awaiting data from HB)
        */     
        FOR i in 1..lt_tr1c.COUNT LOOP                  
          append_value(pi_text   => lt_tr1c(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr1c(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr1c(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'C'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 1
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_tr1c(i).cv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_tr1c(i).non_cv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --          
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output);   
          --                  
        END LOOP;  
        --
        FOR i in 1..lt_tr1l.COUNT LOOP                
          append_value(pi_text   => lt_tr1l(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr1l(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr1l(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'L'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 1
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_tr1l(i).cv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_tr1l(i).non_cv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                   
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --               
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output);                                     
          --         
        END LOOP;  
        -- 
        FOR i in 1..lt_tr2c.COUNT LOOP      
          --        
          append_value(pi_text   => lt_tr2c(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr2c(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr2c(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'C'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 2
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2c(i).cars
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2c(i).lgv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2c(i).psv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2c(i).ogv1
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2c(i).ogv2
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);             
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                          
          --        
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output); 
          --        
        END LOOP;  
        --
        FOR i in 1..lt_tr2l.COUNT LOOP             
          append_value(pi_text   => lt_tr2l(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr2l(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr2l(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'L'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 2
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2l(i).cars
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2l(i).lgv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2l(i).psv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2l(i).ogv1
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr2l(i).ogv2
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);             
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --               
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output);
          --                                     
        END LOOP;  
        --  
        FOR i in 1..lt_tr3c.COUNT LOOP             
          append_value(pi_text   => lt_tr3c(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr3c(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr3c(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'C'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 3
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).lgv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).psv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).r2
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).r3
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).a3
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).r4
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).a4
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3c(i).a5
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);             
          --
          append_value(pi_text   => lt_tr3c(i).a6
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --                      
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output);                                     
          --
        END LOOP; 
        --  
        FOR i in 1..lt_tr3l.COUNT LOOP             
          append_value(pi_text   => lt_tr3l(i).from_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);  
          --
          append_value(pi_text   => lt_tr3l(i).to_offset
                      ,pi_type   => 'F'
                      ,pi_length => 12.3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => to_char(lt_tr3l(i).effective_date,c_datefmt)
                      ,pi_type   => 'A'
                      ,pi_length => 11
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 'L'
                      ,pi_type   => 'A'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 3
                      ,pi_type   => 'I'
                      ,pi_length => 1
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => 0
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).lgv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).psv
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).r2
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).r3
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).a3
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).r4
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).a4
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --
          append_value(pi_text   => lt_tr3l(i).a5
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);             
          --
          append_value(pi_text   => lt_tr3l(i).a6
                      ,pi_type   => 'I'
                      ,pi_length => 8
                      ,pi_output => lv_traffic_cnt_line);                    
          --               
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output); 
          --                  
        END LOOP; 
        --
        FOR i in 1..lt_trt.COUNT LOOP             
          --
          append_value(pi_text   => lt_trt(i).day_type
                      ,pi_type   => 'I'
                      ,pi_length => 3
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_00_01
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_01_02
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_02_03
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_03_04
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_04_05
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_05_06
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_06_07
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_07_08
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_08_09
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_09_10
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --          
          append_value(pi_text   => lt_trt(i).tf_10_11
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_11_12
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_12_13
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_13_14
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_14_15
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_15_16
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_16_17
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_17_18
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_18_19
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_19_20
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_20_21
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --          
          append_value(pi_text   => lt_trt(i).tf_21_22
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_22_23
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line);
          --
          append_value(pi_text   => lt_trt(i).tf_23_24
                      ,pi_type   => 'F'
                      ,pi_length => 8.2
                      ,pi_output => lv_traffic_cnt_line); 
          --               
          add_line(pi_text   => lv_traffic_cnt_line
                  ,pi_tab    => lt_sections_output); 
          --                  
        END LOOP;        
        /*
        ||Component Output:
        ||This is split from Impact Groups into individual Sections
        ||to get around the issues re TRL needing linear components.
        */
        append_value(pi_text   => lt_impacted_network(j).element_unique
                    ,pi_type   => 'A'
                    ,pi_length => 50
                    ,pi_output => lv_component_line);        
        /*
        ||This will be 1 each time as we split to section level for linearity.
        */ 
        append_value(pi_text   => 1
                    ,pi_type   => 'I'
                    ,pi_length =>  3
                    ,pi_output => lv_component_line);      
        --        
        add_line(pi_text   => lv_component_line
                ,pi_tab    => lt_component_output);                
        /*
        ||Always 0 as start of each section.
        */            
        append_value(pi_text   => 0
                    ,pi_type   => 'F'
                    ,pi_length =>  12.3
                    ,pi_output => lv_component_line);
        --
        append_value(pi_text   => lt_impacted_network(j).element_length
                     ,pi_type  => 'F'
                    ,pi_length => 12.3
                    ,pi_output => lv_component_line);
        --
        append_value(pi_text   => lt_impacted_network(j).element_unique
                    ,pi_type   => 'A'
                    ,pi_length =>  20
                    ,pi_output => lv_component_line);
        --
        append_value(pi_text   => lt_impacted_network(j).from_offset
                    ,pi_type   => 'F'
                    ,pi_length =>  12.3
                    ,pi_output => lv_component_line);
        --
        append_value(pi_text   => lt_impacted_network(j).to_offset
                    ,pi_type   => 'F'
                    ,pi_length =>  12.3
                    ,pi_output => lv_component_line);
        --        
        add_line(pi_text   => lv_component_line
                 ,pi_tab   => lt_component_output);                              
        --
      END LOOP;
      --
      /*
      ||Get the Impact Group Contents.
      */
      OPEN  get_impact_groups(pi_events(i).nevt_id);
      FETCH get_impact_groups
       BULK COLLECT
       INTO lt_nig;
      CLOSE get_impact_groups;
      --
      FOR j IN 1..lt_nig.COUNT LOOP
        --
        lt_lanes_output.DELETE;
        /*
        ||Check the speed limit.
        */
        IF lt_nig(j).nig_speed_limit IS NOT NULL
         THEN
            set_speed_limit(pi_speed_limit  => lt_nig(j).nig_speed_limit
                           ,pi_level        => c_impact_group_level
                           ,po_lowest_limit => lr_lowest_limit);
        END IF;
        /*
        ||Get the Group Locations.
        */
        lt_group_locations := get_locations(pi_asset_id => lt_nig(j).nig_id
                                           ,pi_lvm_id   => lv_lvm_id);
        --
        OPEN  get_xsps(lt_nig(j).nig_id);
        FETCH get_xsps
         BULK COLLECT
         INTO lt_nigx;
        CLOSE get_xsps;     
        --
        OPEN  get_total_number_of_lanes(lt_nig(j).nig_id);
        FETCH get_total_number_of_lanes
         INTO lv_total_number_of_lanes;
        CLOSE get_total_number_of_lanes;    
        --        
        FOR k IN 1..lt_group_locations.COUNT LOOP
          --
          OPEN  get_total_number_of_lanes(lt_group_locations(k).element_id);
          FETCH get_total_number_of_lanes
           INTO lv_number_of_lanes;
          CLOSE get_total_number_of_lanes;          
          /*
          ||If Carriageway closure is set at Impact Group Level 
          ||Make all Lanes Closed
          */
          lv_width_restriction := null;
          --
          IF lt_nig(j).nig_carriageway_closure = 'Y' THEN              
            FOR i in 1..lv_number_of_lanes LOOP
              --             
              append_value(pi_text   => lt_group_locations(k).element_unique
                          ,pi_type   => 'A'
                          ,pi_length =>  50
                          ,pi_output => lv_lanes_line);
              --
              append_value(pi_text   => lt_group_locations(k).from_offset
                          ,pi_type   => 'F'
                          ,pi_length =>  12.3
                          ,pi_output => lv_lanes_line);                    
              --
              append_value(pi_text   => lt_group_locations(k).to_offset
                          ,pi_type   => 'F'
                          ,pi_length =>  12.3
                          ,pi_output => lv_lanes_line);
              /*
              || Default to Closed if Carriageway Closure is Yes
              */
              append_value(pi_text    => 1
                           ,pi_type   => 'I'
                           ,pi_length => 1
                           ,pi_output => lv_lanes_line);
              --                 
              add_line(pi_text   => lv_lanes_line
                       ,pi_tab   => lt_lanes_output);                         
              --                
            END LOOP;                        
          ELSE
             FOR i IN 1..lt_nigx.COUNT LOOP
               --
               lv_lane_action := get_lane_status(lt_nigx(i).nigx_reason);        
               --   
               append_value(pi_text   => lt_group_locations(k).element_unique
                           ,pi_type   => 'A'
                           ,pi_length =>  50
                           ,pi_output => lv_lanes_line);
               --
               append_value(pi_text   => lt_group_locations(k).from_offset
                           ,pi_type   => 'F'
                           ,pi_length =>  12.3
                           ,pi_output => lv_lanes_line);
               --
               append_value(pi_text   => lt_group_locations(k).to_offset
                           ,pi_type   => 'F'
                           ,pi_length =>  12.3
                           ,pi_output => lv_lanes_line);
               --
               /*
               || As Per LJ/HE.  If an impact group has a 'Width Restrict' value of ‘Yes’ or any 'Impact Change' within the impact group has a 'Change' value of 'NARROW'
               ||Then data sent to DCM should provide
               ||- 'Narrow Lanes' value of 'Y' for B4.1
               ||- 'Lane Action' value of 2 = 'Opened' where the NEM Impact Change value is 'NARROW' for B4.2
               */
               IF lv_width_restriction IS NULL AND lv_lane_action = 2 THEN
                 lv_width_restriction := 'Y';
               END IF;
               --
               append_value(pi_text   => lv_lane_action
                           ,pi_type   => 'I'
                           ,pi_length =>  1
                           ,pi_output => lv_lanes_line);                       
               --       
               add_line(pi_text   =>  lv_lanes_line
                        ,pi_tab   => lt_lanes_output);                        
               --
            END LOOP;
          END IF;
          --
        END LOOP;
        --
        /*
        ||Get the schedules/diary entries
        */
        OPEN  get_schedules(lt_nig(j).nig_id);
        FETCH get_schedules
         BULK COLLECT
         INTO lt_nigs;
        CLOSE get_schedules;
        --
        lv_schedule_cnt := nvl(lv_schedule_cnt,0) + lt_nigs.COUNT;       
        --
        FOR k IN 1..lt_nigs.COUNT LOOP
          /*
          ||Check the speed limit.
          */
          IF lt_nigs(k).nigs_speed_limit IS NOT NULL
           THEN
              set_speed_limit(pi_speed_limit  => lt_nigs(k).nigs_speed_limit
                             ,pi_level        => c_schedule_level
                             ,po_lowest_limit => lr_lowest_limit);
          END IF;
          --
          lv_dummy := NULL;
          --
          set_edate(pi_actual_complete_date  => lt_nigs(k).nigs_actual_enddate
                   ,pi_actual_start_date     => lt_nigs(k).nigs_actual_startdate
                   ,pi_planned_complete_date => lt_nigs(k).nigs_planned_enddate
                   ,pi_planned_start_date    => lt_nigs(k).nigs_planned_startdate
                   ,po_end_date              => lv_edate);
          --
          /*append_value(pi_text   => TO_CHAR(NVL(lt_nigs(k).nigs_actual_startdate,lt_nigs(k).nigs_planned_startdate),c_datetimefmt)
                      ,pi_type   => 'A'
                      ,pi_length =>  20
                      ,pi_output => lv_diary_line);    
          --
          append_value(pi_text   => TO_CHAR(lv_edate,c_datetimefmt)
                      ,pi_type   => 'A'
                      ,pi_length =>  20
                      ,pi_output => lv_diary_line); 
          --           
          append_value(pi_text   => lt_nig(j).nig_name
                      ,pi_type   => 'A'
                      ,pi_length =>  50
                      ,pi_output => lv_diary_line);               
          --
          add_line(pi_text   => lv_diary_line
                   ,pi_tab   => lt_diary_output);   */       
          --
        END LOOP; --schedules
        --
        /*
        ||Layouts Output:
        */
        append_value(pi_text    => lt_nig(j).nig_name
                    ,pi_type   => 'A'
                    ,pi_length =>  50
                    ,pi_output => lv_layout_line);                   
        --
        append_value(pi_text    => lr_lowest_limit.dcm_meaning
                    ,pi_type   => 'I'
                    ,pi_length =>  2
                    ,pi_output => lv_layout_line);
        --  
        append_value(pi_text    => lr_lowest_limit.dcm_enforced_at_all_times
                    ,pi_type   => 'A'
                    ,pi_length =>  1
                    ,pi_output => lv_layout_line);
        --
        append_value(pi_text    => nvl(lv_width_restriction,lt_nig(j).nig_width_restriction)
                    ,pi_type   => 'A'
                    ,pi_length =>  1
                    ,pi_output => lv_layout_line);
        /*
        ||If Carriageway closure is Yes then use total number of lanes on section.
        ||otherwise count number of XSP records from Event Closure
        */
        IF lt_nig(j).nig_carriageway_closure = 'Y' THEN
          append_value(pi_text    => lv_total_number_of_lanes
                      ,pi_type   => 'I'
                      ,pi_length =>  3
                      ,pi_output => lv_layout_line);            
        ELSE
          append_value(pi_text    => (lt_nigx.COUNT*lt_group_locations.COUNT)
                      ,pi_type   => 'I'
                      ,pi_length =>  3
                      ,pi_output => lv_layout_line);   
        END IF;
        --
        add_line(pi_text   =>  lv_layout_line
                 ,pi_tab    => lt_layout_output);                     
        /*
        ||Add Lanes information for each Impact Group
        */
        FOR j IN 1..lt_lanes_output.COUNT LOOP
          --                 
          add_value(pi_text   => lt_lanes_output(j)
                   ,pi_tab    => lt_layout_output);               
          --
        END LOOP;                 
        --
        set_traffic_management(pi_nig_rec             => lt_nig(j)
                              ,pi_speed_limit         => lr_lowest_limit.dcm_meaning
                              ,pi_mobile_lane_closure => pi_events(i).mobile_lane_closure
                              ,po_traffic_management  => lr_traffic_man);
        --
      END LOOP; -- Impact Groups.
      /*
      ||"Header" Data
      */
      append_value(pi_text   => 'C'
                  ,pi_type   => 'A'
                  ,pi_length =>  1
                  ,pi_output => lv_header_line);             
      --
      append_value(pi_text   => TO_CHAR(NVL(pi_events(i).actual_start_date,pi_events(i).planned_start_date),c_datetimefmt)
                  ,pi_type   => 'A'
                  ,pi_length =>  20
                  ,pi_output => lv_header_line);
      --
      set_edate(pi_actual_complete_date  => pi_events(i).actual_complete_date
               ,pi_actual_start_date     => pi_events(i).actual_start_date
               ,pi_planned_complete_date => pi_events(i).planned_complete_date
               ,pi_planned_start_date    => pi_events(i).planned_start_date
               ,po_end_date              => lv_edate);      
      --             
      append_value(pi_text   => TO_CHAR(lv_edate,c_datetimefmt)
                  ,pi_type   => 'A'
                  ,pi_length =>  20
                  ,pi_output => lv_header_line);  
      --
      append_value(pi_text   => '2'
                  ,pi_type   => 'I'
                  ,pi_length =>  1
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => lr_traffic_man.traffic_value
                  ,pi_type   => 'I'
                  ,pi_length =>  2
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => '0'
                  ,pi_type   => 'I'
                  ,pi_length =>  2
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => 'N'
                  ,pi_type   => 'A'
                  ,pi_length =>  1
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => 'N'
                  ,pi_type   => 'A'
                  ,pi_length =>  1
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => '0'
                  ,pi_type   => 'I'
                  ,pi_length =>  2
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => '0'
                  ,pi_type   => 'I'
                  ,pi_length =>  2
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => lt_impacted_network.COUNT
                  ,pi_type   => 'I'
                  ,pi_length =>  5
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => lt_impacted_network.COUNT
                  ,pi_type   => 'I'
                  ,pi_length =>  5
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => lt_nig.COUNT
                  ,pi_type   => 'I'
                  ,pi_length =>  5
                  ,pi_output => lv_header_line);    
      --
      append_value(pi_text   => lv_schedule_cnt
                  ,pi_type   => 'I'
                  ,pi_length =>  5
                  ,pi_output => lv_header_line);   
      add_line(pi_text   =>  lv_header_line 
              ,pi_tab    => lt_output);   
    --             
     /*
     ||4. DCM requires a consistent set of dates/times be they planned (for an event yet to happen) or actual (for an event that has started).  
     ||E.g. If an event has started, the “Event start date/ time” on record B1.1 should be the actual start date/time, 
     ||as should the “Start date / time” on the first Diary record (B5.1).
     */    
     --     
     OPEN get_all_schedules(pi_events(i).nevt_id);
    FETCH get_all_schedules
     BULK COLLECT
     INTO lt_diaries;
    CLOSE get_all_schedules;
    --
    FOR k IN 1..lt_diaries.COUNT LOOP
    
      append_value(pi_text   => TO_CHAR(NVL(lt_diaries(k).nigs_actual_startdate,lt_diaries(k).nigs_planned_startdate),c_datetimefmt)
                  ,pi_type   => 'A'
                  ,pi_length =>  20
                  ,pi_output => lv_diary_line);    
      --
      set_edate(pi_actual_complete_date  => lt_diaries(k).nigs_actual_enddate
               ,pi_actual_start_date     => lt_diaries(k).nigs_actual_startdate
               ,pi_planned_complete_date => lt_diaries(k).nigs_planned_enddate
               ,pi_planned_start_date    => lt_diaries(k).nigs_planned_startdate
               ,po_end_date              => lv_edate);
      --                   
      append_value(pi_text   => TO_CHAR(lv_edate,c_datetimefmt)
                  ,pi_type   => 'A'
                  ,pi_length =>  20
                  ,pi_output => lv_diary_line); 
      --           
      append_value(pi_text   => lt_diaries(k).nig_name
                  ,pi_type   => 'A'
                  ,pi_length =>  50
                  ,pi_output => lv_diary_line);               
      --
      add_line(pi_text   => lv_diary_line
               ,pi_tab   => lt_diary_output);   
      --      
    END LOOP;
    --
    END LOOP; -- Events.    
    /*
    ||Add the Sections.
    */ 
    FOR j IN 1..lt_sections_output.COUNT LOOP
      --                 
      add_value(pi_text   => lt_sections_output(j)
               ,pi_tab    => lt_output);               
      --
    END LOOP; 
    --    
    FOR k IN 1..lt_component_output.COUNT LOOP
      --                 
      add_value(pi_text   => lt_component_output(k)
               ,pi_tab    => lt_output);
      --
    END LOOP;     
    --
    FOR l IN 1..lt_layout_output.COUNT LOOP
      --                 
      add_value(pi_text   => lt_layout_output(l)
               ,pi_tab    => lt_output);
      --
    END LOOP;   
    --
    FOR m IN 1..lt_diary_output.COUNT LOOP
      --                 
      add_value(pi_text   => lt_diary_output(m)
               ,pi_tab    => lt_output);
      --
    END LOOP;          
    -- 
    RETURN lt_output;
  END get_event_in_dcm_format;
--
-----------------------------------------------------------------------------
--
  PROCEDURE log_loaded_results (pi_dcmh_id     nem_dcm_result.dcmr_id%TYPE
                               ,pi_naex        nem_action_executions%ROWTYPE
                               ,pi_error_count nem_dcm_header.dcmh_number_of_errors%TYPE)
    IS
    --
    lv_error_flag       nm3type.max_varchar2;
    lv_error_text       nm3type.max_varchar2;
    lv_execution_id     PLS_INTEGER;
    --
    TYPE nem_dcm_error_tab IS TABLE OF nem_dcm_error%ROWTYPE INDEX BY BINARY_INTEGER;    
    lt_dcme             nem_dcm_error_tab;
    --    
    lr_dcmr nem_dcm_result%ROWTYPE;    
    --
    CURSOR get_dcmr 
        IS
    SELECT *
      FROM nem_dcm_result
     WHERE dcmr_dcmh_id = pi_dcmh_id    
     ; 
     --
    CURSOR get_dcme 
        IS
    SELECT *
      FROM nem_dcm_error
     WHERE dcme_dcmh_id = pi_dcmh_id    
     ;     
     --
  BEGIN
   /*
   ||Get DCM Results
   */
    OPEN get_dcmr;
   FETCH get_dcmr
    INTO lr_dcmr;
   CLOSE get_dcmr;  
    /*
    ||Start an execution for logging.
    */
    lv_execution_id := nem_execution_api.start_execution(pi_parent_execution_id => pi_naex.naex_id);
    --      
    IF nvl(pi_error_count,0) > 0 THEN
      --     
       OPEN get_dcme;
      FETCH get_dcme
       BULK COLLECT
       INTO lt_dcme;
      CLOSE get_dcme;     
      --
        nem_execution_api.update_action_executions(pi_naex_id                => pi_naex.naex_id
                                                  ,pi_old_success            => 'Yes'
                                                  ,pi_new_success            => 'Yes'
                                                  ,pi_old_summary_result     => pi_naex.naex_summary_result
                                                  ,pi_new_summary_result     => 'DCM results returned with errors'
                                                  ,pi_commit                 => 'Y'
                                                  ,po_error_flag             => lv_error_flag
                                                  ,po_error_text             => lv_error_text);
        --
        FOR i in 1..lt_dcme.COUNT LOOP
          nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                                 ,pi_message_category => 'INFORMATION'
                                                 ,pi_message          => lt_dcme(i).dcme_error
                                                 ,po_error_flag       => lv_error_flag
                                                 ,po_error_text       => lv_error_text);    
        END LOOP;
        --
    ELSE
      nem_execution_api.update_action_executions(pi_naex_id                => pi_naex.naex_id
                                                ,pi_old_success            => 'Yes'
                                                ,pi_new_success            => 'Yes'
                                                ,pi_old_summary_result     => pi_naex.naex_summary_result
                                                ,pi_new_summary_result     => 'DCM results calculated successfully'
                                                ,pi_commit                 => 'Y'
                                                ,po_error_flag             => lv_error_flag
                                                ,po_error_text             => lv_error_text);                                                
      --     
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'Total Delay Time: '||lr_dcmr.dcmr_total_delay_time
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text);
      --
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'Total Delay Cost: '||lr_dcmr.dcmr_total_delay_cost
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text);
      --
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'Total Vehicles: '||lr_dcmr.dcmr_total_vehicles
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text);
      --
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'PSA Delay Time: '||lr_dcmr.dcmr_psa_delay_time
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text);
      --
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'PSA Delay Cost: '||lr_dcmr.dcmr_psa_delay_cost
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text);      
      --
      nem_execution_api.add_action_exe_result(pi_naex_id          => pi_naex.naex_id
                                             ,pi_message_category => 'INFORMATION'
                                             ,pi_message          => 'PSA Vehicles: '||lr_dcmr.dcmr_psa_vehicles
                                             ,po_error_flag       => lv_error_flag
                                             ,po_error_text       => lv_error_text); 
      --
    END IF;
    --
    IF lv_error_flag = 'N'
     THEN
        COMMIT;
    ELSE
        nem_actions_api.add_message(1,lv_error_text);
    END IF;
    --
  EXCEPTION
    WHEN others
     THEN
        nem_actions_api.add_message(1,SQLERRM);
  END log_loaded_results;
  --
  -----------------------------------------------------------------------------
  --    
  PROCEDURE export_event_for_dcm(pi_dcmq IN nem_dcm_queue%ROWTYPE)
    IS
    --
    lt_events  nem_event_tab;
    lt_output  nm3type.tab_varchar32767;
    --
    lv_sql nm3type.max_varchar2;
    lv_error VARCHAR2(1) DEFAULT 'N';
    --
    lr_ftp ftp_con_rec;
    --
    c_event  sys_refcursor;
    --
  BEGIN
    --
    process_log_entry(pi_message => 'Running DCM Export Version: '||get_body_version);    
    init_lookups;
    lv_sql := gen_get_events_sql
    ||CHR(10)||'   AND iit_ne_id = :nevt_id';
    --
    process_log_entry(pi_message => '--------------------------------------------------------');         
    process_log_entry(pi_message => 'Exporting Event: '||pi_dcmq.dcmq_nevt_id||' Action ID:'||pi_dcmq.dcmq_naex_id);
    --    
    IF pi_dcmq.dcmq_file_success = 'N' THEN
      OPEN  c_event FOR lv_sql USING pi_dcmq.dcmq_nevt_id;
      FETCH c_event
       BULK COLLECT
       INTO lt_events
          ;
      CLOSE c_event;
      --     
      process_log_entry(pi_message => 'Converting event into DCM File Format');  
      --      
      lt_output := get_event_in_dcm_format(pi_events => lt_events);
      IF lt_output.COUNT = 0 THEN       
        lv_error := 'Y';
        process_log_entry(pi_message      => 'There was a problem converting the event'
                         ,pi_message_type => 'E');      
      END IF;
      /*
      || write_file to directory.
      */                
      nm3file.write_file(location     => c_dcm_export_dir
                        ,filename     => pi_dcmq.dcmq_nevt_id||'_'||pi_dcmq.dcmq_naex_id||'.dcminput'
                        ,all_lines    => lt_output);          
      --
      update_queue_file_success(pi_dcmq_id => pi_dcmq.dcmq_id);
      --
      process_log_entry(pi_message => 'DCM Export File Created');    
      --      
    END IF;
    --
    IF pi_dcmq.dcmq_ftp_success = 'N' THEN
      BEGIN
        IF lv_error <> 'Y' THEN
          SELECT hfc_id
                ,hfc_ftp_username
                ,hfc_ftp_password
                ,hfc_ftp_host
                ,hfc_ftp_port
                ,hfc_ftp_out_dir
            INTO lr_ftp
            FROM hig_ftp_types, hig_ftp_connections
           WHERE hft_id = hfc_hft_id
             AND hft_type = c_dcm_export_ftptype;
        END IF;
      --
      EXCEPTION
        WHEN no_data_found
         THEN
           /*
           ||If no FTP connection then this is not an error as they may not want to use FTP
           */
           
            hig_process_api.log_it(pi_message => 'No FTP connection details found for Process Type.');
        WHEN too_many_rows
         THEN
            hig_process_api.log_it(pi_message => 'Multiple FTP connection details found for Process Type, only one should be specified.'
                                  ,pi_message_type => 'E');
            lv_error := 'Y';     
        WHEN others
         THEN
            hig_process_api.log_it(pi_message => SUBSTR('Error occurred geting FTP connection details: '||SQLERRM,1,500)
                                  ,pi_message_type => 'E');
            lv_error := 'Y';
      END;
      --   
      IF lv_error <> 'Y' THEN                  
        upload_files(pi_ftp_details => lr_ftp
                    ,pi_file        => pi_dcmq.dcmq_nevt_id||'_'||pi_dcmq.dcmq_naex_id||'.dcminput');
        --   
        process_log_entry(pi_message => 'Upload of File Complete');    
        --
        update_queue_ftp_success(pi_dcmq_id =>pi_dcmq.dcmq_id);      
      END IF;
    END IF;
    --
    IF lv_error = 'Y' THEN
      process_log_entry(pi_message => '--------------------------------------------------------');        
      hig_process_api.process_execution_end(pi_success_flag => 'N');      
    ELSE
      update_queue_complete(pi_dcmq =>pi_dcmq);    
    END IF;
    --
  END export_event_for_dcm;
  --
  -----------------------------------------------------------------------------
  --  
  PROCEDURE queue_dcm(pi_nevt_id IN nem_events.nevt_id%TYPE
                     ,pi_naex_id IN nem_action_executions.naex_id%TYPE)
    IS

  BEGIN
    --
    INSERT INTO nem_dcm_queue(dcmq_id
                             ,dcmq_nevt_id
                             ,dcmq_naex_id)
         VALUES (dcmq_id_seq.nextval
                ,pi_nevt_id
                ,pi_naex_id);

    --
  END queue_dcm;  
  --
  -----------------------------------------------------------------------------
  -- 
  PROCEDURE load_dcm_results_file 
  IS 
    lv_nevt                     NUMBER;
    --
    lv_dcmh_id                  PLS_INTEGER;
    lv_dcmr_id                  PLS_INTEGER;  
    --
    lr_hp    hig_processes%ROWTYPE;
    lr_hptf  hig_process_type_files%ROWTYPE;
    --
    lt_files  hig_process_api.tab_process_files;
    --
    lv_error VARCHAR(1) := 'N';
    --
    lv_filename      VARCHAR2(2000);
    --    
    TYPE header_rec IS RECORD(calc_or_estimate            VARCHAR2(1)
                             ,number_of_errors            INT
                             ,calc_time                   NUMBER(12,6)); 
    --                           
    TYPE single_record_rec IS RECORD(total_delay_time         NUMBER(12,2)
                                    ,total_delay_cost         NUMBER  (12,2)
                                    ,total_vehicles           INT
                                    ,psa_delay_time           NUMBER(12,2)
                                    ,psa_delay_cost           NUMBER(12,2)
                                    ,psa_vehicles             INT
                                    ,number_of_daily_results  INT); 
    --
    TYPE daily_record_rec IS RECORD(daily_date               DATE
                                   ,daily_time               NUMBER(12,2)  
                                   ,daily_cost               NUMBER(12,2) 
                                   ,daily_total_vehicles     INT
                                   ,daily_psa_delay_time     NUMBER(12,2) 
                                   ,daily_psa_delay_cost     NUMBER(12,2) 
                                   ,daily_psa_vehicles       INT); 
    --
    TYPE daily_record_tab IS TABLE OF daily_record_rec INDEX BY BINARY_INTEGER;                          
    --
    TYPE error_tab IS TABLE of VARCHAR(1000) INDEX BY BINARY_INTEGER;
    --
     CURSOR get_naex(c_naex_id nem_action_executions.naex_id%TYPE)
         IS 
     SELECT *
       FROM nem_action_executions
      WHERE naex_id = c_naex_id
      ;    
    --
    lr_naex nem_action_executions%ROWTYPE;
    --
    lt_contents                 nm3type.tab_varchar32767;
    lr_header                   header_rec;
    lr_single_rec               single_record_rec;
    --
    lt_daily                    daily_record_tab;
    lt_errors                   error_tab;
    --
    lt_object_ids               nem_actions_api.object_ids_tab; 
    --    
  BEGIN
    --
    process_log_entry(pi_message => 'Running DCM Output File Loader Version: '||get_body_version);
    /*
    ||Get The Process Id.
    */
    lr_hp := hig_process_api.get_current_process;
    lr_hptf := hig_process_framework.get_process_type_file(pi_process_type_id => lr_hp.hp_process_type_id
                                                          ,pi_file_type_name  => c_results_file_type_name);
    /*
    ||Get the files to be loaded.
    */
    lt_files := hig_process_api.get_current_process_in_files;    
    --
    FOR i IN 1..lt_files.count LOOP
      /*
      ||Loading File Message.
      */
      process_log_entry(pi_message => '--------------------------------------------------------');
      process_log_entry(pi_message => 'Begining load for file: '||lt_files(i).hpf_filename);
      --
      BEGIN     
        --
        SELECT nevt_id
        INTO lv_nevt
        FROM NEM_EVENTS 
        WHERE nevt_id =  substr(lt_files(i).hpf_filename,1,instr(lt_files(i).hpf_filename,'_')-1);
        --
        process_log_entry(pi_message => 'Event ID: '||lv_nevt);        
      EXCEPTION
        WHEN no_data_found THEN
          process_log_entry(pi_message      => 'Error: Event does not exist.'
                           ,pi_message_type => 'E');       
          lv_error := 'Y';
        
      END;
      --
      BEGIN
        lv_filename := substr(lt_files(i).hpf_filename,instr(lt_files(i).hpf_filename,'_')+1,length(lt_files(i).hpf_filename));
        --
         OPEN get_naex(substr(lv_filename,1,instr(lv_filename,'.')-1));
        FETCH get_naex
         INTO lr_naex;
        CLOSE get_naex;         
        --
        process_log_entry(pi_message => 'Action ID: '||lr_naex.naex_id);       
      EXCEPTION
        WHEN no_data_found THEN
          process_log_entry(pi_message      => 'Error: Action does not exist.'
                           ,pi_message_type => 'E');       
          lv_error := 'Y';
              
      END;
      --
      IF lr_naex.naex_summary_result <> 'Submitted to DCM, awaiting results' THEN
          --
          process_log_entry(pi_message      => 'Error: File has already been processed.'
                           ,pi_message_type => 'E');       
          lv_error := 'Y';      
          --
      END IF;
      /*
      ||Read Contents Of File.
      */       
      IF lv_error != 'Y' THEN      
        nm3file.get_file (location     => lt_files(i).hpf_destination
                         ,filename     => lt_files(i).hpf_filename
                         ,max_linesize => 1023
                         ,all_lines    => lt_contents
                         ,add_cr       => FALSE
                         );      
        FOR i in 1..lt_contents.COUNT LOOP
          --
          BEGIN
            --
            IF i = 1 THEN
              /*
              ||Header Record
              */    
              process_log_entry(pi_message => '--------------------------------------------------------');        
              process_log_entry(pi_message => 'Validating Header');
              --     
              lr_header.calc_or_estimate := substr(lt_contents(i),1,1);                    
              lr_header.number_of_errors := substr(lt_contents(i),2,2);        
              lr_header.calc_time        := substr(lt_contents(i),4,12);
              --
              IF   lr_header.calc_or_estimate NOT IN ('C','E') THEN
                process_log_entry(pi_message      => 'Error: Invalid Calculation/Estimate Value on Line:'|| i ||'position:'||1||' Value must be ''C'' or ''E'''
                                 ,pi_message_type => 'E');
                lv_error := 'Y';
              END IF;
              --
            ELSE
              IF nvl(lr_header.number_of_errors,0) > 0 THEN 
                /*
                ||Error Results
                */
                lt_errors(lt_errors.COUNT+1)  := substr(lt_contents(i),1,1000);  
              ELSE        
                IF i = 2 THEN
                  process_log_entry(pi_message => 'Validating Single Results');
                  /*
                  ||Single Record Result
                  */    
                  lr_single_rec.total_delay_time        := substr(lt_contents(i),01,12);      
                  lr_single_rec.total_delay_cost        := substr(lt_contents(i),13,12);      
                  lr_single_rec.total_vehicles          := substr(lt_contents(i),25,12);      
                  lr_single_rec.psa_delay_time          := substr(lt_contents(i),37,12);      
                  lr_single_rec.psa_delay_cost          := substr(lt_contents(i),49,12);      
                  lr_single_rec.psa_vehicles            := substr(lt_contents(i),61,12);      
                  lr_single_rec.number_of_daily_results := substr(lt_contents(i),73,5);                
                ELSE 
                  IF i = 3 THEN
                    process_log_entry(pi_message => 'Validating Daily Results');            
                  END IF;
                  /*
                  ||Daily Results
                  */               
                  lt_daily(i-2).daily_date              := substr(lt_contents(i),01,12);
                  lt_daily(i-2).daily_time              := substr(lt_contents(i),12,12);
                  lt_daily(i-2).daily_cost              := substr(lt_contents(i),24,12);
                  lt_daily(i-2).daily_total_vehicles    := substr(lt_contents(i),36,12);
                  lt_daily(i-2).daily_psa_delay_time    := substr(lt_contents(i),48,12);
                  lt_daily(i-2).daily_psa_delay_cost    := substr(lt_contents(i),60,12);
                  lt_daily(i-2).daily_psa_vehicles      := substr(lt_contents(i),72,12);
                END IF;
              END IF;
            END IF;
          EXCEPTION
            WHEN value_error THEN
              process_log_entry(pi_message      => 'Error: Invalid Value on line:'|| i
                               ,pi_message_type => 'E');       
              lv_error := 'Y';
            WHEN others THEN
              process_log_entry(pi_message      => 'Error: '||sqlerrm
                               ,pi_message_type => 'E');       
              lv_error := 'Y';        
          END;        
          --
        END LOOP;  
      END IF;
      --
      IF lv_error = 'Y' THEN
        process_log_entry(pi_message => '--------------------------------------------------------');        
        process_log_entry(pi_message => 'Validation Failed. No records will be Inserted.');           
        hig_process_api.process_execution_end(pi_success_flag => 'N');        
      ELSE     
        lv_dcmh_id := DCMH_ID_SEQ.NEXTVAL;
        process_log_entry(pi_message => 'Inserting Records');                  
        INSERT INTO nem_dcm_header(dcmh_id
                                  ,dcmh_nevt_id
                                  ,dcmh_naex_id
                                  ,dcmh_calc_or_estimate
                                  ,dcmh_number_of_errors
                                  ,dcmh_calculation_time)
        VALUES                    (lv_dcmh_id
                                  ,lv_nevt
                                  ,lr_naex.naex_id
                                  ,lr_header.calc_or_estimate
                                  ,lr_header.number_of_errors
                                  ,lr_header.calc_time
                                  );
        IF nvl(lr_header.number_of_errors,0) = 0 THEN
          --
          lv_dcmr_id := DCMR_ID_SEQ.NEXTVAL;
          --
          INSERT INTO nem_dcm_result (dcmr_id
                                     ,dcmr_total_delay_time         
                                     ,dcmr_total_delay_cost         
                                     ,dcmr_total_vehicles           
                                     ,dcmr_psa_delay_time           
                                     ,dcmr_psa_delay_cost           
                                     ,dcmr_psa_vehicles             
                                     ,dcmr_number_of_daily_results  
                                     ,dcmr_dcmh_id)
          VALUES                     (lv_dcmr_id
                                     ,lr_single_rec.total_delay_time         
                                     ,lr_single_rec.total_delay_cost         
                                     ,lr_single_rec.total_vehicles           
                                     ,lr_single_rec.psa_delay_time           
                                     ,lr_single_rec.psa_delay_cost           
                                     ,lr_single_rec.psa_vehicles             
                                     ,lr_single_rec.number_of_daily_results  
                                     ,lv_dcmh_id);
          --  
          FOR i in 1..lt_daily.COUNT LOOP
            --
            INSERT INTO nem_dcm_daily_results(dcmd_id                       
                                             ,dcmd_daily_date               
                                             ,dcmd_daily_time                
                                             ,dcmd_daily_cost                
                                             ,dcmd_daily_total_vehicles     
                                             ,dcmd_daily_psa_delay_time     
                                             ,dcmd_daily_psa_delay_cost     
                                             ,dcmd_daily_psa_vehicles       
                                             ,dcmd_dcmr_id)
            VALUES                            (DCMD_ID_SEQ.NEXTVAL
                                              ,lt_daily(i).daily_date
                                              ,lt_daily(i).daily_time
                                              ,lt_daily(i).daily_cost
                                              ,lt_daily(i).daily_total_vehicles
                                              ,lt_daily(i).daily_psa_delay_time
                                              ,lt_daily(i).daily_psa_delay_cost
                                              ,lt_daily(i).daily_psa_vehicles
                                              ,lv_dcmr_id);
          END LOOP;
        ELSE
          --
          FOR i in 1..lt_errors.COUNT LOOP
            INSERT INTO nem_dcm_error(dcme_id              
                                     ,dcme_error           
                                     ,dcme_dcmh_id)
            VALUES                   (DCME_ID_SEQ.NEXTVAL
                                     ,lt_errors(i)
                                     ,lv_dcmh_id);
          END LOOP;
        END IF;
      END IF;
    END LOOP;
    --
    process_log_entry(pi_message => '--------------------------------------------------------');    
    /*
    ||Log action event against Event.
    */
    --lt_object_ids(1) := lv_nevt;
    --
    log_loaded_results (pi_dcmh_id     => lv_dcmh_id
                       ,pi_naex        => lr_naex
                       ,pi_error_count => nvl(lr_header.number_of_errors,0))
    ;
    --                    
  END load_dcm_results_file;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE import_dcm_results
    IS
    --
    lv_ok_to_proceed  BOOLEAN;
    --
  BEGIN
    --
    lv_ok_to_proceed := hig_process_api.do_polling_if_requested(pi_file_type_name     => c_results_file_type_name
                                                               ,pi_file_mask          => NULL
                                                               ,pi_binary             => TRUE
                                                               ,pi_archive_overwrite  => TRUE
                                                               ,pi_remove_failed_arch => TRUE);
    IF lv_ok_to_proceed
     THEN
        --
        load_dcm_results_file;
        --
    END IF;
    --
  END import_dcm_results;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE export_dcm_queue
    IS
    --
    lv_ok_to_proceed  BOOLEAN;
    --
    TYPE nem_dcm_queue_tab is TABLE OF nem_dcm_queue%ROWTYPE INDEX BY BINARY_INTEGER;
    --
    lt_dcmq nem_dcm_queue_tab;
    --
    CURSOR get_dcmq
        IS 
    SELECT *
      FROM nem_dcm_queue
     WHERE dcmq_ftp_success = 'N' OR dcmq_file_success = 'N'
     ORDER BY dcmq_priority, dcmq_id
     ;       
  BEGIN
    --
     OPEN get_dcmq;
    FETCH get_dcmq
     BULK COLLECT
     INTO lt_dcmq;
    CLOSE get_dcmq;   
    --
    FOR i in 1..lt_dcmq.COUNT LOOP
      lv_ok_to_proceed := hig_process_api.do_polling_if_requested(pi_file_type_name     => c_export_file_type_name
                                                                 ,pi_file_mask          => NULL
                                                                 ,pi_binary             => TRUE
                                                                 ,pi_archive_overwrite  => TRUE
                                                                 ,pi_remove_failed_arch => TRUE);
      IF lv_ok_to_proceed
       THEN
          --
          export_event_for_dcm(pi_dcmq =>lt_dcmq(i));
          --
      END IF;
      --
    END LOOP;
  END export_dcm_queue;  
END nem_dcm_interface;
/

