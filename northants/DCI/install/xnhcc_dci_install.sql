---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/DCI/install/xnhcc_dci_install.sql-arc   1.0   May 01 2014 09:59:16   Mike.Huitson  $
--       Module Name      : $Workfile:   xnhcc_dci_install.sql  $
--       Date into PVCS   : $Date:   May 01 2014 09:59:16  $
--       Date fetched Out : $Modtime:   Apr 30 2014 16:24:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : G Bleakley
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2014
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
define logfile1='xnhcc_dci_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

-
WHENEVER SQLERROR CONTINUE
--                         ****************   packages *******************
SET TERM ON
prompt packages...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'DCI'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xnhcc_mai_cim_automation.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'DCI'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xnhcc_mai_cim_automation.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'DCI'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xnhcc_interfaces.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'DCI'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xnhcc_interfaces.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   Metadata *******************
SET TERM ON
prompt DDL...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'DCI'||'&terminator'||'install'||
        '&terminator'||'xnhcc_dci_metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
--
--
spool off
exit

