CREATE OR REPLACE TRIGGER XBC_NE_A_I_STM_TRG
   AFTER INSERT
   ON NM_ELEMENTS_ALL
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/bc/admin/trg/xbc_ne_a_i_stm_trg.trg-arc   1.0   Mar 26 2009 09:41:30   smarshall  $
--       Module Name      : $Workfile:   xbc_ne_a_i_stm_trg.trg  $
--       Date into PVCS   : $Date:   Mar 26 2009 09:41:30  $
--       Date fetched Out : $Modtime:   Mar 26 2009 09:40:50  $
--       PVCS Version     : $Revision:   1.0  $

BEGIN
   xbc_create_securing_inv.process_globals;
END xbc_ne_a_i_stm_trg;
/


