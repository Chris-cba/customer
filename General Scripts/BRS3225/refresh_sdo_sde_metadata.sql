-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/refresh_sdo_sde_metadata.sql-arc   1.3   Jul 29 2011 08:12:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   refresh_sdo_sde_metadata.sql  $
--       Date into PVCS   : $Date:   Jul 29 2011 08:12:36  $
--       Date fetched Out : $Modtime:   Jul 28 2011 16:20:26  $
--       PVCS Version     : $Revision:   1.3  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
-
--
-- These scripts are for use by exor consultants only. THey should not be provided to customers 
--
---------------------------------------------------------------------------------------------------
--
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

  for rec in (SELECT nth_theme_id, nth_theme_name, nth_feature_table, nth_feature_shape_column
                    FROM nm_themes_all
                  WHERE nth_base_table_theme IS NULL
                       AND EXISTS (SELECT 1 FROM v_nm_net_themes_all
                                            WHERE vnnt_nth_theme_id = nth_theme_id
                                                AND vnnt_lr_type = 'D')
                 UNION
                SELECT nth_theme_id, nth_theme_name, nth_feature_table, nth_feature_shape_column
                   FROM nm_themes_all
                 WHERE nth_theme_id NOT IN 
                                        ( SELECT nbth_theme_id FROM nm_base_themes
                                            WHERE nbth_base_theme IN (SELECT vnnt_nth_theme_id FROM v_nm_net_themes_all
                                            WHERE vnnt_lr_type = 'D'))
                   AND nth_base_table_theme IS NULL
                   AND nth_theme_name != 'MERGE_RESULTS' -- added by aileen as table is always empty and causes code to crash
                )
   loop
       if hig.get_sysopt( 'REGSDELAY') = 'Y' then
           nm_debug.debug('Refreshing SDO and SDE metadata for ' || rec.nth_theme_name );
           nm3layer_tool.refresh_sdo_metadata( pi_nth_theme_id  => rec.nth_theme_id
                                                                  , pi_dependency    => 'ALL_DATA'
                                                                  , pi_clone_parent  => 'CLONE'
                                                                  , pi_progress_id   => NULL
                                                                  , pi_run_sde       => TRUE );
       else
           nm_debug.debug('Refreshing SDO metadata for ' || rec.nth_theme_name );
           nm3layer_tool.refresh_sdo_metadata( pi_nth_theme_id  => rec.nth_theme_id
                                                                  , pi_dependency    => 'ALL_DATA'
                                                                  , pi_clone_parent  => 'CLONE'
                                                                  , pi_progress_id   => NULL
                                                                  , pi_run_sde       => FALSE);
       end if;
   end loop;
   
   nm_debug.debug_off;
   hig.set_opt('ALLOWDEBUG', l_allow_debug);

end;
/

@create_data_for_empty_tables.sql

commit;

--generate report
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
from nm_dbug
where nd_session_id=USERENV('SESSIONID')
order by nd_id
/

spool off
