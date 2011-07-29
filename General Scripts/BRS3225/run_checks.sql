-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/run_checks.sql-arc   1.1   Jul 29 2011 08:12:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   run_checks.sql  $
--       Date into PVCS   : $Date:   Jul 29 2011 08:12:36  $
--       Date fetched Out : $Modtime:   Jul 28 2011 16:21:42  $
--       PVCS Version     : $Revision:   1.1  $
--
--
--   Author : Aileen Heal
--
--    Run_checks.sql
--  
--    runs the standard prodcut spatial health checks
--    results are put in folder c:\exor\kestrel\
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- These scripts are for use by exor consultants only. They should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
DECLARE
   l_name varchar2(20);
BEGIN
   Select instance_name into l_name from v$instance;
   nm3sdo_check.run_sdo_check('C:\exor\kestrel\',l_name||'_sdo_check_'||to_char(sysdate,'YYYYMMDD_HH24MISS')||'.log');
   nm3sdo_check.run_theme_check('c:\exor\kestrel\',l_name||'_theme_check_'||to_char(sysdate,'YYYYMMDD_HH24MISS')||'.log');
   if hig.get_sysopt('REGSDELAY') = 'Y' then
     nm3sde_check.run_sde_check('c:\exor\kestrel\',l_name||'_sde_check_'||to_char(sysdate,'YYYYMMDD_HH24MISS')||'.log');
   end if;
END;
/
