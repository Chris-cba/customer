-- *************************************************************************************************************
--
--  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 by Aileen Heal
--  
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/TFL_TMA_POINT_THEMES.sql-arc   3.0   Sep 02 2009 11:58:20   Ian Turnbull  $
--       Module Name      : $Workfile:   TFL_TMA_POINT_THEMES.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:20  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:28:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
-- this script create the functional indexes and themes for the TMA point themes required by TfL
---

-- put entry in user_sdo_geom_Metadata for function based index
INSERT INTO USER_SDO_GEOM_METADATA
   ( select TABLE_NAME, USER ||'.X_TFL_GET_TMA_MID_POINT(TPHS_GEOMETRY)', diminfo, srid
       from user_sdo_geom_metadata 
      where table_name = 'TMA_PHASES_SDO' AND ROWNUM = 1
    );

commit;

-- create function based index
create index X_TFL_TMA_PHASES_FINX 
    on TMA_PHASES_SDO(X_TFL_GET_TMA_MID_POINT(TPHS_GEOMETRY))
    indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');

-- TMA PHASES POINT Theme
CREATE OR REPLACE VIEW X_V_TMA_PHASES_POINTS AS 
    SELECT 
--
-- This view was crated by Exor for TfL as part of SoW 10521 by Aileen Heal
-- to create point geomeotry for TMA phases
-- it requires index X_TFL_TMA_PHASES_FINX 
-- create index X_TFL_TMA_PHASES_FINX 
--    on TMA_PHASES_SDO(X_TFL_GET_TMA_MID_POINT(TPHS_GEOMETRY))
--    indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/TFL_TMA_POINT_THEMES.sql-arc   3.0   Sep 02 2009 11:58:20   Ian Turnbull  $
--       Module Name      : $Workfile:   TFL_TMA_POINT_THEMES.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:20  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:28:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
         TPHS_ID, X_TFL_GET_TMA_MID_POINT(TPHS_GEOMETRY) GEOMETRY
    FROM tma_phases_sdo;     

-- put entry in user_sdo_geom_metadata for themes
INSERT INTO USER_SDO_GEOM_METADATA
   ( select 'X_V_TMA_PHASES_POINTS', 'GEOMETRY', diminfo, srid
       from user_sdo_geom_metadata 
      where table_name = 'TMA_PHASES_SDO' AND ROWNUM = 1
   );

commit;

INSERT INTO NM_THEMES_ALL (
   NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME)
select 
   NTH_THEME_ID_seq.nextval, 'TMA PHASES POINTS', NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, 'X_V_TMA_PHASES_POINTS', NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, 'GEOMETRY', 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME
 from nm_themes_all
where nth_feature_table = 'TMA_PHASES_SDO'
  and nth_feature_shape_column = 'TPHS_GEOMETRY';


Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA PHASES POINTS', 'X_V_TMA_PHASES_POINTS', 'GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?>' ||
    '<styling_rules> ' ||
       '<rule> ' ||
         '<features style="M.CIRCLE"> </features> ' ||
       '</rule> ' ||
    '</styling_rules>');

---
---    TMA RESTRICTIONS 
---

-- put entry in user_sdo_geom_Metadata for function based index
INSERT INTO USER_SDO_GEOM_METADATA
   ( select TABLE_NAME,USER ||'.X_TFL_GET_TMA_MID_POINT(TRES_GEOMETRY)', diminfo, srid
       from user_sdo_geom_metadata 
      where table_name = 'TMA_RESTRICTIONS_SDO' AND ROWNUM = 1
   );

commit;

-- create function based index
create index X_TFL_TMA_RESTRICTIONS_FINX 
    on TMA_RESTRICTIONS_SDO(X_TFL_GET_TMA_MID_POINT(TRES_GEOMETRY))
    indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');

-- TMA RESTRICTIONS POINT Theme
CREATE OR REPLACE VIEW X_V_TMA_RESTRICTIONS_POINTS AS 
     SELECT 
--
-- This view was crated by Exor for TfL as part of SoW 10521 
-- to create point geomeotry for TMA phases
-- it requires index X_TFL_TMA_RESTRICTIONS_FINX 
-- create index X_TFL_TMA_RESTRICTIONS_FINX 
--    on TMA_RESTRICTIONS_SDO(X_TFL_GET_TMA_MID_POINT(TRES_GEOMETRY))
--    indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/TFL_TMA_POINT_THEMES.sql-arc   3.0   Sep 02 2009 11:58:20   Ian Turnbull  $
--       Module Name      : $Workfile:   TFL_TMA_POINT_THEMES.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:20  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:28:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
            TRES_RESTRICTION_ID, X_TFL_GET_TMA_MID_POINT(TRES_GEOMETRY) GEOMETRY
       FROM tma_RESTRICTIONS_sdo;     

-- put entry in user_sdo_geom_metadata for themes
INSERT INTO USER_SDO_GEOM_METADATA
   ( select 'X_V_TMA_RESTRICTIONS_POINTS', 'GEOMETRY', diminfo, srid
       from user_sdo_geom_metadata
      where table_name = 'TMA_PHASES_SDO' AND ROWNUM = 1
   );

commit;

INSERT INTO NM_THEMES_ALL (
   NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME)
select 
   NTH_THEME_ID_seq.nextval, 'TMA RESTRICTION POINTS', NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, 'X_V_TMA_RESTRICTIONS_POINTS', NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, 'GEOMETRY', 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME
 from nm_themes_all
where nth_feature_table = 'TMA_RESTRICTIONS_SDO'
  and nth_feature_shape_column = 'TRES_GEOMETRY';


Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA RESTRICTION POINTS', 'X_V_TMA_RESTRICTIONS_POINTS', 'GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?>' ||
    '<styling_rules> ' ||
       '<rule> ' ||
         '<features style="M.CIRCLE"> </features> ' ||
       '</rule> ' ||
    '</styling_rules>');

---
--- TMA SITES
---

-- put entry in user_sdo_geom_Metadata for function based index
INSERT INTO USER_SDO_GEOM_METADATA
   ( select TABLE_NAME,USER ||'.X_TFL_GET_TMA_MID_POINT(TSIT_GEOMETRY)', diminfo, srid
       from user_sdo_geom_metadata
      where table_name = 'TMA_SITES_SDO' AND ROWNUM = 1
    );
    
commit;

-- create function based index
create index X_TFL_TMA_SITES_FINX 
   on TMA_SITES_SDO(X_TFL_GET_TMA_MID_POINT(TSIT_GEOMETRY))
   indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');

-- TMA SITES POINT Theme
CREATE OR REPLACE VIEW X_V_TMA_SITES_POINTS AS 
     SELECT 
    ---
    -- This view was crated by Exor for TfL as part of SoW 10521 
    -- to create point geomeotry for TMA phases
    -- it requires index X_TFL_TMA_SITES_FINX 
    -- create index X_TFL_TMA_SITES_FINX 
    --    on TMA_SITES_SDO(X_TFL_GET_TMA_MID_POINT(TSIT_GEOMETRY))
    --    indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');
    --
    --   $RCSfile: TFL_TMA_POINT_THEMES.sql,v $ 
    --   $Author:   Ian Turnbull  $
    --   $Date:   Sep 02 2009 11:58:20  $
    --   $Revision:   3.0  $
    ---
            TSIT_ID, X_TFL_GET_TMA_MID_POINT(TSIT_GEOMETRY) GEOMETRY
       FROM tma_sites_sdo;     

-- put entry in user_sdo_geom_metadata for themes
INSERT INTO USER_SDO_GEOM_METADATA
   ( select 'X_V_TMA_SITES_POINTS', 'GEOMETRY', diminfo, srid
       from user_sdo_geom_metadata where table_name = 'TMA_SITES_SDO' 
        AND ROWNUM = 1
    );

commit;

INSERT INTO NM_THEMES_ALL (
   NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, NTH_FEATURE_SHAPE_COLUMN, 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME)
select 
   NTH_THEME_ID_seq.nextval, 'TMA SITES POINTS', NTH_TABLE_NAME, 
   NTH_WHERE, NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
   NTH_RSE_TABLE_NAME, NTH_RSE_FK_COLUMN, NTH_ST_CHAIN_COLUMN, 
   NTH_END_CHAIN_COLUMN, NTH_X_COLUMN, NTH_Y_COLUMN, 
   NTH_OFFSET_FIELD, 'X_V_TMA_SITES_POINTS', NTH_FEATURE_PK_COLUMN, 
   NTH_FEATURE_FK_COLUMN, NTH_XSP_COLUMN, 'GEOMETRY', 
   NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
   NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
   NTH_USE_HISTORY, NTH_START_DATE_COLUMN, NTH_END_DATE_COLUMN, 
   NTH_BASE_TABLE_THEME, NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, 
   NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
   NTH_DYNAMIC_THEME
 from nm_themes_all
where nth_feature_table = 'TMA_SITES_SDO'
  and nth_feature_shape_column = 'TSIT_GEOMETRY';


Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA SITES POINTS', 'X_V_TMA_SITES_POINTS', 'GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?>' ||
    '<styling_rules> ' ||
       '<rule> ' ||
         '<features style="M.CIRCLE"> </features> ' ||
       '</rule> ' ||
    '</styling_rules>');

commit;


