CREATE OR REPLACE FORCE VIEW x_v_load_ploc_brdg_mem_on_ele
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: x_v_load_ploc_brdg_mem_on_ele
	Author: JMM
	UPDATE01:	Original, 2014.06.12, JMM
	UPDATE01:	Added the cast command, 2014.08.11, JMM
*/
AS
	SELECT   
		cast(ne_unique AS VARCHAR2(2000)) BRIDGE_ID,
		ne_unique BRIDGE_SUFFIX,		
		ne_nt_type ne_nt_type,
		TO_NUMBER (NULL) iit_ne_id,
		ne_nt_type iit_inv_type,
		TO_DATE (NULL) nm_start_date
	FROM nm_elements_all
	WHERE 1 = 2;