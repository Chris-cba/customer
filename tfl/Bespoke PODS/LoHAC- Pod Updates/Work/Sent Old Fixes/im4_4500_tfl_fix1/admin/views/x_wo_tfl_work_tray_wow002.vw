create or replace view X_WO_TFL_WORK_TRAY_WOW002 as
With HAUD as
(
SELECT HAUD_PK_ID HAUD_PK_ID, HAUD_NIT_INV_TYPE,
                    HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                    MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, range_value
               FROM HIG_AUDITS, X_LOHAC_DateRANGE_WOWT
              WHERE 1=1
                    AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                    and HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                    AND HAUD_NEW_VALUE = 'RDY'
                    AND HAUD_TIMESTAMP between      st_range and    end_range          
           GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME,HAUD_NIT_INV_TYPE, range_value
) 
--
,Haud2 as (select HAUD_PK_ID REJ_PK_ID 
            from hig_audits 
            WHERE 1=1
                    AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                    and HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                    AND HAUD_NEW_VALUE IN ('REJ', 'HLD')
            )
--
 SELECT DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          NVL(wol.defect_priority, 'NON') defect_priority,
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
          wor.date_raised
          ,WOR_CHAR_ATTRIB118
     FROM ximf_mai_work_orders_all_attr wor,
          --X_IM511001_WO_vw worv,
          imf_mai_work_order_lines wol,
          nm_members net,
          haud
         -- haud2
    WHERE     1=1
            --AND wor.works_order_number = worv.work_order_number
          AND wor.works_order_number = wol.work_order_number
          AND wor.works_order_number = haud_pk_id          
          AND wol.network_element_id = net.nm_ne_id_of
          AND net.nm_obj_type = 'HMBG'
          AND wor.works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = 'RDY' 
          AND HAUD_PK_ID in (select  REJ_PK_ID from haud2);