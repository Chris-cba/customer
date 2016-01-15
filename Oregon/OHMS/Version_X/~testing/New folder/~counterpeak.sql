--------------------------------------------------------
--  DDL for View V_OHMS_7_611_COUNTER_PEAK_LANE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_611_COUNTER_PEAK_LANE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT   route_id
        , begin_point
        , end_point
        , end_point - begin_point section_length
        , a.TL_VALUE_NUMERIC - a.VALUE_NUMERIC VALUE_NUMERIC
    FROM	V_OHMS_7_610_PEAK_LANES a
        
    WHERE 1 = 1
          AND a.VALUE_NUMERIC IS NOT NULL
          
           
;
