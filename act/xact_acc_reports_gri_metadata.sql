DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_acc_reports_gri_metadata.sql	1.1 03/15/05
--       Module Name      : xact_acc_reports_gri_metadata.sql
--       Date into SCCS   : 05/03/15 03:47:22
--       Date fetched Out : 07/06/06 14:33:38
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
   l_rec_hsf hig_system_favourites%ROWTYPE;
   PROCEDURE ins_hsf (p_rec_hsf hig_system_favourites%ROWTYPE) IS
   BEGIN
      INSERT INTO hig_system_favourites
             (hsf_user_id
             ,hsf_parent
             ,hsf_child
             ,hsf_descr
             ,hsf_type
             )
      VALUES (p_rec_hsf.hsf_user_id
             ,p_rec_hsf.hsf_parent
             ,p_rec_hsf.hsf_child
             ,p_rec_hsf.hsf_descr
             ,p_rec_hsf.hsf_type
             );
   END ins_hsf;
BEGIN
--
   l_rec_hsf.hsf_user_id     := 1;
   l_rec_hsf.hsf_parent      := 'ACC_REPORTS';
   l_rec_hsf.hsf_type        := 'M';
--
   l_rec_grm.grm_module      := 'XACT010';
   l_rec_grm.grm_module_type := 'DIS';
   l_rec_grm.grm_module_path := '$PROD_HOME';
   l_rec_grm.grm_file_type   := 'DIS';
   l_rec_grm.grm_tag_flag    := 'N';
   l_rec_grm.grm_tag_table   := Null;
   l_rec_grm.grm_tag_column  := Null;
   l_rec_grm.grm_tag_where   := Null;
   l_rec_grm.grm_linesize    := 80;
   l_rec_grm.grm_pagesize    := 66;
   l_rec_grm.grm_pre_process :=            'BEGIN'
                                ||CHR(10)||'   -- @(#)xact_acc_reports_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'   xact_acc_reports.prepopulate_acc_ranking'
                                ||CHR(10)||'             (pi_start_date     => :XACT_START_DATE'
                                ||CHR(10)||'             ,pi_end_date       => :XACT_END_DATE'
                                ||CHR(10)||'             ,pi_run_type       => :XACT_RUN_TYPE'
                                ||CHR(10)||'             ,pi_records        => :XACT_RECORDS'
                                ||CHR(10)||'             ,pi_fatal_score    => :XACT_FATAL_SCORE'
                                ||CHR(10)||'             ,pi_injury_score   => :XACT_INJURY_SCORE'
                                ||CHR(10)||'             ,pi_property_score => :XACT_PROPERTY_SCORE'
                                ||CHR(10)||'             ,pi_fatal_set      => :XACT_FATAL_SET'
                                ||CHR(10)||'             ,pi_serious_set    => :XACT_SERIOUS_SET'
                                ||CHR(10)||'             ,pi_minor_set      => :XACT_MINOR_SET'
                                ||CHR(10)||'             ,pi_property_set   => :XACT_PROPERTY_SET'
                                ||CHR(10)||'             );'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Accident Ranking Report';
   l_rec_hmo.hmo_filename          := USER||'.'||l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := 'DIS';
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_acc;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
   l_rec_hsf.hsf_child             := l_rec_hmo.hmo_module;
   l_rec_hsf.hsf_descr             := l_rec_hmo.hmo_title;
   ins_hsf (l_rec_hsf);
--
   l_rec_hmr.hmr_module            := l_rec_hmo.hmo_module;
   l_rec_hmr.hmr_role              := 'ACC_USER';
   l_rec_hmr.hmr_mode              := nm3type.c_normal;
   nm3ins.ins_hmr (l_rec_hmr);
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gp.gp_param           := 'XACT_START_DATE';
   l_rec_gp.gp_param_type      := nm3type.c_date;
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
   l_rec_gmp.gmp_param_descr       := 'Start Date';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := '';
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_END_DATE';
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 2;
   l_rec_gmp.gmp_param_descr       := 'End Date';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := '';
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_RUN_TYPE';
   l_rec_gp.gp_param_type      := 'CHAR';
   l_rec_gp.gp_table           := 'HIG_CODES';
   l_rec_gp.gp_column          := 'HCO_CODE';
   l_rec_gp.gp_descr_column    := 'HCO_MEANING';
   l_rec_gp.gp_shown_column    := 'HCO_CODE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Intersection/Midblock';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'HCO_DOMAIN = '||nm3flx.string('XACT_ACCIDENT_TYPE');
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := l_rec_gp.gp_table;
   l_rec_gmp.gmp_default_column    := l_rec_gp.gp_column;
   l_rec_gmp.gmp_default_where     := l_rec_gmp.gmp_where||' AND hco_code = '||nm3flx.string('I');
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'Y';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_RECORDS';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := Null;
   l_rec_gp.gp_column          := Null;
   l_rec_gp.gp_descr_column    := Null;
   l_rec_gp.gp_shown_column    := Null;
   l_rec_gp.gp_shown_type      := Null;
   l_rec_gp.gp_descr_type      := Null;
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 4;
   l_rec_gmp.gmp_param_descr       := 'Records Retrieved';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := 'DUAL';
   l_rec_gmp.gmp_default_column    := '25';
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_FATAL_SCORE';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := Null;
   l_rec_gp.gp_column          := Null;
   l_rec_gp.gp_descr_column    := Null;
   l_rec_gp.gp_shown_column    := Null;
   l_rec_gp.gp_shown_type      := Null;
   l_rec_gp.gp_descr_type      := Null;
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 5;
   l_rec_gmp.gmp_param_descr       := 'Fatal Score';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := 'DUAL';
   l_rec_gmp.gmp_default_column    := '16';
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_INJURY_SCORE';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := Null;
   l_rec_gp.gp_column          := Null;
   l_rec_gp.gp_descr_column    := Null;
   l_rec_gp.gp_shown_column    := Null;
   l_rec_gp.gp_shown_type      := Null;
   l_rec_gp.gp_descr_type      := Null;
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 6;
   l_rec_gmp.gmp_param_descr       := 'Injury Score';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := 'DUAL';
   l_rec_gmp.gmp_default_column    := '4';
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_PROPERTY_SCORE';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := Null;
   l_rec_gp.gp_column          := Null;
   l_rec_gp.gp_descr_column    := Null;
   l_rec_gp.gp_shown_column    := Null;
   l_rec_gp.gp_shown_type      := Null;
   l_rec_gp.gp_descr_type      := Null;
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 7;
   l_rec_gmp.gmp_param_descr       := 'Property Score';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := Null;
   l_rec_gmp.gmp_tag_restriction   := 'N';
   l_rec_gmp.gmp_tag_where         := Null;
   l_rec_gmp.gmp_default_table     := 'DUAL';
   l_rec_gmp.gmp_default_column    := '1';
   l_rec_gmp.gmp_default_where     := Null;
   l_rec_gmp.gmp_visible           := 'Y';
   l_rec_gmp.gmp_gazetteer         := 'N';
   l_rec_gmp.gmp_lov               := 'N';
   l_rec_gmp.gmp_val_global        := Null;
   l_rec_gmp.gmp_wildcard          := 'N';
   l_rec_gmp.gmp_hint_text         := Null;
   l_rec_gmp.gmp_allow_partial     := 'N';
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_FATAL_SET';
   l_rec_gp.gp_param_type      := 'CHAR';
   l_rec_gp.gp_table           := 'HIG_CODES';
   l_rec_gp.gp_column          := 'HCO_CODE';
   l_rec_gp.gp_descr_column    := 'HCO_MEANING';
   l_rec_gp.gp_shown_column    := 'HCO_CODE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_visible           := 'N';
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 8;
   l_rec_gmp.gmp_param_descr       := 'Fatal Set';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'HCO_DOMAIN = '||nm3flx.string('XACC_FATAL_SET');
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_SERIOUS_SET';
   l_rec_gp.gp_param_type      := 'CHAR';
   l_rec_gp.gp_table           := 'HIG_CODES';
   l_rec_gp.gp_column          := 'HCO_CODE';
   l_rec_gp.gp_descr_column    := 'HCO_MEANING';
   l_rec_gp.gp_shown_column    := 'HCO_CODE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 9;
   l_rec_gmp.gmp_param_descr       := 'Serious Injury Set';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'HCO_DOMAIN = '||nm3flx.string('XACC_SERIOUS_SET');
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_MINOR_SET';
   l_rec_gp.gp_param_type      := 'CHAR';
   l_rec_gp.gp_table           := 'HIG_CODES';
   l_rec_gp.gp_column          := 'HCO_CODE';
   l_rec_gp.gp_descr_column    := 'HCO_MEANING';
   l_rec_gp.gp_shown_column    := 'HCO_CODE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 10;
   l_rec_gmp.gmp_param_descr       := 'Minor Injury Set';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'HCO_DOMAIN = '||nm3flx.string('XACC_MINOR_SET');
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_PROPERTY_SET';
   l_rec_gp.gp_param_type      := 'CHAR';
   l_rec_gp.gp_table           := 'HIG_CODES';
   l_rec_gp.gp_column          := 'HCO_CODE';
   l_rec_gp.gp_descr_column    := 'HCO_MEANING';
   l_rec_gp.gp_shown_column    := 'HCO_CODE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 10;
   l_rec_gmp.gmp_param_descr       := 'Property Set';
   l_rec_gmp.gmp_mandatory         := 'N';
   l_rec_gmp.gmp_no_allowed        := 1;
   l_rec_gmp.gmp_where             := 'HCO_DOMAIN = '||nm3flx.string('XACC_PROPERTY_SET');
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
   l_rec_gmp.gmp_base_table        := Null;
   l_rec_gmp.gmp_base_table_column := Null;
   l_rec_gmp.gmp_operator          := Null;
   nm3ins.ins_gmp (l_rec_gmp);
--
-- ##############################################################################
--
--    XACT020
--
-- ##############################################################################
--
   l_rec_grm := nm3get.get_grm (pi_grm_module => 'XACT010');
   l_rec_grm.grm_module      := 'XACT020';
   l_rec_grm.grm_module_type := 'EXE';
   l_rec_grm.grm_pre_process :=            'BEGIN'
                                ||CHR(10)||'   -- @(#)xact_acc_reports_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'   xact_acc_reports.prepopulate_site_hist_inj_type'
                                ||CHR(10)||'             (pi_start_date     => :XACT_START_DATE'
                                ||CHR(10)||'             ,pi_end_date       => :XACT_END_DATE'
                                ||CHR(10)||'             ,pi_run_type       => '||nm3flx.string('I')
                                ||CHR(10)||'             ,pi_node_id        => :XACT_NODE_ID'
                                ||CHR(10)||'             ,pi_element_id     => Null'
                                ||CHR(10)||'             );'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Site Accident History (intersection)';
   l_rec_hmo.hmo_filename          := USER||'.'||l_rec_grm.grm_module;
   l_rec_hmo.hmo_module_type       := 'URL';
   l_rec_hmo.hmo_fastpath_opts     := Null;
   l_rec_hmo.hmo_fastpath_invalid  := 'N';
   l_rec_hmo.hmo_use_gri           := 'Y';
   l_rec_hmo.hmo_application       := nm3type.c_acc;
   l_rec_hmo.hmo_menu              := Null;
   nm3ins.ins_hmo (l_rec_hmo);
   l_rec_hsf.hsf_child             := l_rec_hmo.hmo_module;
   l_rec_hsf.hsf_descr             := l_rec_hmo.hmo_title;
   ins_hsf (l_rec_hsf);
--
   l_rec_hmr.hmr_module            := l_rec_hmo.hmo_module;
   l_rec_hmr.hmr_role              := 'ACC_USER';
   l_rec_hmr.hmr_mode              := nm3type.c_normal;
   nm3ins.ins_hmr (l_rec_hmr);
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT010'
                               ,pi_gmp_param  => 'XACT_START_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT010'
                               ,pi_gmp_param  => 'XACT_END_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_NODE_ID';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := 'NM_NODES';
   l_rec_gp.gp_column          := 'NO_NODE_ID';
   l_rec_gp.gp_descr_column    := 'NO_DESCR';
   l_rec_gp.gp_shown_column    := 'NO_NODE_NAME';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := Null;
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Intersection';
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
   l_rec_gmp.gmp_base_table        := 'NM_NODES';
   l_rec_gmp.gmp_base_table_column := 'NO_NODE_ID';
   l_rec_gmp.gmp_operator          := '=';
   nm3ins.ins_gmp (l_rec_gmp);
--
-- ##############################################################################
--
--    XACT021
--
-- ##############################################################################
--
   l_rec_grm := nm3get.get_grm (pi_grm_module => 'XACT020');
   l_rec_hmo := nm3get.get_hmo (pi_hmo_module => l_rec_grm.grm_module);
   l_rec_grm.grm_module      := 'XACT021';
   l_rec_grm.grm_pre_process :=            'BEGIN'
                                ||CHR(10)||'   -- @(#)xact_acc_reports_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'   xact_acc_reports.prepopulate_site_hist_inj_type'
                                ||CHR(10)||'             (pi_start_date     => :XACT_START_DATE'
                                ||CHR(10)||'             ,pi_end_date       => :XACT_END_DATE'
                                ||CHR(10)||'             ,pi_run_type       => '||nm3flx.string('M')
                                ||CHR(10)||'             ,pi_node_id        => Null'
                                ||CHR(10)||'             ,pi_element_id     => :XACT_LINK_ID'
                                ||CHR(10)||'             );'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Site Accident History (midblock)';
   nm3ins.ins_hmo (l_rec_hmo);
   l_rec_hsf.hsf_child             := l_rec_hmo.hmo_module;
   l_rec_hsf.hsf_descr             := l_rec_hmo.hmo_title;
   ins_hsf (l_rec_hsf);
--
   l_rec_hmr.hmr_module            := l_rec_hmo.hmo_module;
   l_rec_hmr.hmr_role              := 'ACC_USER';
   l_rec_hmr.hmr_mode              := nm3type.c_normal;
   nm3ins.ins_hmr (l_rec_hmr);
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT020'
                               ,pi_gmp_param  => 'XACT_START_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT020'
                               ,pi_gmp_param  => 'XACT_END_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_LINK_ID';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := 'NM_ELEMENTS';
   l_rec_gp.gp_column          := 'NE_ID';
   l_rec_gp.gp_descr_column    := 'NE_DESCR';
   l_rec_gp.gp_shown_column    := 'NE_UNIQUE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := 'NW_DAT';
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Link';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
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
   l_rec_gmp.gmp_base_table        := 'NM_ELEMENTS';
   l_rec_gmp.gmp_base_table_column := 'NE_ID';
   l_rec_gmp.gmp_operator          := '=';
   nm3ins.ins_gmp (l_rec_gmp);
--
-- ##############################################################################
--
--    XACT022
--
-- ##############################################################################
--
   l_rec_grm := nm3get.get_grm (pi_grm_module => 'XACT021');
   l_rec_hmo := nm3get.get_hmo (pi_hmo_module => l_rec_grm.grm_module);
   l_rec_grm.grm_module      := 'XACT022';
   l_rec_grm.grm_pre_process :=            'BEGIN'
                                ||CHR(10)||'   -- @(#)xact_acc_reports_gri_metadata.sql	1.1 03/15/05'
                                ||CHR(10)||'   xact_acc_reports.prepopulate_street_hist'
                                ||CHR(10)||'             (pi_start_date     => :XACT_START_DATE'
                                ||CHR(10)||'             ,pi_end_date       => :XACT_END_DATE'
                                ||CHR(10)||'             ,pi_element_id     => :XACT_ROAD_ID'
                                ||CHR(10)||'             );'
                                ||CHR(10)||'END;';
--
   l_rec_hmo.hmo_module            := l_rec_grm.grm_module;
   l_rec_hmo.hmo_title             := 'Street History';
   nm3ins.ins_hmo (l_rec_hmo);
   l_rec_hsf.hsf_child             := l_rec_hmo.hmo_module;
   l_rec_hsf.hsf_descr             := l_rec_hmo.hmo_title;
   ins_hsf (l_rec_hsf);
--
   l_rec_hmr.hmr_module            := l_rec_hmo.hmo_module;
   l_rec_hmr.hmr_role              := 'ACC_USER';
   l_rec_hmr.hmr_mode              := nm3type.c_normal;
   nm3ins.ins_hmr (l_rec_hmr);
--
   nm3ins.ins_grm (l_rec_grm);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT020'
                               ,pi_gmp_param  => 'XACT_START_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gmp := nm3get.get_gmp (pi_gmp_module => 'XACT020'
                               ,pi_gmp_param  => 'XACT_END_DATE'
                               );
   l_rec_gmp.gmp_module := l_rec_grm.grm_module;
   nm3ins.ins_gmp (l_rec_gmp);
--
   l_rec_gp.gp_param           := 'XACT_ROAD_ID';
   l_rec_gp.gp_param_type      := nm3type.c_number;
   l_rec_gp.gp_table           := 'NM_ELEMENTS';
   l_rec_gp.gp_column          := 'NE_ID';
   l_rec_gp.gp_descr_column    := 'NE_DESCR';
   l_rec_gp.gp_shown_column    := 'NE_UNIQUE';
   l_rec_gp.gp_shown_type      := 'CHAR';
   l_rec_gp.gp_descr_type      := 'CHAR';
   l_rec_gp.gp_order           := Null;
   l_rec_gp.gp_case            := Null;
   l_rec_gp.gp_gaz_restriction := 'NW_GRP';
   nm3ins.ins_gp (l_rec_gp);
--
   l_rec_gmp.gmp_module            := l_rec_grm.grm_module;
   l_rec_gmp.gmp_param             := l_rec_gp.gp_param;
   l_rec_gmp.gmp_seq               := 3;
   l_rec_gmp.gmp_param_descr       := 'Road';
   l_rec_gmp.gmp_mandatory         := 'Y';
   l_rec_gmp.gmp_no_allowed        := 1;
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
   l_rec_gmp.gmp_base_table        := 'NM_ELEMENTS';
   l_rec_gmp.gmp_base_table_column := 'NE_ID';
   l_rec_gmp.gmp_operator          := '=';
   nm3ins.ins_gmp (l_rec_gmp);
--
   COMMIT;
--
END;
/

DECLARE
   l_rec_hdo hig_domains%ROWTYPE;
   PROCEDURE insert_it IS
   BEGIN
      IF nm3get.get_hdo (pi_hdo_domain      => l_rec_hdo.hdo_domain
                        ,pi_raise_not_found => FALSE
                        ).hdo_domain IS NULL
       THEN
         nm3ins.ins_hdo (l_rec_hdo);
      END IF;
   END insert_it;
BEGIN
   l_rec_hdo.hdo_domain      := 'XACC_FATAL_SET';
   l_rec_hdo.hdo_product     := 'ACC';
   l_rec_hdo.hdo_title       := 'Restricted Accident Types for report';
   l_rec_hdo.hdo_code_length := 20;
   insert_it;
   l_rec_hdo.hdo_domain      := 'XACC_SERIOUS_SET';
   insert_it;
   l_rec_hdo.hdo_domain      := 'XACC_MINOR_SET';
   insert_it;
   l_rec_hdo.hdo_domain      := 'XACC_PROPERTY_SET';
   insert_it;
--
   COMMIT;
--
END;
/

