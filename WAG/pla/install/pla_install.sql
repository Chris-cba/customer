-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pla_install.sql-arc   3.7   Feb 01 2010 10:52:04   malexander  $
--       Module Name      : $Workfile:   pla_install.sql  $
--       Date into PVCS   : $Date:   Feb 01 2010 10:52:04  $
--       Date fetched Out : $Modtime:   Feb 01 2010 10:16:10  $
--       Version          : $Revision:   3.7  $
-------------------------------------------------------------------------
--	Copyright (c) Exor Corporation Ltd, 2010
-------------------------------------------------------------------------
--
--
set echo off
set linesize 120
set heading off
set feedback off
--
---------------------------------------------------------------------------------------------------
--                             ****************** LOG FILE *******************
-- Grab date/time to append to log file names this is standard to all upgrade/install scripts
--
undefine log_extension
col         log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/

---
-- The following pl/sql variables must be defined (some will be null) for the appropriately named logfile to be generated
--
--
--   VARIABLE     |  RULES FOR SETTING                                                 | EXAMPLE VALUE(S)
-- ===============================================================================================================
--   script_mode  |  Mandatory                                                         | 'INSTALL' 'UPGRADE' 'FIX'
--   from_version |  Mandatory when script_mode is 'UPGRADE' or 'FIX', null otherwise  | 4052
--   to_version   |  Mandatory when script_mode is 'UPGRADE', null otherwise           | 4100
--   fix_number   |  Mandatory when script_mode is 'FIX', null otherwise               | 1
--
--

undefine proper_to_version
col      proper_to_version new_value proper_to_version noprint
select substr(&to_version,1,1)||'.'||substr(&to_version,2,1)||'.'||substr(&to_version,3,1)||'.'||substr(&to_version,4,1) proper_to_version
from dual
/  

undefine logfile1
col      logfile1 new_value logfile1 noprint
undefine logfile2
col      logfile2 new_value logfile2 noprint   

set term off
select  case when UPPER('&script_mode') = 'INSTALL' THEN 
                  'pla_install_1_&log_extension' 
             when UPPER('&script_mode') = 'UPGRADE' THEN 
                  'pla'||&from_version||'_pla'||&to_version||'_1_'||'&log_extension'
             else
                  'pla'||&from_version||'_fix'||&fix_number||'_1_'||'&log_extension' 
             end logfile1                       
from dual             
/
set term on

set term off
select  case when UPPER('&script_mode') = 'INSTALL' THEN 
                  'pla_install_2_&log_extension' 
             when UPPER('&script_mode') = 'UPGRADE' THEN 
                  'pla'||&from_version||'_pla'||&to_version||'_2_'||'&log_extension'
             else
                  'pla'||&from_version||'_fix'||&fix_number||'_2_'||'&log_extension' 
             end logfile2                       
from dual             
/
set term on
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--                                     ********** CHECKS  ***********
select 'Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET',null);

WHENEVER SQLERROR EXIT

--
-- Check that the user isn't sys or system AND that the correct version of APEX is installed.
--
DECLARE
  l_count number; 
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
      END IF;
      
      select count(username) into l_count from dba_users where username like '%0302%';
      IF l_count < 1
       THEN
         RAISE_APPLICATION_ERROR(-20001,'You do not have the correct version of Apex installed (3.0.2.0) '); 
      END IF;
END;
/


--
-- Check that PEM has been installed @ v4.1.0.0 as PLA is dependent on this
--
BEGIN
 hig2.product_exists_at_version (p_product        => 'ENQ'
                                ,p_VERSION        => '4.1.0.0'
                                );
END;
/

WHENEVER SQLERROR CONTINUE
--
---------------------------------------------------------------------------------------------------
--                    ********************* TABLES *************************
SET TERM ON
Prompt Tables...
SET TERM OFF
SET DEFINE ON
Select '&exor_base'||'pla'||'&terminator'||'install'||
        '&terminator'||'pla.tab' run_file
From   dual
Where Not Exists (Select 'Install'
                  From   hig_products
                  Where  hpr_product = 'PLA'
                  And    hpr_version In ('4.0.5.2','4.1.0.0')
                 )
Union
Select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy.sql'
From   hig_products
Where Exists (Select 'Upgrade From 4052'
              From   hig_products
              Where  hpr_product = 'PLA'
              And    hpr_version = '4.0.5.2'
             )
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                    ********************* INDEXES *************************
SET TERM ON
Prompt Indexes...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla.ind' run_file
From   dual
Where Not Exists (Select 'Install'
                  From   hig_products
                  Where  hpr_product = 'PLA'
                  And    hpr_version In ('4.0.5.2','4.1.0.0')
                 )
Union
Select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy.sql'
From   hig_products
Where Exists (Select 'Upgrade From 4052'
              From   hig_products
              Where  hpr_product = 'PLA'
              And    hpr_version = '4.0.5.2'
             )
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                    ********************* CONSTRAINTS *************************
SET TERM ON
Prompt Constraints...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla.con' run_file
From   dual
Where Not Exists (Select 'Install'
                  From   hig_products
                  Where  hpr_product = 'PLA'
                  And    hpr_version In ('4.0.5.2','4.1.0.0')
                 )
Union
Select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy.sql'
From   hig_products
Where Exists (Select 'Upgrade From 4052'
              From   hig_products
              Where  hpr_product = 'PLA'
              And    hpr_version = '4.0.5.2'
             )
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                    ********************* SEQUENCES *************************
SET TERM ON
Prompt Sequences...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla.sqs' run_file
From   dual
Where Not Exists (Select 'Install'
                  From   hig_products
                  Where  hpr_product = 'PLA'
                  And    hpr_version In ('4.0.5.2','4.1.0.0')
                 )
Union
Select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'dummy.sql'
From   hig_products
Where Exists (Select 'Upgrade From 4052'
              From   hig_products
              Where  hpr_product = 'PLA'
              And    hpr_version = '4.0.5.2'
             )
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                    ********************* DOC Scripts *************************
/*
SET TERM ON
Prompt DOC Scripts...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pem'||'&terminator'||'install'||
        '&terminator'||'doc_procs' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
*/
--
---------------------------------------------------------------------------------------------------
--                    ********************* VIEWS *************************
/*
SET TERM ON
Prompt Views...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
      '&terminator'||'pla.vw' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
*/
--
---------------------------------------------------------------------------------------------------
--                    ********************* PACKAGES *************************
/*
SET TERM ON
Prompt Packages...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'plapkh.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'admin'||
        '&terminator'||'pck'||'&terminator'||'plapkb.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
*/
--
---------------------------------------------------------------------------------------------------
--                    ********************* TRIGGERS *************************
/*
SET TERM ON
Prompt Triggers...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'admin'||
        '&terminator'||'trg'||'&terminator'||'platrg.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
*/
--
---------------------------------------------------------------------------------------------------
--                        ****************   COMPILE SCHEMA   *******************
SET TERM ON
Prompt Creating Compiling Schema Script...
SET TERM OFF
SPOOL OFF

SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
'&terminator'||'utl'||'&terminator'||'compile_schema.sql' run_file
FROM dual
/
START '&run_file'

spool &logfile2

--get some db info
select 'Install Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;
SELECT 'Install Running on ' ||LOWER(username||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance
    ,user_users;

START compile_all.sql
--
---------------------------------------------------------------------------------------------------
--                        ****************   CONTEXT   *******************
--The compile_all will have reset the user context so we must reinitialise it
--
SET FEEDBACK OFF

SET TERM ON
PROMPT Reinitialising Context...
SET TERM OFF
BEGIN
  nm3context.initialise_context;
  nm3user.instantiate_user;
END;
/
--
---------------------------------------------------------------------------------------------------
--                    ********************* META-DATA *************************
SET TERM ON
Prompt Meta-Data...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
        '&terminator'||'pladata_install.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   SYNONYMS   *******************
SET TERM ON
Prompt Creating Synonyms That Do Not Exist...
SET TERM OFF
EXECUTE nm3ddl.refresh_all_synonyms;
--
---------------------------------------------------------------------------------------------------
--                        ****************   ROLES  *******************
/*
SET TERM ON
Prompt Roles...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla_roles.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
--
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla_user_roles.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
*/
--
--
SET TERM ON
Prompt Updating HIG_USER_ROLES...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'nm3'||'&terminator'||'install'||
        '&terminator'||'hig_user_roles.sql' run_file
from dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
--
---------------------------------------------------------------------------------------------------
--                        ****************   VERSION NUMBER   *******************
SET TERM ON
Prompt Setting The Version Number...
SET TERM OFF

undefine hig_upgrades_sql
col      hig_upgrades_sql new_value hig_upgrades_sql noprint
set term off
select  case when UPPER('&script_mode') = 'INSTALL' THEN 
                  'begin hig2.upgrade(''''PLA'''',''''pla_install.sql'''',''''Installed'''',''''&proper_to_version''''); end;'
             when UPPER('&script_mode') = 'UPGRADE' THEN 
                  'begin hig2.upgrade(''''PLA'''',''''pla_install.sql'''',''''Upgrade from &from_version to &to_version'''',''''&proper_to_version''''); end;'
             else
                  'begin hig2.upgrade(''''PLA'''',''''pla_install.sql'''',''''PLA Fix &fix_number'''',Null); end;'
             end hig_upgrades_sql                        
from dual             
/

begin
execute immediate '&hig_upgrades_sql';
end;
/
COMMIT;


select  case when UPPER('&script_mode') = 'INSTALL' THEN 
                  'Product installed at version '||hpr_product||' ' ||hpr_version 
             when UPPER('&script_mode') = 'UPGRADE' THEN 
                  'Product upgraded to version '||hpr_product||' ' ||hpr_version 
             else
                  'Fix applied'
             end details
FROM hig_products
WHERE hpr_product IN ('PLA');
--
---------------------------------------------------------------------------------------------------
--                    ********************* APPLICATION AND PODS *************************
SET TERM ON
Prompt Application and Pods...
SET TERM OFF
SET DEFINE ON  
select '&exor_base'||'pla'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'f624_wag_planning_v24' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
spool off
exit