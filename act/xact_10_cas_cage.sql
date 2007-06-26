DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_10_cas_cage.sql	1.1 03/14/05
--       Module Name      : xact_10_cas_cage.sql
--       Date into SCCS   : 05/03/14 23:10:35
--       Date fetched Out : 07/06/06 14:33:30
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
   l_rec_avs.avs_d_ait_id         := 'CAS';
   l_rec_avs.avs_d_aat_id         := 'CAGE';
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
   l_rec_avs.avs_sql              := 'select a_value from dual -- @(#)xact_10_cas_cage.sql	1.1 03/14/05'
                          ||CHR(10)||'WHERE ('
                          ||CHR(10)||'accdisc.get_attr_value(item_id,'||nm3flx.string('CCPC')||','||nm3flx.string('CAS')||') = '||nm3flx.string('01')
                          ||CHR(10)||'AND (EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VDOB')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND TRUNC((months_between(ai.acc_start_date,hig.date_convert(aia.aia_value))/12)) = a_value'
                          ||CHR(10)||') OR NOT EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VDOB')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||')'
                          ||CHR(10)||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR accdisc.get_attr_value(item_id,'||nm3flx.string('CCPC')||','||nm3flx.string('CAS')||') != '||nm3flx.string('01');
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

