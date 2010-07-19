---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/NSG Themes/Create_road_name_search.sql-arc   1.0   Jul 19 2010 09:33:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   Create_road_name_search.sql  $
--       Date into PVCS   : $Date:   Jul 19 2010 09:33:22  $
--       Date fetched Out : $Modtime:   Jul 19 2010 09:32:32  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to create the standard NSG Themes. 
--
-- Please read the readme.rtf document in the zip file before running this script.
--
---------------------------------------------------------------------------------------------------
--
-- This script assumes that there is a role NSG_USER.
--
-- This script needs to be run as the highways user.
--
-- The themes for Type 1 & 2 streets must exist.
--
------------------------------------------------------------------------------------------------------
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile
--
--
define logfile1='Create_road_name_search_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000
--
spool &logfile1
--
set echo on
set time on


DECLARE
   l_action varchar2(100);
BEGIN


   l_action := 'Creating metamodel for RNAM';
   dbms_output.PUT_LINE( l_action );
   
   Insert into NM_INV_TYPES_ALL
      (NIT_INV_TYPE, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG, NIT_ELEC_DRAIN_CARR, NIT_CONTIGUOUS, 
       NIT_REPLACEABLE, NIT_EXCLUSIVE, NIT_CATEGORY, NIT_DESCR, NIT_LINEAR, 
       NIT_USE_XY, NIT_MULTIPLE_ALLOWED, NIT_END_LOC_ONLY, NIT_SCREEN_SEQ, NIT_VIEW_NAME, 
       NIT_START_DATE, NIT_END_DATE, NIT_SHORT_DESCR, NIT_FLEX_ITEM_FLAG, NIT_TABLE_NAME, 
       NIT_LR_NE_COLUMN_NAME, NIT_LR_ST_CHAIN, NIT_LR_END_CHAIN, NIT_ADMIN_TYPE, NIT_ICON_NAME, 
       NIT_TOP, NIT_FOREIGN_PK_COLUMN, NIT_UPDATE_ALLOWED, NIT_DATE_CREATED, NIT_DATE_MODIFIED, 
       NIT_MODIFIED_BY, NIT_CREATED_BY, NIT_NOTES)
    Values
      ('RNAM', 'C', 'N', 'C', 'N', 
       'N', 'N', 'F', 'Street Names', 'N', 
       'N', 'N', 'N', NULL, 'V_NM_RNAM', 
       TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 'N', 'V_NM_NSGN_OFFN_NT', 
       NULL, NULL, NULL, 'NSG', NULL, 
      'N', 'NE_ID', 'Y', SYSDATE, SYSDATE, USER, USER, NULL);

   
   l_action := 'Creating metamodel attributes for RNAM';
   dbms_output.PUT_LINE( l_action );
   
   Insert into NM_INV_TYPE_ATTRIBS_ALL
      (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
       ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
       ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
       ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
       ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
       ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
       ITA_DISP_WIDTH)
    Values
      ('RNAM', 'NE_DESCR', 'N', 10, 'N', 
       'VARCHAR2', 80, NULL, 'Street', NULL, 
       'N', NULL, NULL, NULL, 'STREET', 
       'STREET', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'Y', NULL, 
       NULL, NULL, 'N', 'N', SYSDATE, SYSDATE, USER, USER, NULL, 'Y', 30);

   Insert into NM_INV_TYPE_ATTRIBS_ALL
      (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
       ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
       ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
       ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
       ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
       ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
       ITA_DISP_WIDTH)
    Values
      ('RNAM', 'COUNTY', 'N', 25, 'N', 
       'VARCHAR2', 240, NULL, 'County', NULL, 
       'N', NULL, NULL, NULL, 'COUNTY', 
       'COUNTY', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'Y', NULL, 
       NULL, NULL, 'N', 'N', SYSDATE, SYSDATE, USER, USER, NULL, 'Y', 30);

   Insert into NM_INV_TYPE_ATTRIBS_ALL
      (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
       ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
       ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
       ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
       ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
       ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
       ITA_DISP_WIDTH)
    Values
      ('RNAM', 'TOWN', 'N', 15, 'N', 
       'VARCHAR2', 80, NULL, 'Town', NULL, 
       'N', NULL, NULL, NULL, 'TOWN', 
       'TOWN', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'Y', NULL, 
       NULL, NULL, 'N', 'N', SYSDATE, SYSDATE, USER, USER, NULL, 'Y', 30);

   Insert into NM_INV_TYPE_ATTRIBS_ALL
      (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
       ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
       ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
       ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
       ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
       ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
       ITA_DISP_WIDTH)
    Values
      ('RNAM', 'LOCALITY', 'N', 30, 'N', 
       'VARCHAR2', 80, NULL, 'Locality', NULL, 
       'N', NULL, NULL, NULL, 'LOCAL_REF', 
       'LOCAL_REF', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'Y', NULL, 
       NULL, NULL, 'N', 'N', SYSDATE, SYSDATE, USER, USER, NULL, 'Y', 30);

   Insert into NM_INV_TYPE_ATTRIBS_ALL
      (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
       ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
       ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
       ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
       ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
       ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
       ITA_DISP_WIDTH)
    Values
      ('RNAM', 'NSG_REFERENCE', 'N', 35, 'N', 
       'VARCHAR2', 8, NULL, 'USRN', NULL, 
       'N', NULL, NULL, NULL, 'NSG_REFERENCE', 
       'NSG_REFERENCE', TO_DATE('01/01/1900 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
       NULL, NULL, 'N', 'N', SYSDATE, SYSDATE, USER, USER, NULL, 'Y', 8);


   l_action := 'Adding Role to metamodel RNAM';
   dbms_output.PUT_LINE( l_action );
   Insert into NM_INV_TYPE_ROLES
      (ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE)
    Values
      ('RNAM', 'NSG_USER', 'NORMAL');


   l_action := 'Putting entry in nm_inv_themes'; 
   dbms_output.PUT_LINE( l_action );

   insert into nm_inv_themes
     select 'RNAM',gt_theme_id
       from gis_themes
      where gt_table_name='V_NM_NAT_NSGN_OFFN_SDO_DT';


   l_action := 'Finished... Committing';
   dbms_output.PUT_LINE( l_action );

   commit;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.PUT_LINE( 'Error occured doing ...' || l_action );
END;
/

------------------------------------------------------------------------------------------------------

spool off
