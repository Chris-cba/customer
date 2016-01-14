CREATE OR REPLACE function x_OPBD_LOOKUP_CHAR(p_what varchar2, p_job_id number, p_section_ID  number) return varchar2
   is
   n_temp number(8);
   s_desc varchar2(188);
   begin
   Case upper(p_what)
	When 'NE_UNIQUE'
		then
			select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select ne_unique into s_desc from nm_elements where ne_id = n_temp;
     
     
	When 'DISTRICT'
		then
			select nqr_source_id  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select  d.nm_ne_id_in into n_temp   from nm_members c, nm_members d
				where 1=1
				and d.nm_ne_id_of=c.nm_ne_id_in
				and c.nm_obj_type = 'ARTC'
				and d.nm_obj_type = 'ARTD'
				and C.NM_NE_ID_OF = n_temp;
				
			select ne_DESCR into s_desc from nm_elements where ne_id = n_temp;
			
	When 'COUNTY_NAME'
		then
			select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select  c.nm_ne_id_in into n_temp   from nm_members c, nm_members d
				where 1=1
				and d.nm_ne_id_of=c.nm_ne_id_in
				and c.nm_obj_type = 'ARTC'
				and d.nm_obj_type = 'ARTD'
				and C.NM_NE_ID_OF = n_temp;
				
			select ne_DESCR into s_desc from nm_elements where ne_id = n_temp;
	
	When 'RT_PREFIX'
		then			
		select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select ne_PREFIX into s_desc from nm_elements where ne_id = n_temp;
	When 'RT_SUFFIX'
		then			
		select NMS_OFFSET_NE_ID into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select ne_SUB_TYPE into s_desc from nm_elements where ne_id = n_temp;
	When 'RT_DESCR'
		then			
		select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select ne_DESCR into s_desc from nm_elements where ne_id = n_temp;
	When 'GOV_LEVEL'
		then			
		select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select SUBSTR(NE_Owner, 1, 2) into s_desc from nm_elements where ne_id = n_temp;
	Else
		s_desc := null;
	end case;
	
	return s_desc;
	
     exception when others then
     return null;
   end;
/


















CREATE OR REPLACE function x_OPBD_LOOKUP_NUM (p_what varchar2, p_job_id number, p_section_ID  number) return number
   is
   n_temp number(8);
   n_temp_dp number(8,2);
   n_desc number;
   begin
   Case upper(p_what)
	When 'BMP' then 
	select NMS_BEGIN_OFFSET  into n_temp_dp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
     
     return n_temp_dp;
	When 'EMP' then
	select NMS_END_OFFSET  into n_temp_dp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
     
     return n_temp_dp;

	When 'COUNTY_CODE' 
		then
			select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;
			select  c.nm_ne_id_in into n_temp   from nm_members c, nm_members d
				where 1=1
				and d.nm_ne_id_of=c.nm_ne_id_in
				and c.nm_obj_type = 'ARTC'
				and d.nm_obj_type = 'ARTD'
				and C.NM_NE_ID_OF = n_temp;
				
			select to_number(ne_unique) into n_desc from nm_elements where ne_id = n_temp;
	When 'ROUTE' then
			select NMS_OFFSET_NE_ID into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;

			select ne_NAME_2 into n_desc from nm_elements where ne_id = n_temp;
     return n_desc;
	
	When 'ROUTE_SECTION' then 
			select NMS_OFFSET_NE_ID  into n_temp from V_MRG_TYPEOP_BD where rownum = 1 and nqr_mrg_job_id = p_job_id and nms_mrg_section_id = p_section_ID;

			select ne_VERSION_NO into n_desc from nm_elements where ne_id = n_temp;
     return n_desc;
    else
		return null;
	end case;
	return n_desc;
     exception when others then
     return null;
   end;
/