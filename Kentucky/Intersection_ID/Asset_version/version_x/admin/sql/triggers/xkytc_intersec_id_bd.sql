create or replace trigger xkytc_intersec_id_bd 
for insert or update 
on nm_elements_all 
when (new.ne_type = 'S')

COMPOUND TRIGGER

	type t_ne_rec is table of nm_elements_all%rowtype index by simple_integer;
    ne_rec t_ne_rec;
	i integer := 0 ;
before each row is
begin
	i := i+1;
	ne_rec(i).NE_ID				:=	:new.NE_ID;
	--ne_rec(i).NE_UNIQUE			:=	:new.NE_UNIQUE;
	--ne_rec(i).NE_TYPE			:=	:new.NE_TYPE;
	--ne_rec(i).NE_NT_TYPE		:=	:new.NE_NT_TYPE;
	--ne_rec(i).NE_DESCR			:=	:new.NE_DESCR;
	ne_rec(i).NE_LENGTH			:=	:new.NE_LENGTH;
	ne_rec(i).NE_ADMIN_UNIT		:=	:new.NE_ADMIN_UNIT;
	--ne_rec(i).NE_DATE_CREATED	:=	:new.NE_DATE_CREATED;
	--ne_rec(i).NE_DATE_MODIFIED	:=	:new.NE_DATE_MODIFIED;
	--ne_rec(i).NE_MODIFIED_BY	:=	:new.NE_MODIFIED_BY;
	--ne_rec(i).NE_CREATED_BY		:=	:new.NE_CREATED_BY;
	ne_rec(i).NE_START_DATE		:=	:new.NE_START_DATE;
	--ne_rec(i).NE_NAME_1			:=	:new.NE_NAME_1;
	--ne_rec(i).NE_NAME_2			:=	:new.NE_NAME_2;
	--ne_rec(i).NE_PREFIX			:=	:new.NE_PREFIX;
	--ne_rec(i).NE_NUMBER			:=	:new.NE_NUMBER;
	--ne_rec(i).NE_SUB_TYPE		:=	:new.NE_SUB_TYPE;
	--ne_rec(i).NE_GROUP			:=	:new.NE_GROUP;
	ne_rec(i).NE_NO_START		:=	:new.NE_NO_START;
	ne_rec(i).NE_NO_END			:=	:new.NE_NO_END;
	--ne_rec(i).NE_SUB_CLASS		:=	:new.NE_SUB_CLASS;
end before each row;



After statement is



	procedure process_node (j number, n_node number, n_start_end varchar2) is
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
									--select ne_length into n_node_mp_e from nm_elements where ne_id = r_row.ne_id;
									n_node_mp_s := n_node_mp_e - n_asset_distance; -- not used atm
									n_node_mp_e := ne_rec(j).ne_length;
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
							p_invrow.iit_start_date := ne_rec(j).NE_START_DATE;
							p_invrow.iit_date_created := trunc(sysdate);
							p_invrow.iit_descr :=  'AutoCreated APRC for new intersection';
							p_invrow.iit_chr_attrib26 := s_default_intersection_type;
							p_invrow.iit_chr_attrib27 := n_intersect_ID;
							p_invrow.iit_admin_unit:= 160;
							nm3inv.insert_nm_inv_items(p_invrow);
							
							-- now to attach it to the asset.
							
							p_memrow.nm_ne_id_in := n_iit_id;
							p_memrow.nm_ne_id_of := ne_rec(j).ne_id;
							p_memrow.nm_type := 'I';
							p_memrow.nm_start_date := ne_rec(j).NE_START_DATE;
							p_memrow.nm_obj_type := s_obj_type;
							p_memrow.nm_begin_mp := n_node_mp_s;
							p_memrow.nm_end_mp := n_node_mp_e;
							p_memrow.nm_cardinality := 1;
							p_memrow.nm_admin_unit := ne_rec(j).ne_admin_unit;
							p_memrow.nm_seq_no :=1;
							
							nm3ins.ins_nm(p_memrow);
												
				end if;
		

			
			

			If inserting then
					-- check to see if I need remove an old asset
					null;
			end if;

			
		end process_node;
	begin
		for j in 1..ne_rec.count loop
			process_node(j,ne_rec(j).ne_no_start, 'S');
			process_node(j,ne_rec(j).ne_no_end, 'E');
		end loop;	
	end after statement;
	end xkytc_intersec_id_bd;