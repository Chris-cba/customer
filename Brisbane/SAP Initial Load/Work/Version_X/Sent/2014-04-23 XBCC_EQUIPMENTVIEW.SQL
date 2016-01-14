--RDCO

create or replace view XBEX_EQUIP_RDCO as
select 
ne_id NETWORK_PRIMARY_ID,
street_name STREET_NAME,
corridor_code STREET_CORRIDOR_ID,
SYSDATE EXTRACT_DATE,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_rdco_rdco_sdo_dt a
order by street_name, corridor_code
;

--Median equipment view.

create or replace view XBEX_EQUIP_MED as
select 
9000000000 + ne_id NETWORK_PRIMARY_ID,
street_name STREET_NAME,
corridor_code STREET_CORRIDOR_ID,
SYSDATE EXTRACT_DATE,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_rdco_rdco_sdo_dt a
order by street_name, corridor_code
;




--VECO

create or replace view XBEX_EQUIP_VECO as
select 
ne_id NETWORK_PRIMARY_ID,
street_name STREET_NAME,
side_of_street side,
corridor_code STREET_CORRIDOR_ID,
SYSDATE EXTRACT_DATE,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_VECO_VECO_sdo_dt a
order by street_name, corridor_code
;


--KCOR


create or replace view XBEX_EQUIP_KCOR as
select 
ne_id NETWORK_PRIMARY_ID,
street_name STREET_NAME,
side_or_street side,
corridor_code STREET_CORRIDOR_ID,
SYSDATE EXTRACT_DATE,
(select nvl(max(nm_end_slk),0) -nvl(min(nm_slk),0)  from nm_members b where b.nm_ne_id_in = a.ne_id) LENGTH,
geoloc GIS_SHAPE
from 
v_nm_nlt_KCOR_KCOR_sdo_dt a
order by street_name, corridor_code
;