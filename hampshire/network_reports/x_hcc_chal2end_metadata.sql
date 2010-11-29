-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hampshire/network_reports/x_hcc_chal2end_metadata.sql-arc   1.0   Nov 29 2010 15:54:08   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_hcc_chal2end_metadata.sql  $
--       Date into PVCS   : $Date:   Nov 29 2010 15:54:08  $
--       Date fetched Out : $Modtime:   Nov 26 2010 13:32:48  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
SET DEFINE OFF;
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('X_HCC_CHAL2END', 'CHALIST Footpath - Adopted with 2 end points', 'x_hcc_chal2end.sql', 'SQL', NULL, 
    'N', 'Y', 'NET', 'FORM');
COMMIT;
SET DEFINE OFF;
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('X_HCC_CHAL2END', 'NET_ADMIN', 'NORMAL');
COMMIT;
SET DEFINE OFF;
Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, 
    GRM_TAG_TABLE, GRM_TAG_COLUMN, GRM_TAG_WHERE, GRM_LINESIZE, GRM_PAGESIZE, 
    GRM_PRE_PROCESS)
 Values
   ('X_HCC_CHAL2END', 'SQL', '$PROD_REPORTS', 'lst', 'N', 
    NULL, NULL, NULL, 80, 60, 
    NULL);
COMMIT;

