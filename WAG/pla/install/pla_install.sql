-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pla_install.sql-arc   3.3   Jul 13 2009 11:04:42   smarshall  $
--       Module Name      : $Workfile:   pla_install.sql  $
--       Date into PVCS   : $Date:   Jul 13 2009 11:04:42  $
--       Date fetched Out : $Modtime:   Jul 13 2009 11:07:08  $
--       Version          : $Revision:   3.3  $
-------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
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
set term on

define logfile1='pla_install_1_&log_extension'
define logfile2='pla_install_2_&log_extension'
spool &logfile1
--
---------------------------------------------------------------------------------------------------
--                                     ********** CHECKS  ***********
select 'Installation Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MM:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT
--
-- Check that the user isn't sys or system
--
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
      END IF;
END;
/

-- Check that the PLA has not already been installed
BEGIN
   --
   FOR v_recs IN (SELECT hpr_version
                  FROM user_tables
                      ,hig_products
                  WHERE hpr_product = 'PLA'
                  AND   table_name = 'WAG_PLAN_RECORD_CARD') LOOP

               RAISE_APPLICATION_ERROR(-20000,'PLA version '||v_recs.hpr_version||' already installed.');

   END LOOP;
END;
/

--
-- Check that PEM has been installed @ v4.0.5.2 as PLA is dependent on this
--
BEGIN
 hig2.product_exists_at_version (p_product        => 'PEM'
                                ,p_VERSION        => '4.0.5.2'
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
select '&exor_base'||'pla'||'&terminator'||'install'||
       '&terminator'||'pla.tab' run_file
from dual
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
from dual
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
from dual
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
from dual
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
BEGIN
      hig2.upgrade('PLA','pla_install.sql','Installed','4.0.5.2');
END;
/
COMMIT;
SELECT 'Product installed at version '||hpr_product||' ' ||hpr_version details
FROM hig_products
WHERE hpr_product IN ('PLA');
--
--
spool off
exit