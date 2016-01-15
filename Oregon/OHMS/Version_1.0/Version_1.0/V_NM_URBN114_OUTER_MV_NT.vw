DROP MATERIALIZED VIEW TRANSINFO.V_NM_URBN114_OUTER_MV_NT;
CREATE MATERIALIZED VIEW TRANSINFO.V_NM_URBN114_OUTER_MV_NT 
TABLESPACE HIGHWAYS
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 12/9/2010 5:08:13 PM (QP5 v5.115.810.9015) */
SELECT   NE_ID,
         NE_UNIQUE,
         NE_LENGTH,
         NE_DESCR,
         NE_START_DATE,
         NE_ADMIN_UNIT,
         ADMIN_UNIT_CODE,
         NE_GTY_GROUP_TYPE,
         URBAN_AREA,
         SMALL_URBAN,
         r.ne_id_of,
         r.nm_begin_mp,
         r.nm_end_mp
  FROM   (SELECT   ne_id_of, nm_begin_mp, nm_end_mp
            FROM   (SELECT   ne_id_of,
                             mp nm_begin_mp,
                             CASE
                                WHEN ne_id_of =
                                        LEAD (ne_id_of)
                                           OVER (ORDER BY ne_id_of, mp)
                                THEN
                                   LEAD (mp) OVER (ORDER BY ne_id_of, mp)
                                ELSE
                                   -1
                             END
                                nm_end_mp
                      FROM   (SELECT   ne_id_of, mp
                                FROM   (SELECT   nm_begin_mp mp,
                                                 nm_ne_id_of ne_id_of
                                          FROM   v_nm_hwy_nt, nm_members
                                         WHERE   ne_id = nm_ne_id_in
                                                 AND ne_unique IS NOT NULL
                                        UNION
                                        SELECT   nm_end_mp mp,
                                                 nm_ne_id_of ne_id_of
                                          FROM   v_nm_hwy_nt, nm_members
                                         WHERE   ne_id = nm_ne_id_in
                                                 AND ne_unique IS NOT NULL)))
           WHERE   nm_end_mp <> -1) r,
         (SELECT   NE_ID,
                   NE_UNIQUE,
                   NE_LENGTH,
                   NE_DESCR,
                   NE_START_DATE,
                   NE_ADMIN_UNIT,
                   ADMIN_UNIT_CODE,
                   NE_GTY_GROUP_TYPE,
                   URBAN_AREA,
                   SMALL_URBAN,
                   nm_ne_id_of ne_id_of,
                   nm_begin_mp,
                   nm_end_mp
            FROM   v_nm_urbn_nt, nm_members
           WHERE   ne_id = nm_ne_id_in) a
 WHERE       r.ne_id_of = a.ne_id_of(+)
         AND r.nm_begin_mp < a.nm_end_mp(+)
         AND r.nm_end_mp > a.nm_begin_mp(+);

COMMENT ON MATERIALIZED VIEW TRANSINFO.V_NM_URBN114_OUTER_MV_NT IS 'snapshot table for snapshot TRANSINFO.V_NM_URBN114_OUTER_MV_NT';

