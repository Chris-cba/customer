CREATE OR REPLACE VIEW WORK_ORDER_REPORT_NULL_DEFECT (WOR_WORKS_ORDER_NO, WOR_DESCR, WOR_DATE_CONFIRMED, WOR_STATUS, WOL_ICB_WORK_CODE, HUS_NAME, RSE_UNIQUE, RSE_ROAD_NUMBER, RSE_SECT_NO, RSE_DESCR, WOL_ID, WOL_EST_COST) AS 
  SELECT
  --
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/admin/views/work_order_report_null_defect.vw-arc   1.0   May 09 2012 11:11:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   work_order_report_null_defect.vw  $
--       Date into PVCS   : $Date:   May 09 2012 11:11:36  $
--       Date fetched Out : $Modtime:   May 02 2012 21:30:44  $
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
          wol_id,
		  WOL_EST_COST
     FROM work_orders wo,
          work_order_lines wol,
          hig_users hu,
          road_segs rs,
          v_work_order_status vwo
    WHERE     wol.wol_works_order_no = wo.wor_works_order_no
          AND wo.wor_peo_person_id = hu.hus_user_id
          AND wol.wol_rse_he_id = rs.rse_he_id
          AND wo.wor_works_order_no = vwo.wor_works_order_no
          and wo.wor_works_order_no = wol.wol_works_order_no
          and wol.wol_def_defect_id is null;