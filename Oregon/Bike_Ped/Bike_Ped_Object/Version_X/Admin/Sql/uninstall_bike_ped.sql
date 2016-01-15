--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/Bike_Ped/Bike_Ped_Object/Version_X/Admin/Sql/uninstall_bike_ped.sql-arc   1.0   Jan 15 2016 16:39:26   Sarah.Williams  $
--       Module Name      : $Workfile:   uninstall_bike_ped.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 16:39:26  $
--       Date fetched Out : $Modtime:   Sep 24 2010 22:31:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- Sctipt to remove Bike Ped
drop table XODOT_BKPD_MRG_RESULT;

drop table XODOT_BKPD_POINT_RESULT;

drop package xodot_bike_ped;

drop view bike_ped_ROAD_SEG_RTE;

drop view XODOT_CONT_BKPD_V;

drop view XODOT_POINT_BKPD_V;

DECLARE

l_merge_id number;

BEGIN
    
	
    select nmq_id into l_merge_id from NM_MRG_QUERY_ALL where NMQ_UNIQUE = 'BIKE_PED_MRG';
    
    delete from  NM_MRG_QUERY_ALL where NMQ_ID = l_merge_id;
    
    commit; 
    
END; 
/  

