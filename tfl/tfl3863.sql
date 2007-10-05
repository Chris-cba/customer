-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/tfl3863.sql-arc   2.3   Oct 05 2007 11:24:24   Ian Turnbull  $
--       Module Name      : $Workfile:   tfl3863.sql  $
--       Date into SCCS   : $Date:   Oct 05 2007 11:24:24  $
--       Date fetched Out : $Modtime:   Oct 05 2007 11:23:48  $
--       SCCS Version     : $Revision:   2.3  $
--
-----------------------------------------------------------------------------
rem
rem  Date   : March 1999
rem  Author : H.Buckley
rem  Descr  : This program will enable the user to create specified output
rem           file formats from the standard exor interface extraction
rem           programs.
rem

set serveroutput on
set ver off
set feed off

prompt

prompt Highways by Exor
exec higgrirp.write_gri_spool(&1,'Highways by Exor');
prompt ================
exec higgrirp.write_gri_spool(&1,'================');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt Mai3863: Download Assets by Inspection
exec higgrirp.write_gri_spool(&1,'Mai3863: Download Assets by Inspection');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt Working ....
exec higgrirp.write_gri_spool(&1,'Working ....');
prompt
exec higgrirp.write_gri_spool(&1,'');

declare
   cursor c_ftp 
   is
   select *
   from x_tfl_ftp_dirs
   where ftp_type = 'PED';
   
   l_ftp_rec x_tfl_ftp_dirs%rowtype;
   
   l_interpath varchar2(200) := hig.get_user_or_sys_opt('INTERPATH');
   l_repoutpath varchar2(200) := hig.get_user_or_sys_opt('REPOUTPATH');
   
   L_FILE_LIST nm3file.file_list;
   
   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
  dbms_output.enable(1000000);
  Pedif.main(&1);
  
  -- get ftp details
  open c_ftp;
  fetch c_ftp into l_ftp_rec;
  close c_ftp;
  
  -- get list of ped files in INTERPATH
  dbms_java.grant_permission(user,'SYS:java.io.FilePermission',l_INTERPATH,'read');
  l_file_list := nm3file.get_files_in_directory (pi_dir => hig.get_user_or_sys_opt('INTERPATH'));

  -- put PED files on to the ftp host
  for i in 1..l_file_list.count
   loop
     if substr(upper(l_file_list(i)),instr(upper(l_file_list(i)),'.')+1,3) = 'PED'
      then
        higgrirp.write_gri_spool(&1,'Transfering '||l_file_list(i));  
        higgrirp.write_gri_spool(&1,'from  '||l_interpath);
        higgrirp.write_gri_spool(&1,'to '||l_repoutpath);
        higgrirp.write_gri_spool(&1,'');
        l_ftp := x_tfl_ftp_util.PUT( p_localpath => l_interpath 
                                    ,p_filename => l_file_list(i)
                                    ,p_remotepath => l_ftp_rec.ftp_arc_out_dir 
                                    ,p_username => l_ftp_rec.ftp_username
                                    ,p_password => l_ftp_rec.ftp_password
                                    ,p_hostname => l_ftp_rec.ftp_host
                                    ,v_status  => l_status
                                    ,v_error_message => l_error
                                    ,n_bytes_transmitted => l_bytes
                                    ,d_trans_start => l_trans_start 
                                    ,d_trans_end => l_trans_end);
        higgrirp.write_gri_spool(&1,'Transfer Status ' || l_status);
        higgrirp.write_gri_spool(&1,'Transfer Message ' || l_error);
        if l_ftp 
         then 
           -- delete the ped file from the database server if transfer ok.
           dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', l_interpath||'/'||l_file_list(i), 'delete' );
           nm3file.DELETE_FILE(pi_dir => l_interpath, pi_file => l_file_list(i)); 
        end if;                              
     end if;                              
  end loop;                              
end;
/

set define on
set term off
set head off

spool run_file.sql
select 'Prompt Press Return to exit '||chr(10)||' pause'
from gri_report_runs
where grr_job_id = '&1'
and grr_mode != 'WEB'
/

exec higgrirp.write_gri_spool(&1,'Finished');

set term on
set define off
spool off
start run_file

exit;

