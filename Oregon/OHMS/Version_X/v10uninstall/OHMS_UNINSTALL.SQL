-- Attempt to remove TransInfo UI Items
delete from HIG_STANDARD_FAVOURITES where HSTF_PARENT = 'OHMS';
delete from HIG_STANDARD_FAVOURITES where HSTF_CHILD = 'OHMS';
delete from GRI_MODULES where GRM_MODULE = 'OHMS_RUN';
delete from HIG_MODULES where  HMO_APPLICATION = 'OHMS';


-- Remove Merge Query
declare

l_merge_id NM_MRG_QUERY_ALL.nmq_id%type;

begin
    select nmq_id into l_merge_id from NM_MRG_QUERY_ALL where NMQ_UNIQUE = 'OHMS_EXTRACT';    
    delete from  NM_MRG_QUERY_ALL where NMQ_ID = l_merge_id;    
    exception
    when others then null;    
end;
/

-- Remove OHMS Tables, Views, Functions, Proceedure, Packages

declare

T_ITEM varchar2(15);
T_NAME varchar2(50);

Cursor cur_items is  
  select Item_Type, Item_Name from OHMS_OBJECTS 
  where Item_Type not in ('TABLE', 'INDEX') and uninstall = 1
  ;
  
Cursor cur_tables is  
  select Item_Type, Item_Name from OHMS_OBJECTS 
  where Item_Type = 'TABLE' and uninstall = 1
  ;

begin          
        open CUR_TABLES;
          
          LOOP
			
              FETCH CUR_TABLES into T_ITEM, T_NAME;
              EXIT when CUR_TABLES%NOTFOUND;
				BEGIN
					execute immediate 'drop '|| T_Item || ' ' || T_NAME || ' CASCADE CONSTRAINTS' ;
					exception when others then null;
				End;
          end loop;     
		close CUR_TABLES;
	
        open cur_items;
          
          LOOP
			
              FETCH cur_items into T_ITEM, T_NAME;
              EXIT when cur_items%NOTFOUND;
				Begin
					execute immediate 'drop '|| T_Item || ' ' || T_NAME ;
					exception when others then null;
				End;
          end loop;     
		close cur_items;
		
	
end;
/


-- Remove Object List, Activity Log
drop table OHMS_OBJECTS;
drop table OHMS_ACTIVITY_LOG;

