-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/create_sub_sdo_views.sql-arc   1.0   Mar 15 2012 14:33:40   Ian.Turnbull  $
--       Module Name      : $Workfile:   create_sub_sdo_views.sql  $
--       Date into PVCS   : $Date:   Mar 15 2012 14:33:40  $
--       Date fetched Out : $Modtime:   Mar 15 2012 12:46:26  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems, 2012
-----------------------------------------------------------------------------
-
--
-- This script are for use by Bentley consultants only. They should not be provided to customers 
--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
col         log_extension new_value log_extension noprint
select  instance_name||'_create_sub_sdo_views_'||TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.log' log_extension from v$instance
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
--
  l_allow_debug := hig.get_sysopt('ALLOWDEBUG');
  hig.set_opt('ALLOWDEBUG', 'Y');
  nm_debug.debug_on;
--   
   for rec in (select hus_username from hig_users
                where HUS_IS_HIG_OWNER_FLAG='N') loop
      nm_debug.debug('Creating Subordinate SDO views for ' || rec.hus_username);
      nm3sdm.refresh_usgm(rec.hus_username);
      nm3ddl.CREATE_SUB_SDO_VIEWS(rec.hus_username);
   end loop;
--  
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
