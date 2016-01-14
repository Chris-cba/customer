Create or replace view X_LOHAC_DateRANGE_WOWT003 as
        SELECT 1 sorter,
        trunc(SYSDATE) - 2                st_range,
        trunc(SYSDATE) + 1 - (1/86400) end_range,
        '0-2'                     range_value
    FROM DUAL
    UNION
        SELECT 2 sorter,
        trunc(SYSDATE) - 5                st_range,
        trunc(SYSDATE) +1 - 3 - (1/86400)    end_range,
        '3-5'                     range_value
    FROM DUAL
    UNION
        SELECT 3 sorter,
        trunc(SYSDATE) - 30                st_range,
        trunc(SYSDATE) +1 - 6 - (1/86400)    end_range,
        '6-30'                     range_value
        from dual
    UNION
        SELECT 4 sorter,
        trunc(SYSDATE) - 360                st_range,
        trunc(SYSDATE)  - 30 - (1/86400)    end_range,
        '>30'                     range_value
        from dual
;