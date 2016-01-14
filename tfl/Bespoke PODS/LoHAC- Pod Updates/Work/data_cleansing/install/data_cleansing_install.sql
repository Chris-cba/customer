REM////////////////////////////////////////////////////////////////////////////
REM   Subversion controlled - SQL template
REM////////////////////////////////////////////////////////////////////////////
REM Id              : $Id:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/data_cleansing_install.sql-arc   1.0   Jan 14 2016 22:37:48   Sarah.Williams  $
REM Date            : $Date:   Jan 14 2016 22:37:48  $
REM Revision        : $Revision:   1.0  $
REM Changed         : $LastChangedDate:    $
REM Last Revision   : $LastChangedRevision:$
REM Last Changed By : $LastChangedBy: $
REM URL             : $URL: $
REM ///////////////////////////////////////////////////////////////////////////
REM Descr: This package was originally written by PS. I have been asked to
REM        modify the package so that it makes use of separate FTP locations.
REM   
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/data_cleansing_install.sql-arc   1.0   Jan 14 2016 22:37:48   Sarah.Williams  $
--       Module Name      : $Workfile:   data_cleansing_install.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 22:37:48  $
--       Date fetched Out : $Modtime:   Jul 09 2013 11:13:44  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2012
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
define logfile1='data_cleansing_1_&log_extension'
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
--                        ****************   META-DATA  *******************
SET TERM ON
PROMPT Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'&terminator'||'install'||
        '&terminator'||'metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   Procedures  *******************
SET TERM ON
prompt Procedures and Packages...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'hig_data_cleansing.pkh' run_file
from dual
/
--
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
---
SET DEFINE ON
select '&exor_base'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'hig_data_cleansing.pkb' run_file
from dual
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Creating Synonyms That Do Not Exist...
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;
--
---------------------------------------------------------------------------------------------------
--
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
---------------------------------------------------------------------------------------------------
--
SET TERM OFF

spool off
exit