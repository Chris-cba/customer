-- 
-- im_pod_sql
--
SET DEFINE OFF;

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
,1 priority from x_IM_MAI_DEFECTS a
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
,1 priority from x_IM_MAI_DEFECTS a
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
,1 priority from x_IM_MAI_DEFECTS a
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
,1 priority from x_IM_MAI_DEFECTS a
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
from x_IM_MAI_DEFECTS def,imf_net_network_members net
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
COMMIT;

