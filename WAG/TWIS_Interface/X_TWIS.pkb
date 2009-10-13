CREATE OR REPLACE PACKAGE BODY WAG.x_twis
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/WAG/TWIS_Interface/X_TWIS.pkb-arc   3.0   Oct 13 2009 08:15:42   Ian Turnbull  $
--       Module Name      : $Workfile:   X_TWIS.pkb  $
--       Date into PVCS   : $Date:   Oct 13 2009 08:15:42  $
--       Date fetched Out : $Modtime:   Oct 13 2009 08:12:56  $
--       PVCS Version     : $Revision:   3.0  $

--
--
--   Author : Garry Bleakley
--
--   x_twis body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  g_body_sccsid CONSTANT VARCHAR2(2000) := '"%W% %G%"';
  --g_body_sccsid is the SCCS ID for the package body

  g_package_name CONSTANT varchar2(30) := 'x_twis';

  g_interpath constant varchar2(200) := hig.get_user_or_sys_opt('INTERPATH');

  g_twis_id varchar2(5);
  g_twis_action varchar2(10);

  c_out constant varchar2(3) := 'OUT';
  c_in  constant varchar2(2) := 'IN';

  --
  -----------------------------------------------------------------------------
--
procedure set_twis_id(pi_twis_id varchar2)
is
begin
   g_twis_id := pi_twis_id;
end set_twis_id;
--
-----------------------------------------------------------------------------
--
function get_twis_id
return varchar2
is
begin
   return g_twis_id;
end get_twis_id;
--
-----------------------------------------------------------------------------
--
procedure set_twis_action(pi_twis_action varchar2)
is
begin
   g_twis_action := pi_twis_action;
end set_twis_action;
--
-----------------------------------------------------------------------------
--
function get_twis_action
return varchar2
is
begin
   return g_twis_action;
end get_twis_action;
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
   l_twis_id varchar2(5) := get_twis_id;
   l_twis_action varchar2(10) := get_twis_action;
begin
   insert into x_twis_log
   (
     TCL_ID
   , TCL_DATE
   , TCL_TWIS_ID
   , TCL_TWIS_ACTION
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
   , l_twis_id
   , l_twis_action
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
procedure send_email(pi_msg varchar2)
is
   cursor c_mail_useR_id
   is
   select nmu.*
   from nm_mail_users nmu
       ,hig_users
   where hus_user_id = NMU_HUS_USER_ID
   and   HUS_IS_HIG_OWNER_FLAG = 'Y';

   cursor c_nmg
   is
   select *
   from nm_mail_groups
   where NMG_NAME = hig.get_sysopt('TWISMAIL');


   l_from nm_mail_message.nmm_from_nmu_id%TYPE;
   l_to  nm3mail.tab_recipient;
   l_cc  nm3mail.tab_recipient;
   l_bcc nm3mail.tab_recipient;
   l_msg nm3type.tab_varchar32767;
   l_subject  nm_mail_message.nmm_subject%TYPE;

   l_nmu_rec nm_mail_users%rowtype;
   l_nmg_rec nm_mail_groups%rowtype;

begin
   open c_mail_useR_id;
   fetch c_mail_user_id into l_nmu_rec;
   close c_mail_useR_id;

   l_from := l_nmu_rec.nmu_id;

   open c_nmg;
   fetch c_nmg into l_nmg_rec;

   if c_nmg%found
    then
      close c_nmg;
      l_to(1).rcpt_id := l_nmg_rec.nmg_id;
      l_to(1).rcpt_type := nm3mail.c_group;

      l_subject := 'Error with the TWIS FTP process';

      l_msg.delete;
      l_msg(1) := pi_msg;

--      nm3mail.WRITE_MAIL_COMPLETE(p_from_user         => l_from
--                                 ,p_subject           => l_subject
--                                 ,p_tab_to            => l_to
--                                 ,p_tab_cc            => l_cc
--                                 ,p_tab_bcc           => l_bcc
--                                 ,p_tab_message_text  => l_msg
--                                 );
--      nm3mail.send_stored_mail;
      ins_log( pi_message => 'Error email sent');
   else
      close c_nmg;
   end if;
end send_email;
--
-----------------------------------------------------------------------------
--
procedure ins_ftp_queue( pi_twis_id varchar2
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
       ,pi_twis_id
       ,pi_filename
       ,pi_direction
      );
   commit;
end ins_ftp_queue;
--
-----------------------------------------------------------------------------
--
procedure ins_out_queue( pi_twis_id varchar2
                        ,pi_filename varchar2
                       )
is
begin
   ins_ftp_queue ( pi_twis_id => pi_twis_id
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
procedure ins_in_queue( pi_twis_id varchar2
                       ,pi_filename varchar2
                      )
is
begin
   ins_ftp_queue ( pi_twis_id => pi_twis_id
                  ,pi_filename => pi_filename
                  ,pi_direction => c_in
                 );
   ins_log(pi_filename => pi_filename
         , pi_ftp_dir => null
         , pi_archive_dir => null
         , pi_message => 'File placed on input queue : ' ||pi_filename );

end ins_in_queue;
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
function get_wc_date
return varchar2
is
   l_wc_name varchar2(20);
   rtrn varchar2(100);
begin
   -- get the last monday date
   l_wc_name := 'TWIS'||to_char(trunc(sysdate),'YYYYMM') ;

   rtrn := l_wc_name;

   return rtrn;

end get_wc_date;
--
-----------------------------------------------------------------------------
--
procedure process_out_ftp_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   cursor c_out_ftp( c_twis_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_out
     and tfq_ftp_site is null
     and tfq_con_id = c_twis_id;


   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   set_twis_action(pi_twis_action => 'TO');
   for dir_rec in c_ftp_dirs
    loop
      set_twis_id(pi_twis_id => dir_rec.ftp_contractor);
      for ftp_rec in c_out_ftp(dir_rec.ftp_contractor)
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
               -- send an email
               send_email(pi_msg => 'FTP process. Status = ' ||l_status||' '||
                                    'Error: ' ||l_error||' '||
                                    'Bytes: ' ||l_bytes||' ');
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
procedure process_in_ftp_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   cursor c_in_ftp( c_twis_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_in
     and tfq_ftp_site is null
     and tfq_con_id = c_twis_id;


   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   set_twis_action(pi_twis_action => 'TI');
   for dir_rec in c_ftp_dirs
    loop
      set_twis_id(pi_twis_id => dir_rec.ftp_contractor);
      for ftp_rec in c_in_ftp(dir_rec.ftp_contractor)
       loop
         l_ftp := x_ftp_util.get( p_localpath => g_interpath
                                      ,p_filename => ftp_rec.tfq_filename
                                      ,p_remotepath => dir_rec.ftp_in_dir
                                      ,p_username => dir_rec.ftp_username
                                      ,p_password => dir_rec.ftp_password
                                      ,p_hostname => dir_rec.ftp_host
                                      ,v_status  => l_status
                                      ,v_error_message => l_error
                                      ,n_bytes_transmitted => l_bytes
                                      ,d_trans_start => l_trans_start
                                      ,d_trans_end => l_trans_end);

         if l_ftp then
         l_ftp := x_ftp_util.remove( p_localpath => g_interpath
                                      ,p_filename => ftp_rec.tfq_filename
                                      ,p_remotepath => dir_rec.ftp_in_dir
                                      ,p_username => dir_rec.ftp_username
                                      ,p_password => dir_rec.ftp_password
                                      ,p_hostname => dir_rec.ftp_host
                                      ,v_status  => l_status
                                      ,v_error_message => l_error
                                      ,n_bytes_transmitted => l_bytes
                                      ,d_trans_start => l_trans_start
                                      ,d_trans_end => l_trans_end);
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_in_dir
                  , pi_archive_dir => null
                  , pi_message => 'REMOVE FTP process. Status = ' ||l_status||' '||
                                  'Error: ' ||l_error||' '||
                                  'Bytes: ' ||l_bytes||' ');

         end if;

         if not l_ftp
          then
            -- try again
            l_ftp := x_ftp_util.get( p_localpath => g_interpath
                                        ,p_filename => ftp_rec.tfq_filename
                                        ,p_remotepath => dir_rec.ftp_in_dir
                                        ,p_username => dir_rec.ftp_username
                                        ,p_password => dir_rec.ftp_password
                                        ,p_hostname => dir_rec.ftp_host
                                        ,v_status  => l_status
                                        ,v_error_message => l_error
                                        ,n_bytes_transmitted => l_bytes
                                        ,d_trans_start => l_trans_start
                                        ,d_trans_end => l_trans_end);

         if l_ftp then
         l_ftp := x_ftp_util.remove( p_localpath => g_interpath
                                      ,p_filename => ftp_rec.tfq_filename
                                      ,p_remotepath => dir_rec.ftp_in_dir
                                      ,p_username => dir_rec.ftp_username
                                      ,p_password => dir_rec.ftp_password
                                      ,p_hostname => dir_rec.ftp_host
                                      ,v_status  => l_status
                                      ,v_error_message => l_error
                                      ,n_bytes_transmitted => l_bytes
                                      ,d_trans_start => l_trans_start
                                      ,d_trans_end => l_trans_end);
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_in_dir
                  , pi_archive_dir => null
                  , pi_message => 'REMOVE FTP process. Status = ' ||l_status||' '||
                                  'Error: ' ||l_error||' '||
                                  'Bytes: ' ||l_bytes||' ');

          end if;

            if not l_ftp
             then
               -- send an email
               send_email(pi_msg => 'FTP process. Status = ' ||l_status||' '||
                                    'Error: ' ||l_error||' '||
                                    'Bytes: ' ||l_bytes||' ');
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_in_dir
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
            , pi_ftp_dir => dir_rec.ftp_in_dir
            , pi_archive_dir => null
            , pi_message => 'FTP process. Status = ' ||l_status||' '||
                            'Error: ' ||l_error||' '||
                            'Bytes: ' ||l_bytes||' ');
      end loop;
   end loop;
end process_in_ftp_queue;
--
-----------------------------------------------------------------------------
--
procedure load_files(p_filename varchar2, p_con_id varchar2)
is
  l_nlf_id     NM_LOAD_FILES.NLF_ID%type;
  l_nlb_batch_no nm_load_batches.nlb_batch_no%TYPE;
  l_tab_recipients nm3mail.tab_recipient;
  l_index number;

begin
  select nlf_id
  into l_nlf_id
  from nm_load_files
  where nlf_unique='TWIS001'||p_con_id;

  l_nlb_batch_no:=nm3load.transfer_to_holding (p_nlf_id       => l_nlf_id
                              ,p_file_name    => p_filename
                              ,p_batch_source =>'S'
                              );

  nm3load.load_batch(p_batch_no => l_nlb_batch_no);


  FOR cs_rec IN
    (select NMU_ID ,'USER'
     from nm_mail_groups
     ,nm_mail_group_membership
     ,nm_mail_users
     where nmg_name='TWIS'
     and NMG_ID=NMGM_NMG_ID
     and NMGM_NMU_ID=NMU_ID)

    LOOP
      l_index:=l_tab_recipients.count+1;
      l_tab_recipients(l_index).rcpt_id   := cs_rec.nmu_id;
      l_tab_recipients(l_index).rcpt_type := 'USER';
   END LOOP;

  nm3load.produce_log_email (p_nlb_batch_no   => l_nlb_batch_no
                            ,p_send_to        => l_tab_recipients
                            );

  nm3mail.send_stored_mail;
end load_files;
--
-----------------------------------------------------------------------------
--
procedure process_in_load_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   cursor c_in_import( c_twis_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_in
     and tfq_import is  null
     and tfq_con_id = c_twis_id;

   l_fail boolean := false;
   l_errors varchar2(1000);
begin
   set_twis_action(pi_twis_action => 'TI');
   for dir_rec in c_ftp_dirs
    loop
      set_twis_id(pi_twis_id => dir_rec.ftp_contractor);
      for ftp_rec in c_in_import(dir_rec.ftp_contractor)
       loop
         begin
           if ftp_rec.tfq_con_id = 'NWTRA' then
            if upper(ftp_rec.tfq_filename) = 'NWTRA_TWIS.CSV'  -- NWTRA
             then
              l_errors:= null;
              load_files(p_filename => ftp_rec.tfq_filename
              		,p_con_id => ftp_rec.tfq_con_id);
              ins_log(pi_filename => ftp_rec.tfq_filename
                    , pi_message =>'processed NWTRA file '||ftp_rec.tfq_filename);
            end if;
           elsif ftp_rec.tfq_con_id = 'MWTRA' then
            if upper(ftp_rec.tfq_filename) = 'MWTRA_TWIS.CSV'  -- MWTRA
             then
              l_errors:= null;
              load_files(p_filename => ftp_rec.tfq_filename
              		,p_con_id => ftp_rec.tfq_con_id);
              ins_log(pi_filename => ftp_rec.tfq_filename
                    , pi_message =>'processed MWTRA file '||ftp_rec.tfq_filename);
            end if;
           elsif ftp_rec.tfq_con_id = 'SWTRA' then
            if upper(ftp_rec.tfq_filename) = 'SWTRA_TWIS.CSV'  -- SWTRA
             then
              l_errors:= null;
              load_files(p_filename => ftp_rec.tfq_filename
              		,p_con_id => ftp_rec.tfq_con_id);
              ins_log(pi_filename => ftp_rec.tfq_filename
                    , pi_message =>'processed SWTRA file '||ftp_rec.tfq_filename);
            end if;
           end if;
         exception
            when others then
            -- send email
            send_email(pi_msg => 'Load TWIS file '||  ftp_rec.tfq_filename||' failed');
            ins_log(pi_filename => ftp_rec.tfq_filename
               , pi_message => 'File load failed');
            l_fail := true;
            exit;
         end;
         -- log success
         if not l_fail
          then
            upd_queue_import(pi_id => ftp_rec.tfq_id);

            ins_log(pi_filename => ftp_rec.tfq_filename
               , pi_ftp_dir => null
               , pi_archive_dir => null
               , pi_message => 'File imported');
         end if;
      end loop;
   end loop;
end process_in_load_queue;
--
-----------------------------------------------------------------------------
--
procedure process_in_archive_queue
is
   cursor c_ftp_dirs
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   cursor c_out_archive( c_con_id x_ftp_queue.tfq_con_id%type)
   is
   select *
   from x_ftp_queue
   where tfq_direction = c_in
     and tfq_archive is null
     and tfq_con_id = c_con_id;

   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   set_twis_action(pi_twis_action => 'TI');
   for dir_rec in c_ftp_dirs
    loop
      set_twis_id(pi_twis_id => dir_rec.ftp_contractor);
      for ftp_rec in c_out_archive(dir_rec.ftp_contractor)
       loop
         -- create dir
          l_ftp := x_ftp_util.mkdir_remote (
                                                 p_remotepath               => dir_rec.ftp_arc_in_dir
                                                ,p_target_dir               => get_wc_date
                                                ,p_username                 => dir_rec.ftp_arc_username
                                                ,p_password                 => dir_rec.ftp_arc_password
                                                ,p_hostname                 => dir_rec.ftp_arc_host
                                                ,v_status                   => l_status
                                                ,v_error_message            => l_error
                                                );
--
         l_ftp := x_ftp_util.PUT( p_localpath => g_interpath
                                     ,p_filename => ftp_rec.tfq_filename
                                     ,p_remotepath => dir_rec.ftp_arc_in_dir || '/' || get_wc_date
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
                                        ,p_remotepath => dir_rec.ftp_arc_in_dir || '/' || get_wc_date
                                        ,p_username => dir_rec.ftp_arc_username
                                        ,p_password => dir_rec.ftp_arc_password
                                        ,p_hostname => dir_rec.ftp_arc_host
                                        ,v_status  => l_status
                                        ,v_error_message => l_error
                                        ,n_bytes_transmitted => l_bytes
                                        ,d_trans_start => l_trans_start
                                        ,d_trans_end => l_trans_end);
              -- now remove the file from the directory
              utl_file.fremove(g_interpath,ftp_rec.tfq_filename);
	      ins_log(pi_filename => ftp_rec.tfq_filename
                    , pi_message =>'Removed '||dir_rec.ftp_contractor||' file '||ftp_rec.tfq_filename||' from server');
            if not l_ftp
             then
               -- send an email
               send_email(pi_msg => 'ARCHIVE process. Status = ' ||l_status||' '||
                                    'Error: ' ||l_error||' '||
                                    'Bytes: ' ||l_bytes||' ');
               -- log the error
               ins_log(pi_filename => ftp_rec.tfq_filename
                  , pi_ftp_dir => dir_rec.ftp_in_dir
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
            , pi_ftp_dir => dir_rec.ftp_in_dir
            , pi_archive_dir => null
            , pi_message => 'ARCHIVE process. Status = ' ||l_status||' '||
                            'Error: ' ||l_error||' '||
                            'Bytes: ' ||l_bytes||' ');
      end loop;
   end loop;
end process_in_archive_queue;
--
-----------------------------------------------------------------------------
--
procedure process_out_queue
is
begin
   process_out_ftp_queue;
end process_out_queue;
--
-----------------------------------------------------------------------------
--
procedure process_in_queue
is
begin
   process_in_ftp_queue;
   process_in_load_queue;
   process_in_archive_queue;
end process_in_queue;
--
-----------------------------------------------------------------------------
--
procedure process_output_files
is
   cursor c_cons
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   l_filename varchar2(100);

   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;

   l_ftp boolean;
begin
   set_twis_action(pi_twis_action => 'TO');
   --
   -- not configured for outgoing as yet
   -- this is merely a placeholder
   --
   -- process out queue
   process_out_queue;


end process_output_files;
--
-----------------------------------------------------------------------------
--
function  get_list(pi_type varchar2
                  ,pi_remotepath x_ftp_dirs.FTP_IN_DIR%type
                  ,pi_username x_ftp_dirs.FTP_USERNAME%type
                  ,pi_password x_ftp_dirs.FTP_PASSWORD%type
                  ,pi_host x_ftp_dirs.FTP_HOST%type
                  )
return nm3type.tab_varchar32767
is
   l_file_list nm3type.tab_varchar32767;
   l_ftp boolean;
   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;
begin
   l_file_list := x_ftp_util.list(
                                    p_localpath         => g_interpath
                              ,     p_filename_filter   => '*'||pi_type||'.*'
                              ,     p_remotepath        => pi_remotepath
                              ,     p_username          => pi_username
                              ,     p_password          => pi_password
                              ,     p_hostname          => pi_host
                              ,     v_status            => l_status
                              ,     v_error_message     => l_error
                              ,     n_bytes_transmitted => l_bytes
                              ,     d_trans_start       => l_trans_start
                              ,     d_trans_end         => l_trans_end
                              );
   RETURN l_file_list;
end get_list;
--
-----------------------------------------------------------------------------
--
procedure process_input_files
is
   cursor c_cons
   is
   select *
   from x_ftp_dirs
   where ftp_type = 'TWIS';

   l_types nm3type.tab_varchar4;
   l_files nm3type.tab_varchar32767;

   l_status varchar2(100);
   l_error varchar2(800);
   l_bytes number;
   l_trans_start date;
   l_trans_end date;

begin
   l_types.delete;
   l_types(1) := 'TWIS';


   set_twis_action(pi_twis_action => 'TI');
   for con_rec in c_cons
    loop
      set_twis_id(pi_twis_id => con_rec.ftp_contractor);

      for i in 1..l_types.count
       loop
         set_twis_action(pi_twis_action => l_types(i));

         -- get list of files TWIS from the ftp site.
         l_files := get_list( pi_type => l_types(i)
                             ,pi_remotepath => con_rec.ftp_in_dir
                             ,pi_username => con_rec.ftp_username
                             ,pi_password => con_rec.ftp_password
                             ,pi_host => con_rec.ftp_host
                            );

         ins_log(pi_filename => null
            , pi_ftp_dir => null
            , pi_archive_dir => null
            , pi_message => 'Got list of ' ||l_types(i)|| ' files');

         -- put the list of files into the input queue
         for x in 1..l_files.count
          loop
           if con_rec.ftp_contractor = substr(l_files(x),1,5) then
            ins_in_queue( pi_twis_id =>  con_rec.ftp_contractor
                         ,pi_filename => l_files(x)
                        );
           end if;
         end loop;

      end loop;

   end loop;

   process_in_queue;

end process_input_files;
--
-----------------------------------------------------------------------------
--
procedure show_twis_log
is
begin
   dm3query.show_query_in_own_page(p_dq_title=>'x_twis_log');
end show_twis_log;
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
   htp.p('<title>exor WAG TWIS </title>');
   htp.p('</head>');
   htp.p('<body>');
   htp.br;
   htp.br;
   htp.p('<table border="0" width="100%">');
   htp.p('<tr>');
   htp.p('<td align="center"><h1><b>Exor WAG TWIS</font></b></h1></td>');
   htp.p('</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_twis.show_ftp_settings">FTP Settings</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_twis.show_ftp_queue">FTP Queue</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('		<tr>');
   htp.p('		<td align="center">');
   htp.p('		<h1><b><a href="x_twis.show_twis_log">Log Details</a></b></h1>');
   htp.p('		</td>');
   htp.p('	</tr>');
   htp.p('</table>');
   htp.p('</body>');
   htp.p('</html>');

end show_menu;
--
-----------------------------------------------------------------------------
--
procedure process_all_files
is
begin
   process_input_files;
   process_output_files;
end process_all_files;
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
   c_bare_what CONSTANT varchar2(62) :=  'x_twis.process_all_files;';
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
             ||CHR(10)||'-- This job is for the exor TWIS interface'
             ||CHR(10)||'-- '
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
END submit_do_all_processes_job;
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
END x_twis; 
/

