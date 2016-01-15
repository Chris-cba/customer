--------------------------------------------------------
--  DDL for View V_OHMS_7_749_GRADES_A
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_749_GRADES_A" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_a_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_a_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_a_len grad_grade_a_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_a_len >0
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
--  DDL for View V_OHMS_7_750_GRADES_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_750_GRADES_B" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_b_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_b_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_b_len grad_grade_b_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_b_len >0
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
--  DDL for View V_OHMS_7_751_GRADES_C
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_751_GRADES_C" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_c_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_c_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_c_len grad_grade_c_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_c_len >0
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
--  DDL for View V_OHMS_7_752_GRADES_D
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_752_GRADES_D" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_d_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_d_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_d_len grad_grade_d_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_d_len >0
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
--  DDL for View V_OHMS_7_753_GRADES_E
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_753_GRADES_E" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_e_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_e_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_e_len grad_grade_e_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_e_len >0
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
--  DDL for View V_OHMS_7_754_GRADES_F
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_754_GRADES_F" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS", "NE_ID_OF", "NM_BEGIN_MP", "NM_END_MP") AS 
  SELECT
 
            ne_unique ROUTE_ID
            , nm_slk BEGIN_POINT
            , nm_end_slk END_POINT
            , nm_end_slk-nm_slk SECTION_LENGTH
            , grad_grade_f_len VALUE_NUMERIC
            , grad_samp_id COMMENTS
            , ne_id_of, nm_begin_mp, nm_end_mp
        FROM (
            SELECT   
                l.ne_unique
                , decode(l.nm_cardinality, 1, l.nm_slk + (greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/1 - l.nm_begin_mp/1,                     l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1) NM_SLK                , decode(l.nm_cardinality, 1, l.nm_end_slk - (l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/1,                     l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), l.nm_begin_mp))/1) NM_END_SLK                , l.nm_ne_id_of ne_id_of
                , greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp) nm_begin_mp
                , least(nvl(a.nm_end_mp,999),l.nm_end_mp) nm_end_mp
                , GRAD_grade_f_len
                , GRAD_SAMP_ID
            FROM (
                    SELECT 
                        a.ne_id_of 
                        , greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp
                        , least(a.nm_end_mp, b.nm_end_mp) nm_end_mp
                        , a.grade_f_len grad_grade_f_len
                        , a.samp_id grad_samp_id
                    FROM 
                          V_NM_GRAD_OHMS_NW a
                        , OHMS_7_network_mv b
                    WHERE
                        a.ne_id_of = b.ne_id_of
                        AND a.nm_begin_mp < b.nm_end_mp
                        AND a.nm_end_mp > b.nm_begin_mp
                        AND a.grade_f_len >0
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