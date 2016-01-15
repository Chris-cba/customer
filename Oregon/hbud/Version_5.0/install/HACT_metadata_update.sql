Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, ITA_FORMAT, ITA_FLD_LENGTH, ITA_SCRN_TEXT, ITA_ID_DOMAIN, ITA_VALIDATE_YN, ITA_VIEW_ATTRI, ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_QUERYABLE, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_DISPLAYED, ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('HACT', 'IIT_CHR_ATTRIB34', 'N', 10, 'N', 
    'VARCHAR2', 1, 'Report Column', 'YES_NO', 
    'Y', 'REPORT_COLUMN', 
    'REPORT_COLUMN', TO_DATE('09/02/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), 'Y', 
    'N', 'N', TO_DATE('09/02/2010 13:13:08', 'MM/DD/YYYY HH24:MI:SS'), TO_DATE('09/02/2010 13:13:08', 'MM/DD/YYYY HH24:MI:SS'), 'TRANSINFO', 'TRANSINFO', 'Y', 2, 'N', 'UPPER');
COMMIT;

exec nm3inv.create_view('HACT');

DECLARE 

CURSOR get_data IS
select distinct(feature_type) from v_nm_hact;

cursor get_data2(p_feature_type VARCHAR2) is
select * from v_nm_hact
where feature_type = p_feature_type
and rownum = 1;

BEGIN

FOR i in get_data LOOP
   
   FOR i2 in get_data2(i.feature_type) LOOP
   
      UPDATE nm_inv_items_all
	  set IIT_CHR_ATTRIB34 = 'Y'
	  where iit_primary_key = i2.iit_primary_key;
   
   END LOOP;
    
END LOOP;
   commit;
   
   update nm_inv_items_all
   set IIT_CHR_ATTRIB34 = 'N'
   where IIT_CHR_ATTRIB26 = '138';
    

commit;
	
END;
/
