create or replace procedure xky_surf_au_update as
	s_module		varchar(50):= upper('update_Surf_AU');
	s_log_area 		varchar(50);
	s_log_base_info	varchar(50);
	s_log_text 		varchar(50);
	n_new_admin		varchar(10);
	cursor c_au_to_Update is select distinct iit_chr_attrib27 from nm_inv_items where iit_inv_type= 'SURF' and iit_admin_unit = 160 order by 1;  --160 = state so I assume the item was changed then
begin

		x_log_table.clean(s_module);  -- remove existing log file entries
		s_log_area := 'Updating AU';  -- log area

    
	for r_row in c_au_to_update loop

		n_new_admin := xky_surf_au(r_row.iit_chr_attrib27);
		
		s_log_base_info := 'Change AU from' || ', ' || r_row.iit_chr_attrib27 || ' to  ' || n_new_admin;
		s_log_text := r_row.iit_chr_attrib27;
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );
    
    nm3inv.bypass_inv_items_all_trgs(true);
	update nm_inv_items a
	set iit_admin_unit =  n_new_admin
	where iit_inv_type= 'SURF'
	and n_new_admin is not null
	and iit_chr_attrib27 = r_row.iit_chr_attrib27 
	and iit_admin_unit <> n_new_admin  -- in case the item was already changed
	;

	commit;
  nm3inv.bypass_inv_items_all_trgs(false);
	end loop;
	
end xky_surf_au_update;