-- Install HTDR1 product and interface items

delete from HIG_STANDARD_FAVOURITES where HSTF_PARENT = 'OHMS';

delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD = 'OHMS';

delete from GRI_MODULES where GRM_MODULE = 'OHMS_RUN';

delete from HIG_MODULE_ROLES
where HMR_ROLE = 'TI_APPROLE_OHMS_USER';

grant TI_APPROLE_OHMS_USER to transinfo;

delete from HIG_MODULES where 
 HMO_APPLICATION = 'OHMS';

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('OHMS_RUN', 'Run OHMS Extract', 'OHMS_RUN' , 'SQL', NULL, 
    'N', 'Y', 'OHMS', NULL);
    
  
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('OHMS_EXTRACT', 'Download OHMS Extract', 'xodot_ohms.ohms_report', 'WEB', NULL, 
    'N', 'N', 'OHMS', NULL);


Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('OHMS_RUN', 'TI_APPROLE_OHMS_USER', 'NORMAL');
   
   Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('OHMS_EXTRACT', 'TI_APPROLE_OHMS_USER', 'NORMAL');


Insert into GRI_MODULES
   (GRM_MODULE, GRM_MODULE_TYPE, GRM_MODULE_PATH, GRM_FILE_TYPE, GRM_TAG_FLAG, 
    GRM_TAG_TABLE, GRM_TAG_COLUMN, GRM_TAG_WHERE, GRM_LINESIZE, GRM_PAGESIZE, 
    GRM_PRE_PROCESS)
 Values
   ('OHMS_RUN', 'SQL', 'c', 'a', 'N', 
    NULL, NULL, NULL, 80, 66, 
    'XODOT_ohms.create_extract' );

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('FAVOURITES', 'OHMS', 'OHMS', 'F', 111);

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('OHMS', 'OHMS_RUN', 'Generate OHMS Extract', 'M', 1);

Insert into HIG_STANDARD_FAVOURITES
   (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
 Values
   ('OHMS', 'OHMS_EXTRACT', 'Download OHMS Extract', 'M', 2);
   
