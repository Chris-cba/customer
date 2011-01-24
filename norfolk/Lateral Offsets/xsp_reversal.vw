CREATE OR REPLACE FORCE VIEW XSP_REVERSAL
(
   XRV_NW_TYPE,
   XRV_OLD_SUB_CLASS,
   XRV_OLD_XSP,
   XRV_NEW_SUB_CLASS,
   XRV_NEW_XSP,
   XRV_MANUAL_OVERRIDE,
   XRV_DEFAULT_XSP
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/norfolk/Lateral Offsets/xsp_reversal.vw-arc   3.0   Jan 24 2011 17:04:38   Ade.Edwards  $
--       Module Name      : $Workfile:   xsp_reversal.vw  $
--       Date into PVCS   : $Date:   Jan 24 2011 17:04:38  $
--       Date fetched Out : $Modtime:   Jan 24 2011 16:51:56  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
   SELECT XRV_NW_TYPE,
          XRV_OLD_SUB_CLASS,
          XRV_OLD_XSP,
          XRV_NEW_SUB_CLASS,
          XRV_NEW_XSP,
          XRV_MANUAL_OVERRIDE,
          XRV_DEFAULT_XSP
     FROM nm_xsp_reversal
   UNION ALL
   SELECT nng_nt_type,
          XRV_OLD_SUB_CLASS,
          XRV_OLD_XSP,
          XRV_NEW_SUB_CLASS,
          XRV_NEW_XSP,
          XRV_MANUAL_OVERRIDE,
          XRV_DEFAULT_XSP
     FROM nm_nt_groupings, nm_xsp_reversal, nm_group_types
    WHERE xrv_nw_type = ngt_nt_type 
      AND ngt_group_type = nng_group_type;