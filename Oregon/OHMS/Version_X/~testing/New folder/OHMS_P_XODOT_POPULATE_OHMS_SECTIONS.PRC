CREATE OR REPLACE PROCEDURE XODOT_POPULATE_OHMS_grad IS 
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

--CURSOR CUR_531 IS 
--SELECT * FROM V_OHMS_FINAL_7_531_Number_Sign;

CURSOR CUR_531 IS
select SAMPLE_ID, SECTION_LENGTH, BEGIN_POINT, END_POINT, ROUTE_ID, STATE_CODE 
    , OHMS_SIGNAL_CNT(ROUTE_ID, BEGIN_POINT, END_POINT) VALUE_NUMERIC
from OHMS_SUBMIT_SAMPLES;

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

CURSOR CUR_581 IS
select * from V_OHMS_FINAL_7_581_HPMS_SAMPLE;

CURSOR CUR_610 IS 
SELECT * FROM V_OHMS_FINAL_7_610_Peak_Lanes;

CURSOR CUR_611 IS 
SELECT * FROM V_OHMS_FINAL_7_611_Counter_Pea;

CURSOR CUR_640 IS 
SELECT * FROM V_OHMS_FINAL_7_640_Peak_Parkin;

 
CURSOR CUR_743 IS 
SELECT * FROM V_OHMS_FINAL_7_743_CURVES_A;

CURSOR CUR_744 IS 
SELECT * FROM V_OHMS_FINAL_7_744_CURVES_B;

CURSOR CUR_745 IS 
SELECT * FROM V_OHMS_FINAL_7_745_CURVES_C;

CURSOR CUR_746 IS 
SELECT * FROM V_OHMS_FINAL_7_746_CURVES_D;

CURSOR CUR_747 IS 
SELECT * FROM V_OHMS_FINAL_7_747_CURVES_E;

CURSOR CUR_748 IS 
SELECT * FROM V_OHMS_FINAL_7_748_CURVES_F;


CURSOR CUR_749 IS 
SELECT * FROM V_OHMS_FINAL_7_749_GRADES_A;

CURSOR CUR_750 IS 
SELECT * FROM V_OHMS_FINAL_7_750_GRADES_B;

CURSOR CUR_751 IS 
SELECT * FROM V_OHMS_FINAL_7_751_GRADES_C;

CURSOR CUR_752 IS 
SELECT * FROM V_OHMS_FINAL_7_752_GRADES_D;

CURSOR CUR_753 IS 
SELECT * FROM V_OHMS_FINAL_7_753_GRADES_E;

CURSOR CUR_754 IS 
SELECT * FROM V_OHMS_FINAL_7_754_GRADES_F;

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
         Processing Cursor #749: GRADES_A
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

        t_data_item_var     := 'GRADES_A';
        t_item_descr     := 'GRADES_A';

        FOR c_749 IN cur_749 LOOP
            t_route_id_var    := c_749.ROUTE_ID;
            t_begin_point_var   := c_749.BEGIN_POINT;
            t_end_point_var    := c_749.END_POINT;
            t_section_length_var  := c_749.SECTION_LENGTH;
            t_value_numeric_var   := c_749.VALUE_NUMERIC;
            --t_comments_var    := c_749.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;
/******************************************************
         Processing Cursor #750: GRADES_B
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

        t_data_item_var     := 'GRADES_B';
        t_item_descr     := 'GRADES_B';

        FOR c_750 IN cur_750 LOOP
            t_route_id_var    := c_750.ROUTE_ID;
            t_begin_point_var   := c_750.BEGIN_POINT;
            t_end_point_var    := c_750.END_POINT;
            t_section_length_var  := c_750.SECTION_LENGTH;
            t_value_numeric_var   := c_750.VALUE_NUMERIC;
            --t_comments_var    := c_750.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;
/******************************************************
         Processing Cursor #751: GRADES_C
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

        t_data_item_var     := 'GRADES_C';
        t_item_descr     := 'GRADES_C';

        FOR c_751 IN cur_751 LOOP
            t_route_id_var    := c_751.ROUTE_ID;
            t_begin_point_var   := c_751.BEGIN_POINT;
            t_end_point_var    := c_751.END_POINT;
            t_section_length_var  := c_751.SECTION_LENGTH;
            t_value_numeric_var   := c_751.VALUE_NUMERIC;
            --t_comments_var    := c_751.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;
/******************************************************
         Processing Cursor #752: GRADES_D
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

        t_data_item_var     := 'GRADES_D';
        t_item_descr     := 'GRADES_D';

        FOR c_752 IN cur_752 LOOP
            t_route_id_var    := c_752.ROUTE_ID;
            t_begin_point_var   := c_752.BEGIN_POINT;
            t_end_point_var    := c_752.END_POINT;
            t_section_length_var  := c_752.SECTION_LENGTH;
            t_value_numeric_var   := c_752.VALUE_NUMERIC;
            --t_comments_var    := c_752.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;
/******************************************************
         Processing Cursor #753: GRADES_E
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

        t_data_item_var     := 'GRADES_E';
        t_item_descr     := 'GRADES_E';

        FOR c_753 IN cur_753 LOOP
            t_route_id_var    := c_753.ROUTE_ID;
            t_begin_point_var   := c_753.BEGIN_POINT;
            t_end_point_var    := c_753.END_POINT;
            t_section_length_var  := c_753.SECTION_LENGTH;
            t_value_numeric_var   := c_753.VALUE_NUMERIC;
            --t_comments_var    := c_753.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'ERROR', t_error_desc);
        COMMIT;

    END;
/******************************************************
         Processing Cursor #754: GRADES_F
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

        t_data_item_var     := 'GRADES_F';
        t_item_descr     := 'GRADES_F';

        FOR c_754 IN cur_754 LOOP
            t_route_id_var    := c_754.ROUTE_ID;
            t_begin_point_var   := c_754.BEGIN_POINT;
            t_end_point_var    := c_754.END_POINT;
            t_section_length_var  := c_754.SECTION_LENGTH;
            t_value_numeric_var   := c_754.VALUE_NUMERIC;
            --t_comments_var    := c_754.COMMENTS;

            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        t_error			:= sqlcode;
        t_error_desc		:= substr(sqlerrm,1,400);
        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT hpms_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO HPMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS, HAL_MESSAGE)
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

exec XODOT_POPULATE_OHMS_grad;


