/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.11.04, JMM
*/

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XAA_SPATIAL_AUDIT';
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from user_objects where object_name = name_array(i) and object_type = 'TABLE';
		if i_count = 1 then
			execute immediate 'drop table ' || name_array(i);
		end if;
	select count(*) into i_count from user_objects where object_name = name_array(i) and object_type = 'VIEW';
		if i_count = 1 then
			execute immediate 'drop view ' || name_array(i);	
		end if;
   END LOOP;
END;
/
----------------------------------------------------
create table XAA_SPATIAL_AUDIT
(
	ROUTE_ID	Number(38)
	,GEOLOC		MDSYS.SDO_GEOMETRY
	,OPERATION	VARCHAR2(6)
	,OP_DATE		Date
	,EFF_DATE	Date
	,END_DATE	Date
);

create or replace public SYNONYM XAA_SPATIAL_AUDIT for exor.XAA_SPATIAL_AUDIT;