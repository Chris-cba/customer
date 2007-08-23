--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/cim/install/remove_hcc_cim.sql-arc   2.0   Aug 23 2007 14:59:08   Ian Turnbull  $
--       Module Name      : $Workfile:   remove_hcc_cim.sql  $
--       Date into PVCS   : $Date:   Aug 23 2007 14:59:08  $
--       Date fetched Out : $Modtime:   Aug 23 2007 14:53:36  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
-- Hampshire CIM automation removal
--
Prompt Remove Hampshire CC CIM
Prompt 
Prompt Dropping  x_hcc_cim_log table
drop table x_hcc_cim_log;

prompt drop sequence xhcl_id_seq;
drop sequence xhcl_id_seq;

Prompt Drop x_hcc_cim_dirs table
drop table x_hcc_cim_dirs;

Prompt Drop package
drop package x_hcc_cim;

--
-- Remove the DBMS_JOB
--
Prompt Used this sql to identify the dbms_job to remove
prompt select job, what from dba_jobs;

prompt
prompt use the job number from the query with this process to remove the job
prompt nn is the job number from the query
prompt begin
prompt dbms_job.remove(job => nn);
prompt end;