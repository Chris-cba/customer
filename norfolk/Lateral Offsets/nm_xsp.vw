CREATE OR REPLACE FORCE VIEW NM_XSP
(
   NWX_NW_TYPE,
   NWX_X_SECT,
   NWX_NSC_SUB_CLASS,
   NWX_DESCR,
   NWX_SEQ,
   NWX_OFFSET,
   NWX_DATE_CREATED,
   NWX_DATE_MODIFIED,
   NWX_MODIFIED_BY,
   NWX_CREATED_BY
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/nm_xsp.vw-arc   3.0   Jan 24 2011 17:04:40   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_xsp.vw  $
--       Date into PVCS   : $Date:   Jan 24 2011 17:04:40  $
--       Date fetched Out : $Modtime:   Jan 24 2011 16:52:58  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
   SELECT nwx_nw_type,
          nwx_x_sect,
          nwx_nsc_sub_class,
          NWX_DESCR,
          NWX_SEQ,
          NWX_OFFSET,
          NWX_DATE_CREATED,
          NWX_DATE_MODIFIED,
          NWX_MODIFIED_BY,
          NWX_CREATED_BY
     FROM nm_nw_xsp
   UNION
   SELECT nng_nt_type,
          nwx_x_sect,
          nwx_nsc_sub_class,
          NWX_DESCR,
          NWX_SEQ,
          NWX_OFFSET,
          NWX_DATE_CREATED,
          NWX_DATE_MODIFIED,
          NWX_MODIFIED_BY,
          NWX_CREATED_BY
     FROM nm_nw_xsp, nm_nt_groupings, nm_group_types
    WHERE ngt_group_type = nng_group_type AND ngt_nt_type = nwx_nw_type;