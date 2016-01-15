DROP VIEW HIGHWAYS.x_lohac_im_im41038_pod;

/* Formatted on 14/02/2013 09:23:45 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.X_LOHAC_IM_IM41038_POD
(
   NAVIGATOR,
   WORK_ORDER_LINE_ID,
   WORKS_ORDER_NUMBER,
   CONTRACTOR_CODE,
   ORIGINATOR_NAME,
   CONTACT,
   DEFECT_ID,
   DEFECT_PRIORITY,
   LOCATION_DESCRIPTION,
   DEFECT_DESCRIPTION,
   REPAIR_DESCRIPTION,
   REPAIR_CATEGORY,
   DATE_RAISED,
   EOT_DATE_REQUESTED,
   DATE_INSTRUCTED,
   ESTIMATED_COST,
   ACTUAL_COST,
   WORKS_ORDER_STATUS,
   SCHEME_TYPE,
   SCHEME_TYPE_DESCRIPTION,
   WORK_CATEGORY,
   WORK_CATEGORY_DESCRIPTION,
   AUTHORISED_BY_NAME,
   DATE_REPAIRED,
   DATE_COMPLETED,
   WO_PROCESS_STATUS,
   WO_EXTENSION_OF_TIME_STATUS,
   EOT_REASON_FOR_REQUEST,
   EOT_REASON_FOR_REJECTION,
   WO_REASON_FOR_HOLD,
   WO_REASON_FOR_REJECTION,
   EOT_CONDITIONAL_DATE,
   WOR_CHAR_ATTRIB106,
   COST_CODE,
   BOROUGH,
   RANGE_VALUE
)
AS
   WITH Haud
        AS (  SELECT HAUD_PK_ID HAUD_PK_ID,
                     HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                     MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP,
                     range_value
                FROM HIG_AUDITS, POD_DAY_RANGE r
               WHERE     1 = 1
                     AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                     AND HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                     AND HAUD_NEW_VALUE = 'HLD'
                     AND HAUD_TIMESTAMP BETWEEN r.st_range AND r.end_range
            --AND range_value = :P6_PARAM1
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, range_value)
   --
   SELECT DISTINCT
             '<a href="javascript:openForms(''WORK_ORDERS'','''
          || wor.works_order_number
          || ''');">Navigator'
             Navigator,
          wol.WORK_ORDER_LINE_ID WORK_ORDER_LINE_ID,
          wor.WORKS_ORDER_NUMBER WORKS_ORDER_NUMBER,
          wor.CONTRACTOR_CODE CONTRACTOR_CODE,
          wor.ORIGINATOR_NAME ORIGINATOR_NAME,
          wor.CONTACT CONTACT,
          wol.DEFECT_ID DEFECT_ID,
          wol.DEFECT_PRIORITY DEFECT_PRIORITY,
          wol.LOCATION_DESCRIPTION LOCATION_DESCRIPTION,
          def.DEFECT_DESCRIPTION DEFECT_DESCRIPTION,
          def.REPAIR_DESCRIPTION REPAIR_DESCRIPTION,
          def.REPAIR_CATEGORY REPAIR_CATEGORY,
          wor.DATE_RAISED DATE_RAISED,
          wor.WOR_DATE_ATTRIB121 AS EOT_Date_Requested,
          wor.DATE_INSTRUCTED DATE_INSTRUCTED,
          wol.ESTIMATED_COST estimated_cost,
          wol.ACTUAL_COST actual_cost,
          wor.WORKS_ORDER_STATUS works_order_status,
          wor.SCHEME_TYPE scheme_type,
          wor.SCHEME_TYPE_DESCRIPTION scheme_type_description,
          wol.WORK_CATEGORY work_category,
          wol.WORK_CATEGORY_DESCRIPTION work_category_description,
          wor.AUTHORISED_BY_NAME authorised_by_name,
          wol.DATE_REPAIRED DATE_REPAIRED,
          wol.DATE_COMPLETED date_completed,
          wor.WOR_CHAR_ATTRIB100 AS WO_Process_Status,
          wor.WOR_CHAR_ATTRIB101 AS WO_Extension_of_Time_Status,
          wor.WOR_CHAR_ATTRIB102 AS EOT_Reason_for_Request,
          wor.WOR_CHAR_ATTRIB103 AS EOT_Reason_for_Rejection,
          wor.WOR_CHAR_ATTRIB104 AS WO_Reason_for_Hold,
          wor.WOR_CHAR_ATTRIB105 AS WO_Reason_for_Rejection,
          wor.WOR_DATE_ATTRIB122 AS EOT_Conditional_Date,
          wor.WOR_CHAR_ATTRIB106,
          bud.COST_CODE,
          net.parent_element_description AS Borough,
          haud.range_value
     FROM ximf_mai_work_orders_all_attr wor,
          ximf_mai_work_order_lines wol,
          imf_mai_defect_repairs def,
          imf_mai_budgets bud,
          imf_net_network_members net,
          HAUD,
          pod_nm_element_security,
          pod_budget_security
    WHERE     1 = 1
          AND wor.works_order_number = work_order_number
          AND wol.defect_id = def.defect_id(+)
          AND wol.budget_id = bud.budget_id
          AND wor.works_order_number = haud_pk_id
          AND wol.network_element_id = child_element_id
          AND parent_group_type = 'HMBG'
          AND UPPER (NVL (works_order_description, 'Empty')) NOT LIKE
                 UPPER ('%**Cancelled**%')
          AND work_order_line_status NOT IN
                 ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC')
          AND WOR_CHAR_ATTRIB100 = 'HLD'
          --and  NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') = :P6_PARAM2
          --
          AND pod_nm_element_security.element_id = wol.network_element_id --wol_rse_he_id
          AND pod_budget_security.budget_code = wol.work_category --WOL_ICB_WORK_CODE;
