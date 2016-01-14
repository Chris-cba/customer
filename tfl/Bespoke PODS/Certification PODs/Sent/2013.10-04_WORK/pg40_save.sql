declare 
  l_values wwv_flow_global.vc_arr2;
begin 

    l_values := htmldb_util.string_to_table(:P40VALUES,'~');

	update work_orders
	set 
	 WOR_CHAR_ATTRIB110  =  decode(l_values(2),'null',null,l_values(2)) --Invoice Status  (select ial_value from nm_inv_attri_lookup where ial_domain = 'INVOICE_STATUS' and ial_meaning =l_values(2))
	where wor_works_order_no =l_values(1);
	commit;
	
	update work_orders
	set 
	WOR_CHAR_ATTRIB111 =  upper(substr(l_values(3),1,500)) --Invoice Status Comments
	,WOR_CHAR_ATTRIB115 =  decode(l_values(4),'null',null,l_values(4)) --Correct area of work and qtys
	,WOR_CHAR_ATTRIB116 =  decode(l_values(5),'null',null,l_values(5)) --Quality of work OK
	,WOR_CHAR_ATTRIB70  =  decode(l_values(6),'null',null,l_values(6)) --Correct BOQ/Uplifts
	,WOR_CHAR_ATTRIB114 =  upper(substr(l_values(7),1,500)) --Certification Comments
	,WOR_CHAR_ATTRIB113 =  decode(l_values(8),'null',null,l_values(8)) --Before/After Photos Present
	where wor_works_order_no =l_values(1);

	commit;
	
    htp.prn('Work Order ' || l_values(1) || ' updated.<br>Page will refresh.');

	exception 
	when others then 
	   htp.prn('Error Updating work order : ' || l_values(1)  || CHR(13)||CHR(10) ||
               'Invoice Status = ' ||l_values(2) ||  CHR(13)||CHR(10) ||
			   'Invoice Status Comments = ' ||l_values(3) ||  CHR(13)||CHR(10) ||
			   'Correct area of work and qtys = ' ||l_values(4) ||  CHR(13)||CHR(10) ||
			   'Quality of work OK = ' ||l_values(5) ||  CHR(13)||CHR(10) ||
			   'Invoice Status = ' ||l_values(6) ||  CHR(13)||CHR(10) ||
			   'Certification Comments = ' ||l_values(7) ||  CHR(13)||CHR(10) ||
			   'Before/After Photos Present = ' ||l_values(8) ||  CHR(13)||CHR(10) ||
			   'APEX Process P40Save');

end;