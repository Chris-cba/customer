   create or replace view c_pod_eop_updated_nobud as      
   --
With Haud as
    (SELECT HAUD_PK_ID HAUD_PK_ID, 
                    HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                    MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP
               FROM HIG_AUDITS
              WHERE 1=1
                    AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                    and HAUD_ATTRIBUTE_NAME = 'WOR_DATE_ATTRIB129'
                    AND HAUD_NEW_VALUE IS NOT null
                    AND HAUD_TIMESTAMP >= SYSDATE - 30.1                   
           GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME)  
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
        WORKS_ORDER_NUMBER,
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB101',
                                           WOR.WOR_CHAR_ATTRIB101)
             AS "WO_EOP",
          1 REQUESTS
     FROM XIMF_MAI_WO_ALL_ATTR_NO_SEC wor,
          WOL,
          CONTRACTS C, 
        (SELECT HAUD_PK_ID RA_HAUD_PK_ID, HAUD_ATTRIBUTE_NAME RA_HAUD_ATTRIBUTE_NAME, HAUD_TIMESTAMP RA_MAX_TS FROM HAUD) RA
    WHERE     1=1
        --and intialrepeat.haud_pk_id(+) = WOR.WORKS_ORDER_NUMBER
        and wor.works_order_number=WOL_WORKS_ORDER_NO(+)
           AND WOR.WORKS_ORDER_NUMBER = RA_HAUD_PK_ID
           AND WOL_BUD_ID is null
		   and  nvl(WOR_CHAR_ATTRIB118 , 'BLANK') <> 'BLANK'
          AND WOL_STATUS_CODE(+) NOT IN  ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC' )
          AND upper(NVL (WORKS_ORDER_DESCRIPTION, 'EMPTY')) NOT LIKE '%**CANCELLED**%'   --Added upper to get the 'Cancelled' cases
          AND NVL (WOR_CHAR_ATTRIB100, 'EMPTY') NOT IN ('REJ', 'HLD')
          AND WOR.CONTRACT_ID(+) = C.CON_ID
             AND WOR_DATE_ATTRIB129 IS NOT NULL
          and (x_get_im_user_id in (Select HUS_USER_ID from X_LOHAC_NoBudget_Security) OR x_get_im_user_id = ORIGINATOR_ID)
		  AND WOr.NETWORK_ELEMENT_ID in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
		  ;