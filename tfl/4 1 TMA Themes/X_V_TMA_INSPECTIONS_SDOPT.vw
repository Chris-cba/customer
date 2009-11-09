CREATE OR REPLACE VIEW X_V_TMA_INSPECTIONS_SDOPT
(ORIGINATORS_REF, UNDERTAKER, DISTRICT, INSPECTOR_NAME, INSECTION_DATE, 
 INSPECTION_TYPE, INSPECTION_CATAGORY, PRIVATE_COMMENT, USRN, STREET_NAME, 
 LOCALITY, TOWN, BOROUGH, LOCATION_TEXT, SITE_COMMENTS, 
 ADDITIONAL_LOCATION_DETAILS, TPHS_ID, GEOMETRY)
AS SELECT
--
  ------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.12.12
--
--   This view displays all the SWR SITES WITH INSPECTIONS WITH UNKNOWN OUTCOME AND CATOGERY A, B or C
--
--   IT WAS REDEFINIED AFTER THE 4.1 UPGRADE TO USE THE NEW TMA THEME 
--   TMA_PHASES_PT_TAB (FEATURE TABLE = TMA_PHASES_POINT_SDO)
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/4 1 TMA Themes/X_V_TMA_INSPECTIONS_SDOPT.vw-arc   3.0   Nov 09 2009 11:39:34   iturnbull  $
--       Module Name      : $Workfile:   X_V_TMA_INSPECTIONS_SDOPT.vw  $
--       Date into PVCS   : $Date:   Nov 09 2009 11:39:34  $
--       Date fetched Out : $Modtime:   Nov 09 2009 11:36:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
        A.WORKS_REF ORIGINATORS_REF, 
        A.TIRE_ORG_NAME_UNDR UNDERTAKER ,
        A.TIRE_DIST_NAME_UNDR DISTRICT, 
        upper(A.TIRE_INSPECTOR_NAME) INSPECTOR_NAME, 
        A.TIRE_DATE INSECTION_DATE,
        A.TIRE_TYPE_MEANING INSPECTION_TYPE, 
        A.TIRE_CATEGORY_MEANING INSPECTION_CATAGORY,
        A.TIRE_COMMENTS PRIVATE_COMMENT,
        A.STR_USRN USRN,
        A.STR_NAME STREET_NAME,
        A.STR_LOCALITY LOCALITY,
        A.STR_TOWN TOWN,
        A.STR_COUNTY BOROUGH,
        A.SITE_LOCATION_TEXT LOCATION_TEXT,
        A.TIRS_SITE_COMMENT_TEXT SITE_COMMENTS,
        A.TIRS_SITE_LOCATION_TEXT ADDITIONAL_LOCATION_DETAILS,
        C.TPPS_TPHS_ID, C.TPPS_TPHS_GEOMETRY
   from v_tma_full_inspection_details A, imf_tma_phases b, TMA_PHASES_POINT_SDO C
  where A.TIRE_OUTCOME_TYPE = 0 
    and a.TIRE_TWOR_WORKS_ID = b.WORKS_ID
    and a.TIRE_PHASE_NO = b.PHASE_NUMBER 
    AND B.PHASE_ID = C.TPPS_TPHS_ID;
    
update nm_themes_all 
   set NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'TMA_PHASES_POINT_SDO')
 where nth_feature_table = 'X_V_TMA_INSPECTIONS_SDOPT';
/
