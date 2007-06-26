CREATE OR REPLACE PACKAGE BODY xtnzweb_fav AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnzweb_fav.pkb	1.3 03/16/05
--       Module Name      : xtnzweb_fav.pkb
--       Date into SCCS   : 05/03/16 01:30:10
--       Date fetched Out : 07/06/06 14:40:42
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   nm3 web favourites package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xtnzweb_fav.pkb	1.3 03/16/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xtnzweb_fav';
--
   c_this_module       CONSTANT  hig_modules.hmo_module%TYPE := 'XTNZWEB0004';
   c_this_module_title CONSTANT  hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_folder_link CONSTANT VARCHAR2(100) := Null; -- 'nm3web.empty_frame';
--
   c_download_link CONSTANT VARCHAR2(100) := 'nm3web.process_download?pi_name=';
--
   c_web      CONSTANT VARCHAR2(3) := 'WEB';
   c_fmx      CONSTANT VARCHAR2(3) := 'FMX';
   c_dis      CONSTANT VARCHAR2(3) := 'DIS';
   c_url      CONSTANT VARCHAR2(3) := 'URL';
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type   nm3type.tab_varchar4
                       ,p_tab_child  nm3type.tab_varchar30
                       ,p_tab_parent nm3type.tab_varchar30
                       ,p_tab_descr  nm3type.tab_varchar2000
                       ,p_tab_level  nm3type.tab_number
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
PROCEDURE show_favourites IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_favourites');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_this_module_title
               );
--
   htp.p('<FRAMESET cols="200,*"> ');
   htp.p('  <FRAME src="'||g_package_name||'.left_frame" name="treeframe" > ');
   htp.p('  <FRAME SRC="'||NVL(hig.get_sysopt('XFAVSTPAGE'),'nm3web.empty_frame')||'" name="basefrm"> ');
   htp.p('</FRAMESET>');
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'show_favourites');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END show_favourites;
--
-----------------------------------------------------------------------------
--
PROCEDURE left_frame IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'left_frame');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_this_module_title
               );
   htp.p('');
   htp.p('');
   htp.p('<!-- NO CHANGES PAST THIS LINE -->');
   htp.p('');
   htp.p('');
   htp.p('<!-- Code for browser detection -->');
   htp.p('<script src="'||c_download_link||'ua.js"></script>');
   htp.p('');
   htp.p('<!-- Infrastructure code for the tree -->');
   htp.p('<script src="'||c_download_link||'ftiens4.js"></script>');
   htp.p('');
   htp.p('<!-- Execution of the code that actually builds the specific tree.');
   htp.p('     The variable foldersTree creates its structure with calls to');
   htp.p('	 gFld, insFld, and insDoc -->');
   htp.p('<script src="'||g_package_name||'.define_tree_favourites"></script>');

   htp.p('');
   htp.p('</head>');
   htp.p('');
   htp.p('<body topmargin=16 marginheight=16>');
   htp.p('');
   htp.p('<!-- Removing this link will make the script stop working -->');
 --  htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:gray" href=http://www.mmartins.com target=_top></a></font></td></table></div>');
   htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-5><a style="font-size:1pt;text-decoration:none;color:gray" href="http://www.mmartins.com" target=_top></a></font></td></table></div>');
   htp.p('');
   htp.p('<!-- Build the browsers objects and display default view of the');
   htp.p('     tree. -->');
   htp.p('<script>initializeDocument()</script>');
   htp.p('');
   htp.p('</html>');


   nm_debug.proc_end(g_package_name,'left_frame');
--
END left_frame;
--
-----------------------------------------------------------------------------
--
FUNCTION allowable_web_form (p_type   VARCHAR2
                            ,p_module VARCHAR2
                            ) RETURN VARCHAR2 IS
   l_retval VARCHAR2(1);
   CURSOR cs_hmo (c_module VARCHAR2) IS
   SELECT DECODE(hmo_module_type
                ,c_web,'Y'
                ,c_dis,'Y'
                ,c_fmx,'Y'
                ,c_url,'Y'
                ,'N'
                )
    FROM  hig_modules
   WHERE  hmo_module = c_module;
BEGIN
   IF p_type = 'F'
    THEN
      l_retval := 'Y';
   ELSIF p_type = 'M'
    AND  p_module = c_this_module
    THEN
      l_retval := 'N';
   ELSE
      IF nm3user.user_can_run_module (p_module)
       THEN
        OPEN  cs_hmo(p_module);
        FETCH cs_hmo INTO l_retval;
        CLOSE cs_hmo;
      ELSE
        l_retval := 'N';
      END IF;
   END IF;
   RETURN l_retval;
END allowable_web_form;
--
-----------------------------------------------------------------------------
--
PROCEDURE define_tree_favourites IS
--
   CURSOR cs_user_faves (c_user_id NUMBER) IS
   SELECT huf_type, huf_child, huf_parent, huf_descr, LEVEL
    FROM  HIG_USER_FAVOURITES
   WHERE huf_user_id = c_user_id
    AND  allowable_web_form (huf_type,huf_child) = 'Y'
   CONNECT BY PRIOR huf_child = huf_parent
   START WITH huf_parent = 'ROOT'
   AND huf_user_id = c_user_id
   ORDER SIBLINGS BY huf_child, huf_descr ASC;
--
   CURSOR cs_sys_faves IS
   SELECT hsf_type, hsf_child, hsf_parent, hsf_descr, LEVEL
   FROM HIG_SYSTEM_FAVOURITES
   WHERE allowable_web_form (hsf_type,hsf_child) = 'Y'
   CONNECT BY PRIOR hsf_child = hsf_parent
   START WITH hsf_parent = 'ROOT'
   ORDER SIBLINGS BY hsf_child, hsf_descr ASC;
--
   CURSOR cs_products IS
   SELECT hpr_product
         ,hpr_product_name
    FROM  hig_products
   WHERE EXISTS (SELECT 1
                  FROM  hig_modules
                       ,hig_module_roles
                       ,hig_user_roles
                 WHERE  hmo_application       = hpr_product
                  AND   UPPER(hmo_module_type) IN (c_web,c_fmx,c_dis,c_url)
                  AND   hmo_module            = hmr_module
                  AND   hur_role              = hmr_role
                  AND   hur_username          = USER
                  AND   hmo_fastpath_invalid != 'Y'
                  AND   hmo_module           != c_this_module
                )
   ORDER BY hpr_sequence;
--
   CURSOR cs_modules (c_app VARCHAR2) IS
   SELECT hmo_module
         ,hmo_title
    FROM  hig_modules
         ,hig_module_roles
         ,hig_user_roles
   WHERE  hmo_application       = c_app
    AND   UPPER(hmo_module_type) IN (c_web,c_fmx,c_dis,c_url)
    AND   hmo_fastpath_invalid != 'Y'
    AND   hmo_module           != c_this_module
    AND   hmo_module            = hmr_module
    AND   hur_role              = hmr_role
    AND   hur_username          = USER
   GROUP BY hmo_title
           ,hmo_module;
--
   l_tab_huf_type   nm3type.tab_varchar4;
   l_tab_huf_child  nm3type.tab_varchar30;
   l_tab_huf_parent nm3type.tab_varchar30;
   l_tab_huf_descr  nm3type.tab_varchar2000;
   l_tab_huf_level  nm3type.tab_number;
--
   l_tab_hsf_type   nm3type.tab_varchar4;
   l_tab_hsf_child  nm3type.tab_varchar30;
   l_tab_hsf_parent nm3type.tab_varchar30;
   l_tab_hsf_descr  nm3type.tab_varchar2000;
   l_tab_hsf_level  nm3type.tab_number;
--
   l_tab_hmo_type   nm3type.tab_varchar4;
   l_tab_hmo_child  nm3type.tab_varchar30;
   l_tab_hmo_parent nm3type.tab_varchar30;
   l_tab_hmo_descr  nm3type.tab_varchar2000;
   l_tab_hmo_level  nm3type.tab_number;
--
   l_count  PLS_INTEGER := 0;
--
   c_launchpad VARCHAR2(9) := 'Launchpad';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'define_tree_favourites');
--
   OPEN  cs_sys_faves;
   FETCH cs_sys_faves
    BULK COLLECT INTO l_tab_hsf_type
                     ,l_tab_hsf_child
                     ,l_tab_hsf_parent
                     ,l_tab_hsf_descr
                     ,l_tab_hsf_level;
   CLOSE cs_sys_faves;
--
   OPEN  cs_user_faves (nm3user.get_user_id);
   FETCH cs_user_faves
    BULK COLLECT INTO l_tab_huf_type
                     ,l_tab_huf_child
                     ,l_tab_huf_parent
                     ,l_tab_huf_descr
                     ,l_tab_huf_level;
   CLOSE cs_user_faves;
--
   l_count := l_count + 1;
   l_tab_hmo_type(l_count)   := 'F';
   l_tab_hmo_child(l_count)  := c_launchpad;
   l_tab_hmo_parent(l_count) := Null;
   l_tab_hmo_descr(l_count)  := c_launchpad;
   l_tab_hmo_level(l_count)  := 1;
   FOR cs_rec IN cs_products
    LOOP
      l_count := l_count + 1;
      l_tab_hmo_type(l_count)   := 'F';
      l_tab_hmo_child(l_count)  := cs_rec.hpr_product;
      l_tab_hmo_parent(l_count) := c_launchpad;
      l_tab_hmo_descr(l_count)  := cs_rec.hpr_product_name;
      l_tab_hmo_level(l_count)  := 2;
      FOR cs_inner IN cs_modules (cs_rec.hpr_product)
       LOOP
         l_count := l_count + 1;
         l_tab_hmo_type(l_count)   := 'M';
         l_tab_hmo_child(l_count)  := cs_inner.hmo_module;
         l_tab_hmo_parent(l_count) := cs_rec.hpr_product;
         l_tab_hmo_descr(l_count)  := cs_inner.hmo_title;
         l_tab_hmo_level(l_count)  := 3;
      END LOOP;
   END LOOP;
--
   htp.p('// You can find instructions for this file here:');
   htp.p('// http://www.mmartins.com');
   htp.p('');
   htp.p('');
   htp.p('// Decide if the names are links or just the icons');
   htp.p('USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks');
   htp.p('');
   htp.p('// Decide if the tree is to start all open or just showing the root folders');
   htp.p('STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree');
   htp.p('');
   htp.p('foldersTree = gFld("<FONT SIZE=-1>Favourites</FONT>", "'||c_folder_link||'")');
   --
   append_faves (p_tab_type   => l_tab_hsf_type
                ,p_tab_child  => l_tab_hsf_child
                ,p_tab_parent => l_tab_hsf_parent
                ,p_tab_descr  => l_tab_hsf_descr
                ,p_tab_level  => l_tab_hsf_level
                );
   append_faves (p_tab_type   => l_tab_huf_type
                ,p_tab_child  => l_tab_huf_child
                ,p_tab_parent => l_tab_huf_parent
                ,p_tab_descr  => l_tab_huf_descr
                ,p_tab_level  => l_tab_huf_level
                );
   append_faves (p_tab_type   => l_tab_hmo_type
                ,p_tab_child  => l_tab_hmo_child
                ,p_tab_parent => l_tab_hmo_parent
                ,p_tab_descr  => l_tab_hmo_descr
                ,p_tab_level  => l_tab_hmo_level
                );
--
   nm_debug.proc_end(g_package_name,'define_tree_favourites');
--
END define_tree_favourites;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type   nm3type.tab_varchar4
                       ,p_tab_child  nm3type.tab_varchar30
                       ,p_tab_parent nm3type.tab_varchar30
                       ,p_tab_descr  nm3type.tab_varchar2000
                       ,p_tab_level  nm3type.tab_number
                       ) IS
--
   l_parent VARCHAR2(30);
--
   l_tab_vc nm3type.tab_varchar32767;
--
   FUNCTION is_childless (p_i PLS_INTEGER) RETURN BOOLEAN IS
      l_retval BOOLEAN;
   BEGIN
      IF NOT p_tab_parent.EXISTS(p_i+1)
       THEN
         l_retval := TRUE;
      ELSE
         l_retval := NOT (p_tab_parent(p_i+1) = p_tab_child(p_i));
      END IF;
      RETURN l_retval;
   END is_childless;
--
BEGIN
   FOR i IN 1..p_tab_level.COUNT
    LOOP
      IF p_tab_level(i) = 1
       THEN
         l_parent := 'foldersTree';
      ELSE
         l_parent := 'aux'||ltrim(to_char(p_tab_level(i)-1),' ');
      END IF;
      IF p_tab_type(i) = 'F'
       THEN
         IF NOT is_childless(i)
          THEN
            l_tab_vc(l_tab_vc.COUNT+1) := ' aux'||ltrim(to_char(p_tab_level(i)),' ')||' = insFld('||l_parent||', gFld("<FONT SIZE=-1>'||p_tab_descr(i)||'</FONT>", "'||c_folder_link||'"))';
         END IF;
      ELSE
         l_tab_vc(l_tab_vc.COUNT+1) := 'insDoc('||l_parent||', gLnk(0, "<FONT SIZE=-1>'||p_tab_descr(i)||'</FONT>", "'||g_package_name||'.run?pi_module='||p_tab_child(i)||'"))';
      END IF;
   END LOOP;
   nm3web.htp_tab_varchar(l_tab_vc);
END append_faves;
--
-----------------------------------------------------------------------------
--
PROCEDURE run (pi_module VARCHAR2) IS
--
   l_rec_hmo            hig_modules%ROWTYPE;
   l_new_url            nm3type.max_varchar2;
   l_password_reqd      BOOLEAN := FALSE;
   l_start_time         BINARY_INTEGER;
--
   c_instance_name CONSTANT VARCHAR2(30) := hig.get_sysopt('X_INSTANCE');
   c_timeout_secs  CONSTANT NUMBER       := hig.get_sysopt('X_TIMEOUT');
   l_user     VARCHAR2(30);
   l_password VARCHAR2(30);
--
   CURSOR cs_xras (c_user VARCHAR2, c_module VARCHAR2) IS
   SELECT xras_username
         ,xras_password
    FROM  xtnz_role_user_assocs
         ,hig_user_roles
   WHERE  hur_username = c_user
    AND   hur_role     = xras_role
    AND   EXISTS (SELECT 1
                   FROM  hig_module_roles
                  WHERE  hmr_module = c_module
                   AND   hmr_role   = xras_role
                 )
   ORDER BY xras_role;
--
   l_conn_str_forms nm3type.max_varchar2;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'run');
--
nm_debug.delete_debug(TRUE);
nm_debug.debug_on;
   nm3web.module_startup(c_this_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_this_module_title
              );
   htp.bodyopen;
   --
   l_rec_hmo := nm3get.get_hmo (pi_hmo_module => pi_module);
   --
   IF NOT nm3user.user_can_run_module (l_rec_hmo.hmo_module)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => 'Run '||l_rec_hmo.hmo_module
                    );
   END IF;
   --
   l_rec_hmo.hmo_module_type := UPPER(l_rec_hmo.hmo_module_type);
   --
   l_password_reqd := l_rec_hmo.hmo_module_type IN (c_fmx,c_dis);
   --
   IF l_password_reqd
    THEN
      OPEN  cs_xras (USER, pi_module);
      FETCH cs_xras INTO l_user, l_password;
      l_found := cs_xras%FOUND;
      CLOSE cs_xras;
      IF l_found
       THEN
         l_conn_str_forms := CHR(38)||'userid='||l_user||'/'||l_password||'@'||c_instance_name;
      ELSE
         l_conn_str_forms := Null;
         l_user           := Null;
         l_password       := Null;
      END IF;
   END IF;
   --
   IF l_rec_hmo.hmo_module_type = c_web
    THEN
      nm3web.run_module (pi_module => l_rec_hmo.hmo_module);
   ELSIF l_rec_hmo.hmo_module_type = c_dis
    THEN
      IF l_user IS NULL
       THEN -- if we don't have a "fake" user to logon as then dont try and logon
         SAVEPOINT before_update;
         UPDATE hig_option_values
          SET   hov_value = 'N'
         WHERE  hov_id    = 'DISPWDVIS'
          AND   hov_value = 'Y';
         l_found := SQL%ROWCOUNT > 0;
      END IF;
      l_new_url := nm3disco.get_run_command (pi_module         => l_rec_hmo.hmo_module
                                            ,pi_param_name     => Null
                                            ,pi_param_value    => Null
                                            ,pi_user_interface => c_web
                                            ,pi_disco_exe      => Null
                                            ,pi_user           => l_user
                                            ,pi_password       => l_password
                                            ,pi_tns            => c_instance_name
                                            );
      IF l_user IS NULL
       AND l_found
       THEN
         ROLLBACK TO before_update;
      END IF;
      nm3web.pop_url_and_back (p_url          => l_new_url
                              ,p_window_title => l_rec_hmo.hmo_title
                              ,p_width        => 800
                              ,p_height       => 600
                              ,p_scrollbars   => TRUE
                              ,p_resizable    => TRUE
                              );
   ELSIF l_rec_hmo.hmo_module_type = c_fmx
    THEN
      l_new_url := hig.get_sysopt('XFORMS_URL')||l_conn_str_forms||CHR(38)||'form='||l_rec_hmo.hmo_filename||'.fmx';
      nm3web.pop_url_and_back (p_url          => l_new_url
                              ,p_window_title => l_rec_hmo.hmo_title
                              ,p_width        => 100
                              ,p_height       => 50
                              );
   ELSIF l_rec_hmo.hmo_module_type = c_url
    THEN
      nm3web.pop_url_and_back (p_url          => l_rec_hmo.hmo_filename
                              ,p_window_title => l_rec_hmo.hmo_title
                              ,p_width        => 800
                              ,p_height       => 600
                              ,p_toolbar      => TRUE
                              ,p_location     => TRUE
                              ,p_directories  => TRUE
                              ,p_status       => TRUE
                              ,p_menubar      => TRUE
                              ,p_scrollbars   => TRUE
                              ,p_resizable    => TRUE
                              );
   ELSE
      htp.p('Unable to run module '||l_rec_hmo.hmo_module||'. Unknown module type '||l_rec_hmo.hmo_module_type);
   END IF;
   --
   htp.bodyclose;
   htp.htmlclose;
nm_debug.debug_off;
--
   nm_debug.proc_end(g_package_name,'run');
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END run;
--
-----------------------------------------------------------------------------
--
END xtnzweb_fav;
/
