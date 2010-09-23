--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/oldham/str/create_stra_asset_metamodel.sql-arc   3.1   Sep 23 2010 13:27:14   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_stra_asset_metamodel.sql  $
--       Date into PVCS   : $Date:   Sep 23 2010 13:27:14  $
--       Date fetched Out : $Modtime:   Sep 23 2010 09:50:10  $
--       PVCS Version     : $Revision:   3.1  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--  This script was written by Aileen Heal as part of BRS 2704 
--  it create the asset metamodel for structures (loaded as assets)
--
-- create domains
Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_ADDOPTED_YN', 'ADDOPTED HWAY Y N P', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2')
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_APPENDIX', 'APPENDIX', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2')
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_OWNER', 'OWNER HIGHWAYS AUTHORITY', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2') 
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_PARAPET_TYPE', 'PARAPET TYPE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2') 
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_STRUCTURE_TYPE', 'STRUCTURE TYPE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2') 
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_UNDER_OVER', 'UNDER OVER', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2')
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_YES_NO', 'YES NO', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2')
/

Insert into NM_INV_DOMAINS_ALL
   (ID_DOMAIN, ID_TITLE, ID_START_DATE, ID_DATATYPE)
 Values
   ('STRA_YES_NO_?', 'YES NO ?', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'VARCHAR2') 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_ADDOPTED_YN', 'Y', 'Yes', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_ADDOPTED_YN', 'N', 'No', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_ADDOPTED_YN', 'P', 'P?', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 3)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_APPENDIX', 'A', '(a)', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_APPENDIX', 'B', '(b)', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_APPENDIX', 'C', '(c)', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 3)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_APPENDIX', 'D', '(d)', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 4)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_APPENDIX', 'E', '(e)', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 5)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'HSG', 'HSG', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 27)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'NK', 'Unknown', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 35)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'OMBC', 'OMBC', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 32)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'NR', 'Network Rail', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 29)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'DTP', 'DTp', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 24)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'NWWA', 'NWWA', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 31)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'BWB', 'BWB', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 22)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'GMC', 'GMC', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 26)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'LE', 'Leisure', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 28)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'BR', 'BR', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 21)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'CEGB', 'CEGB', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'),23)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'PRI', 'Private', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 33)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'NROMBC', 'Network Rail/OMBC', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 30)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'TAM', 'Tameside', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 34) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_OWNER', 'EDU', 'Education', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 25)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_PARAPET_TYPE', 'P2', 'P2', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_PARAPET_TYPE', 'ST', 'Steel', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'BR', 'Bridge', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'CU', 'Culvert', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 3 ) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'TU', 'Tunnel', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 4)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'RE', 'Removed', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 5) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'FI', 'Filled', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 6)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'SW', 'Subway', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 7) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'FB', 'Footbridge', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 8) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_STRUCTURE_TYPE', 'NR', 'No Record', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 9) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_UNDER_OVER', 'UNDER', 'Under', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1)
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_UNDER_OVER', 'OVER', 'Over', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_YES_NO', 'Y', 'Yes', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_YES_NO', 'N', 'No', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_YES_NO_?', 'Y', 'Yes', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 1 ) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_YES_NO_?', 'N', 'No', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 2) 
/

Insert into NM_INV_ATTRI_LOOKUP_ALL
   (IAL_DOMAIN, IAL_VALUE, IAL_MEANING, IAL_START_DATE, IAL_SEQ)
 Values
   ('STRA_YES_NO_?', '?', 'Don''t Know', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 3) 
/

-- create metamodel

Insert into NM_INV_TYPES
   (NIT_INV_TYPE, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG, NIT_ELEC_DRAIN_CARR, NIT_CONTIGUOUS, 
   NIT_REPLACEABLE, NIT_EXCLUSIVE, NIT_CATEGORY, NIT_DESCR, NIT_LINEAR, 
   NIT_USE_XY, NIT_MULTIPLE_ALLOWED, NIT_END_LOC_ONLY, NIT_VIEW_NAME, 
   NIT_START_DATE, NIT_FLEX_ITEM_FLAG, NIT_ADMIN_TYPE, NIT_TOP, 
    NIT_UPDATE_ALLOWED)
 Values
   ('STRA', 'P', 'N', 'C', 'N', 
    'Y', 'N', 'I', 'Structures - Assets', 'N', 
    'Y', 'N', 'N', 'V_NM_STRA', 
    TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'NETW', 'N', 'Y')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
    ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB26', 'N', 2, 'N', 
    'VARCHAR2', 50, 'Appendix', 'STRA_APPENDIX', 
    'Y', 'APPENDIX', 
    'APPENDIX', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, 
    ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB27', 'N', 4, 'N', 
    'VARCHAR2', 50, 'Structure Type', 
    'N', 'STRUCTURE_TYPE', 
    'STRUCTURE_TYPE', TO_DATE('01/01/2001 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 6, 'N', 'MIXED')
/    

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
   ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
   ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
   ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB28', 'N', 5, 'N', 
    'VARCHAR2', 50, 'Adopted Highway (Y/N)', 'STRA_ADDOPTED_YN', 
    'Y', 'ADOPTED_HIGHWAY', 
    'ADOPTED_HIGHWAY', TO_DATE('01/01/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/    

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
   ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
   ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
   ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB29', 'N', 6, 'N', 
    'VARCHAR2', 50, 'Road Class', 
    'N', 'ROAD_CLASS', 
    'ROAD_CLASS', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN,
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB30', 'N', 11, 'N', 
    'VARCHAR2', 50, 'Street Guide', 
    'N', 'STREET_GUIDE', 
    'STREET_GUIDE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB31', 'N', 8, 'N', 
    'VARCHAR2', 50, 'OS Map Ref', 
    'N', 'OS_MAP_REF', 
    'OS_MAP_REF', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, 
    ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB32', 'N', 12, 'N', 
    'VARCHAR2', 50, 'Street Name', 
    'N', 'STREET_NAME', 
    'STREET_NAME', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 10, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB33', 'N', 13, 'N', 
    'VARCHAR2', 50, 'Town', 
    'N', 'TOWN', 
    'TOWN', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 10, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB34', 'N', 15, 'Y', 
    'VARCHAR2', 50, 'Owner / Highways Aurhority', 'STRA_OWNER', 
    'Y', 'OWNER_HA', 
    'OWNER_HA', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB35', 'N', 16, 'N', 
    'VARCHAR2', 50, 'Owner OMBC', 'STRA_YES_NO_?', 
    'Y', 'OWNER_OMBC', 
    'OWNER_OMBC', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 2, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB36', 'N', 17, 'N', 
    'VARCHAR2', 50, 'Span (metres)', 
    'N', 'SPAN_METRES', 
    'SPAN_METRES', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 4, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB37', 'N', 19, 'N', 
    'VARCHAR2', 50, 'H/way Over/Under Obstacle', 'STRA_UNDER_OVER', 
    'Y', 'OVER_UNDER_OBSTACLE', 
    'OVER_UNDER_OBSTACLE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 4, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB38', 'N', 20, 'N', 
    'VARCHAR2', 50, 'Obstacle', 
    'N', 'OBSTACLE', 
    'OBSTACLE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 10, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB39', 'N', 22, 'N', 
    'VARCHAR2', 50, 'Subsequent BCI Required', 'STRA_YES_NO', 
    'Y', 'SUBSEQUENT_BCI_REQUIRED', 
    'SUBSEQUENT_BCI_REQUIRED', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB40', 'N', 23, 'N', 
    'VARCHAR2', 50, 'Special Safety Inspection Req', 'STRA_YES_NO', 
    'Y', 'SSI_REQUIRED', 
    'SSI_REQUIRED', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 2, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
   ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
   ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
   ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB41', 'N', 25, 'N', 
    'VARCHAR2', 50, 'General Inspection Date', 
    'N', 'GENERAL_INSPECTION_DATE', 
    'GENERAL_INSPECTION_DATE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'N', 'N', 'Y', 5, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB42', 'N', 26, 'N', 
    'VARCHAR2', 50, 'P I Required', 'STRA_YES_NO', 
    'Y', 'P_I_REQUIRED', 
    'P_I_REQUIRED', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 2, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB43', 'N', 27, 'N', 
    'VARCHAR2', 50, 'Confined Space', 'STRA_YES_NO', 
    'Y', 'CONFINED_SPACE', 
    'CONFINED_SPACE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 1, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
   ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
   ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB44', 'N', 28, 'N', 
    'VARCHAR2', 50, 'Prin Inspection Date', 
    'N', 'PRIN_INSP_DATE', 
    'PRIN_INSP_DATE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'N', 'N', 'Y', 3, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_ID_DOMAIN, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, 
   ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  
   ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB45', 'N', 29, 'N', 
    'VARCHAR2', 50, 'Painting', 'STRA_YES_NO', 
    'Y', 'PAINTING', 
    'PAINTING', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_ID_DOMAIN, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, 
   ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  
   ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB46', 'N', 31, 'N', 
    'VARCHAR2', 50, 'Parapet Type', 'STRA_PARAPET_TYPE', 
    'Y', 'PARAPET_TYPE', 
    'PARAPET_TYPE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 2, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
   ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
   ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB47', 'N', 33, 'N', 
    'VARCHAR2', 50, 'Parapet Height', 
    'N', 'PARAPET_HEIGHT', 
    'PARAPET_HEIGHT', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 4, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
   ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
   ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB56', 'N', 3, 'Y', 
    'VARCHAR2', 200, 'Bridge Name', 
    'N', 'BRIDGE_NAME', 
    'BRIDGE_NAME', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 20, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
   ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
   ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
   ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
   ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB57', 'N', 7, 'N', 
    'VARCHAR2', 200, 'Location', 
    'N', 'LOCATION', 
    'LOCATION', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'N', 'N', 'Y', 10, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
    ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
    ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB58', 'N', 30, 'N', 
    'VARCHAR2', 200, 'Construction Type', 
    'N', 'CONSTRUCTION_TYPE', 
    'CONSTRUCTION_TYPE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 4, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
    ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
    ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_CHR_ATTRIB59', 'N', 32, 'N', 
    'VARCHAR2', 200, 'Parapet Material', 
    'N', 'PARAPET_MATERIAL', 
    'PARAPET_MATERIAL', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 5, 'N', 'MIXED')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
    ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE,
    ITA_QUERYABLE, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, 
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_DATE_ATTRIB86', 'N', 21, 'N', 
    'DATE', 7, 'Initial BCI Inspection Date', 
    'N', 'INITIAL_BCI_INSP_DATE', 
    'INITIAL_BCI_INSP_DATE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'DD-MON-YYYY', 'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, 
    ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, 
    ITA_QUERYABLE, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  
    ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_DATE_ATTRIB87', 'N', 24, 'N', 
    'DATE', 7, 'Second BCI Insption Date', 
    'N', 'SECOND_BCI_INSP_DATE', 
    'SECOND_BCI_INSP_DATE', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'DD-MON-YYYY', 'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, 
    ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_NUM_ATTRIB100', 'N', 1, 'Y', 
    'NUMBER', 22, 'Bridge Number', 
    'N', 'BRIDGE_NUMBER', 
    'BRIDGE_NUMBER', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 4, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_VALIDATE_YN, 
    ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_NUM_ATTRIB101', 'N', 14, 'N', 
    'NUMBER', 22, 'USRN', 
    'N', 'USRN', 
    'USRN', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_NUM_ATTRIB102', 'N', 18, 'N', 
    'NUMBER', 22, 'Number of Spans', 
    'N', 'NUM_SPANS', 
    'NUM_SPANS', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 3, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_X', 'N', 9, 'N', 
    'NUMBER', 22, 'Easting', 
    'N', 'EASTING', 
    'EASTING', TO_DATE('01/01/2001 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'N', 'N', 'Y', 6, 'N', 'UPPER')
/

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, 
    ITA_VALIDATE_YN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, 
    ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN,  ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('STRA', 'IIT_Y', 'N', 10, 'N', 
    'NUMBER', 22, 'Northing', 
    'N', 'NORTHING', 
    'NORTHING', TO_DATE('01/01/1901 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'N', 
    'N', 'N', 'Y', 6, 'N', 'UPPER')
/
    
    
