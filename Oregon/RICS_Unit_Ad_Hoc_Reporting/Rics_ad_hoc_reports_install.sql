--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/RICS_Unit_Ad_Hoc_Reporting/Rics_ad_hoc_reports_install.sql-arc   3.0   Sep 17 2010 11:58:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   Rics_ad_hoc_reports_install.sql  $
--       Date into PVCS   : $Date:   Sep 17 2010 11:58:28  $
--       Date fetched Out : $Modtime:   Sep 17 2010 11:45:56  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : PStanton
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
-- Program : Rics_ad_hoc_reports_install.sql
-- Descr   : Creates views xodot_mile_report_v
--                         xodot_traff_report_v
--                         xodot_ohp_v
--
-- ******************************************************************************

spool Rics_ad_hoc_reports_install.log
@@xodot_mile_report_v.vw
@@xodot_traff_report_v.vw
@@xodot_ohp_v.vw
spool off
