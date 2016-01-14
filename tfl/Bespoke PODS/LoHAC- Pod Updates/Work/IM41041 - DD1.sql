Select 
WORKS_ORDER_NUMBER
,navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             'TRUE', 'Y',
             'N'),'N','<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
                ,'<a href="javascript:showPopUpMap('''||pod_eot_updated.WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map 
,decode(im_framework.has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'
             ,'<a href="javascript:showDocAssocsWT('''||pod_eot_updated.works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>') DOCS
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,"WO EXTENSION OF TIME STATUS" "EOT STATUS"
,EOT_DATE_REQUESTED
,EOT_REQUESTED_BY
,"EOT REASON FOR REQUEST"
,EOT_DATE_REVIEWED
,EOT_DATE_REVIEWED_BY
,"EOT REASON FOR REJECTION"
,"EOT CONDITIONAL DATE" "EOT RECOMMENDED TARGET DATE"
,CONTACT
,DEFECT_ID
,DEFECT_PRIORITY
,DATE_RAISED
,DATE_INSTRUCTED
,ORIGINATOR_NAME
,LOCATION_DESCRIPTION
,DEFECT_DESCRIPTION
,SCHEME_TYPE
,SCHEME_TYPE_DESCRIPTION
,ESTIMATED_COST
,ACTUAL_COST
,COST_CODE
,WORK_CATEGORY
,WORK_CATEGORY_DESCRIPTION
,AUTHORISED_BY_NAME
,"DATE PRICE EXT REQUESTED"
,"REASON FOR PRICING EXTENSION"
,"PRICE EXTENSION ACCEPTED"
 from c_pod_eot_updated_DD pod_eot_updated
where "WO EXTENSION OF TIME STATUS" =  :P6_PARAM1


--------------

Select 
WORKS_ORDER_NUMBER
,navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             'TRUE', 'Y',
             'N'),'N','<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
                ,'<a href="javascript:showPopUpMap('''||pod_eot_updated.WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map 
,decode(im_framework.has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'
             ,'<a href="javascript:showDocAssocsWT('''||pod_eot_updated.works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>') DOCS
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,"WO EXTENSION OF TIME STATUS" "EOT STATUS"
,EOT_DATE_REQUESTED
,EOT_REQUESTED_BY
,"EOT REASON FOR REQUEST"
,EOT_DATE_REVIEWED
,EOT_DATE_REVIEWED_BY
,"EOT REASON FOR REJECTION"
,"EOT CONDITIONAL DATE" "EOT RECOMMENDED TARGET DATE"
,CONTACT
,DEFECT_ID
,DEFECT_PRIORITY
,DATE_RAISED
,DATE_INSTRUCTED
,ORIGINATOR_NAME
,LOCATION_DESCRIPTION
,DEFECT_DESCRIPTION
,SCHEME_TYPE
,SCHEME_TYPE_DESCRIPTION
,ESTIMATED_COST
,ACTUAL_COST
,COST_CODE
,WORK_CATEGORY
,WORK_CATEGORY_DESCRIPTION
,AUTHORISED_BY_NAME
,"DATE PRICE EXT REQUESTED"
,"REASON FOR PRICING EXTENSION"
,"PRICE EXTENSION ACCEPTED"
 from c_pod_eop_updated_DD pod_eot_updated
