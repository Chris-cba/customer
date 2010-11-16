---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                  : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/validate_all_themes.sql-arc   3.0   Nov 16 2010 12:14:20   Ian.Turnbull  $
--       Module Name       : $Workfile:   validate_all_themes.sql  $
--       Date into PVCS     : $Date:   Nov 16 2010 12:14:20  $
--       Date fetched Out  : $Modtime:   Nov 10 2010 12:21:16  $
--       PVCS Version      : $Revision:   3.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to validate all themes in nm_theme_all  which are tables
-- The log file produced will indicate any tables that have invalid geomoetries
-- results for each table are written to a table named <table name>_EX
-- and can be queires using the following
-- select substr(result, 1,5), count(*) from <results table name>
-- group by substr(result, 1,5);
-- 
-- typical errors are:
-- 13011: geometry is outside the extent specified in user_sdo_geom_metadata
--            to fix this refresh the metadata via the GIS Layer tool (available from 4300)
--            or contact Aileen for function to do this.
--
-- 13356: co-incident nodes 
--            Aileen has a script which will fix this
--
-- 13349: polygon boundary crosses itself
--
-- 13367: wrong rotation for interior/exterior ring
--
-- for all other errors do a google search for ORA-<error number>
-- 
---------------------------------------------------------------------------------------------------

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='validate_all_themes&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on
select user from dual
/

select instance_name  from v$instance
/

declare
  l_allow_debug hig_options.HOP_VALUE%type;

   cursor c1 is
        select nth_theme_id, nth_feature_table, nth_feature_shape_column  
         from nm_themes_all
            where nth_feature_table||nth_feature_shape_column in
                      (select table_name||column_name from user_sdo_geom_metadata)
                           and exists ( select 1 from user_tables where nth_feature_table = table_name )
                           ORDER BY nth_base_table_theme NULLS FIRST;

   l_num_invalid_rows number;
   
begin

  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  hig.set_opt('ALLOWDEBUG', 'Y');

  nm_debug.debug_on;

  for c1rec in c1 loop
    begin
        
        nm_debug.debug('Validating ' || c1rec.nth_feature_table);

         -- drop exception table if already exisits
          begin
              EXECUTE IMMEDIATE 'Drop Table ' || c1rec.nth_feature_table || '_EX';
          exception
          when others then
             null; -- ignore
          end;
              
          l_num_invalid_rows := nm3sdo.VALIDATE_THEME(c1rec.nth_theme_id);
          nm_debug.debug(c1rec.nth_feature_table|| ' has '||l_num_invalid_rows || ' invalid geometries');
          
    exception
      when others then
        nm_debug.debug('Error validating ' || c1rec.nth_feature_table|| ': '||sqlerrm);
    end;
  end loop;

   nm_debug.debug_off;
 
  hig.set_opt('ALLOWDEBUG', l_allow_debug);
   
   commit;
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

