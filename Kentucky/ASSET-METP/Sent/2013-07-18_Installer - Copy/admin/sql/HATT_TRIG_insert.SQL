Create or replace trigger EXOR.XKYTC_INV_TYPES_hatt_trg_bi
before insert
ON EXOR.NM_INV_TYPE_ATTRIBS_all
for each row
WHEN (
(new.ITA_INV_TYPE not in('HATH', 'HATT'))
      )
Declare
	--invrec nm_inv_-tems_all%rowtype;
	i integer := xKYTC_META_Insert.newRows.count + 1 ;

begin
	
	xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'HATT';
	xKYTC_META_Insert.NewRows(i).iit_start_date		:= trunc(sysdate);
	xKYTC_META_Insert.NewRows(i).iit_date_created	:= trunc(sysdate);
	xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :new.ITA_INV_TYPE;
	xKYTC_META_Insert.NewRows(i).iit_chr_attrib27	:= :new.ITA_SCRN_TEXT;

end;
/



CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_hatt_trg_ai
after insert 
ON EXOR.NM_INV_TYPE_ATTRIBS_all
declare
  now date  :=sysdate;
  ok_to_end boolean:=false;

begin

	
		for i in 1..xKYTC_META_Insert.newRows.count
		loop
			if xKYTC_hath_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26) <> 0 then 
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
				, substr('HATT Information for ' || xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 ||'-'||xKYTC_META_Insert.NewRows(i).iit_chr_attrib27,1,40)
				,xKYTC_META_Insert.NewRows(i).iit_chr_attrib26
				,xKYTC_META_Insert.NewRows(i).iit_chr_attrib27
				,xKTKY_hath_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26)
				--,17793243
				, (select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
			from dual;
			end if;
		end loop;


end;
/