create table  X_LOG_INFORMATION  ( 
                                    Sys_Date date
									, xli_id	number
                                    , module varchar2 (100)
                                    , area varchar2(100)
                                    , info1 varchar2(4000)
                                    , info2 varchar2(4000)
                                    );

CREATE SEQUENCE x_log_table_seq
  START WITH 1
  MAXVALUE 999999
  MINVALUE 0
  CYCLE
  NOCACHE
  NOORDER;

create or replace package body x_log_table is
/*
    The contents of this document, including system ideas and concepts, 
    are confidential and proprietary in nature and are not to be distributed 
    in any form without the prior written consent of Bentley Systems.
    
    Author: JMM
    UPDATE01:    Original, 2013.10.29, JMM
*/
    procedure init is
        n_table int;
        
        begin
            select count(*) into n_table from user_tables where table_name = 'X_LOG_INFORMATION';
            if n_table = 0 then
                execute immediate 'create table  X_LOG_INFORMATION  ( 
                                    Sys_Date date
									, xli_id	number
                                    , module varchar2 (100)
                                    , area varchar2(100)
                                    , info1 varchar2(4000)
                                    , info2 varchar2(4000)
                                    )'
                                    ;
            end if;
        end init;
        
    procedure clean(s_module varchar2) is
        begin
            
            execute immediate 'delete from X_LOG_INFORMATION where module = '||chr(39)||s_module ||chr(39);
            commit;
        end clean;
    
    procedure log_item(s_module varchar2, s_area varchar2, s_info1 varchar2, s_info2 varchar2) is
		n_number	number;
         pragma autonomous_transaction;
        begin
			select x_log_table_seq.nextval into n_number from dual;
            insert into x_log_information values ( sysdate ,n_number, s_module , s_area, s_info1, s_info2 );
            commit;
        end log_item;
end x_log_table;
/