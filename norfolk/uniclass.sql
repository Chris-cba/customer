REM
rem   SCCS Identifiers :-
REM Copyright (c) Exor Corporation Ltd, 2004
REM @(#)uniclass.sql	1.1 07/20/04
rem
rem   uniclass interface 
rem
set serveroutput on
set ver off
set feed off
prompt

prompt Highways by Exor
prompt ================
prompt
prompt 
prompt Uniclass Interface
prompt GRI version
prompt
prompt Working ....
prompt
prompt
set serveroutput on
set ver off
set feed off

prompt

exec higgrirp.write_gri_spool(&1,'Highways by Exor');
exec higgrirp.write_gri_spool(&1,'================');
exec higgrirp.write_gri_spool(&1,'');
exec higgrirp.write_gri_spool(&1,'Uniclass File extract');
exec higgrirp.write_gri_spool(&1,'');
exec higgrirp.write_gri_spool(&1,'Working ....');
exec higgrirp.write_gri_spool(&1,'');
begin
  dbms_output.enable(1000000);
  uniclass.main(&1);
  
  UPDATE gri_report_runs 
  SET grr_end_date = sysdate,
  grr_error_no = 0,
  grr_error_descr = 'Normal Successful Completion'
  WHERE grr_job_id = &1
  AND grr_mode != 'WEB';
end;
/


exec higgrirp.write_gri_spool(&1,'Finished');

exit;
