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

create GLOBAL TEMPORARY TABLE XBCC_CORR_LIST (
	NE_ID 				number(9)
	, start_date 		date
	, end_date			date
	, mod_date			date
	, Indicator			varchar(1)
	);

create GLOBAL TEMPORARY TABLE XBCC_CORR_SEG_LIST (
	CORR_NE_ID number(9)
	, NE_ID						number(9)
	, start_date            	date
	, end_date              	date
	, mod_date              	date
	, create_date				date
	, Indicator             	varchar(1)
	);
	
create GLOBAL TEMPORARY TABLE XBCC_INV_IN_LIST(
	NE_ID_IN				number(9)
	)
	;
		
create GLOBAL TEMPORARY TABLE XBCC_INV_LIST (
	 CORR_NE_ID				number(9)
	, IIT_ID				number(9)
	, start_date        	date
	, end_date          	date
	, mod_date          	date
	, create_date				date
	, Indicator         	varchar(1)
);

create GLOBAL TEMPORARY TABLE XBCC_GROUP_LIST (
	 CORR_NE_ID				number(9)
	, IIT_ID				number(9)
	, start_date        	date
	, end_date          	date
	, mod_date          	date
	, create_date				date
	, Indicator         	varchar(1)
);

create GLOBAL TEMPORARY TABLE XBCC_SAP_SYNC_OUTPUT
(
  sorter	 number(1),
  INDICATOR  VARCHAR2(1 BYTE),
  BRAMS_ID   NUMBER(12),   			-- needed for medians
  OBJECT     VARCHAR2(30 BYTE),
  NAME       VARCHAR2(30 BYTE),
  "START"    NUMBER(18,2),
  END        NUMBER(18,2)
);