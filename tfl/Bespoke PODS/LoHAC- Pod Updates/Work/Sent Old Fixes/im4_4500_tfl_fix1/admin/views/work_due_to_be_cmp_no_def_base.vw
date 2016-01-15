Create or replace view work_due_to_be_cmp_no_def_base 
AS
   SELECT WOR_WORKS_ORDER_NO,
          substr(con_code,instr(con_code,'_')+1) contract,
          WOR_CHAR_ATTRIB100 wo_pro_stat,
          WOR_CHAR_ATTRIB101 eot_status,
          WOR_DATE_ATTRIB121 req_eot_date,
          WOR_DATE_ATTRIB122 rec_eot_date,
		  WOL_DEF_DEFECT_ID  WOL_Defect_ID,
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
            WHERE 1=1 and vwor.wor_works_order_no = wor.wor_works_order_no and rownum = 1)
             work_order_status
     FROM work_orders wor,
          work_order_lines wol,
		  contracts,
          pod_nm_element_security ele_sec,
          pod_budget_security bud_sec
    WHERE     1=1
	AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('REJ', 'HLD')
	AND wor_con_id = con_id
          AND wor.WOR_WORKS_ORDER_NO = wol.WOL_WORKS_ORDER_NO
          --AND SUBSTR (wor.WOR_WORKS_ORDER_NO, 5, 2) != 'CS'
          AND WOR_WORKS_ORDER_NO IN (SELECT WOL_WORKS_ORDER_NO
                                       FROM work_order_lines
                                      WHERE wol_def_defect_id IS NULL)
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