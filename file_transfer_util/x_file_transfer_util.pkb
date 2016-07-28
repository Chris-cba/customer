CREATE OR REPLACE PACKAGE BODY x_file_transfer_util
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/file_transfer_util/x_file_transfer_util.pkb-arc   1.0   28 Jul 2016 13:51:50   Mike.Huitson  $
  --       Module Name      : $Workfile:   x_file_transfer_util.pkb  $
  --       Date into PVCS   : $Date:   28 Jul 2016 13:51:50  $
  --       Date fetched Out : $Modtime:   28 Jul 2016 13:47:00  $
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
  g_package_name   CONSTANT VARCHAR2 (30) := 'x_file_transfer_util';
  --
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
  -----------------------------------------------------------------------------
  --
  FUNCTION get_ftp_details(pi_hft_id IN hig_ftp_types.hft_id%TYPE)
    RETURN ftp_con_rec IS
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
          ,hfc_ftp_in_dir
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
  PROCEDURE get_process_details(pi_transfer_direction IN     VARCHAR2 DEFAULT 'UPLOAD'
                               ,po_file_data          IN OUT hig_process_api.rec_temp_files
                               ,po_ftp_details        IN OUT ftp_con_rec)
    IS
    --
    lv_process_id  hig_processes.hp_process_id%TYPE := hig_process_api.get_current_process_id;
    lv_ftp_type_id hig_process_types.hpt_polling_ftp_type_id%TYPE;
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
    ||Check the transfer direction.
    */
    IF pi_transfer_direction NOT IN('UPLOAD', 'DOWNLOAD')
     THEN
        raise_application_error(-20001,'Invalid transfer direction supplied.');
    END IF;
    /*
    ||Get the output destination.
    */
    BEGIN
      po_file_data.destination_type := 'ORACLE_DIRECTORY';
      /*
      ||Init the file data.
      */
      IF pi_transfer_direction = 'UPLOAD'
       THEN
          --
          po_file_data.I_or_O := 'O';
          --
          SELECT hptf_output_destination
                ,hptf_file_type_id
            INTO po_file_data.destination
                ,po_file_data.file_type_id
            FROM hig_process_type_files
                ,hig_processes
           WHERE hp_process_id = lv_process_id
             AND hp_process_type_id = hptf_process_type_id
             AND hptf_output_destination_type = 'ORACLE_DIRECTORY'
               ;
      ELSE
          --
          po_file_data.I_or_O := 'I';
          --
          SELECT hptf_input_destination
                ,hptf_file_type_id
            INTO po_file_data.destination
                ,po_file_data.file_type_id
            FROM hig_process_type_files
                ,hig_processes
           WHERE hp_process_id = lv_process_id
             AND hp_process_type_id = hptf_process_type_id
             AND hptf_input_destination_type = 'ORACLE_DIRECTORY'
               ;      
      END IF;
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20001,'Unable to establish oracle directory.');
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
        raise_application_error(-20001,'Unable to establish FTP Type.');
    END IF;
    --
    CLOSE get_ftp;
    --
    po_ftp_details := get_ftp_details(pi_hft_id => lv_ftp_type_id);
    --
  END get_process_details;
  --

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE upload_files(pi_delete_source_files IN BOOLEAN DEFAULT TRUE)
    IS
    --
    lr_ftp_con    ftp_con_rec;
    lr_dir        hig_directories%ROWTYPE;
    lr_file_data  hig_process_api.rec_temp_files;
    --
    lt_files  nm3file.file_list;
    --
    lv_conn  utl_tcp.connection;
    --
  BEGIN
    /*
    ||Get the process details.
    */
    get_process_details(po_file_data   => lr_file_data
                       ,po_ftp_details => lr_ftp_con);
    IF lr_ftp_con.conn_id IS NOT NULL
     THEN
        /*
        ||Get the contents of the directory.
        */
        lr_dir := hig_directories_api.get(pi_hdir_name => lr_file_data.destination);
        --
        lt_files := nm3file.get_files_in_directory(pi_dir       => lr_dir.hdir_path
                                                  ,pi_extension => NULL);
        --
        hig_process_api.log_it(pi_message      => lt_files.COUNT||' files to Upload.'
                              ,pi_summary_flag => 'Y');
        --
        IF lt_files.COUNT > 0
         THEN
            /*
            ||Connect to the ftp server.
            */
            hig_process_api.log_it(pi_message      => 'Logging into FTP Server '||lr_ftp_con.hostname||' '||lr_ftp_con.password
                                  ,pi_summary_flag => 'Y');
            lv_conn := nm3ftp.login(p_host => lr_ftp_con.hostname
                                   ,p_port => lr_ftp_con.port
                                   ,p_user => lr_ftp_con.username
                                   ,p_pass => lr_ftp_con.password);
            hig_process_api.log_it(pi_message      => 'FTP Connection established '||lv_conn.remote_host
                                  ,pi_summary_flag => 'Y');
            --
            FOR i IN 1..lt_files.COUNT LOOP
              --
              lr_file_data.filename := lt_files(i);
              --
              /*
              ||Upload the file.
              */
              hig_process_api.log_it(pi_message      => 'Uploading file to '||lr_ftp_con.out_dir||lr_file_data.filename
                                    ,pi_summary_flag => 'N');
              --
              nm3ftp.binary(p_conn => lv_conn);
              --
              nm3ftp.put(p_conn      => lv_conn
                        ,p_from_dir  => lr_file_data.destination
                        ,p_from_file => lr_file_data.filename
                        ,p_to_file   => lr_ftp_con.out_dir||'$'||lr_file_data.filename);
              --
              nm3ftp.rename(p_conn => lv_conn
                           ,p_from => lr_ftp_con.out_dir||'$'||lr_file_data.filename
                           ,p_to   => lr_ftp_con.out_dir||lr_file_data.filename);
              --
              hig_process_api.log_it(pi_message      => 'File Uploaded.'
                                    ,pi_summary_flag => 'N');
              /*
              ||Remove the file from the directory.
              */
              IF pi_delete_source_files
               THEN
                  --
                  hig_process_api.log_it(pi_message      => 'Deleting file '||lr_file_data.filename||' from ORACLE DIRECTORY ['||lr_file_data.destination||']'
                                        ,pi_summary_flag => 'N');
                  --
                  utl_file.fremove(location => lr_file_data.destination
                                  ,filename => lr_file_data.filename);
                  --
                  hig_process_api.log_it(pi_message      => 'File deleted.'
                                        ,pi_summary_flag => 'N');
                  --
              END IF;
              --
            END LOOP;
            --
            hig_process_api.log_it(pi_message      => lt_files.COUNT||' files Uploaded.'
                                  ,pi_summary_flag => 'Y');
            /*
            ||Close FTP Connection.
            */
            nm3ftp.logout(p_conn => lv_conn);
            utl_tcp.close_all_connections;
            --
            hig_process_api.log_it(pi_message      => 'FTP Connection Closed.'
                                  ,pi_summary_flag => 'Y');
            hig_process_api.log_it('File upload complete.');
            hig_process_api.process_execution_end(pi_success_flag => 'Y');
            --
        ELSE
            /*
            ||Nothing to transfer so drop the execution to avoid cloging up
            ||the process log with pointless detail.
            */
            hig_process_api.drop_execution;
        END IF;
        --
    END IF;
    --
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('File upload not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
        utl_tcp.close_all_connections;
  END;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE download_files(pi_delete_source_files IN BOOLEAN DEFAULT TRUE)
    IS
    --
    lr_ftp_con    ftp_con_rec;
    lr_file_data  hig_process_api.rec_temp_files;
    --
    lt_files  nm3ftp.t_string_table;
    --
    lv_conn           utl_tcp.connection;
    lv_forward_slash  VARCHAR2(1) := CHR(47);
    --
  BEGIN
    /*
    ||Get the process details.
    */
    get_process_details(pi_transfer_direction => 'DOWNLOAD'
                       ,po_file_data          => lr_file_data
                       ,po_ftp_details        => lr_ftp_con);
    IF lr_ftp_con.conn_id IS NOT NULL
     THEN
        /*
        ||Connect to the ftp server.
        */
        hig_process_api.log_it(pi_message      => 'Logging into FTP Server '||lr_ftp_con.hostname||' '||lr_ftp_con.password
                              ,pi_summary_flag => 'Y');
        lv_conn := nm3ftp.login(p_host => lr_ftp_con.hostname
                               ,p_port => lr_ftp_con.port
                               ,p_user => lr_ftp_con.username
                               ,p_pass => lr_ftp_con.password);
        hig_process_api.log_it(pi_message      => 'FTP Connection established '||lv_conn.remote_host
                              ,pi_summary_flag => 'Y');
        /*
        ||List the files.
        */
        nm3ftp.list(p_conn    => lv_conn
                   ,p_dir     => lr_ftp_con.in_dir
                   ,p_list    => lt_files
                   ,p_command => 'NLST');
        --
        hig_process_api.log_it(pi_message      => lt_files.COUNT||' files to downloaded.'
                              ,pi_summary_flag => 'Y');
        --
        IF lt_files.COUNT > 0
         THEN
            /*
            ||Get the target directory details.
            */
            FOR i IN 1..lt_files.COUNT LOOP
              /*
              ||Set the target filename.
              ||NB. The SUNSTR removes the path from the list result.
              */
              lr_file_data.filename := SUBSTR(lt_files(i)
                                             ,INSTR(lt_files(i),lv_forward_slash,-1)+1
                                             ,LENGTH(lt_files(i))-INSTR(lt_files(i),lv_forward_slash,-1));
              /*
              ||Download the file.
              */
              hig_process_api.log_it(pi_message      => 'Downloading file '||lt_files(i)||' to Oracle Directory ['||lr_file_data.destination||']'
                                    ,pi_summary_flag => 'N');
              --
              nm3ftp.binary(p_conn => lv_conn);
              --
              nm3ftp.get(p_conn        => lv_conn
                        ,p_from_file   => lt_files(i)
                        ,p_to_dir      => lr_file_data.destination
                        ,p_to_file     => lr_file_data.filename);
              --
              hig_process_api.log_it(pi_message      => 'File downloaded.'
                                    ,pi_summary_flag => 'N');
              /*
              ||Remove the file from the FTP site.
              */
              IF pi_delete_source_files
               THEN
                  --
                  hig_process_api.log_it(pi_message      => 'Deleting file '||lr_ftp_con.in_dir||lr_file_data.filename
                                        ,pi_summary_flag => 'N');
                  --
                  nm3ftp.delete(p_conn => lv_conn
                               ,p_file => lt_files(i));
                  --
                  hig_process_api.log_it(pi_message      => 'File deleted.'
                                        ,pi_summary_flag => 'N');
                  --
              END IF;
              --
            END LOOP;
            --
            hig_process_api.log_it(pi_message      => lt_files.COUNT||' files downloaded.'
                                  ,pi_summary_flag => 'Y');
            --
        END IF;
        /*
        ||Close FTP Connection.
        */
        nm3ftp.logout(p_conn => lv_conn);
        utl_tcp.close_all_connections;
        --
        hig_process_api.log_it(pi_message      => 'FTP Connection Closed.'
                              ,pi_summary_flag => 'Y');
        hig_process_api.log_it('File download complete.');
        hig_process_api.process_execution_end(pi_success_flag => 'Y');
        --
        IF lt_files.COUNT = 0
         THEN
            /*
            ||Nothing to transfer so drop the execution to avoid cloging up
            ||the process log with pointless detail.
            */
            hig_process_api.drop_execution;
        END IF;
        --
    END IF;
    --
  EXCEPTION
    WHEN others
     THEN
        hig_process_api.log_it('ERRORS OCCURRED DURING THE PROCESS.');
        hig_process_api.log_it(SQLERRM||CHR(10)||dbms_utility.format_error_backtrace);
        hig_process_api.log_it('File download not successful.');
        hig_process_api.process_execution_end(pi_success_flag => 'N');
        utl_tcp.close_all_connections;
  END;

--
-----------------------------------------------------------------------------
--
END x_file_transfer_util;
/