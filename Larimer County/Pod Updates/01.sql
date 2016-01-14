select distinct z.ne_group as ne_group,
'<a href="javascript:doDrillDown(''IM90231'','''  ||z.ne_group || ''',''' || null || ''',''' || null  || ''');"><font face="verdana" color="blue"><u>'|| a.ne_descr ||'</u></font></a>' "Route"
from nm_elements a, nm_members, nm_elements z 
where nm_ne_id_of = z.ne_id and  nm_ne_id_in = a.ne_id and z.ne_type='S'
and a.ne_nt_Type='CRTE'
and a.ne_type='G'
order by z.ne_group

  
  
  :P6_PARAM1
  
  
select b.ne_group ne_group,
'<a href="javascript:doDrillDown(''IM90231'','''  ||b.ne_group || ''',''' || null || ''',''' || null  || ''');"><font face="verdana" color="blue"><u>'|| a.ne_descr ||'</u></font></a>' Route
from nm_elements a, (select distinct nm_ne_id_in, ne_group from nm_members, nm_elements where nm_ne_id_of = ne_id and ne_type='S') b
where 1=1
and a.ne_id = b.nm_ne_id_in
and a.ne_nt_Type='CRTE'
and a.ne_type='G'
order by b.ne_group


--- OLD incorrect

select distinct * from (
Select  ne_group,
  '<a href="javascript:doDrillDown(''IM90231'','''
  || ne_group || ''',''' || null || ''',''' || null  || ''');"><font face="verdana" color="blue"><u>'|| ne_descr ||'</u></font></a>' "Route"
  from nm_elements a, road_network_sdo_table
	where ne_id = road_network_sdo_id(+)
	and ne_type='S'
	order by ne_descr
  )