DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'xBCC_EAV_Input';
   name_array(2) := 'xBBB_EAV_Input';
     --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'TABLE';
		if i_count = 1 then
			execute immediate 'drop table ' || name_array(i);
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'VIEW';
		if i_count = 1 then
			execute immediate 'drop view ' || name_array(i);	
		end if;
   END LOOP;
END;
/
-----  Installing Table

Create table xBCC_EAV_Input
(
	Primary_View	Varchar2(30),
	--Secondary_View	Varchar2(30),
	BRAMS_Asset		VARCHAR(4),
	Network			Varchar2(4),
	XSP				Varchar2(100)
)
;


  
  --insert into xbcc_eav_input values ('ASOW_ROAD', 'ASOW','RDCO','XCS,XCE1,XCO1');