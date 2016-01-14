Select
 'javascript:doDrillDown( ''IM41021'', '''||x.range_value||''');' as link,
 x.range_value, NVL(data.cnt,0) as rec_count
From
        (
        Select r.range_value, count(*) cnt
        from work_due_to_be_cmp_no_def_base w, POD_DAY_RANGE_REV r
        where work_order_status in ('DRAFT','INSTRUCTED')
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,'0-24',1,'24-72',2,'Late',3))



Select
 'javascript:doDrillDown( ''IM41022'', '''||x.range_value||''',
 '''||'LS'||''');' as link,
 x.range_value, NVL(data.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from work_due_to_be_comp_base w, POD_DAY_RANGE_REV r
        where work_order_status in ('DRAFT','INSTRUCTED')
        and contract = 'LS'
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,'0-24',1,'24-72',2,'Late',3))


Select
 'javascript:doDrillDown( ''IM41022'', '''||x.range_value||''',
 '''||'OT'||''');' as link,
 x.range_value, NVL(data.cnt,0)
From
        (
        Select r.range_value, count(*) cnt
        from work_due_to_be_comp_base w, POD_DAY_RANGE_REV r
        where work_order_status in ('DRAFT','INSTRUCTED')
        and contract != 'LS'
        and due_date between r.st_range and r.end_range
        group by  r.range_value
        ) data,
        POD_DAY_RANGE_REV x
where  data.range_value(+) = x.range_value
order by (decode(range_value,'0-24',1,'24-72',2,'Late',3))