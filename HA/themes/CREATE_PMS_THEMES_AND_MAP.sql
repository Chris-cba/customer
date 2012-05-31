-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcs             : $Header:   //vm_latest/archives/customer/HA/themes/CREATE_PMS_THEMES_AND_MAP.sql-arc   1.0   May 31 2012 10:20:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   CREATE_PMS_THEMES_AND_MAP.sql  $
--       Date into PVCS   : $Date:   May 31 2012 10:20:26  $
--       Date fetched Out : $Modtime:   May 29 2012 17:14:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
-----------------------------------------------------------------------------
-- Script to create UKP themes created by Aileen Heal
-- pre-requisits:
-- foreign table asset types HD, KX and VN and tables UKPMS_HD, UKPMS_HS and UKPMS_VN
-- must already exist in the database.
--
-- ******* IMPORTANT ********
-- You must restart MapViewer and logout of the application (closing all browsers) 
-- after running this script to be able to see all the changes.
--
-----------------------------------------------------------------------------

-- first create the LOCL themes  
-- UKPMS HD TAB
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, 
    NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
    NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, 
    NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_SNAP_TO_THEME, 
    NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS,NTH_DYNAMIC_THEME)
SELECT nth_theme_id_seq.nextval,
   'UKPMS HD TAB', 'UKPMS_HD', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'NM_NIT_UKPMS_HD_SDO', 'IIT_NE_ID', 
    'GEOMETRY', 'UKP', 'N', 'LOCL', 'I', 
    'S', 'N', 'N', 'N', 
    'N', 10, 1 , 'N'
FROM DUAL
WHERE NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'NM_NIT_UKPMS_HD_SDO' )
/

-- UKPMS HX TAB
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, 
    NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_END_CHAIN_COLUMN, NTH_FEATURE_TABLE, 
    NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_SNAP_TO_THEME, 
    NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
SELECT nth_theme_id_seq.nextval, 
    'UKPMS HX TAB', 'UKPMS_HX', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'IIT_END_CHAIN', 'NM_NIT_UKPMS_HX_SDO', 
    'IIT_NE_ID', 'GEOMETRY', 'UKP', 'N', 'LOCL', 
    'I', 'S', 'N', 'N', 'N', 
    'N', 10, 1, 'N'
FROM DUAL
WHERE NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'NM_NIT_UKPMS_HX_SDO' )
/    

-- UKPMS VN TAB
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_END_CHAIN_COLUMN, NTH_FEATURE_TABLE, 
    NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_SNAP_TO_THEME, 
    NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
SELECT nth_theme_id_seq.nextval, 
    'UKPMS VN TAB', 'UKPMS_VN', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'IIT_END_CHAIN', 'NM_NIT_UKPMS_VN_SDO', 
    'IIT_NE_ID', 'GEOMETRY', 'UKP', 'N', 'SDO', 
    'I', 'S', 'N', 'N', 'N', 
    'N', 10, 1, 'N'
FROM DUAL
WHERE NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'NM_NIT_UKPMS_VN_SDO' )
/

commit;

-- now create the SDO themes from the LOCL themes
declare
  v_network_theme_id NM_THEMES_ALL.NTH_THEME_ID%TYPE;
  v_srid USER_SDO_GEOM_METADATA.SRID%TYPE;
  v_feature_table NM_THEMES_ALL.NTH_FEATURE_TABLE%TYPE;
--  
begin
 select NTH_THEME_ID into v_network_theme_id
 from NM_THEMES_ALL
 where  NTH_FEATURE_TABLE = 'HA_NETWORK_SDO';
-- 
 select SRID into v_srid
 from USER_SDO_GEOM_METADATA
 where TABLE_NAME = 'HA_NETWORK_SDO';
-- 
 for rec in (select nth_theme_id, nth_feature_table from nm_themes_all 
             where nth_theme_name in ('UKPMS VN TAB', 'UKPMS HX TAB', 'UKPMS HD TAB')
             and not exists (select 1 from user_objects where object_name = nth_feature_table) ) 
 loop
    NM3SDO.CREATE_SDO_LAYER_FROM_LOCL(rec.nth_theme_id, v_network_theme_id, v_srid);
    nm3sdm.create_nth_sdo_trigger(rec.nth_theme_id);
 end loop;           
end;
/    

commit
/

-- now create the data tracked views
@V_NM_NIT_UKPMS_HD_SDO.vw

@V_NM_NIT_UKPMS_HX_SDO.vw

@V_NM_NIT_UKPMS_VN_SDO.vw

-- now create the date tracked themes
--V_NM_NIT_UKPMS_HX_SDO
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_END_CHAIN_COLUMN, NTH_FEATURE_TABLE, 
    NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, 
    NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
select
   nth_theme_id_seq.nextval, 'TRAFFIC SPEED DEFLECTOGRAPH', 'UKPMS_HX', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'IIT_END_CHAIN', 'V_NM_NIT_UKPMS_HX_SDO', 
    'NE_ID', 'GEOMETRY', 'UKP', 'N', 'SDO', 
    'I', 'S', 'N', 'N', NTH_THEME_ID, 
    'N', 'N', 10, 1, 'N'
from NM_THEMES_ALL where NTH_THEME_NAME = 'UKPMS HX TAB'
AND NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'V_NM_NIT_UKPMS_HX_SDO' )
/
  
--V_NM_NIT_UKPMS_VN_SDO
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_END_CHAIN_COLUMN, NTH_FEATURE_TABLE, 
    NTH_FEATURE_PK_COLUMN, NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, 
    NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
select
     nth_theme_id_seq.nextval, 'VISUAL SURVEY - ON CARRIAGEWAY', 'UKPMS_VN', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'IIT_END_CHAIN', 'V_NM_NIT_UKPMS_VN_SDO', 
    'NE_ID', 'GEOMETRY', 'UKP', 'N', 'SDO', 
    'I', 'S', 'N', 'N', NTH_THEME_ID, 
    'N', 'N', 10, 1, 'N'
from NM_THEMES_ALL where NTH_THEME_NAME = 'UKPMS HD TAB'    
AND NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'V_NM_NIT_UKPMS_VN_SDO' )
/
    
V_NM_NIT_UKPMS_HD_SDO
Insert into NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
    NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, NTH_DEPENDENCY, 
    NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, 
    NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
select
     nth_theme_id_seq.nextval, 'DEFLECTOGRAPH (HAPMS)', 'UKPMS_HD', 'IIT_NE_ID', 'IIT_NE_ID', 
    'NM_ELEMENTS', 'IIT_RSE_HE_ID', 'IIT_ST_CHAIN', 'V_NM_NIT_UKPMS_HD_SDO', 'NE_ID', 
    'GEOMETRY', 'UKP', 'N', 'SDO', 'I', 
    'S', 'N', 'N', NTH_THEME_ID,  
    'N', 'N', 10, 1, 'N'
from NM_THEMES_ALL where NTH_THEME_NAME = 'UKPMS HD TAB'
AND NOT EXISTS (select 1 from NM_THEMES_ALL where  NTH_FEATURE_TABLE =  'V_NM_NIT_UKPMS_HD_SDO' )
/
    
-- put entries in nm_theme_functions & nm_theme_roles
begin
   for rec in (select NTH_THEME_ID 
                 from NM_THEMES_ALL 
                where NTH_FEATURE_TABLE in ('V_NM_NIT_UKPMS_VN_SDO'
                                           ,'V_NM_NIT_UKPMS_HD_SDO' 
                                           ,'V_NM_NIT_UKPMS_HX_SDO') )
   loop
      Insert into NM_THEME_FUNCTIONS_ALL(NTF_NTH_THEME_ID
                                        ,NTF_HMO_MODULE
                                        ,NTF_PARAMETER
                                        ,NTF_MENU_OPTION
                                        ,NTF_SEEN_IN_GIS)
      SELECT rec.NTH_THEME_ID, 'NM0573', 'GIS_SESSION_ID', 'ASSET GRID', 'Y'
      FROM DUAL
      WHERE NOT EXISTS (Select 1 from NM_THEME_FUNCTIONS_ALL 
                        where NTF_NTH_THEME_ID = rec.NTH_THEME_ID
                        and NTF_HMO_MODULE = 'NM0573');

      Insert into NM_THEME_FUNCTIONS_ALL(NTF_NTH_THEME_ID
                                        ,NTF_HMO_MODULE
                                        ,NTF_PARAMETER
                                        ,NTF_MENU_OPTION
                                        ,NTF_SEEN_IN_GIS)
      SELECT
      rec.NTH_THEME_ID, 'NM0572', 'GIS_SESSION_ID', 'LOCATOR', 'N'
      FROM DUAL
      WHERE NOT EXISTS (Select 1 from NM_THEME_FUNCTIONS_ALL 
                        where NTF_NTH_THEME_ID = rec.NTH_THEME_ID
                        and NTF_HMO_MODULE = 'NM0572');
      
      Insert into NM_THEME_ROLES (NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE)
      SELECT rec.NTH_THEME_ID, 'HIG_USER', 'NORMAL' 
      from dual
      WHERE NOT EXISTS (Select 1 from NM_THEME_ROLES 
                        where NTHR_THEME_ID = rec.NTH_THEME_ID
                        and NTHR_ROLE = 'HIG_USER');
   end loop;
end;
/   

-- NM_THEME_GTYPES
Insert into NM_THEME_GTYPES
   (NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO)
 select NTH_THEME_ID, 3302, 1
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_VN_SDO'
 AND not exists (select 1 from NM_THEME_GTYPES where NTG_THEME_ID = NTH_THEME_ID ) 
/ 

Insert into NM_THEME_GTYPES
   (NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO)
 select NTH_THEME_ID, 3302, 1
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_HX_SDO'
 AND not exists (select 1 from NM_THEME_GTYPES where NTG_THEME_ID = NTH_THEME_ID ) 
/

Insert into NM_THEME_GTYPES
   (NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO)
 select NTH_THEME_ID, 2001, 1
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_HD_SDO'
 AND not exists (select 1 from NM_THEME_GTYPES where NTG_THEME_ID = NTH_THEME_ID ) 
/

--NM_INV_THEMES
Insert into NM_INV_THEMES
   (NITH_NIT_ID, NITH_NTH_THEME_ID)
 select 'VN', NTH_THEME_ID
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_VN_SDO'
 AND not exists (select 1 from NM_INV_THEMES where NITH_NTH_THEME_ID = NTH_THEME_ID ) 
/

Insert into NM_INV_THEMES
   (NITH_NIT_ID, NITH_NTH_THEME_ID)
 select 'HD', NTH_THEME_ID
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_HD_SDO'
 AND not exists (select 1 from NM_INV_THEMES where NITH_NTH_THEME_ID = NTH_THEME_ID ) 
/

Insert into NM_INV_THEMES
   (NITH_NIT_ID, NITH_NTH_THEME_ID)
 select 'HX', NTH_THEME_ID
 from NM_THEMES_ALL WHERE NTH_FEATURE_TABLE = 'V_NM_NIT_UKPMS_HX_SDO'
 AND not exists (select 1 from NM_INV_THEMES where NITH_NTH_THEME_ID = NTH_THEME_ID ) 
/

-- sdo style for HD
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
select
   'M.X.UKPMS.HD', 'MARKER', 'Style for UKPMS HD assets', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> ' ||
    '<desc></desc> ' ||
    '<g class="marker" style="stroke:#000000;fill:#FF0000;width:10;height:10;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
    '<circle cx="0" cy="0" r="0" /> </g> </svg>'
from dual where not exists (select 1 from USER_SDO_STYLES where name =  'M.X.UKPMS.HD')  
/

-- sdo themes    
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
Select
   'DEFLECTOGRAPH (HAPMS)', 'V_NM_NIT_UKPMS_HD_SDO', 'GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<styling_rules key_column="OBJECTID"> ' ||
   '<rule> <features style="M.X.UKPMS.HD"> </features> </rule> ' ||
   '</styling_rules>'
from dual where not exists (select 1 from USER_SDO_THEMES where name =  'DEFLECTOGRAPH (HAPMS)')  
/
  
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
Select
    'TRAFFIC SPEED DEFLECTOGRAPH', 'V_NM_NIT_UKPMS_HX_SDO', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="OBJECTID"> ' ||
    '<rule> <features style="L.EXOR.ASSET.CD"> </features> </rule> ' || 
    '</styling_rules>'
from dual where not exists (select 1 from USER_SDO_THEMES where name =  'TRAFFIC SPEED DEFLECTOGRAPH')  
/

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES) 
Select
    'VISUAL SURVEY - ON CARRIAGEWAY', 'V_NM_NIT_UKPMS_VN_SDO', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="OBJECTID"> ' || 
    '<rule> <features style="L.EXOR.ASSET.CH"> </features> </rule> ' ||
    '</styling_rules>'
from dual where not exists (select 1 from USER_SDO_THEMES where name =  'VISUAL SURVEY - ON CARRIAGEWAY')  
/
        
-- backup USER_SDO_MAPS TABLE
declare
 v_table_name VARCHAR2(40) := 'USER_SDO_MAPS_'  || to_char(sysdate,'HH24MISS_DDMMYY');
 v_sql VARCHAR2(256);
begin
 v_sql := 'CREATE TABLE ' || v_table_name || ' AS SELECT * FROM USER_SDO_MAPS';
 EXECUTE IMMEDIATE V_SQL;
END;
/  

-- BACK UP MAP definition
Insert into USER_SDO_MAPS
   (NAME, DESCRIPTION, DEFINITION)
SELECT 'HA MAP ' || to_char(sysdate,'HH24:MI:SS DD-MM-YY'), 
       DESCRIPTION, DEFINITION
from USER_SDO_MAPS
WHERE NAME = 'HA MAP'
/

-- DELETE MAP
delete FROM USER_SDO_MAPS WHERE NAME = 'HA MAP'
/
 
--INSERt NEW DEFINITION
Insert into USER_SDO_MAPS
   (NAME, DESCRIPTION, DEFINITION)
 Values
   ('HA MAP', 'HA Map', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<map_definition> ' ||
   '<theme name="HA NETWORK"/> ' ||
   '<theme name="DEFECTS BY STATUS XY" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="ENQUIRIES BY STATUS" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="HATRIS LINKS"/> ' ||
   '<theme name="VISUAL SURVEY - ON CARRIAGEWAY" min_scale="1000.0" max_scale="0.0"/> ' ||
   '<theme name="DEFLECTOGRAPH (HAPMS)" min_scale="1000.0" max_scale="0.0"/> ' ||
   '<theme name="TRAFFIC SPEED DEFLECTOGRAPH" min_scale="1000.0" max_scale="0.0"/> ' ||
   '<theme name="SIGNS" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="COMMUNICATION CABINET" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="DETECTOR LOOP" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="KERB" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="CENTRAL ISLAND" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="FENCES AND BARRIERS" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="HEDGE" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="HATCHED ROAD MARKING" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="LIGHTING POINT" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="PEDESTRIAN GUARD RAIL" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="REFERENCE MARKER POINT" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="ROAD STUDS" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="TRANSVERSE AND SPECIAL RM" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="SAFETY BOLLARD" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="SAFETY FENCE" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="SWITCHROOM" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="EMERGENCY TELEPHONE" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="TREE" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="TRAFFIC SIGNALS" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="WORK ORDER LINES" min_scale="500.0" max_scale="0.0"/> ' ||
   '<theme name="INSPECTIONS" min_scale="500.0" max_scale="0.0" scale_mode="RATIO"/> ' ||
   '</map_definition>')
/

COMMIT
/   
   