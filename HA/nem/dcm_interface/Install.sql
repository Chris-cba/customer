/*
||Install script for all table and metadata for DCM Interface
*/
/*
||Directories
*/
INSERT 
  INTO hig_directories
      (hdir_name
      ,hdir_path
      ,hdir_url
      ,hdir_comments
      ,hdir_protected)
SELECT 'NEM_DCM_RESULTS'
      ,'<to be specified>'
      ,'<to be specified>'
      ,'Location for the DCM Results files.'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 'X'
                    FROM hig_directories
                   WHERE hdir_name = 'NEM_DCM_RESULTS')
/

INSERT 
  INTO hig_directory_roles
      (hdr_name
      ,hdr_role
      ,hdr_mode)
SELECT 'NEM_DCM_RESULTS'
      ,'NEM_ADMIN'
      ,'NORMAL'
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_directory_roles
                   WHERE hdr_name = 'NEM_DCM_RESULTS'
                     AND hdr_role = 'NEM_ADMIN')
/
INSERT 
  INTO hig_directories
      (hdir_name
      ,hdir_path
      ,hdir_url
      ,hdir_comments
      ,hdir_protected)
SELECT 'NEM_DCM_EXPORT'
      ,'<to be specified>'
      ,'<to be specified>'
      ,'Location for NEM export to DCM file.'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 'X'
                    FROM hig_directories
                   WHERE hdir_name = 'NEM_DCM_EXPORT')
/

INSERT 
  INTO hig_directory_roles
      (hdr_name
      ,hdr_role
      ,hdr_mode)
SELECT 'NEM_DCM_EXPORT'
      ,'NEM_ADMIN'
      ,'NORMAL'
  FROM dual
 WHERE NOT EXISTS(SELECT 'x'
                    FROM hig_directory_roles
                   WHERE hdr_name = 'NEM_DCM_EXPORT'
                     AND hdr_role = 'NEM_ADMIN')
/
/*
||NEM DCM Tables for creating DCMOUTPUT File.
*/
CREATE TABLE nem_dcm_queue
(dcmq_id NUMBER (12)
,dcmq_priority NUMBER(3) DEFAULT 100
,dcmq_nevt_id NUMBER(12)
,dcmq_naex_id NUMBER(12)
,dcmq_nig_id NUMBER(12)
,dcmq_file_count NUMBER(12)
,dcmq_filename VARCHAR2(255)
,dcmq_file_success VARCHAR(1) DEFAULT 'N'
,dcmq_ftp_success VARCHAR(1) DEFAULT 'N'
,dcmq_results_imported  VARCHAR(1) DEFAULT 'N'
,dcmq_notes VARCHAR2(2000)
)
/
ALTER TABLE nem_dcm_queue
 ADD (CONSTRAINT nem_dcm_queue_pk PRIMARY KEY 
  (dcmq_id))
/
--
ALTER TABLE nem_dcm_queue 
 ADD (CONSTRAINT dcmq_fk_nevt FOREIGN KEY 
  (dcmq_nevt_id) REFERENCES nem_events
  (nevt_id))
/
--
ALTER TABLE nem_dcm_queue 
 ADD (CONSTRAINT dcmq_fk_nig FOREIGN KEY 
  (dcmq_nig_id) REFERENCES nem_impact_groups
  (nig_id))
/
--
ALTER TABLE nem_dcm_queue 
 ADD (CONSTRAINT dcmq_fk_naex FOREIGN KEY 
  (dcmq_naex_id) REFERENCES nem_action_executions
  (naex_id))
/
--
CREATE TABLE nem_dcm_speed_limit_map
(nem_code      VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80) NOT NULL
,dcm_rank     NUMBER(3)    NOT NULL)
/

ALTER TABLE nem_dcm_speed_limit_map
 ADD (CONSTRAINT dcm_imp_grp_speed_limit_pk PRIMARY KEY 
  (nem_code))
/

ALTER TABLE nem_dcm_speed_limit_map
 ADD (CONSTRAINT dcm_imp_grp_speed_limit_uk UNIQUE (dcm_rank))
/
CREATE TABLE nem_dcm_sect_fun_map
(nem_code      VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_dcm_sect_fun_map
 ADD (CONSTRAINT dcm_imp_grp_sect_fun_pk PRIMARY KEY 
  (nem_code))
/
CREATE TABLE nem_dcm_single_dual_map
(nem_code      VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_dcm_single_dual_map
 ADD (CONSTRAINT dcm_imp_grp_single_dual_pk PRIMARY KEY 
  (nem_code))
/


CREATE TABLE nem_dcm_environment_map
(nem_code      VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80) NOT NULL)
/

ALTER TABLE nem_dcm_environment_map
 ADD (CONSTRAINT dcm_imp_grp_environment_pk PRIMARY KEY 
  (nem_code))
/
CREATE TABLE nem_dcm_lane_status_map
(nem_code      VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80))
/

ALTER TABLE nem_dcm_lane_status_map
 ADD (CONSTRAINT dcm_lane_status_map_pk PRIMARY KEY 
  (nem_code))
/
CREATE TABLE nem_dcm_diversion_quality_map
(nem_code VARCHAR2(30) NOT NULL
,dcm_meaning  VARCHAR2(80) NOT NULL
,dcm_rank     NUMBER(3)    NOT NULL)
/

ALTER TABLE nem_dcm_diversion_quality_map
 ADD (CONSTRAINT dcm_imp_diversion_quality_pk PRIMARY KEY 
  (dcm_meaning))
/

ALTER TABLE nem_dcm_diversion_quality_map
 ADD (CONSTRAINT dcm_imp_diversion_quality_uk UNIQUE (dcm_rank))
/
/*
||Impact Group Speed Limits.
*/
INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '10 MPH','10',1 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '10 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '20 MPH','20',2 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '20 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '30 MPH','30',3 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '30 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '40 MPH','40',4 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '40 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '50 MPH','50',5 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '50 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT '60 MPH','60',6 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = '60 MPH')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT 'N/A','0',7 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = 'N/A')
/

INSERT INTO nem_dcm_speed_limit_map (nem_code,dcm_meaning,dcm_rank) SELECT 'UNCHANGED','0',8 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_speed_limit_map WHERE nem_code = 'UNCHANGED')
/
/*
||Lane Status.
*/
INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'CLOSED','1' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'CLOSED')
/

INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'OPENED','2' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'OPENED')
/

INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'BORROWED','3' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'BORROWED')
/

INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'LOANED','4' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'LOANED')
/

INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'TEMPORARY','5' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'TEMPORARY')
/

INSERT INTO nem_dcm_lane_status_map (nem_code,dcm_meaning) SELECT 'NARROW','2' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_lane_status_map WHERE nem_code = 'NARROW')
/
/*
||Diversion Quality
*/
INSERT INTO nem_dcm_diversion_quality_map (nem_code, dcm_meaning,dcm_rank) SELECT 'N/S','N/S',1 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_diversion_quality_map WHERE nem_code = 'N/S')
/

INSERT INTO nem_dcm_diversion_quality_map (nem_code, dcm_meaning,dcm_rank) SELECT 'POOR','POOR',2 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_diversion_quality_map WHERE nem_code = 'POOR')
/

INSERT INTO nem_dcm_diversion_quality_map (nem_code, dcm_meaning,dcm_rank) SELECT 'AVER','AVER',3 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_diversion_quality_map WHERE nem_code = 'AVER')
/

INSERT INTO nem_dcm_diversion_quality_map (nem_code, dcm_meaning,dcm_rank) SELECT 'GOOD','GOOD',4 FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_diversion_quality_map WHERE nem_code = 'GOOD')
/
/*
||Section Function
*/
INSERT INTO nem_dcm_sect_fun_map (nem_code, dcm_meaning) SELECT 'MAIN','MAIN' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_sect_fun_map WHERE dcm_meaning = 'MAIN')
/

INSERT INTO nem_dcm_sect_fun_map (nem_code, dcm_meaning) SELECT 'SLIP','SLIP' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_sect_fun_map WHERE dcm_meaning = 'SLIP')
/

INSERT INTO nem_dcm_sect_fun_map (nem_code, dcm_meaning) SELECT 'RBT','RBT' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_sect_fun_map WHERE dcm_meaning = 'RBT')
/

INSERT INTO nem_dcm_sect_fun_map (nem_code, dcm_meaning) SELECT 'OB','OXB' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_sect_fun_map WHERE dcm_meaning = 'OXB')
/
/*
||Single or Dual
*/
INSERT INTO nem_dcm_single_dual_map (nem_code, dcm_meaning) SELECT 'DUAL','DUAL' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_single_dual_map WHERE dcm_meaning = 'DUAL')
/

INSERT INTO nem_dcm_single_dual_map (nem_code, dcm_meaning) SELECT 'S2W','S2W' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_single_dual_map WHERE dcm_meaning = 'S2W')
/

INSERT INTO nem_dcm_single_dual_map (nem_code, dcm_meaning) SELECT 'S1W','S1W' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_single_dual_map WHERE dcm_meaning = 'S1W')
/

INSERT INTO nem_dcm_single_dual_map (nem_code, dcm_meaning) SELECT 'GOOD','GOOD' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_single_dual_map WHERE dcm_meaning = 'GOOD')
/
/*
||Environment
*/
INSERT INTO nem_dcm_environment_map (nem_code, dcm_meaning) SELECT 'R','R' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_environment_map WHERE dcm_meaning = 'R')
/

INSERT INTO nem_dcm_environment_map (nem_code, dcm_meaning) SELECT 'U','U' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_environment_map WHERE dcm_meaning = 'U')
/

INSERT INTO nem_dcm_environment_map (nem_code, dcm_meaning) SELECT 'S','S' FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM nem_dcm_environment_map WHERE dcm_meaning = 'S')
/

/*
||Tables for Import of DCMOUTPUT File.
*/
CREATE TABLE nem_dcm_header
(dcmh_id                NUMBER NOT NULL
,dcmh_nevt_id           NUMBER
,dcmh_nig_id            NUMBER
,dcmh_naex_id           NUMBER
,dcmh_calc_or_estimate  VARCHAR(1)
,dcmh_number_of_errors  NUMBER(2) 
,dcmh_calculation_time  NUMBER(12,6))
/

ALTER TABLE nem_dcm_header
 ADD (CONSTRAINT nem_dcm_header_pk PRIMARY KEY 
  (dcmh_id))
/
--
ALTER TABLE nem_dcm_header 
 ADD (CONSTRAINT DCMH_FK_NEVT FOREIGN KEY 
  (dcmh_nevt_id) REFERENCES nem_events
  (nevt_id))
/
--
ALTER TABLE nem_dcm_header 
 ADD (CONSTRAINT DCMH_FK_NIG FOREIGN KEY 
  (dcmh_nig_id) REFERENCES nem_impact_groups
  (nig_id))
/
--
ALTER TABLE nem_dcm_header 
 ADD (CONSTRAINT DCMH_FK_NAEX FOREIGN KEY 
  (dcmh_naex_id) REFERENCES nem_action_executions
  (naex_id))
/
CREATE INDEX DCMH_FK_NEVT_IND ON nem_dcm_header
 (dcmh_nevt_id)
/
CREATE TABLE nem_dcm_error
(dcme_id              NUMBER
,dcme_error           VARCHAR2(1000)
,dcme_dcmh_id         NUMBER)
/

ALTER TABLE nem_dcm_error
 ADD (CONSTRAINT nem_dcm_error_pk PRIMARY KEY 
  (dcme_id))
/

ALTER TABLE nem_dcm_error 
 ADD (CONSTRAINT DCME_FK_DMCH FOREIGN KEY 
  (dcme_dcmh_id) REFERENCES nem_dcm_header
  (dcmh_id))
/
CREATE INDEX DCME_FK_DMCH_IND ON nem_dcm_error
 (dcme_dcmh_id)
/
--
CREATE TABLE nem_dcm_result
(dcmr_id                       NUMBER NOT NULL
,dcmr_total_delay_time         NUMBER(12,2)
,dcmr_total_delay_cost         NUMBER  (12,2)
,dcmr_total_vehicles           NUMBER (12)
,dcmr_psa_delay_time           NUMBER(12,2)
,dcmr_psa_delay_cost           NUMBER(12,2)
,dcmr_psa_vehicles             NUMBER (12)
,dcmr_number_of_daily_results  NUMBER (5)
,dcmr_dcmh_id                  NUMBER)
/
ALTER TABLE nem_dcm_result
 ADD (CONSTRAINT nem_dcm_result_pk PRIMARY KEY 
  (dcmr_id))
/
ALTER TABLE nem_dcm_result 
 ADD (CONSTRAINT DCMR_FK_DMCH FOREIGN KEY 
  (dcmr_dcmh_id) REFERENCES nem_dcm_header
  (dcmh_id))
/
CREATE INDEX DCMR_FK_DMCH_IND ON nem_dcm_result
 (dcmr_dcmh_id)
/
--
CREATE TABLE nem_dcm_daily_results
(dcmd_id                       NUMBER
,dcmd_daily_date               DATE
,dcmd_daily_time               NUMBER(12,2) 
,dcmd_daily_cost               NUMBER(12,2) 
,dcmd_daily_total_vehicles     NUMBER(12)
,dcmd_daily_psa_delay_time     NUMBER(12,2) 
,dcmd_daily_psa_delay_cost     NUMBER(12,2) 
,dcmd_daily_psa_vehicles       NUMBER(12)
,dcmd_dcmr_id                  NUMBER)
/
ALTER TABLE nem_dcm_daily_results
 ADD (CONSTRAINT nem_dcm_daily_results_pk PRIMARY KEY 
  (dcmd_id))
/
ALTER TABLE nem_dcm_daily_results 
 ADD (CONSTRAINT DCMD_FK_DMCR FOREIGN KEY 
  (dcmd_dcmr_id) REFERENCES nem_dcm_result
  (dcmr_id))
/
CREATE INDEX DCMD_FK_DMCR_IND ON nem_dcm_daily_results
 (dcmd_dcmr_id)
/
--
CREATE SEQUENCE DCMQ_ID_SEQ
 INCREMENT BY 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
CREATE SEQUENCE DCMH_ID_SEQ
 INCREMENT BY 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
CREATE SEQUENCE DCME_ID_SEQ
 INCREMENT BY 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
CREATE SEQUENCE DCMR_ID_SEQ
 INCREMENT BY 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
CREATE SEQUENCE DCMD_ID_SEQ
 INCREMENT BY 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 NOCACHE
/
/*
||FTP Connections
*/
DECLARE
  lv_hft_id NUMBER;
BEGIN
  --
  BEGIN
    SELECT hft_id
      INTO lv_hft_id 
      FROM hig_ftp_types 
     WHERE hft_type = 'NEM_DCM_RESULTS_FILE';
  EXCEPTION
   WHEN no_data_found THEN
     lv_hft_id := HFT_ID_SEQ.NEXTVAL;
     --
     INSERT
      INTO hig_ftp_types(hft_id
                        ,hft_type
                        ,hft_descr
                        )
      SELECT lv_hft_id
             ,'NEM_DCM_RESULTS_FILE'
             ,'NEM DCM Results Location'
      FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_ftp_types WHERE hft_id = lv_hft_id)
     ;
  END;
  --
  BEGIN
    SELECT hft_id
      INTO lv_hft_id 
      FROM hig_ftp_types 
     WHERE hft_type = 'NEM_DCM_EXPORT_FILE';
  EXCEPTION
   WHEN no_data_found THEN
     lv_hft_id := HFT_ID_SEQ.NEXTVAL;
     INSERT
      INTO hig_ftp_types(hft_id
                        ,hft_type
                        ,hft_descr
                        )
      SELECT lv_hft_id
             ,'NEM_DCM_EXPORT_FILE'
             ,'NEM DCM Export File Location'
      FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_ftp_types WHERE hft_id = lv_hft_id)
     ;
  END;
END;
/   
/*
||Process Framework for Export
*/
DECLARE
 lv_process_id NUMBER;
BEGIN
  BEGIN
    SELECT hpt_process_type_id
      INTO lv_process_id
      FROM hig_process_types
     WHERE hpt_name = 'NEM DCM Export'
    ;
  EXCEPTION
  WHEN no_data_found THEN
    lv_process_id := HPT_PROCESS_TYPE_ID_SEQ.NEXTVAL;
    INSERT 
     INTO hig_process_types (hpt_process_type_id, 
                            hpt_name, 
                            hpt_descr, 
                            hpt_what_to_call,
                            hpt_restartable,
                            hpt_see_in_hig2510,
                            hpt_polling_enabled
                            ) 
     SELECT lv_process_id,
            'NEM DCM Export',
            'Exports events from queue into DCM Format',
            'nem_dcm_interface.export_dcm_queue;',
            'Y',
            'Y',
            'N'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_types WHERE hpt_process_type_id = lv_process_id)
    ;
    INSERT 
     INTO hig_process_type_roles (hptr_process_type_id, 
                                  hptr_role) 
     SELECT lv_process_id,
            'NEM_ADMIN'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_roles WHERE hptr_process_type_id = lv_process_id AND hptr_role = 'NEM_ADMIN')
    ;
    INSERT 
     INTO hig_process_type_roles (hptr_process_type_id, 
                                  hptr_role) 
     SELECT lv_process_id,
            'NEM_USER'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_roles WHERE hptr_process_type_id = lv_process_id AND hptr_role = 'NEM_USER')
    ;
    INSERT
     INTO hig_process_type_files(hptf_file_type_id,
                                hptf_name,
                                hptf_process_type_id,
                                hptf_input,
                                hptf_output,
                                hptf_input_destination,
                                hptf_input_destination_type,
                                hptf_min_input_files,
                                hptf_max_input_files,
                                hptf_output_destination,
                                hptf_output_destination_type
                                )
     SELECT lv_process_id,
            'DCMINPUT File',
            lv_process_id,
            'N',
            'Y',
            null,
            null,
            null,
            null,
            'NEM_DCM_EXPORT',
            'ORACLE_DIRECTORY'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_files WHERE hptf_file_type_id = lv_process_id)
    ;
    INSERT
     INTO hig_process_type_file_ext(hpte_file_type_id,
                               hpte_extension)
     SELECT lv_process_id,
            'DCMINPUT'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_file_ext WHERE hpte_file_type_id = lv_process_id AND hpte_extension = 'DCMINPUT')
    ;
    INSERT 
     INTO hig_process_type_frequencies (hpfr_process_type_id,
                                      hpfr_frequency_id,
                                      hpfr_seq)
     SELECT lv_process_id,
            '-1',
            '1'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_frequencies WHERE hpfr_process_type_id = lv_process_id AND hpfr_frequency_id = '-1' AND hpfr_frequency_id = '1')
    ;  
  END;
END;
/                                 
/*
||Process Framework for import
*/
DECLARE
 lv_process_id NUMBER;
BEGIN
  BEGIN
    SELECT hpt_process_type_id
      INTO lv_process_id
      FROM hig_process_types
     WHERE hpt_name = 'NEM DCM Results File Loader'
    ;
  EXCEPTION
  WHEN no_data_found THEN
    lv_process_id := HPT_PROCESS_TYPE_ID_SEQ.NEXTVAL;
    INSERT 
     INTO hig_process_types (hpt_process_type_id, 
                            hpt_name, 
                            hpt_descr, 
                            hpt_what_to_call,
                            hpt_restartable,
                            hpt_see_in_hig2510,
                            hpt_polling_enabled, 
                            hpt_polling_ftp_type_id) 
     SELECT lv_process_id,
            'NEM DCM Results File Loader',
            'Loads DCM Results Files',
            'nem_dcm_interface.import_dcm_results;',
            'N',
            'Y',
            'Y',
            (select hft_id from hig_ftp_types where hft_type = 'NEM_DCM_RESULTS_FILE')
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_types WHERE hpt_process_type_id = lv_process_id)
    ;
    INSERT 
     INTO hig_process_type_roles (hptr_process_type_id, 
                                  hptr_role) 
     SELECT lv_process_id,
            'NEM_ADMIN'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_roles WHERE hptr_process_type_id = lv_process_id AND hptr_role = 'NEM_ADMIN')
    ;
    INSERT 
     INTO hig_process_type_roles (hptr_process_type_id, 
                                  hptr_role) 
     SELECT lv_process_id,
            'NEM_USER'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_roles WHERE hptr_process_type_id = lv_process_id AND hptr_role = 'NEM_USER')
    ;
    INSERT
     INTO hig_process_type_files(hptf_file_type_id,
                                hptf_name,
                                hptf_process_type_id,
                                hptf_input,
                                hptf_output,
                                hptf_input_destination,
                                hptf_input_destination_type,
                                hptf_min_input_files,
                                hptf_max_input_files,
                                hptf_output_destination,
                                hptf_output_destination_type
                                )
     SELECT lv_process_id,
            'NEM DCM EXPORT FILE',
            lv_process_id,
            'Y',
            'N',
            'NEM_DCM_RESULTS',
            'ORACLE_DIRECTORY',
            '1',
            '1',
            '',
            ''
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_files WHERE hptf_file_type_id = lv_process_id)
    ;
    INSERT
     INTO hig_process_type_file_ext(hpte_file_type_id,
                               hpte_extension)
     SELECT lv_process_id,
            'DCMOUTPUT'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_file_ext WHERE hpte_file_type_id = lv_process_id AND hpte_extension = 'DCMOUTPUT')
    ;
    INSERT 
     INTO hig_process_type_frequencies (hpfr_process_type_id,
                                      hpfr_frequency_id,
                                      hpfr_seq)
     SELECT lv_process_id,
            '-1',
            '1'
     FROM DUAL WHERE NOT EXISTS(SELECT 'x' FROM hig_process_type_frequencies WHERE hpfr_process_type_id = lv_process_id AND hpfr_frequency_id = '-1' AND hpfr_frequency_id = '1')
    ;  
  END;
END;
/                                    
/*
||Actions
*/
DECLARE
  --
  lv_error_flag  VARCHAR2(1) := 'N';
  lv_error_text  nm3type.max_varchar2;
  --
  lr_na   nem_actions%ROWTYPE;
  lr_nme  nem_menus%ROWTYPE;
  lr_nmi  nem_menu_items%ROWTYPE;
  --
  lt_roles  nem_menu_api.menu_roles_tab;
  --
  lv_na_id   nem_actions.na_id%TYPE;
  lv_nmi_id  nem_menu_items.nmi_id%TYPE;
  --
BEGIN
  --
  lr_na := nem_actions_api.get_na(pi_label           => 'Manual DCM'
                                 ,pi_context         => 'NEM_EVENTS'
                                 ,pi_raise_not_found => FALSE);
  --
  IF lr_na.na_id IS NULL
   THEN
      --
      nem_actions_api.add_action(pi_script_name     => 'NEM_DCM_ACTIONS.EXECUTE_SCRIPT_MANUAL'
                                ,pi_label           => 'Manual DCM'
                                ,pi_context         => 'NEM_EVENTS'
                                ,pi_min_event_ids   => '1'
                                ,pi_max_event_ids   => '1'
                                ,pi_ask_continue    => 'Y'
                                ,pi_display_results => 'Y'
                                ,pi_ask_reason      => 'N'
                                ,pi_reason_domain   => NULL
                                ,pi_commit          => 'N'
                                ,po_na_id           => lv_na_id
                                ,po_error_flag      => lv_error_flag
                                ,po_error_text      => lv_error_text);
      --
      IF lv_error_flag = 'Y'
       THEN
          raise_application_error(-20001,'Error creating action: '||lv_error_text);
      END IF;
      --
      INSERT
        INTO nem_action_event_statuses
            (naes_na_id
            ,naes_status)
      VALUES(lv_na_id
            ,'WORK IN PROGRESS')
           ;
      --
      INSERT
        INTO nem_action_event_statuses
            (naes_na_id
            ,naes_status)
      VALUES(lv_na_id
            ,'PUBLISHED')
           ;
      --
      INSERT
        INTO nem_action_event_statuses
            (naes_na_id
            ,naes_status)
      VALUES(lv_na_id
            ,'SHARED')
           ;
      --
      INSERT
        INTO nem_action_event_statuses
            (naes_na_id
            ,naes_status)
      VALUES(lv_na_id
            ,'COMPLETED')
           ;           
      --
  ELSE
      lv_na_id := lr_na.na_id;
  END IF;
  --
  lr_nme := nem_menu_api.get_nme(pi_nme_name => 'EventDetails');
  --
  IF lr_nme.nme_id IS NOT NULL
   THEN
      --
      lr_nmi := nem_menu_api.get_nmi(pi_nmi_nme_id      => lr_nme.nme_id
                                    ,pi_nmi_name        => 'NetworkEventSubmitDCM'
                                    ,pi_raise_not_found => FALSE);
      --
      IF lr_nmi.nmi_id IS NULL
       THEN
          --
          lt_roles(1) := 'NEM_USER';
          lt_roles(2) := 'NEM_ADMIN';
          --
          nem_menu_api.add_menu_item(pi_nme_id           => lr_nme.nme_id
                                    ,pi_name             => 'NetworkEventSubmitDCM'
                                    ,pi_label            => 'Submit DCM'
                                    ,pi_display_sequence => 107
                                    ,pi_is_splitter      => 'N'
                                    ,pi_parent_id        => NULL
                                    ,pi_image            => NULL
                                    ,pi_tooltip          => NULL
                                    ,pi_can_execute_func => 'NEM_DCM_ACTIONS.CAN_EXECUTE_ACTION'
                                    ,pi_na_id            => lv_na_id
                                    ,pi_params           => NULL
                                    ,pi_roles            => lt_roles
                                    ,pi_commit           => 'N'
                                    ,po_nmi_id           => lv_nmi_id
                                    ,po_error_flag       => lv_error_flag
                                    ,po_error_text       => lv_error_text);
          --
          IF lv_error_flag = 'Y'
           THEN
              raise_application_error(-20001,'Error creating menu item: '||lv_error_text);
          END IF;
          --
      END IF;
  ELSE
      raise_application_error(-20001,'Unable to get id for the EventDetails Menu.'||lv_error_text);
  END IF;
  --
  COMMIT;
  --
EXCEPTION
  WHEN others
   THEN
      ROLLBACK;
      RAISE;
END;
/

