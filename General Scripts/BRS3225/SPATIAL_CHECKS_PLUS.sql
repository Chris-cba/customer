--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/SPATIAL_CHECKS_PLUS.sql-arc   3.8   Jul 29 2011 08:12:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   SPATIAL_CHECKS_PLUS.SQL  $
--       Date into PVCS   : $Date:   Jul 29 2011 08:12:36  $
--       Date fetched Out : $Modtime:   Jul 28 2011 16:20:40  $
--       PVCS Version     : $Revision:   3.8  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- These scripts are for use by exor consultants only. They should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
col         log_extension new_value log_extension noprint
select  instance_name||'_spatial_checks_plus_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.HTM' log_extension from v$instance
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='&log_extension'
set pages 0
set lines 200
set echo on
SET SERVEROUTPUT ON size 1000000


spool &logfile1


Set markup html on 

set echo on
-- ============================================================
-- check version of SDE
-- if inocrrect please recitfy before running scripts
-- this should be 9.2 or higher
-- ============================================================
--
select release from sde.version; 

SELECT CASE
         WHEN a.release LIKE '92%'
         THEN
           ( SELECT CASE
                      WHEN text LIKE '%|| layer.owner ||%' THEN 'Wrong version of sde.sdo_util'
                      ELSE 'Correct version of sde.sdo_util'
                    END
               FROM dba_source
              WHERE owner = 'SDE'
                AND name = 'SDO_UTIL'
                AND TYPE = 'PACKAGE BODY'
                AND text LIKE '%WHERE owner = %' )
         ELSE
           'Release ' ||a.release ||' is not affected with the SDO_UTIL issue'
       END
         result
  FROM sde.version a;


-- ============================================================
-- themes without a sdo_gtype set
-- if a gtype is not set then locator can be slow to start
-- ============================================================
  select NTH_THEME_ID,NTH_THEME_NAME, NTH_FEATURE_TABLE, NTH_FEATURE_SHAPE_COLUMN, NTG_GTYPE
   from nm_themes_all , NM_THEME_GTYPES
WHERE NTH_THEME_ID = NTG_THEME_ID(+)  
     and ntg_gtype is null;


-- ============================================================
-- spatial tables which appear more than once in nm_themes_all
-- Two (OR MORE) themes should not reference the same spatial table/view,
-- this casue problem in Spatial manager and with this scripts!
-- ============================================================
  select nth_theme_id, nth_theme_name, nth_feature_table 
    from nm_themes_all
   where nth_feature_table in 
                (select nth_feature_table from (select nth_feature_table, count(*) num 
                 from nm_themes_all group by nth_feature_table) where num > 1);


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
       decode (srid, null, 'NULL', to_char(srid)) SRID, DIMINFO
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
-- Entries in user_sdo_geom_metadata that dont relate to an object in the database (delete the entry)
-- ============================================================

select table_name from user_sdo_geom_metadata 
where table_name not in (select object_name from user_objects where object_type in ('VIEW', 'TABLE'))
order by 1;

-- ============================================================
-- Failed spatial indexes
-- ============================================================
select index_name, table_name, STATUS, domidx_status, domidx_opstatus from user_indexes
where ityp_name = 'SPATIAL_INDEX' and domidx_opstatus = 'FAILED';

-- ============================================================
-- Broken Spatial Views
-- ============================================================
SELECT  owner, NAME, TYPE, text 
FROM ALL_ERRORS a, user_sdo_geom_metadata
where type = 'VIEW'
and name = table_name;

-- ============================================================
-- Find any X,Y defect themes
-- ============================================================
select  NTH_THEME_ID,  NTH_THEME_NAME, nth_table_name, NTH_FEATURE_TABLE, NTH_BASE_TABLE_THEME from nm_themes_all 
where nth_feature_table = 'MAI_DEFECTS_XY_SDO'
or NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'MAI_DEFECTS_XY_SDO');


-- ============================================================
-- Find any PEM themes
-- ============================================================
select  NTH_THEME_ID,  NTH_THEME_NAME, nth_table_name, NTH_FEATURE_TABLE, NTH_BASE_TABLE_THEME from nm_themes_all 
where nth_feature_table = 'ENQ_ENQUIRIES_XY_SDO'
or NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'ENQ_ENQUIRIES_XY_SDO');

-- ============================================================
-- Find any DOCS themes
-- ============================================================
select  NTH_THEME_ID,  NTH_THEME_NAME, nth_table_name, NTH_FEATURE_TABLE, NTH_BASE_TABLE_THEME from nm_themes_all 
where nth_feature_table = 'DOC_DOCUMENTS_XY_SDO'
or NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'DOC_DOCUMENTS_XY_SDO');

spool off

SET MARKUP HTML OFF

SET ECHO OFF

