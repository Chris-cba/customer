
--------------------------------------------------------
--  DDL for View V_OHMS_7_610_PEAK_LANES
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_7_610_PEAK_LANES"  AS 



with OHMS_7_network_mv_f

as
(  
     select 
          NE_ID_OF,
          BMP,
          EMP,          
          ne_unique,
--          nm_slk,
--          NM_END_SLK,
          FACL,
          
          case when FACL_BREAK = 1
          then
              case when BMP = MIN_BMP then NM_SLK
                else NM_SLK + BMP end
          else
            NM_SLK
          end nm_slk,
          
          case when FACL_BREAK = 1
          then
              case when EMP = MAX_EMP then NM_END_SLK
                else NM_SLK + (EMP-BMP) end
          else
            NM_END_SLK
          end NM_END_SLK  
     from 
     
     (      
     
     
          select 
              --  Applies the requirement for FACL = 1,2,3
              B.NM_NE_ID_OF NE_ID_OF,
              D.NM_BEGIN_MP BMP,
              D.NM_END_MP EMP,          
              a.ne_unique,
              b.nm_slk,
              B.NM_END_SLK,
              E.IIT_NUM_ATTRIB100 FACL,
              case when  (D.NM_END_MP -  D.NM_BEGIN_MP <>  B.NM_END_SLK - B.NM_SLK) then 1 else 0 end FACL_BREAK,
              min(D.NM_BEGIN_MP) over (partition by B.NM_NE_ID_OF)  MIN_BMP,
              max(D.NM_END_MP) over (partition by B.NM_NE_ID_OF)  MAX_EMP     
              
              
              FROM V_NM_HWY_NT a
                , nm_members b
                , NM_ELEMENTS C
                , NM_MEMBERS D
                , NM_INV_ITEMS E
                
                 
              WHERE 1=1
                and a.ne_id = b.nm_ne_id_in 
                and B.NM_NE_ID_OF = C.NE_ID
                and C.NE_ID = D.NM_NE_ID_OF
                and D.NM_NE_ID_IN = E.IIT_NE_ID
                and B.NM_OBJ_TYPE = 'HWY'
                and D.NM_OBJ_TYPE = 'FACL'        
                and E.iit_num_attrib100 in (1, 2, 3)
                AND b.nm_type = 'G'
                and C.NE_TYPE = 'S'
                and a.MILEAGE_TYPE <> 'P'
                
                ) a
    
)


,TL_SUB as
(
        SELECT      rdgm.ne_unique ROUTE_ID
        ,greatest(rdgm.nm_slk, b. nm_slk) BEGIN_POINT
        ,least(rdgm.nm_end_slk, b. nm_end_slk) END_POINT
        ,RDGM.LN_MEDN_TYP_CD VALUE_NUMERIC
        , B.FACL FACL

        
      
    FROM
        V_NM_RDGM507_COUNT_MV_NW RDGM
        , OHMS_7_network_mv_f b
    WHERE rdgm.ne_unique = b.ne_unique
        AND rdgm.nm_slk < b.nm_end_slk
        and RDGM.NM_END_SLK > B.NM_SLK 
)

, TL_FINAL as
  (
        SELECT route_id 
        , min(begin_point) begin_point 
        , max(end_point) end_point 
        , max(END_POINT) - min(BEGIN_POINT) SECTION_LENGTH      
        , FACL

        , value_numeric
      
     FROM ( 
        SELECT route_id 
            , begin_point 
            , end_point 
            , value_numeric
            , FACL

            , BREAK_POINT 
            , sum(break_point) over (partition by route_id, facl order by route_id, begin_point, facl) group_by_fld 

        FROM 
            (SELECT route_id 
                , begin_point 
                , end_point 
                , value_numeric
                , FACL


                , CASE WHEN (route_id) = lag(route_id) over (order by route_id, begin_point) AND 
                    round(begin_point,2) = lag(round(end_point,2)) over (order by route_id, begin_point)
                    AND value_numeric = lag(value_numeric) over (order by route_id, begin_point)
                    THEN 0 
                ELSE 
                    1 
                END break_point 
            FROM TL_SUB) 
    ) 
     group by ROUTE_ID, GROUP_BY_FLD, VALUE_NUMERIC, FACL
 )


, PL_SUB as
(
  SELECT   route_id
        , begin_point
        , END_POINT
        
        
        --, END_POINT - BEGIN_POINT SECTION_LENGTH
        , case when FACL in (1,3) then SUB7_VALUE_NUMERIC
          
          else
        
              case 
              WHEN SUB10_VALUE_TEXT IS NOT NULL THEN
                  ROUND(SUB7_VALUE_NUMERIC/2)
              WHEN SUB7_VALUE_NUMERIC <= 3 AND SUB10_VALUE_TEXT IS NULL THEN
                  SUB7_VALUE_NUMERIC
              ELSE
                  ROUND(SUB7_VALUE_NUMERIC/2)
              end 
          end VALUE_NUMERIC
        , SUB7_VALUE_NUMERIC TL_VALUE_NUMERIC
        , FACL
        , SUB10_VALUE_TEXT Urbn
        

        
  FROM (
        SELECT 
            s.route_id
            , s.begin_point
            , s.end_point
            , SUB7.VALUE_NUMERIC SUB7_VALUE_NUMERIC
            , SUB10.VALUE_TEXT SUB10_VALUE_TEXT
            , SUB7.FACL

            
        FROM 
             (SELECT *
              FROM (
                     SELECT route_id
                          , pte begin_point
                          , CASE WHEN route_id = lead (route_id) over (order by route_id, pte) AND
                                      pte < lead(pte) over (order by route_id, pte) THEN
                                              lead(pte) over (order by route_id, pte)
                                 ELSE
                                      -99 
                            END end_point
                     FROM (    
                          select distinct ROUTE_ID, PTE from (
                          SELECT route_id, begin_point pte FROM TL_FINAL
                          UNION
                          SELECT route_id, end_point pte FROM TL_FINAL
                          UNION
                          SELECT route_id, begin_point pte FROM V_OHMS_FINAL_7_510_Urban_Sub
                          union
                          SELECT route_id, end_point pte FROM V_OHMS_FINAL_7_510_Urban_Sub
                          )))
              where END_POINT <> -99) S
            , TL_FINAL SUB7
            , V_OHMS_FINAL_7_510_Urban_Sub SUB10
        WHERE 1=1
            AND  s.route_id = SUB7.route_id(+)
            AND  s.begin_point < SUB7.end_point(+)
            AND  s.end_point > SUB7.begin_point(+)
            AND  s.route_id = SUB10.route_id(+)
            AND  s.begin_point < SUB10.end_point(+)
            AND  s.end_point > SUB10.begin_point(+)
        )
    WHERE 1 = 1
          AND SUB7_VALUE_NUMERIC IS NOT NULL
		  
)
  select * from PL_SUB

;

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

--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_610_PEAK_LANES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_610_PEAK_LANES" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
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
        FROM V_OHMS_7_610_Peak_Lanes) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
--------------------------------------------------------
--  DDL for View V_OHMS_FINAL_7_611_COUNTER_PEA
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "TRANSINFO"."V_OHMS_FINAL_7_611_COUNTER_PEA" ("ROUTE_ID", "BEGIN_POINT", "END_POINT", "SECTION_LENGTH", "VALUE_NUMERIC") AS 
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
        FROM V_OHMS_7_611_COUNTER_PEAK_LANE) 
) 
 GROUP BY route_id, group_by_fld, value_numeric 

;
   