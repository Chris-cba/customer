--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor0005.sql-arc   2.0   Mar 25 2008 10:49:20   smarshall  $
--       Module Name      : $Workfile:   xnor0005.sql  $
--       Date into PVCS   : $Date:   Mar 25 2008 10:49:20  $
--       Date fetched Out : $Modtime:   Mar 25 2008 10:48:52  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--   HMS Journals Extract GRI script.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2008
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
EXEC higgrirp.write_gri_spool('&1','HMS Journals Extract');
prompt HMS Journals Extract
prompt
EXEC higgrirp.write_gri_spool('&1','Working ....');
prompt Working ....
EXEC higgrirp.write_gri_spool('&1','');
prompt

DECLARE
  l_filename	varchar2(250);
  
BEGIN  
  l_filename := xnor_journals_interface.generate_journal_file(pi_grr_job_id => &1);
  
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

