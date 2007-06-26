CREATE OR REPLACE TRIGGER xmrwa_695596_create_das_b_stm
   BEFORE INSERT OR DELETE
    ON    doc_assocs
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_695596_create_das_b_stm.trg	1.1 03/15/05
--       Module Name      : xmrwa_695596_create_das_b_stm.trg
--       Date into SCCS   : 05/03/15 00:45:17
--       Date fetched Out : 07/06/06 14:38:06
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA DOCUMENT_GATEWAYS workaround trigger for v3.0.8.1
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
BEGIN
--
   xmrwa_695596_das_3081.clear_globals;
--
END xmrwa_695596_create_das_b_stm;
/
