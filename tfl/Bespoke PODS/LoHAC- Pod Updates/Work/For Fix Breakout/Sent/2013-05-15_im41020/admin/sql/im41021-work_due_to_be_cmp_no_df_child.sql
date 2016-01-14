CREATE OR REPLACE FORCE VIEW HIGHWAYS.WORK_DUE_TO_BE_CMP_NO_DF_CHILD as
--
with TInterval as
(
            select DPR_PRIORITY , dpr_atv_acty_area_code, dpr_int_code, dpr_action_cat
          , (nvl(int_yrs,0) * 365.25 + nvl(int_months,0) * (365.25/12) + nvl(int_days,0) + nvl(int_hrs,0) *(1/24)) days
         from defect_Priorities, intervals b
         where dpr_int_code = int_code
)
, WOL as
( 
select * from work_order_Lines wol, defects def
where 1=1
and wol.wol_def_defect_id = def.def_defect_id(+)
)
, main as (
  SELECT    '<a href="javascript:openForms(''WORK_ORDERS'','''
          || wor.WOR_WORKS_ORDER_NO
          || ''');">Navigator'
             Navigator,
          WOR_WORKS_ORDER_NO,
          DEF_DEFECT_ID defect_id,
          DEF_DEFECT_CODE,
          DEF_PRIORITY,
          DEF_INSPECTION_DATE,
          DEF_DEFECT_DESCR,
          substr(con_code,instr(con_code,'_')+1) contract,
          WOR_CHAR_ATTRIB100 wo_pro_stat,
          WOR_CHAR_ATTRIB101 eot_status,
           WOR_NUM_ATTRIB10, 
          WOR_DATE_ATTRIB121 req_eot_date,
          WOR_DATE_ATTRIB122 rec_eot_date,
          WOL_DEF_DEFECT_ID,
          wor.WOR_CHAR_ATTRIB100 AS "WO Process Status",
          wor.WOR_CHAR_ATTRIB102 AS "EOT Reason for Request",
          wor.WOR_CHAR_ATTRIB103 AS "EOT Reason for Rejection",
          wor.WOR_CHAR_ATTRIB104 AS "WO Reason for Hold",
          wor.WOR_CHAR_ATTRIB105 AS "WO Reason for Rejection",
          wor.WOR_CHAR_ATTRIB100 ,
          WOR_DATE_ATTRIB127,
          wor.wor_est_complete,
          (select hus_name from hig_users where hus_user_id =wor_peo_person_id)  "Works Order Originator",
          (CASE
              WHEN WOR_CHAR_ATTRIB101 = 'APP'
              THEN
                 WOR_DATE_ATTRIB121 
              WHEN WOR_CHAR_ATTRIB101 = 'CND'
              THEN
                 WOR_DATE_ATTRIB122 
			  WHEN WOR_CHAR_ATTRIB101 = 'APF'
              THEN
                 WOR_DATE_ATTRIB121 
              ELSE
                 wor.wor_est_complete + 1 - (1 / (24 * 60 * 60))
           END)
             due_date,
              nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0) days,
              nvl((select dpr_atv_acty_area_code from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0) act_code,
              wol_rep_action_cat,
           (CASE
             WHEN WOL_DEF_DEFECT_ID is null
             THEN
                CASE WHEN 
                    WOR_DATE_ATTRIB121 is null and WOR_DATE_ATTRIB127 is null
                        then wor.wor_est_complete 
                    WHEN WOR_DATE_ATTRIB121 is not null AND WOR_DATE_ATTRIB127 is not null
                        then
                            case when WOR_DATE_ATTRIB121 > WOR_DATE_ATTRIB127 
                                then WOR_DATE_ATTRIB121
                                else  WOR_DATE_ATTRIB127
                             end                                                 
                    when 
                        WOR_DATE_ATTRIB121 is not null 
                        then WOR_DATE_ATTRIB121 
                    WHEN WOR_DATE_ATTRIB127 is not null 
                        then WOR_DATE_ATTRIB127 
                    else
                        wor.wor_est_complete
                    end 
              WHEN WOR_CHAR_ATTRIB101 = 'APP'
              THEN
                 WOR_DATE_ATTRIB121 
              WHEN WOR_CHAR_ATTRIB101 = 'CND'
              THEN
                 WOR_DATE_ATTRIB122 
				WHEN WOR_CHAR_ATTRIB101 = 'APF'
              THEN
                 WOR_DATE_ATTRIB121 
              WHEN nvl(WOR_CHAR_ATTRIB101,'NULL') <> 'REJ' AND WOR_DATE_ATTRIB121 is not null AND substr(con_code,instr(con_code,'_')+1) in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
              THEN
                    WOR_DATE_ATTRIB121
                WHEN nvl(WOR_CHAR_ATTRIB101,'NULL') <> 'REJ' AND WOR_DATE_ATTRIB121 is null AND substr(con_code,instr(con_code,'_')+1) in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
              THEN    
                DEF_INSPECTION_DATE  +nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0)                            
              WHEN nvl(WOR_CHAR_ATTRIB101,'NULL') <> 'REJ' AND WOR_DATE_ATTRIB121 is not null AND substr(con_code,instr(con_code,'_')+1) in ('HR', 'HTO', 'SMCI', 'SR', 'STO')
                THEN
                    WOR_DATE_ATTRIB121
              WHEN nvl(WOR_CHAR_ATTRIB101,'NULL') <> 'REJ' AND WOR_DATE_ATTRIB121 is null AND substr(con_code,instr(con_code,'_')+1) in ('HR', 'HTO', 'SMCI', 'SR', 'STO')
                THEN
                         WOR_DATE_CONFIRMED + nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0)
                --Rejected Cases
                WHEN WOR_CHAR_ATTRIB101 = 'REJ' AND substr(con_code,instr(con_code,'_')+1) in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
                THEN
                    DEF_INSPECTION_DATE + nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0)
                WHEN WOR_CHAR_ATTRIB101 = 'REJ'  AND substr(con_code,instr(con_code,'_')+1) in ('HR', 'HTO', 'SMCI', 'SR', 'STO')
                THEN
                         WOR_DATE_CONFIRMED + nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0)
              ELSE
                 wor.wor_est_complete +  nvl((select days from tinterval where 1=1 and tinterval.DPR_PRIORITY = DEF_PRIORITY and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code and tinterval.dpr_action_cat= wol_rep_action_cat),0)
           END) target_date,
          (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no and rownum=1)
             work_order_status,
          (SELECT hus_name
             FROM hig_users
            WHERE HUS_USER_ID = WOR_PEO_PERSON_ID)
             WO_RAISED_BY,
          wor_contact,
          wor_date_confirmed,
          WOR_ACT_COST,
          WOR_EST_COST,
          WOR_DATE_RAISED,
          WOL_DATE_COMPLETE,
          WOL_DATE_REPAIRED,
          ICB_ITEM_CODE || ICB_SUB_ITEM_CODE || ICB_SUB_SUB_ITEM_CODE
             BUDGET_CODE,
          ICB_WORK_CATEGORY_NAME
     FROM work_orders wor,
          wol,
		  --work_order_lines wol,
          budgets,
          contracts,
          item_code_breakdowns,
          --defects,
          --TInterval,
          pod_nm_element_security ele_sec,
          pod_budget_security bud_sec
    WHERE     NVL (WOR_CHAR_ATTRIB100, 'Empty') NOT IN ('REJ', 'HLD')
          --AND SUBSTR (wor.WOR_WORKS_ORDER_NO, 5, 2) != 'CS'
         -- and tinterval.DPR_PRIORITY = DEF_PRIORITY
          --and tinterval.dpr_atv_acty_area_code = def_atv_acty_area_code
          --and tinterval.dpr_action_cat= wol_rep_action_cat
          AND wor.WOR_WORKS_ORDER_NO = wol.WOL_WORKS_ORDER_NO(+)
           --and defects.DEF_WORKS_ORDER_NO(+)= wor.WOR_WORKS_ORDER_NO
            --and defects.DEF_defect_id= wol.wol_def_defect_id
          and wor_con_id = con_id
          AND wol_bud_id = bud_id
           AND    BUD_ICB_ITEM_CODE
              || BUD_ICB_SUB_ITEM_CODE
              || BUD_ICB_SUB_SUB_ITEM_CODE =
                 ICB_ITEM_CODE || ICB_SUB_ITEM_CODE || ICB_SUB_SUB_ITEM_CODE                              
          AND wol_rse_he_id = ele_sec.element_id
          AND WOL_ICB_WORK_CODE = bud_sec.budget_code
          )
          select * from main where target_date >= (select min(st_range) from X_LOHAC_DateRANGE_WODC)         
          ;