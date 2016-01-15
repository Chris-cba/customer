SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_PODS A USING
 (SELECT
  86 as IP_ID,
  'IM41038a' as IP_HMO_MODULE,
  'Held Work Orders Report - TOR' as IP_TITLE,
  'Held Work Orders Report' as IP_DESCR,
  'IM41036' as IP_PARENT_POD_ID,
  'N' as IP_DRILL_DOWN,
  'Table' as IP_TYPE,
  NULL as IP_GROUP,
  NULL as IP_HEADER,
  NULL as IP_FOOTER,
  0 as IP_CACHE_TIME
  FROM DUAL) B
ON (A.IP_ID = B.IP_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IP_ID, IP_HMO_MODULE, IP_TITLE, IP_DESCR, IP_PARENT_POD_ID, 
  IP_DRILL_DOWN, IP_TYPE, IP_GROUP, IP_HEADER, IP_FOOTER, 
  IP_CACHE_TIME)
VALUES (
  B.IP_ID, B.IP_HMO_MODULE, B.IP_TITLE, B.IP_DESCR, B.IP_PARENT_POD_ID, 
  B.IP_DRILL_DOWN, B.IP_TYPE, B.IP_GROUP, B.IP_HEADER, B.IP_FOOTER, 
  B.IP_CACHE_TIME)
WHEN MATCHED THEN
UPDATE SET 
  A.IP_HMO_MODULE = B.IP_HMO_MODULE,
  A.IP_TITLE = B.IP_TITLE,
  A.IP_DESCR = B.IP_DESCR,
  A.IP_PARENT_POD_ID = B.IP_PARENT_POD_ID,
  A.IP_DRILL_DOWN = B.IP_DRILL_DOWN,
  A.IP_TYPE = B.IP_TYPE,
  A.IP_GROUP = B.IP_GROUP,
  A.IP_HEADER = B.IP_HEADER,
  A.IP_FOOTER = B.IP_FOOTER,
  A.IP_CACHE_TIME = B.IP_CACHE_TIME;

COMMIT;


SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  93 as IPS_ID,
  86 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select 
WORKS_ORDER_NUMBER,
Navigator,
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
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
from X_LOHAC_IM_IM41038a_POD
where 1=1
--
--and  NVL(WO_Reason_for_Hold, ''NO_REASON'') = :P6_PARAM2
AND range_value = :P6_PARAM1
--
order by works_order_number,WORK_ORDER_LINE_ID
' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

COMMIT;
