/*----------------------------------------------------------------------------------------
IM_4_1_1_TOP_1A
Title : Report Set 1
Header: % Completed against target time by defect type
Description: % Completed against target time by defect type
*/------------------------------------------------------------------------------------------
select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || to_char((sysdate-7),'DD-MON-YY')|| q'{','}' ||' For Last 7 Days' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 7 Days",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(sysdate-28) || q'{','}' ||' For Last 4 Weeks'|| q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 4 Weeks",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(add_months(sysdate,-3))|| q'{','}' ||' For Last 3 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 3 Months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(add_months(sysdate,-6))|| q'{','}' ||' For Last 6 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 6 months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||to_char(add_months(sysdate,-12),'DD-MON-YY')|| q'{','}' ||' For Last Year' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last Year",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||'01-JAN-1900'|| q'{','}' ||' For All' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN('COMA')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||to_char((sysdate-7),'DD-MON-YY')|| q'{','}' ||' For Last 7 Days' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 7 Days",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(sysdate-28) || q'{','}' ||' For Last 4 Weeks'|| q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 4 Weeks",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(add_months(sysdate,-3))|| q'{','}' ||' For Last 3 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 3 Months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||(add_months(sysdate,-6))|| q'{','}' ||' For Last 6 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last 6 months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||to_char(add_months(sysdate,-12),'DD-MON-YY')|| q'{','}' ||' For Last Year' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "Last Year",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1A','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' ||'01-JAN-1900'|| q'{','}' ||' For All' || q'{');"><font face="verdana" color="blue"><u>}'|| '1a' ||q'{</u></font></a>}' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN('TOP')
AND PARENT_ELEMENT_REFERENCE LIKE 'WILTSHIRE ROADS'

/*----------------------------------------------------------------------------------------
IM_4_1_1_TOP_1B
Title : Report Set 1
Header: Average number of days to complete by defect type
Description: Average number of days to complete by defect type
*/------------------------------------------------------------------------------------------
select 
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || to_char((sysdate-7),'DD-MON-YY')|| q'{','}' ||' For Last 7 Days' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 7 Days",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (sysdate-28) || q'{','}' ||' For Last 4 Weeks'|| q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 4 Weeks",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (add_months(sysdate,-3))|| q'{','}' ||' For Last 3 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 3 Months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (add_months(sysdate,-6))|| q'{','}' ||' For Last 6 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 6 months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || to_char(add_months(sysdate,-12),'DD-MON-YY')|| q'{','}' ||' For Last Year' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last Year",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION  || q'{','}' || '01-JAN-1900'|| q'{','}' ||' For All' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN('COMA')
UNION
select
DISTINCT PARENT_ELEMENT_DESCRIPTION as "Area Boards",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || to_char((sysdate-7),'DD-MON-YY')|| q'{','}' ||' For Last 7 Days' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 7 Days",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (sysdate-28) || q'{','}' ||' For Last 4 Weeks'|| q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 4 Weeks",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (add_months(sysdate,-3))|| q'{','}' ||' For Last 3 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 3 Months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || (add_months(sysdate,-6))|| q'{','}' ||' For Last 6 Months' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last 6 months",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || to_char(add_months(sysdate,-12),'DD-MON-YY')|| q'{','}' ||' For Last Year' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "Last Year",
q'{<a href="javascript:doDrillDown('IM_4_1_1_DD1_1B','}' || PARENT_ELEMENT_REFERENCE || q'{','}' || PARENT_ELEMENT_DESCRIPTION || q'{','}' || '01-JAN-1900'|| q'{','}' ||' For All' || q'{');"><font face="verdana" color="blue"><u>}'|| '1b' ||q'{</u></font></a>}' "All"
from IMF_NET_NETWORK_MEMBERS 
where PARENT_GROUP_TYPE IN('TOP')
AND PARENT_ELEMENT_REFERENCE LIKE 'WILTSHIRE ROADS'

