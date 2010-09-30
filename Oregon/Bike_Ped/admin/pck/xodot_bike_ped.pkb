CREATE OR REPLACE PACKAGE BODY TRANSINFO.xodot_bike_ped
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/Bike_Ped/admin/pck/xodot_bike_ped.pkb-arc   3.1   Sep 30 2010 19:01:56   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_bike_ped.pkb  $
--       Date into PVCS   : $Date:   Sep 30 2010 19:01:56  $
--       Date fetched Out : $Modtime:   Sep 27 2010 14:56:44  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--
--   Author : P Stanton
--
--   xodot_bike_ped body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   3.1  $"';

  g_package_name CONSTANT varchar2(30) := 'xodot_bike_ped';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_merge(p_job_id OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS

l_mrg_id     nm_mrg_query.nmq_id%TYPE;

BEGIN

    select NMQ_ID into l_mrg_id from nm_mrg_query
    where NMQ_UNIQUE = 'BIKE_PED_MRG';

	delete from nm_mrg_query_results where nqr_nmq_id = l_mrg_id;
    commit;

    NM3MRG_WRAP.execute_mrg_qry_route (l_mrg_id, nm3net.get_ne_id('00100I00'),'Run',p_job_id);


    commit;

END run_merge;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE run_merge_new(p_job_id OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS


  l_sqlcount    pls_integer;
  l_mrg_job_id  integer;
  l_longops_rec nm3sql.longops_rec;
  l_mrg_id     nm_mrg_query.nmq_id%TYPE;

begin


  nm3bulk_mrg.load_group_datums(p_group_id   => nm3net.get_ne_id('00100I00')
                               ,p_sqlcount   => l_sqlcount);

  nm3bulk_mrg.ins_route_connectivity(
     p_criteria_rowcount  => l_sqlcount
    ,p_ignore_poe         => false
  );

  select NMQ_ID into l_mrg_id from nm_mrg_query
    where NMQ_UNIQUE = 'BIKE_PED_MRG';

	delete from nm_mrg_query_results where nqr_nmq_id = l_mrg_id;
    commit;

  nm3bulk_mrg.std_run(
     p_nmq_id         => l_mrg_id
    ,p_nqr_admin_unit => 3
    ,p_nmq_descr      => 'test run from api'
    ,p_ignore_POE => TRUE
    ,p_criteria_rowcount => l_sqlcount
    ,p_mrg_job_id     => l_mrg_job_id
    ,p_longops_rec    => l_longops_rec
  );
  commit;

  p_job_id := l_mrg_job_id;



END run_merge_new;

PROCEDURE run_merge_all(p_job_id OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS


  l_sqlcount    pls_integer;
  l_mrg_job_id  integer;
  l_longops_rec nm3sql.longops_rec;
  l_mrg_id     nm_mrg_query.nmq_id%TYPE;

begin

  nm3bulk_mrg.load_all_network_datums(p_group_type => 'HWY'
                                      ,p_sqlcount   => l_sqlcount);


  nm3bulk_mrg.ins_route_connectivity(
     p_criteria_rowcount  => l_sqlcount
    ,p_ignore_poe         => false
  );

  select NMQ_ID into l_mrg_id from nm_mrg_query
    where NMQ_UNIQUE = 'BIKE_PED_MRG';

	delete from nm_mrg_query_results where nqr_nmq_id = l_mrg_id;
    commit;

  nm3bulk_mrg.std_run(
     p_nmq_id         => l_mrg_id
    ,p_nqr_admin_unit => 1
    ,p_nmq_descr      => 'test run from api'
    ,p_ignore_POE => TRUE
    ,p_criteria_rowcount => l_sqlcount
    ,p_mrg_job_id     => l_mrg_job_id
    ,p_longops_rec    => l_longops_rec
  );
  commit;

  p_job_id := l_mrg_job_id;



END run_merge_all;

PROCEDURE pop_mrg_result_table (p_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE)IS

CURSOR get_data IS
SELECT nms_ne_id_first, a.NMS_MRG_SECTION_ID merg_section_id,nms_begin_offset,nms_end_offset, ne_unique,ne_owner,ne_sub_type ,ne_prefix ,ne_name_1 ,ne_name_2 ,ne_number ,ne_group,b.* from v_mrg_bike_ped_mrg_sec a, V_MRG_BIKE_PED_MRG_VAL b, nm_elements c
WHERE a.NQR_MRG_JOB_ID = p_job_id
AND a.NMS_MRG_SECTION_ID    =  b.NMS_MRG_SECTION_ID
and ne_id = (select nm_ne_id_in from nm_members
               where nm_ne_id_of = nms_ne_id_first
               and nm_obj_type = 'HWY');



CURSOR get_data2 IS
select * from XODOT_BKPD_MRG_RESULT;

Cursor get_rte_data(P_MRG_SECTION_ID NUMBER
                    ,p_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS
SELECT * from bike_ped_ROAD_SEG_RTE
where NMS_MRG_SECTION_ID = P_MRG_SECTION_ID
and NQR_MRG_JOB_ID = p_job_id;

CURSOR get_reg_dist (p_ea_number varchar2)IS
select * from XODOT_EA_CW_DIST_REG_LOOKUP
where ea_number = p_ea_number;

BEGIN


 delete from XODOT_BKPD_MRG_RESULT;
 commit;

 FOR i IN get_data LOOP


    INSERT INTO XODOT_BKPD_MRG_RESULT
    ( ne_id
    ,BIKE_R_TYP_CD
    ,BIKE_R_COND_CD
    ,BIKE_R_NEED_IND
    ,BIKE_R_WD_MEAS
    ,BIKE_R_INSP_YR
    ,BIKE_R_NOTE
    ,BIKE_L_TYP_CD
    ,BIKE_L_COND_CD
    ,BIKE_L_NEED_IND
    ,BIKE_L_WD_MEAS
    ,BIKE_L_INSP_YR
    ,BIKE_L_NOTE
    ,CURB_R_TYP_CD
    ,CURB_R_HT_CD
    ,CURB_R_COND_CD
    ,CURB_R_INSP_YR
    ,CURB_R_SRCE_TYP
    ,CURB_R_NOTE
    ,CURB_CD_TYP_CD
    ,CURB_CD_HT_CD
    ,CURB_CD_COND_CD
    ,CURB_CD_INSP_YR
    ,CURB_CD_SRCE_TYP
    ,CURB_CD_NOTE
    ,CURB_CI_TYP_CD
    ,CURB_CI_HT_CD
    ,CURB_CI_COND_CD
    ,CURB_CI_INSP_YR
    ,CURB_CI_SRCE_TYP
    ,CURB_CI_NOTE
    ,CURB_L_TYP_CD
    ,CURB_L_HT_CD
    ,CURB_L_COND_CD
    ,CURB_L_INSP_YR
    ,CURB_L_SRCE_TYP
    ,CURB_L_NOTE
    ,PARK_R_COND_CD
    ,PARK_R_WD_MEAS
    ,PARK_R_TYP_CD
    ,PARK_R_INSP_YR
    ,PARK_R_SRCE_TYP
    ,PARK_R_NOTE
    ,PARK_L_COND_CD
    ,PARK_L_WD_MEAS
    ,PARK_L_TYP_CD
    ,PARK_L_INSP_YR
    ,PARK_L_SRCE_TYP
    ,PARK_L_NOTE
    ,CITY_R_NM
    ,CITY_L_NM
    ,SHUP_R_SURF_CD
    ,SHUP_R_COND_CD
    ,SHUP_R_INSP_YR
    ,SHUP_R_WD_MEAS
    ,SHUP_L_SURF_CD
    ,SHUP_L_COND_CD
    ,SHUP_L_INSP_YR
    ,SHUP_L_WD_MEAS
    ,SWLK_R_SURF_CD
    ,SWLK_R_COND_CD
    ,SWLK_R_BUF_IND
    ,SWLK_R_NEED_IND
    ,SWLK_R_INSP_YR
    ,SWLK_R_WD_MEAS
    ,SWLK_L_SURF_CD
    ,SWLK_L_COND_CD
    ,SWLK_L_BUF_IND
    ,SWLK_L_NEED_IND
    ,SWLK_L_INSP_YR
    ,SWLK_L_WD_MEAS
    ,HWY
    ,HIGHWAY_NUMBER
    ,SUFFIX
    ,ROADWAY_ID
    ,MILEAGE_TYPE
    ,OVERLAP_MILEAGE_CODE
    ,ROAD_DIRECTION
    ,road_type
    ,begin_mp
    ,end_mp
	,MRG_SECTION_ID
	,SCNS_HWY_EA_NO
	    )
     VALUES
    (
     i.nms_ne_id_first
     ,i.BIKE_R_TYP_CD
     ,i.BIKE_R_COND_CD
     ,i.BIKE_R_NEED_IND
     ,i.BIKE_R_WD_MEAS
     ,i.BIKE_R_INSP_YR
     ,i.BIKE_R_NOTE
     ,i.BIKE_L_TYP_CD
     ,i.BIKE_L_COND_CD
     ,i.BIKE_L_NEED_IND
     ,i.BIKE_L_WD_MEAS
     ,i.BIKE_L_INSP_YR
     ,i.BIKE_L_NOTE
     ,i.CURB_R_TYP_CD
     ,i.CURB_R_HT_CD
    ,i.CURB_R_COND_CD
    ,i.CURB_R_INSP_YR
    ,i.CURB_R_SRCE_TYP
    ,i.CURB_R_NOTE
    ,i.CURB_CD_TYP_CD
    ,i.CURB_CD_HT_CD
    ,i.CURB_CD_COND_CD
    ,i.CURB_CD_INSP_YR
    ,i.CURB_CD_SRCE_TYP
    ,i.CURB_CD_NOTE
    ,i.CURB_CI_TYP_CD
    ,i.CURB_CI_HT_CD
    ,i.CURB_CI_COND_CD
    ,i.CURB_CI_INSP_YR
    ,i.CURB_CI_SRCE_TYP
    ,i.CURB_CI_NOTE
    ,i.CURB_L_TYP_CD
    ,i.CURB_L_HT_CD
    ,i.CURB_L_COND_CD
    ,i.CURB_L_INSP_YR
    ,i.CURB_L_SRCE_TYP
    ,i.CURB_L_NOTE
    ,i.PARK_R_COND_CD
    ,i.PARK_R_WD_MEAS
    ,i.PARK_R_TYP_CD
    ,i.PARK_R_INSP_YR
    ,i.PARK_R_SRCE_TYP
    ,i.PARK_R_NOTE
    ,i.PARK_L_COND_CD
    ,i.PARK_L_WD_MEAS
    ,i.PARK_L_TYP_CD
    ,i.PARK_L_INSP_YR
    ,i.PARK_L_SRCE_TYP
    ,i.PARK_L_NOTE
	,i.CITY_R_NM
    ,i.CITY_L_NM
    ,i.SHUP_R_SURF_CD
    ,i.SHUP_R_COND_CD
    ,i.SHUP_R_INSP_YR
    ,i.SHUP_R_WD_MEAS
    ,i.SHUP_L_SURF_CD
    ,i.SHUP_L_COND_CD
    ,i.SHUP_L_INSP_YR
    ,i.SHUP_L_WD_MEAS
    ,i.SWLK_R_SURF_CD
    ,i.SWLK_R_COND_CD
    ,i.SWLK_R_BUF_IND
    ,i.SWLK_R_NEED_IND
    ,i.SWLK_R_INSP_YR
    ,i.SWLK_R_WD_MEAS
    ,i.SWLK_L_SURF_CD
    ,i.SWLK_L_COND_CD
    ,i.SWLK_L_BUF_IND
    ,i.SWLK_L_NEED_IND
    ,i.SWLK_L_INSP_YR
    ,i.SWLK_L_WD_MEAS
    ,i.ne_unique
    ,i.ne_owner
    ,i.ne_sub_type
    ,i.ne_prefix
    ,i.ne_name_1
    ,i.ne_name_2
    ,i.ne_number
    ,i.ne_group
    ,i.nms_begin_offset
    ,i.nms_end_offset
    ,i.merg_section_id
	,i.SCNS_HWY_EA_NO
   );


 end LOOP;
 COMMIT;

 FOR i in get_data2 LOOP
    FOR i2 IN get_rte_data(i.MRG_SECTION_ID ,p_job_id) LOOP

	  UPDATE XODOT_BKPD_MRG_RESULT
	  set RTE_TYPE_IS = i2.RTE_TYPE_IS
         ,RTE_TYPE_US_1 = i2.RTE_TYPE_US_1
         ,RTE_TYPE_US_2 = i2.RTE_TYPE_US_2
         ,RTE_TYPE_OR_1 = i2.RTE_TYPE_OR_1
         ,RTE_TYPE_OR_2 = i2.RTE_TYPE_OR_2
      WHERE MRG_SECTION_ID =i.MRG_SECTION_ID;

   END LOOP;
   commit;

  END LOOP;

  FOR i in get_data2 LOOP

	 FOR i2 in get_reg_dist(i.SCNS_HWY_EA_NO) LOOP

	  UPDATE XODOT_BKPD_MRG_RESULT
	  set region = i2.maint_reg_id
	  ,district = i2.maint_dist_id
      WHERE MRG_SECTION_ID =i.MRG_SECTION_ID;

	 END LOOP;

	commit;
  END LOOP;

END pop_mrg_result_table;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_bike_ped IS

l_mrg_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE;

BEGIN
  ----- get rid of this at some point only here for testing

  run_merge_new(l_mrg_job_id);

  pop_mrg_result_table(l_mrg_job_id);


END refresh_bike_ped;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_bike_ped_all_network IS

l_mrg_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE;

BEGIN


  run_merge_all(l_mrg_job_id);

  pop_mrg_result_table(l_mrg_job_id);


END refresh_bike_ped_all_network;
--
---------------------------------------------------------------------------------------------------
--
PROCEDURE pop_mrg_result_table_point IS

CURSOR get_adar IS
select
c.typ_cd
,c.iit_x_sect
,c.xst_nm
,c.func_cond_cd
,c.phys_cond_cd
,c.need_ind
,c.insp_yr
,c.note
       ,c.iit_primary_key
       ,b.route_id
	  ,b.HIGHWAY_NUMBER
      ,b.SUFFIX
      ,b.ROADWAY_ID
      ,b.MILEAGE_TYPE
      ,b.OVERLAP_MILEAGE_CODE
      ,b.general_ROAD_DIRECTION
      ,b.ROAD_TYPE
      , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(a.nm_begin_mp,b.nm_begin_mp)) - b.nm_begin_mp,
               b.nm_slk + (b.nm_end_mp  - least(a.nm_end_mp, b.nm_end_mp))) start_point
      , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(a.nm_end_mp, b.nm_end_mp)),
                    b.nm_slk + (b.nm_end_mp - greatest(a.nm_begin_mp, b.nm_begin_mp))) end_point
FROM nm_members a
    , (SELECT ne_unique route_id
            , nm_slk
            , nm_end_slk
                , nm_end_slk - nm_slk section_length
                , nm_begin_mp
                , nm_end_mp
                , nm_ne_id_of
                , nm_cardinality
				,HIGHWAY_NUMBER
                ,SUFFIX
                ,ROADWAY_ID
                ,MILEAGE_TYPE
                ,OVERLAP_MILEAGE_CODE
                ,general_ROAD_DIRECTION
                ,ROAD_TYPE
        FROM v_nm_hwy_nt
                , nm_members
        WHERE ne_id = nm_ne_id_in) b
    , v_nm_adar c
WHERE a.nm_ne_id_of = b.nm_ne_id_of
and a.nm_ne_id_in = c.iit_ne_id;

CURSOR get_mbxg is
select c.iit_primary_key
       ,b.route_id
      ,b.HIGHWAY_NUMBER
      ,b.SUFFIX
      ,b.ROADWAY_ID
      ,b.MILEAGE_TYPE
      ,b.OVERLAP_MILEAGE_CODE
      ,b.general_ROAD_DIRECTION
      ,b.ROAD_TYPE
      , decode(b.nm_cardinality, 1, b.nm_slk + (greatest(a.nm_begin_mp,b.nm_begin_mp)) - b.nm_begin_mp,
               b.nm_slk + (b.nm_end_mp  - least(a.nm_end_mp, b.nm_end_mp))) start_point
 , decode(b.nm_cardinality, 1, b.nm_end_slk - (b.nm_end_mp - least(a.nm_end_mp, b.nm_end_mp)),
                    b.nm_slk + (b.nm_end_mp - greatest(a.nm_begin_mp, b.nm_begin_mp))) end_point
FROM nm_members a
    , (SELECT ne_unique route_id
            , nm_slk
            , nm_end_slk
                , nm_end_slk - nm_slk section_length
                , nm_begin_mp
                , nm_end_mp
                , nm_ne_id_of
                , nm_cardinality
                ,HIGHWAY_NUMBER
                ,SUFFIX
                ,ROADWAY_ID
                ,MILEAGE_TYPE
                ,OVERLAP_MILEAGE_CODE
                ,general_ROAD_DIRECTION
                ,ROAD_TYPE
        FROM v_nm_hwy_nt
                , nm_members
        WHERE ne_id = nm_ne_id_in) b
    , v_nm_mbxg c
WHERE a.nm_ne_id_of = b.nm_ne_id_of
and a.nm_ne_id_in = c.iit_ne_id;

CURSOR get_hwy IS
select distinct(hwy) from XODOT_BKPD_POINT_RESULT;

CURSOR get_begin (p_hwy XODOT_BKPD_POINT_RESULT.hwy%TYPE) IS
select distinct(begin_mp) from XODOT_BKPD_POINT_RESULT
where hwy = p_hwy;

CURSOR get_rte_info (p_mp number, p_hwy XODOT_BKPD_POINT_RESULT.hwy%TYPE) IS
select rte_type_is, rte_type_us_1, rte_type_us_2, rte_type_or_1, rte_type_or_2 from xodot_rwy_report
where hwy =  p_hwy
and begin_mp <= p_mp
and end_mp >= p_mp;

CURSOR get_adar_det is
select * from v_nm_adar_nw
where iit_primary_key in  (select  iit_primary_key from XODoT_BKPD_POINT_RESULT
                                       where adar_primary_key is not null);

CURSOR get_city (p_ne_id_of number, p_mp number)IS
select b.*, a.iit_x_sect from v_nm_city_nw a, v_nm_cilk b
where a.ne_id_of = p_ne_id_of
and nm_begin_mp <= p_mp
and nm_end_mp >= p_mp
and a.nm = b.nm ;

CURSOR get_mbxg_det is
select * from  v_nm_mbxg_nw
where iit_primary_key in  (select  iit_primary_key from XODoT_BKPD_POINT_RESULT
                                       where mbxg_primary_key is not null);

CURSOR get_ea (p_ne_id_of number) IS
select * from XODOT_EA_CW_DIST_REG_LOOKUP
where ea_number = (select ne_unique from nm_elements
                   where ne_id = (select nm_ne_id_in from nm_members
                                  where nm_ne_id_of = p_ne_id_of
                                  and nm_obj_type =  'SEEA'
                                  and rownum = 1 ));

CURSOR get_urban (p_ne_id_of number) IS
select ne_unique from nm_elements
where ne_id in (select nm_ne_id_in from nm_members
                        where  nm_obj_type = 'URBN'
                        and nm_ne_id_of = p_ne_id_of);

BEGIN

delete from XODOT_BKPD_POINT_RESULT;
commit;

   FOR i IN get_adar LOOP

      insert into XODOT_BKPD_POINT_RESULT
	  (adar_primary_key
      ,adar_ramp_typ_cd
      ,adar_xsp
      ,adar_cross_st_nm
      ,adar_ramp_FUNC_COND_CD
      ,adar_RAMP_PHYS_COND_CD
      ,adar_RAMP_NEED_IND
      ,adar_RAMP_INSP_YR
      ,adar_RAMP_NOTE
      ,HWY
      ,BEGIN_MP
	  ,end_mp
      ,HIGHWAY_NUMBER
      ,SUFFIX
      ,ROADWAY_ID
      ,MILEAGE_TYPE
      ,OVERLAP_MILEAGE_CODE
      ,ROAD_DIRECTION
      ,ROAD_TYPE)
	  values
	  (i.iit_primary_key
	  ,i.typ_cd
      ,i.iit_x_sect
      ,i.xst_nm
      ,i.func_cond_cd
      ,i.phys_cond_cd
      ,i.need_ind
	  ,i.insp_yr
      ,i.note
      ,i.route_id
	  ,i.start_point
	  ,i.end_point
	  ,i.HIGHWAY_NUMBER
      ,i.SUFFIX
      ,i.ROADWAY_ID
      ,i.MILEAGE_TYPE
      ,i.OVERLAP_MILEAGE_CODE
      ,i.general_ROAD_DIRECTION
      ,i.ROAD_TYPE
	  );

   END LOOP;
commit;

FOR i IN get_mbxg LOOP

      insert into XODOT_BKPD_POINT_RESULT
	  (mbxg_primary_key
      ,HWY
      ,BEGIN_MP
	  ,end_mp
      ,HIGHWAY_NUMBER
      ,SUFFIX
      ,ROADWAY_ID
      ,MILEAGE_TYPE
      ,OVERLAP_MILEAGE_CODE
      ,ROAD_DIRECTION
      ,ROAD_TYPE)
	  values
	  (i.iit_primary_key
	  ,i.route_id
	  ,i.start_point
	  ,i.end_point
	  ,i.HIGHWAY_NUMBER
      ,i.SUFFIX
      ,i.ROADWAY_ID
      ,i.MILEAGE_TYPE
      ,i.OVERLAP_MILEAGE_CODE
      ,i.general_ROAD_DIRECTION
      ,i.ROAD_TYPE
	  );

   END LOOP;
commit;


FOR i IN get_hwy LOOP

   FOR i2 IN get_begin(i.hwy) LOOP

      FOR i3 IN get_rte_info(i2.begin_mp,i.hwy) LOOP

        UPDATE XODOT_BKPD_POINT_RESULT
		set rte_type_is = i3.rte_type_is
		, rte_type_us_1 = i3.rte_type_us_1
		, rte_type_us_2 = i3.rte_type_us_2
		, rte_type_or_1 = i3.rte_type_or_1
		, rte_type_or_2 = i3.rte_type_or_2
		WHERE hwy = i.hwy
		AND begin_mp = i2.begin_mp;

      END LOOP;

    END LOOP;

END LOOP;
commit;


FOR i in get_adar_det LOOP

   FOR i2 IN get_city (i.ne_id_of, i.nm_begin_mp) loop

	  IF i2.iit_x_sect = 'L' THEN
	    UPDATE XODOT_BKPD_POINT_RESULT
	    set FIPS_CITY_ID_LEFT = i2.fips_id
         ,CITY_GNIS_ID_LEFT = i2.gnis_id
	     ,city_pop_cnt_left = i2.pop_cnt
	     WHERE adar_primary_key = i.iit_primary_key;
	  ELSIF i2.iit_x_sect = 'R' THEN
	    UPDATE XODOT_BKPD_POINT_RESULT
	    set FIPS_CITY_ID_right = i2.fips_id
         ,CITY_GNIS_ID_right = i2.gnis_id
	     ,city_pop_cnt_right = i2.pop_cnt
	     WHERE adar_primary_key = i.iit_primary_key;
	   END IF;
   END LOOP;

   FOR i2 IN get_ea(i.ne_id_of) LOOP

       UPDATE XODOT_BKPD_POINT_RESULT
	   SET ea = i2.EA_NUMBER
	   ,district = i2.maint_dist_id
	   ,region = i2.maint_reg_id
        WHERE adar_primary_key = i.iit_primary_key;

   END LOOP;

   FOR i2 IN get_urban(i.ne_id_of) LOOP
      UPDATE XODOT_BKPD_POINT_RESULT
	  SET urban_area = i2.ne_unique
	  WHERE adar_primary_key = i.iit_primary_key;

   END LOOP;

END LOOP;
commit;

FOR i in get_mbxg_det LOOP

   FOR i2 IN get_city (i.ne_id_of, i.nm_begin_mp) loop

	  IF i2.iit_x_sect = 'L' THEN
	    UPDATE XODOT_BKPD_POINT_RESULT
	    set FIPS_CITY_ID_LEFT = i2.fips_id
         ,CITY_GNIS_ID_LEFT = i2.gnis_id
	     ,city_pop_cnt_left = i2.pop_cnt
	     WHERE mbxg_primary_key = i.iit_primary_key;
	  ELSIF i2.iit_x_sect = 'R' THEN
	    UPDATE XODOT_BKPD_POINT_RESULT
	    set FIPS_CITY_ID_right = i2.fips_id
         ,CITY_GNIS_ID_right = i2.gnis_id
	     ,city_pop_cnt_right = i2.pop_cnt
	     WHERE mbxg_primary_key = i.iit_primary_key;
	   END IF;

   END LOOP;

   FOR i2 IN get_ea(i.ne_id_of) LOOP

       UPDATE XODOT_BKPD_POINT_RESULT
	   SET ea = i2.EA_NUMBER
	   ,district = i2.maint_dist_id
	   ,region = i2.maint_reg_id
	   WHERE mbxg_primary_key = i.iit_primary_key;

   END LOOP;

   FOR i2 IN get_urban(i.ne_id_of) LOOP
      UPDATE XODOT_BKPD_POINT_RESULT
	  SET urban_area = i2.ne_unique
	  WHERE mbxg_primary_key = i.iit_primary_key;

   END LOOP;
END LOOP;
commit;


END pop_mrg_result_table_point;
--
---------------------------------------------------------------------------------------------------
--
END xodot_bike_ped;
/
