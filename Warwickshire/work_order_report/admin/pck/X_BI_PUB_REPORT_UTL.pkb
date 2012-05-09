create or replace PACKAGE BODY          x_bi_pub_report_utl AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/Warwickshire/work_order_report/admin/pck/X_BI_PUB_REPORT_UTL.pkb-arc   1.0   May 09 2012 10:44:08   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_BI_PUB_REPORT_UTL.pkb  $
--       Date into PVCS   : $Date:   May 09 2012 10:44:08  $
--       Date fetched Out : $Modtime:   May 01 2012 21:16:10  $
--       PVCS Version     : $Revision:   1.0  $
--       Based on SCCS version :

--
--
--   Author : Paul Stanton
--
--    x_bi_pub_report_utl header
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Systems ltd, 2011
-----------------------------------------------------------------------------
--
--
procedure POP_PARAM_TABLE(P_REPORT_NAME  varchar2 default null,
                                          P_PARAM_NAME  varchar2 default null,
                                          P_PARAM_VALUE  varchar2 default null)
is
  N_RUN_ID number;
  url varchar2(1000);
begin
  N_RUN_ID := POP_PARAM_TABLE(P_REPORT_NAME => P_REPORT_NAME
                             ,P_PARAM_NAME  => P_PARAM_NAME
                             ,P_PARAM_VALUE =>  P_PARAM_value);

  URL := X_CALL_BI_PUB_REPORT( P_REPORT_NAME => P_REPORT_NAME
                              ,p_run_id => n_run_id);

  HTP.P('<html>');
  HTP.P('<head>');
   HTP.P('<script language="JavaScript" type="text/javascript">');
   HTP.P('function go(){
     var win = window.open ( "'||url||'");
   };');
   HTP.P('</script>');
  HTP.P('</head>');
  HTP.P('<body onload="javascript:go();">');
  HTP.P('transfering to ' || URL );
  HTP.P('</body>');
  HTP.P('</html>');



end pop_param_table;


FUNCTION pop_param_table(p_report_name  VARCHAR2,
                                          p_param_name  VARCHAR2,
                                          p_param_value  VARCHAR2)  RETURN number IS

n_run_id NUMBER;
n_values NUMBER;
l_value VARCHAR2(100);

CURSOR get_each_value IS
SELECT * FROM ( SELECT TRIM( SUBSTR ( txt , INSTR (txt, ',', 1, level ) + 1 , INSTR (txt, ',', 1, level+1 ) - INSTR (txt, ',', 1, level) -1 ) ) AS col_value
 FROM ( SELECT ','||p_param_value||',' AS txt FROM dual ) CONNECT BY level <= LENGTH(txt)-LENGTH(REPLACE(txt,',',''))-1 );
BEGIN

select x_bi_pub_rep_run_id.nextval into n_run_id from dual;



for i in get_each_value loop


 insert into x_bi_pub_runtime_params
values
(upper(p_report_name),
upper(p_param_name),
upper(i.col_value),
n_run_id);
commit;

end loop;


        RETURN n_run_id;

END pop_param_table;
--
-----------------------------------------------------------------------------
--
-- Clear_param_table - Housekeeping procedure to clear down the parameter table - Set to run via a process
PROCEDURE clear_param_table IS

BEGIN

    DELETE FROM x_bi_pub_runtime_params;

    COMMIT;

END clear_param_table;
--
-----------------------------------------------------------------------------
--
FUNCTION x_call_bi_pub_report(p_report_name VARCHAR2,
                                                p_run_id NUMBER) RETURN VARCHAR2 IS


-- Runtime Params
v_url                 VARCHAR2(5000);
--
--metadata params
--
bi_server_url       VARCHAR2(1000);
bi_report_folder   VARCHAR2(1000);
bi_param_name   VARCHAR2(1000);
--
CURSOR get_report_dets IS
SELECT * FROM x_bi_pub_reports
WHERE upper(bi_report_name) = upper(p_report_name);

BEGIN


FOR i IN get_report_dets LOOP

  v_url := i.bi_server_url||'xmlpserver/'||i.bi_report_folder||'/'||i.bi_report_name||'/'||i.bi_report_name||'.xdo?_xpf=&_xpt=0&_xdo=%2F'||replace(i.bi_report_folder,' ','%20')||'%2F'||replace(i.bi_report_name,' ','%20')||'%2F'||replace(i.bi_report_name,' ','%20')||'.xdo&'||i.bi_param_name||'='||p_run_id||'&_xt='||replace(i.bi_report_name,' ','%20')||'&_xf=pdf&_xmode=4';

  END LOOP;

RETURN v_url;

END x_call_bi_pub_report;
--
-----------------------------------------------------------------------------
--
procedure parameter_entry
is
begin
   HTP.P('<script language="JavaScript" type="text/javascript">');
   HTP.P('function saveParams(){
     var host = "shvxor01";
     var dad = "atlas";
     var proc = "x_bi_pub_report_utl.POP_PARAM_TABLE";
     var param1 = $("#p_report_name").val();
     var param2 = $("#p_param_name").val();
     var param3 = $("#p_param_value").val();

     var win = window.open ( "http://"+host+"/"+dad+"/"+proc+"/"+"?p_report_name="+param1+"&"+"p_param_name"+"="+param2+"&"+"p_param_value"+"="+param3);
   };');

   HTP.P('</script>');

   HTP.P('<table class="formlayout">');
   HTP.P('<tr>');
   HTP.P('<input id="p_report_name" class="inputFields" type="hidden" value="WORK ORDER PRINT" maxlength="2000" size="30" name="p_report_name">');
   HTP.P('<input id="p_param_name" class="inputFields" type="hidden" value="RUN_ID" maxlength="2000" size="30" name="p_param_name">');
   HTP.P('<td nowrap="nowrap" align="right">Work Order Ids</td>');
   HTP.P('<td>');
   HTP.P('<input id="p_param_value" class="inputFields" type="textarea" value="" maxlength="2000" size="30" name="p_param_value">');
   htp.p('</td>');
   htp.p('</tr>');
   htp.p('</table>');

   HTP.P('<a class="plsqlrunbutton" id="" href="javascript:saveParams();">Run</a>');

   HTP.P('<script language="JavaScript" type="text/javascript">');
   HTP.P('$(".plsqlrunbutton").button();');

   HTP.P('</script>');
end parameter_entry;
--
-----------------------------------------------------------------------------
--
END x_bi_pub_report_utl;
/

