-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/barnet/FSWMI103_pem_to_sap/install/xpem_invoice_install.sql-arc   2.0   Oct 15 2007 08:46:28   smarshall  $
--       Module Name      : $Workfile:   xpem_invoice_install.sql  $
--       Date into PVCS   : $Date:   Oct 15 2007 08:46:28  $
--       Date fetched Out : $Modtime:   Oct 15 2007 07:48:12  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on SCCS version :

--
--
--   Author : ITurnbull
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
set serverout on size 1000000
set echo off
set head off
set feed off

spool xpem_invoice_install.log

PROMPT
PROMPT Highways by Exor
PROMPT ================
PROMPT
SELECT TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') install_timestamp FROM dual;
SELECT 'Running as ' || USER || '@' || GLOBAL_NAME FROM GLOBAL_NAME;
PROMPT
prompt Installing Barnet PEM Invoice to SAP Interface...
PROMPT

prompt Creating Tables...
--
-- London Borough of Barnet
--
-- PEM Invoice output to SAP
--
-- Supporting tables
--

drop table Xlbb_pem_inv_item_text;
drop table Xlbb_pem_inv_invoice_item;
drop table Xlbb_pem_inv_invoice_header;
drop table Xlbb_pem_inv_batch_header;

drop sequence xlbb_bh_id_seq;
drop sequence xlbb_Ih_id_seq;
drop sequence xlbb_ii_id_seq;
drop sequence xlbb_it_id_seq;
drop sequence xlbb_file_id_seq;

create table Xlbb_pem_inv_batch_header
(
  bh_id number not null
 ,bh_date_created date not null
 ,bh_num_invoices number
 ,bh_num_invoice_items number
 ,bh_filename varchar2(120)
 ,bh_rec_type varchar2(3) DEFAULT 'B##'   not null
 ,Bh_trailer_rec_type varchar2(3) DEFAULT 'T##'   not null
 ,bh_created_by varchar2(100) not null
);

ALTER TABLE XLBB_PEM_INV_BATCH_HEADER ADD
CONSTRAINT xbh_pk
 PRIMARY KEY (BH_ID)
 ENABLE
 VALIDATE;

create sequence xlbb_bh_id_seq;


create table Xlbb_pem_inv_invoice_header
(
 Ih_id   number                      not null
,Ih_bh_id   Number                   not null
,Ih_rec_type   Varchar2(3)           default '1##' not null
,Ih_order_type   Varchar2(4)         default 'ZINV' not null
,Ih_sales_org   Varchar2(4)          default '1000' not null
,Ih_distrib_channel	Varchar2(2)     default '10' not null
,Ih_division	Varchar2(2)           not null
,Ih_sales_office	Varchar2(10)        not null
,Ih_sales_group	Varchar2(10)        not null
,Ih_name	Varchar2(35)
,Ih_sold_to_cust	Varchar2(10)       not null
,Ih_ot_cust_name	Varchar2(40)       default null
,Ih_ot_street2	Varchar2(40)          default null
,Ih_ot_street	Varchar2(60)          default null
,Ih_ot_postcode	Varchar2(10)       default null
,Ih_ot_city	Varchar2(40)             default null
,Ih_po_num	Varchar2(35)             default null
,Ih_cust_group	Varchar2(2)           default null
,Ih_services_rend_date	Varchar2(10) default null
,Ih_billing_date	Date
,Ih_payment_method	Varchar2(1)     default null
,Ih_tax_class	Varchar2(1)
,Ih_ship_to_party	Varchar2(10)       default null
,Ih_bill_to_party	Varchar2(10)       default null
,Ih_payer	Varchar2(10)             default null
);

ALTER TABLE XLBB_PEM_INV_INVOICE_HEADER ADD
CONSTRAINT xlbb_ih_pk
 PRIMARY KEY (IH_ID)
 ENABLE
 VALIDATE;

ALTER TABLE XLBB_PEM_INV_INVOICE_HEADER ADD
CONSTRAINT xlbb_ih_bh_fk
 FOREIGN KEY (IH_BH_ID)
 REFERENCES XLBB_PEM_INV_BATCH_HEADER (BH_ID) ENABLE
 VALIDATE;

create sequence xlbb_Ih_id_seq;


create table Xlbb_pem_inv_invoice_item
(
 Ii_id	Number not null
,Ii_ih_id	Number not null
,Ii_rec_type	Varchar2(3) default '3##' not null
,Ii_mat_code	Varchar2(18) not null
,Ii_description	Varchar2(40)
,Ii_quantity	Varchar2(19) not null
,Ii_profit_centre	Varchar2(10)
,Ii_amount	Number(10,2) not null
,Ii_service_rend_date	date default null
,Ii_po_number	Varchar2(35) default null
);

create sequence xlbb_ii_id_seq;

ALTER TABLE Xlbb_pem_inv_invoice_item ADD
CONSTRAINT xlbb_ii_pk
 PRIMARY KEY (Ii_ID)
 ENABLE
 VALIDATE;

ALTER TABLE Xlbb_pem_inv_invoice_item ADD
CONSTRAINT xlbb_ii_ih_fk
 FOREIGN KEY (Ii_iH_ID)
 REFERENCES Xlbb_pem_inv_invoice_header (iH_ID) ENABLE
 VALIDATE;

create table Xlbb_pem_inv_item_text
(
 It_id	    Number not null
,It_ii_id	 Number not null
,It_rec_type varchar2(3) default '4##' not null
,It_text	    Varchar2(500) not null
);

create sequence xlbb_it_id_seq;

ALTER TABLE Xlbb_pem_inv_item_text ADD
CONSTRAINT xlbb_it_pk
 PRIMARY KEY (It_ID)
 ENABLE
 VALIDATE;

ALTER TABLE Xlbb_pem_inv_item_text ADD
CONSTRAINT xlbb_it_ih_fk
 FOREIGN KEY (It_ii_ID)
 REFERENCES Xlbb_pem_inv_invoice_item (ii_ID) ENABLE
 VALIDATE;


create sequence xlbb_file_id_seq;

drop table Xlbb_sap_to_pem;

create table Xlbb_sap_to_pem
(
  stp_id number not null -- sequence
 ,stp_loaded_date date not null
 ,stp_loaded_by varchar2(30)
 ,stp_filename varchar2(100)
 ,stp_line_id number
 ,stp_line varchar2(1000)
 ,stp_loaded_yn varchar2(1) -- Y or N
);

drop sequence xlbb_stp_id_seq;

create sequence xlbb_stp_id_seq;

ALTER TABLE Xlbb_sap_to_pem ADD
CONSTRAINT xlbb_stp_pk
 PRIMARY KEY (stp_ID)
 ENABLE
 VALIDATE;

-- Z tables for cross reference
create table xlbb_z_sales_office
( zso_enq_class varchar2(5) not null
 ,zso_sales_office varchar2(10) not null
);

ALTER TABLE xlbb_z_sales_office ADD
CONSTRAINT xlbb_zso_pk
 PRIMARY KEY (zso_enq_class,zso_sales_office)
 ENABLE
 VALIDATE;

create table xlbb_z_sales_group
( zsg_enq_class varchar2(5) not null
 ,zsg_sales_group varchar2(10) not null
);

ALTER TABLE xlbb_z_sales_group ADD
CONSTRAINT xlbb_zsg_pk
 PRIMARY KEY (zsg_enq_class,zsg_sales_group)
 ENABLE
 VALIDATE;

create table xlbb_z_service_material
( zsm_enq_class varchar2(5) not null
 ,zsm_enq_type varchar2(5) not null
 ,zsm_service_num varchar2(10) not null
);

ALTER TABLE xlbb_z_service_material ADD
CONSTRAINT xlbb_zsm_pk
 PRIMARY KEY (zsm_enq_class,zsm_enq_type,zsm_service_num)
 ENABLE
 VALIDATE;

--
-- insert z table data
--

insert into xlbb_z_sales_office values ('SKIP','HIGH');
insert into xlbb_z_sales_office values ('XO'  ,'HIGH');

commit;

insert into xlbb_z_sales_group values ('SKIP' ,'SK');
insert into xlbb_z_sales_group values ('XO'   ,'RW');

commit;

insert into xlbb_z_service_material values ('SKIP', 'CO' , '200187');
insert into xlbb_z_service_material values ('XO'  , 'STD', '200187');

commit;

prompt Creating Module Data...

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('XLBB0103', 'PEM Invoice to SAP Extract', 'xlbb0103', 'SQL', NULL,
    'N', 'Y', 'ENQ', NULL);

Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('XLBB0103', 'ENQ_ADMIN', 'NORMAL');

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG,
    GRM_TAG_TABLE, GRM_TAG_COLUMN, GRM_TAG_WHERE, GRM_LINESIZE, GRM_PAGESIZE,
    GRM_PRE_PROCESS)
 Values
   ('XLBB0103', 'SQL', '$PROD_HOME/bin', 'lis', 'N',
    NULL, NULL, NULL, 132, 66,
    NULL);

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS,
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('XLBB0104', 'SAP to PEM Interface ', 'xlbb0104', 'SQL', NULL,
    'N', 'Y', 'ENQ', NULL);

Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('XLBB0104', 'ENQ_ADMIN', 'NORMAL');

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG,
    GRM_TAG_TABLE, GRM_TAG_COLUMN, GRM_TAG_WHERE, GRM_LINESIZE, GRM_PAGESIZE,
    GRM_PRE_PROCESS)
 Values
   ('XLBB0104', 'SQL', '$PROD_HOME/bin', 'lis', 'N',
    NULL, NULL, NULL, 132, 66,
    NULL);


COMMIT;

prompt Creating package...


@@..\admin\pck\xlbb_pem_invoice.pkh
@@..\admin\pck\xlbb_pem_invoice.pkb

prompt
PROMPT Install complete.
PROMPT ================
PROMPT

spool off

set head on
set feed on
set echo on