create or replace view X_WO_TFL_WORK_TRAY_WOW001_NOBU as
--
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
    , WOL as
( 
    select * from work_order_Lines wol, defects def, repairs rep   ,imf_net_network_members net 
    where 1=1
    and wol.wol_def_defect_id = def.def_defect_id(+)
    and def_defect_id = rep_def_defect_id
    and wol.wol_rse_he_id = child_element_id(+)
    and parent_group_type = 'HMBG'
)    
--
 SELECT DISTINCT
          (wor.WORKS_ORDER_NUMBER),
          wor.WORKS_ORDER_DESCRiption,
          (SELECT COUNT (*)
             FROM work_order_lines
            WHERE wol_works_order_no = wor.works_order_number)
             number_of_lines,
          wol.def_priority DEFECT_PRIORITY,
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
     FROM XIMF_MAI_WO_ALL_ATTR_NO_SEC wor,
          --X_IM511001_WO_vw worv,
          wol,         
          haud,
          POD_NM_ELEMENT_SECURITY ELE_SEC
         -- haud2
    WHERE     1=1            
          AND wor.works_order_number = wol.WOL_WORKS_ORDER_NO(+)
          AND WOL_ID is null
          AND wor.works_order_number = haud_pk_id        
           AND wor.works_order_status = 'DRAFT'
          AND WOR_CHAR_ATTRIB100 = HAUD_NEW_VALUE
          AND HAUD_PK_ID not in (select  REJ_PK_ID from haud2)
          and  nvl(WOR_CHAR_ATTRIB118 , 'BLANK') <> 'BLANK'
          AND WOr.NETWORK_ELEMENT_ID in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
          ;
          
