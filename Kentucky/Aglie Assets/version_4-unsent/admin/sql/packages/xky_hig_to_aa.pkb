create or replace package body xky_hig_to_aa is
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2013.10.29, JMM
	UPDATE02:	Fixed varchar2 length in a function, 2014.02.04, JMM
	UPDATE03:	Fixed issue with recalibrate and issues stemming from that change, 2014.03.25, JMM
	UPDATE04:	Fixed issue Array becoming too large in R_Input_Loop-3, 2014.01.07, JMM
	UPDATE05:	Minor Improvements and defect fixes reported by AA, 2015.01.15, JMM
*/
	
	
	s_module varchar2(30);
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);
	err_num NUMBER;
	err_msg VARCHAR2(200);
	n_idx	number;
	s_route_type varchar2(8) := 'RT';
	s_route_dbreak varchar2(8) := 'DB';
		
	b_debug boolean := false;
	--b_debug boolean := true;
	
-----------------------------		Route Events		-----------------------------
-----------------------------		Route Events		-----------------------------
-----------------------------		Route Events		-----------------------------
		procedure process_route_events(s_test_route in varchar2 default  '%', b_debug_in in boolean default false) as
		
			cursor c_route_list is select * from xaa_loc_ident 
					where route_name like s_test_route OR loc_ident like s_test_route
					;
			
			--cursor c_mem_all(n_rt_id number,offset_from number, offset_to number, historic_date date ) is select * from nm_members_all where nm_obj_type = s_route_type and  nm_ne_id_in = n_rt_id  and nm_slk >= offset_from and nm_end_slk <=offset_to and nm_members_all.nm_end_date >= historic_date;
			
			cursor c_chk_cont is 
				select  count(*) over () cnt, ne_id_in , min(slk) start_slk ,max(end_slk) end_slk, op        from (   
				  select         
						ne_id_in , ne_id_of , slk, end_slk, op
						, Case when (lag (slk) over (partition by ne_id_in,OP order by slk, end_slk) = slk AND lag (end_slk) over (partition by ne_id_in order by slk, end_slk) = end_slk) then (last_value (DBTSMP ignore nulls) over (partition by ne_id_in order by slk, end_slk rows between unbounded preceding and 1 preceding))
							when lag (end_slk) over (partition by ne_id_in,OP order by slk, end_slk) <> slk 
							OR (lag (end_slk) over (partition by ne_id_in,OP order by slk, end_slk) is null) then slk
							else (last_value (DBTSMP ignore nulls) over (partition by ne_id_in,OP order by slk, end_slk rows between unbounded preceding and 1 preceding)) end DBSMP
						from (                            
								select 
										ne_id_in , ne_id_of, slk , end_slk,  OPT OP       
										, Case when (lag (slk) over (partition by ne_id_in, OPT order by slk, end_slk) = slk AND lag (end_slk) over (partition by ne_id_in order by slk, end_slk) = end_slk) then null
												when (lag (end_slk) over (partition by ne_id_in, OPT order by slk, end_slk) <> slk)   
														OR (lag (end_slk) over (partition by ne_id_in, OPT order by slk, end_slk) is null) 
															then slk  else null end DBTSMP               
									 from 
										--(select distinct a.*, case when op = 'C' then 'C' else null end OPT  from xaa_route_temp_sql a)
										(select distinct ne_id_of, ne_id_in, slk,end_slk, decode(nvl(to_char(ne_end_date), 'O'),'O',null,'C') OPT from xaa_route_temp_sql a,nm_elements_all b where	a.ne_id_of = b.ne_id group by  ne_id_in, slk,end_slk, ne_id_of,ne_end_date order by ne_id_in, slk,end_slk )
									where 1=1                       
										order by ne_id_in, slk, end_slk, dbtsmp                                           
										)                                 
							)                                
							group by    ne_id_in, DBSMP, op
							order by op nulls first,ne_id_in, start_slk 
							;
			cursor c_chk_cont_current is 
				select  count(*) over () cnt, ne_id_in , min(slk) start_slk ,max(end_slk) end_slk, op        from (   
				  select         
						ne_id_in , ne_id_of , slk, end_slk, op
						, Case when (lag (slk) over (partition by ne_id_in,OP order by slk, end_slk) = slk AND lag (end_slk) over (partition by ne_id_in order by slk, end_slk) = end_slk) then (last_value (DBTSMP ignore nulls) over (partition by ne_id_in order by slk, end_slk rows between unbounded preceding and 1 preceding))
							when lag (end_slk) over (partition by ne_id_in,OP order by slk, end_slk) <> slk 
							OR (lag (end_slk) over (partition by ne_id_in,OP order by slk, end_slk) is null) then slk
							else (last_value (DBTSMP ignore nulls) over (partition by ne_id_in,OP order by slk, end_slk rows between unbounded preceding and 1 preceding)) end DBSMP
						from (                            
								select 
										ne_id_in , ne_id_of, slk , end_slk,  OPT OP       
										, Case when (lag (slk) over (partition by ne_id_in, OPT order by slk, end_slk) = slk AND lag (end_slk) over (partition by ne_id_in order by slk, end_slk) = end_slk) then null
												when (lag (end_slk) over (partition by ne_id_in, OPT order by slk, end_slk) <> slk)   
														OR (lag (end_slk) over (partition by ne_id_in, OPT order by slk, end_slk) is null) 
															then slk  else null end DBTSMP               
									 from 
										--(select distinct a.*, case when op = 'C' then 'C' else null end OPT  from xaa_route_temp_sql a)
										(select distinct ne_id_of, ne_id_in, slk,end_slk, decode(nvl(to_char(ne_end_date), 'O'),'O',null,'C') OPT from xaa_route_temp_sql a,nm_elements b where	a.ne_id_of = b.ne_id group by  ne_id_in, slk,end_slk, ne_id_of,ne_end_date order by ne_id_in, slk,end_slk )
									where 1=1                       
										order by ne_id_in, slk, end_slk, dbtsmp                                           
										)                                 
							)                                
							group by    ne_id_in, DBSMP, op
							order by op nulls first,ne_id_in, start_slk 
							;
			
			cursor c_nm_mem_effective_rt(n_rt_id number,n_slk number,n_end_slk number, d_eff_date date ) is
				select a.* from nm_members_all a,nm_elements_all b where
					1=1
					and a.nm_ne_id_of = b.ne_id
					and b.ne_type <> 'D'
					and nm_type = 'G'  
					and nm_obj_type in (s_route_type)
					and nm_ne_id_in = n_rt_id
					and nm_slk >= n_slk
					and nm_end_slk <= n_end_slk
					and (nm_start_date <= trunc(d_eff_date) AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_eff_date))
					order by nm_slk
					;
			
			cursor c_nm_mem_effective_rt_b(n_rt_id number,n_slk number,n_end_slk number, d_eff_date date ) is  -- recalibrate
				select b.* from xaa_route_all_recal a, nm_members_all b where
					1=1
					and b.nm_ne_id_of = a.nm_ne_id_of 
					and a.nm_ne_id_in = n_rt_id
					and a.slk >= n_slk
					and a.end_slk <= n_end_slk	
					and nm_obj_type in (s_route_type)
					and (b.nm_start_date <= trunc(d_eff_date) AND NVL (b.nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_eff_date))					
					order by a.slk
					;
			
			cursor c_current_route(n_route_id number , n_slk number, n_end_slk number) is 			--used to see if the current version of the route happens to have a DB in it
				select * from xaa_route where  route_id = 	n_route_id and offset_from >= n_slk and offset_to <= n_end_slk order by offset_from;
				
			cursor c_post_history_active_route (s_opt_sn varchar2 default '%')  is
				select --(select rt.nm_unique from nm_elements rt where ne_id = a.ne_id_in) 
					 ne_no_start, ne_no_end
					, lead (ne_no_start) over (partition by ne_id_in order by slk) next_start_no
					, lead (ne_id_in) over (partition by ne_id_in order by slk) next_ne_id_in
					, lead (slk) over (partition by ne_id_in order by slk) next_slk
					,   a.* 
				from (select distinct * from xaa_route_temp_sql) a                   
					,nm_elements b                   
				where a.ne_id_of = b.ne_id
					and b.ne_no_start like s_opt_sn  -- so I can call this later to make sure there is a node disconnect
				order by slk;
			
			r_input xaa_loc_ident%rowtype;
			type t_net_ref is varray(50) of XAA_NET_REF%rowtype;
			TYPE typ_neh_table IS table of nm_element_history%rowtype;
			type typ_nm_members_all is table of nm_members_all%rowtype;
			
			type typ_new_ne_id_record is record(ne_id_of number(10), ne_id_in number(10), slk number(10,3), end_slk number(10,3), op varchar2(4));
			type typ_new_ne_id_list is table of typ_new_ne_id_record;
			type typ_numbers is table of number;
			
			type typ_start_end_datum is record(old_ne_id_of number(10), new_ne_id_of number(10), given_slk number(10,3), datum_start_slk number(10,3),datum_end_slk number(10,3));
			
			r_output t_net_ref := t_net_ref();
			r_old_loc typ_neh_table;
			r_new_rt_name nm_element_history%rowtype;
			r_new_id_list typ_new_ne_id_list ;
			
			r_new_id_list_gaps typ_new_ne_id_list ;
			
			r_nm_members_all typ_nm_members_all  := typ_nm_members_all();
			
			-- added in case an item starts in the middle of a datum
			r_start_datum  typ_start_end_datum;			
			r_end_datum  typ_start_end_datum;
			
			n_count number;
			n_row_count number;
			n_code number;
			n_temp number;
			n_old_rt_id number;
			n_old_end_id number;
			r_n_spilt  typ_numbers:= typ_numbers();
			
			
			
			procedure flush_array is
			n_temp_count number;
			
			begin
				dbms_output.put_line('Flushing');
				s_log_area := 'flush_array';  -- log area
				n_temp_count := r_output.count;
						--lets flush our array
				forall xx in r_output.first .. r_output.last
					insert into xaa_net_ref values r_output(xx);
				r_output.delete;							
							
				s_log_base_info := 'Flushing r_output';
				s_log_text :='r_output had ' || n_temp_count || ' items  and needed to be flushed.';
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
				
				r_output := t_net_ref();
				n_idx := 0;		
				
				commit;  --Turned back on to reduce the undo space usage
			end flush_array;
			
			function op_stat_message(s_op varchar2) return varchar2 is
				begin
					case s_op
						when 'S' then
							null;
					end case;
			end op_stat_message;
	
			function route_changed (d_historic date, n_rt_name varchar2, n_beg number, n_end number) return number is
				n_rt_id number;
				n_count integer;
				n_return integer;
				r_route xaa_route%rowtype;
				d_date  date;
				
				
				
				begin
					/* 	Return Codes
						
						1	Item not found
						2	Item not changed
						3	Item found but effective date changed, might be end dated check that out of function.
						4	Multiple items found IN XAA_ROUTE, should not be possible
						5	route name has changed
						6	recalibrate (length of historic may change and hat to look in elements)
						
					*/
				n_return := -1;
				
				
					s_log_area := 'route_changed';
					
					
					
					select count(*) into n_count from nm_elements where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = n_rt_name and trunc(ne_start_date) <= trunc(d_historic);
						if b_debug = true then
							s_log_base_info := 'select count(*) into n_count from nm_elements where ne_nt_type = s_route_type and ne_type = ''G'' and ne_unique = n_rt_name ';
							s_log_text :='item: '|| n_rt_name  || ' had:  '|| n_count || '';
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
						
					if n_count <> 1 then
						select count(*) into n_count from nm_elements_all where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = n_rt_name and trunc(ne_start_date) <= trunc(d_historic) ;
						if n_count = 0 then
							return 1;
						else
							return 5;
						end if;
					end if;
					
					select ne_id into n_rt_id from nm_elements where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = n_rt_name ;
					
					DBMS_SESSION.set_context('xaa_eff_date_context', 'route_id', n_rt_id);  --Added to speed uo xaa_route_all_recal
					
					select count(*) into n_count from xaa_route where route_id = n_rt_id and n_beg between offset_from  and offset_to  and n_end between offset_from  and offset_to and trunc(effective_date) =trunc(d_historic);
					
						if b_debug = true then
							s_log_base_info := 'select count(*) into n_count from xaa_route where route_id = n_rt_id and n_beg between offset_from  and offset_to  and n_end between offset_from  and offset_to and trunc(effective_date) =trunc(d_historic)';
							s_log_text :='item: '|| n_rt_name  || ' had:  '|| n_count || '';
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
					
					if n_count = 0 then  --mile points not the same as historic dates, or items given on in the continuous area
						--select count(*) into n_count from xaa_route_all where route_id = n_rt_id and  offset_from >=  n_beg    and offset_to < =n_end;
						select count(*) into n_count from xaa_route_all where route_id = n_rt_id and  (n_beg between  offset_from and offset_to ) and (n_end between  offset_from and offset_to );
						if b_debug = true then
							s_log_base_info := 'select count(*) into n_count from xaa_route_all where route_id = n_rt_id and n_beg between offset_from  and offset_to  and n_end between offset_from  and offset_to; ';
							s_log_text :='item: '|| n_rt_name  || ' had:  '|| n_count || ' route_id =  ' || n_rt_id || ', n_beg: ' || n_beg ||  ', n_end: ' || n_end || '';
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
						if n_count = 0 then 
							-- item probably not from a continuous section, but lets check for a recalibrate
							select count(*) into n_count from xaa_route_all_recal where nm_ne_id_in = n_rt_id and slk = n_beg;
							if n_count = 0 then
								return  1;
							else
								select count(*) into n_count from xaa_route_all_recal where nm_ne_id_in = n_rt_id and end_slk = n_end;
								if n_count = 0 then
									return  1;
								else
									return 6;  --probable recalibrate situation
								end if;
							end if;
						else
							-- an item is there, lets figure out if there is a record for the start and end
							select count(*) into n_count from xaa_route_all where route_id = n_rt_id and  offset_from =  n_beg;
							
							if n_count <> 0 then -- return 1 if item is not found, else continue on
								select count(*) into n_count from xaa_route_all where route_id = n_rt_id and   offset_to  =n_end;
								
								if n_count <> 0 then 
									null;   -- continue on
								else  -- We need to check to see if the item was recalibrated
									select count(*) into n_count from xaa_route_all_recal where nm_ne_id_in = n_rt_id and slk = n_beg;
										if n_count = 0 then
											return  1;
										else
											select count(*) into n_count from xaa_route_all_recal where nm_ne_id_in = n_rt_id and end_slk = n_end;
											if n_count = 0 then
												return  1;
											else
												return 6;  --probable recalibrate situation
											end if;
										end if;								
									
								end if;
							else
								--return  1;
								return 3;  --changed to cover cases where item is in the middle of datum
							end if;
							
							-- an item is there, lets figure out if our datums have changed
							select count(*) into n_count from nm_members where nm_ne_id_in = n_rt_id and nm_slk >= n_beg and nm_end_slk <=n_end;
							if n_count= 0 then	--item is not current
								n_return  :=3;
							else
								select max(nm_date_modified) into d_date from nm_members where nm_ne_id_in = n_rt_id and nm_slk >= n_beg and nm_end_slk <=n_end;
								if trunc(d_date) =trunc(d_historic) then
									n_return := 2;
								else
									n_return :=3;
								end if;
							end if;
								
						end if;
					elsif n_count = 1  then --no change
						n_return := 2;
					else  --more than one, unhanded
						n_return := 4;
					end if;
					
					/*  ----OLD
					select ne_id into n_rt_id from nm_elements where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = n_rt_name;
					select count(*) into n_count from xaa_route where route_id = n_rt_id and n_beg between offset_from  and offset_to  and n_end between offset_from  and offset_to;  --using route_id to hit the indexes otherwise it's doing a SLOW FTS
						if n_count = 0 then  -- Need to find out if not exist or end dated
							select count(*) into n_count from xaa_route_all where route_id = n_rt_id  and n_beg between offset_from  and offset_to  and n_end between offset_from  and offset_to;
								if n_count = 0 then 
									n_return := 1;
								else
									n_return := 0;
								end if;
						elsif n_count = 1 then -- only one item most likely no change, change dates to confirm
							select count(*) into n_count from xaa_route where route_id = n_rt_id and offset_from = n_beg and offset_to = n_end;
							if n_count= 1 then
								select * into r_route from xaa_route where route_id = n_rt_id and offset_from = n_beg and offset_to = n_end;
								
								if trunc(r_route.effective_date) = trunc(d_historic) then  -- no change
									n_return := 2;
								else
									n_return := 3;
								end if;
							else  -- Many segments returned
									n_return := 4;
							end if;
							
						else -- count greater than 1, high chance that item was spilt
							null;
						end if;
						
						*/ 
					return n_return;
			end route_changed;
			
			function get_datum_slk(d_historic date, s_route_name varchar2, n_offset number) return typ_start_end_datum is
				n_count number;
				n_rt_id number;
				r_return typ_start_end_datum;
				begin
					select count(*) into n_count from nm_elements_all where ne_nt_type = s_route_type and ne_type = 'G' 
						and ne_unique = s_route_name 
						and trunc(ne_start_date) <= trunc(d_historic)
						AND NVL (ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_historic);
					
					if n_count= 1 then
						select ne_id into n_rt_id from nm_elements_all where ne_nt_type = s_route_type and ne_type = 'G' 
							and ne_unique = s_route_name 
							and trunc(ne_start_date) <= trunc(d_historic)
							AND NVL (ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_historic);
							
						
						select count(*) into n_count 	 from nm_members_all a,nm_elements_all b 
							where 1=1
							and a.nm_ne_id_of = b.ne_id
							and b.ne_type <> 'D'
							and nm_type = 'G'  
							and nm_obj_type in (s_route_type)
							and nm_ne_id_in = n_rt_id
							and n_offset between nm_slk and nm_end_slk					
							and (nm_start_date <= trunc(d_historic) AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_historic));
							
							
						
						if n_count = 1 then
							--lets fill in the values
							select  
									nm_ne_id_of
									, null new_ne_id_of
									, n_offset given_slk
									, nm_slk
									,nm_end_slk
								into 
									r_return.old_ne_id_of 
									,r_return.new_ne_id_of 
									,r_return.given_slk 
									,r_return.datum_start_slk 
									,r_return.datum_end_slk 
								from nm_members_all a,nm_elements_all b 
								where 1=1
								and a.nm_ne_id_of = b.ne_id
								and b.ne_type <> 'D'
								and nm_type = 'G'  
								and nm_obj_type in (s_route_type)
								and nm_ne_id_in = n_rt_id
								and n_offset between nm_slk and nm_end_slk					
								and (nm_start_date <= trunc(d_historic) AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(d_historic));
						else -- either it is on a node or something is wrong, either way nothing to do here
								select 
									 -1 id_of
									, null new_ne_id_of
									, n_offset given_slk
									, n_offset nm_slk
									, n_offset nm_end_slk
								into 
									r_return.old_ne_id_of 
									,r_return.new_ne_id_of 
									,r_return.given_slk 
									,r_return.datum_start_slk 
									,r_return.datum_end_slk 
								from dual;
						-- let the next stage catch it, if it is more than 1 the offset probably is on the end of a datum
						end if;
					else	-- let the next stage catch it, if it is more than 1 the offset probably is on the end of a datum
								select 
									 -2 id_of
									, null new_ne_id_of
									, n_offset given_slk
									, n_offset nm_slk
									, n_offset nm_end_slk
								into 
									r_return.old_ne_id_of 
									,r_return.new_ne_id_of 
									,r_return.given_slk 
									,r_return.datum_start_slk 
									,r_return.datum_end_slk 
								from dual;
					end if;
					
					return r_return;
				
			end get_datum_slk;
			
			
			-- This function is changing to only have the current data in it.
			/*
			function get_old_loc_list(n_old_ne_id number ) return typ_neh_table is
				a_neh_table typ_neh_table := typ_neh_table();
				spilt_neh_table typ_neh_table := typ_neh_table();
				process_spilt_neh_table typ_neh_table := typ_neh_table();
				n_temp number;
				n_count number := -1;
				n_count_MP_chk number := 0;
				n_ne_id number := n_old_ne_id;
				b_has_spilt boolean := false;
				--coded added to get the new last and the new start that goes directly to global variables.
				
				begin
					select count(*) into n_count from nm_element_history where neh_ne_id_old = n_ne_id;
					
					while n_count <> 0 
					loop
						for r_row in (select * from nm_element_history where neh_ne_id_old = n_ne_id order by neh_id) loop
							a_neh_table.extend(1);
							a_neh_table(a_neh_table.count) := r_row;
						end loop;
						
						if a_neh_table(a_neh_table.count).neh_ne_id_new = a_neh_table(a_neh_table.count).neh_ne_id_old OR a_neh_table(a_neh_table.count).neh_operation = 'S' then
							n_ne_id := -1;
						else
							n_ne_id := a_neh_table(a_neh_table.count).neh_ne_id_new;
						end if;
						select count(*) into n_count from nm_element_history where neh_ne_id_old = n_ne_id;
						
						if b_debug = true then
							s_log_base_info := 'get_old_loc_list(n_old_ne_id number )';							
							s_log_text :='item ne_id_old: '|| n_ne_id || ' had:  '|| n_count ||  '';
							
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
						
					end loop;
					
					--OK let get the history on any splits
					
					if b_debug = true then
							s_log_base_info := 'a_neh_table count b/f spilt ops';							
							s_log_text :='a_neh_table: '|| n_ne_id || ' had:  '|| a_neh_table.count ||  '';
							
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					end if;
					
					if a_neh_table.count <> 0 then 
						for xx in a_neh_table.first..a_neh_table.last loop
							if a_neh_table(xx).neh_operation = 'S' then
								b_has_spilt := true;
								spilt_neh_table.extend(1);
								spilt_neh_table(spilt_neh_table.count) := a_neh_table(xx);
							end if;
						end loop;
						
						if spilt_neh_table.count <> 0 then 
							for yy in spilt_neh_table.first..spilt_neh_table.last loop
								process_spilt_neh_table.delete;
								process_spilt_neh_table := get_old_loc_list(spilt_neh_table(yy).neh_ne_id_new);
								if process_spilt_neh_table.count <> 0 then 
									for zz in process_spilt_neh_table.first .. process_spilt_neh_table.last loop
										a_neh_table.extend(1);
										a_neh_table(a_neh_table.count) := process_spilt_neh_table(zz);
										
										
										
										if n_old_ne_id = r_start_datum.old_ne_id_of and yy = 1 then
											
											/*--need to see if the start MP is still in this datum
											select count(*) into n_count_MP_chk from nm_members_all 
															where nm_type = 'G' and nm_obj_type = s_route_type 	
																and  nm_ne_id_of = a_neh_table(a_neh_table.count).neh_ne_id_new and (end_slk - slk) >= (r_start_datum.given_slk - r_start_datum.datum_start_slk);
											*-/
												r_start_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
												if b_debug = true then
													s_log_base_info := 'DATUM SPILT:';							
													s_log_text :='First From: '|| r_start_datum.old_ne_id_of || ' to:  '|| a_neh_table(a_neh_table.count).neh_ne_id_new ||  '';
													
													x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
												end if;
											
										end if;
										
										
										if n_old_ne_id = r_end_datum.old_ne_id_of  then n_old_end_id := r_end_datum.old_ne_id_of; end if;
										
										if n_old_ne_id in (r_end_datum.old_ne_id_of,n_old_end_id) and yy = spilt_neh_table.count then
											r_end_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
											n_old_end_id := r_end_datum.new_ne_id_of;
											if b_debug = true then
												s_log_base_info := 'DATUM SPILT:';							
												s_log_text :='Last From: '|| r_end_datum.old_ne_id_of  || ' currently  ' || n_old_end_id || ' to:  '|| a_neh_table(a_neh_table.count).neh_ne_id_new ||  '';
												
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
											end if;
											
										end if;	
										
									end loop;
								end if;
							end loop;
						end if;
					end if;  
					*/
					
			function get_old_loc_list(n_old_ne_id number ) return typ_neh_table is
				a_neh_table typ_neh_table := typ_neh_table();
				spilt_neh_table typ_neh_table := typ_neh_table();
				final_datum  typ_neh_table:= typ_neh_table();
				process_spilt_neh_table typ_neh_table := typ_neh_table();
				n_temp number;
				n_count number := -1;
				n_count_MP_chk number := 0;
				n_ne_id number := n_old_ne_id;
				b_has_spilt boolean := false;
				--coded added to get the new last and the new start that goes directly to global variables.
				
				begin
					select count(*) into n_count from nm_element_history where neh_ne_id_old = n_ne_id;
					
					while n_count <> 0 
					loop
						for r_row in (select * from nm_element_history where neh_ne_id_old = n_ne_id order by neh_id) loop
							a_neh_table.extend(1);
							a_neh_table(a_neh_table.count) := r_row;
						end loop;
						
						if a_neh_table(a_neh_table.count).neh_ne_id_new = a_neh_table(a_neh_table.count).neh_ne_id_old OR a_neh_table(a_neh_table.count).neh_operation = 'S' then
							n_ne_id := -1;
						else
							n_ne_id := a_neh_table(a_neh_table.count).neh_ne_id_new;
						end if;
						select count(*) into n_count from nm_element_history where neh_ne_id_old = n_ne_id;
						
						if b_debug = true then
							s_log_base_info := 'get_old_loc_list(n_old_ne_id number )';							
							s_log_text :='item ne_id_old: '|| n_ne_id || ' had:  '|| n_count ||  '';
							
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
						
					end loop;
					
					--OK let get the history on any splits
					
					if b_debug = true then
							s_log_base_info := 'a_neh_table count b/f spilt ops';							
							s_log_text :='a_neh_table: '|| n_ne_id || ' had:  '|| a_neh_table.count ||  '';
							
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					end if;
					
					if a_neh_table.count <> 0 then 
						for xx in a_neh_table.first..a_neh_table.last loop
							if a_neh_table(xx).neh_operation = 'S' then
								b_has_spilt := true;
								spilt_neh_table.extend(1);
								spilt_neh_table(spilt_neh_table.count) := a_neh_table(xx);
							end if;
						end loop;
						
						--take the last datum here before processing the spilt
							final_datum.extend(1);
							final_datum(final_datum.count) := a_neh_table(a_neh_table.last);
						
						if spilt_neh_table.count <> 0 then 
							for yy in spilt_neh_table.first..spilt_neh_table.last loop
								process_spilt_neh_table.delete;
								process_spilt_neh_table := get_old_loc_list(spilt_neh_table(yy).neh_ne_id_new);
								if process_spilt_neh_table.count <> 0 then 
									for zz in process_spilt_neh_table.first .. process_spilt_neh_table.last loop
										a_neh_table.extend(1);
										a_neh_table(a_neh_table.count) := process_spilt_neh_table(zz);
										
										
										
										if n_old_ne_id = r_start_datum.old_ne_id_of and yy = 1 then
											
												r_start_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
												if b_debug = true then
													s_log_base_info := 'DATUM SPILT:';							
													s_log_text :='First From: '|| r_start_datum.old_ne_id_of || ' to:  '|| a_neh_table(a_neh_table.count).neh_ne_id_new ||  '';
													
													x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
												end if;
											
										end if;
										
										--add the last spilt
										final_datum.extend(1);
										final_datum(final_datum.count) := a_neh_table(a_neh_table.last);
										
										if n_old_ne_id = r_end_datum.old_ne_id_of  then n_old_end_id := r_end_datum.old_ne_id_of; end if;
										
										if n_old_ne_id in (r_end_datum.old_ne_id_of,n_old_end_id) and yy = spilt_neh_table.count then
											r_end_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
											n_old_end_id := r_end_datum.new_ne_id_of;
											if b_debug = true then
												s_log_base_info := 'DATUM SPILT:';							
												s_log_text :='Last From: '|| r_end_datum.old_ne_id_of  || ' currently  ' || n_old_end_id || ' to:  '|| a_neh_table(a_neh_table.count).neh_ne_id_new ||  '';
												
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
											end if;
											
										end if;	
										
									end loop;
								end if;
							end loop;
						end if;
					end if;  
					
					--Lets find out what happened to the first and last datum if no spilt
					if b_has_spilt = false then
						if n_old_ne_id = r_start_datum.old_ne_id_of then
							if a_neh_table.count <> 0 then 
								r_start_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
							else 
								r_start_datum.new_ne_id_of := r_start_datum.old_ne_id_of;
							end if;
						end if;
						
						if n_old_ne_id = r_end_datum.old_ne_id_of then
							if a_neh_table.count <> 0 then 
								r_end_datum.new_ne_id_of := a_neh_table(a_neh_table.count).neh_ne_id_new;
							else 
								r_end_datum.new_ne_id_of := r_end_datum.old_ne_id_of;
							end if;
						end if;
					end if;				
									
				-- Testing
				
				forall xx in final_datum.first .. final_datum.last
					insert into z_nm_element_history values final_datum(xx);
				--test
				
				return final_datum;
				
			end get_old_loc_list;
		
			function get_mod_date(s_route_desc varchar2, n_slk number, n_end_slk number ) return date is
				n_date  date;
				begin				
					select max(nm_date_MODIFIED) into n_date from nm_members 
					where 1=1
					and nm_ne_id_in = (select max(ne_id) from nm_elements where ne_unique = s_route_desc )
					and nm_slk >= n_slk
					and nm_end_slk <= n_end_slk
					;
					return n_date;
			end get_mod_date;
			
			function get_end_date(s_route_desc varchar2, n_slk number, n_end_slk number ) return date is
				n_date  date;
				begin				
					select max(nm_end_date) into n_date from nm_members_all 
					where 1=1
					and nm_ne_id_in = (select max(ne_id) from nm_elements_all where ne_unique = s_route_desc)
					and nm_slk >= n_slk
					and nm_end_slk <= n_end_slk
					;
					return n_date;
			
			end get_end_date;
			
			procedure fill_xaa_route_temp_gaps  is
				-- This function attempts to fill mileage gaps in the history when the history chain is lost. IT writes directly to the current xaa_route_temp_sql				
				n_count number;
				
				cursor c_get_seg(n_id_in  number, n_slk number, n_end_slk number) is
					select * from nm_members 
					where 1=1
					and nm_ne_id_in = n_id_in 
					and nm_slk >= n_slk 
					and nm_end_slk <= n_end_slk 
					order by nm_seq_no;
					
				begin  
				--c_post_history_active_route (s_opt_sn varchar2 default '%') 
				
				if b_debug = true then
						s_log_base_info := 'Filling Gaps in  xaa_route_temp_sql'	;									
						s_log_text := 'Start';
						
						x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
				end if;
				
				for r_row in c_post_history_active_route loop
					 --if en <> next sn then, check if next sn in list incase its in a different group, 
					 --then loop through nodes in the current group, if deadend see if in end group, otherwise walk through all choices.
					 -- Then enter into xaa_route_temp_sql
					if b_debug = true then
							s_log_base_info := 'Filling Gaps in  xaa_route_temp_sql'	;									
							s_log_text := r_row.ne_id_in;
							
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					end if;
					 
					if r_row.ne_no_end <> nvl(r_row.next_start_no,r_row.ne_no_end) then  -- the nvl removes the null at the end of the list
						select count(*) into n_count from (select distinct * from xaa_route_temp_sql) a ,nm_elements b   where a.ne_id_of = b.ne_id and ne_no_start = r_row.ne_no_end;
						if n_count = 0 and r_row.ne_id_in = r_row.next_ne_id_in then  -- We need to add some Items
							r_new_id_list_gaps  := typ_new_ne_id_list();
							for y_row in c_get_seg(r_row.ne_id_in, r_row.end_slk, r_row.next_slk) loop
								r_new_id_list_gaps.extend(1);
								r_new_id_list_gaps(r_new_id_list_gaps.count).ne_id_of	 := y_row.nm_ne_id_of;
								r_new_id_list_gaps(r_new_id_list_gaps.count).ne_id_in 	 := y_row.nm_ne_id_in;
								r_new_id_list_gaps(r_new_id_list_gaps.count).slk		 := y_row.nm_slk;
								r_new_id_list_gaps(r_new_id_list_gaps.count).end_slk	 := y_row.nm_end_slk;
								r_new_id_list_gaps(r_new_id_list_gaps.count).op 		 := null;
							end loop;
							
							forall xx in r_new_id_list_gaps.first..r_new_id_list_gaps.last 
								insert into xaa_route_temp_sql 
											(
											cur_user ,
											cur_proc ,
											ne_id_of ,
											ne_id_in , 
											slk , 
											end_slk, 
											op 
											) 
											Values 
											(
											user,
											s_module || '-GapFill',
											r_new_id_list_gaps(xx).ne_id_of,
											r_new_id_list_gaps(xx).ne_id_in,
											r_new_id_list_gaps(xx).slk,
											r_new_id_list_gaps(xx).end_slk,
											r_new_id_list_gaps(xx).op
											);
							
						end if;
					end if;
					
				end loop;
					
				--return true;
			end fill_xaa_route_temp_gaps;
			
			procedure update_xaa_route_temp is
			
				
				n_offset_len number := 0;
				n_count number := 0;
				n_rt number;
				b_spilt_datum_reached boolean := false;
				n_spilt_slk number;
				
				begin
					if b_debug = true then
						s_log_base_info := 'UPDATE_XAA_ROUTE_TEMP';
						s_log_text := 'Updating ' || r_start_datum.new_ne_id_of || ', ' || r_end_datum.new_ne_id_of;
						x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					end if;
				--lets do the start first
				
				n_offset_len := r_start_datum.given_slk - r_start_datum.datum_start_slk;  --initial offset
				
				select ne_id_in into n_rt from xaa_route_temp_sql where ne_id_of = r_start_datum.new_ne_id_of and rownum <2;
				
				
				
				select count(*) into n_count from (select distinct a.ne_id_of, a.slk, a.end_slk  from xaa_route_temp_sql a, nm_elements , (select min(slk) min_slk from xaa_route_temp_sql where ne_id_in = n_rt) b
									where ne_id_of = ne_id 
									AND A.ne_id_in = n_rt
									and slk <= min_slk + n_offset_len						
									order by slk);
				
				if n_count = 1 then
					null;  -- do nothing the offset will fit from the datum start MP
				else	--we need to find the new datum to offset from and delete the others
					select slk into n_spilt_slk from xaa_route_temp_sql where ne_id_of = r_start_datum.new_ne_id_of and rownum <2;
					for r_row in (select distinct a.ne_id_of, a.slk, a.end_slk  from xaa_route_temp_sql a, nm_elements , (select min(slk) min_slk from xaa_route_temp_sql where ne_id_in = n_rt) b
									where ne_id_of = ne_id 
									AND A.ne_id_in = n_rt
									and slk <= min_slk + n_offset_len						
									order by slk ) loop
						
						if b_debug = true then
							s_log_base_info := 'UPDATE_XAA_ROUTE_TEMP';
							s_log_text := 'start datum ' || r_start_datum.new_ne_id_of || ' to ' || r_row.ne_id_of;
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
				--lets do the st
						
						r_start_datum.new_ne_id_of := r_row.ne_id_of;
						
						
						
						if (r_row.end_slk - r_row.slk) <= n_offset_len then
							-- we need to delete this one and move on to the next							

							
							if b_debug = true then
								s_log_base_info := 'UPDATE_XAA_ROUTE_TEMP';
								s_log_text := 'Length Change  ' || to_char(n_offset_len) || ' to ' || to_char(n_offset_len - (r_row.end_slk - r_row.slk));
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
							end if;
							
							if r_row.slk >= n_spilt_slk then --See if were are starting form the right place wiht al the spilts that occured
								n_offset_len := n_offset_len - (r_row.end_slk - r_row.slk);
							end if;
							delete from xaa_route_temp_sql where ne_id_of = r_row.ne_id_of;
							
						end if;
					end loop;
			
				end if;
				
				-------------
				update xaa_route_temp_sql 
					set slk = slk + n_offset_len
					where ne_id_of = r_start_datum.new_ne_id_of;

							--lets do the end
				
				n_offset_len :=  r_end_datum.datum_end_slk  - r_end_datum.given_slk;  --initial offset
				
				select ne_id_in into n_rt from xaa_route_temp_sql where ne_id_of = r_end_datum.new_ne_id_of and rownum <2;
				
				select count(*) into n_count from (select distinct a.ne_id_of, a.slk, a.end_slk  from xaa_route_temp_sql a, nm_elements , (select max(end_slk) max_end_slk from xaa_route_temp_sql where ne_id_in = n_rt) b
							where ne_id_of = ne_id 
							AND A.ne_id_in = n_rt
							and end_slk >= max_end_slk - n_offset_len						
							order by slk);
				
				if n_count = 1 then
					null;  -- do nothing the offset will fit from the datum start MP
				else	--we need to find the new datum to offset from and delete the others
					for r_row in (select distinct a.ne_id_of, a.slk, a.end_slk  from xaa_route_temp_sql a, nm_elements , (select max(end_slk) max_end_slk from xaa_route_temp_sql where ne_id_in = n_rt) b
							where ne_id_of = ne_id 
							AND A.ne_id_in = n_rt
							and end_slk >= max_end_slk - n_offset_len						
							order by end_slk desc)
						loop
						
							if b_debug = true then
								s_log_base_info := 'UPDATE_XAA_ROUTE_TEMP';
								s_log_text := 'end datum ' || r_end_datum.new_ne_id_of || ' to ' || r_row.ne_id_of;
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
							end if;
					
							
							r_end_datum.new_ne_id_of := r_row.ne_id_of;
							
							if (r_row.end_slk - r_row.slk) <= n_offset_len then
								-- we need to delete this one and move on to the next							

								
								if b_debug = true then
									s_log_base_info := 'UPDATE_XAA_ROUTE_TEMP';
									s_log_text := 'Length Change  ' || to_char(n_offset_len) || ' to ' || to_char(n_offset_len - (r_row.end_slk - r_row.slk));
									x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
								end if;
								
								n_offset_len := n_offset_len - (r_row.end_slk - r_row.slk);
								delete from xaa_route_temp_sql where ne_id_of = r_row.ne_id_of;
								
							end if;
						end loop;
				end if;
						
						
					update xaa_route_temp_sql 
						set end_slk = end_slk - n_offset_len
						where ne_id_of = r_end_datum.new_ne_id_of;

				EXCEPTION
				WHEN NO_DATA_FOUND
				THEN
					null;
			end update_xaa_route_temp;
			
				-------------------------------------------------------BEGIN----------------------------------------------------------
		begin 	-------------------------------------------------------BEGIN----------------------------------------------------------
				-------------------------------------------------------BEGIN----------------------------------------------------------
			s_module := upper('process_route_events');
			
			x_log_table.clean(s_module);  -- remove existing log file entries
			
			b_debug := b_debug_in;
			
			execute immediate 'truncate table xaa_net_ref';
			--delete from xaa_net_ref;  --clean xaa_net_ref so only entries from naa_loc_ident are listed
			
			for r_input in c_route_list loop
				begin
					DBMS_SESSION.set_context('xaa_eff_date_context', 'date', r_input.historic_date);
					
					s_log_area := 'R_Input_Loop';  -- log area
					
					--- Added so we can find the segment if the begin or end points start in the middle of a datum.
					
					/* 	
									r_start_datum.old_ne_id_of 
									,r_start_datum.new_ne_id_of 
									,r_start_datum.given_slk 
									,r_start_datum.datum_start_slk 
									,r_start_datum.datum_end_slk 
					*/
					r_start_datum := get_datum_slk(r_input.historic_date, r_input.route_name, r_input.offset_from);
					
					r_end_datum := get_datum_slk(r_input.historic_date, r_input.route_name, r_input.offset_to);
					
					s_log_base_info := 'start datum offset/end datum offset';
					s_log_text := r_start_datum.datum_start_slk || ', ' ||  r_end_datum.datum_end_slk;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					
					-----
					--n_code := route_changed(r_input.historic_date, r_input.route_name, r_input.offset_from, r_input.offset_to);
					n_code := route_changed(r_input.historic_date, r_input.route_name, r_start_datum.datum_start_slk, r_end_datum.datum_end_slk);
					
					s_log_base_info := 'Informational';
					s_log_text :='route_changed returned ' || n_code || ' for: '  || r_input.historic_date || ', '|| r_input.loc_ident || ', '||r_input.route_name || ', '|| r_input.offset_from || ', '|| r_input.offset_to;
					x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					
										
					case 
						/*when 0 then  -- Item was end dated / route location closed
							r_output.EXTEND(1);
							n_idx := r_output.count();
							
														r_output(n_idx).historic_date 		:= r_input.historic_date;
							r_output(n_idx).loc_ident 			:= r_input.loc_ident;
							r_output(n_idx).route_name			:= r_input.route_name;
							r_output(n_idx).offset_from		:= r_input.offset_from;
							r_output(n_idx).offset_to			:= r_input.offset_to;
							r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_route'); --r_input.source_table;
							r_output(n_idx).new_route_name		:= null; --r_input.new_route_name;
							r_output(n_idx).new_offset_from	:= null; --r_input.new_offset_from;
							r_output(n_idx).new_offset_to		:= null; --r_input.new_offset_to;
							r_output(n_idx).process_msg		:= 'Route Location Closed'; --r_input.process_msg; */
														
						when n_code =  1 then -- Item not found
							r_output.EXTEND(1);
							n_idx := r_output.count();
							
							r_output(n_idx).historic_date 		:= r_input.historic_date;
							r_output(n_idx).loc_ident 			:= r_input.loc_ident;
							r_output(n_idx).route_name			:= r_input.route_name;
							r_output(n_idx).offset_from			:= r_input.offset_from;
							r_output(n_idx).offset_to			:= r_input.offset_to;
							r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_route'); --r_input.source_table;
							r_output(n_idx).new_date 			:= null;
							r_output(n_idx).new_route_name		:= null; --r_input.new_route_name;
							r_output(n_idx).new_offset_from		:= null; --r_input.new_offset_from;
							r_output(n_idx).new_offset_to		:= null; --r_input.new_offset_to;
							r_output(n_idx).process_msg			:= 'Old Route Location Not Found'; --r_input.process_msg;
						when n_code = 2 then  -- No change
							r_output.EXTEND(1);
							n_idx := r_output.count();
							
							r_output(n_idx).historic_date 		:= r_input.historic_date;
							r_output(n_idx).loc_ident 			:= r_input.loc_ident;
							r_output(n_idx).route_name			:= r_input.route_name;
							r_output(n_idx).offset_from			:= r_input.offset_from;
							r_output(n_idx).offset_to			:= r_input.offset_to;
							r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_route'); --r_input.source_table;
							r_output(n_idx).new_date 			:= get_mod_date(r_input.route_name, r_input.offset_from, r_input.offset_to );
							r_output(n_idx).new_route_name		:= r_input.route_name;
							r_output(n_idx).new_offset_from		:= r_input.offset_from;
							r_output(n_idx).new_offset_to		:= r_input.offset_to;
							r_output(n_idx).process_msg			:= 'Route Location Not Changed'; --r_input.process_msg;
							r_output(n_idx).new_date 			:= get_end_date(r_input.route_name, r_input.offset_from, r_input.offset_to );
						when n_code = 3 or n_code = 6 then  --Date changed but item is still there
							--  This section needs to change--------
							-- Okay, the route name is the same, the date changed so what happened
							
							--get effective member list
							s_log_area := 'R_Input_Loop-3'; 
							r_nm_members_all.delete;
							r_nm_members_all := typ_nm_members_all();
							
							select ne_id into n_old_rt_id from nm_elements_all where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = r_input.route_name and (ne_start_date <= trunc(r_input.historic_date) AND NVL (ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(r_input.historic_date))	;
							
							if n_code = 3 then
								--open c_nm_mem_effective_rt(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date );
								open c_nm_mem_effective_rt(n_old_rt_id,r_start_datum.datum_start_slk, r_end_datum.datum_end_slk, r_input.historic_date );
									fetch c_nm_mem_effective_rt bulk collect into r_nm_members_all;
								close c_nm_mem_effective_rt;
							elsif n_code = 6 then
								--open c_nm_mem_effective_rt_b(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date);
								open c_nm_mem_effective_rt_b(n_old_rt_id,r_start_datum.datum_start_slk, r_end_datum.datum_end_slk, r_input.historic_date);
									fetch c_nm_mem_effective_rt_b bulk collect into r_nm_members_all;
								close c_nm_mem_effective_rt_b;
							end if;
							
							if b_debug = true then
								s_log_base_info := 'Informational';
								s_log_text :='n_code =' || n_code;
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
							end if;

							--get what happened to each member
							
							if r_nm_members_all.count = 0 then
								s_log_base_info := 'Informational';
								s_log_text :='Unexpected 0 record count for CASE  (' || n_code ||')  for: ' || r_input.historic_date ||', ' || n_old_rt_id || ', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
								
								
								if b_debug = true then
									n_temp :=0;
									s_log_base_info := 'c_nm_mem_effective_rt(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date ) ';
									s_log_text :='row: '||n_temp;
									x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									--for r_row in c_nm_mem_effective_rt(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date ) loop
									for r_row in c_nm_mem_effective_rt(n_old_rt_id,r_start_datum.datum_start_slk, r_end_datum.datum_end_slk, r_input.historic_date ) loop
										n_temp :=n_temp +1;
										s_log_base_info := 'c_nm_mem_effective_rt(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date ) ';
										s_log_text :='row: '||n_temp;
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									end loop;
								end if;	
								
								r_output.EXTEND(1);
								n_idx := r_output.count();
								r_output(n_idx).historic_date 		:= r_input.historic_date;
								r_output(n_idx).loc_ident 			:= r_input.loc_ident;
								r_output(n_idx).route_name			:= r_input.route_name;
								r_output(n_idx).offset_from			:= r_input.offset_from;
								r_output(n_idx).offset_to			:= r_input.offset_to;
								r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
								r_output(n_idx).new_route_name 		:= null;
								r_output(n_idx).new_offset_from		:= null;
								r_output(n_idx).new_offset_to		:= null;
								r_output(n_idx).process_msg			:= 'Error Retrieving Effective Route, Perhaps The Offsets Are The Same.'; --r_input.process_msg;


								
							else
								
								r_n_spilt.delete;
								r_n_spilt := typ_numbers();
								r_new_id_list := typ_new_ne_id_list();
								
								if b_debug = true then
									s_log_base_info := 'r_nm_members_all.count ';
									s_log_text :='item: '|| r_input.route_name  || ' had:  '|| r_nm_members_all.count ||  '';
									x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
								end if;
								
								
								for xx in r_nm_members_all.first..r_nm_members_all.last loop
									--split clear added b/c it was double processing them
									r_n_spilt.delete;
									r_n_spilt := typ_numbers();
									r_old_loc := get_old_loc_list(r_nm_members_all(xx).nm_ne_id_of );  --test
									
									if b_debug = true then
										s_log_base_info := 'Informational';
										s_log_text :='r_old_loc count(' || r_old_loc.count ||')  for: ' || r_nm_members_all(xx).nm_ne_id_of ||', ' ||r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									end if;
									

									
									if r_old_loc.count <> 0 then 
										for yy in r_old_loc.first .. r_old_loc.last loop
											if b_debug = true then
												s_log_base_info := 'r_old_loc.old and .op';
												s_log_text :='item: '|| r_old_loc(yy).neh_ne_id_old || ' is:  '|| r_old_loc(yy).NEH_operation ||  '';
												
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
											end if;
											

											
											--if r_old_loc(yy).NEH_operation = 'S' then
											if r_old_loc(yy).NEH_operation <> '28' then  -- dumb operation taking everything now since splits resolved in get old loc
												r_n_spilt.extend(1);
												r_n_spilt(r_n_spilt.count) := r_old_loc(yy).neh_ne_id_new;
											else
												NULL;
											end if;
										end loop;
									end if;
									if r_n_spilt.count <> 0 then 
										for zz in r_n_spilt.first..r_n_spilt.last loop
											if b_debug = true then
												s_log_base_info := 'SPLIT select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk, ''S'' into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk, r_new_id_list(r_new_id_list.count).op from nm_members_all where nm_ne_id_of = r_n_spilt(zz);';
												select count(*) into n_count from nm_members_all where nm_ne_id_of = r_n_spilt(zz)  and nm_obj_type in (s_route_type);
												s_log_text :='item: '|| r_n_spilt(zz) || ' had:  '|| n_count ||  '';
												
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
											end if;
											-- Need to trace the spilt segments
											
											r_new_id_list.extend(1);
											select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk, null into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk, r_new_id_list(r_new_id_list.count).op from nm_members_all where nm_ne_id_of = r_n_spilt(zz) and nm_obj_type in (s_route_type) and nm_start_date = (select max(nm_start_date) from  nm_members_all where nm_ne_id_of =r_n_spilt(zz) and nm_obj_type = s_route_type);
										end loop;
									end if;	
									r_new_id_list.extend(1);
									if r_old_loc.count <> 0 then 
										n_temp := r_old_loc(r_old_loc.last).neh_ne_id_new;
									else 
										-- no history for that segment;
										n_temp := r_nm_members_all(xx).nm_ne_id_of;
									end if;
									
									if b_debug = true then
										s_log_base_info := 'last change: select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk from nm_members_all where nm_ne_id_of = n_temp and nm_obj_type in (s_route_type);';
										select count(*) into n_count from nm_members where nm_date_created = (select max(nm_date_created) from nm_members_all where nm_ne_id_of = n_temp and nm_obj_type in (s_route_type)) and nm_ne_id_of = n_temp and nm_obj_type in (s_route_type);
										s_log_text :='item: '|| n_temp  || ' had:  '|| n_count ||  '';
										
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									end if;
									
									
									
									
									select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk from nm_members_all where nm_date_created = (select max(nm_date_created) from nm_members_all where nm_ne_id_of = n_temp and nm_obj_type in (s_route_type)) and nm_ne_id_of = n_temp and nm_obj_type in (s_route_type) ; --and (nm_start_date <= trunc(r_input.historic_date) AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(r_input.historic_date))	;
									
									if r_old_loc.count <> 0 then 
										r_new_id_list(r_new_id_list.count).op := r_old_loc(r_old_loc.last).neh_operation;
									else
										r_new_id_list(r_new_id_list.count).op := null;
									end if;
									
								end loop;
								
								if b_debug = true then
										s_log_base_info := 'Checking Continuity for'	;									
										s_log_text := 'item: '|| r_new_id_list(r_new_id_list.count).ne_id_in  ;
										
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
								end if;
								
								
								-- see if the results are continuous,  going to use a oracle table to check this
									delete from xaa_route_temp_sql where cur_user = user and cur_proc like s_module || '%';
									forall xx in r_new_id_list.first..r_new_id_list.last 
										insert into xaa_route_temp_sql 
													(
													cur_user ,
													cur_proc ,
													ne_id_of ,
													ne_id_in , 
													slk , 
													end_slk, 
													op 
													) 
													Values 
													(
													user,
													s_module,
													r_new_id_list(xx).ne_id_of,
													r_new_id_list(xx).ne_id_in,
													r_new_id_list(xx).slk,
													r_new_id_list(xx).end_slk,
													r_new_id_list(xx).op
													);
									
									--Subtract SLK from first and last
									
									
									
									/*
										update xaa_route_temp_sql 
											set slk = slk + (r_start_datum.given_slk - r_start_datum.datum_start_slk)
											where ne_id_of = r_start_datum.new_ne_id_of;
										
										update xaa_route_temp_sql 
											set end_slk = end_slk - (r_end_datum.datum_end_slk - r_end_datum.given_slk)
											where ne_id_of = r_end_datum.new_ne_id_of;
									*/
									
									---------------------
									
									fill_xaa_route_temp_gaps;  -- checking for continuity gaps
									update_xaa_route_temp;
									
									n_row_count := 0;
									
									for x_row in c_chk_cont loop										
										
										if x_row.op = 'C' then
										-- section is closed
												r_output.EXTEND(1);
												n_idx := r_output.count();
												r_output(n_idx).historic_date 		:= r_input.historic_date;
												r_output(n_idx).loc_ident 			:= r_input.loc_ident;
												r_output(n_idx).route_name			:= r_input.route_name;
												r_output(n_idx).offset_from			:= r_input.offset_from;
												r_output(n_idx).offset_to			:= r_input.offset_to;
												r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
												r_output(n_idx).new_date 			:= get_end_date(r_input.route_name, r_input.offset_from, r_input.offset_to );
												r_output(n_idx).new_route_name 		:= null; --r_input.new_route_name;
												if x_row.cnt = 1 then
													r_output(n_idx).new_offset_from		:= null; --r_input.new_offset_from;
													r_output(n_idx).new_offset_to		:= null; --r_input.new_offset_to;
												else
													r_output(n_idx).new_offset_from		:= x_row.start_slk; -- - (r_start_datum.datum_start_slk -r_start_datum.given_slk); --r_input.new_offset_from;
													r_output(n_idx).new_offset_to		:= x_row.end_slk; --  - (r_end_datum.datum_end_slk -r_end_datum.given_slk); --r_input.new_offset_to;
												end if;
												r_output(n_idx).process_msg		:= 'Route Location Closed'; --r_input.process_msg;
												
										end if;
										
										if n_idx >= 45 then  -- see if the array is getting too big				
											flush_array;				
										end if;	
										
									end loop;
									
									for x_row in c_chk_cont_current loop
										
										if b_debug = true then
											s_log_base_info := 'Getting Item Count before output'	;									
											s_log_text := 'select count(*)  from xaa_route where  route_id = ' || x_row.ne_id_in || ' and offset_from >= '|| x_row.start_slk || ' and offset_to <= ' ||x_row.end_slk || ' order by offset_from';
											
											x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
										end if;
										select count(*) into n_count from xaa_route where  route_id = 	x_row.ne_id_in and offset_from >= x_row.start_slk and offset_to <= x_row.end_slk order by offset_from;
										
										------------------------------------------
										n_count := 0; -- test by passing  xaaa_route
										-------------------------------------
										if n_count = 0 then
											if b_debug = true then
												s_log_base_info := 'n_count = 0, r_output count before Extend'	;									
												s_log_text := r_output.count();
												
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
											end if;
											r_output.EXTEND(1);
											n_idx := r_output.count();
											r_output(n_idx).historic_date 		:= r_input.historic_date;
											r_output(n_idx).loc_ident 			:= r_input.loc_ident;
											r_output(n_idx).route_name			:= r_input.route_name;
											r_output(n_idx).offset_from			:= r_input.offset_from;
											r_output(n_idx).offset_to			:= r_input.offset_to;
											r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
											select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
											r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, x_row.start_slk, x_row.end_slk );
											r_output(n_idx).new_offset_from		:= x_row.start_slk; -- - (r_start_datum.datum_start_slk -r_start_datum.given_slk); --r_input.new_offset_from;
											r_output(n_idx).new_offset_to		:= x_row.end_slk; --  - (r_end_datum.datum_end_slk -r_end_datum.given_slk); --r_input.new_offset_to;
											r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
										else
											null;
											/*
											n_row_count := 0;
											for  y_row in c_current_route(x_row.ne_id_in,x_row.start_slk, x_row.end_slk) loop
												n_row_count := n_row_count +1;
												if x_row.cnt = 1 then											
														r_output.EXTEND(1);
														n_idx := r_output.count();
														r_output(n_idx).historic_date 		:= r_input.historic_date;
														r_output(n_idx).loc_ident 			:= r_input.loc_ident;
														r_output(n_idx).route_name			:= r_input.route_name;
														r_output(n_idx).offset_from			:= r_input.offset_from;
														r_output(n_idx).offset_to			:= r_input.offset_to;
														r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
														select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
														--r_output(n_idx).new_offset_from		:= y_row.offset_from; --r_input.new_offset_from;
														r_output(n_idx).new_offset_from		:= y_row.offset_from; --  - (r_start_datum.datum_start_slk -r_start_datum.given_slk);
														r_output(n_idx).new_offset_to		:= y_row.offset_to; -- - (r_end_datum.datum_end_slk -r_end_datum.given_slk) ; --r_input.new_offset_to;
														r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, y_row.offset_from, y_row.offset_to );
														if r_input.offset_from <>  y_row.offset_from OR r_input.offset_to <>y_row.offset_to then
															r_output(n_idx).process_msg		:= 'Route Location Changed'; --r_input.process_msg;
														else
															r_output(n_idx).process_msg		:= 'Route Location Not Changed'; --r_input.process_msg;											
														end if;
													
												else 
													
														r_output.EXTEND(1);
														n_idx := r_output.count();
														r_output(n_idx).historic_date 		:= r_input.historic_date;
														r_output(n_idx).loc_ident 			:= r_input.loc_ident;
														r_output(n_idx).route_name			:= r_input.route_name;
														r_output(n_idx).offset_from			:= r_input.offset_from;
														r_output(n_idx).offset_to			:= r_input.offset_to;
														r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
														select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
														r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, y_row.offset_from, y_row.offset_to );
														if n_row_count = 1 then 
															r_output(n_idx).new_offset_from := y_row.offset_from; --  - (r_start_datum.datum_start_slk -r_start_datum.given_slk);
														else
															r_output(n_idx).new_offset_from		:= y_row.offset_from; --r_input.new_offset_from;
														end if;
														r_output(n_idx).new_offset_to		:= y_row.offset_to; --r_input.new_offset_to;
														r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
													
												end if;
												
											--Flush Array Added 2015/01/21 to address a case where the array got too big
												if n_idx >= 45 then  -- see if the array is getting too big				
													flush_array;				
												end if;	
												
											end loop;
											if r_output.count() >= 1 then  r_output(r_output.count()).new_offset_to		:= r_output(r_output.count()).new_offset_to - (r_end_datum.datum_end_slk -r_end_datum.given_slk) ; end if;
											*/
										end if;
										
											
											-- adjust the last 
											
											--Flush Array Added 2015/01/07 to address a case where the array got too big
											if n_idx >= 45 then  -- see if the array is getting too big				
												flush_array;				
											end if;	
											
									end loop;
								end if;
							
							
						when n_code = 4 then  -- Multiple items are now in that area, lets finds them
								
							for  my_row in (select *  from xaa_route where route_id = (select ne_id  from nm_elements where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = r_input.route_name) and offset_from >= r_input.offset_from and offset_to <= r_input.offset_to order by offset_from)
							loop
								null; --------------------------- need code here
							end loop;
							
							
							null;
						when n_code = 5 then -- route name was end dated,
							select ne_id into n_temp  from nm_elements_all where ne_type = 'G' and ne_unique = r_input.route_name and rownum = 1;
							select count(*) into n_count from nm_element_history where neh_ne_id_old = (n_temp);
							
							if n_count = 0 then -- only end dated
								r_output.EXTEND(1);
								n_idx := r_output.count();
								r_output(n_idx).historic_date 		:= r_input.historic_date;
								r_output(n_idx).loc_ident 			:= r_input.loc_ident;
								r_output(n_idx).route_name			:= r_input.route_name;
								r_output(n_idx).offset_from			:= r_input.offset_from;
								r_output(n_idx).offset_to			:= r_input.offset_to;
								r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
								r_output(n_idx).new_date 			:= get_end_date(r_input.route_name, r_input.offset_from, r_input.offset_to );
								r_output(n_idx).new_route_name		:= null; --r_input.new_route_name;
								r_output(n_idx).new_offset_from		:= null; --r_input.new_offset_from;
								r_output(n_idx).new_offset_to		:= null; --r_input.new_offset_to;
								r_output(n_idx).process_msg			:= 'Route Location Closed'; --r_input.process_msg;
								
							else -- probably renamed
								
								r_old_loc := get_old_loc_list(n_temp);  
								s_log_base_info := 'Informational';
								s_log_text :='r_old_loc count(' || r_old_loc.count ||')  for: ' || r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
								
								if r_old_loc.count = 0 then 
									r_output.EXTEND(1);
									n_idx := r_output.count();
									r_output(n_idx).historic_date 		:= r_input.historic_date;
									r_output(n_idx).loc_ident 			:= r_input.loc_ident;
									r_output(n_idx).route_name			:= r_input.route_name;
									r_output(n_idx).offset_from			:= r_input.offset_from;
									r_output(n_idx).offset_to			:= r_input.offset_to;
									r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
									r_output(n_idx).new_date 			:= get_end_date(r_input.route_name, r_input.offset_from, r_input.offset_to );
									r_output(n_idx).new_route_name		:= null; --r_input.new_route_name;
									r_output(n_idx).new_offset_from		:= null; --r_input.new_offset_from;
									r_output(n_idx).new_offset_to		:= null; --r_input.new_offset_to;
									r_output(n_idx).process_msg			:= 'Route Location Closed'; --r_input.process_msg;
								else
									r_new_id_list := typ_new_ne_id_list();
									r_new_rt_name := r_old_loc(r_old_loc.count);  
									if b_debug= true then
										s_log_base_info := 'Informational';
										s_log_text :='select ne_id into n_old_rt_id from nm_elements_all where ne_nt_type =  ' || s_route_type || '  and ne_type = G and ne_unique =  ' || r_input.route_name || '  and (ne_start_date >= trunc( ' || r_input.historic_date || ' ) AND NVL (ne_end_date, TO_DATE (99991231, YYYYMMDD)) >  trunc( ' || r_input.historic_date || ' ))';
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									end if;								
									select ne_id into n_old_rt_id from nm_elements_all where ne_nt_type = s_route_type and ne_type = 'G' and ne_unique = r_input.route_name and (ne_start_date >= trunc(r_input.historic_date) AND NVL (ne_end_date, TO_DATE ('99991231', 'YYYYMMDD')) >  trunc(r_input.historic_date))	;
									
									r_nm_members_all.delete;
									r_nm_members_all := typ_nm_members_all();
									
										open c_nm_mem_effective_rt(n_old_rt_id,r_input.offset_from, r_input.offset_to, r_input.historic_date );
											fetch c_nm_mem_effective_rt bulk collect into r_nm_members_all;
										close c_nm_mem_effective_rt;
									
									if r_nm_members_all.count = 0 then
										s_log_base_info := 'Informational';
										s_log_text :='Unexpected 0 record count for CASE  (' || n_code ||')  for: ' || r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
										
										-- Lets log the issue
										r_output.EXTEND(1);
										n_idx := r_output.count();
										r_output(n_idx).historic_date 		:= r_input.historic_date;
										r_output(n_idx).loc_ident 			:= r_input.loc_ident;
										r_output(n_idx).route_name			:= r_input.route_name;
										r_output(n_idx).offset_from			:= r_input.offset_from;
										r_output(n_idx).offset_to			:= r_input.offset_to;
										r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
										r_output(n_idx).new_route_name 		:= null;
										r_output(n_idx).new_offset_from		:= null;
										r_output(n_idx).new_offset_to		:= null;
										r_output(n_idx).process_msg			:= 'Error Retrieving Effective Route, Perhaps The Offsets Are The Same.'; --r_input.process_msg;
					
									else
										if b_debug= true then
											s_log_base_info := 'Informational';
											s_log_text :='r_nm_members_all.count = ' || r_nm_members_all.count || ' for CASE  (' || n_code ||')  for: ' || r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
											x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
										end if;
										
										r_n_spilt.delete;
										r_n_spilt := typ_numbers();
										r_new_id_list := typ_new_ne_id_list();
										
										for xx in r_nm_members_all.first..r_nm_members_all.last loop
												r_old_loc := get_old_loc_list(r_nm_members_all(xx).nm_ne_id_of );  --test
												s_log_base_info := 'Informational';
												s_log_text :='r_old_loc count(' || r_old_loc.count ||')  for: ' || r_nm_members_all(xx).nm_ne_id_of ||', ' ||r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
												x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
												
												
													for xx in r_old_loc.first .. r_old_loc.last loop
														if r_old_loc(xx).NEH_operation = 'S' then
															r_n_spilt.extend(1);
															r_n_spilt(r_n_spilt.count) := r_old_loc(xx).neh_ne_id_new;
														else
															NULL;
														end if;
													end loop;
													
													if r_n_spilt.count <> 0 then 
														for xx in r_n_spilt.first..r_n_spilt.last loop
															if b_debug= true then
																s_log_base_info := 'Informational';
																s_log_text :='select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk  from nm_members_all where nm_ne_id_of =  ' || r_n_spilt(xx) || ' ;';
																x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
															end if;
															r_new_id_list.extend(1);
															select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk, 'S' into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk, r_new_id_list(r_new_id_list.count).op from nm_members_all where nm_ne_id_of = r_n_spilt(xx) and nm_obj_type = s_route_type and nm_start_date = (select max(nm_start_date) from nm_members_all  where nm_ne_id_of = r_n_spilt(xx) and nm_obj_type = s_route_type) ;
														end loop;
													end if;
													
													r_new_id_list.extend(1);
													
													if b_debug= true then
														s_log_base_info := 'Informational';
														s_log_text :='select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk  from nm_members_all where nm_ne_id_of = ' || n_temp || ' nm_obj_type =  ' ||  s_route_type || '  ;';
														x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
													end if;
													
													select count(*) into n_count from nm_members_all where nm_ne_id_of = n_temp and nm_obj_type = s_route_type;
													if n_count <>0 then 
														select nm_ne_id_of, nm_ne_id_in, nm_slk, nm_end_slk into r_new_id_list(r_new_id_list.count).ne_id_of, r_new_id_list(r_new_id_list.count).ne_id_in, r_new_id_list(r_new_id_list.count).slk, r_new_id_list(r_new_id_list.count).end_slk from nm_members_all where nm_ne_id_of = n_temp and nm_obj_type = s_route_type;
														n_temp := r_old_loc(r_old_loc.last).neh_ne_id_new;
														r_new_id_list(r_new_id_list.count).op := r_old_loc(r_old_loc.last).neh_operation;
													end if;
										end loop;
										
										-- see if the results are continuous,  going to use a oracle table to check this
											delete from xaa_route_temp_sql where cur_user = user and cur_proc = s_module;
											
											if r_new_id_list.count <> 0 then 
												forall xx in r_new_id_list.first..r_new_id_list.last 
													insert into xaa_route_temp_sql 
																(
																cur_user ,
																cur_proc ,
																ne_id_of ,
																ne_id_in , 
																slk , 
																end_slk, 
																op 
																) 
																Values 
																(
																user,
																s_module,
																r_new_id_list(xx).ne_id_of,
																r_new_id_list(xx).ne_id_in,
																r_new_id_list(xx).slk,
																r_new_id_list(xx).end_slk,
																r_new_id_list(xx).op
																);
												
												fill_xaa_route_temp_gaps;  -- fixing gaps
												update_xaa_route_temp;
												for x_row in c_chk_cont_current loop										
													r_output.EXTEND(1);
													n_idx := r_output.count();
													r_output(n_idx).historic_date 		:= r_input.historic_date;
													r_output(n_idx).loc_ident 			:= r_input.loc_ident;
													r_output(n_idx).route_name			:= r_input.route_name;
													r_output(n_idx).offset_from			:= r_input.offset_from;
													r_output(n_idx).offset_to			:= r_input.offset_to;
													r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
													select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
													r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, x_row.start_slk, x_row.end_slk );
													r_output(n_idx).new_offset_from		:= x_row.start_slk; -- - (r_start_datum.datum_start_slk -r_start_datum.given_slk); --r_input.new_offset_from;
													r_output(n_idx).new_offset_to		:= x_row.end_slk; --  - (r_end_datum.datum_end_slk -r_end_datum.given_slk); --r_input.new_offset_to;
													r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
													
													/*
													for  y_row in c_current_route(x_row.ne_id_in,x_row.start_slk, x_row.end_slk) loop
													
														if x_row.cnt = 1 then
															
																r_output.EXTEND(1);
																n_idx := r_output.count();
																r_output(n_idx).historic_date 		:= r_input.historic_date;
																r_output(n_idx).loc_ident 			:= r_input.loc_ident;
																r_output(n_idx).route_name			:= r_input.route_name;
																r_output(n_idx).offset_from			:= r_input.offset_from;
																r_output(n_idx).offset_to			:= r_input.offset_to;
																r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
																select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
																r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, y_row.offset_from, y_row.offset_to );
																r_output(n_idx).new_offset_from		:= y_row.offset_from; --r_input.new_offset_from;
																r_output(n_idx).new_offset_to		:= y_row.offset_to; --r_input.new_offset_to;
																r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
															
														else
															
																r_output.EXTEND(1);
																n_idx := r_output.count();
																r_output(n_idx).historic_date 		:= r_input.historic_date;
																r_output(n_idx).loc_ident 			:= r_input.loc_ident;
																r_output(n_idx).route_name			:= r_input.route_name;
																r_output(n_idx).offset_from			:= r_input.offset_from;
																r_output(n_idx).offset_to			:= r_input.offset_to;
																r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
																select ne_unique into r_output(n_idx).new_route_name 	from nm_elements_all where ne_id = 	x_row.ne_id_in; --:= null; --r_input.new_route_name;
																r_output(n_idx).new_date 			:= get_mod_date(r_output(n_idx).new_route_name, y_row.offset_from, y_row.offset_to );
																r_output(n_idx).new_offset_from		:= y_row.offset_from; --r_input.new_offset_from;
																r_output(n_idx).new_offset_to		:= y_row.offset_to; --r_input.new_offset_to;
																r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
															
														end if; 
													end loop;
													*/
												end loop;
											else
												-- Lets log the issue
												r_output.EXTEND(1);
												n_idx := r_output.count();
												r_output(n_idx).historic_date 		:= r_input.historic_date;
												r_output(n_idx).loc_ident 			:= r_input.loc_ident;
												r_output(n_idx).route_name			:= r_input.route_name;
												r_output(n_idx).offset_from			:= r_input.offset_from;
												r_output(n_idx).offset_to			:= r_input.offset_to;
												r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
												r_output(n_idx).new_route_name 		:= null;
												r_output(n_idx).new_offset_from		:= null;
												r_output(n_idx).new_offset_to		:= null;
												r_output(n_idx).process_msg			:= 'Error Retrieving History'; --r_input.process_msg;
											end if;
									end if;
								end if;
							end if;
						/*when 6 then	 --recalibrate?
							s_log_area := 'R_Input_Loop-6'; 
							r_nm_members_all.delete;
							r_nm_members_all := typ_nm_members_all();
							
							open c_nm_mem_effective_rt_b(n_old_rt_id,r_input.offset_from, r_input.offset_to);
								fetch c_nm_mem_effective_rt bulk collect into r_nm_members_all;
							close c_nm_mem_effective_rt;
							
														r_output.EXTEND(1);
														n_idx := r_output.count();
														r_output(n_idx).historic_date 		:= r_input.historic_date;
														r_output(n_idx).loc_ident 			:= r_input.loc_ident;
														r_output(n_idx).route_name			:= r_input.route_name;
														r_output(n_idx).offset_from			:= r_input.offset_from;
														r_output(n_idx).offset_to			:= r_input.offset_to;
														r_output(n_idx).source_table		:= r_input.source_table; --upper('xaa_elements_all'); --r_input.source_table;
														r_output(n_idx).new_route_name		:= 'test recal';
														r_output(n_idx).new_offset_from		:= 0; --r_input.new_offset_from;
														r_output(n_idx).new_offset_to		:= 0; --r_input.new_offset_to;
														r_output(n_idx).process_msg			:= 'Route Location Changed'; --r_input.process_msg;
														*/
						else
							s_log_base_info := 'Unhandled Item';
							s_log_text :='function route_changed returned an unknown code (' || n_code ||')  for: ' || r_input.historic_date ||', ' || r_input.route_name ||', ' || r_input.offset_from ||', ' || r_input.offset_to;
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
					end case;
					
					if n_idx >= 45 then  -- see if the array is getting too big				
						flush_array;				
					end if;	
					
			/*	exception when others then
					err_num := SQLCODE;
					err_msg := SUBSTR(SQLERRM, 1, 200);
					x_log_table.log_item(s_module, 'R_Input_Loop', 'Unhandled Error', err_num || ' - ' || err_msg);
					RAISE; */
				end;
				

			end loop;
			
			flush_array;
			commit;
			
		end process_route_events;
	
	

		
-----------------------------		Asset Information		-----------------------------
-----------------------------		Asset Information		-----------------------------
-----------------------------		Asset Information		-----------------------------

procedure generate_asset_info(s_user varchar2 default 'EXOR_TO_AA') is
	
	s_sql_columns varchar2(32767);
	s_sql_template varchar2(32767);
	

	cursor c_assets is select asset_type, table_name, route_type from  xaa_asset_type;
	cursor c_columns(s_asset_type varchar2) is select * from xaa_asset_attrib where asset_type = s_asset_type order by column_seq;
	
	procedure drop_table(s_table varchar2) is
		n_table number;
		begin
			select count(*) into n_table from user_tables where table_name = upper(s_table);
            if n_table > 0 then
                execute immediate 'drop table ' || s_table;
            end if;
		end drop_table;
		
	function get_column(s_type varchar2, s_col_name varchar2, s_new_view_name varchar2) return varchar2 is
		n_count number;
		s_ret_val varchar2(30);
		
		begin
		
		select count(*) into n_count from nm_inv_type_attribs where ita_inv_type = s_type and ita_view_col_name = s_col_name;
		
		case n_count
			when 0 then 
				s_ret_val := chr(39)|| 'Invaild Column Name' || chr(39) ||' '|| chr(34) ||  substr(s_new_view_name, 1,30) || chr(34) ;
			when 1 then 
				select ita_attrib_name into s_ret_val from nm_inv_type_attribs where ita_inv_type = s_type and ita_view_col_name = s_col_name;
				
				s_ret_val := s_ret_val || ' ' || chr(34) ||  substr(s_new_view_name, 1,30) || chr(34) ;
			else --multiple returned, should never happen
				s_ret_val := chr(39)|| 'Error Retrieving Column Name' || chr(39) ||' '|| chr(34) ||  substr(s_new_view_name, 1,30) || chr(34) ;
		end case;
		
		
		return s_ret_val;
	end get_column;
	
	procedure reset_template is
		begin
		--set the template
		s_sql_template := 
		q'[
			select 
			ne_unique "ROUTE"
			,'RT' "ROUTE_TYPE"
			,begin_mp_no "FROM_POINT"
			,end_mp_no "END_POINT"
			, aloc_nm_ne_id_in "ASSET_ID"
			##COL##
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
						FROM exor.nm_members aloc,
						exor.nm_members mem           
					WHERE 1=1
					AND mem.nm_obj_type = '##ROUTE_TYPE##'
					AND aloc.nm_type = 'I'        
					AND aloc.nm_obj_type =  '##INV_TYPE##'
					AND mem.nm_ne_id_of = aloc.nm_ne_id_of
				   ) base1) )base2          
					group by  mem_nm_ne_id_in, aloc_nm_ne_id_in,DBSMP) a
			, (select * from exor.nm_inv_items) b
			, (select ne_id, ne_unique from exor.nm_elements) c
			where 
			b.iit_ne_id = a.aloc_nm_ne_id_in
			and a.mem_nm_ne_id_in = c.ne_id	
		]';
	end reset_template;

	procedure grant_select is
		cursor c_tables is select distinct table_name from xaa_asset_type;
		begin
		for xrow in c_tables loop
			execute immediate 'grant select on exor.' || xrow.table_name || '  to ' || s_user;
			execute immediate 'create or replace synonym '|| s_user ||'.' || xrow.table_name || ' for exor.'||xrow.table_name;
		end loop;
	end grant_select;
	
	Begin  ---********* start generate assets *********
		s_module := upper('generate_asset_info');
		x_log_table.clean(s_module);  -- remove existing log file entries
		
		
            
		
		for r_row in c_assets	loop
			s_log_area := 'c_assets';  -- log area
			
			reset_template;
			
			drop_table(r_row.table_name);
			-- build column list
			s_sql_columns := '' ; --'select datum_ne_unique route, ' || s_route_type || ' route_type, route_slk_start from_point, route_slk_end to_point, iit_primary_key  asset_id';
			
			for r_col_row in c_columns(r_row.asset_type) loop
				s_sql_columns := s_sql_columns || ', ' || get_column(r_row.asset_type, r_col_row.COLUMN_DERIVATION ,r_col_row.column_name);  
			end loop;
			
			s_sql_template := replace(s_sql_template,'##ROUTE_TYPE##', s_route_type);
			s_sql_template := replace(s_sql_template,'##INV_TYPE##', r_row.asset_type);
			s_sql_template := replace(s_sql_template,'##COL##', s_sql_columns);
			
			s_log_base_info := 'Informational';
			s_log_text := substr(s_sql_template,1,4000);
			x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
			
			
			execute immediate 'create table ' || r_row.table_name ||' as (' ||  s_sql_template || ' )';
		end loop;
			
			grant_select;
			
	end generate_asset_info;

-----------------------------		Reports		-----------------------------
-----------------------------		Reports		-----------------------------
-----------------------------		Reports		-----------------------------

procedure generate_report_info(d_date_overide in date default null, b_process_spatial in boolean default true) is
	type ty_neh is table of nm_element_history%rowtype;
	type ty_len_change  is table of xaa_length_change%rowtype;	
	
	d_latest_date 			date;
	n_count				 	number;
	i						number :=0 ;
	s_ne_type 				varchar2(1);
	d_ne_date				date;
	d_time_ran 				date;
	s_temp 					varchar2(2000);
	n_temp					number;
	d_temp					date;
	n_temp_seq				number;
	r_report 				ty_len_change := ty_len_change();
	t_neh 					ty_neh := ty_neh() ;		
	r_mem_all				nm_members_all%rowtype;
	
	cursor c_mem_all(d_my_date date) is 
			select nmd.rowid row_id, nmd.*, ne.ne_date_modified from
				nm_elements_all rt
				, nm_members_all nmd
				, nm_elements_all ne			
			where 1=1
			and RT.NE_ID = nmd.nm_ne_id_in
			and nmd.nm_ne_id_of = ne.ne_id
			--
			and rt.ne_nt_type = s_route_type 
			--
			and trunc(ne.ne_date_modified) >=  d_my_date
			and trunc(nmd.nm_date_modified) >=  d_my_date
			--
			--and nm_ne_id_of = 334687
			;
			
	cursor  c_spatial_audit(d_my_date date) is select * from xaa_spatial_audit where trunc(op_date) >= d_my_date;
	cursor c_t_neh(n_nm_ne_id_of number, d_nm_date_modified date) is select *  from nm_element_history where neh_ne_id_old = n_nm_ne_id_of and trunc(neh_actioned_date) = trunc(d_nm_date_modified);
	
	procedure flush_array is
		n_temp_count number;
		begin
			dbms_output.put_line('Flushing');
			s_log_area := 'flush_array';  -- log area
			n_temp_count := r_report.count;
					--lets flush our array
			forall xx in r_report.first .. r_report.last
				insert into xaa_length_change values r_report(xx);
			r_report.delete;							
						
			s_log_base_info := 'Flushing r_report';
			s_log_text :='r_report had ' || n_temp_count || ' items  and needed to be flushed.';
			x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
			
			r_report := ty_len_change();
			i := 0;		
			
			--commit;  --for testing
	end flush_array;
	
	-- Needed to redo these "GET" functions from nm3net since it might be ran form a non exor user
	
	function get_ne_unique(n_ne_id number) return varchar2 is
		n_temp number;
		s_temp varchar2(50) := 'NOTFOUND: NE_ID';
		begin
			select count(*) into n_temp from nm_elements_all where ne_id = n_ne_id;
			if n_temp <> 0 then
				select ne_unique into s_temp from nm_elements_all where ne_id = n_ne_id;
			end if;
		return s_temp;
	end get_ne_unique;
	
	function get_ne_descr(n_ne_id number) return varchar2 is
		n_temp number;
		s_temp varchar2(240) := 'NOTFOUND: NE_ID';
		begin
			select count(*) into n_temp from nm_elements_all where ne_id = n_ne_id;
			if n_temp <> 0 then
				select ne_descr into s_temp from nm_elements_all where ne_id = n_ne_id;
			end if;
		return s_temp;
	end get_ne_descr;
	
	function get_ne_length(n_ne_id number) return number is
		n_temp number;
		nn_temp number := -1;
		begin
			select count(*) into n_temp from nm_elements_all where ne_id = n_ne_id;
			if n_temp <> 0 then
				select ne_length into nn_temp from nm_elements_all where ne_id = n_ne_id;
			end if;
		return nn_temp;
	end get_ne_length;
	
	begin
		--DBMS_OUTPUT.ENABLE(500);
		s_module := upper('generate_report_info');
		x_log_table.clean(s_module);  -- remove existing log file entries
		
		if d_date_overide is null  then
			select nvl(max(REPORT_RUN_DATE),to_date('01-JAN-1900')) into d_latest_date from xaa_length_change;
		else 
			d_latest_date := d_date_overide;
		end if;
		
		i := 0;		
		s_log_base_info := 'Using latest date of: ';
		s_log_text := to_char(d_latest_date,'DD/MON/YYYY');
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
		
		d_time_ran := sysdate;
		
		for r_mem_all in c_mem_all(d_latest_date) loop
			t_neh.delete();
			open c_t_neh(r_mem_all.nm_ne_id_of, trunc(r_mem_all.ne_date_modified));
				fetch c_t_neh bulk collect into t_neh;
			close c_t_neh;
			
			if b_debug = true then 
				s_log_area := 'Collecting from c_t_neh';
				s_log_base_info := 'Generating, Bulk Collected into t_neh for r_mem_all.nm_ne_id_of, r_mem_all.ne_date_modified and rowid: ' || r_mem_all.nm_ne_id_of|| ', ' ||r_mem_all.ne_date_modified || ', ' ||r_mem_all.row_id ;
				s_log_text :=t_neh.count();
				x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
			end if;
			
			dbms_output.put_line('count: ' || r_report.count || ', i is: ' || i);
			
				n_count := t_neh.count();
				if n_count = 0 then -- no operation in history (rescale, new datum/DB)
					BEGIN
						i:= r_report.count() + 1;
						
						s_log_area := 'no operation in history';  -- log area
						--s_log_base_info := 'The current r_report value is:';
						--s_log_text :=i;
						--x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						
						select count(*) into  n_count from nm_elements_all where 1=1 and ne_id = r_mem_all.nm_ne_id_of;
						
						if b_debug = true then 
							s_log_base_info := 'select count(*) into  n_count from nm_elements_all where 1=1 and ne_id = ' || r_mem_all.nm_ne_id_of;
							s_log_text :=n_count;
							x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
						end if;
						
						if n_count > 0 then 
							select nvl(ne_type,0),trunc(ne_start_date) into s_ne_type, d_ne_date from nm_elements_all where 1=1 and ne_id = r_mem_all.nm_ne_id_of;							
							if d_ne_date = trunc(r_mem_all.nm_start_date) then
								case s_ne_type
									when 'D' then --new DB
										r_report.EXTEND(1);
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE				:= 	d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 					:= 'DISTANCE BREAK';
										r_report(i).OPERATION 					:= 'ADDED';
										r_report(i).OLD_BEGIN_MEASURE			:= null;
										r_report(i).OLD_END_MEASURE				:= null;
										r_report(i).NEW_BEGIN_MEASURE 			:= r_mem_all.nm_slk;
										r_report(i).NEW_END_MEASURE				:= r_mem_all.nm_end_slk;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_end_slk - r_mem_all.nm_slk;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);
									when 'S' then--new datum
										r_report.EXTEND(1);
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE	:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 					:= 'DATUM';
										r_report(i).OPERATION 					:= 'ADDED';
										r_report(i).OLD_BEGIN_MEASURE			:= null;
										r_report(i).OLD_END_MEASURE				:= null;
										r_report(i).NEW_BEGIN_MEASURE 			:= r_mem_all.nm_slk;
										r_report(i).NEW_END_MEASURE				:= r_mem_all.nm_end_slk;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_end_slk - r_mem_all.nm_slk;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);								
									else
										null;
								end case;
							else 
								null;
							end if;
						else -- was a DB closed
							s_log_area := 'DB Closed';
							--s_log_base_info := 'The current r_report value is:';
							--s_log_text :=i;
							--x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
							
							select count(*) into n_count from nm_elements_all where ne_type = 'D' and ne_id = r_mem_all.nm_ne_id_of;
							if n_count = 0 then 
								null;  --no need to log
							else --lets see if it was closed
								select count(*) into n_count from nm_members_all where nm_ne_id_in = r_mem_all.nm_ne_id_in and nm_ne_id_of = r_mem_all.nm_ne_id_of and nm_start_date =  r_mem_all.nm_end_date;
								if n_count <> 0 then 
										
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										
										s_log_area := 'the DB was closed';
										s_log_base_info := 'The current r_report value is: ' ||i;
										s_log_text := 'The current change_ID  value is: ' || n_temp_seq;
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
										
										r_report.EXTEND(1);
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE	:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_end_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 				:= 'DISTANCE_BREAK';
										r_report(i).OPERATION 					:= 'CLOSED';
										r_report(i).OLD_BEGIN_MEASURE			:= r_mem_all.nm_slk;
										r_report(i).OLD_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).NEW_BEGIN_MEASURE 			:= null;
										r_report(i).NEW_END_MEASURE			:= null;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_end_slk - r_mem_all.nm_slk;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= substr(get_ne_unique(r_mem_all.nm_ne_id_in),1,30);
										r_report(i).ROUTE_NAME					:= substr(get_ne_descr(r_mem_all.nm_ne_id_in),1,30);	
								end if;
							end if;
						end if;
						/*
						exception when others then
							err_num := SQLCODE;
							err_msg := SUBSTR(SQLERRM, 1, 200);
							x_log_table.log_item(s_module, 'Generating, History D/DB', 'unhandled Error', err_num || ' - ' || err_msg);
							RAISE;
						*/
					end;
				else 
					--i :=0;
					for idx in t_neh.first..t_neh.last loop
					--for r_row in t_neh loop
						BEGIN
							s_log_area := 'BRC Loop';
							i:= r_report.count() + 1;
							
							if b_debug = true then
								s_log_base_info := 'current t_neh row ';
								s_log_text :='item: '|| t_neh(idx).neh_id  ;
								x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
							end if;
							
							case t_neh(idx).neh_operation
								when 'B' then  -- Recalibrate
									select count(*) into n_count from nm_element_history where neh_ne_id_new = r_mem_all.nm_ne_id_of and trunc(neh_actioned_date) = trunc(r_mem_all.ne_date_modified) and neh_operation in ('S', 'M', 'H');
									
									if b_debug = true then
										s_log_base_info := 'Recalibrate r_mem_all.nm_ne_id_of ';
										s_log_text :='item: '|| r_mem_all.nm_ne_id_of  || ' had date :  '|| r_mem_all.ne_date_modified ||  ' and a SMH count of:' || n_count;
										x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
									end if;
									
									
									select ne_start_date into d_temp from nm_elements_all where ne_id = r_mem_all.nm_ne_id_of;
									if t_neh(idx).neh_effective_date = d_temp and n_count =0 then --new datum
										r_report.EXTEND(1);
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE	:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 				:= 'DATUM';
										r_report(i).OPERATION 					:= 'ADDED';
										r_report(i).OLD_BEGIN_MEASURE			:= null;
										r_report(i).OLD_END_MEASURE			:= null;
										r_report(i).NEW_BEGIN_MEASURE 			:= r_mem_all.nm_slk;
										r_report(i).NEW_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_end_slk - r_mem_all.nm_slk;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);								
									elsif r_mem_all.nm_end_date is not null then ----recalibrate
											r_report.EXTEND(1);
											select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
											r_report(i).CHANGE_ID 					:=  n_temp_seq;
											r_report(i).REPORT_RUN_DATE	:= d_time_ran;
											r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
											r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
											r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
											r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
											r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
											r_report(i).DATUM_TYPE 					:= 'DATUM';
											--	r_report(i).OPERATION 					:= 'ADDED';
											r_report(i).OLD_BEGIN_MEASURE			:= r_mem_all.nm_slk + t_neh(idx).neh_param_1;
											r_report(i).OLD_END_MEASURE				:= r_mem_all.nm_slk + t_neh(idx).neh_old_ne_length;
											r_report(i).NEW_BEGIN_MEASURE 			:= r_mem_all.nm_slk + t_neh(idx).neh_param_1;
											r_report(i).NEW_END_MEASURE				:= r_mem_all.nm_slk + t_neh(idx).neh_param_1+t_neh(idx).neh_param_2;
											r_report(i).CHANGE_START_MEASURE		:= least(r_report(i).NEW_END_MEASURE,r_report(i).OLD_END_MEASURE);
											r_report(i).CHANGE_END_MEASURE			:= greatest(r_report(i).NEW_END_MEASURE,r_report(i).OLD_END_MEASURE);
											r_report(i).MILEAGE_CHANGE				:= r_report(i).OLD_END_MEASURE - r_report(i).NEW_END_MEASURE;
											r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
											r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
											r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);		
											
											if r_report(i).NEW_END_MEASURE < r_report(i).old_END_MEASURE then
												s_temp := 'RECALIBRATE SHORTER';
											else
												s_temp := 'RECALIBRATE LONGER';
											end if;										
											
											r_report(i).OPERATION 					:= s_temp;
											
									end if;
								when 'N' then --reclassify
									-- first for the "new" one
										select xaa_leng_change_seq.nextval into n_temp_seq from dual;
										r_report.EXTEND(1);										
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE		:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 					:= 'DATUM';
										r_report(i).OPERATION 					:= 'ADDED RECLASSIFY';
										r_report(i).OLD_BEGIN_MEASURE			:= null;
										r_report(i).OLD_END_MEASURE				:= null;
										r_report(i).NEW_BEGIN_MEASURE 			:= r_mem_all.nm_slk;
										r_report(i).NEW_END_MEASURE				:= r_mem_all.nm_end_slk;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_end_slk - r_mem_all.nm_slk;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);	
										
										--now take care of the old one
										i:= r_report.count() + 1;
										
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										r_report.EXTEND(1);
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE		:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 					:= 'DATUM';
										r_report(i).OPERATION 					:= 'CLOSED RECLASSIFY';
										SELECT NM_SLK into n_temp from nm_members_all where rownum = 1 and nm_type = 'G'  and nm_obj_type in (s_route_type) and nm_end_date = t_neh(idx).NEH_EFFECTIVE_DATE and NM_NE_ID_OF = t_neh(idx).NEH_NE_ID_OLD ;
											r_report(i).OLD_BEGIN_MEASURE			:= n_temp;
										SELECT NM_end_SLK into n_temp from nm_members_all where rownum = 1 and nm_type = 'G'  and nm_obj_type in (s_route_type) and nm_end_date = t_neh(idx).NEH_EFFECTIVE_DATE and NM_NE_ID_OF = t_neh(idx).NEH_NE_ID_OLD;	
											r_report(i).OLD_END_MEASURE				:= n_temp;
										r_report(i).NEW_BEGIN_MEASURE 			:= null;
										r_report(i).NEW_END_MEASURE				:= null;
										SELECT NM_SLK into n_temp from nm_members_all where rownum = 1 and nm_type = 'G'  and nm_obj_type in (s_route_type) and nm_end_date = t_neh(idx).NEH_EFFECTIVE_DATE and NM_NE_ID_OF = t_neh(idx).NEH_NE_ID_OLD;
											r_report(i).CHANGE_START_MEASURE		:= n_temp;
										SELECT NM_END_SLK into n_temp from nm_members_all where rownum = 1 and nm_type = 'G'  and nm_obj_type in (s_route_type) and nm_end_date = t_neh(idx).NEH_EFFECTIVE_DATE and NM_NE_ID_OF = t_neh(idx).NEH_NE_ID_OLD;
											r_report(i).CHANGE_END_MEASURE			:= n_temp;
										r_report(i).MILEAGE_CHANGE				:= r_report(i).OLD_BEGIN_MEASURE - r_report(i).OLD_END_MEASURE;
										SELECT NM_NE_ID_IN into n_temp from nm_members_all where rownum = 1 and nm_type = 'G'  and nm_obj_type in (s_route_type) and nm_end_date = t_neh(idx).NEH_EFFECTIVE_DATE and NM_NE_ID_OF = t_neh(idx).NEH_NE_ID_OLD;
											r_report(i).ROUTE_ID 					:= n_temp;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_report(i).ROUTE_ID);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_report(i).ROUTE_ID);	
										
								when 'C' then  --Closed
										select ne_type into s_ne_type from nm_elements_all where ne_id = r_mem_all.nm_ne_id_of;
										
										case s_ne_type
											when 'S' then
												s_temp := 'DATUM';
											when 'D' then 
												s_temp := 'DISTANCE BREAK';
											else
												s_temp := upper('UNKNOWN ne_type');
										end case;
										
										select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
										r_report.EXTEND(1);
										r_report(i).CHANGE_ID 					:=  n_temp_seq;
										r_report(i).REPORT_RUN_DATE		:= d_time_ran;
										r_report(i).CHANGE_DATE 				:= r_mem_all.ne_date_modified;
										r_report(i).EFFECTIVE_DATE				:= r_mem_all.nm_start_date;
										r_report(i).DATUM_ID 					:= r_mem_all.nm_ne_id_of;
										r_report(i).DATUM_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_LENGTH				:= get_ne_length(r_mem_all.nm_ne_id_of);
										r_report(i).DATUM_TYPE 					:= s_temp;
										r_report(i).OPERATION 					:= 'CLOSED';
										r_report(i).OLD_BEGIN_MEASURE			:= r_mem_all.nm_slk;
										r_report(i).OLD_END_MEASURE				:= r_mem_all.nm_end_slk;
										r_report(i).NEW_BEGIN_MEASURE 			:= null;
										r_report(i).NEW_END_MEASURE				:= null;
										r_report(i).CHANGE_START_MEASURE		:= r_mem_all.nm_slk;
										r_report(i).CHANGE_END_MEASURE			:= r_mem_all.nm_end_slk;
										r_report(i).MILEAGE_CHANGE				:= r_mem_all.nm_slk - r_mem_all.nm_end_slk ;
										r_report(i).ROUTE_ID 					:= r_mem_all.nm_ne_id_in;
										r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_mem_all.nm_ne_id_in);
										r_report(i).ROUTE_NAME					:= get_ne_descr(r_mem_all.nm_ne_id_in);	
								else -- no length change
									null;
							end case;
							
							if i >= 100 then  -- see if r_report is getting to big
								flush_array;	
								
							end if;
						/*	
						exception when others then
							err_num := SQLCODE;
							err_msg := SUBSTR(SQLERRM, 1, 200);
							x_log_table.log_item(s_module, 'Generating, History BRC loop', 'Unhandled Error', err_num || ' - ' || err_msg);
							RAISE; */
						END;
					end loop;
				end if;
			if i >= 100 then  -- see if r_report is getting to big
				flush_array;
				
			end if;		
		end loop;
		
		flush_array;
		commit;
		
		--spatial records
		if b_process_spatial = true then
			i:=0;
			for r_row in c_spatial_audit(d_latest_date) loop
				r_report.EXTEND(1);
				
				i := r_report.count();
				
				select xaa_leng_change_seq.nextval into n_temp_seq from dual; 
				r_report(i).CHANGE_ID 					:=  n_temp_seq;
				r_report(i).REPORT_RUN_DATE				:= d_time_ran;
				r_report(i).CHANGE_DATE 				:= r_row.op_date;
				r_report(i).EFFECTIVE_DATE				:= r_row.eff_date;
				r_report(i).DATUM_ID 					:= null;
				r_report(i).DATUM_UNIQUE 				:= null;
				r_report(i).DATUM_LENGTH				:= SDO_LRS.MEASURE_RANGE(r_row.geoloc)  ;
				r_report(i).DATUM_TYPE 					:= 'GROUP';
				r_report(i).OPERATION 					:= 'GEOMETRY - ' || r_row.operation;
				r_report(i).OLD_BEGIN_MEASURE			:= null;
				r_report(i).OLD_END_MEASURE				:= null;
				r_report(i).NEW_BEGIN_MEASURE 			:= null;
				r_report(i).NEW_END_MEASURE				:= null;
				r_report(i).CHANGE_START_MEASURE		:= null;
				r_report(i).CHANGE_END_MEASURE			:= null;
				r_report(i).MILEAGE_CHANGE				:= null;
				r_report(i).ROUTE_ID 					:= r_row.route_id;
				r_report(i).ROUTE_UNIQUE 				:= get_ne_unique(r_row.route_id);
				r_report(i).ROUTE_NAME					:= get_ne_descr(r_row.route_id);	
				
				
				if i >= 98 then  -- see if r_report is getting to big
					flush_array;					
				end if;
			end loop;
			flush_array;
		end if;
		
		commit;
		
	/*	exception when others then
			err_num := SQLCODE;
			err_msg := SUBSTR(SQLERRM, 1, 200);
			x_log_table.log_item(s_module, 'Generating', 'Unhandled Error', err_num || ' - ' || err_msg);
			RAISE;
	*/
	
	end generate_report_info;

end xky_hig_to_aa;



/*
							r_output.historic_date 		:= r_input.historic_date;
							r_output.loc_ident 			:= r_input.loc_ident;
							r_output.route_name			:= r_input.route_name;
							r_output.offset_from		:= r_input.offset_from;
							r_output.offset_to			:= r_input.offset_to;
							r_output.source_table		:= r_input.source_table;
							r_output.new_route_name		:= r_input.new_route_name;
							r_output.new_offset_from	:= r_input.new_offset_from;
							r_output.new_offset_to		:= r_input.new_offset_to;
							r_output.process_msg		:= r_input.process_msg;
*/
/