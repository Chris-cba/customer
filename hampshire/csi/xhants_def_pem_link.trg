create or replace trigger xhants_def_pem_link
after insert 
on doc_assocs
for each row
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/csi/xhants_def_pem_link.trg-arc   1.1   Oct 07 2010 21:38:42   ian.turnbull  $
--       Module Name      : $Workfile:   xhants_def_pem_link.trg  $
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
  if :new.DAS_TABLE_NAME = 'DEFECTS' then
    xhants_pem_bespoke.set_via_linked_defect(:new.das_rec_id,:new.das_doc_id);
  end if;
end;