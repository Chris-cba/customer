-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS5025_Lighting_Point_Theme/BRS5025.SQL-arc   1.0   May 09 2011 17:52:16   Ian.Turnbull  $
--       Module Name      : $Workfile:   BRS5025.SQL  $
--       Date into PVCS   : $Date:   May 09 2011 17:52:16  $
--       Date fetched Out : $Modtime:   May 09 2011 12:44:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--    BRS5025.sql
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--
-- before running this script you must
-- 1. create the asset theme LP using GIS layer tool
-- 2. create the view V_X_LP_SDO_DT using the script V_X_LP_SDO_DT.sql
-- 3. Using GIS Themes form copy the theme for LP-LIGHTING POIN_DT to new theme
--     LIGHTING POINT feature table ( V_X_LP_SDO_DT)
-- 4. run this script
-- 5. Copy sdo_styles, sdo_themes & sdo_maps from sandbox over into live.
-- 6. set prodcut option WEBMAPNAME to NHCC BRS 5025.

declare
v_new_theme_id number;
v_old_theme_id number;
begin
   select nth_theme_id into v_new_theme_id 
      from nm_themes_all where nth_feature_table = 'V_X_LP_SDO_DT';
--      
   select nth_theme_id into v_old_theme_id 
   from nm_themes_all where nth_feature_table = 'V_NM_ONA_LP_SDO_DT';
--
   insert into nm_theme_roles 
        select v_new_theme_id, NTHR_ROLE, NTHR_MODE 
           from nm_theme_roles 
        where NTHR_THEME_ID = v_old_theme_id;
--
   insert into nm_theme_functions_all    
       select v_new_theme_id,  NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS
         from nm_theme_functions_all
      where    NTF_NTH_THEME_ID = v_old_theme_id;
--      
   insert into nm_theme_gtypes (NTG_THEME_ID,NTG_GTYPE,NTG_SEQ_NO)
      select v_new_theme_id, NTG_GTYPE, NTG_SEQ_NO
      from nm_theme_gtypes
      where NTG_THEME_ID = v_old_theme_id;
--      
  Insert into NORTHANTS.NM_INV_THEMES
   Values('LP',v_new_theme_id );
--
end;
/     
         
