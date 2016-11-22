-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/rif_interface/install.sql-arc   1.0   22 Nov 2016 15:47:12   Mike.Huitson  $
--       Module Name      : $Workfile:   install.sql  $
--       Date into PVCS   : $Date:   22 Nov 2016 15:47:12  $
--       Date fetched Out : $Modtime:   21 Nov 2016 19:05:16  $
--       Version          : $Revision:   1.0  $
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
      ,'NEM_RIF_OUT'
      ,'NEM RIF Interface Output'
      ,NULL
      ,NULL
      ,NULL
      ,NULL
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_ftp_types
                   WHERE hft_type = 'NEM_RIF_OUT')
/

INSERT 
  INTO hig_directories
      (hdir_name
      ,hdir_path
      ,hdir_url
      ,hdir_comments
      ,hdir_protected)
SELECT 'NEM_RIF_OUT_DIRECTORY'
      ,'<to be specified>'
      ,'<to be specified>'
      ,'Location for NEM XML Schemas.'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 'X'
                    FROM hig_directories
                   WHERE hdir_name = 'NEM_RIF_OUT_DIRECTORY')
/

INSERT 
  INTO hig_directory_roles
      (hdr_name
      ,hdr_role
      ,hdr_mode)
SELECT 'NEM_RIF_OUT_DIRECTORY'
      ,'NEM_ADMIN'
      ,'NORMAL'
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_directory_roles
                   WHERE hdr_name = 'NEM_RIF_OUT_DIRECTORY'
                     AND hdr_role = 'NEM_ADMIN')
/

BEGIN
  --
  hig_directories_api.grant_all_dir_roles(pi_name => 'NEM_RIF_OUT_DIRECTORY');
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
BEGIN
  --
  IF NOT hpt_exists(pi_name => 'NEM RIF Interface Full Export')
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
            ,'NEM RIF Interface Full Export'
            ,'Exports ALL current and future Events.'
            ,'nem_rif_interface.initialise_full_export;'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'N'
            ,'Y'
            ,'N'
            ,(SELECT hft_id
                FROM hig_ftp_types
               WHERE hft_type = 'NEM_RIF_OUT')
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
            ,'NEM RIF Interface Full Export File'
            ,lv_process_type_id
            ,'N'
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'NEM_RIF_OUT_DIRECTORY'
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
  IF NOT hpt_exists(pi_name => 'NEM RIF Interface Update Export')
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
            ,'NEM RIF Interface Update Export'
            ,'Exports current and future Events that have been updated since the previous execution or full export.'
            ,'nem_rif_interface.initialise_update;'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'Y'
            ,'Y'
            ,'N'
            ,(SELECT hft_id
                FROM hig_ftp_types
               WHERE hft_type = 'NEM_RIF_OUT')
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
            ,'NEM RIF Interface Update Export File'
            ,lv_process_type_id
            ,'N'
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'NEM_RIF_OUT_DIRECTORY'
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
  IF NOT hpt_exists(pi_name => 'NEM RIF Interface Domain Export')
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
            ,'NEM RIF Interface Domain Export'
            ,'Exports NEM Domains.'
            ,'nem_rif_interface.initialise_domain;'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'Y'
            ,'Y'
            ,'N'
            ,(SELECT hft_id
                FROM hig_ftp_types
               WHERE hft_type = 'NEM_RIF_OUT')
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
            ,'NEM RIF Interface Domain Export File'
            ,lv_process_type_id
            ,'N'
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,'NEM_RIF_OUT_DIRECTORY'
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
        'RIFLVMS'
       ,'NEM'
       ,'NEM RIF Interface LVMS'
       ,'The Location Viewing Methods to be used when exporting Event Impacted Network locations. This can be a comma separated list of one or more LVM IDs'
       ,''
       ,'VARCHAR2'
       ,'Y'
       ,'N'
       ,2000 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'RIFLVMS')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'RIFLVMS'
       ,'2' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'RIFLVMS')
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
        'RIFMAINT'
       ,'NEM'
       ,'RIF File Maintanence'
       ,'The number of hours to retain exported files in the Oracle Directory and FTP site (if configured).'
       ,''
       ,'NUMBER'
       ,'N'
       ,'N'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'RIFMAINT')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'RIFMAINT'
       ,'72' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'RIFMAINT')
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
        'RIFEXPDOM'
       ,'NEM'
       ,'RIF Always Export Domains'
       ,'Export the Domains file everytime a Full Export or Update file is produced.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N'
       ,'N'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'RIFEXPDOM')
/

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'RIFEXPDOM'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'RIFEXPDOM')
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
  EXECUTE IMMEDIATE 'CREATE TABLE nem_rif_log'
                  ||'(nrl_nevt_id          NUMBER(38)'
                  ||',nrl_date_last_sent   DATE)';
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
  EXECUTE IMMEDIATE 'ALTER TABLE nem_rif_log ADD(CONSTRAINT nem_rif_log_pk PRIMARY KEY(nrl_nevt_id))';
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
  EXECUTE IMMEDIATE 'ALTER TABLE nem_rif_log ADD(CONSTRAINT nrl_fk_nevt FOREIGN KEY(nrl_nevt_id) REFERENCES nem_events(nevt_id))';
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
  EXECUTE IMMEDIATE 'CREATE TABLE nem_rif_files'
                  ||'(nrf_hpf_file_id   NUMBER(38)'
                  ||',nrf_ftp_success   VARCHAR2(1))';
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
  EXECUTE IMMEDIATE 'ALTER TABLE nem_rif_files ADD(CONSTRAINT nem_rif_files_pk PRIMARY KEY(nrf_hpf_file_id))';
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
  EXECUTE IMMEDIATE 'ALTER TABLE nem_rif_files ADD(CONSTRAINT nrf_fk_hpf FOREIGN KEY(nrf_hpf_file_id) REFERENCES hig_process_files(hpf_file_id) ON DELETE CASCADE)';
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
  EXECUTE IMMEDIATE 'ALTER TABLE nem_rif_files ADD(CONSTRAINT nrf_ftp_success_yn_chk CHECK(nrf_ftp_success IN (''Y'',''N'')))';
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

CREATE OR REPLACE FORCE VIEW rif_domains AS
SELECT *
  FROM (SELECT hco_domain  domain
              ,hco_seq     seq
              ,hco_code    code
              ,hco_meaning meaning
          FROM hig_codes
         WHERE hco_domain IN('IMPACT_REASON'
                            ,'NEM_XSP'
                            ,'NEM_Y_OR_N'
                            ,'SPEED_LIMIT'
                            ,'TRAFFIC_MANAGEMENT')
        UNION ALL
        SELECT ial_domain  domain
              ,ial_seq     seq
              ,ial_value   code
              ,ial_meaning meaning
          FROM nm_inv_attri_lookup_all
         WHERE ial_domain IN(SELECT ita_id_domain
                               FROM nm_inv_type_attribs_all
                              WHERE ita_inv_type = nem_util.get_event_inv_type
                                AND ita_id_domain IS NOT NULL
                                AND ita_id_domain IS NOT IN('NEM_YES_NO'
                                                           ,'NEM_NO_YES')
                                AND ita_view_col_name IN('EVENT_TYPE'
                                                        ,'EVENT_STATUS'
                                                        ,'DATA_SOURCE'
                                                        ,'PLANNED_DURATION_UNIT'
                                                        ,'DISTRIBUTE'
                                                        ,'NATURE_OF_WORKS'
                                                        ,'DELAY'
                                                        ,'MOBILE_LANE_CLOSURE'
                                                        ,'ALTERNATE_ROUTE_USED')))
 ORDER
    BY domain
      ,seq
/
