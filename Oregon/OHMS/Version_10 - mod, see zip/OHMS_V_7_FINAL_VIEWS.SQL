--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_501_F_SYSTEM
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_501_F_SYSTEM" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_501_F_System) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_502_URBAN_CODE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_502_URBAN_CODE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_502_Urban_Code) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_503_FACILITY_TY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_503_FACILITY_TY" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_503_Facility_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_504_STRUCTURE_T
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_504_STRUCTURE_T" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_504_Structure_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_507_THROUGH_LAN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_507_THROUGH_LAN"  AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
	
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
		
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
			
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_507_Through_Lanes) 
) 
 GROUP BY route_id, group_by_fld, value_numeric

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_508_HOV_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_508_HOV_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_508_HOV_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_509_HOV_LANES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_509_HOV_LANES" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_509_HOV_LANES) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_510_URBAN_SUB
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_510_URBAN_SUB" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_text
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_text
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_text
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_text = lag(value_text) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_510_Urban_Sub) 
) 
 GROUP BY route_id, group_by_fld, value_text 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_512_TURN_LANES_
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_512_TURN_LANES_" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_512_Turn_Lanes_R) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_513_TURN_LANES_
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_513_TURN_LANES_" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_513_Turn_Lanes_L) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_514_SPEED_LIMIT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_514_SPEED_LIMIT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_514_SPEED_LIMIT) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_521_AADT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_521_AADT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_521_AADT) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_522_AADT_SINGLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_522_AADT_SINGLE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_522_AADT_Single_Unit) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_523_PCT_PEAK_SI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_523_PCT_PEAK_SI" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_523_Pct_Peak_Single) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_524_AADT_COMBIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_524_AADT_COMBIN" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_524_AADT_Combination) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_525_PCT_PEAK_CO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_525_PCT_PEAK_CO" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_525_Pct_Peak_Combinat) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_526_K_FACTOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_526_K_FACTOR" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_526_K_Factor) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_527_DIR_FACTOR
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_527_DIR_FACTOR" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_527_Dir_Factor) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_528_FUTURE_AADT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_528_FUTURE_AADT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "VALUE_DATE") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , value_date
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , value_date
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , value_date
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND value_date = lag(value_date) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_528_Future_AADT) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, value_date 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_531_NUMBER_SIGN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_531_NUMBER_SIGN" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_531_Number_Signals) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_532_STOP_SIGNS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_532_STOP_SIGNS" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_532_Stop_Signs) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_533_AT_GRADE_OT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_533_AT_GRADE_OT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_533_At_Grade_Other) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_534_LANE_WIDTH
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_534_LANE_WIDTH" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_534_Lane_Width) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_535_MEDIAN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_535_MEDIAN_TYPE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_535_Median_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_536_MEDIAN_WIDT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_536_MEDIAN_WIDT" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_536_Median_Width) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_537_SHOULDER_TY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_537_SHOULDER_TY" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_537_Shoulder_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_538_SHOULDER_WI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_538_SHOULDER_WI" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_538_Shoulder_Width_R) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_539_SHOULDER_WI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_539_SHOULDER_WI" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_539_Shoulder_Width_L) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_540_PEAK_PARK_R
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_540_PEAK_PARK_R" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_text
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_text
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_text
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_text = lag(value_text) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_540_Peak_Park_Right) 
) 
 GROUP BY route_id, group_by_fld, value_text 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_544_TERRAIN_TYP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_544_TERRAIN_TYP" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_544_Terrain_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_549_SURFACE_TYP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_549_SURFACE_TYP" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_549_Surface_Type) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_556_LAST_OVERLA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_556_LAST_OVERLA" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_556_LAST_OVERLAY_THIC) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_557_THICKNESS_R
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_557_THICKNESS_R" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_557_Thickness_Rigid) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_558_THICKNESS_F
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_558_THICKNESS_F" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_558_Thickness_Flexibl) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_565_OREGON_FREI
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_565_OREGON_FREI" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_565_Oregon_Freight_Ro) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_566_REGION_DIST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_566_REGION_DIST" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_text
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_text
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_text
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_text = lag(value_text) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_566_Region_District) 
) 
 GROUP BY route_id, group_by_fld, value_text 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_567_PMS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_567_PMS" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_567_PMS) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;

--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_581_HPMS_SAMPLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_581_HPMS_SAMPLE" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_TEXT") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_text
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_text
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_text
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_text = lag(value_text) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_581_HPMS_Sample_ID) 
) 
 GROUP BY route_id, group_by_fld, value_text 

;





--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_640_PEAK_PARKIN
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_640_PEAK_PARKIN" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_640_Peak_Parking) 
) 
 GROUP BY route_id, group_by_fld 

;



--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_743_CURVES_A
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_743_CURVES_A" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_743_CURVES_A) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_744_CURVES_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_744_CURVES_B" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_744_CURVES_B) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_745_CURVES_C
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_745_CURVES_C" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_745_CURVES_C) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_746_CURVES_D
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_746_CURVES_D" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_746_CURVES_D) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_747_CURVES_E
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_747_CURVES_E" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_747_CURVES_E) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_748_CURVES_F
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_748_CURVES_F" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_748_CURVES_F) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_749_GRADES_A
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_749_GRADES_A" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_749_GRADES_A) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_750_GRADES_B
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_750_GRADES_B" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_750_GRADES_B) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_751_GRADES_C
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_751_GRADES_C" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_751_GRADES_C) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_752_GRADES_D
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_752_GRADES_D" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_752_GRADES_D) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_753_GRADES_E
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_753_GRADES_E" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_753_GRADES_E) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_754_GRADES_F
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_754_GRADES_F" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC", "COMMENTS") AS 
  SELECT route_id 
    , min(begin_point) begin_point 
    , max(end_point) end_point 
    , max(end_point) - min(begin_point) section_length  
    , value_numeric
    , comments
 FROM ( 
    SELECT route_id 
        , begin_point 
        , end_point 
        , value_numeric
        , comments
        , break_point 
        , sum(break_point) over (partition by route_id order by route_id, begin_point) group_by_fld 
    FROM 
        (SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , comments
            , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                AND comments = lag(comments) over (order by route_id, begin_point)
                THEN 0 
            ELSE 
                1 
            END break_point 
        FROM V_OHMS_7_754_GRADES_F) 
) 
 GROUP BY route_id, group_by_fld, value_numeric, comments 

;
