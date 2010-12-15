--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/SPATIAL_CHECKS_PLUS.sql-arc   3.3   Dec 15 2010 12:19:58   Ian.Turnbull  $
--       Module Name      : $Workfile:   SPATIAL_CHECKS_PLUS.sql  $
--       Date into PVCS   : $Date:   Dec 15 2010 12:19:58  $
--       Date fetched Out : $Modtime:   Dec 15 2010 11:19:50  $
--       PVCS Version     : $Revision:   3.3  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.HTM' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='spatial_checks_plus_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000


spool &logfile1

Set markup html on 

set echo on
-- ============================================================
-- themes without a sdo_gtype set
-- if a gtype is not set then locator can be slow to start
-- ============================================================
  select NTH_THEME_ID,NTH_THEME_NAME, NTH_FEATURE_TABLE, NTH_FEATURE_SHAPE_COLUMN, NTG_GTYPE
   from nm_themes_all , NM_THEME_GTYPES
WHERE NTH_THEME_ID = NTG_THEME_ID(+)  
     and ntg_gtype is null;


-- ============================================================
-- Find all orphaned views
-- Identfy views in nm_themes that are ot referencing their base theme tables
-- ============================================================  
   select nth_theme_id, nth_theme_name, nth_feature_table
     from nm_themes_all, user_views
    where nth_base_table_theme is null
      and nth_feature_table = view_name;

-- ============================================================
-- Themes missing from USER_SDO_GEOM_METADATA
-- i.e. there is no record for theme in user_sdo_geom_metadata
-- this will prevent indexes and spatial functions for working or being created
-- ============================================================
SELECT NTH_THEME_ID,NTH_THEME_NAME, NTH_FEATURE_TABLE 
   FROM nm_themes_all 
 WHERE NTH_FEATURE_TABLE||NTH_FEATURE_SHAPE_COLUMN 
       NOT IN (SELECT TABLE_NAME||COLUMN_NAME FROM USER_SDO_GEOM_METADATA);

-- ============================================================
-- Themes which are materalised views and don't have a SRID
-- set_all_null_srids skips materalised views so thes have to have their SRIDS 
-- a different way (dependent upon how the geometry is constructed.
-- ============================================================
Select nth_feature_table, nth_feature_shape_column, object_type
  from nm_themes_all, user_objects, user_sdo_geom_metadata
where nth_feature_table = object_name 
    and nth_feature_shape_column = column_name
    and nth_feature_table = table_name
    and object_type =  'MATERIALIZED VIEW'
    and srid is null;    

-- ============================================================
-- report of themes and their SRIDS
-- ============================================================
   SELECT NTH_THEME_ID,NTH_THEME_NAME, NTH_FEATURE_TABLE, 
               NTH_FEATURE_SHAPE_COLUMN, table_name USGM_TABLE_NAME, 
               decode (srid, null, 'NULL', to_char(srid)) SRID
      FROM NM_THEMES_ALL, USER_SDO_GEOM_METADATA
    WHERE NTH_FEATURE_TABLE = TABLE_NAME(+)
         and NTH_FEATURE_SHAPE_COLUMN = COLUMN_NAME(+)
ORDER BY NTH_THEME_ID;

-- ============================================================
-- spatial tables/views with a null srid (may not be in nm_theme_all)
-- ============================================================
    select table_name, column_name 
      from user_sdo_geom_metadata 
     where srid is null
     order by table_name, column_name;

-- ============================================================
-- spatial tables/views with a feature table that doesnt exist (drop the theme, or correct the metadata to an object that does exist)
-- ============================================================

select  nth_theme_id, nth_theme_name, nth_feature_table  from nm_themes_all
where not  nth_feature_table in    (select table_name from user_tables union select view_name from user_views);

-- ============================================================
-- Entries in USer_sdo_geom_metadata that dont relate to an object in the database (delete the entry)
-- ============================================================


select table_name from user_sdo_geom_metadata 
where table_name not in (select object_name from user_objects where object_type in ('VIEW', 'TABLE'))
order by 1;


spool off

SET MARKUP HTML OFF

SET ECHO OFF

