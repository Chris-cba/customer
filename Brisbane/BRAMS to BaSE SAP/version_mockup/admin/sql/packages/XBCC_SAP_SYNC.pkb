Create or replace package body XBCC_SAP_SYNC as
/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	Author: JMM
	UPDATE01:	Original, 2014.03.25, JMM
*/


	procedure process (d_start_date date, d_end_date date, n_brams_id number default  null) as
			ex_sap_sync 		Exception;
			d_rundate 			date := sysdate;
		
		procedure date_check(d_sd date, d_ed date) as 		
			
			s_err_text varchar2(1000) := null;			
			begin	--date_check
				if d_sd = d_ed then
					s_err_text := 'Start Date and End Date cannot be the same value.';
				elsif d_sd > d_ed then
					s_err_text := 'Start Date cannot be greater than End Date.';
				elsif d_sd is null or d_ed is null then
					s_err_text := 'Date cannot be NULL.';
				end if;
				if s_err_text is not null then
					raise ex_sap_sync;
				end if;
			exception
				when ex_sap_sync then
					raise_application_error(-20001, s_err_text);		
		end	date_check;
		
		-- BEGIN PROCESS
		-- BEGIN PROCESS
		-- BEGIN PROCESS
		begin  --process
			date_check(d_start_date, d_end_date);
			insert into XBCC_SAP_SYNC_TB select d_rundate, d_start_date, d_end_date, n_brams_id, indicator, brams_id, object, name, "START", end from XBCC_SAP_SYNC_sample;
			commit;
	end process;
	
	procedure process_refcur  (d_start_date in  date, d_end_date in date, rc_recordset out sys_refcursor, n_brams_id in number default null) as
		--type typ_sap_sync_record is record( o_INDICATOR  varchar2(1), o_BRAMS_ID number(10), o_OBJECT varchar2(30), o_NAME varchar2(30), o_START number(18,2), o_END number(18,2));
		--type typ_sap_sync_list is table of typ_sap_sync_record ;
		
		r_sap_sync_list typ_sap_sync_list;
		
		ex_sap_sync 		Exception;
		d_rundate 			date := sysdate;
		
		cursor c_sample_data is select  indicator, brams_id, object, name, "START", end from XBCC_SAP_SYNC_sample;
		
	procedure date_check(d_sd date, d_ed date) as 		

		
		s_err_text varchar2(1000) := null;			
		begin	--date_check
			if d_sd = d_ed then
				s_err_text := 'Start Date and End Date cannot be the same value.';
			elsif d_sd > d_ed then
				s_err_text := 'Start Date cannot be greater than End Date.';
			elsif d_sd is null or d_ed is null then
				s_err_text := 'Date cannot be NULL.';
			end if;
			if s_err_text is not null then
				raise ex_sap_sync;
			end if;
		exception
			when ex_sap_sync then
				raise_application_error(-20001, s_err_text);		
	end	date_check;
	
	-- BEGIN PROCESS_refcur 
	-- BEGIN PROCESS_refcur 
	-- BEGIN PROCESS_refcur 
	begin  --process_refcur 
		date_check(d_start_date, d_end_date);
		
		r_sap_sync_list:= typ_sap_sync_list();
		/*
		open c_sample_data;
			loop 
				r_sap_sync_list.extend(1);
				fetch c_sample_data 
				into 
					r_sap_sync_list(r_sap_sync_list.count).o_indicator
					, r_sap_sync_list(r_sap_sync_list.count).o_brams_id
					, r_sap_sync_list(r_sap_sync_list.count).o_object
					, r_sap_sync_list(r_sap_sync_list.count).o_name
					, r_sap_sync_list(r_sap_sync_list.count).o_START
					, r_sap_sync_list(r_sap_sync_list.count).o_end
					;
					
				EXIT WHEN c_sample_data%NOTFOUND;
			end loop;
					
		close c_sample_data;
		if r_sap_sync_list(r_sap_sync_list.count).o_indicator is null then r_sap_sync_list.delete(r_sap_sync_list.count); end if;
		*/
		OPEN rc_recordset for select  indicator, brams_id, object, name, "START", end from XBCC_SAP_SYNC_sample;
	end process_refcur;
end XBCC_SAP_SYNC;