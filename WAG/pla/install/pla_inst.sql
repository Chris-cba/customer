-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pla_inst.sql-arc   3.0   Jul 08 2009 11:11:42   smarshall  $
--       Module Name      : $Workfile:   pla_inst.sql  $
--       Date into PVCS   : $Date:   Jul 08 2009 11:11:42  $
--       Date fetched Out : $Modtime:   Jul 08 2009 11:11:28  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------

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

Prompt Done