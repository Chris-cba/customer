CREATE TABLE "TRANSINFO"."OHMS_ACTIVITY_LOG" 
   ("HAL_ID" NUMBER, 
	"HAL_DATE" DATE, 
	"HAL_USER" VARCHAR2(100 BYTE), 
	"HAL_ITEM" VARCHAR2(100 BYTE), 
	"HAL_TABLE_ID" NUMBER, 
	"HAL_ERROR" VARCHAR2(100 BYTE), 
	"HAL_MESSAGE" VARCHAR2(4000 BYTE), 
	"HAL_STATUS" VARCHAR2(100 BYTE)
   );

CREATE TABLE OHMS_SUBMIT_SAMPLES
	(
	SAMPLE_ID       VARCHAR2(14 BYTE),
	SECTION_LENGTH  NUMBER(8,3),
	END_POINT       NUMBER(8,3),
	BEGIN_POINT     NUMBER(8,3),
	ROUTE_ID        VARCHAR2(32 BYTE),
	STATE_CODE      NUMBER(2),
	YEAR_RECORD     NUMBER(4),
	FACL			NUMBER(3)
);

CREATE TABLE OHMS_SUBMIT_SECTIONS
    (YEAR_RECORD NUMBER(4)
    ,STATE_CODE NUMBER(2)
    ,ROUTE_ID VARCHAR2(32)
    ,BEGIN_POINT NUMBER(8,3)
    ,END_POINT NUMBER(8,3)
    ,DATA_ITEM VARCHAR2(25)
    ,SECTION_LENGTH NUMBER(8,3)
    ,VALUE_NUMERIC NUMBER
    ,VALUE_TEXT VARCHAR2(50)
    ,VALUE_DATE DATE
    ,COMMENTS VARCHAR2(50)	
    );
	
CREATE TABLE TRANSINFO.V_NM_OHMS_NW
(
  IIT_NE_ID        NUMBER,
  IIT_PRIMARY_KEY  NUMBER,
  SAMP_ID          NUMBER, 
  NE_ID_OF         NUMBER                       NOT NULL,
  NM_BEGIN_MP      NUMBER                       NOT NULL,
  NM_END_MP        NUMBER                       NOT NULL,
  DATA_YR 			NUMBER(6),
  FACL				NUMBER(3),
  ROUTE_ID	 		VARCHAR2(32 BYTE)
);

----------**********------------


CREATE TABLE OHMS_7_NETWORK_MV AS 
	select 
		--  Applies the requirement for FACL = 1,2,3
		b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk
		FROM V_NM_HWY_NT a
			, nm_members b
			, NM_ELEMENTS C
			, NM_MEMBERS D
			, NM_INV_ITEMS E
		   
		WHERE 1=2
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


CREATE TABLE OHMS_7_NETWORK_MV2 AS 
	select 
    --  Applies the requirement for FACL = 1,2,3,6
    b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk
    FROM V_NM_HWY_NT a
        , nm_members b
        , NM_ELEMENTS C
        , NM_MEMBERS D
        , NM_INV_ITEMS E
       
    WHERE 1=2
		and a.ne_id = b.nm_ne_id_in 
        and B.NM_NE_ID_OF = C.NE_ID
        and C.NE_ID = D.NM_NE_ID_OF
        and D.NM_NE_ID_IN = E.IIT_NE_ID
        and B.NM_OBJ_TYPE = 'HWY'
        and D.NM_OBJ_TYPE = 'FACL'        
        and E.iit_num_attrib100 in (1, 2, 3, 6)
        AND b.nm_type = 'G'
        and C.NE_TYPE = 'S'
        and a.MILEAGE_TYPE <> 'P';


CREATE TABLE v_nm_urbn502_outer_mv_nt AS
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
				1=2
				and r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE TABLE v_nm_nbi504_outer_mv_nw AS
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
        WHERE 1=2
				and r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;


CREATE TABLE v_nm_tunl504_outer_mv_nw AS
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
				1=2
				and r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;



/*********************************************************************************
    Aggregate Temp Tables for data item:  Through_Lanes
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_507_RDGM AS 
	SELECT * FROM 
		v_nm_RDGM_nw
	WHERE 1=2
		AND IIT_X_SECT LIKE 'LN%'
		AND LAYER =1
		AND LN_MEDN_TYP_CD IN(1,2,3)
	;

CREATE TABLE OHMS_TMP__7_507_RTE_ITEM_HWY AS 
	SELECT * FROM 
		v_nm_hwy_nt
		, nm_members_d
	WHERE 1=2 
		AND ne_id = nm_ne_id_in
		AND NE_UNIQUE IS NOT NULL
	;

CREATE TABLE OHMS_TMP_RTE_7_507_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_507_RDGM a
	, OHMS_TMP__7_507_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;


CREATE TABLE OHMS_tmp_seg_7_507_rdgm AS
        SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
		FROM (
					SELECT NE_UNIQUE
				 , mp nm_slk
							  , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
									  lead(mp) over(order by  NE_UNIQUE, mp)
				 ELSE
					 -1
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
		WHERE 	
				1=2
				AND nm_end_slk > -1;


CREATE TABLE OHMS_TMP_DETAIL_7_507_RDGM AS
    SELECT 
        ln_medn_typ_cd
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_507_rdgm l
        , OHMS_tmp_rte_7_507_rdgm a
    WHERE 
		1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;

CREATE TABLE v_nm_rdgm507_count_mv_nw AS
    SELECT 
        count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_507_RDGM 
		WHERE 1=2
    GROUP BY 
          NE_UNIQUE
        , nm_slk
        , nm_end_slk;


/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  HOV_Type
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_508_RDGM AS 
	SELECT * FROM 
	v_nm_RDGM_nw
	WHERE 1=2 
	AND IIT_X_SECT LIKE 'LN%'
	AND LAYER =1
	AND LN_MEDN_TYP_CD = 3
	;

CREATE TABLE OHMS_TMP_7_508_RTE_ITEM_HWY AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_d
	WHERE 1=2 
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;

CREATE TABLE OHMS_TMP_RTE_7_508_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_508_RDGM a
	, OHMS_TMP_7_508_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;

CREATE TABLE OHMS_tmp_seg_7_508_rdgm AS
    SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 1=2
		and nm_end_slk > -1;

CREATE TABLE OHMS_TMP_DETAIL_7_508_RDGM AS
    SELECT 
        ln_medn_typ_cd
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_508_rdgm l
        , OHMS_tmp_rte_7_508_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;

CREATE TABLE v_nm_rdgm508_min_mv_nw AS
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


/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  HOV_LANES
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_509_RDGM AS 
	SELECT * FROM 
	v_nm_RDGM_nw
	WHERE 1=2 
	AND IIT_X_SECT LIKE 'LN%'
	AND LAYER = 1
	AND LN_MEDN_TYP_CD = 3
	;

CREATE TABLE OHMS_TMP_7_509_RTE_ITEM_HWY AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_d
	WHERE 1=2
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;


CREATE TABLE OHMS_TMP_RTE_7_509_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_509_RDGM a
	, OHMS_TMP_7_509_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;

CREATE TABLE OHMS_tmp_seg_7_509_rdgm AS
	SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 1=2
		and nm_end_slk > -1;

CREATE TABLE OHMS_TMP_DETAIL_7_509_RDGM AS
    SELECT 
        ln_medn_typ_cd
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_509_rdgm l
        , OHMS_tmp_rte_7_509_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;

CREATE TABLE v_nm_rdgm509_count_mv_nw AS
    SELECT 
        count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_509_RDGM 
		where 1=2
    GROUP BY 
                NE_UNIQUE
        , nm_slk
        , nm_end_slk;

/********************************************************************************/

CREATE TABLE v_nm_urbn510_outer_mv_nt AS
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
        WHERE	1=2
				AND r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE TABLE v_nm_spzn514_outer_mv_nw AS
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
				1=2
				AND r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;


CREATE TABLE v_nm_urbn514_outer_mv_nt AS
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
				1=2
				AND r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;




/*********************************************************************************
    Aggregate Temp Tables for data item:  Shoulder_Width_R
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_538_RDGM AS 
	SELECT * FROM 
		v_nm_RDGM_nw
	WHERE 1=2 
		AND LAYER =1
		AND IIT_X_SECT IN ('OS1I','OS2I') 
	;

CREATE TABLE OHMS_TMP_7_538_RTE_ITEM_HWY AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_i
	WHERE 1=2
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;


CREATE TABLE OHMS_TMP_RTE_7_538_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_538_RDGM a
	, OHMS_TMP_7_538_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;


CREATE TABLE OHMS_tmp_seg_7_538_rdgm AS
	SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 
		1=2
		AND nm_end_slk > -1;

CREATE TABLE OHMS_TMP_DETAIL_7_538_RDGM AS
    SELECT 
        wd_meas
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_538_rdgm l
        , OHMS_tmp_rte_7_538_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;


CREATE TABLE v_nm_rdgm538_sum_mv_nw AS
    SELECT 
        sum(WD_MEAS) WD_MEAS
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_538_RDGM 
		WHERE 1=2
    GROUP BY 
          NE_UNIQUE
        , nm_slk
        , nm_end_slk;

/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  Shoulder_Width_L
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_539_RDGM AS 
	SELECT * FROM 
	v_nm_RDGM_nw
	WHERE 1=2 
	AND LAYER =1
	AND IIT_X_SECT IN('IS1I','IS2I')   
	;


CREATE TABLE OHMS_TMP_7_539_RTE_ITEM_HWY AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_i
	WHERE 1=2 
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;

CREATE TABLE OHMS_TMP_RTE_7_539_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_539_RDGM a
	, OHMS_TMP_7_539_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;

 

CREATE TABLE OHMS_tmp_seg_7_539_rdgm AS
    SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 
		1=2
		AND nm_end_slk > -1;


CREATE TABLE OHMS_TMP_DETAIL_7_539_RDGM AS
    SELECT 
        wd_meas
        , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_539_rdgm l
        , OHMS_tmp_rte_7_539_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;


CREATE TABLE v_nm_rdgm539_sum_mv_nw AS
    SELECT 
        sum(WD_MEAS) WD_MEAS
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_539_RDGM 
		WHERE 1=2
    GROUP BY 
                NE_UNIQUE
        , nm_slk
        , nm_end_slk;


/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  Peak_Park_Right
*********************************************************************************/

CREATE TABLE OHMS_TMP_7_540_PRKR AS 
	SELECT * FROM 
	v_nm_PRKR_nw
	WHERE 1=2
	;


CREATE TABLE OHMS_TMP_7_540_RTE_ITEM_HWY AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_d
	WHERE 1=2 
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;



CREATE TABLE OHMS_TMP_RTE_7_540_PRKR AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_540_PRKR a
	, OHMS_TMP_7_540_RTE_ITEM_HWY l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;



CREATE TABLE OHMS_tmp_seg_7_540_prkr AS
    SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 
		1=2
		AND nm_end_slk > -1;

CREATE TABLE OHMS_TMP_DETAIL_7_540_PRKR AS
    SELECT 
        iit_x_sect
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_540_prkr l
        , OHMS_tmp_rte_7_540_prkr a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;


CREATE TABLE v_nm_prkr540_count_mv_nw AS
    SELECT 
        count(IIT_X_SECT) IIT_X_SECT
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_540_PRKR 
		WHERE 1=2
    GROUP BY 
                NE_UNIQUE
        , nm_slk
        , nm_end_slk;

/********************************************************************************/
 
CREATE TABLE v_nm_seea566_outer_mv_nt AS
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
					  ,a.NE_NAME_2 CREW
				 from NM_ELEMENTS a
				 WHERE a.ne_nt_type = 'SEEA'
				)
                , nm_members 
            WHERE
               ne_id = nm_ne_id_in
            ) a 
        WHERE	1=2
				AND r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;
/* ********************************************************************* */

Create table OHMS_7_get_Turn_1 as
     
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
        Where 1=2
                
        GROUP BY SAMP_ID, ROUTE_ID;
        

create table OHMS_7_get_Turn_Urban as (                         
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
            --and rownum < 3
            )
            
			where 1=2
            group by SAMP_ID
            
            )
            
            ;
  
create table OHMS_GRADE1 as
(                    SELECT samp_id
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

                            WHERE 1=2
								AND a.ne_id = b.nm_ne_id_in
                                AND a.ne_nt_type = 'HWY'
                                AND a.ne_end_date IS NULL
                                AND b.nm_end_date IS NULL

                                AND c.ne_id_of = b.nm_ne_id_of
                                AND b.nm_begin_mp < c.nm_end_mp
                                and B.NM_END_MP > C.NM_BEGIN_MP
                                )
                               )
                            WHERE 1=2 and slk = nm_slk

);

create table OHMS_Grade2 as (
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
		WHERE 1=2
			AND a.ne_id = b.nm_ne_id_in
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
		where 1=2
)
;

/*********************************************************************************
    Aggregate Temp Tables for data item:  Peak_Lanes
*********************************************************************************/
CREATE TABLE OHMS_TMP_7_610_RDGM AS 
	SELECT * FROM 
	v_nm_RDGM_nw
	WHERE 1=2 
	AND LAYER =1
	AND LN_MEDN_TYP_CD =1
	AND IIT_X_SECT LIKE 'LN%'
	;

CREATE TABLE OHMS_TMP_7_610_RTE_ITEM AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_d
	WHERE 1=2
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;

CREATE TABLE OHMS_TMP_RTE_7_610_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_610_RDGM a
	, OHMS_TMP_7_610_RTE_ITEM l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;

CREATE TABLE OHMS_tmp_seg_7_610_rdgm AS
        SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 1=2 and nm_end_slk > -1;

CREATE TABLE OHMS_TMP_DETAIL_7_610_RDGM AS
    SELECT 
        ln_medn_typ_cd
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_610_rdgm l
        , OHMS_tmp_rte_7_610_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;

CREATE TABLE v_nm_rdgm610_count_mv_nw AS
    SELECT 
        count(LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
                , NE_UNIQUE
        , nm_slk
        , nm_end_slk
        FROM OHMS_TMP_DETAIL_7_610_RDGM
		Where 1=2
    GROUP BY 
		  NE_UNIQUE
        , nm_slk
        , nm_end_slk;

/*********************************************************************************
    Aggregate Temp Tables for data item:  Counter_Peak_Lanes
*********************************************************************************/
CREATE TABLE OHMS_TMP_7_611_RDGM AS 
	SELECT * FROM 
	v_nm_RDGM_nw
	WHERE 1=2 
	AND LAYER =1
	AND LN_MEDN_TYP_CD =1
	AND IIT_X_SECT LIKE 'LN%'
	;

CREATE TABLE OHMS_TMP_7_611_RTE_ITEM AS 
	SELECT * FROM 
	v_nm_hwy_nt
	, nm_members_d
	WHERE 1=2 
	AND ne_id = nm_ne_id_in
	AND NE_UNIQUE IS NOT NULL
	;


CREATE TABLE OHMS_TMP_RTE_7_611_RDGM AS
	SELECT  l.NE_UNIQUE
		, l.nm_cardinality
		, decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
		, decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
		, a.*
	FROM OHMS_TMP_7_611_RDGM a
	, OHMS_TMP_7_611_RTE_ITEM l 
	WHERE 1=2
	AND l.nm_ne_id_of= a.ne_id_of
	AND l.nm_begin_mp < a.nm_end_mp
	AND l.nm_end_mp    > a.nm_begin_mp;
	
CREATE TABLE OHMS_tmp_seg_7_611_rdgm AS
        SELECT DISTINCT NE_UNIQUE
        , nm_slk
        , nm_end_slk
    FROM (
                SELECT NE_UNIQUE
             , mp nm_slk
                          , CASE WHEN ne_unique = lead( NE_UNIQUE) over (order by  NE_UNIQUE, mp) THEN
                                  lead(mp) over(order by  NE_UNIQUE, mp)
             ELSE
                 -1
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
    WHERE 1=2 and nm_end_slk > -1;
	
CREATE TABLE OHMS_TMP_DETAIL_7_611_RDGM AS
    SELECT 
        ln_medn_typ_cd
                , l.NE_UNIQUE
        , l.nm_slk
        , l.nm_end_slk
        FROM OHMS_tmp_seg_7_611_rdgm l
        , OHMS_tmp_rte_7_611_rdgm a
    WHERE 1=2
        AND l.ne_unique = a.ne_unique
        AND l.nm_slk < a.nm_end_slk
        AND l.nm_end_slk > a.nm_slk
        ;

CREATE TABLE v_nm_rdgm611_count_mv_nw AS
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
	