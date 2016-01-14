Create or replace view X_LOHAC_DateRANGE_WK as
   SELECT 0 sorter,
           SYSDATE st_range,
          SYSDATE - 1 - (1/86400) end_range,
          '0-1' range_value
     FROM DUAL
   UNION
   SELECT 1 sorter, 
   SYSDATE - 1 st_range,
          SYSDATE - 7- (1/86400) end_range,
          '2-7' range_value
     FROM DUAL
   UNION
   SELECT  2 sorter ,
   SYSDATE - 7 st_range,
          SYSDATE - 1400 end_range,
          'Late' range_value
     FROM DUAL
;

