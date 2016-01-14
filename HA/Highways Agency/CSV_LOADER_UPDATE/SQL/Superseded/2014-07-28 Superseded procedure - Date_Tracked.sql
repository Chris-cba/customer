create or replace procedure x_ha_update_inv_item(p_row_in in v_ha_update_inv%rowtype) as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: x_ha_update_inv_item
	Author: JMM
	UPDATE01:	Original, 2014.07.21, JMM
	
	Condition to be aware of:  Excel is turning some dates to the year 1000, m3inv_update will tell you that the IIT_NE_ID is not found, 
		this is a fictitious error, check the dates in the csv file first.
*/

	r_inv_row 			nm_inv_items%rowtype;
	n_iit_ne_id 		number;
	l_rowid             ROWID;
	p_effective_date	date;
	ex_start_date		exception;
	begin
			p_effective_date := trunc(sysdate);
			
			
			nm_debug.proc_start('x_ha_update_inv_item','x_ha_update_inv_item');
--
			nm3user.set_effective_date (p_effective_date);
			
			n_iit_ne_id := to_number(p_row_in.iit_ne_id);
			
			--l_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => n_iit_ne_id);
			
--
			r_inv_row := nm3get.get_iit (pi_iit_ne_id => n_iit_ne_id);
			
			/* generated using:
				SELECT 
				lower('if  p_row_in.'|| column_name || ' is not null then r_inv_row.' || column_name || ' := p_row_in.'|| column_name || '; End if;')
				, a.*
				FROM   all_tab_cols a
				where owner = 'HIGHWAYS'
				and table_name = 'NM_INV_ITEMS'
				order by column_id
			*/
			
			
			
			--r_inv_row.iit_ne_id := null;
			--if  p_row_in.iit_inv_type is not null then r_inv_row.iit_inv_type := p_row_in.iit_inv_type; end if;
			--r_inv_row.iit_primary_key := null; 
			if  p_row_in.iit_date_created is not null then r_inv_row.iit_date_created := p_row_in.iit_date_created; end if;
			if  p_row_in.iit_date_modified is not null then r_inv_row.iit_date_modified := p_row_in.iit_date_modified; end if;
			if  p_row_in.iit_created_by is not null then r_inv_row.iit_created_by := p_row_in.iit_created_by; end if;
			if  p_row_in.iit_modified_by is not null then r_inv_row.iit_modified_by := p_row_in.iit_modified_by; end if;
			if  p_row_in.iit_admin_unit is not null then r_inv_row.iit_admin_unit := p_row_in.iit_admin_unit; end if;
			if  p_row_in.iit_descr is not null then r_inv_row.iit_descr := p_row_in.iit_descr; end if;
			--if  p_row_in.iit_start_date is not null then r_inv_row.iit_start_date := p_row_in.iit_start_date; end if;
			if  p_row_in.iit_end_date is not null then r_inv_row.iit_end_date := p_row_in.iit_end_date; end if;
			if  p_row_in.iit_foreign_key is not null then r_inv_row.iit_foreign_key := p_row_in.iit_foreign_key; end if;
			if  p_row_in.iit_located_by is not null then r_inv_row.iit_located_by := p_row_in.iit_located_by; end if;
			if  p_row_in.iit_position is not null then r_inv_row.iit_position := p_row_in.iit_position; end if;
			if  p_row_in.iit_x_coord is not null then r_inv_row.iit_x_coord := p_row_in.iit_x_coord; end if;
			if  p_row_in.iit_y_coord is not null then r_inv_row.iit_y_coord := p_row_in.iit_y_coord; end if;
			if  p_row_in.iit_num_attrib16 is not null then r_inv_row.iit_num_attrib16 := p_row_in.iit_num_attrib16; end if;
			if  p_row_in.iit_num_attrib17 is not null then r_inv_row.iit_num_attrib17 := p_row_in.iit_num_attrib17; end if;
			if  p_row_in.iit_num_attrib18 is not null then r_inv_row.iit_num_attrib18 := p_row_in.iit_num_attrib18; end if;
			if  p_row_in.iit_num_attrib19 is not null then r_inv_row.iit_num_attrib19 := p_row_in.iit_num_attrib19; end if;
			if  p_row_in.iit_num_attrib20 is not null then r_inv_row.iit_num_attrib20 := p_row_in.iit_num_attrib20; end if;
			if  p_row_in.iit_num_attrib21 is not null then r_inv_row.iit_num_attrib21 := p_row_in.iit_num_attrib21; end if;
			if  p_row_in.iit_num_attrib22 is not null then r_inv_row.iit_num_attrib22 := p_row_in.iit_num_attrib22; end if;
			if  p_row_in.iit_num_attrib23 is not null then r_inv_row.iit_num_attrib23 := p_row_in.iit_num_attrib23; end if;
			if  p_row_in.iit_num_attrib24 is not null then r_inv_row.iit_num_attrib24 := p_row_in.iit_num_attrib24; end if;
			if  p_row_in.iit_num_attrib25 is not null then r_inv_row.iit_num_attrib25 := p_row_in.iit_num_attrib25; end if;
			if  p_row_in.iit_chr_attrib26 is not null then r_inv_row.iit_chr_attrib26 := p_row_in.iit_chr_attrib26; end if;
			if  p_row_in.iit_chr_attrib27 is not null then r_inv_row.iit_chr_attrib27 := p_row_in.iit_chr_attrib27; end if;
			if  p_row_in.iit_chr_attrib28 is not null then r_inv_row.iit_chr_attrib28 := p_row_in.iit_chr_attrib28; end if;
			if  p_row_in.iit_chr_attrib29 is not null then r_inv_row.iit_chr_attrib29 := p_row_in.iit_chr_attrib29; end if;
			if  p_row_in.iit_chr_attrib30 is not null then r_inv_row.iit_chr_attrib30 := p_row_in.iit_chr_attrib30; end if;
			if  p_row_in.iit_chr_attrib31 is not null then r_inv_row.iit_chr_attrib31 := p_row_in.iit_chr_attrib31; end if;
			if  p_row_in.iit_chr_attrib32 is not null then r_inv_row.iit_chr_attrib32 := p_row_in.iit_chr_attrib32; end if;
			if  p_row_in.iit_chr_attrib33 is not null then r_inv_row.iit_chr_attrib33 := p_row_in.iit_chr_attrib33; end if;
			if  p_row_in.iit_chr_attrib34 is not null then r_inv_row.iit_chr_attrib34 := p_row_in.iit_chr_attrib34; end if;
			if  p_row_in.iit_chr_attrib35 is not null then r_inv_row.iit_chr_attrib35 := p_row_in.iit_chr_attrib35; end if;
			if  p_row_in.iit_chr_attrib36 is not null then r_inv_row.iit_chr_attrib36 := p_row_in.iit_chr_attrib36; end if;
			if  p_row_in.iit_chr_attrib37 is not null then r_inv_row.iit_chr_attrib37 := p_row_in.iit_chr_attrib37; end if;
			if  p_row_in.iit_chr_attrib38 is not null then r_inv_row.iit_chr_attrib38 := p_row_in.iit_chr_attrib38; end if;
			if  p_row_in.iit_chr_attrib39 is not null then r_inv_row.iit_chr_attrib39 := p_row_in.iit_chr_attrib39; end if;
			if  p_row_in.iit_chr_attrib40 is not null then r_inv_row.iit_chr_attrib40 := p_row_in.iit_chr_attrib40; end if;
			if  p_row_in.iit_chr_attrib41 is not null then r_inv_row.iit_chr_attrib41 := p_row_in.iit_chr_attrib41; end if;
			if  p_row_in.iit_chr_attrib42 is not null then r_inv_row.iit_chr_attrib42 := p_row_in.iit_chr_attrib42; end if;
			if  p_row_in.iit_chr_attrib43 is not null then r_inv_row.iit_chr_attrib43 := p_row_in.iit_chr_attrib43; end if;
			if  p_row_in.iit_chr_attrib44 is not null then r_inv_row.iit_chr_attrib44 := p_row_in.iit_chr_attrib44; end if;
			if  p_row_in.iit_chr_attrib45 is not null then r_inv_row.iit_chr_attrib45 := p_row_in.iit_chr_attrib45; end if;
			if  p_row_in.iit_chr_attrib46 is not null then r_inv_row.iit_chr_attrib46 := p_row_in.iit_chr_attrib46; end if;
			if  p_row_in.iit_chr_attrib47 is not null then r_inv_row.iit_chr_attrib47 := p_row_in.iit_chr_attrib47; end if;
			if  p_row_in.iit_chr_attrib48 is not null then r_inv_row.iit_chr_attrib48 := p_row_in.iit_chr_attrib48; end if;
			if  p_row_in.iit_chr_attrib49 is not null then r_inv_row.iit_chr_attrib49 := p_row_in.iit_chr_attrib49; end if;
			if  p_row_in.iit_chr_attrib50 is not null then r_inv_row.iit_chr_attrib50 := p_row_in.iit_chr_attrib50; end if;
			if  p_row_in.iit_chr_attrib51 is not null then r_inv_row.iit_chr_attrib51 := p_row_in.iit_chr_attrib51; end if;
			if  p_row_in.iit_chr_attrib52 is not null then r_inv_row.iit_chr_attrib52 := p_row_in.iit_chr_attrib52; end if;
			if  p_row_in.iit_chr_attrib53 is not null then r_inv_row.iit_chr_attrib53 := p_row_in.iit_chr_attrib53; end if;
			if  p_row_in.iit_chr_attrib54 is not null then r_inv_row.iit_chr_attrib54 := p_row_in.iit_chr_attrib54; end if;
			if  p_row_in.iit_chr_attrib55 is not null then r_inv_row.iit_chr_attrib55 := p_row_in.iit_chr_attrib55; end if;
			if  p_row_in.iit_chr_attrib56 is not null then r_inv_row.iit_chr_attrib56 := p_row_in.iit_chr_attrib56; end if;
			if  p_row_in.iit_chr_attrib57 is not null then r_inv_row.iit_chr_attrib57 := p_row_in.iit_chr_attrib57; end if;
			if  p_row_in.iit_chr_attrib58 is not null then r_inv_row.iit_chr_attrib58 := p_row_in.iit_chr_attrib58; end if;
			if  p_row_in.iit_chr_attrib59 is not null then r_inv_row.iit_chr_attrib59 := p_row_in.iit_chr_attrib59; end if;
			if  p_row_in.iit_chr_attrib60 is not null then r_inv_row.iit_chr_attrib60 := p_row_in.iit_chr_attrib60; end if;
			if  p_row_in.iit_chr_attrib61 is not null then r_inv_row.iit_chr_attrib61 := p_row_in.iit_chr_attrib61; end if;
			if  p_row_in.iit_chr_attrib62 is not null then r_inv_row.iit_chr_attrib62 := p_row_in.iit_chr_attrib62; end if;
			if  p_row_in.iit_chr_attrib63 is not null then r_inv_row.iit_chr_attrib63 := p_row_in.iit_chr_attrib63; end if;
			if  p_row_in.iit_chr_attrib64 is not null then r_inv_row.iit_chr_attrib64 := p_row_in.iit_chr_attrib64; end if;
			if  p_row_in.iit_chr_attrib65 is not null then r_inv_row.iit_chr_attrib65 := p_row_in.iit_chr_attrib65; end if;
			if  p_row_in.iit_chr_attrib66 is not null then r_inv_row.iit_chr_attrib66 := p_row_in.iit_chr_attrib66; end if;
			if  p_row_in.iit_chr_attrib67 is not null then r_inv_row.iit_chr_attrib67 := p_row_in.iit_chr_attrib67; end if;
			if  p_row_in.iit_chr_attrib68 is not null then r_inv_row.iit_chr_attrib68 := p_row_in.iit_chr_attrib68; end if;
			if  p_row_in.iit_chr_attrib69 is not null then r_inv_row.iit_chr_attrib69 := p_row_in.iit_chr_attrib69; end if;
			if  p_row_in.iit_chr_attrib70 is not null then r_inv_row.iit_chr_attrib70 := p_row_in.iit_chr_attrib70; end if;
			if  p_row_in.iit_chr_attrib71 is not null then r_inv_row.iit_chr_attrib71 := p_row_in.iit_chr_attrib71; end if;
			if  p_row_in.iit_chr_attrib72 is not null then r_inv_row.iit_chr_attrib72 := p_row_in.iit_chr_attrib72; end if;
			if  p_row_in.iit_chr_attrib73 is not null then r_inv_row.iit_chr_attrib73 := p_row_in.iit_chr_attrib73; end if;
			if  p_row_in.iit_chr_attrib74 is not null then r_inv_row.iit_chr_attrib74 := p_row_in.iit_chr_attrib74; end if;
			if  p_row_in.iit_chr_attrib75 is not null then r_inv_row.iit_chr_attrib75 := p_row_in.iit_chr_attrib75; end if;
			if  p_row_in.iit_num_attrib76 is not null then r_inv_row.iit_num_attrib76 := p_row_in.iit_num_attrib76; end if;
			if  p_row_in.iit_num_attrib77 is not null then r_inv_row.iit_num_attrib77 := p_row_in.iit_num_attrib77; end if;
			if  p_row_in.iit_num_attrib78 is not null then r_inv_row.iit_num_attrib78 := p_row_in.iit_num_attrib78; end if;
			if  p_row_in.iit_num_attrib79 is not null then r_inv_row.iit_num_attrib79 := p_row_in.iit_num_attrib79; end if;
			if  p_row_in.iit_num_attrib80 is not null then r_inv_row.iit_num_attrib80 := p_row_in.iit_num_attrib80; end if;
			if  p_row_in.iit_num_attrib81 is not null then r_inv_row.iit_num_attrib81 := p_row_in.iit_num_attrib81; end if;
			if  p_row_in.iit_num_attrib82 is not null then r_inv_row.iit_num_attrib82 := p_row_in.iit_num_attrib82; end if;
			if  p_row_in.iit_num_attrib83 is not null then r_inv_row.iit_num_attrib83 := p_row_in.iit_num_attrib83; end if;
			if  p_row_in.iit_num_attrib84 is not null then r_inv_row.iit_num_attrib84 := p_row_in.iit_num_attrib84; end if;
			if  p_row_in.iit_num_attrib85 is not null then r_inv_row.iit_num_attrib85 := p_row_in.iit_num_attrib85; end if;
			if  p_row_in.iit_date_attrib86 is not null then r_inv_row.iit_date_attrib86 := p_row_in.iit_date_attrib86; end if;
			if  p_row_in.iit_date_attrib87 is not null then r_inv_row.iit_date_attrib87 := p_row_in.iit_date_attrib87; end if;
			if  p_row_in.iit_date_attrib88 is not null then r_inv_row.iit_date_attrib88 := p_row_in.iit_date_attrib88; end if;
			if  p_row_in.iit_date_attrib89 is not null then r_inv_row.iit_date_attrib89 := p_row_in.iit_date_attrib89; end if;
			if  p_row_in.iit_date_attrib90 is not null then r_inv_row.iit_date_attrib90 := p_row_in.iit_date_attrib90; end if;
			if  p_row_in.iit_date_attrib91 is not null then r_inv_row.iit_date_attrib91 := p_row_in.iit_date_attrib91; end if;
			if  p_row_in.iit_date_attrib92 is not null then r_inv_row.iit_date_attrib92 := p_row_in.iit_date_attrib92; end if;
			if  p_row_in.iit_date_attrib93 is not null then r_inv_row.iit_date_attrib93 := p_row_in.iit_date_attrib93; end if;
			if  p_row_in.iit_date_attrib94 is not null then r_inv_row.iit_date_attrib94 := p_row_in.iit_date_attrib94; end if;
			if  p_row_in.iit_date_attrib95 is not null then r_inv_row.iit_date_attrib95 := p_row_in.iit_date_attrib95; end if;
			if  p_row_in.iit_angle is not null then r_inv_row.iit_angle := p_row_in.iit_angle; end if;
			if  p_row_in.iit_angle_txt is not null then r_inv_row.iit_angle_txt := p_row_in.iit_angle_txt; end if;
			if  p_row_in.iit_class is not null then r_inv_row.iit_class := p_row_in.iit_class; end if;
			if  p_row_in.iit_class_txt is not null then r_inv_row.iit_class_txt := p_row_in.iit_class_txt; end if;
			if  p_row_in.iit_colour is not null then r_inv_row.iit_colour := p_row_in.iit_colour; end if;
			if  p_row_in.iit_colour_txt is not null then r_inv_row.iit_colour_txt := p_row_in.iit_colour_txt; end if;
			if  p_row_in.iit_coord_flag is not null then r_inv_row.iit_coord_flag := p_row_in.iit_coord_flag; end if;
			if  p_row_in.iit_description is not null then r_inv_row.iit_description := p_row_in.iit_description; end if;
			if  p_row_in.iit_diagram is not null then r_inv_row.iit_diagram := p_row_in.iit_diagram; end if;
			if  p_row_in.iit_distance is not null then r_inv_row.iit_distance := p_row_in.iit_distance; end if;
			if  p_row_in.iit_end_chain is not null then r_inv_row.iit_end_chain := p_row_in.iit_end_chain; end if;
			if  p_row_in.iit_gap is not null then r_inv_row.iit_gap := p_row_in.iit_gap; end if;
			if  p_row_in.iit_height is not null then r_inv_row.iit_height := p_row_in.iit_height; end if;
			if  p_row_in.iit_height_2 is not null then r_inv_row.iit_height_2 := p_row_in.iit_height_2; end if;
			if  p_row_in.iit_id_code is not null then r_inv_row.iit_id_code := p_row_in.iit_id_code; end if;
			if  p_row_in.iit_instal_date is not null then r_inv_row.iit_instal_date := p_row_in.iit_instal_date; end if;
			if  p_row_in.iit_invent_date is not null then r_inv_row.iit_invent_date := p_row_in.iit_invent_date; end if;
			if  p_row_in.iit_inv_ownership is not null then r_inv_row.iit_inv_ownership := p_row_in.iit_inv_ownership; end if;
			if  p_row_in.iit_itemcode is not null then r_inv_row.iit_itemcode := p_row_in.iit_itemcode; end if;
			if  p_row_in.iit_lco_lamp_config_id is not null then r_inv_row.iit_lco_lamp_config_id := p_row_in.iit_lco_lamp_config_id; end if;
			if  p_row_in.iit_length is not null then r_inv_row.iit_length := p_row_in.iit_length; end if;
			if  p_row_in.iit_material is not null then r_inv_row.iit_material := p_row_in.iit_material; end if;
			if  p_row_in.iit_material_txt is not null then r_inv_row.iit_material_txt := p_row_in.iit_material_txt; end if;
			if  p_row_in.iit_method is not null then r_inv_row.iit_method := p_row_in.iit_method; end if;
			if  p_row_in.iit_method_txt is not null then r_inv_row.iit_method_txt := p_row_in.iit_method_txt; end if;
			if  p_row_in.iit_note is not null then r_inv_row.iit_note := p_row_in.iit_note; end if;
			if  p_row_in.iit_no_of_units is not null then r_inv_row.iit_no_of_units := p_row_in.iit_no_of_units; end if;
			if  p_row_in.iit_options is not null then r_inv_row.iit_options := p_row_in.iit_options; end if;
			if  p_row_in.iit_options_txt is not null then r_inv_row.iit_options_txt := p_row_in.iit_options_txt; end if;
			if  p_row_in.iit_oun_org_id_elec_board is not null then r_inv_row.iit_oun_org_id_elec_board := p_row_in.iit_oun_org_id_elec_board; end if;
			if  p_row_in.iit_owner is not null then r_inv_row.iit_owner := p_row_in.iit_owner; end if;
			if  p_row_in.iit_owner_txt is not null then r_inv_row.iit_owner_txt := p_row_in.iit_owner_txt; end if;
			if  p_row_in.iit_peo_invent_by_id is not null then r_inv_row.iit_peo_invent_by_id := p_row_in.iit_peo_invent_by_id; end if;
			if  p_row_in.iit_photo is not null then r_inv_row.iit_photo := p_row_in.iit_photo; end if;
			if  p_row_in.iit_power is not null then r_inv_row.iit_power := p_row_in.iit_power; end if;
			if  p_row_in.iit_prov_flag is not null then r_inv_row.iit_prov_flag := p_row_in.iit_prov_flag; end if;
			if  p_row_in.iit_rev_by is not null then r_inv_row.iit_rev_by := p_row_in.iit_rev_by; end if;
			if  p_row_in.iit_rev_date is not null then r_inv_row.iit_rev_date := p_row_in.iit_rev_date; end if;
			if  p_row_in.iit_type is not null then r_inv_row.iit_type := p_row_in.iit_type; end if;
			if  p_row_in.iit_type_txt is not null then r_inv_row.iit_type_txt := p_row_in.iit_type_txt; end if;
			if  p_row_in.iit_width is not null then r_inv_row.iit_width := p_row_in.iit_width; end if;
			if  p_row_in.iit_xtra_char_1 is not null then r_inv_row.iit_xtra_char_1 := p_row_in.iit_xtra_char_1; end if;
			if  p_row_in.iit_xtra_date_1 is not null then r_inv_row.iit_xtra_date_1 := p_row_in.iit_xtra_date_1; end if;
			if  p_row_in.iit_xtra_domain_1 is not null then r_inv_row.iit_xtra_domain_1 := p_row_in.iit_xtra_domain_1; end if;
			if  p_row_in.iit_xtra_domain_txt_1 is not null then r_inv_row.iit_xtra_domain_txt_1 := p_row_in.iit_xtra_domain_txt_1; end if;
			if  p_row_in.iit_xtra_number_1 is not null then r_inv_row.iit_xtra_number_1 := p_row_in.iit_xtra_number_1; end if;
			if  p_row_in.iit_x_sect is not null then r_inv_row.iit_x_sect := p_row_in.iit_x_sect; end if;
			if  p_row_in.iit_det_xsp is not null then r_inv_row.iit_det_xsp := p_row_in.iit_det_xsp; end if;
			if  p_row_in.iit_offset is not null then r_inv_row.iit_offset := p_row_in.iit_offset; end if;
			if  p_row_in.iit_x is not null then r_inv_row.iit_x := p_row_in.iit_x; end if;
			if  p_row_in.iit_y is not null then r_inv_row.iit_y := p_row_in.iit_y; end if;
			if  p_row_in.iit_z is not null then r_inv_row.iit_z := p_row_in.iit_z; end if;
			if  p_row_in.iit_num_attrib96 is not null then r_inv_row.iit_num_attrib96 := p_row_in.iit_num_attrib96; end if;
			if  p_row_in.iit_num_attrib97 is not null then r_inv_row.iit_num_attrib97 := p_row_in.iit_num_attrib97; end if;
			if  p_row_in.iit_num_attrib98 is not null then r_inv_row.iit_num_attrib98 := p_row_in.iit_num_attrib98; end if;
			if  p_row_in.iit_num_attrib99 is not null then r_inv_row.iit_num_attrib99 := p_row_in.iit_num_attrib99; end if;
			if  p_row_in.iit_num_attrib100 is not null then r_inv_row.iit_num_attrib100 := p_row_in.iit_num_attrib100; end if;
			if  p_row_in.iit_num_attrib101 is not null then r_inv_row.iit_num_attrib101 := p_row_in.iit_num_attrib101; end if;
			if  p_row_in.iit_num_attrib102 is not null then r_inv_row.iit_num_attrib102 := p_row_in.iit_num_attrib102; end if;
			if  p_row_in.iit_num_attrib103 is not null then r_inv_row.iit_num_attrib103 := p_row_in.iit_num_attrib103; end if;
			if  p_row_in.iit_num_attrib104 is not null then r_inv_row.iit_num_attrib104 := p_row_in.iit_num_attrib104; end if;
			if  p_row_in.iit_num_attrib105 is not null then r_inv_row.iit_num_attrib105 := p_row_in.iit_num_attrib105; end if;
			if  p_row_in.iit_num_attrib106 is not null then r_inv_row.iit_num_attrib106 := p_row_in.iit_num_attrib106; end if;
			if  p_row_in.iit_num_attrib107 is not null then r_inv_row.iit_num_attrib107 := p_row_in.iit_num_attrib107; end if;
			if  p_row_in.iit_num_attrib108 is not null then r_inv_row.iit_num_attrib108 := p_row_in.iit_num_attrib108; end if;
			if  p_row_in.iit_num_attrib109 is not null then r_inv_row.iit_num_attrib109 := p_row_in.iit_num_attrib109; end if;
			if  p_row_in.iit_num_attrib110 is not null then r_inv_row.iit_num_attrib110 := p_row_in.iit_num_attrib110; end if;
			if  p_row_in.iit_num_attrib111 is not null then r_inv_row.iit_num_attrib111 := p_row_in.iit_num_attrib111; end if;
			if  p_row_in.iit_num_attrib112 is not null then r_inv_row.iit_num_attrib112 := p_row_in.iit_num_attrib112; end if;
			if  p_row_in.iit_num_attrib113 is not null then r_inv_row.iit_num_attrib113 := p_row_in.iit_num_attrib113; end if;
			if  p_row_in.iit_num_attrib114 is not null then r_inv_row.iit_num_attrib114 := p_row_in.iit_num_attrib114; end if;
			if  p_row_in.iit_num_attrib115 is not null then r_inv_row.iit_num_attrib115 := p_row_in.iit_num_attrib115; end if;
	
	
	 --recheck the start date, it cannot be the same as the old start date
					
			if  r_inv_row.iit_start_date < p_row_in.iit_start_date then 
				r_inv_row.iit_start_date := p_row_in.iit_start_date; 
			elsif p_row_in.iit_start_date is null then 
				r_inv_row.iit_start_date := p_effective_date;
			else
				begin
					raise ex_start_date;
				exception
					when ex_start_date then
						raise_application_error(-20001, 'The Start Date Must Be Greater Than the Current Start Date. Current: '|| r_inv_row.iit_start_date || ' In File: ' || p_row_in.iit_start_date);	
				end;
			end if;
	
			--r_inv_row.iit_start_date := r_inv_row.iit_start_date +1;  -- testing line
	
			nm3inv_update.date_track_update_item (pi_iit_ne_id_old => n_iit_ne_id              ,pio_rec_iit      => r_inv_row         );
	
	
end x_ha_update_inv_item;