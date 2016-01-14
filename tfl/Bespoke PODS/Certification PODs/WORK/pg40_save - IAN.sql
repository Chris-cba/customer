declare 
  l_values wwv_flow_global.vc_arr2;
begin 

    l_values := htmldb_util.string_to_table(:P40VALUES,'~');

	update work_orders
	set 
	 WOR_CHAR_ATTRIB110  =  decode(l_values(2),'null',null,l_values(2)) --Invoice Status
	,WOR_CHAR_ATTRIB111 =  upper(substr(l_values(3),1,500)) --Invoice Status Comments
	,WOR_CHAR_ATTRIB115 =  decode(l_values(4),'null',null,l_values(4)) --Correct area of work and qtys
	,WOR_CHAR_ATTRIB116 =  decode(l_values(5),'null',null,l_values(5)) --Quality of work OK
	,WOR_CHAR_ATTRIB70  =  decode(l_values(6),'null',null,l_values(6)) --Correct BOQ/Uplifts
	,WOR_CHAR_ATTRIB114 =  upper(substr(l_values(7),1,500)) --Certification Comments
	--,WOR_CHAR_ATTRIB113 =  l_values(4) --Before/After Photos Present
	where wor_works_order_no =l_values(1);

        htp.prn('Work Order ' || l_values(1) || ' updated.<br>Page will refresh.');

	exception 
	when others then 
	   htp.prn('Error Updating work order : ' || l_values(4)  ||
               'Invoice Status = ' ||l_values(2) || 
			   'Invoice Status Comments = ' ||l_values(3) ||
			   'Correct area of work and qtys = ' ||l_values(4) ||
			   'Quality of work OK = ' ||l_values(5) ||
			   'Invoice Status = ' ||l_values(6) ||
			   'Certification Comments = ' ||l_values(7) ||
			   'APEX Process P40Save');

end;