drop materialized view X_MV_BRISTOL_WATER_GEOME2;

create materialized view X_MV_BRISTOL_WATER_GEOME2 AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Bristol Water/GeoMeFeed/X_MV_BRISTOL_WATER_GEOME2.vw-arc   1.0   Apr 22 2013 09:46:42   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_MV_BRISTOL_WATER_GEOME2.vw  $
--       Date into PVCS   : $Date:   Apr 22 2013 09:46:42  $
--       Date fetched Out : $Modtime:   Apr 08 2013 15:19:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems 2013
-----------------------------------------------------------------------------
-- Written for Bristol Water by Aileen Heal to create materalised views used by Geo.ME to access
-- TMA data held in G14 database
--
       TWOR_WORKS_REF,
       TWCA_DESCRIPTION,
       0 DISRUPTION,
       (SDO_CS.transform (g.TPPS_TPHS_GEOMETRY, 8307)).sdo_point.y pos_lat,
       (SDO_CS.transform (g.TPPS_TPHS_GEOMETRY,8307)).sdo_point.x pos_long,
       ORG_NAME,
       STR_DESCR,
       STR_LOCALITY,
       STR_TOWN,
       TPHS_PROPOSED_START_DATE,
       TPHS_EST_END_DATE,
       TPHS_LATEST_END_DATE,
       TPHS_ACT_START_DATE,
       TPHS_ACT_END_DATE,
       tphs_phase_status,
       TPHS_DESCRIPTION
from tma_phases,
     tma_phases_point_sdo g, 
     tma_works,  
     nsg_organisations,
     nsg_districts,
     v_tma_streets,
     tma_works_categories
where 
     twor_works_id = tphs_works_id
     AND tphs_id = TPPS_TPHS_ID
     AND twor_org_ref = org_ref
     AND twor_dist_ref = dist_ref
     AND org_ref = dist_org_ref
     AND twor_str_ne_id = str_ne_id
     AND tphs_works_category = twca_works_category
     AND tphs_active_flag = 'Y'
     AND tphs_works_restricted = '0'
     AND TWOR_ORG_REF = '9111'
     AND TRUNC (TPHS_EST_END_DATE) >= TRUNC (SYSDATE - 21)
     AND (tphs_phase_status = 'WIP'OR tphs_phase_status = 'ABOUT_TO_START')     
/


comment on materialized view X_MV_BRISTOL_WATER_GEOME2 IS
'Written for Bristol Water by Aileen Heal to create materialized views used by Geo.ME to access TMA data held in G14 database'
/

CREATE INDEX X_MV_BRISTOLWATER_GEOME2_INDX1 on X_MV_BRISTOL_WATER_GEOME2(POS_LONG)
/

CREATE INDEX X_MV_BRISTOLWATER_GEOME2_INDX2 on X_MV_BRISTOL_WATER_GEOME2(POS_LAT)
/

CREATE OR REPLACE VIEW X_V_BRISTOL_WATER_GEOME AS SELECT * FROM X_MV_BRISTOL_WATER_GEOME2
/