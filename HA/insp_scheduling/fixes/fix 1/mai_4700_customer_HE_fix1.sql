-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/fixes/fix 1/mai_4700_customer_HE_fix1.sql-arc   1.0   Jan 27 2016 14:11:36   Chris.Baugh  $
--       Module Name      : $Workfile:   mai_4700_customer_HE_fix1.sql  $
--       Date into PVCS   : $Date:   Jan 27 2016 14:11:36  $
--       Date fetched Out : $Modtime:   Jan 27 2016 11:54:42  $
--       Version          : $Revision:   1.0  $
------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='mai_4700_customer_HE_fix1_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','MAI');

WHENEVER SQLERROR EXIT

BEGIN
  --
  -- Check that the user isn't sys or system
  --
  IF USER IN ('SYS','SYSTEM')
  THEN
    RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
  END IF;

  --
  -- Check that MAI has been installed @ v4.7.0.0
  --
  hig2.product_exists_at_version (p_product        => 'MAI'
                                 ,p_VERSION        => '4.7.0.0'
                                 );

END;
/

WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating INSL Metadata
SET TERM OFF
--
SET FEEDBACK ON
start mai_4700_customer_HE_fix1_metadata.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- INSL CSV Loader Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT INSL CSV Loader Metadata
SET TERM OFF
--
SET FEEDBACK ON
start nm_load_destinations.sql
start create_partial_inspections_csv_loader.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_ha_ins_insl.vw
SET TERM OFF
--
SET FEEDBACK ON
start v_ha_ins_insl.vw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Creating package body ha_insp
SET TERM OFF
--
SET FEEDBACK ON
start ha_insp.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Creating package body ha_insp
SET TERM OFF
--
SET FEEDBACK ON
start ha_insp.pkw
SET FEEDBACK OFF
--
----------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_mai_4700_cust_HE_fix1.sql 
--
SET FEEDBACK ON
start log_mai_4700_cust_HE_fix1.sql
SET FEEDBACK OFF
SPOOL OFF
EXIT
--