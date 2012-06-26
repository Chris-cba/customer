CREATE OR REPLACE FORCE VIEW V_X_HA_DEFECTS_HISTORIC_SDO
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
   DEFECT_DATE_COMPLETED,
   GEOLOC,
   OBJECTID
)
AS
   SELECT /*+ FIRST_ROWS */
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/HA/themes/V_X_HA_DEFECTS_HISTORIC_SDO.vw-arc   1.0   Jun 26 2012 11:46:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_HA_DEFECTS_HISTORIC_SDO.vw  $
--       Date into PVCS   : $Date:   Jun 26 2012 11:46:18  $
--       Date fetched Out : $Modtime:   Jun 21 2012 13:01:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley SYstems (UK) Ltd, 2012
-----------------------------------------------------------------------------
-- view written by Aileen Heal to add the defect completed data to the standard 
-- defect by status spatial view so we can only include defects clos over 6 months ago.
--
          def.def_defect_id defect_id,
          def.def_rse_he_id DEFECT_ROAD_ID,
          ne.ne_unique defect_road_name,
          ne.ne_descr defect_road_description,
          def.def_st_chain DEFECT_START_CHAIN,
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
          TRUNC(DEF_DATE_COMPL) DEFECT_DATE_COMPLETED,
          g.geoloc,
          g.objectid
     FROM defects def,
          activities_report are,
          nm_elements_all ne,
          hig_users hus,
          org_units org1,
          org_units org2,
          MAI_DEFECTS_XY_SDO g
    WHERE     def.def_rse_he_id = ne.ne_id
          AND def.def_are_report_id = are.are_report_id
          AND are.are_peo_person_id_actioned = hus.hus_user_id
          AND def.def_notify_org_id = org1.oun_org_id(+)
          AND def.def_rechar_org_id = org2.oun_org_id(+)
          AND def_status_code = 'COMPLETED' 
          AND DEF_DATE_COMPL <= add_months( TRUNC(SYSDATE), -6 )
          AND def.def_defect_id = g.DEF_DEFECT_ID
/          
          
insert into user_sdo_geom_metadata (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID )
select 'V_X_HA_DEFECTS_HISTORIC_SDO', COLUMN_NAME, DIMINFO, SRID 
from user_sdo_geom_metadata
where table_name = 'MAI_DEFECTS_XY_SDO'
/

commit
/ 
