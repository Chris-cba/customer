--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/fixes/log_mai_4700_cust_HE_fix2.sql-arc   1.0   Jan 31 2017 09:22:18   James.Wadsworth  $
--       Module Name      : $Workfile:   log_mai_4700_cust_HE_fix2.sql  $
--       Date into PVCS   : $Date:   Jan 31 2017 09:22:18  $
--       Date fetched Out : $Modtime:   Jan 31 2017 09:20:12  $
--       PVCS Version     : $Revision:   1.0  $

--
--------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'MAI'
              ,p_upgrade_script => 'log_mai_4700_cust_HE_fix2.sql'
              ,p_remarks        => 'MAI 4700 Customer HE FIX 2'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
