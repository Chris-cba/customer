  ------------------------------------------------------------------------------
  --
  --  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 by Aileen Heal
  --
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/swr works.sql-arc   3.0   Sep 02 2009 11:58:18   Ian Turnbull  $
--       Module Name      : $Workfile:   swr works.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:18  $
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

CREATE OR REPLACE FORCE VIEW SWR_DETAILS AS  
   SELECT 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 by Aileen Heal
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/swr works.sql-arc   3.0   Sep 02 2009 11:58:18   Ian Turnbull  $
--       Module Name      : $Workfile:   swr works.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:18  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
          wor.wor_orig_ref, 
          wor.wor_true_ver_num, 
          wor.wor_job_ref,
          org.swa_name, 
          dis.odi_name, 
          UPPER (wty.wty_name) wty_name,
          wor_status_type,
          src_wst.rco_meaning work_status, 
          UPPER (wor.wor_descr) wor_descr,
          wor.wor_notice_date, 
          wor.wor_start_date, 
          wor.wor_estimated_end_date,
          wor.wor_abandoned_date, 
          wor.wor_completed_date,
          wor.wor_est_insp_units, 
          wor.wor_actual_insp_units,
          wor.wor_external_ref, 
          sit.sit_num, 
          sit.sit_start_date,
          sit.sit_estimated_end_date, 
          sit.sit_interim_date,
          sit.sit_extant_date, 
          sit.sit_warranty_end_date,
          src_st.rco_meaning site_status, 
          UPPER(swr_reference.get_swr_ref_code_meaning('STREET_LOCATION_TYPE',sit.sit_street_location_type)) site_location,
          UPPER (sit.sit_location_text) site_location_description,
          UPPER(swr_reference.get_swr_ref_code_meaning ('SITE_DEPTH_TYPE',sit.sit_depth_type)) site_depth_type, 
          sit.sit_length_val,
          sit.sit_width_val, 
          UPPER(swr_reference.get_swr_ref_code_meaning ('SITE_TRAFF_MGT_CODE',sit.sit_traff_mgt_code)) traffic_management,
          src_emt.rco_meaning excavation_method,
          sit_id, 
          sit_str_nsg_ref,
          sit_wor_job_ref sco_wor_job_ref, 
          wor_status_type sco_works_status,
          hco_code sco_auth_type, 
          hco_meaning sco_auth_type_meaning,
          str_usrn,
          str_version,
          str_county,
          str_town,
          str_locality
     FROM swr_sites_all sit,
          swr_works_all wor,
          swr_organisations org,
          swr_operational_districts dis,
          hig_codes,
          swr_work_types wty,
          swr_ref_codes src_wst,
          swr_ref_codes src_st,
          swr_ref_codes src_emt,
          v_nm_nsg_simple_streets
    WHERE wor_job_ref = sit_wor_job_ref
      AND wor_swa_ref = swa_ref
      AND TO_CHAR (swa_type) = hco_code
      AND hco_domain = 'ADMIN TYPE GROUPINGS'
      AND wor.wor_swa_ref = dis.odi_swa_ref
      AND wor.wor_odi_ref = dis.odi_ref
      AND wor.wor_wty_type = wty.wty_type
      AND src_wst.rco_domain = 'WORKS_STATUS_TYPE'
      AND src_wst.rco_code = wor.wor_status_type
      AND src_st.rco_domain = 'SITE_TYPE'
      AND src_st.rco_code = sit.sit_type
      AND src_emt.rco_domain = 'EXCAVATION_METHOD_TYPE'
      AND src_emt.rco_code = sit.sit_excavation_method_type
      and str_ne_id=sit_str_nsg_ref
      and exists
      (select 'x' from swr_streets_of_interest
      where sin_str_nsg_ref=sit_str_nsg_ref);

CREATE OR REPLACE FORCE VIEW SWR_DETAILS_SDO as
  select 
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/swr works.sql-arc   3.0   Sep 02 2009 11:58:18   Ian Turnbull  $
--       Module Name      : $Workfile:   swr works.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:18  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
         * 
    from SWR_DETAILS, SWR_SITES_XY_SDO 
   where sco_sit_id=sit_id;
   
INSERT into USER_SDO_GEOM_METADATA
  SELECT 'SWR_DETAILS_SDO', COLUMN_NAME, DIMINFO, SRID
    FROM USER_SDO_GEOM_METADATA
   WHERE TABLE_NAME = 'SWR_SITES_XY_SDO'
     and not exists (select 'x' from USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'SWR_DETAILS_SDO');
     
UPDATE NM_THEMES_ALL 
   SET NTH_FEATURE_TABLE = 'SWR_DETAILS_SDO' 
 WHERE NTH_THEME_NAME = 'SWR SITES';  
 
CREATE OR REPLACE FORCE VIEW X_SWR_DETAILS_NOT_CLOSED_SDO as
  select 
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/swr works.sql-arc   3.0   Sep 02 2009 11:58:18   Ian Turnbull  $
--       Module Name      : $Workfile:   swr works.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:18  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:38:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
         * 
    from SWR_DETAILS, SWR_SITES_XY_SDO 
   where sco_sit_id=sit_id
   and not wor_status_type in (7,4,6);
   
INSERT into USER_SDO_GEOM_METADATA
  SELECT 'X_SWR_DETAILS_NOT_CLOSED_SDO', COLUMN_NAME, DIMINFO, SRID
    FROM USER_SDO_GEOM_METADATA
   WHERE TABLE_NAME = 'SWR_SITES_XY_SDO'
     and not exists (select 'x' from USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'X_SWR_DETAILS_NOT_CLOSED_SDO');
     
-- TO DO MANUALLY ---
-- create new theme based upon sites called SWR WORKS with feature table  X_SWR_DETAILS_NOT_CLOSED_SDO  
-- create new user_sdo_themes called SWR WORKS with feature table  X_SWR_DETAILS_NOT_CLOSED_SDO


