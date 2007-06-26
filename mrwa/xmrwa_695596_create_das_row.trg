CREATE OR REPLACE TRIGGER xmrwa_695596_create_das_row
   BEFORE INSERT OR DELETE
    ON    doc_assocs
   FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_695596_create_das_row.trg	1.1 03/15/05
--       Module Name      : xmrwa_695596_create_das_row.trg
--       Date into SCCS   : 05/03/15 00:45:18
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
   c_das_table_name CONSTANT doc_assocs.das_table_name%TYPE := NVL(:NEW.das_table_name,:OLD.das_table_name);
   c_das_rec_id     CONSTANT doc_assocs.das_rec_id%TYPE     := NVL(:NEW.das_rec_id,:OLD.das_rec_id);
   c_das_doc_id     CONSTANT doc_assocs.das_doc_id%TYPE     := NVL(:NEW.das_doc_id,:OLD.das_doc_id);
--
BEGIN
--
   xmrwa_695596_das_3081.add_to_globals
                         (p_das_table_name => c_das_table_name
                         ,p_das_rec_id     => c_das_rec_id
                         ,p_das_doc_id     => c_das_doc_id
                         ,p_inserting      => INSERTING
                         ,p_deleting       => DELETING
                         );
--
END xmrwa_695596_create_das_row;
/
