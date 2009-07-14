CREATE OR REPLACE FORCE VIEW v_wag_tpc_template
(
   doc_id
 , hct_title
 , hct_first_name
 , hct_surname
 , had_postcode
 , had_building_no
 , had_building_name
 , had_sub_building_name_no
 , had_thoroughfare
 , had_dependent_thoroughfare
 , had_dependent_locality_name
 , had_post_town
 , had_county
 , hus_initials
 , hus_name
 , doc_compl_incident_date
 , doc_compl_location
 , wag_tpc_incident_id
 , wag_tpc_site_inspected
 , wag_tpc_other_similar_claim
 , wag_tpc_other_claim_site
 , wag_tpc_site_ins_notes
 , wag_tpc_other_claim_site_notes
 , wag_tpc_other_sim_claim_notes
 , ne_id
 , date_inspected
 , insp_freq
)
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/view/v_wag_tpc_template.vw-arc   3.1   Jul 14 2009 08:50:52   smarshall  $
--       Module Name      : $Workfile:   v_wag_tpc_template.vw  $
--       Date into PVCS   : $Date:   Jul 14 2009 08:50:52  $
--       Date fetched Out : $Modtime:   Jul 13 2009 15:40:44  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------
  SELECT doc_id, hct_title, hct_first_name, hct_surname, had_postcode,
          had_building_no, had_building_name, had_sub_building_name_no,
          had_thoroughfare, had_dependent_thoroughfare,
          had_dependent_locality_name, had_post_town, had_county,
          hus_initials, hus_name, doc_compl_incident_date, doc_compl_location,
          tpc_insp.wag_tpc_incident_id, tpc_insp.wag_tpc_site_inspected,
          tpc_insp.wag_tpc_other_similar_claim, tpc_insp.wag_tpc_other_claim_site,
          tpc_insp.wag_tpc_site_ins_notes, tpc_insp.wag_tpc_other_claim_site_notes,
          tpc_insp.wag_tpc_other_sim_claim_notes
          ,das_rec_id ne_id         
          ,last_inspection rse_last_inspected   
          ,int_descr
     FROM hig_contacts,
          docs,
          doc_enquiry_contacts,
          hig_contact_address,
          hig_address,
          hig_users,
          wag_tpc_incident tpc_inc,
          wag_tpc_inspections tpc_insp
          ,doc_assocs
          ,road_sections,    
          (SELECT are_rse_he_id, MAX (are_date_work_done) AS last_inspection
         FROM activities_report, doc_assocs, docs
         WHERE     das_table_name = 'ROAD_SEGMENTS_ALL'
               AND das_doc_id = doc_id
               AND das_rec_id = are_rse_he_id
               AND are_date_work_done < doc_compl_incident_date
         GROUP BY are_rse_he_id) last_inspection
          ,intervals
    WHERE doc_id = dec_doc_id
         AND dec_hct_id = hct_id
         AND hct_id = hca_hct_id
         AND hca_had_id = had_id
         AND doc_user_id = hus_user_id
         AND doc_id = tpc_inc.wag_tpc_incident_id(+)
         AND doc_id = tpc_insp.wag_tpc_incident_id(+)
         AND doc_id = das_doc_id
         AND das_table_name = 'ROAD_SEGMENTS_ALL'
         AND das_rec_id = rse_he_id
         AND rse_he_id = are_rse_he_id
         AND int_code = rse_int_code
         AND das_rec_id = are_rse_he_id
/