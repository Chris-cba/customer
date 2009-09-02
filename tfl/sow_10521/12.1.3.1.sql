------------------------------------------------------------------------------
--  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.1 by Aileen Heal
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.1.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.1.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--   This script create 2 themes showing notices by noticing authority.
--   there is a point theme (WORKS BY AUTHORITY - POINT)
--   there is a polyline themes (WORKS BY AUTHORITY - SHAPE)
--
--   These themes displays all the notices where 
--      Notice_type is one pf forward planning , initial notice  orinital notice for permitted streets)
--      The  receipient_type is 1 Primary
--      phase status is one of  'ABOUT_TO_START', 'ADV_PLAN', 'FWD_PLAN', 'WIP' 
--
--   the themes are be colour coded by noticing Authority (c.ORGANISATION_REFERENCE) 
--   If = '0020' themn TfL else not.
--
-- N.B. REQUIRE the following STYLES
--   L.TFL.WORKS_BY_AUTHORITY_NOT_TFL
--   L.TFL.WORKS_BY_AUTHORITY_TFL
--   M.TFL.WORKS_BY_AUTHORITY_NOT_TFL
--   M.TFL.WORKS_BY_AUTHORITY_TFL
--   V.TFL.WORKS_BY_AUTHORITY (POINT)
--   V.TFL.WORKS_BY_AUTHORITY (SHAPE)
--
-----------------------------------------------------------------------------
--
CREATE OR REPLACE VIEW X_WORKS_BY_NOTICING_AUTH AS
select 
------------------------------------------------------------------------------
--
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.1 by Aileen Heal
--
--   This view displays all the notices where 
--      Notice_type is one of forward planning , initial notice  orinital notice for permitted streets)
--      The  receipient_type is 1 Primary
--      phase status is one of  'ABOUT_TO_START', 'ADV_PLAN', 'FWD_PLAN', 'WIP' 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.1.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.1.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
       a.*, C.ORGANISATION_REFERENCE
  from imf_tma_phases  a, imf_tma_notices b, imf_tma_notice_recipients c
 where ACTIVE_FLAG = 'Y' 
   and PHASE_STATUS in ('ABOUT_TO_START', 'ADV_PLAN', 'FWD_PLAN', 'WIP' )
   and a.WORKS_ID = b.WORKS_ID
   and a.PHASE_NUMBER = b.PHASE_NUMBER
   and b.NOTICE_ID = c.NOTICE_ID
   and c.RECIPIENT_TYPE = 1  -- added by Aileen
   and b.NOTICE_TYPE in ('0200', '0210', '0100') -- 100 forward planning , 200 initial notice ,210 inital notice for permitted streets;

CREATE OR REPLACE VIEW X_WORKS_BY_NOTICING_AUTH_SDO AS
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF soW 10521 REQUIREMENT REF: 12.1.3.1 by Aileen Heal
--
--   This view create the shape (polyline) spatial view for the non-spatial view
--   X_WORKS_BY_NOTICING_AUTH
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.1.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.1.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
     a.*, b.tphs_geometry, b.TPHS_ID
from X_WORKS_BY_NOTICING_AUTH a, tma_phases_sdo b
    WHERE a.phase_id = b.tphs_id;
    

insert into user_sdo_geom_metadata
   select 'X_WORKS_BY_NOTICING_AUTH_SDO', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'TMA_PHASES_SDO' and column_name = 'TPHS_GEOMETRY' and rownum = 1
/    


    
CREATE OR REPLACE VIEW X_WORKS_BY_NOTICING_AUTH_SDOPT AS
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF soW 10521 REQUIREMENT REF: 12.1.3.1 by Aileen Heal
--
--   This view create the shape (point) spatial view for the non-spatial view
--   X_WORKS_BY_NOTICING_AUTH
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.1.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.1.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
     a.*, b.geometry, b.TPHS_ID
from X_WORKS_BY_NOTICING_AUTH a, x_v_tma_phases_points b
    WHERE a.phase_id = b.tphs_id;    

insert into user_sdo_geom_metadata
       select 'X_WORKS_BY_NOTICING_AUTH_SDOPT', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'X_V_TMA_PHASES_POINTS' and column_name = 'GEOMETRY' and rownum = 1
/    
    
-- CREATE SDO THEMES ENTRIES
-- N.B. REQUIRE the following STYLES
--   L.TFL.WORKS_BY_AUTHORITY_NOT_TFL
--   L.TFL.WORKS_BY_AUTHORITY_TFL
--   M.TFL.WORKS_BY_AUTHORITY_NOT_TFL
--   M.TFL.WORKS_BY_AUTHORITY_TFL
--   V.TFL.WORKS_BY_AUTHORITY (POINT)
--   V.TFL.WORKS_BY_AUTHORITY (SHAPE)

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY AUTHORITY - POINT', 'X_WORKS_BY_NOTICING_AUTH_SDOPT', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID"> ' ||
    '<rule column="ORGANISATION_REFERENCE"> ' ||
    '<features style="V.TFL.WORKS_BY_AUTHORITY (POINT)"> </features> ' ||
    '</rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY AUTHORITY - SHAPE', 'X_WORKS_BY_NOTICING_AUTH_SDO', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID"> ' ||
    '<rule column="ORGANISATION_REFERENCE"> ' ||
    '<features style="V.TFL.WORKS_BY_AUTHORITY (SHAPE)"> </features> ' ||
    '</rule> </styling_rules>');

--select * from  nm_themes_all where nth_feature_table like 'X_WORKS_BY_NOTICING_AUTH_%';

--delete from nm_themes_all where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDO';

--delete from nm_themes_all where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDOPT'--;

-- CREATE NM_THEMES ENTRIES ETC.
declare
   theme_id nm_themes_all.nth_theme_id%type;
begin
   nm3sdo.register_sdo_table_as_theme( 'X_WORKS_BY_NOTICING_AUTH_SDO', 'TPHS_ID', NULL, 'TPHS_GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'WORKS BY AUTHORITY - SHAPE',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA_PHASES_TAB' ) 
    where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDO';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDO';
    
   
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

   nm3sdo.register_sdo_table_as_theme( 'X_WORKS_BY_NOTICING_AUTH_SDOPT', 'TPHS_ID', NULL, 'GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'WORKS BY AUTHORITY - POINT',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA PHASES POINTS' ) 
    where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDOPT';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_WORKS_BY_NOTICING_AUTH_SDOPT';
    
   
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
    