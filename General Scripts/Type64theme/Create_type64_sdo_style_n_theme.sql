--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/General Scripts/Type64theme/Create_type64_sdo_style_n_theme.sql-arc   3.0   Mar 09 2010 10:23:20   iturnbull  $
--       Module Name      : $Workfile:   Create_type64_sdo_style_n_theme.sql  $
--       Date into PVCS   : $Date:   Mar 09 2010 10:23:20  $
--       Date fetched Out : $Modtime:   Mar 09 2010 09:36:42  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
-- This script will create new styles and theme for NSG theme type 64
-- It is assume that the theme has already been created using the GIS Layer tool
--
---------------------------------------------------------------------------------------------------
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='Create_type64_sdo_style_n_theme_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

select name from v$database;

BEGIN
  Insert into USER_SDO_STYLES
   (NAME, TYPE, DEFINITION)
  Values
   ('L.EXOR.NSG.TYPE 64', 'LINE', 
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<svg width="1in" height="1in"> ' ||
    '<desc></desc> ' ||
    '<g class="line" style="fill:#FF00FF;fill-opacity:247;stroke-width:3.0"> ' ||
    '<line class="base" /></g> </svg>');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN -- do nothing 
       NULL;
END;
/
    
BEGIN
  Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
  Values
   ('TYPE 64', 'V_NM_NIT_TP64_SDO_DT', 'GEOLOC',
    '<?xml version="1.0" standalone="yes"?> ' ||
    '<styling_rules key_column="TP64_IIT_NE_ID"> ' ||
    '<rule> <features style="L.EXOR.NSG.TYPE 64"> </features> </rule> </styling_rules>');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN -- do nothing 
       NULL;
END;
/

-- REMOVE ROLE FROM NON DT VIEW
DELETE from nm_theme_roles 
   where NTHR_THEME_ID  = (select nth_theme_id from NM_themes_all where nth_theme_name = 'TP64-TYPE 64' );


PROMPT issue a commit if all ok or rollback if errors
spool off


