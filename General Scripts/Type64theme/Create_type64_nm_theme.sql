--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/General Scripts/Type64theme/Create_type64_nm_theme.sql-arc   3.0   Mar 09 2010 10:23:20   iturnbull  $
--       Module Name      : $Workfile:   Create_type64_nm_theme.sql  $
--       Date into PVCS   : $Date:   Mar 09 2010 10:23:20  $
--       Date fetched Out : $Modtime:   Mar 01 2010 10:50:58  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
-- This script will create new styles and theme for NSG theme type 64
-- It is assume that the theme has already been created using the GIS Layer tool
--
---------------------------------------------------------------------------------------------------
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='Create_type64_nm_theme_&log_extension'
set pages 0
set lines 200
SET SERVEROUTPUT ON size 1000000

spool &logfile1

set echo on

select name from v$database;


-- check to see if the type 64 theme exists
declare
  v_count number;
  l_allow_debug hig_options.HOP_VALUE%type;

begin

  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;
  nm_debug.set_level(3);

  select count(*) 
   into  v_count 
   from nm_themes_all 
   where nth_feature_table = 'V_NM_NIT_TP64_SDO_DT';
  
  if v_count < 1 then -- table does not exit
     -- create theme
     nm_debug.debug('  Creating TP64');
     nm3layer_tool.create_nsgn_asd_layer('TP64');
     nm_debug.debug('  Created TP64');
     commit;
  else
    nm_debug.debug('  Theme TP64 already exists so skipping creating');
  end if; 
  
  nm_debug.debug_off;

  update hig_options
  set hop_value=l_allow_debug 
  where hop_id='ALLOWDEBUG';  

end;
/

--report on layer creation
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
from nm_dbug
where nd_session_id=USERENV('SESSIONID')
and substr(nd_text,1,2) in ('  ','Cr','Co')
order by nd_id;

commit;

---------------------------------------------------------------------------------------------------
spool off
---------------------------------------------------------------------------------------------------
