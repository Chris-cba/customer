SET DEFINE OFF;
MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  85 as IPS_ID,
  44 as IPS_IP_ID,
  40 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  86 as IPS_ID,
  44 as IPS_IP_ID,
  50 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  87 as IPS_ID,
  44 as IPS_IP_ID,
  60 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  88 as IPS_ID,
  44 as IPS_IP_ID,
  70 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  89 as IPS_ID,
  44 as IPS_IP_ID,
  80 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  103 as IPS_ID,
  44 as IPS_IP_ID,
  90 as IPS_SEQ,
  'select link, range_value, tot  from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' ,  ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  1=1
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       and (haud_new_value is null or haud_new_value = ''APPUN''    )
       order by sorter
       )' as IPS_SOURCE_CODE,
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
  'Awaiting Review â€“ Updated Application' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
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
  'Awaiting Review â€“ New Comments' as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
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
  13 as IPS_ID,
  44 as IPS_IP_ID,
  10 as IPS_SEQ,
  'select link, range_value, tot "Approved" from (
        With Date_range as(
        select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  14 as IPS_ID,
  44 as IPS_IP_ID,
  30 as IPS_SEQ,
  'select link, range_value, tot "Awaiting Reviewâ€™" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' ,  ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  15 as IPS_ID,
  44 as IPS_IP_ID,
  20 as IPS_SEQ,
  'select link, range_value, tot "Rejected" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''60'''', ''''P60_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P60_PRIORITY'''',''|| ''''''''||haud_new_value||'''''', null,null, null,null,null,null);''
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

COMMIT;
