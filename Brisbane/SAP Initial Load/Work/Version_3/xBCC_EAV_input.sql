/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: xBCC_EAV_input.sql
	Author: JMM
	UPDATE01:	Original, 2014.04.28, JMM
*/

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
	Primary_View	Varchar2(26),
	--Secondary_View	Varchar2(30),
	BRAMS_Asset		VARCHAR(4),
	Network			Varchar2(4),
	XSP				Varchar2(100),
	Last_complete	date
)
;


  
  --insert into xbcc_eav_input values ('ASOW_ROAD', 'ASOW','RDCO','XCS,XCE1,XCO1');