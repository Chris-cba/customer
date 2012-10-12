CREATE OR REPLACE TRIGGER xlbe_wol_status_pre_row
AFTER UPDATE OF    wol_status_code
ON work_order_lines
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/trg/xlbe_wol_status_pre_row.trg-arc   1.0   Oct 12 2012 12:22:10   Ian.Turnbull  $
--       Module Name      : $Workfile:   xlbe_wol_status_pre_row.trg  $
--       Date into PVCS   : $Date:   Oct 12 2012 12:22:10  $
--       Date fetched Out : $Modtime:   Oct 05 2012 16:44:56  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_wol_status_pre_row
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

begin
   IF :new.wol_status_code != :old.wol_status_code THEN
     IF :new.wol_status_code = 'ACTIONED' THEN
  xlbe_def_status.tab_wols(xlbe_def_status.tab_wols.count+1):=(:NEW.wol_def_defect_id);
   END IF;
     END IF;
END xlbe_wol_status_pre_row;
/