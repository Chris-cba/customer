-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/nem_format/install.sql-arc   1.6   07 Jul 2017 16:48:44   Mike.Huitson  $
--       Module Name      : $Workfile:   install.sql  $
--       Date into PVCS   : $Date:   07 Jul 2017 16:48:44  $
--       Date fetched Out : $Modtime:   07 Jul 2017 16:48:22  $
--       Version          : $Revision:   1.6  $
-------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-------------------------------------------------------------------------
--
--
INSERT
  INTO hig_ftp_types
      (hft_id
      ,hft_type
      ,hft_descr
      ,hft_date_created
      ,hft_date_modified
      ,hft_modified_by
      ,hft_created_by)
SELECT hft_id_seq.NEXTVAL
      ,'NEM_NTIS_OUT'
      ,'NEM NTIS Interface Output'
      ,NULL
      ,NULL
      ,NULL
      ,NULL
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_ftp_types
                   WHERE hft_type = 'NEM_NTIS_OUT')
/

INSERT 
  INTO hig_directories
      (hdir_name
      ,hdir_path
      ,hdir_url
      ,hdir_comments
      ,hdir_protected)
SELECT 'NEM_NTIS_OUT_DIRECTORY'
      ,'<to be specified>'
      ,'<to be specified>'
      ,'Location for NEM XML Schemas.'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 'X'
                    FROM hig_directories
                   WHERE hdir_name = 'NEM_NTIS_OUT_DIRECTORY')
/

INSERT 
  INTO hig_directory_roles
      (hdr_name
      ,hdr_role
      ,hdr_mode)
SELECT 'NEM_NTIS_OUT_DIRECTORY'
      ,'NEM_ADMIN'
      ,'NORMAL'
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_directory_roles
                   WHERE hdr_name = 'NEM_NTIS_OUT_DIRECTORY'
                     AND hdr_role = 'NEM_ADMIN')
/

BEGIN
  --
  hig_directories_api.grant_all_dir_roles(pi_name => 'NEM_NTIS_OUT_DIRECTORY');
  --
END;
/

/*
||Create the process types for the complete export and updates.
*/
DECLARE
  --
  lv_process_type_id  hig_process_types.hpt_process_type_id%TYPE;
  lv_file_type_id     hig_process_type_files.hptf_file_type_id%TYPE;
  lv_3min_int         hig_scheduling_frequencies.hsfr_frequency_id%TYPE;
  --
  FUNCTION hpt_exists(pi_name IN hig_process_types.hpt_name%TYPE)
    RETURN BOOLEAN IS
    --
    lv_exists  PLS_INTEGER;
    --
  BEGIN
    --
    SELECT 1
      INTO lv_exists
      FROM hig_process_types
     WHERE hpt_name = pi_name
         ;
    --
    RETURN TRUE;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        RETURN FALSE;
    WHEN others
     THEN
        RAISE;
  END hpt_exists;
  --
  FUNCTION get_3min_int
    RETURN hig_scheduling_frequencies.hsfr_frequency_id%TYPE IS
    --
    lv_retval  hig_scheduling_frequencies.hsfr_frequency_id%TYPE;
    --
  BEGIN
    --
    SELECT hsfr_frequency_id
      INTO lv_retval
      FROM hig_scheduling_frequencies
     WHERE hsfr_frequency = 'freq=minutely; interval=3;'
         ;
    --
    RETURN lv_retval;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        RETURN NULL;
    WHEN others
     THEN
        RAISE;
  END get_3min_int;
  --
BEGIN
  --
  lv_3min_int := get_3min_int;
  --
  IF lv_3min_int IS NULL
   THEN
      --
      lv_3min_int := hsfr_frequency_id_seq.NEXTVAL;
      --
      INSERT
        INTO hig_scheduling_frequencies
            (hsfr_frequency_id
            ,hsfr_meaning
            ,hsfr_frequency
            ,hsfr_interval_in_mins)
      SELECT lv_3min_int
            ,'3 Minutes'
            ,'freq=minutely; interval=3;'
            ,3
        FROM dual
       WHERE NOT EXISTS(SELECT 1
                          FROM hig_scheduling_frequencies
                         WHERE hsfr_meaning = '3 Minutes'
                           AND hsfr_frequency = 'freq=minutely; interval=3;')
      ;
  END IF;
  --
  IF NOT hpt_exists(pi_name => 'NEM NTIS Interface Full Export')
   THEN
      --
      lv_process_type_id := hpt_process_type_id_seq.NEXTVAL;
      --
      INSERT
        INTO hig_process_types
            (hpt_process_type_id
            ,hpt_name
            ,hpt_descr
            ,hpt_what_to_call
            ,hpt_initiation_module
            ,hpt_internal_module
            ,hpt_internal_module_param
            ,hpt_process_limit
            ,hpt_restartable
            ,hpt_see_in_hig2510
            ,hpt_polling_enabled
            ,hpt_polling_ftp_type_id
            ,hpt_area_type)
      SELECT lv_process_type_id
            ,'NEM NTIS Interface Full Export'
            ,'Exports ALL current and future Events.'
            ,'nem_ntis_interface.initialise_full_export;'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'N'
            ,'Y'
            ,'N'
            ,(SELECT hft_id
                FROM hig_ftp_types
               WHERE hft_type = 'NEM_NTIS_OUT')
            ,NULL
        FROM dual
           ;
      --
      INSERT
        INTO hig_process_type_roles
            (hptr_process_type_id
            ,hptr_role)
      VALUES(lv_process_type_id
            ,'NEM_ADMIN')
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,-1
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_files
            (hptf_file_type_id
            ,hptf_name
            ,hptf_process_type_id
            ,hptf_input
            ,hptf_output
            ,hptf_input_destination
            ,hptf_input_destination_type
            ,hptf_min_input_files
            ,hptf_max_input_files
            ,hptf_output_destination
            ,hptf_output_destination_type)
      VALUES(hptf_file_type_id_seq.NEXTVAL
            ,'NEM NTIS Interface Full Export File'
            ,lv_process_type_id
            ,'N'
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'NEM_NTIS_OUT_DIRECTORY'
            ,'ORACLE_DIRECTORY')
      RETURNING hptf_file_type_id INTO lv_file_type_id;
      --
      INSERT
        INTO hig_process_type_file_ext
            (hpte_file_type_id
            ,hpte_extension)
      VALUES(lv_file_type_id
            ,'xml')
           ;
      --
      COMMIT;
      --
  END IF;
  --
  IF NOT hpt_exists(pi_name => 'NEM NTIS Interface Update Export')
   THEN
      --
      lv_process_type_id := hpt_process_type_id_seq.NEXTVAL;
      --
      INSERT
        INTO hig_process_types
            (hpt_process_type_id
            ,hpt_name
            ,hpt_descr
            ,hpt_what_to_call
            ,hpt_initiation_module
            ,hpt_internal_module
            ,hpt_internal_module_param
            ,hpt_process_limit
            ,hpt_restartable
            ,hpt_see_in_hig2510
            ,hpt_polling_enabled
            ,hpt_polling_ftp_type_id
            ,hpt_area_type)
      SELECT lv_process_type_id
            ,'NEM NTIS Interface Update Export'
            ,'Exports current and future Events that have been updated since the previous execution or full export.'
            ,'nem_ntis_interface.initialise_update;'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'Y'
            ,'Y'
            ,'N'
            ,(SELECT hft_id
                FROM hig_ftp_types
               WHERE hft_type = 'NEM_NTIS_OUT')
            ,NULL
        FROM dual
           ;
      --
      INSERT
        INTO hig_process_type_roles
            (hptr_process_type_id
            ,hptr_role)
      VALUES(lv_process_type_id
            ,'NEM_ADMIN')
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,-2
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,-3
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,-4
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,-5
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_frequencies
            (hpfr_process_type_id
            ,hpfr_frequency_id
            ,hpfr_seq)
      VALUES(lv_process_type_id
            ,lv_3min_int
            ,1)
           ;
      --
      INSERT
        INTO hig_process_type_files
            (hptf_file_type_id
            ,hptf_name
            ,hptf_process_type_id
            ,hptf_input
            ,hptf_output
            ,hptf_input_destination
            ,hptf_input_destination_type
            ,hptf_min_input_files
            ,hptf_max_input_files
            ,hptf_output_destination
            ,hptf_output_destination_type)
      VALUES(hptf_file_type_id_seq.NEXTVAL
            ,'NEM NTIS Interface Update Export File'
            ,lv_process_type_id
            ,'N'
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'NEM_NTIS_OUT_DIRECTORY'
            ,'ORACLE_DIRECTORY')
      RETURNING hptf_file_type_id INTO lv_file_type_id;
      --
      INSERT
        INTO hig_process_type_file_ext
            (hpte_file_type_id
            ,hpte_extension)
      VALUES(lv_file_type_id
            ,'xml')
           ;
      --
      COMMIT;
      --
  END IF;
  --
END;
/

/*
||Product Options.
*/
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       ,HOL_MAX_LENGTH
       )
SELECT 
        'NTISLVMS'
       ,'NEM'
       ,'NEM NTIS Interface LVMS'
       ,'The Location Viewing Methods to be used when exporting Event Impacted Network locations. This can be a comma separated list of one or more LVM IDs'
       ,''
       ,'VARCHAR2'
       ,'Y'
       ,'N'
       ,2000 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NTISLVMS')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'NTISLVMS'
       ,'2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NTISLVMS')
/

INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       ,HOL_MAX_LENGTH
       )
SELECT 
        'NTISWINDOW'
       ,'NEM'
       ,'NTIS Export Window'
       ,'The number of days in the future to look for Events to include in the NTIS Interface i.e. Events will be included if they have already started or are planned to start within the specified number of days.'
       ,''
       ,'NUMBER'
       ,'N'
       ,'N'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NTISWINDOW')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'NTISWINDOW'
       ,'7' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NTISWINDOW')
/

INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       ,HOL_MAX_LENGTH
       )
SELECT 
        'NTISMAINT'
       ,'NEM'
       ,'NTIS File Maintanence'
       ,'The number of hours to retain exported files in the Oracle Directory and FTP site (if configured).'
       ,''
       ,'NUMBER'
       ,'N'
       ,'N'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NTISMAINT')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'NTISMAINT'
       ,'72' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NTISMAINT')
/

INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       ,HOL_MAX_LENGTH
       )
SELECT 
        'NTISCLNUPD'
       ,'NEM'
       ,'NTIS Cleanup Files on Update'
       ,'If the value of this option is ''Y'' files will be cleaned up as part of the Update File creation process, otherwise a separate process to clean up files will be required.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N'
       ,'N'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'NTISCLNUPD')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'NTISCLNUPD'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'NTISCLNUPD')
/

COMMIT
/

/*
||Tables.
*/
DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-00955); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'CREATE TABLE nem_ntis_log'
                  ||'(nnl_nevt_id          NUMBER(38)'
                  ||',nnl_date_last_sent   DATE'
                  ||',nnl_date_cancel_sent DATE)';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/

DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-02260); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'ALTER TABLE nem_ntis_log ADD(CONSTRAINT nem_ntis_log_pk PRIMARY KEY(nnl_nevt_id))';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/

DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-02275); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'ALTER TABLE nem_ntis_log ADD(CONSTRAINT nnl_fk_nevt FOREIGN KEY(nnl_nevt_id) REFERENCES nem_events(nevt_id))';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/


DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-00955); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'CREATE TABLE nem_ntis_files'
                  ||'(nnf_hpf_file_id   NUMBER(38)'
                  ||',nnf_ftp_success   VARCHAR2(1))';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/

DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-02260); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'ALTER TABLE nem_ntis_files ADD(CONSTRAINT nem_ntis_files_pk PRIMARY KEY(nnf_hpf_file_id))';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/

DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-02275); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'ALTER TABLE nem_ntis_files ADD(CONSTRAINT nnf_fk_hpf FOREIGN KEY(nnf_hpf_file_id) REFERENCES hig_process_files(hpf_file_id) ON DELETE CASCADE)';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/

DECLARE
  --   
  already_exists EXCEPTION;
  PRAGMA exception_init(already_exists,-02264); 
  -- 
BEGIN
  --
  EXECUTE IMMEDIATE 'ALTER TABLE nem_ntis_files ADD(CONSTRAINT nnf_ftp_success_yn_chk CHECK(nnf_ftp_success IN (''Y'',''N'')))';
  --   
EXCEPTION
  WHEN already_exists 
   THEN
      Null;
  WHEN OTHERS
   THEN
      RAISE;
END;
/
