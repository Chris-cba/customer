create table  X_LOG_INFORMATION  ( 
                                    Sys_Date timestamp
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