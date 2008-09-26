CREATE OR REPLACE PACKAGE BODY xact_pem_email AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/XACT/xact_pem_email.pkb-arc   3.0   Sep 26 2008 15:00:36   smarshall  $
--       Module Name      : $Workfile:   xact_pem_email.pkb  $
--       Date into PVCS   : $Date:   Sep 26 2008 15:00:36  $
--       Date fetched Out : $Modtime:   Sep 26 2008 14:37:16  $
--       PVCS Version     : $Revision:   3.0  $
--
--   Author : Kevin Angus
--
--   xact_pem_email body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
--all global package variables here

  -------
  --types
  -------
  type t_blob_arr is table of blob index by pls_integer;
  
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid               CONSTANT varchar2(2000) := '$Revision::   3.0      $';

  g_package_name              CONSTANT varchar2(30) := 'xact_pem_email';
  
  c_pem_status_send_email     CONSTANT docs.doc_status_code%TYPE := 'SE';
  c_pem_status_email_sent     CONSTANT docs.doc_status_code%TYPE := 'ES';
  
  c_base_url_opt              constant hig_option_list.hol_id%type := 'XDOCTMPURL';
  c_default_reply_address_opt constant hig_option_list.hol_id%type := 'XDEFRPLADD';
  
  c_cr                        CONSTANT  varchar2(1) := CHR(13);
  c_lf                        CONSTANT  varchar2(1) := CHR(10);
  c_crlf                      CONSTANT  varchar2(2) := c_cr || c_lf;
  
  -----------
  --variables
  -----------
  g_mail_conn utl_smtp.connection;
  
  g_open_connection boolean := FALSE;
 
  g_doc_blob blob;
  
  g_debug_on boolean := FALSE;
--
-----------------------------------------------------------------------------
--
PROCEDURE db(pi_text IN varchar2
            ) IS
BEGIN
  IF g_debug_on
  THEN
    nm_debug.debug(pi_text);
  END IF;
END db;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_debug(pi_debug_on IN boolean DEFAULT TRUE
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_debug');

  IF pi_debug_on
  THEN
    g_debug_on := TRUE;
    nm_debug.debug_on;
  ELSE
    g_debug_on := FALSE;
    nm_debug.debug_off;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_debug');

END set_debug;
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
FUNCTION get_c_pem_status_send_email RETURN docs.doc_status_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_c_pem_status_send_email');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_c_pem_status_send_email');

  RETURN c_pem_status_send_email;

END get_c_pem_status_send_email;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pem_status_email_sent RETURN docs.doc_status_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_pem_status_email_sent');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_pem_status_email_sent');

  RETURN c_pem_status_email_sent;

END get_pem_status_email_sent;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_server IS

  PROCEDURE check_it (p_option VARCHAR2, p_value VARCHAR2) IS
  BEGIN
     IF p_value IS NULL
      THEN
        hig.raise_ner(pi_appl               => nm3type.c_hig
                     ,pi_id                 => 163
                     ,pi_supplementary_info => p_option);
     END IF;
     
  END check_it;
   
BEGIN
   check_it (nm3mail.g_server_sysopt,nm3mail.g_smtp_server);
   check_it (nm3mail.g_port_sysopt,nm3mail.g_smtp_port);
   check_it (nm3mail.g_domain_sysopt,nm3mail.g_smtp_domain);
   
END check_server;
--
-----------------------------------------------------------------------------
--
PROCEDURE open_smtp_connection IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'open_smtp_connection');

  IF NOT g_open_connection
  THEN
    db('Opening connection : '||nm3mail.g_smtp_server||' port '||nm3mail.g_smtp_port);
    g_mail_conn := utl_smtp.open_connection(nm3mail.g_smtp_server, nm3mail.g_smtp_port);
    db('Helo');
    utl_smtp.helo(g_mail_conn, nm3mail.g_smtp_domain);
    g_open_connection := TRUE;
    db('Connection open');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'open_smtp_connection');

END open_smtp_connection;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_smtp_connection IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'close_smtp_connection');

  IF g_open_connection
  THEN
    db('Closing connection');
    utl_smtp.quit(g_mail_conn);
    g_open_connection := FALSE;
    db('Connection closed');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'close_smtp_connection');

END close_smtp_connection;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sender(pi_sender_username in user_users.username%type
                   ) RETURN nm_mail_users%rowtype IS

  l_retval nm_mail_users%rowtype;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_sender');

  select
    nmu.*
  into
    l_retval
  from
    nm_mail_users nmu,
    hig_users     hus
  where
    hus.hus_username = pi_sender_username
  and
    hus.hus_user_id = nmu.nmu_hus_user_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_sender');

  RETURN l_retval;

exception
  when no_data_found
  then
    raise_application_error(-20000
                           ,'No mail user found for Highways user ' || pi_sender_username);
  
  when too_many_rows
  then
    raise_application_error(-20000
                           ,'More than one mail user found for Highways user ' || pi_sender_username);

END get_sender;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_data (p_text     IN varchar2,p_crlf boolean DEFAULT TRUE) IS
   l_text nm3type.max_varchar2 := NVL(p_text,' ');
BEGIN
   l_text := REPLACE(l_text,c_lf,c_crlf);          -- replace all CHR(10) with CHR(13)||CHR(10)
   l_text := REPLACE(l_text,c_cr||c_crlf,c_crlf);  -- this will leave the propect of CHR(13)||CHR(13)||CHR(10) (if c_crlf was in there originally)
                                                   --  - so change them back to CHR(13)||CHR(10)
   IF p_crlf
    THEN
      utl_smtp.write_data(g_mail_conn,l_text||c_crlf);
   ELSE
      utl_smtp.write_data(g_mail_conn,l_text);
   END IF;
END write_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_mime_header(conn  IN OUT NOCOPY utl_smtp.connection
                           ,name  IN VARCHAR2
                           ,value IN VARCHAR2) IS
BEGIN
  utl_smtp.write_data(conn, name || ': ' || value || utl_tcp.CRLF);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_boundary(conn  IN OUT NOCOPY utl_smtp.connection
	                      ,last  IN            BOOLEAN DEFAULT FALSE) AS
BEGIN
  IF (last) THEN
    utl_smtp.write_data(conn, c_LAST_BOUNDARY);
  ELSE
    utl_smtp.write_data(conn, c_FIRST_BOUNDARY);
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection
                          ,mime_type    IN VARCHAR2 DEFAULT 'text/plain'
                          ,inline       IN BOOLEAN  DEFAULT TRUE
                          ,filename     IN VARCHAR2 DEFAULT NULL
                          ,transfer_enc IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  write_boundary(conn);
  write_mime_header(conn, 'Content-Type', mime_type);

  IF (filename IS NOT NULL)
  THEN
     IF (inline)
     THEN
       write_mime_header(conn, 'Content-Disposition', 'inline; filename="'||filename||'"');
     ELSE
       write_mime_header(conn, 'Content-Disposition', 'attachment; filename="'||filename||'"');
     END IF;
  END IF;

  IF (transfer_enc IS NOT NULL)
  THEN
    write_mime_header(conn, 'Content-Transfer-Encoding', transfer_enc);
  END IF;
    
  utl_smtp.write_data(conn, utl_tcp.CRLF);
END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
			   last IN BOOLEAN DEFAULT FALSE) IS
BEGIN
  utl_smtp.write_data(conn, utl_tcp.CRLF);
  IF (last) THEN
    write_boundary(conn, last);
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_doc_details(pi_doc_id                 in     docs.doc_id%type
                         ,po_doc_filename              out varchar2
                         ,po_doc_location              out doc_locations.dlc_pathname%type
                          ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_doc_details');

  select
    docs.doc_file || '.' || lower(dmd.dmd_file_extension),
    dlc.dlc_pathname
  into
    po_doc_filename,
    po_doc_location
  from
    docs,
    doc_locations          dlc,
    doc_media              dmd
  where
    docs.doc_id = pi_doc_id
  and
    docs.doc_dlc_id = dlc.dlc_id
  and
    docs.doc_dlc_dmd_id = dmd.dmd_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_doc_details');

exception
  when no_data_found
  then
    raise_application_error(-20000
                           ,'No document found for doc_id ' || pi_doc_id);
  
  when too_many_rows
  then
    raise_application_error(-20000
                           ,'More than one document found for doc_id ' || pi_doc_id);

END get_doc_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_currently_attached(pi_pem_doc_id in docs.doc_id%type
                               ) RETURN nm3type.tab_varchar2000 IS

  l_filename_arr nm3type.tab_varchar2000;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_currently_attached');

  select
    xact_pem_email_web.strip_dad_reference(nuf.name)
  bulk collect into
    l_filename_arr
  from
    nm_upload_files nuf
  where
    nuf.nuf_nufg_table_name = c_nuf_gateway
  and
    nuf.nuf_nufgc_column_val_1 = pi_pem_doc_id;

  --for i in 1..l_filename_arr.count
  --loop
  --  l_filename_arr(i) := xact_pem_email_web.strip_dad_reference(l_filename_arr(i));
  --end loop;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_currently_attached');  
  
  RETURN l_filename_arr;

END get_currently_attached;
--
-----------------------------------------------------------------------------
--
PROCEDURE attach_blob(pi_blob      in blob 
                     ,pi_file_name in varchar2
                     ,pi_mime_type in varchar2
                     ,pi_last      in boolean default false
                     ) IS
                     
  l_buf raw(2100);
  l_amt pls_integer := c_MAX_BASE64_LINE_WIDTH;
  l_offset pls_integer := 1;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'attach_doc');

  db('attach_blob');

  db('begin_attachment');
  begin_attachment(conn         => g_mail_conn
                  ,mime_type    => pi_mime_type
                  ,filename     => pi_file_name
                  ,transfer_enc => 'base64');
       
  db('write raw data');           
  begin
    LOOP
      dbms_lob.read(lob_loc => pi_blob
                   ,amount  => l_amt
                   ,offset  => l_offset
                   ,buffer  => l_buf);
                   
      utl_smtp.write_raw_data(g_mail_conn
                             ,utl_encode.base64_encode(l_buf));
        
      l_offset := l_offset +  c_MAX_BASE64_LINE_WIDTH;
    END LOOP;
    
  exception
    when no_data_found
    then
      --end of file
      null;
  end;
    
  db('end attachment');
  end_attachment(conn => g_mail_conn
                ,last => pi_last);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'attach_blob');

END attach_blob;
--
-----------------------------------------------------------------------------
--
PROCEDURE attach_nufs(pi_pem_doc_id in docs.doc_id%type
                     ,pi_last       in boolean default false
                          ) IS

  l_filename_arr  nm3type.tab_varchar2000;
  l_mime_type_arr nm3type.tab_varchar2000;
  l_file_arr      t_blob_arr;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'attach_nufs');

  select
    nuf.name,
    nuf.mime_type,
    nuf.blob_content
  bulk collect into
    l_filename_arr,
    l_mime_type_arr,
    l_file_arr
  from
    nm_upload_files nuf
  where
    nuf.nuf_nufg_table_name = c_nuf_gateway
  and
    nuf.nuf_nufgc_column_val_1 = pi_pem_doc_id;

  for i in 1..l_filename_arr.count
  loop
    attach_blob(pi_blob      => l_file_arr(i)
               ,pi_file_name => xact_pem_email_web.strip_dad_reference(l_filename_arr(i))
               ,pi_mime_type => l_mime_type_arr(i)
               ,pi_last      => pi_last and i = l_filename_arr.count);
  end loop;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'attach_nufs');

END attach_nufs;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_file_from_web(pi_url   in            varchar2
                           ,pio_file in out nocopy blob
                          ) is
                          
  l_file_pieces_arr utl_http.html_pieces;
  
BEGIN
  db('requesting ' || pi_url);
  l_file_pieces_arr := utl_http.request_pieces(pi_url);
  
  db('got ' || l_file_pieces_arr.count || ' pieces.');
  
  FOR i in 1..l_file_pieces_arr.count
  LOOP
    dbms_lob.writeappend(lob_loc => pio_file
                        ,amount => length(l_file_pieces_arr(i))
                        ,buffer => utl_raw.cast_to_raw(l_file_pieces_arr(i)));
  END LOOP;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_file_url(pi_filename in varchar2
                     ) RETURN varchar2 IS

  c_base_url CONSTANT varchar2(2000) := hig.get_sysopt(p_option_id => c_base_url_opt);
  
  l_retval varchar2(2000) := c_base_url;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_file_url');

  IF substr(l_retval, length(l_retval), 1) <> '/'
  THEN
    l_retval := l_retval || '/';
  end if;

  l_retval := nm3web.string_to_url(pi_str => l_retval || pi_filename);

  db('get_file_url returning: ' || l_retval);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_file_url');

  RETURN l_retval;

END get_file_url;
--
-----------------------------------------------------------------------------
--
PROCEDURE attach_doc(pi_doc_id in docs.doc_id%type
                    ,pi_last   in boolean default false
                     ) IS

  l_doc_filename           varchar2(255);
  l_doc_location           doc_locations.dlc_pathname%type;

  l_file_blob blob default empty_blob();

  l_buf raw(2100);

  l_amt pls_integer := c_MAX_BASE64_LINE_WIDTH;
  l_offset pls_integer := 1;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'attach_doc');

  db('attach_doc');
  
  get_doc_details(pi_doc_id                 => pi_doc_id
                 ,po_doc_filename           => l_doc_filename
                 ,po_doc_location           => l_doc_location);
             
  db('l_doc_filename = ' || l_doc_filename);
  db('l_doc_location = ' || l_doc_location);
      
  DBMS_LOB.CREATETEMPORARY(l_file_blob, true);
  
  get_file_from_web(pi_url   => get_file_url(pi_filename => l_doc_filename)
                   ,pio_file => l_file_blob);
  
  db('begin_attachment');
  begin_attachment(conn         => g_mail_conn
                  ,mime_type    => 'application/msword'
                  ,filename     => l_doc_filename
                  ,transfer_enc => 'base64');
       
  db('write raw data');           
  begin
    LOOP
      dbms_lob.read(lob_loc => l_file_blob
                   ,amount  => l_amt
                   ,offset  => l_offset
                   ,buffer  => l_buf);
      
      utl_smtp.write_raw_data(g_mail_conn
                             ,utl_encode.base64_encode(l_buf));
        
      l_offset := l_offset +  c_MAX_BASE64_LINE_WIDTH;
    END LOOP;
    
  exception
    when no_data_found
    then
      --end of file
      null;
  end;
    
  db('end attachment');
  end_attachment(conn => g_mail_conn
                ,last => pi_last);

  DBMS_LOB.freeTEMPORARY(l_file_blob);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'attach_doc');

END attach_doc;
--
-----------------------------------------------------------------------------
--
-- Return the next email address in the list of email addresses, separated
  -- by either a "," or a ";".  The format of mailbox may be in one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
 FUNCTION get_address(addr_list IN OUT VARCHAR2) RETURN VARCHAR2 IS

   addr VARCHAR2(256);
   i    pls_integer;

   FUNCTION lookup_unquoted_char(str  IN VARCHAR2,
			  chrs IN VARCHAR2) RETURN pls_integer AS
     c            VARCHAR2(5);
     i            pls_integer;
     len          pls_integer;
     inside_quote BOOLEAN;
   BEGIN
      inside_quote := false;
      i := 1;
      len := length(str);
      WHILE (i <= len) LOOP

 c := substr(str, i, 1);

 IF (inside_quote) THEN
   IF (c = '"') THEN
     inside_quote := false;
   ELSIF (c = '\') THEN
     i := i + 1; -- Skip the quote character
   END IF;
   GOTO next_char;
 END IF;
	 
 IF (c = '"') THEN
   inside_quote := true;
   GOTO next_char;
 END IF;
      
 IF (instr(chrs, c) >= 1) THEN
    RETURN i;
 END IF;
      
 <<next_char>>
 i := i + 1;

      END LOOP;
    
      RETURN 0;
    
   END;

 BEGIN

   addr_list := ltrim(addr_list);
   i := lookup_unquoted_char(addr_list, ',;');
   IF (i >= 1) THEN
     addr      := substr(addr_list, 1, i - 1);
     addr_list := substr(addr_list, i + 1);
   ELSE
     addr := addr_list;
     addr_list := '';
   END IF;
   
   i := lookup_unquoted_char(addr, '<');
   IF (i >= 1) THEN
     addr := substr(addr, i + 1);
     i := instr(addr, '>');
     IF (i >= 1) THEN
addr := substr(addr, 1, i - 1);
     END IF;
   END IF;

   RETURN addr;
 END;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_pem_status(pi_pem_doc_id in docs.doc_id%type
                        ,pi_status     in docs.doc_status_code%type
                        ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_pem_status');

  update
    docs
  set
    docs.doc_status_code = pi_status
  where
    docs.doc_id = pi_pem_doc_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_pem_status');

END set_pem_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_attached_nufs(pi_pem_doc_id in docs.doc_id%type
                           ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'del_attached_nufs');

  delete
    nm_upload_files nuf
  where
    nuf.nuf_nufg_table_name = c_nuf_gateway
  and
    nuf.nuf_nufgc_column_val_1 = pi_pem_doc_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'del_attached_nufs');

END del_attached_nufs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_email_date RETURN varchar2 IS

  l_retval varchar2(50);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_email_date');

  --set the session time zone to the same as the OS 
  execute immediate 'ALTER SESSION SET time_zone = local';
  
  db('Session time zone set to ' || sessiontimezone);
  
  l_retval :=    TO_CHAR(sysdate, 'dd Mon yyyy hh24:mi:ss')
              || ' ' || replace(sessiontimezone, ':', '');
  
  db('Email date: ' || l_retval);
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_email_date');

  RETURN l_retval;

END get_email_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_mail(pi_pem_doc_id    in docs.doc_id%type
                   --,pi_from          in t_addr
                   ,pi_to            in varchar2
                   ,pi_cc            in varchar2
                   ,pi_doc_id        in docs.doc_id%type
                   ,pi_subject       in varchar2
                   ,pi_message       in varchar2
                   ,pi_mark_pem_sent in boolean default true
                   ) IS

  e_no_recipients exception;
  
  c_default_reply_address constant hig_option_values.hov_value%type
    := hig.get_sysopt(p_option_id => c_default_reply_address_opt);
  
  l_to nm3type.max_varchar2 := pi_to;
  l_cc nm3type.max_varchar2 := pi_cc;
  
  l_attached_file_Names_arr nm3type.tab_varchar2000 := get_currently_attached(pi_pem_doc_id => pi_pem_doc_id);

BEGIN
  db('xact_pem_email.send_mail');
  
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'send_mail');

  If pi_to is null
  then
    raise e_no_recipients;
  end if;

  db('Checking server');
  check_server;

  db('Opening connection');
  open_smtp_connection;
  
  db('mail ' || c_default_reply_address);
  utl_smtp.mail(g_mail_conn, c_default_reply_address);
  
  WHILE (l_to IS NOT NULL)
  LOOP
    utl_smtp.rcpt(g_mail_conn, get_address(l_to));
  END LOOP;
  
  WHILE (l_cc IS NOT NULL)
  LOOP
    utl_smtp.rcpt(g_mail_conn, get_address(l_cc));
  END LOOP;
  
  db('open data');
  utl_smtp.open_data(g_mail_conn);

  db('writing headers');
  --db('Date:' || get_email_date);
  --write_data('Date:' || get_email_date);
  write_data('Subject:' || pi_subject);
  write_data('From:' || c_default_reply_address);
  write_data('To:' || pi_to);
  write_data('CC:' || pi_cc);
  write_data('Content-Type:' || c_MULTIPART_MIME_TYPE);
  
  db('write_data(c_crlf);');
  write_data(c_crlf);
  
  write_data('This is a multi-part message in MIME format.');
  
  --------------
  --message text
  --------------
  begin_attachment(conn         => g_mail_conn
                  ,mime_type    => 'text/plain'
                  ,transfer_enc => NULL);
                  
  write_data(pi_message);
  
  end_attachment(conn => g_mail_conn);
  
  --attach generated doc
  attach_doc(pi_doc_id => pi_doc_id
            ,pi_last   => l_attached_file_Names_arr.count = 0);
           
  --attach any other files 
  attach_nufs(pi_pem_doc_id => pi_pem_doc_id
             ,pi_last       => TRUE);
  
  db('utl_smtp.close_data (g_mail_conn);');
  utl_smtp.close_data(g_mail_conn);
  
  db('closing');
  close_smtp_connection;
  
  db('deleting attached nufs');
  del_attached_nufs(pi_pem_doc_id  => pi_pem_doc_id);
  
  if pi_mark_pem_sent
  then
    db('setting pem status to email sent');
    set_pem_status(pi_pem_doc_id => pi_pem_doc_id
                  ,pi_status     => c_pem_status_email_sent);
  end if;
  
  db('done');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'send_mail');

exception
  when e_no_recipients
  then
    raise_application_error(-20000
                           ,'No recipients specified.');
  
  WHEN utl_smtp.transient_error
    OR utl_smtp.permanent_error
  THEN
    db('utl_smtp error');
    db(sqlerrm);
    BEGIN
      close_smtp_connection;
    EXCEPTION
      WHEN utl_smtp.transient_error
        OR utl_smtp.permanent_error
      THEN
        NULL; -- When the SMTP server is down or unavailable, we don't have
              -- a connection to the server. The quit call will raise an
              -- exception that we can ignore.
    END;
    raise_application_error(-20000
                           ,'Failed to send mail due to the following error: ' || sqlerrm);
  
  WHEN others
  THEN
    db('others error');
    db(sqlerrm);
    DECLARE
      l_err_text nm3type.max_varchar2;
    BEGIN
      l_err_text := dbms_utility.format_error_stack;
      BEGIN
        close_smtp_connection;
      EXCEPTION
        WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
          NULL; -- When the SMTP server is down or unavailable, we don't have
                -- a connection to the server. The quit call will raise an
                -- exception that we can ignore.
      END;
      raise_application_error(-20000
                            ,l_err_text);
    END;

END send_mail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_details_marker RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_details_marker');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_details_marker');

  RETURN c_details_marker;

END get_details_marker;
--
-----------------------------------------------------------------------------
--
FUNCTION get_email_text RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_email_text');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_email_text');

  RETURN c_email_text;

END get_email_text;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nuf_gateway RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_nuf_gateway');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_nuf_gateway');

  RETURN c_nuf_gateway;

END get_nuf_gateway;
--
-----------------------------------------------------------------------------
--
END xact_pem_email;
/
