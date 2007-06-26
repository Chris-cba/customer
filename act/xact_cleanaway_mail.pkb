CREATE OR REPLACE PACKAGE BODY xact_cleanaway_mail AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_cleanaway_mail.pkb	1.1 03/14/05
--       Module Name      : xact_cleanaway_mail.pkb
--       Date into SCCS   : 05/03/14 23:10:53
--       Date fetched Out : 07/06/06 14:33:43
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT Cleanaway Mail package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xact_cleanaway_mail.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xact_cleanaway_mail';
--
   c_xact     CONSTANT VARCHAR2(4) := 'XACT';
   c_nmg_name CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('ACTCLNYGRP');
   g_tab_dac_id nm3type.tab_number;
--
   c_mail_sent         CONSTANT hig_status_codes.hsc_status_code%TYPE := 'MS';
   c_mail_receipted    CONSTANT hig_status_codes.hsc_status_code%TYPE := 'MR';
   c_request_actioned  CONSTANT hig_status_codes.hsc_status_code%TYPE := 'RA';
   c_request_scheduled CONSTANT hig_status_codes.hsc_status_code%TYPE := 'RS';
--
   c_equals         CONSTANT VARCHAR2(1) := '=';
   c_bar            CONSTANT VARCHAR2(1) := '|';
--
-----------------------------------------------------------------------------
--
PROCEDURE create_mail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_bs_iit (p_doc_id docs.doc_id%TYPE) RETURN nm_inv_items%ROWTYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION split_string_into_words (p_string VARCHAR2) RETURN nm3type.tab_varchar80;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_nmpmd
                     (pi_tab_nmpmd IN     nm3mail_pop.tab_nmpmd
                     );
--
-----------------------------------------------------------------------------
--
FUNCTION get_field_value (p_field VARCHAR2) RETURN VARCHAR2;
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
PROCEDURE process_action (p_nmpm_id nm_mail_pop_messages.nmpm_id%TYPE) IS
--
   l_rec_nmpm        nm_mail_pop_messages%ROWTYPE;
   l_tab_nmpmh       nm3mail_pop.tab_nmpmh;
   l_tab_nmpmd       nm3mail_pop.tab_nmpmd;
   l_tab_nmpmr       nm3mail_pop.tab_nmpmr;
   l_type            nm3type.max_varchar2;
   l_dac_id          NUMBER;
   l_doc_id          NUMBER;
   l_sender          nm3type.max_varchar2;
   l_cleanaway_ref   nm3type.max_varchar2;
   l_council_action  nm3type.max_varchar2;
   l_originator_name nm3type.max_varchar2;
   l_csc_comments    nm3type.max_varchar2;
   l_dac_outcome     nm3type.max_varchar2;
   l_dac_status      doc_actions.dac_status%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'process_action');
--
   nm3mail_pop.retrieve_all_message_data
                       (pi_nmpm_id   => p_nmpm_id
                       ,po_rec_nmpm  => l_rec_nmpm
                       ,po_tab_nmpmh => l_tab_nmpmh
                       ,po_tab_nmpmd => l_tab_nmpmd
                       ,po_tab_nmpmr => l_tab_nmpmr
                       );
--
   process_tab_nmpmd (pi_tab_nmpmd => l_tab_nmpmd);
--
   l_type := get_field_value ('STATUS');
--   nm_debug.debug(get_field_value('STATUS'));
--   nm_debug.debug(get_field_value('COUNCIL REF'));
--   nm_debug.debug(get_field_value('CLEANAWAY ID'));
   l_doc_id          := get_field_value('TICKET NUMBER');
   l_dac_id          := get_field_value('COUNCIL REF');
   l_sender          := get_field_value('SENDER');
   l_cleanaway_ref   := get_field_value('CLEANAWAY ID');
   l_council_action  := get_field_value('COUNCIL ACTION');
   l_originator_name := get_field_value('ORIGINATOR NAME');
   l_csc_comments    := get_field_value('CSC COMMENTS');
   l_dac_outcome     := l_council_action;
--
   IF l_dac_outcome IS NOT NULL
    THEN
      l_dac_outcome  := l_dac_outcome||'.';
   END IF;
   l_dac_outcome     := l_dac_outcome||l_csc_comments;
   IF l_type = 'CSC'
    THEN
      l_dac_status := c_mail_receipted;
   ELSIF l_type = 'MGB'
    THEN
      l_dac_status := c_request_scheduled;
   ELSIF l_type = 'CMP'
    THEN
      l_dac_status := c_request_actioned;
      --
      -- do the rest of the guff here
      --
   END IF;
--
   IF l_dac_status IS NOT NULL
    THEN
      UPDATE doc_actions
       SET   dac_status    = l_dac_status
            ,dac_reference = SUBSTR(l_cleanaway_ref,1,30)
            ,dac_outcome   = SUBSTR(l_dac_outcome,1,255)
            ,dac_assignee  = SUBSTR(l_originator_name,1,65)
      WHERE  dac_id        = l_dac_id;
   END IF;
--
   FOR i IN 1..g_tab_field.COUNT
    LOOP
      nm_debug.debug(g_tab_field(i)||'....'||g_tab_value(i)||'....'||g_tab_comment(i));
   END LOOP;
--
   nm_debug.proc_end (g_package_name, 'process_action');
--
END process_action;
--
-----------------------------------------------------------------------------
--
FUNCTION get_field_value (p_field VARCHAR2) RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
--
   FOR i IN 1..g_tab_field.COUNT
    LOOP
      IF g_tab_field(i) = p_field
       THEN
         l_retval := g_tab_value(i);
         EXIT;
      END IF;
   END LOOP;
--
   RETURN l_retval;
--
END get_field_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE chop_line (pi_line  IN     VARCHAR2
                    ,pi_chr   IN     VARCHAR2
                    ,po_field    OUT VARCHAR2
                    ,po_value    OUT VARCHAR2
                    ) IS
   --
   null_line EXCEPTION;
   l_instr   PLS_INTEGER;
   --
BEGIN
   --
   IF pi_line IS NULL
    THEN
      RAISE null_line;
   END IF;
   --
   l_instr  := INSTR(pi_line,pi_chr,1,1);
   --
   IF l_instr != 0
    THEN
      po_field := RTRIM(nm3flx.LEFT(pi_line,(l_instr-1)),' ');
      po_value := LTRIM(SUBSTR(pi_line,(l_instr+1)),' ');
   ELSE
      po_field := pi_line;
   END IF;
   --
EXCEPTION
   WHEN null_line
    THEN
      Null;
END chop_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_nmpmd
                     (pi_tab_nmpmd IN     nm3mail_pop.tab_nmpmd
                     ) IS
--
   l_field      nm3type.max_varchar2;
   l_value      nm3type.max_varchar2;
   l_value_only nm3type.max_varchar2;
   l_comment    nm3type.max_varchar2;
   l_count      PLS_INTEGER := 0;
--
BEGIN
--
   g_tab_field.DELETE;
   g_tab_value.DELETE;
--
   FOR i IN 1..pi_tab_nmpmd.COUNT
    LOOP
      chop_line (pi_tab_nmpmd(i).nmpmd_text, c_equals, l_field, l_value);
      IF l_field IS NOT NULL
       THEN
         chop_line (l_value, c_bar, l_value_only, l_comment);
         l_count                := l_count + 1;
         g_tab_field(l_count)   := l_field;
         g_tab_value(l_count)   := l_value_only;
         g_tab_comment(l_count) := l_comment;
      END IF;
   END LOOP;
--
END process_tab_nmpmd;
--
-----------------------------------------------------------------------------
--
--PROCEDURE process_acknowledgement (p_nmpm_id nm_mail_pop_messages.nmpm_id%TYPE) IS
----
--   l_rec_nmpm   nm_mail_pop_messages%ROWTYPE;
--   l_tab_nmpmh  nm3mail_pop.tab_nmpmh;
--   l_tab_nmpmd  nm3mail_pop.tab_nmpmd;
--   l_tab_nmpmr  nm3mail_pop.tab_nmpmr;
----
--BEGIN
----
--   nm_debug.set_level(4);
--   nm_debug.proc_start (g_package_name, 'process_acknowledgement');
--   nm_debug.set_level(3);
----
--   nm3mail_pop.retrieve_all_message_data
--                       (pi_nmpm_id   => p_nmpm_id
--                       ,po_rec_nmpm  => l_rec_nmpm
--                       ,po_tab_nmpmh => l_tab_nmpmh
--                       ,po_tab_nmpmd => l_tab_nmpmd
--                       ,po_tab_nmpmr => l_tab_nmpmr
--                       );
----
--   nm_debug.proc_end (g_package_name, 'process_acknowledgement');
----
--END process_acknowledgement;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_cleanaway_mail (p_dac_id doc_actions.dac_id%TYPE) IS
BEGIN
--
   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
   nm_debug.proc_start (g_package_name, 'send_cleanaway_mail');
--
   g_rec_dac := nm3get.get_dac (pi_dac_id => p_dac_id);
   g_rec_doc := nm3get.get_doc (pi_doc_id => g_rec_dac.dac_doc_id);
--
   IF (g_rec_doc.doc_dtp_code = 'REQS' AND g_rec_doc.doc_dcl_code IN ('GR','RC'))
    THEN
      create_mail;
   END IF;
--
   nm_debug.proc_end (g_package_name, 'send_cleanaway_mail');
   nm_debug.debug_off;
--
END send_cleanaway_mail;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_mail IS
--
   l_sql          nm3type.tab_varchar32767;
   TYPE tab_rec_xcfs IS TABLE OF xact_cleanaway_field_source%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_xcfs tab_rec_xcfs;
   l_tab_lines    nm3type.tab_varchar32767;
   l_line         nm3type.max_varchar2;
   l_dec_hct_id   nm3type.tab_number;
   l_hca_had_id   nm3type.tab_number;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_sql, p_text, p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'create_mail');
--
   -- get the associated BS inventory item
   g_rec_iit := get_bs_iit (g_rec_doc.doc_id);
--
   SELECT dec_hct_id
    BULK  COLLECT
    INTO  l_dec_hct_id
    FROM  doc_enquiry_contacts
   WHERE  dec_doc_id  = g_rec_doc.doc_id
    AND   dec_contact = 'Y';
--
   IF l_dec_hct_id.COUNT = 0
    THEN
      hig.raise_ner (pi_appl => c_xact
                    ,pi_id   => 3
                    );
   ELSIF l_dec_hct_id.COUNT > 1
    THEN
      hig.raise_ner (pi_appl => c_xact
                    ,pi_id   => 4
                    );
   END IF;
--
   g_rec_hct := nm3get.get_hct (pi_hct_id => l_dec_hct_id(1));
--
   SELECT hca_had_id
    BULK  COLLECT
    INTO  l_hca_had_id
    FROM  hig_contact_address
   WHERE  hca_hct_id = g_rec_hct.hct_id;
--
   IF l_hca_had_id.COUNT = 0
    THEN
      hig.raise_ner (pi_appl => c_xact
                    ,pi_id   => 5
                    );
   ELSIF l_hca_had_id.COUNT > 1
    THEN
      hig.raise_ner (pi_appl => c_xact
                    ,pi_id   => 6
                    );
   END IF;
--
   g_rec_had := nm3get.get_had (pi_had_id => l_hca_had_id(1));
--
   SELECT *
    BULK  COLLECT
    INTO  l_tab_rec_xcfs
    FROM  xact_cleanaway_field_source
   ORDER BY xcfs_seq;
--
   l_sql.DELETE;
--
   append ('DECLARE',FALSE);
   append ('--');
   append ('   PROCEDURE add_value (p_index PLS_INTEGER, p_value VARCHAR2, p_comment VARCHAR2) IS');
   append ('   BEGIN');
   append ('      '||g_package_name||'.g_tab_value(p_index)   := p_value;');
   append ('      '||g_package_name||'.g_tab_comment(p_index) := p_comment;');
   append ('   END add_value;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   Null;');
   append ('--');
   FOR i IN 1..l_tab_rec_xcfs.COUNT
    LOOP
      append ('   add_value ('||i||','||NVL(l_tab_rec_xcfs(i).xcfs_data_source,'Null')||','||NVL(l_tab_rec_xcfs(i).xcfs_comment_source,'Null')||');');
   END LOOP;
   append ('--');
   append ('END;');
--
   g_tab_value.DELETE;
   nm3ddl.execute_tab_varchar(l_sql);
--
   FOR i IN 1..l_tab_rec_xcfs.COUNT
    LOOP
      IF   l_tab_rec_xcfs(i).xcfs_mandatory = 'Y'
       AND g_tab_value(i) IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 50
                       ,pi_supplementary_info => l_tab_rec_xcfs(i).xcfs_data_item
                       );
      END IF;
      l_line := l_tab_rec_xcfs(i).xcfs_data_item||c_equals||g_tab_value(i);
      IF g_tab_comment(i) IS NOT NULL
       THEN
         l_line := l_line||c_bar||g_tab_comment(i);
      END IF;
      l_line := l_line||nm3mail.c_crlf;
      l_tab_lines(l_tab_lines.COUNT+1) := l_line;
   END LOOP;
--
   DECLARE
--
      CURSOR cs_nmg (c_nmg_name VARCHAR2) IS
      SELECT nmg_id
       FROM  nm_mail_groups
      WHERE  nmg_name = c_nmg_name;
--
      l_nmu_id nm_mail_users.nmu_id%TYPE;
      l_found  BOOLEAN;
--
      l_tab_to  nm3mail.tab_recipient;
      l_tab_cc  nm3mail.tab_recipient;
      l_tab_bcc nm3mail.tab_recipient;
--
      l_rec_recipient nm3mail.rec_recipient;
--
   BEGIN
--
      l_nmu_id := nm3mail.get_current_nmu_id;
--
      OPEN  cs_nmg (c_nmg_name);
      FETCH cs_nmg
       INTO l_rec_recipient.rcpt_id;
      l_found := cs_nmg%FOUND;
      CLOSE cs_nmg;
      --
      IF NOT l_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'NM_MAIL_GROUPS.NMG_NAME="'||c_nmg_name||'"'
                       );
      END IF;
      --
      l_rec_recipient.rcpt_type := nm3mail.c_group;
      l_tab_to(1)               := l_rec_recipient;
      --
--      nm3file.write_file (filename     => g_rec_doc.doc_id||'.txt'
--                         ,max_linesize => 32767
--                         ,all_lines    => l_tab_lines
--                         );
--
      nm3mail.write_mail_complete
                    (p_from_user        => l_nmu_id
                    ,p_subject          => g_rec_doc.doc_id
                    ,p_html_mail        => FALSE
                    ,p_tab_to           => l_tab_to
                    ,p_tab_cc           => l_tab_cc
                    ,p_tab_bcc          => l_tab_bcc
                    ,p_tab_message_text => l_tab_lines
                    );
--
   END;
--
   UPDATE doc_actions
    SET   dac_status = c_mail_sent
   WHERE  dac_id     = g_rec_dac.dac_id;
--
   nm_debug.proc_end (g_package_name, 'create_mail');
--
END create_mail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_bs_iit (p_doc_id docs.doc_id%TYPE) RETURN nm_inv_items%ROWTYPE IS
    l_tab_rec_iit nm3type.tab_rec_iit;
    l_rec_iit     nm_inv_items%ROWTYPE;
BEGIN
--
   SELECT  iit.*
    BULK   COLLECT
    INTO   l_tab_rec_iit
    FROM   doc_assocs   das
          ,nm_inv_items iit
   WHERE   das_table_name = 'V_NM_BS'
    AND    das_rec_id     = iit_primary_key
    AND    das_doc_id     = g_rec_doc.doc_id
    AND    iit_inv_type   = 'BS';
--
   IF    l_tab_rec_iit.COUNT = 0
    THEN
      l_tab_rec_iit(1) := l_rec_iit;
--      hig.raise_ner (pi_appl => c_xact
--                    ,pi_id   => 1
--                    );
   ELSIF l_tab_rec_iit.COUNT > 1
    THEN
      hig.raise_ner (pi_appl => c_xact
                    ,pi_id   => 2
                    );
   END IF;
--
   RETURN l_tab_rec_iit(1);
--
END get_bs_iit;
--
-----------------------------------------------------------------------------
--
FUNCTION get_street_name (p_full_street_name VARCHAR2) RETURN VARCHAR2 IS
   l_retval    nm3type.max_varchar2;
   l_tab_words nm3type.tab_varchar80;
BEGIN
--
   l_tab_words := split_string_into_words (p_full_street_name);
   FOR i IN 1..GREATEST((l_tab_words.COUNT-1),1)
    LOOP
      IF i > 1
       THEN
         l_retval := l_retval||' ';
      END IF;
      l_retval := l_retval||l_tab_words(i);
   END LOOP;
--
   RETURN l_retval;
--
END get_street_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_street_type (p_full_street_name VARCHAR2) RETURN VARCHAR2 IS
--
   l_retval      nm3type.max_varchar2;
   l_tab_words   nm3type.tab_varchar80;
   l_street_type nm3type.max_varchar2;
--
   c_domain CONSTANT hig_domains.hdo_domain%TYPE := 'ACT ROAD TYPES';
   l_found           BOOLEAN;
--
   CURSOR cs_hco (c_domain VARCHAR2, c_street_type VARCHAR2) IS
   SELECT hco_code
    FROM  hig_codes
   WHERE  hco_domain  = c_domain
    AND   hco_meaning = c_street_type;
--
BEGIN
--
   l_tab_words   := split_string_into_words (p_full_street_name);
--
   l_street_type := l_tab_words(l_tab_words.COUNT);
--
   l_retval :=  nm3get.get_hco (pi_hco_domain      => c_domain
                               ,pi_hco_code        => l_street_type
                               ,pi_raise_not_found => FALSE
                               ).hco_code;
--
   IF l_retval IS NULL
    THEN
      OPEN  cs_hco (c_domain,l_street_type);
      FETCH cs_hco INTO l_retval;
      l_found := cs_hco%FOUND;
      CLOSE cs_hco;
      IF NOT l_found
       THEN
         hig.raise_ner (pi_appl               => c_xact
                       ,pi_id                 => 7
                       ,pi_supplementary_info => l_street_type
                       );
      END IF;
   END IF;
--
   RETURN l_retval;
--
END get_street_type;
--
-----------------------------------------------------------------------------
--
FUNCTION split_string_into_words (p_string VARCHAR2) RETURN nm3type.tab_varchar80 IS
   l_tab_words nm3type.tab_varchar80;
   l_count     PLS_INTEGER := 1;
   l_start_pos PLS_INTEGER;
   l_end_pos   PLS_INTEGER;
   l_space     PLS_INTEGER;
   l_word      nm3type.max_varchar2;
BEGIN
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.debug(p_string);
   IF p_string IS NOT NULL
    THEN
      l_space := -1; -- dummy val
      WHILE l_space != 0
       LOOP
--
         l_space := INSTR(p_string,' ',1,l_count);
         l_tab_words(l_count) := Null;
--
         IF l_count = 1
          THEN
            l_start_pos := 1;
         ELSE
            l_start_pos := INSTR(p_string,' ',1,(l_count-1))+1;
         END IF;
--
         l_end_pos      := INSTR(p_string,' ',1,l_count)-1;
--
         IF l_end_pos <= 0
          THEN
            l_word      := SUBSTR(p_string, (l_start_pos));
         ELSE
            l_word      := nm3flx.mid (p_string
                                      ,l_start_pos
                                      ,l_end_pos
                                      );
         END IF;
--
         l_tab_words(l_count) := l_word;
         l_count := l_count + 1;
--
      END LOOP;
--
      IF l_tab_words.COUNT = 0
       THEN
         l_tab_words(1) := p_string;
      END IF;
--
   END IF;
--
   RETURN l_tab_words;
--
END split_string_into_words;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_dac (pi_dac_id doc_actions.dac_id%TYPE) IS
BEGIN
--
   g_tab_dac_id(g_tab_dac_id.COUNT+1) := pi_dac_id;
--
END append_dac;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_dac_array IS
BEGIN
--
   g_tab_dac_id.DELETE;
--
END clear_dac_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_dac_array IS
BEGIN
--
   FOR i IN 1..g_tab_dac_id.COUNT
    LOOP
      send_cleanaway_mail (p_dac_id => g_tab_dac_id(i));
   END LOOP;
--
   clear_dac_array;
--
END process_dac_array;
--
-----------------------------------------------------------------------------
--
FUNCTION get_address RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
--
   IF g_rec_had.had_sub_building_name_no IS NOT NULL
    THEN
      l_retval := g_rec_had.had_sub_building_name_no||'/';
   END IF;
--
   l_retval :=   l_retval
               ||g_rec_had.had_building_no
               ||' '
               ||g_rec_had.had_thoroughfare
               ||' '
               ||g_rec_had.had_post_town
               ||' '
               ||g_rec_had.had_postcode;
--
   RETURN l_retval;
--
END get_address;
--
-----------------------------------------------------------------------------
--
FUNCTION get_full_name RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
   PROCEDURE add_if_there (p_val VARCHAR2) IS
   BEGIN
      IF p_val IS NOT NULL
       THEN
         IF l_retval IS NOT NULL
          THEN
            l_retval := l_retval||' ';
         END IF;
         l_retval := l_retval||p_val;
      END IF;
   END add_if_there;
BEGIN
--
   add_if_there (g_rec_hct.hct_title);
   add_if_there (g_rec_hct.hct_first_name);
   add_if_there (g_rec_hct.hct_middle_initial);
   add_if_there (g_rec_hct.hct_surname);
--
   RETURN l_retval;
--
END get_full_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_complaint_code RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   RETURN l_retval;
END get_complaint_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_transaction_code RETURN VARCHAR2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
-- ADDS Additional Services
-- ASST Assistance Required
-- DMG  Damaged
-- NEW  New
-- REP  Replacement of lost/stolen
-- RMA  Withdrawal of Assistance
-- RMN  Withdrawal
-- RMNA Withdrawal of add services
--
   IF    g_rec_doc.doc_compl_type = 'ADDS'
    THEN
      l_retval := 'N';
   ELSIF g_rec_doc.doc_compl_type = 'ASST'
    THEN
      l_retval := 'IF';
   ELSIF g_rec_doc.doc_compl_type = 'DMG'
    THEN
      l_retval := 'R';
   ELSIF g_rec_doc.doc_compl_type = 'NEW'
    THEN
      l_retval := 'N';
   ELSIF g_rec_doc.doc_compl_type = 'REP'
    THEN
      l_retval := 'X';
   ELSIF g_rec_doc.doc_compl_type = 'RMA'
    THEN
      l_retval := 'CF';
   ELSIF g_rec_doc.doc_compl_type = 'RMN'
    THEN
      l_retval := 'C';
   ELSIF g_rec_doc.doc_compl_type = 'RMNA'
    THEN
      l_retval := 'C';
   END IF;
--
   RETURN l_retval;
--
END get_transaction_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_contract_code_comment RETURN VARCHAR2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
   l_retval := nm3get.get_dcl (pi_dcl_dtp_code    => g_rec_doc.doc_dtp_code
                              ,pi_dcl_code        => g_rec_doc.doc_dcl_code
                              ,pi_raise_not_found => FALSE
                              ).dcl_name;
   RETURN l_retval;
END get_contract_code_comment;
--
-----------------------------------------------------------------------------
--
FUNCTION get_contract_code RETURN VARCHAR2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
   IF    g_rec_doc.doc_compl_type IN ('ASST','RMA','RMNA')
    THEN
      l_retval := 'M';
   ELSIF g_rec_doc.doc_dcl_code = 'GR'
    THEN
      l_retval := 'D';
   ELSIF g_rec_doc.doc_dcl_code = 'RC'
    THEN
      l_retval := 'R';
   END IF;
--
   RETURN l_retval;
--
END get_contract_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_transaction_code_comment RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   l_retval := nm3get.get_det (pi_det_dtp_code    => g_rec_doc.doc_dtp_code
                              ,pi_det_dcl_code    => g_rec_doc.doc_dcl_code
                              ,pi_det_code        => g_rec_doc.doc_compl_type
                              ,pi_raise_not_found => FALSE
                              ).det_name;
   RETURN l_retval;
END get_transaction_code_comment;
--
-----------------------------------------------------------------------------
--
END xact_cleanaway_mail;
/
