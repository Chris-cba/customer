-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/install/Exor_mai_ws_20_inst.sql-arc   1.0   Dec 12 2008 14:12:28   mhuitson  $
--       Module Name      : $Workfile:   Exor_mai_ws_20_inst.sql  $
--       Date into PVCS   : $Date:   Dec 12 2008 14:12:28  $
--       Date fetched Out : $Modtime:   Dec 12 2008 14:12:04  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
/*
||Create Table defect_list_temp.
*/
CREATE OR REPLACE GLOBAL TEMPORARY TABLE defect_list_temp
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
