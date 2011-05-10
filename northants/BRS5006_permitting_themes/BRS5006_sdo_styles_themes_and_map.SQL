-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS5006_permitting_themes/BRS5006_sdo_styles_themes_and_map.SQL-arc   1.0   May 10 2011 09:08:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   BRS5006_sdo_styles_themes_and_map.SQL  $
--       Date into PVCS   : $Date:   May 10 2011 09:08:46  $
--       Date fetched Out : $Modtime:   May 09 2011 12:03:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--    BRS5006_sdo_styles_themes_and_map.sql
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
-- This script will create the sdo styles/temes and maps required by BRS 5006
--
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='BRS5006_sdo_styles_themes_and_map_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

select instance_name from v$instance;

select user from dual;

Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('L.X.BRS5006.YELLOW', 'LINE', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
   '<desc></desc> ' ||
   '<g class="line" style="fill:#FFFF00;stroke-width:4"> ' ||
   '<line class="parallel" style="fill:#FFCC00;stroke-width:1" /> ' ||
   '</g> </svg> ');
   
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('L.X.BRS5006.BLUE', 'LINE', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
   '<desc></desc> ' ||
   '<g class="line" style="fill:#33FFFF;stroke-width:4"> ' ||
   '<line class="parallel" style="fill:#3399FF;stroke-width:1" /> ' ||
   '</g> </svg> ');
  
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('V..X.BRS5006.YELLOW', 'ADVANCED', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" ?> ' ||
   '<AdvancedStyle> ' ||
   '<CollectionStyle> ' ||
  '<style name="C.X.BRS5006.YELLOW" shape="polygon" /> ' ||
  '<style name="L.X.BRS5006.YELLOW" shape="line" /> ' ||
  '<style name="M.X.BRS5006.YELLOW" shape="point" /> ' ||
  '</CollectionStyle> ' ||
  '</AdvancedStyle>');
  
Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
 Values
   ('V..X.BRS5006.BLUE', 'ADVANCED', 
   '<?xml version="1.0" ?> ' ||
   '<AdvancedStyle> ' ||
  '<CollectionStyle> ' ||
  '<style name="C.X.BRS5006.BLUE" shape="polygon" /> ' ||
  '<style name="L.X.BRS5006.BLUE" shape="line" /> ' ||
  '<style name="M.X.BRS5006.BLUE" shape="point" /> ' ||
  '</CollectionStyle> ' ||
  '</AdvancedStyle>');
  
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('M.X.BRS5006.BLUE', 'MARKER', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
  '<desc></desc> ' ||
  '<g class="marker" style="stroke:#33AAFF;fill:#33FFFF;width:10;height:10;font-family:Dialog;font-size:12;font-fill:#FF0000">  ' ||
  '<circle cx="0" cy="0" r="0" /> ' ||
  '</g> </svg>');
  
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('M.X.BRS5006.YELLOW', 'MARKER', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
   '<desc></desc> ' ||
   '<g class="marker" style="stroke:#FFCC00;fill:#FFFF00;width:10;height:10;font-family:Dialog;font-size:12;font-fill:#FF0000"> ' ||
   '<circle cx="0" cy="0" r="0" /> ' ||
   '</g> </svg>');
   
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('C.X.BRS5006.YELLOW', 'COLOR', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
   '<desc/> ' ||
   '<g class="color" style="stroke:#999900;fill:#FFFF00;fill-opacity:153"> ' ||
   '<rect width="50" height="50"/> ' ||
  '</g> </svg>');
  
Insert into USER_SDO_STYLES
   (NAME, TYPE, DESCRIPTION, DEFINITION)
 Values
   ('C.X.BRS5006.BLUE', 'COLOR', 'Style Created by Aileen Heal as work done under BRS 5006', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<svg width="1in" height="1in"> ' ||
   '<desc/> ' ||
   '<g class="color" style="stroke:#33AAFF;fill:#33FFFF;fill-opacity:127"> ' ||
   '<rect width="50" height="50"/> ' ||
   '</g> </svg>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA FWD PLAN PERMIT SHAPE', 'X_NHCC_FWDPLAN_PERM_SHP_SDO', 'TPHS_GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<styling_rules key_column="TPHS_PHASE_ID" table_alias="A"> ' ||
   '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> ' ||
   '<features style="V..X.BRS5006.BLUE"> </features> ' ||
  '</rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA PROP IN PROG PERMIT SHAPE', 'X_NHCC_PROPINPROG_PERM_SHP_SDO', 'TPHS_GEOMETRY', 
   '<?xml version="1.0" standalone="yes"?> ' ||
   '<styling_rules key_column="TPHS_PHASE_ID" table_alias="A"> ' ||
   '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> ' ||
   '<features style="V..X.BRS5006.YELLOW"> </features> ' ||
   '</rule> </styling_rules>');

Insert into USER_SDO_MAPS
   (NAME, DESCRIPTION, DEFINITION)
 Values
   ('NHSWM_BRS5006', 'Map created by Aileen Heal as work done under BRS 5006', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<map_definition> ' ||
    '<theme name="PARISH" min_scale="999999.0" max_scale="800.0" min_dist="1.0"/> ' ||
    '<theme name="ESU" min_scale="800.0" max_scale="0.0" min_dist="1.0"/> ' ||
    '<theme name="COUNTY"/> ' ||
    '<theme name="OFFICIAL STREETS" min_scale="4000.0" max_scale="0.0" min_dist="1.0"/> ' ||
    '<theme name="ROAD NUMBER STREETS" min_scale="800.0" max_scale="0.0" min_dist="1.0"/> ' ||
    '<theme name="MGWSP SCHEMES 2010/2011"/> ' ||
    '<theme name="UNOFFICIAL STREETS" min_scale="100.0" max_scale="0.0" min_dist="1.0"/> ' ||
    '<theme name="TYPE 23" min_scale="3000.0" max_scale="0.0"/> ' ||
    '<theme name="SWR_SITE_DETAILS" min_scale="300.0" max_scale="0.0" min_dist="1.0"/> ' ||
    '<theme name="TMA FWD PLAN NRSWA" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA FWD PLAN PERMIT SHAPE" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA FWD PLAN PERMIT" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA COMPLETE NRSWA" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA COMPLETE PERMIT" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA PROP IN PROGRESS NRSWA" min_scale="1750.0" max_scale="0.0"/> ' ||
    '<theme name="TMA PROP IN PROG PERMIT SHAPE" min_scale="1750.0" max_scale="0.0"/> ' ||
    '<theme name="TMA PROP IN PROGRESS PERMIT" min_scale="1750.0" max_scale="0.0"/> ' ||
    '<theme name="TMA_ACTIVE_PHASES" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA SITES NRSWA" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TMA SITES PERMIT" min_scale="500.0" max_scale="0.0"/> ' ||
    '<theme name="TYPE 64" min_scale="3000.0" max_scale="0.0"/> ' ||
    '<theme name="SECTION 58 - POINT" min_scale="1750.0" max_scale="0.0"/> ' ||
    '<theme name="SECTION 58 - SHAPE" min_scale="1750.0" max_scale="0.0"/> ' ||
    '</map_definition>');

begin 
hig.set_opt('WEBMAPNAME', 'NHSWM_BRS5006');
end;
/

spool off
