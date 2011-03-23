CREATE OR REPLACE TRIGGER xhants_wo_hold
after insert 
on     doc_assocs
for    each row
--
declare
--
begin
  if :new.das_table_name = 'WORK_ORDERS' then
    xhants_pem_bespoke.mail_held_wo (:new.das_doc_id,:new.das_rec_id);
  end if;
end;
/
