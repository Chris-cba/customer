--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/Larimer County/Pod Updates/Export/REPORT_CARD_INSTALL.sql-arc   1.0   Jan 14 2016 18:27:18   Sarah.Williams  $
--       Module Name      : $Workfile:   REPORT_CARD_INSTALL.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 18:27:18  $
--       Date fetched Out : $Modtime:   Apr 18 2013 03:56:08  $
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
select  TO_CHAR(sysdate,'YYYYMMDD_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='report_card_install&log_extension'
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
                                ,p_VERSION        => '4.4.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- IM_PODS
--------------------------------------------------------------------------------
--
--
--
--
SET TERM ON
PROMPT *** RUNNING: HIG_MODULE.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START HIG_MODULE.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: IM_PODS.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START IM_PODS.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: IM_POD_SQL.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START IM_POD_SQL.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: IM_POD_CHART.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START IM_POD_CHART.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: IM_FRAMEWORK.pkb ***
SET TERM OFF
--
SET FEEDBACK ON
START IM_FRAMEWORK.pkb
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: SDO_theme_larimer_im_network.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START SDO_theme_larimer_im_network.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: IM_Themes.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START IM_Themes.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: xIM_Icons.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START xIM_Icons.sql
SET FEEDBACK OFF
--
--
SET TERM ON
PROMPT *** RUNNING: f1000.sql ***
SET TERM OFF
--
SET FEEDBACK ON
START f1000.sql
SET FEEDBACK OFF
--
--

--
--

--
--
--
--------------------------------------------------------------------------------

spool off
--
EXIT
--
--