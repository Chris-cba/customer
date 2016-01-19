delete from nm_members 
	where nm_ne_id_in in(
				select iit_ne_id from nm_inv_items 
				where iit_inv_type = 'SGNS' and iit_descr = 'AUTO POPULATED BY XODOT_FILL_SGNS'
				and iit_itemcode like '%'
				)
		  and nm_obj_type = 'SGNS';
		  
delete 		  from nm_inv_items 
				where iit_inv_type = 'SGNS' and iit_descr = 'AUTO POPULATED BY XODOT_FILL_SGNS'
				and iit_itemcode like '%'
				;
				

				

				
				
                 select * from(
                 select nm3net.get_ne_unique(loc.nm_ne_id_in) hwy,inv.iit_inv_type,inv.iit_itemcode
                 , loc.nm_slk+inv_mem.nm_begin_mp inv_begin_mp, loc.nm_slk+(inv_mem.nm_end_mp - inv_mem.nm_begin_mp) inv_end_mp
                 , loc.nm_slk hwy_begin_mp, loc.nm_end_slk hwy_end_mp
                 --,inv.* ,inv_mem.*,loc.*
                 from nm_inv_items inv, nm_members inv_mem, nm_members loc where 1=1
                 	and inv.iit_inv_type in ('SGNS', 'SCNS')
                    and INV.IIT_NE_ID = inv_mem.nm_ne_id_in
                    and inv_mem.nm_ne_id_of = loc.nm_ne_id_of
                    and loc.nm_obj_type = 'HWY'                    
                    and inv.iit_itemcode = 'M6104425'
                    )
                    order by 1,2,4

