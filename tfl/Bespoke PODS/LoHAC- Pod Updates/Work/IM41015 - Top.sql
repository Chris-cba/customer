Select
 'javascript:doDrillDown(''IM41016a'','''||range_value||''', '''||'INITIAL'||''');' as link,
range_value days,
SUM(NVL(requests,0)) as "INITIAL"
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = 'INITIAL'
and "EOT DATE REQUESTED"(+) is not null --WOR_CHAR_ATTRIB121
group by range_value
order by (decode(range_value,'Today',1,'1-6',2,'7-30',3,'31-60',4,'61-90',5))





Select
 'javascript:doDrillDown(''IM41016b'','''||range_value||''', '''||'REPEAT'||''');' as link,
range_value days,
SUM(NVL(requests,0)) Repeat
from c_pod_eot_requests,pod_day_range
where days(+)=range_value
and REQ(+) = 'REPEAT'
and "EOT DATE REQUESTED"(+) is not null --WOR_CHAR_ATTRIB121 
group by range_value
order by (decode(range_value,'Today',1,'1-6',2,'7-30',3,'31-60',4,'61-90',5))




---New----

Select
 'javascript:doDrillDown(''IM41016c'','''||range_value||''', '''||'EOP'||''');' as link,
range_value days,
SUM(NVL(requests,0)) Extension_of_Price_Requested
from c_pod_eop_requests,pod_day_range
where days(+)=range_value
and work_order_line_status(+) <> 'INSTRUCTED'
and "DATE PRICE EXTENSION REQUESTED"(+) is not null --WOR_DATE_ATTRIB129
group by range_value
order by (decode(range_value,'Today',1,'1-6',2,'7-30',3,'31-60',4,'61-90',5))

--New No Budget--

Select
 'javascript:doDrillDown(''IM41016d'','''||range_value||''', '''||'EOP'||''');' as link,
range_value days,
SUM(NVL(requests,0)) Extension_of_Price_Requested
from c_pod_eop_requests_nobud,pod_day_range
where days(+)=range_value
and "DATE PRICE EXTENSION REQUESTED"(+) is not null --WOR_DATE_ATTRIB129
group by range_value
order by (decode(range_value,'Today',1,'1-6',2,'7-30',3,'31-60',4,'61-90',5))
;