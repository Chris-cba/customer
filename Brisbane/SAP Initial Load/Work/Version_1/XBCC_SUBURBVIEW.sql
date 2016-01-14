create or replace view XBCC_SUBURB_EQUIP_RDCO as
select a.*
,
case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end geoloc
 from 
(
select 
ne_id STREET_PRIMARY_ID,
sub.ne_name_2 SUBURB_NAME,
nvl(min(mem.nm_slk),0) start_ch, 
nvl(max(mem.nm_end_slk),0) end_ch,
corridor_code STREET_CORRIDOR_ID,
street_name STREET_NAME
from 
v_nm_nlt_rdco_rdco_sdo_dt a
 ,nm_members mem
 , (select ne_descr,ne_name_1,ne_name_2,nm_ne_id_in, nm_ne_id_of 
        from nm_members, nm_elements       
        where 1=1        and nm_obj_type in ('STSB')       
        and nm_ne_id_in = ne_id) sub
where 
a.ne_id = mem.nm_ne_id_in
and mem.nm_ne_id_of =  sub.nm_ne_id_of
group by ne_id, street_name, corridor_code, sub.ne_name_2
) a, v_nm_nlt_rdco_rdco_sdo_dt b
where b.ne_id  = a.STREET_PRIMARY_ID


create view XBCC_SUBURB_EQUIP_MED as
select a.*
,
case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end geoloc
 from 
(
select 
999 || ne_id STREET_PRIMARY_ID,
sub.ne_name_2 SUBURB_NAME,
nvl(min(mem.nm_slk),0) start_ch, 
nvl(max(mem.nm_end_slk),0) end_ch,
corridor_code STREET_CORRIDOR_ID,
street_name STREET_NAME
from 
v_nm_nlt_rdco_rdco_sdo_dt a
 ,nm_members mem
 , (select ne_descr,ne_name_1,ne_name_2,nm_ne_id_in, nm_ne_id_of 
        from nm_members, nm_elements       
        where 1=1        and nm_obj_type in ('STSB')       
        and nm_ne_id_in = ne_id) sub
where 
a.ne_id = mem.nm_ne_id_in
and mem.nm_ne_id_of =  sub.nm_ne_id_of
group by ne_id, street_name, corridor_code, sub.ne_name_2
) a, v_nm_nlt_rdco_rdco_sdo_dt b
where 999 || b.ne_id  = a.STREET_PRIMARY_ID


create or replace view XBCC_SUBURB_EQUIP_VECO as
select a.*
,
case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end geoloc
 from 
(
select 
ne_id STREET_PRIMARY_ID,
sub.ne_name_2 SUBURB_NAME,
nvl(min(mem.nm_slk),0) start_ch, 
nvl(max(mem.nm_end_slk),0) end_ch,
corridor_code STREET_CORRIDOR_ID,
street_name STREET_NAME
from 
v_nm_nlt_VECO_VECO_sdo_dt a
 ,nm_members mem
 , (select ne_descr,ne_name_1,ne_name_2,nm_ne_id_in, nm_ne_id_of 
        from nm_members, nm_elements       
        where 1=1        and nm_obj_type in ('VESB')       
        and nm_ne_id_in = ne_id) sub
where 
a.ne_id = mem.nm_ne_id_in
and mem.nm_ne_id_of =  sub.nm_ne_id_of
group by ne_id, street_name, corridor_code, sub.ne_name_2
) a, v_nm_nlt_VECO_VECO_sdo_dt b
where b.ne_id  = a.STREET_PRIMARY_ID


create or replace view XBCC_SUBURB_EQUIP_KCOR as
select a.*
,
case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end geoloc
 from 
(
select 
ne_id STREET_PRIMARY_ID,
sub.ne_name_2 SUBURB_NAME,
nvl(min(mem.nm_slk),0) start_ch, 
nvl(max(mem.nm_end_slk),0) end_ch,
corridor_code STREET_CORRIDOR_ID,
street_name STREET_NAME
from 
v_nm_nlt_KCOR_KCOR_sdo_dt a
 ,nm_members mem
 , (select ne_descr,ne_name_1,ne_name_2,nm_ne_id_in, nm_ne_id_of 
        from nm_members, nm_elements       
        where 1=1        and nm_obj_type in ('KSUB')       
        and nm_ne_id_in = ne_id) sub
where 
a.ne_id = mem.nm_ne_id_in
and mem.nm_ne_id_of =  sub.nm_ne_id_of
group by ne_id, street_name, corridor_code, sub.ne_name_2
) a, v_nm_nlt_KCOR_KCOR_sdo_dt b
where b.ne_id  = a.STREET_PRIMARY_ID