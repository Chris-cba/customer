--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)install_may_gurney_interface.sql	1.1 09/20/06
--       Module Name      : install_may_gurney_interface.sql
--       Date into SCCS   : 06/09/20 15:54:20
--       Date fetched Out : 07/06/06 14:38:56
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   HMS May Gurney Interface Installation Script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
SET serverout ON SIZE 1000000
SET echo OFF
SET head OFF
SET feed OFF

spool install_may_gurney_interface.log

prompt
prompt Highways by Exor
prompt ================
prompt
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') install_timestamp FROM dual;
SELECT 'Running as ' || USER || '@' || global_name FROM global_name;
prompt
prompt Installing the HMS May Gurney Interface...
prompt

prompt Creating tables...

CREATE TABLE xnor_may_gurney_wols
  (xmgw_wol_id              number(9)    NOT NULL
  ,xmgw_commitment_value    number(10,2)
  ,xmgw_payment_value       number(10,2)
  ,xmgw_user_last_processed varchar2(30) DEFAULT USER NOT NULL
  ,xmgw_date_last_processed date         DEFAULT SYSDATE NOT NULL);
  
ALTER TABLE xnor_may_gurney_wols ADD CONSTRAINT xmgw_pk PRIMARY KEY (xmgw_wol_id);

COMMENT ON TABLE xnor_may_gurney_wols                           IS 'This table is a log of work order lines processed by the HMS May Gurney Interface.';

COMMENT ON COLUMN xnor_may_gurney_wols.xmgw_wol_id              IS 'Work order line ID.';

COMMENT ON COLUMN xnor_may_gurney_wols.xmgw_commitment_value    IS 'The estimated cost of an instructed work order line.';

COMMENT ON COLUMN xnor_may_gurney_wols.xmgw_payment_value       IS 'The actual cost of an completed work order line to be paid to the contractor.';

COMMENT ON COLUMN xnor_may_gurney_wols.xmgw_user_last_processed IS 'The user who performed the last interface run that affected this row.';

COMMENT ON COLUMN xnor_may_gurney_wols.xmgw_date_last_processed IS 'The date of the last interface run that affected this row.';

prompt Creating packages...

@@xnor_may_gurney_interface.pkh
@@xnor_may_gurney_interface.pkb

prompt Creating metadata...

---------
--modules
---------
INSERT INTO hig_modules
       (hmo_module
       ,hmo_title
       ,hmo_filename
       ,hmo_module_type
       ,hmo_fastpath_opts
       ,hmo_fastpath_invalid
       ,hmo_use_gri
       ,hmo_application
       ,hmo_menu
       )
SELECT 
        'XNOR0001'
       ,'Generate May Gurney Order File'
       ,'xnor0001'
       ,'SQL'
       ,''
       ,'N'
       ,'Y'
       ,'MAI'
       ,NULL FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM hig_modules
                   WHERE hmo_module = 'XNOR0001');

INSERT INTO hig_modules
       (hmo_module
       ,hmo_title
       ,hmo_filename
       ,hmo_module_type
       ,hmo_fastpath_opts
       ,hmo_fastpath_invalid
       ,hmo_use_gri
       ,hmo_application
       ,hmo_menu
       )
SELECT 
        'XNOR0002'
       ,'Generate May Gurney Payments File'
       ,'xnor0002'
       ,'SQL'
       ,''
       ,'N'
       ,'Y'
       ,'MAI'
       ,NULL FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM hig_modules
                   WHERE hmo_module = 'XNOR0002');

INSERT INTO hig_module_roles
       (hmr_module
       ,hmr_role
       ,hmr_mode
       )
SELECT 
        'XNOR0001'
       ,'MAI_ADMIN'
       ,'NORMAL' FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM hig_module_roles
                   WHERE hmr_module = 'XNOR0001'
                    AND  hmr_role = 'MAI_ADMIN');

INSERT INTO hig_module_roles
       (hmr_module
       ,hmr_role
       ,hmr_mode
       )
SELECT 
        'XNOR0002'
       ,'MAI_ADMIN'
       ,'NORMAL' FROM dual
 WHERE NOT EXISTS (SELECT 1 FROM hig_module_roles
                   WHERE hmr_module = 'XNOR0002'
                    AND  hmr_role = 'MAI_ADMIN');

----------
--GRI Data
----------
INSERT INTO gri_modules ( grm_module, grm_module_type, grm_module_path, grm_file_type, grm_tag_flag,
grm_tag_table, grm_tag_column, grm_tag_where, grm_linesize, grm_pagesize,
grm_pre_process ) VALUES ( 
'XNOR0001', 'SQL', '$PROD_HOME/bin', 'lis', 'N', NULL, NULL, NULL, 132, 66, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0001', 'CONTRACTOR_ID', 1, 'Contractor Id', 'Y', 1, 'OUN_ORG_UNIT_TYPE=''CO'''
, 'N', NULL, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, 'N', 'Contractor Identifier', 'N'
, NULL, NULL, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0001', 'FINANCIAL_YEAR', 2, 'Financial Year', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'Restricts the results to budgets within this financial year.', 'N'
, NULL, NULL, NULL); 

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0001', 'FROM_DATE', 3, 'Start Date', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'Start date for the extract.', 'N'
, NULL, NULL, NULL); 

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0001', 'TO_DATE', 4, 'End Date', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'End date for the extract.', 'N'
, NULL, NULL, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0001', 'TEXT', 5, 'File path', 'N', 1, NULL, 'N', NULL, 'HIG_USER_OPTIONS', 'HUO_VALUE'
, 'HUO_ID = ''INTERPATH'' AND HUO_HUS_USER_ID = (SELECT MAX(HUS_USER_ID) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
, 'N', 'N', 'N', NULL, 'N', 'The location the file is to be created. NOTE: Must be referenced in INIT.ORA'
, 'N', NULL, NULL, NULL);

INSERT INTO gri_modules ( grm_module, grm_module_type, grm_module_path, grm_file_type, grm_tag_flag,
grm_tag_table, grm_tag_column, grm_tag_where, grm_linesize, grm_pagesize,
grm_pre_process ) VALUES ( 
'XNOR0002', 'SQL', '$PROD_HOME/bin', 'lis', 'N', NULL, NULL, NULL, 132, 66, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0002', 'CONTRACT_ID', 1, 'Contract Id', 'Y', 1, NULL
, 'N', NULL, NULL, NULL, NULL, 'Y', 'N', 'Y', NULL, 'N', 'Contract Identifier', 'N'
, NULL, NULL, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0002', 'FINANCIAL_YEAR', 2, 'Financial Year', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'Restricts the results to budgets within this financial year.', 'N'
, NULL, NULL, NULL); 

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0002', 'FROM_DATE', 3, 'Start Date', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'Start date for the extract.', 'N'
, NULL, NULL, NULL); 

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0002', 'TO_DATE', 4, 'End Date', 'Y', 1, NULL, 'N', NULL, NULL, NULL, NULL
, 'Y', 'N', 'N', NULL, 'N', 'End date for the extract.', 'N'
, NULL, NULL, NULL);

INSERT INTO gri_module_params ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XNOR0002', 'TEXT', 5, 'File path', 'N', 1, NULL, 'N', NULL, 'HIG_USER_OPTIONS', 'HUO_VALUE'
, 'HUO_ID = ''INTERPATH'' AND HUO_HUS_USER_ID = (SELECT MAX(HUS_USER_ID) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
, 'N', 'N', 'N', NULL, 'N', 'The location the file is to be created. NOTE: Must be referenced in INIT.ORA'
, 'N', NULL, NULL, NULL);

-----------------
--product options
-----------------
INSERT INTO hig_option_list ( hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype,
hol_mixed_case ) VALUES ( 
'FIMREVCODE', 'MAI', 'Reversal Cost Code', 'This is the cost code used when generating reversals in the files created for the HMS May Gurney interface.'
, NULL, 'VARCHAR2', 'N');
INSERT INTO hig_option_values ( hov_id, hov_value ) VALUES ( 
'FIMREVCODE', 'PX1997-B9900-000000');

INSERT INTO hig_option_list ( hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype,
hol_mixed_case ) VALUES ( 
'NCCVATRATE', 'MAI', 'May Gurney Interface VAT Rate', 'The VAT rate used for the May Gurney payments file extract.'
, NULL, 'VARCHAR2', 'N');
INSERT INTO hig_option_values ( hov_id, hov_value ) VALUES ( 
'NCCVATRATE', '17.5');

INSERT INTO hig_option_list ( hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype,
hol_mixed_case ) VALUES ( 
'NCCVATCODE', 'MAI', 'May Gurney Interface VAT Code', 'The VAT code used in the May Gurney payments file extract.'
, NULL, 'VARCHAR2', 'N');
INSERT INTO hig_option_values ( hov_id, hov_value ) VALUES ( 
'NCCVATCODE', '10-ZZZZZZ-B3870-');


COMMIT;


prompt Install complete.
prompt =================
prompt

spool OFF

SET head ON
SET feed ON
SET echo ON
