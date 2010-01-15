-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pla_inst.sql-arc   3.1   Jan 15 2010 11:14:36   malexander  $
--       Module Name      : $Workfile:   pla_inst.sql  $
--       Date into PVCS   : $Date:   Jan 15 2010 11:14:36  $
--       Date fetched Out : $Modtime:   Jan 15 2010 11:14:20  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------

--
-- set pl/sql variables to be referenced by pla_install script
--
set define on

undefine script_mode
col      script_mode new_value script_mode noprint

Select 'UPGRADE' script_mode
From   hig_products
Where  hpr_product = 'PLA'
And    hpr_version = '4.0.5.2'
Union
Select 'INSTALL' script_mode
From   Dual
Where Not Exists (Select 1
                  From   hig_products
                  Where  hpr_product = 'PLA'
                 )
/

define from_version=4052
define to_version=4100
define fix_number=Null

undefine exor_base
undefine run_file
undefine terminator
col exor_base new_value exor_base noprint
col run_file new_value run_file noprint
col terminator new_value terminator noprint

set verify off head off term on

cl scr
prompt
prompt
prompt Please enter the value for exor base. This is the directory under which
prompt the exor software resides (eg c:\exor\ on a client PC). If the value
prompt entered is not correct, the process will not proceed.
prompt There is no default value for this value.
prompt
prompt INPORTANT: Please ensure that the exor base value is terminated with
prompt the directory seperator for your operating system
prompt (eg \ in Windows or / in UNIX).
prompt

accept exor_base prompt "Enter exor base directory now : "

select substr('&exor_base',(length('&exor_base'))) terminator
from dual
/
select decode('&terminator',
              '/',null,
              '\',null,
              'inv_term') run_file
from dual
/

set term off
start '&run_file'
set term on


REM
REM Ensure that exor_base is not greater than 30 characters in length
REM
SELECT DECODE(
              SIGN(30-LENGTH('&exor_base'))
                                          ,1,null
                                          ,'exor_base_too_long.sql') run_file
FROM dual
/
SET term OFF
START '&run_file'
SET term ON


prompt
prompt About to install product foundation layer using exor base : &exor_base
prompt
accept ok_res prompt "OK to Continue with this setting ? (Y/N) "

select decode(upper('&ok_res'),'Y','&exor_base'||'pla'||'&terminator'||'install'||'&terminator'||'pla_install.sql','exit') run_file
from dual
/

start '&run_file'

prompt
prompt The install scripts could not be found in the directory
prompt specified for exor base (&exor_base).
prompt
prompt Please re-run the installation script and enter the correct directory name.
prompt
accept leave_it prompt "Press RETURN to exit from SQL*PLUS"
