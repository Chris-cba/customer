   -------------------------------------------------------------------------
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/customer/HA/STR Users/buc_area_scope_map.sql-arc   1.0   Aug 30 2019 18:19:16   Sarah.Williams  $
   --       Module Name      : $Workfile:   buc_area_scope_map.sql  $
   --       Date into PVCS   : $Date:   Aug 30 2019 18:19:16  $
   --       Date fetched Out : $Modtime:   Aug 30 2019 10:03:02  $
   --       PVCS Version     : $Revision:   1.0  $
   ------------------------------------------------------------------
   --   Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
   ------------------------------------------------------------------
CREATE TABLE BUC_AREA_SCOPE_MAP
(
  BAS_SCOPE  VARCHAR2(50 BYTE),
  BAS_AU     VARCHAR2(50 BYTE),
  BAS_UAU    VARCHAR2(4 BYTE)
);

Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 07', 'A07', '7');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A1 Darlington to Dishforth', 'A33', '33');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 21', 'A21', '21');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - M4 M49 Severn Crossings', 'A36', '36');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A1M', 'A29', '29');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A30 A35', 'A32', '32');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 04', 'A04', '4');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 09', 'A09', '9');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 12', 'A12', '12');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A417 A419', 'A31', '31');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A50', 'A28', '28');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 23', 'A23', '23');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 10', 'A10', '10');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 13', 'A13', '13');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A19', 'A26', '26');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A249', 'A34', '34');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 17', 'A17', '17');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 03', 'A03', '3');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 06', 'A06', '6');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 24', 'A24', '24');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - M25', 'A05', '5');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 22', 'A22', '22');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - A69', 'A25', '25');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - M40', 'A30', '30');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 08', 'A08', '8');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area 14', 'A14', '14');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Area South West', 'SWR', 'SWR');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - M1 A1', 'A27', '27');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('DBFO - M6 Toll', 'A35', '35');
Insert into BUC_AREA_SCOPE_MAP
   (BAS_SCOPE, BAS_AU, BAS_UAU)
 Values
   ('Global', 'ALL', 'ALL');
COMMIT;

