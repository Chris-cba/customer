CREATE OR REPLACE PACKAGE BODY xact_faq AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_faq.pkb	1.1 03/14/05
--       Module Name      : xact_faq.pkb
--       Date into SCCS   : 05/03/14 23:10:55
--       Date fetched Out : 07/06/06 14:33:44
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT FAQ package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xact_faq.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xact_faq';
--
   c_faq_create_module            CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0010';
   c_faq_create_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_create_module);
--
   c_faq_update_module            CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0020';
   c_faq_update_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_update_module);
--
   c_faq_upd_access_module        CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0030';
   c_faq_upd_access_module_title  CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_upd_access_module);
--
   c_faq_delete_module            CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0040';
   c_faq_delete_module_title      CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_delete_module);
--
   c_faq_upd_title_module         CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0050';
   c_faq_upd_title_module_title   CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_upd_title_module);
--
   c_faq_add_content_module       CONSTANT hig_modules.hmo_module%TYPE := 'XFAQWEB0060';
   c_faq_add_content_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_faq_add_content_module);
--
   c_new_faq       CONSTANT VARCHAR2(30) := 'NEW_FAQ';
   c_upd_faq       CONSTANT VARCHAR2(30) := 'UPD_FAQ';
   c_add_cont_faq  CONSTANT VARCHAR2(30) := 'ADD_CONTENT_FAQ';
   c_acc_faq       CONSTANT VARCHAR2(30) := 'modify_faq_access';
   c_del_faq       CONSTANT VARCHAR2(30) := 'delete_faq';
   c_upd_faq_title CONSTANT VARCHAR2(30) := 'modify_faq_title';
--
   c_hig_modules   CONSTANT VARCHAR2(30) := 'HIG_MODULES';
--
   c_url     CONSTANT VARCHAR2(3)  := 'URL';
   c_hsf_type_module     CONSTANT hig_system_favourites.hsf_type%TYPE := 'M';
--
   c_document_table      CONSTANT varchar2(30)               := nm3web.get_document_table;
   c_document_table_part CONSTANT varchar2(30)               := c_document_table||'PART';
   c_faq_admin           CONSTANT VARCHAR2(30)               := 'XFAQ_ADMIN';
   c_user_id             CONSTANT hig_users.hus_user_id%TYPE := 1; --nm3user.get_user_id;
   c_faq_module          CONSTANT VARCHAR2(30)               := 'FAQ Module';
   c_faq_title           CONSTANT VARCHAR2(30)               := 'FAQ Title';
   c_sup_aster           CONSTANT VARCHAR2(30)               := htf.sup('*');
--
   c_continue            CONSTANT nm_errors.ner_descr%TYPE   := hig.get_ner(nm3type.c_hig,165).ner_descr;
   c_selected            CONSTANT VARCHAR2(8)                := 'SELECTED';
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE role_listbox (p_module VARCHAR2 DEFAULT NULL);
--
-----------------------------------------------------------------------------
--
PROCEDURE module_listbox (p_only_without_content BOOLEAN DEFAULT FALSE);
--
-----------------------------------------------------------------------------
--
PROCEDURE folder_listbox (p_module VARCHAR2 DEFAULT NULL);
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_internal (p_mode         VARCHAR2
                          ,p_module       VARCHAR2
                          ,p_module_title VARCHAR2
                          );
--
-----------------------------------------------------------------------------
--
PROCEDURE select_module   (p_mode         VARCHAR2
                          ,p_module       VARCHAR2
                          ,p_module_title VARCHAR2
                          );
--
-----------------------------------------------------------------------------
--
FUNCTION check_module_mode (p_module VARCHAR2
                           ,p_lock   BOOLEAN DEFAULT FALSE
                           ) RETURN hig_modules%ROWTYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE strip_out_nvl_roles (pi_role IN     nm3type.tab_varchar30
                              ,po_role    OUT nm3type.tab_varchar30
                              ,po_mode    OUT nm3type.tab_varchar30
                              );
--
-----------------------------------------------------------------------------
--
PROCEDURE strip_out_nvl_folders (pi_folder IN     nm3type.tab_varchar30
                                ,po_folder    OUT nm3type.tab_varchar30
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_hmr_from_tab (p_hmo_module VARCHAR2
                              ,p_tab_role   nm3type.tab_varchar30
                              ,p_tab_mode   nm3type.tab_varchar30
                              );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_hsf_from_tab (p_tab_folder nm3type.tab_varchar30
                              ,p_hmo_module VARCHAR2
                              ,p_hmo_title  VARCHAR2
                              );
--
-----------------------------------------------------------------------------
--
PROCEDURE dummy_for_arrays (p_param VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE op_completed_successfully (p_module VARCHAR2 DEFAULT NULL);
--
-----------------------------------------------------------------------------
--
PROCEDURE del_hmr (pi_module VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE del_hsf (pi_module VARCHAR2);
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_hmo_filename RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_mand (p_parameter_name  VARCHAR2
                     ,p_parameter_value VARCHAR2
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
PROCEDURE del_by_name (p_name VARCHAR2) IS
   l_sql nm3type.max_varchar2;
   c_filename CONSTANT nm3type.max_varchar2 := nm3upload.g_filename;
BEGIN
   nm3upload.g_filename := p_name;
--   nm_debug.debug('Del_by_name = '||g_filename);
   l_sql :=            'BEGIN'
            ||CHR(10)||'   DELETE '||c_document_table
            ||CHR(10)||'   WHERE name = nm3upload.g_filename;'
            ||CHR(10)||'END;';
--   nm_debug.debug(l_sql);
   EXECUTE IMMEDIATE l_sql;
--   nm_debug.debug('done del_by_name');
END del_by_name;
--
----------------------------------------------------------------------------------------
--
PROCEDURE rename_nuf (pi_old_name varchar2
                     ,pi_new_name varchar2
                     ) IS
--
   l_sql nm3type.max_varchar2;
--
   c_new_filename CONSTANT nm3type.max_varchar2 := nm3upload.g_new_filename;
   c_old_filename CONSTANT nm3type.max_varchar2 := nm3upload.g_old_filename;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'rename_nuf');
--
   nm3upload.g_new_filename := pi_new_name;
   nm3upload.g_old_filename := pi_old_name;
--
   l_sql :=            'BEGIN'
            ||CHR(10)||'   UPDATE '||c_document_table
            ||CHR(10)||'    SET   name = nm3upload.g_new_filename'
            ||CHR(10)||'   WHERE  name = nm3upload.g_old_filename'
            ||CHR(10)||'   RETURNING ROWID INTO nm3upload.g_nuf_rowid;'
            ||CHR(10)||'END;';
   BEGIN
      EXECUTE IMMEDIATE l_sql;
   EXCEPTION
      WHEN dup_val_on_index
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 64
                       ,pi_supplementary_info => pi_new_name
                       );
   END;
--
   l_sql :=            'BEGIN'
            ||CHR(10)||'   DELETE FROM '||c_document_table_part
            ||CHR(10)||'   WHERE document = nm3upload.g_old_filename;'
            ||CHR(10)||'END;';
   BEGIN
      EXECUTE IMMEDIATE l_sql;
   EXCEPTION
      WHEN others THEN NULL;
   END;
--
   nm3upload.g_new_filename := c_new_filename;
   nm3upload.g_old_filename := c_old_filename;
--
   nm_debug.proc_end(g_package_name , 'rename_nuf');
--
END rename_nuf;
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
   htp.p('--       sccsid           : @(#)xact_faq.pkb	1.1 03/14/05');
   htp.p('--       Module Name      : xact_faq.pkb');
   htp.p('--       Date into SCCS   : 05/03/14 23:10:55');
   htp.p('--       Date fetched Out : 07/06/06 14:33:44');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   ACT FAQ package');
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
PROCEDURE prompt_internal (p_mode         VARCHAR2
                          ,p_module       VARCHAR2
                          ,p_module_title VARCHAR2
                          ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_internal');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(p_module);
--
   htp.tableopen (cattributes=>'BORDER=1');
--
   htp.formopen(curl     => g_package_name||'.create_faq'
               ,cenctype => 'multipart/form-data'
               );

   htp.formhidden ('p_call_mode',p_mode);
   htp.formhidden ('p_this_module',p_module);
   htp.formhidden ('p_this_mod_title',p_module_title);
--
   IF p_mode = c_new_faq
    THEN
      htp.tablerowopen;
      htp.tableheader(c_faq_module||c_sup_aster);
      htp.tabledata(htf.formtext(cname      => 'p_module_name'
                                ,csize      => 30
                                ,cmaxlength => 30
                                )
                   );
      htp.tablerowclose;
   --
      htp.tablerowopen;
      htp.tableheader(c_faq_title||c_sup_aster);
      htp.tabledata(htf.formtext(cname      => 'p_module_title'
                                ,csize      => 50
                                ,cmaxlength => 70
                                )
                   );
      htp.tablerowclose;
   --
      role_listbox;
--
      folder_listbox;
--
   ELSIF p_mode IN (c_upd_faq,c_add_cont_faq)
    THEN
      htp.formhidden ('p_module_title',nm3type.c_nvl);
      dummy_for_arrays('p_folder');
      dummy_for_arrays('p_role');
      module_listbox (p_only_without_content => (p_mode=c_add_cont_faq));
   END IF;
--
   htp.tablerowopen;
   htp.tableheader('Filename'||c_sup_aster);
   htp.tabledata(htf.formfile(cname       => 'p_filename'
                             ,cattributes => 'SIZE=60'
                             )
                );
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.tableheader('Replace');
   htp.tabledata(htf.formcheckbox (cname    => 'p_replace'
                                  ,cvalue   => 'Y'
                                  ,cchecked => 'CHECKED'
                                  )
                );
   htp.tablerowclose;
--
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'prompt_internal');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END prompt_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_create_new IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_create_new');
--
   prompt_internal (p_mode         => c_new_faq
                   ,p_module       => c_faq_create_module
                   ,p_module_title => c_faq_create_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_create_new');
--
END prompt_create_new;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_add_content IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_add_content');
--
   prompt_internal (p_mode         => c_add_cont_faq
                   ,p_module       => c_faq_add_content_module
                   ,p_module_title => c_faq_add_content_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_add_content');
--
END prompt_add_content;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_update_content IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_update_content');
--
   prompt_internal (p_mode         => c_upd_faq
                   ,p_module       => c_faq_update_module
                   ,p_module_title => c_faq_update_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_update_content');
--
END prompt_update_content;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_update_access IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_update_access');
--
   select_module   (p_mode         => c_acc_faq
                   ,p_module       => c_faq_upd_access_module
                   ,p_module_title => c_faq_upd_access_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_update_access');
--
END prompt_update_access;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_delete IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_delete');
--
   select_module   (p_mode         => c_del_faq
                   ,p_module       => c_faq_delete_module
                   ,p_module_title => c_faq_delete_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_delete');
--
END prompt_delete;
--
-----------------------------------------------------------------------------
--
PROCEDURE prompt_update_title IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'prompt_update_title');
--
   select_module   (p_mode         => c_upd_faq_title
                   ,p_module       => c_faq_upd_title_module
                   ,p_module_title => c_faq_upd_title_module_title
                   );
--
   nm_debug.proc_end(g_package_name,'prompt_update_title');
--
END prompt_update_title;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_faq (p_filename       VARCHAR2
                     ,p_replace        VARCHAR2
                     ,p_module_name    VARCHAR2
                     ,p_module_title   VARCHAR2
                     ,p_role           nm3type.tab_varchar30
                     ,p_folder         nm3type.tab_varchar30
                     ,p_call_mode      VARCHAR2
                     ,p_this_module    VARCHAR2
                     ,p_this_mod_title VARCHAR2
                     ) IS
   l_rec_hmo      hig_modules%ROWTYPE;
   l_rec_hmo_temp hig_modules%ROWTYPE;
   l_rec_hum      hig_url_modules%ROWTYPE;
   l_filename     nm_upload_files.name%TYPE;
   l_tab_role     nm3type.tab_varchar30;
   l_tab_mode     nm3type.tab_varchar30;
   l_tab_folder   nm3type.tab_varchar30;
--
   l_ins_hum   BOOLEAN     := FALSE;
--
   c_create_new CONSTANT BOOLEAN := p_call_mode = c_new_faq;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_faq');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_this_mod_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(p_this_module);
   --
   check_mand ('p_filename',p_filename);
   check_mand ('p_replace',p_replace);
   check_mand ('p_module_name',p_module_name);
   check_mand ('p_module_title',p_module_title);
   check_mand ('p_call_mode',p_call_mode);
   check_mand ('p_this_module',p_this_module);
   check_mand ('p_this_mod_title',p_this_mod_title);
--
   strip_out_nvl_roles (p_role, l_tab_role, l_tab_mode);
--
   strip_out_nvl_folders (p_folder, l_tab_folder);
--
   htp.p('<!-- Parameters');
   htp.p('--');
   htp.p('--   p_filename     : '||p_filename);
   htp.p('--   p_replace      : '||p_replace);
   htp.p('--   p_module_name  : '||p_module_name);
   htp.p('--   p_module_title : '||p_module_title);
   htp.p('--   p_call_mode    : '||p_call_mode);
   htp.p('--   p_role         : ');
--
   FOR i IN 1..l_tab_role.COUNT
    LOOP
      htp.p('--                    '||l_tab_role(i)||' - '||l_tab_mode(i));
   END LOOP;
   htp.p('--   p_folder       : ');
   FOR i IN 1..l_tab_folder.COUNT
    LOOP
      htp.p('--                    '||l_tab_folder(i));
   END LOOP;
--
   htp.p('--');
   htp.p('-->');
--
   l_filename := nm3upload.strip_dad_reference (p_filename);
--
   IF p_replace = 'Y'
    THEN
      del_by_name (l_filename);
   END IF;
--
   rename_nuf (pi_old_name => p_filename
              ,pi_new_name => l_filename
              );
--
   l_rec_hmo.hmo_module           := RTRIM(UPPER(NVL(p_module_name,l_filename)),' ');
   l_rec_hmo.hmo_filename         := get_default_hmo_filename;
--
   IF c_document_table = nm3upload.c_nm_upload_files
    THEN
      EXECUTE IMMEDIATE            'BEGIN'
                        ||CHR(10)||' UPDATE '||c_document_table
                        ||CHR(10)||'   SET  nuf_nufg_table_name    = '||nm3flx.string(c_hig_modules)
                        ||CHR(10)||'       ,nuf_nufgc_column_val_1 = '||nm3flx.string(l_rec_hmo.hmo_module)
                        ||CHR(10)||' WHERE  ROWID                  = nm3upload.g_nuf_rowid;'
                        ||CHR(10)||'END;';
   END IF;
--
   l_rec_hum.hum_hmo_module       := l_rec_hmo.hmo_module;
   l_rec_hum.hum_url              := c_base_url||l_filename;
--
   IF c_create_new
    THEN
--
      l_rec_hmo.hmo_title            := NVL(p_module_title,l_rec_hmo.hmo_module);
      l_rec_hmo.hmo_module_type      := c_url;
      l_rec_hmo.hmo_fastpath_opts    := Null;
      l_rec_hmo.hmo_fastpath_invalid := 'Y';
      l_rec_hmo.hmo_use_gri          := 'N';
      l_rec_hmo.hmo_application      := c_xfaq;
      l_rec_hmo.hmo_menu             := Null;
      --
      IF nm3get.get_hmo (pi_hmo_module      => l_rec_hmo.hmo_module
                        ,pi_raise_not_found => FALSE
                        ).hmo_module IS NOT NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 64
                       ,pi_supplementary_info => l_rec_hmo.hmo_module
                       );
      END IF;
      --
      nm3ins.ins_hmo (l_rec_hmo);
--
      l_ins_hum := TRUE;
--
      create_hmr_from_tab (l_rec_hmo.hmo_module
                          ,l_tab_role
                          ,l_tab_mode
                          );
--
      create_hsf_from_tab (l_tab_folder
                          ,l_rec_hmo.hmo_module
                          ,l_rec_hmo.hmo_title
                          );
--
   ELSIF p_call_mode = c_upd_faq
    THEN
--
      l_rec_hmo_temp := check_module_mode(l_rec_hmo.hmo_module, TRUE);
--
      IF c_document_table = nm3upload.c_nm_upload_files
       THEN
         EXECUTE IMMEDIATE             'BEGIN'
                           ||CHR(10)||' DELETE '||c_document_table
                           ||CHR(10)||' WHERE  nuf_nufg_table_name    = '||nm3flx.string(c_hig_modules)
                           ||CHR(10)||'  AND   nuf_nufgc_column_val_1 = '||nm3flx.string(l_rec_hmo.hmo_module)
                           ||CHR(10)||'  AND   ROWID                 != nm3upload.g_nuf_rowid;'
                           ||CHR(10)||'END;';
      END IF;
      --
      nm3del.del_hum (pi_hum_hmo_module  => l_rec_hmo.hmo_module
                     ,pi_raise_not_found => FALSE
                     );
      --
      l_ins_hum := TRUE;
      --
      UPDATE hig_modules
       SET   hmo_filename = l_rec_hmo.hmo_filename
      WHERE  hmo_module   = l_rec_hmo.hmo_module;
--
   END IF;
   --
   IF l_ins_hum
    THEN
      nm3ins.ins_hum (l_rec_hum);
   END IF;
   --
   op_completed_successfully (p_this_module);
--   --
--   htp.anchor (curl  => l_rec_hum.hum_url
--              ,ctext => l_rec_hmo.hmo_title
--              );
--
   COMMIT;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'create_faq');
--
EXCEPTION
--
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
--
END create_faq;
--
-----------------------------------------------------------------------------
--
PROCEDURE role_listbox (p_module VARCHAR2 DEFAULT NULL) IS
--
   l_tab_hro_role    nm3type.tab_varchar30;
   l_tab_hro_product nm3type.tab_varchar30;
   l_tab_hro_descr   nm3type.tab_varchar2000;
   l_tab_checked     nm3type.tab_varchar30;
--
BEGIN
   htp.tablerowopen;
   htp.tableheader('Roles',cattributes=>'VALIGN="TOP"');
   dummy_for_arrays ('p_role');
   htp.p('<TD>');
   SELECT hro_role
         ,hro_product
         ,hro_descr
         ,get_hmr_selected_text(hro_role,p_module) checked
    BULK  COLLECT
    INTO  l_tab_hro_role
         ,l_tab_hro_product
         ,l_tab_hro_descr
         ,l_tab_checked
    FROM  hig_roles
         ,hig_products
   WHERE  hro_product = hpr_product
    AND   hpr_key IS NOT NULL
   ORDER BY checked, hro_role;
   htp.p('<SELECT NAME="p_role" MULTIPLE SIZE='||ROUND((l_tab_hro_role.COUNT/3),0)||'>');
   FOR i IN 1..l_tab_hro_role.COUNT
    LOOP
      htp.p(' <OPTION VALUE="'||l_tab_hro_role(i)||'" '||l_tab_checked(i)||'>'||l_tab_hro_role(i)||' ('||l_tab_hro_descr(i)||')');
   END LOOP;
   htp.p('</SELECT>');
   htp.p('</TD>');
   htp.tablerowclose;
END role_listbox;
--
-----------------------------------------------------------------------------
--
PROCEDURE module_listbox (p_only_without_content BOOLEAN DEFAULT FALSE) IS
--
   l_tab_hmo_module  nm3type.tab_varchar30;
   l_tab_hmo_title   nm3type.tab_varchar80;
--
   l_mod_found BOOLEAN := FALSE;
--
   l_write_tab       nm3type.tab_varchar32767;
--
   FUNCTION content_exists (p_module VARCHAR2) RETURN BOOLEAN IS
      CURSOR cs_found (c_module VARCHAR2) IS
      SELECT 1
       FROM  nm_upload_files
      WHERE  nuf_nufg_table_name    = c_hig_modules
       AND   nuf_nufgc_column_val_1 = c_module;
      l_dummy PLS_INTEGER;
      l_found BOOLEAN;
   BEGIN
      OPEN  cs_found (p_module);
      FETCH cs_found INTO l_dummy;
      l_found := cs_found%FOUND;
      CLOSE cs_found;
      RETURN l_found;
   END content_exists;
--
   PROCEDURE write_it (p_text VARCHAR2) IS
   BEGIN
      l_write_tab(l_write_tab.COUNT+1) := p_text;
   END write_it;
--
BEGIN
   htp.tablerowopen;
   htp.tableheader(c_faq_module);
   htp.p('<TD>');
   write_it(htf.formselectopen ('p_module_name'));
   SELECT hmo_module
         ,hmo_title
    BULK  COLLECT
    INTO  l_tab_hmo_module
         ,l_tab_hmo_title
    FROM  hig_modules
   WHERE  hmo_application = c_xfaq
    AND   hmo_module_type = c_url
    AND   EXISTS (SELECT 1
                   FROM  hig_module_roles
                        ,hig_user_roles
                  WHERE  hur_username = USER
                   AND   hur_role     = hmr_role
                   AND   hmr_module   = hmo_module
                   AND   hmr_mode     = nm3type.c_normal
                 )
   ORDER BY hmo_module;
   FOR i IN 1..l_tab_hmo_module.COUNT
    LOOP
      IF NOT p_only_without_content
       OR NOT content_exists (l_tab_hmo_module(i))
       THEN
         l_mod_found := TRUE;
         write_it(' <OPTION VALUE="'||l_tab_hmo_module(i)||'">'||l_tab_hmo_module(i)||' - '||l_tab_hmo_title(i));
      END IF;
   END LOOP;
   write_it(htf.formselectclose);
   IF l_mod_found
    THEN
      nm3web.htp_tab_varchar (l_write_tab);
   ELSE
      htp.formhidden ('p_module_name',Null);
      htp.p(hig.raise_and_catch_ner
                    (pi_appl               => nm3type.c_net
                    ,pi_id                 => 318
                    ,pi_supplementary_info => 'FAQ Modules'
                    )
           );
   END IF;
   htp.p('</TD>');
   htp.tablerowclose;
END module_listbox;
--
-----------------------------------------------------------------------------
--
PROCEDURE folder_listbox (p_module VARCHAR2 DEFAULT NULL) IS
--
   l_tab_hsf_child    nm3type.tab_varchar30;
   l_tab_hsf_descr    nm3type.tab_varchar80;
   l_tab_hsf_level    nm3type.tab_number;
   l_tab_selected     nm3type.tab_varchar30;
--
BEGIN
--
   SELECT hsf_child
         ,hsf_descr
         ,(level-1)*5 the_level
         ,is_existing_hsf_child(hsf_child,p_module) checked
    BULK  COLLECT
    INTO  l_tab_hsf_child
         ,l_tab_hsf_descr
         ,l_tab_hsf_level
         ,l_tab_selected
    FROM  hig_system_favourites
   WHERE  hsf_type = 'F'
   CONNECT BY PRIOR hsf_child = hsf_parent
   START WITH hsf_child = c_faq_start_branch;
--
   htp.tablerowopen;
--   htp.comment ('p_module = '||p_module);
   htp.tableheader('Folders',cattributes=>'VALIGN="TOP"');
   dummy_for_arrays('p_folder');
   htp.p('<TD>');
   htp.p('<SELECT NAME="p_folder" MULTIPLE SIZE='||LEAST(l_tab_hsf_child.COUNT,10)||'>');
   FOR i IN 1..l_tab_hsf_child.COUNT
    LOOP
      htp.p(' <OPTION VALUE="'||l_tab_hsf_child(i)||'" '||l_tab_selected(i)||'>'||REPLACE(RPAD(' ',l_tab_hsf_level(i),' '),' ',nm3web.c_nbsp)||'- '||l_tab_hsf_descr(i));
   END LOOP;
   htp.p('</SELECT>');
   htp.p('</TD>');
   htp.tablerowclose;
END folder_listbox;
--
-----------------------------------------------------------------------------
--
PROCEDURE select_module   (p_mode         VARCHAR2
                          ,p_module       VARCHAR2
                          ,p_module_title VARCHAR2
                          ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'select_module');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => p_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(p_module);
--
   htp.formopen(curl => g_package_name||'.'||p_mode);
   htp.tableopen (cattributes=>'BORDER=1');
   module_listbox;
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'select_module');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END select_module;
--
-----------------------------------------------------------------------------
--
PROCEDURE modify_faq_access (p_module_name hig_modules.hmo_module%TYPE
                            ) IS
--
   l_rec_hmo hig_modules%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'modify_faq_access');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_faq_upd_access_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_faq_upd_access_module);
--
   htp.formopen(curl => g_package_name||'.perform_access_change'
               );
   htp.tableopen (cattributes=>'BORDER=1');
   --
   l_rec_hmo := check_module_mode (p_module_name, FALSE);
   --
   htp.tablerowopen;
   htp.tableheader (c_faq_module);
   htp.tabledata (l_rec_hmo.hmo_module||' - '||l_rec_hmo.hmo_title||htf.formhidden('p_module_name',l_rec_hmo.hmo_module));
   htp.tablerowclose;
   --
   role_listbox(l_rec_hmo.hmo_module);
   --
   folder_listbox(l_rec_hmo.hmo_module);
   --
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'modify_faq_access');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END modify_faq_access;
--
-----------------------------------------------------------------------------
--
FUNCTION is_existing_hsf_child (p_parent VARCHAR2
                               ,p_child  VARCHAR2
                               ) RETURN VARCHAR2 IS
   CURSOR cs_hsf (c_parent VARCHAR2
                 ,c_child  VARCHAR2
                 ) IS
   SELECT c_selected
    FROM  hig_system_favourites
   WHERE  hsf_parent = c_parent
    AND   hsf_child  = c_child;
   l_retval VARCHAR2(10);
BEGIN
   OPEN  cs_hsf (p_parent,p_child);
   FETCH cs_hsf INTO l_retval;
   CLOSE cs_hsf;
   RETURN l_retval;
END is_existing_hsf_child;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hmr_selected_text (p_role   VARCHAR2
                               ,p_module VARCHAR2
                               ) RETURN VARCHAR2 IS
   l_retval VARCHAR2(10);
BEGIN
   IF p_module IS NULL
    THEN
      IF p_role IN ('XFAQ_USER','XACT_PORTAL_ACCESS')
       THEN
         l_retval := c_selected;
      END IF;
   ELSE
      IF nm3get.get_hmr (pi_hmr_module      => p_module
                        ,pi_hmr_role        => p_role
                        ,pi_raise_not_found => FALSE
                        ).hmr_module IS NOT NULL
       THEN
         l_retval := c_selected;
      END IF;
   END IF;
   RETURN l_retval;
END get_hmr_selected_text;
--
-----------------------------------------------------------------------------
--
FUNCTION check_module_mode (p_module VARCHAR2
                           ,p_lock   BOOLEAN DEFAULT FALSE
                           ) RETURN hig_modules%ROWTYPE IS
--
   l_rec_hmo hig_modules%ROWTYPE;
   l_mode    VARCHAR2(30);
--
BEGIN
--
   hig.get_module_details (pi_module => p_module
                          ,po_hmo    => l_rec_hmo
                          ,po_mode   => l_mode
                          );
--
   IF l_mode != nm3type.c_normal
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 267
                    ,pi_supplementary_info => l_rec_hmo.hmo_module
                    );
   END IF;
--
   IF l_rec_hmo.hmo_application != c_xfaq
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 114
                    ,pi_supplementary_info => 'Application != "'||c_xfaq||'" ("'||l_rec_hmo.hmo_application||'")'
                    );
   ELSIF l_rec_hmo.hmo_module_type != c_url
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 114
                    ,pi_supplementary_info => 'Module Type != "'||c_url||'" ("'||l_rec_hmo.hmo_module_type||'")'
                    );
   END IF;
--
   IF p_lock
    THEN
      nm3lock_gen.lock_hmo (pi_hmo_module => l_rec_hmo.hmo_module);
   END IF;
--
   RETURN l_rec_hmo;
--
END check_module_mode;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_access_change (p_module_name VARCHAR2
                                ,p_role        nm3type.tab_varchar30
                                ,p_folder      nm3type.tab_varchar30
                                ) IS
--
   l_rec_hmo    hig_modules%ROWTYPE;
   l_tab_role   nm3type.tab_varchar30;
   l_tab_mode   nm3type.tab_varchar30;
   l_tab_folder nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'perform_access_change');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_faq_upd_access_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_faq_upd_access_module);
   --
   check_mand ('p_module_name',p_module_name);
--
   l_rec_hmo := check_module_mode (p_module_name, TRUE);
--
   strip_out_nvl_roles (p_role, l_tab_role, l_tab_mode);
--
   strip_out_nvl_folders (p_folder, l_tab_folder);
--
   del_hmr (l_rec_hmo.hmo_module);
   create_hmr_from_tab (l_rec_hmo.hmo_module
                       ,l_tab_role
                       ,l_tab_mode
                       );
--
   del_hsf (l_rec_hmo.hmo_module);
   create_hsf_from_tab (l_tab_folder
                       ,l_rec_hmo.hmo_module
                       ,l_rec_hmo.hmo_title
                       );
--
   op_completed_successfully (c_faq_upd_access_module);
   COMMIT;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'perform_access_change');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END perform_access_change;
--
-----------------------------------------------------------------------------
--
PROCEDURE strip_out_nvl_roles (pi_role IN     nm3type.tab_varchar30
                              ,po_role    OUT nm3type.tab_varchar30
                              ,po_mode    OUT nm3type.tab_varchar30
                              ) IS
   l_faq_admin BOOLEAN     := FALSE;
   l_count     PLS_INTEGER := 0;
BEGIN
--
   FOR i IN 1..pi_role.COUNT
    LOOP
      IF pi_role(i) != nm3type.c_nvl
       THEN
         l_count             := l_count + 1;
         po_role(l_count)    := pi_role(i);
         IF pi_role(i) = c_faq_admin
          THEN
            po_mode(l_count) := nm3type.c_normal;
            l_faq_admin      := TRUE;
         ELSE
            po_mode(l_count) := nm3type.c_readonly;
         END IF;
      END IF;
   END LOOP;
--
   IF NOT l_faq_admin
    THEN
      l_count                := l_count + 1;
      po_role(l_count)       := c_faq_admin;
      po_mode(l_count)       := nm3type.c_normal;
   END IF;
--
END strip_out_nvl_roles;
--
-----------------------------------------------------------------------------
--
PROCEDURE strip_out_nvl_folders (pi_folder IN     nm3type.tab_varchar30
                                ,po_folder    OUT nm3type.tab_varchar30
                                ) IS
BEGIN
   FOR i IN 1..pi_folder.COUNT
    LOOP
      IF pi_folder(i) != nm3type.c_nvl
       THEN
         po_folder(po_folder.COUNT+1) := pi_folder(i);
      END IF;
   END LOOP;
END strip_out_nvl_folders;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_hmr_from_tab (p_hmo_module VARCHAR2
                              ,p_tab_role   nm3type.tab_varchar30
                              ,p_tab_mode   nm3type.tab_varchar30
                              ) IS
BEGIN
   FORALL i IN 1..p_tab_role.COUNT
      INSERT INTO hig_module_roles
             (hmr_module
             ,hmr_role
             ,hmr_mode
             )
      VALUES (p_hmo_module
             ,p_tab_role(i)
             ,p_tab_mode(i)
             );
END create_hmr_from_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_hsf_from_tab (p_tab_folder nm3type.tab_varchar30
                              ,p_hmo_module VARCHAR2
                              ,p_hmo_title  VARCHAR2
                              ) IS
BEGIN
   FORALL i IN 1..p_tab_folder.COUNT
      INSERT INTO hig_system_favourites
             (hsf_user_id
             ,hsf_parent
             ,hsf_child
             ,hsf_descr
             ,hsf_type
             )
      VALUES (c_user_id
             ,p_tab_folder(i)
             ,p_hmo_module
             ,p_hmo_title
             ,c_hsf_type_module
             );
END create_hsf_from_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE op_completed_successfully (p_module VARCHAR2 DEFAULT NULL) IS
   l_rec_hmo hig_modules%ROWTYPE;
BEGIN
   --htp.header(2,hig.raise_and_catch_ner (nm3type.c_hig,95));
   htp.p('<SCRIPT>');
   nm3web.js_alert_ner(pi_appl       => nm3type.c_hig
                      ,pi_id         => 95
                      );
   IF p_module IS NOT NULL
    THEN
      l_rec_hmo := nm3get.get_hmo (pi_hmo_module => p_module);
      IF l_rec_hmo.hmo_module_type = 'WEB'
       THEN
         htp.p('location.replace("'||l_rec_hmo.hmo_filename||'");');
      END IF;
   END IF;
--   IF NVL(p_go_back_count,0) != 0
--    THEN
--      htp.p('history.go('||(ABS(p_go_back_count)*-1)||');');
--   END IF;
   htp.p('</SCRIPT>');
END op_completed_successfully;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_hmr (pi_module VARCHAR2) IS
BEGIN
   DELETE FROM hig_module_roles
   WHERE  hmr_module = pi_module;
END del_hmr;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_hsf (pi_module VARCHAR2) IS
BEGIN
   DELETE FROM hig_system_favourites
   WHERE  hsf_child = pi_module
    AND   hsf_type  = c_hsf_type_module;
END del_hsf;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_faq (p_module_name VARCHAR2) IS
   l_rec_hmo    hig_modules%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_faq');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_faq_delete_module_title
               );
   sccs_tags;
   htp.bodyopen;
   --
   check_mand ('p_module_name',p_module_name);
--
   nm3web.module_startup(c_faq_delete_module);
--
   l_rec_hmo := check_module_mode (p_module_name, TRUE);
--
   del_hmr (l_rec_hmo.hmo_module);
--
   del_hsf (l_rec_hmo.hmo_module);
--
   IF c_document_table = nm3upload.c_nm_upload_files
    THEN
      DELETE FROM nm_upload_files
      WHERE  nuf_nufg_table_name    = c_hig_modules
       AND   nuf_nufgc_column_val_1 = l_rec_hmo.hmo_module;
   END IF;
--
   nm3del.del_hum (pi_hum_hmo_module  => l_rec_hmo.hmo_module
                  ,pi_raise_not_found => FALSE
                  );
   nm3del.del_hmo (pi_hmo_module => l_rec_hmo.hmo_module);
--
   op_completed_successfully (c_faq_delete_module);
   COMMIT;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'delete_faq');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END delete_faq;
--
-----------------------------------------------------------------------------
--
PROCEDURE modify_faq_title (p_module_name VARCHAR2
                           ) IS
   l_rec_hmo    hig_modules%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'modify_faq_title');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_faq_upd_title_module_title
               );
   sccs_tags;
   htp.bodyopen;
--
   nm3web.module_startup(c_faq_upd_title_module);
--
   htp.formopen(curl => g_package_name||'.perform_title_change'
               );
   htp.tableopen (cattributes=>'BORDER=1');
   --
   l_rec_hmo := check_module_mode (p_module_name, FALSE);
   --
   htp.tablerowopen;
   htp.tableheader (c_faq_module);
   htp.tabledata (l_rec_hmo.hmo_module||' - '||l_rec_hmo.hmo_title||htf.formhidden('p_module_name',l_rec_hmo.hmo_module));
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(c_faq_title||c_sup_aster);
   htp.tabledata(htf.formtext(cname      => 'p_module_title'
                             ,csize      => 50
                             ,cmaxlength => 70
                             ,cvalue     => l_rec_hmo.hmo_title
                             )
                );
   htp.tablerowclose;
   --
   htp.tablerowopen;
   htp.tableheader(htf.formsubmit(cvalue=>c_continue),cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tableclose;
   htp.formclose;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'modify_faq_title');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END modify_faq_title;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_title_change (p_module_name  VARCHAR2
                               ,p_module_title VARCHAR2
                               ) IS
   l_rec_hmo    hig_modules%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'perform_title_change');
--
   nm3web.head (p_close_head => TRUE
               ,p_title      => c_faq_upd_title_module_title
               );
   sccs_tags;
   htp.bodyopen;
   --
   check_mand ('p_module_name',p_module_name);
   check_mand ('p_module_title',p_module_title);
   --
   l_rec_hmo := check_module_mode (p_module_name, TRUE);
--
   nm3web.module_startup(c_faq_upd_title_module);
--
   l_rec_hmo.hmo_title    := p_module_title;
   l_rec_hmo.hmo_filename := get_default_hmo_filename;
--
   UPDATE hig_modules
    SET   hmo_title    = l_rec_hmo.hmo_title
         ,hmo_filename = l_rec_hmo.hmo_filename
   WHERE  hmo_module   = l_rec_hmo.hmo_module;
--
   UPDATE hig_system_favourites
    SET   hsf_descr    = l_rec_hmo.hmo_title
   WHERE  hsf_child    = l_rec_hmo.hmo_module
    AND   hsf_type     = c_hsf_type_module;
--
   op_completed_successfully (c_faq_upd_title_module);
   COMMIT;
--
   htp.bodyclose;
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'perform_title_change');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END perform_title_change;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_hmo_filename RETURN VARCHAR2 IS
BEGIN
   RETURN USER||':'||TO_CHAR(SYSDATE,nm3type.c_full_date_time_format);
END get_default_hmo_filename;
--
-----------------------------------------------------------------------------
--
PROCEDURE dummy_for_arrays (p_param VARCHAR2) IS
BEGIN
   htp.comment('Dummy values so we always pass arrays');
   FOR i IN 1..4
    LOOP
      htp.formhidden (p_param,nm3type.c_nvl);
   END LOOP;
END dummy_for_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_mand (p_parameter_name  VARCHAR2
                     ,p_parameter_value VARCHAR2
                     ) IS
BEGIN
   IF p_parameter_value IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => p_parameter_name
                    );
   END IF;
END check_mand;
--
-----------------------------------------------------------------------------
--
END xact_faq;
/
