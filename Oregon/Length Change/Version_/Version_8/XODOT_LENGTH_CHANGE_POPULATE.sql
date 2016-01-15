create or replace
PROCEDURE XODOT_LENGTH_CHANGE_POPULATE(p_processdate IN DATE) IS

/*
	Version:	8
	BY:			JMM


*/

t_row					XODOT_LENGTH_CHANGE%ROWTYPE;

t_change_id				NUMBER;
t_process_date			DATE;
t_effective_date		DATE;

t_highway_id			XODOT_LENGTH_CHANGE.HIGHWAY_ID%TYPE;
t_highway_unique		XODOT_LENGTH_CHANGE.HIGHWAY_UNIQUE%TYPE;
t_highway_name			XODOT_LENGTH_CHANGE.HIGHWAY_NAME%TYPE;

t_datum_id				XODOT_LENGTH_CHANGE.DATUM_ID%TYPE;
t_datum_unique			XODOT_LENGTH_CHANGE.DATUM_UNIQUE%TYPE;
t_datum_length			XODOT_LENGTH_CHANGE.DATUM_LENGTH%TYPE;
t_datum_type			XODOT_LENGTH_CHANGE.DATUM_TYPE%TYPE;

t_operation				XODOT_LENGTH_CHANGE.OPERATION%TYPE;
t_reason_for_change		XODOT_LENGTH_CHANGE.REASON_FOR_CHANGE%TYPE;
t_document_id			XODOT_LENGTH_CHANGE.DOCUMENT_ID%TYPE;
t_date_created			DATE;
t_date_modified			DATE;

t_old_begin				XODOT_LENGTH_CHANGE.OLD_BEGIN_MEASURE%TYPE;
t_old_end				XODOT_LENGTH_CHANGE.OLD_END_MEASURE%TYPE;
t_new_begin				XODOT_LENGTH_CHANGE.NEW_BEGIN_MEASURE%TYPE;
t_new_end				XODOT_LENGTH_CHANGE.NEW_END_MEASURE%TYPE;
t_change_start			XODOT_LENGTH_CHANGE.CHANGE_START_MEASURE%TYPE;
t_change_end			XODOT_LENGTH_CHANGE.CHANGE_END_MEASURE%TYPE;
t_mileage_change		XODOT_LENGTH_CHANGE.MILEAGE_CHANGE%TYPE;
t_route					XODOT_LENGTH_CHANGE.RTE%TYPE;
t_slk					NM_MEMBERS_ALL.NM_SLK%TYPE;
t_end_slk				NM_MEMBERS_ALL.NM_END_SLK%TYPE;

t_entry_exists			CHAR(1)		:= 'F';
t_no_length_change		CHAR(1)		:= 'F';
t_reclassify			CHAR(1)		:= 'F';
t_recalibrate			CHAR(1)		:= 'F';
t_replaced				CHAR(1)		:= 'F';
t_close					CHAR(1)		:= 'F';
t_create				CHAR(1)		:= 'F';
t_new_db				CHAR(1)		:= 'F';
t_new_segm				CHAR(1)		:= 'F';
t_rescaled_db			CHAR(1)		:= 'F';

t_old_ne_length			NUMBER;
t_new_ne_length			NUMBER;
t_param_1				NM_ELEMENT_HISTORY.NEH_PARAM_1%TYPE;
t_param_2				NM_ELEMENT_HISTORY.NEH_PARAM_2%TYPE;

t_highway_id_old		XODOT_LENGTH_CHANGE.HIGHWAY_ID%TYPE;
t_highway_unique_old	XODOT_LENGTH_CHANGE.HIGHWAY_UNIQUE%TYPE;
t_highway_name_old		XODOT_LENGTH_CHANGE.HIGHWAY_NAME%TYPE;
t_datum_id_old			XODOT_LENGTH_CHANGE.DATUM_ID%TYPE;
t_datum_unique_old		XODOT_LENGTH_CHANGE.DATUM_UNIQUE%TYPE;
t_datum_length_old		XODOT_LENGTH_CHANGE.DATUM_LENGTH%TYPE;
t_datum_type_old		XODOT_LENGTH_CHANGE.DATUM_TYPE%TYPE;
t_reason_old			XODOT_LENGTH_CHANGE.REASON_FOR_CHANGE%TYPE;
t_document_id_old		XODOT_LENGTH_CHANGE.DOCUMENT_ID%TYPE;
t_date_created_old		DATE;
t_date_modified_old		DATE;
t_effective_date_old	DATE;
t_slk_old				NM_MEMBERS_ALL.NM_SLK%TYPE;
t_end_slk_old			NM_MEMBERS_ALL.NM_END_SLK%TYPE;
t_route_old				XODOT_LENGTH_CHANGE.RTE%TYPE;

IS_COMPLETE				EXCEPTION;
t_error_text			VARCHAR2(350);

t_ChangeEnd_tmp			NUMBER;
t_ChangeStart_tmp		NUMBER;

CURSOR cur_network_changes(cp_date IN DATE) IS
	/*
	
	SELECT a.ne_id highway_id
		, a.ne_unique highway_unique
		, a.ne_descr highway_name
		, b.nm_ne_id_of datum_id
		, c.ne_unique datum_unique
		, c.ne_length datum_length
		, c.ne_type datum_type
		, c.ne_name_2 reason_for_change
		, c.ne_group document_id
		, trunc(b.nm_date_created) date_created
		, trunc(b.nm_date_modified) date_modified
		, b.nm_start_date effective_date
		, b.nm_slk
		, b.nm_end_slk
	FROM nm_elements_all a
		, nm_members_all b
		, nm_elements_all c
	WHERE a.ne_id = b.nm_ne_id_in
		AND a.ne_name_1 <> 'P'
		AND b.nm_ne_id_of = c.ne_id
		AND b.nm_obj_type = 'HWY'
		AND (trunc(b.nm_date_created) = cp_date
			OR trunc(b.nm_date_modified) = cp_date);
	
	*/
	
	-- The CURSOR cur_network_changes was changed to address ghost records from appearing in the report
	
	With Main1 as(
  
  SELECT /*+ materialize */
		  a.ne_id highway_id
		, a.ne_unique highway_unique
		, a.ne_descr highway_name
		, b.nm_ne_id_of datum_id
		, c.ne_unique datum_unique
		, c.ne_length datum_length
		, c.ne_type datum_type
		, c.ne_name_2 reason_for_change
		, C.NE_GROUP DOCUMENT_ID
		, trunc(b.nm_date_created) date_created
		, trunc(b.nm_date_modified) date_modified
		, b.nm_start_date effective_date
		, b.nm_slk
		, b.nm_end_slk
	FROM nm_elements_all a
		, nm_members_all b
		, nm_elements_all c
	WHERE a.ne_id = b.nm_ne_id_in
		AND a.ne_name_1 <> 'P'
		AND b.nm_ne_id_of = c.ne_id
		and B.NM_OBJ_TYPE = 'HWY'
     
		and (TRUNC(B.NM_DATE_CREATED) = cp_date
			OR trunc(b.nm_date_modified) = cp_date) 
      )
      
    , MaxCreated as (
      select 
      
          highway_id
          , highway_unique
          ,datum_id
          , datum_unique                    
          , max(DATE_CREATED) DATE_CREATED

      
      from Main1 group by HIGHWAY_ID, HIGHWAY_UNIQUE, DATUM_ID, DATUM_UNIQUE )
      
      select   
          aa.highway_id
        , aa.highway_unique
        , aa.highway_name
        , aa.datum_id
        , aa.datum_unique
        , aa.datum_length
        , aa.datum_type
        , aa.reason_for_change
        , aa.DOCUMENT_ID
        , aa.date_created
        , aa.date_modified
        , aa.effective_date
        , aa.nm_slk
        , AA.NM_END_SLK
      from 
        MAIN1 AA, MAXCREATED BB
      where
      AA.HIGHWAY_ID = BB.HIGHWAY_ID
     and  AA.HIGHWAY_UNIQUE = BB.HIGHWAY_UNIQUE
      and AA.DATUM_ID= BB.DATUM_ID
      and AA.DATUM_UNIQUE = BB.DATUM_UNIQUE
      and aa.DATE_CREATED = bb.DATE_CREATED
      ;
	
	

CURSOR cur_history(cp_datum IN NUMBER, cp_date IN DATE, cp_operation IN VARCHAR2) IS
	SELECT neh_old_ne_length
		, neh_new_ne_length
		, neh_param_1
		, neh_param_2
		, neh_ne_id_old
	FROM nm_element_history
	WHERE neh_ne_id_new = cp_datum
		AND neh_actioned_date = cp_date
		AND neh_operation = cp_operation
		order by neh_id desc;   -- Last operation of the type

CURSOR cur_no_length_change(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
	WHERE neh_ne_id_new = cp_datum
		AND neh_operation IN ('S','M','R','H','E','V')
		AND neh_actioned_date = cp_date
		OR (neh_ne_id_new = cp_datum
			AND neh_operation = 'N'
			AND neh_actioned_date = cp_date
			AND neh_old_ne_length = neh_new_ne_length);

CURSOR cur_entry_exists(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
	WHERE neh_actioned_date = cp_date
		AND neh_ne_id_new = cp_datum;

CURSOR cur_recalibrate(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
		, nm_members_all
	WHERE neh_ne_id_new = nm_ne_id_of
		AND trunc(neh_actioned_date) = trunc(nm_date_modified)
		AND neh_operation = 'B'
		AND nm_obj_type = 'HWY'
		AND neh_actioned_date = cp_date
		AND neh_ne_id_new = cp_datum;

CURSOR cur_replaced(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
		, nm_members_all
	WHERE neh_ne_id_new = nm_ne_id_of
		AND trunc(neh_actioned_date) = trunc(nm_date_modified)
		AND neh_operation = 'R'
		AND nm_obj_type = 'HWY'
		AND neh_actioned_date = cp_date
		AND neh_ne_id_new = cp_datum;
		
cursor CUR_CREATE(CP_DATUM in number, CP_DATE in date) is
	select DECODE(COUNT(*),0,'F','T') RESULT_
	from NM_ELEMENTS_ALL
		, nm_members_all
	WHERE ne_id = cp_datum
		AND ne_id = nm_ne_id_of
		AND nm_obj_type = 'HWY'
		AND ne_start_date = cp_date
		AND nm_start_date = ne_start_date;

CURSOR cur_close(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
		, nm_members_all
	WHERE neh_ne_id_new = nm_ne_id_of
		AND trunc(neh_actioned_date) = trunc(nm_date_modified)
		AND nm_obj_type = 'HWY'
		AND neh_operation = 'C'
		AND neh_actioned_date = cp_date
		AND neh_ne_id_new = cp_datum;

CURSOR cur_reclassify(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_element_history
		, nm_members_all
	WHERE neh_ne_id_new = nm_ne_id_of
		AND trunc(neh_actioned_date) = trunc(nm_date_modified)
		AND neh_operation = 'N'
		AND nm_obj_type = 'HWY'		
		--AND neh_old_ne_length <> neh_new_ne_length  removed b/c you can reclassify and still have these be equal.
		AND neh_actioned_date = cp_date
		AND neh_ne_id_new = cp_datum;

CURSOR cur_new_segm(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_elements_all
		, nm_members_all
	WHERE ne_id = nm_ne_id_of
		AND ne_id = cp_datum
		AND ne_type = 'S'
		AND nm_obj_type = 'HWY'
		AND trunc(ne_date_created) = trunc(nm_date_created)
		AND trunc(ne_date_created) = cp_date;

CURSOR cur_new_db(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_elements_all
		, nm_members_all
	WHERE ne_id = nm_ne_id_of
		AND ne_id = cp_datum
		AND ne_type = 'D'
		AND nm_obj_type = 'HWY'
		AND trunc(ne_date_created) = trunc(nm_date_created)
		AND trunc(ne_date_created) = cp_date;

CURSOR cur_rescaled_db(cp_datum IN NUMBER, cp_hwy IN NUMBER, cp_date IN DATE) IS
	SELECT decode(count(*),0,'F','T') result_
	FROM nm_elements_all
		, nm_members_all
	WHERE ne_id = nm_ne_id_of
		AND ne_id = cp_datum
		AND nm_ne_id_in = cp_hwy
		AND ne_type = 'D'
		AND ne_end_date = cp_date;

CURSOR cur_oldinfo(cp_datum IN NUMBER, cp_date IN DATE) IS
	SELECT a.ne_id highway_id
		, a.ne_unique highway_unique
		, a.ne_descr highway_name
		, b.nm_ne_id_of datum_id
		, c.ne_unique datum_unique
		, c.ne_length datum_length
		, c.ne_type datum_type
		, c.ne_name_2 reason_for_change
		, c.ne_group document_id
		, trunc(b.nm_date_created) date_created
		, trunc(b.nm_date_modified) date_modified
		, b.nm_start_date effective_date
		, b.nm_slk
		, b.nm_end_slk
	FROM nm_elements_all a
		, nm_members_all b
		, nm_elements_all c
	WHERE a.ne_id = b.nm_ne_id_in
		AND a.ne_name_1 <> 'P'
		AND b.nm_ne_id_of = c.ne_id
		AND b.nm_ne_id_of = cp_datum
		AND b.nm_obj_type = 'HWY'
		AND b.nm_end_date = cp_date;

CURSOR cur_primary_route(cp_datum IN NUMBER) IS
	SELECT ne_unique
	FROM (
		SELECT rte_order
			, ne_unique
		FROM (
			SELECT decode(ne_sub_type,'I-','9-','US','8-','OR','7-','6-') rte_order
				, ne_unique
			FROM nm_elements_all
				, nm_members_all
			WHERE ne_id = nm_ne_id_in
				AND nm_ne_id_of = cp_datum
				AND ne_nt_type = 'RTE')
		ORDER BY rte_order DESC, ne_unique DESC)
	WHERE rownum < 2;

BEGIN

	t_process_date			:= p_processdate;

	t_highway_id			:= NULL;
	t_highway_unique		:= NULL;
	t_highway_name			:= NULL;

	t_datum_id				:= NULL;
	t_datum_unique			:= NULL;
	t_datum_length			:= NULL;
	t_datum_type			:= NULL;

	t_reason_for_change		:= NULL;
	t_document_id			:= NULL;
	t_date_created			:= NULL;
	t_date_modified			:= NULL;
	t_effective_date		:= NULL;
	t_slk					:= NULL;
	t_end_slk				:= NULL;

	t_entry_exists			:= 'F';
	t_no_length_change		:= 'F';
	t_reclassify			:= 'F';
	t_recalibrate			:= 'F';
	t_close					:= 'F';
	t_create				:= 'F';
	t_new_db				:= 'F';
	t_new_segm				:= 'F';
	t_rescaled_db			:= 'F';

	FOR c_changes IN cur_network_changes(t_process_date) LOOP

		t_row					:= NULL;

		t_highway_id			:= c_changes.highway_id;
		t_highway_unique		:= c_changes.highway_unique;
		t_highway_name			:= c_changes.highway_name;

		t_datum_id				:= c_changes.datum_id;
		t_datum_unique			:= c_changes.datum_unique;
		t_datum_length			:= c_changes.datum_length;
		t_datum_type			:= c_changes.datum_type;

		t_reason_for_change		:= c_changes.reason_for_change;
		t_document_id			:= c_changes.document_id;
		t_date_created			:= c_changes.date_created;
		t_date_modified			:= c_changes.date_modified;
		t_effective_date		:= c_changes.effective_date;
		t_slk					:= c_changes.nm_slk;
		t_end_slk				:= c_changes.nm_end_slk;

		t_entry_exists			:= 'F';
		t_no_length_change		:= 'F';
		t_reclassify			:= 'F';
		t_recalibrate			:= 'F';
		t_close					:= 'F';
		t_create				:= 'F';
		t_new_db				:= 'F';
		t_new_segm				:= 'F';
		t_rescaled_db			:= 'F';

		t_highway_id_old		:= NULL;
		t_highway_unique_old	:= NULL;
		t_highway_name_old		:= NULL;
		t_datum_id_old			:= NULL;
		t_datum_unique_old		:= NULL;
		t_datum_length_old		:= NULL;
		t_datum_type_old		:= NULL;
		t_reason_old			:= NULL;
		t_document_id_old		:= NULL;
		t_date_created_old		:= NULL;
		t_date_modified_old		:= NULL;
		t_effective_date_old	:= NULL;
		t_slk_old				:= NULL;
		t_end_slk_old			:= NULL;

		OPEN cur_entry_exists(t_datum_id, t_process_date);
			FETCH cur_entry_exists INTO t_entry_exists;
		CLOSE cur_entry_exists;

		OPEN cur_no_length_change(t_datum_id, t_process_date);
			FETCH cur_no_length_change INTO t_no_length_change;
		CLOSE cur_no_length_change;

		OPEN cur_reclassify(t_datum_id, t_process_date);
			FETCH cur_reclassify INTO t_reclassify;
		CLOSE cur_reclassify;

		OPEN cur_recalibrate(t_datum_id, t_process_date);
			FETCH cur_recalibrate INTO t_recalibrate;
		CLOSE cur_recalibrate;

		OPEN cur_close(t_datum_id, t_process_date);
			FETCH cur_close INTO t_close;
		CLOSE cur_close;

		OPEN cur_create(t_datum_id, t_process_date);
			FETCH cur_create INTO t_create;
		CLOSE cur_create;

		OPEN cur_new_db(t_datum_id, t_process_date);
			FETCH cur_new_db INTO t_new_db;
		CLOSE cur_new_db;

		OPEN cur_new_segm(t_datum_id, t_process_date);
			FETCH cur_new_segm INTO t_new_segm;
		CLOSE cur_new_segm;

		OPEN cur_rescaled_db(t_datum_id, t_highway_id, t_process_date);
			FETCH cur_rescaled_db INTO t_rescaled_db;
		CLOSE cur_rescaled_db;

		IF t_entry_exists = 'F' THEN
			IF t_create = 'T' AND t_datum_type = 'S' THEN

				SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

				OPEN cur_primary_route(t_datum_id);
				FETCH cur_primary_route INTO t_route;
				CLOSE cur_primary_route;

				t_row.change_id				:= t_change_id;
				t_row.change_date			:= t_date_modified;
				t_row.effective_date		:= t_effective_date;
				t_row.datum_id				:= t_datum_id;
				t_row.datum_unique			:= t_datum_unique;
				t_row.datum_length			:= t_datum_length;
				t_row.datum_type			:= t_datum_type;
				t_row.operation				:= 'ADDED-NOENTRY';
				t_row.old_begin_measure		:= NULL;
				t_row.old_end_measure		:= NULL;
				t_row.new_begin_measure		:= t_slk;
				t_row.new_end_measure		:= t_end_slk;
				--t_row.change_start_measure	:= t_slk;
				t_row.change_start_measure	:= 0; 					--Old_End_Measure - Old_Begin_Measure
					t_ChangeStart_tmp := 0;
				--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
				
				
				case
					WHEN ( t_end_slk is null) AND ( t_slk is null) THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					WHEN t_end_slk = '' AND t_slk = '' THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					ELSE
						t_row.change_end_measure	:= t_end_slk - t_slk;
						t_ChangeEnd_tmp :=t_end_slk - t_slk;
				END CASE;

				
						
				
				--t_row.mileage_change		:= t_end_slk - t_slk;		--Change_End_Measure - Change_Start_Measure
				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
				
				t_row.highway_id			:= t_highway_id;
				t_row.highway_unique		:= t_highway_unique;
				t_row.highway_name			:= t_highway_name;
				t_row.reason_for_change		:= t_reason_for_change;
				t_row.document_id			:= t_document_id;
				t_row.rte					:= t_route;

				INSERT INTO xodot_length_change VALUES t_row;

			ELSIF t_create = 'T' AND t_datum_type = 'D' THEN
      
      
      /* ---------- JM, 2011.08.25,14:15
      Distance Break Items have been removed per a Change request
      ---------- */

				SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;
--
--				t_row.change_id			:= t_change_id;
--				t_row.change_date			:= t_date_modified;
--				t_row.effective_date		:= t_effective_date;
--				t_row.datum_id			:= t_datum_id;
--				t_row.datum_unique			:= t_datum_unique;
--				t_row.datum_length			:= t_datum_length;
--				t_row.datum_type			:= t_datum_type;
--				t_row.operation			:= 'DISTANCE BREAK ADDED-NE';
--				t_row.old_begin_measure		:= NULL;
--				t_row.old_end_measure		:= NULL;
--				t_row.new_begin_measure		:= t_slk;
--				t_row.new_end_measure		:= t_end_slk;
--				--t_row.change_start_measure		:= t_slk;
--				t_row.change_start_measure		:= 0;
--					t_ChangeStart_tmp := 0;
--				
--				--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
--				
--				
--				case
--					WHEN  t_end_slk is null AND  t_slk is null THEN
--						t_row.change_end_measure := 0;
--						t_ChangeEnd_tmp :=0;
--					WHEN t_end_slk = '' AND t_slk = '' THEN
--						t_row.change_end_measure := 0;
--						t_ChangeEnd_tmp :=0;
--					ELSE
--						t_row.change_end_measure	:= t_end_slk - t_slk;
--						t_ChangeEnd_tmp :=t_end_slk - t_slk;
--				END CASE;
--				
--				
--				--t_row.mileage_change		:= t_end_slk - t_slk;
--				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
--				
--				t_row.highway_id			:= t_highway_id;
--				t_row.highway_unique		:= t_highway_unique;
--				t_row.highway_name			:= t_highway_name;
--				t_row.reason_for_change		:= 'A mileage gap has been created between ' ||
--										t_slk || ' and ' || t_end_slk;
--				t_row.document_id			:= NULL;
--				t_row.rte				:= NULL;
--
--				INSERT INTO xodot_length_change VALUES t_row;

			ELSIF t_rescaled_db  = 'T' THEN    -- Changed to T since the cursor checks for D and this should only get ran for did
-- Closed DB
--				OPEN cur_primary_route(t_datum_id);
--				FETCH cur_primary_route INTO t_route;
--				CLOSE cur_primary_route;
--
  				SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;
--
--				t_row.change_id				:= t_change_id;
--				t_row.change_date			:= t_date_modified;
--				t_row.effective_date		:= t_effective_date;
--				t_row.datum_id				:= t_datum_id;
--				t_row.datum_unique			:= t_datum_unique;
--				t_row.datum_length			:= t_datum_length;
--				t_row.datum_type			:= t_datum_type;
--				t_row.operation				:= 'DISTANCE BREAK CLOSED-NE';
--				t_row.old_begin_measure		:= t_slk;
--				t_row.old_end_measure		:= t_end_slk;
--				t_row.new_begin_measure		:= NULL;
--				t_row.new_end_measure		:= NULL;
--					t_ChangeEnd_tmp :=0;
--				--t_row.change_start_measure		:= t_slk;
--				case
--					WHEN  t_end_slk is null AND  t_slk is null THEN
--						t_row.change_start_measure := 0;
--						t_ChangeStart_tmp :=0;
--					WHEN t_end_slk = '' AND t_slk = '' THEN
--						t_row.change_start_measure := 0;
--						t_ChangeStart_tmp :=0;
--					ELSE
--						t_row.change_start_measure	:= t_end_slk - t_slk;
--						t_ChangeStart_tmp :=t_end_slk - t_slk;
--				END CASE;
--				
--				--t_row.change_end_measure		:= t_end_slk;
--				t_row.change_end_measure		:= 0;
--					t_ChangeEnd_tmp := 0;
--				--t_row.mileage_change		:= t_slk - t_end_slk;
--				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;
--				
--				t_row.highway_id			:= t_highway_id;
--				t_row.highway_unique		:= t_highway_unique;
--				t_row.highway_name			:= t_highway_name;
--				t_row.reason_for_change		:= t_reason_for_change;
--				t_row.document_id			:= t_document_id;
--				t_row.rte					:= t_route;
--
--				INSERT INTO xodot_length_change VALUES t_row;

			END IF;

		ELSIF t_recalibrate = 'T' THEN

			OPEN cur_history(t_datum_id, t_process_date, 'B');
			FETCH cur_history INTO t_old_ne_length, t_new_ne_length, t_param_1, t_param_2, t_datum_id_old;
			CLOSE cur_history;

			OPEN cur_primary_route(t_datum_id);
			FETCH cur_primary_route INTO t_route;
			CLOSE cur_primary_route;

			IF t_old_ne_length > t_new_ne_length THEN
				t_operation		:= 'RECALIBRATED SHORTER';
			ELSE
				t_operation		:= 'RECALIBRATED LONGER';
			END IF;

			SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

			t_row.change_id				:= t_change_id;
			t_row.change_date			:= t_date_modified;
			t_row.effective_date		:= t_effective_date;
			t_row.datum_id				:= t_datum_id;
			t_row.datum_unique			:= t_datum_unique;
			t_row.datum_length			:= t_datum_length;
			t_row.datum_type			:= t_datum_type;
			t_row.operation				:= t_operation;
			t_row.old_begin_measure		:= nvl(t_slk,0) + nvl(t_param_1,0);
			t_row.old_end_measure		:= nvl(t_slk,0) + nvl(t_old_ne_length,0);
			t_row.new_begin_measure		:= nvl(t_slk,0) + nvl(t_param_1,0);
			t_row.new_end_measure		:= nvl(t_slk,0) + nvl(t_param_1,0) + nvl(t_param_2,0);
			--t_row.change_start_measure	:= least(t_new_ne_length, t_old_ne_length);
			t_row.change_start_measure	:= (nvl(t_slk,0) + nvl(t_old_ne_length,0)) - (nvl(t_slk,0) + nvl(t_param_1,0));
				t_ChangeStart_tmp := (nvl(t_slk,0) + nvl(t_old_ne_length,0)) - (nvl(t_slk,0) + nvl(t_param_1,0));
			--t_row.change_end_measure	:= greatest(t_new_ne_length, t_old_ne_length);
			t_row.change_end_measure	:= (nvl(t_slk,0) + nvl(t_param_1,0) + nvl(t_param_2,0)) - (nvl(t_slk,0) + nvl(t_param_1,0));
				t_ChangeEnd_tmp := (nvl(t_slk,0) + nvl(t_param_1,0) + nvl(t_param_2,0)) - (nvl(t_slk,0) + nvl(t_param_1,0));
			
			--t_row.mileage_change		:= t_new_ne_length - t_old_ne_length;
			t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
			t_row.highway_id			:= t_highway_id;
			t_row.highway_unique		:= t_highway_unique;
			t_row.highway_name			:= t_highway_name;
			t_row.reason_for_change		:= t_reason_for_change;
			t_row.document_id			:= t_document_id;
			t_row.rte					:= t_route;

			INSERT INTO xodot_length_change VALUES t_row;
			
			OPEN cur_replaced(t_datum_id, t_process_date);
				FETCH cur_replaced INTO t_replaced;
			CLOSE cur_replaced;
			
			IF t_replaced = 'F' THEN
				IF t_close = 'T' THEN

					OPEN cur_primary_route(t_datum_id);
					FETCH cur_primary_route INTO t_route;
					CLOSE cur_primary_route;

					SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

					t_row.change_id				:= t_change_id;
					t_row.change_date			:= t_date_modified;
					t_row.effective_date		:= t_effective_date;
					t_row.datum_id				:= t_datum_id;
					t_row.datum_unique			:= t_datum_unique;
					t_row.datum_length			:= t_datum_length;
					t_row.datum_type			:= t_datum_type;
					t_row.operation				:= 'CLOSED-RC';
					t_row.old_begin_measure		:= t_slk;
					t_row.old_end_measure		:= t_end_slk;
					t_row.new_begin_measure		:= NULL;
					t_row.new_end_measure		:= NULL;
						
					--t_row.change_start_measure		:= t_slk;
					case
						WHEN  t_end_slk is null AND  t_slk is null THEN
							t_row.change_start_measure := 0;
							t_ChangeStart_tmp :=0;
						WHEN t_end_slk = '' AND t_slk = '' THEN
							t_row.change_start_measure := 0;
							t_ChangeStart_tmp :=0;
						ELSE
							t_row.change_start_measure	:= t_end_slk - t_slk;
							t_ChangeStart_tmp :=t_end_slk - t_slk;
					END CASE;
					
					--t_row.change_end_measure		:= t_end_slk;
					t_row.change_end_measure		:= 0;
						t_ChangeEnd_tmp := 0;
					--t_row.mileage_change		:= t_slk - t_end_slk;
					
					t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;
					
					t_row.highway_id			:= t_highway_id;
					t_row.highway_unique		:= t_highway_unique;
					t_row.highway_name			:= t_highway_name;
					t_row.reason_for_change		:= t_reason_for_change;
					t_row.document_id			:= t_document_id;
					t_row.rte					:= t_route;

					INSERT INTO xodot_length_change VALUES t_row;
					
				ELSIF t_create = 'T' THEN

					OPEN cur_primary_route(t_datum_id);
					FETCH cur_primary_route INTO t_route;
					CLOSE cur_primary_route;

					SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

					t_row.change_id				:= t_change_id;
					t_row.change_date			:= t_date_modified;
					t_row.effective_date		:= t_effective_date;
					t_row.datum_id				:= t_datum_id;
					t_row.datum_unique			:= t_datum_unique;
					t_row.datum_length			:= t_old_ne_length;
					t_row.datum_type			:= t_datum_type;
					t_row.operation				:= 'ADDED-RC';
					t_row.old_begin_measure		:= NULL;
					t_row.old_end_measure		:= NULL;
					t_row.new_begin_measure		:= t_slk;
	--				t_row.new_end_measure		:= t_end_slk;
					t_row.new_end_measure		:= t_old_ne_length;
					--t_row.change_start_measure	:= t_slk;
	--				t_row.change_end_measure	:= t_end_slk;
					--t_row.change_end_measure	:= t_old_ne_length;
	--				t_row.mileage_change		:= t_end_slk - t_slk;
					t_row.change_start_measure	:= 0;				--Old_End_Measure - Old_Begin_Measure
						t_ChangeStart_tmp := 0;
					--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
					
					
					case
						WHEN  t_old_ne_length is null AND t_slk is null THEN
							t_row.change_end_measure := 0;
							t_ChangeEnd_tmp :=0;
						WHEN t_old_ne_length = '' AND t_slk = '' THEN
							t_row.change_end_measure := 0;
							t_ChangeEnd_tmp :=0;
						ELSE
							t_row.change_end_measure	:= t_old_ne_length - t_slk;
							t_ChangeEnd_tmp :=t_old_ne_length - t_slk;
					END CASE;

					
							
					
					--t_row.mileage_change		:= t_end_slk - t_slk;		--Change_End_Measure - Change_Start_Measure
					t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
					


					t_row.mileage_change		:= t_old_ne_length;
					t_row.highway_id			:= t_highway_id;
					t_row.highway_unique		:= t_highway_unique;
					t_row.highway_name			:= t_highway_name;
					t_row.reason_for_change		:= t_reason_for_change;
					t_row.document_id			:= t_document_id;
					t_row.rte					:= t_route;

					INSERT INTO xodot_length_change VALUES t_row;

				END IF;
			END IF;
			
		ELSIF t_new_db = 'T' AND t_no_length_change = 'F' THEN

  			SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;
--
--			t_row.change_id				:= t_change_id;
--			t_row.change_date			:= t_date_modified;
--			t_row.effective_date		:= t_effective_date;
--			t_row.datum_id				:= t_datum_id;
--			t_row.datum_unique			:= t_datum_unique;
--			t_row.datum_length			:= t_datum_length;
--			t_row.datum_type			:= t_datum_type;
--			t_row.operation				:= 'DISTANCE BREAK ADDED';
--			t_row.old_begin_measure		:= NULL;
--			t_row.old_end_measure		:= NULL;
--			t_row.new_begin_measure		:= t_slk;
--			t_row.new_end_measure		:= t_end_slk;
--			--t_row.change_start_measure	:= t_slk;
--			--t_row.change_end_measure	:= t_end_slk;
--			--t_row.mileage_change		:= t_end_slk - t_slk;
--			
--			t_row.change_start_measure	:= 0;					--Old_End_Measure - Old_Begin_Measure
--			t_ChangeStart_tmp := 0;
--			--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
--				
--				
--				case
--					WHEN  t_end_slk is null AND t_slk is null THEN
--						t_row.change_end_measure := 0;
--						t_ChangeEnd_tmp :=0;
--					WHEN t_end_slk = '' AND t_slk = '' THEN
--						t_row.change_end_measure := 0;
--						t_ChangeEnd_tmp :=0;
--					ELSE
--						t_row.change_end_measure	:= t_end_slk - t_slk;
--						t_ChangeEnd_tmp :=t_end_slk - t_slk;
--				END CASE;
--
--				
--						
--				
--			--t_row.mileage_change		:= t_end_slk - t_slk;		--Change_End_Measure - Change_Start_Measure
--			t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
--				
--			
--			t_row.highway_id			:= t_highway_id;
--			t_row.highway_unique		:= t_highway_unique;
--			t_row.highway_name			:= t_highway_name;
--			t_row.reason_for_change		:= 'A mileage gap has been created between ' ||
--										t_slk || ' and ' || t_end_slk;
--			t_row.document_id			:= NULL;
--			t_row.rte					:= NULL;
--
--			INSERT INTO xodot_length_change VALUES t_row;

		ELSIF t_new_segm = 'T' AND t_no_length_change = 'F' THEN

			OPEN cur_primary_route(t_datum_id);
			FETCH cur_primary_route INTO t_route;
			CLOSE cur_primary_route;

			SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

			t_row.change_id				:= t_change_id;
			t_row.change_date			:= t_date_modified;
			t_row.effective_date		:= t_effective_date;
			t_row.datum_id				:= t_datum_id;
			t_row.datum_unique			:= t_datum_unique;
			t_row.datum_length			:= t_datum_length;
			t_row.datum_type			:= t_datum_type;
			t_row.operation				:= 'ADDED-NEW';
			t_row.old_begin_measure		:= NULL;
			t_row.old_end_measure		:= NULL;
			t_row.new_begin_measure		:= t_slk;
			t_row.new_end_measure		:= t_end_slk;
			--t_row.change_start_measure	:= t_slk;
			--t_row.change_end_measure	:= t_end_slk;
			--t_row.mileage_change		:= t_end_slk - t_slk;
			t_row.change_start_measure	:= 0; 					--Old_End_Measure - Old_Begin_Measure
				t_ChangeStart_tmp := 0;
				--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
				
				
				case
					WHEN t_end_slk is null AND  t_slk is null THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					WHEN t_end_slk = '' AND t_slk = '' THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					ELSE
						t_row.change_end_measure	:= t_end_slk - t_slk;
						t_ChangeEnd_tmp :=t_end_slk - t_slk;
				END CASE;

				
						
				
				--t_row.mileage_change		:= t_end_slk - t_slk;		--Change_End_Measure - Change_Start_Measure
				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
				
			
			t_row.highway_id			:= t_highway_id;
			t_row.highway_unique		:= t_highway_unique;
			t_row.highway_name			:= t_highway_name;
			t_row.reason_for_change		:= t_reason_for_change;
			t_row.document_id			:= t_document_id;
			t_row.rte					:= t_route;

			INSERT INTO xodot_length_change VALUES t_row;
			

		ELSIF t_close = 'T'  THEN  -- Removed Length Change Check since If the Item is Closed it should always be in this report.
								--		The current t_no_length_change check coimes back T if a split and close happens on the same day. 
		--ELSIF t_close = 'T' AND t_no_length_change = 'F' THEN
		
			IF t_datum_type = 'S' THEN

				OPEN cur_primary_route(t_datum_id);
				FETCH cur_primary_route INTO t_route;
				CLOSE cur_primary_route;

				SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

				t_row.change_id				:= t_change_id;
				t_row.change_date			:= t_date_modified;
				t_row.effective_date		:= t_effective_date;
				t_row.datum_id				:= t_datum_id;
				t_row.datum_unique			:= t_datum_unique;
				t_row.datum_length			:= t_datum_length;
				t_row.datum_type			:= t_datum_type;
				t_row.operation				:= 'CLOSED-SEGM';
				t_row.old_begin_measure		:= t_slk;
				t_row.old_end_measure		:= t_end_slk;
				t_row.new_begin_measure		:= NULL;
				t_row.new_end_measure		:= NULL;
				
				--t_row.change_start_measure	:= t_slk;
				--t_row.change_end_measure	:= t_end_slk;
				--t_row.mileage_change		:= t_slk - t_end_slk;
				
				--t_row.change_start_measure		:= t_slk;
				case
					WHEN  t_end_slk is null AND  t_slk is null THEN
						t_row.change_start_measure := 0;
						t_ChangeStart_tmp :=0;
					WHEN t_end_slk = '' AND t_slk = '' THEN
						t_row.change_start_measure := 0;
						t_ChangeStart_tmp :=0;
					ELSE
						t_row.change_start_measure	:= t_end_slk - t_slk;
						t_ChangeStart_tmp :=t_end_slk - t_slk;
				END CASE;
				
				--t_row.change_end_measure		:= t_end_slk;
				T_ROW.CHANGE_END_MEASURE		:= 0;
					t_ChangeEnd_tmp := 0;
				--t_row.mileage_change		:= t_slk - t_end_slk;
				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;
				
				t_row.highway_id			:= t_highway_id;
				t_row.highway_unique		:= t_highway_unique;
				t_row.highway_name			:= t_highway_name;
				t_row.reason_for_change		:= t_reason_for_change;
				t_row.document_id			:= t_document_id;
				t_row.rte					:= t_route;

				INSERT INTO xodot_length_change VALUES t_row;

			ELSE
--				OPEN cur_primary_route(t_datum_id);
--				FETCH cur_primary_route INTO t_route;
--				CLOSE cur_primary_route;
--
  				SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;
--	
--				t_row.change_id				:= t_change_id;
--				t_row.change_date			:= t_date_modified;
--				t_row.effective_date		:= t_effective_date;
--				t_row.datum_id				:= t_datum_id;
--				t_row.datum_unique			:= t_datum_unique;
--				t_row.datum_length			:= t_datum_length;
--				t_row.datum_type			:= t_datum_type;
--				t_row.operation				:= 'DISTANCE BREAK CLOSED';
--				t_row.old_begin_measure		:= t_slk;
--				t_row.old_end_measure		:= t_end_slk;
--				t_row.new_begin_measure		:= NULL;
--				t_row.new_end_measure		:= NULL;
--				--t_row.change_start_measure	:= t_slk;
--				--t_row.change_end_measure	:= t_end_slk;
--				--t_row.mileage_change		:= t_slk - t_end_slk;
--				--t_row.change_start_measure		:= t_slk;
--				case
--					WHEN t_end_slk is null AND t_slk is null THEN
--						t_row.change_start_measure := 0;
--						t_ChangeStart_tmp :=0;
--					WHEN t_end_slk = '' AND t_slk = '' THEN
--						t_row.change_start_measure := 0;
--						t_ChangeStart_tmp :=0;
--					ELSE
--						t_row.change_start_measure	:= t_end_slk - t_slk;
--						t_ChangeStart_tmp :=t_end_slk - t_slk;
--				END CASE;
--				
--				--t_row.change_end_measure		:= t_end_slk;
--				T_ROW.CHANGE_END_MEASURE		:= 0;
--					t_ChangeEnd_tmp := 0;
--				--t_row.mileage_change		:= t_slk - t_end_slk;
--				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;
--				
--				
--				t_row.highway_id			:= t_highway_id;
--				t_row.highway_unique		:= t_highway_unique;
--				t_row.highway_name			:= t_highway_name;
--				t_row.reason_for_change		:= t_reason_for_change;
--				t_row.document_id			:= t_document_id;
--				t_row.rte					:= t_route;
--
--				INSERT INTO xodot_length_change VALUES t_row;

			END IF;
		ELSIF t_reclassify = 'T' THEN

			OPEN cur_history(t_datum_id, t_process_date, 'N');
				FETCH cur_history INTO t_old_ne_length
					, t_new_ne_length
					, t_param_1
					, t_param_2
					, t_datum_id_old;
			CLOSE cur_history;
-- First entry
			OPEN cur_primary_route(t_datum_id);
				FETCH cur_primary_route INTO t_route;
			CLOSE cur_primary_route;

			SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

			t_row.change_id				:= t_change_id;
			t_row.change_date			:= t_date_modified;
			t_row.effective_date		:= t_effective_date;
			t_row.datum_id				:= t_datum_id;
			t_row.datum_unique			:= t_datum_unique;
			t_row.datum_length			:= t_datum_length;
			t_row.datum_type			:= t_datum_type;
			t_row.operation				:= 'ADDED RECLASSIFY';
			t_row.old_begin_measure		:= NULL;
			t_row.old_end_measure		:= NULL;
			t_row.new_begin_measure		:= t_slk;
			t_row.new_end_measure		:= t_end_slk;
			--t_row.change_start_measure	:= t_slk;
			--t_row.change_end_measure	:= t_end_slk;
			--t_row.mileage_change		:= t_end_slk - t_slk;
							T_ROW.CHANGE_START_MEASURE	:= 0; 					--Old_End_Measure - Old_Begin_Measure
					t_ChangeStart_tmp :=0;
				--t_row.change_end_measure	:= t_end_slk;				--New_End_Measure - New_Begin_Measure
				
				
				case
					WHEN t_end_slk is null AND t_slk is null THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					WHEN t_end_slk = '' AND t_slk = '' THEN
						t_row.change_end_measure := 0;
						t_ChangeEnd_tmp :=0;
					ELSE
						t_row.change_end_measure	:= t_end_slk - t_slk;
						t_ChangeEnd_tmp :=t_end_slk - t_slk;
				END CASE;

				
						
				
				--t_row.mileage_change		:= t_end_slk - t_slk;		--Change_End_Measure - Change_Start_Measure
				t_row.mileage_change		:= t_ChangeEnd_tmp - t_ChangeStart_tmp;		--Change_End_Measure - Change_Start_Measure
				
			
			t_row.highway_id			:= t_highway_id;
			t_row.highway_unique		:= t_highway_unique;
			t_row.highway_name			:= t_highway_name;
			t_row.reason_for_change		:= t_reason_for_change;
			t_row.document_id			:= t_document_id;
			t_row.rte					:= t_route;

			INSERT INTO xodot_length_change VALUES t_row;

-- Second entry
			OPEN cur_primary_route(t_datum_id_old);
				FETCH cur_primary_route INTO t_route_old;
			CLOSE cur_primary_route;

			OPEN cur_oldinfo(t_datum_id_old, t_process_date);
				FETCH cur_oldinfo INTO
					t_highway_id_old
					, t_highway_unique_old
					, t_highway_name_old
					, t_datum_id_old
					, t_datum_unique_old
					, t_datum_length_old
					, t_datum_type_old
					, t_reason_old
					, t_document_id_old
					, t_date_created_old
					, t_date_modified_old
					, t_effective_date_old
					, t_slk_old
					, t_end_slk_old;
			CLOSE cur_oldinfo;

			SELECT XODOT_LENG_CHANGE_SEQ.nextval INTO t_change_id FROM DUAL;

			t_row.change_id				:= t_change_id;
			t_row.change_date			:= t_date_modified_old;
			t_row.effective_date		:= t_effective_date_old;
			t_row.datum_id				:= t_datum_id_old;
			t_row.datum_unique			:= t_datum_unique_old;
			t_row.datum_length			:= t_datum_length_old;
			t_row.datum_type			:= t_datum_type_old;
			t_row.operation				:= 'CLOSED RECLASSIFY';
			t_row.old_begin_measure		:= t_slk_old;
			t_row.old_end_measure		:= t_end_slk_old;
			t_row.new_begin_measure		:= NULL;
			t_row.new_end_measure		:= NULL;
			--t_row.change_start_measure	:= t_slk_old;
			--t_row.change_end_measure	:= t_end_slk_old;
			--t_row.mileage_change		:= t_slk_old - t_end_slk_old;
			
			t_row.change_end_measure	:= 0;
				t_ChangeEnd_tmp := 0;
				case
					WHEN t_end_slk is null AND t_slk is null THEN
						t_row.change_start_measure := 0;
						t_ChangeStart_tmp :=0;
					WHEN t_end_slk = '' AND t_slk = '' THEN
						t_row.change_start_measure := 0;
						t_ChangeStart_tmp :=0;
					ELSE
						t_row.change_start_measure	:= t_end_slk - t_slk;
						t_ChangeStart_tmp :=t_end_slk - t_slk;
				END CASE;
			
			t_row.highway_id			:= t_highway_id_old;
			t_row.highway_unique		:= t_highway_unique_old;
			t_row.highway_name			:= t_highway_name_old;
			t_row.reason_for_change		:= t_reason_old;
			t_row.document_id			:= t_document_id_old;
			t_row.rte					:= t_route_old;

			INSERT INTO xodot_length_change VALUES t_row;

		END IF;
	END LOOP;

	COMMIT;

	-- RAISE IS_COMPLETE;   -- This was removed so that DBMS does not roll back the changes from the "failure"

EXCEPTION 
	WHEN IS_COMPLETE THEN
		RAISE_APPLICATION_ERROR( -20000,'Length Change Population Complete');   
	
	WHEN OTHERS THEN
	        t_error_text		:= sqlcode || ' - ' || substr(sqlerrm,1,300);
		RAISE_APPLICATION_ERROR( -20001,'Length Change Population Failed: ' || t_error_text);   
	
END;