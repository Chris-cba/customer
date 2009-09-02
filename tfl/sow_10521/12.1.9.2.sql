  ------------------------------------------------------------------------------
  --
  --  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.9.2 by Aileen Heal
  --
  --   This script create a theme to show TMA restrictions where the restriction status
  --   is IN FORCE or PROPOSED. The theme is colour coded by status i.e. Proposed or In FORCE
  --
  --   N.B. REQUIRE the following STYLES
  --   L.TFL.RESTRICTIONS.PROPOSED
  --   L.TFL.RESTRICTIONS.IN FORCE
  --   M.TFL.RESTRICTIONS.PROPOSED
  --   M.TFL.RESTRICTIONS.IN FORCE
  --   V.TFL.RESTRICTIONS - SHAPE
  --   V.TFL.RESTRICTIONS - POINT
  --
  -----------------------------------------------------------------------------
  --
  --   PVCS Identifiers :-
  --
  --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.9.2.sql-arc   3.0   Sep 02 2009 11:58:16   Ian Turnbull  $
  --       Module Name      : $Workfile:   12.1.9.2.sql  $
  --       Date into PVCS   : $Date:   Sep 02 2009 11:58:16  $
  --       Date fetched Out : $Modtime:   Sep 02 2009 11:35:00  $
  --       PVCS Version     : $Revision:   3.0  $
  --
  --
  --   Author : Aileen Heal
  --
  -----------------------------------------------------------------------------
  --	Copyright (c) exor corporation ltd, 2004
  -----------------------------------------------------------------------------
  --

create or replace view X_RESTRICT_PROPORINFORCE_SDO as
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.9.2 by Aileen Heal
--
--   This view displays all the TMA restrictions where the restriction status
--   is IN FORCE or PROPOSED
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.9.2.sql-arc   3.0   Sep 02 2009 11:58:16   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.9.2.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:16  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:35:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
  a.*, b.TRES_GEOMETRY, b.TRES_RESTRICTION_ID 
  from imf_tma_restricted_streets a, tma_restrictions_sdo b
 where restriction_status in ('IN_FORCE', 'PROPOSED')
  and a.RESTRICTION_ID = b.TRES_RESTRICTION_ID;
  
insert into user_sdo_geom_metadata
   select 'X_RESTRICT_PROPORINFORCE_SDO', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'TMA_RESTRICTIONS_SDO' and column_name = 'TRES_GEOMETRY' and rownum = 1;
    
create or replace view X_RESTRICT_PROPORINFORCE_SDOPT as
select a.*, b.GEOMETRY, b.TRES_RESTRICTION_ID 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.9.2 by Aileen Heal
--
--   This view displays all the TMA restrictions where the restriction status
--   is IN FORCE or PROPOSED
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.9.2.sql-arc   3.0   Sep 02 2009 11:58:16   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.9.2.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:16  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:35:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
       a.*, b.GEOMETRY, b.TRES_RESTRICTION_ID 
  from imf_tma_restricted_streets a, X_V_TMA_RESTRICTIONS_POINTS b
 where restriction_status in ('IN_FORCE', 'PROPOSED')
  and a.RESTRICTION_ID = b.TRES_RESTRICTION_ID;
  
insert into user_sdo_geom_metadata
   select 'X_RESTRICT_PROPORINFORCE_SDOPT', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'X_V_TMA_RESTRICTIONS_POINTS' and column_name = 'GEOMETRY' and rownum = 1;

-- CREATE NM_THEMES ENTRIES ETC.
declare
   theme_id nm_themes_all.nth_theme_id%type;
begin
   nm3sdo.register_sdo_table_as_theme( 'X_RESTRICT_PROPORINFORCE_SDO', 'TRES_RESTRICTION_ID', NULL, 'TRES_GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'S58 AND S58A NOTICES - SHAPE',
          nth_label_column ='TRES_RESTRICTION_STATUS',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA_RESTRICTIONS_TAB' )           
    where nth_feature_table = 'X_RESTRICT_PROPORINFORCE_SDO';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_RESTRICT_PROPORINFORCE_SDO';
    
   
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
      (theme_id, 2002);


   nm3sdo.register_sdo_table_as_theme( 'X_RESTRICT_PROPORINFORCE_SDOPT', 'TRES_RESTRICTION_ID', NULL, 'TRES_GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'S58 AND S58A NOTICES - POINT',
          nth_label_column ='TRES_RESTRICTION_STATUS',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA_RESTRICTIONS_TAB' )           
    where nth_feature_table = 'X_RESTRICT_PROPORINFORCE_SDOPT';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_RESTRICT_PROPORINFORCE_SDOPT';
    
   
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
   
-- CREATE USER SDO THEMES
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('S58 AND S58A NOTICES - SHAPE', 'X_RESTRICT_PROPORINFORCE_SDO', 'TRES_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TRES_RESTRICTION_ID"> ' ||
    '<rule column="RESTRICTION_STATUS"> <features style="V.TFL.RESTRICTIONS - SHAPE"> </features> ' ||
    '</rule> </styling_rules>');


Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('S58 AND S58A NOTICES - POINT', 'X_RESTRICT_PROPORINFORCE_SDOPT', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TRES_RESTRICTION_ID"> ' ||
    '<rule column="RESTRICTION_STATUS"> <features style="V.TFL.RESTRICTIONS - POINT"> </features> ' ||
    '</rule> </styling_rules>');

COMMIT;
/
  
  