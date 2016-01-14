 
 create or replace view X_LOHAC_IM_IM41036_POD_NOBUD as
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
SELECT  
    range_value days,
    1 reason,
     wor_works_order_no works_order_number,
     'NO_BUD' WOR_CHAR_ATTRIB104,
     WOR_CHAR_ATTRIB100
FROM work_orders wor,
    work_order_lines wol,
    haud  
WHERE    1=1
    AND wor_works_order_no = haud_pk_id    
    AND wor_works_order_no =  wol_works_order_no(+)
    AND wor.WOR_CHAR_ATTRIB100 = HAUD_NEW_VALUE  
	and  nvl(WOR_CHAR_ATTRIB118 , 'BLANK') <> 'BLANK'
    AND upper(NVL (wor_DESCR, 'Empty')) NOT LIKE '%**CANCELLED**%'
    AND WOL_STATUS_CODE(+) NOT IN  ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC' )
    AND WOL_BUD_ID is null
    AND WOr.wor_rse_he_id_group in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
    and (x_get_im_user_id in (Select HUS_USER_ID from X_LOHAC_NoBudget_Security) OR x_get_im_user_id = WOR_PEO_PERSON_ID)
    ;
