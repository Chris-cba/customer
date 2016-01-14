create or replace view x_rms_rsd_pdasp as 
--
select 
	provider
	, nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'START'), 'DD-MON-YYYY'), TO_DATE ('01-JAN-1901', 'DD-MON-YYYY')) Date_range_begins
	,nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) Date_range_end
	,max(decode(report,'AVG_RSRE',Val)) Average_Days
	,max(decode(report,'RSDE',Val)) Defects_fixed
	,max(decode(report,'RSRE',Val)) Requests_completed
	,max(decode(report,'RSIN',Val)) Inspections_conducted
	,max(decode(report,'RSAM',Val)) Accomplishments_completed
from
(
select 
Vendor_Code provider, 'AVG_RSRE' report
, avg(abs(Request_Completion_Date - Request_Date_Received)) Val
from v_nm_rsre
where 1=1
and Request_Completion_Date is not null
and Request_Date_Received is not null
and Request_Completion_Date >=   TO_DATE (nvl(SYS_CONTEXT ('XRMS_DATES', 'START'), '01-JAN-1901'), 'DD-MON-YYYY') 
and Request_Completion_Date <=   nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) 
group by vendor_code
--
Union
--
select 
Vendor_Code provider, 'RSDE' report
, count(*)Val
from v_nm_rsde
where 1=1
and DEFECT_COMPLETION_DATE is not null
and DEFECT_COMPLETION_DATE >=   TO_DATE (nvl(SYS_CONTEXT ('XRMS_DATES', 'START'), '01-JAN-1901'), 'DD-MON-YYYY') 
and DEFECT_COMPLETION_DATE <=   nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) 
group by vendor_code
--
UNION
--
select 
Vendor_Code provider, 'RSRE' report
, count(*)Val
from v_nm_rsRE
where 1=1
and Request_Completion_Date is not null
and Request_Completion_Date >=   TO_DATE (nvl(SYS_CONTEXT ('XRMS_DATES', 'START'), '01-JAN-1901'), 'DD-MON-YYYY') 
and Request_Completion_Date <=   nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) 
group by vendor_code
--
UNION
--
select 
Vendor_Code provider, 'RSIN' report
, count(*) Val
from v_nm_rsin
where 1=1
and INSPECTION_COMPLETION_DATE is not null
and INSPECTION_COMPLETION_DATE >=   TO_DATE (nvl(SYS_CONTEXT ('XRMS_DATES', 'START'), '01-JAN-1901'), 'DD-MON-YYYY') 
and INSPECTION_COMPLETION_DATE <=   nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) 
group by vendor_code
--
UNION
--
select 
Vendor_Code provider, 'RSAM' report
, count(*) Val
from v_nm_rsam
where 1=1
and COMPLETED ='Y'
and ACCOMPLISHMENT_DATE >=   TO_DATE (nvl(SYS_CONTEXT ('XRMS_DATES', 'START'), '01-JAN-1901'), 'DD-MON-YYYY') 
and ACCOMPLISHMENT_DATE <=   nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate) 
group by vendor_code
)
group by 
	provider
	, nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'START'), 'DD-MON-YYYY'), TO_DATE ('01-JAN-1901', 'DD-MON-YYYY'))
	,nvl(TO_DATE (SYS_CONTEXT ('XRMS_DATES', 'END'), 'DD-MON-YYYY'), sysdate)
--
;
