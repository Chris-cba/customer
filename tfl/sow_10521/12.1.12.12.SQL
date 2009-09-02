  ------------------------------------------------------------------------------
  --
  --  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.12.12
  --
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.12.12.SQL-arc   3.0   Sep 02 2009 11:58:12   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.12.12.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:12  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:37:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--   This script create 2 themes to show 
--
--   SWR INSPECTIONS
--   TMA INSPECTIONS
--
------------------------------------------------------------------------------
-- first delete all the redundent SWM geomoetries

DELETE FROM   swr_sites_xy_sdo b
      WHERE   NOT EXISTS (SELECT   1
                            FROM   swr_site_spatial_coords a
                           WHERE   a.sco_gis_id = b.sco_gis_id);

commit;                            
                           
CREATE OR REPLACE VIEW X_V_SWR_INSPECTIONS_SDO AS
select  
  ------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.12.12
--
--   This view displays all the SWR SITES WITH INSPECTIONS WITH UNKNOWN OUTCOME AND CATOGERY A, B or C
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.12.12.SQL-arc   3.0   Sep 02 2009 11:58:12   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.12.12.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:12  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:37:00  $
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
        C.SCO_SIT_ID, C.GEOLOC, C.SCO_GIS_ID
   from v_tma_full_inspection_details A, swr_site_details b, SWR_SITES_XY_SDO C
  where A.TIRE_OUTCOME_TYPE = 0 
    AND A.TIRE_TWOR_WORKS_ID IS NULL
    and A.WORKS_REF = B.WOR_ORIG_REF
    and a.TIRS_SITE_NO = b.SIT_NUM
    AND C.SCO_SIT_ID = B.SIT_ID;

INSERT INTO USER_SDO_GEOM_METADATA 
SELECT 'X_V_SWR_INSPECTIONS_SDO', COLUMN_NAME, DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'SWR_SITES_XY_SDO';

-- create nm themes entries
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, 
   NTH_PK_COLUMN, NTH_LABEL_COLUMN, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
Values
   (nth_theme_id_seq.nextval, 'SWR INSPECTIONS', 'X_V_SWR_INSPECTIONS_SDO', 
   'SCO_GIS_ID', 'SIT_ID', 'X_V_SWR_INSPECTIONS_SDO', 'SCO_GIS_ID', 'GEOLOC', 
   'SWR', 'Y', 'SDO', 'I', 'S', 'N', 
   'N', 'N', 'N', 10, 1, 'N');

declare
   theme_id nm_themes_all.nth_theme_id%type;
begin
    
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_V_SWR_INSPECTIONS_SDO';
       
   Insert into NM_THEME_FUNCTIONS_ALL
      (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
   Values
      (theme_id, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'Y');

  Insert into NM_THEME_FUNCTIONS_ALL
     (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
  Values
     (theme_id, 'SWR1190', 'GIS_SESSION_ID', 'Maintain Works', 'Y');

   Insert into NM_THEME_ROLES
      (NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE)
   Values
      (theme_id, 'HIG_USER', 'NORMAL');

   Insert into NM_THEME_GTYPES
      (NTG_THEME_ID, NTG_GTYPE)
    Values
      (theme_id, 2001);
   COMMIT;
END;

-- USER_SDO_THEMES
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('SWR INSPECTIONS', 'X_V_SWR_INSPECTIONS_SDO', 'GEOLOC', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="SCO_GIS_ID"> ' ||
    '<rule column="TIRE_CATEGORY_MEANING"> <features style="V.TFL.SWR.INSPECTIONS"> </features> ' ||
    '</rule> </styling_rules>');
COMMIT;

-- TMA Insepctions

CREATE OR REPLACE VIEW X_V_TMA_INSPECTIONS_SDOPT AS
select  
  ------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.12.12
--
--   This view displays all the SWR SITES WITH INSPECTIONS WITH UNKNOWN OUTCOME AND CATOGERY A, B or C
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.12.12.SQL-arc   3.0   Sep 02 2009 11:58:12   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.12.12.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:12  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:37:00  $
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
        C.TPHS_ID, C.GEOMETRY
   from v_tma_full_inspection_details A, imf_tma_phases b, X_V_TMA_PHASES_POINTS C
  where A.TIRE_OUTCOME_TYPE = 0 
    and a.TIRE_TWOR_WORKS_ID = b.WORKS_ID
    and a.TIRE_PHASE_NO = b.PHASE_NUMBER 
    AND B.PHASE_ID = C.TPHS_ID;

INSERT INTO USER_SDO_GEOM_METADATA 
SELECT 'X_V_TMA_INSPECTIONS_SDOPT', COLUMN_NAME, DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA
WHERE TABLE_NAME = 'X_V_TMA_PHASES_POINTS';


-- CREATE NM_THEMES ENTRIES ETC.
declare
   theme_id nm_themes_all.nth_theme_id%type;
begin

   nm3sdo.register_sdo_table_as_theme( 'X_V_TMA_INSPECTIONS_SDOPT', 'TPHS_ID', NULL, 'GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'TMA INSPECTIONS',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA PHASES POINTS' ) 
    where nth_feature_table = 'X_V_TMA_INSPECTIONS_SDOPT';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_V_TMA_INSPECTIONS_SDOPT';
    
   
   Insert into NM_THEME_FUNCTIONS_ALL
      (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
   Values
      (theme_id, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'Y');

   Insert into NM_THEME_ROLES
      (NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE)
   Values
      (theme_id, 'HIG_USER', 'NORMAL');


   Insert into NM_THEME_GTYPES
      (NTG_THEME_ID, NTG_GTYPE)
    Values
      (theme_id, 2001);

 commit;
end; 
/

-- create sdo themes TMA INSPECTIONS and SWR INSPECTIONS