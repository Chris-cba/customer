CREATE OR REPLACE PROCEDURE X_BRISTOLWATER_REFRESH_MATVIEW
IS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid            : $Header:   //vm_latest/archives/customer/Bristol Water/GeoMeFeed/X_BRISTOLWATER_REFRESH_MATVIEW.prc-arc   1.0   Apr 22 2013 09:46:40   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BRISTOLWATER_REFRESH_MATVIEW.prc  $
--       Date into PVCS   : $Date:   Apr 22 2013 09:46:40  $
--       Date fetched Out : $Modtime:   Mar 25 2013 11:46:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author :Aileen Heal
--
--    X_BRISTOLWATER_REFRESH_MATVIEW
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems, 2013
-----------------------------------------------------------------------------
-- written by Aileen Heal to refresh the Bristol Water materialized Views X_MV_BRISTOL_WATER_GEOME% 
-- and flip the view X_V_BRISTOL_WATER_GEOME to look at the most recently refresh materialized views
--
   l_current_mv_name varchar2(30);
   l_next_mv_name varchar2(30);  
   v_sql Varchar2(128);
  l_allow_debug hig_options.HOP_VALUE%type;

BEGIN
  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';
 
  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';
  
  nm_debug.debug_on;
  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW Started');
   
   BEGIN
      select REFERENCED_NAME into l_current_mv_name
      from USER_DEPENDENCIES 
      where NAME = 'X_V_BRISTOL_WATER_GEOME';
   EXCEPTION 
      when others then
	  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW - Unexpected Error getting current MV name' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK());
	  RETURN;
   END;	  

   if  l_current_mv_name = 'X_MV_BRISTOL_WATER_GEOME1' then
      l_next_mv_name := 'X_MV_BRISTOL_WATER_GEOME2';
   elsif l_current_mv_name = 'X_MV_BRISTOL_WATER_GEOME2' then
      l_next_mv_name := 'X_MV_BRISTOL_WATER_GEOME1';
   else
	  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW - cant identify current materalised view!');
	  RETURN;
   end if;
   
   -- refresh next materialized view
   BEGIN
      nm_debug.debug('X_BRISTOLWATER_REFRESH_MATVIEW - Refreshing ' ||  l_next_mv_name);
      dbms_mview.refresh( l_next_mv_name );
   EXCEPTION 
      when others then
	  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW - Unexpected Error refreshing materalised view ' || l_next_mv_name || ': ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK());
	  RETURN;
   END;	  
   nm_debug.debug('X_BRISTOLWATER_REFRESH_MATVIEW - Refreshed ' || l_next_mv_name);

   BEGIN
      v_sql := 'CREATE OR REPLACE VIEW X_V_BRISTOL_WATER_GEOME AS SELECT * FROM ' || l_next_mv_name;
      nm_debug.debug('X_BRISTOLWATER_REFRESH_MATVIEW ' || v_sql );
      execute immediate v_sql;
   EXCEPTION 
      when others then
	  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW - Unexpected Error executing SQL ' || l_next_mv_name || ': ' || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_STACK());
   END;	  

  
  NM_DEBUG.DEBUG( 'X_BRISTOLWATER_REFRESH_MATVIEW Finished');
  
   nm_debug.debug_off;

   update hig_options
      set hop_value=l_allow_debug 
     where hop_id='ALLOWDEBUG';  
END;
END X_BRISTOLWATER_REFRESH_MATVIEW;
/
