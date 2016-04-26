CREATE OR REPLACE FORCE VIEW V_TMA_TRANSACTIONS_ALERT
(
   NOTICE_ID,
   SENT_OR_RECEIVED,
   NOTICE_STATUS,
   NOTICE_STATUS_NAME,
   SENDER_ORGANISATION_REFERENCE,
   SENDER_ORGANISATION_NAME,
   SENDER_DISTRICT_REFERENCE,
   SENDER_DISTRICT_NAME,
   NOTICE_TYPE,
   NOTICE_TYPE_DESCRIPTION,
   SENDER_CREATED_DATE,
   WORKS_REFERENCE,
   REVIEW_STATUS,
   CREATED_DATE,
   MODIFIED_DATE,
   CREATED_BY,
   MODIFIED_BY,
   NOTICE_SEQUENCE_NUMBER,
   WORKS_ID,
   PHASE_NUMBER,
   NOTICE_COMMENTS,
   EXTERNAL_REFERENCE,
   WORKS_CATEGORY,
   WORKS_CATEGORY_DESCRIPTION,
   LATEST_PHASE_STATUS,
   LOCATION_DESCRIPTION,
   PROPOSED_START_DATE,
   ESTIMATED_END_DATE,
   ACTUAL_START_DATE,
   START_TIME,
   ACTUAL_END_DATE,
   WORKING_HOURS,
   CARRIAGEWAY_RESTRICTION,
   FOOTWAY_CLOSURE,
   PARKING_SUSPENSIONS,
   ESTIMATED_INSPECTION_UNITS,
   ACTUAL_INSPECTION_UNITS,
   PROMOTER_NAME,
   PROMOTER_ADDRESS1,
   PROMOTER_ADDRESS2,
   PROMOTER_ADDRESS3,
   PROMOTER_ADDRESS4,
   PROMOTER_ADDRESS5,
   PROMOTER_POSTCODE,
   PROMOTER_TELNO,
   CONTRACTOR_NAME,
   CONTRACTOR_ADDRESS1,
   CONTRACTOR_ADDRESS2,
   CONTRACTOR_ADDRESS3,
   CONTRACTOR_ADDRESS4,
   CONTRACTOR_ADDRESS5,
   CONTRACTOR_POSTCODE,
   CONTRACTOR_TELNO,
   REVIEW_BY,
   REVIEW_DATIM,
   REVIEW_TEXT,
   REVIEW_REQUIRED,
   ORGANISATION_REFERENCE,
   ORGANISATION_NAME,
   ORGANISATION_PREFIX,
   PROCESSING_SEQUENCE,
   STATUS_CONTEXT_MESSAGE,
   TIMEOUT_DEADLINE,
   TRANSACTION_COMMENTS,
   ASSIGNED_TO,
   FORWARD_STATUS,
   STREET_NAME,
   STREET_TOWN,
   STREET_LOCALITY
)
AS
   SELECT -----------------------------------------------------------------------------------
          -- Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
          -----------------------------------------------------------------------------------
          ttra.ttra_notice_id,
          ttra.ttra_sent_received,
          ttra.ttra_notice_status,
          (SELECT hc.hco_meaning
             FROM hig_codes hc
            WHERE     hc.hco_domain = 'NOTICE_STATUS'
                  AND hc.hco_code = ttra.ttra_notice_status),
          ttra.ttra_sender_org_ref,
          (SELECT nog.org_name
             FROM nsg_organisations nog
            WHERE nog.org_ref = ttra.ttra_sender_org_ref),
          ttra.ttra_sender_dist_ref,
          (SELECT nd.dist_name
             FROM nsg_districts nd
            WHERE     nd.dist_org_ref = ttra.ttra_sender_org_ref
                  AND nd.dist_ref = ttra.ttra_sender_dist_ref),
          ttra.ttra_notice_type,
          (SELECT tnt.tnty_description
             FROM tma_notice_types tnt
            WHERE tnt.tnty_notice_type = ttra.ttra_notice_type),
          ttra.ttra_created_datim,
          ttra.ttra_works_ref,
          ttra.ttra_review_status,
          ttra.ttra_date_created,
          ttra.ttra_date_modified,
          ttra.ttra_created_by,
          ttra.ttra_modified_by,
          ttra.ttra_notice_seq,
          ttra.ttra_works_id,
          ttra.ttra_phase_no,
          ttra.ttra_comments,
          twor.twor_external_ref,
          tphs.tphs_works_category,
          (SELECT twc.twca_description
             FROM tma_works_categories twc
            WHERE twc.twca_works_category = tphs.tphs_works_category),
          (SELECT hc.hco_meaning
             FROM hig_codes hc
            WHERE     hc.hco_domain = 'PHASE_STATUS'
                  AND hc.hco_code = tphs.tphs_phase_status),
          tphs.tphs_loc_description,
          tphs.tphs_proposed_start_date,
          tphs.tphs_est_end_date,
          tphs.tphs_act_start_date,
          tphs.tphs_start_time,
          tphs.tphs_act_end_date,
          tphs.tphs_working_hours,
          tphs.tphs_cway_restrict_type,
          tphs.tphs_fway_closure,
          tphs.tphs_parking_suspensions,
          tphs.tphs_est_insp_units,
          tphs.tphs_act_insp_units,
          tphs.tphs_promoter_name,
          tphs.tphs_promoter_address1,
          tphs.tphs_promoter_address2,
          tphs.tphs_promoter_address3,
          tphs.tphs_promoter_address4,
          tphs.tphs_promoter_address5,
          tphs.tphs_promoter_postcode,
          tphs.tphs_promoter_telno,
          tphs.tphs_contractor_name,
          tphs.tphs_contractor_address1,
          tphs.tphs_contractor_address2,
          tphs.tphs_contractor_address3,
          tphs.tphs_contractor_address4,
          tphs.tphs_contractor_address5,
          tphs.tphs_contractor_postcode,
          tphs.tphs_contractor_telno,
          ttra.ttra_review_by,
          ttra.ttra_review_datim,
          ttra.ttra_review_text,
          ttra.ttra_review_required,
          ttra.ttra_organisation_ref,
          ttra.ttra_organisation_name,
          ttra.ttra_organisation_prefix,
          ttra.ttra_processing_seq,
          ttra.ttra_status_context_message,
          ttra.ttra_timeout_deadline,
          ttra.ttra_transaction_comments,
          ttra.ttra_assigned_to,
          ttra.ttra_fwd_status,
          vstr.str_descr,
          vstr.str_town,
          vstr.str_locality
     FROM tma_phases tphs,
          tma_works twor,
          tma_transactions ttra,
          v_tma_streets_all vstr
    WHERE     tphs.tphs_active_flag = 'Y'
          AND tphs.tphs_works_id = twor.twor_works_id
          AND twor.twor_works_ref = ttra.ttra_works_ref
          AND twor.twor_str_ne_id = vstr.str_ne_id
     AND TRUNC (TTRA.TTRA_DATE_CREATED) >= TRUNC(SYSDATE-7)
   WITH READ ONLY;





CREATE OR REPLACE VIEW V_X_TMA_INSP_ALERT
(INSPECTION_ID,
INSPECTION_TYPE, 
INSPECTION_TYPE_NAME,
INSPECTED_DATE_TIME,
INSPECTION_CREATED_DATE,
MODIFIED_DATE,
RESULT_NUMBER,
INSPECTOR_NAME,
CATEGORY_TYPE,
CATEGORY_TYPE_NAME,
OUTCOME_TYPE,
OUTCOME_TYPE_NAME,
PRIVATE_COMMENTS,
NOTICE_COMMENTS,
ORGANISATION_REF_OWNER_NAME,
WORKS_REFERENCE,
PHASE_NUMBER,
PHASE_LOCATION,
CONTRACTOR_NAME,
PROMOTER_NAME,
INSPECTED_SITES,
UNACCEPTABLE_DEFECT_LINES
)
AS SELECT
  --
  ------------------------------------------------------------------
  --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --   Created by Lee Jackson 24/03/2016 
  ------------------------------------------------------------------ 
  --
imfi.inspection_id,
imfi.inspection_type, 
imfi.inspection_type_name,
imfi.inspection_date_time,
imfi.created_date,
Imfi.modified_date,
imfi.result_number,
imfi.inspector_name,
imfi.category_type,
imfi.category_type_name,
imfi.outcome_type,
imfi.outcome_type_name,
imfi.comments,
tma_inspections_api.get_notice_comments(imfw.works_reference, imfi.result_number),
imfi.organisation_ref_owner_name,
imfw.works_reference,
imfi.phase_number,
imfp.location_description,
imfp.contractor_name,
imfp.promoter_name,
x_tma_insp_sites(imfi.inspection_id) inspected_sites,
x_tma_insp_lines(imfi.inspection_id) unacceptable_defect_lines
FROM imf_tma_inspection_results imfi, imf_tma_works imfw, imf_tma_phases imfp
WHERE TRUNC (imfi.created_date) >= TRUNC(SYSDATE-7)
AND imfi.works_id = imfw.works_id
AND imfi.works_id = imfp.works_id
AND imfi.phase_number = imfp.phase_number




CREATE OR REPLACE FUNCTION X_TMA_INSP_LINES(pi_inspection_id IN  imf_tma_insp_result_lines.inspection_id%TYPE)
  RETURN nm3type.max_varchar2 IS
  --
    ------------------------------------------------------------------
  --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --   Created by Lee Jackson 24/03/2016 
    ------------------------------------------------------------------ 
  --
  TYPE tab_maxvarchar2 IS TABLE OF nm3type.max_varchar2;
  lt_values  tab_maxvarchar2;
  --
  lv_retval  nm3type.max_varchar2;
  --
BEGIN
  --
  SELECT  'Site Number = '||site_number||CHR(13)||CHR(10)|| 'Failed Item Type = '||item_type_name ||CHR(13)||CHR(10)||'Failed Item Reason = '||defect_reason_text||CHR(13)||CHR(10)||CHR(13)||CHR(10)
    BULK COLLECT
    INTO lt_values
    FROM imf_tma_insp_result_lines 
   WHERE inspection_id =pi_inspection_id 
     AND status_type = '2'
       ;
  --
  FOR i IN 1..lt_values.COUNT LOOP
    --
    IF length(lv_retval) > 4000-length(lt_values(i))
     THEN
        EXIT;
    END IF;
    --
    lv_retval := lv_retval||lt_values(i);
    --
  END LOOP;
  --
  RETURN lv_retval;
  --
END;




CREATE OR REPLACE FUNCTION X_TMA_INSP_SITES(pi_inspection_id IN  imf_tma_insp_result_sites.inspection_id%TYPE)
  RETURN nm3type.max_varchar2 IS
  --
  ------------------------------------------------------------------
  --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --   Created by Lee Jackson 24/03/2016 
  ------------------------------------------------------------------ 
  --
  TYPE tab_maxvarchar2 IS TABLE OF nm3type.max_varchar2;
  lt_values  tab_maxvarchar2;
  --
  lv_retval  nm3type.max_varchar2;
  --
BEGIN
  --
  SELECT  'Site Number = '||site_number||CHR(13)||CHR(10)|| 'Site Comment = '||site_comment_text||CHR(13)||CHR(10)||'Site Location Text = '||site_location_text||CHR(13)||CHR(10)||CHR(13)||CHR(10)
    BULK COLLECT
    INTO lt_values
    FROM imf_tma_insp_result_sites 
   WHERE inspection_id =pi_inspection_id 
       ;
  --
  FOR i IN 1..lt_values.COUNT LOOP
    --
        IF length(lv_retval) > 4000-length(lt_values(i))
     THEN
        EXIT;
    END IF;
    --
    lv_retval := lv_retval||lt_values(i);
    --
  END LOOP;
  --
  RETURN lv_retval;
  --
END;




CREATE OR REPLACE VIEW V_X_TMA_INSP_ALERT_MOD_CHK
(INSPECTION_ID,
INSPECTION_TYPE, 
INSPECTION_TYPE_NAME,
INSPECTED_DATE_TIME,
INSPECTION_CREATED_DATE,
MODIFIED_DATE,
RESULT_NUMBER,
INSPECTOR_NAME,
CATEGORY_TYPE,
CATEGORY_TYPE_NAME,
OUTCOME_TYPE,
OUTCOME_TYPE_NAME,
PRIVATE_COMMENTS,
NOTICE_COMMENTS,
ORGANISATION_REF_OWNER_NAME,
WORKS_REFERENCE,
PHASE_NUMBER,
PHASE_LOCATION,
CONTRACTOR_NAME,
PROMOTER_NAME,
INSPECTED_SITES,
UNACCEPTABLE_DEFECT_LINES
)
AS SELECT
  --
  ------------------------------------------------------------------
  --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --   Created by Lee Jackson 24/03/2016 
  ------------------------------------------------------------------ 
  --
imfi.inspection_id,
imfi.inspection_type, 
imfi.inspection_type_name,
imfi.inspection_date_time,
imfi.created_date,
Imfi.modified_date,
imfi.result_number,
imfi.inspector_name,
imfi.category_type,
imfi.category_type_name,
imfi.outcome_type,
imfi.outcome_type_name,
imfi.comments,
tma_inspections_api.get_notice_comments(imfw.works_reference, imfi.result_number),
imfi.organisation_ref_owner_name,
imfw.works_reference,
imfi.phase_number,
imfp.location_description,
imfp.contractor_name,
imfp.promoter_name,
x_tma_insp_sites(imfi.inspection_id) inspected_sites,
x_tma_insp_lines(imfi.inspection_id) unacceptable_defect_lines
FROM imf_tma_inspection_results imfi, imf_tma_works imfw, imf_tma_phases imfp
WHERE TRUNC (imfi.created_date) >= TRUNC(SYSDATE-7)
AND imfi.works_id = imfw.works_id
AND imfi.works_id = imfp.works_id
AND imfi.phase_number = imfp.phase_number
AND TRUNC(imfi.created_date) <> TRUNC(imfi.modified_date)

