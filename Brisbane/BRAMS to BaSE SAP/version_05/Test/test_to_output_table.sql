declare
	c_test  sys_refcursor;
	s_I varchar2(1);
	n_B_ID number;
	s_obj1 varchar(200);
	s_obj2 varchar(200);
	s_obj3 varchar(200);
	s_obj4 varchar(200);
	
	n_run_id number;
	d_run_timestamp date := sysdate;
	n_temp number;
	
	
	s_module varchar2(30);
	s_log_area varchar2(2000);
	s_log_base_info varchar2(4000);
	s_log_text varchar2(4000);
	
	d_start_date date;
	d_end_date date;
	n_brams_id number;
begin
	
	select count(*) into n_temp from z_brams_base_output_delete;
	if nvl(n_temp, -1) <= 0 then
		n_run_id := 1;
	else
		select max(run_id) +1 into n_run_id from z_brams_base_output_delete;
	end if;
	
	insert into z_brams_base_output_delete (run_id, run_timestamp, i_start_date,o_indicator)
		values (n_run_id, d_run_timestamp, sysdate, 'Start of run time recorded in i_start_date');
	commit;
	
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
		
		insert into z_brams_base_output_delete  values
			(n_run_id, d_run_timestamp, d_start_date, d_end_date, n_brams_id, s_i,n_b_id,
				s_obj1,s_obj2,s_obj3,s_obj4);
		
	end loop;
	close c_test;
	commit;
	insert into z_brams_base_output_delete (run_id, run_timestamp, i_end_date,o_indicator)
		values (n_run_id, d_run_timestamp, sysdate, 'End of run time recorded in i_end_date');
		commit;
	end;