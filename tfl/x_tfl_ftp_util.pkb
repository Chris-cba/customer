CREATE OR REPLACE PACKAGE BODY HIGHWAYS.x_tfl_ftp_util
AS

--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/x_tfl_ftp_util.pkb-arc   2.1   Jul 15 2009 08:15:46   Ian Turnbull  $
--       Module Name      : $Workfile:   x_tfl_ftp_util.pkb  $
--       Date into SCCS   : $Date:   Jul 15 2009 08:15:46  $
--       Date fetched Out : $Modtime:   Jul 14 2009 13:25:24  $
--       SCCS Version     : $Revision:   2.1  $
--
--
--   Author : Ian Turnbull
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--

/*
   * VERSION HISTORY
   *  --------------------
   *  1.0     11/19/2002    Unit-tested single and multiple transfers between disparate hosts.
   *  1.0     01/18/2003    Began testing code as proof of concept under 8i.
   *                        As delivered the code did not work correctly for our 8i environment
   *  1.1     03/03/2003    Left package on the shelf to gather dust for awhile.
   *                        Modified login code. Kept failing for some reason.
   *                        Removed multiple file support. Couldn't seem to make it work right.
   *                        Added time_out setting which terminates session if it exceeds 4 minutes
   *                        Added functionality for remove and rename, and sending different filename
   *
   *                          -- To process a file as a different name use the # symbol
   *                          -- test.txt#test.txt20032801
   *                          -- Would be used if you wanted to send the file test.txt
   *                             but copy to remote server as test.txt20032801
   *
   *  2.0      03/01/2004  Upgraded script to support Oracle 9.2.x.x features
   *                       Requires that DBA_DIRECTORIES be utilitized
   *                       meaning that instead of passing local path
   *                       as a path, you must use your defined DBA_DIRECTORY
   *                       values e.g. INTF0047_TABLES is defined as /xfer/INTF0047
   *
   *                        Added binary support
   *                        Added MVS mainframe support
   *
   *  2.1.0    14-AUG-2006 QUOTE SITE command for mainframe was not working. Corrected same.
   *                       Additionally, expanded QUOTE SITE command to permit multiple
   *                       commands to be submitted separated by a | delimiter.
   *
   *                       Added dir and ls functionality
   *
   *  3.0.0    30-AUG-2006 Added some debugging code. Streamlined logic in FTP_FILES_STAGE procedure
   *
   *  3.1.0    15-SEP-2006 Added CLOB / BLOB support and Server Type identification
   *                       Added RMDIR and MKDIR commands for remote server access
   *
   *  3.1.1    22-SEP-2006 Fixed handling of ASCII transfers where carriage return was being captured
   *
   *  3.1.2    22-SEP-2006 Changed logic for current remote path logic on non-mainframe connections
   *                       where we picked up path using PWD command and then performed a CWD
   *                 	   we had to change because the humad\* accounts with backwards slash
   *                 	   throws the routine off. LTRIM RTRIM was changed to substr and instr
   *					   commands.
   *
   *  3.1.3    14-JUL-2009 Updated ftp_files_stage procedure, added call to raise inavalid transfer 
   *  P Stanton            exception, previous version caught the error and sent it back to the calling 
   *                       procedure but returned True to the calling procedure not FALSE.
*/
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"%W% %G%"';

  g_package_name CONSTANT varchar2(30) := 'x_tfl_cim';


   TYPE tstringtable IS TABLE OF VARCHAR2 ( 2000 );

   TYPE tserverreply IS RECORD (
      rpt                           CHAR
,     code                          VARCHAR2 ( 3 )
,     MESSAGE                       VARCHAR2 ( 256 )
   );

   TYPE tserverreplya IS TABLE OF tserverreply;

   TYPE tconnectinfo IS RECORD (
      ip                            VARCHAR2 ( 22 )
,     port                          PLS_INTEGER
   );

   /* Package variables used repeatedly throughout the body. */
   len_string                    NUMBER;
   start_loc                     NUMBER;
   next_loc                      NUMBER;
   /*
   || Since the PUT_LINE procedure regards a string of one or more
   || spaces as NULL, it will not display a space, which is in
   || PS_Parse a valid atomic. So I save a_blank in the PL/SQL
   || table instead of the space itself.
   */
   a_blank              CONSTANT VARCHAR2 ( 3 ) := '" "';


--
-- WRITECOMMAND
--
-- Sends instruction to remote server
--
   FUNCTION writecommand (
      a_conn                     IN       utl_tcp.connection
,     a_command                  IN       VARCHAR2 )
      RETURN tserverreplya
   IS
      v_conn                        utl_tcp.connection;
      v_str                         VARCHAR2 ( 500 );
      v_bytes_written               NUMBER;
      v_reply                       tserverreplya;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                            := 'x_tfl_ftp_util.WRITECOMMAND';
   BEGIN
      v_reply := tserverreplya ( );
      v_conn := a_conn;

      IF a_command IS NOT NULL
      THEN
         v_bytes_written := utl_tcp.write_line ( v_conn, a_command );
      END IF;

      v_conn := a_conn;

      WHILE 1 = 1
      LOOP
         v_str := utl_tcp.get_line ( v_conn, TRUE );
         v_reply.EXTEND;
         v_reply ( v_reply.COUNT ).code := SUBSTR ( v_str
,                                                   1
,                                                   3 );
         v_reply ( v_reply.COUNT ).rpt := SUBSTR ( v_str
,                                                  4
,                                                  1 );
         v_reply ( v_reply.COUNT ).MESSAGE := SUBSTR ( v_str, 5 );

         IF v_reply ( v_reply.COUNT ).rpt = ' '
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF SUBSTR ( v_reply ( v_reply.COUNT ).code
,                 1
,                 1 ) = '5'
      THEN
         raise_application_error ( -20000
,                                  'WriteCommand: ' || v_str
,                                  TRUE );
      END IF;

      RETURN v_reply;
   END;

--
-- LOGIN
--
-- Opens connection with remote server
--
   FUNCTION login (
      a_site_in                  IN       VARCHAR2
,     a_port_in                  IN       VARCHAR2
,     a_user_name                IN       VARCHAR2
,     a_user_pass                IN       VARCHAR2 )
      RETURN utl_tcp.connection
   IS
      v_conn                        utl_tcp.connection;
      v_reply                       tserverreplya;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                   := 'HUM_FTP_INTERFACE.LOGIN';
   BEGIN
      v_conn :=
         utl_tcp.open_connection ( remote_host =>                   a_site_in
,                                  remote_port =>                   a_port_in
,                                  tx_timeout =>                    tx_timeout );
      v_reply := writecommand ( v_conn, NULL );

      IF v_reply ( v_reply.COUNT ).code <> '220'
      THEN
         utl_tcp.close_all_connections;
         raise_application_error ( -20001
,                                     'Login: '
                                   || v_reply ( v_reply.COUNT ).code
                                   || ' '
                                   || v_reply ( v_reply.COUNT ).MESSAGE
,                                  TRUE );
         RETURN v_conn;
      END IF;

      v_reply := writecommand ( v_conn, 'USER ' || a_user_name );

      IF SUBSTR ( v_reply ( v_reply.COUNT ).code
,                 1
,                 1 ) = '5'
      THEN
         utl_tcp.close_all_connections;
         raise_application_error ( -20000
,                                     'Login: '
                                   || v_reply ( v_reply.COUNT ).code
                                   || ' '
                                   || v_reply ( v_reply.COUNT ).MESSAGE
,                                  TRUE );
         RETURN v_conn;
      END IF;

      IF v_reply ( v_reply.COUNT ).code <> '331'
      THEN
         utl_tcp.close_all_connections;
         raise_application_error ( -20001
,                                     'Login: '
                                   || v_reply ( v_reply.COUNT ).code
                                   || ' '
                                   || v_reply ( v_reply.COUNT ).MESSAGE
,                                  TRUE );
         RETURN v_conn;
      END IF;

      v_reply := writecommand ( v_conn, 'PASS ' || a_user_pass );

      IF SUBSTR ( v_reply ( v_reply.COUNT ).code
,                 1
,                 1 ) = '5'
      THEN
         utl_tcp.close_all_connections;
         raise_application_error ( -20000
,                                     'Login: '
                                   || v_reply ( v_reply.COUNT ).code
                                   || ' '
                                   || v_reply ( v_reply.COUNT ).MESSAGE
,                                  TRUE );
         RETURN v_conn;
      END IF;

      IF v_reply ( v_reply.COUNT ).code <> '230'
      THEN
         utl_tcp.close_all_connections;
         raise_application_error ( -20001
,                                     'Login: '
                                   || v_reply ( v_reply.COUNT ).code
                                   || ' '
                                   || v_reply ( v_reply.COUNT ).MESSAGE
,                                  TRUE );
         RETURN v_conn;
      END IF;

      RETURN v_conn;
   END;

--
-- PRINT_OUTPUT
--
-- This prints information to DBMS_OUTPUT, but avoids the buffer limit of 255 per
-- line of DBMS_OUTPUT.
--
   PROCEDURE print_output (
      p_message                  IN       VARCHAR2 )
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                            := 'HUM_FTP_INTERFACE.PRINT_OUTPUT';
   BEGIN
      dbms_output.put_line ( SUBSTR ( p_message
,                                     1
,                                     250 ));

      IF LENGTH ( p_message ) > 250
      THEN
         dbms_output.put_line ( SUBSTR ( p_message
,                                        251
,                                        250 ));
      END IF;

      IF LENGTH ( p_message ) > 501
      THEN
         dbms_output.put_line ( SUBSTR ( p_message
,                                        501
,                                        250 ));
      END IF;

      IF LENGTH ( p_message ) > 751
      THEN
         dbms_output.put_line ( SUBSTR ( p_message
,                                        751
,                                        250 ));
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;               -- Ignore errors... protect buffer overflow's etc.
   END print_output;

--
-- CREATE_PASV
--
-- Create the passive host IP and port number to connect to
--
   PROCEDURE create_pasv (
      p_pasv_cmd                 IN       VARCHAR2
,     p_pasv_host                OUT      VARCHAR2
,     p_pasv_port                OUT      NUMBER )
   IS
      v_pasv_cmd                    VARCHAR2 ( 30 ) := p_pasv_cmd;
      --Host and port to connect to for data transfer
      n_port_dec                    NUMBER;
      n_port_add                    NUMBER;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                             := 'HUM_FTP_INTERFACE.CREATE_PASV';
   BEGIN
      p_pasv_host :=
         REPLACE ( SUBSTR ( v_pasv_cmd
,                           1
,                           INSTR ( v_pasv_cmd
,                                   ','
,                                   1
,                                   4 ) - 1 )
,                  ','
,                  '.' );
      n_port_dec :=
         TO_NUMBER ( SUBSTR ( v_pasv_cmd
,                             INSTR ( v_pasv_cmd
,                                     ','
,                                     1
,                                     4 ) + 1
,                             (   INSTR ( v_pasv_cmd
,                                         ','
,                                         1
,                                         5 )
                                - ( INSTR ( v_pasv_cmd
,                                           ','
,                                           1
,                                           4 ) + 1 ))));
      n_port_add :=
         TO_NUMBER ( SUBSTR ( v_pasv_cmd
,                             INSTR ( v_pasv_cmd
,                                     ','
,                                     1
,                                     5 ) + 1
,                               LENGTH ( v_pasv_cmd )
                              - INSTR ( v_pasv_cmd
,                                       ','
,                                       1
,                                       5 )));
      p_pasv_port := ( n_port_dec * 256 ) + n_port_add;
--       print_output (   'p_pasv_host= '
--                             || p_pasv_host);
--       print_output (   'n_port_dec= '
--                             || n_port_dec);
--       print_output (   'n_port_add= '
--                             || n_port_add);
--       print_output (   'p_pasv_port= '
--                             || p_pasv_port);
   EXCEPTION
      WHEN OTHERS
      THEN
         --print_output(SQLERRM);
         RAISE;
   END create_pasv;

--
-- VALIDATE_REPLY
--
-- Read a single or multi-line reply from the FTP server and VALIDATE
-- it against the code passed in p_code.
--
-- Return TRUE if reply code matches p_code, FALSE if it doesn't or error
-- occurs
--
-- Send full server response back to calling procedure
--
   FUNCTION validate_reply (
      p_ctrl_con                 IN OUT   utl_tcp.connection
,     p_code                     IN       PLS_INTEGER
,     p_reply                    OUT      VARCHAR2 )
      RETURN BOOLEAN
   IS
      n_code                        VARCHAR2 ( 3 ) := p_code;
      n_byte_count                  PLS_INTEGER;
      v_msg                         VARCHAR2 ( 1000 );
      n_line_count                  PLS_INTEGER := 0;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                          := 'HUM_FTP_INTERFACE.VALIDATE_REPLY';
   BEGIN
      LOOP
         v_msg := utl_tcp.get_line ( p_ctrl_con );
         n_line_count := n_line_count + 1;

         IF n_line_count = 1
         THEN
            p_reply := v_msg;
         ELSE
            p_reply := p_reply || SUBSTR ( v_msg, 4 );
         END IF;

         EXIT WHEN INSTR ( v_msg
,                          '-'
,                          1
,                          1 ) <> 4;
      END LOOP;

--       print_output('n_code := ' || n_code);
--       print_output('p_reply := ' || TO_NUMBER (SUBSTR (p_reply
--  ,                           1
--  ,                           3)));
      IF TO_NUMBER ( SUBSTR ( p_reply
,                             1
,                             3 )) = n_code
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_reply := SQLERRM;
         RETURN FALSE;
   END validate_reply;

--
-- VALIDATE_REPLY
--
-- Read a single or multi-line reply from the FTP server and VALIDATE
-- it against the code passed in p_code.
--
-- Return TRUE if reply code matches p_code1 or p_code2, FALSE if it doesn't or error
-- occurs
--
-- Send full server response back to calling procedure
--
   FUNCTION validate_reply (
      p_ctrl_con                 IN OUT   utl_tcp.connection
,     p_code1                    IN       PLS_INTEGER
,     p_code2                    IN       PLS_INTEGER
,     p_reply                    OUT      VARCHAR2 )
      RETURN BOOLEAN
   IS
      v_code1                       VARCHAR2 ( 3 ) := TO_CHAR ( p_code1 );
      v_code2                       VARCHAR2 ( 3 ) := TO_CHAR ( p_code2 );
      v_msg                         VARCHAR2 ( 1000 );
      n_line_count                  PLS_INTEGER := 0;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                          := 'HUM_FTP_INTERFACE.VALIDATE_REPLY';
   BEGIN
      LOOP
         v_msg := utl_tcp.get_line ( p_ctrl_con );
         n_line_count := n_line_count + 1;

         IF n_line_count = 1
         THEN
            p_reply := v_msg;
         ELSE
            p_reply := p_reply || SUBSTR ( v_msg, 4 );
         END IF;

         EXIT WHEN INSTR ( v_msg
,                          '-'
,                          1
,                          1 ) <> 4;
      END LOOP;

      IF TO_NUMBER ( SUBSTR ( p_reply
,                             1
,                             3 )) IN ( v_code1, v_code2 )
      THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_reply := SQLERRM;
         RETURN FALSE;
   END validate_reply;

--
-- TRANSFER_DATA
--
-- Handles actual data transfer.  Responds with status, error message, and
-- transfer statistics.
--
-- Potential errors could be with connection or file i/o
--
   PROCEDURE transfer_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection
,     p_localpath                IN       VARCHAR2
,     p_filename                 IN       VARCHAR2
,     p_filetype                 IN       VARCHAR2
,     p_pasv_host                IN       VARCHAR2
,     p_pasv_port                IN       PLS_INTEGER
,     p_transfer_mode            IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE )
   IS
      l_amount                      PLS_INTEGER;
      u_filehandle                  utl_file.file_type;
      v_tsfr_mode                   VARCHAR2 ( 30 ) := p_transfer_mode;
      v_mode                        VARCHAR2 ( 1 );
      v_tsfr_cmd                    VARCHAR2 ( 10 );
      v_buffer                      VARCHAR2 ( 32767 );
      v_buffer_header1              VARCHAR2 ( 32767 );
      v_buffer_header2              VARCHAR2 ( 32767 );
      v_localpath                   VARCHAR2 ( 255 ) := p_localpath;
      v_filename                    VARCHAR2 ( 255 ) := p_filename;
      v_filenamefr                  VARCHAR2 ( 255 ) := p_filename;
      v_filenameto                  VARCHAR2 ( 255 ) := p_filename;
      v_host                        VARCHAR2 ( 20 ) := p_pasv_host;
      n_port                        PLS_INTEGER := p_pasv_port;
      n_bytes                       NUMBER;
      l_longdir_line_cnt            PLS_INTEGER := 0;
      l_header_displayed            PLS_INTEGER := 0;
      v_msg                         VARCHAR2 ( 1000 );
      v_reply                       VARCHAR2 ( 1000 );
      v_err_status                  VARCHAR2 ( 20 ) := 'ERROR';
      v_database_directory          VARCHAR2 ( 100 );
      p_data_clob                   CLOB;
      p_data_blob                   BLOB;
      l_step                        VARCHAR2 ( 1000 );
      l_filename_search             VARCHAR2 ( 1000 );
      c_process            CONSTANT VARCHAR2 ( 100 )
                                           := 'HUM_FTP_INTERFACE.TRANSFER_DATA';
   BEGIN
/** Initialize some of our OUT variables **/
      v_status := 'SUCCESS';
      v_error_message := ' ';
      n_bytes_transmitted := 0;
--
      l_step := 'PARSING FILENAME';

      IF NVL ( INSTR ( v_filename, '#' ), 0 ) = 0
      THEN
         v_filenamefr := v_filename;
         v_filenameto := v_filename;
      ELSE
         v_filenamefr :=
            LTRIM ( RTRIM ( SUBSTR ( v_filename
,                                    1
,                                    INSTR ( v_filename, '#' ) - 1 )));
         v_filenameto :=
            LTRIM ( RTRIM ( SUBSTR ( v_filename, INSTR ( v_filename, '#' ) + 1 )));
      END IF;

      l_step := 'SELECTING TRANSFER MODE';

      IF UPPER ( v_tsfr_mode ) = 'PUT'
      THEN
         v_mode := 'r';
         v_tsfr_cmd := 'STOR';
      ELSIF UPPER ( v_tsfr_mode ) = 'GET'
      THEN
         v_mode := 'w';
         v_tsfr_cmd := 'RETR';
      ELSIF UPPER ( v_tsfr_mode ) = 'LIST'
      THEN
         v_mode := 'w';
         v_tsfr_cmd := 'LIST';
      ELSIF UPPER ( v_tsfr_mode ) = 'NLST'
      THEN
         v_mode := 'w';
         v_tsfr_cmd := 'NLST';
      ELSIF UPPER ( v_tsfr_mode ) = 'DELE'
      THEN
         v_mode := 'd';
         v_tsfr_cmd := 'DELE';
      ELSIF UPPER ( v_tsfr_mode ) = 'RNFR'
      THEN
         v_mode := 'm';
         v_tsfr_cmd := 'RNFR';
      END IF;

      l_step := 'OPEN CONNECTION WITH SERVER';
/** Open data connection on Passive host and port **/
      u_data_con :=
         utl_tcp.open_connection ( remote_host =>                   v_host
,                                  remote_port =>                   n_port
,                                  tx_timeout =>                    tx_timeout );
      l_step := 'SOME FILE OPERATIONS';

/* FILE STUFF */
      IF UPPER ( v_tsfr_mode ) = 'PUT'
      THEN
         IF    ( v_operation_mode = 'LOB' AND v_localpath = 'CLOB' )
            OR ( p_filetype = 'ASCII' AND v_operation_mode = 'LOB' )
         THEN
            p_data_clob := g_data_c;
         ELSIF p_filetype = 'BINARY'
         THEN
            IF v_operation_mode = 'LOB' AND v_localpath = 'BLOB'
            THEN
               p_data_blob := g_data_b;
            ELSE
               /* Read file into LOB for transferring */
               p_data_blob :=
                  get_local_binary_data ( p_dir =>                         v_localpath
,                                         p_file =>                        v_filenamefr );
            END IF;
         ELSIF v_operation_mode = 'FILE' AND p_filetype = 'ASCII'
         THEN
/** Open the local file to read and transfer data **/
            u_filehandle :=
                    utl_file.fopen ( v_localpath
,                                    v_filenamefr
,                                    v_mode
,                                    32000 );
         END IF;
      ELSIF UPPER ( v_tsfr_mode ) IN ( 'GET', 'LIST', 'NLST' )
      THEN
         IF    ( v_operation_mode = 'LOB' AND v_localpath = 'CLOB' )
            OR ( p_filetype = 'ASCII' AND v_operation_mode = 'LOB' )
         THEN
            p_data_clob := g_data_c;
         ELSIF v_operation_mode = 'LOB' AND v_localpath = 'BLOB'
         THEN
            p_data_blob := g_data_b;
         ELSE
            IF     UPPER ( v_tsfr_cmd ) IN ( 'LIST', 'NLST' )
               AND v_operation_mode = 'FILE'
            THEN
/** Open the local file to read and transfer data using from name which is our directory listing file **/
               u_filehandle :=
                    utl_file.fopen ( v_localpath
,                                    v_filenamefr
,                                    v_mode
,                                    32000 );
            ELSIF v_operation_mode = 'FILE' AND UPPER ( v_tsfr_mode ) = 'GET'
            THEN
/** Open the local file to read and transfer data **/
               u_filehandle :=
                    utl_file.fopen ( v_localpath
,                                    v_filenameto
,                                    v_mode
,                                    32000 );
            END IF;
         END IF;
      END IF;

--
-- v_tsfr_cmd is used for determining remote actions
      IF UPPER ( v_tsfr_cmd ) = 'DELE'
      THEN
         l_step := 'DELETE COMMAND';

         /** Send the DELE command to tell the server we're going to delete a file **/
         IF mainframe_connection
         THEN
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_connection
,                                   'DELE ' || '''' || v_filenamefr || '''' );
         ELSE
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_connection, 'DELE ' || v_filenamefr );
         END IF;
      ELSIF UPPER ( v_tsfr_cmd ) = 'RNFR'
      THEN
         l_step := 'RENAME A FILE';

/** Send the RNFR command to tell the server we're going to rename a file **/
         IF mainframe_connection
         THEN
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'RNFR ' || '''' || v_filenamefr || '''' );

--
            IF validate_reply ( u_ctrl_con
,                               rnfr_code
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            n_bytes :=
                     utl_tcp.write_line ( u_ctrl_con, 'RNFR ' || v_filenamefr );

--
            IF validate_reply ( u_ctrl_con
,                               rnfr_code
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;

--
/** Send the RNTO command to tell the server we're going to rename a file to this name**/
         IF mainframe_connection
         THEN
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'RNTO ' || '''' || v_filenameto || '''' );
         ELSE
            n_bytes :=
                     utl_tcp.write_line ( u_ctrl_con, 'RNTO ' || v_filenameto );
         END IF;
      ELSIF UPPER ( v_tsfr_cmd ) = 'RETR'
      THEN
         l_step := 'RETREIVE A FILE';

/** Send the command to tell the server we're going to download a file **/
         IF mainframe_connection
         THEN
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'RETR ' || '''' || v_filenamefr || '''' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            n_bytes :=
                     utl_tcp.write_line ( u_ctrl_con, 'RETR ' || v_filenamefr );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;
      ELSIF UPPER ( v_tsfr_cmd ) = 'LIST'
      THEN
         l_step := 'LIST DIR CONTENTS - FULL LISTING';

         /** Send the command to tell the server we're going to list dir contents **/
         IF mainframe_connection
         THEN
            n_bytes := utl_tcp.write_line ( u_ctrl_con, 'LIST' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            n_bytes := utl_tcp.write_line ( u_ctrl_con, 'LIST' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;
      ELSIF UPPER ( v_tsfr_cmd ) = 'NLST'
      THEN
         l_step := 'LIST DIRECTORY CONTENTS - FILENAME ONLY';

         /** Send the command to tell the server we're going to list dir contents **/
         IF mainframe_connection
         THEN
            n_bytes := utl_tcp.write_line ( u_ctrl_con, 'NLST' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            n_bytes := utl_tcp.write_line ( u_ctrl_con, 'NLST' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;
      ELSE
         l_step := 'UPLOAD FILE';

                                         -- Defaults to STOR (PUT) case
/** Send the command to tell the server we're going to upload a file **/
         IF mainframe_connection
         THEN
            n_bytes :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'STOR ' || '''' || v_filenameto || '''' );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            n_bytes :=
                     utl_tcp.write_line ( u_ctrl_con, 'STOR ' || v_filenameto );

--
            IF validate_reply ( u_ctrl_con
,                               tsfr_start_code1
,                               tsfr_start_code2
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;
      END IF;

--
      d_trans_start := SYSDATE;

--
      IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
      THEN
         --
         -- For our purposes in this release
         -- we really only needed just the one debug
         -- output entry.
         --
         -- FILETYPE              ASCII vs. BINARY
         -- OPERATION_MODE        FILE vs. LOB
         -- LOCALPATH          EITHER DBA_DIRECTORY OR LOB TYPE
         -- TSFR_MODE          PUT,GET,etc
         -- SYSTEM_TYPE        SERVER TYPE e.g. UNIX,NETWARE,WINDOWS,MVS
         -- SYSTEM_TYPE_REPLY     FULL REPLY TO SYST COMMAND
         --
         -- These values should be beneficial to most debugging
         -- efforts. You can leverage the l_ftp_debug elsewhere
         -- as needed
         --
         print_output (    'FTP_DEBUG :: INFO :: '
                        || p_filetype
                        || ' :: '
                        || v_operation_mode
                        || ' :: '
                        || v_localpath
                        || ' :: '
                        || UPPER ( v_tsfr_mode )
                        || ' :: '
                        || v_system_type
                        || ' :: '
                        || v_system_type_reply );
      END IF;

      IF UPPER ( v_tsfr_mode ) = 'PUT'
      THEN
         l_step := 'UPLOADING DATA';

         IF    ( p_filetype = 'BINARY' AND v_operation_mode = 'FILE' )
            OR ( p_filetype = 'BINARY' AND v_operation_mode = 'LOB' )
         THEN
            p_data_blob := g_data_b;
            put_remote_binary_data ( u_data_con, p_data_blob );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_blob );
         ELSIF    ( v_localpath = 'CLOB' AND v_operation_mode = 'LOB' )
               OR ( p_filetype = 'ASCII' AND v_operation_mode = 'LOB' )
         THEN
            p_data_clob := g_data_c;
            put_remote_ascii_data ( u_data_con, p_data_clob );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_clob );
         ELSE
            -- Read from file
            -- and it must be a flat ascii file
            --
            LOOP
               BEGIN
                  utl_file.get_line ( u_filehandle, v_buffer );
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     EXIT;
               END;

--
/* Trim off Carriage return */
               n_bytes :=
                  utl_tcp.write_line ( u_data_con
,                                      RTRIM ( v_buffer, CHR ( 13 )));
               n_bytes_transmitted := n_bytes_transmitted + n_bytes;
            END LOOP;
         END IF;
      ELSIF UPPER ( v_tsfr_mode ) = 'GET'
      THEN
         l_step := 'GETTING DATA';

         IF p_filetype = 'BINARY' AND v_operation_mode = 'FILE'
         THEN
            p_data_blob := get_remote_binary_data ( u_data_con );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_blob );
            put_local_binary_data ( p_data =>                        p_data_blob
,                                   p_dir =>                         v_localpath
,                                   p_file =>                        v_filenameto );
         ELSIF    ( v_localpath = 'CLOB' AND v_operation_mode = 'LOB' )
               OR ( p_filetype = 'ASCII' AND v_operation_mode = 'LOB' )
         THEN
            p_data_clob := get_remote_ascii_data ( u_data_con );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_clob );
            g_data_c := p_data_clob;
         ELSIF p_filetype = 'BINARY' AND v_operation_mode = 'LOB'
         THEN
            p_data_blob := get_remote_binary_data ( u_data_con );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_blob );
            g_data_b := p_data_blob;
         ELSE
            IF mainframe_connection
            THEN
               LOOP
                  BEGIN
                     v_buffer := utl_tcp.get_line ( u_data_con, TRUE );

--
               /** Sometimes the TCP/IP buffer sends null data **/
                               /** we only want to receive the actual data **/
                     IF v_buffer IS NOT NULL
                     THEN
                        utl_file.put_line ( u_filehandle, v_buffer );
                        n_bytes := LENGTH ( v_buffer );
                        n_bytes_transmitted := n_bytes_transmitted + n_bytes;
                     END IF;
--
                  EXCEPTION
                     WHEN utl_tcp.end_of_input
                     THEN
                        EXIT;
                  END;
--
               END LOOP;
            ELSE
               BEGIN
                  LOOP
                     v_buffer := utl_tcp.get_line ( u_data_con, TRUE );

                     /** Sometimes the TCP/IP buffer sends null data **/
                                     /** we only want to receive the actual data **/
                     IF v_buffer IS NOT NULL
                     THEN
                        utl_file.put_line ( u_filehandle, v_buffer );
                        n_bytes := LENGTH ( v_buffer );
                        n_bytes_transmitted := n_bytes_transmitted + n_bytes;
                     END IF;
                  END LOOP;
               EXCEPTION
                  WHEN utl_tcp.end_of_input
                  THEN
                     NULL;
               END;
            END IF;                            -- end of IF mainframe connection
         END IF;                                 -- end of IF filetype is BINARY
      ELSIF UPPER ( v_tsfr_mode ) IN ( 'LIST', 'NLST' )
      THEN
         l_step := 'GETTING DIRECTORY LISTING';
/*

Long Output Format

The output from ls -l summarizes all the most important information about the file on one line.
If the specified pathname is a directory, ls displays information on every file in that directory
(one file per line). It precedes this list with a status line that indicates the total number of
file system blocks (512 byte units) occupied by the files in that directory. Here is a sample of
the output along with an explanation.

-rw-rw-rw- 1 root   dir 104 Dec 25 19:32 file

The first character identifies the file type:

-    Regular file
b    Block special file
c    Character special file
d    Directory
l    Symbolic link
n    Network file
p    FIFO
s    Socket

The next nine characters are in three groups of three; they describe the permissions on the file.
The first group of three describes owner permissions; the second describes group permissions;
the third describes other (or world) permissions. Because Windows systems do not support group
and other permissions, these are copies of the owner's permissions. Characters that may appear are:

r    Permission to read file
w    Permission to write to file
x    Permission to execute file
a    Archive bit is on (file has not been backed up)
c    Compressed file
s    System file
h    Hidden file
t    Temporary file

On Windows systems, most of the permissions shown are artificial, with no real meaning. The w bit
is set according to the ReadOnly attribute, and the rx bits are always set on.

You can change some permissions with the chmod command.

After the permissions comes the number of links to the file. Since Windows Me does not support links,
this value is always 1.

Next comes the name of the owner of the file or directory. On Windows Me and under
Windows NT/2000/XP/2003 on file systems that don't support Windows NT/2000/XP/2003 security,
the owner name cannot be determined and the owner ID number is displayed instead. Since Windows Me
does not support the concept of ownership, the owner ID number is always user ID zero. Under
Windows NT/2000/XP/2003 the name of the owner of a file is displayed if the file's SIDs can be
obtained and if these SIDs have an associated name in the SAM database. If the file has a SID
associated with it, but the name of the SID cannot be determined, then the value of the SID is
displayed. (This can happen when the current user is not in the domain that was used when the
file was created.) If the file does not have a SID (for example, if it is on a non-NTFS file system),
or if the file security information cannot be accessed because the file is locked by another process,
then the user name appears as <unavail>.

Then comes the name of the group that owns the file or directory. On Windows systems, the same
rules are followed for the group name as for the owner name.

Following this is the size of the file, expressed in bytes.

After this comes a date and time. For a file, this is the time that the file was last changed;
for a directory, it is the time that the directory was created. The -c and -u options can change
which time value is used. If the date is more than six months old or if the date is in the future,
the year is shown instead of the time.

The last item on the line is the name of the file or directory.

--
For LIST command we want to determine what the system type is
because it will determine our format for the headers when running
the LIST (DIR) command.
--
Permission Lnk Owner    Group         Bytes Mon Dy Time  Name
drwxrwxr-x 221 oaphrb   pay           12288 May 02 12:59 appltop
--
Although on Unix system, the header row is not presented, we would like to  provide it here
so that it remains consistent with how the mainframe response is received which does
in fact include a header row.
--
Problem is that different systems display data differently to put it simple. We will be
supporting the following : Netware, VMS, Unix, and Windows. If you have others, you
will need to modify the code accordingly to support it. To identify the system ,
ftp to the server manually and type sys and press enter. It will respond back with
the server type.

Then do a dir command and capture how the headers are displayed. Code for it.
--
--
Connecting to a Netware O/S (Novell)
--
  Permission Owner                           Bytes Mon Dy  Year Name
- [RWCEAFMS] JSB2493S                       483566 May 26  2004 Rearch.EXE
--
Connect to MVS O/S (mainframe)
--
Volume Unit    Referred Ext Used Recfm Lrecl BlkSz Dsorg Dsname
PRM515 3390   2006/08/25  1   15  FB     100 27900  PS  ET.TALX.COIDUDN.FILE
--
--
Connect to Windows O/S
--
Permission Lnk Owner    Group           Bytes Mon Dy Time  Name
---------- --- -----    -----           ----- --- -- ----  ----
dr-xr-xr-x   1 owner    group               0 Feb  1 17:32 bussys
--
--
*/
         l_longdir_line_cnt := 0;

         IF    ( v_localpath = 'CLOB' AND v_operation_mode = 'LOB' )
            OR ( p_filetype = 'ASCII' AND v_operation_mode = 'LOB' )
         THEN
            p_data_clob :=
               get_remote_listing_data ( u_data_con
,                                        v_filenameto
,                                        v_tsfr_mode );
            n_bytes_transmitted := dbms_lob.getlength ( p_data_clob );
            g_data_c := p_data_clob;
         ELSE
            IF mainframe_connection
            THEN
               LOOP
                  BEGIN
                     v_buffer := utl_tcp.get_line ( u_data_con, TRUE );

--

                     --
                     /** Sometimes the TCP/IP buffer sends null data **/
                                     /** we only want to receive the actual data **/
                     IF v_buffer IS NOT NULL
                     THEN
                        l_longdir_line_cnt := l_longdir_line_cnt + 1;

--
-- Capture the first line. On our system
-- it is the column headers
--
                        IF l_longdir_line_cnt = 1
                        THEN
                           v_buffer_header1 := v_buffer;
                        END IF;

                        --
                        -- DISPLAY HEADER ROW WHEN v_SYSTEM_TYPE IS NOT NULL
                        --
                        CASE
                           WHEN     l_longdir_line_cnt = 1
                                AND UPPER ( v_tsfr_mode ) = 'LIST'
                                AND v_system_type = 'MVS'
                           THEN
                              v_buffer_header1 := v_buffer_header1;
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '------ ----    -------- --- ---- ----- ----- ----- ----- ------';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                           WHEN     l_header_displayed = 0
                                AND UPPER ( v_tsfr_mode ) = 'LIST'
                                AND v_system_type <> 'MVS'
                           THEN
                              --
                              -- We didn't recognize the system type so display a message
                              -- that we won't be displaying the header row
                              --
                              v_buffer_header1 :=
                                 LTRIM ( RTRIM (    'System Reply => '
                                                 || v_system_type_reply ));
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '************************************************************************************************';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                           ELSE
                              NULL;
                        END CASE;

--
-- We stored the filename filter in v_filenameto
--
                        IF v_filenameto = '*'
                        THEN
                           IF     l_header_displayed = 0
                              AND UPPER ( v_tsfr_mode ) = 'LIST'
                              AND 'PLACEHOLDER ONLY. ALWAYS INCLUDES HEADER BY DEFAULT' IS NULL
                           THEN
                              l_header_displayed := 1;
                              utl_file.put_line ( u_filehandle
,                                                 v_buffer_header1 );
                              utl_file.put_line ( u_filehandle
,                                                 v_buffer_header2 );
                           END IF;

                           utl_file.put_line ( u_filehandle, v_buffer );
                           n_bytes := LENGTH ( v_buffer );
                           n_bytes_transmitted := n_bytes_transmitted + n_bytes;
                        ELSE
                           --
                           -- Here we are building our search string
                           -- by replacing wildcard * with %
                           -- and then encapsulating the resulting string
                           -- with % on each end. We also make sure we don't
                           -- have %% on the tail and lead of the search string
                           --
                           l_filename_search :=
                                 '%'
                              || RTRIM ( LTRIM (    '%'
                                                 || REPLACE ( v_filenameto
,                                                             '*'
,                                                             '%' )
                                                 || '%'
,                                                '%' )
,                                        '%' )
                              || '%';

                           IF v_buffer LIKE l_filename_search
                           THEN
                              IF     l_header_displayed = 0
                                 AND UPPER ( v_tsfr_mode ) = 'LIST'
                              THEN
                                 l_header_displayed := 1;
                                 utl_file.put_line ( u_filehandle
,                                                    v_buffer_header1 );
                                 utl_file.put_line ( u_filehandle
,                                                    v_buffer_header2 );
                              END IF;

                              utl_file.put_line ( u_filehandle, v_buffer );
                              n_bytes := LENGTH ( v_buffer );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                           END IF;
                        END IF;
                     END IF;
--
                  EXCEPTION
                     WHEN utl_tcp.end_of_input
                     THEN
                        EXIT;
                  END;
--
               END LOOP;
            ELSE                                                -- Not mainframe
               BEGIN
                  LOOP
                     v_buffer := utl_tcp.get_line ( u_data_con, TRUE );

--
                     /** Sometimes the TCP/IP buffer sends null data **/
                                     /** we only want to receive the actual data **/
                     IF v_buffer IS NOT NULL
                     THEN
                        l_longdir_line_cnt := l_longdir_line_cnt + 1;

                        --
                        -- DISPLAY HEADER ROW WHEN v_SYSTEM_TYPE IS NOT NULL
                        --
                        CASE
                           WHEN     UPPER ( v_tsfr_mode ) = 'LIST'
                                AND v_system_type = 'UNIX'
                           THEN
                              v_buffer_header1 :=
                                 'Permission Lnk Owner    Group         Bytes Mon Dy Time  Name';
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '---------- --- -----    -----         ----- --- -- ----  ----';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                           WHEN     UPPER ( v_tsfr_mode ) = 'LIST'
                                AND v_system_type = 'NETWARE'
                           THEN
                              v_buffer_header1 :=
                                 'Permission   Owner                           Bytes Mon Dy DStmp Name';
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '------------ --------                        ----- --- -- ----- ----';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                           WHEN     UPPER ( v_tsfr_mode ) = 'LIST'
                                AND v_system_type = 'WINDOWS'
                           THEN
                              v_buffer_header1 :=
                                 'Permission Lnk Owner    Group           Bytes Mon Dy DStmp Name';
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '---------- --- -----    -----           ----- --- -- ----- ----';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                  n_bytes_transmitted + n_bytes;
                           ELSE
                              --
                              -- We didn't recognize the system type so display a message
                              -- that we won't be displaying the header row
                              --
                              v_buffer_header1 :=
                                 LTRIM ( RTRIM (    'System Reply => '
                                                 || v_system_type_reply ));
                              n_bytes := LENGTH ( v_buffer_header1 );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                              v_buffer_header2 :=
                                 '************************************************************************************************';
                              n_bytes := LENGTH ( v_buffer_header2 );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                        END CASE;

--
-- We stored the filename filter in v_filenameto
--
                        IF v_filenameto = '*'
                        THEN
                           IF     l_header_displayed = 0
                              AND UPPER ( v_tsfr_mode ) = 'LIST'
                           THEN
                              l_header_displayed := 1;
                              utl_file.put_line ( u_filehandle
,                                                 v_buffer_header1 );
                              utl_file.put_line ( u_filehandle
,                                                 v_buffer_header2 );
                           END IF;

                           utl_file.put_line ( u_filehandle, v_buffer );
                           n_bytes := LENGTH ( v_buffer );
                           n_bytes_transmitted := n_bytes_transmitted + n_bytes;
                        ELSE
                           l_filename_search :=
                                 '%'
                              || RTRIM ( LTRIM (    '%'
                                                 || REPLACE ( v_filenameto
,                                                             '*'
,                                                             '%' )
                                                 || '%'
,                                                '%' )
,                                        '%' )
                              || '%';

                           IF v_buffer LIKE l_filename_search
                           THEN
                              IF     l_header_displayed = 0
                                 AND UPPER ( v_tsfr_mode ) = 'LIST'
                              THEN
                                 l_header_displayed := 1;
                                 utl_file.put_line ( u_filehandle
,                                                    v_buffer_header1 );
                                 utl_file.put_line ( u_filehandle
,                                                    v_buffer_header2 );
                              END IF;

                              utl_file.put_line ( u_filehandle, v_buffer );
                              n_bytes := LENGTH ( v_buffer );
                              n_bytes_transmitted :=
                                                   n_bytes_transmitted + n_bytes;
                           END IF;
                        END IF;
                     END IF;
                  END LOOP;
               EXCEPTION
                  WHEN utl_tcp.end_of_input
                  THEN
                     NULL;
               END;
            END IF;                            -- end of IF mainframe connection
         END IF;                                           -- end of LOB vs FILE
      END IF;

--
      d_trans_end := SYSDATE;
      l_step := 'CLOSING FILE IF OPEN';

--
/** Close the file **/
--
-- We don't have to do this when in LOB mode because we
-- are not working with the filesystem
--
      IF v_mode IN ( 'r', 'w', 'l', 'n' ) AND v_operation_mode = 'FILE'
      THEN
         utl_file.fclose ( u_filehandle );
      END IF;

      l_step := 'CLOSING DATA CONNECTION';
--
/** Close the Data Connection **/
      utl_tcp.close_connection ( u_data_con );
--
--
      l_step := 'VERIFY TRANSFER SUCCESS';

--
/** Verify the transfer succeeded **/
      IF v_mode IN ( 'r', 'w', 'l', 'n' )
      THEN
         IF mainframe_connection
         THEN
            IF validate_reply ( u_ctrl_connection
,                               tsfr_end_code_mf
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         ELSE
            IF validate_reply ( u_ctrl_connection
,                               tsfr_end_code
,                               v_reply ) = FALSE
            THEN
               RAISE ctrl_exception;
            END IF;
         END IF;
      ELSIF v_mode = 'd'
      THEN
         IF validate_reply ( u_ctrl_con
,                            delete_code
,                            v_reply ) = FALSE
         THEN
            RAISE ctrl_exception;
         END IF;
      ELSIF v_mode = 'm'
      THEN
         IF validate_reply ( u_ctrl_con
,                            rnto_code
,                            v_reply ) = FALSE
         THEN
            RAISE ctrl_exception;
         END IF;
      END IF;
   EXCEPTION
      WHEN ctrl_exception
      THEN
         v_status := v_err_status;
         v_error_message := c_process || ' :: ' || v_reply || '. :: ' || l_step;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
      WHEN utl_file.invalid_path
      THEN
         v_status := v_err_status;
         v_error_message :=
               c_process
            || ' :: '
            || 'Directory '
            || v_localpath
            || ' is not available to UTL_FILE.  Check the init.ora file for valid UTL_FILE directories'
            || '. :: '
            || l_step;
         utl_tcp.close_connection ( u_data_con );
      WHEN utl_file.invalid_operation
      THEN
         v_status := v_err_status;

--
         IF UPPER ( v_tsfr_mode ) = 'PUT'
         THEN
            v_error_message :=
                  c_process
               || ' :: '
               || 'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be opened for reading'
               || '. :: '
               || l_step;
         ELSIF UPPER ( v_tsfr_mode ) = 'GET'
         THEN
            v_error_message :=
                  c_process
               || ' :: '
               || 'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be opened for writing'
               || '. :: '
               || l_step;
         ELSIF UPPER ( v_tsfr_mode ) = 'LIST'
         THEN
            v_error_message :=
                  'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be opened for writing, or some other problem occurred with dir cmd'
               || '. :: '
               || l_step;
         ELSIF UPPER ( v_tsfr_mode ) = 'NLIST'
         THEN
            v_error_message :=
                  c_process
               || ' :: '
               || 'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be opened for writing, or some other problem occurred with dir cmd'
               || '. :: '
               || l_step;
         ELSIF UPPER ( v_tsfr_mode ) = 'DELE'
         THEN
            v_error_message :=
                  c_process
               || ' :: '
               || 'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be deleted'
               || '. :: '
               || l_step;
         ELSIF UPPER ( v_tsfr_mode ) = 'RNFR'
         THEN
            v_error_message :=
                  c_process
               || ' :: '
               || 'The file '
               || v_filenamefr
               || ' in the directory '
               || v_localpath
               || ' could not be renamed'
               || '. :: '
               || l_step;
         END IF;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
      WHEN utl_file.read_error
      THEN
         v_status := v_err_status;
         v_error_message :=
               c_process
            || ' :: '
            || 'The system encountered an error while trying to read '
            || v_filenamefr
            || ' in the directory '
            || v_localpath
            || '. :: '
            || l_step;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
      WHEN utl_file.write_error
      THEN
         v_status := v_err_status;
         v_error_message :=
               c_process
            || ' :: '
            || 'The system encountered an error while trying to write to '
            || v_filenamefr
            || ' in the directory '
            || v_localpath
            || '. :: '
            || l_step;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
      WHEN utl_file.internal_error
      THEN
         v_status := v_err_status;
         v_error_message :=
               c_process
            || ' :: '
            || 'The UTL_FILE package encountered an unexpected internal system error'
            || '. :: '
            || l_step;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
      WHEN OTHERS
      THEN
         v_status := v_err_status;
         v_error_message :=
            c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM || '. :: '
            || l_step;

--
         IF utl_file.is_open ( u_filehandle ) AND v_operation_mode = 'FILE'
         THEN
            utl_file.fclose ( u_filehandle );
         END IF;

--
         utl_tcp.close_connection ( u_data_con );
   END transfer_data;

--
--
-- FTP_FILES_STAGE
--
-- Handles connection to remote server and initial remote server commands
--
--
--    * Function to handle FTP of files.
--    * Returns TRUE if no batch-level errors occur.
--    * Returns FALSE if a batch-level error occurs.
--    *
--    * Parameters:
--    *
--    * p_error_msg - error message for batch level errors
--    * p_files - FTP_INTERFACE.t_ftp_rec table type.  Accepts
--    *           list of files to be transferred
--    *           returns the table updated with transfer status, error message,
--    *           bytes_transmitted, transmission start date/time and transmission end
--    *           date/time
--    * p_username - username for FTP server
--    * p_password - password for FTP server
--    * p_hostname - hostname or IP address of server Ex: 'ftp.oracle.com' or '127.0.0.1'
--    * p_port - port number to connect on.  FTP is usually on 21, but this may be overridden
--    *          if the server is configured differently.
--
   FUNCTION ftp_files_stage (
      p_error_msg                OUT      VARCHAR2
,     p_files                    IN OUT   t_ftp_rec
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     p_port                     IN       PLS_INTEGER DEFAULT 21 )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                         := 'HUM_FTP_INTERFACE.FTP_FILES_STAGE';
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 30 ) := p_password;
      v_hostname                    VARCHAR2 ( 30 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_remotepath                  VARCHAR2 ( 2000 );
      n_byte_count                  PLS_INTEGER;
      n_first_index                 NUMBER;
      v_msg                         VARCHAR2 ( 1000 );
      v_reply                       VARCHAR2 ( 1000 );
      v_pasv_host                   VARCHAR2 ( 20 );
      l_filetype                    VARCHAR2 ( 10 );
      n_pasv_port                   NUMBER;
      v_buffer                      VARCHAR2 ( 1000 );
      u_ctrl_connection             utl_tcp.connection;
      v_mainframe_cmd_temp          VARCHAR2 ( 2000 );
      l_step                        VARCHAR2 ( 1000 );
      lncnt                         PLS_INTEGER := 0;
      ln_array                      atoms_tabtype;
      ln_empty_array                atoms_tabtype;
      invalid_transfer              EXCEPTION;
   BEGIN
      p_error_msg := 'FTP Successful';
                                   --Assume the overall transfer will succeed
/** Attempt to connect to the host machine **/
      l_step := 'LOGIN TO HOST MACHINE';
      u_ctrl_con :=
         login ( a_site_in =>                     p_hostname
,                a_port_in =>                     p_port
,                a_user_name =>                   v_username
,                a_user_pass =>                   v_password );
--
      u_ctrl_connection := u_ctrl_con;

--
      /** We should be logged in, time to transfer all files **/
      FOR i IN p_files.FIRST .. p_files.LAST
      LOOP
         l_step := 'LOOP THROUGH FILES';

         IF p_files.EXISTS ( i )
         THEN
--
-- For LIST command we want to determine what the system type is
-- because it will determine our format for the headers when running
-- the LIST (DIR) command.
--
-- Permission Lnk Owner    Group         Bytes Mon Dy Time  Name
-- drwxrwxr-x 221 oaphrb   pay           12288 May 02 12:59 appltop
--
-- Although on Unix system, the header row is not presented, we would like to  provide it here
-- so that it remains consistent with how the mainframe response is received which does
-- in fact include a header row.
--
-- Problem is that different systems display data differently to put it simple. We will be
-- supporting the following : Netware, VMS, Unix, and Windows. If you have others, you
-- will need to modify the code accordingly to support it. To identify the system ,
-- ftp to the server manually and type sys and press enter. It will respond back with
-- the server type.
--
-- Then do a dir command and capture how the headers are displayed. Code for it.
--
--
-- Connecting to a Netware O/S (Novell)
--
--   Permission Owner                           Bytes Mon Dy  Year Name
-- - [RWCEAFMS] JSB2493S                       483566 May 26  2004 Rearch.EXE
--
-- Connect to MVS O/S (mainframe)
--
-- Volume Unit    Referred Ext Used Recfm Lrecl BlkSz Dsorg Dsname
-- PRM515 3390   2006/08/25  1   15  FB     100 27900  PS  ET.TALX.COIDUDN.FILE
--
--
-- Connect to Windows O/S
--
-- Permission Lnk Owner    Group           Bytes Mon Dy Time  Name
-- ---------- --- -----    -----           ----- --- -- ----  ----
-- dr-xr-xr-x   1 owner    group               0 Feb  1 17:32 bussys
--
--

            --
-- Special Note. If so desired, we could do other things by leveraging
-- the server type reply. For now, we are just impacting the LIST (dir)
-- command
--
            BEGIN
               l_step := 'PERFORMING SYST COMMAND';
--
                  /** Change to the remotepath directory **/
               n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'SYST' );

               IF validate_reply ( u_ctrl_con
,                                  syst_code
,                                  v_reply ) = FALSE
               THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
                  RAISE ctrl_exception;
               END IF;

               CASE
                  WHEN UPPER ( v_reply ) LIKE '%NETWARE%'
                  THEN
                     v_system_type := 'NETWARE';
                     v_system_type_reply := v_reply;
                  WHEN UPPER ( v_reply ) LIKE '%MVS%'
                  THEN
                     v_system_type := 'MVS';
                     v_system_type_reply := v_reply;
                  WHEN UPPER ( v_reply ) LIKE '%UNIX%'
                  THEN
                     v_system_type := 'UNIX';
                     v_system_type_reply := v_reply;
                  WHEN UPPER ( v_reply ) LIKE '%WINDOWS%'
                  THEN
                     v_system_type := 'WINDOWS';
                     v_system_type_reply := v_reply;
                  ELSE
                     v_system_type :=
                        'INFO :: Header columns not supported yet. Contact IT Support.';
                     v_system_type_reply := v_reply;
               END CASE;
            EXCEPTION
               WHEN OTHERS
               THEN
-- If this SYST command fails we don't want to fail the ftp
-- we just won't show headers on the output file for directory listings
                  v_system_type := NULL;
                  v_system_type_reply := v_reply;
            END;

            v_remotepath := p_files ( i ).remotepath;

--
-- If no path was provided we assume stay in current path
-- let us get path and so we can perform CWD command
--
--
            IF (    v_remotepath IS NULL
                 OR v_remotepath = '.' )
            THEN
               /** Check PWD command **/
               n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'PWD' );

               IF validate_reply ( u_ctrl_con
,                                  pwd_code
,                                  v_reply ) = FALSE
               THEN
                  print_output ( 'user_code= ' || user_code );
                  print_output ( 'v_reply= ' || v_reply );
                  RAISE ctrl_exception;
               ELSE
                  IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
                  THEN
                     print_output ( 'PWD REPLY IS => ' || v_reply );
                  END IF;
--
-- Typical reply would like this :
--
-- 257 "/activitytracker" is current directory.
--
-- If your server response code does not have quotes around the
-- path, then you will need to alter this logic here appropriately
--
-- So far, all of our servers seem to work this way, so I am assuming
-- its a FTP standard
--
                  v_remotepath :=
                     SUBSTR ( v_reply
,                             INSTR ( v_reply
,                                     '"'
,                                     1 ) + 1
,                               INSTR ( SUBSTR ( v_reply
,                                                INSTR ( v_reply
,                                                        '"'
,                                                        1 ) + 1 )
,                                       '"'
,                                       1 )
                              - 1 );

--
-- Get rid of leading quote and trailing quote that is picked up from the mainframe
--
                  IF mainframe_connection
                  THEN
                     v_remotepath :=
                                   LTRIM ( RTRIM ( v_remotepath, '''' ), '''' );
                  END IF;

                  IF v_remotepath IS NULL
                  THEN
                     RAISE ctrl_exception;
                  END IF;
               END IF;
            END IF;

            IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
            THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
               print_output ( 'PATH IS => ' || v_remotepath );
            END IF;

            BEGIN
--
               l_step := 'PERFORMING CWD COMMAND FOR ' || v_remotepath;

--
               IF mainframe_connection
               THEN
--
-- Mainframe does not use unix path syntax.
-- We will convert / (fwd slash) to a . (period)
-- and also trim leading fwd slash
--
-- If already periods, then this really won't do anything
--
                  v_remotepath := LTRIM ( v_remotepath, '/' );
                  v_remotepath := REPLACE ( v_remotepath
,                                           '/'
,                                           '.' );

                  IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
                  THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
                     print_output ( 'MF REMOTEPATH IS => ' || v_remotepath );
                  END IF;

--
                     /** Change to the remotepath directory **/
                  n_byte_count :=
                     utl_tcp.write_line ( u_ctrl_con
,                                         'CWD ' || '''' || v_remotepath || '''' );
               ELSE
                  /** Change to the remotepath directory **/
                  n_byte_count :=
                      utl_tcp.write_line ( u_ctrl_con, 'CWD ' || v_remotepath );
               END IF;

               IF validate_reply ( u_ctrl_con
,                                  cwd_code
,                                  v_reply ) = FALSE
               THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
                  RAISE ctrl_exception;
               END IF;

--
--
               /** Switch to IMAGE mode **/
-- In certain cases we want to switch to ASCII mode
-- otherwise we always default to BINARY because it works fine
-- everything. We handle the 'feature' of binary that adds carriage
-- return to flat text files by trimming it off before sending it over
--
               IF UPPER ( p_files ( i ).localpath ) = 'CLOB'
               THEN
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE A' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'ASCII';
               ELSIF UPPER ( p_files ( i ).transfer_mode ) IN
                                                             ( 'LIST', 'NLST' )
               THEN
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE A' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'ASCII';
               ELSIF mainframe_connection
               THEN
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE A' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'ASCII';
               ELSIF UPPER ( p_files ( i ).filetype ) = 'ASCII'
               THEN
--
-- BINARY MODE WORKS FINE FOR GENERAL PURPOSES
-- HOWEVER WE WILL SAY FILETYPE OF ASCII SO
-- CARRIAGE RETURNS ARE TRIMMED AND FILE
-- IS WRITTEN OUT CORRECTLY
--
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE I' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'ASCII';
               ELSIF UPPER ( p_files ( i ).filetype ) = 'BINARY'
               THEN
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE I' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'BINARY';
               ELSE
--
-- We will default to BINARY MODE
--
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'TYPE I' );

--
                  IF validate_reply ( u_ctrl_con
,                                     type_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;

                  l_filetype := 'BINARY';
               END IF;

--
-- We can provide a list of SITE commands by separating with | symbols
-- This permits us to allocate space as well as submit additional commands
-- like handling special characters
--
-- e.g. quote site recfm=fb lrecl=512 cyl pri=30 sec=30|quote site sbdataconn=(ibm-1047,iso8859-1)
--
-- quote site recfm=fb lrecl=512 cyl pri=30 sec=30         => allocate space
-- quote site sbdataconn=(ibm-1047,iso8859-1)              => handle special characters
--
-- Technically, any valid FTP command could be sent here that has
-- a success return code of 200. We just enforce it for Mainframe to
-- make sure that it is not forgotten
--
-- Some other commands that have a success code of 200
--
-- TYPE, MODE
--
               /** Submit QUOTE SITE commands **/
               IF mainframe_connection AND mainframe_cmd IS NOT NULL
               THEN
                  std_delimiters := '|';
                  ln_array := ln_empty_array;
                  parse_string ( string_in =>                     mainframe_cmd
,                                             atomics_list_out =>              ln_array
,                                             num_atomics_out =>               lncnt );

                  FOR i_idx IN 1 .. lncnt
                  LOOP
                     IF ln_array ( i_idx ) <> '|'
                     THEN
                        v_mainframe_cmd_temp :=
                           LTRIM ( RTRIM ( REPLACE ( LOWER ( ln_array ( i_idx ))
,                                                    'quote'
,                                                    '' )));
                        print_output (    'Executing Site Command :: '
                                       || v_mainframe_cmd_temp );
                        n_byte_count :=
                           utl_tcp.write_line ( u_ctrl_con
,                                               v_mainframe_cmd_temp );

                        IF validate_reply ( u_ctrl_con
,                                           site_code
,                                           v_reply ) = FALSE
                        THEN
                           RAISE ctrl_exception;
                        END IF;
                     END IF;
                  END LOOP;
               ELSE
                  --
                  -- We don't require SITE Commands for non-mainframe transfers
                  -- However, if it was desired, it wouldn't take much to alter
                  -- this package so that additional server commands could be
                  -- sent for non-mainframe ftp processes as well
                  --
                  -- For now we will just put a place holder here which performs
                  -- a NOOP check against the remote server.
                  --
                  -- If your FTP server does not recognize NOOP you can comment
                  -- this out. Most likely it does. In my environment the server
                  -- return code is 200 when successful.
                  --
                  n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'NOOP' );

                  IF validate_reply ( u_ctrl_con
,                                     noop_code
,                                     v_reply ) = FALSE
                  THEN
                     RAISE ctrl_exception;
                  END IF;
               END IF;

               /** Get a Passive connection to use for data transfer **/
               n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'PASV' );

               IF validate_reply ( u_ctrl_con
,                                  pasv_code
,                                  v_reply ) = FALSE
               THEN
                  RAISE ctrl_exception;
               END IF;

               create_pasv ( SUBSTR ( v_reply
,                                     INSTR ( v_reply
,                                             '('
,                                             1
,                                             1 ) + 1
,                                       INSTR ( v_reply
,                                               ')'
,                                               1
,                                               1 )
                                      - INSTR ( v_reply
,                                               '('
,                                               1
,                                               1 )
                                      - 1 )
,                            v_pasv_host
,                            n_pasv_port );

--

               /** Transfer Data **/
               IF UPPER ( p_files ( i ).transfer_mode ) = 'PUT'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSIF UPPER ( p_files ( i ).transfer_mode ) = 'GET'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSIF UPPER ( p_files ( i ).transfer_mode ) = 'LIST'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSIF UPPER ( p_files ( i ).transfer_mode ) = 'NLST'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSIF UPPER ( p_files ( i ).transfer_mode ) = 'DELE'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSIF UPPER ( p_files ( i ).transfer_mode ) = 'RNFR'
               THEN
                  transfer_data ( u_ctrl_con
,                                 p_files ( i ).localpath
,                                 p_files ( i ).filename
,                                 l_filetype
,                                 v_pasv_host
,                                 n_pasv_port
,                                 p_files ( i ).transfer_mode
,                                 p_files ( i ).status
,                                 p_files ( i ).error_message
,                                 p_files ( i ).bytes_transmitted
,                                 p_files ( i ).trans_start
,                                 p_files ( i ).trans_end );
               ELSE
                  RAISE invalid_transfer;            -- Raise an exception here
               END IF;
            EXCEPTION
               WHEN ctrl_exception
               THEN
                  p_files ( i ).status := 'ERROR';
                  p_files ( i ).error_message :=
                             c_process || ' :: ' || v_reply || ' :: ' || l_step;
                             raise ctrl_exception;
               WHEN invalid_transfer
               THEN
                  p_files ( i ).status := 'ERROR';
                  p_files ( i ).error_message :=
                        'Invalid transfer method.  Use PUT/GET/REMOVE/RENAME/LS/DIR Only.'
                     || ' :: '
                     || l_step;
                     raise invalid_transfer;
            END;
         END IF;
      END LOOP;

/** Send QUIT command **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'QUIT' );
/** Don't need to VALIDATE QUIT, just close the connection **/
      utl_tcp.close_connection ( u_ctrl_con );
      RETURN TRUE;
   EXCEPTION
      WHEN ctrl_exception
      THEN
         p_error_msg := c_process || ' :: ' || v_reply || ' :: ' || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
      WHEN OTHERS
      THEN
         p_error_msg :=
            c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM || ' :: '
            || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
   END ftp_files_stage;

--
-- GET_LOCAL_BINARY_DATA
--
-- Load local binary file into BLOB
--
   FUNCTION get_local_binary_data (
      p_dir                      IN       VARCHAR2
,     p_file                     IN       VARCHAR2 )
      RETURN BLOB
   IS
      l_bfile                       BFILE;
      l_data                        BLOB;
      l_dbdir                       VARCHAR2 ( 100 ) := p_dir;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                   := 'HUM_FTP_INTERFACE.GET_LOCAL_BINARY_DATA';
   BEGIN
      dbms_lob.createtemporary ( lob_loc =>                       l_data
,                                CACHE =>                         TRUE
,                                dur =>                           dbms_lob.CALL );
--
      l_bfile := BFILENAME ( l_dbdir, p_file );
--
      dbms_lob.fileopen ( l_bfile, dbms_lob.file_readonly );
--
      dbms_lob.loadfromfile ( l_data
,                             l_bfile
,                             dbms_lob.getlength ( l_bfile ));
--
      dbms_lob.fileclose ( l_bfile );
--
      RETURN l_data;
--
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during GET_LOCAL_BINARY_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         dbms_lob.fileclose ( l_bfile );
         RAISE;
   END get_local_binary_data;

--
-- GET_REMOTE_BINARY_DATA
--
-- Loads remote binary file into BLOB
--
   FUNCTION get_remote_binary_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection )
      RETURN BLOB
   IS
      l_amount                      PLS_INTEGER;
      l_buffer                      RAW ( 32767 );
      l_data                        BLOB;
      l_conn                        utl_tcp.connection := u_ctrl_connection;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                  := 'HUM_FTP_INTERFACE.GET_REMOTE_BINARY_DATA';
   BEGIN
      dbms_lob.createtemporary ( lob_loc =>                       l_data
,                                CACHE =>                         TRUE
,                                dur =>                           dbms_lob.CALL );

      BEGIN
         LOOP
            l_amount := utl_tcp.read_raw ( l_conn
,                                          l_buffer
,                                          32767 );
            dbms_lob.writeappend ( l_data
,                                  l_amount
,                                  l_buffer );
         END LOOP;
      EXCEPTION
         WHEN utl_tcp.end_of_input
         THEN
            NULL;
         WHEN OTHERS
         THEN
            NULL;
      END;

      RETURN l_data;
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during GET_REMOTE_BINARY_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         RAISE;
   END get_remote_binary_data;

--
-- GET_REMOTE_ASCII_DATA
--
-- Loads remote ascii file into CLOB
--
-- Note, we do not have a GET_LOCAL_ASCII_DATA because that code
-- is found within the TRANSFER_DATA routine itself using UTL_FILE.GET_LINE
-- operations
--
   FUNCTION get_remote_ascii_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection )
      RETURN CLOB
   IS
      l_amount                      PLS_INTEGER;
      l_buffer                      VARCHAR2 ( 32767 );
      l_data                        CLOB;
      l_conn                        utl_tcp.connection := u_ctrl_connection;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                   := 'HUM_FTP_INTERFACE.GET_REMOTE_ASCII_DATA';
   BEGIN
      dbms_lob.createtemporary ( lob_loc =>                       l_data
,                                CACHE =>                         TRUE
,                                dur =>                           dbms_lob.CALL );

      BEGIN
         LOOP
--
-- Don't forget you are planning to retrieve an ASCII file
-- via the CLOB method, and you are planning to include the
-- output in a message body of an email which is a formatted
-- email message (html) or in a webpage, then don't forget to
-- use <PRE> </PRE> tags around your content. Otherwise it
-- will look like one big piece of text. HTML doesn't recognize
-- the carriage return correctly otherwise.
--
            l_buffer := utl_tcp.get_line ( l_conn, TRUE );

            /** Sometimes the TCP/IP buffer sends null data **/
                            /** we only want to receive the actual data **/
            IF l_buffer IS NOT NULL
            THEN
               --
               -- We append a crlf to the end of each line
               -- so that the content from is maintained
               -- as we grab one line at a time from the remote server
               --
               l_buffer := l_buffer || utl_tcp.crlf;
               l_amount := LENGTH ( l_buffer );
               dbms_lob.writeappend ( l_data
,                                     l_amount
,                                     l_buffer );
            END IF;
         END LOOP;
      EXCEPTION
         WHEN utl_tcp.end_of_input
         THEN
            NULL;
      END;

      RETURN l_data;
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during GET_REMOTE_ASCII_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         RAISE;
   END get_remote_ascii_data;

--
-- GET_REMOTE_LISTING_DATA
--
-- This is used for obtaining a remote directory listing
-- and loading up into a CLOB
--
   FUNCTION get_remote_listing_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection
,     p_filename_filter          IN       VARCHAR2
,     p_tsfr_mode                IN       VARCHAR2 )
      RETURN CLOB
   IS
      l_data                        CLOB;
      l_conn                        utl_tcp.connection := u_ctrl_connection;
      l_amount                      PLS_INTEGER;
      v_buffer                      VARCHAR2 ( 32767 );
      v_buffer_header1              VARCHAR2 ( 32767 );
      v_buffer_header2              VARCHAR2 ( 32767 );
      l_header_displayed            PLS_INTEGER := 0;
      l_longdir_line_cnt            PLS_INTEGER := 0;
      l_filename_search             VARCHAR2 ( 1000 );
      c_process            CONSTANT VARCHAR2 ( 100 )
                                 := 'HUM_FTP_INTERFACE.GET_REMOTE_LISTING_DATA';
   BEGIN
      dbms_lob.createtemporary ( lob_loc =>                       l_data
,                                CACHE =>                         TRUE
,                                dur =>                           dbms_lob.CALL );

--
-- Don't forget you are planning to retrieve an ASCII file
-- via the CLOB method, and you are planning to include the
-- output in a message body of an email which is a formatted
-- email message (html) or in a webpage, then don't forget to
-- use <PRE> </PRE> tags around your content. Otherwise it
-- will look like one big piece of text. HTML doesn't recognize
-- the carriage return correctly otherwise.
--
      IF mainframe_connection
      THEN
         LOOP
            BEGIN
               v_buffer := utl_tcp.get_line ( l_conn, TRUE );

--

               --
               /** Sometimes the TCP/IP buffer sends null data **/
                               /** we only want to receive the actual data **/
               IF v_buffer IS NOT NULL
               THEN
                  l_longdir_line_cnt := l_longdir_line_cnt + 1;

--
-- Capture the first line. On our system
-- it is the column headers
--
                  IF l_longdir_line_cnt = 1
                  THEN
                     v_buffer_header1 := v_buffer;
                  END IF;

                  --
                  -- DISPLAY HEADER ROW WHEN v_SYSTEM_TYPE IS NOT NULL
                  --
                  CASE
                     WHEN     l_longdir_line_cnt = 1
                          AND UPPER ( p_tsfr_mode ) = 'LIST'
                          AND v_system_type = 'MVS'
                     THEN
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '------ ----    -------- --- ---- ----- ----- ----- ----- ------';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                     WHEN     l_longdir_line_cnt = 1
                          AND UPPER ( p_tsfr_mode ) = 'LIST'
                          AND v_system_type <> 'MVS'
                     THEN
                        --
                        -- We didn't recognize the system type so display a message
                        -- that we won't be displaying the header row
                        --
                        v_buffer_header1 :=
                           LTRIM ( RTRIM (    'System Reply => '
                                           || v_system_type_reply ));
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '************************************************************************************************';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                     ELSE
                        NULL;
                  END CASE;

--
-- We stored the filename filter in v_filenameto
--
                  IF p_filename_filter = '*'
                  THEN
                     IF     l_header_displayed = 0
                        AND UPPER ( p_tsfr_mode ) = 'LIST'
                        AND 'PLACEHOLDER ONLY. ALWAYS INCLUDES HEADER BY DEFAULT' IS NULL
                     THEN
                        l_header_displayed := 1;
                        l_amount := LENGTH ( v_buffer_header1 );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer_header1 );
                        l_amount := LENGTH ( v_buffer_header2 );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer_header2 );
                     END IF;

                     --
                     -- We append a crlf to the end of each line
                     -- so that the content from is maintained
                     -- as we grab one line at a time from the remote server
                     --
                     v_buffer := v_buffer || utl_tcp.crlf;
                     l_amount := LENGTH ( v_buffer );
                     dbms_lob.writeappend ( l_data
,                                           l_amount
,                                           v_buffer );
                  ELSE
                     --
                     -- Here we are building our search string
                     -- by replacing wildcard * with %
                     -- and then encapsulating the resulting string
                     -- with % on each end. We also make sure we don't
                     -- have %% on the tail and lead of the search string
                     --
                     l_filename_search :=
                           '%'
                        || RTRIM ( LTRIM (    '%'
                                           || REPLACE ( p_filename_filter
,                                                       '*'
,                                                       '%' )
                                           || '%'
,                                          '%' )
,                                  '%' )
                        || '%';

                     IF v_buffer LIKE l_filename_search
                     THEN
                        IF     l_header_displayed = 0
                           AND UPPER ( p_tsfr_mode ) = 'LIST'
                        THEN
                           l_header_displayed := 1;
                           l_amount := LENGTH ( v_buffer_header1 );
                           dbms_lob.writeappend ( l_data
,                                                 l_amount
,                                                 v_buffer_header1 );
                           l_amount := LENGTH ( v_buffer_header2 );
                           dbms_lob.writeappend ( l_data
,                                                 l_amount
,                                                 v_buffer_header2 );
                        END IF;

                        v_buffer := v_buffer || utl_tcp.crlf;
                        l_amount := LENGTH ( v_buffer );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer );
                     END IF;
                  END IF;
               END IF;
--
            EXCEPTION
               WHEN utl_tcp.end_of_input
               THEN
                  EXIT;
            END;
--
         END LOOP;
      ELSE
         BEGIN
            LOOP
               v_buffer := utl_tcp.get_line ( l_conn, TRUE );

--
                     /** Sometimes the TCP/IP buffer sends null data **/
                                     /** we only want to receive the actual data **/
               IF v_buffer IS NOT NULL
               THEN
                  l_longdir_line_cnt := l_longdir_line_cnt + 1;

                  --
                  -- DISPLAY HEADER ROW WHEN v_SYSTEM_TYPE IS NOT NULL
                  --
                  CASE
                     WHEN     UPPER ( p_tsfr_mode ) = 'LIST'
                          AND l_longdir_line_cnt = 1
                          AND v_system_type = 'UNIX'
                     THEN
                        v_buffer_header1 :=
                           'Permission Lnk Owner    Group         Bytes Mon Dy Time  Name';
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '---------- --- -----    -----         ----- --- -- ----  ----';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                     WHEN     UPPER ( p_tsfr_mode ) = 'LIST'
                          AND l_longdir_line_cnt = 1
                          AND v_system_type = 'NETWARE'
                     THEN
                        v_buffer_header1 :=
                           'Permission   Owner                           Bytes Mon Dy DStmp Name';
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '------------ --------                        ----- --- -- ----- ----';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                     WHEN     UPPER ( p_tsfr_mode ) = 'LIST'
                          AND l_longdir_line_cnt = 1
                          AND v_system_type = 'WINDOWS'
                     THEN
                        v_buffer_header1 :=
                           'Permission Lnk Owner    Group           Bytes Mon Dy DStmp Name';
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '---------- --- -----    -----           ----- --- -- ----- ----';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                     ELSE
                        --
                        -- We didn't recognize the system type so display a message
                        -- that we won't be displaying the header row
                        --
                        v_buffer_header1 :=
                           LTRIM ( RTRIM (    'System Reply => '
                                           || v_system_type_reply ));
                        v_buffer_header1 := v_buffer_header1 || utl_tcp.crlf;
                        v_buffer_header2 :=
                           '************************************************************************************************';
                        v_buffer_header2 := v_buffer_header2 || utl_tcp.crlf;
                  END CASE;

--
-- We stored the filename filter in v_filenameto
--
                  IF p_filename_filter = '*'
                  THEN
                     IF l_header_displayed = 0
                        AND UPPER ( p_tsfr_mode ) = 'LIST'
                     THEN
                        l_header_displayed := 1;
                        l_amount := LENGTH ( v_buffer_header1 );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer_header1 );
                        l_amount := LENGTH ( v_buffer_header2 );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer_header2 );
                     END IF;

                     v_buffer := v_buffer || utl_tcp.crlf;
                     l_amount := LENGTH ( v_buffer );
                     dbms_lob.writeappend ( l_data
,                                           l_amount
,                                           v_buffer );
                  ELSE
                     l_filename_search :=
                           '%'
                        || RTRIM ( LTRIM (    '%'
                                           || REPLACE ( p_filename_filter
,                                                       '*'
,                                                       '%' )
                                           || '%'
,                                          '%' )
,                                  '%' )
                        || '%';

                     IF v_buffer LIKE l_filename_search
                     THEN
                        IF     l_header_displayed = 0
                           AND UPPER ( p_tsfr_mode ) = 'LIST'
                        THEN
                           l_header_displayed := 1;
                           l_amount := LENGTH ( v_buffer_header1 );
                           dbms_lob.writeappend ( l_data
,                                                 l_amount
,                                                 v_buffer_header1 );
                           l_amount := LENGTH ( v_buffer_header2 );
                           dbms_lob.writeappend ( l_data
,                                                 l_amount
,                                                 v_buffer_header2 );
                        END IF;

                        v_buffer := v_buffer || utl_tcp.crlf;
                        l_amount := LENGTH ( v_buffer );
                        dbms_lob.writeappend ( l_data
,                                              l_amount
,                                              v_buffer );
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         EXCEPTION
            WHEN utl_tcp.end_of_input
            THEN
               NULL;
         END;
      END IF;                                  -- end of IF mainframe connection

      RETURN l_data;
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during GET_REMOTE_LISTING_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         RAISE;
   END get_remote_listing_data;

--
-- PUT_LOCAL_BINARY_DATA
--
-- This is used to write out a BLOB
-- to the local filesystem after
-- retrieving data from remote server
--
   PROCEDURE put_local_binary_data (
      p_data                     IN       BLOB
,     p_dir                      IN       VARCHAR2
,     p_file                     IN       VARCHAR2 )
   IS
      l_out_file                    utl_file.file_type;
      l_buffer                      RAW ( 32767 );
      l_amount                      BINARY_INTEGER := 32767;
      l_pos                         INTEGER := 1;
      l_blob_len                    INTEGER;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                   := 'HUM_FTP_INTERFACE.PUT_LOCAL_BINARY_DATA';
   BEGIN
      l_blob_len := dbms_lob.getlength ( p_data );
      l_out_file := utl_file.fopen ( p_dir
,                                    p_file
,                                    'w'
,                                    32767 );

      WHILE l_pos < l_blob_len
      LOOP
         dbms_lob.READ ( p_data
,                        l_amount
,                        l_pos
,                        l_buffer );

         IF l_buffer IS NOT NULL
         THEN
            utl_file.put_raw ( l_out_file
,                              l_buffer
,                              TRUE );
         END IF;

         l_pos := l_pos + l_amount;
      END LOOP;

      utl_file.fclose ( l_out_file );
   EXCEPTION
      WHEN utl_file.invalid_path
      THEN
         print_output
            (    c_process
              || ' :: '
              || 'Error during PUT_LOCAL_BINARY_DATA :: '
              || 'Directory '
              || p_dir
              || ' is not available to UTL_FILE.  Check the init.ora file for valid UTL_FILE directories.' );
         RAISE;
      WHEN utl_file.invalid_operation
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during PUT_LOCAL_BINARY_DATA :: '
                        || 'The file '
                        || p_file
                        || ' in the directory '
                        || p_dir
                        || ' could not be accessed.' );

         IF utl_file.is_open ( l_out_file )
         THEN
            utl_file.fclose ( l_out_file );
         END IF;

         RAISE;
      WHEN utl_file.read_error
      THEN
         print_output
                   (    c_process
                     || ' :: '
                     || 'Error during PUT_LOCAL_BINARY_DATA :: '
                     || 'The system encountered an error while trying to read '
                     || p_file
                     || ' in the directory '
                     || p_dir );

         IF utl_file.is_open ( l_out_file )
         THEN
            utl_file.fclose ( l_out_file );
         END IF;

         RAISE;
      WHEN utl_file.write_error
      THEN
         print_output
               (    c_process
                 || ' :: '
                 || 'Error during PUT_LOCAL_BINARY_DATA :: '
                 || 'The system encountered an error while trying to write to '
                 || p_file
                 || ' in the directory '
                 || p_dir );

         IF utl_file.is_open ( l_out_file )
         THEN
            utl_file.fclose ( l_out_file );
         END IF;

         RAISE;
      WHEN utl_file.internal_error
      THEN
         print_output
            (    c_process
              || ' :: '
              || 'Error during PUT_LOCAL_BINARY_DATA :: '
              || 'The UTL_FILE package encountered an unexpected internal system error.' );

         IF utl_file.is_open ( l_out_file )
         THEN
            utl_file.fclose ( l_out_file );
         END IF;

         RAISE;
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during PUT_LOCAL_BINARY_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );

         IF utl_file.is_open ( l_out_file )
         THEN
            utl_file.fclose ( l_out_file );
         END IF;

         RAISE;
   END put_local_binary_data;

--
-- PUT_REMOTE_BINARY_DATA
--
-- This is used for upload BLOB
-- to remote server after retrieving
-- from local filesystem or passed
-- via parameter as a BLOB e.g. PUT_BLOB function
-- in this package.
--
   PROCEDURE put_remote_binary_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection
,     p_data                     IN       BLOB )
   IS
      l_result                      PLS_INTEGER;
      l_buffer                      RAW ( 32767 );
      l_amount                      BINARY_INTEGER := 32767;
      l_pos                         INTEGER := 1;
      l_blob_len                    INTEGER;
      l_conn                        utl_tcp.connection := u_ctrl_connection;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                  := 'HUM_FTP_INTERFACE.PUT_REMOTE_BINARY_DATA';
   BEGIN
      l_blob_len := dbms_lob.getlength ( p_data );

      WHILE l_pos < l_blob_len
      LOOP
         dbms_lob.READ ( p_data
,                        l_amount
,                        l_pos
,                        l_buffer );
         l_result := utl_tcp.write_raw ( l_conn
,                                        l_buffer
,                                        l_amount );
         utl_tcp.FLUSH ( l_conn );
         l_pos := l_pos + l_amount;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during PUT_REMOTE_BINARY_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         RAISE;
   END put_remote_binary_data;

--
-- PUT_REMOTE_ASCII_DATA
--
-- This is used for upload CLOB
-- to remote server after retrieving
-- when passed via parameter as a
-- CLOB e.g. PUT_BLOB function in this package.
--
   PROCEDURE put_remote_ascii_data (
      u_ctrl_connection          IN OUT   utl_tcp.connection
,     p_data                     IN       CLOB )
   IS
-- --------------------------------------------------------------------------
      l_result                      PLS_INTEGER;
      l_buffer                      VARCHAR2 ( 32767 );
      l_amount                      BINARY_INTEGER := 32767;
      l_pos                         INTEGER := 1;
      l_clob_len                    INTEGER;
      l_conn                        utl_tcp.connection := u_ctrl_connection;
      c_process            CONSTANT VARCHAR2 ( 100 )
                                   := 'HUM_FTP_INTERFACE.PUT_REMOTE_ASCII_DATA';
   BEGIN
      l_clob_len := dbms_lob.getlength ( p_data );

      WHILE l_pos < l_clob_len
      LOOP
         dbms_lob.READ ( p_data
,                        l_amount
,                        l_pos
,                        l_buffer );
         l_result := utl_tcp.write_line ( l_conn, l_buffer );
         utl_tcp.FLUSH ( l_conn );
         l_pos := l_pos + l_amount;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         print_output (    c_process
                        || ' :: '
                        || 'Error during PUT_REMOTE_ASCII_DATA :: '
                        || SQLCODE
                        || ' - '
                        || SQLERRM );
         RAISE;
   END put_remote_ascii_data;

   /*****************************************************************************
   **  Convenience function for single-file PUT
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION put (
      p_localpath                IN       VARCHAR2
,     p_filename                 IN       VARCHAR2
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'ASCII'
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 ) := 'HUM_FTP_INTERFACE.PUT';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'PUT';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END put;

   /*****************************************************************************
   **  Convenience function for single-file GET
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION get (
      p_localpath                IN       VARCHAR2
,     p_filename                 IN       VARCHAR2
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'ASCII'
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 ) := 'HUM_FTP_INTERFACE.GET';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'GET';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END get;

   /*****************************************************************************
   **  Convenience function for single-file DELETE
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION remove (
      p_localpath                IN       VARCHAR2
,     p_filename                 IN       VARCHAR2
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'BINARY'
,     p_mainframe_connection     IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                  := 'HUM_FTP_INTERFACE.REMOVE';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_connection
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := NULL;
      END IF;

      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'DELE';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END remove;

   /*****************************************************************************
   **  Convenience function for single-file RENAME
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION RENAME (
      p_localpath                IN       VARCHAR2
,     p_filename                 IN       VARCHAR2
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'BINARY'
,     p_mainframe_connection     IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                  := 'HUM_FTP_INTERFACE.RENAME';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_connection
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := NULL;
      END IF;

      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'RNFR';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END RENAME;

   /*****************************************************************************
   **  This is used to verify that a server is up or down or even existent
   **  for that matter
   **
   *****************************************************************************/
   FUNCTION verify_server (
      p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'BINARY'
,     p_mainframe_connection     IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                           := 'HUM_FTP_INTERFACE.VERIFY_SERVER';
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 30 ) := p_password;
      v_hostname                    VARCHAR2 ( 30 ) := p_hostname;
      v_remotepath                  VARCHAR2 ( 255 ) := p_remotepath;
      n_port                        PLS_INTEGER := p_port;
      u_ctrl_connection             utl_tcp.connection;
      n_byte_count                  PLS_INTEGER;
      n_first_index                 NUMBER;
      v_msg                         VARCHAR2 ( 1000 );
      v_reply                       VARCHAR2 ( 1000 );
      v_pasv_host                   VARCHAR2 ( 20 );
      n_pasv_port                   NUMBER;
      l_step                        VARCHAR2 ( 1000 );
   BEGIN
      IF p_mainframe_connection
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := NULL;
      END IF;

--
      v_status := 'SUCCESS';
      v_error_message := 'Server connection is valid.';
--Assume the overall transfer will succeed
/** Attempt to connect to the host machine **/
      u_ctrl_con :=
         login ( a_site_in =>                     p_hostname
,                a_port_in =>                     p_port
,                a_user_name =>                   v_username
,                a_user_pass =>                   v_password );
--
      u_ctrl_connection := u_ctrl_con;

--
      /** We should be logged in, time to verify remote path **/
--
      IF    v_remotepath IS NULL
         OR v_remotepath = '.'
      THEN
--
-- Looks like no path is being declared. So let us stay where we are
-- No CWD command required.
--
         l_step := 'REMOTE PATH IS NULL OR CURRENT PATH';
         NULL;
      ELSIF v_remotepath IS NOT NULL AND v_remotepath <> '.'
      THEN
         l_step := 'PERFORMING CWD COMMAND FOR ' || v_remotepath;

--
--
         IF mainframe_connection
         THEN
--
-- Mainframe does not use unix path syntax.
-- We will convert / (fwd slash) to a . (period)
-- and also trim leading fwd slash
--
-- If already periods, then this really won't do anything
--
            v_remotepath := LTRIM ( v_remotepath, '/' );
            v_remotepath := REPLACE ( v_remotepath
,                                     '/'
,                                     '.' );
--
            /** Change to the remotepath directory **/
            n_byte_count :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'CWD ' || '''' || v_remotepath || '''' );
         ELSE
            /** Change to the remotepath directory **/
            n_byte_count :=
                      utl_tcp.write_line ( u_ctrl_con, 'CWD ' || v_remotepath );
         END IF;

--
         IF validate_reply ( u_ctrl_con
,                            cwd_code
,                            v_reply ) = FALSE
         THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
            RAISE ctrl_exception;
         END IF;
      END IF;

--
--
      l_step := 'SEND PASV COMMAND';
--
--
         /** Get a Passive connection to use for data transfer **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'PASV' );

--
      IF validate_reply ( u_ctrl_connection
,                         pasv_code
,                         v_reply ) = FALSE
      THEN
         RAISE ctrl_exception;
      END IF;

      l_step := 'CREATE PASV COMMAND';
--
      create_pasv ( SUBSTR ( v_reply
,                            INSTR ( v_reply
,                                    '('
,                                    1
,                                    1 ) + 1
,                              INSTR ( v_reply
,                                      ')'
,                                      1
,                                      1 )
                             - INSTR ( v_reply
,                                      '('
,                                      1
,                                      1 )
                             - 1 )
,                   v_pasv_host
,                   n_pasv_port );
--
      l_step := 'SEND QUIT COMMAND';
/** Send QUIT command **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'QUIT' );
/** Don't need to VALIDATE QUIT, just close the connection **/
      l_step := 'CLOSING CONNECTION';
      utl_tcp.close_connection ( u_ctrl_connection );
      RETURN TRUE;
   EXCEPTION
      WHEN ctrl_exception
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || v_reply || ' :: ' || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message :=
            c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM || ' :: '
            || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
   END verify_server;

   /*****************************************************************************
   **  Convenience function for dir to local filename
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION dir (
      p_localpath                IN       VARCHAR2
,     p_filename_filter          IN       VARCHAR2 DEFAULT NULL
,     p_dir_filename             IN       VARCHAR2 DEFAULT 'remotedir_list.txt'
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'ASCII'
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 ) := 'HUM_FTP_INTERFACE.DIR';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      l_filename_filter             VARCHAR2 ( 1000 );
      l_dir_filename                VARCHAR2 ( 1000 );
      l_step                        VARCHAR2 ( 1000 );
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_ftp
      THEN
         mainframe_connection := TRUE;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
      IF LTRIM ( RTRIM ( p_dir_filename )) IS NULL
      THEN
         l_dir_filename := 'remotedir_list.txt';
      ELSE
         l_dir_filename := LTRIM ( RTRIM ( p_dir_filename ));
      END IF;

--
      IF LTRIM ( RTRIM ( p_filename_filter )) IS NULL
      THEN
         l_filename_filter := '*';
      ELSE
         l_filename_filter := LTRIM ( RTRIM ( p_filename_filter ));
      END IF;

--
      IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
      THEN
         BEGIN
            l_step := 'REMOVE, IF EXISTING, PREVIOUS REMOTE FILE LISTING';
            utl_file.fremove ( LOCATION =>                      p_localpath
,                              filename =>                      l_dir_filename );
         EXCEPTION
            WHEN utl_file.invalid_path
            THEN
               l_step := 'UTL_FILE.INVALID_PATH';
            WHEN utl_file.read_error
            THEN
               l_step := 'UTL_FILE.READ_ERROR';
            WHEN utl_file.write_error
            THEN
               l_step := 'UTL_FILE.WRITE_ERROR';
            WHEN utl_file.invalid_mode
            THEN
               l_step := 'UTL_FILE.INVALID_MODE';
            WHEN utl_file.invalid_filehandle
            THEN
               l_step := 'UTL_FILE.INVALID_FILEHANDLE';
            WHEN utl_file.invalid_operation
            THEN
               l_step := 'UTL_FILE.INVALID_OPERATION';
            WHEN utl_file.internal_error
            THEN
               l_step := 'UTL_FILE.INTERNAL_ERROR';
            WHEN utl_file.invalid_maxlinesize
            THEN
               l_step := 'UTL_FILE.INVALID_MAXLINESIZE';
            WHEN VALUE_ERROR
            THEN
               l_step := 'UTL_FILE.VALUE_ERROR';
            WHEN OTHERS
            THEN
               l_step := SQLCODE || ' - ' || SQLERRM;
         END;

         print_output ( 'FTP_DEBUG :: INFO :: ' || l_step );
      END IF;

--
      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := l_dir_filename || '#' || l_filename_filter;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'LIST';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

--
      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END dir;

   /*****************************************************************************
   **  Convenience function for dir to local filename
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION ls (
      p_localpath                IN       VARCHAR2
,     p_filename_filter          IN       VARCHAR2 DEFAULT NULL
,     p_dir_filename             IN       VARCHAR2 DEFAULT 'remotedir_list.txt'
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'ASCII'
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 ) := 'HUM_FTP_INTERFACE.LS';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      l_filename_filter             VARCHAR2 ( 1000 );
      l_dir_filename                VARCHAR2 ( 1000 );
      l_step                        VARCHAR2 ( 1000 );
   BEGIN
      v_operation_mode := 'FILE';

      IF p_mainframe_ftp
      THEN
         mainframe_connection := TRUE;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

      IF LTRIM ( RTRIM ( p_dir_filename )) IS NULL
      THEN
         l_dir_filename := 'remotedir_list.txt';
      ELSE
         l_dir_filename := LTRIM ( RTRIM ( p_dir_filename ));
      END IF;

      IF LTRIM ( RTRIM ( p_filename_filter )) IS NULL
      THEN
         l_filename_filter := '*';
      ELSE
         l_filename_filter := LTRIM ( RTRIM ( p_filename_filter ));
      END IF;

--
      IF NVL ( UPPER ( l_ftp_debug ), 'N' ) = 'Y'
      THEN
         BEGIN
            l_step := 'REMOVE, IF EXISTING, PREVIOUS REMOTE FILE LISTING';
            utl_file.fremove ( LOCATION =>                      p_localpath
,                              filename =>                      l_dir_filename );
         EXCEPTION
            WHEN utl_file.invalid_path
            THEN
               l_step := 'UTL_FILE.INVALID_PATH';
            WHEN utl_file.read_error
            THEN
               l_step := 'UTL_FILE.READ_ERROR';
            WHEN utl_file.write_error
            THEN
               l_step := 'UTL_FILE.WRITE_ERROR';
            WHEN utl_file.invalid_mode
            THEN
               l_step := 'UTL_FILE.INVALID_MODE';
            WHEN utl_file.invalid_filehandle
            THEN
               l_step := 'UTL_FILE.INVALID_FILEHANDLE';
            WHEN utl_file.invalid_operation
            THEN
               l_step := 'UTL_FILE.INVALID_OPERATION';
            WHEN utl_file.internal_error
            THEN
               l_step := 'UTL_FILE.INTERNAL_ERROR';
            WHEN utl_file.invalid_maxlinesize
            THEN
               l_step := 'UTL_FILE.INVALID_MAXLINESIZE';
            WHEN VALUE_ERROR
            THEN
               l_step := 'UTL_FILE.VALUE_ERROR';
            WHEN OTHERS
            THEN
               l_step := SQLCODE || ' - ' || SQLERRM;
         END;

         print_output ( 'FTP_DEBUG :: INFO :: ' || l_step );
      END IF;

--
      t_files ( 1 ).localpath := p_localpath;
      t_files ( 1 ).filename := l_dir_filename || '#' || l_filename_filter;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := p_filetype;
      t_files ( 1 ).transfer_mode := 'NLST';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END ls;

--
-- These are for future development
--

   /*****************************************************************************
   **  Convenience function for single-file PUT
   **  Pass CLOB for data to transfer.
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION put_clob (
      p_filename                 IN       VARCHAR2
,     p_clob                     IN       CLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                := 'HUM_FTP_INTERFACE.PUT_CLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';
      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility
      --
      g_data_c := p_clob;

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'CLOB';
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'ASCII';
      t_files ( 1 ).transfer_mode := 'PUT';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END put_clob;

   /*****************************************************************************
   **  Convenience function for single-file GET
   **  Pass CLOB for data to transfer.
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION get_clob (
      p_filename                 IN       VARCHAR2
,     p_clob                     OUT      CLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                := 'HUM_FTP_INTERFACE.GET_CLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'CLOB';
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'ASCII';
      t_files ( 1 ).transfer_mode := 'GET';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility. We then
      -- pass this LOB value back to the calling process
      -- as an out parameter
      --
      IF b_ftp = FALSE
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         p_clob := g_data_c;
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END get_clob;

   /*****************************************************************************
   **  Convenience function for single-file PUT
   **  Pass BLOB for data to transfer.
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION put_blob (
      p_filename                 IN       VARCHAR2
,     p_blob                     IN       BLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                := 'HUM_FTP_INTERFACE.PUT_BLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';
      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility
      --
      g_data_b := p_blob;

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'BLOB';
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'BINARY';
      t_files ( 1 ).transfer_mode := 'PUT';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      IF b_ftp = FALSE
      THEN
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END put_blob;

   /*****************************************************************************
   **  Convenience function for single-file GET
   **  Pass BLOB for data to transfer.
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION get_blob (
      p_filename                 IN       VARCHAR2
,     p_blob                     OUT      BLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE
,     p_mainframe_cmd            IN       VARCHAR2 DEFAULT NULL )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                := 'HUM_FTP_INTERFACE.GET_BLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      err_mf_cmd_missing            EXCEPTION;
      err_mf_cmd_mf_ftp_false       EXCEPTION;
   -- MF cmd present but identified as not a MF ftp job
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';

      IF p_mainframe_ftp AND p_mainframe_cmd IS NULL
      THEN
         RAISE err_mf_cmd_missing;
      ELSIF p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := p_mainframe_cmd;
      ELSIF NOT p_mainframe_ftp AND p_mainframe_cmd IS NOT NULL
      THEN
         RAISE err_mf_cmd_mf_ftp_false;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'BLOB';
      t_files ( 1 ).filename := p_filename;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'BINARY';
      t_files ( 1 ).transfer_mode := 'GET';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility. We then
      -- pass this LOB value back to the calling process
      -- as an out parameter
      --
      IF b_ftp = FALSE
      THEN
         p_blob := g_data_b;
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         p_blob := g_data_b;
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN err_mf_cmd_missing
      THEN
         p_blob := g_data_b;
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Missing Mainframe Command Parameter. i.e. SITE command';
         RETURN FALSE;
      WHEN err_mf_cmd_mf_ftp_false
      THEN
         p_blob := g_data_b;
         v_status := 'ERROR';
         v_error_message :=
               c_process
            || ' :: '
            || 'Mainframe Command Parameter present, but not a Mainframe FTP.';
         RETURN FALSE;
      WHEN OTHERS
      THEN
         p_blob := g_data_b;
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END get_blob;

     /*****************************************************************************
   **  Convenience function for dir to local filename
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION dir_clob (
      p_filename_filter          IN       VARCHAR2 DEFAULT NULL
,     p_clob                     OUT      CLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                := 'HUM_FTP_INTERFACE.DIR_CLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      l_filename_filter             VARCHAR2 ( 1000 );
      l_dir_filename                VARCHAR2 ( 1000 );
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';

      IF p_mainframe_ftp
      THEN
         mainframe_connection := TRUE;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

--
      l_dir_filename := 'remotedir_list.txt';

--
      IF LTRIM ( RTRIM ( p_filename_filter )) IS NULL
      THEN
         l_filename_filter := '*';
      ELSE
         l_filename_filter := LTRIM ( RTRIM ( p_filename_filter ));
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'CLOB';
      t_files ( 1 ).filename := l_dir_filename || '#' || l_filename_filter;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'ASCII';
      t_files ( 1 ).transfer_mode := 'LIST';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility. We then
      -- pass this LOB value back to the calling process
      -- as an out parameter
      --
      IF b_ftp = FALSE
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         p_clob := g_data_c;
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END dir_clob;

   /*****************************************************************************
   **  Convenience function for dir to local filename
   **  Formats file information for ftp_files_stage function and calls it.
   **
   *****************************************************************************/
   FUNCTION ls_clob (
      p_filename_filter          IN       VARCHAR2 DEFAULT NULL
,     p_clob                     OUT      CLOB
,     p_remotepath               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     n_bytes_transmitted        OUT      NUMBER
,     d_trans_start              OUT      DATE
,     d_trans_end                OUT      DATE
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_filetype                 IN       VARCHAR2 := 'ASCII'
,     p_mainframe_ftp            IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                                 := 'HUM_FTP_INTERFACE.LS_CLOB';
      t_files                       t_ftp_rec;
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 50 ) := p_password;
      v_hostname                    VARCHAR2 ( 100 ) := p_hostname;
      n_port                        PLS_INTEGER := p_port;
      v_err_msg                     VARCHAR2 ( 1000 );
      b_ftp                         BOOLEAN;
      l_filename_filter             VARCHAR2 ( 1000 );
      l_dir_filename                VARCHAR2 ( 1000 );
   BEGIN
      --
      -- Set our operation mode to LOB since we will uploading a
      -- LOB that was passed as a parameter
      --
      v_operation_mode := 'LOB';

      IF p_mainframe_ftp
      THEN
         mainframe_connection := TRUE;
      ELSIF NOT p_mainframe_ftp
      THEN
         mainframe_connection := FALSE;
         mainframe_cmd := NULL;
      END IF;

      l_dir_filename := 'remotedir_list.txt';

      IF LTRIM ( RTRIM ( p_filename_filter )) IS NULL
      THEN
         l_filename_filter := '*';
      ELSE
         l_filename_filter := LTRIM ( RTRIM ( p_filename_filter ));
      END IF;

--
-- We have defined our LOB type
-- in our localpath variable since
-- we will not be writing out to the filesystem
-- this value is used within the process
-- as a flag indicator along with
-- operation_mode and filetype to determine
-- how request should be handled
--
      t_files ( 1 ).localpath := 'CLOB';
      t_files ( 1 ).filename := l_dir_filename || '#' || l_filename_filter;
      t_files ( 1 ).remotepath := p_remotepath;
      t_files ( 1 ).filetype := 'ASCII';
      t_files ( 1 ).transfer_mode := 'NLST';
      b_ftp :=
         ftp_files_stage ( v_err_msg
,                          t_files
,                          v_username
,                          v_password
,                          v_hostname
,                          n_port );

      --
      -- Store our LOB parm into our global spec variable
      -- We did this to minimize modification to the existing
      -- code to ensure backwards compatibility. We then
      -- pass this LOB value back to the calling process
      -- as an out parameter
      --
      IF b_ftp = FALSE
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := v_err_msg;
         RETURN FALSE;
      ELSIF b_ftp = TRUE
      THEN
         p_clob := g_data_c;
         v_status := t_files ( 1 ).status;
         v_error_message := t_files ( 1 ).error_message;
         n_bytes_transmitted := t_files ( 1 ).bytes_transmitted;
         d_trans_start := t_files ( 1 ).trans_start;
         d_trans_end := t_files ( 1 ).trans_end;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_clob := g_data_c;
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM;
         RETURN FALSE;
   END ls_clob;

   /*****************************************************************************
   **  This is used to create a directory on a remote server
   **
   *****************************************************************************/
   FUNCTION mkdir_remote (
      p_remotepath               IN       VARCHAR2
,     p_target_dir               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_connection     IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                            := 'HUM_FTP_INTERFACE.MKDIR_REMOTE';
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 30 ) := p_password;
      v_hostname                    VARCHAR2 ( 30 ) := p_hostname;
      v_remotepath                  VARCHAR2 ( 255 ) := p_remotepath;
      n_port                        PLS_INTEGER := p_port;
      u_ctrl_connection             utl_tcp.connection;
      n_byte_count                  PLS_INTEGER;
      n_first_index                 NUMBER;
      v_msg                         VARCHAR2 ( 1000 );
      v_reply                       VARCHAR2 ( 1000 );
      v_pasv_host                   VARCHAR2 ( 20 );
      n_pasv_port                   NUMBER;
      l_step                        VARCHAR2 ( 1000 );
   BEGIN
      IF p_mainframe_connection
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := NULL;
      END IF;

--
      v_status := 'SUCCESS';
      v_error_message := 'Server connection is valid.';
--Assume the overall transfer will succeed
/** Attempt to connect to the host machine **/
      u_ctrl_con :=
         login ( a_site_in =>                     p_hostname
,                a_port_in =>                     p_port
,                a_user_name =>                   v_username
,                a_user_pass =>                   v_password );
--
      u_ctrl_connection := u_ctrl_con;

--
      /** We should be logged in, time to verify remote path **/
--
      IF    v_remotepath IS NULL
         OR v_remotepath = '.'
      THEN
--
-- Looks like no path is being declared. So let us stay where we are
-- No CWD command required.
--
         l_step := 'REMOTE PATH IS NULL OR CURRENT PATH';
         NULL;
      ELSIF v_remotepath IS NOT NULL AND v_remotepath <> '.'
      THEN
         l_step := 'PERFORMING CWD COMMAND FOR ' || v_remotepath;
--------------------------***********************debug here
--
--
         IF mainframe_connection
         THEN
--
-- Mainframe does not use unix path syntax.
-- We will convert / (fwd slash) to a . (period)
-- and also trim leading fwd slash
--
-- If already periods, then this really won't do anything
--
            v_remotepath := LTRIM ( v_remotepath, '/' );
            v_remotepath := REPLACE ( v_remotepath
,                                     '/'
,                                     '.' );
--
            /** Change to the remotepath directory **/
            n_byte_count :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'CWD ' || '''' || v_remotepath || '''' );
         ELSE
            /** Change to the remotepath directory **/
            n_byte_count :=
                      utl_tcp.write_line ( u_ctrl_con, 'CWD ' || v_remotepath );
         END IF;

--
         IF validate_reply ( u_ctrl_con
,                            cwd_code
,                            v_reply ) = FALSE
         THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
            RAISE ctrl_exception;
         END IF;
      END IF;

--
      IF    v_remotepath IS NULL
         OR v_remotepath = '.'
      THEN
         l_step :=
            'PERFORMING MKD COMMAND FOR ' || p_target_dir || ' in current path';
      ELSE
         l_step :=
               'PERFORMING MKD COMMAND FOR '
            || p_target_dir
            || ' in '
            || v_remotepath;
      END IF;

--
-- No separate command set for mainframe because we don't need quotes around the
-- target directory to be created.
--
      n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'MKD ' || p_target_dir );

--
      IF validate_reply ( u_ctrl_con
,                         mkd_code
,                         v_reply ) = FALSE
      THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
         RAISE ctrl_exception;
      END IF;

--
      l_step := 'SEND PASV COMMAND';
--
--
         /** Get a Passive connection to use for data transfer **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'PASV' );

--
      IF validate_reply ( u_ctrl_connection
,                         pasv_code
,                         v_reply ) = FALSE
      THEN
         RAISE ctrl_exception;
      END IF;

      l_step := 'CREATE PASV COMMAND';
--
      create_pasv ( SUBSTR ( v_reply
,                            INSTR ( v_reply
,                                    '('
,                                    1
,                                    1 ) + 1
,                              INSTR ( v_reply
,                                      ')'
,                                      1
,                                      1 )
                             - INSTR ( v_reply
,                                      '('
,                                      1
,                                      1 )
                             - 1 )
,                   v_pasv_host
,                   n_pasv_port );
--

      --
      l_step := 'SEND QUIT COMMAND';
/** Send QUIT command **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'QUIT' );
/** Don't need to VALIDATE QUIT, just close the connection **/
      l_step := 'CLOSING CONNECTION';
      utl_tcp.close_connection ( u_ctrl_connection );
      RETURN TRUE;
   EXCEPTION
      WHEN ctrl_exception
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || v_reply || ' :: ' || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message :=
            c_process || 'the error is here :: ' || SQLCODE || ' - ' || SQLERRM || ' :: '
            || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
   END mkdir_remote;

   /*****************************************************************************
   **  This is used to remove a directory on a remote server
   **
   *****************************************************************************/
   FUNCTION rmdir_remote (
      p_remotepath               IN       VARCHAR2
,     p_target_dir               IN       VARCHAR2
,     p_username                 IN       VARCHAR2
,     p_password                 IN       VARCHAR2
,     p_hostname                 IN       VARCHAR2
,     v_status                   OUT      VARCHAR2
,     v_error_message            OUT      VARCHAR2
,     p_port                     IN       PLS_INTEGER DEFAULT 21
,     p_mainframe_connection     IN       BOOLEAN DEFAULT FALSE )
      RETURN BOOLEAN
   IS
      c_process            CONSTANT VARCHAR2 ( 100 )
                                            := 'HUM_FTP_INTERFACE.RMDIR_REMOTE';
      v_username                    VARCHAR2 ( 30 ) := p_username;
      v_password                    VARCHAR2 ( 30 ) := p_password;
      v_hostname                    VARCHAR2 ( 30 ) := p_hostname;
      v_remotepath                  VARCHAR2 ( 255 ) := p_remotepath;
      n_port                        PLS_INTEGER := p_port;
      u_ctrl_connection             utl_tcp.connection;
      n_byte_count                  PLS_INTEGER;
      n_first_index                 NUMBER;
      v_msg                         VARCHAR2 ( 1000 );
      v_reply                       VARCHAR2 ( 1000 );
      v_pasv_host                   VARCHAR2 ( 20 );
      n_pasv_port                   NUMBER;
      l_step                        VARCHAR2 ( 1000 );
   BEGIN
      IF p_mainframe_connection
      THEN
         mainframe_connection := TRUE;
         mainframe_cmd := NULL;
      END IF;

--
      v_status := 'SUCCESS';
      v_error_message := 'Server connection is valid.';
--Assume the overall transfer will succeed
/** Attempt to connect to the host machine **/
      u_ctrl_con :=
         login ( a_site_in =>                     p_hostname
,                a_port_in =>                     p_port
,                a_user_name =>                   v_username
,                a_user_pass =>                   v_password );
--
      u_ctrl_connection := u_ctrl_con;

--
      /** We should be logged in, time to verify remote path **/
--
      IF    v_remotepath IS NULL
         OR v_remotepath = '.'
      THEN
--
-- Looks like no path is being declared. So let us stay where we are
-- No CWD command required.
--
         l_step := 'REMOTE PATH IS NULL OR CURRENT PATH';
         NULL;
      ELSIF v_remotepath IS NOT NULL AND v_remotepath <> '.'
      THEN
         l_step := 'PERFORMING CWD COMMAND FOR ' || v_remotepath;

--
--
         IF mainframe_connection
         THEN
--
-- Mainframe does not use unix path syntax.
-- We will convert / (fwd slash) to a . (period)
-- and also trim leading fwd slash
--
-- If already periods, then this really won't do anything
--
            v_remotepath := LTRIM ( v_remotepath, '/' );
            v_remotepath := REPLACE ( v_remotepath
,                                     '/'
,                                     '.' );
--
            /** Change to the remotepath directory **/
            n_byte_count :=
               utl_tcp.write_line ( u_ctrl_con
,                                   'CWD ' || '''' || v_remotepath || '''' );
         ELSE
            /** Change to the remotepath directory **/
            n_byte_count :=
                      utl_tcp.write_line ( u_ctrl_con, 'CWD ' || v_remotepath );
         END IF;

--
         IF validate_reply ( u_ctrl_con
,                            cwd_code
,                            v_reply ) = FALSE
         THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
            RAISE ctrl_exception;
         END IF;
      END IF;

--
      IF    v_remotepath IS NULL
         OR v_remotepath = '.'
      THEN
         l_step :=
            'PERFORMING RMD COMMAND FOR ' || p_target_dir || ' in current path';
      ELSE
         l_step :=
               'PERFORMING RMD COMMAND FOR '
            || p_target_dir
            || ' in '
            || v_remotepath;
      END IF;

--
-- No separate command set for mainframe because we don't need quotes around the
-- target directory to be created.
--
      n_byte_count := utl_tcp.write_line ( u_ctrl_con, 'RMD ' || p_target_dir );

--
      IF validate_reply ( u_ctrl_con
,                         rmd_code
,                         v_reply ) = FALSE
      THEN
--                      print_output ( 'user_code= ' || user_code );
--                      print_output ( 'v_reply= ' || v_reply );
         RAISE ctrl_exception;
      END IF;

--
      l_step := 'SEND PASV COMMAND';
--
--
         /** Get a Passive connection to use for data transfer **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'PASV' );

--
      IF validate_reply ( u_ctrl_connection
,                         pasv_code
,                         v_reply ) = FALSE
      THEN
         RAISE ctrl_exception;
      END IF;

      l_step := 'CREATE PASV COMMAND';
--
      create_pasv ( SUBSTR ( v_reply
,                            INSTR ( v_reply
,                                    '('
,                                    1
,                                    1 ) + 1
,                              INSTR ( v_reply
,                                      ')'
,                                      1
,                                      1 )
                             - INSTR ( v_reply
,                                      '('
,                                      1
,                                      1 )
                             - 1 )
,                   v_pasv_host
,                   n_pasv_port );
--
      l_step := 'SEND QUIT COMMAND';
/** Send QUIT command **/
      n_byte_count := utl_tcp.write_line ( u_ctrl_connection, 'QUIT' );
/** Don't need to VALIDATE QUIT, just close the connection **/
      l_step := 'CLOSING CONNECTION';
      utl_tcp.close_connection ( u_ctrl_connection );
      RETURN TRUE;
   EXCEPTION
      WHEN ctrl_exception
      THEN
         v_status := 'ERROR';
         v_error_message := c_process || ' :: ' || v_reply || ' :: ' || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
      WHEN OTHERS
      THEN
         v_status := 'ERROR';
         v_error_message :=
            c_process || ' :: ' || SQLCODE || ' - ' || SQLERRM || ' :: '
            || l_step;
         utl_tcp.close_all_connections;
         RETURN FALSE;
   END rmdir_remote;

   function list(       p_localpath                IN       VARCHAR2
                  ,     p_filename_filter          IN       VARCHAR2 DEFAULT NULL
                  ,     p_dir_filename             IN       VARCHAR2 DEFAULT 'remotedir_list.txt'
                  ,     p_remotepath               IN       VARCHAR2
                  ,     p_username                 IN       VARCHAR2
                  ,     p_password                 IN       VARCHAR2
                  ,     p_hostname                 IN       VARCHAR2
                  ,     v_status                   OUT      VARCHAR2
                  ,     v_error_message            OUT      VARCHAR2
                  ,     n_bytes_transmitted        OUT      NUMBER
                  ,     d_trans_start              OUT      DATE
                  ,     d_trans_end                OUT      DATE
                  ,     p_port                     IN       PLS_INTEGER DEFAULT 21
                  ,     p_filetype                 IN       VARCHAR2 := 'ASCII')

   return nm3type.tab_varchar32767
   is
      l_lines nm3type.tab_varchar32767;
      status boolean;
   begin
      status := ls(p_localpath         => p_localpath
                  ,p_filename_filter   => p_filename_filter
                  ,p_dir_filename      => p_dir_filename
                  ,p_remotepath        => p_remotepath
                  ,p_username          => p_username
                  ,p_password          => p_password
                  ,p_hostname          => p_hostname
                  ,v_status            => v_status
                  ,v_error_message     => v_error_message
                  ,n_bytes_transmitted => n_bytes_transmitted
                  ,d_trans_start       => d_trans_start
                  ,d_trans_end         => d_trans_end );

      if status
       then
         nm3file.GET_FILE(location     => p_localpath
                         ,filename     => p_dir_filename
                         ,all_lines    => l_lines);

         utl_file.fremove (location    => p_localpath
                         ,filename     => p_dir_filename);
      end if;

      return l_lines;
   end list;
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
   /*--------------------- Private Modules ---------------------------
   || The following functions are available only to other modules in
   || package. No user of PS_Parse can see or use these functions.
   ------------------------------------------------------------------*/
   FUNCTION a_delimiter (
      character_in               IN       VARCHAR2
,     delimiters_in              IN       VARCHAR2 := std_delimiters )
      RETURN BOOLEAN
   /*
   || Returns TRUE if the character passsed into the function is found
   || in the list of delimiters.
   */
   IS
   BEGIN
      RETURN INSTR ( delimiters_in, character_in ) > 0;
   END;

   FUNCTION string_length (
      string_in                  IN       VARCHAR2 )
      RETURN INTEGER
   IS
   BEGIN
      RETURN LENGTH ( LTRIM ( RTRIM ( string_in )));
   END;

   FUNCTION next_atom_loc (
      string_in                  IN       VARCHAR2
,     start_loc_in               IN       NUMBER
,     scan_increment_in          IN       NUMBER := +1 )
      /*
      || The next_atom_loc function returns the location
      || in the string of the starting point of the next atomic (from the
      || start location). The function scans forward if scan_increment_in is
      || +1, otherwise it scans backwards through the string. Here is the
      || logic to determine when the next atomic starts:
      ||
      ||      1. If current atomic is a delimiter (if, that is, the character
      ||         at the start_loc_in of the string is a delimiter), then the
      ||         the next character starts the next atomic since all
      ||         delimiters are a single character in length.
      ||
      ||      2. If current atomic is a word (if, that is, the character
      ||         at the start_loc_in of the string is a delimiter), then the
      ||         next atomic starts at the next delimiter. Any letters or
      ||         numbers in between are part of the current atomic.
      ||
      || So I loop through the string a character at a time and apply these
      || tests. I also have to check for end of string. If I scan forward
      || the end of string comes when the SUBSTR which pulls out the next
      || character returns NULL. If I scan backward, then the end of the
      || string comes when the location is less than 0.
      */
   RETURN NUMBER
   IS
      /* Boolean variable which uses private function to determine
      || if the current character is a delimiter or not.
      */
      was_a_delimiter               BOOLEAN
               := a_delimiter ( SUBSTR ( string_in
,                                                 start_loc_in
,                                                 1 ));
      /* If not a delimiter, then it was a word. */
      was_a_word                    BOOLEAN := NOT was_a_delimiter;
      /* The next character scanned in the string */
      next_char                     VARCHAR2 ( 1 );
      /*
      || The value returned by the function. This location is the start
      || of the next atomic found. Initialize it to next character,
      || forward or backward depending on increment.
      */
      return_value                  NUMBER := start_loc_in + scan_increment_in;
   BEGIN
      LOOP
         -- Extract the next character.
         next_char := SUBSTR ( string_in
,                              return_value
,                              1 );
         -- Exit the loop if:
         EXIT WHEN
                  /* On a delimiter, since that is always an atomic */
                  a_delimiter ( next_char )
               OR
                  /* Was a delimiter, but am now in a word. */
                  ( was_a_delimiter AND NOT a_delimiter ( next_char ))
               OR
                  /* Reached end of string scanning forward. */
                  next_char IS NULL
               OR
                  /* Reached beginning of string scanning backward. */
                  return_value < 0;
         /* Shift return_value to move the next character. */
         return_value := return_value + scan_increment_in;
      END LOOP;

      -- If the return_value is negative, return 0, else the return_value
      RETURN GREATEST ( return_value, 0 );
   END;

   PROCEDURE increment_counter (
      counter_inout              IN OUT   NUMBER
,     count_type_in              IN       VARCHAR2
,     atomic_in                  IN       CHAR )
       /*
       || The increment_counter procedure is used by nth_atomic and
       || number_of_atomics to add to the count of of atomics. Since you
       || can request a count by ALL atomics, just the WORD atomics or
       || just the DELIMITER atomics. I use the a_delimiter function to
       || decide whether I should add to the counter. This is not a terribly
       || complex procedure. I bury this logic into a separate module,
   however,
       || to make it easier to read and debug the main body of the programs.
       */
   IS
   BEGIN
      IF    count_type_in = 'ALL'
         OR ( count_type_in = 'WORD' AND NOT a_delimiter ( atomic_in ))
         OR ( count_type_in = 'DELIMITER' AND a_delimiter ( atomic_in ))
      THEN
         counter_inout := counter_inout + 1;
      END IF;
   END increment_counter;

   /* ------------------------- Public Modules -----------------------*/
   PROCEDURE display_atomics (
      table_in                   IN       atoms_tabtype
,     num_rows_in                IN       NUMBER )
   /*
   || Program to dump out contents of table. Notice I must also pass in
   || the number of rows in the table so that I know when to stop the
   || loop. Otherwise I will raise a NO_DATA_FOUND exception. For a more
   || elaborate display_table module, see Chapter 7 on PL/SQL tables.
   */
   IS
   BEGIN
      FOR table_row IN 1 .. num_rows_in
      LOOP
         dbms_output.put_line ( NVL ( table_in ( table_row ), 'NULL' ));
      END LOOP;
   END;

   PROCEDURE parse_string (
      string_in                  IN       VARCHAR2
,     atomics_list_out           OUT      atoms_tabtype
,     num_atomics_out            IN OUT   NUMBER
,     delimiters_in              IN       VARCHAR2 := std_delimiters )
   /*
   || Version of parse_string which stores the list of atomics
   || in a PL/SQL table.
   ||
   || Parameters:
   ||      string_in - the string to be parsed.
   ||      atomics_list_out - the table of atomics.
   ||      num_atomics_out - the number of atomics found.
   ||      delimiters_in - the set of delimiters used in parse.
   */
   IS
   BEGIN
      /* Initialize variables. */
      num_atomics_out := 0;
      len_string := string_length ( string_in );

      IF len_string IS NOT NULL
      THEN
         /*
         || Only scan the string if made of something more than blanks.
         || Start at first non-blank character. Remember: INSTR returns 0
         || if a space is not found. Stop scanning if at end of string.
         */
         start_loc := LEAST ( 1, INSTR ( string_in, ' ' ) + 1 );

         WHILE start_loc <= len_string
         LOOP
            /*
            || Find the starting point of the NEXT atomic. Go ahead and
            || increment counter for the number of atomics. Then have to
            || actually pull out the atomic. Two cases to consider:
            ||      1. Last atomic goes to end of string.
            ||      2. The atomic is a single blank. Use special constant.
            ||      3. Anything else.
            */
            next_loc := next_atom_loc ( string_in, start_loc );
            num_atomics_out := num_atomics_out + 1;

            IF next_loc > len_string
            THEN
               -- Atomic is all characters right to the end of the string.
               atomics_list_out ( num_atomics_out ) :=
                                                SUBSTR ( string_in, start_loc );
            ELSE
               /*
               || Internal atomic. If RTRIMs to NULL, have a blank
               || Use special-case string to stuff a " " in the table.
               */
               atomics_list_out ( num_atomics_out ) :=
                  NVL ( RTRIM ( SUBSTR ( string_in
,                                        start_loc
,                                        next_loc - start_loc ))
,                       a_blank );
            END IF;

            -- Move starting point of scan for next atomic.
            start_loc := next_loc;
         END LOOP;
      END IF;
   END parse_string;

   PROCEDURE parse_string (
      string_in                  IN       VARCHAR2
,     atomics_list_out           IN OUT   VARCHAR2
,     num_atomics_out            IN OUT   NUMBER
,     delimiters_in              IN       VARCHAR2 := std_delimiters )
   /*
   || The version of parse_string which writes the atomics out to a packed
   || list in the format "|A|,|C|". I do not repeat any of the comments
   || from the first iteration of parse_string.
   */
   IS
   BEGIN
      /* Initialize variables */
      num_atomics_out := 0;
      atomics_list_out := NULL;
      len_string := string_length ( string_in );

      IF len_string IS NOT NULL
      THEN
         start_loc := LEAST ( 1, INSTR ( string_in, ' ' ) + 1 );

         WHILE start_loc <= len_string
         LOOP
            next_loc := next_atom_loc ( string_in, start_loc );
            num_atomics_out := num_atomics_out + 1;

            IF next_loc > len_string
            THEN
               atomics_list_out :=
                     atomics_list_out || '|' || SUBSTR ( string_in, start_loc );
            ELSE
               atomics_list_out :=
                     atomics_list_out
                  || '|'
                  || NVL ( RTRIM ( SUBSTR ( string_in
,                                           start_loc
,                                           next_loc - start_loc ))
,                          a_blank );
            END IF;

            start_loc := next_loc;
         END LOOP;

         /* Apply terminating delimiter to the string. */
         atomics_list_out := atomics_list_out || '|';
      END IF;
   END parse_string;

   FUNCTION number_of_atomics (
      string_in                  IN       VARCHAR2
,     count_type_in              IN       VARCHAR2 := 'ALL'
,     delimiters_in              IN       VARCHAR2 := std_delimiters )
      RETURN INTEGER
   /*
   || Counts the number of atomics in the string_in. You can specify the
   || type of count you want: ALL for all atomics, WORD to count only the
   || words and DELIMITER to count only the delimiters. You can optionally
   || pass your own set of delimiters into the function.
   */
   IS
      return_value                  INTEGER := 0;
   BEGIN
      /* Initialize variables. */
      len_string := string_length ( string_in );

      IF len_string IS NOT NULL
      THEN
         /*
         || This loop is much simpler than parse_string. Call the
         || next_atom_loc to move to the next atomic and increment the
         || counter if appropriate. Everything complicated is shifted into
         || sub-programs so that you can read the program "top-down",
         || understand it layer by layer.
         */
         start_loc := LEAST ( 1, INSTR ( string_in, ' ' ) + 1 );

         WHILE start_loc <= len_string
         LOOP
            increment_counter ( return_value
,                               UPPER ( count_type_in )
,                               SUBSTR ( string_in
,                                        start_loc
,                                        1 ));
            start_loc := next_atom_loc ( string_in, start_loc );
         END LOOP;
      END IF;

      RETURN return_value;
   END number_of_atomics;

   FUNCTION nth_atomic (
      string_in                  IN       VARCHAR2
,     nth_in                     IN       NUMBER
,     count_type_in              IN       VARCHAR2 := 'ALL'
,     delimiters_in              IN       VARCHAR2 := std_delimiters )
      RETURN VARCHAR2
   /*
   || Find and return the nth atomic in a string. If nth_in is greater
   || the number of atomics, then return NULL. If nth_in is negative the
   || function counts from the back of the string. You can again request
   || a retrieval by ALL atomics, just the WORDs or just the DELIMITER.
   || So you can ask for the third atomic, or the second word from the end
   || of the string. You can pass your own list of delimiters as well.
   */
   IS
      /* Local copy of string. Supports up to 1000 characters. */
      local_string                  VARCHAR2 ( 1000 )
                             := LTRIM ( RTRIM ( SUBSTR ( string_in
,                                                        1
,                                                        1000 )));
      /* Running count of atomics so far counted. */
      atomic_count                  NUMBER := 1;
      /* Boolean variable which controls the looping logic. */
      still_scanning                BOOLEAN
                                     := local_string IS NOT NULL AND nth_in != 0;
      /* The amount by which I increment the counter. */
      scan_increment                INTEGER;
      /* Return value of function, maximum length of 100 characters. */
      return_value                  VARCHAR2 ( 100 ) := NULL;
   BEGIN
      IF nth_in = 0
      THEN
         /* Not much to do here. Find 0th atomic? */
         RETURN NULL;
      ELSE
         /* Initialize the loop variables. */
         len_string := string_length ( local_string );

         IF nth_in > 0
         THEN
            /* Start at first non-blank character and scan forward. */
            next_loc := 1;
            scan_increment := 1;
         ELSE
            /* Start at last non-blank character and scan backward. */
            next_loc := len_string;
            scan_increment := -1;
         END IF;

         /* Loop through the string until the Boolean is FALSE. */
         WHILE still_scanning
         LOOP
            /* Move start of scan in string to loc of last atomic. */
            start_loc := next_loc;
            /* Find the starting point of the next atomic. */
            next_loc :=
                      next_atom_loc ( local_string
,                                     start_loc
,                                     scan_increment );
            /* Increment the count of atomics. */
            increment_counter ( atomic_count
,                               UPPER ( count_type_in )
,                               SUBSTR ( local_string
,                                        start_loc
,                                        1 ));
            /*
            || Keep scanning if my count hasn't exceeded the request
            || and I am neither at the beginning nor end of the string.
            */
            still_scanning :=
                   atomic_count <= ABS ( nth_in )
               AND next_loc <= len_string
               AND next_loc >= 1;
         END LOOP;

         /*
         || Done with the loop. If my count has not exceeded the requested
         || amount, then there weren't enough atomics in the string to
         || satisfy the request.
         */
         IF atomic_count <= ABS ( nth_in )
         THEN
            RETURN NULL;
         ELSE
            /*
            || I need to extract the atomic from the string. If scanning
            || forward, then I start at start_loc and SUBSTR forward.
            || If I am scanning backwards, I start at next_loc+1 (next_loc
            || is the starting point of the NEXT atomic and I want the
            || current one) and SUBSTR forward (when scanning in
            || reverse, next_loc comes before start_loc in the string.
            */
            IF scan_increment = +1
            THEN
               RETURN SUBSTR ( local_string
,                              start_loc
,                              next_loc - start_loc );
            ELSE
               RETURN SUBSTR ( local_string
,                              next_loc + 1
,                              start_loc - next_loc );
            END IF;
         END IF;
      END IF;
   END nth_atomic;

END x_tfl_ftp_util;
/
