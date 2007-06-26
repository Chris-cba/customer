
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_cr8tab.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_cr8tab.sql
--       Date into SCCS   : 05/03/15 03:46:13
--       Date fetched Out : 07/06/06 14:40:35
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
DROP TABLE xtnz_doc_mails;
--
CREATE TABLE xtnz_doc_mails
   (xdm_doc_id       NUMBER
   ,xdm_iit_ne_id    NUMBER
   ,xdm_message_type VARCHAR2(1)          NOT NULL
   ,xdm_nmm_id       NUMBER
   ,xdm_message_date DATE DEFAULT SYSDATE NOT NULL
   )
/

ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_uk_1
 UNIQUE (xdm_doc_id,xdm_message_type,xdm_iit_ne_id)
/
ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_uk_2
 UNIQUE (xdm_iit_ne_id,xdm_message_type,xdm_doc_id)
/

ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_doc_fk
 FOREIGN KEY (xdm_doc_id)
 REFERENCES docs (doc_id)
 ON DELETE CASCADE
/


ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_iit_fk
 FOREIGN KEY (xdm_iit_ne_id)
 REFERENCES nm_inv_items_all (iit_ne_id)
 ON DELETE CASCADE
/

ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_nmm_fk
 FOREIGN KEY (xdm_nmm_id)
 REFERENCES nm_mail_message (nmm_id)
 ON DELETE SET NULL
/

CREATE INDEX xdm_doc_fk_ind ON xtnz_doc_mails(xdm_iit_ne_id)
/
CREATE INDEX xdm_nmm_fk_ind ON xtnz_doc_mails(xdm_nmm_id)
/

ALTER TABLE xtnz_doc_mails
 ADD CONSTRAINT xdm_message_type_chk
 CHECK (xdm_message_type IN ('U','L','E'))
/

