create or replace package body xodot_signs_logging as

/*
 The contents of this document,including system ideas and concepts,
 are confidential and proprietary in nature and are not to be distributed 
 in any form without the prior written consent of Bentley Systems.
 
 file: xodot_signs_logging
 Author: JMM
 UPDATE01: Original,2015.03.12,JMM
 UPDATE02: Updated Column Size and moved xodot_execpt to the reports schema, 2015.05.06, JMM
*/

 procedure log_exception(s_ne_id varchar2,s_install_id varchar2,s_statehwy varchar2,n_mp number,s_error_type varchar2,s_sync_error varchar2) is
  reports.r_err xsign_except%rowtype;
  
  pragma autonomous_transaction;  -- will run independent of the calling program
  begin
   r_err.SYNC_DATE   := sysdate;
   r_err.session_id  := sys_context('userenv','SESSIONID');
   r_err.TI_USERNAME  := sys_context('userenv','SESSION_USER');
   r_err.OS_HOST   := sys_context('userenv','HOST');
   r_err.OS_USERNAME  := sys_context('userenv','OS_USER');
   r_err.NE_ID    := s_ne_id;
   r_err.INSTALLATION_ID := s_install_id;
   r_err.STATEHWY   := s_statehwy;
   r_err.MP    := n_mp;
   r_err.ERROR_TYPE  := s_error_type;
   r_err.SYNC_ERROR  := s_sync_error;
   
   insert into reports.xsign_except values r_err;
   commit;
 end log_exception;

 procedure log_status ( n_SFA_CNT number, n_SFA_EXP number, n_TI_CNT number,n_TI_EXCP number, n_LOV_CNT number, n_LOV_EXP number, n_MP100_CNT number, n_MP100_EXP number) is
  r_err reports.xsign_status%rowtype;  
  
  pragma autonomous_transaction;  -- will run independent of the calling program
  
  begin
   r_err.SYNC_DATE  := sysdate; 
   r_err.TI_USERNAME := sys_context('userenv','SESSION_USER'); 
   r_err.OS_HOST  := sys_context('userenv','HOST'); 
   r_err.OS_USERNAME := sys_context('userenv','OS_USER'); 
   r_err.SFA_CNT  := n_SFA_CNT; 
   r_err.SFA_EXP  := n_SFA_EXP;  
   r_err.TI_CNT  := n_TI_CNT; 
   r_err.TI_EXCP  := n_TI_EXCP; 
   r_err.LOV_CNT  := n_LOV_CNT; 
   r_err.LOV_EXP  := n_LOV_EXP; 
   r_err.MP100_CNT  := n_MP100_CNT;
   r_err.MP100_EXP  := n_MP100_EXP;
   
   insert into reports.xsign_status values r_err;
   commit;
 end log_status;                 
end xodot_signs_logging;
/