set serverout on size 1000000
set echo off
set head off
set feed off

spool install_barnet_sap_wo_interface.log

PROMPT
PROMPT Highways by Exor
PROMPT ================
PROMPT
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') install_timestamp FROM dual;
SELECT 'Running as ' || USER || '@' || GLOBAL_NAME FROM GLOBAL_NAME;
PROMPT
prompt Installing Barnet SAP Work Order Interface...
PROMPT

prompt Creating Interface control Table...

create table xlbb_sap_wo_control
  (xswc_last_run_sequence number(6)    not null
  ,xswc_last_run_date     date         not null
  ,xswc_last_run_user     varchar2(30) not null);

insert into
  xlbb_sap_wo_control(xswc_last_run_sequence, xswc_last_run_date, xswc_last_run_user)
values
  (0, to_date('01-jan-1900', 'dd-mon-yyyy'), user);


prompt Creating work order log table...

create table xlbb_sap_wo_log
  (xswl_works_order_no      varchar2(16) not null
  ,xswl_user_last_processed varchar2(30) DEFAULT USER NOT NULL
  ,xswl_date_last_processed date         DEFAULT SYSDATE NOT NULL);

ALTER TABLE xlbb_sap_wo_log ADD CONSTRAINT xswl_pk PRIMARY KEY (xswl_works_order_no);

alter table xlbb_sap_wo_log add constraint xswl_wor_fk foreign key (xswl_works_order_no) references work_orders(wor_works_order_no);

prompt Creating Module Data...

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('XLBB0107', 'SAP Work Order Interface Extract', 'xlbb0107', 'SQL', NULL,
    'N', 'Y', 'MAI', NULL);

Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('XLBB0107', 'MAI_ADMIN', 'NORMAL');

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG,
    GRM_TAG_TABLE, GRM_TAG_COLUMN, GRM_TAG_WHERE, GRM_LINESIZE, GRM_PAGESIZE,
    GRM_PRE_PROCESS)
 Values
   ('XLBB0107', 'SQL', '$PROD_HOME/bin', 'lis', 'N',
    NULL, NULL, NULL, 132, 66,
    NULL);


COMMIT;

prompt Creating package...

@@..\admin\pck\xlbb_sap_wo_interface.pkh
@@..\admin\pck\xlbb_sap_wo_interface.pkb

prompt
PROMPT Install complete.
PROMPT ================
PROMPT

spool off

set head on
set feed on
set echo on