alter trigger xhants_ack_mail disable
/

update defects
set def_status_code = 'NO ACTION'
where def_priority = 'B'
and def_status_code = 'AVAILABLE'
/

alter trigger xhants_ack_mail enable
/
