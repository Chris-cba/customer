create or replace PACKAGE BODY XODOT_FI_REPORT AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Oregon/FI Reporting/admin/pck/xodot_fi_report.pkb-arc   3.0   Sep 06 2010 11:14:38   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_fi_report.pkb  $
--       Date into PVCS   : $Date:   Sep 06 2010 11:14:38  $
--       Date fetched Out : $Modtime:   Sep 03 2010 15:44:42  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :
--
--
--   Author : P Stanton
--
--   XODOT_FI_REPORT body
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
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   3.0  $"';

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
-----------------------------------------------------------------------------
--<PROC NAME="equiv_bit_miles">
--FUNCTION to calculate equivalent  bitumen miles
FUNCTION equiv_bit_miles (p_ne_id  nm_elements.ne_id%TYPE
						 ) return NUMBER IS

CURSOR get_greater_than	(p_ne_id  nm_elements.ne_id%TYPE) IS					 
SELECT SUM(nm3net.get_ne_length(iit_ne_id)) l_result FROM v_nm_rdgm
WHERE iit_ne_id in (select iit_ne_id from v_nm_pvmt_nw a, nm_members b
                                                                        where a.ne_id_of =  b.nm_ne_id_of
                                                                        and b.nm_ne_id_in = p_ne_id
                                                                        and b.nm_begin_mp <= a.nm_begin_mp
                                                                        and b.nm_end_mp >= a.nm_end_mp) 
AND matl_typ_cd IN ('A', 'AP', 'AT', 'AU', 'B', 'C', 'D', 'E', 'F')                -- For these Matltypes, this list contains those types I believe = Asphalt
AND iit_x_sect in ('RS2I', 'RS2D', 'RS1I', 'RS1D','LS1D','LS1I','LS2D','LS2I')     -- Restricting to shoulders
AND wd_meas > 4                                                                     -- and greater than  4
AND layer = 1;                                                                     -- and only for layer 1


CURSOR get_less_than (p_ne_id  nm_elements.ne_id%TYPE) IS
SELECT sum(nm3net.get_ne_length(iit_ne_id)) l_result FROM v_nm_rdgm
WHERE iit_ne_id in (select iit_ne_id from v_nm_pvmt_nw a, nm_members b
                                                                        where a.ne_id_of =  b.nm_ne_id_of
                                                                        and b.nm_ne_id_in = p_ne_id
                                                                        and b.nm_begin_mp <= a.nm_begin_mp
                                                                        and b.nm_end_mp >= a.nm_end_mp)
AND matl_typ_cd IN ('A', 'AP', 'AT', 'AU', 'B', 'C', 'D', 'E', 'F')                -- For these Matl types, this list contains those types I believe = Asphalt
AND iit_x_sect in ('RS2I', 'RS2D', 'RS1I', 'RS1D','LS1D','LS1I','LS2D','LS2I')     -- Restricting to shoulders
AND wd_meas <= 4                                                                  -- and less than or equal to 4
AND layer = 1;                                                                     -- and only for layer 1

l_greater_than NUMBER;
l_less_than    NUMBER;
l_final_total  NUMBER;

BEGIN

--Take the lenth of the shoulder, if it's 4 feet wide or less multiply  the length by 0.3333 if it's greater multiply by 0.666666
   
   OPEN get_greater_than(p_ne_id);
   FETCH get_greater_than INTO l_greater_than;
   CLOSE get_greater_than;
   
   OPEN get_less_than(p_ne_id);
   FETCH get_less_than INTO l_less_than;
   CLOSE get_less_than;

   l_final_total := (l_less_than*0.3333) + (l_greater_than*0.666666);
   
   RETURN l_final_total;
   
END equiv_bit_miles; 						 
			--
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
   where report_column = 'Y';
--
   CURSOR get_activity_data (p_crew_type v_nm_hact.crew_type%TYPE)IS
   SELECT c.ne_name_2,b.iit_inv_type,b.iit_ne_id,b.IIT_ITEMCODE, activity,appropriation_code,time_type,calculation_type,asset_type,attribute_type,attribute_values,crew_type,feature_type  
   FROM V_NM_HACT a, nm_inv_items b, nm_elements c
   WHERE crew_type = p_crew_type
   AND calculation_type <> 'LUMP SUM'
   and b.iit_inv_type = xodot_asset_type_functions.f$get_group_asset_type(p_crew_type,'CREW_ASSET_GROUP_TYPES')
   and b.iit_itemcode = c.ne_unique 
   and report_column = 'Y'
   order by iit_ne_id;
--
   CURSOR get_count_section_det IS
   SELECT distinct(count_section_id),count_section_type FROM xodot_hbud_fi_report;
--
   CURSOR get_crews IS
   select distinct(EA), maint_reg_id, maint_dist_id from XODOT_HBUD_FI_REPORT, XODOT_EA_CW_DIST_REG_LOOKUP
    where ea_number = ea;
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
		     ,appn
		     ,crew_type
		     ,activity
			 ,asset_type
		     ,time_type
		     ,feature_type
			 ,EA
             ,crew			 )
		     VALUES
		    (i2.iit_ne_id
			,i2.iit_inv_type
			,i2.appropriation_code
		    ,i.crew_type  ----  on the groups types there is no limit so this could be bigger than the 4 characters for crew id
		    ,i2.activity
			,i2.asset_type
		    ,i2.time_type
		    ,i2.feature_type
			,i2.IIT_ITEMCODE
			,i2.ne_name_2
		    );
	    
      END LOOP;
      
	  
	  COMMIT;
	
	END LOOP;
	


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
	 
   
   -- Get District Or Region
   FOR i IN get_crews LOOP  
	  
	  UPDATE XODOT_HBUD_FI_REPORT
	  SET district = i.maint_dist_id
	  WHERE ea = i.ea
	  and crew_type = 'SECW';
	  
	  
	  UPDATE XODOT_HBUD_FI_REPORT
	  SET region = i.maint_reg_id
	  WHERE ea = i.ea;
		  
		 
   END LOOP;
   
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
   SELECT a.count_section_id,a.crew,a.begin_mp,a.end_mp,c.ne_id, a.activity, b.feature_type,b.asset_type,b.calculation_type,b.attribute_type,b.attribute_values, d.ita_attrib_name,d.ita_units
   FROM XODOT_HBUD_FI_REPORT a  ,nm_elements c, V_NM_HACT b full outer join  nm_inv_type_attribs d
   on ( d.ita_inv_type = b.asset_type and d.ita_view_col_name = b.attribute_type  )
   WHERE a.activity = b.activity
   AND a.feature_type = b.feature_type
   AND c.ne_unique = a.highway
   and report_column = 'Y'
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
	     AND activity = i.activity
	     AND feature_type = i.feature_type
		 and count_section_id = i.count_section_id;
	  
	  ELSIF i.calculation_type = 'CALCULATED' THEN
	     
		 l_feature_count :=  calculated_process(p_crew              => i.crew
                                               ,p_ne_id            => i.count_section_id
							                   ,p_activity         => i.activity
							                   ,p_feature_type     => i.feature_type
							                   ,p_asset_type       => i.asset_type
							                   ,p_calculation_type => i.calculation_type
							                   ,p_attribute_type   => i.attribute_type
							                   ,p_attribute_values => i.attribute_values
 							                   ,p_ita_attrib_name  => i.ita_attrib_name
							                   ,p_ita_units        => i.ita_units );
	  
	       
		   
		   UPDATE XODOT_HBUD_FI_REPORT
	       SET feature_count = nvl(l_feature_count,0)
		      ,unit_of_measure = 'CALCULATED'
	       WHERE crew = i.crew
	       AND activity = i.activity
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
	     AND activity = i.activity
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
	     AND activity = i.activity
	     AND feature_type = i.feature_type
		 AND count_section_id = i.count_section_id;	

      ELSIF i.calculation_type = 'LUMP SUM' THEN
	           
         UPDATE XODOT_HBUD_FI_REPORT
	     SET feature_count = 1
		    ,unit_of_measure = 'LUMP SUM'
	     WHERE crew = i.crew
	     AND activity = i.activity
	     AND feature_type = i.feature_type;			 
	  
	  END IF;
	  
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
    
   
END summary_process;
--
-----------------------------------------------------------------------------
--
--<PROC NAME="calculated_process">
-- Function to process activities defined as calculated
FUNCTION calculated_process (p_crew              v_nm_hact.crew_type%TYPE
                             ,p_ne_id            nm_elements.ne_id%TYPE
							 ,p_activity         v_nm_hact.activity%TYPE
							 ,p_feature_type     v_nm_hact.feature_type%TYPE 
							 ,p_asset_type       v_nm_hact.asset_type%TYPE 
							 ,p_calculation_type v_nm_hact.calculation_type%TYPE 
							 ,p_attribute_type   v_nm_hact.attribute_type%TYPE 
							 ,p_attribute_values v_nm_hact.attribute_values%TYPE 
 							 ,p_ita_attrib_name  nm_inv_type_attribs.ita_attrib_name%TYPE 
							 ,p_ita_units        nm_inv_type_attribs.ita_units%TYPE) return NUMBER is

l_result VARCHAR2(4000);							 
BEGIN
-- For the Calculated process it is expected that the p_attribute_values parameter will contain a function name
-- this function name will be a custom fucntion that will calculate a value and pass back a number.

IF p_attribute_values = 'EQUIV_BIT_MILES' THEN
   l_result:= equiv_bit_miles (p_ne_id => p_ne_id );
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

    IF p_attribute_name IS NOT NULL AND p_attribute_values is not null THEN
       -- Format the attribute values string
	   l_attribute_values := REPLACE(p_attribute_values,'"','''');
	        
       v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items 
	               WHERE iit_ne_id in (select iit_ne_id from v_nm_'||p_asset_type||'_nw a, nm_members b
                                                                        where a.ne_id_of =  b.nm_ne_id_of
                                                                        and b.nm_ne_id_in = '||p_ne_id||'
                                                                        and b.nm_begin_mp <= a.nm_begin_mp
                                                                        and b.nm_end_mp >= a.nm_end_mp)
                    and '||p_attribute_name||' in ('||l_attribute_values||')';
    
	ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items 
	              WHERE iit_ne_id in (select iit_ne_id from v_nm_'||p_asset_type||'_nw a, nm_members b
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

END;	
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--			 
--<PROC NAME="regenerate_hbud">
-- Regenerate HBUD data
PROCEDURE regenerate_tables IS
BEGIN
  delete from XODOT_HBUD_FI_REPORT;
  commit;
  
  GET_CREW_ACT;
  determine_asset_storage;
  create_fi_views;
  
  RAISE_APPLICATION_ERROR(-20000,'Features Inventory Reporting Tables Generation Complete');
END regenerate_tables;
--
-----------------------------------------------------------------------------
--

END XODOT_FI_REPORT;
/


