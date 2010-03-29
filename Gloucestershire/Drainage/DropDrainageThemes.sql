--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/Gloucestershire/Drainage/DropDrainageThemes.sql-arc   3.0   Mar 29 2010 12:51:10   iturnbull  $   
--       Module Name      : $Workfile:   DropDrainageThemes.sql  $   
--       Date into PVCS   : $Date:   Mar 29 2010 12:51:10  $
--       Date fetched Out : $Modtime:   Mar 18 2010 12:43:40  $
--       PVCS Version     : $Revision:   3.0  $
--
--       Author: Aileen Heal
--------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
--------------------------------------------------------------------------------
--
-- This script was written by Aileen Heal to DROP the standard drainage asset themes
--
--------------------------------------------------------------------------------
-- Spool to Logfile

col         log_extension new_value log_extension noprint
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual;

define logfile1='DropDrainageThemes_&log_extension'
set pages 0
set lines 200

spool &logfile1

set echo on
set time on

declare
  l_allow_debug     hig_options.HOP_VALUE%type;
  l_yes             varchar2(1);

begin

  select hop_value
  into l_allow_debug
  from hig_options 
  where hop_id='ALLOWDEBUG';

  update hig_options
  set hop_value='Y'
  where hop_id='ALLOWDEBUG';

  nm_debug.debug_on;
  
  nm_debug.debug('Dropping drainage asset themes' );
  
  for rec in (select nit_INV_TYPE, NIT_PNT_OR_CONT, nit_descr
                from nm_inv_types
               where nit_inv_type in ('PP','OU','IT','GU','CQ','II','SO','BI','PS',
                                      'RE','GN','RT','CU','LD','SY','CN','EN','MM',
                                      'DB','GR','SC','DT','CE','LI','CF','FN','ND',
                                      'CK','FR','OE','CJ','RC','SP','DP','RP','IB',
                                      'PC','WL'))
  loop
     nm_debug.debug('Dropping theme for ' || rec.nit_INV_TYPE || '; ' || rec.nit_descr );
     
     Nm3sdm.drop_layers_by_inv_type (rec.nit_inv_type);
     
     nm_debug.debug('Dropped theme for ' || rec.nit_INV_TYPE || '; ' || rec.nit_descr );
     
     commit;
  end loop;
  
  nm_debug.debug('Completed all drainage asset themes' );
  nm_debug.debug_off;

  update hig_options
     set hop_value=l_allow_debug 
    where hop_id='ALLOWDEBUG';     
end;    
/

--report on dropping of themes
col nd_text format a170

select to_char(nd_timestamp,'DD-MON-YYYY HH24:MI:SS'),nd_text 
  from nm_dbug
 where nd_session_id=USERENV('SESSIONID')
 order by nd_id;

spool off
