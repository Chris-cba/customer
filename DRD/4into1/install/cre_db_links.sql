-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/DRD/4into1/install/cre_db_links.sql-arc   1.0   Jan 17 2013 10:38:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   cre_db_links.sql  $
--       Date into PVCS   : $Date:   Jan 17 2013 10:38:28  $
--       Date fetched Out : $Modtime:   Jan 17 2013 09:59:28  $
--       Version          : $Revision:   1.0  $
--
--   Copyright (c) exor corporation ltd, 2010
--
-----------------------------------------------------------------------------
 create public database link db_link_north 
 connect to area_north identified by area_north using 'drdtst';

 create public database link db_link_south
 connect to area_south identified by area_south using 'drdtst';

 create public database link db_link_west 
 connect to area_west identified by area_west using 'drdtst';

 CREATE PUBLIC DATABASE LINK db_link_east
 CONNECT TO area_east IDENTIFIED BY area_west USING 'drddev';


--create db link views
declare
  type areas_type IS TABLE OF varchar2(30)    INDEX BY binary_integer;
  
  areas areas_type;
  str varchar2(1000);
  
begin
  areas(1) := 'north';
  areas(2) := 'south';
  areas(3) := 'west';
  
  
  for i in 1..areas.count
   loop
     for crec in ( select * from user_tables)
      loop
        str := 'create or replace force view ' ||areas(i)||'_'||crec.table_name||' as select * from '||crec.table_name||'@db_link_'||areas(i);
        begin
        execute immediate 'create or replace force view ' ||areas(i)||'_'||crec.table_name||' as select * from '||crec.table_name||'@db_link_'||areas(i);
        exception when others then null;
        end;
     end loop;
  end loop;
  
  exception when others then raise_application_error(-20500,str);
end;
/
