CREATE OR REPLACE TRIGGER xodot_BIUS_NM_ELEMENTS_ALL
BEFORE INSERT OR UPDATE OF NE_NAME_2 ON NM_ELEMENTS_ALL
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/gasb34/admin/sql/xodot_bius_nm_elements_all.trg-arc   3.0   Sep 15 2010 09:57:56   ian.turnbull  $
--       Module Name      : $Workfile:   xodot_bius_nm_elements_all.trg  $
--       Date into PVCS   : $Date:   Sep 15 2010 09:57:56  $
--       Date fetched Out : $Modtime:   Sep 15 2010 09:54:04  $
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
BEGIN
   IF xodot_gasb34_package.g_in_process = TRUE THEN
      null;
  ELSE
      xodot_gasb34_package.clear_table;
      xodot_gasb34_package.g_in_process := FALSE;
  END IF; 

END xodot_transfer_trg_1;
/