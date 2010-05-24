--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/tma_traffic_themes/TMA_FWD_PLAN.sql-arc   1.1   May 24 2010 09:15:50   iturnbull  $
--       Module Name      : $Workfile:   TMA_FWD_PLAN.sql  $
--       Date into PVCS   : $Date:   May 24 2010 09:15:50  $
--       Date fetched Out : $Modtime:   May 17 2010 11:14:36  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
--   script to create theme TMA FWD PLAN
--   this script expect the view V_X_TMAPHS_FWD_PLAN_SDOPT to have been created
--   it also assumes that the styles v.traffic restrictions (TMA_traffic_restriction.dat) 
--   have been loader via mapBuilder
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA FWD PLAN', 'V_X_TMAPHS_FWD_PLAN_SDOPT', 'GEOM_PT', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TPHS_PHASE_ID"> ' ||
    '<rule column="TPHS_CWAY_RESTRICT_TYPE"> ' ||
    '<features style="V.TRAFFIC RESTRICTIONS"> </features> ' ||
    '</rule> </styling_rules>')
/    

Insert into NM_THEMES_ALL
           (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, 
            NTH_PK_COLUMN, NTH_LABEL_COLUMN, NTH_FEATURE_TABLE, 
            NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
            NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
            NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
     SELECT nth_theme_id_seq.nextval, 'TMA FWD PLAN', 'V_X_TMAPHS_FWD_PLAN_SDOPT', 
            NTH_PK_COLUMN, NTH_LABEL_COLUMN, 'V_X_TMAPHS_FWD_PLAN_SDOPT',
            'TPHS_PHASE_ID', 'GEOM_PT', 
            NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT,
            NTH_USE_HISTORY, NTH_THEME_ID, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME
       FROM NM_THEMES_ALL 
      WHERE NTH_FEATURE_TABLE  = 'TMA_PHASES_POINT_SDO'
/ 


DECLARE
   V_THEME_ID NUMBER;
   V_TMA_PH_THEME_ID NUMBER;
BEGIN
   SELECT NTH_THEME_ID 
     INTO V_THEME_ID
     FROM NM_THEMES_ALL
    WHERE NTH_THEME_NAME = 'TMA FWD PLAN';

   SELECT NTH_THEME_ID 
     INTO V_TMA_PH_THEME_ID
     FROM NM_THEMES_ALL
    WHERE NTH_FEATURE_TABLE = 'V_TMA_PHASES_SDO';
    
INSERT INTO NM_THEME_FUNCTIONS_ALL
     SELECT V_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER,  NTF_MENU_OPTION, NTF_SEEN_IN_GIS 
       FROM NM_THEME_FUNCTIONS_ALL
      WHERE NTF_NTH_THEME_ID = V_TMA_PH_THEME_ID;
     
INSERT INTO NM_THEME_ROLES
     SELECT V_THEME_ID,  NTHR_ROLE, NTHR_MODE 
      FROM  NM_THEME_ROLES
     WHERE NTHR_THEME_ID  = V_TMA_PH_THEME_ID;
    
INSERT INTO NM_THEME_GTYPES (NTG_THEME_ID , NTG_GTYPE , NTG_SEQ_NO )
     VALUES (V_THEME_ID, 2001, 1);
        
INSERT INTO NM_INV_THEMES
     SELECT NITH_NIT_ID, V_THEME_ID 
       FROM NM_INV_THEMES
      WHERE  NITH_NTH_THEME_ID = V_TMA_PH_THEME_ID;  
    
END;
/  