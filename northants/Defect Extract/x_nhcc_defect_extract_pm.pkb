create or replace
PACKAGE BODY x_nhcc_defect_extract_pm
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/Defect Extract/x_nhcc_defect_extract_pm.pkb-arc   1.1   Mar 28 2012 14:28:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_nhcc_defect_extract_pm.pkb  $
--       Date into PVCS   : $Date:   Mar 28 2012 14:28:46  $
--       Date fetched Out : $Modtime:   Mar 28 2012 14:23:56  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :
--
--
--   Author : %USERNAME%
--
--   %YourObjectName% body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------




------------Old Header-----------------------------------------------------------------
--
-- Author_old : Garry Bleakley
-- Updated : JMM March-2012
-- x_nw_extract body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

 -----------
 --constants
 -----------
 

 --g_package_name CONSTANT varchar2(30) := 'x_defect_extract';

  --g_interpath constant varchar2(200) := 'D:\databases\NHCC\utl\woms';

  --g_con_id varchar2(5);
  --g_cim_action varchar2(10);

  --c_out constant varchar2(3) := 'OUT';
  --C_IN  CONSTANT varchar2(2) := 'IN';
  
  g_FTP_file boolean := false;


/*   -- Commented By JMM
--
-----------------------------------------------------------------------------
--
procedure set_con_id(pi_con_id varchar2)
is
begin
   g_con_id := pi_con_id;
end set_Con_id;
--
-----------------------------------------------------------------------------
--
function get_con_id
return varchar2
is
begin
   return G_CON_ID;
end get_con_id;
--
-----------------------------------------------------------------------------
--


*/

/* ***Note: FTP archiving has not been impletmented in this version of the code.***  */

procedure nhcc_defect_extract(l_path varchar2, l_filename varchar2 default null, l_process_id number) is

TYPE tab_varchar32767 IS TABLE OF varchar2(32767) INDEX BY BINARY_INTEGER;

TYPE tab_number       IS TABLE OF number          INDEX BY binary_integer;

l_file   UTL_FILE.FILE_TYPE;
l_count  PLS_INTEGER;

--l_location varchar2(200):='d:\exor\reports';
--l_file_name varchar2(200);
l_lines tab_varchar32767 ;
l_defects tab_number;
L_DATE date:=sysdate;

	l_hpal_rec   hig_process_alert_log%ROWTYPE;
	L_HP_REC     HIG_PROCESSES%ROWTYPE; 
	l_msg varchar2(500);


FUNCTION fopen(p_LOCATION     IN VARCHAR2
              ,filename     IN VARCHAR2
              ,open_mode    IN VARCHAR2
              ,max_linesize IN BINARY_INTEGER
              ) RETURN UTL_FILE.FILE_TYPE IS
--
   l_full_filename VARCHAR2(2000) := p_LOCATION||'\'||filename;
--
BEGIN
--
   IF p_LOCATION IS NULL
    OR filename IS NULL
    THEN
      RAISE UTL_FILE.INVALID_PATH;
   END IF;
--
   IF UPPER(open_mode) NOT IN ('W')
    THEN
      -- Trap this one before it even gets as far at the FOPEN call
      RAISE UTL_FILE.INVALID_MODE;
   END IF;
--
   RETURN UTL_FILE.FOPEN(p_LOCATION, filename, open_mode, max_linesize);
--
--EXCEPTION
--   WHEN UTL_FILE.INVALID_PATH
--    THEN
--      RAISE_APPLICATION_ERROR(-20001,'file location or name was invalid');
--   WHEN UTL_FILE.INVALID_MODE
--    THEN
--      RAISE_APPLICATION_ERROR(-20001,'the open_mode string was invalid');
--   WHEN UTL_FILE.INVALID_OPERATION
--    THEN
--      RAISE_APPLICATION_ERROR(-20001,'file "'||l_full_filename||'" could not be opened as requested');
--   WHEN UTL_FILE.invalid_maxlinesize
--    THEN
--      RAISE_APPLICATION_ERROR(-20001,'specified max_linesize is too large or too small');
--
END fopen;


PROCEDURE fclose(FILE IN OUT UTL_FILE.FILE_TYPE) IS
BEGIN
--
   UTL_FILE.FCLOSE(FILE);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END fclose;

PROCEDURE put_line(FILE   IN UTL_FILE.FILE_TYPE
                  ,buffer IN VARCHAR2
                  ) IS
BEGIN
--
   UTL_FILE.PUT_LINE(FILE, buffer);
--
EXCEPTION
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file is not open for reading');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END put_line;



begin

--l_file_name:=pi_filename;

  select def_Defect_ID,
  hau_name
  ||','||null
  ||','||def_Defect_ID
  ||','||Def_Priority
  ||','||'C'
  ||','||to_char(rep_date_due,'DD-MON-YYYY HH24:MI:SS')
  ||','||Def_special_instr
  ||','||translate(Def_Locn_descr,',',' ')
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||translate(rep_descr,',',' ')
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||hus_initials
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||translate(Def_defect_Descr,',',' ')
  ||','||null
  ||','||null
  ||','||null
  ||','||null
  ||','||to_char(rep_date_due,'DD-MON-YYYY HH24:MI:SS')
  ||','||def_defect_code
  ||','||rep_tre_treat_code
  ||','||to_char(are_created_date,'DD-MON-YYYY HH24:MI:SS')
  ||','||def_atv_acty_area_code
  ||','||def_easting
  ||','||def_northing
  ||','||are_initiation_type
  ||','||def_siss_id
  ||','||def_x_sect
  ||','||rep_action_cat
  bulk collect into
  l_defects,l_lines
from defects
,repairs
,road_segs
,hig_admin_units
,activities_report
,hig_users
where 1=1
--and rownum < 50   						-- Added for debug
and def_status_code  ='AVAILABLE'
and   rep_def_Defect_id=def_defect_id
and   def_rse_he_id    =rse_he_id
and   hau_admin_unit   =rse_admin_unit
and   are_report_id    =def_are_report_id
and   HUS_USER_ID      =ARE_PEO_PERSON_ID_ACTIONED
for update of def_status_code nowait; -- added (HB ) 180909


--	l_msg := 'Debug: Opening File for writing: ' || l_path ||', ' || l_filename ||', ' || l_process_id;
--	hig_process_api.log_it(pi_process_id   => l_process_id
--						,PI_MESSAGE      => L_MSG
--						,pi_summary_flag => 'Y' );


-- added if statement around fopen, to not create an empty file (GB) 290909
if L_LINES.COUNT > 0 then
    
      L_MSG := 'Writing ' || L_LINES.COUNT ||' lines to file ' || L_FILENAME;  
      hig_process_api.log_it(pi_process_id   => l_process_id
						,PI_MESSAGE      => L_MSG
						,pi_summary_flag => 'Y' );
    
    L_FILE := FOPEN (L_PATH,L_FILENAME,'W',1023);
    



--    
--  L_MSG := 'Debug: l_file := fopen done: ' || L_PATH ||', ' || L_FILENAME ||', ' || L_PROCESS_ID;  
--	hig_process_api.log_it(pi_process_id   => l_process_id
--						,PI_MESSAGE      => L_MSG
--						,pi_summary_flag => 'Y' );


   l_count := l_lines.FIRST;
--
   WHILE l_count IS NOT NULL
    LOOP
      put_line(l_file,l_lines(l_count));
      l_count := l_lines.NEXT(l_count);
   END LOOP;
fclose(l_file);

g_FTP_file := true;  -- Used to tell the FTP part to X-fer the files


for i in 1..l_Defects.count loop
  update defects
  set    def_status_code='EXTRACTED' -- changed (HB) 180909
        ,def_last_updated_date=l_date
  where  def_defect_id        =l_defects(i);
end loop;

commit;

else
            L_MSG := 'No Defects to Export';  
             hig_process_api.log_it(pi_process_id   => l_process_id
						,PI_MESSAGE      => L_MSG
						,pi_summary_flag => 'Y' );


end if;
end;

/*   -- Commented By JMM
--
-----------------------------------------------------------------------------
--
procedure ins_log(  pi_filename varchar2 default null
                   ,pi_ftp_dir varchar2 default null
                   ,pi_archive_dir varchar2 default null
                   ,pi_message varchar2
                   )
is
   pragma autonomous_transaction;
   l_con_id varchar2(5) := get_con_id;
   l_action varchar2(10) := 'WOMS';
begin
   insert into x_woms_log
   (
     TCL_ID
   , TCL_DATE
   , TCL_CON_ID
   , TCL_CIM_ACTION
   , TCL_FILENAME
   , TCL_FTP_DIR
   , TCL_ARCHIVE_DIR
   , TCL_INTERPATH
   , TCL_MESSAGE
   )
   values
   (
     tcl_id_seq.nextval
   , sysdate
   , l_con_id
   , l_action
   , pi_filename
   , pi_ftp_dir
   , pi_archive_dir
   , g_interpath
   , pi_message
   );

   commit;
end ins_log;
--
-----------------------------------------------------------------------------
--
procedure ins_ftp_queue( pi_con_id varchar2
                        ,pi_filename varchar2
                        ,pi_direction varchar2
                       )
is
   pragma autonomous_transaction;
begin
   insert into x_ftp_queue
      ( tfq_id
       ,tfq_date
       ,tfq_con_id
       ,tfq_filename
       ,tfq_direction
      )
   values
      ( tfq_id_seq.nextval
       ,sysdate
       ,pi_con_id
       ,pi_filename
       ,pi_direction
      );
   commit;
end ins_ftp_queue;
--
-----------------------------------------------------------------------------
--
procedure ins_out_queue( pi_con_id varchar2
                        ,pi_filename varchar2
                       )
is
begin
   ins_ftp_queue ( pi_con_id => pi_con_id
                  ,pi_filename => pi_filename
                  ,pi_direction => c_out
                 );
   ins_log(pi_filename => pi_filename
         , pi_ftp_dir => null
         , pi_archive_dir => null
         , pi_message => 'File placed on output queue : ' ||pi_filename );

end ins_out_queue;
--
-----------------------------------------------------------------------------
--
procedure upd_queue_ftp_site(pi_id number)
is
   pragma autonomous_transaction;
begin
   update x_ftp_queue
   set tfq_ftp_site = sysdate
   where tfq_id = pi_id;
   commit;
end upd_queue_ftp_site;
--
-----------------------------------------------------------------------------
--
procedure upd_queue_archive(pi_id number)
is
   pragma autonomous_transaction;
begin
   update x_ftp_queue
   set tfq_archive = sysdate
   where tfq_id = pi_id;
   commit;
end upd_queue_archive;
--
-----------------------------------------------------------------------------
--
procedure upd_queue_import(pi_id number)
is
   pragma autonomous_transaction;
begin
   update x_ftp_queue
   set tfq_import = sysdate
   where tfq_id = pi_id;
   commit;
end upd_queue_import;
--
-----------------------------------------------------------------------------
--
procedure upd_queue_delete(pi_id number)
is
   pragma autonomous_transaction;
begin
   update x_ftp_queue
   set tfq_delete = sysdate
   where tfq_id = pi_id;
   commit;
end upd_queue_delete;
--
-----------------------------------------------------------------------------
--
procedure process_out_ftp_queue
is
  l_rec_hus  hig_users%ROWTYPE      := nm3get.get_hus(pi_hus_user_id => nm3context.get_context(nm3context.get_namespace,'USER_ID'));
  l_rec_nau  nm_admin_units%ROWTYPE := nm3get.get_nau(pi_nau_admin_unit=>l_rec_hus.hus_admin_unit);
  l_contractor varchar2(4) := 'NHCC';
   cursor c_ftp_dirs
   is
    SELECT hfc_ftp_host       ftp_host
         , hfc_ftp_username   ftp_username
         , nm3ftp.get_password(hfc_ftp_password)   ftp_password
         , hfc_ftp_out_dir     ftp_out_dir
         , hfc_ftp_port       ftp_port
      FROM hig_ftp_connections, hig_ftp_types
     WHERE hft_type = 'WOMS'
       AND hft_id = hfc_hft_id
       AND hfc_nau_unit_code = l_rec_nau.nau_unit_code;

   cursor c_out_ftp( c_con_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_out
     and tfq_ftp_site is null
     and tfq_con_id = c_con_id;


   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   for dir_rec in c_ftp_dirs
    loop
      set_con_id(pi_con_id => l_contractor);
      for ftp_rec in c_out_ftp(l_contractor)
       loop
         l_ftp := x_ftp_util.PUT( p_localpath => g_interpath
                                     ,p_filename => ftp_rec.tfq_filename
                                     ,p_remotepath => dir_rec.ftp_out_dir
                                     ,p_username => dir_rec.ftp_username
                                     ,p_password => dir_rec.ftp_password
                                     ,p_hostname => dir_rec.ftp_host
                                     ,v_status  => l_status
                                     ,v_error_message => l_error
                                     ,n_bytes_transmitted => l_bytes
                                     ,d_trans_start => l_trans_start
                                     ,d_trans_end => l_trans_end);
         if not l_ftp
          then
            -- try again
            l_ftp := x_ftp_util.PUT( p_localpath => g_interpath
                                        ,p_filename => ftp_rec.tfq_filename
                                        ,p_remotepath => dir_rec.ftp_out_dir
                                        ,p_username => dir_rec.ftp_username
                                        ,p_password => dir_rec.ftp_password
                                        ,p_hostname => dir_rec.ftp_host
                                        ,v_status  => l_status
                                        ,v_error_message => l_error
                                        ,n_bytes_transmitted => l_bytes
                                        ,d_trans_start => l_trans_start
                                        ,d_trans_end => l_trans_end);
            if not l_ftp
             then
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_out_dir
                  , pi_archive_dir => null
                  , pi_message => 'FTP process. Status = ' ||l_status||' '||
                                  'Error: ' ||l_error||' '||
                                  'Bytes: ' ||l_bytes||' ');
               exit;
            end if;
         end if;
         -- log success
         upd_queue_ftp_site(pi_id => ftp_rec.tfq_id);

         ins_log(pi_filename => ftp_rec.tfq_filename
            , pi_ftp_dir => dir_rec.ftp_out_dir
            , pi_archive_dir => null
            , pi_message => 'FTP process. Status = ' ||l_status||' '||
                            'Error: ' ||l_error||' '||
                            'Bytes: ' ||l_bytes||' ');
      end loop;
   end loop;
end process_out_ftp_queue;
--
-----------------------------------------------------------------------------
--
procedure process_out_archive_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'WOMS';

   cursor c_out_archive( c_con_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_out
     and tfq_archive is null
     and tfq_con_id = c_con_id;

   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   for dir_rec in c_ftp_dirs
    loop
      set_con_id(pi_con_id => dir_rec.ftp_contractor);
      for ftp_rec in c_out_archive(dir_rec.ftp_contractor)
       loop
         l_ftp := x_ftp_util.PUT( p_localpath => g_interpath
                                     ,p_filename => ftp_rec.tfq_filename
                                     ,p_remotepath => dir_rec.ftp_arc_out_dir
                                     ,p_username => dir_rec.ftp_arc_username
                                     ,p_password => dir_rec.ftp_arc_password
                                     ,p_hostname => dir_rec.ftp_arc_host
                                     ,v_status  => l_status
                                      ,v_error_message => l_error
                                     ,n_bytes_transmitted => l_bytes
                                     ,d_trans_start => l_trans_start
                                     ,d_trans_end => l_trans_end);
         if not l_ftp
          then
            -- try again
            l_ftp := x_ftp_util.PUT( p_localpath => g_interpath
                                        ,p_filename => ftp_rec.tfq_filename
                                        ,p_remotepath => dir_rec.ftp_arc_out_dir
                                        ,p_username => dir_rec.ftp_arc_username
                                        ,p_password => dir_rec.ftp_arc_password
                                        ,p_hostname => dir_rec.ftp_arc_host
                                        ,v_status  => l_status
                                        ,v_error_message => l_error
                                        ,n_bytes_transmitted => l_bytes
                                        ,d_trans_start => l_trans_start
                                        ,d_trans_end => l_trans_end);
            if not l_ftp
             then
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_out_dir
                  , pi_archive_dir => null
                  , pi_message => 'ARCHIVE process. Status = ' ||l_status||' '||
                                  'Error: ' ||l_error||' '||
                                  'Bytes: ' ||l_bytes||' ');
               exit;
            end if;
         end if;
         -- log success
         upd_queue_archive(pi_id => ftp_rec.tfq_id);

         ins_log(pi_filename => ftp_rec.tfq_filename
            , pi_ftp_dir => dir_rec.ftp_out_dir
            , pi_archive_dir => null
            , pi_message => 'ARCHIVE process. Status = ' ||l_status||' '||
                            'Error: ' ||l_error||' '||
                            'Bytes: ' ||l_bytes||' ');
      end loop;
   end loop;
end process_out_archive_queue;
--
-----------------------------------------------------------------------------
--
procedure process_out_delete_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'WOMS';

   cursor c_out_delete( c_con_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_out
     and tfq_ftp_site is not null
     and tfq_archive is not null
     and tfq_delete is null
     and tfq_con_id = c_con_id;

   l_fail boolean := false;
begin
   for dir_rec in c_ftp_dirs
    loop
      set_con_id(pi_con_id => dir_rec.ftp_contractor);
      for ftp_rec in c_out_delete(dir_rec.ftp_contractor)
       loop
         begin
            dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', g_interpath||'/'||ftp_rec.tfq_filename, 'delete' );
            nm3file.delete_File(pi_dir => g_interpath, pi_file => ftp_rec.tfq_filename);
         exception
            when others then
            -- send email
            ins_log(pi_filename => ftp_rec.tfq_filename
               , pi_message => 'File deletion failed');
            l_fail := true;
            exit;
         end;
         -- log success
         if not l_fail
          then
            upd_queue_delete(pi_id => ftp_rec.tfq_id);

            ins_log(pi_filename => ftp_rec.tfq_filename
               , pi_ftp_dir => null
               , pi_archive_dir => null
               , pi_message => 'File deleted');
         end if;
      end loop;
   end loop;
end process_out_delete_queue;
--
-----------------------------------------------------------------------------
--
procedure process_out_queue
is
begin
   process_out_ftp_queue;
   -- process_out_archive_queue;
   -- process_out_delete_queue;
end process_out_queue;
--
-----------------------------------------------------------------------------
--

*/

procedure process_output_files
is

	l_process_id Number := hig_process_api.get_current_process_id;   
	l_path       varchar2(100) ; 
	l_filename varchar2(255) := 'NHCC_DEFECT_EXTRACT_'||to_Char(sysdate,'YYYYMMDDHH24MISS')||'.TXT';
	l_hpal_rec   hig_process_alert_log%ROWTYPE;
	L_HP_REC     HIG_PROCESSES%ROWTYPE; 
	l_msg varchar2(500);
   
   -----
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;

   l_ftp boolean;
   
   CURSOR c_get_dir_path
   IS
   SELECT hdir_path 
   FROM   hig_directories
   WHERE  hdir_name = 'DEFECT_EXTRACT';  
   
   
   
   -----
begin
	
	
	OPEN  c_get_dir_path;
	FETCH c_get_dir_path INTO l_path;
	CLOSE c_get_dir_path;
      -- produce the defect extract file
	
	l_hp_rec := hig_process_framework.get_process(l_process_id);
	
	  
	l_msg := 'Starting Extract for: ' || l_filename;
	hig_process_api.log_it(pi_process_id   => l_process_id
						,pi_message      => l_msg
						,pi_summary_flag => 'Y' );

--	l_msg := 'Debug: ' || l_path ||', ' || l_filename ||', ' || l_process_id;
--	hig_process_api.log_it(pi_process_id   => l_process_id
--						,PI_MESSAGE      => L_MSG
--						,pi_summary_flag => 'Y' );


	NHCC_DEFECT_EXTRACT(L_PATH, L_FILENAME, L_PROCESS_ID );
  
  
  if g_FTP_file = true then
  
    l_msg := 'Extract Completed, Preparing to FTP: ' || l_filename;
    hig_process_api.log_it(pi_process_id   => l_process_id
              ,PI_MESSAGE      => L_MSG
              ,PI_SUMMARY_FLAG => 'Y' );
    
    FTP_ARCHIVE_FILE(L_PATH, L_FILENAME, L_PROCESS_ID );
  end if;
	
	



end process_output_files;

procedure FTP_ARCHIVE_FILE (L_PATH varchar2, L_FILENAME varchar2, L_PROCESS_ID number) is
  
  L_FAILED       varchar2(1) ;
   L_ERR_NO     integer;
   l_error      Varchar2(32767);
	L_CONN       UTL_TCP.CONNECTION;
	L_CONTINUE   BOOLEAN := true;
	l_msg         varchar2(500);
	l_hp_rec     hig_processes%ROWTYPE; 

BEGIN

	l_hp_rec := hig_process_framework.get_process(l_process_id);

	l_msg := 'FTP Sending File: ' || l_filename || 'With Process id: ' || l_process_id;
	hig_process_api.log_it(pi_process_id   => l_process_id
						,pi_message      => l_msg
						,PI_SUMMARY_FLAG => 'Y' );
            
            
            
--  L_MSG := 'DEBUG - ' || l_hp_rec.hp_process_type_id || ' :: ' || l_hp_rec.hp_area_id;
--  hig_process_api.log_it(pi_process_id   => l_process_id
--  ,PI_MESSAGE      => L_MSG
--  ,pi_summary_flag => 'Y' );
	
	                  -- Check for FTP setup            
                  FOR ftp IN (SELECT ftp.* 
                              FROM   hig_process_conns_by_area ,hig_ftp_connections ftp
                              where  HPTC_PROCESS_TYPE_ID = L_HP_REC.HP_PROCESS_TYPE_ID 
                              AND    hptc_area_id_value   = Nvl(l_hp_rec.hp_area_id, 1)
                              AND    hfc_id               = hptc_ftp_connection_id)
                  LOOP    
                      --l_continue_rec := get_ftp_details('CIM',oun.oun_contractor_id);
                  --IF  l_continue_rec.hfc_nau_unit_code IS NOT NULL
                  --AND l_continue  
                  
--                  	L_MSG := 'DEBUG - ' || FTP.HFC_FTP_HOST || ' :: ' || FTP.HFC_FTP_PORT || ' :: ' || FTP.HFC_FTP_USERNAME || ' :: ' || NM3FTP.GET_PASSWORD(FTP.HFC_FTP_PASSWORD)|| ' :: ' ||
--                              'l_conn' || ' :: ' ||'d:\databases\nhccsb\defect_extract\'|| ' :: ' || l_filename || ' :: ' || ftp.hfc_ftp_out_dir||l_filename;
--                      hig_process_api.log_it(pi_process_id   => l_process_id
--                      ,PI_MESSAGE      => L_MSG
--                      ,pi_summary_flag => 'Y' );
                  
                  
                  
                      IF l_continue
                      THEN
                         BEGIN
                         --
                            nm3ctx.set_context('NM3FTPPASSWORD','Y');
                            BEGIN
                               --
                               l_conn := nm3ftp.login(ftp.hfc_ftp_host,ftp.hfc_ftp_port,ftp.hfc_ftp_username,nm3ftp.get_password(ftp.hfc_ftp_password));
                               l_continue  := True ;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    l_continue  := False ;
                                    l_failed    := 'Y' ; 
                                    HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                          ,pi_message      => 'Error while connecting to the FTP server '|| Sqlerrm 
                                                          ,pi_message_type => 'E'
                                                          ,pi_summary_flag => 'Y' );
                            END ;
                            IF l_continue 
                            THEN
                                BEGIN
                                   --   
                                   nm3ftp.put(l_conn,'DEFECT_EXTRACT',l_filename,ftp.hfc_ftp_out_dir||l_filename);
                                   hig_process_api.log_it(pi_process_id => l_process_id
                                                             ,pi_message    => 'Defect Extract file '||l_filename||' copied to FTP location');
                                   l_continue  := True ;
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        l_continue  := False ; 
                                        l_failed    := 'Y' ;
                                        HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                              ,pi_message      => 'Following error occurred while copying the Defect file to the FTP ' || Sqlerrm 
                                                              ,pi_message_type => 'E'
                                                              ,pi_summary_flag => 'Y' ); 
                                END  ;            
                                IF l_continue 
                                THEN
                                    BEGIN
                                       --                                       
                                       nm3file.move_file(l_filename,'DEFECT_EXTRACT',l_filename,'DEFECT_EXTRACT_ARC',null,TRUE,l_err_no,l_error);
                                       IF l_error IS NOT NULL
                                       THEN
                                            l_failed    := 'Y' ;
                                            HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                  ,pi_message      => 'Following error occurred while archiving the WO file '||l_filename||' '||l_error
                                                                  ,pi_message_type => 'E'
                                                                  ,pi_summary_flag => 'Y' );                                     
                                       ELSE
                                           hig_process_api.log_it(pi_process_id => l_process_id
                                                                 ,pi_message    => 'Work Order Extract file '||l_filename||' archived');
                                       END IF ;
                                       nm3ftp.logout(l_conn);
                                       --
                                     EXCEPTION
                                        WHEN OTHERS THEN
                                            l_failed := 'Y' ;
                                            nm3ftp.logout(l_conn);
                                            HIG_PROCESS_API.LOG_IT(PI_PROCESS_ID   => L_PROCESS_ID
                                                                  ,pi_message      => 'Following error occurred while archiving the WO file '|| l_filename ||' '||Sqlerrm 
                                                                  ,pi_message_type => 'E'
                                                                  ,pi_summary_flag => 'Y' ); 
                                    END ;
                                END IF ;
                            END IF ;
                         --
                         EXCEPTION
                         WHEN OTHERS
                         THEN
                             nm3ftp.logout(l_conn);                             
                             Raise_Application_Error(-20001,'Error '||Sqlerrm);
                         END ;
                      END IF ;
                  END LOOP;
						
	


END FTP_ARCHIVE_FILE;

/*   -- Commented By JMM
--
-----------------------------------------------------------------------------
--
procedure show_woms_log
is
begin
   dm3query.show_query_in_own_page(p_dq_title=>'x_woms_log');
end show_woms_log;
--
-----------------------------------------------------------------------------
--
procedure show_ftp_queue
is
begin
   dm3query.show_query_in_own_page(p_dq_title=>'x_ftp_queue');
end show_ftp_queue;
--
-----------------------------------------------------------------------------
--
procedure show_ftp_settings
is
begin
   dm3query.show_query_in_own_page(p_dq_title=>'x_ftp_dirs');
end show_ftp_settings;
--
-----------------------------------------------------------------------------
--
procedure show_menu
is
begin

   htp.p('<html>');
   htp.p('<head>');
   htp.p('<title>exor WOMS </title>');
   htp.p('</head>');
   htp.p('<body>');
   htp.br;
   htp.br;
   htp.p('<table border="0" width="100%">');
   htp.p('<tr>');
   htp.p('<td align="center"><h1><b>Exor WOMS</font></b></h1></td>');
   htp.p('</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_defect_extract.show_ftp_settings">FTP Settings</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_defect_extract.show_ftp_queue">FTP Queue</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_defect_extract.show_woms_log">Log Details</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('</table>');
   htp.p('</body>');
   htp.p('</html>');

end show_menu;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_do_all_processes_job (p_every_n_minutes number DEFAULT 15)
IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   c_bare_what CONSTANT varchar2(62) :=  'x_defect_extract.process_output_files;';
   c_what               nm3type.max_varchar2;
--
   l_existing_job_id user_jobs.job%TYPE;
--
   l_job_id   binary_integer;
   l_found    BOOLEAN;
   l_interval nm3type.max_varchar2;
--
BEGIN
--
--
   c_what :=            'DECLARE'
             ||CHR(10)||'--'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--'
             ||CHR(10)||'-- This job is for the WOMS Extract Defects interface'
             ||CHR(10)||'--'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--	Copyright (c) exor corporation ltd, 2007'
             ||CHR(10)||'-----------------------------------------------------------------------------'
             ||CHR(10)||'--'
             ||CHR(10)||'   l_server_not_there EXCEPTION;'
             ||CHR(10)||'   PRAGMA EXCEPTION_INIT (l_server_not_there,-29278);'
             ||CHR(10)||'BEGIN'
             ||CHR(10)||'   '||c_bare_what
             ||CHR(10)||'EXCEPTION'
             ||CHR(10)||'   WHEN l_server_not_there'
             ||CHR(10)||'    THEN'
             ||CHR(10)||'      IF NVL(INSTR(SQLERRM,'||nm3flx.string('421')||',1,1),0) != 0'
             ||CHR(10)||'       THEN'
             ||CHR(10)||'         Null;'
             ||CHR(10)||'      ELSE'
             ||CHR(10)||'         RAISE;'
             ||CHR(10)||'      END IF;'
             ||CHR(10)||'END;';
--
   IF NVL(p_every_n_minutes,0) <= 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 283
                    ,pi_supplementary_info => TO_CHAR(NVL(p_every_n_minutes,0))||' <= 0'
                    );
   END IF;
   l_interval := 'SYSDATE+('||p_every_n_minutes||'/(60*24))';
--
   OPEN  cs_job (c_bare_what);
   FETCH cs_job INTO l_existing_job_id;
   l_found := cs_job%FOUND;
   CLOSE cs_job;
   IF l_found
    THEN
      -- modify the existing job
      dbms_job.change (job       => l_existing_job_id
                      ,what      => c_what
                      ,next_date => SYSDATE
                      ,interval  => l_interval
                      );
      dbms_job.broken (job       => l_existing_job_id
                      ,broken    => FALSE
                      );
   ELSE
      OPEN  cs_job (c_what);
      FETCH cs_job INTO l_existing_job_id;
      l_found := cs_job%FOUND;
      CLOSE cs_job;
      IF l_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 143
                       ,pi_supplementary_info => CHR(10)||c_what||CHR(10)||' (JOB_ID = '||l_existing_job_id||')'
                       );
      END IF;
   --
      dbms_job.submit
          (job       => l_job_id
          ,what      => c_what
          ,next_date => SYSDATE
          ,interval  => l_interval
          );
   --
   END IF;
--
   COMMIT;
--
END submit_do_all_processes_job;


--
-----------------------------------------------------------------------------
--

*/
END x_nhcc_defect_extract_pm;