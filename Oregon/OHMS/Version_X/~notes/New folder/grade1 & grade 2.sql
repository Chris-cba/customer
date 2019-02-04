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
create index inx_ohms_grade1 on OHMS_GRADE1(samp_id, NE_UNIQUE);


--------------------------
--------------------------
--------------------------

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

create index inx_ohms_grade2 on OHMS_GRADE2(iit_ne_id, NE_UNIQUE);