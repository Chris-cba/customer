--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/POD_process/wowt/install/wowt_install.sql-arc   1.0   Jan 14 2016 19:46:22   Sarah.Williams  $
--       Module Name      : $Workfile:   wowt_install.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 19:46:22  $
--       Date fetched Out : $Modtime:   Sep 03 2012 14:25:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
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
define logfile1='wowt_1_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

-
WHENEVER SQLERROR CONTINUE
--
--                        ****************   TABLES and Views  *******************
SET TERM ON
prompt Tables, views, sequences
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'wowt'||'&terminator'||'install'||
        '&terminator'||'views_tables' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   META-DATA  *******************
SET TERM ON
PROMPT Process Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'wowt'||'&terminator'||'install'||
        '&terminator'||'process_metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF

SET TERM ON
PROMPT Pod Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'wowt'||'&terminator'||'install'||
        '&terminator'||'pod_metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   PACKAGE HEADERS  *******************

SET TERM ON
prompt Package Headers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'wowt'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'x_tfl_woot.pkh' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF


---------------------------------------------------------------------------------------------------
--                         ****************   PACKAGE BODIES  *******************
SET TERM ON
prompt Package Bodies...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'wowt'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'x_tfl_woot.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET TERM OFF
--
--

--
--
---------------------------------------------------------------------------------------------------
--                         ****************   512 Application  *******************
--SET TERM ON
--prompt 512 application...
--SET TERM OFF
--SET DEFINE ON
--select '&exor_base'||'wowt'||'&terminator'||'install'||
--        '&terminator'||'f512.sql' run_file
--from dual
--/
--SET FEEDBACK ON
--start '&&run_file'
--SET FEEDBACK OFF
--
--SET TERM OFF
--
--

--

spool off
exit

