-- dummy view for CSV loader
DROP VIEW V_HA_UPD_INSP
/

CREATE OR REPLACE FORCE VIEW V_HA_UPD_INSP
(
   INSP_PRIMARY_KEY,
   INSP_DATE_INSPECTED,
   INSP_DEF_FOUND_YN,
   INSP_INSPECTED_YN,
   INSP_REASON_NOT_INSP,
   INSP_CONDITION,
   INSP_COND_COMMENT,
   PARENT_ID
)
AS
   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/views/v_ha_upd_insp.vw-arc   1.0   Jun 06 2012 16:20:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   v_ha_upd_insp.vw  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:20:14  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:34:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2012
-----------------------------------------------------------------------------
--   
   iit_ne_id,
          iit_date_attrib87,
          iit_chr_attrib27,
          iit_chr_attrib28,
          iit_chr_attrib66,
          iit_chr_attrib30,
          iit_chr_attrib67,
          iit_foreign_key
     FROM nm_inv_items_all
    WHERE 1 = 2
/	