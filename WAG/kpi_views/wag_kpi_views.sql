/* -----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
*/

DROP VIEW KPI_10_ACK_DATES;

/* Formatted on 11-Mar-2011 10:34:55 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_10_ACK_DATES
(
   DHI_DOC_ID,
   DHI_DATE_CHANGED
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT dhi_doc_id, dhi_date_changed
     FROM doc_history
    WHERE dhi_status_code = 'ACK';


DROP SYNONYM HIGHWAYS.KPI_10_ACK_DATES;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_10_ACK_DATES FOR KPI_10_ACK_DATES;


DROP PUBLIC SYNONYM KPI_10_ACK_DATES;

CREATE OR REPLACE PUBLIC SYNONYM KPI_10_ACK_DATES FOR KPI_10_ACK_DATES;

DROP VIEW KPI_10_PERCENT;

/* Formatted on 11-Mar-2011 10:44:53 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_10_PERCENT
(
   HAU_NAME,
   FY_ST_DATE,
   ID_COUNT,
   IN_TARGET_FLAG,
   OVER_TARGET
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT user_admin_name "Admin Unit Name",
            fy_st_date,
            SUM (id_count) AS "Total REQS",
            SUM (in_target_flag) AS "Within Tolerance",
            SUM (over_target) AS "Outside Tolerance"
       FROM kpi_10_requests_for_serv_sp
      WHERE ignore_flag = 'VALID'
   GROUP BY user_admin_name, fy_st_date;


DROP SYNONYM HIGHWAYS.KPI_10_PERCENT;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_10_PERCENT FOR KPI_10_PERCENT;


DROP PUBLIC SYNONYM KPI_10_PERCENT;

CREATE OR REPLACE PUBLIC SYNONYM KPI_10_PERCENT FOR KPI_10_PERCENT;

DROP VIEW KPI_10_REQUESTS_FOR_SERV_SP;

/* Formatted on 11-Mar-2011 10:45:08 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_10_REQUESTS_FOR_SERV_SP
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   ID_COUNT,
   DATE_ISS,
   DOC_ID,
   MIN_TO_COMP,
   IN_TARGET_FLAG,
   OVER_TARGET,
   IGNORE_FLAG,
   DATE_COMP,
   DATE_COMP_CORRESP
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (doc_date_issued, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (doc_date_issued, -12), 'RR')
             ELSE
                TO_CHAR (doc_date_issued, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (doc_date_issued, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          hau_name,
          hau_admin_unit,
          1 AS countt,
          doc_date_issued,
          doc_id,
          (ROUND (
              (NVL (doc_compl_complete, SYSDATE) --                     - NVL (doc_compl_corresp_deliv_date,
               - NVL (doc_compl_corresp_date, doc_date_time_arrived))
              * 24
              * 60))
             AS MIN_TO_COMP,
          CASE
             WHEN (num_business_days (
                      --                        NVL (doc_compl_corresp_deliv_date,
                      --                             doc_date_time_arrived),
                      --                        NVL (doc_compl_complete, SYSDATE)
                      NVL (doc_compl_incident_Date, SYSDATE),
                      NVL (doc_compl_corresp_deliv_date, doc_date_issued))) >=
                     15
             THEN
                0
             ELSE
                1
          END
             inn,
          CASE
             WHEN (num_business_days (
                      --                        NVL (doc_compl_corresp_deliv_date,
                      --                             doc_date_time_arrived),
                      --                        NVL (doc_compl_complete, SYSDATE)
                      NVL (doc_compl_incident_Date, SYSDATE),
                      NVL (doc_compl_corresp_deliv_date, doc_date_issued))) <
                     15
             THEN
                0
             ELSE
                1
          END
             outt,
          --       doc_compl_complete,
          --       doc_compl_corresp_deliv_date,
          --       doc_date_issued,
          --       round(sysdate - nvl(doc_compl_corresp_deliv_date,doc_date_issued))*24*60 d,
          CASE
             WHEN (doc_compl_complete IS NULL)
             THEN
                CASE
                   WHEN (num_business_days (
                            --                              NVL (doc_compl_corresp_deliv_date,
                            --                                   doc_date_issued),
                            --                              NVL (doc_compl_complete, SYSDATE)
                            NVL (doc_compl_incident_Date, SYSDATE),
                            NVL (doc_compl_corresp_deliv_date,
                                 doc_date_issued))) <= 15
                   THEN
                      'IGNORE'
                   ELSE
                      'VALID'
                END
             ELSE
                'VALID'
          END
             ignore_flag,
          doc_compl_complete,
          doc_compl_corresp_date
     FROM docs2view, hig_admin_units, kpi_child_au
    WHERE     doc_dtp_code = 'REQS'
          AND doc_admin_unit = hau_admin_unit
          AND child_admin_unit = hau_admin_unit
          AND doc_date_issued BETWEEN (SELECT CASE
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JAN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'FEB'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'APR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAY'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUL'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'AUG'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'SEP'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'OCT'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'NOV'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'DEC'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 ELSE
                                                    'sysdate'
                                              END
                                         FROM DUAL)
                                  AND (SELECT SYSDATE FROM DUAL);


DROP PUBLIC SYNONYM KPI_10_REQUESTS_FOR_SERV_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI_10_REQUESTS_FOR_SERV_SP FOR KPI_10_REQUESTS_FOR_SERV_SP;

DROP VIEW KPI_10_REQUESTS_FOR_SERVICE_SP;

/* Formatted on 11-Mar-2011 10:45:18 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_10_REQUESTS_FOR_SERVICE_SP
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   ID_COUNT,
   DATE_ISS,
   DOC_ID,
   MIN_TO_COMP,
   IN_TARGET_FLAG,
   OVER_TARGET,
   DATE_COMP
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (doc_date_issued, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (doc_date_issued, -12), 'RR')
             ELSE
                TO_CHAR (doc_date_issued, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (doc_date_issued, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          hau_name,
          hau_admin_unit,
          1 AS "countt",
          doc_date_issued,
          doc_id,
          (ROUND (
              (NVL (dhi_date_changed, SYSDATE) - doc_date_issued) * 24 * 60))
             AS "MIN_TO_COMP",
          CASE
             WHEN (ROUND (
                        (NVL (dhi_date_changed, SYSDATE) - doc_date_issued)
                      * 24
                      * 60)) >= '21600'
             THEN
                0
             ELSE
                1
          END
             inn,
          CASE
             WHEN (ROUND (
                        (NVL (dhi_date_changed, SYSDATE) - doc_date_issued)
                      * 24
                      * 60)) < '21600'
             THEN
                0
             ELSE
                1
          END
             outt,
          NVL (dhi_date_changed, SYSDATE)
     FROM docs2view,
          hig_admin_units,
          kpi_10_ack_dates,
          kpi_child_au_sp
    WHERE     doc_dtp_code = 'REQS'
          AND doc_admin_unit = hau_admin_unit
          AND doc_id = dhi_doc_id(+)
          AND child_admin_unit = hau_admin_unit
          AND doc_date_issued BETWEEN (SELECT CASE
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JAN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'FEB'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'APR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAY'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUL'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'AUG'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'SEP'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'OCT'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'NOV'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'DEC'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 ELSE
                                                    'sysdate'
                                              END
                                         FROM DUAL)
                                  AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI_10_REQUESTS_FOR_SERVICE_SP;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_10_REQUESTS_FOR_SERVICE_SP FOR KPI_10_REQUESTS_FOR_SERVICE_SP;


DROP PUBLIC SYNONYM KPI_10_REQUESTS_FOR_SERVICE_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI_10_REQUESTS_FOR_SERVICE_SP FOR KPI_10_REQUESTS_FOR_SERVICE_SP;

DROP VIEW KPI_14A;

/* Formatted on 11-Mar-2011 10:45:25 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_14A
(
   FY_ST_DATE,
   V_NAME,
   NOS_RECOV,
   NOS_NON_RECOV,
   COST_RECOV,
   COST_NON_RECOV
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT "FY_ST_DATE",
            "USER_ADMIN_NAME",
            "NOS. RECOV",
            "NOS. NON-RECOV",
            "COST RECOV",
            "COST NON-RECOV"
       FROM (  SELECT fy_st_date,
                      user_admin_name,
                      NVL (COUNT (DECODE (d_class, 'RECV', cnt)), 0) "NOS. RECOV",
                      NVL (COUNT (DECODE (d_class, 'NONR', cnt)), 0)
                         "NOS. NON-RECOV",
                      NVL (
                         SUM (
                            DECODE (d_class,
                                    'RECV', NVL (d_act_cost, d_est_cost))),
                         0)
                         "COST RECOV",
                      NVL (
                         SUM (
                            DECODE (d_class,
                                    'NONR', NVL (d_act_cost, d_est_cost))),
                         0)
                         "COST NON-RECOV"
                 FROM kpi14_damg
             GROUP BY fy_st_date, user_admin_name)
   ORDER BY 1, 2;


DROP SYNONYM HIGHWAYS.KPI_14A;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_14A FOR KPI_14A;


DROP PUBLIC SYNONYM KPI_14A;

CREATE OR REPLACE PUBLIC SYNONYM KPI_14A FOR KPI_14A;

DROP VIEW KPI_15_WORK_ORDER_NON_DEFECTS;

/* Formatted on 11-Mar-2011 10:45:32 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_15_WORK_ORDER_NON_DEFECTS
(
   AGENCY_CODE,
   WOL_COUNT,
   ACT_COST,
   EST_COST,
   DEFECT_ID,
   OUTSIDE_TOL,
   INSIDE_TOL
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT i.agency_code,
            COUNT (w.work_order_line_id),
            W.ACTUAL_COST,
            w.estimated_cost,
            w.defect_id,
            CASE
               WHEN w.actual_cost <=
                       (w.estimated_cost * 0.08 + w.estimated_cost)
               THEN
                  CASE
                     WHEN w.actual_cost >=
                             (w.estimated_cost * -0.08 + w.estimated_cost)
                     THEN
                        '0'
                     ELSE
                        '1'
                  END
               ELSE
                  '1'
            END
               AS "Outside Tolerance",
            CASE
               WHEN w.actual_cost <=
                       (w.estimated_cost * 0.08 + w.estimated_cost)
               THEN
                  CASE
                     WHEN w.actual_cost >=
                             (w.estimated_cost * -0.08 + w.estimated_cost)
                     THEN
                        '1'
                     ELSE
                        '0'
                  END
               ELSE
                  '0'
            END
               AS "Within Tolerance"
       FROM imf_mai_work_order_lines w, imf_mai_item_code_breakdowns i
      WHERE W.WORK_CATEGORY = I.WORK_CATEGORY(+)
            AND w.work_order_line_status = 'COMPLETED'
   GROUP BY i.agency_code,
            w.work_order_line_id,
            w.actual_cost,
            w.estimated_cost,
            w.defect_id;


DROP SYNONYM HIGHWAYS.KPI_15_WORK_ORDER_NON_DEFECTS;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_15_WORK_ORDER_NON_DEFECTS FOR KPI_15_WORK_ORDER_NON_DEFECTS;


DROP PUBLIC SYNONYM KPI_15_WORK_ORDER_NON_DEFECTS;

CREATE OR REPLACE PUBLIC SYNONYM KPI_15_WORK_ORDER_NON_DEFECTS FOR KPI_15_WORK_ORDER_NON_DEFECTS;

DROP VIEW KPI_CHILD_AU;

/* Formatted on 11-Mar-2011 10:45:39 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_CHILD_AU
(
   CHILD_ADMIN_UNIT,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT hau_admin_unit child_admin_unit,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name
     FROM hig_admin_units,
          (SELECT hag_child_admin_unit,
                  a.hau_admin_unit user_admin_unit,
                  a.hau_level user_admin_level,
                  a.hau_unit_code user_admin_code,
                  a.hau_name user_admin_name
             FROM hig_admin_groups,
                  (SELECT hau_admin_unit,
                          hau_level,
                          hau_unit_code,
                          hau_name
                     FROM hig_admin_units
                    WHERE EXISTS
                             (SELECT hau_admin_unit
                                FROM hig_users
                               WHERE hus_username =
                                        nm3user.get_username (
                                           nm3context.get_context ('NM3_WAG',
                                                                   'USER_ID'))
                                     AND hus_admin_unit = hau_admin_unit)) a
            WHERE hag_parent_admin_unit = a.hau_admin_unit) b
    WHERE b.hag_child_admin_unit = hau_admin_unit AND hau_end_date IS NULL;


DROP SYNONYM HIGHWAYS.KPI_CHILD_AU;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_CHILD_AU FOR KPI_CHILD_AU;


DROP PUBLIC SYNONYM KPI_CHILD_AU;

CREATE OR REPLACE PUBLIC SYNONYM KPI_CHILD_AU FOR KPI_CHILD_AU;

DROP VIEW KPI_CHILD_AU_DL;

/* Formatted on 11-Mar-2011 10:45:48 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_CHILD_AU_DL
(
   CHILD_ADMIN_UNIT,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT hau_admin_unit child_admin_unit,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name
     FROM hig_admin_units,
          (SELECT hag_child_admin_unit,
                  a.hau_admin_unit user_admin_unit,
                  a.hau_level user_admin_level,
                  a.hau_unit_code user_admin_code,
                  a.hau_name user_admin_name
             FROM hig_admin_groups,
                  (SELECT hau_admin_unit,
                          hau_level,
                          hau_unit_code,
                          hau_name
                     FROM hig_admin_units
                    WHERE EXISTS
                             (SELECT hau_admin_unit
                                FROM hig_users
                               WHERE hus_username =
                                        nm3user.get_username (
                                           nm3context.get_context ('NM3_WAG',
                                                                   'USER_ID'))
                                     AND hus_admin_unit = hau_admin_unit)) a
            WHERE hag_parent_admin_unit = a.hau_admin_unit
                  AND hag_direct_link = 'Y') b
    WHERE b.hag_child_admin_unit = hau_admin_unit AND hau_end_date IS NULL;


DROP SYNONYM HIGHWAYS.KPI_CHILD_AU_DL;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_CHILD_AU_DL FOR KPI_CHILD_AU_DL;


DROP PUBLIC SYNONYM KPI_CHILD_AU_DL;

CREATE OR REPLACE PUBLIC SYNONYM KPI_CHILD_AU_DL FOR KPI_CHILD_AU_DL;
DROP VIEW KPI_CHILD_AU_SP;

/* Formatted on 11-Mar-2011 10:45:55 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI_CHILD_AU_SP
(
   CHILD_ADMIN_UNIT,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT hag_child_admin_unit child_admin_unit,
          user_admin_level,
          hag_parent_admin_unit user_admin_unit,
          hau_unit_code user_admin_code,
          hau_name user_admin_name
     FROM kpi_child_au_dl, hig_admin_groups, hig_admin_units
    WHERE     child_admin_unit = hag_parent_admin_unit
          AND hag_parent_admin_unit = hau_admin_unit
          AND hau_end_date IS NULL
   UNION
   SELECT hau_admin_unit,
          hau_level,
          hau_admin_unit user_admin_unit,
          hau_unit_code,
          hau_name user_admin_name
     FROM hig_admin_units, hig_users
    WHERE hau_admin_unit = hus_admin_unit
          AND hus_username =
                 nm3user.get_username (
                    nm3context.get_context ('NM3_WAG', 'USER_ID'));


DROP SYNONYM HIGHWAYS.KPI_CHILD_AU_SP;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI_CHILD_AU_SP FOR KPI_CHILD_AU_SP;


DROP PUBLIC SYNONYM KPI_CHILD_AU_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI_CHILD_AU_SP FOR KPI_CHILD_AU_SP;

DROP VIEW KPI1_RESP_TO_EMG_REV;

/* Formatted on 11-Mar-2011 10:46:01 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI1_RESP_TO_EMG_REV
(
   DOC_ID,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   HAU_UNIT_CODE,
   HAU_LEVEL,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME,
   FY_ST_DATE,
   QR_ST_DATE,
   DOC_CODE,
   DOC_CL,
   DOC_TYPE,
   DOC_SOURCE,
   NO_EMGS,
   COMPLETION_DATE,
   INCIDENT_DATE,
   ISSUED_DATE,
   MIN_TO_COMP,
   INSIDE_FLAG,
   OUTSIDE_FLAG
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT enquiry_id,
          b.admin_unit_name,
          b.admin_unit_id,
          b.admin_unit_code,
          b.admin_unit_level,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (incident_date, date_recorded), 'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (NVL (incident_date, date_recorded), -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (incident_date, date_recorded), 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (NVL (incident_date, date_recorded), 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          TO_CHAR (NVL (incident_date, date_recorded), 'RR') || ' '
          || DECODE (TO_CHAR (NVL (incident_date, date_recorded), 'Q'),
                     1, 'Q1',
                     2, 'Q2',
                     3, 'Q3',
                     4, 'Q4')
             qr_st_date,
          enquiry_type_code,
          class_code,
          enquiry_type_code,
          source_code,
          1 no_emgs,
          complete_date completion_date,
          incident_date,
          date_recorded issued_date,
          ROUND (
             TO_NUMBER (
                NVL (complete_date, SYSDATE)
                - NVL (incident_date, date_recorded))
             * 1440)
             AS "MIN_TO_COMP",
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (complete_date, SYSDATE)
                         - NVL (incident_date, date_recorded))
                      * 1440)) <= '120'
             THEN
                1
             ELSE
                0
          END
             inside_flag,
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (complete_date, SYSDATE)
                         - NVL (incident_date, date_recorded))
                      * 1440)) > '120'
             THEN
                1
             ELSE
                0
          END
             outside_flag
     FROM imf_enq_enquiries a, imf_hig_admin_units b, kpi_child_au c
    WHERE     enquiry_type_code = 'EMG'
          AND class_code = 'EMG'
          AND a.admin_unit_id = b.admin_unit_id
          AND complete_date IS NOT NULL
          AND a.admin_unit_id = c.child_admin_unit
          AND incident_date BETWEEN (SELECT CASE
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JAN'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'FEB'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'MAR'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'APR'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'MAY'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JUN'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JUL'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'AUG'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'SEP'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'OCT'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'NOV'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'DEC'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               ELSE
                                                  'sysdate'
                                            END
                                       FROM DUAL)
                                AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI1_RESP_TO_EMG_REV;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI1_RESP_TO_EMG_REV FOR KPI1_RESP_TO_EMG_REV;


DROP PUBLIC SYNONYM KPI1_RESP_TO_EMG_REV;

CREATE OR REPLACE PUBLIC SYNONYM KPI1_RESP_TO_EMG_REV FOR KPI1_RESP_TO_EMG_REV;

DROP VIEW KPI11_PPI_REV;

/* Formatted on 11-Mar-2011 10:46:07 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI11_PPI_REV
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   CNT,
   D_DATE_ISSUED,
   DOC_ID,
   D_CATEGORY,
   D_CLASS,
   D_TYPE,
   D_DELIV_DATE,
   D_INCIDENT_DATE,
   D_COMPLETE_DATE,
   D_STATUS,
   D_CODE
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued),
                           'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (
                      NVL (doc_compl_incident_date, doc_date_issued),
                      -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued),
                         'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued), 'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          hau_name,
          hau_admin_unit,
          1,
          doc_date_issued,
          doc_id,
          doc_dtp_code,
          doc_dcl_code,
          doc_compl_type,
          doc_compl_corresp_deliv_date,
          doc_compl_incident_date,
          doc_compl_complete,
          dac_status,
          dac_code
     FROM docs,
          doc_actions,
          hig_admin_units,
          kpi_child_au_sp
    WHERE     doc_dtp_code = 'PPI'
          AND doc_dcl_code = 'PPI'
          AND doc_compl_type = 'PI'
          AND doc_id = dac_doc_id
          --                    and doc_compl_complete is null
          AND dac_code IN ('P1', 'P2', 'P3', 'P4', 'P5')
          --                    and decode(nvl(d_status,'E'),'A','A','B','B','C','C','D','D','E','E','E') <> 'E'
          AND TRUNC (NVL (doc_compl_incident_date, doc_date_issued)) >
                 ADD_MONTHS (TRUNC (SYSDATE), -12)
          AND doc_admin_unit = hau_admin_unit
          AND child_admin_unit = hau_admin_unit;


DROP SYNONYM HIGHWAYS.KPI11_PPI_REV;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI11_PPI_REV FOR KPI11_PPI_REV;


DROP PUBLIC SYNONYM KPI11_PPI_REV;

CREATE OR REPLACE PUBLIC SYNONYM KPI11_PPI_REV FOR KPI11_PPI_REV;

DROP VIEW KPI12_RES;

/* Formatted on 11-Mar-2011 10:46:13 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI12_RES
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   ID_COUNT,
   DATE_ISS,
   DOC_ID,
   MIN_TO_COMP,
   IN_TARGET_FLAG,
   OVER_TARGET,
   IGNORE_FLAG,
   DATE_COMP
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (e.date_recorded, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (e.date_recorded, -12), 'RR')
             ELSE
                TO_CHAR (e.date_recorded, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (e.date_recorded, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          h.admin_unit_name,
          h.admin_unit_id,
          1 AS "countt",
          e.date_recorded,
          e.enquiry_id,
          (ROUND (
              (NVL (e.complete_date, SYSDATE)
               - NVL (e.incident_date, e.date_recorded))
              * 24
              * 60))
             AS "MIN_TO_COMP",
          CASE
             WHEN (ROUND (
                      (NVL (e.complete_date, SYSDATE)
                       - NVL (e.incident_date, e.date_recorded))
                      * 24
                      * 60)) >= 20160
             THEN
                0
             ELSE
                1
          END
             inn,
          CASE
             WHEN (ROUND (
                      (NVL (e.complete_date, SYSDATE)
                       - NVL (e.incident_date, e.date_recorded))
                      * 24
                      * 60)) < 20160
             THEN
                0
             ELSE
                1
          END
             outt,
          CASE
             WHEN (e.complete_date IS NULL)
             THEN
                CASE
                   WHEN (ROUND (
                            SYSDATE - NVL (e.incident_date, e.date_recorded))
                         * 24
                         * 60) <= 20160
                   THEN
                      'IGNORE'
                   ELSE
                      'VALID'
                END
             ELSE
                'VALID'
          END
             ignore_flag,
          NVL (e.complete_date, SYSDATE)
     FROM imf_enq_enquiries e, imf_hig_admin_units h, kpi_child_au
    WHERE     e.enquiry_type_code = 'DEVC'
          AND e.class_code = 'DESK'
          AND e.category_code = 'RES'
          AND e.admin_unit_id = h.admin_unit_id
          AND child_admin_unit = h.admin_unit_id
          AND e.date_recorded BETWEEN (SELECT CASE
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JAN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'FEB'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'APR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAY'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUL'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'AUG'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'SEP'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'OCT'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'NOV'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'DEC'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 ELSE
                                                    'sysdate'
                                              END
                                         FROM DUAL)
                                  AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI12_RES;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI12_RES FOR KPI12_RES;


DROP PUBLIC SYNONYM KPI12_RES;

CREATE OR REPLACE PUBLIC SYNONYM KPI12_RES FOR KPI12_RES;
DROP VIEW KPI12_RES_VALID;

/* Formatted on 11-Mar-2011 10:46:21 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI12_RES_VALID
(
   HAU_NAME,
   FY_ST_DATE,
   ID_COUNT,
   IN_TARGET_FLAG,
   OVER_TARGET
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT user_admin_name "Admin Unit Name",
            fy_st_date,
            SUM (id_count) AS "Total REQS",
            SUM (in_target_flag) AS "Within Tolerance",
            SUM (over_target) AS "Outside Tolerance"
       FROM kpi12_res
      WHERE ignore_flag = 'VALID'
   GROUP BY user_admin_name, fy_st_date;


DROP PUBLIC SYNONYM KPI12_RES_VALID;

CREATE OR REPLACE PUBLIC SYNONYM KPI12_RES_VALID FOR KPI12_RES_VALID;

DROP VIEW KPI12_WAG;

/* Formatted on 11-Mar-2011 10:46:27 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI12_WAG
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   ID_COUNT,
   DATE_ISS,
   DOC_ID,
   MIN_TO_COMP,
   IN_TARGET_FLAG,
   OVER_TARGET,
   IGNORE_FLAG,
   DATE_COMP
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (e.date_recorded, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (e.date_recorded, -12), 'RR')
             ELSE
                TO_CHAR (e.date_recorded, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (e.date_recorded, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          h.admin_unit_name,
          h.admin_unit_id,
          1 AS "count",
          e.date_recorded,
          e.enquiry_id,
          (ROUND (
              (NVL (e.complete_date, SYSDATE)
               - NVL (e.incident_date, e.date_recorded))
              * 24
              * 60))
             AS "MIN_TO_COMP",
          CASE
             WHEN (ROUND (
                      (NVL (e.complete_date, SYSDATE)
                       - NVL (e.incident_date, e.date_recorded))
                      * 24
                      * 60)) >= 7200
             THEN
                0
             ELSE
                1
          END
             inn,
          CASE
             WHEN (ROUND (
                      (NVL (e.complete_date, SYSDATE)
                       - NVL (e.incident_date, e.date_recorded))
                      * 24
                      * 60)) < 7200
             THEN
                0
             ELSE
                1
          END
             outt,
          CASE
             WHEN (e.complete_date IS NULL)
             THEN
                CASE
                   WHEN (ROUND (
                            SYSDATE - NVL (e.incident_date, e.date_recorded))
                         * 24
                         * 60) <= 7200
                   THEN
                      'IGNORE'
                   ELSE
                      'VALID'
                END
             ELSE
                'VALID'
          END
             ignore_flag,
          NVL (e.complete_date, SYSDATE)
     FROM imf_enq_enquiries e, imf_hig_admin_units h, kpi_child_au
    WHERE     e.enquiry_type_code = 'DEVC'
          AND e.class_code = 'DESK'
          AND e.category_code = 'WAG'
          AND e.admin_unit_id = h.admin_unit_id
          AND child_admin_unit = h.admin_unit_id
          AND e.date_recorded BETWEEN (SELECT CASE
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JAN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'FEB'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'APR'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'MAY'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUN'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'JUL'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'AUG'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'SEP'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'OCT'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -12),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'NOV'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -13),
                                                       'DD-MON-RRRR')
                                                 WHEN TO_CHAR (SYSDATE,
                                                               'MON') = 'DEC'
                                                 THEN
                                                    TO_CHAR (
                                                       ADD_MONTHS (
                                                          '01-'
                                                          || TO_CHAR (
                                                                SYSDATE,
                                                                'MON-YYYY'),
                                                          -14),
                                                       'DD-MON-RRRR')
                                                 ELSE
                                                    'sysdate'
                                              END
                                         FROM DUAL)
                                  AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI12_WAG;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI12_WAG FOR KPI12_WAG;


DROP PUBLIC SYNONYM KPI12_WAG;

CREATE OR REPLACE PUBLIC SYNONYM KPI12_WAG FOR KPI12_WAG;
DROP VIEW KPI12_WAG_VALID;

/* Formatted on 11-Mar-2011 10:46:34 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI12_WAG_VALID
(
   HAU_NAME,
   FY_ST_DATE,
   ID_COUNT,
   IN_TARGET_FLAG,
   OVER_TARGET
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT user_admin_name "Admin Unit Name",
            fy_st_date,
            SUM (id_count) AS "Total REQS",
            SUM (in_target_flag) AS "Within Tolerance",
            SUM (over_target) AS "Outside Tolerance"
       FROM kpi12_wag
      WHERE ignore_flag = 'VALID'
   GROUP BY user_admin_name, fy_st_date;


DROP SYNONYM HIGHWAYS.KPI12_WAG_VALID;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI12_WAG_VALID FOR KPI12_WAG_VALID;


DROP PUBLIC SYNONYM KPI12_WAG_VALID;

CREATE OR REPLACE PUBLIC SYNONYM KPI12_WAG_VALID FOR KPI12_WAG_VALID;

DROP VIEW KPI13_WOLINES;

/* Formatted on 11-Mar-2011 10:46:40 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI13_WOLINES
(
   CHILD_ADMIN_UNIT,
   USER_ADMIN_NAME,
   WOL_ID,
   WOL_DATE_CREATED,
   WOL_DEF_DEFECT_ID,
   WOL_DATE_COMPLETE,
   WOL_WORKS_ORDER_NO,
   WOL_EST_COST,
   WOL_ACT_COST,
   FYR_QTR,
   WOL_STATUS_CODE,
   NO_COMP,
   COMP,
   INSIDE_TOL,
   OUTSIDE_TOL,
   WORKS_ORDER_NO
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT child_admin_unit,
          user_admin_name,
          w.work_order_line_id,
          w.date_created,
          w.defect_id,
          w.date_completed,
          w.work_order_number,
          w.ESTIMATED_COST,
          w.ACTUAL_COST,
          CASE
             WHEN TO_CHAR (w.date_completed, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (w.date_completed, -12), 'RR')
             ELSE
                TO_CHAR (w.date_completed, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (w.date_completed, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fyr_qtr,
          WORK_ORDER_LINE_STATUS,
          DECODE (w.date_completed, NULL, 1, 0) no_comp,
          DECODE (w.date_completed, NULL, 0, 1) comp,
          CASE
             WHEN w.ACTUAL_COST = 0
             THEN
                0
             ELSE
                DECODE (
                   SIGN (
                      ABS ( (w.ESTIMATED_COST) - (w.ACTUAL_COST))
                      - ABS (w.ESTIMATED_COST) * 0.08),
                   -1, 1,
                   0, 1,
                   1, 0)
          END
             inside_tol,
          CASE
             WHEN w.ACTUAL_COST = 0
             THEN
                1
             ELSE
                DECODE (
                   SIGN (
                      ABS ( (w.ESTIMATED_COST) - (w.ACTUAL_COST))
                      - ABS (w.ESTIMATED_COST) * 0.08),
                   -1, 0,
                   0, 0,
                   1, 1)
          END
             outside_tol,
          w.work_order_number
     FROM imf_mai_work_order_lines w,
          imf_mai_work_orders o,
          kpi_child_au,
          IMF_NET_MAINT_SECTIONS_ALL N
    WHERE     o.works_order_number = w.work_order_number
          AND w.network_element_id = n.network_element_id
          AND n.admin_unit_id = child_admin_unit
          AND w.ACTUAL_COST IS NOT NULL
          AND w.ACTUAL_COST >= 5000
          AND w.date_completed IS NOT NULL
          AND w.date_completed BETWEEN (SELECT CASE
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JAN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'FEB'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'APR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAY'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUL'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'AUG'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'SEP'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'OCT'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'NOV'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'DEC'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  ELSE
                                                     'sysdate'
                                               END
                                          FROM DUAL)
                                   AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI13_WOLINES;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI13_WOLINES FOR KPI13_WOLINES;


DROP PUBLIC SYNONYM KPI13_WOLINES;

CREATE OR REPLACE PUBLIC SYNONYM KPI13_WOLINES FOR KPI13_WOLINES;

DROP VIEW KPI14_DAMG;

/* Formatted on 11-Mar-2011 10:46:47 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI14_DAMG
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   CNT,
   D_DATE_ISSUED,
   DOC_ID,
   D_CATEGORY,
   D_CLASS,
   D_TYPE,
   D_DELIV_DATE,
   D_INCIDENT_DATE,
   D_COMPLETE_DATE,
   D_EST_COST,
   D_ACT_COST
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (e.correspondence_received, e.incident_date),
                           'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (
                      NVL (e.correspondence_received, e.incident_date),
                      -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (e.correspondence_received, e.incident_date),
                         'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (e.correspondence_received, e.incident_date),
                         'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          h.admin_unit_name,
          h.admin_unit_id,
          1,
          e.date_recorded,
          e.enquiry_id,
          e.enquiry_type_code,
          e.class_code,
          e.category_code,
          e.correspondence_received,
          e.incident_date,
          e.complete_date,
          0 est,
          0 act
     FROM imf_enq_enquiries e, imf_hig_admin_units h, kpi_child_au
    WHERE e.enquiry_type_code = 'DAMG'
          AND TRUNC (NVL (e.correspondence_received, e.incident_date)) >=
                 ADD_MONTHS (TRUNC (SYSDATE), -24)
          AND e.admin_unit_id = h.admin_unit_id
          AND child_admin_unit = h.admin_unit_id;


DROP SYNONYM HIGHWAYS.KPI14_DAMG;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI14_DAMG FOR KPI14_DAMG;


DROP PUBLIC SYNONYM KPI14_DAMG;

CREATE OR REPLACE PUBLIC SYNONYM KPI14_DAMG FOR KPI14_DAMG;

DROP VIEW KPI14B_REP1;

/* Formatted on 11-Mar-2011 10:46:52 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI14B_REP1
(
   FY_ST_DATE,
   HAU_NAME,
   NOS_RECOV_COMP,
   COST_RECOV_COMP
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT fy_st_date,
            hau_name,
            NVL (COUNT (DECODE (d_class, 'RECV', cnt)), 0) nos_recov_comp,
            NVL (SUM (DECODE (d_class, 'RECV', NVL (d_act_cost, d_est_cost))),
                 0)
               cost_recov_comp
       FROM kpi14_damg
      WHERE     d_class = 'RECV'
            AND d_type <> 'LDEN'
            AND d_complete_date >= ADD_MONTHS (TRUNC (SYSDATE), -12)
   GROUP BY fy_st_date, hau_name
   ORDER BY 1, 2;


DROP SYNONYM HIGHWAYS.KPI14B_REP1;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI14B_REP1 FOR KPI14B_REP1;


DROP PUBLIC SYNONYM KPI14B_REP1;

CREATE OR REPLACE PUBLIC SYNONYM KPI14B_REP1 FOR KPI14B_REP1;

DROP VIEW KPI15_BUDGETS;

/* Formatted on 11-Mar-2011 10:46:57 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI15_BUDGETS
(
   BUD_AGENCY,
   FYR_ID,
   AUTHORITY_NAME,
   USER_ADMIN_CODE,
   ROAD_GROUP,
   BUDGET_CODE,
   TOTAL_SPEND_TODATE,
   SPEND_PERC_OF_BUDGET,
   RSE_ADMIN_UNIT,
   BUD_VALUE,
   BUD_COMMITTED,
   BUD_ACTUAL
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT bud_agency,
          fyr_id,
          user_admin_name authority_name,
          user_admin_code,
          rse_unique road_group,
             bud_icb_item_code
          || bud_icb_sub_item_code
          || bud_icb_sub_sub_item_code
             budget_code,
          bud_committed + bud_actual total_spend_todate,
          ROUND (
             ( (bud_committed + bud_actual)
              / DECODE (bud_value,  NULL, 0.01,  0, 0.01,  bud_value))
             * 100,
             2)
             spend_perc_of_budget,
          rse_admin_unit,
          bud_value,
          bud_committed,
          bud_actual
     FROM budgets,
          road_segs,
          financial_years,
          kpi_child_au_sp
    WHERE     bud_rse_he_id = rse_he_id(+)
          AND bud_fyr_id = fyr_id
          AND rse_admin_unit = child_admin_unit
          AND SYSDATE BETWEEN fyr_start_date AND fyr_end_date;


DROP SYNONYM HIGHWAYS.KPI15_BUDGETS;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI15_BUDGETS FOR KPI15_BUDGETS;


DROP PUBLIC SYNONYM KPI15_BUDGETS;

CREATE OR REPLACE PUBLIC SYNONYM KPI15_BUDGETS FOR KPI15_BUDGETS;

DROP VIEW KPI15_BUDGETS_MORE;

/* Formatted on 11-Mar-2011 10:47:01 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI15_BUDGETS_MORE
(
   BUD_AGENCY,
   ICB_TYPE_OF_SCHEME,
   WAG_ID,
   FYR_ID,
   AUTHORITY_NAME,
   USER_ADMIN_CODE,
   ROAD_GROUP,
   BUDGET_CODE,
   TOTAL_SPEND_TODATE,
   SPEND_PERC_OF_BUDGET,
   RSE_ADMIN_UNIT,
   BUD_VALUE,
   BUD_COMMITTED,
   BUD_ACTUAL
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT bud_agency,
          icb_type_of_scheme,
          (CASE
              WHEN icb_type_of_scheme IN
                      ('00',
                       '01',
                       '02',
                       '03',
                       '07',
                       '10',
                       '11',
                       '15',
                       '17',
                       '18',
                       '22',
                       '23',
                       '24',
                       '25',
                       '26',
                       '27',
                       '28',
                       '29',
                       '30',
                       '33',
                       '34')
              THEN
                 'CAPITAL'
              WHEN icb_type_of_scheme IN
                      ('04',
                       '05',
                       '06',
                       '08',
                       '09',
                       '12',
                       '13',
                       '14',
                       '16',
                       '19',
                       '20',
                       '21',
                       '31',
                       '32',
                       'F1',
                       'F2',
                       'F3',
                       'F4',
                       'F5',
                       'F6',
                       'F7',
                       'F8')
              THEN
                 'REVENUE'
              ELSE
                 'IGNORE'
           END)
             wag_id,
          fyr_id,
          authority_name,
          user_admin_code,
          road_group,
          budget_code,
          total_spend_todate,
          spend_perc_of_budget,
          rse_admin_unit,
          bud_value,
          bud_committed,
          bud_actual
     FROM kpi15_budgets, item_code_breakdowns
    WHERE bud_agency = icb_agency_code AND icb_work_code = budget_code;


DROP SYNONYM HIGHWAYS.KPI15_BUDGETS_MORE;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI15_BUDGETS_MORE FOR KPI15_BUDGETS_MORE;


DROP PUBLIC SYNONYM KPI15_BUDGETS_MORE;

CREATE OR REPLACE PUBLIC SYNONYM KPI15_BUDGETS_MORE FOR KPI15_BUDGETS_MORE;

DROP VIEW KPI1A_RESP_TO_EMG_REV;

/* Formatted on 11-Mar-2011 10:47:06 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI1A_RESP_TO_EMG_REV
(
   DOC_ID,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   HAU_UNIT_CODE,
   HAU_LEVEL,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME,
   FY_ST_DATE,
   QR_ST_DATE,
   DOC_CODE,
   DOC_CL,
   DOC_TYPE,
   DOC_SOURCE,
   NO_EMGS,
   COMPLETION_DATE,
   INCIDENT_DATE,
   ISSUED_DATE,
   MIN_TO_COMP,
   INSIDE_FLAG,
   OUTSIDE_FLAG
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT doc_id,
          hau_name,
          hau_admin_unit,
          hau_unit_code,
          hau_level,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued),
                           'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (
                      NVL (doc_compl_incident_date, doc_date_issued),
                      -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued),
                         'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued), 'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued), 'RR')
          || ' '
          || DECODE (
                TO_CHAR (NVL (doc_compl_incident_date, doc_date_issued), 'Q'),
                1, 'Q1',
                2, 'Q2',
                3, 'Q3',
                4, 'Q4')
             qr_st_date,
          doc_dtp_code,
          doc_dcl_code,
          doc_compl_type,
          doc_compl_source,
          1 no_emgs,
          doc_compl_complete completion_date,
          doc_compl_incident_date incident_date,
          doc_date_issued issued_date,
          ROUND (
             TO_NUMBER (
                NVL (doc_compl_complete, SYSDATE)
                - NVL (doc_compl_incident_date, doc_date_issued))
             * 1440)
             AS MIN_TO_COMP,
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (doc_compl_complete, SYSDATE)
                         - NVL (doc_compl_incident_date, doc_date_issued))
                      * 1440)) <= '120'
             THEN
                1
             ELSE
                0
          END
             inside_flag,
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (doc_compl_complete, SYSDATE)
                         - NVL (doc_compl_incident_date, doc_date_issued))
                      * 1440)) > '120'
             THEN
                1
             ELSE
                0
          END
             outside_flag
     FROM docs, hig_admin_units, kpi_child_au c
    WHERE     doc_dtp_code = 'EMG'
          AND doc_dcl_code = 'EMG'
          AND doc_admin_unit = hau_admin_unit
          AND doc_compl_complete IS NOT NULL
          AND doc_admin_unit = c.child_admin_unit
          AND doc_compl_incident_date BETWEEN (SELECT CASE
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'JAN'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -12),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'FEB'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -13),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'MAR'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -14),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'APR'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -12),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'MAY'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -13),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'JUN'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -14),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'JUL'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -12),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'AUG'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -13),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'SEP'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -14),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'OCT'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -12),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'NOV'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -13),
                                                               'DD-MON-RRRR')
                                                         WHEN TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON') =
                                                                 'DEC'
                                                         THEN
                                                            TO_CHAR (
                                                               ADD_MONTHS (
                                                                  '01-'
                                                                  || TO_CHAR (
                                                                        SYSDATE,
                                                                        'MON-YYYY'),
                                                                  -14),
                                                               'DD-MON-RRRR')
                                                         ELSE
                                                            'sysdate'
                                                      END
                                                 FROM DUAL)
                                          AND (SELECT SYSDATE FROM DUAL);


DROP PUBLIC SYNONYM KPI1A_RESP_TO_EMG_REV;

CREATE OR REPLACE PUBLIC SYNONYM KPI1A_RESP_TO_EMG_REV FOR KPI1A_RESP_TO_EMG_REV;

DROP VIEW KPI1A_RESP_TO_EMG_REV2;

/* Formatted on 11-Mar-2011 10:47:12 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI1A_RESP_TO_EMG_REV2
(
   DOC_ID,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   HAU_UNIT_CODE,
   HAU_LEVEL,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME,
   FY_ST_DATE,
   QR_ST_DATE,
   DOC_CODE,
   DOC_CL,
   DOC_TYPE,
   DOC_SOURCE,
   NO_EMGS,
   DATE_TIME_ARRIVED,
   INCIDENT_DATE,
   ISSUED_DATE,
   MIN_TO_ARRIVE,
   INSIDE_FLAG,
   OUTSIDE_FLAG
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT enquiry_id,
          b.admin_unit_name,
          b.admin_unit_id,
          b.admin_unit_code,
          b.admin_unit_level,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (incident_date, date_Recorded), 'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (NVL (incident_date, date_Recorded), -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (incident_date, date_Recorded), 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (NVL (incident_date, date_Recorded), 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          TO_CHAR (NVL (incident_date, date_Recorded), 'RR') || ' '
          || DECODE (TO_CHAR (NVL (incident_date, date_Recorded), 'Q'),
                     1, 'Q1',
                     2, 'Q2',
                     3, 'Q3',
                     4, 'Q4')
             qr_st_date,
          enquiry_type_code,
          class_code,
          enquiry_type_code,
          source_code,
          1 no_emgs,
          date_time_arrived,
          incident_date,
          date_Recorded issued_date,
          ROUND (
             TO_NUMBER (
                NVL (date_time_arrived, SYSDATE)
                - NVL (incident_date, date_Recorded))
             * 1440)
             AS "MIN_TO_ARRIVE",
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (date_time_arrived, SYSDATE)
                         - NVL (incident_date, date_Recorded))
                      * 1440)) <= '120'
             THEN
                1
             ELSE
                0
          END
             inside_flag,
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (date_time_arrived, SYSDATE)
                         - NVL (incident_date, date_Recorded))
                      * 1440)) > '120'
             THEN
                1
             ELSE
                0
          END
             outside_flag
     FROM imf_enq_enquiries a, imf_hig_admin_units b, kpi_child_au c
    WHERE     enquiry_type_code = 'EMG'
          AND class_code = 'EMG'
          AND a.admin_unit_id = b.admin_unit_id
          AND date_time_arrived IS NOT NULL
          AND a.admin_unit_id = c.child_admin_unit
          AND incident_date BETWEEN (SELECT CASE
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JAN'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'FEB'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'MAR'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'APR'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'MAY'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JUN'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'JUL'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'AUG'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'SEP'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'OCT'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -12),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'NOV'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -13),
                                                     'DD-MON-RRRR')
                                               WHEN TO_CHAR (SYSDATE, 'MON') =
                                                       'DEC'
                                               THEN
                                                  TO_CHAR (
                                                     ADD_MONTHS (
                                                        '01-'
                                                        || TO_CHAR (
                                                              SYSDATE,
                                                              'MON-YYYY'),
                                                        -14),
                                                     'DD-MON-RRRR')
                                               ELSE
                                                  'sysdate'
                                            END
                                       FROM DUAL)
                                AND (SELECT SYSDATE FROM DUAL);


DROP PUBLIC SYNONYM KPI1A_RESP_TO_EMG_REV2;

CREATE OR REPLACE PUBLIC SYNONYM KPI1A_RESP_TO_EMG_REV2 FOR KPI1A_RESP_TO_EMG_REV2;

DROP VIEW KPI2_DETAIL;

/* Formatted on 11-Mar-2011 10:47:17 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI2_DETAIL
(
   NOSS,
   ARE_DATE_WORK_DONE,
   RSE_INT_CODE,
   INT,
   INSP,
   INSPTYPE,
   ARE_INITIATION_TYPE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   RSE_HE_ID,
   RSE_UNIQUE,
   RSE_DESCR,
   RSE_MAINT_CATEGORY,
   CATT,
   ARE_ST_CHAIN,
   ARE_END_CHAIN,
   FULLP,
   ARE_REPORT_ID,
   MANN,
   ARE_CREATED_DATE,
   ARE_INSP_LOAD_DATE,
   HUS_NAME,
   HUS_INIT,
   NOSDEFS
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT ROWNUM noss,
            date_inspected,
            int_code,
            DECODE (int_code, NULL, 'Not Set', description),
            INITIATION_TYPE_DESCRIPTION,
            SUBSTR (compl_domain ('INITIATION_TYPE', initiation_type), 1, 20),
            initiation_type,
            d.admin_unit_name,
            d.admin_unit_id,
            d.network_element_id,
            d.network_element_reference,
            d.network_element_description,
            d.maint_category,
            d.maint_category_descr,
            start_offset,
            end_offset,
            DECODE (ROUND (network_element_length) - ROUND (end_offset),
                    0, 'Full',
                    'Partial')
               fullp,
            inspection_id,
            DECODE (date_loaded, NULL, 'Manual', 'DCD') mann,
            date_of_entry,
            date_loaded,
            primary_inspector_name,
            primary_inspector_initials,
            (SELECT COUNT (1)
               FROM imf_mai_defects def
              WHERE def.inspection_id = i.inspection_id)
       FROM imf_net_d d, imf_mai_inspections i, imf_mai_intervals
      WHERE     d.network_element_id = i.network_element_id
            AND int_code = code
            AND i.SAFETY_DETAILED_FLAG = 'S'
            AND i.initiation_type = 'NRM'
            AND ROUND (network_element_length) - ROUND (end_offset) <= 0
            AND i.date_inspected BETWEEN (SELECT CASE
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JAN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'FEB'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'APR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAY'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUL'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'AUG'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'SEP'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'OCT'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'NOV'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'DEC'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    ELSE
                                                       'sysdate'
                                                 END
                                            FROM DUAL)
                                     AND (SELECT SYSDATE FROM DUAL)
   GROUP BY ROWNUM,
            date_inspected,
            int_code,
            DECODE (int_code, NULL, 'Not Set', description),
            INITIATION_TYPE_DESCRIPTION,
            SUBSTR (compl_domain ('INITIATION_TYPE', initiation_type), 1, 20),
            initiation_type,
            d.admin_unit_name,
            d.admin_unit_id,
            d.network_element_id,
            d.network_element_reference,
            d.network_element_description,
            d.maint_category,
            d.maint_category_descr,
            start_offset,
            end_offset,
            DECODE (ROUND (network_element_length) - ROUND (end_offset),
                    0, 'Full',
                    'Partial'),
            inspection_id,
            DECODE (date_loaded, NULL, 'Manual', 'DCD'),
            date_of_entry,
            date_loaded,
            primary_inspector_name,
            primary_inspector_initials;


DROP SYNONYM HIGHWAYS.KPI2_DETAIL;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI2_DETAIL FOR KPI2_DETAIL;


DROP PUBLIC SYNONYM KPI2_DETAIL;

CREATE OR REPLACE PUBLIC SYNONYM KPI2_DETAIL FOR KPI2_DETAIL;

DROP VIEW KPI2_DETAIL_MORE;

/* Formatted on 11-Mar-2011 10:47:22 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI2_DETAIL_MORE
(
   RSE_HE_ID,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   INTERVAL,
   INTCODE,
   RSE_UNIQUE,
   INSPECTION_ID,
   DATE_WORK_DONE,
   PREV_INSP,
   DIFF_IN_DAYS,
   IGNORE,
   ONTARGET,
   FYR_QTR
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT rse_he_id,
            hau_name,
            hau_admin_unit                            --      ,user_Admin_name
                          ,
            INT INTERVAL,
            NVL (rse_int_code, -1) intcode,
            rse_unique,
            are_report_id inspection_id,
            TRUNC (are_date_work_done) date_work_done,
            LAG (TRUNC (are_date_work_done), 1)
               OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done))
               AS prev_insp,
            TRUNC (are_date_work_done)
            - NVL (
                 LAG (TRUNC (are_date_work_done), 1)
                    OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done)),
                 TRUNC (are_date_work_done))
               AS diff_in_days,
            CASE
               WHEN rse_he_id
                    - LAG (
                         rse_he_id,
                         1)
                      OVER (
                         ORDER BY rse_unique, INT, TRUNC (are_date_work_done)) <>
                       0
               THEN
                  'Y'
               ELSE
                  DECODE (ROWNUM, 1, 'Y', 'N')
            END
               ignore,
            CASE
               WHEN TRUNC (are_date_work_done)
                    - NVL (
                         LAG (
                            TRUNC (are_date_work_done),
                            1)
                         OVER (
                            ORDER BY
                               rse_unique, INT, TRUNC (are_date_work_done)),
                         SYSDATE)
                    - DECODE (rse_int_code,
                              '307', 7,
                              '314', 14,
                              '328', 28,
                              0) <= 0
               THEN
                  'ON TIME'
               ELSE
                  'NOT ON TIME'
            END
               AS ontarget,
            CASE
               WHEN TO_CHAR (TRUNC (are_date_work_done), 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (TRUNC (are_date_work_done), -12), 'RR')
               ELSE
                  TO_CHAR (TRUNC (are_date_work_done), 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (TRUNC (are_date_work_done), 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3')
               fyr_qtr
       FROM kpi2_detail, kpi_child_au
      WHERE hau_admin_unit = child_admin_unit
   --   and  rse_unique like '1004018%'
   ORDER BY rse_unique,
            INT,
            rse_int_code,
            TRUNC (are_date_work_done);


DROP SYNONYM HIGHWAYS.KPI2_DETAIL_MORE;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI2_DETAIL_MORE FOR KPI2_DETAIL_MORE;


DROP PUBLIC SYNONYM KPI2_DETAIL_MORE;

CREATE OR REPLACE PUBLIC SYNONYM KPI2_DETAIL_MORE FOR KPI2_DETAIL_MORE;

DROP VIEW KPI2_DETAIL_MORE_SP;

/* Formatted on 11-Mar-2011 10:47:26 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI2_DETAIL_MORE_SP
(
   RSE_HE_ID,
   HAU_NAME,
   USER_ADMIN_NAME,
   INTERVAL,
   INTCODE,
   RSE_UNIQUE,
   INSPECTION_ID,
   DATE_WORK_DONE,
   PREV_INSP,
   DIFF_IN_DAYS,
   IGNORE,
   ONTARGET,
   FYR_QTR,
   INSP_INITIALS
)
AS
  -----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
 SELECT rse_he_id,
          hau_name,
          user_admin_code,
          INT INTERVAL,
          NVL (rse_int_code, -1) intcode,
          rse_unique,
          are_report_id inspection_id,
          TRUNC (are_date_work_done) date_work_done,
          --,to_char(trunc(are_date_work_done),'HH24') formy,
          LAG (TRUNC (are_date_work_done), 1)
             OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done))
             AS prev_insp,
          TRUNC (are_date_work_done)
          - NVL (
               LAG (TRUNC (are_date_work_done), 1)
                  OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done)),
               TRUNC (are_date_work_done))
             AS diff_in_days,
          CASE
             WHEN rse_he_id
                  - LAG (
                       rse_he_id,
                       1)
                    OVER (
                       ORDER BY rse_unique, INT, TRUNC (are_date_work_done)) <>
                     0
             THEN
                'Y'
             ELSE
                DECODE (ROWNUM, 1, 'Y', 'N')
          END
             ignore,
          CASE
             WHEN TRUNC (are_date_work_done)
                  - NVL (
                       LAG (
                          TRUNC (are_date_work_done),
                          1)
                       OVER (
                          ORDER BY
                             rse_unique, INT, TRUNC (are_date_work_done)),
                       SYSDATE)
                  - DECODE (rse_int_code,
                            '307', 7,
                            '314', 14,
                            '328', 28,
                            0) <= 0
             THEN
                'ON TIME'
             ELSE
                'NOT ON TIME'
          END
             AS ontarget,
          CASE
             WHEN TO_CHAR (TRUNC (are_date_work_done), 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (TRUNC (are_date_work_done), -12), 'RR')
             ELSE
                TO_CHAR (TRUNC (are_date_work_done), 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (TRUNC (are_date_work_done), 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fyr_qtr,
          hus_init
     FROM kpi2_detail_mv, kpi_child_au_sp
    WHERE hau_admin_unit = child_admin_unit
--   and  rse_unique like '1004018%'
--   ORDER BY rse_unique, INT, rse_int_code, trunc(are_date_work_done) ;
;


DROP SYNONYM HIGHWAYS.KPI2_DETAIL_MORE_SP;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI2_DETAIL_MORE_SP FOR KPI2_DETAIL_MORE_SP;


DROP PUBLIC SYNONYM KPI2_DETAIL_MORE_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI2_DETAIL_MORE_SP FOR KPI2_DETAIL_MORE_SP;

DROP VIEW KPI2_DETAIL_MORE_VIEW;

/* Formatted on 11-Mar-2011 10:47:31 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI2_DETAIL_MORE_VIEW
(
   RSE_HE_ID,
   HAU_NAME,
   USER_ADMIN_NAME,
   INTERVAL,
   INTCODE,
   RSE_UNIQUE,
   INSPECTION_ID,
   DATE_WORK_DONE,
   PREV_INSP,
   DIFF_IN_DAYS,
   IGNORE,
   ONTARGET,
   FYR_QTR
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT rse_he_id,
          hau_name,
          user_admin_name,
          INT INTERVAL,
          NVL (rse_int_code, -1) intcode,
          rse_unique,
          are_report_id inspection_id,
          TRUNC (are_date_work_done) date_work_done --,to_char(trunc(are_date_work_done),'HH24') formy
                                                   ,
          LAG (TRUNC (are_date_work_done), 1)
             OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done))
             AS prev_insp,
          TRUNC (are_date_work_done)
          - NVL (
               LAG (TRUNC (are_date_work_done), 1)
                  OVER (ORDER BY rse_unique, INT, TRUNC (are_date_work_done)),
               TRUNC (are_date_work_done))
             AS diff_in_days,
          CASE
             WHEN rse_he_id
                  - LAG (
                       rse_he_id,
                       1)
                    OVER (
                       ORDER BY rse_unique, INT, TRUNC (are_date_work_done)) <>
                     0
             THEN
                'Y'
             ELSE
                DECODE (ROWNUM, 1, 'Y', 'N')
          END
             ignore,
          CASE
             WHEN TRUNC (are_date_work_done)
                  - NVL (
                       LAG (
                          TRUNC (are_date_work_done),
                          1)
                       OVER (
                          ORDER BY
                             rse_unique, INT, TRUNC (are_date_work_done)),
                       SYSDATE)
                  - DECODE (rse_int_code,
                            '307', 7,
                            '314', 14,
                            '328', 28,
                            0) <= 0
             THEN
                'ON TIME'
             ELSE
                'NOT ON TIME'
          END
             AS ontarget,
          CASE
             WHEN TO_CHAR (TRUNC (are_date_work_done), 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (TRUNC (are_date_work_done), -12), 'RR')
             ELSE
                TO_CHAR (TRUNC (are_date_work_done), 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (TRUNC (are_date_work_done), 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fyr_qtr
     FROM KPI2_DETAIL_mv, kpi_child_au
    WHERE hau_admin_unit = child_admin_unit;


DROP SYNONYM HIGHWAYS.KPI2_DETAIL_MORE_VIEW;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI2_DETAIL_MORE_VIEW FOR KPI2_DETAIL_MORE_VIEW;


DROP PUBLIC SYNONYM KPI2_DETAIL_MORE_VIEW;

CREATE OR REPLACE PUBLIC SYNONYM KPI2_DETAIL_MORE_VIEW FOR KPI2_DETAIL_MORE_VIEW;

DROP VIEW KPI2_DETAIL_OLD;

/* Formatted on 11-Mar-2011 10:47:36 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI2_DETAIL_OLD
(
   NOSS,
   ARE_DATE_WORK_DONE,
   RSE_INT_CODE,
   INT,
   INSP,
   INSPTYPE,
   ARE_INITIATION_TYPE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   RSE_HE_ID,
   RSE_UNIQUE,
   RSE_DESCR,
   RSE_MAINT_CATEGORY,
   CATT,
   ARE_ST_CHAIN,
   ARE_END_CHAIN,
   FULLP,
   ARE_REPORT_ID,
   MANN,
   ARE_CREATED_DATE,
   ARE_INSP_LOAD_DATE,
   ARETYPE,
   HUS_NAME,
   HUS_INIT,
   SAFDET,
   NOSDEFS
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT ROWNUM noss,
          are_date_work_done,
          rse_int_code,
          DECODE (rse_int_code, NULL, 'Not Set', int_descr) INT,
          DECODE (are_maint_insp_flag, 'D', 'Detailed', 'Safety') insp,
          SUBSTR (compl_domain ('INITIATION_TYPE', are_initiation_type),
                  1,
                  20)
             insptype,
          are_initiation_type,
          hau_name,
          hau_admin_unit,
          rse_he_id,
          rse_unique,
          rse_descr,
          rse_maint_category,
          SUBSTR (compl_domain ('MAINTENANCE_CATEGORY', rse_maint_category),
                  1,
                  20)
             catt,
          are_st_chain,
          are_end_chain,
          DECODE (rse_length - are_end_chain, 0, 'Full', 'Partial') fullp,
          are_report_id,
          DECODE (are_insp_load_date, NULL, 'Manual', 'DCD') mann,
          are_created_date,
          are_insp_load_date,
          SUBSTR (compl_domain ('INITIATION_TYPE', are_initiation_type),
                  1,
                  20)
             aretype,
          hus_name,
          hus_initials,
          DECODE (are_maint_insp_flag, 'D', 'Detailed', 'Safety') safdet,
          f$number_of_defects (are_report_id) nosdefs
     FROM activities_report,
          road_sections,
          hig_users,
          intervals,
          hig_admin_units
    WHERE     are_rse_he_id = rse_he_id
          AND are_peo_person_id_actioned = hus_user_id
          AND rse_int_code = int_code(+)
          AND rse_admin_unit = hau_admin_unit
          -- hau_end_date is null
          --and (rse_he_id = 66402 or rse_he_id = 66410 or rse_he_id = 63922)--
          --and rse_he_id = 63922
          AND are_date_work_done BETWEEN (SELECT CASE
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JAN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'FEB'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'APR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAY'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUL'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'AUG'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'SEP'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'OCT'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'NOV'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'DEC'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    ELSE
                                                       'sysdate'
                                                 END
                                            FROM DUAL)
                                     AND (SELECT SYSDATE FROM DUAL)
          AND are_maint_insp_flag = 'S'
          AND are_initiation_type = 'NRM'
          AND rse_length - are_end_chain = 0
--full
--order by are_rse_he_id,rse_int_code,are_date_work_done asc;
;


DROP SYNONYM HIGHWAYS.KPI2_DETAIL_OLD;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI2_DETAIL_OLD FOR KPI2_DETAIL_OLD;


DROP PUBLIC SYNONYM KPI2_DETAIL_OLD;

CREATE OR REPLACE PUBLIC SYNONYM KPI2_DETAIL_OLD FOR KPI2_DETAIL_OLD;

DROP VIEW KPI3_DEF_BY_STATUS;

/* Formatted on 11-Mar-2011 10:47:42 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI3_DEF_BY_STATUS
(
   HAU_NAME,
   DEF_STATUS_CODE,
   FY_ST_DATE,
   TOT_DEFECTS
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT hau_name,
            def_status_code,
            CASE
               WHEN TO_CHAR (def_created_date, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
               ELSE
                  TO_CHAR (def_created_date, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (def_created_date, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3')
               fy_st_date,
            COUNT (def_defect_id) tot_defects
       FROM nm_elements,
            kpi_child_au,
            defects,
            hig_admin_units
      WHERE     def_priority = 1
            AND ne_admin_unit = child_admin_unit
            AND def_rse_he_id = ne_id
            AND ne_type = 'S'
            AND hau_admin_unit = child_admin_unit
            AND def_created_date BETWEEN (SELECT CASE
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JAN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'FEB'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'APR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAY'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUL'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'AUG'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'SEP'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'OCT'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'NOV'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'DEC'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    ELSE
                                                       'sysdate'
                                                 END
                                            FROM DUAL)
                                     AND (SELECT SYSDATE FROM DUAL)
   GROUP BY hau_name,
            def_status_code,
            CASE
               WHEN TO_CHAR (def_created_date, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
               ELSE
                  TO_CHAR (def_created_date, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (def_created_date, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3');


DROP PUBLIC SYNONYM KPI3_DEF_BY_STATUS;

CREATE OR REPLACE PUBLIC SYNONYM KPI3_DEF_BY_STATUS FOR KPI3_DEF_BY_STATUS;

DROP VIEW KPI3_DEFECTS;

/* Formatted on 11-Mar-2011 10:47:48 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI3_DEFECTS
(
   ADMIN_UNIT_ID,
   FYRQTR,
   CNT
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT admin_unit_id,
            CASE
               WHEN TO_CHAR (b.date_recorded, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (B.DATE_RECORDED, -12), 'RR')
               ELSE
                  TO_CHAR (b.date_recorded, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (b.date_recorded, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3')
               fy_st_date,
            COUNT (b.defect_id)
       FROM imf_net_d a, imf_mai_defects b
      WHERE b.network_element_id = a.network_element_id AND priority = '1'
            AND b.date_recorded BETWEEN (SELECT CASE
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'JAN'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -12),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'FEB'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -13),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'MAR'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -14),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'APR'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -12),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'MAY'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -13),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'JUN'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -14),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'JUL'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -12),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'AUG'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -13),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'SEP'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -14),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'OCT'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -12),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'NOV'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -13),
                                                         'DD-MON-RRRR')
                                                   WHEN TO_CHAR (SYSDATE,
                                                                 'MON') = 'DEC'
                                                   THEN
                                                      TO_CHAR (
                                                         ADD_MONTHS (
                                                            '01-'
                                                            || TO_CHAR (
                                                                  SYSDATE,
                                                                  'MON-YYYY'),
                                                            -14),
                                                         'DD-MON-RRRR')
                                                   ELSE
                                                      'sysdate'
                                                END
                                           FROM DUAL)
                                    AND (SELECT SYSDATE FROM DUAL)
   GROUP BY admin_unit_id,
            CASE
               WHEN TO_CHAR (b.date_recorded, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (b.date_recorded, -12), 'RR')
               ELSE
                  TO_CHAR (b.date_recorded, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (b.date_recorded, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3');


DROP PUBLIC SYNONYM KPI3_DEFECTS;

CREATE OR REPLACE PUBLIC SYNONYM KPI3_DEFECTS FOR KPI3_DEFECTS;


DROP SYNONYM HIGHWAYS.KPI3_DEFECTS;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI3_DEFECTS FOR KPI3_DEFECTS;

DROP VIEW KPI3_DEFECTS_ALL;

/* Formatted on 11-Mar-2011 10:47:54 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI3_DEFECTS_ALL
(
   HAU_NAME,
   FY_ST_DATE,
   DEF_DEFECT_ID,
   DEF_RSE_HE_ID,
   DEF_IIT_ITEM_ID,
   DEF_ST_CHAIN,
   DEF_ARE_REPORT_ID,
   DEF_ATV_ACTY_AREA_CODE,
   DEF_SISS_ID,
   DEF_WORKS_ORDER_NO,
   DEF_CREATED_DATE,
   DEF_DEFECT_CODE,
   DEF_LAST_UPDATED_DATE,
   DEF_ORIG_PRIORITY,
   DEF_PRIORITY,
   DEF_STATUS_CODE,
   DEF_SUPERSEDED_FLAG,
   DEF_AREA,
   DEF_ARE_ID_NOT_FOUND,
   DEF_COORD_FLAG,
   DEF_DATE_COMPL,
   DEF_DATE_NOT_FOUND,
   DEF_DEFECT_CLASS,
   DEF_DEFECT_DESCR,
   DEF_DEFECT_TYPE_DESCR,
   DEF_DIAGRAM_NO,
   DEF_HEIGHT,
   DEF_IDENT_CODE,
   DEF_ITY_INV_CODE,
   DEF_ITY_SYS_FLAG,
   DEF_LENGTH,
   DEF_LOCN_DESCR,
   DEF_MAINT_WO,
   DEF_MAND_ADV,
   DEF_NOTIFY_ORG_ID,
   DEF_NUMBER,
   DEF_PER_CENT,
   DEF_PER_CENT_ORIG,
   DEF_PER_CENT_REM,
   DEF_RECHAR_ORG_ID,
   DEF_SERIAL_NO,
   DEF_SKID_COEFF,
   DEF_SPECIAL_INSTR,
   DEF_SUPERSEDED_ID,
   DEF_TIME_HRS,
   DEF_TIME_MINS,
   DEF_UPDATE_INV,
   DEF_X_SECT,
   DEF_EASTING,
   DEF_NORTHING,
   DEF_RESPONSE_CATEGORY
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT hau_name,
          CASE
             WHEN TO_CHAR (def_created_date, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
             ELSE
                TO_CHAR (def_created_date, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (def_created_date, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          def."DEF_DEFECT_ID",
          def."DEF_RSE_HE_ID",
          def."DEF_IIT_ITEM_ID",
          def."DEF_ST_CHAIN",
          def."DEF_ARE_REPORT_ID",
          def."DEF_ATV_ACTY_AREA_CODE",
          def."DEF_SISS_ID",
          def."DEF_WORKS_ORDER_NO",
          def."DEF_CREATED_DATE",
          def."DEF_DEFECT_CODE",
          def."DEF_LAST_UPDATED_DATE",
          def."DEF_ORIG_PRIORITY",
          def."DEF_PRIORITY",
          def."DEF_STATUS_CODE",
          def."DEF_SUPERSEDED_FLAG",
          def."DEF_AREA",
          def."DEF_ARE_ID_NOT_FOUND",
          def."DEF_COORD_FLAG",
          def."DEF_DATE_COMPL",
          def."DEF_DATE_NOT_FOUND",
          def."DEF_DEFECT_CLASS",
          def."DEF_DEFECT_DESCR",
          def."DEF_DEFECT_TYPE_DESCR",
          def."DEF_DIAGRAM_NO",
          def."DEF_HEIGHT",
          def."DEF_IDENT_CODE",
          def."DEF_ITY_INV_CODE",
          def."DEF_ITY_SYS_FLAG",
          def."DEF_LENGTH",
          def."DEF_LOCN_DESCR",
          def."DEF_MAINT_WO",
          def."DEF_MAND_ADV",
          def."DEF_NOTIFY_ORG_ID",
          def."DEF_NUMBER",
          def."DEF_PER_CENT",
          def."DEF_PER_CENT_ORIG",
          def."DEF_PER_CENT_REM",
          def."DEF_RECHAR_ORG_ID",
          def."DEF_SERIAL_NO",
          def."DEF_SKID_COEFF",
          def."DEF_SPECIAL_INSTR",
          def."DEF_SUPERSEDED_ID",
          def."DEF_TIME_HRS",
          def."DEF_TIME_MINS",
          def."DEF_UPDATE_INV",
          def."DEF_X_SECT",
          def."DEF_EASTING",
          def."DEF_NORTHING",
          def."DEF_RESPONSE_CATEGORY"
     FROM nm_elements,
          kpi_child_au,
          defects def,
          hig_admin_units
    WHERE     def_priority = 1
          AND ne_admin_unit = child_admin_unit
          AND def_rse_he_id = ne_id
          AND ne_type = 'S'
          AND hau_admin_unit = child_admin_unit
          AND def_created_date BETWEEN (SELECT CASE
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JAN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'FEB'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'APR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAY'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUL'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'AUG'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'SEP'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'OCT'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'NOV'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'DEC'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  ELSE
                                                     'sysdate'
                                               END
                                          FROM DUAL)
                                   AND (SELECT SYSDATE FROM DUAL);


DROP PUBLIC SYNONYM KPI3_DEFECTS_ALL;

CREATE OR REPLACE PUBLIC SYNONYM KPI3_DEFECTS_ALL FOR KPI3_DEFECTS_ALL;

DROP VIEW KPI3_DEFECTS_DETAILS;

/* Formatted on 11-Mar-2011 10:47:59 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI3_DEFECTS_DETAILS
(
   ADMIN_NAME,
   FYRQTR,
   CNT
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
     SELECT hau_name,
            CASE
               WHEN TO_CHAR (def_created_date, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
               ELSE
                  TO_CHAR (def_created_date, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (def_created_date, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3')
               fy_st_date,
            COUNT (def_defect_id)
       FROM nm_elements,
            kpi_child_au,
            defects,
            hig_admin_units
      WHERE     def_priority = 1
            AND ne_admin_unit = child_admin_unit
            AND def_rse_he_id = ne_id
            AND ne_type = 'S'
            AND hau_admin_unit = child_admin_unit
            AND def_created_date BETWEEN (SELECT CASE
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JAN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'FEB'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'APR'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'MAY'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUN'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'JUL'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'AUG'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'SEP'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'OCT'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -12),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'NOV'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -13),
                                                          'DD-MON-RRRR')
                                                    WHEN TO_CHAR (SYSDATE,
                                                                  'MON') =
                                                            'DEC'
                                                    THEN
                                                       TO_CHAR (
                                                          ADD_MONTHS (
                                                             '01-'
                                                             || TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON-YYYY'),
                                                             -14),
                                                          'DD-MON-RRRR')
                                                    ELSE
                                                       'sysdate'
                                                 END
                                            FROM DUAL)
                                     AND (SELECT SYSDATE FROM DUAL)
   GROUP BY hau_name,
            CASE
               WHEN TO_CHAR (def_created_date, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
               ELSE
                  TO_CHAR (def_created_date, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (def_created_date, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3')
   ORDER BY hau_name,
            CASE
               WHEN TO_CHAR (def_created_date, 'Q') = 1
               THEN
                  TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
               ELSE
                  TO_CHAR (def_created_date, 'RR')
            END
            || ' '
            || DECODE (TO_CHAR (def_created_date, 'Q'),
                       1, 'Q4',
                       2, 'Q1',
                       3, 'Q2',
                       4, 'Q3');


DROP PUBLIC SYNONYM KPI3_DEFECTS_DETAILS;

CREATE OR REPLACE PUBLIC SYNONYM KPI3_DEFECTS_DETAILS FOR KPI3_DEFECTS_DETAILS;

DROP VIEW KPI3_DEFECTS_MORE_SP;

/* Formatted on 11-Mar-2011 10:48:03 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI3_DEFECTS_MORE_SP
(
   USER_ADMIN_NAME,
   FYRQTR,
   DEFECT_ID,
   ROAD_NO,
   DEF_CREATED_DATE,
   DEF_PRIORITY,
   DEF_COMPLETED_DATE,
   DEF_STATUS,
   DEF_CODE,
   DEF_ACTIVITY_CODE,
   DEF_WO_NOS
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (def_created_date, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (def_created_date, -12), 'RR')
             ELSE
                TO_CHAR (def_created_date, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (def_created_date, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fy_st_date,
          def_defect_id,
          rse_unique,
          def_created_date,
          def_priority,
          def_date_compl,
          def_status_code,
          def_defect_code,
          def_atv_acty_area_code,
          def_works_order_no
     FROM road_sections_all,
          kpi_child_au_sp,
          defects,
          hig_admin_units
    WHERE     def_priority = 1
          AND rse_admin_unit = child_admin_unit
          AND def_rse_he_id = rse_he_id
          AND hau_admin_unit = child_admin_unit
          AND def_created_date BETWEEN (SELECT CASE
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JAN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'FEB'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'APR'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'MAY'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUN'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'JUL'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'AUG'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'SEP'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'OCT'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -12),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'NOV'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -13),
                                                        'DD-MON-RRRR')
                                                  WHEN TO_CHAR (SYSDATE,
                                                                'MON') =
                                                          'DEC'
                                                  THEN
                                                     TO_CHAR (
                                                        ADD_MONTHS (
                                                           '01-'
                                                           || TO_CHAR (
                                                                 SYSDATE,
                                                                 'MON-YYYY'),
                                                           -14),
                                                        'DD-MON-RRRR')
                                                  ELSE
                                                     'sysdate'
                                               END
                                          FROM DUAL)
                                   AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI3_DEFECTS_MORE_SP;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI3_DEFECTS_MORE_SP FOR KPI3_DEFECTS_MORE_SP;


DROP PUBLIC SYNONYM KPI3_DEFECTS_MORE_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI3_DEFECTS_MORE_SP FOR KPI3_DEFECTS_MORE_SP;

DROP VIEW KPI4_CAT1_REPAIRS;

/* Formatted on 11-Mar-2011 10:48:08 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI4_CAT1_REPAIRS
(
   DEF_PRIORITY,
   DEF_ATV_ACTY_AREA_CODE,
   ACTY_CODE,
   DEF_RSE_HE_ID,
   RSE_UNIQUE,
   REP_DEF_DEFECT_ID,
   REP_DUE,
   REP_DATE_COMPLETED,
   REP_ACTION_CAT,
   RSE_ADMIN_UNIT,
   DEF_STATUS_CODE,
   HAU_NAME,
   USER_ADMIN_NAME,
   YR_QTR,
   FYR_QTR,
   ON_TIME,
   NOT_ON_TIME
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT d.PRIORITY,
          d.activity_code,
          CASE
             WHEN d.activity_code IN
                     ('MC',
                      'CM',
                      'FC',
                      'CG',
                      'KC',
                      'PD',
                      'GC',
                      'PG',
                      'GP',
                      'DI',
                      'FD',
                      'CV',
                      'AI',
                      'FL',
                      'RS',
                      'RM',
                      'SG',
                      'TS',
                      'LP',
                      'RC',
                      'SR',
                      'SM',
                      'SE',
                      'SV')
             THEN
                'CARRIAGEWAY DRAINAGE SIGNS and FOOTWAYS'
             WHEN d.activity_code IN ('BF', 'FB', 'BF', 'BT', 'FF', 'FN')
             THEN
                'FENCES AND BARRIERS'
             WHEN d.activity_code IN ('HT', 'HX', 'HN')
             THEN
                'HEDGES and TREES'
             WHEN d.activity_code IN ('EC', 'GA')
             THEN
                'GRASSED AREAS'
             ELSE
                'OTHER'
          END
             acty_code,
          d.network_element_id,
          network_element_reference,
          r.defect_id,
          r.date_due,
          TRUNC (r.date_completed),
          r.repair_category,
          n.admin_unit_id,
          d.defect_status,
          h.admin_unit_name,
          user_admin_name,
          TO_CHAR (r.date_due, 'RR') || ' '
          || DECODE (TO_CHAR (r.date_due, 'Q'),
                     1, 'Q1',
                     2, 'Q2',
                     3, 'Q3',
                     4, 'Q4')
             yr_qtr,
          CASE
             WHEN TO_CHAR (r.date_due, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (r.date_due, -12), 'RR')
             ELSE
                TO_CHAR (r.date_due, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (r.date_due, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fyr_qtr,
          CASE
             WHEN r.date_due <
                       TRUNC (r.date_completed)
                     + (NVL (r.TIME_COMPLETED_HOURS, 0) / 24)
                     + (NVL (r.TIME_COMPLETED_MINS, 0) / 1440)
             THEN
                '0'
             ELSE
                '1'
          END
             on_time,
          CASE
             WHEN r.date_due >=
                       TRUNC (r.date_completed)
                     + (NVL (r.TIME_COMPLETED_HOURS, 0) / 24)
                     + (NVL (r.TIME_COMPLETED_MINS, 0) / 1440)
             THEN
                '0'
             ELSE
                '1'
          END
             not_on_time
     FROM imf_mai_defects d,
          imf_mai_repairs r,
          imf_net_maint_sections_all n,
          kpi_child_au,
          imf_hig_admin_units h
    WHERE     d.PRIORITY = '1'
          AND r.date_completed IS NOT NULL
          AND d.defect_id = r.defect_id(+)
          AND d.defect_status = 'COMPLETED'
          AND r.repair_category = 'P'
          AND n.network_element_id = d.network_element_id
          AND n.admin_unit_id = child_admin_unit
          AND r.date_due >= '01-JAN-2005'
          AND r.date_due < ADD_MONTHS (SYSDATE, 12)
          AND child_admin_unit = h.admin_unit_id
          AND NVL (r.date_due, SYSDATE) BETWEEN (SELECT CASE
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'JAN'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -12),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'FEB'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -13),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'MAR'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -14),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'APR'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -12),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'MAY'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -13),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'JUN'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -14),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'JUL'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -12),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'AUG'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -13),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'SEP'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -14),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'OCT'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -12),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'NOV'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -13),
                                                                 'DD-MON-RRRR')
                                                           WHEN TO_CHAR (
                                                                   SYSDATE,
                                                                   'MON') =
                                                                   'DEC'
                                                           THEN
                                                              TO_CHAR (
                                                                 ADD_MONTHS (
                                                                    '01-'
                                                                    || TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON-YYYY'),
                                                                    -14),
                                                                 'DD-MON-RRRR')
                                                           ELSE
                                                              'sysdate'
                                                        END
                                                   FROM DUAL)
                                            AND (SELECT SYSDATE FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI4_CAT1_REPAIRS;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI4_CAT1_REPAIRS FOR KPI4_CAT1_REPAIRS;


DROP PUBLIC SYNONYM KPI4_CAT1_REPAIRS;

CREATE OR REPLACE PUBLIC SYNONYM KPI4_CAT1_REPAIRS FOR KPI4_CAT1_REPAIRS;

DROP VIEW KPI4_CAT1_REPAIRS__090928;

/* Formatted on 11-Mar-2011 10:48:14 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI4_CAT1_REPAIRS__090928
(
   DEF_PRIORITY,
   DEF_ATV_ACTY_AREA_CODE,
   ACTY_CODE,
   DEF_RSE_HE_ID,
   RSE_UNIQUE,
   REP_DEF_DEFECT_ID,
   REP_DUE,
   REP_DATE_COMPLETED,
   REP_ACTION_CAT,
   RSE_ADMIN_UNIT,
   DEF_STATUS_CODE,
   HAU_NAME,
   USER_ADMIN_NAME,
   YR_QTR,
   FYR_QTR,
   ON_TIME,
   NOT_ON_TIME
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT d.defect_priority,
          d.activity_code,
          CASE
             WHEN d.activity_code IN
                     ('MC',
                      'CM',
                      'FC',
                      'CG',
                      'KC',
                      'PD',
                      'GC',
                      'PG',
                      'GP',
                      'DI',
                      'FD',
                      'CV',
                      'AI',
                      'FL',
                      'RS',
                      'RM',
                      'SG',
                      'TS',
                      'LP',
                      'RC',
                      'SR',
                      'SM',
                      'SE',
                      'SV')
             THEN
                'CARRIAGEWAY DRAINAGE SIGNS and FOOTWAYS'
             WHEN d.activity_code IN ('BF', 'FB', 'BF', 'BT', 'FF', 'FN')
             THEN
                'FENCES AND BARRIERS'
             WHEN d.activity_code IN ('HT', 'HX', 'HN')
             THEN
                'HEDGES and TREES'
             WHEN d.activity_code IN ('EC', 'GA')
             THEN
                'GRASSED AREAS'
             ELSE
                'OTHER'
          END
             acty_code,
          d.network_element_id,
          network_element_reference,
          r.defect_id,
          r.date_repair_due,
          TRUNC (r.date_repair_completed),
          r.repair_category,
          n.admin_unit_id,
          d.defect_status,
          h.admin_unit_name,
          user_admin_name,
          TO_CHAR (r.date_repair_due, 'RR') || ' '
          || DECODE (TO_CHAR (r.date_repair_due, 'Q'),
                     1, 'Q1',
                     2, 'Q2',
                     3, 'Q3',
                     4, 'Q4')
             yr_qtr,
          CASE
             WHEN TO_CHAR (r.date_repair_due, 'Q') = 1
             THEN
                TO_CHAR (ADD_MONTHS (r.date_repair_due, -12), 'RR')
             ELSE
                TO_CHAR (r.date_repair_due, 'RR')
          END
          || ' '
          || DECODE (TO_CHAR (r.date_repair_due, 'Q'),
                     1, 'Q4',
                     2, 'Q1',
                     3, 'Q2',
                     4, 'Q3')
             fyr_qtr,
          CASE
             WHEN r.date_repair_due <
                       TRUNC (r.date_repair_completed)
                     + r.time_repair_completed_hours / 24
                     + r.time_repair_completed_mins / 1440
             THEN
                '0'
             ELSE
                '1'
          END
             on_time,
          CASE
             WHEN r.date_repair_due >=
                       TRUNC (r.date_repair_completed)
                     + r.time_repair_completed_hours / 24
                     + r.time_repair_completed_mins / 1440
             THEN
                '0'
             ELSE
                '1'
          END
             not_on_time
     FROM imf_mai_defects d,
          imf_mai_repairs r,
          imf_net_maint_sections_all n,
          kpi_child_au,
          imf_hig_admin_units h
    WHERE     d.defect_priority = 1
          AND r.date_repair_completed IS NOT NULL
          AND d.defect_id = r.defect_id(+)
          AND d.defect_status = 'COMPLETED'
          AND r.repair_category = 'P'
          AND n.network_element_id = d.network_element_id
          AND n.admin_unit_id = child_admin_unit
          AND r.date_repair_due >= '01-JAN-2005'
          AND r.date_repair_due < ADD_MONTHS (SYSDATE, 12)
          AND child_admin_unit = h.admin_unit_id
          AND NVL (r.date_repair_due, SYSDATE) BETWEEN (SELECT CASE
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'JAN'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -12),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'FEB'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -13),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'MAR'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -14),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'APR'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -12),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'MAY'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -13),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'JUN'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -14),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'JUL'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -12),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'AUG'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -13),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'SEP'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -14),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'OCT'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -12),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'NOV'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -13),
                                                                        'DD-MON-RRRR')
                                                                  WHEN TO_CHAR (
                                                                          SYSDATE,
                                                                          'MON') =
                                                                          'DEC'
                                                                  THEN
                                                                     TO_CHAR (
                                                                        ADD_MONTHS (
                                                                           '01-'
                                                                           || TO_CHAR (
                                                                                 SYSDATE,
                                                                                 'MON-YYYY'),
                                                                           -14),
                                                                        'DD-MON-RRRR')
                                                                  ELSE
                                                                     'sysdate'
                                                               END
                                                          FROM DUAL)
                                                   AND (SELECT SYSDATE
                                                          FROM DUAL);


DROP PUBLIC SYNONYM KPI4_CAT1_REPAIRS__090928;

CREATE OR REPLACE PUBLIC SYNONYM KPI4_CAT1_REPAIRS__090928 FOR KPI4_CAT1_REPAIRS__090928;

DROP VIEW KPI7_CLAIM_WAG;

/* Formatted on 11-Mar-2011 10:48:19 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI7_CLAIM_WAG
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   "count",
   DOC_DATE_ISSUED,
   DOC_ID,
   DOC_DTP_CODE,
   DOC_DCL_CODE
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (correspondence_received, date_recorded), 'Q') =
                     1
             THEN
                TO_CHAR (
                   ADD_MONTHS (NVL (correspondence_received, date_recorded),
                               -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (correspondence_received, date_recorded), 'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (correspondence_received, date_recorded), 'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          h.admin_unit_name,
          h.admin_unit_id,
          '1' AS "count",
          date_recorded,
          enquiry_id,
          category_code,
          class_code
     FROM imf_enq_enquiries e, imf_hig_admin_units h, kpi_child_au
    --WHERE category_code = 'CLAM'
    WHERE     enquiry_type_code = 'CLAM'
          AND (class_code = 'WOLF' OR class_code = 'FRML')
          AND e.admin_unit_id = h.admin_unit_id
          AND child_admin_unit = h.admin_unit_id
          AND NVL (correspondence_received, date_recorded) BETWEEN (SELECT CASE
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'JAN'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -12),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'FEB'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -13),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'MAR'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -14),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'APR'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -12),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'MAY'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -13),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'JUN'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -14),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'JUL'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -12),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'AUG'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -13),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'SEP'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -14),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'OCT'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -12),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'NOV'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -13),
                                                                                    'DD-MON-RRRR')
                                                                              WHEN TO_CHAR (
                                                                                      SYSDATE,
                                                                                      'MON') =
                                                                                      'DEC'
                                                                              THEN
                                                                                 TO_CHAR (
                                                                                    ADD_MONTHS (
                                                                                       '01-'
                                                                                       || TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON-YYYY'),
                                                                                       -14),
                                                                                    'DD-MON-RRRR')
                                                                              ELSE
                                                                                 'sysdate'
                                                                           END
                                                                      FROM DUAL)
                                                               AND (SELECT SYSDATE
                                                                      FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI7_CLAIM_WAG;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI7_CLAIM_WAG FOR KPI7_CLAIM_WAG;


DROP PUBLIC SYNONYM KPI7_CLAIM_WAG;

CREATE OR REPLACE PUBLIC SYNONYM KPI7_CLAIM_WAG FOR KPI7_CLAIM_WAG;

DROP VIEW KPI7_CLAIM_WAG_SP;

/* Formatted on 11-Mar-2011 10:48:23 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI7_CLAIM_WAG_SP
(
   USER_ADMIN_NAME,
   FY_ST_DATE,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   "count",
   DOC_DATE_ISSUED,
   DOC_ID,
   DOC_DTP_CODE,
   DOC_DCL_CODE
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT user_admin_name,
          CASE
             WHEN TO_CHAR (
                     NVL (doc_compl_corresp_deliv_date, doc_date_issued),
                     'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (
                      NVL (doc_compl_corresp_deliv_date, doc_date_issued),
                      -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (doc_compl_corresp_deliv_date, doc_date_issued),
                         'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (doc_compl_corresp_deliv_date, doc_date_issued),
                         'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          hau_name,
          hau_admin_unit,
          '1' AS "count",
          doc_date_issued,
          doc_id,
          doc_dtp_code,
          doc_dcl_code
     FROM docs2view, hig_admin_units, kpi_child_au_sp
    WHERE     doc_dtp_code = 'CLAM'
          AND (doc_dcl_code = 'WOLF' OR doc_dcl_code = 'FRML')
          AND doc_admin_unit = hau_admin_unit
          AND child_admin_unit = hau_admin_unit
          AND NVL (doc_compl_corresp_deliv_date, doc_date_issued) BETWEEN (SELECT CASE
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'JAN'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -12),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'FEB'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -13),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'MAR'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -14),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'APR'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -12),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'MAY'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -13),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'JUN'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -14),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'JUL'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -12),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'AUG'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -13),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'SEP'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -14),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'OCT'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -12),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'NOV'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -13),
                                                                                           'DD-MON-RRRR')
                                                                                     WHEN TO_CHAR (
                                                                                             SYSDATE,
                                                                                             'MON') =
                                                                                             'DEC'
                                                                                     THEN
                                                                                        TO_CHAR (
                                                                                           ADD_MONTHS (
                                                                                              '01-'
                                                                                              || TO_CHAR (
                                                                                                    SYSDATE,
                                                                                                    'MON-YYYY'),
                                                                                              -14),
                                                                                           'DD-MON-RRRR')
                                                                                     ELSE
                                                                                        'sysdate'
                                                                                  END
                                                                             FROM DUAL)
                                                                      AND (SELECT SYSDATE
                                                                             FROM DUAL)
-- and doc_id = 1880;
;


DROP SYNONYM HIGHWAYS.KPI7_CLAIM_WAG_SP;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI7_CLAIM_WAG_SP FOR KPI7_CLAIM_WAG_SP;


DROP PUBLIC SYNONYM KPI7_CLAIM_WAG_SP;

CREATE OR REPLACE PUBLIC SYNONYM KPI7_CLAIM_WAG_SP FOR KPI7_CLAIM_WAG_SP;

DROP VIEW KPI8_PRE_SALTING;

/* Formatted on 11-Mar-2011 10:48:28 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW KPI8_PRE_SALTING
(
   DOC_ID,
   HAU_NAME,
   HAU_ADMIN_UNIT,
   HAU_UNIT_CODE,
   HAU_LEVEL,
   USER_ADMIN_LEVEL,
   USER_ADMIN_UNIT,
   USER_ADMIN_CODE,
   USER_ADMIN_NAME,
   FY_ST_DATE,
   QR_ST_DATE,
   DOC_CODE,
   DOC_CL,
   DOC_TYPE,
   DOC_SOURCE,
   NOS_SALTS,
   COMPLETION_DATE,
   INCIDENT_DATE,
   ISSUED_DATE,
   MIN_TO_COMP,
   INSIDE_FLAG,
   OUTSIDE_FLAG
)
AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/kpi_views/wag_kpi_views.sql-arc   1.0   Mar 11 2011 11:32:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   wag_kpi_views.sql  $
--       Date into PVCS   : $Date:   Mar 11 2011 11:32:46  $
--       Date fetched Out : $Modtime:   Mar 11 2011 11:28:36  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
   SELECT e.enquiry_id,
          h.admin_unit_name,
          h.admin_unit_id,
          h.admin_unit_code,
          h.admin_unit_level,
          user_admin_level,
          user_admin_unit,
          user_admin_code,
          user_admin_name,
          CASE
             WHEN TO_CHAR (NVL (e.correspondence_received, e.date_recorded),
                           'Q') = 1
             THEN
                TO_CHAR (
                   ADD_MONTHS (
                      NVL (e.correspondence_received, e.date_recorded),
                      -12),
                   'RR')
             ELSE
                TO_CHAR (NVL (e.correspondence_received, e.date_recorded),
                         'RR')
          END
          || ' '
          || DECODE (
                TO_CHAR (NVL (e.correspondence_received, e.date_recorded),
                         'Q'),
                1, 'Q4',
                2, 'Q1',
                3, 'Q2',
                4, 'Q3')
             fy_st_date,
          TO_CHAR (NVL (e.correspondence_received, e.date_recorded), 'RR')
          || ' '
          || DECODE (
                TO_CHAR (NVL (e.correspondence_received, e.date_recorded),
                         'Q'),
                1, 'Q1',
                2, 'Q2',
                3, 'Q3',
                4, 'Q4')
             qr_st_date,
          e.enquiry_type_code,
          e.class_code,
          e.category_code,
          e.source_code,
          1 nos_salts,
          e.complete_date completion_date,
          e.incident_date incident_date,
          e.date_recorded issued_date,
          ROUND (
             TO_NUMBER (
                NVL (e.complete_date, SYSDATE)
                - NVL (e.incident_date, e.date_recorded))
             * 1440)
             AS "MIN_TO_COMP",
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (e.complete_date, SYSDATE)
                         - NVL (e.incident_date, e.date_recorded))
                      * 1440)) <= '120'
             THEN
                1
             ELSE
                0
          END
             inside_flag,
          CASE
             WHEN (ROUND (
                      TO_NUMBER (
                         NVL (e.complete_date, SYSDATE)
                         - NVL (e.incident_date, e.date_recorded))
                      * 1440)) > '120'
             THEN
                1
             ELSE
                0
          END
             outside_flag
     FROM imf_enq_enquiries e, imf_hig_admin_units h, kpi_child_au c
    WHERE     e.enquiry_type_code = 'WINT'
          AND e.class_code = 'INST'
          AND e.category_code = 'PS'
          AND e.admin_unit_id = h.admin_unit_id
          AND e.admin_unit_id = c.child_admin_unit
          AND NVL (e.correspondence_received, e.date_recorded) BETWEEN (SELECT CASE
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'JAN'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -12),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'FEB'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -13),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'MAR'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -14),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'APR'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -12),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'MAY'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -13),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'JUN'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -14),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'JUL'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -12),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'AUG'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -13),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'SEP'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -14),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'OCT'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -12),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'NOV'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -13),
                                                                                        'DD-MON-RRRR')
                                                                                  WHEN TO_CHAR (
                                                                                          SYSDATE,
                                                                                          'MON') =
                                                                                          'DEC'
                                                                                  THEN
                                                                                     TO_CHAR (
                                                                                        ADD_MONTHS (
                                                                                           '01-'
                                                                                           || TO_CHAR (
                                                                                                 SYSDATE,
                                                                                                 'MON-YYYY'),
                                                                                           -14),
                                                                                        'DD-MON-RRRR')
                                                                                  ELSE
                                                                                     'sysdate'
                                                                               END
                                                                          FROM DUAL)
                                                                   AND (SELECT SYSDATE
                                                                          FROM DUAL);


DROP SYNONYM HIGHWAYS.KPI8_PRE_SALTING;

CREATE OR REPLACE SYNONYM HIGHWAYS.KPI8_PRE_SALTING FOR KPI8_PRE_SALTING;


DROP PUBLIC SYNONYM KPI8_PRE_SALTING;

CREATE OR REPLACE PUBLIC SYNONYM KPI8_PRE_SALTING FOR KPI8_PRE_SALTING;

