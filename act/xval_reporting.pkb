CREATE OR REPLACE PACKAGE BODY xval_reporting AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xval_reporting.pkb	1.1 03/14/05
--       Module Name      : xval_reporting.pkb
--       Date into SCCS   : 05/03/14 23:11:29
--       Date fetched Out : 07/06/06 14:33:57
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Valuations reporting package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xval_reporting.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xval_reporting';
--
   c_module       CONSTANT hig_modules.hmo_module%TYPE := 'XVALWEB0060';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_module);
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
   htp.p('--       sccsid           : @(#)xval_reporting.pkb	1.1 03/14/05');
   htp.p('--       Module Name      : xval_reporting.pkb');
   htp.p('--       Date into SCCS   : 05/03/14 23:11:29');
   htp.p('--       Date fetched Out : 07/06/06 14:33:57');
   htp.p('--       SCCS Version     : 1.1');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Valuations reporting package');
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
PROCEDURE main IS
--
   l_tab_dq_id    nm3type.tab_number;
   l_tab_dq_title nm3type.tab_varchar80;
   l_tab_dq_descr nm3type.tab_varchar80;
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
   nm3web.module_startup(c_module);
--
   SELECT dq_id
         ,dq_title
         ,dq_descr
    BULK  COLLECT
    INTO  l_tab_dq_id
         ,l_tab_dq_title
         ,l_tab_dq_descr
    FROM  xval_valuation_reports
         ,doc_query
   WHERE  dq_title = xvr_dq_title
   ORDER BY xvr_seq_no;
--
   IF l_tab_dq_id.COUNT = 0
    THEN
      xval_find_inv.js_ner_and_back
                          (pi_appl               => nm3type.c_net
                          ,pi_id                 => 326
                          );
   END IF;
--
   htp.tableopen (cattributes => 'ALIGN=CENTER');
   --
   htp.formopen('dm3query.show_query_in_own_page');
   htp.formhidden ('p_module',c_module);
   htp.formhidden ('p_module_title',c_module_title);
   htp.tablerowopen;
   htp.tabledata(c_select_report);
   htp.p('<TD>');
      htp.p('<SELECT NAME="p_dq_id">');
      FOR i IN 1..l_tab_dq_id.COUNT
       LOOP
         htp.p('<OPTION VALUE="'||l_tab_dq_id(i)||'">'||l_tab_dq_title(i)||' - '||l_tab_dq_descr(i)||'</OPTION>');
      END LOOP;
      htp.p('</SELECT>');
   htp.p('</TD>');
   htp.tabledata (htf.formsubmit (cvalue=>c_run));
   htp.tablerowclose;
   htp.formclose;
   --
   htp.tableclose;
--
--
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
END xval_reporting;
/
