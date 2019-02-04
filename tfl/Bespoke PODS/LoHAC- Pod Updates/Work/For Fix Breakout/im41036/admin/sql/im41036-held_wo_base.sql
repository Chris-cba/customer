 
 create or replace view X_LOHAC_IM_IM41036_POD as
   WITH Haud_a
        AS (  SELECT HAUD_PK_ID HAUD_PK_ID,
                     HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                     MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, HAUD_NEW_VALUE                     
                FROM HIG_AUDITS, POD_DAY_RANGE r
               WHERE     1 = 1
                     AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                     AND HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                     AND HAUD_NEW_VALUE = 'HLD'
                     AND HAUD_TIMESTAMP BETWEEN (select min(st_range) from pod_day_range) AND (select max(end_range) from pod_day_range)
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, HAUD_NEW_VALUE)
            --
          , haud as (
          select h.*, range_value from haud_a h, pod_day_range where   HAUD_TIMESTAMP BETWEEN st_range AND end_range 
          )
   --
   SELECT range_value days,
          1 reason,
          wor_works_order_no works_order_number,
          WOR_CHAR_ATTRIB104,
		  wol.WOL_DEF_DEFECT_ID
     FROM work_orders wor,
          work_order_lines wol,
          haud,
          pod_nm_element_security,
          pod_budget_security
    WHERE     1 = 1
          AND wor_works_order_no = haud_pk_id
          AND wor_works_order_no = wol_works_order_no
          AND WOR_CHAR_ATTRIB100 = HAUD_NEW_VALUE
          AND UPPER (NVL (wor_DESCR, 'Empty')) NOT LIKE '%**CANCELLED**%'
          AND WOL_STATUS_CODE NOT IN ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC')
          AND pod_nm_element_security.element_id = wol_rse_he_id
          AND pod_budget_security.budget_code = WOL_ICB_WORK_CODE;
