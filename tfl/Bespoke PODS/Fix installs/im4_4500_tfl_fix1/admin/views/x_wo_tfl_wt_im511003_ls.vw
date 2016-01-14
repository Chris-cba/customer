CREATE OR REPLACE FORCE VIEW HIGHWAYS.X_WO_TFL_WT_IM511003_LS
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT                                                                   --
         DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          authorised_by_id,
          DECODE (
             mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'),
                                        wor.works_order_number),
             'TRUE', 'Y',
             'N')
             works_order_has_shape,
          wor.order_estimated_cost,
          wor.date_raised
     FROM ximf_mai_work_orders_all_attr wor,
          x_im511003_wo_vw worv,
          ximf_mai_work_order_lines wol
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND works_order_status = 'DRAFT'
          AND NVL (works_order_description, 'Empty') NOT LIKE
                 '%**Cancelled**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('RDY', 'HLD', 'REJ')
          AND wor.works_order_number LIKE '%LS%';
