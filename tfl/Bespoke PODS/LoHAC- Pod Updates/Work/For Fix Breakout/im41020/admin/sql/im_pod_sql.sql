SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  1150 as IPS_ID,
  332 as IPS_IP_ID,
  20 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown( ''''IM41022'''', ''''''||x.range_value||'''''',
 ''''''||''LS''||'''''');'' as link,
 x.range_value, NVL(data.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and CONTRACT in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        X_LOHAC_DateRANGE_WODC x
where  data.range_value(+) = x.range_value
order by sorter' as IPS_SOURCE_CODE,
  'Lump Sum' as IPS_NAME,
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  246 as IPS_ID,
  332 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown( ''''IM41021'''', ''''''||x.range_value||'''''');'' as link,
 x.range_value, NVL(data.cnt,0) as rec_count
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and CONTRACT <> ''SC''
        and WOL_DEF_DEFECT_ID is null
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        X_LOHAC_DateRANGE_WODC x
where  data.range_value(+) = x.range_value
order by sorter ' as IPS_SOURCE_CODE,
  'Non Defect' as IPS_NAME,
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  1151 as IPS_ID,
  332 as IPS_IP_ID,
  30 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown( ''''IM41023'''', ''''''||x.range_value||'''''',
 ''''''||''OT''||'''''');'' as link,
 x.range_value, NVL(data.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and CONTRACT in (''HR'', ''HTO'', ''SMCI'', ''SR'', ''STO'')
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        X_LOHAC_DateRANGE_WODC x
where  data.range_value(+) = x.range_value
order by sorter' as IPS_SOURCE_CODE,
  'Non Lump Sum' as IPS_NAME,
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  20 as IPS_ID,
  46 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
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
where  target_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
--and WOL_DEF_DEFECT_ID is null commented by Ian?
and CONTRACT in (''HR'', ''HTO'', ''SMCI'', ''SR'', ''STO'')
and range_value =  :P6_PARAM1' as IPS_SOURCE_CODE,
  '1' as IPS_NAME,
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  285 as IPS_ID,
  352 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
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
  (select hus_name  from hig_users where hus_user_id = WOR_NUM_ATTRIB10)    "EOT Reviewed By",
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
where  target_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
and WOL_DEF_DEFECT_ID is null  -- commented out on server
and CONTRACT <> ''SC''
and range_value =  :P6_PARAM1' as IPS_SOURCE_CODE,
  'Series 1' as IPS_NAME,
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  290 as IPS_ID,
  357 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
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
  (select hus_name  from hig_users where hus_user_id = WOR_NUM_ATTRIB10)    "EOT Reviewed By",
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
where  target_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
--and WOL_DEF_DEFECT_ID is null  -- COmmented out on the server, maybe by Ian
and CONTRACT in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
and range_value =  :P6_PARAM1' as IPS_SOURCE_CODE,
  'Series 1' as IPS_NAME,
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
