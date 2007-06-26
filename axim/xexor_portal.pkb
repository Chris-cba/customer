CREATE OR REPLACE PACKAGE BODY xexor_portal AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_portal.pkb	1.1 03/15/05
--       Module Name      : xexor_portal.pkb
--       Date into SCCS   : 05/03/15 00:16:33
--       Date fetched Out : 07/06/06 14:37:32
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT portal package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xexor_portal.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xexor_portal';
--
   c_this_module     CONSTANT  hig_modules.hmo_module%TYPE := 'XEXORPORTAL0000';
   c_module_title    CONSTANT  hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_folder_link CONSTANT VARCHAR2(100) := Null; -- 'nm3web.empty_frame';
--
   c_download_link CONSTANT VARCHAR2(100) := nm3web.get_download_url(Null);
--
   c_web      CONSTANT VARCHAR2(3) := 'WEB';
   c_fmx      CONSTANT VARCHAR2(3) := 'FMX';
   c_dis      CONSTANT VARCHAR2(3) := 'DIS';
   c_url      CONSTANT VARCHAR2(3) := 'URL';
--
   c_normal_web_path  CONSTANT VARCHAR2(100) := hig.get_sysopt('NM3WEBHOST')||hig.get_sysopt('NM3WEBPATH')||'/';
   c_faq_start_branch CONSTANT VARCHAR2(100) := hig.get_sysopt('XFAQSTFOLD');
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type       nm3type.tab_varchar4
                       ,p_tab_child      nm3type.tab_varchar30
                       ,p_tab_parent     nm3type.tab_varchar30
                       ,p_tab_descr      nm3type.tab_varchar2000
                       ,p_tab_level      nm3type.tab_number
                       ,p_tab_is_hmo     nm3type.tab_varchar30
                       ,p_tab_folder_url nm3type.tab_varchar2000
                       );
--
-----------------------------------------------------------------------------
--
FUNCTION get_xpl (p_xpl_xpc_id NUMBER
                 ,p_xpl_id     NUMBER
                 ) RETURN xexor_portal_links%ROWTYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE module_startup(pi_module IN hig_modules.hmo_module%TYPE
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
PROCEDURE main IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'main');
--
   module_startup(c_this_module);
--
   nm3web.head(p_close_head => FALSE
              ,p_title      => c_module_title
              );
--   htp.bodyopen;
--
--   htp.p('<DIV ALIGN=CENTER>');
----
--   htp.tableopen;
--   FOR cs_xpc_rec IN (SELECT *
--                       FROM  xexor_portal_categories
--                      ORDER  BY xpc_id
--                     )
--    LOOP
--      htp.tablerowopen;
--      htp.tableheader(htf.big(cs_xpc_rec.xpc_text));
--      htp.tablerowclose;
--      FOR cs_xpl_rec IN (SELECT xpl_id
--                               ,xpl_text
--                          FROM  xexor_portal_links
--                         WHERE  xpl_xpc_id = cs_xpc_rec.xpc_id
--                         ORDER  BY xpl_id
--                        )
--       LOOP
--         htp.tablerowopen;
--         htp.p('<TD ALIGN=CENTER>');
--         htp.anchor (curl  => g_package_name||'.launch_xpl?p_xpl_xpc_id='||cs_xpc_rec.xpc_id||CHR(38)||'p_xpl_id='||cs_xpl_rec.xpl_id
--                    ,ctext => htf.small(cs_xpl_rec.xpl_text)
--                    );
--         htp.p('</TD>');
--         htp.tablerowclose;
--      END LOOP;
--   END LOOP;
--   htp.tableclose;
----
--   htp.p('</DIV>');
   htp.p('<FRAMESET cols="250,*"> ');
   htp.p('  <FRAME src="'||g_package_name||'.left_frame" name="treeframe" > ');
   htp.p('  <FRAME SRC="'||g_package_name||'.show_startup_image" name="basefrm"> ');
   htp.p('</FRAMESET>');
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
PROCEDURE show_startup_image IS
   c_startup_image_s CONSTANT VARCHAR2(255) := hig.get_sysopt('XSTIMG_S');
   c_startup_image_m CONSTANT VARCHAR2(255) := hig.get_sysopt('XSTIMG_M');
   c_startup_image_l CONSTANT VARCHAR2(255) := hig.get_sysopt('XSTIMG_L');
   c_image_width_s   CONSTANT PLS_INTEGER   := 640;
   c_image_height_s  CONSTANT PLS_INTEGER   := 480;
   c_image_width_m   CONSTANT PLS_INTEGER   := 800;
   c_image_height_m  CONSTANT PLS_INTEGER   := 600;
   c_image_width_l   CONSTANT PLS_INTEGER   := 1024;
   c_image_height_l  CONSTANT PLS_INTEGER   := 768;
BEGIN
--
   module_startup(c_this_module);
--
   nm3web.head(p_close_head => FALSE
              ,p_title      => c_module_title
              );
--
   htp.p('<TABLE WIDTH=100% HEIGHT=100%>');
   htp.p('<TR VALIGN=MIDDLE ALIGN=CENTER>');
   htp.p('<TD VALIGN=MIDDLE ALIGN=CENTER>');
--   htp.p('<SCRIPT LANGUAGE="JavaScript">');
--   htp.p('if (screen.height >= 1200 '||chr(38)||chr(38)||' screen.width >= 1600) {');
--   htp.p('document.write("<img src='||nm3flx.string(c_startup_image_l)||' border=0>");');
--   htp.p('}');
--   htp.p('else {');
--   htp.p('if (screen.height == 1024 '||chr(38)||chr(38)||' screen.width == 1280) {');
--   htp.p('document.write("<img src='||nm3flx.string(c_startup_image_m)||' border=0>");');
--   htp.p('}');
--   htp.p('else {');
--   htp.p('document.write("<img src='||nm3flx.string(c_startup_image_s)||' border=0>");');
--   htp.p('}');
--   htp.p('}');
--   htp.p('</SCRIPT>');
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('var resizeIt = 0, winW = '||c_image_width_s||', winH = '||c_image_height_s||', imageW = '||c_image_width_s||', imageH = '||c_image_height_s||', imagePath = "'||c_startup_image_s||'", resizeString = "", l_4_3 = (4/3);');
   htp.p('');
   htp.p(' if (navigator.appName=="Netscape") {');
   htp.p('  winW = window.innerWidth-16;');
   htp.p('  winH = window.innerHeight-16;');
   htp.p('  }');
   htp.p(' else {');
   htp.p('  winW = document.body.offsetWidth-20;');
   htp.p('  winH = document.body.offsetHeight-20;');
   htp.p(' }');
   htp.p('');
   htp.p('if (winH*l_4_3 >= winW) {');
   htp.p('   winH = winW/l_4_3');
   htp.p('}');
   htp.p('else {');
   htp.p('   winW = winH*l_4_3');
   htp.p('}');
   htp.p('');
   htp.p('if (winW >= '||c_image_width_l||') {');
   htp.p('   imageW = '||c_image_width_l||'');
   htp.p('   imageH = '||c_image_height_l||'');
   htp.p('   imagePath = "'||c_startup_image_l||'"');
   htp.p('}');
   htp.p('else {');
   htp.p('   if (winW >= '||c_image_width_m||') {');
   htp.p('      imageW = '||c_image_width_m||'');
   htp.p('      imageH = '||c_image_height_m||'');
   htp.p('      imagePath = "'||c_startup_image_m||'"');
   htp.p('   }');
   htp.p('}');
   htp.p('');
   htp.p('if (winH >= imageH) {');
   htp.p('   winH = imageH');
   htp.p('}');
   htp.p('if (winW >= imageW) {');
   htp.p('   winW = imageW');
   htp.p('}');
--   htp.p('if (winW <= imageW) {');
--   htp.p('   resizeIt = 1');
--   htp.p('}');
--   htp.p('if (winH <= imageH) {');
--   htp.p('   resizeIt = 1');
--   htp.p('}');
   htp.p('');
--   htp.p('if (resizeIt == 1) {');
   htp.p('resizeString = " WIDTH=" + winW + " HEIGHT=" + winH');
--   htp.p('}');
   htp.p('');
   htp.p('document.write("<img src=" + imagePath + resizeString  +" border=>");');
   htp.p('');
   htp.p('</SCRIPT>');
   htp.p('</TD>');
   htp.p('</TR>');
   htp.p('</TABLE>');
--
   htp.bodyclose;
--
   htp.htmlclose;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END show_startup_image;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xpl_url (p_xpl_xpc_id NUMBER
                     ,p_xpl_id     NUMBER
                     ) RETURN VARCHAR2 IS
--
   l_rec_xpl xexor_portal_links%ROWTYPE;
   l_url     nm3type.max_varchar2;
BEGIN
   l_rec_xpl := get_xpl (p_xpl_xpc_id => p_xpl_xpc_id
                        ,p_xpl_id     => p_xpl_id
                        );
   l_url := Null;
   IF l_rec_xpl.xpl_url IS NOT NULL
    THEN
      l_url := l_rec_xpl.xpl_url;
   ELSE
--      IF l_rec_xpl.xpl_module_dad IS NOT NULL
--       THEN
         l_url := '/pls/'||l_rec_xpl.xpl_module_dad||'/nm3web.run_module?pi_module='||l_rec_xpl.xpl_module;
--      ELSE
--         l_url := '/pls/'||l_rec_xpl.xpl_module_dad||'/nm3web.run_module?pi_module='||l_rec_xpl.xpl_module;
--         IF l_rec_xpl.xpl_link_style = 'P'
--          THEN
--            nm3web.pop_module_and_back (p_module       => l_rec_xpl.xpl_module
--                                       ,p_width        => l_rec_xpl.xpl_width
--                                       ,p_height       => l_rec_xpl.xpl_height
--                                       ,p_toolbar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_toolbar)
--                                       ,p_location     => nm3flx.char_to_boolean(l_rec_xpl.xpl_location)
--                                       ,p_directories  => nm3flx.char_to_boolean(l_rec_xpl.xpl_directories)
--                                       ,p_status       => nm3flx.char_to_boolean(l_rec_xpl.xpl_status)
--                                       ,p_menubar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_menubar)
--                                       ,p_scrollbars   => nm3flx.char_to_boolean(l_rec_xpl.xpl_scrollbars)
--                                       ,p_resizable    => nm3flx.char_to_boolean(l_rec_xpl.xpl_resizable)
--                                       );
--         ELSE
--            nm3web.run_module (pi_module => l_rec_xpl.xpl_module);
--         END IF;
--      END IF;
   END IF;
--
--   IF l_url IS NOT NULL
--    THEN
--      IF l_rec_xpl.xpl_link_style = 'P'
--       THEN
--         nm3web.pop_url_and_back (p_url          => l_url
--                                 ,p_window_title => l_rec_xpl.xpl_window_title
--                                 ,p_width        => l_rec_xpl.xpl_width
--                                 ,p_height       => l_rec_xpl.xpl_height
--                                 ,p_toolbar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_toolbar)
--                                 ,p_location     => nm3flx.char_to_boolean(l_rec_xpl.xpl_location)
--                                 ,p_directories  => nm3flx.char_to_boolean(l_rec_xpl.xpl_directories)
--                                 ,p_status       => nm3flx.char_to_boolean(l_rec_xpl.xpl_status)
--                                 ,p_menubar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_menubar)
--                                 ,p_scrollbars   => nm3flx.char_to_boolean(l_rec_xpl.xpl_scrollbars)
--                                 ,p_resizable    => nm3flx.char_to_boolean(l_rec_xpl.xpl_resizable)
--                                 );
--      ELSIF l_rec_xpl.xpl_link_style = 'S'
--       THEN
--         htp.p('<SCRIPT LANGUAGE=JavaScript>');
--         htp.p('  window.location.replace('||nm3flx.string(l_url)||');');
--         htp.p('</SCRIPT>');
--      END IF;
--   END IF;
   RETURN l_url;
END ;
--
-----------------------------------------------------------------------------
--
PROCEDURE launch_xpl (p_xpl_xpc_id NUMBER
                     ,p_xpl_id     NUMBER
                     ) IS
--
   l_rec_xpl xexor_portal_links%ROWTYPE;
   l_url     nm3type.max_varchar2;
--
BEGIN
--
   module_startup(c_this_module);
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   htp.bodyopen;
--
   l_rec_xpl := get_xpl (p_xpl_xpc_id => p_xpl_xpc_id
                        ,p_xpl_id     => p_xpl_id
                        );
--
   l_url := Null;
   IF l_rec_xpl.xpl_url IS NOT NULL
    THEN
      l_url := l_rec_xpl.xpl_url;
   ELSE
      IF l_rec_xpl.xpl_module_dad IS NOT NULL
       THEN
         l_url := '/pls/'||l_rec_xpl.xpl_module_dad||'/nm3web.run_module?pi_module='||l_rec_xpl.xpl_module;
      ELSE
         IF l_rec_xpl.xpl_link_style = 'P'
          THEN
            nm3web.pop_module_and_back (p_module       => l_rec_xpl.xpl_module
                                       ,p_width        => l_rec_xpl.xpl_width
                                       ,p_height       => l_rec_xpl.xpl_height
                                       ,p_toolbar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_toolbar)
                                       ,p_location     => nm3flx.char_to_boolean(l_rec_xpl.xpl_location)
                                       ,p_directories  => nm3flx.char_to_boolean(l_rec_xpl.xpl_directories)
                                       ,p_status       => nm3flx.char_to_boolean(l_rec_xpl.xpl_status)
                                       ,p_menubar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_menubar)
                                       ,p_scrollbars   => nm3flx.char_to_boolean(l_rec_xpl.xpl_scrollbars)
                                       ,p_resizable    => nm3flx.char_to_boolean(l_rec_xpl.xpl_resizable)
                                       );
         ELSE
            nm3web.run_module (pi_module => l_rec_xpl.xpl_module);
         END IF;
      END IF;
   END IF;
--
   IF l_url IS NOT NULL
    THEN
      IF l_rec_xpl.xpl_link_style = 'P'
       THEN
         nm3web.pop_url_and_back (p_url          => l_url
                                 ,p_window_title => l_rec_xpl.xpl_window_title
                                 ,p_width        => l_rec_xpl.xpl_width
                                 ,p_height       => l_rec_xpl.xpl_height
                                 ,p_toolbar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_toolbar)
                                 ,p_location     => nm3flx.char_to_boolean(l_rec_xpl.xpl_location)
                                 ,p_directories  => nm3flx.char_to_boolean(l_rec_xpl.xpl_directories)
                                 ,p_status       => nm3flx.char_to_boolean(l_rec_xpl.xpl_status)
                                 ,p_menubar      => nm3flx.char_to_boolean(l_rec_xpl.xpl_menubar)
                                 ,p_scrollbars   => nm3flx.char_to_boolean(l_rec_xpl.xpl_scrollbars)
                                 ,p_resizable    => nm3flx.char_to_boolean(l_rec_xpl.xpl_resizable)
                                 );
      ELSIF l_rec_xpl.xpl_link_style = 'S'
       THEN
         htp.p('<SCRIPT LANGUAGE=JavaScript>');
         htp.p('  window.location.replace('||nm3flx.string(l_url)||');');
         htp.p('</SCRIPT>');
      END IF;
   END IF;
--
   htp.bodyclose;
   htp.htmlclose;
--
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here THEN NULL;
  WHEN OTHERS
   THEN
     nm3web.failure(SQLERRM);
END launch_xpl;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xpl (p_xpl_xpc_id NUMBER
                 ,p_xpl_id     NUMBER
                 ) RETURN xexor_portal_links%ROWTYPE IS
   CURSOR cs_xpl IS
   SELECT *
    FROM  xexor_portal_links
   WHERE  xpl_xpc_id = p_xpl_xpc_id
    AND   xpl_id     = p_xpl_id;
   l_found   BOOLEAN;
   l_rec_xpl xexor_portal_links%ROWTYPE;
BEGIN
   OPEN  cs_xpl;
   FETCH cs_xpl INTO l_rec_xpl;
   l_found := cs_xpl%FOUND;
   CLOSE cs_xpl;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 67
                    );
   END IF;
   RETURN l_rec_xpl;
END get_xpl;
--
-----------------------------------------------------------------------------
--
PROCEDURE left_frame IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'left_frame');
--
   module_startup(c_this_module);
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_module_title
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
   --htp.p('<base target="_blank">');
   htp.p('');
   htp.p('</head>');
   htp.p('');
   htp.p('<body topmargin=16 marginheight=16>');
   htp.p('');
--
   htp.p('<!-- Removing this link will make the script stop working -->');
 --  htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:gray" href=http://www.mmartins.com target=_top></a></font></td></table></div>');
   htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-5><a style="font-size:1pt;text-decoration:none;color:gray" href="http://www.mmartins.com" target=_top></a></font></td></table></div>');
   htp.p('');
--
--   htp.p('<FONT SIZE=-2>');
--   FOR cs_rec IN  (SELECT *
--                    FROM  xexor_portal_categories
--                   ORDER  BY xpc_id
--                  )
--    LOOP
--      htp.p('<B>'||cs_rec.xpc_text||'</B><BR>');
--      FOR cs_inner IN (SELECT xpl_id
--                             ,xpl_text
--                             ,xpl_module
--                             ,xpl_link_style
--                             ,xpl_module_dad
--                        FROM  xexor_portal_links
--                       WHERE  xpl_xpc_id = cs_rec.xpc_id
--                       ORDER  BY xpl_id
--                      )
--       LOOP
--         htp.p(nm3web.c_nbsp||nm3web.c_nbsp||'<A HREF="'||get_xpl_url(cs_rec.xpc_id,cs_inner.xpl_id)||'" TARGET="_top">'||cs_inner.xpl_text||'</A><BR>');
--      END LOOP;
--   END LOOP;
--   htp.p('</FONT>');
   htp.p('<!-- Build the browsers objects and display default view of the');
   htp.p('     tree. -->');
   htp.p('<script>initializeDocument()</script>');
   htp.p('');
   htp.p('</html>');
--
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
   WHERE  hmo_module      = c_module
    AND   hmo_application = 'XFAQ';
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
   CURSOR cs_sys_faves IS
   SELECT hsf_type, hsf_child, hsf_parent, hsf_descr, LEVEL, 'TRUE', Null
   FROM HIG_SYSTEM_FAVOURITES
   WHERE nm3web_fav.allowable_web_form (hsf_type,hsf_child) = 'Y'
   CONNECT BY PRIOR hsf_child = hsf_parent
   --START WITH hsf_parent = 'ROOT';
   START WITH hsf_child = c_faq_start_branch
   ORDER SIBLINGS BY hsf_descr, hsf_child ASC;
--
   l_tab_hsf_type       nm3type.tab_varchar4;
   l_tab_hsf_child      nm3type.tab_varchar30;
   l_tab_hsf_parent     nm3type.tab_varchar30;
   l_tab_hsf_descr      nm3type.tab_varchar2000;
   l_tab_hsf_level      nm3type.tab_number;
   l_tab_hsf_is_hmo     nm3type.tab_varchar30;
   l_tab_hsf_folder_url nm3type.tab_varchar2000;
--
   l_tab_xpl_type   nm3type.tab_varchar4;
   l_tab_xpl_child  nm3type.tab_varchar30;
   l_tab_xpl_parent nm3type.tab_varchar30;
   l_tab_xpl_descr  nm3type.tab_varchar2000;
   l_tab_xpl_level  nm3type.tab_number;
   l_tab_xpl_is_hmo nm3type.tab_varchar30;
   l_tab_folder_url nm3type.tab_varchar2000;
--
   l_count  PLS_INTEGER := 0;
--
   c_launchpad VARCHAR2(30) := 'ACT DUS Portal';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'define_tree_favourites');
--
   FOR cs_rec IN  (SELECT *
                    FROM  xexor_portal_categories
                   ORDER  BY xpc_id
                  )
    LOOP
      l_count := l_count + 1;
      l_tab_xpl_type(l_count)   := 'F';
      l_tab_xpl_child(l_count)  := cs_rec.xpc_id;
      l_tab_xpl_parent(l_count) := Null;
      l_tab_xpl_descr(l_count)  := cs_rec.xpc_text;
      l_tab_xpl_level(l_count)  := 1;
      l_tab_xpl_is_hmo(l_count) := nm3type.c_false;
      l_tab_folder_url(l_count) := cs_rec.xpc_folder_url;
      FOR cs_inner IN (SELECT xpl_id
                             ,xpl_text
                             ,xpl_module
                             ,xpl_link_style
                             ,xpl_module_dad
                        FROM  xexor_portal_links
                       WHERE  xpl_xpc_id = cs_rec.xpc_id
                       ORDER  BY xpl_id
                      )
       LOOP
         l_count := l_count + 1;
         l_tab_xpl_type(l_count)   := 'M';
         l_tab_xpl_child(l_count)  := cs_inner.xpl_id;
         l_tab_xpl_parent(l_count) := cs_rec.xpc_id;
         l_tab_xpl_descr(l_count)  := cs_inner.xpl_text;
         l_tab_xpl_level(l_count)  := 2;
         l_tab_xpl_is_hmo(l_count) := nm3flx.boolean_to_char
                                      (cs_inner.xpl_module     IS NOT NULL
                                   AND cs_inner.xpl_module_dad IS     NULL
                                   AND cs_inner.xpl_link_style =  'S'
                                      );
         l_tab_folder_url(l_count) := Null;
      END LOOP;
   END LOOP;
--
   OPEN  cs_sys_faves;
   FETCH cs_sys_faves
    BULK COLLECT INTO l_tab_hsf_type
                     ,l_tab_hsf_child
                     ,l_tab_hsf_parent
                     ,l_tab_hsf_descr
                     ,l_tab_hsf_level
                     ,l_tab_hsf_is_hmo
                     ,l_tab_hsf_folder_url;
   CLOSE cs_sys_faves;
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
   htp.p('foldersTree = gFld("<FONT SIZE=-1>'||c_launchpad||'</FONT>", "'||g_package_name||'.show_startup_image")');
   --
   append_faves (p_tab_type       => l_tab_xpl_type
                ,p_tab_child      => l_tab_xpl_child
                ,p_tab_parent     => l_tab_xpl_parent
                ,p_tab_descr      => l_tab_xpl_descr
                ,p_tab_level      => l_tab_xpl_level
                ,p_tab_is_hmo     => l_tab_xpl_is_hmo
                ,p_tab_folder_url => l_tab_folder_url
                );
   append_faves (p_tab_type       => l_tab_hsf_type
                ,p_tab_child      => l_tab_hsf_child
                ,p_tab_parent     => l_tab_hsf_parent
                ,p_tab_descr      => l_tab_hsf_descr
                ,p_tab_level      => l_tab_hsf_level
                ,p_tab_is_hmo     => l_tab_hsf_is_hmo
                ,p_tab_folder_url => l_tab_hsf_folder_url
                );
--
   nm_debug.proc_end(g_package_name,'define_tree_favourites');
--
END define_tree_favourites;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type       nm3type.tab_varchar4
                       ,p_tab_child      nm3type.tab_varchar30
                       ,p_tab_parent     nm3type.tab_varchar30
                       ,p_tab_descr      nm3type.tab_varchar2000
                       ,p_tab_level      nm3type.tab_number
                       ,p_tab_is_hmo     nm3type.tab_varchar30
                       ,p_tab_folder_url nm3type.tab_varchar2000
                       ) IS
--
   l_parent VARCHAR2(30);
--
   l_tab_vc nm3type.tab_varchar32767;
   l_url    nm3type.max_varchar2;
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
--         IF NOT is_childless(i)
--          THEN
            l_tab_vc(l_tab_vc.COUNT+1) := ' aux'||ltrim(to_char(p_tab_level(i)),' ')||' = insFld('||l_parent||', gFld("<FONT SIZE=-1>'||p_tab_descr(i)||'</FONT>", "'||NVL(p_tab_folder_url(i),c_folder_link)||'"))';
--         END IF;
      ELSE
         l_url := Null;
         IF   p_tab_is_hmo.EXISTS(i)
          AND nm3flx.char_to_boolean(p_tab_is_hmo(i))
          THEN
            DECLARE
               l_rec_hmo hig_modules%ROWTYPE;
            BEGIN
               l_rec_hmo := nm3get.get_hmo (pi_hmo_module      => p_tab_child(i)
                                           ,pi_raise_not_found => FALSE
                                           );
               IF l_rec_hmo.hmo_module_type = c_url
                THEN
                  l_url := nm3get.get_hum (pi_hum_hmo_module  => l_rec_hmo.hmo_module
                                          ,pi_raise_not_found => FALSE
                                          ).hum_url;
               ELSE
                  l_url := c_normal_web_path||'nm3web.run_module?pi_module='||p_tab_child(i);
               END IF;
            END;
         ELSE
            l_url := g_package_name||'.launch_xpl?p_xpl_xpc_id='||p_tab_parent(i)||CHR(38)||'p_xpl_id='||p_tab_child(i);
        --   l_url := get_xpl_url(p_tab_parent(i),p_tab_child(i));
         END IF;
         l_tab_vc(l_tab_vc.COUNT+1) := 'insDoc('||l_parent||', gLnk(0, "<FONT SIZE=-1>'||p_tab_descr(i)||'</FONT>", "'||l_url||'"))';
      END IF;
   END LOOP;
   nm3web.htp_tab_varchar(l_tab_vc);
END append_faves;
--
-----------------------------------------------------------------------------
--
PROCEDURE module_startup(pi_module IN hig_modules.hmo_module%TYPE
                        ) IS

  l_hmo_rec hig_modules%ROWTYPE;
  l_hpr_rec hig_products%ROWTYPE;
  l_mode    hig_module_roles.hmr_mode%TYPE;
  l_title1  nm3type.max_varchar2;
  l_title2  nm3type.max_varchar2;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'module_startup');

  --module security
  nm3web.user_can_run_module_web(p_module => pi_module);

  --get module details
  hig.get_module_details(pi_module => pi_module
                        ,po_hmo    => l_hmo_rec
                        ,po_mode   => l_mode);
--
  l_hpr_rec := hig.get_hpr(pi_product => l_hmo_rec.hmo_application);

  --set module details in v%session
  dbms_application_info.set_module(module_name => l_hmo_rec.hmo_application
                                  ,action_name => pi_module);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'module_startup');
END module_startup;
--
-----------------------------------------------------------------------------
--
END xexor_portal;
/
