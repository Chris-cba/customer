--------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/wag9998/wag9998.sql-arc   3.0   Dec 11 2009 17:46:38   malexander  $
--       Module Name      : $Workfile:   wag9998.sql  $
--       Date into PVCS   : $Date:   Dec 11 2009 17:46:38  $
--       Date fetched Out : $Modtime:   Dec 11 2009 17:46:20  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
--------------------------------------------------------------------
-- To correct budgets individually, bespoke module for WAG
-- built 10/12/2009 SW for call 723672

set serveroutput on
set ver off
set feed off
col spool new_value spool noprint;
select higgrirp.get_module_spoolpath(&&1,user)||higgrirp.get_module_spoolfile(&&1) spool 
from dual;
spool &spool

prompt
prompt Highways by Exor
exec higgrirp.write_gri_spool(&1,'Highways by Exor');
prompt ================
exec higgrirp.write_gri_spool(&1,'================');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt UKP: Weighting Set Loader
exec higgrirp.write_gri_spool(&1,'MAI: Reset budgets');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt Working ....
exec higgrirp.write_gri_spool(&1,'Working ....');
prompt
exec higgrirp.write_gri_spool(&1,'');
declare
  budget_code item_code_breakdowns.icb_work_code%TYPE;
  road_group  nm_elements_all.ne_unique%TYPE;
  financial_year financial_years.fyr_id%TYPE;
  budget_id   budgets.bud_id%TYPE;

begin
  dbms_output.enable(1000000);
  budget_code  := higgrirp.get_parameter_value(&1,'WORK_CATEGORY');
  road_group := higgrirp.get_parameter_value(&1,'ROAD_ID');
  financial_year  := higgrirp.get_parameter_value(&1,'FINANCIAL_YEAR');
dbms_output.put_line('budget code = '||budget_code||', road_group = '||road_group||', financial year = '||financial_year);

  select bud_id 
  into   budget_id
  from   budgets
  ,      road_segs
  where  bud_rse_he_id = rse_he_id
  and    bud_sys_flag = rse_sys_flag
  and    bud_fyr_id = financial_year
  and    bud_icb_item_code||bud_icb_sub_item_code||bud_icb_sub_sub_item_code = budget_code
  and    rse_he_id = road_group;

  wo_budget_check.valbud_unique(budget_id);
end;
/

set define on
set term off
set head off

exec higgrirp.write_gri_spool(&1,'Finished');
prompt
prompt Finished
exit;

