SET DEFINE OFF;
--
delete from im_pod_sql where ips_ip_id in (46,357,352) and ips_seq = 1;
--
SET DEFINE OFF;
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (20, 46, 1, 'select
WOR_WORKS_ORDER_NO WORK_ORDER_NUMBER,
Navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, WOR_WORKS_ORDER_NO),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showPopUpMap(''''''||WOR_WORKS_ORDER_NO||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map 
,decode(im_framework.has_doc(WOR_WORKS_ORDER_NO,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||WOR_WORKS_ORDER_NO||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
, defect_id
, DEF_DEFECT_CODE "Repair Type"
, DEF_PRIORITY "DEFECT PRIORITY"
, DEF_INSPECTION_DATE "Date Inspected"
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 req_eot_date "Requested EOT Date",
 rec_eot_date "EOT Recommended Target Date",
  "EOT Reason for Request",
  (select hus_name  from hig_users where hus_user_id = WOR_NUM_ATTRIB10)	"EOT Reviewed By",
   "EOT Reason for Rejection",
 "WO Process Status",
 "Works Order Originator",
DEF_DEFECT_DESCR "Defect Description",
WOR_DATE_CONFIRMED "Date Instructed",
WOR_EST_COST ESTIMATE_COST,
WOR_ACT_COST ACTUAL_COST,
WOR_DATE_RAISED "Date Raised",
 DUE_DATE,
  WORK_ORDER_STATUS,
  BUDGET_CODE
--
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
--and WOL_DEF_DEFECT_ID is null commented by Ian?
and CONTRACT in (''HR'', ''HTO'', ''SMCI'', ''SR'', ''STO'')
and range_value =  :P6_PARAM1', '1', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (285, 352, 1, 'select
WOR_WORKS_ORDER_NO WORK_ORDER_NUMBER,
Navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, WOR_WORKS_ORDER_NO),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showPopUpMap(''''''||WOR_WORKS_ORDER_NO||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map 
,decode(im_framework.has_doc(WOR_WORKS_ORDER_NO,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||WOR_WORKS_ORDER_NO||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
, defect_id
, DEF_DEFECT_CODE "Repair Type"
, DEF_PRIORITY "DEFECT PRIORITY"
, DEF_INSPECTION_DATE "Date Inspected"
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 req_eot_date "Requested EOT Date",
 rec_eot_date "EOT Recommended Target Date",
  "EOT Reason for Request",
  (select hus_name  from hig_users where hus_user_id = WOR_NUM_ATTRIB10)	"EOT Reviewed By",
   "EOT Reason for Rejection",
 "WO Process Status",
 "Works Order Originator",
DEF_DEFECT_DESCR "Defect Description",
WOR_DATE_CONFIRMED "Date Instructed",
WOR_EST_COST ESTIMATE_COST,
WOR_ACT_COST ACTUAL_COST,
WOR_DATE_RAISED "Date Raised",
 DUE_DATE,
  WORK_ORDER_STATUS,
  BUDGET_CODE
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
and WOL_DEF_DEFECT_ID is null  -- commented out on server
and CONTRACT <> ''SC''
and range_value =  :P6_PARAM1', 'Series 1', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (290, 357, 1, 'select
WOR_WORKS_ORDER_NO WORK_ORDER_NUMBER,
Navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, WOR_WORKS_ORDER_NO),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showPopUpMap(''''''||WOR_WORKS_ORDER_NO||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map 
,decode(im_framework.has_doc(WOR_WORKS_ORDER_NO,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||WOR_WORKS_ORDER_NO||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
, defect_id
, DEF_DEFECT_CODE "Repair Type"
, DEF_PRIORITY "DEFECT PRIORITY"
, DEF_INSPECTION_DATE "Date Inspected"
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 req_eot_date "Requested EOT Date",
 rec_eot_date "EOT Recommended Target Date",
  "EOT Reason for Request",
  (select hus_name  from hig_users where hus_user_id = WOR_NUM_ATTRIB10)	"EOT Reviewed By",
   "EOT Reason for Rejection",
 "WO Process Status",
 "Works Order Originator",
DEF_DEFECT_DESCR "Defect Description",
WOR_DATE_CONFIRMED "Date Instructed",
WOR_EST_COST ESTIMATE_COST,
WOR_ACT_COST ACTUAL_COST,
WOR_DATE_RAISED "Date Raised",
 DUE_DATE,
  WORK_ORDER_STATUS,
  BUDGET_CODE
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
--and WOL_DEF_DEFECT_ID is null  -- COmmented out on the server, maybe by Ian
and CONTRACT in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
and range_value =  :P6_PARAM1', 'Series 1', 
    'Bar', 'Box');
COMMIT;
