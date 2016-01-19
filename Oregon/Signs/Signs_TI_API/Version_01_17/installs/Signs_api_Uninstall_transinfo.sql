/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: Signs_api_Install
	Author: JMM
	UPDATE01:	Original, 2015.04.17, JMM
*/


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
--select  '' ||TO_CHAR(sysdate,'YYYY.MM.DD_HH24MISS')||'.LOG' log_extension from dual
select  '' ||instance_name || '_' || TO_CHAR(sysdate,'YYYY.MM.DD_HH24MISS')||'.LOG' log_extension from v$instance
/


set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='Signs_api_uninstall_TI_&log_extension'
define logfile2='Signs_api_uninstall_TI_2_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'UnInstall Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Starting Removal ...
SET TERM OFF
--
SET FEEDBACK ON
start _removal_ti.sql
SET FEEDBACK OFF
--


EXIT
--
--