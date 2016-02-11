-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/nem_format/install.sql-arc   1.0   Feb 11 2016 09:36:12   Mike.Huitson  $
--       Module Name      : $Workfile:   install.sql  $
--       Date into PVCS   : $Date:   Feb 11 2016 09:36:12  $
--       Date fetched Out : $Modtime:   Feb 11 2016 09:25:52  $
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
