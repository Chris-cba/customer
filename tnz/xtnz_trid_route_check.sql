CREATE OR REPLACE PROCEDURE xtnz_trid_route_check IS

--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_route_check.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_route_check.sql
--       Date into SCCS   : 05/03/15 03:46:19
--       Date fetched Out : 07/06/06 14:40:39
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   l_tab_output     nm3type.tab_varchar32767;
   --
   l_nmg_id     nm_mail_groups.nmg_id%TYPE;
   --
   l_tab_to     nm3mail.tab_recipient;
   l_tab_cc     nm3mail.tab_recipient;
   --
   PROCEDURE add_line (p_text VARCHAR2) IS
      c CONSTANT PLS_INTEGER := l_tab_output.COUNT+1;
   BEGIN
      l_tab_output(c) := p_text;
   END add_line;
   --
   PROCEDURE run_for_gty (pi_gty_group_type VARCHAR2) IS
      l_tab_ne_id  nm3type.tab_number;
      l_tab_ne_unq nm3type.tab_varchar30;
      PROCEDURE add_the_error (p_unq VARCHAR2, p_text VARCHAR2) IS
      BEGIN
         add_line('<TR><TD>'||p_unq||'</TD><TD>'||p_text||'</TD></TR>');
      END add_the_error;
   BEGIN
      --
      add_line('<TR><TH COLSPAN=2>'||nm3get.get_ngt(pi_ngt_group_type=>pi_gty_group_type).ngt_descr||'</TH></TR>');
      --
      SELECT ne_id
            ,ne_unique
       BULK  COLLECT
       INTO  l_tab_ne_id
            ,l_tab_ne_unq
       FROM  nm_elements_all
      WHERE  ne_gty_group_type = pi_gty_group_type
      ORDER BY ne_unique;
      --
      FOR i IN 1..l_tab_ne_id.COUNT
       LOOP
         DECLARE
            l_stat BINARY_INTEGER;
            l_tab  nm3type.tab_varchar30;
            -- -20351 'Start of Right <unique> exists with no compatible end'
            e_right_end_not_compat exception;

            -- -20352 'Start of Left  <unique> exists with no compatible end'
            e_left_end_not_compat exception;

            -- -20353 'Start of <unique> and <unique> are incompatible'
            e_datum_starts_not_campat exception;

            -- -20354 'End of <unique> and <unique> are incompatible'
            e_datum_ends_not_campat exception;
            l_offending_datums_msg nm3type.max_varchar2;
            l_ner_id NUMBER;
            end_of_last EXCEPTION;
            l_nm_seq_no NUMBER;

         BEGIN
            nm3route_check.route_check (pi_ne_id            => l_tab_ne_id(i)
                                       ,po_route_status     => l_stat
                                       ,po_offending_datums => l_tab
                                       );
            IF l_tab.COUNT > 0
            THEN

      	      FOR l_i IN l_tab.FIRST..l_tab.LAST
      	       LOOP
      	         l_offending_datums_msg :=    l_offending_datums_msg
      	      	           || REPLACE(l_tab(l_i),'"',CHR(39))
      	      	           || ', ';
      	      END LOOP;
      	      l_offending_datums_msg := Rtrim(l_offending_datums_msg, ', ');
      	    END IF;

            IF l_stat = 5
            THEN
              l_ner_id := 157;
              RAISE e_right_end_not_compat;

            ELSIF l_stat = 10
            THEN
              l_ner_id := 158;
              RAISE e_left_end_not_compat;

            ELSIF l_stat = 15
            THEN
              l_ner_id := 159;
              RAISE e_datum_starts_not_campat;

            ELSIF l_stat = 20
            THEN
              l_ner_id := 160;
              RAISE e_datum_ends_not_campat;
            END IF;
         EXCEPTION
            WHEN end_of_last THEN NULL;
            WHEN e_right_end_not_compat
              OR  e_left_end_not_compat
              OR  e_datum_starts_not_campat
              OR  e_datum_ends_not_campat
             THEN
                 add_the_error (l_tab_ne_unq(i)
                        ,hig.raise_and_catch_ner (pi_appl => nm3type.c_net
                                                 ,pi_id   => l_ner_id
                                                 ,pi_supplementary_info => l_offending_datums_msg
                                                 )
                        );
             WHEN others
              THEN
                add_the_error(l_tab_ne_unq(i),SQLERRM);
         END;
      END LOOP;
   END run_for_gty;
BEGIN
--
   SELECT nmg_id
    INTO  l_nmg_id
    FROM  nm_mail_groups
   WHERE  nmg_name = 'TRID Admin';
--
   l_tab_to(1).rcpt_id   := l_nmg_id;
   l_tab_to(1).rcpt_type := nm3mail.c_group;
--
   add_line(htf.htmlopen);
   add_line(htf.bodyopen);
   add_line(htf.tableopen(cattributes=>'BORDER=1'));
--
   run_for_gty ('T_EX');
   run_for_gty ('T_MU');
--
   add_line(htf.tableclose);
   add_line(htf.bodyclose);
   add_line(htf.htmlclose);
--
   nm3mail.write_mail_complete
             (p_from_user            => nm3mail.get_current_nmu_id
             ,p_subject              => 'Route Check Errors ('||TO_DATE(SYSDATE,'DD-MON-YYYY')||')'
             ,p_html_mail            => TRUE
             ,p_tab_to               => l_tab_to
             ,p_tab_cc               => l_tab_cc
             ,p_tab_bcc              => l_tab_cc
             ,p_tab_message_text     => l_tab_output
             );
--
   COMMIT;
--
END;
/

