CREATE OR REPLACE TRIGGER XKYTC_INV_TYPES_METP_TRG_CMP
for insert or update
ON EXOR.NM_INV_TYPES_ALL
WHEN (
(new.NIT_INV_TYPE not in('METP', 'METC'))
      )
COMPOUND TRIGGER

    type invrec_t is table of nm_inv_items_all%rowtype index by simple_integer;
    invrec invrec_t;
	i integer := 0 ;
	ncount integer := -1;

	
	before each row is
		begin
			If inserting then
				i := i +1;
				invrec(i).iit_inv_type		:= 'INS';   --Used to track if Inserting or updating
				invrec(i).iit_start_date		:= :new.nit_start_date;
				invrec(i).iit_end_date		:= :new.nit_end_date;
				invrec(i).iit_date_created	:= :new.nit_date_created;
				invrec(i).iit_chr_attrib26	:= :new.NIT_INV_TYPE;
				invrec(i).iit_chr_attrib27	:= :new.nit_descr;	
			elsif updating then
				i := i +1;
				invrec(i).iit_inv_type		:= 'UP';   --Used to track if Inserting or updating
				invrec(i).iit_start_date		:= :new.nit_start_date;
				invrec(i).iit_end_date		:= :new.nit_end_date;
				invrec(i).iit_date_created	:= :new.nit_date_created;
				invrec(i).iit_chr_attrib26	:= :new.NIT_INV_TYPE;
				invrec(i).iit_chr_attrib27	:= :new.nit_descr;				
			end if;
		end before each row;
	
	After statement is

	begin
		for j in 1..invrec.count loop
			if invrec(j).iit_inv_type = 'INS' then
			 select count(*) into ncount from nm_inv_items where iit_chr_attrib26 = invrec(j).iit_chr_attrib26;
					if ncount = 0 then
						insert into nm_inv_items_all
						(IIT_NE_ID,
						IIT_PRIMARY_KEY,
						iit_inv_type, 
						iit_start_date, 
						iit_end_date,
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
							,'METP' 	--invrec(j).iit_inv_type    
							,invrec(j).iit_start_date    
							,invrec(j).iit_end_date  
							,invrec(j).iit_date_created							
							, substr('METP Information for ' || invrec(j).iit_chr_attrib26 ||'-'||invrec(j).iit_chr_attrib27,1,40)
							,invrec(j).iit_chr_attrib26
							,invrec(j).iit_chr_attrib27
							--,xKTKY_METP_fk(invrec(i).iit_chr_attrib26)
							--,17793243
							,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
						from dual;
					end if;  
			elsif invrec(j).iit_inv_type = 'UP' then
				update nm_inv_items_all set iit_chr_attrib27 = invrec(j).iit_chr_attrib27, IIT_end_date = invrec(j).iit_end_date where iit_inv_type = 'METP' and iit_chr_attrib26 = invrec(j).iit_chr_attrib26;
                null;		
			end if;
		end loop;    
	end after statement;
	
end XKYTC_INV_TYPES_METP_TRG_CMP;
/