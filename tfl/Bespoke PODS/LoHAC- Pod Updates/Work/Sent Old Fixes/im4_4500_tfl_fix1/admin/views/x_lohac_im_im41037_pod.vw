 create or replace view X_LOHAC_IM_IM41037_POD as 
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
                --AND range_value = :P6_PARAM1
       GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, range_value)
--
Select distinct 
'<a href="javascript:openForms(''WORK_ORDERS'','''||wor.works_order_number||''');">Navigator' Navigator,
wol.WORK_ORDER_LINE_ID WORK_ORDER_LINE_ID,
wor.WORKS_ORDER_NUMBER WORKS_ORDER_NUMBER,
wor.CONTRACTOR_CODE CONTRACTOR_CODE,
wor.ORIGINATOR_NAME ORIGINATOR_NAME,
wor.CONTACT CONTACT,
wol.DEFECT_ID DEFECT_ID,
wol.DEFECT_PRIORITY DEFECT_PRIORITY,
wol.LOCATION_DESCRIPTION LOCATION_DESCRIPTION,
def.DEFECT_DESCRIPTION DEFECT_DESCRIPTION,
def.REPAIR_DESCRIPTION REPAIR_DESCRIPTION,
def.REPAIR_CATEGORY REPAIR_CATEGORY,
wor.DATE_RAISED DATE_RAISED,
wor.WOR_DATE_ATTRIB121 as EOT_Date_Requested,
wor.DATE_INSTRUCTED DATE_INSTRUCTED,
wol.ESTIMATED_COST estimated_cost,
wol.ACTUAL_COST actual_cost,
wor.WORKS_ORDER_STATUS works_order_status,
wor.SCHEME_TYPE scheme_type,
wor.SCHEME_TYPE_DESCRIPTION scheme_type_description,
wol.WORK_CATEGORY work_category,
wol.WORK_CATEGORY_DESCRIPTION work_category_description,
wor.AUTHORISED_BY_NAME authorised_by_name,
wol.DATE_REPAIRED DATE_REPAIRED,
wol.DATE_COMPLETED date_completed,
wor.WOR_CHAR_ATTRIB100 as WO_Process_Status,
wor.WOR_CHAR_ATTRIB101 as WO_Extension_of_Time_Status,
wor.WOR_CHAR_ATTRIB102 as EOT_Reason_for_Request,
wor.WOR_CHAR_ATTRIB103 as EOT_Reason_for_Rejection,
wor.WOR_CHAR_ATTRIB104 as WO_Reason_for_Hold,
wor.WOR_CHAR_ATTRIB105 as WO_Reason_for_Rejection,
wor.WOR_DATE_ATTRIB122 as EOT_Conditional_Date,
wor.WOR_CHAR_ATTRIB106, 
bud.COST_CODE,
net.parent_element_description as Borough
,haud.range_value
from ximf_mai_work_orders_all_attr wor
    ,ximf_mai_work_order_lines wol
    ,imf_mai_defect_repairs def
    ,imf_mai_budgets bud
    ,imf_net_network_members net
    ,HAUD    
    ,pod_nm_element_security
   ,pod_budget_security
where 1=1
and wor.works_order_number=work_order_number
and wol.defect_id = def.defect_id   (+)
and wol.budget_id = bud.budget_id
and wor.works_order_number = haud_pk_id
and wol.network_element_id = child_element_id
and parent_group_type = 'HMBG'
and Upper(nvl(works_order_description,'Empty')) not like upper('%**Cancelled**%')
and work_order_line_status not in ('COMPLETED','ACTIONED','INSTRUCTED', 'PRELOHAC')
and WOR_CHAR_ATTRIB100 = 'REJ'
--and  NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') = :P6_PARAM2
--
AND pod_nm_element_security.element_id = wol.network_element_id --wol_rse_he_id
AND pod_budget_security.budget_code = wol.work_category --WOL_ICB_WORK_CODE
;