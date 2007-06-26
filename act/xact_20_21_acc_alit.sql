DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_20_21_acc_alit.sql	1.1 03/14/05
--       Module Name      : xact_20_21_acc_alit.sql
--       Date into SCCS   : 05/03/14 23:10:42
--       Date fetched Out : 07/06/06 14:33:33
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT Accidents XAV rule
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
   l_rec_avs acc_valid_sql%ROWTYPE;
   l_rec_avd acc_valid_dep%ROWTYPE;
BEGIN
--
   l_rec_avs.avs_d_ait_id         := 'ACC';
   l_rec_avs.avs_d_aat_id         := 'ALIT';
   l_rec_avs.avs_load_flag        := 'N';
   l_rec_avs.avs_sql              := Null;
   l_rec_avs.avs_i_ait_id         := Null;
   l_rec_avs.avs_i_aat_id         := Null;
   l_rec_avs.avs_match_status     := 'VALID';
   l_rec_avs.avs_no_match_status  := 'INVALID';
   l_rec_avs.avs_not_found_status := 'INVALID';
   l_rec_avs.avs_match_mesg       := Null;
   l_rec_avs.avs_no_match_mesg    := Null;
   l_rec_avs.avs_not_found_mesg   := Null;
--
   l_rec_avs.avs_sql              := 'select a_value from dual -- @(#)xact_20_21_acc_alit.sql	1.1 03/14/05'
                          ||CHR(10)||'WHERE '
                          ||CHR(10)||'a_value NOT IN ('||nm3flx.string('1')||','||nm3flx.string('3')||','||nm3flx.string('4')||','||nm3flx.string('5')||')'
                          ||CHR(10)||'OR'
                          ||CHR(10)||'(a_value = '||nm3flx.string('1')
                          ||CHR(10)||' AND SUBSTR(accdisc.get_attr_value(item_id,'||nm3flx.string('ATIM')||','||nm3flx.string('ACC')||'),1,2) BETWEEN 5 AND 20'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR'
                          ||CHR(10)||'(a_value IN ('||nm3flx.string('3')||','||nm3flx.string('4')||','||nm3flx.string('5')||')'
                          ||CHR(10)||' AND SUBSTR(accdisc.get_attr_value(item_id,'||nm3flx.string('ATIM')||','||nm3flx.string('ACC')||'),1,2) NOT BETWEEN 7 AND 16'
                          ||CHR(10)||')';
--
   l_rec_avd.avd_ait_id := l_rec_avs.avs_d_ait_id;
   l_rec_avd.avd_aat_id := l_rec_avs.avs_d_aat_id;
   l_rec_avd.avd_type   := 'Q';
--
   DELETE FROM acc_valid_dep
    WHERE avd_ait_id    = l_rec_avd.avd_ait_id
    AND   avd_aat_id    = l_rec_avd.avd_aat_id
    AND   avd_type = l_rec_avd.avd_type;
--
   DELETE FROM acc_valid_sql
   WHERE  avs_d_ait_id  = l_rec_avs.avs_d_ait_id
    AND   avs_d_aat_id  = l_rec_avs.avs_d_aat_id
    AND   avs_load_flag = l_rec_avs.avs_load_flag;
--
   INSERT INTO acc_valid_dep
          (avd_ait_id
          ,avd_aat_id
          ,avd_type
          )
   VALUES (l_rec_avd.avd_ait_id
          ,l_rec_avd.avd_aat_id
          ,l_rec_avd.avd_type
          );
--
   INSERT INTO acc_valid_sql
          (avs_d_ait_id
          ,avs_d_aat_id
          ,avs_load_flag
          ,avs_sql
          ,avs_i_ait_id
          ,avs_i_aat_id
          ,avs_match_status
          ,avs_no_match_status
          ,avs_not_found_status
          ,avs_match_mesg
          ,avs_no_match_mesg
          ,avs_not_found_mesg
          )
   VALUES (l_rec_avs.avs_d_ait_id
          ,l_rec_avs.avs_d_aat_id
          ,l_rec_avs.avs_load_flag
          ,l_rec_avs.avs_sql
          ,l_rec_avs.avs_i_ait_id
          ,l_rec_avs.avs_i_aat_id
          ,l_rec_avs.avs_match_status
          ,l_rec_avs.avs_no_match_status
          ,l_rec_avs.avs_not_found_status
          ,l_rec_avs.avs_match_mesg
          ,l_rec_avs.avs_no_match_mesg
          ,l_rec_avs.avs_not_found_mesg
          );
--
   proto_validate.p_function (p_ait_id           => l_rec_avs.avs_d_ait_id
			     ,p_aat_id           => l_rec_avs.avs_d_aat_id
			     ,p_sql              => l_rec_avs.avs_sql
			     ,p_match_status     => l_rec_avs.avs_match_status
			     ,p_no_match_status  => l_rec_avs.avs_no_match_status
			     ,p_not_found_status => l_rec_avs.avs_not_found_status
			     );
--
   COMMIT;
--
END;
/

