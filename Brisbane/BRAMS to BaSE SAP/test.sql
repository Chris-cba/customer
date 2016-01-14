declare
	c_test  sys_refcursor;
	s_I varchar2(1);
	n_B_ID number;
	s_obj1 varchar(200);
	s_obj2 varchar(200);
	s_obj3 varchar(200);
	s_obj4 varchar(200);
	
	s_module varchar2(30);
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);
	
	d_start_date date;
	d_end_date date;
	n_brams_id number;
begin

	d_start_date := to_date('2014-05-26', 'RRRR-MM-dd');
	d_end_date := to_date('2014-05-29', 'RRRR-MM-dd');
	n_brams_id := 15208053;

	X_LOG_TABLE.DEBUG_ON;
	XBCC_SAP_SYNC.process_refcur (			
			d_start_date => d_start_date
			, d_end_date => d_end_date
			, rc_recordset => c_test
			, n_brams_id => n_brams_id
			--, b_Only_Check_Cooridor=> true
			);        

	s_module := upper('XBCC_SAP_SYNC-PROCESS_REFCUR');
	s_log_area := 'OUTPUT'; 

			
	loop
		fetch c_test into s_i, n_b_id,s_obj1,s_obj2,s_obj3,s_obj4;
		exit when c_test%NOTFOUND;
		--dbms_output.put_line(s_i || ' ' ||n_b_id);
		s_log_base_info := 'Output for:'  || ' ' || n_b_id;
		s_log_text := s_i || ', ' ||  n_b_id || ', ' || s_obj1 || ', ' || s_obj2 || ', ' || s_obj3 || ', ' || s_obj4;
		x_log_table.log_item(s_module, s_log_area, s_log_base_info , s_log_text );		
	end loop;
	close c_test;

	end;