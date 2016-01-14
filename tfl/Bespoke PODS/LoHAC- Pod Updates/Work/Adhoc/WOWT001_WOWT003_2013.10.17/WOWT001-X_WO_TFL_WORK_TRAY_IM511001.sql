CREATE OR REPLACE FORCE VIEW HIGHWAYS.X_WO_TFL_WORK_TRAY_WOW001
(
   WORKS_ORDER_NUMBER,
   WORKS_ORDER_DESCRIPTION,
   NUMBER_OF_LINES,
   DEFECT_PRIORITY,
   HAUD_TIMESTAMP,
   AUTHORISED_BY_ID,
   RANGE_VALUE,
   WORKS_ORDER_HAS_SHAPE,
   ORDER_ESTIMATED_COST,
   DATE_RAISED,
   WOR_CHAR_ATTRIB118
)
AS
--283
   WITH Haud_a
        AS (  SELECT HAUD_PK_ID HAUD_PK_ID,
                     HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                     MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP,
                     HAUD_NEW_VALUE
                FROM HIG_AUDITS
               WHERE     1 = 1
                     AND HAUD_TABLE_NAME = 'WORK_ORDERS'  
                     AND HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                     AND HAUD_NEW_VALUE = 'RDY'
                     AND HAUD_TIMESTAMP BETWEEN (SELECT MIN (st_range)
                                                   FROM X_LOHAC_DateRANGE_WOWT)
                                            AND (SELECT MAX (end_range)
                                                   FROM X_LOHAC_DateRANGE_WOWT)
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, HAUD_NEW_VALUE)       --
                                                                     ,
        haud
        AS (SELECT  h.*, range_value
              FROM haud_a h, X_LOHAC_DateRANGE_WOWT
             WHERE HAUD_TIMESTAMP BETWEEN st_range AND end_range)           --
                                                                 ,
        Haud2
        AS (SELECT r.HAUD_PK_ID REJ_PK_ID
              FROM hig_audits r, haud h
             WHERE     1 = 1
                    and h.HAUD_PK_ID = r.HAUD_PK_ID
                   AND r.HAUD_TABLE_NAME = 'WORK_ORDERS' 
                   AND r.HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                   AND r.HAUD_NEW_VALUE IN ('REJ', 'HLD')
                   and r.HAUD_TIMESTAMP > sysdate - 550)
        ,haud3
        as (SELECT  h.*
              FROM haud h
             WHERE 1=1
             and not exists (select REJ_PK_ID from haud2 where h.HAUD_PK_ID = REJ_PK_ID))
   --
   --select * from haud3   
   SELECT 
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          NVL (wol.defect_priority, 'NON') defect_priority,
          haud_timestamp,
          authorised_by_id,
          range_value,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
          wor.order_estimated_cost,
          wor.date_raised,
          WOR_CHAR_ATTRIB118
     FROM ximf_mai_work_orders_all_attr wor,
          --X_IM511001_WO_vw worv,
          imf_mai_work_order_lines wol,
          nm_members net,
          haud3
    -- haud2
    WHERE     1 = 1
          --AND wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND wor.works_order_number = haud_pk_id
          AND wol.network_element_id = net.nm_ne_id_of
          AND net.nm_obj_type = 'HMBG'
          AND wor.works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = 'RDY'
          --AND HAUD_PK_ID NOT IN (SELECT REJ_PK_ID FROM haud2);