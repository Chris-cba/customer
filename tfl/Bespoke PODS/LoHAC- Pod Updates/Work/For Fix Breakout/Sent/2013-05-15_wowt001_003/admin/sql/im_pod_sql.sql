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
  102 as IPS_ID,
  490 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select ''javascript:showWOWTDrillDown(512,null, ''''23'''', ''''P23_DAYS'''', ''||''''''''|| dr.range_value ||''''''''||'' , ''''P23_PRIORITY'''', ''''''||code||'''''', null,null, null,null,null,null);'' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from
    (select   range_value, ''TOR'' Code, count(*) CNT
        from  X_WO_TFL_WT_IM511003_NOBUD, X_LOHAC_DateRANGE_WOWT003 dr
        where 1=1
        --and con_code not in (''HLSC'', ''HLSR'', ''SLSC'', ''SLSR'')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
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

COMMIT;
