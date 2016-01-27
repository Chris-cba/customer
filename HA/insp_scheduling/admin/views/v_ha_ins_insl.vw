CREATE OR REPLACE FORCE VIEW V_HA_INS_INSL
(
  INSL_PRIMARY_KEY,
  INSL_START_CHAINAGE,
  INSL_END_CHAINAGE,
  INSL_DATE_INSPECTED,
  INSL_DEF_FOUND,
  INSL_INSP_COMPLETE,
  INSL_CONDITION,
  INSL_CONDITION_COMMENT,
  INSL_START_EASTING,
  INSL_START_NORTHING,
  INSL_END_EASTING,
  INSL_END_NORTHING,
  INSL_SURVEY_DATE,
  INSL_SURVEY_TIME,
  INSL_INSP_INSPECTION_ID)
AS
  SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/admin/views/v_ha_ins_insl.vw-arc   1.0   Jan 27 2016 12:11:34   Chris.Baugh  $
--       Module Name      : $Workfile:   v_ha_ins_insl.vw  $
--       Date into PVCS   : $Date:   Jan 27 2016 12:11:34  $
--       Date fetched Out : $Modtime:   Jan 27 2016 11:34:08  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2016
-----------------------------------------------------------------------------
--   
        iit_ne_id,
        iit_num_attrib100,
        iit_num_attrib101,
        iit_date_attrib86,
        iit_chr_attrib28,
        iit_chr_attrib29,
        iit_chr_attrib30,
        iit_chr_attrib67,
        iit_x,
        iit_y,
        iit_x_coord,
        iit_y_coord,
        iit_date_attrib87,
        iit_chr_attrib31,
        iit_foreign_key        
   FROM nm_inv_items_all
  WHERE 1 = 2
/	