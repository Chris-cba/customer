 Create or replace view C_POD_EOP_REQUESTS as
 --
 With Haud as
    (SELECT HAUD_PK_ID HAUD_PK_ID, 
                    HAUD_ATTRIBUTE_NAME HAUD_ATTRIBUTE_NAME,
                    MAX (HAUD_TIMESTAMP) HAUD_TIMESTAMP
               FROM HIG_AUDITS
              WHERE 1=1
                    AND HAUD_TABLE_NAME = 'WORK_ORDERS'
                    and HAUD_ATTRIBUTE_NAME = 'WOR_DATE_ATTRIB129'
                    --AND HAUD_NEW_VALUE IS NOT null
                    AND HAUD_TIMESTAMP >= (select min(st_range) from pod_day_range)                     
           GROUP BY HAUD_PK_ID, HAUD_ATTRIBUTE_NAME)
--      
,IntialRepeat as
(
select ha.haud_pk_id, count(*) cnt from hig_audits HA, haud
where haud.haud_pk_id = ha.haud_pk_id 
and ha.HAUD_TABLE_NAME = 'WORK_ORDERS'
and ha.HAUD_ATTRIBUTE_NAME = 'WOR_DATE_ATTRIB129'
group by ha.haud_pk_id
)
 SELECT DISTINCT
             '<A HREF="javascript:openForms(''WORK_ORDERS'','''
          || WOR.WORKS_ORDER_NUMBER
          || ''');">NAVIGATOR'
             NAVIGATOR,
          WOL.WORK_ORDER_LINE_ID,
          WOR.WORKS_ORDER_NUMBER,
          WORK_ORDER_LINE_STATUS,
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
          1 REQUESTS,
          WOR.WOR_DATE_ATTRIB121 AS "EOT DATE REQUESTED",
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
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB100',
                                           WOR.WOR_CHAR_ATTRIB100)
             AS "WO PROCESS STATUS",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB101',
                                           WOR.WOR_CHAR_ATTRIB101)
             AS "WO EXTENSION OF TIME STATUS",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB102',
                                           WOR.WOR_CHAR_ATTRIB102)
             AS "EOT REASON FOR REQUEST",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB103',
                                           WOR.WOR_CHAR_ATTRIB103)
             AS "EOT REASON FOR REJECTION",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB104',
                                           WOR.WOR_CHAR_ATTRIB104)
             AS "WO REASON FOR HOLD",
          DISCO.JG_GET_DEC_INV_ATTR_VALUE ('WFX$',
                                           'WOR_CHAR_ATTRIB105',
                                           WOR.WOR_CHAR_ATTRIB105)
             AS "WO REASON FOR REJECTION",
          WOR.WOR_DATE_ATTRIB122 AS "EOT CONDITIONAL DATE",
          BUD.COST_CODE,
          WOR.WOR_DATE_ATTRIB129 AS "DATE PRICE EXTENSION REQUESTED",
          WOR.WOR_CHAR_ATTRIB72 AS "REASON FOR PRICING EXTENSION",
          NET.PARENT_ELEMENT_DESCRIPTION AS "BOROUGH",
          --           (CASE
          --               WHEN WOR_CHAR_ATTRIB101 != 'CND'
          --               THEN
          --                  (SELECT RANGE_VALUE
          --                     FROM POD_DAY_RANGE
          --                    WHERE RA_MAX_TS BETWEEN ST_RANGE AND END_RANGE)
          --            END) DAYS,
          (SELECT RANGE_VALUE
             FROM POD_DAY_RANGE
            WHERE HAUD_TIMESTAMP BETWEEN ST_RANGE AND END_RANGE)
             DAYS,
          (CASE
              WHEN IntialRepeat.cnt  = 1        THEN                 'INITIAL'
              WHEN IntialRepeat.cnt  > 1         THEN                'REPEAT'
           END)
             REQ,
          ROUND (SYSDATE - HAUD_TIMESTAMP) DAYS_SINCE_APP,
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
          IMF_NET_NETWORK_MEMBERS NET,
          --HIG_AUDITS_VW,
          CONTRACTS C,
          POD_BUDGET_SECURITY BUD_SEC,
          POD_NM_ELEMENT_SECURITY ELE_SEC,
          HAUD RA,
          IntialRepeat,
          (SELECT HUS_ADMIN_UNIT USER_AU
             FROM HIG_USERS
            WHERE HUS_USER_ID = NM3USER.GET_USER_ID) AU,
          (SELECT NVL (MWU_RESTRICT_BY_ROAD_GROUP, 'N') RD_RST,
                  NVL (MWU_RESTRICT_BY_WORKCODE, 'N') WC_RST
             FROM MAI_WO_USERS, HIG_USERS
            WHERE MWU_USER_ID = HUS_USER_ID
                  AND HUS_USER_ID = NM3USER.GET_USER_ID) SEC
                  --
    WHERE     1=1
        and intialrepeat.haud_pk_id(+) = WOR.WORKS_ORDER_NUMBER
        AND WOR.WORKS_ORDER_NUMBER = WOL.WORK_ORDER_NUMBER
          AND WOL.WORK_ORDER_NUMBER = DEF.WORKS_ORDER_NUMBER(+) --NM ADDED TO ELIMINATE DUPLICATE RECORDS THAT WERE APPEARING DUE TO TEMP/PERM DEFECTS
          AND WOL.DEFECT_ID = DEF.DEFECT_ID(+)
          AND WOL.BUDGET_ID = BUD.BUDGET_ID
          AND WOR.WORKS_ORDER_NUMBER = RA.HAUD_PK_ID
          AND WOL.NETWORK_ELEMENT_ID = CHILD_ELEMENT_ID
          AND PARENT_GROUP_TYPE = 'HMBG'
          AND WORK_ORDER_LINE_STATUS NOT IN ('COMPLETED', 'ACTIONED', 'PRELOHAC')
          AND upper(NVL (WORKS_ORDER_DESCRIPTION, 'EMPTY')) NOT LIKE '%**CANCELLED**%'   --Added upper to get the 'Cancelled' cases
          AND NVL (WOR_CHAR_ATTRIB100, 'EMPTY') NOT IN ('REJ', 'HLD')
          --AND NVL (WOR_CHAR_ATTRIB101, 'EMPTY') = 'APF'
          --AND WOR_DATE_ATTRIB121 IS NOT NULL  moved to pod level. since there was a design change
          AND WOR.CONTRACT_ID = C.CON_ID
          AND USER_AU IN (1, C.CON_ADMIN_ORG_ID)
          AND WOL.NETWORK_ELEMENT_ID = ELE_SEC.ELEMENT_ID
          AND WOL.WORK_CATEGORY = BUD_SEC.BUDGET_CODE
          ;