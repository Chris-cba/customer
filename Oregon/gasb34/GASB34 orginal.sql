CREATE OR REPLACE FORCE VIEW "TRANSINFO"."XODOT_GASB34" ("HWY_UNIQUE",
  "HIGHWAY_NUMBER", "SUFFIX", "ROADWAY_ID", "MILEAGE_TYPE",
  "OVERLAP_MILEAGE_CODE", "ROAD_DIRECTION", "ROAD_TYPE", "TRANS_UNIQUE",
  "PREVIOUS_INCR_MILEAGE", "PREVIOUS_DECR_MILEAGE", "POST_INCR_MILEAGE",
  "POST_DECR_MILEAGE", "OFFICIAL_TRANSFER_DATE", "OFFICIAL_TRANSFER_ID",
  "OFFICIAL_TRANSFER_TYPE", "AGREEMENT_TRANSFER_COMMENT", "TRANSFER_FROM",
  "TRANSFER_TO")
AS
  SELECT
    hwy.ne_unique hwy_unique ,
    NE_OWNER Highway_Number ,
    NE_SUB_TYPE suffix ,
    NE_PREFIX Roadway_ID ,
    NE_NAME_1 Mileage_Type ,
    NE_NAME_2 Overlap_Mileage_Code ,
    NE_NUMBER Road_Direction ,
    NE_GROUP road_type ,
    p.trans_unique ,
    NVL(PREVIOUS_INCR_MILEAGE ,0) PREVIOUS_INCR_MILEAGE ,
    NVL(PREVIOUS_DECR_MILEAGE ,0) PREVIOUS_DECR_MILEAGE ,
    NVL(POST_INCR_MILEAGE,0) POST_INCR_MILEAGE ,
    NVL(POST_DECR_MILEAGE,0) POST_DECR_MILEAGE ,
    Official_Transfer_Date ,
    Official_Transfer_ID ,
    Official_Transfer_Type ,
    Agreement_Transfer_Comment ,
    Transfer_From ,
    Transfer_To
  FROM
    nm_elements_all hwy,
    (
      SELECT DISTINCT
        ne_unique trans_unique ,
        h.nm_ne_id_in hwy_ne_id ,
        NE_NAME_2 Official_Transfer_Date ,
        NE_NSG_REF Official_Transfer_ID ,
        IIT_CHR_ATTRIB58 Agreement_Transfer_Comment ,
        IIT_CHR_ATTRIB28 Transfer_From ,
        NE_VERSION_NO Official_Transfer_Type ,
        NE_NAME_1 Transfer_To
      FROM
        nm_elements_all ,
        nm_inv_items_all ,
        NM_NW_AD_LINK_ALL l ,
        nm_members_all t ,
        nm_members_all h
      WHERE
        ne_nt_type        = 'TRNF'
      AND ne_name_2      IS NOT NULL
      AND iit_inv_type    = 'TRNF'
      AND L.NAD_IIT_NE_ID = iit_ne_id
      AND L.NAD_NE_ID     = ne_id
      AND ne_name_2      IS NOT NULL
      AND ne_id           = t.nm_ne_id_in
      AND t.nm_ne_id_of   = h.nm_ne_id_of
      AND h.nm_obj_type   = 'HWY'
    )
    p,
    -- PREVIOUS_INCR_MILEAGE
    (
      SELECT
        nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
        t.hwy_ne_id,
        t.ne_unique trans_unique ,
        SUM(rm.nm_end_mp - rm.nm_begin_mp ) PREVIOUS_INCR_MILEAGE
      FROM
        nm_members_all hh,
        nm_members_all rm,
        nm_inv_items_all ri,
        (
          SELECT
            hm.nm_ne_id_in hwy_ne_id ,
            t.ne_unique ,
            t.OFFICIAL_TRANSFER_DATE
          FROM
            v_nm_trnf_trnf_nt t,
            nm_members_all tm,
            nm_members_all hm
          WHERE
            hm. nm_obj_type    = 'HWY'
          AND t.ne_id          = tm.nm_ne_id_in
          AND tm.nm_ne_id_of   = hm.nm_ne_id_of
          AND TM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
          AND
            (
              TM.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
            OR TM.NM_END_DATE IS NULL
            )
          AND hM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
          AND
            (
              hM.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
            OR hM.NM_END_DATE IS NULL
            )
          GROUP BY
            hm.nm_ne_id_in,
            t.ne_unique,
            t.OFFICIAL_TRANSFER_DATE
        )
        t
      WHERE
        hh.nm_obj_type    = 'HWY'
      AND hh.nm_ne_id_in  = t.hwy_ne_id
      AND rm.nm_obj_type  = 'RDGM'
      AND hh.nm_ne_id_of  = rm.nm_ne_id_of
      AND ri.iit_inv_type = 'RDGM'
      AND rm.nm_ne_id_in  = ri.iit_ne_id
      AND ri.iit_x_sect LIKE 'LN_I'
      AND RI.IIT_NO_OF_UNITS = 1
      AND hh.NM_START_DATE   < t.OFFICIAL_TRANSFER_DATE
      AND
        (
          hh.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
        OR hh.NM_END_DATE IS NULL
        )
      AND rm.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
      AND
        (
          rm.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
        OR rm.NM_END_DATE IS NULL
        )
      GROUP BY
        hwy_ne_id,
        t.ne_unique
    )
    a,
    -- PREVIOUS_DECR_MILEAGE
    (
      SELECT
        nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
        t.hwy_ne_id,
        t.ne_unique trans_unique ,
        SUM(rm.nm_end_mp - rm.nm_begin_mp ) PREVIOUS_DECR_MILEAGE
      FROM
        nm_members_all hh,
        nm_members_all rm,
        nm_inv_items_all ri,
        (
          SELECT
            hm.nm_ne_id_in hwy_ne_id ,
            t.ne_unique ,
            t.OFFICIAL_TRANSFER_DATE
          FROM
            v_nm_trnf_trnf_nt t,
            nm_members_all tm,
            nm_members_all hm
          WHERE
            hm. nm_obj_type    = 'HWY'
          AND t.ne_id          = tm.nm_ne_id_in
          AND tm.nm_ne_id_of   = hm.nm_ne_id_of
          AND TM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
          AND
            (
              TM.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
            OR TM.NM_END_DATE IS NULL
            )
          AND hM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
          AND
            (
              hM.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
            OR hM.NM_END_DATE IS NULL
            )
          GROUP BY
            hm.nm_ne_id_in,
            t.ne_unique,
            t.OFFICIAL_TRANSFER_DATE
        )
        t
      WHERE
        hh.nm_obj_type    = 'HWY'
      AND hh.nm_ne_id_in  = t.hwy_ne_id
      AND rm.nm_obj_type  = 'RDGM'
      AND hh.nm_ne_id_of  = rm.nm_ne_id_of
      AND ri.iit_inv_type = 'RDGM'
      AND rm.nm_ne_id_in  = ri.iit_ne_id
      AND ri.iit_x_sect LIKE 'LN_D'
      AND RI.IIT_NO_OF_UNITS = 1
      AND hh.NM_START_DATE   < t.OFFICIAL_TRANSFER_DATE
      AND
        (
          hh.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
        OR hh.NM_END_DATE IS NULL
          )
        AND rm.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE
        AND
          (
            rm.NM_END_DATE  >= t.OFFICIAL_TRANSFER_DATE
          OR rm.NM_END_DATE IS NULL
          )
        GROUP BY
          hwy_ne_id,
          t.ne_unique
    )
    b,
    -- POST_INCR_MILEAGE
    (
      SELECT
        nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
        t.hwy_ne_id,
        t.ne_unique trans_unique ,
        SUM(rm.nm_end_mp - rm.nm_begin_mp ) POST_INCR_MILEAGE
      FROM
        nm_members_all hh,
        nm_members_all rm,
        nm_inv_items_all ri,
        (
          SELECT
            hm.nm_ne_id_in hwy_ne_id ,
            t.ne_unique ,
            t.OFFICIAL_TRANSFER_DATE
          FROM
            v_nm_trnf_trnf_nt t,
            nm_members_all tm,
            nm_members_all hm
          WHERE
            hm. nm_obj_type    = 'HWY'
          AND t.ne_id          = tm.nm_ne_id_in
          AND tm.nm_ne_id_of   = hm.nm_ne_id_of
          AND TM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
          AND
            (
              TM.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
            OR TM.NM_END_DATE IS NULL
            )
          AND hM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
          AND
            (
              hM.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
            OR hM.NM_END_DATE IS NULL
            )
          GROUP BY
            hm.nm_ne_id_in,
            t.ne_unique,
            t.OFFICIAL_TRANSFER_DATE
        )
        t
      WHERE
        hh.nm_obj_type    = 'HWY'
      AND hh.nm_ne_id_in  = t.hwy_ne_id
      AND rm.nm_obj_type  = 'RDGM'
      AND hh.nm_ne_id_of  = rm.nm_ne_id_of
      AND ri.iit_inv_type = 'RDGM'
      AND rm.nm_ne_id_in  = ri.iit_ne_id
      AND ri.iit_x_sect LIKE 'LN_I'
      AND RI.IIT_NO_OF_UNITS = 1
      AND hh.NM_START_DATE   = t.OFFICIAL_TRANSFER_DATE
      AND
        (
          hh.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
        OR hh.NM_END_DATE IS NULL
          )
        AND rm.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
        AND
          (
            rm.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
          OR rm.NM_END_DATE IS NULL
          )
        GROUP BY
          hwy_ne_id,
          t.ne_unique
    )
    c ,
    -- POST_DECR_MILEAGE
    (
      SELECT
        nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
        t.hwy_ne_id,
        t.ne_unique trans_unique ,
        SUM(rm.nm_end_mp - rm.nm_begin_mp ) POST_DECR_MILEAGE
      FROM
        nm_members_all hh,
        nm_members_all rm,
        nm_inv_items_all ri,
        (
          SELECT
            hm.nm_ne_id_in hwy_ne_id ,
            t.ne_unique ,
            t.OFFICIAL_TRANSFER_DATE
          FROM
            v_nm_trnf_trnf_nt t,
            nm_members_all tm,
            nm_members_all hm
          WHERE
            hm. nm_obj_type    = 'HWY'
          AND t.ne_id          = tm.nm_ne_id_in
          AND tm.nm_ne_id_of   = hm.nm_ne_id_of
          AND TM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
          AND
            (
              TM.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
            OR TM.NM_END_DATE IS NULL
            )
          AND hM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
          AND
            (
              hM.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
            OR hM.NM_END_DATE IS NULL
            )
          GROUP BY
            hm.nm_ne_id_in,
            t.ne_unique,
            t.OFFICIAL_TRANSFER_DATE
        )
        t
      WHERE
        hh.nm_obj_type    = 'HWY'
      AND hh.nm_ne_id_in  = t.hwy_ne_id
      AND rm.nm_obj_type  = 'RDGM'
      AND hh.nm_ne_id_of  = rm.nm_ne_id_of
      AND ri.iit_inv_type = 'RDGM'
      AND rm.nm_ne_id_in  = ri.iit_ne_id
      AND ri.iit_x_sect LIKE 'LN_D'
      AND RI.IIT_NO_OF_UNITS = 1
      AND hh.NM_START_DATE   = t.OFFICIAL_TRANSFER_DATE
      AND
        (
          hh.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
        OR hh.NM_END_DATE IS NULL
          )
        AND rm.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE
        AND
          (
            rm.NM_END_DATE   > t.OFFICIAL_TRANSFER_DATE
          OR rm.NM_END_DATE IS NULL
          )
        GROUP BY
          hwy_ne_id,
          t.ne_unique
    )
    d
  WHERE
    p.trans_unique   = a.trans_unique(+)
  AND p.trans_unique = b.trans_unique(+)
  AND p.trans_unique = c.trans_unique(+)
  AND p.trans_unique = d.trans_unique(+)
  AND p.hwy_ne_id    = a.hwy_ne_id(+)
  AND p.hwy_ne_id    = b.hwy_ne_id(+)
  AND p.hwy_ne_id    = c.hwy_ne_id(+)
  AND p.hwy_ne_id    = d.hwy_ne_id(+)
  AND p.hwy_ne_id    = hwy.ne_id
  AND hwy.ne_nt_type = 'HWY';