set sqlblanklines on

-- Insert OHMS Object List
@OHMS_OBJECT_LIST.SQL

-- Drop Existing Tables
declare  

  T_NAME varchar2(50);     
  
Cursor cur_items is  
  select Item_Name from OHMS_OBJECTS 
  where Item_Type = 'TABLE' and item_name <> 'OHMS_OBJECTS'
  ;

BEGIN	
    open cur_items;          
          LOOP
              FETCH cur_items into T_NAME;
              EXIT when CUR_ITEMS%NOTFOUND;
              
              begin 
                execute immediate 'drop '|| 'table' || ' ' || T_NAME || ' CASCADE CONSTRAINTS' ;
                EXCEPTION when OTHERS then null;
              end;
              
          end LOOP;     
	close cur_items; 
END;
/


-- Install Independant Tables
@OHMS_CREATE_TABLES.SQL

-- Install Functions
@OHMS_F_SIGNAL_CNT.FNC
@OHMS_F_GET_TLL.FNC
@OHMS_F_GET_TLR.FNC

/*

-- Install Function Dependent Tables
@OHMS_CREATE_TABLE_F.SQL

--Create Table Indexes
@OHMS_CREATE_IDX.SQL

-- Install OHMS Views
@OHMS_V_VIEWS.SQL
@OHMS_V_7_VIEWS.SQL
@OHMS_V_7_FINAL_VIEWS.SQL

-- Update OHMS TransInfo UI
@OHMS_SECURITY.sql
@ohms_menus.sql

--Create Merge Query
@OHMS_CREATE_MERGE.SQL

--Install Proceedures
@OHMS_P_UPDATE_TABLES.PRC
@OHMS_P_XODOT_POPULATE_OHMS_SECTIONS.PRC

--Install Packages
@OHMS_PK_XODOT_OHMS.PKS
@OHMS_PK_XODOT_OHMS.pkb

*/
