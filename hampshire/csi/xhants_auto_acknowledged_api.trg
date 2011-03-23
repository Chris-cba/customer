create or replace trigger xhants_auto_acknowledged_api
after update 
on     docs
for    each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_auto_acknowledged_api.trg-arc   1.2   Mar 23 2011 18:07:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   xhants_auto_acknowledged_api.trg  $
--       Date into PVCS   : $Date:   Mar 23 2011 18:07:50  $
--       Date fetched Out : $Modtime:   Mar 08 2011 11:46:46  $
--       PVCS Version     : $Revision:   1.2  $
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
-- Trigger changed as part of CSI changes #8 BRS 3547
--  if :new.doc_compl_source in ('E','P','T','F','S','L','W') and :old.doc_compl_source = 'U' and :new.doc_dtp_code = 'HDEF'
    if :new.doc_dtp_code = 'HDEF' and :old.doc_compl_source = 'U'
    and :NEW.doc_file = 'PEM_API' then
    insert into xhants_pem_auto_ack values (:new.doc_id);
    --insert into al_debug values (:new.doc_id,:new.doc_id);
  end if;
end;