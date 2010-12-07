--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/permiting_themes/add_to_gis_themes.sql-arc   1.0   Dec 07 2010 08:41:40   Ian.Turnbull  $
--       Module Name      : $Workfile:   add_to_gis_themes.sql  $
--       Date into PVCS   : $Date:   Dec 07 2010 08:41:40  $
--       Date fetched Out : $Modtime:   Dec 07 2010 08:40:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the permiting themes for Northants (NHSWM)
-- as part of BRS 3384 
--
--- **** note this script is called with 3 parameter which are
-- theme name:             name of the theme to be created       e.g. 'TMA PROP IN PROGRESS PERMIT'
-- feature table:            feature table for the theme                e.g. 'X_NHCC_PROPINPROG_NRSWA_SDO'
-- base feature table    feature table for base theme               e.g. 'V_TMA_PHASES_PT_SDO'
-- theme to copy roles etc from                                              e.q. ''V_TMA_PHASES_PT_SDO'       
--
-- the view should already have been created before callin this script...
---------------------------------------------------------------------------------------------------
--
declare 
   l_theme_name                        nm_themes_all.nth_theme_name%TYPE := UPPER('&1');
   l_theme_feature_table            nm_themes_all.nth_feature_table%TYPE := UPPER('&2');
   l_base_theme_feature_table   nm_themes_all.nth_feature_table%TYPE := UPPER('&3');
   l_theme_to_copy_roles_from   nm_themes_all.nth_feature_table%TYPE := UPPER('&4');
   
   l_new_theme_id number;
   l_base_theme_id number;
   l_role_theme_id  number;
 
 begin
   
   select nth_theme_id
      into l_base_theme_id
     from NM_THEMES_ALL
   where NTH_FEATURE_TABLE = l_base_theme_feature_table;

   select nth_theme_id
      into l_role_theme_id
     from NM_THEMES_ALL
   where NTH_FEATURE_TABLE = l_theme_to_copy_roles_from;

  Insert into NORTHANTS.NM_THEMES_ALL
             (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME, NTH_PK_COLUMN, 
               NTH_LABEL_COLUMN, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
               NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, 
               NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, 
               NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, NTH_SNAP_TO_THEME, 
               NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME)
    select 
              nth_theme_id_seq.nextval, l_theme_name, NTH_TABLE_NAME, NTH_PK_COLUMN, 
              NTH_LABEL_COLUMN,l_theme_feature_table, NTH_FEATURE_PK_COLUMN,  
              NTH_FEATURE_SHAPE_COLUMN,NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE,
              NTH_THEME_TYPE, NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT,  
              NTH_USE_HISTORY, NTH_THEME_ID, NTH_SNAP_TO_THEME, 
              NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, NTH_DYNAMIC_THEME
      from nm_themes_all 
    where NTH_THEME_ID = l_base_theme_id;

   select nth_theme_id
      into l_new_theme_id
     from nm_themes_all
  where nth_theme_name = l_theme_name;
   
   insert into nm_theme_functions_all
          select l_new_theme_id, NTF_HMO_MODULE,NTF_PARAMETER,NTF_MENU_OPTION,NTF_SEEN_IN_GIS
            from nm_theme_functions_all
          where NTF_NTH_THEME_ID = l_role_theme_id;
   
   insert into nm_theme_roles
          select l_new_theme_id, NTHR_ROLE, NTHR_MODE
            from nm_theme_roles
          where NTHR_THEME_ID = l_role_theme_id;
   
   insert into nm_theme_gtypes
         select l_new_theme_id, NTG_GTYPE,NTG_SEQ_NO,NTG_XML_URL
          from nm_theme_gtypes
        where NTG_THEME_ID = l_base_theme_id;
        
   insert into nm_inv_themes
         select NITH_NIT_ID,  l_new_theme_id
           from nm_inv_themes
        where NITH_NTH_THEME_ID = l_base_theme_id;
 end;
 /
 
 
   
   