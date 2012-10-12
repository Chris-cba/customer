CREATE OR REPLACE TRIGGER xlbe_wol_status_post_stm_trg
AFTER UPDATE OF wol_status_code
ON work_order_lines
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/LBE PEM Status Change/admin/trg/xlbe_wol_status_post_stm_trg.trg-arc   1.0   Oct 12 2012 12:22:10   Ian.Turnbull  $
--       Module Name      : $Workfile:   xlbe_wol_status_post_stm_trg.trg  $
--       Date into PVCS   : $Date:   Oct 12 2012 12:22:10  $
--       Date fetched Out : $Modtime:   Oct 05 2012 16:44:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Garry Bleakley
--
--    xlbe_wol_status_post_stm_trg
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
begin
  if xlbe_def_status.tab_wols.COUNT>0 then
    xlbe_def_status.process_wols;
    xlbe_def_status.clear_wols;
  end if;
end xlbe_wol_status_post_stm_trg;
/ 
