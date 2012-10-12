CREATE OR REPLACE TRIGGER xlbe_def_status_pre_row
AFTER UPDATE OF def_status_code
ON defects
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/trg/xlbe_def_status_pre_row.trg-arc   1.0   Oct 12 2012 12:22:10   Ian.Turnbull  $
--       Module Name      : $Workfile:   xlbe_def_status_pre_row.trg  $
--       Date into PVCS   : $Date:   Oct 12 2012 12:22:10  $
--       Date fetched Out : $Modtime:   Oct 05 2012 16:44:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_def_status_pre_row
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
begin
   IF :new.def_status_code != :old.def_status_code THEN
     IF :new.def_serial_no is not null THEN
  xlbe_def_status.tab_defects(xlbe_def_status.tab_defects.count+1):=(:NEW.def_defect_id);
   END IF;
     END IF;
END xlbe_def_status_pre_row;
/

