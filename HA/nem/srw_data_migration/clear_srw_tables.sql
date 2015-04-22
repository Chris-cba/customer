-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/clear_srw_tables.sql-arc   3.0   Apr 22 2015 13:54:34   Mike.Huitson  $
--       Module Name      : $Workfile:   clear_srw_tables.sql  $
--       Date into PVCS   : $Date:   Apr 22 2015 13:54:34  $
--       Date fetched Out : $Modtime:   Apr 22 2015 14:55:30  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
truncate table srw_closures
/

truncate table srw_components
/

truncate table srw_dcm_daily
/

truncate table srw_diary
/

truncate table srw_documents
/

truncate table srw_lanes
/

truncate table srw_layouts
/

truncate table srw_sections
/
