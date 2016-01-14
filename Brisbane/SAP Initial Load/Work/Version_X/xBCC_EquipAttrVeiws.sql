
Create or replace procedure xBCC_Equip_Attr_Views(s_primary_view in varchar2 default '%', d_last_ran_before in date default to_date('01019999','MMDDRRRR')) as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: xBCC_EquipAttrVeiws.sql
	Author: JMM
	UPDATE01:	Original, 2014.04.28, JMM
*/

	s_sql_columns varchar2(32767);
	s_sql_template varchar2(32767);
	s_sql_template_b varchar2(32767);
	s_sql_template_esur varchar2(32767);
	s_sql_XSP varchar2(500) := '';
	s_network varchar2(50) := '';
	s_test_limit varchar2(500) := 'AND ROWNUM <15';  -- Since the GEOTRIM Takes awhile

	cursor c_assets is select * from  xBCC_EAV_Input where primary_view like s_primary_view and nvl(last_complete,to_date('01011801','MMDDRRRR')) < d_last_ran_before;
	cursor c_columns(s_asset_type varchar2) is select ita_attrib_name, ita_view_col_name from nm_inv_type_attribs where ita_inv_type = s_asset_type order by ita_disp_seq_no;
	--cursor c_eav_temp is select rowid myid, start_ch, end_ch from xbcc_eav_temp  for update of geoloc;
	
	procedure drop_table(s_table varchar2) is
		n_table number;
		begin
			select count(*) into n_table from user_tables where table_name = upper(s_table);
            if n_table > 0 then
                execute immediate 'drop table ' || s_table;				
            end if;

		end drop_table;
		
	function get_column(s_type varchar2) return varchar2 is
		n_count number;
		s_ret_val varchar2(1000) := '';
		
		begin
		
		select count(*) into n_count from nm_inv_type_attribs where ita_inv_type = s_type;
		
		case n_count
			when 0 then 
				null;   -- No columns defined
			else 
				for myrow in c_columns(s_type) loop
					s_ret_val := s_ret_val || ', ' || myrow.ita_attrib_name || ' ' || chr(34) ||  substr(myrow.ita_view_col_name, 1,30) || chr(34) ;
				end loop;
				
			end case;
				
		return s_ret_val;
	end get_column;
	
	
	procedure reset_template is
		begin
		--set the template
		s_sql_template := 
		q'[
select * from (
With 
ZDB_CHK as (
        select  * from nm_members m, nm_elements d
         where 1=1
         and ne_type = 'D'
         and ne_id = nm_ne_id_of
         and nm_type = 'G' 
         and nm_obj_type = '##ROUTE_TYPE##'
         and nm_slk = nm_end_slk
 )
 --
, invitems as
(
select   *  from nm_inv_items 
where 1=1 
and iit_inv_type = '##INV_TYPE##' ##X_SECT##
)
,Base1 as 
    (
    select a.*                
    from     
        (SELECT 
            mem.nm_ne_id_in
            mem_nm_ne_id_in,
            aloc.nm_ne_id_in
            aloc_nm_ne_id_in,
            DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) begin_MP_NO,
            DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_MP_NO            
            FROM 
            (select * from nm_members where nm_ne_id_in in (select iit_ne_id from invitems)) aloc
            --,nm_members aloc
            ,nm_members mem           
        WHERE 1=1
        AND mem.nm_obj_type = '##ROUTE_TYPE##'
        AND aloc.nm_type = 'I'       
        AND aloc.nm_obj_type =  '##INV_TYPE##'
        AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
        ) a
    )
,Base2 as  --used to do some analytic looks at the DB (gap) areas
(
        select 
            mem_nm_ne_id_in,
            aloc_nm_ne_id_in ,            
            begin_mp_no ,
            end_mp_no           
            ,db
            ,DBTSMP
            , Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no or zdb = 'Y' then begin_mp_no  
            else (last_value (DBTSMP ignore nulls) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no rows between unbounded preceding and 1 preceding)) end DBSMP
            ,        tt             
        from (
                select 
                 mem_nm_ne_id_in,
                aloc_nm_ne_id_in,                
                begin_mp_no,
                end_mp_no                
                , Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no then 'Y' else 'N' end DB
                , Case when ((lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no) 
                            OR  (begin_mp_no in (select nm_slk from zdb_chk where  nm_ne_id_in = mem_nm_ne_id_in))
                            then begin_mp_no  else null end DBTSMP
                , lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no) tt 
                , case when begin_mp_no in (select nm_slk from zdb_chk where  nm_ne_id_in = mem_nm_ne_id_in) then 'Y' else 'N' end ZDB
            --
                from      base1
                ) 
)
select * from base2
)
		]';
		
s_sql_template_b := 
		q'[
select a.* 
 ,case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(geoloc_tmp) = 0 then null
		   when sdo_lrs.measure_range(geoloc_tmp) = end_ch - start_ch then geoloc_tmp		   
           else SDO_LRS.CLIP_GEOM_SEGMENT(geoloc_tmp, start_ch, end_ch)
           end geoloc 
from ( 
SELECT 
    iit_inv_type,    
    ##MED## mem_nm_ne_id_in  NETWORK_PRIMARY_ID,	--##MED####ROUTE_TYPE##_PRIMARY_ID,
    IIT_NE_ID    ASSET_PRIMARY_ID, --##INV_TYPE##_PRIMARY_ID,
	IIT_START_DATE ASSET_START_DATE,
    beg_mp_no START_CH,
     end_mp_no   END_CH,
	 iit_x_sect XSP,
	 rt.ne_descr NETWORK_NAME,
	 rt.corridor_code NETWORK_CORRIDOR_CODE
      ##COL##    --
	  ##SIDE##
	,  SURVEY_ID	
	,  Survey_Date
	, Survey_Type	
	  , sysdate		EXTRACT_DATE
	  ,geoloc geoloc_tmp
from (
     SELECT *
     FROM (
			select   *  from nm_inv_items 
			where 1=1 
			and iit_inv_type = '##INV_TYPE##'			
			) inv,      
        (select 
            mem_nm_ne_id_in,
            aloc_nm_ne_id_in aloc_IIT_NE_ID,
            min(begin_mp_no) beg_mp_no,
            max(end_mp_no) end_mp_no             
            ,DBSMP
            from xbcc_eav_temp          
            group by  mem_nm_ne_id_in, aloc_nm_ne_id_in, DBSMP) loc        
        WHERE     1=1
        and inv.iit_ne_id = loc.aloc_IIT_NE_ID ##X_SECT##  -- Moved here for speed reasons in the QO
        )  , V_NM_NLT_##ROUTE_TYPE##_##ROUTE_TYPE##_SDO_DT rt
		, XBCC_EQUIP_ATTR_VIEWS_ESUR esur
        Where 1=1     
		and  rt.ne_id =  mem_nm_ne_id_in
		and  esur.esur_mem_nm_ne_id_in(+) = mem_nm_ne_id_in
		and esur.esur_slk(+) <= beg_mp_no
		and esur.esur_end_slk(+) >= end_mp_no
        ) a
		order by NETWORK_PRIMARY_ID, start_ch
		]';		
	end reset_template;
	
	procedure reset_secondary_template is
		begin
		--set the template
		s_sql_template_esur := 
		q'[
select 
			mem_nm_ne_id_in esur_mem_nm_ne_id_in			
			,begin_mp_no esur_SLK
			,end_mp_no esur_END_SLK
			, aloc_nm_ne_id_in "SURVEY_ID"	
            ,  IIT_DATE_ATTRIB86 Survey_Date
            , IIT_CHR_ATTRIB26  	Survey_Type	
			from             (
					  select 
								 mem_nm_ne_id_in,
							   aloc_nm_ne_id_in,            
						 min(begin_mp_no) begin_mp_no,
						 max(end_mp_no) end_mp_no             
						 ,DBSMP
						 from       (select 
						mem_nm_ne_id_in,
						aloc_nm_ne_id_in ,            
						begin_mp_no ,
						end_mp_no            
						,db
						,DBTSMP
						, Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no  then begin_mp_no  
						else (last_value (DBTSMP ignore nulls) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in  order by begin_mp_no rows between unbounded preceding and 1 preceding)) end DBSMP
						,        tt             
					from (        
							select 
							 mem_nm_ne_id_in,
							aloc_nm_ne_id_in,
							begin_mp_no,
							end_mp_no               
							, Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no then 'Y' else 'N' end DB
							, Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no) <> begin_mp_no)                            
										then begin_mp_no  else null end DBTSMP
							, lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no) tt                 
						--
							from              (SELECT 
						mem.nm_ne_id_in
						mem_nm_ne_id_in,
						aloc.nm_ne_id_in
						aloc_nm_ne_id_in,
						DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + aloc.nm_begin_mp,    -1,   mem.nm_end_slk  - aloc.nm_begin_mp) begin_MP_NO,
						DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + aloc.nm_end_mp,    -1,   mem.nm_end_slk       - aloc.nm_begin_mp)    END_MP_NO
						FROM nm_members aloc,
						nm_members mem           
					WHERE 1=1
					AND mem.nm_obj_type = '##ROUTE_TYPE##'
					AND aloc.nm_type = 'I'        
					AND aloc.nm_obj_type =  'ESUR'
					AND mem.nm_ne_id_of = aloc.nm_ne_id_of
				   ) base1) )base2          
					group by  mem_nm_ne_id_in, aloc_nm_ne_id_in,DBSMP) a
			, (select * from nm_inv_items) b
			, (select ne_id, ne_unique from nm_elements) c
			where 
			b.iit_ne_id = a.aloc_nm_ne_id_in
			and a.mem_nm_ne_id_in = c.ne_id	
		]';
		

		
	end reset_secondary_template;
	
	procedure reset_xsp(s_xsp varchar2) is
		begin
		s_sql_XSP  := 	q'[SELECT trim(EXTRACT(column_value,'/e/text()')) XSP from (select '##XSP##' xsp from dual) x, TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(XSP,',','</e><e>')||'</e></ROW>'),'//e')))) ]';
		s_sql_XSP := 'and iit_x_sect in( ' || replace(s_sql_xsp, '##XSP##', s_xsp);
	end reset_xsp;
	
	Begin  ---********* start generate assets *********
        
		DBMS_SNAPSHOT.REFRESH( 'XBCC_EQUIP_ATTR_VIEWS_ESUR');
		
		for r_row in c_assets	loop
			NM3DBG.PUTLN('Starting: ' || ', ' || r_row.primary_view);
			reset_template;
			reset_secondary_template;
			
			
			if r_row.XSP is null then
				s_sql_XSP :='';
			else
				reset_xsp(r_row.xsp);
			end if;
			
			drop_table(r_row.primary_view);
			drop_table('xbcc_eav_temp');
			-- build column list
			s_sql_columns := '' ; 			
			s_sql_columns := get_column(r_row.BRAMS_ASSET);
			
			
			CASE R_ROW.NETWORK
				WHEN 'KCOR' then s_network := ',side_or_street';
				WHEN 'VECO' then s_network := ',side_of_street';
				else s_network := '';
			end case;
			
			--Add survey info
			
			s_sql_template_b := replace(s_sql_template_b,'##ESUR##', s_sql_template_esur);
			
			if r_row.NETWORK = 'MED' then
				s_sql_template := replace(s_sql_template,'##MED####ROUTE_TYPE##_PRIMARY_ID', 'MED_PRIMARY_ID');  -- to deal with a replace issue
				s_sql_template := replace(s_sql_template,'##MED####ROUTE_TYPE##', 'MED');				
				s_sql_template := replace(s_sql_template,'##MED##', '900000000 + ');
				s_sql_template := replace(s_sql_template,'##ROUTE_TYPE##', 'RDCO');
			else
				s_sql_template := replace(s_sql_template,'##MED##', '');
				s_sql_template := replace(s_sql_template,'##ROUTE_TYPE##', r_row.NETWORK);
			end if;
			
			s_sql_template := replace(s_sql_template,'##INV_TYPE##', r_row.BRAMS_ASSET);
			s_sql_template := replace(s_sql_template,'##COL##', s_sql_columns);
			s_sql_template := replace(s_sql_template,'##X_SECT##', s_sql_XSP );
			s_sql_template := replace(s_sql_template,'##LIMIT##', s_test_limit );
			
			if r_row.NETWORK = 'MED' then
				NM3DBG.PUTLN('In MED');
				--s_sql_template_b := replace(s_sql_template_b,'**TEST**', 'MED_PRIMARY_ID');  -- to deal with a replace issue
				s_sql_template_b := replace(s_sql_template_b,'##MED####ROUTE_TYPE##', 'MED');				
				s_sql_template_b := replace(s_sql_template_b,'##MED##', '900000000 + ');
				s_sql_template_b := replace(s_sql_template_b,'##ROUTE_TYPE##', 'RDCO');
			else
				--s_sql_template_b := replace(s_sql_template_b,'**TEST**',r_row.NETWORK || '_PRIMARY_ID' );
				s_sql_template_b := replace(s_sql_template_b,'##MED##', '');
				s_sql_template_b := replace(s_sql_template_b,'##ROUTE_TYPE##', r_row.NETWORK);
			end if;
			
			s_sql_template_b := replace(s_sql_template_b,'##INV_TYPE##', r_row.BRAMS_ASSET);
			s_sql_template_b := replace(s_sql_template_b,'##COL##', s_sql_columns);
			s_sql_template_b := replace(s_sql_template_b,'##SIDE##', s_network);
			s_sql_template_b := replace(s_sql_template_b,'##X_SECT##', s_sql_XSP );
			s_sql_template_b := replace(s_sql_template_b,'##LIMIT##', s_test_limit );
			
			NM3DBG.PUTLN(r_row.primary_view);
			
			NM3DBG.PUTLN(s_sql_template);
			execute immediate 'create table ' || 'xbcc_eav_temp' ||' as (' ||  s_sql_template || ' )';			
			NM3DBG.PUTLN('create table ' || r_row.primary_view ||' as (select * from (' ||  s_sql_template_b || ' ))');
			execute immediate 'create table ' || r_row.primary_view ||' as (select * from (' ||  s_sql_template_b || ' ))';
			NM3DBG.PUTLN('Alter Table');
			execute immediate 'alter table ' || r_row.primary_view ||' drop column geoloc_tmp';
			
			
			--  Added to know when the last time and Item completed is:
			update xBCC_EAV_Input 
				set last_complete = sysdate where Primary_View = r_row.primary_view;
			commit;
			
			
		end loop;
			
						
	
End xBCC_Equip_Attr_Views;
/