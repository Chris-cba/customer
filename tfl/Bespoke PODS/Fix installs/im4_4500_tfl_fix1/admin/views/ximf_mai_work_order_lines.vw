CREATE OR REPLACE FORCE VIEW HIGHWAYS.XIMF_MAI_WORK_ORDER_LINES
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
 --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Fix installs/im4_4500_tfl_fix1/admin/views/ximf_mai_work_order_lines.vw-arc   1.0   Jan 14 2016 21:07:28   Sarah.Williams  $
       --       Module Name      : $Workfile:   ximf_mai_work_order_lines.vw  $
                  --       Date into PVCS   : $Date:   Jan 14 2016 21:07:28  $
               --       Date fetched Out : $Modtime:   Feb 18 2013 00:30:52  $
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
          AND((x_get_im_user_id = 1) or (NOT EXISTS
                  (SELECT 1
                     FROM mai_wo_users
                    WHERE mwu_user_id = x_get_im_user_id)
               OR wol.wol_works_order_no IN
                     (SELECT wor_works_order_no
                        FROM work_orders
                       WHERE wor_forwarded_to = x_get_im_user_id
                      UNION
                      SELECT wol_works_order_no
                        FROM work_order_lines wol
                       WHERE (EXISTS
                                 (SELECT 1
                                    FROM mai_wo_users
                                   WHERE mwu_user_id = x_get_im_user_id
                                         AND mwu_restrict_by_workcode = 'N')
                              OR wol.wol_bud_id IN
                                    (SELECT bud_id
                                       FROM budgets, mai_wo_user_work_codes
                                      WHERE mwuw_user_id = x_get_im_user_id
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
                                       WHERE mwu_user_id = x_get_im_user_id
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
                                                                  x_get_im_user_id)
                                         UNION
                                         SELECT mwur_road_group_id
                                           FROM mai_wo_user_road_groups
                                          WHERE mwur_user_id =
                                                   x_get_im_user_id)))));
