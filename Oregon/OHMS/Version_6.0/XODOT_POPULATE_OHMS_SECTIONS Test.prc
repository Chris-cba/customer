CREATE OR REPLACE PROCEDURE XODOT_POPULATE_OHMS_SECTIONS IS 
/**************************************************************
   Code version 7.6u
**************************************************************
   
   This procedure was auto-generated:
        Date/Time:  01-SEP-11 18.53.50.140000        User:       TRANSINFO        
**************************************************************
   Standard Error Reporting Variables
**************************************************************/
 
t_error                 VARCHAR2(200);
t_error_desc            VARCHAR2(200);
t_error_msg             VARCHAR2(300);
t_item_processing       VARCHAR2(10);
t_item_descr            VARCHAR2(100);
t_hal_id                NUMBER;
t_table_id              NUMBER;
t_timestamp             TIMESTAMP;
 
t_sysdate               DATE;
t_user                  VARCHAR2(32);
t_target_table_name     HPMS_PROCEDURE.HP_DB_TABLE_NAME%TYPE;
is_complete             EXCEPTION;
 
/***************************************************************
   Cursor Definitions
***************************************************************/
 
CURSOR CUR_501 IS 
SELECT * FROM V_OHMS_FINAL_7_501_F_System;

CURSOR CUR_502 IS 
SELECT * FROM V_OHMS_FINAL_7_502_Urban_Code;

CURSOR CUR_503 IS 
SELECT * FROM V_OHMS_FINAL_7_503_Facility_Ty;

CURSOR CUR_504 IS 
SELECT * FROM V_OHMS_FINAL_7_504_Structure_T;

CURSOR CUR_507 IS 
SELECT * FROM V_OHMS_FINAL_7_507_Through_Lan;

CURSOR CUR_508 IS 
SELECT * FROM V_OHMS_FINAL_7_508_HOV_Type;

CURSOR CUR_509 IS 
SELECT * FROM V_OHMS_FINAL_7_509_HOV_LANES;

CURSOR CUR_510 IS 
SELECT * FROM V_OHMS_FINAL_7_510_Urban_Sub;

CURSOR CUR_512 IS 
SELECT * FROM V_OHMS_FINAL_7_512_Turn_Lanes_;

CURSOR CUR_513 IS 
SELECT * FROM V_OHMS_FINAL_7_513_Turn_Lanes_;

CURSOR CUR_514 IS 
SELECT * FROM V_OHMS_FINAL_7_514_SPEED_LIMIT;

CURSOR CUR_521 IS 
SELECT * FROM V_OHMS_FINAL_7_521_AADT;

CURSOR CUR_522 IS 
SELECT * FROM V_OHMS_FINAL_7_522_AADT_Single;

CURSOR CUR_523 IS 
SELECT * FROM V_OHMS_FINAL_7_523_Pct_Peak_Si;

CURSOR CUR_524 IS 
SELECT * FROM V_OHMS_FINAL_7_524_AADT_Combin;

CURSOR CUR_525 IS 
SELECT * FROM V_OHMS_FINAL_7_525_Pct_Peak_Co;

CURSOR CUR_526 IS 
SELECT * FROM V_OHMS_FINAL_7_526_K_Factor;

CURSOR CUR_527 IS 
SELECT * FROM V_OHMS_FINAL_7_527_Dir_Factor;

CURSOR CUR_528 IS 
SELECT * FROM V_OHMS_FINAL_7_528_Future_AADT;

CURSOR CUR_531 IS 
SELECT * FROM V_OHMS_FINAL_7_531_Number_Sign;

CURSOR CUR_532 IS 
SELECT * FROM V_OHMS_FINAL_7_532_Stop_Signs;

CURSOR CUR_533 IS 
SELECT * FROM V_OHMS_FINAL_7_533_At_Grade_Ot;

CURSOR CUR_534 IS 
SELECT * FROM V_OHMS_FINAL_7_534_Lane_Width;

CURSOR CUR_535 IS 
SELECT * FROM V_OHMS_FINAL_7_535_Median_Type;

CURSOR CUR_536 IS 
SELECT * FROM V_OHMS_FINAL_7_536_Median_Widt;

CURSOR CUR_537 IS 
SELECT * FROM V_OHMS_FINAL_7_537_Shoulder_Ty;

CURSOR CUR_538 IS 
SELECT * FROM V_OHMS_FINAL_7_538_Shoulder_Wi;

CURSOR CUR_539 IS 
SELECT * FROM V_OHMS_FINAL_7_539_Shoulder_Wi;

CURSOR CUR_540 IS 
SELECT * FROM V_OHMS_FINAL_7_540_Peak_Park_R;

CURSOR CUR_544 IS 
SELECT * FROM V_OHMS_FINAL_7_544_Terrain_Typ;

CURSOR CUR_549 IS 
SELECT * FROM V_OHMS_FINAL_7_549_Surface_Typ;

CURSOR CUR_556 IS 
SELECT * FROM V_OHMS_FINAL_7_556_LAST_OVERLA;

CURSOR CUR_557 IS 
SELECT * FROM V_OHMS_FINAL_7_557_Thickness_R;

CURSOR CUR_558 IS 
SELECT * FROM V_OHMS_FINAL_7_558_Thickness_F;

CURSOR CUR_565 IS 
SELECT * FROM V_OHMS_FINAL_7_565_Oregon_Frei;

CURSOR CUR_566 IS 
SELECT * FROM V_OHMS_FINAL_7_566_Region_Dist;

CURSOR CUR_567 IS 
SELECT * FROM V_OHMS_FINAL_7_567_PMS;

CURSOR CUR_610 IS 
SELECT * FROM V_OHMS_FINAL_7_610_Peak_Lanes;

CURSOR CUR_611 IS 
SELECT * FROM V_OHMS_FINAL_7_611_Counter_Pea;

CURSOR CUR_640 IS 
SELECT * FROM V_OHMS_FINAL_7_640_Peak_Parkin;

CURSOR CUR_743 IS 
SELECT * FROM V_OHMS_FINAL_7_743_CURVES_A;

CURSOR CUR_745 IS 
SELECT * FROM V_OHMS_FINAL_7_745_CURVES_C;

/***************************************************************
   Column Variables
***************************************************************/

t_year_record_var   NUMBER(4);
t_state_code_var   NUMBER(2);
t_route_id_var    VARCHAR2(32);
t_begin_point_var   NUMBER(8,3);
t_end_point_var    NUMBER(8,3);
t_data_item_var    VARCHAR2(25);
t_section_length_var  NUMBER(8,3);
t_value_numeric_var   NUMBER;
t_value_text_var   VARCHAR2(50);
t_value_date_var   DATE;
t_comments_var    VARCHAR2(50);
 
/***************************************************************
   Procedure BEGIN
***************************************************************/
BEGIN
        t_error                 := NULL;
        t_error_desc            := NULL;
        t_table_id              := 7; 
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;
 
/***************************************************************
   Prepare the Target Table
***************************************************************/

        DELETE FROM OHMS_SUBMIT_SECTIONS;

        COMMIT;
 

/******************************************************
         Processing Cursor #503: Facility_Type
******************************************************/
    BEGIN
        t_year_record_var    := NULL;
        t_state_code_var    := NULL;
        t_route_id_var     := NULL;
        t_begin_point_var    := NULL;
        t_end_point_var     := NULL;
        t_data_item_var     := NULL;
        t_section_length_var   := NULL;
        t_value_numeric_var    := NULL;
        t_value_text_var    := NULL;
        t_value_date_var    := NULL;
        t_comments_var     := NULL;


        SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;


        SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

        t_data_item_var     := 'Facility_Type';
        t_item_descr     := 'Facility_Type';

        FOR c_503 IN cur_503 LOOP
            t_route_id_var    := c_503.ROUTE_ID;
            t_begin_point_var   := c_503.BEGIN_POINT;
            t_end_point_var    := c_503.END_POINT;
            t_section_length_var  := c_503.SECTION_LENGTH;
            t_value_numeric_var   := c_503.VALUE_NUMERIC;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;

/***************************************************************
   Procedure Exception/End
***************************************************************/
 
EXCEPTION 
WHEN IS_COMPLETE THEN 
        RAISE_APPLICATION_ERROR( -20000,'Generation Complete');
WHEN OTHERS THEN
        t_error             := sqlcode;
        t_error_desc        := substr(sqlerrm,1,400);
 
        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;
 
        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID
                , HAL_DATE
                , HAL_USER
                , HAL_TABLE_ID
                , HAL_STATUS
                , HAL_ERROR
                , HAL_MESSAGE)
        VALUES (t_hal_id
                , t_sysdate
                , t_user
                , t_table_id
                , 'ERROR'
                , t_error
                , t_error_desc);
        COMMIT;
    RAISE_APPLICATION_ERROR( -20000,'Generation Failed');
END;
/
