DECLARE
 ex_does_not_exist EXCEPTION;
 PRAGMA exception_init(ex_does_not_exist, -12003);
BEGIN
 EXECUTE IMMEDIATE('DROP MATERIALIZED VIEW MV_SWR_STREET_ADD');
EXCEPTION
 WHEN ex_does_not_exist THEN
   Null;
 WHEN others THEN
   Raise; 
END;
/
CREATE MATERIALIZED VIEW MV_SWR_STREET_ADD
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY AS SELECT 
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/Virgin/swr/admin/r90/mv_swr_street_add.vw-arc   3.0   May 22 2008 16:10:42   gjohnson  $
--       Module Name      : $Workfile:   mv_swr_street_add.vw  $
--       Date into PVCS   : $Date:   May 22 2008 16:10:42  $
--       Date fetched Out : $Modtime:   May 22 2008 16:09:58  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
--   
-------------------------------------------------------------------------
--
  sad_str_nsg_ref
, sad_seq
, sad_swa_ref_auth
, sad_odi_ref_auth
, sad_whole_road
, sad_road_status
, sad_swa_ref_maint
, sad_odi_ref_maint
, sad_location_text
, sad_swa_org_type
, sad_swa_ref_supplier
from swr_street_add 
/
create index mv_sad_ind1 on MV_SWR_STREET_ADD(sad_str_nsg_ref, sad_swa_ref_auth, sad_odi_ref_auth)
/
create index mv_sad_ind2 on MV_SWR_STREET_ADD(sad_str_nsg_ref, sad_swa_org_type)
/