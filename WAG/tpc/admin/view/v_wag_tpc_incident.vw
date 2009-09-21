CREATE OR REPLACE FORCE VIEW v_wag_tpc_incident (
   doc_id,
   doc_dtp_code,
   doc_dcl_code,
   doc_compl_type,
   doc_compl_incident_date,
   doc_compl_location,
   doc_status_code,
   wag_tpc_authorise,
   wag_tpc_sent_tpc
   )
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/view/v_wag_tpc_incident.vw-arc   3.0   Sep 21 2009 16:13:10   smarshall  $
--       Module Name      : $Workfile:   v_wag_tpc_incident.vw  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:13:10  $
--       Date fetched Out : $Modtime:   Sep 21 2009 14:50:20  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
   SELECT doc_id,
         doc_dtp_code,
         doc_dcl_code,
         doc_compl_type,
         doc_compl_incident_date,
         doc_compl_location,
         doc_status_code,
         wag_tpc_authorise,
         wag_tpc_sent_tpc
   FROM docs, wag_tpc_incident
   WHERE doc_id = wag_tpc_incident_id(+)
/