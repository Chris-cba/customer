/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: Create_Groupings.sql
	Author: JMM
	UPDATE01:	Original, 2014.12.03, JMM
*/


Insert Into NM_INV_TYPE_GROUPINGS_ALL (ITG_INV_TYPE,  ITG_PARENT_INV_TYPE,  ITG_MANDATORY,  ITG_RELATION,  ITG_START_DATE,  ITG_DATE_CREATED,  ITG_DATE_MODIFIED,  ITG_MODIFIED_BY,  ITG_CREATED_BY) Values ('RSAM', 'RSD', 'N', 'AT', to_date('01-JAN-1901'), sysdate, sysdate, 'RAMS', 'RAMS');
Insert Into NM_INV_TYPE_GROUPINGS_ALL (ITG_INV_TYPE,  ITG_PARENT_INV_TYPE,  ITG_MANDATORY,  ITG_RELATION,  ITG_START_DATE,  ITG_DATE_CREATED,  ITG_DATE_MODIFIED,  ITG_MODIFIED_BY,  ITG_CREATED_BY) Values ('RSDE', 'RSD', 'N', 'AT', to_date('01-JAN-1901'), sysdate, sysdate, 'RAMS', 'RAMS');
Insert Into NM_INV_TYPE_GROUPINGS_ALL (ITG_INV_TYPE,  ITG_PARENT_INV_TYPE,  ITG_MANDATORY,  ITG_RELATION,  ITG_START_DATE,  ITG_DATE_CREATED,  ITG_DATE_MODIFIED,  ITG_MODIFIED_BY,  ITG_CREATED_BY) Values ('RSIC', 'RSD', 'N', 'AT', to_date('01-JAN-1901'), sysdate, sysdate, 'RAMS', 'RAMS');
Insert Into NM_INV_TYPE_GROUPINGS_ALL (ITG_INV_TYPE,  ITG_PARENT_INV_TYPE,  ITG_MANDATORY,  ITG_RELATION,  ITG_START_DATE,  ITG_DATE_CREATED,  ITG_DATE_MODIFIED,  ITG_MODIFIED_BY,  ITG_CREATED_BY) Values ('RSIN', 'RSD', 'N', 'AT', to_date('01-JAN-1901'), sysdate, sysdate, 'RAMS', 'RAMS');
Insert Into NM_INV_TYPE_GROUPINGS_ALL (ITG_INV_TYPE,  ITG_PARENT_INV_TYPE,  ITG_MANDATORY,  ITG_RELATION,  ITG_START_DATE,  ITG_DATE_CREATED,  ITG_DATE_MODIFIED,  ITG_MODIFIED_BY,  ITG_CREATED_BY) Values ('RSRE', 'RSD', 'N', 'AT', to_date('01-JAN-1901'), sysdate, sysdate, 'RAMS', 'RAMS');



COMMIT;
