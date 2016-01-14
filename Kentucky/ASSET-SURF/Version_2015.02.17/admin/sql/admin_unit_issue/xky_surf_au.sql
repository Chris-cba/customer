create or replace function xky_surf_au(s_hwy_au varchar2) return varchar2 as
	s_temp varchar2(8) := null;
	n_count number :=0;
begin
	
	select count(*) into n_count from nm_admin_units where nau_admin_type = 'INV' and nau_name = (select nau_name from nm_admin_units where nau_admin_unit =s_hwy_au and nau_admin_type = 'HWY');
	if n_count = 1 then
		select nau_admin_unit into s_temp from nm_admin_units where nau_admin_type = 'INV' and nau_name = (select nau_name from nm_admin_units where nau_admin_unit =s_hwy_au and nau_admin_type = 'HWY');
	end if;
	
	return s_temp;
end;
/
