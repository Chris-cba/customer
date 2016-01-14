create or replace
TRIGGER XWCC_trig_PEM_DEF
after INSERT OR UPDATE of 
		def_serial_no, DEF_STATUS_CODE
ON DEFECTS
FOR each ROW 
WHEN
(
	(new.def_serial_no is not null)
)

Declare
	v_cnt	integer;
	v_dsc 	varchar(2);

BEGIN
	--see if pem exists
	select count(*) into v_cnt from docs where doc_id = :new.def_serial_no;
	
	if v_cnt = 1 then 
		V_cnt := 0;
		-- see if Doc Assoication exists
		select count(*) into v_cnt from doc_assocs where DAS_doc_id = :new.def_serial_no and DAS_REC_ID = :new.def_defect_id and DAS_TABLE_NAME = 'DEFECTS';   
		
		-- Only fire if the doc_assoc does not exist.
		if v_cnt = 0 then
			--make the doc ass
			insert into doc_assocs  (DAS_TABLE_NAME, DAS_REC_ID, DAS_DOC_ID) Values ('DEFECTS', :new.def_defect_id, :new.def_serial_no);
		
		
		if :new.DEF_STATUS_CODE = 'COMPLETED' then 
				v_dsc := 'CO';
				
				UPDATE docs SET    
					doc_status_code = v_dsc,
					doc_compl_complete = :new.def_date_compl,
					doc_reason      =  'Defect '||:new.def_defect_id||' Status Changed to '|| v_dsc
					WHERE  doc_id = :new.def_serial_no;
					
		elsif :new.DEF_STATUS_CODE = 'AVAILABLE' then  
				v_dsc := 'DR';
				
				UPDATE docs SET    
					doc_status_code = v_dsc,
					doc_compl_complete = null, --:new.def_date_compl,
					doc_reason      =  'Defect '||:new.def_defect_id||' Status Changed to '|| v_dsc
					WHERE  doc_id = :new.def_serial_no;
			end if;
		else
			null;
			--Update Error Log???
		end if;
	end if;
	



END;
/