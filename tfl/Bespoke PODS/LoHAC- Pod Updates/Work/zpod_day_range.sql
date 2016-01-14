DROP VIEW HIGHWAYS.POD_DAY_RANGE;

/* Formatted on 23/04/2013 14:10:52 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW HIGHWAYS.POD_DAY_RANGE
(
   RANGE_ID,
   ST_RANGE,
   END_RANGE,
   RANGE_VALUE
)
AS
   SELECT 1 RANGE_ID,
          TRUNC (SYSDATE) st_range,
          TRUNC (SYSDATE) + 1 end_range,
          'Today' range_value
     FROM DUAL
   UNION
   SELECT 2 RANGE_ID,
          TRUNC (SYSDATE) - 6 st_range,
          TRUNC (SYSDATE) - (1 / (24 * 60 * 60)) end_range,
          '1-6' range_value
     FROM DUAL
   UNION
   SELECT 3 RANGE_ID,
          TRUNC (SYSDATE) - 29 st_range,
          TRUNC (SYSDATE) - 6 - (1 / (24 * 60 * 60)) end_range,
          '7-30' range_value
     FROM DUAL
   UNION
   SELECT 4 RANGE_ID,
          TRUNC (SYSDATE) - 59 st_range,
          TRUNC (SYSDATE) - 29 - (1 / (24 * 60 * 60)) end_range,
          '31-60' range_value
     FROM DUAL
   UNION
   SELECT 5 RANGE_ID,
          TRUNC (SYSDATE) - 89 st_range,
          TRUNC (SYSDATE) - 59 - (1 / (24 * 60 * 60)) end_range,
          '61-90' range_value
     FROM DUAL;


DROP PUBLIC SYNONYM POD_DAY_RANGE;

CREATE OR REPLACE PUBLIC SYNONYM POD_DAY_RANGE FOR HIGHWAYS.POD_DAY_RANGE;
