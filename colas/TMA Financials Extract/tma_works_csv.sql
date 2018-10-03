CREATE OR REPLACE procedure HIGHWAYS.tma_works_csv
as
    l_rows  number;

begin
    l_rows := dump_csv( 'select TWOR_WORKS_REF, TWOR_STR_NE_ID, TWOR_ORG_REF, TWOR_WORKS_ID, TWOR_DIST_REF  from tma_works',chr(9),'D:\bentley_dir\colaprd\extracts\financials','tma_works.csv' );
end;
/

