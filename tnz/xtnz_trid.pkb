CREATE OR REPLACE PACKAGE BODY xtnz_trid AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid.pkb	1.2 03/16/05
--       Module Name      : xtnz_trid.pkb
--       Date into SCCS   : 05/03/16 01:19:40
--       Date fetched Out : 07/06/06 14:40:32
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   TNZ TRID package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xtnz_trid.pkb	1.2 03/16/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xtnz_trid';
   c_das_table_name  CONSTANT  varchar2(30)   := 'INV_ITEMS_ALL';
--
   c_unlocated       CONSTANT  xtnz_doc_mails.xdm_message_type%TYPE := 'U';
   c_located         CONSTANT  xtnz_doc_mails.xdm_message_type%TYPE := 'L';
   c_event           CONSTANT  xtnz_doc_mails.xdm_message_type%TYPE := 'E';
--
   c_cis_mail_group  CONSTANT  nm_mail_groups.nmg_name%TYPE         := 'TRID CIS Users';
   l_tab_text                  nm3type.tab_varchar32767;
   c_app_owner       CONSTANT  VARCHAR2(30) := hig.get_application_owner;
   c_nmc             CONSTANT  nm_group_types.ngt_group_type%TYPE   := 'NMC';
   c_trid_elec_drain_carr CONSTANT VARCHAR2(1) := '#';
--
   c_trid_excl_group_type CONSTANT nm_group_types.ngt_group_type%TYPE := 'T_EX';
--
   c_url             CONSTANT  hig_user_options.huo_value%TYPE      := hig.get_sysopt('TRIDWEBURL');
--
-----------------------------------------------------------------------------
--
PROCEDURE write_mail_internal (p_from_user        IN nm_mail_message.nmm_from_nmu_id%TYPE
                              ,p_subject          IN nm_mail_message.nmm_subject%TYPE
                              ,p_html_mail        IN boolean DEFAULT TRUE
                              ,p_tab_to           IN nm3mail.tab_recipient
                              ,p_tab_cc           IN nm3mail.tab_recipient
                              ,p_tab_bcc          IN nm3mail.tab_recipient
                              ,p_tab_message_text IN nm3type.tab_varchar32767
                              );
--
-----------------------------------------------------------------------------
--
FUNCTION record_to_move_to (p_ita_view_attri nm_inv_type_attribs.ita_view_attri%TYPE) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmg_id (p_nmg_name nm_mail_groups.nmg_name%TYPE) RETURN nm_mail_groups.nmg_id%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_xdm (p_rec_xdm IN OUT xtnz_doc_mails%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE add_recipients (pi_iit_ne_id IN     NUMBER
                         ,po_tab_to    IN OUT nm3mail.tab_recipient
                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_location (p_iit_ne_id NUMBER, p_iit_inv_type VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE get_first_loc_for_item (p_iit_ne_id   IN     NUMBER
                                 ,p_nm_ne_id_of    OUT NUMBER
                                 ,p_nm_begin_mp    OUT NUMBER
                                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE do_event_mail (p_iit_ne_id      NUMBER
                        ,p_cis_send_only  BOOLEAN
                        ,p_subject_prefix VARCHAR2
                        ,p_create_xdm     BOOLEAN
                        );
--
-----------------------------------------------------------------------------
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
      l_text nm3type.max_varchar2 := p_text;
   BEGIN
      IF p_nl
       THEN
         l_text := l_text||htf.br;
      END IF;
      nm3tab_varchar.append (l_tab_text, l_text, p_nl);
   END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_if_present (p_boilertext VARCHAR2
                            ,p_value      VARCHAR2
                            ) IS
BEGIN
   IF REPLACE(p_value,' ',Null) IS NOT NULL
    THEN
      append (p_boilertext||' : '||p_value);
   END IF;
END append_if_present;
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
PROCEDURE create_pem IS
--
   l_rec_doc_empty              docs%ROWTYPE;
   l_rec_das_empty              doc_assocs%ROWTYPE;
   l_rec_hct_empty              hig_contacts%ROWTYPE;
   l_rec_had_empty              hig_address%ROWTYPE;
   l_rec_hca_empty              hig_contact_address%ROWTYPE;
   l_rec_dec_empty              doc_enquiry_contacts%ROWTYPE;
--
   l_tab_ita                    nm3inv.tab_nita;
--
   l_block                      nm3type.tab_varchar32767;
   l_record_name                VARCHAR2(30);
--
   l_not_trid_pem               EXCEPTION;
   c_trid_pem          CONSTANT VARCHAR2(1) := '$';
   l_some_to_do                 BOOLEAN := FALSE;
--
BEGIN
--
   IF nm3get.get_nit (pi_nit_inv_type => g_rec_iit.iit_inv_type).nit_elec_drain_carr != c_trid_pem
    THEN
      RAISE l_not_trid_pem;
   END IF;
--
   l_tab_ita  := nm3inv.get_tab_ita (g_rec_iit.iit_inv_type);
--
   g_rec_doc                        := l_rec_doc_empty;
   g_rec_das                        := l_rec_das_empty;
   g_rec_hct                        := l_rec_hct_empty;
   g_rec_had                        := l_rec_had_empty;
   g_rec_hca                        := l_rec_hca_empty;
   g_rec_dec                        := l_rec_dec_empty;
--
   g_rec_had.had_id                 := nm3seq.next_had_id_seq;
--
   g_rec_hct.hct_id                 := nm3seq.next_hct_id_seq;
   g_rec_hct.hct_org_or_person_flag := 'P';
--
   g_rec_hca.hca_hct_id             := g_rec_hct.hct_id;
   g_rec_hca.hca_had_id             := g_rec_had.had_id;
--
   g_rec_doc.doc_id                 := nm3seq.next_doc_id_seq;
   g_rec_doc.doc_title              := g_rec_iit.iit_inv_type||','||g_rec_iit.iit_ne_id;
   g_rec_doc.doc_dtp_code           := g_rec_iit.iit_inv_type;
   g_rec_doc.doc_date_issued        := SYSDATE;
--   g_rec_doc.doc_admin_unit         := g_rec_iit.iit_admin_unit;
   g_rec_doc.doc_admin_unit         := 1;
   g_rec_doc.doc_status_code        := 'CL';
   g_rec_doc.doc_user_id            := nm3user.get_user_id;
   g_rec_doc.doc_compl_user_id      := g_rec_doc.doc_user_id;
   g_rec_doc.doc_compl_source       := 'T';
   g_rec_doc.doc_compl_user_type    := 'USER';
   g_rec_doc.doc_reason             := 'Created from trigger';
   g_rec_doc.doc_descr              := g_rec_iit.iit_descr;
--
   g_rec_das.das_table_name         := c_das_table_name;
   g_rec_das.das_rec_id             := g_rec_iit.iit_ne_id;
   g_rec_das.das_doc_id             := g_rec_doc.doc_id;
--
   nm3tab_varchar.append(l_block,'BEGIN',FALSE);
   nm3tab_varchar.append(l_block,'   Null;');
   FOR i IN 1..l_tab_ita.COUNT
    LOOP
      l_record_name := record_to_move_to (l_tab_ita(i).ita_view_attri) ;
      IF l_record_name IS NOT NULL
       THEN
         l_some_to_do := TRUE;
         nm3tab_varchar.append(l_block,'   '||g_package_name||'.'||l_record_name||'.'||LOWER(l_tab_ita(i).ita_view_attri)||' := '||g_package_name||'.g_rec_iit.'||LOWER(l_tab_ita(i).ita_attrib_name)||';');
      END IF;
   END LOOP;
   nm3tab_varchar.append(l_block,'END;');
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm3tab_varchar.debug_tab_varchar (l_block);
--   nm_debug.debug_off;
   IF l_some_to_do
    THEN
      nm3ddl.execute_tab_varchar (l_block);
   END IF;
--
   IF g_rec_iit.iit_inv_type NOT IN ('COMP')
    THEN
      g_rec_doc.doc_compl_type := 'STD';
   END IF;
--
   g_rec_dec.dec_hct_id      := g_rec_hct.hct_id;
   g_rec_dec.dec_doc_id      := g_rec_doc.doc_id;
   g_rec_dec.dec_type        := 'Caller';
   g_rec_dec.dec_ref         := Null;
   g_rec_dec.dec_complainant := Null;
   g_rec_dec.dec_contact     := 'Y';
--
--   g_rec_iit.iit_num_attrib115 := g_rec_doc.doc_id;
--
   nm3ins.ins_hct (g_rec_hct);
   nm3ins.ins_had (g_rec_had);
   nm3ins.ins_hca (g_rec_hca);
   nm3ins.ins_doc (g_rec_doc);
   nm3ins.ins_das (g_rec_das);
   nm3ins.ins_dec (g_rec_dec);
--
EXCEPTION
   WHEN l_not_trid_pem
    THEN
      Null;
--
END create_pem;
--
-----------------------------------------------------------------------------
--
FUNCTION record_to_move_to (p_ita_view_attri nm_inv_type_attribs.ita_view_attri%TYPE) RETURN VARCHAR2 IS
   l_retval VARCHAR2(30);
   l_substr VARCHAR2(3);
BEGIN
   l_substr := RTRIM(UPPER(SUBSTR(p_ita_view_attri,1,3)),'_');
   IF l_substr IN ('HCT','DOC','HAD')
    THEN
      l_retval := 'g_rec_'||lower(l_substr);
   END IF;
   RETURN l_retval;
END record_to_move_to;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_doc_mails IS
--
   CURSOR cs_unlocated (c_older_than DATE) IS
   SELECT doc_id
         ,doc_descr
         ,iit_ne_id
    FROM (SELECT doc_id
                ,TO_NUMBER(das_rec_id) iit_ne_id
                ,doc_descr
                ,doc_dtp_code
           FROM  docs
                ,doc_assocs
          WHERE  doc_date_issued < c_older_than
           AND   doc_id          = das_doc_id
           AND   das_table_name  = c_das_table_name
           AND   NOT EXISTS (SELECT 1
                              FROM  nm_members
                             WHERE  nm_ne_id_in = das_rec_id
                            )
          UNION ALL
          SELECT doc_id
                ,to_number(null) iit_ne_id
                ,doc_descr
                ,doc_dtp_code
           FROM  docs
          WHERE  doc_date_issued < c_older_than
           AND   NOT EXISTS (SELECT 1
                              FROM  doc_assocs
                             WHERE  doc_id          = das_doc_id
                              AND   das_table_name  = c_das_table_name
                            )
         )
         ,doc_types
   WHERE  doc_dtp_code         = dtp_code
    AND   dtp_allow_complaints = 'Y'
    AND   NOT EXISTS (SELECT 1
                       FROM  xtnz_doc_mails
                      WHERE  xdm_doc_id       = doc_id
                       AND   xdm_message_type = c_unlocated
                     );
--
   CURSOR cs_located IS
   SELECT doc_id
         ,doc_descr
         ,iit_ne_id
    FROM (SELECT doc_id
                ,TO_NUMBER(das_rec_id) iit_ne_id
                ,doc_descr
           FROM  docs
                ,doc_assocs
          WHERE  doc_id          = das_doc_id
           AND   das_table_name  = c_das_table_name
           AND       EXISTS (SELECT 1
                              FROM  nm_members
                             WHERE  nm_ne_id_in = das_rec_id
                            )
         )
   WHERE  NOT EXISTS (SELECT 1
                       FROM  xtnz_doc_mails
                      WHERE  xdm_doc_id       = doc_id
                       AND   xdm_message_type = c_located
                     );
--
   l_tab_doc_id    nm3type.tab_number;
   l_tab_iit_ne_id nm3type.tab_number;
   l_tab_doc_descr nm3type.tab_varchar2000;
   l_rec_xdm       xtnz_doc_mails%ROWTYPE;
   l_tab_to        nm3mail.tab_recipient;
   l_tab_cc        nm3mail.tab_recipient;
   l_tab_bcc       nm3mail.tab_recipient;
   l_from_nmu_id   nm_mail_users.nmu_id%TYPE;
   l_nmg_id_cis    nm_mail_groups.nmg_id%TYPE;
   l_rec_doc       docs%ROWTYPE;
--
   PROCEDURE append_details (p_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                            ,p_located   BOOLEAN
                            ) IS
--
      CURSOR cs_contact_dets (c_doc_id docs.doc_id%TYPE) IS
      SELECT hct_title||' '||hct_first_name||' '||hct_surname hct_name
            ,had_building_no||', '||had_thoroughfare had_street
            ,had_dependent_locality_name
            ,had_post_town
            ,hct_home_phone
            ,hct_email
       FROM  hig_contacts
            ,doc_enquiry_contacts
   	    ,hig_contact_address
            ,hig_address
      WHERE  dec_hct_id = hct_id
       AND   dec_doc_id = c_doc_id
       AND   hca_hct_id = hct_id
       AND   hca_had_id = had_id;
--
      l_rec_contact_dets cs_contact_dets%ROWTYPE;
      l_found            BOOLEAN;
--
   BEGIN
--
      append_if_present ('ID',l_rec_doc.doc_id);
--
      IF   p_iit_ne_id IS NOT NULL
       AND p_located
       THEN
         append_location (p_iit_ne_id, Null);
      END IF;
--
      append_if_present ('Category',nm3get.get_dtp (pi_dtp_code        => l_rec_doc.doc_dtp_code
                                                   ,pi_raise_not_found => FALSE
                                                   ).dtp_name
                        );
      append_if_present ('Class',nm3get.get_dcl    (pi_dcl_dtp_code    => l_rec_doc.doc_dtp_code
                                                   ,pi_dcl_code        => l_rec_doc.doc_dcl_code
                                                   ,pi_raise_not_found => FALSE
                                                   ).dcl_name
                        );
      append_if_present ('Type',nm3get.get_det     (pi_det_dtp_code    => l_rec_doc.doc_dtp_code
                                                   ,pi_det_dcl_code    => l_rec_doc.doc_dcl_code
                                                   ,pi_det_code        => l_rec_doc.doc_compl_type
                                                   ,pi_raise_not_found => FALSE
                                                   ).det_name
                        );
      append_if_present ('Recorded',TO_CHAR(l_rec_doc.doc_date_issued,nm3type.c_full_date_time_format));
      append_if_present ('Incident Date',TO_CHAR(l_rec_doc.doc_compl_incident_date,nm3type.c_full_date_time_format));
      append_if_present ('Action',l_rec_doc.doc_compl_action);
      append_if_present ('Location',l_rec_doc.doc_compl_location);
--
      OPEN  cs_contact_dets (l_rec_doc.doc_id);
      FETCH cs_contact_dets
       INTO l_rec_contact_dets;
      l_found := cs_contact_dets%FOUND;
      CLOSE cs_contact_dets;
      IF l_found
       THEN
         append_if_present ('Name',l_rec_contact_dets.hct_name);
         append_if_present ('Address Line 1',l_rec_contact_dets.had_street);
         append_if_present ('Address Line 2',l_rec_contact_dets.had_dependent_locality_name);
         append_if_present ('Address Line 3',l_rec_contact_dets.had_post_town);
         append_if_present ('Phone',l_rec_contact_dets.hct_home_phone);
         append_if_present ('E-Mail',l_rec_contact_dets.hct_email);
      END IF;
--
   END append_details;
--
BEGIN
--
   l_from_nmu_id := nm3mail.get_current_nmu_id;
   l_nmg_id_cis  := get_nmg_id (c_cis_mail_group);
--
   OPEN  cs_unlocated (SYSDATE - (10/1440));
   FETCH cs_unlocated
    BULK COLLECT
    INTO l_tab_doc_id
        ,l_tab_doc_descr
        ,l_tab_iit_ne_id;
   CLOSE cs_unlocated;
--
   l_tab_to(1).rcpt_id        := l_nmg_id_cis;
   l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
   FOR i IN 1..l_tab_doc_id.COUNT
    LOOP
--
      l_tab_text.DELETE;
--
      l_rec_doc := nm3get.get_doc (pi_doc_id => l_tab_doc_id(i));
--
      append_details (l_tab_iit_ne_id(i), FALSE);
--
      write_mail_internal (p_from_user        => l_from_nmu_id
                          ,p_subject          => 'Unlocated : '||l_tab_doc_descr(i)
                          ,p_html_mail        => FALSE
                          ,p_tab_to           => l_tab_to
                          ,p_tab_cc           => l_tab_cc
                          ,p_tab_bcc          => l_tab_bcc
                          ,p_tab_message_text => l_tab_text
                          );
--
      l_rec_xdm.xdm_doc_id       := l_tab_doc_id(i);
      l_rec_xdm.xdm_message_type := c_unlocated;
      l_rec_xdm.xdm_iit_ne_id    := l_tab_iit_ne_id(i);
      l_rec_xdm.xdm_nmm_id       := nm3seq.curr_nmm_id_seq;
      l_rec_xdm.xdm_message_date := SYSDATE;
      ins_xdm (l_rec_xdm);
--
   END LOOP;
--
   OPEN  cs_located;
   FETCH cs_located
    BULK COLLECT
    INTO l_tab_doc_id
        ,l_tab_doc_descr
        ,l_tab_iit_ne_id;
   CLOSE cs_located;
--
   FOR i IN 1..l_tab_doc_id.COUNT
    LOOP
--
      l_tab_to.DELETE;
      l_tab_to(1).rcpt_id        := l_nmg_id_cis;
      l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
      l_tab_text.DELETE;
--
      l_rec_doc := nm3get.get_doc (pi_doc_id => l_tab_doc_id(i));
--
      append_details (l_tab_iit_ne_id(i), TRUE);
--
--    ############################################################
--
--
--     work out in here who else to send it to
--
      IF NVL(l_rec_doc.doc_dcl_code,nm3type.c_nvl) != 'TNZ'
       THEN
         add_recipients (l_tab_iit_ne_id(i), l_tab_to);
      END IF;
--
--    ############################################################
--
      write_mail_internal (p_from_user        => l_from_nmu_id
                          ,p_subject          => l_tab_doc_descr(i)
                          ,p_html_mail        => TRUE
                          ,p_tab_to           => l_tab_to
                          ,p_tab_cc           => l_tab_cc
                          ,p_tab_bcc          => l_tab_bcc
                          ,p_tab_message_text => l_tab_text
                          );
--
      l_rec_xdm.xdm_doc_id       := l_tab_doc_id(i);
      l_rec_xdm.xdm_message_type := c_located;
      l_rec_xdm.xdm_iit_ne_id    := l_tab_iit_ne_id(i);
      l_rec_xdm.xdm_nmm_id       := nm3seq.curr_nmm_id_seq;
      l_rec_xdm.xdm_message_date := SYSDATE;
      ins_xdm (l_rec_xdm);
--
      COMMIT;
--
   END LOOP;
--
END send_doc_mails;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_event_mails IS
--
   CURSOR cs_iit IS
   SELECT iit_ne_id
    FROM  nm_inv_items
   WHERE  iit_inv_type IN (SELECT nit_inv_type
                            FROM  nm_inv_types
                           WHERE  nit_elec_drain_carr = c_trid_elec_drain_carr
                          )
    AND   NOT EXISTS     (SELECT 1
                           FROM  xtnz_doc_mails
                          WHERE  xdm_iit_ne_id = iit_ne_id
                           AND   xdm_message_type = c_event
                         )
    AND   EXISTS         (SELECT 1
                           FROM  nm_members
                          WHERE  nm_ne_id_in = iit_ne_id
                         )
   ORDER BY iit_inv_type;
--
   l_tab_iit_ne_id nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'send_event_mails');
--
   g_prior_nit := nm3type.c_nvl;
--
   OPEN  cs_iit;
   FETCH cs_iit
    BULK COLLECT
    INTO l_tab_iit_ne_id;
   CLOSE cs_iit;
--
   FOR i IN 1..l_tab_iit_ne_id.COUNT
    LOOP
--
      do_event_mail (p_iit_ne_id      => l_tab_iit_ne_id(i)
                    ,p_cis_send_only  => FALSE
                    ,p_subject_prefix => Null
                    ,p_create_xdm     => TRUE
                    );
--
      COMMIT;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'send_event_mails');
--
END send_event_mails;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_list_if_changed IS
--
   l_block nm3type.tab_varchar32767;
--
   CURSOR cs_xdm (c_iit_ne_id NUMBER) IS
   SELECT 1
    FROM  xtnz_doc_mails
   WHERE  xdm_iit_ne_id    = c_iit_ne_id
    AND   xdm_message_type = c_event;
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
   PROCEDURE do_or_diff (p_attrib VARCHAR2) IS
   BEGIN
      append ('   AND ('||g_package_name||'.g_rec_iit_old.'||p_attrib||' = '||g_package_name||'.g_rec_iit.'||p_attrib);
      append ('       OR ('||g_package_name||'.g_rec_iit_old.'||p_attrib||' IS NULL AND '||g_package_name||'.g_rec_iit.'||p_attrib||' IS NULL)');
      append ('       )');
   END do_or_diff;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_to_list_if_changed');
--
   DECLARE
      not_sending_update_mail EXCEPTION;
      PRAGMA EXCEPTION_INIT (not_sending_update_mail,-20999);
   BEGIN
--
      IF nm3get.get_nit (pi_nit_inv_type => g_rec_iit.iit_inv_type).nit_elec_drain_carr != c_trid_elec_drain_carr
       THEN
         RAISE not_sending_update_mail;
      END IF;
--
      OPEN  cs_xdm (g_rec_iit.iit_ne_id);
      FETCH cs_xdm INTO l_dummy;
      l_found := cs_xdm%FOUND;
      CLOSE cs_xdm;
      --
      IF NOT l_found
       THEN -- no initial event mail ever sent - so don't send an update one
         RAISE not_sending_update_mail;
      END IF;
--
      l_block.DELETE;
      --
      --append ('DECLARE');
      append ('BEGIN',FALSE);
      append ('   IF '||g_package_name||'.g_rec_iit_old.iit_ne_id = '||g_package_name||'.g_rec_iit.iit_ne_id');
      --
      do_or_diff ('iit_descr');
      do_or_diff ('iit_primary_key');
      do_or_diff ('iit_start_date');
      do_or_diff ('iit_end_date');
      do_or_diff ('iit_x_sect');
      FOR cs_rec IN (SELECT ita_attrib_name FROM nm_inv_type_attribs WHERE ita_inv_type = g_rec_iit.iit_inv_type)
       LOOP
         do_or_diff (cs_rec.ita_attrib_name);
      END LOOP;
      append ('    THEN');
      append ('      RAISE_APPLICATION_ERROR(-20999,'||nm3flx.string('Nothing of interest changed')||');');
      append ('   END IF;');
      append ('END;');
--      nm_debug.delete_debug(TRUE);
--      nm_debug.debug_on;
--      nm3tab_varchar.debug_tab_varchar(l_block);
--      nm_debug.debug_off;
--
      nm3ddl.execute_tab_varchar (l_block);
--
      -- we've got to here, so something of interest has changed on the item. so send the mail
      g_tab_iit_ne_id(g_tab_iit_ne_id.COUNT+1) := g_rec_iit.iit_ne_id;
--
   EXCEPTION
      WHEN not_sending_update_mail
       THEN
         Null;
   END;
--
   nm_debug.proc_end(g_package_name,'add_to_list_if_changed');
--
END add_to_list_if_changed;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_update_mail_list IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_update_mail_list');
--
   FOR i IN 1..g_tab_iit_ne_id.COUNT
    LOOP
      do_event_mail (p_iit_ne_id      => g_tab_iit_ne_id(i)
                    ,p_cis_send_only  => TRUE
                    ,p_subject_prefix => 'UPDATE'
                    ,p_create_xdm     => FALSE
                    );
   END LOOP;
--
   clear_update_mail_list;
--
   nm_debug.proc_end(g_package_name,'process_update_mail_list');
--
END process_update_mail_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_update_mail_list IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'clear_update_mail_list');
--
   g_tab_iit_ne_id.DELETE;
--
   nm_debug.proc_end(g_package_name,'clear_update_mail_list');
--
END clear_update_mail_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_event_mail (p_iit_ne_id      NUMBER
                        ,p_cis_send_only  BOOLEAN
                        ,p_subject_prefix VARCHAR2
                        ,p_create_xdm     BOOLEAN
                        ) IS
--
   l_tab_to        nm3mail.tab_recipient;
   l_tab_cc        nm3mail.tab_recipient;
   l_tab_bcc       nm3mail.tab_recipient;
   l_from_nmu_id   nm_mail_users.nmu_id%TYPE;
   l_nmg_id_cis    nm_mail_groups.nmg_id%TYPE;
--
   l_tab_ita       nm3inv.tab_nita;
   l_block         nm3type.tab_varchar32767;
--
   l_subject       nm_mail_message.nmm_subject%TYPE;
   l_rec_xdm       xtnz_doc_mails%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'do_event_mail');
--
   l_from_nmu_id := nm3mail.get_current_nmu_id;
   l_nmg_id_cis  := get_nmg_id (c_cis_mail_group);
--
   l_tab_to.DELETE;
   l_tab_to(1).rcpt_id        := l_nmg_id_cis;
   l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
   l_tab_text.DELETE;
--
   g_rec_iit  := nm3get.get_iit (p_iit_ne_id);
   l_tab_ita  := nm3inv.get_tab_ita (g_rec_iit.iit_inv_type);
   --
   IF c_url IS NOT NULL
    THEN
      append (htf.anchor(c_url||'xtnz_lar_mail_merge.show_single_inv_item_details?pi_iit_ne_id='||g_rec_iit.iit_ne_id,'Detail'));
   END IF;
   append_if_present ('Type',g_rec_iit.iit_inv_type);
   append_if_present ('ID',g_rec_iit.iit_primary_key);
   append_location (g_rec_iit.iit_ne_id, g_rec_iit.iit_inv_type);
   --
   IF g_rec_iit.iit_inv_type != g_prior_nit
    THEN
      g_prior_nit := g_rec_iit.iit_inv_type;
      l_block.DELETE;
      nm3tab_varchar.append(l_block,'BEGIN',FALSE);
      nm3tab_varchar.append(l_block,'   Null;');
      FOR i IN 1..l_tab_ita.COUNT
       LOOP
         nm3tab_varchar.append(l_block,'   '||g_package_name||'.append_if_present('||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(l_tab_ita(i).ita_scrn_text))||','||g_package_name||'.g_rec_iit.'||l_tab_ita(i).ita_attrib_name||');');
      END LOOP;
      nm3tab_varchar.append(l_block,'END;');
   END IF;
   nm3ddl.execute_tab_varchar (l_block);
--
--    ############################################################
--
--
--     work out in here who else to send it to
--
   IF NOT p_cis_send_only
    THEN
      add_recipients (g_rec_iit.iit_ne_id, l_tab_to);
   END IF;
--
--    ############################################################
--
   IF p_subject_prefix IS NOT NULL
    THEN
      l_subject := p_subject_prefix||' : ';
   END IF;
   l_subject := l_subject||g_rec_iit.iit_descr;
--
   write_mail_internal (p_from_user        => l_from_nmu_id
                       ,p_subject          => l_subject
                       ,p_html_mail        => TRUE
                       ,p_tab_to           => l_tab_to
                       ,p_tab_cc           => l_tab_cc
                       ,p_tab_bcc          => l_tab_bcc
                       ,p_tab_message_text => l_tab_text
                       );
--
   IF p_create_xdm
    THEN
      l_rec_xdm.xdm_doc_id       := Null;
      l_rec_xdm.xdm_message_type := c_event;
      l_rec_xdm.xdm_iit_ne_id    := g_rec_iit.iit_ne_id;
      l_rec_xdm.xdm_nmm_id       := nm3seq.curr_nmm_id_seq;
      l_rec_xdm.xdm_message_date := SYSDATE;
      ins_xdm (l_rec_xdm);
   END IF;
--
   nm_debug.proc_end(g_package_name,'do_event_mail');
--
END do_event_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_xdm (p_rec_xdm IN OUT xtnz_doc_mails%ROWTYPE) IS
BEGIN
--
   INSERT INTO xtnz_doc_mails
          (xdm_doc_id
          ,xdm_message_type
          ,xdm_iit_ne_id
          ,xdm_nmm_id
          ,xdm_message_date
          )
   VALUES (p_rec_xdm.xdm_doc_id
          ,p_rec_xdm.xdm_message_type
          ,p_rec_xdm.xdm_iit_ne_id
          ,p_rec_xdm.xdm_nmm_id
          ,p_rec_xdm.xdm_message_date
          );
--
END ins_xdm;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmg_id (p_nmg_name nm_mail_groups.nmg_name%TYPE) RETURN nm_mail_groups.nmg_id%TYPE IS
   l_retval nm_mail_groups.nmg_id%TYPE;
BEGIN
--
   BEGIN
      SELECT nmg_id
       INTO  l_retval
       FROM  nm_mail_groups
      WHERE  nmg_name = p_nmg_name;
   EXCEPTION
      WHEN no_data_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'nm_mail_groups.nmg_name='||p_nmg_name
                       );
      WHEN too_many_rows
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 105
                       ,pi_supplementary_info => 'nm_mail_groups.nmg_name='||p_nmg_name
                       );
   END;
--
   RETURN l_retval;
--
END get_nmg_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_recipients (pi_iit_ne_id IN     NUMBER
                         ,po_tab_to    IN OUT nm3mail.tab_recipient
                         ) IS
--
   l_rec_iit           nm_inv_items%ROWTYPE;
   l_rec_nit           nm_inv_types%ROWTYPE;
   l_rec_ngq           nm_gaz_query%ROWTYPE;
   l_rec_ngqt          nm_gaz_query_types%ROWTYPE;
   l_tab_nmg_name_nmc  nm3type.tab_varchar80;
   l_tab_nmg_name_tro  nm3type.tab_varchar80;
   l_results           NUMBER;
   l_tab_ne_admin_unit nm3type.tab_number;
   l_count             PLS_INTEGER;
BEGIN
--
   l_rec_iit := nm3get.get_iit (pi_iit_ne_id    => pi_iit_ne_id);
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => l_rec_iit.iit_inv_type);
--
--   IF l_rec_nit.nit_pnt_or_cont = 'P'
--    THEN
----
--      SELECT nmc_name
--       BULK  COLLECT
--       INTO  l_tab_nmg_name_nmc
--       FROM (SELECT get_nmc(nm_members.nm_ne_id_of,nm_members.nm_begin_mp) nmc_name
--              FROM  nm_members
--             WHERE  nm_ne_id_in = l_rec_iit.iit_ne_id
--            )
--      WHERE  nmc_name IS NOT NULL
--      GROUP BY nmc_name;
----
--   ELSE
----
--      l_rec_ngq.ngq_id                 := nm3seq.next_ngq_id_seq;
--      l_rec_ngq.ngq_source_id          := l_rec_iit.iit_ne_id;
--      l_rec_ngq.ngq_source             := nm3extent.c_route;
--      l_rec_ngq.ngq_open_or_closed     := nm3gaz_qry.c_closed_query;
--      l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_items_query;
--      l_rec_ngq.ngq_query_all_items    := 'N';
--      l_rec_ngq.ngq_begin_mp           := Null;
--      l_rec_ngq.ngq_begin_datum_ne_id  := Null;
--      l_rec_ngq.ngq_begin_datum_offset := Null;
--      l_rec_ngq.ngq_end_mp             := Null;
--      l_rec_ngq.ngq_end_datum_ne_id    := Null;
--      l_rec_ngq.ngq_end_datum_offset   := Null;
--      l_rec_ngq.ngq_ambig_sub_class    := Null;
--      nm3ins.ins_ngq (l_rec_ngq);
----
--      l_rec_ngqt.ngqt_ngq_id           := l_rec_ngq.ngq_id;
--      l_rec_ngqt.ngqt_seq_no           := 1;
--      l_rec_ngqt.ngqt_item_type_type   := nm3gaz_qry.c_ngqt_item_type_type_inv;
--      l_rec_ngqt.ngqt_item_type        := c_nmc;
--      nm3ins.ins_ngqt (l_rec_ngqt);
----
--      l_results := nm3gaz_qry.perform_query (l_rec_ngq.ngq_id);
----
--      SELECT network_name
--       BULK  COLLECT
--       INTO  l_tab_nmg_name_nmc
--       FROM  v_nm_nmc
--      WHERE  iit_ne_id IN (SELECT ngqi_item_id
--                            FROM  nm_gaz_query_item_list
--                           WHERE  ngqi_job_id = l_results
--                          )
--       GROUP BY network_name;
----
--   END IF;
--
   SELECT ne_unique
    BULK  COLLECT
    INTO  l_tab_nmg_name_nmc
    FROM  nm_elements
         ,nm_members nm_inv
         ,nm_members nm_nmc
   WHERE  nm_inv.nm_ne_id_in = l_rec_iit.iit_ne_id
    AND   nm_nmc.nm_ne_id_in = ne_id
    AND   nm_nmc.nm_ne_id_of = nm_inv.nm_ne_id_of
    AND   ne_nt_type         = c_nmc
   GROUP BY ne_unique;
--
   SELECT nag_parent_admin_unit
    BULK  COLLECT
    INTO  l_tab_ne_admin_unit
    FROM  (SELECT ne_admin_unit
            FROM  nm_elements_all
           WHERE  ne_id IN (SELECT nm_ne_id_of
                             FROM  nm_members
                            WHERE  nm_ne_id_in = l_rec_iit.iit_ne_id
                           )
           GROUP BY ne_admin_unit
          )
         ,nm_admin_groups
   WHERE  nag_child_admin_unit = ne_admin_unit
    AND   nag_direct_link      = 'Y'
   GROUP BY nag_parent_admin_unit;
--
   FOR i IN 1..l_tab_ne_admin_unit.COUNT
    LOOP
      l_count := po_tab_to.COUNT + 1;
      po_tab_to(l_count).rcpt_id        := get_nmg_id (nm3get.get_nau(pi_nau_admin_unit=>l_tab_ne_admin_unit(i)).nau_name);
      po_tab_to(l_count).rcpt_type      := nm3mail.c_group;
   END LOOP;
--
   FOR i IN 1..l_tab_nmg_name_nmc.COUNT
    LOOP
      l_count := po_tab_to.COUNT + 1;
      po_tab_to(l_count).rcpt_id        := get_nmg_id (l_tab_nmg_name_nmc(i));
      po_tab_to(l_count).rcpt_type      := nm3mail.c_group;
   END LOOP;
--
END add_recipients;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_dbms_job (p_every_n_minutes PLS_INTEGER DEFAULT 10) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   c_what CONSTANT varchar2(200) :=            'BEGIN'
                                    ||CHR(10)||'   '||g_package_name||'.send_doc_mails;'
                                    ||CHR(10)||'   '||g_package_name||'.send_event_mails;'
                                    ||CHR(10)||'END;';
--
   l_existing_job_id user_jobs.job%TYPE;
--
   l_job_id   binary_integer;
--
BEGIN
--
   OPEN  cs_job (c_what);
   FETCH cs_job INTO l_existing_job_id;
   IF cs_job%FOUND
    THEN
      CLOSE cs_job;
      Raise_Application_Error(-20001,'Such a job already exists - JOB_ID : '||l_existing_job_id);
   END IF;
   CLOSE cs_job;
--
   IF NVL(p_every_n_minutes,0) <= 0
    THEN
      Raise_Application_Error(-20001,'p_every_n_minutes passed must have a non null, non zero, positive value');
   END IF;
--
   dbms_job.submit
       (job       => l_job_id
       ,what      => c_what
       ,next_date => SYSDATE
       ,interval  => 'SYSDATE+('||p_every_n_minutes||'/(60*24))'
       );
--
   COMMIT;
--
END submit_dbms_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_location (p_iit_ne_id NUMBER, p_iit_inv_type VARCHAR2) IS
   l_pl_arr           nm_placement_array := nm3pla.initialise_placement_array;
   l_pl               nm_placement;
   l_tab_pref_lrm     nm3type.tab_varchar4;
   l_loc_title_done   BOOLEAN := FALSE;
   l_iit_inv_type     nm_inv_types.nit_inv_type%TYPE := p_iit_inv_type;
   l_is_point         BOOLEAN;
BEGIN
--
   l_tab_pref_lrm(1) := c_trid_excl_group_type;
   l_tab_pref_lrm(2) := 'RSL';
   l_tab_pref_lrm(3) := 'RMP';
   l_tab_pref_lrm(4) := 'RND';
--
   IF l_iit_inv_type IS NULL
    THEN
      l_iit_inv_type := nm3get.get_iit (pi_iit_ne_id => p_iit_ne_id).iit_inv_type;
   END IF;
--
   l_is_point := nm3get.get_nit (pi_nit_inv_type => l_iit_inv_type).nit_pnt_or_cont = 'P';
--
   FOR j IN 1..l_tab_pref_lrm.COUNT
    LOOP
      l_pl_arr  := nm3pla.get_connected_chunks
                                 (pi_ne_id    => p_iit_ne_id
                                 ,pi_obj_type => l_tab_pref_lrm(j)
                                 );
      IF l_pl_arr.placement_count > 0
       AND NOT l_loc_title_done
       THEN
         l_loc_title_done := TRUE;
         append ('Location');
      END IF;
      FOR i IN 1..l_pl_arr.placement_count
       LOOP
         l_pl := l_pl_arr.get_entry (i);
         IF l_is_point
          THEN
            append (nm3net.get_ne_unique(l_pl.pl_ne_id)||'/'||l_pl.pl_start);
         ELSE
            append (nm3net.get_ne_unique(l_pl.pl_ne_id)||'/'||l_pl.pl_start||'-'||l_pl.pl_end);
         END IF;
      END LOOP;
   END LOOP;
END append_location;
--
-----------------------------------------------------------------------------
--
--FUNCTION get_nmc (p_of NUMBER, p_mp NUMBER) RETURN VARCHAR2 IS
--   none_found EXCEPTION;
--   PRAGMA EXCEPTION_INIT (none_found, -20783);
--BEGIN
--   RETURN nm3inv.get_attrib_value_view_col
--                             (p_of,p_mp,c_nmc,'NETWORK_NAME');
--EXCEPTION
--   WHEN none_found
--    THEN
--      RETURN Null;
--END get_nmc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmc (p_of NUMBER, p_mp NUMBER) RETURN VARCHAR2 IS
   CURSOR cs_ne (c_of NUMBER) IS
   SELECT ne_unique
    FROM  nm_elements
         ,nm_members
   WHERE  nm_ne_id_of = c_of
    AND   nm_ne_id_in = ne_id
    AND   ne_nt_type  = c_nmc;
   l_retval nm_elements.ne_unique%TYPE;
BEGIN
   OPEN  cs_ne (p_of);
   FETCH cs_ne INTO l_retval;
   CLOSE cs_ne;
   RETURN l_retval;
END get_nmc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmc_for_item (p_iit_ne_id NUMBER) RETURN VARCHAR2 IS
   l_of    nm_members.nm_ne_id_of%TYPE;
   l_mp    nm_members.nm_begin_mp%TYPE;
BEGIN
   get_first_loc_for_item (p_iit_ne_id   => p_iit_ne_id
                          ,p_nm_ne_id_of => l_of
                          ,p_nm_begin_mp => l_mp
                          );
   RETURN get_nmc (l_of, l_mp);
END get_nmc_for_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_first_loc_for_item (p_iit_ne_id   IN     NUMBER
                                 ,p_nm_ne_id_of    OUT NUMBER
                                 ,p_nm_begin_mp    OUT NUMBER
                                 ) IS
   CURSOR cs_mem (c_iit_ne_id NUMBER) IS
   SELECT nm_ne_id_of
         ,nm_begin_mp
    FROM  nm_members
   WHERE  nm_ne_id_in = c_iit_ne_id
   ORDER BY nm_seq_no;
BEGIN
   OPEN  cs_mem (p_iit_ne_id);
   FETCH cs_mem INTO p_nm_ne_id_of, p_nm_begin_mp;
   CLOSE cs_mem;
END get_first_loc_for_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_trid_route_for_item (p_iit_ne_id NUMBER) RETURN VARCHAR2 IS
--
   l_retval nm3type.max_varchar2;
--
   l_tab_ne_unique nm3type.tab_varchar80;
--
--   PROCEDURE append_for_lrm (p_lrm VARCHAR2) IS
--      l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
--      l_pl     nm_placement;
--   BEGIN
--      l_pl_arr := nm3pla.get_connected_chunks (pi_ne_id    => p_iit_ne_id
--                                              ,pi_obj_type => p_lrm
--                                              );
--      FOR i IN 1..l_pl_arr.placement_count
--       LOOP
--         l_pl := l_pl_arr.get_entry(i);
--         IF l_retval IS NOT NULL
--          THEN
--            l_retval := l_retval||':';
--         END IF;
--         l_retval := l_retval||nm3net.get_ne_unique(l_pl.pl_ne_id);
--      END LOOP;
--   END append_for_lrm;
--
BEGIN
--
--   append_for_lrm (c_trid_excl_group_type);
--   append_for_lrm ('T_MU');
--
   SELECT e.ne_unique
    BULK  COLLECT
    INTO  l_tab_ne_unique
    FROM  nm_members  r
         ,nm_members  i
         ,nm_elements e
   WHERE  i.nm_ne_id_in = p_iit_ne_id
    AND   i.nm_ne_id_of = r.nm_ne_id_of
    AND   r.nm_type     = 'G'
    AND   r.nm_obj_type||NULL = c_trid_excl_group_type
    AND   r.nm_ne_id_in = e.ne_id
   GROUP BY e.ne_unique;
--
   FOR i IN 1..l_tab_ne_unique.COUNT
    LOOP
      IF i > 1
       THEN
         l_retval := l_retval||':';
      END IF;
      l_retval := l_retval||l_tab_ne_unique(i);
   END LOOP;
--
   RETURN l_retval;
--
END get_trid_route_for_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_map_item_url (pi_iit_ne_id    VARCHAR2
                          ,pi_iit_inv_type nm_inv_items.iit_inv_type%TYPE
                          ) RETURN VARCHAR2 IS
   l_retval      nm3type.max_varchar2;
BEGIN
   l_retval := get_map_item_url_url_only
                          (pi_iit_ne_id    => pi_iit_ne_id
                          ,pi_iit_inv_type => pi_iit_inv_type
                          );
   IF l_retval IS NOT NULL
    THEN
      l_retval := '<A HREF="'||l_retval||'" TARGET="_blank">Map</A>';
   ELSE
      l_retval := nm3web.c_nbsp;
   END IF;
   RETURN l_retval;
END get_map_item_url;
--
-----------------------------------------------------------------------------
--
FUNCTION get_map_item_url_url_only
                          (pi_iit_ne_id    VARCHAR2
                          ,pi_iit_inv_type nm_inv_items.iit_inv_type%TYPE
                          ) RETURN VARCHAR2 IS
   l_retval      nm3type.max_varchar2;
   l_gt_theme_id gis_themes.gt_theme_id%TYPE;
   l_rec_gt      gis_themes%ROWTYPE;
   l_table_name  VARCHAR2(30);
   l_found BOOLEAN;
   l_dummy PLS_INTEGER;
   l_cur   nm3type.ref_cursor;
   CURSOR cs_gt (c_feat_table VARCHAR2) IS
   SELECT *
    FROM  gis_themes
   WHERE  gt_feature_table IN (c_feat_table,c_app_owner||'.'||c_feat_table);
BEGIN
   l_table_name := nm3inv_sde.get_inv_sde_view_name (pi_iit_inv_type);
   OPEN  cs_gt (l_table_name);
   FETCH cs_gt INTO l_rec_gt;
   l_found := cs_gt%FOUND;
   CLOSE cs_gt;
   IF l_found
    THEN
      BEGIN
         OPEN   l_cur
          FOR   'SELECT 1 FROM '||l_rec_gt.gt_feature_table||' WHERE '||l_rec_gt.gt_label_column||' = :a'
          USING pi_iit_ne_id;
         FETCH  l_cur INTO l_dummy;
         l_found := l_cur%FOUND;
         CLOSE l_cur;
         IF l_found
          THEN
            l_retval := 'nm3web_map.show_item?p_gt_theme_id='||LTRIM(TO_CHAR(l_rec_gt.gt_theme_id),' ')||CHR(38)||'p_pk_value='||nm3web.string_to_url(pi_iit_ne_id,FALSE);
         END IF;
      EXCEPTION
         WHEN others
          THEN
            Null;
      END;
   END IF;
   RETURN l_retval;
END get_map_item_url_url_only;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_mail_internal (p_from_user        IN nm_mail_message.nmm_from_nmu_id%TYPE
                              ,p_subject          IN nm_mail_message.nmm_subject%TYPE
                              ,p_html_mail        IN boolean DEFAULT TRUE
                              ,p_tab_to           IN nm3mail.tab_recipient
                              ,p_tab_cc           IN nm3mail.tab_recipient
                              ,p_tab_bcc          IN nm3mail.tab_recipient
                              ,p_tab_message_text IN nm3type.tab_varchar32767
                              ) IS
--
   l_currval nm_mail_message.nmm_id%TYPE;
   c_subject CONSTANT nm_mail_message.nmm_subject%TYPE := SUBSTR('[TRID] '||p_subject,1,255);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_mail_internal');
--
   nm3mail.write_mail_complete (p_from_user        => p_from_user
                               ,p_subject          => c_subject
                               ,p_html_mail        => p_html_mail
                               ,p_tab_to           => p_tab_to
                               ,p_tab_cc           => p_tab_cc
                               ,p_tab_bcc          => p_tab_bcc
                               ,p_tab_message_text => p_tab_message_text
                               );
--
   l_currval := nm3seq.curr_nmm_id_seq;
--
   UPDATE nm_mail_message
    SET   nmm_subject = c_subject
   WHERE  nmm_id      = l_currval;
--
   nm_debug.proc_end(g_package_name,'write_mail_internal');
--
END write_mail_internal;
--
-----------------------------------------------------------------------------
--
FUNCTION this_is_a_trid_item (pi_nit_elec_drain_carr VARCHAR2) RETURN BOOLEAN IS
BEGIN
   RETURN pi_nit_elec_drain_carr=c_trid_elec_drain_carr;
END this_is_a_trid_item;
--
-----------------------------------------------------------------------------
--
FUNCTION user_has_normal_module_access (pi_module VARCHAR2
                                       ) RETURN BOOLEAN IS
   l_rec_hmo hig_modules%ROWTYPE;
   l_mode    hig_module_roles.hmr_mode%TYPE;
BEGIN
   hig.get_module_details (pi_module     => pi_module
                          ,po_hmo        => l_rec_hmo
                          ,po_mode       => l_mode
                          );
   RETURN l_mode = nm3type.c_normal;
END user_has_normal_module_access;
--
-----------------------------------------------------------------------------
--
END xtnz_trid;
/
