set echo on

declare
    i integer;
    sname varchar(50);


BEGIN  --  Done to remove error messages
	
	
	sname := 'OHMS_SUBMIT_SAMPLES';

	
    select COUNT(*) into I from USER_TABLES where TABLE_NAME = SNAME;
    if i <> 0 then
		-- Dropping 'OHMS_SUBMIT_SAMPLES'
        execute immediate 'drop table ' || sname || ' CASCADE CONSTRAINTS' ;
    end if;
	
	sname := 'V_NM_OHMS_NW';	
    select COUNT(*) into I from USER_TABLES where TABLE_NAME = SNAME;
    if i <> 0 then
		-- Dropping 'TRANSINFO.V_NM_OHMS_NW'
        execute immediate 'drop table ' || sname || ' CASCADE CONSTRAINTS' ;
    end if;
	
END;

/


