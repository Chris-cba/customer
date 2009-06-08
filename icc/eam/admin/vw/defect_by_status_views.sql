CREATE OR REPLACE FORCE VIEW v_mai_defects (defect_id,
                                            service_request,
                                            work_request,
                                            work_order,
                                            defect_road_id,
                                            defect_road_name,
                                            defect_road_description,
                                            defect_start_chain,
                                            defect_are_report_id,
                                            defect_siss_id,
                                            defect_works_order_no,
                                            defect_created_date,
                                            defect_inspected_date,
                                            defect_inspected_time,
                                            defect_code,
                                            defect_priority,
                                            def_status_code,
                                            defect_activity,
                                            defect_location,
                                            defect_description,
                                            defect_asset_type,
                                            defect_asset_id,
                                            defect_initiation_type,
                                            defect_inspector,
                                            defect_x_section,
                                            defect_notify_org,
                                            defect_recharge_org
                                           )
AS
   SELECT /*+ FIRST_ROWS */
          def.def_defect_id defect_id,
          edo.edo_service_request_no service_request,
          edo.edo_work_request_id work_request,
          eam_interface.get_work_order_no (def.def_defect_id) work_order,
          def.def_rse_he_id defect_road_id, ne.ne_unique defect_road_name,
          ne.ne_descr defect_road_description,
          def.def_st_chain defect_start_chain,
          def.def_are_report_id defect_are_report_id,
          def.def_siss_id defect_siss_id,
          def.def_works_order_no defect_works_order_no,
          TRUNC (def.def_created_date) defect_created_date,
          ARE.are_date_work_done defect_inspected_date,
          def.def_time_hrs || ':' || def.def_time_mins defect_inspected_time,
          def.def_defect_code defect_code, def.def_priority defect_priority,
          UPPER
             (NVL (eam_interface.get_eam_status (def.def_defect_id),
                   def.def_status_code
                  )
             ) def_status_code,
          def.def_atv_acty_area_code defect_activity,
          def.def_locn_descr defect_location,
          def.def_defect_descr defect_description,
          def.def_ity_inv_code defect_asset_type,
          def.def_iit_item_id defect_asset_id,
          ARE.are_initiation_type defect_initiation_type,
          UPPER (hus.hus_name) defect_inspector,
          def.def_x_sect defect_x_section, org1.oun_name defect_notify_org,
          org2.oun_name defect_recharge_org
     FROM defects def,
          eam_defect_objects edo,
          activities_report ARE,
          nm_elements_all ne,
          hig_users hus,
          org_units org1,
          org_units org2
    WHERE def.def_rse_he_id = ne.ne_id
      AND def.def_defect_id = edo.edo_def_defect_id(+)
      AND def.def_are_report_id = ARE.are_report_id
      AND ARE.are_peo_person_id_actioned = hus.hus_user_id
      AND def.def_notify_org_id = org1.oun_org_id(+)
      AND def.def_rechar_org_id = org2.oun_org_id(+)
/


CREATE OR REPLACE FORCE VIEW v_mai_def_status_xy_sdo (defect_id,
                                                      service_request,
                                                      work_request,
                                                      work_order,
                                                      defect_road_id,
                                                      defect_road_name,
                                                      defect_road_description,
                                                      defect_start_chain,
                                                      defect_are_report_id,
                                                      defect_siss_id,
                                                      defect_works_order_no,
                                                      defect_created_date,
                                                      defect_inspected_date,
                                                      defect_inspected_time,
                                                      defect_code,
                                                      defect_priority,
                                                      defect_status_code,
                                                      defect_activity,
                                                      defect_location,
                                                      defect_description,
                                                      defect_asset_type,
                                                      defect_asset_id,
                                                      defect_initiation_type,
                                                      defect_inspector,
                                                      defect_x_section,
                                                      defect_notify_org,
                                                      defect_recharge_org,
                                                      geoloc,
                                                      objectid
                                                     )
AS
   (SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mai_sdo_util.pkb   1.7 04/11/07
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
           a."DEFECT_ID", a.service_request, a.work_request,
           eam_interface.get_work_order_no (a.defect_id) work_order,
           a."DEFECT_ROAD_ID", a."DEFECT_ROAD_NAME",
           a."DEFECT_ROAD_DESCRIPTION", a."DEFECT_START_CHAIN",
           a."DEFECT_ARE_REPORT_ID", a."DEFECT_SISS_ID",
           a."DEFECT_WORKS_ORDER_NO", a."DEFECT_CREATED_DATE",
           a."DEFECT_INSPECTED_DATE", a."DEFECT_INSPECTED_TIME",
           a."DEFECT_CODE", a."DEFECT_PRIORITY",
           UPPER
              (NVL (eam_interface.get_eam_status (a.defect_id),
                    a.def_status_code
                   )
              ) defect_status_code,
           a."DEFECT_ACTIVITY", a."DEFECT_LOCATION", a."DEFECT_DESCRIPTION",
           a."DEFECT_ASSET_TYPE", a."DEFECT_ASSET_ID",
           a."DEFECT_INITIATION_TYPE", a."DEFECT_INSPECTOR",
           a."DEFECT_X_SECTION", a."DEFECT_NOTIFY_ORG",
           a."DEFECT_RECHARGE_ORG", b.geoloc, b.objectid
      FROM v_mai_defects a, mai_defects_xy_sdo b
     WHERE a.defect_id = b.def_defect_id
       AND a.def_status_code <> 'COMPLETED'
       AND a.def_status_code <> 'AVAILABLE')
/


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON V_MAI_DEF_STATUS_XY_SDO TO SDE
/


CREATE OR REPLACE FORCE VIEW v_mai_def_activity_xy_sdo (defect_id,
                                                        defect_road_id,
                                                        defect_road_name,
                                                        defect_road_description,
                                                        defect_start_chain,
                                                        defect_are_report_id,
                                                        defect_siss_id,
                                                        defect_works_order_no,
                                                        defect_created_date,
                                                        defect_inspected_date,
                                                        defect_inspected_time,
                                                        defect_code,
                                                        defect_priority,
                                                        defect_status_code,
                                                        defect_activity,
                                                        defect_location,
                                                        defect_description,
                                                        defect_asset_type,
                                                        defect_asset_id,
                                                        defect_initiation_type,
                                                        defect_inspector,
                                                        defect_x_section,
                                                        defect_notify_org,
                                                        defect_recharge_org,
                                                        geoloc,
                                                        objectid
                                                       )
AS
   (SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mai_sdo_util.pkb   1.7 04/11/07
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
           a."DEFECT_ID", a."DEFECT_ROAD_ID", a."DEFECT_ROAD_NAME",
           a."DEFECT_ROAD_DESCRIPTION", a."DEFECT_START_CHAIN",
           a."DEFECT_ARE_REPORT_ID", a."DEFECT_SISS_ID",
           a."DEFECT_WORKS_ORDER_NO", a."DEFECT_CREATED_DATE",
           a."DEFECT_INSPECTED_DATE", a."DEFECT_INSPECTED_TIME",
           a."DEFECT_CODE", a."DEFECT_PRIORITY", a."DEF_STATUS_CODE",
           a."DEFECT_ACTIVITY", a."DEFECT_LOCATION", a."DEFECT_DESCRIPTION",
           a."DEFECT_ASSET_TYPE", a."DEFECT_ASSET_ID",
           a."DEFECT_INITIATION_TYPE", a."DEFECT_INSPECTOR",
           a."DEFECT_X_SECTION", a."DEFECT_NOTIFY_ORG",
           a."DEFECT_RECHARGE_ORG", b.geoloc, b.objectid
      FROM v_mai_defects a, mai_defects_xy_sdo b
     WHERE a.defect_id = b.def_defect_id)
/


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON V_MAI_DEF_ACTIVITY_XY_SDO TO SDE
/


CREATE OR REPLACE FORCE VIEW v_mai_def_act_sta_xy_sdo (defect_id,
                                                       defect_road_id,
                                                       defect_road_name,
                                                       defect_road_description,
                                                       defect_start_chain,
                                                       defect_are_report_id,
                                                       defect_siss_id,
                                                       defect_works_order_no,
                                                       defect_created_date,
                                                       defect_inspected_date,
                                                       defect_inspected_time,
                                                       defect_code,
                                                       defect_priority,
                                                       defect_status_code,
                                                       defect_activity,
                                                       defect_location,
                                                       defect_description,
                                                       defect_asset_type,
                                                       defect_asset_id,
                                                       defect_initiation_type,
                                                       defect_inspector,
                                                       defect_x_section,
                                                       defect_notify_org,
                                                       defect_recharge_org,
                                                       geoloc,
                                                       objectid
                                                      )
AS
   (SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mai_sdo_util.pkb   1.7 04/11/07
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
           a."DEFECT_ID", a."DEFECT_ROAD_ID", a."DEFECT_ROAD_NAME",
           a."DEFECT_ROAD_DESCRIPTION", a."DEFECT_START_CHAIN",
           a."DEFECT_ARE_REPORT_ID", a."DEFECT_SISS_ID",
           a."DEFECT_WORKS_ORDER_NO", a."DEFECT_CREATED_DATE",
           a."DEFECT_INSPECTED_DATE", a."DEFECT_INSPECTED_TIME",
           a."DEFECT_CODE", a."DEFECT_PRIORITY", a."DEF_STATUS_CODE",
           a."DEFECT_ACTIVITY", a."DEFECT_LOCATION", a."DEFECT_DESCRIPTION",
           a."DEFECT_ASSET_TYPE", a."DEFECT_ASSET_ID",
           a."DEFECT_INITIATION_TYPE", a."DEFECT_INSPECTOR",
           a."DEFECT_X_SECTION", a."DEFECT_NOTIFY_ORG",
           a."DEFECT_RECHARGE_ORG", b.geoloc, b.objectid
      FROM v_mai_defects a, mai_defects_xy_sdo b
     WHERE a.defect_id = b.def_defect_id)
/


GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON V_MAI_DEF_ACT_STA_XY_SDO TO SDE
/
