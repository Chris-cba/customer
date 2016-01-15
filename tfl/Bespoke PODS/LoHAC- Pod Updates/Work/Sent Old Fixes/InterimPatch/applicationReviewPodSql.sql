SET DEFINE OFF;
--
delete from im_pod_sql where ips_ip_id = 23;commit;
--
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1200, 23, 40, 'select link, range_value, tot "Rej_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REVUPD''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )', 'Awaiting Review – Updated Application', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1201, 23, 50, 'select link, range_value, tot "Awaiting Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REVCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )', 'Awaiting Review – New Comments', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (8, 23, 10, 'select link, range_value, tot "Awaiting Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REV''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )', 'Awaiting Review', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (16, 23, 30, 'select link, range_value, tot "Rej_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''REJCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )', 'Rejct Awaiting Com Review', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (17, 23, 20, 'select link, range_value, tot "Appr_Awaiting Comm Review" from (
        With
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||WOR_CHAR_ATTRIB110||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot
       from
       (Select sum(reason) total, range_value, WOR_CHAR_ATTRIB110
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  WOR_CHAR_ATTRIB110 = ''APPCOMM''
       group by  WOR_CHAR_ATTRIB110, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       order by sorter
       )
	   ', 'Apprvd Awaiting Com Review', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1220, 23, 60, 'select link, range_value, tot  from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''APP''     
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )	', 'Approved', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1221, 23, 70, 'select link, range_value, tot  from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''REJ''     
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )	', 'Rejected', 
    'Bar', 'Box');
Insert into HIGHWAYS.IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1222, 23, 80, 'select link, range_value, tot  from (
        With 
		Date_range as (
			select * from X_LOHAC_DateRANGE_WK
                )
       select  
        ''javascript:showWOWTDrillDown(512,null, ''''40'''', ''''P40_DAYS'''', ''||''''''''||dr.range_value||''''''''||'' , ''''P40_PRIORITY'''',''|| ''''''''||code||'''''', null,null, null,null,null,null);''
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  code = ''INTREJ''     
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )	', 'Interim Rejected', 
    'Bar', 'Box');
COMMIT;
