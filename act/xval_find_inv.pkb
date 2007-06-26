CREATE OR REPLACE PACKAGE BODY xval_find_inv AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_find_inv.pkb	1.1 03/14/05
--       Module Name      : xval_find_inv.pkb
--       Date into SCCS   : 05/03/14 23:11:27
--       Date fetched Out : 07/06/06 14:33:56
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Valuations Find Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000)              := '"@(#)xval_find_inv.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT varchar2(30)                := 'xval_find_inv';
--
   c_find_module       CONSTANT hig_modules.hmo_module%TYPE := 'XVALWEB0570';
   c_find_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_find_module);
--
   c_find_anything_module       CONSTANT hig_modules.hmo_module%TYPE := 'XEXORWEB0570';
   c_find_anything_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_find_anything_module);
--
   c_val_create_module            CONSTANT hig_modules.hmo_module%TYPE := 'XVALWEB0010';
   c_val_create_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_val_create_module);
--
   c_multi_val_create_module      CONSTANT hig_modules.hmo_module%TYPE := 'XVALWEB0011';
   c_multi_val_create_mod_title   CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_multi_val_create_module);
--
   c_val_error_correction_module  CONSTANT hig_modules.hmo_module%TYPE := 'XVALWEB0012';
   c_val_err_correction_mod_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_val_error_correction_module);
--
   c_equals       CONSTANT VARCHAR2(5) := CHR(38)||'#61;';
   c_always_show_inv_pk        CONSTANT boolean := hig.get_user_or_sys_opt('SHOWINVPK') = 'Y';
--
   g_checked                         VARCHAR2(8);
   c_checked  CONSTANT               VARCHAR2(8)  := ' CHECKED';
   c_selected CONSTANT               VARCHAR2(9)  := ' SELECTED';
--
   c_checkbox CONSTANT               VARCHAR2(8)  := 'checkbox';
   c_radio    CONSTANT               VARCHAR2(8)  := 'radio';
--
   c_val_sysopt   CONSTANT hig_options.hop_id%TYPE    := 'XVALINVTYP';
   c_val_inv_type CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt(c_val_sysopt);
   g_val_inv_type_ok       BOOLEAN                    := FALSE;
--
   g_select_statement nm3type.max_varchar2;
   g_rec_nit          nm_inv_types%ROWTYPE;
   g_tab_ita          nm3inv.tab_nita;
--
   c_dummy_col CONSTANT VARCHAR2(30) := 'BADGERS_RULE';
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_select_all_buttons (p_form_name VARCHAR2);
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_close_window_button (p_do_button BOOLEAN DEFAULT TRUE);
--
----------------------------------------------------------------------------------------
--
FUNCTION get_theme_count (pi_iit_inv_type   VARCHAR2
                         ) RETURN PLS_INTEGER;
--
----------------------------------------------------------------------------------------
--
PROCEDURE get_themes_for_inv_type (pi_iit_inv_type   IN     VARCHAR2
                                  ,po_tab_theme_id      OUT nm3type.tab_number
                                  ,po_tab_theme_name    OUT nm3type.tab_varchar80
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
   htp.p('--       sccsid           : @(#)xval_find_inv.pkb	1.1 03/14/05');
   htp.p('--       Module Name      : xval_find_inv.pkb');
   htp.p('--       Date into SCCS   : 05/03/14 23:11:27');
   htp.p('--       Date fetched Out : 07/06/06 14:33:56');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Valuations Find Inventory package');
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
PROCEDURE find_specific (p_inv_type     VARCHAR2
                        ,p_module       VARCHAR2
                        ,p_module_title VARCHAR2
                        ,p_all_fields   VARCHAR2 DEFAULT 'Y'
                        ) IS
BEGIN
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(p_module);
--
   IF nm3get.get_nit (pi_nit_inv_type    => p_inv_type
                     ,pi_raise_not_found => FALSE
                     ).nit_inv_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => 'Query '||p_inv_type
                    );
   END IF;
--
   htp.bodyclose;
   htp.htmlclose;
--
   main_find_window (p_inv_type     => p_inv_type
                    ,p_module       => p_module
                    ,p_module_title => p_module_title
                    ,p_all_fields   => p_all_fields
                    );
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_specific;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_anything IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'find_anything');
--
   main (p_restrict_to_val_parents_only => FALSE
        ,p_module                       => c_find_anything_module
        ,p_module_title                 => c_find_anything_module_title
        );
--
   nm_debug.proc_end(g_package_name,'find_anything');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_anything;
--
-----------------------------------------------------------------------------
--
PROCEDURE main (p_restrict_to_val_parents_only BOOLEAN  DEFAULT TRUE
               ,p_module                       VARCHAR2 DEFAULT NULL
               ,p_module_title                 VARCHAR2 DEFAULT NULL
               ) IS
--
   l_tab_rec_nit nm3type.tab_rec_nit;
   c_module       CONSTANT hig_modules.hmo_module%TYPE := NVL(p_module,c_find_module);
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := NVL(p_module_title,c_find_module_title);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'main');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_module_title
               );
   sccs_tags;
   htp.bodyopen;
   htp.p ('<!--');
   htp.p ('Parameters as passed - ');
   htp.p ('p_restrict_to_val_parents_only : '||nm3flx.boolean_to_char(p_restrict_to_val_parents_only));
   htp.p ('p_module                       : '||p_module);
   htp.p ('p_module_title                 : '||p_module_title);
   IF  p_module       IS NULL
    OR p_module_title IS NULL
    THEN
      htp.p ('--');
      htp.p ('c_module                       : '||c_module);
      htp.p ('c_module_title                 : '||c_module_title);
   END IF;
   htp.p ('-->');
--
   nm3web.module_startup(c_module);
--
   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader (/*htf.small*/('Asset Type'));
   htp.p('<TD>');
--
   htp.formopen(g_package_name||'.main_find_window', cattributes => 'NAME="main_find_window"');
   --
   IF p_restrict_to_val_parents_only
    THEN
     SELECT *
      BULK  COLLECT
      INTO  l_tab_rec_nit
      FROM  nm_inv_types
     WHERE  nit_table_name IS NULL -- Do not bring foreign tables.
      AND   EXISTS (SELECT 1
                     FROM  nm_inv_type_groupings
                    WHERE  itg_parent_inv_type = nit_inv_type
                     AND   itg_inv_type        = get_val_inv_type
                   )
     ORDER  BY nit_descr;
   ELSE
     SELECT *
      BULK  COLLECT
      INTO  l_tab_rec_nit
      FROM  nm_inv_types
--     WHERE  nit_table_name IS NULL -- Do not bring foreign tables.
     ORDER  BY nit_descr;
   END IF;
   --
   htp.formselectopen (cname => 'p_inv_type');
   FOR i IN 1..l_tab_rec_nit.COUNT
    LOOP
      htp.p('   <OPTION VALUE="'||l_tab_rec_nit(i).nit_inv_type||'">'||l_tab_rec_nit(i).nit_descr||'</OPTION>');
   END LOOP;
   htp.formselectclose;
   --
   htp.formhidden ('p_module',c_module);
   htp.formhidden ('p_module_title',c_module_title);
   htp.p('</TD>');
   htp.tablerowclose;
--
--   htp.formhidden ('p_all_fields','N');
   htp.tablerowopen;
   htp.tableheader(/*htf.small*/('Query All Fields'));
   htp.tabledata(htf.formcheckbox (cname    => 'p_all_fields'
                                  ,cvalue   => 'Y'
                                  ,cchecked => Null
                                  )
                );
   htp.tablerowclose;
   htp.tablerowopen;
--
   htp.tableheader(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   --
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'main');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END main;
--
----------------------------------------------------------------------------------------
--
PROCEDURE main_find_window (p_inv_type     VARCHAR2
                           ,p_module       VARCHAR2
                           ,p_module_title VARCHAR2
                           ,p_all_fields   VARCHAR2 DEFAULT 'N'
                           ) IS
   l_rec_nit              nm_inv_types%ROWTYPE;
   l_tab_ita_attrib_name  nm3type.tab_varchar32767;
   l_tab_ita_scrn_text    nm3type.tab_varchar32767;
   l_tab_ita_id_domain    nm3type.tab_varchar32767;
   l_tab_ita_format       nm3type.tab_varchar32767;
   l_tab_ita_fld_length   nm3type.tab_number;
   l_tab_ita_mandatory_yn nm3type.tab_varchar4;
--
   c_ita_value CONSTANT VARCHAR2(9) := 'ita_value';
--
   l_ita_counter          PLS_INTEGER := 0;
   l_is_ft                VARCHAR2(5);
   PROCEDURE do_ita_counter IS
   BEGIN
      l_ita_counter := l_ita_counter + 1;
      htp.formhidden ('ita_counter',l_ita_counter);
   END do_ita_counter;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'main_find_window');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
   htp.p ('<!--');
   htp.p ('Parameters as passed - ');
   htp.p ('p_inv_type     : '||p_inv_type);
   htp.p ('p_module       : '||p_module);
   htp.p ('p_module_title : '||p_module_title);
   htp.p ('p_all_fields   : '||p_all_fields);
   htp.p ('-->');
--
   nm3web.module_startup(p_module);
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => p_inv_type);
   l_is_ft   := nm3flx.boolean_to_char (l_rec_nit.nit_table_name IS NOT NULL);
--
   SELECT ita_attrib_name
         ,ita_scrn_text
         ,ita_id_domain
         ,ita_format
         ,ita_fld_length
         ,ita_mandatory_yn
    BULK  COLLECT
    INTO  l_tab_ita_attrib_name
         ,l_tab_ita_scrn_text
         ,l_tab_ita_id_domain
         ,l_tab_ita_format
         ,l_tab_ita_fld_length
         ,l_tab_ita_mandatory_yn
    FROM  (SELECT ita_attrib_name
                 ,ita_scrn_text
                 ,ita_id_domain
                 ,ita_format
                 ,ita_fld_length
                 ,ita_mandatory_yn
                 ,ita_disp_seq_no
            FROM  nm_inv_type_attribs
           WHERE  ita_inv_type  = l_rec_nit.nit_inv_type
            AND ((ita_queryable = 'Y' AND NVL(p_all_fields,'N') = 'N')
                 OR NVL(p_all_fields,'N') = 'Y'
                )
           UNION ALL
           SELECT c_iit_admin_unit
                 ,c_iit_admin_unit_text
                 ,Null
                 ,nm3type.c_number
                 ,9
                 ,'Y'
                 ,-100
            FROM  DUAL
           WHERE  l_is_ft = 'FALSE'
           UNION ALL
           SELECT c_iit_descr
                 ,c_iit_descr_text
                 ,Null
                 ,nm3type.c_varchar
                 ,80
                 ,'N'
                 ,-80
            FROM  DUAL
           WHERE  l_is_ft = 'FALSE'
           UNION ALL
           SELECT c_iit_note
                 ,c_iit_note_text
                 ,Null
                 ,nm3type.c_varchar
                 ,40
                 ,'N'
                 ,-80
            FROM  DUAL
           WHERE  l_is_ft = 'FALSE'
           UNION ALL
           SELECT c_iit_start_date
                 ,c_iit_start_date_text
                 ,Null
                 ,nm3type.c_date
                 ,13
                 ,'Y'
                 ,-90
            FROM  DUAL
           WHERE  l_is_ft = 'FALSE'
          )
   ORDER BY ita_disp_seq_no, ita_scrn_text;
--
   IF l_tab_ita_attrib_name.COUNT = 0
    THEN
      IF NVL(p_all_fields,'N') = 'Y'
       THEN
         js_ner_and_back (pi_appl               => nm3type.c_net
                         ,pi_id                 => 127
                         ,pi_supplementary_info => l_rec_nit.nit_inv_type
                         );
      ELSE
         js_ner_and_back (pi_appl               => nm3type.c_net
                         ,pi_id                 => 326
                         ,pi_supplementary_info => 'No Queryable Attributes'
                         );
      END IF;
   ELSE
--
      htp.tableopen (cattributes=> 'BORDER=1');
      htp.tablerowopen;
      htp.tableheader (htf.big(l_rec_nit.nit_descr),cattributes=>'COLSPAN=4');
      htp.tablerowclose;
      htp.formopen(g_package_name||'.perform_search', cattributes => 'NAME="perform_search"');
      htp.tablerowopen;
      htp.tableheader(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=4');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader (/*htf.small*/('Query'));
      htp.tableheader (/*htf.small*/('Attribute'));
      htp.tableheader (/*htf.small*/('Condition'));
      htp.tableheader (/*htf.small*/('Value'));
      htp.tablerowclose;
      htp.formhidden ('p_inv_type',l_rec_nit.nit_inv_type);
      htp.formhidden ('p_module',p_module);
      htp.formhidden ('p_module_title',p_module_title);
   --
   -- Put a "fake" one in here so that the HTML always sends arrays down
   --
--      IF nm3flx.char_to_boolean(l_is_ft)
--       THEN
--         htp.formhidden ('ita_query',l_rec_nit.nit_foreign_pk_column);
--         htp.formhidden ('ita_attrib_name',l_rec_nit.nit_foreign_pk_column);
--         htp.formhidden (c_ita_value,Null);
--         htp.formhidden ('ita_condition','IS NOT NULL');
--         htp.formhidden ('ita_format',nm3type.c_number);
--      ELSE
         htp.formhidden ('ita_query',c_dummy_col);
         htp.formhidden ('ita_attrib_name',c_dummy_col);
         htp.formhidden (c_ita_value,Null);
         htp.formhidden ('ita_condition','IS NOT NULL');
         htp.formhidden ('ita_format',nm3type.c_number);
--      END IF;
      do_ita_counter;
   --
      FOR i IN 1..l_tab_ita_attrib_name.COUNT
       LOOP
   --
         htp.tablerowopen;
   --
         htp.tableheader (htf.formcheckbox (cname  => 'ita_query'
                                           ,cvalue => l_tab_ita_attrib_name(i)
                                           )
                         );
         htp.formhidden ('ita_attrib_name',l_tab_ita_attrib_name(i));
   --
         htp.p('<TD>');
--         htp.p('<SMALL>');
         htp.p(l_tab_ita_scrn_text(i));
         IF l_tab_ita_mandatory_yn(i) = 'Y'
          THEN
            htp.p ('<SUP>*</SUP>');
         END IF;
--         htp.p('('||l_tab_ita_attrib_name(i)||')');
--         htp.p('</SMALL>');
         htp.p('</TD>');
   --
         htp.p('<TD>');
         htp.formselectopen (cname => 'ita_condition');
         DECLARE
            l_cur nm3type.ref_cursor;
            l_lup_meaning     hig_codes.hco_code%TYPE;
            l_lup_description hig_codes.hco_meaning%TYPE;
            l_lup_value       hig_codes.hco_code%TYPE;
            FUNCTION is_selected RETURN VARCHAR2 IS
               l_retval VARCHAR2(10);
            BEGIN
               IF    l_lup_value = '='
                AND (l_tab_ita_id_domain(i) IS NOT NULL
                     OR l_tab_ita_format(i) != nm3type.c_varchar
                    )
                THEN
                  l_retval       := c_selected;
               ELSIF l_lup_value = 'LIKE'
                 AND l_tab_ita_format(i) = nm3type.c_varchar
                THEN
                  l_retval       := c_selected;
               END IF;
               RETURN l_retval;
            END is_selected;
         BEGIN
            OPEN  l_cur FOR nm3gaz_qry.get_ngqa_condition_lov_sql;
            FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
            WHILE l_cur%FOUND
             LOOP
               IF nm3mrg_supplementary.get_pbi_condition_value_count(l_lup_value) IN (0,1)
                THEN
                  IF l_lup_value IN ('<','<=','>','>=')
                   AND l_tab_ita_format(i) = nm3type.c_varchar
                   THEN
                     Null;
                  ELSIF l_lup_value LIKE '%LIKE%'
                   AND (l_tab_ita_format(i) != nm3type.c_varchar
                        OR l_tab_ita_id_domain(i) IS NOT NULL
                       )
                   THEN
                     Null;
                  ELSIF l_tab_ita_mandatory_yn(i) = 'Y'
                   AND l_lup_value = 'IS NULL'
                   THEN
                     Null;
                  ELSE
                     htp.p('   <OPTION VALUE="'||nm3web.replace_chevrons(REPLACE(l_lup_value,'=',c_equals))||'"'||is_selected||'>'||nm3web.replace_chevrons(l_lup_description)||'</OPTION>');
                  END IF;
               END IF;
               FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
            END LOOP;
            CLOSE l_cur;
         END;
         htp.formselectclose;
         htp.p('</TD>');
   --
         IF l_tab_ita_attrib_name(i) = c_iit_admin_unit
          THEN
            htp.p('<TD>');
            do_au_listbox (pi_admin_type     => l_rec_nit.nit_admin_type
                          ,pi_parameter_name => c_ita_value
                          );
            htp.p('</TD>');
         ELSIF l_tab_ita_id_domain(i) IS NOT NULL
          THEN
            htp.p('<TD>');
            htp.formselectopen (cname => c_ita_value);
            IF l_tab_ita_mandatory_yn(i) = 'N'
              THEN
                htp.p('   <OPTION VALUE="">'||nm3web.c_nbsp||'</OPTION>');
            END IF;
            FOR cs_rec IN (SELECT ial_value
                                 ,ial_meaning
                            FROM  nm_inv_attri_lookup
                           WHERE  ial_domain = l_tab_ita_id_domain(i)
                           ORDER  BY ial_seq
                          )
             LOOP
               htp.p('   <OPTION VALUE="'||cs_rec.ial_value||'">'||cs_rec.ial_meaning||'</OPTION>');
            END LOOP;
            htp.formselectclose;
            htp.p('</TD>');
         ELSE
            htp.tabledata (htf.formtext (cname      => c_ita_value
--                                        ,csize      => LEAST(l_tab_ita_fld_length(i),50)
                                        ,cmaxlength => l_tab_ita_fld_length(i)
                                        )
                          );
         END IF;
         htp.formhidden ('ita_format',l_tab_ita_format(i));
         do_ita_counter;
   --
         htp.tablerowclose;
   --
      END LOOP;
   --
      htp.tablerowopen;
      htp.tableheader (htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=4');
      htp.formclose;
      htp.tablerowclose;
      htp.tableclose;
   END IF;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'main_find_window');
--
END main_find_window;
--
----------------------------------------------------------------------------------------
--
PROCEDURE perform_search (p_inv_type      VARCHAR2
                         ,p_module        VARCHAR2
                         ,p_module_title  VARCHAR2
                         ,ita_query       nm3type.tab_varchar32767
                         ,ita_attrib_name nm3type.tab_varchar32767
                         ,ita_value       owa_util.vc_arr
                         ,ita_format      nm3type.tab_varchar32767
                         ,ita_condition   nm3type.tab_varchar32767
                         ,ita_counter     nm3type.tab_varchar32767
                         ) IS
--
   l_rec_ngq       nm_gaz_query%ROWTYPE;
   l_rec_ngqt      nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa      nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv      nm_gaz_query_values%ROWTYPE;
--
   i               PLS_INTEGER;
   i2              PLS_INTEGER;
   l_ngqi_job_id       nm_gaz_query_item_list.ngqi_job_id%TYPE;
   l_meaning       nm3type.max_varchar2;
--
   FUNCTION find_index (p_attrib VARCHAR2) RETURN PLS_INTEGER IS
      l_retval PLS_INTEGER;
   BEGIN
--      nm_debug.debug('------');
--      nm_debug.debug(p_attrib);
      FOR i IN 1..ita_attrib_name.COUNT
       LOOP
         IF ita_attrib_name(i) = p_attrib
          THEN
            l_retval := i;
            EXIT;
         END IF;
      END LOOP;
--      nm_debug.debug(l_Retval);
      RETURN l_retval;
   END find_index;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'perform_search');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => p_module_title
               );
   create_js_funcs;
   sccs_tags;
   nm_debug.delete_debug(TRUE);
   nm_debug.debug_on;
   htp.p ('<!--');
   htp.p ('Parameters as passed - ');
   htp.p ('p_inv_type           : '||p_inv_type);
   htp.p ('p_module             : '||p_module);
   htp.p ('p_module_title       : '||p_module_title);
   FOR i IN 1..ita_query.COUNT
    LOOP
      nm_debug.debug(i);
   END LOOP;
   i := ita_query.FIRST;
   WHILE i IS NOT NULL
    LOOP
      i2 := find_index (ita_query(i));
      htp.p (i2);
      htp.p ('ita_query         : '||ita_query(i));
      htp.p ('ita_attrib_name   : '||ita_attrib_name(i2));
      htp.p ('ita_value         : '||ita_value(i2));
      htp.p ('ita_format        : '||ita_format(i2));
      htp.p ('ita_condition     : '||ita_condition(i2));
      htp.p ('ita_counter       : '||ita_counter(i2));
      i := ita_query.NEXT(i);
   END LOOP;
   htp.p ('-->');
   htp.headclose;
   htp.bodyopen;
--
   nm3web.module_startup(p_module);
--
   l_rec_ngq.ngq_id                 := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id          := -1;
   l_rec_ngq.ngq_source             := nm3extent.c_route;
   l_rec_ngq.ngq_open_or_closed     := nm3gaz_qry.c_open_query;
   l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_query_all_items    := 'Y';
   l_rec_ngq.ngq_begin_mp           := Null;
   l_rec_ngq.ngq_begin_datum_ne_id  := Null;
   l_rec_ngq.ngq_begin_datum_offset := Null;
   l_rec_ngq.ngq_end_mp             := Null;
   l_rec_ngq.ngq_end_datum_ne_id    := Null;
   l_rec_ngq.ngq_end_datum_offset   := Null;
   l_rec_ngq.ngq_ambig_sub_class    := Null;
   nm3ins.ins_ngq (l_rec_ngq);
--
   l_rec_ngqt.ngqt_ngq_id           := l_rec_ngq.ngq_id;
   l_rec_ngqt.ngqt_seq_no           := 1;
   l_rec_ngqt.ngqt_item_type_type   := nm3gaz_qry.c_ngqt_item_type_type_inv;
   l_rec_ngqt.ngqt_item_type        := p_inv_type;
   nm3ins.ins_ngqt (l_rec_ngqt);
--
   i := ita_query.FIRST;
   --
--   IF ita_query.COUNT = 1
--    THEN
--      js_ner_and_back (pi_appl               => nm3type.c_net
--                      ,pi_id                 => 121
--                      ,pi_supplementary_info => 'No attributes flagged to be queried'
--                      );
--      htp.bodyclose;
--      htp.htmlclose;
--      RETURN;
--   END IF;
    nm_debug.deLETE_DEBUG(true);
    nm_debug.debug_on;
    nm_debug.debug('------');
   FOR i IN 1..ita_counter.COUNT
    LOOP
       nm_debug.debug(i||':'||ita_counter(i)||':'||ita_attrib_name(i)||' '||ita_condition(i)||' '||ita_value(i));
   END LOOP;
    nm_debug.debug('------');
   --
   WHILE i IS NOT NULL
    LOOP
      i2 := find_index (ita_query(i));
      l_rec_ngqa.ngqa_ngq_id        := l_rec_ngqt.ngqt_ngq_id;
      l_rec_ngqa.ngqa_ngqt_seq_no   := l_rec_ngqt.ngqt_seq_no;
      l_rec_ngqa.ngqa_seq_no        := i2;
      l_rec_ngqa.ngqa_attrib_name   := ita_attrib_name(i2);
      l_rec_ngqa.ngqa_operator      := nm3type.c_and_operator;
      l_rec_ngqa.ngqa_pre_bracket   := Null;
      l_rec_ngqa.ngqa_post_bracket  := Null;
      l_rec_ngqa.ngqa_condition     := ita_condition(i2);
      IF l_rec_ngqa.ngqa_attrib_name != c_dummy_col
       THEN
         nm3ins.ins_ngqa (l_rec_ngqa);
         --
          nm_debug.debug(i||':'||i2||':'||l_rec_ngqa.ngqa_attrib_name||' '||l_rec_ngqa.ngqa_condition||' '||ita_value(i2));
   --      --
         IF nm3mrg_supplementary.get_pbi_condition_value_count(l_rec_ngqa.ngqa_condition) = 1
          THEN
            l_rec_ngqv.ngqv_ngq_id     := l_rec_ngqa.ngqa_ngq_id;
            l_rec_ngqv.ngqv_ngqt_seq_no:= l_rec_ngqa.ngqa_ngqt_seq_no;
            l_rec_ngqv.ngqv_ngqa_seq_no:= l_rec_ngqa.ngqa_seq_no;
            l_rec_ngqv.ngqv_sequence   := 1;
            IF nm3get.get_ita(pi_ita_inv_type    => l_rec_ngqt.ngqt_item_type
                             ,pi_ita_attrib_name => l_rec_ngqa.ngqa_attrib_name
                             ,pi_raise_not_found => FALSE
                             ).ita_inv_type IS NOT NULL
             THEN
               nm3inv.validate_flex_inv (p_inv_type    => l_rec_ngqt.ngqt_item_type
                                        ,p_attrib_name => l_rec_ngqa.ngqa_attrib_name
                                        ,pi_value      => UPPER(ita_value(i2))
                                        ,po_value      => l_rec_ngqv.ngqv_value
                                        ,po_meaning    => l_meaning
                                        );
            ELSE -- this is not an ITA
               IF    ita_format(i2) = nm3type.c_date
                THEN
                  l_rec_ngqv.ngqv_value := xval_create_inv.harsh_date_check (ita_value(i2));
               ELSIF ita_format(i2) = nm3type.c_number
                THEN
                  l_rec_ngqv.ngqv_value := xval_create_inv.harsh_number_check (ita_value(i2));
               ELSE
                  l_rec_ngqv.ngqv_value := ita_value(i2);
               END IF;
            END IF;
            nm3ins.ins_ngqv (l_rec_ngqv);
         END IF;
      END IF;
      --
      i := ita_query.NEXT(i);
      --
   END LOOP;
--
   l_ngqi_job_id := nm3gaz_qry.perform_query (pi_ngq_id => l_rec_ngq.ngq_id);
--
   IF    p_module IN (c_val_create_module
                     ,c_multi_val_create_module
                     )
    THEN
      DELETE FROM nm_gaz_query_item_list
      WHERE  ngqi_job_id = l_ngqi_job_id
       AND   EXISTS (SELECT 1
                      FROM  nm_inv_item_groupings iig
                           ,nm_inv_items          iit
                     WHERE  iig.iig_parent_id  = ngqi_item_id
                      AND   iig.iig_item_id    = iit.iit_ne_id
                      AND   iit.iit_inv_type   = get_val_inv_type
                    );
   ELSIF p_module IN (xval_reval.c_adhoc_reval_single_module
                     ,xval_reval.c_adhoc_reval_multi_module
                     ,xval_reval.c_year_end_reval_module
                     ,xval_reval.c_year_end_dep_module
                     )
    THEN
      DELETE FROM nm_gaz_query_item_list
      WHERE  ngqi_job_id = l_ngqi_job_id
       AND   NOT EXISTS
                    (SELECT 1
                      FROM  nm_inv_item_groupings iig
                           ,nm_inv_items          iit
                     WHERE  iig.iig_parent_id  = ngqi_item_id
                      AND   iig.iig_item_id    = iit.iit_ne_id
                      AND   iit.iit_inv_type   = get_val_inv_type
                    );
   END IF;
--
   instantiate_for_inv_type (pi_nit_inv_type => p_inv_type);
--
nm_debug.debug('calling show_results');
   show_results (p_module      => p_module
                ,p_ngqi_job_id => l_ngqi_job_id
                );
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'perform_search');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END perform_search;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_ner_and_back_internal
                          (pi_appl               VARCHAR2
                          ,pi_id                 NUMBER
                          ,pi_supplementary_info VARCHAR2 DEFAULT Null
                          ,pi_back               BOOLEAN
                          ) IS
BEGIN
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('<!--');
   IF pi_back
    THEN
      htp.p('history.back()');
   END IF;
   nm3web.js_alert_ner (pi_appl       => pi_appl
                       ,pi_id         => pi_id
                       ,pi_extra_text => pi_supplementary_info
                       );
   htp.p('-->');
   htp.p('</SCRIPT>');
END js_ner_and_back_internal;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_ner_and_back (pi_appl               VARCHAR2
                          ,pi_id                 NUMBER
                          ,pi_supplementary_info VARCHAR2 DEFAULT Null
                          ) IS
BEGIN
   js_ner_and_back_internal
                          (pi_appl               => pi_appl
                          ,pi_id                 => pi_id
                          ,pi_supplementary_info => pi_supplementary_info
                          ,pi_back               => TRUE
                          );
END js_ner_and_back;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_ner (pi_appl               VARCHAR2
                 ,pi_id                 NUMBER
                 ,pi_supplementary_info VARCHAR2 DEFAULT Null
                 ) IS
BEGIN
   js_ner_and_back_internal
                          (pi_appl               => pi_appl
                          ,pi_id                 => pi_id
                          ,pi_supplementary_info => pi_supplementary_info
                          ,pi_back               => FALSE
                          );
END js_ner;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_val_inv_type RETURN nm_inv_types.nit_inv_type%TYPE IS
   l_retval nm_inv_types.nit_inv_type%TYPE;
BEGIN
   IF NOT g_val_inv_type_ok
    THEN
      IF c_val_inv_type IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 163
                       ,pi_supplementary_info => c_val_sysopt
                       );
      END IF;
      l_retval := nm3get.get_nit(pi_nit_inv_type => c_val_inv_type).nit_inv_type;
      g_val_inv_type_ok := TRUE;
   ELSE
      l_retval := c_val_inv_type;
   END IF;
   RETURN l_retval;
END get_val_inv_type;
--
----------------------------------------------------------------------------------------
--
PROCEDURE find_val_rec_cr8 IS
BEGIN
--
   main (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_val_create_module
        ,p_module_title                 => c_val_create_module_title
        );
--
END find_val_rec_cr8;
--
----------------------------------------------------------------------------------------
--
PROCEDURE val_rec_cr8_mult IS
BEGIN
--
   main (p_restrict_to_val_parents_only => TRUE
        ,p_module                       => c_multi_val_create_module
        ,p_module_title                 => c_multi_val_create_mod_title
        );
--
END val_rec_cr8_mult;
--
-----------------------------------------------------------------------------
--
PROCEDURE val_rec_err_fix IS
BEGIN
--
   find_specific (p_inv_type     => get_val_inv_type
                 ,p_module       => c_val_error_correction_module
                 ,p_module_title => c_val_err_correction_mod_title
                 );
--
END val_rec_err_fix;
--
----------------------------------------------------------------------------------------
--
PROCEDURE show_results (p_module              hig_modules.hmo_module%TYPE
                       ,p_ngqi_job_id         nm_gaz_query_item_list.ngqi_job_id%TYPE
                       ,p_fail_on_no_results  BOOLEAN                     DEFAULT TRUE
                       ,p_display_inv_type    BOOLEAN                     DEFAULT FALSE
                       ) IS
--
   CURSOR cs_results (c_ngqi_job_id nm_gaz_query_item_list.ngqi_job_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_gaz_query_item_list
                  WHERE  ngqi_job_id  = c_ngqi_job_id
                 );
--
   l_dummy          PLS_INTEGER;
   l_no_results     BOOLEAN;
   l_rec_hmo        hig_modules%ROWTYPE;
   l_checkbox       BOOLEAN      := FALSE;
   l_radio          BOOLEAN      := FALSE;
   l_no_select      BOOLEAN      := FALSE;
   l_input_type     VARCHAR2(10) := Null;
   c_form_name      CONSTANT VARCHAR2(30) := 'show_results_frm';
   l_col_count      NUMBER;
   l_update_allowed BOOLEAN      := FALSE;
   l_map_button     BOOLEAN;
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_results');
--
   htp.p ('<!--');
   htp.p ('Parameters as passed - ');
   htp.p ('p_module             : '||p_module);
   htp.p ('p_ngqi_job_id        : '||p_ngqi_job_id);
   htp.p ('p_fail_on_no_results : '||nm3flx.boolean_to_char(p_fail_on_no_results));
   htp.p ('p_display_inv_type   : '||nm3flx.boolean_to_char(p_display_inv_type));
   htp.p ('-->');
   nm_debug.debug ('Parameters as passed - ');
   nm_debug.debug ('p_module             :..'||p_module||'..');
   nm_debug.debug ('p_ngqi_job_id        :..'||p_ngqi_job_id||'..');
   nm_debug.debug ('p_fail_on_no_results :..'||nm3flx.boolean_to_char(p_fail_on_no_results)||'..');
   nm_debug.debug ('p_display_inv_type   :..'||nm3flx.boolean_to_char(p_display_inv_type)||'..');
   --
   -- -- nm_debug.debug('   IF p_module IS NOT NULL');
   IF p_module IS NOT NULL
    THEN
   -- -- nm_debug.debug('      l_rec_hmo   := nm3get.get_hmo (pi_hmo_module => p_module);');
      l_rec_hmo   := nm3get.get_hmo (pi_hmo_module => p_module);
      l_checkbox  := l_rec_hmo.hmo_menu = 'M';
      l_radio     := l_rec_hmo.hmo_menu = 'S';
   END IF;
--
   -- -- nm_debug.debug('   IF l_checkbox');
   IF l_checkbox
    THEN
      l_input_type := c_checkbox;
   ELSIF l_radio
    THEN
      l_input_type := c_radio;
   ELSE
      l_no_select  := TRUE;
      l_input_type := 'BADGER';
   END IF;
--
   l_update_allowed := (p_module = c_val_error_correction_module);
--
   -- -- nm_debug.debug('   IF p_fail_on_no_results');
   IF p_fail_on_no_results
    THEN
      OPEN  cs_results (p_ngqi_job_id);
      FETCH cs_results INTO l_dummy;
      l_no_results := cs_results%NOTFOUND;
      CLOSE cs_results;
   --
      IF l_no_results
       THEN
         js_ner_and_back (pi_appl               => nm3type.c_net
                         ,pi_id                 => 318
                         ,pi_supplementary_info => Null
                         );
      END IF;
   END IF;
   --
   -- -- nm_debug.debug('   IF l_no_select');
   IF l_no_select
    THEN
      l_col_count := g_tab_ita.COUNT;
   ELSE
      l_col_count := g_tab_ita.COUNT + 1; -- has the iit_ne_id checkbox (or radio) col as well
   END IF;
   l_map_button := get_theme_count(g_rec_nit.nit_inv_type)>0;
   l_col_count := l_col_count + 2; -- for the detail one
   IF l_map_button
    THEN
      l_col_count := l_col_count+1;
   END IF;
--
   htp.tableopen (cattributes=>'BORDER=1');
--
   -- -- nm_debug.debug('   IF p_display_inv_type');
   IF p_display_inv_type
    THEN
      htp.tablerowopen;
      htp.tableheader(/*htf.small*/(g_rec_nit.nit_descr),cattributes=>'COLSPAN='||l_col_count);
      htp.tablerowclose;
   END IF;
--
   -- -- nm_debug.debug('   IF NOT l_no_select');
   IF NOT l_no_select
    THEN
      htp.formopen(l_rec_hmo.hmo_fastpath_opts, cattributes => 'NAME="'||c_form_name||'"');
   END IF;
--
   IF l_checkbox
    THEN
      --
      htp.tablerowopen;
      htp.p('<TD COLSPAN='||l_col_count||'>');
      do_select_all_buttons (c_form_name);
      --
      htp.p('</TD>');
      htp.tablerowclose;
      htp.comment ('*** Dummy values to force passing of arrays ***');
      htp.formhidden ('pi_iit_ne_id',0);
      htp.formhidden ('pi_iit_ne_id',0);
   ELSIF l_update_allowed
    THEN
      htp.tablerowopen;
      htp.p('<TD COLSPAN='||l_col_count||'>');
      htp.p ('<input type=button value="'||c_refresh||'" onClick="javascript:location.reload();">');
      htp.p('</TD>');
      htp.tablerowclose;
   END IF;
--
   IF NOT l_no_select
    THEN
      htp.tablerowopen;
      htp.tabledata('<DIV ALIGN=LEFT>'||htf.formsubmit (cvalue=>c_continue)||'</DIV>',cattributes=>'COLSPAN='||l_col_count);
      htp.tablerowclose;
   END IF;
--
   -- -- nm_debug.debug('   htp.tablerowopen;');
   htp.tablerowopen;
   htp.tableheader (htf.small('Row')); -- For rownum
   IF l_map_button
    THEN
      htp.tableheader (nm3web.c_nbsp); -- For map
   END IF;
   htp.tableheader (nm3web.c_nbsp); -- For detail
   IF NOT l_no_select
    THEN
      htp.tableheader (nm3web.c_nbsp);
   END IF;
   FOR i IN 1..g_tab_ita.COUNT
    LOOP
      htp.tableheader (htf.small(g_tab_ita(i).ita_scrn_text));
   END LOOP;
   htp.tablerowclose;
   --
   DECLARE
      l_block nm3type.tab_varchar32767;
      l_pre_format VARCHAR2(80);
      l_post_format VARCHAR2(80);
      PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
      BEGIN
         nm3tab_varchar.append (l_block,p_text,p_nl);
      END append;
   BEGIN
      append ('DECLARE',FALSE);
      append ('   CURSOR cs_inv_data (c_val NUMBER) IS');
      append (g_select_statement);
      append (' AND '||NVL(g_rec_nit.nit_foreign_pk_column,'iit_ne_id')||' IN (SELECT ngqi_item_id');
      append ('                    FROM  nm_gaz_query_item_list');
      append ('                   WHERE  ngqi_job_id = c_val');
      append ('                  );');
      append ('  l_checked VARCHAR2(8) := '||nm3flx.string(' CHECKED')||';');
      append ('  PROCEDURE add_it (p_text VARCHAR2) IS');
      append ('     c_ CONSTANT PLS_INTEGER := '||g_package_name||'.g_tab_data.COUNT+1;');
      append ('  BEGIN');
      append ('     '||g_package_name||'.g_tab_data(c_) := p_text;');
      append ('  END add_it;');
      append ('BEGIN');
      append ('   '||g_package_name||'.g_tab_data.DELETE;');
      append ('   FOR cs_rec IN cs_inv_data ('||p_ngqi_job_id||')');
      append ('    LOOP');
      append ('       add_it(htf.tabledata (htf.small(cs_inv_data%ROWCOUNT),cattributes=>'||nm3flx.string('ALIGN=CENTER VALIGN=MIDDLE')||'));');
      IF l_map_button
       THEN
         append ('       add_it(htf.tabledata ('||nm3flx.string('<input type="button" value="Map" onClick="popUp(')||'||'||g_package_name||'.get_map_url(cs_rec.iit_ne_id,'||nm3flx.string(g_rec_nit.nit_inv_type)||')||'||nm3flx.string(');">')||',cattributes=>'||nm3flx.string('ALIGN=CENTER VALIGN=MIDDLE')||'));');
      END IF;
      append ('       add_it(htf.tabledata ('||nm3flx.string('<input type="button" value="'||c_detail||'" onClick="popUp(')||'||'||g_package_name||'.get_detail_url(cs_rec.iit_ne_id,'||nm3flx.boolean_to_char(l_update_allowed)||','||nm3flx.string(g_rec_nit.nit_inv_type)||')||'||nm3flx.string(');">')||',cattributes=>'||nm3flx.string('ALIGN=CENTER VALIGN=MIDDLE')||'));');
      IF l_no_select
       THEN
         Null;
      ELSE
         append ('      add_it(htf.tabledata('||nm3flx.string('<INPUT TYPE='||l_input_type||' NAME="pi_iit_ne_id" VALUE="')||'||cs_rec.iit_ne_id||'||nm3flx.string('"')||'||l_checked||'||nm3flx.string('>')||',cattributes=>'||nm3flx.string('ALIGN=CENTER VALIGN=MIDDLE')||'));');
      END IF;
      IF l_radio
       THEN
         append ('      l_checked := Null;');
      END IF;
--
      FOR i IN 1..g_tab_ita.COUNT
       LOOP
         append ('      add_it(htf.tabledata (nm3flx.i_t_e(cs_rec.'||g_tab_ita(i).ita_attrib_name||' IS NULL,nm3web.c_nbsp,htf.small(cs_rec.'||g_tab_ita(i).ita_attrib_name||')),cattributes=>'||nm3flx.string('ALIGN=CENTER VALIGN=MIDDLE')||'));');
      END LOOP;
      append ('      add_it(htf.tablerowclose);');
      append ('      add_it(htf.tablerowopen(CVALIGN=>'||nm3flx.string('"MIDDLE"')||'));');
      append ('   END LOOP;');
      append ('END;');
--       nm_debug.delete_debug(TRUE);
--       nm_debug.debug_on;
       nm_debug.debug('c_detail="'||c_detail||'"');
      nm3tab_varchar.debug_tab_varchar (l_block);
--       nm_debug.debug_off;
      nm3ddl.execute_tab_varchar(l_block);
      --
      nm3web.htp_tab_varchar (g_tab_data);
      --
   END;
--
   IF NOT l_no_select
    THEN
      htp.tabledata('<DIV ALIGN=LEFT>'||htf.formsubmit (cvalue=>c_continue)||'</DIV>',cattributes=>'COLSPAN='||l_col_count);
      htp.tablerowclose;
      htp.formclose;
   ELSE
      htp.tablerowclose;
   END IF;
   htp.tableclose;
--
   IF NOT l_update_allowed
    THEN
      DELETE nm_gaz_query_item_list
      WHERE  ngqi_job_id  = p_ngqi_job_id;
      COMMIT;
   END IF;
--
   nm_debug.proc_end(g_package_name,'show_results');
--
END show_results;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_detail_url (pi_iit_ne_id      NUMBER
                        ,pi_update_allowed BOOLEAN  DEFAULT FALSE
                        ,pi_iit_inv_type   VARCHAR2 DEFAULT NULL
                        ) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3flx.string(g_package_name||'.show_detail?pi_iit_ne_id='||pi_iit_ne_id||CHR(38)||'pi_update_allowed_char='||nm3flx.boolean_to_char(pi_update_allowed)||CHR(38)||'pi_iit_inv_type='||pi_iit_inv_type);
END get_detail_url;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_theme_count (pi_iit_inv_type   VARCHAR2
                         ) RETURN PLS_INTEGER IS
--
   l_tab_nth_theme_id nm3type.tab_number;
   l_tab_theme_name   nm3type.tab_varchar80;
--
BEGIN
--
   get_themes_for_inv_type (pi_iit_inv_type   => pi_iit_inv_type
                           ,po_tab_theme_id   => l_tab_nth_theme_id
                           ,po_tab_theme_name => l_tab_theme_name
                           );
--
   RETURN l_tab_nth_theme_id.COUNT;
--
END get_theme_count;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_map_url (pi_iit_ne_id      NUMBER
                     ,pi_iit_inv_type   VARCHAR2
                     ) RETURN VARCHAR2 IS
--
   l_retval nm3type.max_varchar2;
--
   l_tab_nth_theme_id nm3type.tab_number;
   l_tab_theme_name   nm3type.tab_varchar80;
--
BEGIN
--
   get_themes_for_inv_type (pi_iit_inv_type   => pi_iit_inv_type
                           ,po_tab_theme_id   => l_tab_nth_theme_id
                           ,po_tab_theme_name => l_tab_theme_name
                           );
--
   IF l_tab_nth_theme_id.COUNT = 0
    THEN
      l_retval := g_package_name||'.no_theme_available?pi_iit_inv_type='||pi_iit_inv_type;
   ELSIF l_tab_nth_theme_id.COUNT = 1
    THEN
      l_retval := g_package_name||'.show_on_map?pi_iit_ne_id='||pi_iit_ne_id||CHR(38)||'pi_nth_theme_id='||l_tab_nth_theme_id(1)||CHR(38)||'pi_iit_inv_type='||pi_iit_inv_type;
   ELSE
      l_retval := g_package_name||'.select_theme?pi_iit_ne_id='||pi_iit_ne_id||CHR(38)||'pi_iit_inv_type='||pi_iit_inv_type;
   END IF;
   l_retval := nm3flx.string(l_retval);
   RETURN l_retval;
END get_map_url;
--
----------------------------------------------------------------------------------------
--
PROCEDURE get_themes_for_inv_type (pi_iit_inv_type   IN     VARCHAR2
                                  ,po_tab_theme_id      OUT nm3type.tab_number
                                  ,po_tab_theme_name    OUT nm3type.tab_varchar80
                                  ) IS
BEGIN
   SELECT nith_nth_theme_id
         ,gt_theme_name
    BULK  COLLECT
    INTO  po_tab_theme_id
         ,po_tab_theme_name
    FROM  nm_inv_themes
         ,gis_themes
   WHERE  nith_nit_id       = pi_iit_inv_type
    AND   nith_nth_theme_id = gt_theme_id;
END get_themes_for_inv_type;
--
----------------------------------------------------------------------------------------
--
PROCEDURE select_theme (pi_iit_ne_id    NUMBER
                       ,pi_iit_inv_type VARCHAR2
                       ) IS
--
   l_tab_nth_theme_id nm3type.tab_number;
   l_tab_theme_name   nm3type.tab_varchar80;
   c_title   CONSTANT VARCHAR2(80) := 'Select Theme To Map';
   l_checked VARCHAR2(8) := ' CHECKED';
--
BEGIN
--
   get_themes_for_inv_type (pi_iit_inv_type   => pi_iit_inv_type
                           ,po_tab_theme_id   => l_tab_nth_theme_id
                           ,po_tab_theme_name => l_tab_theme_name
                           );
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_title
               );
   htp.bodyopen;
   htp.tableopen (cattributes=>'BORDER=1');
   htp.tablerowopen;
   htp.tableheader (c_title,cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.formopen(g_package_name||'.show_on_map');
   htp.formhidden ('pi_iit_ne_id',pi_iit_ne_id);
   htp.formhidden ('pi_iit_inv_type',pi_iit_inv_type);
   FOR i IN 1..l_tab_nth_theme_id.COUNT
    LOOP
      htp.tablerowopen;
      htp.tabledata ('<INPUT TYPE='||c_radio||' NAME="pi_nth_theme_id" VALUE="'||l_tab_nth_theme_id(i)||'"'||l_checked||'>');
      l_checked := null;
      htp.tabledata (l_tab_theme_name(i));
      htp.tablerowclose;
   END LOOP;
--   htp.tableheader(
   htp.tablerowopen;
   htp.tableheader (htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
--   htp.p('>1 theme available');
   htp.bodyclose;
   htp.htmlclose;
END select_theme;
--
----------------------------------------------------------------------------------------
--
PROCEDURE show_on_map (pi_iit_ne_id    NUMBER
                      ,pi_nth_theme_id NUMBER
                      ,pi_iit_inv_type VARCHAR2
                      ) IS
   l_rec_nth nm_themes_all%ROWTYPE;
   l_rec_nit nm_inv_types%ROWTYPE;
   l_rec_gdo gis_data_objects%ROWTYPE;
   l_gdo_session_id NUMBER;
--
   c_webmapname CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('WEBMAPNAME');
   c_webmapdsrc CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('WEBMAPDSRC');
   c_webmapmsv  CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('WEBMAPMSV');
   c_jsp_url    CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('XWEBMAPJSP');
   l_url                 nm3type.max_varchar2;
--
   PROCEDURE ins_gdo (p_rec_gdo gis_data_objects%ROWTYPE) IS
   BEGIN
      INSERT INTO gis_data_objects
             (gdo_session_id
             ,gdo_pk_id
             ,gdo_rse_he_id
             ,gdo_st_chain
             ,gdo_end_chain
             ,gdo_x_val
             ,gdo_y_val
             ,gdo_theme_name
             ,gdo_feature_id
             ,gdo_xsp
             ,gdo_offset
             ,gdo_seq_no
             )
      VALUES (p_rec_gdo.gdo_session_id
             ,p_rec_gdo.gdo_pk_id
             ,p_rec_gdo.gdo_rse_he_id
             ,p_rec_gdo.gdo_st_chain
             ,p_rec_gdo.gdo_end_chain
             ,p_rec_gdo.gdo_x_val
             ,p_rec_gdo.gdo_y_val
             ,p_rec_gdo.gdo_theme_name
             ,p_rec_gdo.gdo_feature_id
             ,p_rec_gdo.gdo_xsp
             ,p_rec_gdo.gdo_offset
             ,p_rec_gdo.gdo_seq_no
             );
   END ins_gdo;
--
BEGIN
--
--   htp.p('show_on_map');
--   htp.br;
--   htp.p('pi_iit_ne_id : '||pi_iit_ne_id);
--   htp.br;
--   htp.p('pi_nth_theme_id : '||pi_nth_theme_id);
--   htp.br;
--   htp.p('pi_iit_inv_type : '||pi_iit_inv_type);
--   htp.br;
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_iit_inv_type);
   l_rec_nth        := nm3get.get_nth (pi_nth_theme_id => pi_nth_theme_id);
   l_gdo_session_id := higgis.get_session_id;
--   IF l_rec_nit.nit_table_name IS NULL
--    THEN
--      higgis.create_gdo
--              (pi_source_id      => pi_iit_ne_id
--              ,pi_source         => nm3extent.c_route
--              ,pi_gt_theme_name  => l_rec_nth.nth_theme_name
--              ,po_gdo_session_id => l_gdo_session_id
--              );
--   ELSE
   l_rec_gdo.gdo_session_id         := l_gdo_session_id;
   l_rec_gdo.gdo_pk_id              := pi_iit_ne_id;
   l_rec_gdo.gdo_rse_he_id          := Null;
   l_rec_gdo.gdo_st_chain           := Null;
   l_rec_gdo.gdo_end_chain          := Null;
   l_rec_gdo.gdo_x_val              := Null;
   l_rec_gdo.gdo_y_val              := Null;
   l_rec_gdo.gdo_theme_name         := l_rec_nth.nth_theme_name;
   l_rec_gdo.gdo_feature_id         := Null;
   l_rec_gdo.gdo_xsp                := Null;
   l_rec_gdo.gdo_offset             := Null;
   l_rec_gdo.gdo_seq_no             := 1;
   ins_gdo (l_rec_gdo);
--   END IF;
--
--
   l_url := c_jsp_url||'?GDO_SESSION_ID='||l_gdo_session_id
            ||CHR(38)||'mapname='||c_webmapname
            ||CHR(38)||'datasource='||c_webmapdsrc
            ||CHR(38)||'username='||USER
            ||CHR(38)||'omvserver='||c_webmapmsv;
--
   COMMIT;
--
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('   window.location="'||l_url||'";');
   htp.p('</SCRIPT>');
   htp.anchor(l_url, 'Click here');
--
END show_on_map;
--
----------------------------------------------------------------------------------------
--
PROCEDURE no_theme_available (pi_iit_inv_type VARCHAR2) IS
BEGIN
--
   htp.p('no_theme_available');
   htp.p('pi_iit_inv_type : '||pi_iit_inv_type);
--
END no_theme_available;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_js_funcs (p_script_open  BOOLEAN DEFAULT TRUE
                          ,p_script_close BOOLEAN DEFAULT TRUE
                          ) IS
BEGIN
--
   IF p_script_open
    THEN
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('<!-- Begin');
   END IF;
--
   --
   htp.p('function selectAll(formObj, isInverse)');
   htp.p('{');
   htp.p('   for (var i=0;i < formObj.length;i++)');
   htp.p('   {');
   htp.p('      fldObj = formObj.elements[i];');
   htp.p('      if (fldObj.type == '||nm3flx.string(c_checkbox)||')');
   htp.p('      {');
   htp.p('         if(isInverse)');
   htp.p('            fldObj.checked = (fldObj.checked) ? false : true;');
   htp.p('         else fldObj.checked = true;');
   htp.p('       }');
   htp.p('   }');
   htp.p('}');
   htp.p('function popUp(URL) {');
   htp.p('day = new Date();');
   htp.p('id = day.getTime();');
   htp.p('eval("page" + id + " = window.open(URL, '||nm3flx.string('" + id + "')||', '||nm3flx.string('toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=840,height=600')||');");');
   htp.p('}');
--
   IF p_script_close
    THEN
      htp.p('// End -->');
      htp.p('</SCRIPT>');
   END IF;
--
END create_js_funcs;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_select_all_buttons (p_form_name VARCHAR2) IS
BEGIN
--
   htp.p('<DIV ALIGN=LEFT>');
   htp.tableopen;
   htp.tablerowopen;
   htp.tabledata ('<input type=button value="'||c_select_all||'" onClick="javascript:selectAll('||p_form_name||',0);">');
   htp.tabledata ('<input type=button value="'||c_inverse_selection||'" onClick="javascript:selectAll('||p_form_name||',1);">');
   htp.tablerowclose;
   htp.tableclose;
   htp.p('</DIV>');
--
END do_select_all_buttons;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_for_inv_type (pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   l_tab_ita       nm3inv.tab_nita;
   l_rec_ita       nm_inv_type_attribs%ROWTYPE;
   l_tab_ita_extra nm3inv.tab_nita;
   c_iit_pk CONSTANT VARCHAR2(30) := 'IIT_PRIMARY_KEY';
   l_pk_specified  BOOLEAN;
   l_is_ft         BOOLEAN;
BEGIN
   g_select_statement := Null;
   g_tab_ita.DELETE;
   g_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
   SELECT *
    BULK  COLLECT
    INTO  l_tab_ita
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type = pi_nit_inv_type
   ORDER BY ita_disp_seq_no, ita_view_col_name;
--   l_tab_ita          := nm3inv.get_tab_ita (p_inv_type => pi_nit_inv_type);
--
   l_is_ft := g_rec_nit.nit_table_name IS NOT NULL;
   --
   IF l_is_ft
    THEN
      g_select_statement := 'SELECT '||g_rec_nit.nit_foreign_pk_column||' iit_ne_id';
      g_tab_ita := l_tab_ita;
   --
      FOR i IN 1..g_tab_ita.COUNT
       LOOP
         g_select_statement := g_select_statement
                                  ||CHR(10)||' ,'||g_tab_ita(i).ita_attrib_name;
      END LOOP;
   ELSE
      g_select_statement := 'SELECT iit_ne_id';
      --
      IF g_rec_nit.nit_x_sect_allow_flag = 'Y'
       THEN
         l_rec_ita.ita_attrib_name                := 'IIT_X_SECT';
         l_rec_ita.ita_scrn_text                  := 'XSP';
         l_rec_ita.ita_format_mask                := Null;
         l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      END IF;
      --
      IF c_always_show_inv_pk
       THEN
         l_pk_specified := FALSE;
         FOR i IN 1..l_tab_ita.COUNT
          LOOP
            l_pk_specified := l_tab_ita(i).ita_attrib_name = c_iit_pk;
            EXIT WHEN l_pk_specified;
         END LOOP;
         IF NOT l_pk_specified
          THEN
            l_rec_ita.ita_attrib_name                := c_iit_pk;
            l_rec_ita.ita_scrn_text                  := 'Primary Key';
            l_rec_ita.ita_format_mask                := Null;
            l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
         END IF;
      END IF;
      --
      l_rec_ita.ita_attrib_name                := c_iit_start_date;
      l_rec_ita.ita_scrn_text                  := c_iit_start_date_text;
      l_rec_ita.ita_format_mask                := 'TO_CHAR(IIT_START_DATE,nm3user.get_user_date_mask)';
      l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      --
      l_rec_ita.ita_attrib_name                := c_iit_admin_unit;
      l_rec_ita.ita_scrn_text                  := c_iit_admin_unit_text;
      l_rec_ita.ita_format_mask                := 'nm3ausec.get_unit_code(IIT_ADMIN_UNIT)';
      l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      --
      l_rec_ita.ita_attrib_name                := c_iit_descr;
      l_rec_ita.ita_scrn_text                  := c_iit_descr_text;
      l_rec_ita.ita_format_mask                := Null;
      l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      --
      l_rec_ita.ita_attrib_name                := c_iit_note;
      l_rec_ita.ita_scrn_text                  := c_iit_note_text;
      l_rec_ita.ita_format_mask                := Null;
      l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      --
      l_rec_ita.ita_attrib_name                := c_iit_peo_invent_by_id;
      l_rec_ita.ita_scrn_text                  := c_iit_peo_invent_by_id_text;
      l_rec_ita.ita_format_mask                := 'nm3user.get_username(iit_peo_invent_by_id)';
      l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      --
      IF g_rec_nit.nit_pnt_or_cont = 'C'
       THEN
         l_rec_ita.ita_attrib_name                := 'ITEM_LENGTH';
         l_rec_ita.ita_scrn_text                  := 'Length';
         l_rec_ita.ita_format_mask                := 'nm3net.get_ne_length(iit_ne_id)';
         l_tab_ita_extra(l_tab_ita_extra.COUNT+1) := l_rec_ita;
      END IF;
      --
      FOR i IN 1..l_tab_ita_extra.COUNT
       LOOP
         g_tab_ita(g_tab_ita.COUNT+1) := l_tab_ita_extra(i);
      END LOOP;
      --
      FOR i IN 1..l_tab_ita.COUNT
       LOOP
         g_tab_ita(g_tab_ita.COUNT+1) := l_tab_ita(i);
      END LOOP;
   --
      FOR i IN 1..g_tab_ita.COUNT
       LOOP
         IF g_tab_ita(i).ita_inv_type IS NOT NULL
          THEN
            g_select_statement := g_select_statement
                                  ||CHR(10)||' ,nm3inv.validate_flex_inv('||nm3flx.string(g_tab_ita(i).ita_inv_type)||','||nm3flx.string(g_tab_ita(i).ita_attrib_name)||','||g_tab_ita(i).ita_attrib_name||') '||g_tab_ita(i).ita_attrib_name;
         ELSE
            IF g_tab_ita(i).ita_format_mask IS NOT NULL
             THEN
               g_select_statement := g_select_statement
                                  ||CHR(10)||' ,'||g_tab_ita(i).ita_format_mask||' '||g_tab_ita(i).ita_attrib_name;
            ELSE
               g_select_statement := g_select_statement
                                  ||CHR(10)||' ,'||g_tab_ita(i).ita_attrib_name;
            END IF;
         END IF;
      END LOOP;
   END IF;
--
   IF l_is_ft
    THEN
      g_select_statement := g_select_statement
                            ||CHR(10)||' FROM '||g_rec_nit.nit_table_name
                            ||CHR(10)||'WHERE 1=1';
   ELSE
      g_select_statement := g_select_statement
                            ||CHR(10)||' FROM nm_inv_items'
                            ||CHR(10)||'WHERE iit_inv_type = '||nm3flx.string(pi_nit_inv_type);
   END IF;
END instantiate_for_inv_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_detail (pi_iit_ne_id           NUMBER   DEFAULT NULL
                      ,pi_update_allowed      BOOLEAN  DEFAULT FALSE
                      ,pi_update_allowed_char VARCHAR2 DEFAULT nm3type.c_false
                      ,pi_close_button        BOOLEAN  DEFAULT TRUE
                      ,pi_iit_inv_type        VARCHAR2 DEFAULT NULL
                      ) IS
   l_rec_iit                      nm_inv_items%ROWTYPE;
   l_tab_rec_inv_flex_col_details nm3asset.tab_rec_inv_flex_col_details;
   l_tab_rec_datum_loc_dets       nm3asset.tab_rec_datum_loc_dets;
   l_tab_rec_route_loc_dets       nm3route_ref.tab_rec_route_loc_dets;
   l_rec_nit                      nm_inv_types%ROWTYPE;
   l_tab_child_types_with_data    nm3type.tab_varchar4;
   l_tab_parent_types_with_data   nm3type.tab_varchar4;
   l_hierarchical_ngqi_job_id            NUMBER;
--
--   l_tab_xll_id          nm3type.tab_number;
--   l_tab_xll_description nm3type.tab_varchar80;
--
   l_update_allowed      BOOLEAN := nm3flx.char_to_boolean (pi_update_allowed_char);
--
   l_value               nm3type.max_varchar2;
   l_meaning             nm3type.max_varchar2;
   l_descr               nm3type.max_varchar2;
   l_cur                 nm3type.ref_cursor;
   l_selected            VARCHAR2(10);
   l_rec_ita             nm_inv_type_attribs%ROWTYPE;
   l_colspan             NUMBER;
   l_window_title        nm3type.max_varchar2;
--
   PROCEDURE add_detail_trio (p_header VARCHAR2, p_meaning VARCHAR2, p_descr VARCHAR2, p_header_bold BOOLEAN DEFAULT TRUE) IS
   BEGIN
      htp.tablerowopen;
      IF p_header_bold
       THEN
         htp.tableheader(/*htf.small*/(NVL(p_header,nm3web.c_nbsp)));
      ELSE
         htp.tabledata(/*htf.small*/(NVL(p_header,nm3web.c_nbsp)));
      END IF;
      htp.tabledata(/*htf.small*/(NVL(p_meaning,nm3web.c_nbsp)));
      htp.tabledata(/*htf.small*/(NVL(p_descr,nm3web.c_nbsp)));
      htp.tablerowclose;
   END add_detail_trio;
--
   PROCEDURE add_detail_pair (p_header VARCHAR2, p_meaning VARCHAR2, p_header_bold BOOLEAN DEFAULT TRUE) IS
   BEGIN
      htp.tablerowopen;
      IF p_header_bold
       THEN
         htp.tableheader(/*htf.small*/(NVL(p_header,nm3web.c_nbsp)));
      ELSE
         htp.tabledata(/*htf.small*/(NVL(p_header,nm3web.c_nbsp)));
      END IF;
      htp.tabledata(/*htf.small*/(NVL(p_meaning,nm3web.c_nbsp)));
      htp.tablerowclose;
   END add_detail_pair;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_detail');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_detail
               );
--
   create_js_funcs (p_script_open  => TRUE
                   ,p_script_close => TRUE
                   );
--
   sccs_tags;
   htp.headclose;
   htp.bodyopen;
--
   IF pi_iit_ne_id IS NULL
    THEN
      htp.p('<SCRIPT>');
      htp.p('history.back()');
      htp.p('history.back()');
      htp.p('</SCRIPT>');
      htp.bodyclose;
      htp.htmlclose;
      RETURN;
   END IF;
--
   do_close_window_button (pi_close_button);
--
   IF pi_iit_inv_type IS NOT NULL
    THEN
      l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_iit_inv_type);
   END IF;
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      l_rec_iit := nm3get.get_iit (pi_iit_ne_id    => pi_iit_ne_id);
      l_rec_nit := nm3get.get_nit (pi_nit_inv_type => l_rec_iit.iit_inv_type);
      --
      l_window_title := c_detail||' ('||l_rec_nit.nit_descr||' - '||l_rec_iit.iit_primary_key||')';
      htp.p('<SCRIPT LANGUAGE="Javascript">');
      htp.p('<!--');
      htp.p('   document.title="'||l_window_title||'";');
      htp.p('// -->');
      htp.p('</SCRIPT>');
   END IF;
   --
--
   IF  (pi_update_allowed OR l_update_allowed)
    AND l_rec_nit.nit_table_name IS NULL
    AND invsec.is_inv_item_updatable (p_iit_inv_type           => l_rec_iit.iit_inv_type
                                     ,p_iit_admin_unit         => l_rec_iit.iit_admin_unit
                                     ,pi_unrestricted_override => FALSE
                                     )
    THEN
      l_update_allowed := TRUE;
   ELSE
      l_update_allowed := FALSE;
   END IF;
   --
--
   nm3asset.get_inv_flex_col_details       (pi_iit_ne_id           => pi_iit_ne_id
                                           ,pi_nit_inv_type        => l_rec_nit.nit_inv_type
                                           ,pi_display_xsp_if_reqd => TRUE
                                           ,po_flex_col_dets       => l_tab_rec_inv_flex_col_details
                                           );
--
   nm3asset.get_inv_datum_location_details (pi_iit_ne_id          => pi_iit_ne_id
                                           ,pi_nit_inv_type       => l_rec_nit.nit_inv_type
                                           ,po_tab_datum_loc_dets => l_tab_rec_datum_loc_dets
                                           );
--
   nm3asset.get_inv_route_location_details (pi_iit_ne_id          => pi_iit_ne_id
                                           ,pi_nit_inv_type       => l_rec_nit.nit_inv_type
                                           ,po_tab_route_loc_dets => l_tab_rec_route_loc_dets
                                           );
--

--
   htp.tableopen (cattributes=>'BORDER=1');
   l_colspan := 1;
   l_colspan := nm3flx.i_t_e(l_tab_rec_datum_loc_dets.COUNT > 0
                            ,l_colspan + 1
                            ,l_colspan
                            );
   l_colspan := nm3flx.i_t_e(l_tab_rec_route_loc_dets.COUNT > 0
                            ,l_colspan + 1
                            ,l_colspan
                            );
--   htp.tablerowopen;
--   htp.tableheader(/*htf.small*/(l_rec_nit.nit_descr),cattributes=>'COLSPAN='||l_colspan);
--   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(/*htf.small*/('Attributes'));
   IF l_tab_rec_datum_loc_dets.COUNT > 0
    THEN
      htp.tableheader(/*htf.small*/('Datum Location'));
   END IF;
   IF l_tab_rec_route_loc_dets.COUNT > 0
    THEN
      htp.tableheader(/*htf.small*/('Route Location'));
   END IF;
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TD VALIGN=TOP>');
      htp.tableopen (cattributes=>'BORDER=1');
      IF l_update_allowed
       THEN
         htp.formopen(g_package_name||'.update_item', cattributes => 'NAME="update_item"');
         htp.formhidden ('pi_close_button',nm3flx.boolean_to_char(pi_close_button));
         FOR i IN 1..l_tab_rec_inv_flex_col_details.COUNT
          LOOP
            htp.formhidden (cname  => 'ita_attrib_name'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).ita_attrib_name
                           );
            htp.formhidden (cname  => 'iit_ne_id'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).iit_ne_id
                           );
            htp.formhidden (cname  => 'nit_update_allowed'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).nit_update_allowed
                           );
            htp.formhidden (cname  => 'ita_format'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).ita_format
                           );
            htp.formhidden (cname  => 'ita_format_mask'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).ita_format_mask
                           );
            htp.formhidden (cname  => 'iit_inv_type'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).iit_inv_type
                           );
            htp.formhidden (cname  => 'iit_start_date'
                           ,cvalue => TO_CHAR(l_tab_rec_inv_flex_col_details(i).iit_start_date,nm3type.c_full_date_time_format)
                           );
            htp.formhidden (cname  => 'iit_date_modified'
                           ,cvalue => TO_CHAR(l_tab_rec_inv_flex_col_details(i).iit_date_modified,nm3type.c_full_date_time_format)
                           );
            htp.formhidden (cname  => 'iit_value_orig'
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).iit_value_orig
                           );
            htp.formhidden (cname  => c_iit_admin_unit
                           ,cvalue => l_tab_rec_inv_flex_col_details(i).iit_admin_unit
                           );
            IF l_tab_rec_inv_flex_col_details(i).ita_update_allowed = 'Y'
             THEN
            --
               l_rec_ita := nm3get.get_ita (pi_ita_inv_type    => l_tab_rec_inv_flex_col_details(i).iit_inv_type
                                           ,pi_ita_attrib_name => l_tab_rec_inv_flex_col_details(i).ita_attrib_name
                                           ,pi_raise_not_found => FALSE
                                           );
            --
               IF l_rec_ita.ita_inv_type IS NULL
                THEN -- THis is not a flexible attribute
                  DECLARE
                     l_rec_atc all_tab_columns%ROWTYPE;
                  BEGIN
                     l_rec_atc := nm3ddl.get_column_details (p_column_name => l_tab_rec_inv_flex_col_details(i).ita_attrib_name
                                                            ,p_table_name  => 'NM_INV_ITEMS_ALL'
                                                            );
                     l_rec_ita.ita_format      := l_rec_atc.data_type;
                     l_rec_ita.ita_fld_length  := nm3flx.i_t_e(l_rec_atc.data_type=nm3type.c_date
                                                              ,NVL(LENGTH(nm3user.get_user_date_mask),11)
                                                              ,l_rec_atc.data_length
                                                              );
                     l_rec_ita.ita_attrib_name := l_rec_atc.column_name;
                     l_rec_ita.ita_inv_type    := l_rec_nit.nit_inv_type;
                  END;
               END IF;
            --
               htp.tablerowopen;
               htp.tableheader (/*htf.small*/ (l_tab_rec_inv_flex_col_details(i).ita_scrn_text||htf.sup(l_tab_rec_inv_flex_col_details(i).ita_mandatory_asterisk)));
               htp.p('<TD>');
               IF l_tab_rec_inv_flex_col_details(i).iit_lov_sql IS NOT NULL
                THEN
--                  htp.comment (l_tab_rec_inv_flex_col_details(i).iit_lov_sql);
                  htp.formselectopen (cname => 'iit_value');
                  IF l_tab_rec_inv_flex_col_details(i).ita_mandatory_yn = 'N'
                   THEN
                     htp.p('   <OPTION VALUE="">'||nm3web.c_nbsp||'</OPTION>');
                  END IF;
                  OPEN  l_cur FOR l_tab_rec_inv_flex_col_details(i).iit_lov_sql;
                  LOOP
                     FETCH l_cur INTO l_value, l_meaning, l_descr;
                     EXIT WHEN l_cur%NOTFOUND;
                     IF l_value = l_tab_rec_inv_flex_col_details(i).iit_value_orig
                      THEN
                        l_selected := c_selected;
                     ELSE
                        l_selected := Null;
                     END IF;
                     IF NVL(l_meaning,nm3type.c_nvl) != NVL(l_descr,nm3type.c_nvl)
                      THEN
                        htp.p('   <OPTION VALUE="'||l_value||'"'||l_selected||'>'||l_meaning||' - '||l_descr||'</OPTION>');
                     ELSE
                        htp.p('   <OPTION VALUE="'||l_value||'"'||l_selected||'>'||l_meaning||'</OPTION>');
                     END IF;
                  END LOOP;
                  CLOSE l_cur;
                  htp.formselectclose;
               ELSE
                  IF l_rec_ita.ita_fld_length > 50
                   THEN
                     htp.formtextareaopen
                                  (cname       => 'iit_value'
                                  ,nrows       => TRUNC(l_rec_ita.ita_fld_length/50)+1
                                  ,ncolumns    => 50
                                  ,cattributes => 'WRAP=SOFT'
                                  );
                     htp.p(l_tab_rec_inv_flex_col_details(i).iit_value_orig);
                     htp.formtextareaclose;
                  ELSE
                     htp.formtext (cname      => 'iit_value'
                                  ,cvalue     => l_tab_rec_inv_flex_col_details(i).iit_value_orig
                                  ,cmaxlength => l_rec_ita.ita_fld_length
                                  );
                  END IF;
               END IF;
               htp.p('</TD>');
               htp.tabledata(nm3web.c_nbsp);
               htp.tablerowclose;
            ELSE
               htp.formhidden (cname  => 'iit_value'
                              ,cvalue => l_tab_rec_inv_flex_col_details(i).iit_value_orig
                              );
               add_detail_trio (l_tab_rec_inv_flex_col_details(i).ita_scrn_text||htf.sup(l_tab_rec_inv_flex_col_details(i).ita_mandatory_asterisk)
                               ,l_tab_rec_inv_flex_col_details(i).iit_meaning
                               ,l_tab_rec_inv_flex_col_details(i).iit_description
                               );
            END IF;
         END LOOP;
         htp.tablerowopen;
         htp.tableheader (htf.formsubmit(cvalue=>'Update'),cattributes=>'COLSPAN=3');
         htp.tablerowclose;
         htp.formclose;
      ELSE
         FOR i IN 1..l_tab_rec_inv_flex_col_details.COUNT
          LOOP
            add_detail_trio (l_tab_rec_inv_flex_col_details(i).ita_scrn_text
                            ,l_tab_rec_inv_flex_col_details(i).iit_meaning
                            ,l_tab_rec_inv_flex_col_details(i).iit_description
                            );
         END LOOP;
      END IF;
      htp.tableclose;
   htp.p('</TD>');
   IF l_tab_rec_datum_loc_dets.COUNT > 0
    THEN
      htp.p('<TD VALIGN=TOP>');
         htp.tableopen (cattributes=>'BORDER=1');
         htp.tablerowopen;
         htp.tableheader(/*htf.small*/('Unique'));
         IF l_rec_nit.nit_pnt_or_cont = 'P'
          THEN
            htp.tableheader(/*htf.small*/('MP'));
         ELSE
            htp.tableheader(/*htf.small*/('Begin MP'));
            htp.tableheader(/*htf.small*/('End MP'));
         END IF;
         htp.tablerowclose;
         FOR i IN 1..l_tab_rec_datum_loc_dets.COUNT
          LOOP
            IF l_rec_nit.nit_pnt_or_cont = 'P'
             THEN
               add_detail_pair (l_tab_rec_datum_loc_dets(i).datum_ne_unique,l_tab_rec_datum_loc_dets(i).nm_begin_mp,FALSE);
            ELSE
               add_detail_trio (l_tab_rec_datum_loc_dets(i).datum_ne_unique,l_tab_rec_datum_loc_dets(i).nm_begin_mp,l_tab_rec_datum_loc_dets(i).nm_end_mp,FALSE);
            END IF;
         END LOOP;
         htp.tableclose;
      htp.p('</TD>');
   END IF;
   IF l_tab_rec_route_loc_dets.COUNT > 0
    THEN
      htp.p('<TD VALIGN=TOP>');
         htp.tableopen (cattributes=>'BORDER=1');
         htp.tablerowopen;
         htp.tableheader(/*htf.small*/('Unique'));
         IF l_rec_nit.nit_pnt_or_cont = 'P'
          THEN
            htp.tableheader(/*htf.small*/('SLK'));
         ELSE
            htp.tableheader(/*htf.small*/('Begin SLK'));
            htp.tableheader(/*htf.small*/('End SLK'));
         END IF;
         htp.tablerowclose;
         FOR i IN 1..l_tab_rec_route_loc_dets.COUNT
          LOOP
            IF l_rec_nit.nit_pnt_or_cont = 'P'
             THEN
               add_detail_pair (l_tab_rec_route_loc_dets(i).route_ne_unique,l_tab_rec_route_loc_dets(i).nm_slk,FALSE);
            ELSE
               add_detail_trio (l_tab_rec_route_loc_dets(i).route_ne_unique,l_tab_rec_route_loc_dets(i).nm_slk,l_tab_rec_route_loc_dets(i).nm_end_slk,FALSE);
            END IF;
         END LOOP;
         htp.tableclose;
      htp.p('</TD>');
   END IF;
   htp.tablerowclose;
   htp.tableclose;
--
   SELECT itg_inv_type
    BULK  COLLECT
    INTO  l_tab_child_types_with_data
    FROM  nm_inv_type_groupings
   WHERE  itg_parent_inv_type = l_rec_nit.nit_inv_type
    AND   EXISTS (SELECT /*+ INDEX (iit iit_pk) */ 1
                   FROM  nm_inv_item_groupings
                        ,nm_inv_items iit
                  WHERE  iig_parent_id = l_rec_iit.iit_ne_id
                   AND   iig_item_id   = iit_ne_id
                   AND   iit_inv_type  = itg_inv_type
                 );
   --
   IF l_tab_child_types_with_data.COUNT > 0
    THEN
      htp.hr (cattributes=>'WIDTH=75%');
      htp.p ('<DIV ALIGN=CENTER><STRONG>Child Assets</STRONG></DIV>');
   END IF;
   --
   FOR i IN 1..l_tab_child_types_with_data.COUNT
    LOOP
      --
      SAVEPOINT top_of_child;
      --
      l_hierarchical_ngqi_job_id := nm3pbi.get_job_id;
      --
      DELETE FROM nm_gaz_query_item_list
      WHERE ngqi_job_id = l_hierarchical_ngqi_job_id;
      --
      INSERT INTO nm_gaz_query_item_list
            (ngqi_job_id
            ,ngqi_item_type_type
            ,ngqi_item_type
            ,ngqi_item_id
            )
      SELECT l_hierarchical_ngqi_job_id
            ,nm3gaz_qry.c_ngqt_item_type_type_inv
            ,l_tab_child_types_with_data(i)
            ,iit_ne_id
       FROM  nm_inv_item_groupings
            ,nm_inv_items iit
      WHERE  iig_parent_id = l_rec_iit.iit_ne_id
       AND   iig_item_id   = iit_ne_id
       AND   iit_inv_type  = l_tab_child_types_with_data(i);
      --
      instantiate_for_inv_type (pi_nit_inv_type => l_tab_child_types_with_data(i));
      --
      show_results (p_module             => Null
                   ,p_ngqi_job_id        => l_hierarchical_ngqi_job_id
                   ,p_fail_on_no_results => FALSE
                   ,p_display_inv_type   => TRUE
                   );
      --
      ROLLBACK TO top_of_child;
      --
   END LOOP;
   --
   IF l_tab_child_types_with_data.COUNT > 0
    THEN
      instantiate_for_inv_type (pi_nit_inv_type => l_rec_iit.iit_inv_type);
   END IF;
   --
   SELECT itg_parent_inv_type
    BULK  COLLECT
    INTO  l_tab_parent_types_with_data
    FROM  nm_inv_type_groupings
   WHERE  itg_inv_type = l_rec_nit.nit_inv_type
    AND   EXISTS (SELECT /*+ INDEX (iit iit_pk) */ 1
                   FROM  nm_inv_item_groupings
                        ,nm_inv_items iit
                  WHERE  iig_item_id   = l_rec_iit.iit_ne_id
                   AND   iig_parent_id = iit_ne_id
                   AND   iit_inv_type  = itg_parent_inv_type
                 );
   --
   IF l_tab_parent_types_with_data.COUNT > 0
    THEN
      htp.hr (cattributes=>'WIDTH=75%');
      htp.p ('<DIV ALIGN=CENTER><STRONG>Parent Asset</STRONG></DIV>');
   END IF;
   --
   FOR i IN 1..l_tab_parent_types_with_data.COUNT
    LOOP
      --
      SAVEPOINT top_of_parent;
      --
      l_hierarchical_ngqi_job_id := nm3pbi.get_job_id;
      --
      DELETE FROM nm_gaz_query_item_list
      WHERE ngqi_job_id = l_hierarchical_ngqi_job_id;
      --
      INSERT INTO nm_gaz_query_item_list
            (ngqi_job_id
            ,ngqi_item_type_type
            ,ngqi_item_type
            ,ngqi_item_id
            )
      SELECT l_hierarchical_ngqi_job_id
            ,nm3gaz_qry.c_ngqt_item_type_type_inv
            ,l_tab_parent_types_with_data(i)
            ,iit_ne_id
       FROM  nm_inv_item_groupings
            ,nm_inv_items iit
      WHERE  iig_item_id   = l_rec_iit.iit_ne_id
       AND   iig_parent_id = iit_ne_id
       AND   iit_inv_type  = l_tab_parent_types_with_data(i);
      --
      instantiate_for_inv_type (pi_nit_inv_type => l_tab_parent_types_with_data(i));
      --
      show_results (p_module             => Null
                   ,p_ngqi_job_id        => l_hierarchical_ngqi_job_id
                   ,p_fail_on_no_results => FALSE
                   ,p_display_inv_type   => TRUE
                   );
      --
      ROLLBACK TO top_of_parent;
      --
   END LOOP;
   --
   IF l_tab_parent_types_with_data.COUNT > 0
    THEN
      instantiate_for_inv_type (pi_nit_inv_type => l_rec_iit.iit_inv_type);
   END IF;
--
   do_close_window_button (pi_close_button);
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'show_detail');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END show_detail;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_close_window_button (p_do_button BOOLEAN DEFAULT TRUE) IS
BEGIN
   IF p_do_button
    THEN
      htp.p('<DIV ALIGN=RIGHT>');
      htp.p('<form>');
      htp.p('<input type="button" value="'||c_close||'" onClick="window.close();">');
      htp.p('</form>');
      htp.p('</DIV>');
   END IF;
END do_close_window_button;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_val_multi (pi_iit_ne_id nm3type.tab_varchar30) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_val_multi');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_multi_val_create_mod_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_multi_val_create_module);
--
   xval_create_inv.enter_data
                     (p_inv_type           => get_val_inv_type
                     ,p_module             => c_multi_val_create_module
                     ,p_module_title       => c_multi_val_create_mod_title
                     ,p_parent_ngqi_job_id => xval_reval.put_tab_iit_ne_id_into_ngqi (p_tab_iit_ne_id => pi_iit_ne_id)
                     );
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'create_val_multi');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END create_val_multi;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_val (pi_iit_ne_id NUMBER) IS
   l_rec_iit_parent nm_inv_items%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_val');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_val_create_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_val_create_module);
--
   l_rec_iit_parent := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id);
--
   xval_create_inv.enter_data
                     (p_inv_type        => get_val_inv_type
                     ,p_module          => c_val_create_module
                     ,p_module_title    => c_val_create_module_title
                     ,p_iit_foreign_key => l_rec_iit_parent.iit_primary_key
                     );
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'create_val');
--
EXCEPTION
--
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
--
END create_val;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_au_listbox (pi_admin_type       nm_admin_units.nau_admin_type%TYPE
                        ,pi_parameter_name   VARCHAR2
                        ,pi_normal_mode_only BOOLEAN DEFAULT FALSE
                        ) IS
--
   l_tab_depth nm3type.tab_number;
   l_tab_label nm3type.tab_varchar2000;
   l_tab_au    nm3type.tab_number;
--
   c_mode_not_to_be   CONSTANT VARCHAR2(10) := nm3flx.i_t_e (pi_normal_mode_only
                                                            ,nm3type.c_readonly
                                                            ,nm3type.c_nvl
                                                            );
--
BEGIN
--
   SELECT depth
         ,label
         ,nau_admin_unit
   BULK   COLLECT
   INTO   l_tab_depth
         ,l_tab_label
         ,l_tab_au
   FROM (
         SELECT 1 DEPTH
               ,nau_unit_code||' - '||nau_name label
               ,nau_admin_unit
         FROM   nm_admin_units
         WHERE  nau_admin_unit IN (SELECT nau_admin_unit
                                    FROM  nm_admin_units
                                   WHERE  nau_admin_type = pi_admin_type
                                    AND   nau_level = 1
                                   )
         UNION ALL
         SELECT l_level+1 DEPTH
               ,nau_unit_code||' - '||nau_name label
               ,nau_admin_unit
         FROM   nm_admin_units
              ,(SELECT nag_child_admin_unit, LEVEL l_level
                 FROM (SELECT *
                        FROM  NM_ADMIN_GROUPS
                       WHERE  nag_direct_link = 'Y'
                      )
                CONNECT BY PRIOR nag_child_admin_unit = nag_parent_admin_unit
                START WITH nag_parent_admin_unit IN (SELECT nau_admin_unit
                                                      FROM  nm_admin_units
                                                     WHERE  nau_admin_type = pi_admin_type
                                                      AND   nau_level = 1
                                                    )
                )
         WHERE nau_admin_unit = nag_child_admin_unit
       )
   WHERE  EXISTS (SELECT 1
                   FROM  v_nm_user_au_modes
                  WHERE  nau_admin_unit = admin_unit
                   AND   au_mode       != c_mode_not_to_be
                 );
--
   IF l_tab_depth.COUNT = 1
    THEN
      htp.formhidden (pi_parameter_name,l_tab_au(1));
      htp.p(/*htf.small*/(l_tab_label(1)));
   ELSE
      htp.formselectopen(cname      => pi_parameter_name);
      FOR i IN 1..l_tab_depth.COUNT
       LOOP
         htp.p('   <OPTION VALUE="'||l_tab_au(i)||'">'||REPLACE(RPAD(' ',((l_tab_depth(i)-1)*5),' '),' ',nm3web.c_nbsp)||l_tab_label(i)||'</OPTION>');
      END LOOP;
      htp.formselectclose;
   END IF;
--
END do_au_listbox;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_item (ita_attrib_name    nm3type.tab_varchar32767
                      ,iit_value_orig     owa_util.vc_arr
                      ,iit_value          owa_util.vc_arr
                      ,iit_ne_id          nm3type.tab_varchar32767
                      ,nit_update_allowed nm3type.tab_varchar32767
                      ,ita_format         nm3type.tab_varchar32767
                      ,ita_format_mask    nm3type.tab_varchar32767
                      ,iit_inv_type       nm3type.tab_varchar32767
                      ,iit_start_date     nm3type.tab_varchar32767
                      ,iit_date_modified  nm3type.tab_varchar32767
                      ,iit_admin_unit     nm3type.tab_varchar32767
                      ,pi_close_button    VARCHAR2 DEFAULT nm3type.c_false
                      ) IS
--
   l_tab_rec_inv_flex_col_details nm3asset.tab_rec_inv_flex_col_details;
   l_rec                          nm3asset.rec_inv_flex_col_details;
   l_iit_ne_id                    nm_inv_items.iit_ne_id%TYPE;
--
BEGIN
---- nm_debug.delete_debug(TRUE);
---- nm_debug.debug_on;
--nm_debug.set_level(3);
--
   nm_debug.proc_start(g_package_name,'update_item');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_detail
               );
--
   create_js_funcs (p_script_open  => TRUE
                   ,p_script_close => TRUE
                   );
--
   sccs_tags;
   htp.headclose;
   htp.bodyopen;
--   nm3web.module_startup(c_this_module);
--
   FOR i IN 1..ita_attrib_name.COUNT
    LOOP
      --
      l_iit_ne_id                       := iit_ne_id(i);
      l_rec.iit_ne_id                   := l_iit_ne_id;
      l_rec.item_type_type              := nm3gaz_qry.c_ngqt_item_type_type_inv;
      l_rec.iit_inv_type                := iit_inv_type(i);
      l_rec.iit_start_date              := TO_DATE(iit_start_date(i),nm3type.c_full_date_time_format);
      l_rec.iit_date_modified           := TO_DATE(iit_date_modified(i),nm3type.c_full_date_time_format);
      l_rec.iit_admin_unit              := iit_admin_unit(i);
      l_rec.nit_category                := Null;
      l_rec.nit_table_name              := Null;
      l_rec.nit_lr_ne_column_name       := Null;
      l_rec.nit_lr_st_chain             := Null;
      l_rec.nit_lr_end_chain            := Null;
      l_rec.nit_foreign_pk_column       := Null;
      l_rec.nit_update_allowed          := nit_update_allowed(i);
      l_rec.ita_update_allowed          := Null;
      l_rec.ita_attrib_name             := ita_attrib_name(i);
      l_rec.ita_scrn_text               := Null;
      l_rec.ita_view_col_name           := Null;
      l_rec.ita_id_domain               := Null;
      l_rec.iit_lov_sql                 := Null;
      l_rec.ita_mandatory_yn            := Null;
      l_rec.ita_mandatory_asterisk      := Null;
      l_rec.ita_format                  := ita_format(i);
      l_rec.ita_format_mask             := ita_format_mask(i);
      l_rec.iit_value_orig              := iit_value_orig(i);
      l_rec.iit_value                   := iit_value(i);
      IF   l_rec.ita_format = nm3type.c_varchar
       THEN
         IF nm3inv.is_column_allowable_for_flex(l_rec.ita_attrib_name) = nm3type.c_true
          THEN
            IF l_rec.iit_value != UPPER(l_rec.iit_value)
             THEN
               l_rec.iit_value          := UPPER(l_rec.iit_value);
            END IF;
            l_rec.iit_value             := REPLACE (l_rec.iit_value,CHR(10),' ');
            l_rec.iit_value             := REPLACE (l_rec.iit_value,CHR(13),Null);
         END IF;
         l_rec.iit_value                := RTRIM(l_rec.iit_value,' ');
      END IF;
      l_rec.iit_description             := Null;
      l_rec.iit_meaning                 := Null;
--      -- nm_debug.debug('////////////'||i);
--      -- nm_debug.debug('l_rec.ita_attrib_name : '||l_rec.ita_attrib_name);
--      -- nm_debug.debug('l_rec.iit_value_orig : '||l_rec.iit_value_orig);
--      -- nm_debug.debug('l_rec.iit_value : '||l_rec.iit_value);
--      IF l_rec.ita_attrib_name = 'IIT_CHR_ATTRIB56'
--       THEN
--         -- nm_debug.debug(LENGTH(iit_value_orig(i)));
--         FOR j IN 1..NVL(LENGTH(iit_value_orig(i)),0)
--          LOOP
--            -- nm_debug.debug(j||'=CHR('||ASCII(SUBSTR(iit_value_orig(i),j,1))||')');
--         END LOOP;
--      END IF;
      --
      l_tab_rec_inv_flex_col_details(i) := l_rec;
      --
   END LOOP;
--
   -- nm_debug.debug('   nm3asset.update_inv_flex_cols (pio_flex_col_dets => l_tab_rec_inv_flex_col_details);');
   nm3asset.update_inv_flex_cols (pio_flex_col_dets => l_tab_rec_inv_flex_col_details);
--
   js_ner (pi_appl               => nm3type.c_hig
          ,pi_id                 => 95
          --,pi_supplementary_info =>
          );
--
   COMMIT;
--
   show_detail (pi_iit_ne_id      => l_iit_ne_id
               ,pi_update_allowed => FALSE -- l_allow_update
               ,pi_close_button   => nm3flx.char_to_boolean (pi_close_button)
               );
--
   nm_debug.proc_end(g_package_name,'update_item');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END update_item;
--
----------------------------------------------------------------------------------------
--
END xval_find_inv;
/
