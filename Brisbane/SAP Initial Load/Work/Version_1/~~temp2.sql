declare
	item_cursor sys_refcursor;
	geo_cursor sys_refcursor;
	s_sql varchar2(2000) := 'select rowid,mem_nm_ne_id_in,iit_ne_id,start_ch,end_ch from z_joe_test';
	s_sql_geo varchar2(2000);
	s_sql_update varchar2(2000);
	n_mem_nm_ne_id_in number;
	n_itt_ne_id number;
	n_SC number;
	n_EC number;
	s_rowid varchar2(300);
	geo_geoloc sdo_geometry;
--
begin
	open item_cursor for s_sql;
	loop
		fetch item_cursor into s_rowid,n_mem_nm_ne_id_in, n_itt_ne_id, n_SC, n_EC;
		exit when item_cursor%notfound;
		--
		s_sql_geo := 'select geoloc from v_nm_nlt_rdco_rdco_sdo_dt where ne_id = '|| n_mem_nm_ne_id_in;
		--
		open geo_cursor for s_sql_geo;		
			fetch geo_cursor into geo_geoloc;
			insert into z_rowid_test values(s_rowid,null);
			commit;
			geo_geoloc := SDO_LRS.CLIP_GEOM_SEGMENT(geo_geoloc, n_sc, n_ec);
			--update z_joe_test set geoloc = geo_geoloc where rowid = s_rowid;
			insert into z_rowid_test values(s_rowid,geo_geoloc);
			commit;
		close geo_cursor;
	end loop;
	close item_cursor;
end;