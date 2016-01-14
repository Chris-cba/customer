select 'javascript:showWOWTDrillDown(512,null, ''13'', ''P13_DAYS'', '||''''|| dr.range_value ||''''||' , ''P13_PRIORITY'', '''||code||''', null,null, null,null,null,null);' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, 'LS' Code, count(*) CNT 
        from  X_WO_TFL_WT_IM511003_ALL, X_LOHAC_DateRANGE_WOWT003 dr
        where con_code in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter



select 'javascript:showWOWTDrillDown(512,null, ''3'', ''P3_DAYS'', '||''''|| dr.range_value ||''''||' , ''P3_PRIORITY'', '''||code||''', null,null, null,null,null,null);' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, 'NONLS' Code, count(*) CNT 
        from  X_WO_TFL_WT_IM511003_ALL, X_LOHAC_DateRANGE_WOWT003 dr
        where con_code not in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter


--No bud

select 'javascript:showWOWTDrillDown(512,null, ''23'', ''P23_DAYS'', '||''''|| dr.range_value ||''''||' , ''P23_PRIORITY'', '''||code||''', null,null, null,null,null,null);' as link
,  dr.range_value
,  nvl(CNT, 0) CNT
from 
    (select   range_value, 'TOR' Code, count(*) CNT 
        from  X_WO_TFL_WT_IM511003_NOBUD, X_LOHAC_DateRANGE_WOWT003 dr
        where 1=1 
        --and con_code not in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
        and date_raised between dr.ST_RANGE and dr.end_RANGE
        group by  range_value)x
, X_LOHAC_DateRANGE_WOWT003 dr
--
where 1=1
and x.range_value(+)=dr.range_value
--
order by sorter
