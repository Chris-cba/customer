undefine run_file
undefine logfile
col run_file new_value run_file noprint
col logfile new_value logfile noprint
SET verify OFF head OFF feedback off ECHO off term ON
--
set term off

select 'csi_install_'||to_char(sysdate,'DDMONYYYY_HH24MISS')||'.log' logfile
from dual
/

set term on
--                                                                                                                                                                                                                                                        
-----------------------------------  PACKAGE HEADERS  -----------------------------------------                                                                                                                                                                
--                                                                                                                                                                                                                                                        
spool &logfile
--get some db info
SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_dec_bespoke                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_dec_bespoke.pkh' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'                                                                                                                                                                                                                                         

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_pem_bespoke                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_pem_bespoke.pkh' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_def_status                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_def_status.pks' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  
--                                                                                                                                                                                                                                                        
-----------------------------------  PACKAGE BODIES  -----------------------------------------                                                                                                                                                                
--                                                                                                                                                                                                                                                        
SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_dec_bespoke                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_dec_bespoke.pkb' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'                                                                                                                                                                                                                                         

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_pem_bespoke                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_pem_bespoke.pkb' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_def_status                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_def_status.pkb' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  
--                                                                                                                                                                                                                                                        
-----------------------------------  METADATA  -----------------------------------------                                                                                                                                                                
--  
SET TERM ON                                                                                                                                                                                                                                               
PROMPT Inserting Work Order on hold email group                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'ins_wo_mail_group.sql' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  

SET TERM ON                                                                                                                                                                                                                                               
PROMPT Inserting PEMEMAIL Product/User Option                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'x_hcc_cre_user_option.sql' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  

SET TERM ON                                                                                                                                                                                                                                               
PROMPT Update existing available B defects status to NO ACTION                                                                                                                                                                                                                           
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'update_available_B.sql' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  
--                                                                                                                                                                                                                                                        
-----------------------------------  TRIGGERS  -----------------------------------------                                                                                                                                                                
--  
SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_ack_mail                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_ack_mail.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_auto_acknowledged                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_auto_acknowledged.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_auto_acknowledged_api                                                                                                                                                                                                                          
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_auto_acknowledged_api.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_dec_pre_row_trg                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_dec_pre_row_trg.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_dec_post_stm_trg                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_dec_post_stm_trg.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_def_status_pre_row_trg                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_def_status_pre_row_trg.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_def_status_post_stm_trg                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_def_status_post_stm_trg.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 

SET TERM ON                                                                                                                                                                                                                                               
PROMPT xhants_wo_hold                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT 'xhants_wo_hold.trg' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file' 
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
