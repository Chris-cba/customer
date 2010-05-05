CREATE OR REPLACE VIEW V_X_TMA_WORKS_ACTIVE_PHASE
AS 
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/tma_traffic_themes/V_X_TMA_WORKS_ACTIVE_PHASE.vw-arc   1.0   May 05 2010 15:57:38   iturnbull  $
--       Module Name      : $Workfile:   V_X_TMA_WORKS_ACTIVE_PHASE.vw  $
--       Date into PVCS   : $Date:   May 05 2010 15:57:38  $
--       Date fetched Out : $Modtime:   May 05 2010 12:23:26  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
--   This view was written in order to create special TMA Themes 
--   'TMA WORKS COMPLETE', 'TMA PROP IN PROGRESS, 'TMA FWD PLAN'
--   which use different icons dependent upon the traffic resetriction being applied
--
----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
          twor_works_id, twor_works_ref, twor_org_ref, twor_dist_ref,
          twor_str_ne_id, twor_no_of_phases, twor_actual_works_ref,
          twor_licence_id, twor_external_ref, twor_postcode, tphs_phase_no,
          tphs_active_flag, tphs_description, tphs_phase_status,
          tphs_works_category, tphs_phase_type, tphs_proposed_start_date,
          tphs_est_end_date, tphs_latest_start_date, tphs_latest_end_date,
          tphs_act_start_date, tphs_act_end_date,
          NVL (tphs_act_start_date, tphs_proposed_start_date) tphs_start_date,
          NVL (tphs_act_end_date, tphs_est_end_date) tphs_end_date,
          tphs_reinst_cat, tphs_id tphs_phase_id, tphs_loc_description,
          DECODE (tphs_challenge_end_date, NULL, 'N', 'Y') tphs_challenged,
          tphs_cway_restrict_type
     FROM tma_works, tma_phases
    WHERE twor_works_id = tphs_works_id AND tphs_active_flag = 'Y'
/    



