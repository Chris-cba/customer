CREATE OR REPLACE FORCE VIEW V_WAG_TPC_TEMPLATE (DOC_ID, HCT_TITLE, HCT_FIRST_NAME, HCT_SURNAME, HAD_POSTCODE, HAD_BUILDING_NO, HAD_BUILDING_NAME, HAD_SUB_BUILDING_NAME_NO, HAD_THOROUGHFARE, HAD_DEPENDENT_THOROUGHFARE, HAD_DEPENDENT_LOCALITY_NAME, HAD_POST_TOWN, HAD_COUNTY, HUS_INITIALS, HUS_NAME, DOC_COMPL_INCIDENT_DATE, DOC_COMPL_LOCATION, WAG_TPC_INCIDENT_ID, WAG_TPC_SITE_INSPECTED, WAG_TPC_OTHER_SIMILAR_CLAIM, WAG_TPC_OTHER_CLAIM_SITE, WAG_TPC_SITE_INS_NOTES, WAG_TPC_OTHER_CLAIM_SITE_NOTES, WAG_TPC_OTHER_SIM_CLAIM_NOTES, NE_ID, DATE_INSPECTED, INSP_FREQ)
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/view/v_wag_tpc_template.vw-arc   3.2   Dec 01 2011 10:00:50   Ian.Turnbull  $
--       Module Name      : $Workfile:   v_wag_tpc_template.vw  $
--       Date into PVCS   : $Date:   Dec 01 2011 10:00:50  $
--       Date fetched Out : $Modtime:   Dec 01 2011 09:57:56  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
  SELECT doc_id,
    hct_title,
    hct_first_name,
    hct_surname,
    had_postcode,
    had_building_no,
    had_building_name,
    had_sub_building_name_no,
    had_thoroughfare,
    had_dependent_thoroughfare,
    had_dependent_locality_name,
    had_post_town,
    had_county,
    hus_initials,
    hus_name,
    doc_compl_incident_date,
    doc_compl_location,
    tpc_insp.wag_tpc_incident_id,
    tpc_insp.wag_tpc_site_inspected,
    tpc_insp.wag_tpc_other_similar_claim,
    tpc_insp.wag_tpc_other_claim_site,
    tpc_insp.wag_tpc_site_ins_notes,
    tpc_insp.wag_tpc_other_claim_site_notes,
    tpc_insp.wag_tpc_other_sim_claim_notes ,
    das_rec_id ne_id ,
    (SELECT MAX (are_date_work_done) AS last_inspection
    FROM activities_report,
      doc_assocs
    WHERE das_table_name   = 'ROAD_SEGMENTS_ALL'
    AND das_doc_id         = doc_id
    AND das_rec_id         = are_rse_he_id
    AND are_date_work_done < doc_compl_incident_date
    ) RSE_LAST_INSPECTED ,
    (select nvl(min(int_translation),'Not Set')
from section_freqs,
     INTERVALS
where sfr_rse_he_id = das_rec_id
AND   SFR_ATV_ACTY_AREA_CODE = 'SI'
and   sfr_int_code = int_code)int_descr
  FROM hig_contacts,
    docs,
    doc_enquiry_contacts,
    hig_contact_address,
    hig_address,
    hig_users,
    wag_tpc_incident tpc_inc,
    wag_tpc_inspections tpc_insp ,
    doc_assocs ,
    road_sections,
    (SELECT are_rse_he_id,
      MAX (are_date_work_done) AS last_inspection
    FROM activities_report,
      doc_assocs,
      docs
    WHERE das_table_name   = 'ROAD_SEGMENTS_ALL'
    AND das_doc_id         = doc_id
    AND das_rec_id         = are_rse_he_id
    AND are_date_work_done < doc_compl_incident_date
    GROUP BY are_rse_he_id
    ) last_inspection ,
    intervals
  WHERE doc_id       = dec_doc_id
  AND dec_hct_id     = hct_id
  AND hct_id         = hca_hct_id
  AND hca_had_id     = had_id
  AND doc_user_id    = hus_user_id
  AND doc_id         = tpc_inc.wag_tpc_incident_id(+)
  AND doc_id         = tpc_insp.wag_tpc_incident_id(+)
  AND doc_id         = das_doc_id
  AND das_table_name = 'ROAD_SEGMENTS_ALL'
  AND das_rec_id     = rse_he_id
  AND rse_he_id      = are_rse_he_id
  AND INT_CODE       = RSE_INT_CODE
  AND DAS_REC_ID     = ARE_RSE_HE_ID
  ;