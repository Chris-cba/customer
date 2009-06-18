set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 624 - wag_planning_v24
--
-- Application Export:
--   Application:     624
--   Name:            wag_planning_v24
--   Date and Time:   12:54 Thursday June 18, 2009
--   Exported By:     WAG
--   Flashback:       0
--   Export Type:     Application Export
--   Version: 3.2.0.00.27
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
-- Application Statistics:
--   Pages:                 6
--     Items:              30
--     Computations:        0
--     Validations:         0
--     Processes:          12
--     Regions:             8
--     Buttons:             2
--   Shared Components
--     Breadcrumbs:         1
--        Entries           0
--     Items:               1
--     Computations:        0
--     Processes:           0
--     Parent Tabs:         0
--     Tab Sets:            1
--        Tabs:             4
--     NavBars:             1
--     Lists:               0
--     Shortcuts:           1
--     Themes:              2
--     Templates:
--        Page:            18
--        List:            33
--        Report:          14
--        Label:           10
--        Region:          44
--     Messages:            0
--     Build Options:       0
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>4661904384848534);
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en-gb'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2009.01.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := 624;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

--application/delete_application
 
begin
 
   -- Remove Application
wwv_flow_api.remove_flow(624);
 
end;
/

 
begin
 
wwv_flow_audit.remove_audit_trail(624);
null;
 
end;
/

--application/create_application
 
begin
 
wwv_flow_api.create_flow(
  p_id    => 624,
  p_display_id=> 624,
  p_owner => 'WAG',
  p_name  => 'wag_planning_v24',
  p_alias => 'WAGTPCV15116117118119120121122123124125126127128601602603604605606607608609612613614615616617618619620621622623624',
  p_page_view_logging => 'YES',
  p_default_page_template=> 63118740619599608 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=> 63119637403599610 + wwv_flow_api.g_id_offset,
  p_default_region_template=> 63125835672599618 + wwv_flow_api.g_id_offset,
  p_error_template    => 63118740619599608 + wwv_flow_api.g_id_offset,
  p_page_protection_enabled_y_n=> 'Y',
  p_checksum_salt_last_reset => '20090617113207',
  p_max_session_length_sec=> 28800,
  p_home_link         => 'f?p=&APP_ID.:1:&SESSION.',
  p_flow_language     => 'en-gb',
  p_flow_language_derived_from=> 'FLOW_PRIMARY_LANGUAGE',
  p_flow_image_prefix => '/i/',
  p_documentation_banner=> '',
  p_authentication    => 'CUSTOM2',
  p_login_url         => '',
  p_logout_url        => '',
  p_application_tab_set=> 1,
  p_logo_image => '/i/wag_tpc.png',
  p_logo_image_attributes => 'alt="Highways By Exor" title="Highways By Exor"',
  p_public_url_prefix => '',
  p_public_user       => 'APEX_PUBLIC_USER',
  p_dbauth_url_prefix => '',
  p_proxy_server      => '',
  p_cust_authentication_process=> '.'||to_char(47237728353815662 + wwv_flow_api.g_id_offset)||'.',
  p_cust_authentication_page=> '',
  p_custom_auth_login_url=> '',
  p_flow_version      => 'release 1.0',
  p_flow_status       => 'AVAILABLE_W_EDIT_LINK',
  p_flow_unavailable_text=> 'This application is currently unavailable at this time.',
  p_build_status      => 'RUN_AND_BUILD',
  p_exact_substitutions_only=> 'Y',
  p_vpd               => 'nm3context.initialise_context(''WAG'');'||chr(10)||
'nm3user.instantiate_user;',
  p_csv_encoding    => 'Y',
  p_theme_id => 13,
  p_default_label_template => 63136755972599641 + wwv_flow_api.g_id_offset,
  p_default_report_template => 63134533516599640 + wwv_flow_api.g_id_offset,
  p_default_list_template => 63132436796599636 + wwv_flow_api.g_id_offset,
  p_default_menu_template => 63137054175599641 + wwv_flow_api.g_id_offset,
  p_default_button_template => 63120550297599611 + wwv_flow_api.g_id_offset,
  p_default_chart_template => 63123144437599615 + wwv_flow_api.g_id_offset,
  p_default_form_template => 63123454185599615 + wwv_flow_api.g_id_offset,
  p_default_wizard_template => 63127355106599619 + wwv_flow_api.g_id_offset,
  p_default_tabform_template => 63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_menur_template => 63121954153599613 + wwv_flow_api.g_id_offset,
  p_default_listr_template => 63125835672599618 + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss=> '20090617113207',
  p_required_roles=> wwv_flow_utilities.string_to_table2(''));
 
 
end;
/

prompt  ...authorization schemes
--
 
begin
 
null;
 
end;
/

--application/shared_components/navigation/navigation_bar
prompt  ...navigation bar entries
--
 
begin
 
wwv_flow_api.create_icon_bar_item(
  p_id             => 78940821717650744 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_icon_sequence  => 200,
  p_icon_image     => '',
  p_icon_subtext   => 'Logout',
  p_icon_target    => '&LOGOUT_URL.',
  p_icon_image_alt => 'Logout',
  p_icon_height    => 32,
  p_icon_width     => 32,
  p_icon_height2   => 24,
  p_icon_width2    => 24,
  p_icon_bar_disp_cond      => '',
  p_icon_bar_disp_cond_type => 'CURRENT_LOOK_IS_1',
  p_begins_on_new_line=> '',
  p_cell_colspan      => 1,
  p_onclick=> '',
  p_icon_bar_comment=> '');
 
 
end;
/

prompt  ...application processes
--
prompt  ...application items
--
--application/shared_components/logic/application_items/fsp_after_login_url
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 78946528429082454 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'FSP_AFTER_LOGIN_URL',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

prompt  ...application level computations
--
 
begin
 
null;
 
end;
/

prompt  ...Application Tabs
--
 
begin
 
--application/shared_components/navigation/tabs/standard/t_recordcard
wwv_flow_api.create_tab (
  p_id=> 21107530438797900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_tab_sequence=> 100,
  p_tab_name=> 'T_RECORDCARD',
  p_tab_text => 'Record Card',
  p_tab_step => 1,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_required_patch=>null + wwv_flow_api.g_id_offset,
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_front_sheet
wwv_flow_api.create_tab (
  p_id=> 15849280055536235 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_tab_sequence=> 200,
  p_tab_name=> 'T_FRONT SHEET',
  p_tab_text => 'Front Sheet',
  p_tab_step => 2,
  p_tab_also_current_for_pages => '2',
  p_tab_parent_tabset=>'',
  p_required_patch=>null + wwv_flow_api.g_id_offset,
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/associated_documents
wwv_flow_api.create_tab (
  p_id=> 2452729746631666 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_tab_sequence=> 310,
  p_tab_name=> 'Associated Documents',
  p_tab_text => 'Associated Documents',
  p_tab_step => 3,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_required_patch=>null + wwv_flow_api.g_id_offset,
  p_tab_comment  => '');
 
--application/shared_components/navigation/tabs/standard/t_map
wwv_flow_api.create_tab (
  p_id=> 66411468761265775 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_tab_sequence=> 400,
  p_tab_name=> 'T_MAP',
  p_tab_text => 'Map',
  p_tab_step => 5,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_display_condition_type=> 'ALWAYS',
  p_required_patch=>null + wwv_flow_api.g_id_offset,
  p_tab_comment  => '');
 
 
end;
/

prompt  ...Application Parent Tabs
--
 
begin
 
null;
 
end;
/

prompt  ...Shared Lists of values
--
prompt  ...Application Trees
--
--application/pages/page_groups
prompt  ...page groups
--
 
begin
 
null;
 
end;
/

--application/comments
prompt  ...comments: requires application express 2.2 or higher
--
 
--application/pages/page_00000
prompt  ...PAGE 0: 0
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 0,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => '0',
  p_step_title=> '0',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090609160439',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 78963422633904346 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'Incident',
  p_region_name=>'',
  p_plug_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'REGION_POSITION_06',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'NEVER',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<div style="width:300px">',
  p_plug_footer=> '</div>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>35839814568298627 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_branch_action=> 'f?p=&FLOW_ID.:2:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>35839504329298624+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>40303480056561308 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_branch_action=> 'f?p=&FLOW_ID.:1:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>40303177159561299+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>44533006878621993 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_branch_action=> 'f?p=&FLOW_ID.:0:&SESSION.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 99,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4871339049176983 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OSGR_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 400,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1234',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Osgr X',
  p_source=>'1234',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4871543551178366 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_OSGR_Y',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 410,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Osgr Y',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21109409725971606 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DOC_ID_PARAMETER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 390,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Doc Id',
  p_source=>'P101_DOC_ID_PARAMETER',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>29515121827133643 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_PROPERTY_REF_PARAMETER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 380,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'P101_PROPERTY_REF_PARAMETER',
  p_source_type=> 'ITEM',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136532572599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>33326074170380732 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WPRC_PK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 370,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => '1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'1',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136532572599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00001
prompt  ...PAGE 1: Record Card
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'<script language="JavaScript" type="text/javascript">'||chr(10)||
'<!--'||chr(10)||
''||chr(10)||
' htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 1,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_name   => 'Record Card',
  p_step_title=> 'Record Card',
  p_step_sub_title => 'Record Card',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> '',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090609150455',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select '||chr(10)||
'"WPRCL_WPRC_UPRN",'||chr(10)||
'"WPRCL_SEQ",'||chr(10)||
'chr(wprcl_seq+64),'||chr(10)||
'"WPRCL_WPRC_UPRN" WPRCL_WPRC_UPRN_DISPLAY,'||chr(10)||
'"WPRCL_SEQ" WPRCL_SEQ_DISPLAY,'||chr(10)||
'"WPRCL_DOC_ID",'||chr(10)||
'DOC_DATE_ISSUED,'||chr(10)||
'DOC_REFERENCE_CODE,'||chr(10)||
'DOC_DESCR,'||chr(10)||
'HUS_NAME,'||chr(10)||
'"WPRCL_REGISTRY_FILE"'||chr(10)||
'from DOCS,'||chr(10)||
'     wag_plan_record_card_lines,'||chr(10)||
'     hig_users'||chr(10)||
'where doc_id = wprcl_doc_id'||chr(10)||
'and   doc_compl_user_id = hus_user_id'||chr(10)||
'and   wprcl_wprc_uprn = :p0_property_ref_param';

s:=s||'eter'||chr(10)||
'order by wprcl_seq';

wwv_flow_api.create_report_region (
  p_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_name=> 'Record Card Lines',
  p_region_name=>'',
  p_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 15,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'UPDATABLE_SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_header=> '<div style="width:830px;">',
  p_footer=> '</div>',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'N',
  p_query_row_template=> 63134533516599640+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> '(null)',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No data found.',
  p_query_num_rows_type=> 'ROW_RANGES_IN_SELECT_LIST',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s:=s||'DOC_ID_SEQ';

wwv_flow_api.create_report_columns (
  p_id=> 17638384267717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_WPRC_UPRN',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Wprcl Wprc Uprn',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'HIDDEN',
  p_column_width=> '16',
  p_pk_col_source_type=> 'S',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_WPRC_UPRN',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s:=s||'DOC_ID_SEQ';

wwv_flow_api.create_report_columns (
  p_id=> 17638496587717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_SEQ',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Wprcl Seq',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'HIDDEN',
  p_column_width=> '16',
  p_pk_col_source_type=> 'S',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_SEQ',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17641594968727529 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'CHR(WPRCL_SEQ+64)',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Seq',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17638605016717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_WPRC_UPRN_DISPLAY',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Wprcl Wprc Uprn',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_column_width=> '16',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_WPRC_UPRN_DISPLAY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17638698128717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_SEQ_DISPLAY',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Wprcl Seq',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_column_width=> '16',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_SEQ_DISPLAY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17638802352717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_DOC_ID',
  p_column_display_sequence=> 7,
  p_column_heading=> 'PEM Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_column_width=> '16',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_DOC_ID',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17643200647770523 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_DATE_ISSUED',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Date Received',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17643310900770523 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_REFERENCE_CODE',
  p_column_display_sequence=> 8,
  p_column_heading=> 'LA',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17643392060770523 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_DESCR',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Description',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17643488227770523 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'HUS_NAME',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Name',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17638893018717044 + wwv_flow_api.g_id_offset,
  p_region_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'WPRCL_REGISTRY_FILE',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Registry File Ref',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'TEXT',
  p_column_width=> '16',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'WAG_PLAN_RECORD_CARD_LINES',
  p_ref_column_name=> 'WPRCL_REGISTRY_FILE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 21099205192790367 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Record Card',
  p_region_name=>'',
  p_plug_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_header=> '<div style="width:830px;">',
  p_plug_footer=> '</div>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 17638989244717049 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1,
  p_button_sequence=> 10,
  p_button_plug_id => 17638111032717027+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(63120550297599611+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'TOP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17639081211717049 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1,
  p_button_sequence=> 30,
  p_button_plug_id => 17638111032717027+wwv_flow_api.g_id_offset,
  p_button_name    => 'SUBMIT',
  p_button_image   => 'template:'||to_char(63120550297599611+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Save',
  p_button_position=> 'TOP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>17639779941717054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>19372290014910758 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_LAST_LINE_SEQ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1009,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Last Line Seq',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN_PROTECTED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21101234382790403 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_OSGR_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 42,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'OSGR&nbsp;&nbsp;',
  p_source=>'WPRC_OSGR_X',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:65px;text-align:right" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21101433209790406 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_OSGR_Y',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 43,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'WPRC_OSGR_Y',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'style="width:65px;text-align:right"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136532572599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21101809540790406 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_WPRC_PK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_prompt=>'Wprc Pk',
  p_source=>'WPRC_PK',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN_PROTECTED',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21102027795790408 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_WPRC_UPRN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&nbsp;&nbsp;&nbsp;UPRN&nbsp;&nbsp;',
  p_source=>'WPRC_UPRN',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
  p_tag_attributes  => 'style="width:80px" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136632605599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21102225868790408 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_WPRC_LPA',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LPA&nbsp;&nbsp;',
  p_source=>'WPRC_LPA',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 50,
  p_cHeight=> 1,
  p_tag_attributes  => 'style="width:160px" ',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21102427382790409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_WPRC_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 41,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location&nbsp;&nbsp;',
  p_source=>'WPRC_LOCATION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
  p_tag_attributes  => 'style="width:451px;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21102614251790409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_WPRC_FILE_REF',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Ref&nbsp;&nbsp;',
  p_source=>'WPRC_FILE_REF',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 20,
  p_cHeight=> 1,
  p_tag_attributes  => 'style="width:130px;" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>21102819505790409 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_STOP_TAB1',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 999,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'F|#OWNER#:WAG_PLAN_RECORD_CARD:p0_property_ref_parameter:WPRC_UPRN';

wwv_flow_api.create_page_process(
  p_id     => 21104029884790413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'Fetch Row from WAG_PLAN_RECORD_CARD',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to fetch row.',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'select :p1_osgr_x,'||chr(10)||
'       :p1_osgr_y'||chr(10)||
'into   :p0_osgr_x,'||chr(10)||
'       :p0_osgr_y'||chr(10)||
'from dual;';

wwv_flow_api.create_page_process(
  p_id     => 4873154080266547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'set_p0_osgr',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:WAG_PLAN_RECORD_CARD_LINES:WPRCL_WPRC_UPRN:WPRCL_SEQ';

wwv_flow_api.create_page_process(
  p_id     => 17639583786717052 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'MULTI_ROW_UPDATE',
  p_process_name=> 'ApplyMRU',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to process update.',
  p_process_when_button_id=>17639081211717049 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'update docs'||chr(10)||
'set doc_status_code = ''RE'''||chr(10)||
'where doc_id = :p0_doc_id_parameter;';

wwv_flow_api.create_page_process(
  p_id     => 21104633280790417 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'reject_planning_application',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>21100605810790397 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'--update docs'||chr(10)||
'--set doc_status_code = ''ACK'''||chr(10)||
'--where doc_id = :p0_doc_id_parameter;'||chr(10)||
'null;';

wwv_flow_api.create_page_process(
  p_id     => 21104835222790417 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'accept_planning_application',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>21100605810790397 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'delete wag_plan_record_card;'||chr(10)||
'delete wag_plan_record_card_lines;';

wwv_flow_api.create_page_process(
  p_id     => 21105028691790419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'delete_record_card_and_lines',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>21101004905790400 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'declare'||chr(10)||
'   v_last_seq number;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'--if (:p0_property_ref_parameter is null)'||chr(10)||
'--then :p0_property_ref_parameter := ''10002516120'';'||chr(10)||
'--end if;'||chr(10)||
''||chr(10)||
'--if (:p0_property_ref_parameter is null)'||chr(10)||
'--then :p0_property_ref_parameter := ''10013457595'';'||chr(10)||
'--end if;'||chr(10)||
''||chr(10)||
'if (:p101_property_ref_parameter is null)'||chr(10)||
'then :p101_property_ref_parameter := ''10002516120'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if (:p0_property_ref_parameter is null)'||chr(10)||
'then';

p:=p||' :p0_property_ref_parameter := :p101_property_ref_parameter;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'--if (:p0_doc_id_parameter is null)'||chr(10)||
'--then :p0_doc_id_parameter := 23478;'||chr(10)||
'--end if;'||chr(10)||
''||chr(10)||
'--if (:p0_doc_id_parameter is null)'||chr(10)||
'--then :p0_doc_id_parameter := 17902;'||chr(10)||
'--end if;'||chr(10)||
''||chr(10)||
'if (:p101_doc_id_parameter is null)'||chr(10)||
'then :p101_doc_id_parameter := 23478;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if (:p0_doc_id_parameter is null)'||chr(10)||
'then :p0_doc_id_parameter := :p101_doc_id_p';

p:=p||'arameter;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'select nvl(max(wprcl_seq),0)'||chr(10)||
'into :P1_LAST_LINE_SEQ'||chr(10)||
'from wag_plan_record_card_lines'||chr(10)||
'where wprcl_wprc_uprn = :p0_property_ref_parameter;'||chr(10)||
''||chr(10)||
''||chr(10)||
'insert into wag_plan_record_card'||chr(10)||
'  (wprc_uprn,'||chr(10)||
'   wprc_lpa,'||chr(10)||
'   wprc_location,'||chr(10)||
'   wprc_file_ref,'||chr(10)||
'   wprc_osgr_x,'||chr(10)||
'   wprc_osgr_y)'||chr(10)||
'select :p0_property_ref_parameter,'||chr(10)||
'       s.administrative_area,'||chr(10)||
'       ah_nlpg.GET_PAO_SAO(sao_start_number,sao_st';

p:=p||'art_suffix,sao_end_number, sao_end_suffix,sao_text) || '', '' ||'||chr(10)||
'       ah_nlpg.GET_PAO_SAO(pao_start_number,pao_start_suffix,pao_end_number, pao_end_suffix,pao_text) || '||chr(10)||
'       s.street_descriptor || '', '' ||'||chr(10)||
'       l.post_town || '', '' ||'||chr(10)||
'       l.postcode,'||chr(10)||
'       ''CZ-701-6-18-12345'','||chr(10)||
'       b.x_coordinate,'||chr(10)||
'       b.y_coordinate'||chr(10)||
'from nlpg_lpi l, nlpg_street_descriptor s, nlpg_blpu b  '||chr(10)||
'where l.uprn =';

p:=p||' :p0_property_ref_parameter'||chr(10)||
'and l.uprn = b.uprn'||chr(10)||
'and l.usrn = s.usrn'||chr(10)||
'and l.language = s.language  '||chr(10)||
'and l.language = ''ENG'''||chr(10)||
'and l.logical_status = 1'||chr(10)||
'and not exists ('||chr(10)||
'select ''x'''||chr(10)||
'from wag_plan_record_card'||chr(10)||
'where wprc_uprn = :p0_property_ref_parameter);'||chr(10)||
''||chr(10)||
'insert into wag_plan_record_card_lines'||chr(10)||
'   (wprcl_wprc_uprn,'||chr(10)||
'    wprcl_seq,'||chr(10)||
'    wprcl_doc_id)'||chr(10)||
'select :p0_property_ref_parameter,:P1_LAST_LINE_SEQ+1,:p0_d';

p:=p||'oc_id_parameter'||chr(10)||
'from dual'||chr(10)||
'where not exists ('||chr(10)||
'select ''x'''||chr(10)||
'from wag_plan_record_card_lines'||chr(10)||
'where wprcl_wprc_uprn = :p0_property_ref_parameter'||chr(10)||
'and wprcl_doc_id = :p0_doc_id_parameter);'||chr(10)||
'end;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 21105210525790419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'pre_populate_record_card',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00002
prompt  ...PAGE 2: Front Sheet
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 2,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_name   => 'Front Sheet',
  p_alias  => 'FRONT_SHEET',
  p_step_title=> 'Front Sheet',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090617113207',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select '||chr(10)||
'DHI_DOC_ID,'||chr(10)||
'DHI_DATE_CHANGED,'||chr(10)||
'DHI_STATUS_CODE,'||chr(10)||
'nvl(HSC_STATUS_NAME,''Unchanged'') DOC_STATUS,'||chr(10)||
'DHI_REASON,'||chr(10)||
'DHI_CHANGED_BY'||chr(10)||
'from DOC_HISTORY,'||chr(10)||
'     HIG_STATUS_CODES'||chr(10)||
'where dhi_doc_id = :p0_doc_id_parameter'||chr(10)||
'and   DHI_STATUS_CODE = HSC_STATUS_CODE(+)'||chr(10)||
'and   HSC_DOMAIN_CODE(+) = ''COMPLAINTS'''||chr(10)||
'order by 2';

wwv_flow_api.create_report_region (
  p_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_name=> 'Front Sheet Details (UPRN: &P0_PROPERTY_REF_PARAMETER.  -  Incident ID &P0_DOC_ID_PARAMETER.)',
  p_region_name=>'',
  p_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 15,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'UPDATABLE_SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_header=> '<div style="width:830px;">',
  p_footer=> '</div>',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'N',
  p_query_row_template=> 63134533516599640+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> '(null)',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No data found.',
  p_query_num_rows_type=> 'ROW_RANGES_IN_SELECT_LIST',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s:=s||'ARE_BATCH_ID_SEQ';

wwv_flow_api.create_report_columns (
  p_id=> 10417008812503369 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'DHI_DOC_ID',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Dhi Doc Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'HIDDEN',
  p_column_width=> '16',
  p_pk_col_source_type=> 'S',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'DOC_HISTORY',
  p_ref_column_name=> 'DHI_DOC_ID',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10417121012503369 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'DHI_DATE_CHANGED',
  p_column_display_sequence=> 4,
  p_column_heading=> '&nbsp;&nbsp;&nbsp;Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '10',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'DOC_HISTORY',
  p_ref_column_name=> 'DHI_DATE_CHANGED',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10417225286503369 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'DHI_STATUS_CODE',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Dhi Status Code',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_column_width=> '10',
  p_pk_col_source=> s,
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'DOC_HISTORY',
  p_ref_column_name=> 'DHI_STATUS_CODE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10432211267663563 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_STATUS',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Status',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '8',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10424900306619282 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'DHI_REASON',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Reason for Change',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '104',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 10417307833503369 + wwv_flow_api.g_id_offset,
  p_region_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'DHI_CHANGED_BY',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Officer',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '8',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_schema=> 'WAG',
  p_ref_table_name=> 'DOC_HISTORY',
  p_ref_column_name=> 'DHI_CHANGED_BY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 12242628716905911 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_plug_name=> 'Front Sheet',
  p_region_name=>'',
  p_plug_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<div style="width:830px;">',
  p_plug_footer=> '</div>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12242939798909138 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_LPA',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LPA&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:160px" ',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12243136466917632 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_LA_REF',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LA Ref&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:160px" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12243343045919580 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_FILE_REF',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'File Ref&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:160px" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12243548586921138 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Date&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:80px" ',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12243754473922808 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_APPLICANT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Applicant&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:160px" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12243929670925107 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_OSGR_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'OSGR&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:65px;text-align:right" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12244135904926940 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_OSGR_Y',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:65px;text-align:right" ',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136532572599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12244341445928561 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Location&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:501px;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 4,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>12244546986930104 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_PROPOSAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Proposal&nbsp;&nbsp;',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'style="width:501px;"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 4,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'select s.administrative_area,'||chr(10)||
'       doc_reference_code,'||chr(10)||
'       ''CZ-701-6-18-12345'','||chr(10)||
'       doc_date_issued,'||chr(10)||
'       hus_name,'||chr(10)||
'       b.x_coordinate,'||chr(10)||
'       b.y_coordinate,'||chr(10)||
'       ah_nlpg.GET_PAO_SAO(sao_start_number,sao_start_suffix,sao_end_number, sao_end_suffix,sao_text) || '', '' ||'||chr(10)||
'       ah_nlpg.GET_PAO_SAO(pao_start_number,pao_start_suffix,pao_end_number, pao_end_suffix,pao_text) || '||chr(10)||
'   ';

p:=p||'    s.street_descriptor || '', '' ||'||chr(10)||
'       l.post_town || '', '' || l.postcode location,'||chr(10)||
'       doc_descr'||chr(10)||
'into'||chr(10)||
':P2_LPA,'||chr(10)||
':P2_LA_REF,'||chr(10)||
':P2_FILE_REF,'||chr(10)||
':P2_DATE,'||chr(10)||
':P2_APPLICANT,'||chr(10)||
':P2_OSGR_X,'||chr(10)||
':P2_OSGR_Y,'||chr(10)||
':P2_LOCATION,'||chr(10)||
':P2_PROPOSAL'||chr(10)||
'from nlpg_lpi l, '||chr(10)||
'     nlpg_street_descriptor s, '||chr(10)||
'     nlpg_blpu b,'||chr(10)||
'     docs,'||chr(10)||
'     hig_users'||chr(10)||
'where l.uprn = :p0_property_ref_parameter'||chr(10)||
'and   l.uprn = b.uprn'||chr(10)||
'and   l.usrn = s.usrn'||chr(10)||
'a';

p:=p||'nd   l.language = s.language  '||chr(10)||
'and   l.language = ''ENG'''||chr(10)||
'and   l.logical_status = 1'||chr(10)||
'and   doc_id = :p0_doc_id_parameter'||chr(10)||
'and   doc_compl_user_id = hus_user_id;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 12249328773010038 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'populate_front_sheet',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 2
--
 
begin
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2462925104904126 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 1,
  p_query_column_name=> 'DHI_DOC_ID',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2463031073904129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 2,
  p_query_column_name=> 'DHI_DATE_CHANGED',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2463124468904129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 3,
  p_query_column_name=> 'DHI_STATUS_CODE',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2463242046904129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 4,
  p_query_column_name=> 'DOC_STATUS',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2463332766904129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 5,
  p_query_column_name=> 'DHI_REASON',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 2463428687904129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 6,
  p_query_column_name=> 'DHI_CHANGED_BY',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00003
prompt  ...PAGE 3: Associated Documents
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 3,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_name   => 'Associated Documents',
  p_step_title=> 'Associated Documents',
  p_step_sub_title => 'Associated Documents',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> '',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090609170819',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>3,p_text=>h);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select dlc_url_pathname,'||chr(10)||
'       doc_file,'||chr(10)||
'       doc_compl_type,'||chr(10)||
'       doc_reference_code,'||chr(10)||
'       doc_title,'||chr(10)||
'       doc_category,'||chr(10)||
'       doc_descr'||chr(10)||
'from   docs,'||chr(10)||
'       doc_assocs,'||chr(10)||
'       doc_locations'||chr(10)||
'where  das_rec_id = :P0_DOC_ID_PARAMETER'||chr(10)||
'and    das_doc_id = doc_id'||chr(10)||
'and    doc_dlc_id = dlc_id';

wwv_flow_api.create_page_plug (
  p_id=> 2452820516631666 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Associated Documents (Public Enquiry ID &P0_DOC_ID_PARAMETER.)',
  p_region_name=>'',
  p_plug_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_header=> '<div style="width:800px;overflow:auto">',
  p_plug_footer=> '</div>',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select dlc_url_pathname,'||chr(10)||
'       doc_file,'||chr(10)||
'       doc_compl_type,'||chr(10)||
'       doc_reference_code,'||chr(10)||
'       doc_title,'||chr(10)||
'       doc_category,'||chr(10)||
'       doc_descr'||chr(10)||
'from   docs,'||chr(10)||
'       doc_assocs,'||chr(10)||
'       doc_locations'||chr(10)||
'where  das_rec_id = :P0_DOC_ID_PARAMETER'||chr(10)||
'and    das_doc_id = doc_id'||chr(10)||
'and    doc_dlc_id = dlc_id';

wwv_flow_api.create_worksheet(
  p_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 3,
  p_region_id => 2452820516631666+wwv_flow_api.g_id_offset,
  p_name => 'Associated Documents',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more than 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No data found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => '',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'Y',
  p_show_display_row_count    =>'Y',
  p_show_search_bar           =>'Y',
  p_show_search_textbox       =>'Y',
  p_show_actions_menu         =>'Y',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'Y',
  p_show_select_columns       =>'Y',
  p_show_filter               =>'Y',
  p_show_sort                 =>'Y',
  p_show_control_break        =>'Y',
  p_show_highlight            =>'Y',
  p_show_computation          =>'Y',
  p_show_aggregate            =>'Y',
  p_show_chart                =>'Y',
  p_show_calendar             =>'N',
  p_show_flashback            =>'Y',
  p_show_reset                =>'Y',
  p_show_download             =>'Y',
  p_show_help            =>'Y',
  p_download_formats          =>'CSV',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="" />',
  p_allow_exclude_null_values =>'Y',
  p_allow_hide_extra_columns  =>'Y',
  p_owner                     =>'WAG');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453216583631729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_FILE',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'Filename',
  p_report_label           =>'Filename',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#DLC_URL_PATHNAME##DOC_FILE#',
  p_column_linktext        =>'#DOC_FILE#',
  p_column_link_attr       =>'target="_blank"',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453328301631729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_COMPL_TYPE',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Type',
  p_report_label           =>'Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453432139631729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_REFERENCE_CODE',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Reference Code',
  p_report_label           =>'Reference Code',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453521324631729+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_TITLE',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453620548631731+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_CATEGORY',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Category',
  p_report_label           =>'Category',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453731609631731+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DOC_DESCR',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Description',
  p_report_label           =>'Description',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'WITHOUT_MODIFICATION',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2453131968631723+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'DLC_URL_PATHNAME',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'Dlc Url Pathname',
  p_report_label           =>'Dlc Url Pathname',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'HIDDEN',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 2454047302656582+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_worksheet_id => 2452936623631666+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PUBLIC',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'DOC_FILE:DOC_COMPL_TYPE:DOC_REFERENCE_CODE:DOC_TITLE:DOC_CATEGORY:DOC_DESCR:DLC_URL_PATHNAME',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 3
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00005
prompt  ...PAGE 5: Map
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript" src="/mapviewer/fsmc/jslib/oraclemaps.js"></script>'||chr(10)||
'<script language="Javascript" src="/exor/wagplan_24.js"></script>'||chr(10)||
'';

wwv_flow_api.create_page(
  p_id     => 5,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TPC',
  p_name   => 'Map',
  p_alias  => 'MAP',
  p_step_title=> 'Map',
  p_html_page_onload=>'onload="showMap(&P0_OSGR_X. , &P0_OSGR_Y.);first_field()"'||chr(10)||
'',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090617092027',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>5,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<div id="map" style="left:0px; top:0px; width:900px; height:600px; margin:1px;padding:1px;border:1px'||chr(10)||
'solid #CFE0F1"></div>';

wwv_flow_api.create_page_plug (
  p_id=> 66411975216281133 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 5,
  p_plug_name=> 'Map ([UPRN: &P0_PROPERTY_REF_PARAMETER.]   [Enquiry ID: &P0_DOC_ID_PARAMETER.]   [OSGRX: &P0_OSGR_X.]   [OSGRY: &P0_OSGR_Y.])',
  p_region_name=>'',
  p_plug_template=> 63124335852599616+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4870247867066025 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5,
  p_name=>'P5_OSGR_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 66411975216281133+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Osgr X',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN_PROTECTED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4871163496098970 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 5,
  p_name=>'P5_OSGR_Y',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 66411975216281133+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Osgr Y',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN_PROTECTED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 5
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00101
prompt  ...PAGE 101: Login
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 101,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Login',
  p_alias  => 'LOGIN',
  p_step_title=> 'Login',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 63117944170599607+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'WAG',
  p_last_upd_yyyymmddhh24miss => '20090320135747',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 78941117473650747 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'Login',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>47239553905917639 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::P0_DOC_ID_PARAMETER,P0_PROPERTY_REF_PARAMETER:&P0_DOC_ID_PARAMETER.,&P0_PROPERTY_REF_PARAMETER.',
  p_branch_point=> 'BEFORE_HEADER',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 03-JUL-2008 17:20 by WAG');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>29514618925123274 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PROPERTY_REF_PARAMETER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 78941117473650747+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'PROP1',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'10002516120',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136532572599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>64744358000176980 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_DOC_ID_PARAMETER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 78941117473650747+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Incident ID',
  p_source=>'14020',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>78941205112650747 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_USERNAME',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 78941117473650747+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'User Name',
  p_display_as=> 'TEXT',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>78941300982650747 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PASSWORD',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 78941117473650747+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'Password',
  p_display_as=> 'PASSWORD_WITH_ENTER_SUBMIT',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63136755972599641+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_encrypt_session_state_yn=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>78941412162650747 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_LOGIN',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 78941117473650747+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default => 'Login',
  p_prompt=>'Login',
  p_source=>'LOGIN',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(63120550297599611 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'owa_util.mime_header(''text/html'', FALSE);'||chr(10)||
'owa_cookie.send('||chr(10)||
'    name=>''LOGIN_USERNAME_COOKIE'','||chr(10)||
'    value=>lower(:P101_USERNAME));'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 78941617123650750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'wwv_flow_custom_auth_std.login('||chr(10)||
'    P_UNAME       => :P101_USERNAME,'||chr(10)||
'    P_PASSWORD    => :P101_PASSWORD,'||chr(10)||
'    P_SESSION_ID  => v(''APP_SESSION''),'||chr(10)||
'    P_FLOW_PAGE   => :APP_ID||'':1'''||chr(10)||
'    );';

wwv_flow_api.create_page_process(
  p_id     => 78941509351650748 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Login',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'101';

wwv_flow_api.create_page_process(
  p_id     => 78941822096650750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear Page(s) Cache',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v varchar2(255) := null;'||chr(10)||
'    c owa_cookie.cookie;'||chr(10)||
'begin'||chr(10)||
'   c := owa_cookie.get(''LOGIN_USERNAME_COOKIE'');'||chr(10)||
'   :P101_USERNAME := c.vals(1);'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 78941722095650750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 101
--
 
begin
 
null;
end;
null;
 
end;
/

prompt  ...lists
--
--application/shared_components/navigation/breadcrumbs
prompt  ...breadcrumbs
--
 
begin
 
wwv_flow_api.create_menu (
  p_id=> 78941921583650750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> ' Breadcrumb');
 
null;
 
end;
/

prompt  ...page templates for application: 624
--
--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 63091944123571227
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>'||chr(10)||
'';

c3:=c3||'<div class="t17messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<table align="center" border="0" cellpadding="0" cellspacing="0" summary="" class="t17Login">'||chr(10)||
'<tr>'||chr(10)||
'<td>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_03##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 63091944123571227 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '<div id="t17NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavigationBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 17,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs
prompt  ......Page template 63092147947571241
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t17Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>';

c3:=c3||''||chr(10)||
'<div id="t17ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63092147947571241 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_with_sidebar
prompt  ......Page template 63092455887571241
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" height="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17ContentLeftTop"><br /></td>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="200" id="t17ContentLeft">#REGION_POSITION_02#<br /></td>';

c3:=c3||''||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t17Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t17ContentMiddle" style="padding:5px;">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63092455887571241 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs
prompt  ......Page template 63092731830571241
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" height="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17Tabs">#TAB_CELLS#</div><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t17Messages">#GLOBAL_NOTIFICAT';

c3:=c3||'ION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t17ContentMiddle" style="padding:5px;">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63092731830571241 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_with_sidebar
prompt  ......Page template 63093042892571243
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" height="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17ContentLeftTop"><br /></td>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17Tabs">#TAB_CELLS#</div><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="200" id="t17ContentLe';

c3:=c3||'ft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t17Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t17ContentMiddle" style="padding:5px;">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63093042892571243 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 63093344828571243
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top">'||chr(10)||
'<div style="border:1px solid black;">#SUCCESS_MESSAG';

c3:=c3||'E##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 63093344828571243 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t17NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 63093643557571243
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<t';

c3:=c3||'d width="100%" valign="top"><div class="t17messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63093643557571243 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t17NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 17,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs
prompt  ......Page template 63093962643571243
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17Tabs">#PARENT_TAB_CELLS#</div><div id="t17Tabs">#TAB_CELLS#</div><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t1';

c3:=c3||'7Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t17ContentMiddle" style="padding:5px;">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63093962643571243 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '8');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_sidebar
prompt  ......Page template 63094241692571244
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Left" valign="top"><span id="t17UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t17Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t17Right" valign="top"><span id="t17Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t17Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t17HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t17NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t17PageB';

c3:=c3||'ody"  width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" id="t17ContentBody">'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0" height="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t17ContentLeftTop"><br /></td>'||chr(10)||
'<td colspan="2" valign="top" height="0"><div id="t17Tabs">#PARENT_TAB_CELLS#</div><div id="t17Tabs">#TAB_CELLS#</div><div id="t17BreadCrumbsLeft">#REGION_POSITION_01#</div></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td';

c3:=c3||' valign="top" width="200" id="t17ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" height="100%">'||chr(10)||
'<div id="t17Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t17ContentMiddle" style="padding:5px;">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t17ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table><';

c3:=c3||'/td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63094241692571244 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t17success" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<a href="#TAB_LINK#" class="t17CurrentTab">#TAB_LABEL#</a>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<a href="#TAB_LINK#" class="t17Tab">#TAB_LABEL#</a>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t17notification" id="MESSAGE"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''MESSAGE'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t17NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 17,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 63117944170599607
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div><div class="t13NewBottom2">&MSG_COPYRIGHT.</div><br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t13Logo2">#LOGO#</div>'||chr(10)||
'<div class="t13Sep"><br/></div>'||chr(10)||
'<div id="t13BreadcrumbTop">&nbsp;</div>'||chr(10)||
'<div class="t13BreadcrumbRegion"><br /></div>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13MessageHolder">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="70%" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valig';

c3:=c3||'n="top">#REGION_POSITION_01#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top" width="100%" align="center"><table cellspacing="0" cellpadding="0" border="0" class="t13Sidebar" summary="" align="center" style="width:400px;">'||chr(10)||
'<thead>'||chr(10)||
'<tr>'||chr(10)||
'<th class="L"><br /></th>'||chr(10)||
'<th class="C">&nbsp;</th>'||chr(10)||
'<th class="R"><br /></th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="3" ';

c3:=c3||'class="B">#REGION_POSITION_02##REGION_POSITION_04##BOX_BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table></td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top" style="width:100%"><div style="float:right;">#REGION_POSITION_03##REGION_POSITION_05#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63117944170599607 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2" width="100%"',
  p_theme_id  => 13,
  p_theme_class_id => 6,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs
prompt  ......Page template 63118152236599608
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13BreadcrumbTop">&nbsp;</div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" bo';

c3:=c3||'rder="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#<span id="t13Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13MessageHolder">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="7';

c3:=c3||'0%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITION_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63118152236599608 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>'||chr(10)||
'',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>'||chr(10)||
'',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2" width=""',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_with_sidebar
prompt  ......Page template 63118457627599608
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13BreadcrumbTop">&nbsp;</div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" bo';

c3:=c3||'rder="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#<span id="t13Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13MessageHolder">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="7';

c3:=c3||'0%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#REGION_POSITION_02#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITION_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63118457627599608 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>'||chr(10)||
'',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>'||chr(10)||
'',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2" width=""',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 17,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs
prompt  ......Page template 63118740619599608
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13PageTabs"><table cellpadding="0" cellspacing="0" border="0" summary="" class="t13PageTa';

c3:=c3||'bs"><tbody><tr>#TAB_CELLS#</tr></tbody></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t13BreadcrumbTop">&nbsp;</div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#<span id="t13Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13MessageHolder">#SUCCESS_ME';

c3:=c3||'SSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITION_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'';

c3:=c3||'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63118740619599608 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>'||chr(10)||
'',
  p_current_tab=> '<td class="OnL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnL.png" alt="" /></td>'||chr(10)||
'<td class="OnC"><span>#TAB_LABEL#</span></td>'||chr(10)||
'<td class="OnR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnR.png" alt="" /></td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td class="OffL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffL.png" alt="" /></td>'||chr(10)||
'<td class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td class="OffR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffR.png" alt="" /></td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> 'class="parenttabtextoff"',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>'||chr(10)||
'',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_with_sidebar
prompt  ......Page template 63119061692599608
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13PageTabs"><table cellpadding="0" cellspacing="0" border="0" summary="" class="t13PageTa';

c3:=c3||'bs"><tbody><tr>#TAB_CELLS#</tr></tbody></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t13BreadcrumbTop">&nbsp;</div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#<span id="t13Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13MessageHolder">#SUCCESS_ME';

c3:=c3||'SSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#REGION_POSITION_02#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="htmldbColumnSep"><br ';

c3:=c3||'/></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITION_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63119061692599608 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>'||chr(10)||
'',
  p_current_tab=> '<td class="OnL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnL.png" alt="" /></td>'||chr(10)||
'<td class="OnC"><span>#TAB_LABEL#</span></td>'||chr(10)||
'<td class="OnR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnR.png" alt="" /></td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td class="OffL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffL.png" alt="" /></td>'||chr(10)||
'<td class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td class="OffR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffR.png" alt="" /></td>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>'||chr(10)||
'',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 16,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 63119333690599610
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top"><div class="t13messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_01##REGION_POSITION_02##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 63119333690599610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 63119637403599610
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top">'||chr(10)||
'<div style="border:1px solid black;">#SUCCESS_MESSAG';

c3:=c3||'E##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_05#';

wwv_flow_api.create_template(
  p_id=> 63119637403599610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 13,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs
prompt  ......Page template 63119933186599610
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13PageTabs"><table cellpadding="0" cellspacing="0" border="0" summary="" class="t13PageTa';

c3:=c3||'bs"><tbody><tr>#PARENT_TAB_CELLS#</tr></tbody></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t13BreadcrumbTop2"><div>#TAB_CELLS#</div></div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#</div><span id="t13Customize">#CUSTOMIZE#</span></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13Me';

c3:=c3||'ssageHolder">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITI';

c3:=c3||'ON_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63119933186599610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<span class="OnC">#TAB_LABEL#</span><b>|</b>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<span class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></span><b>|</b>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td class="OnL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnL.png" alt="" /></td>'||chr(10)||
'<td class="OnC"><span>#TAB_LABEL#</span></td>'||chr(10)||
'<td class="OnR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnR.png" alt="" /></td>'||chr(10)||
''||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td class="OffL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffL.png" alt="" /></td>'||chr(10)||
'<td class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td class="OffR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffR.png" alt="" /></td>'||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="2" width=""',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_sidebar
prompt  ......Page template 63120251359599610
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns="http://www.w3.org/1999/xhtml" xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_3_1.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#><noscript>&MSG_JSCRIPT.</noscript>#FORM_OPEN#<a name="PAGETOP"></a>';

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div><div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE#'||chr(10)||
'<a name="END"><br /></a>'||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><a id="t13Logo2" href="#">#LOGO#</a><br />#REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t13PageTabs"><table cellpadding="0" cellspacing="0" border="0" summary="" class="t13PageTa';

c3:=c3||'bs"><tbody><tr>#PARENT_TAB_CELLS#</tr></tbody></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t13BreadcrumbTop2"><div>#TAB_CELLS#</div></div>'||chr(10)||
'<table class="t13Layout" cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13BreadcrumbRegion"><div class="t13Breadcrumbs">#REGION_POSITION_01#</div><span id="t13Customize">#CUSTOMIZE#</span></td>'||chr(10)||
'</table>'||chr(10)||
'<a name="SkipRepNav"></a>'||chr(10)||
'<div id="t13Me';

c3:=c3||'ssageHolder">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE##GLOBAL_NOTIFICATION#</div>'||chr(10)||
'<div class="t13BodyMargin">'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#REGION_POSITION_02#</td>'||chr(10)||
'<td class="t13ColumnSep"><div class="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top" width="100%">#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td class="t13ColumnSep"><div clas';

c3:=c3||'s="t13ColumnSep"><br /></div></td>'||chr(10)||
'<td valign="top"><div style="float:right;">#REGION_POSITION_03#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 63120251359599610 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t13SuccessMessage">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<span class="OnC">#TAB_LABEL#</span><b>|</b>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<span class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></span><b>|</b>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td class="OnL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnL.png" alt="" /></td>'||chr(10)||
'<td class="OnC"><span>#TAB_LABEL#</span></td>'||chr(10)||
'<td class="OnR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnR.png" alt="" /></td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td class="OffL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffL.png" alt="" /></td>'||chr(10)||
'<td class="OffC"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td class="OffR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffR.png" alt="" /></td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t13Notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div id="t13NavBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t13NavLink">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width=""',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 13,
  p_theme_class_id => 18,
  p_error_page_template => '<br />'||chr(10)||
'<br />'||chr(10)||
'<pre>#MESSAGE#</pre>'||chr(10)||
'<a href="#BACK_LINK#">#RETURN_TO_APPLICATION#</a>',
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

prompt  ...button templates
--
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 63094554396571244
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<input onclick="#LINK#" class="t17Button" value="#LABEL#" type="button" />';

wwv_flow_api.create_button_templates (
  p_id=>63094554396571244 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 63094735624571244
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<input onclick="#LINK#" class="t17ButtonAlternative1" value="#LABEL#" type="button" />';

wwv_flow_api.create_button_templates (
  p_id=>63094735624571244 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1',
  p_translate_this_template => 'N',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_template_comment       => 'XP Square FFFFFF');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 63094952659571244
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<input onclick="#LINK#" class="t17ButtonAlternative2" value="#LABEL#" type="button" />';

wwv_flow_api.create_button_templates (
  p_id=>63094952659571244 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 17,
  p_theme_class_id => 5,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 63095143719571244
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<input onclick="#LINK#" class="t17ButtonAlternative3" value="#LABEL#" type="button" />';

wwv_flow_api.create_button_templates (
  p_id=>63095143719571244 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 63120550297599611
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<input type="button" onclick="#LINK#" value="#LABEL#" class="t13Button" />';

wwv_flow_api.create_button_templates (
  p_id=>63120550297599611 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 63120744491599611
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t13ButtonAlternative1">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>63120744491599611 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1',
  p_translate_this_template => 'N',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 63120957208599611
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t13ButtonAlternative2">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>63120957208599611 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 13,
  p_theme_class_id => 5,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 63121136252599611
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t13ButtonAlternative3">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>63121136252599611 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_template_comment       => '');
end;
/
---------------------------------------
prompt  ...region templates
--
--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 63095357545571244
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="" style="border:none;">'||chr(10)||
'<tbody class="borderless">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY';

t:=t||'#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63095357545571244 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Borderless Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 17,
  p_theme_class_id => 7,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63095357545571244 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 63095639748571244
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="" style="border:none;">'||chr(10)||
'<tbody class="bracket">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</';

t:=t||'td></tr>'||chr(10)||
'<tr><td class="t17Bracket">&nbsp;</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63095639748571244 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Bracketed Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 18,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63095639748571244 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 63095937086571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# class="t17Breadcrumbs">#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63095937086571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Breadcrumb Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 6,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63095937086571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 63096254528571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="buttonregionwithtitle">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63096254528571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region with Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63096254528571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 63096558297571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="buttonregionwithouttitle">'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63096558297571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region without Title',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 17,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63096558297571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 63096844180571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="Chart">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</tab';

t:=t||'le>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63096844180571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 30,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63096844180571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 63097131493571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="form">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</tabl';

t:=t||'e>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63097131493571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Form Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 17,
  p_theme_class_id => 8,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63097131493571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 63097455472571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="hideshow">'||chr(10)||
'<tr><th class="t17RegionHeader"><img src="#IMAGE_PREFIX#themes/theme_17/collapse_plus.gif" onclick="htmldb_ToggleWithImage(this,''#REGION_ID#body'')" class="pb" alt="" />#TITLE#</th></tr>'||chr(10)||
'</tbody>'||chr(10)||
'<tbody id="#REGION_ID#body" style="display:none;" class=';

t:=t||'"hideshowcontent">'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63097455472571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Hide and Show Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63097455472571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/list_region_with_icon_chart
prompt  ......region template 63097737834571246
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="listregionwithicon">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr class="ChartIcon"><td class="t17RegionBody">';

t:=t||'#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63097737834571246 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'List Region with Icon (Chart)',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63097737834571246 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 63098032702571247
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# style="border:none;">'||chr(10)||
'<div class="NavigationRegion">'||chr(10)||
'<div class="t17RegionHeader">#TITLE#</div>'||chr(10)||
'<div class="t17RegionBody">#BODY#<img src="IMAGE_PREFIX#themes/theme_17/1px_trans.gif" width="200" height="1" alt="" /></div>'||chr(10)||
'</div>'||chr(10)||
'</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63098032702571247 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63098032702571247 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 63098339246571247
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# style="border:none;">'||chr(10)||
'<div class="NavigationRegionAlternative1">'||chr(10)||
'<div class="t17RegionHeader">#TITLE#</div>'||chr(10)||
'<div class="t17RegionBody">#BODY#<img src="IMAGE_PREFIX#themes/theme_17/1px_trans.gif" width="200" height="1" alt="" /></div>'||chr(10)||
'</div>'||chr(10)||
'</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63098339246571247 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region, Alternative 1',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 16,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63098339246571247 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_title
prompt  ......region template 63098647601571247
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary=""><tbody class="regionwithoutbuttonsandtitle"><tr><td class="t17RegionBody">#BODY#</td></tr></tbody></table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63098647601571247 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Buttons and Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 19,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63098647601571247 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 63098938636571247
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary=""><tbody class="regionwithouttitle"><tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr><tr><td class="t17RegionBody">#BODY#</td></tr></tbody></table>'||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63098938636571247 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 11,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63098938636571247 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_filter_single_row
prompt  ......region template 63099246991571247
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="apex_finderbar" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_top" valign="top"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8" alt=""  class="spacer" alt="" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle"><img src="#IMAGE_PREFIX#htmldb/builder/builder_f';

t:=t||'ind.png" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle" style="">#BODY#</td>'||chr(10)||
'<td class="apex_finderbar_left" rowspan="3" width="10"><br /></td>'||chr(10)||
'<td class="apex_finderbar_buttons" rowspan="3" valign="middle" nowrap="nowrap"><span class="apex_close">#CLOSE#</span><span>#EDIT##CHANGE##DELETE##CREATE##CREATE2##COPY##PREVIOUS##NEXT##EXPAND##HELP#</span></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="';

t:=t||'apex_finderbar_left_middle"><br /></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_bottom" valign="bottom"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8"  class="spacer" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63099246991571247 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report Filter - Single Row',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 31,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63099246991571247 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_list
prompt  ......region template 63099549278571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary=""><tbody class="listregionwithicon"><tr><th class="t17RegionHeader">#TITLE#</th></tr><tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr class="ReportIcon"><td class="t17RegionBody">#B';

t:=t||'ODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63099549278571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63099549278571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 63099842123571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="" width="100%" style="border:none;">'||chr(10)||
'<tbody class="ReportsRegion">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t17RegionHeader">#TITLE#</th>'||chr(10)||
'<th class="t17RegionHeader2" width="100%"><br /></th>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17ButtonHolder" colspan="2">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANG';

t:=t||'E##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17RegionBody" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63099842123571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 9,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63099842123571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 63100137741571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="" width="100%" style="border:none;">'||chr(10)||
'<tbody class="ReportsRegion100Width">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t17RegionHeader">#TITLE#</th>'||chr(10)||
'<th class="t17RegionHeader2" width="100%"><br /></th>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17ButtonHolder" colspan="2">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDI';

t:=t||'T##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17RegionBody" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63100137741571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region 100% Width',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 13,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63100137741571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 63100449623571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="ReportsRegionAlternative1">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td>';

t:=t||'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63100449623571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region, Alternative 1',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 17,
  p_theme_class_id => 10,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63100449623571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 63100751847571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="SidebarRegion">'||chr(10)||
'<tr><th class="t17RegionHeader" width="100%">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#<img src="IMAGE_PREFIX#themes/theme_17/1px_trans.gif" width="200" height="1" alt="" /></td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63100751847571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63100751847571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 63101053742571249
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="SidebarRegionAlternative1">'||chr(10)||
'<tr><th class="t17RegionHeader" width="100%">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#<img src="IMAGE_PREFIX#themes/theme_17/1px_trans.gif" width="200" height="1" alt="" /></td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63101053742571249 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region, Alternative 1',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63101053742571249 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 63101338182571250
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="wizard">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</ta';

t:=t||'ble>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63101338182571250 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 12,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63101338182571250 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 63101645446571250
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t17Region" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tbody class="wizardwithicon">'||chr(10)||
'<tr><th class="t17RegionHeader">#TITLE#</th></tr>'||chr(10)||
'<tr><td class="t17ButtonHolder">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t17RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbo';

t:=t||'dy>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63101645446571250 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region with Icon',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 17,
  p_theme_class_id => 20,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63101645446571250 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 63121336099599611
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13BorderlessRegion" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13';

t:=t||'RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63121336099599611 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Borderless Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 13,
  p_theme_class_id => 7,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63121336099599611 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 63121638918599611
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t13BracketedRegion" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13bracket"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="5" width="1" alt="" /></td>'||chr(10)||
'<td rowspan="3" class="t13RegionBody">'||chr(10)||
'<div class="t13RegionButt';

t:=t||'ons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div>#BODY#</td>'||chr(10)||
'<td class="t13bracket"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="5" width="1" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="48" width="1" alt="" /></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gi';

t:=t||'f" height="48" width="1" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13bracket"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="5" width="1" alt="" /></td>'||chr(10)||
'<td class="t13bracket"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="5" width="1" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63121638918599611 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Bracketed Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 13,
  p_theme_class_id => 18,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63121638918599611 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 63121954153599613
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div  id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63121954153599613 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Breadcrumb Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 6,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63121954153599613 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 63122258340599613
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ButtonRegionwithTitle" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63122258340599613 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region with Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63122258340599613 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 63122547848599613
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ButtonRegionwithoutTitle" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63122547848599613 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region without Title',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 13,
  p_theme_class_id => 17,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63122547848599613 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_list
prompt  ......region template 63122847359599613
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ListRegionwithIcon" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t';

t:=t||'13RegionBody"><table summary="" cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_13/chart.gif" alt="Chart"/></td>'||chr(10)||
'<td valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63122847359599613 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 13,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63122847359599613 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 63123144437599615
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ChartRegion" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13Regio';

t:=t||'nBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63123144437599615 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart Region',
  p_plug_table_bgcolor     => '#FFFFFF',
  p_theme_id  => 13,
  p_theme_class_id => 30,
  p_plug_heading_bgcolor => '#FFFFFF',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63123144437599615 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 63123454185599615
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13FormRegion" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13Region';

t:=t||'Body">#BODY#<img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif" height="1" width="500" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63123454185599615 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Form Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 8,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'Form Region is shimed out a minimum of 600px');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63123454185599615 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 63123752955599615
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13FormRegion" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#<img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#REGION_ID#Body'')" style="margin:0 5px;" class="pseudoButtonInactive" /></th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE';

t:=t||'#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody id="#REGION_ID#Body" style="display:none;">'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63123752955599615 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Hide and Show Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63123752955599615 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 63124059364599615
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13NavigationRegion" border="0" cellpadding="0" cellspacing="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63124059364599615 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63124059364599615 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 63124335852599616
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13NavigationRegionAlternative1" border="0" cellpadding="0" cellspacing="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader"><tr><th class="t13RegionTitle">#TITLE#</th></tr></thead>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63124335852599616 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region, Alternative 1',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 16,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63124335852599616 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_title
prompt  ......region template 63124658135599616
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13RegionWithoutButtonTitle" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63124658135599616 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Buttons and Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 19,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63124658135599616 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 63124934941599616
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13RegionWithoutTitle" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63124934941599616 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 11,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63124934941599616 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_filter_single_row
prompt  ......region template 63125239603599616
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="apex_finderbar" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_top" valign="top"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8" alt=""  class="spacer" alt="" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle"><img src="#IMAGE_PREFIX#htmldb/builder/builder_f';

t:=t||'ind.png" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle" style="">#BODY#</td>'||chr(10)||
'<td class="apex_finderbar_left" rowspan="3" width="10"><br /></td>'||chr(10)||
'<td class="apex_finderbar_buttons" rowspan="3" valign="middle" nowrap="nowrap"><span class="apex_close">#CLOSE#</span><span>#EDIT##CHANGE##DELETE##CREATE##CREATE2##COPY##PREVIOUS##NEXT##EXPAND##HELP#</span></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="';

t:=t||'apex_finderbar_left_middle"><br /></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_bottom" valign="bottom"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8"  class="spacer" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63125239603599616 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report Filter - Single Row',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 31,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63125239603599616 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_list
prompt  ......region template 63125552380599618
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ListRegionwithIcon" cellspacing="0" cellpadding="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t';

t:=t||'13RegionBody"><table summary="" cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_13/report.gif""/></td>'||chr(10)||
'<td valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63125552380599618 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 13,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63125552380599618 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 63125835672599618
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ReportRegion" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons" valign="bottom">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2';

t:=t||'" class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63125835672599618 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region',
  p_plug_table_bgcolor     => '#FFFFFF',
  p_theme_id  => 13,
  p_theme_class_id => 9,
  p_plug_heading_bgcolor => '#FFFFFF',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63125835672599618 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 63126159018599618
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ReportRegion" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES# width="100%">'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" c';

t:=t||'lass="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63126159018599618 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region 100% Width',
  p_plug_table_bgcolor     => '#FFFFFF',
  p_theme_id  => 13,
  p_theme_class_id => 13,
  p_plug_heading_bgcolor => '#FFFFFF',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63126159018599618 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 63126455132599618
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13ReportRegionAlt1" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons" valign="bottom">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspa';

t:=t||'n="2" class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63126455132599618 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region, Alternative 1',
  p_plug_table_bgcolor     => '#FFFFFF',
  p_theme_id  => 13,
  p_theme_class_id => 10,
  p_plug_heading_bgcolor => '#FFFFFF',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63126455132599618 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 63126732505599619
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellspacing="0" cellpadding="0" border="0" class="t13Sidebar" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead>'||chr(10)||
'<tr>'||chr(10)||
'<th class="L"><br /></th>'||chr(10)||
'<th class="C">#TITLE#</th>'||chr(10)||
'<th class="R"><br /></th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="3" class="B">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63126732505599619 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region',
  p_plug_table_bgcolor     => '#F7F7E7',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_plug_heading_bgcolor => '#F7F7E7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'Y',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63126732505599619 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 63127042183599619
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellspacing="0" cellpadding="0" border="0" class="t13SidebarAlt1" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead>'||chr(10)||
'<tr><th class="L"><br /></th><th class="C">#TITLE#</th><th class="R"><br /></th></tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="3" class="B">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63127042183599619 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region, Alternative 1',
  p_plug_table_bgcolor     => '#F7F7E7',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_plug_heading_bgcolor => '#F7F7E7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63127042183599619 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 63127355106599619
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13WizardRegion" summary="" cellpadding="0" cellspacing="0" border="0" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t13Regi';

t:=t||'onBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63127355106599619 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 12,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63127355106599619 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 63127641496599619
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t13WizardRegion" summary="" cellpadding="0" cellspacing="0" border="0" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead class="t13RegionHeader">'||chr(10)||
'<tr>'||chr(10)||
'<th class="t13RegionTitle">#TITLE#</th>'||chr(10)||
'<th class="t13RegionButtons">#CLOSE#&nbsp;&nbsp;#PREVIOUS##NEXT#&nbsp;#DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</th>'||chr(10)||
'</tr>'||chr(10)||
'</thead>'||chr(10)||
'<tbody class="Confirm">'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2';

t:=t||'" class="t13RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 63127641496599619 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region with Icon',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 13,
  p_theme_class_id => 20,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 63127641496599619 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

prompt  ...List Templates
--
--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 63101950770571283
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t17Button" style="background-color:#CCCCCC;">#TEXT#</a>';

t2:=t2||'<a href="#LINK#" class="t17Button">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63101950770571283 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 17,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<div class="t17ButtonList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_menu_with_sublist
prompt  ......list template 63102138511571283
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63102138511571283 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Menu with Sublist',
  p_theme_id  => 17,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_tree
prompt  ......list template 63102437604571285
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>63102437604571285 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Tree',
  p_theme_id  => 17,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 63102750695571285
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="t17current"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/><br />#TEXT#</td>';

t2:=t2||'<td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/></a><br /><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63102750695571285 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<table class="t17HorizontalImageswithLabelList" cellpadding="0" border="0" cellspacing="0" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 63103034254571285
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t17current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63103034254571285 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="t17HorizontalLinksList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image
prompt  ......list template 63103361895571290
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt="" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt=""  /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63103361895571290 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image',
  p_theme_id  => 17,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image_custom_1
prompt  ......list template 63103640985571291
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63103640985571291 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image (Custom 1)',
  p_theme_id  => 17,
  p_theme_class_id => 9,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 63103939900571291
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td valign="bottom" class="t17SepL"><img src="#IMAGE_PREFIX#themes/theme_17/tab_list_left_cap.gif" /></td>'||chr(10)||
'<td class="t17CurrentListTab"><a class="t17CurrentListTab" href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td valign="bottom" class="t17SepR"><img src="#IMAGE_PREFIX#themes/theme_17/tab_list_right_cap.gif" /></td>';

t2:=t2||'<td><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63103939900571291 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 17,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0"  summary="" width="100%" class="t17TabbedNavigationList"><tbody><tr><td class="t17LeftTabList">&nbsp;&nbsp;&nbsp;&nbsp;</td>',
  p_list_template_after_rows=>'<td class="t17EndCap" width="100%">&nbsp;</td></tr></tbody></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tree_list
prompt  ......list template 63104246649571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>63104246649571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tree List',
  p_theme_id  => 17,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="htmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 63104548841571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td class="t17current"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t2:=t2||'<tr><td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63104548841571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 17,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t17VerticalImagesList">',
  p_list_template_after_rows=>'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list_custom_2
prompt  ......list template 63104838596571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t2:=t2||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63104838596571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List (Custom 2)',
  p_theme_id  => 17,
  p_theme_class_id => 10,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="5" summary="" >',
  p_list_template_after_rows=>'</table>'||chr(10)||
'',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 63105149788571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t17current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63105149788571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="t17VerticalOrderedList">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 63105461102571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63105461102571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 17,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<div class="t17VerticalSidebarList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_links_without_bullets
prompt  ......list template 63105756932571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t17current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63105756932571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered Links without Bullets',
  p_theme_id  => 17,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="t17VerticalUnorderedLinkswithoutBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 63106050589571293
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t17current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63106050589571293 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="t17VerticalUnorderedListwithBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 63106345930571294
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="t17current">#TEXT#</div>';

t2:=t2||'<div>#TEXT#</div>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63106345930571294 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 17,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<div class="t17WizardProgressList">',
  p_list_template_after_rows=>'<center>&DONE.</center>'||chr(10)||
'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 63127950668599621
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t13Current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63127950668599621 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 13,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<div class="t13ButtonList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_menu_with_sublist
prompt  ......list template 63128242611599621
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#themes/theme_13/menu_open_right.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#themes/theme_13/menu_open_right.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63128242611599621 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Menu with Sublist',
  p_theme_id  => 13,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_tree
prompt  ......list template 63128542266599621
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>63128542266599621 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Tree',
  p_theme_id  => 13,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 63128858633599621
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="t13current"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/><br />#TEXT#</td>';

t2:=t2||'<td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/></a><br /><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63128858633599621 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<table class="t13HorizontalImageswithLabelList" cellpadding="0" border="0" cellspacing="0" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 63129153919599621
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t13current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63129153919599621 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="t13HorizontalLinksList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/page_tab_navigation
prompt  ......list template 63129454487599622
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="OnL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnL.png" alt="" /></td>'||chr(10)||
'<td class="OnC"><a href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td class="OnR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOnR.png" alt="" /></td>';

t2:=t2||'<td class="OffL"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffL.png" alt="" /></td>'||chr(10)||
'<td class="OffC"><a href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td class="OffR"><img src="#IMAGE_PREFIX#themes/theme_13/tabOffR.png" alt="" /></td>'||chr(10)||
'';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63129454487599622 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Page Tab Navigation',
  p_theme_id  => 13,
  p_theme_class_id => 0,
  p_list_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t13PageTabs">'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'',
  p_list_template_after_rows=>'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'This is the list template to simulate tabs in the builder application');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image
prompt  ......list template 63129760324599622
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt="" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down_nochild.png" width="20" height="128" alt=""  /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#menu/brush_bx_128x128.png" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63129760324599622 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image',
  p_theme_id  => 13,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image_custom_1
prompt  ......list template 63130036115599622
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>63130036115599622 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image (Custom 1)',
  p_theme_id  => 13,
  p_theme_class_id => 9,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 63130358919599624
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td valign="bottom" class="t13SepL"><img src="#IMAGE_PREFIX#themes/theme_13/tab_list_left_cap.gif" alt="" /></td>'||chr(10)||
'<td class="t13CurrentListTab"><a class="t13CurrentListTab" href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td valign="bottom" class="t13SepR"><img src="#IMAGE_PREFIX#themes/theme_13/tab_list_right_cap.gif" alt="" /></td>';

t2:=t2||'<td><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63130358919599624 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 13,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0"  summary="" width="100%" class="t13TabbedNavigationList"><tbody><tr><td class="t13LeftTabList">&nbsp;&nbsp;&nbsp;&nbsp;</td>',
  p_list_template_after_rows=>'<td class="t13EndCap" width="100%">&nbsp;</td></tr></tbody></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tree_list
prompt  ......list template 63130648088599624
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>63130648088599624 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tree List',
  p_theme_id  => 13,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="htmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 63130941148599624
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td class="t13current"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t2:=t2||'<tr><td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63130941148599624 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 13,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t13VerticalImagesList">',
  p_list_template_after_rows=>'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list_custom_2
prompt  ......list template 63131255289599624
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t2:=t2||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63131255289599624 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List (Custom 2)',
  p_theme_id  => 13,
  p_theme_class_id => 10,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="5" summary="" >',
  p_list_template_after_rows=>'</table>'||chr(10)||
'',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 63131534130599624
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t13current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63131534130599624 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="t13VerticalOrderedList">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 63131836864599625
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a class="t13current" href="#LINK#">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63131836864599625 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 13,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<div class="t13VerticalSidebarList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_links_without_bullets
prompt  ......list template 63132132244599625
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t13current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63132132244599625 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered Links without Bullets',
  p_theme_id  => 13,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="t13VerticalUnorderedLinkswithoutBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 63132436796599636
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t13current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63132436796599636 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="t13VerticalUnorderedListwithBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 63132751891599636
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="t13WizCurrent">#TEXT#</div>';

t2:=t2||'<div class="t13WizNon">#TEXT#</div>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>63132751891599636 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 13,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<div class="t13WizBar">',
  p_list_template_after_rows=>'</div>',
  p_between_items=>'<div class="t13WizArrow"><img src="#IMAGE_PREFIX#arrow_down.gif" width="7" height="6" alt="Down" /></div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

prompt  ...report templates
--
--application/shared_components/user_interface/templates/report/borderless
prompt  ......report template 63106657584571294
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t17data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63106657584571294 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t17Borderless" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>'||chr(10)||
'',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t17ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63106657584571294 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 63107131193571294
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t17data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63107131193571294 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t17HorizontalBorder" border="0" cellpadding="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t17ReportHeader"  id="#COLUMN_HEADER_NAME#" #ALIGNMENT#>#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63107131193571294 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 63107661062571296
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'#COLUMN_VALUE#';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63107661062571296 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr><td><ul class="t17OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63107661062571296 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<li>',
  p_row_template_after_last =>'</li>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 63108159030571296
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t17data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63108159030571296 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t17Standard">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t17ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63108159030571296 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_ppr
prompt  ......report template 63108639030571297
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t17data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63108639030571297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard (PPR)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div id="report#REGION_ID#"><htmldb:#REGION_ID#><table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t17Standard">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table><script language=JavaScript type=text/javascript>'||chr(10)||
'<!--'||chr(10)||
'init_htmlPPRReport(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'</htmldb:#REGION_ID#>'||chr(10)||
'</div>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t17ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 17,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63108639030571297 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 63109147165571297
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t17data">#COLUMN_VALUE#</td>';

c2:=c2||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t17dataalt">#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63109147165571297 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table border="0" cellpadding="0" cellspacing="0" summary="" class="t17StandardAlternatingRowColors">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t17ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 17,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63109147165571297 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs
prompt  ......report template 63109641262571299
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr>'||chr(10)||
'<th class="t17ReportHeader">#COLUMN_HEADER#</th>'||chr(10)||
'<td class="t17data">#COLUMN_VALUE#</td>'||chr(10)||
'</tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63109641262571299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr><td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t17ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="t17CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t17pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t17pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t17pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 17,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63109641262571299 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'',
  p_row_template_after_last =>'<tr><td colspan="2" class="t17seperate"><hr /></td></tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/borderless
prompt  ......report template 63133054009599638
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63133054009599638 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" class="t13Borderless"  border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'<tbody>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'<tfoot>#PAGINATION#</tfoot>'||chr(10)||
'</table>'||chr(10)||
'<span class="t13CSV">#CSV_LINK#</span>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t13ReportHeader">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_pagination_template=>'#TEXT#'||chr(10)||
'',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_row_style_mouse_over=>'#CCCCCC',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '<br /><img class="psuedoButton" src="#IMAGE_PREFIX#pdf.png" onclick="pdf_Grab_XML2(''f?p=&APP_ID.:&APP_PAGE_ID.:&SESSION.:FLOW_FOP_OUTPUT_#REGION_ID#'')" />');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63133054009599638 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 63133554850599638
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63133554850599638 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" class="t13HorizontalBorder"  border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'<tbody>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'<tfoot>#PAGINATION#</tfoot>'||chr(10)||
'</table>'||chr(10)||
'<span class="t13CSV">#CSV_LINK#</span>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t13ReportHeader">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_pagination_template=>'#TEXT#'||chr(10)||
'',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_row_style_mouse_over=>'#CCCCCC',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '<br /><img class="psuedoButton" src="#IMAGE_PREFIX#pdf.png" onclick="pdf_Grab_XML2(''f?p=&APP_ID.:&APP_PAGE_ID.:&SESSION.:FLOW_FOP_OUTPUT_#REGION_ID#'')" />');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63133554850599638 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 63134044849599640
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'#COLUMN_VALUE#';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63134044849599640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr><td><ul class="t13OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t13CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t13pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t13pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t13pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t13pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63134044849599640 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<li>',
  p_row_template_after_last =>'</li>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 63134533516599640
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63134533516599640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" class="t13Standard"  border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'<tbody>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'<tfoot>#PAGINATION#</tfoot>'||chr(10)||
'</table>'||chr(10)||
'<span class="t13CSV">#CSV_LINK#</span>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t13ReportHeader">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_pagination_template=>'#TEXT#'||chr(10)||
'',
  p_row_style_mouse_over=>'#CCCCCC',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63134533516599640 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_ppr
prompt  ......report template 63135055117599640
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63135055117599640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard (PPR)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div id="report#REGION_ID#"><htmldb:#REGION_ID#><table cellpadding="0" cellspacing="0" class="t13Standard"  border="0" summary="" id="#REGION_ID#" htmldb:href="p=&APP_ID.:&APP_PAGE_ID.:&SESSION.:pg_R_#REGION_ID#:NO:">'||chr(10)||
'<tbody>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'<tfoot>#PAGINATION#</tfoot>'||chr(10)||
'</table>'||chr(10)||
'<span class="t13CSV">#CSV_LINK#</span>'||chr(10)||
''||chr(10)||
'<script language=JavaScript type=text/javascript>'||chr(10)||
'<!--'||chr(10)||
'init_htmlPPRReport(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'</htmldb:#REGION_ID#>'||chr(10)||
'</div>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t13ReportHeader">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_pagination_template=>'#TEXT#'||chr(10)||
'',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-left:5px;"><img src="#IMAGE_PREFIX#jtfunexe.gif" alt="" /></a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" style="margin-right:5px;"><img src="#IMAGE_PREFIX#jtfupree.gif" alt=""/></a>',
  p_row_style_mouse_over=>'#CCCCCC',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 13,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '<br /><img class="psuedoButton" src="#IMAGE_PREFIX#pdf.png" onclick="pdf_Grab_XML2(''f?p=&APP_ID.:&APP_PAGE_ID.:&SESSION.:FLOW_FOP_OUTPUT_#REGION_ID#'')" />');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63135055117599640 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 63135541960599640
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13data">#COLUMN_VALUE#</td>';

c2:=c2||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t13dataalt">#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63135541960599640 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" class="t13Standard"  border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'<tbody>',
  p_row_template_after_rows =>'</tbody>'||chr(10)||
'<tfoot>#PAGINATION#</tfoot>'||chr(10)||
'</table>'||chr(10)||
'<span class="t13CSV">#CSV_LINK#</span>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t13ReportHeader">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'EVEN_ROW_NUMBERS',
  p_row_template_display_cond2=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'EVEN_ROW_NUMBERS',
  p_pagination_template=>'#TEXT#'||chr(10)||
'',
  p_row_style_mouse_over=>'#CCCCCC',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 13,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63135541960599640 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs
prompt  ......report template 63136044001599641
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr>'||chr(10)||
'<th class="t13ReportHeader">#COLUMN_HEADER#</th>'||chr(10)||
'<td class="t13data">#COLUMN_VALUE#</td>'||chr(10)||
'</tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 63136044001599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr>'||chr(10)||
'<td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t13ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="t13CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t13pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t13pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t13pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t13pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 13,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 63136044001599641 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'',
  p_row_template_after_last =>'<tr><td colspan="2" class="t13seperate"><hr /></td></tr>');
exception when others then null;
end;
null;
 
end;
/

prompt  ...label templates
--
--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 63110132760571299
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63110132760571299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="t17NoLabel">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t17InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 17,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label
prompt  ......label template 63110262391571299
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63110262391571299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t17OptionalLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t17InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label_with_help
prompt  ......label template 63110333585571299
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63110333585571299 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><a class="t17OptionalLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t17InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label
prompt  ......label template 63110448647571300
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63110448647571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t17RequiredLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t17InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 17,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label_with_help
prompt  ......label template 63110553867571300
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63110553867571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><a class="t17RequiredLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t17InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 63136532572599641
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63136532572599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="t13NoLabel">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t13InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 13,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label
prompt  ......label template 63136632605599641
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63136632605599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><span class="t13OptionalLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label_with_help
prompt  ......label template 63136755972599641
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63136755972599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><a class="t13OptionalLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'',''&CLOSE.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label
prompt  ......label template 63136857638599641
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63136857638599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t13RequiredLabel"><img src="#IMAGE_PREFIX#requiredicon_status2.gif" alt="" />',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t13InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 13,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label_with_help
prompt  ......label template 63136951785599641
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 63136951785599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><a class="t13RequiredLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'',''&CLOSE.'')" tabindex="999"><img src="#IMAGE_PREFIX#requiredicon_status2.gif" alt="" />',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'',
  p_on_error_after_label=>'',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

prompt  ...breadcrumb templates
--
--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 63110650103571300
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 63110650103571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'',
  p_current_page_option=>'<a href="#LINK#" class="t17BreadC">#NAME#</a>',
  p_non_current_page_option=>'<a href="#LINK#" class="t17Bread">#NAME#</a>',
  p_menu_link_attributes=>'',
  p_between_levels=>'<b>&gt;</b>',
  p_after_last=>'',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 63110746817571300
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 63110746817571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t17HierarchicalMenu">',
  p_current_page_option=>'<li class="t17current"><a href="#LINK#">#NAME#</a></li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 63137054175599641
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 63137054175599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'',
  p_current_page_option=>'<span class="t13Breadcrumb">#NAME#</span>',
  p_non_current_page_option=>'<a href="#LINK#" class="t13Breadcrumb">#NAME#</a>',
  p_menu_link_attributes=>'',
  p_between_levels=>'<span class="t13BreadcrumbSep">&gt;</span>',
  p_after_last=>'',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 63137151738599641
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 63137151738599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t13HierarchicalMenu">',
  p_current_page_option=>'<li class="t13current"><a href="#LINK#">#NAME#</a></li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/popuplov
prompt  ...popup list of values templates
--
prompt  ......template 63111443975571302
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 63111443975571302 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#list_gray.gif',
  p_popup_icon_attr=>'width="13" height="13" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_17/theme_3_1.css" type="text/css">'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" style="background-color:#FFFFFF;margin:0;"',
  p_before_field_text=>'<div class="t17PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t17PopupBody">',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ......template 63137859689599643
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 63137859689599643 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#list_gray.gif',
  p_popup_icon_attr=>'width="13" height="13" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_13/theme_V3.css" type="text/css">'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" style="background-color:#FFFFFF;margin:0;"',
  p_before_field_text=>'<div class="t13PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t13PopupBody">',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ...calendar templates
--
--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 63110844395571300
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63110844395571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="t17DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t17MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t17MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t17DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t17Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t17Today">',
  p_weekend_title_format=> '<div class="t17WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t17WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t17NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t17NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t17DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17WeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t17Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t17Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t17NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t17Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t17DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17DayCalendarHolder"> <tr> <td class="t17MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t17DayCalendar">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t17Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t17Today">',
  p_daily_time_open_format => '<th class="t17Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 17,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 63111048593571300
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63111048593571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="t17DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t17MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t17MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t17DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t17Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t17Today">',
  p_weekend_title_format=> '<div class="t17WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t17WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t17NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t17NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t17DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17WeekCalendarAlternative1">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t17Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t17Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t17NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t17Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t17DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17DayCalendarAlternative1Holder"> <tr><td class="t17MonthTitle">#IMONTH# #DD#, #YYYY#</td></tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t17DayCalendarAlternative1">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t17Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t17Today">',
  p_daily_time_open_format => '<th class="t17Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 17,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calendar
prompt  ......template 63111238666571300
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63111238666571300 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17SmallCalenderHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t17MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t17MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17SmallCalender">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t17DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t17Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t17Today">',
  p_weekend_title_format=> '<div class="t17WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t17WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t17NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t17NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t17MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t17DayOfWeek">#IDAY#<br />#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t17SmallWeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t17Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t17Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t17NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t17Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t17DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t17SmallDayCalendarHolder"> <tr> <td class="t17MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t17SmallDayCalendar">',
  p_daily_month_close_format => '</table></td></tr></table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t17Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t17Today">',
  p_daily_time_open_format => '<th class="t17Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 17,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 63137255426599641
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63137255426599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="t13DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t13MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="t13Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t13DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t13Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t13Today">',
  p_weekend_title_format=> '<div class="t13WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t13WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t13NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t13NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t13DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t13WeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t13Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t13Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t13NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t13Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t13DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13DayCalendarHolder"> <tr> <td class="t13MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t13DayCalendar">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t13Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t13Today">',
  p_daily_time_open_format => '<th class="t13Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 13,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 63137452252599641
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63137452252599641 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '<th class="t13DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t13MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t13CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t13DayTitle">#DD#</div><br />',
  p_day_open_format=> '<td class="t13Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t13Today">',
  p_weekend_title_format=> '<div class="t13WeekendDayTitle">#DD#</div><br />',
  p_weekend_open_format => '<td valign="top" class="t13WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t13NonDayTitle">#DD#</div><br />',
  p_nonday_open_format => '<td class="t13NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t13DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t13WeekCalendarAlternative1">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t13Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t13Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t13NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t13Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t13DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13DayCalendarAlternative1Holder"> <tr><td class="t13MonthTitle">#IMONTH# #DD#, #YYYY#</td></tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t13DayCalendarAlternative1">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t13Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t13Today">',
  p_daily_time_open_format => '<th class="t13Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 13,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calendar
prompt  ......template 63137660227599643
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 63137660227599643 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calendar',
  p_translate_this_template=> 'N',
  p_day_of_week_format=> '',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13SmallCalenderHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t13MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t13SmallCalender">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t13DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t13Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t13Today">',
  p_weekend_title_format=> '<div class="t13WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t13WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t13NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t13NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t13MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t13DayOfWeek">#IDAY#<br />#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t13SmallWeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t13Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t13Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t13NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t13Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t13DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t13SmallDayCalendarHolder"> <tr> <td class="t13MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t13SmallDayCalendar">',
  p_daily_month_close_format => '</table></td></tr></table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t13Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t13Today">',
  p_daily_time_open_format => '<th class="t13Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 13,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

prompt  ...application themes
--
--application/shared_components/user_interface/themes/greyscale
prompt  ......theme 63111646193571302
begin
wwv_flow_api.create_theme (
  p_id =>63111646193571302 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 17,
  p_theme_name=>'Greyscale',
  p_default_page_template=>63092731830571241 + wwv_flow_api.g_id_offset,
  p_error_template=>63092731830571241 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>63093643557571243 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>63091944123571227 + wwv_flow_api.g_id_offset,
  p_default_button_template=>63094554396571244 + wwv_flow_api.g_id_offset,
  p_default_region_template=>63099842123571249 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>63096844180571246 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>63097131493571246 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>63099842123571249 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>63099842123571249 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>63101338182571250 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>63095937086571246 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>63099842123571249 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>63108159030571296 + wwv_flow_api.g_id_offset,
  p_default_label_template=>63110333585571299 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>63110650103571300 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>63110844395571300 + wwv_flow_api.g_id_offset,
  p_default_list_template=>63106050589571293 + wwv_flow_api.g_id_offset,
  p_default_option_label=>63110333585571299 + wwv_flow_api.g_id_offset,
  p_default_required_label=>63110553867571300 + wwv_flow_api.g_id_offset);
end;
/
 
--application/shared_components/user_interface/themes/blue_gray
prompt  ......theme 63138048518599643
begin
wwv_flow_api.create_theme (
  p_id =>63138048518599643 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 13,
  p_theme_name=>'Blue Gray',
  p_default_page_template=>63118740619599608 + wwv_flow_api.g_id_offset,
  p_error_template=>63118740619599608 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>63119637403599610 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>63117944170599607 + wwv_flow_api.g_id_offset,
  p_default_button_template=>63120550297599611 + wwv_flow_api.g_id_offset,
  p_default_region_template=>63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>63123144437599615 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>63123454185599615 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>63127355106599619 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>63121954153599613 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>63125835672599618 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>63134533516599640 + wwv_flow_api.g_id_offset,
  p_default_label_template=>63136755972599641 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>63137054175599641 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>63137255426599641 + wwv_flow_api.g_id_offset,
  p_default_list_template=>63132436796599636 + wwv_flow_api.g_id_offset,
  p_default_option_label=>63136755972599641 + wwv_flow_api.g_id_offset,
  p_default_required_label=>63136951785599641 + wwv_flow_api.g_id_offset);
end;
/
 
prompt  ...build options used by application 624
--
 
begin
 
null;
 
end;
/

--application/shared_components/globalization/messages
prompt  ...messages used by application: 624
--
--application/shared_components/globalization/dyntranslations
prompt  ...dynamic translations used by application: 624
--
--application/shared_components/globalization/language
prompt  ...Language Maps for Application 624
--
 
begin
 
null;
 
end;
/

prompt  ...Shortcuts
--
--application/shared_components/user_interface/shortcuts/delete_confirm_msg
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'Would you like to perform this delete action?';

wwv_flow_api.create_shortcut (
 p_id=> 78978429768537784 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'DELETE_CONFIRM_MSG',
 p_shortcut_type=> 'TEXT_ESCAPE_JS',
 p_shortcut=> c1);
end;
null;
 
end;
/

prompt  ...web services (9iR2 or better)
--
prompt  ...shared queries
--
prompt  ...report layouts
--
prompt  ...authentication schemes
--
--application/shared_components/security/authentication/use_dad
prompt  ......scheme 47237728353815662
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1:=s1||'-DATABASE-';

s2 := null;
s3 := null;
s4 := null;
s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 47237728353815662 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'use_dad',
  p_description=>'Based on authentication scheme from gallery:No Authentication (using DAD)',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/shared_components/security/authentication/html_db
prompt  ......scheme 78940502640650743
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'-BUILTIN-';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 78940502640650743 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'HTML DB',
  p_description=>'Use internal Application Express account credentials and login page in this application.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/shared_components/security/authentication/database
prompt  ......scheme 78940611200650743
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1:=s1||'-DATABASE-';

s2 := null;
s3 := null;
s4 := null;
s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 78940611200650743 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE',
  p_description=>'Use database authentication (user identified by DAD).',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/shared_components/security/authentication/database_account
prompt  ......scheme 78940724935650743
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'return false; end;--';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 78940724935650743 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE ACCOUNT',
  p_description=>'Use database account credentials.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/end_environment
commit;
commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
