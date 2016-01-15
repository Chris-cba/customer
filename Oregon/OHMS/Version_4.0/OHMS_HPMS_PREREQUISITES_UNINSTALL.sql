/* ---------- JM, 2011.07.25,13:54
OHMS, HPMS INSERT Script
---------- */

set sqlblanklines on


-- HPMS_CATALOG

	DELETE FROM HPMS_CATALOG WHERE hc_name = 'OHMS';

-- HPMS_TABLE

	DELETE FROM HPMS_TABLE where ht_name = 'OHMS_SUBMIT_SECTIONS';


-- HPMS_Column
	DELETE FROM HPMS_COLUMN where HCL_ID between 500 and 515;
	
	



-- HPMS_MAPPING
		
	DELETE FROM HPMS_MAPPING where HM_HCL_ID between 500 and 515;
		

			
			
-- HPMS_PROCEDURE
	
	DELETE FROM HPMS_PROCEDURE where hp_db_table_name = 'OHMS_SUBMIT_SECTIONS';
	

		
commit;

@ zDrop_HPMS_TV.sql;