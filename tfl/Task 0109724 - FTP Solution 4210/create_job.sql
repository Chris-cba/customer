--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/Task 0109724 - FTP Solution 4210/create_job.sql-arc   3.0   Sep 20 2010 10:46:50   Ade.Edwards  $
--       Module Name      : $Workfile:   create_job.sql  $
--       Date into PVCS   : $Date:   Sep 20 2010 10:46:50  $
--       Date fetched Out : $Modtime:   Sep 20 2010 10:01:18  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

BEGIN
  EXECUTE IMMEDIATE 'grant create job to '||user;
END;
/

DECLARE
  ex_no_exists       EXCEPTION;
  PRAGMA             EXCEPTION_INIT (ex_no_exists,-27475);
  l_int              VARCHAR2(1000) := 'freq=daily; byhour=12; byminute=0; bysecond=0;';
BEGIN
--
  BEGIN
    nm3jobs.drop_job ( pi_job_name => 'TMA_INSP_FTP'
                     , pi_force    => TRUE );
  EXCEPTION
    WHEN ex_no_exists THEN NULL;
  END;
--
  nm3jobs.create_job
              ( pi_job_name         => 'TMA_INSP_FTP'
              , pi_job_action       => 'BEGIN x_tfl_tma_ftp.get_inspection_files; END;'
              , pi_comments         => 'Created by nm3jobs at '||to_char(SYSDATE,'DD-MON-YYYY HH24:MI:SS') 
              , pi_repeat_interval  => l_int);
END;
/





