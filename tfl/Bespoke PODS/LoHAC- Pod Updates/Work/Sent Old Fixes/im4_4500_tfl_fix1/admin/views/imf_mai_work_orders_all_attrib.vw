/* Formatted on 25/01/2013 16:47:16 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB
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
   ESTIMATED_COST,
   ESTIMATED_BALANCING_SUM,
   ESTIMATED_TOTAL,
   LABOUR_UNITS,
   ACTUAL_COST,
   ACTUAL_BALANCING_SUM,
   ACTUAL_TOTAL,
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
          --       PVCS id          : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/Sent Old Fixes/im4_4500_tfl_fix1/admin/views/imf_mai_work_orders_all_attrib.vw-arc   1.0   Jan 15 2016 00:26:46   Sarah.Williams  $
          --       Module Name      : $Workfile:   imf_mai_work_orders_all_attrib.vw  $
          --       Date into PVCS   : $Date:   Jan 15 2016 00:26:46  $
          --       Date fetched Out : $Modtime:   Feb 19 2013 23:49:46  $
          --       Version          : $Revision:   1.0  $
          -- Foundation view displaying maintenance manager work orders
          -------------------------------------------------------------------------
          wor_works_order_no works_order_number,
          wor_descr works_order_description,
          (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE  rownum = 1 and vwor.wor_works_order_no = wor.wor_works_order_no)
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
    WHERE con.con_id = wor.wor_con_id;
COMMENT ON TABLE HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB IS 'Maintenance Manager Foundation view of all Works Orders (Including All Flexible Attribute Columns), showing Works Order details, calculated due dates and work order costings. This view can be used to produce statistical and summary Maintenance Manager reports where Works Order details are required.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WORKS_ORDER_NUMBER IS 'The Works Order Number.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WORKS_ORDER_DESCRIPTION IS 'The Works Order Description.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WORKS_ORDER_STATUS IS 'The current status of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WORKS_ORDER_TYPE IS 'The Works Order Type, e.g. M - Cyclic Maintenance or D - Defect Clearance';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WORKS_ORDER_TYPE_DESCRIPTION IS 'The Works Order Type Description';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.INTERIM_PAYMENT IS 'Interim Payments can be made? (Y/N)';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.PRIORITY IS 'The Works Order Priority code.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.PRIORITY_DESCRIPTION IS 'The Works Order Priority meaning.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.NETWORK_ELEMENT_ID IS 'Internal id of the Road Group associated with the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.SYS_FLAG IS 'The Sys Flag of the Road Group associated with the Works Order (L/D).';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.SYS_FLAG_DESCRIPTION IS 'Sys Flag description.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.SCHEME_TYPE IS 'The Works Order Scheme Type.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.SCHEME_TYPE_DESCRIPTION IS 'The Works Order Scheme Type description.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.REGISTER IS 'The Works should be included in the TMA Register? (Y/N)';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.REGISTER_STATUS IS 'The Status of the Works within the TMA Register.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.REGISTER_STATUS_DESCRIPTION IS 'The description of the Status of the Works within the TMA Register.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACT_ID IS 'The internal id of the Contract associated with the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACT_CODE IS 'The Code of the Contract that the Works Order is assigned to.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACT_NAME IS 'The Name of the Contract that the Works Order is assigned to.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACTOR_ID IS 'The internal id of the Contractor associated with the Contract.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACTOR_CODE IS 'The Code of the Contractor associated with the Contract.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTRACTOR_NAME IS 'The Name of the Contractor associated with the Contract.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.CONTACT IS 'The Contact details on the Works Order';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ORIGINATOR_ID IS 'The internal id of the person that raised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ORIGINATOR_INITIALS IS 'The initials of the person that raised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ORIGINATOR_NAME IS 'The name of the person that raised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.AUTHORISED_BY_ID IS 'The internal id of the person who authorised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.AUTHORISED_BY_INITIALS IS 'The initials of the person who authorised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.AUTHORISED_BY_NAME IS 'The name of the person who authorised the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.COST_CENTRE IS 'The Cost Centre code associated with the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.JOB_NUMBER IS 'The Job Number associated with the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.RECHARGABLE IS 'Is the Cost of the Works rechargable to an external organisation? (Y/N).';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.COST_RECHARGED IS 'The Total Cost that has been recharged to an external organisation.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.REMARKS IS 'General remarks held against the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DATE_RAISED IS 'The date the Works Order was raised.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DAYS_SINCE_RAISED IS 'The number of days since the Works Order was raised.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.TARGET_DATE IS 'The Target Completion Date of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DAYS_TO_TARGET_DATE IS 'The number of days until the Target Completion date of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DATE_INSTRUCTED IS 'The date the Works Order was Instructed.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DAYS_SINCE_INSTRUCTED IS 'The number of days since the Works Order was Instructed.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DATE_LAST_PRINTED IS 'The date the Works Order was printed.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DATE_RECEIVED IS 'The date the Works Order was marked as Received.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DAYS_SINCE_RECEIVED IS 'The number of days since the Works Order was marked as Received.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.RECEIVED_BY_ID IS 'The internal id of the person who marked the Works Order as Received.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.RECEIVED_BY_INITIALS IS 'The initials of the person who marked the Works Order as Received.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.RECEIVED_BY_NAME IS 'The name of the person who marked the Works Order as Received.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DATE_COMPLETED IS 'The date the Works Order was completed.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.DAYS_SINCE_COMPLETED IS 'The number of days since the Works Order was completed.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ESTIMATED_COST IS 'The Estimated Cost of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ESTIMATED_BALANCING_SUM IS 'The Estimate Balancing Sum of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ESTIMATED_TOTAL IS 'The Estimated Cost + the Estimated Balancing Sum.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.LABOUR_UNITS IS 'The Total number of Labour Units associated with the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ACTUAL_COST IS 'The Actual Cost of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ACTUAL_BALANCING_SUM IS 'The Balancing Sum to be applied to the Actual Cost of the Works Order.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.ACTUAL_TOTAL IS 'The sum of the Actual Cost and the Actual Balancing Sum.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB01 IS 'The value stored in Numeric Attribute Column 01.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB02 IS 'The value stored in Numeric Attribute Column 02.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB03 IS 'The value stored in Numeric Attribute Column 03.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB04 IS 'The value stored in Numeric Attribute Column 04.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB05 IS 'The value stored in Numeric Attribute Column 05.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB06 IS 'The value stored in Numeric Attribute Column 06.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB07 IS 'The value stored in Numeric Attribute Column 07.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB08 IS 'The value stored in Numeric Attribute Column 08.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB09 IS 'The value stored in Numeric Attribute Column 09.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB10 IS 'The value stored in Numeric Attribute Column 10.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB11 IS 'The value stored in Numeric Attribute Column 11.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB12 IS 'The value stored in Numeric Attribute Column 12.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB13 IS 'The value stored in Numeric Attribute Column 13.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB14 IS 'The value stored in Numeric Attribute Column 14.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB15 IS 'The value stored in Numeric Attribute Column 15.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB16 IS 'The value stored in Numeric Attribute Column 16.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB17 IS 'The value stored in Numeric Attribute Column 17.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB18 IS 'The value stored in Numeric Attribute Column 18.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB19 IS 'The value stored in Numeric Attribute Column 19.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB20 IS 'The value stored in Numeric Attribute Column 20.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB21 IS 'The value stored in Numeric Attribute Column 21.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB22 IS 'The value stored in Numeric Attribute Column 22.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB23 IS 'The value stored in Numeric Attribute Column 23.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB24 IS 'The value stored in Numeric Attribute Column 24.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB25 IS 'The value stored in Numeric Attribute Column 25.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB26 IS 'The value stored in Numeric Attribute Column 26.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB27 IS 'The value stored in Numeric Attribute Column 27.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB28 IS 'The value stored in Numeric Attribute Column 28.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB29 IS 'The value stored in Numeric Attribute Column 29.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB30 IS 'The value stored in Numeric Attribute Column 30.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB31 IS 'The value stored in Numeric Attribute Column 31.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB32 IS 'The value stored in Numeric Attribute Column 32.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB33 IS 'The value stored in Numeric Attribute Column 33.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB34 IS 'The value stored in Numeric Attribute Column 34.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB35 IS 'The value stored in Numeric Attribute Column 35.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB36 IS 'The value stored in Numeric Attribute Column 36.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB37 IS 'The value stored in Numeric Attribute Column 37.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB38 IS 'The value stored in Numeric Attribute Column 38.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB39 IS 'The value stored in Numeric Attribute Column 39.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB40 IS 'The value stored in Numeric Attribute Column 40.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB41 IS 'The value stored in Numeric Attribute Column 41.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB42 IS 'The value stored in Numeric Attribute Column 42.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB43 IS 'The value stored in Numeric Attribute Column 43.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB44 IS 'The value stored in Numeric Attribute Column 44.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB45 IS 'The value stored in Numeric Attribute Column 45.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB46 IS 'The value stored in Numeric Attribute Column 46.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB47 IS 'The value stored in Numeric Attribute Column 47.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB48 IS 'The value stored in Numeric Attribute Column 48.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB49 IS 'The value stored in Numeric Attribute Column 49.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB50 IS 'The value stored in Numeric Attribute Column 50.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB51 IS 'The value stored in Numeric Attribute Column 51.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB52 IS 'The value stored in Numeric Attribute Column 52.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB53 IS 'The value stored in Numeric Attribute Column 53.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB54 IS 'The value stored in Numeric Attribute Column 54.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB55 IS 'The value stored in Numeric Attribute Column 55.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB56 IS 'The value stored in Numeric Attribute Column 56.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB57 IS 'The value stored in Numeric Attribute Column 57.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB58 IS 'The value stored in Numeric Attribute Column 58.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB59 IS 'The value stored in Numeric Attribute Column 59.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_NUM_ATTRIB60 IS 'The value stored in Numeric Attribute Column 60.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB61 IS 'The value stored in Character Attribute Column 61.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB62 IS 'The value stored in Character Attribute Column 62.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB63 IS 'The value stored in Character Attribute Column 63.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB64 IS 'The value stored in Character Attribute Column 64.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB65 IS 'The value stored in Character Attribute Column 65.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB66 IS 'The value stored in Character Attribute Column 66.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB67 IS 'The value stored in Character Attribute Column 67.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB68 IS 'The value stored in Character Attribute Column 68.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB69 IS 'The value stored in Character Attribute Column 69.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB70 IS 'The value stored in Character Attribute Column 70.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB71 IS 'The value stored in Character Attribute Column 71.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB72 IS 'The value stored in Character Attribute Column 72.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB73 IS 'The value stored in Character Attribute Column 73.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB74 IS 'The value stored in Character Attribute Column 74.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB75 IS 'The value stored in Character Attribute Column 75.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB76 IS 'The value stored in Character Attribute Column 76.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB77 IS 'The value stored in Character Attribute Column 77.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB78 IS 'The value stored in Character Attribute Column 78.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB79 IS 'The value stored in Character Attribute Column 79.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB80 IS 'The value stored in Character Attribute Column 80.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB81 IS 'The value stored in Character Attribute Column 81.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB82 IS 'The value stored in Character Attribute Column 82.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB83 IS 'The value stored in Character Attribute Column 83.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB84 IS 'The value stored in Character Attribute Column 84.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB85 IS 'The value stored in Character Attribute Column 85.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB86 IS 'The value stored in Character Attribute Column 86.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB87 IS 'The value stored in Character Attribute Column 87.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB88 IS 'The value stored in Character Attribute Column 88.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB89 IS 'The value stored in Character Attribute Column 89.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB90 IS 'The value stored in Character Attribute Column 90.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB91 IS 'The value stored in Character Attribute Column 91.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB92 IS 'The value stored in Character Attribute Column 92.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB93 IS 'The value stored in Character Attribute Column 93.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB94 IS 'The value stored in Character Attribute Column 94.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB95 IS 'The value stored in Character Attribute Column 95.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB96 IS 'The value stored in Character Attribute Column 96.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB97 IS 'The value stored in Character Attribute Column 97.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB98 IS 'The value stored in Character Attribute Column 98.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB99 IS 'The value stored in Character Attribute Column 99.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB100 IS 'The value stored in Character Attribute Column 100.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB101 IS 'The value stored in Character Attribute Column 101.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB102 IS 'The value stored in Character Attribute Column 102.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB103 IS 'The value stored in Character Attribute Column 103.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB104 IS 'The value stored in Character Attribute Column 104.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB105 IS 'The value stored in Character Attribute Column 105.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB106 IS 'The value stored in Character Attribute Column 106.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB107 IS 'The value stored in Character Attribute Column 107.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB108 IS 'The value stored in Character Attribute Column 108.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB109 IS 'The value stored in Character Attribute Column 109.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB110 IS 'The value stored in Character Attribute Column 110.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB111 IS 'The value stored in Character Attribute Column 111.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB112 IS 'The value stored in Character Attribute Column 112.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB113 IS 'The value stored in Character Attribute Column 113.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB114 IS 'The value stored in Character Attribute Column 114.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB115 IS 'The value stored in Character Attribute Column 115.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB116 IS 'The value stored in Character Attribute Column 116.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB117 IS 'The value stored in Character Attribute Column 117.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB118 IS 'The value stored in Character Attribute Column 118.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB119 IS 'The value stored in Character Attribute Column 119.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_CHAR_ATTRIB120 IS 'The value stored in Character Attribute Column 120.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB121 IS 'The value stored in Date Attribute Column 121.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB122 IS 'The value stored in Date Attribute Column 122.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB123 IS 'The value stored in Date Attribute Column 123.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB124 IS 'The value stored in Date Attribute Column 124.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB125 IS 'The value stored in Date Attribute Column 125.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB126 IS 'The value stored in Date Attribute Column 126.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB127 IS 'The value stored in Date Attribute Column 127.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB128 IS 'The value stored in Date Attribute Column 128.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB129 IS 'The value stored in Date Attribute Column 129.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB130 IS 'The value stored in Date Attribute Column 130.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB131 IS 'The value stored in Date Attribute Column 131.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB132 IS 'The value stored in Date Attribute Column 132.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB133 IS 'The value stored in Date Attribute Column 133.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB134 IS 'The value stored in Date Attribute Column 134.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB135 IS 'The value stored in Date Attribute Column 135.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB136 IS 'The value stored in Date Attribute Column 136.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB137 IS 'The value stored in Date Attribute Column 137.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB138 IS 'The value stored in Date Attribute Column 138.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB139 IS 'The value stored in Date Attribute Column 139.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB140 IS 'The value stored in Date Attribute Column 140.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB141 IS 'The value stored in Date Attribute Column 141.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB142 IS 'The value stored in Date Attribute Column 142.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB143 IS 'The value stored in Date Attribute Column 143.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB144 IS 'The value stored in Date Attribute Column 144.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB145 IS 'The value stored in Date Attribute Column 145.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB146 IS 'The value stored in Date Attribute Column 146.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB147 IS 'The value stored in Date Attribute Column 147.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB148 IS 'The value stored in Date Attribute Column 148.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB149 IS 'The value stored in Date Attribute Column 149.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB150 IS 'The value stored in Date Attribute Column 150.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB151 IS 'The value stored in Date Attribute Column 151.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB152 IS 'The value stored in Date Attribute Column 152.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB153 IS 'The value stored in Date Attribute Column 153.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB154 IS 'The value stored in Date Attribute Column 154.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB155 IS 'The value stored in Date Attribute Column 155.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB156 IS 'The value stored in Date Attribute Column 156.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB157 IS 'The value stored in Date Attribute Column 157.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB158 IS 'The value stored in Date Attribute Column 158.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB159 IS 'The value stored in Date Attribute Column 159.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB160 IS 'The value stored in Date Attribute Column 160.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB161 IS 'The value stored in Date Attribute Column 161.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB162 IS 'The value stored in Date Attribute Column 162.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB163 IS 'The value stored in Date Attribute Column 163.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB164 IS 'The value stored in Date Attribute Column 164.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB165 IS 'The value stored in Date Attribute Column 165.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB166 IS 'The value stored in Date Attribute Column 166.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB167 IS 'The value stored in Date Attribute Column 167.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB168 IS 'The value stored in Date Attribute Column 168.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB169 IS 'The value stored in Date Attribute Column 169.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB170 IS 'The value stored in Date Attribute Column 170.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB171 IS 'The value stored in Date Attribute Column 171.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB172 IS 'The value stored in Date Attribute Column 172.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB173 IS 'The value stored in Date Attribute Column 173.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB174 IS 'The value stored in Date Attribute Column 174.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB175 IS 'The value stored in Date Attribute Column 175.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB176 IS 'The value stored in Date Attribute Column 176.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB177 IS 'The value stored in Date Attribute Column 177.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB178 IS 'The value stored in Date Attribute Column 178.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB179 IS 'The value stored in Date Attribute Column 179.';

COMMENT ON COLUMN HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB.WOR_DATE_ATTRIB180 IS 'The value stored in Date Attribute Column 180.';


DROP PUBLIC SYNONYM IMF_MAI_WORK_ORDERS_ALL_ATTRIB;

CREATE OR REPLACE PUBLIC SYNONYM IMF_MAI_WORK_ORDERS_ALL_ATTRIB FOR HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB;

ALTER VIEW HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB ADD (
  CONSTRAINT IMF_MAI_WORK_ORDERS_ALL_ATT_PK
  UNIQUE (WORKS_ORDER_NUMBER)  DISABLE);

ALTER VIEW HIGHWAYS.IMF_MAI_WORK_ORDERS_ALL_ATTRIB ADD (
  CONSTRAINT IMF_MAI_WORK_ORDERS_ALL_AT_FK1 
  FOREIGN KEY (NETWORK_ELEMENT_ID) 
  REFERENCES HIGHWAYS.IMF_NET_NETWORK (NETWORK_ELEMENT_ID)  DISABLE);
