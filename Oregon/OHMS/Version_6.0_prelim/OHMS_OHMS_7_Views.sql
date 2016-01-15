--------------------------------------------------------
--  DDL for View V_OHMS_7_501_F_SYSTEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_501_F_SYSTEM" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , ffc_fc_cd VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , FFC_fc_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.fc_cd ffc_fc_cd
                    FROM 
                          v_nm_ffc_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_502_URBAN_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_502_URBAN_CODE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , urbn_urban_area VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CASE
	WHEN URBN_SMALL_URBAN = 'N' AND URBN_URBAN_AREA IS NOT NULL THEN
	  DECODE(URBN_URBAN_AREA,'PORTLAND',71317,'EUGENE',28117,'SALEM',78229,'RAINIER',51283,'MEDFORD',55981,'BEND',6868,'CORVALLIS',20422)
	WHEN URBN_SMALL_URBAN = 'Y' AND URBN_URBAN_AREA IS NOT NULL THEN
	  99998
	ELSE
	  99999
	END
	 URBN_urban_area
                , URBN_SMALL_URBAN
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.urban_area urbn_urban_area
                        , a.small_urban urbn_small_urban
                    FROM 
                          v_nm_urbn502_outer_mv_nt a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_503_FACILITY_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_503_FACILITY_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , facl_typ_cd VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , FACL_typ_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.typ_cd facl_typ_cd
                    FROM 
                          v_nm_facl_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.typ_cd IN(1,2,3)
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_504_STRUCTURE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_504_STRUCTURE_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , nbi_struc_id VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CASE
	  WHEN TUNL_STRUC_ID IS NOT NULL THEN  2
	  WHEN NBI_STRUC_ID IS NOT NULL THEN  1
	 ELSE
	  NULL
	 END
	 NBI_struc_id
                , TUNL_STRUC_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp
,c.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp
,c.nm_end_mp) nm_end_mp
                        , a.struc_id nbi_struc_id
                        , c.struc_id tunl_struc_id
                    FROM 
                          v_nm_nbi504_outer_mv_nw a
                        , OHMS_7_network_mv b
                         , v_nm_tunl504_outer_mv_nw c
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.ne_id_of = c.ne_id_of
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_507_THROUGH_LANES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_507_THROUGH_LANES" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_NUMERIC") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
    ,rdgm.ln_medn_typ_cd VALUE_NUMERIC
FROM
    v_nm_rdgm507_count_mv_nw RDGM
    , OHMS_7_network_mv2 b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_508_HOV_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_508_HOV_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_NUMERIC") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
    ,decode(rdgm.ln_medn_typ_cd,3,2,rdgm.ln_medn_typ_cd) VALUE_NUMERIC
FROM
    v_nm_rdgm508_min_mv_nw RDGM
    , OHMS_7_network_mv2 b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_509_HOV_LANES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_509_HOV_LANES" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_NUMERIC") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
    ,rdgm.ln_medn_typ_cd VALUE_NUMERIC
FROM
    v_nm_rdgm509_count_mv_nw RDGM
    , OHMS_7_network_mv2 b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_510_URBAN_SUB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_510_URBAN_SUB" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , urbn_ne_id VALUE_TEXT
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , URBN_ne_id
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.ne_id urbn_ne_id
                    FROM 
                          v_nm_urbn510_outer_mv_nt a
                        , OHMS_7_network_mv2 b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_512_TURN_LANES_R
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_512_TURN_LANES_R" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hpmx_turn_ln_r VALUE_NUMERIC
            , hpmx_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPMX_turn_ln_r
                , HPMX_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.turn_ln_r hpmx_turn_ln_r
                        , a.samp_id hpmx_samp_id
                    FROM 
                          v_nm_hpmx_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.turn_ln_r <> -1
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_513_TURN_LANES_L
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_513_TURN_LANES_L" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hpmx_turn_ln_l VALUE_NUMERIC
            , hpmx_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPMX_turn_ln_l
                , HPMX_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.turn_ln_l hpmx_turn_ln_l
                        , a.samp_id hpmx_samp_id
                    FROM 
                          v_nm_hpmx_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.turn_ln_l <> -1
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_514_SPEED_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_514_SPEED_LIMIT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , spzn_speed_desig VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CASE WHEN SPZN_SPEED_DESIG IS NULL AND URBN_URBAN_AREA IS NULL THEN 55 WHEN SPZN_SPEED_DESIG IS NULL THEN 25 ELSE SPZN_SPEED_DESIG END SPZN_speed_desig
                , URBN_URBAN_AREA
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp
,c.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp
,c.nm_end_mp) nm_end_mp
                        , a.speed_desig spzn_speed_desig
                        , c.urban_area urbn_urban_area
                    FROM 
                          v_nm_spzn514_outer_mv_nw a
                        , OHMS_7_network_mv b
                         , v_nm_urbn514_outer_mv_nt c
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.ne_id_of = c.ne_id_of
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_521_AADT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_521_AADT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_aadt_cnt VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_aadt_cnt
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.aadt_cnt traf_aadt_cnt
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.aadt_yr = (SELECT DATA_YEAR() FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_522_AADT_SINGLE_UNIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_522_AADT_SINGLE_UNIT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_class_04_pct VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , ROUND(((TRAF_CLASS_04_PCT + TRAF_CLASS_05_PCT + TRAF_CLASS_06_PCT + TRAF_CLASS_07_PCT) * TRAF_AADT_CNT) / 100) TRAF_class_04_pct
                , TRAF_CLASS_05_PCT
                , TRAF_CLASS_06_PCT
                , TRAF_CLASS_07_PCT
                , TRAF_AADT_CNT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.class_04_pct traf_class_04_pct
                        , a.class_05_pct traf_class_05_pct
                        , a.class_06_pct traf_class_06_pct
                        , a.class_07_pct traf_class_07_pct
                        , a.aadt_cnt traf_aadt_cnt
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_523_PCT_PEAK_SINGLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_523_PCT_PEAK_SINGLE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_sut_truck_peak_pct VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_sut_truck_peak_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.sut_truck_peak_pct traf_sut_truck_peak_pct
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.sut_truck_peak_pct IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_524_AADT_COMBINATION
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_524_AADT_COMBINATION" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_class_08_pct VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , ROUND(((TRAF_CLASS_08_PCT + TRAF_CLASS_09_PCT + TRAF_CLASS_10_PCT + TRAF_CLASS_11_PCT + TRAF_CLASS_12_PCT + TRAF_CLASS_13_PCT) * TRAF_AADT_CNT) / 100) TRAF_class_08_pct
                , TRAF_CLASS_09_PCT
                , TRAF_CLASS_10_PCT
                , TRAF_CLASS_11_PCT
                , TRAF_CLASS_12_PCT
                , TRAF_CLASS_13_PCT
                , TRAF_AADT_CNT
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.class_08_pct traf_class_08_pct
                        , a.class_09_pct traf_class_09_pct
                        , a.class_10_pct traf_class_10_pct
                        , a.class_11_pct traf_class_11_pct
                        , a.class_12_pct traf_class_12_pct
                        , a.class_13_pct traf_class_13_pct
                        , a.aadt_cnt traf_aadt_cnt
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_525_PCT_PEAK_COMBINAT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_525_PCT_PEAK_COMBINAT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_mut_truck_peak_pct VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_mut_truck_peak_pct
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.mut_truck_peak_pct traf_mut_truck_peak_pct
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.mut_truck_peak_pct IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_526_K_FACTOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_526_K_FACTOR" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_dsgn_hr_fctr VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_dsgn_hr_fctr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.dsgn_hr_fctr traf_dsgn_hr_fctr
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.dsgn_hr_fctr IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_527_DIR_FACTOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_527_DIR_FACTOR" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_dir_fctr VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_dir_fctr
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.dir_fctr traf_dir_fctr
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.dir_fctr IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_528_FUTURE_AADT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_528_FUTURE_AADT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "VALUE_DATE", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , traf_future_aadt_cnt VALUE_NUMERIC
            , traf_aadt_yr VALUE_DATE
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , TRAF_future_aadt_cnt
                , TO_DATE('01-JAN-' || (TRAF_AADT_YR + 20)) TRAF_AADT_YR
                , OHMS_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp
,c.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp
,c.nm_end_mp) nm_end_mp
                        , a.future_aadt_cnt traf_future_aadt_cnt
                        , a.aadt_yr traf_aadt_yr
                        , c.samp_id ohms_samp_id
                    FROM 
                          v_nm_traf_nw a
                        , OHMS_7_network_mv b
                        , v_nm_ohms_nw c
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.ne_id_of = c.ne_id_of
                        AND a.nm_begin_mp < c.nm_end_mp
                        AND a.nm_end_mp > c.nm_begin_mp
                        AND a.aadt_yr = (SELECT DATA_YEAR() -1 FROM DUAL)
                        AND c.data_yr = (SELECT DATA_YEAR()   FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_531_NUMBER_SIGNALS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_531_NUMBER_SIGNALS" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hpmc_signal_count VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPMC_signal_count
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.signal_count hpmc_signal_count
                    FROM 
                          v_nm_hpmc_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_532_STOP_SIGNS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_532_STOP_SIGNS" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , OHMS_stop_sign_cnt VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , OHMS_stop_sign_cnt
                , OHMS_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.stop_sign_cnt OHMS_stop_sign_cnt
                        , a.samp_id OHMS_samp_id
                    FROM 
                          v_nm_HPMS_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.stop_sign_cnt >0
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_533_AT_GRADE_OTHER
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_533_AT_GRADE_OTHER" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , OHMS_oth_isect_cnt VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , OHMS_oth_isect_cnt
                , OHMS_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.oth_isect_cnt OHMS_oth_isect_cnt
                        , a.samp_id OHMS_samp_id
                    FROM 
                          v_nm_HPMS_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.oth_isect_cnt >0
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_534_LANE_WIDTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_534_LANE_WIDTH" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , rdgm_wd_meas VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , RDGM_wd_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.wd_meas rdgm_wd_meas
                    FROM 
                          v_nm_rdgm_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.iit_x_sect = 'LN1I'
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_535_MEDIAN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_535_MEDIAN_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , rdgm_ln_medn_typ_cd VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , DECODE(RDGM_LN_MEDN_TYP_CD,11,4,6,2,9,2,8,3,1) RDGM_ln_medn_typ_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.ln_medn_typ_cd rdgm_ln_medn_typ_cd
                    FROM 
                          v_nm_rdgm_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.matl_typ_cd IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_536_MEDIAN_WIDTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_536_MEDIAN_WIDTH" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , rdgm_wd_meas VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , RDGM_wd_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.wd_meas rdgm_wd_meas
                    FROM 
                          v_nm_rdgm_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.iit_x_sect = 'MEDN'
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_537_SHOULDER_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_537_SHOULDER_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hpmm_shoulder VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPMM_shoulder
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.shoulder hpmm_shoulder
                    FROM 
                          v_nm_hpmm_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_538_SHOULDER_WIDTH_R
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_538_SHOULDER_WIDTH_R" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_NUMERIC") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
    ,rdgm.wd_meas VALUE_NUMERIC
FROM
    v_nm_rdgm538_sum_mv_nw RDGM
    , OHMS_7_network_mv b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_539_SHOULDER_WIDTH_L
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_539_SHOULDER_WIDTH_L" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_NUMERIC") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
    ,rdgm.wd_meas VALUE_NUMERIC
FROM
    v_nm_rdgm539_sum_mv_nw RDGM
    , OHMS_7_network_mv b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_540_PEAK_PARK_RIGHT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_540_PEAK_PARK_RIGHT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "VALUE_TEXT") AS 
  SELECT      prkr.ne_unique ROUTE_ID
    ,greatest(prkr.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(prkr.nm_end_slk, b. nm_end_slk) END_POINT
    ,prkr.iit_x_sect VALUE_TEXT
FROM
    v_nm_prkr540_count_mv_nw PRKR
    , OHMS_7_network_mv b
WHERE prkr.ne_unique = b.ne_unique
    AND prkr.nm_slk < b.nm_end_slk
    AND prkr.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_544_TERRAIN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_544_TERRAIN_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , terr_typ_cd VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , nvl(TERR_TYP_CD,1) TERR_typ_cd
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.typ_cd terr_typ_cd
                    FROM 
                          v_nm_terr_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.typ_cd IS NOT NULL
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_549_SURFACE_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_549_SURFACE_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hppv_surf_typ VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPPV_surf_typ
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.surf_typ hppv_surf_typ
                    FROM 
                          v_nm_hppv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.surf_typ IS NOT NULL
                        AND a.data_yr = (SELECT DATA_YEAR() FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_556_LAST_OVERLAY_THIC
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_556_LAST_OVERLAY_THIC" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hppv_last_ovlay_thk_meas VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPPV_last_ovlay_thk_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.last_ovlay_thk_meas hppv_last_ovlay_thk_meas
                    FROM 
                          v_nm_hppv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.last_ovlay_thk_meas IS NOT NULL
                        AND a.data_yr = (SELECT DATA_YEAR() FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_557_THICKNESS_RIGID
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_557_THICKNESS_RIGID" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hppv_thk_rigid_meas VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPPV_thk_rigid_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.thk_rigid_meas hppv_thk_rigid_meas
                    FROM 
                          v_nm_hppv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.thk_rigid_meas IS NOT NULL
                        AND a.data_yr = (SELECT DATA_YEAR() FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_558_THICKNESS_FLEXIBL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_558_THICKNESS_FLEXIBL" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hppv_thk_flex_meas VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPPV_thk_flex_meas
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.thk_flex_meas hppv_thk_flex_meas
                    FROM 
                          v_nm_hppv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.thk_flex_meas IS NOT NULL
                        AND a.data_yr = (SELECT DATA_YEAR() FROM DUAL)
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
                        , nm_members_i 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_565_OREGON_FREIGHT_RO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_565_OREGON_FREIGHT_RO" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , ofrg_iit_ne_id VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CASE WHEN OFRG_IIT_NE_ID IS  NOT  NULL THEN 1 END OFRG_iit_ne_id
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.iit_ne_id ofrg_iit_ne_id
                    FROM 
                          v_nm_ofrg_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_566_REGION_DISTRICT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_566_REGION_DISTRICT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , seea_crew VALUE_TEXT
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , SEEA_crew
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.crew seea_crew
                    FROM 
                          v_nm_seea566_outer_mv_nt a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_566_REGION_DIST_UP
--------------------------------------------------------
 CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_566_REGION_DIST_UP" ("RDESC", "DDESC", "CREW") AS 

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


			select REG.NE_DESCR RDESC, DIST.NE_DESCR DDESC, SECW.CREW
			
			from
			SECW, REG, DIST, MEMD, MEMR
			
			where
			
			SECW.NE_ID = MEMD.NM_NE_ID_OF
			and DIST.NE_ID = MEMD.NM_NE_ID_IN
			and DIST.NE_ID = MEMR.NM_NE_ID_OF
			and REG.NE_ID = MEMR.NM_NE_ID_IN

	;




--------------------------------------------------------
--  DDL for View V_OHMS_7_567_PMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_567_PMS" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , hppv_sect_id VALUE_NUMERIC
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , HPPV_sect_id
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.sect_id hppv_sect_id
                    FROM 
                          v_nm_hppv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.sect_id IS NOT NULL
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;

--------------------------------------------------------
--  DDL for View V_OHMS_7_610_PEAK_LANES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_610_PEAK_LANES" ("ROUTE_ID", "BEGIN_POINT", "END_POINT") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
FROM
    v_nm_rdgm610_count_mv_nw RDGM
    , OHMS_7_network_mv b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_611_COUNTER_PEAK_LANE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_611_COUNTER_PEAK_LANE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT") AS 
  SELECT      rdgm.ne_unique ROUTE_ID
    ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
    ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
FROM
    v_nm_rdgm611_count_mv_nw RDGM
    , OHMS_7_network_mv b
WHERE rdgm.ne_unique = b.ne_unique
    AND rdgm.nm_slk < b.nm_end_slk
    AND rdgm.nm_end_slk > b.nm_slk 
;
--------------------------------------------------------
--  DDL for View V_OHMS_7_640_PEAK_PARKING
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_640_PEAK_PARKING" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , decode(PARK_IIT_X_SECT,'B',2,1) PARK_iit_x_sect
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.iit_x_sect park_iit_x_sect
                    FROM 
                          v_nm_park_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
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
                        , nm_members_d 
                    WHERE 
                        ne_id = nm_ne_id_in
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;


--------------------------------------------------------
--  DDL for View V_OHMS_7_743_CURVES_A
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_743_CURVES_A" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , curv_curve_a_len VALUE_NUMERIC
            , curv_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CURV_curve_a_len
                , CURV_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.curve_a_len curv_curve_a_len
                        , a.samp_id curv_samp_id
                    FROM 
                          v_nm_curv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.curve_a_len >0
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
--------------------------------------------------------
--  DDL for View V_OHMS_7_745_CURVES_C
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_745_CURVES_C" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , curv_curve_c_len VALUE_NUMERIC
            , curv_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , CURV_curve_c_len
                , CURV_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.curve_c_len curv_curve_c_len
                        , a.samp_id curv_samp_id
                    FROM 
                          v_nm_curv_nw a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.curve_c_len >0
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
                 ) l
            WHERE
                a.ne_id_of = l.nm_ne_id_of
                AND a.nm_begin_mp < l.nm_end_mp
                AND a.nm_end_mp > l.nm_begin_mp
                )
        WHERE nm_end_slk > nm_slk 

;
