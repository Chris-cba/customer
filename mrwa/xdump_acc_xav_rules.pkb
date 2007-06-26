CREATE OR REPLACE PACKAGE BODY xdump_acc_xav_rules AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xdump_acc_xav_rules.pkb	1.1 03/15/05
--       Module Name      : xdump_acc_xav_rules.pkb
--       Date into SCCS   : 05/03/15 00:45:15
--       Date fetched Out : 07/06/06 14:38:03
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   extract accidents cross attribute validation rules package body
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xdump_acc_xav_rules.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xdump_acc_xav_rules';
   g_filename VARCHAR2(80);
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
PROCEDURE dump_single_rule (p_ait_id         acc_item_types.ait_id%TYPE
                           ,p_aat_id         acc_attr_types.aat_id%TYPE
                           ,p_output_dir     VARCHAR2 DEFAULT c_default_output_dir
                           ) IS
--
   CURSOR cs_avd IS
   SELECT *
    FROM  acc_valid_dep
   WHERE  avd_ait_id = p_ait_id
    AND   avd_aat_id = p_aat_id
    AND   avd_type   = 'Q';
--
   CURSOR cs_aat IS
   SELECT *
    FROM  acc_attr_types
   WHERE  aat_id = p_aat_id;
--
   CURSOR cs_aav IS
   SELECT *
    FROM  acc_attr_valid
   WHERE  aav_ait_id = p_ait_id
    AND   aav_aat_id = p_aat_id;
--
   CURSOR cs_ait IS
   SELECT *
    FROM  acc_item_types
   WHERE  ait_id = p_ait_id;
--
   CURSOR cs_avs IS
   SELECT *
    FROM  acc_valid_sql
   WHERE  avs_d_ait_id = p_ait_id
    AND   avs_d_aat_id = p_aat_id;
--
   l_found   BOOLEAN;
   l_rec_ait acc_item_types%ROWTYPE;
   l_rec_aat acc_attr_types%ROWTYPE;
   l_rec_aav acc_attr_valid%ROWTYPE;
   l_rec_avd acc_valid_dep%ROWTYPE;
   l_rec_avs acc_valid_sql%ROWTYPE;
--
   l_tab_output nm3type.tab_varchar32767;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_tab_output, p_text, p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'dump_single_rule');
--
   OPEN  cs_avd;
   FETCH cs_avd
    INTO l_rec_avd;
   l_found := cs_avd%FOUND;
   CLOSE cs_avd;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'acc_valid_dep'
                    );
   END IF;
--
   OPEN  cs_avs;
   FETCH cs_avs
    INTO l_rec_avs;
   l_found := cs_avs%FOUND;
   CLOSE cs_avs;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'acc_valid_sql'
                    );
   END IF;
--
   OPEN  cs_ait;
   FETCH cs_ait
    INTO l_rec_ait;
   l_found := cs_ait%FOUND;
   CLOSE cs_ait;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'acc_item_types'
                    );
   END IF;
--
   OPEN  cs_aat;
   FETCH cs_aat
    INTO l_rec_aat;
   l_found := cs_aat%FOUND;
   CLOSE cs_aat;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'acc_attr_types'
                    );
   END IF;
--
   OPEN  cs_aav;
   FETCH cs_aav
    INTO l_rec_aav;
   l_found := cs_aav%FOUND;
   CLOSE cs_aav;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'acc_attr_valid'
                    );
   END IF;
--
   g_filename := nm3context.get_context(pi_attribute=>'INSTANCE_NAME')||'_';
   g_filename := g_filename||l_rec_ait.ait_level||'_'||LTRIM(to_char(l_rec_aav.aav_seq,'0000'))||'_';
   g_filename := lower(g_filename||p_ait_id||'_'||p_aat_id||'.sql');
--
   l_tab_output.DELETE;
   append ('DECLARE',FALSE);
   append ('--');
   append ('-- accident item type       : '||l_rec_ait.ait_name||' ('||l_rec_ait.ait_id||')');
   append ('-- accident attribute type  : '||l_rec_aat.aat_name||' ('||l_rec_aat.aat_id||')');
   append ('--');
   append ('-- extracted from instance  : '||nm3context.get_context(pi_attribute=>'INSTANCE_NAME')||'@'||nm3context.get_context(pi_attribute=>'HOST_NAME'));
   append ('-- extracted by             : '||USER);
   append ('-- extracted date           : '||to_char(sysdate,nm3type.c_full_date_time_format));
   append ('--');
   append ('   l_rec_avs acc_valid_sql%ROWTYPE;');
   append ('   l_rec_avd acc_valid_dep%ROWTYPE;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   l_rec_avs.avs_d_ait_id         := '||nm3flx.string(l_rec_avs.avs_d_ait_id)||';');
   append ('   l_rec_avs.avs_d_aat_id         := '||nm3flx.string(l_rec_avs.avs_d_aat_id)||';');
   append ('   l_rec_avs.avs_load_flag        := '||nm3flx.string(l_rec_avs.avs_load_flag)||';');
   append ('   l_rec_avs.avs_sql              := '||nm3flx.string(REPLACE(nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_avs.avs_sql)
                                                                         ,'||CHR(10)',CHR(10)||'                          ||CHR(10)'
                                                                         )
                                                                 )||';'
          );
   append ('   l_rec_avs.avs_i_ait_id         := '||nm3flx.string(l_rec_avs.avs_i_ait_id)||';');
   append ('   l_rec_avs.avs_i_aat_id         := '||nm3flx.string(l_rec_avs.avs_i_aat_id)||';');
   append ('   l_rec_avs.avs_match_status     := '||nm3flx.string(l_rec_avs.avs_match_status)||';');
   append ('   l_rec_avs.avs_no_match_status  := '||nm3flx.string(l_rec_avs.avs_no_match_status)||';');
   append ('   l_rec_avs.avs_not_found_status := '||nm3flx.string(l_rec_avs.avs_not_found_status)||';');
   append ('   l_rec_avs.avs_match_mesg       := '||nm3flx.string(l_rec_avs.avs_match_mesg)||';');
   append ('   l_rec_avs.avs_no_match_mesg    := '||nm3flx.string(l_rec_avs.avs_no_match_mesg)||';');
   append ('   l_rec_avs.avs_not_found_mesg   := '||nm3flx.string(l_rec_avs.avs_not_found_mesg)||';');
   append ('--');
   append ('   l_rec_avd.avd_ait_id := l_rec_avs.avs_d_ait_id;');
   append ('   l_rec_avd.avd_aat_id := l_rec_avs.avs_d_aat_id;');
   append ('   l_rec_avd.avd_type   := '||nm3flx.string(l_rec_avd.avd_type)||';');
   append ('--');
   append ('   DELETE FROM acc_valid_dep');
   append ('    WHERE avd_ait_id    = l_rec_avd.avd_ait_id');
   append ('    AND   avd_aat_id    = l_rec_avd.avd_aat_id');
   append ('    AND   avd_type      = l_rec_avd.avd_type;');
   append ('--');
   append ('   DELETE FROM acc_valid_sql');
   append ('   WHERE  avs_d_ait_id  = l_rec_avs.avs_d_ait_id');
   append ('    AND   avs_d_aat_id  = l_rec_avs.avs_d_aat_id');
   append ('    AND   avs_load_flag = l_rec_avs.avs_load_flag;');
   append ('--');
   append ('   INSERT INTO acc_valid_dep');
   append ('          (avd_ait_id');
   append ('          ,avd_aat_id');
   append ('          ,avd_type');
   append ('          )');
   append ('   VALUES (l_rec_avd.avd_ait_id');
   append ('          ,l_rec_avd.avd_aat_id');
   append ('          ,l_rec_avd.avd_type');
   append ('          );');
   append ('--');
   append ('   INSERT INTO acc_valid_sql');
   append ('          (avs_d_ait_id');
   append ('          ,avs_d_aat_id');
   append ('          ,avs_load_flag');
   append ('          ,avs_sql');
   append ('          ,avs_i_ait_id');
   append ('          ,avs_i_aat_id');
   append ('          ,avs_match_status');
   append ('          ,avs_no_match_status');
   append ('          ,avs_not_found_status');
   append ('          ,avs_match_mesg');
   append ('          ,avs_no_match_mesg');
   append ('          ,avs_not_found_mesg');
   append ('          )');
   append ('   VALUES (l_rec_avs.avs_d_ait_id');
   append ('          ,l_rec_avs.avs_d_aat_id');
   append ('          ,l_rec_avs.avs_load_flag');
   append ('          ,l_rec_avs.avs_sql');
   append ('          ,l_rec_avs.avs_i_ait_id');
   append ('          ,l_rec_avs.avs_i_aat_id');
   append ('          ,l_rec_avs.avs_match_status');
   append ('          ,l_rec_avs.avs_no_match_status');
   append ('          ,l_rec_avs.avs_not_found_status');
   append ('          ,l_rec_avs.avs_match_mesg');
   append ('          ,l_rec_avs.avs_no_match_mesg');
   append ('          ,l_rec_avs.avs_not_found_mesg');
   append ('          );');
   append ('--');
   append ('   proto_validate.p_function');
   append ('           (p_ait_id           => l_rec_avs.avs_d_ait_id');
   append ('			     ,p_aat_id           => l_rec_avs.avs_d_aat_id');
   append ('			     ,p_sql              => l_rec_avs.avs_sql');
   append ('			     ,p_match_status     => l_rec_avs.avs_match_status');
   append ('			     ,p_no_match_status  => l_rec_avs.avs_no_match_status');
   append ('			     ,p_not_found_status => l_rec_avs.avs_not_found_status');
   append ('			     );');
   append ('--');
   append ('   COMMIT;');
   append ('--');
   append ('END;');
   append ('/');
--
   nm3file.write_file (location     => p_output_dir
                      ,filename     => g_filename
                      ,max_linesize => 32767
                      ,all_lines    => l_tab_output
                      );
--
   nm_debug.proc_end (g_package_name, 'dump_single_rule');
--
END dump_single_rule;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_all_rules (p_output_dir     VARCHAR2 DEFAULT c_default_output_dir) IS
--
   TYPE tab_avd IS TABLE OF acc_valid_dep%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_avd tab_avd;
--
   l_tab_output nm3type.tab_varchar32767;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_tab_output, p_text, p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'dump_all_rules');
--
   SELECT avd.*
    BULK  COLLECT
    INTO  l_tab_avd
    FROM  acc_valid_dep  avd
         ,acc_item_types ait
         ,acc_attr_valid aav
   WHERE  avd_type = 'Q'
    AND   avd_ait_id = ait_id
    AND   aav_ait_id = ait_id
    AND   aav_aat_id = avd_aat_id
   ORDER BY ait_level, avd_ait_id, aav_seq;
--
   FOR i IN 1..l_tab_avd.COUNT
    LOOP
--
      dump_single_rule (p_ait_id     => l_tab_avd(i).avd_ait_id
                       ,p_aat_id     => l_tab_avd(i).avd_aat_id
                       ,p_output_dir => p_output_dir
                       );
      append ('@'||g_filename);
--
   END LOOP;
--
   nm3file.write_file (location     => p_output_dir
                      ,filename     => lower(nm3context.get_context(pi_attribute=>'INSTANCE_NAME')||'_all_acc_xav_rules.sql')
                      ,max_linesize => 32767
                      ,all_lines    => l_tab_output
                      );
--
   nm_debug.proc_end (g_package_name, 'dump_all_rules');
--
END dump_all_rules;
-----------------------------------------------------------------------------
--
END xdump_acc_xav_rules;
/
