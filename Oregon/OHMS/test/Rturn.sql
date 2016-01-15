SELECT count(*)
FROM (
    SELECT min(nm_ne_id_in) min_ne
        , nm_ne_id_of
        , nm_begin_mp
    FROM (
        SELECT b.*
        FROM (
            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_slk < cp_slk THEN
                        (cp_slk - nm_slk) + nm_begin_mp
                    ELSE
                        nm_begin_mp
                    END
                  ELSE
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_begin_mp + (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_end_mp - (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_end_mp
                    END
                  ELSE
                    CASE WHEN nm_slk < cp_slk THEN
                        nm_end_mp - (cp_slk - nm_slk)
                    ELSE
                        nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
            where 
            --c.ne_unique = cp_route
                 c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                and D.NM_END_DATE is null
--                AND d.nm_end_slk > cp_slk
--                and D.NM_SLK <  CP_END_SLK
                ) a
            , (SELECT nm_ne_id_in
                    , nm_ne_id_of
                    , nm_begin_mp
                    , nm_end_mp
                FROM nm_members_all 
                WHERE nm_obj_type = 'URBN'
                    AND nm_end_date IS NULL) b
        WHERE a.nm_ne_id_of = b.nm_ne_id_of
            AND b.nm_begin_mp < a.nm_end_mp
            and B.NM_END_MP > a.NM_BEGIN_MP)
    GROUP BY nm_ne_id_of, nm_begin_mp);