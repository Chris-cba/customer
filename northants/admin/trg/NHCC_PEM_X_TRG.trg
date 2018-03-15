DROP TRIGGER NHCC_PEM_X_TRG;

CREATE OR REPLACE TRIGGER NHCC_PEM_X_TRG
   AFTER INSERT OR UPDATE
   ON DOCS
   FOR EACH ROW
DECLARE
   --
   -----------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/northants/admin/trg/NHCC_PEM_X_TRG.trg-arc   1.2   Mar 15 2018 15:51:54   Sarah.Williams  $
   --       Module Name      : $Workfile:   nhcc_pem_x_trg.trg  $
   --       Date into PVCS   : $Date:   Mar 15 2018 15:51:54  $
   --       Date fetched Out : $Modtime:   Mar 15 2018 15:51:02  $
   --       PVCS Version     : $Revision:   1.2  $
   --       Based on SCCS version : 
   --
   --   Author : H.Buckley
   --
   --   nhcc_pem_source_trg
   --
   --   Create new PEM mail trigger
   --   on change of PEM Status where SOURCE = 'W' OR 'C' AND FLAG = 'EM'
   --
   -- Dear [AAAAA]
   --
   -- There has been an update to your Street Doctor report, reference number [BBBBBB]
   --
   -- The report has been updated with the following information
   -- [CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC]
   --
   -- You will receive another email when the report is updated again.
   --
   -- Thank you for contacting the Street Doctor at Northamptonshire County Council
   --
   -- Stephen,
   --
   -- During the last meeting, we discussed that you needed a new mail trigger as follows:
   --
   -- On change of status AND (source = `web¿ OR `call centre¿) AND flag = `Mail Required¿ then send a change of status mail.
   --
   -- Can you confirm that the attached is the text to be sent by this trigger?
   --
   -- The mail includes three data fields as follows:
   --
   -- Dear      xxxxx      PEM Contact First Name?
   -- Reference xxxxx PEM ID
   -- Xxxxxxxxxxxxxxxx ?? What PEM field goes in this `updated information¿?
   --
   --
   -- Updated June 2013 by Aileen heal to slighty modify the text of the update trigger.
   --
   -- March 2018 Sarah Williams: Changes made so trigger will work with Sendgrid nm 4500 fix 54.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) Bentley Systems Ltd, 2013
   -----------------------------------------------------------------------------
   --
   --
   -- **********************************************************************
   -- Here we need to obtain an email and name for the contacts
   -- of the document. Only if the contact has an email address will we
   -- send an email to the customer.
   -- **********************************************************************
   CURSOR GetCustomerName (
      doc_id   IN docs.doc_id%TYPE)
   IS
      SELECT *
        FROM hig_contacts, doc_enquiry_contacts
       WHERE     dec_doc_id = doc_id
             AND dec_hct_id = hct_id
             AND hct_email IS NOT NULL;

   custrec                   GetCustomerName%ROWTYPE;

   CURSOR GetAction (doc_id       IN docs.doc_id%TYPE,
                     doc_status   IN docs.doc_status_code%TYPE)
   IS
      SELECT dhi_reason
        FROM doc_history
       WHERE dhi_doc_id = doc_id AND dhi_status_code = doc_status;

   -- SW added 13-Mar-2018 for use with SENDGRID authentication changes associated with NM 4500 fix 54
   no_connection             EXCEPTION;

   CURSOR c_connection
   IS
      SELECT hfc_ftp_username, nm3ftp.get_password (hfc_ftp_password)
        FROM hig_ftp_connections, hig_ftp_types
       WHERE hft_type = 'MAIL' AND hfc_hft_id = hft_id;

   lv_username               hig_ftp_connections.hfc_ftp_username%TYPE;
   lv_password               VARCHAR2 (100);
   lv_b64_username           VARCHAR2 (100);
   lv_b64_password           VARCHAR2 (100);
   lv_authenticated          VARCHAR2 (1) := hig.get_sysopt ('AUTHMAIL');
   lv_row_found              BOOLEAN;
   -- end of definitions added for nm 4500 fix 54 SW 13-MAR-2018

   actionrec                 GetAction%ROWTYPE;

   --
   l_from_name               VARCHAR2 (100)
                                := 'streetdoctor@northamptonshire.gov.uk';
   l_from_user               VARCHAR2 (100) := 'System Administrator';
   l_customer_name           VARCHAR2 (100) := 'Street doctor';
   l_subject                 VARCHAR2 (100)
                                := 'Transport, Highways and Infrastructure';
   -- l_subject        varchar2(100):='A Source change has occured for PEM : '||to_char(:new.doc_id);
   l_status                  hig_status_codes.hsc_status_name%TYPE;
   l_customer_email          hig_contacts.hct_email%TYPE
                                := 'streetdoctor@northamptonshire.gov.uk';
   l_msg                     nm3type.tab_varchar32767;
   v_mail_host               hig_options.hop_value%TYPE
                                := hig.get_sysopt ('SMTPSERVER');
   v_mail_port               hig_options.hop_value%TYPE
                                := hig.get_sysopt ('SMTPPORT');
   v_mail_conn               UTL_SMTP.connection;
   crlf                      VARCHAR2 (2) := CHR (13) || CHR (10);
   j                         INTEGER := 1;
   additional_address_info   BOOLEAN := TRUE;

   --
   PROCEDURE ins_doc_history (pi_text IN VARCHAR2)
   IS
   BEGIN
      INSERT INTO doc_history (dhi_doc_id,
                               dhi_date_changed,
                               dhi_changed_by,
                               dhi_reason)
           VALUES (:NEW.doc_id,
                   SYSDATE + .00001,
                   USER,
                   pi_text);          -- Needs to  add a second so it does not
   END ins_doc_history;              -- clash with the standard doc_history in

   PROCEDURE send_header (name IN VARCHAR2, header IN VARCHAR2)
   AS
   BEGIN
      UTL_SMTP.write_data (v_mail_conn,
                           name || ': ' || header || UTL_TCP.crlf);
   END;
--

BEGIN
   IF INSERTING
   THEN
      IF     :new.doc_status_code <> :old.doc_status_code -- SW 13-MAR-2018 just fyi I don't think this can ever have worked on insert because old doc status code is always null and this will return neither true nor false.I haven't changed it but just noting in case there are queries.
         AND :new.doc_compl_source IN ('C', 'W')
      THEN
         l_subject :=
            'A new PEM has arrived: [' || TO_CHAR (:new.doc_id) || ']';

         IF lv_authenticated = 'Y' -- SW 13-MAR-2018 this if statement added for SENDGRID authentication NM 4500 fix 54
         THEN
            --
            nm3ctx.set_context ('NM3FTPPASSWORD', 'Y');

            OPEN c_connection;

            FETCH c_connection INTO lv_username, lv_password;

            lv_row_found := c_connection%FOUND;

            CLOSE c_connection;

            IF NOT lv_row_found
            THEN
               RAISE no_connection;
            END IF;

            v_mail_conn := UTL_SMTP.open_connection (v_mail_host, v_mail_port);

            lv_b64_username :=
               UTL_RAW.cast_to_varchar2 (
                  UTL_ENCODE.base64_encode (
                     UTL_RAW.cast_to_raw (lv_username)));
            lv_b64_password :=
               UTL_RAW.cast_to_varchar2 (
                  UTL_ENCODE.base64_encode (
                     UTL_RAW.cast_to_raw (lv_password)));

            UTL_SMTP.ehlo (v_mail_conn, v_mail_host);
            UTL_SMTP.command (v_mail_conn, 'AUTH LOGIN');
            UTL_SMTP.command (v_mail_conn, lv_b64_username);
            UTL_SMTP.command (v_mail_conn, lv_b64_password);
            l_from_user := lv_username;
         ELSE
            v_mail_conn := UTL_SMTP.open_connection (v_mail_host, v_mail_port);  
            UTL_SMTP.helo (v_mail_conn, v_mail_host); 
         END IF;

         UTL_SMTP.mail (v_mail_conn, l_from_name);
         UTL_SMTP.rcpt (v_mail_conn, l_customer_email);
         UTL_SMTP.open_data (v_mail_conn);
         send_header ('Date', TO_CHAR (SYSDATE, 'DD-MON-YYYY:HH24:MI:SS'));
         send_header ('From',
                      '<SystemAdministrator@Northamptonshire.gov.uk>');
         send_header ('Subject', l_subject);
         send_header ('To', '<' || l_customer_email || '>');
         l_msg (1) := '';
         l_msg (2) := 'Dear Street Doctor';
         l_msg (3) := ' ';
         l_msg (4) :=
               'A new PEM has arrived; ['
            || TO_CHAR (:new.doc_id)
            || '] via the external web portal.';
         l_msg (5) := ' ';
         l_msg (6) := ' ';
         l_msg (7) := ' ';
         l_msg (8) :=
            'Thank you for contacting the Street Doctor at Northamptonshire County Council';
         l_msg (9) := ' ';
         l_msg (10) := ' ';
         l_msg (11) := ' ';

         IF additional_address_info
         THEN
            l_msg (12) := ' ';
            l_msg (13) := ' ';
            l_msg (14) := ' ';
            l_msg (15) := ' ';
            l_msg (16) := 'Northamptonshire County Council';
            l_msg (17) := 'Highways, Transport and Infrastructure';  
            l_msg (18) := 'Riverside House';
            l_msg (19) := 'Riverside Way';
            l_msg (20) := 'Bedford Road';
            l_msg (21) := 'Northampton';
            l_msg (22) := 'NN1 5NX';
            l_msg (23) := 'Web: www.northamptonshire.gov.uk';
         END IF;

         IF additional_address_info
         THEN
            LOOP
               UTL_SMTP.write_data (v_mail_conn, UTL_TCP.crlf || l_msg (j));
               EXIT WHEN j = 23;
               j := j + 1;
            END LOOP;
         ELSE
            LOOP
               UTL_SMTP.write_data (v_mail_conn, UTL_TCP.crlf || l_msg (j));
               EXIT WHEN j = 11;
               j := j + 1;
            END LOOP;
         END IF;

         UTL_SMTP.close_data (v_mail_conn);
         UTL_SMTP.quit (v_mail_conn);
      END IF;
   ELSIF UPDATING
   THEN
      IF     :new.doc_status_code <> :old.doc_status_code
         AND :new.doc_compl_source IN ('C', 'W')
      THEN
         FOR i IN GetCustomerName (:new.doc_id)
         LOOP
            IF     i.hct_vip = 'EM'
               AND NVL (i.hct_email, 'X') <> 'X'
               AND INSTR (i.hct_email, '@') > 0
            THEN
               OPEN GetAction (:new.doc_id, :new.doc_status_code);

               FETCH GetAction INTO actionrec;

               CLOSE GetAction;

               l_customer_name :=
                  INITCAP (i.hct_title || ' ' || i.hct_surname);
               l_customer_email := LOWER (i.hct_email);
               l_subject := 'Your Street Doctor Report';

               IF lv_authenticated = 'Y' -- SW 13-MAR-2018 this if statement added for SENDGRID authentication NM 4500 fix 54
               THEN
                  --
                  nm3ctx.set_context ('NM3FTPPASSWORD', 'Y');

                  OPEN c_connection;

                  FETCH c_connection INTO lv_username, lv_password;

                  lv_row_found := c_connection%FOUND;

                  CLOSE c_connection;

                  IF NOT lv_row_found
                  THEN
                     RAISE no_connection;
                  END IF;

                  v_mail_conn :=
                     UTL_SMTP.open_connection (v_mail_host, v_mail_port);

                  lv_b64_username :=
                     UTL_RAW.cast_to_varchar2 (
                        UTL_ENCODE.base64_encode (
                           UTL_RAW.cast_to_raw (lv_username)));
                  lv_b64_password :=
                     UTL_RAW.cast_to_varchar2 (
                        UTL_ENCODE.base64_encode (
                           UTL_RAW.cast_to_raw (lv_password)));

                  UTL_SMTP.ehlo (v_mail_conn, v_mail_host);
                  UTL_SMTP.command (v_mail_conn, 'AUTH LOGIN');
                  UTL_SMTP.command (v_mail_conn, lv_b64_username);
                  UTL_SMTP.command (v_mail_conn, lv_b64_password);
                  l_from_user := lv_username;
               ELSE
                  v_mail_conn :=
                     UTL_SMTP.open_connection (v_mail_host, v_mail_port);
                  UTL_SMTP.helo (v_mail_conn, v_mail_host);
               END IF;

               UTL_SMTP.mail (v_mail_conn, l_from_name);
               UTL_SMTP.rcpt (v_mail_conn, l_customer_email);
               UTL_SMTP.open_data (v_mail_conn);
               send_header ('Date',
                            TO_CHAR (SYSDATE, 'DD-MON-YYYY:HH24:MI:SS'));
               send_header ('From',
                            '<SystemAdministrator@Northamptonshire.gov.uk>');
               send_header ('Subject', l_subject);
               send_header ('To', '<' || l_customer_email || '>');

               l_msg (1) := '';
               l_msg (2) :=
                  '*****Please be aware, this is not a monitored e-mail address so please do not reply to this email*****';
               l_msg (3) := '';
               l_msg (4) := 'Dear ' || l_customer_name;
               l_msg (5) := ' ';
               l_msg (6) :=
                     'There has been an update to your Street Doctor report, reference number ['
                  || TO_CHAR (:new.doc_id)
                  || ']';
               l_msg (7) := ' ';
               l_msg (8) :=
                  'The report has been updated with the following information -';
               l_msg (9) := actionrec.dhi_reason;
               l_msg (10) := ' ';
               l_msg (11) := ' ';
               l_msg (12) :=
                  'Thank you for contacting the Street Doctor at Northamptonshire County Council';
               l_msg (13) := ' ';

               -- ******************************************************************************************
               -- Here I have been informe ha we need to bulk up the email. We need to do this so that
               -- relay mail servers do not believe the email to be SPAM and reject the email
               -- ******************************************************************************************
               IF additional_address_info
               THEN
                  l_msg (14) := ' ';
                  l_msg (15) := ' ';
                  l_msg (16) := ' ';
                  l_msg (17) := ' ';
                  l_msg (18) := 'Northamptonshire County Council';
                  l_msg (19) := 'Web: www.northamptonshire.gov.uk';
               END IF;

               IF additional_address_info
               THEN
                  LOOP
                     UTL_SMTP.write_data (v_mail_conn,
                                          UTL_TCP.crlf || l_msg (j));
                     EXIT WHEN j = 19;
                     j := j + 1;
                  END LOOP;
               ELSE
                  LOOP
                     UTL_SMTP.write_data (v_mail_conn,
                                          UTL_TCP.crlf || l_msg (j));
                     EXIT WHEN j = 13;
                     j := j + 1;
                  END LOOP;
               END IF;

               UTL_SMTP.close_data (v_mail_conn);
               UTL_SMTP.quit (v_mail_conn);
            --ins_doc_history (pi_text => 'email sent on change of source');

            END IF;
         END LOOP;
      --utl_smtp.quit(v_mail_conn);
      END IF;
   END IF;
EXCEPTION
   WHEN UTL_SMTP.transient_error OR UTL_SMTP.permanent_error
   THEN
      raise_application_error (-20000, 'Unable to send mail: ' || SQLERRM);
   --
   -- SW 13-MAR-2018 added for SENDGRID changes nm 4500 fix 54
   WHEN no_connection
   THEN
      raise_application_error (
         -20001,
         'SMTP Authentication details have not been defined');
--
END;
/
