--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/4 1 TMA Themes/TMA_THEMES_4_1.SQL-arc   3.0   Nov 09 2009 11:34:32   iturnbull  $
--       Module Name      : $Workfile:   TMA_THEMES_4_1.SQL  $
--       Date into PVCS   : $Date:   Nov 09 2009 11:34:32  $
--       Date fetched Out : $Modtime:   Nov 09 2009 11:33:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
-- This script backs up the original TMA user_sdo_themes and creates the new 
-- 4.1 TMA user_sdo_themes. 
--
-- Once you have run this script you should do the following:
-- 1. Run mapBuilder
-- 2. Import the styles tma_4_1_styles.dat   
-- 3. Add following themes to the map using MapBuilder.
--       TMA_ACTIVE_PHASES (POINT)
--       TMA_SITES (POINT)
--       TMA_RESTRICTIONS (POINT)
-- 4. save the map
-- 5. Restart mapviewer
-- 6. run locator and check themes look OK.

---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='TMA_THEMES_4_1_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on


-- backup sdo_themes and maps
create table user_sdo_themes_bkup_41_ah as select * from user_sdo_themes;

COMMENT ON TABLE user_sdo_themes_bkup_41_ah IS 'This is a backup up of user_sdo_themes before running script tma_thmes_4_1.sql.';

create table user_sdo_maps_bkup_41_ah as select * from user_sdo_maps;

COMMENT ON TABLE user_sdo_maps_bkup_41_ah IS 'This is a backup up of user_sdo_map before running script tma_thmes_4_1.sql.';

-- backup old themes
insert into USER_SDO_THEMES
   select 'TMA_ACTIVE_PHASES_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
   from USER_SDO_THEMES where name = 'TMA_ACTIVE_PHASES';

insert into USER_SDO_THEMES
   select 'TMA_RESTRICTIONS_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
   from USER_SDO_THEMES where name = 'TMA_RESTRICTIONS';

insert into USER_SDO_THEMES
   select 'TMA_SITES_OLD', DESCRIPTION, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES
   from USER_SDO_THEMES where name = 'TMA_SITES';

-- load new themes
delete from USER_SDO_THEMES where name in ('TMA_ACTIVE_PHASES', 'TMA_RESTRICTIONS', 'TMA_SITES');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_ACTIVE_PHASES', 'V_TMA_PHASES_SDO', 'TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_PHASE_ID" table_alias="A"> ' ||
    '<rule column="A.TPHS_GEOMETRY.SDO_GTYPE"> <features style="V.EXOR.TMA.PHASE"> </features> </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_ACTIVE_PHASES (POINT)', 'V_TMA_PHASES_PT_SDO', 'TPPS_TPHS_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TPHS_PHASE_ID"> ' ||
    '<rule> <features style="M.EXOR.TMA.PHASE.PT"> </features> </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_RESTRICTIONS', 'V_TMA_RESTRICTIONS_SDO', 'TRES_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TRES_RESTRICTION_ID" table_alias="A"> ' ||
    '<rule column="A.TRES_GEOMETRY.SDO_GTYPE"> <features style="V.EXOR.TMA.RESTRICTION"> </features>  </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_RESTRICTIONS (POINT)', 'V_TMA_RESTRICTIONS_PT_SDO', 'TPPS_TRES_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TRES_RESTRICTION_ID"> ' ||
    '<rule> <features style="M.EXOR.TMA.RESTRICTIONS.PT"> </features> </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_SITES', 'V_TMA_SITES_SDO', 'TSIT_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TSIT_ID" table_alias="A"> ' ||
    '<rule column="A.TSIT_GEOMETRY.SDO_GTYPE"> <features style="V.EXOR.TMA.SITES"> </features> </rule> </styling_rules>');

Insert into USER_SDO_THEMES
   (NAME, BASE_TABLE, GEOMETRY_COLUMN, STYLING_RULES)
 Values
   ('TMA_SITES (POINT)', 'V_TMA_SITES_PT_SDO', 'TSPS_TSIT_GEOMETRY', 
    '<?xml version="1.0" standalone="yes"?> <styling_rules key_column="TSIT_ID"> ' ||
    '<rule> <features style="M.EXOR.TMA.SITES.PT"> </features>  </rule> </styling_rules>');

-- update the theme names
Update nm_themes_all set nth_theme_name = 'TMA_ACTIVE_PHASES (POINT)' where nth_feature_table = 'V_TMA_PHASES_PT_SDO';

Update nm_themes_all set nth_theme_name = 'TMA_RESTRICTIONS (POINT)' where nth_feature_table = 'V_TMA_RESTRICTIONS_PT_SDO';

Update nm_themes_all set nth_theme_name = 'TMA_SITES (POINT)' where nth_feature_table = 'V_TMA_SITES_PT_SDO';

--COMMIT;

-- make sure they have locatro function on the themes
begin
 for rec in (select nth_theme_id 
                      from nm_themes_all 
                     where nth_feature_table in ( 'V_TMA_PHASES_PT_SDO', 'V_TMA_RESTRICTIONS_PT_SDO', 'V_TMA_SITES_PT_SDO',
                                                  'V_TMA_PHASES_SDO', 'V_TMA_RESTRICTIONS_SDO', 'V_TMA_SITES_SDO' ))
    loop                                              
       BEGIN
          Insert into NM_THEME_FUNCTIONS_ALL
                      (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS)
               Values (rec.nth_theme_id,'NM0572', 'GIS_SESSION_ID', 'Locator', 'Y');
    
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN 
          NULL;
       END;
       
    end loop;   
end;
/
--commit;
PROMPT issue a commit if all ok or rollback if errors
spool off

