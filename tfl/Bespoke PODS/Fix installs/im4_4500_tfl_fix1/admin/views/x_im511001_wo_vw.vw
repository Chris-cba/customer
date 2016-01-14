CREATE OR REPLACE  VIEW X_IM511001_WO_VW
(
   RUN_ID,
   WORK_ORDER_NUMBER,
   DAYS,
   DEF_PRI
)
AS
   SELECT "RUN_ID",
          "WORK_ORDER_NUMBER",
          "DAYS",
          def_pri
     FROM x_im511001_wo
    WHERE run_id = 1;

