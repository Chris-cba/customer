CREATE OR REPLACE VIEW WORK_ORDER_REPORT_HEADER (WOR_WORKS_ORDER_NO, WOR_DESCR, WOR_DATE_CONFIRMED, WOR_STATUS, HUS_NAME, wor_tot_est_cost) AS 
  SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/admin/views/work_order_report_header.vw-arc   1.0   May 09 2012 11:11:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   work_order_report_header.vw  $
--       Date into PVCS   : $Date:   May 09 2012 11:11:36  $
--       Date fetched Out : $Modtime:   May 02 2012 21:28:02  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2011
-----------------------------------------------------------------------------
--
   wo.wor_works_order_no,
          wor_descr,
          wor_date_confirmed,
          wor_status,
           hus_name,
		   wor_est_cost
         FROM work_orders wo,
           hig_users hu,
           v_work_order_status vwo
    WHERE  wo.wor_peo_person_id = hu.hus_user_id
              AND wo.wor_works_order_no = vwo.wor_works_order_no;
		  
