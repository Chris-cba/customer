-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/refresh_sdo_sde_metadata.sql-arc   1.0   Jan 26 2011 07:58:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_sdo_sde_metadata.sql  $
--       Date into PVCS   : $Date:   Jan 26 2011 07:58:12  $
--       Date fetched Out : $Modtime:   Jan 18 2011 18:46:48  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
-
col         log_extension new_value log_extension noprint
select  instance_name||'_refresh_sdo_sde_metadata_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.log' log_extension from v$instance
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='&log_extension'
set pages 0
set lines 200
set echo on
SET SERVEROUTPUT ON size 1000000

spool &logfile1

declare
   l_allow_debug    hig_options.HOP_VALUE%type;
begin

  l_allow_debug := hig.get_sysopt('ALLOWDEBUG');
  
  hig.set_opt('ALLOWDEBUG', 'Y');
  nm_debug.debug_on;

  for rec in (select nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column  
                 from nm_themes_all
                 where exists ( select 1 from user_tables where  table_name = nth_feature_table )
                 and not exists ( select 1 from user_objects 
                                   where object_name = nth_feature_table 
                                       and object_type =  'MATERIALIZED VIEW'))
   loop
        nm_debug.debug('Refreshing SDO metadata for ' || rec.nth_theme_name );
      nm3layer_tool.refresh_sdo_metadata( rec.nth_theme_id, 'ALL_DATA');
   end loop;
   
   nm_debug.debug_off;
   hig.set_opt('ALLOWDEBUG', l_allow_debug);

end;
/

@create_data_for_empty_tables.sql

declare
   l_allow_debug    hig_options.HOP_VALUE%type;
   l_reg_sde_layer  hig_options.HOP_VALUE%type;
begin

  l_allow_debug := hig.get_sysopt('ALLOWDEBUG');
  
  hig.set_opt('ALLOWDEBUG', 'Y');
  nm_debug.debug_on;

 l_reg_sde_layer := hig.get_sysopt('REGSDELYR');

   if (l_reg_sde_layer = 'Y')  then

    for rec in (select nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column  
                from nm_themes_all
                where exists ( select 1 from user_tables where  table_name = nth_feature_table ) 
                 and not exists ( select 1 from user_objects 
                                  where object_name = nth_feature_table 
                                       and object_type =  'MATERIALIZED VIEW'))
   loop
        nm_debug.debug('Refreshing SDE metadata for ' || rec.nth_theme_name );
        nm3layer_tool.refresh_sde_metadata( rec.nth_theme_id,'ALL_DATA');
   end loop;
 
 end if;

   nm_debug.debug_off;
   hig.set_opt('ALLOWDEBUG', l_allow_debug);
end;
/

commit;

--generate report
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
from nm_dbug
where nd_session_id=USERENV('SESSIONID')
order by nd_id
/

spool off
