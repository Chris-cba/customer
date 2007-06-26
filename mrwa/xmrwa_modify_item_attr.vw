CREATE OR REPLACE VIEW xmrwa_modify_item_attr AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_modify_item_attr.vw	1.1 03/15/05
--       Module Name      : xmrwa_modify_item_attr.vw
--       Date into SCCS   : 05/03/15 00:45:57
--       Date fetched Out : 07/06/06 14:38:23
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
      ,iit_start_date
      ,ita_view_col_name
      ,IIT_CHR_ATTRIB75  iit_new_value
 FROM  nm_inv_items_all
      ,nm_inv_type_attribs
WHERE  1=2
/
