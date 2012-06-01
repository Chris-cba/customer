CREATE OR REPLACE TRIGGER XBC_NE_B_I_ROW_TRG
before INSERT
ON NM_ELEMENTS_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
WHEN (
NEW.NE_TYPE = 'S'
      )
DECLARE
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/bc/admin/trg/xbc_ne_b_i_row_trg.trg-arc   1.1   Jun 01 2012 12:41:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   xbc_ne_b_i_row_trg.trg  $
--       Date into PVCS   : $Date:   Jun 01 2012 12:41:22  $
--       Date fetched Out : $Modtime:   Mar 26 2009 08:40:50  $
--       PVCS Version     : $Revision:   1.1  $

--
BEGIN
   xbc_create_securing_inv.append_to_globals (p_ne_id         => :NEW.ne_id
                                               ,p_ne_nt_type    => :NEW.ne_nt_type
                                               );
END xbc_ne_b_i_row_trg;
/


