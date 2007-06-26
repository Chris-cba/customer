CREATE OR REPLACE PACKAGE BODY xtnz_find_inventory AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_find_inventory.pkb	1.1 03/15/05
--       Module Name      : xtnz_find_inventory.pkb
--       Date into SCCS   : 05/03/15 03:45:57
--       Date fetched Out : 07/06/06 14:40:20
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Transit Find Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000)              := '"@(#)xtnz_find_inventory.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT varchar2(30)                := 'xtnz_find_inventory';
--
   c_this_module     CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0570';
   c_module_title    CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_cp_module       CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0030';
   c_cp_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_cp_module);
--
   c_la_module       CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0040';
   c_la_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_la_module);
--
   c_continue     CONSTANT nm_errors.ner_descr%TYPE    := hig.get_ner(nm3type.c_hig,165).ner_descr;
   c_equals       CONSTANT VARCHAR2(5) := CHR(38)||'#61;';
--
   c_cp       CONSTANT nm_inv_types.nit_inv_type%TYPE := 'CP';
   c_la       CONSTANT nm_inv_types.nit_inv_type%TYPE := 'LA';
--
   g_checked                         VARCHAR2(8);
   c_checked  CONSTANT               VARCHAR2(8)  := ' CHECKED';
   c_selected CONSTANT               VARCHAR2(9)  := ' SELECTED';
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE js_ner_and_back (pi_appl               VARCHAR2
                          ,pi_id                 NUMBER
                          ,pi_supplementary_info VARCHAR2
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
   htp.p('--       sccsid           : @(#)xtnz_find_inventory.pkb	1.1 03/15/05');
   htp.p('--       Module Name      : xtnz_find_inventory.pkb');
   htp.p('--       Date into SCCS   : 05/03/15 03:45:57');
   htp.p('--       Date fetched Out : 07/06/06 14:40:20');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Transit Find Inventory package');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2003');
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
                    ,p_all_fields   => 'N'
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
PROCEDURE find_cp IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'find_cp');
--
   find_specific (p_inv_type     => c_cp
                 ,p_module       => c_cp_module
                 ,p_module_title => c_cp_module_title
                 );
--
   nm_debug.proc_end(g_package_name,'find_cp');
--
END find_cp;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_la IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'find_la');
--
   find_specific (p_inv_type     => c_la
                 ,p_module       => c_la_module
                 ,p_module_title => c_la_module_title
                 );
--
   nm_debug.proc_end(g_package_name,'find_la');
--
END find_la;
--
-----------------------------------------------------------------------------
--
PROCEDURE main IS
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
--
   nm3web.module_startup(c_this_module);
--
   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader (htf.small('Asset Type'));
   htp.p('<TD>');
--
   htp.formopen(g_package_name||'.main_find_window', cattributes => 'NAME="main_find_window"');
   --
   htp.formselectopen (cname => 'p_inv_type');
   FOR cs_rec IN (SELECT nit_inv_type
                        ,nit_descr
                   FROM  nm_inv_types
                  WHERE  nit_table_name IS NULL -- Do not bring foreign tables.
                  ORDER  BY nit_descr
                 )
    LOOP
      htp.p('   <OPTION VALUE="'||cs_rec.nit_inv_type||'">'||cs_rec.nit_descr||'</OPTION>');
   END LOOP;
   htp.formselectclose;
   --
   htp.formhidden ('p_module',c_this_module);
   htp.formhidden ('p_module_title',c_module_title);
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader(htf.small('Query All Fields'));
   htp.tabledata(htf.formcheckbox (cname    => 'p_all_fields'
                                  ,cvalue   => 'Y'
                                  ,cchecked => Null
                                  )
                );
   htp.tablerowclose;
   htp.tablerowopen;
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
   l_tab_ita_attrib_name  nm3type.tab_varchar30;
   l_tab_ita_scrn_text    nm3type.tab_varchar30;
   l_tab_ita_id_domain    nm3type.tab_varchar30;
   l_tab_ita_format       nm3type.tab_varchar30;
   l_tab_ita_fld_length   nm3type.tab_number;
   l_tab_ita_mandatory_yn nm3type.tab_varchar4;
BEGIN
--
   nm_debug.proc_start(g_package_name,'main_find_window');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(p_module);
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => p_inv_type);
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
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type  = l_rec_nit.nit_inv_type
    AND ((ita_queryable = 'Y' AND NVL(p_all_fields,'N') = 'N')
         OR NVL(p_all_fields,'N') = 'Y'
        )
   ORDER  BY ita_disp_seq_no, ita_scrn_text;
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
                         ,pi_supplementary_info => 'No queryable attributes'
                         );
      END IF;
   ELSE
--
      htp.tableopen (cattributes=> 'BORDER=1');
      htp.tablerowopen;
      htp.tableheader (htf.big(l_rec_nit.nit_descr),cattributes=>'COLSPAN=4');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tableheader (htf.small('Query'));
      htp.tableheader (htf.small('Attribute'));
      htp.tableheader (htf.small('Condition'));
      htp.tableheader (htf.small('Value'));
      htp.tablerowclose;
      htp.formopen(g_package_name||'.perform_search', cattributes => 'NAME="perform_search"');
      htp.formhidden ('p_inv_type',l_rec_nit.nit_inv_type);
      htp.formhidden ('p_module',p_module);
      htp.formhidden ('p_module_title',p_module_title);
   --
   -- Put a "fake" one in here so that the HTML always sends arrays down
   --
      htp.formhidden ('ita_query','IIT_START_DATE');
      htp.formhidden ('ita_attrib_name','IIT_START_DATE');
      htp.formhidden ('ita_value',Null);
      htp.formhidden ('ita_condition','IS NOT NULL');
      htp.formhidden ('ita_format',nm3type.c_date);
      htp.formhidden ('ita_counter','1');
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
         htp.p('<SMALL>');
         htp.p(l_tab_ita_scrn_text(i));
         IF l_tab_ita_mandatory_yn(i) = 'Y'
          THEN
            htp.p ('<SUP>*</SUP>');
         END IF;
--         htp.p('('||l_tab_ita_attrib_name(i)||')');
         htp.p('</SMALL>');
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
         IF l_tab_ita_id_domain(i) IS NULL
          THEN
            htp.tabledata (htf.formtext (cname      => 'ita_value'
--                                        ,csize      => LEAST(l_tab_ita_fld_length(i),50)
                                        ,cmaxlength => l_tab_ita_fld_length(i)
                                        )
                          );
         ELSE
            htp.p('<TD>');
            htp.formselectopen (cname => 'ita_value');
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
         END IF;
         htp.formhidden ('ita_format',l_tab_ita_format(i));
         htp.formhidden ('ita_counter',(i+1));
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
                         ,ita_query       owa_util.ident_arr
                         ,ita_attrib_name owa_util.ident_arr
                         ,ita_value       owa_util.vc_arr
                         ,ita_format      owa_util.ident_arr
                         ,ita_condition   owa_util.ident_arr
                         ,ita_counter     owa_util.ident_arr
                         ) IS
--
   l_rec_ngq       nm_gaz_query%ROWTYPE;
   l_rec_ngqt      nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa      nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv      nm_gaz_query_values%ROWTYPE;
--
   i               PLS_INTEGER;
   i2              PLS_INTEGER;
   l_matches       nm_gaz_query_item_list.ngqi_job_id%TYPE;
   l_tab_iit_ne_id nm3type.tab_number;
   l_meaning       nm3type.max_varchar2;
--
   FUNCTION find_index (p_attrib VARCHAR2) RETURN PLS_INTEGER IS
      l_retval PLS_INTEGER;
   BEGIN
      FOR i IN 1..ita_attrib_name.COUNT
       LOOP
         IF ita_attrib_name(i) = p_attrib
          THEN
            l_retval := i;
            EXIT;
         END IF;
      END LOOP;
      RETURN l_retval;
   END find_index;
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'perform_search');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
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
   IF ita_query.COUNT = 1
    THEN
      js_ner_and_back (pi_appl               => nm3type.c_net
                      ,pi_id                 => 121
                      ,pi_supplementary_info => 'No attributes flagged to be queried'
                      );
      htp.bodyclose;
      htp.htmlclose;
      RETURN;
   END IF;
--   NM_dEBUG.DELETE_DEBUG(true);
--   nm_debug.debug_on;
--   nm_Debug.debug('------');
--   FOR i IN 1..ita_counter.COUNT
--    LOOP
--      nm_debug.debug(i||':'||ita_counter(i)||':'||ita_attrib_name(i)||' '||ita_condition(i)||' '||ita_value(i));
--   END LOOP;
--   nm_Debug.debug('------');
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
      nm3ins.ins_ngqa (l_rec_ngqa);
      --
--      nm_debug.debug(i||':'||i2||':'||l_rec_ngqa.ngqa_attrib_name||' '||l_rec_ngqa.ngqa_condition||' '||ita_value(i2));
--      --
      IF nm3mrg_supplementary.get_pbi_condition_value_count(l_rec_ngqa.ngqa_condition) = 1
       THEN
         l_rec_ngqv.ngqv_ngq_id     := l_rec_ngqa.ngqa_ngq_id;
         l_rec_ngqv.ngqv_ngqt_seq_no:= l_rec_ngqa.ngqa_ngqt_seq_no;
         l_rec_ngqv.ngqv_ngqa_seq_no:= l_rec_ngqa.ngqa_seq_no;
         l_rec_ngqv.ngqv_sequence   := 1;
         nm3inv.validate_flex_inv (p_inv_type    => l_rec_ngqt.ngqt_item_type
                                  ,p_attrib_name => l_rec_ngqa.ngqa_attrib_name
                                  ,pi_value      => UPPER(ita_value(i2))
                                  ,po_value      => l_rec_ngqv.ngqv_value
                                  ,po_meaning    => l_meaning
                                  );
         nm3ins.ins_ngqv (l_rec_ngqv);
      END IF;
      --
      i := ita_query.NEXT(i);
      --
   END LOOP;
--
   l_matches := nm3gaz_qry.perform_query (pi_ngq_id => l_rec_ngq.ngq_id);
--
   SELECT ngqi_item_id
    BULK  COLLECT
    INTO  l_tab_iit_ne_id
    FROM  nm_gaz_query_item_list
   WHERE  ngqi_job_id = l_matches;
--
   IF l_tab_iit_ne_id.COUNT = 0
    THEN
      js_ner_and_back (pi_appl               => nm3type.c_net
                      ,pi_id                 => 318
                      ,pi_supplementary_info => Null
                      );
   ELSE
      xtnz_lar_mail_merge.get_all_inv_items_by_au (pi_nau_admin_unit   => Null
                                                  ,pi_iit_inv_type     => l_rec_ngqt.ngqt_item_type
                                                  ,pi_iit_ne_id_parent => Null
                                                  ,pi_ngqi_job_id      => l_matches
                                                  ,pi_checkbox_select  => FALSE
                                                  );
   END IF;
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
PROCEDURE js_ner_and_back (pi_appl               VARCHAR2
                          ,pi_id                 NUMBER
                          ,pi_supplementary_info VARCHAR2
                          ) IS
BEGIN
   htp.p('<SCRIPT>');
   htp.p('history.back()');
   nm3web.js_alert_ner (pi_appl       => pi_appl
                       ,pi_id         => pi_id
                       ,pi_extra_text => pi_supplementary_info
                       );
   htp.p('</SCRIPT>');
END js_ner_and_back;
--
----------------------------------------------------------------------------------------
--
END xtnz_find_inventory;
/
