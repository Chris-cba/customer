CREATE OR REPLACE PACKAGE BODY xtnz_lar_mail_merge AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_lar_mail_merge.pkb	1.2 03/16/05
--       Module Name      : xtnz_lar_mail_merge.pkb
--       Date into SCCS   : 05/03/16 01:19:38
--       Date fetched Out : 07/06/06 14:40:28
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   Transit LAR Mail Merge package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000)              := '"@(#)xtnz_lar_mail_merge.pkb	1.2 03/16/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT varchar2(30)                := 'xtnz_lar_mail_merge';
--
   c_this_module       CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0010';
   c_this_module_admin CONSTANT hig_modules.hmo_module%TYPE := 'XTNZWEB0010A';
   c_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
   c_continue          CONSTANT nm_errors.ner_descr%TYPE    := hig.get_ner(nm3type.c_hig,165).ner_descr;
--
   g_select_statement nm3type.max_varchar2;
   g_tab_ita          nm3inv.tab_nita;
--
   c_xtnz  CONSTANT VARCHAR2(4) := 'XTNZ';
--
   c_la       CONSTANT nm_inv_types.nit_inv_type%TYPE := 'LA';
--
   g_checked                         VARCHAR2(8);
   c_checked  CONSTANT               VARCHAR2(8)  := ' CHECKED';
   c_selected CONSTANT               VARCHAR2(9)  := ' SELECTED';
--
   c_checkbox CONSTANT               VARCHAR2(8)  := 'checkbox';
   c_radio    CONSTANT               VARCHAR2(8)  := 'radio';
--
   c_iit           CONSTANT          VARCHAR2(30) := 'NM_INV_ITEMS';
   c_iit_all       CONSTANT          VARCHAR2(30) := c_iit||'_ALL';
   c_doc0120       CONSTANT          hig_modules.hmo_module%TYPE := 'DOC0120';
   c_doc0120_title CONSTANT          hig_modules.hmo_title%TYPE  := nm3get.get_hmo (pi_hmo_module      => c_doc0120
                                                                                   ,pi_raise_not_found => FALSE
                                                                                   ).hmo_title;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_close_window_button (p_do_button BOOLEAN DEFAULT TRUE);
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_data_results_file;
--
-----------------------------------------------------------------------------
--
--FUNCTION get_download_url (p_name VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_user_ok_for_au (pi_nau_admin_unit IN nm_admin_units.nau_admin_unit%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_for_inv_type (pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE);
--
-----------------------------------------------------------------------------
--
FUNCTION get_xll (pi_xll_id    IN xtnz_lar_letters.xll_id%TYPE
                 ) RETURN xtnz_lar_letters%ROWTYPE;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_meta_tags_force_refresh;
--
----------------------------------------------------------------------------------------
--
PROCEDURE create_js_funcs (p_script_open  BOOLEAN DEFAULT TRUE
                          ,p_script_close BOOLEAN DEFAULT TRUE
                          );
--
-----------------------------------------------------------------------------
--
FUNCTION escape_it (p_text VARCHAR2) RETURN VARCHAR2;
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
   htp.p('--       sccsid           : @(#)xtnz_lar_mail_merge.pkb	1.2 03/16/05');
   htp.p('--       Module Name      : xtnz_lar_mail_merge.pkb');
   htp.p('--       Date into SCCS   : 05/03/16 01:19:38');
   htp.p('--       Date fetched Out : 07/06/06 14:40:28');
   htp.p('--       SCCS Version     : 1.2');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Transit LAR Mail Merge package');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2003');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-- Jon');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE main (pi_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE DEFAULT NULL) IS
--
   l_rec_nau            nm_admin_units%ROWTYPE;
--
   l_tab_nau_admin_unit nm3type.tab_number;
   l_tab_nau_unit_code  nm3type.tab_varchar4;
   l_tab_nau_name       nm3type.tab_varchar80;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'main');
--
   nm3web.module_startup(c_this_module);
--
   IF pi_nau_admin_unit IS NOT NULL
    THEN
      check_user_ok_for_au (pi_nau_admin_unit);
      l_rec_nau := nm3get.get_nau (pi_nau_admin_unit => pi_nau_admin_unit);
   ELSE
      SELECT nau_admin_unit
       INTO  l_rec_nau.nau_admin_unit
       FROM  nm_admin_units
            ,nm_inv_types
      WHERE  nau_admin_type = nit_admin_type
       AND   nau_level      = 1
       AND   ROWNUM         = 1
       AND   nit_inv_type   = c_la;
      l_rec_nau := nm3get.get_nau (pi_nau_admin_unit => l_rec_nau.nau_admin_unit);
   END IF;
--
   SELECT nau_admin_unit
         ,nau_unit_code
         ,nau_name
    BULK  COLLECT
    INTO  l_tab_nau_admin_unit
         ,l_tab_nau_unit_code
         ,l_tab_nau_name
    FROM  nm_admin_units
         ,v_nm_user_au_modes
         ,nm_admin_groups
   WHERE  nau_admin_unit        = admin_unit
    AND   nag_child_admin_unit  = nau_admin_unit
    AND   nag_parent_admin_unit = l_rec_nau.nau_admin_unit
    AND   nag_direct_link       = 'Y'
   GROUP BY nau_admin_unit
           ,nau_unit_code
           ,nau_name;
--
   IF l_tab_nau_admin_unit.COUNT = 0
    AND pi_nau_admin_unit IS NULL
    THEN
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 126
                    );
   ELSIF l_tab_nau_admin_unit.COUNT = 0
    THEN
      htp.headopen;
      do_meta_tags_force_refresh;
      htp.headclose;
      get_all_inv_items_by_au (pi_nau_admin_unit   => l_rec_nau.nau_admin_unit
                              ,pi_iit_inv_type     => c_la
                              ,pi_iit_ne_id_parent => Null
                              );
   ELSIF l_tab_nau_admin_unit.COUNT = 1
    THEN
      main (pi_nau_admin_unit => l_tab_nau_admin_unit(1));
   ELSE
--      get_las_by_au (pi_nau_admin_unit => l_tab_nau_admin_unit(1));
--
      nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
      sccs_tags;
      htp.bodyopen;
      htp.tableopen(cattributes=>'BORDER=1');
      htp.tablerowopen;
      htp.tableheader (htf.small('Choose Regional Office'),cattributes=>'COLSPAN=3');
      htp.tablerowclose;
      htp.tablerowopen;
      g_checked := c_checked;
      htp.formopen(g_package_name||'.main', cattributes => 'NAME="main_recursive"');
      htp.tableheader(nm3web.c_nbsp);
      htp.tableheader(htf.small('Code'));
      htp.tableheader(htf.small('Name'));
      htp.tablerowclose;
      FOR i IN 1..l_tab_nau_admin_unit.COUNT
       LOOP
         htp.tablerowopen;
         htp.tabledata('<INPUT TYPE=RADIO NAME="pi_nau_admin_unit" VALUE="'||l_tab_nau_admin_unit(i)||'"'||g_checked||'>'
                      );
         htp.tabledata(htf.small(l_tab_nau_unit_code(i)));
         htp.tabledata(htf.small(l_tab_nau_name(i)));
         g_checked := Null;
         htp.tablerowclose;
      END LOOP;
      htp.tablerowopen;
      htp.tableheader(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN=3');
      htp.tablerowclose;
      htp.tableclose;
      htp.bodyclose;
      htp.htmlclose;
   END IF;
--
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
PROCEDURE get_all_inv_items_by_au (pi_nau_admin_unit   IN nm_admin_units.nau_admin_unit%TYPE
                                  ,pi_iit_inv_type     IN nm_inv_items.iit_inv_type%TYPE
                                  ,pi_iit_ne_id_parent IN nm_inv_items.iit_ne_id%TYPE DEFAULT NULL
                                  ,pi_ngqi_job_id      IN nm_gaz_query_item_list.ngqi_job_id%TYPE DEFAULT NULL
                                  ,pi_checkbox_select  IN BOOLEAN DEFAULT FALSE
                                  ) IS
--
   l_rec_nau            nm_admin_units%ROWTYPE;
   l_rec_nit            nm_inv_types%ROWTYPE;
   l_rec_iit            nm_inv_items%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_all_inv_items_by_au');
--
   nm3web.module_startup(c_this_module);
--
   IF pi_nau_admin_unit IS NOT NULL
    THEN
      check_user_ok_for_au (pi_nau_admin_unit);
      l_rec_nau := nm3get.get_nau (pi_nau_admin_unit => pi_nau_admin_unit);
      nm3web.head(p_close_head => TRUE
                 ,p_title      => c_module_title
                 );
      sccs_tags;
      htp.bodyopen;
   ELSIF pi_iit_ne_id_parent IS NOT NULL
    THEN
      l_rec_iit := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id_parent);
   ELSIF pi_ngqi_job_id IS NOT NULL
    THEN
      Null;
   END IF;
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type   => pi_iit_inv_type);
   instantiate_for_inv_type (pi_iit_inv_type);
--
   htp.tableopen (cattributes=>'BORDER=1');
   IF pi_checkbox_select
    THEN
      -- This is the final stage of selection before a leter is being done
      htp.formopen(g_package_name||'.put_rows_into_table', cattributes => 'NAME="show_single_inv_item_details"');
      htp.formhidden (cname => 'pi_xll_id',cvalue=> g_xll_id);
   ELSE
      htp.formopen(g_package_name||'.show_single_inv_item_details', cattributes => 'NAME="show_single_inv_item_details"');
   END IF;
   htp.tablerowopen;
   IF pi_nau_admin_unit IS NOT NULL
    THEN
      htp.tableheader(htf.small(l_rec_nit.nit_descr||' in '||l_rec_nau.nau_name),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
   ELSIF pi_iit_ne_id_parent IS NOT NULL
    THEN
      htp.tableheader(htf.small(l_rec_nit.nit_descr||' associated with '||l_rec_iit.iit_primary_key),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
   ELSIF pi_ngqi_job_id IS NOT NULL
    THEN
      htp.tableheader(htf.small('Matching records'),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
   END IF;
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tabledata(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader (nm3web.c_nbsp);
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
      l_input_type  VARCHAR2(30);
      PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
      BEGIN
         nm3tab_varchar.append (l_block,p_text,p_nl);
      END append;
   BEGIN
      l_input_type := nm3flx.i_t_e (pi_checkbox_select
                                   ,'CHECKBOX'
                                   ,'RADIO'
                                   );
      g_some_found := FALSE;
      append ('DECLARE',FALSE);
      append ('   CURSOR cs_inv_data (c_val NUMBER) IS');
      append (g_select_statement);
      IF  pi_nau_admin_unit IS NOT NULL
       THEN
         append (' AND iit_admin_unit = c_val;');
      ELSIF pi_iit_ne_id_parent IS NOT NULL
       THEN
         append (' AND iit_ne_id IN (SELECT iig_item_id');
         append ('                    FROM  nm_inv_item_groupings');
         append ('                   WHERE  iig_parent_id = c_val');
         append ('                  );');
      ELSIF pi_ngqi_job_id IS NOT NULL
       THEN
         append (' AND iit_ne_id IN (SELECT ngqi_item_id');
         append ('                    FROM  nm_gaz_query_item_list');
         append ('                   WHERE  ngqi_job_id = c_val');
         append ('                  );');
      END IF;
      append ('  l_checked VARCHAR2(8) := '||nm3flx.string(' CHECKED')||';');
--      append ('  l_display VARCHAR2(4000);');
      append ('BEGIN');
      append ('   FOR cs_rec IN cs_inv_data ('||NVL(pi_nau_admin_unit,NVL(pi_iit_ne_id_parent,pi_ngqi_job_id))||')');
      append ('    LOOP');
      append ('      '||g_package_name||'.g_some_found := TRUE;');
      append ('      htp.tabledata('||nm3flx.string('<INPUT TYPE='||l_input_type||' NAME="pi_iit_ne_id" VALUE="')||'||cs_rec.iit_ne_id||'||nm3flx.string('"')||'||l_checked||'||nm3flx.string('>')||');');
      IF NOT pi_checkbox_select
       THEN
         append ('      l_checked := Null;');
      END IF;
      FOR i IN 1..g_tab_ita.COUNT
       LOOP
--         IF g_tab_ita(i).ita_format_mask IS NOT NULL
--          THEN
--            l_pre_format  := 'TO_CHAR(';
--            l_post_format := ','||nm3flx.string(g_tab_ita(i).ita_format_mask)||')';
--         ELSIF g_tab_ita(i).ita_format = nm3type.c_date
--          THEN
--            l_pre_format  := 'TO_CHAR(';
--            l_post_format := ','||nm3flx.string(nm3user.get_user_date_mask)||')';
--         ELSE
--            l_pre_format  := Null;
--            l_post_format := Null;
--         END IF;
--         append ('      IF cs_rec.'||g_tab_ita(i).ita_attrib_name||' IS NULL');
--         append ('       THEN');
--         append ('         l_display := nm3web.c_nbsp;');
--         append ('      ELSE');
--         append ('         l_display := htf.small('||l_pre_format||'cs_rec.'||g_tab_ita(i).ita_attrib_name||l_post_format||');');
--         append ('      END IF;');
--         append ('      htp.tabledata (l_display);');
         append ('      htp.tabledata (nm3flx.i_t_e(cs_rec.'||g_tab_ita(i).ita_attrib_name||' IS NULL,nm3web.c_nbsp,htf.small(cs_rec.'||g_tab_ita(i).ita_attrib_name||')));');
      END LOOP;
      append ('      htp.tablerowclose;');
      append ('      htp.tablerowopen;');
      append ('   END LOOP;');
      append ('END;');
--      nm_debug.delete_debug(TRUE);
--      nm_debug.debug_on;
--      nm3tab_varchar.debug_tab_varchar (l_block);
--      nm_debug.debug_off;
      nm3ddl.execute_tab_varchar(l_block);
   END;
   --
   IF NOT g_some_found
    THEN
      htp.tablerowopen;
      htp.tableheader(htf.small(hig.raise_and_catch_ner(nm3type.c_net,318)),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
      htp.tablerowclose;
      htp.tablerowopen;
   END IF;
   htp.tabledata(htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN='||(g_tab_ita.COUNT+1));
   htp.formclose;
   htp.tablerowclose;
   htp.tableclose;
--
   IF pi_nau_admin_unit IS NOT NULL
    THEN
      htp.bodyclose;
      htp.htmlclose;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_all_inv_items_by_au');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END get_all_inv_items_by_au;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_single_inv_item_details (pi_iit_ne_id      nm_inv_items.iit_ne_id%TYPE DEFAULT NULL
                                       ,pi_prevent_update BOOLEAN DEFAULT FALSE
                                       ) IS
--
   l_rec_iit                      nm_inv_items%ROWTYPE;
   l_tab_rec_inv_flex_col_details nm3asset.tab_rec_inv_flex_col_details;
   l_tab_rec_datum_loc_dets       nm3asset.tab_rec_datum_loc_dets;
   l_tab_rec_route_loc_dets       nm3route_ref.tab_rec_route_loc_dets;
   l_rec_nit                      nm_inv_types%ROWTYPE;
--
   l_tab_xll_id          nm3type.tab_number;
   l_tab_xll_description nm3type.tab_varchar80;
--
   l_rec_hmo             hig_modules%ROWTYPE;
   l_module_mode         hig_module_roles.hmr_mode%TYPE;
   l_update_allowed      BOOLEAN := FALSE;
   l_prevent_update      BOOLEAN := pi_prevent_update;
--
   l_value               nm3type.max_varchar2;
   l_meaning             nm3type.max_varchar2;
   l_descr               nm3type.max_varchar2;
   l_cur                 nm3type.ref_cursor;
   l_selected            VARCHAR2(10);
   l_rec_ita             nm_inv_type_attribs%ROWTYPE;
   l_colspan             NUMBER;
--
   l_this_is_a_trid_item BOOLEAN;
--
   PROCEDURE add_detail_trio (p_header VARCHAR2, p_meaning VARCHAR2, p_descr VARCHAR2, p_header_bold BOOLEAN DEFAULT TRUE) IS
   BEGIN
      htp.tablerowopen;
      IF p_header_bold
       THEN
         htp.tableheader(htf.small(NVL(p_header,nm3web.c_nbsp)));
      ELSE
         htp.tabledata(htf.small(NVL(p_header,nm3web.c_nbsp)));
      END IF;
      htp.tabledata(htf.small(NVL(p_meaning,nm3web.c_nbsp)));
      htp.tabledata(htf.small(NVL(p_descr,nm3web.c_nbsp)));
      htp.tablerowclose;
   END add_detail_trio;
--
   PROCEDURE add_detail_pair (p_header VARCHAR2, p_meaning VARCHAR2, p_header_bold BOOLEAN DEFAULT TRUE) IS
   BEGIN
      htp.tablerowopen;
      IF p_header_bold
       THEN
         htp.tableheader(htf.small(NVL(p_header,nm3web.c_nbsp)));
      ELSE
         htp.tabledata(htf.small(NVL(p_header,nm3web.c_nbsp)));
      END IF;
      htp.tabledata(htf.small(NVL(p_meaning,nm3web.c_nbsp)));
      htp.tablerowclose;
   END add_detail_pair;
   FUNCTION we_want_this_item (p_item VARCHAR2) RETURN BOOLEAN IS
      l_retval BOOLEAN;
   BEGIN
      IF l_this_is_a_trid_item
       THEN
         l_retval := TRUE;
      ELSE -- LAR
         IF p_item IN ('IIT_DESCR','IIT_NOTE','IIT_START_DATE')
          THEN
            l_retval := FALSE;
         ELSIF p_item = 'IIT_END_DATE'
          AND  NOT xtnz_trid.user_has_normal_module_access (c_this_module_admin)
          THEN
            l_retval := FALSE;
         ELSE
            l_retval := TRUE;
         END IF;
      END IF;
      RETURN l_retval;
   END we_want_this_item;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_single_inv_item_details');
--
   nm3web.module_startup(c_this_module);
--
   hig.get_module_details (pi_module => c_this_module
                          ,po_hmo    => l_rec_hmo
                          ,po_mode   => l_module_mode
                          );
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_module_title||'(G'||CHR(39)||'Day)'
               );
   do_meta_tags_force_refresh;
   create_js_funcs;
   htp.headclose;
   sccs_tags;
   htp.bodyopen;
--   htp.p(htf.small(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')));
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
   -- get it from iit_all
   l_rec_iit := nm3get.get_iit_all (pi_iit_ne_id    => pi_iit_ne_id);
   -- check that it is in NM_INV_ITEMS, then we can prevent update if not.
   --  the only time we should get this is when the user sets the end-date via this
   IF NOT l_prevent_update
    AND   nm3get.get_iit (pi_iit_ne_id       => pi_iit_ne_id
                         ,pi_raise_not_found => FALSE
                         ).iit_ne_id IS NULL
    THEN
      l_prevent_update := TRUE;
   END IF;
   l_rec_nit := nm3get.get_nit     (pi_nit_inv_type => l_rec_iit.iit_inv_type);
--
   IF   NOT l_prevent_update
    AND l_module_mode = nm3type.c_normal
    AND l_rec_nit.nit_table_name IS NULL
    AND invsec.is_inv_item_updatable (p_iit_inv_type           => l_rec_nit.nit_inv_type
                                     ,p_iit_admin_unit         => l_rec_iit.iit_admin_unit
                                     ,pi_unrestricted_override => FALSE
                                     )
    THEN
      l_update_allowed := TRUE;
   END IF;
--
   SELECT xll_id
         ,xll_description
    BULK  COLLECT
    INTO  l_tab_xll_id
         ,l_tab_xll_description
    FROM  xtnz_lar_letters
   WHERE  xll_inv_type = l_rec_iit.iit_inv_type
   ORDER BY xll_id;
--
   IF l_tab_xll_id.COUNT > 0
    THEN
      htp.formopen(g_package_name||'.do_letter', cattributes => 'NAME="do_letter"');
      htp.tableopen (cattributes=>'BORDER=1');
      htp.tablerowopen;
      htp.tableheader (htf.small('Select letter'),cattributes=>'COLSPAN='||nm3flx.i_t_e(l_tab_xll_id.COUNT>1,'4','2'));
      htp.tablerowclose;
      g_checked := c_checked;
      htp.tablerowopen;
      FOR i IN 1..l_tab_xll_id.COUNT
       LOOP
         htp.tabledata('<INPUT TYPE=RADIO NAME="pi_xll_id" VALUE="'||l_tab_xll_id(i)||'"'||g_checked||'>'
                      );
         htp.tabledata(htf.small(l_tab_xll_description(i)));
         g_checked := Null;
         IF MOD (i,2) = 0
          THEN
           htp.tablerowclose;
           htp.tablerowopen;
         END IF;
      END LOOP;
      IF l_tab_xll_id.COUNT > 1
       AND MOD (l_tab_xll_id.COUNT,2) = 1
       THEN
         htp.tabledata(nm3web.c_nbsp);
         htp.tabledata(nm3web.c_nbsp);
      END IF;
      htp.tablerowopen;
      htp.tableheader(htf.formhidden ('pi_iit_ne_id',pi_iit_ne_id)||htf.formsubmit (cvalue=>c_continue),cattributes=>'COLSPAN='||nm3flx.i_t_e(l_tab_xll_id.COUNT>1,'4','2'));
      htp.formclose;
      htp.tablerowclose;
      htp.tableclose;
--   ELSE
--      htp.small ('No letters available for inventory type '||l_rec_iit.iit_inv_type||'.');
   END IF;
   htp.hr (cattributes=>'WIDTH=75%');
--
   DECLARE
      l_tab_child_type nm3type.tab_varchar4;
      l_tab_child_desc nm3type.tab_varchar80;
   BEGIN
--
      SELECT itg_inv_type
            ,nit_descr
       BULK  COLLECT
       INTO  l_tab_child_type
            ,l_tab_child_desc
       FROM  nm_inv_type_groupings
            ,nm_inv_types
      WHERE  itg_parent_inv_type = l_rec_iit.iit_inv_type
       AND   itg_inv_type        = nit_inv_type;
--
      FOR i IN 1..l_tab_child_type.COUNT
       LOOP
         get_all_inv_items_by_au (pi_nau_admin_unit   => Null
                                 ,pi_iit_inv_type     => l_tab_child_type(i)
                                 ,pi_iit_ne_id_parent => l_rec_iit.iit_ne_id
                                 );
         htp.hr (cattributes=>'WIDTH=75%');
      END LOOP;
--
      IF   l_update_allowed
       AND l_tab_child_type.COUNT > 0
       THEN
         htp.tableopen (cattributes=>'BORDER=1');
         htp.formopen('xtnz_lar_create_inv.enter_data', cattributes => 'NAME="create_child"');
         htp.formhidden ('p_module',c_this_module);
         htp.formhidden ('p_module_title',c_module_title);
         htp.formhidden ('p_iit_foreign_key',l_rec_iit.iit_primary_key);
         g_checked := c_checked;
         IF l_tab_child_type.COUNT = 1
          THEN
            htp.formhidden ('p_inv_type',l_tab_child_type(1));
            htp.tablerowopen;
            htp.tableheader(htf.formsubmit(cvalue=>'Create '||l_tab_child_desc(1)), cattributes=>'COLSPAN=2');
            htp.tablerowclose;
         ELSE
            FOR i IN 1..l_tab_child_type.COUNT
             LOOP
               htp.tablerowopen;
               htp.tabledata('<INPUT TYPE=RADIO NAME="p_inv_type" VALUE="'||l_tab_child_type(i)||'"'||g_checked||'>'
                            );
               htp.tabledata (htf.small(l_tab_child_desc(i)));
               g_checked := Null;
               htp.tablerowclose;
            END LOOP;
            htp.tablerowopen;
            htp.tableheader(htf.formsubmit(cvalue=>'Create Child Item'), cattributes=>'COLSPAN=2');
            htp.tablerowclose;
         END IF;
         htp.formclose;
         htp.tableclose;
         htp.hr (cattributes=>'WIDTH=75%');
      END IF;
--
   END;
--
--   htp.p(l_rec_iit.iit_primary_key||' selected');
--
   nm3asset.get_inv_flex_col_details       (pi_iit_ne_id           => pi_iit_ne_id
                                           ,pi_nit_inv_type        => l_rec_iit.iit_inv_type
                                           ,pi_display_xsp_if_reqd => TRUE
                                           ,po_flex_col_dets       => l_tab_rec_inv_flex_col_details
                                           );
--
   l_this_is_a_trid_item := xtnz_trid.this_is_a_trid_item(l_rec_nit.nit_elec_drain_carr);
--
--   nm3asset.get_inv_datum_location_details (pi_iit_ne_id          => pi_iit_ne_id
--                                           ,pi_nit_inv_type       => l_rec_iit.iit_inv_type
--                                           ,po_tab_datum_loc_dets => l_tab_rec_datum_loc_dets
--                                           );
--
   nm3asset.get_inv_route_location_details (pi_iit_ne_id          => pi_iit_ne_id
                                           ,pi_nit_inv_type       => l_rec_iit.iit_inv_type
                                           ,po_tab_route_loc_dets => l_tab_rec_route_loc_dets
                                           );
--
   htp.tableopen (cattributes=>'BORDER=1');
   htp.tablerowopen;
   IF nm3user.user_can_run_module(p_module => c_doc0120)
    THEN
      htp.tabledata (cvalue      => '<input type="button" value="'||c_doc0120_title||'" onClick="popUp('||nm3flx.string(g_package_name||'.view_associated_documents?pi_iit_ne_id='||pi_iit_ne_id||CHR(38)||'pi_prevent_update='||nm3flx.boolean_to_char(pi_prevent_update))||');">'
                    ,cattributes => 'ALIGN=CENTER VALIGN=MIDDLE'
                    );
   END IF;
   IF NOT l_this_is_a_trid_item
    THEN -- do not bring out for TRID items
      DECLARE
         l_url  nm3type.max_varchar2;
      BEGIN
         l_url  := xtnz_trid.get_map_item_url_url_only
                                              (pi_iit_ne_id    => l_rec_iit.iit_primary_key
                                              ,pi_iit_inv_type => l_rec_iit.iit_inv_type
                                              );
         IF l_url IS NOT NULL
          THEN
            --l_url := escape_it (l_url);
            htp.tabledata (cvalue      => '<input type="button" value="Map" onClick="popUp('||nm3flx.string(l_url)||');">'
                          ,cattributes => 'ALIGN=CENTER VALIGN=MIDDLE'
                          );
         END IF;
      END;
   END IF;
   htp.tablerowclose;
   htp.tableclose;

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
--
   htp.tablerowopen;
   htp.tableheader(htf.small(l_rec_nit.nit_descr||' : '||nm3flx.i_t_e(l_update_allowed,'Update is Allowed','Read Only')),cattributes=>'COLSPAN='||l_colspan);
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.tableheader(htf.small('Attributes'));
   IF l_tab_rec_datum_loc_dets.COUNT > 0
    THEN
      htp.tableheader(htf.small('Datum Location'));
   END IF;
   IF l_tab_rec_route_loc_dets.COUNT > 0
    THEN
      htp.tableheader(htf.small('Route Location'));
   END IF;
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TD VALIGN=TOP>');
      htp.tableopen (cattributes=>'BORDER=1');
      IF l_update_allowed
       THEN
--
         htp.formopen(g_package_name||'.update_item');
         FOR i IN 1..l_tab_rec_inv_flex_col_details.COUNT
          LOOP
            IF we_want_this_item (l_tab_rec_inv_flex_col_details(i).ita_attrib_name)
             THEN
               xtnz_lar_create_inv.translate_some_screen_text (l_tab_rec_inv_flex_col_details(i).ita_scrn_text);
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
               htp.formhidden (cname  => 'iit_admin_unit'
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
                  htp.tableheader (htf.small (l_tab_rec_inv_flex_col_details(i).ita_scrn_text||htf.sup(l_tab_rec_inv_flex_col_details(i).ita_mandatory_asterisk)
                                  -- ||'('||l_tab_rec_inv_flex_col_details(i).iit_value_orig||')'
                                   ));
                  htp.p('<TD>');
                  IF l_tab_rec_inv_flex_col_details(i).iit_lov_sql IS NOT NULL
                   THEN
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
                         AND NOT l_this_is_a_trid_item
                         THEN
                           htp.p('   <OPTION VALUE="'||l_value||'"'||l_selected||'>'||l_meaning||' - '||l_descr||'</OPTION>');
                        ELSE
                           htp.p('   <OPTION VALUE="'||l_value||'"'||l_selected||'>'||l_descr||'</OPTION>');
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
                                     ,cattributes => 'WRAP=VIRTUAL'
                                     );
                        htp.p(l_tab_rec_inv_flex_col_details(i).iit_value_orig);
                        htp.formtextareaclose;
                     ELSE
                        htp.formtext (cname      => 'iit_value'
                                     ,cvalue     => l_tab_rec_inv_flex_col_details(i).iit_value_orig
                                     ,csize      => nm3flx.i_t_e (l_rec_ita.ita_format = nm3type.c_date
                                                                 ,Null
                                                                 ,l_rec_ita.ita_fld_length+15
                                                                 )
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
            END IF;
         END LOOP;
         htp.tablerowopen;
         htp.tableheader (htf.formsubmit(cvalue=>'Update'),cattributes=>'COLSPAN=3');
         htp.tablerowclose;
         htp.formclose;
      ELSE
         FOR i IN 1..l_tab_rec_inv_flex_col_details.COUNT
          LOOP
            IF we_want_this_item (l_tab_rec_inv_flex_col_details(i).ita_attrib_name)
             THEN
               xtnz_lar_create_inv.translate_some_screen_text (l_tab_rec_inv_flex_col_details(i).ita_scrn_text);
               add_detail_trio (l_tab_rec_inv_flex_col_details(i).ita_scrn_text
                               ,l_tab_rec_inv_flex_col_details(i).iit_meaning
                               ,l_tab_rec_inv_flex_col_details(i).iit_description
                               );
            END IF;
         END LOOP;
      END IF;
      htp.tableclose;
   htp.p('</TD>');
   IF l_tab_rec_datum_loc_dets.COUNT > 0
    THEN
      htp.p('<TD VALIGN=TOP>');
         htp.tableopen (cattributes=>'BORDER=1');
         htp.tablerowopen;
         htp.tableheader(htf.small('Unique'));
         IF l_rec_nit.nit_pnt_or_cont = 'P'
          THEN
            htp.tableheader(htf.small('MP'));
         ELSE
            htp.tableheader(htf.small('Begin MP'));
            htp.tableheader(htf.small('End MP'));
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
         htp.tableheader(htf.small('Route'));
         IF l_rec_nit.nit_pnt_or_cont = 'P'
          THEN
            htp.tableheader(htf.small('Route Position'));
         ELSE
            htp.tableheader(htf.small('Start Route Position'));
            htp.tableheader(htf.small('End Route Position'));
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
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'show_single_inv_item_details');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END show_single_inv_item_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_for_inv_type (pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE) IS
BEGIN
   g_select_statement := Null;
   g_tab_ita := nm3inv.get_tab_ita (p_inv_type => pi_nit_inv_type);
   g_select_statement := 'SELECT iit_ne_id';
   FOR i IN 1..g_tab_ita.COUNT
    LOOP
      g_select_statement := g_select_statement
                               ||CHR(10)||' ,nm3inv.validate_flex_inv(iit_inv_type,'||nm3flx.string(g_tab_ita(i).ita_attrib_name)||','||g_tab_ita(i).ita_attrib_name||') '||g_tab_ita(i).ita_attrib_name;
   END LOOP;
   g_select_statement := g_select_statement
                            ||CHR(10)||' FROM nm_inv_items'
                            ||CHR(10)||'WHERE iit_inv_type = '||nm3flx.string(pi_nit_inv_type);
END instantiate_for_inv_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_user_ok_for_au (pi_nau_admin_unit IN nm_admin_units.nau_admin_unit%TYPE) IS
   l_mode nm_user_aus.nua_mode%TYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_user_ok_for_au');
--
   l_mode := nm3ausec.get_au_mode
                       (pi_user_id => nm3user.get_user_id
                       ,pi_au      => pi_nau_admin_unit
                       );
--
   nm_debug.proc_end(g_package_name,'check_user_ok_for_au');
--
END check_user_ok_for_au;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_letter (pi_xll_id    IN xtnz_lar_letters.xll_id%TYPE
                    ,pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE
                    ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_rec_xll xtnz_lar_letters%ROWTYPE;
   l_rec_iit nm_inv_items%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'do_letter');
--
   nm3web.module_startup(c_this_module);
--
   l_rec_xll := get_xll        (pi_xll_id    => pi_xll_id);
   g_xll_id  := l_rec_xll.xll_id;
--
   IF l_rec_xll.xll_multi_select_child_type IS NOT NULL
    AND pi_iit_ne_id IS NOT NULL
    THEN
--
      nm3web.head(p_close_head => TRUE
                 ,p_title      => c_module_title
                 );
      sccs_tags;
      htp.bodyopen;
      get_all_inv_items_by_au (pi_nau_admin_unit   => Null
                              ,pi_iit_inv_type     => l_rec_xll.xll_multi_select_child_type
                              ,pi_iit_ne_id_parent => pi_iit_ne_id
                              ,pi_checkbox_select  => TRUE
                              );
      htp.bodyclose;
      htp.htmlclose;
   ELSIF pi_iit_ne_id IS NOT NULL
    THEN
      l_rec_iit   := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id);
      g_iit_ne_id := pi_iit_ne_id;
      put_rows_into_table (g_xll_id, pi_iit_ne_id);
   ELSE
   --
      g_csv_filename     := RTRIM(UPPER(l_rec_xll.xll_nuf_name),'.DOC')||'.DATA';
--
      nm3web.head(p_close_head => FALSE
                 ,p_title      => c_module_title
                 );
--      htp.p('<script language="JavaScript" type="text/javascript"> ');
--      htp.p('');
--      htp.p('<!--');
--      htp.p('');
--      htp.p('var tgt = null; ');
--      htp.p('function saveURLAs (url, c_count) { ');
--      htp.p('if (!document.execCommand) { ');
--      htp.p('alert("Sorry.Your browser doesnt support this action."); return; ');
--      htp.p('} ');
----      htp.p('alert ("dummy"+c_count);');
--      htp.p('tgt = document.frames["'||g_csv_filename||'"'||chr(38)||'c_count];');
--      htp.p('tgt.location = url; ');
--      htp.p('setTimeout('||nm3flx.string('tgt.document.execCommand("SaveAs")')||', 50); ');
--      htp.p(' return(false);');
--      htp.p('} ');
--      htp.p('');
--      htp.p('function downloadfiles(filelist)');
--      htp.p('{');
--      htp.p(' var files = filelist.split(",");');
--      htp.p(' for ( var i=0; i<files.length; i++ )');
----      htp.p('   window.open( files[i], "file"+i );');
--      htp.p('   saveURLAs( files[i], i+1 );');
--      htp.p('');
--      htp.p(' return(false);');
--      htp.p('}');
--      htp.p('');
--      htp.p('//-->');
--      htp.p('');
--      htp.p('</script> ');
      do_meta_tags_force_refresh;
      htp.headclose;
      sccs_tags;
      htp.bodyopen;
   --
      g_xll_dq_id        := l_rec_xll.xll_dq_id;
      build_data_results_file;
--
      htp.small(  hig.get_ner (c_xtnz,1).ner_descr
                ||htf.anchor (nm3web.get_download_url (g_csv_filename),l_rec_xll.xll_description||' Data')
                ||hig.get_ner (c_xtnz,2).ner_descr
               );
      htp.br;
      htp.br;
      htp.small(  hig.get_ner (c_xtnz,3).ner_descr
                ||htf.anchor (nm3web.get_download_url (l_rec_xll.xll_nuf_name),l_rec_xll.xll_description)
                ||hig.get_ner (c_xtnz,4).ner_descr
                ||hig.get_ner (c_xtnz,5).ner_descr
               );
 --     owa_util.print_cgi_env;
--      htp.p('<A HREF="javascript&#58; void 0" ');
--      htp.p('ONCLICK="saveURLAs('||nm3flx.string(nm3web.get_download_url (g_csv_filename))||'); return false">'||htf.small(l_rec_xll.xll_description||' Data')||'</A> ');
--      htp.br;
      UPDATE nm_upload_files
       SET   mime_type = 'text/plain'
      WHERE  name = l_rec_xll.xll_nuf_name
       AND   mime_type != 'text/plain';
----      htp.small(htf.anchor (nm3web.get_download_url (l_rec_xll.xll_nuf_name),l_rec_xll.xll_description));
--      htp.p('<A HREF="javascript&#58; void 0" ');
--      htp.p('ONCLICK="saveURLAs('||nm3flx.string(nm3web.get_download_url (l_rec_xll.xll_nuf_name))||'); return false">'||htf.small(l_rec_xll.xll_description)||'</A> ');
--      htp.p('<A HREF="#" onClick="return(downloadfiles('||nm3flx.string(nm3web.get_download_url (g_csv_filename)||','||nm3web.get_download_url (l_rec_xll.xll_nuf_name))||'));">Download</a>');
--      htp.p('<IFRAME NAME="'||g_csv_filename||'1" WIDTH="0" HEIGHT="0"></IFRAME> ');
--      htp.p('<IFRAME NAME="'||g_csv_filename||'2" WIDTH="0" HEIGHT="0"></IFRAME> ');
   --
      htp.bodyclose;
      htp.htmlclose;
   END IF;
--
   nm_debug.proc_end(g_package_name,'do_letter');
--
   COMMIT;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END do_letter;
--
-----------------------------------------------------------------------------
--
--FUNCTION get_download_url (p_name VARCHAR2) RETURN VARCHAR2 IS
--BEGIN
--   RETURN g_data_dad_config||p_name;
--END get_download_url;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xll (pi_xll_id    IN xtnz_lar_letters.xll_id%TYPE
                 ) RETURN xtnz_lar_letters%ROWTYPE IS
   CURSOR cs_xll (c_xll_id xtnz_lar_letters.xll_id%TYPE) IS
   SELECT *
    FROM  xtnz_lar_letters
   WHERE  xll_id = c_xll_id;
   l_rec_xll xtnz_lar_letters%ROWTYPE;
   l_found   BOOLEAN;
BEGIN
--
   OPEN  cs_xll (pi_xll_id);
   FETCH cs_xll INTO l_rec_xll;
   l_found := cs_xll%FOUND;
   CLOSE cs_xll;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'xtnz_lar_letters.xll_id='||pi_xll_id
                    );
   END IF;
--
   RETURN l_rec_xll;
--
END get_xll;
--
-----------------------------------------------------------------------------
--
FUNCTION get_iit_ne_id RETURN nm_inv_items.iit_ne_id%TYPE IS
BEGIN
   RETURN g_iit_ne_id;
END get_iit_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xll_id RETURN xtnz_lar_letters.xll_id%TYPE IS
BEGIN
   RETURN g_xll_id;
END get_xll_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_data_results_file IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_tab_results           nm3type.tab_varchar32767;
   c_mime_type    CONSTANT VARCHAR2(24) := 'application/unknown';
-- c_mime_type    CONSTANT VARCHAR2(24) := 'text/html';
   c_sysdate      CONSTANT DATE         := SYSDATE;
   c_content_type CONSTANT VARCHAR2(4)  := 'BLOB';
   c_dad_charset  CONSTANT VARCHAR2(5)  := 'ascii';
   l_doc_size              NUMBER       := 0;
   l_rec_xluf xtnz_lar_upload_files%ROWTYPE;
--
BEGIN
--
   DELETE FROM xtnz_lar_upload_files
   WHERE  name       = g_csv_filename
    AND   username   = USER;
----
   l_tab_results := dm3query.execute_query_tab (g_xll_dq_id);
--
   FOR i IN 1..l_tab_results.COUNT
    LOOP
      l_tab_results(i) := l_tab_results(i)||CHR(10);
      l_doc_size := l_doc_size + LENGTH (l_tab_results(i));
   END LOOP;
--
   l_rec_xluf.name         := g_csv_filename;
   l_rec_xluf.username     := USER;
   l_rec_xluf.mime_type    := c_mime_type;
   l_rec_xluf.doc_size     := l_doc_size;
   l_rec_xluf.dad_charset  := c_dad_charset;
   l_rec_xluf.last_updated := c_sysdate;
   l_rec_xluf.content_type := c_content_type;
   l_rec_xluf.blob_content := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (l_tab_results));

   INSERT INTO xtnz_lar_upload_files
          (name
          ,username
          ,mime_type
          ,doc_size
          ,dad_charset
          ,last_updated
          ,content_type
          ,blob_content
          )
   VALUES (l_rec_xluf.name
          ,l_rec_xluf.username
          ,l_rec_xluf.mime_type
          ,l_rec_xluf.doc_size
          ,l_rec_xluf.dad_charset
          ,l_rec_xluf.last_updated
          ,l_rec_xluf.content_type
          ,l_rec_xluf.blob_content
          );
--
   COMMIT;
--
END build_data_results_file;
--
----------------------------------------------------------------------------------------
--
FUNCTION getfilepath RETURN VARCHAR2 IS
BEGIN
   RETURN SUBSTR(owa_util.get_cgi_env(param_name => 'PATH_INFO'),2);
END getfilepath;
--
----------------------------------------------------------------------------------------
--
PROCEDURE process_download IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   c_file_path  CONSTANT nm3type.max_varchar2 := getfilepath;
   l_file_path           nm3type.max_varchar2;
--
   CURSOR cs_xlauf (c_name VARCHAR2) IS
   SELECT ROWID
    FROM  xtnz_lar_upload_files_v
   WHERE  name = c_name;
--
   l_rowid ROWID;
   l_found BOOLEAN;
--
begin
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--nm_debug.debug(c_file_path);
--
   OPEN  cs_xlauf (c_file_path);
   FETCH cs_xlauf
    INTO l_rowid;
   l_found := cs_xlauf%FOUND;
   CLOSE cs_xlauf;
--
   IF l_found
    THEN
      l_file_path := USER||'.'||c_file_path;
      nm3del.del_nuf (pi_name            => l_file_path
                     ,pi_raise_not_found => FALSE
                     );
      INSERT INTO nm_upload_files
            (name
            ,mime_type
            ,doc_size
            ,dad_charset
            ,last_updated
            ,content_type
            ,blob_content
            )
      SELECT l_file_path
            ,mime_type
            ,doc_size
            ,dad_charset
            ,last_updated
            ,content_type
            ,blob_content
       FROM  xtnz_lar_upload_files_v
      WHERE  ROWID = l_rowid;
--    nm_debug.debug('inserted nuf');
   ELSE
      l_file_path := c_file_path;
   END IF;
--
--    nm_debug.debug('call nm3web.process_download');
   nm3web.process_download(pi_name => l_file_path);
--   nm_debug.debug('Done');
--
   COMMIT;
--
END process_download;
--
----------------------------------------------------------------------------------------
--
PROCEDURE put_rows_into_table (pi_xll_id    NUMBER
                              ,pi_iit_ne_id NUMBER DEFAULT NULL
                              ) IS
   l_array owa_util.ident_arr;
BEGIN
   IF pi_iit_ne_id IS NOT NULL
    THEN
      l_array(1) := pi_iit_ne_id;
      put_rows_into_table (pi_xll_id    => pi_xll_id
                          ,pi_iit_ne_id => l_array
                          );
   END IF;
END put_rows_into_table;
--
----------------------------------------------------------------------------------------
--
PROCEDURE put_rows_into_table (pi_xll_id    NUMBER
                              ,pi_iit_ne_id owa_util.ident_arr DEFAULT nm3web.g_empty_ident_arr
                              ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   x       PLS_INTEGER;
   l_array nm3type.tab_number;
BEGIN
--
   x := pi_iit_ne_id.FIRST;
   WHILE x IS NOT NULL
    LOOP
      l_array(l_array.COUNT+1) := pi_iit_ne_id(x);
      x := pi_iit_ne_id.NEXT(x);
   END LOOP;
--
   DELETE FROM xtnz_lar_letters_inv_v;
--
   FORALL i IN 1..l_array.COUNT
      INSERT INTO xtnz_lar_letters_inv (xlli_username,xlli_iit_ne_id)
      VALUES (USER,l_array(i));
--
   COMMIT;
--
   do_letter (pi_xll_id,Null);
--
END put_rows_into_table;
--
----------------------------------------------------------------------------------------
--
PROCEDURE update_item (ita_attrib_name    owa_util.ident_arr
                      ,iit_value_orig     owa_util.vc_arr
                      ,iit_value          owa_util.vc_arr
                      ,iit_ne_id          owa_util.ident_arr
                      ,nit_update_allowed owa_util.ident_arr
                      ,ita_format         owa_util.ident_arr
                      ,ita_format_mask    owa_util.ident_arr
                      ,iit_inv_type       owa_util.ident_arr
                      ,iit_start_date     owa_util.ident_arr
                      ,iit_date_modified  owa_util.ident_arr
                      ,iit_admin_unit     owa_util.ident_arr
                      ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_tab_rec_inv_flex_col_details nm3asset.tab_rec_inv_flex_col_details;
   l_rec                          nm3asset.rec_inv_flex_col_details;
   l_iit_ne_id                    nm_inv_items.iit_ne_id%TYPE;
--
BEGIN
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
--nm_debug.set_level(3);
--nm_debug.debug(USER);
--nm_debug.debug(TO_CHAR(SYSDATE,'HH24:MI:SS'));
--
   nm_debug.proc_start(g_package_name,'update_item');
--
   nm3web.module_startup(c_this_module);
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
--      nm_debug.debug('////////////'||i);
--      nm_debug.debug('l_rec.ita_attrib_name : '||l_rec.ita_attrib_name);
--      nm_debug.debug('l_rec.iit_value_orig : '||l_rec.iit_value_orig);
--      nm_debug.debug('l_rec.iit_value : '||l_rec.iit_value);
--      IF l_rec.ita_attrib_name = 'IIT_CHR_ATTRIB56'
--       THEN
--         nm_debug.debug(LENGTH(iit_value_orig(i)));
--         FOR j IN 1..NVL(LENGTH(iit_value_orig(i)),0)
--          LOOP
--            nm_debug.debug(j||'=CHR('||ASCII(SUBSTR(iit_value_orig(i),j,1))||')');
--         END LOOP;
--      END IF;
      --
      l_tab_rec_inv_flex_col_details(i) := l_rec;
      --
   END LOOP;
--
   nm3asset.update_inv_flex_cols (pio_flex_col_dets => l_tab_rec_inv_flex_col_details);
--
   nm_debug.proc_end(g_package_name,'update_item');
--
   COMMIT;
--
   DECLARE
      l_prevent_update BOOLEAN;
   BEGIN
      l_prevent_update := nm3get.get_iit (pi_iit_ne_id       => l_iit_ne_id
                                         ,pi_raise_not_found => FALSE
                                         ).iit_ne_id IS NULL;
      show_single_inv_item_details  (pi_iit_ne_id      => l_iit_ne_id
                                    ,pi_prevent_update => l_prevent_update
                                    );
   END;
--
END update_item;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_meta_tags_force_refresh IS
BEGIN
   htp.p('<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">');
   htp.p('<meta http-equiv="Pragma" CONTENT="no-cache">');
   htp.p('<meta http-equiv="Expires" CONTENT="Mon, 26 Jul 1997 05:00:00 GMT">');
   htp.p('<meta http-equiv="Cache-Control" CONTENT="no-cache, must-revalidate">');
   htp.p('<meta http-equiv="Last-Modified" CONTENT="Mon, 26 Jul 1997 05:00:00 GMT">');
END do_meta_tags_force_refresh;
--
-----------------------------------------------------------------------------
--
FUNCTION get_detail_url (pi_iit_ne_id nm_inv_items.iit_ne_id%TYPE) RETURN VARCHAR2 IS
BEGIN
   --
   RETURN '<A HREF="'||g_package_name||'.show_single_inv_item_details'||'?'||
               'pi_iit_ne_id='||pi_iit_ne_id||'">Detail</A>';
   --
END get_detail_url;
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
   htp.p('eval("page" + id + " = window.open(URL, '||nm3flx.string('" + id + "')||', '||nm3flx.string('toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=800,height=600')||');");');
   htp.p('}');
--
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
PROCEDURE view_associated_documents (pi_iit_ne_id      nm_inv_items.iit_ne_id%TYPE
                                    ,pi_prevent_update VARCHAR2 DEFAULT 'FALSE'
                                    ) IS
--
   l_rec_hmo             hig_modules%ROWTYPE;
   l_module_mode         hig_module_roles.hmr_mode%TYPE;
   l_update_allowed      BOOLEAN := FALSE;
   l_prevent_update      BOOLEAN := nm3flx.char_to_boolean(pi_prevent_update);
   l_rec_nit             nm_inv_types%ROWTYPE;
   l_rec_iit             nm_inv_items_all%ROWTYPE;
--
   l_tab_doc_id             nm3type.tab_number;
   l_tab_doc_title          nm3type.tab_varchar80;
   l_tab_dlc_url_pathname   nm3type.tab_varchar2000;
   l_tab_doc_file           nm3type.tab_varchar2000;
   l_tab_doc_descr          nm3type.tab_varchar2000;
   l_tab_dmd_file_extension nm3type.tab_varchar2000;
   l_filename               VARCHAR2(254);
--
   l_window_title nm3type.max_varchar2;
--
   l_url          nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'view_associated_documents');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_doc0120_title
               );
--
   create_js_funcs (p_script_open  => TRUE
                   ,p_script_close => TRUE
                   );
--
   sccs_tags;
   create_js_funcs;
   do_meta_tags_force_refresh;
   htp.headclose;
   htp.bodyopen;
--
   do_close_window_button;
--
   --
   hig.get_module_details (pi_module => c_this_module
                          ,po_hmo    => l_rec_hmo
                          ,po_mode   => l_module_mode
                          );
--
--   htp.p(htf.small(TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS')));
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
   -- get it from iit_all
   l_rec_iit := nm3get.get_iit_all (pi_iit_ne_id    => pi_iit_ne_id);
   -- check that it is in NM_INV_ITEMS, then we can prevent update if not.
   --  the only time we should get this is when the user sets the end-date via this
--
   IF NOT l_prevent_update
    AND   nm3get.get_iit (pi_iit_ne_id       => pi_iit_ne_id
                         ,pi_raise_not_found => FALSE
                         ).iit_ne_id IS NULL
    THEN
      l_prevent_update := TRUE;
   END IF;
--
   l_rec_nit := nm3get.get_nit     (pi_nit_inv_type => l_rec_iit.iit_inv_type);
   --
   l_window_title := c_doc0120_title||' ('||l_rec_nit.nit_descr||' - '||l_rec_iit.iit_primary_key||')';
   --
   htp.p('<SCRIPT LANGUAGE="Javascript">');
   htp.p('<!--');
   htp.p('   document.title="'||l_window_title||'";');
   htp.p('// -->');
   htp.p('</SCRIPT>');
--
   IF   NOT l_prevent_update
    AND l_module_mode = nm3type.c_normal
    AND l_rec_nit.nit_table_name IS NULL
    AND invsec.is_inv_item_updatable (p_iit_inv_type           => l_rec_nit.nit_inv_type
                                     ,p_iit_admin_unit         => l_rec_iit.iit_admin_unit
                                     ,pi_unrestricted_override => FALSE
                                     )
    THEN
      l_update_allowed := TRUE;
   END IF;
--
   SELECT /*+ INDEX (das DAS_PK) */
          doc_title
         ,doc_id
         ,dlc_url_pathname
         ,doc_file
         ,doc_descr
         ,dmd_file_extension
    BULK  COLLECT
    INTO  l_tab_doc_title
         ,l_tab_doc_id
         ,l_tab_dlc_url_pathname
         ,l_tab_doc_file
         ,l_tab_doc_descr
         ,l_tab_dmd_file_extension
    FROM  docs
         ,doc_assocs
         ,doc_locations
         ,doc_media
   WHERE  doc_id           = das_doc_id
    AND   das_rec_id       = l_rec_iit.iit_ne_id
    AND   das_table_name   IN (c_iit,c_iit_all)
    AND   doc_dlc_id       = dlc_id
    AND   dlc_url_pathname IS NOT NULL
    AND   doc_dlc_dmd_id   = dmd_id;
--
   IF l_tab_doc_title.COUNT = 0
    THEN
      htp.header(1,hig.raise_and_catch_ner (nm3type.c_net, 326));
   ELSE
      htp.tableopen (cattributes=>'BORDER=1');
      htp.tablerowopen;
      htp.tableheader(nm3web.c_nbsp);
      IF l_update_allowed
       THEN
         htp.formopen (g_package_name||'.delete_checked_das');
         htp.formhidden ('pi_iit_ne_id',pi_iit_ne_id);
         htp.formhidden ('pi_doc_id',-1);
         htp.formhidden ('pi_doc_id',-1);
         htp.tableheader(htf.formsubmit(cvalue=>'Delete'));
      END IF;
      htp.tableheader(htf.small('ID'));
      htp.tableheader(htf.small('Filename'));
      htp.tableheader(htf.small('Title'));
      htp.tableheader(htf.small('Descr'));
      htp.tablerowclose;
      FOR i IN 1..l_tab_doc_title.COUNT
       LOOP
         htp.tablerowopen;
         l_url := l_tab_dlc_url_pathname(i);
         IF nm3flx.right(l_url,1) NOT IN ('/','\')
          THEN
            l_url := l_url||'/';
         END IF;
         l_filename := l_tab_doc_file(i);
         IF UPPER(nm3flx.RIGHT(l_filename,(LENGTH(l_tab_dmd_file_extension(i))+1))) != '.'||l_tab_dmd_file_extension(i)
          THEN
            l_filename := l_filename||'.'||l_tab_dmd_file_extension(i);
         END IF;
         l_url := l_url||l_filename;
         htp.tabledata (cvalue      => '<input type="button" value="Show" onClick="popUp('||nm3flx.string(l_url)||');">'
                       ,cattributes => 'ALIGN=CENTER VALIGN=MIDDLE'
                       );
         IF l_update_allowed
          THEN
            htp.tableheader (htf.formcheckbox(cname  => 'pi_doc_id'
                                             ,cvalue => l_tab_doc_id(i)
                                             )
                            );
         END IF;
         htp.tabledata (htf.small (l_tab_doc_id(i)));
         htp.tabledata (htf.small (l_filename));
         htp.tabledata (htf.small (l_tab_doc_title(i)));
         htp.tabledata (htf.small (l_tab_doc_descr(i)));
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
      IF l_update_allowed
       THEN
         htp.formclose;
      END IF;
   END IF;
--
   IF l_update_allowed
    THEN
      htp.br;
      htp.tableopen (cattributes=>'BORDER=1');
      htp.tablerowopen;
      htp.tabledata (cvalue => '<input type="button" value="Add New" onClick="popUp('||nm3flx.string(g_package_name||'.associate_new_doc?pi_iit_ne_id='||pi_iit_ne_id)||');">');
      htp.tabledata ('<input type=button value="Refresh" onClick="javascript:location.reload();">');
      htp.tablerowclose;
      htp.tableclose;
   END IF;
--
   do_close_window_button;
--
   htp.bodyclose;
   htp.htmlclose;
--
END view_associated_documents;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_close_window_button (p_do_button BOOLEAN DEFAULT TRUE) IS
BEGIN
   IF p_do_button
    THEN
      htp.p('<DIV ALIGN=RIGHT>');
      htp.p('<form>');
      htp.p('<input type="button" value="Close" onClick="window.close();">');
      htp.p('</form>');
      htp.p('</DIV>');
   END IF;
END do_close_window_button;
--
----------------------------------------------------------------------------------------
--
PROCEDURE associate_new_doc (pi_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
--
   l_selected     VARCHAR2(10);
--
   l_tab_dtp_code nm3type.tab_varchar4;
   l_tab_dtp_name nm3type.tab_varchar30;
--
   l_tab_dmd_name nm3type.tab_varchar30;
   l_tab_dlc_name nm3type.tab_varchar30;
   l_tab_dlc_id   nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'associate_new_doc');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_doc0120_title
               );
--
   create_js_funcs (p_script_open  => TRUE
                   ,p_script_close => TRUE
                   );
--
   sccs_tags;
   create_js_funcs;
   do_meta_tags_force_refresh;
   htp.headclose;
   htp.bodyopen;
--
   do_close_window_button;
--
   htp.formopen (g_package_name||'.associate_new');
   htp.formhidden ('pi_iit_ne_id',pi_iit_ne_id);
   --
   htp.tableopen (cattributes=>'BORDER=1');
   --
   htp.tablerowopen;
   htp.tableheader(htf.small('Doc Type'));
   SELECT dtp_code
         ,dtp_name
    BULK  COLLECT
    INTO  l_tab_dtp_code
         ,l_tab_dtp_name
    FROM  doc_types
   WHERE  dtp_allow_comments   = 'N'
    AND   dtp_allow_complaints = 'N'
   ORDER BY dtp_name;
   htp.p('<TD>');
   htp.formselectopen ('pi_dtp_code');
   l_selected := c_selected;
   FOR i IN 1..l_tab_dtp_code.COUNT
    LOOP
      htp.p('   <OPTION VALUE="'||l_tab_dtp_code(i)||'"'||l_selected||'>'||l_tab_dtp_name(i)||'</OPTION>');
      l_selected := Null;
   END LOOP;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.small('Doc Media/Location'));
   htp.p('<TD>');
   htp.formselectopen ('pi_dlc_id');
   --
   SELECT dmd_name
         ,dlc_name
         ,dlc_id
    BULK  COLLECT
    INTO  l_tab_dmd_name
         ,l_tab_dlc_name
         ,l_tab_dlc_id
    FROM  doc_locations
         ,doc_media
   WHERE  dlc_dmd_id = dmd_id
    AND   dlc_url_pathname IS NOT NULL;
   --
   l_selected := c_selected;
   FOR i IN 1..l_tab_dlc_id.COUNT
    LOOP
      htp.p('   <OPTION VALUE="'||l_tab_dlc_id(i)||'"'||l_selected||'>'||l_tab_dlc_name(i)||'</OPTION>');
      l_selected := Null;
   END LOOP;
   --
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.small('Filename'));
   htp.tabledata (htf.formtext (cname      => 'pi_doc_file'
                               ,csize      => 30
                               ,cmaxlength => 254
                               )
                 );
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.small('Title'));
   htp.tabledata (htf.formtext (cname      => 'pi_doc_title'
                               ,csize      => 30
                               ,cmaxlength => 254
                               )
                 );
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.small('Description'));
   htp.tabledata (htf.formtext (cname      => 'pi_doc_descr'
                               ,csize      => 30
                               ,cmaxlength => 254
                               )
                 );
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   --
   htp.tableclose;
   --
   htp.formclose;
--
   do_close_window_button;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'associate_new_doc');
--
END associate_new_doc;
--
----------------------------------------------------------------------------------------
--
PROCEDURE associate_new (pi_dtp_code  docs.doc_dtp_code%TYPE
                        ,pi_dlc_id    docs.doc_dlc_id%TYPE
                        ,pi_doc_file  docs.doc_file%TYPE
                        ,pi_doc_title docs.doc_title%TYPE
                        ,pi_doc_descr docs.doc_descr%TYPE
                        ,pi_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                        ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_rec_doc docs%ROWTYPE;
   l_rec_dtp doc_types%ROWTYPE;
   l_rec_dlc doc_locations%ROWTYPE;
   l_rec_dmd doc_media%ROWTYPE;
   l_rec_das doc_assocs%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'associate_new_doc');
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_doc0120_title
               );
--
   create_js_funcs (p_script_open  => TRUE
                   ,p_script_close => TRUE
                   );
--
   sccs_tags;
   create_js_funcs;
   do_meta_tags_force_refresh;
   htp.headclose;
   htp.bodyopen;
--
   do_close_window_button;
--
   l_rec_dtp := nm3get.get_dtp (pi_dtp_code => pi_dtp_code);
   l_rec_dlc := nm3get.get_dlc (pi_dlc_id   => pi_dlc_id);
   l_rec_dmd := nm3get.get_dmd (pi_dmd_id   => l_rec_dlc.dlc_dmd_id);
--
   l_rec_doc.doc_id                         := nm3seq.next_doc_id_seq;
   l_rec_doc.doc_title                      := NVL(pi_doc_title,l_rec_dtp.dtp_name||' for '||c_iit_all||' - '||pi_iit_ne_id);
   l_rec_doc.doc_dtp_code                   := pi_dtp_code;
   l_rec_doc.doc_date_issued                := SYSDATE;
   l_rec_doc.doc_file                       := pi_doc_file;
   IF l_rec_dmd.dmd_file_extension IS NOT NULL
    THEN
      IF nm3flx.right(UPPER(l_rec_doc.doc_file),(LENGTH(l_rec_dmd.dmd_file_extension)+1)) = '.'||UPPER(l_rec_dmd.dmd_file_extension)
       THEN
         l_rec_doc.doc_file                 := nm3flx.left(l_rec_doc.doc_file,(LENGTH(l_rec_doc.doc_file)-(LENGTH(l_rec_dmd.dmd_file_extension)+1)));
      END IF;
   END IF;
   l_rec_doc.doc_reference_code             := l_rec_doc.doc_file;
   l_rec_doc.doc_dlc_id                     := l_rec_dlc.dlc_id;
   l_rec_doc.doc_dlc_dmd_id                 := l_rec_dlc.dlc_dmd_id;
   l_rec_doc.doc_descr                      := NVL(pi_doc_descr,'Document automatically created by new file association');
--
   nm3ins.ins_doc (l_rec_doc);
--
   l_rec_das.das_table_name                 := c_iit_all;
   l_rec_das.das_rec_id                     := pi_iit_ne_id;
   l_rec_das.das_doc_id                     := l_rec_doc.doc_id;
--
   nm3ins.ins_das (l_rec_das);
--
   htp.p('<SCRIPT>');
   htp.p('   alert("Now press the '||nm3flx.string('Refresh')||' button to see the new association");');
   htp.p('   self.close();');
   htp.p('// -->');
   htp.p('</SCRIPT>');
--
   htp.bodyclose;
   htp.htmlclose;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'associate_new');
--
END associate_new;
--
----------------------------------------------------------------------------------------
--
PROCEDURE delete_checked_das (pi_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                             ,pi_doc_id    nm3type.tab_varchar30
                             ) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
--
   FORALL i IN 1..pi_doc_id.COUNT
      DELETE FROM doc_assocs
      WHERE  das_table_name IN (c_iit_all,c_iit)
       AND   das_rec_id     =  pi_iit_ne_id
       AND   das_doc_id     =  pi_doc_id(i);
--
   FORALL i IN 1..pi_doc_id.COUNT
      DELETE FROM docs
      WHERE doc_id = pi_doc_id(i)
       AND  NOT EXISTS (SELECT 1
                         FROM  doc_assocs
                        WHERE  das_doc_id = doc_id
                       );
--
   view_associated_documents (pi_iit_ne_id => pi_iit_ne_id);
--
   COMMIT;
--
END delete_checked_das;
--
-----------------------------------------------------------------------------
--
FUNCTION escape_it (p_text VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3web.replace_chevrons(REPLACE(p_text
                                         ,'"'
                                         ,nm3web.get_escape_char('"')
                                         )
                                 );
END escape_it;
--
----------------------------------------------------------------------------------------
--
END xtnz_lar_mail_merge;
/
