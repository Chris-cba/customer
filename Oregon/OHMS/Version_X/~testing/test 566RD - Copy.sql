CURSOR CUR_566 IS 
SELECT * FROM V_OHMS_FINAL_7_566_Region_Dist;


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
