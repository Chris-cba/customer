CREATE OR REPLACE FORCE VIEW XODOT_MILE_REPORT_V (HWY,HIGHWAY_NAME,BEGIN_MP,END_MP,HIGHWAY_NUMBER,SUFFIX,ROADWAY_ID,MILEAGE_TYPE,OVERLAP_MILEAGE_CODE,ROAD_DIRECTION,ROAD_TYPE ,SURFACE_TYPE,EA,DISTRICT,REGION,COUNTY,NUMBER_LANES_I,NUMBER_LANES_D,SECTION_LENGTH)  
AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/RICS_Unit_Ad_Hoc_Reporting/xodot_mile_report_v.vw-arc   3.0   Sep 17 2010 11:58:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_mile_report_v.vw  $
--       Date into PVCS   : $Date:   Sep 17 2010 11:58:28  $
--       Date fetched Out : $Modtime:   Sep 17 2010 11:13:40  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : PStanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
hwy 
,highway_name
,begin_mp
,end_mp
,highway_number
,suffix
,roadway_id
,mileage_type
,overlap_mileage_code
,general_road_direction
,road_type
,nvl2((rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1I_MATL_TYP_CD))),(rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1I_MATL_TYP_CD))),(rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1D_MATL_TYP_CD))) )
,scns_hwy_ea_no
,maint_dist_id
,maint_reg_id
,cnty_county_id
,no_lanes_i
,no_lanes_d
,(end_mp-begin_mp) 
from  XODOT_RWY_REPORT
/