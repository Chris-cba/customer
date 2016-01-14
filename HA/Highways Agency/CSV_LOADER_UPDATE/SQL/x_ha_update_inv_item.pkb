create or replace package body x_ha_update_inv_item as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: x_ha_update_inv_item.pkb
	Author: JMM
	UPDATE01:	Original, 2014.07.28, JMM
*/

	procedure p_update(p_row_in in v_ha_update_inv%rowtype) is
		begin
			process(p_row_in,true);
	end p_update;
	
	
	procedure p_validate(p_row_in in v_ha_update_inv%rowtype) is
		begin
			process(p_row_in,false);
	end p_validate;
	
	procedure process(p_row_in in v_ha_update_inv%rowtype, b_validate boolean default false) is
		r_inv_row 			nm_inv_items%rowtype;
		n_iit_ne_id 		number;
		l_rowid             ROWID;
		p_effective_date	date;
		ex_start_date		exception;
		ex_error			exception;
		
	
	function is_updatable(s_asset_type varchar2, s_column_name varchar2, s_new_val varchar2, n_iit_id number) return boolean  is
		s_allow_list varchar2(1500):=  'IIT_SOME_COL1,IIT_SOME_COL2';
		s_inspectable_prefix_list varchar2(1500):= 'IIT_NUM_,IIT_CHR_,IIT_DATE_,IIT_XTRA_';
		n_count number;
		s_temp varchar2(10);
		s_rc_sql varchar2(200);
		e_error exception;
		s_error_text varchar2(200);
		b_return boolean := false;
		--l_cursor ref cursor;
		
		begin --is_updatable
		
			-- Checking whole column names that are allowed to be changed
			select count(*) into n_count from (
				select trim(myrow) myrow from
				(SELECT EXTRACT(column_value,'/e/text()') myrow from
					 (select  upper(s_allow_list) col1 from dual) x,
					 TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
				)
				) 
				where myrow = upper(s_column_name);
				
			if n_count <> 0 then 
				b_return := true; 
			else -- is value the same?
				null;  -- checked below
			end if;
			
			--  Checking the user defined columns for is inspectable flags
			select count(*) into n_count from (
				select trim(myrow) myrow from
				(SELECT EXTRACT(column_value,'/e/text()') myrow from
					 (select  upper(s_inspectable_prefix_list) col1 from dual) x,
					 TABLE(XMLSEQUENCE(EXTRACT(XMLTYPE('<ROW><e>'||REPLACE(col1,',','</e><e>')||'</e></ROW>'),'//e')))
				)
				) 
				where instr(upper(s_column_name),myrow) <>0;
				
			if n_count <>0 then 
				select count(*)  into n_count from NM_INV_TYPE_ATTRIBS nita
					where ita_inv_type = upper(s_asset_type)
					and ita_attrib_name = upper(s_column_name);

				if n_count =0 then 	-- throw a error if the user definable column isn't defined to be used by the asset
					s_error_text := 'Column ' || upper(s_column_name) || ' is not used by asset ' || upper(s_asset_type);
					raise e_error;
				end if;					
				
				select nita.ita_inspectable  into s_temp from NM_INV_TYPE_ATTRIBS nita
					where ita_inv_type = upper(s_asset_type)
					and ita_attrib_name = upper(s_column_name);
				
				if s_temp  = 'Y' then 
					b_return := true; 
				end if;
				-- if No then dont update
			end if;
			
			/*
			if substr(s_column_name, 1,8) in ('IIT_NUM_', 'IIT_CHR_', 'IIT_DATE', 'IIT_XTRA') then  -- check for attribute columns iit_num_, iit_chr_,iit_date, iit_xtra
				select count(*)  into n_count from NM_INV_TYPE_ATTRIBS nita
					where ita_inv_type = upper(s_asset_type)
					and ita_attrib_name = upper(s_column_name);
				
				if n_count =0 then 
					s_error_text := 'Column ' || upper(s_column_name) || ' is not used by asset ' || upper(s_asset_type);
					raise e_error;
				end if;
				
				select nita.ita_inspectable  into s_temp from NM_INV_TYPE_ATTRIBS nita
					where ita_inv_type = upper(s_asset_type)
					and ita_attrib_name = upper(s_column_name);
				
				if s_temp <> 'Y' then 
					s_error_text := 'Column ' || upper(s_column_name) || ' is not Inspectable and cannot be updated via this loader';
					raise e_error;
				end if;
			end if;
			*/
			
			--Check to see if the value of a non-up-datable field has changed
			if b_return = false then
				s_rc_sql := 'select count(*) from nm_inv_items where iit_ne_id = ' || n_iit_id || ' and ' || s_column_name || '= ' || s_new_val;
				EXECUTE IMMEDIATE s_rc_sql into n_count;
				if n_count = 0 then 
					s_error_text := 'The non-updatable column  ' || s_column_name || ' contains a value that is different than the current value.';
					raise e_error;
				end if;
			end if;
			
			
			return b_return;
			
			exception
				when e_error then
					raise_application_error(-20002, s_error_text);
			
	end is_updatable;
	
	begin
			p_effective_date := trunc(sysdate);
			
			
			nm_debug.proc_start('x_ha_update_inv_item','x_ha_update_inv_item');
--
			nm3user.set_effective_date (p_effective_date);
			
			n_iit_ne_id := to_number(p_row_in.iit_ne_id);
			
			--l_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => n_iit_ne_id);
			
			
			-- See if the CHANGE field is 'C'
			if upper(p_row_in.operation) <> upper('U') then
				begin
					raise ex_error;
				exception
					when ex_error then
						raise_application_error(-20002, 'Asset type associated with IIT_NE_ID ' || n_iit_ne_id|| ' Does not have a "U" in the opperation column');
				
				end;
			end if;
			
			
--
			r_inv_row := nm3get.get_iit (pi_iit_ne_id => n_iit_ne_id);
			
			if r_inv_row .iit_inv_type <> p_row_in.iit_inv_type then
				begin
					raise ex_error;
				exception
					when ex_error then
						raise_application_error(-20002, 'Asset type associated with IIT_NE_ID ' || n_iit_ne_id|| ' Does Not Match the Asset type in the CSV file');
				
				end;
			end if;
			
			/* generated using:
			SELECT 
				lower('if  p_row_in.'|| column_name || ' is not null then if is_updatable(r_inv_row.iit_inv_type,upper(''' || column_name ||'''),p_row_in.'|| column_name || ',p_row_in.iit_ne_id) = true then r_inv_row.' || column_name || ' := p_row_in.'|| column_name || '; End if; End if;')
				, a.*
				FROM   all_tab_cols a
				where owner = 'HIGHWAYS'
				and table_name = 'NM_INV_ITEMS'
				order by column_id
			*/
			--is_updatable(s_asset_type varchar2, s_column_name varchar2, s_new_val varchar2, n_iit_id number)
			
			
			if  p_row_in.iit_ne_id is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_ne_id'),p_row_in.iit_ne_id,p_row_in.iit_ne_id) = true then r_inv_row.iit_ne_id := p_row_in.iit_ne_id; end if; end if;
			if  p_row_in.iit_inv_type is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_inv_type'),p_row_in.iit_inv_type,p_row_in.iit_ne_id) = true then r_inv_row.iit_inv_type := p_row_in.iit_inv_type; end if; end if;
			if  p_row_in.iit_primary_key is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_primary_key'),p_row_in.iit_primary_key,p_row_in.iit_ne_id) = true then r_inv_row.iit_primary_key := p_row_in.iit_primary_key; end if; end if;
			if  p_row_in.iit_start_date is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_start_date'),p_row_in.iit_start_date,p_row_in.iit_ne_id) = true then r_inv_row.iit_start_date := p_row_in.iit_start_date; end if; end if;
			if  p_row_in.iit_date_created is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_created'),p_row_in.iit_date_created,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_created := p_row_in.iit_date_created; end if; end if;
			if  p_row_in.iit_date_modified is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_modified'),p_row_in.iit_date_modified,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_modified := p_row_in.iit_date_modified; end if; end if;
			if  p_row_in.iit_created_by is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_created_by'),p_row_in.iit_created_by,p_row_in.iit_ne_id) = true then r_inv_row.iit_created_by := p_row_in.iit_created_by; end if; end if;
			if  p_row_in.iit_modified_by is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_modified_by'),p_row_in.iit_modified_by,p_row_in.iit_ne_id) = true then r_inv_row.iit_modified_by := p_row_in.iit_modified_by; end if; end if;
			if  p_row_in.iit_admin_unit is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_admin_unit'),p_row_in.iit_admin_unit,p_row_in.iit_ne_id) = true then r_inv_row.iit_admin_unit := p_row_in.iit_admin_unit; end if; end if;
			if  p_row_in.iit_descr is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_descr'),p_row_in.iit_descr,p_row_in.iit_ne_id) = true then r_inv_row.iit_descr := p_row_in.iit_descr; end if; end if;
			if  p_row_in.iit_end_date is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_end_date'),p_row_in.iit_end_date,p_row_in.iit_ne_id) = true then r_inv_row.iit_end_date := p_row_in.iit_end_date; end if; end if;
			if  p_row_in.iit_foreign_key is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_foreign_key'),p_row_in.iit_foreign_key,p_row_in.iit_ne_id) = true then r_inv_row.iit_foreign_key := p_row_in.iit_foreign_key; end if; end if;
			if  p_row_in.iit_located_by is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_located_by'),p_row_in.iit_located_by,p_row_in.iit_ne_id) = true then r_inv_row.iit_located_by := p_row_in.iit_located_by; end if; end if;
			if  p_row_in.iit_position is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_position'),p_row_in.iit_position,p_row_in.iit_ne_id) = true then r_inv_row.iit_position := p_row_in.iit_position; end if; end if;
			if  p_row_in.iit_x_coord is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_x_coord'),p_row_in.iit_x_coord,p_row_in.iit_ne_id) = true then r_inv_row.iit_x_coord := p_row_in.iit_x_coord; end if; end if;
			if  p_row_in.iit_y_coord is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_y_coord'),p_row_in.iit_y_coord,p_row_in.iit_ne_id) = true then r_inv_row.iit_y_coord := p_row_in.iit_y_coord; end if; end if;
			if  p_row_in.iit_num_attrib16 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib16'),p_row_in.iit_num_attrib16,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib16 := p_row_in.iit_num_attrib16; end if; end if;
			if  p_row_in.iit_num_attrib17 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib17'),p_row_in.iit_num_attrib17,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib17 := p_row_in.iit_num_attrib17; end if; end if;
			if  p_row_in.iit_num_attrib18 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib18'),p_row_in.iit_num_attrib18,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib18 := p_row_in.iit_num_attrib18; end if; end if;
			if  p_row_in.iit_num_attrib19 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib19'),p_row_in.iit_num_attrib19,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib19 := p_row_in.iit_num_attrib19; end if; end if;
			if  p_row_in.iit_num_attrib20 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib20'),p_row_in.iit_num_attrib20,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib20 := p_row_in.iit_num_attrib20; end if; end if;
			if  p_row_in.iit_num_attrib21 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib21'),p_row_in.iit_num_attrib21,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib21 := p_row_in.iit_num_attrib21; end if; end if;
			if  p_row_in.iit_num_attrib22 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib22'),p_row_in.iit_num_attrib22,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib22 := p_row_in.iit_num_attrib22; end if; end if;
			if  p_row_in.iit_num_attrib23 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib23'),p_row_in.iit_num_attrib23,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib23 := p_row_in.iit_num_attrib23; end if; end if;
			if  p_row_in.iit_num_attrib24 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib24'),p_row_in.iit_num_attrib24,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib24 := p_row_in.iit_num_attrib24; end if; end if;
			if  p_row_in.iit_num_attrib25 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib25'),p_row_in.iit_num_attrib25,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib25 := p_row_in.iit_num_attrib25; end if; end if;
			if  p_row_in.iit_chr_attrib26 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib26'),p_row_in.iit_chr_attrib26,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib26 := p_row_in.iit_chr_attrib26; end if; end if;
			if  p_row_in.iit_chr_attrib27 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib27'),p_row_in.iit_chr_attrib27,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib27 := p_row_in.iit_chr_attrib27; end if; end if;
			if  p_row_in.iit_chr_attrib28 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib28'),p_row_in.iit_chr_attrib28,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib28 := p_row_in.iit_chr_attrib28; end if; end if;
			if  p_row_in.iit_chr_attrib29 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib29'),p_row_in.iit_chr_attrib29,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib29 := p_row_in.iit_chr_attrib29; end if; end if;
			if  p_row_in.iit_chr_attrib30 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib30'),p_row_in.iit_chr_attrib30,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib30 := p_row_in.iit_chr_attrib30; end if; end if;
			if  p_row_in.iit_chr_attrib31 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib31'),p_row_in.iit_chr_attrib31,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib31 := p_row_in.iit_chr_attrib31; end if; end if;
			if  p_row_in.iit_chr_attrib32 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib32'),p_row_in.iit_chr_attrib32,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib32 := p_row_in.iit_chr_attrib32; end if; end if;
			if  p_row_in.iit_chr_attrib33 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib33'),p_row_in.iit_chr_attrib33,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib33 := p_row_in.iit_chr_attrib33; end if; end if;
			if  p_row_in.iit_chr_attrib34 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib34'),p_row_in.iit_chr_attrib34,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib34 := p_row_in.iit_chr_attrib34; end if; end if;
			if  p_row_in.iit_chr_attrib35 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib35'),p_row_in.iit_chr_attrib35,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib35 := p_row_in.iit_chr_attrib35; end if; end if;
			if  p_row_in.iit_chr_attrib36 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib36'),p_row_in.iit_chr_attrib36,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib36 := p_row_in.iit_chr_attrib36; end if; end if;
			if  p_row_in.iit_chr_attrib37 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib37'),p_row_in.iit_chr_attrib37,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib37 := p_row_in.iit_chr_attrib37; end if; end if;
			if  p_row_in.iit_chr_attrib38 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib38'),p_row_in.iit_chr_attrib38,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib38 := p_row_in.iit_chr_attrib38; end if; end if;
			if  p_row_in.iit_chr_attrib39 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib39'),p_row_in.iit_chr_attrib39,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib39 := p_row_in.iit_chr_attrib39; end if; end if;
			if  p_row_in.iit_chr_attrib40 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib40'),p_row_in.iit_chr_attrib40,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib40 := p_row_in.iit_chr_attrib40; end if; end if;
			if  p_row_in.iit_chr_attrib41 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib41'),p_row_in.iit_chr_attrib41,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib41 := p_row_in.iit_chr_attrib41; end if; end if;
			if  p_row_in.iit_chr_attrib42 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib42'),p_row_in.iit_chr_attrib42,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib42 := p_row_in.iit_chr_attrib42; end if; end if;
			if  p_row_in.iit_chr_attrib43 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib43'),p_row_in.iit_chr_attrib43,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib43 := p_row_in.iit_chr_attrib43; end if; end if;
			if  p_row_in.iit_chr_attrib44 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib44'),p_row_in.iit_chr_attrib44,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib44 := p_row_in.iit_chr_attrib44; end if; end if;
			if  p_row_in.iit_chr_attrib45 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib45'),p_row_in.iit_chr_attrib45,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib45 := p_row_in.iit_chr_attrib45; end if; end if;
			if  p_row_in.iit_chr_attrib46 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib46'),p_row_in.iit_chr_attrib46,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib46 := p_row_in.iit_chr_attrib46; end if; end if;
			if  p_row_in.iit_chr_attrib47 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib47'),p_row_in.iit_chr_attrib47,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib47 := p_row_in.iit_chr_attrib47; end if; end if;
			if  p_row_in.iit_chr_attrib48 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib48'),p_row_in.iit_chr_attrib48,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib48 := p_row_in.iit_chr_attrib48; end if; end if;
			if  p_row_in.iit_chr_attrib49 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib49'),p_row_in.iit_chr_attrib49,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib49 := p_row_in.iit_chr_attrib49; end if; end if;
			if  p_row_in.iit_chr_attrib50 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib50'),p_row_in.iit_chr_attrib50,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib50 := p_row_in.iit_chr_attrib50; end if; end if;
			if  p_row_in.iit_chr_attrib51 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib51'),p_row_in.iit_chr_attrib51,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib51 := p_row_in.iit_chr_attrib51; end if; end if;
			if  p_row_in.iit_chr_attrib52 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib52'),p_row_in.iit_chr_attrib52,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib52 := p_row_in.iit_chr_attrib52; end if; end if;
			if  p_row_in.iit_chr_attrib53 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib53'),p_row_in.iit_chr_attrib53,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib53 := p_row_in.iit_chr_attrib53; end if; end if;
			if  p_row_in.iit_chr_attrib54 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib54'),p_row_in.iit_chr_attrib54,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib54 := p_row_in.iit_chr_attrib54; end if; end if;
			if  p_row_in.iit_chr_attrib55 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib55'),p_row_in.iit_chr_attrib55,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib55 := p_row_in.iit_chr_attrib55; end if; end if;
			if  p_row_in.iit_chr_attrib56 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib56'),p_row_in.iit_chr_attrib56,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib56 := p_row_in.iit_chr_attrib56; end if; end if;
			if  p_row_in.iit_chr_attrib57 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib57'),p_row_in.iit_chr_attrib57,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib57 := p_row_in.iit_chr_attrib57; end if; end if;
			if  p_row_in.iit_chr_attrib58 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib58'),p_row_in.iit_chr_attrib58,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib58 := p_row_in.iit_chr_attrib58; end if; end if;
			if  p_row_in.iit_chr_attrib59 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib59'),p_row_in.iit_chr_attrib59,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib59 := p_row_in.iit_chr_attrib59; end if; end if;
			if  p_row_in.iit_chr_attrib60 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib60'),p_row_in.iit_chr_attrib60,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib60 := p_row_in.iit_chr_attrib60; end if; end if;
			if  p_row_in.iit_chr_attrib61 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib61'),p_row_in.iit_chr_attrib61,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib61 := p_row_in.iit_chr_attrib61; end if; end if;
			if  p_row_in.iit_chr_attrib62 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib62'),p_row_in.iit_chr_attrib62,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib62 := p_row_in.iit_chr_attrib62; end if; end if;
			if  p_row_in.iit_chr_attrib63 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib63'),p_row_in.iit_chr_attrib63,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib63 := p_row_in.iit_chr_attrib63; end if; end if;
			if  p_row_in.iit_chr_attrib64 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib64'),p_row_in.iit_chr_attrib64,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib64 := p_row_in.iit_chr_attrib64; end if; end if;
			if  p_row_in.iit_chr_attrib65 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib65'),p_row_in.iit_chr_attrib65,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib65 := p_row_in.iit_chr_attrib65; end if; end if;
			if  p_row_in.iit_chr_attrib66 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib66'),p_row_in.iit_chr_attrib66,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib66 := p_row_in.iit_chr_attrib66; end if; end if;
			if  p_row_in.iit_chr_attrib67 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib67'),p_row_in.iit_chr_attrib67,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib67 := p_row_in.iit_chr_attrib67; end if; end if;
			if  p_row_in.iit_chr_attrib68 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib68'),p_row_in.iit_chr_attrib68,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib68 := p_row_in.iit_chr_attrib68; end if; end if;
			if  p_row_in.iit_chr_attrib69 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib69'),p_row_in.iit_chr_attrib69,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib69 := p_row_in.iit_chr_attrib69; end if; end if;
			if  p_row_in.iit_chr_attrib70 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib70'),p_row_in.iit_chr_attrib70,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib70 := p_row_in.iit_chr_attrib70; end if; end if;
			if  p_row_in.iit_chr_attrib71 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib71'),p_row_in.iit_chr_attrib71,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib71 := p_row_in.iit_chr_attrib71; end if; end if;
			if  p_row_in.iit_chr_attrib72 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib72'),p_row_in.iit_chr_attrib72,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib72 := p_row_in.iit_chr_attrib72; end if; end if;
			if  p_row_in.iit_chr_attrib73 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib73'),p_row_in.iit_chr_attrib73,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib73 := p_row_in.iit_chr_attrib73; end if; end if;
			if  p_row_in.iit_chr_attrib74 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib74'),p_row_in.iit_chr_attrib74,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib74 := p_row_in.iit_chr_attrib74; end if; end if;
			if  p_row_in.iit_chr_attrib75 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_chr_attrib75'),p_row_in.iit_chr_attrib75,p_row_in.iit_ne_id) = true then r_inv_row.iit_chr_attrib75 := p_row_in.iit_chr_attrib75; end if; end if;
			if  p_row_in.iit_num_attrib76 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib76'),p_row_in.iit_num_attrib76,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib76 := p_row_in.iit_num_attrib76; end if; end if;
			if  p_row_in.iit_num_attrib77 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib77'),p_row_in.iit_num_attrib77,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib77 := p_row_in.iit_num_attrib77; end if; end if;
			if  p_row_in.iit_num_attrib78 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib78'),p_row_in.iit_num_attrib78,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib78 := p_row_in.iit_num_attrib78; end if; end if;
			if  p_row_in.iit_num_attrib79 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib79'),p_row_in.iit_num_attrib79,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib79 := p_row_in.iit_num_attrib79; end if; end if;
			if  p_row_in.iit_num_attrib80 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib80'),p_row_in.iit_num_attrib80,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib80 := p_row_in.iit_num_attrib80; end if; end if;
			if  p_row_in.iit_num_attrib81 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib81'),p_row_in.iit_num_attrib81,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib81 := p_row_in.iit_num_attrib81; end if; end if;
			if  p_row_in.iit_num_attrib82 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib82'),p_row_in.iit_num_attrib82,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib82 := p_row_in.iit_num_attrib82; end if; end if;
			if  p_row_in.iit_num_attrib83 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib83'),p_row_in.iit_num_attrib83,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib83 := p_row_in.iit_num_attrib83; end if; end if;
			if  p_row_in.iit_num_attrib84 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib84'),p_row_in.iit_num_attrib84,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib84 := p_row_in.iit_num_attrib84; end if; end if;
			if  p_row_in.iit_num_attrib85 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib85'),p_row_in.iit_num_attrib85,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib85 := p_row_in.iit_num_attrib85; end if; end if;
			if  p_row_in.iit_date_attrib86 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib86'),p_row_in.iit_date_attrib86,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib86 := p_row_in.iit_date_attrib86; end if; end if;
			if  p_row_in.iit_date_attrib87 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib87'),p_row_in.iit_date_attrib87,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib87 := p_row_in.iit_date_attrib87; end if; end if;
			if  p_row_in.iit_date_attrib88 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib88'),p_row_in.iit_date_attrib88,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib88 := p_row_in.iit_date_attrib88; end if; end if;
			if  p_row_in.iit_date_attrib89 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib89'),p_row_in.iit_date_attrib89,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib89 := p_row_in.iit_date_attrib89; end if; end if;
			if  p_row_in.iit_date_attrib90 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib90'),p_row_in.iit_date_attrib90,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib90 := p_row_in.iit_date_attrib90; end if; end if;
			if  p_row_in.iit_date_attrib91 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib91'),p_row_in.iit_date_attrib91,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib91 := p_row_in.iit_date_attrib91; end if; end if;
			if  p_row_in.iit_date_attrib92 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib92'),p_row_in.iit_date_attrib92,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib92 := p_row_in.iit_date_attrib92; end if; end if;
			if  p_row_in.iit_date_attrib93 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib93'),p_row_in.iit_date_attrib93,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib93 := p_row_in.iit_date_attrib93; end if; end if;
			if  p_row_in.iit_date_attrib94 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib94'),p_row_in.iit_date_attrib94,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib94 := p_row_in.iit_date_attrib94; end if; end if;
			if  p_row_in.iit_date_attrib95 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_date_attrib95'),p_row_in.iit_date_attrib95,p_row_in.iit_ne_id) = true then r_inv_row.iit_date_attrib95 := p_row_in.iit_date_attrib95; end if; end if;
			if  p_row_in.iit_angle is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_angle'),p_row_in.iit_angle,p_row_in.iit_ne_id) = true then r_inv_row.iit_angle := p_row_in.iit_angle; end if; end if;
			if  p_row_in.iit_angle_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_angle_txt'),p_row_in.iit_angle_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_angle_txt := p_row_in.iit_angle_txt; end if; end if;
			if  p_row_in.iit_class is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_class'),p_row_in.iit_class,p_row_in.iit_ne_id) = true then r_inv_row.iit_class := p_row_in.iit_class; end if; end if;
			if  p_row_in.iit_class_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_class_txt'),p_row_in.iit_class_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_class_txt := p_row_in.iit_class_txt; end if; end if;
			if  p_row_in.iit_colour is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_colour'),p_row_in.iit_colour,p_row_in.iit_ne_id) = true then r_inv_row.iit_colour := p_row_in.iit_colour; end if; end if;
			if  p_row_in.iit_colour_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_colour_txt'),p_row_in.iit_colour_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_colour_txt := p_row_in.iit_colour_txt; end if; end if;
			if  p_row_in.iit_coord_flag is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_coord_flag'),p_row_in.iit_coord_flag,p_row_in.iit_ne_id) = true then r_inv_row.iit_coord_flag := p_row_in.iit_coord_flag; end if; end if;
			if  p_row_in.iit_description is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_description'),p_row_in.iit_description,p_row_in.iit_ne_id) = true then r_inv_row.iit_description := p_row_in.iit_description; end if; end if;
			if  p_row_in.iit_diagram is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_diagram'),p_row_in.iit_diagram,p_row_in.iit_ne_id) = true then r_inv_row.iit_diagram := p_row_in.iit_diagram; end if; end if;
			if  p_row_in.iit_distance is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_distance'),p_row_in.iit_distance,p_row_in.iit_ne_id) = true then r_inv_row.iit_distance := p_row_in.iit_distance; end if; end if;
			if  p_row_in.iit_end_chain is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_end_chain'),p_row_in.iit_end_chain,p_row_in.iit_ne_id) = true then r_inv_row.iit_end_chain := p_row_in.iit_end_chain; end if; end if;
			if  p_row_in.iit_gap is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_gap'),p_row_in.iit_gap,p_row_in.iit_ne_id) = true then r_inv_row.iit_gap := p_row_in.iit_gap; end if; end if;
			if  p_row_in.iit_height is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_height'),p_row_in.iit_height,p_row_in.iit_ne_id) = true then r_inv_row.iit_height := p_row_in.iit_height; end if; end if;
			if  p_row_in.iit_height_2 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_height_2'),p_row_in.iit_height_2,p_row_in.iit_ne_id) = true then r_inv_row.iit_height_2 := p_row_in.iit_height_2; end if; end if;
			if  p_row_in.iit_id_code is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_id_code'),p_row_in.iit_id_code,p_row_in.iit_ne_id) = true then r_inv_row.iit_id_code := p_row_in.iit_id_code; end if; end if;
			if  p_row_in.iit_instal_date is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_instal_date'),p_row_in.iit_instal_date,p_row_in.iit_ne_id) = true then r_inv_row.iit_instal_date := p_row_in.iit_instal_date; end if; end if;
			if  p_row_in.iit_invent_date is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_invent_date'),p_row_in.iit_invent_date,p_row_in.iit_ne_id) = true then r_inv_row.iit_invent_date := p_row_in.iit_invent_date; end if; end if;
			if  p_row_in.iit_inv_ownership is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_inv_ownership'),p_row_in.iit_inv_ownership,p_row_in.iit_ne_id) = true then r_inv_row.iit_inv_ownership := p_row_in.iit_inv_ownership; end if; end if;
			if  p_row_in.iit_itemcode is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_itemcode'),p_row_in.iit_itemcode,p_row_in.iit_ne_id) = true then r_inv_row.iit_itemcode := p_row_in.iit_itemcode; end if; end if;
			if  p_row_in.iit_lco_lamp_config_id is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_lco_lamp_config_id'),p_row_in.iit_lco_lamp_config_id,p_row_in.iit_ne_id) = true then r_inv_row.iit_lco_lamp_config_id := p_row_in.iit_lco_lamp_config_id; end if; end if;
			if  p_row_in.iit_length is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_length'),p_row_in.iit_length,p_row_in.iit_ne_id) = true then r_inv_row.iit_length := p_row_in.iit_length; end if; end if;
			if  p_row_in.iit_material is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_material'),p_row_in.iit_material,p_row_in.iit_ne_id) = true then r_inv_row.iit_material := p_row_in.iit_material; end if; end if;
			if  p_row_in.iit_material_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_material_txt'),p_row_in.iit_material_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_material_txt := p_row_in.iit_material_txt; end if; end if;
			if  p_row_in.iit_method is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_method'),p_row_in.iit_method,p_row_in.iit_ne_id) = true then r_inv_row.iit_method := p_row_in.iit_method; end if; end if;
			if  p_row_in.iit_method_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_method_txt'),p_row_in.iit_method_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_method_txt := p_row_in.iit_method_txt; end if; end if;
			if  p_row_in.iit_note is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_note'),p_row_in.iit_note,p_row_in.iit_ne_id) = true then r_inv_row.iit_note := p_row_in.iit_note; end if; end if;
			if  p_row_in.iit_no_of_units is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_no_of_units'),p_row_in.iit_no_of_units,p_row_in.iit_ne_id) = true then r_inv_row.iit_no_of_units := p_row_in.iit_no_of_units; end if; end if;
			if  p_row_in.iit_options is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_options'),p_row_in.iit_options,p_row_in.iit_ne_id) = true then r_inv_row.iit_options := p_row_in.iit_options; end if; end if;
			if  p_row_in.iit_options_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_options_txt'),p_row_in.iit_options_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_options_txt := p_row_in.iit_options_txt; end if; end if;
			if  p_row_in.iit_oun_org_id_elec_board is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_oun_org_id_elec_board'),p_row_in.iit_oun_org_id_elec_board,p_row_in.iit_ne_id) = true then r_inv_row.iit_oun_org_id_elec_board := p_row_in.iit_oun_org_id_elec_board; end if; end if;
			if  p_row_in.iit_owner is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_owner'),p_row_in.iit_owner,p_row_in.iit_ne_id) = true then r_inv_row.iit_owner := p_row_in.iit_owner; end if; end if;
			if  p_row_in.iit_owner_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_owner_txt'),p_row_in.iit_owner_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_owner_txt := p_row_in.iit_owner_txt; end if; end if;
			if  p_row_in.iit_peo_invent_by_id is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_peo_invent_by_id'),p_row_in.iit_peo_invent_by_id,p_row_in.iit_ne_id) = true then r_inv_row.iit_peo_invent_by_id := p_row_in.iit_peo_invent_by_id; end if; end if;
			if  p_row_in.iit_photo is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_photo'),p_row_in.iit_photo,p_row_in.iit_ne_id) = true then r_inv_row.iit_photo := p_row_in.iit_photo; end if; end if;
			if  p_row_in.iit_power is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_power'),p_row_in.iit_power,p_row_in.iit_ne_id) = true then r_inv_row.iit_power := p_row_in.iit_power; end if; end if;
			if  p_row_in.iit_prov_flag is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_prov_flag'),p_row_in.iit_prov_flag,p_row_in.iit_ne_id) = true then r_inv_row.iit_prov_flag := p_row_in.iit_prov_flag; end if; end if;
			if  p_row_in.iit_rev_by is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_rev_by'),p_row_in.iit_rev_by,p_row_in.iit_ne_id) = true then r_inv_row.iit_rev_by := p_row_in.iit_rev_by; end if; end if;
			if  p_row_in.iit_rev_date is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_rev_date'),p_row_in.iit_rev_date,p_row_in.iit_ne_id) = true then r_inv_row.iit_rev_date := p_row_in.iit_rev_date; end if; end if;
			if  p_row_in.iit_type is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_type'),p_row_in.iit_type,p_row_in.iit_ne_id) = true then r_inv_row.iit_type := p_row_in.iit_type; end if; end if;
			if  p_row_in.iit_type_txt is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_type_txt'),p_row_in.iit_type_txt,p_row_in.iit_ne_id) = true then r_inv_row.iit_type_txt := p_row_in.iit_type_txt; end if; end if;
			if  p_row_in.iit_width is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_width'),p_row_in.iit_width,p_row_in.iit_ne_id) = true then r_inv_row.iit_width := p_row_in.iit_width; end if; end if;
			if  p_row_in.iit_xtra_char_1 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_xtra_char_1'),p_row_in.iit_xtra_char_1,p_row_in.iit_ne_id) = true then r_inv_row.iit_xtra_char_1 := p_row_in.iit_xtra_char_1; end if; end if;
			if  p_row_in.iit_xtra_date_1 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_xtra_date_1'),p_row_in.iit_xtra_date_1,p_row_in.iit_ne_id) = true then r_inv_row.iit_xtra_date_1 := p_row_in.iit_xtra_date_1; end if; end if;
			if  p_row_in.iit_xtra_domain_1 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_xtra_domain_1'),p_row_in.iit_xtra_domain_1,p_row_in.iit_ne_id) = true then r_inv_row.iit_xtra_domain_1 := p_row_in.iit_xtra_domain_1; end if; end if;
			if  p_row_in.iit_xtra_domain_txt_1 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_xtra_domain_txt_1'),p_row_in.iit_xtra_domain_txt_1,p_row_in.iit_ne_id) = true then r_inv_row.iit_xtra_domain_txt_1 := p_row_in.iit_xtra_domain_txt_1; end if; end if;
			if  p_row_in.iit_xtra_number_1 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_xtra_number_1'),p_row_in.iit_xtra_number_1,p_row_in.iit_ne_id) = true then r_inv_row.iit_xtra_number_1 := p_row_in.iit_xtra_number_1; end if; end if;
			if  p_row_in.iit_x_sect is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_x_sect'),p_row_in.iit_x_sect,p_row_in.iit_ne_id) = true then r_inv_row.iit_x_sect := p_row_in.iit_x_sect; end if; end if;
			if  p_row_in.iit_det_xsp is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_det_xsp'),p_row_in.iit_det_xsp,p_row_in.iit_ne_id) = true then r_inv_row.iit_det_xsp := p_row_in.iit_det_xsp; end if; end if;
			if  p_row_in.iit_offset is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_offset'),p_row_in.iit_offset,p_row_in.iit_ne_id) = true then r_inv_row.iit_offset := p_row_in.iit_offset; end if; end if;
			if  p_row_in.iit_x is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_x'),p_row_in.iit_x,p_row_in.iit_ne_id) = true then r_inv_row.iit_x := p_row_in.iit_x; end if; end if;
			if  p_row_in.iit_y is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_y'),p_row_in.iit_y,p_row_in.iit_ne_id) = true then r_inv_row.iit_y := p_row_in.iit_y; end if; end if;
			if  p_row_in.iit_z is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_z'),p_row_in.iit_z,p_row_in.iit_ne_id) = true then r_inv_row.iit_z := p_row_in.iit_z; end if; end if;
			if  p_row_in.iit_num_attrib96 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib96'),p_row_in.iit_num_attrib96,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib96 := p_row_in.iit_num_attrib96; end if; end if;
			if  p_row_in.iit_num_attrib97 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib97'),p_row_in.iit_num_attrib97,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib97 := p_row_in.iit_num_attrib97; end if; end if;
			if  p_row_in.iit_num_attrib98 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib98'),p_row_in.iit_num_attrib98,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib98 := p_row_in.iit_num_attrib98; end if; end if;
			if  p_row_in.iit_num_attrib99 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib99'),p_row_in.iit_num_attrib99,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib99 := p_row_in.iit_num_attrib99; end if; end if;
			if  p_row_in.iit_num_attrib100 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib100'),p_row_in.iit_num_attrib100,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib100 := p_row_in.iit_num_attrib100; end if; end if;
			if  p_row_in.iit_num_attrib101 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib101'),p_row_in.iit_num_attrib101,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib101 := p_row_in.iit_num_attrib101; end if; end if;
			if  p_row_in.iit_num_attrib102 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib102'),p_row_in.iit_num_attrib102,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib102 := p_row_in.iit_num_attrib102; end if; end if;
			if  p_row_in.iit_num_attrib103 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib103'),p_row_in.iit_num_attrib103,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib103 := p_row_in.iit_num_attrib103; end if; end if;
			if  p_row_in.iit_num_attrib104 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib104'),p_row_in.iit_num_attrib104,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib104 := p_row_in.iit_num_attrib104; end if; end if;
			if  p_row_in.iit_num_attrib105 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib105'),p_row_in.iit_num_attrib105,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib105 := p_row_in.iit_num_attrib105; end if; end if;
			if  p_row_in.iit_num_attrib106 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib106'),p_row_in.iit_num_attrib106,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib106 := p_row_in.iit_num_attrib106; end if; end if;
			if  p_row_in.iit_num_attrib107 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib107'),p_row_in.iit_num_attrib107,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib107 := p_row_in.iit_num_attrib107; end if; end if;
			if  p_row_in.iit_num_attrib108 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib108'),p_row_in.iit_num_attrib108,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib108 := p_row_in.iit_num_attrib108; end if; end if;
			if  p_row_in.iit_num_attrib109 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib109'),p_row_in.iit_num_attrib109,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib109 := p_row_in.iit_num_attrib109; end if; end if;
			if  p_row_in.iit_num_attrib110 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib110'),p_row_in.iit_num_attrib110,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib110 := p_row_in.iit_num_attrib110; end if; end if;
			if  p_row_in.iit_num_attrib111 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib111'),p_row_in.iit_num_attrib111,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib111 := p_row_in.iit_num_attrib111; end if; end if;
			if  p_row_in.iit_num_attrib112 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib112'),p_row_in.iit_num_attrib112,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib112 := p_row_in.iit_num_attrib112; end if; end if;
			if  p_row_in.iit_num_attrib113 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib113'),p_row_in.iit_num_attrib113,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib113 := p_row_in.iit_num_attrib113; end if; end if;
			if  p_row_in.iit_num_attrib114 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib114'),p_row_in.iit_num_attrib114,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib114 := p_row_in.iit_num_attrib114; end if; end if;
			if  p_row_in.iit_num_attrib115 is not null then if is_updatable(r_inv_row.iit_inv_type,upper('iit_num_attrib115'),p_row_in.iit_num_attrib115,p_row_in.iit_ne_id) = true then r_inv_row.iit_num_attrib115 := p_row_in.iit_num_attrib115; end if; end if;
	
	/*
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
			*/
			
			if b_validate = true then
				NM3INV.VALIDATE_REC_IIT(r_inv_row);
			else
			
				/*
					SELECT 
						lower(', '|| column_name || ' = ' || ' p_row_in.'|| column_name )
						, a.*
						FROM   all_tab_cols a
						where owner = 'HIGHWAYS'
						and table_name = 'NM_INV_ITEMS'
						order by column_id
				*/
			
				update nm_inv_items set
				--iit_ne_id =  r_inv_row.iit_ne_id
				--, iit_inv_type =  r_inv_row.iit_inv_type
				--, iit_primary_key =  r_inv_row.iit_primary_key
				--, iit_start_date =  r_inv_row.iit_start_date
				--, iit_date_created =  r_inv_row.iit_date_created
				 iit_date_modified =  sysdate
				--, iit_created_by =  r_inv_row.iit_created_by
				--, iit_modified_by =  r_inv_row.iit_modified_by
				, iit_admin_unit =  r_inv_row.iit_admin_unit
				, iit_descr =  r_inv_row.iit_descr
				, iit_end_date =  r_inv_row.iit_end_date
				, iit_foreign_key =  r_inv_row.iit_foreign_key
				, iit_located_by =  r_inv_row.iit_located_by
				, iit_position =  r_inv_row.iit_position
				, iit_x_coord =  r_inv_row.iit_x_coord
				, iit_y_coord =  r_inv_row.iit_y_coord
				, iit_num_attrib16 =  r_inv_row.iit_num_attrib16
				, iit_num_attrib17 =  r_inv_row.iit_num_attrib17
				, iit_num_attrib18 =  r_inv_row.iit_num_attrib18
				, iit_num_attrib19 =  r_inv_row.iit_num_attrib19
				, iit_num_attrib20 =  r_inv_row.iit_num_attrib20
				, iit_num_attrib21 =  r_inv_row.iit_num_attrib21
				, iit_num_attrib22 =  r_inv_row.iit_num_attrib22
				, iit_num_attrib23 =  r_inv_row.iit_num_attrib23
				, iit_num_attrib24 =  r_inv_row.iit_num_attrib24
				, iit_num_attrib25 =  r_inv_row.iit_num_attrib25
				, iit_chr_attrib26 =  r_inv_row.iit_chr_attrib26
				, iit_chr_attrib27 =  r_inv_row.iit_chr_attrib27
				, iit_chr_attrib28 =  r_inv_row.iit_chr_attrib28
				, iit_chr_attrib29 =  r_inv_row.iit_chr_attrib29
				, iit_chr_attrib30 =  r_inv_row.iit_chr_attrib30
				, iit_chr_attrib31 =  r_inv_row.iit_chr_attrib31
				, iit_chr_attrib32 =  r_inv_row.iit_chr_attrib32
				, iit_chr_attrib33 =  r_inv_row.iit_chr_attrib33
				, iit_chr_attrib34 =  r_inv_row.iit_chr_attrib34
				, iit_chr_attrib35 =  r_inv_row.iit_chr_attrib35
				, iit_chr_attrib36 =  r_inv_row.iit_chr_attrib36
				, iit_chr_attrib37 =  r_inv_row.iit_chr_attrib37
				, iit_chr_attrib38 =  r_inv_row.iit_chr_attrib38
				, iit_chr_attrib39 =  r_inv_row.iit_chr_attrib39
				, iit_chr_attrib40 =  r_inv_row.iit_chr_attrib40
				, iit_chr_attrib41 =  r_inv_row.iit_chr_attrib41
				, iit_chr_attrib42 =  r_inv_row.iit_chr_attrib42
				, iit_chr_attrib43 =  r_inv_row.iit_chr_attrib43
				, iit_chr_attrib44 =  r_inv_row.iit_chr_attrib44
				, iit_chr_attrib45 =  r_inv_row.iit_chr_attrib45
				, iit_chr_attrib46 =  r_inv_row.iit_chr_attrib46
				, iit_chr_attrib47 =  r_inv_row.iit_chr_attrib47
				, iit_chr_attrib48 =  r_inv_row.iit_chr_attrib48
				, iit_chr_attrib49 =  r_inv_row.iit_chr_attrib49
				, iit_chr_attrib50 =  r_inv_row.iit_chr_attrib50
				, iit_chr_attrib51 =  r_inv_row.iit_chr_attrib51
				, iit_chr_attrib52 =  r_inv_row.iit_chr_attrib52
				, iit_chr_attrib53 =  r_inv_row.iit_chr_attrib53
				, iit_chr_attrib54 =  r_inv_row.iit_chr_attrib54
				, iit_chr_attrib55 =  r_inv_row.iit_chr_attrib55
				, iit_chr_attrib56 =  r_inv_row.iit_chr_attrib56
				, iit_chr_attrib57 =  r_inv_row.iit_chr_attrib57
				, iit_chr_attrib58 =  r_inv_row.iit_chr_attrib58
				, iit_chr_attrib59 =  r_inv_row.iit_chr_attrib59
				, iit_chr_attrib60 =  r_inv_row.iit_chr_attrib60
				, iit_chr_attrib61 =  r_inv_row.iit_chr_attrib61
				, iit_chr_attrib62 =  r_inv_row.iit_chr_attrib62
				, iit_chr_attrib63 =  r_inv_row.iit_chr_attrib63
				, iit_chr_attrib64 =  r_inv_row.iit_chr_attrib64
				, iit_chr_attrib65 =  r_inv_row.iit_chr_attrib65
				, iit_chr_attrib66 =  r_inv_row.iit_chr_attrib66
				, iit_chr_attrib67 =  r_inv_row.iit_chr_attrib67
				, iit_chr_attrib68 =  r_inv_row.iit_chr_attrib68
				, iit_chr_attrib69 =  r_inv_row.iit_chr_attrib69
				, iit_chr_attrib70 =  r_inv_row.iit_chr_attrib70
				, iit_chr_attrib71 =  r_inv_row.iit_chr_attrib71
				, iit_chr_attrib72 =  r_inv_row.iit_chr_attrib72
				, iit_chr_attrib73 =  r_inv_row.iit_chr_attrib73
				, iit_chr_attrib74 =  r_inv_row.iit_chr_attrib74
				, iit_chr_attrib75 =  r_inv_row.iit_chr_attrib75
				, iit_num_attrib76 =  r_inv_row.iit_num_attrib76
				, iit_num_attrib77 =  r_inv_row.iit_num_attrib77
				, iit_num_attrib78 =  r_inv_row.iit_num_attrib78
				, iit_num_attrib79 =  r_inv_row.iit_num_attrib79
				, iit_num_attrib80 =  r_inv_row.iit_num_attrib80
				, iit_num_attrib81 =  r_inv_row.iit_num_attrib81
				, iit_num_attrib82 =  r_inv_row.iit_num_attrib82
				, iit_num_attrib83 =  r_inv_row.iit_num_attrib83
				, iit_num_attrib84 =  r_inv_row.iit_num_attrib84
				, iit_num_attrib85 =  r_inv_row.iit_num_attrib85
				, iit_date_attrib86 =  r_inv_row.iit_date_attrib86
				, iit_date_attrib87 =  r_inv_row.iit_date_attrib87
				, iit_date_attrib88 =  r_inv_row.iit_date_attrib88
				, iit_date_attrib89 =  r_inv_row.iit_date_attrib89
				, iit_date_attrib90 =  r_inv_row.iit_date_attrib90
				, iit_date_attrib91 =  r_inv_row.iit_date_attrib91
				, iit_date_attrib92 =  r_inv_row.iit_date_attrib92
				, iit_date_attrib93 =  r_inv_row.iit_date_attrib93
				, iit_date_attrib94 =  r_inv_row.iit_date_attrib94
				, iit_date_attrib95 =  r_inv_row.iit_date_attrib95
				, iit_angle =  r_inv_row.iit_angle
				, iit_angle_txt =  r_inv_row.iit_angle_txt
				, iit_class =  r_inv_row.iit_class
				, iit_class_txt =  r_inv_row.iit_class_txt
				, iit_colour =  r_inv_row.iit_colour
				, iit_colour_txt =  r_inv_row.iit_colour_txt
				, iit_coord_flag =  r_inv_row.iit_coord_flag
				, iit_description =  r_inv_row.iit_description
				, iit_diagram =  r_inv_row.iit_diagram
				, iit_distance =  r_inv_row.iit_distance
				, iit_end_chain =  r_inv_row.iit_end_chain
				, iit_gap =  r_inv_row.iit_gap
				, iit_height =  r_inv_row.iit_height
				, iit_height_2 =  r_inv_row.iit_height_2
				, iit_id_code =  r_inv_row.iit_id_code
				, iit_instal_date =  r_inv_row.iit_instal_date
				, iit_invent_date =  r_inv_row.iit_invent_date
				, iit_inv_ownership =  r_inv_row.iit_inv_ownership
				, iit_itemcode =  r_inv_row.iit_itemcode
				, iit_lco_lamp_config_id =  r_inv_row.iit_lco_lamp_config_id
				, iit_length =  r_inv_row.iit_length
				, iit_material =  r_inv_row.iit_material
				, iit_material_txt =  r_inv_row.iit_material_txt
				, iit_method =  r_inv_row.iit_method
				, iit_method_txt =  r_inv_row.iit_method_txt
				, iit_note =  r_inv_row.iit_note
				, iit_no_of_units =  r_inv_row.iit_no_of_units
				, iit_options =  r_inv_row.iit_options
				, iit_options_txt =  r_inv_row.iit_options_txt
				, iit_oun_org_id_elec_board =  r_inv_row.iit_oun_org_id_elec_board
				, iit_owner =  r_inv_row.iit_owner
				, iit_owner_txt =  r_inv_row.iit_owner_txt
				, iit_peo_invent_by_id =  r_inv_row.iit_peo_invent_by_id
				, iit_photo =  r_inv_row.iit_photo
				, iit_power =  r_inv_row.iit_power
				, iit_prov_flag =  r_inv_row.iit_prov_flag
				, iit_rev_by =  r_inv_row.iit_rev_by
				, iit_rev_date =  r_inv_row.iit_rev_date
				, iit_type =  r_inv_row.iit_type
				, iit_type_txt =  r_inv_row.iit_type_txt
				, iit_width =  r_inv_row.iit_width
				, iit_xtra_char_1 =  r_inv_row.iit_xtra_char_1
				, iit_xtra_date_1 =  r_inv_row.iit_xtra_date_1
				, iit_xtra_domain_1 =  r_inv_row.iit_xtra_domain_1
				, iit_xtra_domain_txt_1 =  r_inv_row.iit_xtra_domain_txt_1
				, iit_xtra_number_1 =  r_inv_row.iit_xtra_number_1
				, iit_x_sect =  r_inv_row.iit_x_sect
				, iit_det_xsp =  r_inv_row.iit_det_xsp
				, iit_offset =  r_inv_row.iit_offset
				, iit_x =  r_inv_row.iit_x
				, iit_y =  r_inv_row.iit_y
				, iit_z =  r_inv_row.iit_z
				, iit_num_attrib96 =  r_inv_row.iit_num_attrib96
				, iit_num_attrib97 =  r_inv_row.iit_num_attrib97
				, iit_num_attrib98 =  r_inv_row.iit_num_attrib98
				, iit_num_attrib99 =  r_inv_row.iit_num_attrib99
				, iit_num_attrib100 =  r_inv_row.iit_num_attrib100
				, iit_num_attrib101 =  r_inv_row.iit_num_attrib101
				, iit_num_attrib102 =  r_inv_row.iit_num_attrib102
				, iit_num_attrib103 =  r_inv_row.iit_num_attrib103
				, iit_num_attrib104 =  r_inv_row.iit_num_attrib104
				, iit_num_attrib105 =  r_inv_row.iit_num_attrib105
				, iit_num_attrib106 =  r_inv_row.iit_num_attrib106
				, iit_num_attrib107 =  r_inv_row.iit_num_attrib107
				, iit_num_attrib108 =  r_inv_row.iit_num_attrib108
				, iit_num_attrib109 =  r_inv_row.iit_num_attrib109
				, iit_num_attrib110 =  r_inv_row.iit_num_attrib110
				, iit_num_attrib111 =  r_inv_row.iit_num_attrib111
				, iit_num_attrib112 =  r_inv_row.iit_num_attrib112
				, iit_num_attrib113 =  r_inv_row.iit_num_attrib113
				, iit_num_attrib114 =  r_inv_row.iit_num_attrib114
				, iit_num_attrib115 =  r_inv_row.iit_num_attrib115
				where iit_ne_id = n_iit_ne_id
				;
			end if;
			
	end process;
	
end x_ha_update_inv_item;