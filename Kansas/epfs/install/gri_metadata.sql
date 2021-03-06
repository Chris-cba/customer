-- Hig modules & hig module roles
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Kanzas/epfs/install/gri_metadata.sql-arc   2.0   Jul 06 2007 14:09:36   Ian Turnbull  $
--       Module Name      : $Workfile:   gri_metadata.sql  $
--       Date into SCCS   : $Date:   Jul 06 2007 14:09:36  $
--       Date fetched Out : $Modtime:   Jul 06 2007 13:09:58  $
--       SCCS Version     : $Revision:   2.0  $
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS01', 'Non Interstate system Map', 'xepfs01', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS01','HIG_USER','NORMAL');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS02', 'Non Interstate High Priority Project Map', 'xepfs02', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS02','HIG_USER','NORMAL');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS03', 'Interstate System Map', 'xepfs01', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS03','HIG_USER','NORMAL');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS04', 'Interstate High Priority Project Map', 'xepfs04', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS04','HIG_USER','NORMAL');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS05', 'Bridge System Map', 'xepfs05', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS05','HIG_USER','NORMAL');

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION)
 Values
   ('XEPFS06', 'Bridge High Priority Project Map', 'xepfs06', 'SQL', 'Y', 'Y', 'HIG');

insert into hig_module_roles
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 values
   ('XEPFS06','HIG_USER','NORMAL');


commit;



-- gri_modules
Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS01', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS02', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS03', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS04', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS05', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);

Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, GRM_LINESIZE, GRM_PAGESIZE)
 Values
   ('XEPFS06', 'SQL', '$PROD_HOME/bin', 'lis', 'N', 80, 60);


COMMIT;

--gri_params
Insert into GRI_PARAMS
   (GP_PARAM, GP_PARAM_TYPE)
 Values
   ('ASSESSMENT_ID', 'CHAR');

Insert into GRI_PARAMS
   (GP_PARAM, GP_PARAM_TYPE)
 Values
   ('COUNTY_NUMBER', 'CHAR');

Insert into GRI_PARAMS
   (GP_PARAM, GP_PARAM_TYPE)
 Values
   ('THRESHOLD', 'CHAR');

COMMIT;

-- gri_module_params
Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS01', 'ASSESSMENT_ID', 10, 'Non interstate need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Non interstate need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS01', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');


Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS02', 'ASSESSMENT_ID', 10, 'Non interstate need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Non interstate need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS02', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS02', 'THRESHOLD', 10, 'Threshold Percent', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Threshold Percent', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS03', 'ASSESSMENT_ID', 10, 'Interstate need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Interstate need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS03', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');


Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS04', 'ASSESSMENT_ID', 10, 'Interstate need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Interstate need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS04', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS04', 'THRESHOLD', 10, 'Threshold Percent', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Threshold Percent', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS05', 'ASSESSMENT_ID', 10, 'Bridge need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Bridge need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS05', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS06', 'ASSESSMENT_ID', 10, 'Bridge need assessment id', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Bridge need assessment id', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS06', 'COUNTY_NUMBER', 10, 'County Number', 'N', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'County Number', 'N');

Insert into GRI_MODULE_PARAMS
   (GMP_MODULE, GMP_PARAM, GMP_SEQ, GMP_PARAM_DESCR, GMP_MANDATORY, GMP_NO_ALLOWED, GMP_TAG_RESTRICTION, GMP_VISIBLE, GMP_GAZETTEER, GMP_LOV, GMP_VAL_GLOBAL, GMP_WILDCARD, GMP_HINT_TEXT, GMP_ALLOW_PARTIAL)
 Values
   ('XEPFS06', 'THRESHOLD', 10, 'Threshold Percent', 'Y', 1, 'N', 'Y', 'N', 'N', 'N', 'N', 'Threshold Percent', 'N');


COMMIT;



