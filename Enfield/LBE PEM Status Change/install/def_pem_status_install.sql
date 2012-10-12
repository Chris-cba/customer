-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/LBE PEM Status Change/install/def_pem_status_install.sql-arc   1.0   Oct 12 2012 12:21:42   Ian.Turnbull  $
--       Module Name      : $Workfile:   def_pem_status_install.sql  $
--       Date into PVCS   : $Date:   Oct 12 2012 12:21:42  $
--       Date fetched Out : $Modtime:   Oct 05 2012 16:39:04  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2012
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
define logfile1='def_pem_status_&log_extension'
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
---------------------------------------------------------------------------------------------------
--                         ****************   Package *******************
SET TERM ON
prompt package...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||'&terminator'||'pck'||
        '&terminator'||'xlbe_def_status.pks' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||'&terminator'||'pck'||
        '&terminator'||'xlbe_def_status.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   Triggers *******************
SET TERM ON
prompt triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'xlbe_def_status_pre_row.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'xlbe_def_status_post_stm_trg.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'xlbe_wol_status_pre_row.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
SET DEFINE ON
select '&exor_base'||'LBE PEM Status Change'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'xlbe_wol_status_post_stm_trg.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
spool off
exit

