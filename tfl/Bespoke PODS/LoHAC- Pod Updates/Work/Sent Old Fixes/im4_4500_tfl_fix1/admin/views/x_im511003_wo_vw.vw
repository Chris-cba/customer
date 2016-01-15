                                                                             
  CREATE OR REPLACE FORCE VIEW "HIGHWAYS"."X_IM511003_WO_VW" ("RUN_ID", "WORK_OR
DER_NUMBER", "DAYS") AS                                                         
  SELECT "RUN_ID", "WORK_ORDER_NUMBER", "DAYS"                                  
     FROM x_im511003_wo                                                         
    WHERE run_id = 1;                                                          

