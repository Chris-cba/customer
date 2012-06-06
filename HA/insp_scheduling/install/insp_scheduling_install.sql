--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/install/insp_scheduling_install.sql-arc   1.0   Jun 06 2012 16:23:32   Ian.Turnbull  $
--       Module Name      : $Workfile:   insp_scheduling_install.sql  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:23:32  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:16:32  $
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
define logfile1='insp_scheduling_1_&log_extension'
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

select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'v_ha_upd_insp.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'


select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'mai3700_asset_list.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
---------------------------------------------------------------------------------------------------
--                        ****************   META-DATA  *******************
SET TERM ON
PROMPT Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Creating Sequence 'ASSET_INSP_BATCH_SEQ'
SET TERM OFF
CREATE SEQUENCE ASSET_INSP_BATCH_SEQ
START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE;
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   Procedures  *******************

SET TERM ON
prompt Procedures and Packages...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'ha_insp.pkh' run_file
from dual
/


SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
---
SET DEFINE ON
select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'ha_insp.pkb' run_file
from dual
/


SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
---
---------------------------------------------------------------------------------------------------
--  

---------------------------------------------------------------------------------------------------
--                        ****************   CSV Loaders *******************

SET TERM ON
prompt CSV Loader.......
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'nm_load_destinations.sql' run_file
from dual
/


SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
---
SET DEFINE ON
select '&exor_base'||'insp_scheduling'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'update_inpections_csv_loader.sql' run_file
from dual
/


SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Creating Synonyms That Do Not Exist...
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;

---------------------------------------------------------------------------------------------------
--
SET TERM OFF

spool off
exit

