                                                   with il as (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  :s_inv_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e'))) il
                        )
                    select iit_ne_id ne_id from 
                    (select * from nm_inv_items_all ) i
                    where 1=1
                    and  iit_inv_type  in ((select trim(cast(myrow as varchar2(25))) from il))
                                        and (   
						--	(trunc(aloc.nm_date_modified) between :d_start_date and :d_end_date  and trunc(aloc.nm_date_modified) <> :d_start_date)
                           (trunc(i.iit_date_modified)between :d_start_date and  :d_end_date and trunc(i.iit_date_modified) <> :d_start_date)
						)
						
						
						              with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select :s_route_type col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))                        
                        )
                        select nm_ne_id_in from
                        nm_members_all aloc
                        where 
                        nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
                        and (trunc(aloc.nm_date_modified) between :d_start_date and :d_end_date  and trunc(aloc.nm_date_modified) <> :d_start_date)