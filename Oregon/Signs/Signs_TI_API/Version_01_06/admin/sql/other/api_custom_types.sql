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