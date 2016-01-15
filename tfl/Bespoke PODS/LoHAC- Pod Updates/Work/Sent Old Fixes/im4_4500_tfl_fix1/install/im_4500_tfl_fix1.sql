--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/customer/tfl/Bespoke PODS/LoHAC- Pod Updates/Work/Sent Old Fixes/im4_4500_tfl_fix1/install/im_4500_tfl_fix1.sql-arc   1.0   Jan 15 2016 00:31:52   Sarah.Williams  $
--       Module Name      : $Workfile:   im_4500_tfl_fix1.sql  $
--       Date into PVCS   : $Date:   Jan 15 2016 00:31:52  $
--       Date fetched Out : $Modtime:   Feb 20 2013 19:40:40  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='im_4500_tfl_fix1_1_&log_extension'
define logfile2='im_4500_tfl_fix1_2_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET');

WHENEVER SQLERROR EXIT

BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;

 --
 -- Check that HIG has been installed @ v4.5.0.0
 --
 hig2.product_exists_at_version (p_product        => 'HIG'
                                ,p_VERSION        => '4.5.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--
--------------------------------------------------------------------------------
-- Application Changes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT f1000.sql
SET TERM OFF
--
SET FEEDBACK ON
start f1000.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT f512.sql
SET TERM OFF
--
SET FEEDBACK ON
start f512.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- IM Pods
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_modules.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\hig_modules.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT hig_module_roles.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\hig_module_roles.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im_pods.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_pods.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im_pod_sql.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_pod_sql.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im_pod_chart.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_pod_chart.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im_user_tabs.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_user_tabs.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT im_user_pods.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_user_pods.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT sortables.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\sortables.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Themes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT im_themes.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\im_themes.sql
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Tables
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT x_im511001.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511001.tab
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511001_wo.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511001_wo.tab
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511002.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511002.tab
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511002_wo.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511002_wo.tab
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511003.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511003.tab
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511003_wo.tab
SET TERM OFF
--
SET FEEDBACK ON
start x_im511003_wo.tab
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Packages
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT im_chart_gen_3_10v45.pkb
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\pck\im_chart_gen_3_10v45.pkb
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_tfl_woot.pkb
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\pck\x_tfl_woot.pkb
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_tfl_woot.pkh
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\pck\x_tfl_woot.pkh
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT x_get_im_user_id.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\x_get_im_user_id.sql
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im_wo_has_doc.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\x_im_wo_has_doc.sql
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Sequences
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT im_4500_tfl.sqs
SET TERM OFF
--
SET FEEDBACK ON
start im_4500_tfl.sqs
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT c_pod_eop_requests.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eop_requests.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eot_requests.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eot_requests.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eot_updated.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eot_updated.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT c_pod_eot_updated_dd.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\c_pod_eot_updated_dd.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT imf_mai_work_orders_all_attrib.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\imf_mai_work_orders_all_attrib.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT pod_budget_security.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\pod_budget_security.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT pod_eot_requests.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\pod_eot_requests.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT pod_eot_updated.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\pod_eot_updated.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT pod_nm_element_security.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\pod_nm_element_security.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT v_mai_wol_network.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\v_mai_wol_network.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT wo_views.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\wo_views.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT work_due_to_be_cmp_no_def_base.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\work_due_to_be_cmp_no_def_base.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT work_due_to_be_cmp_no_df_child.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\work_due_to_be_cmp_no_df_child.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511001_wo_vw.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_im511001_wo_vw.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511002_wo_vw.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_im511002_wo_vw.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_im511003_wo_vw.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_im511003_wo_vw.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_daterange_wk.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_daterange_wk.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_daterange_wodc.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_daterange_wodc.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_daterange_wowt.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_daterange_wowt.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_daterange_wowt003.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_daterange_wowt003.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_application_reveiw.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_application_reveiw.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_application_status.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_application_status.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41035_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41035_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41036_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41036_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41037_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41037_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_lohac_im_im41038_pod.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_lohac_im_im41038_pod.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_im511001.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_im511001.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_im511002.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_im511002.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_im511003_ls.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_im511003_ls.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_im511003nls.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_im511003nls.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_wow001.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_wow001.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_work_tray_wow002.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_work_tray_wow002.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_wt_im511003_all.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_wt_im511003_all.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_wt_im511003_ls.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_wt_im511003_ls.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT x_wo_tfl_wt_im511003nls.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\x_wo_tfl_wt_im511003nls.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT ximf_mai_work_order_lines.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\ximf_mai_work_order_lines.vw
SET FEEDBACK OFF
--
--
SET TERM ON 
PROMPT ximf_mai_work_orders_all_attr.vw
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\views\ximf_mai_work_orders_all_attr.vw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
--Indexes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT x_tfl_ind.ind
SET TERM OFF
--
SET FEEDBACK ON
start x_tfl_ind.ind
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
--Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT process_metadata.sql
SET TERM OFF
--
SET FEEDBACK ON
start ..\admin\sql\process_metadata.sql
SET FEEDBACK OFF
--
--

--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT log_im_4500_tfl_fix1.sql 
--
SET FEEDBACK ON
start log_im_4500_tfl_fix1.sql
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- Compile the schema
--------------------------------------------------------------------------------
--
SET TERM ON
Prompt Executing the Compile_schema
SET TERM OFF
SPOOL OFF
SET define ON

start compile_schema;
--
--
spool &logfile2
SET TERM ON
--start compile_all.sql
spool off
--
EXIT
--
--