

BEGIN


	FOR c_changes IN cur_network_changes(t_process_date) LOOP

		
		
			FETCH cur_entry_exists INTO t_entry_exists;	
			FETCH cur_no_length_change INTO t_no_length_change;
			FETCH cur_reclassify INTO t_reclassify;	
			FETCH cur_recalibrate INTO t_recalibrate;		
			FETCH cur_close INTO t_close;		
			FETCH cur_create INTO t_create;	
			FETCH cur_new_db INTO t_new_db;		
			FETCH cur_new_segm INTO t_new_segm;		
			FETCH cur_rescaled_db INTO t_rescaled_db;
		

		IF t_entry_exists = 'F' THEN
			
			IF t_create = 'T' AND t_datum_type = 'S' THEN

				t_row.operation				:= 'ADDED-NOENTRY';
				t_row.rte					:= t_route;
				INSERT INTO xodot_length_change VALUES t_row;

			ELSIF t_create = 'T' AND t_datum_type = 'D' THEN

				t_row.operation			:= 'DISTANCE BREAK ADDED-NE';
				INSERT INTO xodot_length_change VALUES t_row;

			ELSIF t_rescaled_db  = 'T' THEN    
			
				t_row.operation				:= 'DISTANCE BREAK CLOSED-NE';			
				INSERT INTO xodot_length_change VALUES t_row;
			END IF;

		ELSIF t_recalibrate = 'T' THEN

			IF t_old_ne_length > t_new_ne_length THEN
				t_operation		:= 'RECALIBRATED SHORTER';
			ELSE
				t_operation		:= 'RECALIBRATED LONGER';
			END IF;
			
			INSERT INTO xodot_length_change VALUES t_row;

			IF t_close = 'T' THEN

				t_row.operation				:= 'CLOSED-RC';
				INSERT INTO xodot_length_change VALUES t_row;
				
			ELSIF t_create = 'T' THEN

				t_row.operation				:= 'ADDED-RC';
				INSERT INTO xodot_length_change VALUES t_row;
			END IF;

		ELSIF t_new_db = 'T' AND t_no_length_change = 'F' THEN

			t_row.operation				:= 'DISTANCE BREAK ADDED';
			
			INSERT INTO xodot_length_change VALUES t_row;

		ELSIF t_new_segm = 'T' AND t_no_length_change = 'F' THEN

			t_row.operation				:= 'ADDED-NEW';			
			INSERT INTO xodot_length_change VALUES t_row;

		ELSIF t_close = 'T'  THEN  
		
			IF t_datum_type = 'S' THEN

				
				t_row.operation				:= 'CLOSED-SEGM';
				
				INSERT INTO xodot_length_change VALUES t_row;

			ELSE
				
				t_row.operation				:= 'DISTANCE BREAK CLOSED';
				
				INSERT INTO xodot_length_change VALUES t_row;

			END IF;
			
		ELSIF t_reclassify = 'T' THEN
-- first entry			
			t_row.operation				:= 'ADDED RECLASSIFY';
			
			INSERT INTO xodot_length_change VALUES t_row;

-- Second entry
			t_row.operation				:= 'CLOSED RECLASSIFY';

			INSERT INTO xodot_length_change VALUES t_row;

		END IF;
	END LOOP;

