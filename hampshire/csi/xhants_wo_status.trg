create or replace TRIGGER xhants_wo_status 
After update of wol_status_code on work_order_lines
For each row
declare
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_wo_status.trg-arc   1.1   Oct 07 2010 21:38:46   ian.turnbull  $
--       Module Name      : $Workfile:   xhants_wo_status.trg  $
--       Date into PVCS   : $Date:   Oct 07 2010 21:38:46  $
--       Date fetched Out : $Modtime:   Oct 07 2010 21:37:52  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

begin
--  if :new.wol_status_code = 'ROUTINE' and :old.wol_status_code != 'ROUTINE' then
--    xhants_pem_bespoke.set_routine(:new.wol_def_defect_id);
--  end if;
  --
  -- COMPLETED temp taken out--
  --if :new.wol_status_code = 'COMPLETED' and :old.wol_status_code != 'COMPLETED' then
    --xhants_pem_bespoke.set_complete_3rd_party(:new.wol_def_defect_id,:new.wol_works_order_no,:new.wol_descr);
  --end if;
  -- AUTHORISED temp taken out--
  --if :new.wol_status_code = 'AUTHORISED' and :old.wol_status_code != 'AUTHORISED' then
    --xhants_pem_bespoke.set_routine(:new.wol_def_defect_id,:new.wol_works_order_no);
  --end if;
  --
--  if :new.wol_status_code = 'REJECTED' and :old.wol_status_code != 'REJECTED' then
--    xhants_pem_bespoke.mail_rejected_wo(:new.wol_id,:new.wol_rse_he_id,:new.wol_works_order_no,:new.wol_def_defect_id);
--  end if;
  --
  if :new.wol_status_code = 'QUERIED' and :old.wol_status_code != 'QUERIED' then
    xhants_pem_bespoke.mail_queried_wo(:new.wol_id,:new.wol_rse_he_id,:new.wol_works_order_no,:new.wol_def_defect_id,:new.wol_descr,:new.wol_locn_descr);
  end if;
  --
--  if :new.wol_status_code = 'CANCELLED' and :old.wol_status_code != 'CANCELLED' then
--    xhants_pem_bespoke.set_cancelled(:new.wol_def_defect_id,:new.wol_descr);
--  end if;
  --
--  if :new.wol_status_code = 'READY' and :old.wol_status_code != 'READY' then
--    xhants_pem_bespoke.mail_ready_auth(:new.wol_id,:new.wol_rse_he_id,:new.wol_works_order_no,:new.wol_def_defect_id);
--  end if;
end;