SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  10 as IPS_ID,
  331 as IPS_IP_ID,
  40 as IPS_SEQ,
  'select ''javascript:doDrillDown(''''IM41031'''',''''''||days2||'''''',  ''''''||''1E''||'''''');'' as link,days2 days,nvl("1E",0) "1E" from
(select days,sum(priority) "1E"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then ''1''
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then ''2-5''
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then ''6-60''
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then ''60-90'' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in (''AVAILABLE'',''INSTRUCTED'')
and works_order_number is null
and activity_code != ''PU''
and priority = ''1E''
)
group by days
order by days),
(select days2 from
(select ''1'' as days2 from dual) union (select ''2-5'' as days2 from dual)
union (select ''6-60'' as days2 from dual) union (select ''60-90'' as days2 from dual))
where days(+)=days2
order by days2' as IPS_SOURCE_CODE,
  '-1E-' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
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
