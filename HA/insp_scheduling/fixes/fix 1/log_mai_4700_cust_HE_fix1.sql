-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/fixes/fix 1/log_mai_4700_cust_HE_fix1.sql-arc   1.0   Jan 27 2016 14:11:36   Chris.Baugh  $
--       Module Name      : $Workfile:   log_mai_4700_cust_HE_fix1.sql  $
--       Date into PVCS   : $Date:   Jan 27 2016 14:11:36  $
--       Date fetched Out : $Modtime:   Jan 27 2016 11:53:48  $
--       Version          : $Revision:   1.0  $
------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
BEGIN
--
  hig2.upgrade(p_product        => 'MAI'
              ,p_upgrade_script => 'log_mai_4700_cust_HE_fix1.sql'
              ,p_remarks        => 'MAI 4700 Customer HE FIX 1 for Partial Inspections'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
