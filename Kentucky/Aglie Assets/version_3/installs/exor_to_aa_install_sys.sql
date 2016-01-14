/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: exor_to_aa_install_sys.sql
	Author: JMM
	UPDATE01:	Original, 2014.01.16, JMM
*/


set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  '' ||TO_CHAR(sysdate,'YYYY.MM.DD_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='EXOR_TO_AA_SYS_&log_extension'
define logfile2='EXOR_TO_AA_SYS_2_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Install Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER NOT IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Starting install ...
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\tables\xaa_user.sql;
SET FEEDBACK OFF
--

--
--------------------------------------------------------------------------------
-- Compile the schema
--------------------------------------------------------------------------------
/*--
SET TERM ON
Prompt Executing the Compile_schema
SET TERM OFF
SPOOL OFF
SET define ON

--start compile_schema;
--
--
/*
spool &logfile2
SET TERM ON
start compile_all.sql
spool off
--
*/
EXIT;
--
--