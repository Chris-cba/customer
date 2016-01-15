   create or replace view c_pod_eot_updated_dd as
   --
   With Haud as
    (SELECT HAUD_PK_ID HAUD_PK_ID, 
                    HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                    MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP, HAUD_NEW_VALUE
               FROM HIG_AUDITS
              WHERE 1=1
                    AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                    and HAUD_ATTRIBUTE_NAME = 'WOR_CHAR_ATTRIB101'
                    --AND HAUD_NEW_VALUE IS NOT null
					AND HAUD_NEW_VALUE in ('APP', 'CND', 'REJ')
                    AND HAUD_TIMESTAMP >= SYSDATE - 30.1                    
           GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME, HAUD_NEW_VALUE) 
  --
  SELECT DISTINCT
             '<A HREF="JAVASCRIPT:openForms(''WORK_ORDERS'','''
          || WOR.WORKS_ORDER_NUMBER
          || ''');">NAVIGATOR'
             NAVIGATOR,
          WOL.WORK_ORDER_LINE_ID,
          WOR.WORKS_ORDER_NUMBER,
          WOR.CONTRACTOR_CODE,
          WOR.ORIGINATOR_NAME,
          WOR.CONTACT,
          WOL.DEFECT_ID,
          WOL.DEFECT_PRIORITY,
          WOL.LOCATION_DESCRIPTION,
          DEF.DEFECT_DESCRIPTION,
          DEF.REPAIR_DESCRIPTION,
          DEF.REPAIR_CATEGORY,
          WOR.DATE_RAISED,
          WOR.WOR_DATE_ATTRIB121 AS EOT_DATE_REQUESTED,
          WOR.DATE_INSTRUCTED,
          WOL.ESTIMATED_COST,
          WOL.ACTUAL_COST,
          WOR.WORKS_ORDER_STATUS,
          WOR.SCHEME_TYPE,
          WOR.SCHEME_TYPE_DESCRIPTION,
          WOL.WORK_CATEGORY,
          WOL.WORK_CATEGORY_DESCRIPTION,
          WOR.AUTHORISED_BY_NAME,
          WOL.DATE_REPAIRED,
          WOL.DATE_COMPLETED,
          --WOR.WOR_CHAR_ATTRIB100 AS "WO PROCESS STATUS",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB100',
                                           WOR.WOR_CHAR_ATTRIB100)
             AS "WO PROCESS STATUS",
          --NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB100'), WOR.WOR_CHAR_ATTRIB100) "WO PROCESS STATUS DESCR",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB101',
                                           WOR.WOR_CHAR_ATTRIB101)
             AS "WO EXTENSION OF TIME STATUS",
          --NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB101'), WOR.WOR_CHAR_ATTRIB101)  "WO EXT OF TIME STATUS DESCR",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB102',
                                           WOR.WOR_CHAR_ATTRIB102)
             AS "EOT REASON FOR REQUEST",
          -- NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB102'), WOR.WOR_CHAR_ATTRIB102)  "EOT REASON FOR REQUEST DESCR",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB103',
                                           WOR.WOR_CHAR_ATTRIB103)
             AS "EOT REASON FOR REJECTION",
          -- NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB103'), WOR.WOR_CHAR_ATTRIB103)  "EOT REASON FOR REJECTION DESCR",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB104',
                                           WOR.WOR_CHAR_ATTRIB104)
             AS "WO REASON FOR HOLD",
          --NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB104'), WOR.WOR_CHAR_ATTRIB104) "WO REASON FOR HOLD DESCR",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB105',
                                           WOR.WOR_CHAR_ATTRIB105)
             AS "WO REASON FOR REJECTION",
          --NM3INV.GET_INV_DOMAIN_MEANING(NM3INV.GET_ATTRIB_DOMAIN('WOF','WOR_CHAR_ATTRIB105'), WOR.WOR_CHAR_ATTRIB105)  "WO REASON FOR REJECTION DESCR",
          WOR.WOR_DATE_ATTRIB122 AS "EOT CONDITIONAL DATE",
		  WOR.WOR_DATE_ATTRIB129 AS "DATE PRICE EXT REQUESTED",
		  WOR.WOR_CHAR_ATTRIB72 AS "REASON FOR PRICING EXTENSION",
		  WOR.WOR_CHAR_ATTRIB66 AS "PRICE EXTENSION ACCEPTED",
          BUD.COST_CODE,
          NET.PARENT_ELEMENT_DESCRIPTION AS "BOROUGH",
          C.CON_ADMIN_ORG_ID CON_AU,
          1 REQUESTS,
          (SELECT HUS_NAME
             FROM HIG_USERS
            WHERE HUS_USER_ID = WOR.WOR_NUM_ATTRIB10)
             EOT_REQUESTED_BY,
          WOR_DATE_ATTRIB123 AS EOT_DATE_REVIEWED,
          (SELECT HUS_NAME
             FROM HIG_USERS
            WHERE HUS_USER_ID = WOR.WOR_NUM_ATTRIB11)
             EOT_DATE_REVIEWED_BY
     FROM IMF_MAI_WORK_ORDERS_ALL_ATTRIB WOR,
          IMF_MAI_WORK_ORDER_LINES WOL,
          IMF_MAI_DEFECT_REPAIRS DEF,
          IMF_MAI_BUDGETS BUD,
          CONTRACTS C,
          IMF_NET_NETWORK_MEMBERS NET,
          POD_BUDGET_SECURITY BUD_SEC,
          POD_NM_ELEMENT_SECURITY ELE_SEC,
          (  SELECT HAUD_PK_ID RA_HAUD_PK_ID, HAUD_ATTRIBUTE_NAME RA_HAUD_ATTRIBUTE_NAME, HAUD_TIMESTAMP RA_MAX_TS FROM HAUD) RA,  -- moved into With
          (SELECT HUS_ADMIN_UNIT USER_AU
             FROM HIG_USERS
            WHERE HUS_USERNAME = USER) AU,
          (SELECT NVL (MWU_RESTRICT_BY_ROAD_GROUP, 'N') RD_RST,
                  NVL (MWU_RESTRICT_BY_WORKCODE, 'N') WC_RST
             FROM MAI_WO_USERS, HIG_USERS
            WHERE MWU_USER_ID = HUS_USER_ID AND HUS_USERNAME = USER) SEC
    WHERE     WOR.WORKS_ORDER_NUMBER = WORK_ORDER_NUMBER
          AND WOR.WORKS_ORDER_NUMBER = RA_HAUD_PK_ID
          AND WOL.DEFECT_ID = DEF.DEFECT_ID(+)
          AND WOL.BUDGET_ID = BUD.BUDGET_ID
          AND WOL.NETWORK_ELEMENT_ID = CHILD_ELEMENT_ID
          AND PARENT_GROUP_TYPE = 'HMBG'
          AND WORK_ORDER_LINE_STATUS NOT IN ('COMPLETED', 'ACTIONED', 'PRELOHAC', 'INTERIM')
          AND upper(NVL (WORKS_ORDER_DESCRIPTION, 'EMPTY')) NOT LIKE '%**CANCELLED**%'
          AND NVL (WOR_CHAR_ATTRIB100, 'EMPTY') NOT IN ('REJ', 'HLD')
          AND WOR_DATE_ATTRIB121 IS NOT NULL
          AND WOR.CONTRACT_ID = C.CON_ID
          AND USER_AU IN (1, C.CON_ADMIN_ORG_ID)
          --AND WOR_CHAR_ATTRIB101 = DECODE(:P6_PARAM1,'APPROVED','APP','CONDITIONAL','CND','REJECTED','REJ')
          --AND RA_MAX_TS >= sysdate - 360
          AND WOL.NETWORK_ELEMENT_ID = ELE_SEC.ELEMENT_ID
          AND WOL.WORK_CATEGORY = BUD_SEC.BUDGET_CODE;