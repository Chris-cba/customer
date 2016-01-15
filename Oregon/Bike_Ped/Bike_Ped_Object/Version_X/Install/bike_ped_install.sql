--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/Bike_Ped/Bike_Ped_Object/Version_X/Install/bike_ped_install.sql-arc   1.0   Jan 15 2016 16:40:02   Sarah.Williams  $
--       Module Name      : $Workfile:   bike_ped_install.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 16:40:02  $
--       Date fetched Out : $Modtime:   Sep 24 2010 22:18:06  $
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
define logfile1='bike_ped_install_1_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

WHENEVER SQLERROR EXIT
--
-- Check that bike_ped has not already been installed
--
DECLARE
  l_table_name         VARCHAR2(100);
  ex_already_installed EXCEPTION;

  TYPE                 refcur IS REF CURSOR;
  rc                   refcur;
  v_sql                VARCHAR2(1000);

BEGIN

   v_sql := 'SELECT table_name FROM user_tables where  table_name = ''XODT_BKPD_MRG_RESULT''';
   --
   OPEN rc FOR v_sql;
   FETCH rc INTO l_table_name;
   CLOSE rc;

   IF l_table_name IS NOT NULL THEN
       RAISE ex_already_installed;
   END IF;

EXCEPTION

 WHEN ex_already_installed THEN
    RAISE_APPLICATION_ERROR(-20000,'Bike Ped already installed.');
 WHEN others THEN
    Null;
END;
/
WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                        ****************   TABLES  *******************
SET TERM ON
prompt Tables...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'bike_ped'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'bike_ped.tab' run_file
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
select '&exor_base'||'bike_ped'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_bike_ped.pkh' run_file
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
select '&exor_base'||'bike_ped'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'bike_ped_mrg_metadata.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                            ****************   VIEWS  *******************

SET TERM ON
prompt Views...
SET TERM OFF
SET DEFINE ON

select '&exor_base'||'bike_ped'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'xodot_cont_bkpd_v.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'bike_ped'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'bike_ped_road_seg_rte.vw' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

SET DEFINE ON

select '&exor_base'||'bike_ped'||'&terminator'||'admin'||'&terminator'||'views'||
        '&terminator'||'xodot_point_bkpd_v.vw' run_file
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
select '&exor_base'||'bike_ped'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'xodot_bike_ped.pkb' run_file
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

