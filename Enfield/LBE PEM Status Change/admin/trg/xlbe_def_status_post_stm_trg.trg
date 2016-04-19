CREATE OR REPLACE TRIGGER XLBE_DEF_STATUS_POST_STM_TRG 
AFTER INSERT OR UPDATE OF def_status_code
ON DEFECTS
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/trg/xlbe_def_status_post_stm_trg.trg-arc   1.1   Apr 19 2016 09:40:16   Chris.Baugh  $
--       Module Name      : $Workfile:   xlbe_def_status_post_stm_trg.trg  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:40:16  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:39:42  $
--       PVCS Version     : $Revision:   1.1  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_def_status_post_stm_trg
--
--    Updated 28-SEP-2015 by Lee Jackson. Change made to fire trigger after insert or update, rather than just after update. Change made in relation to problem reported on SR 7000292234.
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
begin
  if xlbe_def_status.tab_defects.COUNT>0 then
    xlbe_def_status.process_defects;
    xlbe_def_status.clear_defects;
  end if;
end xlbe_def_status_post_stm_trg;
/
