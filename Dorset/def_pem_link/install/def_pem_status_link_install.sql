---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Dorset/def_pem_link/install/def_pem_status_link_install.sql-arc   1.0   Sep 06 2011 16:23:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   def_pem_status_link_install.sql  $
--       Date into PVCS   : $Date:   Sep 06 2011 16:23:18  $
--       Date fetched Out : $Modtime:   Sep 06 2011 15:09:40  $
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
define logfile1='def_pem_status_link_&log_extension'
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
select '&exor_base'||'def_pem_link'||'&terminator'||'install'||
        '&terminator'||'def_pem_status_link.tab' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   Metadata *******************
SET TERM ON
prompt metadata...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'def_pem_link'||'&terminator'||'install'||
        '&terminator'||'metadata.sql' run_file
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
select '&exor_base'||'def_pem_link'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'x_dorset_def_pem_status_link.trg' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
spool off
exit

