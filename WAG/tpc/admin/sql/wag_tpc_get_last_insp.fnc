CREATE OR REPLACE FUNCTION WAG_TPC_GET_LAST_INSP(pi_ne_id nm_elements_all.ne_id%type)
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/sql/wag_tpc_get_last_insp.fnc-arc   3.0   Sep 21 2009 16:15:04   smarshall  $
--       Module Name      : $Workfile:   wag_tpc_get_last_insp.fnc  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:15:04  $
--       Date fetched Out : $Modtime:   Sep 21 2009 16:14:32  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
RETURN VARCHAR2 AS
rtrn VARCHAR2(30);   
BEGIN
  select max(are_date_work_done) 
  into rtrn 
  from activities_report
  where are_rse_he_id = pi_ne_id
   and are_maint_insp_flag = 'D';
  
  RETURN rtrn;
END WAG_TPC_GET_LAST_INSP;
/