DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_1_4_cas_ccpc.sql	1.1 03/14/05
--       Module Name      : xact_1_4_cas_ccpc.sql
--       Date into SCCS   : 05/03/14 23:10:41
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
   l_sql     nm3type.max_varchar2;
BEGIN
--
   l_rec_avs.avs_d_ait_id         := 'CAS';
   l_rec_avs.avs_d_aat_id         := 'CCPC';
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
   l_sql               :=            'select a_value -- @(#)xact_1_4_cas_ccpc.sql	1.1 03/14/05'
                          ||CHR(10)||' from  dual'
                          ||CHR(10)||'WHERE'
                          ||CHR(10)||'('
                          ||CHR(10)||'EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE a_value IN ('||nm3flx.string('01')
                                                    ||','||nm3flx.string('02')
                                                    ||','||nm3flx.string('03')
                                                    ||','||nm3flx.string('04')
                                                    ||','||nm3flx.string('05')
                                                    ||','||nm3flx.string('06')
                                                    ||','||nm3flx.string('13')
                                                    ||',DECODE(aia.aia_value,'||nm3flx.string('7')||','||nm3flx.string('14')||','||nm3flx.string(nm3type.c_nvl)||')'
                                                    ||')'
                          ||CHR(10)||' AND ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VVTC')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND aia.aia_value IN ('||nm3flx.string('1')
                                                         ||','||nm3flx.string('2')
                                                         ||','||nm3flx.string('3')
                                                         ||','||nm3flx.string('4')
                                                         ||','||nm3flx.string('5')
                                                         ||','||nm3flx.string('6')
                                                         ||','||nm3flx.string('7')
                                                         ||','||nm3flx.string('10')
                                                         ||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE a_value IN ('||nm3flx.string('09')
                                                    ||','||nm3flx.string('10')
                                                    ||','||nm3flx.string('13')
                                                    ||')'
                          ||CHR(10)||' AND ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VVTC')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND aia.aia_value IN ('||nm3flx.string('8')||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE a_value IN ('||nm3flx.string('07')
                                                    ||','||nm3flx.string('08')
                                                    ||','||nm3flx.string('13')
                                                    ||')'
                          ||CHR(10)||' AND ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VVTC')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND aia.aia_value IN ('||nm3flx.string('11')||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE a_value IN ('||nm3flx.string('11')
                                                         ||','||nm3flx.string('13')
                                                         ||')'
                          ||CHR(10)||' AND ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VVTC')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND aia.aia_value IN ('||nm3flx.string('9')||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'OR EXISTS'
                          ||CHR(10)||'(SELECT /*+ INDEX (aia aia_pk) */ 1'
                          ||CHR(10)||' FROM acc_item_attr aia, acc_items_all ai'
                          ||CHR(10)||'WHERE ai.acc_id = item_id'
                          ||CHR(10)||' AND aia.aia_acc_id = ai.acc_parent_id'
                          ||CHR(10)||' AND aia.aia_aat_id = '||nm3flx.string('VVTC')
                          ||CHR(10)||' AND aia.aia_ait_id = '||nm3flx.string('VEH')
                          ||CHR(10)||' AND aia.aia_value NOT IN ('||nm3flx.string('1')
                                                             ||','||nm3flx.string('2')
                                                             ||','||nm3flx.string('3')
                                                             ||','||nm3flx.string('4')
                                                             ||','||nm3flx.string('5')
                                                             ||','||nm3flx.string('6')
                                                             ||','||nm3flx.string('7')
                                                             ||','||nm3flx.string('8')
                                                             ||','||nm3flx.string('9')
                                                             ||','||nm3flx.string('10')
                                                             ||','||nm3flx.string('11')
                                                             ||')'
                          ||CHR(10)||')'
                          ||CHR(10)||')'
                          ||CHR(10)||'AND NOT EXISTS '
                          ||CHR(10)||'(SELECT 1'
                          ||CHR(10)||'  FROM  acc_items_all ai_mates, acc_items_all ai_item'
                          ||CHR(10)||' WHERE  ai_item.acc_id        = item_id'
                          ||CHR(10)||'  AND   ai_item.acc_parent_id = ai_mates.acc_parent_id'
                          ||CHR(10)||'  AND   ai_item.acc_id       != ai_mates.acc_id'
                          ||CHR(10)||'  AND   ai_item.acc_ait_id    = ai_mates.acc_ait_id'
                          ||CHR(10)||'  AND   a_value NOT IN ('||nm3flx.string('13')||','||nm3flx.string('14')||')'
                          ||CHR(10)||'  AND   accdisc.get_attr_value(ai_mates.acc_id,'||nm3flx.string('CCPC')||','||nm3flx.string('CAS')||') = a_value'
                          ||CHR(10)||')';
--
   l_rec_avs.avs_sql    := l_sql;
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

