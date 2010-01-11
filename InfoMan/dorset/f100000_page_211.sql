set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100000 - Enquiries POD
--
-- Application Export:
--   Application:     100000
--   Name:            Enquiries POD
--   Date and Time:   15:34 Thursday January 7, 2010
--   Exported By:     CHACKFORTH
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.10
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
 
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
  wwv_flow_api.set_security_group_id(p_security_group_id=>994322674405384);
 
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
   wwv_flow.g_flow_id := 100000;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

PROMPT ...Remove page 211
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>211);
 
end;
/

 
--application/pages/page_00211
prompt  ...PAGE 211: IM100211 - Enquiries Type over time
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 211,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'IM100211 - Enquiries Type over time',
  p_alias  => 'IM100211',
  p_step_title=> 'IM100211 - Enquiries Type over time',
  p_html_page_onload=>' class=" yui-skin-sam";',
  p_step_sub_title => 'IM100211 - Enquiries Type over time',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => 63297039385168854+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'GBLEAKLEY',
  p_last_upd_yyyymmddhh24miss => '20091218113842',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>211,p_text=>h);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"'||chr(10)||
'	codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"'||chr(10)||
'	width="#WIDTH#"'||chr(10)||
'	height="#HEIGHT#"'||chr(10)||
'	id="#CHART_NAME#"'||chr(10)||
'	align="">'||chr(10)||
'<param name="movie" value="#IMAGE_PREFIX#flashchart/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:211:&APP_SESSION.:FLOW_FLASH_CHART_R#REGION_ID#">'||chr(10)||
'<param name="qual';

s:=s||'ity" value="high">'||chr(10)||
'<param name="allowScriptAccess" value="sameDomain">'||chr(10)||
'<param name="allowNetworking" value="all">'||chr(10)||
'<param name="scale" value="noscale">'||chr(10)||
'<param name="wmode" value="transparent">'||chr(10)||
'<param name="FlashVars" value="waiting=#FLASH_WAITING#&loading=#FLASH_LOADING#">'||chr(10)||
''||chr(10)||
'<embed src="#IMAGE_PREFIX#flashchart/#CHART_TYPE#.swf?XMLFile=#HOST#apex_util.flash?p=&APP_ID.:211:&APP_SESSION.:FLOW_FLASH_CH';

s:=s||'ART_R#REGION_ID#"'||chr(10)||
'       quality="high"'||chr(10)||
'       width="#WIDTH#"'||chr(10)||
'       height="#HEIGHT#"'||chr(10)||
'       name="#CHART_NAME#"'||chr(10)||
'       scale="noscale"'||chr(10)||
'       align=""'||chr(10)||
'       allowScriptAccess="sameDomain" '||chr(10)||
'       allowNetworking="all"'||chr(10)||
'       type="application/x-shockwave-flash"'||chr(10)||
'       pluginspage="http://www.macromedia.com/go/getflashplayer"'||chr(10)||
'       wmode="transparent"'||chr(10)||
'       FlashVars="waiting=#FLASH_WAITING#&';

s:=s||'loading=#FLASH_LOADING#">'||chr(10)||
'</embed>'||chr(10)||
'</object>'||chr(10)||
'#CHART_REFRESH#';

wwv_flow_api.create_page_plug (
  p_id=> 1146209930509012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 211,
  p_plug_name=> 'Enquiries type over time',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 2,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'FLASH_CHART',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'im_framework.user_can_run_module(v(''APP_USER''),''IM100211'');',
  p_plug_customized=>'0',
  p_plug_caching=> 'CACHED',
  p_plug_caching_session_state=>    '',
  p_plug_caching_max_age_in_sec=>   3600,
  p_plug_cache_when_cond_type =>    '0',
  p_plug_cache_when_condition_e1 => '',
  p_plug_cache_when_condition_e2 => '',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1 := null;
wwv_flow_api.create_flash_chart(
  p_id => 1146414730509012+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 211,
  p_region_id => 1146209930509012+wwv_flow_api.g_id_offset,
  p_default_chart_type  =>'3DColumn',
  p_chart_title         =>'',
  p_chart_width         =>600,
  p_chart_height        =>400,
  p_chart_animation     =>'alpha',
  p_display_attr        =>'H:N:V:N:BACK:R',
  p_dial_tick_attr      =>'::',
  p_margins             =>':::',
  p_omit_label_interval =>null,
  p_bgtype              =>'TRANSPARENT',
  p_bgcolor1            =>'',
  p_bgcolor2            =>'',
  p_gradient_rotation   =>null,
  p_color_scheme        =>'1',
  p_custom_colors       =>'',
  p_x_axis_title        =>'Status',
  p_x_axis_min          =>null,
  p_x_axis_max          =>null,
  p_x_axis_grid_spacing =>null,
  p_x_axis_prefix       =>'',
  p_x_axis_postfix      =>'',
  p_x_axis_group_sep    =>'',
  p_x_axis_decimal_place=>null,
  p_y_axis_title        =>'Number',
  p_y_axis_min          =>null,
  p_y_axis_max          =>null,
  p_y_axis_grid_spacing =>null,
  p_y_axis_prefix       =>'',
  p_y_axis_postfix      =>'',
  p_y_axis_group_sep    =>'N',
  p_y_axis_decimal_place=>null,
  p_async_update        =>'N',
  p_async_time          =>null,
  p_names_font          =>'Verdana:10:#000000',
  p_names_rotation      =>null,
  p_values_font         =>'Verdana:10:#000000',
  p_values_rotation     =>null,
  p_hints_font          =>'Verdana:10:#000000',
  p_legend_font         =>'Verdana:10:#000000',
  p_grid_labels_font    =>'Verdana:10:#000000',
  p_chart_title_font    =>'Verdana:14:#000000',
  p_x_axis_title_font   =>'Verdana:14:#000000',
  p_y_axis_title_font   =>'Verdana:14:#000000',
  p_use_chart_xml       =>'N',
  p_chart_xml           => a1,
  p_attribute_01        =>'',
  p_attribute_02        =>'',
  p_attribute_03        =>'',
  p_attribute_04        =>'',
  p_attribute_05        =>'');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'select ''javascript:showDrillDown(&APP_ID.,&APP_SESSION., ''''212'''', ''''P212_STATUS'''',''''''||label||'''''''||chr(10)||
', null, null, null,null, null,null,null,null);'' as link,label,value from'||chr(10)||
'(select imf_translate(status_code) label, sum(value) value'||chr(10)||
'from'||chr(10)||
'(select'||chr(10)||
'--(case when rownum <10 then status_code else ''Other'' end) '||chr(10)||
'status_code,value'||chr(10)||
'from'||chr(10)||
'(select status_code,sum(case when status_code = ''RE'' then -1 else 1 end) a';

a1:=a1||'s value'||chr(10)||
'from imf_enq_enquiries'||chr(10)||
'where status_code is not null'||chr(10)||
'and date_recorded between :P211_start and :P211_end'||chr(10)||
'group by status_code))'||chr(10)||
'group by status_code)';

wwv_flow_api.create_flash_chart_series(
  p_id => 1146520951509014+wwv_flow_api.g_id_offset,
  p_chart_id => 1146414730509012+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_series_seq                =>10,
  p_series_name               =>'Series 1',
  p_series_query              => a1,
  p_series_query_type         =>'SQL_QUERY',
  p_series_query_parse_opt    =>'PARSE_CHART_QUERY',
  p_series_query_no_data_found=>'No data found.',
  p_series_query_row_count_max=>15);
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 1166130201703045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 211,
  p_plug_name=> 'Params',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 1,
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
  p_plug_header=> '<table width="450" border="0"> '||chr(10)||
'<tr>'||chr(10)||
'<td align="left"> '||chr(10)||
'<span class="exorPODTitle">Enquiries Type over time</span>'||chr(10)||
'</td> '||chr(10)||
'<td align="right"> '||chr(10)||
'<a href="javascript:podInfo(''IM100211'',''$Revision:   3.0  $'')"><img class="podIcons" src="/im4_framework/info_icon.jpg" alt="Pod Info"></img></a>'||chr(10)||
'</td> '||chr(10)||
'<td align="left"> '||chr(10)||
'<!-- manually choose the icon that is appropriate -->'||chr(10)||
'<img class="podIcons" src="/im4_framework/green_down_arrow.png" alt="Drill down for more detail."></img></a>'||chr(10)||
'</td>'||chr(10)||
'<td align="left"> '||chr(10)||
'<!-- manually choose the icon that is appropriate -->'||chr(10)||
'<img class="podIcons" src="/im4_framework/redflag.jpg" alt="This POD will not be affected by location"></img></a>'||chr(10)||
'</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br>'||chr(10)||
'<table width="400" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left"> '||chr(10)||
'<span style="display:block;width=400px;font-size:10pt;color=006261">Enter Date range, or leave the defaults for all Enquiries</span>'||chr(10)||
'</td> '||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_plug_customized=>'0',
  p_plug_caching=> 'CACHED',
  p_plug_caching_session_state=>    '',
  p_plug_caching_max_age_in_sec=>   3600,
  p_plug_cache_when_cond_type =>    '0',
  p_plug_cache_when_condition_e1 => '',
  p_plug_cache_when_condition_e2 => '',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1167404752733525 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 211,
  p_branch_action=> 'f?p=&APP_ID.:211:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>1167226785730417+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 11-NOV-2009 15:57 by GBLEAKLEY');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1165723836691706 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 211,
  p_name=>'P211_START',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 21,
  p_item_plug_id => 1166130201703045+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_date(''01-JAN-1950'',''DD-MON-YYYY'')',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'From Date',
  p_source=>'to_date(''01-JAN-1950'',''DD-MON-YYYY'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'PICK_DATE_USING_APP_DATE_FORMAT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63302846747168891+wwv_flow_api.g_id_offset,
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
  p_id=>1166016349699014 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 211,
  p_name=>'P211_END',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 22,
  p_item_plug_id => 1166130201703045+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_date(sysdate,''DD-MON-YYYY'')',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'To Date',
  p_source=>'to_date(sysdate,''DD-MON-YYYY'')',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'PICK_DATE_USING_FLOW_FORMAT_MASK',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 63302846747168891+wwv_flow_api.g_id_offset,
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
  p_id=>1167226785730417 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 211,
  p_name=>'P211_GO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 23,
  p_item_plug_id => 1166130201703045+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default => 'P211_GO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Go',
  p_source=>'P211_GO',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT-CENTER',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 211
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
