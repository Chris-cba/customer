DROP VIEW HIGHWAYS.LBE_DEF_DUE_ALERT;

/* Formatted on 21/08/2018 13:32:38 (QP5 v5.313) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.LBE_DEF_DUE_ALERT
(
    DEF_DEFECT_ID,
    NE_UNIQUE,
    NE_DESCR,
    NE_SUB_CLASS,
    ARE_DATE_WORK_DONE,
    DEF_INSPECTION_DATE,
    DEF_TIME_HRS,
    DEF_TIME_MINS,
    DEF_DEFECT_CODE,
    PRIORITY,
    DEF_STATUS_CODE,
    DEF_ATV_ACTY_AREA_CODE,
    DEF_LOCN_DESCR,
    DEF_DEFECT_DESCR,
    ARE_INITIATION_TYPE,
    ATV_DESCR,
    DTY_DESCR1,
    HUS_NAME,
    HUS_INITIALS,
    REP_DESCR,
    REP_DATE_DUE,
    TRE_TREAT_CODE,
    TRE_DESCR,
    IIT_NUM_ATTRIB83,
    DEF_SPECIAL_INSTR,
    DUE_DIFF,
    WOL_WORKS_ORDER_NO,
    WOR_DATE_CONFIRMED
)
AS
    SELECT def.def_defect_id,
           ne.ne_unique,
           ne.ne_descr,
           ne.ne_sub_class,
           are.are_date_work_done,
           def.def_inspection_date,
           def.def_time_hrs,
           def.def_time_mins,
           def.def_defect_code,
           SUBSTR (compl_domain ('DEFECT_PRIORITIES', def.def_priority),
                   1,
                   15)
               priority,
           def.def_status_code,
           def.def_atv_acty_area_code,
           def.def_locn_descr,
           def.def_defect_descr,
           are.are_initiation_type,
           atv.atv_descr,
           dty.dty_descr1,
           hus.hus_name,
           hus.hus_initials,
           rep.rep_descr,
           rep.rep_date_due,
           tre.tre_treat_code,
           tre.tre_descr,
           inv.IIT_NUM_ATTRIB83,
           def.def_special_instr,
             SYSDATE
           - wor.Wor_Date_Confirmed
           - DECODE (def.Def_Priority,
                     '1', 1,
                     '6', 28,
                     '7', 0,
                     '8', 0,
                     '9', 7,
                     '9P', 7,
                     '6P', 28,
                     '1P', 1,
                     0)
               due_diff,
           wol.wol_works_order_no,
           wor.wor_date_confirmed
      FROM defects            def,
           activities_report  are,
           nm_elements_all    ne,
           hig_users          hus,
           treatments         tre,
           repairs            rep,
           activities         atv,
           def_types          dty,
           NM_INV_ITEMS_ALL   inv,
           NM_NW_AD_LINK_ALL  nwd,
           work_order_lines   wol,
           work_orders        wor
     WHERE     def.def_rse_he_id = ne.ne_id
           AND def.def_are_report_id = are.are_report_id
           AND are.are_peo_person_id_actioned = hus.hus_user_id
           AND def.def_defect_id = rep.rep_def_defect_id
           AND rep.rep_tre_treat_code = tre.tre_treat_code
           AND def.def_defect_code = dty.dty_defect_code
           AND def.def_atv_acty_area_code = atv.atv_acty_area_code
           AND def.def_atv_acty_area_code = dty.dty_atv_acty_area_code
           AND ne.ne_id = nwd.NAD_NE_ID
           AND nwd.NAD_IIT_NE_ID = inv.IIT_NE_ID
           AND def.def_defect_id = wol.wol_def_defect_id
           AND wol.wol_status_code <> 'NOT DONE' -- SW added 7-AUG-2018 because of errors picking up 2 wols with same defect on
           AND wol.wol_works_order_no = wor.wor_works_order_no
           AND wor.wor_con_id = 12
           AND def.def_status_code = 'INSTRUCTED';


CREATE OR REPLACE PUBLIC SYNONYM LBE_DEF_DUE_ALERT FOR HIGHWAYS.LBE_DEF_DUE_ALERT;

