--<PACKAGE>
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/zmiles/install/xodot_zmile_tab.sql-arc   1.0   Oct 12 2010 11:53:56   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_zmile_tab.sql  $
--       Date into PVCS   : $Date:   Oct 12 2010 11:53:56  $
--       Date fetched Out : $Modtime:   Oct 12 2010 11:51:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : H.Buckley
--
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  G_SCCSID CONSTANT VARCHAR2(2000):='"$Revision:   1.0  $"';

--</GLOBVAR>


 create table xodot_zmile_transient
 as select *
    from   nm_members_all
    where 1=2;

-- I have decided to create an index here but in reality it may be
-- better without one because the table should not be a buildup of records
-- in this table so the table should be small. All rows in this table will be
-- deleted at the end of the initial transaction.

create unique index xodot_zmile_trans_idx1
on xodot_zmile_transient ( nm_ne_id_in,nm_ne_id_of);

create public synonym xodot_zmile_transient for xodot_zmile_transient; 

