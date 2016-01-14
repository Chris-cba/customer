update xaa_net_ref a
set new_date = (select max(nm_start_date) from nm_members 
              where 1=1
              AND nm_ne_id_in = nm3net.get_ne_id(a.new_route_name)
              and nm_slk >= a.new_offset_from
              and nm_end_slk <= a.new_offset_to)
where 1=1
and new_route_name is not null;


COMMIT;