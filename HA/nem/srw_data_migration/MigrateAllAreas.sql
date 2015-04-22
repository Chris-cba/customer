-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/MigrateAllAreas.sql-arc   3.0   Apr 22 2015 13:54:34   Mike.Huitson  $
--       Module Name      : $Workfile:   MigrateAllAreas.sql  $
--       Date into PVCS   : $Date:   Apr 22 2015 13:54:34  $
--       Date fetched Out : $Modtime:   Apr 22 2015 14:58:58  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
BEGIN
  --
  srw_data_load.process_closures(pi_srw_operational_area => NULL);
  --
END;