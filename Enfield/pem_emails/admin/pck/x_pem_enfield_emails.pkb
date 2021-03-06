create or replace
PACKAGE BODY "X_PEM_ENFIELD_EMAILS"
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/Enfield/emails/x_pem_enfield_emails.pkb-arc   1.3   Mar 14 2016 11:49:16   Sarah.Williams  $
--       Module Name      : $Workfile:   x_pem_enfield_emails.pkb  $
--       Date into PVCS   : $Date:   Mar 14 2016 11:49:16  $
--       Date fetched Out : $Modtime:   Mar 14 2016 11:47:48  $
--       PVCS Version     : $Revision:   1.3  $
--       Based on SCCS version :
--
--
--   Author : Paul Stanton
--
--   x_pem_enfield_emails body
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
-- 14-MAR-2016 SW v1.3 In the if statements for non-user contacts the PEM status was incorrectly compared to Complete instead of Enquiry completed
--                     so was emailing non user contacts when the enquiry was closed which was not required.  Changed both if statements for non users.
--
--all global package variables here
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.3  $"';
  g_package_name CONSTANT varchar2(30) := 'x_pem_enfield_emails';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_docs AS
BEGIN
	DELETE x_pem_docs_email WHERE processed = 'Y';
	COMMIT;
END CLEAR_DOCS;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_docs AS
	CURSOR c1 IS
		SELECT a.doc_id, doc_user_id, doc_status_code, doc_dtp_code, doc_dcl_code ,doc_compl_type, doc_outcome, nmu_email_address, doc_compl_location, doc_descr, doc_compl_action, doc_compl_target, doc_compl_user_id,
		 doc_compl_cpr_id,DOC_COMPL_INSURANCE_CLAIM,DOC_COMPL_POLICE_NOTIF_FLAG,doc_compl_summons_received,doc_compl_litigation_flag
		FROM docs a, x_pem_docs_email b, nm_mail_users c
		WHERE a.doc_id = b.doc_id
		AND c.nmu_hus_user_id = a.doc_compl_user_id
		AND b.processed = 'N'
		AND c.nmu_email_address IS NOT NULL;
	  CURSOR c2 IS
	  SELECT a.doc_id, doc_user_id, doc_status_code, doc_dtp_code, doc_dcl_code ,doc_compl_type, doc_outcome, hct_email, doc_compl_location, doc_descr, doc_compl_action, doc_compl_target, doc_compl_user_id,
	   doc_compl_cpr_id,DOC_COMPL_INSURANCE_CLAIM,DOC_COMPL_POLICE_NOTIF_FLAG,doc_compl_summons_received,doc_compl_litigation_flag
	  FROM docs a, x_pem_docs_email b, hig_contacts c
	WHERE a.doc_id = b.doc_id
	AND c.hct_id = a.doc_compl_user_id
	AND b.processed = 'N'
	AND c.hct_email IS NOT NULL;
r1 c1%ROWTYPE;
r2 c2%ROWTYPE;
BEGIN
-- Process emails for standard users
		OPEN c1;
		LOOP
			FETCH c1 INTO r1;
			EXIT WHEN c1%NOTFOUND;
			responsibility_email(
				r1.doc_id,
				r1.doc_user_id,
				r1.doc_status_code,
				r1.doc_dtp_code,
				r1.doc_dcl_code,
				r1.doc_compl_type,
				r1.doc_outcome,
				r1.doc_compl_location,
				r1.doc_descr,
				r1.doc_compl_action,
				r1.doc_compl_target,
				r1.nmu_email_address,
				r1.doc_compl_user_id,
				r1.doc_compl_cpr_id,
				r1.DOC_COMPL_INSURANCE_CLAIM,
				r1.DOC_COMPL_POLICE_NOTIF_FLAG,
				r1.doc_compl_summons_received,
				r1.doc_compl_litigation_flag);
			UPDATE x_pem_docs_email
			SET processed = 'Y'
			WHERE doc_id = r1.doc_id;
			COMMIT;
		END LOOP;
		CLOSE c1;
  clear_docs;
	COMMIT;
-- Process emails for contacts that are not users in the system
OPEN c2;
		LOOP
			FETCH c2 INTO r2;
			EXIT WHEN c2%NOTFOUND;
			responsibility_email(
				r2.doc_id,
				r2.doc_user_id,
				r2.doc_status_code,
				r2.doc_dtp_code,
				r2.doc_dcl_code,
				r2.doc_compl_type,
				r2.doc_outcome,
				r2.doc_compl_location,
				r2.doc_descr,
				r2.doc_compl_action,
				r2.doc_compl_target,
				r2.hct_email,
				r2.doc_compl_user_id,
				r2.doc_compl_cpr_id,
				r2.DOC_COMPL_INSURANCE_CLAIM,
				r2.DOC_COMPL_POLICE_NOTIF_FLAG,
				r2.doc_compl_summons_received,
				r2.doc_compl_litigation_flag);
			UPDATE x_pem_docs_email
			SET processed = 'Y'
			WHERE doc_id = r2.doc_id;
			COMMIT;
		END LOOP;
		CLOSE c2;
  clear_docs;
	COMMIT;
END process_docs;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_doc_history(pi_doc_id NUMBER, pi_text VARCHAR2)
IS
BEGIN
	INSERT INTO doc_history (dhi_doc_id, dhi_date_changed, dhi_changed_by, dhi_reason) VALUES (pi_doc_id, sysdate + 0.001, user, pi_text);
EXCEPTION
	WHEN OTHERS THEN NULL;
END insert_doc_history;
--
-----------------------------------------------------------------------------
--
PROCEDURE responsibility_email(    pi_doc_id                       IN NUMBER,
								pi_doc_user_id                   IN NUMBER,
								pi_doc_status_code               IN VARCHAR2,
								pi_doc_dtp_code                   IN VARCHAR2,
								pi_doc_dcl_code                   IN VARCHAR2,
								pi_doc_compl_type               IN VARCHAR2,
								pi_doc_outcome_reason           IN VARCHAR2,
								pi_doc_compl_location           IN VARCHAR2,
								pi_doc_descr                   IN VARCHAR2,
								pi_doc_compl_action               IN VARCHAR2,
								pi_doc_compl_target               IN VARCHAR2,
								pi_to_email_address               IN VARCHAR2,
								 pi_doc_compl_user_id           IN VARCHAR2,
								pi_doc_compl_cpr_id            IN VARCHAR2,
								pi_DOC_COMPL_INSURANCE_CLAIM   IN VARCHAR2,
								pi_DOC_COMPL_POLICE_NOTIF_FLAG IN VARCHAR2,
								pi_doc_compl_summons_received  IN VARCHAR2,
								pi_doc_compl_litigation_flag   IN VARCHAR2) IS
 CURSOR c_check_doc_type (
	  c_dtp_code doc_types.dtp_code%TYPE)
   IS
	  SELECT '*'
	  FROM   doc_types
	  WHERE  dtp_allow_complaints = 'N'
	  AND    dtp_code = c_dtp_code;
--
   CURSOR c_mail_user (
	  c_user_id nm_mail_users.nmu_hus_user_id%TYPE)
   IS
	  SELECT nmu.*
	  FROM   nm_mail_users nmu
	  WHERE  nmu_hus_user_id = c_user_id;
--
CURSOR c_mail_user_contact (c_user_id hig_contacts.hct_id%TYPE)
   IS
	  SELECT *
	  FROM   hig_contacts
	  WHERE  hct_id = c_user_id;
--
   CURSOR get_status (
	  c_status_code hig_status_codes.hsc_status_code%TYPE)
   IS
	  SELECT hsc_status_name
	  FROM   hig_status_codes
	  WHERE  hsc_domain_code = 'COMPLAINTS'
	  AND    hsc_status_code = c_status_code;
--
   CURSOR get_user
   IS
	  SELECT nmu_id
	  FROM   nm_mail_users
	  WHERE  nmu_hus_user_id = (select hus_user_id from hig_users
								where hus_username = user);
--
CURSOR get_from_user
   IS
	  SELECT nmu_email_address
	  FROM   nm_mail_users
	  WHERE  nmu_hus_user_id = (select hus_user_id from hig_users
								where hus_username = user);
--
   CURSOR get_priority (p_doc_compl_cpr_id docs.doc_compl_cpr_id%TYPE) IS
   SELECT cpr_name FROM complaint_priorities
   WHERE cpr_id = p_doc_compl_cpr_id;
--
   CURSOR get_cat (p_doc_dtp_code docs.doc_dtp_code%TYPE) IS
   SELECT dtp_name FROM doc_types
   WHERE dtp_code = p_doc_dtp_code;
--
   CURSOR get_class (p_doc_dcl_code docs.doc_dcl_code%TYPE, p_doc_dtp_code docs.doc_dtp_code%TYPE) IS
   select dcl_name from doc_class
   where dcl_code = p_doc_dcl_code
   and dcl_dtp_code = p_doc_dtp_code;
--
   CURSOR get_type (p_doc_compl_type docs.doc_compl_type%TYPE, p_doc_dcl_code docs.doc_dcl_code%TYPE, p_doc_dtp_code docs.doc_dtp_code%TYPE) IS
   select det_name from doc_enquiry_types
   where det_code = p_doc_compl_type
   and det_dtp_code = p_doc_dtp_code
   and det_dcl_code = p_doc_dcl_code;
--
   CURSOR get_contact (p_doc_id docs.doc_id%TYPE) IS
   select hct_id,hct_title,hct_first_name,hct_surname,hct_home_phone,hct_work_phone, hct_mobile_phone, hct_email from hig_contacts
   where hct_id = (select dec_hct_id from doc_enquiry_contacts
				   where dec_doc_id = p_doc_id
				   and dec_contact = 'Y' and rownum = 1);
--
   CURSOR get_address (p_hct_id hig_contact_address.hca_hct_id%TYPE) IS
   select had_building_no,had_building_name, had_thoroughfare,had_post_town,had_postcode,decode(had_property_type,'CCD','Yes')  from hig_address
   where had_id in (select hca_had_id from hig_contact_address
				   where hca_hct_id = p_hct_id);
--
	CURSOR c_details (p_hct_id hig_contacts.hct_id%TYPE) IS
	SELECT hct_title, hct_first_name, hct_surname, hct_email
	FROM hig_contacts
	WHERE hct_id  = p_hct_id;
--
	CURSOR get_recorded_by (p_doc_user_id docs.doc_user_id%TYPE) IS
	SELECT hus_name
	FROM hig_users
	WHERE hus_user_id  = p_doc_user_id;
--
	CURSOR get_claim_val (p_doc_id docs.doc_id%TYPE) IS
	SELECT decode(DOC_COMPL_POLICE_NOTIF_FLAG,'Y','Yes','N','No',null),
		   decode(DOC_COMPL_INSURANCE_CLAIM,'Y','Yes','N','No',null),
		   decode(doc_compl_summons_received,'Y','Yes','N','No',null),
		   decode(doc_compl_litigation_flag,'Y','Yes','N','No',null)
	  FROM docs
	 WHERE doc_id = p_doc_id;
--
	CURSOR get_claims (p_doc_id docs.doc_id%TYPE) IS
	SELECT (case when nvl(doc_compl_litigation_flag,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'N' and nvl(DOC_COMPL_POLICE_NOTIF_FLAG,'N') = 'N'
			 then 'ACT PER'
			 when nvl(doc_compl_litigation_flag,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'N' and nvl(DOC_COMPL_POLICE_NOTIF_FLAG,'N') = 'Y'
			 then 'ACT PER / POT PROP'
			 when nvl(doc_compl_litigation_flag,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'Y'
			 then 'ACT PER / ACT PROP'
			 when nvl(doc_compl_litigation_flag,'N') = 'N' and nvl(DOC_COMPL_INSURANCE_CLAIM,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'N' and nvl(DOC_COMPL_POLICE_NOTIF_FLAG,'N') = 'N'
			 then 'POT PER'
			 when nvl(doc_compl_litigation_flag,'N') = 'N' and nvl(DOC_COMPL_INSURANCE_CLAIM,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'N' and nvl(DOC_COMPL_POLICE_NOTIF_FLAG,'N') = 'Y'
			 then 'POT PER / POT PROP'
			 when nvl(doc_compl_litigation_flag,'N') = 'N' and nvl(DOC_COMPL_INSURANCE_CLAIM,'N') = 'Y'
			  and nvl(doc_compl_summons_received,'N') = 'Y'
			 then 'POT PER / ACT PROP'
			 when nvl(doc_compl_litigation_flag,'N') = 'N' and nvl(DOC_COMPL_INSURANCE_CLAIM,'N') = 'N'
			  and nvl(doc_compl_summons_received,'N') = 'Y'
			 then 'ACT PROP'
			 when nvl(doc_compl_litigation_flag,'N') = 'N' and nvl(DOC_COMPL_INSURANCE_CLAIM,'N') = 'N'
			  and nvl(doc_compl_summons_received,'N') = 'N' and nvl(DOC_COMPL_POLICE_NOTIF_FLAG,'N') = 'Y'
			 then 'POT PROP' end) claims
	FROM DOCS
	WHERE doc_id = p_doc_id;
--
   user_id              VARCHAR2 (500);
   l_from_user          nm_mail_message.nmm_from_nmu_id%TYPE;
   l_from_email         nm_mail_users.nmu_email_address%TYPE;
   r_details            c_details%ROWTYPE;
   l_to                 nm3mail.tab_recipient;
   l_cc                 nm3mail.tab_recipient;
   l_bcc                nm3mail.tab_recipient;
   l_subject            nm_mail_message.nmm_subject%TYPE;
   l_msg                nm3type.tab_varchar32767;
   l_nmu_rec            nm_mail_users%ROWTYPE;
   l_hc_rec             hig_contacts%ROWTYPE;
   l_status             hig_status_codes.hsc_status_name%TYPE;
   l_priority           complaint_priorities.cpr_name%TYPE;
   l_cat                doc_types.dtp_name%TYPE;
   l_class              doc_class.dcl_name%TYPE;
   l_type               doc_enquiry_types.det_name%TYPE;
   l_hct_id             hig_contacts.hct_id%TYPE;
   l_hct_title          hig_contacts.hct_title%TYPE;
   l_hct_first_name     hig_contacts.hct_first_name%TYPE;
   l_hct_surname        hig_contacts.hct_surname%TYPE;
   l_hct_home_phone     hig_contacts.hct_home_phone%TYPE;
   l_hct_work_phone     hig_contacts.hct_work_phone%TYPE;
   l_hct_mobile_phone   hig_contacts.hct_mobile_phone%TYPE;
   l_hct_email	 		hig_contacts.hct_email%TYPE;
   l_had_building_no    hig_address.had_building_no%TYPE;
   l_had_building_name  hig_address.had_building_name%TYPE;
   l_had_thoroughfare   hig_address.had_thoroughfare%TYPE;
   l_had_post_town      hig_address.had_post_town%TYPE;
   l_had_postcode       hig_address.had_postcode%TYPE;
   l_had_property_type	hig_address.had_property_type%TYPE;
   l_recorded_by	hig_users.hus_name%TYPE;
   l_claims		VARCHAR2(20);
   l_pot_prop VARCHAR2(5);
   l_pot_per  VARCHAR2(5);
   l_act_prop VARCHAR2(5);
   l_act_per  VARCHAR2(5);
   v_message            VARCHAR2(4000);
	lfcr CONSTANT VARCHAR2(10) := CHR(10)||''||CHR(13);
	l_doc_type VARCHAR2 (1);
BEGIN
--set the flag which states the customer is using the auto emailing functionality.
   --flag is reset back to false in doc0150 post insert or post update triggers.
   pem.set_customer_auto_email (TRUE);
 OPEN c_check_doc_type (pi_doc_dtp_code);
		 FETCH c_check_doc_type
		 INTO  l_doc_type;
		 IF c_check_doc_type%NOTFOUND THEN
			CLOSE c_check_doc_type;
--
			OPEN get_status (pi_doc_status_code);
			FETCH get_status
			INTO  l_status;
			CLOSE get_status;
--
			OPEN get_user;
			FETCH get_user
			INTO  l_from_user;
			IF get_user%FOUND THEN
			   CLOSE get_user;
			   OPEN c_mail_user (pi_doc_compl_user_id);
			   FETCH c_mail_user
			   INTO  l_nmu_rec;
			   OPEN get_priority (pi_doc_compl_cpr_id);
			   FETCH get_priority INTO l_priority;
			   CLOSE get_priority;
			   OPEN get_cat (pi_doc_dtp_code);
			   FETCH get_cat INTO l_cat;
			   CLOSE get_cat;
			   OPEN get_class (pi_doc_dcl_code, pi_doc_dtp_code);
			   FETCH get_class INTO l_class;
			   CLOSE get_class;
			   OPEN get_type (pi_doc_compl_type, pi_doc_dcl_code, pi_doc_dtp_code);
			   FETCH get_type INTO l_type;
			   CLOSE get_type;
			   OPEN get_contact (pi_doc_id);
			   FETCH get_contact INTO l_hct_id, l_hct_title, l_hct_first_name, l_hct_surname, l_hct_home_phone, l_hct_work_phone, l_hct_mobile_phone, l_hct_email;
			   CLOSE get_contact;
			   OPEN get_address (l_hct_id);
			   FETCH get_address INTO l_had_building_no,l_had_building_name, l_had_thoroughfare,l_had_post_town,l_had_postcode,l_had_property_type;
			   CLOSE get_address;
			   OPEN get_recorded_by (pi_doc_user_id);
			   FETCH get_recorded_by INTO l_recorded_by;
			   CLOSE get_recorded_by;
			   OPEN get_claim_val (pi_doc_id);
			   FETCH get_claim_val INTO l_pot_prop,l_pot_per,l_act_prop,l_act_per;
			   CLOSE get_claim_val;
			   OPEN get_claims (pi_doc_id);
			   FETCH get_claims INTO l_claims;
			   CLOSE get_claims;
			   IF c_mail_user%FOUND and l_status <> 'Enquiry completed' THEN
				  l_to (1).rcpt_id := l_nmu_rec.nmu_id;
				  l_to (1).rcpt_type := nm3mail.c_user;
				  l_subject  := 'PEM ' || pi_doc_id ||' for '||l_nmu_rec.nmu_name||' '||l_claims||' '||l_had_postcode;
				  l_msg (1)  := 'Cautionary Contact: ' || l_had_property_type||'			Status = ' || pi_doc_status_code|| ' ' || l_status;
				  l_msg (2)  := lfcr;
				  l_msg (3)  := 'Priority: '||NVL(l_priority,'n/a')||'				Category: '||l_cat;
				  l_msg (4)  := lfcr;
				  l_msg (5)  := 'Class: '||l_class||'				Enquiry Type: '||l_type;
				  l_msg (6)  := lfcr;
				  l_msg (7) := 'Location: '||NVL(pi_doc_compl_location,'n/a');
				  l_msg (8) := lfcr;
				  l_msg (9) := 'Description: '||NVL(pi_doc_descr,'n/a');
				  l_msg (10) := lfcr;
				  l_msg (11) := 'Action/Remarks: '||NVL(pi_doc_compl_action,'n/a');
				  l_msg (12) := lfcr;
				  l_msg (13) := 'Contact Details: '||l_hct_title||' '||l_hct_first_name||' '||l_hct_surname||', '||l_had_building_no||' '||l_had_building_name||' '||l_had_thoroughfare||', '||l_had_post_town||', '||l_had_postcode;
				  l_msg (14) := lfcr;
				  l_msg (15) := 'Tel Home: '||NVL(l_hct_home_phone,'n/a')||'		Tel Work: '||nvl(l_hct_work_phone,'n/a');
				  l_msg (16) := lfcr;
				  l_msg (17) := 'Tel Mobile: '||nvl(l_hct_mobile_phone,'n/a')||'	Email: '||nvl(l_hct_email,'n/a');
				  l_msg (18) := lfcr;
				  l_msg (19) := 'PEM Created by: '||NVL(l_recorded_by,'n/a');
				  l_msg (20) := lfcr;
				  l_msg (21) := '********************************* OFFICER'||''''||'S RESPONSE ********************************';
				  l_msg (22) := lfcr;
				  l_msg (23) := 'An inspection of the above site(s) was made on:';
				  l_msg (24) := lfcr;
				  l_msg (25) := 'Telephoned customer on (date):         at (time):';
				  l_msg (26) := lfcr;
				  l_msg (27) := 'Photographs attached Yes/No:';
				  l_msg (28) := lfcr;
				  l_msg (29) := 'Referred to:                           on date:';
				  l_msg (30) := lfcr;
				  l_msg (31) := 'Action taken:';
				  l_msg (32) := lfcr;
				  l_msg (33) := 'Works orders no(s):                    date(s) of issue:';
				  l_msg (34) := lfcr;
				  l_msg (35) := 'Anticipated completion date:';
				  l_msg (36) := lfcr;
				  l_msg (37) := 'Planned date of next routine inspection:';
--
				  nm3mail.write_mail_complete (p_from_user => l_from_user
											  ,p_subject => l_subject
											  ,p_html_mail => FALSE
											  ,p_tab_to => l_to
											  ,p_tab_cc => l_cc
											  ,p_tab_bcc => l_bcc
											  ,p_tab_message_text => l_msg);
--
				  insert_doc_history (pi_doc_id, 'email sent to responsibility of');
			   ELSIF c_mail_user%FOUND and l_status = 'Enquiry completed'   THEN
				 NULL;
			   ELSE
				  CLOSE c_mail_user;
			   -- See if the user is actually a contact
				  OPEN c_mail_user_contact (pi_doc_compl_user_id);
				  FETCH c_mail_user_contact
				  INTO  l_hc_rec;
				  OPEN c_details (l_hc_rec.hct_id);
				  FETCH c_details INTO r_details;
				  CLOSE c_details;
				  OPEN get_priority (pi_doc_compl_cpr_id);
				  FETCH get_priority INTO l_priority;
				  CLOSE get_priority;
				  OPEN get_cat (pi_doc_dtp_code);
				  FETCH get_cat INTO l_cat;
				  CLOSE get_cat;
				  OPEN get_class (pi_doc_dcl_code, pi_doc_dtp_code);
				  FETCH get_class INTO l_class;
				  CLOSE get_class;
				  OPEN get_type (pi_doc_compl_type, pi_doc_dcl_code, pi_doc_dtp_code);
				  FETCH get_type INTO l_type;
				  CLOSE get_type;
				  OPEN get_contact (pi_doc_id);
				  FETCH get_contact INTO l_hct_id, l_hct_title, l_hct_first_name, l_hct_surname, l_hct_home_phone, l_hct_work_phone, l_hct_mobile_phone, l_hct_email;
				  CLOSE get_contact;
				  OPEN get_address (l_hct_id);
				  FETCH get_address INTO l_had_building_no,l_had_building_name, l_had_thoroughfare,l_had_post_town,l_had_postcode,l_had_property_type;
				  CLOSE get_address;
				  OPEN get_recorded_by (pi_doc_user_id);
				  FETCH get_recorded_by INTO l_recorded_by;
				  CLOSE get_recorded_by;
				  OPEN get_claim_val (pi_doc_id);
				  FETCH get_claim_val INTO l_pot_prop,l_pot_per,l_act_prop,l_act_per;
				  CLOSE get_claim_val;
				  OPEN get_claims (pi_doc_id);
				  FETCH get_claims INTO l_claims;
				  CLOSE get_claims;
				  IF c_mail_user_contact%FOUND and l_status <> 'Enquiry completed' THEN
					 -- get from users email address
					 OPEN get_from_user;
					 FETCH get_from_user INTO l_from_email;
					 CLOSE get_from_user;
					 l_subject := 'PEM ' || pi_doc_id ||' for '||l_nmu_rec.nmu_name||' '||l_claims||' '||l_had_postcode;
					 v_message := v_message||lfcr||'Cautionary Contact: ' || l_had_property_type||'			Status = ' || pi_doc_status_code|| ' ' || l_status;
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Priority: '||NVL(l_priority,'n/a')||'			Category: '||l_cat;
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Class: '||l_class||'			Enquiry Type: '||l_type;
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Location: '||NVL(pi_doc_compl_location,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Description: '||NVL(pi_doc_descr,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Action/Remarks: '||NVL(pi_doc_compl_action,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Contact Details: '||l_hct_title||' '||l_hct_first_name||' '||l_hct_surname||', '||l_had_building_no||' '||l_had_building_name||' '||l_had_thoroughfare||', '||l_had_post_town||', '||l_had_postcode;
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Tel Home: '||NVL(l_hct_home_phone,'n/a')||'		Tel Work: '||nvl(l_hct_work_phone,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Tel Mobile: '||nvl(l_hct_mobile_phone,'n/a')||'	Email: '||nvl(l_hct_email,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'PEM Created by: '||NVL(l_recorded_by,'n/a');
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'********************************* OFFICER'||''''||'S RESPONSE ********************************';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'An inspection of the above site(s) was made on:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Telephoned customer on (date):         at (time):';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Photographs attached Yes/No:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Referred to:                           on date:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Action taken:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Works orders no(s):                    date(s) of issue:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Anticipated completion date:';
					 v_message := v_message||lfcr;
					 v_message := v_message||lfcr||'Planned date of next routine inspection:';
--
					 x_pem_email.SEND_MAIL(pi_from => l_from_email
										   ,pi_to   => r_details.hct_email
						  ,pi_cc => null
						  ,pi_doc_id => null
						  ,pi_subject => l_subject
						  ,pi_message => v_message
						  ,pi_attachment_name => null
						  );
--
				  insert_doc_history (pi_doc_id, 'email sent to responsibility of');
			   ELSIF c_mail_user_contact%FOUND and l_status = 'Enquiry completed'   THEN
				 null;
			   ELSE
			   CLOSE get_user;
				  --set the flag which specifies the user responsible for the PEM doesn't have an email address
				  --this flag is reset in doc0150
				  pem.set_resp_has_email (FALSE);
			   END IF;
			END IF;
		 ELSE
			--CLOSE c_check_doc_type;
			null;
		 END IF;
	 END IF;
/*EXCEPTION WHEN OTHERS THEN
raise_application_error(-20000
						   ,'problem with processing emails');                  */
END responsibility_email;
--
-----------------------------------------------------------------------------
--
END x_pem_enfield_emails;
/
