CREATE OR REPLACE PROCEDURE XODOT_OHMSTEST IS 
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
CURSOR CUR_504 IS 
SELECT * FROM V_OHMS_FINAL_7_504_Structure_T;

CURSOR CUR_566 IS 
SELECT * FROM V_OHMS_FINAL_7_566_Region_Dist;

CURSOR CUR_528 IS 
SELECT * FROM V_OHMS_FINAL_7_528_Future_AADT;

CURSOR CUR_531 IS
select SAMPLE_ID, SECTION_LENGTH, BEGIN_POINT, END_POINT, ROUTE_ID, STATE_CODE 
    , OHMS_SIGNAL_CNT(ROUTE_ID, BEGIN_POINT, END_POINT) VALUE_NUMERIC
from OHMS_SUBMIT_SAMPLES;

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
         Processing Cursor #504: Is_Structure 
******************************************************-/
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

        t_data_item_var     := 'Is_Structure ';
        t_item_descr     := 'Is_Structure ';

        FOR c_504 IN cur_504 LOOP
            t_route_id_var    := c_504.ROUTE_ID;
            t_begin_point_var   := c_504.BEGIN_POINT;
            t_end_point_var    := c_504.END_POINT;
            t_section_length_var  := c_504.SECTION_LENGTH;
            t_value_numeric_var   := c_504.VALUE_NUMERIC;

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
******************************************************-/
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
******************************************************-/
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

        t_data_item_var     := 'Signals';
        t_item_descr     := 'Signals';

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
