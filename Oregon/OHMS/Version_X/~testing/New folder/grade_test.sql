Select a.*, (nvl(GRADE_A, 0) +nvl(GRADE_B, 0) +nvl(GRADE_C, 0) +nvl(GRADE_D, 0) +nvl(GRADE_E, 0) + nvl(GRADE_F, 0)) Tot_grade

from 
(select ROUTE_ID, BEGIN_POINT, END_POINT, SECTION_LENGTH,
        max(DECODE(DATA_ITEM, 'GRADES_A', Value_numeric, null)) GRADE_A
        , max(DECODE(DATA_ITEM, 'GRADES_B', Value_numeric, null)) GRADE_B
        , max(DECODE(DATA_ITEM, 'GRADES_C', Value_numeric, null)) GRADE_C
        , max(DECODE(DATA_ITEM, 'GRADES_D', Value_numeric, null)) GRADE_D
        , max(DECODE(DATA_ITEM, 'GRADES_E', Value_numeric, null)) GRADE_E
        , max(DECODE(data_item, 'GRADES_F', Value_numeric, null)) GRADE_F
        
        from
        OHMS_SUBMIT_SECTIONS
        
        group by ROUTE_ID, BEGIN_POINT, END_POINT, SECTION_LENGTH
        
        ) a
        ;