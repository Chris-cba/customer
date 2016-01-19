create or replace package body xodot_signs_api as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.

	This packages is dependant on a package: xlog_file for debugging purposes
		
	file: xodot_signs_api
	Author: JMM
	UPDATE01:	Original, 2015.03.09, JMM
*/
	--g_sign_asset_list varchar2(2000):= 'SCNS';
	g_sign_asset_list varchar2(2000)	:= 'SNIN,SNSN,SNSU,SNML';
	g_route_ne_nt_type varchar(4)		:= 'HWY';
	g_inv_admin_unit number(5)			:= 3;
	
function find_ea_from_crew_number(s_crew_number in varchar2) return varchar2 is	---------------------------------------------------------------------------------------
	/*
		This Function is used to find the EA number of the crew.  It returns a comma separated list of EA numbers for the imputed crew number
	*/
	cursor c_ea_list(s_crew_number varchar2)  is 
			select el_ea.ne_unique ea from 
				nm_elements el_cw
				,nm_members mem_cw
				,nm_elements el_ea
			where 1=1
				and el_cw.ne_unique = s_crew_number
				and el_cw.ne_type = 'P'
				and el_cw.ne_nt_type = 'SNCW'
				and el_cw.ne_id = mem_cw.nm_ne_id_in  
				and mem_cw.nm_ne_id_of = el_ea.ne_id;
	
	s_output varchar2(2000) := null;
	
	begin
		for r_row in c_ea_list(s_crew_number) loop
			s_output := s_output || r_row.ea || ',';
		end loop;
		
		if s_output is null then s_output := 'N/A'; end if;
		
		s_output := rtrim(s_output,',');
		
		return s_output;
end find_ea_from_crew_number;	---------------------------------------------------------------------------------------

--THis function deletes asset children without end dating them. 
function delete_child_asset(n_parent_ne_id number, s_asset_type varchar2) return varchar2 is	---------------------------------------------------------------------------------------
	s_return varchar2(50) := null;
	begin
		delete nm_inv_item_groupings_all 
			where iig_item_id in (select iit_ne_id from nm_inv_items_all where iit_foreign_key = n_parent_ne_id and iit_inv_type = s_asset_type);
		delete nm_inv_items_all
			where iit_foreign_key = n_parent_ne_id and iit_inv_type = s_asset_type;
		
		return s_return;
end delete_child_asset;	---------------------------------------------------------------------------------------

procedure get_task_list_sign_assets(s_crew_number in varchar2,  d_last_sync_date in date, output_list out xodot_signs_task_list) is---------------------------------------------------------------------------------------
	/*
		This procedure retrieves a list and count of Sign asset objects that need updating, both parent and children for a specific sign crew.
	
	s_crew_number varchar2(80)
	*/
	cursor c_asset_list(s_asset_list varchar2, s_ea_list varchar2, d_sync_date date) is
		select mem_inv_on_datum.nm_obj_type asset, count(*) cnt from 
            		nm_members mem_inv_ea
            		, (                    
                    	select * from nm_inv_items_all where iit_inv_type = 'SGNS'
							and iit_itemcode in  
                            	(    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_ea_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                                        
                                        ) b 
                    , nm_members_all mem_inv_on_datum
                    , nm_inv_items_all inv_on_datum
				where 1=1
				and 	b.iit_ne_id = mem_inv_ea.nm_ne_id_in 
                and     mem_inv_ea.nm_ne_id_of =  mem_inv_on_datum.nm_ne_id_of 
                --and 	mem_inv_on_datum.nm_type = 'I'                 
                and   	mem_inv_on_datum.nm_obj_type in  (    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_asset_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                 
                and 	inv_on_datum.iit_ne_id = mem_inv_on_datum.nm_ne_id_in                
                and 	(mem_inv_on_datum.nm_date_modified > d_sync_date OR inv_on_datum.iit_date_modified > d_sync_date)
                group by mem_inv_on_datum.nm_obj_type;
				
	cursor c_ch_asset_list(s_asset_list varchar2, s_ea_list varchar2, d_sync_date date) is
		select ch.iit_inv_type asset, count(*) cnt from 
			(select inv_on_datum.iit_ne_id from 
            		nm_members mem_inv_ea
            		, (                    
                    	select * from nm_inv_items_all where iit_inv_type = 'SGNS'
							and iit_itemcode in  
                            	(    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_ea_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                                        
                                        ) b 
                    , nm_members_all mem_inv_on_datum
                    , nm_inv_items_all inv_on_datum
				where 1=1
				and 	b.iit_ne_id = mem_inv_ea.nm_ne_id_in 
                and     mem_inv_ea.nm_ne_id_of =  mem_inv_on_datum.nm_ne_id_of 
                --and 	mem_inv_on_datum.nm_type = 'I'                 
                and   	mem_inv_on_datum.nm_obj_type in  (    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_asset_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                 
                and 	inv_on_datum.iit_ne_id = mem_inv_on_datum.nm_ne_id_in) p
				, NM_INV_ITEM_GROUPINGS gr 
				,nm_inv_items_all ch
				where 1=1
				and ch.iit_ne_id = gr.iig_item_id
				and iig_parent_id = p.iit_ne_id
				and ch.IIT_date_modified >d_sync_date
            group by ch.iit_inv_type;
                
	
	r_output xodot_signs_task_list := xodot_signs_task_list();
	s_ea_list varchar2(2000) := 'N/A';
	begin
		s_ea_list := find_ea_from_crew_number(s_crew_number);
		if s_ea_list <> 'N/A' then
			for r_row in c_asset_list(g_sign_asset_list,s_ea_list,d_last_sync_date) loop
				r_output.extend(1);
				r_output(r_output.count) := xodot_signs_task_list_row(null,null);
				
				r_output(r_output.count).asset := r_row.asset;
				r_output(r_output.count).cnt := r_row.cnt;				
			end loop;
			
			for r_row in c_ch_asset_list(g_sign_asset_list,s_ea_list,d_last_sync_date) loop
				r_output.extend(1);
				r_output(r_output.count) := xodot_signs_task_list_row(null,null);
				
				r_output(r_output.count).asset := r_row.asset;
				r_output(r_output.count).cnt := r_row.cnt;				
			end loop;
		end if;
		
		if r_output.count = 0 then 
				r_output.extend(1);
				r_output(r_output.count) := xodot_signs_task_list_row(null,null);
				
				r_output(r_output.count).asset := '-ERR';
				r_output(r_output.count).cnt := -99;
		end if;
		
		
		
		output_list := r_output;

end get_task_list_sign_assets; ---------------------------------------------------------------------------------------------------------------------------

/*
	Used for: operations to the asset type SNIN, Sign Installations.  This is need so that special error logging can occur
*/
procedure snin_opps				( t_result 				out		xodot_signs_asset_op
								, s_Operation			in		varchar2 -- Expects: I = Insert, U = Update, E = End Date
								, p_iit_ne_id			in 		number 										default null 
								--Insertion Information
								, p_effective_date		IN 		DATE 										DEFAULT nm3user.get_effective_date
								, p_admin_unit			IN 		nm_inv_items_all.iit_admin_unit%TYPE  		DEFAULT NULL
								, p_x_sect				IN		nm_inv_items_all.iit_x_sect%TYPE  			DEFAULT NULL
								, p_descr 				IN		nm_inv_items_all.iit_descr%TYPE 			DEFAULT NULL
								, p_note  				IN		nm_inv_items_all.iit_note%TYPE 				DEFAULT NULL
								
								, pf_loc_note          	IN		nm_inv_items_all.iit_chr_attrib27%TYPE 		DEFAULT NULL
								, pf_city_rd_flg    	IN		nm_inv_items_all.iit_chr_attrib28%TYPE 		DEFAULT NULL
								, pf_cnty_rd_flg    	IN		nm_inv_items_all.iit_chr_attrib29%TYPE 		DEFAULT NULL
								, pf_off_netwrk_note	IN		nm_inv_items_all.iit_chr_attrib66%TYPE 		DEFAULT NULL
								, pf_dstnc_from_pvmt	IN		nm_inv_items_all.iit_distance%TYPE 			DEFAULT NULL
								, pf_lat            	IN		nm_inv_items_all.iit_num_attrib100%TYPE 	DEFAULT NULL
								, pf_longtd         	IN		nm_inv_items_all.iit_num_attrib101%TYPE 	DEFAULT NULL
								--Location Information
								, s_LRM					IN		nm_elements.ne_unique%TYPE 					default null
								, n_MP					in		nm_members_all.NM_SLK%TYPE					default null
								) is
	
	
	s_return_val xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	n_ne_id number(8);
	
	function change_att_val(n_ne_id number, col varchar2, inputval varchar2) return varchar2 is
		begin
			if inputval is null then
				return nm3inv.get_attrib_value(n_ne_id,upper(col));
			else
				return inputval;
			end if;
	end change_att_val;
	
	begin

		
		nm3user.set_effective_date( p_effective_date);
		
		case upper(s_operation)
			when 'I' then
				-- We need to verify the location and get the element ne_id and MP type
				 n_ne_id:= nm3api_inv_snin.ins (
							p_effective_date        		=> nm3user.get_effective_date
							,p_admin_unit                   => g_inv_admin_unit
							,p_x_sect                       => p_x_sect
							,p_descr                        => p_descr
							,p_note                         => p_note
							-- <FLEXIBLE ATTRIBUTES>        =>
							,pf_loc_note                    => pf_loc_note
							,pf_city_rd_flg                 => pf_city_rd_flg
							,pf_cnty_rd_flg                 => pf_cnty_rd_flg
							,pf_off_netwrk_note             => pf_off_netwrk_note
							,pf_dstnc_from_pvmt             => pf_dstnc_from_pvmt
							,pf_lat                         => pf_lat
							,pf_longtd                      => pf_longtd
							-- </FLEXIBLE ATTRIBUTES>
							-- <LOCATION DETAILS>
							,p_element_ne_unique            =>     s_lrm
							,p_element_ne_nt_type           =>     g_route_ne_nt_type
							,p_element_mp                   =>     n_MP
							-- </LOCATION DETAILS>
							);
				--xodot_signs_logging.log_exception('Joe', 'Joe' ,'Joe',0,00000,nm3user.get_effective_date);
				--xodot_signs_logging.log_exception('Joe', 'Joe' ,'Joe',0,00000,p_effective_date);		
			when 'U'  then
				n_ne_id:= p_iit_ne_id;
				nm3api_inv_snin.date_track_upd_attr (
								p_iit_ne_id 					=>n_ne_id
                              ,p_effective_date              	=> nm3user.get_effective_date
                              -- <FLEXIBLE ATTRIBUTES>
                              ,pf_loc_note                    	=> change_att_val(p_iit_ne_id, 'iit_chr_attrib27', pf_loc_note)    
                              ,pf_city_rd_flg                 	=> change_att_val(p_iit_ne_id, 'iit_chr_attrib28', pf_city_rd_flg)    
                              ,pf_cnty_rd_flg                 	=> change_att_val(p_iit_ne_id, 'iit_chr_attrib29', pf_cnty_rd_flg)    
                              ,pf_off_netwrk_note             	=> change_att_val(p_iit_ne_id, 'iit_chr_attrib66', pf_off_netwrk_note)    
                              ,pf_dstnc_from_pvmt             	=> change_att_val(p_iit_ne_id, 'iit_distance'	 , pf_dstnc_from_pvmt)     	
                              ,pf_lat                         	=> change_att_val(p_iit_ne_id, 'iit_num_attrib100',pf_lat)   
                              ,pf_longtd                      	=> change_att_val(p_iit_ne_id, 'iit_num_attrib101',pf_longtd)   
                              -- </FLEXIBLE ATTRIBUTES>
                              );
			when 'E'  then
				nm3api_inv.end_date_item(
							p_iit_ne_id 						=> p_iit_ne_id
							,p_effective_date					=> nm3user.get_effective_date
							);
		end case;
		
		--(ne_id number(10), err_num number, err_msg varchar2(500)
		s_return_val.ne_id := n_ne_id;
		s_return_val.err_num := null;
		s_return_val.err_msg := null;
		
		t_result := s_return_val;
		
		nm3user.set_effective_date( trunc(sysdate));
		
	exception when others then
		null;  -- need error logging code
		
		s_return_val.ne_id := -999;
		s_return_val.err_num := SQLCODE;
		s_return_val.err_msg := substr(SQLERRM,1,500);
		
		xodot_signs_logging.log_exception(p_iit_ne_id, p_iit_ne_id ,s_LRM,n_MP,SQLCODE,'SNIN: ' || substr(SQLERRM,1,244));
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
end snin_opps;

/*
	Used for: operations to the asset type SNSN, Sign "Signs" (Panels).  This is need so that special error logging can occur
*/

PROCEDURE snsn_opps 			(t_result 						out		xodot_signs_asset_op
								,s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
								,p_iit_ne_id					in 		number 	-- THis is the Parent NE_ID			
								---AssetInformation
								,p_effective_date				IN		nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date								
								,p_x_sect						IN		nm_inv_items_all.iit_x_sect%TYPE DEFAULT NULL 
								,p_descr						IN		nm_inv_items_all.iit_descr%TYPE DEFAULT NULL 
								,p_note							IN		nm_inv_items_all.iit_note%TYPE DEFAULT NULL 
								--<FLEXIBLEATTRIBUTES>		
								,pf_sign_typ					IN		nm_inv_items_all.iit_chr_attrib26%TYPE DEFAULT NULL 								
								,pf_std_sign_id					IN		nm_inv_items_all.iit_chr_attrib27%TYPE DEFAULT NULL 
								,pf_fail_flg					IN		nm_inv_items_all.iit_chr_attrib28%TYPE DEFAULT NULL 
								,pf_facing_dir					IN		nm_inv_items_all.iit_chr_attrib29%TYPE DEFAULT NULL 
								,pf_sbstr						IN		nm_inv_items_all.iit_chr_attrib30%TYPE DEFAULT NULL 
								,pf_sheeting					IN		nm_inv_items_all.iit_chr_attrib31%TYPE DEFAULT NULL 
								,pf_soi_flg						IN		nm_inv_items_all.iit_chr_attrib32%TYPE DEFAULT NULL 
								,pf_custom_lgnd					IN		nm_inv_items_all.iit_chr_attrib66%TYPE DEFAULT NULL 
								,pf_custom_pic_path				IN		nm_inv_items_all.iit_chr_attrib67%TYPE DEFAULT NULL 
								,pf_est_rplcmnt_dt				IN		nm_inv_items_all.iit_date_attrib86%TYPE DEFAULT NULL 
								,pf_insp_dt						IN		nm_inv_items_all.iit_date_attrib87%TYPE DEFAULT NULL 
								,pf_install_dt					IN		nm_inv_items_all.iit_instal_date%TYPE DEFAULT NULL 
								--,pf_custom_lgnd_id				IN		nm_inv_items_all.iit_num_attrib100%TYPE DEFAULT NULL 
								,pf_custom_wd					IN		nm_inv_items_all.iit_num_attrib101%TYPE DEFAULT NULL 
								,pf_custom_ht					IN		nm_inv_items_all.iit_num_attrib102%TYPE DEFAULT NULL 
								,pf_recyc_cnt					IN		nm_inv_items_all.iit_num_attrib103%TYPE DEFAULT NULL 
								) is
	s_return_val xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	n_ne_id number(8);
	s_temp varchar2(50);
	
	Begin
		-- Need a delete and insert new functionality
		nm3user.set_effective_date( p_effective_date);
		
		case upper(s_operation)
			when 'I' then
				n_ne_id := nm3api_inv_snsn.ins (
								p_effective_date                =>		nm3user.get_effective_date
								,p_admin_unit                   =>		g_inv_admin_unit
								--,p_x_sect                       =>		p_x_sect
								,p_descr                        =>		p_descr
								,p_note                         =>		p_note
								,pf_iit_fk						=> 		p_iit_ne_id
								-- <FLEXIBLE ATTRIBUTES>        =>		
								,pf_sign_typ                    =>		pf_sign_typ
								,pf_std_sign_id                 =>		pf_std_sign_id
								,pf_fail_flg                    =>		pf_fail_flg		
								,pf_facing_dir                  =>		pf_facing_dir		
								,pf_sbstr                       =>		pf_sbstr			
								,pf_sheeting                    =>		pf_sheeting		
								,pf_soi_flg                     =>		pf_soi_flg			
								,pf_custom_lgnd                 =>		pf_custom_lgnd		
								,pf_custom_pic_path             =>		pf_custom_pic_path	
								,pf_est_rplcmnt_dt              =>		pf_est_rplcmnt_dt	
								,pf_insp_dt                     =>		pf_insp_dt			
								,pf_install_dt                  =>		pf_install_dt		
								--,pf_custom_lgnd_id              =>		pf_custom_lgnd_id	
								,pf_custom_wd                   =>		pf_custom_wd		
								,pf_custom_ht                   =>		pf_custom_ht		
								,pf_recyc_cnt                   =>		pf_recyc_cnt		
								);
			when 'D' then                                               
				s_temp := delete_child_asset(p_iit_ne_id, 'SNSN');
		end case;
		
		
		s_return_val.ne_id := n_ne_id;  -- I don't need this with the child
		s_return_val.err_num := null;
		s_return_val.err_msg := null;
		
		t_result := s_return_val;
		
		nm3user.set_effective_date( trunc(sysdate));
		
		
	exception when others then
		null;  -- need error logging code
		
		s_return_val.ne_id := -999;
		s_return_val.err_num := SQLCODE;
		s_return_val.err_msg := substr(SQLERRM,1,500);
		
		xodot_signs_logging.log_exception(p_iit_ne_id, p_iit_ne_id ,null,null,SQLCODE,substr(SQLERRM,1,250));
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
end snsn_opps;

/*
	Used for: operations to the asset type SNSU, Sign supports.  This is need so that special error logging can occur
*/

PROCEDURE snsu_opps 			(t_result 						out		xodot_signs_asset_op
								,s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
								,p_iit_ne_id					in 		number 	-- This is the Parent NE_ID			
								---AssetInformation
								,p_effective_date               IN     nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
								,p_admin_unit                   IN     nm_inv_items_all.iit_admin_unit%TYPE default null
								,p_x_sect                       IN     nm_inv_items_all.iit_x_sect%TYPE default null
								,p_descr                        IN     nm_inv_items_all.iit_descr%TYPE DEFAULT NULL
								,p_note                         IN     nm_inv_items_all.iit_note%TYPE DEFAULT NULL
								-- <FLEXIBLE ATTRIBUTES>
								,pf_supp_typ                    IN     nm_inv_items_all.iit_chr_attrib26%TYPE  DEFAULT NULL
								,pf_install_dt                  IN     nm_inv_items_all.iit_instal_date%TYPE  DEFAULT NULL
								,pf_no_supps                    IN     nm_inv_items_all.iit_no_of_units%TYPE  DEFAULT NULL								
								) is
	s_return_val xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	n_ne_id number(8);
	s_temp varchar2(50);
	Begin
		-- Need a delete and insert new functionality
		nm3user.set_effective_date( p_effective_date);
		
		case upper(s_operation)
			when 'I' then
				n_ne_id := nm3api_inv_snsu.ins (
							p_effective_date               	=>		nm3user.get_effective_date
							,p_admin_unit                   =>		g_inv_admin_unit
							--,p_x_sect                       =>		p_x_sect
							,p_descr                        =>		p_descr
							,p_note                         =>		p_note
							,pf_iit_fk						=> 		p_iit_ne_id
							-- <FLEXIBLE ATTRIBUTES>        	
							,pf_supp_typ                    =>		pf_supp_typ
							,pf_install_dt                  =>		pf_install_dt
							,pf_no_supps                    =>		pf_no_supps
							-- </FLEXIBLE ATTRIBUTES>
							);
			when 'D' then                                               
				s_temp := delete_child_asset(p_iit_ne_id, 'SNSU');
		end case;
		
		
		s_return_val.ne_id := n_ne_id;  -- I don't need this with the child
		s_return_val.err_num := null;
		s_return_val.err_msg := null;
		
		t_result := s_return_val;
		
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
		
	exception when others then
		null;  -- need error logging code
		
		s_return_val.ne_id := -999;
		s_return_val.err_num := SQLCODE;
		s_return_val.err_msg := substr(SQLERRM,1,500);
		
		xodot_signs_logging.log_exception(p_iit_ne_id, p_iit_ne_id ,null,null,SQLCODE,substr(SQLERRM,1,250));
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
end snsu_opps;

/*
	Used for: operations to the asset type SNSN, Sign "Signs" (Panels).  This is need so that special error logging can occur
*/

PROCEDURE snml_opps 			(t_result 						out		xodot_signs_asset_op
								,s_Operation					in		varchar2 -- Expects: I = Insert, D = Delete
								,p_iit_ne_id					in 		number 	-- This is the Parent NE_ID			
								---AssetInformation
								,p_effective_date               IN     nm_inv_items_all.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
								,p_admin_unit                   IN     nm_inv_items_all.iit_admin_unit%TYPE DEFAULT NULL
								,p_x_sect                       IN     nm_inv_items_all.iit_x_sect%TYPE DEFAULT NULL
								,p_descr                        IN     nm_inv_items_all.iit_descr%TYPE DEFAULT NULL
								,p_note                         IN     nm_inv_items_all.iit_note%TYPE DEFAULT NULL
								-- <FLEXIBLE ATTRIBUTES>
								,pf_actn                        IN     nm_inv_items_all.iit_chr_attrib26%TYPE DEFAULT NULL
								,pf_cause                       IN     nm_inv_items_all.iit_chr_attrib27%TYPE DEFAULT NULL
								,pf_sign_dtl                    IN     nm_inv_items_all.iit_chr_attrib28%TYPE DEFAULT NULL
								,pf_resp_per                    IN     nm_inv_items_all.iit_chr_attrib29%TYPE DEFAULT NULL
								,pf_sign_sz                     IN     nm_inv_items_all.iit_chr_attrib30%TYPE DEFAULT NULL
								,pf_sign_facing                 IN     nm_inv_items_all.iit_chr_attrib31%TYPE DEFAULT NULL
								,pf_sign_lgnd                   IN     nm_inv_items_all.iit_chr_attrib56%TYPE DEFAULT NULL
								,pf_comnt                       IN     nm_inv_items_all.iit_chr_attrib66%TYPE DEFAULT NULL
								,pf_matl                        IN     nm_inv_items_all.iit_chr_attrib67%TYPE DEFAULT NULL
								,pf_supp_desc                   IN     nm_inv_items_all.iit_chr_attrib70%TYPE DEFAULT NULL
								,pf_maint_hist_dt               IN     nm_inv_items_all.iit_date_attrib86%TYPE DEFAULT NULL
								,pf_accomp                      IN     nm_inv_items_all.iit_no_of_units%TYPE DEFAULT NULL
								,pf_crew_hr                     IN     nm_inv_items_all.iit_num_attrib100%TYPE DEFAULT NULL
								,pf_equip_hr                    IN     nm_inv_items_all.iit_num_attrib101%TYPE DEFAULT NULL
								) is
	s_return_val xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	n_ne_id number(8);
	s_temp varchar2(50);
	Begin
		-- Need a delete and insert new functionality
		nm3user.set_effective_date( p_effective_date);
		
		case upper(s_operation)
			when 'I' then
				n_ne_id := nm3api_inv_snml.ins (
					p_effective_date        		=>		nm3user.get_effective_date
					,p_admin_unit           		=>		g_inv_admin_unit
					--,p_x_sect               		=>		p_x_sect
					,p_descr                		=>		p_descr
					,p_note                 		=>		p_note
					,pf_iit_fk						=> 		p_iit_ne_id
					-- <FLEXIBLE ATTRIBUTES>		
					,pf_actn                		=>		pf_actn          
					,pf_cause               		=>		pf_cause         
					,pf_sign_dtl            		=>		pf_sign_dtl      
					,pf_resp_per            		=>		pf_resp_per      
					,pf_sign_sz             		=>		pf_sign_sz       
					,pf_sign_facing         		=>		pf_sign_facing   
					,pf_sign_desc           		=>		pf_sign_lgnd     
					,pf_comnt               		=>		pf_comnt         
					,pf_matl                		=>		pf_matl          
					--,pf_sign_desc           		=>		pf_supp_desc     
					,pf_hist_dt       				=>		pf_maint_hist_dt 
					,pf_accomp              		=>		pf_accomp        
					,pf_crew_hr             		=>		pf_crew_hr       
					,pf_equip_hr            		=>		pf_equip_hr      
							);
			when 'D' then                                               
				s_temp := delete_child_asset(p_iit_ne_id, 'SNML');
		end case;
		
		
		s_return_val.ne_id := n_ne_id;  -- I don't need this with the child
		s_return_val.err_num := null;
		s_return_val.err_msg := null;
		
		t_result := s_return_val;
		
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
		
	exception when others then
		null;  -- need error logging code
		
		s_return_val.ne_id := -999;
		s_return_val.err_num := SQLCODE;
		s_return_val.err_msg := substr(SQLERRM,1,500);
		
		xodot_signs_logging.log_exception(p_iit_ne_id, p_iit_ne_id ,null,null,SQLCODE,substr(SQLERRM,1,250));
		nm3user.set_effective_date( trunc(sysdate));
		t_result := s_return_val;
end snml_opps;


procedure get_sign_assets(s_crew_number varchar2, s_asset_type in varchar2, d_date_last_synced in date, ref_cur out sys_refcursor) is
	-- This returns a ref cursor of the changes for an asset since a date
	s_ea_list varchar2(2000) := 'N/A';
	begin
		s_ea_list := find_ea_from_crew_number(s_crew_number);
	/*	
		open ref_cur for
			select distinct inv_on_datum.* from 
            		nm_members_all mem_inv_ea
            		, (                    
                    	select * from nm_inv_items_all where iit_inv_type = 'SCNS'
							and iit_itemcode in  
                            	(    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_ea_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                                        
                                        ) b 
                    , nm_members_all mem_inv_on_datum
                    , nm_inv_items_all inv_on_datum
				where 1=1
				and 	b.iit_ne_id = mem_inv_ea.nm_ne_id_in 
                and     mem_inv_ea.nm_ne_id_of =  mem_inv_on_datum.nm_ne_id_of 
                and 	mem_inv_on_datum.nm_type = 'I'                 
                and   	mem_inv_on_datum.nm_obj_type in  (s_asset_type) 
                and 	inv_on_datum.iit_ne_id = mem_inv_on_datum.nm_ne_id_in 
                and 	(mem_inv_on_datum.nm_date_modified > d_date_last_synced OR inv_on_datum.iit_date_modified > d_date_last_synced)
				*/
				-- breaking it into 2, b/c hat OR was slowing it down
			open ref_cur for
			select distinct * from (
			select inv_on_datum.* from 
            		nm_members_all mem_inv_ea
            		, (                    
                    	select * from nm_inv_items_all where iit_inv_type = 'SGNS'
							and iit_itemcode in  
                            	(    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_ea_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                                        
                                        ) b 
                    , nm_members_all mem_inv_on_datum
                    , nm_inv_items_all inv_on_datum
				where 1=1
				and 	b.iit_ne_id = mem_inv_ea.nm_ne_id_in 
                and     mem_inv_ea.nm_ne_id_of =  mem_inv_on_datum.nm_ne_id_of 
                --and 	mem_inv_on_datum.nm_type = 'I'                 
                and   	mem_inv_on_datum.nm_obj_type in  (s_asset_type) 
                and 	inv_on_datum.iit_ne_id = mem_inv_on_datum.nm_ne_id_in 
				and 	inv_on_datum.iit_inv_type = s_asset_type
                and 	(mem_inv_on_datum.nm_date_modified > d_date_last_synced)
			union all
			select inv_on_datum.* from 
            		nm_members_all mem_inv_ea
            		, (                    
                    	select * from nm_inv_items_all where iit_inv_type = 'SGNS'
							and iit_itemcode in  
                            	(    --THis XML sting converts a comma separated list to a table                
                            	SELECT to_char(trim(EXTRACT(column_value,'/e/text()'))) myrow from (select  s_ea_list col1 from dual) x,
                            	TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
                        				)                                        
                                        ) b 
                    , nm_members_all mem_inv_on_datum
                    , nm_inv_items_all inv_on_datum
				where 1=1
				and 	b.iit_ne_id = mem_inv_ea.nm_ne_id_in 
                and     mem_inv_ea.nm_ne_id_of =  mem_inv_on_datum.nm_ne_id_of 
                --and 	mem_inv_on_datum.nm_type = 'I'                 
                and   	mem_inv_on_datum.nm_obj_type in  (s_asset_type)
				and 	inv_on_datum.iit_inv_type = s_asset_type				
                and 	inv_on_datum.iit_ne_id = mem_inv_on_datum.nm_ne_id_in 
                and 	(inv_on_datum.iit_date_modified > d_date_last_synced)
				)
                ;
	
end get_sign_assets;

procedure get_asset_lov(s_asset varchar2, d_date_last_synced date, info out xodot_signs_asset_op, ref_cur out sys_refcursor) is
	s_info xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	n_count number := 0;
	begin
		select count(*) into n_count from nm_inv_items_all where iit_inv_type = s_asset and iit_date_modified >= d_date_last_synced;
		
		s_info.ne_id := n_count;
		s_info.err_num := null;
		s_info.err_msg := null;
		
		if n_count >0 then
			open ref_cur for
				select iit_inv_type, iit_end_date
					,IIT_CHR_ATTRIB26
					,IIT_CHR_ATTRIB27
					,IIT_CHR_ATTRIB28
					,IIT_CHR_ATTRIB29
					,IIT_CHR_ATTRIB30
					,IIT_CHR_ATTRIB31
					,IIT_CHR_ATTRIB32
					,IIT_CHR_ATTRIB33
					,IIT_CHR_ATTRIB56
					,IIT_CHR_ATTRIB57
					,IIT_NUM_ATTRIB16
					,IIT_NUM_ATTRIB17
					,IIT_NUM_ATTRIB100
					,IIT_NUM_ATTRIB101
					,IIT_NUM_ATTRIB102
					,IIT_NUM_ATTRIB103
					from nm_inv_items_all
					where iit_inv_type = s_asset;
		else
			open ref_cur for 
				select 'NO_CHANGE' from dual;
		end if;
		
	exception when others then
		null;  -- need error logging code
		
		s_info.ne_id := -999;
		s_info.err_num := SQLCODE;
		s_info.err_msg := substr(SQLERRM,1,500);
		
		info := s_info;
		
		xodot_signs_logging.log_exception(null, null ,null,null,SQLCODE,substr(SQLERRM,1,250));
		
		
end get_asset_lov;

procedure get_domain_lov(s_domain in varchar2, info out xodot_signs_asset_op, ref_cur out sys_refcursor ) is
	n_count number := 0;
	s_info xodot_signs_asset_op := xodot_signs_asset_op(null,null,null);
	begin
		select count(*) into n_count from NM_INV_ATTRI_LOOKUP where ial_domain =s_domain;
		
		s_info.ne_id := n_count;
		s_info.err_num := null;
		s_info.err_msg := null;
		
		if n_count >0 then
			open ref_cur for
				select ial_value, ial_meaning from NM_INV_ATTRI_LOOKUP
				where ial_domain =s_domain
				order by ial_seq
				; 
		end if;
	exception when others then
		null;  -- need error logging code
		
		s_info.ne_id := -999;
		s_info.err_num := SQLCODE;
		s_info.err_msg := substr(SQLERRM,1,500);
		
		info := s_info;
		
		xodot_signs_logging.log_exception(null, null ,null,null,SQLCODE,substr(SQLERRM,1,250));
end get_domain_lov;

procedure get_mem_location_from_ne_id(n_ne_id in number, ref_cur out sys_refcursor) is
	begin
		open ref_cur for
			select ne_loc.ne_unique, ne_owner hwy_num, ne_name_1 MT , ne_name_2 overlap_code,ne_prefix roadway_ID ,ne_number gen_direct ,ne_sub_type link_id , nm_loc.* 
			from nm_members nm_in
				,(select iit_ne_id from v_nm_snin where iit_ne_id = n_ne_id) inv
				, nm_members nm_loc
				, nm_elements ne_loc
			where 1=1
				and nm_loc.nm_TYPE = 'G' and nm_loc.nm_OBJ_TYPE = 'HWY'
				and nm_in.nm_ne_id_in = inv.iit_ne_id
				and nm_in.nm_ne_id_of = nm_loc.nm_ne_id_of 
				and ne_loc.ne_id = nm_loc. nm_ne_id_in;
	end get_mem_location_from_ne_id;

procedure get_child_from_parent_ne_id(n_ne_id in number, s_child_type varchar2, ref_cur out sys_refcursor) is	
	begin
		open ref_cur for
		select a.* from nm_inv_items a, NM_INV_ITEM_GROUPINGS 
		where iit_inv_type = s_child_type
		and iit_ne_id = iig_item_id
		and iig_parent_id = n_ne_id;
end get_child_from_parent_ne_id;


procedure get_simple_report_lookup(s_report in varchar2,s_crew varchar2, s_district varchar2, b_crew_only  varchar2,  d_last_sync_date date  default sysdate , ref_cur out sys_refcursor) is
	s_sql  varchar2(2000);
	s_where_replace  varchar2(300) := ' ';
	s_crew_type  varchar2(8) := 'SNCW';
	n_count number;
	begin
		case upper(s_report)
			when 'TBLHIGHWAYEA' then
				s_sql := 'select * from reports.TIODS_MAINT_HIER a where crew_typ = '''|| s_crew_type || ''' and (#CREW#)';
				if upper(b_crew_only) = 'TRUE' then
					s_where_replace := 'crew = ''' ||s_crew || '''';  
					
					
				else
					s_where_replace := 'dist = ''' || s_district || '''' || 'or crew = ''' ||s_crew || ''''; --'
				end if;
				s_sql := replace(s_sql, '#CREW#', s_where_replace);
			when 'TBLDISTRICTS' then
				s_sql := 'select distinct dist,reg from reports.TIODS_MAINT_HIER a where crew_typ = '''|| s_crew_type || ''' order by dist';
			
			when 'TBLHIGHWAYS' then
				s_sql := 'select  distinct substr(lrm_key,1,5) hwy, hwy_nm from  reports.TIODS_RTE_HWY_LOC where trunc(extrct_prc_dt) >=  '''|| trunc(d_last_sync_date) ||''' order by 1';
				
			when 'TBLROUTESINTERSTATE' then
				s_sql := 'select distinct IS_RTE from reports.TIODS_RTE_HWY_LOC where is_rte is not null and trunc(extrct_prc_dt) >=  '''|| trunc(d_last_sync_date) ||'''';
				
			when 'TBLROUTESUS' then
				s_sql := 'select distinct US_RTE_1 from reports.TIODS_RTE_HWY_LOC where US_RTE_1 is not null and trunc(extrct_prc_dt) >=  '''|| trunc(d_last_sync_date) ||'''';
				
			when 'TBLROUTESSTATE' then
				s_sql := 'select distinct OR_RTE_1 from reports.TIODS_RTE_HWY_LOC where OR_RTE_1  is not null and trunc(extrct_prc_dt) >=  '''|| trunc(d_last_sync_date) ||'''';
			when 'TBLMILEPOSTPREFIXES' then
				s_sql := q'[select distinct hco_code || nvl(ovlp_cd,0) MP_Prefix , case when hco_code = 'Z' then hco_meaning || ' Code ' ||ovlp_cd else hco_meaning end meaning from reports.TIODS_MP_HUND ,( select hco_code, hco_meaning from hig_codes where upper(hco_domain) = 'ODOT_MLGE_TYP' and nvl(hco_end_date,'12-DEC-9999') > NM3USER.GET_EFFECTIVE_DATE) where hco_code = mlge_typ(+) order by 1]';
				
			when 'TBLHWYGPSDATA' then
				-- This one is slightly more complicated, becuas eof the potential for a lot of date goign to see if wee need to update first.
				if upper(b_crew_only) = 'FALSE' then
					select count(*) into n_count from reports.TIODS_MP_HUND H ,reports.TIODS_MAINT_HIER MH --				
						where 1=1    and MH.CREW_TYP = s_crew_type  and h.lrm_key = mh.lrm_key   and h.mp between mh.beg_mp_no and mh.end_mp_no --
							and (dist = s_district or crew = s_crew)  and h.data_updt_dt >= d_last_sync_date and rownum <5;
				else
					select count(*) into n_count from reports.TIODS_MP_HUND H ,reports.TIODS_MAINT_HIER MH --				
						where 1=1    and MH.CREW_TYP = s_crew_type  and h.lrm_key = mh.lrm_key   and h.mp between mh.beg_mp_no and mh.end_mp_no --
							and (crew = s_crew)  and h.data_updt_dt >= d_last_sync_date and rownum <5;
				end if;
				
				if n_count = 0 then 
					s_sql := 'select ''NO_DATA'' from dual';
				else
					s_sql := 'select h.lrm_key  ,hwy_no ,h.rdwy_id   ,h.mlge_typ ,h.ovlp_cd ,h.MP ,h.rdwy_typ ,h.lat ,h.longtd   ,h.extrct_prc_dt ';  --Cols
					s_sql := s_sql || ' from   reports.TIODS_MP_HUND H ,reports.TIODS_MAINT_HIER MH ';  --from
					s_sql := s_sql || q'[ where 1=1 and MH.CREW_TYP = '#s_crew#' and h.lrm_key = mh.lrm_key and h.mp between mh.beg_mp_no and mh.end_mp_no ]' ; -- where1
					s_sql := s_sql || q'[ and (dist = '#dist#' or crew = '#crew#') and h.data_updt_dt >= '#date#' order by h.lrm_key, h.mp]'; --where 2
					
					--replace the text variables
					s_sql := replace(s_sql,'#s_crew#',s_crew_type);
					s_sql := replace(s_sql,'#dist#',s_district);
					s_sql := replace(s_sql,'#crew#',s_crew);
					s_sql := replace(s_sql,'#date#',d_last_sync_date);
					
				end if;
				
    
			else
			
				s_sql :='select ''NO_DATA'' from dual';
				
			
		end case;
		
		open ref_cur for s_sql;
		
	
end get_simple_report_lookup;

procedure get_gen_dir_from_LRM(LRM varchar2, ref_cur out sys_refcursor) is
	/*
	Used for: retrieving the general direction of a hwy so mainly so that the correct XSP can be applied
*/
	
	n_count number;
		
	
	begin
		select count(*) into n_count from nm_elements where ne_nt_type = 'HWY' and ne_unique = LRM;
		
		if n_count = 1 then 
			open ref_cur for  select ne_number  from nm_elements where ne_nt_type = 'HWY' and ne_unique = LRM;
		else
			open ref_cur for select '-'  from dual;
		end if;
		
	
	
end get_gen_dir_from_LRM;

end xodot_signs_api;




/












