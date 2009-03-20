-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/install/Exor_mai_ws_21_inst.sql-arc   1.0   Mar 20 2009 16:00:28   mhuitson  $
--       Module Name      : $Workfile:   Exor_mai_ws_21_inst.sql  $
--       Date into PVCS   : $Date:   Mar 20 2009 16:00:28  $
--       Date fetched Out : $Modtime:   Mar 20 2009 15:55:18  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
/*
||Send output to a log file.
*/
spool Exor_mai_ws_21_inst.log;

/*
||Create Table defect_list_temp.
*/
CREATE GLOBAL TEMPORARY TABLE defect_list_temp
  (dlt_defect_id      NUMBER(8)   NOT NULL
  ,dlt_rep_action_cat VARCHAR2(1) NOT NULL
  ,dlt_budget_id      NUMBER(9))
  ON COMMIT DELETE ROWS
/

/*
||Add Primary Key.
*/
ALTER TABLE defect_list_temp
  ADD (CONSTRAINT dlt_pk PRIMARY KEY (dlt_defect_id,dlt_rep_action_cat))
/

@register_exor_mai_ws_schemas

@mai_api.pkh

@mai_api.pkw

@mai_web_service.pkh

@mai_web_service.pkw

spool off;

@compile_schema

spool compile_all.log;

@compile_all

spool off;