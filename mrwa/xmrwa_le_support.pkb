CREATE OR REPLACE PACKAGE BODY xmrwa_le_support IS--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_le_support.pkb	1.1 03/15/05
--       Module Name      : xmrwa_le_support.pkb
--       Date into SCCS   : 05/03/15 00:45:36
--       Date fetched Out : 07/06/06 14:38:22
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xmrwa_le_support.pkb	1.1 03/15/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name CONSTANT VARCHAR2(30) := 'xmrwa_le_support';
--
   c_application_owner CONSTANT user_users.username%TYPE  := hig.get_application_owner;
   c_server_name       CONSTANT v$instance.host_name%TYPE := NVL(hig.get_sysopt('SDESERVER')
                                                                ,nm3context.get_context(pi_attribute=>'HOST_NAME')
                                                                );
   c_sde_service       CONSTANT varchar2(80)              := NVL(hig.get_sysopt('SDEINST')
                                                                ,'esri_sde'
                                                                );
   c_file_dest         CONSTANT hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('SDEBATDIR'),'c:');
   c_utlfiledir_set    CONSTANT BOOLEAN      := hig.get_sysopt('UTLFILEDIR') IS NOT NULL;
   c_run_now           CONSTANT boolean      := hig.get_sysopt('SDERUNLE')='Y';
   c_inv_view_slk      CONSTANT boolean      := hig.get_sysopt('INVVIEWSLK') = 'Y';
   c_carot             CONSTANT varchar2(2)  := '^';
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
---------------------------------------------------------------------------------
--
FUNCTION get_server_string(p_app_owner_pwd VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN ' -s '||c_server_name||' -i '||c_sde_service||' -u '||c_application_owner||' -p '||p_app_owner_pwd;
END get_server_string;
--
---------------------------------------------------------------------------------
--
PROCEDURE create_batch_file (p_inv_type VARCHAR2,p_app_owner_pwd VARCHAR2) IS
--
   c_connect_string CONSTANT nm3type.max_varchar2 := get_server_string(p_app_owner_pwd);
   c_view_name      CONSTANT VARCHAR2(30)         := nm3inv_sde.get_inv_sde_view_name(p_inv_type);
   c_table_name     CONSTANT VARCHAR2(30)         := nm3inv_sde.get_inv_sde_table_name(p_inv_type);
   c_inv_view_name  CONSTANT VARCHAR2(30)         := nm3inv_view.derive_inv_type_view_name(p_inv_type);
--
   l_tab_lines nm3type.tab_varchar32767;
--
   l_tab_source nm3type.tab_varchar80;
   l_tab_alias  nm3type.tab_varchar30;
   l_comma      VARCHAR2(10);
   l_rec_nit    nm_inv_types%ROWTYPE;
--
   l_au_join    BOOLEAN;
--
   PROCEDURE add_pair (p_source VARCHAR2, p_alias VARCHAR2) IS
      c CONSTANT PLS_INTEGER := l_tab_source.COUNT+1;
   BEGIN
      l_tab_source(c) := p_source;
      l_tab_alias(c)  := p_alias;
   END add_pair;
--
   PROCEDURE add_line (p_text VARCHAR2, p_carot BOOLEAN DEFAULT TRUE) IS
   BEGIN
      l_tab_lines(l_tab_lines.COUNT+1) := p_text||nm3flx.i_t_e(p_carot,c_carot,Null);
   END add_line;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_batch_file');
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => p_inv_type);
--
   add_pair (c_table_name||'.ROUTE_NE_UNIQUE','ROAD_NO');
   IF l_rec_nit.nit_pnt_or_cont = 'C'
    THEN
      add_pair (c_table_name||'.ROUTE_SLK_START','START_SLK');
      add_pair (c_table_name||'.ROUTE_SLK_END','END_SLK');
   ELSE
      add_pair (c_table_name||'.ROUTE_SLK_START','SLK');
   END IF;
   --
   add_pair ('NM_ELEMENTS_ALL.NE_SUB_CLASS','CWAY');
   --
   IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
    THEN
      add_pair (c_inv_view_name||'.IIT_X_SECT','XSP');
   END IF;
   --
   add_pair (c_inv_view_name||'.IIT_START_DATE','START_DATE');
   add_pair (c_inv_view_name||'.IIT_DATE_MODIFIED','LAST_MODIFIED_DATE');
   add_pair (c_inv_view_name||'.IIT_MODIFIED_BY','LAST_MODIFIED_BY');
   --
   DECLARE
      l_no_col EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_no_col,-20200);
   BEGIN
      IF nm3ddl.get_column_details ('NAU_UNIT_CODE',c_inv_view_name).owner IS NOT NULL
       THEN
         add_pair (c_inv_view_name||'.NAU_UNIT_CODE','ADMIN_UNIT');
         l_au_join := FALSE;
      ELSE
         RAISE l_no_col; -- just in case the function is ever changed not to raise an error
      END IF;
   EXCEPTION
      WHEN l_no_col
       THEN
         add_pair ('NM_ADMIN_UNITS.NAU_UNIT_CODE','ADMIN_UNIT');
         l_au_join := TRUE;
   END;
   --
   FOR cs_rec IN (SELECT ita_view_col_name
                        ,ita_view_attri
                   FROM  nm_inv_type_attribs
                  WHERE  ita_inv_type = p_inv_type
                  ORDER BY ita_disp_seq_no
                 )
    LOOP
      add_pair (c_inv_view_name||'.'||cs_rec.ita_view_col_name,cs_rec.ita_view_attri);
   END LOOP;
   add_pair (c_table_name||'.SHAPE','SHAPE');
--
   add_line ('@echo off',FALSE);
   add_line ('REM delete the existing SDE view if its there',FALSE);
   add_line ('sdetable -o delete -t '||c_view_name||c_connect_string||' -N',FALSE);
   add_line ('REM create the new SDE view',FALSE);
   add_line ('sdetable -o create_view'||c_connect_string);
   add_line (' -T '||c_view_name);
   add_line (' -t "'||c_table_name||','||c_inv_view_name||',NM_ELEMENTS_ALL'||nm3flx.i_t_e(l_au_join,',NM_ADMIN_UNITS',Null)||'"');
   add_line (' -w "'||c_table_name||'.iit_ne_id='||c_inv_view_name||'.iit_ne_id AND NM_ELEMENTS_ALL.ne_id='||c_table_name||'.NE_ID_OF'||nm3flx.i_t_e(l_au_join,' AND '||c_inv_view_name||'.iit_admin_unit = NM_ADMIN_UNITS.NAU_ADMIN_UNIT',Null)||'"');
   l_comma := ' -c ';
   FOR i IN 1..l_tab_source.COUNT
    LOOP
      add_line (l_comma||l_tab_source(i));
      l_comma := ',';
   END LOOP;
   l_comma := ' -a ';
   FOR i IN 1..l_tab_alias.COUNT
    LOOP
      add_line (l_comma||l_tab_alias(i),i!=l_tab_alias.COUNT);
      l_comma := ',';
   END LOOP;
  -- l_tab_lines(l_tab_lines.COUNT) := l_tab_lines(l_tab_lines.COUNT)||c_connect_string;
   nm3file.write_file (location       => c_file_dest
                      ,filename       => LOWER('mrwa_loadevents.'||c_view_name||'.bat')
                      ,max_linesize   => 32767
                      ,all_lines      => l_tab_lines
                      );
--
   nm_debug.proc_start(g_package_name,'create_batch_file');
--
END create_batch_file;
--
---------------------------------------------------------------------------------
--
PROCEDURE create_all_batch_files (p_app_owner_pwd VARCHAR2) IS
   l_tab_nit nm3type.tab_varchar4;
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_batch_files');
--
   SELECT nit_inv_type
    BULK  COLLECT
    INTO  l_tab_nit
    FROM  nm_inv_types
   WHERE  nit_table_name IS NULL
    AND   EXISTS (SELECT 1
                   FROM  gis_themes_all
                  WHERE  gt_feature_table LIKE '%'||nm3inv_sde.get_inv_sde_view_name(nit_inv_type)
                 );
--
   FOR i IN 1..l_tab_nit.COUNT
    LOOP
      create_batch_file (l_tab_nit(i),p_app_owner_pwd);
   END LOOP;
--
   nm_debug.proc_start(g_package_name,'create_all_batch_files');
--
END create_all_batch_files;
--
---------------------------------------------------------------------------------
--
END xmrwa_le_support;
/
