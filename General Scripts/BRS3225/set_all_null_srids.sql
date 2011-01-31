--------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/set_all_null_srids.sql-arc   3.2   Jan 31 2011 15:05:16   Ian.Turnbull  $
--       Module Name      : $Workfile:   set_all_null_srids.sql  $
--       Date into PVCS   : $Date:   Jan 31 2011 15:05:16  $
--       Date fetched Out : $Modtime:   Jan 27 2011 10:08:56  $
--       PVCS Version     : $Revision:   3.2  $
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
col diminfo format a30
col column_name format a30

col         log_extension new_value log_extension noprint
select  instance_name||'_set_All_null_srids_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.log' log_extension from v$instance
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile
define logfile1='&log_extension'
set pages 0
set lines 200
set echo on
SET SERVEROUTPUT ON size 1000000


set echo on

undefine pv_default_srid

spool &logfile1

set echo on

select user from dual
/

select instance_name  from v$instance
/


-- select table_name,srid from user_Sdo_geom_metadata
--order by 1;


@AH_SET_TABLE_SRID.sql

prompt
accept   pv_default_srid   default 81989 prompt "Enter the default srid to use: "

declare
   l_allow_debug    hig_options.HOP_VALUE%type;
   l_reg_sde_layer  hig_options.HOP_VALUE%type;
   l_default_srid      number := &pv_default_srid;
   l_table_type     varchar2(40);
      
   cursor c1 is
/*         select nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column  
           from nm_themes_all
        where nth_feature_table in
       (select table_name from user_sdo_geom_metadata where srid is null)
           and exists ( select 1 from user_tables where  table_name = nth_feature_table )
           and not exists ( select 1 from user_objects 
                                   where object_name = nth_feature_table 
                                       and object_type =  'MATERIALIZED VIEW')
          ORDER BY nth_base_table_theme NULLS FIRST;
 */ 
 select distinct nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column,srid
from
(SELECT distinct nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column,u.sdo_srid srid
      FROM MDSYS.sdo_geom_metadata_table u,
           (SELECT   hus_username, nth_feature_table, nth_feature_shape_column,nth_theme_id, nth_theme_name
                FROM (SELECT hus_username, a.nth_feature_table, a.nth_feature_shape_column, nth_theme_id, nth_Theme_name
                        FROM nm_themes_all a,
                             nm_theme_roles,
                             hig_user_roles,
                             hig_users,
                             all_users
                       WHERE nthr_theme_id = a.nth_theme_id
                         AND nthr_role = hur_role
                         AND hur_username = hus_username
                         AND hus_username = username
                         AND hus_username != hig.get_application_owner
                         AND hus_end_date IS NULL
                         AND NOT EXISTS
                         -- Ignore the TMA Webservice schemas
                           (SELECT 1 FROM all_objects o
                             WHERE o.object_name = 'GET_RECIPIENTS'
                               AND o.object_type = 'PROCEDURE'
                               AND o.owner = hus_username)
                         -- Make sure the role is actually granted 
                         AND EXISTS
                           (SELECT * FROM dba_role_privs
                             WHERE grantee = hus_username
                               AND granted_role = nthr_role)
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM MDSYS.sdo_geom_metadata_table g1
                                 WHERE g1.sdo_owner = hus_username
                                   AND g1.sdo_table_name = nth_feature_table
                                   AND g1.sdo_column_name = nth_feature_shape_column)
                      UNION ALL
                      SELECT hus_username, b.nth_feature_table, b.nth_feature_shape_column,b.nth_theme_id ,b.nth_theme_name
                        FROM nm_themes_all a,
                             hig_users,
                             all_users,
                             nm_themes_all b
                       WHERE b.nth_theme_id = a.nth_base_table_theme
                         AND hus_username = username
                         AND hus_username != hig.get_application_owner
                         AND hus_end_date IS NULL
                         AND NOT EXISTS
                         -- Ignore the TMA Webservice schemas
                           (SELECT 1 FROM all_objects o
                             WHERE o.object_name = 'GET_RECIPIENTS'
                               AND o.object_type = 'PROCEDURE'
                               AND o.owner = hus_username)
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM MDSYS.sdo_geom_metadata_table g1
                                 WHERE g1.sdo_owner = hus_username
                                   AND g1.sdo_table_name = b.nth_feature_table
                                   AND g1.sdo_column_name = b.nth_feature_shape_column)
                         -- Make sure we only report base table themes that we actually
                         -- have the roles to access their child View based themes
                         AND a.nth_theme_id IN (
                                SELECT z.nth_theme_id
                                  FROM nm_themes_all z, nm_theme_roles
                                 WHERE EXISTS (SELECT 1
                                                 FROM hig_user_roles
                                                WHERE hur_username = hus_username 
                                                  AND hur_role = nthr_role)
                                   AND nthr_theme_id = z.nth_theme_id))
            GROUP BY hus_username, nth_feature_table, nth_feature_shape_column,nth_theme_id,nth_theme_name)
     WHERE u.sdo_table_name = nth_feature_table
       AND u.sdo_column_name = nth_feature_shape_column
       AND u.sdo_owner = hig.get_application_owner
 union all
    select
     nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column,null
      FROM nm_themes_all
     WHERE nth_theme_type = 'SDO'
       AND NOT EXISTS (
              SELECT 1
                FROM user_sdo_geom_metadata
               WHERE table_name = nth_feature_table
                 AND column_name = nth_feature_shape_column)
union all
 select nth_theme_id,nth_theme_name, nth_feature_table, nth_feature_shape_column  ,null
           from nm_themes_all
        where nth_feature_table in
       (select table_name from user_sdo_geom_metadata where srid is null)
           and exists ( select 1 from user_tables where  table_name = nth_feature_table )
           and not exists ( select 1 from user_objects 
                                   where object_name = nth_feature_table 
                                       and object_type =  'MATERIALIZED VIEW'))
  where nth_feature_table is not null                                   
order by 1;         
          
          
   cursor c2 is
         Select table_name, column_name 
           from user_sdo_geom_metadata
        where table_name in ( 'TMA_NONSWA_STR_LOCS_SDO',   'TMA_SW_LICENCES_SDO')
            and srid is null;

   cursor c3 (pi_table nm_themes_all.nth_feature_table%type) is
   	    select object_type from all_objects
   	    where object_name=pi_table
   	     and owner=hig.get_application_owner;

begin

  l_allow_debug := hig.get_sysopt('ALLOWDEBUG');
  
  hig.set_opt('ALLOWDEBUG', 'Y');
  nm_debug.debug_on;

 l_reg_sde_layer := hig.get_sysopt('REGSDELYR');
 
  for c1rec in c1 loop
    -- first check it is not a materalised view
--check is a table, not view or MV and that the srid is null 
    open c3(c1rec.nth_feature_Table);
    fetch c3 into l_table_type;
    close c3; 
    nm_debug.debug(c1rec.nth_feature_table||' '||l_table_type||' SRID '|| c1rec.srid );
    if l_table_type = 'TABLE' and c1rec.srid is null then
      nm_debug.debug('Setting SRID for ' || c1rec.nth_feature_table|| ' to  '|| l_default_srid );
      ah_set_table_srid(c1rec.nth_feature_table, c1rec.nth_feature_shape_column, l_default_srid );
      ah_set_dependent_views_srids(c1rec.nth_feature_table, c1rec.nth_feature_shape_column, c1rec.nth_theme_id, l_default_srid );
    end if;  
--end check     

     commit;
  end loop;
  nm_debug.debug('Checking other TMA tables ');

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

