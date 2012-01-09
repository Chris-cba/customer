SET DEFINE OFF;
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (1, 242, 1, 'select  ''<a href="javascript:doDrillDown(''''XWILTS001A'''',''''''||con_code||'''''',''''''||con_id||'''''',''''''||con_name||'''''')">''||con_code||''</a>'' as "Contract No",con_name as "Contract Name",con_year_end_date as "Year End Date" 
from contracts 
where con_status_code = ''ACTIVE''
order by con_code,con_year_end_date
', 'Contract', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (2, 248, 1, 'select  ''<a href="javascript:doDrillDown(''''XWILTS001B'''',''''''||wor_works_order_no||'''''',''''''||ltrim(to_char(wor_act_cost,''9999999.99''))||'''''',''''''||trunc(wor_act_cost/wor_est_cost*100)||'''''')">''||wor_works_order_no||''</a>'' as "WO No",wor.wor_descr as "Description"
,wwo.raised_by(wor.wor_works_order_no) as "Raised By",wwo.authorised_by(wor.wor_works_order_no) as "Authorised By",wor.wor_date_raised as "Date Raised"
,wor.wor_est_complete as "Target Complete",wor.wor_date_confirmed as "Date Instructed",wor.wor_est_cost as "Estimate",wor.wor_act_cost as "Actual",
  (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)
             as "Status",wor_date_closed as "Date Completed",
 ''<a href="javascript:doDrillDown(''''XWILTS001B2'''',''''''||wor_works_order_no||'''''',''''''||ltrim(to_char(wor_act_cost,''9999999.99''))||'''''')">''||''BOQ Items''||''</a>'' as "Breakdown"
from work_orders wor
where wor_con_id = :P6_PARAM2
ORDER BY 1', 'WOContract', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (3, 249, 1, 'select null as link,to_char(cp_payment_date,''Mon YYYY'') as "Month",sum(cp_payment_value) as "Expenditure" from claim_payments
where cp_wol_id in (select wol_id from work_order_lines where wol_works_order_no = :P6_PARAM1)
and cp_payment_date is not null
group by to_char(cp_payment_date,''Mon YYYY''),to_number(to_char(cp_payment_date,''YYMM''))
order by to_number(to_char(cp_payment_date,''YYMM''))', 'WOMonth', 
    'Bar', 'Cylinder');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (6, 253, 1, 'select null link,
 substr(boq_item_name,instr(boq_item_name,''-'')+2,4) as "BOQ",
to_char(sum(boq_act_cost)/:P6_PARAM2*100,''990.99'') as "Percentage Spent"
from boq_items 
where boq_wol_id in (select wol_id from work_order_lines where wol_works_order_no = :P6_PARAM1)
and boq_act_cost > 0
and substr(boq_item_name,instr(boq_item_name,''-'')+2,4) like ''1%''
GROUP BY SUBSTR(BOQ_ITEM_NAME,INSTR(BOQ_ITEM_NAME,''-'')+2,4)', 'WOBOQ', 
    'Bar', 'Cylinder');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (7, 254, 1, 'select  ''<a href="javascript:doDrillDown(''''XWILTS002A'''',''''''||oun_unit_code||'''''',''''''||oun_org_id||'''''',''''''||oun_name||'''''')">''||oun_unit_code||''</a>'' as "Contractor Code",oun_name as "Name",oun_contractor_id as "Contractor Id",oun_start_date as "Start Date",oun_end_date as "End Date" 
from org_units 
where oun_org_unit_type = ''CO''
and nvl(oun_end_date,sysdate) >= sysdate
order by 1', 'Contractors', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (12, 255, 1, 'select ''<a href="javascript:doDrillDown(''''XWILTS002B5'''',''''''||wor_works_order_no||'''''')">''||wor_works_order_no||''</a>'' as "WO No",wor.wor_descr as "Description"
,wwo.raised_by(wor.wor_works_order_no) as "Raised By",wwo.authorised_by(wor.wor_works_order_no) as "Authorised By",wor.wor_date_raised as "Date Raised"
,wor.wor_est_complete as "Target Complete",wor.wor_date_confirmed as "Date Instructed",wor.wor_est_cost as "Estimate",wor.wor_act_cost as "Actual",
  (SELECT wor_status
             FROM v_work_order_status vwor
            WHERE vwor.wor_works_order_no = wor.wor_works_order_no)
             as "Status",wor_date_closed as "Date Completed",
''<a href="javascript:doDrillDown(''''XWILTS002B3'''',''''''||:P6_PARAM1||'''''',''''''||sum(wor_act_cost) over ()||'''''',''''''||to_char(sum(wor_act_cost) over ()/sum(wor_est_cost) over ()*100,''990.99'')||'''''',''''''||wor_scheme_type||'''''',''''''||(select hco_meaning from hig_codes where hco_domain = ''SCHEME_TYPES'' and hco_code = wor_scheme_type)||'''''')">''||wor_scheme_type||''</a>'' as "Scheme Type",
''<a href="javascript:doDrillDown(''''XWILTS002B4'''',''''''||:P6_PARAM1||'''''',''''''||sum(wor_act_cost) over ()||'''''',''''''||wor_scheme_type||'''''',''''''||(select hco_meaning from hig_codes where hco_domain = ''SCHEME_TYPES'' and hco_code = wor_scheme_type)||'''''')">''||wor_scheme_type||'' Breakdown''||''</a>'' as "Scheme Type Breakdown",
''<a href="javascript:doDrillDown(''''XWILTS002B'''',''''''||:P6_PARAM1||'''''',''''''||sum(wor_act_cost) over ()||'''''',''''''||to_char(sum(wor_act_cost) over ()/sum(wor_est_cost) over ()*100,''990.99'')||'''''')">''||:P6_PARAM1||'' Monthly Expenditure''||''</a>'' as "Expenditure",
''<a href="javascript:doDrillDown(''''XWILTS002B2'''',''''''||:P6_PARAM1||'''''',''''''||sum(wor_act_cost) over ()||'''''')">''||:P6_PARAM1||'' Breakdown''||''</a>'' as "Contractor Breakdown", ''<a href="javascript:doDrillDown(''''XWILTS002B6'''',''''''||wor_works_order_no||'''''',''''''||wor_date_raised||'''''')">''||wor_works_order_no||'' Cumulative Actual''||''</a>'' as "Cumulative Actual"
from work_orders wor
where wor_con_id in (select con_id from contracts where con_contr_org_id in (select oun_org_id from org_units where oun_unit_code = :P6_PARAM1) and con_start_date <= sysdate and con_end_date >= sysdate)
order by 1
', 'works', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (9, 256, 1, 'Select null as link, to_char(cp_payment_date,''Mon YYYY'') as "Month",sum(cp_payment_value) as "Expenditure" from claim_payments
where cp_wol_id in (select wol_id from work_order_lines where wol_works_order_no in 
(select wor_works_order_no from work_orders where wor_con_id in 
(select con_id from contracts where con_contr_org_id in 
(select oun_org_id from org_units where oun_unit_code = :P6_PARAM1) 
and con_start_date <= sysdate
and con_end_date >= sysdate)))
and cp_payment_date is not null
group by to_char(cp_payment_date,''Mon YYYY''),to_number(to_char(cp_payment_date,''YYMM''))
order by to_number(to_char(cp_payment_date,''YYMM''))
', 'ContractorMonth', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (10, 257, 1, 'select substr(boq_item_name,instr(boq_item_name,''-'')+2,4) as "BOQ",
to_char(sum(boq_act_cost)/:P6_PARAM2*100,''990.99'') as "Percentage Spent"
from boq_items 
where boq_wol_id in (select wol_id from work_order_lines where wol_works_order_no in 
(select wor_works_order_no from work_orders where wor_con_id in 
(select con_id from contracts where con_contr_org_id in 
(select oun_org_id from org_units where oun_unit_code = :P6_PARAM1) 
and con_start_date <= sysdate
and con_end_date >= sysdate)))
and boq_act_cost > 0
and substr(boq_item_name,instr(boq_item_name,''-'')+2,4) like ''1%''
group by substr(boq_item_name,instr(boq_item_name,''-'')+2,4)
order by 1', 'ContractorBOQ', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (11, 258, 1, 'Select null as link, to_char(cp_payment_date,''Mon YYYY'') as "Month",sum(cp_payment_value) as "Expenditure" from claim_payments
where cp_wol_id in (select wol_id from work_order_lines where wol_works_order_no in 
(select wor_works_order_no from work_orders where wor_con_id in 
(select con_id from contracts where con_contr_org_id in 
(select oun_org_id from org_units where oun_unit_code = :P6_PARAM1) 
and con_start_date <= sysdate
and con_end_date >= sysdate)
and wor_scheme_type = :P6_PARAM4))
and cp_payment_date is not null
group by to_char(cp_payment_date,''Mon YYYY''),to_number(to_char(cp_payment_date,''YYMM''))
order by to_number(to_char(cp_payment_date,''YYMM''))
', 'SchemeMonth', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (13, 259, 1, 'select null as link, substr(boq_item_name,instr(boq_item_name,''-'')+2,4) as "BOQ",
to_char(sum(boq_act_cost)/:P6_PARAM2*100,''990.99'') as "Percentage Spent"
from boq_items 
where boq_wol_id in (select wol_id from work_order_lines where wol_works_order_no in 
(select wor_works_order_no from work_orders where wor_con_id in 
(select con_id from contracts where con_contr_org_id in 
(select oun_org_id from org_units where oun_unit_code = :P6_PARAM1) 
and con_start_date <= sysdate
and con_end_date >= sysdate)
and wor_scheme_type = :P6_PARAM3))
and boq_act_cost > 0
and substr(boq_item_name,instr(boq_item_name,''-'')+2,4) like ''1%''
group by substr(boq_item_name,instr(boq_item_name,''-'')+2,4)
order by 1
', 'SchemeBOQ', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (16, 260, 1, 'select ''<a href="http://1csrvapp09.wiltshire.council:7779/discoverer/viewer?&db=highways&wbk=MP Detailed &#8211; Orders Available" target="_blank"> MP Detailed &#8211; Orders Available</a>'' as "Discoverer Reports" from dual
union
select ''<a href="http://1csrvapp09.wiltshire.council:7779/discoverer/viewer?&db=highways&wbk=WCC Payment Approval (Client)" target="_blank"> WCC Payment Approval (Client)</a>'' as "Discoverer Reports" from dual
union
select ''<a href="http://1csrvapp09.wiltshire.council:7779/discoverer/viewer?&db=highways&wbk=WCC Payment Run Report" target="_blank"> WCC Payment Run Report</a>'' as "Discoverer Reports" from dual
union
select ''<a href="http://1csrvapp09.wiltshire.council:7779/discoverer/viewer?&db=highways&wbk=Finance VO Report" target="_blank"> Finance VO Report</a>'' as "Discoverer Reports" from dual
union
select ''<a href="http://1csrvapp09.wiltshire.council:7779/discoverer/viewer?&db=highways&wbk=Full Detailed finance report" target="_blank"> Full Detailed finance report</a>'' as "Discoverer Reports" from dual
', 'disco', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (17, 261, 1, 'select wor.wor_works_order_no as "WO No",wor.wor_descr as "Job",wwo.raised_by(wor.wor_works_order_no) as"Client Officer",
wor.wor_contact as "Consultant",bud.bud_value as "Budget",boq.vo_value as "VO Value",wor.wor_est_cost as "Total Estimate",wor.wor_act_cost as "Spend to date",to_char(wor.wor_act_cost/wor.wor_est_cost*100,''990.99'') as "% Spend",wor.wor_est_cost-wor.wor_act_cost as "Variance",
payments.aprpaid as "Apr Paid",payments.aprcul as "Apr Cul",payments.maypaid as "May Paid",payments.MayCul as "May Cul",payments.junpaid as "Jun Paid",payments.JunCul as "Jun Cul",payments.julpaid as "Jul Paid",payments.JulCul as "Jul Cul",
payments.augpaid as "Aug Paid",payments.augcul as "Aug Cul",payments.seppaid as "Sep Paid",payments.SepCul as "Sep Cul",payments.Octpaid as "Oct Paid",payments.OctCul as "Oct Cul",payments.novpaid as "Nov Paid",payments.novCul as "Nov Cul",
payments.decpaid as "Dec Paid",payments.deccul as "Dec Cul",payments.janpaid as "Jan Paid",payments.janCul as "Jan Cul",payments.febpaid as "Feb Paid",payments.FebCul as "Feb Cul",payments.marpaid as "Mar Paid",payments.MarCul as "Mar Cul"
from work_orders wor,(select bud_value from budgets 
where bud_id in (select wol_bud_id from work_order_lines 
where wol_works_order_no = :P6_PARAM1)) bud,
(select sum(boq_act_cost) as vo_value from boq_items 
where boq_wol_id in (select wol_id from work_order_lines where wol_works_order_no = :P6_PARAM1) and boq_sta_item_code = ''VO'') boq,
(select (case when Substr(month,1,3) = ''Apr'' then sum(mth_payment) end) AprPaid,(case when Substr(month,1,3) = ''Apr'' then sum(ytd_payment) end) AprCul,
(case when Substr(month,1,3) = ''May'' then sum(mth_payment) end) MayPaid,(case when Substr(month,1,3) = ''May'' then sum(ytd_payment) end) maycul,
(case when Substr(month,1,3) = ''Jun'' then sum(mth_payment) end) JunPaid,(case when Substr(month,1,3) = ''Jun'' then sum(ytd_payment) end) JunCul,
(case when Substr(month,1,3) = ''Jul'' then sum(mth_payment) end) JulPaid,(case when Substr(month,1,3) = ''Jul'' then sum(ytd_payment) end) JulCul,
(case when Substr(month,1,3) = ''Aug'' then sum(mth_payment) end) AugPaid,(case when Substr(month,1,3) = ''Aug'' then sum(ytd_payment) end) AugCul,
(case when Substr(month,1,3) = ''Sep'' then sum(mth_payment) end) SepPaid,(case when Substr(month,1,3) = ''Sep'' then sum(ytd_payment) end) SepCul,
(case when Substr(month,1,3) = ''Oct'' then sum(mth_payment) end) OctPaid,(case when Substr(month,1,3) = ''Oct'' then sum(ytd_payment) end) OctCul,
(case when Substr(month,1,3) = ''Nov'' then sum(mth_payment) end) NovPaid,(case when Substr(month,1,3) = ''Nov'' then sum(ytd_payment) end) NovCul,
(case when Substr(month,1,3) = ''Dec'' then sum(mth_payment) end) DecPaid,(case when Substr(month,1,3) = ''Dec'' then sum(ytd_payment)end) DecCul,
(case when Substr(month,1,3) = ''Jan'' then sum(mth_payment) end) JanPaid,(case when Substr(month,1,3) = ''Jan'' then sum(ytd_payment) end) JanCul,
(case when Substr(month,1,3) = ''Feb'' then sum(mth_payment) end) FebPaid,(case when Substr(month,1,3) = ''Feb'' then sum(ytd_payment) end) FebCul,
(case when Substr(month,1,3) = ''Mar'' then sum(mth_payment) end) MarPaid,(case when Substr(month,1,3) = ''Mar'' then sum(ytd_payment) end) MarCul
from (select month,mth_payment,sum(mth_payment) over (partition by cp_wol_id order by to_number(to_char(to_date(month,''Mon YYYY''),''YYMM'')) rows 12 preceding) ytd_payment
from (select cp_wol_id,to_char(cp_payment_date,''Mon YYYY'') as month,sum(cp_payment_value) as mth_payment
from claim_payments
where cp_wol_id in (select wol_id from work_order_lines where wol_works_order_no = :P6_PARAM1)
and cp_payment_value > 0
group by cp_wol_id,to_char(cp_payment_date,''Mon YYYY''),to_number(to_char(cp_payment_date,''YYMM''))
order by to_number(to_char(cp_payment_date,''YYMM'')))
order by to_number(to_char(to_date(month,''Mon YYYY''),''YYMM''))) group by month) payments
where wor.wor_works_order_no = :P6_PARAM1
', 'mjr', 
    'Bar', 'Box');
Insert into IM_POD_SQL
   (IPS_ID, IPS_IP_ID, IPS_SEQ, IPS_SOURCE_CODE, IPS_NAME, IPS_TYPE, IPS_SHAPE_TYPE)
 Values
   (19, 262, 1, 'select null as link,adate month,nvl(last_value(sum(ytd_payment) ignore nulls) over (order by  to_number(to_char(to_date(adate,''Mon YYYY''),''YYMM''))),0) as total
from (select adate,mth_payment,sum(mth_payment) over (partition by cp_wol_id order by to_number(to_char(to_date(month,''Mon YYYY''),''YYMM'')) rows 12 preceding) ytd_payment
from (select cp_wol_id,to_char(cp_payment_date,''Mon YYYY'') as month,sum(cp_payment_value) as mth_payment
from claim_payments
where cp_wol_id in (select wol_id from work_order_lines where wol_works_order_no = :P6_PARAM1)
--and cp_payment_value > 0
group by cp_wol_id,to_char(cp_payment_date,''Mon YYYY''),to_number(to_char(cp_payment_date,''YYMM''))
order by to_number(to_char(cp_payment_date,''YYMM''))),(select distinct to_char((to_date(:P6_PARAM2))+level,''Mon YYYY'') as adate
from dual
connect by level <=365)
where month(+)=adate
order by to_number(to_char(to_date(month,''Mon YYYY''),''YYMM''))
)
group by adate,to_number(to_char(to_date(adate,''Mon YYYY''),''YYMM''))
order by to_number(to_char(to_date(adate,''Mon YYYY''),''YYMM''))', 'cumulative_act', 
    'Line', 'Box');
COMMIT;

