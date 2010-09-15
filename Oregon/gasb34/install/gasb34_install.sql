-
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/gasb34/install/gasb34_install.sql-arc   3.0   Sep 15 2010 09:57:58   ian.turnbull  $
--       Module Name      : $Workfile:   gasb34_install.sql  $
--       Date into PVCS   : $Date:   Sep 15 2010 09:57:58  $
--       Date fetched Out : $Modtime:   Sep 15 2010 09:54:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------


set echo off
set linesize 120
set heading off
set feedback off

--
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
---------------------------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='gasb34_install_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

-
WHENEVER SQLERROR CONTINUE
--                        ****************   TABLES  *******************
SET TERM ON
prompt Tables...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'install'||
        '&terminator'||'gasb34_tab.tab' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGE HEADERS  *******************

SET TERM ON
prompt Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_gasb34_package.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                         ****************   PACKAGE BODIES  *******************
SET TERM ON
prompt Package Bodies...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_gasb34_package.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET TERM OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   Triggers *******************
SET TERM ON
prompt Package triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'xodot_aiu_nm_elements_all.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'xodot_biu_nm_elements_all.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
SET DEFINE ON
select '&exor_base'||'gasb34'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'xodot_bius_nm_elements_all.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
spool off
exit

