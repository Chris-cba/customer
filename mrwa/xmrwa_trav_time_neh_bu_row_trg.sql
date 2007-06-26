CREATE OR REPLACE TRIGGER xmrwa_trav_time_neh_bu_row_trg
   BEFORE INSERT OR UPDATE
    ON    nm_element_history
   FOR    EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_trav_time_neh_bu_row_trg.sql	1.1 03/15/05
--       Module Name      : xmrwa_trav_time_neh_bu_row_trg.sql
--       Date into SCCS   : 05/03/15 00:46:30
--       Date fetched Out : 07/06/06 14:38:33
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA trigger to send emails on update of a travel time route
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
BEGIN
--
   xmrwa_travel_time.fire_nw_op_email
                           (p_ne_id_old => :NEW.neh_ne_id_old
                           ,p_ne_id_new => :NEW.neh_ne_id_new
                           ,p_operation => :NEW.neh_operation
                           ,p_eff_date  => :NEW.neh_effective_date
                           );
--
END xmrwa_trav_time_neh_bu_row_trg;
/
