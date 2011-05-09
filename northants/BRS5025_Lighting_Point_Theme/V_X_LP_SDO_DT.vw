CREATE OR REPLACE  VIEW V_X_LP_SDO_DT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/BRS5025_Lighting_Point_Theme/V_X_LP_SDO_DT.vw-arc   1.0   May 09 2011 17:52:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_LP_SDO_DT.vw  $
--       Date into PVCS   : $Date:   May 09 2011 17:52:24  $
--       Date fetched Out : $Modtime:   May 09 2011 13:19:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- Created by Aileen Heal as part of BRS 5025 in May 2011
--
(
   IIT_NE_ID,
   IIT_INV_TYPE,
   IIT_PRIMARY_KEY,
   IIT_START_DATE,
   IIT_DATE_CREATED,
   IIT_DATE_MODIFIED,
   IIT_CREATED_BY,
   IIT_MODIFIED_BY,
   IIT_ADMIN_UNIT,
   IIT_DESCR,
   IIT_NOTE,
   IIT_PEO_INVENT_BY_ID,
   NAU_UNIT_CODE,
   IIT_X_SECT,
   IIT_END_DATE,
   LP_COL_MAT,
   SWITCH_TYPE,
   ON_OFF,
   IIT_EASTING,
   IIT_NORTHING,
   STREET_NAME,
   LP_ID,
   LP_LIGHT_POINT_ID,
   LOCATION,
   TOWN,
   LP_TYPE,
   LANTERN_COUNT,
   LAMP_COUNT,
   LP_LAMP_CHANGE,
   LP_COLUMN_NAME,
   LP_OWNER,
   LP_LOCALITY,
   LP_NEXT_CHANGE,
   LP_HEIGHT,
   LP_LAMP,
   LP_LAMP_WATTS,
   LP_LIN_POINT_NO,
   LP_PARISH_NAME,
   LP_LATEST_CHANGE,
   LP_ONOFF_DATES,
   SURVEY_METHOD,
   VIDEO_FILE_NAME,
   LP_SYMBOL,
   OBJECTID,
   GEOLOC
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/BRS5025_Lighting_Point_Theme/V_X_LP_SDO_DT.vw-arc   1.0   May 09 2011 17:52:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_LP_SDO_DT.vw  $
--       Date into PVCS   : $Date:   May 09 2011 17:52:24  $
--       Date fetched Out : $Modtime:   May 09 2011 13:19:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
-- Created by Aileen Heal as part of BRS 5025 in May 2011
--
          i.IIT_NE_ID,
          i.IIT_INV_TYPE,
          i.IIT_PRIMARY_KEY,
          i.IIT_START_DATE,
          i.IIT_DATE_CREATED,
          i.IIT_DATE_MODIFIED,
          i.IIT_CREATED_BY,
          i.IIT_MODIFIED_BY,
          i.IIT_ADMIN_UNIT,
          i.IIT_DESCR,
          i.IIT_NOTE,
          i.IIT_PEO_INVENT_BY_ID,
          i.NAU_UNIT_CODE,
          i.IIT_X_SECT,
          i.IIT_END_DATE,
          i.LP_COL_MAT,
          i.SWITCH_TYPE,
          i.ON_OFF,
          i.IIT_EASTING,
          i.IIT_NORTHING,
          i.STREET_NAME,
          i.LP_ID,
          i.LP_LIGHT_POINT_ID,
          i.LOCATION,
          i.TOWN,
          i.LP_TYPE,
          i.LANTERN_COUNT,
          i.LAMP_COUNT,
          i.LP_LAMP_CHANGE,
          i.LP_COLUMN_NAME,
          i.LP_OWNER,
          i.LP_LOCALITY,
          i.LP_NEXT_CHANGE,
          i.LP_HEIGHT,
          i.LP_LAMP,
          i.LP_LAMP_WATTS,
          i.LP_LIN_POINT_NO,
          i.LP_PARISH_NAME,
          i.LP_LATEST_CHANGE,
          i.LP_ONOFF_DATES,
          i.SURVEY_METHOD,
          i.VIDEO_FILE_NAME,
          i.LP_OWNER || '_' || ON_OFF LP_SYMBOL,
          s.objectid,
          s.geoloc
     FROM V_NM_LP i, NM_ONA_LP_SDO s
    WHERE i.iit_ne_id = s.ne_id
          AND s.START_DATE <=
                (SELECT nm3context.get_effective_date FROM DUAL)
          AND NVL (s.END_DATE, TO_DATE ('99991231', 'YYYYMMDD')) >
                 (SELECT nm3context.get_effective_date FROM DUAL);

delete  from user_sdo_geom_metadata where table_name = 'V_X_LP_SDO_DT';

insert into user_sdo_geom_metadata
select 'V_X_LP_SDO_DT', column_name, diminfo, srid
from user_sdo_geom_metadata
where table_name = 'V_NM_ONA_LP_SDO_DT';

commit;
