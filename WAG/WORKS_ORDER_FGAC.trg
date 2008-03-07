CREATE OR REPLACE TRIGGER WORKS_ORDER_FGAC
--   PVCS Identifiers :-
--
--       pccsid           : $Header:   //vm_latest/archives/customer/WAG/WORKS_ORDER_FGAC.trg-arc   2.0   Mar 07 2008 15:31:50   smarshall  $
--       Module Name      : $Workfile:   WORKS_ORDER_FGAC.trg  $
--       Date into PCCS   : $Date:   Mar 07 2008 15:31:50  $
--       Date fetched Out : $Modtime:   Mar 07 2008 15:28:18  $
--       SCCS Version     : $Revision:   2.0  $
BEFORE INSERT
ON WORK_ORDERS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN

/*   
   --
   -- Get Agency Context
   -- Only set the Agency code if User inserting does not have top level access
   --
   IF mai.GET_ICB_FGAC_CONTEXT(FALSE) != mai.GET_ICB_FGAC_CONTEXT(TRUE) THEN
     --
     :new.wor_agency := mai.GET_ICB_FGAC_CONTEXT(FALSE);
     --
   END IF;
   --
   EXCEPTION
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
*/
   :new.wor_agency := mai.get_context('ICB_WAG','AGENCY');
  

END Works_order_FGAC;
/


