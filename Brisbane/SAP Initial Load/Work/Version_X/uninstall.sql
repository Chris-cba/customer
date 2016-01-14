DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XBEX_SUBURB_EQUIP_RDCO';
   name_array(2) := 'XBEX_SUBURB_EQUIP_MED';
   name_array(3) := 'XBEX_SUBURB_EQUIP_KCOR';
   name_array(4) := 'XBEX_SUBURB_EQUIP_VECO';
   name_array(5) := 'xBCC_EAV_Input';
   name_array(6) := 'XBEX_EQUIP_RDCO';
   name_array(7) := 'XBEX_EQUIP_MED';
   name_array(8) := 'XBEX_EQUIP_VECO';   
   name_array(9) := 'XBEX_EQUIP_KCOR';
   name_array(10) := 'XBCC_EQUIP_ATTR_VIEWS_ESUR';
   name_array(10) := 'xBCC_Equip_Attr_Views';
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
   	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'MATERIALIZED VIEW';
		if i_count = 1 then
			execute immediate 'drop MATERIALIZED VIEW ' || name_array(i);	
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'TABLE';
		if i_count = 1 then
			execute immediate 'drop table ' || name_array(i) || ' CASCADE CONSTRAINTS';
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'VIEW';
		if i_count = 1 then
			execute immediate 'drop view ' || name_array(i);	
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type like 'PACKAGE%';
		if i_count = 1 then
			execute immediate 'drop package body ' || name_array(i);	
			execute immediate 'drop package  ' || name_array(i);	
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'INDEX';
		if i_count = 1 then
			execute immediate 'drop index ' || name_array(i);	
		end if;	
   END LOOP;
END;
/

