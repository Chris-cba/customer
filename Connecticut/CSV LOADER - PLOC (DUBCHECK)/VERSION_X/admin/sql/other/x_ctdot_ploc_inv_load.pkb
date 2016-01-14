create or replace package body x_ctdot_ploc_inv_load is	
	/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: x_ctdot_ploc_inv_load
	Author: JMM
	UPDATE01:	Original, 2014.08.19, JMM
*/
	b_validate boolean := false;
	r_inv_items nm_inv_items%rowtype;
	
	--type  typ_p_rec_old is table of V_LOAD_INV_MEM_ON_ELEMENT%ROWTYPE;  -- now in header
	
	p_rec_old_tbl typ_p_rec_old;
	p_rec_tbl typ_p_rec_old;
	
	g_create_temp_ne_on_validate 	BOOLEAN 					:= FALSE;
	g_last_nte_job_id            	NUMBER 						:= -1;
	
	procedure p_load_inv(p_row_in in X_V_INV_ITEM_LOADER%rowtype) is
		begin
			b_validate := false;
			process(p_row_in,b_validate);
	end p_load_inv;
	
	procedure p_validate_inv(p_row_in in X_V_INV_ITEM_LOADER%rowtype) is
		begin
			b_validate := true;
			process(p_row_in,b_validate);
	end p_validate_inv;
	
	procedure process(p_row_in in X_V_INV_ITEM_LOADER%rowtype, b_validate boolean default false) is
		n_count number := 0;
		
		function f_xfer_to_inv_items(p_row in X_V_INV_ITEM_LOADER%rowtype) return nm_inv_items%rowtype is
			r_ret nm_inv_items%rowtype;
			begin
			/* 
						SELECT 
						lower('r_ret.'|| column_name || ' := ' || ' p_row_in.'|| column_name || ';' )
						, a.*
						FROM   all_tab_cols a
						where owner = 'ATLAS'
						and table_name = 'NM_INV_ITEMS'
						order by column_id
			*/
			r_ret.iit_ne_id :=  p_row_in.iit_ne_id;
			r_ret.iit_inv_type :=  p_row_in.iit_inv_type;
			r_ret.iit_primary_key :=  p_row_in.iit_primary_key;
			r_ret.iit_start_date :=  p_row_in.iit_start_date;
			r_ret.iit_date_created :=  p_row_in.iit_date_created;
			r_ret.iit_date_modified :=  p_row_in.iit_date_modified;
			r_ret.iit_created_by :=  p_row_in.iit_created_by;
			r_ret.iit_modified_by :=  p_row_in.iit_modified_by;
			r_ret.iit_admin_unit :=  p_row_in.iit_admin_unit;
			r_ret.iit_descr :=  p_row_in.iit_descr;
			r_ret.iit_end_date :=  p_row_in.iit_end_date;
			r_ret.iit_foreign_key :=  p_row_in.iit_foreign_key;
			r_ret.iit_located_by :=  p_row_in.iit_located_by;
			r_ret.iit_position :=  p_row_in.iit_position;
			r_ret.iit_x_coord :=  p_row_in.iit_x_coord;
			r_ret.iit_y_coord :=  p_row_in.iit_y_coord;
			r_ret.iit_num_attrib16 :=  p_row_in.iit_num_attrib16;
			r_ret.iit_num_attrib17 :=  p_row_in.iit_num_attrib17;
			r_ret.iit_num_attrib18 :=  p_row_in.iit_num_attrib18;
			r_ret.iit_num_attrib19 :=  p_row_in.iit_num_attrib19;
			r_ret.iit_num_attrib20 :=  p_row_in.iit_num_attrib20;
			r_ret.iit_num_attrib21 :=  p_row_in.iit_num_attrib21;
			r_ret.iit_num_attrib22 :=  p_row_in.iit_num_attrib22;
			r_ret.iit_num_attrib23 :=  p_row_in.iit_num_attrib23;
			r_ret.iit_num_attrib24 :=  p_row_in.iit_num_attrib24;
			r_ret.iit_num_attrib25 :=  p_row_in.iit_num_attrib25;
			r_ret.iit_chr_attrib26 :=  p_row_in.iit_chr_attrib26;
			r_ret.iit_chr_attrib27 :=  p_row_in.iit_chr_attrib27;
			r_ret.iit_chr_attrib28 :=  p_row_in.iit_chr_attrib28;
			r_ret.iit_chr_attrib29 :=  p_row_in.iit_chr_attrib29;
			r_ret.iit_chr_attrib30 :=  p_row_in.iit_chr_attrib30;
			r_ret.iit_chr_attrib31 :=  p_row_in.iit_chr_attrib31;
			r_ret.iit_chr_attrib32 :=  p_row_in.iit_chr_attrib32;
			r_ret.iit_chr_attrib33 :=  p_row_in.iit_chr_attrib33;
			r_ret.iit_chr_attrib34 :=  p_row_in.iit_chr_attrib34;
			r_ret.iit_chr_attrib35 :=  p_row_in.iit_chr_attrib35;
			r_ret.iit_chr_attrib36 :=  p_row_in.iit_chr_attrib36;
			r_ret.iit_chr_attrib37 :=  p_row_in.iit_chr_attrib37;
			r_ret.iit_chr_attrib38 :=  p_row_in.iit_chr_attrib38;
			r_ret.iit_chr_attrib39 :=  p_row_in.iit_chr_attrib39;
			r_ret.iit_chr_attrib40 :=  p_row_in.iit_chr_attrib40;
			r_ret.iit_chr_attrib41 :=  p_row_in.iit_chr_attrib41;
			r_ret.iit_chr_attrib42 :=  p_row_in.iit_chr_attrib42;
			r_ret.iit_chr_attrib43 :=  p_row_in.iit_chr_attrib43;
			r_ret.iit_chr_attrib44 :=  p_row_in.iit_chr_attrib44;
			r_ret.iit_chr_attrib45 :=  p_row_in.iit_chr_attrib45;
			r_ret.iit_chr_attrib46 :=  p_row_in.iit_chr_attrib46;
			r_ret.iit_chr_attrib47 :=  p_row_in.iit_chr_attrib47;
			r_ret.iit_chr_attrib48 :=  p_row_in.iit_chr_attrib48;
			r_ret.iit_chr_attrib49 :=  p_row_in.iit_chr_attrib49;
			r_ret.iit_chr_attrib50 :=  p_row_in.iit_chr_attrib50;
			r_ret.iit_chr_attrib51 :=  p_row_in.iit_chr_attrib51;
			r_ret.iit_chr_attrib52 :=  p_row_in.iit_chr_attrib52;
			r_ret.iit_chr_attrib53 :=  p_row_in.iit_chr_attrib53;
			r_ret.iit_chr_attrib54 :=  p_row_in.iit_chr_attrib54;
			r_ret.iit_chr_attrib55 :=  p_row_in.iit_chr_attrib55;
			r_ret.iit_chr_attrib56 :=  p_row_in.iit_chr_attrib56;
			r_ret.iit_chr_attrib57 :=  p_row_in.iit_chr_attrib57;
			r_ret.iit_chr_attrib58 :=  p_row_in.iit_chr_attrib58;
			r_ret.iit_chr_attrib59 :=  p_row_in.iit_chr_attrib59;
			r_ret.iit_chr_attrib60 :=  p_row_in.iit_chr_attrib60;
			r_ret.iit_chr_attrib61 :=  p_row_in.iit_chr_attrib61;
			r_ret.iit_chr_attrib62 :=  p_row_in.iit_chr_attrib62;
			r_ret.iit_chr_attrib63 :=  p_row_in.iit_chr_attrib63;
			r_ret.iit_chr_attrib64 :=  p_row_in.iit_chr_attrib64;
			r_ret.iit_chr_attrib65 :=  p_row_in.iit_chr_attrib65;
			r_ret.iit_chr_attrib66 :=  p_row_in.iit_chr_attrib66;
			r_ret.iit_chr_attrib67 :=  p_row_in.iit_chr_attrib67;
			r_ret.iit_chr_attrib68 :=  p_row_in.iit_chr_attrib68;
			r_ret.iit_chr_attrib69 :=  p_row_in.iit_chr_attrib69;
			r_ret.iit_chr_attrib70 :=  p_row_in.iit_chr_attrib70;
			r_ret.iit_chr_attrib71 :=  p_row_in.iit_chr_attrib71;
			r_ret.iit_chr_attrib72 :=  p_row_in.iit_chr_attrib72;
			r_ret.iit_chr_attrib73 :=  p_row_in.iit_chr_attrib73;
			r_ret.iit_chr_attrib74 :=  p_row_in.iit_chr_attrib74;
			r_ret.iit_chr_attrib75 :=  p_row_in.iit_chr_attrib75;
			r_ret.iit_num_attrib76 :=  p_row_in.iit_num_attrib76;
			r_ret.iit_num_attrib77 :=  p_row_in.iit_num_attrib77;
			r_ret.iit_num_attrib78 :=  p_row_in.iit_num_attrib78;
			r_ret.iit_num_attrib79 :=  p_row_in.iit_num_attrib79;
			r_ret.iit_num_attrib80 :=  p_row_in.iit_num_attrib80;
			r_ret.iit_num_attrib81 :=  p_row_in.iit_num_attrib81;
			r_ret.iit_num_attrib82 :=  p_row_in.iit_num_attrib82;
			r_ret.iit_num_attrib83 :=  p_row_in.iit_num_attrib83;
			r_ret.iit_num_attrib84 :=  p_row_in.iit_num_attrib84;
			r_ret.iit_num_attrib85 :=  p_row_in.iit_num_attrib85;
			r_ret.iit_date_attrib86 :=  p_row_in.iit_date_attrib86;
			r_ret.iit_date_attrib87 :=  p_row_in.iit_date_attrib87;
			r_ret.iit_date_attrib88 :=  p_row_in.iit_date_attrib88;
			r_ret.iit_date_attrib89 :=  p_row_in.iit_date_attrib89;
			r_ret.iit_date_attrib90 :=  p_row_in.iit_date_attrib90;
			r_ret.iit_date_attrib91 :=  p_row_in.iit_date_attrib91;
			r_ret.iit_date_attrib92 :=  p_row_in.iit_date_attrib92;
			r_ret.iit_date_attrib93 :=  p_row_in.iit_date_attrib93;
			r_ret.iit_date_attrib94 :=  p_row_in.iit_date_attrib94;
			r_ret.iit_date_attrib95 :=  p_row_in.iit_date_attrib95;
			r_ret.iit_angle :=  p_row_in.iit_angle;
			r_ret.iit_angle_txt :=  p_row_in.iit_angle_txt;
			r_ret.iit_class :=  p_row_in.iit_class;
			r_ret.iit_class_txt :=  p_row_in.iit_class_txt;
			r_ret.iit_colour :=  p_row_in.iit_colour;
			r_ret.iit_colour_txt :=  p_row_in.iit_colour_txt;
			r_ret.iit_coord_flag :=  p_row_in.iit_coord_flag;
			r_ret.iit_description :=  p_row_in.iit_description;
			r_ret.iit_diagram :=  p_row_in.iit_diagram;
			r_ret.iit_distance :=  p_row_in.iit_distance;
			r_ret.iit_end_chain :=  p_row_in.iit_end_chain;
			r_ret.iit_gap :=  p_row_in.iit_gap;
			r_ret.iit_height :=  p_row_in.iit_height;
			r_ret.iit_height_2 :=  p_row_in.iit_height_2;
			r_ret.iit_id_code :=  p_row_in.iit_id_code;
			r_ret.iit_instal_date :=  p_row_in.iit_instal_date;
			r_ret.iit_invent_date :=  p_row_in.iit_invent_date;
			r_ret.iit_inv_ownership :=  p_row_in.iit_inv_ownership;
			r_ret.iit_itemcode :=  p_row_in.iit_itemcode;
			r_ret.iit_lco_lamp_config_id :=  p_row_in.iit_lco_lamp_config_id;
			r_ret.iit_length :=  p_row_in.iit_length;
			r_ret.iit_material :=  p_row_in.iit_material;
			r_ret.iit_material_txt :=  p_row_in.iit_material_txt;
			r_ret.iit_method :=  p_row_in.iit_method;
			r_ret.iit_method_txt :=  p_row_in.iit_method_txt;
			r_ret.iit_note :=  p_row_in.iit_note;
			r_ret.iit_no_of_units :=  p_row_in.iit_no_of_units;
			r_ret.iit_options :=  p_row_in.iit_options;
			r_ret.iit_options_txt :=  p_row_in.iit_options_txt;
			r_ret.iit_oun_org_id_elec_board :=  p_row_in.iit_oun_org_id_elec_board;
			r_ret.iit_owner :=  p_row_in.iit_owner;
			r_ret.iit_owner_txt :=  p_row_in.iit_owner_txt;
			r_ret.iit_peo_invent_by_id :=  p_row_in.iit_peo_invent_by_id;
			r_ret.iit_photo :=  p_row_in.iit_photo;
			r_ret.iit_power :=  p_row_in.iit_power;
			r_ret.iit_prov_flag :=  p_row_in.iit_prov_flag;
			r_ret.iit_rev_by :=  p_row_in.iit_rev_by;
			r_ret.iit_rev_date :=  p_row_in.iit_rev_date;
			r_ret.iit_type :=  p_row_in.iit_type;
			r_ret.iit_type_txt :=  p_row_in.iit_type_txt;
			r_ret.iit_width :=  p_row_in.iit_width;
			r_ret.iit_xtra_char_1 :=  p_row_in.iit_xtra_char_1;
			r_ret.iit_xtra_date_1 :=  p_row_in.iit_xtra_date_1;
			r_ret.iit_xtra_domain_1 :=  p_row_in.iit_xtra_domain_1;
			r_ret.iit_xtra_domain_txt_1 :=  p_row_in.iit_xtra_domain_txt_1;
			r_ret.iit_xtra_number_1 :=  p_row_in.iit_xtra_number_1;
			r_ret.iit_x_sect :=  p_row_in.iit_x_sect;
			r_ret.iit_det_xsp :=  p_row_in.iit_det_xsp;
			r_ret.iit_offset :=  p_row_in.iit_offset;
			r_ret.iit_x :=  p_row_in.iit_x;
			r_ret.iit_y :=  p_row_in.iit_y;
			r_ret.iit_z :=  p_row_in.iit_z;
			r_ret.iit_num_attrib96 :=  p_row_in.iit_num_attrib96;
			r_ret.iit_num_attrib97 :=  p_row_in.iit_num_attrib97;
			r_ret.iit_num_attrib98 :=  p_row_in.iit_num_attrib98;
			r_ret.iit_num_attrib99 :=  p_row_in.iit_num_attrib99;
			r_ret.iit_num_attrib100 :=  p_row_in.iit_num_attrib100;
			r_ret.iit_num_attrib101 :=  p_row_in.iit_num_attrib101;
			r_ret.iit_num_attrib102 :=  p_row_in.iit_num_attrib102;
			r_ret.iit_num_attrib103 :=  p_row_in.iit_num_attrib103;
			r_ret.iit_num_attrib104 :=  p_row_in.iit_num_attrib104;
			r_ret.iit_num_attrib105 :=  p_row_in.iit_num_attrib105;
			r_ret.iit_num_attrib106 :=  p_row_in.iit_num_attrib106;
			r_ret.iit_num_attrib107 :=  p_row_in.iit_num_attrib107;
			r_ret.iit_num_attrib108 :=  p_row_in.iit_num_attrib108;
			r_ret.iit_num_attrib109 :=  p_row_in.iit_num_attrib109;
			r_ret.iit_num_attrib110 :=  p_row_in.iit_num_attrib110;
			r_ret.iit_num_attrib111 :=  p_row_in.iit_num_attrib111;
			r_ret.iit_num_attrib112 :=  p_row_in.iit_num_attrib112;
			r_ret.iit_num_attrib113 :=  p_row_in.iit_num_attrib113;
			r_ret.iit_num_attrib114 :=  p_row_in.iit_num_attrib114;
			r_ret.iit_num_attrib115 :=  p_row_in.iit_num_attrib115;
			
			return r_ret;
		end f_xfer_to_inv_items;
		
		--main process procedure
		--main process procedure
		--main process procedure
		begin
			-- check to see if this is new or existing
			select count(*) into n_count from nm_inv_items where iit_ne_id = p_row_in.iit_ne_id and IIT_CHR_ATTRIB26 = p_row_in.IIT_CHR_ATTRIB26;
			if n_count = 0 then -- new asset
			--need to xfer the rowtype to nm_inv_items
			r_inv_items := f_xfer_to_inv_items(p_row_in);
				if b_validate = true then
					NM3INV.VALIDATE_REC_IIT(r_inv_items);
				else
					NM3INS.INS_IIT_ALL(r_inv_items);
				end if;
			else --existing asset
				--nothing to do with the assets item.
				null;
			end if;
	end process;
	
	procedure p_load_loc(p_row_in in X_V_LOAD_INV_MEM_ON_ELEMENT_P%rowtype) is
		begin
			b_validate := false;
			process_ploc(p_row_in,b_validate);
		end p_load_loc;
		
	procedure p_validate_loc(p_row_in in X_V_LOAD_INV_MEM_ON_ELEMENT_P%rowtype) is
		begin
			b_validate := true;
			process_ploc(p_row_in,b_validate);
	end p_validate_loc;
	
	procedure process_ploc(p_row_in in X_V_LOAD_INV_MEM_ON_ELEMENT_P%rowtype, b_validate boolean default false) is
		cursor  c_current_ploc(n_iit_id number)  is  select * from v_nm_ploc_nw   where IIT_NE_ID  = n_iit_id;
		
		begin
			--NM_DEBUG.PROC_START(G_PACKAGE_NAME,'process_ploc');

			p_rec_old_tbl := typ_p_rec_old();
		   
			p_rec_old_tbl.extend(1);
			
			p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:= p_row_in.NE_UNIQUE;
			p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE			:= p_row_in.NE_NT_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP				:= p_row_in.begin_mp;
			p_rec_old_tbl(p_rec_old_tbl.count).END_MP				:= p_row_in.end_mp;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_row_in.IIT_NE_ID;
			p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE			:= p_row_in.IIT_INV_TYPE;
			p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= p_row_in.NM_START_DATE;
					
			-- Lets get the existing locations
			
			for r_row in c_current_ploc(p_row_in.IIT_NE_ID) loop  -- using v_nm_ploc_nw 
				p_rec_old_tbl.extend(1);
				p_rec_old_tbl(p_rec_old_tbl.count).NE_UNIQUE			:=r_row.MEMBER_UNIQUE;
				p_rec_old_tbl(p_rec_old_tbl.count).NE_NT_TYPE			:= nm3net.get_nt_type(r_row.ne_id_of);
				p_rec_old_tbl(p_rec_old_tbl.count).BEGIN_MP				:= r_row.NM_BEGIN_MP;
				p_rec_old_tbl(p_rec_old_tbl.count).END_MP				:= r_row.NM_END_MP;
				p_rec_old_tbl(p_rec_old_tbl.count).IIT_NE_ID			:= p_row_in.IIT_NE_ID;
				p_rec_old_tbl(p_rec_old_tbl.count).IIT_INV_TYPE			:= p_row_in.IIT_INV_TYPE;
				p_rec_old_tbl(p_rec_old_tbl.count).NM_START_DATE		:= r_row.NM_START_DATE;
			end loop;

				
			
			
			LOAD_OR_VAL_ON_ELEMENT (P_REC           => P_REC_old_tbl
								,P_VALIDATE_ONLY => b_validate
								);
			
			
		   --NM_DEBUG.PROC_END(G_PACKAGE_NAME,'process_ploc');
	end process_ploc;
	
	PROCEDURE LOAD_OR_VAL_ON_ELEMENT (P_REC           typ_p_rec_old                  ,P_VALIDATE_ONLY BOOLEAN                                 ) IS

		C_INIT_EFFECTIVE_DATE CONSTANT DATE := TO_DATE(SYS_CONTEXT('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

		L_REC_NE       NM_ELEMENTS%ROWTYPE;

		NOTHING_TO_DO  EXCEPTION;

		L_BEGIN_MP     NUMBER;
		L_END_MP       NUMBER;
		L_NTE_JOB_ID   NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE;
		L_NTE_JOB_ID_2   NM_NW_TEMP_EXTENTS.NTE_JOB_ID%TYPE;
		C_END_MP  NUMBER ;

		BEGIN
		/* 

		*/


			SAVEPOINT TOP_OF_LOAD;

			IF  P_REC(p_rec.first).NE_UNIQUE IS NULL
			THEN
			  RAISE NOTHING_TO_DO;
			END IF;



			--- START --------section to repeat
			C_END_MP  := NVL(P_REC(p_rec.first).END_MP,P_REC(p_rec.first).BEGIN_MP);
			L_REC_NE := NM3GET.GET_NE (PI_NE_ID  => NM3NET.GET_NE_ID (P_REC(p_rec.first).NE_UNIQUE,P_REC(p_rec.first).NE_NT_TYPE));


			IF   NVL(P_REC(p_rec.first).BEGIN_MP,0)            = 0
			AND NVL(C_END_MP,L_REC_NE.NE_LENGTH) = L_REC_NE.NE_LENGTH
			THEN
			  L_BEGIN_MP := NULL;
			  L_END_MP   := NULL;
			ELSE
			  L_BEGIN_MP := P_REC(p_rec.first).BEGIN_MP;
			  L_END_MP   := C_END_MP;
			END IF;

			NM3EXTENT.CREATE_TEMP_NE (PI_SOURCE_ID => L_REC_NE.NE_ID
									,PI_SOURCE    => NM3EXTENT.C_ROUTE
									,PI_BEGIN_MP  => L_BEGIN_MP
									,PI_END_MP    => L_END_MP
									,PO_JOB_ID    => L_NTE_JOB_ID
									);

			NM3EXTENT.REMOVE_DB_FROM_TEMP_NE (L_NTE_JOB_ID);
			--- END --------section to repeat

			if p_rec.count >1 then  --
				   --- START --------section to repeat
				   for xx in 2 ..p_rec.count loop
						C_END_MP   := NVL(P_REC(xx).END_MP,P_REC(xx).BEGIN_MP);
					   L_REC_NE := NM3GET.GET_NE (PI_NE_ID  => NM3NET.GET_NE_ID (P_REC(xx).NE_UNIQUE,p_rec(xx).NE_NT_TYPE));

					   
					   IF   NVL(P_REC(xx).BEGIN_MP,0)            = 0
						AND NVL(C_END_MP,L_REC_NE.NE_LENGTH) = L_REC_NE.NE_LENGTH
						THEN
						  L_BEGIN_MP := NULL;
						  L_END_MP   := NULL;
					   ELSE
						  L_BEGIN_MP := P_REC(xx).BEGIN_MP;
						  L_END_MP   := C_END_MP;
					   END IF;

					   NM3EXTENT.CREATE_TEMP_NE (PI_SOURCE_ID => L_REC_NE.NE_ID
												,PI_SOURCE    => NM3EXTENT.C_ROUTE
												,PI_BEGIN_MP  => L_BEGIN_MP
												,PI_END_MP    => L_END_MP
												,PO_JOB_ID    => L_NTE_JOB_ID_2
												);

					   NM3EXTENT.REMOVE_DB_FROM_TEMP_NE (L_NTE_JOB_ID_2);
					   --- END --------section to repeat
					   
					  Nm3extent.combine_temp_nes(pi_job_id_1       => L_NTE_JOB_ID
										  ,pi_job_id_2       => L_NTE_JOB_ID_2
										  ,pi_check_overlaps => FALSE);  --homo will check for overlaps
					end loop;
			end if;

			NM3HOMO.HISTORIC_LOCATE_INIT(PI_EFFECTIVE_DATE => P_REC(p_rec.first).NM_START_DATE);

			NM3HOMO.CHECK_TEMP_NE_FOR_PNT_OR_CONT (PI_NTE_JOB_ID  => L_NTE_JOB_ID
												 ,PI_PNT_OR_CONT => NM3GET.GET_NIT(PI_NIT_INV_TYPE=>P_REC(p_rec.first).IIT_INV_TYPE).NIT_PNT_OR_CONT
												 );

			NM3HOMO.HISTORIC_LOCATE_VALIDATION(PI_NTE_JOB_ID   => L_NTE_JOB_ID
											 ,PI_USER_NE_ID   => L_REC_NE.NE_ID
											 ,PI_USER_NE_TYPE => L_REC_NE.NE_TYPE);

			IF P_VALIDATE_ONLY
			THEN
			  IF NOT G_CREATE_TEMP_NE_ON_VALIDATE
			   THEN
				 ROLLBACK TO TOP_OF_LOAD;
				 G_LAST_NTE_JOB_ID := -1;
			  END IF;
			ELSE
			  NM3HOMO.HOMO_UPDATE (P_TEMP_NE_ID_IN  => L_NTE_JOB_ID
								  ,P_IIT_NE_ID      => P_REC(p_rec.first).IIT_NE_ID
								  ,P_EFFECTIVE_DATE => P_REC(p_rec.first).NM_START_DATE
								  );

			commit;
			END IF;

			G_LAST_NTE_JOB_ID := L_NTE_JOB_ID;

			NM3HOMO.HISTORIC_LOCATE_POST(PI_INIT_EFFECTIVE_DATE => C_INIT_EFFECTIVE_DATE);

			EXCEPTION

			WHEN NOTHING_TO_DO
			THEN
			  NULL;

			WHEN OTHERS
			THEN
			  ROLLBACK TO TOP_OF_LOAD;
			  NM3HOMO.HISTORIC_LOCATE_POST(PI_INIT_EFFECTIVE_DATE => C_INIT_EFFECTIVE_DATE);
			  RAISE;

		END LOAD_OR_VAL_ON_ELEMENT;
	
	function get_iit_id_proj(s_proj_number varchar2) return number is
	/* currently this is just checking project number for duplicates*/
		n_count number :=0;
		n_ret number := 0;
		
		begin
			select count(*) into n_count from v_nm_ploc where project_number = s_proj_number;
			if n_count <> 0 then
				select min(iit_ne_id) into n_ret from v_nm_ploc where project_number = s_proj_number;
			else
				n_ret := NM3NET.GET_NEXT_NE_ID;
			end if;
		return n_ret;
	end get_iit_id_proj;
	
end x_ctdot_ploc_inv_load;