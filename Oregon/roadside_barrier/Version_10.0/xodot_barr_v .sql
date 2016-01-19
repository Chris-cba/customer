create or replace view xodot_barr_v as
--create or replace view x_jm_barr as
With 
SEEA as 
    (select min(nm_begin_mp) nm_begin_mp, max(nm_end_mp) nm_end_mp, ne_id, nm_ne_id_of, highway_ea_number from  v_nm_seea_nt, nm_members 
        WHERE  ne_id = nm_ne_id_in  AND nm_obj_type = 'SEEA'
        group by ne_id, nm_ne_id_of, highway_ea_number
    ) -- need to min/max to get rid of some duplicate records
,ZDB_CHK as (
        select /*+ materialize */ * from nm_members m, nm_elements d
         where 1=1
         and ne_type = 'D'
         and ne_id = nm_ne_id_of
         and nm_type = 'G' 
         and nm_obj_type = 'HWY' 
         and nm_slk = nm_end_slk
 )
 --
,Base1 as 
    (
    select a.*,
        case when barr_begin_mp_no < ea_begin_mp_no then ea_begin_mp_no else barr_begin_mp_no end begin_mp_no,
        case when barr_end_mp_no > ea_end_mp_no then ea_end_mp_no else barr_end_mp_no end end_mp_no,
        case when barr_begin_mp_no < ea_begin_mp_no then 'Y' else 'N' end EA_BREAK_mp_begin,
        case when barr_end_mp_no > ea_end_mp_no then 'Y' else 'N' end EA_BREAK_mp_end         
    from     
        (SELECT 
            mem.nm_ne_id_in
            mem_nm_ne_id_in,
            aloc.nm_ne_id_in
            aloc_nm_ne_id_in,
            DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + s.nm_begin_mp,    -1,   mem.nm_end_slk  - s.nm_begin_mp) ea_begin_MP_NO,
            DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + s.nm_end_mp,    -1,   mem.nm_end_slk       - s.nm_begin_mp)    ea_END_MP_NO,
            DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + aloc.nm_begin_mp,    -1,   mem.nm_end_slk  - aloc.nm_begin_mp) barr_begin_MP_NO,
            DECODE (MEM.NM_CARDINALITY,    1,   mem.nm_slk      + aloc.nm_end_mp,    -1,   mem.nm_end_slk       - aloc.nm_begin_mp)    barr_END_MP_NO
            ,highway_ea_number
            FROM nm_members aloc,
            nm_members mem
           ,SEEA s
        WHERE 1=1
        AND mem.nm_obj_type = 'HWY'
        AND aloc.nm_type = 'I'
        -- set asset type here - massive speed differance
        AND aloc.nm_obj_type =  'BARR'
        AND aloc.nm_ne_id_of =  s.nm_ne_id_of
        AND (aloc.nm_begin_mp <    s.nm_end_mp     AND aloc.nm_end_mp > s.nm_begin_mp)
        AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
        --  and aloc.nm_ne_id_in in (           -- for testing
        --                          1166653,
        --                          1166650
        --                          )
        ) a
    )
,Base2 as  --used to do some analytic looks at the DB (gap) areas
(
        select 
            mem_nm_ne_id_in,
            aloc_nm_ne_id_in ,
            highway_ea_number,
            begin_mp_no ,
            end_mp_no
            ,EA_BREAK_mp_begin
            ,db
            ,DBTSMP
            , Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no or zdb = 'Y' then begin_mp_no  
            else (last_value (DBTSMP ignore nulls) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in, highway_ea_number order by begin_mp_no rows between unbounded preceding and 1 preceding)) end DBSMP
            ,        tt             
        from (
                select 
                 mem_nm_ne_id_in,
                aloc_nm_ne_id_in,
                highway_ea_number,
                begin_mp_no,
                end_mp_no
                ,EA_BREAK_mp_begin
                , Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no then 'Y' else 'N' end DB
                , Case when ((lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no) 
                            OR  (begin_mp_no in (select nm_slk from zdb_chk where  nm_ne_id_in = mem_nm_ne_id_in))
                            then begin_mp_no  else null end DBTSMP
                , lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no) tt 
                , case when begin_mp_no in (select nm_slk from zdb_chk where  nm_ne_id_in = mem_nm_ne_id_in) then 'Y' else 'N' end ZDB
            --
                from      base1
                ) 
)
--select * from base2 where mem_nm_ne_id_in = 1050365
--
---
---  
     SELECT ne_unique HWY,     
          BEG_MP_no BEGIN_MP,
          END_MP_no END_MP,
          HIGHWAY_NUMBER,
          SUFFIX,
          ROADWAY_ID,
          MILEAGE_TYPE,
          OVERLAP_MILEAGE_CODE,
          general_road_direction ROAD_DIRECTION,
          ROAD_TYPE,
          iit_x_sect XSP,
          iit_primary_key PRIMARY_KEY,
          highway_ea_number SECTION_EA,
          g.maint_section_crew_id SECTION_CREW,
          g.maint_dist_id DISTRICT,
          g.maint_reg_id REGION,                   
          BARR_TYP BARR_TYP,
          CONC_CNSTRC_TYP BARR_CONC_CNSTRC_TYP,
          CONC_CON_DESC BARR_CONC_CON_DESC,
          RAIL_POST_SPACING_TYP BARR_RAIL_POST_SPACING_TYP,
          RAIL_POST_TYP BARR_RAIL_POST_TYP,
          BARR_HT_CD BARR_HT_CD,
          BARR_COND_CD BARR_COND_CD,
          BEG_TRMNL_TYP BARR_BEG_TRMNL_TYP,
          BEG_TRMNL_HT_CD BARR_BEG_TRMNL_HT_CD,
          BEG_TRMNL_COND_CD BARR_BEG_TRMNL_COND_CD,
          case when (lag(end_mp_no) over (partition by IIT_primary_key order by beg_mp_no)) = beg_mp_no  then 'N' else 'Y' end BARR_BEG_CNT_TRMNL_BRK_FLG ,
          SHR_BEG_TRMNL_FLG BARR_SHR_BEG_TRMNL_FLG,
          END_TRMNL_TYP BARR_END_TRMNL_TYP,
          END_TRMNL_HT_CD BARR_END_TRMNL_HT_CD,
          END_TRMNL_COND_CD BARR_END_TRMNL_COND_CD,
          case when (lead(beg_mp_no) over (partition by IIT_primary_key order by beg_mp_no)) = end_mp_no  then 'N' else 'Y' end BARR_END_CNT_TRMNL_BRK_FLG ,
          SHR_END_TRMNL_FLG BARR_SHR_END_TRMNL_FLG,
          BARR_DESC,
          INV_COMNT BARR_INV_COMNT,
          NOTE BARR_NOTE,
          LAST_INV_Yr BARR_LAST_INV_DT
     FROM v_nm_BARR a,
          v_nm_hwy_hwy_nt hwy,      
                      (
          select 
                     mem_nm_ne_id_in,
                   aloc_nm_ne_id_in IIT_NE_ID,
            highway_ea_number,
             min(begin_mp_no) beg_mp_no,
             max(end_mp_no) end_mp_no             
             ,DBSMP
             from base2          
        group by  mem_nm_ne_id_in, aloc_nm_ne_id_in, highway_ea_number,DBSMP) loc,
          XODOT_EA_CW_DIST_REG_LOOKUP g
    WHERE     a.iit_ne_id = loc.iit_ne_id
          AND mem_nm_ne_id_in = hwy.ne_id
          AND HIGHWAY_EA_NUMBER = g.ea_number
          
          --AND iit_primary_key = 1442750
          --
          --)
          ;