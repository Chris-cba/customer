CREATE SEQUENCE X_im511001_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE X_im511002_seq
START WITH 1
INCREMENT BY 1;

CREATE SEQUENCE X_im511003_seq
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE VIEW XIMF_MAI_WORK_ORDER_LINES
(
   WORK_ORDER_LINE_ID,
   WORK_ORDER_NUMBER,
   LOCATION_DESCRIPTION,
   NETWORK_ELEMENT_ID,
   STANDARD_ITEM_SUB_SECTION_ID,
   STANDARD_ITEM_SUB_SECTION_DESC,
   WORK_CATEGORY,
   WORK_CATEGORY_DESCRIPTION,
   AGENCY_CODE,
   AGENCY_CODE_DESCRIPTION,
   DEFECT_ID,
   DEFECT_TYPE,
   DEFECT_TYPE_DESCRIPTION,
   DEFECT_PRIORITY,
   DEFECT_PRIORITY_DESCRIPTION,
   DEFECT_ASSET_TYPE,
   DEFECT_ASSET_ID,
   REPAIR_CATEGORY,
   REPAIR_CATEGORY_DESCRIPTION,
   SCHEDULE_ID,
   SCHEDULE_DESCRIPTION,
   WORKSHEET,
   REGISTER,
   REGISTER_STATUS,
   REGISTER_STATUS_DESCRIPTION,
   CONTRACT_PAYMENTS_ID,
   ACTIVITY_CODE,
   ACTIVITY_DESCRIPTION,
   TREATMENT_CODE,
   TREATMENT_DESCRIPTION,
   ESTIMATED_COST,
   LABOUR_UNITS,
   ACTUAL_COST,
   REMARKS,
   DATE_CREATED,
   DAYS_SINCE_CREATED,
   DATE_REPAIRED,
   DAYS_SINCE_REPAIRED,
   DATE_COMPLETED,
   DAYS_SINCE_COMPLETED,
   DATE_PAID,
   DAYS_SINCE_PAID,
   PAYMENT_CODE,
   WORK_ORDER_LINE_STATUS,
   WORK_ORDER_LINE_STATUS_DESCR,
   INVOICE_STATUS,
   INVOICE_STATUS_DESCRIPTION,
   BUDGET_ID
)
AS
   SELECT -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/POD_process/wowt/install/views_tables.sql-arc   1.0   Jan 14 2016 19:46:14   Sarah.Williams  $
          --       Module Name      : $Workfile:   views_tables.sql  $
          --       Date into PVCS   : $Date:   Jan 14 2016 19:46:14  $
          --       Date fetched Out : $Modtime:   Oct 20 2011 11:08:40  $
          --       Version          : $Revision:   1.0  $
          -- Foundation view displaying maintenance manager work order lines
          -------------------------------------------------------------------------
          -- SM 03042009
          -- Added rowid=1 to ICB inline sql to cater for ICBFGAC product option
          -- SM 28052009
          -- Added icb_agency_code and hau_name (agency_code_descr)
          -------------------------------------------------------------------------
          wol.wol_id work_order_line_id,
          wol.wol_works_order_no work_order_number,
          NVL (def.def_locn_descr, wol.wol_locn_descr) location_description,
          wol.wol_rse_he_id network_element_id,
          wol.wol_siss_id standard_item_sub_section_id,
          (SELECT siss_name
             FROM standard_item_sub_sections
            WHERE siss_id = wol.wol_siss_id)
             standard_item_sub_section_desc,
          wol.wol_icb_work_code work_category,
          (SELECT icb_work_category_name
             FROM budgets, item_code_breakdowns
            WHERE     icb_dtp_flag = bud_sys_flag
                  AND icb_agency_code = bud_agency
                  AND icb_item_code = bud_icb_item_code
                  AND icb_sub_item_code = bud_icb_sub_item_code
                  AND icb_sub_sub_item_code = bud_icb_sub_sub_item_code
                  AND bud_id = wol.wol_bud_id)
             work_category_description,
          (SELECT bud_agency
             FROM budgets
            WHERE bud_id = wol.wol_bud_id)
             agency_code,
          (SELECT hau_name
             FROM hig_admin_units
            WHERE hau_authority_code = (SELECT bud_agency
                                          FROM budgets
                                         WHERE bud_id = wol.wol_bud_id))
             agency_code_description,
          wol.wol_def_defect_id defect_id,
          def.def_defect_code defect_type,
          (SELECT dty_descr1
             FROM def_types
            WHERE     dty_defect_code = def.def_defect_code
                  AND dty_atv_acty_area_code = def.def_atv_acty_area_code
                  AND dty_dtp_flag = def.def_ity_sys_flag)
             defect_type_description,
          def.def_priority defect_priority,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'DEFECT_PRIORITIES'
                  AND hco_code = def.def_priority)
             defect_priority_description,
          (SELECT nit_inv_type
             FROM inv_type_translations
            WHERE ity_inv_code = def.def_ity_inv_code)
             defect_asset_type,
          def.def_iit_item_id defect_asset_id,
          wol.wol_rep_action_cat repair_category,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'REPAIR_TYPE'
                  AND hco_code = wol.wol_rep_action_cat)
             repair_category_description,
          wol.wol_schd_id schedule_id,
          (SELECT schd_name
             FROM schedules
            WHERE schd_id = wol.wol_schd_id)
             schedule_description,
          wol.wol_work_sheet_no worksheet,
          wol.wol_register_flag register,
          DECODE (
             wol.wol_register_flag,
             'N', NULL,
             mai.determine_reg_status_for_flag (wol.wol_works_order_no,
                                                wol.wol_register_flag,
                                                wol.wol_id))
             register_status,
          DECODE (
             wol.wol_register_flag,
             'N', NULL,
             (SELECT hco_meaning
                FROM hig_codes
               WHERE hco_domain = 'WOR_REGISTER_STATUS'
                     AND hco_code =
                            mai.determine_reg_status_for_flag (
                               wol.wol_works_order_no,
                               wol.wol_register_flag,
                               wol.wol_id)))
             register_status_description,
          wol.wol_cnp_id contract_payments_id,
          wol.wol_act_area_code activity_code,
          (SELECT atv_descr
             FROM activities
            WHERE atv_acty_area_code = wol.wol_act_area_code
                  AND atv_dtp_flag =
                         (SELECT wor_sys_flag
                            FROM work_orders
                           WHERE wor_works_order_no = wol.wol_works_order_no))
             activity_description,
          DECODE (
             wol.wol_flag,
             'S', wol.wol_ss_tre_treat_code,
             (SELECT rep_tre_treat_code
                FROM repairs
               WHERE rep_def_defect_id = wol.wol_def_defect_id
                     AND rep_action_cat = wol.wol_rep_action_cat))
             treatment_code,
          (SELECT tre_descr
             FROM treatments
            WHERE tre_treat_code =
                     DECODE (
                        wol.wol_flag,
                        'S', wol.wol_ss_tre_treat_code,
                        (SELECT rep_tre_treat_code
                           FROM repairs
                          WHERE rep_def_defect_id = wol.wol_def_defect_id
                                AND rep_action_cat = wol.wol_rep_action_cat)))
             treatment_description,
          wol.wol_est_cost estimated_cost,
          wol.wol_est_labour labour_units,
          wol.wol_act_cost actual_cost,
          wol.wol_descr remarks,
          wol.wol_date_created date_created,
          TRUNC (SYSDATE) - TRUNC (wol.wol_date_created) days_since_created,
          wol.wol_date_repaired date_repaired,
          TRUNC (SYSDATE) - TRUNC (wol.wol_date_repaired) days_since_repaired,
          wol.wol_date_complete date_completed,
          TRUNC (SYSDATE) - TRUNC (wol.wol_date_complete)
             days_since_completed,
          wol.wol_date_paid date_paid,
          TRUNC (SYSDATE) - TRUNC (wol.wol_date_paid) days_since_paid,
          wol.wol_payment_code payment_code,
          wol.wol_status_code work_order_line_status,
          (SELECT hsc_status_name
             FROM hig_status_codes
            WHERE hsc_domain_code = 'WORK_ORDER_LINES'
                  AND hsc_status_code = wol.wol_status_code)
             work_order_line_status_descr,
          wol.wol_invoice_status invoice_status,
          DECODE (wol.wol_invoice_status,
                  'B', 'Both Held and Outstanding Invoices exist',
                  'O', 'Oustanding Invoice exists',
                  'H', 'Held Invoice exists',
                  'A', 'All Invoices have been Paid')
             invoice_status_description,
          wol.wol_bud_id budget_id
     FROM defects def, work_order_lines wol
    WHERE wol.wol_def_defect_id = def.def_defect_id(+)
          AND (NOT EXISTS
                  (SELECT 1
                     FROM mai_wo_users
                    WHERE mwu_user_id = nm3user.get_user_id)
               OR wol.wol_works_order_no IN
                     (SELECT wor_works_order_no
                        FROM work_orders
                       WHERE wor_forwarded_to = nm3user.get_user_id
                      UNION
                      SELECT wol_works_order_no
                        FROM work_order_lines wol
                       WHERE (EXISTS
                                 (SELECT 1
                                    FROM mai_wo_users
                                   WHERE mwu_user_id = nm3user.get_user_id
                                         AND mwu_restrict_by_workcode = 'N')
                              OR wol.wol_bud_id IN
                                    (SELECT bud_id
                                       FROM budgets, mai_wo_user_work_codes
                                      WHERE mwuw_user_id =
                                               nm3user.get_user_id
                                            AND mwuw_icb_item_code =
                                                   bud_icb_item_code
                                            AND NVL (mwuw_icb_sub_item_code,
                                                     bud_icb_sub_item_code) =
                                                   bud_icb_sub_item_code
                                            AND NVL (
                                                   mwuw_icb_sub_sub_item_code,
                                                   bud_icb_sub_sub_item_code) =
                                                   bud_icb_sub_sub_item_code))
                             AND (EXISTS
                                     (SELECT 1
                                        FROM mai_wo_users
                                       WHERE mwu_user_id =
                                                nm3user.get_user_id
                                             AND mwu_restrict_by_road_group =
                                                    'N')
                                  OR wol_rse_he_id IN
                                        (    SELECT nm_ne_id_of
                                               FROM nm_members
                                              WHERE nm_type = 'G'
                                         CONNECT BY PRIOR nm_ne_id_of =
                                                       nm_ne_id_in
                                         START WITH nm_ne_id_in IN
                                                       (SELECT mwur_road_group_id
                                                          FROM mai_wo_user_road_groups
                                                         WHERE mwur_user_id =
                                                                  nm3user.get_user_id)
                                         UNION
                                         SELECT mwur_road_group_id
                                           FROM mai_wo_user_road_groups
                                          WHERE mwur_user_id =
                                                   nm3user.get_user_id))));


CREATE OR REPLACE VIEW XIMF_MAI_WORK_ORDERS_ALL_ATTR
(
   WORKS_ORDER_NUMBER,
   WORKS_ORDER_DESCRIPTION,
   WORKS_ORDER_STATUS,
   WORKS_ORDER_TYPE,
   WORKS_ORDER_TYPE_DESCRIPTION,
   INTERIM_PAYMENT,
   PRIORITY,
   PRIORITY_DESCRIPTION,
   NETWORK_ELEMENT_ID,
   SYS_FLAG,
   SYS_FLAG_DESCRIPTION,
   SCHEME_TYPE,
   SCHEME_TYPE_DESCRIPTION,
   REGISTER,
   REGISTER_STATUS,
   REGISTER_STATUS_DESCRIPTION,
   CONTRACT_ID,
   CONTRACT_CODE,
   CONTRACT_NAME,
   CONTRACTOR_ID,
   CONTRACTOR_CODE,
   CONTRACTOR_NAME,
   CONTACT,
   ORIGINATOR_ID,
   ORIGINATOR_INITIALS,
   ORIGINATOR_NAME,
   AUTHORISED_BY_ID,
   AUTHORISED_BY_INITIALS,
   AUTHORISED_BY_NAME,
   COST_CENTRE,
   JOB_NUMBER,
   RECHARGABLE,
   COST_RECHARGED,
   REMARKS,
   DATE_RAISED,
   DAYS_SINCE_RAISED,
   TARGET_DATE,
   DAYS_TO_TARGET_DATE,
   DATE_INSTRUCTED,
   DAYS_SINCE_INSTRUCTED,
   DATE_LAST_PRINTED,
   DATE_RECEIVED,
   DAYS_SINCE_RECEIVED,
   RECEIVED_BY_ID,
   RECEIVED_BY_INITIALS,
   RECEIVED_BY_NAME,
   DATE_COMPLETED,
   DAYS_SINCE_COMPLETED,
   ORDER_ESTIMATED_COST,
   ORDER_ESTIMATED_BALANCING_SUM,
   ORDER_ESTIMATED_TOTAL,
   LABOUR_UNITS,
   ORDER_ACTUAL_COST,
   ORDER_ACTUAL_BALANCING_SUM,
   ORDER_ACTUAL_TOTAL,
   WOR_NUM_ATTRIB01,
   WOR_NUM_ATTRIB02,
   WOR_NUM_ATTRIB03,
   WOR_NUM_ATTRIB04,
   WOR_NUM_ATTRIB05,
   WOR_NUM_ATTRIB06,
   WOR_NUM_ATTRIB07,
   WOR_NUM_ATTRIB08,
   WOR_NUM_ATTRIB09,
   WOR_NUM_ATTRIB10,
   WOR_NUM_ATTRIB11,
   WOR_NUM_ATTRIB12,
   WOR_NUM_ATTRIB13,
   WOR_NUM_ATTRIB14,
   WOR_NUM_ATTRIB15,
   WOR_NUM_ATTRIB16,
   WOR_NUM_ATTRIB17,
   WOR_NUM_ATTRIB18,
   WOR_NUM_ATTRIB19,
   WOR_NUM_ATTRIB20,
   WOR_NUM_ATTRIB21,
   WOR_NUM_ATTRIB22,
   WOR_NUM_ATTRIB23,
   WOR_NUM_ATTRIB24,
   WOR_NUM_ATTRIB25,
   WOR_NUM_ATTRIB26,
   WOR_NUM_ATTRIB27,
   WOR_NUM_ATTRIB28,
   WOR_NUM_ATTRIB29,
   WOR_NUM_ATTRIB30,
   WOR_NUM_ATTRIB31,
   WOR_NUM_ATTRIB32,
   WOR_NUM_ATTRIB33,
   WOR_NUM_ATTRIB34,
   WOR_NUM_ATTRIB35,
   WOR_NUM_ATTRIB36,
   WOR_NUM_ATTRIB37,
   WOR_NUM_ATTRIB38,
   WOR_NUM_ATTRIB39,
   WOR_NUM_ATTRIB40,
   WOR_NUM_ATTRIB41,
   WOR_NUM_ATTRIB42,
   WOR_NUM_ATTRIB43,
   WOR_NUM_ATTRIB44,
   WOR_NUM_ATTRIB45,
   WOR_NUM_ATTRIB46,
   WOR_NUM_ATTRIB47,
   WOR_NUM_ATTRIB48,
   WOR_NUM_ATTRIB49,
   WOR_NUM_ATTRIB50,
   WOR_NUM_ATTRIB51,
   WOR_NUM_ATTRIB52,
   WOR_NUM_ATTRIB53,
   WOR_NUM_ATTRIB54,
   WOR_NUM_ATTRIB55,
   WOR_NUM_ATTRIB56,
   WOR_NUM_ATTRIB57,
   WOR_NUM_ATTRIB58,
   WOR_NUM_ATTRIB59,
   WOR_NUM_ATTRIB60,
   WOR_CHAR_ATTRIB61,
   WOR_CHAR_ATTRIB62,
   WOR_CHAR_ATTRIB63,
   WOR_CHAR_ATTRIB64,
   WOR_CHAR_ATTRIB65,
   WOR_CHAR_ATTRIB66,
   WOR_CHAR_ATTRIB67,
   WOR_CHAR_ATTRIB68,
   WOR_CHAR_ATTRIB69,
   WOR_CHAR_ATTRIB70,
   WOR_CHAR_ATTRIB71,
   WOR_CHAR_ATTRIB72,
   WOR_CHAR_ATTRIB73,
   WOR_CHAR_ATTRIB74,
   WOR_CHAR_ATTRIB75,
   WOR_CHAR_ATTRIB76,
   WOR_CHAR_ATTRIB77,
   WOR_CHAR_ATTRIB78,
   WOR_CHAR_ATTRIB79,
   WOR_CHAR_ATTRIB80,
   WOR_CHAR_ATTRIB81,
   WOR_CHAR_ATTRIB82,
   WOR_CHAR_ATTRIB83,
   WOR_CHAR_ATTRIB84,
   WOR_CHAR_ATTRIB85,
   WOR_CHAR_ATTRIB86,
   WOR_CHAR_ATTRIB87,
   WOR_CHAR_ATTRIB88,
   WOR_CHAR_ATTRIB89,
   WOR_CHAR_ATTRIB90,
   WOR_CHAR_ATTRIB91,
   WOR_CHAR_ATTRIB92,
   WOR_CHAR_ATTRIB93,
   WOR_CHAR_ATTRIB94,
   WOR_CHAR_ATTRIB95,
   WOR_CHAR_ATTRIB96,
   WOR_CHAR_ATTRIB97,
   WOR_CHAR_ATTRIB98,
   WOR_CHAR_ATTRIB99,
   WOR_CHAR_ATTRIB100,
   WOR_CHAR_ATTRIB101,
   WOR_CHAR_ATTRIB102,
   WOR_CHAR_ATTRIB103,
   WOR_CHAR_ATTRIB104,
   WOR_CHAR_ATTRIB105,
   WOR_CHAR_ATTRIB106,
   WOR_CHAR_ATTRIB107,
   WOR_CHAR_ATTRIB108,
   WOR_CHAR_ATTRIB109,
   WOR_CHAR_ATTRIB110,
   WOR_CHAR_ATTRIB111,
   WOR_CHAR_ATTRIB112,
   WOR_CHAR_ATTRIB113,
   WOR_CHAR_ATTRIB114,
   WOR_CHAR_ATTRIB115,
   WOR_CHAR_ATTRIB116,
   WOR_CHAR_ATTRIB117,
   WOR_CHAR_ATTRIB118,
   WOR_CHAR_ATTRIB119,
   WOR_CHAR_ATTRIB120,
   WOR_DATE_ATTRIB121,
   WOR_DATE_ATTRIB122,
   WOR_DATE_ATTRIB123,
   WOR_DATE_ATTRIB124,
   WOR_DATE_ATTRIB125,
   WOR_DATE_ATTRIB126,
   WOR_DATE_ATTRIB127,
   WOR_DATE_ATTRIB128,
   WOR_DATE_ATTRIB129,
   WOR_DATE_ATTRIB130,
   WOR_DATE_ATTRIB131,
   WOR_DATE_ATTRIB132,
   WOR_DATE_ATTRIB133,
   WOR_DATE_ATTRIB134,
   WOR_DATE_ATTRIB135,
   WOR_DATE_ATTRIB136,
   WOR_DATE_ATTRIB137,
   WOR_DATE_ATTRIB138,
   WOR_DATE_ATTRIB139,
   WOR_DATE_ATTRIB140,
   WOR_DATE_ATTRIB141,
   WOR_DATE_ATTRIB142,
   WOR_DATE_ATTRIB143,
   WOR_DATE_ATTRIB144,
   WOR_DATE_ATTRIB145,
   WOR_DATE_ATTRIB146,
   WOR_DATE_ATTRIB147,
   WOR_DATE_ATTRIB148,
   WOR_DATE_ATTRIB149,
   WOR_DATE_ATTRIB150,
   WOR_DATE_ATTRIB151,
   WOR_DATE_ATTRIB152,
   WOR_DATE_ATTRIB153,
   WOR_DATE_ATTRIB154,
   WOR_DATE_ATTRIB155,
   WOR_DATE_ATTRIB156,
   WOR_DATE_ATTRIB157,
   WOR_DATE_ATTRIB158,
   WOR_DATE_ATTRIB159,
   WOR_DATE_ATTRIB160,
   WOR_DATE_ATTRIB161,
   WOR_DATE_ATTRIB162,
   WOR_DATE_ATTRIB163,
   WOR_DATE_ATTRIB164,
   WOR_DATE_ATTRIB165,
   WOR_DATE_ATTRIB166,
   WOR_DATE_ATTRIB167,
   WOR_DATE_ATTRIB168,
   WOR_DATE_ATTRIB169,
   WOR_DATE_ATTRIB170,
   WOR_DATE_ATTRIB171,
   WOR_DATE_ATTRIB172,
   WOR_DATE_ATTRIB173,
   WOR_DATE_ATTRIB174,
   WOR_DATE_ATTRIB175,
   WOR_DATE_ATTRIB176,
   WOR_DATE_ATTRIB177,
   WOR_DATE_ATTRIB178,
   WOR_DATE_ATTRIB179,
   WOR_DATE_ATTRIB180
)
AS
   SELECT -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
                                                                            --
 --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Existing PODS/IM4 tfl Post v45 scripts/POD_process/wowt/install/views_tables.sql-arc   1.0   Jan 14 2016 19:46:14   Sarah.Williams  $
 --       Module Name      : $Workfile:   views_tables.sql  $
                  --       Date into PVCS   : $Date:   Jan 14 2016 19:46:14  $
               --       Date fetched Out : $Modtime:   Oct 20 2011 11:08:40  $
                               --       Version          : $Revision:   1.0  $
                 -- Foundation view displaying maintenance manager work orders
     -------------------------------------------------------------------------
          wor_works_order_no works_order_number,
          wor_descr works_order_description,
          (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)
             works_order_status,
          wor_flag works_order_type,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'WOR_FLAG' AND hco_code = wor_flag)
             works_order_type_description,
          wor_interim_payment_flag interim_payment,
          wor_priority priority,
          NVL (
             (SELECT hco_meaning
                FROM hig_codes
               WHERE hco_domain = 'WOR_PRIORITY'
                     AND hco_code = wor.wor_priority),
             (SELECT wpr_name
                FROM work_order_priorities
               WHERE wpr_id = wor.wor_priority))
             priority_description,
          wor_rse_he_id_group network_element_id,
          wor_sys_flag sys_flag,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'ROAD_SYS_FLAG'
                  AND hco_code = wor.wor_sys_flag)
             sys_flag_description,
          wor_scheme_type scheme_type,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'SCHEME_TYPES'
                  AND hco_code = wor.wor_scheme_type)
             scheme_type_description,
          wor_register_flag register,
          wor_register_status register_status,
          (SELECT hco_meaning
             FROM hig_codes
            WHERE hco_domain = 'WOR_REGISTER_STATUS'
                  AND hco_code = wor.wor_register_status)
             register_status_description,
          wor_con_id contract_id,
          con_code contract_code,
          con_name contract_name,
          con_contr_org_id contractor_id,
          (SELECT oun_unit_code
             FROM org_units
            WHERE con_contr_org_id = oun_org_id)
             contractor_code,
          (SELECT oun_name
             FROM org_units
            WHERE con_contr_org_id = oun_org_id)
             contractor_name,
          wor_contact contact,
          wor_peo_person_id originator_id,
          (SELECT hus_initials
             FROM hig_users
            WHERE hus_user_id = wor.wor_peo_person_id)
             originator_initials,
          (SELECT hus_name
             FROM hig_users
            WHERE hus_user_id = wor.wor_peo_person_id)
             originator_name,
          wor_mod_by_id authorised_by_id,
          (SELECT hus_initials
             FROM hig_users
            WHERE hus_user_id = wor.wor_mod_by_id)
             authorised_by_initials,
          (SELECT hus_name
             FROM hig_users
            WHERE hus_user_id = wor.wor_mod_by_id)
             authorised_by_name,
          wor_coc_cost_centre cost_centre,
          wor_job_number job_number,
          wor_rechargeable rechargable,
          wor_cost_recharg cost_recharged,
          wor_remarks remarks,
          wor_date_raised date_raised,
          TRUNC (SYSDATE) - TRUNC (wor_date_raised) days_since_raised,
          wor_est_complete target_date,
          TRUNC (wor_est_complete) - TRUNC (SYSDATE) days_to_target_date,
          wor_date_confirmed date_instructed,
          TRUNC (SYSDATE) - TRUNC (wor_date_confirmed) days_since_instructed,
          wor_last_print_date date_last_printed,
          wor_date_received date_received,
          TRUNC (SYSDATE) - TRUNC (wor_date_received) days_since_received,
          wor_received_by received_by_id,
          (SELECT hus_initials
             FROM hig_users
            WHERE hus_user_id = wor.wor_received_by)
             received_by_initials,
          (SELECT hus_name
             FROM hig_users
            WHERE hus_user_id = wor.wor_received_by)
             received_by_name,
          wor_date_closed date_completed,
          TRUNC (SYSDATE) - TRUNC (wor_date_closed) days_since_completed,
          wor_est_cost order_estimated_cost,
          wor_est_balancing_sum order_estimated_balancing_sum,
          wor_est_cost + wor_est_balancing_sum order_estimated_total,
          wor_est_labour labour_units,
          wor_act_cost order_actual_cost,
          wor_act_balancing_sum order_actual_balancing_sum,
          wor_act_cost + wor_act_balancing_sum order_actual_total,
          wor_num_attrib01,
          wor_num_attrib02,
          wor_num_attrib03,
          wor_num_attrib04,
          wor_num_attrib05,
          wor_num_attrib06,
          wor_num_attrib07,
          wor_num_attrib08,
          wor_num_attrib09,
          wor_num_attrib10,
          wor_num_attrib11,
          wor_num_attrib12,
          wor_num_attrib13,
          wor_num_attrib14,
          wor_num_attrib15,
          wor_num_attrib16,
          wor_num_attrib17,
          wor_num_attrib18,
          wor_num_attrib19,
          wor_num_attrib20,
          wor_num_attrib21,
          wor_num_attrib22,
          wor_num_attrib23,
          wor_num_attrib24,
          wor_num_attrib25,
          wor_num_attrib26,
          wor_num_attrib27,
          wor_num_attrib28,
          wor_num_attrib29,
          wor_num_attrib30,
          wor_num_attrib31,
          wor_num_attrib32,
          wor_num_attrib33,
          wor_num_attrib34,
          wor_num_attrib35,
          wor_num_attrib36,
          wor_num_attrib37,
          wor_num_attrib38,
          wor_num_attrib39,
          wor_num_attrib40,
          wor_num_attrib41,
          wor_num_attrib42,
          wor_num_attrib43,
          wor_num_attrib44,
          wor_num_attrib45,
          wor_num_attrib46,
          wor_num_attrib47,
          wor_num_attrib48,
          wor_num_attrib49,
          wor_num_attrib50,
          wor_num_attrib51,
          wor_num_attrib52,
          wor_num_attrib53,
          wor_num_attrib54,
          wor_num_attrib55,
          wor_num_attrib56,
          wor_num_attrib57,
          wor_num_attrib58,
          wor_num_attrib59,
          wor_num_attrib60,
          wor_char_attrib61,
          wor_char_attrib62,
          wor_char_attrib63,
          wor_char_attrib64,
          wor_char_attrib65,
          wor_char_attrib66,
          wor_char_attrib67,
          wor_char_attrib68,
          wor_char_attrib69,
          wor_char_attrib70,
          wor_char_attrib71,
          wor_char_attrib72,
          wor_char_attrib73,
          wor_char_attrib74,
          wor_char_attrib75,
          wor_char_attrib76,
          wor_char_attrib77,
          wor_char_attrib78,
          wor_char_attrib79,
          wor_char_attrib80,
          wor_char_attrib81,
          wor_char_attrib82,
          wor_char_attrib83,
          wor_char_attrib84,
          wor_char_attrib85,
          wor_char_attrib86,
          wor_char_attrib87,
          wor_char_attrib88,
          wor_char_attrib89,
          wor_char_attrib90,
          wor_char_attrib91,
          wor_char_attrib92,
          wor_char_attrib93,
          wor_char_attrib94,
          wor_char_attrib95,
          wor_char_attrib96,
          wor_char_attrib97,
          wor_char_attrib98,
          wor_char_attrib99,
          wor_char_attrib100,
          wor_char_attrib101,
          wor_char_attrib102,
          wor_char_attrib103,
          wor_char_attrib104,
          wor_char_attrib105,
          wor_char_attrib106,
          wor_char_attrib107,
          wor_char_attrib108,
          wor_char_attrib109,
          wor_char_attrib110,
          wor_char_attrib111,
          wor_char_attrib112,
          wor_char_attrib113,
          wor_char_attrib114,
          wor_char_attrib115,
          wor_char_attrib116,
          wor_char_attrib117,
          wor_char_attrib118,
          wor_char_attrib119,
          wor_char_attrib120,
          wor_date_attrib121,
          wor_date_attrib122,
          wor_date_attrib123,
          wor_date_attrib124,
          wor_date_attrib125,
          wor_date_attrib126,
          wor_date_attrib127,
          wor_date_attrib128,
          wor_date_attrib129,
          wor_date_attrib130,
          wor_date_attrib131,
          wor_date_attrib132,
          wor_date_attrib133,
          wor_date_attrib134,
          wor_date_attrib135,
          wor_date_attrib136,
          wor_date_attrib137,
          wor_date_attrib138,
          wor_date_attrib139,
          wor_date_attrib140,
          wor_date_attrib141,
          wor_date_attrib142,
          wor_date_attrib143,
          wor_date_attrib144,
          wor_date_attrib145,
          wor_date_attrib146,
          wor_date_attrib147,
          wor_date_attrib148,
          wor_date_attrib149,
          wor_date_attrib150,
          wor_date_attrib151,
          wor_date_attrib152,
          wor_date_attrib153,
          wor_date_attrib154,
          wor_date_attrib155,
          wor_date_attrib156,
          wor_date_attrib157,
          wor_date_attrib158,
          wor_date_attrib159,
          wor_date_attrib160,
          wor_date_attrib161,
          wor_date_attrib162,
          wor_date_attrib163,
          wor_date_attrib164,
          wor_date_attrib165,
          wor_date_attrib166,
          wor_date_attrib167,
          wor_date_attrib168,
          wor_date_attrib169,
          wor_date_attrib170,
          wor_date_attrib171,
          wor_date_attrib172,
          wor_date_attrib173,
          wor_date_attrib174,
          wor_date_attrib175,
          wor_date_attrib176,
          wor_date_attrib177,
          wor_date_attrib178,
          wor_date_attrib179,
          wor_date_attrib180
     FROM work_orders wor, contracts con
    WHERE con.con_id = wor.wor_con_id
          AND (NOT EXISTS
                  (SELECT 1
                     FROM mai_wo_users
                    WHERE mwu_user_id = nm3user.get_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                           )
               OR wor.wor_works_order_no IN
                     (SELECT wor_works_order_no
                        FROM work_orders
                       WHERE wor_forwarded_to = nm3user.get_user_id
                      -- (select hus_user_id from hig_users where hus_username = v('APP_USER'))
                      UNION
                      SELECT wol_works_order_no
                        FROM work_order_lines wol
                       WHERE (EXISTS
                                 (SELECT 1
                                    FROM mai_wo_users
                                   WHERE mwu_user_id = nm3user.get_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                         AND mwu_restrict_by_workcode = 'N')
                              OR wol.wol_bud_id IN
                                    (SELECT bud_id
                                       FROM budgets, mai_wo_user_work_codes
                                      WHERE mwuw_user_id =
                                               nm3user.get_user_id
                                            --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                            AND mwuw_icb_item_code =
                                                   bud_icb_item_code
                                            AND NVL (mwuw_icb_sub_item_code,
                                                     bud_icb_sub_item_code) =
                                                   bud_icb_sub_item_code
                                            AND NVL (
                                                   mwuw_icb_sub_sub_item_code,
                                                   bud_icb_sub_sub_item_code) =
                                                   bud_icb_sub_sub_item_code))
                             AND (EXISTS
                                     (SELECT 1
                                        FROM mai_wo_users
                                       WHERE mwu_user_id =
                                                nm3user.get_user_id
                                             --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                             AND mwu_restrict_by_road_group =
                                                    'N')
                                  OR wol_rse_he_id IN
                                        (    SELECT nm_ne_id_of
                                               FROM nm_members
                                              WHERE nm_type = 'G'
                                         CONNECT BY PRIOR nm_ne_id_of =
                                                       nm_ne_id_in
                                         START WITH nm_ne_id_in IN
                                                       (SELECT mwur_road_group_id
                                                          FROM mai_wo_user_road_groups
                                                         WHERE mwur_user_id =
                                                                  nm3user.get_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                                                     )
                                         UNION
                                         SELECT mwur_road_group_id
                                           FROM mai_wo_user_road_groups
                                          WHERE mwur_user_id =
                                                   nm3user.get_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                                      ))));

Create table x_IM511001
(run_id number
,non_col1 number
,non_col2 number
,non_col3 number
,col1_1A number
,col2_1A number
,col3_1A number
,col1_2H number
,col2_2H number
,col3_2H number
,col1_2M number
,col2_2M number
,col3_2M number
,col1_2L number
,col2_2L number
,col3_2L number);

CREATE TABLE X_IM511001_WO
(
  RUN_ID             NUMBER,
  WORK_ORDER_NUMBER  VARCHAR2(50 BYTE),
  DAYS               VARCHAR2(10 BYTE),
  DEF_PRI            VARCHAR2(10 BYTE)
);

CREATE OR REPLACE  VIEW X_IM511001_WO_VW
(
   RUN_ID,
   WORK_ORDER_NUMBER,
   DAYS,
   DEF_PRI
)
AS
   SELECT "RUN_ID",
          "WORK_ORDER_NUMBER",
          "DAYS",
          def_pri
     FROM x_im511001_wo
    WHERE run_id = 1;

CREATE OR REPLACE VIEW X_WO_TFL_WORK_TRAY_IM511001
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   DEFECT_PRIORITY,
   HAUD_TIMESTAMP,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          wol.defect_priority,
          haud_timestamp,
          authorised_by_id,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
          wor.order_estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          X_IM511001_WO_vw worv,
          imf_mai_work_order_lines wol,
          nm_members net,
          hig_audits_vw
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND wor.works_order_number = haud_pk_id
          AND haud_table_name = 'WORK_ORDERS'
          AND wol.network_element_id = net.nm_ne_id_of
          AND net.nm_obj_type = 'HMBG'
          AND wor.works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = 'RDY'
          AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
          AND haud_timestamp =
                 (SELECT MAX (haud_timestamp)
                    FROM hig_audits_vw
                   WHERE     haud_pk_id = wor.works_order_number
                         AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                         AND haud_new_value = 'RDY')
          AND NVL (haud_old_value, 'Empty') NOT IN ('REJ', 'HLD');

Create table x_IM511002
(run_id number
,non_col1 number
,non_col2 number
,non_col3 number
,col1_1A number
,col2_1A number
,col3_1A number
,col1_2H number
,col2_2H number
,col3_2H number
,col1_2M number
,col2_2M number
,col3_2M number
,col1_2L number
,col2_2L number
,col3_2L number);

drop table X_IM511002_WO;

CREATE TABLE X_IM511002_WO
(
  RUN_ID             NUMBER,
  WORK_ORDER_NUMBER  VARCHAR2(50 BYTE),
  DAYS               VARCHAR2(10 BYTE),
  DEF_PRI            VARCHAR2(10 BYTE)
);
    
CREATE OR REPLACE VIEW X_IM511002_WO_VW
(
   RUN_ID,
   WORK_ORDER_NUMBER,
   DAYS,
          def_pri
)
AS
   SELECT "RUN_ID", "WORK_ORDER_NUMBER",  "DAYS",  def_pri
     FROM x_im511002_wo
    WHERE run_id = 1;    

CREATE OR REPLACE VIEW X_WO_TFL_WORK_TRAY_IM511002
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   DEFECT_PRIORITY,
   HAUD_TIMESTAMP,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          wol.defect_priority,
          haud_timestamp,
          authorised_by_id,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
          wor.order_estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          X_IM511002_WO_vw worv,
          ximf_mai_work_order_lines wol,
          nm_members net,
          hig_audits_vw
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND wor.works_order_number = haud_pk_id
          AND haud_table_name = 'WORK_ORDERS'
          AND wol.network_element_id = net.nm_ne_id_of
          AND net.nm_obj_type = 'HMBG'
          AND works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = 'RDY'
          AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
          AND haud_timestamp =
                 (SELECT MAX (haud_timestamp)
                    FROM hig_audits_vw
                   WHERE     haud_pk_id = wor.works_order_number
                         AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                         AND haud_new_value = 'RDY')
          AND haud_old_value IN ('REJ', 'HLD');    
 

Create table x_IM511003
 (run_id number
,non_col1 number
,non_col2 number
,non_col3 number
,non_col4 number
,ls_col1 number
,ls_col2 number
,ls_col3 number
,ls_col4 number);

drop table X_IM511003_WO;

CREATE TABLE X_IM511003_WO
(
  RUN_ID             NUMBER,
  WORK_ORDER_NUMBER  VARCHAR2(50),   
  DAYS               VARCHAR2(10)
);

CREATE OR REPLACE VIEW X_IM511003_WO_VW
(
   RUN_ID,
   WORK_ORDER_NUMBER,
   DAYS
)
AS
   SELECT "RUN_ID", "WORK_ORDER_NUMBER", "DAYS"
     FROM x_im511003_wo
    WHERE run_id = 1;
         
CREATE OR REPLACE  VIEW X_WO_TFL_WORK_TRAY_IM511003_LS
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT                                                                   --
         DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          authorised_by_id,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
         wor.order_estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          x_im511003_wo_vw worv,
          ximf_mai_work_order_lines wol
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND works_order_status = 'DRAFT'
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          AND wor.works_order_number LIKE '%LS%';          
          
CREATE OR REPLACE  VIEW X_WO_TFL_WORK_TRAY_IM511003NLS
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT                                                                   --
         DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          authorised_by_id,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
           wor.order_estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          x_im511003_wo_vw worv,
          ximf_mai_work_order_lines wol
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND works_order_status = 'DRAFT'
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          AND wor.works_order_number NOT LIKE '%LS%';          


