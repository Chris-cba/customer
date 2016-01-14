Select 
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             'TRUE', 'Y',
             'N'),'N','<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
             ,'<a href="javascript:showWODefOnMap('''||WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map ,
decode(x_im_wo_has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'
             ,'<a href="javascript:showWODocAssocs('''||works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>') DOCS
 --
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,"WO EXTENSION OF TIME STATUS"
,"EOT DATE REQUESTED"
,EOT_Requested_By
,"EOT REASON FOR REQUEST"
,Contact
,Defect_ID
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
,"DATE PRICE EXTENSION REQUESTED"
, "REASON FOR PRICING EXTENSION"
from c_pod_eot_requests
where UPPER(req)= 'INITIAL'
and "EOT DATE REQUESTED" is not null --WOR_CHAR_ATTRIB121 
and days = :P6_PARAM1