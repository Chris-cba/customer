Create or replace view X_LOHAC_DateRANGE_WK as
   SELECT 0 sorter,
           trunc(SYSDATE) + 1  - (1/86400) end_range,
          trunc(SYSDATE)  - 1  st_range,
          '0-1' range_value
     FROM DUAL
   UNION
   SELECT 1 sorter, 
   trunc(SYSDATE) - 1 - (1/86400) end_range,
          trunc(SYSDATE) - 7 start_range,
          '2-7' range_value
     FROM DUAL
   UNION
   SELECT  2 sorter ,
   trunc(SYSDATE) - 7 - (1/86400) end_range,
          trunc(SYSDATE) - 1400 st_range,
          'Late' range_value
     FROM DUAL
     
;

