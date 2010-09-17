CREATE OR REPLACE VIEW XODOT_TRAFF_REPORT_V (HWY,HIGHWAY_NAME,BEGIN_MP,END_MP,HIGHWAY_NUMBER,SUFFIX,ROADWAY_ID,MILEAGE_TYPE,OVERLAP_MILEAGE_CODE,ROAD_DIRECTION,ROAD_TYPE,SURFACE_TYPE,EA,DISTRICT,REGION,COUNTY,SECTION_CREW,URBAN_AREA,FFC_FED_FC_CD,TRAF_AADT_CNT,TRAF_AADT_YR,TRAF_DAYS_OPEN_CNT,TRAF_TON_MLGE_FCTR,TRAF_FUTURE_AADT_CNT,STRA_PRIMARY_KEY,OFRG_PRIMARY_KEY,NHS_NHS_IND,NN_PRIMARY_KEY,RTE_TYPE_IS,RTE_TYPE_US_1,RTE_TYPE_US_2,RTE_TYPE_OR_1,RTE_TYPE_OR_2,NO_LANES_I,NO_LANES_D,DIVIDED,SECTION_LENGTH)  
AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/RICS_Unit_Ad_Hoc_Reporting/xodot_traff_report_v.vw-arc   3.0   Sep 17 2010 11:58:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_traff_report_v.vw  $
--       Date into PVCS   : $Date:   Sep 17 2010 11:58:30  $
--       Date fetched Out : $Modtime:   Sep 17 2010 11:12:18  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : PStanton
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
hwy 
,highway_name
,min(begin_mp)
,max(end_mp)
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
,maint_section_crew_id 
,URBN_URBAN_AREA      
,FFC_FC_CD            
,TRAF_AADT_CNT
,TRAF_AADT_YR
,TRAF_DAYS_OPEN_CNT
,TRAF_TON_MLGE_FCTR
,TRAF_FUTURE_AADT_CNT
,decode(nvl(STRA_PRTY_IND,'N'),'N','N','Y')  
,decode(nvl(OFRG_PRIMARY_KEY,'N'),'N','N','Y') 
,decode(nvl(nhs_nhs_cd,'N'),'N','N','Y')      
,decode(nvl(nn_primary_key,'N'),'N','N','Y')   
,rte_type_is
,rte_type_us_1
,rte_type_us_2
,rte_type_or_1
,rte_type_or_2
,no_lanes_i       
,no_lanes_d       
,divided
,(end_mp-begin_mp)
from  XODOT_RWY_REPORT
group by hwy,highway_name,highway_number,suffix
,roadway_id
,mileage_type
,overlap_mileage_code
,general_road_direction
,road_type
,scns_hwy_ea_no
,maint_dist_id
,maint_reg_id
,cnty_county_id
,maint_section_crew_id 
,URBN_URBAN_AREA      
,FFC_FC_CD            
,TRAF_AADT_CNT
,TRAF_AADT_YR
,TRAF_DAYS_OPEN_CNT
,TRAF_TON_MLGE_FCTR
,TRAF_FUTURE_AADT_CNT
,STRA_PRTY_IND
,OFRG_PRIMARY_KEY
,nn_primary_key
,nhs_nhs_cd
,nn_primary_key
,rte_type_is
,rte_type_us_1
,rte_type_us_2
,rte_type_or_1
,rte_type_or_2
,no_lanes_i       
,no_lanes_d       
,divided
,(end_mp-begin_mp) 
,nvl2((rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1I_MATL_TYP_CD))),(rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1I_MATL_TYP_CD))),(rtrim(xodot_HTDR1_GEN.get_simplified_material(RDGM_LN1D_MATL_TYP_CD))) )
/