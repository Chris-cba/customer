CREATE OR REPLACE PACKAGE BODY xexor_auto_mailer IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_auto_mailer.pkb	1.1 03/15/05
--       Module Name      : xexor_auto_mailer.pkb
--       Date into SCCS   : 05/03/15 00:16:31
--       Date fetched Out : 07/06/06 14:37:31
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   auto mailer package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xexor_auto_mailer.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
--
-------------------------------------------------------------------------
--
   g_package_name CONSTANT VARCHAR2(30) := 'xexor_auto_mailer';
   --
   g_tab_recipient_to  nm3mail.tab_recipient;
   g_tab_recipient_cc  nm3mail.tab_recipient;
   g_tab_recipient_bcc nm3mail.tab_recipient;
   g_tab_text          nm3type.tab_varchar32767;
   g_tab_text_temp     nm3type.tab_varchar32767;
   g_tab_text_temp2    nm3type.tab_varchar32767;
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
-------------------------------------------------------------------------
--
   PROCEDURE clear_globals IS
   BEGIN
      g_tab_recipient_to.DELETE;
      g_tab_recipient_cc.DELETE;
      g_tab_recipient_bcc.DELETE;
      g_tab_text.DELETE;
      g_tab_text_temp.DELETE;
      g_tab_text_temp2.DELETE;
   END clear_globals;
--
-------------------------------------------------------------------------
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      g_tab_text(g_tab_text.COUNT+1) := p_text;
   END append;
--
-------------------------------------------------------------------------
--
   PROCEDURE append2 (p_text VARCHAR2) IS
   BEGIN
      g_tab_text_temp2(g_tab_text_temp2.COUNT+1) := p_text;
   END append2;
--
-------------------------------------------------------------------------
--
   PROCEDURE add_detail_pair (p_head VARCHAR2, p_detail VARCHAR2) IS
   BEGIN
      append ('<!-- '||p_head||' -->');
      append ('<TR>');
      append ('<TH>'||p_head||'</TH>');
      append ('<TD>'||NVL(p_detail,nm3web.c_nbsp)||'</TD>');
      append ('</TR>');
   END add_detail_pair;
--
-------------------------------------------------------------------------
--
PROCEDURE send_pending_emails IS
   --
   PRAGMA AUTONOMOUS_TRANSACTION;
   --
   CURSOR cs_xam IS
   SELECT *
    FROM  xexor_auto_mails
   WHERE (xam_last_sent + xam_frequency_days) <= SYSDATE
    AND   EXISTS (SELECT 1
                   FROM  xexor_auto_mail_queries
                  WHERE  xamq_xam_id = xam_id
                 )
    AND   EXISTS (SELECT 1
                   FROM  xexor_auto_mail_recipients
                  WHERE  xamr_xam_id = xam_id
                 );
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'send_pending_emails');
--
   FOR cs_rec IN cs_xam
    LOOP
      send_individual_xam (p_xam_id => cs_rec.xam_id);
   END LOOP;
--
   nm3mail.send_stored_mail;
--
   nm_debug.proc_end (g_package_name,'send_pending_emails');
--
   COMMIT;
--
END send_pending_emails;
--
-------------------------------------------------------------------------
--
PROCEDURE send_individual_xam (p_xam_id NUMBER) IS
   --
   l_title  VARCHAR2(200);
   --
   l_from_user nm_mail_users.nmu_id%TYPE;
   --
   CURSOR cs_xam (c_xam_id NUMBER) IS
   SELECT *
    FROM  xexor_auto_mails
   WHERE  xam_id = c_xam_id
    AND   EXISTS (SELECT 1
                   FROM  xexor_auto_mail_queries
                  WHERE  xamq_xam_id = xam_id
                 )
    AND   EXISTS (SELECT 1
                   FROM  xexor_auto_mail_recipients
                  WHERE  xamr_xam_id = xam_id
                 )
   FOR UPDATE OF xam_last_sent NOWAIT;
   --
   CURSOR cs_dq (c_xamq_xam_id NUMBER) IS
   SELECT *
    FROM  xexor_auto_mail_queries
         ,doc_query
   WHERE  xamq_xam_id = c_xamq_xam_id
    AND   xamq_dq_id  = dq_id
   ORDER BY xamq_seq, dq_title;
   --
   CURSOR cs_xamr (c_xamr_xam_id NUMBER) IS
   SELECT *
    FROM  xexor_auto_mail_recipients
   WHERE  xamr_xam_id = c_xamr_xam_id;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'send_individual_xam');
--
   l_from_user := nm3mail.get_current_nmu_id;
--
   FOR cs_rec IN cs_xam (p_xam_id)
    LOOP
      --
      clear_globals;
      --
      l_title := cs_rec.xam_mail_title||' - '||to_char(sysdate,nm3type.c_full_date_time_format);
      --
      FOR cs_xamr_rec IN cs_xamr (cs_rec.xam_id)
       LOOP
         g_tab_recipient_to(cs_xamr%ROWCOUNT).rcpt_id   := cs_xamr_rec.xamr_nmg_id;
         g_tab_recipient_to(cs_xamr%ROWCOUNT).rcpt_type := nm3mail.c_group;
      END LOOP;
      --
      append ('<HTML>');
      append ('<HEAD>');
      append ('<TITLE>'||l_title||'</TITLE>');
      append ('</HEAD>');
      append ('<BODY>');
      append ('<H2>'||l_title||'</H2>');
      append ('<TABLE BORDER=1>');
      FOR cs_dq_rec IN cs_dq (cs_rec.xam_id)
       LOOP
         g_tab_text_temp := dm3query.execute_query_tab (p_dq_id => cs_dq_rec.dq_id);
         add_detail_pair('<A HREF="#'||cs_dq_rec.dq_id||'">'||cs_dq_rec.dq_title||'</A>',cs_dq_rec.dq_descr);
         append2 ('<BR>');
         append2 ('<A NAME="'||cs_dq_rec.dq_id||'"><FONT SIZE=+1>'||cs_dq_rec.dq_title||'</FONT></A>');
         append2 ('<A HREF="#top"><SUP>^top</SUP><A>');
         append2 ('<BR>');
         IF cs_dq_rec.dq_descr IS NOT NULL
          THEN
	          append2 ('<FONT SIZE=-1>'||cs_dq_rec.dq_descr||'</FONT>');
   	        append2 ('<BR>');
         END IF;
         FOR i IN 1..g_tab_text_temp.COUNT
          LOOP
	          append2 (g_tab_text_temp(i));
         END LOOP;
      END LOOP;
      append ('</TABLE>');
      --
      FOR i IN 1..g_tab_text_temp2.COUNT
       LOOP
         append (g_tab_text_temp2(i));
      END LOOP;
      append ('</BODY>');
      append ('</HTML>');
      nm3mail.write_mail_complete (p_from_user        => l_from_user
			                            ,p_subject          => l_title
      	                          ,p_html_mail        => TRUE
			                            ,p_tab_to           => g_tab_recipient_to
      	                          ,p_tab_cc           => g_tab_recipient_cc
			                            ,p_tab_bcc          => g_tab_recipient_bcc
      	                          ,p_tab_message_text => g_tab_text
			                            );
      --
      UPDATE xexor_auto_mails
       SET   xam_last_sent = SYSDATE
      WHERE  CURRENT OF cs_xam;
      --
   END LOOP;
--
   nm_debug.proc_end (g_package_name,'send_individual_xam');
--
END send_individual_xam;
--
-------------------------------------------------------------------------
--
PROCEDURE submit_dbms_job (p_minutes PLS_INTEGER) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_job_id NUMBER;
BEGIN
--
   nm_debug.proc_start (g_package_name,'submit_dbms_job');
--
   dbms_job.submit (job       => l_job_id
                   ,what      => g_package_name||'.send_pending_emails;'
                   ,next_date => SYSDATE
                   ,interval  => 'SYSDATE+('||NVL(p_minutes,5)||'/1440)'
                   );
--
   nm_debug.proc_end (g_package_name,'submit_dbms_job');
--
   COMMIT;
--
END submit_dbms_job;
--
-------------------------------------------------------------------------
--
END xexor_auto_mailer;
/
