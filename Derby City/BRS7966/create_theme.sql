
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, 
    NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
    NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, 
   NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
 select nth_theme_id_seq.nextval,
   'TMA ALL PHASES (POINT)', 'X_DCC_TMA_WKS_ACTIVE_PHS_DETS', 'TPHS_PHASE_ID', 'TPHS_DESCRIPTION', 
   'X_DCC_TMA_PHASES_PT_SDO', 'TPPS_TPHS_ID', 'TPPS_TPHS_GEOMETRY', 
   'TMA', 'N','SDO', 'I', 'S', 'N', 
   'N', nth_theme_id, 'N','N', 10, 1, 'N' 
   from  NM_THEMES_ALL
   where nth_feature_table = 'TMA_PHASES_POINT_SDO'
/   


Insert into NM_THEME_FUNCTIONS_ALL
   (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
select nth_theme_id, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'N'
from nm_themes_all where nth_feature_table = 'X_DCC_TMA_PHASES_PT_SDO'
/


Insert into NM_THEME_ROLES
   (NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE)
select nth_theme_id,'TMA_USER', 'NORMAL'
from nm_themes_all where nth_feature_table = 'X_DCC_TMA_PHASES_PT_SDO'
/

Insert into NM_THEME_GTYPES
   (NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO, NTG_XML_URL)
select nth_theme_id, 2001, 1, NULL
from nm_themes_all where nth_feature_table = 'X_DCC_TMA_PHASES_PT_SDO'
/


