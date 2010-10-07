create or replace trigger xhants_auto_acknowledged_api
after update 
on     docs
for    each row
--
declare
--
begin
  if :new.doc_compl_source in ('E','P','T','F','S','L','W') and :old.doc_compl_source = 'U' and :new.doc_dtp_code = 'HDEF'
    and :NEW.doc_file = 'PEM_API' then
    insert into xhants_pem_auto_ack values (:new.doc_id);
    --insert into al_debug values (:new.doc_id,:new.doc_id);
  end if;
end;