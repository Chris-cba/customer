DECLARE

  v_job_no NUMBER(5);
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/emails/admin/sql/x_pem_emails_create_job.sql-arc   1.0   Feb 28 2011 11:53:44   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_pem_emails_create_job.sql  $
--       Date into PVCS   : $Date:   Feb 28 2011 11:53:44  $
--       Date fetched Out : $Modtime:   Feb 28 2011 10:51:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--   
-- 
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--   
BEGIN
  dbms_job.submit(v_job_no, 'x_pem_enfield_emails.process_docs;', TRUNC(SYSDATE+(1/24/60), 'MI'), 'TRUNC(SYSDATE+(1/24/60), ''MI'')');
  commit;
END;
/