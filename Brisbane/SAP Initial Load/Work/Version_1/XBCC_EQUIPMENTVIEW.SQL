--RDCO

create or replace view XBCC_EQUIP_RDCO as
select 
ne_id STREET_PRIMARY_ID,
street_name STREET_NAME,
corridor_code STREET_CORRIDOR_ID,
--SDO_LRS.MEASURE_RANGE(geoloc)  LENGTH,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_rdco_rdco_sdo_dt a
;

--Median equipment view.

create or replace view XBCC_EQUIP_MED as
select 
999 || ne_id STREET_PRIMARY_ID,
street_name STREET_NAME,
corridor_code STREET_CORRIDOR_ID,
--SDO_LRS.MEASURE_RANGE(geoloc)  LENGTH,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_rdco_rdco_sdo_dt a
;




--VECO

create or replace view XBCC_EQUIP_VECO as
select 
ne_id STREET_PRIMARY_ID,
street_name STREET_NAME,
side_of_street side,
corridor_code STREET_CORRIDOR_ID,
--SDO_LRS.MEASURE_RANGE(geoloc)  LENGTH,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) mLENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_VECO_VECO_sdo_dt a
;


--KCOR


create or replace view XBCC_EQUIP_KCOR as
select 
ne_id STREET_PRIMARY_ID,
street_name STREET_NAME,
side_or_street side,
corridor_code STREET_CORRIDOR_ID,
--SDO_LRS.MEASURE_RANGE(geoloc)  LENGTH,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_KCOR_KCOR_sdo_dt a
;