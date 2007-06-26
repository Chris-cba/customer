DECLARE
   l_rec_grm gri_modules%ROWTYPE;
   l_rec_gp  gri_params%ROWTYPE;
   l_rec_gmp gri_module_params%ROWTYPE;
   l_rec_hmo hig_modules%ROWTYPE;
   l_rec_hmr hig_module_roles%ROWTYPE;
BEGIN
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xmrwa_delete_route_gri_metadata.sql	1.1 03/15/05
--       Module Name      : xmrwa_delete_route_gri_metadata.sql
--       Date into SCCS   : 05/03/15 00:45:29
--       Date fetched Out : 07/06/06 14:38:15
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------

   l_rec_grm.grm_module      := 'XNM0206';
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
                                ||CHR(10)||'   -- @(#)xmrwa_delete_route_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xmrwa_delete_route (:XNM0206_NE_ID);'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Delete Route';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := 'MRWA';
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   l_rec_hmr.hmr_module            := l_rec_hmo.hmo_module;
   l_rec_hmr.hmr_role              := 'HIG_ADMIN';
   l_rec_hmr.hmr_mode              := nm3type.c_normal;
   nm3ins.ins_hmr (l_rec_hmr);
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'XNM0206_NE_ID';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_ELEMENTS_ALL';
   l_rec_gp.gp_column          := 'NE_ID';
   l_rec_gp.gp_descr_column    := 'NE_DESCR';
   l_rec_gp.gp_shown_column    := 'NE_UNIQUE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := 'NW_GRP';
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Road Name';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := '';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'Y';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   COMMIT;
--
END;
/

