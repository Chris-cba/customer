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

CREATE or replace view v_nm_grad_ohms AS

SELECT samp_id
    , sample_iit_ne_id iit_ne_id
    , sample_length
    , grade_a_len
    , grade_b_len
    , grade_c_len
    , grade_d_len
    , grade_e_len
    , grade_f_len
FROM (
    SELECT samp_id
        , sample_iit_ne_id
        , sample_length
        , greatest(sample_length - (
            sum(grade_a_length) over (partition by samp_id) +    -- changed
            sum(grade_b_length) over (partition by samp_id) +
            sum(grade_c_length) over (partition by samp_id) +
            sum(grade_d_length) over (partition by samp_id) +
            sum(grade_e_length) over (partition by samp_id) +
            sum(grade_f_length) over (partition by samp_id)),0) grade_a_len
        , sum(grade_b_length) over (partition by samp_id) grade_b_len
        , sum(grade_c_length) over (partition by samp_id) grade_c_len
        , sum(grade_d_length) over (partition by samp_id) grade_d_len
        , sum(grade_e_length) over (partition by samp_id) grade_e_len
        , sum(grade_f_length) over (partition by samp_id) grade_f_len
        , sample_rec_count
    FROM (
        SELECT samp_id
            , sample_iit_ne_id
            , CASE WHEN grade_type = 'GRADE_A' THEN
                grade_length
              ELSE
                0
              END grade_a_length
            , CASE WHEN grade_type = 'GRADE_B' THEN
                grade_length
              ELSE
                0
              END grade_b_length
            , CASE WHEN grade_type = 'GRADE_C' THEN
                grade_length
              ELSE
                0
              END grade_c_length
            , CASE WHEN grade_type = 'GRADE_D' THEN
                grade_length
              ELSE
                0
              END grade_d_length
            , CASE WHEN grade_type = 'GRADE_E' THEN
                grade_length
              ELSE
                0
              END grade_e_length
            , CASE WHEN grade_type = 'GRADE_F' THEN
                grade_length
              ELSE
                0
              END grade_f_length
            , sample_length
            , sample_rec_count
        FROM (
            SELECT samp_id
                , sample_iit_ne_id
                , sample_length
                , grade_type
                , sum(grade_length) over (partition by samp_id, grade_type, iit_ne_id) grade_length
                , count(samp_id) over (partition by samp_id order by samp_id, grade_type, iit_ne_id) sample_rec_count
            FROM (
                SELECT iit_ne_id
                    , sample_iit_ne_id 
                    , samp_id
                    , grade_type
                    , greatest(a.nm_slk, b.nm_slk) grade_start
                    , least(a.nm_end_slk, b.nm_end_slk) grade_end
                    , round(least(a.nm_end_slk, b.nm_end_slk) - greatest(a.nm_slk, b.nm_slk),3) grade_length
                    , b.ne_unique
                    , b.nm_slk
                    , b.nm_end_slk
                    --, b.nm_end_slk - b.nm_slk sample_length   */ wrong table? /*
					, a.nm_end_slk - a.nm_slk sample_length
                from 
                      ohms_grade1 a
                    , OHMS_GRADE2 b
                    
                WHERE a.ne_unique = b.ne_unique
                    AND b.nm_slk < a.nm_end_slk
                    AND b.nm_end_slk > a.nm_slk
                    ))))
WHERE sample_rec_count = 1;

CREATE OR REPLACE VIEW v_nm_grad_ohms_nw AS
SELECT a.*
        , b.ne_id_of ne_id_of
        , b.nm_begin_mp
        , b.nm_end_mp
    from V_NM_GRAD_OHMS a
        , V_NM_OHMS_NW B
    where a.IIT_NE_ID = b.iit_ne_id
	
	
       ;
	   

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