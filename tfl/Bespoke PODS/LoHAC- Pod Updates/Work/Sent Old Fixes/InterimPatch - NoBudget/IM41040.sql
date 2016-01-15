SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  96 as IPS_ID,
  333 as IPS_IP_ID,
  40 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041a'''', ''''''||eop||'''''', ''''EOP'''');'' as link, sq.*
From (
--
         Select  ''EOP'' EOP, count("REQUESTS") count
         from( select * from c_pod_eoP_updated)         
         group by "REQUESTS" 
		 union
         select ''EOP''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated)
         ) sq' as IPS_SOURCE_CODE,
  'Extension of Price' as IPS_NAME,
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
  97 as IPS_ID,
  333 as IPS_IP_ID,
  50 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041b'''', ''''''||eop||'''''', ''''EOP'''');'' as link, sq.*
From (
--
         Select  ''TOR'' EOP, count("REQUESTS") count
         from( select * from c_pod_eoP_updated_nobud)         
         group by "REQUESTS" 
		 union
         select ''TOR''  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated_nobud)
         ) sq' as IPS_SOURCE_CODE,
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
  249 as IPS_ID,
  333 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041'''', ''''''||eot||'''''', ''''Approved'''');'' as link, sq.*
From (
--
         Select  ''Approved'' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Approved'')
         group by "WO EXTENSION OF TIME STATUS"
		 union
         select ''Approved''  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Approved'')
         ) sq' as IPS_SOURCE_CODE,
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
  11 as IPS_ID,
  333 as IPS_IP_ID,
  30 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041'''', ''''''||eot||'''''', ''''Rejected'''');'' as link, sq.*
From (
--
         Select  ''Rejected'' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Rejected'')
         group by "WO EXTENSION OF TIME STATUS"
		 union
         select ''Rejected''  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Rejected'')
         ) sq' as IPS_SOURCE_CODE,
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
  12 as IPS_ID,
  333 as IPS_IP_ID,
  20 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041'''', ''''''||eot||'''''', ''''Conditional'''');'' as link, sq.*
From (
--
         Select  ''Conditional'' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Conditional'')
         group by "WO EXTENSION OF TIME STATUS"
		 union
         select ''Conditional''  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = ''Conditional'')
         ) sq' as IPS_SOURCE_CODE,
  'Conditional' as IPS_NAME,
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
  109 as IP_ID,
  'IM41041a' as IP_HMO_MODULE,
  'Updated EOPs Report' as IP_TITLE,
  'Updated EOPs Report' as IP_DESCR,
  'IM41040' as IP_PARENT_POD_ID,
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

MERGE INTO HIGHWAYS.IM_PODS A USING
 (SELECT
  110 as IP_ID,
  'IM41041b' as IP_HMO_MODULE,
  'Updated EOPs Report - TOR' as IP_TITLE,
  'Updated EOPs Report - Task Order Request' as IP_DESCR,
  'IM41040' as IP_PARENT_POD_ID,
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
  98 as IPS_ID,
  109 as IPS_IP_ID,
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
 from c_pod_eop_updated_DD pod_eot_updated' as IPS_SOURCE_CODE,
  'Updated EOPs Report' as IPS_NAME,
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

COMMIT;
