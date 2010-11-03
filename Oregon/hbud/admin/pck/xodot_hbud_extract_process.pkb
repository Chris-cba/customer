create or replace PACKAGE BODY XODOT_HBUD_EXTRACT_PROCESS AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Oregon/hbud/admin/pck/xodot_hbud_extract_process.pkb-arc   3.1   Nov 03 2010 13:26:24   Ian.Turnbull  $
--       Module Name      : $Workfile:   xodot_hbud_extract_process.pkb  $
--       Date into PVCS   : $Date:   Nov 03 2010 13:26:24  $
--       Date fetched Out : $Modtime:   Nov 03 2010 12:09:00  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--
--   Author : P Stanton
--
--   xodot_hbud_extract_process body
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
--
 g_package_name    CONSTANT  varchar2(30)   := 'xodot_hbud_extract_process';
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
--
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_CREW_ACT">
-- Procedure Determine the crews and activities to be processed
PROCEDURE GET_CREW_ACT IS
--
   CURSOR get_crews IS
   SELECT ne_id, ne_unique,ne_descr, ne_nt_type, ne_name_2 
   FROM nm_elements
   WHERE ne_nt_type IN (SELECT DISTINCT(crew_type) FROM V_NM_HACT);
--
   CURSOR get_activity_data (p_crew_type v_nm_hact.crew_type%TYPE)IS
   SELECT activity,appropriation_code,time_type,calculation_type,asset_type,attribute_type,attribute_values,crew_type,feature_type  
   FROM V_NM_HACT
   WHERE crew_type = p_crew_type;
--
BEGIN

   FOR i IN get_crews LOOP   ---- Get he distinct crews to be processed

      -- for each crew find the Activities and the asset info that it is related to
      FOR i2 IN get_activity_data(i.ne_nt_type) LOOP
	     INSERT INTO XODOT_HBUD_EXTRACT
		 (appn
		 ,crew
		 ,activity
		 ,time_type
		 ,feature_type)
		 VALUES
		 (i2.appropriation_code
		 ,i.ne_name_2  ----  on the groups types there is no limit so this could be bigger than the 4 characters for crew id
		 ,i2.activity
		 ,i2.time_type
		 ,i2.feature_type
		 );
	  END LOOP;
      COMMIT;
   
   END LOOP;
   
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
   
   SELECT a.crew,c.ne_id, a.activity, b.feature_type,b.asset_type,b.calculation_type,b.attribute_type,b.attribute_values, d.ita_attrib_name,d.ita_units
   FROM XODOT_HBUD_EXTRACT a  ,nm_elements c, V_NM_HACT b full outer join  nm_inv_type_attribs d
   on ( d.ita_inv_type = b.asset_type and d.ita_view_col_name = b.attribute_type  )
   WHERE a.activity = b.activity
   AND a.feature_type = b.feature_type
   AND c.ne_unique = a.crew
   AND b.crew_type = c.ne_nt_type
   
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
                                           ,p_ne_id  => i.ne_id
						                   ,p_attribute_name => i.ita_attrib_name);
         
		 -- Update the extract table with the value returned and the units of measure
		 UPDATE XODOT_HBUD_EXTRACT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = l_unit_of_measure.un_unit_name
	     WHERE crew = i.crew
	     AND activity = i.activity
	     AND feature_type = i.feature_type;
	  
	  ELSIF i.calculation_type = 'CALCULATED' THEN
	     
		 l_feature_count :=  calculated_process(p_crew              => i.crew
                                               ,p_ne_id            => i.ne_id 
							                   ,p_activity         => i.activity
							                   ,p_feature_type     => i.feature_type
							                   ,p_asset_type       => i.asset_type
							                   ,p_calculation_type => i.calculation_type
							                   ,p_attribute_type   => i.attribute_type
							                   ,p_attribute_values => i.attribute_values
 							                   ,p_ita_attrib_name  => i.ita_attrib_name
							                   ,p_ita_units        => i.ita_units );
	  
	       
		   
		   UPDATE XODOT_HBUD_EXTRACT
	       SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = 'CALCULATED'
	       WHERE crew = i.crew
	       AND activity = i.activity
	       AND feature_type = i.feature_type;	
	  
	  ELSIF i.calculation_type = 'COUNT' THEN
	     
		l_feature_count := count_process(p_asset_type => i.asset_type
                                        ,p_ne_id  => i.ne_id
						                ,p_attribute_name => i.ita_attrib_name
						                ,p_attribute_values => i.attribute_values);

         UPDATE XODOT_HBUD_EXTRACT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = 'COUNT'
	     WHERE crew = i.crew
	     AND activity = i.activity
	     AND feature_type = i.feature_type;										
	  
	  ELSIF i.calculation_type = 'LENGTH' THEN
	     
           l_feature_count := length_process(p_asset_type => i.asset_type
                                            ,p_ne_id  => i.ne_id
				     		                ,p_attribute_name => i.ita_attrib_name
					    	                ,p_attribute_values => i.attribute_values);

         UPDATE XODOT_HBUD_EXTRACT
	     SET feature_count = nvl(l_feature_count,0)
		     ,unit_of_measure = 'MILES'
	     WHERE crew = i.crew
	     AND activity = i.activity
	     AND feature_type = i.feature_type;	

      ELSIF i.calculation_type = 'LUMP SUM' THEN
	           
         UPDATE XODOT_HBUD_EXTRACT
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

   v_query := 'SELECT sum('||p_attribute_name||') FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||'  )';

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
	        
       v_query := 'SELECT count(*) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||'  ) and '||p_attribute_name||' in ('||l_attribute_values||')';
    
	ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  v_query := 'SELECT count(*) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||')';
    
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
          v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and '||p_attribute_name||' in ('||l_attribute_values||') and iit_no_of_units = 1 and iit_x_sect like '||''''||'LN%'||''''||' ) r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';
	   
	   ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  --v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||')';
          v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and iit_no_of_units = 1 and iit_x_sect like '||''''||'LN%'||''''||') r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';

	   END IF;
    
	ELSE 
    
	   IF p_attribute_name IS NOT NULL AND p_attribute_values is not null THEN
          -- Format the attribute values string
	      l_attribute_values := REPLACE(p_attribute_values,'"','''');
	        
--       v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||'  ) and '||p_attribute_name||' in ('||l_attribute_values||')';
          v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||' and '||p_attribute_name||' in ('||l_attribute_values||') ) r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';
	   
	   ELSE
	  -- query is going ignore the asset attributes and just count all existing assets of the specified type
	  --v_query := 'SELECT sum(nm3net.get_ne_length(iit_ne_id)) FROM nm_inv_items WHERE iit_ne_id in (SELECT nm_ne_id_in FROM nm_members WHERE nm_ne_id_of in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in in (SELECT ne_id FROM nm_elements WHERE ne_id in (SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '||p_ne_id||')))) AND nm_type     = '||''''||'I'||''''||' AND nm_obj_type = '||''''||p_asset_type||''''||')';
          v_query := 'select sum (least(r.nm_end_mp, sm.nm_end_mp) - greatest(r.nm_begin_mp, sm.nm_begin_mp)) from (select nm_ne_id_of ne_id_of,nm_end_mp,nm_begin_mp from nm_inv_items, nm_members where iit_ne_id = nm_ne_id_in   and nm_obj_type = '||''''||p_asset_type||''''||') r, nm_elements s, nm_members sm where ne_id = nm_ne_id_in and nm_ne_id_of = ne_id_of and ne_id in (select cm.nm_ne_id_of from nm_members cm, nm_elements c where c.ne_id = '||p_ne_id||' and ne_id = nm_ne_id_in) and r.nm_end_mp >= sm.nm_begin_mp and r.nm_begin_mp <= sm.nm_end_mp';

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
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--			 
--<PROC NAME="regenerate_hbud">
-- Regenerate HBUD data
PROCEDURE regenerate_hbud IS
BEGIN
nm_debug.debug_on;
  delete from XODOT_HBUD_EXTRACT;
  commit;
  
  GET_CREW_ACT;
  determine_asset_storage;
  
  RAISE_APPLICATION_ERROR(-20000,'HBUD Generation Complete');
END regenerate_hbud;
--
-----------------------------------------------------------------------------
--
PROCEDURE hbud_params IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'HBUD_LIST';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

   l_tab_value  nm3type.tab_varchar30;
   l_tab_prompt nm3type.tab_varchar30;
   l_checked    varchar2(8) := ' CHECKED';

BEGIN
--nm_debug.debug_on;
--nm_debug.debug('in the proce');
  l_tab_value(1)  := 'HPMS';
  l_tab_prompt(1) := 'Click continue';
  


  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'hbud_params');
  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);

  htp.bodyopen;
  nm3web.module_startup(c_this_module);

  htp.p('<DIV ALIGN="CENTER">');


  htp.header(nsize   => 1
            ,cheader => c_module_title
            ,calign  => 'center');
  --open table for params

    htp.tableopen(calign => 'center');
  --open form to submit params to results procedure
  htp.formopen(curl => g_package_name || '.hbud_report');

   htp.p('<TR>');
   htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
   htp.p('</TR>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2 ALIGN=CENTER>');
      htp.tableopen;
      htp.tablerowopen;
      htp.tableheader('Click Continue to Download HBUD extract file', cattributes=>'COLSPAN=2');
      htp.tablerowclose;
      --
     -- FOR i IN 1..l_tab_value.COUNT
      -- LOOP
      --   htp.tablerowopen(cattributes=>'ALIGN=CENTER');
      --   htp.tabledata(l_tab_prompt(i));
      --   htp.p('<TD><INPUT TYPE=RADIO NAME="pi_report_type" VALUE="'||l_tab_value(i)||'"'||l_checked||'></TD>');
      --   l_checked := NULL;
      --   htp.tablerowclose;
      --END LOOP;
      htp.tableclose;
   --
   htp.p('</TD>');
   htp.p('<TR>');
   htp.p('<TD COLSPAN=2>'||htf.hr||'</TD>');
   htp.p('</TR>');
   htp.p('<TR>');



  --button that submits the form,
  htp.tablerowopen(calign=> 'center');
    htp.p('<TD colspan="2">');
    htp.formsubmit(cvalue => 'Continue');
    htp.p('</TD>');
  htp.tablerowclose;

  htp.formclose;
  htp.tableclose;

  nm3web.CLOSE;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'assetgap_params');
EXCEPTION
  WHEN nm3web.g_you_should_not_be_here
  THEN
    raise;
  WHEN others
  THEN
  nm_debug.debug('error');
    nm3web.failure(pi_error => SQLERRM);
END hbud_params ;
--
-----------------------------------------------------------------------------
--
PROCEDURE hbud_report IS
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'HBUD_LIST';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);

  c_nl varchar2(1) := CHR(10);
  l_qry nm3type.max_varchar2;

  i number:=0;

  l_rec_nuf               nm_upload_files%ROWTYPE;
  c_mime_type    CONSTANT varchar2(30) := 'application/HPMS/HERS';
  c_sysdate      CONSTANT date         := SYSDATE;
  c_content_type CONSTANT varchar2(4)  := 'BLOB';
  c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
  v_clob clob;
  v_tmp_clob clob;

  l_tab             nm3type.tab_varchar32767;  
  
  
BEGIN

nm_debug.debug('in the second procedure');
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'hbud_report');

  nm3web.head(p_close_head => TRUE
             ,p_title      => c_module_title);
  htp.bodyopen;
  nm3web.module_startup(pi_module => c_this_module);


  l_rec_nuf.mime_type              := c_mime_type;
  l_rec_nuf.dad_charset            := c_dad_charset;
  l_rec_nuf.last_updated           := c_sysdate;
  l_rec_nuf.content_type           := c_content_type;
  l_rec_nuf.doc_size               := 0;
  
  
 
    l_rec_nuf.name                   := 'HBUD_'||to_char(sysdate,'DD-MON-YYYY:HH24:MI:SS')||'.csv';
    for c1rec in
      (select
       APPN
       ||','||CREW
       ||','||ACTIVITY
       ||','||TIME_TYPE
       ||','||UNIT_OF_MEASURE
       ||','||FEATURE_TYPE
       ||','||FEATURE_COUNT  v_row
    from xodot_hbud_extract
    --where rownum<10
    ) loop
       l_tab(l_tab.count+1):=c1rec.v_row||chr(10);
       l_rec_nuf.doc_size  := l_rec_nuf.doc_size+length(l_tab(l_tab.count));
    end loop;
  
 
     
       --nm_debug.debug_clob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));

      
    -- l_rec_nuf.blob_content           := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab));
    
        for a in  1 .. l_tab.count 
        loop  
            v_tmp_clob :=   l_tab(a); 
            v_clob := v_clob || v_tmp_clob; 
        end loop; 
        
        l_rec_nuf.blob_content           := nm3clob.clob_to_blob(v_clob); 
        
        delete from nm_upload_files
        where name= l_rec_nuf.name;

         nm3ins.ins_nuf (l_rec_nuf);
         COMMIT;






/*.

  htp.p('<div align="center">');
      nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => l_qry));
  htp.p('</div>');
*/
  --line
 -- htp.tablerowopen(calign=> 'center');
 --   htp.p('<TD colspan="2">');
 --   htp.p(htf.hr);
    htp.p('  Click <a href=docs/'||l_rec_nuf.name||'> HERE </a> to download and save your CSV file');
--    htp.p('</TD>');
--  htp.tablerowclose;

  nm3web.CLOSE;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'results');

EXCEPTION
  WHEN others
  THEN
    nm3web.failure(pi_error => SQLERRM);
--    nm3web.failure(pi_error => l_qry);
END hbud_report;
--

END XODOT_HBUD_EXTRACT_PROCESS;
/


