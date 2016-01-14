--xaa_route_temp_sql

create global temporary table xaa_route_temp_sql(
cur_user varchar(40),
cur_proc varchar(40),
ne_id_of number(10),
 ne_id_in number(10), 
 slk number(10,3), 
 end_slk number(10,3), 
 op varchar2(4)
 );
 
 
 --create index xaa_route_temp_slk_idx on xaa_route_temp_sql(slk);
 --create index xaa_route_temp_end_slk_idx on xaa_route_temp_sql(end_slk);