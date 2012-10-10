CREATE OR REPLACE  VIEW x_wilt_brid_ge_insp AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid            : $Header:   //vm_latest/archives/customer/Wiltshire/disco_bridge_insp/x_wilt_brid_ge_insp.vw-arc   1.0   Oct 10 2012 09:16:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_wilt_brid_ge_insp.vw  $
--       Date into PVCS   : $Date:   Oct 10 2012 09:16:22  $
--       Date fetched Out : $Modtime:   Oct 10 2012 08:24:14  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley System 2012
----------------------------------------------------------------------------- 
--
-- view written for Wiltshire by Aileen Heal(exor Consultant) in October 2012
-- to be use to create a Bridge Inspections Report
--
-----------------------------------------------------------------------------
       str_id structure_id
     , SIP_ID INSPECTION_ID
     , SIP_DATE_INSPECTED date_inspected
     , sip_date_scheduled date_schedulted
     , str_name structure_name
     , str_local_ref local_ref
     , sip_remarks inspection_comment
     , x_wilt_str_insp_get_severity('PDEL',sip_id) PDEL_SEV
     , x_wilt_str_insp_get_extent('PDEL',sip_id) PDEL_EXT
     , x_wilt_str_insp_get_condition('PDEL',sip_id) PDEL_DEF
     , x_wilt_str_insp_get_comment('PDEL',sip_id) PDEL_COMMENTS
     , x_wilt_str_insp_get_severity('SDTB',sip_id) SDTB_SEV
     , x_wilt_str_insp_get_extent('SDTB',sip_id) SDTB_EXT
     , x_wilt_str_insp_get_condition('SDTB',sip_id) SDTB_DEF
     , x_wilt_str_insp_get_comment('SDTB',sip_id) SDTB_COMMENTS 
     , x_wilt_str_insp_get_severity('SDT3',sip_id) SDT3_SEV
     , x_wilt_str_insp_get_extent('SDT3',sip_id) SDT3_EXT
     , x_wilt_str_insp_get_condition('SDT3',sip_id) SDT3_DEF
     , x_wilt_str_insp_get_comment('SDT3',sip_id) SDT3_COMMENTS   
     , x_wilt_str_insp_get_severity('HJNT',sip_id) HJNT_SEV
     , x_wilt_str_insp_get_extent('HJNT',sip_id) HJNT_EXT
     , x_wilt_str_insp_get_condition('HJNT',sip_id) HJNT_DEF
     , x_wilt_str_insp_get_comment('HJNT',sip_id) HJNT_COMMENTS   
     , x_wilt_str_insp_get_severity('TIBR',sip_id) TIBR_SEV
     , x_wilt_str_insp_get_extent('TIBR',sip_id) TIBR_EXT
     , x_wilt_str_insp_get_condition('TIBR',sip_id) TIBR_DEF
     , x_wilt_str_insp_get_comment('TIBR',sip_id) TIBR_COMMENTS
     , x_wilt_str_insp_get_severity('PBCA',sip_id) PBCA_SEV
     , x_wilt_str_insp_get_extent('PBCA',sip_id) PBCA_EXT
     , x_wilt_str_insp_get_condition('PBCA',sip_id) PBCA_DEF
     , x_wilt_str_insp_get_comment('PBCA',sip_id) PBCA_COMMENTS
     , x_wilt_str_insp_get_severity('DKBR',sip_id) DKBR_SEV
     , x_wilt_str_insp_get_extent('DKBR',sip_id) DKBR_EXT
     , x_wilt_str_insp_get_condition('DKBR',sip_id) DKBR_DEF
     , x_wilt_str_insp_get_comment('DKBR',sip_id) DKBR_COMMENTS
     , x_wilt_str_insp_get_severity('FOUN',sip_id) FOUN_SEV
     , x_wilt_str_insp_get_extent('FOUN',sip_id) FOUN_EXT
     , x_wilt_str_insp_get_condition('FOUN',sip_id) FOUN_DEF
     , x_wilt_str_insp_get_comment('FOUN',sip_id) FOUN_COMMENTS
     , x_wilt_str_insp_get_severity('ABUT',sip_id) ABUT_SEV
     , x_wilt_str_insp_get_extent('ABUT',sip_id) ABUT_EXT
     , x_wilt_str_insp_get_condition('ABUT',sip_id) ABUT_DEF
     , x_wilt_str_insp_get_comment('ABUT',sip_id) ABUT_COMMENTS
     , x_wilt_str_insp_get_severity('SPDL',sip_id) SPDL_SEV
     , x_wilt_str_insp_get_extent('SPDL',sip_id) SPDL_EXT
     , x_wilt_str_insp_get_condition('SPDL',sip_id) SPDL_DEF
     , x_wilt_str_insp_get_comment('SPDL',sip_id) SPDL_COMMENTS
     , x_wilt_str_insp_get_severity('PIER',sip_id) PIER_SEV
     , x_wilt_str_insp_get_extent('PIER',sip_id) PIER_EXT
     , x_wilt_str_insp_get_condition('PIER',sip_id) PIER_DEF
     , x_wilt_str_insp_get_comment('PIER',sip_id) PIER_COMMENTS
     , x_wilt_str_insp_get_severity('XHCB',sip_id) XHCB_SEV
     , x_wilt_str_insp_get_extent('XHCB',sip_id) XHCB_EXT
     , x_wilt_str_insp_get_condition('XHCB',sip_id) XHCB_DEF
     , x_wilt_str_insp_get_comment('XHCB',sip_id) XHCB_COMMENTS
     , x_wilt_str_insp_get_severity('BRNG',sip_id) BRNG_SEV
     , x_wilt_str_insp_get_extent('BRNG',sip_id) BRNG_EXT
     , x_wilt_str_insp_get_condition('BRNG',sip_id) BRNG_DEF
     , x_wilt_str_insp_get_comment('BRNG',sip_id) BRNG_COMMENTS
     , x_wilt_str_insp_get_severity('BRPL',sip_id) BRPL_SEV
     , x_wilt_str_insp_get_extent('BRPL',sip_id) BRPL_EXT
     , x_wilt_str_insp_get_condition('BRPL',sip_id) BRPL_DEF
     , x_wilt_str_insp_get_comment('BRPL',sip_id) BRPL_COMMENTS    
     , x_wilt_str_insp_get_severity('SUPD',sip_id) SUPD_SEV
     , x_wilt_str_insp_get_extent('SUPD',sip_id) SUPD_EXT
     , x_wilt_str_insp_get_condition('SUPD',sip_id) SUPD_DEF
     , x_wilt_str_insp_get_comment('SUPD',sip_id) SUPD_COMMENTS 
     , x_wilt_str_insp_get_severity('SUBD',sip_id) SUBD_SEV
     , x_wilt_str_insp_get_extent('SUBD',sip_id) SUBD_EXT
     , x_wilt_str_insp_get_condition('SUBD',sip_id) SUBD_DEF
     , x_wilt_str_insp_get_comment('SUBD',sip_id) SUBD_COMMENTS  
     , x_wilt_str_insp_get_severity('WTPR',sip_id) WTPR_SEV
     , x_wilt_str_insp_get_extent('WTPR',sip_id) WTPR_EXT
     , x_wilt_str_insp_get_condition('WTPR',sip_id) WTPR_DEF
     , x_wilt_str_insp_get_comment('WTPR',sip_id) WTPR_COMMENTS    
     , x_wilt_str_insp_get_severity('MEXJ',sip_id) MEXJ_SEV
     , x_wilt_str_insp_get_extent('MEXJ',sip_id) MEXJ_EXT
     , x_wilt_str_insp_get_condition('MEXJ',sip_id) MEXJ_DEF
     , x_wilt_str_insp_get_comment('MEXJ',sip_id) MEXJ_COMMENTS  
     , x_wilt_str_insp_get_severity('BFID',sip_id) BFID_SEV
     , x_wilt_str_insp_get_extent('BFID',sip_id) BFID_EXT
     , x_wilt_str_insp_get_condition('BFID',sip_id) BFID_DEF
     , x_wilt_str_insp_get_comment('BFID',sip_id) BFID_COMMENTS    
     , x_wilt_str_insp_get_severity('BFIS',sip_id) BFIS_SEV
     , x_wilt_str_insp_get_extent('BFIS',sip_id) BFIS_EXT
     , x_wilt_str_insp_get_condition('BFIS',sip_id) BFIS_DEF
     , x_wilt_str_insp_get_comment('BFIS',sip_id) BFIS_COMMENTS
     , x_wilt_str_insp_get_severity('BFIP',sip_id) BFIP_SEV
     , x_wilt_str_insp_get_extent('BFIP',sip_id) BFIP_EXT
     , x_wilt_str_insp_get_condition('BFIP',sip_id) BFIP_DEF
     , x_wilt_str_insp_get_comment('BFIP',sip_id) BFIP_COMMENTS 
     , x_wilt_str_insp_get_severity('ACWG',sip_id) ACWG_SEV
     , x_wilt_str_insp_get_extent('ACWG',sip_id) ACWG_EXT
     , x_wilt_str_insp_get_condition('ACWG',sip_id) ACWG_DEF
     , x_wilt_str_insp_get_comment('ACWG',sip_id) ACWG_COMMENTS   
     , x_wilt_str_insp_get_severity('HPSF',sip_id) HPSF_SEV
     , x_wilt_str_insp_get_extent('HPSF',sip_id) HPSF_EXT
     , x_wilt_str_insp_get_condition('HPSF',sip_id) HPSF_DEF
     , x_wilt_str_insp_get_comment('HPSF',sip_id) HPSF_COMMENTS
     , x_wilt_str_insp_get_severity('CWSF',sip_id) CWSF_SEV
     , x_wilt_str_insp_get_extent('CWSF',sip_id) CWSF_EXT
     , x_wilt_str_insp_get_condition('CWSF',sip_id) CWSF_DEF
     , x_wilt_str_insp_get_comment('CWSF',sip_id) CWSF_COMMENTS
     , x_wilt_str_insp_get_severity('FVFS',sip_id) FVFS_SEV
     , x_wilt_str_insp_get_extent('FVFS',sip_id) FVFS_EXT
     , x_wilt_str_insp_get_condition('FVFS',sip_id) FVFS_DEF
     , x_wilt_str_insp_get_comment('FVFS',sip_id) FVFS_COMMENTS     
     , x_wilt_str_insp_get_severity('INRB',sip_id) INRB_SEV
     , x_wilt_str_insp_get_extent('INRB',sip_id) INRB_EXT
     , x_wilt_str_insp_get_condition('INRB',sip_id) INRB_DEF
     , x_wilt_str_insp_get_comment('INRB',sip_id) INRB_COMMENTS     
     , x_wilt_str_insp_get_severity('APRN',sip_id) APRN_SEV
     , x_wilt_str_insp_get_extent('APRN',sip_id) APRN_EXT
     , x_wilt_str_insp_get_condition('APRN',sip_id) APRN_DEF
     , x_wilt_str_insp_get_comment('APRN',sip_id) APRN_COMMENTS
     , x_wilt_str_insp_get_severity('FCCP',sip_id) FCCP_SEV
     , x_wilt_str_insp_get_extent('FCCP',sip_id) FCCP_EXT
     , x_wilt_str_insp_get_condition('FCCP',sip_id) FCCP_DEF
     , x_wilt_str_insp_get_comment('FCCP',sip_id) FCCP_COMMENTS     
     , x_wilt_str_insp_get_severity('RVBP',sip_id) RVBP_SEV
     , x_wilt_str_insp_get_extent('RVBP',sip_id) RVBP_EXT
     , x_wilt_str_insp_get_condition('RVBP',sip_id) RVBP_DEF
     , x_wilt_str_insp_get_comment('RVBP',sip_id) RVBP_COMMENTS     
     , x_wilt_str_insp_get_severity('RVTW',sip_id) RVTW_SEV
     , x_wilt_str_insp_get_extent('RVTW',sip_id) RVTW_EXT
     , x_wilt_str_insp_get_condition('RVTW',sip_id) RVTW_DEF
     , x_wilt_str_insp_get_comment('RVTW',sip_id) RVTW_COMMENTS
     , x_wilt_str_insp_get_severity('WNGW',sip_id) WNGW_SEV
     , x_wilt_str_insp_get_extent('WNGW',sip_id) WNGW_EXT
     , x_wilt_str_insp_get_condition('WNGW',sip_id) WNGW_DEF
     , x_wilt_str_insp_get_comment('WNGW',sip_id) WNGW_COMMENTS     
     , x_wilt_str_insp_get_severity('RWAL',sip_id) RWAL_SEV
     , x_wilt_str_insp_get_extent('RWAL',sip_id) RWAL_EXT
     , x_wilt_str_insp_get_condition('RWAL',sip_id) RWAL_DEF
     , x_wilt_str_insp_get_comment('RWAL',sip_id) RWAL_COMMENTS
     , x_wilt_str_insp_get_severity('EMBK',sip_id) EMBK_SEV
     , x_wilt_str_insp_get_extent('EMBK',sip_id) EMBK_EXT
     , x_wilt_str_insp_get_condition('EMBK',sip_id) EMBK_DEF
     , x_wilt_str_insp_get_comment('EMBK',sip_id) EMBK_COMMENTS
     , x_wilt_str_insp_get_severity('MACH',sip_id) MACH_SEV
     , x_wilt_str_insp_get_extent('MACH',sip_id) MACH_EXT
     , x_wilt_str_insp_get_condition('MACH',sip_id) MACH_DEF
     , x_wilt_str_insp_get_comment('MACH',sip_id) MACH_COMMENTS
     , x_wilt_str_insp_get_severity('ARBW',sip_id) ARBW_SEV
     , x_wilt_str_insp_get_extent('ARBW',sip_id) ARBW_EXT
     , x_wilt_str_insp_get_condition('ARBW',sip_id) ARBW_DEF
     , x_wilt_str_insp_get_comment('ARBW',sip_id) ARBW_COMMENTS
     , x_wilt_str_insp_get_severity('SGNS',sip_id) SGNS_SEV
     , x_wilt_str_insp_get_extent('SGNS',sip_id) SGNS_EXT
     , x_wilt_str_insp_get_condition('SGNS',sip_id) SGNS_DEF
     , x_wilt_str_insp_get_comment('SGNS',sip_id) SGNS_COMMENTS
     , x_wilt_str_insp_get_severity('MAST',sip_id) MAST_SEV
     , x_wilt_str_insp_get_extent('MAST',sip_id) MAST_EXT
     , x_wilt_str_insp_get_condition('MAST',sip_id) MAST_DEF
     , x_wilt_str_insp_get_comment('MAST',sip_id) MAST_COMMENTS     
     , x_wilt_str_insp_get_severity('SERV',sip_id) SERV_SEV
     , x_wilt_str_insp_get_extent('SERV',sip_id) SERV_EXT
     , x_wilt_str_insp_get_condition('SERV',sip_id) SERV_DEF
     , x_wilt_str_insp_get_comment('SERV',sip_id) SERV_COMMENTS     
     , x_wilt_str_insp_get_severity('VEGN',sip_id) VEGN_SEV
     , x_wilt_str_insp_get_extent('VEGN',sip_id) VEGN_EXT
     , x_wilt_str_insp_get_condition('VEGN',sip_id) VEGN_DEF
     , x_wilt_str_insp_get_comment('VEGN',sip_id) VEGN_COMMENTS                                                                                                  
from str_insp,v_str_bridge
where sip_str_id = str_id
and sip_snt_id = 'GE'
/