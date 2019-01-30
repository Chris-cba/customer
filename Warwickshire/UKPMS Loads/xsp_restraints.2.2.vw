CREATE OR REPLACE FORCE VIEW XSP_RESTRAINTS
(
   XSR_NW_TYPE,
   XSR_ITY_INV_CODE,
   XSR_SCL_CLASS,
   XSR_X_SECT_VALUE,
   XSR_DESCR,
   XSR_DATE_CREATED,
   XSR_DATE_MODIFIED,
   XSR_MODIFIED_BY,
   XSR_CREATED_BY
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/customer/Warwickshire/UKPMS Loads/xsp_restraints.2.2.vw-arc   1.0   Jan 30 2019 11:10:24   Sarah.Williams  $
--       Module Name      : $Workfile:   xsp_restraints.2.2.vw  $
--       Date into PVCS   : $Date:   Jan 30 2019 11:10:24  $
--       Date fetched Out : $Modtime:   Jan 30 2019 11:05:44  $
--       PVCS Version     : $Revision:   1.0  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   SELECT decode(XSR_NW_TYPE,'SECT','L') XSR_NW_TYPE,
          XSR_ITY_INV_CODE,
          XSR_SCL_CLASS,
          XSR_X_SECT_VALUE,
          XSR_DESCR,
          XSR_DATE_CREATED,
          XSR_DATE_MODIFIED,
          XSR_MODIFIED_BY,
          XSR_CREATED_BY
     FROM nm_xsp_restraints
   UNION ALL
   SELECT nng_nt_type,
          xsr_ity_inv_code,
          nsc_sub_class,
          xsr_x_sect_value,
          xsr_descr,
          xsr_date_created,
          xsr_date_modified,
          xsr_modified_by,
          xsr_created_by
     FROM nm_nt_groupings,
          nm_xsp_restraints,
          nm_group_types,
          nm_type_subclass
    WHERE     xsr_nw_type = ngt_nt_type
          AND ngt_group_type = nng_group_type
          AND nsc_nw_type = ngt_nt_type
          AND nsc_sub_class = xsr_scl_class
   UNION ALL
   SELECT nwx_nw_type,
          '$$',
          nwx_nsc_sub_class,
          nwx_x_sect,
          nwx_descr,
          NULL,
          NULL,
          NULL,
          NULL
     FROM nm_xsp;

