create or replace 
TRIGGER X_PEM_SEND_EMAILS
   AFTER INSERT OR UPDATE OF doc_status_code, doc_compl_user_id
   ON docs
   FOR EACH ROW
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/emails/admin/trg/x_pem_send_emails.trg-arc   1.0   Jul 10 2013 15:17:58   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_pem_send_emails.trg  $
--       Date into PVCS   : $Date:   Jul 10 2013 15:17:58  $
--       Date fetched Out : $Modtime:   Jun 07 2013 10:59:40  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-- x_pem_send_emails  Trigger written for Enfield to trigger sending of emails when PEM status or responsibility of is changed
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
DECLARE
BEGIN

IF :NEW.doc_compl_source != 'M' THEN
   IF UPDATING THEN
      IF :OLD.doc_status_code <> :NEW.doc_status_code
         OR :OLD.doc_compl_user_id <> :NEW.doc_compl_user_id THEN
            INSERT INTO x_pem_docs_email VALUES (:new.doc_id, 'N');
      ELSE
         null;
      END IF;
   ELSE
     IF :NEW.doc_file = 'PEM_API' THEN
        null;
     ELSE
         IF :new.doc_status_code is not NULL THEN
          INSERT INTO x_pem_docs_email VALUES (:new.doc_id, 'N');
         END IF;
    END IF;
   END IF;
END IF;

END;
/
