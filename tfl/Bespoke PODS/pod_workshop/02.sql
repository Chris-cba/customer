 Select 
'javascript:showWOWTDrillDown(512,null, ''500'', ''P500_DAYS'', '||''''||mon||''''||' , ''P500_PRIORITY'','|| ''''||wor_char_attrib64||''', null,null, null,null,null,null);'
--'javascript:doDrillDown(''WS_JM02_DD1'','''||mon||''', '''||wor_char_attrib64||''');' as link
, mon, cnt from (
 select wor_char_attrib64,a.sorter, a.mon, nvl(cnt,0) cnt from (
 select  wor_char_attrib64,sorter, mon, count(*) cnt from (
 Select wor_char_attrib64, sorter, mon from 
		 (select 
			0 sorter
			, 'MAR' mon
			, to_date('01-MAR-2013') st_date
			, last_day('01-MAR-2013') end_date
			from dual
		 union
		  select 
			1 sorter
			, 'APR' mon
			, to_date('01-APR-2013') st_date
			, last_day('01-APR-2013') end_date
			from dual
			union
			 select 
			2 sorter
			, 'MAY' mon
			, to_date('01-MAY-2013') st_date
			, last_day('01-MAY-2013') end_date
			from dual)a,
			work_orders b
			where wor_date_raised between a.st_date and a.end_date
			and wor_char_attrib64 = 'INSTRUCTED'  -- ACTIONED, COMPLETED, DRAFT, PART COMP
			)    
    group by sorter, mon, wor_char_attrib64
    order by 1 ) b,
				 (select 
				0 sorter
				, 'MAR' mon
				, to_date('01-MAR-2013') st_date
				, last_day('01-MAR-2013') end_date
				from dual
			 union
			  select 
				1 sorter
				, 'APR' mon
				, to_date('01-APR-2013') st_date
				, last_day('01-APR-2013') end_date
				from dual
				union
				 select 
				2 sorter
				, 'MAY' mon
				, to_date('01-MAY-2013') st_date
				, last_day('01-MAY-2013') end_date
				from dual) a
    where 
    a.sorter = b.sorter(+)
    order by sorter
	)
	
	
	
	
	
       select 
    '<p title="Click for forms"  id="'||WOR_works_order_no||'"  onmouseover="showWOLDetails(this);">'||  WOR_works_order_no||'</p>' WORKS_ORDER_NUMBER
    ,decode( DECODE (mai_sdo_util.wo_has_shape (hig.get_sysopt ('SDOWOLNTH'), wor.WOR_works_order_no), 'TRUE', 'Y','N'),
            'N',
        '<img width=24 height=24 src="/' || '&FRAMEWORK_DIR.' || '/images/grey_globe.png" title="No Location">'
        ,'<a href="javascript:showWODefOnMap('''||WOR_works_order_no||''',''~'');" ><img width=24 height=24 src="/' || '&FRAMEWORK_DIR.' || '/images/globe_64.gif" title="Find on Map"></a>') map
    ,decode(im_framework.has_doc(WOR_works_order_no,'WORK_ORDERS'),0,
        '<img width=24 height=24 src="/' || '&FRAMEWORK_DIR.' || '/images/mfclosed.gif" title="No Documents">'
        ,'<a href="javascript:showWODocAssocs('''||WOR_works_order_no||''',&APP_ID.,&APP_SESSION.,''WORK_ORDERS'')" ><img width=24 height=24 src="/' || '&FRAMEWORK_DIR.' || '/images/mfopen.gif" title="Show Documents"></a>') DOCS
    ,(select ial_meaning from nm_inv_attri_lookup where ial_domain = 'INVOICE_STATUS' and ial_value = wor_char_attrib110) INVOICE_STATUS
    ,wor_char_attrib111 INVOICE_STATUS_DESCRIPTION
    ,WOR_DESCR
    ,WOR_DATE_RAISED
        ,WOR_CHAR_ATTRIB115    "Correct area of work "
        ,WOR_CHAR_ATTRIB116    "Quality of Work OK"
        ,WOR_CHAR_ATTRIB70    "Correct BOQ_Uplifts" 
        ,WOR_CHAR_ATTRIB113    "Before After Photos Present"
        ,WOR_CHAR_ATTRIB114 "Certification Comments"
--,(select hus_name from hig_audits, hig_users where haud_pk_id = haud.haud_pk_id and haud_timestamp = haud.haud_timestamp and haud_new_value = haud.haud_new_value and haud_attribute_name = haud.haud_attribute_name and  rownum =1) Reviewed_By
,  (select HUS_NAME from hig_users where hus_user_id = WOR_NUM_ATTRIB04 )  Reviewed_By
        , WOR_works_order_no wor_number
		, 'Edit' rec_edit
 from 
work_orders wor
where 1=1
and wor_date_raised between to_date('01-' ||:P500_DAYS ||'-2013')and last_day('01-' ||:P500_DAYS ||'-2013')
and wor_char_attrib64 = :P500_PRIORITY  -- ACTIONED, COMPLETED, DRAFT, PART COMP




