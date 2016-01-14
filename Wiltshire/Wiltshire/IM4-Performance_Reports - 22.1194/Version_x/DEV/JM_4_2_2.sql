--1A

select "Priority", Received, Completed,"% completed" from (
    select rownum sorter, a.* from (
		select case when grouping(PRIORITY) = 1 then 'Total' else priority end  as "Priority",
		sum(Received) Received,
		sum(Completed) Completed,
		trunc((avg(Completed)/avg(Received)*100),2) as "% completed"
		from
		(select --case when grouping(PRIORITY) = 1 then 'Total' else priority end  as "Priority",
			Priority,
			sum(Rec) as Received ,
			sum(Comp) as Completed 
			--trunc((comp/Rec*100),2) as "% completed"
			FROM
				(select 
				case      when DR.PRIORITY IN('1','1P') then 'P1'
						   when DR.PRIORITY = '2' then 'P2'
						   when DR.PRIORITY = '3' then 'P3'
						   when DR.PRIORITY = '4' then 'P4'
						  end AS Priority,
				--SUM(CASE WHEN dr.defect_status ='INSTRUCTED' 
				-- THEN 1 ELSE 0 END) as Rec,
				count(dr.defect_id) AS Rec,
				 SUM(CASE WHEN dr.defect_status='COMPLETED' 
				 THEN 1 ELSE 0 END) AS Comp
				 from IMF_MAI_DEFECT_REPAIRS DR,
				IMF_MAI_INSPECTIONS INS,
				IMF_NET_NETWORK_MEMBERS NM,
				IMF_MAI_WORK_ORDERS WO
				where 1=1
				and DR.INSPECTION_ID=INS.INSPECTION_ID
				AND DR.network_element_id =NM.child_element_id
				AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
				AND INS.initiation_type NOT IN('CMT')
				and DR.PRIORITY IN('1P','1','2','3','4')
				and nm.parent_group_type = 'COMA'
				And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,'*','%')
				and wo.date_instructed between :P6_PARAM3 and :P6_PARAM4 
				group by DR.PRIORITY)
				--group by rollup(PRIORITY)
				group by PRIORITY)
		group by rollup(PRIORITY)) a
    --
    UNION
    --
    select 1000  sorter, a.* from (
		select 
		'Others' as Priority,
		sum(Received) Received,
		sum(Completed) Completed,
		trunc((avg(Completed)/avg(Received)*100),2) as "% completed"
		from
		(
			select dr.PRIORITY as priority,
			count(dr.defect_id) AS Received,
			 SUM(CASE WHEN dr.defect_status='COMPLETED' 
			 THEN 1 ELSE 0 END) AS Completed
			from IMF_MAI_DEFECT_REPAIRS DR,
			IMF_MAI_INSPECTIONS INS,
			IMF_NET_NETWORK_MEMBERS NM,
			IMF_MAI_WORK_ORDERS WO
			where 1=1
			and DR.INSPECTION_ID=INS.INSPECTION_ID
			AND DR.network_element_id =NM.child_element_id
			AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
			AND INS.initiation_type NOT IN('CMT')
			and DR.PRIORITY IN('5','6','7')
			and nm.parent_group_type = 'COMA'
			And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,'*','%')
			and wo.date_instructed between :P6_PARAM3 and :P6_PARAM4 
		group by dr.PRIORITY)
    ) a
)


----------------------------------
--4,2,2 1B

select b.FF "Find and Fix", nvl("Received",0) "Received", nvl("Completed",0) "Completed", nvl("% completed",0) "% completed" from (
select case when DEFECT_TYPE='POTH' then 'Potholes'  end as FF,
Rec as "Received",
comp as "Completed",
trunc((comp/Rec*100),2) as "% completed"
from(
select
dr.defect_type as defect_type,
--count(dr.defect_id) as cnt
SUM(CASE WHEN INS.initiation_type ='CMT' 
 THEN 1 ELSE 0 END) AS Rec,
 SUM(CASE WHEN defect_status='COMPLETED' 
  and  INS.initiation_type ='CMT'
  THEN 1 ELSE 0 END) AS Comp
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type IN('CMT')
and DR.DEFECT_TYPE='POTH'
and nm.parent_group_type = 'COMA'
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,'*','%')
group by DR.DEFECT_TYPE)) a
, (select  'Potholes' FF from dual) b
where a.FF(+) = b.FF
union
select 'All Defect Types' as "Find and Fix",
sum(Rec) as "Received",
sum(comp) as "Completed",
trunc((avg(comp)/avg(Rec)*100),2) as "% completed"
from(
select
dr.defect_type as defect_type,
--count(dr.defect_id) as cnt
SUM(CASE WHEN INS.initiation_type ='CMT' 
 THEN 1 ELSE 0 END) AS Rec,
 SUM(CASE WHEN defect_status='COMPLETED' 
  and  INS.initiation_type ='CMT'
  THEN 1 ELSE 0 END) AS Comp
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type IN('CMT')
and DR.DEFECT_TYPE<>'POTH'
and nm.parent_group_type = 'COMA'
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,'*','%')
group by DR.DEFECT_TYPE)
order by 1 desc
