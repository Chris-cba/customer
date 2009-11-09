DROP VIEW WORCS.V_MAI_DEFECTS;

CREATE OR REPLACE FORCE VIEW V_MAI_DEFECTS
(
   DEFECT_ID,
   DEFECT_ROAD_ID,
   DEFECT_ROAD_NAME,
   DEFECT_ROAD_DESCRIPTION,
   DEFECT_START_CHAIN,
   DEFECT_ARE_REPORT_ID,
   DEFECT_SISS_ID,
   DEFECT_WORKS_ORDER_NO,
   DEFECT_CREATED_DATE,
   DEFECT_INSPECTED_DATE,
   DEFECT_INSPECTED_TIME,
   DEFECT_CODE,
   DEFECT_PRIORITY,
   DEFECT_STATUS_CODE,
   DEFECT_ACTIVITY,
   DEFECT_LOCATION,
   DEFECT_DESCRIPTION,
   DEFECT_ASSET_TYPE,
   DEFECT_ASSET_ID,
   DEFECT_INITIATION_TYPE,
   DEFECT_INSPECTOR,
   DEFECT_X_SECTION,
   DEFECT_NOTIFY_ORG,
   DEFECT_RECHARGE_ORG,
   DEFECT_NE_ID,
   DEFECT_BEGIN_MP,
   DEFECT_TMA_CODE
)
AS
  SELECT 
         --
         --------------------------------------------------------------------------------
         --   PVCS Identifiers :-
         --
         --       sccsid           : $Header:   //vm_latest/archives/customer/Warwickshire/Defects SDO/xwcc_v_mai_defects.vw-arc   3.1   09 Nov 2009 17:41:12   kdawson  $
         --       Module Name      : $Workfile:   xwcc_v_mai_defects.vw  $
         --       Date into PVCS   : $Date:   09 Nov 2009 17:41:12  $
         --       Date fetched Out : $Modtime:   06 Nov 2009 11:48:32  $
         --       PVCS Version     : $Revision:   3.1  $
         --
         --------------------------------------------------------------------------------
         --
         /*+ FIRST_ROWS */
         def.def_defect_id defect_id,
         def.def_rse_he_id defect_road_id,
         ne.ne_unique defect_road_name,
         ne.ne_descr defect_road_description,
         def.def_st_chain defect_start_chain,
         def.def_are_report_id defect_are_report_id,
         def.def_siss_id defect_siss_id,
         def.def_works_order_no defect_works_order_no,
         TRUNC (def.def_created_date) defect_created_date,
         are.are_date_work_done defect_inspected_date,
         def.def_time_hrs || ':' || def.def_time_mins defect_inspected_time,
         def.def_defect_code defect_code,
         def.def_priority defect_priority,
         def.def_status_code defect_status_code,
         def.def_atv_acty_area_code defect_activity,
         def.def_locn_descr defect_location,
         def.def_defect_descr defect_description,
         def.def_ity_inv_code defect_asset_type,
         def.def_iit_item_id defect_asset_id,
         are.are_initiation_type defect_initiation_type,
         UPPER (hus.hus_initials) defect_inspector,
         def.def_x_sect defect_x_section,
         org1.oun_name defect_notify_org,
         org2.oun_name defect_recharge_org,
         (SELECT nm_ne_id_of
            FROM nm_members
           WHERE nm_ne_id_in = def_rse_he_id
             AND def_st_chain BETWEEN nm_slk AND nm_end_slk
             AND ROWNUM = 1) nm_ne_id_of,
        .1 nm_begin_mp,
         rep_tre_treat_code
    FROM defects def,
         repairs,
         activities_report are,
         nm_elements_all ne,
         hig_users hus,
         org_units org1,
         org_units org2
   WHERE def.def_rse_he_id = ne.ne_id
     AND rep_def_defect_id = def_defect_id
     AND def.def_are_report_id = are.are_report_id
     AND are.are_peo_person_id_actioned = hus.hus_user_id
     AND def.def_notify_org_id = org1.oun_org_id(+)
     AND def.def_rechar_org_id = org2.oun_org_id(+);
	 
	 DROP SYNONYM WARKS_SUB.V_MAI_DEFECTS;

     CREATE SYNONYM WARKS_SUB.V_MAI_DEFECTS FOR WORCS.V_MAI_DEFECTS;
	 
/