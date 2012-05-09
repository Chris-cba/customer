CREATE OR REPLACE VIEW WORK_ORDER_REPORT_WITH_DEFECT (WOR_WORKS_ORDER_NO, WOR_DESCR, WOR_DATE_CONFIRMED, WOR_STATUS, WOL_ICB_WORK_CODE, HUS_NAME, RSE_UNIQUE, RSE_ROAD_NUMBER, RSE_SECT_NO, RSE_DESCR, DEF_LOCN_DESCR, DEF_SPECIAL_INSTR, REP_TRE_TREAT_CODE, WOL_DEF_DEFECT_ID, DEF_PRIORITY, DEF_DEFECT_CODE, DEF_EASTING, DEF_NORTHING, WOL_ID, WOL_EST_COST) AS 
  SELECT
  --
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/admin/views/work_order_report_with_defect.vw-arc   1.0   May 09 2012 11:11:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   work_order_report_with_defect.vw  $
--       Date into PVCS   : $Date:   May 09 2012 11:11:36  $
--       Date fetched Out : $Modtime:   May 02 2012 21:30:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Ltd, 2011
-----------------------------------------------------------------------------
--
   wo.wor_works_order_no,
          wor_descr,
          wor_date_confirmed,
          wor_status,
          wol_icb_work_code,
          hus_name,
          rse_unique,
          rse_road_number,
          rse_sect_no,
          rse_descr,
          def_locn_descr,
          def_special_instr,
          rep_tre_treat_code,
          wol_def_defect_id,
          def_priority,
          def_defect_code,
          def_easting,
          def_northing,
          wol_id,
		  WOL_EST_COST
     FROM work_orders wo,
          work_order_lines wol,
          hig_users hu,
          road_segs rs,
          defects def,
          repairs rep,
          v_work_order_status vwo
    WHERE     wol.wol_works_order_no = wo.wor_works_order_no
          AND wo.wor_peo_person_id = hu.hus_user_id
          AND wol.wol_rse_he_id = rs.rse_he_id
          AND def.def_defect_id = wol.wol_def_defect_id
          AND rep.rep_action_cat = 'P'
          AND rep.rep_def_defect_id = wol.wol_def_defect_id
          AND wo.wor_works_order_no = vwo.wor_works_order_no;
