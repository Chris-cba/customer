spool on

spool uninstall_gasb34.log

@uninstall_gasb34_triggers_sql.sql

drop view xodot_gasb34;

commit;

spool off