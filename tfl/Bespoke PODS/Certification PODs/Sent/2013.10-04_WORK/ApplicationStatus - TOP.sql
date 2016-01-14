select link, range_value, tot "Approved" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select  
        'javascript:showWOWTDrillDown(512,null, ''60'', ''P10_DAYS'', '||''''||dr.range_value||''''||' , ''P10_PRIORITY'','|| ''''||haud_new_value||''', null,null, null,null,null,null);'
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = 'APP'     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )
-----------------------	   

select link, range_value, tot "Rejected" from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select  
        'javascript:showWOWTDrillDown(512,null, ''60'', ''P10_DAYS'', '||''''||dr.range_value||''''||' , ''P10_PRIORITY'','|| ''''||haud_new_value||''', null,null, null,null,null,null);'
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  haud_new_value = 'REJ'     
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value       
       order by sorter
       )
	   
	   -----------------------	   

select link, range_value, tot  from (
        With Date_range as(
		select * from X_LOHAC_DateRANGE_WK
                )
       select  
        'javascript:showWOWTDrillDown(512,null, ''60'', ''P60_DAYS'', '||''''||dr.range_value||''''||' ,  ''P60_PRIORITY'','|| ''''||haud_new_value||''', null,null, null,null,null,null);'
            AS link,
         dr.range_value,
         NVL (total, 0) tot 
       from 
       (Select sum(reason) total, range_value, haud_new_value
       from  X_LOHAC_IM_APPLICATION_STATUS
       where  1=1   
       group by  haud_new_value, range_value) mn,
       Date_range dr
       where mn.range_value(+) = dr.range_value  
	   and (haud_new_value is null or haud_new_value = 'REV'      )
       order by sorter
       )
	   
	   
	   
	REV
	REVUPD
	REVCOMM
	APPCOMM
	APP
	REJCOMM
	REJ
	INTREJ	   
	 'APPUN'