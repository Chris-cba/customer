CREATE OR REPLACE TRIGGER xexor_derived_inv_b_iu_stm
   BEFORE INSERT OR UPDATE
    ON    nm_inv_items_all
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_derived_inv_b_iu_stm.trg	1.1 03/15/05
--       Module Name      : xexor_derived_inv_b_iu_stm.trg
--       Date into SCCS   : 05/03/15 22:46:51
--       Date fetched Out : 07/06/06 14:36:39
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Derived Inventory supporting trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
   xexor_derived_inv.clear_arrays;
END xexor_derived_inv_b_iu_stm;
/
