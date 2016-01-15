     Create table OHMS_7_get_Turn_1 as
     
      select 
        SAMP_ID
        , route_id
        , min(nm_slk) nm_slk
        , max(nm_end_slk) nm_end_slk
        
        FROM (
            select a.SAMP_ID
                , a.NE_ID_OF
                , GREATEST(a.NM_BEGIN_MP, D.NM_BEGIN_MP) NM_BEGIN_MP
                , least(a.nm_end_mp, d.nm_end_mp) nm_end_mp
                , d.nm_cardinality
                , c.ne_unique route_id
                    , CASE 
                            when D.NM_CARDINALITY = 1 then
                                d.nm_slk + (greatest(a.nm_begin_mp,d.nm_begin_mp) - d.nm_begin_mp)
                            ELSE
                                    d.nm_slk + (d.nm_end_mp - least(d.nm_end_mp, a.nm_end_mp))
                        END nm_slk
                    , CASE 
                            WHEN d.nm_cardinality = 1 THEN
                                d.nm_end_slk - (d.nm_end_mp - least(d.nm_end_mp, a.nm_end_mp))
                            ELSE
                                d.nm_end_slk - (greatest(a.nm_begin_mp,d.nm_begin_mp) - d.nm_begin_mp)
                        end NM_END_SLK
                        
            from v_nm_OHMS_NW a
                --, nm_members_all b
                , nm_elements_all c
                , NM_MEMBERS_ALL D
                
            where rownum > 0
                --AND a.iit_inv_type = 'HPMS'
                --and a.IIT_END_DATE is null
                --AND a.iit_ne_id = b.nm_ne_id_in
                --AND a.iit_power = cp_year
                --AND b.nm_end_date IS NULL
                AND c.ne_nt_type = 'HWY'
                AND c.ne_end_date IS NULL
                AND c.ne_id = d.nm_ne_id_in
                and D.NM_END_DATE is null
                and a.NE_ID_OF = D.NM_NE_ID_OF
                and D.NM_BEGIN_MP < a.NM_END_MP
                and D.NM_END_MP > a.NM_BEGIN_MP
                --and a.SAMP_ID = 3517
                
                )
                
                
        GROUP BY SAMP_ID, ROUTE_ID;
        
create index IDX_OHMS_7_GET_TURN_1 on OHMS_7_GET_TURN_1(SAMP_ID, route_id);


create table OHMS_7_get_Turn_Urban as (                         
              select samp_id, count(*) Urban from (
              
              SELECT b.*, a.samp_id                
              from            
                (SELECT OHMS_7_GET_TURN_1.*, d.nm_ne_id_of
                              , case when D.NM_CARDINALITY = 1 then
                                  case when D.NM_SLK < OHMS_7_GET_TURN_1.NM_SLK then
                                      (OHMS_7_GET_TURN_1.nm_slk - d.nm_slk) + nm_begin_mp
                                  ELSE
                                      nm_begin_mp
                                  END
                                else
                                  case when d.NM_END_SLK > OHMS_7_GET_TURN_1.NM_END_SLK then
                                      nm_begin_mp + (d.nm_end_slk - OHMS_7_GET_TURN_1.nm_end_slk)
                                  ELSE
                                      nm_begin_mp
                                  END
                                END nm_begin_mp
                              , case when D.NM_CARDINALITY = 1 then
                                  case when d.NM_END_SLK > OHMS_7_GET_TURN_1.NM_END_SLK then
                                      nm_end_mp - (d.nm_end_slk - OHMS_7_GET_TURN_1.nm_end_slk)
                                  ELSE
                                      nm_end_mp
                                  END
                                else
                                  case when d.NM_SLK < OHMS_7_GET_TURN_1.NM_SLK then
                                      nm_end_mp - (OHMS_7_GET_TURN_1.nm_slk - d.nm_slk)
                                  ELSE
                                      nm_end_mp
                                  END
                                END nm_end_mp
                          FROM nm_elements_all c
                              , NM_MEMBERS_ALL D
                              , OHMS_7_GET_TURN_1
                          WHERE c.ne_unique = OHMS_7_GET_TURN_1.route_id
                              AND c.ne_id = d.nm_ne_id_in
                              AND c.ne_end_date IS NULL
                              and D.NM_END_DATE is null
                              and D.NM_END_SLK > OHMS_7_GET_TURN_1.NM_SLK
                              and D.NM_SLK <  OHMS_7_GET_TURN_1.NM_END_SLK
                              --and SAMP_ID = 3522
                              ) a
                        ,
                              
                              (SELECT nm_ne_id_in
                    , nm_ne_id_of
                    , nm_begin_mp
                    , NM_END_MP
                    --, nm_obj_type
                FROM nm_members_all 
                WHERE nm_obj_type = 'URBN'
                    and NM_END_DATE is null) B
                    
        where 
            
             a.nm_ne_id_of = b.nm_ne_id_of
            and B.NM_BEGIN_MP < a.NM_END_MP
            and B.NM_END_MP > a.NM_BEGIN_MP
            --and rownum < 3
            )
            
            group by SAMP_ID
            
            )
            
            ;
create index idx_OHMS_7_get_Turn_Urban on OHMS_7_get_Turn_Urban(samp_id);           



create table v_nm_ohms_turn_nw as
select a.*, XNA_OHMS_GET_TLL(a.SAMP_ID) TLL,  XNA_OHMS_GET_TLR(a.SAMP_ID) TLR
from V_NM_OHMS_NW a, OHMS_7_get_Turn_Urban B
  where 1=1
  
  and a.SAMP_ID = B.SAMP_ID  
  ;

create index idx_v_nm_ohms_turn_nw on v_nm_ohms_turn_nw(samp_id, iit_ne_id, ne_id_of);
