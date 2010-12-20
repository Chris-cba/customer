-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/clean_up.sql-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   clean_up.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:31:50  $
--       Version          : $Revision:   3.0  $
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
/*
Clean up script.
*/

-- Drop temp view tables
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE xsp_temp';
EXCEPTION
WHEN OTHERS THEN
  NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW xsp_invalid_temp';
EXCEPTION
WHEN OTHERS THEN
  NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW xsp_invalid_summary_temp';
EXCEPTION
WHEN OTHERS THEN
  NULL;
END;
/ 
 -- Drop temp tables
 
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_TYPE_SUBCLASS_TEMP CASCADE CONSTRAINTS';
EXCEPTION 
WHEN OTHERS THEN
NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_NW_XSP_TEMP CASCADE CONSTRAINTS';
EXCEPTION 
WHEN OTHERS THEN
NULL;
END;
/
  ALTER TRIGGER NM_ELEMENTS_ALL_B_UPD_NSGN ENABLE;
  ALTER TRIGGER B_UPD_NM_ELEMENTS ENABLE;


