-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/WAG/tpc/install/tpcdata1.sql-arc   3.0   Sep 21 2009 16:16:28   smarshall  $
--       Module Name      : $Workfile:   tpcdata1.sql  $
--       Date into PVCS   : $Date:   Sep 21 2009 16:16:28  $
--       Date fetched Out : $Modtime:   Sep 21 2009 16:15:52  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
Insert into HIG_PRODUCTS
   (HPR_PRODUCT, HPR_PRODUCT_NAME, HPR_VERSION, HPR_PATH_NAME, HPR_KEY, 
    HPR_SEQUENCE, HPR_IMAGE, HPR_USER_MENU, HPR_LAUNCHPAD_ICON, HPR_IMAGE_TYPE)
 Values
   ('TPC', 'Third Party Claims', '4.0.5.0', NULL, 91, 
    NULL, NULL, NULL, NULL, NULL);

Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
    HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION)
 Values
   ('TPCURL', 'TPC', 'Third Party Claims URL', 'Holds the base URL thats calls the TPC system.', NULL, 
    'VARCHAR2', 'Y', 'N');
Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
    HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION)
 Values
   ('TPCCATE', 'TPC', 'Third Party Claims Category', 'Holds the Enquiry Category which triggers the TPC system.', NULL, 
    'VARCHAR2', 'N', 'N');

Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('TPCURL', 'http://195.188.241.201/pls/wag/f?p=129:101:::::P101_PASSED_DOC_ID:');
Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('TPCCATE', 'CLAM');
COMMIT;
