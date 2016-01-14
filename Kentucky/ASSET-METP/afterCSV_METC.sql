declare
	cursor c1 is select * from nm_inv_type_attribs where 1=1 AND ita_INV_TYPE ||ITA_ATTRIB_NAME not in (select iit_chr_attrib26 || iit_chr_attrib27 from nm_inv_items where iit_inv_type = 'METC');
	p_invrow nm_inv_items%ROWTYPE;
	n_nau number;
begin

	select NAU_ADMIN_UNIT into n_nau from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE';
	for rec_att in c1
	loop
	
	/*
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
				,trunc(sysdate)
				,trunc(sysdate)
				, substr('METP Information for ' || rec_att.nit_inv_type ||'-'||rec_att.nit_descr, 1,40)
				,rec_att.nit_inv_type
				,rec_att.nit_descr
				--,xKTKY_METP_fk(rec_att.iit_chr_attrib26)
				--,17793243
				,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
			from dual;
			
			*/
			if xKYTC_METP_fk(rec_att.ita_inv_type) <> 0 then 
				p_invrow.iit_NE_ID := NM3SEQ.NEXT_NE_ID_SEQ;
				p_invrow.iit_PRIMARY_KEY := NM3SEQ.CURR_NE_ID_SEQ;
				p_invrow.iit_inv_type := 'METC' ;
				p_invrow.iit_start_date := trunc(sysdate);
				p_invrow.iit_date_created := trunc(sysdate);
				p_invrow.iit_descr := substr('METC Infor for ' || rec_att.ita_inv_type ||'-'||rec_att.ita_attrib_name, 1,40);
				p_invrow.iit_chr_attrib26 := rec_att.ita_inv_type;
				p_invrow.iit_chr_attrib27 := rec_att.ita_attrib_name;
				p_invrow.iit_FOREIGN_KEY := xKYTC_METP_fk(rec_att.ita_inv_type);
				p_invrow.iit_ADMIN_UNIT := n_nau;
				
				nm3inv.insert_nm_inv_items(p_invrow);
			end if;
	end loop;
	commit;
end;
/