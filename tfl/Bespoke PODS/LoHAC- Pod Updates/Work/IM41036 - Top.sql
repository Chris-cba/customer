 
 
 SELECT    'javascript:doDrillDown( ''IM41038'' ,'''
         || r2.range_value
         || ''',  '''
         || WOR_CHAR_ATTRIB104
         || ''');'
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') WOR_CHAR_ATTRIB104 
              FROM  (SELECT DISTINCT *
                      FROM X_LOHAC_IM_IM41036_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') = 'LSW'
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

'LSW'
'BDG'
'BOQ'
'SCH'
'TOHLD'

'WCC'
'3RD'
'NPH'

'VIS'
'PRI'

'NOT'
'CSH'
'RISKTFL'
'TOREQ'


'NO_REASON'


--------------
 SELECT    'javascript:doDrillDown( ''IM41038a'' ,'''
         || r2.range_value
         || ''',  '''
         || WOR_CHAR_ATTRIB104
         || ''');'
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, 'NO_BUD') WOR_CHAR_ATTRIB104 
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41036_POD_NOBUD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, 'NO_BUD') = 'NO_BUD'
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id