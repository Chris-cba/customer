'NON'
 '1'
'1 (ECO)'
 '2M'
 '2H'
 '2L'

 
 
select 'javascript:showWOWTDrillDown(512,null, ''9'', ''P9_DAYS'', '||''''|| dr.range_value ||''''||' , ''P9_PRIORITY'', '''||defect_priority||''', null,null, null,null,null,null);' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, defect_priority, count(*) CNT 
        from  X_WO_TFL_WORK_TRAY_WOW002 
        where  defect_priority = '2M'
        group by  range_value, defect_priority)x
, X_LOHAC_DateRANGE_WOWT dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter