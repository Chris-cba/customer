--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/emails/install/pem_enfield_emails_install.sql-arc   1.0   Feb 28 2011 11:53:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   pem_enfield_emails_install.sql  $
--       Date into PVCS   : $Date:   Feb 28 2011 11:53:46  $
--       Date fetched Out : $Modtime:   Feb 28 2011 11:00:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--   
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
define logfile1='x_pem_enfield_emails_&log_extension'
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
--                        ****************   TABLES  *******************
SET TERM ON
prompt Tables...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pem_emails'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'x_pem_enfield_emails_ddl.sql' run_file
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
select '&exor_base'||'pem_emails'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'x_pem_enfield_emails.pkh' run_file
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
select '&exor_base'||'pem_emails'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'x_pem_enfield_emails.pkb' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                         ****************   Create job  *******************
SET TERM ON
prompt create job...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pem_emails'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'x_pem_emails_create_job.sql' run_file
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

