CREATE OR REPLACE PACKAGE BODY xact_pem_email_web AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/XACT/xact_pem_email_web.pkb-arc   3.0   Sep 26 2008 15:00:36   smarshall  $
--       Module Name      : $Workfile:   xact_pem_email_web.pkb  $
--       Date into PVCS   : $Date:   Sep 26 2008 15:00:36  $
--       Date fetched Out : $Modtime:   Sep 26 2008 14:34:26  $
--       PVCS Version     : $Revision:   3.0  $
--
--   Author : Kevin Angus
--
--   xact_pem_email_web body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
--all global package variables here

  --------
  --types
  -------
  
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision::   3.0      $';

  g_package_name CONSTANT varchar2(30) := 'xact_pem_email_web';
  
  c_write_email_proc constant varchar2(30) := 'write_mail';
  c_send_email_proc  constant varchar2(30) := 'send_mail';  
    
  c_nl constant varchar2(1) := chr(10);
  
  c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'XDOCWEB0010';
  c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
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
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : %W% %G%');
   htp.p('--       Module Name      : %M%');
   htp.p('--       Date into SCCS   : %E% %U%');
   htp.p('--       Date fetched Out : %D% %T%');
   htp.p('--       SCCS Version     : %I%');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author: Kevin Angus');
   htp.p('--');
   htp.p('--   xact_pem_email_web package.');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2006');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
FUNCTION strip_dad_reference(pi_filename IN varchar2
                            ) RETURN varchar2 IS
BEGIN
   -------------------------------------------------------------------
   --remove unique reference the gateway puts on the uploaded filename
   -------------------------------------------------------------------

   nm_debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'strip_dad_reference');

   nm_debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'strip_dad_reference');

   RETURN SUBSTR(pi_filename, INSTR(pi_filename, '/') + 1);

END strip_dad_reference;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_new_attachment(pi_pem_doc_id    in     docs.doc_id%type
                                ,pi_file_name     in     varchar2
                                --,po_new_file_name    out varchar2
                                ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_new_attachment');
  
  begin
    update
      nm_upload_files nuf
    set
      --nuf.name                   = po_new_file_name,
      nuf.nuf_nufg_table_name    = xact_pem_email.c_nuf_gateway,
      nuf.nuf_nufgc_column_val_1 = pi_pem_doc_id
    where
      nuf.name = pi_file_name;
      
  exception
    when dup_val_on_index
    then
      update
        nm_upload_files nuf
      set
        nuf.nuf_nufg_table_name    = xact_pem_email.c_nuf_gateway,
        nuf.nuf_nufgc_column_val_1 = pi_pem_doc_id
      where
        nuf.name = pi_file_name;
        
   end;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_new_attachment');

END process_new_attachment;
--
-----------------------------------------------------------------------------
--
procedure list_currently_attached(pi_pem_doc_id in docs.doc_id%type
                               ) IS

  l_filename_arr nm3type.tab_varchar2000;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'list_currently_attached');

  l_filename_arr := xact_pem_email.get_currently_attached(pi_pem_doc_id => pi_pem_doc_id);
  
  if l_filename_arr.count > 0
  then
    htp.tableopen(cborder => '0');
    htp.tablerowopen;
      htp.tableheader(cvalue => 'Currently Attached:');
    htp.tablerowclose;
    for i in 1..l_filename_arr.count
    loop
      htp.tablerowopen;
        htp.tabledata(cvalue => strip_dad_reference(l_filename_arr(i)));
      htp.tablerowclose;
    end loop;
    htp.tableclose;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'list_currently_attached');

END list_currently_attached;
--
-----------------------------------------------------------------------------
--
PROCEDURE attach_file(pi_pem_doc_id in docs.doc_id%type
                     ,pi_file_name  in varchar2 default null
                     ) IS

  c_proc_name       constant varchar2(30) := 'attach_file';
  
  c_file_name_param constant  varchar2(30) := 'pi_file_name';
  c_pem_doc_id_param constant varchar2(30) := 'pi_pem_doc_id';
  
  c_upload_form_name constant varchar2(30) := 'upload_form';
  
  --l_stripped_filename nm_upload_files.name%type;
  
  l_status_message varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => c_proc_name);

  nm3web.module_startup(c_this_module);

  ----------------------------
  --process upload of new file
  ----------------------------
  if pi_file_name is not null
  then
    process_new_attachment(pi_pem_doc_id    =>  pi_pem_doc_id
                          ,pi_file_name     => pi_file_name);
                          --,po_new_file_name => l_stripped_filename);
    l_status_message := 'File ' || strip_dad_reference(pi_file_name) || ' attached.';
  end if;
  
  -------------
  --create page
  -------------
  nm3web.head(p_title => c_module_title);
  
  sccs_tags;
  
  htp.header(1, 'Attachments to email for enquiry ' || to_char(pi_pem_doc_id));
  
  htp.p(l_status_message);
  
  list_currently_attached(pi_pem_doc_id => pi_pem_doc_id);
  
  htp.tableopen(cborder => 'border=0');

  htp.formopen(curl        => g_package_name || '.' || c_proc_name
              ,cenctype    => 'multipart/form-data'
              ,cattributes => 'name="' || c_upload_form_name || '"');

  htp.p('</td>');
  htp.tablerowclose;

  htp.tablerowopen;
  htp.tabledata('Filename:');
  htp.tabledata(htf.formfile(cname => c_file_name_param));
  htp.tablerowclose;

  htp.formhidden(cname => c_pem_doc_id_param
                ,cvalue => pi_pem_doc_id);

  htp.tabledata(htf.formsubmit(cvalue => 'Attach'));

  htp.formclose;

  htp.tableclose;
  
  nm3web.close;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => c_proc_name);

END attach_file;
--
-----------------------------------------------------------------------------
--
END xact_pem_email_web;
/
