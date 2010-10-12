--<PACKAGE>
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/zmiles/install/xodot_zmile_install.sql-arc   1.0   Oct 12 2010 11:52:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_zmile_install.sql  $
--       Date into PVCS   : $Date:   Oct 12 2010 11:52:50  $
--       Date fetched Out : $Modtime:   Oct 12 2010 11:51:26  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author :
--
--    packagebody
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  G_SCCSID CONSTANT VARCHAR2(2000):='"$Revision:   1.0  $"';

--</GLOBVAR>


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
define logfile1='xodot_zmile_install_1_&log_extension'
define logfile2='xodot_zmile_install_2_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

WHENEVER SQLERROR EXIT
--
-- Check that NM3 has not already been installed
--

WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        ****************   TYPES  *******************
SET TERM ON
prompt Tables ....
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'zmile'||'&terminator'||'install'||'&terminator'||
       'xodot_zmile_tab.sql' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   TABLES  *******************
SET TERM ON
prompt Schedule and Schedued Job ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'zmile'||'&terminator'||'install'||
       '&terminator'||'xodot_zmile_job_create.tab' run_file
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
select '&exor_base'||'zmile'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_zmile.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGE BODY  *******************
SET TERM ON
prompt Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'zmile'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_zmile.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   TRIGGERS  *******************
SET TERM ON
prompt Triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'zmile'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'xodot_zmile_a_ins.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
--
spool off
exit

