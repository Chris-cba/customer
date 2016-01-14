REM////////////////////////////////////////////////////////////////////////////
REM   Subversion controlled - SQL template
REM////////////////////////////////////////////////////////////////////////////
REM Id              : $Id:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/metadata.sql-arc   1.0   Jan 14 2016 22:38:08   Sarah.Williams  $
REM Date            : $Date:   Jan 14 2016 22:38:08  $
REM Revision        : $Revision:   1.0  $
REM Changed         : $LastChangedDate:    $
REM Last Revision   : $LastChangedRevision:$
REM Last Changed By : $LastChangedBy:      $
REM URL             : $URL:                $
REM ///////////////////////////////////////////////////////////////////////////
REM Descr: 
REM        
REM    
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/metadata.sql-arc   1.0   Jan 14 2016 22:38:08   Sarah.Williams  $
--       Module Name      : $Workfile:   metadata.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 22:38:08  $
--       Date fetched Out : $Modtime:   Jul 09 2013 11:33:42  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : H.Buckley
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2013
-----------------------------------------------------------------------------
--
--   HIG_PROCESS_TYPE_FREQUENCIES
--   HIG_PROCESS_TYPE_FILES
--   HIG_PROCESS_TYPE_FILE_EXT                    

----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPES
--
-- select * from mai_metadata.hig_process_types
-- order by hpt_process_type_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_process_types
SET TERM OFF
--
column process_id new_value process_id noprint
select hpt_process_type_id_seq.nextval process_id
from dual;
-
INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
         &&process_id
       ,'Document Bundles Data Cleansing'
       ,'Process Used to Remove unwanted or expired data from the system'
       ,'hig_data_cleansing.RemoveData(trunc(sysdate)-365);'
       ,''
       ,null
       ,null
       ,null
       ,'N'
       ,'Y'  -- If this is a fully automated process then this may need to be REVERSED.
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                   FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = &&process_id);                    
--
----------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_process_type_roles
SET TERM OFF
--
INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
         &&process_id
       ,'HIG_USER' 
FROM DUAL
WHERE NOT EXISTS (SELECT 1 
                  FROM   HIG_PROCESS_TYPE_ROLES
                  WHERE  HPTR_PROCESS_TYPE_ID = &&process_id
                  AND    HPTR_ROLE            = 'HIG_USER');							
----------------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_FREQUENCIES
--
-- select * from mai_metadata.hig_process_type_frequencies
-- order by hpfr_process_type_id
--         ,hpfr_frequency_id
--
----------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_process_type_frequencies
SET TERM OFF
--
INSERT INTO HIG_PROCESS_TYPE_FREQUENCIES
       (HPFR_PROCESS_TYPE_ID
       ,HPFR_FREQUENCY_ID
       ,HPFR_SEQ
       )
SELECT 
        &&process_id
       ,-1
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                   FROM   HIG_PROCESS_TYPE_FREQUENCIES
                   WHERE  HPFR_PROCESS_TYPE_ID = &&process_id
                   AND    HPFR_FREQUENCY_ID    = -1);
--
commit;  