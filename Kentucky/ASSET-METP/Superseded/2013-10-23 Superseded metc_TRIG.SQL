CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METC_trg
after  update or delete 
ON EXOR.NM_INV_TYPE_ATTRIBS_all
for each row
WHEN (
(new.ITA_INV_TYPE not in('METP', 'METC'))
      )
begin

    
    IF UPDATING then
        update nm_inv_items set iit_chr_attrib27 = :new.ITA_SCRN_TEXT where iit_inv_type = 'METC' and iit_chr_attrib26 = :new.ITA_INV_TYPE;
        
        null;
    ELSE
        update nm_inv_items set iit_end_date = trunc(sysdate) where iit_inv_type = 'METC' and iit_chr_attrib26 = :new.ITA_INV_TYPE;
        null;
    end if;

end;
/