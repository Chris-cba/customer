DROP TABLE OHMS_7_NETWORK_MV;

CREATE TABLE OHMS_7_NETWORK_MV AS 
select 
    --  Applies the requirement for FACL = 1,2,3
    b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk
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
        and E.iit_num_attrib100 in (1, 2, 3)
        AND b.nm_type = 'G'
        and C.NE_TYPE = 'S'
        and a.MILEAGE_TYPE <> 'P';

CREATE INDEX OHMS_7_NETWORK_MV_IDX ON OHMS_7_NETWORK_MV(NE_ID_OF);

DROP TABLE OHMS_7_NETWORK_MV2;

CREATE TABLE OHMS_7_NETWORK_MV2 AS 
select 
    --  Applies the requirement for FACL = 1,2,3,6
    b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk
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

CREATE INDEX OHMS_7_NETWORK_MV2_IDX ON OHMS_7_NETWORK_MV2(NE_ID_OF);

DROP TABLE v_nm_urbn502_outer_mv_nt;

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
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_urbn502_outer_mv_nt_IDX ON v_nm_urbn502_outer_mv_nt(NE_ID_OF);


DROP TABLE v_nm_urbn502_outer_mv_nt;

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
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_urbn502_outer_mv_nt_IDX ON v_nm_urbn502_outer_mv_nt(NE_ID_OF);


DROP TABLE v_nm_nbi504_outer_mv_nw;

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
        WHERE
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_nbi504_outer_mv_nw_IDX ON v_nm_nbi504_outer_mv_nw(NE_ID_OF);


DROP TABLE v_nm_tunl504_outer_mv_nw;

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
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_tunl504_outer_mv_nw_IDX ON v_nm_tunl504_outer_mv_nw(NE_ID_OF);


/*********************************************************************************
    Aggregate Temp Tables for data item:  Through_Lanes
*********************************************************************************/
DROP TABLE OHMS_TMP_7_507_RDGM;
CREATE TABLE OHMS_TMP_7_507_RDGM AS 
SELECT * FROM 
v_nm_RDGM_nw
WHERE 1=1 
AND IIT_X_SECT LIKE 'LN%'
AND LAYER =1
AND LN_MEDN_TYP_CD IN(1,2,3)
;
CREATE INDEX OHMS_TMP_7_507_RDGM_IDX ON OHMS_TMP_7_507_RDGM(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_d
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_507_RDGM;

CREATE TABLE OHMS_TMP_RTE_7_507_RDGM AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_507_RDGM a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_507_RDGM_IDX ON OHMS_TMP_RTE_7_507_RDGM(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_507_rdgm;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_507_rdgm_idx ON OHMS_tmp_seg_7_507_rdgm
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_507_RDGM;
 

CREATE TABLE OHMS_TMP_DETAIL_7_507_RDGM AS
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
DROP TABLE v_nm_rdgm507_count_mv_nw;

CREATE TABLE v_nm_rdgm507_count_mv_nw AS
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

DROP TABLE OHMS_TMP_RTE_7_507_RDGM;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_507_RDGM;
DROP TABLE OHMS_TMP_SEG_7_507_RDGM;
DROP TABLE OHMS_TMP_DETAIL_7_507_RDGM;

/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  HOV_Type
*********************************************************************************/
DROP TABLE OHMS_TMP_7_508_RDGM;
CREATE TABLE OHMS_TMP_7_508_RDGM AS 
SELECT * FROM 
v_nm_RDGM_nw
WHERE 1=1 
AND IIT_X_SECT LIKE 'LN%'
AND LAYER =1
AND LN_MEDN_TYP_CD = 3
;
CREATE INDEX OHMS_TMP_7_508_RDGM_IDX ON OHMS_TMP_7_508_RDGM(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_d
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_508_RDGM;

CREATE TABLE OHMS_TMP_RTE_7_508_RDGM AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_508_RDGM a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_508_RDGM_IDX ON OHMS_TMP_RTE_7_508_RDGM(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_508_rdgm;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_508_rdgm_idx ON OHMS_tmp_seg_7_508_rdgm
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_508_RDGM;
 

CREATE TABLE OHMS_TMP_DETAIL_7_508_RDGM AS
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
DROP TABLE v_nm_rdgm508_min_mv_nw;

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

DROP TABLE OHMS_TMP_RTE_7_508_RDGM;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_508_RDGM;
DROP TABLE OHMS_TMP_SEG_7_508_RDGM;
DROP TABLE OHMS_TMP_DETAIL_7_508_RDGM;

/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  HOV_LANES
*********************************************************************************/
DROP TABLE OHMS_TMP_7_509_RDGM;
CREATE TABLE OHMS_TMP_7_509_RDGM AS 
SELECT * FROM 
v_nm_RDGM_nw
WHERE 1=1 
AND IIT_X_SECT LIKE 'LN%'
AND LAYER = 1
AND LN_MEDN_TYP_CD = 3
;
CREATE INDEX OHMS_TMP_7_509_RDGM_IDX ON OHMS_TMP_7_509_RDGM(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_d
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_509_RDGM;

CREATE TABLE OHMS_TMP_RTE_7_509_RDGM AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_509_RDGM a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_509_RDGM_IDX ON OHMS_TMP_RTE_7_509_RDGM(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_509_rdgm;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_509_rdgm_idx ON OHMS_tmp_seg_7_509_rdgm
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_509_RDGM;
 

CREATE TABLE OHMS_TMP_DETAIL_7_509_RDGM AS
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
DROP TABLE v_nm_rdgm509_count_mv_nw;

CREATE TABLE v_nm_rdgm509_count_mv_nw AS
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

DROP TABLE OHMS_TMP_RTE_7_509_RDGM;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_509_RDGM;
DROP TABLE OHMS_TMP_SEG_7_509_RDGM;
DROP TABLE OHMS_TMP_DETAIL_7_509_RDGM;

/********************************************************************************/
 


DROP TABLE v_nm_urbn510_outer_mv_nt;

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
        WHERE
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_urbn510_outer_mv_nt_IDX ON v_nm_urbn510_outer_mv_nt(NE_ID_OF);


DROP TABLE v_nm_spzn514_outer_mv_nw;

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
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_spzn514_outer_mv_nw_IDX ON v_nm_spzn514_outer_mv_nw(NE_ID_OF);


DROP TABLE v_nm_urbn514_outer_mv_nt;

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
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_urbn514_outer_mv_nt_IDX ON v_nm_urbn514_outer_mv_nt(NE_ID_OF);


/*********************************************************************************
    Aggregate Temp Tables for data item:  Shoulder_Width_R
*********************************************************************************/
DROP TABLE OHMS_TMP_7_538_RDGM;
CREATE TABLE OHMS_TMP_7_538_RDGM AS 
SELECT * FROM 
v_nm_RDGM_nw
WHERE 1=1 
AND LAYER =1
AND IIT_X_SECT IN ('OS1I','OS2I') 
;
CREATE INDEX OHMS_TMP_7_538_RDGM_IDX ON OHMS_TMP_7_538_RDGM(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_i
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_538_RDGM;

CREATE TABLE OHMS_TMP_RTE_7_538_RDGM AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_538_RDGM a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_538_RDGM_IDX ON OHMS_TMP_RTE_7_538_RDGM(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_538_rdgm;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_538_rdgm_idx ON OHMS_tmp_seg_7_538_rdgm
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_538_RDGM;
 

CREATE TABLE OHMS_TMP_DETAIL_7_538_RDGM AS
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
DROP TABLE v_nm_rdgm538_sum_mv_nw;

CREATE TABLE v_nm_rdgm538_sum_mv_nw AS
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

DROP TABLE OHMS_TMP_RTE_7_538_RDGM;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_538_RDGM;
DROP TABLE OHMS_TMP_SEG_7_538_RDGM;
DROP TABLE OHMS_TMP_DETAIL_7_538_RDGM;

/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  Shoulder_Width_L
*********************************************************************************/
DROP TABLE OHMS_TMP_7_539_RDGM;
CREATE TABLE OHMS_TMP_7_539_RDGM AS 
SELECT * FROM 
v_nm_RDGM_nw
WHERE 1=1 
AND LAYER =1
AND IIT_X_SECT IN('IS1I','IS2I')   
;
CREATE INDEX OHMS_TMP_7_539_RDGM_IDX ON OHMS_TMP_7_539_RDGM(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_i
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_539_RDGM;

CREATE TABLE OHMS_TMP_RTE_7_539_RDGM AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_539_RDGM a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_539_RDGM_IDX ON OHMS_TMP_RTE_7_539_RDGM(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_539_rdgm;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_539_rdgm_idx ON OHMS_tmp_seg_7_539_rdgm
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_539_RDGM;
 

CREATE TABLE OHMS_TMP_DETAIL_7_539_RDGM AS
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
DROP TABLE v_nm_rdgm539_sum_mv_nw;

CREATE TABLE v_nm_rdgm539_sum_mv_nw AS
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

DROP TABLE OHMS_TMP_RTE_7_539_RDGM;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_539_RDGM;
DROP TABLE OHMS_TMP_SEG_7_539_RDGM;
DROP TABLE OHMS_TMP_DETAIL_7_539_RDGM;

/********************************************************************************/
 


/*********************************************************************************
    Aggregate Temp Tables for data item:  Peak_Park_Right
*********************************************************************************/
DROP TABLE OHMS_TMP_7_540_PRKR;
CREATE TABLE OHMS_TMP_7_540_PRKR AS 
SELECT * FROM 
v_nm_PRKR_nw
WHERE 1=1 
;
CREATE INDEX OHMS_TMP_7_540_PRKR_IDX ON OHMS_TMP_7_540_PRKR(ne_id_of);


DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
CREATE TABLE OHMS_TMP_RTE_ITEM_HWY AS 
SELECT * FROM 
v_nm_hwy_nt
, nm_members_d
WHERE 1=1 
AND ne_id = nm_ne_id_in
AND NE_UNIQUE IS NOT NULL
;

CREATE INDEX OHMS_TMP_RTE_ITEM_HWY_IDX ON OHMS_TMP_RTE_ITEM_HWY(NE_UNIQUE);

 

DROP TABLE OHMS_TMP_RTE_7_540_PRKR;

CREATE TABLE OHMS_TMP_RTE_7_540_PRKR AS
SELECT  l.NE_UNIQUE
    , l.nm_cardinality
    , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) nm_slk
    , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) nm_end_slk
    , a.*
FROM OHMS_TMP_7_540_PRKR a
, OHMS_TMP_RTE_ITEM_HWY l 
WHERE 1=1
AND l.nm_ne_id_of= a.ne_id_of
AND l.nm_begin_mp < a.nm_end_mp
AND l.nm_end_mp    > a.nm_begin_mp;

CREATE INDEX OHMS_TMP_RTE_7_540_PRKR_IDX ON OHMS_TMP_RTE_7_540_PRKR(NE_UNIQUE);


 

DROP TABLE OHMS_tmp_seg_7_540_prkr;
 

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
    WHERE nm_end_slk > -1;

        CREATE INDEX OHMS_tmp_seg_7_540_prkr_idx ON OHMS_tmp_seg_7_540_prkr
        (NE_UNIQUE);
 

DROP TABLE OHMS_TMP_DETAIL_7_540_PRKR;
 

CREATE TABLE OHMS_TMP_DETAIL_7_540_PRKR AS
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
DROP TABLE v_nm_prkr540_count_mv_nw;

CREATE TABLE v_nm_prkr540_count_mv_nw AS
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

DROP TABLE OHMS_TMP_RTE_7_540_PRKR;
DROP TABLE OHMS_TMP_RTE_ITEM_HWY;
DROP TABLE OHMS_TMP_7_540_PRKR;
DROP TABLE OHMS_TMP_SEG_7_540_PRKR;
DROP TABLE OHMS_TMP_DETAIL_7_540_PRKR;

/********************************************************************************/
 
DROP TABLE v_nm_seea566_outer_mv_nt;

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
                v_nm_seea_nt
                , nm_members 
            WHERE
               ne_id = nm_ne_id_in
            ) a 
        WHERE
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_seea566_outer_mv_nt_IDX ON v_nm_seea566_outer_mv_nt(NE_ID_OF);


