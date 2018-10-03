CREATE OR REPLACE procedure HIGHWAYS.nsg_org_csv
as
    l_rows  number;

begin
    l_rows := dump_csv( 'select ORG_REF , org_name from nsg_organisations',chr(9),'D:\bentley_dir\colaprd\extracts\financials','nsg_organisations.csv' );
end;
/

