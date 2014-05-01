---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/DCI/install/xnhcc_dci_metadata.sql-arc   1.0   May 01 2014 09:59:16   Mike.Huitson  $
--       Module Name      : $Workfile:   xnhcc_dci_metadata.sql  $
--       Date into PVCS   : $Date:   May 01 2014 09:59:16  $
--       Date fetched Out : $Modtime:   Apr 30 2014 16:40:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : G Bleakley
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2014
-----------------------------------------------------------------------------
--
Insert into HIG_FTP_TYPES
   (HFT_ID, 
    HFT_TYPE, 
    HFT_DESCR
   )
 select
   hft_id_seq.nextval, 
    'DCI', 
    'Defect Completions Interface' from dual
 WHERE NOT EXISTS (SELECT 1 FROM HIG_FTP_TYPES
                   WHERE HFT_TYPE = 'DCI');

Insert into HIG_FTP_CONNECTIONS
   (HFC_ID, 
    HFC_HFT_ID, 
    HFC_NAME, 
    HFC_NAU_ADMIN_UNIT, 
    HFC_NAU_UNIT_CODE, 
    HFC_NAU_ADMIN_TYPE, 
    HFC_FTP_USERNAME, 
    HFC_FTP_PASSWORD, 
    HFC_FTP_HOST, 
    HFC_FTP_PORT, 
    HFC_FTP_IN_DIR, 
    HFC_FTP_OUT_DIR
   )
 select
    hfc_id_seq.nextval, 
    hft_id, 
    'DCI', 
    1, 
    '1', 
    'NETW', 
    'nhcc', 
    'uwre2576', 
    '213.212.127.114', 
    '21', 
    '/defectextract/', 
    '/defectextract/' from HIG_FTP_TYPES
 where hft_type = 'DCI'
 and not exists (select 1 from HIG_FTP_CONNECTIONS
                 where hfc_name = 'DCI');



Insert into HIG_PROCESS_TYPES
   (HPT_PROCESS_TYPE_ID, 
    HPT_NAME, 
    HPT_DESCR, 
    HPT_WHAT_TO_CALL, 
    HPT_RESTARTABLE, 
    HPT_SEE_IN_HIG2510, 
    HPT_AREA_TYPE, 
    HPT_POLLING_ENABLED, 
    HPT_POLLING_FTP_TYPE_ID
   )
 select
    HPT_PROCESS_TYPE_ID_SEQ.nextval, 
    'Defect Completions', 
    'Defect Completions', 
    'xnhcc_mai_cim_automation.run_batch(''WC'');', 
    'N', 
    'Y', 
    'CIM_CONTRACTOR', 
    'Y', 
    hft_id from HIG_FTP_TYPES
 where hft_type = 'DCI'
 and not exists (select 1 from HIG_PROCESS_TYPES
                 where hpt_name = 'Defect Completions');

INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,'MAI_USER' FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-5
       ,1 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-7
       ,2 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-8
       ,3 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-10
       ,4 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-12
       ,5 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        HPT_PROCESS_TYPE_ID
       ,-1
       ,6 FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions';

Insert into HIG_PROCESS_TYPE_FILES
   (HPTF_FILE_TYPE_ID, 
    HPTF_NAME, 
    HPTF_PROCESS_TYPE_ID, 
    HPTF_INPUT, 
    HPTF_OUTPUT, 
    HPTF_INPUT_DESTINATION, 
    HPTF_INPUT_DESTINATION_TYPE
   )
 select
   hptf_file_type_id_seq.nextval, 
    'Defect Completions', 
    HPT_PROCESS_TYPE_ID, 
    'Y', 
    'N', 
    'CIM_DIR', 
    'ORACLE_DIRECTORY' FROM HIG_PROCESS_TYPES
 where hpt_name = 'Defect Completions'
 AND NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_FILES
                   WHERE HPTF_NAME = 'Defect Completions');

COMMIT;
