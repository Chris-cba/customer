CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METP_trg_tst
after insert or update or delete
ON EXOR.NM_INV_TYPES_ALL
for each row
declare
	PRAGMA AUTONOMOUS_TRANSACTION;

begin

    

            if inserting then
                
                if 0 = 0 then
                    insert into nm_inv_items 
                    (IIT_NE_ID,
                    IIT_PRIMARY_KEY,
                    iit_inv_type, 
                    iit_start_date, 
                    iit_date_created,
                    iit_descr,
                    iit_chr_attrib26,
                    iit_chr_attrib27,
                    --IIT_FOREIGN_KEY,
                    IIT_ADMIN_UNIT            
                    )
                    select
                    NM3SEQ.NEXT_NE_ID_SEQ
                        ,NM3SEQ.CURR_NE_ID_SEQ
                        ,'METP'    
                        ,:new.nit_start_date    
                        ,:new.nit_start_date
                        , substr('METP Information for ' ||:new.NIT_INV_TYPE ||'-'||:new.nit_descr,1,40)
                        ,:new.NIT_INV_TYPE
                        ,:new.nit_descr
                        --,xKTKY_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26)
                        --,17793243
                        ,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
                    from dual;
					
					commit;
                end if;
         
		   elsif UPDATING then
                update nm_inv_items_all set iit_chr_attrib27 = :new.nit_descr, IIT_end_date = :new.nit_end_date where iit_inv_type = 'METP' and iit_chr_attrib26 = :new.NIT_INV_TYPE;
                null;
				commit;
			/*
			elsif DELETING then
				delete from nm_inv_item_groupings_all where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26);
				delete from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26
				delete  from nm_inv_items where iit_inv_type = 'METP' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26;
            */
			end if;
			
        


end;
/