CREATE OR REPLACE PACKAGE BODY xmrwa_travel_time AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_travel_time.pkb	1.1 03/15/05
--       Module Name      : xmrwa_travel_time.pkb
--       Date into SCCS   : 05/03/15 00:46:08
--       Date fetched Out : 07/06/06 14:38:34
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   MRWA Travel Time package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_travel_time.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xmrwa_travel_time';
--
   g_tab_text nm3type.tab_varchar32767;
   c_notify_travel_mail_group CONSTANT VARCHAR2(30) := 'NET_NOTIFY_TRAVEL';
   c_date_mask CONSTANT VARCHAR2(40) := nm3user.get_user_date_mask;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmg_id (p_nmg_name nm_mail_groups.nmg_name%TYPE) RETURN nm_mail_groups.nmg_id%TYPE;
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
PROCEDURE do_element_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_asset_detail;
--
-----------------------------------------------------------------------------
--
   PROCEDURE append (p_text VARCHAR2) IS
      l_text nm3type.max_varchar2 := p_text;
   BEGIN
--      IF p_nl
--       THEN
--         l_text := l_text||htf.br;
--      END IF;
      g_tab_text(g_tab_text.COUNT+1) := l_text;

--      nm3tab_varchar.append (g_tab_text, l_text);
   END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_mod_by_pair (p_modified_by VARCHAR2, p_modified_date DATE) IS
   l_mod_by nm3type.max_varchar2;
BEGIN
   l_mod_by := nm3get.get_hus (pi_hus_username => p_modified_by).hus_name;
   l_mod_by := l_mod_by||' ('||p_modified_by||')';
   append (htf.br);
   append ('<TABLE BORDER=1>');
   append_value_pair ('Modified By',l_mod_by);
   append_value_pair ('Modified Date',TO_CHAR(p_modified_date,nm3type.c_full_date_time_format));
   append ('</TABLE>');
   append (htf.br);
END do_mod_by_pair;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_table_header IS
BEGIN
   append ('<TABLE BORDER=1>');
   append ('<TR><TH>Attribute</TH><TH>Old</TH><TH>New</TH></TR>');
END do_table_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_value_pair (p_boilertext VARCHAR2
                            ,p_value      VARCHAR2
                            ) IS
BEGIN
   append ('<TR><TH>'||p_boilertext||'</TH><TD>'||NVL(p_value,nm3web.c_nbsp)||'</TD></TR>');
END append_value_pair;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_value_triplet (p_boilertext VARCHAR2
                               ,p_value      VARCHAR2
                               ,p_value2     VARCHAR2
                               ) IS
   l_old_val    nm3type.max_varchar2 := nm3web.replace_chevrons(NVL(p_value,nm3web.c_nbsp));
   l_new_val    nm3type.max_varchar2 := nm3web.replace_chevrons(NVL(p_value2,nm3web.c_nbsp));
   l_boilertext nm3type.max_varchar2 := p_boilertext;
BEGIN
   IF l_old_val != l_new_val
    THEN
      l_boilertext := '<TH><FONT COLOR=RED>'||l_boilertext||'</FONT></TH>';
   ELSE
      l_boilertext := '<TD ALIGN=CENTER>'||l_boilertext||'</TD>';
   END IF;
   append ('<TR>'||l_boilertext||'<TD>'||l_old_val||'</TD><TD>'||l_new_val||'</TD></TR>');
END append_value_triplet;
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
PROCEDURE fire_mem_change_email (p_prefix VARCHAR2) IS
--
   l_tab_to        nm3mail.tab_recipient;
   l_tab_cc        nm3mail.tab_recipient;
   l_tab_bcc       nm3mail.tab_recipient;
   l_from_nmu_id   nm_mail_users.nmu_id%TYPE;
   l_nmg_id        nm_mail_groups.nmg_id%TYPE;
   l_subject       nm_mail_message.nmm_subject%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'fire_mem_change_email');
--
   l_from_nmu_id := nm3mail.get_current_nmu_id;
   l_nmg_id      := get_nmg_id (c_notify_travel_mail_group);
--
   l_tab_to.DELETE;
   l_tab_to(1).rcpt_id        := l_nmg_id;
   l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
   g_tab_text.DELETE;
   do_table_header;
--
   IF g_rec_nm_new.nm_type = 'G'
    THEN
      g_rec_ne_old := nm3get.get_ne_all (pi_ne_id           => g_rec_nm_old.nm_ne_id_in
                                        ,pi_raise_not_found => FALSE
                                        );
      g_rec_ne_new := nm3get.get_ne_all (pi_ne_id           => g_rec_nm_old.nm_ne_id_in
                                        ,pi_raise_not_found => FALSE
                                        );
      append ('<TR><TH COLSPAN=3>Parent Route</TH></TR>');
      do_element_detail;
   ELSIF g_rec_nm_new.nm_type = 'I'
    THEN
      g_rec_iit_old := nm3get.get_iit_all (pi_iit_ne_id       => g_rec_nm_old.nm_ne_id_in
                                          ,pi_raise_not_found => FALSE
                                          );
      g_rec_iit_new := nm3get.get_iit_all (pi_iit_ne_id       => g_rec_nm_old.nm_ne_id_in
                                          ,pi_raise_not_found => FALSE
                                          );
      append ('<TR><TH COLSPAN=3>Inventory Item</TH></TR>');
      do_asset_detail;
   END IF;
--
   g_rec_ne_old := nm3get.get_ne_all (pi_ne_id           => g_rec_nm_old.nm_ne_id_of
                                     ,pi_raise_not_found => FALSE
                                     );
   g_rec_ne_new := nm3get.get_ne_all (pi_ne_id           => g_rec_nm_old.nm_ne_id_of
                                     ,pi_raise_not_found => FALSE
                                     );
   append ('<TR><TH COLSPAN=3>Datum Element</TH></TR>');
   do_element_detail;
--
   append ('<TR><TH COLSPAN=3>Member Details</TH></TR>');
   append_value_triplet ('Start Date'
                        ,TO_CHAR(g_rec_nm_old.nm_start_date,c_date_mask)
                        ,TO_CHAR(g_rec_nm_new.nm_start_date,c_date_mask)
                        );
   append_value_triplet ('End Date'
                        ,TO_CHAR(g_rec_nm_old.nm_end_date,c_date_mask)
                        ,TO_CHAR(g_rec_nm_new.nm_end_date,c_date_mask)
                        );
   append_value_triplet ('Begin MP'
                        ,g_rec_nm_old.nm_begin_mp
                        ,g_rec_nm_new.nm_begin_mp
                        );
   append_value_triplet ('End MP'
                        ,g_rec_nm_old.nm_end_mp
                        ,g_rec_nm_new.nm_end_mp
                        );
   append_value_triplet ('Cardinality'
                        ,nm3flx.i_t_e(g_rec_nm_old.nm_cardinality=1,'+','-')
                        ,nm3flx.i_t_e(g_rec_nm_new.nm_cardinality=1,'+','-')
                        );
   append_value_triplet ('SLK'
                        ,g_rec_nm_old.nm_slk
                        ,g_rec_nm_new.nm_slk
                        );
   append_value_triplet ('True'
                        ,g_rec_nm_old.nm_true
                        ,g_rec_nm_new.nm_true
                        );
--
   append ('</TABLE>');
--
   do_mod_by_pair (g_rec_nm_new.nm_modified_by,g_rec_nm_new.nm_date_modified);
--
   write_mail_internal (p_from_user        => l_from_nmu_id
                       ,p_subject          => nm3flx.i_t_e(g_rec_nm_new.nm_type='I','Group','Inventory')||' Membership Change ('||p_prefix||')'
                       ,p_html_mail        => TRUE
                       ,p_tab_to           => l_tab_to
                       ,p_tab_cc           => l_tab_cc
                       ,p_tab_bcc          => l_tab_bcc
                       ,p_tab_message_text => g_tab_text
                       );
--
   nm_debug.proc_end(g_package_name,'fire_mem_change_email');
--
END fire_mem_change_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE fire_nw_op_email (p_ne_id_old NUMBER
                           ,p_ne_id_new NUMBER
                           ,p_operation VARCHAR2
                           ,p_eff_date  DATE
                           ) IS
   c_eff_date CONSTANT DATE := nm3user.get_effective_date;
BEGIN
--
   nm_debug.proc_start(g_package_name,'fire_nw_op_email');
--
   DECLARE
   --
      CURSOR cs_mem_chk (c_ne_id NUMBER) IS
      SELECT 1
       FROM  nm_members
      WHERE  nm_ne_id_of = c_ne_id
       AND   nm_type     = 'G'
       AND   nm_obj_type||Null = 'TRAV';
   --
      l_no_trav_route EXCEPTION;
      l_dummy         PLS_INTEGER;
      l_found         BOOLEAN;
      l_prefix        hig_codes.hco_meaning%TYPE;
   --
   BEGIN
   --
      nm3user.set_effective_date (p_eff_date-1);
      OPEN  cs_mem_chk (p_ne_id_old);
      FETCH cs_mem_chk INTO l_dummy;
      l_found := cs_mem_chk%FOUND;
      CLOSE cs_mem_chk;
   --
      IF NOT l_found
       THEN
         nm3user.set_effective_date (p_eff_date);
         OPEN  cs_mem_chk (p_ne_id_new);
         FETCH cs_mem_chk INTO l_dummy;
         l_found := cs_mem_chk%FOUND;
         CLOSE cs_mem_chk;
         IF NOT l_found
          THEN
            RAISE l_no_trav_route;
         END IF;
      END IF;
      nm3user.set_effective_date (c_eff_date);
   --
      g_rec_ne_old := nm3get.get_ne_all (pi_ne_id => p_ne_id_old);
      g_rec_ne_new := nm3get.get_ne_all (pi_ne_id => p_ne_id_new);
   --
      l_prefix := NVL(nm3get.get_hco (pi_hco_domain      => 'HISTORY_OPERATION'
                                     ,pi_hco_code        => p_operation
                                     ,pi_raise_not_found => FALSE
                                     ).hco_meaning
                     ,p_operation
                     );
   --
      fire_group_change_email (p_subject_prefix => l_prefix);
   --
   EXCEPTION
      WHEN l_no_trav_route
       THEN
         nm3user.set_effective_date (c_eff_date);
   END;
--
   nm_debug.proc_end(g_package_name,'fire_nw_op_email');
--
END fire_nw_op_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE fire_group_change_email (p_subject_prefix VARCHAR2) IS
--
   l_tab_to        nm3mail.tab_recipient;
   l_tab_cc        nm3mail.tab_recipient;
   l_tab_bcc       nm3mail.tab_recipient;
   l_from_nmu_id   nm_mail_users.nmu_id%TYPE;
   l_nmg_id        nm_mail_groups.nmg_id%TYPE;
   l_subject       nm_mail_message.nmm_subject%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'fire_group_change_email');
--
   l_from_nmu_id := nm3mail.get_current_nmu_id;
   l_nmg_id      := get_nmg_id (c_notify_travel_mail_group);
--
   l_tab_to.DELETE;
   l_tab_to(1).rcpt_id        := l_nmg_id;
   l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
   g_tab_text.DELETE;
   do_table_header;
   do_element_detail;
   append ('</TABLE>');
--
   do_mod_by_pair (g_rec_ne_new.ne_modified_by,g_rec_ne_new.ne_date_modified);
--
   IF g_rec_ne_new.ne_gty_group_type IS NOT NULL
    THEN
      l_subject := p_subject_prefix||' '||nm3get.get_ngt(pi_ngt_group_type => g_rec_ne_new.ne_gty_group_type).ngt_descr||' Route';
   ELSE
      l_subject := 'Network Operation - '||p_subject_prefix;
   END IF;
--
   write_mail_internal (p_from_user        => l_from_nmu_id
                       ,p_subject          => l_subject
                       ,p_html_mail        => TRUE
                       ,p_tab_to           => l_tab_to
                       ,p_tab_cc           => l_tab_cc
                       ,p_tab_bcc          => l_tab_bcc
                       ,p_tab_message_text => g_tab_text
                       );
--
   nm_debug.proc_end(g_package_name,'fire_group_change_email');
--
END fire_group_change_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_element_detail IS
   l_block nm3type.tab_varchar32767;
BEGIN
   l_block.DELETE;
   append_value_triplet ('Unique'
                        ,g_rec_ne_old.ne_unique
                        ,g_rec_ne_new.ne_unique
                        );
   append_value_triplet ('Description'
                        ,g_rec_ne_old.ne_descr
                        ,g_rec_ne_new.ne_descr
                        );
   append_value_triplet ('Start Date'
                        ,TO_CHAR(g_rec_ne_old.ne_start_date,c_date_mask)
                        ,TO_CHAR(g_rec_ne_new.ne_start_date,c_date_mask)
                        );
   append_value_triplet ('End Date'
                        ,TO_CHAR(g_rec_ne_old.ne_end_date,c_date_mask)
                        ,TO_CHAR(g_rec_ne_new.ne_end_date,c_date_mask)
                        );
   nm3tab_varchar.append(l_block,'BEGIN',FALSE);
   nm3tab_varchar.append(l_block,'   Null;');
   FOR cs_rec IN (SELECT ntc_column_name, ntc_prompt
                   FROM  nm_type_columns
                  WHERE  ntc_nt_type = g_rec_ne_old.ne_nt_type
                   AND   ntc_displayed = 'Y'
                  ORDER BY ntc_seq_no
                 )
    LOOP
      nm3tab_varchar.append(l_block
                           ,'   '||g_package_name||'.append_value_triplet('||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.ntc_prompt))
                                                                      ||','||g_package_name||'.g_rec_ne_old.'||cs_rec.ntc_column_name
                                                                      ||','||g_package_name||'.g_rec_ne_new.'||cs_rec.ntc_column_name
                                                                      ||');'
                          );
   END LOOP;
   nm3tab_varchar.append(l_block,'END;');
   nm3ddl.execute_tab_varchar (l_block);
END do_element_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE fire_inv_change_email IS
--
   l_tab_to        nm3mail.tab_recipient;
   l_tab_cc        nm3mail.tab_recipient;
   l_tab_bcc       nm3mail.tab_recipient;
   l_from_nmu_id   nm_mail_users.nmu_id%TYPE;
   l_nmg_id        nm_mail_groups.nmg_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'fire_inv_change_email');
--
--   g_rec_iit := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id);
--
   l_from_nmu_id := nm3mail.get_current_nmu_id;
   l_nmg_id      := get_nmg_id (c_notify_travel_mail_group);
--
   l_tab_to.DELETE;
   l_tab_to(1).rcpt_id        := l_nmg_id;
   l_tab_to(1).rcpt_type      := nm3mail.c_group;
--
   g_tab_text.DELETE;
   do_table_header;
   do_asset_detail;
   append ('</TABLE>');
   do_mod_by_pair (g_rec_iit_new.iit_modified_by, g_rec_iit_new.iit_date_modified);
--
   write_mail_internal (p_from_user        => l_from_nmu_id
                       ,p_subject          => 'Updated '||nm3get.get_nit(pi_nit_inv_type => g_rec_iit_new.iit_inv_type).nit_descr||' Inventory'
                       ,p_html_mail        => TRUE
                       ,p_tab_to           => l_tab_to
                       ,p_tab_cc           => l_tab_cc
                       ,p_tab_bcc          => l_tab_bcc
                       ,p_tab_message_text => g_tab_text
                       );
--
   nm_debug.proc_end(g_package_name,'fire_inv_change_email');
--
END fire_inv_change_email;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_asset_detail IS
   l_block nm3type.tab_varchar32767;
   l_tab_ita       nm3inv.tab_nita;
BEGIN
   l_tab_ita  := nm3inv.get_tab_ita (g_rec_iit_new.iit_inv_type);
   l_block.DELETE;
   append_value_triplet ('Primary Key'
                        ,g_rec_iit_old.iit_primary_key
                        ,g_rec_iit_new.iit_primary_key
                        );
   append_value_triplet ('Description'
                        ,g_rec_iit_old.iit_descr
                        ,g_rec_iit_new.iit_descr
                        );
   append_value_triplet ('Start Date'
                        ,TO_CHAR(g_rec_iit_old.iit_start_date,c_date_mask)
                        ,TO_CHAR(g_rec_iit_new.iit_start_date,c_date_mask)
                        );
   append_value_triplet ('End Date'
                        ,TO_CHAR(g_rec_iit_old.iit_end_date,c_date_mask)
                        ,TO_CHAR(g_rec_iit_new.iit_end_date,c_date_mask)
                        );
   nm3tab_varchar.append(l_block,'BEGIN',FALSE);
   nm3tab_varchar.append(l_block,'   Null;');
   FOR i IN 1..l_tab_ita.COUNT
    LOOP
      nm3tab_varchar.append(l_block
                           ,'   '||g_package_name||'.append_value_triplet('||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(l_tab_ita(i).ita_scrn_text))
                                                                      ||','||g_package_name||'.g_rec_iit_old.'||l_tab_ita(i).ita_attrib_name
                                                                      ||','||g_package_name||'.g_rec_iit_new.'||l_tab_ita(i).ita_attrib_name
                                                                      ||');'
                          );
   END LOOP;
   nm3tab_varchar.append(l_block,'END;');
   nm3ddl.execute_tab_varchar (l_block);
END do_asset_detail;
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
   c_subject CONSTANT nm_mail_message.nmm_subject%TYPE := SUBSTR('[TRAVEL TIME] '||p_subject,1,255);
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
END xmrwa_travel_time;
/
