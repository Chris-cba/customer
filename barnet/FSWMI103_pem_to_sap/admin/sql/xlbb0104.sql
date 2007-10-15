--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/barnet/FSWMI103_pem_to_sap/admin/sql/xlbb0104.sql-arc   2.0   Oct 15 2007 08:39:18   smarshall  $
--       Module Name      : $Workfile:   xlbb0104.sql  $
--       Date into PVCS   : $Date:   Oct 15 2007 08:39:18  $
--       Date fetched Out : $Modtime:   Oct 15 2007 07:46:10  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--   LBB Atlas SAP Work Order Extract
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
EXEC higgrirp.write_gri_spool('&1','LBB SAP to PEM Import');
prompt HMS Commitment Extract
prompt
EXEC higgrirp.write_gri_spool('&1','Working ....');
prompt Working ....
EXEC higgrirp.write_gri_spool('&1','');
prompt

DECLARE
  l_extract_filename varchar2(250);
  l_log_filename     varchar2(250);

BEGIN
  xlbb_pem_invoice.update_pem_from_sap;

  IF l_extract_filename IS NOT NULL
  THEN
    higgrirp.write_gri_spool('&1','Info: Extract File '||l_extract_filename||' created');
    DBMS_OUTPUT.PUT_LINE('Info: Extract File '||l_extract_filename||' created');
  END IF;

  IF l_log_filename IS NOT NULL
  THEN
    higgrirp.write_gri_spool('&1','Info: Log File '||l_log_filename||' created');
    DBMS_OUTPUT.PUT_LINE('Info: Log FFile '||l_log_filename||' created');
  END IF;

  update gri_report_runs
  set grr_end_date = sysdate,
  grr_error_no = 0,
  grr_error_descr = 'Normal Successful Completion'
  where grr_job_id = &&1;

  higgrirp.write_gri_spool('&1','Operation completed');

EXCEPTION
  WHEN others
  THEN
    DECLARE
      c_errm CONSTANT gri_report_runs.grr_error_descr%type := substr(DBMS_UTILITY.FORMAT_ERROR_STACK, 1, 254);
      c_erno CONSTANT pls_integer := SQLCODE;

    BEGIN
      higgrirp.write_gri_spool('&1','Unexpected error: ' || c_errm);
      DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || c_errm);

      update gri_report_runs
      set grr_end_date = sysdate,
      grr_error_no = c_erno,
      grr_error_descr = c_errm
      where grr_job_id = &&1;
    END;
END;
/

COMMIT;

prompt
PROMPT Operation completed
prompt

EXIT;

