create or replace procedure xodot_fill_sgns(s_ea_input  varchar2) as
	
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: xodot_fill_sgns
	Author: JMM
	UPDATE01:	Original, 2015.03.00, JMM
	UPDATE02:	Changed d_start_date 	date 		:= trunc(sysdate);
*/
	cursor c_missing_snea is select * from nm_elements where ne_nt_type = 'SEEA' and ne_unique not in (select ne_unique from nm_elements where ne_nt_type = 'SNEA');
	
	cursor c_seea_no_snea(s_ea_num varchar2) is
		select a.* from nm_members a, nm_elements b 
			where a.nm_obj_type = 'SEEA' 
			and b.ne_id = a.nm_ne_id_in
			and ne_unique like s_ea_num
			and a.nm_ne_id_of not in (select b.nm_ne_id_of from  nm_members b where 1=1 and b.nm_obj_type = 'SNEA');
			
		cursor c_scns_no_sgns(s_ea_num varchar2) is
			select * from nm_members .
				where 1=1
				--for the EA we are currently on 
				and nm_ne_id_in in (
					select iit_ne_id from nm_inv_items where iit_inv_type = 'SCNS'
					and iit_itemcode like s_ea_num
					)
				-- Not the places that all ready exist 
								and nm_ne_id_of not in (select nm_ne_id_of from nm_members where nm_obj_type = 'SGNS' 
										and nm_ne_id_in in  (select iit_ne_id from nm_inv_items where iit_inv_type = 'SGNS'
																	and iit_itemcode like s_ea_num));
				
			/*	
		cursor c_scns_no_sgns(s_ea_num varchar2) is
			select mem_hwy.nm_slk + mem_inv.nm_begin_mp s_slk, (mem_hwy.nm_slk + mem_inv.nm_begin_mp) + (mem_inv.nm_end_mp - mem_inv.nm_begin_mp) e_slk, mem_inv.*
				from nm_members mem_inv, nm_members mem_hwy
				where 1=1
				--for the EA we are currently on 
				and nm_ne_id_in in (
					select iit_ne_id from nm_inv_items where iit_inv_type = 'SCNS'
					and iit_itemcode like s_ea_num
					)
				-- Not the places that all ready exist 
				and nm_ne_id_of not in (select nm_ne_id_of from nm_members where nm_obj_type = 'SGNS' 
										and nm_ne_id_in not in (select iit_ne_id from nm_inv_items where iit_inv_type = 'SGNS'
																	and iit_itemcode like s_ea_num));
				*/
				
		cursor c_distinct_scns_no_sgns(s_ea_num varchar2) is
			select distinct b.iit_itemcode from nm_members, nm_inv_items b 
				where 1=1
				and 	b.iit_ne_id = nm_ne_id_in
				--for the EA we are currently on 
				and nm_ne_id_in in (
					select iit_ne_id from nm_inv_items where iit_inv_type = 'SCNS'
					and iit_itemcode like s_ea_num
					)
				-- Not the places that all ready exist 
				and nm_ne_id_of not in (select nm_ne_id_of from nm_members where nm_obj_type = 'SGNS');
		
	cursor  c_seea_district(s_dist_number varchar2) is
		 select 
				dist.ne_unique dist_unique, dist.ne_descr dest_desc,
				mem_seea.nm_ne_id_in seea_ne_id_in, mem_seea.nm_ne_id_of seea_ne_id_of,
				ele_seea.ne_unique ea_num
			 from 
				nm_elements dist
				, nm_members mem_dist
				, nm_members mem_secw
				, nm_members mem_seea
				, nm_elements ele_seea
			where 1=1
			--
			and dist.ne_nt_type = 'DIST'
			and dist.ne_type = 'P'
			--
			and mem_dist.nm_ne_id_in = dist.ne_id
			--
			and mem_secw.nm_ne_id_in = mem_dist.nm_ne_id_of
			and mem_seea.nm_ne_id_in = mem_secw.nm_ne_id_of
			and ele_seea.ne_id = mem_seea.nm_ne_id_in
			and dist.ne_unique like s_dist_number;
	
	
	
	d_start_date 	date 		:= trunc(sysdate);
	n_admin_unit 	number 		:= 9;
	s_sgns_desc 	varchar2(50)	:= upper('AUTO POPULATED BY XODOT_FILL_SGNS');
	
	r_elements 	nm_elements_all%rowtype;
	r_members	nm_members_all%rowtype;
	
	s_testing_ea varchar2(8) := s_ea_input;  --Limiter
	
	n_snea number;
	
	n_ne_id_temp number;
	
	t_placement nm_placement := nm_placement(0,0,0,0);
	a_placement_array nm_placement_array;
	
	function get_snea_ne_id(n_ea number) return number is
		n_count number;
		n_snea number;
		begin
			select count(*) into n_count from nm_elements where ne_nt_type = 'SNEA' and ne_unique = (select ne_unique from nm_elements where ne_id = n_ea);
			
			if n_count = 1 then
				select ne_id  into n_snea from nm_elements where ne_nt_type = 'SNEA' and ne_unique = (select ne_unique from nm_elements where ne_id = n_ea);
			else
				n_snea := -1;
			end if;
			
			return n_snea;
	end get_snea_ne_id;
	
	begin
		
		-- Lets insert the missing member information for snea
		for r_row in c_missing_snea loop		
			r_elements := r_row;
		
				r_elements.ne_id := null;
				r_elements.ne_nt_type := 'SNEA';
				r_elements.ne_gty_group_type := 'SNEA';
				nm3ins.ins_ne(r_elements);	
			
		end loop;
		
		
		-- for testing doing ea: M0184416
		-- Lets add missing segments to SNEA in Members
		for r_row in c_seea_no_snea(s_testing_ea) loop 		
			r_members := r_row;
			n_snea := get_snea_ne_id(r_elements.ne_id);
			if n_snea <> -1 then 
				r_members.nm_ne_id_in :=n_snea;
				r_members.nm_obj_type := 'SNEA';
				r_members.nm_start_date := d_start_date;
				r_members.nm_date_created := sysdate;
				r_members.nm_date_modified := sysdate;
				r_members.nm_created_by := user;
				r_members.nm_modified_by := user;
				
				NM3INS.INS_NM_ALL(r_members);
			end if;			
		end loop;
		
		-- Lets fill the group now
		--idea is for each SNEA, we see if the seea datum was located, else place it on a snea.
		
		for r_row in c_distinct_scns_no_sgns(s_testing_ea) loop
			-- for these items well create a new SGNS assets for the EA and attach all missing datum
			
			a_placement_array := null;
			a_placement_array := nm3pla.initialise_placement_array;
			
			for y_row in c_scns_no_sgns(r_row.iit_itemcode) loop
				-- lets build a placement array and then create a new object
				t_placement.pl_ne_id 			:= y_row.nm_ne_id_of;
				t_placement.pl_start			:= y_row.nm_begin_mp;
				t_placement.pl_end				:= y_row.nm_end_mp;
				
				a_placement_array := a_placement_array.add_element(
				--pl_ne_id 			=> y_row.nm_ne_id_of
				--,pl_start			=> y_row.nm_begin_mp	
				--,pl_end				=> y_row.nm_end_mp 	
				--,pl_measure 		=> 0
				pl_pl =>t_placement
				,pl_mrg_mem			=> true
				);
			end loop;
				
			-- lets make and place
			nm3api_inv_sgns.ins (					
				p_iit_ne_id							=> n_ne_id_temp
				,p_effective_date				=> d_start_date
				,p_admin_unit					=> n_admin_unit
				,p_descr 						=> s_sgns_desc
				,p_note							=> null
				-- <FLEXIBLE ATTRIBUTES>
				,pf_hwy_ea_no 					=> r_row.iit_itemcode
				,pf_mjr_sign_cnt				=> 0
				,pf_mnr_sign_cnt				=> 0
				-- </FLEXIBLE ATTRIBUTES>
				-- <LOCATION DETAILS>
				,p_pl_arr 						=> a_placement_array
				-- </LOCATION DETAILS>
				);
			
		end loop;
		
		
		
		commit;
end xodot_fill_sgns;