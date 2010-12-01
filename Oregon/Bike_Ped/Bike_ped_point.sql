--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/Bike_Ped/Bike_ped_point.sql-arc   3.1   Dec 01 2010 10:08:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   Bike_ped_point.sql  $
--       Date into PVCS   : $Date:   Dec 01 2010 10:08:30  $
--       Date fetched Out : $Modtime:   Dec 01 2010 09:26:42  $
--       PVCS Version     : $Revision:   3.1  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
drop table XODOT_BKPD_POINT_RESULT;

CREATE TABLE XODOT_BKPD_POINT_RESULT
(
adar_primary_key VARCHAR2(50)
,adar_ramp_TYP_CD          VARCHAR2(2)
,adar_xsp	              VARCHAR2 (4)
,adar_cross_st_nm          VARCHAR2 (50)
,adar_ramp_FUNC_COND_CD	  VARCHAR2 (1)	
,adar_RAMP_PHYS_COND_CD	  VARCHAR2 (1)	
,adar_RAMP_NEED_IND	      VARCHAR2 (1)	
,adar_RAMP_INSP_YR		  NUMBER (6)	
,adar_RAMP_NOTE            VARCHAR2 (200)
,adar_MEMBER_UNIQUE		VARCHAR2 (4000)	
,adar_NM_BEGIN_MP		NUMBER	
,adar_NM_END_MP		NUMBER	
,mbxg_primary_key          VARCHAR2(50)
,mbxg_MEMBER_UNIQUE		VARCHAR2 (4000)	
,mbxg_NM_BEGIN_MP		NUMBER	
,mbxg_NM_END_MP		NUMBER		
,fips_city_id_left        VARCHAR2(50)	
,city_gnis_id_left        VARCHAR2(50)
,city_pop_cnt_left        VARCHAR2(50)
,fips_city_id_right       VARCHAR2(50)	
,city_gnis_id_right       VARCHAR2(50)
,city_pop_cnt_right       VARCHAR2(50)
,urban_area               VARCHAR2 (80)
,ea                       VARCHAR2 (120)
,DISTRICT                 VARCHAR2(30)
,region                   VARCHAR2(30)
,HWY		               VARCHAR2 (30)	
,BEGIN_MP		           NUMBER	
,END_MP		               NUMBER	
,HIGHWAY_NUMBER		       VARCHAR2 (4)	
,SUFFIX		               VARCHAR2 (2)	
,ROADWAY_ID		           VARCHAR2 (4)	
,MILEAGE_TYPE		       VARCHAR2 (80)	
,OVERLAP_MILEAGE_CODE      VARCHAR2 (80)	
,ROAD_DIRECTION		       VARCHAR2 (8)		
,ROAD_TYPE                 VARCHAR2(30)
,RTE_TYPE_IS	VARCHAR2 (4)	
,RTE_TYPE_US_1	VARCHAR2 (4)	
,RTE_TYPE_US_2	VARCHAR2 (4)	
,RTE_TYPE_OR_1	VARCHAR2 (4)	
,RTE_TYPE_OR_2	VARCHAR2 (4)
);

CREATE OR REPLACE FORCE VIEW TRANSINFO.XODOT_POINT_BKPD_V
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
   SELECT "ADAR_RAMP_TYP_CD",
          "ADAR_XSP",
          "ADAR_CROSS_ST_NM",
          "ADAR_RAMP_FUNC_COND_CD",
          "ADAR_RAMP_PHYS_COND_CD",
          "ADAR_RAMP_NEED_IND",
          "ADAR_RAMP_INSP_YR",
          "ADAR_RAMP_NOTE",
          "MBXG_PRIMARY_KEY",
          "FIPS_CITY_ID_LEFT",
          "CITY_GNIS_ID_LEFT",
          "CITY_POP_CNT_LEFT",
          "FIPS_CITY_ID_RIGHT",
          "CITY_GNIS_ID_RIGHT",
          "CITY_POP_CNT_RIGHT",
          "URBAN_AREA",
          "EA",
          "DISTRICT",
          "REGION",
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
          "RTE_TYPE_OR_2"
     FROM XODOT_BKPD_POINT_RESULT;