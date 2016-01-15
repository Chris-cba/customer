CREATE OR REPLACE PROCEDURE TRANSINFO.XODOT_POPULATE_OHMS_SECTIONS IS

-- v5.1
-- Standard Error Reporting Variables
t_error                 VARCHAR2(200);
t_error_desc            VARCHAR2(200);
t_error_msg             VARCHAR2(300);
t_item_processing       VARCHAR2(10);
t_hal_id                NUMBER;
t_table_id              NUMBER;

t_sysdate               DATE;
t_user                  VARCHAR2(32);
t_target_table_name     HPMS_PROCEDURE.HP_DB_TABLE_NAME%TYPE;
is_complete         exception;



CURSOR CUR_107 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_ln_medn_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(rdgm_ln_medn_typ_cd) rdgm_ln_medn_typ_cd
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_ln_medn_typ_cd
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_ln_medn_typ_cd
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm107_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members_extended b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );


CURSOR CUR_109 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_ln_medn_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(rdgm_ln_medn_typ_cd) rdgm_ln_medn_typ_cd
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_ln_medn_typ_cd
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_ln_medn_typ_cd
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm109_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );


CURSOR CUR_110 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_ln_medn_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(rdgm_ln_medn_typ_cd) rdgm_ln_medn_typ_cd
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_ln_medn_typ_cd
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_ln_medn_typ_cd
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm110_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );


CURSOR CUR_111 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_ln_medn_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(rdgm_ln_medn_typ_cd) rdgm_ln_medn_typ_cd
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_ln_medn_typ_cd
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_ln_medn_typ_cd
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm111_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );


CURSOR CUR_131 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , road_cntl_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(road_cntl_typ_cd) road_cntl_typ_cd
        , ne_unique
        , min(nm_slk) nm_slk 
        , max(nm_end_slk) nm_end_slk 
    FROM (    
        SELECT
            road_cntl_typ_cd
            , ohms_samp_id
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                road_cntl_typ_cd
                , ohms_samp_id
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , CASE WHEN a.nm_begin_mp = a.nm_end_mp AND 
                a.iit_ne_id = lag(a.iit_ne_id) 
                over (order by a.ne_id_of, a.nm_begin_mp) THEN
                'Y' ELSE 'N' END duplicate_record 
            FROM 
                v_nm_road131_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp <= b.nm_end_mp
                AND a.nm_end_mp >= b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , ohms_samp_id
            );


CURSOR CUR_133 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , road_cntl_typ_cd VALUE_NUMERIC
FROM (    
    SELECT 
        COUNT(road_cntl_typ_cd) road_cntl_typ_cd
        , ne_unique
        , min(nm_slk) nm_slk 
        , max(nm_end_slk) nm_end_slk 
    FROM (    
        SELECT
            road_cntl_typ_cd
            , ohms_samp_id
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                road_cntl_typ_cd
                , ohms_samp_id
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , CASE WHEN a.nm_begin_mp = a.nm_end_mp AND 
                a.iit_ne_id = lag(a.iit_ne_id) 
                over (order by a.ne_id_of, a.nm_begin_mp) THEN
                'Y' ELSE 'N' END duplicate_record 
            FROM 
                v_nm_road133_count_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp <= b.nm_end_mp
                AND a.nm_end_mp >= b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , ohms_samp_id
            );


CURSOR CUR_138 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_wd_meas VALUE_NUMERIC
FROM (    
    SELECT 
        SUM(rdgm_wd_meas) rdgm_wd_meas
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_wd_meas
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_wd_meas
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm138_sum_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );


CURSOR CUR_139 IS
SELECT 
    ne_unique ROUTE_ID
    , nm_slk BEGIN_POINT
    , nm_end_slk END_POINT
    , nm_end_slk-nm_slk SECTION_LENGTH
    , rdgm_wd_meas VALUE_NUMERIC
FROM (    
    SELECT 
        SUM(rdgm_wd_meas) rdgm_wd_meas
        , ne_unique
        , nm_slk 
        , nm_end_slk 
    FROM (    
        SELECT
            rdgm_wd_meas
            , ne_unique
            , nm_slk
            , nm_end_slk
        FROM (    
            SELECT 
                rdgm_wd_meas
                , ne_unique
                , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp)) - b.nm_begin_mp, 
                        b.nm_slk + (b.nm_end_mp  - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))) nm_slk
                , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp)), 
                        b.nm_slk + (b.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))) nm_end_slk
                , 'N' duplicate_record
            FROM 
                v_nm_rdgm139_sum_mv_nw a
                , v_nm_HWY_nt bb
                , nm_members b
            WHERE 
                a.ne_id_of = b.nm_ne_id_of
                AND bb.ne_id = b.nm_ne_id_in
                AND a.nm_begin_mp < b.nm_end_mp
                AND a.nm_end_mp > b.nm_begin_mp
                AND bb.roadway_id = 'I'
            )
        WHERE duplicate_record = 'N')
    GROUP BY 
            ne_unique
            , nm_slk, nm_end_slk 
            );



CURSOR CUR_101 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , fc_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , fc_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.fc_cd
                    FROM 
                          v_nm_ffc_nw a
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_102 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , urban_area VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , urban_area
            FROM (
                    SELECT 
                        a.nm_ne_id_of ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , aa.urban_area
                    FROM 
                          v_nm_urbn_nt aa
                        , nm_members a
                    WHERE
                        aa.ne_id = a.nm_ne_id_in
                        AND aa.urban_area IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_103 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , typ_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.typ_cd
                    FROM 
                          v_nm_facl_nw a
                    WHERE
                        a.typ_cd <> 5
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_104 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , struc_id VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE 

 WHEN TUNL_IIT_NE_ID IS NULL AND NBI_STRUC_ID IS NULL THEN

  0

 WHEN NBI_STRUC_ID IS NOT NULL THEN

  1

 ELSE

  2

 END

 STRUC_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, c.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, c.nm_end_mp) nm_end_mp
                        , a.struc_id nbi_struc_id
                        , c.iit_ne_id tunl_iit_ne_id
                    FROM 
                          v_nm_nbi104_outer_mv_nw a
                         , v_nm_tunl104_outer_mv_nw c
                    WHERE
                        a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_105 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , accss_cntl_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , accss_cntl_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.accss_cntl_cd
                    FROM 
                          v_nm_accs_nw a
                    WHERE
                        a.accss_cntl_cd IN(1,2)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_106 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , fc_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , (SELECT '1' FROM DUAL) FC_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.fc_cd ffc_fc_cd
                    FROM 
                          v_nm_ffc_nw a
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_108 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , ln_medn_typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , DECODE(RDGM_LN_MEDN_TYP_CD,3,2,RDGM_LN_MEDN_TYP_CD) LN_MEDN_TYP_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.ln_medn_typ_cd rdgm_ln_medn_typ_cd
                    FROM 
                          v_nm_rdgm_nw a
                    WHERE
                        a.ln_medn_typ_cd = 3
                        AND a.layer =1
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_112 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , iit_x_sect VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE  WHEN ROAD_IIT_X_SECT IN ('R','B')  AND RDG1_IIT_X_SECT NOT LIKE 'RT%'  AND RDG2_IIT_X_SECT NOT LIKE 'RT%' THEN

          5

 WHEN RDG1_IIT_X_SECT = 'RT2'  THEN

          2

 WHEN RDG2_IIT_X_SECT = 'RT1' THEN

           4

 WHEN ROAD_IIT_X_SECT = 'L' THEN

           1

 ELSE

           1

END IIT_X_SECT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_end_mp
                        , a.iit_x_sect rdg1_iit_x_sect
                        , c.iit_x_sect rdg2_iit_x_sect
                        , d.iit_x_sect road_iit_x_sect
                    FROM 
                          v_nm_rdg1_nw a
                        , v_nm_rdg2_nw c
                        , v_nm_road_nw d
                    WHERE
                        a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                        AND a.ne_id_of = d.ne_id_of
                        AND a.nm_begin_mp < d.nm_end_mp
                        AND a.nm_end_mp > d.nm_begin_mp
                        AND a.iit_x_sect = 'RT1'
                        AND a.layer  = 1
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_113 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , iit_x_sect VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE  WHEN ROAD_IIT_X_SECT IN ('L','B')  AND RDG1_IIT_X_SECT NOT LIKE 'LT%'  AND RDG2_IIT_X_SECT NOT LIKE 'LT%' THEN

          5

 WHEN RDG1_IIT_X_SECT = 'LT2'  THEN

          2

 WHEN RDG2_IIT_X_SECT = 'LT1' THEN

           4

 WHEN ROAD_IIT_X_SECT = 'R' THEN

           1

 ELSE

           1

END IIT_X_SECT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_end_mp
                        , a.iit_x_sect rdg1_iit_x_sect
                        , c.iit_x_sect rdg2_iit_x_sect
                        , d.iit_x_sect road_iit_x_sect
                    FROM 
                          v_nm_rdg1_nw a
                        , v_nm_rdg2_nw c
                        , v_nm_road_nw d
                    WHERE
                        a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                        AND a.ne_id_of = d.ne_id_of
                        AND a.nm_begin_mp < d.nm_end_mp
                        AND a.nm_end_mp > d.nm_begin_mp
                        AND a.iit_x_sect = 'LT1'
                        AND a.layer  = 1
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_114 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , speed_desig VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE WHEN SPZN_SPEED_DESIG IS NULL AND URBN_URBAN_AREA IS NULL THEN 55 WHEN SPZN_SPEED_DESIG IS NULL THEN 25 ELSE SPZN_SPEED_DESIG END SPEED_DESIG
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, c.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, c.nm_end_mp) nm_end_mp
                        , a.speed_desig spzn_speed_desig
                        , c.urban_area urbn_urban_area
                    FROM 
                          v_nm_spzn114_outer_mv_nw a
                         , v_nm_urbn114_outer_mv_nt c
                    WHERE
                        a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_117 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , route_id VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , route_id
            FROM (
                    SELECT 
                        a.nm_ne_id_of ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , aa.route_id
                    FROM 
                          v_nm_rte_nt aa
                        , nm_members a
                    WHERE
                        aa.ne_id = a.nm_ne_id_in
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_118 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , route_type VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , DECODE(RTE_ROUTE_TYPE,'I-',2,'-US',3,'OR',4,1) ROUTE_TYPE
            FROM (
                    SELECT 
                        a.nm_ne_id_of ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , aa.route_type rte_route_type
                    FROM 
                          v_nm_rte_nt aa
                        , nm_members a
                    WHERE
                        aa.ne_id = a.nm_ne_id_in
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_119 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , route_suffix VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , DECODE(RTE_ROUTE_SUFFIX,'B',3,'BY',4,'SP',5,'ALT',2,'LP',6,1) ROUTE_SUFFIX
            FROM (
                    SELECT 
                        a.nm_ne_id_of ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , aa.route_suffix rte_route_suffix
                    FROM 
                          v_nm_rte_nt aa
                        , nm_members a
                    WHERE
                        aa.ne_id = a.nm_ne_id_in
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_120 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , alt_rd_nm VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , alt_rd_nm
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.alt_rd_nm
                    FROM 
                          v_nm_alnm_nw a
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_121 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , aadt_cnt VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , aadt_cnt
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.aadt_cnt
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.aadt_yr = (SELECT DATA_YEAR() - 1  FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_122 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , class_04_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , TRAF_CLASS_04_PCT + TRAF_CLASS_05_PCT + TRAF_CLASS_06_PCT + TRAF_CLASS_07_PCT CLASS_04_PCT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.class_04_pct traf_class_04_pct
                        , a.class_05_pct traf_class_05_pct
                        , a.class_06_pct traf_class_06_pct
                        , a.class_07_pct traf_class_07_pct
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_123 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , sut_truck_peak_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , sut_truck_peak_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.sut_truck_peak_pct
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_124 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , class_08_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , TRAF_CLASS_08_PCT + TRAF_CLASS_09_PCT + TRAF_CLASS_10_PCT + TRAF_CLASS_11_PCT + TRAF_CLASS_12_PCT + TRAF_CLASS_13_PCT CLASS_08_PCT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.class_08_pct traf_class_08_pct
                        , a.class_09_pct traf_class_09_pct
                        , a.class_10_pct traf_class_10_pct
                        , a.class_11_pct traf_class_11_pct
                        , a.class_12_pct traf_class_12_pct
                        , a.class_13_pct traf_class_13_pct
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_125 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , mut_truck_peak_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , mut_truck_peak_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.mut_truck_peak_pct
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.mut_truck_peak_pct IS NOT NULL
                        AND a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_126 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , dsgn_hr_fctr VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , dsgn_hr_fctr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.dsgn_hr_fctr
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.dsgn_hr_fctr IS NOT NULL
                        AND a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_127 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , dir_fctr VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , dir_fctr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.dir_fctr
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.dir_fctr IS NOT NULL
                        AND a.aadt_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_128 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , future_aadt_cnt VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , future_aadt_cnt
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.future_aadt_cnt
                    FROM 
                          v_nm_traf_nw a
                    WHERE
                        a.aadt_yr = (SELECT DATA_YEAR() - 1  FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_129 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , sgnl_sys_typ_cd VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , sgnl_sys_typ_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.sgnl_sys_typ_cd
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.sgnl_sys_typ_cd IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_130 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grn_tm_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , grn_tm_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.grn_tm_pct
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.grn_tm_pct IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_132 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , stop_sign_cnt VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , stop_sign_cnt
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.stop_sign_cnt
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.stop_sign_cnt IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_134 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , wd_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , wd_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.wd_meas
                    FROM 
                          v_nm_rdgm_nw a
                    WHERE
                        a.iit_x_sect = 'LN1I'
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_135 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , ln_medn_typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , DECODE(RDGM_LN_MEDN_TYP_CD,11,4,6,2,9,2,8,3,1) LN_MEDN_TYP_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.ln_medn_typ_cd rdgm_ln_medn_typ_cd
                    FROM 
                          v_nm_rdgm_nw a
                    WHERE
                        a.matl_typ_cd IS NOT NULL
                        AND a.layer =1
                        AND a.iit_x_sect = 'MEDN'
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_136 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , wd_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , wd_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.wd_meas
                    FROM 
                          v_nm_rdgm_nw a
                    WHERE
                        a.iit_x_sect = 'MEDN'
                        AND a.layer =1
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_137 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , matl_typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE WHEN CURB_IIT_NE_ID IS NOT NULL AND RDGM_MATL_TYP_CD IS NULL AND SHLD_MATL_TYP_CD IS NULL THEN

  7

 WHEN RDGM_MATL_TYP_CD IS NULL AND SHLD_MATL_TYP_CD IS NULL THEN

  1

 WHEN RDGM_MATL_TYP_CD IS NOT NULL AND SHLD_MATL_TYP_CD IS NOT NULL AND RDGM_MATL_TYP_CD <> SHLD_MATL_TYP_CD THEN

  5

 WHEN xodot_htdr1_gen.get_simplified_material(NVL(RDGM_MATL_TYP_CD,SHLD_MATL_TYP_CD)) = 'G' THEN

  4

 WHEN xodot_htdr1_gen.get_simplified_material(NVL(RDGM_MATL_TYP_CD,SHLD_MATL_TYP_CD)) = 'C' THEN

  3

 WHEN xodot_htdr1_gen.get_simplified_material(NVL(RDGM_MATL_TYP_CD,SHLD_MATL_TYP_CD)) = 'AU' THEN

  1

 ELSE


  1

END

 MATL_TYP_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp ,c.nm_begin_mp,d.nm_begin_mp) nm_end_mp
                        , a.matl_typ_cd rdgm_matl_typ_cd
                        , d.matl_typ_cd shld_matl_typ_cd
                        , c.iit_ne_id curb_iit_ne_id
                    FROM 
                          v_nm_rdgm137_outer_mv_nw a
                         , v_nm_curb137_outer_mv_nw c
                         , v_nm_shld137_outer_mv_nw d
                    WHERE
                        a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                        AND a.ne_id_of = d.ne_id_of
                        AND a.nm_begin_mp < d.nm_end_mp
                        AND a.nm_end_mp > d.nm_begin_mp
                        AND a.layer =1
                        AND a.iit_x_sect ='OS1I'
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_140 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , iit_x_sect VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , decode(PARK_IIT_X_SECT,'B',2,1) IIT_X_SECT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.iit_x_sect park_iit_x_sect
                    FROM 
                          v_nm_park_nw a
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_141 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , wdn_obstcl_1_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , wdn_obstcl_1_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.wdn_obstcl_1_cd
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.wdn_obstcl_1_cd IN (1,2)
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_142 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , wdn_potntl_cd VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , wdn_potntl_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.wdn_potntl_cd
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.wdn_potntl_cd IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_143 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , deg_crve_ang VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE  WHEN HZCV_deg_crve_ang  < 3.5 THEN 'A'  WHEN HZCV_deg_crve_ang  < 5.4 THEN 'B' WHEN HZCV_deg_crve_ang  < 8.4 THEN 'C'  WHEN HZCV_deg_crve_ang  < 13.9 THEN 'D' WHEN HZCV_deg_crve_ang  < 27.9 THEN 'E' WHEN HZCV_deg_crve_ang  > 28 THEN 'F' ELSE '' END  DEG_CRVE_ANG
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.deg_crve_ang hzcv_deg_crve_ang
                    FROM 
                          v_nm_hzcv_nw a
                    WHERE
                        a.deg_crve_ang IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_144 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , nvl(TERR_TYP_CD,1) TYP_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.typ_cd terr_typ_cd
                    FROM 
                          v_nm_terr_nw a
                    WHERE
                        a.typ_cd IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_145 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grd_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , CASE  WHEN VRTG_grd_pct  < 0.4 THEN 'A'  WHEN VRTG_grd_pct   < 2.4 THEN 'B' WHEN VRTG_grd_pct  < 4.4 THEN 'C'  WHEN VRTG_grd_pct < 6.4 THEN 'D' WHEN VRTG_grd_pct  < 8.4 THEN 'E' WHEN VRTG_grd_pct  > 8.5 THEN 'F' ELSE '' END  GRD_PCT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.grd_pct vrtg_grd_pct
                    FROM 
                          v_nm_vrtg_nw a
                    WHERE
                        a.grd_pct IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_146 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , pass_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , pass_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.pass_pct
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.pass_pct IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_147 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , iri_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , iri_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.iri_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.iri_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_148 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , psr_rtng_cd VALUE_TEXT
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , psr_rtng_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.psr_rtng_cd
                    FROM 
                          v_nm_hpms_nw a
                    WHERE
                        a.psr_rtng_cd IS NOT NULL
                        AND a.data_yr =(SELECT DATA_YEAR() FROM DUAL)
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_149 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , matl_typ_cd VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , xodot_htdr1_gen.get_simplified_material(rdgm_matl_typ_cd) MATL_TYP_CD
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.matl_typ_cd rdgm_matl_typ_cd
                    FROM 
                          v_nm_rdgm_nw a
                    WHERE
                        a.iit_x_sect = 'LN1I'  
                        AND a.layer = 1
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_150 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , rutg_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , rutg_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.rutg_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.rutg_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_151 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , flt_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , flt_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.flt_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.flt_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_152 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , crackg_pct VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , crackg_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.crackg_pct
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.crackg_pct IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_153 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , crackg_len VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , crackg_len
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.crackg_len
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.crackg_len IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_154 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , last_imprv_yr VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , last_imprv_yr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.last_imprv_yr
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.last_imprv_yr IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_155 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , last_cnstrc_yr VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , last_cnstrc_yr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.last_cnstrc_yr
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.last_cnstrc_yr IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_156 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , last_ovlay_yr VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , last_ovlay_yr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.last_ovlay_yr
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.last_ovlay_yr IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_157 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , thk_rigid_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , thk_rigid_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.thk_rigid_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.thk_rigid_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_158 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , thk_flex_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , thk_flex_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.thk_flex_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.thk_flex_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_159 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , base_typ VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , base_typ
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.base_typ
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.base_typ IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;

CURSOR CUR_160 IS
        SELECT
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , base_thk_meas VALUE_NUMERIC
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1, 
                    l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK
                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1, 
                    l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK
                , base_thk_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp ) nm_begin_mp
                        , least(a.nm_end_mp ) nm_end_mp
                        , a.base_thk_meas
                    FROM 
                          v_nm_hppv_nw a
                    WHERE
                        a.base_thk_meas IS NOT NULL
                 ) a
                ,(
                    SELECT 
                        ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_begin_mp
                        , nm_end_mp
                        , nm_ne_id_of
                        , nm_cardinality
                    FROM 
                        v_nm_hwy_nt
                        , nm_members 
                    WHERE 
                        ne_id = nm_ne_id_in
                        AND roadway_id = 'I'
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk;





t_year_record_var			NUMBER(4);
t_state_code_var			NUMBER(2);
t_route_id_var				VARCHAR2(32);
t_begin_point_var			NUMBER(8,3);
t_end_point_var				NUMBER(8,3);
t_data_item_var				VARCHAR2(25);
t_section_length_var		NUMBER(8,3);
t_value_numeric_var			NUMBER;
t_value_text_var			VARCHAR2(50);
t_value_date_var			DATE;
t_comments_var				VARCHAR2(50);

BEGIN
        t_error                 := NULL;
        t_error_desc            := NULL;

        SELECT trunc(sysdate), user INTO t_sysdate, t_user FROM DUAL;

        t_table_id               := 4;


	DELETE FROM OHMS_SUBMIT_SECTIONS;

	COMMIT;


/******************************************************
		 Processing Cursor #101
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'F_System' INTO t_data_item_var FROM DUAL;


	FOR c_101 IN cur_101 LOOP

		t_route_id_var				:= c_101.ROUTE_ID;
		t_begin_point_var			:= c_101.BEGIN_POINT;
		t_end_point_var				:= c_101.END_POINT;
		t_section_length_var		:= c_101.SECTION_LENGTH;
		t_value_numeric_var			:= c_101.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #102
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Urban_Code' INTO t_data_item_var FROM DUAL;


	FOR c_102 IN cur_102 LOOP

		t_route_id_var				:= c_102.ROUTE_ID;
		t_begin_point_var			:= c_102.BEGIN_POINT;
		t_end_point_var				:= c_102.END_POINT;
		t_section_length_var		:= c_102.SECTION_LENGTH;
		t_value_numeric_var			:= c_102.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #103
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Facility_Type' INTO t_data_item_var FROM DUAL;


	FOR c_103 IN cur_103 LOOP

		t_route_id_var				:= c_103.ROUTE_ID;
		t_begin_point_var			:= c_103.BEGIN_POINT;
		t_end_point_var				:= c_103.END_POINT;
		t_section_length_var		:= c_103.SECTION_LENGTH;
		t_value_numeric_var			:= c_103.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #104
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Structure_Type' INTO t_data_item_var FROM DUAL;


	FOR c_104 IN cur_104 LOOP

		t_route_id_var				:= c_104.ROUTE_ID;
		t_begin_point_var			:= c_104.BEGIN_POINT;
		t_end_point_var				:= c_104.END_POINT;
		t_section_length_var		:= c_104.SECTION_LENGTH;
		t_value_numeric_var			:= c_104.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #105
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Access_Control' INTO t_data_item_var FROM DUAL;


	FOR c_105 IN cur_105 LOOP

		t_route_id_var				:= c_105.ROUTE_ID;
		t_begin_point_var			:= c_105.BEGIN_POINT;
		t_end_point_var				:= c_105.END_POINT;
		t_section_length_var		:= c_105.SECTION_LENGTH;
		t_value_numeric_var			:= c_105.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #106
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Ownership' INTO t_data_item_var FROM DUAL;


	FOR c_106 IN cur_106 LOOP

		t_route_id_var				:= c_106.ROUTE_ID;
		t_begin_point_var			:= c_106.BEGIN_POINT;
		t_end_point_var				:= c_106.END_POINT;
		t_section_length_var		:= c_106.SECTION_LENGTH;
		t_value_numeric_var			:= c_106.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #107
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Through_Lanes' INTO t_data_item_var FROM DUAL;


	FOR c_107 IN cur_107 LOOP

		t_route_id_var				:= c_107.ROUTE_ID;
		t_begin_point_var			:= c_107.BEGIN_POINT;
		t_end_point_var				:= c_107.END_POINT;
		t_section_length_var		:= c_107.SECTION_LENGTH;
		t_value_numeric_var			:= c_107.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #108
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'HOV_Type' INTO t_data_item_var FROM DUAL;


	FOR c_108 IN cur_108 LOOP

		t_route_id_var				:= c_108.ROUTE_ID;
		t_begin_point_var			:= c_108.BEGIN_POINT;
		t_end_point_var				:= c_108.END_POINT;
		t_section_length_var		:= c_108.SECTION_LENGTH;
		t_value_numeric_var			:= c_108.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #109
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'HOV_LANES' INTO t_data_item_var FROM DUAL;


	FOR c_109 IN cur_109 LOOP

		t_route_id_var				:= c_109.ROUTE_ID;
		t_begin_point_var			:= c_109.BEGIN_POINT;
		t_end_point_var				:= c_109.END_POINT;
		t_section_length_var		:= c_109.SECTION_LENGTH;
		t_value_numeric_var			:= c_109.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #110
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Peak_Lanes' INTO t_data_item_var FROM DUAL;


	FOR c_110 IN cur_110 LOOP

		t_route_id_var				:= c_110.ROUTE_ID;
		t_begin_point_var			:= c_110.BEGIN_POINT;
		t_end_point_var				:= c_110.END_POINT;
		t_section_length_var		:= c_110.SECTION_LENGTH;
		t_value_numeric_var			:= c_110.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #111
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Counter_Peak_Lanes' INTO t_data_item_var FROM DUAL;


	FOR c_111 IN cur_111 LOOP

		t_route_id_var				:= c_111.ROUTE_ID;
		t_begin_point_var			:= c_111.BEGIN_POINT;
		t_end_point_var				:= c_111.END_POINT;
		t_section_length_var		:= c_111.SECTION_LENGTH;
		t_value_numeric_var			:= c_111.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #112
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Turn_Lanes_R' INTO t_data_item_var FROM DUAL;


	FOR c_112 IN cur_112 LOOP

		t_route_id_var				:= c_112.ROUTE_ID;
		t_begin_point_var			:= c_112.BEGIN_POINT;
		t_end_point_var				:= c_112.END_POINT;
		t_section_length_var		:= c_112.SECTION_LENGTH;
		t_value_numeric_var			:= c_112.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #113
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Turn_Lanes_L' INTO t_data_item_var FROM DUAL;


	FOR c_113 IN cur_113 LOOP

		t_route_id_var				:= c_113.ROUTE_ID;
		t_begin_point_var			:= c_113.BEGIN_POINT;
		t_end_point_var				:= c_113.END_POINT;
		t_section_length_var		:= c_113.SECTION_LENGTH;
		t_value_numeric_var			:= c_113.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #114
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'SPEED_LIMIT' INTO t_data_item_var FROM DUAL;


	FOR c_114 IN cur_114 LOOP

		t_route_id_var				:= c_114.ROUTE_ID;
		t_begin_point_var			:= c_114.BEGIN_POINT;
		t_end_point_var				:= c_114.END_POINT;
		t_section_length_var		:= c_114.SECTION_LENGTH;
		t_value_numeric_var			:= c_114.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #117
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Route_Number' INTO t_data_item_var FROM DUAL;


	FOR c_117 IN cur_117 LOOP

		t_route_id_var				:= c_117.ROUTE_ID;
		t_begin_point_var			:= c_117.BEGIN_POINT;
		t_end_point_var				:= c_117.END_POINT;
		t_section_length_var		:= c_117.SECTION_LENGTH;
		t_value_numeric_var			:= c_117.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #118
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Route_Signing' INTO t_data_item_var FROM DUAL;


	FOR c_118 IN cur_118 LOOP

		t_route_id_var				:= c_118.ROUTE_ID;
		t_begin_point_var			:= c_118.BEGIN_POINT;
		t_end_point_var				:= c_118.END_POINT;
		t_section_length_var		:= c_118.SECTION_LENGTH;
		t_value_numeric_var			:= c_118.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #119
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Route_Qualifier' INTO t_data_item_var FROM DUAL;


	FOR c_119 IN cur_119 LOOP

		t_route_id_var				:= c_119.ROUTE_ID;
		t_begin_point_var			:= c_119.BEGIN_POINT;
		t_end_point_var				:= c_119.END_POINT;
		t_section_length_var		:= c_119.SECTION_LENGTH;
		t_value_numeric_var			:= c_119.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #120
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Alternative_Route_Name' INTO t_data_item_var FROM DUAL;


	FOR c_120 IN cur_120 LOOP

		t_route_id_var				:= c_120.ROUTE_ID;
		t_begin_point_var			:= c_120.BEGIN_POINT;
		t_end_point_var				:= c_120.END_POINT;
		t_section_length_var		:= c_120.SECTION_LENGTH;
		t_value_text_var			:= c_120.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #121
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'AADT' INTO t_data_item_var FROM DUAL;


	FOR c_121 IN cur_121 LOOP

		t_route_id_var				:= c_121.ROUTE_ID;
		t_begin_point_var			:= c_121.BEGIN_POINT;
		t_end_point_var				:= c_121.END_POINT;
		t_section_length_var		:= c_121.SECTION_LENGTH;
		t_value_numeric_var			:= c_121.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #122
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'AADT_Single_Unit' INTO t_data_item_var FROM DUAL;


	FOR c_122 IN cur_122 LOOP

		t_route_id_var				:= c_122.ROUTE_ID;
		t_begin_point_var			:= c_122.BEGIN_POINT;
		t_end_point_var				:= c_122.END_POINT;
		t_section_length_var		:= c_122.SECTION_LENGTH;
		t_value_numeric_var			:= c_122.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #123
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Pct_Peak_Single' INTO t_data_item_var FROM DUAL;


	FOR c_123 IN cur_123 LOOP

		t_route_id_var				:= c_123.ROUTE_ID;
		t_begin_point_var			:= c_123.BEGIN_POINT;
		t_end_point_var				:= c_123.END_POINT;
		t_section_length_var		:= c_123.SECTION_LENGTH;
		t_value_numeric_var			:= c_123.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #124
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'AADT_Combination' INTO t_data_item_var FROM DUAL;


	FOR c_124 IN cur_124 LOOP

		t_route_id_var				:= c_124.ROUTE_ID;
		t_begin_point_var			:= c_124.BEGIN_POINT;
		t_end_point_var				:= c_124.END_POINT;
		t_section_length_var		:= c_124.SECTION_LENGTH;
		t_value_numeric_var			:= c_124.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #125
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Pct_Peak_Combination' INTO t_data_item_var FROM DUAL;


	FOR c_125 IN cur_125 LOOP

		t_route_id_var				:= c_125.ROUTE_ID;
		t_begin_point_var			:= c_125.BEGIN_POINT;
		t_end_point_var				:= c_125.END_POINT;
		t_section_length_var		:= c_125.SECTION_LENGTH;
		t_value_numeric_var			:= c_125.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #126
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'K_Factor' INTO t_data_item_var FROM DUAL;


	FOR c_126 IN cur_126 LOOP

		t_route_id_var				:= c_126.ROUTE_ID;
		t_begin_point_var			:= c_126.BEGIN_POINT;
		t_end_point_var				:= c_126.END_POINT;
		t_section_length_var		:= c_126.SECTION_LENGTH;
		t_value_text_var			:= c_126.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #127
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Dir_Factor' INTO t_data_item_var FROM DUAL;


	FOR c_127 IN cur_127 LOOP

		t_route_id_var				:= c_127.ROUTE_ID;
		t_begin_point_var			:= c_127.BEGIN_POINT;
		t_end_point_var				:= c_127.END_POINT;
		t_section_length_var		:= c_127.SECTION_LENGTH;
		t_value_text_var			:= c_127.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #128
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Future_AADT' INTO t_data_item_var FROM DUAL;


	FOR c_128 IN cur_128 LOOP

		t_route_id_var				:= c_128.ROUTE_ID;
		t_begin_point_var			:= c_128.BEGIN_POINT;
		t_end_point_var				:= c_128.END_POINT;
		t_section_length_var		:= c_128.SECTION_LENGTH;
		t_value_numeric_var			:= c_128.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #129
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Signal_Type' INTO t_data_item_var FROM DUAL;


	FOR c_129 IN cur_129 LOOP

		t_route_id_var				:= c_129.ROUTE_ID;
		t_begin_point_var			:= c_129.BEGIN_POINT;
		t_end_point_var				:= c_129.END_POINT;
		t_section_length_var		:= c_129.SECTION_LENGTH;
		t_value_text_var			:= c_129.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #130
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Pct_Green_Time' INTO t_data_item_var FROM DUAL;


	FOR c_130 IN cur_130 LOOP

		t_route_id_var				:= c_130.ROUTE_ID;
		t_begin_point_var			:= c_130.BEGIN_POINT;
		t_end_point_var				:= c_130.END_POINT;
		t_section_length_var		:= c_130.SECTION_LENGTH;
		t_value_numeric_var			:= c_130.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #131
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Number_Signals' INTO t_data_item_var FROM DUAL;


	FOR c_131 IN cur_131 LOOP

		t_route_id_var				:= c_131.ROUTE_ID;
		t_begin_point_var			:= c_131.BEGIN_POINT;
		t_end_point_var				:= c_131.END_POINT;
		t_section_length_var		:= c_131.SECTION_LENGTH;
		t_value_numeric_var			:= c_131.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #132
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Stop_Signs' INTO t_data_item_var FROM DUAL;


	FOR c_132 IN cur_132 LOOP

		t_route_id_var				:= c_132.ROUTE_ID;
		t_begin_point_var			:= c_132.BEGIN_POINT;
		t_end_point_var				:= c_132.END_POINT;
		t_section_length_var		:= c_132.SECTION_LENGTH;
		t_value_numeric_var			:= c_132.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #133
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'At_Grade_Other' INTO t_data_item_var FROM DUAL;


	FOR c_133 IN cur_133 LOOP

		t_route_id_var				:= c_133.ROUTE_ID;
		t_begin_point_var			:= c_133.BEGIN_POINT;
		t_end_point_var				:= c_133.END_POINT;
		t_section_length_var		:= c_133.SECTION_LENGTH;
		t_value_numeric_var			:= c_133.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #134
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Lane_Width' INTO t_data_item_var FROM DUAL;


	FOR c_134 IN cur_134 LOOP

		t_route_id_var				:= c_134.ROUTE_ID;
		t_begin_point_var			:= c_134.BEGIN_POINT;
		t_end_point_var				:= c_134.END_POINT;
		t_section_length_var		:= c_134.SECTION_LENGTH;
		t_value_numeric_var			:= c_134.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #135
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Median_Type' INTO t_data_item_var FROM DUAL;


	FOR c_135 IN cur_135 LOOP

		t_route_id_var				:= c_135.ROUTE_ID;
		t_begin_point_var			:= c_135.BEGIN_POINT;
		t_end_point_var				:= c_135.END_POINT;
		t_section_length_var		:= c_135.SECTION_LENGTH;
		t_value_numeric_var			:= c_135.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #136
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Median_Width' INTO t_data_item_var FROM DUAL;


	FOR c_136 IN cur_136 LOOP

		t_route_id_var				:= c_136.ROUTE_ID;
		t_begin_point_var			:= c_136.BEGIN_POINT;
		t_end_point_var				:= c_136.END_POINT;
		t_section_length_var		:= c_136.SECTION_LENGTH;
		t_value_numeric_var			:= c_136.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #137
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Shoulder_Type' INTO t_data_item_var FROM DUAL;


	FOR c_137 IN cur_137 LOOP

		t_route_id_var				:= c_137.ROUTE_ID;
		t_begin_point_var			:= c_137.BEGIN_POINT;
		t_end_point_var				:= c_137.END_POINT;
		t_section_length_var		:= c_137.SECTION_LENGTH;
		t_value_numeric_var			:= c_137.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #138
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Shoulder_Width_R' INTO t_data_item_var FROM DUAL;


	FOR c_138 IN cur_138 LOOP

		t_route_id_var				:= c_138.ROUTE_ID;
		t_begin_point_var			:= c_138.BEGIN_POINT;
		t_end_point_var				:= c_138.END_POINT;
		t_section_length_var		:= c_138.SECTION_LENGTH;
		t_value_numeric_var			:= c_138.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #139
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Shoulder_Width_L' INTO t_data_item_var FROM DUAL;


	FOR c_139 IN cur_139 LOOP

		t_route_id_var				:= c_139.ROUTE_ID;
		t_begin_point_var			:= c_139.BEGIN_POINT;
		t_end_point_var				:= c_139.END_POINT;
		t_section_length_var		:= c_139.SECTION_LENGTH;
		t_value_numeric_var			:= c_139.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #140
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Peak_Parking' INTO t_data_item_var FROM DUAL;


	FOR c_140 IN cur_140 LOOP

		t_route_id_var				:= c_140.ROUTE_ID;
		t_begin_point_var			:= c_140.BEGIN_POINT;
		t_end_point_var				:= c_140.END_POINT;
		t_section_length_var		:= c_140.SECTION_LENGTH;
		t_value_numeric_var			:= c_140.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #141
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Widening_Obstacle' INTO t_data_item_var FROM DUAL;


	FOR c_141 IN cur_141 LOOP

		t_route_id_var				:= c_141.ROUTE_ID;
		t_begin_point_var			:= c_141.BEGIN_POINT;
		t_end_point_var				:= c_141.END_POINT;
		t_section_length_var		:= c_141.SECTION_LENGTH;
		t_value_numeric_var			:= c_141.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #142
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Widening_Potential' INTO t_data_item_var FROM DUAL;


	FOR c_142 IN cur_142 LOOP

		t_route_id_var				:= c_142.ROUTE_ID;
		t_begin_point_var			:= c_142.BEGIN_POINT;
		t_end_point_var				:= c_142.END_POINT;
		t_section_length_var		:= c_142.SECTION_LENGTH;
		t_value_text_var			:= c_142.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #143
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Curve_Classification' INTO t_data_item_var FROM DUAL;


	FOR c_143 IN cur_143 LOOP

		t_route_id_var				:= c_143.ROUTE_ID;
		t_begin_point_var			:= c_143.BEGIN_POINT;
		t_end_point_var				:= c_143.END_POINT;
		t_section_length_var		:= c_143.SECTION_LENGTH;
		t_value_numeric_var			:= c_143.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #144
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Terrain_Type' INTO t_data_item_var FROM DUAL;


	FOR c_144 IN cur_144 LOOP

		t_route_id_var				:= c_144.ROUTE_ID;
		t_begin_point_var			:= c_144.BEGIN_POINT;
		t_end_point_var				:= c_144.END_POINT;
		t_section_length_var		:= c_144.SECTION_LENGTH;
		t_value_numeric_var			:= c_144.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #145
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Grade_Classification' INTO t_data_item_var FROM DUAL;


	FOR c_145 IN cur_145 LOOP

		t_route_id_var				:= c_145.ROUTE_ID;
		t_begin_point_var			:= c_145.BEGIN_POINT;
		t_end_point_var				:= c_145.END_POINT;
		t_section_length_var		:= c_145.SECTION_LENGTH;
		t_value_numeric_var			:= c_145.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #146
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Pct_Pass_Sight' INTO t_data_item_var FROM DUAL;


	FOR c_146 IN cur_146 LOOP

		t_route_id_var				:= c_146.ROUTE_ID;
		t_begin_point_var			:= c_146.BEGIN_POINT;
		t_end_point_var				:= c_146.END_POINT;
		t_section_length_var		:= c_146.SECTION_LENGTH;
		t_value_numeric_var			:= c_146.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #147
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'IRI' INTO t_data_item_var FROM DUAL;


	FOR c_147 IN cur_147 LOOP

		t_route_id_var				:= c_147.ROUTE_ID;
		t_begin_point_var			:= c_147.BEGIN_POINT;
		t_end_point_var				:= c_147.END_POINT;
		t_section_length_var		:= c_147.SECTION_LENGTH;
		t_value_numeric_var			:= c_147.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #148
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'PSR' INTO t_data_item_var FROM DUAL;


	FOR c_148 IN cur_148 LOOP

		t_route_id_var				:= c_148.ROUTE_ID;
		t_begin_point_var			:= c_148.BEGIN_POINT;
		t_end_point_var				:= c_148.END_POINT;
		t_section_length_var		:= c_148.SECTION_LENGTH;
		t_value_text_var			:= c_148.VALUE_TEXT;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #149
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Surface_Type' INTO t_data_item_var FROM DUAL;


	FOR c_149 IN cur_149 LOOP

		t_route_id_var				:= c_149.ROUTE_ID;
		t_begin_point_var			:= c_149.BEGIN_POINT;
		t_end_point_var				:= c_149.END_POINT;
		t_section_length_var		:= c_149.SECTION_LENGTH;
		t_value_numeric_var			:= c_149.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #150
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Rutting' INTO t_data_item_var FROM DUAL;


	FOR c_150 IN cur_150 LOOP

		t_route_id_var				:= c_150.ROUTE_ID;
		t_begin_point_var			:= c_150.BEGIN_POINT;
		t_end_point_var				:= c_150.END_POINT;
		t_section_length_var		:= c_150.SECTION_LENGTH;
		t_value_numeric_var			:= c_150.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #151
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Faulting' INTO t_data_item_var FROM DUAL;


	FOR c_151 IN cur_151 LOOP

		t_route_id_var				:= c_151.ROUTE_ID;
		t_begin_point_var			:= c_151.BEGIN_POINT;
		t_end_point_var				:= c_151.END_POINT;
		t_section_length_var		:= c_151.SECTION_LENGTH;
		t_value_numeric_var			:= c_151.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #152
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Cracking_Percent' INTO t_data_item_var FROM DUAL;


	FOR c_152 IN cur_152 LOOP

		t_route_id_var				:= c_152.ROUTE_ID;
		t_begin_point_var			:= c_152.BEGIN_POINT;
		t_end_point_var				:= c_152.END_POINT;
		t_section_length_var		:= c_152.SECTION_LENGTH;
		t_value_numeric_var			:= c_152.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #153
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Cracking_Length' INTO t_data_item_var FROM DUAL;


	FOR c_153 IN cur_153 LOOP

		t_route_id_var				:= c_153.ROUTE_ID;
		t_begin_point_var			:= c_153.BEGIN_POINT;
		t_end_point_var				:= c_153.END_POINT;
		t_section_length_var		:= c_153.SECTION_LENGTH;
		t_value_numeric_var			:= c_153.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #154
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Year_Last_Improv' INTO t_data_item_var FROM DUAL;


	FOR c_154 IN cur_154 LOOP

		t_route_id_var				:= c_154.ROUTE_ID;
		t_begin_point_var			:= c_154.BEGIN_POINT;
		t_end_point_var				:= c_154.END_POINT;
		t_section_length_var		:= c_154.SECTION_LENGTH;
		t_value_numeric_var			:= c_154.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #155
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Year_Last_Construction' INTO t_data_item_var FROM DUAL;


	FOR c_155 IN cur_155 LOOP

		t_route_id_var				:= c_155.ROUTE_ID;
		t_begin_point_var			:= c_155.BEGIN_POINT;
		t_end_point_var				:= c_155.END_POINT;
		t_section_length_var		:= c_155.SECTION_LENGTH;
		t_value_numeric_var			:= c_155.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #156
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'LAST_OVERLAY_THICKNESS' INTO t_data_item_var FROM DUAL;


	FOR c_156 IN cur_156 LOOP

		t_route_id_var				:= c_156.ROUTE_ID;
		t_begin_point_var			:= c_156.BEGIN_POINT;
		t_end_point_var				:= c_156.END_POINT;
		t_section_length_var		:= c_156.SECTION_LENGTH;
		t_value_numeric_var			:= c_156.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #157
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Thickness_Rigid' INTO t_data_item_var FROM DUAL;


	FOR c_157 IN cur_157 LOOP

		t_route_id_var				:= c_157.ROUTE_ID;
		t_begin_point_var			:= c_157.BEGIN_POINT;
		t_end_point_var				:= c_157.END_POINT;
		t_section_length_var		:= c_157.SECTION_LENGTH;
		t_value_numeric_var			:= c_157.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #158
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Thickness_Flexible' INTO t_data_item_var FROM DUAL;


	FOR c_158 IN cur_158 LOOP

		t_route_id_var				:= c_158.ROUTE_ID;
		t_begin_point_var			:= c_158.BEGIN_POINT;
		t_end_point_var				:= c_158.END_POINT;
		t_section_length_var		:= c_158.SECTION_LENGTH;
		t_value_numeric_var			:= c_158.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #159
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Base_Type' INTO t_data_item_var FROM DUAL;


	FOR c_159 IN cur_159 LOOP

		t_route_id_var				:= c_159.ROUTE_ID;
		t_begin_point_var			:= c_159.BEGIN_POINT;
		t_end_point_var				:= c_159.END_POINT;
		t_section_length_var		:= c_159.SECTION_LENGTH;
		t_value_numeric_var			:= c_159.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;
/******************************************************
		 Processing Cursor #160
******************************************************/

BEGIN
	t_year_record_var			 := NULL;
	t_state_code_var			 := NULL;
	t_route_id_var				 := NULL;
	t_begin_point_var			 := NULL;
	t_end_point_var				 := NULL;
	t_data_item_var				 := NULL;
	t_section_length_var		 := NULL;
	t_value_numeric_var			 := NULL;
	t_value_text_var			 := NULL;
	t_value_date_var			 := NULL;
	t_comments_var				 := NULL;

	SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;

	SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

	SELECT 'Base_Thickness' INTO t_data_item_var FROM DUAL;


	FOR c_160 IN cur_160 LOOP

		t_route_id_var				:= c_160.ROUTE_ID;
		t_begin_point_var			:= c_160.BEGIN_POINT;
		t_end_point_var				:= c_160.END_POINT;
		t_section_length_var		:= c_160.SECTION_LENGTH;
		t_value_numeric_var			:= c_160.VALUE_NUMERIC;

		INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
		VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

		COMMIT;

	END LOOP;


	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;


EXCEPTION WHEN OTHERS THEN
	t_error			:= sqlcode;
	t_error_desc		:= substr(sqlerrm,1,400);
	SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;


	INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_TABLE_ID, HAL_STATUS)
	VALUES (t_hal_id, t_sysdate, t_user, t_table_id, 'SUCCESS');
	COMMIT;

END;



EXCEPTION 

when is_complete
    then 
        raise_application_error( -20000,'Generation Complete');

WHEN OTHERS THEN
        t_error            := sqlcode;
        t_error_desc        := substr(sqlerrm,1,400);

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID
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
    raise_application_error( -20000,'Generation Failed');
END;
/
