--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/install/ddl_script.sql-arc   1.0   May 09 2012 11:12:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   ddl_script.sql  $
--       Date into PVCS   : $Date:   May 09 2012 11:12:24  $
--       Date fetched Out : $Modtime:   May 09 2012 09:08:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems Ltd, 2012
-----------------------------------------------------------------------------
--
drop table x_bi_pub_reports;

create table x_bi_pub_reports
(bi_report_name VARCHAR2(1000),
bi_server_url       VARCHAR2(1000),
bi_report_folder   VARCHAR2(1000),
bi_param_name   VARCHAR2(1000)
);

drop table x_bi_pub_runtime_params;

create table x_bi_pub_runtime_params
(report_name VARCHAR2(100),
 param_name VARCHAR2(100),
 param_value VARCHAR2(500),
 run_id NUMBER);
 
create sequence x_bi_pub_rep_run_id;
 
 
 
 