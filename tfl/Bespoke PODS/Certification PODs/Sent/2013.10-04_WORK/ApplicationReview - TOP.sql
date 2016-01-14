
select link, range_value, tot  from (
        With 
        Date_range as (
            select * from X_LOHAC_DateRANGE_WK
                )
       select  
        'javascript:showWOWTDrillDown(512,null, ''40'', ''P40_DAYS'', '||''''||dr.range_value||''''||' , ''P40_PRIORITY'','|| ''''||code||''', null,null, null,null,null,null);'
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, code
       from  X_LOHAC_IM_APPLICATION_REVEIW
       where  1=1            
       group by  code, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value
       and (code is null or code = 'REJCOMM')       
       order by sorter
       )    	   
	   
	   
	   
			'REV'
			REVUPD
			REVCOMM
			APPCOMM
			APP
			REJCOMM
			REJ
			INTREJ
			'APPUN'
	   