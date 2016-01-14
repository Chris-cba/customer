create or replace trigger xkytc_intersec_id_bd 
after insert or update 
on nm_elements_all 
for each row
when (new.ne_type = 'S')


declare


	procedure process_node (n_node number, n_start_end varchar2) is
		cursor c_node_ne_id(n_node number) is select nnu_ne_id ne_id from nm_node_usages where nnu_no_node_id = n_node;
		
		n_temp number;
		n_node_mp_s number;
		n_node_mp_e number;
		n_intersect_ID number;
		n_iit_id number ;
		s_intersection_type varchar2(1);		
		n_asset_distance number := 0.01;  --no longer needed, can vary as the length of the asset now counts as the approach
		s_obj_type varchar2(4) := 'APRC';
		s_default_intersection_type varchar2(1) := 'Z';
		
		b_asset_found boolean := false;
		
		p_invrow nm_inv_items_all%rowtype;
		p_memrow nm_members%rowtype;
		
		
		
		
		begin
			
			
			select count(*) into n_temp from nm_node_usages where nnu_no_node_id = n_node;
			
			if n_temp = 0 then
				-- not an intersection
				null;
			else
				b_asset_found := false;
					for r_row in c_node_ne_id(n_node) loop
						if b_asset_found = false then  -- no reason to continue if we find one.
							-- check to see if the asset exists on the other datum
							if n_start_end  = 'S' then 
								n_node_mp_s := 0;
								n_node_mp_e := n_asset_distance;  -- not used atm
								
								select count(*) into n_temp from nm_members where nm_ne_id_of = r_row.ne_id and nm_obj_type = s_obj_type and (nm_begin_mp = n_node_mp_s);
								if n_temp = 0 then
									null; -- do nothing and move on;
								elsif n_temp =1 then
									-- get the intersection ID and intersection type then make the new asset.
									select nm_ne_id_in into n_temp from nm_members where nm_ne_id_of = r_row.ne_id and nm_obj_type = s_obj_type and (nm_begin_mp = n_node_mp_s);
									select iit_num_attrib16, iit_chr_attrib26 into  n_intersect_ID, s_intersection_type from  nm_inv_items where iit_inv_type = 'APRC'  and iit_ne_id = n_temp;
									b_asset_found := true;
								else
									--too many --should I exit?
									null;
									
									
								end if;
							elsif n_start_end = 'E' then 
								select ne_length into n_node_mp_e from nm_elements where ne_id = r_row.ne_id;
								n_node_mp_s := n_node_mp_e - n_asset_distance; -- not used atm
								n_node_mp_e := :new.ne_length;
								select count(*) into n_temp from nm_members where nm_ne_id_of = r_row.ne_id and nm_obj_type = s_obj_type and (nm_end_mp = n_node_mp_e);
								if n_temp = 0 then
										null; -- do nothing and move on;
									elsif n_temp =1 then
										-- get the intersection ID and intersection type then make the new asset.
										select nm_ne_id_in into n_temp from nm_members where nm_ne_id_of = r_row.ne_id and nm_obj_type = s_obj_type and (nm_end_mp = n_node_mp_e);
										select iit_num_attrib16, iit_chr_attrib26 into  n_intersect_ID, s_intersection_type from  nm_inv_items where iit_inv_type = 'APRC'  and iit_ne_id = n_temp;
										b_asset_found := true;
									else
										--too many --should I exit?
										null;
										
										
								end if;
								
							else -- wrong input
								n_node_mp_s := -100;					
								n_node_mp_e := -100.01;					
							end if;
						end if;
					end loop;
				
				if b_asset_found = false then
					-- new asset needed.
					n_intersect_ID := x_aprc_interection_id.nextval;
				end if;
				
					n_iit_id := NM3SEQ.NEXT_NE_ID_SEQ;
					
						p_invrow.iit_NE_ID := n_iit_id;
						p_invrow.iit_PRIMARY_KEY := n_iit_id;
						p_invrow.iit_inv_type := s_obj_type ;
						p_invrow.iit_start_date := '1-JAN-1950';
						p_invrow.iit_date_created := trunc(sysdate);
						p_invrow.iit_descr :=  'AutoCreated APRC for new intersection';
						p_invrow.iit_chr_attrib26 := s_default_intersection_type;
						p_invrow.iit_chr_attrib27 := n_intersect_ID;
						p_invrow.iit_admin_unit:= 160;
						nm3inv.insert_nm_inv_items(p_invrow);
						
						-- now to attach it to the asset.
						
						p_memrow.nm_ne_id_in := n_iit_id;
						p_memrow.nm_ne_id_of := :new.ne_id;
						p_memrow.nm_type := 'I';
						p_memrow.nm_obj_type := s_obj_type;
						p_memrow.nm_begin_mp := n_node_mp_s;
						p_memrow.nm_end_mp := n_node_mp_e;
						p_memrow.nm_cardinality := 1;
						p_memrow.nm_admin_unit := :new.ne_admin_unit;
						p_memrow.nm_seq_no :=1;
						
						nm3ins.ins_nm(p_memrow);
					
					
			
					
					
				
				
			end if;
			

			
			

			If inserting then
					-- check to see if I need remove an old asset
					null;
			end if;

			
		end process_node;
	begin
		process_node(:new.ne_no_start, 'S');
		process_node(:new.ne_no_end, 'E');
	end xkytc_intersec_id_bd;