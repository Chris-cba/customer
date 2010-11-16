--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/set_all_null_srids.sql-arc   3.0   Nov 16 2010 12:14:22   Ian.Turnbull  $
--       Module Name      : $Workfile:   set_all_null_srids.sql  $
--       Date into PVCS   : $Date:   Nov 16 2010 12:14:22  $
--       Date fetched Out : $Modtime:   Nov 10 2010 18:17:44  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
--  ******* IMPORTANT  the exor database must be at version 4300 *********

-- Written by Aileen Heal to to sett all themes which don't have a srid already set to
-- the SRID specified by user (default value is 81989)
--
-- this script will also refresh all the SDO Metadata for the table, it's depnendent views 
-- and subordinate views. If the prodcut options option REGSDELYR = Y it will also
-- refresh the SDE metadata.  
--
-- N.B. it is important after running this script to ** RESTART MAPVIEWER **
--
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='set_all_null_srids_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

undefine pv_default_srid

spool &logfile1

set echo on

select user from dual
/

select instance_name  from v$instance
/

@AH_SET_TABLE_SRID.sql

prompt
accept   pv_default_srid   default 81989 prompt "Enter the default srid to use: "

declare
   l_allow_debug    hig_options.HOP_VALUE%type;
   l_reg_sde_layer  hig_options.HOP_VALUE%type;
   l_default_srid      number := &pv_default_srid;
      
   cursor c1 is
         select nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column  
           from nm_themes_all
        where nth_feature_table in
       (select table_name from user_sdo_geom_metadata where srid is null)
           and exists ( select 1 from user_tables where  table_name = nth_feature_table )
           and not exists ( select 1 from user_objects 
                                   where object_name = nth_feature_table 
                                       and object_type =  'MATERIALIZED VIEW')
          ORDER BY nth_base_table_theme NULLS FIRST;
 
   cursor c2 is
         Select table_name, column_name 
           from user_sdo_geom_metadata
        where table_name in ( 'TMA_NONSWA_STR_LOCS_SDO',   'TMA_SW_LICENCES_SDO')
            and srid is null;

begin

  l_allow_debug := hig.get_sysopt('ALLOWDEBUG');
  
  hig.set_opt('ALLOWDEBUG', 'Y');
  nm_debug.debug_on;

 l_reg_sde_layer := hig.get_sysopt('REGSDELYR');
 
  for c1rec in c1 loop
    -- first check it is not a materalised view
    
    nm_debug.debug('Setting SRID for ' || c1rec.nth_feature_table|| ' to  '|| l_default_srid );
    ah_set_table_srid(c1rec.nth_feature_table, c1rec.nth_feature_shape_column, l_default_srid );
     
    nm_debug.debug('Refreshing SDO metadata for ' || c1rec.nth_feature_table  );
    nm3layer_tool.refresh_sdo_metadata( c1rec.nth_theme_id, 'ALL_DATA');

     if (l_reg_sde_layer = 'Y')  then
        nm_debug.debug('Refreshing SDE metadata for ' || c1rec.nth_feature_table );
        nm3layer_tool.refresh_sde_metadata( c1rec.nth_theme_id, 'ALL_DATA');
     end if;

  end loop;

  -- do the 2 TMA tables which for some reason are not in nm_themes_all
     for c2rec in c2 loop 
        nm_debug.debug('Setting SRID for ' || c2rec.table_name || ' to  '|| l_default_srid );
        ah_set_table_srid(c2rec.table_name, c2rec.column_name, l_default_srid );
      end loop;                 
  
   
   nm_debug.debug_off;
 
  hig.set_opt('ALLOWDEBUG', l_allow_debug);
     
end;
/

--generate report
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
from nm_dbug
where nd_session_id=USERENV('SESSIONID')
order by nd_id
/

spool off

