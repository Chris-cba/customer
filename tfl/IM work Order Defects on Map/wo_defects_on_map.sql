/* -----------------------------------------------------------------------------
 --
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/IM work Order Defects on Map/wo_defects_on_map.sql-arc   1.0   Jun 15 2012 14:32:46   Ian.Turnbull  $
 --       Module Name      : $Workfile:   wo_defects_on_map.sql  $
 --       Date into PVCS   : $Date:   Jun 15 2012 14:32:46  $
 --       Date fetched Out : $Modtime:   Jun 15 2012 14:24:56  $
 --       PVCS Version     : $Revision:   1.0  $
 --       Based on SCCS version :
 --
 --
 -----------------------------------------------------------------------------
 -- Copyright (c) exor corporation ltd, 2009
 -----------------------------------------------------------------------------
 */
spool wo_defects_on_map.log
set define off
set scan off

update im_pod_sql
set ips_source_code = replace(ips_source_code,'showPopUpMap','showWODefOnMap')
where instr(ips_source_code,'showPopUpMap') > 0;

update apex_030200.wwv_flow_templates
set  header_template = replace(header_template,'#HEAD#',chr(13)||'<script src="/&FRAMEWORK_DIR./js/wo_defects_on_map.js" type="text/javascript"></script>'||chr(13)||'#HEAD#')
where flow_id = 1000 
and name in ( 'Default','drill down page');


update apex_030200.wwv_flow_templates
set header_template = replace(header_template,'#HEAD#',chr(13)||'<script src="/&FRAMEWORK_DIR./js/wo_defects_on_map.js" type="text/javascript"></script>'||chr(13)||'#HEAD#')
where flow_id = 512
and name in ( 'One Level Tabs with Sidebar');

update apex_030200.wwv_flow_worksheets
set sql_query = replace(sql_query,'showPopUpMap','showWODefOnMap')
where flow_id = 512;

commit;
spool off
