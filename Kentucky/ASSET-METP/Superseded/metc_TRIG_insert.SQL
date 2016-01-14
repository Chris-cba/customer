CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METC_trg_tst
after insert  or update or delete
ON EXOR.NM_INV_TYPE_ATTRIBS_all
for each row
declare
	PRAGMA AUTONOMOUS_TRANSACTION;
	
	p_invrow nm_inv_items%ROWTYPE;
	n_nau number;
	n_count number;
begin

	select NAU_ADMIN_UNIT into n_nau from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE';


	
	
		if INSERTING then
			select count(*) into n_count from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 = :new.ITA_INV_TYPE and iit_chr_attrib27 = :new.ITA_SCRN_TEXT;
				if n_count = 0 then
					if xKYTC_METP_fk(:new.ITA_INV_TYPE) <> 0 then 
						p_invrow.iit_NE_ID := NM3SEQ.NEXT_NE_ID_SEQ;
						p_invrow.iit_PRIMARY_KEY := NM3SEQ.CURR_NE_ID_SEQ;
						p_invrow.iit_inv_type := 'METC';
						p_invrow.iit_start_date := :new.ita_start_date;
						--p_invrow.iit_end_date := :new.ita_end_date;
						p_invrow.iit_date_created := :new.ita_date_created;
						p_invrow.iit_descr := substr('METC Information for ' || :new.ITA_INV_TYPE ||'-'|| :new.ita_attrib_name, 1,40);
						p_invrow.iit_chr_attrib26 := :new.ITA_INV_TYPE;
						p_invrow.iit_chr_attrib27 := :new.ita_attrib_name;
						p_invrow.iit_FOREIGN_KEY := xKYTC_METP_fk(:new.ITA_INV_TYPE);
						p_invrow.iit_ADMIN_UNIT := n_nau;
						
						nm3inv.insert_nm_inv_items(p_invrow);
						
						commit;
					end if;
				end if;
		elsif deleting then
			--insert into xtest_jmm  (select 'test2' from dual);
			delete from nm_inv_item_groupings_all where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =:new.ITA_INV_TYPE and iit_chr_attrib27 =:new.ITA_SCRN_TEXT);
			delete from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =:new.ITA_INV_TYPE and iit_chr_attrib27 =:new.ita_attrib_name;
		elsif updating then
			update nm_inv_item_groupings_all set iig_end_date = :new.ita_end_date where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =:new.ITA_INV_TYPE and iit_chr_attrib27 =:new.ita_attrib_name);
			
			update nm_inv_items_all
				set iit_end_date = :new.ita_end_date
				where
					iit_inv_type = 'METC' and iit_chr_attrib26 =:new.ITA_INV_TYPE and iit_chr_attrib27 =:new.ita_attrib_name;
			commit;
			
		end if;
	
	--commit;
end;
/