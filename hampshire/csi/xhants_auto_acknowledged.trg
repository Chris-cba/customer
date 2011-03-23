create or replace trigger xhants_auto_acknowledged
after insert 
on     docs
for    each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_auto_acknowledged.trg-arc   1.2   Mar 23 2011 18:07:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   xhants_auto_acknowledged.trg  $
--       Date into PVCS   : $Date:   Mar 23 2011 18:07:50  $
--       Date fetched Out : $Modtime:   Mar 08 2011 11:50:24  $
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
--  if :new.doc_compl_source in ('E','P','T','F','S','L','W','EX','PX','TX','FX','SX','LX','WX') and :new.doc_dtp_code = 'HDEF' then
    if :new.doc_dtp_code = 'HDEF' then
    insert into xhants_pem_auto_ack values (:new.doc_id);
  end if;
end;