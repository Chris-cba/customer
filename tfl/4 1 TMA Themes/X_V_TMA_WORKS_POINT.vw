CREATE OR REPLACE FORCE VIEW X_V_TMA_WORKS_POINT 
(TWOR_WORKS_ID, TWOR_WORKS_REF, TWOR_ORG_REF, TWOR_DIST_REF, TWOR_NO_OF_PHASES, 
 TWOR_STR_NE_ID, TWOR_ACTUAL_WORKS_REF, TWOR_LICENCE_ID, TWOR_EXTERNAL_REF, ORG_NAME, 
 ORG_PREFIX, DIST_NAME, DIST_PREFIX, STR_USRN, STR_DESCR, 
 STR_LOCALITY, STR_TOWN, STR_COUNTY, STR_PROVISIONAL_STREET_FLAG, TPHS_ACTIVE_FLAG, 
 TPHS_PHASE_NO, TPHS_DESCRIPTION, TPHS_PHASE_STATUS, TPHS_WORKS_CATEGORY, TWCA_DESCRIPTION, 
 TPHS_PHASE_TYPE, PHASE_TYPE_MEANING, TPHS_PROPOSED_START_DATE, TPHS_EST_END_DATE, TPHS_LATEST_START_DATE, 
 TPHS_LATEST_END_DATE, TPHS_ACT_START_DATE, TPHS_ACT_END_DATE, TPHS_START_DATE, TPHS_END_DATE, 
 PHASE_STATUS_MEANING, TPHS_REINST_CAT, TPHS_PHASE_ID, TPHS_LOC_DESCRIPTION, TPHS_CHALLENGED, 
 GEOMETRY)
AS
SELECT
--
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 by Aileen Heal
--
--   IT WAS REDEFINIED AFTER THE 4.1 UPGRADE TO USE THE NEW TMA THEME 
--   TMA_PHASES_PT_TAB (FEATURE TABLE = TMA_PHASES_POINT_SDO)
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/tfl/4 1 TMA Themes/X_V_TMA_WORKS_POINT.vw-arc   3.0   Nov 09 2009 11:39:34   iturnbull  $
--       Module Name      : $Workfile:   X_V_TMA_WORKS_POINT.vw  $
--       Date into PVCS   : $Date:   Nov 09 2009 11:39:34  $
--       Date fetched Out : $Modtime:   Nov 09 2009 11:36:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
        a."TWOR_WORKS_ID",a."TWOR_WORKS_REF",a."TWOR_ORG_REF",a."TWOR_DIST_REF",
        a."TWOR_NO_OF_PHASES",a."TWOR_STR_NE_ID",a."TWOR_ACTUAL_WORKS_REF",a."TWOR_LICENCE_ID",
        a."TWOR_EXTERNAL_REF",a."ORG_NAME",a."ORG_PREFIX",a."DIST_NAME",a."DIST_PREFIX",
        a."STR_USRN",a."STR_DESCR",a."STR_LOCALITY",a."STR_TOWN",a."STR_COUNTY",
        a."STR_PROVISIONAL_STREET_FLAG",a."TPHS_ACTIVE_FLAG",a."TPHS_PHASE_NO",a."TPHS_DESCRIPTION",
        a."TPHS_PHASE_STATUS",a."TPHS_WORKS_CATEGORY",a."TWCA_DESCRIPTION",a."TPHS_PHASE_TYPE",
        a."PHASE_TYPE_MEANING",a."TPHS_PROPOSED_START_DATE",a."TPHS_EST_END_DATE",
        a."TPHS_LATEST_START_DATE",a."TPHS_LATEST_END_DATE",a."TPHS_ACT_START_DATE",
        a."TPHS_ACT_END_DATE",a."TPHS_START_DATE",a."TPHS_END_DATE",a."PHASE_STATUS_MEANING",
        a."TPHS_REINST_CAT",a."TPHS_PHASE_ID",a."TPHS_LOC_DESCRIPTION",a."TPHS_CHALLENGED", 
        b.TPPS_TPHS_GEOMETRY 
   FROM v_tma_works_active_phase_dets a, TMA_PHASES_POINT_SDO b
 WHERE a.tphs_phase_id = b.TPPS_TPHS_ID
 and tphs_phase_status in ('ADV_PLAN', 'ACCEPTED', 'AWAIT_RESPONSE', 'UNASSIGNED', 
                           'CREATED', 'FWD_PLAN', 'WIP', 'ABOUT_TO_START');

update nm_themes_all 
   set NTH_BASE_TABLE_THEME = (select nth_theme_id from nm_themes_all where nth_feature_table = 'TMA_PHASES_POINT_SDO')
 where nth_feature_table = 'X_V_TMA_WORKS_POINT';
/