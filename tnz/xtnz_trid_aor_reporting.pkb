CREATE OR REPLACE PACKAGE BODY xtnz_trid_aor_reporting AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_aor_reporting.pkb	1.1 03/15/05
--       Module Name      : xtnz_trid_aor_reporting.pkb
--       Date into SCCS   : 05/03/15 03:46:12
--       Date fetched Out : 07/06/06 14:40:33
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TNZ TRID AoR Reporting package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xtnz_trid_aor_reporting.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xtnz_trid_aor_reporting';
--
   c_this_module             CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0020';
   c_module_title            CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
   c_continue                CONSTANT nm_errors.ner_descr%TYPE    := hig.get_ner(nm3type.c_hig,165).ner_descr;
   c_trid_elec_drain_carr    CONSTANT nm_inv_types.nit_elec_drain_carr%TYPE := '#';
   c_find_module             CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0021';
   c_find_module_title       CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_find_module);
   c_other_module            CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0000';
   c_other_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_other_module);
   --
   g_ngqi_job_id NUMBER;

   CURSOR cs_ntc (c_ne_nt_type nm_types.nt_type%TYPE) IS
   SELECT *
    FROM  (SELECT col_name ntc_column_name
                 ,col_name variable_name
                 ,'Unique' ntc_prompt
                 ,30 ntc_str_length
                 ,-1 seq
            FROM  (SELECT 'ne_unique' col_name FROM DUAL)
           UNION ALL
           SELECT 'UPPER('||col_name||')' ntc_column_name
                 ,col_name variable_name
                 ,'Descr' ntc_prompt
                 ,80 ntc_str_length
                 ,0 seq
            FROM  (SELECT 'ne_descr' col_name FROM DUAL)
           UNION ALL
           SELECT LOWER(ntc_column_name) ntc_column_name
                 ,LOWER(ntc_column_name) variable_name
                 ,ntc_prompt
                 ,ntc_str_length
                 ,ntc_seq_no seq
            FROM  nm_type_columns
           WHERE  ntc_nt_type   = c_ne_nt_type
            AND   ntc_displayed = 'Y'
          )
   ORDER BY seq;
--
   g_checked                         VARCHAR2(8);
   c_checked  CONSTANT               VARCHAR2(8)  := ' CHECKED';
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
   htp.p('--       sccsid           : @(#)xtnz_trid_aor_reporting.pkb	1.1 03/15/05');
   htp.p('--       Module Name      : xtnz_trid_aor_reporting.pkb');
   htp.p('--       Date into SCCS   : 05/03/15 03:46:12');
   htp.p('--       Date fetched Out : 07/06/06 14:40:33');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   TNZ TRID AoR Reporting package');
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
PROCEDURE trid IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'trid');
--
   nt_qry (p_ne_nt_type => 'TRID');
--
   nm_debug.proc_end(g_package_name,'trid');
--
END trid;
--
-----------------------------------------------------------------------------
--
PROCEDURE nt_qry (p_ne_nt_type nm_elements.ne_nt_type%TYPE DEFAULT NULL) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'nt_qry');
--
   nm3web.module_startup(c_find_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_find_module_title
              );
   sccs_tags;
   htp.bodyopen;
   --
   IF p_ne_nt_type IS NULL
    THEN
      htp.formopen(g_package_name||'.nt_qry', cattributes => 'NAME="find_inv"');
      htp.tableopen;
      htp.tablerowopen;
      htp.tableheader(htf.small('Select Network Type'));
      htp.p('<TD>');
      htp.formselectopen(cname => 'p_ne_nt_type');
      FOR cs_rec IN (SELECT nt_type, nt_descr
                      FROM  nm_types
--                     WHERE  EXISTS (SELECT 1
--                                     FROM  nm_type_columns
--                                    WHERE  nt_type = ntc_nt_type
--                                     AND   ntc_displayed = 'Y'
--                                   )
                     ORDER BY nt_descr
                    )
       LOOP
         htp.p('   <OPTION VALUE='||cs_rec.nt_type||'>'||cs_rec.nt_descr||'</OPTION>');
      END LOOP;
      htp.formselectclose;
      htp.p('</TD>');
      htp.tablerowclose;
   ELSE
      htp.formopen(g_package_name||'.main', cattributes => 'NAME="find_inv"');
      htp.formhidden ('p_ne_nt_type',p_ne_nt_type);
      htp.tableopen;
      htp.tablerowopen;
      htp.tableheader(htf.small(nm3get.get_nt (pi_nt_type => p_ne_nt_type).nt_descr),cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      FOR cs_Rec IN cs_ntc(p_ne_nt_type)
       LOOP
         htp.tablerowopen;
         htp.tableheader(htf.small(cs_rec.ntc_prompt));
         htp.tabledata (htf.formtext (cname      => 'p_'||cs_rec.variable_name
                                     ,cmaxlength => cs_rec.ntc_str_length
                                     )
                       );
      END LOOP;
   END IF;
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
   --
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'nt_qry');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END nt_qry;
--
-----------------------------------------------------------------------------
--
PROCEDURE main (p_ne_nt_type    nm_elements.ne_nt_type%TYPE    DEFAULT NULL
               ,p_ne_unique     nm_elements.ne_unique%TYPE     DEFAULT NULL
               ,p_ne_descr      nm_elements.ne_descr%TYPE      DEFAULT NULL
               ,p_ne_owner      nm_elements.ne_owner%TYPE      DEFAULT NULL
               ,p_ne_name_1     nm_elements.ne_name_1%TYPE     DEFAULT NULL
               ,p_ne_name_2     nm_elements.ne_name_2%TYPE     DEFAULT NULL
               ,p_ne_prefix     nm_elements.ne_prefix%TYPE     DEFAULT NULL
               ,p_ne_number     nm_elements.ne_number%TYPE     DEFAULT NULL
               ,p_ne_sub_type   nm_elements.ne_sub_type%TYPE   DEFAULT NULL
               ,p_ne_group      nm_elements.ne_group%TYPE      DEFAULT NULL
               ,p_ne_sub_class  nm_elements.ne_sub_class%TYPE  DEFAULT NULL
               ,p_ne_nsg_ref    nm_elements.ne_nsg_ref%TYPE    DEFAULT NULL
               ,p_ne_version_no nm_elements.ne_version_no%TYPE DEFAULT NULL
               ) IS
   l_tab_nit_inv_type nm3type.tab_varchar4;
   l_tab_nit_descr    nm3type.tab_varchar80;
BEGIN
--
   nm_debug.proc_start(g_package_name,'main');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   --
   htp.formopen(g_package_name||'.find_inv', cattributes => 'NAME="find_inv"');
   htp.tableopen;
   htp.tablerowopen;
--   htp.tabledata (htf.formtext (cname      => 'pi_route'
--                               ,cmaxlength => 30
--                               )
--                 );


   IF p_ne_nt_type IS NOT NULL
    THEN
      DECLARE
         l_sql nm3type.max_varchar2;
         l_cur nm3type.ref_cursor;
         PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
         BEGIN
            IF p_nl
             THEN
               append (CHR(10),FALSE);
            END IF;
            l_sql := l_sql||p_text;
         END append;
      BEGIN
         g_ne_nt_type    := p_ne_nt_type;
         g_ne_unique     := UPPER(p_ne_unique);
         g_ne_descr      := UPPER(p_ne_descr);
         g_ne_owner      := UPPER(p_ne_owner);
         g_ne_name_1     := UPPER(p_ne_name_1);
         g_ne_name_2     := UPPER(p_ne_name_2);
         g_ne_prefix     := UPPER(p_ne_prefix);
         g_ne_number     := UPPER(p_ne_number);
         g_ne_sub_type   := UPPER(p_ne_sub_type);
         g_ne_group      := UPPER(p_ne_group);
         g_ne_sub_class  := UPPER(p_ne_sub_class);
         g_ne_nsg_ref    := UPPER(p_ne_nsg_ref);
         g_ne_version_no := UPPER(p_ne_version_no);
         append ('BEGIN');
         append ('SELECT ne_unique');
         append (' BULK  COLLECT');
         append (' INTO  '||g_package_name||'.g_tab_ne_unique');
         append (' FROM  nm_elements');
         append ('WHERE  ne_nt_type = '||g_package_name||'.g_ne_nt_type');
         FOR cs_rec IN cs_ntc(p_ne_nt_type)
          LOOP
            append (' AND ('||cs_rec.ntc_column_name||' LIKE '||nm3flx.string('%')||'||'||g_package_name||'.g_'||cs_rec.variable_name||'||'||nm3flx.string('%'));
            append ('     OR '||g_package_name||'.g_'||cs_rec.variable_name||' IS NULL');
            append ('     )');
         END LOOP;
         append (';',FALSE);
         append ('END;');
         EXECUTE IMMEDIATE l_sql;
--         htp.tabledata('g_ne_nt_type    := '||p_ne_nt_type); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_unique     := '||p_ne_unique); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_descr      := '||p_ne_descr); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_owner      := '||p_ne_owner); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_name_1     := '||p_ne_name_1); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_name_2     := '||p_ne_name_2); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_prefix     := '||p_ne_prefix); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_number     := '||p_ne_number); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_sub_type   := '||p_ne_sub_type); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_group      := '||p_ne_group); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_sub_class  := '||p_ne_sub_class); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_nsg_ref    := '||p_ne_nsg_ref); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata('g_ne_version_no := '||p_ne_version_no); htp.tablerowclose; htp.tablerowopen;
--         htp.tabledata(htf.code (l_sql),cattributes=>'COLSPAN=3');
         htp.tablerowclose;
         htp.tablerowopen;
         IF g_tab_ne_unique.COUNT = 0
          THEN
            hig.raise_ner (pi_appl => nm3type.c_net
                          ,pi_id   => 306
                          );
         END IF;
      END;
   ELSE
      SELECT ne_unique
       BULK  COLLECT
       INTO  g_tab_ne_unique
       FROM  nm_elements
      WHERE  ne_gty_group_type = 'T_EX';
   END IF;
   htp.tableheader (htf.small('Search Route'));
   htp.p('<TD>');
   IF g_tab_ne_unique.COUNT = 1
    THEN
      htp.formhidden ('pi_route',g_tab_ne_unique(1));
      htp.small (g_tab_ne_unique(1));
   ELSE
      htp.formselectopen (cname => 'pi_route');
      FOR i IN 1..g_tab_ne_unique.COUNT
       LOOP
         htp.p('   <OPTION VALUE="'||g_tab_ne_unique(i)||'">'||g_tab_ne_unique(i)||'</OPTION>');
      END LOOP;
      htp.formselectclose;
   END IF;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader (htf.small('Event Types'));
   htp.p('<TD>');
   htp.tableopen (cattributes=>'BORDER=1');
   htp.tablerowopen;
   SELECT nit_inv_type
         ,nit_descr
    BULK  COLLECT
    INTO  l_tab_nit_inv_type
         ,l_tab_nit_descr
    FROM  nm_inv_types
   WHERE  nit_table_name IS NULL
    AND   nit_elec_drain_carr = c_trid_elec_drain_carr
   ORDER BY nit_inv_type;
   --
   FOR i IN 1..l_tab_nit_inv_type.COUNT
    LOOP
      IF MOD(i,3) = 1
       THEN
         htp.tablerowclose;
         htp.tablerowopen;
      END IF;
      htp.tabledata('<INPUT TYPE=CHECKBOX NAME="pi_nit_inv_type" VALUE="'||l_tab_nit_inv_type(i)||'" CHECKED>'||htf.small(l_tab_nit_descr(i))
                   );
   END LOOP;
   htp.tablerowclose;
   htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=3');
   htp.tablerowclose;
   htp.tableclose;
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
-----------------------------------------------------------------------------
--
PROCEDURE find_inv (pi_route        VARCHAR2
                   ,pi_nit_inv_type VARCHAR2 DEFAULT NULL
                   ) IS
   l_tab_nit_inv_type owa_util.ident_arr;
BEGIN
--
   IF pi_nit_inv_type IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'pi_nit_inv_type'
                    );
   END IF;
--
   l_tab_nit_inv_type(1) := pi_nit_inv_type;
--
   find_inv (pi_route        => pi_route
            ,pi_nit_inv_type => l_tab_nit_inv_type
            );
--
END find_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE find_inv (pi_route        VARCHAR2
                   ,pi_nit_inv_type owa_util.ident_arr
                   ) IS
   l_tab_ne_id        nm3type.tab_number;
   l_tab_ne_unique    nm3type.tab_varchar30;
   l_tab_ne_nt_type   nm3type.tab_varchar30;
--
   l_tab_iit_inv_type nm3type.tab_varchar4;
   l_tab_iit_ne_id    nm3type.tab_number;
--
   l_rec_ngq          nm_gaz_query%ROWTYPE;
   l_rec_ngqt         nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa         nm_gaz_query_attribs%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'find_inv');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   --
   l_rec_ngq.ngq_id                  := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id           := -2; -- Dummy value - can't be -1 ("normal" dummy value) as constraint stops you
   l_rec_ngq.ngq_source              := nm3extent.c_route;
   l_rec_ngq.ngq_open_or_closed      := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area       := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_query_all_items     := 'N';
   l_rec_ngq.ngq_begin_mp            := Null;
   l_rec_ngq.ngq_begin_datum_ne_id   := Null;
   l_rec_ngq.ngq_begin_datum_offset  := Null;
   l_rec_ngq.ngq_end_mp              := Null;
   l_rec_ngq.ngq_end_datum_ne_id     := Null;
   l_rec_ngq.ngq_end_datum_offset    := Null;
   l_rec_ngq.ngq_ambig_sub_class     := Null;
   nm3ins.ins_ngq (l_rec_ngq);
   --
   FOR i IN 1..pi_nit_inv_type.COUNT
    LOOP
      l_rec_ngqt.ngqt_ngq_id         := l_rec_ngq.ngq_id;
      l_rec_ngqt.ngqt_seq_no         := i;
      l_rec_ngqt.ngqt_item_type_type := nm3gaz_qry.c_ngqt_item_type_type_inv;
      l_rec_ngqt.ngqt_item_type      := pi_nit_inv_type(i);
      nm3ins.ins_ngqt (l_rec_ngqt);
      l_rec_ngqa.ngqa_ngq_id         := l_rec_ngqt.ngqt_ngq_id;
      l_rec_ngqa.ngqa_ngqt_seq_no    := l_rec_ngqt.ngqt_seq_no;
      l_rec_ngqa.ngqa_seq_no         := 1;
      l_rec_ngqa.ngqa_attrib_name    := 'IIT_NE_ID';
      l_rec_ngqa.ngqa_operator       := nm3type.c_and_operator;
      l_rec_ngqa.ngqa_pre_bracket    := Null;
      l_rec_ngqa.ngqa_post_bracket   := Null;
      l_rec_ngqa.ngqa_condition      := 'IS NOT NULL';
      nm3ins.ins_ngqa (l_rec_ngqa);
   END LOOP;
   --
   SELECT ne_id
         ,ne_unique
         ,ne_nt_type
    BULK  COLLECT
    INTO  l_tab_ne_id
         ,l_tab_ne_unique
         ,l_tab_ne_nt_type
    FROM  nm_elements
   WHERE  ne_unique LIKE '%'||UPPER(pi_route)||'%';
--    AND   ne_gty_group_type IN (SELECT ngt_group_type
--                                 FROM  nm_group_types
--                                WHERE  ngt_linear_flag = 'Y'
--                               );
   --
   FOR i IN 1..l_tab_ne_id.COUNT
    LOOP
      --
      htp.header (3,l_tab_ne_unique(i)||' ('||l_tab_ne_nt_type(i)||')');
      --
      UPDATE nm_gaz_query
       SET   ngq_source_id = l_tab_ne_id(i)
      WHERE  ngq_id        = l_rec_ngq.ngq_id;
      --
      g_ngqi_job_id := nm3gaz_qry.perform_query
                                    (pi_ngq_id         => l_rec_ngq.ngq_id
                                    ,pi_effective_date => nm3user.get_effective_date
                                    );
      --
      SELECT ngqi_item_type
            ,ngqi_item_id
       BULK  COLLECT
       INTO  l_tab_iit_inv_type
            ,l_tab_iit_ne_id
       FROM  nm_gaz_query_item_list
      WHERE  ngqi_job_id = g_ngqi_job_id
       AND   ROWNUM = 1; -- Just see if there is one there
      --
      IF l_tab_iit_inv_type.COUNT = 0
       THEN
         htp.small (hig.raise_and_catch_ner (pi_appl => nm3type.c_net
                                            ,pi_id   => 318
                                            )
                   );
      ELSE
         dm3query.show_query_in_own_page (p_dq_title => 'TRID_ROUTE_SEARCH');
--         htp.tableopen;
--         FOR i IN 1..l_tab_iit_inv_type.COUNT
--          LOOP
--            htp.tablerowopen;
--            htp.tabledata (l_tab_iit_inv_type(i));
--            htp.tabledata (l_tab_iit_ne_id(i));
--            htp.tablerowclose;
--         END LOOP;
--         htp.tableclose;
         DELETE nm_gaz_query_item_list
         WHERE  ngqi_job_id = g_ngqi_job_id;
      END IF;
      --
   END LOOP;
   --
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'find_inv');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END find_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqi_job_id RETURN NUMBER IS
BEGIN
   RETURN g_ngqi_job_id;
END get_ngqi_job_id;
--
-----------------------------------------------------------------------------
--
--PROCEDURE other IS
--   l_tab_hmo_module      nm3type.tab_varchar30;
--   l_tab_hmo_title       nm3type.tab_varchar80;
----   l_tab_hmo_filename    nm3type.tab_varchar80;
----   l_tab_hmo_module_type nm3type.tab_varchar30;
--   l_tab_hmo_application nm3type.tab_varchar30;
--BEGIN
----
--   nm_debug.proc_start(g_package_name,'other');
----
--   nm3web.module_startup(c_other_module);
----
--   nm3web.head(p_close_head => TRUE
--              ,p_title      => c_other_module_title
--              );
--   sccs_tags;
--   htp.bodyopen;
--   --
--   SELECT hmo_module
--         ,hmo_title
----         ,hmo_filename
----         ,UPPER(hmo_module_type)
--         ,hmo_application
--    BULK  COLLECT
--    INTO  l_tab_hmo_module
--         ,l_tab_hmo_title
----         ,l_tab_hmo_filename
----         ,l_tab_hmo_module_type
--         ,l_tab_hmo_application
--    FROM  hig_modules
--         ,hig_products
--   WHERE  hmo_fastpath_invalid = 'N'
--    AND   is_module_type_supported (UPPER(hmo_module_type)) = nm3type.c_true
--    AND   EXISTS (SELECT 1
--                   FROM  hig_module_roles
--                        ,hig_user_roles
--                  WHERE  hmr_module   = hmo_module
--                   AND   hmr_role     = hur_role
--                   AND   hur_username = USER
--                 )
--    AND   hmo_application = hpr_product
--    AND   hpr_key IS NOT NULL
--   ORDER BY hpr_sequence
--           ,hpr_product
--           ,hmo_title;
--   --
--   htp.formopen(g_package_name||'.run', cattributes => 'NAME="run_module"');
--   htp.tableopen (cattributes=>'BORDER=1');
--   g_checked := c_checked;
--   FOR i IN 1..l_tab_hmo_module.COUNT
--    LOOP
--      IF  i = 1
--       OR l_tab_hmo_application(i) != l_tab_hmo_application(i-1)
--       THEN
--         htp.tablerowopen;
--         htp.tableheader(htf.small(nm3get.get_hpr(pi_hpr_product=>l_tab_hmo_application(i)).hpr_product_name)
--                        ,cattributes => 'COLSPAN=3'
--                        );
--         htp.tablerowclose;
--      END IF;
--      htp.tablerowopen;
--      htp.tableheader('<INPUT TYPE=RADIO NAME="pi_module" VALUE="'||l_tab_hmo_module(i)||'"'||g_checked||'>'
--                     );
--      g_checked := Null;
--      htp.tabledata (htf.small(l_tab_hmo_title(i)));
--      htp.tabledata (htf.small(l_tab_hmo_module(i)));
----      htp.tabledata (htf.small(l_tab_hmo_filename(i)));
----      htp.tabledata (htf.small(l_tab_hmo_module_type(i)));
--      htp.tablerowclose;
--   END LOOP;
--   htp.tableheader(htf.formsubmit (cvalue=>c_continue)
--                  ,cattributes => 'COLSPAN=3'
--                  );
--   htp.formclose;
--   htp.tableclose;
--   --
--   htp.bodyclose;
--   htp.htmlclose;
----
--   nm_debug.proc_end(g_package_name,'other');
----
--EXCEPTION
--  WHEN nm3web.g_you_should_not_be_here THEN NULL;
--  WHEN OTHERS
--   THEN
--     nm3web.failure(SQLERRM);
--END other;
----
-------------------------------------------------------------------------------
----
--FUNCTION is_module_type_supported (pi_module_type VARCHAR2) RETURN VARCHAR2 IS
--BEGIN
--   RETURN nm3flx.boolean_to_char (pi_module_type IN (c_web
--                                 --                   ,c_fmx
--                                                    ,c_dis
--                                                    )
--                                 );
--END is_module_type_supported;
--
-----------------------------------------------------------------------------
--
END xtnz_trid_aor_reporting;
/
