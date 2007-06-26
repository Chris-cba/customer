CREATE OR REPLACE TRIGGER xval_valuation_columns_b_iu
   BEFORE INSERT OR UPDATE
    ON    xval_valuation_columns
    FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_valuation_columns_b_iu.trg	1.1 03/14/05
--       Module Name      : xval_valuation_columns_b_iu.trg
--       Date into SCCS   : 05/03/14 23:11:31
--       Date fetched Out : 07/06/06 14:33:59
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Valuations table trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
BEGIN
--
   IF   INSERTING
    OR (UPDATING AND :OLD.xvc_nit_inv_type != :NEW.xvc_nit_inv_type)
    THEN
      -- Check to ensure the ITG record exists
      DECLARE
         l_rec_itg nm_inv_type_groupings%ROWTYPE;
      BEGIN
         l_rec_itg := nm3get.get_itg (pi_itg_inv_type        => xval_find_inv.get_val_inv_type
                                     ,pi_itg_parent_inv_type => :NEW.xvc_nit_inv_type
                                     );
      END;
   END IF;
--
   xval_reval.check_xvc_ita_view_col_name (p_xvc_ita_view_col_name => :NEW.xvc_ita_view_col_name
                                          ,p_xvc_sum_for_report    => :NEW.xvc_sum_for_report
                                          );
--
END xval_valuation_columns_b_iu;
/

