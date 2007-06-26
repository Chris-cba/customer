--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_695596_create_doc_assocs_records_for_existing.sql	1.1 03/15/05
--       Module Name      : xmrwa_695596_create_doc_assocs_records_for_existing.sql
--       Date into SCCS   : 05/03/15 00:45:18
--       Date fetched Out : 07/06/06 14:38:07
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
INSERT INTO doc_assocs
      (das_table_name
      ,das_rec_id
      ,das_doc_id
      )
SELECT new_das_table_name
      ,new_das_rec_id
      ,new_das_doc_id
 FROM (SELECT c_app_owner||'.'||nm3inv_view.derive_nw_inv_type_view_name(iit_inv_type) new_das_table_name
             ,das_rec_id new_das_rec_id
             ,das_doc_id new_das_doc_id
        FROM  doc_assocs
             ,nm_inv_items
             ,(SELECT hig.get_application_owner c_app_owner FROM DUAL)
       WHERE  das_table_name = 'NM_INV_ITEMS'
        AND   das_rec_id     = iit_ne_id
      )
WHERE EXISTS (SELECT 1
               FROM  doc_gateways
              WHERE  dgt_table_name = new_das_table_name
             )
 AND NOT EXISTS
             (SELECT 1
               FROM  doc_assocs
              WHERE  das_table_name = new_das_table_name
               AND   das_rec_id     = new_das_rec_id
               AND   das_doc_id     = new_das_doc_id
             )
/
