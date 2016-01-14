DROP VIEW HIGHWAYS.x_lohac_im_im41036_pod;

/* Formatted on 13/02/2013 16:08:56 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.X_LOHAC_IM_IM41036_POD
(
   DAYS,
   REASON,
   WORKS_ORDER_NUMBER,
   WOR_CHAR_ATTRIB104
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
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, range_value)
   --
   SELECT range_value days,
          1 reason,
          wor_works_order_no works_order_number,
          WOR_CHAR_ATTRIB104
     FROM work_orders wor,
          work_order_lines wol,
          haud,
          pod_nm_element_security,
          pod_budget_security
    WHERE     1 = 1
          AND wor_works_order_no = haud_pk_id
          AND wor_works_order_no = wol_works_order_no
          AND WOR_CHAR_ATTRIB100 = 'HLD'
          AND UPPER (NVL (wor_DESCR, 'Empty')) NOT LIKE '%**CANCELLED**%'
          AND WOL_STATUS_CODE NOT IN
                 ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC')
          AND pod_nm_element_security.element_id = wol_rse_he_id
          AND pod_budget_security.budget_code = WOL_ICB_WORK_CODE;
