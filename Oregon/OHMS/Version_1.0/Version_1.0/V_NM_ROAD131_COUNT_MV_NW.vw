DROP MATERIALIZED VIEW TRANSINFO.V_NM_ROAD131_COUNT_MV_NW;
CREATE MATERIALIZED VIEW TRANSINFO.V_NM_ROAD131_COUNT_MV_NW 
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
/* Formatted on 12/9/2010 4:41:40 PM (QP5 v5.115.810.9015) */
SELECT   road_cntl_typ_cd,
         ohms_samp_id,
         iit_ne_id,
         ne_id_of,
         nm_begin_mp,
         nm_end_mp
  FROM   (SELECT   cntl_typ_cd road_cntl_typ_cd,
                   samp_id ohms_samp_id,
                   b.iit_ne_id,
                   b.ne_id_of,
                   b.nm_begin_mp,
                   b.nm_end_mp,
                   CASE
                      WHEN b.nm_begin_mp = b.nm_end_mp
                           AND b.iit_ne_id =
                                 LAG (b.iit_ne_id)
                                    OVER (ORDER BY b.ne_id_of, b.nm_begin_mp)
                      THEN
                         'Y'
                      ELSE
                         'N'
                   END
                      DUPLICATE_RECORD
            FROM   v_nm_ohms_nw a, v_nm_road_nw b
           WHERE       1 = 1
                   AND a.ne_id_of = b.ne_id_of
                   AND a.nm_begin_mp <= b.nm_end_mp
                   AND a.nm_end_mp >= b.nm_begin_mp
                   AND b.cntl_typ_cd = 3)
 WHERE   DUPLICATE_RECORD = 'N';

COMMENT ON MATERIALIZED VIEW TRANSINFO.V_NM_ROAD131_COUNT_MV_NW IS 'snapshot table for snapshot TRANSINFO.V_NM_ROAD131_COUNT_MV_NW';

