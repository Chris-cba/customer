CREATE OR REPLACE FORCE VIEW V_NM_NIT_UKPMS_VN_SDO AS
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcs             : $Header:   //vm_latest/archives/customer/HA/themes/V_NM_NIT_UKPMS_VN_SDO.vw-arc   1.0   May 31 2012 10:20:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_NM_NIT_UKPMS_VN_SDO.vw  $
--       Date into PVCS   : $Date:   May 31 2012 10:20:30  $
--       Date fetched Out : $Modtime:   May 29 2012 14:33:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
--  view created by Aileen Heal for data tracked theme for foreign table asset type VN
-----------------------------------------------------------------------------
   e.IIT_ADMIN_UNIT    ADMIN_UNIT
  ,e.IIT_CHR_ATTRIB26    DEFECT_TYPE
  ,e.IIT_CHR_ATTRIB27    DEFECT_CODE
  ,e.IIT_CHR_ATTRIB28    SUB_XSP
  ,e.IIT_CREATED_BY    CREATED_BY
  ,e.IIT_DATE_CREATED    DATE_CREATED
  ,e.IIT_DATE_MODIFIED    DATE_MODIFIED
  ,e.IIT_DET_XSP    DETAILED_XSP
  ,e.IIT_END_CHAIN    END_CHAIN
  ,e.IIT_END_DATE    END_DATE
  ,e.IIT_INV_TYPE    INV_TYPE
  ,e.IIT_ITY_SYS_FLAG    ITY_SYS_FLAG
  ,e.IIT_MODIFIED_BY    MODIFIED_BY
  ,e.IIT_NE_ID    NE_ID
  ,e.IIT_NOTE    DATA_ID
  ,e.IIT_NUM_ATTRIB16    START_WIDTH
  ,e.IIT_NUM_ATTRIB17    END_WIDTH
  ,e.IIT_PRIMARY_KEY    PRIMARY_KEY
  ,e.IIT_RSE_HE_ID    RSE_HE_ID
  ,e.IIT_START_DATE    START_DATE
  ,e.IIT_ST_CHAIN    ST_CHAIN
  ,e.IIT_X_SECT    X_SECT
    ,O.GEOMETRY, O.OBJECTID
     FROM  UKPMS_VN e, NM_NIT_UKPMS_VN_SDO o
    WHERE e.IIT_NE_ID = o.IIT_NE_ID 
    AND E.IIT_START_DATE <= (SELECT nm3context.get_effective_date FROM DUAL)
          AND NVL (e.IIT_END_DATE, TO_DATE ('99991231', 'YYYYMMDD')) >
                 (SELECT nm3context.get_effective_date FROM DUAL)  
/

insert into user_sdo_geom_metadata 
select 'V_NM_NIT_UKPMS_VN_SDO', COLUMN_NAME, DIMINFO, SRID
from user_sdo_geom_metadata where table_name = 'NM_NIT_UKPMS_VN_SDO'
and not exists (select 1 from user_sdo_geom_metadata where table_name = 'V_NM_NIT_UKPMS_VN_SDO')
/

commit
/            
                            