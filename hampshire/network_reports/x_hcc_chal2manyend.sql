-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header::   
--       Module Name      : $Workfile::   
--       Date into PVCS   : $Date::   
--       Date fetched Out : $Modtime::   
--       PVCS Version     : $Revision::   
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- To check sections with 2 end points
-- built 15/3/2010 SW
set serveroutput on 
set serveroutput on size unlimited

set ver off
set feed off
col spool new_value spool noprint;
select higgrirp.get_module_spoolpath(&&1,user)||higgrirp.get_module_spoolfile(&&1) spool 
from dual;
spool &spool

prompt
prompt Highways by Exor
exec higgrirp.write_gri_spool(&1,'Highways by Exor');
prompt ================
exec higgrirp.write_gri_spool(&1,'================');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt Checking for Sections with 2 end points
exec higgrirp.write_gri_spool(&1,'CHALIST Footpath - Adopted with more than 2 end points');
prompt
exec higgrirp.write_gri_spool(&1,'');
prompt Working ....
exec higgrirp.write_gri_spool(&1,'Working ....');
prompt
exec higgrirp.write_gri_spool(&1,'');

declare
  cursor c1 is
    select a.ne_id, b.ne_unique, a.geoloc.sdo_elem_info, ne_descr
    from V_NM_NLT_CHAL_SECT_SDO a, nm_elements_all b
   where ne_nt_type = 'CHAL'
   and ne_sub_type = 'W'
   and  a.NE_ID = b.NE_ID;
--and rownum<10

begin

  DBMS_OUTPUT.ENABLE(1000000);
  dbms_output.put_line('CHALIST Footpath - Adopted with more than 2 end points');
  
  for irec in c1 loop
  
   begin
     NM3ROUTE_CHECK.TERMINUS_CHECK(irec.ne_id, 'ROAD' );
   exception
     when others then
       higgrirp.write_gri_spool(&1,irec.ne_id||'    '||irec.ne_unique||' '||irec.ne_descr );
       dbms_output.put_line(irec.ne_id||'    '||irec.ne_unique||' '||irec.ne_descr );
    end;
  end loop;
  end;
/



set define on
set term off
set head off

exec higgrirp.write_gri_spool(&1,'Finished');
prompt
prompt Finished
exit;

