CREATE OR REPLACE VIEW xmrwa_modify_inv_item_location AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_modify_inv_item_location.vw	1.1 03/15/05
--       Module Name      : xmrwa_modify_inv_item_location.vw
--       Date into SCCS   : 05/03/15 00:45:56
--       Date fetched Out : 07/06/06 14:38:23
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
       iit_primary_key
      ,loc.*
 FROM  nm_inv_items_all  iit
      ,mrwa_load_inv_loc loc
WHERE  1=2
/
