CREATE OR REPLACE FORCE VIEW X_OLDHAM_PEM_WORK_ORDER
(
   PEM_ID,
   PEM_ISSUED_DATE,
   PEM_COMPLETE_DATE,
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
 --       PVCS id          : $Header:   //vm_latest/archives/customer/oldham/x_oldham_pem_work_order.vw-arc   1.1   Nov 03 2010 15:50:42   Ian.Turnbull  $
        --       Module Name      : $Workfile:   x_oldham_pem_work_order.vw  $
                  --       Date into PVCS   : $Date:   Nov 03 2010 15:50:42  $
               --       Date fetched Out : $Modtime:   Nov 03 2010 15:02:06  $
                               --       Version          : $Revision:   1.1  $
                                 -- Foundation view displaying enquiry network
     -------------------------------------------------------------------------
          d.doc_id PEM_ID,
          d.doc_date_issued pem_issued_date,
          d.doc_compl_complete pem_complete_date,
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
          wl.wol_def_defect_id Defect_id,
          wl.wol_works_order_no Work_order_no,
          wl.wol_date_created work_order_created
     FROM docs d, doc_assocs dc, work_order_lines wl
     ,hig_users
    WHERE     dc.das_doc_id = d.doc_id
          AND dc.das_rec_id = wl.wol_def_defect_id(+)
          AND dc.das_table_name = 'DEFECTS'
          and d.doc_compl_user_id =hus_user_id(+);