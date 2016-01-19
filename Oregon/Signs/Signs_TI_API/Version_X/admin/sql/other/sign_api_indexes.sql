/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: sign_api_indexes.sql
	Author: JMM
	UPDATE01:	Original, 2015.06.10, JMM
*/

-- Removing old indexes

DECLARE
   name_array dbms_sql.varchar2_table;
   i_count  number;
BEGIN
   name_array(1) := 'xsigns_date_chk_idx';
   --
   FOR i IN name_array.FIRST .. name_array.LAST
   LOOP
	select count(*) into i_count from dba_objects where object_name = upper(name_array(i)) and object_type like 'INDEX';
		if i_count = 1 then
			execute immediate 'drop INDEX ' || name_array(i);
		end if;
   END LOOP;
END;
/



/* ************************************************************
	Object:		xsigns_date_chk_idx
	Purpose:	The signs API needs to check the date modified fields and with a large amount of records this as become time consuming
	Notes:		
	Created:	2015.06.10	J.Mendoza
************************************************************* */

create index xsigns_date_chk_idx on nm_inv_items_all(iit_date_modified);