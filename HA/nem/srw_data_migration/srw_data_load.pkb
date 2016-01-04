CREATE OR REPLACE PACKAGE BODY srw_data_load AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/srw_data_load.pkb-arc   3.4   Jan 04 2016 10:52:00   Mike.Huitson  $
  --       Module Name      : $Workfile:   srw_data_load.pkb  $
  --       Date into PVCS   : $Date:   Jan 04 2016 10:52:00  $
  --       Date fetched Out : $Modtime:   Jan 04 2016 10:51:48  $
  --       Version          : $Revision:   3.4  $
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
  g_body_sccsid   CONSTANT VARCHAR2(2000) := '$Revision:   3.4  $';
  g_package_name  CONSTANT VARCHAR2(30)   := 'nem_initial_data_load';
  --
  g_debug    BOOLEAN := FALSE;
  g_closure  srw_closures.closure%TYPE;
  g_operational_area  srw_closures.operational_area%TYPE;
  --
  TYPE closure_tab IS TABLE OF srw_closures%ROWTYPE;
  TYPE layouts_tab IS TABLE OF srw_layouts%ROWTYPE;
  TYPE components_tab IS TABLE OF srw_components%ROWTYPE;
  TYPE sections_tab IS TABLE OF srw_sections%ROWTYPE;
  TYPE lanes_tab IS TABLE OF srw_lanes%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE diary_tab IS TABLE OF srw_diary%ROWTYPE;
  --
  TYPE pla_tab IS TABLE OF nm_placement_array INDEX BY BINARY_INTEGER;
  --
  TYPE au_lookup_tab IS TABLE OF nm_admin_units_all.nau_unit_code%TYPE INDEX BY srw_closures.operational_area%TYPE;
  g_au_lookup  au_lookup_tab;
  --
  TYPE au_id_lookup_tab IS TABLE OF nm_admin_units_all.nau_admin_unit%TYPE INDEX BY nm_admin_units_all.nau_unit_code%TYPE;
  g_au_id_lookup  au_id_lookup_tab;
  --
  TYPE lane_lookup_tab IS TABLE OF nem_impact_group_xsps.nigx_xsp%TYPE INDEX BY srw_lanes.lane%TYPE;
  g_lane_lookup  lane_lookup_tab;
  --
  TYPE lane_status_lookup_tab IS TABLE OF nem_impact_group_xsps.nigx_reason%TYPE INDEX BY srw_lanes.lane_status%TYPE;
  g_lane_status_lookup  lane_status_lookup_tab;
  --
  TYPE speed_limit_lookup_tab IS TABLE OF nem_impact_groups.nig_speed_limit%TYPE INDEX BY srw_closures.temporary_speed_limit%TYPE;
  g_group_speed_limit_lookup  speed_limit_lookup_tab;
  g_schd_speed_limit_lookup  speed_limit_lookup_tab;
  --
  TYPE delay_lookup_tab IS TABLE OF nm_inv_attri_lookup_all.ial_value%TYPE INDEX BY srw_closures.expected_delay%TYPE;
  g_delay_lookup  delay_lookup_tab;
  --
  TYPE nature_of_works_lookup_tab IS TABLE OF nm_inv_attri_lookup_all.ial_value%TYPE INDEX BY srw_closures.nature_of_works%TYPE;
  g_nature_of_works_lookup  nature_of_works_lookup_tab;
  --
  TYPE nec_tab IS TABLE OF nem_event_contacts%ROWTYPE INDEX BY BINARY_INTEGER;
  --
  TYPE location_rec IS RECORD(nm_ne_id_of  nm_members_all.nm_ne_id_of%TYPE
                             ,nm_begin_mp  nm_members_all.nm_begin_mp%TYPE
                             ,nm_end_mp    nm_members_all.nm_end_mp%TYPE);
  TYPE location_tab IS TABLE OF location_rec INDEX BY BINARY_INTEGER;
  --
  TYPE schedule_tab IS TABLE OF nem_impact_group_schedules%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE impact_change_tab IS TABLE OF nem_impact_group_xsps%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE impact_group_rec IS RECORD(group_rec  nem_impact_groups%ROWTYPE
                                 ,locations  location_tab
                                 ,changes    impact_change_tab
                                 ,schedules  schedule_tab);
  TYPE impact_group_tab IS TABLE OF impact_group_rec INDEX BY BINARY_INTEGER;
  --
  TYPE message_stack_tab IS TABLE OF srw_to_nem_log%ROWTYPE INDEX BY BINARY_INTEGER;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE init_event_rec(po_event_rec IN OUT nem_api.event_rec)
    IS
    --
    lr_event  nem_api.event_rec;
    --
  BEGIN
    --
    po_event_rec := lr_event;
    --
  END init_event_rec;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE add_to_stack(pi_message      IN     srw_to_nem_log.stn_message%TYPE
                        ,pi_message_type IN     srw_to_nem_log.stn_message_type%TYPE DEFAULT c_error
                        ,po_stack        IN OUT message_stack_tab)
    IS
  BEGIN
    --
    po_stack(po_stack.COUNT+1).stn_id := stn_id_seq.NEXTVAL;
    po_stack(po_stack.COUNT).stn_timestamp := CURRENT_TIMESTAMP;
    po_stack(po_stack.COUNT).stn_operational_area := g_operational_area;
    po_stack(po_stack.COUNT).stn_closure := g_closure;
    po_stack(po_stack.COUNT).stn_message_type := pi_message_type;
    po_stack(po_stack.COUNT).stn_message := pi_message;
    --
  END add_to_stack;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE flush_stack(po_stack IN OUT message_stack_tab)
    IS
    --
    PRAGMA AUTONOMOUS_TRANSACTION;
    --
  BEGIN
    --
    FORALL i IN 1..po_stack.COUNT
      INSERT
        INTO srw_to_nem_log
      VALUES po_stack(i)
           ;
    --
    COMMIT;
    --
    po_stack.DELETE;
    --
  END flush_stack;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION stack_contains_errors(pi_stack IN message_stack_tab)
    RETURN BOOLEAN IS
    --
    lv_retval BOOLEAN := FALSE;
    --
  BEGIN
    --
    FOR i IN 1..pi_stack.COUNT LOOP
      --
      IF pi_stack(i).stn_message_type = c_error
       THEN
          lv_retval := TRUE;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    RETURN lv_retval;
    --
  END stack_contains_errors;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE dump_pla(pi_title         IN     VARCHAR2
                    ,pi_pla           IN     nm_placement_array
                    ,po_message_stack IN OUT message_stack_tab)
    IS
  BEGIN
    --
    IF pi_pla.is_empty
     THEN
        --
        add_to_stack(pi_message      => pi_title||' placement array is empty.'
                    ,pi_message_type => c_debug
                    ,po_stack        => po_message_stack);
        --
    ELSE
        --
        add_to_stack(pi_message      => pi_title||' contents:-'
                    ,pi_message_type => c_debug
                    ,po_stack        => po_message_stack);
        --
        FOR i IN 1..pi_pla.placement_count LOOP
          add_to_stack(pi_message      => 'Pos('||i||')'
                                        ||'-'||pi_pla.npa_placement_array(i).pl_ne_id
                                        ||'('||Nm3net.get_ne_unique(pi_pla.npa_placement_array(i).pl_ne_id)||')'
                                        ||','||pi_pla.npa_placement_array(i).pl_start
                                        ||'->'||pi_pla.npa_placement_array(i).pl_end
                                        ||','||pi_pla.npa_placement_array(i).pl_measure
                      ,pi_message_type => c_debug
                      ,po_stack        => po_message_stack);
        END LOOP;
        --
    END IF;
    --
  END dump_pla;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE refresh_nem_roads
    IS
    --
    lt_roads  nem_util.roads_tab;
    --
    CURSOR get_rec_ids
        IS
    SELECT nevt_id
      FROM nem_events
     UNION ALL
    SELECT nig_id
      FROM nem_impact_groups
         ;
    --
    lt_rec_ids  nem_api.event_ids_tab;
    --
  BEGIN
    --
    OPEN get_rec_ids;
    --
    LOOP
      --
      FETCH get_rec_ids
       BULK COLLECT
       INTO lt_rec_ids
      LIMIT 1000;
      --
      FOR i IN 1..lt_rec_ids.COUNT LOOP
        --
        lt_roads := nem_get_roads(pi_rec_id => lt_rec_ids(i));
        --
        DELETE nem_roads
         WHERE nerd_rec_id = lt_rec_ids(i)
             ;
        --
        FORALL j IN 1..lt_roads.COUNT
          INSERT
            INTO nem_roads
          VALUES lt_roads(j)
               ;
        --
      END LOOP;
      --
      COMMIT;
      --
      EXIT WHEN get_rec_ids%NOTFOUND;
      --
    END LOOP;
    --
    CLOSE get_rec_ids;
    --
  END refresh_nem_roads;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION get_au_lookup(pi_operational_area IN srw_closures.operational_area%TYPE)
    RETURN nm_admin_units_all.nau_unit_code%TYPE IS
  BEGIN
    --
    RETURN g_au_lookup(pi_operational_area);
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        RETURN NULL;
  END get_au_lookup;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_admin_unit(pi_operational_area IN     srw_closures.operational_area%TYPE
                          ,po_admin_unit       IN OUT nm_admin_units_all.nau_admin_unit%TYPE
                          ,po_message_stack    IN OUT message_stack_tab)
    IS
    --
    lv_unit_code   nm_admin_units_all.nau_unit_code%TYPE;
    lv_admin_unit  nm_admin_units_all.nau_admin_unit%TYPE;
    --
  BEGIN
    --
    lv_unit_code := get_au_lookup(pi_operational_area => pi_operational_area);
    --
    IF lv_unit_code IS NOT NULL
     THEN
        BEGIN
          --
          lv_admin_unit := g_au_id_lookup(lv_unit_code);
          --
        EXCEPTION
          WHEN no_data_found
           THEN
              BEGIN
                --
                SELECT nau_admin_unit
                  INTO lv_admin_unit
                  FROM nm_admin_units_all
                 WHERE nau_unit_code = lv_unit_code
                     ;
                --
                g_au_id_lookup(lv_unit_code) := lv_admin_unit;
                --
              EXCEPTION
                WHEN no_data_found
                 THEN
                    lv_admin_unit := NULL;
              END;
        END;
    END IF;
    --
    IF lv_admin_unit IS NOT NULL
     THEN
        po_admin_unit := lv_admin_unit;
    ELSE
        add_to_stack(pi_message => 'Unable to map Operational Area ['||pi_operational_area||'] to an Admin Unit.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_admin_unit;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_event_status(pi_srw_status    IN     srw_closures.closure_status%TYPE
                            ,po_nem_status    IN OUT VARCHAR2
                            ,po_message_stack IN OUT message_stack_tab)
    IS
    --
  BEGIN
    --
    IF pi_srw_status = 'PROV'
     THEN
        po_nem_status := 'SHARED';
    ELSIF pi_srw_status = 'FIRM'
     THEN
        po_nem_status := 'PUBLISHED';
    ELSE
        add_to_stack(pi_message => 'SRW Closure status is '||pi_srw_status||' migration of closures at this status is not supported.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_event_status;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_event_type(pi_srw_activity        IN     srw_closures.activity%TYPE
                          ,pi_srw_closure_type    IN     srw_closures.closure_type%TYPE
                          ,pi_srw_nature_of_works IN     srw_closures.nature_of_works%TYPE
                          ,po_event_type          IN OUT VARCHAR2
                          ,po_message_stack       IN OUT message_stack_tab)
    IS
    --
  BEGIN
    --
    CASE pi_srw_activity
      /*
      ||Activity of 'To Be Advised' is not to be migrated so drop into the ELSE clause.
      WHEN 'NA'
       THEN
      */
      WHEN 'MS'
       THEN
          po_event_type := 'MAJOR SCHEMES';
      /*
      ||Historic Value - Not Supported.
      WHEN 'TMC'
       THEN
          po_event_type := '';
      */
      /*
      ||Historic Value - Not Supported.
      WHEN 'SERPS'
       THEN
          po_event_type := '';
      */
      WHEN 'AS'
       THEN
          po_event_type := 'AREA SCHEMES';
      /*
      ||Historic Value - Not Supported.
      WHEN 'MAC'
       THEN
          po_event_type := '';
      */
      /*
      ||Historic Value - Not Supported.
      WHEN 'SERVPR'
       THEN
          po_event_type := '';
      */
      WHEN 'AR'
       THEN
          po_event_type := 'AREA RENEWALS';
      /*
      ||Historic Value - Not Supported.
      WHEN 'DBFO'
       THEN
          po_event_type := '';
      */
      /*
      ||Historic Value - Not Supported.
      WHEN 'FRAME'
       THEN
          po_event_type := '';
      */
      WHEN 'RW'
       THEN
          IF pi_srw_closure_type = 'PLAN'
           THEN
              po_event_type := 'PROGRAMMED ROUTINE WORKS';
          ELSIF pi_srw_closure_type = 'EMER'
           THEN
              po_event_type := 'EMERGENCY ROUTINE WORKS';
          ELSE
              add_to_stack(pi_message => 'Comination of SRW Activity '||pi_srw_activity||' and SRW Closure Type '||pi_srw_closure_type||' is not supported.'
                          ,po_stack   => po_message_stack);
          END IF;
      /*
      ||Historic Value - Not Supported.
      WHEN 'STATUNDER'
       THEN
          po_event_type := '';
      */
      /*
      ||Historic Value - Not Supported.
      WHEN 'SEC278'
       THEN
          po_event_type := '';
      */
      /*
      ||Historic Value - Not Supported.
      WHEN 'SECT50'
       THEN
          po_event_type := '';
      */
      WHEN 'TS'
       THEN
          po_event_type := 'REGIONAL TECHNOLOGY SCHEMES';
      WHEN 'TW'
       THEN
          po_event_type := 'REGIONAL TECHNOLOGY WORKS';
      /*
      ||Historic Value - Not Supported.
      WHEN 'TPI'
       THEN
          po_event_type := '';
      */
      WHEN 'SW'
       THEN
          /*
          ||TODO - Pete R has included some TMA data in the mapping of this one, need to go back to discuss.
          */
          IF pi_srw_closure_type = 'PLAN'
           THEN
              po_event_type := 'PROGRAMMED STREET/ROAD WORKS';
          ELSIF pi_srw_closure_type = 'EMER'
           THEN
              po_event_type := 'EMERGENCY AND URGENT ROAD WORK';
          ELSE
              add_to_stack(pi_message => 'Comination of SRW Activity '||pi_srw_activity||' and SRW Closure Type '||pi_srw_closure_type||' is not supported.'
                          ,po_stack   => po_message_stack);
          END IF;
      /*
      ||Historic Value - Not Supported.
      WHEN 'OTH'
       THEN
          po_event_type := '';
      */
      WHEN 'DW'
       THEN
          po_event_type := 'DEVELOPER WORKS';
      WHEN 'LW'
       THEN
          po_event_type := 'LICENSEE WORKS';
      WHEN 'NTW'
       THEN
          IF pi_srw_closure_type = 'PLAN'
           THEN
              po_event_type := 'NATIONAL TECHNOLOGY WORKS';
          ELSIF pi_srw_closure_type = 'EMER'
           THEN
              po_event_type := 'EMERGENCY NATIONAL TECH WORKS';
          ELSE
              add_to_stack(pi_message => 'Comination of SRW Activity '||pi_srw_activity||' and SRW Closure Type '||pi_srw_closure_type||' is not supported.'
                          ,po_stack   => po_message_stack);
          END IF;
      WHEN 'EVENT'
       THEN
          IF pi_srw_nature_of_works = 'DR'
           THEN
              po_event_type := 'DIVERSION/ALTERNATE ROUTE';
          ELSE
              po_event_type := 'OFF NETWORK';
          END IF;
      WHEN 'INC'
       THEN
          po_event_type := 'TRAFFIC INCIDENTS';
      WHEN 'SOAL'
       THEN
          po_event_type := 'ABNORMAL LOAD MOVEMENTS';
      WHEN 'OAL'
       THEN
          po_event_type := 'ABNORMAL LOAD MOVEMENTS';
      ELSE
          add_to_stack(pi_message => 'SRW Activity '||pi_srw_activity||' is not supported.'
                      ,po_stack   => po_message_stack);
    END CASE;
    --
  END set_event_type;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_nature_of_works(pi_srw_nature_of_works IN     srw_closures.nature_of_works%TYPE
                               ,po_nem_nature_of_works IN OUT VARCHAR2
                               ,po_message_stack       IN OUT message_stack_tab)
    IS
    --
    lv_now  VARCHAR2(500);
    --
  BEGIN
    --
    po_nem_nature_of_works := g_nature_of_works_lookup(pi_srw_nature_of_works);
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        add_to_stack(pi_message => 'Nature Of Works Value ['||pi_srw_nature_of_works||'] is not supported.'
                    ,po_stack   => po_message_stack);
  END set_nature_of_works;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_xsp(pi_lane          IN     srw_lanes.lane%TYPE
                   ,po_xsp           IN OUT nem_impact_group_xsps.nigx_xsp%TYPE
                   ,po_message_stack IN OUT message_stack_tab)
    IS
    --
    lv_xsp  nem_impact_group_xsps.nigx_xsp%TYPE;
    --
  BEGIN
    --
    BEGIN
      lv_xsp := g_lane_lookup(pi_lane);
    EXCEPTION
      WHEN no_data_found
       THEN
          lv_xsp := NULL;
    END;
    --
    IF lv_xsp IS NOT NULL
     THEN
        po_xsp := lv_xsp;
    ELSE
        add_to_stack(pi_message => 'Unable to map Lane ['||pi_lane||'] to an XSP.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_xsp;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_reason(pi_lane_status   IN     srw_lanes.lane_status%TYPE
                      ,po_reason        IN OUT nem_impact_group_xsps.nigx_reason%TYPE
                      ,po_message_stack IN OUT message_stack_tab)
    IS
    --
    lv_reason  nem_impact_group_xsps.nigx_reason%TYPE;
    --
  BEGIN
    --
    BEGIN
      lv_reason := g_lane_status_lookup(pi_lane_status);
    EXCEPTION
      WHEN no_data_found
       THEN
          lv_reason := NULL;
    END;
    --
    IF lv_reason IS NOT NULL
     THEN
        po_reason := lv_reason;
    ELSE
        add_to_stack(pi_message => 'Unable to map Lane Status ['||pi_lane_status||'] to a Reason.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_reason;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_speed_limit(pi_grp_or_schd     IN     VARCHAR2
                           ,pi_srw_speed_limit IN     srw_closures.temporary_speed_limit%TYPE
                           ,po_nem_speed_limit IN OUT nem_impact_groups.nig_speed_limit%TYPE
                           ,po_message_stack   IN OUT message_stack_tab)
    IS
    --
    lv_speed_limit  nem_impact_groups.nig_speed_limit%TYPE;
    --
  BEGIN
    --
    BEGIN
      IF pi_grp_or_schd = 'GRP'
       THEN
          lv_speed_limit := g_group_speed_limit_lookup(pi_srw_speed_limit);
      ELSE
          lv_speed_limit := g_schd_speed_limit_lookup(pi_srw_speed_limit);
      END IF;
    EXCEPTION
      WHEN no_data_found
       THEN
          lv_speed_limit := NULL;
    END;
    --
    IF lv_speed_limit IS NOT NULL
     THEN
        po_nem_speed_limit := lv_speed_limit;
    ELSE
        add_to_stack(pi_message => 'Unable to map SRW Temporary Speed Limit['||pi_srw_speed_limit||'] to an NEM Speed Limit.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_speed_limit;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE set_delay(pi_expected_delay IN     srw_closures.expected_delay%TYPE
                     ,po_delay          IN OUT nm_inv_attri_lookup_all.ial_value%TYPE
                     ,po_message_stack  IN OUT message_stack_tab)
    IS
    --
    lv_delay  nm_inv_attri_lookup_all.ial_value%TYPE;
    --
  BEGIN
    --
    BEGIN
      lv_delay := g_delay_lookup(pi_expected_delay);
    EXCEPTION
      WHEN no_data_found
       THEN
          lv_delay := NULL;
    END;
    --
    IF lv_delay IS NOT NULL
     THEN
        po_delay := lv_delay;
    ELSE
        add_to_stack(pi_message => 'Unable to map SRW Expected Delay['||pi_expected_delay||'] to an NEM Delay.'
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END set_delay;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_varchar2(pi_value         IN     VARCHAR2
                        ,pi_target_name   IN     VARCHAR2
                        ,po_target        IN OUT VARCHAR2
                        ,po_message_stack IN OUT message_stack_tab
                        ,pi_message_type  IN     srw_to_nem_log.stn_message_type%TYPE DEFAULT c_error)
    IS
  BEGIN
    /*
    ||Do the assignment.
    */
    po_target := pi_value;
    --
  EXCEPTION
    WHEN others
     THEN
        add_to_stack(pi_message => pi_target_name||' Set_VARCHAR2: '||SQLERRM
                    ,po_stack   => po_message_stack);
  END set_varchar2;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_number(pi_value         IN     VARCHAR2
                      ,pi_target_name   IN     VARCHAR2
                      ,po_target        IN OUT VARCHAR2
                      ,po_message_stack IN OUT message_stack_tab
                      ,pi_message_type  IN     srw_to_nem_log.stn_message_type%TYPE DEFAULT c_error)
    IS
  BEGIN
    /*
    ||Do the assignment.
    */
    po_target := TO_NUMBER(pi_value);
    --
  EXCEPTION
    WHEN others
     THEN
        add_to_stack(pi_message => pi_target_name||': '||SQLERRM
                    ,po_stack   => po_message_stack);
  END set_number;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION get_lanes(pi_component_key IN srw_components.component_key%TYPE
                    ,pi_layout_key    IN srw_layouts.layout_key%TYPE)
    RETURN lanes_tab IS
    --
    lt_lanes  lanes_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_lanes
      FROM srw_lanes
     WHERE layout_key = pi_layout_key
       AND component_key = pi_component_key
       AND lane_status != 'UNCHANGED'
         ;
    --
    RETURN lt_lanes;
    --
  END get_lanes;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION get_layouts(pi_component_key IN srw_components.component_key%TYPE)
    RETURN layouts_tab IS
    --
    lt_layouts  layouts_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_layouts
      FROM srw_layouts
     WHERE layout_key IN(SELECT layout_key
                           FROM srw_lanes
                          WHERE component_key = pi_component_key
                            AND lane_status != 'UNCHANGED')
         ;
    --
    RETURN lt_layouts;
    --
  END get_layouts;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION get_sections(pi_component_key IN srw_components.component_key%TYPE)
    RETURN sections_tab IS
    --
    lt_sections  sections_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_sections
      FROM srw_sections
     WHERE component_key = pi_component_key
     ORDER
        BY component_start
         ;
    --
    RETURN lt_sections;
    --
  END get_sections;

  --
  --------------------------------------------------------------------------------
  --
  FUNCTION get_diary(pi_layout_key IN srw_layouts.layout_key%TYPE)
    RETURN diary_tab IS
    --
    lt_diary  diary_tab;
    --
  BEGIN
    --
    SELECT *
      BULK COLLECT
      INTO lt_diary
      FROM srw_diary
     WHERE layout_key = pi_layout_key
         ;
    --
    RETURN lt_diary;
    --
  END get_diary;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE add_locations(pi_iit_ne_id     IN     nm_inv_items_all.iit_ne_id%TYPE
                         ,pi_nit_inv_type  IN     nm_inv_types_all.nit_inv_type%TYPE
                         ,pi_locations     IN     location_tab
                         ,po_message_stack IN OUT message_stack_tab)
    IS
    --
    lv_asset_job_id        NUMBER;
    lv_location_job_id     NUMBER;
    lv_no_overlaps_job_id  NUMBER;
    --
    lv_warning_code  VARCHAR2(1000);
    lv_warning_msg   VARCHAR2(1000);
    --
  BEGIN
    --
    IF pi_locations.COUNT > 0
     THEN
        /*
        ||Create an extent for the asset.
        */
        nm3extent.create_temp_ne(pi_source_id => pi_iit_ne_id
                                ,pi_source    => nm3extent.get_route
                                ,pi_begin_mp  => NULL
                                ,pi_end_mp    => NULL
                                ,po_job_id    => lv_asset_job_id);
        /*
        ||Loop through the locations and add them to the asset extent.
        */
        FOR i IN 1..pi_locations.COUNT LOOP
          --
          BEGIN
            --
            nm3extent.create_temp_ne(pi_source_id => pi_locations(i).nm_ne_id_of
                                    ,pi_source    => nm3extent.get_route
                                    ,pi_begin_mp  => pi_locations(i).nm_begin_mp
                                    ,pi_end_mp    => pi_locations(i).nm_end_mp
                                    ,po_job_id    => lv_location_job_id);
            --
            nm3extent.combine_temp_nes(pi_job_id_1       => lv_asset_job_id
                                      ,pi_job_id_2       => lv_location_job_id
                                      ,pi_check_overlaps => FALSE);
            /*
            ||Remove any overlaps.
            */
            lv_asset_job_id := nm3extent.remove_overlaps(pi_nte_id => lv_asset_job_id);
            --
          EXCEPTION
            WHEN others
             THEN
                add_to_stack(pi_message      => 'Error Adding Location, Element Id['
                                                ||pi_locations(i).nm_ne_id_of||'] From Offset['
                                                ||pi_locations(i).nm_begin_mp||'] To Offset['
                                                ||pi_locations(i).nm_end_mp||']: '||SQLERRM
                            ,pi_message_type => c_warning
                            ,po_stack        => po_message_stack);
          END;
        END LOOP;
        /*
        ||Remove any overlaps.
        */
        lv_no_overlaps_job_id := nm3extent.remove_overlaps(pi_nte_id => lv_asset_job_id);
        /*
        ||Locate the asset.
        ||NB. If the load runs beyond midnight the session's effective date
        ||will be yesterday which means any assets created after midnight will
        ||not be able to be located as they will not show up in the nm_inv_items
        ||view so reset the effective date to be sure.
        */
        nm3user.set_effective_date(p_date => SYSDATE);
        nm3homo.homo_update(p_temp_ne_id_in  => lv_no_overlaps_job_id
                           ,p_iit_ne_id      => pi_iit_ne_id
                           ,p_effective_date => TRUNC(SYSDATE)
                           ,p_warning_code   => lv_warning_code
                           ,p_warning_msg    => lv_warning_msg);
        --
    END IF;
    --
  EXCEPTION
    WHEN others
     THEN
        add_to_stack(pi_message      => 'Error Adding Locations(lv_no_overlaps_job_id='||lv_no_overlaps_job_id||'): '||SQLERRM
                    ,pi_message_type => c_warning
                    ,po_stack        => po_message_stack);

  END add_locations;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE add_impact_group(pi_name          IN     nem_impact_groups.nig_name%TYPE
                            ,pi_closure_rec   IN     srw_closures%ROWTYPE
                            ,po_group_tab     IN OUT impact_group_tab
                            ,po_message_stack IN OUT message_stack_tab)
    IS
    --
    lv_ind         PLS_INTEGER;
    lv_error_flag  VARCHAR2(1);
    lv_error_text  nm3type.max_varchar2;
    --
    lr_empty_group  nem_impact_groups%ROWTYPE;
    --
  BEGIN
    --
    lv_ind := po_group_tab.COUNT + 1;
    --
    po_group_tab(lv_ind).group_rec := lr_empty_group;
    --
    set_varchar2(pi_value         => pi_name
                ,pi_target_name   => 'Impact Group Name'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_name
                ,po_message_stack => po_message_stack);
    --
    set_varchar2(pi_value         => CASE WHEN pi_closure_rec.traffic_management = 'CWAYCLO' THEN 'Y' ELSE 'N' END
                ,pi_target_name   => 'Impact Group Carriageway Closure'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_carriageway_closure
                ,po_message_stack => po_message_stack);
    --
    set_varchar2(pi_value         => CASE WHEN pi_closure_rec.traffic_management = 'HRESTR' THEN 'Y' ELSE 'N' END
                ,pi_target_name   => 'Impact Group Height Restriction'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_height_restriction
                ,po_message_stack => po_message_stack);
    --
    set_varchar2(pi_value         => CASE WHEN pi_closure_rec.traffic_management = 'WRESTR'  OR pi_closure_rec.narrow_lanes='YES' THEN 'Y' ELSE 'N' END
                ,pi_target_name   => 'Impact Group Width Restriction'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_width_restriction
                ,po_message_stack => po_message_stack);
    --
    set_varchar2(pi_value         => CASE WHEN pi_closure_rec.traffic_management = 'WERESTR'THEN 'Y' ELSE 'N' END
                ,pi_target_name   => 'Impact Group Weight Restriction'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_weight_restriction
                ,po_message_stack => po_message_stack);
    --
    set_varchar2(pi_value         => CASE WHEN pi_closure_rec.traffic_management = 'CONTRA' THEN 'Y' ELSE 'N' END
                ,pi_target_name   => 'Impact Group Contraflow'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_contraflow
                ,po_message_stack => po_message_stack);
    --
    set_speed_limit(pi_grp_or_schd     => 'GRP'
                   ,pi_srw_speed_limit => pi_closure_rec.temporary_speed_limit
                   ,po_nem_speed_limit => po_group_tab(lv_ind).group_rec.nig_speed_limit
                   ,po_message_stack   => po_message_stack);
    --
    set_varchar2(pi_value         => CASE pi_closure_rec.traffic_management
                                       WHEN 'CONWORK'
                                        THEN 'CONVOY WORKING'
                                       WHEN 'TRSIGN'
                                        THEN 'TRAFFIC SIGNALS'
                                       ELSE 'NONE'
                                     END
                ,pi_target_name   => 'Impact Group Traffic Management'
                ,po_target        => po_group_tab(lv_ind).group_rec.nig_traffic_management
                ,po_message_stack => po_message_stack);
    --
    nem_api.validate_impact_group(pi_nig_rec    => po_group_tab(lv_ind).group_rec
                                 ,po_error_flag => lv_error_flag
                                 ,po_error_text => lv_error_text);
    --
    IF lv_error_flag = 'Y'
     THEN
        add_to_stack(pi_message => 'Validating Impact Group ['||pi_name||']: '||lv_error_text
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END add_impact_group;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE add_schedule(pi_group_name     IN     nem_impact_groups.nig_name%TYPE
                        ,pi_speed_limit    IN     srw_closures.temporary_speed_limit%TYPE
                        ,pi_start_date     IN     DATE
                        ,pi_end_date       IN     DATE
                        ,pi_published_date IN     DATE
                        ,po_schedule_tab   IN OUT schedule_tab
                        ,po_message_stack  IN OUT message_stack_tab)
    IS
    --
    lv_ind         PLS_INTEGER;
    lv_error_flag  VARCHAR2(1);
    lv_error_text  nm3type.max_varchar2;
    --
    lr_empty_schedule  nem_impact_group_schedules%ROWTYPE;
    --
  BEGIN
    --
    lv_ind := po_schedule_tab.COUNT + 1;
    --
    po_schedule_tab(lv_ind) := lr_empty_schedule;
    --
    set_speed_limit(pi_grp_or_schd     => 'SCHD'
                   ,pi_srw_speed_limit => pi_speed_limit
                   ,po_nem_speed_limit => po_schedule_tab(lv_ind).nigs_speed_limit
                   ,po_message_stack   => po_message_stack);
    --
    po_schedule_tab(lv_ind).nigs_planned_startdate := pi_start_date;
    --
    po_schedule_tab(lv_ind).nigs_planned_enddate := pi_end_date;
    --
    IF pi_start_date < pi_published_date
     THEN
         po_schedule_tab(lv_ind).nigs_actual_startdate := pi_start_date;
    END IF;
    --
    IF pi_end_date < pi_published_date
     THEN
        po_schedule_tab(lv_ind).nigs_actual_enddate := pi_end_date;
    END IF;
    --
    nem_api.validate_impact_group_schedule(pi_nigs_rec   => po_schedule_tab(lv_ind)
                                          ,po_error_flag => lv_error_flag
                                          ,po_error_text => lv_error_text);
    --
    IF lv_error_flag = 'Y'
     THEN
        add_to_stack(pi_message => 'Validating Impact Group Schedule built for Impact Group ['||pi_group_name||']: '||lv_error_text
                    ,po_stack   => po_message_stack);
    END IF;
    --
  END add_schedule;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE process_comp_sections(pi_component_key IN     srw_components.component_key%TYPE
                                 ,pi_admin_unit    IN     nm_admin_units_all.nau_admin_unit%TYPE
                                 ,po_pla           IN OUT nm_placement_array
                                 ,po_locations     IN OUT location_tab
                                 ,po_invalid_refs  IN OUT BOOLEAN
                                 ,po_message_stack IN OUT message_stack_tab)
    IS
    --
    lv_length        NUMBER;
    lv_admin_unit    nm_admin_units_all.nau_admin_unit%TYPE;
    lv_invalid_refs  BOOLEAN := FALSE;
    --
    lt_sections  sections_tab;
    lr_location  location_rec;
    --
  BEGIN
    --
    po_locations.DELETE;
    po_pla := nm3pla.initialise_placement_array;
    --
    lt_sections := get_sections(pi_component_key => pi_component_key);
    --
    FOR i IN 1..lt_sections.COUNT LOOP
      --
      BEGIN
        --
        SELECT ne_id
              ,ne_admin_unit
          INTO lr_location.nm_ne_id_of
              ,lv_admin_unit
          FROM nm_elements_all
         WHERE ne_unique = lt_sections(i).label
             ;
        --
        IF lv_admin_unit != pi_admin_unit
         THEN
            add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label||'], the Sections Admin Unit['
                                            ||nm3get.get_nau(lv_admin_unit).nau_name||'] does not match the Closure Admin Unit['
                                            ||nm3get.get_nau(pi_admin_unit).nau_name||'].'
                        ,pi_message_type => c_warning
                        ,po_stack        => po_message_stack );
        ELSE
            --
            lv_length := nm3net.get_ne_length(p_ne_id => lr_location.nm_ne_id_of);
            --
            set_number(pi_value         => LEAST(lt_sections(i).start_offset,lt_sections(i).end_offset)
                      ,pi_target_name   => 'NetworkLocation/FromOffset'
                      ,po_target        => lr_location.nm_begin_mp
                      ,po_message_stack => po_message_stack
                      ,pi_message_type  => c_warning);
            --
            set_number(pi_value         => GREATEST(lt_sections(i).start_offset,lt_sections(i).end_offset)
                      ,pi_target_name   => 'NetworkLocation/ToOffset'
                      ,po_target        => lr_location.nm_end_mp
                      ,po_message_stack => po_message_stack
                      ,pi_message_type  => c_warning);
            /*
            ||Validate the offsets and default the values where required.
            */
            IF lr_location.nm_begin_mp > lv_length
             THEN
                --
                add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label||'] FromOffset['||lr_location.nm_begin_mp
                                                ||'] is greater than the Element Length['||lv_length||'], defaulting to 0.'
                            ,pi_message_type => c_warning
                            ,po_stack        => po_message_stack);
                --
                lr_location.nm_begin_mp := 0;
                --
            ELSIF lr_location.nm_begin_mp < 0
             THEN
                --
                add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label||'] FromOffset['||lr_location.nm_begin_mp
                                                ||'] must be 0 or greater, defaulting to 0.'
                            ,pi_message_type => c_warning
                            ,po_stack        => po_message_stack );
                --
                lr_location.nm_begin_mp := 0;
                --
            ELSIF lr_location.nm_end_mp > lv_length
             THEN
                --
                add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label||'] ToOffset['||lr_location.nm_end_mp
                                                ||'] is greater than the Element Length['||lv_length||'], defaulting to the Element Length.'
                            ,pi_message_type => c_warning
                            ,po_stack        => po_message_stack );
                --
                lr_location.nm_end_mp := lv_length;
                --
            ELSIF lr_location.nm_end_mp < 0
             THEN
                --
                add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label||'] ToOffset['||lr_location.nm_end_mp
                                                ||'] must be 0 or greater, defaulting to the Element Length.'
                            ,pi_message_type => c_warning
                            ,po_stack        => po_message_stack );
                --
                lr_location.nm_end_mp := lv_length;
                --
            END IF;
            --
            IF lr_location.nm_begin_mp = lr_location.nm_end_mp
             THEN
                IF lr_location.nm_end_mp = lv_length
                 THEN
                    --
                    lr_location.nm_begin_mp := lr_location.nm_begin_mp - 1;
                    --
                    add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label
                                                    ||'] From and To Offsets cannot be the same, 1 meter has been removed from the From Offset.'
                                ,pi_message_type => c_warning
                                ,po_stack        => po_message_stack );
                    --
                ELSE
                    --
                    lr_location.nm_end_mp := lr_location.nm_end_mp + 1;
                    --
                    add_to_stack(pi_message      => 'Validating Section ['||lt_sections(i).label
                                                    ||'] From and To Offsets cannot be the same, 1 meter has been added to the To Offset.'
                                ,pi_message_type => c_warning
                                ,po_stack        => po_message_stack );
                    --
                END IF;
            END IF;
            --
            po_locations(po_locations.COUNT+1) := lr_location;
            --
            nm3pla.add_element_to_pl_arr(pio_pl_arr => po_pla
                                        ,pi_ne_id   => lr_location.nm_ne_id_of
                                        ,pi_start   => LEAST(lt_sections(i).start_offset,lt_sections(i).end_offset)
                                        ,pi_end     => GREATEST(lt_sections(i).start_offset,lt_sections(i).end_offset)
                                        ,pi_measure => lt_sections(i).component_start);
            --
        END IF;
        --
      EXCEPTION
       WHEN no_data_found
        THEN
           lv_invalid_refs := TRUE;
           add_to_stack(pi_message      => 'Validating Section : Invalid Element Reference ['||lt_sections(i).label||'].'
                       ,pi_message_type => c_warning
                       ,po_stack        => po_message_stack );
       WHEN too_many_rows
        THEN
           lv_invalid_refs := TRUE;
           add_to_stack(pi_message      => 'Validating Section: Multiple Elements returned for Element Reference ['||lt_sections(i).label||'].'
                       ,pi_message_type => c_warning
                       ,po_stack        => po_message_stack );
       WHEN others
        THEN
           lv_invalid_refs := TRUE;
           add_to_stack(pi_message      => 'Validating Section: ['||lt_sections(i).label||']: '||SQLERRM
                       ,pi_message_type => c_warning
                       ,po_stack        => po_message_stack );
      END;
      --
      po_invalid_refs := lv_invalid_refs;
      --
    END LOOP;
    --
  END process_comp_sections;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE process_components(pi_closure_rec      IN     srw_closures%ROWTYPE
                              ,pi_admin_unit       IN     nm_admin_units_all.nau_admin_unit%TYPE
                              ,po_invalid_network  IN OUT BOOLEAN
                              ,po_impacted_network IN OUT location_tab
                              ,po_impact_groups    IN OUT impact_group_tab
                              ,po_message_stack    IN OUT message_stack_tab)
    IS
    --
    TYPE comp_rec IS RECORD(component_key      srw_components.component_key%TYPE
                           ,closure            srw_components.closure%TYPE
                           ,component_length   srw_components.component_length%TYPE
                           ,name               srw_components.name%TYPE
                           ,lane_count         PLS_INTEGER);
    TYPE comp_tab IS TABLE OF comp_rec;
    lt_components  comp_tab;
    --
    TYPE groups_to_create_rec IS RECORD(name  nem_impact_groups.nig_name%TYPE
                                       ,lanes lanes_tab
                                       ,locs  location_tab);
    TYPE groups_to_create_tab IS TABLE OF groups_to_create_rec INDEX BY BINARY_INTEGER;
    lt_layout_groups  groups_to_create_tab;
    --
    lt_impact_groups     impact_group_tab;
    lt_comp_locations    location_tab;
    lt_impacted_network  location_tab;
    lv_comp_pla          nm_placement_array;
    lt_layouts           layouts_tab;
    lt_lanes             lanes_tab;
    lt_diary             diary_tab;
    lt_schedules         schedule_tab;
    --
    lr_empty_xsp       nem_impact_group_xsps%ROWTYPE;
    lr_empty_schedule  nem_impact_group_schedules%ROWTYPE;
    --
    lv_loc_errors  BOOLEAN;
    lv_error_flag  VARCHAR2(1);
    lv_error_text  nm3type.max_varchar2;
    --
    PROCEDURE add_lane_to_tab(pi_lane       IN     srw_lanes%ROWTYPE
                             ,pi_loc_errors IN     BOOLEAN
                             ,pi_comp_pla   IN     nm_placement_array
                             ,pi_tab        IN OUT groups_to_create_tab)
      IS
      --
      lv_id      BINARY_INTEGER;
      lv_action  VARCHAR2(10);
      --
      PROCEDURE add_lane_location(pi_lane       IN     srw_lanes%ROWTYPE
                                 ,pi_loc_errors IN     BOOLEAN
                                 ,pi_comp_pla   IN     nm_placement_array
                                 ,po_loc_tab    IN OUT location_tab)
        IS
        --
        lv_start_lref nm_lref;
        lv_end_lref   nm_lref;
        --
        lv_lane_pla   nm_placement_array;
        lv_pre_pla    nm_placement_array;
        lv_post_pla   nm_placement_array;
        lv_dummy_pla  nm_placement_array;
        --
      BEGIN
        /*
        ||If no errors occurred when validating the Component Sections
        ||then work out what part of the component the lane covers
        ||otherwise do nothing because the placement array will be invalid.
        */
        IF NOT pi_loc_errors
         THEN
            /*
            ||Get the element and offset for the lane start from the component array.
            */
            lv_start_lref := nm3pla.get_lref_from_measure_in_plarr(pi_comp_pla,pi_lane.from_offset);
            --
            /*
            ||Get the element and offset for the lane end from the component array.
            */
            lv_end_lref := nm3pla.get_lref_from_measure_in_plarr(pi_comp_pla,pi_lane.to_offset);
            --
            /*
            ||Now get the placement array between the two lrefs.
            */
            nm3pla.split_placement_array(this_npa    => pi_comp_pla
                                        ,pi_ne_id    => lv_start_lref.get_ne_id
                                        ,pi_mp       => lv_start_lref.get_offset
                                        ,po_npa_pre  => lv_pre_pla
                                        ,po_npa_post => lv_post_pla);
            --
            nm3pla.split_placement_array(this_npa    => lv_post_pla
                                        ,pi_ne_id    => lv_end_lref.get_ne_id
                                        ,pi_mp       => lv_end_lref.get_offset
                                        ,po_npa_pre  => lv_lane_pla
                                        ,po_npa_post => lv_dummy_pla);
            /*
            ||Populate location.
            */
            IF NOT lv_lane_pla.is_empty
             THEN
                FOR i IN 1..lv_lane_pla.placement_count LOOP
                  --
                  po_loc_tab(po_loc_tab.COUNT+1).nm_ne_id_of := lv_lane_pla.npa_placement_array(i).pl_ne_id;
                  po_loc_tab(po_loc_tab.COUNT).nm_begin_mp := lv_lane_pla.npa_placement_array(i).pl_start;
                  po_loc_tab(po_loc_tab.COUNT).nm_end_mp := lv_lane_pla.npa_placement_array(i).pl_end;
                  --
                END LOOP;
            END IF;
            --
        END IF;
        --
      END add_lane_location;
      --
    BEGIN
      /*
      ||Check to see if there is already a group with this lane included.
      */
      FOR i IN 1..pi_tab.COUNT LOOP
        /*
        ||Start with the assumption that the Lane can be added
        ||to the current group and evaluate this assumption.
        */
        lv_action := 'ADD';
        --
        FOR j IN 1..pi_tab(i).lanes.COUNT LOOP
          --
          IF pi_tab(i).lanes(j).lane = pi_lane.lane
           THEN
              /*
              ||Lane already exists in this group.
              */
              IF pi_tab(i).lanes(j).lane_status = pi_lane.lane_status
               THEN
                  /*
                  ||Lane Status is the same so just add the location.
                  */
                  lv_action := 'ADDLOCS';
              ELSE
                  /*
                  ||Lane Status is different but may exist in another group so keep checking.
                  ||If no more groups exist then a new one will be created.
                  */
                  lv_action := 'NEWGROUP';
              END IF;
              --
              EXIT;
              --
          END IF;
          --
        END LOOP;
        --
        IF lv_action = 'ADD'
         THEN
            /*
            ||Lane was not found so add it and the location to the group.
            */
            pi_tab(i).lanes(pi_tab(i).lanes.COUNT+1) := pi_lane;
            add_lane_location(pi_lane       => pi_lane
                             ,pi_loc_errors => pi_loc_errors
                             ,pi_comp_pla   => pi_comp_pla
                             ,po_loc_tab    => pi_tab(i).locs);
            EXIT;
        ELSIF lv_action = 'ADDLOCS'
         THEN
            /*
            ||Lane was found so need to add the location to the group.
            */
            add_lane_location(pi_lane       => pi_lane
                             ,pi_loc_errors => pi_loc_errors
                             ,pi_comp_pla   => pi_comp_pla
                             ,po_loc_tab    => pi_tab(i).locs);
            EXIT;
        END IF;
        --
      END LOOP;
      /*
      ||Create a new group and add the Lane and location if required.
      */
      IF lv_action = 'NEWGROUP'
       THEN
          lv_id := pi_tab.COUNT+1;
          pi_tab(lv_id).name := pi_tab(1).name||' ('||TO_CHAR(lv_id)||')';
          pi_tab(lv_id).lanes(1) := pi_lane;
          add_lane_location(pi_lane       => pi_lane
                           ,pi_loc_errors => pi_loc_errors
                           ,pi_comp_pla   => pi_comp_pla
                           ,po_loc_tab    => pi_tab(lv_id).locs);
      END IF;
      --
    END add_lane_to_tab;
    --
  BEGIN
    --
    SELECT com.*
          ,(SELECT count(*)
              FROM srw_lanes lanes
             WHERE lanes.component_key = com.component_key)
      BULK COLLECT
      INTO lt_components
      FROM srw_components com
     WHERE com.closure = pi_closure_rec.closure
       AND EXISTS(SELECT 'x'
                    FROM srw_sections sec
                   WHERE sec.component_key = com.component_key)
         ;
    --
    IF g_debug
     THEN
        add_to_stack(pi_message      => 'Processing '||lt_components.COUNT||' Components.'
                    ,pi_message_type => c_debug
                    ,po_stack        => po_message_stack);
    END IF;
    --
    FOR i IN 1..lt_components.COUNT LOOP
      --
      process_comp_sections(pi_component_key => lt_components(i).component_key
                           ,pi_admin_unit    => pi_admin_unit
                           ,po_pla           => lv_comp_pla
                           ,po_locations     => lt_comp_locations
                           ,po_invalid_refs  => lv_loc_errors
                           ,po_message_stack => po_message_stack);
      /*
      ||If any of the components have invalid locations
      ||communicate this to the calling procedure.
      */
      IF lv_loc_errors
       THEN
          po_invalid_network := TRUE;
      END IF;
      /*
      ||Add the locations to the overall Impacted Network.
      */
      FOR j IN 1..lt_comp_locations.COUNT LOOP
        lt_impacted_network(lt_impacted_network.COUNT+1) := lt_comp_locations(j);
      END LOOP;
      --
      IF lt_components(i).lane_count = 0
       THEN
          /*
          ||No Lanes so just build a Group for the whole component.
          */
          add_impact_group(pi_name          => lt_components(i).name
                          ,pi_closure_rec   => pi_closure_rec
                          ,po_group_tab     => lt_impact_groups
                          ,po_message_stack => po_message_stack);
          /*
          ||Set the locations.
          */
          lt_impact_groups(lt_impact_groups.COUNT).locations := lt_comp_locations;
          /*
          ||Build an Impact Group Schedule record based on the Closure Start and End Dates.
          */
          add_schedule(pi_group_name     => lt_impact_groups(lt_impact_groups.COUNT).group_rec.nig_name
                      ,pi_speed_limit    => pi_closure_rec.temporary_speed_limit
                      ,pi_start_date     => pi_closure_rec.start_date
                      ,pi_end_date       => pi_closure_rec.end_date
                      ,pi_published_date => pi_closure_rec.published_date
                      ,po_schedule_tab   => lt_impact_groups(lt_impact_groups.COUNT).schedules
                      ,po_message_stack  => po_message_stack);
          --
      ELSE
          /*
          ||Get associated Layouts.
          */
          lt_layouts := get_layouts(pi_component_key => lt_components(i).component_key);
          --
          FOR j IN 1..lt_layouts.COUNT LOOP
            /*
            ||Get the Layout Diary.
            */
            lt_schedules.DELETE;
            --
            lt_diary := get_diary(pi_layout_key => lt_layouts(j).layout_key);
            --
            FOR k IN 1..lt_diary.COUNT LOOP
              --
              add_schedule(pi_group_name     => lt_components(i).name||' - '||lt_layouts(j).name
                          ,pi_speed_limit    => pi_closure_rec.temporary_speed_limit
                          ,pi_start_date     => lt_diary(k).start_date
                          ,pi_end_date       => lt_diary(k).end_date
                          ,pi_published_date => pi_closure_rec.published_date
                          ,po_schedule_tab   => lt_schedules
                          ,po_message_stack  => po_message_stack);
              --
            END LOOP;
            /*
            ||Build the Groups required to represent the Component\Layout.
            */
            --
            lt_layout_groups.DELETE;
            --
            lt_layout_groups(1).name := lt_components(i).name||' - '||lt_layouts(j).name;
            --
            lt_lanes := get_lanes(pi_component_key => lt_components(i).component_key
                                 ,pi_layout_key    => lt_layouts(j).layout_key);
            --
            FOR k IN 1..lt_lanes.COUNT LOOP
              --
              add_lane_to_tab(pi_lane       => lt_lanes(k)
                             ,pi_loc_errors => lv_loc_errors
                             ,pi_comp_pla   => lv_comp_pla
                             ,pi_tab        => lt_layout_groups);
              --
            END LOOP;
            --
            FOR k IN 1..lt_layout_groups.COUNT LOOP
              --
              add_impact_group(pi_name          => lt_layout_groups(k).name
                              ,pi_closure_rec   => pi_closure_rec
                              ,po_group_tab     => lt_impact_groups
                              ,po_message_stack => po_message_stack);
              /*
              ||Set the locations.
              */
              IF NOT lv_loc_errors
               THEN
                  lt_impact_groups(lt_impact_groups.COUNT).locations := lt_layout_groups(k).locs;
              END IF;
              /*
              ||Set the XSPs
              */
              FOR m IN 1..lt_layout_groups(k).lanes.COUNT LOOP
                --
                lt_impact_groups(lt_impact_groups.COUNT).changes(m) := lr_empty_xsp;
                --
                set_xsp(pi_lane          => lt_layout_groups(k).lanes(m).lane
                       ,po_xsp           => lt_impact_groups(lt_impact_groups.COUNT).changes(m).nigx_xsp
                       ,po_message_stack => po_message_stack);
                --
                set_reason(pi_lane_status   => lt_layout_groups(k).lanes(m).lane_status
                          ,po_reason        => lt_impact_groups(lt_impact_groups.COUNT).changes(m).nigx_reason
                          ,po_message_stack => po_message_stack);
                --
                nem_api.validate_impact_group_xsp(pi_nigx_rec   => lt_impact_groups(lt_impact_groups.COUNT).changes(m)
                                                 ,po_error_flag => lv_error_flag
                                                 ,po_error_text => lv_error_text);
                --
                IF lv_error_flag = 'Y'
                 THEN
                    add_to_stack(pi_message => 'Validating Impact Group Change built from Layout['||lt_layouts(j).name||']: '||lv_error_text
                                ,po_stack   => po_message_stack);
                    lv_error_flag := 'N';
                    lv_error_text := NULL;
                END IF;
                /*
                ||Set the Schedules.
                */
                lt_impact_groups(lt_impact_groups.COUNT).schedules := lt_schedules;
                --
              END LOOP;
              --
            END LOOP;
            --
          END LOOP;
      END IF;
      --
    END LOOP;
    --
    po_impact_groups := lt_impact_groups;
    po_impacted_network := lt_impacted_network;
    --
  EXCEPTION
    WHEN others
     THEN
        add_to_stack(pi_message => 'Error Creating Event: '||dbms_utility.format_error_backtrace
                    ,po_stack   => po_message_stack);
        flush_stack(po_stack => po_message_stack);
  END process_components;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE execute_validation(pi_event_id  IN     nem_events.nevt_id%TYPE
                              ,po_validated IN OUT BOOLEAN)
    IS
    --
    lv_dummy      PLS_INTEGER;
    lv_validated  BOOLEAN := TRUE;
    --
    lt_ids       nem_actions_api.object_ids_tab;
    lt_messages  nem_message_tab;
    --
  BEGIN
    /*
    ||Execute the validate action.
    */
    lt_ids(1) := pi_event_id;
    nem_actions_api.execute_action(p_script_name    => 'Validate'
                                  ,p_object_ids_tab => lt_ids
                                  ,p_context        => 'NEM_EVENTS');
    /*
    ||Check for problems running the action.
    */
    lt_messages := nem_actions_api.get_messages;
    --
    lv_validated := TRUE;
    --
    FOR i IN 1..lt_messages.COUNT LOOP
      --
      IF lt_messages(i).message_category = 1
       THEN
          --
          lv_validated := FALSE;
          --
      END IF;
      --
    END LOOP;
    --
    IF lv_validated
     THEN
        /*
        ||Check for validation errors.
        */
        BEGIN
          SELECT 1
            INTO lv_dummy
            FROM dual
           WHERE EXISTS(SELECT 'x'
                          FROM nem_action_execution_results
                         WHERE naer_naex_id IN(SELECT naex_id
                                                 FROM nem_action_executions
                                                WHERE naex_nevt_id = pi_event_id
                                                  AND naex_na_id = (SELECT na_id
                                                                      FROM nem_actions
                                                                     WHERE na_label = 'Validate'))
                           AND naer_message_category = 'ERROR')
               ;
          --
          lv_validated := FALSE;
          --
        EXCEPTION
          WHEN no_data_found
           THEN
              NULL;
        END;
        --
    END IF;
    --
    po_validated := lv_validated;
    --
  END execute_validation;

  --
  --------------------------------------------------------------------------------
  --
  PROCEDURE process_closures(pi_srw_operational_area IN srw_closures.operational_area%TYPE
                            ,pi_validation_only      IN BOOLEAN DEFAULT FALSE)
    IS
    --
    lt_message_stack  message_stack_tab;
    --
    lt_closures           closure_tab;
    --
    lr_event             nem_api.event_rec;
    lt_attr              nem_util.flex_attr_tab;
    lt_nec               nec_tab;
    lt_impacted_network  location_tab;
    lt_impact_groups     impact_group_tab;
    --
    --lr_empty_group     nem_impact_groups%ROWTYPE;
    --
    lv_execution_id      PLS_INTEGER;
    lv_naex_id           nem_action_executions.naex_id%TYPE;
    lv_event_id          nem_events.nevt_id%TYPE;
    lv_event_number      nm3type.max_varchar2;
    lv_contact_id        nem_event_contacts.nec_id%TYPE;
    lv_impact_group_id   nm_inv_items_all.iit_ne_id%TYPE;
    lv_nigx_id           nem_impact_group_xsps.nigx_id%TYPE;
    lv_nigs_id           nem_impact_group_schedules.nigs_id%TYPE;
    lv_event_status      nm_inv_attri_lookup_all.ial_value%TYPE;
    lv_nature_of_works   nm_inv_attri_lookup_all.ial_value%TYPE;
    lv_delay             nm_inv_attri_lookup_all.ial_value%TYPE;
    lv_val_attr_value    nm3type.max_varchar2;
    lv_val_attr_meaning  nm3type.max_varchar2;
    lv_error_flag        VARCHAR2(1);
    lv_error_text        nm3type.max_varchar2;
    lv_operational_area  srw_closures.operational_area%TYPE;
    lv_invalid_network   BOOLEAN;
    lv_validated         BOOLEAN;
    --
    CURSOR get_closures
        IS
    SELECT *
      FROM srw_closures
     WHERE closure = closure_parent /*Latest Version of each closure*/
       AND published != 'X'
       AND nature_of_works NOT IN('NA','EWU','OTH','TRAIN')
       AND activity != 'NA'
       AND closure_status != 'COMP'
       AND operational_area = NVL(pi_srw_operational_area,operational_area)
       AND closure NOT IN(SELECT iit_num_attrib19
                            FROM nm_inv_items_all
                           WHERE iit_inv_type = 'NEVT')
     ORDER
        BY operational_area
          ,closure
         ;
    --
  BEGIN
    /*
    ||Get the closures to convert.
    */
    OPEN get_closures;
    --
    LOOP
      --
      FETCH get_closures
       BULK COLLECT
       INTO lt_closures
      LIMIT 100;
      --
      FOR i IN 1..lt_closures.COUNT LOOP
        /*
        ||Log start of the load.
        */
        IF NVL(g_operational_area,'@@@@@') != lt_closures(i).operational_area
         THEN
            g_operational_area := lt_closures(i).operational_area;
            add_to_stack(pi_message      => 'Starting to process Closures for Operaitional Area ['||g_operational_area||']'
                        ,pi_message_type => c_information
                        ,po_stack        => lt_message_stack);
        END IF;
        /*
        ||Set the closure global.
        */
        g_closure := lt_closures(i).closure;
        --
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Starting to translate and validate Closure.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        /*
        ||Build the Event Record.
        */
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Init Event Record and Impacted Network Tab.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        --
        init_event_rec(po_event_rec => lr_event);
        lt_impacted_network.DELETE;
        lt_impact_groups.DELETE;
        --
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Set Event Properties.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        --
        set_admin_unit(pi_operational_area => lt_closures(i).operational_area
                      ,po_admin_unit       => lr_event.admin_unit
                      ,po_message_stack    => lt_message_stack);
        --
        set_varchar2(pi_value         => SUBSTR(lt_closures(i).description,1,500)
                    ,pi_target_name   => 'Event Description'
                    ,po_target        => lr_event.description
                    ,po_message_stack => lt_message_stack);
        --
        set_event_type(pi_srw_activity        => lt_closures(i).activity
                      ,pi_srw_closure_type    => lt_closures(i).closure_type
                      ,pi_srw_nature_of_works => lt_closures(i).nature_of_works
                      ,po_event_type          => lr_event.event_type
                      ,po_message_stack       => lt_message_stack);
        --
        set_event_status(pi_srw_status    => lt_closures(i).closure_status
                        ,po_nem_status    => lv_event_status
                        ,po_message_stack => lt_message_stack);
        --
        lr_event.data_source := 'MIGRATED';
        --
        lr_event.planned_start_date := lt_closures(i).start_date;
        --
        lr_event.planned_complete_date := lt_closures(i).end_date;
        --
        IF lt_closures(i).start_date < lt_closures(i).published_date
         THEN
            lr_event.actual_start_date := lt_closures(i).start_date;
        END IF;
        --
        lr_event.validation_state := nem_util.c_requires_validation;
        /*
        ||Build the Event Attributes records.
        */
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Set Event Flex Attributes.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        lt_attr.DELETE;
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'DISTRIBUTE'
                                ,pi_char_value    => SUBSTR(lt_closures(i).record_visible_to_public,1,1)
                                ,pi_attr_tab      => lt_attr);
        --
        set_nature_of_works(pi_srw_nature_of_works => lt_closures(i).nature_of_works
                           ,po_nem_nature_of_works => lv_nature_of_works
                           ,po_message_stack       => lt_message_stack);
        nem_util.add_to_attr_tab(pi_view_col_name => 'NATURE_OF_WORKS'
                                ,pi_char_value    => lv_nature_of_works
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'USER_RESPONSIBLE'
                                ,pi_char_value    => lt_closures(i).login
                                ,pi_attr_tab      => lt_attr);
        --
        set_delay(pi_expected_delay   => lt_closures(i).expected_delay
                 ,po_delay            => lv_delay
                 ,po_message_stack    => lt_message_stack);
        nem_util.add_to_attr_tab(pi_view_col_name => 'DELAY'
                                ,pi_char_value    => lv_delay
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'HE_REF'
                                ,pi_char_value    => lt_closures(i).reference_number
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'WORKS_REF'
                                ,pi_char_value    => lt_closures(i).contract_number
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'TMA_WORKS_REF'
                                ,pi_char_value    => CASE
                                                       WHEN SUBSTR(lt_closures(i).eton_reference,1,5) = 'ETON_'
                                                         THEN SUBSTR(lt_closures(i).eton_reference,6)
                                                       ELSE lt_closures(i).eton_reference
                                                     END
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'MOBILE_LANE_CLOSURE'
                                ,pi_char_value    => CASE
                                                       WHEN lt_closures(i).traffic_management = 'MOBLACL'
                                                         THEN 'Y'
                                                       ELSE 'N'
                                                     END
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'SRW_ID'
                                ,pi_char_value    => lt_closures(i).closure
                                ,pi_attr_tab      => lt_attr);
        --
        nem_util.add_to_attr_tab(pi_view_col_name => 'NOTES'
                                ,pi_char_value    => SUBSTR(lt_closures(i).notes,1,500)
                                ,pi_attr_tab      => lt_attr);
        /*
        ||Validate the flexible attributes.
        */
        FOR j IN 1..lt_attr.COUNT LOOP
          --
          nem_api.validate_event_attrib_value(pi_attrib_name     => lt_attr(j).attrib_name
                                             ,pi_value           => lt_attr(j).char_value
                                             ,po_formatted_value => lv_val_attr_value
                                             ,po_meaning         => lv_val_attr_meaning
                                             ,po_error_flag      => lv_error_flag
                                             ,po_error_text      => lv_error_text);
          --
          IF lv_error_flag = 'Y'
           THEN
              add_to_stack(pi_message => 'Validating Attribute['||lt_attr(j).scrn_text||']: '||lv_error_text
                          ,po_stack   => lt_message_stack);
              lv_error_flag := 'N';
              lv_error_text := NULL;
          END IF;
          --
        END LOOP;
        /*
        ||Build the Event Contacts records.
        */
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Set Event Contacts.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        --
        lt_nec.DELETE;
        --
        IF lt_closures(i).project_manager IS NOT NULL
         THEN
            --
            lt_nec(lt_nec.COUNT+1).nec_type := 'PROJECT MANAGER';
            --
            set_varchar2(pi_value         => lt_closures(i).project_manager
                        ,pi_target_name   => 'Project Manager Contact Name'
                        ,po_target        => lt_nec(lt_nec.COUNT).nec_name
                        ,po_message_stack => lt_message_stack);
            --
            IF LENGTH(lt_closures(i).project_manager_tel) > 20
             THEN
                set_varchar2(pi_value         => 'See Notes'
                            ,pi_target_name   => 'Project Manager Contact Telephone'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_day_telephone
                            ,po_message_stack => lt_message_stack);
                set_varchar2(pi_value         => lt_closures(i).project_manager_tel
                            ,pi_target_name   => 'Project Manager Contact Notes'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_notes
                            ,po_message_stack => lt_message_stack);
            ELSE
                set_varchar2(pi_value         => lt_closures(i).project_manager_tel
                            ,pi_target_name   => 'Project Manager Contact Telephone'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_day_telephone
                            ,po_message_stack => lt_message_stack);
            END IF;
            --
            nem_api.validate_event_contact(pi_nec_rec    => lt_nec(lt_nec.COUNT)
                                          ,po_error_flag => lv_error_flag
                                          ,po_error_text => lv_error_text);
            --
            IF lv_error_flag = 'Y'
             THEN
                add_to_stack(pi_message => 'Validating Project Manager Contact: '||lv_error_text
                            ,po_stack   => lt_message_stack);
                lv_error_flag := 'N';
                lv_error_text := NULL;
            END IF;
            --
        END IF;
        --
        IF lt_closures(i).contractor_name IS NOT NULL
         THEN
            --
            lt_nec(lt_nec.COUNT+1).nec_type := 'CONTRACTOR';
            --
            set_varchar2(pi_value         => lt_closures(i).contractor_name
                        ,pi_target_name   => 'Contractor Contact Name'
                        ,po_target        => lt_nec(lt_nec.COUNT).nec_name
                        ,po_message_stack => lt_message_stack);
            --
            IF LENGTH(lt_closures(i).contractor_tel) > 20
             THEN
                set_varchar2(pi_value         => 'See Notes'
                            ,pi_target_name   => 'Contractor Contact Telephone'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_day_telephone
                            ,po_message_stack => lt_message_stack);
                set_varchar2(pi_value         => lt_closures(i).contractor_tel
                            ,pi_target_name   => 'Contractor Contact Notes'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_notes
                            ,po_message_stack => lt_message_stack);
            ELSE
                set_varchar2(pi_value         => lt_closures(i).contractor_tel
                            ,pi_target_name   => 'Contractor Contact Telephone'
                            ,po_target        => lt_nec(lt_nec.COUNT).nec_day_telephone
                            ,po_message_stack => lt_message_stack);
            END IF;
            --
            nem_api.validate_event_contact(pi_nec_rec    => lt_nec(lt_nec.COUNT)
                                          ,po_error_flag => lv_error_flag
                                          ,po_error_text => lv_error_text);
            --
            IF lv_error_flag = 'Y'
             THEN
                add_to_stack(pi_message => 'Validating Contractor Contact: '||lv_error_text
                            ,po_stack   => lt_message_stack);
                lv_error_flag := 'N';
                lv_error_text := NULL;
            END IF;
            --
        END IF;
        /*
        ||Build the Event Impacted Network Locations And Impact Groups.
        */
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Process Components.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        --
        lv_invalid_network := FALSE;
        --
        process_components(pi_closure_rec      => lt_closures(i)
                          ,pi_admin_unit       => lr_event.admin_unit
                          ,po_invalid_network  => lv_invalid_network
                          ,po_impacted_network => lt_impacted_network
                          ,po_impact_groups    => lt_impact_groups
                          ,po_message_stack    => lt_message_stack);
        /*
        ||Create the data.
        */
        IF NOT stack_contains_errors(pi_stack => lt_message_stack)
         THEN
            --
            IF g_debug
             THEN
                add_to_stack(pi_message      => 'Starting to Create the Data.'
                            ,pi_message_type => c_debug
                            ,po_stack        => lt_message_stack);
            END IF;
            --
            IF pi_validation_only
             THEN
                add_to_stack(pi_message      => 'Closure validated.'
                            ,pi_message_type => c_information
                            ,po_stack        => lt_message_stack);
            ELSE
                --
                IF g_debug
                 THEN
                    add_to_stack(pi_message      => 'Creating Event.'
                                ,pi_message_type => c_debug
                                ,po_stack        => lt_message_stack);
                END IF;
                /*
                ||Create the Event.
                */
                BEGIN
                  /*
                  ||Set a save point.
                  */
                  SAVEPOINT closure_to_event_sp;
                  --
                  lv_execution_id := nem_execution_api.start_execution (pi_parent_execution_id => NULL);
                  --
                  nem_api.create_event(pi_event_rec           => lr_event
                                      ,pi_attributes          => lt_attr
                                      ,pi_parent_execution_id => lv_execution_id
                                      ,pi_commit              => 'N'
                                      ,po_event_id            => lv_event_id
                                      ,po_event_number        => lv_event_number
                                      ,po_error_flag          => lv_error_flag
                                      ,po_error_text          => lv_error_text);
                  --
                  IF lv_error_flag = 'Y'
                   THEN
                      raise_application_error (-20001, lv_error_text);
                  END IF;
                  /*
                  ||Create Event Contacts.
                  */
                  IF g_debug
                   THEN
                      add_to_stack(pi_message      => 'Creating Contacts.'
                                  ,pi_message_type => c_debug
                                  ,po_stack        => lt_message_stack);
                  END IF;
                  --
                  FOR j IN 1..lt_nec.COUNT LOOP
                     --
                     lt_nec(j).nec_nevt_id := lv_event_id;
                     lt_nec(j).nec_id := nec_id_seq.NEXTVAL;
                     --
                  END LOOP;
                  --
                  FORALL j IN 1..lt_nec.COUNT
                    INSERT
                      INTO nem_event_contacts
                    VALUES lt_nec(j)
                         ;
                  /*
                  ||Create the Impacted Network.
                  */
                  IF g_debug
                   THEN
                      add_to_stack(pi_message      => 'Adding Impacted Network.'
                                  ,pi_message_type => c_debug
                                  ,po_stack        => lt_message_stack);
                  END IF;
                  --
                  add_locations(pi_iit_ne_id     => lv_event_id
                               ,pi_nit_inv_type  => nem_util.get_event_inv_type
                               ,pi_locations     => lt_impacted_network
                               ,po_message_stack => lt_message_stack);
                  /*
                  ||Create the Impact Groups.
                  */
                  FOR j in 1..lt_impact_groups.COUNT LOOP
                    --
                    IF g_debug
                     THEN
                        add_to_stack(pi_message      => 'Creating Impact Group['||lt_impact_groups(j).group_rec.nig_name||'].'
                                    ,pi_message_type => c_debug
                                    ,po_stack        => lt_message_stack);
                    END IF;
                    --
                    lt_impact_groups(j).group_rec.nig_nevt_id := lv_event_id;
                    --
                    nem_api.create_impact_group(pi_nig_rec         => lt_impact_groups(j).group_rec
                                               ,pi_commit          => 'N'
                                               ,po_impact_group_id => lv_impact_group_id
                                               ,po_error_flag      => lv_error_flag
                                               ,po_error_text      => lv_error_text);
                    IF lv_error_flag = 'Y'
                     THEN
                        raise_application_error (-20001, 'Impact Group['||lt_impact_groups(j).group_rec.nig_name||']: '||lv_error_text);
                    END IF;
                    /*
                    ||Create the Impact Group Locations.
                    */
                    IF g_debug
                     THEN
                        add_to_stack(pi_message      => 'Creating Impact Group Locations.'
                                    ,pi_message_type => c_debug
                                    ,po_stack        => lt_message_stack);
                    END IF;
                    --
                    add_locations(pi_iit_ne_id     => lv_impact_group_id
                                 ,pi_nit_inv_type  => nem_util.get_impact_group_inv_type
                                 ,pi_locations     => lt_impact_groups(j).locations
                                 ,po_message_stack => lt_message_stack);
                    /*
                    ||Create the Impact Group Changes.
                    */
                    IF g_debug
                     THEN
                        add_to_stack(pi_message      => 'Creating '||lt_impact_groups(j).changes.COUNT||' Impact Group XSPs.'
                                    ,pi_message_type => c_debug
                                    ,po_stack        => lt_message_stack);
                    END IF;
                    --
                    FOR k IN 1..lt_impact_groups(j).changes.COUNT LOOP
                      --
                      lt_impact_groups(j).changes(k).nigx_nig_id := lv_impact_group_id;
                      lt_impact_groups(j).changes(k).nigx_id := nigx_id_seq.nextval;
                      --
                    END LOOP;
                    --
                    FORALL k IN 1..lt_impact_groups(j).changes.COUNT
                      INSERT
                        INTO nem_impact_group_xsps
                      VALUES lt_impact_groups(j).changes(k)
                          ;
                    /*
                    ||Create the Impact Group Schedules.
                    */
                    IF g_debug
                     THEN
                        add_to_stack(pi_message      => 'Creating '||lt_impact_groups(j).schedules.COUNT||' Impact Group Schedules.'
                                    ,pi_message_type => c_debug
                                    ,po_stack        => lt_message_stack);
                    END IF;
                    --
                    FOR k in 1..lt_impact_groups(j).schedules.COUNT LOOP
                      --
                      lt_impact_groups(j).schedules(k).nigs_nig_id := lv_impact_group_id;
                      lt_impact_groups(j).schedules(k).nigs_id := nigs_id_seq.nextval;
                      --
                    END LOOP;
                    --
                    FORALL k IN 1..lt_impact_groups(j).schedules.COUNT
                      INSERT
                        INTO nem_impact_group_schedules
                      VALUES lt_impact_groups(j).schedules(k)
                          ;
                    --
                  END LOOP;
                  --
                  IF g_debug
                   THEN
                      add_to_stack(pi_message      => 'Recalculting "No Impact" Group.'
                                  ,pi_message_type => c_debug
                                  ,po_stack        => lt_message_stack);
                  END IF;
                  --
                  nem_api.recalculate_no_impact(pi_nevt_id    => lv_event_id
                                               ,po_error_flag => lv_error_flag
                                               ,po_error_text => lv_error_text);
                  --
                  IF lv_error_flag = 'Y'
                   THEN
                      raise_application_error (-20001, 'Error re-calculating the no impact group: '||lv_error_text);
                  END IF;
                  /*
                  ||Create Action Executions.
                  */
                  IF g_debug
                   THEN
                      add_to_stack(pi_message      => 'Creating Migration Action.'
                                  ,pi_message_type => c_debug
                                  ,po_stack        => lt_message_stack);
                  END IF;
                  /*
                  ||Migration To NEM.
                  */
                  lv_naex_id := NULL;
                  nem_execution_api.add_execution_record(pi_execution_id   => lv_execution_id
                                                        ,pi_nevt_id        => lv_event_id
                                                        ,pi_description    => 'Initial Data Load'
                                                        ,pi_success        => 'Yes'
                                                        ,pi_summary_result => 'Event Created.'
                                                        ,po_naex_id        => lv_naex_id
                                                        ,po_error_flag     => lv_error_flag
                                                        ,po_error_text     => lv_error_text);
                  --
                  FOR j in 1..lt_message_stack.COUNT LOOP
                    --
                    IF lt_message_stack(j).stn_message_type = c_warning
                     THEN
                        nem_execution_api.add_action_exe_result(pi_naex_id          => lv_naex_id
                                                               ,pi_message_category => lt_message_stack(j).stn_message_type
                                                               ,pi_message          => lt_message_stack(j).stn_message
                                                               ,po_error_flag       => lv_error_flag
                                                               ,po_error_text       => lv_error_text);
                    END IF;
                    --
                  END LOOP;
                  --
                  IF lv_error_flag = 'Y'
                   THEN
                      raise_application_error(-20001,lv_error_text);
                  END IF;
                  /*
                  ||SRW Created Action.
                  */
                  INSERT
                    INTO nem_action_executions
                        (naex_id
                        ,naex_nevt_id
                        ,naex_execution_date
                        ,naex_user_name
                        ,naex_description
                        ,naex_success
                        ,naex_summary_result
                        ,naex_notes
                        ,naex_na_id)
                  SELECT naex_id_seq.nextval
                        ,lv_event_id
                        ,lt_closures(i).published_date
                        ,USER
                        ,'Create Event'
                        ,'Yes'
                        ,'Event Created (In SRW).'
                        ,NULL
                        ,NULL
                    FROM dual
                       ;
                  /*
                  ||Escalations.
                  */
                  INSERT
                    INTO nem_action_executions
                        (naex_id
                        ,naex_nevt_id
                        ,naex_execution_date
                        ,naex_user_name
                        ,naex_description
                        ,naex_success
                        ,naex_summary_result
                        ,naex_notes
                        ,naex_na_id)
                  SELECT naex_id_seq.nextval
                        ,lv_event_id
                        ,escalation_date
                        ,USER
                        ,na_label
                        ,'Yes'
                        ,na_label
                        ,NULL
                        ,na_id
                    FROM (SELECT closure_parent
                                ,escalation
                                ,MIN(published_date) escalation_date
                            FROM srw_closures
                           WHERE escalation != 'NONE'
                           GROUP
                              BY closure_parent
                                ,escalation) escalations
                        ,(SELECT na_id
                                ,na_label
                                ,CASE na_label
                                   WHEN 'Raised to Stage 1' THEN 'S1NO'
                                   WHEN 'Raised to Stage 2' THEN 'S2NO'
                                   WHEN 'Raised to Stage 3' THEN 'S3NO'
                                   WHEN 'Resolved at Stage 1' THEN 'S1YES'
                                   WHEN 'Resolved at Stage 2' THEN 'S2YES'
                                   WHEN 'Resolved at Stage 3' THEN 'S3YES'
                                   ELSE '~~~~~~~~~~~'
                                 END srw_value
                            FROM nem_actions
                           WHERE na_label LIKE 'Raised to Stage%'
                              OR na_label LIKE 'Resolved at Stage%') actions
                   WHERE srw_value = escalation
                     AND closure_parent = lt_closures(i).closure
                       ;
                  /*
                  ||Run the Validate Action.
                  */
                  execute_validation(pi_event_id  => lv_event_id
                                    ,po_validated => lv_validated);
                  /*
                  ||Update the status if everything is ok.
                  */
                  IF lv_validated
                   AND NOT lv_invalid_network
                   THEN
                      IF g_debug
                       THEN
                          add_to_stack(pi_message      => 'Setting Event Status to '||lv_event_status||'.'
                                      ,pi_message_type => c_debug
                                      ,po_stack        => lt_message_stack);
                      END IF;
                      /*
                      ||Set the Event Status.
                      */
                      UPDATE nm_inv_items_all
                         SET iit_chr_attrib28 = lv_event_status
                       WHERE iit_ne_id = lv_event_id
                           ;
                      /*
                      ||Published\Shared in SRW Action.
                      */
                      INSERT
                        INTO nem_action_executions
                            (naex_id
                            ,naex_nevt_id
                            ,naex_execution_date
                            ,naex_user_name
                            ,naex_description
                            ,naex_success
                            ,naex_summary_result
                            ,naex_notes
                            ,naex_na_id)
                      SELECT naex_id_seq.nextval
                            ,lv_event_id
                            ,lt_closures(i).published_date
                            ,USER
                            ,DECODE(lv_event_status,'PUBLISHED','Publish','Share')
                            ,'Yes'
                            ,nem_util.get_formatted_event_number(lv_event_id)||DECODE(lv_event_status,'PUBLISHED',' set to Published (In SRW).',' set to Shared (In SRW).')
                            ,NULL
                            ,DECODE(lv_event_status,'PUBLISHED',3,2)
                        FROM dual
                           ;
                      --
                  END IF;
                  /*
                  ||Log creation of the Event.
                  */
                  add_to_stack(pi_message      => 'Event created ['||nem_util.get_formatted_event_number(pi_nevt_id => lv_event_id)||'].'
                              ,pi_message_type => c_information
                              ,po_stack        => lt_message_stack);
                  --
                EXCEPTION
                  WHEN others
                   THEN
                      add_to_stack(pi_message => 'Error Creating Event: SQLERRM = '||SQLERRM||' Stack='||dbms_utility.format_error_backtrace
                                  ,po_stack   => lt_message_stack);
                      flush_stack(po_stack => lt_message_stack);
                      ROLLBACK TO closure_to_event_sp;
                END;
            END IF;
            --
        END IF;
        --
        IF g_debug
         THEN
            add_to_stack(pi_message      => 'Translation and validation of Closure complete.'
                        ,pi_message_type => c_debug
                        ,po_stack        => lt_message_stack);
        END IF;
        /*
        ||Log any messages.
        */
        flush_stack(po_stack => lt_message_stack);
        --
      END LOOP;
      --
      COMMIT;
      --
      EXIT WHEN get_closures%NOTFOUND;
      --
    END LOOP;
    --
    CLOSE get_closures;
    /*
    ||Populate NEM_ROADS.
    */
    refresh_nem_roads;
    --
  EXCEPTION
    WHEN others
     THEN
        add_to_stack(pi_message => 'Error Creating Event: SQLERRM = '||SQLERRM||' Stack='||dbms_utility.format_error_backtrace
                    ,po_stack   => lt_message_stack);
        flush_stack(po_stack => lt_message_stack);
        RAISE;
  END process_closures;
--
-----------------------------------------------------------------------------
--
BEGIN
  /*
  ||Admin Unit Mapping.
  ||The index is the SRW Operational Area, the assignment is the NEM Admin Unit.
  ||Any assignments of NULL indicate that no sensible mapping of the SRW value
  ||can be determined.
  */
  g_au_lookup('2NDSC')  := 'A35';
  g_au_lookup('A01')    := 'A01';
  g_au_lookup('A02')    := 'A02';
  g_au_lookup('A03')    := 'A03';
  g_au_lookup('A04')    := 'A04';
  g_au_lookup('A05')    := NULL;
  g_au_lookup('A06')    := 'A06';
  g_au_lookup('A07')    := 'A07';
  g_au_lookup('A08')    := 'A08';
  g_au_lookup('A09')    := 'A09';
  g_au_lookup('A10')    := 'A10';
  g_au_lookup('A11')    := NULL;
  g_au_lookup('A12')    := 'A12';
  g_au_lookup('A13')    := 'A13';
  g_au_lookup('A14')    := 'A14';
  g_au_lookup('A16')    := NULL;
  g_au_lookup('A17')    := NULL;
  g_au_lookup('A19')    := NULL;
  g_au_lookup('A1DD')   := 'A33';
  g_au_lookup('DBFO1')  := 'A27';
  g_au_lookup('DBFO2')  := 'A30';
  g_au_lookup('DBFO3')  := 'A29';
  g_au_lookup('DBFO4')  := 'A26';
  g_au_lookup('DBFO5')  := 'A32';
  g_au_lookup('DBFO6')  := 'A28';
  g_au_lookup('DBFO7')  := 'A25';
  g_au_lookup('DBFO9')  := 'A34';
  g_au_lookup('DBFO8')  := 'A31';
  g_au_lookup('DARTF')  := NULL;
  g_au_lookup('M6TOLL') := 'A36';
  g_au_lookup('M25')    := 'A05';
  g_au_lookup('DBFO')   := NULL;
  g_au_lookup('UNKN')   := NULL;
  g_au_lookup('UETON')  := NULL;
  /*
  ||Lane/XSP Mapping.
  ||The index is the SRW Lane, the assignment is the NEM Impact Group Change XSP.
  ||Any assignments of NULL indicate that no sensible mapping of the SRW value
  ||can be determined.
  */
  g_lane_lookup('LH')  := 'LH';
  g_lane_lookup('-L1') := 'NL1';
  g_lane_lookup('CL1') := 'CL1';
  g_lane_lookup('CL2') := 'CL2';
  g_lane_lookup('CL3') := 'CL3';
  g_lane_lookup('CL4') := 'CL4';
  g_lane_lookup('CL5') := 'CL5';
  g_lane_lookup('CL6') := 'CL6';
  g_lane_lookup('CL7') := 'CL7';
  g_lane_lookup('CL8') := 'CL8';
  g_lane_lookup('CL9') := 'CL9';
  g_lane_lookup('+L1') := 'OL1';
  g_lane_lookup('+L2') := 'OL2';
  g_lane_lookup('+L3') := 'OL3';
  g_lane_lookup('CR9') := 'CR9';
  g_lane_lookup('CR8') := 'CR8';
  g_lane_lookup('CR7') := 'CR7';
  g_lane_lookup('CR6') := 'CR6';
  g_lane_lookup('CR5') := 'CR5';
  g_lane_lookup('CR4') := 'CR4';
  g_lane_lookup('CR3') := 'CR3';
  g_lane_lookup('CR2') := 'CR2';
  g_lane_lookup('CR1') := 'CR1';
  g_lane_lookup('-R1') := 'NR1';
  g_lane_lookup('RH' ) := 'RH';
  /*
  ||Lane Status Mapping.
  ||The index is the SRW Lane Status, the assignment is the NEM Impact Group Change Reason.
  ||Any assignments of NULL indicate that no sensible mapping of the SRW value
  ||can be determined.
  */
  g_lane_status_lookup('UNCHANGED') := NULL;
  g_lane_status_lookup('CLOS') := 'CLOSED';
  g_lane_status_lookup('OPEN') := 'OPENED';
  g_lane_status_lookup('BORR') := 'BORROWED';
  g_lane_status_lookup('LOAN') := 'LOANED';
  g_lane_status_lookup('TEMP') := 'TEMPORARY';
  /*
  ||Impact Group Speed Limit Mapping.
  ||The index is the SRW Temporary Speed Limit, the assignment is the NEM Impact
  ||Group Speed Limit.
  ||Some of the SRW codes indicate that the speed limit only applies to traffic
  ||management in which case the Impact Group will show 'N/A' and the Schedules
  ||will be assigned the SRW Speed Limit.
  */
  g_group_speed_limit_lookup('NA')    := 'N/A';
  g_group_speed_limit_lookup('10MPH') := '10 MPH';
  g_group_speed_limit_lookup('20MPH') := '20 MPH';
  g_group_speed_limit_lookup('30MPH') := '30 MPH';
  g_group_speed_limit_lookup('40MPH') := '40 MPH';
  g_group_speed_limit_lookup('50MPH') := '50 MPH';
  g_group_speed_limit_lookup('60MPH') := '60 MPH';
  g_group_speed_limit_lookup('70MPH') := 'UNCHANGED';
  g_group_speed_limit_lookup('10TM')  := 'N/A';
  g_group_speed_limit_lookup('10AT')  := '10 MPH';
  g_group_speed_limit_lookup('20TM')  := 'N/A';
  g_group_speed_limit_lookup('20AT')  := '20 MPH';
  g_group_speed_limit_lookup('30TM')  := 'N/A';
  g_group_speed_limit_lookup('30AT')  := '30 MPH';
  g_group_speed_limit_lookup('40TM')  := 'N/A';
  g_group_speed_limit_lookup('40AT')  := '40 MPH';
  g_group_speed_limit_lookup('50TM')  := 'N/A';
  g_group_speed_limit_lookup('50AT')  := '50 MPH';
  g_group_speed_limit_lookup('60TM')  := 'N/A';
  g_group_speed_limit_lookup('60AT')  := '60 MPH';
  /*
  ||Schedule Speed Limit Mapping.
  ||The index is the SRW Temporary Speed Limit, the assignment is the NEM
  ||Schedule Speed Limit.
  */
  g_schd_speed_limit_lookup('NA')    := 'N/A';
  g_schd_speed_limit_lookup('10MPH') := '10 MPH';
  g_schd_speed_limit_lookup('20MPH') := '20 MPH';
  g_schd_speed_limit_lookup('30MPH') := '30 MPH';
  g_schd_speed_limit_lookup('40MPH') := '40 MPH';
  g_schd_speed_limit_lookup('50MPH') := '50 MPH';
  g_schd_speed_limit_lookup('60MPH') := '60 MPH';
  g_schd_speed_limit_lookup('70MPH') := 'UNCHANGED';
  g_schd_speed_limit_lookup('10TM')  := '10 MPH';
  g_schd_speed_limit_lookup('10AT')  := '10 MPH';
  g_schd_speed_limit_lookup('20TM')  := '20 MPH';
  g_schd_speed_limit_lookup('20AT')  := '20 MPH';
  g_schd_speed_limit_lookup('30TM')  := '30 MPH';
  g_schd_speed_limit_lookup('30AT')  := '30 MPH';
  g_schd_speed_limit_lookup('40TM')  := '40 MPH';
  g_schd_speed_limit_lookup('40AT')  := '40 MPH';
  g_schd_speed_limit_lookup('50TM')  := '50 MPH';
  g_schd_speed_limit_lookup('50AT')  := '50 MPH';
  g_schd_speed_limit_lookup('60TM')  := '60 MPH';
  g_schd_speed_limit_lookup('60AT')  := '60 MPH';
  /*
  ||Delay Mapping.
  ||The index is the SRW Expected Delay, the assignment is the NEM Delay.
  ||Any assignments of NULL indicate that no sensible mapping of the SRW value
  ||can be determined.
  */
  g_delay_lookup('ND') := 'NO DELAY';
  g_delay_lookup('S')  := 'SLIGHT (LESS THAN 10 MINS)';
  g_delay_lookup('M')  := 'MODERATE (10 - 30 MINS)';
  g_delay_lookup('SV') := 'SEVERE (MORE THAN 30 MINS)';
  /*
  ||Nature Of Works Mapping.
  ||The index is the SRW Nature Of Works, the assignment is the NEM Nature Of Works.
  ||Nature Of Works is not a mandatory attribute so there may be null values.
  ||NB. Some SRW values below are commented out because Closures with these values
  ||will not be migrated.
  */
  --g_nature_of_works_lookup('NA')         := NULL;
  g_nature_of_works_lookup('ABNL')       := NULL;
  g_nature_of_works_lookup('BP')         := 'BARRIERS - PERMANENT';
  g_nature_of_works_lookup('BT')         := 'BARRIERS - TEMPORARY';
  g_nature_of_works_lookup('CAS')        := 'CARRIAGEWAY - ANTI-SKID';
  g_nature_of_works_lookup('CRR')        := 'CARRIAGEWAY - RECONST/REPAIR';
  g_nature_of_works_lookup('CRO')        := 'CARRIAGEWAY - RECONST/REPAIR';
  g_nature_of_works_lookup('CRWISFD')    := 'CENTRAL RESERVATION';
  g_nature_of_works_lookup('CPI')        := 'CLOSED ON POLICE INSTRUCTION';
  g_nature_of_works_lookup('COMM')       := 'COMMUNICATIONS';
  g_nature_of_works_lookup('CBS')        := 'CONSTRUCTION-BRIDGE/STRUCTURE';
  g_nature_of_works_lookup('CBN')        := 'CONSTRUCTION - BYPASS/NEW';
  g_nature_of_works_lookup('CIU')        := 'CONSTRUCTION-IMPROVE/UPGRADE';
  g_nature_of_works_lookup('DR')         := NULL;
  g_nature_of_works_lookup('GC')         := 'DRAINAGE';
  g_nature_of_works_lookup('EWSL')       := 'ELECTRICAL WORKS';
  --g_nature_of_works_lookup('EWU')        := NULL;
  g_nature_of_works_lookup('EVENT')      := NULL;
  g_nature_of_works_lookup('HORT')       := 'HORTICULTURE(CUTTING-PLANTING)';
  g_nature_of_works_lookup('CIS')        := 'INSPECTION/SURVEY';
  g_nature_of_works_lookup('LITT')       := 'LITTER CLEARANCE';
  g_nature_of_works_lookup('POLREC')     := 'POLICE RECONSTRUCTION';
  g_nature_of_works_lookup('RTA')        := 'ROAD TRAFFIC COLLISION';
  g_nature_of_works_lookup('SAFEB')      := 'BARRIER/FENCE SAFETY REPAIRS';
  g_nature_of_works_lookup('SIGNE')      := 'SIGNS - ERECTION';
  g_nature_of_works_lookup('SIGNMAN')    := 'SIGNS - MAINTENANCE';
  g_nature_of_works_lookup('SUW')        := 'SU WORKS';
  g_nature_of_works_lookup('SI')         := 'INSPECTION/SURVEY';
  g_nature_of_works_lookup('SM')         := 'STRUCTURE - MAINTENANCE';
  g_nature_of_works_lookup('STRNR')      := 'STRUCTURE - NEW/RECONSTRUCTION';
  g_nature_of_works_lookup('SREPAIRS')   := 'STRUCTURE - MAINTENANCE';
  g_nature_of_works_lookup('SWEEP')      := 'SWEEPING OF CARRIAGEWAY';
  --g_nature_of_works_lookup('TRAIN')      := NULL;
  g_nature_of_works_lookup('TUNNELMAIN') := 'TUNNEL MAINTENANCE';
  g_nature_of_works_lookup('VORW')       := 'VERGE OFF-ROAD WORKS';
  g_nature_of_works_lookup('WHITL')      := 'WHITE LINING/ROAD MARKINGS';
  --g_nature_of_works_lookup('OTH')        := NULL;
  --
END srw_data_load;
/
