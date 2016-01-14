CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METP_trg
after update or delete 
ON EXOR.NM_INV_TYPES_ALL
for each row
WHEN (
(new.NIT_INV_TYPE not in('METP', 'METC'))
      )
declare
    p_temp  number;
begin
    
    IF INSERTING THEN
		null;
    ELSIF UPDATING then
        update nm_inv_items set iit_chr_attrib27 = :new.nit_descr where iit_inv_type = 'METP' and iit_chr_attrib26 = :new.NIT_INV_TYPE;
        
        null;
    ELSE
        update nm_inv_items set iit_end_date = trunc(sysdate) where iit_inv_type = 'METP' and iit_chr_attrib26 = :new.NIT_INV_TYPE;
        null;
    end if;

end;
/