-- This one normally runs quickly, sometimes it takes forever.

			with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select 'OPWD,KSUB,VESB,STSB' col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                        , n as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select 'RDCO,VECO,KCOR' col1 from dual) x,
                        TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        )
                            SELECT /*+ index(mem xbcc_idx_ne_id_in_chr) */
                                mem.nm_ne_id_in         mem_nm_ne_id_in,
                                aloc.nm_ne_id_in            aloc_nm_ne_id_in
                                ,aloc. nm_date_modified aloc_nm_date_modified  
                                ,aloc.nm_date_created    aloc_nm_date_created 
                                , aloc.nm_start_date        aloc_nm_start_date
                                , aloc.nm_end_date        aloc_nm_end_date
                                , aloc.nm_obj_type          aloc_nm_obj_type
                                ,i.ne_name_1                 i_ne_descr   --ne_name_1 listed as street sub in type_columns
                            FROM                             
                                nm_elements_all i 
                                ,nm_members_all aloc
                                ,nm_members_all mem                            
                            WHERE 1=1
                                and mem.nm_ne_id_in like '%'  -- this can be 1 ID, there is a function index to help the 'text' conversion
                                AND mem.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from n)  
                                AND aloc.nm_type = 'G'       
                                AND aloc.nm_obj_type in (select trim( cast(myrow as varchar2(25))) from m)                    
                                AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
                                and aloc.nm_ne_id_of = i.ne_id            
								--and rownum < 50  --tester
                    and (   
							(trunc(aloc.nm_date_modified) between '01-MAY-2014' and '30-JUN-2014' and trunc(aloc.nm_date_modified) <> '01-MAY-2014')
                               or 
							 (trunc(ne_date_modified) between '01-MAY-2014' and '30-JUN-2014' and trunc(ne_date_modified) <> '01-MAY-2014')
						);
						
						
-- This is the Second one that sometimes runs slowly


		select ne_id from (
			with il as (SELECT EXTRACT(column_value,'/e/text()') myrow from (select   'ASOW,CBSC,CALL,KCON' col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e'))) il
			)
			select iit_ne_id ne_id from 
				(select * from nm_inv_items_all ) i
				where 1=1
				and  iit_inv_type  in ((select trim(cast(myrow as varchar2(25))) from il))
				and (   
				--	(trunc(aloc.nm_date_modified) between  d_start_date and  d_end_date  and trunc(aloc.nm_date_modified) <>  d_start_date)
				(trunc(i.iit_date_modified)between  '01-MAY-2014' and   '30-JUN-2014' and trunc(i.iit_date_modified) <>  '01-MAY-2014')
			)
			--and rownum < 50  --tester
		)
		--
		UNION ALL
		--
		select * from (
			with m as  (SELECT EXTRACT(column_value,'/e/text()') myrow from (select  'RDCO,VECO,KCOR' col1 from dual) x,
			TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))                        
			)
			select nm_ne_id_in ne_id from
				nm_members_all aloc
				where 
				nm_obj_type in (select trim(cast(myrow as varchar2(25))) from m)
				and (trunc(aloc.nm_date_modified) between  '01-MAY-2014' and  '30-JUN-2014'  and trunc(aloc.nm_date_modified) <>  '01-MAY-2014')
				--and rownum < 50  --tester
		);			