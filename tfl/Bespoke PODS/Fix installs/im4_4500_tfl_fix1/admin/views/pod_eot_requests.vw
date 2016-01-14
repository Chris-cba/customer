CREATE OR REPLACE FORCE VIEW POD_EOT_REQUESTS
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
   REQUESTS,
   "EOT Date Requested",
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
   "WO Process Status",
   "WO Extension of Time Status",
   "EOT Reason for Request",
   "EOT Reason for Rejection",
   "WO Reason for Hold",
   "WO Reason for Rejection",
   "EOT Conditional Date",
   COST_CODE,
   "Borough",
   DAYS,
   REQ,
   DAYS_SINCE_APP
)
AS
   SELECT DISTINCT
             '<a href="javascript:openForms(''WORK_ORDERS'','''
          || wor.works_order_number
          || ''');">Navigator'
             Navigator,
          wol.WORK_ORDER_LINE_ID,
          wor.WORKS_ORDER_NUMBER,
          wor.CONTRACTOR_CODE,
          wor.ORIGINATOR_NAME,
          wor.CONTACT,
          wol.DEFECT_ID,
          wol.DEFECT_PRIORITY,
          wol.LOCATION_DESCRIPTION,
          def.DEFECT_DESCRIPTION,
          def.REPAIR_DESCRIPTION,
          def.REPAIR_CATEGORY,
          wor.DATE_RAISED,
          1 requests,
          wor.WOR_DATE_ATTRIB121 AS "EOT Date Requested",
          wor.DATE_INSTRUCTED,
          wol.ESTIMATED_COST,
          wol.ACTUAL_COST,
          wor.WORKS_ORDER_STATUS,
          wor.SCHEME_TYPE,
          wor.SCHEME_TYPE_DESCRIPTION,
          wol.WORK_CATEGORY,
          wol.WORK_CATEGORY_DESCRIPTION,
          wor.AUTHORISED_BY_NAME,
          wol.DATE_REPAIRED,
          wol.DATE_COMPLETED,
          --wor.WOR_CHAR_ATTRIB100 AS "WO Process Status",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB100',
                                           wor.WOR_CHAR_ATTRIB100)
             AS "WO Process Status",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB100'), wor.WOR_CHAR_ATTRIB100) "WO Process Status Descr",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB101',
                                           wor.WOR_CHAR_ATTRIB101)
             AS "WO Extension of Time Status",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB101'), wor.WOR_CHAR_ATTRIB101)  "WO Ext of Time Status Descr",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB102',
                                           wor.WOR_CHAR_ATTRIB102)
             AS "EOT Reason for Request",
          -- NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB102'), wor.WOR_CHAR_ATTRIB102)  "EOT Reason for Request Descr",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB103',
                                           wor.WOR_CHAR_ATTRIB103)
             AS "EOT Reason for Rejection",
          -- NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB103'), wor.WOR_CHAR_ATTRIB103)  "EOT Reason for Rejection Descr",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB104',
                                           wor.WOR_CHAR_ATTRIB104)
             AS "WO Reason for Hold",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB104'), wor.WOR_CHAR_ATTRIB104) "WO Reason for Hold Descr",
          disco.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB105',
                                           wor.WOR_CHAR_ATTRIB105)
             AS "WO Reason for Rejection",
          --NM3INV.GET_INV_DOMAIN_MEANING(nm3inv.get_attrib_domain('WOF','WOR_CHAR_ATTRIB105'), wor.WOR_CHAR_ATTRIB105)  "WO Reason for Rejection Descr",
          wor.WOR_DATE_ATTRIB122 AS "EOT Conditional Date",
          bud.COST_CODE,
          net.parent_element_description AS "Borough",
          --           (CASE
          --               WHEN WOR_CHAR_ATTRIB101 != 'CND'
          --               THEN
          --                  (SELECT RANGE_VALUE
          --                     FROM pod_day_range
          --                    WHERE ra_max_ts BETWEEN st_range AND end_range)
          --            END) days,
          (SELECT RANGE_VALUE
             FROM pod_day_range
            WHERE ra_max_ts BETWEEN st_range AND end_range)
             days,
          (CASE
              WHEN COUNT (haud_pk_id)
                      OVER (PARTITION BY haud_attribute_name, haud_pk_id) = 1
              THEN
                 'Initial'
              WHEN COUNT (haud_pk_id)
                      OVER (PARTITION BY haud_attribute_name, haud_pk_id) > 1
              THEN
                 'Repeat'
           END)
             req,
          ROUND (SYSDATE - ra_max_ts) days_since_app
     FROM imf_mai_work_orders_all_attrib wor,
          imf_mai_work_order_lines wol,
          imf_mai_defect_repairs def,
          imf_mai_budgets bud,
          imf_net_network_members net,
          hig_audits_vw,
          contracts c,
          POD_BUDGET_SECURITY bud_sec,
          POD_NM_ELEMENT_SECURITY ele_Sec,
          (  SELECT haud_pk_id ra_haud_pk_id,
                    haud_attribute_name ra_haud_attribute_name,
                    MAX (haud_timestamp) ra_max_ts
               FROM hig_audits_vw
              WHERE haud_attribute_name = 'WOR_DATE_ATTRIB121'
                    AND haud_timestamp >= SYSDATE - 30
           GROUP BY haud_pk_id, haud_attribute_name) RA,
          (SELECT hus_admin_unit user_au
             FROM hig_users
            WHERE hus_username = USER) au,
          (SELECT NVL (MWU_RESTRICT_BY_ROAD_GROUP, 'N') RD_RST,
                  NVL (MWU_RESTRICT_BY_WORKCODE, 'N') WC_RST
             FROM mai_wo_users, hig_users
            WHERE mwu_user_id = hus_user_id AND hus_username = USER) sec
    WHERE     wor.works_order_number = wol.work_order_number
          AND wol.WORK_ORDER_NUMBER = def.WORKS_ORDER_NUMBER --NM added to eliminate duplicate records that were appearing due to temp/perm defects
          AND wol.defect_id = def.defect_id(+)
          AND wol.budget_id = bud.budget_id
          AND wor.works_order_number = haud_pk_id
          AND haud_table_name = 'WORK_ORDERS'
          AND wol.network_element_id = child_element_id
          AND parent_group_type = 'HMBG'
          AND work_order_line_status NOT IN ('COMPLETED', 'ACTIONED')
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('REJ', 'HLD')
          AND NVL (WOR_CHAR_ATTRIB101, 'Empty') = 'APF'
          AND WOR_DATE_ATTRIB121 IS NOT NULL
          AND haud_table_name = 'WORK_ORDERS'
          AND haud_attribute_name = 'WOR_DATE_ATTRIB121'
          AND haud_pk_id = ra_haud_pk_id
          AND DECODE (WOR.SCHEME_TYPE,
                      5, 'WFS$',
                      10, 'WFX$',
                      20, 'WFX$',
                      30, 'WFX$') = HAUD_INV_TYPE
          AND WOR.CONTRACT_ID = C.CON_ID
          AND user_au IN (1, C.CON_ADMIN_ORG_ID)
          AND wol.network_element_id = ele_sec.element_id
          AND wol.work_category = bud_sec.budget_code;
