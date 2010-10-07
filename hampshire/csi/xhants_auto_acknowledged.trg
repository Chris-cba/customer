create or replace trigger xhants_auto_acknowledged
after insert 
on     docs
for    each row
--
declare
--
begin
  if :new.doc_compl_source in ('E','P','T','F','S','L','W','EX','PX','TX','FX','SX','LX','WX') and :new.doc_dtp_code = 'HDEF' then
    insert into xhants_pem_auto_ack values (:new.doc_id);
  end if;
end;