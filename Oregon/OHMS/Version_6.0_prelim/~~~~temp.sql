with 
	SECW as (
		SELECT 

			a.NE_ID 
			,a.NE_UNIQUE 
			,a.NE_LENGTH 
			,a.NE_DESCR 
			,a.NE_START_DATE 
			,a.NE_ADMIN_UNIT 
			,SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10) ADMIN_UNIT_CODE
			,a.NE_GTY_GROUP_TYPE 
			,a.NE_NAME_2 CREW
			,a.NE_NAME_1 DISTRICT
		FROM nm_elements a
		WHERE a.ne_nt_type = 'SECW'
		and  NE_NAME_2 = 1101

	)

	,DIST as (
		SELECT 
			a.NE_ID 
			,a.NE_UNIQUE 
			,a.NE_LENGTH 
			,a.NE_DESCR 
			,a.NE_START_DATE 
			,a.NE_ADMIN_UNIT 
			,SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10) ADMIN_UNIT_CODE
			,a.NE_GTY_GROUP_TYPE 
		FROM nm_elements a
		where NE_NT_TYPE = 'DIST'
		and NE_GTY_GROUP_TYPE = 'DIST'
	)

	, REG as (

		SELECT 
			a.NE_ID 
			,a.NE_UNIQUE 
			,a.NE_LENGTH 
			,a.NE_DESCR 
			,a.NE_START_DATE 
			,a.NE_ADMIN_UNIT 
			,SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10) ADMIN_UNIT_CODE
			,a.NE_GTY_GROUP_TYPE 
		from NM_ELEMENTS a
		where NE_NT_TYPE = 'REG'
		and NE_GTY_GROUP_TYPE = 'REG'
	)

	, MEMD as (
		select 
			NM_NE_ID_OF
			, NM_NE_ID_IN
			, NM_OBJ_TYPE
		from NM_MEMBERS_ALL 
		where NM_OBJ_TYPE = 'DIST'


	)

	, MEMR as (
		select 
			NM_NE_ID_OF
			, NM_NE_ID_IN
			, NM_OBJ_TYPE
		from NM_MEMBERS_ALL 
		where NM_OBJ_TYPE = 'REG'            
	)


	select REG.NE_DESCR, DIST.NE_DESCR, SECW.CREW
	
	from
	SECW, REG, DIST, MEMD, MEMR
	
	where
	
	SECW.NE_ID = MEMD.NM_NE_ID_OF
	and DIST.NE_ID = MEMD.NM_NE_ID_IN
	and DIST.NE_ID = MEMR.NM_NE_ID_OF
	and REG.NE_ID = MEMR.NM_NE_ID_IN

	;
