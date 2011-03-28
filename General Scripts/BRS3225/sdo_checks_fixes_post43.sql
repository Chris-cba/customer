-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/sdo_checks_fixes_post43.sql-arc   1.1   Mar 28 2011 11:59:18   Ian.Turnbull  $
--       Module Name      : $Workfile:   sdo_checks_fixes_post43.sql  $
--       Date into PVCS   : $Date:   Mar 28 2011 11:59:18  $
--       Date fetched Out : $Modtime:   Jan 18 2011 17:43:32  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :

--
--
--   Author : Clive Hackforth
--
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
-- script written by Clive Hackforth to
--   * build all subordinate views
--   * drop themes where the feature table/view does not actually exist
--   * remove entries in user_sdo_geom_metadata where table/view does not exist
--   
--
col         log_extension new_value log_extension noprint
select  instance_name||'_fixes_post_43_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.log' log_extension from v$instance
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='&log_extension'
set pages 0
set lines 200
set echo on
SET SERVEROUTPUT ON size 1000000


spool &logfile1

begin
  for c1rec in
(          
  select distinct hus_username from
            ( 
            SELECT hus_username   FROM hig_users
                     , all_users
                     , nm_themes_all
                     , hig_user_roles
                     , nm_theme_roles
                 WHERE hus_username = username
                   AND hus_username != hig.get_application_owner
                   AND nth_theme_type = 'SDO'
                   AND nthr_theme_id = nth_theme_id
                   AND nthr_role = hur_role
                   AND hur_username = hus_username
                   AND EXISTS
                     (SELECT * FROM dba_role_privs
                       WHERE grantee = hus_username
                         AND granted_role = nthr_role)
                   AND NOT EXISTS
                       -- Ignore the TMA Webservice schemas
                         (SELECT 1 FROM all_objects o
                           WHERE o.object_name = 'GET_RECIPIENTS'
                             AND o.object_type = 'PROCEDURE'
                             AND o.owner = hus_username)
                   AND NOT EXISTS (
                          SELECT 1
                            FROM dba_objects
                           WHERE owner != hig.get_application_owner
                             AND owner = hus_username
                             AND object_name = nth_feature_table
                             AND object_type = 'VIEW')
            )
            )            
   loop
   dbms_output.put_line(c1rec.hus_username);
    nm3sdm.create_msv_feature_views(pi_username => c1rec.hus_username);  
   end loop;
end;        
/


begin
	for c1rec in
	  (select  nth_theme_id, nth_theme_name, nth_feature_table  from nm_themes_all
     where not  nth_feature_table in    (select table_name from user_tables union select view_name from user_views))
  loop
  	nm3sdm.drop_layer(c1rec.nth_theme_id);
  	dbms_output.put_line(c1rec.nth_Theme_name||' theme dropped');
  end loop;
end;
/

begin
	for c1rec in
	  ( SELECT sequence_name
      FROM user_sequences
     WHERE sequence_name LIKE 'NTH%SEQ'
       AND NOT EXISTS (SELECT 1
                         FROM nm_themes_all
                        WHERE nth_sequence_name = sequence_name)
       AND sequence_name NOT LIKE '%THEME%')
   loop
     Nm3ddl.drop_synonym_for_object (c1rec.sequence_name);
     EXECUTE IMMEDIATE 'drop sequence ' || c1rec.sequence_name;
  	dbms_output.put_line(c1rec.sequence_name||' sequence dropped');
   END LOOP;
 END;
/


delete from user_sdo_Geom_metadata
where table_name not in (select object_name from user_objects where object_type in ('VIEW', 'TABLE'))
/

spool off

-------------------------------------------------

PROMPT check log and issue a commit if all ok or rollback if errors
