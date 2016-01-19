    delete from nm_members 
    where rowid  in ( 
        select mem.rowid r_id from nm_members mem,
            (select mem.nm_ne_id_in, mem.nm_ne_id_of, min(mem.nm_start_date) sd
            from 
                nm_members mem
                ,(select nm_ne_id_in, nm_ne_id_of from nm_members
                where nm_obj_type = 'SNEA' 
                --and nm_ne_id_in = 5754264
               ) cnt
            where
                cnt.nm_ne_id_in =mem.nm_ne_id_in
                and cnt.nm_ne_id_of = mem.nm_ne_id_of
            group by mem.nm_ne_id_in, mem.nm_ne_id_of
            )    k
            where k.nm_ne_id_in = mem.nm_ne_id_in
            and k.nm_ne_id_of = mem.nm_ne_id_of
            and k.sd <> mem.nm_start_date)
    and nm_obj_type = 'SNEA' ;