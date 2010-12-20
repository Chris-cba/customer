-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/install_metadata.sql-arc   3.0   Dec 20 2010 10:44:16   Ade.Edwards  $
--       Module Name      : $Workfile:   install_metadata.sql  $
--       Date into PVCS   : $Date:   Dec 20 2010 10:44:16  $
--       Date fetched Out : $Modtime:   Dec 20 2010 10:32:38  $
--       Version          : $Revision:   3.0  $
--
--       Author : Chris Strettle
--
-----------------------------------------------------------------------------
--  Copyright (c) Bentley Systems, 2010
-----------------------------------------------------------------------------
--
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_TYPE_SUBCLASS_TEMP CASCADE CONSTRAINTS';
EXCEPTION 
WHEN OTHERS THEN
NULL;
END;
/

CREATE TABLE NM_TYPE_SUBCLASS_TEMP
(
  NSC_NW_TYPE    VARCHAR2(4)  NOT NULL,
  NSC_SUB_CLASS  VARCHAR2(4)  NOT NULL,
  NSC_DESCR      VARCHAR2(80),
  NSC_SEQ_NO     NUMBER(4)    NOT NULL
);

Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'A', 'A ROADS', 1);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'B', 'B ROADS', 2);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'C', 'C ROADS', 3);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'U', 'U ROADS', 4);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'MP', 'MP ROADS', 5);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'NM', 'NM ROADS', 6);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'PV', 'PV ROADS', 7);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'V', 'V ROADS', 8);
Insert into NM_TYPE_SUBCLASS_TEMP
   (NSC_NW_TYPE, NSC_SUB_CLASS, NSC_DESCR, NSC_SEQ_NO)
 Values
   ('HERM', 'FC', 'FC ROADS', 9);
COMMIT;
--
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_NW_XSP_TEMP CASCADE CONSTRAINTS';
EXCEPTION 
WHEN OTHERS THEN
NULL;
END;
/
--
CREATE TABLE NM_NW_XSP_TEMP
(
  NWX_NW_TYPE        VARCHAR2(4)           NOT NULL,
  NWX_X_SECT         VARCHAR2(4)           NOT NULL,
  NWX_NSC_SUB_CLASS  VARCHAR2(4)           NOT NULL,
  NWX_DESCR          VARCHAR2(80),
  NWX_SEQ            NUMBER(4),
  NWX_OFFSET         NUMBER
);
--
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'A', 'LEFT O/S VG', 1,  -7);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'B', 'LEFT O/S VG', 2, -6);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'C', 'LEFT O/S VG', 3, -5.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'U', 'LEFT O/S VG', 4, -5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'MP', 'LEFT O/S VG', 5, -5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'NM', 'LEFT O/S VG', 6, -5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'PV', 'LEFT O/S VG', 7, -5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'V', 'LEFT O/S VG', 8, -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '1', 'FC', 'LEFT O/S VG', 9,-2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'A', 'LEFT FW', 1, -5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'B', 'LEFT FW', 2, -4);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'C', 'LEFT FW', 3, -3.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'U', 'LEFT FW', 4, -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'MP', 'LEFT FW', 5, -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'NM', 'LEFT FW', 6, -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'PV', 'LEFT FW', 7, -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '2', 'V', 'LEFT FW', 8, -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'A', 'LEFT VG', 1, -4);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'B', 'LEFT VG', 2, 
    -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'C', 'LEFT VG', 3, 
    -2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'U', 'LEFT VG', 4, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'MP', 'LEFT VG', 5, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'NM', 'LEFT VG', 6, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'PV', 'LEFT VG', 7, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'V', 'LEFT VG', 8, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '3', 'FC', 'LEFT VG', 9, 
    -1);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'A', 'LANE 1', 1, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'B', 'LANE 1', 2, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'C', 'LANE 1', 3, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'U', 'LANE 1', 4, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'MP', 'LANE 1', 5, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'NM', 'LANE 1', 6, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'PV', 'LANE 1', 7, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'V', 'LANE 1', 8, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '4', 'FC', 'LANE 1', 9, 
    0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'A', 'LANE 2', 1, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'B', 'LANE 2', 2, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'C', 'LANE 2', 3, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'U', 'LANE 2', 4, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'MP', 'LANE 2', 5, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'NM', 'LANE 2', 6, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'PV', 'LANE 2', 7, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'V', 'LANE 2', 8, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '5', 'FC', 'LANE 2', 9, 
    0.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'A', 'LANE 3', 1, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'B', 'LANE 3', 2, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'C', 'LANE 3', 3, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'U', 'LANE 3', 4, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'MP', 'LANE 3', 5, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'NM', 'LANE 3', 6, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'PV', 'LANE 3', 7, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'V', 'LANE 3', 8, 
    1);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '6', 'FC', 'LANE 3', 9, 
    0.75);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'A', 'LANE 4', 1, 
    4);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'B', 'LANE 4', 2, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'C', 'LANE 4', 3, 
    2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'U', 'LANE 4', 4, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'MP', 'LANE 4', 5, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'NM', 'LANE 4', 6, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'PV', 'LANE 4', 7, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'V', 'LANE 4', 8, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '7', 'FC', 'LANE 4', 9, 
    1);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'A', 'RIGHT VG', 1, 
    4.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'B', 'RIGHT VG', 2, 
    3.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'C', 'RIGHT VG', 3, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'U', 'RIGHT VG', 4, 
    2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'MP', 'RIGHT VG', 5, 
    2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'NM', 'RIGHT VG', 6, 
    2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'PV', 'RIGHT VG', 7, 
    2.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'V', 'RIGHT VG', 8, 
    1.75);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '8', 'FC', 'RIGHT VG', 9, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'A', 'RIGHT FW', 1, 
    5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'B', 'RIGHT FW', 2, 
    4);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'C', 'RIGHT FW', 3, 
    3.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'U', 'RIGHT FW', 4, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'MP', 'RIGHT FW', 5, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'NM', 'RIGHT FW', 6, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'PV', 'RIGHT FW', 7, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'V', 'RIGHT FW', 8, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '9', 'FC', 'RIGHT FW', 9, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'A', 'RIGHT O/S VG', 1, 
    7);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'B', 'RIGHT O/S VG', 2, 
    6);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'C', 'RIGHT O/S VG', 3, 
    5.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'U', 'RIGHT O/S VG', 4, 
    5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'MP', 'RIGHT O/S VG', 5, 
    5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'NM', 'RIGHT O/S VG', 6, 
    5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'PV', 'RIGHT O/S VG', 7, 
    5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'V', 'RIGHT O/S VG', 8, 
    3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', '0', 'FC', 'RIGHT O/S VG', 9, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'A', 'ACCEL SPLAY', 1, 
    -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'B', 'ACCEL SPLAY', 2, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'C', 'ACCEL SPLAY', 3, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'U', 'ACCEL SPLAY', 4, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'MP', 'ACCEL SPLAY', 5, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'NM', 'ACCEL SPLAY', 6, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Q', 'PV', 'ACCEL SPLAY', 7, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'A', 'L-TURN DECEL', 1, 
    -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'B', 'L-TURN DECEL', 2, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'C', 'L-TURN DECEL', 3, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'U', 'L-TURN DECEL', 4, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'MP', 'L-TURN DECEL', 5, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'NM', 'L-TURN DECEL', 6, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'W', 'PV', 'L-TURN DECEL', 7, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'A', 'R-TURN REFUGE', 1, 
    2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'B', 'R-TURN REFUGE', 2, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'C', 'R-TURN REFUGE', 3, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'U', 'R-TURN REFUGE', 4, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'MP', 'R-TURN REFUGE', 5, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'NM', 'R-TURN REFUGE', 6, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'E', 'PV', 'R-TURN REFUGE', 7, 
    1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'A', 'BUS LANE', 1, 
    -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'B', 'BUS LANE', 2, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'C', 'BUS LANE', 3, 
    -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'U', 'BUS LANE', 4, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'MP', 'BUS LANE', 5, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'NM', 'BUS LANE', 6, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'R', 'PV', 'BUS LANE', 7, 
    -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'A', 'CRAWL LANE', 1, 
    -3);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'B', 'CRAWL LANE', 2, -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'C', 'CRAWL LANE', 3, -2);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'U', 'CRAWL LANE', 4, -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'MP', 'CRAWL LANE', 5, -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'NM', 'CRAWL LANE', 6, -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'T', 'PV', 'CRAWL LANE', 7, -1.5);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'A', 'OTHER', 1, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'B', 'OTHER', 2, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'C', 'OTHER', 3, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'U', 'OTHER', 4, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'MP', 'OTHER', 5, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'NM', 'OTHER', 6, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'PV', 'OTHER', 7, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'V', 'OTHER', 8, 0);
Insert into  NM_NW_XSP_TEMP
   (NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS, NWX_DESCR, NWX_SEQ, NWX_OFFSET)
 Values
   ('HERM', 'Y', 'FC', 'OTHER', 9, 0);

COMMIT;

--
CREATE UNIQUE INDEX NWX_PK_TEMP ON NM_NW_XSP_TEMP
(NWX_NW_TYPE, NWX_X_SECT, NWX_NSC_SUB_CLASS);

DELETE FROM hig_codes WHERE HCO_DOMAIN = 'NETWORK_SUB_CLASSES';

BEGIN
EXECUTE IMMEDIATE
'INSERT INTO hig_codes (HCO_DOMAIN
                         ,HCO_CODE
                         ,HCO_MEANING
                         ,HCO_SYSTEM
                         ,HCO_SEQ
                         ,HCO_START_DATE)
   SELECT DISTINCT ''NETWORK_SUB_CLASSES'' HCO_DOMAIN
         ,NSC_SUB_CLASS HCO_CODE
         ,NSC_DESCR HCO_MEANING
         ,''N'' HCO_SYSTEM
         ,NSC_SEQ_NO HCO_SEQ
         ,''01-JAN-1900'' HCO_START_DATE
     FROM NM_TYPE_SUBCLASS_TEMP';
EXCEPTION
WHEN OTHERS THEN 
NULL;
END;
/
COMMIT;

  ALTER TRIGGER NM_ELEMENTS_ALL_B_UPD_NSGN DISABLE;
  ALTER TRIGGER B_UPD_NM_ELEMENTS DISABLE;
  