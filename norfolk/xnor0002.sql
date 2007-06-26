--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xnor0002.sql	1.2 09/20/06
--       Module Name      : xnor0002.sql
--       Date into SCCS   : 06/09/20 16:19:18
--       Date fetched Out : 07/06/06 14:39:01
--       SCCS Version     : 1.2
--
--
--   Author : Kevin Angus
--
--   HMS May Gurney Payments Extract GRI script.
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
EXEC higgrirp.write_gri_spool('&1','HMS May Gurney Payments Extract');
prompt May Gurney Order Extract
prompt
EXEC higgrirp.write_gri_spool('&1','Working ....');
prompt Working ....
EXEC higgrirp.write_gri_spool('&1','');
prompt

DECLARE
  l_payment_filename	varchar2(500);
  l_reversal_filename	varchar2(500);
  
BEGIN
  xnor_may_gurney_interface.generate_payment_file(pi_grr_job_id        => &1
                                                 ,po_payment_filename  => l_payment_filename
                                                 ,po_reversal_filename => l_reversal_filename);
  
  IF l_payment_filename IS NOT NULL
  THEN
    higgrirp.write_gri_spool('&1','Info: Payment File ' || l_payment_filename || ' created');
    DBMS_OUTPUT.PUT_LINE('Info: File ' || l_payment_filename || ' created');
  END IF;
  
  IF l_reversal_filename IS NOT NULL
  THEN
    higgrirp.write_gri_spool('&1','Info: Payment File ' || l_reversal_filename || ' created');
    DBMS_OUTPUT.PUT_LINE('Info: File ' || l_reversal_filename || ' created');
  END IF;

EXCEPTION
  WHEN others
  THEN
    DECLARE
      l_error nm3type.max_varchar2;
      
    BEGIN
      l_error := DBMS_UTILITY.FORMAT_ERROR_STACK;
    
      higgrirp.write_gri_spool('&1','Unexpected error: ' || l_error);
      DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || l_error);
    END;
END;
/

update gri_report_runs 
set grr_end_date = sysdate,
grr_error_no = 0,
grr_error_descr = 'Normal Successful Completion'
where grr_job_id = &1; 

EXEC higgrirp.write_gri_spool('&1','Operation completed');
prompt
PROMPT Operation completed
prompt

EXIT;

