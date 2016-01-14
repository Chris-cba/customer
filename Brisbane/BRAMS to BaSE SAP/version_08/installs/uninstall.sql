DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XBCC_CORR_LIST';
   name_array(2) := 'XBCC_INV_LIST';
   name_array(3) := 'XBCC_CORR_SEG_LIST';
   name_array(4) := 'XBCC_SAP_SYNC_SAMPLE';
   name_array(5) := 'XBCC_SAP_SYNC_OUTPUT';
   name_array(6) := 'XBCC_INV_IN_LIST';
   name_array(7) := 'XBCC_GROUP_LIST';
   name_array(8) := 'XBCC_IDX_NM_DATE_MODIFIED';   
   name_array(9) := 'XBCC_IDX_NE_DATE_MODIFIED';
   name_array(10) := 'XBCC_IDX_IIT_DATE_MODIFIED';
   name_array(11) := 'XBCC_SAP_SYNC';
   name_array(12) := 'XBCC_SAP_SYNC_TB';
   name_array(13) := 'XBCC_SAP_SYNC_RESULTS';
   name_array(14) := 'XBCC_IDX_NE_ID_IN_CHR';
   name_array(15) := 'XBCC_IDX_NM_DATE_MODIFIED';
   name_array(16) := 'XBCC_IDX_NM_DATE_MOD_ID_OF';
   
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

