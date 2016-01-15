--OHMS Sections Table

--Droping tables and views

declare
    i integer;
    sname varchar(50);
	
Cursor cur_views is  
  select VIEW_NAME from USER_VIEWS 
  where VIEW_NAME like 'V_HPMS_7%'
  OR VIEW_NAME like 'V_HPMS_FINAL_7%';
	

BEGIN

sname := 'OHMS_SUBMIT_SECTIONS';


    select COUNT(*) into I from USER_TABLES where TABLE_NAME = SNAME;
    if i <> 0 then
        execute immediate 'drop table ' || sname ;
    end if;
	
	for  C_ROW IN CUR_VIEWS LOOP    	
		execute immediate 'drop view ' || C_ROW.VIEW_NAME;  
	end loop;
	
	
END;
/

DROP PACKAGE xna_ohms;