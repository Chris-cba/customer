Select 
WORKS_ORDER_NUMBER,
Navigator,
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             'TRUE', 'Y',
             'N'),'N','<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'
                ,'<a href="javascript:showWODefOnMap('''||WORKs_ORDER_NUMBER||''',''~'');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>') map ,
decode(x_im_wo_has_doc(works_order_number,'WORK_ORDERS'),0,
              '<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'
             ,'<a href="javascript:showWODocAssocs('''||works_order_number||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>') DOCS,
CONTRACTOR_CODE,
ORIGINATOR_NAME,
CONTACT CONTACT,
DEFECT_ID DEFECT_ID,
DEFECT_PRIORITY,
LOCATION_DESCRIPTION,
DEFECT_DESCRIPTION,
REPAIR_DESCRIPTION,
REPAIR_CATEGORY,
DATE_RAISED DATE_RAISED,
EOT_Date_Requested "Requested EOT Date",
DATE_INSTRUCTED,
estimated_cost,
actual_cost,
works_order_status,
scheme_type,
scheme_type_description,
work_category,
work_category_description,
authorised_by_name,
DATE_REPAIRED,
date_completed,
WO_Process_Status, --100
WO_Reason_for_Hold, --104
WOR_CHAR_ATTRIB106 "WO Process Status Comment",
WO_Extension_of_Time_Status, --101
EOT_Reason_for_Request,
EOT_Reason_for_Rejection,
EOT_Conditional_Date,  --102
COST_CODE,
 Borough
from X_LOHAC_IM_IM41037a_POD
where 1=1
--
--and  NVL(WO_Reason_for_Hold, 'NO_REASON') = :P6_PARAM2
AND range_value = :P6_PARAM1
--
order by works_order_number,WORK_ORDER_LINE_ID
