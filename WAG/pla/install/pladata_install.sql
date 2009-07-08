-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/pla/install/pladata_install.sql-arc   3.0   Jul 08 2009 11:35:26   smarshall  $
--       Module Name      : $Workfile:   pladata_install.sql  $
--       Date into PVCS   : $Date:   Jul 08 2009 11:35:26  $
--       Date fetched Out : $Modtime:   Jul 08 2009 11:35:12  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------

set echo off
set linesize 120
set heading off
set feedback off

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
--
--
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/
--
--
SET TERM ON
Prompt Running pladata1...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'pla'||'&terminator'||'install'||
        '&terminator'||'pladata1' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
--
--
