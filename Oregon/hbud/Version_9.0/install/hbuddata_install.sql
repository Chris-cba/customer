--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/hbud/Version_9.0/install/hbuddata_install.sql-arc   1.0   Jan 15 2016 19:30:40   Sarah.Williams  $
--       Module Name      : $Workfile:   hbuddata_install.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 19:30:40  $
--       Date fetched Out : $Modtime:   Sep 09 2010 20:39:48  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
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
-------------------------------------------------------------------------------------------
--
SET TERM ON
prompt Running HBUDdata1 ...
SET TERM OFF
SET DEFINE ON
select '&exor_base'||'hbud'||'&terminator'||'install'||
       '&terminator'||'hbuddata1' run_file
from dual
/
SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF
commit;
/
-
--
-------------------------------------------------------------------------------------------
--

