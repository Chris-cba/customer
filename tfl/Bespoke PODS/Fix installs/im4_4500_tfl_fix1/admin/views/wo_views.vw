CREATE OR REPLACE FORCE VIEW HIGHWAYS.V_WORK_ORDER_LINES
(
   WOL_ID,
   WOL_WORKS_ORDER_NO,
   WOL_REMARKS,
   WOL_STATUS,
   WOL_WORK_CATEGORY,
   WOL_ROAD_ID,
   WOL_ROAD_NAME,
   WOL_ROAD_DESCRIPTION,
   WOL_DEFECT_ID,
   WOL_REPAIR_CATEGORY,
   WOL_DEFECT_TYPE,
   WOL_DEFECT_PRIORITY,
   WOL_TREATMENT,
   WOL_DEFECT_LOCATION,
   WOL_SCHEDULE,
   WOL_ASSET_ID,
   WOL_REGISTERABLE,
   WOL_LABOUR_UNITS,
   WOL_GANG,
   WOL_ESTIMATED_COST,
   WOL_ACTUAL_COST,
   WOL_TARGET_DATE,
   WOL_DAYS_TO_TARGET,
   WOL_DATE_REPAIRED,
   WOL_DATE_COMPLETED
)
AS
   SELECT wol.wol_id wol_id,
          wol.wol_works_order_no wol_works_order_no,
          wol.wol_descr wol_remarks,
          wol.wol_status_code wol_status,
          wol.wol_icb_work_code wol_work_category,
          wol.wol_rse_he_id wol_road_id,
          ne.ne_unique wol_road_name,
          ne.ne_descr wol_road_description,
          wol.wol_def_defect_id wol_defect_id,
          wol.wol_rep_action_cat wol_repair_category,
          def.def_defect_code wol_defect_type,
          def.def_priority wol_defect_priority,
          rep.rep_tre_treat_code wol_treatment,
          def.def_locn_descr wol_defect_location,
          wol.wol_schd_id wol_schedule,
          wol.wol_iit_item_id wol_asset_id,
          wol_register_flag wol_registerable,
          wol.wol_est_labour wol_labour_units,
          wol.wol_gang wol_gang,
          wol.wol_est_cost wol_estimated_cost,
          wol.wol_act_cost wol_actual_cost,
          DECODE (wol.wol_flag, 'D', rep.rep_date_due, wor.wor_est_complete)
             wol_target_date,
          DECODE (
             wol.wol_date_complete,
             NULL, (NVL (
                       TRUNC (
                          DECODE (wol.wol_flag,
                                  'D', rep.rep_date_due,
                                  wor.wor_est_complete)),
                       TRUNC (SYSDATE))
                    - TRUNC (SYSDATE)),
             0)
             wol_days_to_target,
          wol.wol_date_repaired wol_date_repaired,
          wol.wol_date_complete wol_date_completed
     FROM defects def,
          repairs rep,
          work_orders wor,
          work_order_lines wol,
          nm_elements_all ne
    WHERE     ne.ne_id = wol.wol_rse_he_id
          AND wol.wol_works_order_no = wor.wor_works_order_no
          AND wol.wol_def_defect_id = rep.rep_def_defect_id(+)
          AND wol.wol_rep_action_cat = rep.rep_action_cat(+)
          AND rep.rep_def_defect_id = def.def_defect_id(+);


CREATE OR REPLACE FORCE VIEW HIGHWAYS.V_WORK_ORDER_LINES_SDO
(
   WOL_ID,
   WOL_WORKS_ORDER_NO,
   WOL_REMARKS,
   WOL_STATUS,
   WOL_WORK_CATEGORY,
   WOL_ROAD_ID,
   WOL_ROAD_NAME,
   WOL_ROAD_DESCRIPTION,
   WOL_DEFECT_ID,
   WOL_REPAIR_CATEGORY,
   WOL_DEFECT_TYPE,
   WOL_DEFECT_PRIORITY,
   WOL_TREATMENT,
   WOL_DEFECT_LOCATION,
   WOL_SCHEDULE,
   WOL_ASSET_ID,
   WOL_REGISTERABLE,
   WOL_LABOUR_UNITS,
   WOL_GANG,
   WOL_ESTIMATED_COST,
   WOL_ACTUAL_COST,
   WOL_TARGET_DATE,
   WOL_DAYS_TO_TARGET,
   WOL_DATE_REPAIRED,
   WOL_DATE_COMPLETED,
   GEOLOC
)
AS
   SELECT -----------------------------------------------------------------------------
                                                                            --
                                                      --   SCCS Identifiers :-
                                                                            --
                               --       sccsid           : $Revision:   1.0  $
                                               --       Module Name      : %M%
                                           --       Date into SCCS   : %E% %U%
                                           --       Date fetched Out : %D% %T%
                                               --       SCCS Version     : %I%
                                                                            --
 -----------------------------------------------------------------------------
                                  --  Copyright (c) exor corporation ltd, 2006
 -----------------------------------------------------------------------------
          a.WOL_ID,
          a.WOL_WORKS_ORDER_NO,
          a.WOL_REMARKS,
          a.WOL_STATUS,
          a.WOL_WORK_CATEGORY,
          a.WOL_ROAD_ID,
          a.WOL_ROAD_NAME,
          a.WOL_ROAD_DESCRIPTION,
          a.WOL_DEFECT_ID,
          a.WOL_REPAIR_CATEGORY,
          a.WOL_DEFECT_TYPE,
          a.WOL_DEFECT_PRIORITY,
          a.WOL_TREATMENT,
          a.WOL_DEFECT_LOCATION,
          a.WOL_SCHEDULE,
          a.WOL_ASSET_ID,
          a.WOL_REGISTERABLE,
          a.WOL_LABOUR_UNITS,
          a.WOL_GANG,
          a.WOL_ESTIMATED_COST,
          a.WOL_ACTUAL_COST,
          a.WOL_TARGET_DATE,
          a.WOL_DAYS_TO_TARGET,
          a.WOL_DATE_REPAIRED,
          a.WOL_DATE_COMPLETED,
          b.GEOLOC
     FROM V_WORK_ORDER_LINES a, v_mai_wol_network b
    WHERE a.WOL_ID = b.WOL_ID;



CREATE OR REPLACE PUBLIC SYNONYM V_WORK_ORDER_LINES FOR HIGHWAYS.V_WORK_ORDER_LINES;

CREATE OR REPLACE PUBLIC SYNONYM V_WORK_ORDER_LINES_SDO FOR HIGHWAYS.V_WORK_ORDER_LINES_DO;
