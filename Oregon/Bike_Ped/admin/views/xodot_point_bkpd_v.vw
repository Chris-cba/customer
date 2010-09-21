CREATE OR REPLACE FORCE VIEW XODOT_POINT_BKPD_V
(
   ADAR_RAMP_TYP_CD,
   ADAR_XSP,
   ADAR_CROSS_ST_NM,
   ADAR_RAMP_FUNC_COND_CD,
   ADAR_RAMP_PHYS_COND_CD,
   ADAR_RAMP_NEED_IND,
   ADAR_RAMP_INSP_YR,
   ADAR_RAMP_NOTE,
   MBXG_PRIMARY_KEY,
   FIPS_CITY_ID_LEFT,
   CITY_GNIS_ID_LEFT,
   CITY_POP_CNT_LEFT,
   FIPS_CITY_ID_RIGHT,
   CITY_GNIS_ID_RIGHT,
   CITY_POP_CNT_RIGHT,
   URBAN_AREA,
   EA,
   DISTRICT,
   REGION,
   HWY,
   BEGIN_MP,
   END_MP,
   HIGHWAY_NUMBER,
   SUFFIX,
   ROADWAY_ID,
   MILEAGE_TYPE,
   OVERLAP_MILEAGE_CODE,
   ROAD_DIRECTION,
   ROAD_TYPE,
   RTE_TYPE_IS,
   RTE_TYPE_US_1,
   RTE_TYPE_US_2,
   RTE_TYPE_OR_1,
   RTE_TYPE_OR_2
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/Bike_Ped/admin/views/xodot_point_bkpd_v.vw-arc   3.0   Sep 21 2010 14:28:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_point_bkpd_v.vw  $
--       Date into PVCS   : $Date:   Sep 21 2010 14:28:36  $
--       Date fetched Out : $Modtime:   Sep 21 2010 14:24:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
   ADAR_RAMP_TYP_CD,
          ADAR_XSP,
          ADAR_CROSS_ST_NM,
          ADAR_RAMP_FUNC_COND_CD,
          ADAR_RAMP_PHYS_COND_CD,
          ADAR_RAMP_NEED_IND,
          ADAR_RAMP_INSP_YR,
          ADAR_RAMP_NOTE,
          MBXG_PRIMARY_KEY,
          FIPS_CITY_ID_LEFT,
          CITY_GNIS_ID_LEFT,
          CITY_POP_CNT_LEFT,
          FIPS_CITY_ID_RIGHT,
          CITY_GNIS_ID_RIGHT,
          CITY_POP_CNT_RIGHT,
          URBAN_AREA,
          EA,
          DISTRICT,
          REGION,
          HWY,
          BEGIN_MP,
          END_MP,
          HIGHWAY_NUMBER,
          SUFFIX,
          ROADWAY_ID,
          MILEAGE_TYPE,
          OVERLAP_MILEAGE_CODE,
          ROAD_DIRECTION,
          ROAD_TYPE,
          RTE_TYPE_IS,
          RTE_TYPE_US_1,
          RTE_TYPE_US_2,
          RTE_TYPE_OR_1,
          RTE_TYPE_OR_2
     FROM XODOT_BKPD_POINT_RESULT;