Create or Replace Function "TRANSINFO"."OHMS_SIGNAL_CNT"  (cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER) RETURN NUMBER Is


--(cp_route IN VARCHAR2, cp_slk IN NUMBER, cp_end_slk IN NUMBER)
Cursor cur_road_assets IS
					with

					/*
					OHMS_ROW as ( 

						select * from (
						
						  select         
							ROUTE_ID RID
							,BEGIN_POINT SLK
							,end_point SLK_END
						  from OHMS_SUBMIT_SAMPLES
						  ORDER BY DBMS_RANDOM.VALUE
						)
					where rownum =1

					)
					,

					*/

					 road as (


									  SELECT iit_ne_id
										, nm_ne_id_of
										, nm_begin_mp
										, nm_end_mp
									FROM nm_inv_items_all
										, nm_members_all 
									WHERE iit_inv_type = 'ROAD'
										AND iit_end_date IS NULL
										AND iit_end_chain = 3
										and IIT_NE_ID = NM_NE_ID_IN
										and NM_END_DATE is null

					)

					
					, a as

					(
							
								SELECT d.nm_ne_id_of
									, case when D.NM_CARDINALITY = 1 then
										CASE WHEN nm_slk < cp_slk THEN
											(cp_slk - nm_slk) + nm_begin_mp
										ELSE
											nm_begin_mp
										END
									  else
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
									  end NM_END_MP
									  
								from NM_ELEMENTS_ALL C
								
									, NM_MEMBERS_ALL D
									
									
									
								where 
									c.ne_unique = cp_route
									AND c.ne_id = d.nm_ne_id_in
									AND c.ne_end_date IS NULL
									AND d.nm_end_date IS NULL
									and D.NM_END_SLK > cp_slk
									and D.NM_SLK <  cp_end_slk) 

				, b_other_assets as
				(

            SELECT d.nm_ne_id_of
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN d.nm_slk < cp_slk THEN
                        (cp_slk - d.nm_slk) + d.nm_begin_mp
                    ELSE

                        d.nm_begin_mp
                    END
                  ELSE
                    CASE WHEN d.nm_end_slk > cp_end_slk THEN
                        d.nm_begin_mp + (d.nm_end_slk - cp_end_slk)
                    ELSE

                        d.nm_begin_mp
                    END
                  END nm_begin_mp
                , CASE WHEN d.nm_cardinality = 1 THEN
                    CASE WHEN d.nm_end_slk > cp_end_slk THEN
                        d.nm_end_mp - (d.nm_end_slk - cp_end_slk)
                    ELSE

                        d.nm_end_mp
                    END
                  ELSE
                    CASE WHEN d.nm_slk < cp_slk THEN
                        d.nm_end_mp - (cp_slk - d.nm_slk)
                    ELSE

                        d.nm_end_mp
                    END
                  END nm_end_mp
            FROM nm_elements_all c
                , nm_members_all d
                , nm_elements_all e
		, v_nm_facl_nw f
            WHERE e.ne_unique = cp_route
                AND e.ne_owner = c.ne_owner
                AND e.ne_sub_type = c.ne_sub_type
                AND e.ne_name_1 = c.ne_name_1
                AND c.ne_prefix = 'D'
                AND c.ne_id = d.nm_ne_id_in
                AND c.ne_end_date IS NULL
                AND e.ne_end_date IS NULL
                AND d.nm_end_date IS NULL
                AND d.nm_end_slk > cp_slk
                AND d.nm_slk <  cp_end_slk
				AND d.nm_ne_id_of = f.ne_id_of
				AND d.nm_begin_mp < f.nm_end_mp
				AND d.nm_end_mp > f.nm_begin_mp
				AND f.typ_cd IN (6)  --changing to 6 only
				
				) 		


				, Cnt_Road_A as
					(
					SELECT count(*) cnt
					from (

						SELECT min(iit_ne_id) min_iit
							, nm_ne_id_of
							, nm_begin_mp
						FROM (   
						
						
							SELECT b.*
							from     a
									
								, road b
										
										
							WHERE a.nm_ne_id_of = b.nm_ne_id_of
								AND b.nm_begin_mp >= a.nm_begin_mp
								and B.NM_BEGIN_MP <= a.NM_END_MP)
								
						GROUP BY nm_ne_id_of, nm_begin_mp)
					)	
						
				, cnt_road_o as 
					(
						SELECT count(*) cnt
						FROM (
							SELECT min(iit_ne_id) min_iit
								, nm_ne_id_of
								, nm_begin_mp
							FROM (
								SELECT b.*
									from    
									
									b_other_assets a								
									, road b
									
									WHERE a.nm_ne_id_of = b.nm_ne_id_of
									AND b.nm_begin_mp >= a.nm_begin_mp
									AND b.nm_begin_mp <= a.nm_end_mp)
			
							GROUP BY nm_ne_id_of, nm_begin_mp)
					
					
					)
								select nvl(a.CNT,0) + nvl(b.cnt,0) from cnt_road_a a, cnt_road_o b
					
						
						;
	
	t_road_count		NUMBER;
	t_other_road_count	NUMBER;
	t_total_count		NUMBER;

	
Begin 			
	t_road_count		:= 0;
	t_other_road_count	:= 0;
	t_total_count		:= 0;
	
	OPEN cur_road_assets;  --(t_route, t_slk + 0.001, t_end_slk)
	FETCH cur_road_assets INTO t_road_count;
	CLOSE cur_road_assets;
	
	
	
	t_total_count := nvl(t_other_road_count,0) + nvl(t_road_count,0);
	RETURN t_total_count;
	
	
END;
/
			