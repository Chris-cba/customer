CREATE OR REPLACE TRIGGER XKYTC_INV_TYPES_METC_TRG_CMP
for insert or update
ON EXOR.NM_INV_TYPE_ATTRIBS_all
WHEN (
(new.ITA_INV_TYPE not in('METP', 'METC'))
      )
COMPOUND TRIGGER

    type invrec_t is table of nm_inv_items_all%rowtype index by simple_integer;
	invrec invrec_t;
	p_invrow nm_inv_items%ROWTYPE;
	i integer := 0 ;
	ncount integer := -1;
	n_nau number;
	n_ne_id number;

	
	before each row is
		begin
			If inserting then
				i := i +1;
				invrec(i).iit_inv_type		:= 'INS';   --using to knwo what to do in the after statement
				invrec(i).iit_start_date	:= :new.ita_start_date;
				invrec(i).iit_date_created	:= :new.ita_date_created;
				invrec(i).iit_end_date		:= :new.ita_end_date;
				invrec(i).iit_chr_attrib26	:= :new.ITA_INV_TYPE;
				invrec(i).iit_chr_attrib27	:= :new.ITA_SCRN_TEXT;
			elsif updating then
				i := i +1;
				invrec(i).iit_inv_type		:= 'UP';
				invrec(i).iit_start_date	:= :new.ita_start_date;
				invrec(i).iit_date_created	:= :new.ita_date_created;
				invrec(i).iit_end_date		:= :new.ita_end_date;
				invrec(i).iit_chr_attrib26	:= :new.ITA_INV_TYPE;
				invrec(i).iit_chr_attrib27	:= :new.ITA_SCRN_TEXT;		
					end if;
		end before each row;
	
	After statement is
	
	begin
		select NAU_ADMIN_UNIT into n_nau from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE';
		for j in 1..invrec.count loop
			if invrec(j).iit_inv_type = 'INS' then
				if xKYTC_METP_fk(invrec(j).iit_chr_attrib26) <> 0 then 
					SELECT NM3SEQ.NEXT_NE_ID_SEQ INTO n_ne_id from dual;
					/*
					p_invrow.iit_NE_ID := n_ne_id;
					p_invrow.iit_PRIMARY_KEY := n_ne_id;
					p_invrow.iit_inv_type := 'METC';
					p_invrow.iit_start_date := invrec(j).iit_start_date;
					p_invrow.iit_start_date := invrec(j).iit_end_date;
					p_invrow.iit_date_created := invrec(j).iit_date_created;
					p_invrow.iit_descr := substr('METC Information for ' || invrec(j).iit_chr_attrib26 ||'-'||invrec(j).iit_chr_attrib27, 1,40);
					p_invrow.iit_chr_attrib26 := invrec(j).iit_chr_attrib26;
			7		p_invrow.iit_chr_attrib27 := invrec(j).iit_chr_attrib27;
					p_invrow.iit_FOREIGN_KEY := xKYTC_METP_fk(invrec(j).iit_chr_attrib26);
					p_invrow.iit_ADMIN_UNIT := n_nau;
					
					nm3inv.insert_nm_inv_items(p_invrow);
					*/
					insert into xnm_inv_items_all
						(IIT_NE_ID,
						IIT_PRIMARY_KEY,
						iit_inv_type, 
						iit_start_date, 
						iit_end_date,
						iit_date_created,
						iit_descr,
						iit_chr_attrib26,
						iit_chr_attrib27,
						IIT_FOREIGN_KEY,
						IIT_ADMIN_UNIT            
						)
						select
						NM3SEQ.NEXT_NE_ID_SEQ
							,NM3SEQ.CURR_NE_ID_SEQ
							,'METC' 	--invrec(j).iit_inv_type    
							,invrec(j).iit_start_date    
							,invrec(j).iit_end_date  
							,invrec(j).iit_date_created							
							, substr('METC Info: ' || invrec(j).iit_chr_attrib26 ||'-'||invrec(j).iit_chr_attrib27, 1,40)
							,invrec(j).iit_chr_attrib26
							,invrec(j).iit_chr_attrib27
							,xKYTC_METP_fk(invrec(j).iit_chr_attrib26)
							--,17793243
							,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
						from dual;
					
				end if; 
			elsif invrec(j).iit_inv_type = 'UP' then
			null;
					select count(*)  into ncount from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =invrec(j).iit_chr_attrib26 and iit_chr_attrib27 =invrec(j).iit_chr_attrib27;
					if ncount =0 then
						null;
					else
						select iit_ne_id into n_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =invrec(j).iit_chr_attrib26 and iit_chr_attrib27 =invrec(j).iit_chr_attrib27;
						
						insert into xnm_inv_items_all
							(IIT_NE_ID,
							IIT_PRIMARY_KEY,
							iit_inv_type, 
							iit_start_date, 
							iit_end_date,
							iit_date_created,
							iit_descr,
							iit_chr_attrib26,
							iit_chr_attrib27,
							IIT_FOREIGN_KEY,
							IIT_ADMIN_UNIT            
							)
							select
							n_ne_id
								,n_ne_id
								,'METC' 	--invrec(j).iit_inv_type    
								,invrec(j).iit_start_date    
								,invrec(j).iit_end_date  
								,invrec(j).iit_date_created							
								, substr('METC Info: ' || invrec(j).iit_chr_attrib26 ||'-'||invrec(j).iit_chr_attrib27, 1,40)
								,invrec(j).iit_chr_attrib26
								,invrec(j).iit_chr_attrib27
								,xKYTC_METP_fk(invrec(j).iit_chr_attrib26)
								--,17793243
								,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
							from dual;
					end if;
			end if;
		end loop;    
	end after statement;
	
end XKYTC_INV_TYPES_METC_TRG_CMP;
/