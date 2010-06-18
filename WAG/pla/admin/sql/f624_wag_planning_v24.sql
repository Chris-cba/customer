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
--   Date and Time:   13:56 Friday June 18, 2010
--   Exported By:     ITURNBULL
--   Flashback:       0
--   Export Type:     Application Export
--   Version: 3.2.1.00.11
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
-- Application Statistics:
--   Pages:                 6
--     Items:              37
--     Computations:        0
--     Validations:         0
--     Processes:          13
--     Regions:             8
--     Buttons:             4
--   Shared Components
--     Breadcrumbs:         1
--        Entries           0
--     Items:               4
--     Computations:        0
--     Processes:           4
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>987604084005712);
 
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
  p_alias => 'WAGPLAN',
  p_page_view_logging => 'YES',
  p_default_page_template=> 63118740619599608 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=> 63119637403599610 + wwv_flow_api.g_id_offset,
  p_default_region_template=> 63125835672599618 + wwv_flow_api.g_id_offset,
  p_error_template    => 63118740619599608 + wwv_flow_api.g_id_offset,
  p_page_protection_enabled_y_n=> 'Y',
  p_checksum_salt_last_reset => '20100618122530',
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
  p_substitution_string_01 => 'FRAMEWORK_VERSION',
  p_substitution_value_01  => '$Revision:   3.5  $',
  p_substitution_string_02 => 'MSG_COPYRIGHT',
  p_substitution_value_02  => '&copy: copyright exor corporation ltd 2009',
  p_last_updated_by => 'ITURNBULL',
  p_last_upd_yyyymmddhh24miss=> '20100618122530',
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
--application/shared_components/logic/application_processes/getmapvariables
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'apex_mapping_utils.get_map_variables(pi_product => ''WAGPAP'');';

wwv_flow_api.create_flow_process(
  p_id => 2040728238859715 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'getMapVariables',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/get_user_temp_value
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'htp.prn(apex_mapping_utils.get_cookie(pi_name => :TEMP_TYPE));';

wwv_flow_api.create_flow_process(
  p_id => 2040902050861545 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'GET_USER_TEMP_VALUE',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/ins_user_temp_values
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'apex_mapping_utils.save_cookie(pi_name     => :TEMP_TYPE'||chr(10)||
'                        ,PI_VALUE    => :TEMPVALUE);';

wwv_flow_api.create_flow_process(
  p_id => 2041108629863454 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'INS_USER_TEMP_VALUES',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/getmapcenterxy
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'apex_mapping_utils.GETMAPCENTERXY;';

wwv_flow_api.create_flow_process(
  p_id => 2041316941865822 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'getmapcenterxy',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

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

--application/shared_components/logic/application_items/fsp_process_state_1279329827464923
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 1281828011483376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'FSP_PROCESS_STATE_1279329827464923',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/tempvalue
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 2040519234857034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'TEMPVALUE',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/temp_type
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 2040315424855937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'TEMP_TYPE',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
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
  p_tab_name=> 'Associated Documents ',
  p_tab_text => 'Associated Documents (&P0_DOC_ASSOC_COUNT.)',
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
  p_last_upd_yyyymmddhh24miss => '20090706145042',
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
  p_id=>1270929051433314 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_WPRC_UPRN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 420,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1309402477749237 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 0,
  p_name=>'P0_DOC_ASSOC_COUNT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 430,
  p_item_plug_id => 78963422633904346+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Doc Assoc Count',
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
  p_last_updated_by => 'ALOW',
  p_last_upd_yyyymmddhh24miss => '20100104154317',
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
  p_column_link=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::P2_DOC_ID:#WPRCL_DOC_ID#',
  p_column_linktext=>'#WPRCL_DOC_ID#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '16',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
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
 
wwv_flow_api.create_page_button(
  p_id             => 1267307524323064 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1,
  p_button_sequence=> 40,
  p_button_plug_id => 17638111032717027+wwv_flow_api.g_id_offset,
  p_button_name    => 'PRINT',
  p_button_image   => 'template:'||to_char(63120550297599611+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print',
  p_button_position=> 'TOP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.:PRINT_REPORT=Report%20Card:&DEBUG.:::',
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
 
wwv_flow_api.create_page_branch(
  p_id=>1267622454323064 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_branch_action=> 'f?p=&FLOW_ID.:0:&SESSION.:PRINT_REPORT='||to_char(1265307197124296+wwv_flow_api.g_id_offset)||':&DEBUG.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>1267307524323064+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1304813879125028 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_LA_REF',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
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
  p_id=>1307308177637312 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_DOC_ASSOC_SUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1019,
  p_item_plug_id => 21099205192790367+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Doc Assoc Sum',
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
  p_prompt=>'&nbsp;&nbsp;&nbsp;UPRN&nbsp;&nbsp; ',
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
  p_begin_on_new_field=> 'YES',
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
  p_tag_attributes  => 'style="width:160px"',
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
'from dual;'||chr(10)||
''||chr(10)||
'select :P1_WPRC_UPRN'||chr(10)||
'into :P0_WPRC_UPRN'||chr(10)||
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
'if (:p101_property_ref_parameter is null)'||chr(10)||
'then :p101_property_ref_parameter := ''10002516120'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if (:p0_property_ref_parameter is null)'||chr(10)||
'then :p0_property_ref_parameter := :p101_property_ref_parameter;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if (:p101_doc_id_parameter is null)'||chr(10)||
'then :p101_doc_id_parameter := 23478;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if (:p0_doc_id_parameter is null)'||chr(10)||
'then :p0_doc_id_paramet';

p:=p||'er := :p101_doc_id_parameter;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'select nvl(max(wprcl_seq),0)'||chr(10)||
'into :P1_LAST_LINE_SEQ'||chr(10)||
'from wag_plan_record_card_lines'||chr(10)||
'where wprcl_wprc_uprn = :p0_property_ref_parameter;'||chr(10)||
''||chr(10)||
'select dec_ref'||chr(10)||
'into :p1_la_ref'||chr(10)||
'from doc_enquiry_contacts'||chr(10)||
'where dec_doc_id = :p0_doc_id_parameter'||chr(10)||
'and rownum = 1;'||chr(10)||
''||chr(10)||
'select count(1)'||chr(10)||
'into :p0_doc_assoc_count'||chr(10)||
'from   docs,'||chr(10)||
'       doc_assocs,'||chr(10)||
'       doc_locations'||chr(10)||
'where  das_rec_i';

p:=p||'d = :P0_DOC_ID_PARAMETER'||chr(10)||
'and    das_doc_id = doc_id'||chr(10)||
'and    doc_dlc_id = dlc_id;'||chr(10)||
''||chr(10)||
'insert into wag_plan_record_card'||chr(10)||
'  (wprc_uprn,'||chr(10)||
'   wprc_lpa,'||chr(10)||
'   wprc_location,'||chr(10)||
'   wprc_file_ref,'||chr(10)||
'   wprc_osgr_x,'||chr(10)||
'   wprc_osgr_y)'||chr(10)||
'select :p0_property_ref_parameter,'||chr(10)||
'       administrative_area,'||chr(10)||
'       location,'||chr(10)||
'       ''CZ-701-''||:p0_doc_id_parameter,'||chr(10)||
'       x_coordinate,'||chr(10)||
'       y_coordinate'||chr(10)||
'from nlpg_properties_v'||chr(10)||
'where u';

p:=p||'prn = :p0_property_ref_parameter'||chr(10)||
'and not exists ('||chr(10)||
'select ''x'''||chr(10)||
'from wag_plan_record_card'||chr(10)||
'where wprc_uprn = :p0_property_ref_parameter);'||chr(10)||
''||chr(10)||
'insert into wag_plan_record_card_lines'||chr(10)||
'   (wprcl_wprc_uprn,'||chr(10)||
'    wprcl_seq,'||chr(10)||
'    wprcl_doc_id)'||chr(10)||
'select :p0_property_ref_parameter,:P1_LAST_LINE_SEQ+1,:p0_doc_id_parameter'||chr(10)||
'from dual'||chr(10)||
'where not exists ('||chr(10)||
'select ''x'''||chr(10)||
'from wag_plan_record_card_lines'||chr(10)||
'where wprcl_wprc_uprn = :';

p:=p||'p0_property_ref_parameter'||chr(10)||
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
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1256826057016153 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 1,
  p_query_column_name=> 'WPRCL_WPRC_UPRN',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1256928956016154 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 2,
  p_query_column_name=> 'WPRCL_SEQ',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257026100016154 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 3,
  p_query_column_name=> 'CHR(WPRCL_SEQ+64)',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257108561016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 4,
  p_query_column_name=> 'WPRCL_WPRC_UPRN_DISPLAY',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257210820016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 5,
  p_query_column_name=> 'WPRCL_SEQ_DISPLAY',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257312594016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 6,
  p_query_column_name=> 'WPRCL_DOC_ID',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257408573016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 7,
  p_query_column_name=> 'DOC_DATE_ISSUED',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257529256016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 8,
  p_query_column_name=> 'DOC_REFERENCE_CODE',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257632604016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 9,
  p_query_column_name=> 'DOC_DESCR',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257712192016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 10,
  p_query_column_name=> 'HUS_NAME',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
wwv_flow_api.create_region_rpt_cols (
  p_id     => 1257806496016156 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_plug_id=> 17638111032717027 + wwv_flow_api.g_id_offset,
  p_column_sequence=> 11,
  p_query_column_name=> 'WPRCL_REGISTRY_FILE',
  p_display_as=> 'TEXT',
  p_column_comment=> '');
 
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
  p_last_upd_yyyymmddhh24miss => '20100223115116',
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
'where dhi_doc_id = :p2_doc_id'||chr(10)||
'and   DHI_STATUS_CODE = HSC_STATUS_CODE(+)'||chr(10)||
'and   HSC_DOMAIN_CODE(+) = ''COMPLAINTS'''||chr(10)||
'order by 2';

wwv_flow_api.create_report_region (
  p_id=> 10416723003503351 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 2,
  p_name=> 'Front Sheet Details (UPRN: &P0_PROPERTY_REF_PARAMETER.  -  Incident ID &P2_DOC_ID.)',
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
 
wwv_flow_api.create_page_button(
  p_id             => 1284522666021109 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 2,
  p_button_sequence=> 10,
  p_button_plug_id => 10416723003503351+wwv_flow_api.g_id_offset,
  p_button_name    => 'PRINT',
  p_button_image   => 'template:'||to_char(63120550297599611+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print',
  p_button_position=> 'TOP',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:2:&SESSION.:PRINT_REPORT=Front%20Page:&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
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
  p_id=>1279214243460420 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_DOC_ID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Doc Id',
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
  p_id=>1310611124026118 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_TARGET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Target Date&nbsp;&nbsp;',
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
  p_id=>1313932304554217 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_REG_FILE_REF',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Registry File Ref&nbsp;&nbsp;',
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
  p_id=>12242939798909138 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 2,
  p_name=>'P2_LPA',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
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
  p_item_sequence=> 2,
  p_item_plug_id => 12242628716905911+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'LA Ref&nbsp;&nbsp;',
  p_source=>'P1_LA_REF',
  p_source_type=> 'ITEM',
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
  p_item_sequence=> 3,
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
  p_item_sequence=> 4,
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
  p_item_sequence=> 6,
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
  p_item_sequence=> 8,
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
  p_item_sequence=> 9,
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
  p_item_sequence=> 10,
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
  p_item_sequence=> 11,
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
'select administrative_area,'||chr(10)||
'       ''CZ-701-''||:p2_doc_id,'||chr(10)||
'       doc_date_issued,'||chr(10)||
'       hus_name,'||chr(10)||
'       x_coordinate,'||chr(10)||
'       y_coordinate,'||chr(10)||
'       location,'||chr(10)||
'       doc_descr,'||chr(10)||
'       doc_compl_target'||chr(10)||
'into'||chr(10)||
':P2_LPA,'||chr(10)||
':P2_FILE_REF,'||chr(10)||
':P2_DATE,'||chr(10)||
':P2_APPLICANT,'||chr(10)||
':P2_OSGR_X,'||chr(10)||
':P2_OSGR_Y,'||chr(10)||
':P2_LOCATION,'||chr(10)||
':P2_PROPOSAL,'||chr(10)||
':P2_TARGET'||chr(10)||
'from (select * from nlpg_properties_v order by logical_status),'||chr(10)||
'     docs,'||chr(10)||
'   ';

p:=p||'  hig_users'||chr(10)||
'where uprn = :p0_property_ref_parameter'||chr(10)||
'and   doc_id = :p2_doc_id'||chr(10)||
'and   doc_compl_user_id = hus_user_id'||chr(10)||
'and rownum = 1;'||chr(10)||
''||chr(10)||
'select wprcl_registry_file'||chr(10)||
'into :p2_reg_file_ref '||chr(10)||
'from (select * from WAG_PLAN_RECORD_CARD_LINES order by wprcl_seq)'||chr(10)||
'where wprcl_doc_id = :p2_doc_id'||chr(10)||
'and wprcl_wprc_uprn = :p0_property_ref_parameter '||chr(10)||
'and rownum = 1;'||chr(10)||
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
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
':p2_doc_id := :P0_doc_id_parameter;'||chr(10)||
''||chr(10)||
'select dec_ref'||chr(10)||
'into :p2_la_ref'||chr(10)||
'from doc_enquiry_contacts'||chr(10)||
'where dec_doc_id = :p2_doc_id'||chr(10)||
'and rownum = 1;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 1279329827464923 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 2,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'set_p2_doc_id',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'Y',
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
  p_last_upd_yyyymmddhh24miss => '20090623125259',
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
  p_plug_header=> '<div style="width:1000px;overflow:auto">',
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
ph:=ph||'<script language="JavaScript" src="http://195.188.241.201/mapviewer/fsmc/jslib/oraclemaps.js"></script>'||chr(10)||
'<script language="Javascript" src="/exor/wagplan_24_new.js"></script>';

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
  p_last_updated_by => 'ITURNBULL',
  p_last_upd_yyyymmddhh24miss => '20100618122530',
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

c2:=c2||'<div class="t13NewBottom"><div id="t13User">&USER.</div>'||chr(10)||
'<div class="t13NewBottom1"><a href="http://www.exorcorp.com">www.exorcorp.com</a></div>'||chr(10)||
'<div class="t13NewBottom1">&FRAMEWORK_VERSION.</div>'||chr(10)||
'<div class="t13NewBottom1">Page: &FLOW_STEP_ID.</div>'||chr(10)||
'<div class="t13NewBottom1">&BROWSER_LANGUAGE.</div>'||chr(10)||
'<div class="t13NewBottom2">&MSG_COPYRIGHT.</div>'||chr(10)||
'<br style="clear:both;"/>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITI';

c2:=c2||'ON_05#'||chr(10)||
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
--application/shared_components/reports/report_queries/front_page
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select * from wag_plan_record_card'||chr(10)||
'where wprc_uprn = :P1_WPRC_UPRN';

wwv_flow_api.create_shared_query(
  p_id => 1265307197124296 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_name=>'Front Page',
  p_query_text => p1,
  p_xml_structure =>'APEX',
  p_report_layout_id =>1319710737138107 + wwv_flow_api.g_id_offset,
  p_format =>'PDF',
  p_format_item =>'',
  p_output_file_name =>'Front Page',
  p_content_disposition =>'ATTACHMENT',
  p_document_header =>'',
  p_xml_items =>'P2_DOC_ID');
end;
/
 
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select administrative_area planning_authority,'||chr(10)||
'       ''CZ-701-''||:p2_doc_id ref_number,'||chr(10)||
'       enq.doc_date_issued issue_date,'||chr(10)||
'       hus_name applicant,'||chr(10)||
'       x_coordinate,'||chr(10)||
'       y_coordinate,'||chr(10)||
'       location,'||chr(10)||
'       enq.doc_descr proposal,'||chr(10)||
'       enq.doc_compl_target target_date,'||chr(10)||
'       dec_ref auth_ref'||chr(10)||
'from (select * from nlpg_properties_v order by logical_status),'||chr(10)||
'     docs enq,'||chr(10)||
'     hig_use';

p1:=p1||'rs,'||chr(10)||
'     doc_enquiry_contacts'||chr(10)||
'where uprn = :p0_property_ref_parameter'||chr(10)||
'and   enq.doc_id = :p2_doc_id'||chr(10)||
'and   enq.doc_compl_user_id = hus_user_id'||chr(10)||
'and   enq.doc_id = dec_doc_id'||chr(10)||
'and rownum = 1';

wwv_flow_api.create_shared_query_stmnt(
  p_id => 1319926229139101 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_shared_query_id => 1265307197124296 + wwv_flow_api.g_id_offset,
  p_sql_statement => p1);
end;
/
 
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select doc_file, doc_reference_code, doc_title'||chr(10)||
'from   docs,'||chr(10)||
'       doc_assocs,'||chr(10)||
'       doc_locations'||chr(10)||
'where  das_rec_id = :p2_doc_id'||chr(10)||
'and    das_doc_id = doc_id'||chr(10)||
'and    doc_dlc_id = dlc_id;';

wwv_flow_api.create_shared_query_stmnt(
  p_id => 1320108581139101 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_shared_query_id => 1265307197124296 + wwv_flow_api.g_id_offset,
  p_sql_statement => p1);
end;
/
--application/shared_components/reports/report_queries/report_card
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select * from wag_plan_record_card'||chr(10)||
'where wprc_uprn = :P0_WPRC_UPRN';

wwv_flow_api.create_shared_query(
  p_id => 1283708589950820 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_name=>'Report Card',
  p_query_text => p1,
  p_xml_structure =>'APEX',
  p_report_layout_id =>1325207339400801 + wwv_flow_api.g_id_offset,
  p_format =>'PDF',
  p_format_item =>'',
  p_output_file_name =>'Report Card',
  p_content_disposition =>'ATTACHMENT',
  p_document_header =>'',
  p_xml_items =>'P0_PROPERTY_REF_PARAMETER');
end;
/
 
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select '||chr(10)||
'"WPRCL_WPRC_UPRN",'||chr(10)||
'"WPRCL_SEQ",'||chr(10)||
'chr(wprcl_seq+64) char_seq,'||chr(10)||
'"WPRCL_WPRC_UPRN" WPRCL_WPRC_UPRN_DISPLAY,'||chr(10)||
'"WPRCL_SEQ" WPRCL_SEQ_DISPLAY,'||chr(10)||
'"WPRCL_DOC_ID",'||chr(10)||
'DOC_DATE_ISSUED,'||chr(10)||
'DOC_REFERENCE_CODE,'||chr(10)||
'DOC_DESCR,'||chr(10)||
'HUS_NAME,'||chr(10)||
'nvl ("WPRCL_REGISTRY_FILE", '' '') WPRCL_REGISTRY_FILE'||chr(10)||
'from DOCS,'||chr(10)||
'     wag_plan_record_card_lines,'||chr(10)||
'     hig_users'||chr(10)||
'where doc_id = wprcl_doc_id'||chr(10)||
'and   doc_compl_user_id = hus_user_id'||chr(10)||
'and   ';

p1:=p1||'wprcl_wprc_uprn = :p0_property_ref_parameter'||chr(10)||
'order by wprcl_seq';

wwv_flow_api.create_shared_query_stmnt(
  p_id => 1325419545405065 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_shared_query_id => 1283708589950820 + wwv_flow_api.g_id_offset,
  p_sql_statement => p1);
end;
/
 
declare
    p1 varchar2(32767) := null;
begin
p1:=p1||'select *'||chr(10)||
'from wag_plan_record_card'||chr(10)||
'where wprc_uprn = :p0_property_ref_parameter';

wwv_flow_api.create_shared_query_stmnt(
  p_id => 1325630834405065 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_shared_query_id => 1283708589950820 + wwv_flow_api.g_id_offset,
  p_sql_statement => p1);
end;
/
prompt  ...report layouts
--
 
begin
 
    wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
    wwv_flow_api.g_varchar2_table(1) := '{\rtf1\adeflang1025\ansi\ansicpg1252\uc1\adeff0\deff0\stshfdbch0\stshfloch37\stshfhich37\stshfbi37\d';
    wwv_flow_api.g_varchar2_table(2) := 'eflang1033\deflangfe1033{\fonttbl{\f0\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times Ne';
    wwv_flow_api.g_varchar2_table(3) := 'w Roman;}{\f37\fswiss\fcharset0\fprq2{\*\panose 020f0502020204030204}Calibri;}{\f43\froman\fcharset2';
    wwv_flow_api.g_varchar2_table(4) := '38\fprq2 Times New Roman CE;}'||chr(10)||
'{\f44\froman\fcharset204\fprq2 Times New Roman Cyr;}{\f46\froman\fchar';
    wwv_flow_api.g_varchar2_table(5) := 'set161\fprq2 Times New Roman Greek;}{\f47\froman\fcharset162\fprq2 Times New Roman Tur;}{\f48\fbidi ';
    wwv_flow_api.g_varchar2_table(6) := '\froman\fcharset177\fprq2 Times New Roman (Hebrew);}'||chr(10)||
'{\f49\fbidi \froman\fcharset178\fprq2 Times New';
    wwv_flow_api.g_varchar2_table(7) := ' Roman (Arabic);}{\f50\froman\fcharset186\fprq2 Times New Roman Baltic;}{\f51\froman\fcharset163\fpr';
    wwv_flow_api.g_varchar2_table(8) := 'q2 Times New Roman (Vietnamese);}{\f413\fswiss\fcharset238\fprq2 Calibri CE;}'||chr(10)||
'{\f414\fswiss\fcharset';
    wwv_flow_api.g_varchar2_table(9) := '204\fprq2 Calibri Cyr;}{\f416\fswiss\fcharset161\fprq2 Calibri Greek;}{\f417\fswiss\fcharset162\fprq';
    wwv_flow_api.g_varchar2_table(10) := '2 Calibri Tur;}{\f420\fswiss\fcharset186\fprq2 Calibri Baltic;}}{\colortbl;\red0\green0\blue0;\red0\';
    wwv_flow_api.g_varchar2_table(11) := 'green0\blue255;'||chr(10)||
'\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue255;\red255\green0\bl';
    wwv_flow_api.g_varchar2_table(12) := 'ue0;\red255\green255\blue0;\red255\green255\blue255;\red0\green0\blue128;\red0\green128\blue128;\red';
    wwv_flow_api.g_varchar2_table(13) := '0\green128\blue0;\red128\green0\blue128;\red128\green0\blue0;'||chr(10)||
'\red128\green128\blue0;\red128\green12';
    wwv_flow_api.g_varchar2_table(14) := '8\blue128;\red192\green192\blue192;\red231\green243\blue253;}{\stylesheet{\ql \li0\ri0\sa200\widctlp';
    wwv_flow_api.g_varchar2_table(15) := 'ar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af0\afs22\alang1025 \';
    wwv_flow_api.g_varchar2_table(16) := 'ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \snext0 \styrsid1248866 Norm';
    wwv_flow_api.g_varchar2_table(17) := 'al;}{\*\cs10 \additive \ssemihidden Default Paragraph Font;}{\*'||chr(10)||
'\ts11\tsrowd\trftsWidthB3\trpaddl108';
    wwv_flow_api.g_varchar2_table(18) := '\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tscellwidthfts0\tsvertalt\ts';
    wwv_flow_api.g_varchar2_table(19) := 'brdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv '||chr(10)||
'\ql \li0\ri0\widctlpar\wrapdefaul';
    wwv_flow_api.g_varchar2_table(20) := 't\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af37\afs20 \ltrch\fcs0 \f37\fs20\l';
    wwv_flow_api.g_varchar2_table(21) := 'ang1024\langfe1024\cgrid\langnp1024\langfenp1024 \snext11 \ssemihidden Normal Table;}{\*\ts15\tsrowd';
    wwv_flow_api.g_varchar2_table(22) := '\trbrdrt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrd';
    wwv_flow_api.g_varchar2_table(23) := 'rr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidthB';
    wwv_flow_api.g_varchar2_table(24) := '3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tscellwidthfts0\';
    wwv_flow_api.g_varchar2_table(25) := 'tsvertalt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv '||chr(10)||
'\ql \li0\ri0\widctlpa';
    wwv_flow_api.g_varchar2_table(26) := 'r\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af0\afs22\alang1025 \l';
    wwv_flow_api.g_varchar2_table(27) := 'trch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \sbasedon11 \snext15 \styrsid1';
    wwv_flow_api.g_varchar2_table(28) := '6665483 Table Grid;}}'||chr(10)||
'{\*\latentstyles\lsdstimax156\lsdlockeddef0{\lsdlockedexcept Normal;heading 1;';
    wwv_flow_api.g_varchar2_table(29) := 'heading 2;heading 3;heading 4;heading 5;heading 6;heading 7;heading 8;heading 9;toc 1;toc 2;toc 3;to';
    wwv_flow_api.g_varchar2_table(30) := 'c 4;toc 5;toc 6;toc 7;toc 8;toc 9;caption;Title;Default Paragraph Font;Subtitle;Strong;Emphasis;Tabl';
    wwv_flow_api.g_varchar2_table(31) := 'e Grid;}}'||chr(10)||
'{\*\rsidtbl \rsid919359\rsid1248866\rsid1512796\rsid2576807\rsid2903609\rsid3560942\rsid38';
    wwv_flow_api.g_varchar2_table(32) := '09611\rsid4022835\rsid4331195\rsid4933644\rsid5131112\rsid6291715\rsid7225007\rsid7427681\rsid800150';
    wwv_flow_api.g_varchar2_table(33) := '2\rsid8482629\rsid9640468\rsid10617749\rsid14319519\rsid15601039'||chr(10)||
'\rsid15625051\rsid15664419\rsid1666';
    wwv_flow_api.g_varchar2_table(34) := '5483}{\*\generator Microsoft Word 11.0.0000;}{\info{\author  Ian Turnbull}{\operator SMarshall}{\cre';
    wwv_flow_api.g_varchar2_table(35) := 'atim\yr2009\mo6\dy23\hr11\min11}{\revtim\yr2009\mo7\dy7\hr11\min20}{\version9}{\edmins79}{\nofpages1';
    wwv_flow_api.g_varchar2_table(36) := '}{\nofwords142}'||chr(10)||
'{\nofchars815}{\*\company  }{\nofcharsws956}{\vern24611}{\*\password 00000000}}{\*\x';
    wwv_flow_api.g_varchar2_table(37) := 'mlnstbl {\xmlns1 http://schemas.microsoft.com/office/word/2003/wordml}}\paperw12240\paperh15840\marg';
    wwv_flow_api.g_varchar2_table(38) := 'l1440\margr1440\margt1440\margb1440\gutter0\ltrsect '||chr(10)||
'\widowctrl\ftnbj\aenddoc\donotembedsysfont1\don';
    wwv_flow_api.g_varchar2_table(39) := 'otembedlingdata0\grfdocevents0\validatexml1\showplaceholdtext0\ignoremixedcontent0\saveinvalidxml0\s';
    wwv_flow_api.g_varchar2_table(40) := 'howxmlerrors1\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospaceforul\formshade\horzdoc\dgmargin\dgh';
    wwv_flow_api.g_varchar2_table(41) := 'space180'||chr(10)||
'\dgvspace180\dghorigin1440\dgvorigin1440\dghshow1\dgvshow1'||chr(10)||
'\jexpand\viewkind1\viewscale150\';
    wwv_flow_api.g_varchar2_table(42) := 'pgbrdrhead\pgbrdrfoot\splytwnine\ftnlytwnine\htmautsp\nolnhtadjtbl\useltbaln\alntblind\lytcalctblwd\';
    wwv_flow_api.g_varchar2_table(43) := 'lyttblrtgr\lnbrkrule\nobrkwrptbl\snaptogridincell\allowfieldendsel\wrppunct'||chr(10)||
'\asianbrkrule\rsidroot16';
    wwv_flow_api.g_varchar2_table(44) := '665483\newtblstyruls\nogrowautofit \fet0{\*\wgrffmtfilter 2450}\ilfomacatclnup0\ltrpar \sectd \ltrse';
    wwv_flow_api.g_varchar2_table(45) := 'ct\linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sft';
    wwv_flow_api.g_varchar2_table(46) := 'nbj {\*\pnseclvl1'||chr(10)||
'\pnucrm\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl2\pnucltr\pnstart1\pni';
    wwv_flow_api.g_varchar2_table(47) := 'ndent720\pnhang {\pntxta .}}{\*\pnseclvl3\pndec\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl';
    wwv_flow_api.g_varchar2_table(48) := '4\pnlcltr\pnstart1\pnindent720\pnhang {\pntxta )}}{\*\pnseclvl5'||chr(10)||
'\pndec\pnstart1\pnindent720\pnhang {';
    wwv_flow_api.g_varchar2_table(49) := '\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\p';
    wwv_flow_api.g_varchar2_table(50) := 'nseclvl7\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnstart1\pn';
    wwv_flow_api.g_varchar2_table(51) := 'indent720\pnhang '||chr(10)||
'{\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (';
    wwv_flow_api.g_varchar2_table(52) := '}{\pntxta )}}\pard\plain \ltrpar\qc \li0\ri0\sa200\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adju';
    wwv_flow_api.g_varchar2_table(53) := 'stright\rin0\lin0\itap0\pararsid6291715 \rtlch\fcs1 \af0\afs22\alang1025 '||chr(10)||
'\ltrch\fcs0 \f37\fs22\lang';
    wwv_flow_api.g_varchar2_table(54) := '1033\langfe1033\cgrid\langnp1033\langfenp1033 {\field\fldedit\fldlock{\*\fldinst {\rtlch\fcs1 \af0\a';
    wwv_flow_api.g_varchar2_table(55) := 'fs28 \ltrch\fcs0 \fs28\cf8\lang2057\langfe1033\langnp2057\insrsid4022835\charrsid4022835  SHAPE  \\*';
    wwv_flow_api.g_varchar2_table(56) := ' MERGEFORMAT }}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0\afs28 \ltrch\fcs0 \fs28\cf8\lang1024\langfe1024\noproof\';
    wwv_flow_api.g_varchar2_table(57) := 'insrsid4022835\charrsid4022835 '||chr(10)||
'{\shpgrp{\*\shpinst\shpleft0\shptop0\shpright9360\shpbottom720\shpfh';
    wwv_flow_api.g_varchar2_table(58) := 'dr0\shpbxcolumn\shpbxignore\shpbypara\shpbyignore\shpwr3\shpwrk0\shpfblwtxt0\shpz0\shplockanchor\shp';
    wwv_flow_api.g_varchar2_table(59) := 'lid1030'||chr(10)||
'{\sp{\sn groupLeft}{\sv 1448}}{\sp{\sn groupTop}{\sv 1448}}{\sp{\sn groupRight}{\sv 10808}}{';
    wwv_flow_api.g_varchar2_table(60) := '\sp{\sn groupBottom}{\sv 2168}}{\sp{\sn fFlipH}{\sv 0}}{\sp{\sn fFlipV}{\sv 0}}{\sp{\sn fLockRotatio';
    wwv_flow_api.g_varchar2_table(61) := 'n}{\sv 0}}{\sp{\sn fLockAspectRatio}{\sv 1}}'||chr(10)||
'{\sp{\sn fLockPosition}{\sv 0}}{\sp{\sn posh}{\sv 0}}{\';
    wwv_flow_api.g_varchar2_table(62) := 'sp{\sn posrelh}{\sv 3}}{\sp{\sn posv}{\sv 0}}{\sp{\sn posrelv}{\sv 3}}{\sp{\sn fAllowOverlap}{\sv 1}';
    wwv_flow_api.g_varchar2_table(63) := '}{\sp{\sn fBehindDocument}{\sv 0}}{\sp{\sn dgmt}{\sv 0}}{\sp{\sn fPseudoInline}{\sv 1}}'||chr(10)||
'{\sp{\sn fLa';
    wwv_flow_api.g_varchar2_table(64) := 'youtInCell}{\sv 1}}{\sp{\sn fLockPosition}{\sv 1}}{\sp{\sn fLockRotation}{\sv 1}}{\shp{\*\shpinst\sh';
    wwv_flow_api.g_varchar2_table(65) := 'plid1029{\sp{\sn relLeft}{\sv 1448}}{\sp{\sn relTop}{\sv 1448}}{\sp{\sn relRight}{\sv 10808}}'||chr(10)||
'{\sp{\';
    wwv_flow_api.g_varchar2_table(66) := 'sn relBottom}{\sv 2168}}{\sp{\sn fRelFlipH}{\sv 0}}{\sp{\sn fRelFlipV}{\sv 0}}{\sp{\sn shapeType}{\s';
    wwv_flow_api.g_varchar2_table(67) := 'v 75}}{\sp{\sn fLockText}{\sv 1}}{\sp{\sn cxk}{\sv 0}}{\sp{\sn fShadowOK}{\sv 1}}{\sp{\sn f3DOK}{\sv';
    wwv_flow_api.g_varchar2_table(68) := ' 1}}{\sp{\sn fLineOK}{\sv 1}}'||chr(10)||
'{\sp{\sn fFillOK}{\sv 1}}{\sp{\sn fFilled}{\sv 0}}{\sp{\sn fNoFillHitT';
    wwv_flow_api.g_varchar2_table(69) := 'est}{\sv 1}}{\sp{\sn fLine}{\sv 0}}{\sp{\sn fPreferRelativeResize}{\sv 0}}{\sp{\sn fLayoutInCell}{\s';
    wwv_flow_api.g_varchar2_table(70) := 'v 1}}}}'||chr(10)||
'{\shp{\*\shpinst\shplid1031{\sp{\sn relLeft}{\sv 1448}}{\sp{\sn relTop}{\sv 1448}}{\sp{\sn r';
    wwv_flow_api.g_varchar2_table(71) := 'elRight}{\sv 10808}}{\sp{\sn relBottom}{\sv 2168}}{\sp{\sn fRelFlipH}{\sv 0}}{\sp{\sn fRelFlipV}{\sv';
    wwv_flow_api.g_varchar2_table(72) := ' 0}}{\sp{\sn shapeType}{\sv 1}}{\sp{\sn fillColor}{\sv 0}}'||chr(10)||
'{\sp{\sn fFilled}{\sv 1}}{\sp{\sn fLayout';
    wwv_flow_api.g_varchar2_table(73) := 'InCell}{\sv 1}}}}{\shp{\*\shpinst\shplid1032{\sp{\sn relLeft}{\sv 2348}}{\sp{\sn relTop}{\sv 1628}}{';
    wwv_flow_api.g_varchar2_table(74) := '\sp{\sn relRight}{\sv 4523}}{\sp{\sn relBottom}{\sv 1988}}{\sp{\sn fRelFlipH}{\sv 0}}'||chr(10)||
'{\sp{\sn fRelF';
    wwv_flow_api.g_varchar2_table(75) := 'lipV}{\sv 0}}{\sp{\sn shapeType}{\sv 136}}{\sp{\sn gtextUNICODE}{\sv Records Service}}{\sp{\sn gtext';
    wwv_flow_api.g_varchar2_table(76) := 'Size}{\sv 786432}}{\sp{\sn gtextFont}{\sv Arial Black}}{\sp{\sn gtextFReverseRows}{\sv 0}}{\sp{\sn f';
    wwv_flow_api.g_varchar2_table(77) := 'Gtext}{\sv 1}}'||chr(10)||
'{\sp{\sn gtextFVertical}{\sv 0}}{\sp{\sn gtextFKern}{\sv 1}}{\sp{\sn gtextFTight}{\sv';
    wwv_flow_api.g_varchar2_table(78) := ' 0}}{\sp{\sn gtextFStretch}{\sv 1}}{\sp{\sn gtextFShrinkFit}{\sv 1}}{\sp{\sn gtextFBestFit}{\sv 1}}{';
    wwv_flow_api.g_varchar2_table(79) := '\sp{\sn gtextFNormalize}{\sv 0}}{\sp{\sn gtextFDxMeasure}{\sv 0}}'||chr(10)||
'{\sp{\sn gtextFBold}{\sv 0}}{\sp{\';
    wwv_flow_api.g_varchar2_table(80) := 'sn gtextFItalic}{\sv 0}}{\sp{\sn gtextFUnderline}{\sv 0}}{\sp{\sn gtextFShadow}{\sv 0}}{\sp{\sn gtex';
    wwv_flow_api.g_varchar2_table(81) := 'tFSmallcaps}{\sv 0}}{\sp{\sn gtextFStrikethrough}{\sv 0}}'||chr(10)||
'{\sp{\sn adjustValue}{\sv 10706}}{\sp{\sn ';
    wwv_flow_api.g_varchar2_table(82) := 'fFilled}{\sv 1}}{\sp{\sn fLine}{\sv 1}}{\sp{\sn shadowColor}{\sv 8816262}}{\sp{\sn fShadow}{\sv 0}}{';
    wwv_flow_api.g_varchar2_table(83) := '\sp{\sn fshadowObscured}{\sv 0}}{\sp{\sn fPerspective}{\sv 0}}{\sp{\sn f3D}{\sv 0}}{\sp{\sn fc3DMeta';
    wwv_flow_api.g_varchar2_table(84) := 'llic}{\sv 0}}'||chr(10)||
'{\sp{\sn fc3DUseExtrusionColor}{\sv 0}}{\sp{\sn fc3DLightFace}{\sv 1}}{\sp{\sn fc3DCon';
    wwv_flow_api.g_varchar2_table(85) := 'strainRotation}{\sv 1}}{\sp{\sn fc3DRotationCenterAuto}{\sv 0}}{\sp{\sn fc3DParallel}{\sv 1}}{\sp{\s';
    wwv_flow_api.g_varchar2_table(86) := 'n fc3DKeyHarsh}{\sv 1}}{\sp{\sn fc3DFillHarsh}{\sv 0}}'||chr(10)||
'{\sp{\sn fLayoutInCell}{\sv 1}}}}}{\shprslt{\';
    wwv_flow_api.g_varchar2_table(87) := '*\do\dobxcolumn\dobypara\dodhgt8192\dpgroup\dpcount4\dpx0\dpy0\dpxsize9360\dpysize720\dppolygon\dppo';
    wwv_flow_api.g_varchar2_table(88) := 'lycount4\dpptx0\dppty0\dpptx0\dppty720\dpptx9360\dppty720\dpptx9360\dppty0\dpx0\dpy0\dpxsize9360\dpy';
    wwv_flow_api.g_varchar2_table(89) := 'size720'||chr(10)||
'\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255\dpfillbgcr255\dpfillbgcg255\dpfillbgcb255\dpfillp';
    wwv_flow_api.g_varchar2_table(90) := 'at0\dplinehollow\dprect\dpx0\dpy0\dpxsize9360\dpysize720'||chr(10)||
'\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255\';
    wwv_flow_api.g_varchar2_table(91) := 'dpfillbgcr0\dpfillbgcg0\dpfillbgcb0\dpfillpat1\dplinew15\dplinecor0\dplinecog0\dplinecob0\dprect\dpx';
    wwv_flow_api.g_varchar2_table(92) := '900\dpy180\dpxsize2175\dpysize360'||chr(10)||
'\dpfillfgcr255\dpfillfgcg255\dpfillfgcb255\dpfillbgcr255\dpfillbgc';
    wwv_flow_api.g_varchar2_table(93) := 'g255\dpfillbgcb255\dpfillpat0\dplinehollow\dpendgroup\dpx0\dpy0\dpxsize0\dpysize0}\par\pard\ql \li0\';
    wwv_flow_api.g_varchar2_table(94) := 'ri0\widctlpar\brdrt\brdrs\brdrw15\brdrcf1 \brdrl\brdrs\brdrw15\brdrcf1 \brdrb'||chr(10)||
'\brdrs\brdrw15\brdrcf1';
    wwv_flow_api.g_varchar2_table(95) := ' \brdrr\brdrs\brdrw15\brdrcf1 \pvpg\abslock1\dxfrtext180\dfrmtxtx180\dfrmtxty0\wraparound\aspalpha\a';
    wwv_flow_api.g_varchar2_table(96) := 'spnum\faauto\adjustright\rin0\lin0\itap0 {\pict\picscalex100\picscaley100\piccropl0\piccropr0\piccro';
    wwv_flow_api.g_varchar2_table(97) := 'pt0\piccropb0'||chr(10)||
'\picw16540\pich1300\picwgoal9377\pichgoal737\wmetafile8\bliptag2044047665\blipupi133{\';
    wwv_flow_api.g_varchar2_table(98) := '*\blipuid 79d5b131b02c73ecda9595666c761516}'||chr(10)||
'010009000003372b000008001610000000001610000026060f002220';
    wwv_flow_api.g_varchar2_table(99) := '574d4643010000000000010061bf000000000200000000200000041b0000043b00000100'||chr(10)||
'00006c000000e1ffffffe1fffff';
    wwv_flow_api.g_varchar2_table(100) := 'f600f0000500100000000000000000000b24000002a05000020454d4600000100043b0000930100000400000000000000000';
    wwv_flow_api.g_varchar2_table(101) := '0'||chr(10)||
'000000000000971200009e1a0000c900000020010000000000000000000000000000f8120300cb660400160000000c0000';
    wwv_flow_api.g_varchar2_table(102) := '00180000000a000000100000000000'||chr(10)||
'0000000000000900000010000000430f000033010000250000000c0000000e0000801';
    wwv_flow_api.g_varchar2_table(103) := '20000000c000000010000005200000070010000010000009cffffff0000'||chr(10)||
'0000000000000000000090010000000000000440';
    wwv_flow_api.g_varchar2_table(104) := '0012540069006d006500730020004e0065007700200052006f006d0061006e00000000000000000000000000'||chr(10)||
'00000000000';
    wwv_flow_api.g_varchar2_table(105) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(106) := '00000000000000000'||chr(10)||
'0000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(107) := '0000000000000000000000000000000000000000000000'||chr(10)||
'00000000000000000000cb30093000000000040000000000ae300';
    wwv_flow_api.g_varchar2_table(108) := '83109300000000047169001000002020603050405020304877a002000000080080000000000'||chr(10)||
'0000ff010000000000005400';
    wwv_flow_api.g_varchar2_table(109) := '69006d00650073002000000065007700200052006f006d0061006e00000000000000bd2d093050bbae300033140001000000';
    wwv_flow_api.g_varchar2_table(110) := '0000'||chr(10)||
'00003c441100aab402303c4411004c3eaf30544411006476000800000000250000000c00000001000000180000000c0';
    wwv_flow_api.g_varchar2_table(111) := '000000000000254000000540000000000'||chr(10)||
'0000000000002c00000071000000010000008a2787403f408740000000005a0000';
    wwv_flow_api.g_varchar2_table(112) := '00010000004c000000040000000000000000000000490f0000390100005000'||chr(10)||
'0000200000002d00000046000000280000001';
    wwv_flow_api.g_varchar2_table(113) := 'c000000474449430200000003000000030000003f0f00002f0100000000000046000000280000001c0000004744'||chr(10)||
'49430200';
    wwv_flow_api.g_varchar2_table(114) := '00000200000002000000400f0000300100000000000046000000140000000800000047444943030000004600000028000000';
    wwv_flow_api.g_varchar2_table(115) := '1c000000474449430200'||chr(10)||
'00000000000000000000430f000033010000000000002100000008000000620000000c000000010';
    wwv_flow_api.g_varchar2_table(116) := '0000024000000240000000000003e00000000000000000000'||chr(10)||
'003e0000000000000000020000002700000018000000020000';
    wwv_flow_api.g_varchar2_table(117) := '00000000000000000000000000250000000c00000002000000250000000c000000080000805600'||chr(10)||
'000030000000020000000';
    wwv_flow_api.g_varchar2_table(118) := '20000003f0f00002f010000050000001700170017007709f7797709f779170017001700250000000c0000000700008025000';
    wwv_flow_api.g_varchar2_table(119) := '0000c00'||chr(10)||
'0000000000802400000024000000000000410000000000000000000000410000000000000000020000003a000000';
    wwv_flow_api.g_varchar2_table(120) := '0c0000000800000024000000240000000000'||chr(10)||
'003e00000000000000000000003e0000000000000000020000005f000000380';
    wwv_flow_api.g_varchar2_table(121) := '00000030000003800000000000000380000000000000000200100320000000000'||chr(10)||
'0000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(122) := '00250000000c00000003000000250000000c00000005000080560000002c000000e1ffffffe1ffffff600f00005001'||chr(10)||
'00000';
    wwv_flow_api.g_varchar2_table(123) := '40000001700170017007709f7797709f7791700250000000c00000007000080250000000c000000000000802400000024000';
    wwv_flow_api.g_varchar2_table(124) := '00000000041000000000000'||chr(10)||
'000000000041000000000000000002000000280000000c000000030000003a0000000c000000';
    wwv_flow_api.g_varchar2_table(125) := '0a000000220000000c000000ffffffff46000000140000000800'||chr(10)||
'0000474449430300000046000000280000001c000000474';
    wwv_flow_api.g_varchar2_table(126) := '4494302000000740100004b00000005050000e800000000000000280000000c000000020000002100'||chr(10)||
'000008000000620000';
    wwv_flow_api.g_varchar2_table(127) := '000c0000000100000024000000240000000000803d00000000000000000000803d0000000000000000020000002700000018';
    wwv_flow_api.g_varchar2_table(128) := '0000000200'||chr(10)||
'000000000000ffffff0000000000250000000c00000002000000130000000c000000010000003b00000008000';
    wwv_flow_api.g_varchar2_table(129) := '0001b00000010000000a0170000150e00005800'||chr(10)||
'0000000100000000000000000000ffffffffffffffff39000000c917100b';
    wwv_flow_api.g_varchar2_table(130) := 'f1170a081a180505e0180505a71905056e1a0505dc1a0505301b1805681b3e05a01b'||chr(10)||
'6505cc1baa05ea1b1106071c7806131';
    wwv_flow_api.g_varchar2_table(131) := 'cf6060c1c8907051c0908f11b7808d11bd508b11b3309861b7e09541bb909331bde09071bfd09d11a150afa1a330a181b'||chr(10)||
'4f';
    wwv_flow_api.g_varchar2_table(132) := '0a2a1b6c0a361b7f0a471ba80a5d1be60a721b240b811b550b871b760bb41b560ce51b350d111c150e8b1b150e041b150e7d';
    wwv_flow_api.g_varchar2_table(133) := '1a150e4b1a280d161a3c0ce419'||chr(10)||
'500bd119f40abe19b80aad199d0a9519780a7819670a5819670a4d19670a4319670a38196';
    wwv_flow_api.g_varchar2_table(134) := '70a2819a10b1719db0c0719150e8f18150e1718150ea017150e3d00'||chr(10)||
'0000080000001b000000100000004f190000b1080000';
    wwv_flow_api.g_varchar2_table(135) := '580000007c0000000000000000000000ffffffffffffffff180000008219b108b419b108e619b108f719'||chr(10)||
'b108171aa608461';
    wwv_flow_api.g_varchar2_table(136) := 'a91085e1a8808741a7008851a4908951a21089f1af507a21ac207a61a78079c1a3d07871a1607721aee06471ada06051ada0';
    wwv_flow_api.g_varchar2_table(137) := '6d119da069c19'||chr(10)||
'da066819da0660197707581914084f19b1083d000000080000003c000000080000003e000000180000007a';
    wwv_flow_api.g_varchar2_table(138) := '01000050000000c2010000e2000000130000000c00'||chr(10)||
'000001000000250000000c00000000000080240000002400000000008';
    wwv_flow_api.g_varchar2_table(139) := '04100000000000000000000804100000000000000000200000024000000240000000000'||chr(10)||
'803d00000000000000000000803d';
    wwv_flow_api.g_varchar2_table(140) := '000000000000000002000000250000000c00000002000000130000000c000000010000003b000000080000001b0000001000';
    wwv_flow_api.g_varchar2_table(141) := ''||chr(10)||
'00000c2000006c0b000058000000e80000000000000000000000ffffffffffffffff33000000361f6c0b5f1e6c0b881d6c0';
    wwv_flow_api.g_varchar2_table(142) := 'b881dd30b931d210ca61d530cc11d'||chr(10)||
'9c0ce81dc10c1a1ec10c391ec10c591eb10c761e910c891e7c0c9e1e5a0cb41e270c1c';
    wwv_flow_api.g_varchar2_table(143) := '1f3b0c851f4e0ced1f620cb51f0b0d731f820d2b1fcc0de31e170e7f1e'||chr(10)||
'3b0eff1d3b0e901d3b0e3a1d1c0efe1cdc0dc21c9';
    wwv_flow_api.g_varchar2_table(144) := 'd0d921c3a0d701cb10c4e1c280c401c890b4a1cd00a581cc9098e1cf608ea1c5208451dae07be1d5e07521e'||chr(10)||
'5e07ca1e5e07';
    wwv_flow_api.g_varchar2_table(145) := '271f8207681fcc07a91f1508da1f7e08f61f0809132092091c20460a1020230b0f203c0b0e20540b0c206c0b3d0000000800';
    wwv_flow_api.g_varchar2_table(146) := '00001b0000001000'||chr(10)||
'0000d61e0000380a000058000000580000000000000000000000ffffffffffffffff0f000000d61ebb0';
    wwv_flow_api.g_varchar2_table(147) := '9ca1e6209b21e2c099a1ef608771edc084b1edc08181e'||chr(10)||
'dc08ed1d0509ca1d5509b51d8809a41dd4099a1d380a031e380a6c';
    wwv_flow_api.g_varchar2_table(148) := '1e380ad61e380a3d000000080000003c000000080000003e00000018000000c40100007500'||chr(10)||
'000002020000e400000013000';
    wwv_flow_api.g_varchar2_table(149) := '0000c00000001000000250000000c00000000000080240000002400000000008041000000000000000000008041000000000';
    wwv_flow_api.g_varchar2_table(150) := '000'||chr(10)||
'00000200000024000000240000000000803d00000000000000000000803d000000000000000002000000250000000c00';
    wwv_flow_api.g_varchar2_table(151) := '000002000000130000000c0000000100'||chr(10)||
'00003b0000000800000055000000340100000000000000000000fffffffffffffff';
    wwv_flow_api.g_varchar2_table(152) := 'f460000001023820b74239a0bd923b00b3d24c80b2624480c0424b50cd923'||chr(10)||
'130dae23700d7823b80d3b23ed0dfd22220eaf';
    wwv_flow_api.g_varchar2_table(153) := '223b0e53223b0efa213b0eb1212b0e78210a0e3e21e80d0d21b30de720680dc1201e0da320c70c9020630c7e20'||chr(10)||
'ff0b79207';
    wwv_flow_api.g_varchar2_table(154) := 'b0b8120d40a8a20280aa1209809c4202509dd20d10800218508282141085021fe077b21ce07a321ac07e421770736225e079';
    wwv_flow_api.g_varchar2_table(155) := '8225e0721235e078823'||chr(10)||
'8f07ca23f1070b2454083724e4084a24a009e423bb097d23d5091723f1091223a90903237209ec22';
    wwv_flow_api.g_varchar2_table(156) := '4e09d6222909b42218098a2218095622180928223e090422'||chr(10)||
'8a09df21d809c8214b0ac021e60ab821700bc421d80be0211f0';
    wwv_flow_api.g_varchar2_table(157) := 'cfc21670c25228b0c57228b0c81228b0ca622750cc5224a0ce3221f0cfd22dd0b1023820b3c00'||chr(10)||
'0000080000003e00000018';
    wwv_flow_api.g_varchar2_table(158) := '000000070200007500000045020000e4000000130000000c00000001000000250000000c0000000000008024000000240000';
    wwv_flow_api.g_varchar2_table(159) := '000000'||chr(10)||
'804100000000000000000000804100000000000000000200000024000000240000000000803d00000000000000000';
    wwv_flow_api.g_varchar2_table(160) := '000803d0000000000000000020000002500'||chr(10)||
'00000c00000002000000130000000c000000010000003b000000080000001b00';
    wwv_flow_api.g_varchar2_table(161) := '000010000000b6240000d10a0000580000007c0000000000000000000000ffff'||chr(10)||
'ffffffffffff18000000c424d109fb24fe0';
    wwv_flow_api.g_varchar2_table(162) := '859255708b625b00731265e07c3265e076c275e07e627c007312883086c2820098528e2097928c80a6c28ca0b3528'||chr(10)||
'9d0cd8';
    wwv_flow_api.g_varchar2_table(163) := '27420d7b27e90dff263b0e68263b0ee1253b0e7625f70d2c256d0dd124c30ca824e50bb624d10a3d000000080000001b0000';
    wwv_flow_api.g_varchar2_table(164) := '0010000000f8250000d00a'||chr(10)||
'0000580000007c0000000000000000000000ffffffffffffffff18000000f025660bfa25d40b1';
    wwv_flow_api.g_varchar2_table(165) := '4261c0c2e26630c5326870c8026870caf26870cd726650cf826'||chr(10)||
'1e0c1927d60b2e27660b3727c90a3e27380a3427cb091b27';
    wwv_flow_api.g_varchar2_table(166) := '840901273c09dd261a09b1261a0982261a0959263e09372685091526ce0900263c0af825d00a3d00'||chr(10)||
'0000080000003c00000';
    wwv_flow_api.g_varchar2_table(167) := '0080000003e000000180000004a0200007500000089020000e4000000130000000c00000001000000250000000c000000000';
    wwv_flow_api.g_varchar2_table(168) := '000802400'||chr(10)||
'000024000000000080410000000000000000000080410000000000000000020000002400000024000000000080';
    wwv_flow_api.g_varchar2_table(169) := '3d00000000000000000000803d000000000000'||chr(10)||
'000002000000250000000c00000002000000130000000c000000010000003';
    wwv_flow_api.g_varchar2_table(170) := 'b0000000800000055000000b00000000000000000000000ffffffffffffffff2500'||chr(10)||
'000043298407a72984070b2a8407702a';
    wwv_flow_api.g_varchar2_table(171) := '84076b2ae007662a3c08612a9808842a2108a72acf07c82aa107e92a7407102b5e073d2b5e076c2b5e07a02b7c07d42b'||chr(10)||
'b70';
    wwv_flow_api.g_varchar2_table(172) := '7ab2b5008812be908582b8209342b6209172b5209012b5209d72a5209b42a75099a2abb09742a1d0a592ad40a4b2ae10b412';
    wwv_flow_api.g_varchar2_table(173) := 'a9d0c372a590d2d2a150ec229'||chr(10)||
'150e5629150eeb28150e0829e50b2529b409432984073c000000080000003e000000180000';
    wwv_flow_api.g_varchar2_table(174) := '008e02000075000000be020000e2000000130000000c0000000100'||chr(10)||
'0000250000000c0000000000008024000000240000000';
    wwv_flow_api.g_varchar2_table(175) := '000804100000000000000000000804100000000000000000200000024000000240000000000803d0000'||chr(10)||
'0000000000000000';
    wwv_flow_api.g_varchar2_table(176) := '803d000000000000000002000000250000000c00000002000000130000000c000000010000003b000000080000001b000000';
    wwv_flow_api.g_varchar2_table(177) := '10000000c92f'||chr(10)||
'00000505000058000000b80000000000000000000000ffffffffffffffff27000000a02f0a08772f100b4f2';
    wwv_flow_api.g_varchar2_table(178) := 'f150eeb2e150e872e150e222e150e272ec20d2b2e'||chr(10)||
'6f0d2f2e1c0d012e870dd52dcd0db12df20d802d230e4b2d3b0e122d3b';
    wwv_flow_api.g_varchar2_table(179) := '0ea02c3b0e4d2ce40d1b2c360de92b870cd52bb40be22bbb0af02ba5091e2cd008682c'||chr(10)||
'3c08b02ca8070a2d5e07702d5e07a';
    wwv_flow_api.g_varchar2_table(180) := '22d5e07cf2d6f07f62d91071c2eb3073f2ee5075a2e2908682e1d07772e1106852e0505f12e05055d2f0505c92f05053d00'||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(181) := '0000080000001b000000100000003a2e0000c80a0000580000007c0000000000000000000000ffffffffffffffff18000000';
    wwv_flow_api.g_varchar2_table(182) := '402e440a372ee1091f2ea009082e'||chr(10)||
'5f09e52d3f09bb2d3f09952d3f09742d5f09582d9d093c2ddb09292d430a212dd60a1a2';
    wwv_flow_api.g_varchar2_table(183) := 'd600b232dc30b392d030c4f2d440c6e2d630c942d630cbd2d630ce12d'||chr(10)||
'440c002e030c1e2ec10b322e590b3a2ec80a3d0000';
    wwv_flow_api.g_varchar2_table(184) := '00080000003c000000080000003e00000018000000bd02000050000000fd020000e4000000130000000c00'||chr(10)||
'0000010000002';
    wwv_flow_api.g_varchar2_table(185) := '50000000c0000000000008024000000240000000000804100000000000000000000804100000000000000000200000024000';
    wwv_flow_api.g_varchar2_table(186) := '000240000000000'||chr(10)||
'803d00000000000000000000803d000000000000000002000000250000000c0000000200000013000000';
    wwv_flow_api.g_varchar2_table(187) := '0c000000010000003b00000008000000550000009401'||chr(10)||
'00000000000000000000ffffffffffffffff5e000000f22f420c5e3';
    wwv_flow_api.g_varchar2_table(188) := '02d0cc9301a0c3431060c3d31520c4d31870c6331a90c7831ca0c9831da0cbf31da0cea31'||chr(10)||
'da0c0d32c90c2632a40c393289';
    wwv_flow_api.g_varchar2_table(189) := '0c4532660c47323d0c49320f0c3f32eb0b2832d20b1832c00beb31aa0ba2318f0b3531670be930440bc030220b9630000b73';
    wwv_flow_api.g_varchar2_table(190) := '30'||chr(10)||
'c90a5b307a0a41302b0a3730d1093c306c094230fd0857309e087b304d089f30fc07d030c107093199074331710790315';
    wwv_flow_api.g_varchar2_table(191) := 'e07ef315e0753325e079c326e07ca32'||chr(10)||
'8c07f732ab071d33da073a331b0855335c086c33b3087b33200914333409ae324809';
    wwv_flow_api.g_varchar2_table(192) := '47325c09423226093632ff082632e5080f32c408f031b308cd31b308a931'||chr(10)||
'b3088e31bf087c31d8086a31f408603113095e3';
    wwv_flow_api.g_varchar2_table(193) := '137095c31610965318009793195098c31aa09ba31bc09ff31ce096832e609b732080ae832330a19335e0a3f33'||chr(10)||
'9b0a5633ec';
    wwv_flow_api.g_varchar2_table(194) := '0a6d333d0b7633940b7133f40b6c33550c5833b40c3733100d15336c0de232b40da132ea0d6032200e08323b0e9c313b0e03';
    wwv_flow_api.g_varchar2_table(195) := '313b0e97300f0e5c30'||chr(10)||
'b70d2030600dfc2fe30cf22f420c3c000000080000003e00000018000000ff0200007500000038030';
    wwv_flow_api.g_varchar2_table(196) := '000e4000000130000000c00000001000000250000000c00'||chr(10)||
'0000000000802400000024000000000080410000000000000000';
    wwv_flow_api.g_varchar2_table(197) := '0000804100000000000000000200000024000000240000000000803d00000000000000000000'||chr(10)||
'803d0000000000000000020';
    wwv_flow_api.g_varchar2_table(198) := '00000250000000c00000002000000130000000c000000010000003b00000008000000550000007c010000000000000000000';
    wwv_flow_api.g_varchar2_table(199) := '0ffff'||chr(10)||
'ffffffffffff580000000836150b7a36070bec36f90a5e37eb0a5f37590b6a37ad0b7e37e80b9d37450ccf37740c14';
    wwv_flow_api.g_varchar2_table(200) := '38740c4738740c70385d0c8e382c0cac38'||chr(10)||
'fc0bbd38c50bc038860bc3384a0bb838140ba138e40a8a38b50a4e38890af1375';
    wwv_flow_api.g_varchar2_table(201) := 'e0a5837150aec36ba09b03644097536cf085a363a086336840769360e078136'||chr(10)||
'9c06a9363206d036c8050937760552373805';
    wwv_flow_api.g_varchar2_table(202) := '9937fb04f937de047238de040639de0475391405bc398205033af205283aa1062a3a9107ba399f074839ab07d738'||chr(10)||
'b907d53';
    wwv_flow_api.g_varchar2_table(203) := '85007c5380507ab38d5069138a5066b388e0638388e060e388e06ee379f06d737c206c137e606b4371107b1374407af37680';
    wwv_flow_api.g_varchar2_table(204) := '7b6378907c637a707d537'||chr(10)||
'c507fc37e1073938fd07d13842083f3984087f39c908bd390f09ec396409053acb091d3a320a27';
    wwv_flow_api.g_varchar2_table(205) := '3aa30a203a220b183ab70bfc39400ccd39bd0c9e393a0d5e39'||chr(10)||
'990d1239da0dc6381c0e67383c0ef7373c0e32373c0eac36f';
    wwv_flow_api.g_varchar2_table(206) := '10d6a36580d2736c00c0536ff0b0836150b3c000000080000003e00000018000000600300004d00'||chr(10)||
'0000a3030000e4000000';
    wwv_flow_api.g_varchar2_table(207) := '130000000c00000001000000250000000c000000000000802400000024000000000080410000000000000000000080410000';
    wwv_flow_api.g_varchar2_table(208) := '00000000'||chr(10)||
'00000200000024000000240000000000803d00000000000000000000803d0000000000000000020000002500000';
    wwv_flow_api.g_varchar2_table(209) := '00c00000002000000130000000c0000000100'||chr(10)||
'00003b000000080000001b000000100000005d3e00006c0b000058000000e8';
    wwv_flow_api.g_varchar2_table(210) := '0000000000000000000000ffffffffffffffff33000000873d6c0bb03c6c0bd93b'||chr(10)||
'6c0bd93bd30be43b210cf73b530c113c9';
    wwv_flow_api.g_varchar2_table(211) := 'c0c393cc10c6b3cc10c8a3cc10caa3cb10cc73c910cda3c7c0cef3c5a0c053d270c6d3d3b0cd63d4e0c3e3e620c063e'||chr(10)||
'0b0d';
    wwv_flow_api.g_varchar2_table(212) := 'c43d820d7c3dcc0d343d170ed03c3b0e503c3b0ee13b3b0e8b3b1c0e4f3bdc0d133b9d0de33a3a0dc13ab10c9f3a280c913a';
    wwv_flow_api.g_varchar2_table(213) := '890b9b3ad00aa93ac909df3a'||chr(10)||
'f6083b3b5208963bae070f3c5e07a33c5e071b3d5e07783d8207b93dcc07fa3d15082b3e7e0';
    wwv_flow_api.g_varchar2_table(214) := '8473e0809633e92096d3e460a613e230b603e3c0b5f3e540b5d3e'||chr(10)||
'6c0b3d000000080000001b00000010000000273d000038';
    wwv_flow_api.g_varchar2_table(215) := '0a000058000000580000000000000000000000ffffffffffffffff0f000000273dbb091b3d6209033d'||chr(10)||
'2c09eb3cf608c83cd';
    wwv_flow_api.g_varchar2_table(216) := 'c089c3cdc08693cdc083e3c05091b3c5509053c8809f53bd409ea3b380a543c380abd3c380a273d380a3d000000080000003';
    wwv_flow_api.g_varchar2_table(217) := 'c0000000800'||chr(10)||
'00003e00000018000000a903000075000000e7030000e4000000130000000c00000001000000250000000c00';
    wwv_flow_api.g_varchar2_table(218) := '0000000000802400000024000000000080410000'||chr(10)||
'00000000000000008041000000000000000002000000240000002400000';
    wwv_flow_api.g_varchar2_table(219) := '00000803d00000000000000000000803d000000000000000002000000250000000c00'||chr(10)||
'000002000000130000000c00000001';
    wwv_flow_api.g_varchar2_table(220) := '0000003b0000000800000055000000b00000000000000000000000ffffffffffffffff25000000293f84078d3f8407f13f'||chr(10)||
'8';
    wwv_flow_api.g_varchar2_table(221) := '407554084075040e0074b403c0847409808694021088d40cf07ae40a107ce407407f6405e0723415e0752415e0785417c07b';
    wwv_flow_api.g_varchar2_table(222) := '941b707914150086641e9083e41'||chr(10)||
'82091a416209fc405209e6405209bd405209994075097f40bb0959401d0a3e40d40a3040';
    wwv_flow_api.g_varchar2_table(223) := 'e10b27409d0c1d40590d1340150ea73f150e3c3f150ed03e150eed3e'||chr(10)||
'e50b0b3fb409293f84073c000000080000003e00000';
    wwv_flow_api.g_varchar2_table(224) := '018000000ed030000750000001c040000e2000000130000000c00000001000000250000000c0000000000'||chr(10)||
'00802400000024';
    wwv_flow_api.g_varchar2_table(225) := '0000000000804100000000000000000000804100000000000000000200000024000000240000000000803d00000000000000';
    wwv_flow_api.g_varchar2_table(226) := '000000803d0000'||chr(10)||
'00000000000002000000250000000c00000002000000130000000c000000010000003b000000080000005';
    wwv_flow_api.g_varchar2_table(227) := '5000000740000000000000000000000ffffffffffff'||chr(10)||
'ffff16000000f241840761428407d04284073f4384076243e8088743';
    wwv_flow_api.g_varchar2_table(228) := '4a0aaa43ad0bf4434a0a4144e8088b448407f744840763458407cf4584073d45b509a444'||chr(10)||
'e40b1244150eb343150e5443150';
    wwv_flow_api.g_varchar2_table(229) := 'ef542150ea142e40b4642b509f24184073c000000080000003e000000180000001f040000780000005d040000e2000000130';
    wwv_flow_api.g_varchar2_table(230) := '0'||chr(10)||
'00000c00000001000000250000000c00000000000080240000002400000000008041000000000000000000008041000000';
    wwv_flow_api.g_varchar2_table(231) := '000000000002000000240000002400'||chr(10)||
'00000000803d00000000000000000000803d000000000000000002000000250000000';
    wwv_flow_api.g_varchar2_table(232) := 'c00000002000000130000000c000000010000003b000000080000001b00'||chr(10)||
'0000100000005946000005050000580000004c00';
    wwv_flow_api.g_varchar2_table(233) := '00000000000000000000ffffffffffffffff0c000000c44605052f4705059a470505924797058a4729068347'||chr(10)||
'bc061847bc0';
    wwv_flow_api.g_varchar2_table(234) := '6ad46bc064246bc064946290651469705594605053d000000080000001b000000100000003746000084070000580000004c0';
    wwv_flow_api.g_varchar2_table(235) := '00000000000000000'||chr(10)||
'0000ffffffffffffffff0c000000a24684070d478407784784075b47b4093d47e50b2047150eb54615';
    wwv_flow_api.g_varchar2_table(236) := '0e4a46150edf45150efc45e50b1a46b409374684073d00'||chr(10)||
'0000080000003c000000080000003e000000180000005d0400005';
    wwv_flow_api.g_varchar2_table(237) := '00000007a040000e2000000130000000c00000001000000250000000c000000000000802400'||chr(10)||
'000024000000000080410000';
    wwv_flow_api.g_varchar2_table(238) := '0000000000000000804100000000000000000200000024000000240000000000803d00000000000000000000803d00000000';
    wwv_flow_api.g_varchar2_table(239) := '0000'||chr(10)||
'000002000000250000000c00000002000000130000000c000000010000003b000000080000005500000034010000000';
    wwv_flow_api.g_varchar2_table(240) := '0000000000000ffffffffffffffff4600'||chr(10)||
'0000804a820be54a9a0b4a4bb00bae4bc80b974b480c754bb50c4a4b130d1f4b70';
    wwv_flow_api.g_varchar2_table(241) := '0de94ab80dac4aed0d6d4a220e204a3b0ec4493b0e6a493b0e22492b0ee848'||chr(10)||
'0a0eaf48e80d7e48b30d5848680d32481e0d1';
    wwv_flow_api.g_varchar2_table(242) := '448c70c0248630cef47ff0be9477b0bf247d40afb47280a12489809354825094e48d1087148850899484108c148'||chr(10)||
'fe07eb48';
    wwv_flow_api.g_varchar2_table(243) := 'ce071449ac0755497707a7495e07094a5e07924a5e07f94a8f073b4bf1077c4b5408a84be408bb4ba009554bbb09ee4ad509';
    wwv_flow_api.g_varchar2_table(244) := '884af109834aa909744a'||chr(10)||
'72095e4a4e09474a2909254a1809fb491809c649180999493e0975498a095049d80939494b0a314';
    wwv_flow_api.g_varchar2_table(245) := '9e60a2a49700b3549d80b51491f0c6d49670c96498b0cc849'||chr(10)||
'8b0cf2498b0c174a750c364a4a0c544a1f0c6e4add0b804a82';
    wwv_flow_api.g_varchar2_table(246) := '0b3c000000080000003e000000180000007e04000075000000bc040000e4000000130000000c00'||chr(10)||
'000001000000250000000';
    wwv_flow_api.g_varchar2_table(247) := 'c000000000000802400000024000000000080410000000000000000000080410000000000000000020000002400000024000';
    wwv_flow_api.g_varchar2_table(248) := '0000000'||chr(10)||
'803d00000000000000000000803d000000000000000002000000250000000c00000002000000130000000c000000';
    wwv_flow_api.g_varchar2_table(249) := '010000003b000000080000001b0000001000'||chr(10)||
'0000e94f00006c0b000058000000e80000000000000000000000fffffffffff';
    wwv_flow_api.g_varchar2_table(250) := 'fffff33000000124f6c0b3b4e6c0b654d6c0b654dd30b6f4d210c824d530c9d4d'||chr(10)||
'9c0cc54dc10cf64dc10c164ec10c354eb1';
    wwv_flow_api.g_varchar2_table(251) := '0c534e910c654e7c0c7a4e5a0c904e270cf94e3b0c614f4e0cca4f620c914f0b0d4f4f820d074fcc0dbf4e170e5b4e'||chr(10)||
'3b0ed';
    wwv_flow_api.g_varchar2_table(252) := 'b4d3b0e6c4d3b0e164d1c0eda4cdc0d9e4c9d0d6e4c3a0d4c4cb10c2a4c280c1d4c890b264cd00a344cc9096b4cf608c64c5';
    wwv_flow_api.g_varchar2_table(253) := '208214dae079b4d5e072e4e'||chr(10)||
'5e07a64e5e07044f8207444fcc07854f1508b64f7e08d24f0809ef4f9209f84f460aec4f230b';
    wwv_flow_api.g_varchar2_table(254) := 'eb4f3c0bea4f540be94f6c0b3d000000080000001b0000001000'||chr(10)||
'0000b24e0000380a0000580000005800000000000000000';
    wwv_flow_api.g_varchar2_table(255) := '00000ffffffffffffffff0f000000b34ebb09a64e62098f4e2c09764ef608544edc08274edc08f44d'||chr(10)||
'dc08c94d0509a74d55';
    wwv_flow_api.g_varchar2_table(256) := '09914d8809804dd409764d380adf4d380a494e380ab24e380a3d000000080000003c000000080000003e00000018000000c1';
    wwv_flow_api.g_varchar2_table(257) := '0400007500'||chr(10)||
'000000050000e4000000130000000c00000001000000250000000c00000000000080240000002400000000008';
    wwv_flow_api.g_varchar2_table(258) := '041000000000000000000008041000000000000'||chr(10)||
'00000200000024000000240000000000803d00000000000000000000803d';
    wwv_flow_api.g_varchar2_table(259) := '0000000000000000020000005f000000380000000300000038000000000000003800'||chr(10)||
'0000000000000000010064000000000';
    wwv_flow_api.g_varchar2_table(260) := '0000000000000000000000000000000000000250000000c00000003000000250000000c000000050000803b0000000800'||chr(10)||
'00';
    wwv_flow_api.g_varchar2_table(261) := '001b00000010000000a0170000150e000058000000000100000000000000000000ffffffffffffffff39000000c917100bf1';
    wwv_flow_api.g_varchar2_table(262) := '170a081a180505e0180505a719'||chr(10)||
'05056e1a0505dc1a0505301b1805681b3e05a01b6505cc1baa05ea1b1106071c7806131cf';
    wwv_flow_api.g_varchar2_table(263) := '6060c1c8907051c0908f11b7808d11bd508b11b3309861b7e09541b'||chr(10)||
'b909331bde09071bfd09d11a150afa1a330a181b4f0a';
    wwv_flow_api.g_varchar2_table(264) := '2a1b6c0a361b7f0a471ba80a5d1be60a721b240b811b550b871b760bb41b560ce51b350d111c150e980d'||chr(10)||
'000026060f00261';
    wwv_flow_api.g_varchar2_table(265) := 'b574d4643010000000000010000000000000002000000041b000000000000043b00008b1b150e041b150e7d1a150e4b1a280';
    wwv_flow_api.g_varchar2_table(266) := 'd161a3c0ce419'||chr(10)||
'500bd119f40abe19b80aad199d0a9519780a7819670a5819670a4d19670a4319670a3819670a2819a10b17';
    wwv_flow_api.g_varchar2_table(267) := '19db0c0719150e8f18150e1718150ea017150e3d00'||chr(10)||
'0000080000001b000000100000004f190000b1080000580000007c000';
    wwv_flow_api.g_varchar2_table(268) := '0000000000000000000ffffffffffffffff180000008219b108b419b108e619b108f719'||chr(10)||
'b108171aa608461a91085e1a8808';
    wwv_flow_api.g_varchar2_table(269) := '741a7008851a4908951a21089f1af507a21ac207a61a78079c1a3d07871a1607721aee06471ada06051ada06d119da069c19';
    wwv_flow_api.g_varchar2_table(270) := ''||chr(10)||
'da066819da0660197707581914084f19b1083d000000080000003c000000080000004000000018000000750100004c00000';
    wwv_flow_api.g_varchar2_table(271) := '0c6010000e6000000250000000c00'||chr(10)||
'000007000080250000000c000000000000802400000024000000000080410000000000';
    wwv_flow_api.g_varchar2_table(272) := '00000000008041000000000000000002000000280000000c0000000300'||chr(10)||
'000024000000240000000000803d0000000000000';
    wwv_flow_api.g_varchar2_table(273) := '0000000803d0000000000000000020000005f00000038000000030000003800000000000000380000000000'||chr(10)||
'000000000100';
    wwv_flow_api.g_varchar2_table(274) := '640000000000000000000000000000000000000000000000250000000c00000003000000250000000c000000050000803b00';
    wwv_flow_api.g_varchar2_table(275) := '0000080000001b00'||chr(10)||
'0000100000000c2000006c0b000058000000e80000000000000000000000ffffffffffffffff3300000';
    wwv_flow_api.g_varchar2_table(276) := '0361f6c0b5f1e6c0b881d6c0b881dd30b931d210ca61d'||chr(10)||
'530cc11d9c0ce81dc10c1a1ec10c391ec10c591eb10c761e910c89';
    wwv_flow_api.g_varchar2_table(277) := '1e7c0c9e1e5a0cb41e270c1c1f3b0c851f4e0ced1f620cb51f0b0d731f820d2b1fcc0de31e'||chr(10)||
'170e7f1e3b0eff1d3b0e901d3';
    wwv_flow_api.g_varchar2_table(278) := 'b0e3a1d1c0efe1cdc0dc21c9d0d921c3a0d701cb10c4e1c280c401c890b4a1cd00a581cc9098e1cf608ea1c5208451dae07b';
    wwv_flow_api.g_varchar2_table(279) := 'e1d'||chr(10)||
'5e07521e5e07ca1e5e07271f8207681fcc07a91f1508da1f7e08f61f0809132092091c20460a1020230b0f203c0b0e20';
    wwv_flow_api.g_varchar2_table(280) := '540b0c206c0b3d000000080000001b00'||chr(10)||
'000010000000d61e0000380a000058000000580000000000000000000000fffffff';
    wwv_flow_api.g_varchar2_table(281) := 'fffffffff0f000000d61ebb09ca1e6209b21e2c099a1ef608771edc084b1e'||chr(10)||
'dc08181edc08ed1d0509ca1d5509b51d8809a4';
    wwv_flow_api.g_varchar2_table(282) := '1dd4099a1d380a031e380a6c1e380ad61e380a3d000000080000003c000000080000004000000018000000bf01'||chr(10)||
'000071000';
    wwv_flow_api.g_varchar2_table(283) := '00006020000e8000000250000000c00000007000080250000000c00000000000080240000002400000000008041000000000';
    wwv_flow_api.g_varchar2_table(284) := '0000000000080410000'||chr(10)||
'00000000000002000000280000000c0000000300000024000000240000000000803d000000000000';
    wwv_flow_api.g_varchar2_table(285) := '00000000803d0000000000000000020000005f0000003800'||chr(10)||
'000003000000380000000000000038000000000000000000010';
    wwv_flow_api.g_varchar2_table(286) := '0640000000000000000000000000000000000000000000000250000000c000000030000002500'||chr(10)||
'00000c0000000500008055';
    wwv_flow_api.g_varchar2_table(287) := '00000034010000030200007100000049020000e8000000460000001023820b74239a0bd923b00b3d24c80b2624480c0424b5';
    wwv_flow_api.g_varchar2_table(288) := '0cd923'||chr(10)||
'130dae23700d7823b80d3b23ed0dfd22220eaf223b0e53223b0efa213b0eb1212b0e78210a0e3e21e80d0d21b30de';
    wwv_flow_api.g_varchar2_table(289) := '720680dc1201e0da320c70c9020630c7e20'||chr(10)||
'ff0b79207b0b8120d40a8a20280aa1209809c4202509dd20d108002185082821';
    wwv_flow_api.g_varchar2_table(290) := '41085021fe077b21ce07a321ac07e421770736225e0798225e0721235e078823'||chr(10)||
'8f07ca23f1070b2454083724e4084a24a00';
    wwv_flow_api.g_varchar2_table(291) := '9e423bb097d23d5091723f1091223a90903237209ec224e09d6222909b42218098a2218095622180928223e090422'||chr(10)||
'8a09df';
    wwv_flow_api.g_varchar2_table(292) := '21d809c8214b0ac021e60ab821700bc421d80be0211f0cfc21670c25228b0c57228b0c81228b0ca622750cc5224a0ce3221f';
    wwv_flow_api.g_varchar2_table(293) := '0cfd22dd0b1023820b2500'||chr(10)||
'00000c00000007000080250000000c00000000000080240000002400000000008041000000000';
    wwv_flow_api.g_varchar2_table(294) := '000000000008041000000000000000002000000280000000c00'||chr(10)||
'00000300000024000000240000000000803d000000000000';
    wwv_flow_api.g_varchar2_table(295) := '00000000803d0000000000000000020000005f000000380000000300000038000000000000003800'||chr(10)||
'0000000000000000010';
    wwv_flow_api.g_varchar2_table(296) := '0640000000000000000000000000000000000000000000000250000000c00000003000000250000000c000000050000803b0';
    wwv_flow_api.g_varchar2_table(297) := '000000800'||chr(10)||
'00001b00000010000000b6240000d10a0000580000007c0000000000000000000000ffffffffffffffff180000';
    wwv_flow_api.g_varchar2_table(298) := '00c424d109fb24fe0859255708b625b0073126'||chr(10)||
'5e07c3265e076c275e07e627c007312883086c2820098528e2097928c80a6';
    wwv_flow_api.g_varchar2_table(299) := 'c28ca0b35289d0cd827420d7b27e90dff263b0e68263b0ee1253b0e7625f70d2c25'||chr(10)||
'6d0dd124c30ca824e50bb624d10a3d00';
    wwv_flow_api.g_varchar2_table(300) := '0000080000001b00000010000000f8250000d00a0000580000007c0000000000000000000000ffffffffffffffff1800'||chr(10)||
'000';
    wwv_flow_api.g_varchar2_table(301) := '0f025660bfa25d40b14261c0c2e26630c5326870c8026870caf26870cd726650cf8261e0c1927d60b2e27660b3727c90a3e2';
    wwv_flow_api.g_varchar2_table(302) := '7380a3427cb091b2784090127'||chr(10)||
'3c09dd261a09b1261a0982261a0959263e09372685091526ce0900263c0af825d00a3d0000';
    wwv_flow_api.g_varchar2_table(303) := '00080000003c000000080000004000000018000000460200007100'||chr(10)||
'00008d020000e8000000250000000c000000070000802';
    wwv_flow_api.g_varchar2_table(304) := '50000000c00000000000080240000002400000000008041000000000000000000008041000000000000'||chr(10)||
'0000020000002800';
    wwv_flow_api.g_varchar2_table(305) := '00000c0000000300000024000000240000000000803d00000000000000000000803d0000000000000000020000005f000000';
    wwv_flow_api.g_varchar2_table(306) := '380000000300'||chr(10)||
'000038000000000000003800000000000000000001006400000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(307) := '00000250000000c00000003000000250000000c00'||chr(10)||
'00000500008055000000b00000008a02000071000000c2020000e60000';
    wwv_flow_api.g_varchar2_table(308) := '002500000043298407a72984070b2a8407702a84076b2ae007662a3c08612a9808842a'||chr(10)||
'2108a72acf07c82aa107e92a74071';
    wwv_flow_api.g_varchar2_table(309) := '02b5e073d2b5e076c2b5e07a02b7c07d42bb707ab2b5008812be908582b8209342b6209172b5209012b5209d72a5209b42a'||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(310) := '75099a2abb09742a1d0a592ad40a4b2ae10b412a9d0c372a590d2d2a150ec229150e5629150eeb28150e0829e50b2529b409';
    wwv_flow_api.g_varchar2_table(311) := '43298407250000000c0000000700'||chr(10)||
'0080250000000c000000000000802400000024000000000080410000000000000000000';
    wwv_flow_api.g_varchar2_table(312) := '08041000000000000000002000000280000000c000000030000002400'||chr(10)||
'0000240000000000803d0000000000000000000080';
    wwv_flow_api.g_varchar2_table(313) := '3d0000000000000000020000005f0000003800000003000000380000000000000038000000000000000000'||chr(10)||
'0100640000000';
    wwv_flow_api.g_varchar2_table(314) := '000000000000000000000000000000000000000250000000c00000003000000250000000c000000050000803b00000008000';
    wwv_flow_api.g_varchar2_table(315) := '0001b0000001000'||chr(10)||
'0000c92f00000505000058000000b80000000000000000000000ffffffffffffffff27000000a02f0a08';
    wwv_flow_api.g_varchar2_table(316) := '772f100b4f2f150eeb2e150e872e150e222e150e272e'||chr(10)||
'c20d2b2e6f0d2f2e1c0d012e870dd52dcd0db12df20d802d230e4b2';
    wwv_flow_api.g_varchar2_table(317) := 'd3b0e122d3b0ea02c3b0e4d2ce40d1b2c360de92b870cd52bb40be22bbb0af02ba5091e2c'||chr(10)||
'd008682c3c08b02ca8070a2d5e';
    wwv_flow_api.g_varchar2_table(318) := '07702d5e07a22d5e07cf2d6f07f62d91071c2eb3073f2ee5075a2e2908682e1d07772e1106852e0505f12e05055d2f0505c9';
    wwv_flow_api.g_varchar2_table(319) := '2f'||chr(10)||
'05053d000000080000001b000000100000003a2e0000c80a0000580000007c0000000000000000000000fffffffffffff';
    wwv_flow_api.g_varchar2_table(320) := 'fff18000000402e440a372ee1091f2e'||chr(10)||
'a009082e5f09e52d3f09bb2d3f09952d3f09742d5f09582d9d093c2ddb09292d430a';
    wwv_flow_api.g_varchar2_table(321) := '212dd60a1a2d600b232dc30b392d030c4f2d440c6e2d630c942d630cbd2d'||chr(10)||
'630ce12d440c002e030c1e2ec10b322e590b3a2';
    wwv_flow_api.g_varchar2_table(322) := 'ec80a3d000000080000003c000000080000004000000018000000b90200004c00000001030000e80000002500'||chr(10)||
'00000c0000';
    wwv_flow_api.g_varchar2_table(323) := '0007000080250000000c00000000000080240000002400000000008041000000000000000000008041000000000000000002';
    wwv_flow_api.g_varchar2_table(324) := '000000280000000c00'||chr(10)||
'00000300000024000000240000000000803d00000000000000000000803d000000000000000002000';
    wwv_flow_api.g_varchar2_table(325) := '0005f000000380000000300000038000000000000003800'||chr(10)||
'0000000000000000010064000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(326) := '0000000000000000250000000c00000003000000250000000c00000005000080550000009401'||chr(10)||
'0000fb020000710000003c0';
    wwv_flow_api.g_varchar2_table(327) := '30000e80000005e000000f22f420c5e302d0cc9301a0c3431060c3d31520c4d31870c6331a90c7831ca0c9831da0cbf31da0';
    wwv_flow_api.g_varchar2_table(328) := 'cea31'||chr(10)||
'da0c0d32c90c2632a40c3932890c4532660c47323d0c49320f0c3f32eb0b2832d20b1832c00beb31aa0ba2318f0b35';
    wwv_flow_api.g_varchar2_table(329) := '31670be930440bc030220b9630000b7330'||chr(10)||
'c90a5b307a0a41302b0a3730d1093c306c094230fd0857309e087b304d089f30f';
    wwv_flow_api.g_varchar2_table(330) := 'c07d030c107093199074331710790315e07ef315e0753325e079c326e07ca32'||chr(10)||
'8c07f732ab071d33da073a331b0855335c08';
    wwv_flow_api.g_varchar2_table(331) := '6c33b3087b33200914333409ae32480947325c09423226093632ff082632e5080f32c408f031b308cd31b308a931'||chr(10)||
'b3088e3';
    wwv_flow_api.g_varchar2_table(332) := '1bf087c31d8086a31f408603113095e3137095c31610965318009793195098c31aa09ba31bc09ff31ce096832e609b732080';
    wwv_flow_api.g_varchar2_table(333) := 'ae832330a19335e0a3f33'||chr(10)||
'9b0a5633ec0a6d333d0b7633940b7133f40b6c33550c5833b40c3733100d15336c0de232b40da1';
    wwv_flow_api.g_varchar2_table(334) := '32ea0d6032200e08323b0e9c313b0e03313b0e97300f0e5c30'||chr(10)||
'b70d2030600dfc2fe30cf22f420c250000000c00000007000';
    wwv_flow_api.g_varchar2_table(335) := '080250000000c000000000000802400000024000000000080410000000000000000000080410000'||chr(10)||
'00000000000002000000';
    wwv_flow_api.g_varchar2_table(336) := '280000000c0000000300000024000000240000000000803d00000000000000000000803d0000000000000000020000005f00';
    wwv_flow_api.g_varchar2_table(337) := '00003800'||chr(10)||
'0000030000003800000000000000380000000000000000000100640000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(338) := '000000000250000000c000000030000002500'||chr(10)||
'00000c00000005000080550000007c0100005c03000049000000a7030000e8';
    wwv_flow_api.g_varchar2_table(339) := '000000580000000836150b7a36070bec36f90a5e37eb0a5f37590b6a37ad0b7e37'||chr(10)||
'e80b9d37450ccf37740c1438740c47387';
    wwv_flow_api.g_varchar2_table(340) := '40c70385d0c8e382c0cac38fc0bbd38c50bc038860bc3384a0bb838140ba138e40a8a38b50a4e38890af1375e0a5837'||chr(10)||
'150a';
    wwv_flow_api.g_varchar2_table(341) := 'ec36ba09b03644097536cf085a363a086336840769360e0781369c06a9363206d036c80509377605523738059937fb04f937';
    wwv_flow_api.g_varchar2_table(342) := 'de047238de040639de047539'||chr(10)||
'1405bc398205033af205283aa1062a3a9107ba399f074839ab07d738b907d5385007c538050';
    wwv_flow_api.g_varchar2_table(343) := '7ab38d5069138a5066b388e0638388e060e388e06ee379f06d737'||chr(10)||
'c206c137e606b4371107b1374407af376807b6378907c6';
    wwv_flow_api.g_varchar2_table(344) := '37a707d537c507fc37e1073938fd07d13842083f3984087f39c908bd390f09ec396409053acb091d3a'||chr(10)||
'320a273aa30a203a2';
    wwv_flow_api.g_varchar2_table(345) := '20b183ab70bfc39400ccd39bd0c9e393a0d5e39990d1239da0dc6381c0e67383c0ef7373c0e32373c0eac36f10d6a36580d2';
    wwv_flow_api.g_varchar2_table(346) := '736c00c0536'||chr(10)||
'ff0b0836150b250000000c00000007000080250000000c000000000000802400000024000000000080410000';
    wwv_flow_api.g_varchar2_table(347) := '0000000000000000804100000000000000000200'||chr(10)||
'0000280000000c0000000300000024000000240000000000803d0000000';
    wwv_flow_api.g_varchar2_table(348) := '0000000000000803d0000000000000000020000005f00000038000000030000003800'||chr(10)||
'000000000000380000000000000000';
    wwv_flow_api.g_varchar2_table(349) := '000100640000000000000000000000000000000000000000000000250000000c00000003000000250000000c0000000500'||chr(10)||
'0';
    wwv_flow_api.g_varchar2_table(350) := '0803b000000080000001b000000100000005d3e00006c0b000058000000e80000000000000000000000ffffffffffffffff3';
    wwv_flow_api.g_varchar2_table(351) := '3000000873d6c0bb03c6c0bd93b'||chr(10)||
'6c0bd93bd30be43b210cf73b530c113c9c0c393cc10c6b3cc10c8a3cc10caa3cb10cc73c';
    wwv_flow_api.g_varchar2_table(352) := '910cda3c7c0cef3c5a0c053d270c6d3d3b0cd63d4e0c3e3e620c063e'||chr(10)||
'0b0dc43d820d7c3dcc0d343d170ed03c3b0e503c3b0';
    wwv_flow_api.g_varchar2_table(353) := 'ee13b3b0e8b3b1c0e4f3bdc0d133b9d0de33a3a0dc13ab10c9f3a280c913a890b9b3ad00aa93ac909df3a'||chr(10)||
'f6083b3b520896';
    wwv_flow_api.g_varchar2_table(354) := '3bae070f3c5e07a33c5e071b3d5e07783d8207b93dcc07fa3d15082b3e7e08473e0809633e92096d3e460a613e230b603e3c';
    wwv_flow_api.g_varchar2_table(355) := '0b5f3e540b5d3e'||chr(10)||
'6c0b3d000000080000001b00000010000000273d0000380a000058000000580000000000000000000000f';
    wwv_flow_api.g_varchar2_table(356) := 'fffffffffffffff0f000000273dbb091b3d6209033d'||chr(10)||
'2c09eb3cf608c83cdc089c3cdc08693cdc083e3c05091b3c5509053c';
    wwv_flow_api.g_varchar2_table(357) := '8809f53bd409ea3b380a543c380abd3c380a273d380a3d000000080000003c0000000800'||chr(10)||
'00004000000018000000a403000';
    wwv_flow_api.g_varchar2_table(358) := '071000000eb030000e8000000250000000c00000007000080250000000c00000000000080240000002400000000008041000';
    wwv_flow_api.g_varchar2_table(359) := '0'||chr(10)||
'00000000000000008041000000000000000002000000280000000c0000000300000024000000240000000000803d000000';
    wwv_flow_api.g_varchar2_table(360) := '00000000000000803d000000000000'||chr(10)||
'0000020000005f0000003800000003000000380000000000000038000000000000000';
    wwv_flow_api.g_varchar2_table(361) := '00001006400000000000000000000000000000000000000000000002500'||chr(10)||
'00000c00000003000000250000000c0000000500';
    wwv_flow_api.g_varchar2_table(362) := '008055000000b0000000e80300007100000020040000e600000025000000293f84078d3f8407f13f84075540'||chr(10)||
'84075040e00';
    wwv_flow_api.g_varchar2_table(363) := '74b403c0847409808694021088d40cf07ae40a107ce407407f6405e0723415e0752415e0785417c07b941b70791415008664';
    wwv_flow_api.g_varchar2_table(364) := '1e9083e4182091a41'||chr(10)||
'6209fc405209e6405209bd405209994075097f40bb0959401d0a3e40d40a3040e10b27409d0c1d4059';
    wwv_flow_api.g_varchar2_table(365) := '0d1340150ea73f150e3c3f150ed03e150eed3ee50b0b3f'||chr(10)||
'b409293f8407250000000c00000007000080250000000c0000000';
    wwv_flow_api.g_varchar2_table(366) := '000008024000000240000000000804100000000000000000000804100000000000000000200'||chr(10)||
'0000280000000c0000000300';
    wwv_flow_api.g_varchar2_table(367) := '000024000000240000000000803d00000000000000000000803d0000000000000000020000005f0000003800000003000000';
    wwv_flow_api.g_varchar2_table(368) := '3800'||chr(10)||
'000000000000380000000000000000000100640000000000000000000000000000000000000000000000250000000c0';
    wwv_flow_api.g_varchar2_table(369) := '0000003000000250000000c0000000500'||chr(10)||
'008055000000740000001b0400007400000062040000e600000016000000f24184';
    wwv_flow_api.g_varchar2_table(370) := '0761428407d04284073f4384076243e80887434a0aaa43ad0bf4434a0a4144'||chr(10)||
'e8088b448407f744840763458407cf4584073';
    wwv_flow_api.g_varchar2_table(371) := 'd45b509a444e40b1244150eb343150e5443150ef542150ea142e40b4642b509f2418407250000000c0000000700'||chr(10)||
'00802500';
    wwv_flow_api.g_varchar2_table(372) := '00000c0000000000008024000000240000000000804100000000000000000000804100000000000000000200000028000000';
    wwv_flow_api.g_varchar2_table(373) := '0c000000030000002400'||chr(10)||
'0000240000000000803d00000000000000000000803d0000000000000000020000005f000000380';
    wwv_flow_api.g_varchar2_table(374) := '0000003000000380000000000000038000000000000000000'||chr(10)||
'01006400000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(375) := '00250000000c00000003000000250000000c000000050000803b000000080000001b0000001000'||chr(10)||
'000059460000050500005';
    wwv_flow_api.g_varchar2_table(376) := '80000004c0000000000000000000000ffffffffffffffff0c000000c44605052f4705059a470505924797058a4729068347b';
    wwv_flow_api.g_varchar2_table(377) := 'c061847'||chr(10)||
'bc06ad46bc064246bc064946290651469705594605053d000000080000001b000000100000003746000084070000';
    wwv_flow_api.g_varchar2_table(378) := '580000004c0000000000000000000000ffff'||chr(10)||
'ffffffffffff0c000000a24684070d478407784784075b47b4093d47e50b204';
    wwv_flow_api.g_varchar2_table(379) := '7150eb546150e4a46150edf45150efc45e50b1a46b409374684073d0000000800'||chr(10)||
'00003c0000000800000040000000180000';
    wwv_flow_api.g_varchar2_table(380) := '00590400004c0000007e040000e6000000250000000c00000007000080250000000c00000000000080240000002400'||chr(10)||
'00000';
    wwv_flow_api.g_varchar2_table(381) := '0008041000000000000000000008041000000000000000002000000280000000c00000003000000240000002400000000008';
    wwv_flow_api.g_varchar2_table(382) := '03d00000000000000000000'||chr(10)||
'803d0000000000000000020000005f0000003800000003000000380000000000000038000000';
    wwv_flow_api.g_varchar2_table(383) := '0000000000000100640000000000000000000000000000000000'||chr(10)||
'000000000000250000000c00000003000000250000000c0';
    wwv_flow_api.g_varchar2_table(384) := '000000500008055000000340100007a04000071000000c0040000e800000046000000804a820be54a'||chr(10)||
'9a0b4a4bb00bae4bc8';
    wwv_flow_api.g_varchar2_table(385) := '0b974b480c754bb50c4a4b130d1f4b700de94ab80dac4aed0d6d4a220e204a3b0ec4493b0e6a493b0e22492b0ee8480a0eaf';
    wwv_flow_api.g_varchar2_table(386) := '48e80d7e48'||chr(10)||
'b30d5848680d32481e0d1448c70c0248630cef47ff0be9477b0bf247d40afb47280a12489809354825094e48d';
    wwv_flow_api.g_varchar2_table(387) := '1087148850899484108c148fe07eb48ce071449'||chr(10)||
'ac0755497707a7495e07094a5e07924a5e07f94a8f073b4bf1077c4b5408';
    wwv_flow_api.g_varchar2_table(388) := 'a84be408bb4ba009554bbb09ee4ad509884af109834aa909744a72095e4a4e09474a'||chr(10)||
'2909254a1809fb491809c6491809994';
    wwv_flow_api.g_varchar2_table(389) := '93e0975498a095049d80939494b0a3149e60a2a49700b3549d80b51491f0c6d49670c96498b0cc8498b0cf2498b0c174a'||chr(10)||
'75';
    wwv_flow_api.g_varchar2_table(390) := '0c364a4a0c544a1f0c6e4add0b804a820b250000000c00000007000080250000000c00000000000080240000002400000000';
    wwv_flow_api.g_varchar2_table(391) := '00804100000000000000000000'||chr(10)||
'8041000000000000000002000000280000000c00000003000000240000002400000000008';
    wwv_flow_api.g_varchar2_table(392) := '03d00000000000000000000803d0000000000000000020000005f00'||chr(10)||
'00003800000003000000380000000000000038000000';
    wwv_flow_api.g_varchar2_table(393) := '0000000000000100640000000000000000000000000000000000000000000000250000000c0000000300'||chr(10)||
'0000250000000c0';
    wwv_flow_api.g_varchar2_table(394) := '00000050000803b000000080000001b00000010000000e94f00006c0b000058000000e80000000000000000000000fffffff';
    wwv_flow_api.g_varchar2_table(395) := 'fffffffff3300'||chr(10)||
'0000124f6c0b3b4e6c0b654d6c0b654dd30b6f4d210c824d530c9d4d9c0cc54dc10cf64dc10c164ec10c35';
    wwv_flow_api.g_varchar2_table(396) := '4eb10c534e910c654e7c0c7a4e5a0c904e270cf94e'||chr(10)||
'3b0c614f4e0cca4f620c914f0b0d4f4f820d074fcc0dbf4e170e5b4e3';
    wwv_flow_api.g_varchar2_table(397) := 'b0edb4d3b0e6c4d3b0e164d1c0eda4cdc0d9e4c9d0d6e4c3a0d4c4cb10c2a4c280c1d4c'||chr(10)||
'890b264cd00a344cc9096b4cf608';
    wwv_flow_api.g_varchar2_table(398) := 'c64c5208214dae079b4d5e072e4e5e07a64e5e07044f8207444fcc07854f1508b64f7e08d24f0809ef4f9209f84f460aec4f';
    wwv_flow_api.g_varchar2_table(399) := ''||chr(10)||
'230beb4f3c0bea4f540be94f6c0b3d000000080000001b00000010000000b24e0000380a000058000000580000000000000';
    wwv_flow_api.g_varchar2_table(400) := '000000000ffffffffffffffff0f00'||chr(10)||
'0000b34ebb09a64e62098f4e2c09764ef608544edc08274edc08f44ddc08c94d0509a7';
    wwv_flow_api.g_varchar2_table(401) := '4d5509914d8809804dd409764d380adf4d380a494e380ab24e380a3d00'||chr(10)||
'0000080000003c000000080000004000000018000';
    wwv_flow_api.g_varchar2_table(402) := '000bd0400007100000004050000e8000000250000000c00000007000080250000000c000000000000802400'||chr(10)||
'000024000000';
    wwv_flow_api.g_varchar2_table(403) := '00008041000000000000000000008041000000000000000002000000280000000c00000003000000220000000c000000ffff';
    wwv_flow_api.g_varchar2_table(404) := 'ffff460000001400'||chr(10)||
'0000080000004744494303000000250000000c0000000e0000800e00000014000000000000001000000';
    wwv_flow_api.g_varchar2_table(405) := '0140000000400000003010800050000000b0200000000'||chr(10)||
'050000000c0245006603040000002e0118001c000000fb02040002';
    wwv_flow_api.g_varchar2_table(406) := '0000000000bc02000000000102022253797374656d00000000000000000000000000000000'||chr(10)||
'0000000000000000000004000';
    wwv_flow_api.g_varchar2_table(407) := '0002d01000004000000020101001c000000fb02eaff0000000000009001000000000440001254696d6573204e657720526f6';
    wwv_flow_api.g_varchar2_table(408) := 'd61'||chr(10)||
'6e0000000000000000000000000000000000040000002d010100050000000902000000020d000000320a140000000100';
    wwv_flow_api.g_varchar2_table(409) := '0400000000006403450020230a000300'||chr(10)||
'00001e0007000000fc020000000000000000040000002d01020008000000fa02050';
    wwv_flow_api.g_varchar2_table(410) := '000000000ffffff00040000002d0103000e00000024030500010001000100'||chr(10)||
'430061034300610301000100010008000000fa';
    wwv_flow_api.g_varchar2_table(411) := '0200000000000000000000040000002d01040007000000fc020000ffffff000000040000002d01050008000000'||chr(10)||
'fa0200000';
    wwv_flow_api.g_varchar2_table(412) := '100000000000000040000002d01060007000000fc020100000000000000040000002d0107000c00000024030400010001000';
    wwv_flow_api.g_varchar2_table(413) := '1004300610343006103'||chr(10)||
'0100040000002d010400040000002d01050004000000f0010600040000002701ffff04000000f001';
    wwv_flow_api.g_varchar2_table(414) := '0200030000001e0007000000fc020000ffffff0000000400'||chr(10)||
'00002d0102000400000006010100040000002d0103006200000';
    wwv_flow_api.g_varchar2_table(415) := '03805020020000e0054003200560012005e001200600012006100130062001400630016006300'||chr(10)||
'180064001b0063001d0063';
    wwv_flow_api.g_varchar2_table(416) := '001f006200210061002300600023005f002400600024006000250061002600610027006100280062002900640032005e0032';
    wwv_flow_api.g_varchar2_table(417) := '005c00'||chr(10)||
'28005b0027005b0026005b0025005a002500590025005900320054003200540032005a001f005c001f005c001f005';
    wwv_flow_api.g_varchar2_table(418) := 'd001e005e001e005e001d005e001c005e00'||chr(10)||
'1a005e0019005d0019005c0018005a0018005a001f005a001f00040000002d01';
    wwv_flow_api.g_varchar2_table(419) := '04000400000006010100040000002d010500040000002d010200040000000601'||chr(10)||
'0100040000002d0103006a0000003805020';
    wwv_flow_api.g_varchar2_table(420) := '027000b00720029006900290069002a0069002c006a002d006b002d006b002d006c002d006c002c006d002b007100'||chr(10)||
'2c0071';
    wwv_flow_api.g_varchar2_table(421) := '002e0070002f006f0030006f0031006d0032006a00330068003200670031006600300065002d0064002a0064002600650024';
    wwv_flow_api.g_varchar2_table(422) := '006500210066001f006700'||chr(10)||
'1e0068001c0069001b006a001a006c001a006e001b006f001c0071001e0071002000720023007';
    wwv_flow_api.g_varchar2_table(423) := '200280072002900720029006d0024006d0022006d0021006c00'||chr(10)||
'20006b001f006b0020006a00210069002200690024006d00';
    wwv_flow_api.g_varchar2_table(424) := '24006d002400040000002d0104000400000006010100040000002d010500040000002d0102000400'||chr(10)||
'0000060101000400000';
    wwv_flow_api.g_varchar2_table(425) := '02d010300650000003805010030007c00290081002a0080002c007f002e007e0030007d0031007c0032007a0033007800320';
    wwv_flow_api.g_varchar2_table(426) := '077003200'||chr(10)||
'760031007500300074002e0074002c0073002a0073002600740023007400200076001d0076001c0077001b0079';
    wwv_flow_api.g_varchar2_table(427) := '001a007b001a007c001a007d001b007e001b00'||chr(10)||
'7f001c0080001d0080001f0080002000810022007c0023007c0022007c002';
    wwv_flow_api.g_varchar2_table(428) := '1007b0020007b0020007a0021007900220078002400780027007800290078002b00'||chr(10)||
'79002c007a002d007b002c007b002c00';
    wwv_flow_api.g_varchar2_table(429) := '7c002a007c002900040000002d0104000400000006010100040000002d010500040000002d0102000400000006010100'||chr(10)||
'040';
    wwv_flow_api.g_varchar2_table(430) := '000002d0103006c000000380502002000130082002600820024008300220084001f0085001e0086001c0087001b0088001a0';
    wwv_flow_api.g_varchar2_table(431) := '08a001a008b001a008d001b00'||chr(10)||
'8e001c008f001e008f002200900026008f0029008f002b008e002d008d002f008c0031008b';
    wwv_flow_api.g_varchar2_table(432) := '0032008a0032008800330087003200860032008500310084003000'||chr(10)||
'83002e0083002c0082002900820026008200260087002';
    wwv_flow_api.g_varchar2_table(433) := '6008700290087002b0088002c0089002c0089002c008a002b008b0029008b0028008b0026008b002400'||chr(10)||
'8b0022008a002100';
    wwv_flow_api.g_varchar2_table(434) := '890020008800210088002200870024008700260087002600040000002d0104000400000006010100040000002d0105000400';
    wwv_flow_api.g_varchar2_table(435) := '00002d010200'||chr(10)||
'0400000006010100040000002d0103002f00000038050100150092001b0097001b0096001f0097001c00980';
    wwv_flow_api.g_varchar2_table(436) := '01b0099001a0099001a009a001a009b001b009a00'||chr(10)||
'2200990021009900210098002100970023009700240096002500960028';
    wwv_flow_api.g_varchar2_table(437) := '0096002a00960032009100320092001b00040000002d01040004000000060101000400'||chr(10)||
'00002d010500040000002d0102000';
    wwv_flow_api.g_varchar2_table(438) := '400000006010100040000002d01030066000000380502001d001300aa001200a8003200a4003200a4002f00a3003000a200'||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(439) := '3200a1003200a00033009f0032009e0032009d0030009c002f009c002b009c0026009c0023009c0021009d001f009e001d00';
    wwv_flow_api.g_varchar2_table(440) := '9e001c009f001b00a0001a00a100'||chr(10)||
'1a00a2001a00a3001b00a4001c00a4001d00a5001200aa001200aa001200a4002600a40';
    wwv_flow_api.g_varchar2_table(441) := '02400a4002200a3002100a2002100a2002100a1002200a0002400a000'||chr(10)||
'2500a0002600a0002900a0002b00a1002c00a2002c';
    wwv_flow_api.g_varchar2_table(442) := '00a3002c00a3002b00a4002900a4002600a4002600040000002d0104000400000006010100040000002d01'||chr(10)||
'0500040000002';
    wwv_flow_api.g_varchar2_table(443) := 'd0102000400000006010100040000002d0103007f000000380501003d00aa002c00af002b00af002c00af002d00b0002d00b';
    wwv_flow_api.g_varchar2_table(444) := '0002e00b1002d00'||chr(10)||
'b2002d00b2002b00b2002b00b2002a00b1002a00b0002900ae002800ad002800ac002700ac002500ab00';
    wwv_flow_api.g_varchar2_table(445) := '2300ab002100ab001f00ac001d00ad001c00ae001b00'||chr(10)||
'af001a00b1001a00b3001a00b4001b00b5001c00b6001d00b6001e0';
    wwv_flow_api.g_varchar2_table(446) := '0b7002000b2002100b2002000b2002000b1001f00b1001f00b0001f00b0001f00af002100'||chr(10)||
'af002100b0002200b0002200b1';
    wwv_flow_api.g_varchar2_table(447) := '002300b3002300b5002400b6002500b6002700b6002900b7002a00b6002c00b6002e00b5003000b4003100b2003200b00033';
    wwv_flow_api.g_varchar2_table(448) := '00'||chr(10)||
'af003200ad003200ac003100ac003100ab002e00aa002c00040000002d0104000400000006010100040000002d0105000';
    wwv_flow_api.g_varchar2_table(449) := '40000002d0102000400000006010100'||chr(10)||
'040000002d0103008b000000380501004300c0002700c4002700c5002900c5002a00';
    wwv_flow_api.g_varchar2_table(450) := 'c5002b00c6002c00c6002c00c7002c00c8002c00c9002b00c9002a00c900'||chr(10)||
'2900c9002800c9002700c8002600c6002500c50';
    wwv_flow_api.g_varchar2_table(451) := '02400c4002300c3002200c2002100c1001e00c1001b00c1001800c2001600c3001400c4001300c6001200c800'||chr(10)||
'1100ca0011';
    wwv_flow_api.g_varchar2_table(452) := '00cb001200cc001300cd001400cd001500ce001700ce001900ce001b00ca001b00c9001a00c9001800c8001800c7001700c7';
    wwv_flow_api.g_varchar2_table(453) := '001700c6001800c600'||chr(10)||
'1a00c6001b00c6001c00c7001c00c9001d00ca001e00cb001e00cc001f00cd002100ce002300ce002';
    wwv_flow_api.g_varchar2_table(454) := '500ce002800ce002b00cd002d00cc003000ca003100c900'||chr(10)||
'3200c7003300c5003200c3003200c2003100c1002f00c0002c00';
    wwv_flow_api.g_varchar2_table(455) := 'c0002700040000002d0104000400000006010100040000002d010500040000002d0102000400'||chr(10)||
'000006010100040000002d0';
    wwv_flow_api.g_varchar2_table(456) := '103006a0000003805020027000b00dd002900d4002900d4002a00d5002c00d5002d00d6002d00d7002d00d8002d00d8002c0';
    wwv_flow_api.g_varchar2_table(457) := '0d800'||chr(10)||
'2b00dd002c00dc002e00dc002f00db003000da003100d8003200d6003300d4003200d2003100d1003000d0002d00d0';
    wwv_flow_api.g_varchar2_table(458) := '002a00d0002600d0002400d1002100d100'||chr(10)||
'1f00d2001e00d3001c00d4001b00d6001a00d7001a00d9001b00db001c00dc001';
    wwv_flow_api.g_varchar2_table(459) := 'e00dd002000dd002300dd002800dd002900dd002900d9002400d9002200d800'||chr(10)||
'2100d8002000d7001f00d6002000d5002100';
    wwv_flow_api.g_varchar2_table(460) := 'd5002200d5002400d9002400d9002400040000002d0104000400000006010100040000002d010500040000002d01'||chr(10)||
'0200040';
    wwv_flow_api.g_varchar2_table(461) := '0000006010100040000002d0103002f000000380501001500e0001b00e4001b00e4001f00e5001c00e5001b00e6001a00e70';
    wwv_flow_api.g_varchar2_table(462) := '01a00e8001a00e9001b00'||chr(10)||
'e7002200e7002100e6002100e5002100e5002300e4002400e4002500e4002800e4002a00e30032';
    wwv_flow_api.g_varchar2_table(463) := '00df003200e0001b00040000002d0104000400000006010100'||chr(10)||
'040000002d010500040000002d01020004000000060101000';
    wwv_flow_api.g_varchar2_table(464) := '40000002d01030015000000380501000800ea001b00ef001b00f0002900f3001b00f8001b00f200'||chr(10)||
'3200ee003200ea001b00';
    wwv_flow_api.g_varchar2_table(465) := '040000002d0104000400000006010100040000002d010500040000002d0102000400000006010100040000002d0103001e00';
    wwv_flow_api.g_varchar2_table(466) := '00003805'||chr(10)||
'020006000600fa001200fe001200fe001800f9001800fa001200fa001200f9001b00fe001b00fc003200f800320';
    wwv_flow_api.g_varchar2_table(467) := '0f9001b00f9001b00040000002d0104000400'||chr(10)||
'000006010100040000002d010500040000002d010200040000000601010004';
    wwv_flow_api.g_varchar2_table(468) := '0000002d01030065000000380501003000080129000c012a000c012c000b012e00'||chr(10)||
'0a0130000901310007013200060133000';
    wwv_flow_api.g_varchar2_table(469) := '401320003013200020131000101300000012e00ff002c00ff002a00ff002600000123000001200002011d0002011c00'||chr(10)||
'0301';
    wwv_flow_api.g_varchar2_table(470) := '1b0005011a0007011a0008011a0009011b000a011b000b011c000c011d000c011f000c0120000d0122000801230008012200';
    wwv_flow_api.g_varchar2_table(471) := '080121000701200006012000'||chr(10)||
'050121000501220004012400040127000401290004012b0005012c0006012d0007012c00070';
    wwv_flow_api.g_varchar2_table(472) := '12c0008012a0008012900040000002d0104000400000006010100'||chr(10)||
'040000002d010500040000002d01020004000000060101';
    wwv_flow_api.g_varchar2_table(473) := '00040000002d0103006a0000003805020027000b001c0129001301290013012a0013012c0014012d00'||chr(10)||
'15012d0015012d001';
    wwv_flow_api.g_varchar2_table(474) := '6012d0016012c0017012b001b012c001a012e001a012f0019013000180131001701320014013300120132001101310010013';
    wwv_flow_api.g_varchar2_table(475) := '0000f012d00'||chr(10)||
'0e012a000e0126000e0124000f01210010011f0010011e0011011c0013011b0014011a0015011a0018011b00';
    wwv_flow_api.g_varchar2_table(476) := '19011c001a011e001b0120001c0123001c012800'||chr(10)||
'1c0129001c0129001701240017012200170121001601200015011f00140';
    wwv_flow_api.g_varchar2_table(477) := '120001301210013012200130124001701240017012400040000002d01040004000000'||chr(10)||
'06010100040000002d010500080000';
    wwv_flow_api.g_varchar2_table(478) := '00fa0200000100000000000000040000002d010600040000002d010700440000002503200054003200560012005e001200'||chr(10)||
'6';
    wwv_flow_api.g_varchar2_table(479) := '00012006100130062001400630016006300180064001b0063001d0063001f006200210061002300600023005f00240060002';
    wwv_flow_api.g_varchar2_table(480) := '400600025006100260061002700'||chr(10)||
'6100280062002900640032005e0032005c0028005b0027005b0026005b0025005a002500';
    wwv_flow_api.g_varchar2_table(481) := '590025005900320054003200540032002000000025030e005a001f00'||chr(10)||
'5c001f005c001f005d001e005e001e005e001d005e0';
    wwv_flow_api.g_varchar2_table(482) := '01c005e001a005e0019005d0019005c0018005a0018005a001f005a001f00040000002d01040004000000'||chr(10)||
'2d010500040000';
    wwv_flow_api.g_varchar2_table(483) := '00f001060008000000fa0200000100000000000000040000002d010600040000002d01070052000000250327007200290069';
    wwv_flow_api.g_varchar2_table(484) := '00290069002a00'||chr(10)||
'69002c006a002d006b002d006b002d006c002d006c002c006d002b0071002c0071002e0070002f006f003';
    wwv_flow_api.g_varchar2_table(485) := '0006f0031006d0032006a0033006800320067003100'||chr(10)||
'6600300065002d0064002a0064002600650024006500210066001f00';
    wwv_flow_api.g_varchar2_table(486) := '67001e0068001c0069001b006a001a006c001a006e001b006f001c0071001e0071002000'||chr(10)||
'720023007200280072002900720';
    wwv_flow_api.g_varchar2_table(487) := '029001a00000025030b006d0024006d0022006d0021006c0020006b001f006b0020006a00210069002200690024006d00240';
    wwv_flow_api.g_varchar2_table(488) := '0'||chr(10)||
'6d002400040000002d010400040000002d01050004000000f001060008000000fa0200000100000000000000040000002d';
    wwv_flow_api.g_varchar2_table(489) := '010600040000002d01070064000000'||chr(10)||
'250330007c00290081002a0080002c007f002e007e0030007d0031007c0032007a003';
    wwv_flow_api.g_varchar2_table(490) := '3007800320077003200760031007500300074002e0074002c0073002a00'||chr(10)||
'73002600740023007400200076001d0076001c00';
    wwv_flow_api.g_varchar2_table(491) := '77001b0079001a007b001a007c001a007d001b007e001b007f001c0080001d0080001f008000200081002200'||chr(10)||
'7c0023007c0';
    wwv_flow_api.g_varchar2_table(492) := '022007c0021007b0020007b0020007a0021007900220078002400780027007800290078002b0079002c007a002d007b002c0';
    wwv_flow_api.g_varchar2_table(493) := '07b002c007c002a00'||chr(10)||
'7c002900040000002d010400040000002d01050004000000f001060008000000fa0200000100000000';
    wwv_flow_api.g_varchar2_table(494) := '000000040000002d010600040000002d01070044000000'||chr(10)||
'2503200082002600820024008300220084001f0085001e0086001';
    wwv_flow_api.g_varchar2_table(495) := 'c0087001b0088001a008a001a008b001a008d001b008e001c008f001e008f00220090002600'||chr(10)||
'8f0029008f002b008e002d00';
    wwv_flow_api.g_varchar2_table(496) := '8d002f008c0031008b0032008a003200880033008700320086003200850031008400300083002e0083002c00820029008200';
    wwv_flow_api.g_varchar2_table(497) := '2600'||chr(10)||
'820026002a00000025031300870026008700290087002b0088002c0089002c0089002c008a002b008b0029008b00280';
    wwv_flow_api.g_varchar2_table(498) := '08b0026008b0024008b0022008a002100'||chr(10)||
'890020008800210088002200870024008700260087002600040000002d01040004';
    wwv_flow_api.g_varchar2_table(499) := '0000002d01050004000000f001060008000000fa0200000100000000000000'||chr(10)||
'040000002d010600040000002d0107002e000';
    wwv_flow_api.g_varchar2_table(500) := '0002503150092001b0097001b0096001f0097001c0098001b0099001a0099001a009a001a009b001b009a002200'||chr(10)||
'99002100';
 
end;
/

 
begin
 
    wwv_flow_api.g_varchar2_table(501) := '99002100980021009700230097002400960025009600280096002a00960032009100320092001b00040000002d0104000400';
    wwv_flow_api.g_varchar2_table(502) := '00002d01050004000000'||chr(10)||
'f001060008000000fa0200000100000000000000040000002d010600040000002d0107003e00000';
    wwv_flow_api.g_varchar2_table(503) := '025031d00aa001200a8003200a4003200a4002f00a3003000'||chr(10)||
'a2003200a1003200a00033009f0032009e0032009d0030009c';
    wwv_flow_api.g_varchar2_table(504) := '002f009c002b009c0026009c0023009c0021009d001f009e001d009e001c009f001b00a0001a00'||chr(10)||
'a1001a00a2001a00a3001';
    wwv_flow_api.g_varchar2_table(505) := 'b00a4001c00a4001d00a5001200aa001200aa0012002a00000025031300a4002600a4002400a4002200a3002100a2002100a';
    wwv_flow_api.g_varchar2_table(506) := '2002100'||chr(10)||
'a1002200a0002400a0002500a0002600a0002900a0002b00a1002c00a2002c00a3002c00a3002b00a4002900a400';
    wwv_flow_api.g_varchar2_table(507) := '2600a4002600040000002d01040004000000'||chr(10)||
'2d01050004000000f001060008000000fa02000001000000000000000400000';
    wwv_flow_api.g_varchar2_table(508) := '02d010600040000002d0107007e00000025033d00aa002c00af002b00af002c00'||chr(10)||
'af002d00b0002d00b0002e00b1002d00b2';
    wwv_flow_api.g_varchar2_table(509) := '002d00b2002b00b2002b00b2002a00b1002a00b0002900ae002800ad002800ac002700ac002500ab002300ab002100'||chr(10)||
'ab001';
    wwv_flow_api.g_varchar2_table(510) := 'f00ac001d00ad001c00ae001b00af001a00b1001a00b3001a00b4001b00b5001c00b6001d00b6001e00b7002000b2002100b';
    wwv_flow_api.g_varchar2_table(511) := '2002000b2002000b1001f00'||chr(10)||
'b1001f00b0001f00b0001f00af002100af002100b0002200b0002200b1002300b3002300b500';
    wwv_flow_api.g_varchar2_table(512) := '2400b6002500b6002700b6002900b7002a00b6002c00b6002e00'||chr(10)||
'b5003000b4003100b2003200b0003300af003200ad00320';
    wwv_flow_api.g_varchar2_table(513) := '0ac003100ac003100ab002e00aa002c00040000002d010400040000002d01050004000000f0010600'||chr(10)||
'08000000fa02000001';
    wwv_flow_api.g_varchar2_table(514) := '00000000000000040000002d010600040000002d0107008a00000025034300c0002700c4002700c5002900c5002a00c5002b';
    wwv_flow_api.g_varchar2_table(515) := '00c6002c00'||chr(10)||
'c6002c00c7002c00c8002c00c9002b00c9002a00c9002900c9002800c9002700c8002600c6002500c5002400c';
    wwv_flow_api.g_varchar2_table(516) := '4002300c3002200c2002100c1001e00c1001b00'||chr(10)||
'c1001800c2001600c3001400c4001300c6001200c8001100ca001100cb00';
    wwv_flow_api.g_varchar2_table(517) := '1200cc001300cd001400cd001500ce001700ce001900ce001b00ca001b00c9001a00'||chr(10)||
'c9001800c8001800c7001700c700170';
    wwv_flow_api.g_varchar2_table(518) := '0c6001800c6001a00c6001b00c6001c00c7001c00c9001d00ca001e00cb001e00cc001f00cd002100ce002300ce002500'||chr(10)||
'ce';
    wwv_flow_api.g_varchar2_table(519) := '002800ce002b00cd002d00cc003000ca003100c9003200c7003300c5003200c3003200c2003100c1002f00c0002c00c00027';
    wwv_flow_api.g_varchar2_table(520) := '00040000002d01040004000000'||chr(10)||
'2d01050004000000f001060008000000fa0200000100000000000000040000002d0106000';
    wwv_flow_api.g_varchar2_table(521) := '40000002d0107005200000025032700dd002900d4002900d4002a00'||chr(10)||
'd5002c00d5002d00d6002d00d7002d00d8002d00d800';
    wwv_flow_api.g_varchar2_table(522) := '2c00d8002b00dd002c00dc002e00dc002f00db003000da003100d8003200d6003300d4003200d2003100'||chr(10)||
'd1003000d0002d0';
    wwv_flow_api.g_varchar2_table(523) := '0d0002a00d0002600d0002400d1002100d1001f00d2001e00d3001c00d4001b00d6001a00d7001a00d9001b00db001c00dc0';
    wwv_flow_api.g_varchar2_table(524) := '01e00dd002000'||chr(10)||
'dd002300dd002800dd002900dd0029001a00000025030b00d9002400d9002200d8002100d8002000d7001f';
    wwv_flow_api.g_varchar2_table(525) := '00d6002000d5002100d5002200d5002400d9002400'||chr(10)||
'd9002400040000002d010400040000002d01050004000000f00106000';
    wwv_flow_api.g_varchar2_table(526) := '8000000fa0200000100000000000000040000002d010600040000002d0107002e000000'||chr(10)||
'25031500e0001b00e4001b00e400';
    wwv_flow_api.g_varchar2_table(527) := '1f00e5001c00e5001b00e6001a00e7001a00e8001a00e9001b00e7002200e7002100e6002100e5002100e5002300e4002400';
    wwv_flow_api.g_varchar2_table(528) := ''||chr(10)||
'e4002500e4002800e4002a00e3003200df003200e0001b00040000002d010400040000002d01050004000000f0010600080';
    wwv_flow_api.g_varchar2_table(529) := '00000fa0200000100000000000000'||chr(10)||
'040000002d010600040000002d0107001400000025030800ea001b00ef001b00f00029';
    wwv_flow_api.g_varchar2_table(530) := '00f3001b00f8001b00f2003200ee003200ea001b00040000002d010400'||chr(10)||
'040000002d01050004000000f001060008000000f';
    wwv_flow_api.g_varchar2_table(531) := 'a0200000100000000000000040000002d010600040000002d0107001000000025030600fa001200fe001200'||chr(10)||
'fe001800f900';
    wwv_flow_api.g_varchar2_table(532) := '1800fa001200fa0012001000000025030600f9001b00fe001b00fc003200f8003200f9001b00f9001b00040000002d010400';
    wwv_flow_api.g_varchar2_table(533) := '040000002d010500'||chr(10)||
'04000000f001060008000000fa0200000100000000000000040000002d010600040000002d010700640';
    wwv_flow_api.g_varchar2_table(534) := '0000025033000080129000c012a000c012c000b012e00'||chr(10)||
'0a0130000901310007013200060133000401320003013200020131';
    wwv_flow_api.g_varchar2_table(535) := '000101300000012e00ff002c00ff002a00ff002600000123000001200002011d0002011c00'||chr(10)||
'03011b0005011a0007011a000';
    wwv_flow_api.g_varchar2_table(536) := '8011a0009011b000a011b000b011c000c011d000c011f000c0120000d0122000801230008012200080121000701200006012';
    wwv_flow_api.g_varchar2_table(537) := '000'||chr(10)||
'050121000501220004012400040127000401290004012b0005012c0006012d0007012c0007012c0008012a0008012900';
    wwv_flow_api.g_varchar2_table(538) := '040000002d010400040000002d010500'||chr(10)||
'04000000f001060008000000fa0200000100000000000000040000002d010600040';
    wwv_flow_api.g_varchar2_table(539) := '000002d01070052000000250327001c0129001301290013012a0013012c00'||chr(10)||
'14012d0015012d0015012d0016012d0016012c';
    wwv_flow_api.g_varchar2_table(540) := '0017012b001b012c001a012e001a012f0019013000180131001701320014013300120132001101310010013000'||chr(10)||
'0f012d000';
    wwv_flow_api.g_varchar2_table(541) := 'e012a000e0126000e0124000f01210010011f0010011e0011011c0013011b0014011a0015011a0018011b0019011c001a011';
    wwv_flow_api.g_varchar2_table(542) := 'e001b0120001c012300'||chr(10)||
'1c0128001c0129001c0129001a00000025030b001701240017012200170121001601200015011f00';
    wwv_flow_api.g_varchar2_table(543) := '140120001301210013012200130124001701240017012400040000002d010400040000002d01050004000000f00106000400';
    wwv_flow_api.g_varchar2_table(544) := '00002701ffff040000002d010000030000000000}\par}}}{\rtlch\fcs1 \af0\afs28 '||chr(10)||
'\ltrch\fcs0 \fs28\cf8\lang2';
    wwv_flow_api.g_varchar2_table(545) := '057\langfe1033\langnp2057\insrsid4022835\charrsid4022835 {\pict{\*\picprop\defshp\shplid1027{\sp{\sn';
    wwv_flow_api.g_varchar2_table(546) := ' shapeType}{\sv 75}}{\sp{\sn fFlipH}{\sv 0}}'||chr(10)||
'{\sp{\sn fFlipV}{\sv 0}}{\sp{\sn fPseudoInline}{\sv 1}}';
    wwv_flow_api.g_varchar2_table(547) := '{\sp{\sn fLayoutInCell}{\sv 1}}{\sp{\sn fLockPosition}{\sv 1}}{\sp{\sn fLockRotation}{\sv 1}}}\picsc';
    wwv_flow_api.g_varchar2_table(548) := 'alex130\picscaley16\piccropl0\piccropr0\piccropt-4319\piccropb4319'||chr(10)||
'\picw12700\pich7620\picwgoal7200\';
    wwv_flow_api.g_varchar2_table(549) := 'pichgoal4320\wmetafile8\bliptag-1024776911\blipupi133{\*\blipuid c2eb2531d0257a019546f9551720ab09}'||chr(10)||
'0';
    wwv_flow_api.g_varchar2_table(550) := '100090000030202000002008a01000000008a01000026060f000a03574d46430100000000000100f5a90000000001000000e';
    wwv_flow_api.g_varchar2_table(551) := '802000000000000e80200000100'||chr(10)||
'00006c00000000000000000000002c0000007100000000000000000000007d400000f504';
    wwv_flow_api.g_varchar2_table(552) := '000020454d4600000100e80200000e00000002000000000000000000'||chr(10)||
'000000000000971200009e1a0000c90000002001000';
    wwv_flow_api.g_varchar2_table(553) := '0000000000000000000000000f8120300cb660400160000000c000000180000000a000000100000000000'||chr(10)||
'00000000000009';
    wwv_flow_api.g_varchar2_table(554) := '000000100000003c0f00002c010000250000000c0000000e000080120000000c000000010000005200000070010000010000';
    wwv_flow_api.g_varchar2_table(555) := '009cffffff0000'||chr(10)||
'00000000000000000000900100000000000004400012540069006d006500730020004e006500770020005';
    wwv_flow_api.g_varchar2_table(556) := '2006f006d0061006e00000000000000000000000000'||chr(10)||
'00000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(557) := '000000000000000000000000000000000000000000000000000000000000000000000000'||chr(10)||
'000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(558) := '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(559) := '0'||chr(10)||
'00000000000000000000cb30093000000000040000000000ae300831093000000000471690010000020206030504050203';
    wwv_flow_api.g_varchar2_table(560) := '04877a002000000080080000000000'||chr(10)||
'0000ff01000000000000540069006d00650073002000000065007700200052006f006';
    wwv_flow_api.g_varchar2_table(561) := 'd0061006e00000000000000bd2d093050bbae3000331400010000000000'||chr(10)||
'00003c441100aab402303c4411004c3eaf305444';
    wwv_flow_api.g_varchar2_table(562) := '11006476000800000000250000000c00000001000000180000000c0000000000000254000000540000000000'||chr(10)||
'00000000000';
    wwv_flow_api.g_varchar2_table(563) := '02c00000071000000010000008a2787403f408740000000005a000000010000004c0000000400000000000000000000003c0';
    wwv_flow_api.g_varchar2_table(564) := 'f00002c0100005000'||chr(10)||
'0000200000002d00000046000000280000001c0000004744494302000000ffffffffffffffff3d0f00';
    wwv_flow_api.g_varchar2_table(565) := '002d010000000000004600000014000000080000004744'||chr(10)||
'494303000000250000000c0000000e0000800e000000140000000';
    wwv_flow_api.g_varchar2_table(566) := '000000010000000140000000400000003010800050000000b0200000000050000000c024300'||chr(10)||
'6303040000002e0118001c00';
    wwv_flow_api.g_varchar2_table(567) := '0000fb020400020000000000bc02000000000102022253797374656d00000000000000000000000000000000000000000000';
    wwv_flow_api.g_varchar2_table(568) := '0000'||chr(10)||
'0000040000002d01000004000000020101001c000000fb02eaff0000000000009001000000000440001254696d65732';
    wwv_flow_api.g_varchar2_table(569) := '04e657720526f6d616e00000000000000'||chr(10)||
'00000000000000000000040000002d010100050000000902000000020d00000032';
    wwv_flow_api.g_varchar2_table(570) := '0a14000000010004000000000061034300200c0a00040000002d010000030000000000}}}}\sectd \linex0\headery708\';
    wwv_flow_api.g_varchar2_table(571) := 'footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj '||chr(10)||
'\sectd \ltrsect\';
    wwv_flow_api.g_varchar2_table(572) := 'linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj';
    wwv_flow_api.g_varchar2_table(573) := ' {\*\pnseclvl1\pnucrm\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl2\pnucltr\pnstart1\pninden';
    wwv_flow_api.g_varchar2_table(574) := 't720\pnhang {\pntxta .}}{\*\pnseclvl3'||chr(10)||
'\pndec\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl4\p';
    wwv_flow_api.g_varchar2_table(575) := 'nlcltr\pnstart1\pnindent720\pnhang {\pntxta )}}{\*\pnseclvl5\pndec\pnstart1\pnindent720\pnhang {\pnt';
    wwv_flow_api.g_varchar2_table(576) := 'xtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}'||chr(10)||
'{\*\pnse';
    wwv_flow_api.g_varchar2_table(577) := 'clvl7\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl8\pnlcltr\pnstart1\pnind';
    wwv_flow_api.g_varchar2_table(578) := 'ent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (}{\p';
    wwv_flow_api.g_varchar2_table(579) := 'ntxta )}}{\rtlch\fcs1 \af0\afs28 \ltrch\fcs0 '||chr(10)||
'\fs28\lang2057\langfe1033\langnp2057\insrsid4022835 '||chr(10)||
'\';
    wwv_flow_api.g_varchar2_table(580) := 'par }\pard\plain \ltrpar\qc \li0\ri0\sa200\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\';
    wwv_flow_api.g_varchar2_table(581) := 'rin0\lin0\itap0\pararsid6291715 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\lang';
    wwv_flow_api.g_varchar2_table(582) := 'fe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 '||chr(10)||
'\af0\afs28 \ltrch\fcs0 \fs28\lang2057\langfe1033\';
    wwv_flow_api.g_varchar2_table(583) := 'langnp2057\insrsid919359 New Transport & H}{\rtlch\fcs1 \af0\afs28 \ltrch\fcs0 \fs28\lang2057\langfe';
    wwv_flow_api.g_varchar2_table(584) := '1033\langnp2057\insrsid16665483\charrsid6291715 ighways }{\rtlch\fcs1 \af0\afs28 \ltrch\fcs0 '||chr(10)||
'\fs28\';
    wwv_flow_api.g_varchar2_table(585) := 'lang2057\langfe1033\langnp2057\insrsid919359 F}{\rtlch\fcs1 \af0\afs28 \ltrch\fcs0 \fs28\lang2057\la';
    wwv_flow_api.g_varchar2_table(586) := 'ngfe1033\langnp2057\insrsid16665483\charrsid6291715 ile Opened'||chr(10)||
'\par \ltrrow}\trowd \irow0\irowband0\';
    wwv_flow_api.g_varchar2_table(587) := 'ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrd';
    wwv_flow_api.g_varchar2_table(588) := 'rb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdr';
    wwv_flow_api.g_varchar2_table(589) := 's\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3';
    wwv_flow_api.g_varchar2_table(590) := '\trpaddft3\trpaddfb3\trpaddfr3\tblrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvert';
    wwv_flow_api.g_varchar2_table(591) := 'alt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cl';
    wwv_flow_api.g_varchar2_table(592) := 'brdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbr';
    wwv_flow_api.g_varchar2_table(593) := 'drt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brd';
    wwv_flow_api.g_varchar2_table(594) := 'rs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\pard\plain \ltrpar\ql ';
    wwv_flow_api.g_varchar2_table(595) := '\li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 ';
    wwv_flow_api.g_varchar2_table(596) := '\af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlc';
    wwv_flow_api.g_varchar2_table(597) := 'h\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 \cell }\pard \ltrpar'||chr(10)||
'\ql \li';
    wwv_flow_api.g_varchar2_table(598) := '0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid16665483\yts1';
    wwv_flow_api.g_varchar2_table(599) := '5 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 Reference Number:{\*';
    wwv_flow_api.g_varchar2_table(600) := '\bkmkstart Text1} {\*\bkmkend Text1}}'||chr(10)||
'{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \ins';
    wwv_flow_api.g_varchar2_table(601) := 'rsid7427681\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid7427681\charrsid7427681 {';
    wwv_flow_api.g_varchar2_table(602) := '\*\datafield '||chr(10)||
'0001000000000000055465787431000a5245465f4e554d42455200000000000e3c3f5245465f4e554d4245';
    wwv_flow_api.g_varchar2_table(603) := '523f3e0000000000}{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext REF_NUMBE';
    wwv_flow_api.g_varchar2_table(604) := 'R}{\*\ffstattext <?REF_NUMBER?>}}}}}{\fldrslt {\rtlch\fcs1 \af0 '||chr(10)||
'\ltrch\fcs0 \lang1024\langfe1024\no';
    wwv_flow_api.g_varchar2_table(605) := 'proof\insrsid7427681\charrsid7427681 REF_NUMBER}}}\sectd \linex0\headery708\footery708\colsx708\endn';
    wwv_flow_api.g_varchar2_table(606) := 'here\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\';
    wwv_flow_api.g_varchar2_table(607) := 'langfe1033\langnp2057\insrsid16665483 \cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdef';
    wwv_flow_api.g_varchar2_table(608) := 'ault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37';
    wwv_flow_api.g_varchar2_table(609) := '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\lang';
    wwv_flow_api.g_varchar2_table(610) := 'fe1033\langnp2057\insrsid16665483 \trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\b';
    wwv_flow_api.g_varchar2_table(611) := 'rdrs\brdrw10\brdrcf1 \trbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\b';
    wwv_flow_api.g_varchar2_table(612) := 'rdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidt';
    wwv_flow_api.g_varchar2_table(613) := 'hB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid166';
    wwv_flow_api.g_varchar2_table(614) := '65483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdr';
    wwv_flow_api.g_varchar2_table(615) := 'l\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clf';
    wwv_flow_api.g_varchar2_table(616) := 'tsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\';
    wwv_flow_api.g_varchar2_table(617) := 'brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\clftsWidth3';
    wwv_flow_api.g_varchar2_table(618) := '\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wra';
    wwv_flow_api.g_varchar2_table(619) := 'pdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid16665483\yts15 \rtlch\fcs1 \af0\afs22\';
    wwv_flow_api.g_varchar2_table(620) := 'alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0';
    wwv_flow_api.g_varchar2_table(621) := ' \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 Planning Authority: }{\field\flddirty{\';
    wwv_flow_api.g_varchar2_table(622) := '*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid7427681\charrsid7427681 '||chr(10)||
'FORMTEXT}{\rtlch\fcs1 \af0 ';
    wwv_flow_api.g_varchar2_table(623) := '\ltrch\fcs0 \insrsid7427681\charrsid7427681 {\*\datafield 00010000000000000554657874310012504c414e4e';
    wwv_flow_api.g_varchar2_table(624) := '494e475f415554484f524954590000000000163c3f504c414e4e494e475f415554484f524954593f3e0000000000}'||chr(10)||
'{\*\fo';
    wwv_flow_api.g_varchar2_table(625) := 'rmfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext PLANNING_AUTHORITY}{\*\ffstattex';
    wwv_flow_api.g_varchar2_table(626) := 't <?PLANNING_AUTHORITY?>}}}}}{\fldrslt {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang1024\langfe1024\noproof\in';
    wwv_flow_api.g_varchar2_table(627) := 'srsid7427681\charrsid7427681 PLANNING_AUTHORITY}'||chr(10)||
'}}\sectd \linex0\headery708\footery708\colsx708\end';
    wwv_flow_api.g_varchar2_table(628) := 'nhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\';
    wwv_flow_api.g_varchar2_table(629) := 'langfe1033\langnp2057\insrsid16665483 \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapde';
    wwv_flow_api.g_varchar2_table(630) := 'fault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap2\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltr';
    wwv_flow_api.g_varchar2_table(631) := 'ch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\';
    wwv_flow_api.g_varchar2_table(632) := 'b\lang2057\langfe1033\langnp2057\insrsid15625051 Files attached or Related}{\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(633) := 'fcs0 \lang2057\langfe1033\langnp2057\insrsid15625051\charrsid15625051 \nestcell{\nonesttables'||chr(10)||
'\par }';
    wwv_flow_api.g_varchar2_table(634) := '}\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0';
    wwv_flow_api.g_varchar2_table(635) := '\lin0\itap2 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1';
    wwv_flow_api.g_varchar2_table(636) := '033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid15625051 {\*\';
    wwv_flow_api.g_varchar2_table(637) := 'nesttableprops\trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft5\trhdr\trbrdrt\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(638) := 'cf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\t';
    wwv_flow_api.g_varchar2_table(639) := 'rbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\';
    wwv_flow_api.g_varchar2_table(640) := 'trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15625051\tbllkhdrrow';
    wwv_flow_api.g_varchar2_table(641) := 's\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(642) := '1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \clc';
    wwv_flow_api.g_varchar2_table(643) := 'bpat17\cltxlrtb\clftsWidth3\clwWidth4557\clcbpatraw17 \cellx4562\nestrow}{\nonesttables'||chr(10)||
'\par }}\pard';
    wwv_flow_api.g_varchar2_table(644) := '\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\';
    wwv_flow_api.g_varchar2_table(645) := 'itap2\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1';
    wwv_flow_api.g_varchar2_table(646) := '033\langfenp1033 {\*\bkmkstart Text2}'||chr(10)||
'{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9';
    wwv_flow_api.g_varchar2_table(647) := '\lang2057\langfe1033\langnp2057\insrsid15625051\charrsid15625051  FORMTEXT }{\rtlch\fcs1 \af0 \ltrch';
    wwv_flow_api.g_varchar2_table(648) := '\fcs0 \cf9\lang2057\langfe1033\langnp2057\insrsid7225007\charrsid15625051 {\*\datafield '||chr(10)||
'80010000000';
    wwv_flow_api.g_varchar2_table(649) := '00000055465787432000246200000000000183c3f666f722d656163683a524f57534554325f524f573f3e0000000000}{\*\';
    wwv_flow_api.g_varchar2_table(650) := 'formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text2}{\*\ffdeftext F }{\*\ffstattext <?';
    wwv_flow_api.g_varchar2_table(651) := 'for-each:ROWSET2_ROW?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof';
    wwv_flow_api.g_varchar2_table(652) := '\langnp2057\insrsid15625051\charrsid15625051 F }}}\sectd \linex0\headery708\footery708\colsx708\endn';
    wwv_flow_api.g_varchar2_table(653) := 'here\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\*\bkmkstart Text3}'||chr(10)||
'{\*\bkmkend Text2}{\';
    wwv_flow_api.g_varchar2_table(654) := 'field\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid15625';
    wwv_flow_api.g_varchar2_table(655) := '051\charrsid15625051  FORMTEXT }{\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsi';
    wwv_flow_api.g_varchar2_table(656) := 'd7225007\charrsid15625051 '||chr(10)||
'{\*\datafield 80010000000000000554657874330008444f435f46494c4500000000000';
    wwv_flow_api.g_varchar2_table(657) := 'c3c3f444f435f46494c453f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname ';
    wwv_flow_api.g_varchar2_table(658) := 'Text3}{\*\ffdeftext DOC_FILE}{\*\ffstattext <?DOC_FILE?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs';
    wwv_flow_api.g_varchar2_table(659) := '0 \lang1024\langfe1024\noproof\langnp2057\insrsid15625051\charrsid15625051 DOC_FILE}}}\sectd \linex0';
    wwv_flow_api.g_varchar2_table(660) := '\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\*\b';
    wwv_flow_api.g_varchar2_table(661) := 'kmkstart Text4}'||chr(10)||
'{\*\bkmkend Text3}{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\lan';
    wwv_flow_api.g_varchar2_table(662) := 'g2057\langfe1033\langnp2057\insrsid15625051\charrsid15625051  FORMTEXT }{\rtlch\fcs1 \af0 \ltrch\fcs';
    wwv_flow_api.g_varchar2_table(663) := '0 \cf9\lang2057\langfe1033\langnp2057\insrsid7225007\charrsid15625051 '||chr(10)||
'{\*\datafield 800100000000000';
    wwv_flow_api.g_varchar2_table(664) := '0055465787434000220450000000000103c3f656e6420666f722d656163683f3e0000000000}{\*\formfield{\fftype0\f';
    wwv_flow_api.g_varchar2_table(665) := 'fownhelp\ffownstat\fftypetxt0{\*\ffname Text4}{\*\ffdeftext  E}{\*\ffstattext <?end for-each?>}}}}}{';
    wwv_flow_api.g_varchar2_table(666) := '\fldrslt {\rtlch\fcs1 '||chr(10)||
'\af0 \ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\langnp2057\insrsid15625051\';
    wwv_flow_api.g_varchar2_table(667) := 'charrsid15625051  E}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdef';
    wwv_flow_api.g_varchar2_table(668) := 'aultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsi';
    wwv_flow_api.g_varchar2_table(669) := 'd15625051 {\*\bkmkend Text4}\nestcell{\nonesttables'||chr(10)||
'\par }}\pard\plain \ltrpar\ql \li0\ri0\widctlpar';
    wwv_flow_api.g_varchar2_table(670) := '\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap2 \rtlch\fcs1 \af0\afs22\alang10';
    wwv_flow_api.g_varchar2_table(671) := '25 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(672) := 'fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid15625051 {\*\nesttableprops\trowd \irow1\irowband1\last';
    wwv_flow_api.g_varchar2_table(673) := 'row \ltrrow\ts15\trgaph108\trleft5\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trb';
    wwv_flow_api.g_varchar2_table(674) := 'rdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\b';
    wwv_flow_api.g_varchar2_table(675) := 'rdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpadd';
    wwv_flow_api.g_varchar2_table(676) := 'fl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15625051\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastco';
    wwv_flow_api.g_varchar2_table(677) := 'l\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbr';
    wwv_flow_api.g_varchar2_table(678) := 'drb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4557\clshdraw';
    wwv_flow_api.g_varchar2_table(679) := 'nil \cellx4562\nestrow}{\nonesttables'||chr(10)||
'\par }\ltrrow}\trowd \irow1\irowband1\ltrrow\ts15\trgaph108\tr';
    wwv_flow_api.g_varchar2_table(680) := 'left-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1';
    wwv_flow_api.g_varchar2_table(681) := ' \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trft';
    wwv_flow_api.g_varchar2_table(682) := 'sWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trp';
    wwv_flow_api.g_varchar2_table(683) := 'addfr3\tblrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(684) := '0\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(685) := 'cf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(686) := '1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\clt';
    wwv_flow_api.g_varchar2_table(687) := 'xlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl';
    wwv_flow_api.g_varchar2_table(688) := '\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \lt';
    wwv_flow_api.g_varchar2_table(689) := 'rch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 ';
    wwv_flow_api.g_varchar2_table(690) := '\lang2057\langfe1033\langnp2057\insrsid7427681 \cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intb';
    wwv_flow_api.g_varchar2_table(691) := 'l\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 '||chr(10)||
'\rtlch\fcs1 \af0\afs22\alang1025 \ltrch\';
    wwv_flow_api.g_varchar2_table(692) := 'fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang';
    wwv_flow_api.g_varchar2_table(693) := '2057\langfe1033\langnp2057\insrsid16665483 \trowd \irow1\irowband1\ltrrow\ts15\trgaph108\trleft-108\';
    wwv_flow_api.g_varchar2_table(694) := 'trbrdrt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdr';
    wwv_flow_api.g_varchar2_table(695) := 'r\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\';
    wwv_flow_api.g_varchar2_table(696) := 'trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\t';
    wwv_flow_api.g_varchar2_table(697) := 'blrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(698) := '1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \clt';
    wwv_flow_api.g_varchar2_table(699) := 'xlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrd';
    wwv_flow_api.g_varchar2_table(700) := 'rl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\cl';
    wwv_flow_api.g_varchar2_table(701) := 'ftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar\ql \li0\ri0\widctlpar\';
    wwv_flow_api.g_varchar2_table(702) := 'intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang102';
    wwv_flow_api.g_varchar2_table(703) := '5 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(704) := 'fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 Authority Ref:}{\rtlch\fcs1 \af0\afs24 \ltrch\f';
    wwv_flow_api.g_varchar2_table(705) := 'cs0 \fs24\insrsid7427681  }{\field\flddirty{\*\fldinst {\rtlch\fcs1 '||chr(10)||
'\af0\afs24 \ltrch\fcs0 \fs24\in';
    wwv_flow_api.g_varchar2_table(706) := 'srsid7427681\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681\charr';
    wwv_flow_api.g_varchar2_table(707) := 'sid7427681 {\*\datafield 00010000000000000554657874310008415554485f52454600000000000c3c3f415554485f5';
    wwv_flow_api.g_varchar2_table(708) := '245463f3e0000000000}'||chr(10)||
'{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext AUTH_';
    wwv_flow_api.g_varchar2_table(709) := 'REF}{\*\ffstattext <?AUTH_REF?>}}}}}{\fldrslt {\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\lang1024\lan';
    wwv_flow_api.g_varchar2_table(710) := 'gfe1024\noproof\insrsid7427681\charrsid7427681 AUTH_REF}}}\sectd '||chr(10)||
'\linex0\headery708\footery708\cols';
    wwv_flow_api.g_varchar2_table(711) := 'x708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 \l';
    wwv_flow_api.g_varchar2_table(712) := 'ang2057\langfe1033\langnp2057\insrsid16665483 '||chr(10)||
'\par Date:}{\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\';
    wwv_flow_api.g_varchar2_table(713) := 'insrsid7427681  }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid742768';
    wwv_flow_api.g_varchar2_table(714) := '1\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681\charrsid7427681 ';
    wwv_flow_api.g_varchar2_table(715) := ''||chr(10)||
'{\*\datafield 0001000000000000055465787431000a49535355455f4441544500000000000e3c3f49535355455f44415';
    wwv_flow_api.g_varchar2_table(716) := '4453f3e0000000000}{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext ISSUE_DA';
    wwv_flow_api.g_varchar2_table(717) := 'TE}{\*\ffstattext <?ISSUE_DATE?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\lang1024\l';
    wwv_flow_api.g_varchar2_table(718) := 'angfe1024\noproof\insrsid7427681\charrsid7427681 ISSUE_DATE}}}\sectd \linex0\headery708\footery708\c';
    wwv_flow_api.g_varchar2_table(719) := 'olsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(720) := ' '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 \cell National Grid Reference'||chr(10)||
'\par Easting: }{\fie';
    wwv_flow_api.g_varchar2_table(721) := 'ld\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid7427681\charrsid7427681 FORMTEXT}{\rtlc';
    wwv_flow_api.g_varchar2_table(722) := 'h\fcs1 \af0 \ltrch\fcs0 \insrsid7427681\charrsid7427681 {\*\datafield '||chr(10)||
'00010000000000000554657874310';
    wwv_flow_api.g_varchar2_table(723) := '00c585f434f4f5244494e4154450000000000103c3f585f434f4f5244494e4154453f3e0000000000}{\*\formfield{\fft';
    wwv_flow_api.g_varchar2_table(724) := 'ype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext X_COORDINATE}{\*\ffstattext <?X_COORDINATE?>';
    wwv_flow_api.g_varchar2_table(725) := '}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid7427681\charrsid74';
    wwv_flow_api.g_varchar2_table(726) := '27681 X_COORDINATE}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefa';
    wwv_flow_api.g_varchar2_table(727) := 'ultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid';
    wwv_flow_api.g_varchar2_table(728) := '16665483 '||chr(10)||
'\par }\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustr';
    wwv_flow_api.g_varchar2_table(729) := 'ight\rin0\lin0\pararsid16665483\yts15 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\';
    wwv_flow_api.g_varchar2_table(730) := 'insrsid16665483 Northing: }{\field\flddirty{\*\fldinst {\rtlch\fcs1 '||chr(10)||
'\af0 \ltrch\fcs0 \insrsid742768';
    wwv_flow_api.g_varchar2_table(731) := '1\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid7427681\charrsid7427681 {\*\datafie';
    wwv_flow_api.g_varchar2_table(732) := 'ld 0001000000000000055465787431000c595f434f4f5244494e4154450000000000103c3f595f434f4f5244494e4154453';
    wwv_flow_api.g_varchar2_table(733) := 'f3e0000000000}'||chr(10)||
'{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext Y_COORDINAT';
    wwv_flow_api.g_varchar2_table(734) := 'E}{\*\ffstattext <?Y_COORDINATE?>}}}}}{\fldrslt {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang1024\langfe1024\n';
    wwv_flow_api.g_varchar2_table(735) := 'oproof\insrsid7427681\charrsid7427681 Y_COORDINATE}}}\sectd '||chr(10)||
'\linex0\headery708\footery708\colsx708\';
    wwv_flow_api.g_varchar2_table(736) := 'endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang20';
    wwv_flow_api.g_varchar2_table(737) := '57\langfe1033\langnp2057\insrsid16665483 \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wra';
    wwv_flow_api.g_varchar2_table(738) := 'pdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \';
    wwv_flow_api.g_varchar2_table(739) := 'f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\';
    wwv_flow_api.g_varchar2_table(740) := 'langfe1033\langnp2057\insrsid16665483 \trowd \irow2\irowband2\ltrrow\ts15\trgaph108\trleft-108\trbrd';
    wwv_flow_api.g_varchar2_table(741) := 'rt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdr';
    wwv_flow_api.g_varchar2_table(742) := 's\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsW';
    wwv_flow_api.g_varchar2_table(743) := 'idthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid';
    wwv_flow_api.g_varchar2_table(744) := '16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cl';
    wwv_flow_api.g_varchar2_table(745) := 'brdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\';
    wwv_flow_api.g_varchar2_table(746) := 'clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brd';
    wwv_flow_api.g_varchar2_table(747) := 'rs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWid';
    wwv_flow_api.g_varchar2_table(748) := 'th3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\trowd \irow3\irowband3\ltrrow\ts15\trgaph108\tr';
    wwv_flow_api.g_varchar2_table(749) := 'left-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(750) := '1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trf';
    wwv_flow_api.g_varchar2_table(751) := 'tsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\tr';
    wwv_flow_api.g_varchar2_table(752) := 'paddfr3\tblrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(753) := '10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(754) := 'rcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvmgf\clvertalt\clbrdrt\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(755) := '0\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(756) := 'f1 '||chr(10)||
'\cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\pard\plain \ltrpar\ql \li0\ri0\widctlp';
    wwv_flow_api.g_varchar2_table(757) := 'ar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang';
    wwv_flow_api.g_varchar2_table(758) := '1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltr';
    wwv_flow_api.g_varchar2_table(759) := 'ch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 Applicant:}{\rtlch\fcs1 \af0\afs24 \ltrch\fc';
    wwv_flow_api.g_varchar2_table(760) := 's0 \fs24\insrsid7427681  }{\field\flddirty{\*\fldinst {\rtlch\fcs1 '||chr(10)||
'\af0\afs24 \ltrch\fcs0 \fs24\ins';
    wwv_flow_api.g_varchar2_table(761) := 'rsid7427681\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681\charrs';
    wwv_flow_api.g_varchar2_table(762) := 'id7427681 {\*\datafield 000100000000000005546578743100094150504c4943414e5400000000000d3c3f4150504c49';
    wwv_flow_api.g_varchar2_table(763) := '43414e543f3e0000000000}'||chr(10)||
'{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext AP';
    wwv_flow_api.g_varchar2_table(764) := 'PLICANT}{\*\ffstattext <?APPLICANT?>}}}}}{\fldrslt {\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\lang102';
    wwv_flow_api.g_varchar2_table(765) := '4\langfe1024\noproof\insrsid7427681\charrsid7427681 APPLICANT}}}\sectd '||chr(10)||
'\linex0\headery708\footery70';
    wwv_flow_api.g_varchar2_table(766) := '8\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\f';
    wwv_flow_api.g_varchar2_table(767) := 'cs0 \lang2057\langfe1033\langnp2057\insrsid16665483 \cell Preliminary enquiry/to be determind by\cel';
    wwv_flow_api.g_varchar2_table(768) := 'l }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\r';
    wwv_flow_api.g_varchar2_table(769) := 'in0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033';
    wwv_flow_api.g_varchar2_table(770) := '\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 \trowd ';
    wwv_flow_api.g_varchar2_table(771) := '\irow3\irowband3\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(772) := '10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(773) := 'rcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trp';
    wwv_flow_api.g_varchar2_table(774) := 'addr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tb';
    wwv_flow_api.g_varchar2_table(775) := 'lindtype3 \clvertalt\clbrdrt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\br';
    wwv_flow_api.g_varchar2_table(776) := 'drw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx46';
    wwv_flow_api.g_varchar2_table(777) := '80\clvmgf\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\clbrdrb\brdrs\brd';
    wwv_flow_api.g_varchar2_table(778) := 'rw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx946';
    wwv_flow_api.g_varchar2_table(779) := '8\row \ltrrow}\trowd \irow4\irowband4\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1';
    wwv_flow_api.g_varchar2_table(780) := ' \trbrdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbr';
    wwv_flow_api.g_varchar2_table(781) := 'drh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\tra';
    wwv_flow_api.g_varchar2_table(782) := 'utofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid16665483\tbllkhdrrows\t';
    wwv_flow_api.g_varchar2_table(783) := 'bllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(784) := 'cf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth478';
    wwv_flow_api.g_varchar2_table(785) := '8\clshdrawnil \cellx4680\clvmrg\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(786) := 'f1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\clftsWidth3\clwWidth4788';
    wwv_flow_api.g_varchar2_table(787) := '\clshdrawnil \cellx9468\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\f';
    wwv_flow_api.g_varchar2_table(788) := 'aauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\l';
    wwv_flow_api.g_varchar2_table(789) := 'angfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp205';
    wwv_flow_api.g_varchar2_table(790) := '7\insrsid16665483 Location A:}{\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681  }{\rtlch\fcs';
    wwv_flow_api.g_varchar2_table(791) := '1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 '||chr(10)||
'\par }\pard \ltrpar\ql \li0\ri0';
    wwv_flow_api.g_varchar2_table(792) := '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid16665483\yts15 {\r';
    wwv_flow_api.g_varchar2_table(793) := 'tlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 At: }{\field\flddirty{\*\';
    wwv_flow_api.g_varchar2_table(794) := 'fldinst {\rtlch\fcs1 \af0 '||chr(10)||
'\ltrch\fcs0 \insrsid7427681\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0 \l';
    wwv_flow_api.g_varchar2_table(795) := 'trch\fcs0 \insrsid7427681\charrsid7427681 {\*\datafield 000100000000000005546578743100084c4f43415449';
    wwv_flow_api.g_varchar2_table(796) := '4f4e00000000000c3c3f4c4f434154494f4e3f3e0000000000}'||chr(10)||
'{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\f';
    wwv_flow_api.g_varchar2_table(797) := 'fname Text1}{\*\ffdeftext LOCATION}{\*\ffstattext <?LOCATION?>}}}}}{\fldrslt {\rtlch\fcs1 \af0 \ltrc';
    wwv_flow_api.g_varchar2_table(798) := 'h\fcs0 \lang1024\langfe1024\noproof\insrsid7427681\charrsid7427681 LOCATION}}}\sectd '||chr(10)||
'\linex0\header';
    wwv_flow_api.g_varchar2_table(799) := 'y708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1';
    wwv_flow_api.g_varchar2_table(800) := ' \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 \cell }\pard \ltrpar'||chr(10)||
'\ql \li0\ri0\';
    wwv_flow_api.g_varchar2_table(801) := 'widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 {\rtlch\fcs1 \af0 \lt';
    wwv_flow_api.g_varchar2_table(802) := 'rch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\wid';
    wwv_flow_api.g_varchar2_table(803) := 'ctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang10';
    wwv_flow_api.g_varchar2_table(804) := '25 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(805) := 'fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 \trowd \irow4\irowband4\ltrrow\ts15\trgaph108\';
    wwv_flow_api.g_varchar2_table(806) := 'trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(807) := 'f1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \tr';
    wwv_flow_api.g_varchar2_table(808) := 'ftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\t';
    wwv_flow_api.g_varchar2_table(809) := 'rpaddfr3\tblrsid16665483\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3 \clvertalt\clbrdrt'||chr(10)||
'\brdrs\brd';
    wwv_flow_api.g_varchar2_table(810) := 'rw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\br';
    wwv_flow_api.g_varchar2_table(811) := 'drcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvmrg\clvertalt\clbrdrt\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(812) := '10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(813) := 'rcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\trowd \irow5\irowband5\l';
    wwv_flow_api.g_varchar2_table(814) := 'astrow \ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(815) := 'f1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trb';
    wwv_flow_api.g_varchar2_table(816) := 'rdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\';
    wwv_flow_api.g_varchar2_table(817) := 'trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3560942\tbllkhdrrows\tbllkhdrcols\tblind0\tblindtype3';
    wwv_flow_api.g_varchar2_table(818) := ' \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb'||chr(10)||
'\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(819) := 'rcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\pard\p';
    wwv_flow_api.g_varchar2_table(820) := 'lain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yt';
    wwv_flow_api.g_varchar2_table(821) := 's15 \rtlch\fcs1 \af0\afs22\alang1025 '||chr(10)||
'\ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\lan';
    wwv_flow_api.g_varchar2_table(822) := 'gfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 Proposal:}{\';
    wwv_flow_api.g_varchar2_table(823) := 'rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681  }{\field\flddirty{\*\fldinst {'||chr(10)||
'\rtlch\fcs1 \';
    wwv_flow_api.g_varchar2_table(824) := 'af0\afs24 \ltrch\fcs0 \fs24\insrsid7427681\charrsid7427681 FORMTEXT}{\rtlch\fcs1 \af0\afs24 \ltrch\f';
    wwv_flow_api.g_varchar2_table(825) := 'cs0 \fs24\insrsid7427681\charrsid7427681 {\*\datafield '||chr(10)||
'0001000000000000055465787431000850524f504f53';
    wwv_flow_api.g_varchar2_table(826) := '414c00000000000c3c3f50524f504f53414c3f3e0000000000}{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ff';
    wwv_flow_api.g_varchar2_table(827) := 'name Text1}{\*\ffdeftext PROPOSAL}{\*\ffstattext <?PROPOSAL?>}}}}}{\fldrslt {\rtlch\fcs1 \af0\afs24 ';
    wwv_flow_api.g_varchar2_table(828) := ''||chr(10)||
'\ltrch\fcs0 \fs24\lang1024\langfe1024\noproof\insrsid7427681\charrsid7427681 PROPOSAL}}}\sectd \lin';
    wwv_flow_api.g_varchar2_table(829) := 'ex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\';
    wwv_flow_api.g_varchar2_table(830) := 'rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 '||chr(10)||
'\par \cell }\pard\plai';
    wwv_flow_api.g_varchar2_table(831) := 'n \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlc';
    wwv_flow_api.g_varchar2_table(832) := 'h\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
    wwv_flow_api.g_varchar2_table(833) := '{\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid16665483 \trowd \irow5\irowban';
    wwv_flow_api.g_varchar2_table(834) := 'd5\lastrow \ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\br';
    wwv_flow_api.g_varchar2_table(835) := 'drcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 ';
    wwv_flow_api.g_varchar2_table(836) := '\trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr1';
    wwv_flow_api.g_varchar2_table(837) := '08\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3560942\tbllkhdrrows\tbllkhdrcols\tblind0\tblindty';
    wwv_flow_api.g_varchar2_table(838) := 'pe3 \clvertalt\clbrdrt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\';
    wwv_flow_api.g_varchar2_table(839) := 'brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\row';
    wwv_flow_api.g_varchar2_table(840) := ' }\pard \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin';
    wwv_flow_api.g_varchar2_table(841) := '0\itap0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid16665483 '||chr(10)||
'\par \ltrrow}';
    wwv_flow_api.g_varchar2_table(842) := '\trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdr';
    wwv_flow_api.g_varchar2_table(843) := 's\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(844) := '10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl';
    wwv_flow_api.g_varchar2_table(845) := '108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbll';
    wwv_flow_api.g_varchar2_table(846) := 'khdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\b';
    wwv_flow_api.g_varchar2_table(847) := 'rdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\c';
    wwv_flow_api.g_varchar2_table(848) := 'lwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\br';
    wwv_flow_api.g_varchar2_table(849) := 'drcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4';
    wwv_flow_api.g_varchar2_table(850) := '788\clshdrawnil \cellx9468\pard\plain \ltrpar\qc \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha';
    wwv_flow_api.g_varchar2_table(851) := '\aspnum\faauto\adjustright\rin0\lin0\pararsid6291715\yts15 \rtlch\fcs1 \af0\afs22\alang1025 '||chr(10)||
'\ltrch\';
    wwv_flow_api.g_varchar2_table(852) := 'fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \ul\l';
    wwv_flow_api.g_varchar2_table(853) := 'ang2057\langfe1033\langnp2057\insrsid6291715\charrsid6291715 DESCRIPTION OF DUTIES\cell DATE AND OFF';
    wwv_flow_api.g_varchar2_table(854) := 'ICER\rquote S INITIALS\cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\a';
    wwv_flow_api.g_varchar2_table(855) := 'spnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\l';
    wwv_flow_api.g_varchar2_table(856) := 'angfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp20';
    wwv_flow_api.g_varchar2_table(857) := '57\insrsid6291715 \trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(858) := 'rcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \t';
    wwv_flow_api.g_varchar2_table(859) := 'rbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\';
    wwv_flow_api.g_varchar2_table(860) := 'trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows';
    wwv_flow_api.g_varchar2_table(861) := '\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 '||chr(10)||
'\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(862) := '1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltx';
    wwv_flow_api.g_varchar2_table(863) := 'lrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdr';
    wwv_flow_api.g_varchar2_table(864) := 'l'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clf';
    wwv_flow_api.g_varchar2_table(865) := 'tsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widc';
    wwv_flow_api.g_varchar2_table(866) := 'tlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\al';
    wwv_flow_api.g_varchar2_table(867) := 'ang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \l';
    wwv_flow_api.g_varchar2_table(868) := 'trch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 Application Received in RNM2/RNM6\cell \ce';
    wwv_flow_api.g_varchar2_table(869) := 'll }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\r';
    wwv_flow_api.g_varchar2_table(870) := 'in0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp103';
    wwv_flow_api.g_varchar2_table(871) := '3\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \';
    wwv_flow_api.g_varchar2_table(872) := 'irow1\irowband1\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(873) := '0\brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(874) := 'cf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trp';
    wwv_flow_api.g_varchar2_table(875) := 'addr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcol';
    wwv_flow_api.g_varchar2_table(876) := 's\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\';
    wwv_flow_api.g_varchar2_table(877) := 'brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth';
    wwv_flow_api.g_varchar2_table(878) := '4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \';
    wwv_flow_api.g_varchar2_table(879) := 'clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\cls';
    wwv_flow_api.g_varchar2_table(880) := 'hdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\as';
    wwv_flow_api.g_varchar2_table(881) := 'palpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\';
    wwv_flow_api.g_varchar2_table(882) := 'fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langf';
    wwv_flow_api.g_varchar2_table(883) := 'e1033\langnp2057\insrsid6291715 Passed From RNM2/RNM6 To RNM3 (Drawing Office)\cell \cell }\pard\pla';
    wwv_flow_api.g_varchar2_table(884) := 'in \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rt';
    wwv_flow_api.g_varchar2_table(885) := 'lch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp103';
    wwv_flow_api.g_varchar2_table(886) := '3 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \irow2\irowba';
    wwv_flow_api.g_varchar2_table(887) := 'nd2\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \t';
    wwv_flow_api.g_varchar2_table(888) := 'rbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv';
    wwv_flow_api.g_varchar2_table(889) := '\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpad';
    wwv_flow_api.g_varchar2_table(890) := 'dfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastco';
    wwv_flow_api.g_varchar2_table(891) := 'l\tblind0\tblindtype3 '||chr(10)||
'\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbr';
    wwv_flow_api.g_varchar2_table(892) := 'drb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdraw';
    wwv_flow_api.g_varchar2_table(893) := 'nil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdr';
    wwv_flow_api.g_varchar2_table(894) := 's\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cel';
    wwv_flow_api.g_varchar2_table(895) := 'lx9468\row \ltrrow}\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnu';
    wwv_flow_api.g_varchar2_table(896) := 'm\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033';
    wwv_flow_api.g_varchar2_table(897) := '\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp';
    wwv_flow_api.g_varchar2_table(898) := '2057\insrsid6291715 Received In RNM3 (Drawing Office)\cell \cell }\pard\plain \ltrpar\ql \li0\ri0\wi';
    wwv_flow_api.g_varchar2_table(899) := 'dctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1';
    wwv_flow_api.g_varchar2_table(900) := '025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrc';
    wwv_flow_api.g_varchar2_table(901) := 'h\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \irow3\irowband3\ltrrow\ts15\trgaph108\';
    wwv_flow_api.g_varchar2_table(902) := 'trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(903) := 'cf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\t';
    wwv_flow_api.g_varchar2_table(904) := 'rftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\';
    wwv_flow_api.g_varchar2_table(905) := 'trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \cl';
    wwv_flow_api.g_varchar2_table(906) := 'vertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1';
    wwv_flow_api.g_varchar2_table(907) := ' \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\';
    wwv_flow_api.g_varchar2_table(908) := 'clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr';
    wwv_flow_api.g_varchar2_table(909) := ''||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\';
    wwv_flow_api.g_varchar2_table(910) := 'plain \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\';
    wwv_flow_api.g_varchar2_table(911) := 'lin0\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1';
    wwv_flow_api.g_varchar2_table(912) := '033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 Passed';
    wwv_flow_api.g_varchar2_table(913) := ' By RNM3 (Drawing Office) To RUG\cell \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapde';
    wwv_flow_api.g_varchar2_table(914) := 'fault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37';
    wwv_flow_api.g_varchar2_table(915) := '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\lan';
    wwv_flow_api.g_varchar2_table(916) := 'gfe1033\langnp2057\insrsid6291715 \trowd \irow4\irowband4\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\b';
    wwv_flow_api.g_varchar2_table(917) := 'rdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\br';
    wwv_flow_api.g_varchar2_table(918) := 'drw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidth';
    wwv_flow_api.g_varchar2_table(919) := 'B3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291';
    wwv_flow_api.g_varchar2_table(920) := '715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 '||chr(10)||
'\clvertalt\clbrdrt\brdr';
    wwv_flow_api.g_varchar2_table(921) := 's\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(922) := '10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10';
    wwv_flow_api.g_varchar2_table(923) := '\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(924) := 'f1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar'||chr(10)||
'\ql \li';
    wwv_flow_api.g_varchar2_table(925) := '0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fc';
    wwv_flow_api.g_varchar2_table(926) := 's1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rt';
    wwv_flow_api.g_varchar2_table(927) := 'lch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 Received In RUG\cell \cell';
    wwv_flow_api.g_varchar2_table(928) := ' }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin';
    wwv_flow_api.g_varchar2_table(929) := '0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\';
    wwv_flow_api.g_varchar2_table(930) := 'langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \ir';
    wwv_flow_api.g_varchar2_table(931) := 'ow5\irowband5\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\';
    wwv_flow_api.g_varchar2_table(932) := 'brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(933) := '1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpad';
    wwv_flow_api.g_varchar2_table(934) := 'dr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\';
    wwv_flow_api.g_varchar2_table(935) := 'tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\br';
    wwv_flow_api.g_varchar2_table(936) := 'drcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth47';
    wwv_flow_api.g_varchar2_table(937) := '88\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \cl';
    wwv_flow_api.g_varchar2_table(938) := 'brdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshd';
    wwv_flow_api.g_varchar2_table(939) := 'rawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspa';
    wwv_flow_api.g_varchar2_table(940) := 'lpha\aspnum\faauto\adjustright\rin0\lin0\pararsid6691967\yts15 \rtlch\fcs1 '||chr(10)||
'\af0\afs22\alang1025 \lt';
    wwv_flow_api.g_varchar2_table(941) := 'rch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \';
    wwv_flow_api.g_varchar2_table(942) := 'lang2057\langfe1033\langnp2057\insrsid6291715 Received to Drawing Office\cell }\pard \ltrpar'||chr(10)||
'\ql \li';
    wwv_flow_api.g_varchar2_table(943) := '0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 {\rtlch\f';
    wwv_flow_api.g_varchar2_table(944) := 'cs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \';
    wwv_flow_api.g_varchar2_table(945) := 'li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\af';
    wwv_flow_api.g_varchar2_table(946) := 's22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \';
    wwv_flow_api.g_varchar2_table(947) := 'af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \irow6\irowband6\ltrrow\ts15\';
    wwv_flow_api.g_varchar2_table(948) := 'trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brd';
    wwv_flow_api.g_varchar2_table(949) := 'rw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\b';
    wwv_flow_api.g_varchar2_table(950) := 'rdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\t';
    wwv_flow_api.g_varchar2_table(951) := 'rpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblind';
    wwv_flow_api.g_varchar2_table(952) := 'type3 '||chr(10)||
'\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(953) := '0\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\c';
    wwv_flow_api.g_varchar2_table(954) := 'lvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(955) := '1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrr';
    wwv_flow_api.g_varchar2_table(956) := 'ow}\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustr';
    wwv_flow_api.g_varchar2_table(957) := 'ight\rin0\lin0\pararsid6691967\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033';
    wwv_flow_api.g_varchar2_table(958) := '\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp';
    wwv_flow_api.g_varchar2_table(959) := '2057\insrsid6291715 Returned From Drawing Office to RNM2/RNM6\cell }\pard \ltrpar\ql \li0\ri0\sa200\';
    wwv_flow_api.g_varchar2_table(960) := 'widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 {\rtlch\fcs1 \af0 \lt';
    wwv_flow_api.g_varchar2_table(961) := 'rch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 \cell }\pard\plain \ltrpar\ql \li0\ri0\widc';
    wwv_flow_api.g_varchar2_table(962) := 'tlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang102';
    wwv_flow_api.g_varchar2_table(963) := '5 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(964) := 'fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \irow7\irowband7\ltrrow\ts15\trgaph108\tr';
    wwv_flow_api.g_varchar2_table(965) := 'left-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdrcf';
    wwv_flow_api.g_varchar2_table(966) := '1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trf';
    wwv_flow_api.g_varchar2_table(967) := 'tsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\tr';
    wwv_flow_api.g_varchar2_table(968) := 'paddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clve';
    wwv_flow_api.g_varchar2_table(969) := 'rtalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \';
    wwv_flow_api.g_varchar2_table(970) := 'clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\cl';
    wwv_flow_api.g_varchar2_table(971) := 'brdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\';
    wwv_flow_api.g_varchar2_table(972) := 'brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\pl';
    wwv_flow_api.g_varchar2_table(973) := 'ain \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\li';
    wwv_flow_api.g_varchar2_table(974) := 'n0\pararsid6691967\yts15 \rtlch\fcs1 '||chr(10)||
'\af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033';
    wwv_flow_api.g_varchar2_table(975) := '\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid';
    wwv_flow_api.g_varchar2_table(976) := '6291715 Received In RNM2/RNM6\cell }\pard \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\asp';
    wwv_flow_api.g_varchar2_table(977) := 'alpha\aspnum\faauto\adjustright\rin0\lin0\yts15 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\l';
    wwv_flow_api.g_varchar2_table(978) := 'angnp2057\insrsid6291715 \cell }\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalph';
    wwv_flow_api.g_varchar2_table(979) := 'a\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang103';
    wwv_flow_api.g_varchar2_table(980) := '3\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langn';
    wwv_flow_api.g_varchar2_table(981) := 'p2057\insrsid6291715 \trowd \irow8\irowband8\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\';
    wwv_flow_api.g_varchar2_table(982) := 'brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1';
    wwv_flow_api.g_varchar2_table(983) := ' \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidth';
    wwv_flow_api.g_varchar2_table(984) := 'A3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrr';
    wwv_flow_api.g_varchar2_table(985) := 'ows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 '||chr(10)||
'\clvertalt\clbrdrt\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(986) := 'rcf1 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \c';
    wwv_flow_api.g_varchar2_table(987) := 'ltxlrtb\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clb';
    wwv_flow_api.g_varchar2_table(988) := 'rdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\';
    wwv_flow_api.g_varchar2_table(989) := 'clftsWidth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\w';
    wwv_flow_api.g_varchar2_table(990) := 'idctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22';
    wwv_flow_api.g_varchar2_table(991) := '\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0';
    wwv_flow_api.g_varchar2_table(992) := ' \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 Passed By RNM2/RNM6 To relevant Enginee';
    wwv_flow_api.g_varchar2_table(993) := 'r For Action\cell \cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum';
    wwv_flow_api.g_varchar2_table(994) := '\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 '||chr(10)||
'\ltrch\fcs0 \f37\fs22\lang1033\langf';
    wwv_flow_api.g_varchar2_table(995) := 'e1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\in';
    wwv_flow_api.g_varchar2_table(996) := 'srsid6291715 \trowd \irow9\irowband9\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 ';
    wwv_flow_api.g_varchar2_table(997) := '\trbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrd';
    wwv_flow_api.g_varchar2_table(998) := 'rh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trau';
    wwv_flow_api.g_varchar2_table(999) := 'tofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbl';
    wwv_flow_api.g_varchar2_table(1000) := 'lklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \cl';
null;
 
end;
/

 
begin
 
    wwv_flow_api.g_varchar2_table(1001) := 'brdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb';
    wwv_flow_api.g_varchar2_table(1002) := '\clftsWidth3\clwWidth4788\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\br';
    wwv_flow_api.g_varchar2_table(1003) := 'drs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWi';
    wwv_flow_api.g_varchar2_table(1004) := 'dth3\clwWidth4788\clshdrawnil \cellx9468\row \ltrrow}\pard\plain \ltrpar\ql \li0\ri0\sa200\widctlpar';
    wwv_flow_api.g_varchar2_table(1005) := '\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts15 \rtlch\fcs1 \af0\afs22\alang10';
    wwv_flow_api.g_varchar2_table(1006) := '25 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch';
    wwv_flow_api.g_varchar2_table(1007) := '\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715 Received By Engineer\cell \cell }\pard\plain \l';
    wwv_flow_api.g_varchar2_table(1008) := 'trpar'||chr(10)||
'\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\f';
    wwv_flow_api.g_varchar2_table(1009) := 'cs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\r';
    wwv_flow_api.g_varchar2_table(1010) := 'tlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid6291715 \trowd \irow10\irowband10';
    wwv_flow_api.g_varchar2_table(1011) := '\lastrow \ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(1012) := 'cf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \t';
    wwv_flow_api.g_varchar2_table(1013) := 'rbrdrv\brdrs\brdrw10\brdrcf1 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108';
    wwv_flow_api.g_varchar2_table(1014) := '\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6291715\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllk';
    wwv_flow_api.g_varchar2_table(1015) := 'lastcol\tblind0\tblindtype3 '||chr(10)||
'\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrcf1';
    wwv_flow_api.g_varchar2_table(1016) := ' \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\cl';
    wwv_flow_api.g_varchar2_table(1017) := 'shdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdr';
    wwv_flow_api.g_varchar2_table(1018) := 'b\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth4788\clshdrawni';
    wwv_flow_api.g_varchar2_table(1019) := 'l \cellx9468\row }\pard \ltrpar\ql \li0\ri0\sa200\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjus';
    wwv_flow_api.g_varchar2_table(1020) := 'tright\rin0\lin0\itap0 {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid6291715';
    wwv_flow_api.g_varchar2_table(1021) := '\charrsid16665483 '||chr(10)||
'\par }}';
null;
 
end;
/

--application/shared_components/reports/report_layouts/front_page
begin
wwv_flow_api.create_report_layout(
  p_id => 1319710737138107 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_report_layout_name =>'Front Page',
  p_report_layout_type =>'RTF_FILE',
  p_varchar2_table => wwv_flow_api.g_varchar2_table,
  p_xslfo_column_heading =>'',
  p_xslfo_column_template =>'',
  p_xslfo_column_template_width =>'',
  p_reference_id =>null,
  p_report_layout_comment =>'');
end;
/
 
begin
 
    wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
    wwv_flow_api.g_varchar2_table(1) := '{\rtf1\adeflang1025\ansi\ansicpg1252\uc1\adeff0\deff0\stshfdbch0\stshfloch37\stshfhich37\stshfbi37\d';
    wwv_flow_api.g_varchar2_table(2) := 'eflang1033\deflangfe1033{\fonttbl{\f0\froman\fcharset0\fprq2{\*\panose 02020603050405020304}Times Ne';
    wwv_flow_api.g_varchar2_table(3) := 'w Roman;}{\f2\fmodern\fcharset0\fprq1{\*\panose 02070309020205020404}Courier New;}'||chr(10)||
'{\f37\fswiss\fcha';
    wwv_flow_api.g_varchar2_table(4) := 'rset0\fprq2{\*\panose 020f0502020204030204}Calibri;}{\f255\froman\fcharset238\fprq2 Times New Roman ';
    wwv_flow_api.g_varchar2_table(5) := 'CE;}{\f256\froman\fcharset204\fprq2 Times New Roman Cyr;}{\f258\froman\fcharset161\fprq2 Times New R';
    wwv_flow_api.g_varchar2_table(6) := 'oman Greek;}'||chr(10)||
'{\f259\froman\fcharset162\fprq2 Times New Roman Tur;}{\f260\fbidi \froman\fcharset177\f';
    wwv_flow_api.g_varchar2_table(7) := 'prq2 Times New Roman (Hebrew);}{\f261\fbidi \froman\fcharset178\fprq2 Times New Roman (Arabic);}{\f2';
    wwv_flow_api.g_varchar2_table(8) := '62\froman\fcharset186\fprq2 Times New Roman Baltic;}'||chr(10)||
'{\f263\froman\fcharset163\fprq2 Times New Roman';
    wwv_flow_api.g_varchar2_table(9) := ' (Vietnamese);}{\f275\fmodern\fcharset238\fprq1 Courier New CE;}{\f276\fmodern\fcharset204\fprq1 Cou';
    wwv_flow_api.g_varchar2_table(10) := 'rier New Cyr;}{\f278\fmodern\fcharset161\fprq1 Courier New Greek;}'||chr(10)||
'{\f279\fmodern\fcharset162\fprq1 ';
    wwv_flow_api.g_varchar2_table(11) := 'Courier New Tur;}{\f280\fbidi \fmodern\fcharset177\fprq1 Courier New (Hebrew);}{\f281\fbidi \fmodern';
    wwv_flow_api.g_varchar2_table(12) := '\fcharset178\fprq1 Courier New (Arabic);}{\f282\fmodern\fcharset186\fprq1 Courier New Baltic;}'||chr(10)||
'{\f28';
    wwv_flow_api.g_varchar2_table(13) := '3\fmodern\fcharset163\fprq1 Courier New (Vietnamese);}{\f625\fswiss\fcharset238\fprq2 Calibri CE;}{\';
    wwv_flow_api.g_varchar2_table(14) := 'f626\fswiss\fcharset204\fprq2 Calibri Cyr;}{\f628\fswiss\fcharset161\fprq2 Calibri Greek;}{\f629\fsw';
    wwv_flow_api.g_varchar2_table(15) := 'iss\fcharset162\fprq2 Calibri Tur;}'||chr(10)||
'{\f632\fswiss\fcharset186\fprq2 Calibri Baltic;}}{\colortbl;\red';
    wwv_flow_api.g_varchar2_table(16) := '0\green0\blue0;\red0\green0\blue255;\red0\green255\blue255;\red0\green255\blue0;\red255\green0\blue2';
    wwv_flow_api.g_varchar2_table(17) := '55;\red255\green0\blue0;\red255\green255\blue0;\red255\green255\blue255;'||chr(10)||
'\red0\green0\blue128;\red0\';
    wwv_flow_api.g_varchar2_table(18) := 'green128\blue128;\red0\green128\blue0;\red128\green0\blue128;\red128\green0\blue0;\red128\green128\b';
    wwv_flow_api.g_varchar2_table(19) := 'lue0;\red128\green128\blue128;\red192\green192\blue192;}{\stylesheet{'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\w';
    wwv_flow_api.g_varchar2_table(20) := 'rapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrc';
    wwv_flow_api.g_varchar2_table(21) := 'h\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \snext0 \styrsid1248866 Normal;}{';
    wwv_flow_api.g_varchar2_table(22) := '\*\cs10 \additive '||chr(10)||
'\ssemihidden Default Paragraph Font;}{\*\ts11\tsrowd\trftsWidthB3\trpaddl108\trpa';
    wwv_flow_api.g_varchar2_table(23) := 'ddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tscellwidthfts0\tsvertalt\tsbrdrt';
    wwv_flow_api.g_varchar2_table(24) := '\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv '||chr(10)||
'\ql \li0\ri0\widctlpar\wrapdefault\asp';
    wwv_flow_api.g_varchar2_table(25) := 'alpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af37\afs20 \ltrch\fcs0 \f37\fs20\lang10';
    wwv_flow_api.g_varchar2_table(26) := '24\langfe1024\cgrid\langnp1024\langfenp1024 \snext11 \ssemihidden Normal Table;}{\*\ts15\tsrowd\trbr';
    wwv_flow_api.g_varchar2_table(27) := 'drt'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\br';
    wwv_flow_api.g_varchar2_table(28) := 'drs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidthB3\trp';
    wwv_flow_api.g_varchar2_table(29) := 'addl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblind0\tblindtype3\tscellwidthfts0\tsver';
    wwv_flow_api.g_varchar2_table(30) := 'talt\tsbrdrt\tsbrdrl\tsbrdrb\tsbrdrr\tsbrdrdgl\tsbrdrdgr\tsbrdrh\tsbrdrv '||chr(10)||
'\ql \li0\ri0\widctlpar\wra';
    wwv_flow_api.g_varchar2_table(31) := 'pdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\';
    wwv_flow_api.g_varchar2_table(32) := 'fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \sbasedon11 \snext15 \styrsid166654';
    wwv_flow_api.g_varchar2_table(33) := '83 Table Grid;}}'||chr(10)||
'{\*\latentstyles\lsdstimax156\lsdlockeddef0{\lsdlockedexcept Normal;heading 1;headi';
    wwv_flow_api.g_varchar2_table(34) := 'ng 2;heading 3;heading 4;heading 5;heading 6;heading 7;heading 8;heading 9;toc 1;toc 2;toc 3;toc 4;t';
    wwv_flow_api.g_varchar2_table(35) := 'oc 5;toc 6;toc 7;toc 8;toc 9;caption;Title;Default Paragraph Font;Subtitle;Strong;Emphasis;Table Gri';
    wwv_flow_api.g_varchar2_table(36) := 'd;}}'||chr(10)||
'{\*\rsidtbl \rsid607341\rsid1248866\rsid1512796\rsid2170205\rsid2576807\rsid2903609\rsid3360042';
    wwv_flow_api.g_varchar2_table(37) := '\rsid3560942\rsid4201360\rsid4331195\rsid4933644\rsid5131112\rsid5730614\rsid6451980\rsid6765518\rsi';
    wwv_flow_api.g_varchar2_table(38) := 'd8001502\rsid8482629\rsid9640468\rsid9856348\rsid10358963'||chr(10)||
'\rsid10617749\rsid11886692\rsid12353262\rs';
    wwv_flow_api.g_varchar2_table(39) := 'id13435002\rsid14238228\rsid14319519\rsid14376119\rsid14896649\rsid15428369\rsid15601039\rsid1566441';
    wwv_flow_api.g_varchar2_table(40) := '9\rsid16665483}{\*\generator Microsoft Word 11.0.0000;}{\info{\title Records Service  }{\author  Ian';
    wwv_flow_api.g_varchar2_table(41) := ' Turnbull}'||chr(10)||
'{\operator SMarshall}{\creatim\yr2009\mo6\dy23\hr16\min20}{\revtim\yr2009\mo7\dy7\hr14\mi';
    wwv_flow_api.g_varchar2_table(42) := 'n52}{\version12}{\edmins180}{\nofpages1}{\nofwords50}{\nofchars289}{\*\company  }{\nofcharsws338}{\v';
    wwv_flow_api.g_varchar2_table(43) := 'ern24611}{\*\password 00000000}}{\*\xmlnstbl {\xmlns1 http://schem'||chr(10)||
'as.microsoft.com/office/word/2003';
    wwv_flow_api.g_varchar2_table(44) := '/wordml}}\paperw12240\paperh15840\margl1440\margr1440\margt1440\margb1440\gutter0\ltrsect '||chr(10)||
'\widowctr';
    wwv_flow_api.g_varchar2_table(45) := 'l\ftnbj\aenddoc\donotembedsysfont1\donotembedlingdata0\grfdocevents0\validatexml1\showplaceholdtext0';
    wwv_flow_api.g_varchar2_table(46) := '\ignoremixedcontent0\saveinvalidxml0\showxmlerrors1\noxlattoyen\expshrtn\noultrlspc\dntblnsbdb\nospa';
    wwv_flow_api.g_varchar2_table(47) := 'ceforul\formshade\horzdoc\dgmargin\dghspace180'||chr(10)||
'\dgvspace180\dghorigin1440\dgvorigin1440\dghshow1\dgv';
    wwv_flow_api.g_varchar2_table(48) := 'show1'||chr(10)||
'\jexpand\viewkind1\viewscale150\pgbrdrhead\pgbrdrfoot\splytwnine\ftnlytwnine\htmautsp\nolnhtad';
    wwv_flow_api.g_varchar2_table(49) := 'jtbl\useltbaln\alntblind\lytcalctblwd\lyttblrtgr\lnbrkrule\nobrkwrptbl\snaptogridincell\allowfielden';
    wwv_flow_api.g_varchar2_table(50) := 'dsel\wrppunct'||chr(10)||
'\asianbrkrule\rsidroot16665483\newtblstyruls\nogrowautofit \fet0{\*\wgrffmtfilter 2450';
    wwv_flow_api.g_varchar2_table(51) := '}\ilfomacatclnup0\ltrpar \sectd \ltrsect\linex0\headery708\footery708\colsx708\endnhere\sectlinegrid';
    wwv_flow_api.g_varchar2_table(52) := '360\sectdefaultcl\sectrsid10617749\sftnbj {\*\pnseclvl1'||chr(10)||
'\pnucrm\pnstart1\pnindent720\pnhang {\pntxta';
    wwv_flow_api.g_varchar2_table(53) := ' .}}{\*\pnseclvl2\pnucltr\pnstart1\pnindent720\pnhang {\pntxta .}}{\*\pnseclvl3\pndec\pnstart1\pnind';
    wwv_flow_api.g_varchar2_table(54) := 'ent720\pnhang {\pntxta .}}{\*\pnseclvl4\pnlcltr\pnstart1\pnindent720\pnhang {\pntxta )}}{\*\pnseclvl';
    wwv_flow_api.g_varchar2_table(55) := '5'||chr(10)||
'\pndec\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl6\pnlcltr\pnstart1\pnindent7';
    wwv_flow_api.g_varchar2_table(56) := '20\pnhang {\pntxtb (}{\pntxta )}}{\*\pnseclvl7\pnlcrm\pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxt';
    wwv_flow_api.g_varchar2_table(57) := 'a )}}{\*\pnseclvl8\pnlcltr\pnstart1\pnindent720\pnhang '||chr(10)||
'{\pntxtb (}{\pntxta )}}{\*\pnseclvl9\pnlcrm\';
    wwv_flow_api.g_varchar2_table(58) := 'pnstart1\pnindent720\pnhang {\pntxtb (}{\pntxta )}}\pard\plain \ltrpar\qr \li0\ri0\sa200\widctlpar\w';
    wwv_flow_api.g_varchar2_table(59) := 'rapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0\pararsid13435002 \rtlch\fcs1 '||chr(10)||
'\af0\afs';
    wwv_flow_api.g_varchar2_table(60) := '22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\field\flddirt';
    wwv_flow_api.g_varchar2_table(61) := 'y{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid13435002\charrsid13435002 FORMTEXT}{\rtlch\fcs1 \';
    wwv_flow_api.g_varchar2_table(62) := 'af0 \ltrch\fcs0 '||chr(10)||
'\insrsid13435002\charrsid13435002 {\*\datafield 0001000000000000055465787431000d575';
    wwv_flow_api.g_varchar2_table(63) := '052435f46494c455f5245460000000000113c3f575052435f46494c455f5245463f3e0000000000}{\*\formfield{\fftyp';
    wwv_flow_api.g_varchar2_table(64) := 'e0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext WPRC_FILE_REF}'||chr(10)||
'{\*\ffstattext <?WPRC_FILE_REF?';
    wwv_flow_api.g_varchar2_table(65) := '>}}}}}{\fldrslt {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang1024\langfe1024\noproof\insrsid13435002\charrsid1';
    wwv_flow_api.g_varchar2_table(66) := '3435002 WPRC_FILE_REF}}}\sectd '||chr(10)||
'\linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sect';
    wwv_flow_api.g_varchar2_table(67) := 'defaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid9856348\charrsid13435002  }{';
    wwv_flow_api.g_varchar2_table(68) := '\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid16665483\charrsid13435002 '||chr(10)||
'\par \ltrrow}\trowd \irow0\irowband0';
    wwv_flow_api.g_varchar2_table(69) := '\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbr';
    wwv_flow_api.g_varchar2_table(70) := 'drb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brd';
    wwv_flow_api.g_varchar2_table(71) := 'rs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3';
    wwv_flow_api.g_varchar2_table(72) := '\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tbli';
    wwv_flow_api.g_varchar2_table(73) := 'ndtype3 \clvmgf\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdr';
    wwv_flow_api.g_varchar2_table(74) := 'w10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil \cellx2286';
    wwv_flow_api.g_varchar2_table(75) := '\clvmgf\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(76) := 'f1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil \cellx4680\clverta';
    wwv_flow_api.g_varchar2_table(77) := 'lt\clbrdrt\brdrdb\brdrw30 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brd';
    wwv_flow_api.g_varchar2_table(78) := 'rs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil '||chr(10)||
'\cellx7074\clvertalt\clbrdrt\brdr';
    wwv_flow_api.g_varchar2_table(79) := 'db\brdrw30 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdr';
    wwv_flow_api.g_varchar2_table(80) := 'cf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil \cellx9468\pard\plain \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\';
    wwv_flow_api.g_varchar2_table(81) := 'widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid6691967\yts15 \rtlc';
    wwv_flow_api.g_varchar2_table(82) := 'h\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
    wwv_flow_api.g_varchar2_table(83) := '{\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid13435002 L.P.A.'||chr(10)||
'\par }{\field\';
    wwv_flow_api.g_varchar2_table(84) := 'flddirty{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 FORMTEXT}{\rt';
    wwv_flow_api.g_varchar2_table(85) := 'lch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 {\*\datafield '||chr(10)||
'0001000000000000055465';
    wwv_flow_api.g_varchar2_table(86) := '7874310008575052435f4c504100000000000c3c3f575052435f4c50413f3e0000000000}{\*\formfield{\fftype0\ffow';
    wwv_flow_api.g_varchar2_table(87) := 'nstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext WPRC_LPA}{\*\ffstattext <?WPRC_LPA?>}}}}}{\fldrslt {\';
    wwv_flow_api.g_varchar2_table(88) := 'rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\lang1024\langfe1024\noproof\insrsid13435002\charrsid14896649 WPRC_L';
    wwv_flow_api.g_varchar2_table(89) := 'PA}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10';
    wwv_flow_api.g_varchar2_table(90) := '617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\lang2057\langfe1033\langnp2057\insrsid13435002\char';
    wwv_flow_api.g_varchar2_table(91) := 'rsid14896649 \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid13435002 Ad';
    wwv_flow_api.g_varchar2_table(92) := 'dress'||chr(10)||
'\par }{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14';
    wwv_flow_api.g_varchar2_table(93) := '896649 FORMTEXT}{\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 {\*\datafield '||chr(10)||
'00';
    wwv_flow_api.g_varchar2_table(94) := '01000000000000055465787431000d575052435f4c4f434154494f4e0000000000113c3f575052435f4c4f434154494f4e3f';
    wwv_flow_api.g_varchar2_table(95) := '3e0000000000}{\*\formfield{\fftype0\ffownstat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext WPRC_LOCATION';
    wwv_flow_api.g_varchar2_table(96) := '}{\*\ffstattext <?WPRC_LOCATION?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\lang1024\langfe10';
    wwv_flow_api.g_varchar2_table(97) := '24\noproof\insrsid13435002\charrsid14896649 WPRC_LOCATION}}}\sectd \linex0\headery708\footery708\col';
    wwv_flow_api.g_varchar2_table(98) := 'sx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(99) := '\f2\lang2057\langfe1033\langnp2057\insrsid13435002\charrsid14896649 \cell }{\rtlch\fcs1 \af0 \ltrch\';
    wwv_flow_api.g_varchar2_table(100) := 'fcs0 \lang2057\langfe1033\langnp2057\insrsid13435002 \cell Easting'||chr(10)||
'\par }{\field\flddirty{\*\fldinst';
    wwv_flow_api.g_varchar2_table(101) := ' {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 FORMTEXT}{\rtlch\fcs1 \af2 \ltrc';
    wwv_flow_api.g_varchar2_table(102) := 'h\fcs0 \f2\insrsid13435002\charrsid14896649 {\*\datafield '||chr(10)||
'0001000000000000055465787431000b575052435';
    wwv_flow_api.g_varchar2_table(103) := 'f4f5347525f5800000000000f3c3f575052435f4f5347525f583f3e0000000000}{\*\formfield{\fftype0\ffownstat\f';
    wwv_flow_api.g_varchar2_table(104) := 'ftypetxt0{\*\ffname Text1}{\*\ffdeftext WPRC_OSGR_X}{\*\ffstattext <?WPRC_OSGR_X?>}}}}}{\fldrslt {\r';
    wwv_flow_api.g_varchar2_table(105) := 'tlch\fcs1 '||chr(10)||
'\af2 \ltrch\fcs0 \f2\lang1024\langfe1024\noproof\insrsid13435002\charrsid14896649 WPRC_OS';
    wwv_flow_api.g_varchar2_table(106) := 'GR_X}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid';
    wwv_flow_api.g_varchar2_table(107) := '10617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\lang2057\langfe1033\langnp2057\insrsid13435002\ch';
    wwv_flow_api.g_varchar2_table(108) := 'arrsid14896649 \cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\fa';
    wwv_flow_api.g_varchar2_table(109) := 'auto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe10';
    wwv_flow_api.g_varchar2_table(110) := '33\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrs';
    wwv_flow_api.g_varchar2_table(111) := 'id13435002 \trowd \irow0\irowband0\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \t';
    wwv_flow_api.g_varchar2_table(112) := 'rbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh';
    wwv_flow_api.g_varchar2_table(113) := '\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpadd';
    wwv_flow_api.g_varchar2_table(114) := 'l108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbl';
    wwv_flow_api.g_varchar2_table(115) := 'lkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvmgf\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl'||chr(10)||
'\brdrs\';
    wwv_flow_api.g_varchar2_table(116) := 'brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\';
    wwv_flow_api.g_varchar2_table(117) := 'clwWidth2394\clshdrawnil \cellx2286\clvmgf\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl\brdrs\brdrw10\b';
    wwv_flow_api.g_varchar2_table(118) := 'rdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth';
    wwv_flow_api.g_varchar2_table(119) := '2394\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb';
    wwv_flow_api.g_varchar2_table(120) := '\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil';
    wwv_flow_api.g_varchar2_table(121) := ' '||chr(10)||
'\cellx7074\clvertalt\clbrdrt\brdrdb\brdrw30 \clbrdrl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\';
    wwv_flow_api.g_varchar2_table(122) := 'brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\clshdrawnil \cellx9468\row';
    wwv_flow_api.g_varchar2_table(123) := ' \ltrrow}\trowd \irow1\irowband1\ltrrow'||chr(10)||
'\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \tr';
    wwv_flow_api.g_varchar2_table(124) := 'brdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\b';
    wwv_flow_api.g_varchar2_table(125) := 'rdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl1';
    wwv_flow_api.g_varchar2_table(126) := '08\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbllk';
    wwv_flow_api.g_varchar2_table(127) := 'hdrcols\tbllklastcol\tblind0\tblindtype3 \clvmrg\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\b';
    wwv_flow_api.g_varchar2_table(128) := 'rdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWi';
    wwv_flow_api.g_varchar2_table(129) := 'dth3\clwWidth2394\clshdrawnil \cellx2286\clvmrg\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brd';
    wwv_flow_api.g_varchar2_table(130) := 'rs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWid';
    wwv_flow_api.g_varchar2_table(131) := 'th3\clwWidth2394\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw';
    wwv_flow_api.g_varchar2_table(132) := '10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\clftsWidth3\clwW';
    wwv_flow_api.g_varchar2_table(133) := 'idth2394\clshdrawnil \cellx7074\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(134) := 'f1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth2394\';
    wwv_flow_api.g_varchar2_table(135) := 'clshdrawnil \cellx9468'||chr(10)||
'\pard\plain \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\as';
    wwv_flow_api.g_varchar2_table(136) := 'pnum\faauto\adjustright\rin0\lin0\pararsid6691967\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0';
    wwv_flow_api.g_varchar2_table(137) := ' \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 '||chr(10)||
'\af0 \ltrch\fcs0 \lang205';
    wwv_flow_api.g_varchar2_table(138) := '7\langfe1033\langnp2057\insrsid13435002 \cell \cell Cards\cell Northing'||chr(10)||
'\par }{\field\flddirty{\*\fl';
    wwv_flow_api.g_varchar2_table(139) := 'dinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 FORMTEXT}{\rtlch\fcs1 \af2 ';
    wwv_flow_api.g_varchar2_table(140) := '\ltrch\fcs0 \f2\insrsid13435002\charrsid14896649 {\*\datafield '||chr(10)||
'0001000000000000055465787431000b5750';
    wwv_flow_api.g_varchar2_table(141) := '52435f4f5347525f5900000000000f3c3f575052435f4f5347525f593f3e0000000000}{\*\formfield{\fftype0\ffowns';
    wwv_flow_api.g_varchar2_table(142) := 'tat\fftypetxt0{\*\ffname Text1}{\*\ffdeftext WPRC_OSGR_Y}{\*\ffstattext <?WPRC_OSGR_Y?>}}}}}{\fldrsl';
    wwv_flow_api.g_varchar2_table(143) := 't {\rtlch\fcs1 '||chr(10)||
'\af2 \ltrch\fcs0 \f2\lang1024\langfe1024\noproof\insrsid13435002\charrsid14896649 WP';
    wwv_flow_api.g_varchar2_table(144) := 'RC_OSGR_Y}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sec';
    wwv_flow_api.g_varchar2_table(145) := 'trsid10617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\lang2057\langfe1033\langnp2057\insrsid134350';
    wwv_flow_api.g_varchar2_table(146) := '02\charrsid14896649 \cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspn';
    wwv_flow_api.g_varchar2_table(147) := 'um\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\lan';
    wwv_flow_api.g_varchar2_table(148) := 'gfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\';
    wwv_flow_api.g_varchar2_table(149) := 'insrsid13435002 \trowd \irow1\irowband1\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrc';
    wwv_flow_api.g_varchar2_table(150) := 'f1 \trbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \tr';
    wwv_flow_api.g_varchar2_table(151) := 'brdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\t';
    wwv_flow_api.g_varchar2_table(152) := 'rpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastro';
    wwv_flow_api.g_varchar2_table(153) := 'w\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvmrg\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clb';
    wwv_flow_api.g_varchar2_table(154) := 'rdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\';
    wwv_flow_api.g_varchar2_table(155) := 'clftsWidth3\clwWidth2394\clshdrawnil \cellx2286\clvmrg\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbr';
    wwv_flow_api.g_varchar2_table(156) := 'drl\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\c';
    wwv_flow_api.g_varchar2_table(157) := 'lftsWidth3\clwWidth2394\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdr';
    wwv_flow_api.g_varchar2_table(158) := 's\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\cltxlrtb\clftsWidt';
    wwv_flow_api.g_varchar2_table(159) := 'h3\clwWidth2394\clshdrawnil \cellx7074\clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl\brdrs\brdrw1';
    wwv_flow_api.g_varchar2_table(160) := '0\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWid';
    wwv_flow_api.g_varchar2_table(161) := 'th2394\clshdrawnil \cellx9468\row '||chr(10)||
'}\pard\plain \ltrpar\qc \li0\ri0\sa200\widctlpar\intbl\wrapdefaul';
    wwv_flow_api.g_varchar2_table(162) := 't\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap2\pararsid6765518\yts15 \rtlch\fcs1 \af0\afs22\al';
    wwv_flow_api.g_varchar2_table(163) := 'ang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 '||chr(10)||
'{\*\bkmkstart Text3';
    wwv_flow_api.g_varchar2_table(164) := '}{\*\bkmkstart Text4}{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\insrsid3360042\c';
    wwv_flow_api.g_varchar2_table(165) := 'harrsid3360042  FORMTEXT }{\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\insrsid3360042\charrsid3360042 {\*\data';
    wwv_flow_api.g_varchar2_table(166) := 'field '||chr(10)||
'8001000000000000055465787434000246200000000000183c3f666f722d656163683a524f57534554315f524f573';
    wwv_flow_api.g_varchar2_table(167) := 'f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text4}{\*\ffdeftext F ';
    wwv_flow_api.g_varchar2_table(168) := '}{\*\ffstattext <?for-each:ROWSET1_ROW?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\lang1024\';
    wwv_flow_api.g_varchar2_table(169) := 'langfe1024\noproof\insrsid3360042\charrsid3360042 F }}}\sectd \linex0\headery708\footery708\colsx708';
    wwv_flow_api.g_varchar2_table(170) := '\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\*\bkmkstart Text5}{\*\bkmkend Text';
    wwv_flow_api.g_varchar2_table(171) := '4}'||chr(10)||
'{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518  FOR';
    wwv_flow_api.g_varchar2_table(172) := 'MTEXT }{\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518 {\*\datafield '||chr(10)||
'8001000000000';
    wwv_flow_api.g_varchar2_table(173) := '0000554657874350008434841525f53455100000000000c3c3f434841525f5345513f3e0000000000}{\*\formfield{\fft';
    wwv_flow_api.g_varchar2_table(174) := 'ype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text5}{\*\ffdeftext CHAR_SEQ}{\*\ffstattext <?CHAR_SEQ';
    wwv_flow_api.g_varchar2_table(175) := '?>}}}}}{\fldrslt {\rtlch\fcs1 \af2 '||chr(10)||
'\ltrch\fcs0 \f2\lang1024\langfe1024\noproof\insrsid3360042\charr';
    wwv_flow_api.g_varchar2_table(176) := 'sid6765518 CHAR_SEQ}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdef';
    wwv_flow_api.g_varchar2_table(177) := 'aultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\insrsid3360042\charrsid6765518 {\*';
    wwv_flow_api.g_varchar2_table(178) := '\bkmkend Text5}'||chr(10)||
'\par {\*\bkmkstart Text6}}{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 ';
    wwv_flow_api.g_varchar2_table(179) := '\f2\insrsid3360042\charrsid6765518  FORMTEXT }{\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charr';
    wwv_flow_api.g_varchar2_table(180) := 'sid6765518 {\*\datafield '||chr(10)||
'8001000000000000055465787436000f444f435f444154455f495353554544000000000013';
    wwv_flow_api.g_varchar2_table(181) := '3c3f444f435f444154455f4953535545443f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetx';
    wwv_flow_api.g_varchar2_table(182) := 't0{\*\ffname Text6}{\*\ffdeftext DOC_DATE_ISSUED}{\*\ffstattext '||chr(10)||
'<?DOC_DATE_ISSUED?>}}}}}{\fldrslt {';
    wwv_flow_api.g_varchar2_table(183) := '\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\lang1024\langfe1024\noproof\insrsid3360042\charrsid6765518 DOC_DATE';
    wwv_flow_api.g_varchar2_table(184) := '_ISSUED}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectr';
    wwv_flow_api.g_varchar2_table(185) := 'sid10617749\sftnbj {'||chr(10)||
'\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid3360042 {\*\bkmkend Text6}\nestcell{\nones';
    wwv_flow_api.g_varchar2_table(186) := 'ttables'||chr(10)||
'\par }}\pard \ltrpar\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\ad';
    wwv_flow_api.g_varchar2_table(187) := 'justright\rin0\lin0\itap2\pararsid14376119\yts15 {\*\bkmkstart Text7}{\field\flddirty{\*\fldinst {\r';
    wwv_flow_api.g_varchar2_table(188) := 'tlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518  '||chr(10)||
'FORMTEXT }{\rtlch\fcs1 \af2 \ltrch\f';
    wwv_flow_api.g_varchar2_table(189) := 'cs0 \f2\insrsid3360042\charrsid6765518 {\*\datafield 80010000000000000554657874370013575052434c5f524';
    wwv_flow_api.g_varchar2_table(190) := '54749535452595f46494c450000000000173c3f575052434c5f52454749535452595f46494c453f3e0000000000}'||chr(10)||
'{\*\for';
    wwv_flow_api.g_varchar2_table(191) := 'mfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text7}{\*\ffdeftext WPRCL_REGISTRY_FILE}{\*';
    wwv_flow_api.g_varchar2_table(192) := '\ffstattext <?WPRCL_REGISTRY_FILE?>}}}}}{\fldrslt {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\lang1024\langfe1';
    wwv_flow_api.g_varchar2_table(193) := '024\noproof\insrsid3360042\charrsid6765518 '||chr(10)||
'WPRCL_REGISTRY_FILE}}}\sectd \linex0\headery708\footery7';
    wwv_flow_api.g_varchar2_table(194) := '08\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\rtlch\fcs1 \af2 \ltrch\';
    wwv_flow_api.g_varchar2_table(195) := 'fcs0 \f2\insrsid3360042\charrsid6765518 {\*\bkmkend Text7}'||chr(10)||
'\par {\*\bkmkstart Text8}}{\field\flddirt';
    wwv_flow_api.g_varchar2_table(196) := 'y{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518  FORMTEXT }{\rtlch\fcs';
    wwv_flow_api.g_varchar2_table(197) := '1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518 {\*\datafield '||chr(10)||
'8001000000000000055465787438000';
    wwv_flow_api.g_varchar2_table(198) := '84855535f4e414d4500000000000c3c3f4855535f4e414d453f3e0000000000}{\*\formfield{\fftype0\ffownhelp\ffo';
    wwv_flow_api.g_varchar2_table(199) := 'wnstat\fftypetxt0{\*\ffname Text8}{\*\ffdeftext HUS_NAME}{\*\ffstattext <?HUS_NAME?>}}}}}{\fldrslt {';
    wwv_flow_api.g_varchar2_table(200) := '\rtlch\fcs1 \af2 '||chr(10)||
'\ltrch\fcs0 \f2\lang1024\langfe1024\noproof\insrsid3360042\charrsid6765518 HUS_NAM';
    wwv_flow_api.g_varchar2_table(201) := 'E}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrsid106';
    wwv_flow_api.g_varchar2_table(202) := '17749\sftnbj {\rtlch\fcs1 \af2 \ltrch\fcs0 '||chr(10)||
'\f2\insrsid3360042\charrsid6765518 {\*\bkmkend Text8} - ';
    wwv_flow_api.g_varchar2_table(203) := '{\*\bkmkstart Text9}}{\field\flddirty{\*\fldinst {\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\ch';
    wwv_flow_api.g_varchar2_table(204) := 'arrsid6765518  FORMTEXT }{\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\insrsid3360042\charrsid6765518 '||chr(10)||
'{\*\dataf';
    wwv_flow_api.g_varchar2_table(205) := 'ield 80010000000000000554657874390009444f435f444553435200000000000d3c3f444f435f44455343523f3e0000000';
    wwv_flow_api.g_varchar2_table(206) := '000}{\*\formfield{\fftype0\ffownhelp\ffownstat\fftypetxt0{\*\ffname Text9}{\*\ffdeftext DOC_DESCR}{\';
    wwv_flow_api.g_varchar2_table(207) := '*\ffstattext <?DOC_DESCR?>}}}}}{\fldrslt {'||chr(10)||
'\rtlch\fcs1 \af2 \ltrch\fcs0 \f2\lang1024\langfe1024\nopr';
    wwv_flow_api.g_varchar2_table(208) := 'oof\insrsid3360042\charrsid6765518 DOC_DESCR}}}\sectd \linex0\headery708\footery708\colsx708\endnher';
    wwv_flow_api.g_varchar2_table(209) := 'e\sectlinegrid360\sectdefaultcl\sectrsid10617749\sftnbj {\*\bkmkstart Text10}{\*\bkmkend Text9}'||chr(10)||
'{\fi';
    wwv_flow_api.g_varchar2_table(210) := 'eld\flddirty{\*\fldinst {\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\insrsid3360042\charrsid3360042  FORMTEXT ';
    wwv_flow_api.g_varchar2_table(211) := '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \cf9\insrsid3360042\charrsid3360042 {\*\datafield '||chr(10)||
'800100000000000006';
    wwv_flow_api.g_varchar2_table(212) := '546578743130000220450000000000103c3f656e6420666f722d656163683f3e0000000000}{\*\formfield{\fftype0\ff';
    wwv_flow_api.g_varchar2_table(213) := 'ownhelp\ffownstat\fftypetxt0{\*\ffname Text10}{\*\ffdeftext  E}{\*\ffstattext <?end for-each?>}}}}}{';
    wwv_flow_api.g_varchar2_table(214) := '\fldrslt {\rtlch\fcs1 \af0 '||chr(10)||
'\ltrch\fcs0 \cf9\lang1024\langfe1024\noproof\insrsid3360042\charrsid3360';
    wwv_flow_api.g_varchar2_table(215) := '042  E}}}\sectd \linex0\headery708\footery708\colsx708\endnhere\sectlinegrid360\sectdefaultcl\sectrs';
    wwv_flow_api.g_varchar2_table(216) := 'id10617749\sftnbj {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid3360042 {\*\bkmkend Text10}'||chr(10)||
'\nestcell{\nones';
    wwv_flow_api.g_varchar2_table(217) := 'ttables'||chr(10)||
'\par }}\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\ad';
    wwv_flow_api.g_varchar2_table(218) := 'justright\rin0\lin0\itap2 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033';
    wwv_flow_api.g_varchar2_table(219) := '\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\insrsid3360042 {\*\nesttableprops\tro';
    wwv_flow_api.g_varchar2_table(220) := 'wd \irow0\irowband0\lastrow \ltrrow\ts15\trgaph108\trleft0\trbrdrb\brdrdot\brdrw10 \trbrdrh\brdrs\br';
    wwv_flow_api.g_varchar2_table(221) := 'drw10 \trbrdrv\brdrs\brdrw10 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3';
    wwv_flow_api.g_varchar2_table(222) := '\trpaddft3\trpaddfb3\trpaddfr3\tblrsid6451980\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tb';
    wwv_flow_api.g_varchar2_table(223) := 'lind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb'||chr(10)||
'\brdrdot\brdrw10 \clbrdrr\brd';
    wwv_flow_api.g_varchar2_table(224) := 'rs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1980\clshdrawnil \cellx1980\clvertalt\clbrdrt\brdrtbl \clbr';
    wwv_flow_api.g_varchar2_table(225) := 'drl\brdrs\brdrw10 \clbrdrb\brdrdot\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth7380\clshd';
    wwv_flow_api.g_varchar2_table(226) := 'rawnil \cellx9360'||chr(10)||
'\nestrow}{\nonesttables'||chr(10)||
'\par }\ltrrow}\trowd \irow2\irowband2\ltrrow\ts15\trgaph10';
    wwv_flow_api.g_varchar2_table(227) := '8\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brd';
    wwv_flow_api.g_varchar2_table(228) := 'rcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\';
    wwv_flow_api.g_varchar2_table(229) := 'trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\';
    wwv_flow_api.g_varchar2_table(230) := 'tblrsid3360042\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\cl';
    wwv_flow_api.g_varchar2_table(231) := 'brdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\';
    wwv_flow_api.g_varchar2_table(232) := 'brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\pard\plain \ltrpar'||chr(10)||
'\';
    wwv_flow_api.g_varchar2_table(233) := 'ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid1';
    wwv_flow_api.g_varchar2_table(234) := '3435002\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\langn';
    wwv_flow_api.g_varchar2_table(235) := 'p1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid3360042 {\*';
    wwv_flow_api.g_varchar2_table(236) := '\bkmkend Text3}\cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\fa';
    wwv_flow_api.g_varchar2_table(237) := 'auto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe10';
    wwv_flow_api.g_varchar2_table(238) := '33\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrs';
    wwv_flow_api.g_varchar2_table(239) := 'id3360042 \trowd \irow2\irowband2\ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \tr';
    wwv_flow_api.g_varchar2_table(240) := 'brdrl\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\';
    wwv_flow_api.g_varchar2_table(241) := 'brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl';
    wwv_flow_api.g_varchar2_table(242) := '108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbll';
    wwv_flow_api.g_varchar2_table(243) := 'khdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\b';
    wwv_flow_api.g_varchar2_table(244) := 'rdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\c';
    wwv_flow_api.g_varchar2_table(245) := 'lwWidth9576\clshdrawnil \cellx9468\row \ltrrow}\trowd \irow3\irowband3\lastrow \ltrrow\ts15\trgaph10';
    wwv_flow_api.g_varchar2_table(246) := '8\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trbrdrl\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\br';
    wwv_flow_api.g_varchar2_table(247) := 'drcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(248) := '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3';
    wwv_flow_api.g_varchar2_table(249) := '\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\c';
    wwv_flow_api.g_varchar2_table(250) := 'lbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr';
    wwv_flow_api.g_varchar2_table(251) := '\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\pard\plain \ltrpar'||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(252) := '\ql \li0\ri0\sa200\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid';
    wwv_flow_api.g_varchar2_table(253) := '14376119\yts15 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \f37\fs22\lang1033\langfe1033\cgrid\lang';
    wwv_flow_api.g_varchar2_table(254) := 'np1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 '||chr(10)||
'\lang2057\langfe1033\langnp2057\insrsid13435002 \';
    wwv_flow_api.g_varchar2_table(255) := 'cell }\pard\plain \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright';
    wwv_flow_api.g_varchar2_table(256) := '\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 '||chr(10)||
'\f37\fs22\lang1033\langfe1033\cgrid\langnp1';
    wwv_flow_api.g_varchar2_table(257) := '033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\langfe1033\langnp2057\insrsid13435002 \trow';
    wwv_flow_api.g_varchar2_table(258) := 'd \irow3\irowband3\lastrow \ltrrow\ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10\brdrcf1 \trbrdrl'||chr(10)||
'';
    wwv_flow_api.g_varchar2_table(259) := '\brdrs\brdrw10\brdrcf1 \trbrdrb\brdrs\brdrw10\brdrcf1 \trbrdrr\brdrs\brdrw10\brdrcf1 \trbrdrh\brdrs\';
    wwv_flow_api.g_varchar2_table(260) := 'brdrw10\brdrcf1 \trbrdrv\brdrs\brdrw10\brdrcf1 '||chr(10)||
'\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\tr';
    wwv_flow_api.g_varchar2_table(261) := 'paddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid3360042\tbllkhdrrows\tbllklastrow\tbllkhdrco';
    wwv_flow_api.g_varchar2_table(262) := 'ls\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrs\brdrw10\brdrcf1 \clbrdrl'||chr(10)||
'\brdrs\brdrw10';
    wwv_flow_api.g_varchar2_table(263) := '\brdrcf1 \clbrdrb\brdrs\brdrw10\brdrcf1 \clbrdrr\brdrs\brdrw10\brdrcf1 \cltxlrtb\clftsWidth3\clwWidt';
    wwv_flow_api.g_varchar2_table(264) := 'h9576\clshdrawnil \cellx9468\row }\pard \ltrpar'||chr(10)||
'\ql \li0\ri0\sa200\widctlpar\wrapdefault\aspalpha\as';
    wwv_flow_api.g_varchar2_table(265) := 'pnum\faauto\adjustright\rin0\lin0\itap0\pararsid15428369 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2057\lan';
    wwv_flow_api.g_varchar2_table(266) := 'gfe1033\langnp2057\insrsid13435002\charrsid16665483 '||chr(10)||
'\par }}';
 
end;
/

--application/shared_components/reports/report_layouts/report_card
begin
wwv_flow_api.create_report_layout(
  p_id => 1325207339400801 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_report_layout_name =>'Report Card',
  p_report_layout_type =>'RTF_FILE',
  p_varchar2_table => wwv_flow_api.g_varchar2_table,
  p_xslfo_column_heading =>'',
  p_xslfo_column_template =>'',
  p_xslfo_column_template_width =>'',
  p_reference_id =>null,
  p_report_layout_comment =>'');
end;
/
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
