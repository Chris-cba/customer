create or replace view X_WO_TFL_WORK_TRAY_WOW001 as
   WITH Haud_a
        AS (  SELECT HAUD_PK_ID HAUD_PK_ID,
                     HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                     MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, HAUD_NEW_VALUE                     
                FROM HIG_AUDITS
               WHERE     1 = 1
                     AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                     AND HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                     AND HAUD_NEW_VALUE = 'RDY'
                     AND HAUD_TIMESTAMP BETWEEN (select min(st_range) from X_LOHAC_DateRANGE_WOWT) AND (select max(end_range) from X_LOHAC_DateRANGE_WOWT)
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, HAUD_NEW_VALUE)
            --
          , haud as (
          select h.*, range_value from haud_a h, X_LOHAC_DateRANGE_WOWT where   HAUD_TIMESTAMP BETWEEN st_range AND end_range 
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
          AND HAUD_PK_ID not in (select  REJ_PK_ID from haud2);