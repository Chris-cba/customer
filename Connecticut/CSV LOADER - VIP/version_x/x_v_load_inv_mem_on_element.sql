CREATE OR REPLACE FORCE VIEW x_V_LOAD_INV_MEM_ON_ELEMENT
AS
	SELECT   
		ne_unique ROAD_UNIQUE,
		ne_unique ROUTE_SUFFIX,
		ne_unique ROUTE_DIR,
		ne_nt_type ne_nt_type,
		TO_NUMBER (NULL) begin_mp,
		TO_NUMBER (NULL) end_mp,
		TO_NUMBER (NULL) iit_ne_id,
		ne_nt_type iit_inv_type,
		TO_DATE (NULL) nm_start_date
	FROM nm_elements_all
	WHERE 1 = 2;