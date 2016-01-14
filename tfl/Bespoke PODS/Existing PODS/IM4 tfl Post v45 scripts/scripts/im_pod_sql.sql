SET DEFINE OFF;
MERGE INTO IM_POD_SQL A USING
 (SELECT
  290 as IPS_ID,
  357 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, WOR_WORKS_ORDER_NO),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||WOR_WORKS_ORDER_NO||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(WOR_WORKS_ORDER_NO,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||WOR_WORKS_ORDER_NO||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
Navigator,
WOR_WORKS_ORDER_NO WORK_ORDER_NUMBER,
WOL_DEF_DEFECT_ID DEFECT_ID,
WOL_REP_ACTION_CAT REPAIR_TYPE,
DEF_PRIORITY DEFECT_PRIORITY,
 DEF_INSPECTION_DATE DATE_INSPECTED,
 WO_PRO_STAT WO_PROCESS_STATUS,
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
 DEF_DEFECT_DESCR DEFECT_DESCRIPTION,
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
from work_due_to_be_comp_child a, POD_DAY_RANGE_REV r
where  due_date between r.st_range and r.end_range
and range_value =  :P6_PARAM1
and (( contract_type = :P6_PARAM2)
or( ''OT'' = :P6_PARAM2 and contract_type != ''LS''))
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
  285 as IPS_ID,
  352 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, WOR_WORKS_ORDER_NO),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||WOR_WORKS_ORDER_NO||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(WOR_WORKS_ORDER_NO,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||WOR_WORKS_ORDER_NO||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
Navigator,
WOR_WORKS_ORDER_NO WORK_ORDER_NUMBER,
 WO_PRO_STAT WO_PROCESS_STATUS,
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
from WORK_DUE_TO_BE_CMP_NO_dF_child a, POD_DAY_RANGE_REV r
where  due_date between r.st_range and r.end_range
and range_value =  :P6_PARAM1
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
  287 as IPS_ID,
  354 as IPS_IP_ID,
  1 as IPS_SEQ,
  'SELECT decode(DECODE (mai_sdo_util.wo_has_shape (559, work_order_number),''TRUE'', ''Y'',''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">'',''<a href="javascript:showWODefOnMap(''''''||work_order_number||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(work_order_number,''WORK_ORDERS''),0,''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">'',''<a href="javascript:showWODocAssocs(''''''||work_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24 src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
 ''<a href="javascript:openForms(''''WORK_ORDERS'''',''''''||work_order_number|| '''''');">Navigator'' Navigator,
 wol.WORK_ORDER_LINE_ID,
 wor.WORKS_ORDER_NUMBER,
 wor.CONTRACTOR_CODE,
 wor.ORIGINATOR_NAME,
 wor.CONTACT,
 wol.DEFECT_ID,
 wol.DEFECT_PRIORITY,
 wol.LOCATION_DESCRIPTION,
 def.DEFECT_DESCRIPTION,
 def.REPAIR_DESCRIPTION,
 def.REPAIR_CATEGORY,
 wor.DATE_RAISED,
 wor.WOR_DATE_ATTRIB121 AS "EOT Date Requested",
 wor.DATE_INSTRUCTED,
 wol.ESTIMATED_COST,
 wol.ACTUAL_COST,
 wor.WORKS_ORDER_STATUS,
 wor.SCHEME_TYPE,
 wor.SCHEME_TYPE_DESCRIPTION,
 wol.WORK_CATEGORY,
 wol.WORK_CATEGORY_DESCRIPTION,
 wor.AUTHORISED_BY_NAME,
 wol.DATE_REPAIRED,
 wol.DATE_COMPLETED,
 wor.WOR_CHAR_ATTRIB100 AS "WO Process Status",
 wor.WOR_CHAR_ATTRIB101 AS "WO Extension of Time Status",
 wor.WOR_CHAR_ATTRIB102 AS "EOT Reason for Request",
 wor.WOR_CHAR_ATTRIB103 AS "EOT Reason for Rejection",
 wor.WOR_CHAR_ATTRIB104 AS "WO Reason for Hold",
 wor.WOR_CHAR_ATTRIB105 AS "WO Reason for Rejection",
 wor.WOR_DATE_ATTRIB122 AS "EOT Conditional Date",
 bud.COST_CODE,
 net.parent_element_description AS "Borough"
FROM ximf_mai_work_orders_all_attr wor,
ximf_mai_work_order_lines wol,
imf_mai_defect_repairs def,
imf_mai_budgets bud,
imf_net_network_members net,
hig_audits_vw,
POD_DAY_RANGE r,
pod_nm_element_security,
pod_budget_security
WHERE     wor.works_order_number = work_order_number
AND wol.defect_id = def.defect_id(+)
AND wol.budget_id = bud.budget_id
AND wor.works_order_number = haud_pk_id
AND haud_table_name = ''WORK_ORDERS''
AND wol.network_element_id = child_element_id
AND parent_group_type = ''HMBG''
AND NVL (works_order_description, ''Empty'') NOT LIKE ''%**Cancelled**%''
AND work_order_line_status NOT IN
(''COMPLETED'', ''ACTIONED'', ''INSTRUCTED'')
AND WOR_CHAR_ATTRIB100 = ''REJ''
AND WOR_CHAR_ATTRIB104 = :P6_PARAM2
AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
AND haud_timestamp =
(SELECT MAX (haud_timestamp)
FROM hig_audits_vw
WHERE haud_pk_id = wor.works_order_number
AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
AND haud_new_value = ''REJ'')
AND haud_timestamp BETWEEN r.st_range AND r.end_range
AND r.range_value = :P6_PARAM1
AND pod_nm_element_security.element_id = wol.network_element_id
AND pod_budget_security.budget_code = wol.work_category
ORDER BY wor.works_order_number, wol.WORK_ORDER_LINE_ID' as IPS_SOURCE_CODE,
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
  241 as IPS_ID,
  330 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown(''''IM41016a'''',''''''||range_value||'''''', ''''''||''Initial''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) as "initial"
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = ''Initial''
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
 ''javascript:doDrillDown(''''IM41016b'''',''''''||range_value||'''''', ''''''||''Initial''||'''''');'' as link,
range_value days,
SUM(NVL(requests,0)) Repeat
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = ''Repeat''
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
  'SELECT LINK, DAYS, "1A"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY decode(DAYS,''0-1'',1,''2-7'',2,''>7'',3,4)' as IPS_SOURCE_CODE,
  '1A' as IPS_NAME,
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
  'select ''<a href="javascript:openForms(''''DEFECTS'''',''''''||defect_id||'''''');">Navigator'' Navigator
,decode( (select def_defect_id from vw_mai_defects_sdo where def_defect_id = defect_id),null, ''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
       ,''<a href="javascript:showFeatureOnMap(''''''||defect_id||'''''',''''IM_DEFECTS'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map
,decode(im_framework.has_doc(DEFECT_ID,''DEFECTS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showDocAssocsWT(''''''||defect_id||'''''',&APP_ID.,&APP_SESSION.,''''DEFECTS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
,def.*,net.parent_element_description
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
  1121 as IPS_ID,
  460 as IPS_IP_ID,
  2 as IPS_SEQ,
  'SELECT LINK, DAYS, "1A"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''1A''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "1A" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''1A'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS' as IPS_SOURCE_CODE,
  '1A' as IPS_NAME,
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
  'SELECT LINK, DAYS, "2M"
from (select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS' as IPS_SOURCE_CODE,
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
  'SELECT LINK, DAYS, "2L"
from (
select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority union
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw  where days = ''2-7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY DAYS' as IPS_SOURCE_CODE,
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
  'select link, DAYS, "LS"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''||''0-2''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''0-2'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''0-2'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''||''3-5''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''3-5'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''3-5'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''|| ''6-30''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''6-30'' DAYS, count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''6-30'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''13'''', ''''P13_DAYS'''',''''''|| ''>30''||'''''', ''''P3_CONTRACT'''', ''''''||''LS''||'''''', null,null, null,null,null,null);'' as link,  ''>30'' DAYS,  count(*) "LS" from X_WO_TFL_WORK_TRAY_IM511003_LS, x_im511003_wo_vw where days = ''>30'' and work_order_number = works_order_number)
ORDER BY DAYS' as IPS_SOURCE_CODE,
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
  1157 as IPS_ID,
  489 as IPS_IP_ID,
  5 as IPS_SEQ,
  'SELECT LINK, DAYS, "2L"
from (
select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2L''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2L" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2L'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY decode(DAYS,''0-1'',1,''2-7'',2,''>7'',3,4)' as IPS_SOURCE_CODE,
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
  1155 as IPS_ID,
  489 as IPS_IP_ID,
  3 as IPS_SEQ,
  'SELECT LINK, DAYS, "2H"
from (
select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2H''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2H" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2H'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY decode(DAYS,''0-1'',1,''2-7'',2,''>7'',3,4)' as IPS_SOURCE_CODE,
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
  'SELECT LINK, DAYS, "2M"
from (select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null,''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link, ''2-7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw  where days = ''2-7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''2M''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "2M" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''2M'' and work_order_number = works_order_number and def_pri = defect_priority)
ORDER BY decode(DAYS,''0-1'',1,''2-7'',2,''>7'',3,4)' as IPS_SOURCE_CODE,
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
  'SELECT LINK, DAYS, NON
from ( select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511002,x_IM511002_wo_vw where days = ''0-1'' and def_pri = ''NON'' and work_order_number = works_order_number
 UNION
 SELECT ''javascript:showWOWTDrillDown(512.,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' AS LINK, ''2-7'' DAYS, COUNT(*) "NON" FROM X_WO_TFL_WORK_TRAY_IM511002,X_IM511002_WO_VW  WHERE DAYS = ''2-7'' AND DEF_PRI = ''NON'' AND WORK_ORDER_NUMBER = WORKS_ORDER_NUMBER
 UNION
 select ''javascript:showWOWTDrillDown(512,null, ''''9'''', ''''P9_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P9_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511002 ,x_IM511002_wo_vw where days = ''>7'' and def_pri = ''NON'' and work_order_number = works_order_number)
ORDER BY decode(DAYS,''0-1'',1,''2-7'',2,''>7'',3,4)' as IPS_SOURCE_CODE,
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
  1159 as IPS_ID,
  490 as IPS_IP_ID,
  2 as IPS_SEQ,
  'select link, DAYS, "Non LS"
from (
select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''||''0-2''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''0-2'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''0-2'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''||''3-5''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''3-5'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''3-5'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''|| ''6-30''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''6-30'' DAYS, count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''6-30'' and work_order_number = works_order_number
 union
 select ''javascript:showWOWTDrillDown(512,null, ''''3'''', ''''P3_DAYS'''',''''''|| ''>30''||'''''', ''''P3_CONTRACT'''', ''''''||''Non LS''||'''''', null,null, null,null,null,null);'' as link,  ''>30'' DAYS,  count(*) "Non LS" from X_WO_TFL_WORK_TRAY_IM511003NLS, x_im511003_wo_vw where days = ''>30'' and work_order_number = works_order_number)
ORDER BY DAYS' as IPS_SOURCE_CODE,
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
  1120 as IPS_ID,
  460 as IPS_IP_ID,
  1 as IPS_SEQ,
  'SELECT LINK, DAYS, NON
from ( select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''0-1''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''0-1'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511001,x_im511001_wo_vw where days = ''0-1'' and def_pri = ''NON'' and work_order_number = works_order_number
 UNION
 SELECT ''javascript:showWOWTDrillDown(512.,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''2-7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' AS LINK, ''2-7'' DAYS, COUNT(*) "NON" FROM X_WO_TFL_WORK_TRAY_IM511001,X_IM511001_WO_VW  WHERE DAYS = ''2-7'' AND DEF_PRI = ''NON'' AND WORK_ORDER_NUMBER = WORKS_ORDER_NUMBER
 UNION
 select ''javascript:showWOWTDrillDown(512,null, ''''10'''', ''''P10_DAYS'''', ''||''''''''||''>7''||''''''''||'' , ''''P10_PRIORITY'''', ''''''||''Non Defective''||'''''', null,null, null,null,null,null);'' as link,  ''>7'' DAYS, count(*) "NON" from X_WO_TFL_WORK_TRAY_IM511001 ,x_im511001_wo_vw where days = ''>7'' and def_pri = ''NON'' and work_order_number = works_order_number)
ORDER BY DAYS
' as IPS_SOURCE_CODE,
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
  288 as IPS_ID,
  355 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select ''<a href="javascript:openForms(''''WORK_ORDERS'''',''''''||wor.works_order_number||'''''');">Navigator'' Navigator,
decode(DECODE (
             mai_sdo_util.wo_has_shape (559,wor. works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||wor.WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(wor.works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||wor.works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
,wol.WORK_ORDER_LINE_ID WORK_ORDER_LINE_ID,
wor.WORKS_ORDER_NUMBER WORKS_ORDER_NUMBER,
wor.CONTRACTOR_CODE CONTRACTOR_CODE,
wor.ORIGINATOR_NAME ORIGINATOR_NAME,
wor.CONTACT CONTACT,
wol.DEFECT_ID DEFECT_ID,
wol.DEFECT_PRIORITY DEFECT_PRIORITY,
wol.LOCATION_DESCRIPTION LOCATION_DESCRIPTION,
def.DEFECT_DESCRIPTION DEFECT_DESCRIPTION,
def.REPAIR_DESCRIPTION REPAIR_DESCRIPTION,
def.REPAIR_CATEGORY REPAIR_CATEGORY,
wor.DATE_RAISED DATE_RAISED,
wor.WOR_DATE_ATTRIB121 as EOT_Date_Requested,
wor.DATE_INSTRUCTED DATE_INSTRUCTED,
wol.ESTIMATED_COST estimated_cost,
wol.ACTUAL_COST actual_cost,
wor.WORKS_ORDER_STATUS works_order_status,
wor.SCHEME_TYPE scheme_type,
wor.SCHEME_TYPE_DESCRIPTION scheme_type_description,
wol.WORK_CATEGORY work_category,
wol.WORK_CATEGORY_DESCRIPTION work_category_description,
wor.AUTHORISED_BY_NAME authorised_by_name,
wol.DATE_REPAIRED DATE_REPAIRED,
wol.DATE_COMPLETED date_completed,
wor.WOR_CHAR_ATTRIB100 as WO_Process_Status,
wor.WOR_CHAR_ATTRIB101 as WO_Extension_of_Time_Status,
wor.WOR_CHAR_ATTRIB102 as EOT_Reason_for_Request,
wor.WOR_CHAR_ATTRIB103 as EOT_Reason_for_Rejection,
wor.WOR_CHAR_ATTRIB104 as WO_Reason_for_Hold,
wor.WOR_CHAR_ATTRIB105 as WO_Reason_for_Rejection,
wor.WOR_DATE_ATTRIB122 as EOT_Conditional_Date,
bud.COST_CODE,
net.parent_element_description as Borough
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,imf_mai_defect_repairs def,
imf_mai_budgets bud,imf_net_network_members net,hig_audits_vw,
POD_DAY_RANGE r,
pod_nm_element_security,
pod_budget_security
where wor.works_order_number=work_order_number
and wol.defect_id = def.defect_id(+)
and wol.budget_id = bud.budget_id
and wor.works_order_number = haud_pk_id
and haud_table_name = ''WORK_ORDERS''
and wol.network_element_id = child_element_id
and parent_group_type = ''HMBG''
and nvl(works_order_description,''Empty'') not like ''%**Cancelled**%''
and work_order_line_status not in (''COMPLETED'',''ACTIONED'',''INSTRUCTED'')
and WOR_CHAR_ATTRIB100 = ''HLD''
and WOR_CHAR_ATTRIB104 = :P6_PARAM2
and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = wor.works_order_number
                    and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                    and haud_new_value = ''HLD'')
         AND haud_timestamp BETWEEN r.st_range AND r.end_range
         AND r.range_value = :P6_PARAM1
         AND pod_nm_element_security.element_id = wol.network_element_id
         AND pod_budget_security.budget_code = wol.work_category
order by wor.works_order_number,wol.WORK_ORDER_LINE_ID' as IPS_SOURCE_CODE,
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
        from work_due_to_be_comp_base w, POD_DAY_RANGE_REV r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and contract = ''LS''
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,''0-24'',1,''24-72'',2,''Late'',3))' as IPS_SOURCE_CODE,
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
  243 as IPS_ID,
  331 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select ''javascript:doDrillDown(''''IM41031'''',''''''||days2||'''''',  ''''''||''1A''||'''''');'' as link,days2 days,nvl("1A",0) "1A" from
(select days,sum(priority) "1A"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from imf_mai_defects a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''1A''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
  '1A' as IPS_NAME,
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
         || ''LSW''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("LSWORK", 0) "Lump Sum Work"
    FROM (  SELECT days, SUM (reason) "LSWORK"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''LSW''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'LSWORK' as IPS_NAME,
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
  246 as IPS_ID,
  332 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown( ''''IM41021'''', ''''''||x.range_value||'''''');'' as link,
 x.range_value, NVL(data.cnt,0) as rec_count
From
        (
        Select r.range_value, count(*) cnt
        from work_due_to_be_cmp_no_def_base w, POD_DAY_RANGE_REV r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,''0-24'',1,''24-72'',2,''Late'',3))       ' as IPS_SOURCE_CODE,
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                            and WOR_CHAR_ATTRIB104 = ''PRI''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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
  1151 as IPS_ID,
  332 as IPS_IP_ID,
  30 as IPS_SEQ,
  'Select
 ''javascript:doDrillDown( ''''IM41022'''', ''''''||x.range_value||'''''',
 ''''''||''OT''||'''''');'' as link,
 x.range_value, NVL(data.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from work_due_to_be_comp_base w, POD_DAY_RANGE_REV r
        where work_order_status in (''DRAFT'',''INSTRUCTED'')
        and contract != ''LS''
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,''0-24'',1,''24-72'',2,''Late'',3))' as IPS_SOURCE_CODE,
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
  283 as IPS_ID,
  336 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select 
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
NAVIGATOR
 ,WORKS_ORDER_NUMBER
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,WO_EXTENSION_OF_TIME_STATUS
,EOT_Date_Requested
,EOT_Requested_By
,EOT_Reason_for_Request
,EOT_Date_Reviewed
,EOT_reviewed_by
,EOT_Reason_for_Rejection
,EOT_Conditional_Date
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
,REQUESTS
,ESTIMATED_COST
,ACTUAL_COST
,COST_CODE
,WORK_CATEGORY
,WORK_CATEGORY_DESCRIPTION
,AUTHORISED_BY_NAME
,DATE_REPAIRED
,REPAIR_DESCRIPTION
,REPAIR_CATEGORY
,DATE_COMPLETED
from c_pod_eot_requests
where req = ''Initial''
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
  253 as IPS_ID,
  334 as IPS_IP_ID,
  40 as IPS_SEQ,
  'SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''3RD''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("3RDDAM", 0) "3rd Party Damage"
    FROM (  SELECT days, SUM (reason) "3RDDAM"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''3RD''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  284 as IPS_ID,
  351 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select 
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
             ,''<a href="javascript:showWODefOnMap(''''''||WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS,
NAVIGATOR
 ,WORKS_ORDER_NUMBER
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,WO_EXTENSION_OF_TIME_STATUS
,EOT_Date_Requested
,EOT_Requested_By
,EOT_Reason_for_Request
,EOT_Date_Reviewed
,EOT_reviewed_by
,EOT_Reason_for_Rejection
,EOT_Conditional_Date
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
,REQUESTS
,ESTIMATED_COST
,ACTUAL_COST
,COST_CODE
,WORK_CATEGORY
,WORK_CATEGORY_DESCRIPTION
,AUTHORISED_BY_NAME
,DATE_REPAIRED
,REPAIR_DESCRIPTION
,REPAIR_CATEGORY
,DATE_COMPLETED
from c_pod_eot_requests
where req = ''Repeat''
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
  251 as IPS_ID,
  334 as IPS_IP_ID,
  20 as IPS_SEQ,
  'SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''BOQ''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("BOQINV", 0) "Invalid BOQ"
    FROM (  SELECT days, SUM (reason) "BOQINV"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''BOQ''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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
  252 as IPS_ID,
  334 as IPS_IP_ID,
  30 as IPS_SEQ,
  'SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''WCC''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CCINV", 0) "Wrong Cost Code"
    FROM (  SELECT days, SUM (reason) "CCINV"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''WCC''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id ' as IPS_SOURCE_CODE,
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
  249 as IPS_ID,
  333 as IPS_IP_ID,
  10 as IPS_SEQ,
  'Select  ''javascript:doDrillDown( ''''IM41041'''', ''''''||eot||'''''');'' as link, sq.*
From (
         Select  WO_Extension_of_Time_Status EOT, count(WO_Extension_of_Time_Status) count
         from pod_eot_updated
         where WO_Extension_of_Time_Status in (''Approved'',''Conditional'',''Rejected'') 
         group by WO_Extension_of_Time_Status
    union 
     select ''No Data found'' eot,0 count
     from dual 
     where not exists (select 1 from pod_eot_updated
         where WO_Extension_of_Time_Status in (''Approved'',''Conditional'',''Rejected'') )
         ) sq
' as IPS_SOURCE_CODE,
  'Updated EOTs' as IPS_NAME,
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
  254 as IPS_ID,
  334 as IPS_IP_ID,
  50 as IPS_SEQ,
  'SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''NPH''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("NOPHOT", 0) "No Photos"
    FROM (  SELECT days, SUM (reason) "NOPHOT"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''NPH''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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
  258 as IPS_ID,
  334 as IPS_IP_ID,
  90 as IPS_SEQ,
  'SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''CSH''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("CNSCHWO", 0) "Cancel and add to scheme WO"
    FROM (  SELECT days, SUM (reason) "CNSCHWO"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''CSH''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  289 as IPS_ID,
  356 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select 
decode(DECODE (
             mai_sdo_util.wo_has_shape (559, works_order_number),
             ''TRUE'', ''Y'',
             ''N''),''N'',''<img width=24 height=24 src="/im4_framework/images/grey_globe.png" title="No Location">''
                ,''<a href="javascript:showWODefOnMap(''''''||pod_eot_updated.WORKs_ORDER_NUMBER||'''''',''''~'''');" ><img width=24 height=24 src="/im4_framework/images/globe_64.gif" title="Find on Map"></a>'') map ,          
decode(x_im_wo_has_doc(works_order_number,''WORK_ORDERS''),0,
              ''<img width=24 height=24 src="/im4_framework/images/mfclosed.gif" alt="No Documents">''
             ,''<a href="javascript:showWODocAssocs(''''''||pod_eot_updated.works_order_number||'''''',&APP_ID.,&APP_SESSION.,''''WORK_ORDERS'''')" ><img width=24 height=24
src="/im4_framework/images/mfopen.gif" alt="Show Documents"></a>'') DOCS
, navigator
,WORKS_ORDER_NUMBER
,WORK_ORDER_LINE_ID
,WORKS_ORDER_STATUS
,CONTRACTOR_CODE
,WO_EXTENSION_OF_TIME_STATUS
,EOT_DATE_REQUESTED
,EOT_REQUESTED_BY
,EOT_REASON_FOR_REQUEST
,EOT_DATE_REVIEWED
,EOT_REVIEWED_BY
,EOT_REASON_FOR_REJECTION
,EOT_CONDITIONAL_DATE
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
,REQUESTS
,ESTIMATED_COST
,ACTUAL_COST
,COST_CODE
,WORK_CATEGORY
,WORK_CATEGORY_DESCRIPTION
,AUTHORISED_BY_NAME
,DATE_REPAIRED
,REPAIR_DESCRIPTION
,REPAIR_CATEGORY
,DATE_COMPLETED
 from pod_eot_updated 
where WO_Extension_of_Time_Status =  :P6_PARAM1' as IPS_SOURCE_CODE,
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
  260 as IPS_ID,
  335 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select ''javascript:doDrillDown( ''''IM41038'''',''''''|| r2.range_value||'''''',  ''''''||''SCH''||'''''');''  as link
, r2.range_value,nvl("SCHWRKS",0) "Include in Scheme Works" from
(select days,sum(reason) "SCHWRKS" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
  pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = ''WORK_ORDERS''
and works_order_number=work_order_number
and nvl(works_order_description,''Empty'') not like ''%**Cancelled**%''
and work_order_line_status not in (''COMPLETED'',''ACTIONED'',''INSTRUCTED'')
and WOR_CHAR_ATTRIB100 = ''HLD''
and WOR_CHAR_ATTRIB104 = ''SCH''
and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                    and haud_new_value = ''HLD'')
                    AND haud_timestamp BETWEEN r.st_range AND r.end_range
                    AND pod_nm_element_security.element_id = wol.network_element_id
                    AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'SCHWRKS' as IPS_NAME,
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
  'select ''javascript:doDrillDown( ''''IM41038'''',''''''|| r2.range_value||'''''',  ''''''||''RISKTFL''||'''''');''  as link
, r2.range_value,nvl("RISKTFL",0) "Risk managed by TfL" from
(select days,sum(reason) "RISKTFL" from
(select distinct   r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,POD_DAY_RANGE r,
 pod_nm_element_security,
pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = ''WORK_ORDERS''
and works_order_number=work_order_number
and nvl(works_order_description,''Empty'') not like ''%**Cancelled**%''
and work_order_line_status not in (''COMPLETED'',''ACTIONED'',''INSTRUCTED'')
and WOR_CHAR_ATTRIB100 = ''HLD''
and WOR_CHAR_ATTRIB104 = ''RISKTFL''
and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                    and haud_new_value = ''HLD'')
                    AND haud_timestamp BETWEEN r.st_range AND r.end_range
                    AND pod_nm_element_security.element_id = wol.network_element_id
                    AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id
' as IPS_SOURCE_CODE,
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
  255 as IPS_ID,
  334 as IPS_IP_ID,
  60 as IPS_SEQ,
  '  SELECT    ''javascript:doDrillDown( ''''IM41037'''' ,''''''
         || r2.range_value
         || '''''',  ''''''
         || ''VIS''
         || '''''');''
            AS link,
         r2.range_value,
         NVL ("NODEFVIS", 0) "No Defect Visible"
    FROM (  SELECT days, SUM (reason) "NODEFVIS"
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
                           AND haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 ''WOR_CHAR_ATTRIB100''
                                          AND haud_new_value = ''REJ'')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = ''VIS''
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
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

MERGE INTO IM_POD_SQL A USING
 (SELECT
  259 as IPS_ID,
  335 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select ''javascript:doDrillDown( ''''IM41038'''',''''''|| r2.range_value||'''''',  ''''''||''BDG''||'''''');''  as link
, r2.range_value,nvl("BUDCONST",0) "Budgetary Constraints" from
(select days,sum(reason) "BUDCONST" from
(select distinct  r.range_value days
,1 reason,works_order_number
from ximf_mai_work_orders_all_attr wor,ximf_mai_work_order_lines wol,hig_audits_vw,
 POD_DAY_RANGE r,
 pod_nm_element_security,
 pod_budget_security
where works_order_number=haud_pk_id
and haud_table_name = ''WORK_ORDERS''
and works_order_number=work_order_number
and nvl(works_order_description,''Empty'') not like ''%**Cancelled**%''
and work_order_line_status not in (''COMPLETED'',''ACTIONED'',''INSTRUCTED'')
and WOR_CHAR_ATTRIB100 = ''HLD''
and WOR_CHAR_ATTRIB104 = ''BDG''
and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
and haud_timestamp = (select max(haud_timestamp) from hig_audits_vw where haud_pk_id = works_order_number
                    and haud_attribute_name = ''WOR_CHAR_ATTRIB100''
                    and haud_new_value = ''HLD'')
                     AND haud_timestamp BETWEEN r.st_range AND r.end_range
                     AND pod_nm_element_security.element_id = wol.network_element_id
                     AND pod_budget_security.budget_code = wol.work_category
)
group by days
order by days),
POD_DAY_RANGE r2
WHERE days(+) =r2.range_value
ORDER BY r2.range_id' as IPS_SOURCE_CODE,
  'BUDCONST' as IPS_NAME,
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

COMMIT;
