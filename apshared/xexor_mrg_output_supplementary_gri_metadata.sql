DECLARE
   l_rec_grm gri_modules%ROWTYPE;
   l_rec_gp  gri_params%ROWTYPE;
   l_rec_gmp gri_module_params%ROWTYPE;
   l_rec_gpd gri_param_dependencies%ROWTYPE;
   l_rec_hmo hig_modules%ROWTYPE;
   l_rec_hmr hig_module_roles%ROWTYPE;
BEGIN
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xexor_mrg_output_supplementary_gri_metadata.sql	1.1 03/15/05
--       Module Name      : xexor_mrg_output_supplementary_gri_metadata.sql
--       Date into SCCS   : 05/03/15 22:46:55
--       Date fetched Out : 07/06/06 14:36:41
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
--
   l_rec_grm.grm_module      := 'XNM7057';
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
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xexor_mrg_output_supplementary.create_table_from_nmf'
                                ||CHR(10)||'              (p_nmf_id         => :X_NMF_ID'
                                ||CHR(10)||'              ,p_nqr_mrg_job_id => :X_JOB_ID'
                                ||CHR(10)||'              );'
                               ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--
   IF nm3get.get_grm (pi_grm_module      => l_rec_grm.grm_module
                     ,pi_raise_not_found => FALSE
                     ).grm_module IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => 'gri_modules.grm_module="'||l_rec_grm.grm_module||'"'
                    );
   END IF;
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Extract merge results to table';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_net;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   INSERT INTO hig_module_roles
         (hmr_module
         ,hmr_role
         ,hmr_mode
         )
   SELECT l_rec_hmo.hmo_module
         ,hmr_role
         ,hmr_mode
    FROM  hig_module_roles
   WHERE  hmr_module = 'NM7057';
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'X_NMQ_ID';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_MRG_QUERY';
   l_rec_gp.gp_column          := 'NMQ_ID';
   l_rec_gp.gp_descr_column    := 'NMQ_DESCR';
   l_rec_gp.gp_shown_column    := 'NMQ_UNIQUE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := 'NMQ_UNIQUE';
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Merge Query';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'EXISTS (SELECT 1 FROM nm_mrg_output_file WHERE nmf_nmq_id=nmq_id) AND EXISTS (SELECT 1 FROM nm_mrg_query_results WHERE nqr_nmq_id=nmq_id)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gpd.gpd_module            := l_rec_grm.grm_module;
   l_rec_gpd.gpd_indep_param       := l_rec_gmp.gmp_param;
--
   l_rec_gp.gp_param           := 'X_JOB_ID';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_MRG_QUERY_RESULTS';
   l_rec_gp.gp_column          := 'NQR_MRG_JOB_ID';
   l_rec_gp.gp_descr_column    := 'NQR_DESCRIPTION';
   l_rec_gp.gp_shown_column    := 'NQR_MRG_JOB_ID';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Result Set';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := 'NQR_NMQ_ID LIKE NVL( :X_NMQ_ID ,NQR_NMQ_ID)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
   nm3ins.ins_gpd (l_rec_gpd);
--
   l_rec_gp.gp_param           := 'X_NMF_ID';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_MRG_OUTPUT_FILE';
   l_rec_gp.gp_column          := 'NMF_ID';
   l_rec_gp.gp_descr_column    := 'NMF_ID';
   l_rec_gp.gp_shown_column    := 'NMF_FILENAME';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'NUMBER';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'Output Definition';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := 'NMF_NMQ_ID LIKE NVL( :X_NMQ_ID ,NMF_NMQ_ID)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
   nm3ins.ins_gpd (l_rec_gpd);
--
--
--
-- ###################################################################
--
--
--
-- ###################################################################
--
--
--
   l_rec_grm.grm_module      := 'XNM7051E';
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
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xexor_mrg_output_supplementary.submit_merge_in_batch'
                                ||CHR(10)||'              (p_source_id => :X_SOURCE_ID_ELE'
                                ||CHR(10)||'              ,p_source    => '||nm3flx.string('ROUTE')
                                ||CHR(10)||'              ,p_nmq_id    => :X_NMQ_ID'
                                ||CHR(10)||'              ,p_nmq_descr => :X_NQR_DESCR'
                                ||CHR(10)||'              );'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--

   IF nm3get.get_grm (pi_grm_module      => l_rec_grm.grm_module
                     ,pi_raise_not_found => FALSE
                     ).grm_module IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => 'gri_modules.grm_module="'||l_rec_grm.grm_module||'"'
                    );
   END IF;
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Submit merge query in batch on element';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_net;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   INSERT INTO hig_module_roles
         (hmr_module
         ,hmr_role
         ,hmr_mode
         )
   SELECT l_rec_hmo.hmo_module
         ,hmr_role
         ,hmr_mode
    FROM  hig_module_roles
   WHERE  hmr_module = 'NM7051';
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'X_NMQ_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_QUERY';
--   l_rec_gp.gp_column          := 'NMQ_ID';
--   l_rec_gp.gp_descr_column    := 'NMQ_DESCR';
--   l_rec_gp.gp_shown_column    := 'NMQ_UNIQUE';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'CHAR';
--   l_rec_gp.gp_order           := 'NMQ_UNIQUE';
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Merge Query';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gpd.gpd_module            := l_rec_grm.grm_module;
   l_rec_gpd.gpd_indep_param       := l_rec_gmp.gmp_param;
--
   l_rec_gp.gp_param           := 'X_SOURCE_ID_ELE';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_ELEMENTS';
   l_rec_gp.gp_column          := 'NE_ID';
   l_rec_gp.gp_descr_column    := 'NE_DESCR';
   l_rec_gp.gp_shown_column    := 'NE_UNIQUE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := 'NW_ALL';
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'Element';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
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
   l_rec_gp.gp_param           := 'X_NQR_DESCR';
   l_rec_gp.gp_param_type      := 'CHAR';
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
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Description';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
--   nm3ins.ins_gpd (l_rec_gpd);
--
--
--
-- ###################################################################
--
--
--
-- ###################################################################
--
--
--
   l_rec_grm.grm_module      := 'XNM7051S';
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
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xexor_mrg_output_supplementary.submit_merge_in_batch'
                                ||CHR(10)||'              (p_source_id => :X_SOURCE_ID_SAVED'
                                ||CHR(10)||'              ,p_source    => '||nm3flx.string('SAVED')
                                ||CHR(10)||'              ,p_nmq_id    => :X_NMQ_ID'
                                ||CHR(10)||'              ,p_nmq_descr => :X_NQR_DESCR'
                                ||CHR(10)||'              );'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--

   IF nm3get.get_grm (pi_grm_module      => l_rec_grm.grm_module
                     ,pi_raise_not_found => FALSE
                     ).grm_module IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => 'gri_modules.grm_module="'||l_rec_grm.grm_module||'"'
                    );
   END IF;
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Submit merge query in batch on saved extent';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_net;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   INSERT INTO hig_module_roles
         (hmr_module
         ,hmr_role
         ,hmr_mode
         )
   SELECT l_rec_hmo.hmo_module
         ,hmr_role
         ,hmr_mode
    FROM  hig_module_roles
   WHERE  hmr_module = 'NM7051';
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'X_NMQ_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_QUERY';
--   l_rec_gp.gp_column          := 'NMQ_ID';
--   l_rec_gp.gp_descr_column    := 'NMQ_DESCR';
--   l_rec_gp.gp_shown_column    := 'NMQ_UNIQUE';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'CHAR';
--   l_rec_gp.gp_order           := 'NMQ_UNIQUE';
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Merge Query';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gpd.gpd_module            := l_rec_grm.grm_module;
   l_rec_gpd.gpd_indep_param       := l_rec_gmp.gmp_param;
--
   l_rec_gp.gp_param           := 'X_SOURCE_ID_SAVED';
   l_rec_gp.gp_param_type      := 'NUMBER';
   l_rec_gp.gp_table           := 'NM_SAVED_EXTENTS';
   l_rec_gp.gp_column          := 'NSE_ID';
   l_rec_gp.gp_descr_column    := 'NSE_DESCR';
   l_rec_gp.gp_shown_column    := 'NSE_NAME';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := 'EXTENT';
--
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'Saved Extent';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
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
   l_rec_gp.gp_param           := 'X_NQR_DESCR';
--   l_rec_gp.gp_param_type      := 'CHAR';
--   l_rec_gp.gp_table           := Null;
--   l_rec_gp.gp_column          := Null;
--   l_rec_gp.gp_descr_column    := Null;
--   l_rec_gp.gp_shown_column    := Null;
--   l_rec_gp.gp_shown_type      := Null;
--   l_rec_gp.gp_descr_type      := Null;
--   l_rec_gp.gp_order           := Null;
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Description';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
--   nm3ins.ins_gpd (l_rec_gpd);--
--
--
-- ###################################################################
--
--
--
-- ###################################################################
--
--
--
   l_rec_grm.grm_module      := 'XNM7057E';
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
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xexor_mrg_output_supplementary.create_table_from_nmf'
                                ||CHR(10)||'              (p_nmf_id    => :X_NMF_ID'
                                ||CHR(10)||'              ,p_source_id => :X_SOURCE_ID_ELE'
                                ||CHR(10)||'              ,p_source    => '||nm3flx.string('ROUTE')
                                ||CHR(10)||'              ,p_nmq_id    => :X_NMQ_ID'
                                ||CHR(10)||'              );'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--
   IF nm3get.get_grm (pi_grm_module      => l_rec_grm.grm_module
                     ,pi_raise_not_found => FALSE
                     ).grm_module IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => 'gri_modules.grm_module="'||l_rec_grm.grm_module||'"'
                    );
   END IF;
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Run merge on element and extract results to table';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_net;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   INSERT INTO hig_module_roles
         (hmr_module
        ,hmr_role
         ,hmr_mode
         )
   SELECT l_rec_hmo.hmo_module
         ,hmr_role
         ,hmr_mode
    FROM  hig_module_roles
   WHERE  hmr_module = 'NM7057';
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'X_NMQ_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_QUERY';
--   l_rec_gp.gp_column          := 'NMQ_ID';
--   l_rec_gp.gp_descr_column    := 'NMQ_DESCR';
--   l_rec_gp.gp_shown_column    := 'NMQ_UNIQUE';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'CHAR';
--   l_rec_gp.gp_order           := 'NMQ_UNIQUE';
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Merge Query';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'EXISTS (SELECT 1 FROM nm_mrg_output_file WHERE nmf_nmq_id=nmq_id)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gpd.gpd_module            := l_rec_grm.grm_module;
   l_rec_gpd.gpd_indep_param       := l_rec_gmp.gmp_param;
--
   l_rec_gp.gp_param           := 'X_NMF_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_OUTPUT_FILE';
--   l_rec_gp.gp_column          := 'NMF_ID';
--   l_rec_gp.gp_descr_column    := 'NMF_ID';
--   l_rec_gp.gp_shown_column    := 'NMF_FILENAME';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'NUMBER';
--   l_rec_gp.gp_order           := Null;
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'Output Definition';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := 'NMF_NMQ_ID LIKE NVL( :X_NMQ_ID ,NMF_NMQ_ID)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
   nm3ins.ins_gpd (l_rec_gpd);
--
   l_rec_gp.gp_param           := 'X_SOURCE_ID_ELE';
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Element';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
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
--
-- ###################################################################
--
--
--
-- ###################################################################
--
--
--
   l_rec_grm.grm_module      := 'XNM7057S';
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
                                ||CHR(10)||'BEGIN'
                                ||CHR(10)||'   xexor_mrg_output_supplementary.create_table_from_nmf'
                                ||CHR(10)||'              (p_nmf_id    => :X_NMF_ID'
                                ||CHR(10)||'              ,p_source_id => :X_SOURCE_ID_SAVED'
                                ||CHR(10)||'              ,p_source    => '||nm3flx.string('SAVED')
                                ||CHR(10)||'              ,p_nmq_id    => :X_NMQ_ID'
                                ||CHR(10)||'              );'
                                ||CHR(10)||'   COMMIT;'
                                ||CHR(10)||'END;';
--
   IF nm3get.get_grm (pi_grm_module      => l_rec_grm.grm_module
                     ,pi_raise_not_found => FALSE
                     ).grm_module IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => 'gri_modules.grm_module="'||l_rec_grm.grm_module||'"'
                    );
   END IF;
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Run merge on saved extent and extract results to table';
   l_rec_hmo.hmo_filename          := l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := l_rec_grm.grm_module_type;
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_net;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
--
   INSERT INTO hig_module_roles
         (hmr_module
        ,hmr_role
         ,hmr_mode
         )
   SELECT l_rec_hmo.hmo_module
         ,hmr_role
         ,hmr_mode
    FROM  hig_module_roles
   WHERE  hmr_module = 'NM7057';
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'X_NMQ_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_QUERY';
--   l_rec_gp.gp_column          := 'NMQ_ID';
--   l_rec_gp.gp_descr_column    := 'NMQ_DESCR';
--   l_rec_gp.gp_shown_column    := 'NMQ_UNIQUE';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'CHAR';
--   l_rec_gp.gp_order           := 'NMQ_UNIQUE';
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 1;
   l_rec_gmp.gmp_param_descr       := 'Merge Query';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'EXISTS (SELECT 1 FROM nm_mrg_output_file WHERE nmf_nmq_id=nmq_id)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gpd.gpd_module            := l_rec_grm.grm_module;
   l_rec_gpd.gpd_indep_param       := l_rec_gmp.gmp_param;
--
   l_rec_gp.gp_param           := 'X_NMF_ID';
--   l_rec_gp.gp_param_type      := 'NUMBER';
--   l_rec_gp.gp_table           := 'NM_MRG_OUTPUT_FILE';
--   l_rec_gp.gp_column          := 'NMF_ID';
--   l_rec_gp.gp_descr_column    := 'NMF_ID';
--   l_rec_gp.gp_shown_column    := 'NMF_FILENAME';
--   l_rec_gp.gp_shown_type      := 'CHAR';
--   l_rec_gp.gp_descr_type      := 'NUMBER';
--   l_rec_gp.gp_order           := Null;
--   l_rec_gp.gp_case            := Null;
--   l_rec_gp.gp_gaz_restriction := Null;
----
--   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'Output Definition';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := 'NMF_NMQ_ID LIKE NVL( :X_NMQ_ID ,NMF_NMQ_ID)';
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := Null;
   l_rec_gmp.gmp_default_column    := Null;
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   nm3ins.ins_gmp (l_rec_gmp);
   l_rec_gpd.gpd_dep_param         := l_rec_gmp.gmp_param;
   nm3ins.ins_gpd (l_rec_gpd);
--
   l_rec_gp.gp_param           := 'X_SOURCE_ID_SAVED';
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Saved Extent';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_where             := Null;
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

