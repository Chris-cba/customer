--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xnor0001.sql	1.1 09/20/06
--       Module Name      : xnor0001.sql
--       Date into SCCS   : 06/09/20 15:54:56
--       Date fetched Out : 07/06/06 14:39:01
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   HMS May Gurney Order Extract GRI script.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
SET serveroutput ON size 1000000
SET ver OFF
SET feed OFF
prompt

EXEC higgrirp.write_gri_spool('&1','Highways by Exor');
prompt Highways by Exor
EXEC higgrirp.write_gri_spool('&1','================');
prompt ================
prompt
EXEC higgrirp.write_gri_spool('&1','');
prompt 
EXEC higgrirp.write_gri_spool('&1','HMS May Gurney Order Extract');
prompt May Gurney Order Extract
prompt
EXEC higgrirp.write_gri_spool('&1','Working ....');
prompt Working ....
EXEC higgrirp.write_gri_spool('&1','');
prompt

DECLARE
  l_filename	varchar2(250);
  
BEGIN
  l_filename := xnor_may_gurney_interface.generate_order_file(pi_grr_job_id => &1);
  
  IF l_filename IS NOT NULL
  THEN
    higgrirp.write_gri_spool('&1','Info: File '||l_filename||' created');
    DBMS_OUTPUT.PUT_LINE('Info: File '||l_filename||' created');
  END IF;

EXCEPTION
  WHEN others
  THEN
    higgrirp.write_gri_spool('&1','Unexpected error: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
    DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END;
/

update gri_report_runs 
set grr_end_date = sysdate,
grr_error_no = 0,
grr_error_descr = 'Normal Successful Completion'
where grr_job_id = &&1; 

EXEC higgrirp.write_gri_spool('&1','Operation completed');
prompt
PROMPT Operation completed
prompt

EXIT;

