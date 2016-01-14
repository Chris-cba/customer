
                select a.* , b.* from nm_members_all a,nm_elements_all b  where
                    1=1
                    and a.nm_ne_id_of = b.ne_id                     
                    and b.ne_type <> 'D'
                    and nm_type = 'G'  
                    and nm_obj_type in (:s_route_type)
                    and (   nm_date_modified between to_date('10/12/2013','DD/MM/RRRR') and to_date('11/12/2013','DD/MM/RRRR') 
                               or ne_date_modified between to_date('10/12/2013','DD/MM/RRRR') and to_date('11/12/2013','DD/MM/RRRR'))
                    order by nm_ne_id_in,nm_slk
                    ;
					

					select * from nm_members_all i, nm_members_all r
					where 1=1
					and i.nm_type = 'I'
					and i.nm_ne_id_in = r.nm_ne_id_of
					
					
					
					
					
	SELECT 
            mem.nm_ne_id_in         mem_nm_ne_id_in,
            aloc.nm_ne_id_in            aloc_nm_ne_id_in
            ,aloc. nm_date_modified aloc_nm_date_modified  
            ,aloc.nm_
            , 
           -- DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) begin_MP_NO,
            --DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_MP_NO            
            FROM 
            nm_inv_items_all i -- (select iit_ne_id from  nm_inv_items where 1=1 and iit_inv_type = :INV_TYPE)) aloc
            ,nm_members_all aloc
            ,nm_members_all mem           
        WHERE 1=1
        AND mem.nm_obj_type = 'RDCO'
        AND aloc.nm_type = 'I'       
        AND aloc.nm_obj_type =  :INV_TYPE
        AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
        and aloc.nm_ne_id_in = i.iit_ne_id
         and (   aloc.nm_date_modified between to_date('10/12/2009','DD/MM/RRRR') and to_date('11/12/2013','DD/MM/RRRR') 
                               or i.iit_date_modified between to_date('10/12/2009','DD/MM/RRRR') and to_date('11/12/2013','DD/MM/RRRR'))