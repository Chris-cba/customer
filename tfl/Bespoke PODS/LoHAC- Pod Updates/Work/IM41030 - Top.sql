--1 (ECO)
select 'javascript:doDrillDown(''IM41031'','''||days2||''',  '''||'1 (ECO)'||''');' as link,days2 days,nvl("1 ECO",0) "1 ECO" from
(select days,sum(priority) "1 ECO"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then '1'
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5'
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60'
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = '1 (ECO)'
)
group by days
order by days),
(select days2 from
(select '1' as days2 from dual) union (select '2-5' as days2 from dual)
union (select '6-60' as days2 from dual) union (select '60-90' as days2 from dual))
where days(+)=days2
order by days2


--1
select 'javascript:doDrillDown(''IM41031'','''||days2||''',  '''||'1'||''');' as link,days2 days,nvl("1",0) "1" from
(select days,sum(priority) "1"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then '1'
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5'
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60'
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = '1'
)
group by days
order by days),
(select days2 from
(select '1' as days2 from dual) union (select '2-5' as days2 from dual)
union (select '6-60' as days2 from dual) union (select '60-90' as days2 from dual))
where days(+)=days2
order by days2

--2H
select 'javascript:doDrillDown( ''IM41031'','''||days2||''', '''||'2H'||''');' as link,days2 days,nvl("2H",0) "2H" from
(select days,sum(priority) "2H"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then '1'
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5'
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60'
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = '2H'
)
group by days
order by days),
(select days2 from
(select '1' as days2 from dual) union (select '2-5' as days2 from dual)
union (select '6-60' as days2 from dual) union (select '60-90' as days2 from dual))
where days(+)=days2
order by days2


--2M
select 'javascript:doDrillDown( ''IM41031'', '''||days2||''', '''||'2M'||''');' as link,days2 days,nvl("2M",0) "2M" from
(select days,sum(priority) "2M"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then '1'
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5'
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60'
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = '2M'
)
group by days
order by days),
(select days2 from
(select '1' as days2 from dual) union (select '2-5' as days2 from dual)
union (select '6-60' as days2 from dual) union (select '60-90' as days2 from dual))
where days(+)=days2
order by days2


--2L
select 'javascript:doDrillDown( ''IM41031'', '''||days2||''', '''||'2L'||''');' as link,days2 days,nvl("2L",0) "2L" from
(select days,sum(priority) "2L"
from
(select (case when trunc(sysdate-date_inspected) <= 1 then '1'
when trunc(sysdate-date_inspected) > 1 and trunc(sysdate-date_inspected) <= 5 then '2-5'
when trunc(sysdate-date_inspected) > 5 and trunc(sysdate-date_inspected) <= 60 then '6-60'
when trunc(sysdate-date_inspected) > 60 and trunc(sysdate-date_inspected) <= 90 then '60-90' end) days
,1 priority from x_IM_MAI_DEFECTS a
where defect_status in ('AVAILABLE','INSTRUCTED')
and works_order_number is null
and activity_code != 'PU'
and priority = '2L'
)
group by days
order by days),
(select days2 from
(select '1' as days2 from dual) union (select '2-5' as days2 from dual)
union (select '6-60' as days2 from dual) union (select '60-90' as days2 from dual))
where days(+)=days2
order by days2