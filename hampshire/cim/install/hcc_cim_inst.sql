--
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/hampshire/cim/install/hcc_cim_inst.sql-arc   2.1   Aug 21 2007 16:03:56   Ian Turnbull  $
--       Module Name      : $Workfile:   hcc_cim_inst.sql  $
--       Date into PVCS   : $Date:   Aug 21 2007 16:03:56  $
--       Date fetched Out : $Modtime:   Aug 21 2007 15:44:58  $
--       PVCS Version     : $Revision:   2.1  $
--
-- Hampshire CIM Automation
-- 
clear screen
Prompt
Prompt Hampshire CIM Automation install.
Prompt 
Prompt Dropping existing x_hcc_cim_log table
drop table x_hcc_cim_log;

Prompt 
Prompt Creating x_hcc_cim_log table

create table x_hcc_cim_log
( hcl_id number not null
 ,hcl_date date not null
 ,hcl_text varchar2(1000) not null
);

prompt
prompt drop sequence xhcl_id_seq;
drop sequence xhcl_id_seq;

prompt
prompt create sequence xhcl_id_seq;
create sequence xhcl_id_seq;


Prompt Dropping existing x_hcc_cim_dirs table
drop table x_hcc_cim_dirs;

Prompt 
Prompt Creating x_hcc_cim_dirs table
create table x_hcc_cim_dirs
( hcd_direction varchar2(3) not null
 ,hcd_directory varchar2(500) not null
);

Prompt 
Prompt Enter values as requested, press enter after each one.

undefine p_out_dir
undefine p_in_dir

ACCEPT p_out_dir char prompt 'ENTER THE OUTGOING FTP DIRECTORY    : ';
ACCEPT p_in_dir  char prompt 'ENTER THE INCOMING FTP DIRECTORY    : ';

Prompt
Prompt Inerting values into table

SET verify OFF;
SET feedback OFF;
SET serveroutput ON

declare
p_out_dir varchar2(100) := UPPER('&p_out_dir');
p_in_dir varchar2(100) := UPPER('&p_in_dir');
begin 
   insert into  x_hcc_cim_dirs
    ( hcd_direction ,hcd_directory)
   values 
    ( 'OUT',p_out_dir);
   commit;
   insert into  x_hcc_cim_dirs
    ( hcd_direction ,hcd_directory)
   values 
    ( 'IN',p_in_dir);
   commit;
end;
/
set feedback on 
select * from x_hcc_cim_dirs; 
Prompt
Prompt Finished
Prompt
  