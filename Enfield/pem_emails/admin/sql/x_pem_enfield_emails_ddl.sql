--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Enfield/emails/admin/sql/x_pem_enfield_emails_ddl.sql-arc   1.0   Feb 28 2011 11:53:44   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_pem_enfield_emails_ddl.sql  $
--       Date into PVCS   : $Date:   Feb 28 2011 11:53:44  $
--       Date fetched Out : $Modtime:   Feb 28 2011 10:51:58  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--   
-- x_pem_enfield_emails_ddl
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--   
DROP TABLE x_pem_docs_email;

CREATE TABLE x_pem_docs_email(
	doc_id						NUMBER(9)		NOT NULL,
	processed					VARCHAR2(1) NOT NULL
)
/