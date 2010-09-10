-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/rics_point_data/rics_point_uninstall.sql-arc   3.0   Sep 10 2010 14:53:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   rics_point_uninstall.sql  $
--       Date into PVCS   : $Date:   Sep 10 2010 14:53:24  $
--       Date fetched Out : $Modtime:   Sep 10 2010 12:55:14  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton           
--                        
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- Program : Rics_point_install.sql
-- Descr   : drops view xodot_rwy_point_locs
--           
--
-- ******************************************************************************

spool Rics_point_uninstall.log
drop view xodot_rwy_point_locs;
spool off
