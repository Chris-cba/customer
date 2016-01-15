--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/hbud/Version_9.0/install/compile_hbud.sql-arc   1.0   Jan 15 2016 19:30:00   Sarah.Williams  $
--       Module Name      : $Workfile:   compile_hbud.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 19:30:00  $
--       Date fetched Out : $Modtime:   Sep 09 2010 20:39:46  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

DECLARE
  v_view_name VARCHAR2(30);
BEGIN

IF NOT nm3ddl.does_object_exist(nm3inv_view.work_out_inv_type_view_name ('HACT'),'VIEW') THEN
  nm3inv.Create_inv_view('HACT', FALSE, v_view_name);
END IF;

END;
/
alter package XODOT_HBUD_EXTRACT_PROCESS compile;
