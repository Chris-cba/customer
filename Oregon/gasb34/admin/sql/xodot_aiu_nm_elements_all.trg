create or replace trigger XODOT_AIU_NM_ELEMENTS_ALL AFTER INSERT OR UPDATE OF NE_NAME_2 ON NM_ELEMENTS_ALL
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/gasb34/admin/sql/xodot_aiu_nm_elements_all.trg-arc   3.0   Sep 15 2010 09:57:56   ian.turnbull  $
--       Module Name      : $Workfile:   xodot_aiu_nm_elements_all.trg  $
--       Date into PVCS   : $Date:   Sep 15 2010 09:57:56  $
--       Date fetched Out : $Modtime:   Sep 15 2010 09:54:02  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
--    XODOT_AIU_NM_ELEMENTS_ALL
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
begin 
                            
IF xodot_gasb34_package.g_in_process = FALSE THEN 


    xodot_gasb34_package.g_in_process := TRUE;
		
	xodot_gasb34_package.update_elements;
	
	xodot_gasb34_package.g_in_process := FALSE;

END IF;	
	
end; 
/ 