--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor0003.sql-arc   2.0   Sep 03 2007 10:32:50   dyounger  $
--       Module Name      : $Workfile:   xnor0003.sql  $
--       Date into PVCS   : $Date:   Sep 03 2007 10:32:50  $
--       Date fetched Out : $Modtime:   Sep 03 2007 09:35:58  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--   HMS Commitment Extract GRI script.
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
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
EXEC higgrirp.write_gri_spool('&1','HMS Commitment Extract');
prompt HMS Commitment Extract
prompt
EXEC higgrirp.write_gri_spool('&1','Working ....');
prompt Working ....
EXEC higgrirp.write_gri_spool('&1','');
prompt

DECLARE
  l_filename	varchar2(250);
  
BEGIN
  l_filename := xnor_hops_gl_interface.generate_commitment_file(pi_grr_job_id => &1);
  
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

