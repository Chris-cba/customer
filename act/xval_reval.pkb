CREATE OR REPLACE PACKAGE BODY xval_reval AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_reval.pkb	1.1 03/14/05
--       Module Name      : xval_reval.pkb
--       Date into SCCS   : 05/03/14 23:11:30
--       Date fetched Out : 07/06/06 14:33:58
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Valuations Revaluation package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xval_reval.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xval_reval';
--
   c_empty_rec_iit         nm_inv_items%ROWTYPE;
--
   c_val_inv_type     CONSTANT nm_inv_types.nit_inv_type%TYPE := xval_find_inv.get_val_inv_type;
   c_val_inv_type_str CONSTANT VARCHAR2(6)                    := nm3flx.string(c_val_inv_type);
   c_val_inv_type_old CONSTANT VARCHAR2(8)                    := c_val_inv_type||'_OLD';
--
   c_nm_inv_items CONSTANT VARCHAR2(30)                   := 'NM_INV_ITEMS';
--
   c_asterisk     CONSTANT VARCHAR2(1)                    := '*';
   c_sup_asterisk CONSTANT VARCHAR2(30)                   := htf.sup(c_asterisk);
   c_app_owner    CONSTANT VARCHAR2(30)                   := hig.get_application_owner;
   c_checked      CONSTANT varchar2(8)                    := ' CHECKED';
--
   c_y            CONSTANT VARCHAR2(1)                    := 'Y';
   c_n            CONSTANT VARCHAR2(1)                    := 'N';
   c_y_str        CONSTANT VARCHAR2(3)                    := nm3flx.string(c_y);
   c_n_str        CONSTANT VARCHAR2(3)                    := nm3flx.string(c_n);
--
-----------------------------------------------------------------------------
--
PROCEDURE display_tab_xvc (pi_rec_xvc     tab_xvc
                          ,pi_rec_iit_val nm_inv_items%ROWTYPE DEFAULT c_empty_rec_iit
                          );
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_out_table_pairs (pi_header   nm3type.tab_varchar32767
                               ,pi_detail   nm3type.tab_varchar32767
                               );
--
-----------------------------------------------------------------------------
--
FUNCTION delete_zero_ids_from_table (pi_table nm3type.tab_varchar30) RETURN nm3type.tab_varchar30;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_reval_internal (pi_iit_ne_id          IN nm_inv_items.iit_ne_id%TYPE
                                 ,pi_data_col           IN nm3type.tab_varchar32767
                                 ,pi_data_string        IN nm3type.tab_varchar32767
                                 ,pi_process_type_col   IN VARCHAR2
                                 ,pi_xvc_xf_formula_col IN VARCHAR2
                                 ,pi_dry_run            IN BOOLEAN DEFAULT FALSE
                                 );
PROCEDURE perform_reval_internal (pi_iit_ne_id          IN nm3type.tab_varchar30
                                 ,pi_data_col           IN nm3type.tab_varchar32767
                                 ,pi_data_string        IN nm3type.tab_varchar32767
                                 ,pi_process_type_col   IN VARCHAR2
                                 ,pi_xvc_xf_formula_col IN VARCHAR2
                                 ,pi_dry_run            IN BOOLEAN DEFAULT FALSE
                                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tab_xvc (p_iit_inv_type nm_inv_types.nit_inv_type%TYPE
                      ,p_column_name  VARCHAR2
--                      ,p_column_name2 VARCHAR2 DEFAULT NULL
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE internal_prompt_many
                      (pi_iit_ne_id         nm3type.tab_varchar30
                      ,pi_module            hig_modules.hmo_module%TYPE
                      ,pi_module_title      hig_modules.hmo_title%TYPE
                      ,pi_prompt_column     VARCHAR2
--                      ,pi_prompt_column2    VARCHAR2 DEFAULT NULL
                      ,pi_process_proc      VARCHAR2
                      ,pi_process_type_col  VARCHAR2
--                      ,pi_process_type_col2 VARCHAR2 DEFAULT NULL
                      ,pi_dry_run_radios    BOOLEAN DEFAULT FALSE
                      );
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
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)xval_reval.pkb	1.1 03/14/05');
   htp.p('--       Module Name      : xval_reval.pkb');
   htp.p('--       Date into SCCS   : 05/03/14 23:11:30');
   htp.p('--       Date fetched Out : 07/06/06 14:33:58');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Valuations Revaluation package');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2004');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_year_end_dep IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'find_year_end_dep');
--
   xval_find_inv.main
        (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_year_end_dep_module
        ,p_module_title                 => c_year_end_dep_module_title
        );
--
   nm_debug.proc_end (g_package_name,'find_year_end_dep');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_year_end_dep;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_year_end_reval IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'find_year_end_reval');
--
   xval_find_inv.main
        (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_year_end_reval_module
        ,p_module_title                 => c_year_end_reval_mod_title
        );
--
   nm_debug.proc_end (g_package_name,'find_year_end_reval');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_year_end_reval;
--
-----------------------------------------------------------------------------
--
--PROCEDURE find_year_end_dep_dry IS
--BEGIN
----
--   nm_debug.proc_start (g_package_name,'find_year_end_dep_dry');
----
--   xval_find_inv.main
--        (p_restrict_to_val_parents_only => TRUE
--        ,p_module                       => c_year_end_reval_module
--        ,p_module_title                 => c_year_end_reval_mod_title
--        );
----
--   nm_debug.proc_end (g_package_name,'find_year_end_dep_dry');
----
--EXCEPTION
--  WHEN nm3web.g_you_should_not_be_here THEN NULL;
--  WHEN OTHERS
--   THEN
--     nm3web.failure(SQLERRM);
--END find_year_end_dep_dry;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_adhoc_many IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'find_adhoc_many');
--
   xval_find_inv.main
        (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_adhoc_reval_multi_module
        ,p_module_title                 => c_adhoc_reval_multi_mod_title
        );
--
   nm_debug.proc_end (g_package_name,'find_adhoc_many');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_adhoc_many;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_adhoc_single IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'find_adhoc_single');
--
   xval_find_inv.main
        (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_adhoc_reval_single_module
        ,p_module_title                 => c_adhoc_reval_single_mod_title
        );
--
   nm_debug.proc_end (g_package_name,'find_adhoc_single');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_adhoc_single;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_adhoc_many (pi_iit_ne_id nm3type.tab_varchar30) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'prompt_adhoc_many');
--
   internal_prompt_many (pi_iit_ne_id        => pi_iit_ne_id
                        ,pi_module           => c_adhoc_reval_multi_module
                        ,pi_module_title     => c_adhoc_reval_multi_mod_title
                        ,pi_prompt_column    => c_xvc_prompt_ad_hoc_many
                        ,pi_process_proc     => c_procedure_process_adhoc_many
                        ,pi_process_type_col => c_xvc_process_ad_hoc_many
                        );
--
   nm_debug.proc_end (g_package_name,'prompt_adhoc_many');
--
END prompt_adhoc_many;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_year_end_dep (pi_iit_ne_id nm3type.tab_varchar30) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'prompt_year_end_dep');
--
   internal_prompt_many (pi_iit_ne_id         => pi_iit_ne_id
                        ,pi_module            => c_year_end_dep_module
                        ,pi_module_title      => c_year_end_dep_module_title
                        ,pi_prompt_column     => c_xvc_prompt_year_end_dep_dep
--                        ,pi_prompt_column2    => c_xvc_process_year_end_val
                        ,pi_process_proc      => c_proc_process_year_end_dep
                        ,pi_process_type_col  => c_xvc_process_year_end_dep
--                        ,pi_process_type_col2 => c_xvc_process_year_end_dep
                        ,pi_dry_run_radios    => TRUE
                        );
--
   nm_debug.proc_end (g_package_name,'prompt_year_end_dep');
--
END prompt_year_end_dep;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_year_end_rev (pi_iit_ne_id nm3type.tab_varchar30) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'prompt_year_end_rev');
--
   internal_prompt_many (pi_iit_ne_id         => pi_iit_ne_id
                        ,pi_module            => c_year_end_reval_module
                        ,pi_module_title      => c_year_end_reval_mod_title
                        ,pi_prompt_column     => c_xvc_prompt_year_end_dep_val
                        ,pi_process_proc      => c_proc_process_year_end_reval
                        ,pi_process_type_col  => c_xvc_process_year_end_val
                        ,pi_dry_run_radios    => TRUE
                        );
-- YEAR_END_REVAL_PROCESS
--
   nm_debug.proc_end (g_package_name,'prompt_year_end_rev');
--
END prompt_year_end_rev;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_adhoc_single (pi_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   l_rec_iit     nm_inv_items%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'prompt_adhoc_single');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_adhoc_reval_single_mod_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_adhoc_reval_single_module);
--
   l_rec_iit     := nm3get.get_iit       (pi_iit_ne_id        => pi_iit_ne_id);
   g_rec_iit_val_old := get_valuation_record (pi_iit_ne_id_parent => l_rec_iit.iit_ne_id);
--
   get_tab_xvc (p_iit_inv_type => l_rec_iit.iit_inv_type
               ,p_column_name  => c_xvc_prompt_ad_hoc
               );
--
   htp.formopen (curl        => g_package_name||'.adhoc_process'
                ,cattributes => 'NAME="adhoc_process"'
                );
   htp.formhidden (cname=>'pi_module',cvalue=>c_adhoc_reval_single_module);
   htp.formhidden (cname=>'pi_module_title',cvalue=>c_adhoc_reval_single_mod_title);
   htp.formhidden (cname=>'pi_process_type_col',cvalue=>c_xvc_process_ad_hoc);
   htp.formhidden (cname=>'pi_iit_ne_id',cvalue=>0);
   htp.formhidden (cname=>'pi_iit_ne_id',cvalue=>pi_iit_ne_id);
--
   display_tab_xvc (pi_rec_xvc     => g_tab_xvc
                   ,pi_rec_iit_val => g_rec_iit_val_old
                   );
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end (g_package_name,'prompt_adhoc_single');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END prompt_adhoc_single;
--
-----------------------------------------------------------------------------
--
PROCEDURE display_tab_xvc (pi_rec_xvc     tab_xvc
                          ,pi_rec_iit_val nm_inv_items%ROWTYPE DEFAULT c_empty_rec_iit
                          ) IS
   l_rec_xvc     xval_valuation_columns%ROWTYPE;
   l_data_string nm3type.max_varchar2;
   l_lov_sql     nm3type.max_varchar2;
--
   c_data_col    CONSTANT VARCHAR2(30) := 'pi_data_col';
   c_data_string CONSTANT VARCHAR2(30) := 'pi_data_string';
--
BEGIN
--
   htp.tableopen (cattributes=>'BORDER=1');
--   htp.tablerowopen;
--   htp.tableheader (/*htf.small*/('Parameter'));
--   htp.tableheader (/*htf.small*/('Value'));
--   htp.tablerowclose;
--
   g_rec_iit_val := pi_rec_iit_val;
--
   htp.comment ('pass in some dummy values so that arrays are always passed');
   FOR i IN 1..2
    LOOP
      htp.formhidden (cname      => c_data_col
                     ,cvalue     => nm3type.c_nvl
                     );
      htp.formhidden (cname      => c_data_string
                     ,cvalue     => nm3type.c_nvl
                     );
   END LOOP;
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
   FOR i IN 1..pi_rec_xvc.COUNT
    LOOP
      l_rec_xvc := pi_rec_xvc(i);
--
      check_xvc_ita_view_col_name (p_xvc_ita_view_col_name => l_rec_xvc.xvc_ita_view_col_name
                                  ,p_xvc_sum_for_report    => l_rec_xvc.xvc_sum_for_report
                                  );
      g_value       := Null;
      IF   pi_rec_iit_val.iit_ne_id  IS NOT NULL
       AND is_column_in_table (c_nm_inv_items,g_rec_xvc_dets.ita_attrib_name)
       THEN
         DECLARE
            l_sql    nm3type.max_varchar2;
         BEGIN
            l_sql :=            'BEGIN'
                     ||CHR(10)||'   '||g_package_name||'.g_value := '||g_package_name||'.g_rec_iit_val.'||g_rec_xvc_dets.ita_attrib_name||';'
                     ||CHR(10)||'END;';
--            nm_debug.debug(l_sql);
            EXECUTE IMMEDIATE l_sql;
         EXCEPTION
            WHEN others
             THEN
               g_value := Null;
         END;
      END IF;
      l_data_string := htf.formhidden (cname      => c_data_col
                                      ,cvalue     => l_rec_xvc.xvc_ita_view_col_name
                                      );
      l_lov_sql := Null;
      l_lov_sql := nm3gaz_qry.get_ngqv_lov_sql (nm3gaz_qry.c_ngqt_item_type_type_inv
                                               ,c_val_inv_type
                                               ,g_rec_xvc_dets.ita_attrib_name
                                               );
      IF  l_lov_sql IS NOT NULL
       THEN
         l_data_string := l_data_string
                     ||CHR(10)||htf.formselectopen(c_data_string);
         DECLARE
            l_cur             nm3type.ref_cursor;
            l_lup_value       nm3type.max_varchar2;
            l_lup_meaning     nm3type.max_varchar2;
            l_lup_description nm3type.max_varchar2;
            l_i               PLS_INTEGER := 0;
            l_tab_value       nm3type.tab_varchar32767;
            l_tab_meaning     nm3type.tab_varchar32767;
         BEGIN
            IF g_rec_xvc_dets.ita_mandatory_yn = c_n
             THEN
               l_i                := l_i + 1;
               l_tab_value(l_i)   := Null;
               l_tab_meaning(l_i) := Null;
            END IF;
            OPEN  l_cur FOR  l_lov_sql;
            FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
            LOOP
               EXIT WHEN l_cur%NOTFOUND;
               l_i                := l_i + 1;
               l_tab_value(l_i)   := l_lup_value;
               l_tab_meaning(l_i) := l_lup_description;
               l_tab_meaning(l_i) := NVL(l_tab_meaning(l_i),l_lup_meaning);
               FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
            END LOOP;
            CLOSE l_cur;
            FOR i IN 1..l_i
             LOOP
               l_data_string := l_data_string
                     ||CHR(10)||'<OPTION VALUE="'||l_tab_value(i)||'"'
                              ||nm3flx.i_t_e(NVL(l_tab_value(i),nm3type.c_nvl)=NVL(g_value,nm3type.c_nvl)
                                            ,' SELECTED'
                                            ,Null
                                            )
                              ||'>'||l_tab_meaning(i)||'</OPTION>';
            END LOOP;
         END;
         l_data_string := l_data_string
                     ||CHR(10)||'</SELECT>';
      ELSE
         l_data_string := l_data_string
                     ||htf.formtext   (cname      => c_data_string
                                      ,csize      => NVL(g_rec_xvc_dets.ita_fld_length,50)
                                      ,cmaxlength => NVL(g_rec_xvc_dets.ita_fld_length,50)
                                      ,cvalue     => g_value
                                      );
      END IF;
--
      htp.tablerowopen;
      htp.tableheader (/*htf.small*/(g_rec_xvc_dets.ita_scrn_text||nm3flx.i_t_e(g_rec_xvc_dets.ita_mandatory_yn=c_y,c_sup_asterisk,Null)));
      htp.tabledata (l_data_string);
      htp.tablerowclose;
--
   END LOOP;
--
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit (cvalue=>xval_find_inv.c_continue), cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
--
END display_tab_xvc;
--
-----------------------------------------------------------------------------
--
FUNCTION put_tab_iit_ne_id_into_ngqi (p_tab_iit_ne_id nm3type.tab_varchar30) RETURN nm_gaz_query_item_list.ngqi_job_id%TYPE IS
BEGIN
--
   g_last_ngqi_job_id := nm3pbi.get_job_id;
--
   FORALL i IN 1..p_tab_iit_ne_id.COUNT
      INSERT INTO nm_gaz_query_item_list
            (ngqi_job_id
            ,ngqi_item_type_type
            ,ngqi_item_type
            ,ngqi_item_id
            )
      SELECT g_last_ngqi_job_id                   -- ngqi_job_id
            ,nm3gaz_qry.c_ngqt_item_type_type_inv -- ngqi_item_type_type
            ,iit_inv_type                         -- ngqi_item_type
            ,iit_ne_id                            -- ngqi_item_id
       FROM  nm_inv_items
      WHERE  iit_ne_id = p_tab_iit_ne_id(i);
--
   RETURN g_last_ngqi_job_id;
--
END put_tab_iit_ne_id_into_ngqi;
--
-----------------------------------------------------------------------------
--
PROCEDURE adhoc_process (pi_iit_ne_id        nm3type.tab_varchar30
                        ,pi_data_col         nm3type.tab_varchar32767
                        ,pi_data_string      nm3type.tab_varchar32767
                        ,pi_module           VARCHAR2
                        ,pi_module_title     VARCHAR2
                        ,pi_process_type_col VARCHAR2
                        ) IS
   l_tab_iit_ne_id  nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start (g_package_name,'adhoc_process');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => pi_module_title
               );
   xval_find_inv.create_js_funcs;
   htp.headclose;
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(pi_module);
--
   l_tab_iit_ne_id := delete_zero_ids_from_table (pi_iit_ne_id);
--
   FOR i IN 1..l_tab_iit_ne_id.COUNT
    LOOP
      perform_adhoc_reval (pi_iit_ne_id        => l_tab_iit_ne_id(i)
                          ,pi_data_col         => pi_data_col
                          ,pi_data_string      => pi_data_string
                          ,pi_process_type_col => pi_process_type_col
                          );
   END LOOP;
--
   xval_find_inv.js_ner (pi_appl               => nm3type.c_hig
                        ,pi_id                 => 95
                        ,pi_supplementary_info => c_revaluation
                        );
--
   xval_find_inv.show_results
                        (p_module      => Null
                        ,p_ngqi_job_id => put_tab_iit_ne_id_into_ngqi (l_tab_iit_ne_id)
                        );
--
   html_dump_report_array (p_window_title      => pi_module_title
                          ,p_calling_pack_proc => g_package_name||'.adhoc_process;'
                          );
--
--   dump_out_table_pairs (pi_header => pi_data_col
--                        ,pi_detail => pi_data_string
--                        );
--
   COMMIT;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end (g_package_name,'adhoc_process');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END adhoc_process;
--
-----------------------------------------------------------------------------
--
FUNCTION delete_zero_ids_from_table (pi_table nm3type.tab_varchar30) RETURN nm3type.tab_varchar30 IS
   l_retval nm3type.tab_varchar30;
BEGIN
   FOR i IN 1..pi_table.COUNT
    LOOP
      IF NVL(pi_table(i),0) != 0
       THEN
         l_retval (l_retval.COUNT+1) := pi_table(i);
      END IF;
   END LOOP;
   RETURN l_retval;
END delete_zero_ids_from_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_out_table_pairs (pi_header   nm3type.tab_varchar32767
                               ,pi_detail   nm3type.tab_varchar32767
                               ) IS
BEGIN
   htp.tableopen (cattributes=>'BORDER=1');
   FOR i IN 1..pi_header.COUNT
    LOOP
      IF NVL(pi_header(i),nm3type.c_nvl) != nm3type.c_nvl
       THEN
         htp.tablerowopen;
         htp.tableheader(/*htf.small*/(pi_header(i)));
         htp.tabledata(nm3flx.i_t_e (pi_detail(i) IS NULL
                                    ,nm3web.c_nbsp
                                    ,/*htf.small*/(pi_detail(i))
                                    )
                      );
         htp.tablerowclose;
      END IF;
   END LOOP;
   htp.tableclose;
END dump_out_table_pairs;
--
-----------------------------------------------------------------------------
--
PROCEDURE year_end_dep_process (pi_iit_ne_id        IN nm3type.tab_varchar30
                               ,pi_data_col         IN nm3type.tab_varchar32767
                               ,pi_data_string      IN nm3type.tab_varchar32767
                               ,pi_dry_run          IN VARCHAR2 DEFAULT nm3type.c_true
                               ,pi_process_type_col IN VARCHAR2 DEFAULT c_xvc_process_year_end_dep
                               ,pi_module           IN VARCHAR2 DEFAULT c_year_end_dep_module
                               ,pi_module_title     IN VARCHAR2 DEFAULT c_year_end_dep_module_title
                               ) IS
   l_dry_run BOOLEAN := nm3flx.char_to_boolean (pi_dry_run);
BEGIN
--
   nm_debug.proc_start (g_package_name,'year_end_dep_process');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => pi_module_title
               );
   xval_find_inv.create_js_funcs;
   htp.headclose;
   sccs_tags;
   htp.bodyopen;
--
   IF NVL(pi_process_type_col,nm3type.c_nvl) != NVL(c_xvc_process_year_end_dep,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_process_type_col != '||c_xvc_process_year_end_dep||' ('||pi_process_type_col||')'
                    );
   ELSIF NVL(c_year_end_dep_module,nm3type.c_nvl) != NVL(pi_module,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_module != '||c_year_end_dep_module||' ('||pi_module||')'
                    );
   ELSIF NVL(c_year_end_dep_module_title,nm3type.c_nvl) != NVL(pi_module_title,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_module_title != '||c_year_end_dep_module_title||' ('||pi_module_title||')'
                    );
   END IF;

--
   nm3web.module_startup(pi_module);
--   htp.p('<style>{cursor:wait}</style>');
--
   perform_year_end_dep (pi_iit_ne_id        => pi_iit_ne_id
                        ,pi_data_col         => pi_data_col
                        ,pi_data_string      => pi_data_string
--                        ,pi_process_type_col => pi_process_type_col
                        );
--
   xval_find_inv.show_results
                      (p_module      => Null
                      ,p_ngqi_job_id => put_tab_iit_ne_id_into_ngqi (pi_iit_ne_id)
                      );
--   htp.p('<style>{cursor:default}</style>');
--
   xval_find_inv.js_ner (pi_appl               => nm3type.c_hig
                        ,pi_id                 => 95
                        ,pi_supplementary_info => nm3flx.i_t_e (l_dry_run
                                                               ,c_dry_run||' '
                                                               ,Null
                                                               )
                                                  ||c_depreciation
                        );
--
--   dump_out_table_pairs (pi_header => pi_data_col
--                        ,pi_detail => pi_data_string
--                        );
--
   html_dump_report_array (p_window_title      => pi_module_title
                          ,p_calling_pack_proc => g_package_name||'.year_end_dep_process;'
                          );
--
   -- Make reports available
--
   htp.bodyclose;
   htp.htmlclose;
--
   IF l_dry_run
    THEN
      ROLLBACK;
   ELSE
      COMMIT;
   END IF;
--
   nm_debug.proc_end (g_package_name,'year_end_dep_process');
--
EXCEPTION
--
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
--
END year_end_dep_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE year_end_reval_process (pi_iit_ne_id        IN nm3type.tab_varchar30
                                 ,pi_data_col         IN nm3type.tab_varchar32767
                                 ,pi_data_string      IN nm3type.tab_varchar32767
                                 ,pi_dry_run          IN VARCHAR2 DEFAULT nm3type.c_true
                                 ,pi_process_type_col IN VARCHAR2 DEFAULT c_xvc_process_year_end_val
                                 ,pi_module           IN VARCHAR2 DEFAULT c_year_end_reval_module
                                 ,pi_module_title     IN VARCHAR2 DEFAULT c_year_end_reval_mod_title
                                 ) IS
   l_dry_run BOOLEAN := nm3flx.char_to_boolean (pi_dry_run);
BEGIN
--
   nm_debug.proc_start (g_package_name,'year_end_reval_process');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => pi_module_title
               );
   xval_find_inv.create_js_funcs;
   htp.headclose;
   sccs_tags;
   htp.bodyopen;
--
   IF NVL(pi_process_type_col,nm3type.c_nvl) != NVL(c_xvc_process_year_end_val,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_process_type_col != '||c_xvc_process_year_end_val||' ('||pi_process_type_col||')'
                    );
   ELSIF NVL(c_year_end_reval_module,nm3type.c_nvl) != NVL(pi_module,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_module != '||c_year_end_reval_module||' ('||pi_module||')'
                    );
   ELSIF NVL(c_year_end_reval_mod_title,nm3type.c_nvl) != NVL(pi_module_title,nm3type.c_nvl)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => 'pi_module_title != '||c_year_end_reval_mod_title||' ('||pi_module_title||')'
                    );
   END IF;
--
   nm3web.module_startup(pi_module);
--
   perform_year_end_reval (pi_iit_ne_id        => pi_iit_ne_id
                          ,pi_data_col         => pi_data_col
                          ,pi_data_string      => pi_data_string
                          );
--
   xval_find_inv.show_results
                      (p_module      => Null
                      ,p_ngqi_job_id => put_tab_iit_ne_id_into_ngqi (pi_iit_ne_id)
                      );
--
   xval_find_inv.js_ner (pi_appl               => nm3type.c_hig
                        ,pi_id                 => 95
                        ,pi_supplementary_info => nm3flx.i_t_e (l_dry_run
                                                               ,c_dry_run||' '
                                                               ,Null
                                                               )
                                                  ||c_revaluation
                        );
--
   html_dump_report_array (p_window_title      => pi_module_title
                          ,p_calling_pack_proc => g_package_name||'.year_end_reval_process'
                          );
--
--   dump_out_table_pairs (pi_header => pi_data_col
--                        ,pi_detail => pi_data_string
--                        );
--
   -- Make reports available

--
   htp.bodyclose;
   htp.htmlclose;
--
   IF l_dry_run
    THEN
      ROLLBACK;
   ELSE
      COMMIT;
   END IF;
--
   nm_debug.proc_end (g_package_name,'year_end_reval_process');
--
EXCEPTION
--
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
--
END year_end_reval_process;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_adhoc_reval (pi_iit_ne_id        IN nm_inv_items.iit_ne_id%TYPE
                              ,pi_data_col         IN nm3type.tab_varchar32767
                              ,pi_data_string      IN nm3type.tab_varchar32767
                              ,pi_process_type_col IN VARCHAR2 DEFAULT c_xvc_process_ad_hoc
                              ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'perform_adhoc_reval');
--
   perform_reval_internal (pi_iit_ne_id          => pi_iit_ne_id
                          ,pi_data_col           => pi_data_col
                          ,pi_data_string        => pi_data_string
                          ,pi_process_type_col   => pi_process_type_col
                          ,pi_xvc_xf_formula_col => c_xvc_xf_id_ad_hoc
                          );
--
   nm_debug.proc_end (g_package_name,'perform_adhoc_reval');
--
END perform_adhoc_reval;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_year_end_dep (pi_iit_ne_id        IN nm3type.tab_varchar30
                               ,pi_data_col         IN nm3type.tab_varchar32767
                               ,pi_data_string      IN nm3type.tab_varchar32767
                               ,pi_dry_run          IN BOOLEAN DEFAULT FALSE
                               ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'perform_year_end_dep');
--
   perform_reval_internal (pi_iit_ne_id          => pi_iit_ne_id
                          ,pi_data_col           => pi_data_col
                          ,pi_data_string        => pi_data_string
                          ,pi_process_type_col   => c_xvc_process_year_end_dep
                          ,pi_xvc_xf_formula_col => c_xvc_xf_id_year_end_dep
                          ,pi_dry_run            => pi_dry_run
                          );
--
   nm_debug.proc_end (g_package_name,'perform_year_end_dep');
--
END perform_year_end_dep;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_year_end_reval (pi_iit_ne_id        IN nm3type.tab_varchar30
                                 ,pi_data_col         IN nm3type.tab_varchar32767
                                 ,pi_data_string      IN nm3type.tab_varchar32767
                                 ,pi_dry_run          IN BOOLEAN DEFAULT FALSE
                                 ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'perform_year_end_reval');
--
   perform_reval_internal (pi_iit_ne_id          => pi_iit_ne_id
                          ,pi_data_col           => pi_data_col
                          ,pi_data_string        => pi_data_string
                          ,pi_process_type_col   => c_xvc_process_year_end_val
                          ,pi_xvc_xf_formula_col => c_xvc_xf_id_year_end_val
                          ,pi_dry_run            => pi_dry_run
                          );
--
   nm_debug.proc_end (g_package_name,'perform_year_end_reval');
--
END perform_year_end_reval;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_reval_internal (pi_iit_ne_id          IN nm3type.tab_varchar30
                                 ,pi_data_col           IN nm3type.tab_varchar32767
                                 ,pi_data_string        IN nm3type.tab_varchar32767
                                 ,pi_process_type_col   IN VARCHAR2
                                 ,pi_xvc_xf_formula_col IN VARCHAR2
                                 ,pi_dry_run            IN BOOLEAN DEFAULT FALSE
                                 ) IS
--
   l_tab_iit_ne_id nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'perform_reval_internal');
--
   l_tab_iit_ne_id := delete_zero_ids_from_table (pi_table => pi_iit_ne_id);
--
   FOR i IN 1..l_tab_iit_ne_id.COUNT
    LOOP
      perform_reval_internal (pi_iit_ne_id          => l_tab_iit_ne_id(i)
                             ,pi_data_col           => pi_data_col
                             ,pi_data_string        => pi_data_string
                             ,pi_process_type_col   => pi_process_type_col
                             ,pi_xvc_xf_formula_col => pi_xvc_xf_formula_col
                             ,pi_dry_run            => pi_dry_run
                             );
   END LOOP;
--
   nm_debug.proc_end (g_package_name,'perform_reval_internal');
--
END perform_reval_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_reval_internal (pi_iit_ne_id          IN nm_inv_items.iit_ne_id%TYPE
                                 ,pi_data_col           IN nm3type.tab_varchar32767
                                 ,pi_data_string        IN nm3type.tab_varchar32767
                                 ,pi_process_type_col   IN VARCHAR2
                                 ,pi_xvc_xf_formula_col IN VARCHAR2
                                 ,pi_dry_run            IN BOOLEAN DEFAULT FALSE
                                 ) IS
   l_rec_iit       nm_inv_items%ROWTYPE;
--
   l_val_rowid     ROWID;
   l_sql           nm3type.tab_varchar32767;
   l_attrib_name   nm_inv_type_attribs.ita_attrib_name%TYPE;
   l_rebuild_the_sql  BOOLEAN := TRUE;
   l_tab_ita          nm3inv.tab_nita;
--
   c_g_rec_iit_val         CONSTANT VARCHAR2(30) := 'g_rec_iit_val';
   c_dot_g_rec_iit_val_dot CONSTANT VARCHAR2(32) := '.'||c_g_rec_iit_val||'.';
   c_rpad_len              CONSTANT PLS_INTEGER  := LENGTH(g_package_name||c_dot_g_rec_iit_val_dot)+30;
--
   l_tab_moves             nm3type.tab_varchar32767;
   l_index                 PLS_INTEGER;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_sql, p_text, p_nl);
   END append;
--
   PROCEDURE append_moves (p_index PLS_INTEGER,p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append_moves (p_index, CHR(10), FALSE);
      END IF;
      IF NOT l_tab_moves.EXISTS(p_index)
       THEN
         l_tab_moves(p_index) := Null;
      END IF;
      l_tab_moves(p_index)    := l_tab_moves(p_index)||p_text;
   END append_moves;
--
   FUNCTION get_data_col_data_type (p_data_col_index PLS_INTEGER) RETURN VARCHAR2 IS
      l_retval VARCHAR2(200) := 'nm3type.max_varchar2';
   BEGIN
      IF l_tab_ita.EXISTS(p_data_col_index)
       AND l_tab_ita(p_data_col_index).ita_format != nm3type.c_varchar
       THEN
         l_retval := l_tab_ita(p_data_col_index).ita_format;
         IF l_tab_ita(p_data_col_index).ita_format = nm3type.c_date
          THEN
            l_retval := l_retval||' := xval_create_inv.harsh_date_check('||g_package_name||'.g_data_string('||p_data_col_index||'))';
         ELSIF l_tab_ita(p_data_col_index).ita_format = nm3type.c_number
          THEN
            l_retval := l_retval||' := xval_create_inv.harsh_number_check('||g_package_name||'.g_data_string('||p_data_col_index||'))';
         ELSE
            l_retval := l_retval||' := '||g_package_name||'.g_data_string('||p_data_col_index||')';
         END IF;
      ELSE
         l_retval := l_retval||' := '||g_package_name||'.g_data_string('||p_data_col_index||')';
      END IF;
      RETURN l_retval;
   END get_data_col_data_type;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'perform_reval_internal');
--
   l_rec_iit := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id);
   g_rec_iit_parent := l_rec_iit;
--
   nm3lock.lock_inv_item_and_members (pi_iit_ne_id      => l_rec_iit.iit_ne_id
                                     ,p_lock_for_update => TRUE
                                     );
--
   xval_find_inv.instantiate_for_inv_type (l_rec_iit.iit_inv_type);
--
   g_rec_iit_val_old := get_valuation_record (pi_iit_ne_id_parent => l_rec_iit.iit_ne_id);
   g_rec_iit_val := g_rec_iit_val_old;
   g_data_string := pi_data_string;
--
   l_val_rowid   := nm3lock_gen.lock_iit_all (pi_iit_ne_id => g_rec_iit_val_old.iit_ne_id);
--
   IF  l_rec_iit.iit_inv_type != g_last_iit_inv_type
    OR pi_process_type_col    != g_last_process_type_col
    THEN
      l_rebuild_the_sql       := TRUE;
      g_last_iit_inv_type     := l_rec_iit.iit_inv_type;
      g_last_process_type_col := pi_process_type_col;
      l_sql.DELETE;
      append ('DECLARE',FALSE);
      append ('   c_val_inv_type CONSTANT nm_inv_types.nit_inv_type%TYPE := '||c_val_inv_type_str||';');
      append ('   CURSOR cs_xvc (c_nit_inv_type_parent nm_inv_types.nit_inv_type%TYPE )IS');
      append ('   SELECT '||g_package_name||'.triple_translate_formula_str(xf.xf_formula,c_nit_inv_type_parent) translated_formula');
      append ('         ,xf.xf_formula');
      append ('         ,NVL(ita_val.ita_attrib_name, xvc.xvc_ita_view_col_name) ita_attrib_name');
      append ('         ,xvc.xvc_ita_view_col_name ita_view_col_name');
      append ('         ,xvc.xvc_process_seq_no');
      append ('         ,xvc.xvc_sum_for_report');
      append ('         ,NVL(ita_val.ita_scrn_text, xvc.xvc_ita_view_col_name) ita_scrn_text');
      append ('         ,DECODE(ita_val.ita_attrib_name,Null,'||nm3flx.string('N')||','||nm3flx.string('N')||') is_ita');
      append ('    FROM  xval_valuation_columns xvc');
      append ('         ,xval_formulae          xf');
      append ('         ,nm_inv_type_attribs    ita_val');
      append ('   WHERE  xvc.xvc_nit_inv_type          = c_nit_inv_type_parent');
      append ('    AND   xvc.'||pi_process_type_col||' = '||c_y_str);
      --append ('    AND   xvc.xvc_xf_id                 = xf.xf_id');
      append ('    AND   xvc.'||pi_xvc_xf_formula_col||' = xf.xf_id');
      append ('    AND   ita_val.ita_inv_type      (+) = c_val_inv_type');
      append ('    AND   ita_val.ita_view_col_name (+) = xvc.xvc_ita_view_col_name');
      append ('   ORDER BY xvc_process_seq_no;');
      append ('BEGIN');
      append ('   OPEN  cs_xvc ('||g_package_name||'.g_last_iit_inv_type);');
      append ('   FETCH cs_xvc');
      append ('    BULK COLLECT');
      append ('    INTO '||g_package_name||'.g_tab_translated_formula');
      append ('        ,'||g_package_name||'.g_tab_xf_formula');
      append ('        ,'||g_package_name||'.g_tab_ita_attrib_name');
      append ('        ,'||g_package_name||'.g_tab_ita_view_col_name');
      append ('        ,'||g_package_name||'.g_tab_xvc_process_seq_no');
      append ('        ,'||g_package_name||'.g_tab_xvc_sum_for_report');
      append ('        ,'||g_package_name||'.g_tab_ita_scrn_text');
      append ('        ,'||g_package_name||'.g_tab_is_ita;');
      append ('   CLOSE cs_xvc;');
      append ('END;');
      --
--      nm_debug.delete_debug(TRUE);
--      nm_debug.debug_on;
      nm3tab_varchar.debug_tab_varchar(l_sql);
      --
      nm3ddl.execute_tab_varchar (l_sql);
   END IF;
--
   IF l_rebuild_the_sql
    THEN
      l_sql.DELETE;
   --
      append ('DECLARE',FALSE);
      append ('   --');
      FOR i IN 1..pi_data_col.COUNT
       LOOP
       --
         IF   pi_data_col(i) != nm3type.c_nvl
          THEN
            l_tab_ita(i) := nm3get.get_ita (pi_ita_inv_type      => c_val_inv_type
                                           ,pi_ita_view_col_name => pi_data_col(i)
                                           ,pi_raise_not_found   => FALSE
                                           );
            append ('   '||RPAD(LOWER(pi_data_col(i)),30)||' '||get_data_col_data_type(i)||';');
         END IF;
       --
      END LOOP;
      append ('   --');
      append ('BEGIN');
      append ('   Null; -- Dummy');
--      FOR i IN 1..pi_data_col.COUNT
--       LOOP
--       --
--         IF   pi_data_col(i) != nm3type.c_nvl
--          THEN
--            append ('   nm_debug.debug('||nm3flx.string(pi_data_col(i)||' : ')||'||'||pi_data_col(i)||');');
--         END IF;
--       --
--      END LOOP;
--      append ('   --');
--      append ('   -- ###########################################################');
--      append ('   -- Move "Static" (i.e. prompted for) values to global variable');
--      append ('   -- ###########################################################');
--      append ('   --');
      FOR i IN 1..pi_data_col.COUNT
       LOOP
       --
         IF   pi_data_col(i) != nm3type.c_nvl
          THEN
            l_attrib_name := Null;
            IF l_tab_ita.EXISTS(i)
             THEN
               l_attrib_name := l_tab_ita(i).ita_attrib_name;
            ELSIF is_column_in_table (c_nm_inv_items,pi_data_col(i))
             THEN
               l_attrib_name := pi_data_col(i);
            END IF;
            IF l_attrib_name IS NOT NULL
             THEN
--               append_moves(i,'   nm_debug.debug('||nm3flx.string(pi_data_col(i))||');',FALSE);
--               append_moves(i,'   nm_debug.debug('||g_package_name||c_dot_g_rec_iit_val_dot||LOWER(l_attrib_name)||');');
               append_moves(i,'   '||RPAD(g_package_name||c_dot_g_rec_iit_val_dot||LOWER(l_attrib_name),c_rpad_len)||' := '||lower(pi_data_col(i))||';');
--               append_moves(i,'   nm_debug.debug('||g_package_name||c_dot_g_rec_iit_val_dot||LOWER(l_attrib_name)||');');
            END IF;
         END IF;
       --
      END LOOP;
      --
--      append ('   --');
--      append ('   -- #############################################');
--      append ('   -- Move Formula-Driven values to global variable');
--      append ('   -- #############################################');
--      append ('   --');
   --
      FOR i IN 1..g_tab_translated_formula.COUNT
       LOOP
         is_column_in_table (c_nm_inv_items,g_tab_ita_attrib_name(i));
         append_moves(g_tab_xvc_process_seq_no(i),'   -- '||g_tab_ita_view_col_name(i)||' = '||g_tab_xf_formula(i),FALSE);
--         append_moves(g_tab_xvc_process_seq_no(i),'   nm_debug.debug('||nm3flx.string(g_tab_ita_view_col_name(i))||');');
--         append_moves(g_tab_xvc_process_seq_no(i),'   nm_debug.debug('||g_package_name||c_dot_g_rec_iit_val_dot||LOWER(g_tab_ita_attrib_name(i))||');');
         IF g_tab_is_ita(i) = 'Y'
          THEN
            append_moves(g_tab_xvc_process_seq_no(i),'   '||RPAD(g_package_name||c_dot_g_rec_iit_val_dot||LOWER(g_tab_ita_attrib_name(i)),c_rpad_len)||' := nm3inv.validate_flex_inv('||c_val_inv_type_str||','||nm3flx.string(g_tab_ita_attrib_name(i))||','||g_tab_translated_formula(i)||');');
         ELSE
            append_moves(g_tab_xvc_process_seq_no(i),'   '||RPAD(g_package_name||c_dot_g_rec_iit_val_dot||LOWER(g_tab_ita_attrib_name(i)),c_rpad_len)||' := '||g_tab_translated_formula(i)||';');
         END IF;
--         append_moves(g_tab_xvc_process_seq_no(i),'   nm_debug.debug('||g_package_name||c_dot_g_rec_iit_val_dot||LOWER(g_tab_ita_attrib_name(i))||');');
      END LOOP;
      --
      append ('--');
      l_index := l_tab_moves.FIRST;
      WHILE l_index IS NOT NULL
       LOOP
         append ('   /* '||l_index||' */');
         append (l_tab_moves(l_index));
         append ('--');
         l_index := l_tab_moves.NEXT(l_index);
      END LOOP;
      --
      append ('--');
      append ('-- Summing for reports');
      append ('--');
      FOR i IN 1..g_tab_translated_formula.COUNT
       LOOP
         IF g_tab_xvc_sum_for_report(i) = c_y
          THEN
            append ('   -- '||g_tab_xvc_process_seq_no(i)||' - '||g_tab_ita_scrn_text(i));
            append ('   '||g_package_name||'.add_to_report_arrays ('||g_package_name||c_dot_g_rec_iit_val_dot||LOWER(g_tab_ita_attrib_name(i))||', '||g_package_name||'.g_tab_xvc_process_seq_no('||i||'), '||g_package_name||'.g_tab_ita_scrn_text('||i||'));');
         END IF;
      END LOOP;
      append ('--');
      append ('END;');
   END IF;
   --
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm3tab_varchar.debug_tab_varchar(l_sql);
   --
   g_rec_iit_val.iit_ne_id       := nm3seq.next_ne_id_seq;
   g_rec_iit_val.iit_primary_key := Null;
   g_rec_iit_val.iit_start_date  := nm3user.get_effective_date;
   --
   nm3ddl.execute_tab_varchar (l_sql);
--   nm_debug.debug_off;
   --
   IF NOT pi_dry_run
    THEN
      --
      -- create the new valuation record
      nm3ins.ins_iit (p_rec_iit => g_rec_iit_val);
      --
      -- end date the old valuation record
      UPDATE nm_inv_items_all
       SET   iit_end_date = nm3user.get_effective_date
      WHERE  ROWID        = l_val_rowid;
      --
   END IF;
   --
   xval_audit.create_nat_pair_for_val
                    (p_rec_iit_old => g_rec_iit_val_old
                    ,p_rec_iit_new => g_rec_iit_val
                    ,p_audit_type  => xval_audit.c_update
                    );
--
   nm_debug.proc_end (g_package_name,'perform_reval_internal');
--
END perform_reval_internal;
--
-----------------------------------------------------------------------------
--
FUNCTION get_valuation_record (pi_iit_ne_id_parent nm_inv_items.iit_ne_id%TYPE) RETURN nm_inv_items%ROWTYPE IS
   CURSOR cs_val (c_iit_ne_id_parent nm_inv_items.iit_ne_id%TYPE) IS
   SELECT iit.*
    FROM  nm_inv_items          iit
         ,nm_inv_item_groupings iig
   WHERE  iig.iig_parent_id = c_iit_ne_id_parent
    AND   iig.iig_item_id   = iit.iit_ne_id
    AND   iit.iit_inv_type  = c_val_inv_type;
--
   l_retval nm_inv_items%ROWTYPE;
   l_found  BOOLEAN;
--
BEGIN
--
   OPEN  cs_val (pi_iit_ne_id_parent);
   FETCH cs_val INTO l_retval;
   l_found := cs_val%FOUND;
   CLOSE cs_val;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => nm3inv.get_nit_descr(c_val_inv_type)||' record for asset'
                    );
   END IF;
--
   RETURN l_retval;
--
END get_valuation_record;
--
-----------------------------------------------------------------------------
--
FUNCTION triple_translate_formula_str (p_xf_formula      xval_formulae.xf_formula%TYPE
                                      ,p_inv_type_parent VARCHAR2
                                      ) RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   l_retval := translate_formula_string (p_xf_formula => p_xf_formula
                                        ,p_inv_type   => c_val_inv_type
                                        );
   l_retval := translate_formula_string (p_xf_formula => l_retval
                                        ,p_inv_type   => c_val_inv_type_old
                                        );
   l_retval := translate_formula_string (p_xf_formula => l_retval
                                        ,p_inv_type   => p_inv_type_parent
                                        );
   RETURN l_retval;
END triple_translate_formula_str;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_formula_string (p_xf_formula xval_formulae.xf_formula%TYPE
                                  ,p_inv_type   VARCHAR2 DEFAULT xval_find_inv.get_val_inv_type
                                  ) RETURN VARCHAR2 IS
--
   l_retval           nm3type.max_varchar2;
--
   l_sanity           PLS_INTEGER := 0;
   i                  PLS_INTEGER := 1;
   j                  PLS_INTEGER;
   l_ascii            PLS_INTEGER;
   l_view_col_name    nm3type.max_varchar2;
   l_attrib_name      nm3type.max_varchar2;
   l_inv_type         nm_inv_types.nit_inv_type%TYPE;
--
   c_formula_length   CONSTANT PLS_INTEGER  := LENGTH(p_xf_formula);
   c_inv_type_dot     CONSTANT VARCHAR2(31) := p_inv_type||'.';
   c_inv_type_dot_len CONSTANT PLS_INTEGER  := LENGTH(c_inv_type_dot);
   c_record_name               VARCHAR2(30);
--
BEGIN
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--nm_debug.debug('p_xf_formula='||p_xf_formula);
--nm_debug.debug('c_inv_type_dot_len='||c_inv_type_dot_len);
--nm_debug.debug('c_inv_type_dot='||c_inv_type_dot);
--
   IF p_inv_type = c_val_inv_type
    THEN
      l_inv_type    := p_inv_type;
      c_record_name := 'g_rec_iit_val';
   ELSIF p_inv_type = c_val_inv_type||'_OLD'
    THEN
      l_inv_type    := c_val_inv_type;
      c_record_name := 'g_rec_iit_val_old';
   ELSE
      l_inv_type    := p_inv_type;
      c_record_name := 'g_rec_iit_parent';
   END IF;
--
   WHILE i <= LENGTH(p_xf_formula)
    LOOP
--
      l_sanity := l_sanity + 1;
      IF l_sanity > 4000
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 28
                       ,pi_supplementary_info => 'loop sanity check exceeded in '||g_package_name||'.translate_formula_string'
                       );
      END IF;
--
--nm_debug.debug('.....');
--nm_debug.debug('i='||i);
--nm_debug.debug(UPPER(SUBSTR(p_xf_formula,i,c_inv_type_dot_len)));
      IF UPPER(SUBSTR(p_xf_formula,i,c_inv_type_dot_len)) = c_inv_type_dot
       THEN
         l_retval := l_retval||g_package_name||'.'||c_record_name||'.';
         l_view_col_name := Null;
--         nm_debug.debug('FOR k IN ('||to_char(i+c_inv_type_dot_len)||')..'||to_char(LENGTH(p_xf_formula)));
         FOR k IN (i+c_inv_type_dot_len)..c_formula_length
          LOOP
            l_ascii := ASCII(SUBSTR(p_xf_formula,k,1));
            IF   l_ascii NOT BETWEEN 65 AND 90  -- A-Z
             AND l_ascii NOT BETWEEN 97 AND 122 -- a-z
             AND l_ascii != 95 -- _
             THEN
--               nm_debug.debug('getting out- l_ascii='||l_ascii||'...k='||k);
               j := k;
               EXIT;
            ELSE
               l_view_col_name := l_view_col_name||SUBSTR(p_xf_formula,k,1);
            END IF;
            IF k = c_formula_length
             THEN
               j := k+1;
            END IF;
         END LOOP;
         IF l_view_col_name IS NOT NULL
          THEN
--            nm_debug.debug(l_view_col_name);
            IF LENGTH(l_view_col_name) > 30
             THEN
               hig.raise_ner (pi_appl               => nm3type.c_net
                             ,pi_id                 => 28
                             ,pi_supplementary_info => l_view_col_name||' is too long to be a valid ITA_VIEW_COL_NAME'
                             );
            END IF;
            l_view_col_name := UPPER(l_view_col_name);
            l_attrib_name   := nm3get.get_ita (pi_ita_inv_type      => l_inv_type
                                              ,pi_ita_view_col_name => l_view_col_name
                                              ,pi_raise_not_found   => FALSE
                                              ).ita_attrib_name;
            IF l_attrib_name IS NULL
             THEN
               IF is_column_in_table (c_nm_inv_items,l_view_col_name)
                THEN
                  l_attrib_name := l_view_col_name;
               ELSE
                  hig.raise_ner (pi_appl               => nm3type.c_hig
                                ,pi_id                 => 67
                                ,pi_supplementary_info =>            'NM_INV_TYPE_ATTRIBS:'
                                                          ||CHR(10)||'ITA_INV_TYPE='||l_inv_type
                                                          ||CHR(10)||'ITA_VIEW_COL_NAME='||l_view_col_name
                                );
               END IF;
            END IF;
            l_retval := l_retval||LOWER(l_attrib_name);
            i := j;
         ELSIF j = c_formula_length
          THEN
            i := j;
         END IF;
      ELSE
         l_retval := l_retval||SUBSTR(p_xf_formula,i,1);
         i := i + 1;
      END IF;
--
   END LOOP;
--nm_debug.debug_off;
--
   RETURN l_retval;
--
END translate_formula_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE is_column_in_table (p_table_name  VARCHAR2
                             ,p_column_name VARCHAR2
                             ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                             ) IS
BEGIN
   IF NOT is_column_in_table (p_table_name  => p_table_name
                             ,p_column_name => p_column_name
                             ,p_table_owner => p_table_owner
                             )
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 147
                    ,pi_supplementary_info => p_table_owner||'.'||p_table_name||'.'||p_column_name
                    );
   END IF;
END is_column_in_table;
--
-----------------------------------------------------------------------------
--
FUNCTION is_column_in_table (p_table_name  VARCHAR2
                            ,p_column_name VARCHAR2
                            ,p_table_owner VARCHAR2 DEFAULT hig.get_application_owner
                            ) RETURN BOOLEAN IS
   CURSOR cs_atc IS
   SELECT 1
    FROM  all_tab_columns
   WHERE  owner       = p_table_owner
    AND   table_name  = p_table_name
    AND   column_name = p_column_name;
   l_dummy  PLS_INTEGER;
   l_retval BOOLEAN;
BEGIN
--
   OPEN  cs_atc;
   FETCH cs_atc INTO l_dummy;
   l_retval := cs_atc%FOUND;
   CLOSE cs_atc;
--
   RETURN l_retval;
--
END is_column_in_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_xvc_ita_view_col_name (p_xvc_ita_view_col_name xval_valuation_columns.xvc_ita_view_col_name%TYPE
                                      ,p_xvc_sum_for_report    xval_valuation_columns.xvc_sum_for_report%TYPE
                                      ) IS
--
   l_sql nm3type.max_varchar2;
--
BEGIN
   nm_debug.proc_start (g_package_name,'check_xvc_ita_view_col_name');
--
   l_sql :=            'DECLARE'
            ||CHR(10)||'   c_col CONSTANT VARCHAR2(30) := '||g_package_name||'.g_col_name;'
            ||CHR(10)||'   CURSOR cs_cur IS'
            ||CHR(10)||'   SELECT *'
            ||CHR(10)||'    FROM ('
            ||CHR(10)||get_xvc_ita_view_col_name_lov
            ||CHR(10)||'         )'
            ||CHR(10)||'   WHERE ita_view_col_name = c_col;'
            ||CHR(10)||'   l_found  BOOLEAN;'
            ||CHR(10)||'   l_found2 BOOLEAN := FALSE;'
            ||CHR(10)||'   l_dummy  cs_cur%ROWTYPE;'
            ||CHR(10)||'BEGIN'
            ||CHR(10)||'   OPEN  cs_cur;'
            ||CHR(10)||'   FETCH cs_cur INTO l_dummy;'
            ||CHR(10)||'   l_found  := cs_cur%FOUND;'
            ||CHR(10)||'   IF l_found'
            ||CHR(10)||'    THEN' -- look for a second one - will only happen if someone sets up a ITA_VIEW_COL_NAME of "IIT_DESCR" or similar
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_view_col_name := l_dummy.ita_view_col_name;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_scrn_text     := l_dummy.ita_scrn_text;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_disp_seq_no   := l_dummy.ita_disp_seq_no;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_mandatory_yn  := l_dummy.ita_mandatory_yn;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_attrib_name   := l_dummy.ita_attrib_name;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_fld_length    := l_dummy.ita_fld_length;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.is_ita            := l_dummy.is_ita;'
            ||CHR(10)||'      '||g_package_name||'.g_rec_xvc_dets.ita_format        := l_dummy.ita_format;'
            ||CHR(10)||'      FETCH cs_cur INTO l_dummy;'
            ||CHR(10)||'      l_found2 := cs_cur%FOUND;'
            ||CHR(10)||'   END IF;'
            ||CHR(10)||'   CLOSE cs_cur;'
            ||CHR(10)||'   IF NOT l_found'
            ||CHR(10)||'    THEN'
            ||CHR(10)||'      hig.raise_ner (pi_appl               => '||g_package_name||'.c_xval'
            ||CHR(10)||'                    ,pi_id                 => 1'
            ||CHR(10)||'                    ,pi_supplementary_info => c_col'
            ||CHR(10)||'                    );'
            ||CHR(10)||'   ELSIF l_found2'
            ||CHR(10)||'    THEN'
            ||CHR(10)||'      hig.raise_ner (pi_appl               => '||g_package_name||'.c_xval'
            ||CHR(10)||'                    ,pi_id                 => 2'
            ||CHR(10)||'                    ,pi_supplementary_info => c_col'
            ||CHR(10)||'                    );'
            ||CHR(10)||'   END IF;'
            ||CHR(10)||'END;';
   g_col_name := p_xvc_ita_view_col_name;
   EXECUTE IMMEDIATE l_sql;
--
   IF   p_xvc_sum_for_report       = c_y
    AND g_rec_xvc_dets.ita_format != nm3type.c_number
    THEN
      hig.raise_ner (pi_appl               => c_xval
                    ,pi_id                 => 8
                    ,pi_supplementary_info => g_rec_xvc_dets.ita_view_col_name||':'||g_rec_xvc_dets.ita_format
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_xvc_ita_view_col_name');
--
END check_xvc_ita_view_col_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xvc_ita_view_col_name_lov RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   l_retval :=        'SELECT *'
           ||CHR(10)||' FROM (SELECT ita_view_col_name              ita_view_col_name'
           ||CHR(10)||'             ,ita_scrn_text                  ita_scrn_text'
           ||CHR(10)||'             ,ita_attrib_name                ita_attrib_name'
           ||CHR(10)||'             ,ita_disp_seq_no                ita_disp_seq_no'
           ||CHR(10)||'             ,ita_mandatory_yn               ita_mandatory_yn'
           ||CHR(10)||'             ,'||nm3flx.string(nm3type.c_true)||'      is_ita'
           ||CHR(10)||'             ,ita_fld_length                 ita_fld_length'
           ||CHR(10)||'             ,ita_format                     ita_format'
           ||CHR(10)||'        FROM  nm_inv_type_attribs'
           ||CHR(10)||'       WHERE  ita_inv_type = '||c_val_inv_type_str
           ||CHR(10)||'       UNION ALL'
           ||CHR(10)||'       SELECT column_name                    ita_view_col_name'
           ||CHR(10)||'             ,'||g_package_name||'.translate_iit_col_into_descr(column_name) ita_scrn_text'
           ||CHR(10)||'             ,column_name                    ita_attrib_name'
           ||CHR(10)||'             ,column_id+10000                ita_disp_seq_no'
           ||CHR(10)||'             ,DECODE(nullable,'||c_y_str||','||c_n_str||','||c_y_str||')   ita_mandatory_yn'
           ||CHR(10)||'             ,'||nm3flx.string(nm3type.c_false)||'    is_ita'
           ||CHR(10)||'             ,DECODE(data_type'
           ||CHR(10)||'                    ,'||nm3flx.string(nm3type.c_number)||',DECODE(data_precision,Null,38,data_precision+DECODE(data_scale,Null,0,1))'
           ||CHR(10)||'                    ,'||nm3flx.string(nm3type.c_date)||',20'
           ||CHR(10)||'                    ,data_length'
           ||CHR(10)||'                    )                        ita_fld_length'
           ||CHR(10)||'             ,data_type                      ita_format'
           ||CHR(10)||'        FROM  all_tab_columns'
           ||CHR(10)||'       WHERE  owner        = '||nm3flx.string(c_app_owner)
           ||CHR(10)||'        AND   table_name   = '||nm3flx.string(c_nm_inv_items)
           ||CHR(10)||'        AND   column_name IN ('||nm3flx.string('IIT_NOTE')
           ||CHR(10)||'                             ,'||nm3flx.string('IIT_DESCR')
           ||CHR(10)||'                             ,'||nm3flx.string('IIT_PEO_INVENT_BY_ID')
           ||CHR(10)||'                             )'
--           ||CHR(10)||'        AND   column_name NOT IN ('||nm3flx.string('IIT_NE_ID')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_PRIMARY_KEY')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_FOREIGN_KEY')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_START_DATE')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_END_DATE')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_INV_TYPE')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_X_SECT')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_DET_XSP')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_LOCATED_BY')
--           ||CHR(10)||'                                 ,'||nm3flx.string('IIT_ADMIN_UNIT')
--           ||CHR(10)||'                                 )'
--           ||CHR(10)||'        AND   nm3inv.is_column_allowable_for_flex(column_name) = '||nm3flx.string(nm3type.c_false)
           ||CHR(10)||'      )'
           ||CHR(10)||'ORDER BY ita_disp_seq_no';
   RETURN l_retval;
END get_xvc_ita_view_col_name_lov;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_iit_col_into_descr (pi_column_name VARCHAR2) RETURN nm_inv_type_attribs.ita_scrn_text%TYPE IS
   l_retval nm_inv_type_attribs.ita_scrn_text%TYPE;
BEGIN
--
   l_retval := nm3get.get_hco (pi_hco_domain      => nm3gaz_qry.c_fixed_cols_domain_inv
                              ,pi_hco_code        => pi_column_name
                              ,pi_raise_not_found => FALSE
                              ).hco_meaning;
   IF l_retval IS NULL
    THEN
      l_retval := INITCAP(REPLACE(SUBSTR(pi_column_name,(INSTR(pi_column_name,'_',1,1)+1)),'_',' '));
   END IF;
--
   RETURN l_retval;
--
END translate_iit_col_into_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tab_xvc (p_iit_inv_type nm_inv_types.nit_inv_type%TYPE
                      ,p_column_name  VARCHAR2
--                      ,p_column_name2 VARCHAR2 DEFAULT NULL
                      ) IS
   l_sql nm3type.max_varchar2;
BEGIN
   l_sql :=            'BEGIN'
            ||CHR(10)||'   '||g_package_name||'.g_tab_xvc.DELETE;'
            ||CHR(10)||'   SELECT *'
            ||CHR(10)||'    BULK  COLLECT'
            ||CHR(10)||'    INTO  '||g_package_name||'.g_tab_xvc'
            ||CHR(10)||'    FROM  xval_valuation_columns'
            ||CHR(10)||'   WHERE  xvc_nit_inv_type   = :p_iit_inv_type'
            ||CHR(10)||'    AND  ('||p_column_name||' = '||c_y_str;
--   IF p_column_name2 IS NOT NULL
--    THEN
--      l_sql := l_sql
--            ||CHR(10)||'         OR '||p_column_name2||' = '||c_y_str;
--   END IF;
   l_sql := l_sql
            ||CHR(10)||'         )'
            ||CHR(10)||'   ORDER BY xvc_process_seq_no;'
            ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_sql USING p_iit_inv_type;
END get_tab_xvc;
--
-----------------------------------------------------------------------------
--
PROCEDURE internal_prompt_many
                      (pi_iit_ne_id         nm3type.tab_varchar30
                      ,pi_module            hig_modules.hmo_module%TYPE
                      ,pi_module_title      hig_modules.hmo_title%TYPE
                      ,pi_prompt_column     VARCHAR2
--                      ,pi_prompt_column2    VARCHAR2 DEFAULT NULL
                      ,pi_process_proc      VARCHAR2
                      ,pi_process_type_col  VARCHAR2
--                      ,pi_process_type_col2 VARCHAR2 DEFAULT NULL
                      ,pi_dry_run_radios    BOOLEAN DEFAULT FALSE
                      ) IS
   l_rec_iit nm_inv_items%ROWTYPE;
   l_tab_iit_ne_id  nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start (g_package_name,'internal_prompt_many');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => pi_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(pi_module);
--
   l_tab_iit_ne_id := delete_zero_ids_from_table (pi_iit_ne_id);
   FOR i IN 1..l_tab_iit_ne_id.COUNT
    LOOP
      l_rec_iit := nm3get.get_iit (pi_iit_ne_id => l_tab_iit_ne_id(i));
   END LOOP;
--
   IF l_tab_iit_ne_id.COUNT = 0
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 16
                    );
   END IF;
--
   get_tab_xvc (p_iit_inv_type => l_rec_iit.iit_inv_type
               ,p_column_name  => pi_prompt_column
--               ,p_column_name2 => pi_prompt_column2
               );
--
   htp.formopen (curl        => g_package_name||'.'||pi_process_proc
                ,cattributes => 'NAME="'||pi_process_proc||'"'
                );
   htp.formhidden (cname=>'pi_module',cvalue=>pi_module);
   htp.formhidden (cname=>'pi_module_title',cvalue=>pi_module_title);
   htp.formhidden (cname=>'pi_process_type_col',cvalue=>pi_process_type_col);
--
   IF pi_dry_run_radios
    THEN
      htp.tableopen (cattributes => 'BORDER=1');
      htp.tablerowopen;
      htp.tableheader (/*htf.small*/(c_dry_run));
      htp.p('<TD>');
         htp.tableopen (cattributes => 'BORDER=1');
         htp.tablerowopen;
         htp.tabledata('<INPUT TYPE=RADIO NAME="pi_dry_run" VALUE="'||nm3type.c_true||'"'||c_checked||'>'||c_small_yes||'</INPUT>');
         htp.tabledata('<INPUT TYPE=RADIO NAME="pi_dry_run" VALUE="'||nm3type.c_false||'"'||'>'||c_small_no||'</INPUT>');
         htp.tablerowclose;
         htp.tableclose;
      htp.p('</TD>');
      htp.tablerowclose;
      htp.tableclose;
--   htp.formhidden (cname=>'pi_dry_run',cvalue=>nm3type.c_true);
   END IF;
--
   FOR i IN 1..pi_iit_ne_id.COUNT
    LOOP
      htp.formhidden (cname=>'pi_iit_ne_id',cvalue=>pi_iit_ne_id(i));
   END LOOP;
--
   display_tab_xvc (pi_rec_xvc => g_tab_xvc);
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end (g_package_name,'internal_prompt_many');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END internal_prompt_many;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_report_arrays (pi_value     NUMBER
                               ,pi_array_pos PLS_INTEGER
                               ,pi_scrn_text VARCHAR2
                               ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'add_to_report_arrays');
--
   IF NOT g_tab_report_array.EXISTS (pi_array_pos)
    THEN
      g_tab_report_array(pi_array_pos)   := 0;
      g_tab_report_columns(pi_array_pos) := pi_scrn_text;
   END IF;
--
   g_tab_report_array(pi_array_pos)      := g_tab_report_array(pi_array_pos) + NVL(pi_value,0);
--
   nm_debug.proc_end (g_package_name,'add_to_report_arrays');
--
END add_to_report_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE html_dump_report_array (p_window_title      VARCHAR2 DEFAULT NULL
                                 ,p_calling_pack_proc VARCHAR2 DEFAULT NULL
                                 ) IS
   i PLS_INTEGER;
--
   l_tab_vc nm3type.tab_varchar32767;
--
   PROCEDURE add_it (p_text VARCHAR2) IS
   BEGIN
      l_tab_vc (l_tab_vc.COUNT+1) := p_text;
   END add_it;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'html_dump_report_array');
--
   IF g_tab_report_array.COUNT > 0
    THEN
      add_it(htf.tableopen (cattributes => 'BORDER=1'));
      i := g_tab_report_array.FIRST;
      WHILE i IS NOT NULL
       LOOP
         add_it(htf.tablerowopen);
         add_it(htf.tableheader(/*htf.small*/(g_tab_report_columns(i))));
         add_it(htf.tabledata(/*htf.small*/(g_tab_report_array(i))));
         add_it(htf.tablerowclose);
         i := g_tab_report_array.NEXT(i);
      END LOOP;
      add_it(htf.tableclose);
   END IF;
--
   dm3query.main_js_for_dump_table (p_tab_vc => l_tab_vc);
--
   htp.tableopen;
   htp.p('<TR VALIGN="MIDDLE">');
   htp.p('<TD VALIGN="MIDDLE">');
   dm3query.do_save_button_and_params (p_window_title      => p_window_title
                                      ,p_calling_pack_proc => p_calling_pack_proc
                                      );
   htp.p('</TD>');
   htp.p('<TD>');
   dm3query.write_retrieved_js;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tableclose;
--
   nm_debug.proc_end (g_package_name,'html_dump_report_array');
--
END html_dump_report_array;
--
-----------------------------------------------------------------------------
--
END xval_reval;
/
