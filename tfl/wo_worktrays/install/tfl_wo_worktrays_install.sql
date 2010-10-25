--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/wo_worktrays/install/tfl_wo_worktrays_install.sql-arc   3.1   Oct 25 2010 13:00:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   tfl_wo_worktrays_install.sql  $
--       Date into PVCS   : $Date:   Oct 25 2010 13:00:22  $
--       Date fetched Out : $Modtime:   Oct 25 2010 12:58:52  $
--       PVCS Version     : $Revision:   3.1  $
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
define logfile1='tfl_wo_worktrays_1_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;


WHENEVER SQLERROR CONTINUE

--
---------------------------------------------------------------------------------------------------
--                            ****************   VIEWS  *******************

SET TERM ON
prompt Views...
SET TERM OFF
SET DEFINE ON

select '&exor_base'||'wo_worktrays'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'ximf_wo_tfl_work_tray_2.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'wo_worktrays'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'ximf_wo_tfl_work_tray_3.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'wo_worktrays'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'ximf_wo_tfl_work_tray_4.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
SET TERM OFF
--

--
---------------------------------------------------------------------------------------------------
--                            ****************   Metadata  *******************

SET TERM ON
prompt Metadata..
SET TERM OFF
SET DEFINE ON

select '&exor_base'||'wo_worktrays'||'&terminator'||'admin'||'&terminator'||'sql'||
        '&terminator'||'tfl_wo_worktray_metadata.sql' run_file
from dual
/

--
---------------------------------------------------------------------------------------------------
--    ****************   IM$ application *******************


SET TERM ON
prompt IM4 Worktrays..
SET TERM OFF
SET DEFINE ON

select '&exor_base'||'wo_worktrays'||'&terminator'||'admin'||'&terminator'||'sql'||
        '&terminator'||'f511.sql' run_file
from dual
/

commit;

spool off
exit

