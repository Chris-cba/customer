CREATE OR REPLACE VIEW V_X_TMAPHS_FWD_PLAN_SDOPT
AS 
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/tma_traffic_themes/V_X_TMAPHS_FWD_PLAN_SDOPT.vw-arc   1.0   May 05 2010 15:57:38   iturnbull  $
--       Module Name      : $Workfile:   V_X_TMAPHS_FWD_PLAN_SDOPT.vw  $
--       Date into PVCS   : $Date:   May 05 2010 15:57:38  $
--       Date fetched Out : $Modtime:   May 05 2010 10:41:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--   This view was written to create special TMA Theme 'TMA FWD PLAN'
--   which uses different icons dependent upon the traffic resetriction being applied
--   It is dependent upon the view V_X_TMA_WORKS_ACTIVE_PHASE
--
----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
          twor_works_id, twor_works_ref, twor_org_ref, twor_dist_ref,
          twor_no_of_phases, twor_str_ne_id, twor_actual_works_ref,
          twor_licence_id, twor_external_ref, org_name, org_prefix, dist_name,
          dist_prefix, str_usrn, str_descr, str_locality, str_town,
          str_county, str_provisional_street_flag, tphs_active_flag,
          tphs_phase_no, tphs_description, tphs_phase_status,
          tphs_works_category, twca_description, tphs_phase_type,
          hig_codes1.hco_meaning phase_type_meaning, tphs_proposed_start_date,
          tphs_est_end_date, tphs_latest_start_date, tphs_latest_end_date,
          tphs_act_start_date, tphs_act_end_date, tphs_start_date,
          tphs_end_date, hig_codes2.hco_meaning phase_status_meaning,
          tphs_reinst_cat, tphs_phase_id, tphs_loc_description,
          tphs_challenged, tphs_cway_restrict_type, hig_codes3.HCO_MEANING cway_restrict_meaning,
          B.TPPS_TPHS_GEOMETRY GEOM_PT
     FROM V_X_TMA_WORKS_ACTIVE_PHASE,
          nsg_organisations,
          nsg_districts,
          v_tma_streets,                        -- join to the restricted view
          tma_works_categories,
          hig_codes hig_codes1,
          hig_codes hig_codes2,
          hig_codes hig_codes3,
          TMA_PHASES_POINT_SDO b
    WHERE twor_org_ref = org_ref
      AND twor_dist_ref = dist_ref
      AND org_ref = dist_org_ref
      AND twor_str_ne_id = str_ne_id
      AND tphs_works_category = twca_works_category
      AND tphs_phase_type = hig_codes1.hco_code
      AND hig_codes1.hco_domain = 'PHASE_TYPE'
      AND tphs_phase_status = hig_codes2.hco_code
      AND hig_codes2.hco_domain = 'PHASE_STATUS'
      and hig_codes3.HCO_DOMAIN = 'PHASE_CWAY_RESTRICT'
      and tphs_cway_restrict_type = hig_codes3.HCO_CODE
      and TPHS_PHASE_STATUS in ('FWD_PLAN')
      and tphs_phase_id = b.TPPS_TPHS_ID
/