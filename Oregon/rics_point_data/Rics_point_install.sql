-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/rics_point_data/Rics_point_install.sql-arc   3.0   Sep 10 2010 14:53:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   Rics_point_install.sql  $
--       Date into PVCS   : $Date:   Sep 10 2010 14:53:22  $
--       Date fetched Out : $Modtime:   Sep 10 2010 12:55:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton           
--                        
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
-- Program : Rics_point_install.sql
-- Descr   : Creates view xodot_rwy_point_locs
--           
--
-- ******************************************************************************

spool Rics_point_install.log
@@xodot_rwy_point_locs.vw
spool off
