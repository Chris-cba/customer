
SPOOL 0109724_install.log

--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/tfl/Task 0109724 - FTP Solution 4210/0109724_install.sql-arc   3.0   Sep 20 2010 10:46:48   Ade.Edwards  $
--       Module Name      : $Workfile:   0109724_install.sql  $
--       Date into PVCS   : $Date:   Sep 20 2010 10:46:48  $
--       Date fetched Out : $Modtime:   Sep 20 2010 10:28:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
PROMPT
PROMPT
PROMPT Exor Corporation
PROMPT 
PROMPT Transport For London
PROMPT Installation of Task 0109724 - FTP TMA Inspection Files 4210
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
PROMPT Creating Metadata in HIG_FTP_CONNECTIONS
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
  l_hft_id     NUMBER        := nm3ddl.sequence_nextval('hft_id_seq');
  l_hfc_id     NUMBER        := nm3ddl.sequence_nextval('hfc_id_seq');
--
BEGIN
--
--  INSERT INTO x_tfl_ftp_dirs
--  ( ftp_type, ftp_contractor, ftp_username, ftp_password, ftp_host
--  , ftp_arc_username, ftp_arc_password, ftp_arc_host, ftp_in_dir
--  , ftp_out_dir, ftp_arc_in_dir, ftp_arc_out_dir, ftp_port, ftp_arc_port)
--  VALUES 
--   ('TMAI',NULL,p_user,p_pass,p_host_ip,NULL, NULL, NULL,p_ftp_folder
--   ,NULL, NULL, NULL, p_port, p_port);
--
  INSERT INTO hig_ftp_types
    ( hft_id, hft_type, hft_descr)
  SELECT 
    l_hft_id, 'TMAI','TMA Inspection Files'
   FROM DUAL;
--
  INSERT INTO hig_ftp_connections
   ( hfc_id, hfc_hft_id, hfc_name, hfc_nau_admin_unit, hfc_nau_unit_code
   , hfc_nau_admin_type, hfc_ftp_username, hfc_ftp_password, hfc_ftp_host
   , hfc_ftp_port, hfc_ftp_in_dir, hfc_ftp_out_dir)
  SELECT
     l_hfc_id, l_hft_id, 'TMA_FTP',NULL, NULL
   , NULL, p_user, nm3ftp.obfuscate_password( p_pass ), p_host_ip
   , p_port, p_ftp_folder, NULL 
    FROM DUAL;
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

PROMPT Create Scheduled Job
@create_job.sql

PROMPT
PROMPT Installation of 0109724 Complete

SPOOL OFF
