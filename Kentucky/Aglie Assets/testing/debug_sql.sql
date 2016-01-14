exec nm3user.set_effective_date('01-JAN-1950');

select 
nm3net.get_ne_unique(nm_ne_id_in)
,nm_ne_id_in
,nm_ne_id_of
,nm_slk
,nm_end_slk
,nm_start_date
,nm_end_date
,nm_obj_type
from nm_members 
where nm_obj_type = 'RT'
and nm_ne_id_in = nm3net.get_ne_id(:neu)
order by nm_slk
;


select * from nm_element_history
where neh_ne_id_old = 
;

exec nm3user.set_effective_date(sysdate);

select 
nm3net.get_ne_unique(nm_ne_id_in)
,nm_ne_id_in
,a.nm_ne_id_of
,nm_slk
,nm_end_slk
,a.nm_start_date
,nm_end_date
,nm_obj_type
from nm_members_all a
,(select nm_ne_id_of,max(nm_start_date) nm_start_date from nm_members_all where nm_obj_type = 'RT' group by nm_ne_id_of) b
where nm_obj_type = 'RT'
and a.nm_ne_id_of = b.nm_ne_id_of
and a.nm_start_date = b.nm_start_date
and a.nm_ne_id_of in (8457631,8457632,4941952)
--order by nm_ne_id_in, nm_slk
;