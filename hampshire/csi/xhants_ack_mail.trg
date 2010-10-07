create or replace trigger xhants_ack_mail
after update 
on     docs
for    each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_ack_mail.trg-arc   1.1   Oct 07 2010 21:38:40   ian.turnbull  $
--       Module Name      : $Workfile:   xhants_ack_mail.trg  $
--       Date into PVCS   : $Date:   Oct 07 2010 21:38:40  $
--       Date fetched Out : $Modtime:   Oct 07 2010 21:37:52  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------

declare
--
begin
    if :new.doc_compl_user_id != :old.doc_compl_user_id then
      xhants_pem_bespoke.mail_new_resp(:new.doc_id,
                                       :new.doc_reference_code,
                                       :new.doc_descr,
                                       :new.doc_compl_location,
                                       :new.doc_dtp_code,
                                       :new.doc_dcl_code,
                                       :new.doc_compl_type,
                                       :new.doc_reason,
                                       :new.doc_compl_user_id,
                                       :new.doc_compl_user_type);
    end if;
    if :new.doc_dtp_code = 'HDEF' then
      --
      if :new.doc_status_code = 'CTP' and :old.doc_status_code != 'CTP' and :new.doc_compl_user_type = 'USER' then
        xhants_pem_bespoke.mail_poss_recharge(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_compl_user_id);
        --insert into al_debug values (1,2);
      end if;
      --
      if :new.doc_status_code = 'OLG' and :old.doc_status_code != 'OLG' and :new.doc_compl_user_type ='CONT' then
        xhants_pem_bespoke.mail_new_ext_resp(:new.doc_id,
                                             :new.doc_reference_code,
                                             :new.doc_descr,
                                             :new.doc_compl_location,
                                             :new.doc_dtp_code,
                                             :new.doc_dcl_code,
                                             :new.doc_compl_type,
                                             :new.doc_reason,
                                             :new.doc_compl_user_id,
                                             :new.doc_compl_user_type);
      end if;
      --
      if :new.doc_status_code = 'EX' and :old.doc_status_code != 'EX' and :new.doc_compl_user_type ='CONT' then
        xhants_pem_bespoke.mail_inform_3rd  (:new.doc_id,
                                             :new.doc_reference_code,
                                             :new.doc_descr,
                                             :new.doc_compl_location,
                                             :new.doc_dtp_code,
                                             :new.doc_dcl_code,
                                             :new.doc_compl_type,
                                             :new.doc_reason,
                                             :new.doc_compl_user_id,
                                             :new.doc_compl_user_type);
      end if;
      --
      --if :new.doc_status_code = 'AK' and :old.doc_status_code = 'RE' then
      --  xhants_pem_bespoke.set_null_contact_email(:new.doc_id,:new.doc_compl_user_id);
      --end if;
      --
      --if :new.doc_status_code = 'AK' and :old.doc_status_code = 'RE' then
      --  xhants_pem_bespoke.mail_auto_ack(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
      --end if;
      --
      if :new.doc_status_code = 'EX' and :old.doc_status_code != 'EX' then
        xhants_pem_bespoke.mail_3rd_party(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location,:new.doc_compl_user_id,:new.doc_compl_user_type);
      end if;
      if :new.doc_status_code = 'OLG' and :old.doc_status_code != 'OLG' then
        xhants_pem_bespoke.mail_olg_3rd_party(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location,:new.doc_compl_user_id,:new.doc_compl_user_type);
      end if;
      if :new.doc_status_code = 'UEX' and :old.doc_status_code != 'UEX' then
          xhants_pem_bespoke.mail_unknown_3rd_party(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
      end if;
      --
      if :new.doc_compl_source in ('F','S','L','W','E','P','T') then
        --
        if :new.doc_status_code = 'MG' and :old.doc_status_code != 'MG' then
          xhants_pem_bespoke.mail_maint_gang(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
        if :new.doc_status_code = 'MS' and :old.doc_status_code != 'MS' then
          xhants_pem_bespoke.mail_made_safe(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
        if :new.doc_status_code = 'PW' and :old.doc_status_code != 'PW' then
          xhants_pem_bespoke.mail_planned_work(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
        if :new.doc_status_code = 'NM' and :old.doc_status_code != 'NM' then
          xhants_pem_bespoke.mail_no_work_reqd(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
        if :new.doc_status_code = 'ND' and :old.doc_status_code != 'ND' then
          xhants_pem_bespoke.mail_no_def_found(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
        if :new.doc_status_code = 'PC' and :old.doc_status_code != 'PC' then
          xhants_pem_bespoke.mail_passed_contractor(:new.doc_id,nvl(:new.doc_reference_code,:new.doc_id),:new.doc_descr,:new.doc_compl_location);
        end if;
        --
      end if;
      if :new.doc_status_code in ('UEX','OLG','TP','ND','NM','CA','WC','EX') then
        insert into xhants_pem_auto_close values (:new.doc_id);
      end if;
    end if;
end;