CREATE OR REPLACE TRIGGER xmrwa_acc_policing_after_stm
   AFTER  INSERT
    ON    ACC_ITEMS_ALL_ALL
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_acc_policing_after_stm.trg	1.1 03/15/05
--       Module Name      : xmrwa_acc_policing_after_stm.trg
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
   xmrwa_acc_policing.process_globals;
--
END xmrwa_acc_policing_after_stm;
/
