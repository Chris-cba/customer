GRANT ADMINISTER DATABASE TRIGGER TO NM31;
CREATE OR REPLACE TRIGGER xmrwa_hig_logon_messages_trg
   AFTER LOGON
    ON   DATABASE
DECLARE
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_hig_logon_messages_trg.trg	1.1 03/15/05
--       Module Name      : xmrwa_hig_logon_messages_trg.trg
--       Date into SCCS   : 05/03/15 00:45:35
--       Date fetched Out : 07/06/06 14:38:21
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   do_nothing EXCEPTION;
   l_session_count NUMBER;
   l_nmu_id nm_mail_users.nmu_id%TYPE;
   l_found BOOLEAN;
   l_tab_to   nm3mail.tab_recipient;
   l_tab_cc   nm3mail.tab_recipient;
   l_tab_bcc  nm3mail.tab_recipient;
   l_send_mail BOOLEAN;
   l_user_id NUMBER;
   l_dummy PLS_INTEGER;
--
   CURSOR cs_nmu (c_user_id NUMBER) IS
   SELECT nmu_id
    FROM  nm_mail_users
   WHERE  nmu_hus_user_id = c_user_id;
--
   CURSOR cs_xhlmm (c_nmu_id NUMBER) IS
   SELECT *
    FROM  v_nm_mail
         ,nm_mail_group_membership
   WHERE  iit_nmg_id  = nmgm_nmg_id
    AND   nmgm_nmu_id = c_nmu_id;
--
   CURSOR cs_done_already (c_iit_ne_id NUMBER, c_hus_user_id NUMBER) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_inv_item_groupings
                        ,nm_inv_items_all
                  WHERE  iig_top_id           = c_iit_ne_id
                   AND   iit_ne_id            = iig_item_id
                   AND   iit_peo_invent_by_id = c_hus_user_id
                 );
   l_rec_iit nm_inv_items%ROWTYPE;
   l_child_item_exists  BOOLEAN;
--
BEGIN
   --
   l_user_id := nm3user.get_user_id;
   --
   OPEN  cs_nmu (l_user_id);
   FETCH cs_nmu INTO l_nmu_id;
   l_found := cs_nmu%FOUND;
   CLOSE cs_nmu;
   --
   IF NOT l_found
    THEN
      RAISE do_nothing;
   END IF;
   --
   SELECT COUNT(1)
    INTO  l_session_count
    FROM  v$session
   WHERE  username = USER;
   --
   IF l_session_count > 1
    THEN
      RAISE do_nothing;
   END IF;
   --
   l_tab_to(1).rcpt_id   := l_nmu_id;
   l_tab_to(1).rcpt_type := nm3mail.c_user;
   --
   l_rec_iit.iit_inv_type := 'MAIS';
   FOR cs_rec IN cs_xhlmm (l_nmu_id)
    LOOP
      OPEN  cs_done_already (cs_rec.iit_ne_id, l_user_id);
      FETCH cs_done_already INTO l_dummy;
      l_child_item_exists := cs_done_already%FOUND;
      CLOSE cs_done_already;
      IF cs_rec.iit_once_only = 'Y'
       AND l_child_item_exists
       THEN
         l_send_mail := FALSE;
      ELSE
         l_send_mail := TRUE;
      END IF;
      IF l_send_mail
       THEN
         nm3mail.send_server_file_as_email
                              (p_from_user => l_nmu_id
                              ,p_subject   => cs_rec.iit_subject
                              ,p_html_mail => (cs_rec.iit_html='Y')
                              ,p_tab_to    => l_tab_to
                              ,p_tab_cc    => l_tab_cc
                              ,p_tab_bcc   => l_tab_bcc
                              ,p_file_path => cs_rec.iit_file_path
                              ,p_file_name => cs_rec.iit_file_name
                              );
--         IF NOT l_child_item_exists
--          THEN
            -- Create the child item
            l_rec_iit.iit_ne_id            := nm3seq.next_ne_id_seq;
            l_rec_iit.iit_primary_key      := Null;
            l_rec_iit.iit_start_date       := nm3user.get_effective_date;
            l_rec_iit.iit_admin_unit       := cs_rec.iit_admin_unit;
            l_rec_iit.iit_end_date         := cs_rec.iit_end_date;
            l_rec_iit.iit_foreign_key      := cs_rec.iit_subject;
            l_rec_iit.iit_peo_invent_by_id := l_user_id;
            l_rec_iit.IIT_DATE_ATTRIB87    := SYSDATE;
            l_rec_iit.IIT_DATE_ATTRIB86    := TRUNC(l_rec_iit.IIT_DATE_ATTRIB87);
            nm3ins.ins_iit (l_rec_iit);
--         END IF;
      END IF;
   END LOOP;
--
   COMMIT;
--
EXCEPTION
   WHEN do_nothing
    THEN
      Null;
END;
/
--REVOKE ADMINISTER DATABASE TRIGGER FROM NM31;
