--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/HA/insp_scheduling/fixes/fix 1/mai_4700_customer_HE_fix1_metadata.sql-arc   1.0   Jan 27 2016 14:11:36   Chris.Baugh  $
--       Module Name      : $Workfile:   mai_4700_customer_HE_fix1_metadata.sql  $
--       Date into PVCS   : $Date:   Jan 27 2016 14:11:36  $
--       Date fetched Out : $Modtime:   Jan 27 2016 11:56:56  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : P Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley ltd, 2016
-----------------------------------------------------------------------------
--

----------------------------------------------------------------------------------------
--
--nm_inv_domains_all
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT nm_inv_domains_all
SET TERM OFF

INSERT INTO nm_inv_domains_all
  (ID_DOMAIN
  ,ID_TITLE
  ,ID_START_DATE
  ,ID_DATATYPE
  )
SELECT 'INSP_INSPECTED'
      ,'INSPECTED?'
      ,TO_DATE('01/JAN/1900')
      ,'VARCHAR2'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 
                     FROM nm_inv_domains_all
                    WHERE ID_DOMAIN = 'INSP_INSPECTED');
                   
 ----------------------------------------------------------------------------------------
--
--nm_inv_attri_lookup_all
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT nm_inv_attri_lookup_all
SET TERM OFF

INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
  (IAL_DOMAIN
  ,IAL_VALUE
  ,IAL_MEANING
  ,IAL_START_DATE
  ,IAL_SEQ
  )
SELECT
   'INSP_INSPECTED' 
  ,'Y'
  ,'Yes'
  ,TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  ,1
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 
                     FROM NM_INV_ATTRI_LOOKUP_ALL 
                    WHERE IAL_DOMAIN = 'INSP_INSPECTED' 
                      AND IAL_VALUE = 'Y');
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
  (IAL_DOMAIN
  ,IAL_VALUE
  ,IAL_MEANING
  ,IAL_START_DATE
  ,IAL_SEQ
  )
SELECT
   'INSP_INSPECTED' 
  ,'N'
  ,'No'
  ,TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  ,2
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 
                     FROM NM_INV_ATTRI_LOOKUP_ALL 
                    WHERE IAL_DOMAIN = 'INSP_INSPECTED' 
                      AND IAL_VALUE = 'N');
--
INSERT INTO NM_INV_ATTRI_LOOKUP_ALL
  (IAL_DOMAIN
  ,IAL_VALUE
  ,IAL_MEANING
  ,IAL_START_DATE
  ,IAL_SEQ
  )
SELECT
   'INSP_INSPECTED' 
  ,'P'
  ,'Partial'
  ,TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  ,3
  FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 
                     FROM NM_INV_ATTRI_LOOKUP_ALL 
                    WHERE IAL_DOMAIN = 'INSP_INSPECTED' 
                      AND IAL_VALUE = 'P');

----------------------------------------------------------------------------------------
-- NM_INV_TYPES_ALL
--
-- select * from nm3_metadata.nm_inv_types_all
-- order by nit_inv_type
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_types_all
SET TERM OFF

INSERT INTO NM_INV_TYPES_ALL
   (NIT_INV_TYPE
   ,NIT_PNT_OR_CONT
   ,NIT_X_SECT_ALLOW_FLAG
   ,NIT_ELEC_DRAIN_CARR
   ,NIT_CONTIGUOUS
   ,NIT_REPLACEABLE
   ,NIT_EXCLUSIVE
   ,NIT_CATEGORY
   ,NIT_DESCR
   ,NIT_LINEAR
   ,NIT_USE_XY
   ,NIT_MULTIPLE_ALLOWED
   ,NIT_END_LOC_ONLY
   ,NIT_VIEW_NAME
   ,NIT_START_DATE
   ,NIT_FLEX_ITEM_FLAG
   ,NIT_ADMIN_TYPE
   ,NIT_TOP
   ,NIT_UPDATE_ALLOWED)
SELECT 'INSL', 'P', 'N', 'C', 'N', 
       'Y', 'N', 'I', 'Linear Inspection Record', 'N', 
       'N', 'N', 'N', 'V_NM_INSL', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 
       'N', 'NETW', 'N', 'Y'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPES_ALL
                   WHERE NIT_INV_TYPE = 'INSL');

----------------------------------------------------------------------------------------
-- NM_INV_TYPE_ATTRIBS_ALL
--
-- select * from nm3_metadata.nm_inv_type_attribs_all
-- order by ita_inv_type
--         ,ita_attrib_name
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_type_attribs_all
SET TERM OFF

INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE
   , ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_FOREIGN_KEY', 'N', 1, 'Y', 
    'VARCHAR2', 50, 'Scheduled Inspection ID', 'N', 'INSP_INSPECTION_ID', 
    'INSP_INSPECTION_ID', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_FOREIGN_KEY');

--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_NUM_ATTRIB100', 'N', 2, 'N', 
    'NUMBER', 22, 'Start Chainage', 'N', 'START_CHAINAGE', 
    'START_CHAINAGE', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB100');

--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_NUM_ATTRIB101', 'N', 3, 'N', 
    'NUMBER', 22, 'End Chainage', 'N', 'END_CHAINAGE', 
    'END_CHAINAGE', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_NUM_ATTRIB101');
    
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_DATE_ATTRIB86', 'N', 4, 'Y', 
    'DATE', 7, 'Date Inspected', 'N', 'DATE_INSPECTED', 
    'DATE_INSPECTED', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB86');
--    
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, ITA_VALIDATE_YN, 
    ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, 
    ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_CHR_ATTRIB28', 'N', 5, 'Y', 
    'VARCHAR2', 3, 'Defects Found?', 'Y_OR_N', 'Y', 
    'INSL_DEF_FOUND', 'INSL_DEF_FOUND', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 
    'N', 'Y', 2, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB28');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, ITA_VALIDATE_YN, 
    ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, 
    ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_CHR_ATTRIB29', 'N', 6, 'Y', 
    'VARCHAR2', 3, 'Inspection Complete?', 'Y_OR_N', 'Y', 
    'INSL_INSP_COMPLETE', 'INSL_INSP_COMPLETE', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 
    'N', 'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB29');
--   
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, ITA_VALIDATE_YN, 
    ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, 
    ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_CHR_ATTRIB30', 'N', 7, 'N', 
    'VARCHAR2', 50, 'Condition Rating', 'INSP_COND', 'Y', 
    'INSL_CONDITION', 'INSL_CONDITION', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 
    'N', 'Y', 10, 'Y', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB30');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_CHR_ATTRIB67', 'N', 8, 'N', 
    'VARCHAR2', 500, 'Condition Comment', 'N', 'INSL_CONDITION_COMMENT', 
    'INSL_CONDITION_COMMENT', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 'N', 'N', 
    'N', 10, 'N', 'MIXED'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB67');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_X', 'N', 9, 'N', 
    'NUMBER', 6, 'Start X (Easting)', 'N', 'START_EASTING', 
    'START_EASTING', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'Y', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_X');
--    
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_Y', 'N', 10, 'N', 
    'NUMBER', 6, 'Start Y (Northing)', 'N', 'START_NORTHING', 
    'START_NORTHING', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'Y', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL'AND  ITA_ATTRIB_NAME = 'IIT_Y');
--   
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_X_COORD', 'N', 11, 'N', 
    'NUMBER', 6, 'End X (Easting', 'N', 'END_EASTING', 
    'END_EASTING', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'Y', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_X_COORD');
--    
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_Y_COORD', 'N', 12, 'N', 
    'NUMBER', 6, 'End Y (Northing', 'N', 'END_NORTHING', 
    'END_NORTHING', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'Y', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_Y_COORD');
--
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_DATE_ATTRIB87', 'N', 13, 'N', 
    'DATE', 7, 'Survey Date', 'N', 'INSL_SURVEY_DATE', 
    'INSL_SURVEY_DATE', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL'AND  ITA_ATTRIB_NAME = 'IIT_DATE_ATTRIB87');
--    
INSERT INTO NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
SELECT 'INSL', 'IIT_CHR_ATTRIB31', 'N', 14, 'N', 
    'VARCHAR2', 50, 'Survey Time', 'N', 'INSL_SURVEY_TIME', 
    'INSL_SURVEY_TIME', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 'N', 'N', 
    'Y', 10, 'N', 'UPPER'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ATTRIBS_ALL
                   WHERE ITA_INV_TYPE = 'INSL' AND  ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB31');
--
----------------------------------------------------------------------------------------
-- NM_INV_NW_ALL
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT NM_INV_NW_ALL
SET TERM OFF

INSERT INTO NM_INV_NW_ALL
   (NIN_NW_TYPE, NIN_NIT_INV_CODE, NIN_LOC_MANDATORY, NIN_START_DATE)
SELECT 'D', 'INSL', 'N', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_NW_ALL 
                   WHERE NIN_NW_TYPE = 'D' AND NIN_NIT_INV_CODE = 'INSL');
   
--
----------------------------------------------------------------------------------------
-- NM_INV_NW_ALL
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT NM_INV_NW_ALL
SET TERM OFF

INSERT INTO NM_INV_TYPE_GROUPINGS_ALL
   (ITG_INV_TYPE, ITG_PARENT_INV_TYPE, ITG_MANDATORY, ITG_RELATION, ITG_START_DATE)
SELECT 'INSL', 'INSP', 'N', 'NONE', TO_DATE('01/01/2000 00:00:00', 'MM/DD/YYYY HH24:MI:SS')
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_GROUPINGS_ALL 
                   WHERE ITG_INV_TYPE = 'INSL' AND ITG_PARENT_INV_TYPE = 'INSP');

                   
----------------------------------------------------------------------------------------
--
-- Update INSP IIT_CHR_ATTRIB29 to use INSP_INSPECTED domain
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT Update INSP IIT_CHR_ATTRIB29 to use INSP_INSPECTED domain
SET TERM OFF

UPDATE NM_INV_TYPE_ATTRIBS_ALL
   SET ITA_ID_DOMAIN =   'INSP_INSPECTED'
 WHERE ITA_INV_TYPE = 'INSP'
   AND ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB29';

exec nm3inv.create_view('INSL');

exec nm3inv_api_gen.build_one('INSL');    

----------------------------------------------------------------------------------------
-- NM_INV_TYPE_ROLES
--
-- select * from nm3_metadata.nm_inv_type_roles
-- order by itr_inv_type
--         ,itr_hro_role
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT nm_inv_type_roles
SET TERM OFF

INSERT INTO NM_INV_TYPE_ROLES
       (ITR_INV_TYPE
       ,ITR_HRO_ROLE
       ,ITR_MODE
       )
SELECT 
        'INSL'
       ,'NET_USER'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ROLES
                   WHERE ITR_INV_TYPE = 'INSL'
                    AND  ITR_HRO_ROLE = 'NET_USER');
                    
INSERT INTO NM_INV_TYPE_ROLES
       (ITR_INV_TYPE
       ,ITR_HRO_ROLE
       ,ITR_MODE
       )
SELECT 
        'INSL'
       ,'NET_READONLY'
       ,'READONLY' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPE_ROLES
                   WHERE ITR_INV_TYPE = 'INSL'
                    AND  ITR_HRO_ROLE = 'NET_READONLY');
                    
----------------------------------------------------------------------------------------
-- HIG_OPTION_LIST
--
-- select * from nm3_metadata.hig_option_list
-- order by hol_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_option_list
SET TERM OFF

INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       ,HOL_MAX_LENGTH
       )
SELECT 
        'ASSINSLCSV'
       ,'MAI'
       ,'Partial Asset Inspections'
       ,'Choose which CSV file definition is to used for partial Asset inspections'
       ,NULL
       ,'VARCHAR2'
       ,'N'
       ,'N'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'ASSINSLCSV');	

----------------------------------------------------------------------------------------
-- HIG_OPTION_VALUES
--
-- select * from nm3_metadata.hig_option_values
-- order by hov_id
--
----------------------------------------------------------------------------------------

SET TERM ON
PROMPT hig_option_values
SET TERM OFF

INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'ASSINSLCSV'
       ,'MCI_INSL_INSERT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'ASSINSLCSV');			
              