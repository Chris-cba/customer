-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/ntis_interface/install.sql-arc   1.0   26 Jan 2016 18:00:08   Mike.Huitson  $
--       Module Name      : $Workfile:   install.sql  $
--       Date into PVCS   : $Date:   26 Jan 2016 18:00:08  $
--       Date fetched Out : $Modtime:   21 Jan 2016 11:29:56  $
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

/*
||NEM to SRW Domain Maps.
*/
CREATE TABLE nem_ntis_status_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80))
/

ALTER TABLE nem_ntis_status_map
 ADD (CONSTRAINT ntis_status_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_delay_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_ntis_delay_map
 ADD (CONSTRAINT ntis_delay_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_srw_type_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_ntis_srw_type_map
 ADD (CONSTRAINT ntis_srw_type_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_srw_activity_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_ntis_srw_activity_map
 ADD (CONSTRAINT ntis_srw_activity_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_nature_of_works_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_ntis_nature_of_works_map
 ADD (CONSTRAINT ntis_nature_of_works_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_imp_grp_speed_limit
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL
,ntis_rank     NUMBER(3)    NOT NULL)
/

ALTER TABLE nem_ntis_imp_grp_speed_limit
 ADD (CONSTRAINT ntis_imp_grp_speed_limit_pk PRIMARY KEY 
  (nem_code))
/

ALTER TABLE nem_ntis_imp_grp_speed_limit
 ADD (CONSTRAINT ntis_imp_grp_speed_limit_uk UNIQUE (ntis_rank))
/

CREATE TABLE nem_ntis_schd_speed_limit
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80) NOT NULL
,ntis_rank     NUMBER(3)    NOT NULL)
/

ALTER TABLE nem_ntis_schd_speed_limit
 ADD (CONSTRAINT ntis_schd_speed_limit_pk PRIMARY KEY 
  (nem_code))
/

ALTER TABLE nem_ntis_schd_speed_limit
 ADD (CONSTRAINT ntis_schd_speed_limit_uk UNIQUE (ntis_rank))
/

CREATE TABLE nem_ntis_lane_status_map
(nem_code      VARCHAR2(30) NOT NULL
,ntis_meaning  VARCHAR2(80))
/

ALTER TABLE nem_ntis_lane_status_map
 ADD (CONSTRAINT ntis_lane_status_map_pk PRIMARY KEY 
  (nem_code))
/

CREATE TABLE nem_ntis_xsp_map
(nem_code   VARCHAR2(30) NOT NULL
,ntis_code  VARCHAR2(80))
/

ALTER TABLE nem_ntis_xsp_map
 ADD (CONSTRAINT nem_ntis_xsp_map_pk PRIMARY KEY 
  (nem_code))
/

set define off

/*
||Status.
*/
INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'CANCELLED','' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'CANCELLED')
/

INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'COMPLETED','Completed' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'COMPLETED')
/

INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'PUBLISHED','Firm' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'PUBLISHED')
/

INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'SHARED','Provisional' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'SHARED')
/

INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'SUPERSEDED','' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'SUPERSEDED')
/

INSERT INTO nem_ntis_status_map (nem_code,ntis_meaning) SELECT 'WORK IN PROGRESS','Provisional' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_status_map WHERE nem_code = 'WORK IN PROGRESS')
/

/*
||Delay
*/
INSERT INTO nem_ntis_delay_map (nem_code,ntis_meaning) SELECT 'MODERATE (10 - 30 MINS)','Moderate' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_delay_map WHERE nem_code = 'MODERATE (10 - 30 MINS)')
/

INSERT INTO nem_ntis_delay_map (nem_code,ntis_meaning) SELECT 'NO DELAY','No Delay' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_delay_map WHERE nem_code = 'NO DELAY')
/

INSERT INTO nem_ntis_delay_map (nem_code,ntis_meaning) SELECT 'SEVERE (MORE THAN 30 MINS)','Severe (more than 30 mins)' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_delay_map WHERE nem_code = 'SEVERE (MORE THAN 30 MINS)')
/

INSERT INTO nem_ntis_delay_map (nem_code,ntis_meaning) SELECT 'SLIGHT (LESS THAN 10 MINS)','Slight (less than 10 mins)' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_delay_map WHERE nem_code = 'SLIGHT (LESS THAN 10 MINS)')
/

/*
||SRW Type.
*/
INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'ABNORMAL LOAD MOVEMENTS','Abnormal Load' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'ABNORMAL LOAD MOVEMENTS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'AD-HOC ROUTINE WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'AD-HOC ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'AD-HOC STREET/ROAD WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'AD-HOC STREET/ROAD WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'AREA RENEWALS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'AREA RENEWALS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'AREA SCHEMES','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'AREA SCHEMES')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'DEVELOPER WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'DEVELOPER WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'DIVERSION/ALTERNATE ROUTE','Event' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'DIVERSION/ALTERNATE ROUTE')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'EMBARGO','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'EMBARGO')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'EMERGENCY AND URGENT ROAD WORK','Emergency Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'EMERGENCY AND URGENT ROAD WORK')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'EMERGENCY NATIONAL TECH WORKS','Emergency Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'EMERGENCY NATIONAL TECH WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'EMERGENCY REGIONAL TECH WORKS','Emergency Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'EMERGENCY REGIONAL TECH WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'EMERGENCY ROUTINE WORKS','Emergency Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'EMERGENCY ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'LICENSEE WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'LICENSEE WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'MAJOR SCHEMES','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'MAJOR SCHEMES')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'NATIONAL TECHNOLOGY WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'NATIONAL TECHNOLOGY WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'OFF NETWORK','Event' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'OFF NETWORK')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'PROGRAMMED ROUTINE WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'PROGRAMMED ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'PROGRAMMED STREET/ROAD WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'PROGRAMMED STREET/ROAD WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'REGIONAL TECHNOLOGY SCHEMES','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'REGIONAL TECHNOLOGY SCHEMES')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'REGIONAL TECHNOLOGY WORKS','Planned Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'REGIONAL TECHNOLOGY WORKS')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'SHORT STOP ACTIVITIES','Emergency Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'SHORT STOP ACTIVITIES')
/

INSERT INTO nem_ntis_srw_type_map (nem_code,ntis_meaning) SELECT 'TRAFFIC INCIDENTS','Incident' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_type_map WHERE nem_code = 'TRAFFIC INCIDENTS')
/

/*
||SRW Activity.
*/
INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'ABNORMAL LOAD MOVEMENTS','Abnormal Load - Special Order' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'ABNORMAL LOAD MOVEMENTS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'AD-HOC ROUTINE WORKS','Routine Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'AD-HOC ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'AD-HOC STREET/ROAD WORKS','Street Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'AD-HOC STREET/ROAD WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'AREA RENEWALS','Area Renewals' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'AREA RENEWALS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'AREA SCHEMES','Area Schemes' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'AREA SCHEMES')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'DEVELOPER WORKS','Developer Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'DEVELOPER WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'DIVERSION/ALTERNATE ROUTE','Event' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'DIVERSION/ALTERNATE ROUTE')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'EMBARGO','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'EMBARGO')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'EMERGENCY AND URGENT ROAD WORK','Street Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'EMERGENCY AND URGENT ROAD WORK')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'EMERGENCY NATIONAL TECH WORKS','National Technology Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'EMERGENCY NATIONAL TECH WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'EMERGENCY REGIONAL TECH WORKS','Technology Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'EMERGENCY REGIONAL TECH WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'EMERGENCY ROUTINE WORKS','Routine Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'EMERGENCY ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'LICENSEE WORKS','Licensee Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'LICENSEE WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'MAJOR SCHEMES','Major Schemes' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'MAJOR SCHEMES')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'NATIONAL TECHNOLOGY WORKS','National Technology Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'NATIONAL TECHNOLOGY WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'OFF NETWORK','Event' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'OFF NETWORK')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'PROGRAMMED ROUTINE WORKS','Routine Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'PROGRAMMED ROUTINE WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'PROGRAMMED STREET/ROAD WORKS','Street Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'PROGRAMMED STREET/ROAD WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'REGIONAL TECHNOLOGY SCHEMES','Technology Schemes' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'REGIONAL TECHNOLOGY SCHEMES')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'REGIONAL TECHNOLOGY WORKS','Technology Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'REGIONAL TECHNOLOGY WORKS')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'SHORT STOP ACTIVITIES','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'SHORT STOP ACTIVITIES')
/

INSERT INTO nem_ntis_srw_activity_map (nem_code,ntis_meaning) SELECT 'TRAFFIC INCIDENTS','Incident' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_srw_activity_map WHERE nem_code = 'TRAFFIC INCIDENTS')
/

/*
||Nature Of Works.
*/
INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'BARRIER/FENCE SAFETY REPAIRS','Safety Barrier/Fence Repairs' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'BARRIER/FENCE SAFETY REPAIRS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'BARRIERS - PERMANENT','Barriers - Permanent' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'BARRIERS - PERMANENT')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'BARRIERS - TEMPORARY','Barriers - Temporary' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'BARRIERS - TEMPORARY')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CARRIAGEWAY - ANTI-SKID','Carriageway - Anti-skid' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CARRIAGEWAY - ANTI-SKID')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CARRIAGEWAY - RECONST/REPAIR','Carriageway - Reconstruction/Repair' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CARRIAGEWAY - RECONST/REPAIR')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CENTRAL RESERVATION','Central Reserve Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CENTRAL RESERVATION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CLOSED ON POLICE INSTRUCTION','Closed on Police Instruction' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CLOSED ON POLICE INSTRUCTION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'COMMUNICATIONS','Communications' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'COMMUNICATIONS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CONSTRUCTION - BYPASS/NEW','Construction - Bypass/New' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CONSTRUCTION - BYPASS/NEW')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CONSTRUCTION-BRIDGE/STRUCTURE','Construction - Bridge/Structure' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CONSTRUCTION-BRIDGE/STRUCTURE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'CONSTRUCTION-IMPROVE/UPGRADE','Construction - Improvement/Upgrading' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'CONSTRUCTION-IMPROVE/UPGRADE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'DRAINAGE','Drainage' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'DRAINAGE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'ELECTRICAL WORKS','Electrical Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'ELECTRICAL WORKS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'GANTRY','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'GANTRY')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'HORTICULTURE(CUTTING-PLANTING)','Horticulture (cutting & planting)' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'HORTICULTURE(CUTTING-PLANTING)')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'INSPECTION/SURVEY','Inspection/Survey' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'INSPECTION/SURVEY')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'LA WORKS','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'LA WORKS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'LITTER CLEARANCE','Litter Clearance' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'LITTER CLEARANCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'POLICE RECONSTRUCTION','Police Reconstruction' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'POLICE RECONSTRUCTION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'ROAD TRAFFIC COLLISION','Road Traffic Collision' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'ROAD TRAFFIC COLLISION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SCAFFOLD LICENCE','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SCAFFOLD LICENCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SIGNS - ERECTION','Signs - Erection' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SIGNS - ERECTION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SIGNS - MAINTENANCE','Signs - Maintenance' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SIGNS - MAINTENANCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SKIP LICENCE','Other' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SKIP LICENCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'STRUCTURE - MAINTENANCE','Structure - Maintenance' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'STRUCTURE - MAINTENANCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'STRUCTURE - NEW/RECONSTRUCTION','Structure - New/Reconstruction' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'STRUCTURE - NEW/RECONSTRUCTION')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SU WORKS','SU Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SU WORKS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'SWEEPING OF CARRIAGEWAY','Sweeping of Carriageway' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'SWEEPING OF CARRIAGEWAY')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'TRAINING','Training' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'TRAINING')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'TUNNEL MAINTENANCE','Tunnel Maintenance' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'TUNNEL MAINTENANCE')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'VERGE OFF-ROAD WORKS','Verge/Off-Road Works' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'VERGE OFF-ROAD WORKS')
/

INSERT INTO nem_ntis_nature_of_works_map (nem_code,ntis_meaning) SELECT 'WHITE LINING/ROAD MARKINGS','White Lining/Road Markings' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_nature_of_works_map WHERE nem_code = 'WHITE LINING/ROAD MARKINGS')
/

/*
||Impact Group Speed Limits.
*/
INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '10 MPH','10 mph at all times',1 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '10 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '20 MPH','20 mph at all times',2 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '20 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '30 MPH','30 mph at all times',3 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '30 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '40 MPH','40 mph at all times',4 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '40 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '50 MPH','50 mph at all times',5 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '50 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '60 MPH','60 mph at all times',6 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = '60 MPH')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT 'N/A','Unchanged',7 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = 'N/A')
/

INSERT INTO nem_ntis_imp_grp_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT 'UNCHANGED','Unchanged',8 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_imp_grp_speed_limit WHERE nem_code = 'UNCHANGED')
/

/*
||Schedule Speed Limits.
*/
INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '10 MPH','10 mph during Traffic Management',1 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '10 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '20 MPH','20 mph during Traffic Management',2 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '20 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '30 MPH','30 mph during Traffic Management',3 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '30 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '40 MPH','40 mph during Traffic Management',4 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '40 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '50 MPH','50 mph during Traffic Management',5 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '50 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT '60 MPH','60 mph during Traffic Management',6 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = '60 MPH')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT 'N/A','Unchanged',7 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = 'N/A')
/

INSERT INTO nem_ntis_schd_speed_limit (nem_code,ntis_meaning,ntis_rank) SELECT 'UNCHANGED','Unchanged',8 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_schd_speed_limit WHERE nem_code = 'UNCHANGED')
/

/*
||Lane Status.
*/
INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'CLOSED','Closed' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'CLOSED')
/

INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'OPENED','Opened' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'OPENED')
/

INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'BORROWED','Borrowed' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'BORROWED')
/

INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'LOANED','Loaned' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'LOANED')
/

INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'TEMPORARY','Temporary' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'TEMPORARY')
/

INSERT INTO nem_ntis_lane_status_map (nem_code,ntis_meaning) SELECT 'NARROW','Narrow' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_lane_status_map WHERE nem_code = 'NARROW')
/

/*
||XSP.
*/
INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'LH','LH' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'LH')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'NL1','-L1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'NL1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL1','CL1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL2','CL2' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL2')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL3','CL3' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL3')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL4','CL4' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL4')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL5','CL5' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL5')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL6','CL6' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL6')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL7','CL7' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL7')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL8','CL8' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL8')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CL9','CL9' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CL9')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OL1','+L1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OL1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OL2','+L2' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OL2')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OL3','+L3' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OL3')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CC','CC' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CC')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OR3','+R3' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OR3')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OR2','+R2' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OR2')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'OR1','+R1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'OR1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR9','CR9' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR9')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR8','CR8' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR8')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR7','CR7' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR7')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR6','CR6' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR6')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR5','CR5' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR5')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR4','CR4' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR4')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR3','CR3' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR3')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR2','CR2' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR2')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'CR1','CR1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'CR1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'NR1','-R1' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'NR1')
/

INSERT INTO nem_ntis_xsp_map (nem_code,ntis_code) SELECT 'RH','RH' FROM dual WHERE NOT EXISTS(SELECT 'x' FROM nem_ntis_xsp_map WHERE nem_code = 'RH')
/

COMMIT
/
