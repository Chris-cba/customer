drop table z_joe_test;

create table z_joe_test as (
select * from (
With 
ZDB_CHK as (
        select /*+ materialize */ * from nm_members m, nm_elements d
         where 1=1
         and ne_type = 'D'
         and ne_id = nm_ne_id_of
         and nm_type = 'G' 
         and nm_obj_type = 'RDCO'
         and nm_slk = nm_end_slk
 )
 --
, invitems as
(
select /*+ materialize */  *  from nm_inv_items 
where 1=1 
and iit_inv_type ='ASOW' 
and IIT_X_SECT  in ('XRM', 'XCM', 'XMKE', 'XMKO', 'XRKE', 'XRKO')
)
,Base1 as 
    (
    select a.*                
    from     
        (SELECT 
            mem.nm_ne_id_in
            mem_nm_ne_id_in,
            aloc.nm_ne_id_in
            aloc_nm_ne_id_in,
            DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) begin_MP_NO,
            DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_MP_NO            
            FROM 
            (select * from nm_members where nm_ne_id_in in (select iit_ne_id from invitems)) aloc
            --,nm_members aloc
            ,nm_members mem           
        WHERE 1=1
        AND mem.nm_obj_type = 'RDCO'
        AND aloc.nm_type = 'I'       
        AND aloc.nm_obj_type =  'ASOW'
        AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
        ) a
    )
,Base2 as  --used to do some analytic looks at the DB (gap) areas
(
        select 
            mem_nm_ne_id_in,
            aloc_nm_ne_id_in ,            
            begin_mp_no ,
            end_mp_no           
            ,db
            ,DBTSMP
            , Case when (lag (end_mp_no) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no)) <> begin_mp_no or zdb = 'Y' then begin_mp_no  
            else (last_value (DBTSMP ignore nulls) over (partition by aloc_nm_ne_id_in, mem_nm_ne_id_in order by begin_mp_no rows between unbounded preceding and 1 preceding)) end DBSMP
            ,        tt             
        from (
                select 
                 mem_nm_ne_id_in,
                aloc_nm_ne_id_in,                
                begin_mp_no,
                end_mp_no                
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
--select * from base2 where 1 = 1
--
---
--- 
select a.* 
--geoloc geoloc_full,
 ,cast( null as sdo_geometry) geoloc 
from ( 
SELECT 
    iit_inv_type,    
    mem_nm_ne_id_in        ,--##ROUTE_TYPE##_PRIMARY_ID,1444
    IIT_NE_ID    ,--##INV_TYPE##_PRIMARY_ID,
    beg_mp_no START_CH,
     end_mp_no   END_CH
      --##COL##    --
from (
     SELECT *
     FROM invitems inv,      
        (select 
            mem_nm_ne_id_in,
            aloc_nm_ne_id_in aloc_IIT_NE_ID,
            min(begin_mp_no) beg_mp_no,
            max(end_mp_no) end_mp_no             
            ,DBSMP
            from base2          
            group by  mem_nm_ne_id_in, aloc_nm_ne_id_in, DBSMP) loc        
        WHERE     1=1
        and inv.iit_ne_id = loc.aloc_IIT_NE_ID
        )  
        Where 1=1        
        ) a
        ,  V_NM_NLT_RDCO_RDCO_SDO_DT sdo --V_NM_NLT_##ROUTE_TYPE##_##ROUTE_TYPE##_SDO_DT sdo
        Where 1=1
       -- and IIT_X_SECT  in ('XRM', 'XCM', 'XMKE', 'XMKO', 'XRKE', 'XRKO')
        and sdo.ne_id = mem_nm_ne_id_in --##ROUTE_TYPE##_PRIMARY_ID
        and rownum <50
        ))
        ;
        
          
          --AND iit_primary_key = 1442750
          --
          --)
          ;