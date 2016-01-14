create or replace view  xaa_route as   -- add comment about RT
        select
        r_ne_id route_id
        , r_ne_unique route_name
        --, r_ne_descr
        --, max(r_ne_descr)        
		,'RT' ROUTE_TYPE
        , min(nm_slk) offset_from
        ,max(nm_end_slk) offset_to
        , max(d_ne_date_modified)effective_date
from ( 
(
  select         
        r_ne_id
        , r_ne_unique
        , r_ne_descr
        , r_NE_DATE_MODIFIED
        , m_nm_date_modified
        , nm_slk 
        , nm_end_slk 
        , Case when lag (nm_end_slk) over (partition by r_ne_id order by nm_slk, nm_end_slk) <> nm_slk 
            OR (lag (nm_end_slk) over (partition by r_ne_id order by nm_slk, nm_end_slk) is null)  
            or (lag(D_NE_type) over (partition by r_ne_id order by nm_slk, nm_end_slk) = 'D' )  then nm_slk  
            else (last_value (DBTSMP ignore nulls) over (partition by r_ne_id order by nm_slk, nm_end_slk rows between unbounded preceding and 1 preceding)) end DBSMP
        ,d_ne_id
        , d_ne_unique
        , d_ne_descr
        , d_NE_DATE_MODIFIED
        , d_ne_type
        from
        (
    select 
        routes.ne_id r_ne_id
        , routes.ne_unique r_ne_unique
        , routes.ne_descr r_ne_descr
        , routes.NE_DATE_MODIFIED r_ne_date_modified
        , mem.nm_date_modified m_nm_date_modified
        , nm_slk 
        , nm_end_slk        
        , Case when 
                        (lag (nm_end_slk) over (partition by routes.ne_id order by mem.nm_slk, mem.nm_end_slk) <> nm_slk)   
                        OR (lag (nm_end_slk) over (partition by routes.ne_id order by mem.nm_slk, mem.nm_end_slk) is null)                       
                        OR  (lag(DATUM.NE_type) over (partition by routes.ne_id order by mem.nm_slk, mem.nm_end_slk) = 'D' )                           
                            then nm_slk  else null end DBTSMP
        , datum.ne_id d_ne_id
        , datum.ne_unique d_ne_unique
        , datum.ne_descr d_ne_descr
        , datum.NE_DATE_MODIFIED d_ne_date_modified
        , datum.ne_type d_ne_type
     from 
        nm_elements routes
        , nm_members mem
        , nm_elements datum
    where 1=1
        and mem.nm_ne_id_in = routes.ne_id
        and mem.nm_ne_id_of = datum.ne_id
        and mem.nm_obj_type in ('RT')
        and routes.ne_nt_type = 'RT'
        and mem.nm_type = 'G'   
        and datum.ne_type in ('S','D') 
        --
        --and mem.nm_ne_id_in = 9137
        order by nm_slk, nm_end_slk
        )
		where D_NE_type <> 'D'
        )
        )
        group by         
        r_ne_id
        , r_ne_unique
        , r_ne_descr, DBSMP
        --order by slk, end_slk
        ;
        
        
        