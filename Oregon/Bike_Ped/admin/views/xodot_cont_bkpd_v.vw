CREATE OR REPLACE FORCE VIEW XODOT_CONT_BKPD_V (
   BIKE_TYP_CD_R,
   BIKE_COND_CD_R,
   BIKE_NEED_IND_R,
   BIKE_WD_MEAS_R,
   BIKE_INSP_YR_R,
   BIKE_NOTE_R,
   BIKE_TYP_CD_L,
   BIKE_COND_CD_L,
   BIKE_NEED_IND_L,
   BIKE_WD_MEAS_L,
   BIKE_INSP_YR_L,
   BIKE_NOTE_L,
   CURB_TYP_CD_R,
   CURB_HT_CD_R,
   CURB_COND_CD_R,
   CURB_INSP_YR_R,
   CURB_SRCE_TYP_R,
   CURB_NOTE_R,
   CURB_TYP_CD_CD,
   CURB_HT_CD_CD,
   CURB_COND_CD_CD,
   CURB_INSP_YR_CD,
   CURB_SRCE_TYP_CD,
   CURB_NOTE_CD,
   CURB_TYP_CD_CI,
   CURB_HT_CD_CI,
   CURB_COND_CD_CI,
   CURB_INSP_YR_CI,
   CURB_SRCE_TYP_CI,
   CURB_NOTE_CI,
   CURB_TYP_CD_L,
   CURB_HT_CD_L,
   CURB_COND_CD_L,
   CURB_INSP_YR_L,
   CURB_SRCE_TYP_L,
   CURB_NOTE_L,
   PARK_COND_CD_R,
   PARK_WD_MEAS_R,
   PARK_TYP_CD_R,
   PARK_INSP_YR_R,
   PARK_SRCE_TYP_R,
   PARK_NOTE_R,
   PARK_COND_CD_L,
   PARK_WD_MEAS_L,
   PARK_TYP_CD_L,
   PARK_INSP_YR_L,
   PARK_SRCE_TYP_L,
   PARK_NOTE_L,
   CITY_R_NM,
   CITY_R_FIPS_ID,
   CITY_R_GNIS_ID,
   CITY_R_POP_COUNT,
   CITY_L_NM,
   CITY_L_FIPS_ID,
   CITY_L_GNIS_ID,
   CITY_L_POP_COUNT,
   SHUP_SURF_CD_R,
   SHUP_COND_CD_R,
   SHUP_INSP_YR_R,
   SHUP_WD_MEAS_R,
   SHUP_SURF_CD_L,
   SHUP_COND_CD_L,
   SHUP_INSP_YR_L,
   SHUP_WD_MEAS_L,
   SWLK_SURF_CD_R,
   SWLK_COND_CD_R,
   SWLK_BUF_IND_R,
   SWLK_NEED_IND_R,
   SWLK_INSP_YR_R,
   SWLK_WD_MEAS_R,
   SWLK_SURF_CD_L,
   SWLK_COND_CD_L,
   SWLK_BUF_IND_L,
   SWLK_NEED_IND_L,
   SWLK_INSP_YR_L,
   SWLK_WD_MEAS_L,
   SMALL_URBAN,
   URBAN_AREA,
   SPZN_SPEED_DESIG,
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
   RTE_TYPE_OR_2,
   DISTRICT,
   REGION,
   EA
)AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/Bike_Ped/admin/views/xodot_cont_bkpd_v.vw-arc   3.1   Oct 22 2010 09:34:00   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_cont_bkpd_v.vw  $
--       Date into PVCS   : $Date:   Oct 22 2010 09:34:00  $
--       Date fetched Out : $Modtime:   Oct 20 2010 21:15:34  $
--       PVCS Version     : $Revision:   3.1  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
          "BIKE_R_TYP_CD",
          "BIKE_R_COND_CD",
          "BIKE_R_NEED_IND",
          "BIKE_R_WD_MEAS",
          "BIKE_R_INSP_YR",
          "BIKE_R_NOTE",
          "BIKE_L_TYP_CD",
          "BIKE_L_COND_CD",
          "BIKE_L_NEED_IND",
          "BIKE_L_WD_MEAS",
          "BIKE_L_INSP_YR",
          "BIKE_L_NOTE",
          "CURB_R_TYP_CD",
          "CURB_R_HT_CD",
          "CURB_R_COND_CD",
          "CURB_R_INSP_YR",
          "CURB_R_SRCE_TYP",
          "CURB_R_NOTE",
          "CURB_CD_TYP_CD",
          "CURB_CD_HT_CD",
          "CURB_CD_COND_CD",
          "CURB_CD_INSP_YR",
          "CURB_CD_SRCE_TYP",
          "CURB_CD_NOTE",
          "CURB_CI_TYP_CD",
          "CURB_CI_HT_CD",
          "CURB_CI_COND_CD",
          "CURB_CI_INSP_YR",
          "CURB_CI_SRCE_TYP",
          "CURB_CI_NOTE",
          "CURB_L_TYP_CD",
          "CURB_L_HT_CD",
          "CURB_L_COND_CD",
          "CURB_L_INSP_YR",
          "CURB_L_SRCE_TYP",
          "CURB_L_NOTE",
          "PARK_R_COND_CD",
          "PARK_R_WD_MEAS",
          "PARK_R_TYP_CD",
          "PARK_R_INSP_YR",
          "PARK_R_SRCE_TYP",
          "PARK_R_NOTE",
          "PARK_L_COND_CD",
          "PARK_L_WD_MEAS",
          "PARK_L_TYP_CD",
          "PARK_L_INSP_YR",
          "PARK_L_SRCE_TYP",
          "PARK_L_NOTE",
          "CITY_R_NM",	 
          "CITY_R_FIPS_ID" ,  
          "CITY_R_GNIS_ID",   
          "CITY_R_POP_COUNT", 
          "CITY_L_NM",	 	
          "CITY_L_FIPS_ID",   
          "CITY_L_GNIS_ID",   
          "CITY_L_POP_COUNT", 
          "SHUP_R_SURF_CD",
          "SHUP_R_COND_CD",
          "SHUP_R_INSP_YR",
          "SHUP_R_WD_MEAS",
          "SHUP_L_SURF_CD",
          "SHUP_L_COND_CD",
          "SHUP_L_INSP_YR",
          "SHUP_L_WD_MEAS",
          "SWLK_R_SURF_CD",
          "SWLK_R_COND_CD",
          "SWLK_R_BUF_IND",
          "SWLK_R_NEED_IND",
          "SWLK_R_INSP_YR",
          "SWLK_R_WD_MEAS",
          "SWLK_L_SURF_CD",
          "SWLK_L_COND_CD",
          "SWLK_L_BUF_IND",
          "SWLK_L_NEED_IND",
          "SWLK_L_INSP_YR",
          "SWLK_L_WD_MEAS",
		  "URBN_SMALL_URBAN",
          "URBN_URBAN_AREA",
		  "SPZN_SPEED_DESIG",
          "HWY",
          "BEGIN_MP",
          "END_MP",
          "HIGHWAY_NUMBER",
          "SUFFIX",
          "ROADWAY_ID",
          "MILEAGE_TYPE",
          "OVERLAP_MILEAGE_CODE",
          "ROAD_DIRECTION",
          "ROAD_TYPE",
          "RTE_TYPE_IS",
          "RTE_TYPE_US_1",
          "RTE_TYPE_US_2",
          "RTE_TYPE_OR_1",
          "RTE_TYPE_OR_2",
          "DISTRICT",
          "REGION",
          "SCNS_HWY_EA_NO"
     FROM XODOT_BKPD_MRG_RESULT;