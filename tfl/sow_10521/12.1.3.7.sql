-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.7.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.7.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
------------------------------------------------------------------------------
--  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.7 by Aileen Heal
--
--   This script create 2 themes showing works by cordinator.
--   there is a point theme (WORKS BY  CORDINATOR - POINT)
--   there is a polyline themes (WORKS BY CORDINATOR - SHAPE)
--
--   These themes displays all the notices where 
--      Notice_type is one of forward planning , initial notice  orinital notice for permitted streets)
--
------------------------------------------------------------------------------

CREATE OR REPLACE VIEW X_WORKS_BY_STREET_GROUP 
AS
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.7 by Aileen Heal
--
--   This view displays all the notices where 
--      Notice_type is one pf forward planning , initial notice  orinital notice for permitted streets)
--      The  receipient_type is 1 Primary
--      phase status is one of  'ABOUT_TO_START', 'ADV_PLAN', 'FWD_PLAN', 'WIP' 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.7.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.7.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
       a.*, e.TSG_NAME
  from imf_tma_phases  a, imf_tma_notices b, imf_tma_notice_recipients c, tma_street_group_members d, tma_street_groups e
 where ACTIVE_FLAG = 'Y' 
   and PHASE_STATUS in ('ABOUT_TO_START', 'ADV_PLAN', 'FWD_PLAN', 'WIP' )
   and a.WORKS_ID = b.WORKS_ID
   and a.PHASE_NUMBER = b.PHASE_NUMBER
   and b.NOTICE_ID = c.NOTICE_ID
   and c.RECIPIENT_TYPE = 1 -- primary
   and b.NOTICE_TYPE in ('0200', '0210', '0100') -- 100 (forward planning ), 200 (initial notice) 210 (inital notice for permitted streets)
   and b.STREET_ID = d.TSGM_STR_NE_ID
   and d.TSGM_TSG_ID = e.TSG_ID
   and e.TSG_NAME in ('CROYDON - TLRN','MERTON - TLRN', 'SUTTON - TLRN', 
                      'KINGSTON UPON THAMES - TLRN', 'RICHMOND UPON THAMES - TLRN',
                      'BEXLEY - TLRN', 'BROMLEY - TLRN', 'GREENWICH - TLRN',
                      'LAMBETH - TLRN',
                      'WANDSWORTH - TLRN',
                      'SOUTHWARK - TLRN', 'LEWISHAM - TLRN',
                      'CITY OF LONDON - TLRN', 
                      'CAMDEN - TLRN', 'ISLINGTON - TLRN',
                      'KENSINGTON & CHELSEA - TLRN', 'CITY OF WESTMINSTER',
                      'HACKNEY - TLRN','TOWER HAMLETS - TLRN',
                      'HOUNSLOW - TLRN', 'EALING - TLRN', 'HAMMERSMITH & FULHAM - TLRN', 'HILLINGDON - TLRN',
                      'BARKING & DAGENHAM - TLRN', 'NEWHAM - TLRN', 'HAVERING - TLRN', 'REDBRIDGE - TLRN', 'WALTHAM FOREST - TLRN',
                      'BRENT - TLRN',  'BARNET - TLRN', 'ENFIELD - TLRN', 'HARROW - TLRN', 'HARINGEY - TLRN' ); 


CREATE OR REPLACE VIEW X_WORKS_BY_STREET_GROUP_SDO AS
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.7 by Aileen Heal
--
--   This view create the shape (polyline) spatial view for the non-spatial view
--   X_WORKS_BY_STREET_GROUP
--
-- N.B. REQUIRE the following STYLES
-- L.TFL.WORKS BY ST GROUP 1
-- L.TFL.WORKS BY ST GROUP 2
-- L.TFL.WORKS BY ST GROUP 3
-- L.TFL.WORKS BY ST GROUP 4
-- L.TFL.WORKS BY ST GROUP 5
-- L.TFL.WORKS BY ST GROUP 6
-- L.TFL.WORKS BY ST GROUP 7
-- L.TFL.WORKS BY ST GROUP 8
-- L.TFL.WORKS BY ST GROUP 9
-- L.TFL.WORKS BY ST GROUP 10
-- L.TFL.WORKS BY ST GROUP 11
-- L.TFL.WORKS BY ST GROUP 12
-- L.TFL.WORKS BY ST GROUP 13
--
-- M.TFL.WORKS BY ST GROUP 1
-- M.TFL.WORKS BY ST GROUP 2
-- M.TFL.WORKS BY ST GROUP 3
-- M.TFL.WORKS BY ST GROUP 4
-- M.TFL.WORKS BY ST GROUP 5
-- M.TFL.WORKS BY ST GROUP 6
-- M.TFL.WORKS BY ST GROUP 7
-- M.TFL.WORKS BY ST GROUP 8
-- M.TFL.WORKS BY ST GROUP 9
-- M.TFL.WORKS BY ST GROUP 10
-- M.TFL.WORKS BY ST GROUP 11
-- M.TFL.WORKS BY ST GROUP 12
-- M.TFL.WORKS BY ST GROUP 13
--
-- V.TFL.WORKS BY ST GRP POINT
-- V.TFL.WORKS BY ST GRP SHAPE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.7.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.7.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
      a.*, b.tphs_geometry, b.TPHS_ID
 from X_WORKS_BY_STREET_GROUP a, tma_phases_sdo b
   WHERE a.phase_id = b.tphs_id;
    

insert into user_sdo_geom_metadata
   select 'X_WORKS_BY_STREET_GROUP', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'TMA_PHASES_SDO' and column_name = 'TPHS_GEOMETRY' and rownum = 1;
    

CREATE OR REPLACE VIEW X_WORKS_BY_STREET_GROUP_SDOPT AS
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.7 by Aileen Heal
--
--   This view create the shape (point) spatial view for the non-spatial view
--   X_WORKS_BY_STREET_GROUP
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/sow_10521/12.1.3.7.sql-arc   3.0   Sep 02 2009 11:58:14   Ian Turnbull  $
--       Module Name      : $Workfile:   12.1.3.7.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:14  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
     a.*, b.geometry, b.TPHS_ID
from X_WORKS_BY_STREET_GROUP a, x_v_tma_phases_points b
    WHERE a.phase_id = b.tphs_id;    

insert into user_sdo_geom_metadata
       select 'X_WORKS_BY_STREET_GROUP_SDOPT', column_name, diminfo, srid
     from user_sdo_geom_metadata
    where table_name = 'X_V_TMA_PHASES_POINTS' and column_name = 'GEOMETRY' and rownum = 1;
   

-- CREATE NM_THEMES ENTRIES ETC.
declare
   theme_id nm_themes_all.nth_theme_id%type;
begin
   nm3sdo.register_sdo_table_as_theme( 'X_WORKS_BY_STREET_GROUP_SDO', 'TPHS_ID', NULL, 'TPHS_GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'WORKS BY STREET GROUP - SHAPE',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA_PHASES_TAB' )
          where nth_feature_table = 'X_WORKS_BY_STREET_GROUP_SDO';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_WORKS_BY_STREET_GROUP_SDO';
    
   
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

   nm3sdo.register_sdo_table_as_theme( 'X_WORKS_BY_STREET_GROUP_SDOPT', 'TPHS_ID', NULL, 'GEOMETRY');
   
   update nm_themes_all
      set nth_theme_name = 'WORKS BY STREET GROUP - POINT',
          NTH_LABEL_COLUMN = 'TPHS_DESCRIPTION',
          nth_rse_table_name = null,
          nth_rse_fk_column = null,
          NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_theme_name = 'TMA PHASES POINTS' )           
    where nth_feature_table = 'X_WORKS_BY_STREET_GROUP_SDOPT';
 
   select nth_theme_id
     into theme_id
     from nm_themes_all 
    where nth_feature_table = 'X_WORKS_BY_STREET_GROUP_SDOPT';
    
   
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
    
-- sdo themes    
Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY STREET GROUP - POINT', 'X_WORKS_BY_STREET_GROUP_SDOPT', 'GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID">' ||
    '<rule column="TSG_NAME"> <features style="V.TFL.WORKS BY ST GRP POINT"> </features> ' ||
    '</rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('WORKS BY STREET GROUP - SHAPE', 'X_WORKS_BY_STREET_GROUP_SDO', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_ID"> ' || 
    '<rule column="TSG_NAME"> <features style="V.TFL.WORKS BY ST GRP SHAPE"> </features> ' ||
    '</rule> </styling_rules>');

COMMIT;
/
