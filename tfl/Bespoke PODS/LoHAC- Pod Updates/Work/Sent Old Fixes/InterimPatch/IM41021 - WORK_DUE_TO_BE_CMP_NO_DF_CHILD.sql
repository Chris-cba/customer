CREATE OR REPLACE FORCE VIEW HIGHWAYS.WORK_DUE_TO_BE_CMP_NO_DF_CHILD as
--
  SELECT    '<a href="javascript:openForms(''WORK_ORDERS'','''
          || wor.WOR_WORKS_ORDER_NO
          || ''');">Navigator'
             Navigator,
          WOR_WORKS_ORDER_NO,
          DEF_DEFECT_ID defect_id,
          DEF_DEFECT_CODE,
          DEF_PRIORITY,
          DEF_INSPECTION_DATE,
          DEF_DEFECT_DESCR,
          substr(con_code,instr(con_code,'_')+1) contract,
          WOR_CHAR_ATTRIB100 wo_pro_stat,
          WOR_CHAR_ATTRIB101 eot_status,
		   WOR_NUM_ATTRIB10, 
          WOR_DATE_ATTRIB121 req_eot_date,
          WOR_DATE_ATTRIB122 rec_eot_date,
          WOL_DEF_DEFECT_ID,
          wor.WOR_CHAR_ATTRIB100 AS "WO Process Status",
          wor.WOR_CHAR_ATTRIB102 AS "EOT Reason for Request",
          wor.WOR_CHAR_ATTRIB103 AS "EOT Reason for Rejection",
          wor.WOR_CHAR_ATTRIB104 AS "WO Reason for Hold",
          wor.WOR_CHAR_ATTRIB105 AS "WO Reason for Rejection",
          wor.WOR_CHAR_ATTRIB100 ,
		  (select hus_name from hig_users where hus_user_id =wor_peo_person_id)  "Works Order Originator",
          (CASE
              WHEN WOR_CHAR_ATTRIB101 = 'APP'
              THEN
                 WOR_DATE_ATTRIB121 + 1 - (1 / (24 * 60 * 60))
              WHEN WOR_CHAR_ATTRIB101 = 'CND'
              THEN
                 WOR_DATE_ATTRIB122 + 1 - (1 / (24 * 60 * 60))
              ELSE
                 wor.wor_est_complete + 1 - (1 / (24 * 60 * 60))
           END)
             due_date,
          wor_est_complete target_date,
          (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no and rownum=1)
             work_order_status,
          (SELECT hus_name
             FROM hig_users
            WHERE HUS_USER_ID = WOR_PEO_PERSON_ID)
             WO_RAISED_BY,
          wor_contact,
          wor_date_confirmed,
          WOR_ACT_COST,
          WOR_EST_COST,
          WOR_DATE_RAISED,
          WOL_DATE_COMPLETE,
          WOL_DATE_REPAIRED,
          ICB_ITEM_CODE || ICB_SUB_ITEM_CODE || ICB_SUB_SUB_ITEM_CODE
             BUDGET_CODE,
          ICB_WORK_CATEGORY_NAME
     FROM work_orders wor,
          work_order_lines wol,
          budgets,
          contracts,
          item_code_breakdowns,
          defects,
          pod_nm_element_security ele_sec,
          pod_budget_security bud_sec
    WHERE     NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('REJ', 'HLD')
          --AND SUBSTR (wor.WOR_WORKS_ORDER_NO, 5, 2) != 'CS'
          AND wor.WOR_WORKS_ORDER_NO = wol.WOL_WORKS_ORDER_NO
          and defects.DEF_WORKS_ORDER_NO= wor.WOR_WORKS_ORDER_NO(+)
          and wor_con_id = con_id
          AND wol_bud_id = bud_id
           AND    BUD_ICB_ITEM_CODE
              || BUD_ICB_SUB_ITEM_CODE
              || BUD_ICB_SUB_SUB_ITEM_CODE =
                 ICB_ITEM_CODE || ICB_SUB_ITEM_CODE || ICB_SUB_SUB_ITEM_CODE 
          /*AND WOR_WORKS_ORDER_NO IN (SELECT WOL_WORKS_ORDER_NO
                                       FROM work_order_lines
                                      WHERE wol_def_defect_id IS NULL)*/
          AND (CASE
                  WHEN WOR_CHAR_ATTRIB101 = 'APP'
                  THEN
                     WOR_DATE_ATTRIB121 + 1 - (1 / (24 * 60 * 60))
                  WHEN WOR_CHAR_ATTRIB101 = 'CND'
                  THEN
                     WOR_DATE_ATTRIB122 + 1 - (1 / (24 * 60 * 60))
                  ELSE
                     wor.wor_est_complete + 1 - (1 / (24 * 60 * 60))
               END) >= (SYSDATE - 365)
          AND wol_rse_he_id = ele_sec.element_id
          AND WOL_ICB_WORK_CODE = bud_sec.budget_code;