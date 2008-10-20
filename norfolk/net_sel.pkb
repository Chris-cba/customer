CREATE OR REPLACE PACKAGE BODY net_sel AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/norfolk/net_sel.pkb-arc   1.0   Oct 20 2008 16:32:56   smarshall  $
--       Module Name      : $Workfile:   net_sel.pkb  $
--       Date into PVCS   : $Date:   Oct 20 2008 16:32:56  $
--       Date fetched Out : $Modtime:   Oct 20 2008 16:27:28  $
--       PVCS Version     : $Revision:   1.0  $

-----------------------------------------------------------------------------
--   Originally taken from '@(#)net_sel.pck	1.26 08/19/03'
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here

-- This is hacked by RC to cater for Norfolk groups of sections (group of groups)
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

  g_package_name CONSTANT varchar2(30) := 'net_sel';
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
FUNCTION run_dynamic_sql (p_sql_text IN VARCHAR2) RETURN NUMBER  IS

	cdsql			   INTEGER := DBMS_SQL.OPEN_CURSOR;
	v_sql_text		VARCHAR2(32767) := p_sql_text;
	v_ex_feedback	INTEGER ;
   lb_rows        BOOLEAN := FALSE;
   lc_dummy       VARCHAR2(1);

BEGIN
	dbms_output.put_line(v_sql_text);
	cdsql := DBMS_SQL.OPEN_CURSOR;
	DBMS_SQL.PARSE (	cdsql,
				v_sql_text,
				DBMS_SQL.NATIVE);

	v_ex_feedback := DBMS_SQL.EXECUTE(cdsql);
   DBMS_SQL.CLOSE_CURSOR(cdsql);
   RETURN DBMS_SQL.FETCH_ROWS(cdsql);
EXCEPTION
  WHEN others then
    err_string  := sqlerrm;
    RETURN -1;
END;
--
-----------------------------------------------------------------------------
--
Procedure transform_operator (user_op in hig_codes.hco_code%TYPE,
                                    code_op out hig_codes.hco_code%TYPE) is

Begin
  if user_op = 'OR' then
     code_op := 'UNION';
  elsif user_op = 'AND' then
     code_op := 'INTERSECT';
  elsif user_op = 'EXCLUDE' then
     code_op := 'MINUS';
  end if;
End;
--
-----------------------------------------------------------------------------
--
Procedure select_process (road_group in road_segs.rse_he_id%TYPE,
                                result out number) is

cursor select_exists is
  select rse_he_id
  from   road_groups
  where  rse_he_id = road_group;

cursor criteria is
  select nscr_id, nscr_criteria, nscr_operator
  from   net_sel_criteria
  where  nscr_net_sel_id = road_group
  order by nscr_seq;

pn_road_group road_segs.rse_he_id%TYPE := null;
pn_count number := 1;
pc_insert varchar2(32767) := null;
pc_operator hig_codes.hco_code%TYPE := null;

Begin

  result := 0;

  open select_exists;
  fetch select_exists into pn_road_group;

  if select_exists%found then
     close select_exists;
--     pc_sql := 'delete from road_seg_membs where rsm_rse_he_id_in = '||pn_road_group;
--     result := populate_road_gp_members;
     pc_sql := 'delete from nm_members_all where nm_ne_id_in = '||pn_road_group;
     result := populate_road_gp_members;
  else
     close select_exists;
  end if;
  result := 0;
  pc_sql := null;
--  pc_insert := 'insert into road_seg_membs '||
--               '(rsm_rse_he_id_in, rsm_rse_he_id_of, rsm_start_date, rsm_seq_no, rsm_type) ';
  pc_insert := 'insert into nm_members_all '||
               '(nm_ne_id_in, nm_ne_id_of, nm_start_date, nm_seq_no, nm_type, nm_obj_type, nm_begin_mp, nm_end_mp, nm_admin_unit) ';
  pc_sql := pc_insert;

  FOR criteria_rec in criteria LOOP
      transform_operator(criteria_rec.nscr_operator,pc_operator);
      if pn_count > 1 and pc_operator is not null then
         pc_sql := pc_sql||' '||pc_operator||' (';
      end if;

      if criteria_rec.nscr_criteria = 'ROAD NETWORK' then
         select_roads(criteria_rec.nscr_id, road_group);
      elsif criteria_rec.nscr_criteria = 'FEATURES/SURVEYS' then
         pc_sql2 := null;
          select_assets(criteria_rec.nscr_id, road_group);
         if pc_sql2 is not null then
            pc_sql2 := pc_sql2||' order by 1';
         end if;
      elsif criteria_rec.nscr_criteria = 'ENQUIRIES' then
         select_enquiries(criteria_rec.nscr_id, road_group);
      elsif criteria_rec.nscr_criteria = 'DEFECTS' then
         select_defects(criteria_rec.nscr_id, road_group);
      end if;
      if pn_count > 1 and pc_operator is not null then
         pc_sql := pc_sql||') ';
      end if;

      pn_count := pn_count + 1;

END LOOP;

  if rtrim(pc_sql,' ') <> rtrim(pc_insert,' ') or pc_sql2 is not null then
    result := populate_road_gp_members;
    commit;
  end if;
  -- 711224 JW 23-JUL-2008 
  -- This variable needs to be cleared after each call to ensure that no constraint
  -- errors occur on nm_members_all  
  pc_sql2 := null; 
Exception
    when others then
    /* trap the error string */
    err_string := sqlerrm;
    commit;
    raise_application_error( -20002, err_string );
End;
--
-----------------------------------------------------------------------------
--
Procedure select_roads (nscr_id in net_sel_criteria.nscr_id%TYPE,
                              road_group in road_segs.rse_he_id%TYPE) is

cursor roads is
 select nsr_nscr_id,
        nsr_rse_unique,
        nsr_rse_admin_unit,
        nsr_unit_code,
        nsr_rse_type,
        nsr_rse_gty_group_type,
        nsr_rse_sys_flag,
        handle_quotes(nsr_rse_descr) nsr_rse_descr,
        nsr_rse_carriageway_type,
        nsr_rse_maint_category,
        nsr_rse_road_environment,
        nsr_road_hierarchy,
        nsr_operator,               
        nsr_rec_id,
        nsr_ref_id
 from   net_sel_roads
 where  nsr_nscr_id = nscr_id
 order by nsr_rec_id;

cursor road_gty_type is
 select rse_gty_group_type, rse_admin_unit
   from road_segs
  where rse_he_id = road_group;

 l_rse_gty_group_type road_segs.rse_gty_group_type%TYPE;
 l_admin_unit         road_segs.rse_admin_unit%TYPE;
 pn_count number := 1;
 pc_operator hig_codes.hco_code%TYPE := null;
 
Begin

  FOR roads_rec in roads LOOP
      transform_operator(roads_rec.nsr_operator,pc_operator);
      if pn_count > 1 then
         pc_sql := pc_sql||' '||pc_operator||' ';
      end if;

      open road_gty_type;
      fetch road_gty_type into l_rse_gty_group_type, l_admin_unit;
      close road_gty_type;
      
      -- Log 711224 JW 18-JUL-2008 
      --  
      -- Added missing columns to the dynamic sql statement where the rse_type = 'G'
      --     
      if nm3net.IS_GTY_PARTIAL( l_rse_gty_group_type ) = 'Y' then
      if roads_rec.nsr_rse_type = 'G' then

         if roads_rec.nsr_rse_admin_unit is not null then
            pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rsm_rse_he_id_of,trunc(sysdate),1,'||''''||'G'||''''
                            ||', '||chr(39)||roads_rec.nsr_rse_unique||chr(39)||', rsm_begin_mp, rsm_end_mp,'||to_char(l_admin_unit)
                            ||' from road_seg_membs where ';                           
            pc_sql := pc_sql||'rsm_rse_he_id_in in (select rse_he_id from road_groups where rse_sys_flag = '''||lc_sys_flag||''' and ';
         else
            pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rsm_rse_he_id_of,trunc(sysdate),1,'||''''||'G'||''''
                            ||', '||chr(39)||roads_rec.nsr_rse_unique||chr(39)||', rsm_begin_mp, rsm_end_mp, null'
                            ||' from road_seg_membs where ';                           
            pc_sql := pc_sql||'rsm_rse_he_id_in in (select rse_he_id from road_groups where rse_sys_flag = '''||lc_sys_flag||''' and ';
         end if;

      else
         pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rse_he_id,trunc(sysdate),1,'||''''||'G'||''''
                         ||','||''''||l_rse_gty_group_type||''''||',nvl(rse_begin_mp,0),nvl(rse_end_mp,rse_length),'||to_char(l_admin_unit)
                         ||' from road_sections where rse_sys_flag = '''||lc_sys_flag||'''and ';                           
      end if;

      else

      if roads_rec.nsr_rse_type = 'G' then

         if roads_rec.nsr_rse_admin_unit is not null then
            pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rsm_rse_he_id_of,trunc(sysdate),1,'||''''||'G'||''''
                            ||', '||chr(39)||roads_rec.nsr_rse_unique||chr(39)||', 0, 0,'||to_char(l_admin_unit)
                            ||' from road_seg_membs where ';                           
            pc_sql := pc_sql||'rsm_rse_he_id_in in (select rse_he_id from road_groups where rse_sys_flag = '''||lc_sys_flag||''' and ';
         else
            pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rsm_rse_he_id_of,trunc(sysdate),1,'||''''||'G'||''''
                            ||', '||chr(39)||roads_rec.nsr_rse_unique||chr(39)||', 0, 0, null'
                            ||' from road_seg_membs where ';                           
            pc_sql := pc_sql||'rsm_rse_he_id_in in (select rse_he_id from road_groups where rse_sys_flag = '''||lc_sys_flag||''' and ';
         end if;

      else
         pc_sql := pc_sql||'select /* NETWORK */ '||road_group||',rse_he_id,trunc(sysdate),1,'||''''||'G'||''''
                         ||','||''''||l_rse_gty_group_type||''''||',0, 0,'||to_char(l_admin_unit)
                         ||' from road_sections where rse_sys_flag = '''||lc_sys_flag||'''and ';                           
      end if;
      
      end if;

      if roads_rec.nsr_rse_unique is not null then
         if instr(roads_rec.nsr_rse_unique,'%',1,1) > 0 then
            pc_sql := pc_sql||' rse_unique like '||''''||roads_rec.nsr_rse_unique||''''||' and ';
         else
            pc_sql := pc_sql||' rse_unique = '||''''||roads_rec.nsr_rse_unique||''''||' and ';
         end if;
      end if;

      if roads_rec.nsr_rse_admin_unit is not null then
         pc_sql := pc_sql||' rse_admin_unit = '||roads_rec.nsr_rse_admin_unit||' and ';
      end if;

      if roads_rec.nsr_rse_type is not null then
         pc_sql := pc_sql||' rse_type = '||''''||roads_rec.nsr_rse_type||''''||' and ';
      end if;

      if roads_rec.nsr_rse_gty_group_type is not null then
         pc_sql := pc_sql||' rse_gty_group_type = '||''''||roads_rec.nsr_rse_gty_group_type||''''||' and ';
      end if;

      if roads_rec.nsr_rse_sys_flag is not null then
         pc_sql := pc_sql||' rse_sys_flag = '||''''||roads_rec.nsr_rse_sys_flag||''''||' and ';
      end if;

      if roads_rec.nsr_rse_unique is null then
         if roads_rec.nsr_rse_descr is not null then
            pc_sql := pc_sql||' rse_descr like '||''''||roads_rec.nsr_rse_descr||''''||' and ';
         end if;
      end if;

      if roads_rec.nsr_rse_road_environment is not null then
         pc_sql := pc_sql||' rse_road_environment = '||''''||
                           roads_rec.nsr_rse_road_environment||''''||' and ';
      end if;

--    Log 711224 JW 18-JUL-2008 
--    Columns rse_carriageway_type, rse_maint_category and road_hierarchy do not exist
--   in the road_groups view and cause the dynamic sql statement to fail. 
--
--
--      if roads_rec.nsr_rse_carriageway_type is not null then  
--         pc_sql := pc_sql||' rse_carriageway_type = '||''''|| 
--                           roads_rec.nsr_rse_carriageway_type||''''||' and ';
--      end if;
--
--      if roads_rec.nsr_rse_maint_category is not null then 
--         pc_sql := pc_sql||' rse_maint_category = '||''''|| 
--                           roads_rec.nsr_rse_maint_category||''''||' and '; 
--      end if;
--
--
--      if roads_rec.nsr_road_hierarchy is not null then 
--         pc_sql := pc_sql||' road_hierarchy = '||''''||roads_rec.nsr_road_hierarchy||''''||' and '; 
--      end if; 

      pc_sql := pc_sql||' 1 = 1';

      if roads_rec.nsr_rse_type = 'G' then
         pc_sql := pc_sql||')';
      end if;

      pn_count := pn_count + 1;

  END LOOP;

Exception
    when others then
    /* trap the error string */
      err_string := sqlerrm;
      raise_application_error( -20001, err_string );
End;
--
-----------------------------------------------------------------------------
--
Procedure select_assets (nscr_id in net_sel_criteria.nscr_id%TYPE,
                               road_group in road_segs.rse_he_id%TYPE) is

cursor assets is
  select nsi_nscr_id,
         nsi_id,
         nsi_iit_sys_flag,
         nsi_iit_inv_code,
         nsi_iit_xsp,
         nsi_iit_det_xsp,
         nsi_operator,
         nsi_rec_id,
         nsi_ref_id
  from   net_sel_inv
  where  nsi_nscr_id = nscr_id
  order by nsi_rec_id;

cursor asset_attr (nsi_id number) is
  select nsa_nscr_id,
         nsa_nsi_id,
         nsa_attrib,
         nsa_scrn_text,
         nsa_format,
         nsa_condition,
         nsa_value1,
         nsa_value2
  from   net_sel_attr
  where  nsa_nsi_id = nsi_id;

cursor road_gty_type is
 select rse_gty_group_type
   from road_segs
  where rse_he_id = road_group;

cursor select_ad_assets is
 select nad_ne_id, nad_inv_type
   from nm_nw_ad_link_all
  where nad_iit_ne_id = nscr_id
    and nad_primary_ad = 'Y';

  l_rse_gty_group_type road_segs.rse_gty_group_type%TYPE;
  r_select_ad_assets   select_ad_assets%ROWTYPE; 
  --
  pn_count             number := 1;
  pc_operator          hig_codes.hco_code%TYPE := null;

Begin

  FOR assets_rec in assets LOOP

      transform_operator(assets_rec.nsi_operator,pc_operator);

      if pn_count > 1 then
         pc_sql2 := pc_sql2||' '||pc_operator||' ';
      end if;
--
      open road_gty_type;
      fetch road_gty_type into l_rse_gty_group_type;
      close road_gty_type;
--    
      open select_ad_assets;
      fetch select_ad_assets into r_select_ad_assets;
--
      if select_ad_assets%found then
        pc_sql2:= pc_sql2||'select /* INVENTORY */ '||road_group||',rse_he_id,trunc(sysdate),1,'||''''||'G'||''''||
                        ','||''''||l_rse_gty_group_type||''''||',nvl(rse_begin_mp,0),nvl(rse_end_mp,rse_length),rse_admin_unit'||
                        ' from road_sections ne where exists ( select '||''''||'asset item on this network element'||''''||
                        ' from nm_inv_items inv, nm_nw_ad_link_all where 1=1 and ';

        if assets_rec.nsi_iit_inv_code is not null then
           pc_sql2 := pc_sql2||'inv.iit_inv_type = '||''''||r_select_ad_assets.nad_inv_type||'''';
        end if;
      else
     
        pc_sql2:= pc_sql2||'select /* INVENTORY */ '||road_group||',rse_he_id,trunc(sysdate),1,'||''''||'G'||''''||
                        ','||''''||l_rse_gty_group_type||''''||',nvl(rse_begin_mp,0),nvl(rse_end_mp,rse_length),rse_admin_unit'||
                        ' from road_sections ne where exists ( select '||''''||'asset item on this network element'||''''||
                        ' from nm_inv_items inv, nm_members memb where 1=1 and ';
      
        if assets_rec.nsi_iit_inv_code is not null then
           pc_sql2 := pc_sql2||'inv.iit_inv_type = '||''''||assets_rec.nsi_iit_inv_code||''''||' and ';
        end if;

        if assets_rec.nsi_iit_xsp is not null then
           pc_sql2 := pc_sql2||'inv.iit_x_sect = '||''''||assets_rec.nsi_iit_xsp||''''||' and ';
        end if;

        if assets_rec.nsi_iit_det_xsp is not null then
           pc_sql2 := pc_sql2||'inv.iit_det_xsp = '||''''||assets_rec.nsi_iit_det_xsp||''''||' and ';
        end if;

        pc_sql2 := pc_sql2||' memb.nm_ne_id_in = inv.iit_ne_id and ne.rse_he_id = memb.nm_ne_id_of ';

    end if;
      
    FOR assets_attr_rec in asset_attr (assets_rec.nsi_id) LOOP

        pc_sql2 := pc_sql2||' and '||assets_attr_rec.nsa_attrib||' '||assets_attr_rec.nsa_condition||' ';

        select pc_sql2||decode(assets_attr_rec.nsa_condition,
 			         'IS NOT NULL','',
			         'IS NULL','',
			         'IN','('||assets_attr_rec.nsa_value1||')',
		    	         'NOT IN','('||assets_attr_rec.nsa_value1||')',
			         'BETWEEN','('||assets_attr_rec.nsa_value1||' and '||
                                          assets_attr_rec.nsa_value2||')',
                           decode(assets_attr_rec.nsa_format,'NUMBER','','''')||
                                  assets_attr_rec.nsa_value1||
                           decode(assets_attr_rec.nsa_format,'NUMBER','',''''))
                           --decode(assets_attr_rec.nsa_format,'NUMBER','',''''))||' and '
          into pc_sql2
          from dual;
    END LOOP;

--
    pc_sql2 := pc_sql2||')';
    pn_count := pn_count + 1;
--
    close select_ad_assets;

END LOOP;

Exception
    when others then
    /* trap the error string */
      err_string := sqlerrm;
      raise_application_error( -20001, err_string );
End;
--
-----------------------------------------------------------------------------
--
Procedure select_enquiries (nscr_id in net_sel_criteria.nscr_id%TYPE,
                                  road_group in road_segs.rse_he_id%TYPE) is

cursor enquiries is
  select nse_nscr_id,
         nse_doc_admin_unit,
         nse_admin_unit_code,
         nse_doc_compl_type,
         nse_doc_compl_cpr_id,
         nse_doc_compl_location,
         nse_doc_descr,
         nse_doc_compl_name,
         nse_doc_status_code,
         nse_doc_date_issued,
         nse_doc_target_date,
         nse_doc_complete_date,
         nse_count_operator,
         nse_count,
         nse_operator,
         nse_rec_id,
         nse_ref_id
  from   net_sel_enquiries
  where  nse_nscr_id = nscr_id
  order by nse_rec_id;

cursor road_gty_type is
 select rse_gty_group_type
   from road_segs
  where rse_he_id = road_group;

 l_rse_gty_group_type road_segs.rse_gty_group_type%TYPE;
  pn_count number := 1;
  pc_operator hig_codes.hco_code%TYPE := null;

Begin
  pc_tmp_sql := null;
  pc_alias := null;

  FOR enquiries_rec in enquiries LOOP
      transform_operator(enquiries_rec.nse_operator,pc_operator);
      pc_tmp_sql := null;
      pc_alias := 'das1.';
      if pn_count > 1 then
         pc_sql := pc_sql||' '||pc_operator||' ';
      end if;

      open road_gty_type;
      fetch road_gty_type into l_rse_gty_group_type;
      close road_gty_type;
      
      pc_sql := pc_sql||'select /* ENQUIRIES */ distinct '||road_group||',to_number('||
                        pc_alias||'das_rec_id),trunc(sysdate),1,'||''''||'G'||''''||
                        ','||''''||l_rse_gty_group_type||''''||',nvl(rse_begin_mp,0),nvl(rse_end_mp,rse_length),rse_admin_unit'||
                        ' from doc_assocs das1, road_sections rs1 where '||
                        'to_number('||pc_alias||'das_rec_id) = rs1.rse_he_id and '||
                        pc_alias||'das_table_name = '||''''||'ROAD_SEGMENTS_ALL'||''''||
                        ' and to_number('||pc_alias||'das_rec_id) in '||
                        '(select rse_he_id from road_sections where rse_sys_flag = '''||lc_sys_flag||''')'||
                        ' and '||pc_alias||'das_doc_id in (select doc_id from docs '||
                        'where doc_dtp_code = '||''''||'COMP'||''''||' and ';

      if enquiries_rec.nse_doc_admin_unit is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_admin_unit = '||
                                   enquiries_rec.nse_doc_admin_unit||' and ';
      end if;

      if enquiries_rec.nse_doc_compl_type is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_type = '||''''||
                                   enquiries_rec.nse_doc_compl_type||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_compl_cpr_id is not null then
         if instr(enquiries_rec.nse_doc_compl_cpr_id,'%',1,1) > 0 then
            pc_tmp_sql := pc_tmp_sql||'doc_compl_cpr_id like '||''''||
                                      enquiries_rec.nse_doc_compl_cpr_id||''''||' and ';
         else
            pc_tmp_sql := pc_tmp_sql||'doc_compl_cpr_id = '||''''||
                                      enquiries_rec.nse_doc_compl_cpr_id||''''||' and ';
         end if;
      end if;

      if enquiries_rec.nse_doc_compl_location is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_location like '||''''||
                                   enquiries_rec.nse_doc_compl_location||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_descr is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_descr like '||''''||
                                   enquiries_rec.nse_doc_descr||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_compl_name is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_name like '||''''||
                                   enquiries_rec.nse_doc_compl_name||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_status_code is not null then
         if instr(enquiries_rec.nse_doc_compl_cpr_id,'%',1,1) > 0 then
            pc_tmp_sql := pc_tmp_sql||'doc_status_code like '||''''||
                                   enquiries_rec.nse_doc_status_code||''''||' and ';
         else
            pc_tmp_sql := pc_tmp_sql||'doc_status_code = '||''''||
                                   enquiries_rec.nse_doc_status_code||''''||' and ';
         end if;
      end if;

      if enquiries_rec.nse_doc_date_issued is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_date_issued like '||''''||
                                   enquiries_rec.nse_doc_date_issued||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_target_date is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_target like '||''''||
                                   enquiries_rec.nse_doc_target_date||''''||' and ';
      end if;

      if enquiries_rec.nse_doc_complete_date is not null then
         pc_tmp_sql := pc_tmp_sql||'doc_compl_complete like '||''''||
                                   enquiries_rec.nse_doc_complete_date||''''||' and ';
      end if;

      if enquiries_rec.nse_count_operator is not null then
         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||enquiries_rec.nse_count||' ';
         if enquiries_rec.nse_count_operator = '<' then
            pc_sql := pc_sql||'>';
         elsif enquiries_rec.nse_count_operator = '>' then
            pc_sql := pc_sql||'<';
         else
            pc_sql := pc_sql||'=';
         end if;

         pc_sql := pc_sql||' (select count(*) from docs where doc_dtp_code = '||
                           ''''||'COMP'||''''||' and ';
         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||'doc_id in (select das_doc_id from doc_assocs where das_rec_id = '||
                           pc_alias||'das_rec_id and das_table_name = '||''''||
                           'ROAD_SEGMENTS_ALL'||''''||') and ';
         pc_sql := pc_sql||'1 = 1))';
      else
         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||'1 = 1)';
      end if;

      pn_count := pn_count + 1;
      pc_tmp_sql := null;
  END LOOP;
Exception
    when others then
    /* trap the error string */
      err_string := sqlerrm;
      raise_application_error( -20001, err_string );
End;
--
-----------------------------------------------------------------------------
--
Procedure select_defects (nscr_id in net_sel_criteria.nscr_id%TYPE,
                                road_group in road_segs.rse_he_id%TYPE
) is

  Cursor Defects is
    select
      nsd_nscr_id,
      nsd_def_defect_code,
      nsd_def_acty_area_code,
      nsd_def_priority,
      nsd_def_status_code,
      nsd_rep_tre_treat_code,
      nsd_boq_sta_item_code,
      nsd_count_operator,
      nsd_count,
      nsd_operator,
      nsd_rec_id,
      nsd_ref_id
    from net_sel_defects
    where nsd_nscr_id = nscr_id
    order by nsd_rec_id;

cursor road_gty_type is
 select rse_gty_group_type
   from road_segs
  where rse_he_id = road_group;

 l_rse_gty_group_type road_segs.rse_gty_group_type%TYPE;
  pn_count number := 1;
  pc_operator hig_codes.hco_code%TYPE := null;

Begin
  pc_tmp_sql := null;
  pc_alias := null;

  FOR defects_rec in defects LOOP
      transform_operator(defects_rec.nsd_operator,pc_operator);
      pc_tmp_sql := null;
      pc_alias := 'def1.';
      if pn_count > 1 then
         pc_sql := pc_sql||' '||pc_operator||' ';
      end if;

      open road_gty_type;
      fetch road_gty_type into l_rse_gty_group_type;
      close road_gty_type;
            
      pc_sql := pc_sql||'select /* DEFECTS */ distinct '||road_group||',def1.def_rse_he_id,trunc(sysdate),1,'||''''||'G'||''''||
                        ','||''''||l_rse_gty_group_type||''''||',nvl(rse_begin_mp,0),nvl(rse_end_mp,rse_length),rse_admin_unit'||
                           ' from defects def1, road_sections rs1 where rs1.rse_he_id = def1.def_rse_he_id and '||
                        'def1.def_rse_he_id in (select rse_he_id from road_sections where rse_sys_flag = '''||lc_sys_flag||''') and ';
      if defects_rec.nsd_def_defect_code is not null then
         if instr(defects_rec.nsd_def_defect_code,'%',1,1) > 0 then
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_defect_code like '||''''||
                                      defects_rec.nsd_def_defect_code||''''||' and ';
         else
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_defect_code = '||''''||
                                      defects_rec.nsd_def_defect_code||''''||' and ';
         end if;
      end if;

      if defects_rec.nsd_def_acty_area_code is not null then
         pc_tmp_sql := pc_tmp_sql||pc_alias||'def_atv_acty_area_code = '||''''||
                                   defects_rec.nsd_def_acty_area_code||''''||' and ';
      end if;

      if defects_rec.nsd_def_priority is not null then
         pc_tmp_sql := pc_tmp_sql||pc_alias||'def_priority = '||''''||
                                   defects_rec.nsd_def_priority||''''||' and ';
      end if;

      if defects_rec.nsd_def_status_code is not null then
         if instr(defects_rec.nsd_def_status_code,'%',1,1) > 0 then
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_status_code like '||''''||
                                      defects_rec.nsd_def_status_code||''''||' and ';
         else
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_status_code = '||''''||
                                      defects_rec.nsd_def_status_code||''''||' and ';
         end if;
      end if;

      if defects_rec.nsd_rep_tre_treat_code is not null then
         pc_tmp_sql := pc_tmp_sql||pc_alias||
                                   'def_defect_id in (select rep_def_defect_id from repairs where ';
         pc_tmp_sql := pc_tmp_sql||'rep_tre_treat_code = '||''''||
                                   defects_rec.nsd_rep_tre_treat_code||''''||') and ';
      end if;

      if defects_rec.nsd_boq_sta_item_code is not null then
         pc_tmp_sql := pc_tmp_sql||pc_alias||
                                   'def_defect_id in (select boq_defect_id from boq_items where ';
         pc_tmp_sql := pc_tmp_sql||'boq_sta_item_code = '||''''||
                                   defects_rec.nsd_boq_sta_item_code||''''||') and ';
      end if;

      if defects_rec.nsd_count_operator is not null then
         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||defects_rec.nsd_count||' ';
         if defects_rec.nsd_count_operator = '<' then
            pc_sql := pc_sql||'>';
         elsif defects_rec.nsd_count_operator = '>' then
            pc_sql := pc_sql||'<';
         else
            pc_sql := pc_sql||'=';
         end if;
         pc_tmp_sql := null;
         pc_alias := 'def2.';
         pc_sql := pc_sql||' (select count(*) from defects def2 '||
                           'where def1.def_rse_he_id = '||pc_alias||'def_rse_he_id and ';
         if defects_rec.nsd_def_defect_code is not null then
            if instr(defects_rec.nsd_def_defect_code,'%',1,1) > 0 then
               pc_tmp_sql := pc_tmp_sql||pc_alias||'def_defect_code like '||''''||
                                         defects_rec.nsd_def_defect_code||''''||' and ';
            else
               pc_tmp_sql := pc_tmp_sql||pc_alias||'def_defect_code = '||''''||
                                         defects_rec.nsd_def_defect_code||''''||' and ';
            end if;
         end if;

         if defects_rec.nsd_def_acty_area_code is not null then
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_atv_acty_area_code = '||''''|| --added atv into the field name (templine)
                                      defects_rec.nsd_def_acty_area_code||''''||' and ';
         end if;

         if defects_rec.nsd_def_priority is not null then
            pc_tmp_sql := pc_tmp_sql||pc_alias||'def_priority = '||''''||
                                      defects_rec.nsd_def_priority||''''||' and ';
         end if;

         if defects_rec.nsd_def_status_code is not null then
            if instr(defects_rec.nsd_def_status_code,'%',1,1) > 0 then
               pc_tmp_sql := pc_tmp_sql||pc_alias||'def_status_code like '||''''||
                                         defects_rec.nsd_def_status_code||''''||' and ';
            else
               pc_tmp_sql := pc_tmp_sql||pc_alias||'def_status_code = '||''''||
                                         defects_rec.nsd_def_status_code||''''||' and ';
            end if;
         end if;

         if defects_rec.nsd_rep_tre_treat_code is not null then
            pc_tmp_sql := pc_tmp_sql||pc_alias||
                                      'def_defect_id in (select rep_def_defect_id from repairs where ';
            pc_tmp_sql := pc_tmp_sql||'rep_tre_treat_code = '||''''||
                                      defects_rec.nsd_rep_tre_treat_code||''''||') and ';
         end if;

         if defects_rec.nsd_boq_sta_item_code is not null then
            pc_tmp_sql := pc_tmp_sql||pc_alias||
                                      'def_defect_id in (select boq_defect_id from boq_items where ';
            pc_tmp_sql := pc_tmp_sql||'boq_sta_item_code = '||''''||
                                      defects_rec.nsd_boq_sta_item_code||''''||') and ';
         end if;

         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||'1 = 1)';
      else
         pc_sql := pc_sql||pc_tmp_sql;
         pc_sql := pc_sql||'1 = 1';
      end if;

      pn_count := pn_count + 1;
      pc_tmp_sql := null;

END LOOP;

Exception
    when others then
    /* trap the error string */
      err_string := sqlerrm;
      raise_application_error( -20001, err_string );
End;
--
-----------------------------------------------------------------------------
--
Function populate_road_gp_members Return number is

result number := 0;
lc_sql varchar2(32767);
c1     nm3type.ref_cursor;

TYPE rec_inv_data IS RECORD
      ( rid_nm_ne_id_in    nm_members_all.nm_ne_id_in%TYPE
      , rid_nm_ne_id_of    nm_members_all.nm_ne_id_of%TYPE
      , rid_nm_start_date  nm_members_all.nm_start_date%TYPE
      , rid_nm_seq_no      nm_members_all.nm_seq_no%TYPE
      , rid_nm_type        nm_members_all.nm_type%TYPE
      , rid_nm_obj_type    nm_members_all.nm_obj_type%TYPE
      , rid_nm_begin_mp    nm_members_all.nm_begin_mp%TYPE
      , rid_nm_end_mp      nm_members_all.nm_end_mp%TYPE
      , rid_nm_admin_unit  nm_members_all.nm_admin_unit%TYPE
      );

TYPE tab_inv IS TABLE OF rec_inv_data INDEX BY binary_integer;
g_tab_inv tab_inv;
--
-- To debug this procedure create a table called net119_debug with one column which is a VARCHAR2(2000)
--
Begin
  --
  Begin
    if pc_sql2 is not null then
      lc_sql := handle_quotes(pc_sql2);    
    else
      lc_sql := handle_quotes(pc_sql);
      --hig.execute_sql ('insert into net119_debug (seq,text) select nvl(max(seq),0)+1,'''||lc_sql||''' from net119_debug',result);
    end if;
  EXCEPTION
    WHEN OTHERS THEN
      null;
  END;
  --
  if pc_sql2 is not null then
    open c1 for pc_sql2;
    loop
      fetch c1 bulk collect into g_tab_inv limit 1000;
      for i in 1..g_tab_inv.count loop

        insert into nm_members_all 
        ( nm_ne_id_in
        , nm_ne_id_of
        , nm_start_date
        , nm_seq_no
        , nm_type
        , nm_obj_type
        , nm_begin_mp
        , nm_end_mp
        , nm_admin_unit
        )
        values (
         g_tab_inv(i).rid_nm_ne_id_in
        , g_tab_inv(i).rid_nm_ne_id_of
        , g_tab_inv(i).rid_nm_start_date
        , g_tab_inv(i).rid_nm_seq_no
        , g_tab_inv(i).rid_nm_type
        , g_tab_inv(i).rid_nm_obj_type
        , g_tab_inv(i).rid_nm_begin_mp
        , g_tab_inv(i).rid_nm_end_mp
        , g_tab_inv(i).rid_nm_admin_unit)
        ;
      end loop;
        exit when c1%notfound;
    end loop;
    close c1;
  else
    hig.execute_sql (pc_sql, result);  
  end if;
  commit;

  return result;
Exception
    when others then
    /* trap the error string */
      err_string := sqlerrm;
      raise_application_error( -20003, err_string );
      
End;
--
-----------------------------------------------------------------------------
--
Function delete_select (road_group in road_segs.rse_he_id%TYPE,

                              action in varchar2,

							  block  in varchar2,

							  item_1 in number,

							  item_2 in number,

                       group_type in varchar2,

                       sys_flag in varchar2

) Return boolean is

Begin

  lc_sys_flag := sys_flag;
  --
  -- 711224 JW 19-AUG-2008 
  --
  -- The pass_sel_ckh function dynamically runs a sql select statement to check whether the road_group exists on the ukpms_automatic_pass table. It uses dbms_sql.execute 
  -- to run the sql and dbms_sql_fetch to return the number of rows found. Unfortunately, the returm value from dbms_sql.execute is only valid for insert, update or 
  -- delete statements and not selects.Testing showed that when run dynamically the return value was always -1 which implied that the road_group didn't exist and was 
  -- therefore eligible for deletion.The following call to the pass_sel_chk function has been commented out and the check is now made in the key-delrec trigger in NET1119.   
  -- 
  --  IF pass_sel_chk(road_group) THEN 
  --     return FALSE;
  --  end if;
  --
  if action = 'DELETE' then


     IF block = 'B1' THEN

	   DELETE FROM NET_SEL_CONTRACTS
       WHERE NSC_NSCR_ID In(select nscr_id from NET_SEL_CRITERIA WHERE NSCR_NET_SEL_ID = road_group);

       DELETE FROM NET_SEL_ENQUIRIES
       WHERE NSE_NSCR_ID In(select nscr_id from NET_SEL_CRITERIA WHERE NSCR_NET_SEL_ID = road_group);
       
       DELETE FROM NET_SEL_ROADS
       WHERE NSR_NSCR_ID In(select nscr_id from NET_SEL_CRITERIA WHERE NSCR_NET_SEL_ID = road_group);

       DELETE FROM NET_SEL_ATTR
       WHERE NSA_NSCR_ID||NSA_NSI_ID In(select nscr_id||nsi_id from NET_SEL_CRITERIA, NET_SEL_INV  WHERE NSCR_NET_SEL_ID = road_group AND   NSI_NSCR_ID = nscr_id);

       DELETE FROM NET_SEL_INV
       WHERE NSI_NSCR_ID In(select nscr_id from NET_SEL_CRITERIA WHERE NSCR_NET_SEL_ID = road_group);

       DELETE FROM NET_SEL_CRITERIA
       WHERE NSCR_NET_SEL_ID = road_group;

	   delete from road_seg_membs_all
       where  rsm_rse_he_id_in = road_group;

       -- Log 711224 JW 20-JUN-2008 
       -- Deleting from road_groups resulted in a ORA-01752 error. 
       -- delete from road_groups
       -- where  rse_he_id = road_group;
       delete from nm_elements_all where ne_id = road_group;

	 END IF;

	 IF block ='B2' THEN

	   DELETE FROM NET_SEL_CONTRACTS

       WHERE NSC_NSCR_ID = item_1;

       DELETE FROM NET_SEL_ENQUIRIES

       WHERE NSE_NSCR_ID = item_1;

       DELETE FROM NET_SEL_INV

       WHERE NSI_NSCR_ID = item_1;

       DELETE FROM NET_SEL_ROADS

       WHERE NSR_NSCR_ID = item_1;

	    DELETE FROM NET_SEL_ATTR

        WHERE NSA_NSCR_ID = item_1

		and NSA_NSI_ID = item_2;

     END IF;

	 --

	 IF block = 'B4' THEN

	    DELETE FROM NET_SEL_ATTR

        WHERE NSA_NSCR_ID = item_1

		and NSA_NSI_ID = item_2;

     END IF;



  end if;



  commit;

  return TRUE;



Exception

    when others then



    /* trap the error string */


      err_string := sqlerrm;

      return FALSE;

      raise_application_error( -20003, err_string );



End;
--
-----------------------------------------------------------------------------
--
Function pass_sel_chk (road_group in road_segs.rse_he_id%TYPE

) return boolean is



  v_count	   NUMBER;

  v_sql_text   VARCHAR2(32767);



BEGIN

	v_sql_text := '    select ''x'' from   ukpms_automatic_pass where  uap_network_selection_id ='''||road_group||'''';

   --

   v_count := run_dynamic_sql(v_sql_text);

   IF v_count > 0 THEN

     RETURN TRUE;

   ELSE

     RETURN FALSE;

   END IF;

   --

END;
--
-----------------------------------------------------------------------------
--
function handle_quotes(text in varchar2) return varchar2 IS

ln_quote_pos number := 1;

lc_text1 varchar2(20000) := text;

begin

  loop

    ln_quote_pos := INSTR(lc_text1,CHR(39),ln_quote_pos);

    IF ln_quote_pos IS NULL OR ln_quote_pos = 0 THEN

      exit;

    END IF;

	IF substr(lc_text1,ln_quote_pos+1,1) = chr(39) THEN

	  exit;

	END IF;

    lc_text1 := substr(lc_text1,0,ln_quote_pos-1)||chr(39)||chr(39)||substr(lc_text1,ln_quote_pos+1);

    ln_quote_pos := ln_quote_pos+2;

  end loop;

  return lc_text1;

end;

---------------------------------------------------------------------------------------



/* MAIN */



---------------------------------------------------------------------------------------



BEGIN



  /* return the language under which the application is running */

  g_language := 'ENGLISH';



  /* instantiate common error messages */



END net_sel;
/
