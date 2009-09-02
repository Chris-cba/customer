------------------------------------------------------------------------------
--  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.11.3 by Aileen Heal
--
------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.11.3.SQL-arc   3.0   Sep 02 2009 11:58:10   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.11.3.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:10  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:36:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--   This script create themes to show WORKS WITH A PROMOTER REFERENCE OF 'YG104'.
--
--
-- THEME REQUIRES THE FOLLOWING STYLES
--
-- M.TFL.S50
-- L.TFL.S50
--
------------------------------------------------------------------------------

Create or replace View X_S50_LICENCES_SD0 AS 
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.10.2
--
--   This view displays all the WORKS WHICH HAVE A PROMOTER REFERENCE OF 'YG104'
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.11.3.SQL-arc   3.0   Sep 02 2009 11:58:10   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.11.3.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:10  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:36:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
     a.*, C.TPHS_GEOMETRY, c.TPHS_ID
from imf_tma_phases  a, imf_tma_works b, TMA_PHASES_SDO C
where ACTIVE_FLAG = 'Y'
and a.WORKS_ID = b.WORKS_ID
and b.WORKS_REFERENCE like 'YG104%'
and c.TPHS_ID = a.PHASE_ID;

insert into user_sdo_geom_metadata
   select 'X_S50_LICENCES_SD0', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'TMA_PHASES_SDO' and column_name = 'TPHS_GEOMETRY' and rownum = 1;


Create or replace View X_S50_LICENCES_SD0PT AS 
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.10.2 by Ailee Heal
--
--   This view displays all the WORKS WHICH HAVE A PROMOTER REFERENCE OF 'YG104'
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.11.3.SQL-arc   3.0   Sep 02 2009 11:58:10   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.11.3.SQL  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:10  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:36:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
     a.*, C.GEOMETRY, c.TPHS_ID
from imf_tma_phases  a, imf_tma_works b, X_V_TMA_PHASES_POINTS C
where ACTIVE_FLAG = 'Y'
and a.WORKS_ID = b.WORKS_ID
and b.WORKS_REFERENCE like 'YG104%'
and C.TPHS_ID = a.PHASE_ID;

insert into user_sdo_geom_metadata
       select 'X_S50_LICENCES_SD0PT', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'X_V_TMA_PHASES_POINTS' and column_name = 'GEOMETRY' and rownum = 1;
   
-- SDO THEMES
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('SECTION 50 LICENCES - POINT', 'X_S50_LICENCES_SD0PT', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID"> ' ||
    '<rule> <features style="M.TFL.S50"> </features> </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('SECTION 50 LICENCES - SHAPE', 'X_S50_LICENCES_SD0', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID"> ' ||
    '<rule> <features style="L.TFL.S50"> </features> </rule> </styling_rules>');

 -- CREATE NM_THEMES ENTRIES ETC.
declare
   theme_id nm_themes_all.nth_theme_id%type;
begin
   nm3sdo.register_sdo_table_as_theme( 'X_S50_LICENCES_SD0', 'TPHS_ID', NULL, 'TPHS_GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'SECTION 50 LICENCES - SHAPE',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA_PHASES_TAB' ) 
    where nth_feature_table = 'X_S50_LICENCES_SD0';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_S50_LICENCES_SD0';
    
   
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

   nm3sdo.register_sdo_table_as_theme( 'X_S50_LICENCES_SD0PT', 'TPHS_ID', NULL, 'GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'SECTION 50 LICENCES - POINT',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA PHASES POINTS' ) 
    where nth_feature_table = 'X_S50_LICENCES_SD0PT';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_S50_LICENCES_SD0PT';
    
   
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

