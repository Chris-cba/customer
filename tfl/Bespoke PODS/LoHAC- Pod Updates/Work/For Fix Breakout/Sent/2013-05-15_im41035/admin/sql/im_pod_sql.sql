SET DEFINE OFF;
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

MERGE INTO HIGHWAYS.IM_POD_SQL A USING
 (SELECT
  105 as IPS_ID,
  334 as IPS_IP_ID,
  70 as IPS_SEQ,
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
