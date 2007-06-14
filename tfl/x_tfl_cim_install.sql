-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/x_tfl_cim_install.sql-arc   2.0   Jun 14 2007 10:09:44   smarshall  $
--       Module Name      : $Workfile:   x_tfl_cim_install.sql  $
--       Date into SCCS   : $Date:   Jun 14 2007 10:09:44  $
--       Date fetched Out : $Modtime:   Jun 14 2007 10:09:26  $
--       SCCS Version     : $Revision:   2.0  $
--
--
--   Author : Ian Turnbull
--
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

spool x_tfl_cim_install.log


drop table x_tfl_ftp_dirs;

create table x_tfl_ftp_dirs
(
    ftp_type varchar2(5)
   ,ftp_contractor varchar2(12)
   ,ftp_username varchar2(80)
   ,ftp_password varchar2(80)
   ,ftp_host varchar2(30)
   ,ftp_arc_username varchar2(80)
   ,ftp_arc_password varchar2(80)
   ,ftp_arc_host varchar2(30)
   ,ftp_in_dir varchar2(500)
   ,ftp_out_dir varchar2(500)
   ,ftp_arc_in_dir varchar2(500)
   ,ftp_arc_out_dir varchar2(500)
);

insert into x_tfl_ftp_dirs (ftp_type, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_IN_DIR, FTP_OUT_DIR, ftp_arc_in_dir,ftp_arc_out_dir )
values
('CIM', 'AMP','Aimsadmin@10.211.19.21','A1m5Adm1n','10.100.244.18','/aims/amp/in','/aims/amp/out','archive/amp/in','archive/amp/out');

insert into x_tfl_ftp_dirs (ftp_type, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_IN_DIR, FTP_OUT_DIR, ftp_arc_in_dir, ftp_arc_out_dir)
values
('CIM', 'AMY','Aimsadmin@10.211.19.21','A1m5Adm1n','10.100.244.18','/aims/ais/in','/aims/ais/out','archive/ais/in','archive/ais/out');

insert into x_tfl_ftp_dirs (ftp_type, FTP_CONTRACTOR, FTP_USERNAME, FTP_PASSWORD, FTP_HOST, FTP_IN_DIR, FTP_OUT_DIR, ftp_arc_in_dir, ftp_arc_out_dir )
values
('CIM', 'RJB','Aimsadmin@10.211.19.21','A1m5Adm1n','10.100.244.18','/aims/rjl/in','/aims/rjl/out','archive/rjl/in','archive/rjl/out');

commit;

drop table x_tfl_cim_log;

create table x_tfl_cim_log
(
   tcl_id number not null
  ,tcl_date date not null
  ,tcl_con_id varchar2(5) not null
  ,tcl_cim_action varchar2(5) not null
  ,tcl_filename varchar2(80)
  ,tcl_ftp_dir varchar2(500)
  ,tcl_archive_dir varchar2(500)
  ,tcl_interpath varchar2(500)
  ,tcl_message varchar2(1000)
);

ALTER TABLE X_TFL_CIM_LOG ADD
CONSTRAINT x_tfl_cim_log
 PRIMARY KEY (TCL_ID);


drop sequence tcl_id_seq;

create sequence tcl_id_seq;


drop table x_tfl_ftp_queue;

create table x_tfl_ftp_queue
(
    tfq_id number
   ,tfq_date date
   ,tfq_con_id varchar2(5)
   ,tfq_direction varchar2(5)
   ,tfq_filename varchar2(80)
   ,tfq_ftp_site date
   ,tfq_archive date
   ,tfq_import date
   ,tfq_delete date
);

drop sequence tfq_id_seq;

create sequence tfq_id_seq;

--
-- populate doc_query with queries for the reports
--
begin
--
   update hig_modules
   set HMO_APPLICATION = 'HIG'
   where hmo_module = 'DOCWEB0010';
--
   delete doc_query where dq_title in ('x_tfl_ftp_dirs', 'x_tfl_ftp_queue','x_tfl_cim_log');
--
   dm3query.INS_DQ(p_sql => 'select * from x_tfl_ftp_dirs order by ftp_type, ftp_contractor', p_title => 'x_tfl_ftp_dirs', p_desc => 'Settings for the ftp directroies and usernames' );
   dm3query.INS_DQ(p_sql => 'select * from x_tfl_ftp_queue order by tfq_id desc', p_title => 'x_tfl_ftp_queue', p_desc => 'FTP Queue Details' );
   dm3query.INS_DQ(p_sql => 'select * from x_tfl_cim_log order by tcl_id desc', p_title => 'x_tfl_cim_log', p_desc => 'CIM FTP process log details' );
--
   commit;
end;
/


spool off

 