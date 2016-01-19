-- Version 5 - Richard Ellis june 2011

--  altered to deal with assets at the very end of a SEEA.



CREATE OR REPLACE VIEW TRANSINFO.XODOT_IATN_V
AS
select  
   HWY,
   BEGIN_MP,
   HIGHWAY_NUMBER,
   SUFFIX,
   ROADWAY_ID,
   MILEAGE_TYPE,
   OVERLAP_MILEAGE_CODE,
   ROAD_DIRECTION,
   ROAD_TYPE,
   PRIMARY_KEY,
   SECTION_EA,
   g.maint_section_crew_id SECTION_CREW,
   g.maint_dist_id DISTRICT,
   g.maint_reg_id REGION,
   IATN_TRMNL_TYP,
   IATN_TRMNL_HT_CD,
   IATN_TRMNL_COND_CD,
   IATN_NOTE,
   IATN_INV_COMNT,
   IATN_LAST_INV_YR
from 
       (SELECT   b.ne_unique HWY,
            DECODE (b.nm_cardinality,
                    1, b.nm_slk + c.nm_begin_mp,
                    b.nm_slk + (b.nm_end_mp - c.nm_end_mp))
               BEGIN_MP,
            HIGHWAY_NUMBER,
            SUFFIX,
            ROADWAY_ID,
            MILEAGE_TYPE,
            OVERLAP_MILEAGE_CODE,
            GENERAL_ROAD_DIRECTION ROAD_DIRECTION,
            ROAD_TYPE,
            c.iit_primary_key PRIMARY_KEY,
            decode ( s.HIGHWAY_EA_NUMBER , null, s2.HIGHWAY_EA_NUMBER , s.HIGHWAY_EA_NUMBER )  SECTION_EA,
           -- g.maint_section_crew_id SECTION_CREW,
           -- g.maint_dist_id DISTRICT,
           -- g.maint_reg_id REGION,
            c.trmnl_typ IATN_TRMNL_TYP,
            c.trmnl_ht_cd IATN_TRMNL_HT_CD,
            c.trmnl_cond_cd IATN_TRMNL_COND_CD,
            c.note IATN_NOTE,
            c.inv_comnt IATN_INV_COMNT,
            c.last_inv_yr IATN_LAST_INV_YR
     FROM   (SELECT   NE_UNIQUE,
                      HIGHWAY_NUMBER,
                      SUFFIX,
                      ROADWAY_ID,
                      MILEAGE_TYPE,
                      OVERLAP_MILEAGE_CODE,
                      GENERAL_ROAD_DIRECTION,
                      ROAD_TYPE,
                      nm_slk,
                      nm_begin_mp,
                      nm_end_mp,
                      nm_ne_id_of,
                      nm_cardinality
               FROM   v_nm_hwy_hwy_nt, nm_members
              WHERE   ne_id = nm_ne_id_in) b,
            v_nm_IATN_nw c,
            (SELECT   *
               FROM   v_nm_seea_nt, nm_members
              WHERE   ne_id = nm_ne_id_in AND nm_obj_type = 'SEEA') s ,
               (SELECT   *
               FROM   v_nm_seea_nt, nm_members
              WHERE   ne_id = nm_ne_id_in AND nm_obj_type = 'SEEA') s2 --,
              -- XODOT_EA_CW_DIST_REG_LOOKUP g
    WHERE       c.ne_id_of = b.nm_ne_id_of
            AND c.ne_id_of = s.nm_ne_id_of (+)
            AND c.nm_begin_mp >= s.nm_begin_mp (+)
            AND c.nm_begin_mp < s.nm_end_mp(+)
             AND c.ne_id_of = s2.nm_ne_id_of (+)
            and c.nm_begin_mp > s2.nm_begin_mp(+) 
            AND c.nm_begin_mp <= s2.nm_end_mp (+)
            ) iatn,
            XODOT_EA_CW_DIST_REG_LOOKUP g
            where                 
            section_EA = g.ea_number;


