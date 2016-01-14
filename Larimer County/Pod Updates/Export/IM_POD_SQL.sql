SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  542 as IPS_ID,
  742 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
--ne_id
ne_unique Route
,ne_descr Description
--,ne_no_start
--,ne_no_end
--,ne_nt_type 
--,ne_type
--
,''<a href="javascript:doDrillDown(''''IM90232'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''SREPORT'')||''" alt="Report Card"></a>'' "Report Card"  --sample_report.gif
,''<a href="javascript:doDrillDown(''''IM90233'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''AMBULANCE'')||''" alt="Accident Summary"></a>''  "Accident Summary" -- ambulance-24x24x8b.png
,''<a href="javascript:doDrillDown(''''IM90234'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''CALC'')||''" alt="Traffic Count"></a>'' "Traffic Count" --calculator_go.png
--
, decode(im_framework.has_doc(ne_id,''ROAD_SEGMENTS_ALL''),0,
''<img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''MFCLOSED'')||''" alt="No Documents">''
,''<a href="javascript:showDocAssocsWT(''||ne_id||'',&APP_ID.,&APP_SESSION.,''''ROAD_SEGMENTS_ALL'''')" ><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''MFOPEN'')||''" alt="Show Documents"></a>'') DOCS
,decode(road_network_sdo_id,null,
''<img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''GG'')||''" alt="No Location">''
,''<a href="javascript:showLarimerNetonMap(''''''||ne_unique||'''''');" ><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''G64'')||''" alt="Find on Map"></a>'') map
from nm_elements, road_network_sdo_table
where ne_id = road_network_sdo_id(+)
and ne_type=''S''
and ne_group= :P6_PARAM1' as IPS_SOURCE_CODE,
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
  561 as IPS_ID,
  761 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select b.ne_group ne_group,
''<a href="javascript:doDrillDown(''''IM90231'''',''''''  ||b.ne_group || '''''','''''' || null || '''''','''''' || null  || '''''');"><font face="verdana" color="blue"><u>''|| a.ne_descr ||''</u></font></a>'' Route
from nm_elements a, (select distinct nm_ne_id_in, ne_group from nm_members, nm_elements where nm_ne_id_of = ne_id and ne_type=''S'') b
where 1=1
and a.ne_id = b.nm_ne_id_in
and a.ne_nt_Type=''CRTE''
and a.ne_type=''G''
order by b.ne_group' as IPS_SOURCE_CODE,
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
  5 as IPS_ID,
  81 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select 
"Scored Area"
,"Condition Index"
,"Condition Grade"
,"Accident Rate"
,"Accident Grade"
,"Length in Miles"
from (
--
select 
SCORED_AREA"Scored Area"
,CONDITION_INDEX"Condition Index"
,CONDITION_GRADE "Condition Grade"
,ACC_RATE "Accident Rate"
,ACC_GRADE "Accident Grade"
,LENGTH_IN_MILES "Length in Miles"
, 0 as sorter
from LARIMER_COUNTY.xlar_county_scores_gaz
--
UNION
--
select 
null "Scored Area"
, null "Condition Index"
, null "Condition Grade"
, null "Accident Rate"
, null "Accident Grade"
, null "Length in Miles" 
, 1 as sorter from dual
--
UNION
--
select 
''<a href="javascript:doDrillDown(''''IM90231RS'''')">Select Route</a>'' "Scored Area"
, null "Condition Index"
, null "Condition Grade"
, null "Accident Rate"
, null "Accident Grade"
, null "Length in Miles" 
, 2 as sorter from dual
) order by sorter' as IPS_SOURCE_CODE,
  's' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
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
  543 as IPS_ID,
  743 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select
--NE_ID,
Ne_Unique "Road",
Avg_Pvin_Cond "Condition",
Condition_Grade "Condition Grade",
Acc_Rate "Accident Rate",
Acc_Count "Accident Count",
Accident_Grade "Accident Grade",
Surf_Type "Surface Type",
Average_Road_Width "Surface Width",
--Ne_Length_Ft "Length In Feet",
Ne_Length_Miles "Length In Miles",
Adt_Adj "Average Daily Traffic Count",
Count_Year "Count Year",
Capacity_Ratio  "Capacity Ratio",
Capacity_Grade "Capacity Grade",
Condition "Condition",
Capacity  "Capacity",
Safety "Safety"
from xlar_im_report_card_Decode1
where ne_id = :P6_PARAM1
' as IPS_SOURCE_CODE,
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
  544 as IPS_ID,
  744 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select b.aal_meaning "Severity",nvl(sev_Count,0) "Severity Count" from 
(
select aal_meaning,sev_Count
from XLAR_MV_LCRB_ACC_SEV_3_YEAR
,acc_attr_lookup
where aia_value=aal_value
and aal_aad_id=''ASEV''
and alo_ne_id=:P6_PARAM1
) a
, (select * from acc_attr_lookup where aal_aad_id=''ASEV'') b
where a.aal_meaning(+) = b.aal_meaning
order by b.aal_meaning
' as IPS_SOURCE_CODE,
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
  545 as IPS_ID,
  745 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select count_year "Count Year",adt_adj "Count"
from xlar_v_adt
where ne_id_of=:P6_PARAM1
' as IPS_SOURCE_CODE,
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

COMMIT;

SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  542 as IPS_ID,
  742 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
--ne_id
ne_unique Route
,ne_descr Description
--,ne_no_start
--,ne_no_end
--,ne_nt_type 
--,ne_type
--
,''<a href="javascript:doDrillDown(''''IM90232'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''SREPORT'')||''" alt="Report Card"></a>'' "Report Card"  --sample_report.gif
,''<a href="javascript:doDrillDown(''''IM90233'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''AMBULANCE'')||''" alt="Accident Summary"></a>''  "Accident Summary" -- ambulance-24x24x8b.png
,''<a href="javascript:doDrillDown(''''IM90234'''',''''''  || ne_id || '''''','''''' || null || '''''','''''' || null  || '''''');"><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''CALC'')||''" alt="Traffic Count"></a>'' "Traffic Count" --calculator_go.png
--
, decode(im_framework.has_doc(ne_id,''ROAD_SEGMENTS_ALL''),0,
''<img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''MFCLOSED'')||''" alt="No Documents">''
,''<a href="javascript:showDocAssocsWT(''||ne_id||'',&APP_ID.,&APP_SESSION.,''''ROAD_SEGMENTS_ALL'''')" ><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''MFOPEN'')||''" alt="Show Documents"></a>'') DOCS
,decode(road_network_sdo_id,null,
''<img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''GG'')||''" alt="No Location">''
,''<a href="javascript:showLarimerNetonMap(''''''||ne_unique||'''''');" ><img width=24 height=24 src="''||(select imagedir || filename from xim_icons where item = ''G64'')||''" alt="Find on Map"></a>'') map
from nm_elements, road_network_sdo_table
where ne_id = road_network_sdo_id(+)
and ne_type=''S''
and ne_group= :P6_PARAM1
order by ne_unique' as IPS_SOURCE_CODE,
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

COMMIT;

