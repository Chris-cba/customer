-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/install/Exor_mai_ws_20_inst.sql-arc   1.1   Dec 12 2008 18:50:56   mhuitson  $
--       Module Name      : $Workfile:   Exor_mai_ws_20_inst.sql  $
--       Date into PVCS   : $Date:   Dec 12 2008 18:50:56  $
--       Date fetched Out : $Modtime:   Dec 12 2008 18:36:20  $
--       Version          : $Revision:   1.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
/*
||Send output to a log file.
*/
spool Exor_mai_ws_20_inst.log;

/*
||Create Table defect_list_temp.
*/
CREATE GLOBAL TEMPORARY TABLE defect_list_temp
  (dlt_defect_id NUMBER(8))
  ON COMMIT DELETE ROWS
  NOCACHE
/

/*
||Add Primary Key.
*/
ALTER TABLE defect_list_temp
  ADD (CONSTRAINT dlt_pk PRIMARY KEY (dlt_defect_id))
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