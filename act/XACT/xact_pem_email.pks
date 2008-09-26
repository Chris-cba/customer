CREATE OR REPLACE PACKAGE xact_pem_email
AS
--<PACKAGE>
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:$
--       Module Name      : $Workfile:$
--       Date into PVCS   : $Date:$
--       Date fetched Out : $Modtime:$
--       PVCS Version     : $Revision:$
--
--   Author : Kevin Angus
--
--    xact_pem_email
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -------
  --types
  -------
  subtype t_addr      is varchar2(255);
  type    t_addr_list is table of t_addr index by pls_integer;

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  g_sccsid                CONSTANT varchar2(2000) := '$Revision::            $';

  c_nl                    constant varchar2(1) := chr(10);

  c_BOUNDARY              CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';

  c_FIRST_BOUNDARY        CONSTANT VARCHAR2(256) := '--' || c_BOUNDARY || utl_tcp.CRLF;
  c_LAST_BOUNDARY         CONSTANT VARCHAR2(256) := '--' || c_BOUNDARY || '--' || utl_tcp.CRLF;

  -- A MIME type that denotes multi-part email (MIME) messages.
  c_MULTIPART_MIME_TYPE   CONSTANT VARCHAR2(256) := 'multipart/mixed; boundary="'||
                                                  c_BOUNDARY || '"';

  c_MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER := 76 / 4 * 3;

  c_nuf_gateway           constant nm_upload_file_gateways.nufg_table_name%type := 'DOCS_PEM';

  --This is the text that will appear in the email message
  --It can be editded as desired. The marker c_details_marker will be replaced
  --by details from the enquiry.
  c_details_marker       constant varchar2(30) := '<enq_details>';
  c_email_text           CONSTANT nm3type.max_varchar2
    :=            'Contract Supervisor,'
       || c_nl
       || c_nl || 'We have received a public enquiry that requires your attention.'
       || c_nl
       || c_nl || c_details_marker
       || c_nl
       || c_nl || 'Please see the attached document for more details.'
       || c_nl
       || c_nl || 'Regards,'
       || c_nl
       || c_nl || 'Territory and Municipal Services';

--</GLOBVAR>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_VERSION">
-- This function returns the current SCCS version
FUNCTION get_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_BODY_VERSION">
-- This function returns the current SCCS version of the package body
FUNCTION get_body_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_c_pem_status_send_email">
--
-- This function returns the c_pem_status_send_email constant.
--
FUNCTION get_c_pem_status_send_email RETURN docs.doc_status_code%TYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_pem_status_email_sent">
--
-- This function returns the c_pem_status_email_sen constant.
--
FUNCTION get_pem_status_email_sent RETURN docs.doc_status_code%TYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="send_mail">
--
-- This procedure sends and email for the specified enquiry record.
--
PROCEDURE send_mail(pi_pem_doc_id    in docs.doc_id%type
                   --,pi_from          in t_addr
                   ,pi_to            in varchar2
                   ,pi_cc            in varchar2
                   ,pi_doc_id        in docs.doc_id%type
                   ,pi_subject       in varchar2
                   ,pi_message       in varchar2
                   ,pi_mark_pem_sent in boolean default true
                   );
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="send_mail">
--
-- This function returns the mail user record for the specified username.
--
FUNCTION get_sender(pi_sender_username in user_users.username%type
                   ) RETURN nm_mail_users%rowtype;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_currently_attached">
--
-- This function returns a list of the filenames currently attached to the
-- email produced for the specified enquiry.
--
FUNCTION get_currently_attached(pi_pem_doc_id in docs.doc_id%type
                               ) RETURN nm3type.tab_varchar2000;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_currently_attached">
--
-- This function returns the default email message text.
--
FUNCTION get_email_text RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_details_marker">
--
-- This function returns enquiry details marker that is used in the message
-- text.
--
FUNCTION get_details_marker RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="get_nuf_gateway">
--
-- This function returns the upload file gateway used for the email
-- attachments.
--
FUNCTION get_nuf_gateway RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="set_debug">
--
-- This procedure switches debugging on or off.
--
PROCEDURE set_debug(pi_debug_on IN boolean DEFAULT TRUE
                   );
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PRAGMA>
  PRAGMA RESTRICT_REFERENCES(get_version, rnds, wnps, wnds);
  PRAGMA RESTRICT_REFERENCES(get_body_version, rnds, wnps, wnds);
--</PRAGMA>
--
-----------------------------------------------------------------------------
--
END xact_pem_email;
/

