create or replace trigger xhants_pem_bespoke_trg 
before update 
on     docs
for    each row
--
declare
--
begin
  if new.doc_dtp_code = 'HDEF' and new.doc_status_code = 'AK' and new.doc_compl_ack_date is null then
    new.doc_compl_ack_date = sysdate;
  end if;
end;