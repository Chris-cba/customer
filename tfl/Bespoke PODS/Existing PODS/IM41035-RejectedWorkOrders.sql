/* Needs
	-LSW
-BDG
	-BOQ
-SCH
-TOHLD
	-WCC
	-3RD
	-NPH
	-VIS
	-PRI
-NOT
	-CSH
-RISKTFL
-TOREQ


*/

-- LSW
 SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'LSW'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'LSW'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id


--BOQINV

SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'BOQ'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'BOQ'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--CCINV
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'WCC'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'WCC'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

--3rd
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || '3RD'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = '3RD'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--NOPOT
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'NPH'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'NPH'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--NODEFVIS
  SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'VIS'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
                           AND works_order_number = work_order_number
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'VIS'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--INCDEFPRI
  SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'PRI'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                            and WOR_CHAR_ATTRIB104 = 'PRI'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id

--CNSCHWO
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''
         || 'CSH'
         || ''');'
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'CSH'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id


-- BDG
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'BDG'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("BDG", 0) "Budget Constraints"
    FROM (  SELECT days, SUM (reason) "BDG"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
                           AND works_order_number = work_order_number
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'BDG'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

-- SCH
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'SCH'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("SCH", 0) "TBI Scheme Works"
    FROM (  SELECT days, SUM (reason) "SCH"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
                           AND works_order_number = work_order_number
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'SCH'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

-- TOHLD
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'TOHLD'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("TOHLD", 0) "Task_Order_Held"
    FROM (  SELECT days, SUM (reason) "TOHLD"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'TOHLD'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

-- NOT
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'NOT'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("NOT", 0) "Not on TLRN"
    FROM (  SELECT days, SUM (reason) "NOT"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'NOT'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

-- RISKTFL
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'RISKTFL'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("RISKTFL", 0) "RISK TFL"
    FROM (  SELECT days, SUM (reason) "RISKTFL"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
                           AND works_order_number = work_order_number
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'RISKTFL'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 

-- TOREQ
SELECT    'javascript:doDrillDown( ''IM41037'' ,'''
         || r2.range_value
         || ''',  '''

         || 'TOREQ'
         || ''');'
            AS link,
         r2.range_value,

         NVL ("TOREQ", 0) "TO ReQuote Required"
    FROM (  SELECT days, SUM (reason) "TOREQ"
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
                           AND haud_table_name = 'WORK_ORDERS'
						   AND WOR_CHAR_ATTRIB100 = 'REJ'
						   AND work_order_line_status NOT IN('COMPLETED', 'ACTIONED', 'INSTRUCTED')
                           AND works_order_number = work_order_number
                           AND haud_attribute_name = 'WOR_CHAR_ATTRIB100'
                           AND haud_timestamp =
                                  (SELECT MAX (haud_timestamp)
                                     FROM hig_audits_vw
                                    WHERE haud_pk_id = works_order_number
                                          AND haud_attribute_name =
                                                 'WOR_CHAR_ATTRIB100'
                                          AND haud_new_value = 'REJ')
                           AND haud_timestamp BETWEEN r.st_range AND r.end_range
                           and WOR_CHAR_ATTRIB104 = 'TOREQ'
                           AND pod_nm_element_security.element_id = wol.network_element_id
                           AND pod_budget_security.budget_code = wol.work_category )
          GROUP BY days
          ORDER BY days),
           POD_DAY_RANGE r2
   WHERE days(+) =r2.range_value
ORDER BY r2.range_id 


