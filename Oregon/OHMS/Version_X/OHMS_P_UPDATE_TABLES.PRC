create or replace

procedure XODOT_OHMS_UPDATE_TA(p_Name in varchar2) is


t_error                 VARCHAR2(200);
t_error_desc            VARCHAR2(200);
t_error_msg             VARCHAR2(300);
t_item_processing       VARCHAR2(10);
t_item_descr            VARCHAR2(100);
t_hal_id                NUMBER;
t_table_id              NUMBER;
t_timestamp             TIMESTAMP;

t_sysdate               DATE;
t_user                  VARCHAR2(32);
T_TARGET_TABLE_NAME     HPMS_PROCEDURE.HP_DB_TABLE_NAME%type;

E_INCORRECT				Exception;

BEGIN

  -----------------------
  t_error                 := NULL;
  t_error_desc            := NULL;
  T_TABLE_ID              := 7;
  SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

  T_ITEM_DESCR            := P_NAME;
  t_error_desc            := 'Updating Table: ' || P_NAME;

  -----------------------

  execute immediate 'truncate table ' || p_name;

  case  P_NAME

    when 'OHMS_7_NETWORK_MV' then

        Insert into OHMS_7_NETWORK_MV
	select 
		--  Applies the requirement for FACL = 1,2,3
		b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk, E.iit_num_attrib100 FACL
		FROM V_NM_HWY_NT a
			, nm_members b
			, NM_ELEMENTS C
			, NM_MEMBERS D
			, NM_INV_ITEMS E
		   
		WHERE 1=1
			and a.ne_id = b.nm_ne_id_in 
			and B.NM_NE_ID_OF = C.NE_ID
			and C.NE_ID = D.NM_NE_ID_OF
			and D.NM_NE_ID_IN = E.IIT_NE_ID
			and B.NM_OBJ_TYPE = 'HWY'
			and D.NM_OBJ_TYPE = 'FACL'        
			and E.iit_num_attrib100 in (1, 2, 3)
			AND b.nm_type = 'G'
			and C.NE_TYPE = 'S'
			and a.MILEAGE_TYPE <> 'P';

    when 'OHMS_7_NETWORK_MV2' then
                insert into OHMS_7_NETWORK_MV2
                select
                --  Applies the requirement for FACL = 1,2,3,6
                b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk, E.iit_num_attrib100 FACL
                FROM V_NM_HWY_NT a
                , nm_members b
                , NM_ELEMENTS C
                , NM_MEMBERS D
                , NM_INV_ITEMS E

                WHERE a.ne_id = b.nm_ne_id_in
                and B.NM_NE_ID_OF = C.NE_ID
                and C.NE_ID = D.NM_NE_ID_OF
                and D.NM_NE_ID_IN = E.IIT_NE_ID
                and B.NM_OBJ_TYPE = 'HWY'
                and D.NM_OBJ_TYPE = 'FACL'
                and E.iit_num_attrib100 in (1, 2, 3, 6)
                AND b.nm_type = 'G'
                and C.NE_TYPE = 'S'
                and a.MILEAGE_TYPE <> 'P';

    when 'V_NM_URBN502_OUTER_MV_NT' then
				insert into v_nm_urbn502_outer_mv_nt
				SELECT
				SMALL_URBAN
				, URBAN_AREA
				, NE_GTY_GROUP_TYPE
				, ADMIN_UNIT_CODE
				, NE_ADMIN_UNIT
				, NE_START_DATE
				, NE_DESCR
				, NE_LENGTH
				, NE_UNIQUE
				, NE_ID
				, r.ne_id_of
				, r.nm_begin_mp
				, r.nm_end_mp
				FROM (
				SELECT x.ne_id_of
				, x.nm_begin_mp
				, x.nm_end_mp
				FROM (
				SELECT ne_id_of
					, nm_begin_mp
					, nm_end_mp
				FROM (
					SELECT ne_id_of
						, mp nm_begin_mp
						, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
							lead(mp) over(order by ne_id_of, mp)
						  ELSE
							-1
						  END nm_end_mp
					FROM (
						SELECT DISTINCT ne_id_of, mp
						FROM (
							SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
							FROM nm_members
							WHERE nm_type = 'G'
								AND nm_obj_type IN ('HWY','URBN')
							UNION
							SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
							FROM nm_members
							WHERE nm_type = 'G'
								AND nm_obj_type IN ('HWY','URBN')

						)))
					WHERE nm_end_mp > -1) x
					, (SELECT
						nm_begin_mp
						, nm_end_mp
						, nm_ne_id_of ne_id_of
					FROM
					v_nm_hwy_nt
					, nm_members
					WHERE
					   ne_id = nm_ne_id_in
					   AND ne_unique IS NOT NULL) y
				WHERE x.ne_id_of = y.ne_id_of
					  AND x.nm_begin_mp < y.nm_end_mp
					  AND x.nm_end_mp > y.nm_begin_mp) r
				, (
				SELECT
				SMALL_URBAN
				, URBAN_AREA
				, NE_GTY_GROUP_TYPE
				, ADMIN_UNIT_CODE
				, NE_ADMIN_UNIT
				, NE_START_DATE
				, NE_DESCR
				, NE_LENGTH
				, NE_UNIQUE
				, NE_ID
				, nm_ne_id_of ne_id_of
				, nm_begin_mp
				, nm_end_mp
				FROM
				v_nm_urbn_nt
				, nm_members
				WHERE
				ne_id = nm_ne_id_in
				) a
				WHERE
				r.ne_id_of = a.ne_id_of(+)
				AND r.nm_begin_mp < a.nm_end_mp(+)
				AND r.nm_end_mp > a.nm_begin_mp(+);

    when 'V_NM_NBI504_OUTER_MV_NW' then
				insert into v_nm_nbi504_outer_mv_nw 
				   SELECT 
							NM_ADMIN_UNIT
							, NM_END_DATE
							, NM_START_DATE
							, NM_SEQ_NO
							, MEMBER_UNIQUE
							, STRUC_NM
							, FEAT_NM
							, CENTER_MP_MEAS
							, LEN_MEAS
							, STRUC_ID
							, IIT_END_DATE
							, IIT_X_SECT
							, NAU_UNIT_CODE
							, IIT_PEO_INVENT_BY_ID
							, IIT_NOTE
							, IIT_DESCR
							, IIT_ADMIN_UNIT
							, IIT_MODIFIED_BY
							, IIT_CREATED_BY
							, IIT_DATE_MODIFIED
							, IIT_DATE_CREATED
							, IIT_START_DATE
							, IIT_PRIMARY_KEY
							, IIT_INV_TYPE
							, IIT_NE_ID
						, r.ne_id_of
						, r.nm_begin_mp
						, r.nm_end_mp
					FROM (             
						SELECT x.ne_id_of
							, x.nm_begin_mp
							, x.nm_end_mp
						FROM (    
							SELECT ne_id_of
								, nm_begin_mp
								, nm_end_mp
							FROM (    
								SELECT ne_id_of
									, mp nm_begin_mp
									, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
										lead(mp) over(order by ne_id_of, mp)
									  ELSE
										-1
									  END nm_end_mp
								FROM (      
									SELECT DISTINCT ne_id_of, mp
									FROM (
										SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
										FROM nm_members
										WHERE nm_type = 'G'
											AND nm_obj_type IN ('HWY')
										UNION
										SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
										FROM nm_members
										WHERE nm_type = 'G'
											AND nm_obj_type IN ('HWY')
										UNION
										SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
										FROM nm_members
										WHERE nm_type = 'I'
											AND nm_obj_type IN ('NBI')
										UNION
										SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
										FROM nm_members
										WHERE nm_type = 'I'
											AND nm_obj_type IN ('NBI')

									)))
								WHERE nm_end_mp > -1) x 
								, (SELECT 
									nm_begin_mp
									, nm_end_mp
									, nm_ne_id_of ne_id_of
								FROM
								v_nm_hwy_nt
								, nm_members
								WHERE
								   ne_id = nm_ne_id_in
								   AND ne_unique IS NOT NULL) y
							WHERE x.ne_id_of = y.ne_id_of
								  AND x.nm_begin_mp < y.nm_end_mp
								  AND x.nm_end_mp > y.nm_begin_mp) r
						, (
						SELECT
							NM_ADMIN_UNIT
							, NM_END_DATE
							, NM_START_DATE
							, NM_SEQ_NO
							, MEMBER_UNIQUE
							, STRUC_NM
							, FEAT_NM
							, CENTER_MP_MEAS
							, LEN_MEAS
							, STRUC_ID
							, IIT_END_DATE
							, IIT_X_SECT
							, NAU_UNIT_CODE
							, IIT_PEO_INVENT_BY_ID
							, IIT_NOTE
							, IIT_DESCR
							, IIT_ADMIN_UNIT
							, IIT_MODIFIED_BY
							, IIT_CREATED_BY
							, IIT_DATE_MODIFIED
							, IIT_DATE_CREATED
							, IIT_START_DATE
							, IIT_PRIMARY_KEY
							, IIT_INV_TYPE
							, IIT_NE_ID
							, ne_id_of
							, nm_begin_mp
							, nm_end_mp
						FROM
							v_nm_nbi_nw
						) a 
					WHERE
						r.ne_id_of = a.ne_id_of(+)
							AND r.nm_begin_mp < a.nm_end_mp(+)
							AND r.nm_end_mp > a.nm_begin_mp(+)
					;
    when 'V_NM_TUNL504_OUTER_MV_NW' then
					insert into v_nm_tunl504_outer_mv_nw 
					SELECT 
						NM_ADMIN_UNIT
						, NM_END_DATE
						, NM_START_DATE
						, NM_SEQ_NO
						, MEMBER_UNIQUE
						, NM
						, CENTER_MP_MEAS
						, LEN_MEAS
						, STRUC_ID
						, IIT_END_DATE
						, NAU_UNIT_CODE
						, IIT_PEO_INVENT_BY_ID
						, IIT_NOTE
						, IIT_DESCR
						, IIT_ADMIN_UNIT
						, IIT_MODIFIED_BY
						, IIT_CREATED_BY
						, IIT_DATE_MODIFIED
						, IIT_DATE_CREATED
						, IIT_START_DATE
						, IIT_PRIMARY_KEY
						, IIT_INV_TYPE
						, IIT_NE_ID
					, r.ne_id_of
					, r.nm_begin_mp
					, r.nm_end_mp
				FROM (             
					SELECT x.ne_id_of
						, x.nm_begin_mp
						, x.nm_end_mp
					FROM (    
						SELECT ne_id_of
							, nm_begin_mp
							, nm_end_mp
						FROM (    
							SELECT ne_id_of
								, mp nm_begin_mp
								, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
									lead(mp) over(order by ne_id_of, mp)
								  ELSE
									-1
								  END nm_end_mp
							FROM (      
								SELECT DISTINCT ne_id_of, mp
								FROM (
									SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
									FROM nm_members
									WHERE nm_type = 'G'
										AND nm_obj_type IN ('HWY')
									UNION
									SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
									FROM nm_members
									WHERE nm_type = 'G'
										AND nm_obj_type IN ('HWY')
									UNION
									SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
									FROM nm_members
									WHERE nm_type = 'I'
										AND nm_obj_type IN ('TUNL')
									UNION
									SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
									FROM nm_members
									WHERE nm_type = 'I'
										AND nm_obj_type IN ('TUNL')

								)))
							WHERE nm_end_mp > -1) x 
							, (SELECT 
								nm_begin_mp
								, nm_end_mp
								, nm_ne_id_of ne_id_of
							FROM
							v_nm_hwy_nt
							, nm_members
							WHERE
							   ne_id = nm_ne_id_in
							   AND ne_unique IS NOT NULL) y
						WHERE x.ne_id_of = y.ne_id_of
							  AND x.nm_begin_mp < y.nm_end_mp
							  AND x.nm_end_mp > y.nm_begin_mp) r
					, (
					SELECT
						NM_ADMIN_UNIT
						, NM_END_DATE
						, NM_START_DATE
						, NM_SEQ_NO
						, MEMBER_UNIQUE
						, NM
						, CENTER_MP_MEAS
						, LEN_MEAS
						, STRUC_ID
						, IIT_END_DATE
						, NAU_UNIT_CODE
						, IIT_PEO_INVENT_BY_ID
						, IIT_NOTE
						, IIT_DESCR
						, IIT_ADMIN_UNIT
						, IIT_MODIFIED_BY
						, IIT_CREATED_BY
						, IIT_DATE_MODIFIED
						, IIT_DATE_CREATED
						, IIT_START_DATE
						, IIT_PRIMARY_KEY
						, IIT_INV_TYPE
						, IIT_NE_ID
						, ne_id_of
						, nm_begin_mp
						, nm_end_mp
					FROM
						v_nm_tunl_nw
					) a 
				WHERE
					r.ne_id_of = a.ne_id_of(+)
						AND r.nm_begin_mp < a.nm_end_mp(+)
						AND r.nm_end_mp > a.nm_begin_mp(+)
				;
    when 'OHMS_TMP_7_507_RDGM' then
				insert into OHMS_TMP_7_507_RDGM
				SELECT * FROM 
				v_nm_RDGM_nw
				WHERE 1=1 
				AND IIT_X_SECT LIKE 'LN%'
				AND LAYER =1
				AND LN_MEDN_TYP_CD IN(1,2,3)
				;
		
	when 'OHMS_TMP__7_507_RTE_ITEM_HWY' then
				insert into OHMS_TMP__7_507_RTE_ITEM_HWY 
				SELECT * FROM 
				v_nm_hwy_nt
				, nm_members_d
				WHERE 1=1 
				AND ne_id = nm_ne_id_in
				AND NE_UNIQUE IS NOT NULL
				;
	when 'OHMS_TMP_RTE_7_507_RDGM' then
				insert into OHMS_TMP_RTE_7_507_RDGM
				SELECT  l.NE_UNIQUE
					, l.nm_cardinality
					, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
					, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
					, a.*
				FROM OHMS_TMP_7_507_RDGM a
				, OHMS_TMP__7_507_RTE_ITEM_HWY l 
				WHERE 1=1
				AND l.nm_ne_id_of= a.ne_id_of
				AND l.nm_begin_mp < a.nm_end_mp
				AND l.nm_end_mp    > a.nm_begin_mp;
	when 'OHMS_TMP_SEG_7_507_RDGM' then
				insert into OHMS_tmp_seg_7_507_rdgm 
				SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM (
						SELECT NE_UNIQUE
							 , mp nm_slk
							 , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
									lead(mp) over(order by  NE_UNIQUE, mp)
							 ELSE
								 -99
							 END nm_end_slk
						FROM ( 
							 SELECT ne_unique
							 , nm_slk mp
							 FROM OHMS_tmp_rte_7_507_rdgm
							 UNION
							 SELECT ne_unique
							 , nm_end_slk mp
							 FROM OHMS_tmp_rte_7_507_rdgm
							 UNION
							 SELECT ne_unique
							 , nm_slk mp
							 FROM OHMS_7_network_mv
							 UNION
							 SELECT ne_unique
							 , nm_end_slk mp
							 FROM OHMS_7_network_mv
							  ))
					WHERE nm_end_slk > -99;

	when 'OHMS_TMP_DETAIL_7_507_RDGM' then
				insert into OHMS_TMP_DETAIL_7_507_RDGM 
				SELECT 
					ln_medn_typ_cd
							, l.NE_UNIQUE
					, l.nm_slk
					, l.nm_end_slk
					FROM OHMS_tmp_seg_7_507_rdgm l
					, OHMS_tmp_rte_7_507_rdgm a
				WHERE 1=1
					AND l.ne_unique = a.ne_unique
					AND l.nm_slk < a.nm_end_slk
					AND l.nm_end_slk > a.nm_slk
					;
	when 'V_NM_RDGM507_COUNT_MV_NW' then
				insert into V_NM_RDGM507_COUNT_MV_NW 
				SELECT 
					count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
							, NE_UNIQUE
					, nm_slk
					, nm_end_slk
					FROM OHMS_TMP_DETAIL_7_507_RDGM 
				GROUP BY 
							NE_UNIQUE
					, nm_slk
					, nm_end_slk;
					
	when 'OHMS_TMP_7_508_RDGM' then
				insert into  OHMS_TMP_7_508_RDGM 
				SELECT * FROM 
				v_nm_RDGM_nw
				WHERE 1=1 
				AND IIT_X_SECT LIKE 'LN%'
				AND LAYER =1
				AND LN_MEDN_TYP_CD = 3
				;
				
	when 'OHMS_TMP_7_508_RTE_ITEM_HWY' then
				insert into OHMS_TMP_7_508_RTE_ITEM_HWY
				SELECT * FROM 
				v_nm_hwy_nt
				, nm_members_d
				WHERE 1=1 
				AND ne_id = nm_ne_id_in
				AND NE_UNIQUE IS NOT NULL
				;

	
	when 'OHMS_TMP_RTE_7_508_RDGM' then
			insert into OHMS_TMP_RTE_7_508_RDGM 
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_508_RDGM a
			, OHMS_TMP_7_508_RTE_ITEM_HWY l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;
	
	when 'OHMS_TMP_SEG_7_508_RDGM' then
			insert into OHMS_TMP_SEG_7_508_RDGM 
			SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_508_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_508_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;
	
	when 'OHMS_TMP_DETAIL_7_508_RDGM' then
			insert into OHMS_TMP_DETAIL_7_508_RDGM 
			SELECT 
				ln_medn_typ_cd
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_508_rdgm l
				, OHMS_tmp_rte_7_508_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
			
	when 'V_NM_RDGM508_MIN_MV_NW' then		
			insert into V_NM_RDGM508_MIN_MV_NW 
			SELECT 
				min(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_508_RDGM 
			GROUP BY 
						NE_UNIQUE
				, nm_slk
				, nm_end_slk;
				
	when 'OHMS_TMP_7_509_RDGM' then		
			insert into OHMS_TMP_7_509_RDGM 
			SELECT * FROM 
			v_nm_RDGM_nw
			WHERE 1=1 
			AND IIT_X_SECT LIKE 'LN%'
			AND LAYER = 1
			AND LN_MEDN_TYP_CD = 3;		
		
	when 'OHMS_TMP_7_509_RTE_ITEM_HWY' then	
			insert into OHMS_TMP_7_509_RTE_ITEM_HWY
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_d
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;

	when 'OHMS_TMP_RTE_7_509_RDGM' then
			insert into OHMS_TMP_RTE_7_509_RDGM 
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_509_RDGM a
			, OHMS_TMP_7_509_RTE_ITEM_HWY l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;

	when 'OHMS_TMP_SEG_7_509_RDGM' then		
			insert into OHMS_TMP_SEG_7_509_RDGM
			SELECT DISTINCT NE_UNIQUE
			, nm_slk
			, nm_end_slk
			FROM (
					SELECT NE_UNIQUE
				 , mp nm_slk
							  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
									  lead(mp) over(order by  NE_UNIQUE, mp)
				 ELSE
					 -99
				 END nm_end_slk
			 FROM ( 
				 SELECT ne_unique
				 , nm_slk mp
				 FROM OHMS_tmp_rte_7_509_rdgm
				 UNION
				 SELECT ne_unique
				 , nm_end_slk mp
				 FROM OHMS_tmp_rte_7_509_rdgm
				 UNION
				 SELECT ne_unique
				 , nm_slk mp
				 FROM OHMS_7_network_mv
				 UNION
				 SELECT ne_unique
				 , nm_end_slk mp
				 FROM OHMS_7_network_mv
				  ))
			WHERE nm_end_slk > -99;

	when 'OHMS_TMP_DETAIL_7_509_RDGM' then		
			insert into OHMS_TMP_DETAIL_7_509_RDGM
			SELECT 
				ln_medn_typ_cd
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_509_rdgm l
				, OHMS_tmp_rte_7_509_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
	when 'V_NM_RDGM509_COUNT_MV_NW' then	
			insert into V_NM_RDGM509_COUNT_MV_NW 
			SELECT 
				count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_509_RDGM 
			GROUP BY 
						NE_UNIQUE
				, nm_slk
				, nm_end_slk;	

	when 'V_NM_URBN510_OUTER_MV_NT' then
			insert into V_NM_URBN510_OUTER_MV_NT 
			SELECT 
					SMALL_URBAN
					, URBAN_AREA
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
				, r.ne_id_of
				, r.nm_begin_mp
				, r.nm_end_mp
			FROM (             
				SELECT x.ne_id_of
					, x.nm_begin_mp
					, x.nm_end_mp
				FROM (    
					SELECT ne_id_of
						, nm_begin_mp
						, nm_end_mp
					FROM (    
						SELECT ne_id_of
							, mp nm_begin_mp
							, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
								lead(mp) over(order by ne_id_of, mp)
							  ELSE
								-1
							  END nm_end_mp
						FROM (      
							SELECT DISTINCT ne_id_of, mp
							FROM (
								SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','URBN')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','URBN')

							)))
						WHERE nm_end_mp > -1) x 
						, (SELECT 
							nm_begin_mp
							, nm_end_mp
							, nm_ne_id_of ne_id_of
						FROM
						v_nm_hwy_nt
						, nm_members
						WHERE
						   ne_id = nm_ne_id_in
						   AND ne_unique IS NOT NULL) y
					WHERE x.ne_id_of = y.ne_id_of
						  AND x.nm_begin_mp < y.nm_end_mp
						  AND x.nm_end_mp > y.nm_begin_mp) r
				, (
				SELECT
					SMALL_URBAN
					, URBAN_AREA
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
					, nm_ne_id_of ne_id_of
					, nm_begin_mp
					, nm_end_mp
				FROM
					v_nm_urbn_nt
					, nm_members 
				WHERE
				   ne_id = nm_ne_id_in
				) a 
			WHERE
				r.ne_id_of = a.ne_id_of(+)
					AND r.nm_begin_mp < a.nm_end_mp(+)
					AND r.nm_end_mp > a.nm_begin_mp(+)
			;

	when 'V_NM_SPZN514_OUTER_MV_NW' then
			insert into V_NM_SPZN514_OUTER_MV_NW 
			SELECT 
					NM_ADMIN_UNIT
					, NM_END_DATE
					, NM_START_DATE
					, NM_SEQ_NO
					, MEMBER_UNIQUE
					, SPEED_DESIG
					, IIT_END_DATE
					, NAU_UNIT_CODE
					, IIT_PEO_INVENT_BY_ID
					, IIT_NOTE
					, IIT_DESCR
					, IIT_ADMIN_UNIT
					, IIT_MODIFIED_BY
					, IIT_CREATED_BY
					, IIT_DATE_MODIFIED
					, IIT_DATE_CREATED
					, IIT_START_DATE
					, IIT_PRIMARY_KEY
					, IIT_INV_TYPE
					, IIT_NE_ID
				, r.ne_id_of
				, r.nm_begin_mp
				, r.nm_end_mp
			FROM (             
				SELECT x.ne_id_of
					, x.nm_begin_mp
					, x.nm_end_mp
				FROM (    
					SELECT ne_id_of
						, nm_begin_mp
						, nm_end_mp
					FROM (    
						SELECT ne_id_of
							, mp nm_begin_mp
							, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
								lead(mp) over(order by ne_id_of, mp)
							  ELSE
								-1
							  END nm_end_mp
						FROM (      
							SELECT DISTINCT ne_id_of, mp
							FROM (
								SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
								FROM nm_members
								WHERE nm_type = 'I'
									AND nm_obj_type IN ('SPZN')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
								FROM nm_members
								WHERE nm_type = 'I'
									AND nm_obj_type IN ('SPZN')

							)))
						WHERE nm_end_mp > -1) x 
						, (SELECT 
							nm_begin_mp
							, nm_end_mp
							, nm_ne_id_of ne_id_of
						FROM
						v_nm_hwy_nt
						, nm_members
						WHERE
						   ne_id = nm_ne_id_in
						   AND ne_unique IS NOT NULL) y
					WHERE x.ne_id_of = y.ne_id_of
						  AND x.nm_begin_mp < y.nm_end_mp
						  AND x.nm_end_mp > y.nm_begin_mp) r
				, (
				SELECT
					NM_ADMIN_UNIT
					, NM_END_DATE
					, NM_START_DATE
					, NM_SEQ_NO
					, MEMBER_UNIQUE
					, SPEED_DESIG
					, IIT_END_DATE
					, NAU_UNIT_CODE
					, IIT_PEO_INVENT_BY_ID
					, IIT_NOTE
					, IIT_DESCR
					, IIT_ADMIN_UNIT
					, IIT_MODIFIED_BY
					, IIT_CREATED_BY
					, IIT_DATE_MODIFIED
					, IIT_DATE_CREATED
					, IIT_START_DATE
					, IIT_PRIMARY_KEY
					, IIT_INV_TYPE
					, IIT_NE_ID
					, ne_id_of
					, nm_begin_mp
					, nm_end_mp
				FROM
					v_nm_spzn_nw
				) a 
			WHERE
				r.ne_id_of = a.ne_id_of(+)
					AND r.nm_begin_mp < a.nm_end_mp(+)
					AND r.nm_end_mp > a.nm_begin_mp(+)
			;

	when 'V_NM_URBN514_OUTER_MV_NT' then
			insert into V_NM_URBN514_OUTER_MV_NT
			SELECT 
					SMALL_URBAN
					, URBAN_AREA
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
				, r.ne_id_of
				, r.nm_begin_mp
				, r.nm_end_mp
			FROM (             
				SELECT x.ne_id_of
					, x.nm_begin_mp
					, x.nm_end_mp
				FROM (    
					SELECT ne_id_of
						, nm_begin_mp
						, nm_end_mp
					FROM (    
						SELECT ne_id_of
							, mp nm_begin_mp
							, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
								lead(mp) over(order by ne_id_of, mp)
							  ELSE
								-1
							  END nm_end_mp
						FROM (      
							SELECT DISTINCT ne_id_of, mp
							FROM (
								SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','URBN')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','URBN')

							)))
						WHERE nm_end_mp > -1) x 
						, (SELECT 
							nm_begin_mp
							, nm_end_mp
							, nm_ne_id_of ne_id_of
						FROM
						v_nm_hwy_nt
						, nm_members
						WHERE
						   ne_id = nm_ne_id_in
						   AND ne_unique IS NOT NULL) y
					WHERE x.ne_id_of = y.ne_id_of
						  AND x.nm_begin_mp < y.nm_end_mp
						  AND x.nm_end_mp > y.nm_begin_mp) r
				, (
				SELECT
					SMALL_URBAN
					, URBAN_AREA
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
					, nm_ne_id_of ne_id_of
					, nm_begin_mp
					, nm_end_mp
				FROM
					v_nm_urbn_nt
					, nm_members 
				WHERE
				   ne_id = nm_ne_id_in
				) a 
			WHERE
				r.ne_id_of = a.ne_id_of(+)
					AND r.nm_begin_mp < a.nm_end_mp(+)
					AND r.nm_end_mp > a.nm_begin_mp(+)
			;
	
	when 'OHMS_TMP_7_538_RDGM' then
			insert into OHMS_TMP_7_538_RDGM
			SELECT * FROM 
			v_nm_RDGM_nw
			WHERE 1=1 
			AND LAYER =1
			AND IIT_X_SECT IN ('OS1I','OS2I') 
			;
		
	when 'OHMS_TMP_7_538_RTE_ITEM_HWY' then
			insert into OHMS_TMP_7_538_RTE_ITEM_HWY
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_i
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;

	
	when 'OHMS_TMP_SEG_7_538_RDGM' then
			insert into OHMS_TMP_SEG_7_538_RDGM
			SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_538_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_538_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;


	when 'OHMS_TMP_RTE_7_538_RDGM' then
			insert into OHMS_TMP_RTE_7_538_RDGM
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_538_RDGM a
			, OHMS_TMP_7_538_RTE_ITEM_HWY l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;
	

	when 'OHMS_TMP_DETAIL_7_538_RDGM' then
			insert into OHMS_TMP_DETAIL_7_538_RDGM
			SELECT 
				wd_meas
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_538_rdgm l
				, OHMS_tmp_rte_7_538_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
	
	when 'V_NM_RDGM538_SUM_MV_NW' then
			insert into V_NM_RDGM538_SUM_MV_NW
			SELECT 
				sum(WD_MEAS) WD_MEAS
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_538_RDGM 
			GROUP BY 
				  NE_UNIQUE
				, nm_slk
				, nm_end_slk;
	
	when 'OHMS_TMP_7_539_RDGM' then
			insert into OHMS_TMP_7_539_RDGM
			SELECT * FROM 
			v_nm_RDGM_nw
			WHERE 1=1 
			AND LAYER =1
			AND IIT_X_SECT IN('IS1I','IS2I')   
			;

	when 'OHMS_TMP_7_539_RTE_ITEM_HWY' then
			insert into OHMS_TMP_7_539_RTE_ITEM_HWY
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_i
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;
	
	when 'OHMS_TMP_RTE_7_539_RDGM' then
			insert into OHMS_TMP_RTE_7_539_RDGM
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_539_RDGM a
			, OHMS_TMP_7_539_RTE_ITEM_HWY l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;
	
	when 'OHMS_TMP_SEG_7_539_RDGM' then
			insert into OHMS_TMP_SEG_7_539_RDGM
			SELECT DISTINCT NE_UNIQUE
			, nm_slk
			, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_539_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_539_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;

	when 'OHMS_TMP_DETAIL_7_539_RDGM' then
			insert into OHMS_TMP_DETAIL_7_539_RDGM
			SELECT 
				wd_meas
				, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_539_rdgm l
				, OHMS_tmp_rte_7_539_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
	
	when 'V_NM_RDGM539_SUM_MV_NW' then
			insert into V_NM_RDGM539_SUM_MV_NW
			SELECT 
				sum(WD_MEAS) WD_MEAS
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_539_RDGM 
			GROUP BY 
				NE_UNIQUE
				, nm_slk
				, nm_end_slk;
	
	when 'OHMS_TMP_7_540_PRKR' then	
			insert into OHMS_TMP_7_540_PRKR 
			SELECT * FROM 
			v_nm_PRKR_nw
			WHERE 1=1 
			;

	when 'OHMS_TMP_7_540_RTE_ITEM_HWY' then
			insert into OHMS_TMP_7_540_RTE_ITEM_HWY
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_d
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;
	
	when 'OHMS_TMP_RTE_7_540_PRKR' then
			insert into OHMS_TMP_RTE_7_540_PRKR
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_540_PRKR a
			, OHMS_TMP_7_540_RTE_ITEM_HWY l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp   > a.nm_begin_mp;
			
	when 'OHMS_TMP_SEG_7_540_PRKR' then
			insert into OHMS_TMP_SEG_7_540_PRKR
			SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_540_prkr
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_540_prkr
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;
			
	when 'OHMS_TMP_DETAIL_7_540_PRKR' then
			insert into OHMS_TMP_DETAIL_7_540_PRKR
			SELECT 
				iit_x_sect
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_540_prkr l
				, OHMS_tmp_rte_7_540_prkr a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
				
	when 'V_NM_PRKR540_COUNT_MV_NW' then
			insert into V_NM_PRKR540_COUNT_MV_NW 
			SELECT 
				count(IIT_X_SECT) IIT_X_SECT
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_540_PRKR 
			GROUP BY 
						NE_UNIQUE
				, nm_slk
				, nm_end_slk;
				
	when 'V_NM_SEEA566_OUTER_MV_NT' then
			insert into V_NM_SEEA566_OUTER_MV_NT
			SELECT 
					CREW
					, HIGHWAY_EA_NUMBER
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
				, r.ne_id_of
				, r.nm_begin_mp
				, r.nm_end_mp
			FROM (             
				SELECT x.ne_id_of
					, x.nm_begin_mp
					, x.nm_end_mp
				FROM (    
					SELECT ne_id_of
						, nm_begin_mp
						, nm_end_mp
					FROM (    
						SELECT ne_id_of
							, mp nm_begin_mp
							, CASE WHEN ne_id_of = lead(ne_id_of) over (order by ne_id_of, mp) THEN
								lead(mp) over(order by ne_id_of, mp)
							  ELSE
								-1
							  END nm_end_mp
						FROM (      
							SELECT DISTINCT ne_id_of, mp
							FROM (
								SELECT nm_ne_id_of ne_id_of, nm_end_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','SEEA')
								UNION
								SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
								FROM nm_members
								WHERE nm_type = 'G'
									AND nm_obj_type IN ('HWY','SEEA')

							)))
						WHERE nm_end_mp > -1) x 
						, (SELECT 
							nm_begin_mp
							, nm_end_mp
							, nm_ne_id_of ne_id_of
						FROM
						v_nm_hwy_nt
						, nm_members
						WHERE
						   ne_id = nm_ne_id_in
						   AND ne_unique IS NOT NULL) y
					WHERE x.ne_id_of = y.ne_id_of
						  AND x.nm_begin_mp < y.nm_end_mp
						  AND x.nm_end_mp > y.nm_begin_mp) r
				, (
				SELECT
					CREW
					, HIGHWAY_EA_NUMBER
					, NE_GTY_GROUP_TYPE
					, ADMIN_UNIT_CODE
					, NE_ADMIN_UNIT
					, NE_START_DATE
					, NE_DESCR
					, NE_LENGTH
					, NE_UNIQUE
					, NE_ID
					, nm_ne_id_of ne_id_of
					, nm_begin_mp
					, nm_end_mp
				FROM
					(
					  SELECT 
						   a.NE_ID 
						  ,a.NE_UNIQUE 
						  ,a.NE_LENGTH 
						  ,a.NE_DESCR 
						  ,a.NE_START_DATE 
						  ,a.NE_ADMIN_UNIT 
						  ,SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10) ADMIN_UNIT_CODE
						  ,a.NE_GTY_GROUP_TYPE 
						  ,a.NE_NAME_1 HIGHWAY_EA_NUMBER
						  ,b.MAINT_SECTION_CREW_ID CREW
					 from NM_ELEMENTS a,
							XODOT_EA_CW_DIST_REG_LOOKUP b
					 where a.NE_NT_TYPE = 'SEEA'
							and a.NE_UNIQUE = b.EA_NUMBER
					)
					, nm_members 
				WHERE
				   ne_id = nm_ne_id_in
				) a 
			WHERE	1=1
					AND r.ne_id_of = a.ne_id_of(+)
					AND r.nm_begin_mp < a.nm_end_mp(+)
					AND r.nm_end_mp > a.nm_begin_mp(+)
			;
		
	when 'OHMS_7_GET_TURN_1' then
			insert into OHMS_7_GET_TURN_1
			 
			select 
				SAMP_ID
				, route_id
				, min(nm_slk) nm_slk
				, max(nm_end_slk) nm_end_slk
				
				FROM (
					select a.SAMP_ID
						, a.NE_ID_OF
						, GREATEST(a.NM_BEGIN_MP, D.NM_BEGIN_MP) NM_BEGIN_MP
						, least(a.nm_end_mp, d.nm_end_mp) nm_end_mp
						, d.nm_cardinality
						, c.ne_unique route_id
							, CASE 
									when D.NM_CARDINALITY = 1 then
										d.nm_slk + (greatest(a.nm_begin_mp,d.nm_begin_mp) - d.nm_begin_mp)
									ELSE
											d.nm_slk + (d.nm_end_mp - least(d.nm_end_mp, a.nm_end_mp))
								END nm_slk
							, CASE 
									WHEN d.nm_cardinality = 1 THEN
										d.nm_end_slk - (d.nm_end_mp - least(d.nm_end_mp, a.nm_end_mp))
									ELSE
										d.nm_end_slk - (greatest(a.nm_begin_mp,d.nm_begin_mp) - d.nm_begin_mp)
								end NM_END_SLK
								
					from v_nm_OHMS_NW a
						--, nm_members_all b
						, nm_elements_all c
						, NM_MEMBERS_ALL D
						
					where rownum > 0
						AND c.ne_nt_type = 'HWY'
						AND c.ne_end_date IS NULL
						AND c.ne_id = d.nm_ne_id_in
						and D.NM_END_DATE is null
						and a.NE_ID_OF = D.NM_NE_ID_OF
						and D.NM_BEGIN_MP < a.NM_END_MP
						and D.NM_END_MP > a.NM_BEGIN_MP
						--and a.SAMP_ID = 3517						
						)			
			GROUP BY SAMP_ID, ROUTE_ID;
	
	when 'OHMS_7_GET_TURN_URBAN' then
			insert into OHMS_7_GET_TURN_URBAN  (                         
			select samp_id, count(*) Urban from (

				SELECT b.*, a.samp_id                
				from            
				(SELECT OHMS_7_GET_TURN_1.*, d.nm_ne_id_of
							  , case when D.NM_CARDINALITY = 1 then
								  case when D.NM_SLK < OHMS_7_GET_TURN_1.NM_SLK then
									  (OHMS_7_GET_TURN_1.nm_slk - d.nm_slk) + nm_begin_mp
								  ELSE
									  nm_begin_mp
								  END
								else
								  case when d.NM_END_SLK > OHMS_7_GET_TURN_1.NM_END_SLK then
									  nm_begin_mp + (d.nm_end_slk - OHMS_7_GET_TURN_1.nm_end_slk)
								  ELSE
									  nm_begin_mp
								  END
								END nm_begin_mp
							  , case when D.NM_CARDINALITY = 1 then
								  case when d.NM_END_SLK > OHMS_7_GET_TURN_1.NM_END_SLK then
									  nm_end_mp - (d.nm_end_slk - OHMS_7_GET_TURN_1.nm_end_slk)
								  ELSE
									  nm_end_mp
								  END
								else
								  case when d.NM_SLK < OHMS_7_GET_TURN_1.NM_SLK then
									  nm_end_mp - (OHMS_7_GET_TURN_1.nm_slk - d.nm_slk)
								  ELSE
									  nm_end_mp
								  END
								END nm_end_mp
						  FROM nm_elements_all c
							  , NM_MEMBERS_ALL D
							  , OHMS_7_GET_TURN_1
						  WHERE c.ne_unique = OHMS_7_GET_TURN_1.route_id
							  AND c.ne_id = d.nm_ne_id_in
							  AND c.ne_end_date IS NULL
							  and D.NM_END_DATE is null
							  and D.NM_END_SLK > OHMS_7_GET_TURN_1.NM_SLK
							  and D.NM_SLK <  OHMS_7_GET_TURN_1.NM_END_SLK
							  --and SAMP_ID = 3522
							  ) a
						,
							  
							  (SELECT nm_ne_id_in
					, nm_ne_id_of
					, nm_begin_mp
					, NM_END_MP
					--, nm_obj_type
				FROM nm_members_all 
				WHERE nm_obj_type = 'URBN'
					and NM_END_DATE is null) B
					
				where 

				a.nm_ne_id_of = b.nm_ne_id_of
				and B.NM_BEGIN_MP < a.NM_END_MP
				and B.NM_END_MP > a.NM_BEGIN_MP
			
			)

			group by SAMP_ID

			)

			;
	when 'V_NM_OHMS_TURN_NW' then
			insert into V_NM_OHMS_TURN_NW 
			select a.*, XNA_OHMS_GET_TLL(a.SAMP_ID) TLL,  XNA_OHMS_GET_TLR(a.SAMP_ID) TLR
			from V_NM_OHMS_NW a, OHMS_7_get_Turn_Urban B
			where 1=1			  
			and a.SAMP_ID = B.SAMP_ID  
			;
			
	when 'OHMS_GRADE1' then
			insert into OHMS_GRADE1
			(   SELECT samp_id
					, sample_iit_ne_id
					, ne_unique
					, nm_slk
					, nm_end_slk
					, nm_end_slk - nm_slk sample_length
				FROM (
					SELECT samp_id
						, sample_iit_ne_id
						, NE_UNIQUE
						, nm_slk slk
						, min(nm_slk) over (partition by samp_id) nm_slk
						, max(NM_END_SLK) over (partition by SAMP_ID) NM_END_SLK
					FROM (
						SELECT c.iit_ne_id sample_iit_ne_id
							, c.samp_id 
							, a.ne_unique
							, DECODE (b.nm_cardinality, 1, b.nm_slk + (GREATEST (NVL (c.nm_begin_mp, 0), b.nm_begin_mp)) - b.nm_begin_mp, 
									b.nm_slk + (b.nm_end_mp - LEAST (NVL (c.nm_end_mp, 9999), b.nm_end_mp)))nm_slk
							, DECODE (b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - LEAST (NVL (c.nm_end_mp, 9999), b.nm_end_mp)),
									b.nm_slk + (b.nm_end_mp - GREATEST (NVL (c.nm_begin_mp, 0), b.nm_begin_mp))) nm_end_slk
							, b.nm_ne_id_of ne_id_of
							, GREATEST (NVL (c.nm_begin_mp, 0), b.nm_begin_mp) nm_begin_mp
							, LEAST (NVL (c.nm_end_mp, 999), b.nm_end_mp) nm_end_mp
						FROM nm_elements_all a
							, nm_members_all b
							, v_nm_ohms_nw c

						WHERE a.ne_id = b.nm_ne_id_in
							AND a.ne_nt_type = 'HWY'
							AND a.ne_end_date IS NULL
							AND b.nm_end_date IS NULL

							AND c.ne_id_of = b.nm_ne_id_of
							AND b.nm_begin_mp < c.nm_end_mp
							and B.NM_END_MP > C.NM_BEGIN_MP
							)
						   )
						WHERE slk = nm_slk

				);
	
	When 'OHMS_GRADE2' Then
			insert into OHMS_GRADE2 
			(
			SELECT iit_ne_id 
				, grade_type
				, ne_unique
				, nm_slk
				, NM_END_SLK
			FROM (
			   
			   
				SELECT c.iit_ne_id
					, a.ne_unique
				   , case 
					  WHEN round(abs(c.iit_num_attrib103),1) between 0.5 and 2.4 THEN
						'GRADE_B'
					  WHEN round(abs(c.iit_num_attrib103),1) between 2.5 and 4.4 THEN
						'GRADE_C'
					  WHEN round(abs(c.iit_num_attrib103),1) between 4.5 and 6.4 THEN
						'GRADE_D'
					  WHEN round(abs(c.iit_num_attrib103),1) between 6.5 and 8.4  THEN
						'GRADE_E'
					  WHEN round(abs(c.iit_num_attrib103),1) > 8.5  THEN
						'GRADE_F' 
					  ELSE
						'GRADE_A'
					  END grade_type
					
					, (DECODE (b.nm_cardinality, 1, b.nm_slk + (GREATEST (NVL (d.nm_begin_mp, 0), b.nm_begin_mp)) - b.nm_begin_mp, 
							b.nm_slk + (b.nm_end_mp - LEAST (NVL (d.nm_end_mp, 9999), b.nm_end_mp))))
							- round(((c.iit_num_attrib102 * 0.000189393939)/2),3) nm_slk
					, (DECODE (b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - LEAST (NVL (d.nm_end_mp, 9999), b.nm_end_mp)),
							b.nm_slk + (b.nm_end_mp - GREATEST (NVL (d.nm_begin_mp, 0), b.nm_begin_mp))))
							+ round(((c.iit_num_attrib102 * 0.000189393939)/2),3) nm_end_slk
			   
				FROM nm_elements_all a
					, nm_members_all b
					, nm_inv_items_all c
					, nm_members_all d
				WHERE a.ne_id = b.nm_ne_id_in
					AND a.ne_nt_type = 'HWY'
					AND a.ne_end_date IS NULL
					AND b.nm_end_date IS NULL
					AND c.iit_ne_id = d.nm_ne_id_in
					AND c.iit_inv_type = 'VRTG'
					AND c.iit_end_date IS NULL
					AND d.nm_end_date IS NULL
					AND d.nm_ne_id_of = b.nm_ne_id_of
					and B.NM_BEGIN_MP <= D.NM_BEGIN_MP
					and B.NM_END_MP >= D.NM_END_MP
					)
			)
			;
	
	when 'OHMS_TMP_7_610_RDGM' Then
			insert into OHMS_TMP_7_610_RDGM
			SELECT * FROM 
			v_nm_RDGM_nw
			WHERE 1=1 
			AND LAYER =1
			AND LN_MEDN_TYP_CD =1
			AND IIT_X_SECT LIKE 'LN%'
			;
	when 'OHMS_TMP_7_610_RTE_ITEM' then
			insert into OHMS_TMP_7_610_RTE_ITEM
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_d
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;
	when 'OHMS_TMP_RTE_7_610_RDGM' then 
			insert into OHMS_TMP_RTE_7_610_RDGM
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_610_RDGM a
			, OHMS_TMP_7_610_RTE_ITEM l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;
	
	when 'OHMS_TMP_SEG_7_610_RDGM' then
			insert into OHMS_tmp_seg_7_610_rdgm
			SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_610_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_610_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;
			
	when 'OHMS_TMP_DETAIL_7_610_RDGM' then
			insert into OHMS_TMP_DETAIL_7_610_RDGM 
			SELECT 
				ln_medn_typ_cd
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_610_rdgm l
				, OHMS_tmp_rte_7_610_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
				
	when 'V_NM_RDGM610_COUNT_MV_NW' then
			insert into V_NM_RDGM610_COUNT_MV_NW
			SELECT 
				count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_610_RDGM 
			GROUP BY 
						NE_UNIQUE
				, nm_slk
				, nm_end_slk;
	when 'OHMS_TMP_7_611_RDGM' then
			insert into OHMS_TMP_7_611_RDGM
			SELECT * FROM 
			v_nm_RDGM_nw
			WHERE 1=1 
			AND LAYER =1
			AND LN_MEDN_TYP_CD =1
			AND IIT_X_SECT LIKE 'LN%'
			;
	when 'OHMS_TMP_7_611_RTE_ITEM' then
			insert into OHMS_TMP_7_611_RTE_ITEM
			SELECT * FROM 
			v_nm_hwy_nt
			, nm_members_d
			WHERE 1=1 
			AND ne_id = nm_ne_id_in
			AND NE_UNIQUE IS NOT NULL
			;
				
			
	when 'OHMS_TMP_RTE_7_611_RDGM' then
			insert into OHMS_TMP_RTE_7_611_RDGM
			SELECT  l.NE_UNIQUE
				, l.nm_cardinality
				, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
				, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
				, a.*
			FROM OHMS_TMP_7_611_RDGM a
			, OHMS_TMP_7_611_RTE_ITEM l 
			WHERE 1=1
			AND l.nm_ne_id_of= a.ne_id_of
			AND l.nm_begin_mp < a.nm_end_mp
			AND l.nm_end_mp    > a.nm_begin_mp;
			
	when 'OHMS_TMP_SEG_7_611_RDGM' then
			insert into OHMS_TMP_SEG_7_611_RDGM
			SELECT DISTINCT NE_UNIQUE
				, nm_slk
				, nm_end_slk
			FROM (
						SELECT NE_UNIQUE
					 , mp nm_slk
								  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
										  lead(mp) over(order by  NE_UNIQUE, mp)
					 ELSE
						 -99
					 END nm_end_slk
				 FROM ( 
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_tmp_rte_7_611_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_tmp_rte_7_611_rdgm
					 UNION
					 SELECT ne_unique
					 , nm_slk mp
					 FROM OHMS_7_network_mv
					 UNION
					 SELECT ne_unique
					 , nm_end_slk mp
					 FROM OHMS_7_network_mv
					  ))
			WHERE nm_end_slk > -99;
			
	when 'OHMS_TMP_DETAIL_7_611_RDGM' then
			insert into OHMS_TMP_DETAIL_7_611_RDGM
			SELECT 
				ln_medn_typ_cd
						, l.NE_UNIQUE
				, l.nm_slk
				, l.nm_end_slk
				FROM OHMS_tmp_seg_7_611_rdgm l
				, OHMS_tmp_rte_7_611_rdgm a
			WHERE 1=1
				AND l.ne_unique = a.ne_unique
				AND l.nm_slk < a.nm_end_slk
				AND l.nm_end_slk > a.nm_slk
				;
			
	when 'V_NM_RDGM611_COUNT_MV_NW' then
			insert into V_NM_RDGM611_COUNT_MV_NW
			SELECT 
				count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
						, NE_UNIQUE
				, nm_slk
				, nm_end_slk
				FROM OHMS_TMP_DETAIL_7_611_RDGM 
			GROUP BY 
						NE_UNIQUE
				, nm_slk
				, nm_end_slk;

	--when '' then
	
	
  else
    raise E_incorrect;
  end case;

        select HPMS_HAL_ID.NEXTVAL into T_HAL_ID from DUAL;

        insert into OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS', t_error_desc);
        COMMIT;



/***************************************************************
   Procedure Exception/End
***************************************************************/

EXCEPTION

when E_INCORRECT then 

        T_ERROR             := 'Item Not Found';
        t_error_desc        := 'Unknown Table:' ||P_NAME;
        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID
                , HAL_DATE
                , HAL_USER
                , HAL_TABLE_ID
                , HAL_STATUS
                , HAL_ERROR
                , HAL_MESSAGE)
        VALUES (t_hal_id
                , t_sysdate
                , t_user
                , t_table_id
                , 'ERROR'
                , t_error
                , T_ERROR_DESC);
        COMMIT;

WHEN OTHERS THEN
        T_ERROR             := SQLCODE;
        t_error_desc        := ''; --substr(sqlerrm,1,400);

        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID
                , HAL_DATE
                , HAL_USER
                , HAL_TABLE_ID
                , HAL_STATUS
                , HAL_ERROR
                , HAL_MESSAGE)
        VALUES (t_hal_id
                , t_sysdate
                , t_user
                , t_table_id
                , 'ERROR'
                , t_error
                , t_error_desc);
        COMMIT;

END;

/