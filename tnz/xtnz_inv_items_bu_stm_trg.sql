CREATE OR REPLACE TRIGGER xtnz_inv_items_bu_stm_trg
   BEFORE UPDATE
    ON    nm_inv_items_all
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_inv_items_bu_stm_trg.sql	1.1 03/15/05
--       Module Name      : xtnz_inv_items_bu_stm_trg.sql
--       Date into SCCS   : 05/03/15 03:46:00
--       Date fetched Out : 07/06/06 14:40:22
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TNZ TRID trigger to sent event emails on update of the event
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
BEGIN
--
   xtnz_trid.clear_update_mail_list;
--
END xtnz_inv_items_bu_stm_trg;
/

