drop materialized  view X_MV_BRISTOL_WATER_GEOME2;


create materialized  view X_MV_BRISTOL_WATER_GEOME2
AS SELECT a.TWOR_WORKS_ID,
       a.TWOR_WORKS_REF,
       a.TWOR_ORG_REF,
       a.TWOR_DIST_REF,
       a.TWOR_NO_OF_PHASES,
       a.TWOR_STR_NE_ID,
       a.TWOR_ACTUAL_WORKS_REF,
       a.TWOR_LICENCE_ID,
       a.TWOR_EXTERNAL_REF,
       a.ORG_NAME,
       a.ORG_PREFIX,
       a.DIST_NAME,
       a.DIST_PREFIX,
       a.STR_USRN,
       a.STR_DESCR,
       a.STR_LOCALITY,
       a.STR_TOWN,
       a.STR_COUNTY,
       a.STR_PROVISIONAL_STREET_FLAG,
       a.TPHS_ACTIVE_FLAG,
       a.TPHS_PHASE_NO,
       a.TPHS_DESCRIPTION,
       a.TPHS_PHASE_STATUS,
       a.TPHS_WORKS_CATEGORY,
       a.TWCA_DESCRIPTION,
       a.TPHS_PHASE_TYPE,
       a.PHASE_TYPE_MEANING,
       a.TPHS_PROPOSED_START_DATE,
       a.TPHS_EST_END_DATE,
       a.TPHS_LATEST_START_DATE,
       a.TPHS_LATEST_END_DATE,
       a.TPHS_ACT_START_DATE,
       a.TPHS_ACT_END_DATE,
       a.TPHS_START_DATE,
       a.TPHS_END_DATE,
       a.PHASE_STATUS_MEANING,
       a.TPHS_REINST_CAT,
       a.TPHS_PHASE_ID,
       a.TPHS_LOC_DESCRIPTION,
       a.TPHS_CHALLENGED,
       ---1 DISRUPTION,
       --g.TPPS_TPHS_GEOMETRY,
       g.TPPS_TPHS_GEOMETRY.sdo_point.x east,
       g.TPPS_TPHS_GEOMETRY.sdo_point.y north,
       (SDO_CS.transform (g.TPPS_TPHS_GEOMETRY,8307)).sdo_point.x pos_long,
       (SDO_CS.transform (g.TPPS_TPHS_GEOMETRY, 8307)).sdo_point.y pos_lat
  FROM v_tma_w_active_phase_dets_g14 a,
       TMA_PHASES_POINT_SDO g
 WHERE     TWOR_ORG_REF = '9111'
       AND a.tphs_phase_id = g.TPPS_TPHS_ID
       AND TRUNC (a.TPHS_EST_END_DATE) >= TRUNC (SYSDATE - 21)
       -- AND a.TWOR_WORKS_REF = b.REF
/

CREATE INDEX X_MV_BRISTOL_WATER2_INDX1 ON X_MV_BRISTOL_WATER_GEOME2(POS_LONG)
/

CREATE INDEX X_MV_BRISTOL_WATER2_INDX2 ON X_MV_BRISTOL_WATER_GEOME2(POS_LAT)
/
