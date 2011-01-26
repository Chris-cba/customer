CREATE OR REPLACE PROCEDURE AH_SET_TABLE_SRID(p_table  IN VARCHAR2
                                                                                 , p_column IN VARCHAR2
                                                                                 , p_srid   IN NUMBER )  AS 
 --------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/General Scripts/BRS3225/ah_set_table_srid.sql-arc   3.1   Jan 26 2011 07:55:56   Ian.Turnbull  $
--       Module Name      : $Workfile:   ah_set_table_srid.sql  $
--       Date into PVCS   : $Date:   Jan 26 2011 07:55:56  $
--       Date fetched Out : $Modtime:   Nov 08 2010 13:01:00  $
--       PVCS Version     : $Revision:   3.1  $
--       Based on SCCS version :
--
--   Author : Aileen Heal
--
---------------------------------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
---------------------------------------------------------------------------------------------------
--
-- Written by Aileen Heal to change the SRID of a table, this calls the standard function
-- Nm3sdo.set_srid 
-- N.B. it will not reproject the data
--      it disable the trigers first, sets the srid and then enables the triggers
---------------------------------------------------------------------------------------------------
   type trigger_name_tab is TABLE OF USER_TRIGGERS.TRIGGER_NAME%TYPE
          INDEX BY BINARY_INTEGER;

   l_trigger_names trigger_name_tab;
   
BEGIN
  -- get all enabled triggers
   select TRIGGER_NAME
      bulk collect into l_trigger_names
    from user_triggers
  where TABLE_NAME = p_table
     and  STATUS = 'ENABLED';

  -- disable all enabled triggers
  if l_trigger_names.count > 0 then
     for i in l_trigger_names.first .. l_trigger_names.last loop
        begin
           execute immediate 'ALTER TRIGGER ' || l_trigger_names(i) || ' DISABLE';
        exception
           when others then
           nm_debug.debug('AH_SET_TABLE_SRID: Error disabling trigger '|| l_trigger_names(i)||'*'||sqlerrm);           
        end;
     end loop;          
  end if;
  
  -- set srid
  begin
     Nm3sdo.set_srid( p_table, p_column, p_srid); 
  exception
     when others then
        nm_debug.debug('AH_SET_TABLE_SRID: Error setting SRID for '||p_table||'*'||sqlerrm);           
  end;

  -- enable all previously disabled triggers  
  if l_trigger_names.count > 0 then
     for i in l_trigger_names.first .. l_trigger_names.last loop
        begin
           execute immediate 'ALTER TRIGGER ' || l_trigger_names(i) || ' ENABLE';
        exception
           when others then
           nm_debug.debug('AH_SET_TABLE_SRID: Error enabling trigger '|| l_trigger_names(i)||'*'||sqlerrm);           
        end;
     end loop;
  end if;     
     
END AH_SET_TABLE_SRID;
/  