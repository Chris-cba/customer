DROP VIEW ATLAS.X_DCC_TMA_COMPLETED_PHASES_PT;

/* Formatted on 2012/04/18 12:53 (Formatter Plus v4.8.8) */
--
-- X_DCC_TMA_COMPLETED_PHASES_PT  (View) 
--
CREATE OR REPLACE FORCE VIEW atlas.x_dcc_tma_completed_phases_pt (twor_works_id,
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
                                                                  tphs_cway_restrict_meaning,
                                                                  tpps_tphs_id,
                                                                  tpps_tphs_geometry,
                                                                  tpps_tphs_feature_type
                                                                 )
AS
   SELECT a."TWOR_WORKS_ID", a."TWOR_WORKS_REF", a."TWOR_ORG_REF",
          a."TWOR_DIST_REF", a."TWOR_NO_OF_PHASES", a."TWOR_STR_NE_ID",
          a."TWOR_ACTUAL_WORKS_REF", a."TWOR_LICENCE_ID",
          a."TWOR_EXTERNAL_REF", a."ORG_NAME", a."ORG_PREFIX", a."DIST_NAME",
          a."DIST_PREFIX", a."STR_USRN", a."STR_DESCR", a."STR_LOCALITY",
          a."STR_TOWN", a."STR_COUNTY", a."STR_PROVISIONAL_STREET_FLAG",
          a."TPHS_ACTIVE_FLAG", a."TPHS_PHASE_NO", a."TPHS_DESCRIPTION",
          a."TPHS_PHASE_STATUS", a."TPHS_WORKS_CATEGORY",
          a."TWCA_DESCRIPTION", a."TPHS_PHASE_TYPE", a."PHASE_TYPE_MEANING",
          a."TPHS_PROPOSED_START_DATE", a."TPHS_EST_END_DATE",
          a."TPHS_LATEST_START_DATE", a."TPHS_LATEST_END_DATE",
          a."TPHS_ACT_START_DATE", a."TPHS_ACT_END_DATE", a."TPHS_START_DATE",
          a."TPHS_END_DATE", a."PHASE_STATUS_MEANING", a."TPHS_REINST_CAT",
          a."TPHS_PHASE_ID", a."TPHS_LOC_DESCRIPTION", a."TPHS_CHALLENGED",
          a."TPHS_CWAY_RESTRICT_TYPE", a."TPHS_CWAY_RESTRICT_MEANING",
          a."TPPS_TPHS_ID", a."TPPS_TPHS_GEOMETRY",
          a."TPPS_TPHS_FEATURE_TYPE"
     FROM x_dcc_tma_phases_pt_sdo a
    WHERE tphs_phase_status IN
               ('WORKS_COMPLETE', 'WORKS_COMPLETE_EX', 'WORKS_COMPLETE_NOEX');


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON ATLAS.X_DCC_TMA_COMPLETED_PHASES_PT TO SDE;

