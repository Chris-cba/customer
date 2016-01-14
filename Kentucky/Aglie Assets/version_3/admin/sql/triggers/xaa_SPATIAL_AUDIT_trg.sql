create or replace trigger xaa_spatial_audit_trg 
	after  insert or update or delete
	on nm_nlt_rt_rt_sdo
	for each row
	
	declare
	
	begin
	/*	XAA_SPATIAL_AUDIT 
			ROUTE_ID
			GEOLOC
			OPERATION
			OP_DATE
			EFF_DATE
			END_DATE
	*/

	
		if inserting then
			insert into XAA_SPATIAL_AUDIT values (
				:new.ne_id --route_id
				, :new.geoloc
				, 'ADD'
				, sysdate
				, :new.start_date  
				, :new.end_date
				)
				;
		elsif updating then
			insert into XAA_SPATIAL_AUDIT values (
				:old.ne_id --route_id
				, :old.geoloc
				, 'DELETE'
				, sysdate
				, :old.date_modified  -- Need to fill in
				, :new.date_modified --:old.end_date
				)
				;
				
			insert into XAA_SPATIAL_AUDIT values (
				:new.ne_id --route_id
				, :new.geoloc
				, 'ADD'
				, sysdate
				, :new.date_modified --:new.start_date  -- Need to fill in
				, :new.end_date
				)
				;
		
		elsif deleting then
			insert into XAA_SPATIAL_AUDIT values (
				:old.ne_id --route_id
				, :old.geoloc
				, 'DELETE'
				, sysdate
				, :old.start_date  -- Need to fill in
				, :old.end_date
				)
				;
		
		end if;
	end;
	/	