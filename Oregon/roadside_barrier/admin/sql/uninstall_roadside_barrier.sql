--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/roadside_barrier/admin/sql/uninstall_roadside_barrier.sql-arc   1.0   Oct 22 2010 10:20:38   Ian.Turnbull  $
--       Module Name      : $Workfile:   uninstall_roadside_barrier.sql  $
--       Date into PVCS   : $Date:   Oct 22 2010 10:20:38  $
--       Date fetched Out : $Modtime:   Oct 22 2010 10:17:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- Descr   : drops views XODOT_BARR_V, XODOT_IATN_V and XODOT_EA_CW_DIST_REG_LOOKUP
--           
--
-- ******************************************************************************

spool Roadside_barrier_uninstall.log
drop view XODOT_BARR_V;
drop view XODOT_IATN_V;
drop view XODOT_EA_CW_DIST_REG_LOOKUP;
spool off
