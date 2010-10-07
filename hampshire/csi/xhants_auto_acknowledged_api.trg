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
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_auto_acknowledged_api.trg-arc   1.1   Oct 07 2010 21:38:42   ian.turnbull  $
--       Module Name      : $Workfile:   xhants_auto_acknowledged_api.trg  $
--       Date into PVCS   : $Date:   Oct 07 2010 21:38:42  $
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
  if :new.doc_compl_source in ('E','P','T','F','S','L','W') and :old.doc_compl_source = 'U' and :new.doc_dtp_code = 'HDEF'
    and :NEW.doc_file = 'PEM_API' then
    insert into xhants_pem_auto_ack values (:new.doc_id);
    --insert into al_debug values (:new.doc_id,:new.doc_id);
  end if;
end;