CREATE OR REPLACE PACKAGE BODY TRANSINFO.XODOT_FI_REPORT AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/Oregon/FI Reporting/Version 8.0/Version_8.0/Admin/pck/xodot_fi_report.pkb-arc   1.0   Jan 15 2016 17:53:16   Sarah.Williams  $
--       Module Name      : $Workfile:   xodot_fi_report.pkb  $

--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--
--   Author : P Stanton
--
--   XODOT_FI_REPORT body

--   Altered by R. Ellis to remove dependance on HACT.REPORT_COLUMN = Y.
--    it now just uses one per column.


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
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   1.0  $"';

  g_package_name CONSTANT varchar2(30) := 'XODOT_FI_REPORT';
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
FUNCTION equiv_bit_miles (p_begin_mp  number
                              ,p_end_mp  number
                              ,p_hwy  nm_elements.ne_unique%type
                         ) return NUMBER IS

retval number := 0;

begin

    select
    sum (
         (lane_count * leng) --lane
         +
         (
             case when osD_width > 0 and osD_width <= 4
                  then   1/3
                  when osD_width > 4
                  then 2/3
                  else 0
             end
             * leng
         ) --osd
         +
         (
             case when isD_width > 0 and isD_width <= 4
                  then   1/3
                  when isD_width > 4
                  then 2/3
                  else 0
             end
             * leng
         ) --isd
         +
         (
             case when isi_width > 0 and isi_width <= 4
                  then   1/3
                  when isi_width > 4
                  then 2/3
                  else 0
             end
             * leng
         ) --isi
         +
         (
             case when osi_width > 0 and osi_width <= 4
                  then   1/3
                  when osi_width > 4
                  then 2/3
                  else 0
             end
             * leng
         ) --osi
    ) into retval
    from
    (
        select
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN1I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN2I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN3I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN4I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN5I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN6I_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN1D_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN2D_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN3D_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN4D_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN5D_MATL_TYP_CD),'AU',1,0) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_LN6D_MATL_TYP_CD),'AU',1,0) lane_count,
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_oS1D_MATL_TYP_CD),'AU', R.RDGM_oS1D_WD_MEAS
                                                                                ,'CU',R.RDGM_oS1D_WD_MEAS
                                                                                     ,0
              ) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_oS2D_MATL_TYP_CD),'AU', R.RDGM_oS2D_WD_MEAS
                                                                                ,'CU', R.RDGM_oS2D_WD_MEAS
                                                                                     ,0
              ) osD_width,
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_iS1D_MATL_TYP_CD),'AU', R.RDGM_iS1D_WD_MEAS
                                                                                ,'CU',R.RDGM_iS1D_WD_MEAS
                                                                                     ,0
              ) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_iS2D_MATL_TYP_CD),'AU', R.RDGM_iS2D_WD_MEAS
                                                                                ,'CU', R.RDGM_iS2D_WD_MEAS
                                                                                     ,0
              ) isD_width,
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_iS1I_MATL_TYP_CD),'AU', R.RDGM_iS1I_WD_MEAS
                                                                                ,'CU',R.RDGM_iS1I_WD_MEAS
                                                                                     ,0
              ) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_iS2I_MATL_TYP_CD),'AU', R.RDGM_iS2I_WD_MEAS
                                                                                ,'CU', R.RDGM_iS2I_WD_MEAS
                                                                                     ,0
              ) isI_width,
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_OS1I_MATL_TYP_CD),'AU', R.RDGM_OS1I_WD_MEAS
                                                                                ,'CU',R.RDGM_OS1I_WD_MEAS
                                                                                     ,0
              ) +
        decode(XODOT_HTDR1_GEN.GET_SIMPLIFIED_MATERIAL (R.RDGM_OS2I_MATL_TYP_CD),'AU', R.RDGM_OS2I_WD_MEAS
                                                                                ,'CU', R.RDGM_OS2I_WD_MEAS
                                                                                     ,0
              ) osI_width     ,
              R.END_MP - R.BEGIN_MP leng
         from xodot_rwy_report r
        where
           R.HWY = p_hwy
           and R.BEGIN_MP >= p_begin_mp
           and R.END_MP <= p_end_mp
    );

    return retval;


end equiv_bit_miles;

/*
-----------------------------------------------------------------------------
--<PROC NAME="equiv_bit_miles">
--FUNCTION to calculate equivalent  bitumen miles
FUNCTION equiv_bit_miles (p_ne_id  nm_elements.ne_id%TYPE
						 ) return NUMBER IS


CURSOR get_greater_than	(p_ne_id  nm_elements.ne_id%TYPE) IS
select nvl(sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)),0)
from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from v_nm_rdgm, nm_members
         where iit_ne_id = nm_ne_id_in   and nm_obj_type = 'RDGM' and  matl_typ_cd IN ('AU','A' ,'AU','B','C','CP','CS','D','DS','E','EA','F','FS','HR','HS','L','M','MS','R','SL','SM','SS','Z')
AND iit_x_sect in ('OS2I', 'OS2D', 'OS1I', 'OS1D','IS1D','IS1I','IS2D','IS2I')      -- Restricting to shoulders
AND wd_meas > 4                                                                    -- and greater than  4
AND layer = 1 ) r, nm_elements s, nm_members sm
where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in
     (select cm.nm_ne_id_of
     from nm_members cm, nm_elements c
     where c.ne_id = p_ne_id
     and ne_id = nm_ne_id_in
     )
and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp;

CURSOR get_less_than (p_ne_id  nm_elements.ne_id%TYPE) IS
select nvl(sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) ,0)
from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from v_nm_rdgm, nm_members
         where iit_ne_id = nm_ne_id_in   and nm_obj_type = 'RDGM'
         and  matl_typ_cd IN ('AU','A' ,'AU','B','C','CP','CS','D','DS','E','EA','F','FS','HR','HS','L','M','MS','R','SL','SM','SS','Z')

AND iit_x_sect in ('OS2I', 'OS2D', 'OS1I', 'OS1D','IS1D','IS1I','IS2D','IS2I')     -- Restricting to shoulders
AND wd_meas <= 4                                                                    -- and less than  4
AND layer = 1 ) r, nm_elements s, nm_members sm
where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in
(select cm.nm_ne_id_of from nm_members cm, nm_elements c
where c.ne_id = p_ne_id
and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp;

CURSOR get_the_rest	(p_ne_id  nm_elements.ne_id%TYPE) IS
select nvl(sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) ,0)
from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from v_nm_rdgm, nm_members
         where iit_ne_id = nm_ne_id_in   and nm_obj_type = 'RDGM'
         and  matl_typ_cd IN ('AU','A' ,'AU','B','C','CP','CS','D','DS','E','EA','F','FS','HR','HS','L','M','MS','R','SL','SM','SS','Z')
AND iit_x_sect like 'LN%' -- =NOT IN ('RS2I', 'RS2D', 'RS1I', 'RS1D','LS1D','LS1I','LS2D','LS2I')
AND layer = 1 ) r, nm_elements s, nm_members sm
where ne_id = nm_ne_id_in
and nm_ne_id_of = ne_id_of
and ne_id in
     (select cm.nm_ne_id_of
        from nm_members cm, nm_elements c
        where c.ne_id = p_ne_id
        and ne_id = nm_ne_id_in
     ) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp;


--select ne_id, ne_nt_type from nm_elements where ne_unique = '1101'



l_greater_than_shoulder NUMBER;
l_less_than_shoulder    NUMBER;
l_the_rest     number;
l_final_total  NUMBER;

BEGIN

--Take the lenth of the shoulder, if it's 4 feet wide or less multiply  the length by 0.3333 if it's greater multiply by 0.666666

   OPEN get_greater_than(p_ne_id);
   FETCH get_greater_than INTO l_greater_than_shoulder;
   CLOSE get_greater_than;

   OPEN get_less_than(p_ne_id);
   FETCH get_less_than INTO l_less_than_shoulder;
   CLOSE get_less_than;

   OPEN get_the_rest(p_ne_id);
   FETCH get_the_rest INTO l_the_rest;
   CLOSE get_the_rest;

   l_final_total := (l_less_than_shoulder*0.3333) + (l_greater_than_shoulder*0.666666) + l_the_rest;

   RETURN l_final_total;

END equiv_bit_miles;
			--

            */
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_CREW_ACT">
-- Procedure Determine the crews and activities to be processed
PROCEDURE GET_CREW_ACT IS
--
   CURSOR get_crew_types IS
   SELECT DISTINCT(crew_type) FROM V_NM_HACT
   where calculation_type != 'LUMP SUM';
--
   CURSOR get_activity_data (p_crew_type v_nm_hact.crew_type%TYPE)IS
            
 SELECT  lookup_crew crew_unique
          , ea.ne_nt_type EA_type
       ,count_sections.iit_inv_type
      ,count_sections.iit_ne_id
      , locs.hwy
      , locs.begin_mp
      ,locs.end_mp      
      ,count_sections.IIT_ITEMCODE EA
    ,calculation_type
   ,asset_type
   ,attribute_type
   ,attribute_values
   ,hact.crew_type
   ,feature_type
   , district
   , region
   FROM
   (    select 
        NM3NET.GET_NE_UNIQUE(hwy.nm_ne_id_in) hwy,
        min(hwy.nm_slk+inv.nm_begin_mp) begin_mp,
        max(hwy.nm_slk+inv.nm_end_mp) end_mp,
        inv.nm_ne_id_in iit_ne_id
        from nm_members inv, nm_members hwy
        where hwy.nm_obj_type = 'HWY'
        and inv.nm_obj_type in ('SCNS','ELCS','BRGS','SGNS','LDSS','STPS','SCNS')
        and hwy.nm_ne_id_of = inv.nm_ne_id_of
        --and inv.nm_ne_id_in = 5419008
        group by hwy.nm_ne_id_in, inv.nm_ne_id_in
   ) locs,
   (     
    select * from V_NM_HACT
      where iit_ne_id in
         (
            select min(iit_ne_id) from v_nm_HACT
            where calculation_type !=  'LUMP SUM'
            group by calculation_type, asset_type, ATTRIBUTE_TYPE, crew_type, FEATURE_TYPE
        )      
    ) hact
   , nm_inv_items count_sections
   , nm_elements ea
   , (  
   select 'SECW' lookup_crew_type
      , nm3net.get_ne_unique(r.nm_ne_id_in) region
      ,district
      ,crew lookup_crew
      ,ne_id
             from nm_members r,
             v_nm_SEcw_SEcw_nt
       where r.nm_obj_type = 'REG'
       and nm_type = 'G'
       and nm3net.get_ne_unique(r.nm_ne_id_of) = district
        union
        select 'LDCW', region, null district, crew , ne_id  from v_nm_LDCW_ldcw_NT where ne_gty_group_type = --'SECW' --  
                                                                                                            p_crew_type 
        union
        select 'SNCW', region, null district, crew  , ne_id from v_nm_sncw_sncw_nt where ne_gty_group_type = --'SECW' --   
                                                                                                            p_crew_type 
        union
        select 'ELCW', region, null district, crew  , ne_id from v_nm_elcw_elcw_nt where ne_gty_group_type = --'SECW' --   
                                                                                                            p_crew_type 
        union
        select 'BGCW', region, null district, crew  , ne_id from v_nm_bgcw_bgcw_nt where ne_gty_group_type = --'SECW' --   
                                                                                                            p_crew_type 
        union
        select 'SPCW', region, null district, crew  , ne_id from v_nm_spcw_spcw_nt where ne_gty_group_type = --'SECW' --   
                                                                                                            p_crew_type 
   ) crew,
   (   select nm_ne_id_of ea_ne_id,
        nm_ne_id_in crew_ne_id
        from nm_members
        where nm_obj_type = --'SECW'
                         p_crew_type        
   ) crew_ea
   WHERE
   locs.iit_ne_id = count_sections.iit_ne_id
   and hact.crew_type =--- 'SECW'
                         p_crew_type
   and hact.asset_type = count_sections.iit_inv_type              
   and count_sections.iit_inv_type   =  --'SCNS'
                           xodot_asset_type_functions.f$get_group_asset_type(  p_crew_type     ,'CREW_ASSET_GROUP_TYPES')                     
     and count_sections.iit_itemcode = ea.ne_unique
      AND ea.NE_ID = crew_ea.ea_ne_id
    and crew_ne_id = crew.ne_id
   order by iit_ne_id;

--
   CURSOR get_count_section_det IS
  
 SELECT distinct(count_section_id),count_section_type FROM xodot_hbud_fi_report;
 
--
 /*  CURSOR get_crews IS
   select distinct(EA), maint_reg_id, maint_dist_id from XODOT_HBUD_FI_REPORT, XODOT_EA_CW_DIST_REG_LOOKUP
    where ea_number = ea;

    */
--
l_route_info nm3route_ref.tab_rec_route_loc_dets;
--

BEGIN

   FOR i IN get_crew_types LOOP   ---- Get he distinct crew types to be processed

      -- for each crew type populate the count sections and Activities and the asset info that it is related to
      FOR i2 IN get_activity_data(i.crew_type) LOOP

		    INSERT INTO XODOT_HBUD_FI_REPORT
		    ( COUNT_SECTION_ID
			 ,COUNT_SECTION_TYPE
             ,HIGHWAY
             , BEGIN_MP
             , END_MP
		     ,crew_type
		     ,asset_type
		     ,feature_type
			 ,EA
             ,crew
             ,district
             ,region	 )
		     VALUES
		    (i2.iit_ne_id
			,i2.iit_inv_type
            ,i2.Hwy
             ,i2. BEGIN_MP
             ,i2.END_MP
			,i.crew_type  ----  on the groups types there is no limit so this could be bigger than the 4 characters for crew id
		  	,i2.asset_type
		    ,i2.feature_type
			,i2.EA
			,i2.crew_unique
            ,i2.district
             ,i2.region
		    );

            commit;

      END LOOP;


	  COMMIT;

	END LOOP;

/*  this doesn't work bec

	 -- Populate Count section information
      FOR i IN get_count_section_det LOOP

	     nm3asset.get_inv_route_location_details (pi_iit_ne_id  =>   i.count_section_id
                                                  ,pi_nit_inv_type     => i.COUNT_SECTION_TYPE
                                                  ,po_tab_route_loc_dets  =>  l_route_info
                                                  );

         FOR i2 IN 1..l_route_info.COUNT LOOP

		    UPDATE XODOT_HBUD_FI_REPORT
		    SET HIGHWAY  = l_route_info(i2).route_ne_unique
		       ,begin_mp = l_route_info(i2).nm_slk
		       ,end_mp   = l_route_info(i2).nm_end_slk
		    WHERE count_section_id = i.count_section_id;
		   commit;
         END LOOP;

      END LOOP;
      
      */

  /*
   -- Get District Or Region
   FOR i IN get_crews LOOP

	  UPDATE XODOT_HBUD_FI_REPORT
	  SET district = i.maint_dist_id
	  WHERE ea = i.ea
	  and crew_type = 'SECW';


	  UPDATE XODOT_HBUD_FI_REPORT
	  SET region = i.maint_reg_id
	  WHERE ea = i.ea;


   END LOOP;*/

   commit;
END GET_CREW_ACT;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="determine_asset_storage">
-- Procedure to determine if the value is calculated from a count,length, summary
-- or calculation. Then calls process and updates extract table with the result.
PROCEDURE determine_asset_storage is
--
   CURSOR get_data IS

      SELECT
   a.count_section_id
   ,a.crew
   , a.crew_type
   ,a.begin_mp
   ,a.end_mp
   ,A.HIGHWAY
   ,c.ne_id
   , b.feature_type
   ,b.asset_type
   ,b.calculation_type
   ,b.attribute_type
   ,b.attribute_values
   , d.ita_attrib_name
   ,d.ita_units
   FROM XODOT_HBUD_FI_REPORT a ,v_nm_hwy_nt c,
   (
       select * from  V_NM_HACT
       where iit_ne_id in
             (
                select min(iit_ne_id) from v_nm_HACT
                where calculation_type !=  'LUMP SUM'
                group by calculation_type, asset_type, ATTRIBUTE_TYPE, crew_type, FEATURE_TYPE
             )
   ) b
   full outer join  nm_inv_type_attribs d
   on ( d.ita_inv_type = b.asset_type and d.ita_view_col_name = b.attribute_type  )
   WHERE --a.activity = b.activity   AND
   a.feature_type = b.feature_type
   and a.crew_type = b.crew_type
   AND c.ne_unique = a.highway
  -- and calculation_type = 'LENGTH' -- debug
  -- and a.feature_type = 'GUARDRAIL (METAL/WOOD/CABLE RAIL (MILES)' -- debug
   ORDER BY crew;


--
 l_feature_count VARCHAR2(4000);
 l_unit_of_measure nm_units%ROWTYPE;
--
BEGIN

   FOR i IN get_data LOOP
      IF i.ita_units IS NOT NULL THEN
	     l_unit_of_measure := nm3get.get_un(pi_un_unit_id => i.ita_units);
	  ELSE
	     l_unit_of_measure := null;
	  END IF;

	  IF i.calculation_type = 'SUMMARY' THEN
                                              -- call the summary process passing the ne_id of the crew
											  -- the sum of the specified attribute will be returned.
  	   l_feature_count :=   summary_process(p_asset_type => i.asset_type
                                           ,p_ne_id  => i.count_section_id
						                   ,p_attribute_name => i.ita_attrib_name);

		 -- Update the extract table with the value returned and the units of measure
		 UPDATE XODOT_HBUD_FI_REPORT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = l_unit_of_measure.un_unit_name
	     WHERE crew = i.crew
         and crew_type = i.crew_type
	     AND feature_type = i.feature_type
		 and count_section_id = i.count_section_id;

	  ELSIF i.calculation_type = 'CALCULATED' THEN

		 l_feature_count :=  calculated_process(p_crew              => i.crew
                                               ,p_ne_id            => i.count_section_id
							                   ,p_feature_type     => i.feature_type
							                   ,p_asset_type       => i.asset_type
							                   ,p_calculation_type => i.calculation_type
							                   ,p_attribute_type   => i.attribute_type
							                   ,p_attribute_values => i.attribute_values
 							                   ,p_ita_attrib_name  => i.ita_attrib_name
							                   ,p_ita_units        => i.ita_units
                                               ,p_begin_mp         => i.begin_mp
                                               ,p_end_mp           => i.end_mp
                                               ,p_hwy              => i.highway);



		   UPDATE XODOT_HBUD_FI_REPORT
	       SET feature_count = nvl(l_feature_count,0)
		      ,unit_of_measure = 'CALCULATED'
	       WHERE crew = i.crew
	       AND crew_type = i.crew_type
	       AND feature_type = i.feature_type
		   and count_section_id = i.count_section_id;

	  ELSIF i.calculation_type = 'COUNT' THEN

		l_feature_count := count_process(p_asset_type => i.asset_type
                                        ,p_ne_id  => i.count_section_id
						                ,p_attribute_name => i.ita_attrib_name
						                ,p_attribute_values => i.attribute_values);

         UPDATE XODOT_HBUD_FI_REPORT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = 'COUNT'
	     WHERE crew = i.crew
	     AND crew_type = i.crew_type
	     AND feature_type = i.feature_type
		 AND count_section_id = i.count_section_id;

	  ELSIF i.calculation_type = 'LENGTH' THEN

           l_feature_count := length_process(p_asset_type => i.asset_type
                                            ,p_ne_id  => i.count_section_id
				     		                ,p_attribute_name => i.ita_attrib_name
					    	                ,p_attribute_values => i.attribute_values);

         UPDATE XODOT_HBUD_FI_REPORT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = 'MILES'
	     WHERE crew = i.crew
	     AND crew_type = i.crew_type
	     AND feature_type = i.feature_type
		 AND count_section_id = i.count_section_id;


	  END IF;
      commit;

   END LOOP;
   commit;

END determine_asset_storage;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="summary_process">
-- Procedure to process activities defined as Summary
FUNCTION summary_process (p_asset_type nm_inv_items.iit_inv_type%TYPE
                         ,p_ne_id  nm_elements.ne_id%TYPE
						 ,p_attribute_name nm_inv_type_attribs.ita_attrib_name%TYPE) return VARCHAR2 IS

  TYPE cur_typ IS REF CURSOR;
  c_cursor cur_typ;
  v_query  VARCHAR2(4000);
  l_result VARCHAR2(4000);

BEGIN

   v_query := 'SELECT sum('||p_attribute_name||') FROM nm_inv_items
               WHERE iit_ne_id in (select iit_ne_id from v_nm_'||p_asset_type||'_nw a, nm_members b
                                                                        where a.ne_id_of =  b.nm_ne_id_of
                                                                        and b.nm_ne_id_in = '||p_ne_id||'
                                                                        and b.nm_begin_mp <= a.nm_begin_mp
                                                                        and b.nm_end_mp >= a.nm_end_mp)';

   OPEN c_cursor FOR v_query;
   LOOP
     FETCH c_cursor INTO l_result;
     EXIT WHEN c_cursor%NOTFOUND;
    -- process row here
	 return l_result;

   END LOOP;
   CLOSE c_cursor;
    EXCEPTION WHEN OTHERS THEN
	    nm_debug.debug(v_query);

END summary_process;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="calculated_process">
-- Function to process activities defined as calculated
FUNCTION calculated_process (p_crew              v_nm_hact.crew_type%TYPE
                             ,p_ne_id            nm_elements.ne_id%TYPe
							 ,p_feature_type     v_nm_hact.feature_type%TYPE
							 ,p_asset_type       v_nm_hact.asset_type%TYPE
							 ,p_calculation_type v_nm_hact.calculation_type%TYPE
							 ,p_attribute_type   v_nm_hact.attribute_type%TYPE
							 ,p_attribute_values v_nm_hact.attribute_values%TYPE
 							 ,p_ita_attrib_name  nm_inv_type_attribs.ita_attrib_name%TYPE
							 ,p_ita_units        nm_inv_type_attribs.ita_units%TYPE
                             ,p_begin_mp         number
                             ,p_end_mp           number
                             ,p_hwy              nm_elements_all.ne_unique%TYPE
                                                        ) return NUMBER is

l_result VARCHAR2(4000);
BEGIN
-- For the Calculated process it is expected that the p_attribute_values parameter will contain a function name
-- this function name will be a custom fucntion that will calculate a value and pass back a number.

IF p_attribute_values = 'EQUIV_BIT_MILES' THEN
   l_result:= equiv_bit_miles   (
                              p_begin_mp => p_begin_mp
                              ,p_end_mp  => p_end_mp
                              ,p_hwy => p_hwy );
ELSE
   l_result:= NULL;
END IF;

RETURN l_result;
END calculated_process;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="count_process">
-- FUNCTION to process activities defined as count
FUNCTION count_process  (p_asset_type nm_inv_items.iit_inv_type%TYPE
                        ,p_ne_id  nm_elements.ne_id%TYPE
						,p_attribute_name nm_inv_type_attribs.ita_attrib_name%TYPE
						,p_attribute_values V_NM_HACT.attribute_values%TYPE) return NUMBER IS


  TYPE cur_typ IS REF CURSOR;
  c_cursor cur_typ;
  v_query  VARCHAR2(4000);
  l_result NUMBER;
  l_attribute_values VARCHAR2(4000);

BEGIN

	IF p_attribute_name IS NOT NULL and p_attribute_values is not null THEN
       -- Format the attribute values string
	   l_attribute_values := REPLACE(p_attribute_values,'"','''');

       v_query := 'SELECT count(*) FROM nm_inv_items WHERE iit_ne_id in (select iit_ne_id from v_nm_'||p_asset_type||'_nw a, nm_members b
                                                                         where a.ne_id_of =  b.nm_ne_id_of
                                                                         and b.nm_ne_id_in = '||p_ne_id||'
                                                                         and b.nm_begin_mp <= a.nm_begin_mp
                                                                         and b.nm_end_mp >= a.nm_end_mp)
                   and '||p_attribute_name||' in ('||l_attribute_values||')';
	ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  v_query := 'SELECT count(*) FROM nm_inv_items WHERE iit_ne_id in (select iit_ne_id from v_nm_'||p_asset_type||'_nw a, nm_members b
                                                                        where a.ne_id_of =  b.nm_ne_id_of
                                                                        and b.nm_ne_id_in = '||p_ne_id||'
                                                                        and b.nm_begin_mp <= a.nm_begin_mp
                                                                        and b.nm_end_mp >= a.nm_end_mp)';

	END IF;


   OPEN c_cursor FOR v_query;
   LOOP
     FETCH c_cursor INTO l_result;
     EXIT WHEN c_cursor%NOTFOUND;
    -- process row here
	 return l_result;

   END LOOP;
   CLOSE c_cursor;
    EXCEPTION WHEN OTHERS THEN
	    nm_debug.debug(v_query);

END count_process;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="length_process">
-- Function to process activities defined as length
FUNCTION length_process (p_asset_type nm_inv_items.iit_inv_type%TYPE
                        ,p_ne_id  nm_elements.ne_id%TYPE
						,p_attribute_name nm_inv_type_attribs.ita_attrib_name%TYPE
						,p_attribute_values V_NM_HACT.attribute_values%TYPE) return NUMBER IS

  TYPE cur_typ IS REF CURSOR;
  c_cursor cur_typ;
  v_query  VARCHAR2(4000);
  l_result NUMBER;
  l_attribute_values VARCHAR2(4000);

BEGIN

   IF  p_asset_type = 'RDGM' THEN
	    -- Need to Restrict by layer and XSP
		IF p_attribute_name IS NOT NULL AND p_attribute_values is not null THEN
          -- Format the attribute values string
	      l_attribute_values := REPLACE(p_attribute_values,'"','''');

--       v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||'  ) and '||p_attribute_name||' in ('||l_attribute_values||')';
         --v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and '||p_attribute_name||' in ('||l_attribute_values||') and iit_no_of_units = 1 and iit_x_sect like '||''''||'LN%'||''''||' ) r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';
         v_query := ' select sum (least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp))
   from (
                select   nm_ne_id_of ne_id_of
                ,nm_end_mp,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and   iit_no_of_units = ''1''
                and iit_x_sect like '||''''||'LN%'||''''||'
                and nm_obj_type = ''RDGM''
                and iit_inv_type = ''RDGM''
                and '||p_attribute_name||' in ('||l_attribute_values||')
        ) b,
        (
                select iit_inv_type,nm_ne_id_of ne_id_of
                ,nm_end_mp
                ,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and iit_ne_id = '||p_ne_id||'
        ) cs
        where cs.ne_id_of = b.ne_id_of
        and   least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp) >= 0';
	   ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  --v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||')';
          --v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and iit_no_of_units = 1 and iit_x_sect like '||''''||'LN%'||''''||') r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';
         v_query := ' select sum (least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp))
   from (
                select  nm_ne_id_of ne_id_of
                ,nm_end_mp,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and   iit_no_of_units = ''1''
                and iit_x_sect like '||''''||'LN%'||''''||'
                and nm_obj_type = ''RDGM''
                and iit_inv_type = ''RDGM''
        ) b,
        (
                select iit_inv_type,nm_ne_id_of ne_id_of
                ,nm_end_mp
                ,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and iit_ne_id = '||p_ne_id||'
        ) cs
        where cs.ne_id_of = b.ne_id_of
        and   least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp) >= 0';

	   END IF;

	ELSE

	   IF p_attribute_name IS NOT NULL AND p_attribute_values is not null THEN
          -- Format the attribute values string
	      l_attribute_values := REPLACE(p_attribute_values,'"','''');

--       v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||'  ) and '||p_attribute_name||' in ('||l_attribute_values||')';
          v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and '||p_attribute_name||' in ('||l_attribute_values||') ) r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp          
        and   least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp) >= 0';

	   ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  --v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||')';
         -- v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||') r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';
         v_query :=  'select sum (least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp))
               from (
                select nm_ne_id_of ne_id_of
                ,nm_end_mp,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and nm_obj_type =' ||''''||p_asset_type||''''||'
        ) b,
        (
                select iit_inv_type,nm_ne_id_of ne_id_of
                ,nm_end_mp
                ,nm_begin_mp
                from nm_inv_items, nm_members
                where iit_ne_id = nm_ne_id_in
                and iit_ne_id = '||p_ne_id||'
        ) cs
        where cs.ne_id_of = b.ne_id_of
        and   least(b.nm_end_mp, cs.nm_end_mp) - greatest(b.nm_begin_mp, cs.nm_begin_mp) >= 0';

	   END IF;

	 END IF;

   OPEN c_cursor FOR v_query;
   LOOP
     FETCH c_cursor INTO l_result;
     EXIT WHEN c_cursor%NOTFOUND;
    -- process row here
	 return l_result;

   END LOOP;
   CLOSE c_cursor;
   EXCEPTION WHEN OTHERS THEN
	    nm_debug.debug(v_query);

END length_process;
-----------------------------------------------------------------------------
--
--<PROC NAME="Create_fi_views">
-- Function to craete an FI view for each crew type
--
PROCEDURE create_fi_views IS

CURSOR get_crews IS
select distinct(crew_type) from XODOT_HBUD_FI_REPORT;


l_stmt VARCHAR2(5000);
BEGIN

FOR i IN get_crews LOOP

 l_stmt :=  'CREATE OR REPLACE view XODOT_'||i.crew_type||'_FI_REPORTING (COUNT_SECTION_ID, HIGHWAY, COUNT_SECTION_BEGIN_MP, COUNT_SECTION_END_MP, EA, CREW, DISTRICT, REGION,  feature_type, feature_count) as
             select count_section_id, highway,begin_mp,end_mp,EA, crew, district,region, feature_type,feature_count from  XODOT_HBUD_FI_REPORT
             where crew_type = '||''''||i.crew_type||'''';

  execute immediate(l_stmt);

END LOOP;
EXCEPTION WHEN OTHERS THEN
	    nm_debug.debug(l_stmt);
END;
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
--<PROC NAME="regenerate_hbud">
-- Regenerate HBUD data
PROCEDURE regenerate_tables IS
BEGIN
nm_debug.debug_on;

  delete from XODOT_HBUD_FI_REPORT;

  commit;

 GET_CREW_ACT;
  determine_asset_storage;
  create_fi_views;

  --RAISE_APPLICATION_ERROR(-20000,'Features Inventory Reporting Tables Generation Complete');
END regenerate_tables;
--
-----------------------------------------------------------------------------
--

END XODOT_FI_REPORT;
/
