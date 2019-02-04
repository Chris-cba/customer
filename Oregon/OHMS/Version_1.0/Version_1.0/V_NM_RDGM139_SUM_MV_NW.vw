DROP MATERIALIZED VIEW TRANSINFO.V_NM_RDGM139_SUM_MV_NW;
CREATE MATERIALIZED VIEW TRANSINFO.V_NM_RDGM139_SUM_MV_NW 
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
/* Formatted on 12/9/2010 4:40:27 PM (QP5 v5.115.810.9015) */
SELECT   rdgm_wd_meas,
         iit_ne_id,
         ne_id_of,
         nm_begin_mp,
         nm_end_mp
  FROM   (SELECT   wd_meas rdgm_wd_meas,
                   b.iit_ne_id,
                   b.ne_id_of,
                   b.nm_begin_mp,
                   b.nm_end_mp,
                   'N' DUPLICATE_RECORD
            FROM   v_nm_rdgm_nw b
           WHERE   1 = 1 AND b.iit_x_sect IN ('IS1', 'IS2'))
 WHERE   DUPLICATE_RECORD = 'N';

COMMENT ON MATERIALIZED VIEW TRANSINFO.V_NM_RDGM139_SUM_MV_NW IS 'snapshot table for snapshot TRANSINFO.V_NM_RDGM139_SUM_MV_NW';
