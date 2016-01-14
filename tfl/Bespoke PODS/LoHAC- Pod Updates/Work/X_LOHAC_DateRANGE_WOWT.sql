Create or replace view X_LOHAC_DateRANGE_WOWT as
        SELECT 1 sorter,
        trunc(SYSDATE) - 1                st_range,
        trunc(SYSDATE) +1- 0 - (1/86400) end_range,
        '0-1'                     range_value
    FROM DUAL
    UNION
        SELECT 2 sorter,
        trunc(SYSDATE) - 7                st_range,
        trunc(SYSDATE)  - 1 - (1/86400)    end_range,
        '2-7'                     range_value
    FROM DUAL
    UNION
        SELECT 3 sorter,        
        trunc(SYSDATE)  - 360     st_range,
        trunc(SYSDATE) - 7      - (1/86400)          end_range,
        '>7'                     range_value
        from dual
        ;


