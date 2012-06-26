CREATE OR REPLACE FORCE VIEW V_X_HA_INC_HISTORIC_SDO
(
   DOC_ENQUIRY_ID,
   DOC_STATUS,
   DOC_SOURCE,
   DOC_CATEGORY,
   DOC_CLASS,
   DOC_TYPE,
   DOC_RECORDED_BY,
   DOC_RESPONSIBILITY_OF,
   DOC_PRIORITY,
   DOC_DATE_RECORDED,
   DOC_TARGET_DATE,
   DOC_EASTING,
   DOC_NORTHING,
   DOC_COMPLETED_DATE,
   OBJECTID,
   GEOLOC
)
AS
   SELECT /*+ FIRST_ROWS */
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/HA/themes/V_X_HA_INC_HISTORIC_SDO.vw-arc   1.0   Jun 26 2012 11:46:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   V_X_HA_INC_HISTORIC_SDO.vw  $
--       Date into PVCS   : $Date:   Jun 26 2012 11:46:26  $
--       Date fetched Out : $Modtime:   Jun 21 2012 22:59:58  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Systems (UK) Ltd, 2012
-----------------------------------------------------------------------------
-- view written by Aileen Heal to add the enq completed data so we can only 
-- include incidents closed in last 6 months ago.
--
          doc.doc_id doc_enquiry_id,
          doc.doc_status_code doc_status,
          doc.doc_compl_source doc_source,
          doc.doc_dtp_code doc_category,
          doc.doc_dcl_code doc_class,
          doc.doc_compl_type doc_type,
          doc.doc_user_id doc_recorded_by,
          doc.doc_compl_user_id doc_responsibility_of,
          doc.doc_compl_cpr_id doc_priority,
          TRUNC (doc.doc_date_issued) doc_date_recorded,
          TRUNC (doc.doc_compl_target) doc_target_date,
          doc_compl_east doc_easting,
          doc_compl_north doc_northing,
          TRUNC(DOC_COMPL_COMPLETE) DOC_COMPLETED_DATE,
		  g.OBJECTID,
		  g.GEOLOC
     FROM docs doc, ENQ_ENQUIRIES_XY_SDO g
    WHERE doc.doc_dcl_code IS NOT NULL
      AND doc.doc_status_code = 'CO'
      AND doc.DOC_COMPL_COMPLETE > ADD_MONTHS(TRUNC(SYSDATE),-6)
	  AND doc.doc_Id = g.doc_id
	  AND doc.DOC_DTP_CODE IN ('INCI','INDN')
/

insert into user_sdo_geom_metadata (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID )
select 'V_X_HA_INC_HISTORIC_SDO', COLUMN_NAME, DIMINFO, SRID 
from user_sdo_geom_metadata
where table_name = 'ENQ_ENQUIRIES_XY_SDO'
/

commit
/ 

