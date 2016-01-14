create or replace  view z_length_change_test as
select
    change_id
    ,report_run_date
    ,change_date
    , effective_date
    ,(select ne_unique from nm_elements where ne_id = nm_ne_id_in) old_reclassed_route
    , nm_slk old_reclassed_start_measure
    , nm_end_slk old_reclassed_end_measure
    , datum_id Current_datum_id
    , datum_unique current_datum_unique
    , datum_length
    , datum_type
    , operation
    , old_begin_measure
    , old_end_measure
    , new_begin_measure
    , new_end_measure
    , change_start_measure
    , change_end_measure
    , mileage_change    
from(
    select z.*, y.* from 
    (select neh_ne_id_old, a.*  from xaa_length_change a, nm_element_history b 
    where neh_ne_id_new(+) = datum_id
    and neh_actioned_date(+) = trunc(effective_date)
    ) z
    , (select * from nm_members_all c where 1=1 and c.nm_obj_type = 'RT') y
    where    1=1
    and z.neh_ne_id_old = y.nm_ne_id_of(+) 
    and trunc(effective_date) = trunc(y.nm_date_created(+))
    ) a
    where 1= 1
    and  operation <> 'ADDED RECLASSIFY'
	and operation not like 'GEOMETRY%'
    order by change_date, change_id
;