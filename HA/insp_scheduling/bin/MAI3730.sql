-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/bin/MAI3730.sql-arc   1.0   Jun 06 2012 16:22:34   Ian.Turnbull  $
--       Module Name      : $Workfile:   MAI3730.sql  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:22:34  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:31:02  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentely ltd, 2012
-----------------------------------------------------------------------------
exec higgrirp.write_gri_spool(&1,'Highways by Exor');
exec higgrirp.write_gri_spool(&1,'================');
exec higgrirp.write_gri_spool(&1,'');
exec higgrirp.write_gri_spool(&1,'Working ....');

set ver off
set feed off
col spool new_value spool noprint;

select higgrirp.get_module_spoolpath(&1,user)||higgrirp.get_module_spoolfile(&1) spool 
from dual;

spool &spool

prompt

prompt Download Inspections Batches
prompt ================================
prompt
prompt 
prompt Download Inspections Batches
prompt
prompt Submitting ....
prompt
declare
   
   
   l_gri_id              number;
  
-----------------------------------------
   l_process_type_id           hig_processes.hp_process_type_id%TYPE;
   l_initiated_by_username     hig_processes.hp_initiated_by_username%TYPE;
   l_initiated_date            hig_processes.hp_initiated_date%TYPE;
   l_initiators_ref            hig_processes.hp_initiators_ref%TYPE;
   l_start_date                date;
   l_frequency_id              hig_processes.hp_frequency_id%TYPE;
   l_polling_flag              hig_processes.hp_polling_flag%TYPE;
   l_area_id                   hig_processes.hp_area_id%TYPE;
   l_check_file_cardinality    BOOLEAN;
   l_process_id                hig_processes.hp_process_id%TYPE;
   l_job_name                  hig_processes.hp_job_name%TYPE;
   l_scheduled_start_date      DATE;   
----------------------------------

   l_params        hig_process_api.rec_temp_params;

begin

   dbms_output.enable;

   select grr_job_id into l_gri_id from  gri_report_runs
   where grr_job_id = &1;
 
   l_process_type_id := -5001;
   l_initiated_by_username := user;
   l_initiated_date := sysdate;
   l_initiators_ref  := null;
   l_start_date := sysdate;
   l_frequency_id := -1;
   l_polling_flag := 'N';
   l_area_id    := null;
   l_check_file_cardinality := FALSE;

   hig_process_api.initialise_temp_params;

   l_params.param_name := 'GRI_ID';
   l_params.param_value := l_gri_id;
   hig_process_api.add_temp_param (l_params);
  
   l_params.param_name := 'MODULE';
   l_params.param_value := 'MAI3730';
   hig_process_api.add_temp_param (l_params);

   hig_process_api.create_and_schedule_process    (pi_process_type_id           => l_process_type_id
                                                 , pi_initiated_by_username     => l_initiated_by_username
                                                 , pi_initiated_date            => l_initiated_date
                                                 , pi_initiators_ref            => l_initiators_ref
                                                 , pi_start_date                => l_start_date
                                                 , pi_frequency_id              => l_frequency_id
                                                 , pi_polling_flag              => l_polling_flag
                                                 , pi_area_id                   => l_area_id
                                                 , pi_check_file_cardinality    => l_check_file_cardinality
                                                 , po_process_id                => l_process_id
                                                 , po_job_name                  => l_job_name
                                                 , po_scheduled_start_date      => l_scheduled_start_date);


   higgrirp.write_gri_spool(&1,'The Parameters have been submitted to Process Manager.');
   higgrirp.write_gri_spool(&1,'Please use the Process Monitor module to view details. Process ID: '||l_process_id);

end;
/
set define on
set term off
set head off

spool off

spool run_file.sql
select 'Prompt Press Return to exit '||chr(10)||' pause'
from gri_report_runs
where grr_job_id = '&1'
and grr_mode != 'WEB'
/

exec higgrirp.write_gri_spool(&1,'Finished');

update gri_report_runs 
set grr_end_date = sysdate,
grr_error_no = 0,
grr_error_descr = 'Normal Successful Completion'
where grr_job_id = &&1; 

set term on
set define off
spool off
start run_file

exit;
