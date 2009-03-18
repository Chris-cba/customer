CREATE OR REPLACE PACKAGE BODY XRTA_NM_UNIQUE IS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/rta/XRTA_NM_UNIQUE.pkb-arc   1.1   Mar 18 2009 17:05:20   cstrettle  $
--       Module Name      : $Workfile:   XRTA_NM_UNIQUE.pkb  $
--       Date into PVCS   : $Date:   Mar 18 2009 17:05:20  $
--       Date fetched Out : $Modtime:   Mar 18 2009 16:55:46  $
--       Version          : $Revision:   1.1  $
--       Based on SCCS version : NA
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.1  $';

  g_package_name CONSTANT varchar2(30) := 'XRTA_NM_UNIQUE';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE XRTA_ERROR(P_ERROR_NE_ID NUMBER, P_ERROR VARCHAR2,P_ETYPE VARCHAR2) IS
--
 PRAGMA AUTONOMOUS_TRANSACTION;
--
BEGIN
--
  INSERT INTO XRTA_ERRORS
  (XRTAE_NE_ID,
   XRTAE_TYPE,
   XRTAE_SQL_ERROR)
   VALUES
  (P_ERROR_NE_ID,
   P_ETYPE,
   P_ERROR);
--  
  COMMIT;  
--
END XRTA_ERROR;
--
PROCEDURE XRTA_NM_UNIQUE_INSERT(P_NE_ID NUMBER, P_TYPE VARCHAR2) AS
--
 L_ERROR VARCHAR2(4000);
--
 PRAGMA AUTONOMOUS_TRANSACTION;
--
BEGIN
--  
  INSERT INTO XRTA_NM_UNIQUES
  (XRTA_NE_ID,
   XRTA_TYPE,
   XRTA_DT_MODIFIED)                            
  VALUES
  (P_NE_ID,
   P_TYPE,
   SYSDATE);    
--  
  COMMIT;
--  
EXCEPTION
WHEN OTHERS THEN
-- 
 L_ERROR := '----- PL/SQL Error -----' || CHR(10) || 
 SQLERRM || CHR(10) || 
 CHR(10) || 
 dbms_utility.format_call_stack;
-- 
  XRTA_ERROR(P_NE_ID, L_ERROR, P_TYPE);
--  
END XRTA_NM_UNIQUE_INSERT;
--
PROCEDURE XTRA_LOAD_ELEMENTS IS
  cursor elements_cur is     
  SELECT ne_id
    FROM nm_elements_all;
BEGIN  
--
  FOR elements_rec IN elements_cur 
  LOOP
  XRTA_NM_UNIQUE_INSERT(elements_rec.ne_id, 'E');
  END LOOP;
--
COMMIT;
--
END XTRA_LOAD_ELEMENTS;
--
PROCEDURE XRTA_LOAD_ITEMS IS
  cursor items_cur 
  is     
  SELECT iit_ne_id
    FROM nm_inv_items_all;
--
BEGIN
--
  FOR item_rec IN items_cur 
  LOOP
  XRTA_NM_UNIQUE_INSERT(item_rec.iit_ne_id, 'I');
  END LOOP;
--
COMMIT;
--
END XRTA_LOAD_ITEMS;
--
BEGIN
NULL;
END XRTA_NM_UNIQUE;
/