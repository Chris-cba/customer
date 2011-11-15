-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--        pvcsid                 : $Header:   //vm_latest/archives/customer/cornwall/BRS6763/BRS6763_allocate_street_groups.sql-arc   1.0   Nov 15 2011 15:43:52   Ian.Turnbull  $
--       Module Name      : $Workfile:   BRS6763_allocate_street_groups.sql  $
--       Date into PVCS   : $Date:   Nov 15 2011 15:43:52  $
--       Date fetched Out : $Modtime:   Nov 15 2011 12:14:54  $
--       PVCS Version     : $Revision:   1.0  $
--       Author : Aileen Heal
--
--    Copyright: (c) 2011 Bentley Systems, Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- Written by Aileen Heal as part of work package BRS 6763 for Cornwall Nov 2011
-- This script requires a view called X_BRS6764 which is created using the script
-- BRS6763_create_tables_n_views.sql
-- The shape file Stworks2011.shp supplied by Cornwall was loaded into the database 
-- using MapBuilder as table name STWORKS2011 (SRID = 81989, geometry column GEOMETRY)
-----------------------------------------------------------------------------
declare
   v_street_group_id TMA_STREET_GROUPS.tsg_id%TYPE;
   v_sub_area X_BRS6764.AREA_NAME%TYPE;
   i NUMBER := 0;
   v_intersection NUMBER;
begin
   nm_debug.debug_on; 
--
   for rec1 in ( select ne_id, count(*) how_many from X_BRS6764
                     group by ne_id) 
   loop
--      nm_debug.debug ('BRS6764: doing ' || rec1.ne_id || ' count: ' || rec1.how_many);
      if rec1.how_many = 1 then
        select  AREA_NAME  into v_sub_area
           from    X_BRS6764
           where ne_id = rec1.ne_id;
      else -- > 1
         v_intersection := 0;
         for rec2 in (select ne_id, sub_area,  sum(sdo_geom.sdo_length(sdo_geom.sdo_intersection(a.geometry, b.geoloc, 0.5), 0.5)) intersect_length 
                           from STWORKS2011 a, v_nm_nat_nsgn_offn_sdo b
                           where ne_id = rec1.ne_id
                           and sdo_geom.sdo_length(sdo_geom.sdo_intersection(a.geometry, b.geoloc, 0.5), 0.5) > 0
                           group by ne_Id, sub_area )
         loop
            if rec2.intersect_length > 0 then 
               nm_debug.debug( 'BRS6764: ne_id:' || rec2.ne_id || ' area:'  || rec2.sub_area || ' intersection: ' || rec2.intersect_length );
               if rec2.intersect_length > v_intersection then
                  v_intersection := rec2.intersect_length;
                  v_sub_area := rec2.sub_area;
               end if;
            end if;
         end loop;  
         nm_debug.debug( 'BRS6764: ne_id:' || rec1.ne_id || ' interection: ' || v_intersection || ' area: ' || v_sub_area  );                
      end if;
--         
      select TSG_ID into v_street_group_id
         from TMA_STREET_GROUPS 
         where TSG_NAME = v_sub_area;
--     
     insert into TMA_STREET_GROUP_MEMBERS (TSGM_TSG_ID, TSGM_STR_NE_ID)
      values (  v_street_group_id, rec1.ne_id  );          
      i := i+1;
      if i > 1000 then
         commit;
         i := 0;
      end if;        
   end loop;
   -- final commit;
   commit;
   nm_debug.debug_off;
end;      
/

