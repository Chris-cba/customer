CREATE OR REPLACE FORCE VIEW POD_EOT_UPDATED
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
   COST_CODE,
   BOROUGH,
   CON_AU,
   REQUESTS,
   EOT_REQUESTED_BY,
   EOT_DATE_REVIEWED,
   EOT_REVIEWED_BY
)
AS
   SELECT DISTINCT
             '<a href="javascript:openForms(''WORK_ORDERS'','''
          || wor.works_order_number
          || ''');">Navigator'
             navigator,
          wol.work_order_line_id,
          wor.works_order_number,
          wor.contractor_code,
          wor.originator_name,
          wor.contact,
          wol.defect_id,
          wol.defect_priority,
          wol.location_description,
          def.defect_description,
          def.repair_description,
          def.repair_category,
          wor.date_raised,
          wor.wor_date_attrib121 AS EOT_Date_Requested,
          wor.date_instructed,
          wol.estimated_cost,
          wol.actual_cost,
          wor.works_order_status,
          wor.scheme_type,
          wor.scheme_type_description,
          wol.work_category,
          wol.work_category_description,
          wor.authorised_by_name,
          wol.date_repaired,
          wol.date_completed,
          --wor.WOR_CHAR_ATTRIB100 AS "WO Process Status",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB100',
                                           wor.wor_char_attrib100)
             AS "WO Process Status",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB100'), wor.WOR_CHAR_ATTRIB100) "WO Process Status Descr",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB101',
                                           wor.wor_char_attrib101)
             AS "WO Extension of Time Status",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB101'), wor.WOR_CHAR_ATTRIB101)  "WO Ext of Time Status Descr",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB102',
                                           wor.wor_char_attrib102)
             AS "EOT Reason for Request",
          -- NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB102'), wor.WOR_CHAR_ATTRIB102)  "EOT Reason for Request Descr",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB103',
                                           wor.wor_char_attrib103)
             AS "EOT Reason for Rejection",
          -- NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB103'), wor.WOR_CHAR_ATTRIB103)  "EOT Reason for Rejection Descr",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB104',
                                           wor.wor_char_attrib104)
             AS "WO Reason for Hold",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB104'), wor.WOR_CHAR_ATTRIB104) "WO Reason for Hold Descr",
          disco.jg_get_dec_inv_attr_value ('WFX$',
                                           'WOR_CHAR_ATTRIB105',
                                           wor.wor_char_attrib105)
             AS "WO Reason for Rejection",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB105'), wor.WOR_CHAR_ATTRIB105)  "WO Reason for Rejection Descr",
          wor.wor_date_attrib122 AS "EOT Conditional Date",
          bud.cost_code,
          net.parent_element_description AS "Borough",
          c.con_admin_org_id con_au,
          1 requests,
          (SELECT hus_name
             FROM hig_users
            WHERE hus_user_id = wor.WOR_NUM_ATTRIB10)
             eot_requested_by,
          WOR_DATE_ATTRIB123 AS eot_date_reviewed,
          (SELECT hus_name
             FROM hig_users
            WHERE hus_user_id = wor.WOR_NUM_ATTRIB11)
             eot_date_reviewed_by
     FROM imf_mai_work_orders_all_attrib wor,
          imf_mai_work_order_lines wol,
          imf_mai_defect_repairs def,
          imf_mai_budgets bud,
          contracts c,
          imf_net_network_members net,
          pod_budget_security bud_sec,
          pod_nm_element_security ele_sec,
          (  SELECT haud_pk_id ra_haud_pk_id,
                    haud_attribute_name ra_haud_attribute_name,
                    MAX (haud_timestamp) ra_max_ts
               FROM hig_audits_vw
              WHERE haud_attribute_name = 'WOR_CHAR_ATTRIB101'
           GROUP BY haud_pk_id, haud_attribute_name) ra,
          (SELECT hus_admin_unit user_au
             FROM hig_users
            WHERE hus_username = USER) au,
          (SELECT NVL (mwu_restrict_by_road_group, 'N') rd_rst,
                  NVL (mwu_restrict_by_workcode, 'N') wc_rst
             FROM mai_wo_users, hig_users
            WHERE mwu_user_id = hus_user_id AND hus_username = USER) sec
    WHERE     wor.works_order_number = work_order_number
          AND wor.works_order_number = ra_haud_pk_id
          AND wol.defect_id = def.defect_id(+)
          AND wol.budget_id = bud.budget_id
          AND wol.network_element_id = child_element_id
          AND parent_group_type = 'HMBG'
          AND work_order_line_status NOT IN ('COMPLETED', 'ACTIONED')
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (wor_char_attrib100, 'Empty') NOT IN ('REJ', 'HLD')
          AND wor_date_attrib121 IS NOT NULL
          AND wor.contract_id = c.con_id
          AND user_au IN (1, c.con_admin_org_id)
          --and WOR_CHAR_ATTRIB101 = decode(:P6_PARAM1,'Approved','APP','Conditional','CND','Rejected','REJ')
          AND TRUNC (SYSDATE - ra_max_ts) <= 30
          AND wol.network_element_id = ele_sec.element_id
          AND wol.work_category = bud_sec.budget_code;
