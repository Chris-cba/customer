create or replace trigger xhants_def_pem_link
after insert 
on doc_assocs
for each row
--
declare
--
begin
  if :new.DAS_TABLE_NAME = 'DEFECTS' then
    xhants_pem_bespoke.set_via_linked_defect(:new.das_rec_id,:new.das_doc_id);
  end if;
end;