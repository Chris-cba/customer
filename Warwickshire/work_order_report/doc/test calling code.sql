Declare
l_report_in  varchar2(1000);
l_params_in VARCHAR2(1000);
l_url_out VARCHAR2(5000);
n_run_id NUMBER;
begin

l_report_in := 'Work Order Print';
l_params_in := 'NORTH/1016,NORTH/1000';


n_run_id :=  x_bi_pub_report_utl.pop_param_table(l_report_in,
                                                                          'wo_number',
                                                                          l_params_in);  

l_url_out := x_bi_pub_report_utl.x_call_bi_pub_report(l_report_in,
                                                                              n_run_id);
 

dbms_output.put_line('url is : '||l_url_out);



end;


http://gbexor8ck.mas.local/xmlpserver/WORK ORDER REPORT/WORK ORDER PRINT/WORK ORDER PRINT.xdo?_xpf=&_xpt=0&_xdo=%2FWORK%20ORDER%20REPORT%2FWORK%20ORDER%20PRINT%2FWORK%20ORDER%20PRINT.xdo&RUN_ID=24&_xt=WORK%20ORDER%20PRINT&_xf=pdf&_xmode=4

http://gbexor8ck.mas.local/xmlpserver/WORK ORDER REPORT/WORK ORDER PRINT/WORK ORDER PRINT.xdo?_xpf=&_xpt=0&_xdo=%2FWORK%20ORDER%20REPORT%2FWORK%20ORDER%20PRINT%2FWORK%20ORDER%20PRINT.xdo&RUN_ID=24&_xt=WORK%20ORDER%20PRINT&_xf=pdf&_xmode=4
