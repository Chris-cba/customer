CREATE OR REPLACE TRIGGER xmrwa_str_items_all_mail_trg
   AFTER INSERT
    ON   STR_ITEMS_ALL_ALL
   FOR   EACH ROW
   WHEN (NEW.STR_ID = NEW.STR_TOP_ID)
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_str_items_all_mail_trg.trg	1.1 03/15/05
--       Module Name      : xmrwa_str_items_all_mail_trg.trg
--       Date into SCCS   : 05/03/15 00:46:06
--       Date fetched Out : 07/06/06 14:38:30
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
   l_tab_text nm3type.tab_varchar32767;
   l_tab_to   nm3mail.tab_recipient;
   l_tab_cc   nm3mail.tab_recipient;
   l_tab_bcc  nm3mail.tab_recipient;
   l_nmu_id   nm_mail_users.nmu_id%TYPE;
--
   CURSOR cs_nmu (c_user_id NUMBER) IS
   SELECT nmu_id
    FROM  nm_mail_users
   WHERE  nmu_hus_user_id = c_user_id;
--
   CURSOR cs_nmg (c_name VARCHAR2) IS
   SELECT nmg_id
    FROM  nm_mail_groups
   WHERE  nmg_name = c_name;
--
   l_found BOOLEAN;
   c_group_name CONSTANT nm_mail_groups.nmg_name%TYPE := 'STR_TOP_USERS';
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_tab_text,p_text,p_nl);
   END append;
   PROCEDURE append_pair (p_heading VARCHAR2, p_text VARCHAR2) IS
   BEGIN
      append ('<TR>');
      append ('<TH>'||p_heading||'</TH>');
      append ('<TD>'||NVL(p_text,nm3web.c_nbsp)||'</TD>');
      append ('</TR>');
   END append_pair;
--
BEGIN
--
   --
   OPEN  cs_nmu (nm3user.get_user_id);
   FETCH cs_nmu INTO l_nmu_id;
   l_found := cs_nmu%FOUND;
   CLOSE cs_nmu;
   --
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => 'Send mail from your account'
                    );
   END IF;
--
   l_tab_to(1).rcpt_type := nm3mail.c_group;
   OPEN  cs_nmg (c_group_name);
   FETCH cs_nmg INTO l_tab_to(1).rcpt_id;
   l_found := cs_nmg%FOUND;
   CLOSE cs_nmg;
   --
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_mail_groups.nmg_name='||c_group_name
                    );
   END IF;
--
   l_tab_cc(1).rcpt_id   := l_nmu_id;
   l_tab_cc(1).rcpt_type := nm3mail.c_user;
--
   append ('<HTML>');
   append ('<BODY>');
--
   append ('<TABLE BORDER=1>');
   append_pair ('Type',:NEW.str_sit_id);
   append_pair ('Start Date',TO_CHAR(:NEW.str_start_date,nm3user.get_user_date_mask));
   append_pair ('Name',:NEW.str_name);
   append_pair ('Desc',:NEW.str_descr);
   append_pair ('Admin Unit',nm3ausec.get_unit_code(:NEW.str_admin_unit));
   append_pair ('Grid East',:NEW.str_st_grid_east);
   append_pair ('Grid North',:NEW.str_st_grid_north);
   append_pair ('Created By',USER);
   append_pair ('Creation Date',to_char(sysdate,nm3type.c_full_date_time_format));
   append ('<TABLE>');
--
   append ('</BODY>');
   append ('</HTML>');
--
   nm3mail.write_mail_complete (p_from_user        => l_nmu_id
                               ,p_subject          => 'New Structure "'||:NEW.str_name||'" created'
                               ,p_html_mail        => TRUE
                               ,p_tab_to           => l_tab_to
                               ,p_tab_cc           => l_tab_cc
                               ,p_tab_bcc          => l_tab_bcc
                               ,p_tab_message_text => l_tab_text
                               );
END xmrwa_str_items_all_mail_trg;
/
