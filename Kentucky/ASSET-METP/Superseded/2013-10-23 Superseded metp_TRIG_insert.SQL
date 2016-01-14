Create or replace trigger EXOR.XKYTC_INV_TYPES_METP_trg_bi
before insert or update or delete
ON EXOR.NM_INV_TYPES_ALL
for each row
WHEN (
(new.NIT_INV_TYPE not in('METP', 'METC'))
      )
Declare
	--invrec nm_inv_-tems_all%rowtype;
	i integer := xKYTC_META_Insert.newRows.count + 1 ;

begin
	if DELETING then 
		xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'METP';
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :old.NIT_INV_TYPE;
	else
		xKYTC_META_Insert.NewRows(i).iit_inv_type		:= 'METP';
		xKYTC_META_Insert.NewRows(i).iit_start_date		:= :new.nit_start_date;
		xKYTC_META_Insert.NewRows(i).iit_date_created	:= :new.nit_date_created;
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib26	:= :new.NIT_INV_TYPE;
		xKYTC_META_Insert.NewRows(i).iit_chr_attrib27	:= :new.nit_descr;
	end if;
end;
/



CREATE OR REPLACE TRIGGER EXOR.XKYTC_INV_TYPES_METP_trg_ai
after insert or update or delete
ON EXOR.NM_INV_TYPES_ALL
declare
  now date  :=sysdate;
  ok_to_end boolean:=false;
  ncount  number;

begin

    
        for i in 1..xKYTC_META_Insert.newRows.count
        loop
            if inserting then
                select count(*) into ncount from nm_inv_items where iit_chr_attrib26 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib26;
                if ncount = 0 then
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
                        ,xKYTC_META_Insert.NewRows(i).iit_inv_type    
                        ,xKYTC_META_Insert.NewRows(i).iit_start_date    
                        ,xKYTC_META_Insert.NewRows(i).iit_date_created
                        , substr('METP Information for ' || xKYTC_META_Insert.NewRows(i).iit_chr_attrib26 ||'-'||xKYTC_META_Insert.NewRows(i).iit_chr_attrib27,1,40)
                        ,xKYTC_META_Insert.NewRows(i).iit_chr_attrib26
                        ,xKYTC_META_Insert.NewRows(i).iit_chr_attrib27
                        --,xKTKY_METP_fk(xKYTC_META_Insert.NewRows(i).iit_chr_attrib26)
                        --,17793243
                        ,(select NAU_ADMIN_UNIT from nm_admin_units where NAU_ADMIN_TYPE = 'INV' and NAU_UNIT_CODE = 'STATE') NAU
                    from dual;
                end if;
            elsif UPDATING then
                update nm_inv_items set iit_chr_attrib27 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib27 where iit_inv_type = 'METP' and iit_chr_attrib26 = xKYTC_META_Insert.NewRows(i).iit_chr_attrib26;
                null;
			elsif DELETING then
				delete from nm_inv_item_groupings_all where iig_item_id in (select iit_ne_id from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26);
				delete from nm_inv_items where iit_inv_type = 'METC' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26
				delete  from nm_inv_items where iit_inv_type = 'METP' and iit_chr_attrib26 =xKYTC_META_Insert.NewRows(i).iit_chr_attrib26;
            end if;
        end loop;


end;
/