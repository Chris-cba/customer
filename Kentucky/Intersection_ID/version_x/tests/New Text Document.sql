create or replace view z_node_exe_test as
select no_node_id,NO_PURPOSE, npl_id, no_np_id, no_node_name, no_descr, npl_location node_geom 
from nm_point_locations, nm_nodes where no_np_id = npl_id;

Create or replace procedure z_node_purpose_test(GIS_SESSION_ID in number) is
	cursor c_selected_node_id (n_session number) is select gdo_pk_id from gis_data_objects  where gdo_session_id = n_session;
	
	s_value varchar2(128) := 'SELECTED: ';
	begin
		for r_row in c_selected_node_id(GIS_SESSION_ID) loop
			s_value := s_value || r_row.gdo_pk_id || ' ';
		end loop;
		
		for r_row in c_selected_node_id(GIS_SESSION_ID) loop
			update nm_nodes_all set no_purpose = s_value where no_np_id = r_row.gdo_pk_id;			
		end loop;
		
		commit;
	end z_node_purpose_test;

	
insert into hig_modules
(hmo_module, hmo_title, hmo_filename, hmo_module_type,
 hmo_fastpath_opts, hmo_fastpath_invalid, hmo_use_gri,
 hmo_application, hmo_menu )
values
( 'ZNODETST', 'Node purpose Test', 'Z_NODE_PURPOSE_TEST', 'PLS',
  null, 'Y', 'N', 
  'AST', null ); 

insert into hig_module_roles
(hmr_module, hmr_role, hmr_mode )
values ('ZNODETST', 'NET_ADMIN', 'NORMAL' );
commit;
