CREATE OR REPLACE TRIGGER XBC_NE_B_I_STM_TRG 
   BEFORE INSERT
   ON nm_elements_all
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/bc/admin/trg/xbc_ne_b_i_stm_trg.trg-arc   1.1   Jun 01 2012 12:41:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   xbc_ne_b_i_stm_trg.trg  $
--       Date into PVCS   : $Date:   Jun 01 2012 12:41:26  $
--       Date fetched Out : $Modtime:   Mar 26 2009 08:40:50  $
--       PVCS Version     : $Revision:   1.1  $
--
BEGIN
   xbc_create_securing_inv.clear_globals;
END xbc_ne_b_i_stm_trg;
/


