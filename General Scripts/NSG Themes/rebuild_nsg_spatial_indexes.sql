--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/General Scripts/NSG Themes/rebuild_nsg_spatial_indexes.sql-arc   1.0   Jan 11 2011 10:28:30   Ian.Turnbull  $
--       Module Name      : $Workfile:   rebuild_nsg_spatial_indexes.sql  $
--       Date into PVCS   : $Date:   Jan 11 2011 10:28:30  $
--       Date fetched Out : $Modtime:   Jan 11 2011 10:24:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
-- This script will rebuild the NSG spatial indexes if required.
--
col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
---------------------------------------------------------------------------------------------------
-- Spool to Logfile

define logfile1='rebuild_nsg_spatial_indexes_&log_extension'
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

begin

  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  hig.set_opt('ALLOWDEBUG', 'Y');

  nm_debug.debug_on;

if NSG_SPATIAL_CONSOLIDATION.SPATIAL_INDEX_REBUILD_NEEDED then
    NSG_SPATIAL_CONSOLIDATION.rebuild_nsg_spatial_indexes;
else
   nm_debug.debug( 'NSG Spatial Indexes did not need rebuilding'); 
end if;

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