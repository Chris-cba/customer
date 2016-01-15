create or replace view xodot_gasb34 as
select
  hwy.ne_unique hwy_unique
, NE_OWNER Highway_Number
, NE_SUB_TYPE suffix
, NE_PREFIX Roadway_ID
, NE_NAME_1 Mileage_Type
, NE_NAME_2 Overlap_Mileage_Code
, NE_NUMBER Road_Direction
, NE_GROUP road_type
, p.trans_unique 
, nvl(PREVIOUS_INCR_MILEAGE ,0) PREVIOUS_INCR_MILEAGE
, nvl(PREVIOUS_DECR_MILEAGE ,0) PREVIOUS_DECR_MILEAGE
, nvl(POST_INCR_MILEAGE,0) POST_INCR_MILEAGE
, nvl(POST_DECR_MILEAGE,0) POST_DECR_MILEAGE
, Official_Transfer_Date
, Official_Transfer_ID
, Official_Transfer_Type
, Agreement_Transfer_Comment
, Transfer_From
, Transfer_To
 from 
 nm_elements_all hwy,
(
select distinct ne_unique trans_unique 
,  h.nm_ne_id_in hwy_ne_id
, NE_NAME_2 Official_Transfer_Date
, NE_NSG_REF Official_Transfer_ID
, IIT_CHR_ATTRIB58 Agreement_Transfer_Comment
, IIT_CHR_ATTRIB28 Transfer_From
, NE_VERSION_NO Official_Transfer_Type
, NE_NAME_1 Transfer_To
 from 
  nm_elements_all
, nm_inv_items_all
, NM_NW_AD_LINK_ALL l
, nm_members_all t
   , nm_members_all h
where ne_nt_type = 'TRNF' 
and ne_name_2 is not null
and iit_inv_type = 'TRNF'
and L.NAD_IIT_NE_ID = iit_ne_id
and L.NAD_NE_ID = ne_id
and ne_name_2 is not null
and ne_id = t.nm_ne_id_in
and t.nm_ne_id_of = h.nm_ne_id_of
and h.nm_obj_type = 'HWY'
) p,
-- PREVIOUS_INCR_MILEAGE
(
select nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
t.hwy_ne_id,
 t.ne_unique trans_unique 
 , sum(rm.nm_end_mp - rm.nm_begin_mp ) PREVIOUS_INCR_MILEAGE from 
nm_members_all hh,
nm_members_all rm,
nm_inv_items_all ri,
(
    select 
    hm.nm_ne_id_in hwy_ne_id
    ,t.ne_unique
    , t.OFFICIAL_TRANSFER_DATE
    from 
    v_nm_trnf_trnf_nt t,
    nm_members_all tm,
    nm_members_all hm
    where 
    hm. nm_obj_type = 'HWY'
    and t.ne_id = tm.nm_ne_id_in
    and tm.nm_ne_id_of = hm.nm_ne_id_of
    and TM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (TM.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or TM.NM_END_DATE is null)
    and hM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (hM.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or hM.NM_END_DATE is null)
    group by hm.nm_ne_id_in,t.ne_unique, t.OFFICIAL_TRANSFER_DATE
) t
where hh.nm_obj_type = 'HWY'
and hh.nm_ne_id_in = t.hwy_ne_id
and rm.nm_obj_type = 'RDGM'
and hh.nm_ne_id_of = rm.nm_ne_id_of
and ri.iit_inv_type = 'RDGM'
and rm.nm_ne_id_in = ri.iit_ne_id
and ri.iit_x_sect like 'LN_I'
and RI.IIT_NO_OF_UNITS = 1
and hh.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (hh.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or hh.NM_END_DATE is null)
and rm.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (rm.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or rm.NM_END_DATE is null) 
group by hwy_ne_id, t.ne_unique
) a,
-- PREVIOUS_DECR_MILEAGE
(select nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
t.hwy_ne_id,
 t.ne_unique trans_unique 
 , sum(rm.nm_end_mp - rm.nm_begin_mp ) PREVIOUS_DECR_MILEAGE from 
nm_members_all hh,
nm_members_all rm,
nm_inv_items_all ri,
(select 
hm.nm_ne_id_in hwy_ne_id
,t.ne_unique
, t.OFFICIAL_TRANSFER_DATE
from 
v_nm_trnf_trnf_nt t,
nm_members_all tm,
nm_members_all hm
where 
hm. nm_obj_type = 'HWY'
and t.ne_id = tm.nm_ne_id_in
and tm.nm_ne_id_of = hm.nm_ne_id_of
and TM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (TM.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or TM.NM_END_DATE is null)
and hM.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (hM.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or hM.NM_END_DATE is null)
group by hm.nm_ne_id_in,t.ne_unique, t.OFFICIAL_TRANSFER_DATE) t
where hh.nm_obj_type = 'HWY'
and hh.nm_ne_id_in = t.hwy_ne_id
and rm.nm_obj_type = 'RDGM'
and hh.nm_ne_id_of = rm.nm_ne_id_of
and ri.iit_inv_type = 'RDGM'
and rm.nm_ne_id_in = ri.iit_ne_id
and ri.iit_x_sect like 'LN_D'
and RI.IIT_NO_OF_UNITS = 1
and hh.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (hh.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or hh.NM_END_DATE is null)
and rm.NM_START_DATE < t.OFFICIAL_TRANSFER_DATE and (rm.NM_END_DATE >= t.OFFICIAL_TRANSFER_DATE or rm.NM_END_DATE is null) 
group by hwy_ne_id, t.ne_unique) b,
-- POST_INCR_MILEAGE
( select nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
 t.hwy_ne_id,
 t.ne_unique trans_unique 
 , sum(rm.nm_end_mp - rm.nm_begin_mp ) POST_INCR_MILEAGE from 
nm_members_all hh,
nm_members_all rm,
nm_inv_items_all ri,
(select 
hm.nm_ne_id_in hwy_ne_id
,t.ne_unique
, t.OFFICIAL_TRANSFER_DATE
from 
v_nm_trnf_trnf_nt t,
nm_members_all tm,
nm_members_all hm
where 
hm. nm_obj_type = 'HWY'
and t.ne_id = tm.nm_ne_id_in
and tm.nm_ne_id_of = hm.nm_ne_id_of
and TM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (TM.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or TM.NM_END_DATE is null)
and hM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (hM.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or hM.NM_END_DATE is null)
group by hm.nm_ne_id_in,t.ne_unique, t.OFFICIAL_TRANSFER_DATE) t
where hh.nm_obj_type = 'HWY'
and hh.nm_ne_id_in = t.hwy_ne_id
and rm.nm_obj_type = 'RDGM'
and hh.nm_ne_id_of = rm.nm_ne_id_of
and ri.iit_inv_type = 'RDGM'
and rm.nm_ne_id_in = ri.iit_ne_id
and ri.iit_x_sect like 'LN_I'
and RI.IIT_NO_OF_UNITS = 1
and hh.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (hh.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or hh.NM_END_DATE is null)
and rm.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (rm.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or rm.NM_END_DATE is null) 
group by hwy_ne_id, t.ne_unique) c ,
-- POST_DECR_MILEAGE
( select nm3net.get_ne_unique(t.hwy_ne_id) hwy ,
t.hwy_ne_id,
 t.ne_unique trans_unique 
 , sum(rm.nm_end_mp - rm.nm_begin_mp ) POST_DECR_MILEAGE from 
nm_members_all hh,
nm_members_all rm,
nm_inv_items_all ri,
(select 
hm.nm_ne_id_in hwy_ne_id
,t.ne_unique
, t.OFFICIAL_TRANSFER_DATE
from 
v_nm_trnf_trnf_nt t,
nm_members_all tm,
nm_members_all hm
where 
hm. nm_obj_type = 'HWY'
and t.ne_id = tm.nm_ne_id_in
and tm.nm_ne_id_of = hm.nm_ne_id_of
and TM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (TM.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or TM.NM_END_DATE is null)
and hM.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (hM.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or hM.NM_END_DATE is null)
group by hm.nm_ne_id_in,t.ne_unique, t.OFFICIAL_TRANSFER_DATE) t
where hh.nm_obj_type = 'HWY'
and hh.nm_ne_id_in = t.hwy_ne_id
and rm.nm_obj_type = 'RDGM'
and hh.nm_ne_id_of = rm.nm_ne_id_of
and ri.iit_inv_type = 'RDGM'
and rm.nm_ne_id_in = ri.iit_ne_id
and ri.iit_x_sect like 'LN_D'
and RI.IIT_NO_OF_UNITS = 1
and hh.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (hh.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or hh.NM_END_DATE is null)
and rm.NM_START_DATE = t.OFFICIAL_TRANSFER_DATE and (rm.NM_END_DATE > t.OFFICIAL_TRANSFER_DATE or rm.NM_END_DATE is null) 
group by hwy_ne_id, t.ne_unique) d
where 
p.trans_unique  = a.trans_unique(+)
and p.trans_unique  = b.trans_unique(+)
and p.trans_unique  = c.trans_unique(+)
and p.trans_unique  = d.trans_unique(+)
and p.hwy_ne_id = a.hwy_ne_id(+)
and p.hwy_ne_id = b.hwy_ne_id(+)
and p.hwy_ne_id = c.hwy_ne_id(+)
and p.hwy_ne_id = d.hwy_ne_id(+)
and p.hwy_ne_id = hwy.ne_id
and hwy.ne_nt_type = 'HWY';
/

