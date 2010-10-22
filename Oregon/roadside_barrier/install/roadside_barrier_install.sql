-
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/roadside_barrier/install/roadside_barrier_install.sql-arc   1.0   Oct 22 2010 10:54:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   roadside_barrier_install.sql  $
--       Date into PVCS   : $Date:   Oct 22 2010 10:54:26  $
--       Date fetched Out : $Modtime:   Oct 22 2010 10:17:14  $
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
define logfile1='roadside_barrier_install_1_&log_extension'
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

select '&exor_base'||'roadside_barrier'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'xodot_ea_cw_dist_reg_lookup.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'roadside_barrier'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'xodot_iatn_v.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'roadside_barrier'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'xodot_barr_v.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
SET TERM OFF
--
spool off
exit

