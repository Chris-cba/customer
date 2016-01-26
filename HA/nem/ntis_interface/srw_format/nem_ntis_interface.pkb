CREATE OR REPLACE PACKAGE BODY nem_ntis_interface
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/nem_ntis_interface.pkb-arc   1.0   26 Jan 2016 18:00:08   Mike.Huitson  $
  --       Module Name      : $Workfile:   nem_ntis_interface.pkb  $
  --       Date into PVCS   : $Date:   26 Jan 2016 18:00:08  $
  --       Date fetched Out : $Modtime:   25 Jan 2016 18:53:00  $
  --       Version          : $Revision:   1.0  $
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
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';
  g_package_name   CONSTANT VARCHAR2 (30) := 'nem_ntis_interface';
  --
  c_impact_group_level  CONSTANT PLS_INTEGER := 2;
  c_schedule_level      CONSTANT PLS_INTEGER := 1;
  --
  TYPE status_map_tab IS TABLE OF nem_ntis_status_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_status_map  status_map_tab;
  --
  TYPE delay_map_tab IS TABLE OF nem_ntis_delay_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_delay_map  delay_map_tab;
  --
  TYPE srw_type_map_tab IS TABLE OF nem_ntis_srw_type_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_srw_type_map  srw_type_map_tab;
  --
  TYPE srw_activity_map_tab IS TABLE OF nem_ntis_srw_activity_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_srw_activity_map  srw_activity_map_tab;
  --
  TYPE nature_of_works_map_tab IS TABLE OF nem_ntis_nature_of_works_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_nature_of_works_map  nature_of_works_map_tab;
  --
  TYPE imp_grp_speed_limit_map_tab IS TABLE OF nem_ntis_imp_grp_speed_limit%ROWTYPE INDEX BY BINARY_INTEGER;
  g_imp_grp_speed_limit_map  imp_grp_speed_limit_map_tab;
  --
  TYPE schd_speed_limit_map_tab IS TABLE OF nem_ntis_schd_speed_limit%ROWTYPE INDEX BY BINARY_INTEGER;
  g_schd_speed_limit_map  schd_speed_limit_map_tab;
  --
  TYPE lane_status_map_tab IS TABLE OF nem_ntis_lane_status_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_lane_status_map  lane_status_map_tab;
  --
  TYPE xsp_map_tab IS TABLE OF nem_ntis_xsp_map%ROWTYPE INDEX BY BINARY_INTEGER;
  g_xsp_map  xsp_map_tab;
  --
  TYPE speed_limit_rec IS RECORD(limit_level   PLS_INTEGER
                                ,limit_rank    PLS_INTEGER
                                ,ntis_meaning  nem_ntis_imp_grp_speed_limit.ntis_meaning%TYPE);
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
                             ,element_unit_name  nm_units.un_unit_name%TYPE);
  TYPE location_tab IS TABLE OF location_rec INDEX BY BINARY_INTEGER;
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
  FUNCTION gen_tags(pi_element    IN VARCHAR2
                   ,pi_data       IN VARCHAR2)
    RETURN VARCHAR2 IS
    --
    lv_retval  nm3type.max_varchar2;
    lv_indent  nm3type.max_varchar2;
    --
  BEGIN
    --
    IF pi_data IS NOT NULL
     THEN
        lv_retval := '<'||pi_element||'>'||dbms_xmlgen.convert(pi_data)||'</'||pi_element||'>';
    ELSE
        lv_retval := '<'||pi_element||'></'||pi_element||'>';
    END IF;
    --
    RETURN lv_retval;
    --
  END gen_tags;

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
      INTO g_status_map
      FROM nem_ntis_status_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_delay_map
      FROM nem_ntis_delay_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_srw_type_map
      FROM nem_ntis_srw_type_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_srw_activity_map
      FROM nem_ntis_srw_activity_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_nature_of_works_map
      FROM nem_ntis_nature_of_works_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_imp_grp_speed_limit_map
      FROM nem_ntis_imp_grp_speed_limit
     ORDER
        BY ntis_rank
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_schd_speed_limit_map
      FROM nem_ntis_schd_speed_limit
     ORDER
        BY ntis_rank
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_lane_status_map
      FROM nem_ntis_lane_status_map
         ;
    --
    SELECT *
      BULK COLLECT
      INTO g_xsp_map
      FROM nem_ntis_xsp_map
         ;
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
  FUNCTION get_status(pi_nem_code IN nem_ntis_status_map.nem_code%TYPE)
    RETURN nem_ntis_status_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_status_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_status_map.COUNT LOOP
      --
      IF g_status_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_status_map(i).ntis_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Status Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_STATUS_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_status;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_lane_status(pi_nem_code IN nem_ntis_lane_status_map.nem_code%TYPE)
    RETURN nem_ntis_lane_status_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_lane_status_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_lane_status_map.COUNT LOOP
      --
      IF g_lane_status_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_lane_status_map(i).ntis_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Lane Status Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_LANE_STATUS_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_lane_status;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_xsp(pi_nem_code IN nem_ntis_xsp_map.nem_code%TYPE)
    RETURN nem_ntis_xsp_map.ntis_code%TYPE IS
    --
    lv_retval  nem_ntis_xsp_map.ntis_code%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_xsp_map.COUNT LOOP
      --
      IF g_xsp_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_xsp_map(i).ntis_code;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM XSP Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_XSP_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_xsp;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_delay(pi_nem_code IN nem_ntis_delay_map.nem_code%TYPE)
    RETURN nem_ntis_delay_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_delay_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_delay_map.COUNT LOOP
      --
      IF g_delay_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_delay_map(i).ntis_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Delay Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_DELAY_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_delay;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_srw_type(pi_nem_code IN nem_ntis_srw_type_map.nem_code%TYPE)
    RETURN nem_ntis_srw_type_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_srw_type_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_srw_type_map.COUNT LOOP
      --
      IF g_srw_type_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_srw_type_map(i).ntis_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Event Type Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_SRW_TYPE_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_srw_type;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_srw_activity(pi_nem_code IN nem_ntis_srw_activity_map.nem_code%TYPE)
    RETURN nem_ntis_srw_activity_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_srw_activity_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    FOR i IN 1..g_srw_activity_map.COUNT LOOP
      --
      IF g_srw_activity_map(i).nem_code = pi_nem_code
       THEN
          lv_retval := g_srw_activity_map(i).ntis_meaning;
          EXIT;
      END IF;
      --
    END LOOP;
    --
    IF lv_retval IS NULL
     THEN
        raise_application_error(-20001,'Unable to translate NEM Event Type Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_SRW_ACTIVITY_MAP.');
    END IF;
    --
    RETURN lv_retval;
    --
  END get_srw_activity;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_nature_of_works(pi_event_type IN nem_ntis_nature_of_works_map.nem_code%TYPE
                              ,pi_nem_code   IN nem_ntis_nature_of_works_map.nem_code%TYPE)
    RETURN nem_ntis_nature_of_works_map.ntis_meaning%TYPE IS
    --
    lv_retval  nem_ntis_nature_of_works_map.ntis_meaning%TYPE;
    --
  BEGIN
    --
    CASE
      WHEN pi_event_type = 'ABNORMAL LOAD MOVEMENTS'
       THEN
          lv_retval := 'Abnormal Load';
      WHEN pi_event_type = 'DIVERSION/ALTERNATE ROUTE'
       THEN
          lv_retval := 'Diversion Route';
      WHEN pi_nem_code IS NULL
       THEN
          lv_retval := NULL;
      ELSE
          FOR i IN 1..g_nature_of_works_map.COUNT LOOP
            --
            IF g_nature_of_works_map(i).nem_code = pi_nem_code
             THEN
                lv_retval := g_nature_of_works_map(i).ntis_meaning;
                EXIT;
            END IF;
            --
          END LOOP;
          --
          IF lv_retval IS NULL
           THEN
              raise_application_error(-20001,'Unable to translate NEM Event Type Code ['||pi_nem_code||'] to an NTIS value, please add a valid translation to the table NEM_NTIS_NATURE_OF_WORKS_MAP.');
          END IF;
    END CASE;
    --
    RETURN lv_retval;
    --
  END get_nature_of_works;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_ftp_details(pi_hft_id IN hig_ftp_types.hft_id%TYPE)
    RETURN ftp_con_rec IS
    --
    lv_process_id  hig_processes.hp_process_id%TYPE := hig_process_api.get_current_process_id;
    --
    lr_retval  ftp_con_rec;
    --
  BEGIN
    --
    SELECT hfc_id
          ,hfc_ftp_username
          ,hfc_ftp_password
          ,hfc_ftp_host
          ,hfc_ftp_port
          ,hfc_ftp_out_dir
      INTO lr_retval
      FROM hig_ftp_types
          ,hig_ftp_connections
     WHERE hfc_hft_id = hft_id
       AND hft_id = pi_hft_id
         ;
    --
    IF SYS_CONTEXT('NM3SQL','NM3FTPPASSWORD') = 'N'
     OR SYS_CONTEXT('NM3SQL','NM3FTPPASSWORD') IS NULL
     THEN
        nm3ctx.set_context('NM3FTPPASSWORD','Y');
    END IF;
    --
    lr_retval.password := nm3ftp.get_password(lr_retval.password);
    --
    RETURN lr_retval;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        hig_process_api.log_it(pi_message => 'No FTP connection details found for Process Type.'
                              ,pi_message_type => 'E');
        RETURN lr_retval;
    WHEN too_many_rows
     THEN
        hig_process_api.log_it(pi_message => 'Multiple FTP connection details found for Process Type, only one should be specified.'
                              ,pi_message_type => 'E');
        RETURN lr_retval;     
    WHEN others
     THEN
        hig_process_api.log_it(pi_message => SUBSTR('Error occurred geting FTP connection details: '||SQLERRM,1,500)
                              ,pi_message_type => 'E');
        RETURN lr_retval;
  END get_ftp_details;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_process_details(po_directory   IN OUT hig_process_type_files.hptf_output_destination%TYPE
                               ,po_ftp_details IN OUT ftp_con_rec
                               ,po_run_date    IN OUT DATE)
    IS
    --
    lv_process_id  hig_processes.hp_process_id%TYPE := hig_process_api.get_current_process_id;
    lv_run_id      hig_process_job_runs.hpjr_job_run_seq%TYPE := hig_process_api.get_current_job_run_seq;
    lv_ftp_type_id hig_process_types.hpt_polling_ftp_type_id%TYPE;
    --
    CURSOR get_run_date(cp_process_id hig_processes.hp_process_id%TYPE
                       ,cp_run_id     hig_process_job_runs.hpjr_job_run_seq%TYPE)
        IS
    SELECT CAST(hpjr_start AS DATE) run_date
      FROM hig_process_job_runs
     WHERE hpjr_process_id = cp_process_id
       AND hpjr_job_run_seq = cp_run_id
         ;
    --
    CURSOR get_ftp(cp_process_id hig_processes.hp_process_id%TYPE)
        IS
    SELECT hpt_polling_ftp_type_id
      FROM hig_process_types
          ,hig_processes
     WHERE hp_process_id = cp_process_id
       AND hp_process_type_id = hpt_process_type_id
         ;
    --
  BEGIN
    /*
    ||Get the run date.
    */
    OPEN  get_run_date(lv_process_id,lv_run_id);
    FETCH get_run_date
     INTO po_run_date;
    --
    IF get_run_date%NOTFOUND
     THEN
        raise_application_error(-20001,'Unable to establish run date.');
    END IF;
    --
    CLOSE get_run_date;
    /*
    ||Get the output destination.
    */
    BEGIN
      SELECT hptf_output_destination
        INTO po_directory
        FROM hig_process_type_files
            ,hig_processes
       WHERE hp_process_id = lv_process_id
         AND hp_process_type_id = hptf_process_type_id
         AND hptf_output_destination_type = 'ORACLE_DIRECTORY'
           ;
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20001,'Unable to establish oracle directory to write output to.');
      WHEN too_many_rows
       THEN
          raise_application_error(-20001,'Multiple file types specified for Process Type, only 1 should be specified.');
      WHEN others
       THEN
          RAISE;
    END;
    /*
    ||Get the ftp details.
    */
    OPEN  get_ftp(lv_process_id);
    FETCH get_ftp
     INTO lv_ftp_type_id;
    --
    IF get_ftp%NOTFOUND
     THEN
        raise_application_error(-20001,'Unable to establish FTP Type to write output to.');
    END IF;
    --
    CLOSE get_ftp;
    --
    po_ftp_details := get_ftp_details(pi_hft_id => lv_ftp_type_id);
    --
  END get_process_details;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_process_details(pi_full_exp_name IN     hig_process_types.hpt_name%TYPE
                               ,po_directory     IN OUT hig_process_type_files.hptf_output_destination%TYPE
                               ,po_ftp_details   IN OUT ftp_con_rec
                               ,po_run_date      IN OUT DATE
                               ,po_prev_run_date IN OUT DATE)
    IS
    --
    lv_full_exp_type_id  hig_process_types.hpt_process_type_id%TYPE;
    lv_process_id        hig_processes.hp_process_id%TYPE := hig_process_api.get_current_process_id;
    lv_run_id            hig_process_job_runs.hpjr_job_run_seq%TYPE := hig_process_api.get_current_job_run_seq;
    lv_full_run_date     DATE;
    lv_update_run_date   DATE;
    --
    CURSOR get_prev_date(cp_process_id IN hig_processes.hp_process_id%TYPE
                        ,cp_run_id     IN hig_process_job_runs.hpjr_job_run_seq%TYPE)
        IS
    SELECT CAST(hpjr_start AS DATE) run_date
      FROM hig_process_job_runs
     WHERE hpjr_job_run_seq < cp_run_id
       AND hpjr_process_id = cp_process_id
     ORDER
        BY hpjr_job_run_seq DESC
         ;
    --
    CURSOR get_prev_full_exp_date(cp_process_type_id IN hig_process_types.hpt_process_type_id%TYPE)
        IS
    SELECT CAST(hpjr_start AS DATE) run_date
      FROM hig_process_job_runs
     WHERE hpjr_process_id IN(SELECT hp_process_id
                                FROM hig_processes
                               WHERE hp_process_type_id = cp_process_type_id)
     ORDER
        BY hpjr_start DESC
         ;
    --
  BEGIN
    --
    get_process_details(po_directory   => po_directory
                       ,po_ftp_details => po_ftp_details
                       ,po_run_date    => po_run_date);
    /*
    ||Make sure a full export has been executed and get the run date.
    */
    lv_full_exp_type_id := hig_process_framework.get_process_type(pi_process_type_name => pi_full_exp_name).hpt_process_type_id;
    --
    OPEN  get_prev_full_exp_date(lv_full_exp_type_id);
    FETCH get_prev_full_exp_date
     INTO lv_full_run_date;
    --
    IF get_prev_full_exp_date%NOTFOUND
     THEN
        raise_application_error(-20001,'A full export should be executed ("'||pi_full_exp_name||'") before updates can be created.');
    END IF;
    --
    CLOSE get_prev_full_exp_date;
    /*
    ||Get the last update run date.
    */
    OPEN  get_prev_date(lv_process_id,lv_run_id);
    FETCH get_prev_date
     INTO lv_update_run_date;
    --
    IF get_prev_date%NOTFOUND
     THEN
        po_prev_run_date := lv_full_run_date;
    ELSE
        po_prev_run_date := GREATEST(lv_full_run_date,lv_update_run_date);
    END IF;
    --
    CLOSE get_prev_date;
    --
  END get_process_details;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE upload_files(pi_ftp_details IN ftp_con_rec
                        ,pi_from_dir    IN hig_process_type_files.hptf_output_destination%TYPE
                        ,pi_files       IN nm3type.tab_varchar80)
    IS
    --
    lr_conn_details  ftp_con_rec;
    --
    lv_conn  utl_tcp.connection;
    --
    lv_wallet_path VARCHAR2(200) := 'file:C:\oracle\product\11.2.0\exor\BIN\owm\wallets\Administrator';
    lv_wallet_pass VARCHAR2(10) := NULL;
    --
  BEGIN
    --
    IF pi_ftp_details.conn_id IS NOT NULL
     AND pi_files.COUNT > 0
     THEN
        /*
        ||Connect to the ftp server.
        */
        hig_process_api.log_it(pi_message      => 'Logging into FTP Server '||pi_ftp_details.hostname||' '||pi_ftp_details.password
                              ,pi_summary_flag => 'N');
        lv_conn := nm3ftp.login(p_host => pi_ftp_details.hostname
                               ,p_port => pi_ftp_details.port
                               ,p_user => pi_ftp_details.username
                               ,p_pass => pi_ftp_details.password);
                               --,p_wallet_path => lv_wallet_path
                               --,p_wallet_pass => lv_wallet_pass);
        hig_process_api.log_it(pi_message      => 'FTP Connection established '||lv_conn.remote_host
                              ,pi_summary_flag => 'N');
        /*
        ||Upload the files.
        */
        FOR i IN 1..pi_files.COUNT LOOP
          /*
          ||Upload the file.
          */
          hig_process_api.log_it(pi_message      => 'Uploading file to '||pi_ftp_details.out_dir||pi_files(i)
                                ,pi_summary_flag => 'N');
          --
          hig_process_api.log_it(pi_message      => 'Calling ascii.'
                                ,pi_summary_flag => 'N');
          nm3ftp.ascii(p_conn => lv_conn);
          --
          hig_process_api.log_it(pi_message      => 'Calling put.'
                                ,pi_summary_flag => 'N');
          nm3ftp.put(p_conn      => lv_conn
                    ,p_from_dir  => pi_from_dir
                    ,p_from_file => pi_files(i)
                    ,p_to_file   => pi_ftp_details.out_dir||'$'||pi_files(i));
          --
          hig_process_api.log_it(pi_message      => 'Calling rename.'
                                ,pi_summary_flag => 'N');
          nm3ftp.rename(p_conn => lv_conn
                       ,p_from => pi_ftp_details.out_dir||'$'||pi_files(i)
                       ,p_to   => pi_ftp_details.out_dir||pi_files(i));
          --
          hig_process_api.log_it(pi_message      => 'File Uploaded.'
                                ,pi_summary_flag => 'N');
          /*
          ||Update the file upload status.
          */
        END LOOP;
        /*
        ||Close FTP Connection.
        */
        nm3ftp.logout(p_conn => lv_conn);
        --
        hig_process_api.log_it(pi_message      => 'FTP Connection Closed.'
                              ,pi_summary_flag => 'N');
    END IF;
    --
  END upload_files;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE add_line(pi_text   IN     VARCHAR2
                    ,pi_indent IN     PLS_INTEGER DEFAULT 0
                    ,pi_tab    IN OUT NOCOPY nm3type.tab_varchar32767)
    IS
  BEGIN  
    --
    pi_tab(pi_tab.COUNT+1) := LPAD(' ',NVL(pi_indent,0))||pi_text;
    --
  END add_line;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_edate(pi_actual_complete_date  IN     DATE
                     ,pi_actual_start_date     IN     DATE
                     ,pi_planned_complete_date IN     DATE
                     ,pi_planned_start_date    IN     DATE
                     ,po_end_date              IN OUT DATE
                     ,po_notes                 IN OUT VARCHAR2)
    IS
    --
    lv_retval  DATE;
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
            po_notes    := po_notes||CHR(10)||'#Closure End Date has been calculated by the NEM NTIS Interface because Actual Start is greater than Planned Complete.';
        ELSE
            po_end_date := pi_planned_complete_date;
        END IF;
    END IF;
    --
  END set_edate;

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
    ||Schedule Level Speed Limits overide Impact Group Speed Limits.
    ||The values are ranked in the tables nem_ntis_imp_grp_speed_limit
    ||and nem_ntis_schd_speed_limit and the lowest rank wins.
    */
    IF pi_level = c_impact_group_level
     THEN
        FOR i IN 1..g_imp_grp_speed_limit_map.COUNT LOOP
          --
          IF g_imp_grp_speed_limit_map(i).nem_code = pi_speed_limit
           THEN
              lv_temp_limit.limit_level := pi_level;
              lv_temp_limit.limit_rank := g_imp_grp_speed_limit_map(i).ntis_rank;
              lv_temp_limit.ntis_meaning := g_imp_grp_speed_limit_map(i).ntis_meaning;
              EXIT;
          END IF;
          --        
        END LOOP;
    ELSE
        FOR i IN 1..g_schd_speed_limit_map.COUNT LOOP
          --
          IF g_schd_speed_limit_map(i).nem_code = pi_speed_limit
           THEN
              lv_temp_limit.limit_level := pi_level;
              lv_temp_limit.limit_rank := g_schd_speed_limit_map(i).ntis_rank;
              lv_temp_limit.ntis_meaning := g_schd_speed_limit_map(i).ntis_meaning;
              EXIT;
          END IF;
          --        
        END LOOP;
    END IF;
    --
    IF po_lowest_limit.ntis_meaning IS NULL
     OR (lv_temp_limit.limit_level < po_lowest_limit.limit_level
         AND lv_temp_limit.ntis_meaning != 'Unchanged')
     OR (lv_temp_limit.limit_level = po_lowest_limit.limit_level
         AND lv_temp_limit.limit_rank < po_lowest_limit.limit_rank)
     THEN
        po_lowest_limit := lv_temp_limit;
    END IF;
    --
  END set_speed_limit;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE set_traffic_management(pi_nig_rec             IN     nem_impact_groups%ROWTYPE
                                  ,pi_speed_limit         IN     nem_ntis_imp_grp_speed_limit.ntis_meaning%TYPE
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
          lr_temp_value.traffic_value := 'Carriageway Closure';
          lr_temp_value.traffic_rank := 1;
      WHEN includes_lane_closure(pi_nig_id => pi_nig_rec.nig_id)
       THEN
          lr_temp_value.traffic_value := 'Lane Closure';
          lr_temp_value.traffic_rank := 2;
      WHEN pi_nig_rec.nig_contraflow = 'Y'
       THEN
          lr_temp_value.traffic_value := 'Contraflow';
          lr_temp_value.traffic_rank := 3;
      WHEN pi_nig_rec.nig_width_restriction = 'Y'
       THEN
          lr_temp_value.traffic_value := 'Width Restriction';
          lr_temp_value.traffic_rank := 4;
      WHEN pi_speed_limit != 'Unchanged'
       THEN
          lr_temp_value.traffic_value := 'Speed Restriction';
          lr_temp_value.traffic_rank := 5;
      WHEN pi_nig_rec.nig_traffic_management = 'CONVOY WORKING'
       THEN
          lr_temp_value.traffic_value := 'Convoy Working';
          lr_temp_value.traffic_rank := 6;
      WHEN pi_mobile_lane_closure = 'Y'
       THEN
          lr_temp_value.traffic_value := 'Mobile Lane Closure';
          lr_temp_value.traffic_rank := 7;
      WHEN pi_nig_rec.nig_traffic_management = 'TRAFFIC SIGNALS'
       THEN
          lr_temp_value.traffic_value := 'Traffic Signals';
          lr_temp_value.traffic_rank := 8;
      WHEN pi_nig_rec.nig_weight_restriction = 'Y'
       THEN
          lr_temp_value.traffic_value := 'Weight Restriction';
          lr_temp_value.traffic_rank := 9;
      WHEN pi_nig_rec.nig_height_restriction = 'Y'
       THEN
          lr_temp_value.traffic_value := 'Height Restriction';
          lr_temp_value.traffic_rank := 10;
      ELSE
          lr_temp_value.traffic_value := 'None';
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
  FUNCTION get_impact_length(pi_nevt_id IN nem_events.nevt_id%TYPE)
    RETURN NUMBER IS
    --
    lv_retval  NUMBER;
    --
  BEGIN
    --
    SELECT NVL(SUM(mem_length),0) impact_length
      INTO lv_retval
      FROM (SELECT CASE
                     WHEN im.nm_end_mp > im.nm_begin_mp
                      THEN
                         im.nm_end_mp - im.nm_begin_mp
                     ELSE
                         im.nm_begin_mp - im.nm_end_mp
                   END mem_length
              FROM nm_members im
             WHERE im.nm_ne_id_in = pi_nevt_id)
         ;
    --
    RETURN lv_retval;
    --
  END get_impact_length;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE write_events_to_srw_file(pi_events   IN nem_event_tab
                                    ,pi_out_dir  IN hig_process_type_files.hptf_output_destination%TYPE
                                    ,pi_filename IN VARCHAR2)
    IS
    --
    lt_output            nm3type.tab_varchar32767;
    lt_layout_output     nm3type.tab_varchar32767;
    lt_diary_output      nm3type.tab_varchar32767;
    lt_component_output  nm3type.tab_varchar32767;
    --
    lt_impacted_network  location_tab;
    lt_group_locations   location_tab;
    --
    lv_lvm_id        nem_lvms.nlvm_id%TYPE := get_lvm;
    lv_edate         DATE;
    lv_extra_notes   VARCHAR2(500);
    lv_dummy         VARCHAR2(500);
    lv_narrow_lanes  VARCHAR2(3) := 'No';
    lv_dentry        VARCHAR2(100);
    --
    lr_lowest_limit  speed_limit_rec;
    lr_traffic_man   traffic_man_rec;
    --
    CURSOR get_contact(cp_nevt_id nem_events.nevt_id%TYPE
                      ,cp_type    VARCHAR2)
        IS
    SELECT nec_name
          ,nec_day_telephone
      FROM nem_event_contacts
     WHERE nec_nevt_id = cp_nevt_id
       AND nec_type = cp_type
     ORDER
        BY nec_id DESC
         ;
    --
    lr_proj_contact  get_contact%ROWTYPE;
    lr_cont_contact  get_contact%ROWTYPE;
    --
    CURSOR get_impact_groups(cp_nevt_id nem_events.nevt_id%TYPE)
        IS
    SELECT *
      FROM nem_impact_groups
     WHERE nig_nevt_id = cp_nevt_id
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
    add_line(pi_text => '<closure_transfer_file>'
            ,pi_tab  => lt_output);
    --
    FOR i IN 1..pi_events.COUNT LOOP
      --
      hig_process_api.log_it(pi_message      => 'Processing Event '||nem_util.get_formatted_event_number(pi_event_number   => pi_events(i).event_number
                                                                                                        ,pi_version_number => pi_events(i).version_number)
                            ,pi_summary_flag => 'N');
      --

      /*
      ||Init variables.
      */
      lv_edate := NULL;
      lr_lowest_limit := NULL;
      lr_traffic_man := NULL;
      lv_extra_notes := NULL;
      lv_narrow_lanes := 'No';
      lt_layout_output.DELETE;
      lt_diary_output.DELETE;
      lt_component_output.DELETE;
      lt_impacted_network.DELETE;
      /*
      ||Get the components (Impacted Network).
      */
      lt_impacted_network := get_locations(pi_asset_id => pi_events(i).nevt_id
                                          ,pi_lvm_id   => lv_lvm_id);
      --
      remove_duplicate_sects(po_locations => lt_impacted_network);
      --
      add_line(pi_text   => '<components>'
              ,pi_indent => 4
              ,pi_tab    => lt_component_output);
      --
      FOR j IN 1..lt_impacted_network.COUNT LOOP
        --
        add_line(pi_text   => '<comp>'
                ,pi_indent => 6
                ,pi_tab    => lt_component_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'key'
                                      ,pi_data    => lt_impacted_network(j).element_id)
                ,pi_indent => 8
                ,pi_tab    => lt_component_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'comp_name'
                                      ,pi_data    => lt_impacted_network(j).element_unique)
                ,pi_indent => 8
                ,pi_tab    => lt_component_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'length'
                                      ,pi_data    => lt_impacted_network(j).element_length)
                ,pi_indent => 8
                ,pi_tab    => lt_component_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'compsec'
                                      ,pi_data    => lt_impacted_network(j).element_id
                                                     ||','||lt_impacted_network(j).element_unique
                                                     ||',0,'||lt_impacted_network(j).element_length)
                ,pi_indent => 8
                ,pi_tab    => lt_component_output);
        --
        add_line(pi_text   => '</comp>'
                ,pi_indent => 6
                ,pi_tab    => lt_component_output);
        --
      END LOOP;
      --
      add_line(pi_text   => '</components>'
              ,pi_indent => 4
              ,pi_tab    => lt_component_output);
      /*
      ||Get the Impact Group Contents.
      */
      OPEN  get_impact_groups(pi_events(i).nevt_id);
      FETCH get_impact_groups
       BULK COLLECT
       INTO lt_nig;
      CLOSE get_impact_groups;
      --
      add_line(pi_text   => '<layouts>'
              ,pi_indent => 6
              ,pi_tab    => lt_layout_output);
      --
      add_line(pi_text   => '<diary>'
              ,pi_indent => 6
              ,pi_tab    => lt_diary_output);
      --
      FOR j IN 1..lt_nig.COUNT LOOP
        /*
        ||Set the narrow lanes flag.
        */
        IF lt_nig(j).nig_width_restriction = 'Y'
         THEN
            lv_narrow_lanes := 'Yes';
        END IF;
        /*
        ||Check the speed limit.
        */
        IF lt_nig(j).nig_speed_limit IS NOT NULL
         THEN
            set_speed_limit(pi_speed_limit  => lt_nig(j).nig_speed_limit
                           ,pi_level        => c_impact_group_level
                           ,po_lowest_limit => lr_lowest_limit);
        END IF;
        --
        add_line(pi_text   => '<layout>'
                ,pi_indent => 8
                ,pi_tab    => lt_layout_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'key'
                                      ,pi_data    => lt_nig(j).nig_id)
                ,pi_indent => 10
                ,pi_tab    => lt_layout_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'layout_name'
                                      ,pi_data    => lt_nig(j).nig_name)
                ,pi_indent => 10
                ,pi_tab    => lt_layout_output);
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
        FOR k IN 1..lt_group_locations.COUNT LOOP
          --
          IF lt_nigx.COUNT > 0
           THEN
              FOR m IN 1..lt_nigx.COUNT LOOP
                --
                add_line(pi_text   => gen_tags(pi_element => 'lanes'
                                              ,pi_data    => lt_group_locations(k).element_id
                                                             ||','||lt_group_locations(k).from_offset
                                                             ||','||lt_group_locations(k).to_offset
                                                             ||','||get_xsp(pi_nem_code => lt_nigx(m).nigx_xsp)
                                                             ||','||get_lane_status(pi_nem_code => lt_nigx(m).nigx_reason))
                        ,pi_indent => 10
                        ,pi_tab    => lt_layout_output);
                --
              END LOOP;
          ELSE
              --
              add_line(pi_text   => gen_tags(pi_element => 'lanes'
                                            ,pi_data    => lt_group_locations(k).element_id
                                                           ||','||lt_group_locations(k).from_offset
                                                           ||','||lt_group_locations(k).to_offset
                                                           ||',ALL,Unchanged')
                      ,pi_indent => 10
                      ,pi_tab    => lt_layout_output);
              --
          END IF;
              --
        END LOOP;
        --
        add_line(pi_text   => '</layout>'
                ,pi_indent => 8
                ,pi_tab    => lt_layout_output);
        --
        /*
        ||Get the schedules.
        */
        OPEN  get_schedules(lt_nig(j).nig_id);
        FETCH get_schedules
         BULK COLLECT
         INTO lt_nigs;
        CLOSE get_schedules;        
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
          lv_dentry := TO_CHAR(NVL(lt_nigs(k).nigs_actual_startdate,lt_nigs(k).nigs_planned_startdate),c_datetimefmt);
          --
          lv_dummy := NULL;
          --
          set_edate(pi_actual_complete_date  => lt_nigs(k).nigs_actual_enddate
                   ,pi_actual_start_date     => lt_nigs(k).nigs_actual_startdate
                   ,pi_planned_complete_date => lt_nigs(k).nigs_planned_enddate
                   ,pi_planned_start_date    => lt_nigs(k).nigs_planned_startdate
                   ,po_end_date              => lv_edate
                   ,po_notes                 => lv_dummy);
          --
          lv_dentry := lv_dentry||','||TO_CHAR(lv_edate,c_datetimefmt)||','||lt_nig(j).nig_id;
          --
          add_line(pi_text   => gen_tags(pi_element => 'dentry'
                                        ,pi_data    => lv_dentry)
                  ,pi_indent => 8
                  ,pi_tab    => lt_diary_output);
          --
        END LOOP; --schedules
        --
        set_traffic_management(pi_nig_rec             => lt_nig(j)
                              ,pi_speed_limit         => lr_lowest_limit.ntis_meaning
                              ,pi_mobile_lane_closure => pi_events(i).mobile_lane_closure
                              ,po_traffic_management  => lr_traffic_man);
        --
      END LOOP; -- Impact Groups.
      --
      add_line(pi_text   => '</layouts>'
              ,pi_indent => 6
              ,pi_tab    => lt_layout_output);
      --
      add_line(pi_text   => '</diary>'
              ,pi_indent => 6
              ,pi_tab    => lt_diary_output);
      /*
      ||Open the clos tag.
      */
      add_line(pi_text   => '<clos>'
              ,pi_indent => 2
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'clos_key'
                                    ,pi_data    => pi_events(i).event_number)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'publish'
                                    ,pi_data    => CASE pi_events(i).distribute
                                                     WHEN 'Y' 
                                                      THEN 'Yes'
                                                     ELSE 'No'
                                                   END)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'sdate'
                                    ,pi_data    => TO_CHAR(NVL(pi_events(i).actual_start_date,pi_events(i).planned_start_date),c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      set_edate(pi_actual_complete_date  => pi_events(i).actual_complete_date
               ,pi_actual_start_date     => pi_events(i).actual_start_date
               ,pi_planned_complete_date => pi_events(i).planned_complete_date
               ,pi_planned_start_date    => pi_events(i).planned_start_date
               ,po_end_date              => lv_edate
               ,po_notes                 => lv_extra_notes);
      --
      add_line(pi_text   => gen_tags(pi_element => 'edate'
                                    ,pi_data    => TO_CHAR(lv_edate,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'road'
                                    ,pi_data    => nem_ntis_get_road(pi_nevt_id => pi_events(i).nevt_id))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => '<location></location>'
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'length'
                                    ,pi_data    => get_impact_length(pi_nevt_id => pi_events(i).nevt_id))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'description'
                                    ,pi_data    => pi_events(i).description)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'status'
                                    ,pi_data    => get_status(pi_nem_code => pi_events(i).event_status))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'expdel'
                                    ,pi_data    => get_delay(pi_nem_code => pi_events(i).delay))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'type'
                                    ,pi_data    => get_srw_type(pi_nem_code => pi_events(i).event_type))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'narrowlanes'
                                    ,pi_data    => lv_narrow_lanes)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'tempspeedlimit'
                                    ,pi_data    => lr_lowest_limit.ntis_meaning)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'internal_notes'
                                    ,pi_data    => SUBSTR(pi_events(i).notes,1,500 - LENGTH(lv_extra_notes))||lv_extra_notes)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'login'
                                    ,pi_data    => pi_events(i).user_responsible)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'modified'
                                    ,pi_data    => TO_CHAR(pi_events(i).last_modified,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'contract_type'
                                    ,pi_data    => get_srw_activity(pi_nem_code => pi_events(i).event_type))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'traf_man'
                                    ,pi_data    => lr_traffic_man.traffic_value)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'works'
                                    ,pi_data    => get_nature_of_works(pi_event_type => pi_events(i).event_type
                                                                      ,pi_nem_code   => pi_events(i).nature_of_works))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      /*
      ||Get the contact details.
      */
      lr_proj_contact := NULL;
      lr_cont_contact := NULL;
      --
      OPEN  get_contact(pi_events(i).nevt_id,'PROJECT MANAGER');
      FETCH get_contact
       INTO lr_proj_contact;
      CLOSE get_contact;
      --
      OPEN  get_contact(pi_events(i).nevt_id,'CONTRACTOR');
      FETCH get_contact
       INTO lr_cont_contact;
      CLOSE get_contact;
      --
      add_line(pi_text   => '<contact_details>'
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'projman'
                                    ,pi_data    => lr_proj_contact.nec_name)
              ,pi_indent => 6
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'projmantel'
                                    ,pi_data    => lr_proj_contact.nec_day_telephone)
              ,pi_indent => 6
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'contractor'
                                    ,pi_data    => lr_cont_contact.nec_name)
              ,pi_indent => 6
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'contractortel'
                                    ,pi_data    => lr_cont_contact.nec_day_telephone)
              ,pi_indent => 6
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => '</contact_details>'
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'ref'
                                    ,pi_data    => pi_events(i).he_ref)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'contractnumber'
                                    ,pi_data    => pi_events(i).works_ref)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'version'
                                    ,pi_data    => pi_events(i).version_number)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      /*
      ||Add the detail tag.
      */
      add_line(pi_text   => '<detail>'
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      FOR j IN 1..lt_layout_output.COUNT LOOP
        --
        add_line(pi_text   => lt_layout_output(j)
                ,pi_tab    => lt_output);
        --
      END LOOP;
      --
      FOR j IN 1..lt_diary_output.COUNT LOOP
        --
        add_line(pi_text   => lt_diary_output(j)
                ,pi_tab    => lt_output);
        --
      END LOOP;
      --
      add_line(pi_text   => '</detail>'
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      /*
      ||Add the components.
      */
      FOR j IN 1..lt_component_output.COUNT LOOP
        --
        add_line(pi_text   => lt_component_output(j)
                ,pi_tab    => lt_output);
        --
      END LOOP;     
      /*
      ||Close the clos tag.
      */
      add_line(pi_text   => '</clos>'
              ,pi_indent => 2
              ,pi_tab    => lt_output);
      --
    END LOOP; -- Events.
    --
    add_line(pi_text => '</closure_transfer_file>'
            ,pi_tab  => lt_output);
    --
    hig_process_api.log_it(pi_message      => 'Writing Closures file '||pi_filename
                          ,pi_summary_flag => 'N');
    --
    nm3file.write_file(location     => pi_out_dir
                      ,filename     => pi_filename
                      ,all_lines    => lt_output);
    --
  END write_events_to_srw_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE write_srw_cancellation_file(pi_out_dir       IN hig_process_type_files.hptf_output_destination%TYPE
                                       ,pi_filename      IN VARCHAR2
                                       ,pi_run_date      IN DATE
                                       ,pi_prev_run_date IN DATE)
    IS
    --
    TYPE cancelled_event_rec IS RECORD(nevt_id         nm_inv_items_all.iit_ne_id%TYPE
                                      ,cancelled_date  DATE);
    TYPE cancelled_event_tab IS TABLE OF cancelled_event_rec;
    lt_events  cancelled_event_tab;
    --
    lt_output  nm3type.tab_varchar32767;
    --
    lv_sql  nm3type.max_varchar2;
    --
    lv_cancelled_status   CONSTANT VARCHAR2(30) := 'CANCELLED';
    lv_cancel_action      CONSTANT VARCHAR2(30) := 'Cancel';
    lv_superseded_status  CONSTANT VARCHAR2(30) := 'SUPERSEDED';
    lv_published_status   CONSTANT VARCHAR2(30) := 'PUBLISHED';
    lv_combine_action     CONSTANT VARCHAR2(30) := 'Combine';
    lv_abnormal_load      CONSTANT VARCHAR2(30) := 'ABNORMAL LOAD MOVEMENTS';
    lv_embargo            CONSTANT VARCHAR2(30) := 'EMBARGO';
    lv_traffic_incidents  CONSTANT VARCHAR2(30) := 'TRAFFIC INCIDENTS';
    --
    c_events  sys_refcursor;
    --
  BEGIN
    --
    add_line(pi_text => '<SRW_Cancelled_Closures>'
            ,pi_tab  => lt_output);
    --
    lv_sql := 'SELECT '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
   ||CHR(10)||'      ,MAX(naex_execution_date)'
   ||CHR(10)||'  FROM nem_action_executions'
   ||CHR(10)||'      ,nm_inv_items_all'
   ||CHR(10)||'      ,nem_events'
   ||CHR(10)||' WHERE nevt_id = iit_ne_id'
   ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = :cancelled'
   ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                       ||' NOT IN(:abnormal1,:embargo1,:incident1)'
   ||CHR(10)||'   AND iit_date_modified BETWEEN :last_run_date1 AND :run_date1'
   ||CHR(10)||'   AND iit_ne_id = naex_nevt_id'
   ||CHR(10)||'   AND naex_na_id = (SELECT na_id'
   ||CHR(10)||'                       FROM nem_actions'
   ||CHR(10)||'                      WHERE na_label = :cancel)'
   ||CHR(10)||' GROUP'
   ||CHR(10)||'    BY nevt_id'
   ||CHR(10)||'UNION'
   ||CHR(10)||'SELECT iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
   ||CHR(10)||'      ,MAX(naex_execution_date)'
   ||CHR(10)||'  FROM nem_action_executions'
   ||CHR(10)||'      ,nm_inv_items_all iit'
   ||CHR(10)||'      ,nem_events'
   ||CHR(10)||' WHERE nevt_id = iit.iit_ne_id'
   ||CHR(10)||'   AND iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = :superceded'
   ||CHR(10)||'   AND iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                       ||' NOT IN(:abnormal2,:embargo2,:incident2)'
   ||CHR(10)||'   AND iit.iit_date_modified BETWEEN :last_run_date2 AND :run_date2'
   ||CHR(10)||'   AND EXISTS(SELECT 1'
   ||CHR(10)||'                FROM nm_inv_items_all iit2'
   ||CHR(10)||'               WHERE iit2.iit_ne_id = iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'SUPERSEDED_BY_ID')
   ||CHR(10)||'                 AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = :published'
   ||CHR(10)||'                 AND iit2.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
                                ||' != iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')||')'
   ||CHR(10)||'   AND iit_ne_id = naex_nevt_id'
   ||CHR(10)||'   AND naex_na_id = (SELECT na_id'
   ||CHR(10)||'                       FROM nem_actions'
   ||CHR(10)||'                      WHERE na_label = :combine)'
   ||CHR(10)||' GROUP'
   ||CHR(10)||'    BY nevt_id'
    ;
nm_debug.debug(lv_sql);
nm_debug.debug('Prev Date '||TO_CHAR(pi_prev_run_date,'DD-MON-YYYY HH24:MI:SS'));
nm_debug.debug('Run Date '||TO_CHAR(pi_run_date,'DD-MON-YYYY HH24:MI:SS'));
    --
    OPEN c_events FOR lv_sql 
      USING lv_cancelled_status
           ,lv_abnormal_load
           ,lv_embargo
           ,lv_traffic_incidents
           ,pi_prev_run_date
           ,pi_run_date
           ,lv_cancel_action
           ,lv_superseded_status
           ,lv_abnormal_load
           ,lv_embargo
           ,lv_traffic_incidents
           ,pi_prev_run_date
           ,pi_run_date
           ,lv_published_status
           ,lv_combine_action
    ;
    --
    LOOP
      --
      FETCH c_events
       BULK COLLECT
       INTO lt_events
      LIMIT 1000;
      --
      FOR i IN 1..lt_events.COUNT LOOP
        /*
        ||Open the clos tag.
        */
        add_line(pi_text   => '<closure>'
                ,pi_indent => 2
                ,pi_tab    => lt_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'closkey'
                                      ,pi_data    => lt_events(i).nevt_id)
                ,pi_indent => 4
                ,pi_tab    => lt_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'cdate'
                                      ,pi_data    => TO_CHAR(lt_events(i).cancelled_date,c_datetimefmt))
                ,pi_indent => 4
                ,pi_tab    => lt_output);
        /*
        ||Close the clos tag.
        */
        add_line(pi_text   => '</closure>'
                ,pi_indent => 2
                ,pi_tab    => lt_output);
        --
      END LOOP; -- Events.
      --
      EXIT WHEN c_events%NOTFOUND;
      --
    END LOOP;
    --
    add_line(pi_text => '</SRW_Cancelled_Closures>'
            ,pi_tab  => lt_output);
    --
    hig_process_api.log_it(pi_message      => 'Writing Cancelations file '||pi_filename
                          ,pi_summary_flag => 'N');
    --
    nm3file.write_file(location     => pi_out_dir
                      ,filename     => pi_filename
                      ,all_lines    => lt_output);
    --
  END write_srw_cancellation_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_full_srw_file(pi_out_dir     IN hig_process_type_files.hptf_output_destination%TYPE
                                ,pi_ftp_details IN ftp_con_rec
                                ,pi_run_date    IN DATE)
    IS
    --
    lt_events  nem_event_tab;
    lt_files   nm3type.tab_varchar80;
    --
    lv_file_count  PLS_INTEGER;
    lv_sql  nm3type.max_varchar2;
    --
    c_events  sys_refcursor;
    --
  BEGIN
    /*
    ||Init the domain lookups.
    */
    init_lookups;
    --
    lv_sql := gen_get_events_sql
               ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')
                                   ||' = ''PUBLISHED'''
               ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                                   ||' NOT IN(''ABNORMAL LOAD MOVEMENTS'',''EMBARGO'',''TRAFFIC INCIDENTS'')'
               ||CHR(10)||'   AND ('||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'ACTUAL_START_DATE')||' IS NOT NULL'
               ||CHR(10)||'        OR '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'PLANNED_START_DATE')||' <= SYSDATE + 7)'
    ;
    --
nm_debug.debug(lv_sql);
    OPEN c_events FOR lv_sql;
    --
    LOOP
      --
      FETCH c_events
       BULK COLLECT
       INTO lt_events
      LIMIT 1000;
      --
      lv_file_count := lt_files.COUNT+1;
      lt_files(lv_file_count) := 'NTISFullExport_'||lv_file_count||'_'||TO_CHAR(pi_run_date,'YYYYMMDD_HH24MISS')||'.xml';
      --
      write_events_to_srw_file(pi_events   => lt_events
                              ,pi_out_dir  => pi_out_dir
                              ,pi_filename => lt_files(lt_files.COUNT));
      --
      EXIT WHEN c_events%NOTFOUND;
      --
    END LOOP;
    --
    upload_files(pi_ftp_details => pi_ftp_details
                ,pi_from_dir    => pi_out_dir
                ,pi_files       => lt_files);
    --
  END create_full_srw_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_update_srw_file(pi_out_dir       IN hig_process_type_files.hptf_output_destination%TYPE
                                  ,pi_ftp_details   IN ftp_con_rec
                                  ,pi_run_date      IN DATE
                                  ,pi_prev_run_date IN DATE)
    IS
    --
    lt_events  nem_event_tab;
    lt_files   nm3type.tab_varchar80;
    --
    lv_file_count  PLS_INTEGER;
    lv_sql  nm3type.max_varchar2;
    --
    c_events  sys_refcursor;
    --
  BEGIN
    /*
    ||Init the domain lookups.
    */
    init_lookups;
    /*
    ||Create the updates file.
    */
    lt_files(1) := 'NTISUpdate_'||TO_CHAR(pi_run_date,'YYYYMMDD_HH24MISS')||'.xml';
    --
    lv_sql := gen_get_events_sql
               ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')
                                   ||' = ''PUBLISHED'''
               ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                                   ||' NOT IN(''ABNORMAL LOAD MOVEMENTS'',''EMBARGO'',''TRAFFIC INCIDENTS'')'
               ||CHR(10)||'   AND ('||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'ACTUAL_START_DATE')||' IS NOT NULL'
               ||CHR(10)||'        OR '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'PLANNED_START_DATE')||' <= SYSDATE + 7)'
               ||CHR(10)||'   AND iit_date_modified BETWEEN :last_run_date AND :run_date'
    ;
    --
nm_debug.debug(lv_sql);
nm_debug.debug('Prev Date '||TO_CHAR(pi_prev_run_date,'DD-MON-YYYY HH24:MI:SS'));
nm_debug.debug('Run Date '||TO_CHAR(pi_run_date,'DD-MON-YYYY HH24:MI:SS'));
    OPEN c_events FOR lv_sql USING pi_prev_run_date, pi_run_date;
    --
    LOOP
      --
      FETCH c_events
       BULK COLLECT
       INTO lt_events
      LIMIT 1000;
      --
      write_events_to_srw_file(pi_events   => lt_events
                              ,pi_out_dir  => pi_out_dir
                              ,pi_filename => lt_files(lt_files.COUNT));
      --
      EXIT WHEN c_events%NOTFOUND;
      --
    END LOOP;
    /*
    ||Create the cancelations file.
    */
    lt_files(2) := 'NTISCancellations_'||TO_CHAR(pi_run_date,'YYYYMMDD_HH24MISS')||'.xml';
    --
    write_srw_cancellation_file(pi_out_dir       => pi_out_dir
                               ,pi_filename      => lt_files(lt_files.COUNT)
                               ,pi_run_date      => pi_run_date
                               ,pi_prev_run_date => pi_prev_run_date);
    /*
    ||Upload the files to the FTP site.
    */
    upload_files(pi_ftp_details => pi_ftp_details
                ,pi_from_dir    => pi_out_dir
                ,pi_files       => lt_files);
    --
  END create_update_srw_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE initialise_full_export
    IS
    --
    lv_run_date  DATE;
    lv_out_dir   hig_process_type_files.hptf_output_destination%TYPE;
    lr_ftp_det   ftp_con_rec;
    --
  BEGIN
    --
nm_debug.debug_on;
    hig_process_api.log_it('Starting creation and upload of interface files using NTIS Interface '||get_body_version);
    --
    get_process_details(po_directory   => lv_out_dir
                       ,po_ftp_details => lr_ftp_det
                       ,po_run_date    => lv_run_date);
    --
    create_full_srw_file(pi_out_dir     => lv_out_dir
                        ,pi_ftp_details => lr_ftp_det
                        ,pi_run_date    => lv_run_date);
    --
    hig_process_api.log_it('Creation and upload of interface files successful.');
    hig_process_api.process_execution_end(pi_success_flag => 'Y');
    --
nm_debug.debug_off;
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('Creation and Upload of Interface File not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
nm_debug.debug_off;
  END initialise_full_export;
  
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE initialise_update
    IS
    --
    lv_run_date       DATE;
    lv_prev_run_date  DATE;
    lv_out_dir        hig_process_type_files.hptf_output_destination%TYPE;
    lr_ftp_det        ftp_con_rec;
    --
  BEGIN
nm_debug.debug_on;
    --
    hig_process_api.log_it('Starting creation and upload of update files using NTIS Interface '||get_body_version);
    --
    get_process_details(pi_full_exp_name => 'NEM NTIS Interface Full Export'
                       ,po_directory     => lv_out_dir
                       ,po_ftp_details   => lr_ftp_det
                       ,po_run_date      => lv_run_date
                       ,po_prev_run_date => lv_prev_run_date);
    --
    create_update_srw_file(pi_out_dir       => lv_out_dir
                          ,pi_ftp_details   => lr_ftp_det
                          ,pi_run_date      => lv_run_date
                          ,pi_prev_run_date => lv_prev_run_date);
    --
    hig_process_api.log_it('Creation and upload of update files successful.');
    hig_process_api.process_execution_end(pi_success_flag => 'Y');
    --
nm_debug.debug_off;
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('Creation and upload of update files not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
nm_debug.debug_off;
  END initialise_update;
--
-----------------------------------------------------------------------------
--
END nem_ntis_interface;
/

show err