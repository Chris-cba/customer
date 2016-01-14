Create or replace view X_LOHAC_DateRANGE_WODC as
        SELECT 0 sorter,
            trunc(SYSDATE)-360                st_range,
            trunc(SYSDATE)  - (1/86400)     end_range,
            'Late'                     range_value
        FROM DUAL
    UNION
        SELECT 1 sorter,
        trunc(SYSDATE) + 0                st_range,
        trunc(SYSDATE) + 1 - (1/86400) end_range,
        '0-1'                     range_value
    FROM DUAL
    UNION
        SELECT 2 sorter,
        trunc(SYSDATE) +1                st_range,
        trunc(SYSDATE)  +1+ 3 - (1/86400)    end_range,
        '1-3'                     range_value
    FROM DUAL
    UNION
        SELECT 3 sorter,
        trunc(SYSDATE) +3 +1               st_range,
        trunc(SYSDATE)  + 1+10 - (1/86400)    end_range,
        '3-10'                     range_value
    FROM DUAL    
        UNION
        SELECT 4 sorter,
        trunc(SYSDATE) +1+10                st_range,
        trunc(SYSDATE)  + 360 - (1/86400)    end_range,
        '>10'                     range_value
    FROM DUAL
;

