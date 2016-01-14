Create or replace view X_LOHAC_DateRANGE_WODC as
		SELECT 0 sorter,
			SYSDATE-360				st_range,
			SYSDATE  - (1/86400) 	end_range,
			'Late' 					range_value
		FROM DUAL
	UNION
		SELECT 1 sorter,
		SYSDATE + 0				st_range,
		SYSDATE + 1 - (1/86400) end_range,
		'0-1' 					range_value
	FROM DUAL
	UNION
		SELECT 2 sorter,
		SYSDATE +1				st_range,
		SYSDATE  + 3 - (1/86400)	end_range,
		'1-3' 					range_value
	FROM DUAL
	UNION
		SELECT 3 sorter,
		SYSDATE +3				st_range,
		SYSDATE  + 10 - (1/86400)	end_range,
		'3-10' 					range_value
	FROM DUAL	
		UNION
		SELECT 4 sorter,
		SYSDATE +10				st_range,
		SYSDATE  + 360 - (1/86400)	end_range,
		'>10' 					range_value
	FROM DUAL	
;


