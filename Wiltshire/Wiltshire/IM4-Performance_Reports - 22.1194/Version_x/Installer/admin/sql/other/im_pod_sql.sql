SET DEFINE OFF;
MERGE INTO IM_POD_SQL A USING
 (SELECT
  4015 as IPS_ID,
  4019 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4016 as IPS_ID,
  4020 as IPS_IP_ID,
  1 as IPS_SEQ,
  'Select Find_and_Fix_App as "Find and Fix App",
nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null) "% Completed against target",
Number_of_CMT_defects as "Number of CMT defects"
from
(
select
(select ''Find and Fix'' from Dual) as Find_and_Fix_App,
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') <= trunc(date_due) then 1 else 0 end) completed_on_time
--
,
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') > trunc(date_due) then 1 else 0 end) completed_late
,
sum (case when  defect_status<>''COMPLETED'' and trunc(DATE_DUE) < trunc(sysdate) then 1 else 0 end) Not_completed_and_late,
count(DR.DEFECT_ID) as Number_of_CMT_defects
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
group by INS.INITIATION_TYPE_DESCRIPTION)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4017 as IPS_ID,
  4021 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_4_DD1_4B'',''}'' || ''*'' || q''{'',''}'' ||PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''4b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4018 as IPS_ID,
  4022 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select -- INS.INITIATION_TYPE_DESCRIPTION,
(select ''Find and Fix'' from Dual) as "Find and Fix App",
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
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
AND INS.initiation_type IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
group by INS.INITIATION_TYPE_DESCRIPTION
' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4019 as IPS_ID,
  4023 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_5_DD1_5A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4020 as IPS_ID,
  4024 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select case when DR.DEFECT_TYPE=''POTH'' then ''Potholes'' end as "Topic",
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
then
DR.defect_date_completed-WO.date_instructed end))
as "Average end to end times(days)",
SUM(CASE WHEN dr.defect_status=''INSTRUCTED''
 and trunc(date_instructed) >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
 THEN 1 ELSE 0 END) AS "Issued to Contractor",
 SUM(CASE WHEN defect_status=''COMPLETED''
  and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
 THEN 1 ELSE 0 END) AS "Number Completed"
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
and DR.DEFECT_TYPE=''POTH''
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
--and DR.PRIORITY not in(''A1'',''A2'',''A3'',''A4'',''A5'')
--And DR.Activity_code in (''DP'', ''AF'', ''PL'', ''FP'', ''GR'', ''SL'', ''FT'')
group by DR.DEFECT_TYPE' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4021 as IPS_ID,
  4025 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4022 as IPS_ID,
  4026 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select ACTIVITY_DESCRIPTION as "Topic",
nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null) "% Completed against target",
Issued_to_BBLP as "Issued to Contractor",
--Number_Completed as "Number Completed"
completed_on_time "Completed on Time",
completed_late "Completed and Late",
Not_completed_and_late "Not Completed and Late"
from
(
select DR.ACTIVITY_DESCRIPTION as ACTIVITY_DESCRIPTION,
--
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') <= trunc(date_due) then 1 else 0 end) completed_on_time
--
,
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') > trunc(date_due) then 1 else 0 end) completed_late
,
sum (case when  defect_status<>''COMPLETED'' and trunc(DATE_DUE) < trunc(sysdate) then 1 else 0 end) Not_completed_and_late
,
SUM(CASE WHEN dr.defect_status=''INSTRUCTED''
and trunc(date_instructed) >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
 THEN 1 ELSE 0 END)
 AS Issued_to_BBLP,
--
SUM(CASE WHEN defect_status=''COMPLETED''
and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
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
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''DP'', ''AF'', ''PL'', ''FP'', ''GR'', ''SL'', ''FT'')
group by ACTIVITY_CODE,ACTIVITY_DESCRIPTION)
order by ACTIVITY_DESCRIPTION' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4023 as IPS_ID,
  4027 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION  || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_1_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''1b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''
' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4024 as IPS_ID,
  4028 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select DR.ACTIVITY_DESCRIPTION as "Topic",
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
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
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''DP'', ''AF'', ''PL'', ''FP'', ''GR'', ''SL'', ''FT'')
group by ACTIVITY_CODE,ACTIVITY_DESCRIPTION
order by ACTIVITY_DESCRIPTION' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4025 as IPS_ID,
  4029 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4026 as IPS_ID,
  4030 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select --PRIORITY,
case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
--avg(nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null)) "% Completed against target",
case when grouping(PRIORITY) = 1 
then trunc(100 * avg(completed_on_time)/ (nullif(avg(completed_on_time),0)+nullif(avg(completed_late),0)+nullif(avg(Not_completed_and_late),0)),2)
else avg(nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null)) 
end "% Completed against target",
sum(Issued_to_BBLP) as "Issued to Contractor",
--sum(Number_Completed) as "Number Completed"
sum(completed_on_time) "Completed on Time",
sum(completed_late) "Completed and Late",
sum(Not_completed_and_late) "Not Completed and Late"
from(
select
Priority,
sum(Issued_to_BBLP) as Issued_to_BBLP,
--sum(Number_Completed) as "Number Completed"
sum(completed_on_time) completed_on_time,
sum(completed_late) completed_late,
sum(Not_completed_and_late) Not_completed_and_late
from
(
 select
 case      when DR.PRIORITY IN(''1'',''1P'') then ''P1''
           when DR.PRIORITY = ''2'' then ''P2''
           when DR.PRIORITY = ''3'' then ''P3''
           when DR.PRIORITY = ''4'' then ''P4''
          end AS Priority,
--count(DR.DEFECT_ID),
--
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'')  >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') <= trunc(date_due) then 1 else 0 end) completed_on_time
--
,
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') > trunc(date_due) then 1 else 0 end) completed_late
,
sum (case when  defect_status<>''COMPLETED'' and trunc(DATE_DUE) < trunc(sysdate) then 1 else 0 end) Not_completed_and_late
,
SUM(CASE WHEN dr.defect_status=''INSTRUCTED''
and trunc(date_instructed) >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
 THEN 1 ELSE 0 END)
 AS Issued_to_BBLP,
--
SUM(CASE WHEN defect_status=''COMPLETED''
and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
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
AND INS.initiation_type NOT IN(''CMT'')
and DR.PRIORITY IN(''1P'',''1'',''2'',''3'',''4'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4027 as IPS_ID,
  4031 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_2_DD1_2B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''2b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4028 as IPS_ID,
  4032 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
--avg(nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null)) "% Completed against target",
case when grouping(PRIORITY) = 1 
then trunc(100 * avg(completed_on_time)/ (nullif(avg(completed_on_time),0)+nullif(avg(completed_late),0)+nullif(avg(Not_completed_and_late),0)),2)
else avg(nvl(trunc(100*(completed_on_time/nullif((completed_on_time+completed_late+Not_completed_and_late),0)),2), null)) 
end "% Completed against target",
sum(Issued_to_BBLP) as "Issued to Contractor",
--sum(Number_Completed) as "Number Completed"
sum(completed_on_time) "Completed on Time",
sum(completed_late) "Completed and Late",
sum(Not_completed_and_late) "Not Completed and Late"
from
(
 select DR.PRIORITY as PRIORITY,
--
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') <= trunc(date_due) then 1 else 0 end) completed_on_time
--
,
sum (case when  defect_status=''COMPLETED'' and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) And nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') > trunc(date_due) then 1 else 0 end) completed_late
,
sum (case when  defect_status<>''COMPLETED'' and trunc(DATE_DUE) < trunc(sysdate) then 1 else 0 end) Not_completed_and_late
,
SUM(CASE WHEN dr.defect_status=''INSTRUCTED'' 
and trunc(date_instructed) >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
 THEN 1 ELSE 0 END) 
 AS Issued_to_BBLP,
--
SUM(CASE WHEN defect_status=''COMPLETED'' 
and nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
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
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
and DR.PRIORITY IN(''A1'',''A2'',''A3'',''A4'',''A5'')
And DR.Activity_code in (''AF'',''DP'',''FP'',''FT'',''GR'',''LC'',''NS'',''PA'',''PL'',''PT'',''SL'',''SW'',''WD'',''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4029 as IPS_ID,
  4033 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4030 as IPS_ID,
  4034 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select  case when grouping(PRIORITY) = 1 then ''Average'' else priority end  as "Priority",
         --sum(Avg_end_to_end) as "Average end to end times(days)"
         case when grouping(PRIORITY) = 1 
    then avg(Avg_end_to_end) 
    else
     sum(Avg_end_to_end)  end "Average end to end times(days)"
from(
select
PRIORITY,
sum(Avg_end_to_end) Avg_end_to_end
from
(Select --DR.PRIORITY as PRIORITY, 
case      when DR.PRIORITY IN(''1'',''1P'') then ''P1''
           when DR.PRIORITY = ''2'' then ''P2''
           when DR.PRIORITY = ''3'' then ''P3''
           when DR.PRIORITY = ''4'' then ''P4''
          end AS Priority,
    round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
then
DR.defect_date_completed-WO.date_instructed end))
as Avg_end_to_end
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and DR.PRIORITY IN(''1P'',''1'',''2'',''3'',''4'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4031 as IPS_ID,
  4035 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || (add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_1_3_DD1_3B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || ''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''3b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4032 as IPS_ID,
  4036 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select  case when grouping(PRIORITY) = 1 then ''Average'' else priority end  as "Priority",
         --sum(Avg_end_to_end) as "Average end to end times(days)"
         case when grouping(PRIORITY) = 1 
    then avg(Avg_end_to_end) 
    else
     sum(Avg_end_to_end)  end "Average end to end times(days)"
 from
(select DR.PRIORITY as priority,
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR''))
then
DR.defect_date_completed-WO.date_instructed end))
as Avg_end_to_end
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
and DR.PRIORITY in(''A1'',''A2'',''A3'',''A4'',''A5'')
And DR.Activity_code in(''AF'',''DP'',''FP'',''FT'',''GR'',''LC'',''NS'',''PA'',''PL'',''PT'',''SL'',''SW'',''WD'',''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4033 as IPS_ID,
  4037 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' || trunc(sysdate) || q''{'',''}'' ||'' for Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' || (sysdate-28)|| q''{'',''}'' ||'' for Preceding 6 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5b'' ||q''{</u></font></a>}'' "Preceding 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' ||'' for Over 7 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5c'' ||q''{</u></font></a>}'' "Over 7 months"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' || trunc(sysdate) || q''{'',''}'' ||'' for Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''5a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || ''*''  || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' for Preceding 6 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5b'' ||q''{</u></font></a>}'' "Preceding 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1A'',''}'' || ''*''  || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' ||'' for Over 7 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''5c'' ||q''{</u></font></a>}'' "Over 7 months"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4034 as IPS_ID,
  4038 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select "Priority", Received, Completed,"% completed" from (
    select rownum sorter, a.* from (
		select case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
		sum(Received) Received,
		sum(Completed) Completed,
		trunc((avg(Completed)/avg(Received)*100),2) as "% completed"
		from
		(select --case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
			Priority,
			sum(Rec) as Received ,
			sum(Comp) as Completed 
			--trunc((comp/Rec*100),2) as "% completed"
			FROM
				(select 
				case      when DR.PRIORITY IN(''1'',''1P'') then ''P1''
						   when DR.PRIORITY = ''2'' then ''P2''
						   when DR.PRIORITY = ''3'' then ''P3''
						   when DR.PRIORITY = ''4'' then ''P4''
						  end AS Priority,
				--SUM(CASE WHEN dr.defect_status =''INSTRUCTED'' 
				-- THEN 1 ELSE 0 END) as Rec,
				count(dr.defect_id) AS Rec,
				 SUM(CASE WHEN dr.defect_status=''COMPLETED'' 
				 THEN 1 ELSE 0 END) AS Comp
				 from IMF_MAI_DEFECT_REPAIRS DR,
				IMF_MAI_INSPECTIONS INS,
				IMF_NET_NETWORK_MEMBERS NM,
				IMF_MAI_WORK_ORDERS WO
				where 1=1
				and DR.INSPECTION_ID=INS.INSPECTION_ID
				AND DR.network_element_id =NM.child_element_id
				AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
				AND INS.initiation_type NOT IN(''CMT'')
				and DR.PRIORITY IN(''1P'',''1'',''2'',''3'',''4'')
				and nm.parent_group_type = ''COMA''
				And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
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
		''Others'' as Priority,
		sum(Received) Received,
		sum(Completed) Completed,
		trunc((avg(Completed)/avg(Received)*100),2) as "% completed"
		from
		(
			select dr.PRIORITY as priority,
			count(dr.defect_id) AS Received,
			 SUM(CASE WHEN dr.defect_status=''COMPLETED'' 
			 THEN 1 ELSE 0 END) AS Completed
			from IMF_MAI_DEFECT_REPAIRS DR,
			IMF_MAI_INSPECTIONS INS,
			IMF_NET_NETWORK_MEMBERS NM,
			IMF_MAI_WORK_ORDERS WO
			where 1=1
			and DR.INSPECTION_ID=INS.INSPECTION_ID
			AND DR.network_element_id =NM.child_element_id
			AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
			AND INS.initiation_type NOT IN(''CMT'')
			and DR.PRIORITY IN(''5'',''6'',''7'')
			and nm.parent_group_type = ''COMA''
			And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
			and wo.date_instructed between :P6_PARAM3 and :P6_PARAM4 
		group by dr.PRIORITY)
    ) a
)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4035 as IPS_ID,
  4039 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'');"><font face="verdana" color="blue"><u>}''|| ''Find and Fix'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'');"><font face="verdana" color="blue"><u>}''|| ''Find and Fix'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4036 as IPS_ID,
  4040 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select b.FF "Find and Fix", nvl("Received",0) "Received", nvl("Completed",0) "Completed", nvl("% completed",0) "% completed" from (
select case when DEFECT_TYPE=''POTH'' then ''Potholes''  end as FF,
Rec as "Received",
comp as "Completed",
trunc((comp/Rec*100),2) as "% completed"
from(
select
dr.defect_type as defect_type,
--count(dr.defect_id) as cnt
SUM(CASE WHEN INS.initiation_type =''CMT'' 
 THEN 1 ELSE 0 END) AS Rec,
 SUM(CASE WHEN defect_status=''COMPLETED'' 
  and  INS.initiation_type =''CMT''
  THEN 1 ELSE 0 END) AS Comp
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type IN(''CMT'')
and DR.DEFECT_TYPE=''POTH''
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
group by DR.DEFECT_TYPE)) a
, (select  ''Potholes'' FF from dual) b
where a.FF(+) = b.FF
union
select ''All Defect Types'' as "Find and Fix",
sum(Rec) as "Received",
sum(comp) as "Completed",
trunc((avg(comp)/avg(Rec)*100),2) as "% completed"
from(
select
dr.defect_type as defect_type,
--count(dr.defect_id) as cnt
SUM(CASE WHEN INS.initiation_type =''CMT'' 
 THEN 1 ELSE 0 END) AS Rec,
 SUM(CASE WHEN defect_status=''COMPLETED'' 
  and  INS.initiation_type =''CMT''
  THEN 1 ELSE 0 END) AS Comp
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type IN(''CMT'')
and DR.DEFECT_TYPE<>''POTH''
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
group by DR.DEFECT_TYPE)
order by 1 desc' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4037 as IPS_ID,
  4041 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' || trunc(sysdate) || q''{'',''}'' ||'' for Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''6a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' || (sysdate-28)|| q''{'',''}'' ||'' for Preceding 6 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''6b'' ||q''{</u></font></a>}'' "Preceding 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' ||'' for Over 7 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''6c'' ||q''{</u></font></a>}'' "Over 7 months"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' || trunc(sysdate) || q''{'',''}'' ||'' for Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''6a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || ''*''  || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' || (sysdate-28) || q''{'',''}'' ||'' for Preceding 6 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''6b'' ||q''{</u></font></a>}'' "Preceding 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_2_2_DD1_1C'',''}'' || ''*''  || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||(add_months(sysdate,-7))|| q''{'',''}'' ||'' for Over 7 months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''6c'' ||q''{</u></font></a>}'' "Over 7 months"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4038 as IPS_ID,
  4042 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
sum(Rec) as Received ,
sum(Comp) as Completed ,
--avg(trunc((comp/Rec*100),2)) as "% completed"
case when grouping(PRIORITY) = 1 
    then trunc((avg(comp)/avg(Rec)*100),2)
    else
     avg(trunc((comp/Rec*100),2)) end "% completed" 
FROM
(select  DR.PRIORITY as PRIORITY,
--SUM(CASE WHEN dr.defect_status =''INSTRUCTED'' 
-- THEN 1 ELSE 0 END) as Rec,
count(dr.defect_id) AS Rec,
 SUM(CASE WHEN dr.defect_status=''COMPLETED'' 
 THEN 1 ELSE 0 END) AS Comp
 from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and DR.PRIORITY IN(''A1'',''A2'',''A3'',''A4'',''A5'')
And DR.Activity_code in (''AF'',''DP'',''FP'',''FT'',''GR'',''LC'',''NS'',''PA'',''PL'',''PT'',''SL'',''SW'',''WD'',''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
and wo.date_instructed between :P6_PARAM3 and :P6_PARAM4 
group by DR.PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4039 as IPS_ID,
  4043 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_1_DD1_7A'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7a'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4040 as IPS_ID,
  4044 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select DR.ACTIVITY_DESCRIPTION as "Topic",
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
WO.date_instructed-DR.date_recorded end))
as --"Average e2e times(days) DR-DI",
"Received to Instructed",
round(avg(case when nvl(trunc(WO.date_instructed),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-DR.date_recorded end))
as --"Average e2e times(days) DR-DC",
"Received to Completed",
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-WO.date_instructed end))
as --"Average e2e times(days) DI-DC"
"Instructed to Completed"
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''DP'', ''AF'', ''PL'', ''FP'', ''GR'', ''SL'', ''FT'')
group by ACTIVITY_CODE,ACTIVITY_DESCRIPTION
order by ACTIVITY_DESCRIPTION
' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4041 as IPS_ID,
  4045 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_2_DD1_7B'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7b'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4042 as IPS_ID,
  4046 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select --PRIORITY,
case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
--sum(DR_DI) "Received to Instructed",--"Average e2e times(days) DR-DI",
case when grouping(PRIORITY) = 1 
    then avg(DR_DI) 
    else
     sum(DR_DI)  end  "Received to Instructed",
--sum(DR_DC) "Received to Completed",--"Average e2e times(days) DR-DC",
case when grouping(PRIORITY) = 1 
    then avg(DR_DC) 
    else
     sum(DR_DC)  end  "Received to Completed",
--sum(DI_DC) "Instructed to Completed"--"Average e2e times(days) DI-DC"
case when grouping(PRIORITY) = 1 
    then avg(DI_DC) 
    else
     sum(DI_DC)  end "Instructed to Completed"
from(
select
Priority,
avg(DR_DI) DR_DI,
avg(DR_DC) DR_DC,
avg(DI_DC) DI_DC
from
(
 select 
 case      when DR.PRIORITY IN(''1'',''1P'') then ''P1''
           when DR.PRIORITY = ''2'' then ''P2''
           when DR.PRIORITY = ''3'' then ''P3''
           when DR.PRIORITY = ''4'' then ''P4''
          end AS Priority,
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
WO.date_instructed-DR.date_recorded end))
as DR_DI,
round(avg(case when nvl(trunc(WO.date_instructed),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-DR.date_recorded end))
as DR_DC,
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-WO.date_instructed end))
as DI_DC
--
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and DR.PRIORITY IN(''1P'',''1'',''2'',''3'',''4'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
And DR.Activity_code in (''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4043 as IPS_ID,
  4047 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' || to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || PARENT_ELEMENT_REFERENCE || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''COMA'')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char((sysdate-7),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last 7 Days'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 7 Days",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(sysdate-28) || q''{'',''}'' ||'' For Last 4 Weeks''|| q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 4 Weeks",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-3))|| q''{'',''}'' ||'' For Last 3 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 3 Months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||(add_months(sysdate,-6))|| q''{'',''}'' ||'' For Last 6 Months'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last 6 months",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||to_char(add_months(sysdate,-12),''DD-MON-YY'')|| q''{'',''}'' ||'' For Last Year'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "Last Year",
q''{<a href="javascript:doDrillDown(''WPR_4_3_3_DD1_7C'',''}'' || ''*'' || q''{'',''}'' || PARENT_ELEMENT_DESCRIPTION || q''{'',''}'' ||''01-JAN-1900''|| q''{'',''}'' ||'' For All'' || q''{'');"><font face="verdana" color="blue"><u>}''|| ''7c'' ||q''{</u></font></a>}'' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN(''TOP'')
AND PARENT_ELEMENT_REFERENCE LIKE ''WILTSHIRE ROADS''' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

MERGE INTO IM_POD_SQL A USING
 (SELECT
  4044 as IPS_ID,
  4048 as IPS_IP_ID,
  1 as IPS_SEQ,
  'select --priority as "Priority",
case when grouping(PRIORITY) = 1 then ''Total'' else priority end  as "Priority",
--sum(DR_DI) "Received to Instructed",--"Average e2e times(days) DR-DI",
case when grouping(PRIORITY) = 1 
    then avg(DR_DI) 
    else
     sum(DR_DI)  end  "Received to Instructed",
--sum(DR_DC) "Received to Completed",--"Average e2e times(days) DR-DC",
case when grouping(PRIORITY) = 1 
    then avg(DR_DC) 
    else
     sum(DR_DC)  end  "Received to Completed",
--sum(DI_DC) "Instructed to Completed"--"Average e2e times(days) DI-DC"
case when grouping(PRIORITY) = 1 
    then avg(DI_DC) 
    else
     sum(DI_DC)  end "Instructed to Completed"
 from
(select DR.PRIORITY as priority,
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
WO.date_instructed-DR.date_recorded end))
as DR_DI,
round(avg(case when nvl(trunc(WO.date_instructed),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-DR.date_recorded end))
as DR_DC,
round(avg(case when nvl(trunc(DEFECT_DATE_COMPLETED),''12-DEC-9999'') >= trunc(to_date(:P6_PARAM3,''DD-MM-RRRR'')) 
then
DR.DEFECT_DATE_COMPLETED-WO.date_instructed end))
as DI_DC
from IMF_MAI_DEFECT_REPAIRS DR,
IMF_MAI_INSPECTIONS INS,
IMF_NET_NETWORK_MEMBERS NM,
IMF_MAI_WORK_ORDERS WO
where 1=1
and DR.INSPECTION_ID=INS.INSPECTION_ID
AND DR.network_element_id =NM.child_element_id
AND DR.WORKS_ORDER_NUMBER=WO.WORKS_ORDER_NUMBER
AND INS.initiation_type NOT IN(''CMT'')
and nm.parent_group_type = ''COMA''
And NM.PARENT_ELEMENT_REFERENCE like replace(:P6_PARAM1,''*'',''%'')
and DR.PRIORITY in(''A1'',''A2'',''A3'',''A4'',''A5'')
And DR.Activity_code in(''AF'',''DP'',''FP'',''FT'',''GR'',''LC'',''NS'',''PA'',''PL'',''PT'',''SL'',''SW'',''WD'',''CK'',''CL'',''CW'',''DC'',''DD'',''FW'',''HF'',''HO'',''KE'',''RA'',''SB'',''SF'',''SN'',''TH'',''VG'',''VK'',''WM'')
group by DR.PRIORITY)
group by rollup(PRIORITY)' as IPS_SOURCE_CODE,
  NULL as IPS_NAME,
  'Bar' as IPS_TYPE,
  'Box' as IPS_SHAPE_TYPE,
  NULL as IPS_NE_ID_COLUMN
  FROM DUAL) B
ON (A.IPS_ID = B.IPS_ID)
WHEN NOT MATCHED THEN 
INSERT (
  IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, 
  IPS_TYPE, IPS_SHAPE_TYPE, IPS_NE_ID_COLUMN)
VALUES (
  B.IPS_ID, B.IPS_IP_ID, B.IPS_SEQ, B.IPS_SOURCE_CODE, B.IPS_NAME, 
  B.IPS_TYPE, B.IPS_SHAPE_TYPE, B.IPS_NE_ID_COLUMN)
WHEN MATCHED THEN
UPDATE SET 
  A.IPS_IP_ID = B.IPS_IP_ID,
  A.IPS_SEQ = B.IPS_SEQ,
  A.IPS_SOURCE_CODE = B.IPS_SOURCE_CODE,
  A.IPS_NAME = B.IPS_NAME,
  A.IPS_TYPE = B.IPS_TYPE,
  A.IPS_SHAPE_TYPE = B.IPS_SHAPE_TYPE,
  A.IPS_NE_ID_COLUMN = B.IPS_NE_ID_COLUMN;

COMMIT;
