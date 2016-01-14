--IM41015

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  95 as IPS_ID,
  108 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select 
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
from C_POD_EOP_REQUESTS_nobud
where  1=1
--work_order_line_status(+) <> ''INSTRUCTED'' 
and "DATE PRICE EXTENSION REQUESTED" is not null --WOR_DATE_ATTRIB129
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
  'EOT Request Report (EOP) - TOR' as IPS_NAME,
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

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  94 as IPS_ID,
  330 as IPS_IP_ID,
  40 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown(''''IM41016d'''',''''''||range_value||'''''', ''''''||''EOP''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) Extension_of_Price_Requested
from c_pod_eop_requests_nobud,pod_day_range
where days(+)=range_value
and "DATE PRICE EXTENSION REQUESTED"(+) is not null --WOR_DATE_ATTRIB129
group by range_value
order by (decode(range_value,''Today'',1,''1-6'',2,''7-30'',3,''31-60'',4,''61-90'',5))' as IPS_SOURCE_CODE,
  'Task Order Requests' as IPS_NAME,
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

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  283 as IPS_ID,
  336 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
where UPPER(req)= ''INITIAL''
and "EOT DATE REQUESTED" is not null --WOR_CHAR_ATTRIB121
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
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
  284 as IPS_ID,
  351 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
where UPPER(req)= ''REPEAT''
and "EOT DATE REQUESTED" is not null --WOR_CHAR_ATTRIB121
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
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
  19 as IPS_ID,
  45 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
from c_pod_eop_requests
where  work_order_line_status(+) <> ''INSTRUCTED''
and "DATE PRICE EXTENSION REQUESTED" is not null --WOR_DATE_ATTRIB129
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
  'EOT Request Report (EOP)' as IPS_NAME,
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
  95 as IPS_ID,
  108 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select 
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
from C_POD_EOP_REQUESTS_nobud
where  1=1
--work_order_line_status(+) <> ''INSTRUCTED'' 
and "DATE PRICE EXTENSION REQUESTED" is not null --WOR_DATE_ATTRIB129
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
  'EOT Request Report (EOP) - TOR' as IPS_NAME,
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


-----------------------------------------------------------------------------
--WOWT001
-----------------------------------------------------------------------------

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  29 as IPS_ID,
  460 as IPS_IP_ID,
  7 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''2H''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  '2H' as IPS_NAME,
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
  30 as IPS_ID,
  460 as IPS_IP_ID,
  6 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''1''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  '-1-' as IPS_NAME,
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
  100 as IPS_ID,
  460 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''15'''', ''''P15_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P15_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW001_NOBU 
        --where  defect_priority = ''2M''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  'Task Order Requests' as IPS_NAME,
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
  1120 as IPS_ID,
  460 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''NON''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  'Non Defective' as IPS_NAME,
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
  1121 as IPS_ID,
  460 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''1 (ECO)''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  '1 (ECO)' as IPS_NAME,
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
  1123 as IPS_ID,
  460 as IPS_IP_ID,
  4 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''2M''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  '2M' as IPS_NAME,
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
  1124 as IPS_ID,
  460 as IPS_IP_ID,
  5 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P10_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, defect_priority, count(*) CNT
        from  X_WO_TFL_WORK_TRAY_WOW001
        where  defect_priority = ''2L''
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  '2L' as IPS_NAME,
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


-----------------------------------------------------------------------------
--IM_LOHAC_AR_00_TOP
-----------------------------------------------------------------------------

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  8 as IPS_ID,
  23 as IPS_IP_ID,
  30 as IPS_SEQ,
  'select link, range_value, tot  from (
        With 
        Date_range as (
            select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  1=1            
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       and (code is null or code = ''REV'')       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Awaiting Review' as IPS_NAME,
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
  16 as IPS_ID,
  23 as IPS_IP_ID,
  80 as IPS_SEQ,
  'select link, range_value, tot "Rej_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REJCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Rejct Awaiting Com Review' as IPS_NAME,
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
  17 as IPS_ID,
  23 as IPS_IP_ID,
  60 as IPS_SEQ,
  'select link, range_value, tot "Appr_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''APPCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )
	   ' as IPS_SOURCE_CODE,
  'Apprvd Awaiting Com Review' as IPS_NAME,
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
  104 as IPS_ID,
  23 as IPS_IP_ID,
  90 as IPS_SEQ,
  'select link, range_value, tot  from (
        With 
        Date_range as (
            select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  1=1            
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       and (code is null or code = ''APPUN'')       
       order by sorter
       ) ' as IPS_SOURCE_CODE,
  'Approved but un-reviewed' as IPS_NAME,
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
  1200 as IPS_ID,
  23 as IPS_IP_ID,
  40 as IPS_SEQ,
  'select link, range_value, tot "Rej_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REVUPD''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Awaiting Review – Updated Application' as IPS_NAME,
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
  1201 as IPS_ID,
  23 as IPS_IP_ID,
  50 as IPS_SEQ,
  'select link, range_value, tot "Awaiting Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REVCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Awaiting Review – New Comments' as IPS_NAME,
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
  1220 as IPS_ID,
  23 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select link, range_value, tot  from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''APP''
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )	' as IPS_SOURCE_CODE,
  'Approved' as IPS_NAME,
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
  1221 as IPS_ID,
  23 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select link, range_value, tot  from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''REJ''
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )	' as IPS_SOURCE_CODE,
  'Rejected' as IPS_NAME,
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
  1222 as IPS_ID,
  23 as IPS_IP_ID,
  70 as IPS_SEQ,
  'select link, range_value, tot  from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''INTREJ''
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )	' as IPS_SOURCE_CODE,
  'Interim Rejected' as IPS_NAME,
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

-----------------------------------------------------------------------------
--IM41020
-----------------------------------------------------------------------------

SET DEFINE OFF;
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

COMMIT;

SET DEFINE OFF;
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  19 as IPS_ID,
  45 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
WORKS_ORDER_NUMBER,
NAVIGATOR,
--
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
from c_pod_eop_requests
where  work_order_line_status(+) <> ''INSTRUCTED''
and "DATE PRICE EXTENSION REQUESTED" is not null --WOR_DATE_ATTRIB129
and days = :P6_PARAM1' as IPS_SOURCE_CODE,
  'EOT Request Report (EOP)' as IPS_NAME,
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


-----------------------------------------------------------------------------
--IM41021
-----------------------------------------------------------------------------

SET DEFINE OFF;
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

COMMIT;

-----------------------------------------------------------------------------
--IM41022
-----------------------------------------------------------------------------

SET DEFINE OFF;
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



-----------------------------------------------------------------------------
--IM41035
-----------------------------------------------------------------------------
SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  258 as IPS_ID,
  334 as IPS_IP_ID,
  90 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NOT''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NOT' as IPS_NAME,
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
  255 as IPS_ID,
  334 as IPS_IP_ID,
  60 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NODEFVIS''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NODEFVIS' as IPS_NAME,
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
  24 as IPS_ID,
  334 as IPS_IP_ID,
  120 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOHOLD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOHOLD' as IPS_NAME,
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
  250 as IPS_ID,
  334 as IPS_IP_ID,
  10 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''LSW''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'LSW' as IPS_NAME,
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
  256 as IPS_ID,
  334 as IPS_IP_ID,
  70 as IPS_SEQ,
  '  SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''PRI''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("INCDEFPRI", 0) "Incorrect Defect Priority"
    FROM (  SELECT days, SUM (reason) "INCDEFPRI"
              FROM (SELECT DISTINCT
                          r.range_value days,
                           1 reason,
                           works_order_number
                      FROM imf_mai_work_orders_all_attrib wor,
                           imf_mai_work_order_lines wol,
                           hig_audits_vw,
                           POD_DAY_RANGE r,
                           pod_nm_element_security,
                           pod_budget_security
                     WHERE     works_order_number = haud_pk_id
                           AND haud_table_name = ''WORK_ORDERS''
                           AND works_order_number = work_order_number
                           AND NVL (works_order_description, ''Empty'') NOT LIKE
                                  ''%**Cancelled**%''
                           AND work_order_line_status NOT IN
                                  (''COMPLETED'', ''ACTIONED'', ''INSTRUCTED'')
                           AND WOR_CHAR_ATTRIB100 = ''REJ''
                           AND WOR_CHAR_ATTRIB104 = ''PRI''
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_value' as IPS_SOURCE_CODE,
  'INCDEFPRI' as IPS_NAME,
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
  253 as IPS_ID,
  334 as IPS_IP_ID,
  40 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''3RDDAM''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  '3RDDAM' as IPS_NAME,
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
  251 as IPS_ID,
  334 as IPS_IP_ID,
  20 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BOQINV''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BOQINV' as IPS_NAME,
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
  252 as IPS_ID,
  334 as IPS_IP_ID,
  30 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CCINV''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CCINV' as IPS_NAME,
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
  254 as IPS_ID,
  334 as IPS_IP_ID,
  50 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NOPOT''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NOPOT' as IPS_NAME,
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
  21 as IPS_ID,
  334 as IPS_IP_ID,
  100 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CNSCHWO''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CNSCHWO' as IPS_NAME,
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
  22 as IPS_ID,
  334 as IPS_IP_ID,
  110 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOREQ''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOREQ' as IPS_NAME,
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
  79 as IPS_ID,
  334 as IPS_IP_ID,
  15 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BDG''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BDG' as IPS_NAME,
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
  90 as IPS_ID,
  334 as IPS_IP_ID,
  170 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41037a'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_BUD'') WOR_CHAR_ATTRIB104 
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD_NOBUD
                     WHERE 1=1
                     AND NVL(WOR_CHAR_ATTRIB104, ''NO_BUD'') = ''NO_BUD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'Task Order Requests' as IPS_NAME,
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

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  287 as IPS_ID,
  354 as IPS_IP_ID,
  1 as IPS_SEQ,
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
WO_Reason_for_Hold as "WO PROCESS STATUS REASON", --104
WOR_CHAR_ATTRIB106 "WO PROCESS STATUS COMMENT",
WO_Extension_of_Time_Status as "EOT STATUS", --101
EOT_Reason_for_Request,
EOT_Reason_for_Rejection,
EOT_Conditional_Date as "EOT Recommednded Target Date",  --102
COST_CODE,
 Borough
from X_LOHAC_IM_IM41037_POD
where 1=1
--
and  NVL(WO_Reason_for_Hold, ''NO_REASON'') = :P6_PARAM2
AND range_value = :P6_PARAM1
--
order by works_order_number,WORK_ORDER_LINE_ID
' as IPS_SOURCE_CODE,
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
  91 as IPS_ID,
  66 as IPS_IP_ID,
  NULL as IPS_SEQ,
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
from X_LOHAC_IM_IM41037a_POD
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

-----------------------------------------------------------------------------
--IM41036
-----------------------------------------------------------------------------

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  259 as IPS_ID,
  335 as IPS_IP_ID,
  10 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''LSW''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'LSW' as IPS_NAME,
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
  260 as IPS_ID,
  335 as IPS_IP_ID,
  20 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BDG''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BDG' as IPS_NAME,
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
  261 as IPS_ID,
  335 as IPS_IP_ID,
  30 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BOQINV''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BOQINV' as IPS_NAME,
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
  61 as IPS_ID,
  335 as IPS_IP_ID,
  50 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''3RDDAM''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  '3RDDAM' as IPS_NAME,
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
  64 as IPS_ID,
  335 as IPS_IP_ID,
  40 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CCINV''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CCINV' as IPS_NAME,
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
  65 as IPS_ID,
  335 as IPS_IP_ID,
  70 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NODEFVIS''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NODEFVIS' as IPS_NAME,
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
  66 as IPS_ID,
  335 as IPS_IP_ID,
  80 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''INCDEFPRI''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'INCDEFPRI' as IPS_NAME,
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
  69 as IPS_ID,
  335 as IPS_IP_ID,
  60 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NOPOT''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NOPOT' as IPS_NAME,
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
  70 as IPS_ID,
  335 as IPS_IP_ID,
  100 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CNSCHWO''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CNSCHWO' as IPS_NAME,
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
  71 as IPS_ID,
  335 as IPS_IP_ID,
  90 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NOT''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NOT' as IPS_NAME,
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
  72 as IPS_ID,
  335 as IPS_IP_ID,
  110 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOREQ''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOREQ' as IPS_NAME,
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
  76 as IPS_ID,
  335 as IPS_IP_ID,
  120 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') WOR_CHAR_ATTRIB104
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOHOLD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOHOLD' as IPS_NAME,
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
  92 as IPS_ID,
  335 as IPS_IP_ID,
  160 as IPS_SEQ,
  ' SELECT    ''javascript:doDrillDown( ''''IM41038a'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || WOR_CHAR_ATTRIB104
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, ''NO_BUD'') WOR_CHAR_ATTRIB104 
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41036_POD_NOBUD
                     WHERE 1=1
                     AND NVL(WOR_CHAR_ATTRIB104, ''NO_BUD'') = ''NO_BUD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'Task Order Requests' as IPS_NAME,
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

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  288 as IPS_ID,
  355 as IPS_IP_ID,
  1 as IPS_SEQ,
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
from X_LOHAC_IM_IM41038_POD
where 1=1
--
and  NVL(WO_Reason_for_Hold, ''NO_REASON'') = :P6_PARAM2
AND range_value = :P6_PARAM1
--
order by works_order_number,WORK_ORDER_LINE_ID
' as IPS_SOURCE_CODE,
  'se' as IPS_NAME,
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


-----------------------------------------------------------------------------
--IM41040
-----------------------------------------------------------------------------
Delete from im_pod_sql where ips_ip_id = 333;

commit;


SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  249 as IPS_ID,
  333 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select Link, item, cnt from (
--
 Select 0 Sorter,
         ''javascript:doDrillDown( ''''IM41041'''', ''''''||b.c||'''''', ''''N/A'''');'' as link
         , b.c item
         ,nvl(cnt,0) cnt
         from
         (
         select "WO EXTENSION OF TIME STATUS" eot
         ,count("WO EXTENSION OF TIME STATUS") cnt
         from c_pod_eot_updated
         group by "WO EXTENSION OF TIME STATUS"
         order by "WO EXTENSION OF TIME STATUS"
         ) a,
         (Select ''Conditional'' c from dual union Select ''Rejected'' c from dual union Select ''Approved'' c from dual) b
         where 1=1
         and eot(+) = b.c
--
UNION
--EOP
Select  1 sorter, ''javascript:doDrillDown( ''''IM41041a'''', ''''''||eop||'''''', ''''EOP'''');'' as link, EOP item, cnt
From (
--
         Select  ''EOP'' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated)         
         group by "REQUESTS" 
         union
         select ''EOP''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated)
         ) sq
--
UNION         
--EOP, NO bud
Select  2 sorter, ''javascript:doDrillDown( ''''IM41041b'''', ''''''||eop||'''''', ''''TOR'''');'' as link, EOP item, cnt
From (
--
         Select  ''TOR'' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated_nobud)         
         group by "REQUESTS" 
         union
         select ''TOR''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated_nobud)
         ) sq
 --
) order by sorter' as IPS_SOURCE_CODE,
  'Everything' as IPS_NAME,
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

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  289 as IPS_ID,
  356 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
WORKS_ORDER_NUMBER
,navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||pod_eot_updated.WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map
,decode(im_framework.has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||pod_eot_updated.works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
where "WO EXTENSION OF TIME STATUS" =  :P6_PARAM1' as IPS_SOURCE_CODE,
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
  99 as IPS_ID,
  110 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select 
WORKS_ORDER_NUMBER
,navigator
,decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showPopUpMap(''''''||pod_eot_updated.WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map 
,decode(im_framework.has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||pod_eot_updated.works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
 from c_pod_eop_updated_DD_nobud pod_eot_updated' as IPS_SOURCE_CODE,
  'Updated EOPs Report - TOR' as IPS_NAME,
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

-----------------------------------------------------------------------------
--WOWT003
-----------------------------------------------------------------------------

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  60 as IPS_ID,
  490 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P3_PRIORITY'''', ''''''||code||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, ''NONLS'' Code, count(*) CNT
        from  X_WO_TFL_WT_IM511003_ALL, X_LOHAC_DateRANGE_WOWT003 dr
        where con_code not in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
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
  1160 as IPS_ID,
  490 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P13_PRIORITY'''', ''''''||code||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, ''LS'' Code, count(*) CNT
        from  X_WO_TFL_WT_IM511003_ALL, X_LOHAC_DateRANGE_WOWT003 dr
        where con_code in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
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
  102 as IPS_ID,
  490 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''15'''', ''''P15_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P15_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, '''' defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW001_NOBU 
        --where  defect_priority = ''2M''
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter' as IPS_SOURCE_CODE,
  'Task Order Requests' as IPS_NAME,
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



