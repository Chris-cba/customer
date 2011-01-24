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
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/xsp_restraints.vw-arc   3.0   Jan 24 2011 17:04:40   Ade.Edwards  $
--       Module Name      : $Workfile:   xsp_restraints.vw  $
--       Date into PVCS   : $Date:   Jan 24 2011 17:04:40  $
--       Date fetched Out : $Modtime:   Jan 24 2011 16:52:26  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
   SELECT XSR_NW_TYPE,
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