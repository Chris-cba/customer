--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/install/api_syns.sql-arc   1.0   Nov 28 2008 11:22:50   mhuitson  $
--       Module Name      : $Workfile:   api_syns.sql  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:22:50  $
--       Date fetched Out : $Modtime:   Nov 28 2008 11:22:02  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--For Create WR
CREATE SYNONYM FND_API_EXOR FOR APPS.FND_API_EXOR@TRNICC_EAM
/

CREATE SYNONYM CS_INCIDENTS_ALL_B FOR APPS.CS_INCIDENTS_ALL_B@TRNICC_EAM
/

CREATE SYNONYM cs_incidents_all_tl FOR cs.cs_incidents_all_tl@TRNICC_EAM
/

CREATE SYNONYM WIP_EAM_WORK_REQUESTS FOR APPS.WIP_EAM_WORK_REQUESTS@TRNICC_EAM
/

CREATE SYNONYM EAM_COMMON_UTILITIES_PVT FOR APPS.EAM_COMMON_UTILITIES_PVT@TRNICC_EAM
/

CREATE SYNONYM EAM_LINEAR_LOCATIONS_PUB FOR APPS.EAM_LINEAR_LOCATIONS_PUB@TRNICC_EAM
/

CREATE SYNONYM mtl_system_items_b_kfv FOR apps.mtl_system_items_b_kfv@TRNICC_EAM
/

CREATE SYNONYM fnd_user FOR applsys.fnd_user@TRNICC_EAM
/

CREATE SYNONYM fnd_global FOR apps.fnd_global@TRNICC_EAM
/

CREATE SYNONYM wip_eam_workrequest_pub FOR wip_eam_workrequest_pub@TRNICC_EAM
/

CREATE SYNONYM MTL_SERIAL_NUMBERS FOR inv.MTL_SERIAL_NUMBERS@TRNICC_EAM
/

create synonym mtl_system_items_b for inv.mtl_system_items_b@TRNICC_EAM
/

-- For Create WO
create synonym eam_process_wo_pub for apps.eam_process_wo_pub@TRNICC_EAM
/

