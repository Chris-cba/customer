--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/install/setup.sql-arc   1.3   Jun 11 2009 22:35:18   mhuitson  $
--       Module Name      : $Workfile:   setup.sql  $
--       Date into PVCS   : $Date:   Jun 11 2009 22:35:18  $
--       Date fetched Out : $Modtime:   Jun 11 2009 22:34:40  $
--       PVCS Version     : $Revision:   1.3  $
--       Based on SCCS version :

/*
||DDL
*/
propmt Creating EAM Database Objects.

CREATE SEQUENCE EDO_ID_SEQ;

CREATE TABLE EAM_DEFECT_OBJECTS
  (EDO_ID               NUMBER         NOT NULL
  ,EDO_DEF_DEFECT_ID    NUMBER         NOT NULL
  ,EDO_WORK_REQUEST_ID  NUMBER
  ,EDO_WIP_ENTITY_ID    NUMBER
  ,EDO_ERROR            VARCHAR2(4000)
  ,EDO_WIP_ENTITY_NAME  VARCHAR2(240)
  ,EDO_SERVICE_REQUEST_NO  VARCHAR2(64)
   );

ALTER TABLE EAM_DEFECT_OBJECTS
  ADD (PRIMARY KEY(EDO_ID));

CREATE TABLE EAM_FT_INV_TYPE_GROUPINGS_ALL
(
  EFTG_ID               INTEGER            NOT NULL, 
  EFTG_INV_TYPE         VARCHAR2(4)        NOT NULL,
  EFTG_FK_COLUMN        VARCHAR2(30),
  EFTG_DESCR_COLUMN     VARCHAR2(30)       NOT NULL,
  EFTG_PARENT_INV_TYPE  VARCHAR2(4),
  EFTG_DATE_CREATED     DATE               NOT NULL,
  EFTG_DATE_MODIFIED    DATE               NOT NULL,
  EFTG_MODIFIED_BY      VARCHAR2(30)       NOT NULL,
  EFTG_CREATED_BY       VARCHAR2(30)       NOT NULL
)
/
ALTER TABLE EAM_FT_INV_TYPE_GROUPINGS_ALL ADD (
  CONSTRAINT EFTG_PK
 PRIMARY KEY
 (EFTG_ID))
/
ALTER TABLE EAM_FT_INV_TYPE_GROUPINGS_ALL ADD (
  CONSTRAINT EFTG_PARENT_NIT_FK 
 FOREIGN KEY (EFTG_PARENT_INV_TYPE) 
 REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE))
/
ALTER TABLE EAM_FT_INV_TYPE_GROUPINGS_ALL ADD (
  CONSTRAINT EFTG_NIT_FK 
 FOREIGN KEY (EFTG_INV_TYPE) 
 REFERENCES NM_INV_TYPES_ALL (NIT_INV_TYPE))
/ 
CREATE INDEX EFTG_NIT_PARENT_FK_IND ON EAM_FT_INV_TYPE_GROUPINGS_ALL
(EFTG_PARENT_INV_TYPE)
/
CREATE INDEX EFTG_NIT_FK_IND ON EAM_FT_INV_TYPE_GROUPINGS_ALL
(EFTG_INV_TYPE)
/

CREATE SEQUENCE EAM_EFTG_ID_SEQ
  START WITH 1 INCREMENT BY 1 NOCACHE;

ALTER TRIGGER def_due_date_time DISABLE;

/*
||Metadata.
*/
prompt Creating EAM Product Data.

Insert into HIG_PRODUCTS
   (HPR_PRODUCT, HPR_PRODUCT_NAME, HPR_VERSION, HPR_PATH_NAME, HPR_KEY, 
    HPR_SEQUENCE, HPR_IMAGE, HPR_USER_MENU, HPR_LAUNCHPAD_ICON, HPR_IMAGE_TYPE)
 Values
   ('EAM', 'Oracle EAM Interface', '4.0.1.0', NULL, 69, 
    NULL, NULL, NULL, NULL, NULL);

prompt Creating EAM Error Messages.

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,1
   ,NULL
   ,'EAM Organization Does Not Exist'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,2
   ,NULL
   ,'EAM Department Does Not Exist'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,3
   ,NULL
   ,'EAM Asset Group Does Not Exist'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,4
   ,NULL
   ,'An Error Occured'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,5
   ,NULL
   ,'Defect Id Does Not Exist'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,6
   ,NULL
   ,'Repair Does Not Exist'
   ,NULL);

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_HER_NO, NER_DESCR, NER_CAUSE)
 Values
   ('EAM'
   ,7
   ,NULL
   ,'Cannot Create A Work Request For A Defect With No Associated Asset.'
   ,NULL);


INSERT INTO nm_errors
            (ner_appl, ner_id, ner_her_no, ner_descr, ner_cause
            )
     VALUES ('EAM', 8, NULL, 'Service Request Number not found', NULL
            );

INSERT INTO nm_errors
            (ner_appl, ner_id, ner_her_no, ner_descr, ner_cause
            )
     VALUES ('EAM', 9, NULL, 'One and only one asset must be selected', NULL
            );

INSERT INTO nm_errors
            (ner_appl, ner_id, ner_her_no, ner_descr, ner_cause
            )
     VALUES ('EAM', 10, NULL, 'Service Request is at a Status that prevents creation of a Work Request / Work Order', NULL
            );

prompt Creating EAM Product Options.

Insert
  into HIG_OPTION_LIST
      (HOL_ID
      ,HOL_PRODUCT
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
      )
Values('EAMIDATTR'
      ,'EAM'
      ,'EAM ID Attribute'
      ,'This Option Defines Which Asset Attribute Column Should Be Used To Store The EAM Asset Id'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      );

Insert
  into HIG_OPTION_LIST
      (HOL_ID
      ,HOL_PRODUCT
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
      )
Values('EAMORGCODE'
      ,'EAM'
      ,'EAM Organization Code'
      ,'This Option Defines The EAM Organization Code To Be Used When Creating Objects In EAM'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      );

Insert
  into HIG_OPTION_LIST
      (HOL_ID
      ,HOL_PRODUCT
      ,HOL_NAME
      ,HOL_REMARKS
      ,HOL_DOMAIN
      ,HOL_DATATYPE
      ,HOL_MIXED_CASE
      ,HOL_USER_OPTION
      )
Values('EAMUSER'
      ,'EAM'
      ,'EAM USERNAME'
      ,'This Option Defines The EAM Username To Be Used When Creating Objects In EAM.'
      ,NULL
      ,'VARCHAR2'
      ,'N'
      ,'N'
      );

prompt Creating EAM Module data.

INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
     VALUES ('EAM0010'
           , 'Define External Asset Hierarchy'
           , 'eam0010'
           , 'FMX'
           ,  NULL
           , 'N'
           , 'N'
           , 'EAM'
           , 'FORM'
            );

INSERT INTO hig_module_roles
            (hmr_module, hmr_role, hmr_mode
            )
     VALUES ('EAM0010', 'HIG_USER', 'NORMAL'
            );

INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
     VALUES ('EAM3807'
           , 'Create Work Request/Work Order'
           , 'eam3807'
           , 'FMX'
           ,  NULL
           , 'Y'
           , 'N'
           , 'EAM'
           , 'FORM'
            );
            
INSERT INTO hig_module_roles
            (hmr_module, hmr_role, hmr_mode
            )
     VALUES ('EAM3807', 'HIG_USER', 'NORMAL'
            );

prompt Creating Service Request Status Domain.

/*
||Add The Service Request Status Domain.
*/
INSERT
  INTO hig_status_domains
      (HSD_DOMAIN_CODE
      ,HSD_PRODUCT
      ,HSD_DESCRIPTION
      ,HSD_FEATURE1
      ,HSD_FEATURE2
      ,HSD_FEATURE3
      ,HSD_FEATURE4
      ,HSD_FEATURE5
      ,HSD_FEATURE6
      ,HSD_FEATURE7
      ,HSD_FEATURE8
      ,HSD_FEATURE9)
VALUES('SERVICE_REQUEST_STATUS'
      ,'MAI'
      ,'EAM Service Request Status Names. This Domain allows Service Request Status Codes to be identified as valid for the creation of Work Requests/Work Orders. The EAM Service Request Status Name will be matched with Name given below, this is case sensitive.'
      ,'Work Request / Work Order creation is allowed.'
      ,'Display a warning before Work Request / Work Order creation.'
      ,'Not Used'
      ,'Not Used'
      ,'Not Used'
      ,'Not Used'
      ,'Not Used'
      ,'Not Used'
      ,'Not Used')
/

/*
||Add Status Codes To The Domain.
*/
INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'NEW'
      ,'New'
      ,1
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/

INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'ASSIGNED'
      ,'Assigned'
      ,2
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/

INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'AWAIT_EXT'
      ,'Awaiting External Action'
      ,3
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/

INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'INPROGRESS'
      ,'In Progress'
      ,4
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/

INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'REASSIGNED'
      ,'Reassigned'
      ,5
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/

INSERT
  INTO hig_status_codes
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date) 
VALUES('SERVICE_REQUEST_STATUS'
      ,'COMPNOTCLS'
      ,'Completed not closed'
      ,6
      ,'Y'
      ,'Y'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,'N'
      ,NULL
      ,NULL )
/


COMMIT ;