/* Needs
	LSW
			BDG
	BOQ
			SCH
	TOHLD
	WCC
	3RD
	NPH
	VIS
	PRI
	NOT
	CSH
			RISKTFL
	TOREQ
*/



--LSW
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'LSW'||''');'  as link
, r2.range_value,nvl("Lum_Sum_Work",0) "Lum Sum Work" from
(select days,sum(reason) "Lum_Sum_Work" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'LSW'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--BOQ
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'BOQ'||''');'  as link
, r2.range_value,nvl("BOQ_Not_Correct",0) "BOQ Not Correct" from
(select days,sum(reason) "BOQ_Not_Correct" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'BOQ'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--TOHLD
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'TOHLD'||''');'  as link
, r2.range_value,nvl("Task_Order_Held",0) "Task Order Held" from
(select days,sum(reason) "Task_Order_Held" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'TOHLD'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--WCC
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'WCC'||''');'  as link
, r2.range_value,nvl("Wrong_Cost_Code",0) "Wrong Cost Code" from
(select days,sum(reason) "Wrong_Cost_Code" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'WCC'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--3RD
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'3RD'||''');'  as link
, r2.range_value,nvl("Third_Party_Damage",0) "Third Party Damage" from
(select days,sum(reason) "Third_Party_Damage" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = '3RD'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--NPH
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'NPH'||''');'  as link
, r2.range_value,nvl("No_Photos",0) "No Photos" from
(select days,sum(reason) "No_Photos" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'NPH'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--VIS
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'VIS'||''');'  as link
, r2.range_value,nvl("No_Visible_Defect",0) "No Visible Defect" from
(select days,sum(reason) "No_Visible_Defect" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'VIS'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--PRI
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'PRI'||''');'  as link
, r2.range_value,nvl("Incorrect_Defect_Priority",0) "Incorrect Defect Priority" from
(select days,sum(reason) "Incorrect_Defect_Priority" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'PRI'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id


--NOT
select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'NOT'||''');'  as link
, r2.range_value,nvl("Not_On_TLRN",0) "Not On TLRN" from
(select days,sum(reason) "Not_On_TLRN" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'NOT'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id


--CSH

select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'CSH'||''');'  as link
, r2.range_value,nvl("Cancel_Add_Defect_To_Scheme",0) "Cancel Add Defect To Scheme" from
(select days,sum(reason) "Cancel_Add_Defect_To_Scheme" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'CSH'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--TOREQ

select 'javascript:doDrillDown( ''IM41038'','''|| r2.range_value||''',  '''||'TOREQ'||''');'  as link
, r2.range_value,nvl("TO_ReQuote_Required",0) "TO ReQuote Required" from
(select days,sum(reason) "TO_ReQuote_Required" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = 'WORK_ORDERS'
and works_order_number=work_order_number
and nvl(works_order_description,'Empty') not like '%**Cancelled**%'
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED')
and WOR_CHAR_ATTRIB100 = 'HLD'
and WOR_CHAR_ATTRIB104 = 'TOREQ'
and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                    and haud_new_value = 'HLD')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id
