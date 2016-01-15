 create or replace view X_LOHAC_IM_IM41037a_POD as 
   WITH Haud_a
        AS (  SELECT HAUD_PK_ID HAUD_PK_ID,
                     HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                     MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, HAUD_NEW_VALUE                     
                FROM HIG_AUDITS, POD_DAY_RANGE r
               WHERE     1 = 1
                     AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                     AND HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB100'
                     AND HAUD_NEW_VALUE = 'REJ'
                     AND HAUD_TIMESTAMP BETWEEN (select min(st_range) from pod_day_range) AND (select max(end_range) from pod_day_range)
            GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, HAUD_NEW_VALUE)
            --
          , haud as (
          select h.*, range_value from haud_a h, pod_day_range where   HAUD_TIMESTAMP BETWEEN st_range AND end_range 
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
Select distinct 
'<a href="javascript:openForms(''WORK_ORDERS'','''||wor.works_order_number||''');">Navigator' Navigator,
wol.wol_id WORK_ORDER_LINE_ID,
wor.WORKS_ORDER_NUMBER WORKS_ORDER_NUMBER,
wor.CONTRACTOR_CODE CONTRACTOR_CODE,
wor.ORIGINATOR_NAME ORIGINATOR_NAME,
wor.CONTACT CONTACT,
wol.wol_def_defect_id DEFECT_ID,
wol.def_priority DEFECT_PRIORITY,
NVL (wol.def_locn_descr, wol.wol_locn_descr)   LOCATION_DESCRIPTION,
wol.def_defect_descr DEFECT_DESCRIPTION,
wol.rep_descr REPAIR_DESCRIPTION,
wol.rep_action_cat REPAIR_CATEGORY,
wor.DATE_RAISED DATE_RAISED,
wor.WOR_DATE_ATTRIB121 as EOT_Date_Requested,
wor.DATE_INSTRUCTED DATE_INSTRUCTED,
WOL_EST_COST estimated_cost,
WOL_ACT_COST actual_cost,
wor.WORKS_ORDER_STATUS works_order_status,
wor.SCHEME_TYPE scheme_type,
wor.SCHEME_TYPE_DESCRIPTION scheme_type_description,
wol.wol_icb_work_code work_category,
null  work_category_description,
wor.AUTHORISED_BY_NAME authorised_by_name,
WOL_DATE_REPAIRED DATE_REPAIRED,
WOL_DATE_COMPLETE  date_completed,
wor.WOR_CHAR_ATTRIB100 as WO_Process_Status,
wor.WOR_CHAR_ATTRIB101 as WO_Extension_of_Time_Status,
wor.WOR_CHAR_ATTRIB102 as EOT_Reason_for_Request,
wor.WOR_CHAR_ATTRIB103 as EOT_Reason_for_Rejection,
wor.WOR_CHAR_ATTRIB104 as WO_Reason_for_Hold,
wor.WOR_CHAR_ATTRIB105 as WO_Reason_for_Rejection,
wor.WOR_DATE_ATTRIB122 as EOT_Conditional_Date,
wor.WOR_CHAR_ATTRIB106, 
null COST_CODE,
parent_element_description as Borough,
haud.range_value
from XIMF_MAI_WO_ALL_ATTR_NO_SEC wor
    ,wol       
    ,HAUD 
where 1=1
and wor.works_order_number=WOL_WORKS_ORDER_NO(+)
and wor.works_order_number = haud_pk_id
AND WOL_BUD_ID is null
and Upper(nvl(works_order_description,'Empty')) not like upper('%**Cancelled**%')
AND WOL_STATUS_CODE(+) NOT IN  ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC' )
and (x_get_im_user_id in (Select HUS_USER_ID from X_LOHAC_NoBudget_Security) OR x_get_im_user_id = ORIGINATOR_ID)
and WOR_CHAR_ATTRIB100 = HAUD_NEW_VALUE
AND WOr.NETWORK_ELEMENT_ID in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
;

