CREATE OR REPLACE VIEW v_nm_grad_ohms AS
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
                FROM (
                    SELECT iit_ne_id 
                        , grade_type
                        , ne_unique
                        , nm_slk
                        , nm_end_slk
                    FROM (
                        SELECT c.iit_ne_id
                            , a.ne_unique
                           , CASE 
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
                            AND b.nm_begin_mp <= d.nm_begin_mp
                            AND b.nm_end_mp >= d.nm_end_mp)) a
                    , (
                    SELECT samp_id
                        , sample_iit_ne_id
                        , ne_unique
                        , nm_slk
                        , nm_end_slk
                        , nm_end_slk - nm_slk sample_length
                    FROM (
                        SELECT samp_id
                            , sample_iit_ne_id
                            , ne_unique
                            , nm_slk slk
                            , min(nm_slk) over (partition by samp_id) nm_slk
                            , max(nm_end_slk) over (partition by samp_id) nm_end_slk
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
                                --, nm_inv_items_all c
                                --, nm_members_all d
                            WHERE a.ne_id = b.nm_ne_id_in
                                AND a.ne_nt_type = 'HWY'
                                AND a.ne_end_date IS NULL
                                AND b.nm_end_date IS NULL
                                --AND c.iit_ne_id = d.nm_ne_id_in
                                --AND c.iit_inv_type = 'HPMS'
                               --AND c.iit_end_date IS NULL
                                --AND c.iit_power = (select data_year() from dual)
                                --AND d.nm_end_date IS NULL
                                AND c.ne_id_of = b.nm_ne_id_of
                                AND b.nm_begin_mp < c.nm_end_mp
                                AND b.nm_end_mp > c.nm_begin_mp))
                    WHERE slk = nm_slk) b
                WHERE a.ne_unique = b.ne_unique
                    AND b.nm_slk < a.nm_end_slk
                    AND b.nm_end_slk > a.nm_slk
                    ))))
WHERE sample_rec_count = 1;                

CREATE OR REPLACE VIEW v_nm_grad_nw AS
    SELECT a.*
        , b.nm_ne_id_of ne_id_of
        , b.nm_begin_mp
        , b.nm_end_mp
    FROM v_nm_grad a
        , nm_members_all b
    WHERE a.iit_ne_id = b.nm_ne_id_in
        AND b.nm_end_date IS NULL;