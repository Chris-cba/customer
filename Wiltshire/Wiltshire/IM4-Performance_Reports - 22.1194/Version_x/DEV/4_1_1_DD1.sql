/*--------------------------------------------------------------------------
IM_4_1_1_DD1_1A
Community Area: &P6_PARAM2. for &P6_PARAM3.
% Completed against target time by defect type
---------------------------------------------------------------------------*/
select ACTIVITY_DESCRIPTION as "Topic",
trunc(100*(completed_on_time/(completed_on_time+completed_late+Not_completed_and_late)),2) "% Completed against target",
Issued_to_BBLP as "Issued to BBLP",
Number_Completed as "Number Completed"
from
(
select DR.ACTIVITY_DESCRIPTION as ACTIVITY_DESCRIPTION,
sum(DR.DEFECT_ID),
--
sum (case when  defect_status='COMPLETED' and trunc(DEFECT_DATE_COMPLETED) >= trunc(to_date(:P6_PARAM3,'DD-MM-RRRR')) And trunc(DEFECT_DATE_COMPLETED) <= trunc(date_due) then 1 else 0 end) completed_on_time
--
,
sum (case when  defect_status='COMPLETED' and trunc(DEFECT_DATE_COMPLETED) >= trunc(to_date(:P6_PARAM3,'DD-MM-RRRR')) And trunc(DEFECT_DATE_COMPLETED) > trunc(date_due) then 1 else 0 end) completed_late
,
sum (case when  defect_status<>'COMPLETED' and trunc(DATE_DUE) < trunc(sysdate) then 1 else 0 end) Not_completed_and_late
,
SUM(CASE WHEN dr.defect_status='INSTRUCTED' 
and trunc(date_instructed) >= trunc(to_date(:P6_PARAM3,'DD-MM-RRRR')) 
 THEN 1 ELSE 0 END) 
 AS Issued_to_BBLP,
--
SUM(CASE WHEN defect_status='COMPLETED' 
and trunc(DEFECT_DATE_COMPLETED) >= trunc(to_date(:P6_PARAM3,'DD-MM-RRRR')) 
 THEN 1 ELSE 0 END) 
 AS Number_Completed
--
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN('CMT')
and nm.parent_group_type = 'COMA'
And NM.PARENT_ELEMENT_REFERENCE like :P6_PARAM1
And DR.Activity_code in ('DP', 'AF', 'PL', 'FP', 'GR', 'SL', 'FT')
group by ACTIVITY_CODE,ACTIVITY_DESCRIPTION
)
/*--------------------------------------------------------------------------
IM_4_1_1_DD1_1B
Title : Community Area: &P6_PARAM2. for &P6_PARAM3.
Description: Average end to end times(days) of completed tickets(works Order Date Instructed - Date Completed date)
---------------------------------------------------------------------------*/
select DR.ACTIVITY_DESCRIPTION as "Topic",
round(avg(case when trunc(DR.defect_date_completed) >= trunc(to_date(:P6_PARAM3,'DD-MM-RRRR')) 
then
DR.defect_date_completed-WO.date_instructed end))
as "Average end to end times(days)"
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN('CMT')
and nm.parent_group_type = 'COMA'
And NM.PARENT_ELEMENT_REFERENCE like :P6_PARAM1
And DR.Activity_code in ('DP', 'AF', 'PL', 'FP', 'GR', 'SL', 'FT')
group by ACTIVITY_CODE,ACTIVITY_DESCRIPTION


