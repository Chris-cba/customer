--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/Sent Old Fixes/im4_4500_tfl_fix5/install/im_4500_tfl_fix5.sql-arc   1.0   Jan 15 2016 00:36:20   Sarah.Williams  $
--       Module Name      : $Workfile:   im_4500_tfl_fix5.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 00:36:20  $
--       Date fetched Out : $Modtime:   Mar 20 2013 21:10:30  $
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
define logfile1='im_4500_tfl_fix1_1_&log_extension'
define logfile2='im_4500_tfl_fix1_2_&log_extension'
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
--
--------------------------------------------------------------------------------
-- Application Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT f512.sql
SET TERM OFF
--
SET FEEDBACK ON
start f512.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- SQL
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT im41015.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41015.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im41035_base.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41035_base.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im41036_base.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41036_base.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im41037a.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41037a.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im41038a.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41038a.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im41040.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im41040.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT wowt00x.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\wowt00x.sql
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT c_pod_eop_requests_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_requests_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eop_updated.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_updated.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eop_updated_dd.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_updated_dd.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eop_updated_dd_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_updated_dd_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eop_updated_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_updated_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41035_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41035_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41035_pod_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41035_pod_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41036_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41036_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41036_pod_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41036_pod_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41037a_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41037a_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41038a_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41038a_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_wow001_nobu.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_wow001_nobu.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_wt_im511003_nobud.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_wt_im511003_nobud.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT ximf_mai_wo_all_attr_no_sec.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\ximf_mai_wo_all_attr_no_sec.vw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_im_4500_tfl_fix5.sql 
--
SET FEEDBACK ON
start log_im_4500_tfl_fix5.sql
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Compile the schema
--------------------------------------------------------------------------------
--
SET TERM ON
Prompt Executing the Compile_schema
SET TERM OFF
SPOOL OFF
SET define ON

start compile_schema;
--
--
spool &logfile2
SET TERM ON
start compile_all.sql
spool off
--
EXIT
--
--