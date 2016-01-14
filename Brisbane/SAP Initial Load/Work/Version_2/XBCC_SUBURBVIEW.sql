/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: XBCC_SUBURBVIEW.sql
	Author: JMM
	UPDATE01:	Original, 2014.04.28, JMM
*/

create or replace view XBEX_SUBURB_EQUIP_RDCO as
			select a.*
,corridor_code STREET_CORRIDOR_ID
,street_name STREET_NAME
,sysdate EXTRACT_DATE
,case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = 0 then null
		   when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc		   
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end GIS_SHAPE
		   from (
		   select
				mem_nm_ne_id_in NETWORK_PRIMARY_ID,
				i_ne_descr suburb_name,
				min(slk) start_ch,
				max(end_slk) end_ch	
			from (      
            select a.*
            		, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
             from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP
					from ( 
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_name_2   			  i_ne_descr   --suburb
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk						
							FROM 
								(select * from nm_elements where ne_nt_type in  ('KSUB','VESB','STSB')) i 
								,nm_members aloc
								,nm_members mem 
                                ,v_nm_nlt_rdco_rdco_sdo_dt   cor                     
							WHERE 1=1
								--and i.iit_x_sect = 'XCS' 
                                and  cor.ne_id = mem.nm_ne_id_in
								--and mem.nm_ne_id_in like n_brams_id
								AND mem.nm_obj_type  = cor.ne_gty_group_type
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('KSUB','VESB','STSB')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
                                                            --order by slk                                                              
							)      -- order by slk   
                            )        a --order by slk                                                                  
					)
			group by mem_nm_ne_id_in, i_ne_descr, DBSMP
			) a, v_nm_nlt_rdco_rdco_sdo_dt b
where b.ne_id  = a.NETWORK_PRIMARY_ID
order by suburb_name, start_ch
			;


create or replace view XBEX_SUBURB_EQUIP_MED as
			select a.*
,corridor_code STREET_CORRIDOR_ID
,street_name STREET_NAME
,sysdate EXTRACT_DATE
,case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = 0 then null
		   when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc		   
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end GIS_SHAPE
		   from (
		   select
				9000000000 + mem_nm_ne_id_in NETWORK_PRIMARY_ID,
				i_ne_descr suburb_name,
				min(slk) start_ch,
				max(end_slk) end_ch	
			from (      
            select a.*
            		, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
             from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP
					from ( 
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_name_2   			  i_ne_descr   --suburb
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk						
							FROM 
								(select * from nm_elements where ne_nt_type in  ('KSUB','VESB','STSB')) i 
								,nm_members aloc
								,nm_members mem 
                                ,v_nm_nlt_rdco_rdco_sdo_dt   cor                     
							WHERE 1=1
								--and i.iit_x_sect = 'XCS' 
                                and  cor.ne_id = mem.nm_ne_id_in
								--and mem.nm_ne_id_in like n_brams_id
								AND mem.nm_obj_type  = cor.ne_gty_group_type
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('KSUB','VESB','STSB')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
                                                            --order by slk                                                              
							)      -- order by slk   
                            )        a --order by slk                                                                  
					)
			group by mem_nm_ne_id_in, i_ne_descr, DBSMP
			) a, v_nm_nlt_rdco_rdco_sdo_dt b
where 9000000000 + b.ne_id  = a.NETWORK_PRIMARY_ID
order by suburb_name, start_ch
			;


create or replace view XBEX_SUBURB_EQUIP_KCOR as
			select a.*
,corridor_code STREET_CORRIDOR_ID
,street_name STREET_NAME
,sysdate EXTRACT_DATE
,case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = 0 then null
		   when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc		   
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end GIS_SHAPE
		   from (
		   select
				 mem_nm_ne_id_in NETWORK_PRIMARY_ID,
				i_ne_descr suburb_name,
				min(slk) start_ch,
				max(end_slk) end_ch	
			from (      
            select a.*
            		, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
             from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP
					from ( 
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_name_2   			  i_ne_descr   --suburb
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk						
							FROM 
								(select * from nm_elements where ne_nt_type in  ('KSUB','VESB','STSB')) i 
								,nm_members aloc
								,nm_members mem 
                                ,v_nm_nlt_kcor_kcor_sdo_dt   cor                     
							WHERE 1=1
								--and i.iit_x_sect = 'XCS' 
                                and  cor.ne_id = mem.nm_ne_id_in
								--and mem.nm_ne_id_in like n_brams_id
								AND mem.nm_obj_type  = cor.ne_gty_group_type
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('KSUB','VESB','STSB')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
                                                            --order by slk                                                              
							)      -- order by slk   
                            )        a --order by slk                                                                  
					)
			group by mem_nm_ne_id_in, i_ne_descr, DBSMP
			) a, v_nm_nlt_kcor_kcor_sdo_dt b
where  b.ne_id  = a.NETWORK_PRIMARY_ID
order by suburb_name, start_ch
;

create or replace view XBEX_SUBURB_EQUIP_VECO as
			select a.*
,corridor_code STREET_CORRIDOR_ID
,street_name STREET_NAME
,sysdate EXTRACT_DATE
,case    when start_ch = end_ch then null
           when sdo_lrs.measure_range(b.geoloc) = 0 then null
		   when sdo_lrs.measure_range(b.geoloc) = end_ch - start_ch then b.geoloc		   
           else SDO_LRS.CLIP_GEOM_SEGMENT(b.geoloc, start_ch, end_ch)
           end GIS_SHAPE
		   from (
		   select
				 mem_nm_ne_id_in NETWORK_PRIMARY_ID,
				i_ne_descr suburb_name,
				min(slk) start_ch,
				max(end_slk) end_ch	
			from (      
            select a.*
            		, Case when (lag (end_slk) over (partition by  i_ne_descr, mem_nm_ne_id_in order by slk)) <> slk  then slk 
						else (last_value (DBTSMP ignore nulls) over (partition by i_ne_descr, mem_nm_ne_id_in  order by slk rows between unbounded preceding and 1 preceding)) end DBSMP
             from (
					select
						mem_nm_ne_id_in,
						i_ne_descr,
						slk,
						end_slk
						, Case when (lag (end_slk) over (partition by mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then 'Y' else 'N' end DB
						, Case when (lag (end_slk) over (partition by  mem_nm_ne_id_in, i_ne_descr order by slk)) <> slk then slk  else null end DBTSMP
					from ( 
							SELECT 
								mem.nm_ne_id_in         mem_nm_ne_id_in,
								aloc.nm_ne_id_in            aloc_nm_ne_id_in
								,aloc. nm_date_modified aloc_nm_date_modified  
								,aloc.nm_date_created    aloc_nm_date_created 
								, aloc.nm_start_date        aloc_nm_start_date
								, aloc.nm_end_date        aloc_nm_end_date
								, aloc.nm_obj_type          aloc_nm_obj_type
								,i.ne_name_2   			  i_ne_descr   --suburb
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_begin_mp,0),    -1,   nvl(mem.nm_end_slk,0)  - nvl(aloc.nm_begin_mp,0)) slk
								,DECODE (MEM.NM_CARDINALITY,    1,   nvl(mem.nm_slk,0)      + nvl(aloc.nm_end_mp,0),    -1,   nvl(mem.nm_end_slk,0)       - nvl(aloc.nm_begin_mp,0))    END_slk						
							FROM 
								(select * from nm_elements where ne_nt_type in  ('KSUB','VESB','STSB')) i 
								,nm_members aloc
								,nm_members mem 
                                ,v_nm_nlt_veco_veco_sdo_dt   cor                     
							WHERE 1=1
								--and i.iit_x_sect = 'XCS' 
                                and  cor.ne_id = mem.nm_ne_id_in
								--and mem.nm_ne_id_in like n_brams_id
								AND mem.nm_obj_type  = cor.ne_gty_group_type
								AND aloc.nm_type = 'G'       
								AND aloc.nm_obj_type in ('KSUB','VESB','STSB')                    
								AND mem.nm_ne_id_of = aloc.nm_ne_id_of 
								and aloc.nm_ne_id_in = i.ne_id
                                                            --order by slk                                                              
							)      -- order by slk   
                            )        a --order by slk                                                                  
					)
			group by mem_nm_ne_id_in, i_ne_descr, DBSMP
			) a, v_nm_nlt_veco_veco_sdo_dt b
where  b.ne_id  = a.NETWORK_PRIMARY_ID
order by suburb_name, start_ch
;