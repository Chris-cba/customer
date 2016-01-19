-- Version 3 - Richard Ellis May 2011

CREATE  VIEW XODOT_BARR_V (HWY, BEGIN_MP, END_MP, HIGHWAY_NUMBER, SUFFIX, ROADWAY_ID, MILEAGE_TYPE, OVERLAP_MILEAGE_CODE, ROAD_DIRECTION, ROAD_TYPE, PRIMARY_KEY, SECTION_EA, SECTION_CREW, DISTRICT, REGION, BARR_TYP, BARR_CONC_CNSTRC_TYP, BARR_CONC_CON_DESC, BARR_RAIL_POST_SPACING_TYP, BARR_RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BARR_BEG_TRMNL_TYP, BARR_BEG_TRMNL_HT_CD, BARR_BEG_TRMNL_COND_CD, BARR_SHR_BEG_TRMNL_FLG, BARR_END_TRMNL_TYP, BARR_END_TRMNL_HT_CD, BARR_END_TRMNL_COND_CD, BARR_SHR_END_TRMNL_FLG, BARR_DESC, BARR_INV_COMNT, BARR_NOTE, BARR_LAST_INV_DT) 
as
select ne_unique HWY
, BEG_MP_no
, END_MP_no
, HIGHWAY_NUMBER
, SUFFIX
, ROADWAY_ID
, MILEAGE_TYPE
, OVERLAP_MILEAGE_CODE
, general_road_direction ROAD_DIRECTION
, ROAD_TYPE
, iit_primary_key PRIMARY_KEY
,highway_ea_number  SECTION_EA
, g.maint_section_crew_id SECTION_CREW
, g.maint_dist_id DISTRICT
, g.maint_reg_id  REGION
, BARR_TYP, CONC_CNSTRC_TYP, CONC_CON_DESC,RAIL_POST_SPACING_TYP, RAIL_POST_TYP, BARR_HT_CD, BARR_COND_CD, BEG_TRMNL_TYP, BEG_TRMNL_HT_CD, BEG_TRMNL_COND_CD, SHR_BEG_TRMNL_FLG, END_TRMNL_TYP, END_TRMNL_HT_CD, END_TRMNL_COND_CD, SHR_END_TRMNL_FLG, BARR_DESC
, INV_COMNT
, NOTE note,
LAST_INV_Yr BARR_LAST_INV_DT 
from 
        v_nm_BARR a,
        v_nm_hwy_hwy_nt hwy,
             (
            select aloc_nm_ne_id_in IIT_NE_ID
               ,mem_nm_ne_id_in
               ,begin_MP_NO beg_mp_no
               ,end end_mp_no 
               ,highway_ea_number 
               from
               (
                 select 
                  aloc_nm_ne_id_in
                 ,mem_nm_ne_id_in
                 ,p_end
                 ,begin_MP_NO
                 ,end_mp_no
                 ,next_b
                  -- need an NVL here in case we are all on one datum!
                 , nvl(lead( end_MP_NO )over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in    order by  begin_MP_NO ),end_mp_no) end
                 , highway_ea_number 
                  from  
                  (      
                     select 
                     aloc_nm_ne_id_in
                    ,mem_nm_ne_id_in
                    ,p_end
                    ,begin_MP_NO    
                    ,end_mp_no
                    ,next_b
                    ,highway_ea_number 
                     from  
                     (
                          SELECT 
                          aloc_nm_ne_id_in
                          ,mem_nm_ne_id_in
                          ,begin_MP_NO
                          ,end_mp_no
                          ,lead( begin_MP_NO )over (partition by  aloc_nm_ne_id_in, mem_nm_ne_id_in    order by  begin_MP_NO )  next_b
                          ,lag ( end_mp_NO )over (partition by  aloc_nm_ne_id_in, mem_nm_ne_id_in    order by  end_MP_NO  ) P_end
                          ,highway_ea_number  
                           FROM
                           (        
                               select
                               mem.nm_ne_id_in mem_nm_ne_id_in
                               ,aloc.nm_ne_id_in aloc_nm_ne_id_in
                               ,decode( MEM.NM_CARDINALITY
                                        ,1  ,  mem.nm_slk+ aloc.nm_begin_mp
                                        ,-1 ,  mem.nm_end_slk  -  aloc.nm_begin_mp
                                       ) begin_MP_NO  
                               ,decode( MEM.NM_CARDINALITY
                                        , 1   ,  mem.nm_slk+ aloc.nm_end_mp
                                        , -1  ,  mem.nm_end_slk  -  aloc.nm_begin_mp
                                      ) END_MP_NO   
                               ,highway_ea_number               
                               from 
                                nm_members aloc
                               ,nm_members mem
                               , 
                                  ( 
                                        select * 
                                        from v_nm_seea_nt, nm_members
                                       where ne_id = nm_ne_id_in 
                                       and nm_obj_type = 'SEEA'
                                  ) s
                               where mem.nm_obj_type = 'HWY'
                               and aloc.nm_type = 'I'
                               -- set asset type here - massive speed differance
                               and aloc.nm_obj_type = 'BARR'
                               and aloc.nm_ne_id_of = s.nm_ne_id_of
                               and ( aloc.nm_begin_mp < s.nm_end_mp and aloc.nm_end_mp > s.nm_begin_mp) 
                               --
                               and mem.nm_ne_id_of = aloc.nm_ne_id_of     
                            --  and aloc.nm_ne_id_in in (           -- for testing
                            --                          1166653, 
                            --                          1166650
                            --                          ) 
                            )
                      ) 
                      where (begin_mp_no != p_end       
                            or p_end is null)
                            or end_mp_no != next_b
                            or next_b is null
                      order by begin_mp_no          
                  )
               )
               where p_end != begin_mp_no   
               or p_end is null    
              ) loc,
              XODOT_EA_CW_DIST_REG_LOOKUP g                          
        where a.iit_ne_id = loc.iit_ne_id
        and mem_nm_ne_id_in = hwy.ne_id
        and HIGHWAY_EA_NUMBER = g.ea_number;
     
    
