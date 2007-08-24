CREATE OR REPLACE PACKAGE BODY x_hcc_cim
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/cim/admin/pck/x_hcc_cim.pkb-arc   2.5   Aug 24 2007 15:10:36   Ian Turnbull  $
--       Module Name      : $Workfile:   x_hcc_cim.pkb  $
--       Date into PVCS   : $Date:   Aug 24 2007 15:10:36  $
--       Date fetched Out : $Modtime:   Aug 24 2007 15:10:00  $
--       PVCS Version     : $Revision:   2.5  $
--       Based on SCCS version :
--
--
--   Author : ITurnbull
--
--   x_hcc_cim body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   2.5  $"';

  g_package_name CONSTANT varchar2(30) := 'x_hcc_cim';
  
  TYPE ref_cursor IS REF CURSOR;
  g_interpath constant varchar2(200) := hig.get_user_or_sys_opt('INTERPATH');


  c_out constant varchar2(3) := 'OUT';
  c_in  constant varchar2(2) := 'IN';  
  
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;

--
-----------------------------------------------------------------------------
--
procedure move_file 
  ( pi_from_file  in  varchar2
  , pi_from_loc   in  varchar2 default null
  , pi_to_file    in  varchar2 default null
  , pi_to_loc     in  varchar2 default null
  , pi_overwrite  in  boolean  default false
  , po_err_no     out integer
  , po_err_mess   out varchar2
  )
  is
-- No 'to' file name assume it's the same name
l_to_file varchar2(32767) := nvl(pi_to_file,pi_from_file) ;
-- no 'to' file dir assume it's the same dir
l_to_loc varchar2(32767) := nvl(pi_to_loc,pi_from_loc) ;
l_from_handle utl_file.file_type ;
l_to_handle utl_file.file_type ;
l_line_buffer varchar2(32767) ;
b_eof_data boolean ;
l_directory_path varchar2(256) ;
begin
  nm_debug.proc_start(g_package_name,'move_file');
  if not pi_overwrite and nm3file.file_exists( l_to_loc, l_to_file ) = 'Y'
  then
    raise_application_error(-20001,'move_file: "To" file ' || l_to_file || ' exists and overwrite not specified ' );
  elsif nm3file.file_exists( pi_from_loc, pi_from_file ) = 'N'
  then
    raise_application_error(-20001,'move_file: "From" file ' || pi_from_file || ' does not exist ' );
  end if;
  l_from_handle := nm3file.fopen( pi_from_loc, pi_from_file, nm3file.c_read_mode, 32767 ) ;
  l_to_handle := nm3file.fopen( l_to_loc, l_to_file, nm3file.c_write_mode, 32767 ) ;
  -- We are going to do this a line at a time because of memory considerations
  -- it might be quite slow
  b_eof_data := false ;
  while true
  loop
    nm3file.get_line( l_from_handle, l_line_buffer, b_eof_data ) ;
    exit when b_eof_data ;
    nm3file.put_line( l_to_handle, l_line_buffer ) ;
  end loop;
  nm3file.fclose_all ;
  nm_debug.proc_end(g_package_name,'move_file');
exception
  when others then
    nm_debug.debug( sqlerrm ) ;
    po_err_no := sqlcode ;
    po_err_mess := sqlerrm ;

end move_file;
--
-----------------------------------------------------------------------------
--
procedure ins_log(  pi_message varchar2 )
is
   pragma autonomous_transaction;
begin
   insert into x_hcc_cim_log
   (
     hcl_id
   , hcl_date
   , hcl_text
   )
   values
   (
     xhcl_id_seq.nextval
   , sysdate
   , pi_message
   );

   commit;
end ins_log;
--
-----------------------------------------------------------------------------
--
function get_ftp_dir(pi_direction varchar2)
return varchar2
is
   rtrn varchar2(500);
   ref_cur ref_cursor;
begin
   
   open ref_cur for 'select hcd_directory from x_hcc_cim_dirs where hcd_direction = '''||pi_direction||'''';
   fetch ref_cur into rtrn;
   close ref_cur;
    
   return rtrn;
end get_ftp_dir;
--
-----------------------------------------------------------------------------
--
procedure process_output_files
is
   cursor c_cons
   is
   select oun_contractor_id 
   from org_units
   where oun_electronic_orders_flag = 'Y';

   l_filename varchar2(100);
   
   l_err_no integer;
   l_err_msg varchar2(1000);
begin
   for con_rec in c_cons
    loop
      -- produce the wo extract file
      ins_log( pi_message => 'Createing Work Order file for '||con_rec.oun_contractor_id);
      l_filename := interfaces.write_wor_file( p_contractor_id	=> con_rec.oun_contractor_id
                                              ,p_seq_no	      => null
                                              ,p_filepath	   => g_interpath);
      ins_log( pi_message => 'Created file '||l_filename);
      
      --dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', g_interpath||'\*', 'read,write,delete' ) ;
      --dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', get_ftp_dir(pi_direction => c_out )||'\*', 'read,write,delete' ) ;
      dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,delete' ) ;
      ins_log('Starting move file');
      ins_log('pi_from_file => '||l_filename);
      ins_log('pi_from_loc  => '||g_interpath);
      ins_log('pi_to_file   => '||l_filename);
      ins_log('pi_to_loc    => '||get_ftp_dir(pi_direction => c_out )); 
      move_file( pi_from_file => l_filename 
                        ,pi_from_loc  => g_interpath
                        ,pi_to_file   => l_filename
                        ,pi_to_loc    => get_ftp_dir(pi_direction => c_out )
                        ,po_err_no    => l_err_no
                        ,po_err_mess  => l_err_msg
                       ); 
      ins_log('po_err_no    => '||l_err_no);
      ins_log('po_err_mess  => '||l_err_msg);                 
   end loop;
                     
end process_output_files;
--
-----------------------------------------------------------------------------
--
procedure process_input_files
is
   l_file_list nm3file.file_list;

   l_err_no integer;
   l_err_msg varchar2(1000);

   l_errors varchar2(1000);
begin 
   null;
   -- get a list of files in the ftp in dir
   --dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', get_ftp_dir(pi_direction => c_in )||'\*', 'read,write,delete' ) ;
     
   dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', '<<ALL FILES>>' , 'read,write,delete' ) ;
   ins_log('Getting file list for ' || get_ftp_dir(pi_direction => c_in ));    
   l_file_list := nm3file.get_files_in_directory( pi_dir => get_ftp_dir(pi_direction => c_in ) ); 

   for i in 1..l_file_list.count 
    loop
      if substr(l_file_list(i),1,2) in ('WC','WI')
       then 
         -- move each file from the ftp dir to the interpath dir

--         dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', g_interpath||'\*', 'read,write,delete' ) ;
--         dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', get_ftp_dir(pi_direction => c_in )||'\*', 'read,write,delete' ) ;
         dbms_java.grant_permission( user, 'SYS:java.io.FilePermission','<<ALL FILES>>' , 'read,write,delete' ) ;
         dbms_java.grant_permission( user, 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,delete' ) ;

         ins_log('Starting move file');
         ins_log('pi_from_file => '|| l_file_list(i));
         ins_log('pi_from_loc  => '||get_ftp_dir(pi_direction => c_in ));
         ins_log('pi_to_file   => '||l_file_list(i));
         ins_log('pi_to_loc    => '||g_interpath); 

         move_file( pi_from_file => l_file_list(i)
                           ,pi_from_loc  => get_ftp_dir(pi_direction => c_in )
                           ,pi_to_file   => l_file_list(i)
                           ,pi_to_loc    => g_interpath
                           ,po_err_no    => l_err_no
                           ,po_err_mess  => l_err_msg
                           );
         ins_log('po_err_no    => '||l_err_no);
         ins_log('po_err_mess  => '||l_err_msg);                 
         -- load in the file
         ins_log('Starting load for ');
         ins_log('contractor ' || substr(l_file_list(i),instr(l_file_list(i),'.')+1) );
         ins_log('filename ' ||  l_file_list(i));
         interfaces.completion_file_ph1(p_contractor_id => substr(l_file_list(i),instr(l_file_list(i),'.')+1)
                                       ,p_seq_no => null
                                       ,p_filepath => g_interpath
                                       ,p_filename => l_file_list(i)
                                       ,p_error => l_errors );
         ins_log('loaded file ' || l_file_list(i));
         ins_log('p_error => '||l_errors );                                        
      end if;
   end loop;
--      
end process_input_files;
--
-----------------------------------------------------------------------------
--
procedure process_all_files
is
begin 
   process_output_files;
   process_input_files;
end process_all_files;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_dbms_job (p_every_n_minutes number DEFAULT 30)
IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   c_bare_what CONSTANT varchar2(62) :=  'x_hcc_cim.process_all_files;';
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
             ||CHR(10)||'-- This job is for the exor CIM interface'
             ||CHR(10)||'-- Works order extract and completion/invoice files'
             ||CHR(10)||'--It moves the file around and processes them'
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
END submit_dbms_job;
--
-----------------------------------------------------------------------------
--

END x_hcc_cim;
/
