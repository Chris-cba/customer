/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/IM WO Doc Assocs/wo_doc_assocs.sql-arc   1.2   Jun 27 2012 15:49:10   Ian.Turnbull  $
 --       Module Name      : $Workfile:   wo_doc_assocs.sql  $
 --       Date into PVCS   : $Date:   Jun 27 2012 15:49:10  $
 --       Date fetched Out : $Modtime:   Jun 27 2012 15:48:44  $
 --       PVCS Version     : $Revision:   1.2  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */

update im_pod_sql
set ips_source_code = replace(ips_source_code,'im_framework.has_doc','x_im_wo_has_doc')
where instr(ips_source_code,'im_framework.has_doc') > 0
and 
instr(ips_source_code,'WORK_ORDERS') > 0
;

update im_pod_sql
set ips_source_code = replace(ips_source_code,'showDocAssocsWT','showWODocAssocs')
where instr(ips_source_code,'showDocAssocsWT') > 0
and 
instr(ips_source_code,'WORK_ORDERS') > 0
;


update apex_030200.wwv_flow_worksheets
set sql_query = replace(sql_query,'im_framework.has_doc','x_im_wo_has_doc')
where flow_id = 512;

update apex_030200.wwv_flow_worksheets
set sql_query = replace(sql_query,'showDocAssocsWT','showWODocAssocs')
where flow_id = 512;



update apex_030200.wwv_flow_templates
set  header_template = replace(header_template,'#HEAD#',chr(13)||
'<script type="text/javascript">
function showWODocAssocs(docID,appID,sessionID,dasTableName)
{
   setSessionValue("P8_WOID",docID);
   var url = "f?p=" + appID + ":8:" + sessionID;   
    $("#daContent").attr("src",url);  
    $("#docAss").dialog("option", "title" , "Associated documents for : "+docID);    
    $("#docAss").dialog("open");
}</script>'
||chr(13)||'#HEAD#')
where flow_id = 1000 
and name in ( 'Default','drill down page');


update apex_030200.wwv_flow_templates
set header_template = replace(header_template,'#HEAD#',chr(13)||
'<script type="text/javascript">
function showWODocAssocs(docID,appID,sessionID,dasTableName)
{
   setSessionValue("P8_WOID",docID);
   var url = "f?p=" + appID + ":8:" + sessionID;   
    $("#daContent").attr("src",url);  
    $("#docAss").dialog("option", "title" , "Associated documents for : "+docID);    
    $("#docAss").dialog("open");
}</script>'
||chr(13)||'#HEAD#')
where flow_id = 512
and name in ( 'One Level Tabs with Sidebar');


update apex_030200.wwv_flow_templates
set  header_template = replace(header_template,'<link rel="stylesheet" href="/&FRAMEWORK_DIR./css/master.css" type="text/css" />'
                                              ,'<!--link rel="stylesheet" href="/&FRAMEWORK_DIR./css/master.css" type="text/css" /-->')
where flow_id = 1000 
and name in ( 'popup');

update apex_030200.wwv_flow_templates
set  header_template = replace(header_template,'<script type="text/javascript" src="/&FRAMEWORK_DIR./js/cmode.js"></script>'
                                              ,'<!--script type="text/javascript" src="/&FRAMEWORK_DIR./js/cmode.js"></script-->')
where flow_id = 1000 
and name in ( 'popup');

commit;
