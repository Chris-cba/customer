-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/WAG/tpc_upg.sql-arc   3.0   Nov 27 2008 09:22:26   smarshall  $
--       Module Name      : $Workfile:   tpc_upg.sql  $
--       Date into PVCS   : $Date:   Nov 27 2008 09:22:26  $
--       Date fetched Out : $Modtime:   Nov 27 2008 09:22:10  $
--       PVCS Version     : $Revision:   3.0  $
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2008
-----------------------------------------------------------------------------
--
Insert into HIG_PRODUCTS
   (HPR_PRODUCT, HPR_PRODUCT_NAME, HPR_VERSION, HPR_PATH_NAME, HPR_KEY, 
    HPR_SEQUENCE, HPR_IMAGE, HPR_USER_MENU, HPR_LAUNCHPAD_ICON, HPR_IMAGE_TYPE)
 Values
   ('TPC', 'Third Party Claims', '4.0.2.2', NULL, 91, 
    NULL, NULL, NULL, NULL, NULL);

Insert into HIG_ROLES
   (HRO_ROLE, HRO_PRODUCT, HRO_DESCR)
 Values
   ('TPC0010', 'TPC', 'Third Party Claims');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('TPC0010', 'Third Party Claims', 'tpc0010', 'FMX', NULL, 
    'Y', 'N', 'TPC', NULL);

Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('TPC0010', 'TPC0010', 'NORMAL');

Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
    HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION)
 Values
   ('TPCURL', 'TPC', 'Third Party Claims URL', 'Holds the base URL thats calls the TPC system.', NULL, 
    'VARCHAR2', 'N', 'N');
Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
    HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION)
 Values
   ('TPCCATE', 'TPC', 'Third Party Claims Category', 'Holds the Enquiry Category which triggers the TPC system.', NULL, 
    'VARCHAR2', 'N', 'N');

Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('TPCCATE', 'CLAM');
Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('TPCURL', 'HTTP://GBEXOR8CD/PLS/WAG/F?P=113:101:::::P101_PASSED_DOC_ID:');

