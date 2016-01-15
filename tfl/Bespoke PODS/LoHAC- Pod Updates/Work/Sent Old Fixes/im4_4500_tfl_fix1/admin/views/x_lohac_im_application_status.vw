create or replace force view highways.X_LOHAC_IM_APPLICATION_STATUS as
select * from /*link, range_value, tot "Lump Sum Work" from */
(
With 
Date_range as (
   select * from X_LOHAC_DateRANGE_WK
    )
  --
, haud as (
select max(haud_timestamp) haud_timestamp, haud_pk_id, haud_attribute_name, haud_new_value, r.range_value
from hig_audits, Date_range r
where 1 = 1
and haud_timestamp BETWEEN  r.END_range And r.st_range
and haud_table_name = 'WORK_ORDERS'
and haud_attribute_name = 'WOR_CHAR_ATTRIB110'
and  haud_new_value in ('APP', 'REJ', 'REV')
group by  haud_pk_id, haud_attribute_name, haud_new_value, range_value
)
--
, main as (
SELECT DISTINCT
                          range_value,
                          haud_timestamp,
                           1 reason,
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
