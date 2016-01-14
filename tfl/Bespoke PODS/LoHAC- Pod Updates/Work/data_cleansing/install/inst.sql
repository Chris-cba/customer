REM////////////////////////////////////////////////////////////////////////////
REM   Subversion controlled - SQL template
REM////////////////////////////////////////////////////////////////////////////
REM Id              : $Id:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/inst.sql-arc   1.0   Jan 14 2016 22:37:58   Sarah.Williams  $
REM Date            : $Date:   Jan 14 2016 22:37:58  $
REM Revision        : $Revision:   1.0  $
REM Changed         : $LastChangedDate:    $
REM Last Revision   : $LastChangedRevision:$
REM Last Changed By : $LastChangedBy: $
REM URL             : $URL: $
REM ///////////////////////////////////////////////////////////////////////////
REM Descr: This package has been provided so that date expired data can be 
REM        removed from the system.
REM   
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/data_cleansing/install/inst.sql-arc   1.0   Jan 14 2016 22:37:58   Sarah.Williams  $
--       Module Name      : $Workfile:   inst.sql  $
--       Date into PVCS   : $Date:   Jan 14 2016 22:37:58  $
--       Date fetched Out : $Modtime:   Jul 09 2013 11:13:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : H.Buckley
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2012
-----------------------------------------------------------------------------
--
-- Check that the user isn't sys or system
--
WHENEVER SQLERROR EXIT
BEGIN
   --
      IF USER IN ('SYS','SYSTEM')
       THEN
         RAISE_APPLICATION_ERROR(-20000,'You cannot install Inspection Scheduling as ' || USER);
      END IF;
END;      
/
WHENEVER SQLERROR CONTINUE

undefine exor_base
undefine run_file
undefine terminator
col exor_base new_value exor_base noprint
col run_file new_value run_file noprint
col terminator new_value terminator noprint

set verify off head off term on

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

prompt
prompt About to install Inspection Scheduling using exor base : &exor_base
prompt
accept ok_res prompt "OK to Continue with this setting ? (Y/N) "
--
select decode(upper('&ok_res'),'Y','&exor_base'||'&terminator'||
        'install'||'&terminator'||'data_cleansing_install','exit') run_file
from dual
/
--
start '&run_file'
--
prompt
prompt The Highways install scripts could not be found in the directory
prompt specified for exor base (&exor_base).
prompt
prompt Please re-run the installation script and enter the correct directory name.
prompt
accept leave_it prompt "Press RETURN to exit from SQL*PLUS"
exit;
