CREATE OR REPLACE FORCE VIEW X_OLDHAM_PEM_WORK_ORDER
(
   PEM_ID,
   PEM_ISSUED_DATE,
   PEM_COMPLETE_DATE,
   PEM_LAST_REDIRECT_DATE,
   PEM_CLASS,
   PEM_CODE,
   PEM_TYPE,
   PEM_LOCATION,
   PEM_DESCRIPTION,
   PEM_ACTION,
   REASON,
   RESPONSIBILITY_OF,
   EASTING,
   NORTHING,
   PEM_SOURCE,
   DEFECT_ID,
   WORK_ORDER_NO,
   WORK_ORDER_CREATED
)
AS
   SELECT -------------------------------------------------------------------------
                                                      --   PVCS Identifiers :-
                                                                            --
 --       PVCS id          : $Header:   //vm_latest/archives/customer/oldham/x_oldham_pem_work_order.vw-arc   1.2   Nov 05 2010 11:02:20   Ian.Turnbull  $
        --       Module Name      : $Workfile:   x_oldham_pem_work_order.vw  $
                  --       Date into PVCS   : $Date:   Nov 05 2010 11:02:20  $
               --       Date fetched Out : $Modtime:   Nov 05 2010 10:48:30  $
                               --       Version          : $Revision:   1.2  $
                                 -- Foundation view displaying enquiry network
     -------------------------------------------------------------------------
          d.doc_id PEM_ID,
          d.doc_date_issued pem_issued_date,
          d.doc_compl_complete pem_complete_date,
          max_re_date pem_last_redirect_date,
          d.doc_dcl_code pem_class,
          d.doc_dtp_code pem_code,
          d.doc_compl_type pem_type,
          d.doc_compl_location pem_location,
          d.doc_descr pem_description,
          d.doc_compl_action pem_action,
          d.doc_reason reason,
          hus_name responsibility_of,
          d.doc_compl_east Easting,
          d.doc_compl_north Northing,
          d.doc_compl_source pem_source,
          das_rec_id,
          wl.wol_works_order_no Work_order_no,
          wl.wol_date_created work_order_created
     FROM docs d,
          (SELECT das_doc_id, das_rec_id
             FROM doc_assocs
            WHERE das_table_name = 'DEFECTS') dc,
          (  SELECT dhi_doc_id, MAX (dhi_date_changed) max_re_date
               FROM doc_history
              WHERE dhi_status_code = 'RE'
           GROUP BY dhi_doc_id) doc_history_re,
          work_order_lines wl,
          hig_users
    WHERE     1 = 1
          --       and doc_id in(5002,5003)
          AND d.doc_id = dc.das_doc_id(+)
          AND d.doc_id = dhi_doc_id(+)
          AND dc.das_rec_id = wl.wol_def_defect_id(+)
          AND d.doc_compl_user_id = hus_user_id(+);