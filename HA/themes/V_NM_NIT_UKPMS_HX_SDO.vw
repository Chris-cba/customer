CREATE OR REPLACE FORCE VIEW V_NM_NIT_UKPMS_HX_SDO AS
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcs             : $Header:   //vm_latest/archives/customer/HA/themes/V_NM_NIT_UKPMS_HX_SDO.vw-arc   1.0   May 31 2012 10:20:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_NM_NIT_UKPMS_HX_SDO.vw  $
--       Date into PVCS   : $Date:   May 31 2012 10:20:28  $
--       Date fetched Out : $Modtime:   May 29 2012 14:33:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
--  view created by Aileen Heal for data tracked theme for foreign table asset type HX
-----------------------------------------------------------------------------
   e.IIT_ADMIN_UNIT    ADMIN_UNIT
  ,e.IIT_CHR_ATTRIB26    DEFECT_TYPE
  ,e.IIT_CHR_ATTRIB27    SLOPE_DOPLR1_RELIABLE
  ,e.IIT_CHR_ATTRIB28    SLOPE_DOPLR2_RELIABLE
  ,e.IIT_CHR_ATTRIB29    SLOPE_DOPLR3_RELIABLE
  ,e.IIT_CHR_ATTRIB30    SLOPE_DOPLR4_RELIABLE
  ,e.IIT_CHR_ATTRIB31    SLOPE_DOPLR5_RELIABLE
  ,e.IIT_CHR_ATTRIB32    SLOPE_DOPLR6_RELIABLE
  ,e.IIT_CHR_ATTRIB33    SLOPE_DOPLR7_RELIABLE
  ,e.IIT_CHR_ATTRIB34    SLOPE_DOPLR8_RELIABLE
  ,e.IIT_CHR_ATTRIB35    SLOPE_DOPLR9_RELIABLE
  ,e.IIT_CHR_ATTRIB36    SLOPE_DOPLR10_RELIABLE
  ,e.IIT_CHR_ATTRIB37    SLOPE_DOPLR11_RELIABLE
  ,e.IIT_CHR_ATTRIB38    SLOPE_DOPLR12_RELIABLE
  ,e.IIT_CHR_ATTRIB39    SLOPE_DOPLR13_RELIABLE
  ,e.IIT_CHR_ATTRIB40    SLOPE_DOPLR14_RELIABLE
  ,e.IIT_CHR_ATTRIB41    SLOPE_DOPLR15_RELIABLE
  ,e.IIT_CHR_ATTRIB42    SLOPE_DOPLR16_RELIABLE
  ,e.IIT_CHR_ATTRIB43    SLOPE_DOPLR17_RELIABLE
  ,e.IIT_CHR_ATTRIB44    SLOPE_DOPLR18_RELIABLE
  ,e.IIT_CHR_ATTRIB45    SLOPE_DOPLR19_RELIABLE
  ,e.IIT_CHR_ATTRIB46    SLOPE_DOPLR20_RELIABLE
  ,e.IIT_CHR_ATTRIB47    SLOPE_DOPLR21_RELIABLE
  ,e.IIT_CHR_ATTRIB48    SLOPE_DOPLR22_RELIABLE
  ,e.IIT_CHR_ATTRIB49    SLOPE_DOPLR23_RELIABLE
  ,e.IIT_CHR_ATTRIB50    SLOPE_DOPLR24_RELIABLE
  ,e.IIT_CHR_ATTRIB51    SLOPE_DOPLR25_RELIABLE
  ,e.IIT_CHR_ATTRIB52    ROAD_SURF_TEMP_RELIABLE
  ,e.IIT_CHR_ATTRIB53    AIR_TEMP_RELIABLE
  ,e.IIT_CHR_ATTRIB54    SPARE_TEMP_RELIABLE
  ,e.IIT_CHR_ATTRIB55    VEHICLE_SPEED_RELIABLE
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
  ,e.IIT_NUM_ATTRIB100    SLOPE_DOPLR20
  ,e.IIT_NUM_ATTRIB101    SLOPE_DOPLR21
  ,e.IIT_NUM_ATTRIB102    SLOPE_DOPLR22
  ,e.IIT_NUM_ATTRIB103    SLOPE_DOPLR23
  ,e.IIT_NUM_ATTRIB104    SLOPE_DOPLR24
  ,e.IIT_NUM_ATTRIB105    SLOPE_DOPLR25
  ,e.IIT_NUM_ATTRIB106    ST_PROC_DATA_FRM_ST_SURV
  ,e.IIT_NUM_ATTRIB107    ROAD_SURF_TEMP
  ,e.IIT_NUM_ATTRIB108    AIR_TEMP
  ,e.IIT_NUM_ATTRIB109    SPARE_TEMP_SLOT
  ,e.IIT_NUM_ATTRIB110    VEHICLE_SPEED
  ,e.IIT_NUM_ATTRIB111    TIME_OF_DAY
  ,e.IIT_NUM_ATTRIB16    ST_GEO_ST_SURV
  ,e.IIT_NUM_ATTRIB17    GRAD_HORIZ
  ,e.IIT_NUM_ATTRIB18    CROSSFALL_HORIZ
  ,e.IIT_NUM_ATTRIB19    RADIUS_CURVE
  ,e.IIT_NUM_ATTRIB20    ST_SLOPE_FRM_ST_SURV
  ,e.IIT_NUM_ATTRIB21    SLOPE_DOPLR1
  ,e.IIT_NUM_ATTRIB22    SLOPE_DOPLR2
  ,e.IIT_NUM_ATTRIB23    SLOPE_DOPLR3
  ,e.IIT_NUM_ATTRIB24    SLOPE_DOPLR4
  ,e.IIT_NUM_ATTRIB25    SLOPE_DOPLR5
  ,e.IIT_NUM_ATTRIB76    SLOPE_DOPLR6
  ,e.IIT_NUM_ATTRIB77    SLOPE_DOPLR7
  ,e.IIT_NUM_ATTRIB78    SLOPE_DOPLR8
  ,e.IIT_NUM_ATTRIB79    SLOPE_DOPLR9
  ,e.IIT_NUM_ATTRIB80    SLOPE_DOPLR10
  ,e.IIT_NUM_ATTRIB81    SLOPE_DOPLR11
  ,e.IIT_NUM_ATTRIB82    SLOPE_DOPLR12
  ,e.IIT_NUM_ATTRIB83    SLOPE_DOPLR13
  ,e.IIT_NUM_ATTRIB84    SLOPE_DOPLR14
  ,e.IIT_NUM_ATTRIB85    SLOPE_DOPLR15
  ,e.IIT_NUM_ATTRIB96    SLOPE_DOPLR16
  ,e.IIT_NUM_ATTRIB97    SLOPE_DOPLR17
  ,e.IIT_NUM_ATTRIB98    SLOPE_DOPLR18
  ,e.IIT_NUM_ATTRIB99    SLOPE_DOPLR19
  ,e.IIT_OFFSET    ST_COORD_FRM_ST_SURV
  ,e.IIT_PRIMARY_KEY    PRIMARY_KEY
  ,e.IIT_RSE_HE_ID    RSE_HE_ID
  ,e.IIT_START_DATE    START_DATE
  ,e.IIT_ST_CHAIN    ST_CHAIN
  ,e.IIT_X    X_COORD
  ,e.IIT_X_SECT    X_SECT
  ,e.IIT_Y    Y_COORD
  ,e.IIT_Z    Z_COORD
  ,O.GEOMETRY, O.OBJECTID
       FROM  UKPMS_HX e, NM_NIT_UKPMS_HX_SDO o
    WHERE e.IIT_NE_ID = O.IIT_NE_ID    
    AND E.IIT_START_DATE <= (SELECT nm3context.get_effective_date FROM DUAL)
          AND NVL (e.IIT_END_DATE, TO_DATE ('99991231', 'YYYYMMDD')) >
                 (SELECT nm3context.get_effective_date FROM DUAL)
/

insert into user_sdo_geom_metadata 
select 'V_NM_NIT_UKPMS_HX_SDO', COLUMN_NAME, DIMINFO, SRID
from user_sdo_geom_metadata where table_name = 'NM_NIT_UKPMS_HX_SDO'
and not exists (select 1 from user_sdo_geom_metadata where table_name = 'V_NM_NIT_UKPMS_HX_SDO')
/

commit
/                   