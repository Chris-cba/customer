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
            --sum(grade_a_length) over (partition by samp_id) +
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
                    , b.nm_end_slk - b.nm_slk sample_length
                from 
                      ohms_grade1 a
                    , OHMS_GRADE2 b
                    
                WHERE a.ne_unique = b.ne_unique
                    AND b.nm_slk < a.nm_end_slk
                    AND b.nm_end_slk > a.nm_slk
                    ))))
WHERE sample_rec_count = 1;

/*
CREATE OR REPLACE VIEW v_nm_grad_ohms_nw AS
    SELECT a.*
        , b.nm_ne_id_of ne_id_of
        , b.nm_begin_mp
        , b.nm_end_mp
    FROM v_nm_grad_ohms a
        , nm_members_all b
    WHERE a.iit_ne_id = b.nm_ne_id_in
        AND b.nm_end_date IS NULL;
*/

CREATE OR REPLACE VIEW v_nm_grad_ohms_nw AS
SELECT a.*
        , b.ne_id_of ne_id_of
        , b.nm_begin_mp
        , b.nm_end_mp
    from V_NM_GRAD_OHMS a
        , V_NM_OHMS_NW B
    where a.IIT_NE_ID = b.iit_ne_id
       ;