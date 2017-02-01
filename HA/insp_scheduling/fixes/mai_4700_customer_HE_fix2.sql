--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/fixes/mai_4700_customer_HE_fix2.sql-arc   1.1   Feb 01 2017 09:24:38   James.Wadsworth  $
--       Module Name      : $Workfile:   mai_4700_customer_HE_fix2.sql  $ 
--       Date into PVCS   : $Date:   Feb 01 2017 09:24:38  $
--       Date fetched Out : $Modtime:   Feb 01 2017 09:24:10  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL      log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF
SELECT  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='mai_4700_customer_HE_fix2_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(sysdate, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;
--
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');
--
--------------------------------------------------------------------------------
-- 	Check(s)
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT
--
DECLARE
--
	l_dummy_c1 VARCHAR2(1);
--
BEGIN
--
-- 	Check that the user isn't sys or system
--
	IF USER IN ('SYS','SYSTEM')
	THEN
		RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
	END IF;
--
-- 	Check that HIG has been installed @ v4.7.0.0
--
	HIG2.PRODUCT_EXISTS_AT_VERSION  (p_product        => 'MAI'
                                        ,p_VERSION        => '4.7.0.0'
                                        );
--
--
END;
/

WHENEVER SQLERROR CONTINUE
--
----------------------------------------------
-- Package change
----------------------------------------------
SET TERM ON
PROMPT Apply changes to HA_INSP package body
SET TERM OFF
--
SET FEEDBACK ON
START ha_insp.pkw
SET FEEDBACK OFF
----------------------------------------------
-- New attributes for INSP
----------------------------------------------
SET TERM ON
PROMPT Add new attributes for INSP asset
SET TERM OFF
--
SET FEEDBACK ON
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE
   ,ITA_ATTRIB_NAME
   ,ITA_DYNAMIC_ATTRIB
   ,ITA_DISP_SEQ_NO
   ,ITA_MANDATORY_YN
   ,ITA_FORMAT
   ,ITA_FLD_LENGTH
   ,ITA_SCRN_TEXT
   ,ITA_VALIDATE_YN
   ,ITA_VIEW_ATTRI
   ,ITA_VIEW_COL_NAME
   ,ITA_START_DATE
   ,ITA_QUERYABLE
   ,ITA_EXCLUSIVE
   ,ITA_KEEP_HISTORY_YN
   ,ITA_DATE_CREATED
   ,ITA_DATE_MODIFIED
   ,ITA_MODIFIED_BY
   ,ITA_CREATED_BY
   ,ITA_DISPLAYED
   ,ITA_DISP_WIDTH
   ,ITA_INSPECTABLE
   ,ITA_CASE
   )
SELECT
    'INSP'
   ,'IIT_X'
   ,'N'
   ,15
   ,'N'
   ,'NUMBER'
   ,22
   ,'Start X'
   ,'N'
   ,'START_X'
   ,'START_X'
   ,TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
   ,'Y'
   ,'N'
   ,'N'
   ,SYSDATE
   ,SYSDATE
   ,USER
   ,USER
   ,'Y'
   ,10
   ,'Y'
   ,'UPPER'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 
                    FROM NM_INV_TYPE_ATTRIBS_ALL   
                   WHERE ITA_INV_TYPE = 'INSP'
                     AND ITA_ATTRIB_NAME = 'IIT_X'
                 );
--
--
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE
   ,ITA_ATTRIB_NAME
   ,ITA_DYNAMIC_ATTRIB
   ,ITA_DISP_SEQ_NO
   ,ITA_MANDATORY_YN
   ,ITA_FORMAT
   ,ITA_FLD_LENGTH
   ,ITA_SCRN_TEXT
   ,ITA_VALIDATE_YN
   ,ITA_VIEW_ATTRI
   ,ITA_VIEW_COL_NAME
   ,ITA_START_DATE
   ,ITA_QUERYABLE
   ,ITA_EXCLUSIVE
   ,ITA_KEEP_HISTORY_YN
   ,ITA_DATE_CREATED
   ,ITA_DATE_MODIFIED
   ,ITA_MODIFIED_BY
   ,ITA_CREATED_BY
   ,ITA_DISPLAYED
   ,ITA_DISP_WIDTH
   ,ITA_INSPECTABLE
   ,ITA_CASE
   )
SELECT
   'INSP'
  ,'IIT_Y'
  ,'N'
  ,16
  ,'N'
  ,'NUMBER'
  ,22
  ,'Start Y'
  ,'N'
  ,'START_Y'
  ,'START_Y'
  ,TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  ,'Y'
  ,'N'
  ,'N'
  ,SYSDATE
  ,SYSDATE
  ,USER
  ,USER
  ,'Y'
  ,10
  ,'Y'
  ,'UPPER'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 
                    FROM NM_INV_TYPE_ATTRIBS_ALL   
                   WHERE ITA_INV_TYPE = 'INSP'
                     AND ITA_ATTRIB_NAME = 'IIT_Y'
                 );
SET FEEDBACK OFF
----------------------------------------------
-- Update inventory for INSP
----------------------------------------------
SET TERM ON
PROMPT Update inventory for INSP asset
SET TERM OFF
--
SET FEEDBACK ON
UPDATE NM_INV_TYPES_ALL
   SET NIT_USE_XY = 'Y'
 WHERE NIT_INV_TYPE = 'INSP';
SET FEEDBACK OFF
----------------------------------------------
-- Re-create INSP view
----------------------------------------------
SET TERM ON
PROMPT Re-creating view for INSP asset
SET TERM OFF
--
SET FEEDBACK ON
DECLARE
  v_view_name USER_VIEWS.VIEW_NAME%TYPE;
BEGIN
  NM3INV.CREATE_INV_VIEW('INSP', FALSE, v_view_name);
END;
/
SET FEEDBACK OFF
----------------------------------------------
-- Re-build API
----------------------------------------------
SET TERM ON
PROMPT Re-build API for INSP asset
SET TERM OFF
--
SET FEEDBACK ON
BEGIN
  NM3INV_API_GEN.BUILD_ONE('INSP'); 
END;
/
SET FEEDBACK OFF
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT log_mai_4700_cust_HE_fix2.sql 
--
SET FEEDBACK ON
start log_mai_4700_cust_HE_fix2.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--