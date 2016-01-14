--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Fix installs/post fix1/installs/im_4500_tfl_fix1.sql-arc   1.0   Jan 14 2016 21:13:40   Sarah.Williams  $
--       Module Name      : $Workfile:   im_4500_tfl_fix1.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 21:13:40  $
--       Date fetched Out : $Modtime:   Feb 22 2013 15:19:38  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
define logfile1='im_4500_tfl_fix1x_1_&log_extension'
define logfile2='im_4500_tfl_fix1x_2_&log_extension'
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
WHERE hpr_product IN ('HIG','NET');

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
 -- Check that HIG has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.5.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- IM Pods
--------------------------------------------------------------------------------
--
--
SET TERM ON 
PROMPT im_pod_sql.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_pod_sql.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT X_IM_MAI_DEFECTS.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\X_IM_MAI_DEFECTS.vw
SET FEEDBACK OFF
--
--
spool off
--
EXIT
--
--