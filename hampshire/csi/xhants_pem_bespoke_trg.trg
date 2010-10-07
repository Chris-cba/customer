create or replace trigger xhants_pem_bespoke_trg 
before update 
on     docs
for    each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_pem_bespoke_trg.trg-arc   1.1   Oct 07 2010 21:38:44   ian.turnbull  $
--       Module Name      : $Workfile:   xhants_pem_bespoke_trg.trg  $
--       Date into PVCS   : $Date:   Oct 07 2010 21:38:44  $
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
  if new.doc_dtp_code = 'HDEF' and new.doc_status_code = 'AK' and new.doc_compl_ack_date is null then
    new.doc_compl_ack_date = sysdate;
  end if;
end;