CREATE OR REPLACE FORCE VIEW x_dcc_tma_wks_active_phs_dets (twor_works_id,
                                                                  twor_works_ref,
                                                                  twor_org_ref,
                                                                  twor_dist_ref,
                                                                  twor_no_of_phases,
                                                                  twor_str_ne_id,
                                                                  twor_actual_works_ref,
                                                                  twor_licence_id,
                                                                  twor_external_ref,
                                                                  org_name,
                                                                  org_prefix,
                                                                  dist_name,
                                                                  dist_prefix,
                                                                  str_usrn,
                                                                  str_descr,
                                                                  str_locality,
                                                                  str_town,
                                                                  str_county,
                                                                  str_provisional_street_flag,
                                                                  tphs_active_flag,
                                                                  tphs_phase_no,
                                                                  tphs_description,
                                                                  tphs_phase_status,
                                                                  tphs_works_category,
                                                                  twca_description,
                                                                  tphs_phase_type,
                                                                  phase_type_meaning,
                                                                  tphs_proposed_start_date,
                                                                  tphs_est_end_date,
                                                                  tphs_latest_start_date,
                                                                  tphs_latest_end_date,
                                                                  tphs_act_start_date,
                                                                  tphs_act_end_date,
                                                                  tphs_start_date,
                                                                  tphs_end_date,
                                                                  phase_status_meaning,
                                                                  tphs_reinst_cat,
                                                                  tphs_phase_id,
                                                                  tphs_loc_description,
                                                                  tphs_challenged,
                                                                  tphs_cway_restrict_type,
                                                                  tphs_cway_restrict_meaning
                                                                  )
AS
   SELECT
------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/Derby City/BRS7966/x_dcc_tma_wks_active_phs_dets.vw-arc   1.0   Apr 20 2012 08:18:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_dcc_tma_wks_active_phs_dets.vw  $
--       Date into PVCS   : $Date:   Apr 20 2012 08:18:26  $
--       Date fetched Out : $Modtime:   Apr 18 2012 08:48:40  $
--       Version          : $Revision:   1.0  $
--   :
-------------------------------------------------------------------------
--
-- writen by Aileen Heal for DCC as parot of BRS 7966 in April 2012
-- based upon v_tma_works_active_phase_dets.vw  version 3.5
--   :
-------------------------------------------------------------------------
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
          tphs_challenged, 
          tphs_cway_restrict_type, -- Added by Aileen
          hig_codes3.hco_meaning tphs_cway_restrict_meaning -- Added by Aileen
     FROM x_dcc_tma_works_active_phase,
          nsg_organisations,
          nsg_districts,
--          v_tma_streets_all,
          v_tma_streets,                        -- join to the restricted view
          tma_works_categories,
          hig_codes hig_codes1,
          hig_codes hig_codes2,
          hig_codes hig_codes3 
    WHERE twor_org_ref = org_ref
      AND twor_dist_ref = dist_ref
      AND org_ref = dist_org_ref
      AND twor_str_ne_id = str_ne_id
      AND tphs_works_category = twca_works_category
      AND tphs_phase_type = hig_codes1.hco_code
      AND hig_codes1.hco_domain = 'PHASE_TYPE'
      AND tphs_phase_status = hig_codes2.hco_code
      AND hig_codes2.hco_domain = 'PHASE_STATUS'
      AND tphs_cway_restrict_type = hig_codes3.hco_code 
      AND hig_codes3.hco_domain = 'PHASE_CWAY_RESTRICT'
/      
      
