 
 
 SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || WOR_CHAR_ATTRIB104
         || ''');'
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') WOR_CHAR_ATTRIB104 
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, 'NO_REASON') = 'LSWORK'
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

'LSWORK'
'BDG'
'BOQ'
'SCH'
'TOHLD'

'WCC'
'3RDDAM'
'NPH'

'VIS'
'PRI'

'NOT'
'CSH'
'RISKTFL'
'TOREQ'

BOQINV
CCINV
NOPOT
INCDEFPRI
'NO_REASON'


-- No Budget

 SELECT    'javascript:doDrillDown( ''IM41037a'' ,'''
         || r2.range_value
         || ''',  '''
         || WOR_CHAR_ATTRIB104
         || ''');'
            AS link,
         r2.range_value,
         NVL ("CNT", 0) "CNT"
    FROM (  SELECT days, SUM (reason) "CNT", NVL(WOR_CHAR_ATTRIB104, 'NO_BUD') WOR_CHAR_ATTRIB104 
              FROM  (SELECT *
                      FROM X_LOHAC_IM_IM41035_POD_NOBUD
                     WHERE 1=1
					 AND NVL(WOR_CHAR_ATTRIB104, 'NO_BUD') = 'NO_BUD'
                     )
          GROUP BY days, WOR_CHAR_ATTRIB104
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id