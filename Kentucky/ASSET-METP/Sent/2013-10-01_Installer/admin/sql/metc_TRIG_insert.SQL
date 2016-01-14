Create or replace trigger EXOR.XKYTC_INV_TYPES_METC_trg_bi
before insert
ON EXOR.NM_INV_TYPE_ATTRIBS_all
for each row
WHEN (
(new.ITA_INV_TYPE not in('METP', 'METC'))
      )
Declare
	--invrec nm_inv_-tems_all%rowtype;
	i integer := xKYTC_META_Insert.newRows.count + 1 ;

begin
	
	xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'METC';
	xKYTC_META_Insert.NewRows(i).iit_start_date		:= trunc(sysdate);
	xKYTC_META_Insert.NewRows(i).iit_date_created	:= trunc(sysdate);
	xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :new.ITA_INV_TYPE;
	xKYTC_META_Insert.NewRows(i).iit_chr_attrib27	:= :new.ITA_SCRN_TEXT;

end;
/


/*
CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METC_trg_ai
after insert 
ON EXOR.NM_INV_TYPE_ATTRIBS_all
declare
  now date  :=sysdate;
  ok_to_end boolean:=false;

begin

	
		for i in 1..xKYTC_META_Insert.newRows.count
		loop
			if xKYTC_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26) <> 0 then 
			insert into nm_inv_items 
            (IIT_NE_ID,
            IIT_PRIMARY_KEY,
            iit_inv_type, 
            iit_start_date, 
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
				,xKYTC_META_Insert.NewRows(i).iit_inv_type	
				,xKYTC_META_Insert.NewRows(i).iit_start_date	
				,xKYTC_META_Insert.NewRows(i).iit_date_created
				, substr('METC Information for ' || xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 ||'-'||xKYTC_META_Insert.NewRows(i).iit_chr_attrib27,1,40)
				,xKYTC_META_Insert.NewRows(i).iit_chr_attrib26
				,xKYTC_META_Insert.NewRows(i).iit_chr_attrib27
				,xKYTC_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26)
				--,17793243
				, (select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
			from dual;
			end if;
		end loop;


end;
/
*/

CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METC_trg_ai
after insert 
ON EXOR.NM_INV_TYPE_ATTRIBS_all

declare
	  now date  :=sysdate;
  ok_to_end boolean:=false;
	p_invrow nm_inv_items%ROWTYPE;
	n_nau number;
begin

	select NAU_ADMIN_UNIT into n_nau from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE';
	

			for i in 1..xKYTC_META_Insert.newRows.count
		loop

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
	end loop;
	--commit;
end;
/