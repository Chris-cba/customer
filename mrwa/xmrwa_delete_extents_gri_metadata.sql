DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_delete_extents_gri_metadata.sql	1.1 03/15/05
--       Module Name      : xmrwa_delete_extents_gri_metadata.sql
--       Date into SCCS   : 05/03/15 00:45:26
--       Date fetched Out : 07/06/06 14:38:14
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
   l_rec_grm gri_modules%ROWTYPE;
   l_rec_gp  gri_params%ROWTYPE;
   l_rec_gmp gri_module_params%ROWTYPE;
   l_rec_hmo hig_modules%ROWTYPE;
   l_rec_hmr hig_module_roles%ROWTYPE;
BEGIN
--
   l_rec_grm.grm_module      := 'XNM0120';
   l_rec_grm.grm_module_type := 'EXE';
   l_rec_grm.grm_module_path := '$PROD_HOME';
   l_rec_grm.grm_file_type   := 'EXE';
   l_rec_grm.grm_tag_flag    := 'N';
   l_rec_grm.grm_tag_table   := Null;
   l_rec_grm.grm_tag_column  := Null;
   l_rec_grm.grm_tag_where   := Null;
   l_rec_grm.grm_linesize    := 80;
   l_rec_grm.grm_pagesize    := 66;
   l_rec_grm.grm_pre_process :=            'DECLARE'
                                ||CHR(10)||'   -- @(#)xmrwa_delete_extents_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'   l_tab_nse_id nm3type.tab_number;'
                                ||CHR(10)||''
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   SELECT nse_id'
                                ||CHR(10)||'    BULK  COLLECT'
                                ||CHR(10)||'    INTO  l_tab_nse_id'
                                ||CHR(10)||'    FROM  nm_saved_extents'
                                ||CHR(10)||'   WHERE  nse_owner = USER'
                                ||CHR(10)||'    AND   nse_name LIKE :XNM0120_NSE_NAME;'
                                ||CHR(10)||'   FORALL i IN 1..l_tab_nse_id.COUNT'
                                ||CHR(10)||'      DELETE FROM nm_saved_extent_member_datums'
                                ||CHR(10)||'      WHERE nsd_nse_id = l_tab_nse_id(i);'
                                ||CHR(10)||'   FORALL i IN 1..l_tab_nse_id.COUNT'
                                ||CHR(10)||'      DELETE FROM nm_saved_extent_members'
                                ||CHR(10)||'      WHERE nsm_nse_id = l_tab_nse_id(i);'
                                ||CHR(10)||'   FORALL i IN 1..l_tab_nse_id.COUNT'
                                ||CHR(10)||'      DELETE FROM nm_saved_extents'
                                ||CHR(10)||'      WHERE nse_id = l_tab_nse_id(i);'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Delete saved extents';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := 'MRWA';
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   FOR cs_rec IN (SELECT * FROM hig_module_roles WHERE hmo_module = 'NM0120')
    LOOP
      l_rec_hmr.hmr_module            := cs_rec.hmo_module;
      l_rec_hmr.hmr_role              := cs_rec.hmr_role;
      l_rec_hmr.hmr_mode              := cs_rec.hmr_mode;
      nm3ins.ins_hmr (l_rec_hmr);
   END LOOP;
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'XNM0120_NSE_NAME';
   l_rec_gp.gp_param_type      := nm3type.c_varchar;
   l_rec_gp.gp_table           := Null;
   l_rec_gp.gp_column          := Null;
   l_rec_gp.gp_descr_column    := Null;
   l_rec_gp.gp_shown_column    := Null;
   l_rec_gp.gp_shown_type      := Null;
   l_rec_gp.gp_descr_type      := Null;
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Extent Name';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := '';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := 'DUAL';
   l_rec_gmp.gmp_default_column    := nm3flx.string('%');
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--

--
   COMMIT;
--
END;
/

