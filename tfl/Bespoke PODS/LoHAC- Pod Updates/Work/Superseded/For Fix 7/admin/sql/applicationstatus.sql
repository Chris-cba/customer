create or replace view X_LOHAC_IM_APPLICATION_STATUS as
select * from /*link, range_value, tot "Lump Sum Work" from */
(
    With 
    Date_range as (
        select * from X_LOHAC_DateRANGE_WK
        ) 
    ,Haud_a
        AS (            select wor_works_order_no haud_pk_id, WOR_CHAR_ATTRIB110 HAUD_NEW_VALUE, WOR_DATE_ATTRIB131 HAUD_TIMESTAMP
          from work_orders
          where 1=1
             AND WOR_CHAR_ATTRIB110 in  ('REV', 'REVUPD','REVCOMM','APPCOMM','APP','REJCOMM','REJ','INTREJ','APPUN')
             AND WOR_DATE_ATTRIB131 BETWEEN (select min(st_range) from Date_range) AND (select max(end_range) from Date_range)
            )            
      , haud as (
          select h.*, range_value from haud_a h, Date_range 
          where   HAUD_TIMESTAMP BETWEEN st_range AND end_range 
          )
--
, main as (
SELECT DISTINCT
                          range_value,
                          haud_timestamp,
                           1 reason,
						   wol.budget_id,
                           works_order_number,
						   haud_new_value,  -- this and WOR_CHAR_ATTRIB110 should be the same value
						   WOR_CHAR_ATTRIB110
                      FROM imf_mai_work_orders_all_attrib wor,
                           imf_mai_work_order_lines wol,
                           haud,                           
                           pod_nm_element_security,
                           pod_budget_security
                     WHERE     works_order_number = haud_pk_id  
							AND  WOR_CHAR_ATTRIB110 = haud_new_value
                           AND works_order_number = work_order_number
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category                       
                           )     
       select  * from Main
       )
	   ;
