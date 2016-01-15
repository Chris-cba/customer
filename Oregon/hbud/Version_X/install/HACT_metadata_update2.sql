delete from  NM_INV_TYPE_ATTRIBS_ALL where ita_inv_type = 'HACT' and ITA_ATTRIB_NAME = 'IIT_CHR_ATTRIB67';

Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT,  ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('HACT', 'IIT_CHR_ATTRIB67', 'N', 11, 'N', 
    'VARCHAR2', 500, 'XSP_VALUES', 
    'Y', 'XSP_VALUES', 
    'XSP_VALUES', TO_DATE('09/02/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', 'Y', 2, 'N', 'UPPER');
    
COMMIT;

exec nm3inv.create_view('HACT');

 

update nm_inv_items set IIT_CHR_ATTRIB67 = ' 
"LT1D",
"LT2I",
"LN1D",
"RT2D",
"LN3I",
"RT1I",
"LN3D",
"RT1D",
"LN4D",
"LN6I",
"LN2D",
"LN2I",
"LT2D",
"RT2I",
"LN5D",
"LN1I",
"LN4I",
"LT1I",
"LN5I"'
where iit_ne_id in (
select iit_ne_id from v_nm_hact
where calculation_type = 'LENGTH'
and asset_type = 'RDGM'
);


update nm_inv_items set IIT_CHR_ATTRIB67 = ' 
"OS1I",
"IS1I",
"IS2I",
"OS1D",
"IS1D",
"OS2D",
"OS2I",
"IS2D"
'
where iit_ne_id in (
select iit_ne_id from v_nm_hact
where calculation_type = 'LENGTH'
and asset_type = 'RDGM'
and feature_type = 'PAVED SHOULDERS (MILES)'
);

commit;


--v_nm_hact
	

