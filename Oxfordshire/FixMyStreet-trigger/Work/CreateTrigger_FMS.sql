create or replace
TRIGGER XOX_trig_PEM_FMS
after INSERT OR UPDATE of 
	doc_compl_source,
	doc_status_code

ON DOCS
FOR each ROW 
WHEN
(
	(new.doc_compl_source = 'FMS')
)

Declare
	v_status  varchar2(30);
	v_msg     varchar2(512); 
	v_cnt     integer;

BEGIN
	if :new.doc_compl_source = 'FMS' then
	
  select count(*) into v_cnt from XOX_FMS_TRIGGER_LOOKUP where STATUS_CODE = :new.doc_status_code;
  
	if v_cnt = 0 then
		Insert into FMS_UPDATE (service_request_id, STATUS, DESCRIPTION) values (:new.DOC_ID, 'ERROR', 'UNHANDLED STATUS CODE: ' || :new.doc_status_code || ' in XOX_FMS_TRIGGER_LOOKUP table.');
	else
		select Status, Description into v_status, v_msg from XOX_FMS_TRIGGER_LOOKUP where rownum = 1 and STATUS_CODE = :new.doc_status_code;
		Insert into FMS_UPDATE (service_request_id, STATUS, DESCRIPTION)
		values (:new.DOC_ID, v_status, v_msg);
	end if;
	
	end if;


END;
/