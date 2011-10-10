CREATE OR REPLACE FORCE VIEW X_V_BRS6404 AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/BRS6404_XML_TMA_extract/X_V_BRS6404.vw-arc   1.0   Oct 10 2011 13:30:20   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_V_BRS6404.vw  $
--       Date into PVCS   : $Date:   Oct 10 2011 13:30:20  $
--       Date fetched Out : $Modtime:   Oct 04 2011 13:44:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- view written for NHSWM to create view to extract the data for TMA extract
-- important to note this only include WIP, ABOUT_TO_START and FWD_PLAN
-- also exclude works that should have closed more than a month ago (i.e. close notice missing)
         TWOR_DATE_MODIFIED LastModified 
       , TPHS_DESCRIPTION Description
       , TWOR_ORG_REF OrgRef
       , TWOR_DIST_REF  OrgDistRef
       , Dist_Name OrgDistName
       , TPHS_PROMOTER_NAME PromoterName
       , TPHS_PROMOTER_TELNO PromoterTelNo
       , TWOR_WORKS_REF OrgEventReference
       , TPHS_LOC_DESCRIPTION LocationDescription
       , X_BRS_6404_START_DATIM(tphs_act_start_date, tphs_proposed_start_date)  START_DATIM
       , X_BRS_6404_END_DATIM(tphs_act_end_date  , tphs_est_end_date ) END_DATIM
       , tphs_cway_restrict_type TrafficManagementCode
       , hig_codes.hco_meaning CarriagewayRestriction
       , decode(TPHS_FWAY_CLOSURE, 1,  'True', 'False' )   FootwayClosure
       , decode(TPHS_PARKING_SUSPENSIONS, 1,  ' True', 'False' )  ParkingSuspensions
       , replace(to_char(SDO_UTIL.TO_GMLGEOMETRY(g.TPHS_GEOMETRY)), 'SDO:81989', 'EPSG:27700') GeometryAsGML
       , V_TMA_STREETS.STR_USRN USRN
       , decode(TPHS_WORKING_HOURS, 1, 'True', 'False') OutOfHours
       , TPHS_PHASE_NO PhaseNumber
       , tphs_phase_status WorksStatus
       , V_TMA_STREETS.STR_DESCR StreetName
       , V_TMA_STREETS.STR_TOWN Town
       , TPHS_WORKS_CATEGORY WorksCategory
from
     TMA_WORKS w
   , TMA_PHASES p
   , TMA_PHASES_SDO g
   , V_TMA_STREETS
   , hig_codes hig_codes
   , Nsg_Districts
where twor_works_id = tphs_works_id 
AND p.tphs_id = g.TPHS_ID
AND twor_str_ne_id = str_ne_id   
AND hig_codes.hco_domain = 'PHASE_CWAY_RESTRICT'
AND tphs_cway_restrict_type = hig_codes.hco_code
AND tphs_active_flag = 'Y'
AND p.TPHS_WORKS_RESTRICTED = '0'
AND tphs_phase_status IN ('ABOUT_TO_START', 'WIP', 'ADV_PLAN')
AND NVL(tphs_act_end_date, TPHS_EST_END_DATE) > TRUNC(SYSDATE) - 31
AND TWOR_DIST_REF = Dist_Ref
AND Nsg_Districts.DIST_ORG_REF = TWOR_ORG_REF
/