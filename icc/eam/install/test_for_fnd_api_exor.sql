--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/install/test_for_fnd_api_exor.sql-arc   1.0   Nov 28 2008 11:22:52   mhuitson  $
--       Module Name      : $Workfile:   test_for_fnd_api_exor.sql  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:22:52  $
--       Date fetched Out : $Modtime:   Nov 28 2008 11:22:12  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
declare
lv_dummy varchar2(240);
begin
lv_dummy:=fnd_api_exor.get_work_request_status(1);
end;