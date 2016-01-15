--------------------------------------------------------
--  DDL for Function XNA_HPMS_GET_TLR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "TRANSINFO"."XNA_OHMS_GET_TLR" (p_sample IN VARCHAR2) RETURN NUMBER IS

CURSOR cur_datums(cp_samp IN VARCHAR2, cp_year IN NUMBER) IS
         SELECT route_id
        , nm_slk
        ,  nm_end_slk
        from OHMS_7_get_Turn_1
		where samp_id = cp_samp
        ;
        
CURSOR cur_road(cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER) IS
SELECT count(*)
FROM (
    SELECT (iit_ne_id) min_iit
        , nm_ne_id_of
        , nm_begin_mp
    FROM (
        SELECT b.*
        FROM (
            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_slk < cp_slk THEN
                        (cp_slk - nm_slk) + nm_begin_mp
                    ELSE
                        nm_begin_mp
                    END
                  ELSE
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_begin_mp + (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_end_mp - (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_end_mp
                    END
                  ELSE
                    CASE WHEN nm_slk < cp_slk THEN
                        nm_end_mp - (cp_slk - nm_slk)
                    ELSE
                        nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
            WHERE c.ne_unique = cp_route
                AND c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                AND d.nm_end_date IS NULL
                AND d.nm_end_slk > cp_slk
                AND d.nm_slk <  cp_end_slk) a
            , (SELECT iit_ne_id
                    , nm_ne_id_of
                    , nm_begin_mp
                    , nm_end_mp
                FROM nm_inv_items_all
                    , nm_members_all 
                WHERE iit_inv_type = 'ROAD'
                    AND iit_end_date IS NULL
                    AND iit_x_sect IN ('L','B')
                    AND iit_ne_id = nm_ne_id_in
                    AND nm_end_date IS NULL) b
        WHERE a.nm_ne_id_of = b.nm_ne_id_of
            AND b.nm_begin_mp >= a.nm_begin_mp
            AND b.nm_begin_mp <= a.nm_end_mp)
    GROUP BY nm_ne_id_of, nm_begin_mp);
        
CURSOR cur_urban(cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER) IS
SELECT count(*)
FROM (
    SELECT (nm_ne_id_in) min_ne
        , nm_ne_id_of
        , nm_begin_mp
    FROM (
        SELECT b.*
        FROM (
            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_slk < cp_slk THEN
                        (cp_slk - nm_slk) + nm_begin_mp
                    ELSE
                        nm_begin_mp
                    END
                  ELSE
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_begin_mp + (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_end_mp - (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_end_mp
                    END
                  ELSE
                    CASE WHEN nm_slk < cp_slk THEN
                        nm_end_mp - (cp_slk - nm_slk)
                    ELSE
                        nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
            WHERE c.ne_unique = cp_route
                AND c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                AND d.nm_end_date IS NULL
                AND d.nm_end_slk > cp_slk
                AND d.nm_slk <  cp_end_slk) a
            , (SELECT nm_ne_id_in
                    , nm_ne_id_of
                    , nm_begin_mp
                    , nm_end_mp
                FROM nm_members_all 
                WHERE nm_obj_type = 'URBN'
                    AND nm_end_date IS NULL) b
        WHERE a.nm_ne_id_of = b.nm_ne_id_of
            AND b.nm_begin_mp < a.nm_end_mp
            AND b.nm_end_mp > a.nm_begin_mp)
    GROUP BY nm_ne_id_of, nm_begin_mp);

CURSOR cur_rdgm_2(cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER) IS
SELECT count(*)
FROM (
    SELECT (iit_ne_id) min_iit
        , nm_ne_id_of
        , nm_begin_mp
    FROM (
        SELECT b.*
        FROM (
            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_slk < cp_slk THEN
                        (cp_slk - nm_slk) + nm_begin_mp
                    ELSE
                        nm_begin_mp
                    END
                  ELSE
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_begin_mp + (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_end_mp - (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_end_mp
                    END
                  ELSE
                    CASE WHEN nm_slk < cp_slk THEN
                        nm_end_mp - (cp_slk - nm_slk)
                    ELSE
                        nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
            WHERE c.ne_unique = cp_route
                AND c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                AND d.nm_end_date IS NULL
                AND d.nm_end_slk > cp_slk
                AND d.nm_slk <  cp_end_slk) a
            , (	SELECT iit_ne_id
			, nm_ne_id_of
			, nm_begin_mp
			, nm_end_mp
		FROM nm_inv_items_all
			, nm_members_all
		WHERE iit_inv_type = 'RDGM'
			AND iit_no_of_units = 1
			AND iit_end_date IS NULL
			AND iit_x_sect IN ('RT2D','RT2I')
			AND iit_ne_id = nm_ne_id_in
			AND nm_end_date IS NULL) b
        WHERE a.nm_ne_id_of = b.nm_ne_id_of
            AND b.nm_begin_mp < a.nm_end_mp
            AND b.nm_end_mp > a.nm_begin_mp)
    GROUP BY nm_ne_id_of, nm_begin_mp);

CURSOR cur_rdgm_1(cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER) IS
SELECT count(*)
FROM (
    SELECT (iit_ne_id) min_iit
        , nm_ne_id_of
        , nm_begin_mp
    FROM (
        SELECT b.*
        FROM (
            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_slk < cp_slk THEN
                        (cp_slk - nm_slk) + nm_begin_mp
                    ELSE
                        nm_begin_mp
                    END
                  ELSE
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_begin_mp + (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN nm_end_slk > cp_end_slk THEN
                        nm_end_mp - (nm_end_slk - cp_end_slk)
                    ELSE
                        nm_end_mp
                    END
                  ELSE
                    CASE WHEN nm_slk < cp_slk THEN
                        nm_end_mp - (cp_slk - nm_slk)
                    ELSE
                        nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
            WHERE c.ne_unique = cp_route
                AND c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                AND d.nm_end_date IS NULL
                AND d.nm_end_slk > cp_slk
                AND d.nm_slk <  cp_end_slk) a
            , (	SELECT iit_ne_id
			, nm_ne_id_of
			, nm_begin_mp
			, nm_end_mp
		FROM nm_inv_items_all
			, nm_members_all
		WHERE iit_inv_type = 'RDGM'
			AND iit_no_of_units = 1
			AND iit_end_date IS NULL
			AND iit_x_sect IN ('RT1D','RT1I')
			AND iit_ne_id = nm_ne_id_in
			AND nm_end_date IS NULL) b
        WHERE a.nm_ne_id_of = b.nm_ne_id_of
            AND b.nm_begin_mp < a.nm_end_mp
            AND b.nm_end_mp > a.nm_begin_mp)
    GROUP BY nm_ne_id_of, nm_begin_mp);

t_sample		VARCHAR2(20);
t_road_count		NUMBER;        
t_urban_count		NUMBER;
t_rdgm_1_count		NUMBER;
t_rdgm_2_count		NUMBER;

t_route			VARCHAR2(20);
t_slk			NUMBER;
t_end_slk		NUMBER;

t_year			NUMBER;

t_turn_lane_right	NUMBER;

BEGIN
	t_sample			:= p_sample;
	t_turn_lane_right		:= 1;
	t_road_count			:= NULL;
	t_urban_count			:= NULL;
	t_rdgm_1_count			:= NULL;
	t_rdgm_2_count			:= NULL;
	t_route				:= NULL;
	t_slk				:= NULL;
	t_end_slk			:= NULL;

	SELECT data_year() INTO t_year FROM DUAL;

	t_turn_lane_right		:= -1;

	OPEN cur_datums(t_sample, t_year);
	FETCH cur_datums INTO t_route, t_slk, t_end_slk;
	CLOSE cur_datums;

	OPEN cur_urban(t_route, t_slk, t_end_slk);
	FETCH cur_urban INTO t_urban_count;
	CLOSE cur_urban;

	IF nvl(t_urban_count,-1) > 0 THEN
		OPEN cur_road(t_route, t_slk, t_end_slk);
		FETCH cur_road INTO t_road_count;
		CLOSE cur_road;

		IF nvl(t_road_count,-1) < 1 THEN
			t_turn_lane_right	:= 1;
		ELSE
			OPEN cur_rdgm_2(t_route, t_slk, t_end_slk);
			FETCH cur_rdgm_2 INTO t_rdgm_2_count;
			CLOSE cur_rdgm_2;

			IF nvl(t_rdgm_2_count,-1) > 0 THEN
				t_turn_lane_right	:= 2;
			ELSE
				OPEN cur_rdgm_1(t_route, t_slk, t_end_slk);
				FETCH cur_rdgm_1 INTO t_rdgm_1_count;
				CLOSE cur_rdgm_1;

				IF nvl(t_rdgm_1_count,-1) > 0 THEN
					t_turn_lane_right	:= 4;
				ELSE
					t_turn_lane_right	:= 5;
				END IF;
			END IF;
		END IF;
	END IF;

	RETURN t_turn_lane_right;
END;

/

