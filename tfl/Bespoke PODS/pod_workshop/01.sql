Select 
'javascript:doDrillDown(''WS_JMO1_DD1'','''||wor_char_attrib64||''', '''||''||''');' as link
, wor_char_attrib64 
, cnt
from(
    Select wor_char_attrib64, count(*) cnt from work_orders
     where wor_char_attrib64 is not null and wor_date_raised >= '01-APR-2013'
     group by wor_char_attrib64
     order by wor_char_attrib64
 )
 
 
 Select 
FMTH
,'<a href="javascript:doDrillDown(''WS_JM01_DD2'','''  || mth || ''',''' || null || ''',''' || null  || ''');">' || CNT ||'</a>' Item_count
from
(
Select to_char(wor_date_raised, 'MM') mth,to_char(wor_date_raised, 'MONTH') fmth, count(*) cnt from work_orders a 
where wor_char_attrib64 = :P6_PARAM1
and wor_date_raised >= '01-MAR-2013'
group by to_char(wor_date_raised, 'MM'), to_char(wor_date_raised, 'MONTH')
order by MTH
)


----------

Select 
*
from
(
Select * from work_orders a 
where wor_char_attrib64 = :P6_PARAM1
and to_char(wor_date_raised, 'MM') = :P6_PARAM2
order by wor_date_raised
)


Select 
WOR_WORKS_ORDER_NO
,WOR_DATE_RAISED
,WOR_DESCR
from
(
Select *  from work_orders a 
where wor_char_attrib64 = :P6_PARAM1
and wor_date_raised between add_months('01-JAN-2013', to_number(:P6_PARAM2) -1) and last_day( add_months('01-JAN-2013', to_number(:P6_PARAM2) -1))
order by wor_date_raised
)
