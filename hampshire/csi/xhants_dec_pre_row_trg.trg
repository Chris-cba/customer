CREATE OR REPLACE TRIGGER xhants_dec_pre_row_trg
BEFORE INSERT
ON doc_enquiry_contacts
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

begin
 if :new.dec_type = 'ENQUIRER' then
  xhants_dec_bespoke.tab_dec(xhants_dec_bespoke.tab_dec.count+1):=(:NEW.dec_hct_id);
 end if;
END xhants_dec_pre_row_trg;
/

