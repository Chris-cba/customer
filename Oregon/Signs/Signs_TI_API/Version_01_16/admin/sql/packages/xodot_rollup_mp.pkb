create or replace package body reports.xodot_rollup_mp is
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: xodot_rollup_mp
	Author: JMM
	UPDATE01:	Original, 2015.04.20, JMM
*/

/* *******************************************************
	Used for: Rolling up tables from the reports schema.  It is expected that the following fields exist from the source table: LRM_KEY, BEG_MP_NO, END_MP_NO, 
	all other fields are are assumed to be attributes that the user
	It is also expected that the temporary table that is filled is created prior to running this package; If it is not a true temporary table the calling 
	procedure should empty it.
	
	
******************************************************* */

procedure rollup_mp(s_source_table  varchar2, s_destination_table  varchar2) is
	s_schema varchar2(50) := 'REPORTS';
	
	s_sql_base varchar2(30000) := ''; --Too big for a table use only in this code
	s_sql_columns varchar2(2000) := '';
	s_sql_ands varchar2(5000) := '';
	s_sql_insert varchar(500) := '';
	
	/* ************************************************************
	Object:		c_get_rows
	Purpose:	To get the column names of the input table
	Notes:		
	Created:	2015.06.05	J.Mendoza
	************************************************************* */
	
	cursor c_get_rows(s_table_name varchar2, s_owner varchar2) is
		select Column_name from dba_tab_cols where owner= upper(s_owner) and table_name = upper(s_table_name) and column_name not in ('LRM_KEY', 'BEG_MP_NO','END_MP_NO');
	
/* ************************************************************
	Object:		private procedure set_base
	Purpose:	To set the base query to be used by the roll up procedure
	Notes:		
	Created:	2015.06.05	J.Mendoza
************************************************************* */
	
	procedure set_base is
		begin
		s_sql_base := 'SELECT lrm_key 
				   , beg_mp_no 
				   , end_mp_no 
				   #COL#
				FROM (
				SELECT lrm_key 
					, min(beg_mp_no) beg_mp_no 
					, max(end_mp_no) end_mp_no 
					#COL#
				FROM ( 
					SELECT lrm_key 
						, beg_mp_no 
						, end_mp_no 
						#COL#
						, break_point 
						, sum(break_point) over (partition by lrm_key order by lrm_key, beg_mp_no) group_by_fld 
					FROM 
						(SELECT lrm_key 
							, beg_mp_no 
							, end_mp_no 
							#COL#
							, CASE WHEN (lrm_key) = lag(lrm_key) over (order by lrm_key, beg_mp_no) AND 
								(round(beg_mp_no,2) = lag(round(end_mp_no,2)) over (order by lrm_key, beg_mp_no) OR 
								round(beg_mp_no,2) = lag(round(beg_mp_no,2)) over (order by lrm_key, beg_mp_no))
								#CASE_ANDS#
								THEN 0 
							ELSE 
								1 
							END break_point 
						FROM #FROM_TABLE#) 
				) 
				 GROUP BY lrm_key, group_by_fld #COL#)				 
				 ';		
		end set_base;
	----------------------------------------------
	----------------------------------------------
	-----------------START------------------------
	----------------------------------------------
	----------------------------------------------
	begin
		
		for r_row in c_get_rows(s_source_table, s_schema) loop
			s_sql_columns :=  s_sql_columns || ',' ||r_row.column_name ;
			
			s_sql_ands := s_sql_ands || ' AND nvl(#1#,''0'') = lag( nvl(#1#,''0'')) over (order by lrm_key, beg_mp_no)';
			s_sql_ands := replace(s_sql_ands, '#1#', r_row.column_name);
			
		end loop;
		
		
		--fill the base sql
		
		set_base;
		
		-- ready the sql for a cursor
		
		s_sql_base := replace(s_sql_base,'#COL#',s_sql_columns);
		s_sql_base := replace(s_sql_base,'#CASE_ANDS#',s_sql_ands);
		s_sql_base := replace(s_sql_base,'#FROM_TABLE#',s_source_table);
		
		
		s_sql_insert := 'Insert into ' || s_destination_table || ' (lrm_key , beg_mp_no , end_mp_no #COL#) ';
		s_sql_insert := replace(s_sql_insert,'#COL#',s_sql_columns);
		
		
		dbms_output.put_line(s_sql_insert);
		dbms_output.put_line(s_sql_base);
		
		EXECUTE IMMEDIATE s_sql_insert || s_sql_base;
		
	end rollup_mp;


end xodot_rollup_mp;
/