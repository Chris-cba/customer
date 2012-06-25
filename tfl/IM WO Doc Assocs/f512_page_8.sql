set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 512 - WO_WORKTRAY_TFL
--
-- Application Export:
--   Application:     512
--   Name:            WO_WORKTRAY_TFL
--   Date and Time:   10:39 Monday June 25, 2012
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.1.00.12
 
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
   wwv_flow.g_flow_id := 512;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

PROMPT ...Remove page 8
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>8);
 
end;
/

 
--application/pages/page_00008
prompt  ...PAGE 8: WO Document Associations
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 8,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'WO Document Associations',
  p_step_title=> 'Wo Document Associations',
  p_html_page_onload=>'class=" yui-skin-sam";',
  p_step_sub_title => 'Wo Document Associations',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => 79690700470672275+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20120625103710',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>8,p_text=>h);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select * '||chr(10)||
'from ('||chr(10)||
'select 1 sort_order'||chr(10)||
'      ,decode(das_table_name,''WORK_ORDERS'',''Work Order'''||chr(10)||
'                            ,''WORK_ORDER_LINES'',''Work Order Line'''||chr(10)||
'                            ,''DEFECTS'',''Defect'''||chr(10)||
'                            ,''Other'') doc_source'||chr(10)||
'      ,doc_title    '||chr(10)||
'      ,doc_descr'||chr(10)||
',CASE  lower(substr(doc_file,instr(doc_file,''.'')+1,3))'||chr(10)||
'  WHEN ''pdf'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_path';

s:=s||'name||doc_file||''" target="_blank"><img src="/im4_framework/images/pdf_64.gif" width="64" height="64" align=center valign=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''doc'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="/im4_framework/images/word_icon.jpg" width="64" height="64" align=center valign=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
''||chr(10)||
'  WHEN ''gif''  THEN'||chr(10)||
'      ';

s:=s||' ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''jpg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''jpeg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathn';

s:=s||'ame||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''png''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  ELSE '||chr(10)||
'        ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank">Clic';

s:=s||'k to View</a>'' '||chr(10)||
'END imageurl'||chr(10)||
'from doc_assocs'||chr(10)||
'    , docs '||chr(10)||
'    , doc_locations'||chr(10)||
'where das_table_name = ''WORK_ORDERS'''||chr(10)||
'and doc_id = das_doc_id'||chr(10)||
'and das_rec_id = :P8_WOID'||chr(10)||
'and doc_dlc_id = dlc_id'||chr(10)||
'union'||chr(10)||
'select 2 sort_order'||chr(10)||
'      ,decode(das_table_name,''WORK_ORDERS'',''Work Order'''||chr(10)||
'                            ,''WORK_ORDER_LINES'',''Work Order Line'''||chr(10)||
'                            ,''DEFECTS'',''Defect'''||chr(10)||
'                ';

s:=s||'            ,''Other'') doc_source'||chr(10)||
'      ,doc_title    '||chr(10)||
'      ,doc_descr'||chr(10)||
',CASE  lower(substr(doc_file,instr(doc_file,''.'')+1,3))'||chr(10)||
'  WHEN ''pdf'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="/im4_framework/images/pdf_64.gif" width="64" height="64" align=center valign=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''doc'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_fi';

s:=s||'le||''" target="_blank"><img src="/im4_framework/images/word_icon.jpg" width="64" height="64" align=center valign=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
''||chr(10)||
'  WHEN ''gif''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''jpg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_f';

s:=s||'ile||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''jpeg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''png''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><im';

s:=s||'g src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  ELSE '||chr(10)||
'        ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank">Click to View</a>'' '||chr(10)||
'END imageurl'||chr(10)||
'from doc_assocs'||chr(10)||
'    , docs '||chr(10)||
'    , doc_locations'||chr(10)||
'where das_table_name = ''WORK_ORDER_LINES'''||chr(10)||
'and doc_id = das_doc_id'||chr(10)||
'and das_rec_id in (select to_char(wol_id)'||chr(10)||
'                  from work_order_line';

s:=s||'s'||chr(10)||
'                  where wol_works_order_no = :P8_WOID)'||chr(10)||
'and doc_dlc_id = dlc_id'||chr(10)||
'union'||chr(10)||
'select 3 sort_order'||chr(10)||
'      ,decode(das_table_name,''WORK_ORDERS'',''Work Order'''||chr(10)||
'                            ,''WORK_ORDER_LINES'',''Work Order Line'''||chr(10)||
'                            ,''DEFECTS'',''Defect'''||chr(10)||
'                            ,''Other'') doc_source'||chr(10)||
'      ,doc_title    '||chr(10)||
'      ,doc_descr'||chr(10)||
',CASE  lower(substr(doc_file,instr(d';

s:=s||'oc_file,''.'')+1,3))'||chr(10)||
'  WHEN ''pdf'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="/im4_framework/images/pdf_64.gif" width="64" height="64" align=center valign=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''doc'' THEN '||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="/im4_framework/images/word_icon.jpg" width="64" height="64" align=center v';

s:=s||'align=middle alt="''|| doc_file ||''" ></a>'' '||chr(10)||
''||chr(10)||
'  WHEN ''gif''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''jpg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_f';

s:=s||'ile ||''" ></a>'' '||chr(10)||
'  WHEN ''jpeg''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  WHEN ''png''  THEN'||chr(10)||
'       ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank"><img src="''||dlc_url_pathname||doc_file||''" width="100" height="100" alt="''|| doc_file ||''" ></a>'' '||chr(10)||
'  ELSE '||chr(10)||
'  ';

s:=s||'      ''<a href="''||dlc_url_pathname||doc_file||''" target="_blank">Click to View</a>'' '||chr(10)||
'END imageurl'||chr(10)||
'from doc_assocs'||chr(10)||
'    , docs '||chr(10)||
'    , doc_locations'||chr(10)||
'where das_table_name = ''DEFECTS'''||chr(10)||
'and doc_id = das_doc_id'||chr(10)||
'and das_rec_id in (select to_char(wol_def_defect_id)'||chr(10)||
'                   from work_order_lines'||chr(10)||
'                   where wol_works_order_no = :P8_WOID)'||chr(10)||
'and doc_dlc_id = dlc_id'||chr(10)||
')'||chr(10)||
'order by sort_order';

wwv_flow_api.create_report_region (
  p_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 8,
  p_name=> 'Document Associations [These documents relate to Enquiry ID &P8_WOID.]',
  p_region_name=>'',
  p_template=> 0+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 79695693538672306+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No data found.',
  p_query_num_rows_type=> '0',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
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
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 2217908938785623 + wwv_flow_api.g_id_offset,
  p_region_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SORT_ORDER',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Sort Order',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
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
  p_id=> 2218009581785628 + wwv_flow_api.g_id_offset,
  p_region_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_SOURCE',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Source',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
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
  p_id=> 2218113191785628 + wwv_flow_api.g_id_offset,
  p_region_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_TITLE',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Document Title',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
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
  p_id=> 2218210844785628 + wwv_flow_api.g_id_offset,
  p_region_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'DOC_DESCR',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Document Description',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
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
  p_id=> 2218317435785628 + wwv_flow_api.g_id_offset,
  p_region_id=> 2217714025785584 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'IMAGEURL',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Preview',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
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
  p_id=>2218406768785629 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_WOID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2217714025785584+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'WOID',
  p_source=>'106_LS/7873',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>2218619234785643 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 8,
  p_name=>'P8_DAS_TABLE_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2217714025785584+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Das Table Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_field_template => 79696293461672312+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 8
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
