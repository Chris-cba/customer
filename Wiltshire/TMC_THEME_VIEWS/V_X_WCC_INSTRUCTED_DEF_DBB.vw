CREATE OR REPLACE FORCE VIEW V_X_WCC_INSTRUCTED_DEF_DBB AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Wiltshire/TMC_THEME_VIEWS/V_X_WCC_INSTRUCTED_DEF_DBB.vw-arc   1.0   May 07 2013 12:27:04   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_WCC_INSTRUCTED_DEF_DBB.vw  $
--       Date into PVCS   : $Date:   May 07 2013 12:27:04  $
--       Date fetched Out : $Modtime:   May 07 2013 12:17:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems Ltd, 2013
-----------------------------------------------------------------------------
--
D.*, O.OUN_NAME DEF_CONTRACTOR, WOL.WOL_STATUS_CODE, G.GEOLOC
FROM
V_MAI_DEFECTS D, MAI_DEFECTS_XY_SDO G, WORK_ORDERS WO, WORK_ORDER_LINES WOL, contracts c, ORG_UNITS O 
WHERE
D.DEFECT_ID = G.DEF_DEFECT_ID
AND D.DEFECT_ID = WOL.WOL_DEF_DEFECT_ID
AND WO.WOR_WORKS_ORDER_NO = WOL.WOL_WORKS_ORDER_NO
AND WO.WOR_CON_ID = C.CON_ID
AND C.CON_CONTR_ORG_ID = O.OUN_ORG_ID
AND O.OUN_CONTRACTOR_ID = 'DBB'
AND D.DEFECT_STATUS_CODE IN ('INSTRUCTED', 'SELECTED')
and d.defect_activity != 'CR'
/

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) 
SELECT 'V_X_WCC_INSTRUCTED_DEF_DBB','GEOLOC',DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'MAI_DEFECTS_XY_SDO'
AND NOT EXISTS (SELECT 'X' FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'V_X_WCC_INSTRUCTED_DEF_DBB')
/

