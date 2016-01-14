-- 
-- im_pod_sql
--
SET DEFINE OFF;
MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''WCC''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'WCC' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NPH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NPH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  81 as IPS_ID,
  121 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ENQUIRY_ID
,TITLE
,STATUS_CODE
,STATUS_DESCR
,STATUS_CHANGE_REASON
,SOURCE_CODE
,SOURCE_DESCR
,OUTCOME
,OUTCOME_DESCR
,OUTCOME_CHANGE_REASON
,RECORDED_BY_ID
,RECORDED_BY_NAME
,RESPONSIBILITY_OF_ID
,RESPONSIBILITY_OF_NAME
,USER_TYPE
,ADMIN_UNIT_ID
,ADMIN_UNIT_CODE
,ADMIN_UNIT_NAME
,CATEGORY_CODE
,CATEGORY_DESCR
,CLASS_CODE
,CLASS_DESCR
,ENQUIRY_TYPE_CODE
,ENQUIRY_TYPE_DESCR
,PRIORITY_CODE
,PRIORITY_DESCR
,DATE_RECORDED
,DAYS_SINCE_RECORDED
,INCIDENT_DATE
,DAYS_SINCE_INCIDENT
,CORRESPONDENCE_DATE
,CORRESPONDENCE_RECEIVED
,FOLLOW_UP1
,FOLLOW_UP2
,FOLLOW_UP3
,ACKNOWLEDGEMENT_FLAG
,ACKNOWLEDGEMENT_DATE
,TARGET_DATE
,DAYS_TO_TARGET_DATE
,COMPLETE_DATE
,DATE_TIME_ARRIVED
,REASON_FOR_LATER_ARRIVAL
,LOCATION
,ENQUIRY_DESCRIPTION
,REMARKS
,INJURIES
,DAMAGE
,ENQUIRY_FILE
,NORTHING
,EASTING
,CONTACT_ID
,CONTACT_TYPE_CODE
,CONTACT_TYPE_DESCR
,CONTACT_TITLE
,NAME
,FIRST_NAME
,MIDDLE_INITIAL
,SURNAME
,PRIMARY_CONTACT
,OCCUPATION
,EMPLOYER
,DATE_OF_BIRTH
,ORGANISATION
,CONTACT_NOTES
,ADDRESS_ID
,DEPARTMENT
,BUILDING_NO
,BUILDING_NAME
,SUB_BUILDING_NAME_NO
,STREET
,DEPENDENT_STREET
,LOCALITY
,DEPENDENT_LOCALITY
,TOWN
,COUNTY
,POSTCODE
,PROPERTY_TYPE
,HOME_PHONE
,WORK_PHONE
,MOBILE_PHONE
,FAX
,PAGER
,EMAIL
,       decode(im_framework.has_doc(a.enquiry_id,''DOCS2VIEW''),0,
              ''<img width=24 height=24 src="/im4_framework/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''||a.enquiry_id||'',&APP_ID.,&APP_SESSION.,''''DOCS2VIEW'''')" ><img width=24 height=24 src="/im4_framework/mfopen.gif" alt="Show Documents"></a>'') DOCS,
       decode(objectid,null,
              ''<img width=24 height=24 src="/im4_framework/grey_globe.png" alt="No Location">''
             ,''<a href="javascript:findEnqsFromReport(''||a.enquiry_id||'',&APP_ID.,&APP_SESSION.);" ><img width=24 height=24 src="/im4_framework/globe_64.gif" alt="Find on Map"></a>'') map
from imf_enq_contacts a
    ,NM_DOC_ENQUIRIES_SDO b
where
    a.enquiry_id = b.doc_id(+)
and
    (:P6_PARAM1 is null or a.enquiry_id = :P6_PARAM1)
and
    (:P6_PARAM2 is null or a.contact_id = :P6_PARAM2)
and
    nvl(:P6_PARAM3,nvl(a.postcode,''~'')) = nvl(a.postcode,''~'')
and
    nvl(to_number(:P6_PARAM4),nvl(a.responsibility_of_id,1)) = nvl(a.responsibility_of_id,1)' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  101 as IPS_ID,
  141 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ref as "Ref",
decode(Disruption,1, ''<img src="/im4_framework/images/RWSignLow.gif" border=0 alt="Roadwork">   '',
2, ''<img src="/im4_framework/images/RWSignMed.gif" border=0 alt="Roadwork">'',
3, ''<img src="/im4_framework/images/RWSignHigh.gif" border=0 alt="Roadwork">'',
4, ''  <img src="/im4_framework/images/RWSignSev.gif" border=0 alt="Roadwork">'')  as "Impact",
 ''<span style="display:block;width=500px;"><strong>'' ||street_description
       || '', ''||
       street_town
       ||'', ''||
       street_county
       ||''</strong><BR>''||
       description
       ||''<BR>''||
       to_char(proposed_start_date,''DD-MON-YYYY'')||'' (estimated) - ''
||to_char(estimated_end_date,''DD-MON-YYYY'')||'' (estimated)''
||''<BR>''||
decode(Disruption,1,''<img src="/im4_framework/images/minimal_px.gif" style="border:1px solid #808080;width:12px;height:12px;vertical-align:middle" alt="Impact: Minimal - delays unlikely">Impact: Minimal - delays unlikely ''
                 ,2,''<img src="/im4_framework/images/slight_px.gif" style="border:1px solid #808080;width:12px;height:12px;vertical-align:middle" alt="Slight - delays possible">Impact: Slight - delays possible''
                 ,3,''<img src="/im4_framework/images/moderate_px.gif" style="border:1px solid #808080;width:12px;height:12px;vertical-align:middle" alt="Moderate - delays likely ">Impact: Moderate - delays likely ''
                 ,4,''<img src="/im4_framework/images/severeimpact_px.gif" style="border:1px solid #808080;width:12px;height:12px;vertical-align:middle" alt="Severe - severe delays likely">Impact: Severe - severe delays likely ''
                 )
||''</span> '' as "Description",
''<a href="javascript:displayRoadworkDetails(''''''||ref||'''''')" ><img  src="/im4_framework/images/more.png" alt="More Details"></a> '' ||
''&nbsp <br>''||
''Last updated: ''||to_char(works_modified_date,''DD-MON-YYYY'')
 as "Details"
from  im_tma_road_works
    , IMF_TMA_WORKS_PHASES b
    , imf_tma_streets c
where ref = WORKS_REFERENCE
  and  b.street_id = c.street_id
  and (:P6_PARAM1 is null or ref like ''%''||:P6_PARAM1||''%'')
  and (:P6_PARAM2 is null or street_town = :P6_PARAM2)
  and
      (:P6_PARAM3 is null or street_description = :P6_PARAM3)
and  (Disruption = decode(:P6_PARAM4,''4'',4,0)
      or
      Disruption = decode(:P6_PARAM5,''3'',3,0)
      or
      Disruption = decode(:P6_PARAM6,''2'',2,0)
      or
      DISRUPTION = DECODE(:P6_PARAM7,''1'',1,0))
and  (:P6_PARAM10 is null or :P6_PARAM10 = USRN) ' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''3RDDAM''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  '3rd' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  3 as IPS_ID,
  61 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''<a href="https://v-mid-namsprd.cs-nams2.co.uk/discoverer/viewer?databaseIdentifier=namsprd&eulName=DISCO_REPORTS" target="_blank">Discoverer Viewer</a>'' as Link
from dual
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''VIS''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'VIS' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''PRI''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'PRI' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  41 as IPS_ID,
  18 as IPS_IP_ID,
  3 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_INSP'''',''''''||decode(inspection_type,''5'',''Other Inspection'',''7'',''Other Inspection'',''3'',''Other Inspection'',''Other Inspection'')||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month,
sum(inspection_cost) AS "Other Inspection"
from imf_tma_inspection_results
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and inspection_type in (5,7,3)
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),decode(inspection_type,''5'',''Other Inspection'',''7'',''Other Inspection'',''3'',''Other Inspection'',''Other Inspection'')
order by to_number(to_char(created_date,''YYMM''))
' as IPS_SOURCE_CODE,
  'Other Inspection' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  42 as IPS_ID,
  19 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
-- ''javascript:showDrillDown(50000,''''&APP_SESSION.'''', ''''202'''', ''''P202_ADMIN_UNIT'''',''''''||label||'''''' , ''''P202_P2_ADMIN_UNIT'''', ''''''||label||'''''', null,null);'' as link
null link
,label
, value from
(select initcap(admin_unit_name) label,round(m_to_miles(sum(network_element_length))) value
from
imf_net_maint_sections imf
where network_element_length is not null
group by admin_unit_name)
where value>0
order by 1' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  44 as IPS_ID,
  21 as IPS_IP_ID,
  1 as IPS_SEQ,
  'SELECT
 ''javascript:doDrillDown(''''IM100203'''',''''''||TO_CHAR(DATE_RECORDED,''Mon YYYY'')||'''''')'' as link
,to_char(date_recorded,''Mon YYYY'') Month, count(*) as "Total Enquiries"
from
imf_enq_enquiries
where date_recorded BETWEEN to_date(to_char(add_months(sysdate,-24),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
GROUP BY to_char(date_recorded,''Mon YYYY''),to_number(to_char(date_recorded,''YYMM''))
order by to_number(to_char(date_recorded,''YYMM''))' as IPS_SOURCE_CODE,
  'Total Enquiries' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  45 as IPS_ID,
  22 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(20000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_CAT'''', ''''''||category_type_name||'''''', null,null, null,null,null,null);'' as link ,to_char(created_date,''Mon YYYY'') Month
,count(*) as "Category A"
from imf_tma_inspection_results
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and category_type_name = ''Category A''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),category_type_name
order by to_number(to_char(created_date,''YYMM''))
' as IPS_SOURCE_CODE,
  'Cat A' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  46 as IPS_ID,
  22 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showDrillDown(20000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_CAT'''', ''''''||category_type_name||'''''', null,null, null,null,null,null);'' as link ,to_char(created_date,''Mon YYYY'') Month
, count(*) as "Category B"
from imf_tma_inspection_results
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and category_type_name = ''Category B''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),category_type_name
order by to_number(to_char(created_date,''YYMM''))
     ' as IPS_SOURCE_CODE,
  'Cat B' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  47 as IPS_ID,
  22 as IPS_IP_ID,
  3 as IPS_SEQ,
  '      select ''javascript:showDrillDown(20000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_CAT'''', ''''''||category_type_name||'''''', null,null, null,null,null,null);'' as link ,to_char(created_date,''Mon YYYY'') Month
      , count(*) as "Category C"
      from imf_tma_inspection_results
      where
       created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
      and category_type_name = ''Category C''
      group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),category_type_name
      order by to_number(to_char(created_date,''YYMM''))
      ' as IPS_SOURCE_CODE,
  'Cat C' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  49 as IPS_ID,
  21 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showDrillDown(100000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(date_recorded,''Mon YYYY'')||'''''' , null, null, null,null, null,null,null,null);'' as link
,to_char(date_recorded,''Mon YYYY'') Month,count(*) as "Late Enquiries"
from
imf_enq_enquiries
where nvl(complete_date,sysdate) > target_date
and date_recorded BETWEEN to_date(to_char(add_months(sysdate,-24),''MON-YYYY''),''MON-YYYY'')AND sysdate
group by to_char(date_recorded,''Mon YYYY''),to_number(to_char(date_recorded,''YYMM''))
order by to_number(to_char(date_recorded,''YYMM''))' as IPS_SOURCE_CODE,
  'Late Enquiries' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  50 as IPS_ID,
  26 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(20000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_SENT_REC'''', ''''Received'''', null,null, null,null,null,null);'' as link
,to_char(created_date,''Mon YYYY'') Month,count(*) Received
from
imf_tma_notices
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and sent_or_received = ''R''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM''))
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'received' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  52 as IPS_ID,
  25 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(40000,''''&APP_SESSION.'''', ''''205'''', ''''P205_DEFECT_TYPE'''',''''''||label||'''''' ,null, null, null,null, null,null,null,null);'' as link,
label,value from
(select
imf_translate(defect_type_description) label ,sum(late) value
from
(select
(case when rownum <10 then defect_type_description else ''Other'' end) defect_type_description
,late
from
(
select defect_type_description,count(1) late from imf_mai_defect_repairs
where repair_late=''Y''
and date_due between (sysdate-30) and sysdate
group by defect_type_description
order by 2 desc
))
group by defect_type_description)' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  53 as IPS_ID,
  26 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(20000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_SENT_REC'''', ''''Sent'''', null,null, null,null,null,null);'' as link
,to_char(created_date,''Mon YYYY'') Month, count(*) Sent
from
imf_tma_notices
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and sent_or_received = ''S''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM''))
order by to_number(to_char(created_date,''YYMM''))
' as IPS_SOURCE_CODE,
  'sent' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  54 as IPS_ID,
  16 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(50000,''''&APP_SESSION.'''', ''''205'''', ''''P205_ROAD_CLASS'''',''''''||im_framework.imf_translate(label)||'''''' ,null, null, null,null, null,null,null,null);'' as link,
 label ,sum(value) value
from
(select
(case when rownum <6 then label else ''Other'' end) label
,value
from
(
select section_class_DESCR label, round(m_to_miles(sum(network_element_length))) value from
imf_net_maint_sections imf
where network_element_length is not null
group by section_class_DESCR
order by 2 desc
))
GROUP BY LABEL
order by label' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  62 as IPS_ID,
  106 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select        decode(im_framework.has_doc(enquiry_id,''DOCS2VIEW''),0,
              ''<img width=24 height=24 src="/im4_framework/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''||enquiry_id||'',&APP_ID.,&APP_SESSION.,''''DOCS2VIEW'''')" ><img width=24 height=24
src="/im4_framework/mfopen.gif" alt="Show Documents"></a>'') DOCS,
       decode(objectid,null,
              ''<img width=24 height=24 src="/im4_framework/grey_globe.png" alt="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''FINDENQSREP'''',''||enquiry_id||'');" ><img width=24 height=24 src="/im4_framework/globe_64.gif" alt="Find on Map"></a>'') map
,imf.*
from imf_enq_enquiries imf
,enq_enquiries_xy_sdo
where imf.enquiry_id=doc_id(+)
and to_char(date_recorded,''Mon YYYY'') = nvl(:P6_PARAM1,to_char(sysdate,''Mon YYYY''))
and enquiry_type_descr=:P6_PARAM2' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  63 as IPS_ID,
  107 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select imf.*
,       decode(im_framework.has_doc(enquiry_id,''DOCS2VIEW''),0,
              ''<img width=24 height=24 src="/im4_framework/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''||enquiry_id||'',&APP_ID.,&APP_SESSION.,''''DOCS2VIEW'''')" ><img width=24 height=24 src="/im4_framework/mfopen.gif" alt="Show Documents"></a>'') DOCS,
       decode(objectid,null,
              ''<img width=24 height=24 src="/im4_framework/grey_globe.png" alt="No Location">''
             ,''<a href="javascript:findEnqsFromReport(''||enquiry_id||'',&APP_ID.,&APP_SESSION.);" ><img width=24 height=24 src="/im4_framework/globe_64.gif" alt="Find on Map"></a>'') map
from imf_enq_enquiries imf
,enq_enquiries_xy_sdo
where imf.enquiry_id=doc_id(+)
and to_char(date_recorded,''Mon YYYY'') = nvl(:P6_PARAM1,to_char(sysdate,''Mon YYYY''))
and enquiry_type_descr=:P6_PARAM2
and nvl(complete_date,sysdate) > target_date' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  67 as IPS_ID,
  111 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select enquiry_type_descr as "Enquiry Type"
,''<a href="javascript:doDrillDown(''''IM100205'''',''''''||:P6_PARAM1||'''''',''''''||ENQUIRY_TYPE_DESCR||'''''')">''||count(*)||''</a>'' as Enquiries
from
imf_enq_enquiries
where to_char(date_recorded,''Mon YYYY'') = nvl(:P6_PARAM1,to_char(sysdate,''Mon YYYY''))
group by enquiry_type_descr
order by enquiry_type_descr' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  68 as IPS_ID,
  112 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select enquiry_type_descr
,''<a href="javascript:doDrillDown(''''IM100206'''',''''''||:P6_PARAM1||'''''',''''''||ENQUIRY_TYPE_DESCR||'''''')">''||count(*)||''</a>''  as Enquiries
from
imf_enq_enquiries
where to_char(date_recorded,''Mon YYYY'') = nvl(:P6_PARAM1,to_char(sysdate,''Mon YYYY''))
and nvl(complete_date,sysdate) > target_date
group by enquiry_type_descr
order by enquiry_type_descr
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  121 as IPS_ID,
  214 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select itnr.Organisation_Name authority, works_category_name, Count(*)
From Imf_Tma_Possible_Fpns itpf, Imf_Tma_Notice_Recipients itnr
Where itpf.Notice_Id = itnr.Notice_Id
And itnr.Recipient_Type = 1
And itpf.created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(itpf.created_date,''Mon YYYY'') = :P6_PARAM1
and itpf.rule_group_text = :P6_PARAM2
Group By itnr.Organisation_Name,works_category_name
Order By Count(*) desc
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  136 as IPS_ID,
  229 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select *
from imf_tma_notices
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(created_date,''Mon YYYY'') = :P6_PARAM1
and sent_or_received = decode(:P6_PARAM2,''Sent'',''S'',''Received'',''R'')
and imf_translate(SENDER_ORGANISATION_NAME)=:P6_PARAM3' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  122 as IPS_ID,
  215 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select itpf.*,
NOTICE_RECIPIENT_ID, ORGANISATION_REFERENCE, ORGANISATION_NAME, DISTRICT_REFERENCE, DISTRICT_NAME, RECIPIENT_TYPE, RECIPIENT_TYPE_NAME
From Imf_Tma_Possible_Fpns itpf, Imf_Tma_Notice_Recipients itnr
Where itpf.Notice_Id = itnr.Notice_Id
And itnr.Recipient_Type = 1
And itpf.created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(itpf.created_date,''Mon YYYY'') = :P6_PARAM1
and itpf.rule_group_text = :P6_PARAM2
and works_category_name =:P6_PARAM3
and itnr.Organisation_Name=:P6_PARAM4' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  123 as IPS_ID,
  216 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ORGANISATION_REF_OWNER_NAME,sum(inspection_cost)
from imf_tma_inspection_results
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(created_date,''Mon YYYY'') = :P6_PARAM1
and decode(inspection_type,6,''Defect Inspection'',4,''Defect Inspection'',2,''Defect Inspection'',1,''Sample Inspection'',5,''Other Inspection'',7,''Other Inspection'',3,''Other Inspection'',inspection_type) = :P6_PARAM2
group by ORGANISATION_REF_OWNER_NAME' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  124 as IPS_ID,
  217 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select *
from imf_tma_inspection_results
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(created_date,''Mon YYYY'') = :P6_PARAM1
and decode(inspection_type,6,''Defect Inspection'',4,''Defect Inspection'',2,''Defect Inspection'',1,''Sample Inspection'',5,''Other Inspection'',7,''Other Inspection'',3,''Other Inspection'',inspection_type) = :P6_PARAM2
and ORGANISATION_REF_OWNER_NAME=:P6_PARAM3' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  128 as IPS_ID,
  221 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select imdr.* From
imf_mai_defect_repairs imdr
,(select defect_type_description,
(case when rownum <10 then defect_type_description else ''Other'' end) top_type_descr
,late
from
(
select defect_type_description,count(1) late from imf_mai_defect_repairs
WHERE REPAIR_LATE=''Y''
and date_due between (sysdate-30) and sysdate
group by defect_type_description
order by 2 desc
) )top_type
WHERE REPAIR_LATE=''Y''
and date_due between (sysdate-30) and sysdate
and imf_translate(top_type.top_type_descr)=:P6_PARAM1 and top_type.defect_type_description=imdr.defect_type_description ' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  31 as IPS_ID,
  15 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE INITIAL"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE INITIAL''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE INITIAL' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  32 as IPS_ID,
  15 as IPS_IP_ID,
  3 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE CONFIRMATION"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE CONFIRMATION''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE CONFIRMATION' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  33 as IPS_ID,
  15 as IPS_IP_ID,
  4 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE CANCELLATION"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE CANCELLATION''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE CANCELLATION' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  34 as IPS_ID,
  15 as IPS_IP_ID,
  5 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE ACTUAL START"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'')AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE ACTUAL START''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE ACTUAL START' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  35 as IPS_ID,
  15 as IPS_IP_ID,
  6 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE WORKS STOP"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE WORKS STOP''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE WORKS STOP' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  36 as IPS_ID,
  15 as IPS_IP_ID,
  7 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE REGISTRATION"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE REGISTRATION''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE REGISTRATION' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  37 as IPS_ID,
  15 as IPS_IP_ID,
  8 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month, count(*) as "OUTSIDE VALIDITY PERIOD"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''OUTSIDE VALIDITY PERIOD''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'OUTSIDE VALIDITY PERIOD' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  135 as IPS_ID,
  228 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select imf_translate(SENDER_ORGANISATION_NAME)  as Organisation,count(*) as Count
from imf_tma_notices
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and to_char(created_date,''Mon YYYY'') = :P6_PARAM1
and sent_or_received = decode(:P6_PARAM2,''Sent'',''S'',''Received'',''R'')
group by to_char(created_date,''Mon YYYY''),SENDER_ORGANISATION_NAME' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
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
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 REQ_EOT_DATE EOT_REQUESTED_DATE,
 REC_EOT_DATE EOT_RECOMMENDED_DATE,
 "WO Process Status",
 "EOT Reason for Request",
 "EOT Reason for Rejection",
 "WO Reason for Hold",
 "WO Reason for Rejection",
 WO_RAISED_BY,
 WOR_CONTACT CONTACT,
 WOR_DATE_CONFIRMED WO_INSTRUCTED_DATE,
 WOR_ACT_COST ACTUAL_COST,
 WOR_EST_COST ESTIMATE_COST,
 WOR_DATE_RAISED WO_RAISED_DATE,
 WOL_DATE_COMPLETE WI_COMPLETED_DATE,
 WOL_DATE_REPAIRED WC_COMPLETED_DATE,
 DUE_DATE,
 WORK_ORDER_STATUS,
 BUDGET_CODE,
 r.range_value
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
and WOL_DEF_DEFECT_ID is null
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  38 as IPS_ID,
  15 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''201'''', ''''P201_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P201_GROUP'''',''''''||RULE_GROUP_TEXT||'''''', null,null, null,null,null,null);'' as link ,to_char(created_date,''Mon YYYY'') Month, count(*) as "LATE IMMEDIATE"
from imf_tma_possible_fpns
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and RULE_GROUP_TEXT = ''LATE IMMEDIATE''
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),RULE_GROUP_TEXT
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'LATE IMMEDIATE' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  39 as IPS_ID,
  18 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_INSP'''',''''''||decode(inspection_type,''1'',''Sample Inspection'',inspection_type)||'''''', null,null, null,null,null,null);'' as link
,to_char(created_date,''Mon YYYY'') Month,
sum(inspection_cost) AS "Sample Inspection"
from imf_tma_inspection_results
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and inspection_type = 1
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),decode(inspection_type,''1'',''Sample Inspection'',inspection_type)
order by to_number(to_char(created_date,''YYMM''))' as IPS_SOURCE_CODE,
  'Sample Inspection' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  40 as IPS_ID,
  18 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showDrillDown(30000,''''&APP_SESSION.'''', ''''204'''', ''''P204_MONTH'''',''''''||to_char(created_date,''Mon YYYY'')||'''''' , ''''P204_INSP'''',''''''||decode(inspection_type,''6'',''Defect Inspection'',''4'',''Defect Inspection'',''2'',''Defect Inspection'',''Defect Inspection'')||'''''', null,null, null,null,null,null);'' as link,to_char(created_date,''Mon YYYY'') Month,
sum(inspection_cost) AS "Defect Inspection"
from imf_tma_inspection_results
where created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'')AND trunc(sysdate)
and inspection_type in (6,4,2)
group by to_char(created_date,''Mon YYYY''), to_number(to_char(created_date,''YYMM'')),decode(inspection_type,''6'',''Defect Inspection'',''4'',''Defect Inspection'',''2'',''Defect Inspection'',''Defect Inspection'')
order by to_number(to_char(created_date,''YYMM''))
' as IPS_SOURCE_CODE,
  'Defect Inspection' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Cylinder' as IPS_SHAPE_TYPE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  147 as IPS_ID,
  240 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select * from
imf_net_maint_sections imf
,(select
(case when rownum <6 then label else ''Other'' end) label
,label code
,value
from
(
--
select section_class_DESCR label, round(m_to_miles(sum(network_element_length))) value from
imf_net_maint_sections imf
where network_element_length is not null
group by section_class_DESCR
order by 2 desc
))top_type
where network_element_length is not null
AND im_framework.imf_translate(TOP_TYPE.LABEL)=:P6_PARAM1
and top_type.code=section_class_DESCR' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  137 as IPS_ID,
  230 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select imf_translate(UNDERTAKER_ORG_REFERENCE_NAME) UNDERTAKER_ORG_REFERENCE_NAME,count(*) as Inspections
from imf_tma_inspection_results
where
 created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and category_type_name = :P6_PARAM2
and to_char(created_date,''Mon YYYY'') = :P6_PARAM1
group by UNDERTAKER_ORG_REFERENCE_NAME,to_char(created_date,''Mon (YYYY)''),category_type_name
order by UNDERTAKER_ORG_REFERENCE_NAME' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  138 as IPS_ID,
  231 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select works_reference,itir.*
from imf_tma_inspection_results itir
,imf_tma_works itw
where
 itir.created_date BETWEEN to_date(to_char(add_months(sysdate,-12),''MON-YYYY''),''MON-YYYY'') AND trunc(sysdate)
and category_type_name = :P6_PARAM1
--and inspection_type = ''1''
and to_char(itir.created_date,''Mon YYYY'') = :P6_PARAM2
and imf_translate(UNDERTAKER_ORG_REFERENCE_NAME)=:P6_PARAM3
and itw.works_id=itir.works_id' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  321 as IPS_ID,
  381 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select *
from IMF_NET_MAINT_SECTIONS IMF
where NETWORK_ELEMENT_LENGTH is not null
and initcap(admin_unit_name) = :P6_PARAM1' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
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
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 REQ_EOT_DATE EOT_REQUESTED_DATE,
 REC_EOT_DATE EOT_RECOMMENDED_DATE,
 "WO Process Status",
 "EOT Reason for Request",
 "EOT Reason for Rejection",
 "WO Reason for Hold",
 "WO Reason for Rejection",
 WO_RAISED_BY,
 WOR_CONTACT CONTACT,
 WOR_DATE_CONFIRMED WO_INSTRUCTED_DATE,
 WOR_ACT_COST ACTUAL_COST,
 WOR_EST_COST ESTIMATE_COST,
 WOR_DATE_RAISED WO_RAISED_DATE,
 WOL_DATE_COMPLETE WI_COMPLETED_DATE,
 WOL_DATE_REPAIRED WC_COMPLETED_DATE,
 DUE_DATE,
 WORK_ORDER_STATUS,
 BUDGET_CODE,
 r.range_value
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
and WOL_DEF_DEFECT_ID is null
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  85 as IPS_ID,
  44 as IPS_IP_ID,
  40 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''REVUPD''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Awaiting Review - Updated application' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  86 as IPS_ID,
  44 as IPS_IP_ID,
  50 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''REVCOMM''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Awaiting Review - New comments' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  87 as IPS_ID,
  44 as IPS_IP_ID,
  60 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''APPCOMM''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Approved - Awaiting Commercial Review' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  88 as IPS_ID,
  44 as IPS_IP_ID,
  70 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''INTREJ''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Intrim Rejected' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1 as IPS_ID,
  1 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select
 NULL as link,
days2 days,
SUM(NVL(requests,0)) Repeat
from pod_eot_requests,
                                            (select days2 from
                                            (select ''0-1'' as days2 from dual) union (select ''2-3'' as days2 from dual)
                                            union (select ''4-10'' as days2 from dual) union (select ''>10'' as days2 from dual))
where days(+)=days2
and REQ(+) = ''Initial''
group by DAYS2
order by days2' as IPS_SOURCE_CODE,
  'Initial' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  2 as IPS_ID,
  41 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
null as link,
ne_admin_unit||'' - ''||M_L_FLAG ||
DECODE(COMP_ON_TIME_FLAG,1,''YES'',''NO'') as "completed",
count(*) as "amount"
from disco.spi_13_v1
where ne_admin_unit in (3,4,5)
and target_response >= sysdate - 30
group by ne_admin_unit,M_L_FLAG,COMP_ON_TIME_FLAG
order by 2' as IPS_SOURCE_CODE,
  'Test' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  89 as IPS_ID,
  44 as IPS_IP_ID,
  80 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''REJCOMM''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
  'Rejected - Awaiting Commercial Review' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  241 as IPS_ID,
  330 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown(''''IM41016a'''',''''''||range_value||'''''', ''''''||''INITIAL''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) as "INITIAL"
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = ''INITIAL''
and "EOT DATE REQUESTED"(+) is not null --WOR_CHAR_ATTRIB121
group by range_value
order by (decode(range_value,''Today'',1,''1-6'',2,''7-30'',3,''31-60'',4,''61-90'',5))' as IPS_SOURCE_CODE,
  'Initial' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  242 as IPS_ID,
  330 as IPS_IP_ID,
  20 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown(''''IM41016b'''',''''''||range_value||'''''', ''''''||''REPEAT''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) Repeat
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = ''REPEAT''
and "EOT DATE REQUESTED"(+) is not null --WOR_CHAR_ATTRIB121 
group by range_value
order by (decode(range_value,''Today'',1,''1-6'',2,''7-30'',3,''31-60'',4,''61-90'',5))' as IPS_SOURCE_CODE,
  'Repeat' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1154 as IPS_ID,
  489 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOHLD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOHLD' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''SCH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'SCH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''3RD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  '3RD' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NPH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NPH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''WCC''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'WCC' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1155 as IPS_ID,
  489 as IPS_IP_ID,
  3 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1156 as IPS_ID,
  489 as IPS_IP_ID,
  4 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1158 as IPS_ID,
  489 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  286 as IPS_ID,
  353 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
--WORKS_ORDER_NUMBER,
--
''<a href="javascript:openForms(''''DEFECTS'''',''''''||defect_id||'''''');">Navigator'' Navigator
,decode( (select def_defect_id from vw_mai_defects_sdo where def_defect_id = defect_id),null, ''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
       ,''<a href="javascript:showFeatureOnMap(''''''||defect_id||'''''',''''IM_DEFECTS'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map
,decode(im_framework.has_doc(DEFECT_ID,''DEFECTS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||defect_id||'''''',&APP_ID.,&APP_SESSION.,''''DEFECTS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
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
from imf_mai_defects def,imf_net_network_members net
where network_element_id = child_element_id
and parent_group_type = ''HMBG''
and defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = :P6_PARAM2
and  (case when trunc(sysdate-date_inspected) <= 1 then ''1''when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5'' when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60'' when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) = :P6_PARAM1' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  1157 as IPS_ID,
  489 as IPS_IP_ID,
  5 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''PRI''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'PRI' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''VIS''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'VIS' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  75 as IPS_ID,
  335 as IPS_IP_ID,
  130 as IPS_SEQ,
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''RISKTFL''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'RISKTFL' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CSH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CSH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  73 as IPS_ID,
  335 as IPS_IP_ID,
  140 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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
        and due_date between r.st_range and r.end_range
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''LSWORK''
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  243 as IPS_ID,
  331 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select ''javascript:doDrillDown(''''IM41031'''',''''''||days2||'''''',  ''''''||''1''||'''''');'' as link,days2 days,nvl("1",0) "1" from
(select days,sum(priority) "1"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from imf_mai_defects a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''1''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  245 as IPS_ID,
  331 as IPS_IP_ID,
  30 as IPS_SEQ,
  'select ''javascript:doDrillDown( ''''IM41031'''', ''''''||days2||'''''', ''''''||''2M''||'''''');'' as link,days2 days,nvl("2M",0) "2M" from
(select days,sum(priority) "2M"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from imf_mai_defects a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''2M''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
  '-2M-' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  26 as IPS_ID,
  334 as IPS_IP_ID,
  130 as IPS_SEQ,
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''CSH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'CSH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  25 as IPS_ID,
  334 as IPS_IP_ID,
  140 as IPS_SEQ,
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''RISKTFL''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'RISKTFL' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  74 as IPS_ID,
  335 as IPS_IP_ID,
  150 as IPS_SEQ,
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NO_REASON''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NO_REASON' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
        and due_date between r.st_range and r.end_range
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''TOHLD''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'TOHLD' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  23 as IPS_ID,
  334 as IPS_IP_ID,
  150 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        X_LOHAC_DateRANGE_WODC x
where  data.range_value(+) = x.range_value
order by sorter  ' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  244 as IPS_ID,
  331 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select ''javascript:doDrillDown( ''''IM41031'''',''''''||days2||'''''', ''''''||''2H''||'''''');'' as link,days2 days,nvl("2H",0) "2H" from
(select days,sum(priority) "2H"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from imf_mai_defects a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''2H''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
  '-2H-' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BOQ''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BOQ' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''SCH''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'SCH' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  59 as IPS_ID,
  489 as IPS_IP_ID,
  6 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P9_PRIORITY'''', ''''''||defect_priority||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  10 as IPS_ID,
  331 as IPS_IP_ID,
  40 as IPS_SEQ,
  'select ''javascript:doDrillDown(''''IM41031'''',''''''||days2||'''''',  ''''''||''1 (ECO)''||'''''');'' as link,days2 days,nvl("1 ECO",0) "1 ECO" from
(select days,sum(priority) "1 ECO"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from imf_mai_defects a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''1 (ECO)''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
  '-1 (ECO)-' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
 ,WO_PRO_STAT WO_PROCESS_STATUS,
 EOT_STATUS,
 REQ_EOT_DATE EOT_REQUESTED_DATE,
 REC_EOT_DATE EOT_RECOMMENDED_DATE,
 "WO Process Status",
 "EOT Reason for Request",
 "EOT Reason for Rejection",
 "WO Reason for Hold",
 "WO Reason for Rejection",
 WO_RAISED_BY,
 WOR_CONTACT CONTACT,
 WOR_DATE_CONFIRMED WO_INSTRUCTED_DATE,
 WOR_ACT_COST ACTUAL_COST,
 WOR_EST_COST ESTIMATE_COST,
 WOR_DATE_RAISED WO_RAISED_DATE,
 WOL_DATE_COMPLETE WI_COMPLETED_DATE,
 WOL_DATE_REPAIRED WC_COMPLETED_DATE,
 DUE_DATE,
 WORK_ORDER_STATUS,
 BUDGET_CODE,
 r.range_value
from WORK_DUE_TO_BE_CMP_NO_dF_child a, X_LOHAC_DateRANGE_WODC r
where  due_date between r.st_range and r.end_range
and work_order_status in (''DRAFT'',''INSTRUCTED'')
and WOL_DEF_DEFECT_ID is null
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  80 as IPS_ID,
  334 as IPS_IP_ID,
  151 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  8 as IPS_ID,
  23 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select link, range_value, tot "Awaiting Review" from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''REV''     
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  82 as IPS_ID,
  334 as IPS_IP_ID,
  152 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  83 as IPS_ID,
  334 as IPS_IP_ID,
  153 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  84 as IPS_ID,
  334 as IPS_IP_ID,
  154 as IPS_SEQ,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  16 as IPS_ID,
  23 as IPS_IP_ID,
  30 as IPS_SEQ,
  'select link, range_value, tot "Rej_Awaiting Comm Review" from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''REJCOMM''     
       group by  code, range_value) mn,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  17 as IPS_ID,
  23 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select link, range_value, tot "Appr_Awaiting Comm Review" from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''APPCOMM''     
       group by  code, range_value) mn,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  77 as IPS_ID,
  334 as IPS_IP_ID,
  160 as IPS_SEQ,
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''NO_REASON''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'NO_REASON' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  13 as IPS_ID,
  44 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''APP''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  14 as IPS_ID,
  44 as IPS_IP_ID,
  30 as IPS_SEQ,
  'select link, range_value, tot "Awaiting Review’" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' ,  ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''REV''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  15 as IPS_ID,
  44 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select link, range_value, tot "Rejected" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P10_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P10_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = ''REJ''     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )' as IPS_SOURCE_CODE,
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

MERGE INTO IM_POD_SQL A USING
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
					 AND NVL(WOR_CHAR_ATTRIB104, ''NO_REASON'') = ''BOQ''
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BOQ' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  18 as IPS_ID,
  330 as IPS_IP_ID,
  30 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown(''''IM41016c'''',''''''||range_value||'''''', ''''''||''EOP''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) Extension_of_Price_Requested
from c_pod_eop_requests,pod_day_range
where days(+)=range_value
and work_order_line_status(+) <> ''INSTRUCTED'' 
and "DATE PRICE EXTENSION REQUESTED"(+) is not null --WOR_DATE_ATTRIB129
group by range_value
order by (decode(range_value,''Today'',1,''1-6'',2,''7-30'',3,''31-60'',4,''61-90'',5))' as IPS_SOURCE_CODE,
  'Price Extension Requested' as IPS_NAME,
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

MERGE INTO IM_POD_SQL A USING
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
