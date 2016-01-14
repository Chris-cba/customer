/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2014.03.25, JMM
*/

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'XBCC_SAP_SYNC_TB';
   name_array(2) := 'XBCC_SAP_SYNC_RESULTS';
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

create  table XBCC_SAP_SYNC_TB
(
	RUN_DATE		date
,	i_start_date	date
,	i_end_date		date
,	i_brams_id		number
,	o_INDICATOR 	varchar2(1)
,	o_BRAMS_ID		number(10)
,	o_OBJECT		varchar2(30)
,	o_NAME			varchar2(30)
,	o_START			number(18,2)
,	o_END			number(18,2)
)
;

create or replace view XBCC_SAP_SYNC_RESULTS as

select
	o_INDICATOR 	"INDICATOR"
,	o_BRAMS_ID		"BRAMS_ID"
,	o_OBJECT		"OBJECT"
,	o_NAME			"NAME"
,	o_START			"START"
,	o_END			"END"
from XBCC_SAP_SYNC_TB
where run_date = (select max(run_date) from XBCC_SAP_SYNC_TB)
;