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
MERGE INTO HIGHWAYS.IM_PODS A USING
 (SELECT
  108 as IP_ID,
  'IM41016d' as IP_HMO_MODULE,
  'EOT Request Report (EOP) - TOR' as IP_TITLE,
  'extension of price has been  requested' as IP_DESCR,
  'IM41015' as IP_PARENT_POD_ID,
  'Y' as IP_DRILL_DOWN,
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
