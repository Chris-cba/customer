CREATE MATERIALIZED VIEW XODOT_IATN_V (HWY, BEGIN_MP, HIGHWAY_NUMBER, SUFFIX, ROADWAY_ID, MILEAGE_TYPE, OVERLAP_MILEAGE_CODE, ROAD_DIRECTION, ROAD_TYPE, PRIMARY_KEY, SECTION_EA, SECTION_CREW, DISTRICT, REGION, IATN_TRMNL_TYP, IATN_TRMNL_HT_CD, IATN_TRMNL_COND_CD, IATN_NOTE, IATN_INV_COMNT, IATN_LAST_INV_YR)
REFRESH FORCE
    START WITH SYSDATE 
    NEXT  SYSDATE + 1
    WITH PRIMARY KEY
as
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/roadside_barrier/admin/views/xodot_iatn_v.vw-arc   1.0   Oct 22 2010 10:54:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_iatn_v.vw  $
--       Date into PVCS   : $Date:   Oct 22 2010 10:54:14  $
--       Date fetched Out : $Modtime:   Oct 22 2010 10:17:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton           
--                                   
--                        
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
b.route_id
       , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(a.nm_begin_mp,b.nm_begin_mp)) - b.nm_begin_mp, 
               b.nm_slk + (b.nm_end_mp  - least(a.nm_end_mp, b.nm_end_mp))) start_point
       ,d.ne_owner
       ,d.ne_sub_type
       ,d.ne_prefix
       ,d.ne_name_1
       ,d.ne_name_2
       ,d.ne_number
       ,d.ne_group
	   ,c.iit_primary_key
	   ,g.ea_number
       ,g.maint_section_crew_id
       ,g.maint_dist_id
       ,g.maint_reg_id
       ,c.trmnl_typ
       ,c.trmnl_ht_cd
       ,c.trmnl_cond_cd
	   ,c.note
	   ,c.inv_comnt
	   ,c.last_inv_yr
FROM nm_members a
    , (SELECT ne_unique route_id
            , ne_id
            , nm_slk
            , nm_end_slk
                , nm_end_slk - nm_slk section_length
                , nm_begin_mp
                , nm_end_mp
                , nm_ne_id_of
                , nm_cardinality
        FROM v_nm_hwy_nt
                , nm_members
        WHERE ne_id = nm_ne_id_in) b
    , v_nm_IATN c
    ,nm_elements d
	, nm_members f
   ,XODOT_EA_CW_DIST_REG_LOOKUP g
WHERE a.nm_ne_id_of = b.nm_ne_id_of
and a.nm_ne_id_in = c.iit_ne_id
and b.ne_id = d.ne_id
and f.nm_ne_id_of = a.nm_ne_id_of
and f.nm_obj_type = 'SEEA'
and g.ea_ne_id = f.nm_ne_id_in;