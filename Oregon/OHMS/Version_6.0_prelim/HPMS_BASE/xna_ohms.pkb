CREATE OR REPLACE PACKAGE BODY TRANSINFO.xna_ohms IS
/*
	This procedure auto-generates a PROCEDURE that populates an HPMS table according to the
	data stored in the OHMS_ tables.

	February 2011
	PSHEEDY
*/
----------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //new_vm_latest/archives/customer/Oregon/OHMS/Version_6.0_prelim/HPMS_BASE/xna_ohms.pkb-arc   1.0   Jan 15 2016 20:25:30   Sarah.Williams  $
-- Module Name : $Workfile:   xna_ohms.pkb  $
-- Date into PVCS : $Date:   Jan 15 2016 20:25:30  $
-- Date fetched Out : $Modtime:   Sep 29 2011 22:12:26  $
-- PVCS Version : $Revision:   1.0  $
----------------------------------------------------------


/*********************************************************************************	
**********************************************************************************	

   Returns the hard-coded version number

*********************************************************************************	
*********************************************************************************/
FUNCTION get_version RETURN VARCHAR2 IS
t_return	VARCHAR2(10);
BEGIN
	t_return		:= '7.6u';
	RETURN t_return;
END;


/*********************************************************************************	
**********************************************************************************	

   Processes all tables in a catalog.  For each table, generate a table insert proc

*********************************************************************************	
*********************************************************************************/
PROCEDURE GENERATE_CATALOG_ALL(p_catalog IN NUMBER) IS

t_catalog_table		NUMBER;

BEGIN
	t_catalog_table		:= -1;

	FOR c_table IN cur_catalog(p_catalog) LOOP
		t_catalog_table		:= c_table.ht_id;
		table_generate(t_catalog_table);
	END LOOP;
END;


/*********************************************************************************	
**********************************************************************************	

   Examine each data item (output column mapping) and generate the appropriate views.
   Once the views are created, write a procedure to use them to insert data into
   the specified target table.

*********************************************************************************	
*********************************************************************************/

PROCEDURE table_generate (p_table IN NUMBER DEFAULT 1, p_log IN VARCHAR2 DEFAULT 'YES') IS

BEGIN
	t_global_log			:= p_log;
	t_ht_id				:= NULL;
	t_hc_name			:= NULL;
	t_ht_name			:= NULL;
	t_ht_template			:= NULL;
	t_ht_hl_id			:= NULL;

/*********************************************************************************	
  Retrieve information from catalog/tables for passed table id
*********************************************************************************/
	OPEN cur_cat_table(p_table);
	FETCH cur_cat_table INTO t_hc_name, t_ht_name, t_ht_hl_id, t_ht_id;
	CLOSE cur_cat_table; 

	t_network_clause		:= NULL;
	t_network_mv_name		:= NULL;
	t_network_route_id		:= NULL;
	t_network_select		:= NULL;
	t_network_from			:= NULL;
	t_network_where			:= NULL;
	t_shape_count			:= 0;

	t_table_id			:= t_ht_id;

	t_procedure			:= NULL;
	t_mview_creates			:= NULL;
	t_table_creates			:= NULL;
	t_target_db_table		:= NULL;
	t_target_col_name		:= NULL;
	t_target_col_type		:= NULL;
	t_target_col_size		:= NULL;

	OPEN cur_procedure(t_table_id);
	FETCH cur_procedure INTO t_procedure, t_mview_creates, t_table_creates;
	CLOSE cur_procedure;

	dbms_lob.trim(t_procedure,1);
	dbms_lob.trim(t_mview_creates,1);
	dbms_lob.trim(t_table_creates,1);

/********************************************************************************
  If there is a network restriction that applies to all record types within
  the table being processed, then write a CREATE TABLE command with the sql
  that defines the network restriction.

  The table created will be included in each output record type.
*********************************************************************************/

	IF t_ht_hl_id <> -1 THEN
		lp_create_network_restriction;
	END IF;

/************************************************************************
 Create the Target Table that will hold the output data
************************************************************************/

	lp_create_target_table;

/************************************************************************
 Begin the procedure writing process by writing the Procedure Header info
************************************************************************/

	lp_begin_procedure_write;

/************************************************************************
  Read through the data items for the table and generate views for each
************************************************************************/

	FOR c_item IN cur_cursor_count(t_table_id) LOOP

		t_data_item			:= c_item.hm_hdi_id;
		t_aggregate_count		:= 0;
		t_outerjoin_count		:= 0;
		t_subview_count			:= 0;
		t_shape_count			:= 0;

-- check for SHAPE columns
		OPEN cur_shape_count(t_table_id, t_data_item);
		FETCH cur_shape_count INTO t_shape_count;
		CLOSE cur_shape_count;

-- check for SUM, COUNT, MIN, MAX
		OPEN cur_aggregate_count(t_table_id, t_data_item);
		FETCH cur_aggregate_count INTO t_aggregate_count;
		CLOSE cur_aggregate_count;

-- check for outer joins
		OPEN cur_outerjoin_count(t_table_id, t_data_item);
		FETCH cur_outerjoin_count INTO t_outerjoin_count;
		CLOSE cur_outerjoin_count;

-- check for subviews (queries that rely on other queries)
		OPEN cur_subview_count(t_table_id, t_data_item);
		FETCH cur_subview_count INTO t_subview_count;
		CLOSE cur_subview_count;

-- build the appropriate views
		CASE 
			WHEN t_aggregate_count > 0 THEN
				lp_build_aggregate_table;
				lp_build_aggregate_view;
			WHEN t_outerjoin_count > 0 THEN
				lp_build_outerjoin_table;
				lp_build_view('SIMPLE');
			WHEN t_subview_count > 0 THEN
				lp_build_view('SUBVIEW');
			WHEN t_shape_count > 0 THEN
				lp_build_shape_view;
			ELSE
				lp_build_view('SIMPLE');
		END CASE;

	END LOOP;

/*********************************************************************************************

 Complete the rest of the procedure:
	- define variables
	- write body of procedure
		* variable initialization
		* write cursor loops to INSERT records
		* write error routine for each cursor
	- write error routine for main body

**********************************************************************************************/
		
	lp_complete_the_procedure;
	COMMIT;
END;

PROCEDURE lp_complete_the_procedure IS

BEGIN
	t_template			:= NULL;
	t_template_line			:= NULL;
	t_template_read			:= 0;

	OPEN cur_template('BODY','PROCEDURE');
	FETCH cur_template INTO t_template;
	CLOSE cur_template;

	IF t_template IS NOT NULL THEN

		t_template_length		:= dbms_lob.getlength(t_template);
		t_template_read			:= 100;
		t_template_start		:= 1;
		t_template_return_count		:= 1;
		t_template_return_pos		:= 0;

		t_sub_start			:= 0;
		t_sub_return_count		:= 0;

		WHILE t_template_return_pos IS NOT NULL LOOP
			BEGIN
				t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

				IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
					t_template_read			:= t_template_return_pos - t_template_start;

					IF t_template_read > 0 THEN
						dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					ELSE
						t_template_line		:= chr(10);
					END IF;

					t_template_start		:= t_template_return_pos + 1;
					
					IF instr(t_template_line,'<<Column Variables>>') > 0 THEN
						t_variables_line		:= NULL;
						FOR c_col IN cur_columns(t_ht_id) LOOP
							t_variables_line	:= t_variables_line ||t_newline;
							t_repeat		:= 7 - trunc((length('t_' || lower(c_col.hcl_name) || '_var')/4));
							t_variables_line	:= t_variables_line || 't_' || lower(c_col.hcl_name) ||
											'_var' || rpad(t_tab,t_repeat,t_tab);
		
							IF c_col.hcl_type = 'DATE' THEN
								t_variables_line		:= t_variables_line || c_col.hcl_type || ';';
							ELSIF nvl(c_col.hcl_size,'-x') = '-x' THEN
								t_variables_line		:= t_variables_line || c_col.hcl_type || ';';
							ELSE
								t_variables_line		:= t_variables_line || c_col.hcl_type || '(' ||
												c_col.hcl_size || ');';
							END IF;
						END LOOP;
						t_variables_line		:= t_variables_line || t_newline;
		
						t_procedure_line_length		:= length(t_variables_line);
						t_procedure_line		:= t_variables_line;
						t_procedure_line_length		:= length(t_procedure_line);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

-- Stick in the table id for error reporting
					ELSIF instr(t_template_line,'<<table code>>') > 0 THEN
						t_template_line			:= replace(t_template_line,'<<table code>>',t_table_id);
		
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;

						t_lob_length			:= dbms_lob.getlength(t_procedure_line);

						IF instr(t_procedure_line,'CREATE OR REPLACE PROCEDURE') > 0 THEN
							dbms_lob.write(t_procedure, t_procedure_line_length, 1, t_procedure_line);
						ELSE
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
						END IF;
					ELSIF instr(t_template_line,'<<Clear Target Table>>') > 0 THEN
-- Clear the target table
						t_variables_line		:= NULL;
						t_target_table			:= NULL;

						OPEN cur_target_table (t_ht_id);
						FETCH cur_target_table INTO t_target_table;
						CLOSE cur_target_table;

						t_variables_line		:= t_newline || t_tab ||  t_tab || 'DELETE FROM ' || upper(t_target_table) || ';' || t_newline;

						t_procedure_line_length		:= length(t_variables_line);
						t_procedure_line		:= t_variables_line;
						t_procedure_line_length		:= length(t_procedure_line);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

						t_variables_line		:= t_newline || t_tab ||  t_tab || 'COMMIT;' || t_newline;

						t_procedure_line_length		:= length(t_variables_line);
						t_procedure_line		:= t_variables_line;
						t_procedure_line_length		:= length(t_procedure_line);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

					ELSIF instr(t_template_line,'<<Cursor Processing>>') > 0 THEN
						t_variables_line		:= NULL;
						FOR c_cursor IN cur_output_cursors(t_ht_id) LOOP
-- Process Cursors
-- For each record type/data item...
							t_cursor_id		:= c_cursor.hm_hdi_id;
							t_cursor_name		:= 'cur_' || t_cursor_id;
							t_cursor_abbrev		:= 'c_' || t_cursor_id;

							t_variables_line		:= NULL;
-- Add a comment for clarity
							OPEN cur_item_desc(t_ht_id, t_cursor_id);
							FETCH cur_item_desc INTO t_cursor_descr;
							CLOSE cur_item_desc;

							t_variables_line	:= t_newline || 
										'/******************************************************' ||
										t_newline || t_tab || t_tab ||
										' Processing Cursor #' || t_cursor_id || ': ' || t_cursor_descr || t_newline ||
										'******************************************************/';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

-- BEGIN
							t_variables_line		:= NULL;
							t_variables_line		:= t_newline ||  t_tab || 'BEGIN';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
-- Create Variables for this data item
							t_variables_line		:= NULL;
							FOR c_col IN cur_columns(t_ht_id) LOOP
								t_variables_line	:= t_variables_line ||t_newline;
								t_repeat		:= 7 - trunc((length('t_' || lower(c_col.hcl_name) || '_var')/4));
								t_variables_line	:= t_variables_line || t_tab ||  t_tab || 't_' || lower(c_col.hcl_name) || '_var' ||
												rpad(t_tab,t_repeat,t_tab) || ' := NULL;';
							END LOOP;
							t_variables_line		:= t_variables_line || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

-- Process Functions and Text entries
							t_procedure_line		:= NULL;
							t_variables_line		:= NULL;
							t_single_item_name		:= NULL;
							t_single_item			:= NULL;
							t_single_item_type		:= NULL;
							t_log_item			:= NULL;

							FOR c_singles IN cur_map_singles(t_ht_id, t_cursor_id) LOOP
								t_single_item_name	:= c_singles.hcl_name;
								t_single_item		:= c_singles.hm_item_value;
								t_single_item_type	:= c_singles.hm_item_type;

								CASE t_single_item_type
									WHEN 'TEXT' THEN

										t_repeat		:= 7 - trunc((length('t_' || lower(t_single_item_name) || '_var')/4));
										t_procedure_line	:= t_tab ||  t_tab || 't_' || lower(t_single_item_name) || '_var' ||
													rpad(t_tab,t_repeat,t_tab) || ' := ' || '''' || t_single_item || '''' ||';';
										IF nvl(t_log_item,'-x') = '-x' THEN
											t_log_item	:= t_single_item ;
										ELSE
											t_log_item	:= t_log_item || ', '|| t_single_item ;
										END IF;
									WHEN 'FUNCTION' THEN
										t_procedure_line	:= t_newline || t_tab ||  t_tab || 'SELECT ' ||
													t_single_item || ' INTO ' ||
													't_' || lower(t_single_item_name) || '_var' ||
													' FROM DUAL;';
								END CASE;

								t_procedure_line		:= t_newline || t_procedure_line || t_newline;
								t_procedure_line_length		:= length(t_procedure_line);
								dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
							END LOOP;
-- Populate the log-item variable
-- so that it will appear in the 
-- activity log
							t_repeat		:= 7 - trunc((length('t_item_descr')/4));
							IF nvl(t_log_item,'-x') = '-x' THEN
								t_procedure_line	:= t_tab ||  t_tab || 't_item_descr' ||
											rpad(t_tab,t_repeat,t_tab) || ' := NULL;';
							ELSE
								t_procedure_line	:= t_tab ||  t_tab || 't_item_descr' ||
											rpad(t_tab,t_repeat,t_tab) || ' := ' || '''' || t_log_item || '''' ||';';
							END IF;

							t_procedure_line		:= t_procedure_line || t_newline;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							
-- Create a cursor loop to process 
-- add cursor data to the target table
							t_variables_line		:= t_newline || t_tab || t_tab || 
												'FOR ' || t_cursor_abbrev ||
												' IN ' || t_cursor_name || ' LOOP';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							t_variables_line		:= NULL;
							t_repeat			:= 0;
							t_all_var_columns		:= NULL;
							t_all_target_columns		:= NULL;
							t_min_hm_id			:= NULL;

							OPEN cur_get_min_hmid (t_ht_id, t_cursor_id);
							FETCH cur_get_min_hmid INTO t_min_hm_id;
							CLOSE cur_get_min_hmid;
-- this is where the addl items go...
							FOR c_all1 IN cur_columns(t_ht_id) LOOP
								IF nvl(t_all_var_columns,'-x') <> '-x' THEN
									t_all_target_columns	:= t_all_target_columns || ', ' || c_all1.hcl_name;
									t_all_var_columns	:= t_all_var_columns || ',' ||
											't_' || lower(c_all1.hcl_name) || '_var';
								ELSE
									t_all_target_columns	:= c_all1.hcl_name;
									t_all_var_columns	:= 't_' || lower(c_all1.hcl_name) || '_var';
								END IF;
							END LOOP;
---  above this line
							FOR c_all IN cur_map_multiples(t_ht_id, t_cursor_id) LOOP
								IF nvl(c_all.hm_item_type,'TEXT') NOT IN ('TEXT','FUNCTION') THEN
									t_variables_line	:= t_newline || t_tab || t_tab || t_tab;
									t_repeat		:= 7 - trunc((length('t_' || lower(c_all.hcl_name) || '_var')/4));
									t_variables_line	:= t_variables_line || 't_' || lower(c_all.hcl_name) || '_var' ||
												rpad(t_tab,t_repeat,t_tab) || ':= ' || t_cursor_abbrev ||
												'.' || c_all.hcl_name || ';';

									t_procedure_line_length		:= length(t_variables_line);
									t_procedure_line		:= t_variables_line;
									t_procedure_line_length		:= length(t_procedure_line);
									dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
								END IF;
							END LOOP;
-- Write the insert statement
							t_variables_line		:= t_newline || t_newline || t_tab || t_tab || t_tab || 
											'INSERT INTO ' || t_target_table ||
											'(' || t_all_target_columns || ') ' ||
											t_newline || t_tab || t_tab || t_tab || 
											'VALUES(' || t_all_var_columns || ');' || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
-- Commit
							t_variables_line		:= t_newline || t_tab || t_tab || t_tab;
							t_variables_line		:= t_variables_line || 'COMMIT;';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
-- End the cursor loop
							t_variables_line		:= t_newline || t_tab ||  t_tab || 'END LOOP;' || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
-- Write to the activity log
							t_variables_line		:= t_newline || t_tab ||  t_tab || 'SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;' || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							t_variables_line		:= t_newline || t_tab ||  t_tab || 'SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;' || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							t_variables_line		:= NULL;
							t_variables_line		:= t_newline || t_tab ||  t_tab || 'INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							t_variables_line		:= NULL;
							t_variables_line		:= t_newline || t_tab ||  t_tab || 'VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, ' || '''' || 'SUCCESS' || '''' || ');';
							t_variables_line		:= t_variables_line || t_newline;

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

							t_variables_line		:= t_newline || t_tab ;
							t_variables_line		:= t_variables_line ||  t_tab || 'COMMIT;';
-- Commit
							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
-- Add the exception clause
							lp_add_exception_clause;
-- End
							t_variables_line		:= NULL;
							t_variables_line		:= t_newline ||  t_tab || 'END;';

							t_procedure_line_length		:= length(t_variables_line);
							t_procedure_line		:= t_variables_line;
							t_procedure_line_length		:= length(t_procedure_line);
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

						END LOOP;
					ELSE
						t_template_line			:= t_template_line || t_newline;
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;
						t_procedure_line_length		:= length(t_procedure_line);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
					END IF;

					t_template_return_count		:= t_template_return_count + 1;
				ELSE
					EXIT;
				END IF;
			END;
		END LOOP;
	END IF;
END;

PROCEDURE lp_add_exception_clause IS
BEGIN
	t_variables_line		:= NULL;
	t_variables_line		:= t_newline || t_newline ||  t_tab || 'EXCEPTION WHEN OTHERS THEN';

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= NULL;
	t_variables_line		:= t_newline || t_tab ||  t_tab || 't_error			:= sqlcode;';

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= NULL;
	t_variables_line		:= t_newline || t_tab ||  t_tab || 't_error_desc		:= substr(sqlerrm,1,400);';

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= t_newline || t_tab ||  t_tab || 'SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;' || t_newline;

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= t_newline || t_tab ||  t_tab || 'SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;' || t_newline ;

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= NULL;

	t_variables_line		:= t_newline || t_tab ||  t_tab || 'INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)';
	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= NULL;
	t_variables_line		:= t_newline || t_tab ||  t_tab || 'VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, ' || '''' || 'ERROR' || '''' || ', t_error_desc);';

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	t_variables_line		:= t_newline || t_tab ;
	t_variables_line		:= t_variables_line ||  t_tab || 'COMMIT;' || t_newline;

	t_procedure_line_length		:= length(t_variables_line);
	t_procedure_line		:= t_variables_line;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
END;



FUNCTION lf_generate_shape_view RETURN VARCHAR2 IS

BEGIN
	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

	WHILE t_template_return_pos IS NOT NULL LOOP
		BEGIN
			t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

			IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
				t_template_read			:= t_template_return_pos - t_template_start;

				IF t_template_read > 0 THEN
					dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					t_whitespace			:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
				ELSE
					t_template_line		:= chr(10);
					t_whitespace		:= ' ';
				END IF;

				t_template_start		:= t_template_return_pos + 1;

				IF nvl(t_output,'-x') = '-x' THEN

					t_output	:= t_output || t_newline || t_whitespace ||
							'CURSOR CUR_' || t_data_item || ' IS ' || t_newline;

					t_counter			:= 1;
					t_group_type			:= NULL;
					t_network_type			:= NULL;

					t_output			:= t_output || t_whitespace || ltrim(t_template_line,' ');

				ELSIF instr(t_template_line,'<<shape cursor fields>>') > 0 THEN
					FOR c_shape IN cur_shape_columns(t_table_id) LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_newline || t_whitespace || c_shape.hm_item_value || ' ' ||
										c_shape.hcl_name;
						ELSE
							t_output	:= t_output || t_newline || t_whitespace || ', ' || c_shape.hm_item_value || ' ' ||
										c_shape.hcl_name;
						END IF;
						t_counter		:= t_counter + 1;
						t_group_type		:= c_shape.hm_item;
					END LOOP;

					t_output	:= t_output || t_newline;

				ELSIF instr(t_template_line,'<<network group>>') > 0 THEN
					OPEN cur_network_group(t_group_type);
					FETCH cur_network_group INTO t_network_type;
					CLOSE cur_network_group;

					t_output	:= t_output || t_whitespace || replace(t_template_line,'<<network group>>',t_network_type || '_' || t_group_type);

				ELSE
					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;
			ELSE
				EXIT;
			END IF;

			t_template_return_count		:= t_template_return_count + 1;
		END;
	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_subview_view RETURN VARCHAR2 IS

BEGIN
	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

	t_point_cont			:= 'C';

	WHILE t_template_return_pos IS NOT NULL LOOP
		BEGIN
			t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

			IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
				t_template_read		:= t_template_return_pos - t_template_start;

				IF t_template_read > 0 THEN
					dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
				ELSE
					t_template_line		:= chr(10);
					t_whitespace		:= ' ';
				END IF;

				t_template_start		:= t_template_return_pos + 1;

				IF nvl(t_output,'-x') = '-x' THEN

					t_output	:= t_output || t_newline || t_whitespace ||
							'CURSOR CUR_' || t_data_item || ' IS ' || t_newline;

					tab_alias.delete;
					tab_item.delete;
					tab_formula.delete;
					tab_column.delete;
					tab_view_column.delete;
					tab_where_clause.delete;
					tab_item_value.delete;

					t_counter		:= 0;
					FOR c_subviews IN cur_sub_view_items(t_table_id, t_data_item) LOOP
						IF t_counter = 0 THEN
							t_min_hm_id			:= c_subviews.hm_id;
						END IF;
						t_counter					:= t_counter + 1;
						tab_alias(t_counter)				:= 'SUB' || c_subviews.hm_item;
						tab_item(t_counter)				:= c_subviews.hm_item;
						tab_column(t_counter)				:= c_subviews.hcl_name;
						tab_item_value(t_counter)			:= c_subviews.hm_item_value;
						IF  nvl(c_subviews.hm_item_formula,'-x') = '-x' THEN
							tab_formula(t_counter)				:= NULL;
						ELSE
							tab_formula(t_counter)				:= c_subviews.hm_item_formula;
						END IF;

						OPEN cur_get_min_hmid(t_table_id, c_subviews.hm_item);
						FETCH cur_get_min_hmid INTO t_min_hm_id;
						CLOSE cur_get_min_hmid;

						OPEN cur_get_output_column(t_min_hm_id);
						FETCH cur_get_output_column INTO t_viewcolumn;
						CLOSE cur_get_output_column;
						
						tab_view_column(t_counter)			:= t_viewcolumn;
						tab_where_clause(t_counter)			:= c_subviews.hm_where_clause;
					END LOOP;

					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;

				ELSIF instr(t_template_line,'<<sub_field_formula>>') > 0 THEN
					
					IF nvl(trim(tab_formula(1)),'-x') = '-x' THEN
						t_output	:= t_output || t_whitespace || ', ' || tab_alias(1) || '_' || tab_item_value(1) || ' ' || tab_column(1) || t_newline;
					ELSE
						t_output	:= t_output || t_whitespace || ', ' || trim(tab_formula(1)) || ' ' || tab_column(1) || t_newline;
					END IF;

					FOR t_loop IN 2..tab_alias.count LOOP
						t_output_count		:= 0;
						OPEN cur_get_sub_output(t_ht_id, t_data_item, tab_column(t_loop ), tab_item(t_loop));
						FETCH cur_get_sub_output INTO t_output_count;
						CLOSE cur_get_sub_output;

						IF nvl(t_output_count,0) > 0 THEN
							t_output		:= t_output || t_whitespace || ', ' || tab_alias(t_loop) || '_' || 
										tab_item_value(t_loop) || ' ' || tab_column(t_loop) || t_newline;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_route_id>>') > 0 THEN
					t_output		:= t_output || t_whitespace || 's.route_id' || t_newline;

				ELSIF instr(t_template_line,'<<sub_begin_point>>') > 0 THEN
					t_output		:= t_output || t_whitespace || ', s.begin_point' || t_newline;

				ELSIF instr(t_template_line,'<<sub_end_point>>') > 0 THEN
					t_output		:= t_output || t_whitespace || ', s.end_point' || t_newline;

				ELSIF instr(t_template_line,'<<sub_fields>>') > 0 THEN

					FOR t_loop IN 1..tab_alias.count LOOP
						t_output		:= t_output || t_whitespace || 
									', ' || tab_alias(t_loop) || '.' || tab_item_value(t_loop) || ' ' || 
									tab_alias(t_loop) || '_' || tab_item_value(t_loop) || t_newline;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_view_points>>') > 0 THEN
					FOR t_loop IN 1..tab_item.count LOOP
						OPEN cur_item_desc(t_table_id, tab_item(t_loop));
						FETCH cur_item_desc INTO t_item_desc;
						CLOSE cur_item_desc;

						t_viewname	:= substr('V_OHMS_FINAL_' || t_ht_id || '_' || tab_item(t_loop) || '_' || replace(t_item_desc,' ','_'),1,30);

						t_loop_dup	:= 0;
						IF t_loop > 1 THEN
							FOR t_loop2 IN 1..t_loop -1 LOOP
								IF tab_item(t_loop2) = tab_item(t_loop) THEN
									t_loop_dup		:= 1;
								END IF;
							END LOOP;
						END IF;

						IF t_loop_dup = 0 AND t_loop = 1 THEN
							t_output	:= t_output || t_whitespace || 'SELECT route_id, begin_point pte FROM ' || t_viewname || t_newline;
							t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
							t_output	:= t_output || t_whitespace || 'SELECT route_id, end_point pte FROM ' || t_viewname || t_newline;
						ELSIF t_loop_dup = 0 AND t_loop > 1 THEN
							t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
							t_output	:= t_output || t_whitespace || 'SELECT route_id, begin_point pte FROM ' || t_viewname || t_newline;
							t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
							t_output	:= t_output || t_whitespace || 'SELECT route_id, end_point pte FROM ' || t_viewname || t_newline;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_views>>') > 0 THEN

					t_viewname				:= NULL;
					FOR t_loop IN 1..tab_alias.count LOOP
						OPEN cur_item_desc(t_table_id, tab_item(t_loop));
						FETCH cur_item_desc INTO t_item_desc;
						CLOSE cur_item_desc;

						t_viewname			:= substr('V_OHMS_FINAL_' || t_ht_id || '_' || tab_item(t_loop) || '_' || replace(t_item_desc,' ','_'),1,30);

						IF t_loop = 1 THEN
							t_output		:= t_output || t_whitespace || ', ' || t_viewname || ' ' || tab_alias(t_loop) || t_newline;
						ELSE
							t_loop_dup	:= 0;
							FOR t_loop2 IN 1..t_loop -1 LOOP
								IF tab_item(t_loop2) = tab_item(t_loop) THEN
									t_loop_dup		:= 1;
								END IF;
							END LOOP;

							IF t_loop_dup = 0 THEN
							t_output		:= t_output || t_whitespace || ', ' || t_viewname || ' ' || tab_alias(t_loop) || t_newline;
							END IF;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_joins>>') > 0 THEN

					t_viewname				:= NULL;
					FOR t_loop IN 1..tab_alias.count LOOP
						t_loop_dup	:= 0;
						FOR t_loop2 IN 1..t_loop -1 LOOP
							IF tab_item(t_loop2) = tab_item(t_loop) THEN
								t_loop_dup		:= 1;
							END IF;
						END LOOP;

						IF t_loop_dup = 0 THEN

							t_output		:= t_output || t_whitespace || 'AND ' || 
										' s.route_id = ' || tab_alias(t_loop) || '.route_id(+)' || t_newline;
							t_output		:= t_output || t_whitespace || 'AND ' || 
										 ' s.begin_point < ' || tab_alias(t_loop) || '.end_point(+)' || t_newline;
							t_output		:= t_output || t_whitespace || 'AND ' || 
										 ' s.end_point > ' || tab_alias(t_loop) || '.begin_point(+)' || t_newline;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_attrib_where>>') > 0 THEN

					FOR t_loop IN 1..tab_item.count LOOP
						IF nvl(trim(tab_where_clause(t_loop)),'-x') <> '-x' THEN
							t_output		:= t_output || t_whitespace || 'AND SUB' || 
										tab_item(t_loop) || '_' || tab_where_clause(t_loop) || t_newline;
						END IF;
					END LOOP;
					t_output	:= t_output || t_whitespace || ';' ;

				ELSE
					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;
			ELSE
				EXIT;
			END IF;

			t_template_return_count		:= t_template_return_count + 1;
		END;
	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_aggregate_table_pt RETURN VARCHAR2 IS


BEGIN

	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

/*********************************************************************************************
 	Generate TABLEs for all Aggregate data items
	SUM, COUNT, MIN, MAX
**********************************************************************************************/

	WHILE t_template_return_pos IS NOT NULL LOOP
		BEGIN
			t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

			IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
				t_template_read			:= t_template_return_pos - t_template_start;

				IF t_template_read > 0 THEN
					dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
				ELSE
					t_template_line		:= chr(10);
					t_whitespace		:= ' ';
				END IF;
				t_template_start		:= t_template_return_pos + 1;

				t_route_sql			:= NULL;
				t_cursor_id			:= t_data_item;
				t_cursor_name			:= 'cur_' || t_cursor_id;

				IF nvl(t_output,'-x') = '-x' THEN

					t_route_restrict		:= 'BOTH';
					t_formula_used			:= FALSE;
					t_min_hm_id			:= 0;
					t_primary_name			:= NULL;
					t_primary_item			:= NULL;
					t_primary_value			:= NULL;
					t_primary_attribute		:= NULL;
					t_primary_where			:= NULL;
					t_primary_type			:= NULL;
					t_primary_function		:= NULL;
					t_primary_formula		:= NULL;
					t_primary_hdi_id		:= NULL;
					t_range_item			:= NULL;
					t_range_value			:= NULL;
					t_range_attribute		:= NULL;
					t_range_where			:= NULL;
					t_range_type			:= NULL;	
					t_route_item			:= NULL;	
					t_route_item_value		:= NULL;
					t_route_item_attribute		:= NULL;
					t_route_item_where		:= NULL;
					t_route_item_type		:= NULL;
					t_route_table			:= NULL;
					t_base_name			:= NULL;

					OPEN cur_get_min_hmid(t_table_id, t_data_item);
					FETCH cur_get_min_hmid INTO t_min_hm_id;
					CLOSE cur_get_min_hmid;

					OPEN cur_primary_item(t_min_hm_id);
					FETCH cur_primary_item INTO t_primary_name
						, t_primary_item
						, t_primary_value
						, t_primary_attribute
						, t_primary_where
						, t_primary_type
						, t_primary_function
						, t_primary_formula
						, t_primary_hdi_id
						, t_primary_join;
					CLOSE cur_primary_item;

					OPEN cur_aggregate_range(t_table_id, t_cursor_id);
					FETCH cur_aggregate_range INTO t_range_item
							, t_range_value
							, t_range_type
							, t_range_attribute
							, t_range_where;
					CLOSE cur_aggregate_range;
	
					IF nvl(trim(t_primary_formula),'-x') <> '-x' THEN
						t_formula_used		:= TRUE;
					END IF;

					OPEN cur_route_restrict(t_table_id, t_data_item);
					FETCH cur_route_restrict INTO t_route_restrict;
					CLOSE cur_route_restrict;

					FOR c_map IN cur_map_all(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' THEN
							t_route_item			:= c_map.hm_item;
							t_route_item_value		:= c_map.hm_item_value;
							t_route_item_attribute		:= c_map.hm_item_attribute;
							t_route_item_where		:= c_map.hm_item_where;
							t_route_item_type		:= c_map.hm_item_type;
							t_route_table			:= 'OHMS_TMP_RTE_ITEM_' || c_map.hm_item;
						END IF;
					END LOOP;

					tab_alias.delete;
					tab_item.delete;
					tab_from.delete;
					tab_type.delete;
					tab_table.delete;
					tab_rte_table.delete;

					tab_alias(1)				:= 'a';
					tab_item(1)				:= t_primary_item;
					tab_type(1)				:= t_primary_type;
					tab_table(1)				:= 'OHMS_TMP_' || t_table_id || 
											'_' || t_data_item || '_' || t_primary_item;
					tab_rte_table(1)			:= 'OHMS_TMP_RTE_' || t_table_id || 
											'_' || t_data_item || '_' || t_primary_item;
					t_aggregate_seg_table			:= 'OHMS_TMP_SEG_' || t_table_id || '_' || t_data_item || '_' || t_primary_item;
					t_aggregate_detail_table		:= 'OHMS_TMP_DETAIL_' || t_table_id || '_' || t_data_item || '_' || t_primary_item;

					IF t_network_flag > 0 THEN
						tab_alias(2)			:= 'b';
						tab_item(2)			:= 'NETWORK';
						tab_type(2)			:= 'NETWORK';
						tab_table(2)			:= t_network_mv_name;
						tab_rte_table(2)		:= 'x';
					ELSE
						tab_alias(2)			:= 'x';
						tab_item(2)			:= 'x';
						tab_type(2)			:= 'x';
						tab_table(2)			:= 'x';
						tab_rte_table(2)		:= 'x';
					END IF;

					t_counter				:= tab_alias.count;
					FOR c_adddl_items IN cur_aggregate_item_list (t_table_id, t_data_item) LOOP
						t_found		:= 0;
						FOR t_loop IN 1..tab_alias.count LOOP
							IF c_adddl_items.hm_item = tab_item(t_loop) THEN
								t_found		:= 1;
							END IF;
						END LOOP;

						IF t_found = 0 THEN
							t_counter						:= t_counter + 1;
							SELECT decode(t_counter,3, 'c', 4, 'd', 5, 'e', 6, 'f', 7 ,'g','h')
							INTO t_alias
							FROM DUAL;

							tab_alias(t_counter)		:= t_alias;
							tab_item(t_counter)		:= c_adddl_items.hm_item;
							tab_type(t_counter)		:= c_adddl_items.hm_item_type;
							tab_table(t_counter)		:= 'OHMS_TMP_' || t_table_id || 
											'_' || t_data_item || '_' ||  c_adddl_items.hm_item;
							tab_rte_table(t_counter)	:= 'OHMS_TMP_RTE_' || t_table_id || 
											'_' || t_data_item || '_' ||  c_adddl_items.hm_item;
						END IF;
					END LOOP;

					IF tab_type(1) = 'ASSET' THEN
						t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
						t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
									' FROM ( ' ||
									    ' SELECT nit_pnt_or_cont ' ||
									    ' FROM nm_inv_types_all ' ||
									    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
									     'UNION ' ||
									     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

						EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
						IF t_point_cont	= '-x' THEN
							t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
										' WHERE rownum < 10';
		
							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
							IF t_point_cont = '0'THEN
								t_point_cont 	:= 'P';
							ELSE
								t_point_cont 	:= 'C';
							END IF;
						END IF;
					ELSE
						t_point_cont 	:= 'C';
					END IF;

					IF t_primary_function IN ('SUM', 'COUNT', 'MIN', 'MAX') THEN
						t_mview_name	:= 'v_nm_' || lower(t_primary_item) || t_primary_hdi_id || '_' || lower(t_primary_function);
						IF t_primary_type = 'ASSET' THEN
							t_mview_name	:= t_mview_name || '_mv_nw';
						ELSIF t_primary_type = 'GROUP' THEN
							t_mview_name	:= t_mview_name || '_nt_mv';
						END IF;

						t_aggregate_final_table			:= t_mview_name;
						t_base_name				:= 'v_nm_' || lower(t_primary_item) || t_primary_hdi_id || '_' 
												|| lower(t_primary_function) || '_base';

					END IF;
					t_output	:= t_output || t_newline || t_whitespace || ltrim(t_template_line,' ') || t_newline;

					OPEN cur_item_desc(t_table_id, t_data_item);
					FETCH cur_item_desc INTO t_cursor_descr;
					CLOSE cur_item_desc;

				ELSIF instr(t_template_line,'<<aggregate data item descr>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate data item descr>>',t_cursor_descr) || t_newline;

				ELSIF instr(t_template_line,'<<setup temp tables>>') > 0  THEN
					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;
					
					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
						t_output	:= t_output || 'CREATE TABLE ' || tab_table(t_loop) || ' AS ' || t_newline;
						t_output	:= t_output || 'SELECT * FROM ' || t_newline;
						IF tab_type(t_loop) = 'ASSET' THEN
							t_output	:= t_output || '     ' || 'v_nm_' || tab_item(t_loop) || '_nw'|| t_newline;
						ELSE
							t_output	:= t_output || '     ' || 'v_nm_' || tab_item(t_loop) || '_nt'|| t_newline;
							t_output	:= t_output || '     ' || ', nm_members'|| t_newline;
						END IF;
						t_output	:= t_output || 'WHERE 1=1 ' || t_newline;

						IF tab_type(t_loop) = 'GROUP' THEN
							t_output	:= t_output || '     ' || 'AND ne_id = nm_ne_id_of' || t_newline;
						END IF;

						FOR c_where IN cur_aggregate_where_list(t_table_id, t_data_item, tab_item(t_loop)) LOOP
							t_output	:= t_output || '     ' || c_where.where_clause || t_newline;
						END LOOP;						
						t_output	:= t_output || t_whitespace || ';' || t_newline;
						
						IF tab_type(t_loop) = 'ASSET' THEN
							t_output	:= t_output || 'CREATE INDEX ' || tab_table(t_loop) || '_IDX ON ' ||
										tab_table(t_loop) || '(ne_id_of);' || t_newline;
						ELSE
							t_output	:= t_output || 'CREATE INDEX ' || tab_table(t_loop) || '_IDX ON ' ||
										tab_table(t_loop) || '(nm_ne_id_of);' ||  t_newline;
						END IF;
						END IF;
						t_output	:= t_output || t_newline;
					END LOOP;

					IF nvl(t_route_item,'-x') <> '-x' THEN 
						t_output	:= t_output || 'DROP TABLE ' || t_route_table || ';' || t_newline;
						t_output	:= t_output || 'CREATE TABLE ' || t_route_table || ' AS ' || t_newline;
						t_output	:= t_output || 'SELECT * FROM ' || t_newline;

						IF t_route_type = 'ASSET' THEN
							t_output	:= t_output || '     ' || 'v_nm_' || lower(t_route_item) || '_nw'|| t_newline;
						ELSE
							t_output	:= t_output || '     ' || 'v_nm_' || lower(t_route_item) || '_nt'|| t_newline;
							IF t_route_restrict = 'D' THEN
								t_output	:= t_output || '     ' || ', nm_members_d'|| t_newline;
							ELSIF t_route_restrict = 'I'THEN
								t_output	:= t_output || '     ' || ', nm_members_i'|| t_newline;
							ELSE
								t_output	:= t_output || '     ' || ', nm_members'|| t_newline;
							END IF;
						END IF;
						t_output	:= t_output || 'WHERE 1=1 ' || t_newline;

						IF t_route_item_type = 'GROUP' THEN
							t_output	:= t_output || '     ' || 'AND ne_id = nm_ne_id_in' || t_newline;
						END IF;

						IF nvl(t_route_item_attribute,'-x') <> '-x' THEN
							t_output	:= t_output || '     ' || 'AND ' || t_route_item_attribute || ' ' || nvl(t_route_item_where,'IS NOT NULL') || t_newline;
						END IF;
						t_output	:= t_output || ';' || t_newline || t_newline;

						t_output	:= t_output || 'CREATE INDEX ' || t_route_table || '_IDX ON ' ||
										t_route_table || '(' || t_route_item_value || ');' || t_newline;

					END IF;

				ELSIF instr(t_template_line,'<<create aggregate route tables>>') > 0 THEN

					IF t_primary_type = 'ASSET' THEN
						OPEN cur_divisor_asset(t_route_type, t_primary_item);
						FETCH cur_divisor_asset INTO t_unit_divisor;
						CLOSE cur_divisor_asset;
					ELSE
						OPEN cur_divisor_group(t_route_type, t_primary_item);
						FETCH cur_divisor_group INTO t_unit_divisor;
						CLOSE cur_divisor_group;
					END IF;

					t_unit_divisor		:= nvl(t_unit_divisor,1);

					FOR t_loop IN 1..tab_rte_table.count LOOP
						IF t_loop <> 2 THEN

						IF tab_type(t_loop) = 'ASSET' THEN
							t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
							t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
										' FROM ( ' ||
										    ' SELECT nit_pnt_or_cont ' ||
										    ' FROM nm_inv_types_all ' ||
										    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
										     'UNION ' ||
										     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
							IF t_point_cont	= '-x' THEN
								t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
											' WHERE rownum < 10';
		
								EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
								IF t_point_cont = '0'THEN
									t_point_cont 	:= 'P';
								ELSE
									t_point_cont 	:= 'C';
								END IF;
							END IF;
						ELSE
							t_point_cont 	:= 'C';
						END IF;

						t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_rte_table(t_loop) || ';' || t_newline || t_newline;
						t_output	:= t_output || t_whitespace || 'CREATE TABLE ' || tab_rte_table(t_loop) || ' AS' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT  l.' || t_route_item_value || t_newline; 
						t_output	:= t_output || t_whitespace || '    , l.nm_cardinality' || t_newline;

						t_output	:= t_output || t_whitespace || '    , decode(l.nm_cardinality, 1, l.nm_slk + ' || 
								'(greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/' ||
								t_unit_divisor || ' - l.nm_begin_mp/' || t_unit_divisor ||
                    						',l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/' ||
								t_unit_divisor || ') nm_slk' || t_newline;

						t_output	:= t_output || t_whitespace || '    , decode(l.nm_cardinality, 1, l.nm_end_slk - ' ||
								'(l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/' ||
								t_unit_divisor || ', l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), ' ||
								'l.nm_begin_mp))/' || t_unit_divisor || ') nm_end_slk' || t_newline;

						t_output	:= t_output || t_whitespace || '    , a.*' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || tab_table(t_loop) || ' a' || t_newline;
						t_output	:= t_output || t_whitespace || ', ' || t_route_table || ' l ' || t_newline;
						t_output	:= t_output || t_whitespace || 'WHERE 1=1' || t_newline;

						t_output	:= t_output || t_whitespace || 'AND l.nm_ne_id_of= a.ne_id_of' || t_newline;

						IF t_point_cont = 'P' THEN
							t_output	:= t_output || t_whitespace || 'AND l.nm_begin_mp <= a.nm_end_mp' || t_newline;
							t_output	:= t_output || t_whitespace || 'AND l.nm_end_mp >= a.nm_begin_mp;' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'AND l.nm_begin_mp < a.nm_end_mp' || t_newline;
							t_output	:= t_output || t_whitespace || 'AND l.nm_end_mp    > a.nm_begin_mp;' || t_newline;
						END IF;


						t_output	:= t_output || t_newline || t_whitespace || 'CREATE INDEX ' || tab_rte_table(t_loop) || '_IDX ON ' ||
									tab_rte_table(t_loop)|| '(' || t_route_item_value || ');' || t_newline;
						END IF;
						t_output	:= t_output || t_newline;
					END LOOP;

				ELSIF instr(t_template_line,'<<aggregate segments table>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate segments table>>',
								lower(t_aggregate_seg_table)) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate route field>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate route field>>',
								t_route_item_value) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate route table unions>> ') > 0 THEN

					FOR t_loop IN 1..tab_item.count LOOP
						IF t_loop <> 2 THEN
							IF t_loop > 1 THEN
								t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
							END IF;

							IF tab_type(t_loop) = 'ASSET' THEN
								t_output	:= t_output || t_whitespace || 'SELECT ne_id_of' || t_newline;
								t_output	:= t_output || t_whitespace || ', nm_begin_mp mp' || t_newline;
								t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
								t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
								t_output	:= t_output || t_whitespace || 'SELECT ne_id_of' || t_newline;
								t_output	:= t_output || t_whitespace || ', nm_end_mp mp' || t_newline;
								t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
							ELSE
								t_output	:= t_output || t_whitespace || 'SELECT nm_ne_id_of ne_id_of' || t_newline;
								t_output	:= t_output || t_whitespace || ', nm_begin_mp mp' || t_newline;
								t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
								t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
								t_output	:= t_output || t_whitespace || 'SELECT nm_ne_id_of ne_id_of' || t_newline;
								t_output	:= t_output || t_whitespace || ', nm_end_mp mp' || t_newline;
								t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
							END IF;
						END IF;
					END LOOP;

					IF t_network_flag > 0 THEN
						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT ne_id_of' || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_begin_mp mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(t_network_mv_name) || t_newline;
						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT ne_id_of' || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_end_mp mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(t_network_mv_name) || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate results detail table>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate results detail table>>',
								t_aggregate_detail_table) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate results final table>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate results final table>>',
								t_aggregate_final_table) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate field>>') > 0 THEN

					t_output	:= t_output || '     ' || lower(t_primary_value) || t_newline ;

				ELSIF instr(t_template_line,'<<aggregate range field>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || '     , ' || lower(t_range_value) || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate data tables>>') > 0 THEN

					t_output	:= t_output || '     , ' || lower(tab_table(1)) || ' a'|| t_newline;

				ELSIF instr(t_template_line,'<<aggregate range table>>') > 0 THEN

					IF nvl(t_range_item,'-x') <> '-x' THEN
						FOR t_loop in 1..tab_item.count LOOP
							IF tab_item(t_loop) = t_range_item THEN
								t_output	:= t_output || '     , ' || 
										lower(tab_table(t_loop)) || ' ' || tab_alias(t_loop) || t_newline;
							END IF;
						END LOOP;
					END IF;
				ELSIF instr(t_template_line,'<<aggregate network restrict>>') > 0 THEN
					IF t_network_flag > 0 THEN
						t_output	:= t_output || '     , ' || lower(t_network_mv_name) || ' b' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate function>>') > 0 THEN

					t_output	:= t_output || lower(t_primary_function) || '(' || t_primary_value || ') ' || t_primary_value || t_newline;

				ELSIF instr(t_template_line,'<<aggregate range join>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						FOR t_loop in 1..tab_item.count LOOP
							IF tab_item(t_loop) = t_range_item THEN
								t_output	:= t_output || '     ' || 'AND l.ne_id_of'||
											' = ' || tab_alias(t_loop) || '.ne_id_of' || t_newline;
								t_output	:= t_output || '     ' || 'AND l.nm_begin_mp < '|| tab_alias(t_loop) || 
											'.nm_end_mp' || t_newline;
								t_output	:= t_output || '     ' || 'AND l.nm_end_mp > '|| tab_alias(t_loop) || 
											'.nm_begin_mp' || t_newline;
							END IF;
						END LOOP;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate data join>>') > 0 THEN
					IF tab_type(1) = 'ASSET' THEN
						t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
						t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
									' FROM ( ' ||
									    ' SELECT nit_pnt_or_cont ' ||
									    ' FROM nm_inv_types_all ' ||
									    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
									     'UNION ' ||
									     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

						EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
						IF t_point_cont	= '-x' THEN
							t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
										' WHERE rownum < 10';
		
							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
							IF t_point_cont = '0'THEN
								t_point_cont 	:= 'P';
							ELSE
								t_point_cont 	:= 'C';
							END IF;
						END IF;
					ELSE
						t_point_cont 	:= 'C';
					END IF;

					IF t_point_cont = 'P' THEN
						t_output	:= t_output || '     AND l.ne_id_of = a.ne_id_of' || t_newline;
						t_output	:= t_output || '     AND l.nm_begin_mp <= a.nm_end_mp' || t_newline;
						t_output	:= t_output || '     AND l.nm_end_mp >= a.nm_begin_mp' || t_newline;
					ELSE
						t_output	:= t_output || '     AND l.ne_id_of = a.ne_id_of' || t_newline;
						t_output	:= t_output || '     AND l.nm_begin_mp < a.nm_end_mp' || t_newline;
						t_output	:= t_output || '     AND l.nm_end_mp > a.nm_begin_mp' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate network join>>') > 0 THEN
					IF t_network_flag > 0 THEN
						t_output	:= t_output || '     AND l.ne_id_of = b.ne_id_of' || t_newline;
						t_output	:= t_output || '     AND l.nm_begin_mp < b.nm_end_mp' || t_newline;
						t_output	:= t_output || '     AND l.nm_end_mp > b.nm_begin_mp;' || t_newline;
					ELSE
						t_output	:= t_output || ';' || t_newline;
					END IF;
				ELSIF instr(t_template_line,'<<aggregate results base>>') > 0 THEN
 					t_output	:= t_output || replace(t_template_line,'<<aggregate results base>>',
								t_base_name) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate route table name>>') > 0 THEN
 					t_output	:= t_output || replace(t_template_line,'<<aggregate route table name>>',
								t_route_table) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate milepoints>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || ', min(nm_slk) nm_slk' || t_newline;
						t_output	:= t_output || ', max(nm_end_slk) nm_end_slk' || t_newline;
					ELSE
						t_output	:= t_output || ', nm_slk'|| t_newline;
						t_output	:= t_output || ', nm_end_slk' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate group milepoints>>') > 0 THEN
					IF nvl(t_range_item,'-x') = '-x' THEN
						t_output	:= t_output || ', nm_slk'|| t_newline;
						t_output	:= t_output || ', nm_end_slk;' || t_newline;
					ELSE
						t_output	:= t_output || ';' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate range group by field>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || lower(t_range_value) || ',' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<drop temp aggregate tables>>') > 0 THEN

					FOR t_loop IN 1..tab_rte_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || 'DROP TABLE ' || tab_rte_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;

					IF nvl(t_route_table,'-x') <> '-x'THEN
						t_output	:= t_output ||'DROP TABLE ' || t_route_table || ';' || t_newline;
					END IF;

					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || 'DROP TABLE ' || tab_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;

					t_output	:= t_output || 'DROP TABLE ' || t_aggregate_seg_table || ';' || t_newline;
					t_output	:= t_output || 'DROP TABLE ' || t_aggregate_detail_table || ';' || t_newline;
				ELSE
					t_output	:= t_output ||  t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;

			ELSE
				EXIT;
			END IF;

			t_template_return_count	:= t_template_return_count + 1;
		END;
	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_aggregate_table RETURN VARCHAR2 IS

BEGIN

	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

/*********************************************************************************************
 	Generate TABLEs for all Aggregate data items
	SUM, COUNT, MIN, MAX
**********************************************************************************************/

	WHILE t_template_return_pos IS NOT NULL LOOP
		BEGIN
			t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

			IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
				t_template_read			:= t_template_return_pos - t_template_start;

				IF t_template_read > 0 THEN
					dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
				ELSE
					t_template_line		:= chr(10);
					t_whitespace		:= ' ';
				END IF;
				t_template_start		:= t_template_return_pos + 1;

				t_route_sql			:= NULL;
				t_cursor_id			:= t_data_item;
				t_cursor_name			:= 'cur_' || t_cursor_id;

				IF nvl(t_output,'-x') = '-x' THEN

					t_route_restrict		:= 'BOTH';
					t_formula_used			:= FALSE;
					t_min_hm_id			:= 0;
					t_primary_name			:= NULL;
					t_primary_item			:= NULL;
					t_primary_value			:= NULL;
					t_primary_attribute		:= NULL;
					t_primary_where			:= NULL;
					t_primary_type			:= NULL;
					t_primary_function		:= NULL;
					t_primary_formula		:= NULL;
					t_primary_hdi_id		:= NULL;
					t_range_item			:= NULL;
					t_range_value			:= NULL;
					t_range_attribute		:= NULL;
					t_range_where			:= NULL;
					t_range_type			:= NULL;	
					t_route_item			:= NULL;	
					t_route_item_value		:= NULL;
					t_route_item_attribute		:= NULL;
					t_route_item_where		:= NULL;
					t_route_item_type		:= NULL;
					t_route_table			:= NULL;

					OPEN cur_get_min_hmid(t_table_id, t_data_item);
					FETCH cur_get_min_hmid INTO t_min_hm_id;
					CLOSE cur_get_min_hmid;

					OPEN cur_primary_item(t_min_hm_id);
					FETCH cur_primary_item INTO t_primary_name
						, t_primary_item
						, t_primary_value
						, t_primary_attribute
						, t_primary_where
						, t_primary_type
						, t_primary_function
						, t_primary_formula
						, t_primary_hdi_id
						, t_primary_join;
					CLOSE cur_primary_item;

					OPEN cur_aggregate_range(t_table_id, t_cursor_id);
					FETCH cur_aggregate_range INTO t_range_item
							, t_range_value
							, t_range_type
							, t_range_attribute
							, t_range_where;
					CLOSE cur_aggregate_range;
	
					IF nvl(trim(t_primary_formula),'-x') <> '-x' THEN
						t_formula_used		:= TRUE;
					END IF;

					OPEN cur_route_restrict(t_table_id, t_data_item);
					FETCH cur_route_restrict INTO t_route_restrict;
					CLOSE cur_route_restrict;

					FOR c_map IN cur_map_all(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' THEN
							t_route_item			:= c_map.hm_item;
							t_route_item_value		:= c_map.hm_item_value;
							t_route_item_attribute		:= c_map.hm_item_attribute;
							t_route_item_where		:= c_map.hm_item_where;
							t_route_item_type		:= c_map.hm_item_type;
							t_route_table			:= 'OHMS_TMP_RTE_ITEM_' || c_map.hm_item;
						END IF;
					END LOOP;

					tab_alias.delete;
					tab_item.delete;
					tab_from.delete;
					tab_type.delete;
					tab_table.delete;
					tab_rte_table.delete;

					tab_alias(1)				:= 'a';
					tab_item(1)				:= t_primary_item;
					tab_type(1)				:= t_primary_type;
					tab_table(1)				:= 'OHMS_TMP_' || t_table_id || 
											'_' || t_data_item || '_' || t_primary_item;
					tab_rte_table(1)			:= 'OHMS_TMP_RTE_' || t_table_id || 
											'_' || t_data_item || '_' || t_primary_item;
					t_aggregate_seg_table			:= 'OHMS_TMP_SEG_' || t_table_id || '_' || t_data_item || '_' || t_primary_item;
					t_aggregate_detail_table		:= 'OHMS_TMP_DETAIL_' || t_table_id || '_' || t_data_item || '_' || t_primary_item;

					IF t_network_flag > 0 THEN
						tab_alias(2)			:= 'b';
						tab_item(2)			:= 'NETWORK';
						tab_type(2)			:= 'NETWORK';
						tab_table(2)			:= t_network_mv_name;
						tab_rte_table(2)		:= 'x';
					ELSE
						tab_alias(2)			:= 'x';
						tab_item(2)			:= 'x';
						tab_type(2)			:= 'x';
						tab_table(2)			:= 'x';
						tab_rte_table(2)		:= 'x';
					END IF;

					t_counter				:= tab_alias.count;
					FOR c_adddl_items IN cur_aggregate_item_list (t_table_id, t_data_item) LOOP
						t_found		:= 0;
						FOR t_loop IN 1..tab_alias.count LOOP
							IF c_adddl_items.hm_item = tab_item(t_loop) THEN
								t_found		:= 1;
							END IF;
						END LOOP;

						IF t_found = 0 THEN
							t_counter						:= t_counter + 1;
							SELECT decode(t_counter,3, 'c', 4, 'd', 5, 'e', 6, 'f', 7 ,'g','h')
							INTO t_alias
							FROM DUAL;

							tab_alias(t_counter)		:= t_alias;
							tab_item(t_counter)		:= c_adddl_items.hm_item;
							tab_type(t_counter)		:= c_adddl_items.hm_item_type;
							tab_table(t_counter)		:= 'OHMS_TMP_' || t_table_id || 
											'_' || t_data_item || '_' ||  c_adddl_items.hm_item;
							tab_rte_table(t_counter)	:= 'OHMS_TMP_RTE_' || t_table_id || 
											'_' || t_data_item || '_' ||  c_adddl_items.hm_item;
						END IF;
					END LOOP;

					IF tab_type(1) = 'ASSET' THEN
						t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
						t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
									' FROM ( ' ||
									    ' SELECT nit_pnt_or_cont ' ||
									    ' FROM nm_inv_types_all ' ||
									    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
									     'UNION ' ||
									     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

						EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
						IF t_point_cont	= '-x' THEN
							t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
										' WHERE rownum < 10';
		
							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
							IF t_point_cont = '0'THEN
								t_point_cont 	:= 'P';
							ELSE
								t_point_cont 	:= 'C';
							END IF;
						END IF;
					ELSE
						t_point_cont 	:= 'C';
					END IF;

					IF t_primary_function IN ('SUM', 'COUNT', 'MIN', 'MAX') THEN
						t_mview_name	:= 'v_nm_' || lower(t_primary_item) || t_primary_hdi_id || '_' || lower(t_primary_function);
						IF t_primary_type = 'ASSET' THEN
							t_mview_name	:= t_mview_name || '_mv_nw';
						ELSIF t_primary_type = 'GROUP' THEN
							t_mview_name	:= t_mview_name || '_nt_mv';
						END IF;

						t_aggregate_final_table			:= t_mview_name;

					END IF;
					t_output	:= t_output || t_newline || t_whitespace || ltrim(t_template_line,' ') || t_newline;

					OPEN cur_item_desc(t_table_id, t_data_item);
					FETCH cur_item_desc INTO t_cursor_descr;
					CLOSE cur_item_desc;

				ELSIF instr(t_template_line,'<<aggregate data item descr>>') > 0 THEN
					t_output	:= t_output || replace(t_template_line,'<<aggregate data item descr>>',t_cursor_descr) || t_newline;

				ELSIF instr(t_template_line,'<<setup temp tables>>') > 0 THEN
					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;
					
					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
						t_output	:= t_output || t_whitespace || 'CREATE TABLE ' || tab_table(t_loop) || ' AS ' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT * FROM ' || t_newline;
						IF tab_type(t_loop) = 'ASSET' THEN
							t_output	:= t_output || t_whitespace || 'v_nm_' || tab_item(t_loop) || '_nw'|| t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'v_nm_' || tab_item(t_loop) || '_nt'|| t_newline;
							t_output	:= t_output || t_whitespace || ', nm_members'|| t_newline;
						END IF;
						t_output	:= t_output || t_whitespace || 'WHERE 1=1 ' || t_newline;

						IF tab_type(t_loop) = 'GROUP' THEN
							t_output	:= t_output || t_whitespace || 'AND ne_id = nm_ne_id_of' || t_newline;
						END IF;

						FOR c_where IN cur_aggregate_where_list(t_table_id, t_data_item, tab_item(t_loop)) LOOP
							t_output	:= t_output || t_whitespace || c_where.where_clause || t_newline;
						END LOOP;						
						t_output	:= t_output || t_whitespace || ';' || t_newline;
						
						IF tab_type(t_loop) = 'ASSET' THEN
							t_output	:= t_output || t_whitespace || 'CREATE INDEX ' || tab_table(t_loop) || '_IDX ON ' ||
										tab_table(t_loop) || '(ne_id_of);' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'CREATE INDEX ' || tab_table(t_loop) || '_IDX ON ' ||
										tab_table(t_loop) || '(nm_ne_id_of);' ||  t_newline;
						END IF;
						END IF;
						t_output	:= t_output || t_newline;
					END LOOP;

					IF nvl(t_route_item,'-x') <> '-x' THEN 
						t_output	:= t_output || t_whitespace || 'DROP TABLE ' || t_route_table || ';' || t_newline;
						t_output	:= t_output || t_whitespace || 'CREATE TABLE ' || t_route_table || ' AS ' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT * FROM ' || t_newline;

						IF t_route_type = 'ASSET' THEN
							t_output	:= t_output || t_whitespace || 'v_nm_' || lower(t_route_item) || '_nw'|| t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'v_nm_' || lower(t_route_item) || '_nt'|| t_newline;
							IF t_route_restrict = 'D' THEN
								t_output	:= t_output || t_whitespace || ', nm_members_d'|| t_newline;
							ELSIF t_route_restrict = 'I'THEN
								t_output	:= t_output || t_whitespace || ', nm_members_i'|| t_newline;
							ELSE
								t_output	:= t_output || t_whitespace || ', nm_members'|| t_newline;
							END IF;
						END IF;
						t_output	:= t_output || t_whitespace || 'WHERE 1=1 ' || t_newline;

						IF t_route_item_type = 'GROUP' THEN
							t_output	:= t_output || t_whitespace || 'AND ne_id = nm_ne_id_in' || t_newline;
						END IF;

						IF nvl(t_route_item_attribute,'-x') <> '-x' THEN
							t_output	:= t_output || t_whitespace || 'AND ' || t_route_item_attribute || ' ' || nvl(t_route_item_where,'IS NOT NULL') || t_newline;
						END IF;
						t_output	:= t_output || t_whitespace || ';' || t_newline || t_newline;

						t_output	:= t_output || t_whitespace || 'CREATE INDEX ' || t_route_table || '_IDX ON ' ||
										t_route_table || '(' || t_route_item_value || ');' || t_newline;

						t_output	:= t_output || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<create aggregate route tables>>') > 0 THEN

					IF t_primary_type = 'ASSET' THEN
						OPEN cur_divisor_asset(t_route_type, t_primary_item);
						FETCH cur_divisor_asset INTO t_unit_divisor;
						CLOSE cur_divisor_asset;
					ELSE
						OPEN cur_divisor_group(t_route_type, t_primary_item);
						FETCH cur_divisor_group INTO t_unit_divisor;
						CLOSE cur_divisor_group;
					END IF;

					t_unit_divisor		:= nvl(t_unit_divisor,1);

					FOR t_loop IN 1..tab_rte_table.count LOOP
						IF t_loop <> 2 THEN

						IF tab_type(t_loop) = 'ASSET' THEN
							t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
							t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
										' FROM ( ' ||
										    ' SELECT nit_pnt_or_cont ' ||
										    ' FROM nm_inv_types_all ' ||
										    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
										     'UNION ' ||
										     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
							IF t_point_cont	= '-x' THEN
								t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
											' WHERE rownum < 10';
		
								EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
								IF t_point_cont = '0'THEN
									t_point_cont 	:= 'P';
								ELSE
									t_point_cont 	:= 'C';
								END IF;
							END IF;
						ELSE
							t_point_cont 	:= 'C';
						END IF;

						t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_rte_table(t_loop) || ';' || t_newline || t_newline;
						t_output	:= t_output || t_whitespace || 'CREATE TABLE ' || tab_rte_table(t_loop) || ' AS' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT  l.' || t_route_item_value || t_newline; 
						t_output	:= t_output || t_whitespace || '    , l.nm_cardinality' || t_newline;

						t_output	:= t_output || t_whitespace || '    , decode(l.nm_cardinality, 1, l.nm_slk + ' || 
								'(greatest(nvl(a.nm_begin_mp,0),l.nm_begin_mp))/' ||
								t_unit_divisor || ' - l.nm_begin_mp/' || t_unit_divisor ||
                    						',l.nm_slk + (l.nm_end_mp  - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/' ||
								t_unit_divisor || ') nm_slk' || t_newline;

						t_output	:= t_output || t_whitespace || '    , decode(l.nm_cardinality, 1, l.nm_end_slk - ' ||
								'(l.nm_end_mp - least(nvl(a.nm_end_mp,9999), l.nm_end_mp))/' ||
								t_unit_divisor || ', l.nm_slk + (l.nm_end_mp - greatest(nvl(a.nm_begin_mp,0), ' ||
								'l.nm_begin_mp))/' || t_unit_divisor || ') nm_end_slk' || t_newline;

						t_output	:= t_output || t_whitespace || '    , a.*' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || tab_table(t_loop) || ' a' || t_newline;
						t_output	:= t_output || t_whitespace || ', ' || t_route_table || ' l ' || t_newline;
						t_output	:= t_output || t_whitespace || 'WHERE 1=1' || t_newline;

						t_output	:= t_output || t_whitespace || 'AND l.nm_ne_id_of= a.ne_id_of' || t_newline;

						IF t_point_cont = 'P' THEN
							t_output	:= t_output || t_whitespace || 'AND l.nm_begin_mp <= a.nm_end_mp' || t_newline;
							t_output	:= t_output || t_whitespace || 'AND l.nm_end_mp >= a.nm_begin_mp;' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'AND l.nm_begin_mp < a.nm_end_mp' || t_newline;
							t_output	:= t_output || t_whitespace || 'AND l.nm_end_mp    > a.nm_begin_mp;' || t_newline;
						END IF;


						t_output	:= t_output || t_newline || t_whitespace || 'CREATE INDEX ' || tab_rte_table(t_loop) || '_IDX ON ' ||
									tab_rte_table(t_loop)|| '(' || t_route_item_value || ');' || t_newline;
						END IF;
						t_output	:= t_output || t_newline;
					END LOOP;

				ELSIF instr(t_template_line,'<<aggregate segments table>>') > 0 THEN
					t_output	:= t_output || t_whitespace || replace(t_template_line,'<<aggregate segments table>>',
								lower(t_aggregate_seg_table)) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate route field>>') > 0 THEN
					t_output	:= t_output || t_whitespace || replace(t_template_line,'<<aggregate route field>>',
								t_route_item_value) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate route table unions>> ') > 0 THEN

					FOR t_loop IN 1..tab_rte_table.count LOOP
						IF t_loop <> 2 THEN
						IF t_loop > 1 THEN
							t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						END IF;
						t_output	:= t_output || t_whitespace || 'SELECT ' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_slk mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT ' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_end_slk mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(tab_rte_table(t_loop)) || t_newline;
						END IF;
					END LOOP;

					IF t_network_flag > 0 THEN
						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT ' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_slk mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(t_network_mv_name) || t_newline;
						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						t_output	:= t_output || t_whitespace || 'SELECT ' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || ', nm_end_slk mp' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || lower(t_network_mv_name) || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate results detail table>>') > 0 THEN
					t_output	:= t_output || t_whitespace || replace(t_template_line,'<<aggregate results detail table>>',
								t_aggregate_detail_table) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate results final table>>') > 0 THEN
					t_output	:= t_output || t_whitespace || replace(t_template_line,'<<aggregate results final table>>',
								t_aggregate_final_table) || t_newline;

				ELSIF instr(t_template_line,'<<aggregate field>>') > 0 THEN

					t_output	:= t_output || t_whitespace || lower(t_primary_value) || t_newline ;

				ELSIF instr(t_template_line,'<<aggregate range field>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || ', ' || lower(t_range_value) || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate data tables>>') > 0 THEN

					t_output	:= t_output || t_whitespace || ', ' || lower(tab_rte_table(1)) || ' a'|| t_newline;

				ELSIF instr(t_template_line,'<<aggregate range table>>') > 0 THEN

					IF nvl(t_range_item,'-x') <> '-x' THEN
						FOR t_loop in 1..tab_item.count LOOP
							IF tab_item(t_loop) = t_range_item AND t_range_item <> t_primary_item THEN
								t_output	:= t_output || t_whitespace || ', ' || 
										lower(tab_rte_table(t_loop)) || ' ' || tab_alias(t_loop) || t_newline;
							END IF;
						END LOOP;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate function>>') > 0 THEN

					t_output	:= t_output || t_whitespace || lower(t_primary_function) || '(' || t_primary_value || ') ' || t_primary_value || t_newline;

				ELSIF instr(t_template_line,'<<aggregate range join>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						FOR t_loop in 1..tab_item.count LOOP
							IF tab_item(t_loop) = t_range_item THEN
								t_output	:= t_output || t_whitespace || 'AND l.' || lower(t_route_item_value) ||
											' = ' || tab_alias(t_loop) || '.' || lower(t_route_item_value) || t_newline;
								t_output	:= t_output || t_whitespace || 'AND l.nm_slk < '|| tab_alias(t_loop) || 
											'.nm_end_slk' || t_newline;
								t_output	:= t_output || t_whitespace || 'AND l.nm_end_slk > '|| tab_alias(t_loop) || 
											'.nm_slk' || t_newline;
							END IF;
						END LOOP;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate data join>>') > 0 THEN

					IF tab_type(1) = 'ASSET' THEN
						t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
						t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
									' FROM ( ' ||
									    ' SELECT nit_pnt_or_cont ' ||
									    ' FROM nm_inv_types_all ' ||
									    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
									     'UNION ' ||
									     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

						EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
						IF t_point_cont	= '-x' THEN
							t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
										' WHERE rownum < 10';
		
							EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
							IF t_point_cont = '0'THEN
								t_point_cont 	:= 'P';
							ELSE
								t_point_cont 	:= 'C';
							END IF;
						END IF;
					ELSE
						t_point_cont 	:= 'C';
					END IF;

					IF t_point_cont = 'P' THEN
						t_output	:= t_output || t_whitespace || 'AND l.' || lower(t_route_item_value) ||
									' = a.' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || 'AND l.nm_slk <= a.nm_end_slk' || t_newline;
						t_output	:= t_output || t_whitespace || 'AND l.nm_end_slk >= a.nm_slk' || t_newline;
					ELSE
						t_output	:= t_output || t_whitespace || 'AND l.' || lower(t_route_item_value) ||
									' = a.' || lower(t_route_item_value) || t_newline;
						t_output	:= t_output || t_whitespace || 'AND l.nm_slk < a.nm_end_slk' || t_newline;
						t_output	:= t_output || t_whitespace || 'AND l.nm_end_slk > a.nm_slk' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate milepoints>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || ', min(nm_slk) nm_slk' || t_newline;
						t_output	:= t_output || t_whitespace || ', max(nm_end_slk) nm_end_slk' || t_newline;
					ELSE
						t_output	:= t_output || t_whitespace || ', nm_slk'|| t_newline;
						t_output	:= t_output || t_whitespace || ', nm_end_slk' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate group milepoints>>') > 0 THEN
					IF nvl(t_range_item,'-x') = '-x' THEN
						t_output	:= t_output || t_whitespace || ', nm_slk'|| t_newline;
						t_output	:= t_output || t_whitespace || ', nm_end_slk;' || t_newline;
					ELSE
						t_output	:= t_output || t_whitespace || ';' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<aggregate range group by field>>') > 0 THEN
					IF nvl(t_range_item,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || lower(t_range_value) || ',' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<drop temp aggregate tables>>') > 0 THEN

					FOR t_loop IN 1..tab_rte_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_rte_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;

					IF nvl(t_route_table,'-x') <> '-x'THEN
						t_output	:= t_output || t_whitespace || 'DROP TABLE ' || t_route_table || ';' || t_newline;
					END IF;

					FOR t_loop IN 1..tab_table.count LOOP
						IF t_loop <> 2 THEN
							t_output	:= t_output || t_whitespace || 'DROP TABLE ' || tab_table(t_loop) || ';' || t_newline;
						END IF;
					END LOOP;

					t_output	:= t_output || t_whitespace || 'DROP TABLE ' || t_aggregate_seg_table || ';' || t_newline;
					t_output	:= t_output || t_whitespace || 'DROP TABLE ' || t_aggregate_detail_table || ';' || t_newline;
				ELSE
					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;

			ELSE
				EXIT;
			END IF;

			t_template_return_count	:= t_template_return_count + 1;
		END;
	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_aggregate_view RETURN VARCHAR2 IS

BEGIN

	t_output	:= NULL;

	t_min_hm_id			:= 0;
	t_primary_name		:= NULL;
	t_primary_item		:= NULL;
	t_primary_value		:= NULL;
	t_primary_attribute	:= NULL;
	t_primary_where		:= NULL;
	t_primary_type		:= NULL;
	t_primary_function	:= NULL;
	t_primary_hdi_id		:= NULL;

	OPEN cur_get_min_hmid(t_table_id, t_data_item);
	FETCH cur_get_min_hmid INTO t_min_hm_id;
	CLOSE cur_get_min_hmid;

	OPEN cur_primary_item(t_min_hm_id);
	FETCH cur_primary_item INTO t_primary_name
			, t_primary_item
			, t_primary_value
			, t_primary_attribute
			, t_primary_where
			, t_primary_type
			, t_primary_function
			, t_primary_formula
			, t_primary_hdi_id
			, t_primary_join;
	CLOSE cur_primary_item;

	t_route_item			:= NULL;
	t_route_item_value		:= NULL;
	t_route_item_attribute		:= NULL;
	t_route_item_where		:= NULL;
	t_route_item_type		:= NULL;

	FOR c_map IN cur_map_all(t_table_id, t_data_item) LOOP
		IF c_map.hcl_name = 'ROUTE_ID' THEN
			t_route_item			:= c_map.hm_item;
			t_route_item_value		:= c_map.hm_item_value;
			t_route_item_attribute		:= c_map.hm_item_attribute;
			t_route_item_where		:= c_map.hm_item_where;
			t_route_item_type		:= c_map.hm_item_type;
		END IF;
	END LOOP;

	t_mview_name	:= 'v_nm_' || lower(t_primary_item) || t_primary_hdi_id || '_' || lower(t_primary_function);

	IF t_primary_type = 'ASSET' THEN
		t_mview_name	:= t_mview_name || '_mv_nw';
	ELSIF t_primary_type = 'GROUP' THEN
		t_mview_name	:= t_mview_name || '_nt_mv';
	END IF;

	t_output	:= t_output || t_newline || 'CURSOR CUR_'|| t_data_item || ' IS' || t_newline;

	t_output	:= t_output || 'SELECT' ;

	t_counter		:= 0;
	FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
		IF c_map.hm_item_function NOT IN('TEXT','CONSTANT') THEN
			IF t_counter = 0 THEN
				t_comma		:= NULL;
			ELSE
				t_comma		:= ',';
			END IF;
			t_counter		:= t_counter + 1;

			IF c_map.hm_item = t_primary_item THEN	
				IF nvl(t_network_mv_name,'-x') <> '-x' THEN
					CASE 
					WHEN lower(c_map.hm_item_value) = 'nm_slk' THEN
						t_output	:= t_output || t_tab || t_comma ||
								'greatest(' ||lower(t_primary_item)|| '.' || lower(c_map.hm_item_value) || ', b. ' || lower(c_map.hm_item_value) || ') ' ||
								upper(c_map.hcl_name) || t_newline;
					WHEN lower(c_map.hm_item_value) = 'nm_end_slk' THEN
						t_output	:= t_output || t_tab || t_comma ||
								'least(' ||lower(t_primary_item)|| '.' || lower(c_map.hm_item_value) || ', b. ' || lower(c_map.hm_item_value) || ') ' ||
								upper(c_map.hcl_name) || t_newline;
					ELSE
						IF nvl(c_map.hm_item_formula,'-x') = '-x' THEN
							t_output	:= t_output || t_tab || t_comma ||
								lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ' ' || upper(c_map.hcl_name) || t_newline;
						ELSE
							t_output	:= t_output || t_tab || t_comma ||
								lower(c_map.hm_item_formula) || ' ' || upper(c_map.hcl_name) || t_newline;
						END IF;
					END CASE;
				ELSE
					IF nvl(c_map.hm_item_formula,'-x') = '-x' THEN
						t_output	:= t_output || t_tab || t_comma ||
								lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ' ' || upper(c_map.hcl_name) || t_newline;
					ELSE
						t_output	:= t_output || t_tab || t_comma ||
								lower(c_map.hm_item_formula) || ' ' || upper(c_map.hcl_name) || t_newline;
					END IF;
				END IF;
			ELSE
				IF nvl(t_network_mv_name,'-x') <> '-x' THEN
					CASE 
					WHEN lower(c_map.hm_item_value) = 'nm_slk' THEN
						t_output	:= t_output || t_tab || t_comma ||
								'greatest(' || lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ', b. ' || lower(c_map.hm_item_value) || ') ' ||
								upper(c_map.hcl_name) || t_newline;
					WHEN lower(c_map.hm_item_value) = 'nm_end_slk' THEN
						t_output	:= t_output || t_tab || t_comma ||
								'least(' || lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ', b. ' || lower(c_map.hm_item_value) || ') ' ||
								upper(c_map.hcl_name) || t_newline;
					ELSE
						t_output	:= t_output || t_tab || t_comma ||
								lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ' ' || upper(c_map.hcl_name) || t_newline;
					END CASE;
				ELSE
					t_output	:= t_output || t_tab || t_comma ||
							lower(t_primary_item) || '.' || lower(c_map.hm_item_value) || ' ' || upper(c_map.hcl_name) || t_newline;
				END IF;
			END IF;
		END IF;
	END LOOP;

	t_output	:= t_output || 'FROM' || t_newline;
	t_output	:= t_output || t_tab || lower(t_mview_name) || ' ' || t_primary_item || t_newline;

	IF nvl(t_network_mv_name,'-x') <> '-x' THEN
		t_output	:= t_output || t_tab || ', ' || lower(t_network_mv_name) || ' b' || t_newline;
	
		t_output	:= t_output || 'WHERE ' || lower(t_primary_item) || '.' || lower(t_route_item_value) || ' = b.' || lower(t_route_item_value) || t_newline;
		t_output	:= t_output || t_tab || 'AND ' || lower(t_primary_item) || '.nm_slk < b.nm_end_slk' || t_newline;
		t_output	:= t_output || t_tab || 'AND ' || lower(t_primary_item) || '.nm_end_slk > b.nm_slk;' || t_newline;
	END IF;


	RETURN t_output;
END;

FUNCTION lf_generate_outerjoin_table RETURN VARCHAR2 IS

BEGIN
	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

	t_route_restrict		:= 'BOTH';
	t_point_cont			:= 'C';
	t_and			:= NULL;

	WHILE t_template_return_pos IS NOT NULL LOOP
		t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

		IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
			t_template_read			:= t_template_return_pos - t_template_start;

			IF t_template_read > 0 THEN
				dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
				t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
			ELSE
				t_template_line		:= chr(10);
				t_whitespace		:= ' ';
			END IF;

			t_template_start		:= t_template_return_pos + 1;

			IF nvl(t_output,'-x') = '-x' THEN
				t_primary_name		:= NULL;
				t_primary_item		:= NULL;
				t_primary_value		:= NULL;
				t_primary_attribute	:= NULL;
				t_primary_where		:= NULL;
				t_primary_type		:= NULL;
				t_primary_function	:= NULL;
				t_primary_hdi_id	:= NULL;

				OPEN cur_primary_item(t_min_hm_id);
				FETCH cur_primary_item INTO t_primary_name
								, t_primary_item
								, t_primary_value
								, t_primary_attribute
								, t_primary_where
								, t_primary_type
								, t_primary_function
								, t_primary_formula
								, t_primary_hdi_id
								, t_primary_join;
				CLOSE cur_primary_item;

				t_outerrange_name		:= NULL;
				t_outerrange_item		:= NULL;
				t_outerrange_value		:= NULL;
				t_outerrange_attribute		:= NULL;
				t_outerrange_where		:= NULL;
				t_outerrange_type		:= NULL;

				OPEN cur_outer_range(t_table_id, t_data_item);
				FETCH cur_outer_range INTO t_outerrange_name
					,t_outerrange_item
					,t_outerrange_value
					,t_outerrange_attribute
					,t_outerrange_where
					,t_outerrange_type;
				CLOSE cur_outer_range;

				IF nvl(t_outerrange_item,'-x') = '-x' THEN
					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' THEN
							t_outerrange_name	:= c_map.hcl_name;
							t_outerrange_item	:= c_map.hm_item;
							t_outerrange_value	:= c_map.hm_item_value;
							t_outerrange_attribute	:= c_map.hm_item_attribute;
							t_outerrange_where	:= c_map.hm_item_where;
							t_outerrange_type	:= c_map.hm_item_type;
						END IF;
					END LOOP;
				END IF;


				IF t_primary_function IN ('OUTERJOIN_RANGE', 'OUTERJOIN_DATA') THEN
					t_mview_name	:= 'v_nm_' || lower(t_primary_item) || t_primary_hdi_id || '_outer';
					IF t_primary_type = 'ASSET' THEN
						t_mview_name	:= t_mview_name || '_mv_nw';
					ELSIF t_primary_type = 'GROUP' THEN
						t_mview_name	:= t_mview_name || '_mv_nt';
					END IF;

					t_output	:= t_newline || 'DROP TABLE ' || t_mview_name || ';' || t_newline;
					t_output	:= t_output || t_newline || 'CREATE TABLE ' || t_mview_name || ' AS';
				END IF;

				t_output	:= t_output || t_newline || t_whitespace || ltrim(t_template_line,' ') || t_newline;
--outer
			ELSIF instr(t_template_line,'<<outer data columns>>') > 0 THEN
				t_counter	:= 1;

				IF nvl(t_primary_type,'-x') = 'ASSET' THEN
					FOR c_fields IN cur_fields('V_NM_' || t_primary_item || '_NW') LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_whitespace || '    ' || c_fields.column_name || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '    , ' || c_fields.column_name || t_newline;
						END IF;
						t_counter		:= t_counter + 1;
					END LOOP;
				ELSE
					FOR c_fields IN cur_fields('V_NM_' || t_primary_item || '_NT') LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_whitespace || '    ' || c_fields.column_name || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '    , ' || c_fields.column_name || t_newline;
						END IF;
						t_counter		:= t_counter + 1;
					END LOOP;
				END IF;

			ELSIF instr(t_template_line,'<<range items>>') > 0 THEN

				t_output		:= t_output || t_whitespace || 'SELECT DISTINCT ne_id_of, mp' || t_newline;
				t_output		:= t_output || t_whitespace || 'FROM (' || t_newline;
				t_union_count		:= 0;
				t_alias_group		:= NULL;
				t_alias_group_range	:= NULL;
				t_native_count		:= 0;

				IF t_outerrange_type = 'GROUP' OR t_primary_type = 'GROUP' THEN
					t_native_count		:= 0;
					IF nvl(t_outerrange_type,'-x') = 'GROUP' THEN
						OPEN cur_alias_group(t_outerrange_item);
						FETCH cur_alias_group INTO t_native_count;
						CLOSE cur_alias_group;
					END IF;

					t_union_count		:= 1;
					t_output	:= t_output || t_whitespace || '    SELECT nm_ne_id_of ne_id_of, nm_end_mp mp' || t_newline;
					t_output	:= t_output || t_whitespace || '    FROM nm_members' || t_newline;
					t_output	:= t_output || t_whitespace || '    WHERE nm_type = ' || '''' || 'G' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || '        AND nm_obj_type IN (' ;

					t_comma		:= NULL;
					IF t_outerrange_type = 'GROUP' THEN
						IF t_native_count > 0 THEN
							t_output	:= t_output || '''' || t_outerrange_item || '''' ;
							t_comma		:= ',';
						ELSE
							t_alias_group_range		:= NULL;
							OPEN cur_alias_reference(t_outerrange_item,'NT');
							FETCH cur_alias_reference INTO t_alias_group_range;
							CLOSE cur_alias_reference;
							
							IF nvl(t_alias_group,'-x') <> '-x' THEN
								t_output	:= t_output || '''' || t_alias_group_range || '''' ;
								t_comma		:= ',';
							ELSE
								t_output	:= t_output || '''' || t_outerrange_item || '''' ;
								t_comma		:= ',';
							END IF;
						END IF;
					END IF;

					IF t_primary_type = 'GROUP' THEN
						t_native_count		:= 0;
						IF nvl(t_primary_type,'-x') = 'GROUP' THEN
							OPEN cur_alias_group(t_primary_item);
							FETCH cur_alias_group INTO t_native_count;
							CLOSE cur_alias_group;
						END IF;

						IF t_native_count > 0 THEN
							t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
						ELSE
							t_alias_group		:= NULL;
							OPEN cur_alias_reference(t_outerrange_item,'NT');
							FETCH cur_alias_reference INTO t_alias_group;
							CLOSE cur_alias_reference;
							
							IF nvl(t_alias_group,'-x') <> '-x' THEN
								t_output	:= t_output || t_comma || '''' || t_alias_group || '''' ;
							ELSE
								t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
							END IF;
						END IF;
					END IF;

					t_output	:= t_output || ')' || t_newline;
					t_output	:= t_output || t_whitespace || '    UNION' || t_newline;
					t_output	:= t_output || t_whitespace || '    SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp' || t_newline;
					t_output	:= t_output || t_whitespace || '    FROM nm_members' || t_newline;
					t_output	:= t_output || t_whitespace || '    WHERE nm_type = ' || '''' || 'G' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || '        AND nm_obj_type IN (' ;

					t_comma		:= NULL;
					IF t_outerrange_type = 'GROUP' THEN
						IF nvl(t_alias_group_range,'-x') = '-x' THEN
							t_output	:= t_output || '''' || t_outerrange_item || '''' ;
							t_comma		:= ',';
						ELSE
							t_output	:= t_output || '''' || t_alias_group_range || '''' ;
							t_comma		:= ',';
						END IF;
					END IF;

					IF t_primary_type = 'GROUP' THEN
						IF nvl(t_alias_group,'-x') = '-x' THEN
							t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
						ELSE
							t_output	:= t_output || t_comma || '''' || t_alias_group || '''' ;
						END IF;
					END IF;
					t_output	:= t_output || ')' || t_newline;
				END IF;

				t_alias_asset		:= NULL;
				t_alias_asset_range	:= NULL;
				t_native_count		:= 0;

				IF t_outerrange_type = 'ASSET' OR t_primary_type = 'ASSET' THEN
					IF t_union_count = 1 THEN
						t_output	:= t_output || t_whitespace || '    UNION' || t_newline;
					END IF;
					t_output	:= t_output || t_whitespace || '    SELECT nm_ne_id_of ne_id_of, nm_end_mp mp' || t_newline;
					t_output	:= t_output || t_whitespace || '    FROM nm_members' || t_newline;
					t_output	:= t_output || t_whitespace || '    WHERE nm_type = ' || '''' || 'I' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || '        AND nm_obj_type IN (' ;

					t_comma		:= NULL;
					IF t_outerrange_type = 'ASSET' THEN
						t_native_count		:= 0;
						OPEN cur_alias_asset(t_outerrange_item);
						FETCH cur_alias_asset INTO t_native_count;
						CLOSE cur_alias_asset;

						IF t_native_count > 0 THEN
							t_output	:= t_output || t_comma || '''' || t_outerrange_item || '''' ;
						ELSE
							t_alias_asset_range		:= NULL;
							OPEN cur_alias_reference(t_outerrange_item,'NW');
							FETCH cur_alias_reference INTO t_alias_asset_range;
							CLOSE cur_alias_reference;
							
							IF nvl(t_alias_asset_range,'-x') <> '-x' THEN
								t_output	:= t_output || '''' || t_alias_asset_range || '''' ;
								t_comma		:= ',';
							ELSE
								t_output	:= t_output || '''' || t_outerrange_item || '''' ;
								t_comma		:= ',';
							END IF;
						END IF;
					END IF;

					IF t_primary_type = 'ASSET' THEN
						t_native_count		:= 0;
						OPEN cur_alias_asset(t_primary_item);
						FETCH cur_alias_asset INTO t_native_count;
						CLOSE cur_alias_asset;

						IF t_native_count > 0 THEN
							t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
						ELSE
							t_alias_asset		:= NULL;
							OPEN cur_alias_reference(t_primary_item,'NW');
							FETCH cur_alias_reference INTO t_alias_asset;
							CLOSE cur_alias_reference;
							
							IF nvl(t_alias_asset,'-x') <> '-x' THEN
								t_output	:= t_output || t_comma || '''' || t_alias_asset || '''' ;
							ELSE
								t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
							END IF;
						END IF;
					END IF;

					t_output	:= t_output || ')' || t_newline;
					t_output	:= t_output || t_whitespace || '    UNION' || t_newline;
					t_output	:= t_output || t_whitespace || '    SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp' || t_newline;
					t_output	:= t_output || t_whitespace || '    FROM nm_members' || t_newline;
					t_output	:= t_output || t_whitespace || '    WHERE nm_type = ' || '''' || 'I' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || '        AND nm_obj_type IN (' ;

					t_comma		:= NULL;
					IF t_outerrange_type = 'ASSET' THEN
						IF nvl(t_alias_asset_range,'-x') = '-x' THEN
							t_output	:= t_output || '''' || t_outerrange_item || '''' ;
							t_comma		:= ',';
						ELSE
							t_output	:= t_output || '''' || t_alias_asset_range || '''' ;
							t_comma		:= ',';
						END IF;
					END IF;

					IF t_primary_type = 'ASSET' THEN
						IF nvl(t_alias_asset,'-x') = '-x' THEN
							t_output	:= t_output || t_comma || '''' || t_primary_item || '''' ;
						ELSE
							t_output	:= t_output || t_comma || '''' || t_alias_asset || '''' ;
						END IF;
					END IF;
					t_output	:= t_output || ')' || t_newline;
				END IF;
				t_output	:= t_output || t_newline || t_whitespace || ')))' || t_newline;

			ELSIF instr(t_template_line,'<<outer range items>>') > 0 THEN

				t_output	:= t_output || t_whitespace || ', (SELECT ' || t_newline;
				t_output	:= t_output || t_whitespace || '    nm_begin_mp' || t_newline;
				t_output	:= t_output || t_whitespace || '    , nm_end_mp' || t_newline;
				IF t_outerrange_type = 'ASSET' THEN
					t_output	:= t_output || t_whitespace || '    , ne_id_of' || t_newline;
				ELSE
					t_output	:= t_output || t_whitespace || '    , nm_ne_id_of ne_id_of' || t_newline;
				END IF;
				t_output	:= t_output || t_whitespace || 'FROM' || t_newline;
				IF t_outerrange_type = 'ASSET' THEN
					t_output	:= t_output || t_whitespace || 'v_nm_' || lower(t_outerrange_item) || '_nw' || t_newline;
				ELSE
					t_output	:= t_output || t_whitespace || 'v_nm_' || lower(t_outerrange_item) || '_nt' || t_newline;
					t_output	:= t_output || t_whitespace || ', nm_members' || t_newline;
				END IF;
				IF t_outerrange_type = 'ASSET' THEN
					IF nvl(t_outerrange_attribute,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || 'WHERE' || t_newline;
						t_output	:= t_output || t_whitespace || '   ' || lower(t_outerrange_attribute);
						IF nvl(t_outerrange_where,'-x') <> '-x' THEN
							t_output	:= t_output || ' ' || t_outerrange_where;
						ELSE
							t_output	:= t_output || ' IS NOT NULL';
						END IF;
					END IF;
				ELSE
					t_output	:= t_output || t_whitespace || 'WHERE' || t_newline;
					t_output	:= t_output || t_whitespace || '   ne_id = nm_ne_id_in' || t_newline;
					IF nvl(t_outerrange_attribute,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || '   AND ' || lower(t_outerrange_attribute);
						IF nvl(t_outerrange_where,'-x') <> '-x' THEN
							t_output	:= t_output || ' ' || t_outerrange_where;
						ELSE
							t_output	:= t_output || ' IS NOT NULL';
						END IF;
					END IF;
				END IF;

				t_output	:= t_output || ') y' || t_newline;

			ELSIF instr(t_template_line,'<<data selection start>>') > 0 THEN
				t_counter	:= 1;

				t_output	:= t_output || t_whitespace || ', ('|| t_newline;
				t_output	:= t_output || t_whitespace || 'SELECT'|| t_newline;

				IF nvl(t_primary_type,'-x') = 'ASSET' THEN
					FOR c_fields IN cur_fields('V_NM_' || t_primary_item || '_NW') LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_whitespace || '    ' || c_fields.column_name || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '    , ' || c_fields.column_name || t_newline;
						END IF;
						t_counter		:= t_counter + 1;
					END LOOP;
					t_output	:= t_output || t_whitespace || '    , ne_id_of' || t_newline;
				ELSE
					FOR c_fields IN cur_fields('V_NM_' || t_primary_item || '_NT') LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_whitespace || '    ' || c_fields.column_name || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '    , ' || c_fields.column_name || t_newline;
						END IF;
						t_counter		:= t_counter + 1;
					END LOOP;
					t_output	:= t_output || t_whitespace || '    , nm_ne_id_of ne_id_of' || t_newline;
				END IF;
				t_output	:= t_output || t_whitespace || '    , nm_begin_mp' || t_newline;
				t_output	:= t_output || t_whitespace || '    , nm_end_mp' || t_newline;
				t_output	:= t_output || t_whitespace || 'FROM' || t_newline;
				IF nvl(t_primary_type,'-x') = 'ASSET' THEN
					t_output	:= t_output || t_whitespace || '    v_nm_' || lower(t_primary_item) || '_nw' || t_newline;
				ELSE
					t_output	:= t_output || t_whitespace || '    v_nm_' || lower(t_primary_item) || '_nt' || t_newline;
					t_output	:= t_output || t_whitespace || '    , nm_members ' || t_newline;
				END IF;
				IF t_primary_type = 'ASSET' THEN
					IF nvl(t_primary_attribute,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || 'WHERE' || t_newline;
						t_output	:= t_output || t_whitespace || '   ' || lower(t_primary_attribute);
						IF nvl(t_primary_where,'-x') <> '-x' THEN
							t_output	:= t_output || ' ' || t_primary_where;
						ELSE
							t_output	:= t_output || ' IS NOT NULL';
						END IF;
					END IF;
				ELSE
					t_output	:= t_output || t_whitespace || 'WHERE' || t_newline;
					t_output	:= t_output || t_whitespace || '   ne_id = nm_ne_id_in' || t_newline;
					IF nvl(t_primary_attribute,'-x') <> '-x' THEN
						t_output	:= t_output || t_whitespace || '   AND ' || t_primary_attribute;
						IF nvl(t_primary_where,'-x') <> '-x' THEN
							t_output	:= t_output || ' ' || t_primary_where;
						ELSE
							t_output	:= t_output || ' IS NOT NULL';
						END IF;
					END IF;
				END IF;
				FOR c_more_where IN cur_addl_outer(t_table_id, t_data_item, t_primary_item, t_min_hm_id) LOOP
					t_output	:= t_output || t_newline || t_whitespace || ' AND ' || lower(c_more_where.hm_item_attribute);
					t_output	:= t_output || ' ' || c_more_where.hm_item_where;
				END LOOP;

				t_output	:= t_output || t_whitespace || ') a ' || t_newline;
				t_counter		:= t_counter + 1;

			ELSIF instr(t_template_line,'<<join conditions>>') > 0 THEN
				t_output		:= t_output || t_whitespace || t_and || 'r.ne_id_of = ' ||
								'a.ne_id_of(+)' || t_newline;
				t_output		:= t_output || t_whitespace || '    AND r.nm_begin_mp < ' ||
								'a.nm_end_mp(+)' || t_newline;
				t_output		:= t_output || t_whitespace || '    AND r.nm_end_mp > ' ||
								'a.nm_begin_mp(+)';
				t_output		:= t_output || t_newline;
			ELSIF instr(t_template_line,'<<create index>>') > 0 THEN
				t_output		:= t_output || t_newline ||
							'CREATE INDEX ' || t_mview_name || '_IDX ON ' || t_mview_name || '(NE_ID_OF);' || t_newline || t_newline;
			ELSE
				t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
			END IF;
		ELSE
			EXIT;
		END IF;

		t_template_return_count	:= t_template_return_count + 1;

	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_prte_view RETURN VARCHAR2 IS

BEGIN
	SELECT htmp_template_code 
	INTO t_template 
	FROM OHMS_template 
	WHERE htmp_template_type = 'OVERLAPPING_ROUTES' 
		AND htmp_template_target = 'VIEW';

	t_output		:= NULL;

	OPEN cur_get_prte_abbrev(1);
	FETCH cur_get_prte_abbrev INTO t_primary_item;
	CLOSE cur_get_prte_abbrev;

	t_mview_name	:= 'v_nm_' || lower(t_primary_item) || '_nw';

	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

	WHILE t_template_return_pos IS NOT NULL LOOP
		BEGIN
			t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

			IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
				t_template_read		:= t_template_return_pos - t_template_start;

				IF t_template_read > 0 THEN
					dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
					t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
				ELSE
					t_template_line		:= chr(10);
					t_whitespace		:= ' ';
				END IF;

				t_template_start		:= t_template_return_pos + 1;

				IF nvl(t_output,'-x') = '-x' THEN

					t_output	:= 'CREATE OR REPLACE VIEW ' || t_mview_name || ' AS ' || t_newline;

					OPEN cur_count_order;
					FETCH cur_count_order INTO t_counter;
					CLOSE cur_count_order;

				ELSIF instr(t_template_line,'<<order_value>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || 'CASE' || t_newline;

					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_order_value' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || '          ' || t_whitespace || '''' || '-1' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || 'END ordering_value' || t_newline;

				ELSIF instr(t_template_line,'<<route_order>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;

					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_min_route_order' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || t_whitespace || '          -1' || t_newline;
					t_output	:= t_output || t_whitespace || 'END primary_ne_id_in' || t_newline;

				ELSIF instr(t_template_line,'<<route_value>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;

					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_route' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || t_whitespace ||  '          -1' || t_newline;
					t_output	:= t_output || t_whitespace || 'END ne_id_in' || t_newline;

				ELSIF instr(t_template_line,'<<route_id>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;
					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_route_id' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || '          ' || t_whitespace ||  '''' || '-1' || '''' || t_newline;
					t_output	:= t_output || t_whitespace || 'END ne_unique' || t_newline;
	
				ELSIF instr(t_template_line,'<<cardinality>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;
					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_nm_cardinality' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || '          ' || t_whitespace ||  '-1' || t_newline;
					t_output	:= t_output || t_whitespace || 'END nm_cardinality' || t_newline;

				ELSIF instr(t_template_line,'<<slk>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;
					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_nm_slk' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || '          ' || t_whitespace ||  '-1' || t_newline;
					t_output	:= t_output || t_whitespace || 'END nm_slk' || t_newline;

				ELSIF instr(t_template_line,'<<end_slk>>') > 0 THEN
					
					t_output	:= t_output || t_whitespace || ', CASE' || t_newline;
					FOR i IN 1..t_counter LOOP
						t_output	:= t_output || t_whitespace || '     WHEN least(';
						FOR j IN 1..t_counter LOOP
							SELECT decode(j,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
							INTO t_alias
							FROM DUAL;

							IF j = 1 THEN
								t_comma		:= NULL;
							ELSE
								t_comma		:= ',';
							END IF;

							t_output	:= t_output || t_comma || t_alias || '_order_value';
						END LOOP;
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || ') = ' || t_alias || '_order_value THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || t_alias || '_nm_end_slk' || t_newline;
					END LOOP;
					t_output	:= t_output || t_whitespace || 'ELSE' || t_newline;
					t_output	:= t_output || '          ' || t_whitespace || '-1' || t_newline;
					t_output	:= t_output || t_whitespace || 'END nm_end_slk' || t_newline;

				ELSIF instr(t_template_line,'<<route_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						IF i = 1 THEN
							t_comma		:= NULL;
						ELSE
							t_comma		:= ',';
						END IF;

						t_output	:= t_output || t_whitespace || t_comma || ' ' || t_alias || '_route' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<order_Value_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || t_comma || ' CASE WHEN ' || t_alias || '_order_value = ' || '''' || '0' || '''' || ' THEN' || t_newline;
						t_output	:= t_output || '          ' || t_whitespace || '''' || '999' || '''' || t_newline;
						t_output	:= t_output || t_whitespace || '  ELSE ' || '''' || i || '''' || ' || ' || t_alias || '_order_value' || t_newline;
						t_output	:= t_output || t_whitespace || '  END ' ||  t_alias || '_order_value' || t_newline;

					END LOOP;
 
				ELSIF instr(t_template_line,'<<min_route_order_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '_min_route_order' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<route_id_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '_route_id' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<cardinality_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '_nm_cardinality' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<slk_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '_nm_slk' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<end_slk_selections>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '_nm_end_slk' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<route_ne_id_options>>') > 0 THEN

					FOR i IN 1..t_counter LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						IF i = 1 THEN
							t_comma		:= NULL;
						ELSE
							t_comma		:= ',';
						END IF;
  
						t_output	:= t_output || t_whitespace || t_comma || ' ' || t_alias || '.route_ne_id ' || t_alias || '_route' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<route_id_options>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

  						SELECT max(qpr_route_identifier) INTO t_primary_item FROM OHMS_primary_route WHERE qpr_order = tab_item(i);

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '.' || lower(t_primary_item) || ' ' || t_alias || '_route_id' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<cardinality_options>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

  						SELECT max(qpr_route_identifier) INTO t_primary_item FROM OHMS_primary_route WHERE qpr_order = tab_item(i);

						t_output	:= t_output || t_whitespace || ', ' || t_alias || '.nm_cardinality ' || t_alias || '_nm_cardinality' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<slk_options>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;
 
					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', DECODE (' || t_newline;
						t_output	:= t_output || t_whitespace || '     ' || t_alias || '.nm_cardinality' || t_newline;
						t_output	:= t_output || t_whitespace || '    , 1, ' || t_alias || '.nm_slk' || t_newline;
						t_output	:= t_output || t_whitespace || '     + (GREATEST (NVL(s.begin_point,0), ' || t_alias || '.nm_begin_mp))' || t_newline;
						t_output	:= t_output || t_whitespace || '    , - ' || t_alias || '.nm_begin_mp,' || t_alias || '.nm_slk' || t_newline;
						t_output	:= t_output || t_whitespace || '    , + (' || t_alias || '.nm_end_mp - LEAST(NVL(s.end_point,9999), ' || t_alias || '.nm_end_mp)))' || t_newline;
						t_output	:= t_output || t_whitespace || t_alias || '_nm_slk' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<end_slk_options>>') > 0 THEN
 
					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', DECODE (' || t_newline;
						t_output	:= t_output || t_whitespace || '     ' || t_alias || '.nm_cardinality' || t_newline;
						t_output	:= t_output || t_whitespace || '    , 1, ' || t_alias || '.nm_end_slk' || t_newline;
						t_output	:= t_output || t_whitespace || '    , - (' || t_alias || '.nm_end_mp' || t_newline;
						t_output	:= t_output || t_whitespace || '     - LEAST (NVL(s.end_point,9999), ' || t_alias || '.nm_end_mp))' || t_newline;
						t_output	:= t_output || t_whitespace || '    , ' || t_alias || '.nm_slk' || t_newline;
						t_output	:= t_output || t_whitespace || '    , + (' || t_alias || '.nm_end_mp - GREATEST(NVL(s.begin_point,0), ' || t_alias || '.nm_begin_mp)))' || t_newline;
						t_output	:= t_output || t_whitespace || t_alias || '_nm_end_slk' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<count_first_values>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || ', count(' || t_alias || '.route_ne_id) over ' || 
									' (partition by s.ne_id_of, s.begin_point, s.end_point order by ';

						t_counter2	:= 1;
						FOR c_sort IN cur_prte_sort(tab_item(i)) LOOP
							t_prte_sort_item	:= c_sort.qpr_sort_item;
							t_prte_sort_order	:= c_sort.qpr_sort_order;
							IF t_counter2 > 1 THEN
								t_output	:= t_output || ', ';
							END IF;
							t_counter2		:= t_counter2 + 1;
							t_output		:= t_output || ' lpad(' || t_alias || '.' || t_prte_sort_item || 
											',7,' || '''' || '0' || '''' || ') ' || t_prte_sort_order;
						END LOOP;
						t_output	:= t_output || ') ' || t_alias || '_order_value' || t_newline;


						t_output	:= t_output || t_whitespace || ', first_value(' || t_alias || '.route_ne_id) over ' || 
									' (partition by s.ne_id_of, s.begin_point, s.end_point order by ';

						t_counter2	:= 1;
						FOR c_sort IN cur_prte_sort(tab_item(i)) LOOP
							t_prte_sort_item	:= c_sort.qpr_sort_item;
							t_prte_sort_order	:= c_sort.qpr_sort_order;
							IF t_counter2 > 1 THEN
								t_output	:= t_output || ', ';
							END IF;
							t_counter2		:= t_counter2 + 1;
							t_output		:= t_output || ' lpad(' || t_alias || '.' || t_prte_sort_item || 
											',7,' || '''' || '0' || '''' || ') ' || t_prte_sort_order;
						END LOOP;
						t_output	:= t_output || ') ' || t_alias || '_min_route_order' || t_newline;

					END LOOP;

				ELSIF instr(t_template_line,'<<sub_view_points>>') > 0 THEN

					SELECT DISTINCT qpr_linear_group BULK COLLECT INTO tab_item FROM OHMS_primary_route WHERE qpr_linear_group IS NOT NULL;

					FOR i IN 1..tab_item.count LOOP

						t_viewname	:= 'v_nm_' || lower(tab_item(i)) || '_nt';

						IF i > 1 THEN
							t_output	:= t_output || t_whitespace || 'UNION' || t_newline;
						END IF;
						t_output	:= t_output || t_whitespace || 'SELECT nm_ne_id_of ne_id_of, nm_begin_mp mp ' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || t_viewname || t_newline;
						t_output	:= t_output || t_whitespace || '    ,  nm_members' || t_newline;
						t_output	:= t_output || t_whitespace || 'WHERE ne_id = nm_ne_id_in ' || t_newline;

						t_output	:= t_output || t_whitespace || 'UNION' || t_newline;

						t_output	:= t_output || t_whitespace || 'SELECT nm_ne_id_of ne_id_of, nm_end_mp mp ' || t_newline;
						t_output	:= t_output || t_whitespace || 'FROM ' || t_viewname || t_newline;
						t_output	:= t_output || t_whitespace || '    ,  nm_members' || t_newline;
						t_output	:= t_output || t_whitespace || 'WHERE ne_id = nm_ne_id_in ' || t_newline;
					END LOOP;

				ELSIF instr(t_template_line,'<<sub_views>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						SELECT lower(MIN(qpr_linear_group)) INTO t_view 
						FROM OHMS_primary_route 
						WHERE qpr_order = tab_item(i);

						t_viewname	:= 'v_nm_' || t_view || '_nt';

						t_output	:= t_output || t_whitespace || ', (SELECT ' || tab_item(i) || ' route_order' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'a.ne_id route_ne_id' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'a.ne_unique' || t_newline;
						FOR c_sort IN cur_prte_sort(tab_item(i)) LOOP
							t_prte_sort_item	:= c_sort.qpr_sort_item;
							t_output	:= t_output || t_whitespace || '     , ' || 'a.' || lower(t_prte_sort_item) || t_newline;
						END LOOP;

						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_ne_id_of' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_begin_mp' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_end_mp' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_cardinality' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_slk' || t_newline;
						t_output	:= t_output || t_whitespace || '     , ' || 'b.nm_end_slk' || t_newline;


						t_output	:= t_output || t_whitespace || 'FROM ' || t_viewname || ' a' || t_newline;
						t_output	:= t_output || t_whitespace || '     , nm_members b' || t_newline;
						t_output	:= t_output || t_whitespace || 'WHERE ne_id = nm_ne_id_in ' || t_newline;
						FOR c_where IN cur_prte_where(tab_item(i)) LOOP
							t_prte_where_item	:= c_where.qpr_item;
							t_prte_where		:= c_where.qpr_where;
							t_output		:= t_output || t_whitespace || '     AND ' || t_prte_where_item || 
											' ' || t_prte_where || t_newline;
						END LOOP;
						t_output	:= t_output || t_whitespace || ') ' || t_alias || t_newline;

					END LOOP;
 
				ELSIF instr(t_template_line,'<<sub_joins>>') > 0 THEN

					SELECT DISTINCT qpr_order BULK COLLECT INTO tab_item FROM OHMS_primary_route ORDER BY qpr_order;

					FOR i IN 1..tab_item.count LOOP
						SELECT decode(i,1,'a',2,'b',3,'c',4,'d',5,'e',6,'f','g')
						INTO t_alias
						FROM DUAL;

						t_output	:= t_output || t_whitespace || 'AND s.ne_id_of = ' || t_alias || '.nm_ne_id_of(+)' || t_newline;
						t_output	:= t_output || t_whitespace || 'AND s.begin_point < ' || t_alias || '.nm_end_mp(+)' || t_newline;
						t_output	:= t_output || t_whitespace || 'AND s.end_point > ' || t_alias || '.nm_begin_mp(+)' || t_newline;
					END LOOP;

				ELSE
					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;

			ELSE
				EXIT;
			END IF;

			t_template_return_count		:= t_template_return_count + 1;
		END;
	END LOOP;

	RETURN t_output;
END;

FUNCTION lf_generate_simple_view RETURN VARCHAR2 IS


BEGIN
	t_template_length		:= dbms_lob.getlength(t_template);
	t_template_read			:= 100;
	t_template_start		:= 1;
	t_template_return_count		:= 1;
	t_template_return_pos		:= 0;
	t_template_line			:= NULL;
	t_output			:= NULL;

	t_route_restrict		:= 'BOTH';
	t_point_cont			:= 'C';
	t_addl_count			:= 0;
	t_formula_used			:= NULL;
	t_found				:= NULL;

	WHILE t_template_return_pos IS NOT NULL LOOP
		t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

		IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
			t_template_read		:= t_template_return_pos - t_template_start;

			IF t_template_read > 0 THEN
				dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
				t_whitespace		:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
			ELSE
				t_template_line		:= chr(10);
				t_whitespace		:= ' ';
			END IF;

			t_template_start		:= t_template_return_pos + 1;
			t_whitespace			:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');

				IF nvl(t_output,'-x') = '-x' THEN
					t_output	:= 'CURSOR CUR_'|| t_data_item || ' IS' || t_newline;
					t_output	:= t_output || t_whitespace || 'SELECT' || t_newline;

					t_route_restrict		:= 'BOTH';
					t_formula_used		:= FALSE;
					t_min_hm_id			:= 0;
					t_primary_name		:= NULL;
					t_primary_item		:= NULL;
					t_primary_value		:= NULL;
					t_primary_attribute	:= NULL;
					t_primary_where		:= NULL;
					t_primary_type		:= NULL;
					t_primary_function	:= NULL;
					t_primary_formula		:= NULL;
					t_primary_hdi_id		:= NULL;

					OPEN cur_get_min_hmid(t_table_id, t_data_item);
					FETCH cur_get_min_hmid INTO t_min_hm_id;
					CLOSE cur_get_min_hmid;

					OPEN cur_primary_item(t_min_hm_id);
					FETCH cur_primary_item INTO t_primary_name
						, t_primary_item
						, t_primary_value
						, t_primary_attribute
						, t_primary_where
						, t_primary_type
						, t_primary_function
						, t_primary_formula
						, t_primary_hdi_id
						, t_primary_join;
					CLOSE cur_primary_item;

					IF nvl(trim(t_primary_formula),'-x') <> '-x' THEN
						t_formula_used		:= TRUE;
					END IF;

					OPEN cur_route_restrict(t_table_id, t_data_item);
					FETCH cur_route_restrict INTO t_route_restrict;
					CLOSE cur_route_restrict;

					tab_alias.delete;
					tab_item.delete;
					tab_from.delete;
					tab_type.delete;

					tab_alias(1)				:= 'a';
					tab_item(1)				:= t_primary_item;
					tab_type(1)				:= t_primary_type;

					IF t_network_flag > 0 THEN
						tab_alias(2)			:= 'b';
						tab_item(2)				:= 'NETWORK';
						tab_type(2)				:= 'NETWORK';
					ELSE
						tab_alias(2)			:= 'x';
						tab_item(2)				:= 'x';
						tab_type(2)				:= 'x';
					END IF;

					t_counter				:= tab_alias.count;
					FOR c_adddl_items IN cur_distinct_addl_item_vals(t_table_id, t_data_item, t_min_hm_id) LOOP
						t_found		:= 0;
						FOR t_loop IN 1..tab_alias.count LOOP
							IF c_adddl_items.hm_item = tab_item(t_loop) THEN
								t_found		:= 1;
							END IF;
						END LOOP;

						IF t_found = 0 THEN
							t_counter						:= t_counter + 1;
							SELECT decode(t_counter,3, 'c', 4, 'd', 5, 'e', 6, 'f', 7 ,'g','h')
							INTO t_alias
							FROM DUAL;

							tab_alias(t_counter)				:= t_alias;
							tab_item(t_counter)				:= c_adddl_items.hm_item;
							tab_type(t_counter)				:= c_adddl_items.hm_item_type;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<cursor fields>>') > 0 THEN
					t_counter	:= 1;
					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF t_counter = 1 THEN
							t_output	:= t_output || t_whitespace || lower(c_map.hm_item_value) ||
									 ' '|| c_map.hcl_name || t_newline ;
						ELSE
							IF nvl(c_map.hm_output,'-x') = 'Y' THEN
								t_output	:= trim(t_output) || t_whitespace || ', ' || trim(lower(c_map.hm_item)) || '_' 
											|| trim(lower(c_map.hm_item_value)) || ' ' || c_map.hcl_name || t_newline;
							ELSE
								t_output	:= trim(t_output) || t_whitespace || ', ' || trim(lower(c_map.hm_item_value) ||
									' ' || c_map.hcl_name) || t_newline;
							END IF;
						END IF;
						t_counter		:= t_counter + 1;
					END LOOP;

				ELSIF instr(t_template_line,'<<inner select 1 route_id field>>') > 0 THEN
					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' then
							t_output	:= t_output || t_whitespace || 'l.' || lower(c_map.hm_item_value) || t_newline ;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<unit conversions>>') > 0 THEN
					t_unit_conversions	:= 1;

				ELSIF instr(t_template_line,'<<unit conversions end>>') > 0 THEN
					t_unit_conversions	:= 0;

				ELSIF t_unit_conversions > 0 THEN
					t_route_type		:= NULL;
					t_item_type			:= NULL;
					t_item			:= NULL;
					t_unit_divisor		:= 1;

					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' THEN
							t_route_type 	:= c_map.hm_item;
						ELSIF instr(c_map.hcl_name,'VALUE_') > 0 THEN
							t_item_type 	:= c_map.hm_item_type;
							t_item		:= c_map.hm_item;
						END IF;
					END LOOP;

					IF t_item_type = 'ASSET' THEN
						OPEN cur_divisor_asset(t_route_type, t_item);
						FETCH cur_divisor_asset INTO t_unit_divisor;
						CLOSE cur_divisor_asset;
					ELSE
						OPEN cur_divisor_group(t_route_type, t_item);
						FETCH cur_divisor_group INTO t_unit_divisor;
						CLOSE cur_divisor_group;
					END IF;

					t_unit_divisor		:= nvl(t_unit_divisor,1);
					t_template_line			:= replace(t_template_line,'<<unit divisor>>',t_unit_divisor);
					t_output			:= t_output || t_whitespace || ltrim(t_template_line,' ');

				ELSIF instr(t_template_line,'<<asset value>>') > 0 THEN
					IF t_formula_used THEN
						t_output	:= t_output || t_whitespace || ', ' || t_primary_formula ||
									' ' || tab_item(1) || '_' || lower(t_primary_value) || t_newline ;
					ELSE
						t_output	:= t_output || t_whitespace || ', ' || tab_item(1) || '_' || lower(t_primary_value) || t_newline ;
					END IF;

					FOR c_add_items IN cur_addl_items(t_table_id, t_data_item, t_min_hm_id) LOOP
						IF nvl(c_add_items.hm_item_value,'-x') <> '-x' THEN
							t_found		:= 0;
							FOR t_loop IN 1..tab_alias.count LOOP
								IF c_add_items.hm_item = tab_item(t_loop) THEN
									t_found		:= 1;
									t_alias		:= tab_item(t_loop);
								END IF;
							END LOOP;

							IF t_found = 1 THEN
								IF nvl(c_add_items.hm_item_formula,'-x') <> '-x' THEN
									t_output	:= t_output || t_whitespace || ', ' || c_add_items.hm_item_formula ||
												' ' || t_alias || '_' || c_add_items.hm_item_value || t_newline ;
								ELSE
									t_output	:= t_output || t_whitespace || ', ' || t_alias || '_' || 
												c_add_items.hm_item_value || t_newline ;
								END IF;
							END IF;
						END IF;
					END LOOP;


				ELSIF instr(t_template_line,'<<datum field>>') > 0 THEN
					IF t_primary_type = 'ASSET' OR t_primary_function = 'OUTERJOIN_DATA' THEN
						t_output	:= t_output || t_whitespace || 'a.ne_id_of ' || t_newline ;
					ELSE
						t_output	:= t_output || t_whitespace || 'a.nm_ne_id_of ne_id_of ' || t_newline ;
					END IF;

				ELSIF instr(t_template_line,'<<greatest begin>>') > 0 THEN
					t_counter		:= tab_alias.count;

					IF t_counter = 1 THEN
						t_output	:= t_output || t_whitespace || ', a.nm_begin_mp' || t_newline;
					ELSIF t_counter = 2 AND t_network_flag = 1 THEN
						t_output	:= t_output || t_whitespace || ', greatest(a.nm_begin_mp, b.nm_begin_mp) nm_begin_mp' || t_newline;
					ELSIF t_counter = 3 AND t_network_flag = 0 THEN
						t_output	:= t_output || t_whitespace || ', greatest(a.nm_begin_mp, c.nm_begin_mp) nm_begin_mp' || t_newline;
					ELSE
						IF t_network_flag > 0 THEN
							t_output	:= t_output || t_whitespace || ', greatest(a.nm_begin_mp, b.nm_begin_mp' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || ', greatest(a.nm_begin_mp ' ;
						END IF;

						FOR t_loop IN 1..tab_alias.count LOOP
							IF t_loop > 2 THEN

								IF tab_type(t_loop) = 'ASSET' THEN
									t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
									t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
												' FROM ( ' ||
												    ' SELECT nit_pnt_or_cont ' ||
												    ' FROM nm_inv_types_all ' ||
												    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
											     'UNION ' ||
												     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

									EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
									IF t_point_cont	= '-x' THEN
										t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
												' WHERE rownum < 10';
		
										EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
										IF t_point_cont = '0'THEN
											t_point_cont 	:= 'P';
										ELSE
											t_point_cont 	:= 'C';
										END IF;
									END IF;
								ELSE
									t_point_cont 	:= 'C';
								END IF;

								IF t_point_cont <> 'P' THEN
									t_alias			:= tab_alias(t_loop);
									t_output		:= t_output || ',' || t_alias || '.nm_begin_mp' ;
								END IF;
							END IF;
						END LOOP;
						t_output	:= t_output || ') nm_begin_mp' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<least end>>') > 0 THEN
					t_counter		:= tab_alias.count;

					IF t_counter = 1 THEN
						t_output	:= t_output || t_whitespace || ', a.nm_end_mp' || t_newline;
					ELSIF t_counter = 2 AND t_network_flag = 1 THEN
						t_output	:= t_output || t_whitespace || ', least(a.nm_end_mp, b.nm_end_mp) nm_end_mp' || t_newline;
					ELSIF t_counter = 3 AND t_network_flag = 0 THEN
						t_output	:= t_output || t_whitespace || ', least(a.nm_end_mp, c.nm_end_mp) nm_end_mp' || t_newline;
					ELSE
						IF t_network_flag > 0 THEN
							t_output	:= t_output || t_whitespace || ', least(a.nm_end_mp, b.nm_end_mp' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || ', least(a.nm_end_mp ';
						END IF;

						FOR t_loop IN 1..tab_alias.count LOOP
							IF t_loop > 2 THEN
								IF tab_type(t_loop) = 'ASSET' THEN
									t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
									t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
												' FROM ( ' ||
												    ' SELECT nit_pnt_or_cont ' ||
												    ' FROM nm_inv_types_all ' ||
												    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
											     'UNION ' ||
												     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

									EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
									IF t_point_cont	= '-x' THEN
										t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
												' WHERE rownum < 10';
		
										EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
										IF t_point_cont = '0'THEN
											t_point_cont 	:= 'P';
										ELSE
											t_point_cont 	:= 'C';
										END IF;
									END IF;
								ELSE
									t_point_cont 	:= 'C';
								END IF;

								IF t_point_cont <> 'P' THEN
									t_alias		:= tab_alias(t_loop);
									t_output		:= t_output || ',' || t_alias || '.nm_end_mp' ;
								END IF;
							END IF;
						END LOOP;
						t_output	:= t_output || ') nm_end_mp' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<inner asset value>>') > 0 THEN
					IF nvl(t_primary_value,'-x') <> '-x' THEN
--						IF t_formula_used = TRUE THEN
							t_primary_value	:= t_primary_value || ' ' || trim(t_primary_item) || '_' || trim(t_primary_value);
--						END IF;

						IF t_primary_type = 'ASSET' OR t_primary_function = 'OUTERJOIN_DATA' THEN
							t_primary_alias	:= 'a';
							t_output	:= t_output || t_whitespace || ', a.' || lower(t_primary_value)|| t_newline ;
						ELSE
							t_primary_alias	:= 'aa';
							t_output	:= t_output || t_whitespace || ', aa.' || lower(t_primary_value) || t_newline ;
						END IF;
					END IF;

					t_counter		:= 0;
					FOR c_addl_items IN cur_addl_items(t_table_id, t_data_item, t_min_hm_id) LOOP
						t_counter			:= t_counter + 1;
						t_addl_name			:= c_addl_items.hcl_name;
						t_addl_item			:= c_addl_items.hm_item;
						t_addl_value		:= c_addl_items.hm_item_value;
						t_addl_attribute		:= c_addl_items.hm_item_attribute;
						t_addl_where		:= c_addl_items.hm_item_where;
						t_addl_type			:= c_addl_items.hm_item_type;
						t_addl_function		:= c_addl_items.hm_item_function;

						FOR t_loop IN 1..tab_alias.count LOOP
							IF t_addl_item = tab_item(t_loop) THEN
								t_alias		:= tab_alias(t_loop);
							END IF;
						END LOOP;

--						IF t_formula_used = TRUE AND nvl(trim(t_addl_value),'-x') <> '-x' THEN
--							t_addl_value	:= t_addl_value || ' ' || trim(t_addl_item) || '_' || trim(t_addl_value);
--						END IF;

						IF nvl(trim(t_addl_value),'-x') <> '-x' THEN
							t_addl_value	:= t_addl_value || ' ' || trim(t_addl_item) || '_' || trim(t_addl_value);
						END IF;

						IF ((t_addl_item = t_primary_item) AND t_primary_function IN ('SUM','COUNT','MIN','MAX'))
							OR nvl(t_addl_value,'-x') = '-x' THEN
								NULL;
						ELSE
							IF (t_addl_type = 'ASSET' OR t_addl_function = 'OUTERJOIN_DATA') AND (nvl(t_addl_value,'-x') <> '-x') THEN
								t_output	:= t_output || t_whitespace ||
										', ' || t_alias || '.' || lower(t_addl_value) || t_newline ;
							ELSIF t_addl_type = 'GROUP' AND nvl(t_addl_value,'-x') <> '-x' THEN
								t_output	:= t_output || t_whitespace ||
									', ' || t_alias || t_alias || '.' || lower(t_addl_value) || t_newline ;
							END IF;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<inner from primary item>>') > 0 THEN
					IF t_primary_function IN ('SUM','COUNT', 'MIN', 'MAX') THEN
						IF t_primary_type = 'ASSET' THEN
							t_output	:= t_output || t_whitespace || '  v_nm_' ||
										lower(t_primary_item) || t_primary_hdi_id || '_' ||
										lower(t_primary_function) || '_mv_nw a' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '  v_nm_' ||
									lower(t_primary_item) || t_primary_hdi_id || '_mv_nt a' || t_newline;
						END IF;
					ELSIF t_primary_function = 'OUTERJOIN_DATA' THEN
						IF t_primary_type = 'ASSET' THEN
							t_output	:= t_output || t_whitespace || '  v_nm_' ||
									lower(t_primary_item) || t_primary_hdi_id || '_outer_mv_nw a' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || '  v_nm_' ||
									lower(t_primary_item) || t_primary_hdi_id || '_outer_mv_nt a' || t_newline;
						END IF;

					ELSIF t_primary_type = 'ASSET' THEN
						t_output	:= t_output || t_whitespace || '  v_nm_' || lower(t_primary_item) ||
									'_nw a' || t_newline;
					ELSE
						t_output	:= t_output || t_whitespace || '  v_nm_' || lower(t_primary_item) || '_nt aa' || t_newline ;
						t_output	:= t_output || t_whitespace || ', nm_members a' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<inner from network restriction>>') > 0 THEN
					IF t_network_flag > 0 THEN
						t_output	:= t_output || t_whitespace || ', OHMS_' || t_table_id || '_network_mv b' || t_newline;
					END IF;

				ELSIF instr(t_template_line,'<<additional from item restrictions>>') > 0 THEN
					t_counter			:= 0;
					t_addl_name			:= NULL;
					t_addl_item			:= NULL;
					t_addl_value		:= NULL;
					t_addl_attribute		:= NULL;
					t_addl_where		:= NULL;
					t_addl_type			:= NULL;

					FOR t_loop IN 1..tab_alias.count LOOP
						IF t_loop > 2 THEN
							OPEN cur_addl_function(t_table_id, t_data_item, tab_item(t_loop));
							FETCH cur_addl_function INTO t_counter;
							CLOSE cur_addl_function;

							t_addl_item			:= tab_item(t_loop);
							t_addl_type			:= tab_type(t_loop);
							IF t_counter > 0 THEN
								t_addl_function		:= 'OUTERJOIN_DATA';
							ELSE
								t_addl_function		:= NULL;
							END IF;

							t_alias			:= tab_alias(t_loop);

							IF t_addl_item <> t_primary_item THEN
								IF t_addl_function = 'OUTERJOIN_DATA' AND t_addl_type = 'ASSET' THEN
									t_output	:= t_output || t_whitespace || ' , v_nm_' ||
											lower(t_addl_item) || t_data_item || '_outer_mv_nw ' || t_alias || t_newline;
								ELSIF t_addl_function = 'OUTERJOIN_DATA' AND t_addl_type = 'GROUP' THEN
									t_output	:= t_output || t_whitespace || ' , v_nm_' ||
											lower(t_addl_item) || t_data_item || '_outer_mv_nt ' || t_alias || t_newline;
								ELSIF t_addl_type = 'ASSET' THEN
									t_output	:= t_output || t_whitespace || ', v_nm_' || lower(t_addl_item) || '_nw '||
											t_alias || t_newline;
								ELSE
									t_output	:= t_output || t_whitespace || ', v_nm_' || lower(t_addl_item) || '_nt ' ||
											t_alias || t_alias || t_newline;

									t_output	:= t_output || t_whitespace || ', nm_members ' || t_alias || t_newline;
								END IF;
							END IF;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<where word>>') > 0 THEN
					t_counter	:= 0;
					t_and		:= NULL;
					FOR c_addl_items IN cur_distinct_addl_items(t_table_id, t_data_item, t_min_hm_id) LOOP

						IF c_addl_items.hm_item = t_primary_item AND t_primary_function IN ('SUM','COUNT','MIN','MAX') THEN
							t_addl_count 	:= 0;
						ELSE
							OPEN cur_addl_where(t_table_id, t_data_item, t_min_hm_id,c_addl_items.hm_item,c_addl_items.hm_item_type);
							FETCH cur_addl_where INTO t_addl_count;
							CLOSE cur_addl_where;
						END IF;

						IF c_addl_items.hm_item <> t_primary_item THEN
							t_counter		:= t_counter + 1;
						ELSIF t_addl_count > 0 THEN
							t_counter		:= t_counter + 1;
						END IF;
					END LOOP;

					IF (t_network_flag > 0 OR t_primary_type = 'GROUP' OR nvl(t_primary_attribute,'-x') <> '-x' OR t_counter > 0) THEN
						IF nvl(t_primary_function,'-x') IN ('COUNT','SUM','MIN','MAX') AND
							t_counter = 0 AND t_network_flag = 0 THEN
							NULL;
						ELSE
							t_output	:= t_output || t_whitespace || 'WHERE' || t_newline;
						END IF;
					END IF;

				ELSIF instr(t_template_line,'<<inner where>>') > 0 THEN
					t_counter	:= 0;
					t_and		:= NULL;
					IF t_network_flag > 0 THEN
						IF t_primary_type = 'ASSET' OR t_primary_function = 'OUTERJOIN_DATA' THEN
							t_output	:= t_output || t_whitespace || 'a.ne_id_of = b.ne_id_of' || t_newline;
						ELSE
							t_output	:= t_output || t_whitespace || 'a.nm_ne_id_in = aa.ne_id' || t_newline;
							t_output	:= t_output || t_whitespace || 'AND a.nm_ne_id_of = b.ne_id_of' || t_newline;
						END IF;
						t_output	:= t_output || t_whitespace || 'AND a.nm_begin_mp < ' || 'b.nm_end_mp' || t_newline ;

						t_output	:= t_output || t_whitespace || 'AND a.nm_end_mp > ' || 'b.nm_begin_mp' || t_newline  ;
						t_and		:= 'AND ';
					ELSE
						IF t_primary_type = 'GROUP' THEN
							t_output	:= t_output || t_whitespace || 'aa.ne_id = a.nm_ne_id_in' || t_newline ;
							t_and		:= 'AND ';
						END IF;
					END IF;

					FOR t_loop IN 1..tab_alias.count LOOP
						IF t_loop > 2 THEN
							OPEN cur_addl_function(t_table_id, t_data_item, tab_item(t_loop));
							FETCH cur_addl_function INTO t_counter;
							CLOSE cur_addl_function;

							t_addl_item			:= tab_item(t_loop);
							t_addl_type			:= tab_type(t_loop);
							IF t_counter > 0 THEN
								t_addl_function		:= 'OUTERJOIN_DATA';
							ELSE
								t_addl_function		:= NULL;
							END IF;

							t_alias			:= tab_alias(t_loop);

							IF t_addl_item <> t_primary_item THEN
								IF t_addl_type = 'ASSET' OR t_addl_function = 'OUTERJOIN_DATA' THEN
									IF t_primary_type = 'GROUP' AND t_primary_function <> 'OUTERJOIN_DATA' THEN
										t_output	:= t_output || t_whitespace ||
												t_and || 'a.nm_ne_id_of = ' || t_alias || '.ne_id_of' || t_newline ;
									ELSE
										t_output	:= t_output || t_whitespace ||
												t_and || 'a.ne_id_of = ' || t_alias || '.ne_id_of' || t_newline ;
									END IF;
								ELSE
									t_output	:= t_output || t_whitespace || t_and || t_alias || t_alias ||
												'.ne_id = ' ||t_alias || '.nm_ne_id_in' || t_newline ;
									t_and		:= 'AND ';

									IF t_primary_type = 'GROUP' AND t_primary_function <> 'OUTERJOIN_DATA' THEN
										t_output	:= t_output || t_whitespace ||
												t_and || 'a.nm_ne_id_of = ' ||t_alias || '.nm_ne_id_of' || t_newline ;
									ELSE
										t_output	:= t_output || t_whitespace ||
												t_and || 'a.ne_id_of = ' ||t_alias || '.nm_ne_id_of' || t_newline ;
									END IF;
								END IF;

								IF t_addl_type = 'ASSET' THEN
									t_table_name	:= 'v_nm_' || t_primary_item || '_nw';
	
									t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
												' FROM ( ' ||
												    ' SELECT nit_pnt_or_cont ' ||
												    ' FROM nm_inv_types_all ' ||
												    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
											     'UNION ' ||
												     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

									EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
		
									IF t_point_cont	= '-x' THEN
										t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
												' WHERE rownum < 10';
		
										EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;
	
										IF t_point_cont = '0'THEN
											t_point_cont 	:= 'P';
										ELSE
											t_point_cont 	:= 'C';
										END IF;
									END IF;
								ELSE
									t_point_cont 	:= 'C';
								END IF;

								IF t_point_cont = 'P' THEN
									t_output		:= t_output || t_whitespace ||
												'AND a.nm_begin_mp <= ' || t_alias || '.nm_end_mp' || t_newline ;

									t_output		:= t_output || t_whitespace ||
												'AND a.nm_end_mp >= ' || t_alias || '.nm_begin_mp' || t_newline  ;
									t_and			:= 'AND ';
								ELSE
									t_output		:= t_output || t_whitespace ||
												'AND a.nm_begin_mp < ' || t_alias || '.nm_end_mp' || t_newline ;

									t_output		:= t_output || t_whitespace ||
												'AND a.nm_end_mp > ' || t_alias || '.nm_begin_mp' || t_newline  ;
									t_and			:= 'AND ';
								END IF;
							END IF;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<attribute where>>') > 0 THEN
					t_counter	:= 0;
					IF nvl(t_primary_function,'-x') NOT IN ('COUNT','SUM','MIN','MAX','-x','OUTERJOIN_RANGE', 'OUTERJOIN_DATA') THEN

						IF nvl(t_primary_where,'-x') <> '-x' THEN
							IF t_primary_type = 'ASSET' THEN
								t_output	:= t_output || t_whitespace ||
										t_and  || 'a.' || lower(t_primary_attribute) || ' ' || t_primary_where || t_newline ;
							ELSE
								t_output	:= t_output || t_whitespace ||
										t_and  || 'aa.' || lower(t_primary_attribute) || ' ' || t_primary_where || t_newline ;
							END IF;
							t_and 		:= 'AND ';
						END IF;

						IF nvl(t_primary_attribute,'-x') <> '-x' AND nvl(t_primary_where,'-x') = '-x' THEN
							IF t_primary_type = 'ASSET' THEN
								t_output	:= t_output || t_whitespace ||
										t_and || 'a.' || lower(t_primary_attribute) || ' IS NOT NULL' || t_newline ;
							ELSE
								t_output	:= t_output || t_whitespace ||
										t_and || 'aa.' || lower(t_primary_attribute) || ' IS NOT NULL' || t_newline ;
							END IF;
							t_and			:= 'AND ';
						END IF;

						t_counter		:= 0;
					END IF;

					FOR c_addl_items IN cur_addl_items(t_table_id, t_data_item, t_min_hm_id) LOOP
						t_counter		:= t_counter + 1;
						t_addl_name		:= c_addl_items.hcl_name;
						t_addl_item		:= c_addl_items.hm_item;
						t_addl_value		:= c_addl_items.hm_item_value;
						t_addl_attribute	:= c_addl_items.hm_item_attribute;
						t_addl_where		:= c_addl_items.hm_item_where;
						t_addl_type		:= c_addl_items.hm_item_type;
						t_addl_function		:= c_addl_items.hm_item_function;

						FOR t_loop IN 1..tab_alias.count LOOP
							IF t_addl_item = tab_item(t_loop) THEN
								t_alias		:= tab_alias(t_loop);
							END IF;
						END LOOP;

						IF nvl(t_primary_function,'-x') NOT IN ('COUNT','SUM','MIN','MAX','-x','OUTERJOIN_RANGE', 'OUTERJOIN_DATA') THEN
							IF nvl(t_addl_where,'-x') <> '-x' THEN
								IF t_addl_type = 'ASSET' THEN
									t_output	:= t_output || t_whitespace ||
											t_and || t_alias || '.' || lower(t_addl_attribute) ||
											' ' || t_addl_where || t_newline ;
								ELSE
									t_output	:= t_output || t_whitespace ||
											t_and || t_alias || t_alias || '.' || lower(t_addl_attribute) ||
											' ' || t_addl_where || t_newline ;
								END IF;
								t_and			:= 'AND ';
							END IF;
							IF nvl(t_addl_attribute,'-x') <> '-x' AND nvl(t_addl_where,'-x') = '-x' THEN
								IF t_addl_type = 'ASSET' THEN
									t_output	:= t_output || t_whitespace ||
											t_and || t_alias || '.' || lower(t_addl_attribute) || ' IS NOT NULL' || t_newline ;
								ELSE
									t_output	:= t_output || t_whitespace ||
											t_and || t_alias || t_alias ||
											'.' || lower(t_addl_attribute) || ' IS NOT NULL' || t_newline ;
								END IF;
								t_and			:= 'AND ';
							END IF;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<inner select 2 route_id field>>') > 0 THEN
					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' then
							t_output	:= t_output || t_whitespace || lower(c_map.hm_item_value) || t_newline ;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<inner from 2 location view>>') > 0 THEN
					FOR c_map IN cur_map_multiples(t_table_id, t_data_item) LOOP
						IF c_map.hcl_name = 'ROUTE_ID' then
							t_output	:= t_output || t_whitespace || 'v_nm_' || lower(c_map.hm_item) || '_nt' || t_newline ;
						END IF;
					END LOOP;

				ELSIF instr(t_template_line,'<<inner from 2 location extended>>') > 0 THEN
					IF nvl(t_route_restrict,'BOTH') = 'D' THEN
						t_output	:= t_output || t_whitespace || ', nm_members_d ' || t_newline ;
					ELSIF nvl(t_route_restrict,'BOTH') = 'I' THEN
						t_output	:= t_output || t_whitespace || ', nm_members_i ' || t_newline ;
					ELSE
						t_output	:= t_output || t_whitespace || ', nm_members ' || t_newline ;
					END IF;
				ELSIF instr(t_template_line,'<<route_restriction>>') > 0 THEN
					NULL;
				ELSIF instr(t_template_line,'<<query join type>>') > 0 THEN
					t_counter	:= 0;
					t_output		:= t_output || t_whitespace ||
								'a.ne_id_of = l.nm_ne_id_of' || t_newline ;
					t_output		:= t_output || t_whitespace ||
								'AND a.nm_begin_mp < l.nm_end_mp' || t_newline ;
					t_output		:= t_output || t_whitespace ||
								'AND a.nm_end_mp > l.nm_begin_mp' || t_newline ;
				ELSE
					t_output	:= t_output || t_whitespace || ltrim(t_template_line,' ') || t_newline;
				END IF;

		ELSE
			EXIT;
		END IF;

		t_template_return_count		:= t_template_return_count + 1;

	END LOOP;

	RETURN t_output;
END;

PROCEDURE lp_create_network_restriction IS

BEGIN

	t_network_flag		:= 1;

-- Create a TABLE that holds the datum/offsets that the results will be restricted to

	OPEN cur_network(t_ht_hl_id);
	FETCH cur_network INTO t_hl_type
				, t_hl_item
				, t_hl_item_attribute
				, t_hl_where
				, t_hl_item_type;
	CLOSE cur_network;

	t_network_mv_name	:= 'OHMS_' || trim(t_ht_id) || '_NETWORK_MV';

	CASE t_hl_item_type
-- mview specification, if the restriction is based on an assets location
		WHEN 'ASSET' THEN
			t_route_item		:= NULL;
			FOR c_map IN cur_map_all(t_table_id, 1) LOOP
				IF c_map.hcl_name = 'ROUTE_ID' THEN
					t_route_item			:= c_map.hm_item;
				END IF;
			END LOOP;

			t_network_select	:= t_tab || 'SELECT a.ne_id_of, a.nm_begin_mp, a,nm_end_mp ' || t_newline;
			t_network_select	:= t_network_select || t_tab || ', c.ne_unique ' || t_newline;

			t_network_select	:= t_network_select || t_tab || ', decode(b.nm_cardinality, 1, b.nm_slk + ' ||
							'(greatest(nvl(a.nm_begin_mp,0),b.nm_begin_mp))/1 - b.nm_begin_mp/1, ' || t_newline;

			t_network_select	:= t_network_select || t_tab || 'b.nm_slk + (b.nm_end_mp  - ' || 
							'least(nvl(a.nm_end_mp,9999), b.nm_end_mp))/1) nm_slk' || t_newline;


			t_network_select	:= t_network_select || t_tab || ', decode(b.nm_cardinality, 1, b.nm_end_slk - ' || 
							'(b.nm_end_mp - least(nvl(a.nm_end_mp,9999), b.nm_end_mp))/1, ' || t_newline;

			t_network_select	:= t_network_select || t_tab || 'b.nm_slk + (b.nm_end_mp - ' || 
							'greatest(nvl(a.nm_begin_mp,0), b.nm_begin_mp))/1) nm_end_slk' || t_newline;



			t_network_from		:= t_tab || ' FROM V_NM_' || t_hl_item || '_NW a' || t_newline;
			t_network_from		:= t_network_from || t_tab || t_tab || ', nm_elements aa' || t_newline;
			t_network_from		:= t_network_from || t_tab || t_tab || ', nm_members b' || t_newline;
			t_network_from		:= t_network_from || t_tab || t_tab || ', nm_elements c' || t_newline;


			t_network_where	:= t_newline || t_tab || 'WHERE a.ne_id_of = aa.ne_id ' || t_newline ||
							t_tab || t_tab || 'AND aa.ne_type = ' || '''' || 'S' || '''' || t_newline;

			t_network_where		:= t_network_where || t_tab || t_tab || ' AND a.ne_id_of = b.nm_ne_id_of' || t_newline;
			t_network_where		:= t_network_where || t_tab || t_tab || ' AND b.nm_ne_id_in = c.ne_id' || t_newline;
			t_network_where		:= t_network_where || t_tab || t_tab || ' AND b.nm_obj_type = ' || '''' || t_route_item || '''';
			t_network_where		:= t_network_where || t_tab || t_tab || ' AND a.nm_begin_mp < b.nm_end_mp' || t_newline;
			t_network_where		:= t_network_where || t_tab || t_tab || ' AND a.nm_end_mp > b.nm_begin_mp' || t_newline;

			IF nvl(t_hl_item_attribute,'--') <> '--' THEN
				IF nvl(t_hl_where,'--') = '--' THEN
					t_network_where	:= t_network_where || t_newline || t_tab || 'AND ' || t_hl_item_attribute ||
								' IS NOT NULL;';
				ELSE
					t_network_where	:= t_network_where || t_newline || t_tab || 'AND ' || t_hl_item_attribute  ||
								' ' || t_hl_where || ';';
				END IF;
			ELSE
				t_network_where		:= t_network_where || ';';
			END IF;
		WHEN 'GROUP' THEN
-- mview specification, if the restriction is based on an groups location
			t_network_select	:= t_tab || 'SELECT b.nm_ne_id_of ne_id_of, b.nm_begin_mp, b.nm_end_mp, a.ne_unique, b.nm_slk, b.nm_end_slk';

			t_network_from		:= t_newline || t_tab || 'FROM V_NM_' || t_hl_item || '_NT a' || t_newline ||
							t_tab || t_tab || ', nm_members b' || t_newline ||
							t_tab || t_tab || ', nm_elements c';

			t_network_where	:= t_newline || t_tab || 'WHERE a.ne_id = b.nm_ne_id_in ' || t_newline ||
							t_tab || t_tab || 'AND b.nm_ne_id_of = c.ne_id' || t_newline ||
							t_tab || t_tab || 'AND b.nm_obj_type = ' || '''' || t_hl_item || '''' || t_newline ||
							t_tab || t_tab || 'AND b.nm_type = ' || '''' || 'G' || '''' || t_newline ||
							t_tab || t_tab || 'AND c.ne_type = ' || '''' || 'S' || '''';

			IF nvl(t_hl_item_attribute,'--') <> '--' THEN
				IF nvl(t_hl_where,'--') = '--' THEN
					t_network_where	:= t_network_where || t_newline ||
									t_tab || t_tab || 'AND a.' || t_hl_item_attribute || ' IS NOT NULL;';
				ELSE
					t_network_where	:= t_network_where || t_newline ||
							t_tab || t_tab || 'AND a.' || t_hl_item_attribute  || ' ' || t_hl_where || ';';
				END IF;
			ELSE
				t_network_where		:= t_network_where || ';';
			END IF;

		WHEN 'DATUM' THEN
-- mview specification, if the restriction is based on an datum types location
			t_network_select	:= t_tab || 'SELECT ne_id ne_id_of, 0 nm_begin_mp, ne_length nm_end_mp';
			t_network_from		:= t_newline || t_tab || 'FROM V_NM_' || t_hl_item || '_NT ';

			IF nvl(t_hl_item_attribute,'--') <> '--' THEN
				IF nvl(t_hl_where,'--') = '--' THEN
					t_network_where	:= t_newline || t_tab || 'WHERE ' ||
										t_hl_item_attribute || ' IS NOT NULL' || t_newline ||
								' AND ne_type = ' || '''' || 'S' || '''' || ';';
				ELSE
					t_network_where	:= t_newline || t_tab || ' WHERE ' ||
										t_hl_item_attribute  || ' ' || t_hl_where || t_newline || 
								' AND ne_type = ' || '''' || 'S' || '''' || ';';
				END IF;
			ELSE
				t_network_where		:= t_network_where || ';';
			END IF;
	END CASE;

	t_network_clause	:= trim(t_network_select) || trim(t_network_from) || trim(t_network_where);

-- Create the statements that will drop the mview and recreate it
-- Create an INDEX to speed up processing

	IF nvl(t_network_clause,'-xx') <> '-xx' THEN
-- Drop Table
		t_procedure_line	:= 'DROP TABLE ' || t_network_mv_name || ';' || t_newline || t_newline;
		t_procedure_line_length := length(t_procedure_line);

		t_lob_length		:= dbms_lob.getlength(t_mview_creates);

		IF nvl(t_lob_length,1) = 1 THEN
			dbms_lob.write(t_mview_creates, t_procedure_line_length, 1, t_procedure_line);
		ELSE
			dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);
		END IF;
-- Create Table
		t_procedure_line	:= 'CREATE TABLE ' || t_network_mv_name || ' AS ' || t_newline;
		t_procedure_line_length := length(t_procedure_line);
		dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);

		t_procedure_line	:= t_network_clause || t_newline || t_newline;
		t_procedure_line_length := length(t_procedure_line);
		dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);

-- Create INDEX
		t_procedure_line	:= 'CREATE INDEX ' || t_network_mv_name || '_IDX ON ' || t_network_mv_name || '(NE_ID_OF);' || t_newline || t_newline;
		t_procedure_line_length := length(t_procedure_line);
		dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);

	END IF;
END;

PROCEDURE lp_create_target_table IS
BEGIN
	t_counter	:= 0;
	FOR c_target_cols IN cur_target_cols(t_table_id) LOOP
		t_target_db_table		:= c_target_cols.hp_db_table_name;
		t_target_col_name		:= c_target_cols.hcl_name;
		t_target_col_type		:= c_target_cols.hcl_type;
		t_target_col_size		:= c_target_cols.hcl_size;

		IF t_counter = 0 THEN
			t_procedure_line	:= 'DROP TABLE ' || t_target_db_table || ';' || t_newline || t_newline;
			t_procedure_line_length := length(t_procedure_line);
			t_lob_length		:= dbms_lob.getlength(t_table_creates);

			IF nvl(t_lob_length,1) = 1 THEN
				dbms_lob.write(t_table_creates, t_procedure_line_length, 1, t_procedure_line);
			ELSE
				dbms_lob.writeappend(t_table_creates, t_procedure_line_length, t_procedure_line);
			END IF;

			t_procedure_line	:= 'CREATE TABLE ' || t_target_db_table || t_newline;
			t_procedure_line_length := length(t_procedure_line);
			dbms_lob.writeappend(t_table_creates, t_procedure_line_length, t_procedure_line);

		END IF;

		IF t_counter = 0 THEN
			t_procedure_line	:= t_tab || '(' || t_target_col_name || ' ' || t_target_col_type;
		ELSE
			t_procedure_line	:= t_tab || ',' || t_target_col_name || ' ' || t_target_col_type;
		END IF;

		IF nvl(t_target_col_size,'-x') <> '-x' THEN
			t_procedure_line	:= t_procedure_line || '(' || t_target_col_size || ')' || t_newline;
		ELSE
			t_procedure_line	:= t_procedure_line || t_newline;
		END IF;

		t_procedure_line_length := length(t_procedure_line);
		dbms_lob.writeappend(t_table_creates, t_procedure_line_length, t_procedure_line);

		t_counter		:= t_counter + 1;
	END LOOP;

	t_procedure_line	:= t_tab || ');' || t_newline || t_newline;
	t_procedure_line_length := length(t_procedure_line);
	dbms_lob.writeappend(t_table_creates, t_procedure_line_length, t_procedure_line);
END;

PROCEDURE lp_build_aggregate_table IS

BEGIN
	t_template			:= NULL;
	t_template_line			:= NULL;
	t_template_read			:= 0;
	t_comma				:= NULL;
	t_output			:= NULL;
	t_mview_name			:= NULL;

	OPEN cur_route_restrict(t_table_id, t_data_item);
	FETCH cur_route_restrict INTO t_route_restrict;
	CLOSE cur_route_restrict;

	OPEN cur_get_min_hmid(t_table_id, t_data_item);
	FETCH cur_get_min_hmid INTO t_min_hm_id;
	CLOSE cur_get_min_hmid;

	OPEN cur_primary_item(t_min_hm_id);
	FETCH cur_primary_item INTO t_primary_name
		, t_primary_item
		, t_primary_value
		, t_primary_attribute
		, t_primary_where
		, t_primary_type
		, t_primary_function
		, t_primary_formula
		, t_primary_hdi_id
		, t_primary_join;
	CLOSE cur_primary_item;

	IF t_primary_type = 'ASSET' THEN
		t_table_name	:= 'v_nm_' || t_primary_item || '_nw';

		t_item_sql	:= 'SELECT max(nit_pnt_or_cont) pnt_cont ' ||
					' FROM ( ' ||
					    ' SELECT nit_pnt_or_cont ' ||
					    ' FROM nm_inv_types_all ' ||
					    ' WHERE nit_inv_type = ' || '''' || t_primary_item || '''' ||
					     'UNION ' ||
					     'SELECT ' || '''' || '-x' || '''' || ' nit_pnt_or_cont FROM DUAL)';

		EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;

		IF t_point_cont	= '-x' THEN
			t_item_sql	:= 'SELECT sum(nm_end_mp - nm_begin_mp) seg_length FROM ' || t_table_name ||
						' WHERE rownum < 10';
		
			EXECUTE IMMEDIATE t_item_sql INTO t_point_cont;

			IF t_point_cont = '0'THEN
				t_point_cont 	:= 'P';
			ELSE
				t_point_cont 	:= 'C';
			END IF;
		END IF;
	ELSE
		t_point_cont 	:= 'C';
	END IF;

	IF t_point_cont = 'P' THEN
		OPEN cur_template('AGGREGATE_POINT','TABLE');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;
	ELSE
		OPEN cur_template('AGGREGATE','TABLE');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;
	END IF;

	IF t_template IS NOT NULL THEN

		t_route_sql			:= NULL;
		IF t_point_cont = 'P' THEN
			t_route_sql			:= lf_generate_aggregate_table_pt;
		ELSE
			t_route_sql			:= lf_generate_aggregate_table;
		END IF;

		t_procedure_line_length		:= length(t_route_sql);
		t_procedure_line		:= t_route_sql;
		t_procedure_line_length		:= length(t_procedure_line);

		IF nvl(t_route_sql,'-x') <> '-x' THEN
			t_lob_length		:= dbms_lob.getlength(t_mview_creates);
			IF nvl(t_lob_length,1) = 1 THEN
				dbms_lob.write(t_mview_creates, t_procedure_line_length, 1, t_procedure_line);
			ELSE
				dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);
			END IF;
		END IF;
	END IF;
END;

PROCEDURE lp_build_aggregate_view IS

BEGIN
	t_output			:= NULL;

	t_route_sql			:= NULL;
	t_route_sql			:= lf_generate_aggregate_view;

	BEGIN
		OPEN cur_item_desc(t_table_id, t_data_item);
		FETCH cur_item_desc INTO t_item_desc;
		CLOSE cur_item_desc;

		OPEN cur_data_type(t_table_id, t_data_item);
		FETCH cur_data_type INTO t_target_col_name;
		CLOSE cur_data_type;

		t_item_sql		:= replace(t_route_sql,'CURSOR CUR_' || t_data_item || ' IS',' ');
		t_view			:= substr('V_OHMS_' || t_table_id || '_' || t_data_item || '_' || replace(t_item_desc,' ','_'),1,30);
		create_OHMS_view(t_item_sql, t_item_desc, t_table_id, t_data_item, t_view,'TEMP');

		t_rollup		:= NULL;

		OPEN cur_rollup(t_table_id, t_data_item);
		FETCH cur_rollup INTO t_rollup;
		CLOSE cur_rollup;

		IF t_rollup = 'N' THEN
			t_route_sql		:= results_rollup(t_view,'NO_ROLLUP', t_table_id, t_data_item);
		ELSE
			t_route_sql		:= results_rollup(t_view,'ROLLUP', t_table_id, t_data_item);
		END IF;

		t_item_sql			:= replace(t_route_sql,'CURSOR CUR_' || t_data_item || ' IS',' ');
		t_view				:= substr('V_OHMS_FINAL_' || t_table_id || '_' || t_data_item || '_' || replace(t_item_desc,' ','_'),1,30);
		create_OHMS_view(t_item_sql, t_item_desc, t_table_id, t_data_item, t_view, 'FINAL');
		t_route_sql			:= 'CURSOR CUR_' || t_data_item || ' IS ' || chr(10) || 
								'SELECT * FROM ' || t_view|| ';' || chr(10) || chr(10);
		t_procedure_line_length		:= length(t_route_sql);
		t_procedure_line		:= t_route_sql;
		t_procedure_line_length		:= length(t_procedure_line);
		dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

	EXCEPTION WHEN OTHERS THEN
		NULL;
	END;
END;

PROCEDURE lp_build_primary_route IS
BEGIN
	t_route_sql			:= NULL;
	t_route_sql			:= lf_generate_prte_view ;
	t_primary_route			:= NULL;

	OPEN cur_prte_output(1);
	FETCH cur_prte_output INTO t_primary_route;
	CLOSE cur_prte_output;

	dbms_lob.trim(t_primary_route,1);

	t_procedure_line_length		:= length(t_route_sql);
	t_procedure_line		:= t_route_sql;
	t_procedure_line_length		:= length(t_procedure_line);
	dbms_lob.write(t_primary_route, t_procedure_line_length, 1, t_procedure_line);

	COMMIT;
END;

PROCEDURE lp_build_view(lp_type IN VARCHAR2) IS

t_view_type		VARCHAR2(20);

BEGIN
	t_template			:= NULL;
	t_template_line			:= NULL;
	t_template_read			:= 0;
	t_comma				:= NULL;
	t_output			:= NULL;
	t_view_type			:= lp_type;

	IF t_view_type = 'SIMPLE' THEN
		OPEN cur_template('SIMPLE','VIEW');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;

	ELSIF t_view_type = 'SUBVIEW' THEN
		OPEN cur_template('SUBVIEW','VIEW');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;

	ELSIF t_view_type = 'AGGREGATE' THEN
		OPEN cur_template('AGGREGATE','VIEW');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;
	END IF;

	IF t_template IS NOT NULL THEN

		t_route_sql			:= NULL;

		IF t_view_type = 'SIMPLE' THEN
			t_route_sql			:= lf_generate_simple_view;

		ELSIF t_view_type = 'SUBVIEW' THEN
			t_route_sql			:= lf_generate_subview_view;

		ELSIF t_view_type = 'AGGREGATE' THEN
			t_route_sql			:= lf_generate_aggregate_view;

		END IF;


		IF t_table_id = 3 THEN
			t_procedure_line_length			:= length(t_route_sql);
			t_procedure_line			:= t_route_sql;
			t_procedure_line_length			:= length(t_procedure_line);
			dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
		END IF;

		BEGIN
			OPEN cur_item_desc(t_table_id, t_data_item);
			FETCH cur_item_desc INTO t_item_desc;
			CLOSE cur_item_desc;

			OPEN cur_data_type(t_table_id, t_data_item);
			FETCH cur_data_type INTO t_target_col_name;
			CLOSE cur_data_type;

			t_item_sql		:= replace(t_route_sql,'CURSOR CUR_' || t_data_item || ' IS',' ');
			t_view			:= substr('V_OHMS_' || t_table_id || '_' || t_data_item || '_' || replace(t_item_desc,' ','_'),1,30);
			create_OHMS_view(t_item_sql, t_item_desc, t_table_id, t_data_item, t_view,'TEMP');

			IF t_table_id NOT IN (3) THEN
				t_rollup		:= NULL;
--xxx
				OPEN cur_rollup(t_table_id, t_data_item);
				FETCH cur_rollup INTO t_rollup;
				CLOSE cur_rollup;

				IF t_rollup = 'N' THEN
					t_route_sql		:= results_rollup(t_view,'NO_ROLLUP', t_table_id, t_data_item);
				ELSIF t_view_type = 'SIMPLE' OR t_view_type = 'SUBVIEW' OR t_view_type = 'AGGREGATE' THEN
					t_route_sql		:= results_rollup(t_view,'ROLLUP', t_table_id, t_data_item);
--				ELSIF t_view_type = 'SUBVIEW' THEN
--					t_route_sql		:= results_rollup(t_view,'NO_ROLLUP', t_table_id, t_data_item);	
				END IF;

				t_item_sql			:= replace(t_route_sql,'CURSOR CUR_' || t_data_item || ' IS',' ');
				t_view				:= substr('V_OHMS_FINAL_' || t_table_id || '_' || t_data_item || '_' || replace(t_item_desc,' ','_'),1,30);
				create_OHMS_view(t_item_sql, t_item_desc, t_table_id, t_data_item, t_view, 'FINAL');
				t_route_sql			:= 'CURSOR CUR_' || t_data_item || ' IS ' || chr(10) || 
										'SELECT * FROM ' || t_view|| ';' || chr(10) || chr(10);
				t_procedure_line_length		:= length(t_route_sql);
				t_procedure_line		:= t_route_sql;
				t_procedure_line_length		:= length(t_procedure_line);
				dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
			END IF;
		EXCEPTION WHEN OTHERS THEN
			NULL;
		END;
	END IF;
END;


PROCEDURE lp_build_outerjoin_table IS

BEGIN
	FOR c_outerjoin IN cur_outerjoins(t_table_id, t_data_item) LOOP
		t_min_hm_id			:= c_outerjoin.hm_id;
	
		t_template			:= NULL;
		t_template_line			:= NULL;
		t_template_read			:= 0;
		t_comma				:= NULL;
		t_output			:= NULL;
		t_mview_name			:= NULL;

		OPEN cur_template('OUTERJOIN','TABLE');
		FETCH cur_template INTO t_template;
		CLOSE cur_template;

		IF t_template IS NOT NULL THEN

			t_route_sql			:= NULL;
			t_route_sql			:= lf_generate_outerjoin_table;

			t_procedure_line_length		:= length(t_route_sql);
			t_procedure_line		:= t_route_sql;
			t_procedure_line_length		:= length(t_procedure_line);

			IF nvl(t_route_sql,'-x') <> '-x' THEN
				t_lob_length		:= dbms_lob.getlength(t_mview_creates);
				IF nvl(t_lob_length,1) = 1 THEN
					dbms_lob.write(t_mview_creates, t_procedure_line_length, 1, t_procedure_line);
				ELSE
					dbms_lob.writeappend(t_mview_creates, t_procedure_line_length, t_procedure_line);
				END IF;
			END IF;
		END IF;
	END LOOP;
END;

PROCEDURE lp_build_shape_view IS
BEGIN
	t_template			:= NULL;
	t_template_line			:= NULL;
	t_template_read			:= 0;
	t_comma				:= NULL;
	t_output			:= NULL;

	OPEN cur_template('SHAPE','VIEW');
	FETCH cur_template INTO t_template;
	CLOSE cur_template;

	IF t_template IS NOT NULL THEN

		t_route_sql			:= NULL;
		t_route_sql			:= lf_generate_shape_view;

		t_procedure_line_length		:= length(t_route_sql);
		t_procedure_line		:= t_route_sql;
		t_procedure_line_length		:= length(t_procedure_line);
		dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
	END IF;
END;

PROCEDURE lp_begin_procedure_write IS
t_cr	VARCHAR2(1)	:= chr(13);
BEGIN

-- Fetch the template for the procedure's header

	t_template			:= NULL;
	t_template_line			:= NULL;
	t_template_read			:= 0;

	OPEN cur_template('HEADER','PROCEDURE');
	FETCH cur_template INTO t_template;
	CLOSE cur_template;

	SELECT user, systimestamp 
	INTO t_generation_user, t_generation_time 
	FROM DUAL;

	IF t_template IS NOT NULL THEN

		t_template_length		:= dbms_lob.getlength(t_template);
		t_template_read			:= 100;
		t_template_start		:= 1;
		t_template_return_count		:= 1;
		t_template_return_pos		:= 0;

		t_sub_start			:= 0;
		t_sub_return_count		:= 0;

		WHILE t_template_return_pos IS NOT NULL LOOP
			BEGIN
				t_template_return_pos		:= dbms_lob.instr(t_template, t_cr, 1, t_template_return_count);

				t_template_return_pos		:= dbms_lob.instr(t_template, t_newline, 1, t_template_return_count);

				IF nvl(t_template_return_pos,-5) NOT IN (-5,0) THEN
					t_template_read			:= t_template_return_pos - t_template_start;

					IF t_template_read > 0 THEN
						dbms_lob.read(t_template, t_template_read, t_template_start, t_template_line);
						t_whitespace			:= rpad(' ',length(t_template_line) - length(ltrim(t_template_line)),' ');
					ELSE
						t_template_line		:= chr(10);
						t_whitespace		:= ' ';
					END IF;

					t_template_start		:= t_template_return_pos + 1;

					IF instr(t_template_line,'<<table code>>') > 0 THEN
						t_template_line			:= replace(t_template_line,'<<table code>>',t_table_id);
		
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;

						t_lob_length			:= dbms_lob.getlength(t_procedure);

						IF instr(t_procedure_line,'CREATE OR REPLACE PROCEDURE') > 0 THEN
							dbms_lob.write(t_procedure, t_procedure_line_length, 1, t_procedure_line);
						ELSE
							dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
						END IF;
					ELSIF instr(t_template_line,'<<generation time>>') > 0 THEN
						t_template_line			:= replace(t_template_line,'<<generation time>>',t_generation_time);
		
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;

						t_lob_length			:= dbms_lob.getlength(t_procedure);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);

					ELSIF instr(t_template_line,'<<generation user>>') > 0 THEN
						t_template_line			:= replace(t_template_line,'<<generation user>>',t_generation_user);
		
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;

						t_lob_length			:= dbms_lob.getlength(t_procedure);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
					ELSE
						t_template_line			:= t_template_line || t_newline;
						t_procedure_line_length		:= length(t_template_line);
						t_procedure_line		:= t_template_line;
						t_procedure_line_length		:= length(t_procedure_line);
						dbms_lob.writeappend(t_procedure, t_procedure_line_length, t_procedure_line);
					END IF;

					t_template_return_count		:= t_template_return_count + 1;
				ELSE
					EXIT;
				END IF;
			END;
		END LOOP;
	END IF;
END;

PROCEDURE CREATE_OBJECTS(p_table_id IN NUMBER DEFAULT 1) IS

t_cursor		NUMBER;

t_clob          	CLOB;
t_clob_length		INTEGER;
t_clob_counter		NUMBER(8,2);
t_start			INTEGER;
t_remaining		INTEGER;

t_line			VARCHAR2(8000);
t_semicolon_count	NUMBER;
t_semicolon_pos		NUMBER;
t_name_pos		NUMBER;
t_as_pos		NUMBER;
t_action		VARCHAR2(20);
t_status		VARCHAR2(10);

t_count			INTEGER;
t_boolean		BOOLEAN	:= FALSE;
t_mview_name		VARCHAR2(200);
t_read			NUMBER;

t_table_id		NUMBER;

t_error_count		NUMBER;
t_error_line		NUMBER;
t_error_text		VARCHAR2(4000);

t_hal_id		OHMS_ACTIVITY_LOG.HAL_ID%TYPE;
t_hal_date		OHMS_ACTIVITY_LOG.HAL_DATE%TYPE;
t_hal_user		OHMS_ACTIVITY_LOG.HAL_USER%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_ITEM%TYPE;
t_hal_table_id		OHMS_ACTIVITY_LOG.HAL_TABLE_ID%TYPE;
t_hal_error		OHMS_ACTIVITY_LOG.HAL_ERROR%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_MESSAGE%TYPE;

CURSOR cur_procedure(cp_table_id IN NUMBER) IS
	SELECT hp_mview_creates
	FROM OHMS_procedure
	WHERE hp_ht_id = cp_table_id;

CURSOR cur_errors(cp_proc_name IN VARCHAR2) IS
	SELECT *
	FROM sys.user_errors
	WHERE name = cp_proc_name
		AND type = 'VIEW'
		AND attribute = 'ERROR';

BEGIN
	t_clob			:= NULL;
	t_clob_length		:= 0;
	t_table_id		:= p_table_id;
	t_action		:= NULL;
	t_status		:= NULL;

      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	OPEN cur_procedure(t_table_id);
	FETCH cur_procedure INTO t_clob;
	CLOSE cur_procedure;

	t_clob_length		:= dbms_lob.getlength(t_clob);

	t_read			:= 1000;
	t_start			:= 1;
	t_semicolon_count	:= 1;
	t_semicolon_pos		:= 0;
	t_line			:= NULL;
	t_mview_name		:= NULL;

	WHILE t_semicolon_pos IS NOT NULL LOOP
		t_semicolon_pos		:= dbms_lob.instr(t_clob, ';', 1, t_semicolon_count);
		t_mview_name		:= NULL;

		IF nvl(t_semicolon_pos,-5) NOT IN (-5,0) THEN
			t_read		:= t_semicolon_pos - t_start;

			dbms_lob.read(t_clob, t_read, t_start, t_line);

			t_start		:= t_start + t_read + 1;

			t_name_pos	:= instr(t_line,'CREATE TABLE',1,1);
			t_as_pos	:= instr(t_line,' AS',1,1);

			IF instr(t_line,'CREATE TABLE',1,1) > 0 THEN
				t_mview_name 	:= upper(substr(t_line,t_name_pos + 13, t_as_pos - (t_name_pos + 13)));
				t_action	:= 'CREATE TABLE';
			ELSIF instr(t_line,'CREATE INDEX',1,1) > 0 THEN

				t_name_pos	:= instr(t_line,'CREATE INDEX',1,1);
				t_mview_name 	:= upper(substr(t_line,t_name_pos + 13, t_as_pos - (t_name_pos + 13)));
				t_action	:= 'CREATE INDEX ON';
			ELSIF instr(t_line,'DROP INDEX',1,1) > 0 THEN

				t_name_pos	:= instr(t_line,'DROP INDEX',1,1);
				t_mview_name 	:= upper(substr(t_line,t_name_pos + 11));
				t_action	:= 'DROP INDEX';
			ELSE
				t_name_pos	:= instr(t_line,'DROP TABLE',1,1);
				t_mview_name 	:= upper(substr(t_line,t_name_pos + 11));
				t_action	:= 'DROP TABLE';
			END IF;

			BEGIN
				t_cursor	:= DBMS_SQL.OPEN_CURSOR;
				t_line		:= trim(t_line);

				DBMS_SQL.PARSE(t_cursor, t_line, 2);

				IF DBMS_SQL.IS_OPEN(t_cursor) THEN
					DBMS_SQL.CLOSE_CURSOR(t_cursor);
				END IF;

				t_status		:= 'SUCCESS';
			        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
			      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

				INSERT INTO OHMS_ACTIVITY_LOG
				(
					hal_id
					, hal_date
					, hal_user
					, hal_item
					, hal_table_id
					, hal_status
					, hal_error
				)
				VALUES
				(
					t_hal_id
					, t_hal_date
					, t_hal_user
					, t_mview_name
					, t_table_id
					, t_status
					, t_action
				);
				COMMIT;

			EXCEPTION WHEN OTHERS THEN

				IF DBMS_SQL.IS_OPEN(t_cursor) THEN
					DBMS_SQL.CLOSE_CURSOR(t_cursor);
				END IF;

				t_error_line		:= sqlcode;
				t_error_text		:= t_error_line || ' -- ' || substr(sqlerrm,1,200) || t_newline || t_newline || substr(t_line,1,3500);
				t_status		:= NULL;

				IF t_action IN ('DROP TABLE','DROP INDEX') THEN
					t_status		:= 'SUCCESS';
				ELSE
					t_status		:= 'ERROR';

				        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
				      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

					INSERT INTO OHMS_ACTIVITY_LOG
					(
						hal_id
						, hal_date
						, hal_user
						, hal_item
						, hal_table_id
						, hal_status
						, hal_error
						, hal_message
					)
					VALUES
					(
						t_hal_id
						, t_hal_date
						, t_hal_user
						, t_mview_name
						, t_table_id
						, t_status
						, t_action
						, t_error_text
					);
					COMMIT;
				END IF;
			END;

		ELSE
			EXIT;
		END IF;

		t_semicolon_count	:= t_semicolon_count + 1;

	END LOOP;

EXCEPTION WHEN OTHERS THEN
	IF DBMS_SQL.IS_OPEN(t_cursor) THEN
		DBMS_SQL.CLOSE_CURSOR(t_cursor);
	END IF;
        --t_error_text		:= sqlcode || ' - ' || substr(sqlerrm,1,400);
	t_error_text		:= substr(sqlerrm,1,200) || t_newline || t_newline || substr(t_line,1,3500);

        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	INSERT INTO OHMS_ACTIVITY_LOG
	(
		hal_id
		, hal_date
		, hal_user
		, hal_item
		, hal_table_id
		, hal_status
		, hal_error
		, hal_message
	)
	VALUES
	(
		t_hal_id
		, t_hal_date
		, t_hal_user
		, t_mview_name
		, t_table_id
		, 'ERROR'
		, t_action
		, 'MVIEW Action Aborted: ' || t_error_text
	);
	COMMIT;

END;

PROCEDURE COMPILE_PROC(p_table_id IN NUMBER DEFAULT 1) IS

t_cursor		NUMBER;

t_clob          	CLOB;
t_clob_length		INTEGER;
t_clob_counter		NUMBER(8,2);
t_start			INTEGER;
t_remaining		INTEGER;

t_procedure     	DBMS_SQL.VARCHAR2A;
t_index			INTEGER;
t_count			INTEGER;
t_test			VARCHAR2(100);
t_boolean		BOOLEAN	:= FALSE;
t_procedure_name	VARCHAR2(32);

t_table_id		NUMBER;

t_error_count		NUMBER;
t_error_line		NUMBER;
t_error_text		VARCHAR2(4000);

t_hal_id		OHMS_ACTIVITY_LOG.HAL_ID%TYPE;
t_hal_date		OHMS_ACTIVITY_LOG.HAL_DATE%TYPE;
t_hal_user		OHMS_ACTIVITY_LOG.HAL_USER%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_ITEM%TYPE;
t_hal_table_id		OHMS_ACTIVITY_LOG.HAL_TABLE_ID%TYPE;
t_hal_error		OHMS_ACTIVITY_LOG.HAL_ERROR%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_MESSAGE%TYPE;

CURSOR cur_procedure(cp_table_id IN NUMBER) IS
	SELECT hp_procedure
	FROM OHMS_procedure
	WHERE hp_ht_id = cp_table_id;

CURSOR cur_errors(cp_proc_name IN VARCHAR2) IS
	SELECT *
	FROM sys.user_errors
	WHERE name = cp_proc_name
		AND type = 'PROCEDURE'
		AND attribute = 'ERROR';

BEGIN
	t_clob			:= NULL;
	t_clob_length		:= 0;
	t_table_id		:= p_table_id;

      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	OPEN cur_procedure(t_table_id);
	FETCH cur_procedure INTO t_clob;
	CLOSE cur_procedure;

	t_clob_length		:= dbms_lob.getlength(t_clob);

	IF t_clob_length > 100 THEN
		t_cursor		:= DBMS_SQL.OPEN_CURSOR;
		t_clob_counter		:= t_clob_length/32767;

		IF (t_clob_length/32767) - trunc(t_clob_length/32767) > 0 THEN
			t_clob_counter	:= trunc(t_clob_counter) + 1;
		ELSE
			t_clob_counter	:= trunc(t_clob_counter);
		END IF;

		t_start			:= 1;
		FOR t_index in 0..t_clob_counter LOOP

			t_remaining				:= t_clob_length - t_start + 1;
			IF t_remaining < 32768 THEN
				t_procedure(t_index)		:= replace(substr(t_clob, t_start),chr(13),chr(10));
			ELSE
				t_procedure(t_index)		:= replace(substr(t_clob, t_start, 32767),chr(13),chr(10));
			END IF;

			t_start					:= t_start + 32767;

		END LOOP;

		DBMS_SQL.PARSE(t_cursor,t_procedure, 0, t_clob_counter, t_boolean, 2);

		IF DBMS_SQL.IS_OPEN(t_cursor) THEN
			DBMS_SQL.CLOSE_CURSOR(t_cursor);
		END IF;

		t_procedure_name		:= 'XNA_OHMS_POPULATE_'|| t_table_id;
		t_error_count			:= 0;

		FOR c_errors IN cur_errors(t_procedure_name) LOOP
			t_error_count		:= t_error_count + 1;
			t_error_line		:= c_errors.line;
			t_error_text		:= c_errors.text;

		        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
		      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

			INSERT INTO OHMS_ACTIVITY_LOG
			(
				hal_id
				, hal_date
				, hal_user
				, hal_item
				, hal_table_id
				, hal_status
				, hal_error
				, hal_message
			)
			VALUES
			(
				t_hal_id
				, t_hal_date
				, t_hal_user
				, t_procedure_name
				, t_table_id
				, 'ERROR'
				, 'COMPILE'
				, 'Error on line: ' || t_error_line || '; ' || t_error_text
			);
			COMMIT;
		END LOOP;

		IF t_error_count = 0 THEN
		        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
		      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

			INSERT INTO OHMS_ACTIVITY_LOG
			(
				hal_id
				, hal_date
				, hal_user
				, hal_item
				, hal_table_id
				, hal_status
				, hal_error
			)
			VALUES
			(
				t_hal_id
				, t_hal_date
				, t_hal_user
				, t_procedure_name
				, t_table_id
				, 'SUCCESS'
				, 'COMPILE'
			);
			COMMIT;
		END IF;
	END IF;


EXCEPTION WHEN OTHERS THEN
	IF DBMS_SQL.IS_OPEN(t_cursor) THEN
		DBMS_SQL.CLOSE_CURSOR(t_cursor);
	END IF;
        t_error_text		:= sqlcode || ' - ' || substr(sqlerrm,1,400);

        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	INSERT INTO OHMS_ACTIVITY_LOG
	(
		hal_id
		, hal_date
		, hal_user
		, hal_item
		, hal_table_id
		, hal_status
		, hal_error
		, hal_message
	)
	VALUES
	(
		t_hal_id
		, t_hal_date
		, t_hal_user
		, t_procedure_name
		, t_table_id
		, 'ERROR'
		, 'COMPILE'
		, 'Aborted: ' || t_error_text
	);
	COMMIT;
END;


PROCEDURE CREATE_OHMS_VIEW(p_sql IN VARCHAR2
				, p_desc IN VARCHAR2
				, p_table_id IN NUMBER DEFAULT 1
				, p_item_id IN NUMBER DEFAULT 0
				, p_view IN VARCHAR2 DEFAULT 'V_OHMS_XXX'
				, p_view_version IN VARCHAR2 DEFAULT 'TEMP') IS
PRAGMA AUTONOMOUS_TRANSACTION;

t_sql	          	VARCHAR2(32000);
t_desc			VARCHAR2(100);
t_table_id		NUMBER;
t_item_id		NUMBER;

t_cursor		NUMBER;
t_view_log		VARCHAR2(200);
t_view_name		VARCHAR2(32);

t_action		VARCHAR2(100);
t_status		VARCHAR2(10);

t_error_count		NUMBER;
t_error_line		NUMBER;
t_error_text		VARCHAR2(4000);

t_hal_id		OHMS_ACTIVITY_LOG.HAL_ID%TYPE;
t_hal_date		OHMS_ACTIVITY_LOG.HAL_DATE%TYPE;
t_hal_user		OHMS_ACTIVITY_LOG.HAL_USER%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_ITEM%TYPE;
t_hal_table_id		OHMS_ACTIVITY_LOG.HAL_TABLE_ID%TYPE;
t_hal_error		OHMS_ACTIVITY_LOG.HAL_ERROR%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_MESSAGE%TYPE;

t_select_pos		NUMBER;
t_version		VARCHAR2(10);

is_complete 		EXCEPTION;

BEGIN
	t_sql			:= trim(p_sql);
	t_desc			:= trim(p_desc);
	t_table_id		:= p_table_id;
	t_item_id		:= p_item_id;
	t_version		:= p_view_version;

	t_status		:= NULL;
	t_view_log		:= 'Table ' || t_table_id || ' Item; ' || t_item_id ||
					' - ' || t_desc;
	t_view_name		:= p_view;

      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	t_sql			:= replace(t_sql,chr(13),chr(10));
	t_sql			:= replace(t_sql,';',' ');
	t_sql			:= 'CREATE OR REPLACE VIEW ' || t_view_name || ' AS ' || trim(t_sql);

	IF t_version = 'TEMP' THEN
	 	t_select_pos	:= instr(t_sql,'SELECT') + 6;
 		t_sql			:= substr(t_sql,1,t_select_pos) || ' ' || substr(t_sql,t_select_pos);
		t_action		:= 'VALIDATE DETAIL VIEW';
	ELSE
		t_action		:= 'VALIDATE FINAL VIEW';
	END IF;
 
	BEGIN
		t_cursor	:= DBMS_SQL.OPEN_CURSOR;
		DBMS_SQL.PARSE(t_cursor, t_sql, 2);

		IF DBMS_SQL.IS_OPEN(t_cursor) THEN
			DBMS_SQL.CLOSE_CURSOR(t_cursor);
		END IF;

		t_status		:= 'SUCCESS';

		IF t_global_log = 'YES' THEN
		      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

		        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
			INSERT INTO OHMS_ACTIVITY_LOG
			(
				hal_id
				, hal_date
				, hal_user
				, hal_item
				, hal_table_id
				, hal_status
				, hal_error
			)
			VALUES
			(
				t_hal_id
				, t_hal_date
				, t_hal_user
				, t_view_name
				, t_table_id
				, t_status
				, t_action
			);
		END IF;

	EXCEPTION WHEN OTHERS THEN
		IF DBMS_SQL.IS_OPEN(t_cursor) THEN
			DBMS_SQL.CLOSE_CURSOR(t_cursor);
		END IF;

		t_error_line			:= sqlcode;
		t_error_text			:= DBMS_UTILITY.FORMAT_ERROR_STACK || t_newline || t_newline || t_sql;
		t_status			:= 'ERROR';


		IF t_global_log = 'YES' THEN
		      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

		        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
			INSERT INTO OHMS_ACTIVITY_LOG
			(
				hal_id
				, hal_date
				, hal_user
				, hal_item
				, hal_table_id
				, hal_status
				, hal_error
				, hal_message
			)
			VALUES
			(
				t_hal_id
				, t_hal_date
				, t_hal_user
				, t_view_name
				, t_table_id
				, t_status
				, t_action
				, t_error_text
			);
		END IF;
	END;
	COMMIT;
EXCEPTION WHEN OTHERS THEN
	IF DBMS_SQL.IS_OPEN(t_cursor) THEN
		DBMS_SQL.CLOSE_CURSOR(t_cursor);
	END IF;
        t_error_text		:= sqlcode || ' - ' || substr(sqlerrm,1,400);

	IF t_global_log = 'YES' THEN	
	      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
		INSERT INTO OHMS_ACTIVITY_LOG
		(
			hal_id
			, hal_date
			, hal_user
			, hal_item
			, hal_table_id
			, hal_status
			, hal_error
			, hal_message
		)
		VALUES
		(
			t_hal_id
			, t_hal_date
			, t_hal_user
			, t_view_name
			, t_table_id
			, 'ERROR'
			, 'CURSOR'
			, 'Aborted: ' || t_error_text
		);
	END IF;
	COMMIT;
END;

PROCEDURE clear_activity_log IS

BEGIN
	DELETE FROM OHMS_ACTIVITY_LOG;
	COMMIT;

    raise_application_error( -20000,'Activity Log cleared.');

END;

PROCEDURE OHMS_params IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'OHMS_EX';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

   l_tab_value  nm3type.tab_varchar30;
   l_tab_prompt nm3type.tab_varchar30;
   l_checked    varchar2(8) := ' CHECKED';

BEGIN

  l_tab_value(1)  := 'HPMS1';
  l_tab_prompt(1) := 'HPMS SUBMIT_SECTIONS';
  l_tab_value(2)  := 'HPMS2';
  l_tab_prompt(2) := 'HPMS SUBMIT_SAMPLE_SECTIONS';
  l_tab_value(3)  := 'ACTIVITY_LOG';
  l_tab_prompt(3) := 'Activity Log';

  nm3web.head(p_close_head => TRUE, p_title      => c_module_title);
  htp.bodyopen;

  nm3web.module_startup(c_this_module);

  htp.p('<DIV ALIGN="CENTER">');
  htp.header(nsize   => 1
            ,cheader => c_module_title
            ,calign  => 'center');
  htp.tableopen(calign => 'center');
  htp.formopen(curl => g_package_name || '.OHMS_report');

  htp.p('<TR>');
  htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
  htp.p('</TR>');
  htp.p('<TR>');
  htp.p('<TD COLSPAN=2 ALIGN=CENTER>');
  htp.tableopen;
  htp.tablerowopen;
  htp.tableheader('Select Report Type', cattributes=>'COLSPAN=2');
  htp.tablerowclose;

  FOR i IN 1..l_tab_value.COUNT LOOP
         htp.tablerowopen(cattributes=>'ALIGN=CENTER');
         htp.tabledata(l_tab_prompt(i));
         htp.p('<TD><INPUT TYPE=RADIO NAME="pi_report_type" VALUE="'||l_tab_value(i)||'"'||l_checked||'></TD>');
         l_checked := NULL;
         htp.tablerowclose;
  END LOOP;
  htp.tableclose;

  htp.p('</TD>');
  htp.p('<TR>');
  htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
  htp.p('</TR>');
  htp.p('<TR>');

  htp.tablerowopen(calign=> 'center');
  htp.p('<TD colspan="2">');
  htp.formsubmit(cvalue => 'Continue');
  htp.p('</TD>');
  htp.tablerowclose;

  htp.formclose;
  htp.tableclose;

  nm3web.CLOSE;

EXCEPTION
	WHEN nm3web.g_you_should_not_be_here THEN
    		raise;
	WHEN others THEN
    		nm3web.failure(pi_error => SQLERRM);

END OHMS_params;

PROCEDURE OHMS_report(pi_report_type varchar2) IS

c_this_module  		CONSTANT hig_modules.hmo_module%TYPE := 'OHMS_EX';
c_module_title 		CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

c_nl 				varchar2(1) := CHR(10);
l_qry 			nm3type.max_varchar2;

i 				number:=0;

v_clob clob;
v_tmp_clob clob;

l_rec_nuf               nm_upload_files%ROWTYPE;
c_mime_type    		CONSTANT varchar2(30) := 'application/HPMS/HERS';
c_sysdate      		CONSTANT date         := SYSDATE;
c_content_type 		CONSTANT varchar2(4)  := 'BLOB';
c_dad_charset  		CONSTANT varchar2(5)  := 'ascii';
header_row          varchar(500);

l_tab             	nm3type.tab_varchar32767;

BEGIN
	nm3web.head(p_close_head => TRUE, p_title      => c_module_title);
	htp.bodyopen;
	nm3web.module_startup(pi_module => c_this_module);

  	l_rec_nuf.mime_type              := c_mime_type;
  	l_rec_nuf.dad_charset            := c_dad_charset;
  	l_rec_nuf.last_updated           := c_sysdate;
  	l_rec_nuf.content_type           := c_content_type;
  	l_rec_nuf.doc_size               := 0;

  	if pi_report_type='HPMS1' then
    		l_rec_nuf.name     := 'OHMS_SECTIONS_'||to_char(sysdate,'DD-MON-YYYY_HH24_MI_SS')||'.csv';
            
            -- put in the header row.
            
            select 'YEAR_RECORD'
                    || '|' || 'STATE_CODE'
                    || '|' || 'ROUTE_ID'
                    || '|' || 'BEGIN_POINT'
                    || '|' || 'END_POINT'
                    || '|' || 'DATA_ITEM'
                    || '|' || 'SECTION_LENGTH'
                    || '|' || 'VALUE_NUMERIC'
                    || '|' || 'VALUE_TEXT'
                    || '|' || 'VALUE_DATE'
                    || '|' || 'COMMENTS' into header_row from dual;
                    
               l_tab(l_tab.count+1)    := header_row ||chr(10);
               l_rec_nuf.doc_size      := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
                    
                    

    		for c1rec in (SELECT
					YEAR_RECORD
					|| '|' || STATE_CODE
					|| '|' || ROUTE_ID
					|| '|' || BEGIN_POINT
					|| '|' || END_POINT
					|| '|' || DATA_ITEM
					|| '|' || SECTION_LENGTH
					|| '|' || VALUE_NUMERIC
					|| '|' || VALUE_TEXT
					|| '|' || VALUE_DATE
					|| '|' || COMMENTS v_row
				FROM OHMS_SUBMIT_SECTIONS) LOOP
       		l_tab(l_tab.count+1)	:= c1rec.v_row ||chr(10);
       		l_rec_nuf.doc_size  	:= l_rec_nuf.doc_size+length(l_tab(l_tab.count));
    		end loop;
  	elsif pi_report_type='HPMS2' then
    		l_rec_nuf.name     := 'OHMS_SAMPLES_'||to_char(sysdate,'DD-MON-YYYY_HH24_MI_SS')||'.csv';
            
            select 'YEAR_RECORD'
                    || '|' || 'STATE_CODE'
                    || '|' || 'ROUTE_ID'
                    || '|' || 'BEGIN_POINT'
                    || '|' || 'END_POINT'
                    || '|' || 'SECTION_LENGTH'
                    || '|' || 'SAMPLE_ID' into header_row from dual;
                    
               l_tab(l_tab.count+1)    := header_row ||chr(10);
               l_rec_nuf.doc_size      := l_rec_nuf.doc_size+length(l_tab(l_tab.count));

    		for c1rec in (SELECT
					YEAR_RECORD
					|| '|' || STATE_CODE
					|| '|' || ROUTE_ID
					|| '|' || BEGIN_POINT
					|| '|' || END_POINT
					|| '|' || SECTION_LENGTH
					|| '|' || SAMPLE_ID v_row
				FROM OHMS_SUBMIT_SAMPLES) LOOP
       		l_tab(l_tab.count+1)	:= c1rec.v_row ||chr(10);
       		l_rec_nuf.doc_size  	:= l_rec_nuf.doc_size+length(l_tab(l_tab.count));
    		end loop;

  	elsif pi_report_type='HPMS3' then
		NULL;
/*
    		l_rec_nuf.name     := 'OHMS_'||to_char(sysdate,'DD-MON-YYYY_HH24_MI_SS')||'.csv';

    		for c1rec in (SELECT
					YEAR_RECORD
					|| '|' || STATE_CODE
					|| '|' || ROUTE_ID
					|| '|' || SHAPE v_row
				FROM OHMS_ROUTE_SHAPES) LOOP
       		l_tab(l_tab.count+1)	:= c1rec.v_row ||chr(10);
       		l_rec_nuf.doc_size  	:= l_rec_nuf.doc_size+length(l_tab(l_tab.count));
    		end loop;
*/
	elsif  pi_report_type='ACTIVITY_LOG' then
     		l_rec_nuf.name    := 'OHMS_ACTLOG_'||to_char(sysdate,'DD-MON-YYYY_HH24_MI_SS')||'.csv';
    		for c1rec in (SELECT
					HAL_ID
					|| '|' || HAL_DATE
					|| '|' || HAL_USER
					|| '|' || HAL_ITEM
					|| '|' || HAL_TABLE_ID
					|| '|' || HAL_STATUS
					|| '|' || HAL_MESSAGE
					|| '|' || HAL_ERROR v_row
				FROM OHMS_ACTIVITY_LOG ORDER BY HAL_ID DESC) LOOP
      		l_tab(l_tab.count+1):=c1rec.v_row ||chr(10);
      		l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
     		end loop;
  	end if;

	IF nvl(l_rec_nuf.name,'-x') <> '-x' THEN
		--l_rec_nuf.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));

         for a in  1 .. l_tab.count
        loop

            v_tmp_clob :=   l_tab(a);

            v_clob := v_clob || v_tmp_clob;

        end loop;



             l_rec_nuf.blob_content           := nm3clob.clob_to_blob(v_clob);



	      delete from nm_upload_files where name= l_rec_nuf.name;

		nm3ins.ins_nuf (l_rec_nuf);
		COMMIT;

		htp.p('  Click <a href=docs/'||l_rec_nuf.name ||'> HERE </a> to download and save ' || l_rec_nuf.name);
	END IF;

	nm3web.CLOSE;

EXCEPTION WHEN OTHERS THEN
    nm3web.failure(pi_error => SQLERRM);

END OHMS_report;

PROCEDURE table_validate(p_table_id IN NUMBER DEFAULT 1) IS

t_sql	          	VARCHAR2(32000);
t_desc			VARCHAR2(100);
t_table_id		NUMBER;

t_cursor		NUMBER;
t_view_name		VARCHAR2(200);

t_action		VARCHAR2(10);
t_status		VARCHAR2(10);

t_error_count		NUMBER;
t_error_line		NUMBER;
t_error_text		VARCHAR2(4000);

t_hal_id		OHMS_ACTIVITY_LOG.HAL_ID%TYPE;
t_hal_date		OHMS_ACTIVITY_LOG.HAL_DATE%TYPE;
t_hal_user		OHMS_ACTIVITY_LOG.HAL_USER%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_ITEM%TYPE;
t_hal_table_id		OHMS_ACTIVITY_LOG.HAL_TABLE_ID%TYPE;
t_hal_error		OHMS_ACTIVITY_LOG.HAL_ERROR%TYPE;
t_hal_item		OHMS_ACTIVITY_LOG.HAL_MESSAGE%TYPE;
is_complete exception;

BEGIN
	t_table_id		:= p_table_id;
	t_action		:= 'VALIDATE';
	t_status		:= NULL;
	t_view_name		:= 'table_generate';
	t_global_proc		:= 'TABLE_VALIDATE';

	t_view_name		:= 'GENERATE';
	t_status		:= 'SUCCESS';

	t_global_log		:= 'NO';
	table_generate(t_table_id, 'NO');
	t_global_log		:= 'YES';

	create_objects(t_table_id);

	table_generate(t_table_id, 'YES');

	IF t_global_log = 'YES' THEN
	      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

	        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
		INSERT INTO OHMS_ACTIVITY_LOG
		(
			hal_id
			, hal_date
			, hal_user
			, hal_item
			, hal_table_id
			, hal_status
			, hal_message
		)
		VALUES
		(
			t_hal_id
			, t_hal_date
			, t_hal_user
			, t_view_name
			, t_table_id
			, t_status
			, 'Procedure XNA_OHMS_POPULATE_' || t_table_id || ' Generated'
		);
		COMMIT;
	END IF;

	compile_proc(t_table_id);

	t_view_name		:= 'COMPILE';

	IF t_global_log = 'YES' THEN
	      	SELECT systimestamp, user INTO t_hal_date, t_hal_user FROM DUAL;

		SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;
		INSERT INTO OHMS_ACTIVITY_LOG
		(
			hal_id
			, hal_date
			, hal_user
			, hal_item
			, hal_table_id
			, hal_status
			, hal_message
		)
		VALUES
		(
			t_hal_id
			, t_hal_date
			, t_hal_user
			, t_view_name
			, t_table_id
			, t_status
			, 'Compilation of XNA_OHMS_POPULATE_' || t_table_id || ' Completed'
		);
		COMMIT;
	END IF;

    RAISE is_complete;

EXCEPTION

WHEN is_complete THEN
    RAISE_APPLICATION_ERROR( -20000,'Compilation of XNA_OHMS_POPULATE_' || t_table_id || ' Completed' );

WHEN OTHERS THEN
	IF DBMS_SQL.IS_OPEN(t_cursor) THEN
		DBMS_SQL.CLOSE_CURSOR(t_cursor);
	END IF;
        t_error_text		:= DBMS_UTILITY.FORMAT_ERROR_STACK;

        SELECT OHMS_hal_id.nextval INTO t_hal_id FROM DUAL;

	INSERT INTO OHMS_ACTIVITY_LOG
	(
		hal_id
		, hal_date
		, hal_user
		, hal_item
		, hal_table_id
		, hal_status
		, hal_error
		, hal_message
	)
	VALUES
	(
		t_hal_id
		, t_hal_date
		, t_hal_user
		, t_view_name
		, t_table_id
		, 'ERROR'
		, 'CURSOR'
		, 'Aborted: ' || t_error_text
	);
	COMMIT;

    raise_application_error( -20000,'Compilation attempt Failed,  Error is '
                            || t_error_text
                            || '. Please review the OHMS_ACTIVITY_LOG table.');

END;


FUNCTION results_rollup(p_view_name IN VARCHAR2, p_data_type IN VARCHAR2, p_table IN NUMBER, p_data_item IN NUMBER) RETURN VARCHAR2 IS

t_query			VARCHAR2(4000);


BEGIN
	IF p_data_type IN ('_AGGREGATE','_SUB','NO_ROLLUP') THEN
		t_query	:= 	t_newline || t_newline ||
				'CURSOR CUR_' || p_data_item || ' IS ' || t_newline ||
				'SELECT * FROM OHMS_xxx ;';
	ELSE
		t_query	:= 	t_newline || t_newline || 'CURSOR CUR_' || p_data_item || ' IS ' || t_newline ||
				'SELECT route_id ' || t_newline ||
	    			'    , min(begin_point) begin_point ' || t_newline ||
			        '    , max(end_point) end_point ' || t_newline ||
				'    , max(end_point) - min(begin_point) section_length  ' || t_newline;


		FOR c_target IN cur_output_columns(p_table, p_data_item) LOOP
			t_target_col_name	:= c_target.hcl_name;

			t_query			:= t_query || '    , ' || lower(t_target_col_name) || t_newline;
		END LOOP;

		t_query		:= t_query || ' FROM ( ' || t_newline ||
				'    SELECT route_id ' || t_newline ||
				'        , begin_point ' || t_newline ||
				'        , end_point ' || t_newline;

		FOR c_target IN cur_output_columns(p_table, p_data_item) LOOP
			t_target_col_name	:= c_target.hcl_name;

			t_query			:= t_query || '        , ' || lower(t_target_col_name) || t_newline;
		END LOOP;

		t_query		:= t_query || '        , break_point ' || t_newline ||
				'        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld ' || t_newline ||
				'    FROM ' || t_newline ||
				'        (SELECT route_id ' || t_newline ||
				'            , begin_point ' || t_newline ||
				'            , end_point ' || t_newline ;
		FOR c_target IN cur_output_columns(p_table, p_data_item) LOOP
			t_target_col_name	:= c_target.hcl_name;

			t_query			:= t_query || '            , ' || lower(t_target_col_name) || t_newline;
		END LOOP;

		t_query		:= t_query || '            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND ' || t_newline ||
				'                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)' || t_newline;

		FOR c_target IN cur_output_columns(p_table, p_data_item) LOOP
			t_target_col_name	:= c_target.hcl_name;

			t_query			:= t_query || '                AND ' || lower(t_target_col_name) || ' = lag(' || lower(t_target_col_name) ||
							') over (order by route_id, begin_point)' || t_newline;
		END LOOP;

		t_query		:= t_query || '                THEN 0 ' || t_newline ||
				'            ELSE ' || t_newline ||
				'                1 ' || t_newline ||
				'            END break_point ' || t_newline ||
				'        FROM OHMS_xxx) ' || t_newline ||
				') ' || t_newline ||
				' GROUP BY route_id, group_by_fld';

		FOR c_target IN cur_output_columns(p_table, p_data_item) LOOP
			t_target_col_name	:= c_target.hcl_name;

			t_query			:= t_query || ', ' || lower(t_target_col_name);
		END LOOP;
		
		t_query		:= t_query || ';' || t_newline || t_newline;
	END IF;

	t_query	:= replace(t_query,'OHMS_xxx',p_view_name);

	RETURN t_query;

EXCEPTION WHEN OTHERS THEN
	RETURN NULL;
END;
END;
/
