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
   name_array(1) := 'XAA_LOC_IDENT';
   name_array(2) := 'XAA_NET_REF';
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
create table XAA_LOC_IDENT
(
	HISTORIC_DATE		Date			not null
	,LOC_IDENT			INTEGER			not null
	,ROUTE_NAME			VARCHAR2 (30)	not null
	,OFFSET_FROM		NUMBER (22,4)	not null
	,OFFSET_TO			NUMBER (22,4)	not null
	,SOURCE_TABLE		VARCHAR2 (32)	not null
	,NEW_DATE			DATE
	,NEW_ROUTE_NAME		VARCHAR2 (30)
	,NEW_OFFSET_FROM	NUMBER (22,4)
	,NEW_OFFSET_TO		NUMBER (22,4)
	,PROCESS_MSG		VARCHAR(100)
	);

	create table XAA_NET_REF
(
	HISTORIC_DATE		Date			not null
	,LOC_IDENT			INTEGER			not null
	,ROUTE_NAME			VARCHAR2 (30)	not null
	,OFFSET_FROM		NUMBER (22,4)	not null
	,OFFSET_TO			NUMBER (22,4)	not null
	,SOURCE_TABLE		VARCHAR2 (32)	not null
	,NEW_DATE			Date
	,NEW_ROUTE_NAME		VARCHAR2 (30)
	,NEW_OFFSET_FROM	NUMBER (22,4)
	,NEW_OFFSET_TO		NUMBER (22,4)
	,PROCESS_MSG		VARCHAR(100)
	);