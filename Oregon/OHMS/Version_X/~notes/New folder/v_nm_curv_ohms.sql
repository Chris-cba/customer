
CREATE OR REPLACE VIEW v_nm_curv_ohms AS
SELECT d.iit_ne_id 
    , d.samp_id
    , CASE WHEN sample_len > nvl(a.total_curve_len,0) THEN
        nvl(a.curve_a_len,0) + (sample_len - nvl(a.total_curve_len,0))
      WHEN sample_len < nvl(a.total_curve_len,0) THEN
            CASE WHEN nvl(a.curve_a_len,0) - (nvl(a.total_curve_len,0) - sample_len) < 0 THEN
               0
            ELSE
              nvl(a.curve_a_len,0) - (nvl(a.total_curve_len,0) - sample_len)
            END
      ELSE
        nvl(a.curve_a_len,0)
      END curve_a_len
    , nvl(a.curve_b_len,0) curve_b_len
    , nvl(a.curve_c_len,0) curve_c_len
    , nvl(a.curve_d_len,0) curve_d_len
    , nvl(a.curve_e_len,0) curve_e_len
    , nvl(a.curve_f_len,0) curve_f_len
    , nvl(a.total_curve_len,0) total_curve_len
    , d.sample_len
FROM (
    SELECT samp_id
        , sum(curve_a_len) curve_a_len
        , sum(curve_b_len) curve_b_len
        , sum(curve_c_len) curve_c_len
        , sum(curve_d_len) curve_d_len
        , sum(curve_e_len) curve_e_len
        , sum(curve_f_len) curve_f_len
        , sum(curve_a_len + curve_b_len + curve_c_len + curve_d_len + curve_e_len +curve_f_len) total_curve_len
    FROM (        
        SELECT   samp_id
            , decode(curve_type,'CURVE_A', curve_len,0) curve_a_len
            , decode(curve_type,'CURVE_B', curve_len,0) curve_b_len
            , decode(curve_type,'CURVE_C', curve_len,0) curve_c_len
            , decode(curve_type,'CURVE_D', curve_len,0) curve_d_len
            , decode(curve_type,'CURVE_E', curve_len,0) curve_e_len
            , decode(curve_type,'CURVE_F', curve_len,0) curve_f_len
        FROM (    
            SELECT c.samp_id
                , CASE 
                  WHEN round(a.iit_num_attrib110,1) between 3.5 and 5.4 THEN
                    'CURVE_B'
                  WHEN round(a.iit_num_attrib110,1) between 5.5 and 8.4 THEN
                    'CURVE_C'
                  WHEN round(a.iit_num_attrib110,1) between 8.5 and 13.9 THEN
                    'CURVE_D'
                  WHEN round(a.iit_num_attrib110,1) between 14 and 27.9  THEN
                    'CURVE_E'
                  WHEN round(a.iit_num_attrib110,1) > 28  THEN
                    'CURVE_F' 
                  ELSE
                    'CURVE_A'
                  END curve_type
                , least(nvl(b.nm_end_mp,9999), c.nm_end_mp) - greatest(nvl(b.nm_begin_mp,0), c.nm_begin_mp) curve_len
            FROM nm_inv_items_all a
                , nm_members_all b
				,	v_nm_ohms_nw c
                --, nm_inv_items_all c
                --, nm_members_all d
            WHERE a.iit_inv_type = 'HZCV'
                AND a.iit_end_date IS NULL
                --AND c.iit_inv_type = 'HPMS'
               -- AND c.iit_power = (SELECT data_year() FROM DUAL)
               -- AND c.iit_end_date IS NULL
                AND a.iit_ne_id = b.nm_ne_id_in
                AND b.nm_end_date IS NULL
                --AND c.iit_ne_id = d.nm_ne_id_in
                --AND d.nm_end_date IS NULL 
                AND b.nm_ne_id_of = c.ne_id_of
                AND c.nm_begin_mp < b.nm_end_mp
                AND c.nm_end_mp > b.nm_begin_mp))
    GROUP BY samp_id) a       
    , (SELECT sum(nm_end_mp - nm_begin_mp) sample_len, iit_ne_id, samp_id
        FROM --nm_inv_items_all x
				v_nm_ohms_nw x
            --, nm_members_all y
        --WHERE 
			--x.iit_inv_type = 'HPMS'
           --- AND x.iit_end_date IS NULL
           -- AND x.iit_power = (select data_year() from dual)
            --AND x.iit_ne_id = y.nm_ne_id_in
            --AND y.nm_end_date IS NULL
        GROUP BY samp_id, iit_ne_id) d
WHERE  a.samp_id(+) = d.samp_id;


CREATE OR REPLACE VIEW v_nm_curv_ohms_nw AS
 
		
	SELECT a.*
        , b.ne_id_of ne_id_of
        , b.nm_begin_mp
        , B.NM_END_MP
    from V_NM_CURV_ohms a
        , v_nm_ohms_nw b
    where a.IIT_NE_ID = b.iit_ne_id
	;