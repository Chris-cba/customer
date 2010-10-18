-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/colas/MAI_Themes/white_work.sql-arc   3.0   Oct 18 2010 15:50:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   white_work.sql  $
--       Date into PVCS   : $Date:   Oct 18 2010 15:50:50  $
--       Date fetched Out : $Modtime:   Oct 18 2010 14:51:50  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
--    black_work_footway.sql
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
-- script created by Aileen Heal as part of BRS 2945 October 2010
-- to create theme White Work

CREATE OR REPLACE FORCE VIEW V_X_DEF_WHITEWORK 
   ("DEFECT_ID", "DEFECT_ROAD_ID", "DEFECT_ROAD_NAME", "DEFECT_ROAD_DESCRIPTION", 
    "DEFECT_START_CHAIN", "DEFECT_ARE_REPORT_ID", "DEFECT_SISS_ID", "DEFECT_WORKS_ORDER_NO", 
    "DEFECT_CREATED_DATE", "DEFECT_INSPECTED_DATE", "DEFECT_INSPECTED_TIME", 
    "DEFECT_CODE", "DEFECT_PRIORITY", "DEFECT_STATUS_CODE", "DEFECT_ACTIVITY", 
    "DEFECT_LOCATION", "DEFECT_DESCRIPTION", "DEFECT_ASSET_TYPE", "DEFECT_ASSET_ID", 
    "DEFECT_INITIATION_TYPE", "DEFECT_INSPECTOR", "DEFECT_X_SECTION", "DEFECT_NOTIFY_ORG", 
    "DEFECT_RECHARGE_ORG", "GEOLOC", "OBJECTID") 
AS 
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/colas/MAI_Themes/white_work.sql-arc   3.0   Oct 18 2010 15:50:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   white_work.sql  $
--       Date into PVCS   : $Date:   Oct 18 2010 15:50:50  $
--       Date fetched Out : $Modtime:   Oct 18 2010 14:51:50  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author:   Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
-- view created by Aileen Heal as part of BRS 2945 October 2010
-- for theme WHITE WORK
--
 a."DEFECT_ID",a."DEFECT_ROAD_ID",a."DEFECT_ROAD_NAME",a."DEFECT_ROAD_DESCRIPTION",a."DEFECT_START_CHAIN",
  a."DEFECT_ARE_REPORT_ID",a."DEFECT_SISS_ID",a."DEFECT_WORKS_ORDER_NO",a."DEFECT_CREATED_DATE",
  a."DEFECT_INSPECTED_DATE",a."DEFECT_INSPECTED_TIME",a."DEFECT_CODE",a."DEFECT_PRIORITY",
  a."DEFECT_STATUS_CODE",a."DEFECT_ACTIVITY",a."DEFECT_LOCATION",a."DEFECT_DESCRIPTION",a."DEFECT_ASSET_TYPE",
  a."DEFECT_ASSET_ID",a."DEFECT_INITIATION_TYPE",a."DEFECT_INSPECTOR",a."DEFECT_X_SECTION",a."DEFECT_NOTIFY_ORG",
  a."DEFECT_RECHARGE_ORG",B."GEOLOC",B."OBJECTID" 
   FROM V_MAI_DEFECTS a, MAI_DEFECTS_XY_SDO b 
 WHERE A.DEFECT_CODE IN ('SLRK','SLBK','KBRK','KBBK','HWMA','CHAN','CESA','BPPR')
 And a.DEFECT_ID = b.DEF_DEFECT_ID
/

insert into user_sdo_geom_metadata
    select 'V_X_DEF_WHITEWORK', 'GEOLOC', DIMINFO, SRID 
      FROM user_sdo_geom_metadata
      where table_name = 'MAI_DEFECTS_XY_SDO'
/

Insert into nm_themes_all( NTH_THEME_ID,NTH_THEME_NAME,NTH_TABLE_NAME,NTH_WHERE,
                           NTH_PK_COLUMN,NTH_LABEL_COLUMN,NTH_RSE_TABLE_NAME,
                           NTH_RSE_FK_COLUMN,NTH_ST_CHAIN_COLUMN,NTH_END_CHAIN_COLUMN,
                           NTH_X_COLUMN,NTH_Y_COLUMN,NTH_OFFSET_FIELD,NTH_FEATURE_TABLE,
                           NTH_FEATURE_PK_COLUMN,NTH_FEATURE_FK_COLUMN,NTH_XSP_COLUMN,
                           NTH_FEATURE_SHAPE_COLUMN,NTH_HPR_PRODUCT,NTH_LOCATION_UPDATABLE,
                           NTH_THEME_TYPE,NTH_DEPENDENCY,NTH_STORAGE,NTH_UPDATE_ON_EDIT,
                           NTH_USE_HISTORY,NTH_START_DATE_COLUMN,NTH_END_DATE_COLUMN,
                           NTH_BASE_TABLE_THEME,NTH_SNAP_TO_THEME,
                           NTH_LREF_MANDATORY,NTH_TOLERANCE,NTH_TOL_UNITS,NTH_DYNAMIC_THEME) 
select nth_theme_id_seq.nextval,'WHITE WORK','V_MAI_DEFECTS',
        'DEFECT_CODE IN (''SLRK'',''SLBK'',''KBRK'',''KBBK'',''HWMA'',''CHAN'',''CESA'',''BPPR'')',
        'DEFECT_ID','DEFECT_ID','NM_ELEMENTS',null,null,null,'DEF_EASTING','DEF_NORTHING',null,
        'V_X_DEF_WHITEWORK','DEFECT_ID',null,null,'GEOLOC','MAI','Y','SDO','I','S','N','N',
        null,null,nth_theme_id,'S','N',10,1,'N' from nm_themes_all where nth_feature_table = 'MAI_DEFECTS_XY_SDO'
/

DECLARE
  v_new_theme_id NUMBER;
  v_defect_theme_id number;
begin
   select nth_theme_id
     into v_new_theme_id
     from nm_themes_all
    where nth_feature_table = 'V_X_DEF_WHITEWORK';
   
   select nth_theme_id
     into v_defect_theme_id
     from nm_themes_all
    where nth_feature_table = 'V_MAI_DEF_ACT_STA_XY_SDO';
    
   insert into nm_theme_roles
      select v_new_theme_id, nthr_role, nthr_mode
        from nm_theme_roles
       where nthr_theme_id = v_defect_theme_id;
       
   insert into nm_theme_functions_all
    select v_new_theme_id, ntf_hmo_module, ntf_parameter, ntf_menu_option, ntf_seen_in_gis
   from nm_theme_functions_all
   where ntf_nth_theme_id = v_defect_theme_id;
      
   insert into nm_base_themes
   select v_new_theme_id, nbth_base_theme
   from nm_base_themes
   where nbth_theme_id = v_defect_theme_id;
   
   insert into nm_theme_snaps 
     select v_new_theme_id, nts_snap_to, nts_priority
     from nm_theme_snaps
     where nts_theme_id = v_defect_theme_id;

   insert into nm_theme_gtypes 
      select v_new_theme_id, ntg_gtype, ntg_seq_no, ntg_xml_url
      from nm_theme_gtypes
      where ntg_theme_id = v_defect_theme_id;
      
  insert into nm_inv_themes
  values ('DEFX',v_new_theme_id);
  
end;
/

Insert into USER_SDO_THEMES (NAME,DESCRIPTION,BASE_TABLE,GEOMETRY_COLUMN,STYLING_RULES) 
values ('WHITE WORK','Bespoke theme created by Aileen Heal as part of BRS 2945',
        'V_X_DEF_WHITEWORK','GEOLOC',
        '<?xml version="1.0" standalone="yes"?> ' ||
        '<styling_rules key_column="OBJECTID"> ' ||
        '<rule column="DEFECT_STATUS_CODE"> ' ||
        '<features style="V.EXOR.DEFECT.STATUS"> </features> ' ||
        '</rule> </styling_rules>' )
/


 