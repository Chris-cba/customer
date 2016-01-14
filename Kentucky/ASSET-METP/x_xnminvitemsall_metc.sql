create or replace trigger x_xnminvitemsall_metc
after insert 
on xnm_inv_items_all

FOR each row 

declare
n_count number;
p_invrow nm_inv_items_all%rowtype;
begin

select count(*) into n_count from nm_inv_items_all where iit_ne_id = :new.iit_ne_id;

if n_count = 0 then  -- adding this so it uses the API call to insert
	p_invrow.iit_NE_ID := :new.IIT_NE_ID;
	p_invrow.iit_PRIMARY_KEY := :new.IIT_PRIMARY_KEY;
	p_invrow.iit_inv_type := :new.IIT_INV_TYPE ;
	p_invrow.iit_start_date := :new.iit_start_date;
	p_invrow.iit_date_created := :new.iit_date_created;
	p_invrow.iit_descr :=  :new.IIT_DESCR;
	p_invrow.iit_chr_attrib26 := :new.iit_chr_attrib26;
	p_invrow.iit_chr_attrib27 := :new.iit_chr_attrib27;
	p_invrow.iit_FOREIGN_KEY := :new.IIT_FOREIGN_KEY;
	p_invrow.iit_ADMIN_UNIT := :new.IIT_ADMIN_UNIT;
	
	nm3inv.insert_nm_inv_items(p_invrow);
else

	MERGE INTO NM_INV_ITEMS_ALL A USING
	 (SELECT
	  :new.IIT_NE_ID as IIT_NE_ID,
	  :new.IIT_PRIMARY_KEY as IIT_PRIMARY_KEY,
	  :new.IIT_INV_TYPE as IIT_INV_TYPE,
	  :new.IIT_START_DATE as IIT_START_DATE,
	  :new.IIT_END_DATE as IIT_END_DATE,
	  :new.IIT_DATE_CREATED as IIT_DATE_CREATED,
	  :new.IIT_DESCR as IIT_DESCR,
	  :new.IIT_CHR_ATTRIB26 as IIT_CHR_ATTRIB26,
	  :new.IIT_CHR_ATTRIB27 as IIT_CHR_ATTRIB27,
	  :new.IIT_FOREIGN_KEY as IIT_FOREIGN_KEY,
	  :new.IIT_ADMIN_UNIT as IIT_ADMIN_UNIT
	  FROM DUAL) B
	ON (A.iit_ne_id = B.iit_ne_id)
	WHEN NOT MATCHED THEN 
	INSERT (
	  IIT_NE_ID, IIT_PRIMARY_KEY, IIT_INV_TYPE, IIT_START_DATE, IIT_END_DATE, 
	  IIT_DATE_CREATED, IIT_DESCR, IIT_CHR_ATTRIB26, IIT_CHR_ATTRIB27, IIT_FOREIGN_KEY, 
	  IIT_ADMIN_UNIT)
	VALUES (
	  B.IIT_NE_ID, B.IIT_PRIMARY_KEY, B.IIT_INV_TYPE, B.IIT_START_DATE, B.IIT_END_DATE, 
	  B.IIT_DATE_CREATED, B.IIT_DESCR, B.IIT_CHR_ATTRIB26, B.IIT_CHR_ATTRIB27, B.IIT_FOREIGN_KEY, 
	  B.IIT_ADMIN_UNIT)
	WHEN MATCHED THEN
	UPDATE SET 

	  A.IIT_END_DATE = B.IIT_END_DATE;
end if;
  

end x_xnminvitemsall_metc;
/