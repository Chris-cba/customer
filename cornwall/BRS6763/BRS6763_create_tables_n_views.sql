-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--        pvcsid                 : $Header:   //vm_latest/archives/customer/cornwall/BRS6763/BRS6763_create_tables_n_views.sql-arc   1.0   Nov 15 2011 15:43:54   Ian.Turnbull  $
--       Module Name      : $Workfile:   BRS6763_create_tables_n_views.sql  $
--       Date into PVCS   : $Date:   Nov 15 2011 15:43:54  $
--       Date fetched Out : $Modtime:   Nov 15 2011 09:27:18  $
--       PVCS Version     : $Revision:   1.0  $
--       Author : Aileen Heal
--
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- Written by Aileen Heal as part of work package BRS 6763 for Cornwall Nov 2011
-- This script create a number of look up tables as views. The shape file Stworks2011.shp
-- supplied by Cornwall was loaded into the database using MapBuilder as table name
-- STWORKS2011 (SRID = 81989, geometry column GEOMETRY)
-----------------------------------------------------------------------------
create table X_BRS6764_E1 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'E1' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_E1 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_E1_UNI
as select unique NE_ID from X_BRS6764_E1
/

comment on table X_BRS6764_E1_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_E2 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'E2' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_E2 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_E2_UNI
as select unique NE_ID from X_BRS6764_E2
/

comment on table X_BRS6764_E2_UNI IS 'Created by Aileen Heal for BRS 6467';


create table X_BRS6764_E3 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'E3' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_E3 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_E3_UNI
as select unique NE_ID from X_BRS6764_E3
/

comment on table X_BRS6764_E3_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C1 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'C1' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_C1 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C1_UNI
as select unique NE_ID from X_BRS6764_C1
/

comment on table X_BRS6764_C1_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C2 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'C2' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_C2 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C2_UNI
as select unique NE_ID from X_BRS6764_C2
/

comment on table X_BRS6764_C2_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C3 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'C3' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE')
/ 

comment on table X_BRS6764_C3 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_C3_UNI
as select unique NE_ID from X_BRS6764_C3
/

comment on table X_BRS6764_C3_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W1 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'W1' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_W1 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W1_UNI
as select unique NE_ID from X_BRS6764_W1
/

comment on table X_BRS6764_W1_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W2 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'W2' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_W2 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W2_UNI
as select unique NE_ID from X_BRS6764_W2
/

comment on table X_BRS6764_W2_UNI IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W3 as
(select a.ne_id, a.ne_id_of from  v_nm_nat_nsgn_offn_sdo a, STWORKS2011 g
where g.sub_area = 'W3' and
sdo_relate( a.geoloc, g.geometry, 'mask=anyinteract') = 'TRUE') 
/

comment on table X_BRS6764_W3 IS 'Created by Aileen Heal for BRS 6467';

create table X_BRS6764_W3_UNI
as select unique NE_ID from X_BRS6764_W3
/

comment on table X_BRS6764_W3_UNI IS 'Created by Aileen Heal for BRS 6467';

create or replace view X_BRS6764 as
-- view created by Aileen Heal as part of the work for BRS6764
SELECT 'E1' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_E1_UNI)
union
SELECT 'E2' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_E2_UNI)
union
SELECT 'E3' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_E3_UNI)
UNION
SELECT 'W1' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_W1_UNI)
UNION
SELECT 'W2' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_W2_UNI)
UNION
SELECT 'W3' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_W3_UNI)
UNION
SELECT 'C1' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_C1_UNI)
UNION
SELECT 'C2' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_C2_UNI)
UNION
SELECT 'C3' area_name,ne_id, NSG_REFERENCE, ne_descr 
from v_nsg_full_OFFN_attribs 
WHERE NE_ID  in (select NE_ID from X_BRS6764_C3_UNI)
/