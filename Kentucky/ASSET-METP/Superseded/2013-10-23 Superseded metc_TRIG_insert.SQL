Create or replace trigger EXOR.XKYTC_INV_TYPES_METC_trg_bi
before insert or update or delete
ON EXOR.NM_INV_TYPE_ATTRIBS_all
for each row
WHEN (
(new.ITA_INV_TYPE not in('METP', 'METC'))
      )
Declare
	--invrec nm_inv_-tems_all%rowtype;
	i integer := xKYTC_META_Insert.newRows.count + 1 ;

begin
	if deleting then
		xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'METC';
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :old.ITA_INV_TYPE;
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib27	:= :old.ITA_SCRN_TEXT;
	else
		xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'METC';
		xKYTC_META_Insert.NewRows(i).iit_start_date		:= :new.ita_start_date;
		xKYTC_META_Insert.NewRows(i).iit_date_created	:= :new.ita_date_created;
		xKYTC_META_Insert.NewRows(i).iit_end_date		:= :new.ita_end_date;
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :new.ITA_INV_TYPE;
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib27	:= :new.ITA_SCRN_TEXT;
	end if;

end;
/




CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METC_trg_ai
after insert  or update or delete
ON EXOR.NM_INV_TYPE_ATTRIBS_all

declare
	  now date  :=sysdate;
  ok_to_end boolean:=false;
	p_invrow nm_inv_items%ROWTYPE;
	n_nau number;
	n_count number;
begin

	select NAU_ADMIN_UNIT into n_nau from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE';
	

	for i in 1..xKYTC_META_Insert.newRows.count			
	loop
		if INSERTING then
			select count(*) into n_count from nm_inv_items where iit_inv_type = xKYTC_META_Insert.NewRows(i).iit_inv_type and iit_chr_attrib26 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 and iit_chr_attrib27 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib27;
				if n_count = 0 then
					if xKYTC_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26) <> 0 then 
						p_invrow.iit_NE_ID := NM3SEQ.NEXT_NE_ID_SEQ;
						p_invrow.iit_PRIMARY_KEY := NM3SEQ.CURR_NE_ID_SEQ;
						p_invrow.iit_inv_type := xKYTC_META_Insert.NewRows(i).iit_inv_type ;
						p_invrow.iit_start_date := xKYTC_META_Insert.NewRows(i).iit_start_date;
						p_invrow.iit_date_created := xKYTC_META_Insert.NewRows(i).iit_date_created;
						p_invrow.iit_descr := substr('METC Information for ' || xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 ||'-'||xKYTC_META_Insert.NewRows(i).iit_chr_attrib27, 1,40);
						p_invrow.iit_chr_attrib26 := xKYTC_META_Insert.NewRows(i).iit_chr_attrib26;
						p_invrow.iit_chr_attrib27 := xKYTC_META_Insert.NewRows(i).iit_chr_attrib27;
						p_invrow.iit_FOREIGN_KEY := xKYTC_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26);
						p_invrow.iit_ADMIN_UNIT := n_nau;
						
						nm3inv.insert_nm_inv_items(p_invrow);
					end if;
				end if;
		elsif deleting then
			--insert into xtest_jmm  (select 'test2' from dual);
			delete from nm_inv_item_groupings_all where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 and iit_chr_attrib27 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib27);
			delete from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 and iit_chr_attrib27 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib27;
		elsif updating then
			update nm_inv_item_groupings_all set iig_end_date = xKYTC_META_Insert.NewRows(i).iit_end_date where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 and iit_chr_attrib27 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib27);
			
			update nm_inv_items
				set iit_chr_attrib27 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib27
					,iit_end_date = xKYTC_META_Insert.NewRows(i).iit_end_date
				where
					iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 and iit_chr_attrib27 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib27;
			
			
		end if;
	end loop;
	--commit;
end;
/