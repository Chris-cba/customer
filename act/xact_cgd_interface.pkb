CREATE OR REPLACE PACKAGE BODY xact_cgd_interface AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_cgd_interface.pkb	1.1 03/14/05
--       Module Name      : xact_cgd_interface.pkb
--       Date into SCCS   : 05/03/14 23:10:50
--       Date fetched Out : 07/06/06 14:33:40
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT CGD Interface package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xact_cgd_interface.pkb	1.1 03/14/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xact_cgd_interface';
   c_app_owner CONSTANT VARCHAR2(30) := hig.get_application_owner;
   c_block_table CONSTANT VARCHAR2(30) := 'BLOCK';
--
   c_addr_inv_type    CONSTANT VARCHAR2(4) := 'ADDR';
   c_nt_type_block    CONSTANT VARCHAR2(4) := 'BLCK';
   c_nt_type_section  CONSTANT VARCHAR2(4) := 'BSEC';
   c_nt_type_division CONSTANT VARCHAR2(4) := 'BDIV';
   c_nt_type_district CONSTANT VARCHAR2(4) := 'BDIS';
--
   c_gty_group_type_district CONSTANT VARCHAR2(4) := c_nt_type_district;
   c_gty_group_type_division CONSTANT VARCHAR2(4) := c_nt_type_division;
   c_gty_group_type_section  CONSTANT VARCHAR2(4) := c_nt_type_section;
   c_federation              CONSTANT DATE := TO_DATE('01011901','DDMMYYYY');
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
FUNCTION get_view_name_from_cgd_table (p_table VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN UPPER('XACT_'||SUBSTR(p_table,1,19)||'_CGD_V');
END get_view_name_from_cgd_table;
--
-----------------------------------------------------------------------------
--
FUNCTION do_db_link RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   IF c_db_link_name IS NOT NULL
    THEN
      l_retval := '@'||c_db_link_name;
   END IF;
   RETURN l_retval;
END do_db_link;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_cgd_view (p_table VARCHAR2, p_inv_type VARCHAR2, p_del_inv_type BOOLEAN DEFAULT FALSE) IS
--
   c_view_name      CONSTANT VARCHAR2(30) := get_view_name_from_cgd_table(p_table);
   c_owner_dot_view CONSTANT VARCHAR2(61) := c_app_owner||'.'||c_view_name;
   l_spatial_col VARCHAR2(30);
   l_pk_col      VARCHAR2(30);
--
--
   l_rec_nit  nm_inv_types%ROWTYPE;
   l_rec_ita  nm_inv_type_attribs%ROWTYPE;
   l_rec_itr  nm_inv_type_roles%ROWTYPE;
   l_rec_nth  nm_themes_all%ROWTYPE;
   l_rec_ntf  nm_theme_functions_all%ROWTYPE;
   l_rec_nith nm_inv_themes%ROWTYPE;
--
   l_tab_atc   nm3ddl.tab_atc;
   l_rec_atc   all_tab_columns%ROWTYPE;
   l_cur       nm3type.ref_cursor;
--
   l_sql       nm3type.max_varchar2;
--
   l_owner     all_indexes.owner%TYPE;
   l_index     user_indexes.index_name%TYPE;
   l_unq       user_indexes.uniqueness%TYPE;
   l_col       user_ind_columns.column_name%TYPE;
--
   l_tab_own   nm3type.tab_varchar30;
   l_tab_ix    nm3type.tab_varchar30;
   l_tab_unq   nm3type.tab_varchar30;
   l_tab_col   nm3type.tab_varchar30;
--
   c_section_block_col CONSTANT VARCHAR2(30) := 'SECTION_BLOCK';
   c_block_section_col CONSTANT VARCHAR2(30) := 'BLOCK_SECTION';
   c_block_sec_sub_col CONSTANT VARCHAR2(30) := 'BLOCK_SECTION_SUBURB';
   c_sep               CONSTANT VARCHAR2(1)  := '/';
--
   CURSOR cs_theme (c_theme_name VARCHAR2) IS
   SELECT 1
    FROM  user_sdo_themes
   WHERE  name = c_theme_name;
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
   l_tab_analyse_suffix nm3type.tab_varchar30;
--
   CURSOR cs_sgm (c_table_name VARCHAR2) IS
   SELECT 1
    FROM  user_sdo_geom_metadata
   WHERE  table_name = c_table_name;
--
   PROCEDURE drop_thing (p_type VARCHAR2) IS
   BEGIN
      IF nm3ddl.does_object_exist (c_view_name,p_type)
       THEN
         EXECUTE IMMEDIATE 'DROP '||p_type||' '||c_view_name;
      END IF;
   END drop_thing;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_cgd_view');
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--
   drop_thing('VIEW');
   drop_thing('MATERIALIZED VIEW');
   drop_thing('TABLE');
--
   l_sql := 'CREATE TABLE '||c_owner_dot_view||' AS SELECT * FROM ';
   IF c_cgd_schema IS NOT NULL
    THEN
      l_sql := l_sql||c_cgd_schema||'.';
   END IF;
   l_sql := l_sql||p_table||do_db_link||' UNRECOVERABLE';
      nm_debug.debug(l_sql);
   EXECUTE IMMEDIATE l_sql;
--
   nm3ddl.create_synonym_for_object (c_view_name);
--
   l_tab_atc := nm3ddl.get_all_columns_for_table (c_view_name);
--
   IF p_inv_type IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'ALTER TABLE '||c_owner_dot_view||' ADD (XNE_ID NUMBER(9) DEFAULT 1 NOT NULL, XBEGIN_MP NUMBER DEFAULT 0 NOT NULL, XEND_MP NUMBER DEFAULT 0 NOT NULL)';
   END IF;
--
   IF p_table = c_block_table
    THEN
      EXECUTE IMMEDIATE   'ALTER TABLE '||c_owner_dot_view||' ADD ('||c_section_block_col||' VARCHAR2(8),'||c_block_section_col||' VARCHAR2(8), '||c_block_sec_sub_col||' VARCHAR2(39))';
      l_sql :=            'BEGIN'
               ||CHR(10)||'   UPDATE '||c_owner_dot_view
               ||CHR(10)||'    SET   DIVISION_NAME = SUBSTR('||nm3flx.string('RURAL ')||'||DISTRICT_NAME,1,30)'
               ||CHR(10)||'   WHERE  DIVISION_NAME IS NULL;'
               ||CHR(10)||'   UPDATE '||c_owner_dot_view
               ||CHR(10)||'    SET   '||c_section_block_col||' = SECTION_NUMBER||'||nm3flx.string(c_sep)||'||BLOCK_NUMBER'
               ||CHR(10)||'         ,'||c_block_section_col||' = BLOCK_NUMBER||'||nm3flx.string(c_sep)||'||SECTION_NUMBER'
               ||CHR(10)||'         ,'||c_block_sec_sub_col||' = BLOCK_NUMBER||'||nm3flx.string(c_sep)||'||SECTION_NUMBER||'||nm3flx.string(c_sep)||'||DIVISION_NAME;'
               ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_sql;
      EXECUTE IMMEDIATE 'ALTER TABLE '||c_owner_dot_view||' MODIFY ('||c_section_block_col||' NOT NULL, '||c_block_section_col||' NOT NULL, '||c_block_sec_sub_col||' NOT NULL)';
      EXECUTE IMMEDIATE 'CREATE INDEX '||c_app_owner||'.'||SUBSTR(c_view_name,1,25)||'_IX98'||' ON '||c_owner_dot_view||'('||c_section_block_col||') UNRECOVERABLE';
      EXECUTE IMMEDIATE 'CREATE INDEX '||c_app_owner||'.'||SUBSTR(c_view_name,1,25)||'_IX99'||' ON '||c_owner_dot_view||'('||c_block_section_col||') UNRECOVERABLE';
      EXECUTE IMMEDIATE 'CREATE INDEX '||c_app_owner||'.'||SUBSTR(c_view_name,1,25)||'_IX97'||' ON '||c_owner_dot_view||'('||c_block_sec_sub_col||') UNRECOVERABLE';
   END IF;
--
   FOR i IN 1..l_tab_atc.COUNT
    LOOP
      l_rec_atc := l_tab_atc(i);
      IF i = 1
       THEN
         l_pk_col := l_rec_atc.column_name;
      ELSIF l_rec_atc.data_type  = 'SDO_GEOMETRY'
       THEN
         l_spatial_col := l_rec_atc.column_name;
      END IF;
   END LOOP;
  --
   OPEN  cs_sgm (c_view_name);
   FETCH cs_sgm INTO l_dummy;
   l_found := cs_sgm%FOUND;
   CLOSE cs_sgm;
   --
   IF NOT l_found
    THEN
      l_sql :=                'INSERT INTO user_sdo_geom_metadata'
                   ||CHR(10)||'      (table_name'
                   ||CHR(10)||'      ,column_name'
                   ||CHR(10)||'      ,diminfo'
                   ||CHR(10)||'      ,srid'
                   ||CHR(10)||'      )'
                   ||CHR(10)||'SELECT :c_view_name'
                   ||CHR(10)||'      ,column_name'
                   ||CHR(10)||'      ,diminfo'
                   ||CHR(10)||'      ,srid'
                   ||CHR(10)||' FROM  '||c_mdsys_schema||'.all_sdo_geom_metadata'||do_db_link
                   ||CHR(10)||'WHERE  owner = '||nm3flx.string(c_cgd_schema)||' AND table_name = :p_table';
      EXECUTE IMMEDIATE l_sql USING c_view_name, p_table;
--
      clone_sde_metadata (p_table,c_view_name);
--
   END IF;
--
   EXECUTE IMMEDIATE 'CREATE INDEX '||c_app_owner||'.'||SUBSTR(c_view_name,1,25)||'_SPPK'||' ON '||c_owner_dot_view||'('||l_spatial_col||') INDEXTYPE IS MDSYS.SPATIAL_INDEX';
--
   l_sql  :=   'SELECT owner, index_name, uniqueness FROM all_indexes'||do_db_link
             ||' WHERE owner = '||nm3flx.string(c_cgd_schema)||' AND table_name = :c_table_name AND index_type='||nm3flx.string('NORMAL');
--
      nm_debug.debug(l_sql);
   OPEN  l_cur FOR l_sql USING p_table;
   LOOP
      --
      FETCH l_cur INTO l_owner, l_index, l_unq;
      EXIT WHEN l_cur%NOTFOUND;
      --
      l_tab_own (l_cur%ROWCOUNT) := l_owner;
      l_tab_ix (l_cur%ROWCOUNT)  := l_index;
      l_tab_unq (l_cur%ROWCOUNT) := l_unq;
      --
   END LOOP;
   CLOSE l_cur;
--
   FOR i IN 1..l_tab_own.COUNT
    LOOP
      l_tab_col.DELETE;
      l_sql := 'SELECT column_name FROM all_ind_columns'||do_db_link
             ||' WHERE index_owner=:owner AND index_name=:ix_name ORDER BY column_position';
      OPEN  l_cur FOR l_sql USING l_tab_own(i), l_tab_ix(i);
      LOOP
         FETCH l_cur INTO l_col;
         EXIT WHEN l_cur%NOTFOUND;
         l_tab_col(l_cur%ROWCOUNT) := l_col;
      END LOOP;
      CLOSE l_cur;
      l_sql := 'CREATE ';
      IF l_tab_unq(i) = 'UNIQUE'
       THEN
         l_sql := l_sql||l_tab_unq(i)||' ';
      END IF;
      l_sql := l_sql||'INDEX '||c_app_owner||'.X'||SUBSTR(l_tab_ix(i),1,29)||' ON '||c_owner_dot_view||'(';
      FOR j IN 1..l_tab_col.COUNT
       LOOP
         IF j > 1
          THEN
            l_sql := l_sql||',';
         END IF;
         l_sql := l_sql||l_tab_col(j);
      END LOOP;
      l_sql := l_sql||') UNRECOVERABLE';
      EXECUTE IMMEDIATE l_sql;
   END LOOP;
--
   IF p_inv_type IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'CREATE INDEX '||c_app_owner||'.'||SUBSTR(c_view_name,1,25)||'_IX'||' ON '||c_owner_dot_view||'(xne_id)';
   END IF;
--
   l_tab_analyse_suffix(1) := Null;
   l_tab_analyse_suffix(2) := ' FOR ALL COLUMNS';
   l_tab_analyse_suffix(3) := ' FOR ALL INDEXES';
--
   FOR i IN 1..l_tab_analyse_suffix.COUNT
    LOOP
      EXECUTE IMMEDIATE 'ANALYZE TABLE '||c_owner_dot_view||' COMPUTE STATISTICS'||l_tab_analyse_suffix(i);
   END LOOP;
--
   IF p_inv_type IS NOT NULL
    AND (nm3get.get_nit (pi_nit_inv_type    => p_inv_type
                        ,pi_raise_not_found => FALSE
                        ).nit_inv_type IS NULL
         OR p_del_inv_type
        )
    THEN
    --
      l_rec_nit.nit_inv_type             := p_inv_type;
      l_rec_nth.nth_theme_name           := REPLACE(p_table,'_',' ');
    --
      DELETE FROM nm_inv_type_roles
      WHERE itr_inv_type     = l_rec_nit.nit_inv_type;
    --
      DELETE FROM nm_inv_type_attribs
      WHERE ita_inv_type     = l_rec_nit.nit_inv_type;
    --
      DELETE FROM nm_themes_all
      WHERE  nth_theme_name = l_rec_nth.nth_theme_name;
    --
      DELETE FROM nm_inv_types
      WHERE nit_inv_type     = l_rec_nit.nit_inv_type;
    --
      l_rec_nit.nit_pnt_or_cont                := 'P';
      l_rec_nit.nit_x_sect_allow_flag          := 'N';
      l_rec_nit.nit_elec_drain_carr            := 'C';
      l_rec_nit.nit_contiguous                 := 'N';
      l_rec_nit.nit_replaceable                := 'N';
      l_rec_nit.nit_exclusive                  := 'N';
      l_rec_nit.nit_category                   := 'F';
      l_rec_nit.nit_descr                      := p_table;
      l_rec_nit.nit_linear                     := 'N';
      l_rec_nit.nit_use_xy                     := 'N';
      l_rec_nit.nit_multiple_allowed           := 'N';
      l_rec_nit.nit_end_loc_only               := 'N';
      l_rec_nit.nit_screen_seq                 := 999;
      l_rec_nit.nit_view_name                  := Null;
      l_rec_nit.nit_start_date                 := c_federation;
      l_rec_nit.nit_end_date                   := Null;
      l_rec_nit.nit_short_descr                := Null;
      l_rec_nit.nit_flex_item_flag             := 'N';
      l_rec_nit.nit_table_name                 := c_view_name;
      l_rec_nit.nit_lr_ne_column_name          := 'XNE_ID';
      l_rec_nit.nit_lr_st_chain                := 'XBEGIN_MP';
      l_rec_nit.nit_lr_end_chain               := 'XEND_MP';
      l_rec_nit.nit_admin_type                 := 'NET';
      l_rec_nit.nit_icon_name                  := Null;
      l_rec_nit.nit_top                        := 'N';
      l_rec_nit.nit_foreign_pk_column          := l_pk_col;
      l_rec_nit.nit_update_allowed             := 'N';
      nm3ins.ins_nit (l_rec_nit);
      DECLARE
      BEGIN
         FOR i IN 1..l_tab_atc.COUNT
          LOOP
            l_rec_atc := l_tab_atc(i);
            IF l_rec_atc.data_type IN (nm3type.c_varchar,nm3type.c_number,nm3type.c_date)
             THEN
               l_rec_ita.ita_inv_type                   := l_rec_nit.nit_inv_type;
               l_rec_ita.ita_attrib_name                := l_rec_atc.column_name;
               l_rec_ita.ita_dynamic_attrib             := 'N';
               l_rec_ita.ita_disp_seq_no                := i;
               l_rec_ita.ita_mandatory_yn               := nm3flx.i_t_e (l_rec_atc.nullable='Y','N','Y');
               l_rec_ita.ita_format                     := l_rec_atc.data_type;
               IF l_rec_atc.data_type = nm3type.c_number
                THEN
                  l_rec_ita.ita_fld_length              := NVL(l_rec_atc.data_precision,38);
                  l_rec_ita.ita_dec_places              := l_rec_atc.data_scale;
               ELSE
                  l_rec_ita.ita_fld_length              := l_rec_atc.data_length;
                  l_rec_ita.ita_dec_places              := Null;
               END IF;
               l_rec_ita.ita_scrn_text                  := l_rec_atc.column_name;
               l_rec_ita.ita_id_domain                  := Null;
               l_rec_ita.ita_validate_yn                := 'N';
               l_rec_ita.ita_dtp_code                   := Null;
               l_rec_ita.ita_max                        := Null;
               l_rec_ita.ita_min                        := Null;
               l_rec_ita.ita_view_attri                 := l_rec_atc.column_name;
               l_rec_ita.ita_view_col_name              := l_rec_atc.column_name;
               l_rec_ita.ita_start_date                 := l_rec_nit.nit_start_date;
               l_rec_ita.ita_end_date                   := l_rec_nit.nit_end_date;
               l_rec_ita.ita_queryable                  := 'N';
               l_rec_ita.ita_ukpms_param_no             := Null;
               l_rec_ita.ita_units                      := Null;
               l_rec_ita.ita_format_mask                := Null;
               l_rec_ita.ita_exclusive                  := 'N';
               l_rec_ita.ita_keep_history_yn            := 'N';
               nm3ins.ins_ita (l_rec_ita);
            END IF;
         END LOOP;
      END;
      --
      l_rec_itr.itr_inv_type           := l_rec_nit.nit_inv_type;
      l_rec_itr.itr_hro_role           := 'HIG_USER';
      l_rec_itr.itr_mode               := nm3type.c_readonly;
      nm3ins.ins_itr (l_rec_itr);
      --
      l_rec_nth.nth_theme_id             := nm3seq.next_nth_theme_id_seq;
      l_rec_nth.nth_table_name           := c_view_name;
      l_rec_nth.nth_where                := Null;
      l_rec_nth.nth_pk_column            := l_pk_col;
      l_rec_nth.nth_label_column         := l_pk_col;
      l_rec_nth.nth_rse_table_name       := 'NM_ELEMENTS';
      l_rec_nth.nth_rse_fk_column        := Null;
      l_rec_nth.nth_st_chain_column      := Null;
      l_rec_nth.nth_end_chain_column     := Null;
      l_rec_nth.nth_x_column             := Null;
      l_rec_nth.nth_y_column             := Null;
      l_rec_nth.nth_offset_field         := Null;
      l_rec_nth.nth_feature_table        := c_view_name;
      l_rec_nth.nth_feature_pk_column    := l_pk_col;
      l_rec_nth.nth_feature_fk_column    := Null;
      l_rec_nth.nth_xsp_column           := Null;
      l_rec_nth.nth_feature_shape_column := l_spatial_col;
      l_rec_nth.nth_hpr_product          := nm3type.c_hig;
      l_rec_nth.nth_location_updatable   := 'N';
      l_rec_nth.nth_theme_type           := 'SDO';
      l_rec_nth.nth_base_theme           := Null;
      l_rec_nth.nth_dependency           := 'I';
      l_rec_nth.nth_storage              := 'S';
      l_rec_nth.nth_update_on_edit       := 'N';
      nm3ins.ins_nth (l_rec_nth);
      --
      l_rec_ntf.ntf_nth_theme_id         := l_rec_nth.nth_theme_id;
      l_rec_ntf.ntf_hmo_module           := 'NM0570';
      l_rec_ntf.ntf_parameter            := 'GIS_SESSION_ID';
      l_rec_ntf.ntf_menu_option          := nm3get.get_hmo (pi_hmo_module => l_rec_ntf.ntf_hmo_module).hmo_title;
      l_rec_ntf.ntf_seen_in_gis          := 'Y';
      nm3ins.ins_ntf (l_rec_ntf);
      --
      INSERT INTO nm_theme_roles
            (nthr_theme_id
            ,nthr_role
            ,nthr_mode
            )
      SELECT l_rec_nth.nth_theme_id
            ,itr_hro_role
            ,itr_mode
       FROM  nm_inv_type_roles
      WHERE  itr_inv_type = l_rec_nit.nit_inv_type;
      --
      l_rec_nith.nith_nit_id       := l_rec_nit.nit_inv_type;
      l_rec_nith.nith_nth_theme_id := l_rec_nth.nth_theme_id;
      nm3ins.ins_nith (l_rec_nith);
      --
      OPEN  cs_theme (l_rec_nth.nth_theme_name);
      FETCH cs_theme INTO l_dummy;
      l_found := cs_theme%FOUND;
      CLOSE cs_theme;
      --
      IF NOT l_found
       THEN
         create_sdo_theme_from_nth (pi_nth_theme_name => l_rec_nth.nth_theme_name
                                   ,pi_feature_style  => 'L.LIGHT DUTY'
                                   ,pi_label_style    => 'T.STREET NAME'
                                   ,pi_point_theme    => TRUE
                                   ,pi_map            => hig.get_sysopt('WEBMAPNAME')
                                   );
      END IF;
   END IF;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'add_cgd_view');
--
END add_cgd_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE maintain_all_cgd_data IS
   l_sql     nm3type.max_varchar2;
   l_cur     nm3type.ref_cursor;
   l_tab_tab nm3type.tab_varchar30;
   l_table   VARCHAR2(30);
BEGIN
--
   nm_debug.proc_start(g_package_name,'maintain_all_cgd_data');
--
   l_sql :=           'SELECT xct_table_name'
           ||CHR(10)||' FROM  xact_cgd_tables'
           ||CHR(10)||'      ,';
   IF c_cgd_schema IS NOT NULL
    THEN
      l_sql := l_sql||c_cgd_schema||'.';
   END IF;
   l_sql := l_sql||'cgd_physical_entity'||do_db_link
           ||CHR(10)||'WHERE  cgd_physical_table_name = xct_table_name'
           ||CHR(10)||' AND   last_update_date IS NOT NULL'
           ||CHR(10)||' AND   last_update_date > xct_last_refresh_date';
--
   OPEN  l_cur FOR l_sql;
   FETCH l_cur INTO l_table;
   WHILE l_cur%FOUND
    LOOP
      l_tab_tab(l_cur%ROWCOUNT) := l_table;
      FETCH l_cur INTO l_table;
   END LOOP;
   CLOSE l_cur;
--
   FOR i IN 1..l_tab_tab.COUNT
    LOOP
      refresh_cgd_data (p_table => l_tab_tab(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'maintain_all_cgd_data');
--
END maintain_all_cgd_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_cgd_data (p_table VARCHAR2) IS
   l_rec_xct xact_cgd_tables%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'refresh_cgd_data');
--
   l_rec_xct := get_xct (p_table);
--
   add_cgd_view (p_table        => l_rec_xct.xct_table_name
                ,p_inv_type     => l_rec_xct.xct_nit_inv_type
                ,p_del_inv_type => FALSE
                );
--
   UPDATE xact_cgd_tables
    SET   xct_last_refresh_date = SYSDATE
   WHERE  xct_table_name        = p_table;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'refresh_cgd_data');
--
END refresh_cgd_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xct (pi_xct_table_name  xact_cgd_tables.xct_table_name%TYPE
                 ,pi_raise_not_found BOOLEAN DEFAULT FALSE
                 ) RETURN xact_cgd_tables%ROWTYPE IS
--
   CURSOR cs_xct (c_xct_table_name xact_cgd_tables.xct_table_name%TYPE) IS
   SELECT *
    FROM  xact_cgd_tables
   WHERE  xct_table_name = c_xct_table_name;
--
   l_rec_xct xact_cgd_tables%ROWTYPE;
   l_found   BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_xct');
--
   OPEN  cs_xct (pi_xct_table_name);
   FETCH cs_xct INTO l_rec_xct;
   l_found := cs_xct%FOUND;
   CLOSE cs_xct;
--
   IF NOT l_found
    AND pi_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'xact_cgd_tables.xct_table_name="'||pi_xct_table_name||'"'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_xct');
--
   RETURN l_rec_xct;
--
END get_xct;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_maintain_cgd_job (p_next     DATE     DEFAULT (TRUNC(SYSDATE)+1)
                                  ,p_interval VARCHAR2 DEFAULT 'TRUNC(SYSDATE)+1'
                                  ) IS
--
   c_what CONSTANT user_jobs.what%TYPE := 'BEGIN'
                               ||CHR(10)||'   --'
                               ||CHR(10)||'   -- Keeps the CGD data up to date'
                               ||CHR(10)||'   --'
                               ||CHR(10)||'      '||g_package_name||'.maintain_all_cgd_data;'
                               ||CHR(10)||'   --'
                               ||CHR(10)||'END;';
   l_job_id        user_jobs.job%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'submit_maintain_cgd_job');
--
   nm3dbms_job.make_sure_processes_available;
--
   IF NOT nm3dbms_job.does_job_exist_by_what (c_what)
    THEN
      dbms_job.submit (job       => l_job_id
                      ,what      => c_what
                      ,next_date => p_next
                      ,interval  => p_interval
                      );
      COMMIT;
   END IF;
--
   nm_debug.proc_end(g_package_name,'submit_maintain_cgd_job');
--
END submit_maintain_cgd_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE clone_sde_metadata (p_remote_table VARCHAR2
                             ,p_local_table  VARCHAR2
                             ) IS
--
   l_cur   nm3type.ref_cursor;
   l_sql   nm3type.max_varchar2;
   l_found BOOLEAN;
--
   l_tr_rowid             ROWID;
   l_tr_rowid_column      nm3type.max_varchar2;
   l_tr_description       nm3type.max_varchar2;
   l_tr_object_flags       NUMBER;
   l_tr_registration_date NUMBER;
--
   l_l_rowid               ROWID;
   l_l_description         varchar2(65);
   l_l_spatial_column      varchar2(32);
   l_l_eflags              number(38);
   l_l_layer_mask          number(38);
   l_l_gsize1              float(64);
   l_l_gsize2              float(64);
   l_l_gsize3              float(64);
   l_l_minx                float(64);
   l_l_miny                float(64);
   l_l_maxx                float(64);
   l_l_maxy                float(64);
   l_l_cdate               number(38);
   l_l_layer_config        varchar2(32);
   l_l_optimal_array_size  number(38);
   l_l_stats_date          number(38);
   l_l_minimum_id          number(38);
   l_l_srid                number(38);
   l_l_base_layer_id       number(38);
--
   l_gc_rowid              ROWID;
   l_gc_f_table_catalog    varchar2(32);
   l_gc_f_geometry_column  varchar2(32);
   l_gc_g_table_catalog    varchar2(32);
   l_gc_storage_type       number(38);
   l_gc_geometry_type      number(38);
   l_gc_coord_dimension    number(38);
   l_gc_max_ppr            number(38);
   l_gc_srid               number(38);
--
   PROCEDURE get_sde_table_registry (p_table_name      VARCHAR2
                                    ,p_schema          VARCHAR2
                                    ,p_db_link         VARCHAR2
                                    ,p_raise_not_found BOOLEAN DEFAULT TRUE
                                    ) IS
   BEGIN
      l_sql :=           'SELECT ROWID, rowid_column,description,object_flags,registration_date'
              ||CHR(10)||' FROM  '||c_sde_schema||'.table_registry';
      IF p_db_link IS NOT NULL
       THEN
         l_sql := l_sql||'@'||p_db_link;
      END IF;
      l_sql := l_sql
              ||CHR(10)||'WHERE table_name = :table_name'
              ||CHR(10)||' AND  owner      = :owner';
      OPEN  l_cur FOR l_sql USING p_table_name, p_schema;
      l_tr_rowid := Null;
      FETCH l_cur INTO l_tr_rowid
                      ,l_tr_rowid_column
                      ,l_tr_description
                      ,l_tr_object_flags
                      ,l_tr_registration_date;
      l_found := l_cur%FOUND;
      CLOSE l_cur;
   --
      IF NOT l_found
       AND p_raise_not_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => c_sde_schema||'.table_registry'
                       );
      END IF;
   END get_sde_table_registry;
--
   PROCEDURE get_sde_layers (p_table_name      VARCHAR2
                            ,p_schema          VARCHAR2
                            ,p_db_link         VARCHAR2
                            ,p_raise_not_found BOOLEAN DEFAULT TRUE
                            ) IS
   BEGIN
      l_sql :=           'SELECT ROWID'
              ||CHR(10)||'      ,description'
              ||CHR(10)||'      ,spatial_column'
              ||CHR(10)||'      ,eflags'
              ||CHR(10)||'      ,layer_mask'
              ||CHR(10)||'      ,gsize1'
              ||CHR(10)||'      ,gsize2'
              ||CHR(10)||'      ,gsize3'
              ||CHR(10)||'      ,minx'
              ||CHR(10)||'      ,miny'
              ||CHR(10)||'      ,maxx'
              ||CHR(10)||'      ,maxy'
              ||CHR(10)||'      ,cdate'
              ||CHR(10)||'      ,layer_config'
              ||CHR(10)||'      ,optimal_array_size'
              ||CHR(10)||'      ,stats_date'
              ||CHR(10)||'      ,minimum_id'
              ||CHR(10)||'      ,srid'
              ||CHR(10)||'      ,base_layer_id'
              ||CHR(10)||' FROM  '||c_sde_schema||'.layers';
      IF p_db_link IS NOT NULL
       THEN
         l_sql := l_sql||'@'||p_db_link;
      END IF;
      l_sql := l_sql
              ||CHR(10)||'WHERE table_name = :table_name'
              ||CHR(10)||' AND  owner      = :owner';
      OPEN  l_cur FOR l_sql USING p_table_name, p_schema;
      l_l_rowid := Null;
      FETCH l_cur
       INTO l_l_rowid
           ,l_l_description
           ,l_l_spatial_column
           ,l_l_eflags
           ,l_l_layer_mask
           ,l_l_gsize1
           ,l_l_gsize2
           ,l_l_gsize3
           ,l_l_minx
           ,l_l_miny
           ,l_l_maxx
           ,l_l_maxy
           ,l_l_cdate
           ,l_l_layer_config
           ,l_l_optimal_array_size
           ,l_l_stats_date
           ,l_l_minimum_id
           ,l_l_srid
           ,l_l_base_layer_id;
      l_found := l_cur%FOUND;
      CLOSE l_cur;
   --
      IF NOT l_found
       AND p_raise_not_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => c_sde_schema||'.layers'
                       );
      END IF;
   --
   END get_sde_layers;
--
   PROCEDURE get_sde_geometry_columns (p_table_name      VARCHAR2
                                      ,p_schema          VARCHAR2
                                      ,p_db_link         VARCHAR2
                                      ,p_raise_not_found BOOLEAN DEFAULT TRUE
                                      ) IS
   BEGIN
      l_sql :=           'SELECT ROWID'
              ||CHR(10)||'      ,f_table_catalog'
              ||CHR(10)||'      ,f_geometry_column'
              ||CHR(10)||'      ,g_table_catalog'
              ||CHR(10)||'      ,storage_type'
              ||CHR(10)||'      ,geometry_type'
              ||CHR(10)||'      ,coord_dimension'
              ||CHR(10)||'      ,max_ppr'
              ||CHR(10)||'      ,srid'
              ||CHR(10)||' FROM  '||c_sde_schema||'.geometry_columns';
      IF p_db_link IS NOT NULL
       THEN
         l_sql := l_sql||'@'||p_db_link;
      END IF;
      l_sql := l_sql
              ||CHR(10)||'WHERE f_table_name   = :table_name'
              ||CHR(10)||' AND  f_table_schema = :owner';
      OPEN  l_cur FOR l_sql USING p_table_name, p_schema;
      l_gc_rowid := Null;
      FETCH l_cur
       INTO l_gc_rowid
           ,l_gc_f_table_catalog
           ,l_gc_f_geometry_column
           ,l_gc_g_table_catalog
           ,l_gc_storage_type
           ,l_gc_geometry_type
           ,l_gc_coord_dimension
           ,l_gc_max_ppr
           ,l_gc_srid;
      l_found := l_cur%FOUND;
      CLOSE l_cur;
   --
      IF NOT l_found
       AND p_raise_not_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => c_sde_schema||'.geometry_columns'
                       );
      END IF;
   END get_sde_geometry_columns;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'clone_sde_metadata');
--
   get_sde_table_registry (p_table_name      => p_local_table
                          ,p_schema          => c_app_owner
                          ,p_db_link         => Null
                          ,p_raise_not_found => FALSE
                          );
--
   IF l_tr_rowid IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'DELETE FROM '||c_sde_schema||'.table_registry WHERE ROWID = :l_ROWID' USING l_tr_rowid;
   END IF;
--
   get_sde_table_registry (p_table_name      => p_remote_table
                          ,p_schema          => c_cgd_schema
                          ,p_db_link         => c_db_link_name
                          ,p_raise_not_found => TRUE
                          );
--
   get_sde_layers (p_table_name      => p_local_table
                  ,p_schema          => c_app_owner
                  ,p_db_link         => Null
                  ,p_raise_not_found => FALSE
                  );
--
   IF l_l_rowid IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'DELETE FROM '||c_sde_schema||'.layers WHERE ROWID = :l_ROWID' USING l_l_rowid;
   END IF;
--
   get_sde_layers (p_table_name      => p_remote_table
                  ,p_schema          => c_cgd_schema
                  ,p_db_link         => c_db_link_name
                  ,p_raise_not_found => TRUE
                  );
--
   get_sde_geometry_columns (p_table_name      => p_local_table
                            ,p_schema          => c_app_owner
                            ,p_db_link         => Null
                            ,p_raise_not_found => FALSE
                            );
--
   IF l_gc_rowid IS NOT NULL
    THEN
      EXECUTE IMMEDIATE 'DELETE FROM '||c_sde_schema||'.geometry_columns WHERE ROWID = :l_ROWID' USING l_gc_rowid;
   END IF;
--
   get_sde_geometry_columns (p_table_name      => p_remote_table
                            ,p_schema          => c_cgd_schema
                            ,p_db_link         => c_db_link_name
                            ,p_raise_not_found => TRUE
                            );
--
   l_sql :=            'INSERT INTO '||c_sde_schema||'.table_registry'
            ||CHR(10)||'       (registration_id'
            ||CHR(10)||'       ,table_name'
            ||CHR(10)||'       ,owner'
            ||CHR(10)||'       ,rowid_column'
            ||CHR(10)||'       ,description'
            ||CHR(10)||'       ,object_flags'
            ||CHR(10)||'       ,registration_date'
            ||CHR(10)||'       ,config_keyword'
            ||CHR(10)||'       )'
            ||CHR(10)||'VALUES ('||c_sde_schema||'.table_id_generator.NEXTVAL'
            ||CHR(10)||'       ,'||nm3flx.string(p_local_table)
            ||CHR(10)||'       ,'||nm3flx.string(c_app_owner)
            ||CHR(10)||'       ,:rowid_column'
            ||CHR(10)||'       ,:description'
            ||CHR(10)||'       ,:object_flags'
            ||CHR(10)||'       ,:registration_date'
            ||CHR(10)||'       ,'||nm3flx.string(c_sde_sdo_keyword)
            ||CHR(10)||'       )';
   EXECUTE IMMEDIATE l_sql
    USING  l_tr_rowid_column
          ,l_tr_description
          ,l_tr_object_flags
          ,l_tr_registration_date;
--
   DECLARE
      l_db_link nm3type.max_varchar2;
   BEGIN
      IF c_db_link_name IS NOT NULL
       THEN
         l_db_link := '@'||c_db_link_name;
      END IF;
      l_sql :=         'INSERT INTO '||c_sde_schema||'.spatial_references'
            ||CHR(10)||'       (srid'
            ||CHR(10)||'       ,description'
            ||CHR(10)||'       ,auth_name'
            ||CHR(10)||'       ,auth_srid'
            ||CHR(10)||'       ,falsex'
            ||CHR(10)||'       ,falsey'
            ||CHR(10)||'       ,xyunits'
            ||CHR(10)||'       ,falsez'
            ||CHR(10)||'       ,zunits'
            ||CHR(10)||'       ,falsem'
            ||CHR(10)||'       ,munits'
            ||CHR(10)||'       ,srtext'
            ||CHR(10)||'       )'
            ||CHR(10)||'SELECT  cgd.srid'
            ||CHR(10)||'       ,cgd.description'
            ||CHR(10)||'       ,cgd.auth_name'
            ||CHR(10)||'       ,cgd.auth_srid'
            ||CHR(10)||'       ,cgd.falsex'
            ||CHR(10)||'       ,cgd.falsey'
            ||CHR(10)||'       ,cgd.xyunits'
            ||CHR(10)||'       ,cgd.falsez'
            ||CHR(10)||'       ,cgd.zunits'
            ||CHR(10)||'       ,cgd.falsem'
            ||CHR(10)||'       ,cgd.munits'
            ||CHR(10)||'       ,cgd.srtext'
            ||CHR(10)||' FROM   '||c_sde_schema||'.spatial_references'||l_db_link||' cgd'
            ||CHR(10)||'WHERE  NOT EXISTS (SELECT 1'
            ||CHR(10)||'                    FROM  '||c_sde_schema||'.spatial_references loc'
            ||CHR(10)||'                   WHERE  loc.srid = cgd.srid'
            ||CHR(10)||'                  )'
            ||CHR(10)||' AND   cgd.srid IN (:layer_srid,:base_layer_srid)';
      EXECUTE IMMEDIATE l_sql USING l_l_srid, l_l_base_layer_id;
   END;
--
   l_sql :=            'INSERT INTO '||c_sde_schema||'.layers'
            ||CHR(10)||'       (layer_id'
            ||CHR(10)||'       ,description'
            ||CHR(10)||'       ,database_name'
            ||CHR(10)||'       ,owner'
            ||CHR(10)||'       ,table_name'
            ||CHR(10)||'       ,spatial_column'
            ||CHR(10)||'       ,eflags'
            ||CHR(10)||'       ,layer_mask'
            ||CHR(10)||'       ,gsize1'
            ||CHR(10)||'       ,gsize2'
            ||CHR(10)||'       ,gsize3'
            ||CHR(10)||'       ,minx'
            ||CHR(10)||'       ,miny'
            ||CHR(10)||'       ,maxx'
            ||CHR(10)||'       ,maxy'
            ||CHR(10)||'       ,cdate'
            ||CHR(10)||'       ,layer_config'
            ||CHR(10)||'       ,optimal_array_size'
            ||CHR(10)||'       ,stats_date'
            ||CHR(10)||'       ,minimum_id'
            ||CHR(10)||'       ,srid'
            ||CHR(10)||'       ,base_layer_id'
            ||CHR(10)||'       )'
            ||CHR(10)||'VALUES ('||c_sde_schema||'.layer_id_generator.NEXTVAL'
            ||CHR(10)||'       ,:description'
            ||CHR(10)||'       ,Null'
            ||CHR(10)||'       ,'||nm3flx.string(c_app_owner)
            ||CHR(10)||'       ,'||nm3flx.string(p_local_table)
            ||CHR(10)||'       ,:spatial_column'
            ||CHR(10)||'       ,:eflags'
            ||CHR(10)||'       ,:layer_mask'
            ||CHR(10)||'       ,:gsize1'
            ||CHR(10)||'       ,:gsize2'
            ||CHR(10)||'       ,:gsize3'
            ||CHR(10)||'       ,:minx'
            ||CHR(10)||'       ,:miny'
            ||CHR(10)||'       ,:maxx'
            ||CHR(10)||'       ,:maxy'
            ||CHR(10)||'       ,:cdate'
            ||CHR(10)||'       ,:layer_config'
            ||CHR(10)||'       ,:optimal_array_size'
            ||CHR(10)||'       ,:stats_date'
            ||CHR(10)||'       ,:minimum_id'
            ||CHR(10)||'       ,:srid'
            ||CHR(10)||'       ,:base_layer_id'
            ||CHR(10)||'       )';
   EXECUTE IMMEDIATE l_sql
    USING  l_l_description
          ,l_l_spatial_column
          ,l_l_eflags
          ,l_l_layer_mask
          ,l_l_gsize1
          ,l_l_gsize2
          ,l_l_gsize3
          ,l_l_minx
          ,l_l_miny
          ,l_l_maxx
          ,l_l_maxy
          ,l_l_cdate
          ,l_l_layer_config
          ,l_l_optimal_array_size
          ,l_l_stats_date
          ,l_l_minimum_id
          ,l_l_srid
          ,l_l_base_layer_id;
--

   l_sql :=            'INSERT INTO '||c_sde_schema||'.geometry_columns'
            ||CHR(10)||'       (f_table_catalog'
            ||CHR(10)||'       ,f_table_schema'
            ||CHR(10)||'       ,f_table_name'
            ||CHR(10)||'       ,f_geometry_column'
            ||CHR(10)||'       ,g_table_catalog'
            ||CHR(10)||'       ,g_table_schema'
            ||CHR(10)||'       ,g_table_name'
            ||CHR(10)||'       ,storage_type'
            ||CHR(10)||'       ,geometry_type'
            ||CHR(10)||'       ,coord_dimension'
            ||CHR(10)||'       ,max_ppr'
            ||CHR(10)||'       ,srid'
            ||CHR(10)||'       )'
            ||CHR(10)||'VALUES (:f_table_catalog'
            ||CHR(10)||'       ,'||nm3flx.string(c_app_owner)
            ||CHR(10)||'       ,'||nm3flx.string(p_local_table)
            ||CHR(10)||'       ,:f_geometry_column'
            ||CHR(10)||'       ,:g_table_catalog'
            ||CHR(10)||'       ,'||nm3flx.string(c_app_owner)
            ||CHR(10)||'       ,'||nm3flx.string(p_local_table)
            ||CHR(10)||'       ,:storage_type'
            ||CHR(10)||'       ,:geometry_type'
            ||CHR(10)||'       ,:coord_dimension'
            ||CHR(10)||'       ,:max_ppr'
            ||CHR(10)||'       ,:srid'
            ||CHR(10)||'       )';
    EXECUTE IMMEDIATE l_sql
     USING  l_gc_f_table_catalog
           ,l_gc_f_geometry_column
           ,l_gc_g_table_catalog
           ,l_gc_storage_type
           ,l_gc_geometry_type
           ,l_gc_coord_dimension
           ,l_gc_max_ppr
           ,l_gc_srid;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'clone_sde_metadata');
--
END clone_sde_metadata;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dummy_node (p_nt_type VARCHAR2) RETURN NUMBER IS
   l_retval NUMBER;
   CURSOR cs_node (c_nt_type VARCHAR2) IS
   SELECT no_node_id
    FROM  nm_nodes
         ,nm_types
   WHERE  nt_type = c_nt_type
    AND   no_node_type = nt_node_type;
BEGIN
   OPEN  cs_node (p_nt_type);
   FETCH cs_node INTO l_retval;
   CLOSE cs_node;
   RETURN l_retval;
END get_dummy_node;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_block_datum (p_block_id NUMBER) IS
--
   l_rec_block xact_block_cgd_v%ROWTYPE;
   l_found     BOOLEAN;
--
   CURSOR cs_block (c_block_id NUMBER) IS
   SELECT *
    FROM  xact_block_cgd_v
   WHERE  block_id = c_block_id;
--
   l_rec_ne_block    nm_elements%ROWTYPE;
   l_rec_ne_district nm_elements%ROWTYPE;
   l_rec_ne_division nm_elements%ROWTYPE;
   l_rec_ne_section  nm_elements%ROWTYPE;
--
   c_dummy_node CONSTANT NUMBER := get_dummy_node(c_nt_type_block);
--
   c_au NUMBER;
   already_exists EXCEPTION;
--
   PROCEDURE create_member (p_in NUMBER, p_of NUMBER, p_grp_type VARCHAR2) IS
      l_rec_nm nm_members%ROWTYPE;
   BEGIN
      l_rec_nm.nm_ne_id_in            := p_in;
      l_rec_nm.nm_ne_id_of            := p_of;
      l_rec_nm.nm_type                := 'G';
      l_rec_nm.nm_obj_type            := p_grp_type;
      l_rec_nm.nm_begin_mp            := 0;
      l_rec_nm.nm_start_date          := l_rec_ne_block.ne_start_date;
      l_rec_nm.nm_end_date            := Null;
      l_rec_nm.nm_end_mp              := 0;
      l_rec_nm.nm_slk                 := Null;
      l_rec_nm.nm_cardinality         := 1;
      l_rec_nm.nm_admin_unit          := c_au;
      l_rec_nm.nm_date_created        := Null;
      l_rec_nm.nm_date_modified       := Null;
      l_rec_nm.nm_modified_by         := Null;
      l_rec_nm.nm_created_by          := Null;
      SELECT MAX(nm_seq_no)
       INTO  l_rec_nm.nm_seq_no
       FROM  nm_members
      WHERE  nm_ne_id_in = p_in;
      l_rec_nm.nm_seg_no              := Null;
      l_rec_nm.nm_true                := Null;
      l_rec_nm.nm_end_slk             := Null;
      l_rec_nm.nm_end_true            := Null;
      nm3ins.ins_nm (l_rec_nm);
   END create_member;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_block_datum');
--
   OPEN  cs_block (p_block_id);
   FETCH cs_block INTO l_rec_block;
   l_found := cs_block%FOUND;
   CLOSE cs_block;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'BLOCK.BLOCK_ID='||p_block_id
                    );
   END IF;
--
   c_au := nm3get.get_nau (pi_nau_unit_code  => 'CGD'
                          ,pi_nau_admin_type => 'CGD'
                          ).nau_admin_unit;
--
   IF nm3get.get_ne (pi_ne_unique       => l_rec_block.block_section_suburb
                    ,pi_ne_nt_type      => c_nt_type_block
                    ,pi_raise_not_found => FALSE
                    ).ne_id IS NOT NULL
    THEN
      RAISE already_exists;
   END IF;
   l_rec_ne_block.ne_id                  := nm3seq.next_ne_id_seq;
   l_rec_ne_block.ne_unique              := l_rec_block.block_section_suburb;
   l_rec_ne_block.ne_type                := 'S';
   l_rec_ne_block.ne_nt_type             := c_nt_type_block;
   l_rec_ne_block.ne_descr               := l_rec_block.block_section_suburb;
   l_rec_ne_block.ne_length              := TO_NUMBER(nm3unit.get_formatted_value(l_rec_block.area,1));
   l_rec_ne_block.ne_admin_unit          := c_au;
   l_rec_ne_block.ne_start_date          := c_federation;
   l_rec_ne_block.ne_gty_group_type      := Null;
   l_rec_ne_block.ne_owner               := Null;
   l_rec_ne_block.ne_name_1              := l_rec_block.block_key;
   l_rec_ne_block.ne_name_2              := l_rec_block.district_name;
   l_rec_ne_block.ne_prefix              := l_rec_block.block_number;
   l_rec_ne_block.ne_number              := l_rec_block.section_number;
   l_rec_ne_block.ne_sub_type            := Null;
   l_rec_ne_block.ne_group               := l_rec_block.division_name;
   l_rec_ne_block.ne_no_start            := c_dummy_node;
   l_rec_ne_block.ne_no_end              := c_dummy_node;
   l_rec_ne_block.ne_sub_class           := Null;
   l_rec_ne_block.ne_nsg_ref             := Null;
   l_rec_ne_block.ne_version_no          := Null;
--
   nm3ins.ins_ne (l_rec_ne_block);
--
   l_rec_ne_district := nm3get.get_ne (pi_ne_unique       => l_rec_block.district_name
                                      ,pi_ne_nt_type      => c_nt_type_district
                                      ,pi_raise_not_found => FALSE
                                      );
--
   IF l_rec_ne_district.ne_id IS NULL
    THEN -- district record not found
      l_rec_ne_district.ne_id                  := nm3seq.next_ne_id_seq;
      l_rec_ne_district.ne_unique              := l_rec_block.district_name;
      l_rec_ne_district.ne_type                := 'P';
      l_rec_ne_district.ne_nt_type             := c_nt_type_district;
      l_rec_ne_district.ne_descr               := l_rec_block.district_name;
      l_rec_ne_district.ne_length              := Null;
      l_rec_ne_district.ne_admin_unit          := c_au;
      l_rec_ne_district.ne_start_date          := l_rec_ne_block.ne_start_date;
      l_rec_ne_district.ne_gty_group_type      := c_gty_group_type_district;
      l_rec_ne_district.ne_owner               := Null;
      l_rec_ne_district.ne_name_1              := Null;
      l_rec_ne_district.ne_name_2              := Null;
      l_rec_ne_district.ne_prefix              := Null;
      l_rec_ne_district.ne_number              := Null;
      l_rec_ne_district.ne_sub_type            := Null;
      l_rec_ne_district.ne_group               := Null;
      l_rec_ne_district.ne_no_start            := Null;
      l_rec_ne_district.ne_no_end              := Null;
      l_rec_ne_district.ne_sub_class           := Null;
      l_rec_ne_district.ne_nsg_ref             := Null;
      l_rec_ne_district.ne_version_no          := Null;
      nm3ins.ins_ne (l_rec_ne_district);
   END IF;
--
   l_rec_ne_division := nm3get.get_ne (pi_ne_unique       => l_rec_block.division_name
                                      ,pi_ne_nt_type      => c_nt_type_division
                                      ,pi_raise_not_found => FALSE
                                      );
--
   IF l_rec_ne_division.ne_id IS NULL
    THEN -- division record not found
      l_rec_ne_division.ne_id                  := nm3seq.next_ne_id_seq;
      l_rec_ne_division.ne_unique              := l_rec_block.division_name;
      l_rec_ne_division.ne_type                := 'G';
      l_rec_ne_division.ne_nt_type             := c_nt_type_division;
      l_rec_ne_division.ne_descr               := l_rec_block.district_name||'/'||l_rec_block.division_name;
      l_rec_ne_division.ne_length              := Null;
      l_rec_ne_division.ne_admin_unit          := c_au;
      l_rec_ne_division.ne_start_date          := l_rec_ne_block.ne_start_date;
      l_rec_ne_division.ne_gty_group_type      := c_gty_group_type_division;
      l_rec_ne_division.ne_owner               := Null;
      l_rec_ne_division.ne_name_1              := l_rec_block.district_name;
      l_rec_ne_division.ne_name_2              := Null;
      l_rec_ne_division.ne_prefix              := Null;
      l_rec_ne_division.ne_number              := Null;
      l_rec_ne_division.ne_sub_type            := Null;
      l_rec_ne_division.ne_group               := Null;
      l_rec_ne_division.ne_no_start            := Null;
      l_rec_ne_division.ne_no_end              := Null;
      l_rec_ne_division.ne_sub_class           := Null;
      l_rec_ne_division.ne_nsg_ref             := Null;
      l_rec_ne_division.ne_version_no          := Null;
      nm3ins.ins_ne (l_rec_ne_division);
      create_member (l_rec_ne_district.ne_id, l_rec_ne_division.ne_id,l_rec_ne_district.ne_gty_group_type);
   END IF;
--
   l_rec_ne_section := nm3get.get_ne (pi_ne_unique       => l_rec_block.division_name||'/'||l_rec_block.section_number
                                     ,pi_ne_nt_type      => c_nt_type_section
                                     ,pi_raise_not_found => FALSE
                                     );
--
   IF l_rec_ne_section.ne_id IS NULL
    THEN -- section record not found
      l_rec_ne_section.ne_id                  := nm3seq.next_ne_id_seq;
      l_rec_ne_section.ne_unique              := l_rec_block.division_name||'/'||l_rec_block.section_number;
      l_rec_ne_section.ne_type                := 'G';
      l_rec_ne_section.ne_nt_type             := c_nt_type_section;
      l_rec_ne_section.ne_descr               := l_rec_block.district_name||'/'||l_rec_block.division_name||'/'||l_rec_block.section_number;
      l_rec_ne_section.ne_length              := Null;
      l_rec_ne_section.ne_admin_unit          := c_au;
      l_rec_ne_section.ne_start_date          := l_rec_ne_block.ne_start_date;
      l_rec_ne_section.ne_gty_group_type      := c_gty_group_type_section;
      l_rec_ne_section.ne_owner               := Null;
      l_rec_ne_section.ne_name_1              := l_rec_block.district_name;
      l_rec_ne_section.ne_name_2              := l_rec_block.division_name;
      l_rec_ne_section.ne_prefix              := Null;
      l_rec_ne_section.ne_number              := Null;
      l_rec_ne_section.ne_sub_type            := Null;
      l_rec_ne_section.ne_group               := Null;
      l_rec_ne_section.ne_no_start            := Null;
      l_rec_ne_section.ne_no_end              := Null;
      l_rec_ne_section.ne_sub_class           := Null;
      l_rec_ne_section.ne_nsg_ref             := Null;
      l_rec_ne_section.ne_version_no          := Null;
      nm3ins.ins_ne (l_rec_ne_section);
--      create_member (l_rec_ne_division.ne_id, l_rec_ne_section.ne_id,l_rec_ne_division.ne_gty_group_type);
   END IF;
--
   create_member (l_rec_ne_section.ne_id, l_rec_ne_block.ne_id,l_rec_ne_section.ne_gty_group_type);
   create_member (l_rec_ne_division.ne_id, l_rec_ne_block.ne_id,l_rec_ne_division.ne_gty_group_type);
--
   nm_debug.proc_end(g_package_name,'create_block_datum');
--
EXCEPTION
   WHEN already_exists
    THEN
      Null;
END create_block_datum;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_all_block_datums (p_limit NUMBER DEFAULT Null) IS
   l_tab_block_id nm3type.tab_number;
   c_commit CONSTANT PLS_INTEGER := NVL(hig.get_user_or_sys_opt('PCOMMIT'),1000);
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_block_datums');
--
   SELECT block_id
    BULK  COLLECT
    INTO  l_tab_block_id
    FROM  xact_block_cgd_v
   WHERE  NOT EXISTS (SELECT 1
                       FROM  nm_elements
                      WHERE  ne_unique = block_section_suburb
                       AND   ne_nt_type = c_nt_type_block
                     );
--
   FOR i IN 1..l_tab_block_id.COUNT
    LOOP
--
      create_block_datum (l_tab_block_id(i));
--
      IF MOD(i,c_commit)=0
       THEN
         COMMIT;
      END IF;
--
      IF p_limit IS NOT NULL
       AND i >= p_limit
       THEN
         EXIT;
      END IF;
--
   END LOOP;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'create_all_block_datums');
--
END create_all_block_datums;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_and_locate_street_addr IS
   c_au NUMBER;
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_and_locate_street_addr');
--
   c_au := nm3get.get_nau (pi_nau_unit_code  => 'CGD'
                          ,pi_nau_admin_type => 'CGD'
                          ).nau_admin_unit;
--
   nm3ausec.set_status (nm3type.c_off);
--
   INSERT INTO nm_inv_items_all
         (iit_ne_id
         ,iit_inv_type
         ,iit_primary_key
         ,iit_chr_attrib66
         ,iit_start_date
         ,iit_admin_unit
         ,iit_chr_attrib26 -- addr_street_number_text
         ,iit_chr_attrib57 -- addr_road_name
         ,iit_chr_attrib58 -- addr_suburb_district_name
         ,iit_chr_attrib27 -- addr_state_territory_name
         ,iit_num_attrib18 -- addr_number_first
         ,iit_num_attrib19 -- addr_number_last
         ,iit_chr_attrib28 -- addr_road_name_short
         ,iit_chr_attrib29 -- addr_road_name_type
         ,iit_chr_attrib30 -- addr_road_name_suffix
         ,iit_chr_attrib31 -- addr_anzlic_id
         ,iit_chr_attrib32 -- addr_source_anzlic_id
         ,iit_date_attrib86 -- addr_create_date
         ,iit_num_attrib20 -- addr_feature_instance_metadata
         ,iit_num_attrib115
         )
   SELECT ne_id_seq.NEXTVAL
         ,c_addr_inv_type
         ,address_allocation_id
         ,street_address_text
         ,c_federation
         ,c_au
         ,street_number_text
         ,road_name
         ,suburb_district_name
         ,state_territory_name
         ,number_first
         ,number_last
         ,road_name_short
         ,road_name_type
         ,road_name_suffix
         ,anzlic_id
         ,source_anzlic_id
         ,create_date
         ,feature_instance_metadata_id
         ,block_id
    FROM  xact_street_address_cgd_v a
   WHERE  NOT EXISTS (SELECT /*+ INDEX (b iit_uk) */ 1
                       FROM  nm_inv_items b
                      WHERE  LTRIM(TO_CHAR(a.address_allocation_id)) = b.iit_primary_key
                       AND   b.iit_inv_type                          = c_addr_inv_type
                     );
   --
   INSERT INTO nm_members_all
         (nm_ne_id_in
         ,nm_ne_id_of
         ,nm_type
         ,nm_obj_type
         ,nm_begin_mp
         ,nm_start_date
         ,nm_end_date
         ,nm_end_mp
         ,nm_cardinality
         ,nm_admin_unit
         ,nm_seq_no
         )
   SELECT iit_ne_id
         ,ne_id
         ,'I'
         ,iit_inv_type
         ,0
         ,iit_start_date
         ,iit_end_date
         ,0
         ,1
         ,iit_admin_unit
         ,1
    FROM  nm_inv_items     iit
         ,nm_elements      ne
         ,xact_block_cgd_v cgd
   WHERE  iit.iit_inv_type         = c_addr_inv_type
    AND   ne.ne_nt_type            = c_nt_type_block
    AND   cgd.block_id             = iit.iit_num_attrib115
    AND   cgd.block_section_suburb = ne_unique
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_members
                      WHERE  iit_ne_id = nm_ne_id_in
                     );
   --
   nm3ausec.set_status (nm3type.c_on);
--
   UPDATE xact_street_address_cgd_v a
    SET   a.xne_id = (SELECT /*+ INDEX (b iit_uk) */ iit_ne_id
                       FROM  nm_inv_items b
                      WHERE  LTRIM(TO_CHAR(a.address_allocation_id)) = b.iit_primary_key
                       AND   b.iit_inv_type                          = c_addr_inv_type
                     );
--
   nm_debug.proc_end (g_package_name,'create_and_locate_street_addr');
--
END create_and_locate_street_addr;
--
-----------------------------------------------------------------------------
--
END xact_cgd_interface;
/
