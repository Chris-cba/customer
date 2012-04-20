CREATE OR REPLACE FORCE VIEW x_dcc_tma_works_active_phase (twor_works_id,
                                                           twor_works_ref,
                                                           twor_org_ref,
                                                           twor_dist_ref,
                                                           twor_str_ne_id,
                                                           twor_no_of_phases,
                                                           twor_actual_works_ref,
                                                           twor_licence_id,
                                                           twor_external_ref,
                                                           twor_postcode,
                                                           tphs_phase_no,
                                                           tphs_active_flag,
                                                           tphs_description,
                                                           tphs_phase_status,
                                                           tphs_works_category,
                                                           tphs_phase_type,
                                                           tphs_proposed_start_date,
                                                           tphs_est_end_date,
                                                           tphs_latest_start_date,
                                                           tphs_latest_end_date,
                                                           tphs_act_start_date,
                                                           tphs_act_end_date,
                                                           tphs_start_date,
                                                           tphs_end_date,
                                                           tphs_reinst_cat,
                                                           tphs_phase_id,
                                                           tphs_loc_description,
                                                           tphs_challenged,
                                                           tphs_agreed_s74_end_date,
                                                           tphs_ignore_challenge_flag,
                                                           tphs_cway_restrict_type
                                                            )
AS
   SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/Derby City/BRS7966/x_dcc_tma_works_active_phase.vw-arc   1.0   Apr 20 2012 08:18:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_dcc_tma_works_active_phase.vw  $
--       Date into PVCS   : $Date:   Apr 20 2012 08:18:26  $
--       Date fetched Out : $Modtime:   Apr 18 2012 08:48:52  $
--       Version          : $Revision:   1.0  $
--   :
-------------------------------------------------------------------------
--
-- writen by Aileen Heal for DCC as parot of BRS 7966 in April 2012
-- based upon v_tma_works_active_phase.vw  version 3.4 
--   :
-------------------------------------------------------------------------
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
          tphs_agreed_s74_end_date, tphs_ignore_challenge_flag,
          tphs_cway_restrict_type -- added by Aileen
     FROM tma_works, tma_phases
    WHERE twor_works_id = tphs_works_id AND tphs_active_flag = 'Y'
/
