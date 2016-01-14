CREATE OR REPLACE VIEW X_IM511002_WO_VW
(
   RUN_ID,
   WORK_ORDER_NUMBER,
   DAYS,
          def_pri
)
AS
   SELECT "RUN_ID", "WORK_ORDER_NUMBER",  "DAYS",  def_pri
     FROM x_im511002_wo
    WHERE run_id = 1;    

