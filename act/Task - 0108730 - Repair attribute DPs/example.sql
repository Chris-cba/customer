--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/act/Task - 0108730 - Repair attribute DPs/example.sql-arc   3.0   Nov 23 2009 10:25:02   aedwards  $
--       Module Name      : $Workfile:   example.sql  $
--       Date into PVCS   : $Date:   Nov 23 2009 10:25:02  $
--       Date fetched Out : $Modtime:   Nov 23 2009 10:22:32  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

set serveroutput on

PROMPT ******************************************************
PROMPT Report on the Asset Type 
PROMPT ******************************************************
exec x_act_dp_fix.run_checker('TREE')

PROMPT ******************************************************
PROMPT Repair a particular Asset Type and Attribute
PROMPT ******************************************************
exec x_act_dp_fix.do_asset_type ( pi_asset_type => 'TREE', pi_asset_attrib_name => 'IIT_X')

PROMPT ******************************************************
PROMPT Re-run the report
PROMPT ******************************************************
exec x_act_dp_fix.run_checker('TREE')


