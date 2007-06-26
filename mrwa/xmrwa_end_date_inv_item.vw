CREATE OR REPLACE VIEW xmrwa_end_date_inv_item AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_end_date_inv_item.vw	1.1 03/15/05
--       Module Name      : xmrwa_end_date_inv_item.vw
--       Date into SCCS   : 05/03/15 00:45:32
--       Date fetched Out : 07/06/06 14:38:17
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
       iit_ne_id
      ,iit_primary_key
      ,iit_inv_type
      ,iit_end_date
      ,iit_note
 FROM  nm_inv_items_all
WHERE  1=2
/
