---
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/RICS_Unit_Ad_Hoc_Reporting/Rics_ad_hoc_reports_uninstall.sql-arc   3.0   Sep 17 2010 11:58:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   Rics_ad_hoc_reports_uninstall.sql  $
--       Date into PVCS   : $Date:   Sep 17 2010 11:58:28  $
--       Date fetched Out : $Modtime:   Sep 17 2010 11:48:16  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : PStanton
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
--
-- Program : Rics_ad_hoc_reports_uninstall.sql
-- Descr   : drops view xodot_mile_report_v
--                         xodot_traff_report_v
--                         xodot_ohp_v
--
-- ******************************************************************************

spool Rics_ad_hoc_reports_uninstall.log
drop view xodot_mile_report_v;
drop view xodot_traff_report_v;
drop view xodot_ohp_v;
spool off

