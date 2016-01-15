 
 create or replace view X_LOHAC_IM_IM41035_POD as
 With Haud as 
        (SELECT HAUD_PK_ID HAUD_PK_ID, 
                        HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                        MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, range_value
                   FROM HIG_AUDITS, POD_DAY_RANGE r
                  WHERE 1=1
                        AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                        and HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                        AND HAUD_NEW_VALUE = 'REJ'
                        AND HAUD_TIMESTAMP between     r.st_range AND r.end_range                
               GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, range_value) 
           --
SELECT  
    range_value days,
    1 reason,
     wor_works_order_no works_order_number,
    WOR_CHAR_ATTRIB104,
     WOR_CHAR_ATTRIB100
FROM work_orders wor,
    work_order_lines wol,
    haud,    
    pod_nm_element_security,
    pod_budget_security
WHERE    1=1
    AND wor_works_order_no = haud_pk_id    
    AND wor_works_order_no =  wol_works_order_no
    AND wor.WOR_CHAR_ATTRIB100 = 'REJ'  
    AND upper(NVL (wor_DESCR, 'Empty')) NOT LIKE '%**CANCELLED**%'
    AND WOL_STATUS_CODE NOT IN  ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC' )
    AND pod_nm_element_security.element_id = wol_rse_he_id
    AND pod_budget_security.budget_code = WOL_ICB_WORK_CODE
    ;
