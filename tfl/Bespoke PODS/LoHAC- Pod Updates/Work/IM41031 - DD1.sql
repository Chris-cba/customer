select 
--WORKS_ORDER_NUMBER,
--
'<a href="javascript:openForms(''DEFECTS'','''||defect_id||''');">Navigator' Navigator
,decode( (select def_defect_id from vw_mai_defects_sdo where def_defect_id = defect_id),null, '<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
       ,'<a href="javascript:showFeatureOnMap('''||defect_id||''',''IM_DEFECTS'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map
,decode(im_framework.has_doc(DEFECT_ID,'DEFECTS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'
             ,'<a href="javascript:showDocAssocsWT('''||defect_id||''',&APP_ID.,&APP_SESSION.,''DEFECTS'')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>') DOCS
,def.defect_id
,location_description
,SPECIAL_INSTRUCTIONS
,DEFECT_STATUS
,DEFECT_STATUS_DESCRIPTION
,DATE_INSPECTED
,DATE_RECORDED
,ASSET_TYPE
,ACTIVITY_CODE
,INSPECTION_ID
,ACTIVITY_DESCRIPTION
,PRIORITY
,PRIORITY_DESCRIPTION
,DEFECT_TYPE
,DEFECT_TYPE_DESCRIPTION
,NETWORK_ELEMENT_ID
,NETWORK_ELEMENT_OFFSET
,ASSET_MODIFICATION_CODE
,ASSET_MODIFICATION_DESCRIPTION
--,def.*
--.net.parent_element_description
from x_IM_MAI_DEFECTS def,imf_net_network_members net
where network_element_id = child_element_id
and parent_group_type = 'HMBG'
and defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = :P6_PARAM2
and  (case when trunc(sysdate-date_inspected) <= 1 then '1'when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5' when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60' when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) = :P6_PARAM1