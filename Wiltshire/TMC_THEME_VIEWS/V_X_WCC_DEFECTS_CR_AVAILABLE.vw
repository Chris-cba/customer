CREATE OR REPLACE FORCE VIEW V_X_WCC_DEFECTS_CR_AVAILABLE AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Wiltshire/TMC_THEME_VIEWS/V_X_WCC_DEFECTS_CR_AVAILABLE.vw-arc   1.0   May 07 2013 12:27:02   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_WCC_DEFECTS_CR_AVAILABLE.vw  $
--       Date into PVCS   : $Date:   May 07 2013 12:27:02  $
--       Date fetched Out : $Modtime:   May 07 2013 12:17:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems Ltd, 2013
-----------------------------------------------------------------------------
--
D.*, G.GEOLOC
FROM V_MAI_DEFECTS D, MAI_DEFECTS_XY_SDO G
WHERE
D.DEFECT_ID = G.DEF_DEFECT_ID
AND D.defect_activity ='CR'
AND D.DEFECT_STATUS_CODE = 'AVAILABLE'
/

INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) 
SELECT 'V_X_WCC_DEFECTS_CR_AVAILABLE','GEOLOC',DIMINFO, SRID
FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'MAI_DEFECTS_XY_SDO'
AND NOT EXISTS (SELECT 'X' FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'V_X_WCC_DEFECTS_CR_AVAILABLE')
/
