CREATE OR REPLACE FORCE VIEW V_X_NHCC_STREET_DOCTOR as
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS4326_street_doctor/V_X_NHCC_STREET_DOCTOR.vw-arc   1.0   Feb 28 2011 16:08:10   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_NHCC_STREET_DOCTOR.vw  $
--       Date into PVCS   : $Date:   Feb 28 2011 16:08:10  $
--       Date fetched Out : $Modtime:   Feb 15 2011 12:27:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--   
          a.DOC_ENQUIRY_ID,
          a.DOC_STATUS,
          a.DOC_SOURCE,
          a.DOC_CATEGORY,
          a.DOC_CLASS,
          a.DOC_TYPE,
          a.DOC_RECORDED_BY,
          a.DOC_RESPONSIBILITY_OF,
          a.DOC_PRIORITY,
          a.DOC_DATE_RECORDED,
          a.DOC_TARGET_DATE,
          a.DOC_EASTING,
          a.DOC_NORTHING,
          b.GEOLOC,
          b.objectid,
          X_NHCC_STREET_DOCTOR_SYMBOL(a.DOC_STATUS, a.DOC_CATEGORY) symbol
     FROM V_ENQ_ENQUIRIES a, ENQ_ENQUIRIES_XY_SDO b
    WHERE a.DOC_ENQUIRY_ID = b.DOC_ID;

delete from user_sdo_geom_metadata where table_name = 'V_X_NHCC_STREET_DOCTOR';

insert into user_sdo_geom_metadata
select 'V_X_NHCC_STREET_DOCTOR', column_name, diminfo, srid
from user_sdo_geom_metadata 
where table_name = 'ENQ_ENQUIRIES_XY_SDO';

commit;
/