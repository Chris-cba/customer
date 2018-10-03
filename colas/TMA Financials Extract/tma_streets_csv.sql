CREATE OR REPLACE procedure HIGHWAYS.tma_streets_csv
as
    l_rows  number;

begin
    l_rows := dump_csv( 'select str_ne_id , str_usrn  from v_tma_streets_all',chr(9),'D:\bentley_dir\colaprd\extracts\financials','v_tma_streets_all.csv' );
end;
/

