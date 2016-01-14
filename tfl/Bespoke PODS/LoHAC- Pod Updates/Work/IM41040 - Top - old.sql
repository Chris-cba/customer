--Approved

Select  'javascript:doDrillDown( ''IM41041'', '''||eot||''', ''Approved'');' as link, sq.*
From (
--
         Select  'Approved' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Approved')         
         group by "WO EXTENSION OF TIME STATUS" 
		 union
         select 'Approved'  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Approved')
         ) sq
		 
		 
--Conditional


Select  'javascript:doDrillDown( ''IM41041'', '''||eot||''', ''Conditional'');' as link, sq.*
From (
--
         Select  'Conditional' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Conditional')         
         group by "WO EXTENSION OF TIME STATUS" 
		 union
         select 'Conditional'  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Conditional')
         ) sq



--Rejected


Select  'javascript:doDrillDown( ''IM41041'', '''||eot||''', ''Rejected'');' as link, sq.*
From (
--
         Select  'Rejected' EOT, count("WO EXTENSION OF TIME STATUS") count
         from( select * from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Rejected')         
         group by "WO EXTENSION OF TIME STATUS" 
		 union
         select 'Rejected'  EOT, 0 count from dual where not exists (select 1 from c_pod_eot_updated where "WO EXTENSION OF TIME STATUS" = 'Rejected')
         ) sq


--EOP

Select  'javascript:doDrillDown( ''IM41041a'', '''||eop||''', ''EOP'');' as link, sq.*
From (
--
         Select  'EOP' EOP, count("REQUESTS") count
         from( select * from c_pod_eoP_updated)         
         group by "REQUESTS" 
		 union
         select 'EOP'  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated)
         ) sq
		 
		 
--EOP, NO bud

Select  'javascript:doDrillDown( ''IM41041b'', '''||eop||''', ''EOP'');' as link, sq.*
From (
--
         Select  'EOP' EOP, count("REQUESTS") count
         from( select * from c_pod_eoP_updated_nobud)         
         group by "REQUESTS" 
		 union
         select 'EOP'  EOP, 0 count from dual where not exists (select 1 from c_pod_eop_updated_nobud)
         ) sq
