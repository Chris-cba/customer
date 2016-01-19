drop view xodot_barr_ea;
create view xodot_barr_ea as 


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
, iit_x_sect
, highway_ea_number  SECTION_EA
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
                 , nvl(lead( end_MP_NO )over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in ,highway_ea_number    order by  begin_MP_NO ),end_mp_no) end --,highway_ea_number added by JMM to remove some mile point overlaps
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
                          ,lead( begin_MP_NO )over (partition by  aloc_nm_ne_id_in, mem_nm_ne_id_in ,highway_ea_number   order by  begin_MP_NO )  next_b  --,highway_ea_number added by JMM to remove some mile point overlaps
                          ,lag ( end_mp_NO )over (partition by  aloc_nm_ne_id_in, mem_nm_ne_id_in ,highway_ea_number    order by  end_MP_NO  ) P_end
                          ,highway_ea_number  
                           FROM
                           (        

                               select
                               mem.nm_ne_id_in mem_nm_ne_id_in
                               ,aloc.nm_ne_id_in aloc_nm_ne_id_in
                               ,DECODE( MEM.NM_CARDINALITY
                                        ,1  ,  mem.nm_slk+ aloc.nm_begin_mp + case when s.nm_begin_mp <> 0 then  abs(aloc.nm_begin_mp-s.nm_begin_mp) else 0 end
                                        ,-1 ,  mem.nm_end_slk  -  aloc.nm_begin_mp
                                       ) begin_MP_NO  
                               ,DECODE( MEM.NM_CARDINALITY
                                        , 1   ,  mem.nm_slk+ aloc.nm_end_mp - case when aloc.nm_end_mp > s.nm_end_mp then abs(aloc.nm_end_mp - s.nm_end_mp) else 0 end
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
                            --  and aloc.nm_ne_id_in in (1442645,1440783)
                            --  and aloc.nm_ne_id_in in (           -- for testing
                            --                          1166653, 
                            --                          1166650
                            --                          ) 
                            )
                      ) 
                      
                  )
               )
              
              ) loc,
              XODOT_EA_CW_DIST_REG_LOOKUP g                          
        where a.iit_ne_id = loc.iit_ne_id
        and mem_nm_ne_id_in = hwy.ne_id
        and HIGHWAY_EA_NUMBER = g.ea_number;
     
     
    
