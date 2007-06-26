CREATE OR REPLACE TRIGGER xmrwa_acc_policing_before_row
   BEFORE INSERT OR UPDATE
    ON    ACC_ITEMS_ALL_ALL
    FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_acc_policing_before_row.trg	1.1 03/15/05
--       Module Name      : xmrwa_acc_policing_before_row.trg
--       Date into SCCS   : 05/03/15 00:45:23
--       Date fetched Out : 07/06/06 14:38:11
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA Accident Policing trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
BEGIN
--
   xmrwa_acc_policing.append_to_globals
                            (p_acc_id         => :NEW.acc_id
                            ,p_acc_parent_id  => :NEW.acc_parent_id
                            ,p_acc_top_id     => :NEW.acc_top_id
                            ,p_acc_ait_id     => :NEW.acc_ait_id
                            );
--
END xmrwa_acc_policing_before_row;
/
