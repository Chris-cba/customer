/*--------------------------------------------------------------------------
IM_4_1_2_DD1_2A
Community Area: &P6_PARAM2. for &P6_PARAM3.
% Highway defects completed against target time by priority
---------------------------------------------------------------------------*/
select   case
           when PRIORITY IN('1','1P') then 'P1'
           when PRIORITY = '2' then 'P2'
           when PRIORITY = '3' then 'P3'
           when PRIORITY = '4' then 'P4'
          end AS "Priority",
		 avg(trunc(100*(completed_on_time/(completed_on_time+completed_late+Not_completed_and_late)),2)) "% Completed against target",
sum(Issued_to_BBLP) as "Issued to BBLP",
sum(Number_Completed) as "Number Completed"
from
(
 select DR.PRIORITY as PRIORITY,
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
and DR.PRIORITY IN('1P','1','2','3','4')
and nm.parent_group_type = 'COMA'
And NM.PARENT_ELEMENT_REFERENCE like :P6_PARAM1
And DR.Activity_code in ('CK','CL','CW','DC','DD','FW','HF','HO','KE','RA','SB','SF','SN','TH','VG','VK','WM')
group by DR.PRIORITY)
group by rollup(PRIORITY)

/*--------------------------------------------------------------------------
IM_4_1_2_DD1_2B
Community Area: &P6_PARAM2. for &P6_PARAM3.
% PEM defects completed against target time
---------------------------------------------------------------------------*/
select PRIORITY as "Priority",
avg(trunc(100*(completed_on_time/(completed_on_time+completed_late+Not_completed_and_late)),2)) "% Completed against target",
sum(Issued_to_BBLP) as "Issued to BBLP",
sum(Number_Completed) as "Number Completed"
from
(
 select DR.PRIORITY as PRIORITY,
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
and DR.PRIORITY IN('A1','A2','A3','A4','A5')
And DR.Activity_code in ('AF','DP','FP','FT','GR','LC','NS','PA','PL','PT','SL','SW','WD','CK','CL','CW','DC','DD','FW','HF','HO','KE','RA','SB','SF','SN','TH','VG','VK','WM')
group by DR.PRIORITY)
group by rollup(PRIORITY)