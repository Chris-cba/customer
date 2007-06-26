CREATE OR REPLACE TRIGGER xact_cleanaway_dac_bi_row
   BEFORE INSERT
    ON    DOC_ACTIONS
   FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_cleanaway_dac_bi_row.trg	1.1 03/14/05
--       Module Name      : xact_cleanaway_dac_bi_row.trg
--       Date into SCCS   : 05/03/14 23:10:52
--       Date fetched Out : 07/06/06 14:33:42
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT Cleanaway Mail trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
   xact_cleanaway_mail.append_dac (:NEW.dac_id);
END xact_cleanaway_dac_bi_row;
/
