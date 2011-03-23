CREATE OR REPLACE TRIGGER xhants_dec_post_stm_trg
AFTER INSERT
ON doc_enquiry_contacts
begin
  if xhants_dec_bespoke.tab_dec.COUNT>0 then
     xhants_dec_bespoke.process_dec;
     xhants_dec_bespoke.clear_dec;
  end if;
end xhants_dec_post_stm_trg;
/ 
