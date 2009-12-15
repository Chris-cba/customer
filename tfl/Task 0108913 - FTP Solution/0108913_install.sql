
SPOOL 0108913_install.log

--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/Task 0108913 - FTP Solution/0108913_install.sql-arc   3.0   Dec 15 2009 10:06:46   aedwards  $
--       Module Name      : $Workfile:   0108913_install.sql  $
--       Date into PVCS   : $Date:   Dec 15 2009 10:06:46  $
--       Date fetched Out : $Modtime:   Dec 15 2009 10:03:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
PROMPT
PROMPT
PROMPT Exor Corporation
PROMPT 
PROMPT Transport For London
PROMPT Installation of Task 0108913 - FTP TMA Inspection Files
PROMPT 
PROMPT

UNDEFINE p_host_ip
UNDEFINE p_ftp_folder
UNDEFINE p_user
UNDEFINE p_pass
UNDEFINE p_port

ACCEPT p_host_ip     CHAR PROMPT 'ENTER THE IP ADDRESS OF THE FTP SITE       : ';
ACCEPT p_ftp_folder  CHAR PROMPT 'ENTER THE INCOMING FOLDER ON THE FTP SITE  : ';
ACCEPT p_user        CHAR PROMPT 'ENTER THE FTP USERNAME                     : ';
ACCEPT p_pass        CHAR PROMPT 'ENTER THE FTP PASSWORD                     : ' hide;
ACCEPT p_port        CHAR PROMPT 'ENTER THE FTP PORT NUMBER (USUALLY 21)     : ';

PROMPT
PROMPT Creating Metadata in X_TFL_FTP_DIRS
PROMPT
--
SET verify OFF;
SET feedback OFF;
SET serveroutput ON
--
DECLARE
--
  p_host_ip    VARCHAR2(100) := '&P_HOST_IP';
  p_ftp_folder VARCHAR2(100) := '&P_FTP_FOLDER';
  p_user       VARCHAR2(100) := '&P_USER';
  p_pass       VARCHAR2(100) := '&P_PASS';
  p_port       VARCHAR2(100) := '&P_PORT';
--
BEGIN
--
  INSERT INTO x_tfl_ftp_dirs
  ( ftp_type, ftp_contractor, ftp_username, ftp_password, ftp_host
  , ftp_arc_username, ftp_arc_password, ftp_arc_host, ftp_in_dir
  , ftp_out_dir, ftp_arc_in_dir, ftp_arc_out_dir, ftp_port, ftp_arc_port)
  VALUES 
   ('TMAI',NULL,p_user,p_pass,p_host_ip,NULL, NULL, NULL,p_ftp_folder
   ,NULL, NULL, NULL, p_port, p_port);
--
END;
/

SET verify ON;
SET feedback ON;

PROMPT Applying Packages
PROMPT

PROMPT x_tfl_tma_ftp.pkh
@x_tfl_tma_ftp.pkh

PROMPT x_tfl_tma_ftp.pkw
@x_tfl_tma_ftp.pkw

PROMPT nm3jobs.pkh
@nm3jobs.pkh

PROMPT nm3jobs.pkw
@nm3jobs.pkw

PROMPT Create Scheduled Job
@create_job.sql

PROMPT
PROMPT Installation of 0108913 Complete

SPOOL OFF
