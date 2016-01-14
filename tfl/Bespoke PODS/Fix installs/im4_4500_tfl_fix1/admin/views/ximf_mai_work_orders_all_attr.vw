CREATE OR REPLACE FORCE VIEW XIMF_MAI_WORK_ORDERS_ALL_ATTR
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
 --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/Fix installs/im4_4500_tfl_fix1/admin/views/ximf_mai_work_orders_all_attr.vw-arc   1.0   Jan 14 2016 21:07:22   Sarah.Williams  $
 --       Module Name      : $Workfile:   ximf_mai_work_orders_all_attr.vw  $
                  --       Date into PVCS   : $Date:   Jan 14 2016 21:07:22  $
               --       Date fetched Out : $Modtime:   Feb 18 2013 00:30:52  $
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
          AND ((x_get_im_user_id = 1) or (NOT EXISTS
                  (SELECT 1
                     FROM mai_wo_users
                    WHERE mwu_user_id = x_get_im_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                        )
               OR wor.wor_works_order_no IN
                     (SELECT wor_works_order_no
                        FROM work_orders
                       WHERE wor_forwarded_to = x_get_im_user_id
                      -- (select hus_user_id from hig_users where hus_username = v('APP_USER'))
                      UNION
                      SELECT wol_works_order_no
                        FROM work_order_lines wol
                       WHERE (EXISTS
                                 (SELECT 1
                                    FROM mai_wo_users
                                   WHERE mwu_user_id = x_get_im_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                         AND mwu_restrict_by_workcode = 'N')
                              OR wol.wol_bud_id IN
                                    (SELECT bud_id
                                       FROM budgets, mai_wo_user_work_codes
                                      WHERE mwuw_user_id = x_get_im_user_id
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
                                       WHERE mwu_user_id = x_get_im_user_id
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
                                                                  x_get_im_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                                                  )
                                         UNION
                                         SELECT mwur_road_group_id
                                           FROM mai_wo_user_road_groups
                                          WHERE mwur_user_id =
                                                   x_get_im_user_id --(select hus_user_id from hig_users where hus_username = v('APP_USER'))
                                                                   )))));


