Create or replace package body XBCC_SAP_SYNC as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2014.03.25, JMM
	UPDATE02:	Added Extra Logging Information, 2014.05.29, JMM
	UPDATE03:	Added 0 to be accepted as null, 2014.06.15, JMM
	UPDATE04:	Changed Corridor check to have a separate _all and bram_id cursor
	UPDATE05:	Changed Corridor check and initial Asset Check for the all Brams_ID cases to use UNION ALL queries instead of  an OR Date check
*/
	s_module varchar2(30);
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);
	err_num NUMBER;
	s_err_text VARCHAR2(1000);
	
	b_is_med boolean := false;
	n_idx	number;
	s_brams_id_chkd varchar2(20) := null;
	s_route_type varchar2(50) := 'RDCO,VECO,KCOR';
	s_inv_type varchar2(50) := 'ASOW,CBSC,CALL,KCON';
	s_group_type varchar2(50) := 'OPWD,KSUB,VESB,STSB';
	d_start_time date := sysdate;
	

	procedure process_refcur  (d_start_date in  date, d_end_date in date, rc_recordset out sys_refcursor, n_brams_id in number default null, b_Only_Check_Cooridor in boolean default false, b_log_to_x_log_information in boolean default false) as

		
		ex_sap_sync 		Exception;
		d_rundate 			date := sysdate;
		n_count				number;
		n_slk				number;
		n_end_slk			number;
		s_desc				varchar2(40);  -- needs to be substr to 30 before use
		s_indicator 		varchar2(5) := null;
		s_indicator_cor 	varchar2(5) := null;
		r_elements nm_elements_all%rowtype;
		
		TYPE ARRAY IS TABLE OF xbcc_inv_in_list%rowtype;
		l_data array; 
		
		TYPE ARRAY2 IS TABLE OF XBCC_INV_LIST%rowtype;
		l_data2 array2; 
		
		cursor c_corridor_ch_id(d_start_date  date, d_end_date date, s_brams_id number) is
					with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
			        select a.* , b.* from nm_members_all a,nm_elements_all b  where
                    1=1
                    and a.nm_ne_id_of = b.ne_id                     
                    and b.ne_type = 'S'
                    and nm_type = 'G'  
                    and nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                    and (   
							(trunc(nm_date_modified) between d_start_date and d_end_date and trunc(nm_date_modified) <> d_start_date)
                               or 
							 (trunc(ne_date_modified) between d_start_date and d_end_date and trunc(ne_date_modified) <> d_start_date)
						)
                    and nm_ne_id_in = s_brams_id
					--and rownum < 50  --tester
                    --order by nm_ne_id_in,nm_slk
                    ; 
				
		cursor c_corridor_ch_all(d_start_date  date, d_end_date date, s_brams_id varchar2) is
					with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
						select distinct * from (
			        select a.* , b.* from nm_members_all a,nm_elements_all b  where
                    1=1
                    and a.nm_ne_id_of = b.ne_id                     
                    and b.ne_type = 'S'
                    and nm_type = 'G'  
                    and nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                    and (   
							(trunc(nm_date_modified) between d_start_date and d_end_date and trunc(nm_date_modified) <> d_start_date)
                             						)
						union all
					select a.* , b.* from nm_members_all a,nm_elements_all b  where
                    1=1
                    and a.nm_ne_id_of = b.ne_id                     
                    and b.ne_type = 'S'
                    and nm_type = 'G'  
                    and nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                    and (   
							
							 (trunc(ne_date_modified) between d_start_date and d_end_date and trunc(ne_date_modified) <> d_start_date)
						)
						)
                    --and nm_ne_id_in like s_brams_id
					--and rownum < 50  --tester
                    --order by nm_ne_id_in,nm_slk
                    ;			

					--old c_inv_ch method too slow and memory consuming on the large dataset
		cursor c_inv_ch_id(d_start_date  date, d_end_date date, s_brams_id varchar2) is
                    with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                        , il as (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_inv_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                    SELECT 
                    mem.nm_ne_id_in         mem_nm_ne_id_in,
                    aloc.nm_ne_id_in            aloc_nm_ne_id_in
                    ,aloc. nm_date_modified aloc_nm_date_modified  
                    ,aloc.nm_date_created    aloc_nm_date_created 
                    , aloc.nm_start_date        aloc_nm_start_date
                    , aloc.nm_end_date        aloc_nm_end_date
                    , aloc.nm_obj_type          aloc_nm_obj_type
                    FROM 
                         (select * from  nm_inv_items_all where iit_inv_type  in ((select trim(cast(myrow as varchar2(25))) from il))) i -- (select iit_ne_id from  nm_inv_items where 1=1 and iit_inv_type = :INV_TYPE)) aloc
                        --,nm_members_all aloc
						, (select * from nm_members_all where 1=1 AND nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)) mem  --Added to reduce the number of records, the collection was hanging.
                        ,nm_members_all aloc           
                    WHERE 1=1
                    and mem.nm_ne_id_in like s_brams_id
                    AND mem.nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                    AND aloc.nm_type = 'I'       
                    AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from il)
                    AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
                    and aloc.nm_ne_id_in = i.iit_ne_id
                    and (   
							(trunc(aloc.nm_date_modified) between d_start_date and d_end_date  and trunc(aloc.nm_date_modified) <> d_start_date)
                            or (trunc(i.iit_date_modified)between d_start_date and  d_end_date and trunc(i.iit_date_modified) <> d_start_date)
						)
					;
					   
					
		cursor c_inv_ch_mem_in_list(d_start_date  date, d_end_date date, s_brams_id varchar2) is
			select ne_id from (
			with il as (SELECT EXTRACT(column_value,'/e/text()') myrow from (select   s_inv_type col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e'))) il
			)
			select iit_ne_id ne_id from 
				(select * from nm_inv_items_all ) i
				where 1=1
				and  iit_inv_type  in ((select trim(cast(myrow as varchar2(25))) from il))
				and (   
				--	(trunc(aloc.nm_date_modified) between  d_start_date and  d_end_date  and trunc(aloc.nm_date_modified) <>  d_start_date)
				(trunc(i.iit_date_modified)between  d_start_date and   d_end_date and trunc(i.iit_date_modified) <>  d_start_date)
			)
			--and rownum < 50  --tester
		)
		--
		UNION ALL
		--
		select * from (
			with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_route_type col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))                        
			)
			select nm_ne_id_in ne_id from
				nm_members_all aloc
				where 
				nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
				and (trunc(aloc.nm_date_modified) between  d_start_date and  d_end_date  and trunc(aloc.nm_date_modified) <>  d_start_date)
				--and rownum < 50  --tester
		);
		cursor c_inv_ch is
		     with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_route_type col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))                        
			)
         	, il as (SELECT EXTRACT(column_value,'/e/text()') myrow from (select   s_inv_type col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e'))))			
			select mem.nm_ne_id_in ne_id, null a,null b,null c,null d,null e,null f from   -- Nulls added to do bulk insert
				nm_members_all aloc
                ,nm_members_all mem
                ,XBCC_INV_IN_LIST i
				where 
				mem.nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                and aloc.nm_obj_type in (select trim(cast(myrow as varchar2(25))) from il)
                and aloc.nm_ne_id_of = mem.nm_ne_id_of
                and aloc.nm_ne_id_in =i.ne_id_in
				;
		
		cursor c_group_ch_all(d_start_date  date, d_end_date date, s_brams_id varchar2) is
			with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select s_group_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                        , n as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
						select distinct * from (
                            SELECT 
                                mem.nm_ne_id_in         mem_nm_ne_id_in,
                                aloc.nm_ne_id_in            aloc_nm_ne_id_in
                                ,aloc. nm_date_modified aloc_nm_date_modified  
                                ,aloc.nm_date_created    aloc_nm_date_created 
                                , aloc.nm_start_date        aloc_nm_start_date
                                , aloc.nm_end_date        aloc_nm_end_date
                                , aloc.nm_obj_type          aloc_nm_obj_type
                                ,i.ne_name_1                 i_ne_descr   --ne_name_1 listed as street sub in type_columns
                            FROM 
                            -- keeping redundant table to keep code like the others
                                nm_elements_all i 
                                ,nm_members_all aloc
                                ,nm_members_all mem                            
                            WHERE 1=1
                                --and mem.nm_ne_id_in like s_brams_id
                                AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from n)  
                                AND aloc.nm_type = 'G'       
                                AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from m)                    
                                AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
                                and aloc.nm_ne_id_of = i.ne_id            --makes aloc and mem redundant
								--and rownum < 50  --tester
                    and (   
							(trunc(aloc.nm_date_modified) between d_start_date and d_end_date and trunc(aloc.nm_date_modified) <> d_start_date)
                            --   or 
							-- (trunc(ne_date_modified) between d_start_date and d_end_date and trunc(ne_date_modified) <> d_start_date)
							)
						union all
						SELECT 
                                mem.nm_ne_id_in         mem_nm_ne_id_in,
                                aloc.nm_ne_id_in            aloc_nm_ne_id_in
                                ,aloc. nm_date_modified aloc_nm_date_modified  
                                ,aloc.nm_date_created    aloc_nm_date_created 
                                , aloc.nm_start_date        aloc_nm_start_date
                                , aloc.nm_end_date        aloc_nm_end_date
                                , aloc.nm_obj_type          aloc_nm_obj_type
                                ,i.ne_name_1                 i_ne_descr   --ne_name_1 listed as street sub in type_columns
                            FROM 
                            -- keeping redundant table to keep code like the others
                                nm_elements_all i 
                                ,nm_members_all aloc
                                ,nm_members_all mem                            
                            WHERE 1=1
                                --and mem.nm_ne_id_in like s_brams_id
                                AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from n)  
                                AND aloc.nm_type = 'G'       
                                AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from m)                    
                                AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
                                and aloc.nm_ne_id_of = i.ne_id            --makes aloc and mem redundant
								--and rownum < 50  --tester
                    and (   
						--	(trunc(aloc.nm_date_modified) between d_start_date and d_end_date and trunc(aloc.nm_date_modified) <> d_start_date)
                        --       or 
							 (trunc(ne_date_modified) between d_start_date and d_end_date and trunc(ne_date_modified) <> d_start_date))							 
						);
						
		cursor c_group_ch_id(d_start_date  date, d_end_date date, s_brams_id number) is
			with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select s_group_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                        , n as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                            SELECT 
                                mem.nm_ne_id_in         mem_nm_ne_id_in,
                                aloc.nm_ne_id_in            aloc_nm_ne_id_in
                                ,aloc. nm_date_modified aloc_nm_date_modified  
                                ,aloc.nm_date_created    aloc_nm_date_created 
                                , aloc.nm_start_date        aloc_nm_start_date
                                , aloc.nm_end_date        aloc_nm_end_date
                                , aloc.nm_obj_type          aloc_nm_obj_type
                                ,i.ne_name_1                 i_ne_descr   --ne_name_1 listed as street sub in type_columns
                            FROM 
                            -- keeping redundant table to keep code like the others
                                nm_elements_all i 
                                ,nm_members_all aloc
                                ,nm_members_all mem                            
                            WHERE 1=1
                                and mem.nm_ne_id_in = s_brams_id
                                AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from n)  
                                AND aloc.nm_type = 'G'       
                                AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from m)                    
                                AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
                                and aloc.nm_ne_id_of = i.ne_id            --makes aloc and mem redundant
								--and rownum < 50  --tester
                    and (   
							(trunc(aloc.nm_date_modified) between d_start_date and d_end_date and trunc(aloc.nm_date_modified) <> d_start_date)
                               or 
							 (trunc(ne_date_modified) between d_start_date and d_end_date and trunc(ne_date_modified) <> d_start_date)
						);
		
		cursor c_get_owner(n_brams_id number, s_cor_type varchar2, d_end_date date) is
			select
				mem_nm_ne_id_in,
				i_asset_owner,
				min(slk) slk,
				max(end_slk) end_slk
				--,Indicator
			from (
					select
						mem_nm_ne_id_in,
						i_asset_owner,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_asset_owner order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_asset_owner order by slk)) <> slk then slk  else null end DBTSMP
						--,Indicator
					from (
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.IIT_CHR_ATTRIB26     i_asset_owner
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk  
								,case
									when i.iit_end_date is not null then 'D'                                        
									when trunc(i.iit_date_created) = trunc(i.iit_date_modified) then 'I'
									else 'C'
									end Indicator								
							FROM 
								nm_inv_items_all i -- (select iit_ne_id from  nm_inv_items where 1=1 and iit_inv_type = :INV_TYPE)) aloc
								,nm_members_all aloc
								,nm_members_all mem                            
							WHERE 1=1
								and mem.nm_ne_id_in = n_brams_id
								AND mem.nm_obj_type in (s_cor_type)
								AND aloc.nm_type = 'I'       
								AND aloc.nm_obj_type in ('ASOW')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.iit_ne_id
								and mem.nm_start_date <= d_end_date AND NVL (mem.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								and aloc.nm_start_date <= d_end_date  AND NVL (aloc.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								and i.iit_start_date <= d_end_date  AND NVL (i.iit_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
							) 
					)
			group by mem_nm_ne_id_in, i_asset_owner--, DBTSMP, DB
			order by slk
			;
			
		cursor c_get_ward(n_brams_id number, s_cor_type varchar2, d_end_date date) is
			select
				mem_nm_ne_id_in,
				i_ne_descr,
				min(slk) slk,
				max(end_slk) end_slk				
			from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP						
					from (
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_descr   			  i_ne_descr
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk 
								,case
									when i.ne_end_date is not null then 'D'                                        
									when trunc(i.ne_date_created) = trunc(i.ne_date_modified) then 'I'
									else 'C'
									end Indicator								
							FROM 
								nm_elements_all i -- (select iit_ne_id from  nm_inv_items where 1=1 and iit_inv_type = :INV_TYPE)) aloc
								,nm_members_all aloc
								,nm_members_all mem                            
							WHERE 1=1
								and mem.nm_ne_id_in = n_brams_id
								AND mem.nm_obj_type in (s_cor_type)
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('OPWD')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
								and mem.nm_start_date <= d_end_date AND NVL (mem.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								and aloc.nm_start_date <= d_end_date  AND NVL (aloc.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								-- and i.ne_start_date <= d_end_date  AND NVL (i.ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
							) 
					)
			group by mem_nm_ne_id_in, i_ne_descr --, DBTSMP, DB
			order by slk
			;
			

		cursor c_get_las_region(n_brams_id number, s_cor_type varchar2, d_end_date date) is
			select
				mem_nm_ne_id_in,
				i_ne_descr,
				min(slk) slk,
				max(end_slk) end_slk				
			from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP						
					from (
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_group   			  i_ne_descr   --LAS region is ne_group
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk   								
							FROM 
								nm_elements_all i -- (select iit_ne_id from  nm_inv_items where 1=1 and iit_inv_type = :INV_TYPE)) aloc
								,nm_members_all aloc
								,nm_members_all mem                            
							WHERE 1=1
								and mem.nm_ne_id_in = n_brams_id
								AND mem.nm_obj_type in (s_cor_type)
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('OPWD')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
								and mem.nm_start_date <= d_end_date AND NVL (mem.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								and aloc.nm_start_date <= d_end_date  AND NVL (aloc.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								-- and i.ne_start_date <= d_end_date  AND NVL (i.ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
							) 
					)
			group by mem_nm_ne_id_in, i_ne_descr --, DBTSMP, DB
			order by slk
			;

		cursor c_get_suburb(n_brams_id number, s_cor_type varchar2, d_end_date date) is
			select
				mem_nm_ne_id_in,
				i_ne_descr,
				min(slk) slk,
				max(end_slk) end_slk                		
			from (      
            select a.*
            		, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
             from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP
					from ( 
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_name_2   			  i_ne_descr   --subburb
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk						
							FROM 
								(select * from nm_elements_all where ne_nt_type in  ('KSUB','VESB','STSB')) i 
								,nm_members_all aloc
								,nm_members_all mem                            
							WHERE 1=1
								--and i.iit_x_sect = 'XCS' 
								and mem.nm_ne_id_in like n_brams_id
								AND mem.nm_obj_type in (s_cor_type)
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('KSUB','VESB','STSB')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
								and mem.nm_start_date <= d_end_date AND NVL (mem.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								and aloc.nm_start_date <= d_end_date  AND NVL (aloc.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date
								-- and i.ne_start_date <= d_end_date  AND NVL (i.ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date  
                                                            --order by slk                                                              
							)      -- order by slk   
                            )        a --order by slk                                                                  
					)
			group by mem_nm_ne_id_in, i_ne_descr, DBSMP
			order by slk
			;
						
			
			cursor c_get_condition(n_brams_id number, s_cor_type varchar2, d_end_date date) is
				with g as  
					(SELECT EXTRACT(column_value,'/e/text()') myrow from (select 'CBSC,CALL,KCON' col1 from dual) x,
					TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
					)
				, c as  
					(SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_cor_type col1 from dual) x,
					TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
					)
				,base1 as( -- needed to hint it b/c QO was doing unnecessary TFS
					SELECT /*+ materialize */ 
						mem.nm_ne_id_in         mem_nm_ne_id_in,
						aloc.nm_ne_id_in            aloc_nm_ne_id_in
						,aloc. nm_date_modified aloc_nm_date_modified  
						,aloc.nm_date_created    aloc_nm_date_created 
						, aloc.nm_start_date        aloc_nm_start_date
						, aloc.nm_end_date        aloc_nm_end_date
						, aloc.nm_obj_type          aloc_nm_obj_type
						,iit_x_sect							
						,case aloc.nm_obj_type 
						when 'CBSC' then to_char(IIT_NUM_ATTRIB102)
						when 'CALL' then to_char(IIT_NUM_ATTRIB100)
						when 'KCON'  then IIT_CHR_ATTRIB26
						else null
						end     Condition
						,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
						,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk
					FROM 
						nm_inv_items_all i
						,(select * from nm_members_all where nm_obj_type in (select trim( cast(myrow as varchar2(25))) from g)  ) aloc		
						,(select * from nm_members_all where nm_ne_id_in like  n_brams_id and   nm_obj_type in (select trim( cast(myrow as varchar2(25))) from c))  mem              
					WHERE 1=1
						and ((i.iit_x_sect = 'XCS' and i.iit_inv_type = 'CBSC') OR (i.iit_x_sect in( 'XKE', 'XKO') and i.iit_inv_type = 'KCON') OR (i.iit_x_sect in( 'XVE2','XVO2') and i.iit_inv_type = 'CALL') )
						and mem.nm_ne_id_in like  n_brams_id
						AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from c) 		
						AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from g)                     
						AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
						and aloc.nm_ne_id_in = i.iit_ne_id
						and mem.nm_start_date <=  d_end_date AND NVL (mem.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  d_end_date
						and aloc.nm_start_date <=  d_end_date  AND NVL (aloc.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  d_end_date
						and i.iit_start_date <=  d_end_date  AND NVL (i.iit_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  d_end_date
					)
				,base2 as  
					(select 
						mem_nm_ne_id_in
						,aloc_nm_obj_type
						,slk
						,end_slk
						,max(decode(iit_x_sect,'XCS',condition,'XKE',condition,'XVE2',condition,-99))  p_condition
						,max(decode(iit_x_sect,'XKO',condition,'XVO2',condition,-99))  s_condition
					from base1 
					group by 
						mem_nm_ne_id_in
						,aloc_nm_obj_type
						,slk
						,end_slk
					order by slk
					)
				,base3 as (
					select 
					mem_nm_ne_id_in
					,aloc_nm_obj_type
					,slk
					,end_slk
					, case when p_condition <> -99 then 	p_condition
					when s_condition <> -99 then 	s_condition
					else null end condition
					from base2
					)
				select
					mem_nm_ne_id_in,
					i_ne_descr i_ne_descr,
					min(slk) slk,
					max(end_slk) end_slk				
				from (
					select a.*
					, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
					else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
					from (
						select
						mem_nm_ne_id_in,
						Condition i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in,Condition order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, Condition order by slk)) <> slk then slk  else null end DBTSMP							
						from (	select * from base3 )
						) a
					)
				group by mem_nm_ne_id_in, i_ne_descr , DBSMP
				order by mem_nm_ne_id_in, slk
				;
			
		cursor c_cor_list_seg is select distinct corr_ne_id ne_id from XBCC_CORR_SEG_LIST;
		cursor c_inv_list_seg is select distinct corr_ne_id ne_id from XBCC_INV_LIST;
		cursor c_group_list_seg is select distinct corr_ne_id ne_id from XBCC_group_LIST;
		cursor c_cor_list_cor is select distinct ne_id from XBCC_CORR_LIST;
------
		procedure date_check(d_sd date, d_ed date) as 		

			
			begin	--date_check
			
				s_log_area := 'DataCheck';  -- log area			
				s_err_text  := null;
				
				if d_sd = d_ed then
					s_err_text := 'Start Date and End Date cannot be the same value.';
				elsif d_sd > d_ed then
					s_err_text := 'Start Date cannot be greater than End Date.';
				elsif d_sd is null or d_ed is null then
					s_err_text := 'Date cannot be NULL.';
				end if;
				if s_err_text is not null then
					raise ex_sap_sync;
				end if;
			exception
				when ex_sap_sync then
					s_log_base_info := 'Error';
					s_log_text := s_err_text;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					raise_application_error(-20001, s_err_text);		
		end	date_check;
		
		procedure brams_id_checked(n_brams_test in number) as
			n_count number;
			n_brams number;
			begin
				s_log_area := 'BRAMS ID Check';  -- log area
				n_brams := n_brams_test;
				if length(n_brams) = 10 then  -- check to see if this is really med.
					n_brams := n_brams_id - 9000000000;
					
					select count(*) into n_count from nm_elements_all where ne_id = n_brams and ne_nt_type in ('RDCO');
					
					if n_count = 0 then --assume the correct whole ID was given
						s_brams_id_chkd := n_brams_test;				
						b_is_med := false;
					else
						s_brams_id_chkd := n_brams;
						b_is_med := true;
					end if;
				else
					s_brams_id_chkd := n_brams_test;				
					b_is_med := false;
				end if;
		END brams_id_checked;
		
		function find_cor_indicator(n_ne_id number) return varchar2 as
			r_nm_elements nm_elements_all%rowtype;
			n_count number;
			begin
				select count(*) into n_count from nm_elements_all where ne_id = n_ne_id;   -- should always have 1
				
				if n_count = 1 then
					
					select * into r_nm_elements from nm_elements_all where ne_id = n_ne_id;   -- should always have 1
					
					if r_nm_elements.ne_end_date  is not  null then
						return 'D';
					elsif r_nm_elements.ne_date_modified = r_nm_elements.ne_date_created then
						return 'I';
					else 
						return 'C';
					end if;
					
				else
					null;
				end if;
				
				return 'ZZ'; -- something went wrong
			end find_cor_indicator;
		
		procedure write_output_corridor(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			function get_desc (s_name varchar2, s_type varchar2) return varchar2 as
				s_ret varchar2(40);
				n_count number;
				begin
					case s_type
						when 'G' then
							select count(*) into n_count from nm_group_types where ngt_nt_type = s_name;
							if n_count = 0 then
								s_ret := 'unknown group/item type';
							else
								select ngt_descr into s_ret from nm_group_types where ngt_nt_type = s_name;
							end if;
						else
							s_ret := 'unknown group/item type';
					end case;
						
					s_log_base_info := 'Informational - Get Description for: ';
					s_log_text := s_name || ', ' || s_type || ', ' || s_ret;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
					
					return s_ret;				
			end get_desc;
			
			begin
			
			select count(*) into n_count from nm_members_all where nm_ne_id_in = n_ne_id and nm_start_date <= d_end_date AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date;
					if n_count = 0 then		-- should never happen
						n_slk := -999;
						n_end_slk := -999;
					else
						select min(nm_slk), max(nm_end_slk) into n_slk, n_end_slk from nm_members_all where nm_ne_id_in = n_ne_id and nm_start_date <= d_end_date AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) > d_end_date;
					end if;					
                 
				s_desc := get_desc (r_elements.ne_nt_type, 'G');
				if b_write_med = true then   -- write median info
					n_ne_id_out := 9000000000 + n_ne_id;
					s_desc := 'Median Corridor';
				end if;
				
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor|| ', ' ||n_ne_id_out|| ', ' ||substr(s_desc,1,30)|| ', ' ||r_elements.ne_unique|| ', ' ||n_slk|| ', ' ||n_end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				
				insert into xbcc_sap_sync_output values ( 1,
														s_indicator_cor
														,n_ne_id_out
														,substr(s_desc,1,30)
														,r_elements.ne_unique
														,n_slk
														,n_end_slk
														);
		end write_output_corridor;
		
		procedure write_output_owner(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			begin
			
				
			
			if b_write_med = true then   -- write median info
				n_ne_id_out := 9000000000 + n_ne_id;					
			end if;
			
			s_desc := 'Asset Owner';
			
			for r_row in c_get_owner(n_ne_id,r_elements.ne_nt_type,d_end_date) loop
		
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor || ', ' || n_ne_id_out || ', ' || s_desc  || ', ' || r_row.i_asset_owner || ', ' || r_row.slk || ', ' || r_row.end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				
				insert into xbcc_sap_sync_output values ( 2,
														s_indicator_cor --r_row.indicator
														,n_ne_id_out
														,substr(s_desc,1,30)
														,r_row.i_asset_owner
														,r_row.slk
														,r_row.end_slk
															);
			end loop;
		end write_output_owner;
		
		procedure write_output_ward(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			begin
			
				
			
			if b_write_med = true then   -- write median info
				n_ne_id_out := 9000000000 + n_ne_id;					
			end if;
			
			s_desc := 'Ward Name';
			
			for r_row in c_get_ward(n_ne_id,r_elements.ne_nt_type,d_end_date) loop
		
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor || ', ' || n_ne_id_out || ', ' || s_desc  || ', ' || r_row.i_ne_descr || ', ' || r_row.slk || ', ' || r_row.end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				
				insert into xbcc_sap_sync_output values ( 3,
														s_indicator_cor --r_row.indicator
														,n_ne_id_out
														,substr(s_desc,1,30)
														,r_row.i_ne_descr
														,r_row.slk
														,r_row.end_slk
															);
			end loop;
		end write_output_ward;

		procedure write_output_las(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			begin
			
				
			
			if b_write_med = true then   -- write median info
				n_ne_id_out := 9000000000 + n_ne_id;					
			end if;
			
			s_desc := 'LAS Region';
			
			for r_row in c_get_las_region(n_ne_id,r_elements.ne_nt_type,d_end_date) loop
		
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor || ', ' || n_ne_id_out || ', ' || s_desc  || ', ' || r_row.i_ne_descr || ', ' || r_row.slk || ', ' || r_row.end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				if r_row.i_ne_descr is not null then
					insert into xbcc_sap_sync_output values ( 4,
															s_indicator_cor --r_row.indicator
															,n_ne_id_out
															,substr(s_desc,1,30)
															,r_row.i_ne_descr
															,r_row.slk
															,r_row.end_slk
																);
				end if;
			end loop;
		end write_output_LAS;

procedure write_output_suburb(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			begin
			
				
			
			if b_write_med = true then   -- write median info
				n_ne_id_out := 9000000000 + n_ne_id;					
			end if;
			
			s_desc := 'Suburb';
			
			for r_row in c_get_Suburb(n_ne_id,r_elements.ne_nt_type,d_end_date) loop
		
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor || ', ' || n_ne_id_out || ', ' || s_desc  || ', ' || r_row.i_ne_descr || ', ' || r_row.slk || ', ' || r_row.end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				
				insert into xbcc_sap_sync_output values ( 5,
														s_indicator_cor --r_row.indicator
														,n_ne_id_out
														,substr(s_desc,1,30)
														,r_row.i_ne_descr
														,r_row.slk
														,r_row.end_slk
															);
			end loop;
		end write_output_suburb;
		
procedure write_output_condition(n_ne_id number,b_write_med boolean, d_end_date date, r_elements nm_elements_all%rowtype ) as
			n_ne_id_out number := n_ne_id;
			
			begin
			
				
			-- MED not needed for condition
			if b_write_med = true then   -- write median info
				n_ne_id_out := 9000000000 + n_ne_id;					
			end if;
			
			s_desc := 'Condition';
			
				s_log_base_info := 'Informational - asking for: ';
				s_log_text := n_ne_id|| ', ' ||r_elements.ne_nt_type|| ', ' ||d_end_date;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
			
			for r_row in c_get_condition(n_ne_id,r_elements.ne_nt_type,d_end_date) loop
		
				s_log_base_info := 'Informational - inserting: ';
				s_log_text := s_indicator_cor || ', ' || n_ne_id_out || ', ' || s_desc  || ', ' || r_row.i_ne_descr || ', ' || r_row.slk || ', ' || r_row.end_slk;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );	
				
				insert into xbcc_sap_sync_output values ( 6,
														s_indicator_cor --r_row.indicator
														,n_ne_id_out
														,substr(s_desc,1,30)
														,r_row.i_ne_descr
														,r_row.slk
														,r_row.end_slk
															);
			end loop;
		end write_output_condition;
	-- BEGIN PROCESS_refcur ---------------------------------------------------
	-- BEGIN PROCESS_refcur --------------------------------------------------- 
	-- BEGIN PROCESS_refcur --------------------------------------------------- 		
	-- BEGIN PROCESS_refcur ---------------------------------------------------
	-- BEGIN PROCESS_refcur --------------------------------------------------- 
	-- BEGIN PROCESS_refcur --------------------------------------------------- 
	begin  --process_refcur --------------------------------------------------- 
		
		if b_log_to_x_log_information = true then x_log_table.debug_on; end if;
		
		s_module := upper('XBCC_SAP_SYNC-PROCESS_REFCUR');
			
		x_log_table.clean(s_module);  -- remove existing log file entries
		
		s_log_area := 'Main-1'; 
		s_log_base_info := 'Information';
		s_log_text := 'Begin with parameters (d_start_date in  date, d_end_date in date,  n_brams_id in number default null: '   || d_start_date  || ', ' ||  d_end_date  || ', ' ||  n_brams_id  ;
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
		
		date_check(d_start_date, d_end_date);
		
		s_log_area := 'Main-1a'; 
		if n_brams_id is not null and n_brams_id <>0 then   -- <>0 added to deal with fake nulls coming from the web service.
			brams_id_checked(n_brams_id);
			
			s_log_area := 'Main-1b'; 
			--lets see if the id is in the networks
			select count(*) into n_count from nm_elements_all where ne_id = s_brams_id_chkd and ne_nt_type in (select trim(cast(myrow as varchar2(25))) from (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  s_route_type col1 from dual) x, TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))));
			
				s_log_base_info := 'Informational - select count(*) into n_count from nm_members_all where ne_id = s_brams_id_chkd and ne_nt_type in (s_route_type); ';
				s_log_text := 'For Checked ID ' ||s_brams_id_chkd|| ' count is ' || n_count;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
			
			if n_count = 0 then
				s_log_base_info := 'Informational - select count(*) into n_count from nm_members_all where ne_id = s_brams_id_chkd and ne_nt_type in (s_route_type); ';
				s_log_text := 'GIVEN ID is not in a cooridoor';
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
				rc_recordset := null;
				return;  -- no need to continue;
			end if;
		else  -- no brams id given
			s_brams_id_chkd := '%';
		end if;
		
		s_log_area := 'Main-2'; 
		s_log_base_info := 'Informational - Getting Cor d_start_date , d_end_date ,  s_brams_id_chkd ';
		s_log_text := d_start_date ||', '|| d_end_date ||', '||  s_brams_id_chkd;
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
		
		if s_brams_id_chkd = '%' then
			for r_row in c_corridor_ch_all(d_start_date , d_end_date ,  s_brams_id_chkd) loop
				
				if r_row.nm_end_date  is not  null then
					s_indicator := 'D';
				elsif r_row.nm_date_modified = r_row.nm_date_created then
					s_indicator := 'I';
				else 
					s_indicator := 'C';
				end if;			
				insert into XBCC_CORR_SEG_LIST values (r_row.nm_ne_id_in,r_row.nm_ne_id_of,r_row.nm_start_date,r_row.nm_end_date,r_row.nm_date_modified, r_row.nm_date_created, s_indicator);
			end loop;
		elsif nvl(LENGTH(TRIM(TRANSLATE(s_brams_id_chkd, ' +-.0123456789', ' '))), -99) = -99 then
			for r_row in c_corridor_ch_id(d_start_date , d_end_date ,  cast(s_brams_id_chkd as number)) loop
				
				if r_row.nm_end_date  is not  null then
					s_indicator := 'D';
				elsif r_row.nm_date_modified = r_row.nm_date_created then
					s_indicator := 'I';
				else 
					s_indicator := 'C';
				end if;			
				insert into XBCC_CORR_SEG_LIST values (r_row.nm_ne_id_in,r_row.nm_ne_id_of,r_row.nm_start_date,r_row.nm_end_date,r_row.nm_date_modified, r_row.nm_date_created, s_indicator);
			end loop;
		end if;
		
		--return;
		
		s_log_area := 'Main-3-boolean'; 
		s_log_base_info := 'Informational - Only do Segments?  ';
		 if b_Only_Check_Cooridor = true then s_log_text := 'TRUE'; else s_log_text := 'FALSE'; end if;
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
		
		  -- this way was too slow and mem consuming used only when ID is given
		if b_Only_Check_Cooridor = false then
			s_log_area := 'Main-3'; 
			s_log_base_info := 'Informational - Getting Inv d_start_date , d_end_date ,  s_brams_id_chkd ';
			s_log_text := d_start_date ||', '|| d_end_date ||', '||  s_brams_id_chkd || ',GLOBAL: ' ||s_inv_type|| ', ' ||s_route_type;
			x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
			if s_brams_id_chkd <> '%'  then 
				for r_row in c_inv_ch_id(d_start_date , d_end_date ,  s_brams_id_chkd) loop
					
					if r_row.aloc_nm_end_date  is not  null then
						s_indicator := 'D';
					elsif r_row.aloc_nm_date_modified = r_row.aloc_nm_date_created then
						s_indicator := 'I';
					else 
						s_indicator := 'C';
					end if;
					
					/*s_log_area := 'Main-3a'; 
					s_log_base_info := 'r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in';
					s_log_text := r_row.mem_nm_ne_id_in|| ', ' ||r_row.aloc_nm_ne_id_in;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text ); */
							
					
					insert into XBCC_INV_LIST values (r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in,r_row.aloc_nm_start_date,r_row.aloc_nm_end_date,r_row.aloc_nm_date_modified, r_row.aloc_nm_date_created, s_indicator);
				end loop;
			else
			/* trying a bulk insert
				for r_row in c_inv_ch_mem_in_list(d_start_date , d_end_date ,  s_brams_id_chkd) loop
					insert into XBCC_INV_IN_LIST values (r_row.ne_id);
				end loop;
				*/
				
				open c_inv_ch_mem_in_list(d_start_date , d_end_date ,  s_brams_id_chkd);
				loop
					fetch c_inv_ch_mem_in_list bulk collect into l_data limit 10000;
					forall i in 1..l_data.count
						insert into XBCC_INV_IN_LIST values l_data(i);
					EXIT WHEN c_inv_ch_mem_in_list%NOTFOUND;
				end loop;
				close c_inv_ch_mem_in_list;
				
				s_log_area := 'Main-3-building cooridor list'; 
				s_log_base_info := 'Informational - Getting Inv d_start_date , d_end_date ,  s_brams_id_chkd ';
				s_log_text := d_start_date ||', '|| d_end_date ||', '||  s_brams_id_chkd || ',GlOBAL: ' ||s_inv_type|| ', ' ||s_route_type;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
				
				/* **  Trying a bulk insert
				
				for r_row in c_inv_ch loop
					insert into XBCC_INV_LIST (corr_ne_id) values (r_row.ne_id);
				end loop;
				*/
				
				open c_inv_ch;
				loop
					fetch c_inv_ch bulk collect into l_data2 limit 10000;
					forall i in 1..l_data2.count
						insert into XBCC_INV_LIST values l_data2(i);
					EXIT WHEN c_inv_ch%NOTFOUND;
				end loop;
				close c_inv_ch;
				
				--return;
				
				s_log_area := 'Main-3a'; 
				s_log_base_info := 'Informational - Getting GROUP d_start_date , d_end_date ,  s_brams_id_chkd ';
				s_log_text := d_start_date ||', '|| d_end_date ||', '||  s_brams_id_chkd || ',GLOBAL: ' ||s_group_type|| ', ' ||s_route_type;
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
				
				
		if s_brams_id_chkd = '%' then
				for r_row in c_group_ch_all(d_start_date , d_end_date ,  s_brams_id_chkd) loop
					
					if r_row.aloc_nm_end_date  is not  null then
						s_indicator := 'D';
					elsif r_row.aloc_nm_date_modified = r_row.aloc_nm_date_created then
						s_indicator := 'I';
					else 
						s_indicator := 'C';
					end if;
					
					/*s_log_area := 'Main-3a'; 
					s_log_base_info := 'r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in';
					s_log_text := r_row.mem_nm_ne_id_in|| ', ' ||r_row.aloc_nm_ne_id_in;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text ); */
					
					insert into XBCC_group_LIST values (r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in,r_row.aloc_nm_start_date,r_row.aloc_nm_end_date,r_row.aloc_nm_date_modified, r_row.aloc_nm_date_created, s_indicator);
				end loop;
		elsif nvl(LENGTH(TRIM(TRANSLATE(s_brams_id_chkd, ' +-.0123456789', ' '))), -99) = -99 then
				for r_row in c_group_ch_id(d_start_date , d_end_date ,  cast(s_brams_id_chkd as number)) loop
					
					if r_row.aloc_nm_end_date  is not  null then
						s_indicator := 'D';
					elsif r_row.aloc_nm_date_modified = r_row.aloc_nm_date_created then
						s_indicator := 'I';
					else 
						s_indicator := 'C';
					end if;
					
					/*s_log_area := 'Main-3a'; 
					s_log_base_info := 'r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in';
					s_log_text := r_row.mem_nm_ne_id_in|| ', ' ||r_row.aloc_nm_ne_id_in;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text ); */
					
					insert into XBCC_group_LIST values (r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in,r_row.aloc_nm_start_date,r_row.aloc_nm_end_date,r_row.aloc_nm_date_modified, r_row.aloc_nm_date_created, s_indicator);
				end loop;
		end if;
				
				
				for r_row in c_group_ch_all(d_start_date , d_end_date ,  s_brams_id_chkd) loop
					
					if r_row.aloc_nm_end_date  is not  null then
						s_indicator := 'D';
					elsif r_row.aloc_nm_date_modified = r_row.aloc_nm_date_created then
						s_indicator := 'I';
					else 
						s_indicator := 'C';
					end if;
					
					/*s_log_area := 'Main-3a'; 
					s_log_base_info := 'r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in';
					s_log_text := r_row.mem_nm_ne_id_in|| ', ' ||r_row.aloc_nm_ne_id_in;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text ); */
					
					insert into XBCC_group_LIST values (r_row.mem_nm_ne_id_in,r_row.aloc_nm_ne_id_in,r_row.aloc_nm_start_date,r_row.aloc_nm_end_date,r_row.aloc_nm_date_modified, r_row.aloc_nm_date_created, s_indicator);
				end loop;
			end if;
		end if;	
		--return;
		--Start filling the corridor list
		
		
		for r_row in c_cor_list_seg loop
			insert into XBCC_CORR_LIST (ne_id) values (r_row.ne_id);
		end loop;
		
		for r_row in c_inv_list_seg loop
			insert into XBCC_CORR_LIST (ne_id) values (r_row.ne_id);
		end loop;
		
		for r_row in c_group_list_seg loop
			insert into XBCC_CORR_LIST (ne_id) values (r_row.ne_id);
		end loop;
		
		
		
		
		
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		---- NEED the ID's form INV
		
		
		for r_row in c_cor_list_cor loop
			s_log_area := 'Main-4'; 
			s_indicator_cor := find_cor_indicator(r_row.ne_id);
			
			
			select count(*) into n_count from nm_elements_all where ne_id = r_row.ne_id;   -- should always have 1
			
			if n_count = 1 then					
				select * into r_elements from nm_elements_all where ne_id = r_row.ne_id;   -- should always have 1
			else
				s_indicator_cor := 'ZZ';
			end if;
			
			case s_indicator_cor
				when 'D' then
					
					if b_is_med = false 				then 			write_output_corridor(r_row.ne_id, false, d_end_date, r_elements); 				end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_corridor(r_row.ne_id, true, d_end_date, r_elements);				end if;
				when 'ZZ' then
					--Something is wrong							
					s_log_base_info := 'Informational - Issue finding cooridor Indicator for: ';
					s_log_text := r_row.ne_id;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					
				else  -- Inserted or Changed
					if b_is_med = false 				then 			write_output_corridor(r_row.ne_id, false, d_end_date, r_elements); 				end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_corridor(r_row.ne_id, true, d_end_date, r_elements);				 end if;
					
					--Now for the characteristics
					if b_is_med = false 				then 			write_output_owner(r_row.ne_id, false, d_end_date, r_elements); 				end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_owner(r_row.ne_id, true, d_end_date, r_elements);					end if;
					
					if b_is_med = false 				then 			write_output_ward(r_row.ne_id, false, d_end_date, r_elements); 					end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_ward(r_row.ne_id, true, d_end_date, r_elements);					end if;				

					if b_is_med = false 				then 			write_output_las(r_row.ne_id, false, d_end_date, r_elements); 					end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_las(r_row.ne_id, true, d_end_date, r_elements);					end if;					

					if b_is_med = false 				then 			write_output_suburb(r_row.ne_id, false, d_end_date, r_elements); 					end if;  -- Don't write if a MED brams ID was given
					if r_elements.ne_nt_type = 'RDCO'	then 			write_output_suburb(r_row.ne_id, true, d_end_date, r_elements);					end if;					
					
					if b_is_med = false 				then 			write_output_condition(r_row.ne_id, false, d_end_date, r_elements); 					end if;  -- Don't write if a MED brams ID was given
					--if r_elements.ne_nt_type = 'RDCO'	then 			write_output_condition(r_row.ne_id, true, d_end_date, r_elements);					end if;					-- Not needed for MED
					
			end case;
		
		end loop;
		
		s_log_area := 'Completed';
		s_log_base_info := 'Informational - Total Process Time (end time, start time, difference, difference *86400): ';
		s_log_text := sysdate || ', ' || d_start_time || ', ' || to_char(sysdate - d_start_time) || ', ' || to_char((sysdate - d_start_time) * 86400);
		--x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
		
		OPEN rc_recordset for select  indicator, brams_id, object, name, "START", "END" from XBCC_SAP_SYNC_OUTPUT order by brams_id, sorter, "START" ;
		

	end process_refcur;
end XBCC_SAP_SYNC;
/