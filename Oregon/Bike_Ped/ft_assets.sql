-- create FT assets for URBN

-- remove them if they exist

delete nm_inv_type_roles where
itr_inv_type in  ('URBN');

delete nm_inv_type_attribs_all where
ita_inv_type in  ('URBN');

delete nm_inv_nw_all where 
NIN_NIT_INV_CODE in ('URBN');

delete nm_inv_types_all where 
nit_inv_type in ('URBN');


-- create FT asset types

-- create views
     
CREATE OR REPLACE VIEW xODOT_URBN_FT     
AS
   SELECT
   NE_ID ft_pk_col,
   NE_UNIQUE,
   URBAN_AREA,
   SMALL_URBAN
     FROM V_NM_URBN_URBN_NT
;
 

  

--create asset headers

INSERT INTO NM_INV_TYPES_ALL ( NIT_INV_TYPE, NIT_PNT_OR_CONT, NIT_X_SECT_ALLOW_FLAG,
NIT_ELEC_DRAIN_CARR, NIT_CONTIGUOUS, NIT_REPLACEABLE, NIT_EXCLUSIVE, NIT_CATEGORY, NIT_DESCR,
NIT_LINEAR, NIT_USE_XY, NIT_MULTIPLE_ALLOWED, NIT_END_LOC_ONLY, NIT_SCREEN_SEQ, NIT_VIEW_NAME,
NIT_START_DATE, NIT_END_DATE, NIT_SHORT_DESCR, NIT_FLEX_ITEM_FLAG, NIT_TABLE_NAME,
NIT_LR_NE_COLUMN_NAME, NIT_LR_ST_CHAIN, NIT_LR_END_CHAIN, NIT_ADMIN_TYPE, NIT_ICON_NAME, NIT_TOP,
NIT_FOREIGN_PK_COLUMN, NIT_UPDATE_ALLOWED  ) VALUES ( 
'URBN', 'C', 'N', 'C', 'Y', 'Y', 'Y', 'F', 'URBN for reporting', 'N', 'N', 'Y', 'N', NULL, 'XODOT_URBN_FT'
,  TO_Date( '01/01/1901 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, NULL, 'N', 'XODOT_URBN_FT'
, null, null, null, 'ASST', NULL, 'N', 'FT_PK_COL', 'Y'); 


-- now insert the cols

delete from NM_INV_TYPE_ATTRIBS where ita_inv_type in ('URBN');

INSERT INTO NM_INV_TYPE_ATTRIBS( ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB,
ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT,
ITA_ID_DOMAIN, ITA_VALIDATE_YN,  ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME,
ITA_START_DATE, ITA_QUERYABLE, 
ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH )
select 
nit_inv_type
, column_name
, 'N'
, column_id
, 'N'
, DATA_TYPE
, DATA_LENGTH
,DATA_precision
, column_name
, null
, 'N'
 , column_name, column_name
 , '01-JAN-1975'
 , 'N'
 , 'N', 'N', 'N', 10
from user_tab_cols, NM_INV_TYPES_ALL
where table_name = nit_table_name
and nit_inv_type in ('URBN')
and  column_name not in ('FT_PK_COL',
   'NM_NE_ID_OF',
   'NM_BEGIN_MP',
   'NM_END_MP');

-- insert roles

delete from NM_INV_TYPE_ROLES where ITR_INV_TYPE in ('URBN');

INSERT INTO NM_INV_TYPE_ROLES ( ITR_INV_TYPE, ITR_HRO_ROLE, ITR_MODE )
select  
nit_inv_type, 'HIG_USER', 'NORMAL'
from NM_INV_TYPES_ALL
where  nit_inv_type in ('URBN');

 
-- net asscocs

INSERT INTO NM_INV_NW_all (NIN_NW_TYPE, NIN_NIT_INV_CODE, NIN_LOC_MANDATORY, NIN_START_DATE)
select  
'SEGM', nit_inv_type, 'N', '01-JAN-1901'
from NM_INV_TYPES_ALL
where  nit_inv_type in ('URBN');

commit;
