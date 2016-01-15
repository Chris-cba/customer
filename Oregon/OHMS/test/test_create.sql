DROP TABLE v_nm_elea566_outer_mv_nt;

CREATE TABLE v_nm_elea566_outer_mv_nt AS
       SELECT 
                NE_ID
                , NE_UNIQUE
                , NE_LENGTH
                , NE_DESCR
                , NE_START_DATE
                , NE_ADMIN_UNIT
                , ADMIN_UNIT_CODE
                , NE_GTY_GROUP_TYPE
                , HIGHWAY_EA_NUMBER
                , CREW
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
                                AND nm_obj_type IN ('HWY','ELEA')
                            UNION
                            SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp
                            FROM nm_members
                            WHERE nm_type = 'G'
                                AND nm_obj_type IN ('HWY','ELEA')

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
                NE_ID
                , NE_UNIQUE
                , NE_LENGTH
                , NE_DESCR
                , NE_START_DATE
                , NE_ADMIN_UNIT
                , ADMIN_UNIT_CODE
                , NE_GTY_GROUP_TYPE
                , HIGHWAY_EA_NUMBER
                , CREW
                , nm_ne_id_of ne_id_of
                , nm_begin_mp
                , nm_end_mp
            FROM
                v_nm_elea_nt
                , nm_members 
            WHERE
               ne_id = nm_ne_id_in
            ) a 
        WHERE
            r.ne_id_of = a.ne_id_of(+)
                AND r.nm_begin_mp < a.nm_end_mp(+)
                AND r.nm_end_mp > a.nm_begin_mp(+)
        ;

CREATE INDEX v_nm_elea566_outer_mv_nt_IDX ON v_nm_elea566_outer_mv_nt(NE_ID_OF);