/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: api_custom_types.sql
	Author: JMM
	UPDATE01:	Original, 2015.03.12, JMM
*/

/*
	Used for: Retrieving a task list count and passing it to the broker
*/
create or replace type xodot_signs_task_list_row as object (asset varchar2(4), cnt number);
create or replace type xodot_signs_task_list is table of xodot_signs_task_list_row;

/*
	Used for: passing insertion status back to the broker
*/
create or replace type xodot_signs_asset_op as object (ne_id number(10), err_num number, err_msg varchar2(500));

------------------------SYNONYM------------------------
------------------------SYNONYM------------------------
------------------------SYNONYM------------------------

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'xodot_signs_task_list_row';
   name_array(2) := 'xodot_signs_task_list';
   name_array(3) := 'xodot_signs_asset_op';
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from dba_objects where object_name = upper(name_array(i)) and object_type like 'SYNONYM';
		if i_count = 1 then
			execute immediate 'drop PUBLIC SYNONYM ' || name_array(i);
		end if;
	select count(*) into i_count from user_objects where object_name = upper(name_array(i)) and object_type = 'SYNONYM';
		if i_count = 1 then
			execute immediate 'drop SYNONYM ' || name_array(i);	
		end if;
   END LOOP;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM xodot_signs_task_list_row FOR TRANSINFO.xodot_signs_task_list_row;
CREATE OR REPLACE PUBLIC SYNONYM xodot_signs_task_list FOR TRANSINFO.xodot_signs_task_list;
CREATE OR REPLACE PUBLIC SYNONYM xodot_signs_asset_op FOR TRANSINFO.xodot_signs_asset_op;
