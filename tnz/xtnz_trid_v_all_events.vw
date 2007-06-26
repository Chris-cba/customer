CREATE OR REPLACE VIEW v_all_events AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_v_all_events.vw	1.1 03/15/05
--       Module Name      : xtnz_trid_v_all_events.vw
--       Date into SCCS   : 05/03/15 03:46:22
--       Date fetched Out : 07/06/06 14:40:41
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
       iit_ne_id iit_ne_id
      ,iit_inv_type iit_inv_type
      ,iit_primary_key Event_ID
      ,iit_descr Descr
      ,iit_start_date Date_Recorded
      ,iit_date_created iit_date_created
      ,iit_date_modified iit_date_modified
      ,iit_created_by iit_created_by
      ,iit_modified_by iit_modified_by
      ,iit_admin_unit iit_admin_unit
      ,SUBSTR(nm3ausec.get_nau_unit_code(iit_admin_unit),1,10) nau_unit_code
      ,iit_end_date Event_closed_Date
      ,SUBSTR(xtnz_trid.get_trid_route_for_item (iit_ne_id),1,240) route
      ,SUBSTR(iit_chr_attrib31,1,30) INFORMATION_STATUS
      ,SUBSTR(iit_chr_attrib34,1,40) EVENT_TYPE
      ,iit_date_attrib87 EXPECTED_RESOLUTION_DATE
      ,iit_date_attrib88 DATE_NEXT_UPDATE_DUE
      ,SUBSTR(iit_chr_attrib26,1,40) INFORMATION_SOURCE
      ,SUBSTR(iit_chr_attrib55,1,3) NMC_NOTIFIED
      ,xtnz_trid.get_nmc_for_item (iit_ne_id) nmc
      ,SUBSTR(iit_chr_attrib27,1,20) IMPACT
      ,SUBSTR(iit_chr_attrib28,1,40) PUBLIC_CONTACT
      ,SUBSTR(iit_chr_attrib67,1,256) ALTERNATIVE_ROUTE
      ,SUBSTR(iit_chr_attrib68,1,256) COMMENTS
      ,SUBSTR(iit_chr_attrib36,1,3) PLANNED_EVENT
      ,iit_date_attrib86 EVENT_START_DATE
 FROM  nm_inv_items inv
WHERE  iit_inv_type IN ('AW','PW','RH','RW')
/
