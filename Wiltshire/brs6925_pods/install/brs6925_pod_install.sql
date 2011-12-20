---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Wiltshire/brs6925_pods/install/brs6925_pod_install.sql-arc   1.0   Dec 20 2011 10:45:34   Ian.Turnbull  $
--       Module Name      : $Workfile:   brs6925_pod_install.sql  $
--       Date into PVCS   : $Date:   Dec 20 2011 10:45:34  $
--       Date fetched Out : $Modtime:   Dec 14 2011 11:12:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : G Bleakley
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
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
define logfile1='brs6925_pods_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

-
WHENEVER SQLERROR CONTINUE
--                         ****************   PODs *******************
SET TERM ON
prompt PODs...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'brs6925_pods'||'&terminator'||'install'||
        '&terminator'||'hig_modules.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'brs6925_pods'||'&terminator'||'install'||
        '&terminator'||'hig_module_roles.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'brs6925_pods'||'&terminator'||'install'||
        '&terminator'||'im_pods.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'brs6925_pods'||'&terminator'||'install'||
        '&terminator'||'im_pod_sql.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'brs6925_pods'||'&terminator'||'install'||
        '&terminator'||'im_pod_chart.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
spool off
exit

