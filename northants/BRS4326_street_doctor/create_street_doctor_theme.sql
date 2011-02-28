--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS4326_street_doctor/create_street_doctor_theme.sql-arc   1.0   Feb 28 2011 16:08:10   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_street_doctor_theme.sql  $
--       Date into PVCS   : $Date:   Feb 28 2011 16:08:10  $
--       Date fetched Out : $Modtime:   Feb 15 2011 13:16:14  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : Aileen Heal
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- script to create street doctor theme. 
-- n.b.  X_NHCC_STREET_DOCTOR.fnc 
-- and   v_x_nhcc_street_doctor.vew 
-- must be run first
--
Insert into NORTHANTS.NM_THEMES_ALL
   (NTH_THEME_ID, NTH_THEME_NAME, NTH_TABLE_NAME,NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_X_COLUMN, NTH_Y_COLUMN, NTH_FEATURE_TABLE, NTH_FEATURE_PK_COLUMN, 
    NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, 
    NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
    NTH_DYNAMIC_THEME)
 select
    nth_theme_id_seq.nextval, 'STREET DOCTOR',NTH_TABLE_NAME,NTH_PK_COLUMN, NTH_LABEL_COLUMN, 
    NTH_RSE_TABLE_NAME, NTH_X_COLUMN, NTH_Y_COLUMN,  'V_X_NHCC_STREET_DOCTOR',NTH_FEATURE_PK_COLUMN, 
    NTH_FEATURE_SHAPE_COLUMN, NTH_HPR_PRODUCT, NTH_LOCATION_UPDATABLE, NTH_THEME_TYPE, 
    NTH_DEPENDENCY, NTH_STORAGE, NTH_UPDATE_ON_EDIT, NTH_USE_HISTORY, NTH_BASE_TABLE_THEME, 
    NTH_SEQUENCE_NAME, NTH_SNAP_TO_THEME, NTH_LREF_MANDATORY, NTH_TOLERANCE, NTH_TOL_UNITS, 
    NTH_DYNAMIC_THEME
from nm_themes_all where nth_feature_table = 'V_ENQ_BY_STATUS_SOURCE_XY_SDO';
   
declare
   v_theme_id number;
   v_org_theme_id number;
begin
   select nth_theme_id 
      into v_theme_id
     from nm_themes_all
  where nth_theme_name =  'STREET DOCTOR';
  
   select nth_theme_id 
      into v_org_theme_id
     from nm_themes_all
  where nth_feature_table =  'V_ENQ_BY_STATUS_XY_SDO';

  insert into nm_inv_themes
         select nith_nit_id, v_theme_id
         from  nm_inv_themes
         where NITH_NTH_THEME_ID = v_org_theme_id;
         
   insert into nm_theme_roles
          select v_theme_id, NTHR_ROLE, NTHR_MODE
            from nm_theme_roles
         where NTHR_THEME_ID  = v_org_theme_id;
   
   insert into nm_theme_functions_all
          select v_theme_id, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS
            from nm_theme_functions_all
         where NTF_NTH_THEME_ID = v_org_theme_id;
         
   insert into nm_theme_gtypes(NTG_THEME_ID, NTG_GTYPE, NTG_SEQ_NO)
        select v_theme_id, NTG_GTYPE, NTG_SEQ_NO
            from nm_theme_gtypes
        where  NTG_THEME_ID = v_org_theme_id;

       insert into nm_theme_snaps
              select v_theme_id, NTS_SNAP_TO, NTS_PRIORITY
                from nm_theme_snaps  
             where  NTS_THEME_ID =   v_org_theme_id;
             
      insert into nm_base_themes
      select v_theme_id, NBTH_BASE_THEME
                from nm_base_themes  
             where  NBTH_THEME_ID =  v_org_theme_id;
           
end;
/   
