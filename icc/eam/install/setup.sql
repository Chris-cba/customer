--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/icc/eam/install/setup.sql-arc   1.0   Nov 28 2008 11:22:52   mhuitson  $
--       Module Name      : $Workfile:   setup.sql  $
--       Date into PVCS   : $Date:   Nov 28 2008 11:22:52  $
--       Date fetched Out : $Modtime:   Nov 28 2008 11:21:12  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

/*
||DDL
*/
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

COMMIT ;