DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XBCC_EQUIP_ATTR_VIEWS';
   name_array(2) := 'XBCC_CONTEXT_DATES';
   name_array(3) := 'XBCC_EQUIP_ATTR_VIEWS_TT';
   name_array(4) := 'XBCC_EAV_INPUT';
   name_array(5) := 'XBCC_EQUIP_ATTR_VIEWS_ESUR';
   name_array(6) := 'XBCC_INV_ITEMS_BT';
   name_array(7) := 'XBCC_MEMBERS_BT';
   
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
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

