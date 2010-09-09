--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/hbud/install/hbuddata1.sql-arc   3.0   Sep 09 2010 14:52:46   Ian.Turnbull  $
--       Module Name      : $Workfile:   hbuddata1.sql  $
--       Date into PVCS   : $Date:   Sep 09 2010 14:52:46  $
--       Date fetched Out : $Modtime:   Sep 09 2010 14:39:46  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
/***************************************************************************

INFO
====
As at Release 4.1.0.0


TABLES PROCESSED
================
HIG_PRODUCTS
HIG_MODULES
HIG_OPTION_LIST
HIG_OPTION_VALUES
GRI_MODULES
HIG_STANDARD_FAVOURITES
HIG_ROLES
HIG_MODULE_ROLES

***************************************************************************/

set define off;
set feedback off;

---------------------------------
-- START OF GENERATED METADATA --
---------------------------------

--
--********** HIG_PRODUCTS **********--
SET TERM ON
PROMPT hig_products
SET TERM OFF
--
-- Columns
-- HPR_PRODUCT                    NOT NULL VARCHAR2(6)
--   HPR_PK (Pos 1)
-- HPR_PRODUCT_NAME               NOT NULL VARCHAR2(40)
--   HPR_UK1 (Pos 1)
-- HPR_VERSION                    NOT NULL VARCHAR2(10)
--   HPR_UK1 (Pos 2)
-- HPR_PATH_NAME                           VARCHAR2(100)
-- HPR_KEY                                 NUMBER(22)
-- HPR_SEQUENCE                            NUMBER(3)
-- HPR_IMAGE                               VARCHAR2(40)
-- HPR_USER_MENU                           VARCHAR2(1)
-- HPR_LAUNCHPAD_ICON                      VARCHAR2(40)
-- HPR_IMAGE_TYPE                          VARCHAR2(4)
--
--
INSERT INTO HIG_PRODUCTS
       (HPR_PRODUCT
       ,HPR_PRODUCT_NAME
       ,HPR_VERSION
       ,HPR_PATH_NAME
       ,HPR_KEY
       ,HPR_SEQUENCE
       ,HPR_IMAGE
       ,HPR_USER_MENU
       ,HPR_LAUNCHPAD_ICON
       ,HPR_IMAGE_TYPE
       )
SELECT 
        'HBUD'
       ,'HBUD INTERFACE'
       ,'4.0.0.0'
       ,''
       ,79
       ,8
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PRODUCTS
                   WHERE HPR_PRODUCT = 'HBUD');


--********** HIG_MODULES **********--
SET TERM ON
PROMPT hig_modules
SET TERM OFF
--
-- Columns
-- HMO_MODULE                     NOT NULL VARCHAR2(30)
--   HIG_MODULES_PK (Pos 1)
-- HMO_TITLE                      NOT NULL VARCHAR2(70)
-- HMO_FILENAME                   NOT NULL VARCHAR2(30)
-- HMO_MODULE_TYPE                NOT NULL VARCHAR2(3)
-- HMO_FASTPATH_OPTS                       VARCHAR2(2000)
-- HMO_FASTPATH_INVALID           NOT NULL VARCHAR2(1)
-- HMO_USE_GRI                    NOT NULL VARCHAR2(1)
-- HMO_APPLICATION                         VARCHAR2(6)
-- HMO_MENU                                VARCHAR2(30)
--
--
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
   SELECT 'HBUD_RUN', 'Regenerate HHBUD', 'RUN_HBUD', 'SQL', NULL, 
    'N', 'Y', 'HBUD', NULL FROM DUAL
	WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
	                  WHERE HMO_MODULE = 'HBUD_RUN');
--

Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
    HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
   SELECT 'HBUD_LIST', 'HBUD Download Page', 'xodot_hbud_extract_process.hbud_params', 'WEB', NULL, 
    'N', 'N', 'HBUD', NULL FROM DUAL
	WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
	                  WHERE HMO_MODULE = 'HBUD_LIST');


COMMIT;
--


SET TERM ON
PROMPT gri_modules
SET TERM OFF
----------------------------------------------------------------------------------------
-- GRI_MODULES
-----------------------------------------------------------------------------------------
	
INSERT INTO GRI_MODULES
       (GRM_MODULE
       ,GRM_MODULE_TYPE
       ,GRM_MODULE_PATH
       ,GRM_FILE_TYPE
       ,GRM_TAG_FLAG
       ,GRM_TAG_TABLE
       ,GRM_TAG_COLUMN
       ,GRM_TAG_WHERE
       ,GRM_LINESIZE
       ,GRM_PAGESIZE
       ,GRM_PRE_PROCESS
       )
SELECT 
        'HBUD_RUN'
       ,'SQL'
       ,'c'
       ,'a'
       ,'N'
       ,Null
       ,Null
       ,Null
       ,80
       ,66
       ,'xodot_hbud_extract_process.regenerate_hbud' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'HBUD_RUN');
				   
SET TERM ON
PROMPT hig_standard_favourites
SET TERM OFF
--
   
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HBUD'
       ,'HBUD'
       ,'F'
       ,120 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'HBUD');

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HBUD'
       ,'HBUD_RUN'
       ,'Regenerate HBUD Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HBUD'
                    AND  HSTF_CHILD = 'HBUD_RUN');	

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HBUD'
       ,'HBUD_LIST'
       ,'HBUD Download'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HBUD'
                    AND  HSTF_CHILD = 'HBUD_LIST');						
--
--
----------------------------------------------------------------------------------------
--
COMMIT;	

--
--********** HIG_ROLES **********--
SET TERM ON
PROMPT hig_roles
SET TERM OFF
--
-- Columns
-- HRO_ROLE                       NOT NULL VARCHAR2(30)
--   HIG_ROLES_PK (Pos 1)
-- HRO_PRODUCT                    NOT NULL VARCHAR2(6)
--   HRO_HPR_FK (Pos 1)
-- HRO_DESCR                               VARCHAR2(2000)
--
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'TI_APPROLE_HBUD_ADMIN'
       ,'HBUD'
       ,'HBUD Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'TI_APPROLE_HBUD_ADMIN');
--
INSERT INTO HIG_ROLES
       (HRO_ROLE
       ,HRO_PRODUCT
       ,HRO_DESCR
       )
SELECT 
        'TI_APPROLE_HBUD_USER'
       ,'HBUD'
       ,'HBUD User Readonly' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                   WHERE HRO_ROLE = 'TI_APPROLE_HBUD_USER');
--

--
--
--********** HIG_MODULE_ROLES **********--
SET TERM ON
PROMPT hig_module_roles
SET TERM OFF
--
-- Columns
-- HMR_MODULE                     NOT NULL VARCHAR2(30)
--   HMR_PK (Pos 1)
--   HMR_HMO_FK (Pos 1)
-- HMR_ROLE                       NOT NULL VARCHAR2(30)
--   HMR_PK (Pos 2)
--   HMR_HRO_FK (Pos 1)
-- HMR_MODE                       NOT NULL VARCHAR2(10)
--
--
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 select 'HBUD_RUN', 'TI_APPROLE_HBUD_ADMIN', 'NORMAL' from dual
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HBUD_RUN'
				   AND HMR_ROLE = 'TI_APPROLE_HBUD_ADMIN');
--
Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 select 'HBUD_LIST', 'TI_APPROLE_HBUD_ADMIN', 'NORMAL' from dual
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HBUD_LIST'
				   AND HMR_ROLE = 'TI_APPROLE_HBUD_ADMIN');			   
				   



commit;

set feedback on
set define on				   
--
-------------------------------
-- END OF METADATA --
-------------------------------
--
