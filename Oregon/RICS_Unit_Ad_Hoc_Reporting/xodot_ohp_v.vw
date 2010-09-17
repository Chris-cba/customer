CREATE OR REPLACE VIEW XODOT_OHP_V (HWY, HIGHWAY_NAME, BEGIN_MP, END_MP, HIGHWAY_NUMBER, SUFFIX, ROADWAY_ID, MILEAGE_TYPE, OVERLAP_MILEAGE_CODE, ROAD_DIRECTION, ROAD_TYPE, RTE_TYPE_IS, RTE_TYPE_US_1, RTE_TYPE_US_2, RTE_TYPE_OR_1, RTE_TYPE_OR_2, NN_PRIMARY_KEY, NHS_NHS_IND, SCS_CLASSFN_NO, OFRG_PRIMARY_KEY, BYPS_PRIMARY_KEY, HSD, SB_EXST_PRPSD_IND, EXPR_PRIMARY_KEY)  
AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/RICS_Unit_Ad_Hoc_Reporting/xodot_ohp_v.vw-arc   3.0   Sep 17 2010 11:58:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_ohp_v.vw  $
--       Date into PVCS   : $Date:   Sep 17 2010 11:58:30  $
--       Date fetched Out : $Modtime:   Sep 17 2010 11:37:12  $
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
,begin_mp
,end_mp
,highway_number
,suffix
,roadway_id
,mileage_type
,overlap_mileage_code
,general_road_direction
,road_type
,rte_type_is
,rte_type_us_1
,rte_type_us_2
,rte_type_or_1
,rte_type_or_2
,NN_PRIMARY_KEY
,nhs_nhs_cd
,SCS_CLASSFN_NO
,OFRG_PRIMARY_KEY
,BYPS_PRIMARY_KEY
,HSD_SEG_DESIG_CD        -- HSD not in table
,SB_EXST_PRPSD_IND
,EXPR_BEG_DESC          -- EXPR_PRIMARY_KEY not in the table
from  XODOT_RWY_REPORT
/