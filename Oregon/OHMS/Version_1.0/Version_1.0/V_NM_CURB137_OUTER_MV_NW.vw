DROP MATERIALIZED VIEW TRANSINFO.V_NM_CURB137_OUTER_MV_NW;
CREATE MATERIALIZED VIEW TRANSINFO.V_NM_CURB137_OUTER_MV_NW 
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
/* Formatted on 12/9/2010 4:25:27 PM (QP5 v5.115.810.9015) */
SELECT   IIT_NE_ID,
         IIT_INV_TYPE,
         IIT_PRIMARY_KEY,
         IIT_START_DATE,
         IIT_DATE_CREATED,
         IIT_DATE_MODIFIED,
         IIT_CREATED_BY,
         IIT_MODIFIED_BY,
         IIT_ADMIN_UNIT,
         IIT_DESCR,
         IIT_NOTE,
         IIT_PEO_INVENT_BY_ID,
         NAU_UNIT_CODE,
         IIT_X_SECT,
         IIT_END_DATE,
         TYP_CD,
         HT_CD,
         COND_CD,
         SRCE_TYP,
         NOTE,
         INSP_YR,
         MEMBER_UNIQUE,
         NM_SEQ_NO,
         NM_START_DATE,
         NM_END_DATE,
         NM_ADMIN_UNIT,
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
         (SELECT   IIT_NE_ID,
                   IIT_INV_TYPE,
                   IIT_PRIMARY_KEY,
                   IIT_START_DATE,
                   IIT_DATE_CREATED,
                   IIT_DATE_MODIFIED,
                   IIT_CREATED_BY,
                   IIT_MODIFIED_BY,
                   IIT_ADMIN_UNIT,
                   IIT_DESCR,
                   IIT_NOTE,
                   IIT_PEO_INVENT_BY_ID,
                   NAU_UNIT_CODE,
                   IIT_X_SECT,
                   IIT_END_DATE,
                   TYP_CD,
                   HT_CD,
                   COND_CD,
                   SRCE_TYP,
                   NOTE,
                   INSP_YR,
                   MEMBER_UNIQUE,
                   NM_SEQ_NO,
                   NM_START_DATE,
                   NM_END_DATE,
                   NM_ADMIN_UNIT,
                   ne_id_of,
                   nm_begin_mp,
                   nm_end_mp
            FROM   v_nm_curb_nw) a
 WHERE       r.ne_id_of = a.ne_id_of(+)
         AND r.nm_begin_mp < a.nm_end_mp(+)
         AND r.nm_end_mp > a.nm_begin_mp(+);

COMMENT ON MATERIALIZED VIEW TRANSINFO.V_NM_CURB137_OUTER_MV_NW IS 'snapshot table for snapshot TRANSINFO.V_NM_CURB137_OUTER_MV_NW';

