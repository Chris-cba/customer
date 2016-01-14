CREATE OR REPLACE FORCE VIEW HIGHWAYS.XIMF_MAI_WO_ALL_ATTR_NO_SEC
AS
   SELECT -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
                                                                            --
 --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/For Fix 8/admin/sql/ximf_mai_wo_all_attr_no_sec.sql-arc   1.0   Jan 14 2016 22:43:32   Sarah.Williams  $
 --       Module Name      : $Workfile:   ximf_mai_wo_all_attr_no_sec.sql  $
                  --       Date into PVCS   : $Date:   Jan 14 2016 22:43:32  $
               --       Date fetched Out : $Modtime:   Mar 11 2013 13:43:36  $
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
        ;

