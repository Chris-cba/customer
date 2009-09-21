CREATE OR REPLACE function wag_tpc_get_hsc_code (p_domain IN varchar2, p_code IN varchar2)
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/admin/sql/wag_tpc_get_hsc_code.fnc-arc   3.0   Sep 21 2009 16:15:02   smarshall  $
--       Module Name      : $Workfile:   wag_tpc_get_hsc_code.fnc  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:15:02  $
--       Date fetched Out : $Modtime:   Sep 21 2009 16:14:30  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
      RETURN varchar2 IS
   l_retval varchar2(255);
BEGIN
   select hco_meaning
   into   l_retval
   from   hig_codes
   where  hco_domain = p_domain
   and    hco_code = p_code;

   RETURN l_retval;

END wag_tpc_get_hsc_code;
/