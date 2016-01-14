/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.11.15, JMM
*/

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'xaa_length_change';
   name_array(2) := 'xaa_leng_change_seq';
 
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
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'SEQUENCE';
		if i_count = 1 then
			execute immediate 'drop sequence ' || name_array(i);	
		end if;
   END LOOP;
END;
/
----------------------------------------------------
create table xaa_length_change
(
	CHANGE_ID 					number(9)		not null
	,REPORT_RUN_DATE			date
	,CHANGE_DATE 				date
	,EFFECTIVE_DATE				date
	,DATUM_ID 					number(9)
	,DATUM_UNIQUE 				varchar2(30)
	,DATUM_LENGTH				number
	,DATUM_TYPE 				varchar2(15)
	,OPERATION 					varchar2(25)
	,OLD_BEGIN_MEASURE			number
	,OLD_END_MEASURE			number
	,NEW_BEGIN_MEASURE 			number
	,NEW_END_MEASURE			number
	,CHANGE_START_MEASURE		number
	,CHANGE_END_MEASURE			number
	,MILEAGE_CHANGE				number
	,ROUTE_ID 					number(9)
	,ROUTE_UNIQUE 				varchar2(30)
	,ROUTE_NAME					varchar2(240)	
	, CONSTRAINT xaa_lc_change_id_uk unique(change_id)
);


CREATE SEQUENCE xaa_leng_change_seq
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 0
  NOCYCLE
  NOCACHE
  NOORDER;


CREATE OR REPLACE PUBLIC SYNONYM xaa_leng_change_seq FOR EXOR.xaa_leng_change_seq;