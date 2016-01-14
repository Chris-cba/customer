CREATE OR REPLACE VIEW X_WO_TFL_WORK_TRAY_IM511002
(
   WORKS_ORDER_NUMBER,
   DESCRIPTION,
   NUMBER_OF_LINES,
   DEFECT_PRIORITY,
   HAUD_TIMESTAMP,
   AUTHORISED_BY_ID,
   WORKS_ORDER_HAS_SHAPE,
   ESTIMATED_COST,
   DATE_RAISED
)
AS
   SELECT DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          wol.defect_priority,
          haud_timestamp,
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
          X_IM511002_WO_vw worv,
          ximf_mai_work_order_lines wol,
          nm_members net,
          hig_audits_vw
    WHERE     wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND wor.works_order_number = haud_pk_id
          AND haud_table_name = 'WORK_ORDERS'
          AND wol.network_element_id = net.nm_ne_id_of
          AND net.nm_obj_type = 'HMBG'
          AND works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = 'RDY'
          AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
          AND haud_timestamp =
                 (SELECT MAX (haud_timestamp)
                    FROM hig_audits_vw
                   WHERE     haud_pk_id = wor.works_order_number
                         AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                         AND haud_new_value = 'RDY')
          AND haud_old_value IN ('REJ', 'HLD');    
 