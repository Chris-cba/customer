Select
 'javascript:doDrillDown( ''IM41021'', '''||x.range_value||''');' as link,
 x.range_value, NVL(d.cnt,0) as rec_count
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in ('DRAFT','INSTRUCTED')
		and CONTRACT <> 'SC'
		and WOL_DEF_DEFECT_ID is null
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) d,
        X_LOHAC_DateRANGE_WODC x
where  d.range_value(+) = x.range_value
order by sorter       



Select
 'javascript:doDrillDown( ''IM41022'', '''||x.range_value||''',
 '''||'LS'||''');' as link,
 x.range_value, NVL(d.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in ('DRAFT','INSTRUCTED')
        and CONTRACT in ('HLSC', 'HLSR', 'SLSC', 'SLSR')
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) d,
        X_LOHAC_DateRANGE_WODC x
where  d.range_value(+) = x.range_value
order by sorter



Select
 'javascript:doDrillDown( ''IM41023'', '''||x.range_value||''',
 '''||'OT'||''');' as link,
 x.range_value, NVL(d.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from WORK_DUE_TO_BE_CMP_NO_DF_CHILD w, X_LOHAC_DateRANGE_WODC r
        where work_order_status in ('DRAFT','INSTRUCTED')
        and CONTRACT in ('HR', 'HTO', 'SMCI', 'SR', 'STO')
        and target_date between r.st_range and r.end_range
        group by  r.range_value
        ) d,
        X_LOHAC_DateRANGE_WODC x
where  d.range_value(+) = x.range_value
order by sorter