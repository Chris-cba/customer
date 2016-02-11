CREATE OR REPLACE PACKAGE BODY nem_ntis_interface
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/nem_format/nem_ntis_interface.pkb-arc   1.0   Feb 11 2016 09:36:12   Mike.Huitson  $
  --       Module Name      : $Workfile:   nem_ntis_interface.pkb  $
  --       Date into PVCS   : $Date:   Feb 11 2016 09:36:12  $
  --       Date fetched Out : $Modtime:   Feb 05 2016 16:15:20  $
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
--    ELSE
--        lv_retval := '<'||pi_element||'></'||pi_element||'>';
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
    lv_wallet_path VARCHAR2(200) := 'file:E:\Wallets\NEMDEV04';
    lv_wallet_pass VARCHAR2(10) := 'bentley1';
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
                               ,p_wallet_path => lv_wallet_path
                               ,p_wallet_pass => lv_wallet_pass);
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
    IF pi_text IS NOT NULL
     THEN
        pi_tab(pi_tab.COUNT+1) := LPAD(' ',NVL(pi_indent,0))||pi_text;
    END IF;
    --
  END add_line;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE write_events_to_file(pi_events   IN nem_event_tab
                                ,pi_out_dir  IN hig_process_type_files.hptf_output_destination%TYPE
                                ,pi_filename IN VARCHAR2)
    IS
    --
    lt_output            nm3type.tab_varchar32767;
    lt_impacted_network  location_tab;
    lt_group_locations   location_tab;
    --
    lv_lvm_id        nem_lvms.nlvm_id%TYPE := get_lvm;
    --
    CURSOR get_contacts(cp_nevt_id nem_events.nevt_id%TYPE)
        IS
    SELECT *
      FROM nem_event_contacts
     WHERE nec_nevt_id = cp_nevt_id
     ORDER
        BY nec_id DESC
         ;
    --
    TYPE nec_tab IS TABLE OF nem_event_contacts%ROWTYPE;
    lt_nec  nec_tab;
    --
    CURSOR get_impact_groups(cp_nevt_id    nem_events.nevt_id%TYPE
                            ,cp_no_impact  nem_impact_groups.nig_name%TYPE)
        IS
    SELECT *
      FROM nem_impact_groups
     WHERE nig_nevt_id = cp_nevt_id
       AND nig_name != cp_no_impact
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
    CURSOR get_roads(cp_nevt_id nem_events.nevt_id%TYPE)
        IS
    SELECT *
      FROM nem_roads
     WHERE nerd_rec_id = cp_nevt_id
         ;
    --
    TYPE nerd_tab IS TABLE OF nem_roads%ROWTYPE;
    lt_nerd  nerd_tab;
    --
  BEGIN
    --
    add_line(pi_text => '<event_transfer_file xmlns="http://schemas.bentley.com/NetworkEventManager/NTISInterface">'
            ,pi_tab  => lt_output);
    --
    FOR i IN 1..pi_events.COUNT LOOP
      --
      hig_process_api.log_it(pi_message      => 'Processing Event '
                                                ||nem_util.get_formatted_event_number(pi_event_number   => pi_events(i).event_number
                                                                                     ,pi_version_number => pi_events(i).version_number)
                            ,pi_summary_flag => 'N');
      /*
      ||Open the event tag.
      */
      add_line(pi_text   => '<event>'
              ,pi_indent => 2
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'event_number'
                                    ,pi_data    => pi_events(i).event_number)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'version'
                                    ,pi_data    => pi_events(i).version_number)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'distribute'
                                    ,pi_data    => pi_events(i).distribute)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'planned_sdate'
                                    ,pi_data    => TO_CHAR(pi_events(i).planned_start_date,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'planned_edate'
                                    ,pi_data    => TO_CHAR(pi_events(i).planned_complete_date,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'actual_sdate'
                                    ,pi_data    => TO_CHAR(pi_events(i).actual_start_date,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'actual_edate'
                                    ,pi_data    => TO_CHAR(pi_events(i).actual_complete_date,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'description'
                                    ,pi_data    => pi_events(i).description)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'status'
                                    ,pi_data    => pi_events(i).event_status)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'delay'
                                    ,pi_data    => pi_events(i).delay)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'type'
                                    ,pi_data    => pi_events(i).event_type)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'notes'
                                    ,pi_data    => pi_events(i).notes)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'user_responsible'
                                    ,pi_data    => pi_events(i).user_responsible)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'modified'
                                    ,pi_data    => TO_CHAR(pi_events(i).last_modified,c_datetimefmt))
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'nature_of_works'
                                    ,pi_data    => pi_events(i).nature_of_works)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'he_ref'
                                    ,pi_data    => pi_events(i).he_ref)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      --
      add_line(pi_text   => gen_tags(pi_element => 'works_ref'
                                    ,pi_data    => pi_events(i).works_ref)
              ,pi_indent => 4
              ,pi_tab    => lt_output);
      /*
      ||Get the Contacts.
      */
      OPEN  get_contacts(pi_events(i).nevt_id);
      FETCH get_contacts
       BULK COLLECT
       INTO lt_nec;
      CLOSE get_contacts;
      --
      IF lt_nec.COUNT > 0
       THEN
          --
          add_line(pi_text   => '<contacts>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
          FOR j IN 1..lt_nec.COUNT LOOP
            --
            add_line(pi_text   => '<contact>'
                    ,pi_indent => 6
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'type'
                                          ,pi_data    => lt_nec(j).nec_type)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'name'
                                          ,pi_data    => lt_nec(j).nec_name)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'ref'
                                          ,pi_data    => lt_nec(j).nec_ref)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'day_tel'
                                          ,pi_data    => lt_nec(j).nec_day_telephone)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'night_tel'
                                          ,pi_data    => lt_nec(j).nec_night_telephone)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'notes'
                                          ,pi_data    => lt_nec(j).nec_notes)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => '</contact>'
                    ,pi_indent => 6
                    ,pi_tab    => lt_output);
            --
          END LOOP;
          --
          add_line(pi_text   => '</contacts>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
      END IF;
      /*
      ||Get the Roads.
      */
      OPEN  get_roads(pi_events(i).nevt_id);
      FETCH get_roads
       BULK COLLECT
       INTO lt_nerd;
      CLOSE get_roads;
      --
      IF lt_nerd.COUNT > 0
       THEN
          --
          add_line(pi_text   => '<roads>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
          FOR j IN 1..lt_nerd.COUNT LOOP
            --
            add_line(pi_text   => gen_tags(pi_element => 'road'
                                          ,pi_data    => lt_nerd(j).nerd_road)
                    ,pi_indent => 6
                    ,pi_tab    => lt_output);
            --
          END LOOP;
          --
          add_line(pi_text   => '</roads>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
      END IF;
      /*
      ||Get the Impact Group Contents.
      */
      OPEN  get_impact_groups(pi_events(i).nevt_id
                             ,nem_util.get_no_impact_group_name);
      FETCH get_impact_groups
       BULK COLLECT
       INTO lt_nig;
      CLOSE get_impact_groups;
      --
      IF lt_nig.COUNT > 0
       THEN
          add_line(pi_text   => '<operational_impact>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
          FOR j IN 1..lt_nig.COUNT LOOP
            --
            add_line(pi_text   => '<impact_group>'
                    ,pi_indent => 6
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'name'
                                          ,pi_data    => lt_nig(j).nig_name)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'speed_limit'
                                          ,pi_data    => lt_nig(j).nig_speed_limit)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'carriageway_closure'
                                          ,pi_data    => lt_nig(j).nig_carriageway_closure)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'height_restriction'
                                          ,pi_data    => lt_nig(j).nig_height_restriction)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'width_restriction'
                                          ,pi_data    => lt_nig(j).nig_width_restriction)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'weight_restriction'
                                          ,pi_data    => lt_nig(j).nig_weight_restriction)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'contraflow'
                                          ,pi_data    => lt_nig(j).nig_contraflow)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            --
            add_line(pi_text   => gen_tags(pi_element => 'traffic_management'
                                          ,pi_data    => lt_nig(j).nig_traffic_management)
                    ,pi_indent => 8
                    ,pi_tab    => lt_output);
            /*
            ||Get the XSPs (changes).
            */
            OPEN  get_xsps(lt_nig(j).nig_id);
            FETCH get_xsps
             BULK COLLECT
             INTO lt_nigx;
            CLOSE get_xsps;
            --
            IF lt_nigx.COUNT > 0
             THEN
                --
                add_line(pi_text   => '<changes>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
                FOR k IN 1..lt_nigx.COUNT LOOP
                  --
                  add_line(pi_text   => '<change>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'xsp'
                                                ,pi_data    => lt_nigx(k).nigx_xsp)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'reason'
                                                ,pi_data    => lt_nigx(k).nigx_reason)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => '</change>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                END LOOP;
                --
                add_line(pi_text   => '</changes>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
            END IF;
            /*
            ||Get the Group Locations.
            */
            lt_group_locations := get_locations(pi_asset_id => lt_nig(j).nig_id
                                               ,pi_lvm_id   => lv_lvm_id);
            --
            IF lt_group_locations.COUNT > 0
             THEN
                --
                add_line(pi_text   => '<locations>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
                FOR k IN 1..lt_group_locations.COUNT LOOP
                  --
                  add_line(pi_text   => '<location>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'element_id'
                                                ,pi_data    => lt_group_locations(k).element_id)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'element_name'
                                                ,pi_data    => lt_group_locations(k).element_unique)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'from_offset'
                                                ,pi_data    => lt_group_locations(k).from_offset)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'to_offset'
                                                ,pi_data    => lt_group_locations(k).to_offset)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => '</location>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                END LOOP;
                --
                add_line(pi_text   => '</locations>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
            END IF;
            /*
            ||Get the schedules.
            */
            OPEN  get_schedules(lt_nig(j).nig_id);
            FETCH get_schedules
             BULK COLLECT
             INTO lt_nigs;
            CLOSE get_schedules;        
            --
            IF lt_nigs.COUNT > 0
             THEN
                --
                add_line(pi_text   => '<schedules>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
                FOR k IN 1..lt_nigs.COUNT LOOP
                  --
                  add_line(pi_text   => '<schedule>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'planned_sdate'
                                                ,pi_data    => TO_CHAR(lt_nigs(k).nigs_planned_startdate,c_datetimefmt))
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'planned_edate'
                                                ,pi_data    => TO_CHAR(lt_nigs(k).nigs_planned_enddate,c_datetimefmt))
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'actual_sdate'
                                                ,pi_data    => TO_CHAR(lt_nigs(k).nigs_actual_startdate,c_datetimefmt))
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'actual_edate'
                                                ,pi_data    => TO_CHAR(lt_nigs(k).nigs_actual_enddate,c_datetimefmt))
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'speed_limit'
                                                ,pi_data    => lt_nigs(k).nigs_speed_limit)
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => gen_tags(pi_element => 'cancel_date'
                                                ,pi_data    => TO_CHAR(lt_nigs(k).nigs_cancel_date,c_datetimefmt))
                          ,pi_indent => 12
                          ,pi_tab    => lt_output);
                  --
                  add_line(pi_text   => '</schedule>'
                          ,pi_indent => 10
                          ,pi_tab    => lt_output);
                  --
                END LOOP; --schedules
                --
                add_line(pi_text   => '</schedules>'
                        ,pi_indent => 8
                        ,pi_tab    => lt_output);
                --
            END IF;
            --
            add_line(pi_text   => '</impact_group>'
                    ,pi_indent => 6
                    ,pi_tab    => lt_output);
            --
          END LOOP; -- Impact Groups.
          --
          add_line(pi_text   => '</operational_impact>'
                  ,pi_indent => 4
                  ,pi_tab    => lt_output);
          --
      END IF;
      /*
      ||Close the clos tag.
      */
      add_line(pi_text   => '</event>'
              ,pi_indent => 2
              ,pi_tab    => lt_output);
      --
    END LOOP; -- Events.
    --
    add_line(pi_text => '</event_transfer_file>'
            ,pi_tab  => lt_output);
    --
    hig_process_api.log_it(pi_message      => 'Writing Event file '||pi_filename
                          ,pi_summary_flag => 'N');
    --
    nm3file.write_file(location     => pi_out_dir
                      ,filename     => pi_filename
                      ,all_lines    => lt_output);
    --
  END write_events_to_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE write_cancellation_file(pi_out_dir       IN hig_process_type_files.hptf_output_destination%TYPE
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
    lv_superseded_status  CONSTANT VARCHAR2(30) := 'SUPERSEDED';
    lv_published_status   CONSTANT VARCHAR2(30) := 'PUBLISHED';
    --
    c_events  sys_refcursor;
    --
  BEGIN
    --
    add_line(pi_text => '<cancelled_events xmlns="http://schemas.bentley.com/NetworkEventManager/NTISInterface">'
            ,pi_tab  => lt_output);
    --
    lv_sql := 'SELECT '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
   ||CHR(10)||'      ,MAX(naex_execution_date)'
   ||CHR(10)||'  FROM nem_action_executions'
   ||CHR(10)||'      ,nm_inv_items_all'
   ||CHR(10)||'      ,nem_events'
   ||CHR(10)||' WHERE nevt_id = iit_ne_id'
   ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = ''CANCELLED'''
   ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                       ||' NOT IN(''ABNORMAL LOAD MOVEMENTS'',''EMBARGO'',''TRAFFIC INCIDENTS'')'
   ||CHR(10)||'   AND iit_date_modified BETWEEN :last_run_date1 AND :run_date1'
   ||CHR(10)||'   AND iit_ne_id = naex_nevt_id'
   ||CHR(10)||'   AND naex_na_id = (SELECT na_id'
   ||CHR(10)||'                       FROM nem_actions'
   ||CHR(10)||'                      WHERE na_label = ''Cancel'')'
   ||CHR(10)||' GROUP'
   ||CHR(10)||'    BY '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
   ||CHR(10)||'UNION ALL'
   ||CHR(10)||'SELECT iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
   ||CHR(10)||'      ,MAX(naex_execution_date)'
   ||CHR(10)||'  FROM nem_action_executions'
   ||CHR(10)||'      ,nm_inv_items_all iit'
   ||CHR(10)||'      ,nem_events'
   ||CHR(10)||' WHERE nevt_id = iit.iit_ne_id'
   ||CHR(10)||'   AND iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = ''SUPERSEDED'''
   ||CHR(10)||'   AND iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                       ||' NOT IN(''ABNORMAL LOAD MOVEMENTS'',''EMBARGO'',''TRAFFIC INCIDENTS'')'
   ||CHR(10)||'   AND iit.iit_date_modified BETWEEN :last_run_date2 AND :run_date2'
   ||CHR(10)||'   AND EXISTS(SELECT 1'
   ||CHR(10)||'                FROM nm_inv_items_all iit2'
   ||CHR(10)||'               WHERE iit2.iit_ne_id = iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'SUPERSEDED_BY_ID')
   ||CHR(10)||'                 AND iit2.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')||' = ''PUBLISHED'''
   ||CHR(10)||'                 AND iit2.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
                                ||' != iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')||')'
   ||CHR(10)||'   AND iit.iit_ne_id = naex_nevt_id'
   ||CHR(10)||'   AND naex_na_id = (SELECT na_id'
   ||CHR(10)||'                       FROM nem_actions'
   ||CHR(10)||'                      WHERE na_label = ''Combine'')'
   ||CHR(10)||' GROUP'
   ||CHR(10)||'    BY iit.'||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_NUMBER')
    ;
    --
    OPEN c_events FOR lv_sql 
      USING pi_prev_run_date
           ,pi_run_date
           ,pi_prev_run_date
           ,pi_run_date
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
        add_line(pi_text   => '<event>'
                ,pi_indent => 2
                ,pi_tab    => lt_output);
        --
        add_line(pi_text   => gen_tags(pi_element => 'event_number'
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
        add_line(pi_text   => '</event>'
                ,pi_indent => 2
                ,pi_tab    => lt_output);
        --
      END LOOP; -- Events.
      --
      EXIT WHEN c_events%NOTFOUND;
      --
    END LOOP;
    --
    add_line(pi_text => '</cancelled_events>'
            ,pi_tab  => lt_output);
    --
    hig_process_api.log_it(pi_message      => 'Writing Cancelations file '||pi_filename
                          ,pi_summary_flag => 'N');
    --
    nm3file.write_file(location     => pi_out_dir
                      ,filename     => pi_filename
                      ,all_lines    => lt_output);
    --
  END write_cancellation_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_full_file(pi_out_dir     IN hig_process_type_files.hptf_output_destination%TYPE
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
      write_events_to_file(pi_events   => lt_events
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
  END create_full_file;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_update_files(pi_out_dir       IN hig_process_type_files.hptf_output_destination%TYPE
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
    ||Create the updates file.
    */
    lt_files(1) := 'NTISUpdate_'||TO_CHAR(pi_run_date,'YYYYMMDD_HH24MISS')||'.xml';
    --
    lv_sql := gen_get_events_sql
               ||CHR(10)||'   AND (('||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')
                                     ||' = ''PUBLISHED'''
               ||CHR(10)||'         AND ('||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'ACTUAL_START_DATE')||' IS NOT NULL'
               ||CHR(10)||'              OR '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'PLANNED_START_DATE')||' <= SYSDATE + 7)'
               ||CHR(10)||'         AND iit_date_modified BETWEEN :last_run_date AND :run_date)'
               ||CHR(10)||'       OR ('||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_STATUS')
                                       ||' = ''COMPLETED'''
               ||CHR(10)||'           AND (SELECT MAX(naex_execution_date)'
               ||CHR(10)||'                  FROM nem_action_executions'
               ||CHR(10)||'                 WHERE naex_nevt_id = iit_ne_id'
               ||CHR(10)||'                   AND (naex_description IN(''Schedule Stop'',''Event Complete'')'
               ||CHR(10)||'                        OR naex_description LIKE ''Received 0600 Notice%'')'
               ||CHR(10)||'                   AND naex_success = ''Yes'') BETWEEN :last_run_date AND :run_date))'               
               ||CHR(10)||'   AND '||nem_util.get_attrib_name_from_view_col(pi_view_col_name => 'EVENT_TYPE')
                                   ||' NOT IN(''ABNORMAL LOAD MOVEMENTS'',''EMBARGO'',''TRAFFIC INCIDENTS'')'
    ;
    --
    OPEN c_events FOR lv_sql USING pi_prev_run_date, pi_run_date, pi_prev_run_date, pi_run_date;
    --
    LOOP
      --
      FETCH c_events
       BULK COLLECT
       INTO lt_events
      LIMIT 1000;
      --
      write_events_to_file(pi_events   => lt_events
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
    write_cancellation_file(pi_out_dir       => pi_out_dir
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
  END create_update_files;

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
    hig_process_api.log_it('Starting creation and upload of interface files using NTIS Interface '||get_body_version);
    --
    get_process_details(po_directory   => lv_out_dir
                       ,po_ftp_details => lr_ftp_det
                       ,po_run_date    => lv_run_date);
    --
    create_full_file(pi_out_dir     => lv_out_dir
                    ,pi_ftp_details => lr_ftp_det
                    ,pi_run_date    => lv_run_date);
    --
    hig_process_api.log_it('Creation and upload of interface files successful.');
    hig_process_api.process_execution_end(pi_success_flag => 'Y');
    --
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('Creation and Upload of Interface File not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
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
    --
    hig_process_api.log_it('Starting creation and upload of update files using NTIS Interface '||get_body_version);
    --
    get_process_details(pi_full_exp_name => 'NEM NTIS Interface Full Export'
                       ,po_directory     => lv_out_dir
                       ,po_ftp_details   => lr_ftp_det
                       ,po_run_date      => lv_run_date
                       ,po_prev_run_date => lv_prev_run_date);
    --
    create_update_files(pi_out_dir       => lv_out_dir
                       ,pi_ftp_details   => lr_ftp_det
                       ,pi_run_date      => lv_run_date
                       ,pi_prev_run_date => lv_prev_run_date);
    --
    hig_process_api.log_it('Creation and upload of update files successful.');
    hig_process_api.process_execution_end(pi_success_flag => 'Y');
    --
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('Creation and upload of update files not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
  END initialise_update;
--
-----------------------------------------------------------------------------
--
END nem_ntis_interface;
/
