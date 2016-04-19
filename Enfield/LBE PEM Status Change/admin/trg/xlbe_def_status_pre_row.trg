CREATE OR REPLACE TRIGGER XLBE_DEF_STATUS_PRE_ROW 
AFTER INSERT OR UPDATE OF def_status_code
ON DEFECTS
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/trg/xlbe_def_status_pre_row.trg-arc   1.1   Apr 19 2016 09:41:22   Chris.Baugh  $
--       Module Name      : $Workfile:   xlbe_def_status_pre_row.trg  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:41:22  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:40:50  $
--       PVCS Version     : $Revision:   1.1  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_def_status_pre_row
--
--    Updated 28-SEP-2015 by Lee Jackson. Change made to fire trigger after insert or update, rather than just after update. Change made in relation to problem reported on SR 7000292234.
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------

begin
   --IF :new.def_status_code != NVL(:old.def_status_code,nm3type.nvl) THEN
   IF INSERTING OR :new.def_status_code != :old.def_status_code THEN
     IF :new.def_serial_no IS NOT NULL THEN
  xlbe_def_status.tab_defects(xlbe_def_status.tab_defects.count+1):=(:NEW.def_defect_id);
   END IF;
     END IF;
END xlbe_def_status_pre_row;
/