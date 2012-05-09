CREATE OR REPLACE VIEW WORK_ORDER_REPORT (WORKS_ORDER_NUMBER, WOL_DEF_DEFECT_ID, WOL_ICB_WORK_CODE, RSE_ROAD_NUMBER, RSE_SECT_NO, RSE_DESCR, DEF_LOCN_DESCR, DEF_SPECIAL_INSTR, REP_TRE_TREAT_CODE, DEF_PRIORITY, DEF_DEFECT_CODE, DEF_EASTING, DEF_NORTHING, wol_id, WOL_EST_COST) AS 
select  
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/admin/views/work_order_report.vw-arc   1.0   May 09 2012 11:11:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   work_order_report.vw  $
--       Date into PVCS   : $Date:   May 09 2012 11:11:36  $
--       Date fetched Out : $Modtime:   May 02 2012 21:30:42  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2011
-----------------------------------------------------------------------------
--
WOR_WORKS_ORDER_NO, wol_def_defect_id,wol_icb_work_code,rse_road_number, rse_sect_no, rse_descr, def_locn_descr, def_special_instr, rep_tre_treat_code, def_priority,def_defect_code,DEF_EASTING,DEF_NORTHING, wol_id, WOL_EST_COST  from work_order_report_with_defect 
union 
select WOR_WORKS_ORDER_NO,null,wol_icb_work_code,rse_road_number, rse_sect_no, rse_descr, null, null, null, null,null,null, null, wol_id, WOL_EST_COST from WORK_ORDER_REPORT_NULL_DEFECT;