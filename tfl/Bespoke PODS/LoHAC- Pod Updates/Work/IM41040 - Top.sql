Select Link, item, cnt from (
--
 Select 0 Sorter,
         'javascript:doDrillDown( ''IM41041'', '''||b.c||''', ''N/A'');' as link
         , b.c item
         ,nvl(cnt,0) cnt
         from
         (
         select "WO EXTENSION OF TIME STATUS" eot
         ,count("WO EXTENSION OF TIME STATUS") cnt
         from c_pod_eot_updated
         group by "WO EXTENSION OF TIME STATUS"
         order by "WO EXTENSION OF TIME STATUS"
         ) a,
         (Select 'Conditional' c from dual union Select 'Rejected' c from dual union Select 'Approved' c from dual) b
         where 1=1
         and eot(+) = b.c
--
UNION
--EOP
Select  1 sorter, 'javascript:doDrillDown( ''IM41041a'', '''||eop||''', ''EOP'');' as link, EOP item, cnt
From (
--
         Select  'EOP' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated)         
         group by "REQUESTS" 
         union
         select 'EOP'  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated)
         ) sq
--
UNION         
--EOP, NO bud
Select  2 sorter, 'javascript:doDrillDown( ''IM41041b'', '''||eop||''', ''TOR'');' as link, EOP item, cnt
From (
--
         Select  'TOR' EOP, count("REQUESTS") cnt
         from( select * from c_pod_eoP_updated_nobud)         
         group by "REQUESTS" 
         union
         select 'TOR'  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated_nobud)
         ) sq
 --
) order by sorter