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
select * from V_OHMS_FINAL_7_581_OHMS_SAMPLE;

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
         Processing Cursor #501: F_System
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

        t_data_item_var     := 'F_System';
        t_item_descr     := 'F_System';

        FOR c_501 IN cur_501 LOOP
            t_route_id_var    := c_501.ROUTE_ID;
            t_begin_point_var   := c_501.BEGIN_POINT;
            t_end_point_var    := c_501.END_POINT;
            t_section_length_var  := c_501.SECTION_LENGTH;
            t_value_numeric_var   := c_501.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #502: Urban_Code
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

        t_data_item_var     := 'Urban_Code';
        t_item_descr     := 'Urban_Code';

        FOR c_502 IN cur_502 LOOP
            t_route_id_var    := c_502.ROUTE_ID;
            t_begin_point_var   := c_502.BEGIN_POINT;
            t_end_point_var    := c_502.END_POINT;
            t_section_length_var  := c_502.SECTION_LENGTH;
            t_value_numeric_var   := c_502.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #507: Through_Lanes
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

        t_data_item_var     := 'Through_Lanes';
        t_item_descr     := 'Through_Lanes';

        FOR c_507 IN cur_507 LOOP
            t_route_id_var    := c_507.ROUTE_ID;
            t_begin_point_var   := c_507.BEGIN_POINT;
            t_end_point_var    := c_507.END_POINT;
            t_section_length_var  := c_507.SECTION_LENGTH;
            t_value_numeric_var   := c_507.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #508: HOV_Type
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

        t_data_item_var     := 'HOV_Type';
        t_item_descr     := 'HOV_Type';

        FOR c_508 IN cur_508 LOOP
            t_route_id_var    := c_508.ROUTE_ID;
            t_begin_point_var   := c_508.BEGIN_POINT;
            t_end_point_var    := c_508.END_POINT;
            t_section_length_var  := c_508.SECTION_LENGTH;
            t_value_numeric_var   := c_508.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #509: HOV_LANES
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

        t_data_item_var     := 'HOV_LANES';
        t_item_descr     := 'HOV_LANES';

        FOR c_509 IN cur_509 LOOP
            t_route_id_var    := c_509.ROUTE_ID;
            t_begin_point_var   := c_509.BEGIN_POINT;
            t_end_point_var    := c_509.END_POINT;
            t_section_length_var  := c_509.SECTION_LENGTH;
            t_value_numeric_var   := c_509.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #512: Turn_Lanes_R
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

        t_data_item_var     := 'Turn_Lanes_R';
        t_item_descr     := 'Turn_Lanes_R';

        FOR c_512 IN cur_512 LOOP
            t_route_id_var    := c_512.ROUTE_ID;
            t_begin_point_var   := c_512.BEGIN_POINT;
            t_end_point_var    := c_512.END_POINT;
            t_section_length_var  := c_512.SECTION_LENGTH;
            t_value_numeric_var   := c_512.VALUE_NUMERIC;
            t_comments_var    := c_512.COMMENTS;

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
/******************************************************
         Processing Cursor #513: Turn_Lanes_L
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

        t_data_item_var     := 'Turn_Lanes_L';
        t_item_descr     := 'Turn_Lanes_L';

        FOR c_513 IN cur_513 LOOP
            t_route_id_var    := c_513.ROUTE_ID;
            t_begin_point_var   := c_513.BEGIN_POINT;
            t_end_point_var    := c_513.END_POINT;
            t_section_length_var  := c_513.SECTION_LENGTH;
            t_value_numeric_var   := c_513.VALUE_NUMERIC;
            t_comments_var    := c_513.COMMENTS;

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
/******************************************************
         Processing Cursor #514: SPEED_LIMIT
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

        t_data_item_var     := 'SPEED_LIMIT';
        t_item_descr     := 'SPEED_LIMIT';

        FOR c_514 IN cur_514 LOOP
            t_route_id_var    := c_514.ROUTE_ID;
            t_begin_point_var   := c_514.BEGIN_POINT;
            t_end_point_var    := c_514.END_POINT;
            t_section_length_var  := c_514.SECTION_LENGTH;
            t_value_numeric_var   := c_514.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #521: AADT
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

        t_data_item_var     := 'AADT';
        t_item_descr     := 'AADT';

        FOR c_521 IN cur_521 LOOP
            t_route_id_var    := c_521.ROUTE_ID;
            t_begin_point_var   := c_521.BEGIN_POINT;
            t_end_point_var    := c_521.END_POINT;
            t_section_length_var  := c_521.SECTION_LENGTH;
            t_value_numeric_var   := c_521.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #522: AADT_Single_Unit
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

        t_data_item_var     := 'AADT_Single_Unit';
        t_item_descr     := 'AADT_Single_Unit';

        FOR c_522 IN cur_522 LOOP
            t_route_id_var    := c_522.ROUTE_ID;
            t_begin_point_var   := c_522.BEGIN_POINT;
            t_end_point_var    := c_522.END_POINT;
            t_section_length_var  := c_522.SECTION_LENGTH;
            t_value_numeric_var   := c_522.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #523: Pct_Peak_Single
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

        t_data_item_var     := 'Pct_Peak_Single';
        t_item_descr     := 'Pct_Peak_Single';

        FOR c_523 IN cur_523 LOOP
            t_route_id_var    := c_523.ROUTE_ID;
            t_begin_point_var   := c_523.BEGIN_POINT;
            t_end_point_var    := c_523.END_POINT;
            t_section_length_var  := c_523.SECTION_LENGTH;
            t_value_numeric_var   := c_523.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #524: AADT_Combination
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

        t_data_item_var     := 'AADT_Combination';
        t_item_descr     := 'AADT_Combination';

        FOR c_524 IN cur_524 LOOP
            t_route_id_var    := c_524.ROUTE_ID;
            t_begin_point_var   := c_524.BEGIN_POINT;
            t_end_point_var    := c_524.END_POINT;
            t_section_length_var  := c_524.SECTION_LENGTH;
            t_value_numeric_var   := c_524.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #525: Pct_Peak_Combination
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

        t_data_item_var     := 'Pct_Peak_Combination';
        t_item_descr     := 'Pct_Peak_Combination';

        FOR c_525 IN cur_525 LOOP
            t_route_id_var    := c_525.ROUTE_ID;
            t_begin_point_var   := c_525.BEGIN_POINT;
            t_end_point_var    := c_525.END_POINT;
            t_section_length_var  := c_525.SECTION_LENGTH;
            t_value_numeric_var   := c_525.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #526: K_Factor
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

        t_data_item_var     := 'K_Factor';
        t_item_descr     := 'K_Factor';

        FOR c_526 IN cur_526 LOOP
            t_route_id_var    := c_526.ROUTE_ID;
            t_begin_point_var   := c_526.BEGIN_POINT;
            t_end_point_var    := c_526.END_POINT;
            t_section_length_var  := c_526.SECTION_LENGTH;
            t_value_numeric_var   := c_526.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #527: Dir_Factor
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

        t_data_item_var     := 'Dir_Factor';
        t_item_descr     := 'Dir_Factor';

        FOR c_527 IN cur_527 LOOP
            t_route_id_var    := c_527.ROUTE_ID;
            t_begin_point_var   := c_527.BEGIN_POINT;
            t_end_point_var    := c_527.END_POINT;
            t_section_length_var  := c_527.SECTION_LENGTH;
            t_value_numeric_var   := c_527.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #528: Future_AADT
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

        t_data_item_var     := 'Future_AADT';
        t_item_descr     := 'Future_AADT';

        FOR c_528 IN cur_528 LOOP
            t_route_id_var    := c_528.ROUTE_ID;
            t_begin_point_var   := c_528.BEGIN_POINT;
            t_end_point_var    := c_528.END_POINT;
            t_section_length_var  := c_528.SECTION_LENGTH;
            t_value_numeric_var   := c_528.VALUE_NUMERIC;
            t_value_date_var   := c_528.VALUE_DATE;

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
/******************************************************
         Processing Cursor #531: Number_Signals
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

        t_data_item_var     := 'Number_Signals';
        t_item_descr     := 'Number_Signals';

        FOR c_531 IN cur_531 LOOP
            t_route_id_var    := c_531.ROUTE_ID;
            t_begin_point_var   := c_531.BEGIN_POINT;
            t_end_point_var    := c_531.END_POINT;
            t_section_length_var  := c_531.SECTION_LENGTH;
            t_value_numeric_var   := c_531.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #532: Stop_Signs
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

        t_data_item_var     := 'Stop_Signs';
        t_item_descr     := 'Stop_Signs';

        FOR c_532 IN cur_532 LOOP
            t_route_id_var    := c_532.ROUTE_ID;
            t_begin_point_var   := c_532.BEGIN_POINT;
            t_end_point_var    := c_532.END_POINT;
            t_section_length_var  := c_532.SECTION_LENGTH;
            t_value_numeric_var   := c_532.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #533: At_Grade_Other
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

        t_data_item_var     := 'At_Grade_Other';
        t_item_descr     := 'At_Grade_Other';

        FOR c_533 IN cur_533 LOOP
            t_route_id_var    := c_533.ROUTE_ID;
            t_begin_point_var   := c_533.BEGIN_POINT;
            t_end_point_var    := c_533.END_POINT;
            t_section_length_var  := c_533.SECTION_LENGTH;
            t_value_numeric_var   := c_533.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #534: Lane_Width
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

        t_data_item_var     := 'Lane_Width';
        t_item_descr     := 'Lane_Width';

        FOR c_534 IN cur_534 LOOP
            t_route_id_var    := c_534.ROUTE_ID;
            t_begin_point_var   := c_534.BEGIN_POINT;
            t_end_point_var    := c_534.END_POINT;
            t_section_length_var  := c_534.SECTION_LENGTH;
            t_value_numeric_var   := c_534.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #535: Median_Type
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

        t_data_item_var     := 'Median_Type';
        t_item_descr     := 'Median_Type';

        FOR c_535 IN cur_535 LOOP
            t_route_id_var    := c_535.ROUTE_ID;
            t_begin_point_var   := c_535.BEGIN_POINT;
            t_end_point_var    := c_535.END_POINT;
            t_section_length_var  := c_535.SECTION_LENGTH;
            t_value_numeric_var   := c_535.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #536: Median_Width
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

        t_data_item_var     := 'Median_Width';
        t_item_descr     := 'Median_Width';

        FOR c_536 IN cur_536 LOOP
            t_route_id_var    := c_536.ROUTE_ID;
            t_begin_point_var   := c_536.BEGIN_POINT;
            t_end_point_var    := c_536.END_POINT;
            t_section_length_var  := c_536.SECTION_LENGTH;
            t_value_numeric_var   := c_536.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #537: Shoulder_Type
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

        t_data_item_var     := 'Shoulder_Type';
        t_item_descr     := 'Shoulder_Type';

        FOR c_537 IN cur_537 LOOP
            t_route_id_var    := c_537.ROUTE_ID;
            t_begin_point_var   := c_537.BEGIN_POINT;
            t_end_point_var    := c_537.END_POINT;
            t_section_length_var  := c_537.SECTION_LENGTH;
            t_value_numeric_var   := c_537.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #538: Shoulder_Width_R
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

        t_data_item_var     := 'Shoulder_Width_R';
        t_item_descr     := 'Shoulder_Width_R';

        FOR c_538 IN cur_538 LOOP
            t_route_id_var    := c_538.ROUTE_ID;
            t_begin_point_var   := c_538.BEGIN_POINT;
            t_end_point_var    := c_538.END_POINT;
            t_section_length_var  := c_538.SECTION_LENGTH;
            t_value_numeric_var   := c_538.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #539: Shoulder_Width_L
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

        t_data_item_var     := 'Shoulder_Width_L';
        t_item_descr     := 'Shoulder_Width_L';

        FOR c_539 IN cur_539 LOOP
            t_route_id_var    := c_539.ROUTE_ID;
            t_begin_point_var   := c_539.BEGIN_POINT;
            t_end_point_var    := c_539.END_POINT;
            t_section_length_var  := c_539.SECTION_LENGTH;
            t_value_numeric_var   := c_539.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #544: Terrain_Type
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

        t_data_item_var     := 'Terrain_Type';
        t_item_descr     := 'Terrain_Type';

        FOR c_544 IN cur_544 LOOP
            t_route_id_var    := c_544.ROUTE_ID;
            t_begin_point_var   := c_544.BEGIN_POINT;
            t_end_point_var    := c_544.END_POINT;
            t_section_length_var  := c_544.SECTION_LENGTH;
            t_value_numeric_var   := c_544.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #549: Surface_Type
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

        t_data_item_var     := 'Surface_Type';
        t_item_descr     := 'Surface_Type';

        FOR c_549 IN cur_549 LOOP
            t_route_id_var    := c_549.ROUTE_ID;
            t_begin_point_var   := c_549.BEGIN_POINT;
            t_end_point_var    := c_549.END_POINT;
            t_section_length_var  := c_549.SECTION_LENGTH;
            t_value_numeric_var   := c_549.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #556: LAST_OVERLAY_THICKNESS
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

        t_data_item_var     := 'LAST_OVERLAY_THICKNESS';
        t_item_descr     := 'LAST_OVERLAY_THICKNESS';

        FOR c_556 IN cur_556 LOOP
            t_route_id_var    := c_556.ROUTE_ID;
            t_begin_point_var   := c_556.BEGIN_POINT;
            t_end_point_var    := c_556.END_POINT;
            t_section_length_var  := c_556.SECTION_LENGTH;
            t_value_numeric_var   := c_556.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #557: Thickness_Rigid
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

        t_data_item_var     := 'Thickness_Rigid';
        t_item_descr     := 'Thickness_Rigid';

        FOR c_557 IN cur_557 LOOP
            t_route_id_var    := c_557.ROUTE_ID;
            t_begin_point_var   := c_557.BEGIN_POINT;
            t_end_point_var    := c_557.END_POINT;
            t_section_length_var  := c_557.SECTION_LENGTH;
            t_value_numeric_var   := c_557.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #558: Thickness_Flexible
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

        t_data_item_var     := 'Thickness_Flexible';
        t_item_descr     := 'Thickness_Flexible';

        FOR c_558 IN cur_558 LOOP
            t_route_id_var    := c_558.ROUTE_ID;
            t_begin_point_var   := c_558.BEGIN_POINT;
            t_end_point_var    := c_558.END_POINT;
            t_section_length_var  := c_558.SECTION_LENGTH;
            t_value_numeric_var   := c_558.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #565: Oregon_Freight_Route
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

        t_data_item_var     := 'Oregon_Freight_Route';
        t_item_descr     := 'Oregon_Freight_Route';

        FOR c_565 IN cur_565 LOOP
            t_route_id_var    := c_565.ROUTE_ID;
            t_begin_point_var   := c_565.BEGIN_POINT;
            t_end_point_var    := c_565.END_POINT;
            t_section_length_var  := c_565.SECTION_LENGTH;
            t_value_numeric_var   := c_565.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #566: Region_District
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

        t_data_item_var     := 'District';
        t_item_descr     := 'District';

        FOR c_566 IN cur_566 LOOP
            t_route_id_var    := c_566.ROUTE_ID;
            t_begin_point_var   := c_566.BEGIN_POINT;
            t_end_point_var    := c_566.END_POINT;
            t_section_length_var  := c_566.SECTION_LENGTH;
            --t_value_text_var   := c_566.VALUE_TEXT;
			
			SELECT DDESC INTO t_value_text_var FROM V_OHMS_7_566_REGION_DIST_UP Where crew = c_566.VALUE_TEXT;
				
            INSERT INTO OHMS_SUBMIT_SECTIONS(YEAR_RECORD, STATE_CODE, ROUTE_ID, BEGIN_POINT, END_POINT, DATA_ITEM, SECTION_LENGTH, VALUE_NUMERIC, VALUE_TEXT, VALUE_DATE, COMMENTS) 
            VALUES(t_year_record_var,t_state_code_var,t_route_id_var,t_begin_point_var,t_end_point_var,t_data_item_var,t_section_length_var,t_value_numeric_var,t_value_text_var,t_value_date_var,t_comments_var);

            COMMIT;
        END LOOP;

        SELECT systimestamp, user INTO t_sysdate, t_user FROM DUAL;

        SELECT HPMS_hal_id.nextval INTO t_hal_id FROM DUAL;

        INSERT INTO OHMS_ACTIVITY_LOG(HAL_ID, HAL_DATE, HAL_USER, HAL_ITEM, HAL_TABLE_ID, HAL_STATUS)
        VALUES (t_hal_id, t_sysdate, t_user, t_item_descr, t_table_id, 'SUCCESS');

        COMMIT;
		
		----- REGION -------
		----- REGION -------
		----- REGION -------
		
		t_year_record_var    	:= NULL;
        t_state_code_var    	:= NULL;
        t_route_id_var     		:= NULL;
        t_begin_point_var    	:= NULL;
        t_end_point_var     	:= NULL;
        t_data_item_var     	:= NULL;
        t_section_length_var   	:= NULL;
        t_value_numeric_var    	:= NULL;
        t_value_text_var    	:= NULL;
        t_value_date_var    	:= NULL;
        t_comments_var     		:= NULL;


        SELECT DATA_YEAR() INTO t_year_record_var FROM DUAL;


        SELECT GET_STATE_CODE() INTO t_state_code_var FROM DUAL;

        t_data_item_var     := 'Region';
        t_item_descr     := 'Region';

        FOR c_566 IN cur_566 LOOP
            t_route_id_var    := c_566.ROUTE_ID;
            t_begin_point_var   := c_566.BEGIN_POINT;
            t_end_point_var    := c_566.END_POINT;
            t_section_length_var  := c_566.SECTION_LENGTH;
            --t_value_text_var   := c_566.VALUE_TEXT;
			
			SELECT RDESC INTO t_value_text_var FROM V_OHMS_7_566_REGION_DIST_UP Where crew = c_566.VALUE_TEXT;
				
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
/******************************************************
         Processing Cursor #567: PMS
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

        t_data_item_var     := 'PMS';
        t_item_descr     := 'PMS';

        FOR c_567 IN cur_567 LOOP
            t_route_id_var    := c_567.ROUTE_ID;
            t_begin_point_var   := c_567.BEGIN_POINT;
            t_end_point_var    := c_567.END_POINT;
            t_section_length_var  := c_567.SECTION_LENGTH;
            t_value_numeric_var   := c_567.VALUE_NUMERIC;

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
	
		/******************************************************
         Processing Cursor #581: HPMS_Sample_ID
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

        t_data_item_var     := 'HPMS_Sample_ID';
        t_item_descr     := 'HPMS_Sample_ID';

        FOR c_581 IN cur_581 LOOP
            t_route_id_var    := c_581.ROUTE_ID;
            t_begin_point_var   := c_581.BEGIN_POINT;
            t_end_point_var    := c_581.END_POINT;
            t_section_length_var  := c_581.SECTION_LENGTH;

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
	
	
	/******************************************************
         Processing Cursor #610: Peak_Lanes
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

        t_data_item_var     := 'Peak_Lanes';
        t_item_descr     := 'Peak_Lanes';

        FOR c_610 IN cur_610 LOOP
            t_route_id_var    := c_610.ROUTE_ID;
            t_begin_point_var   := c_610.BEGIN_POINT;
            t_end_point_var    := c_610.END_POINT;
            t_section_length_var  := c_610.SECTION_LENGTH;
			t_value_numeric_var  := c_610.VALUE_NUMERIC;
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
/******************************************************
         Processing Cursor #611: Counter_Peak_Lanes
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

        t_data_item_var     := 'Counter_Peak_Lanes';
        t_item_descr     := 'Counter_Peak_Lanes';

        FOR c_611 IN cur_611 LOOP
            t_route_id_var    := c_611.ROUTE_ID;
            t_begin_point_var   := c_611.BEGIN_POINT;
            t_end_point_var    := c_611.END_POINT;
            t_section_length_var  := c_611.SECTION_LENGTH;
			t_value_numeric_var  := c_611.VALUE_NUMERIC;

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
/******************************************************
         Processing Cursor #640: Peak_Parking
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

        t_data_item_var     := 'Peak_Parking';
        t_item_descr     := 'Peak_Parking';

        FOR c_640 IN cur_640 LOOP
            t_route_id_var    := c_640.ROUTE_ID;
            t_begin_point_var   := c_640.BEGIN_POINT;
            t_end_point_var    := c_640.END_POINT;
            t_section_length_var  := c_640.SECTION_LENGTH;

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
	
	/******************************************************
         Processing Cursor #581: HPMS_Sample_ID
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

        t_data_item_var     := 'HPMS_Sample_ID';
        t_item_descr     := 'HPMS_Sample_ID';

        FOR c_581 IN cur_581 LOOP
            t_route_id_var    := c_581.ROUTE_ID;
            t_begin_point_var   := c_581.BEGIN_POINT;
            t_end_point_var    := c_581.END_POINT;
            t_section_length_var  := c_581.SECTION_LENGTH;

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
	
	
	
	/******************************************************
         Processing Cursor #743: CURVES_A
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

        t_data_item_var     := 'CURVES_A';
        t_item_descr     := 'CURVES_A';

        FOR c_743 IN cur_743 LOOP
            t_route_id_var    := c_743.ROUTE_ID;
            t_begin_point_var   := c_743.BEGIN_POINT;
            t_end_point_var    := c_743.END_POINT;
            t_section_length_var  := c_743.SECTION_LENGTH;
            t_value_numeric_var   := c_743.VALUE_NUMERIC;
            t_comments_var    := c_743.COMMENTS;

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
         Processing Cursor #744: CURVES_B
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

        t_data_item_var     := 'CURVES_B';
        t_item_descr     := 'CURVES_B';

        FOR c_744 IN cur_744 LOOP
            t_route_id_var    := c_744.ROUTE_ID;
            t_begin_point_var   := c_744.BEGIN_POINT;
            t_end_point_var    := c_744.END_POINT;
            t_section_length_var  := c_744.SECTION_LENGTH;
            t_value_numeric_var   := c_744.VALUE_NUMERIC;
            t_comments_var    := c_744.COMMENTS;

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
         Processing Cursor #745: CURVES_C
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

        t_data_item_var     := 'CURVES_C';
        t_item_descr     := 'CURVES_C';

        FOR c_745 IN cur_745 LOOP
            t_route_id_var    := c_745.ROUTE_ID;
            t_begin_point_var   := c_745.BEGIN_POINT;
            t_end_point_var    := c_745.END_POINT;
            t_section_length_var  := c_745.SECTION_LENGTH;
            t_value_numeric_var   := c_745.VALUE_NUMERIC;
            t_comments_var    := c_745.COMMENTS;

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
         Processing Cursor #746: CURVES_D
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

        t_data_item_var     := 'CURVES_D';
        t_item_descr     := 'CURVES_D';

        FOR c_746 IN cur_746 LOOP
            t_route_id_var    := c_746.ROUTE_ID;
            t_begin_point_var   := c_746.BEGIN_POINT;
            t_end_point_var    := c_746.END_POINT;
            t_section_length_var  := c_746.SECTION_LENGTH;
            t_value_numeric_var   := c_746.VALUE_NUMERIC;
            t_comments_var    := c_746.COMMENTS;

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
         Processing Cursor #747: CURVES_E
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

        t_data_item_var     := 'CURVES_E';
        t_item_descr     := 'CURVES_E';

        FOR c_747 IN cur_747 LOOP
            t_route_id_var    := c_747.ROUTE_ID;
            t_begin_point_var   := c_747.BEGIN_POINT;
            t_end_point_var    := c_747.END_POINT;
            t_section_length_var  := c_747.SECTION_LENGTH;
            t_value_numeric_var   := c_747.VALUE_NUMERIC;
            t_comments_var    := c_747.COMMENTS;

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
         Processing Cursor #748: CURVES_F
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

        t_data_item_var     := 'CURVES_F';
        t_item_descr     := 'CURVES_F';

        FOR c_748 IN cur_748 LOOP
            t_route_id_var    := c_748.ROUTE_ID;
            t_begin_point_var   := c_748.BEGIN_POINT;
            t_end_point_var    := c_748.END_POINT;
            t_section_length_var  := c_748.SECTION_LENGTH;
            t_value_numeric_var   := c_748.VALUE_NUMERIC;
            t_comments_var    := c_748.COMMENTS;

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
            t_comments_var    := c_749.COMMENTS;

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
            t_comments_var    := c_750.COMMENTS;

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
            t_comments_var    := c_751.COMMENTS;

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
            t_comments_var    := c_752.COMMENTS;

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
            t_comments_var    := c_753.COMMENTS;

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
            t_comments_var    := c_754.COMMENTS;

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
