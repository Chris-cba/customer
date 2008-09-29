-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/XACT/install_pem_email.sql-arc   3.1   Sep 29 2008 10:27:52   smarshall  $
--       Module Name      : $Workfile:   install_pem_email.sql  $
--       Date into PVCS   : $Date:   Sep 29 2008 10:27:52  $
--       Date fetched Out : $Modtime:   Sep 29 2008 10:27:24  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------

SET serverout ON SIZE 1000000
SET echo OFF
SET head OFF
SET feed OFF

spool install_pem_email.log

prompt
prompt Highways by Exor
prompt ================
prompt
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') install_timestamp FROM dual;
SELECT 'Running as ' || USER || '@' || global_name FROM global_name;
prompt
prompt Installing PEM Email...
prompt

prompt Creating tables...

CREATE TABLE xact_pem_email_templates
  (xpet_category          varchar2(4)  NOT NULL
  ,xpet_class             varchar2(4)  NOT NULL
  ,xpet_type              varchar2(4)  NOT NULL
  ,xpet_ne_id             number(9)    NOT NULL
  ,xpet_nmu_id            number(9)    NOT NULL
  ,xpet_dtg_template_name varchar2(30) NOT NULL);

ALTER TABLE xact_pem_email_templates ADD CONSTRAINT xact_pk
  PRIMARY KEY (xpet_category, xpet_class, xpet_type, xpet_ne_id);

ALTER TABLE xact_pem_email_templates ADD CONSTRAINT xact_ne_fk
  FOREIGN KEY (xpet_ne_id) REFERENCES nm_elements_all(ne_id);

CREATE INDEX xact_ne_fk_idx ON xact_pem_email_templates(xpet_ne_id);

ALTER TABLE xact_pem_email_templates ADD CONSTRAINT xact_nmu_fk
  FOREIGN KEY (xpet_nmu_id) REFERENCES nm_mail_users(nmu_id);

CREATE INDEX xact_nmu_fk_idx ON xact_pem_email_templates(xpet_nmu_id);

ALTER TABLE xact_pem_email_templates ADD CONSTRAINT xact_dtg_fk
  FOREIGN KEY (xpet_dtg_template_name) REFERENCES doc_template_gateways(dtg_template_name);

CREATE INDEX xact_dtg_fk_idx ON xact_pem_email_templates(xpet_dtg_template_name);

------
--data
------

--new pem status codes
INSERT INTO hig_status_codes ( hsc_domain_code, hsc_status_code, hsc_status_name, hsc_seq_no,
hsc_allow_feature1, hsc_allow_feature2, hsc_allow_feature3, hsc_allow_feature4, hsc_allow_feature5,
hsc_allow_feature6, hsc_allow_feature7, hsc_allow_feature8, hsc_allow_feature9, hsc_start_date,
hsc_end_date ) VALUES ( 
'COMPLAINTS', 'SE', 'Send Email', 11, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N'
, NULL, NULL); 
INSERT INTO hig_status_codes ( hsc_domain_code, hsc_status_code, hsc_status_name, hsc_seq_no,
hsc_allow_feature1, hsc_allow_feature2, hsc_allow_feature3, hsc_allow_feature4, hsc_allow_feature5,
hsc_allow_feature6, hsc_allow_feature7, hsc_allow_feature8, hsc_allow_feature9, hsc_start_date,
hsc_end_date ) VALUES ( 
'COMPLAINTS', 'ES', 'Email Sent', 12, 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N'
, NULL, NULL);

--hig modules for web pages
prompt Creating hig modules...
INSERT INTO HIG_MODULES ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU ) VALUES ( 
'XDOCWEB0010', 'Enquiry Email Attachments', 'xact_pem_email_web.attach_file', 'WEB'
, NULL, 'N', 'N', 'ENQ', NULL); 
INSERT INTO HIG_MODULES ( HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU ) VALUES ( 
'XDOC0010', 'Enquiry Emails', 'xdoc0010', 'FMX', NULL, 'N', 'N', 'ENQ', 'FORM'); 

INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'XDOCWEB0010', 'ENQ_USER', 'NORMAL'); 
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'XDOCWEB0010', 'ENQ_ADMIN', 'NORMAL'); 
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'XDOC0010', 'ENQ_USER', 'NORMAL'); 
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE, HMR_ROLE, HMR_MODE ) VALUES ( 
'XDOC0010', 'ENQ_ADMIN', 'NORMAL');

INSERT INTO NM_UPLOAD_FILE_GATEWAYS ( NUFG_TABLE_NAME ) VALUES ( 
'DOCS_PEM');   

INSERT INTO NM_UPLOAD_FILE_GATEWAY_COLS ( NUFGC_NUFG_TABLE_NAME, NUFGC_SEQ, NUFGC_COLUMN_NAME,
NUFGC_COLUMN_DATATYPE ) VALUES ( 
'DOCS_PEM', 1, 'DOC_ID', 'NUMBER'); 

INSERT INTO HIG_OPTION_LIST ( HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE,
HOL_MIXED_CASE ) VALUES ( 
'XDOCTMPURL', 'ENQ', 'PEM docs temp URL', 'The URL of the temporary file area for PEM documents.'
, NULL, 'VARCHAR2', 'Y'); 

INSERT INTO HIG_OPTION_VALUES ( HOV_ID, HOV_VALUE ) VALUES ( 
'XDOCTMPURL', 'http://mac040:81/documents');
 
INSERT INTO HIG_OPTION_LIST ( HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE,
HOL_MIXED_CASE ) VALUES ( 
'XDOCTMPDIR', 'ENQ', 'PEM docs temp dir', 'The temporary file area for PEM documents.'
, NULL, 'VARCHAR2', 'Y'); 

INSERT INTO HIG_OPTION_VALUES ( HOV_ID, HOV_VALUE ) VALUES ( 
'XDOCTMPDIR', '\\mac040\documents');

INSERT INTO HIG_OPTION_LIST ( HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE,
HOL_MIXED_CASE ) VALUES ( 
'XDEFRPLADD', 'ENQ', 'PEM Email From', 'The email address used as "From" when sending PEM documents.'
, NULL, 'VARCHAR2', 'Y'); 

INSERT INTO HIG_OPTION_VALUES ( HOV_ID, HOV_VALUE ) VALUES ( 
'XDEFRPLADD', 'iamsreplies@act.gov.au');


prompt Creating packages...

@@xact_pem_email.pkh
@@xact_pem_email_web.pkh

@@xact_pem_email.pkb
@@xact_pem_email_web.pkb

prompt
prompt Install complete.
prompt =================
prompt

spool OFF

SET head ON
SET feed ON
