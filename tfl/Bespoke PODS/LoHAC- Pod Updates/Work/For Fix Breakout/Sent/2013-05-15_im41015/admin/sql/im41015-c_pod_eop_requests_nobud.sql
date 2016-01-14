 Create or replace view C_POD_EOP_REQUESTS_nobud as
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
--
, WOL as
( 
select * from work_order_Lines wol, defects def, repairs rep   ,imf_net_network_members net 
where 1=1
and wol.wol_def_defect_id = def.def_defect_id(+)
and def_defect_id = rep_def_defect_id
and wol.wol_rse_he_id = child_element_id(+)
and parent_group_type = 'HMBG'
)
--
 SELECT DISTINCT
             '<A HREF="javascript:openForms(''WORK_ORDERS'','''
          || WOR.WORKS_ORDER_NUMBER
          || ''');">NAVIGATOR'
             NAVIGATOR,
          wol.wol_id WORK_ORDER_LINE_ID,
          WOR.WORKS_ORDER_NUMBER,
          WOL_WORKS_ORDER_NO WORK_ORDER_LINE_STATUS,
        wor.CONTRACTOR_CODE CONTRACTOR_CODE,
        wor.ORIGINATOR_NAME ORIGINATOR_NAME,
        wor.CONTACT CONTACT,
        wol.wol_def_defect_id DEFECT_ID,
        wol.def_priority DEFECT_PRIORITY,
          NVL (wol.def_locn_descr, wol.wol_locn_descr)   LOCATION_DESCRIPTION,
            wol.def_defect_descr DEFECT_DESCRIPTION,
            wol.rep_descr REPAIR_DESCRIPTION,
            wol.rep_action_cat REPAIR_CATEGORY,
          WOR.DATE_RAISED,
          1 REQUESTS,
          WOR.WOR_DATE_ATTRIB121 AS "EOT DATE REQUESTED",
          WOR.DATE_INSTRUCTED,
        WOL_EST_COST estimated_cost,
        WOL_ACT_COST actual_cost,
          WOR.WORKS_ORDER_STATUS,
          WOR.SCHEME_TYPE,
          WOR.SCHEME_TYPE_DESCRIPTION,
          wol.wol_icb_work_code work_category,
          null WORK_CATEGORY_DESCRIPTION,
          WOR.AUTHORISED_BY_NAME,
          WOL_DATE_REPAIRED,
         WOL_DATE_COMPLETE,
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
          null COST_CODE,
          WOR.WOR_DATE_ATTRIB129 AS "DATE PRICE EXTENSION REQUESTED",
          WOR.WOR_CHAR_ATTRIB72 AS "REASON FOR PRICING EXTENSION",
          PARENT_ELEMENT_DESCRIPTION AS "BOROUGH",
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
     FROM XIMF_MAI_WO_ALL_ATTR_NO_SEC wor,
          WOL,                
          --HIG_AUDITS_VW,
          CONTRACTS C, 
          HAUD RA,
          IntialRepeat
                  --
    WHERE     1=1
        and intialrepeat.haud_pk_id(+) = WOR.WORKS_ORDER_NUMBER
        and wor.works_order_number=WOL_WORKS_ORDER_NO(+)
           AND WOR.WORKS_ORDER_NUMBER = RA.HAUD_PK_ID
           AND WOL_BUD_ID is null
          AND WOL_STATUS_CODE(+) NOT IN  ('COMPLETED', 'ACTIONED', 'INSTRUCTED', 'PRELOHAC' )
          AND upper(NVL (WORKS_ORDER_DESCRIPTION, 'EMPTY')) NOT LIKE '%**CANCELLED**%'   --Added upper to get the 'Cancelled' cases
          AND NVL (WOR_CHAR_ATTRIB100, 'EMPTY') NOT IN ('REJ', 'HLD')
		  AND NVL (WOR_CHAR_ATTRIB101, 'EMPTY') not in ('APP','REJ','CND')
          AND WOR.CONTRACT_ID(+) = C.CON_ID
		  and (x_get_im_user_id in (Select HUS_USER_ID from X_LOHAC_NoBudget_Security) OR x_get_im_user_id = ORIGINATOR_ID)
		  AND WOr.NETWORK_ELEMENT_ID in  ( select mwur_road_group_id from mai_wo_user_road_groups where mwur_user_id=x_get_im_user_id) 
          ;