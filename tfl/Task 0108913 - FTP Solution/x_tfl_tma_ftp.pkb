CREATE OR REPLACE PACKAGE BODY x_tfl_tma_ftp
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/tfl/Task 0108913 - FTP Solution/x_tfl_tma_ftp.pkb-arc   3.1   Jun 04 2010 09:00:04   aedwards  $
--       Module Name      : $Workfile:   x_tfl_tma_ftp.pkb  $
--       Date into PVCS   : $Date:   Jun 04 2010 09:00:04  $
--       Date fetched Out : $Modtime:   Jun 04 2010 08:54:38  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT varchar2(2000) := '$Revision:   3.1  $';

  g_package_name   CONSTANT varchar2(30) := 'x_tfl_tma_ftp';

  c_dir_sep        CONSTANT VARCHAR2(200) := hig.get_user_or_sys_opt('DIRREPSTRN');
  b_is_unix                 BOOLEAN       := c_dir_sep = '/';

  l_in_dir                  VARCHAR2(30) := 'TMA_INSP_IMPORT_DIRECTORY';
  
  l_log_prefix_get          VARCHAR2(100) := 'get_inspection_files : ';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION does_directory_exist ( pi_directory_name IN VARCHAR2) RETURN BOOLEAN 
IS
  CURSOR c1 (cp_directory_name IN VARCHAR2) IS
  SELECT 'exists'
    FROM (SELECT 'x'
            FROM hig_directories
           WHERE hdir_name = cp_directory_name
             AND EXISTS
                   (SELECT 1
                      FROM all_directories
                     WHERE hdir_name = directory_name
                       AND hdir_path != '<to be specified>')
           UNION
          SELECT 'x'
            FROM all_directories
           WHERE directory_name = cp_directory_name
             AND directory_path != '<to be specified>');
  l_dummy VARCHAR2(10);
BEGIN
  OPEN c1 ( pi_directory_name );
  FETCH c1 INTO l_dummy;
  CLOSE c1;
  RETURN (l_dummy IS NOT NULL);
END does_directory_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xtfd (pi_ftp_type IN VARCHAR2) RETURN hig_ftp_connections%ROWTYPE
IS
  retval hig_ftp_connections%ROWTYPE;
BEGIN
  SELECT hig_ftp_connections.* INTO retval 
    FROM hig_ftp_connections, hig_ftp_types
   WHERE hft_type = pi_ftp_type
     AND hfc_hft_id = hft_id;
--
  RETURN retval;
--
END get_xtfd;
--
-----------------------------------------------------------------------------
--
FUNCTION next_tfl_id_seq RETURN NUMBER
  IS
    retval NUMBER;
  BEGIN
    SELECT xtfl_id_seq.nextval INTO retval FROM dual;
    RETURN retval;
  END next_tfl_id_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it (pi_text IN VARCHAR2) 
IS
  PRAGMA autonomous_transaction;
BEGIN
--
  INSERT INTO xtfl_ftp_log
       VALUES (next_tfl_id_seq
              ,sysdate
              ,substr(pi_text,0,4000)
              );
  COMMIT;
--
END log_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_inspection_files
           ( pi_ftp_type       IN VARCHAR2 DEFAULT g_ftp_type_get
           , pi_orcl_directory IN hig_directories.hdir_name%TYPE DEFAULT NULL
           , pi_delete_files   IN BOOLEAN DEFAULT TRUE)
IS
  l_rec_xtfd       hig_ftp_connections%ROWTYPE;
  l_conn           utl_tcp.connection;
  ftplist          nm3ftp.t_string_table;
  l_filename       nm3type.max_varchar2;
  l_count          NUMBER := 0;
  l_delete_count   NUMBER := 0;
  l_total          NUMBER := 0;
  l_directory      VARCHAR2(30) := NVL(pi_orcl_directory,l_in_dir);
  l_ftp_type       VARCHAR2(30) := NVL(pi_ftp_type,g_ftp_type_get);
--
  ex_no_directory  EXCEPTION;
--
BEGIN
--
  nm3ctx.set_context('NM3FTPPASSWORD','Y');
--
  log_it (l_log_prefix_get||'==============================================================');
  log_it (l_log_prefix_get||'Start TMA Inspection File Get Process started by '||USER|| ' at '||to_char(SYSDATE,'DD-MON-YYYY HH24:MI:SS'));
  log_it (l_log_prefix_get||'==============================================================');
--
  IF NOT does_directory_exist ( pi_directory_name => l_directory )
  THEN
    RAISE ex_no_directory;
  END IF;
  
-- Get FTP info
  l_rec_xtfd := get_xtfd ( pi_ftp_type => l_ftp_type );
--
  log_it (l_log_prefix_get||'Derived FTP connection details');
--
-- connection
  l_conn := nm3ftp.login( l_rec_xtfd.hfc_ftp_host
                        , l_rec_xtfd.hfc_ftp_port
                        , l_rec_xtfd.hfc_ftp_username
                        , nm3ftp.get_password(l_rec_xtfd.hfc_ftp_password));
--
  log_it (l_log_prefix_get||'Connected to FTP site [ '||l_rec_xtfd.hfc_ftp_host||':'
                                                      ||l_rec_xtfd.hfc_ftp_port||' ]');
-- set to ascii transfer
  nm3ftp.ascii(p_conn => l_conn);
--
-- list files in folder
  nm3ftp.list (p_conn  => l_conn,
               p_dir   => l_rec_xtfd.hfc_ftp_in_dir,
               p_list  => ftplist );
--
  l_total := ftplist.COUNT;
--
  log_it (l_log_prefix_get||'Listed '||l_total||' files for transfer');
--
-- go through the files
--
  IF l_total > 0
  THEN
  --
    FOR i IN 1..ftplist.COUNT 
    LOOP
      BEGIN
    --
        l_filename := ltrim(substr(ftplist(i), instr(ftplist(i),chr(32),-1,1),length(ftplist(i))));
    --
        nm3ftp.get
                    (p_conn      => l_conn,
                     p_from_file => l_rec_xtfd.hfc_ftp_in_dir||c_dir_sep||l_filename,
                     p_to_dir    => l_in_dir,
                     p_to_file   => l_filename);
    --
        log_it (l_log_prefix_get||'Downloaded '||l_filename||' to '||l_rec_xtfd.hfc_ftp_in_dir||c_dir_sep||l_filename);
        log_it (l_log_prefix_get||'File details :'||ftplist(i));
    --
        l_count := l_count + 1;
    --
--        nm_debug.debug('Put filename - '||l_filename);
--        nm_debug.debug('Put filename - '||ftplist(i));
    --
      EXCEPTION
        WHEN OTHERS
        THEN
          log_it (l_log_prefix_get||'Error :'||l_filename||' - '||SQLERRM);
      END;
    --
    END LOOP;
    -- close and clear connections
    nm3ftp.logout(l_conn);
  --
    utl_tcp.close_all_connections;
  --
    IF pi_delete_files
    THEN
    --
      DECLARE
        l_conn2       utl_tcp.connection;
        l_filename2   nm3type.max_varchar2;
      BEGIN
      --
        log_it (l_log_prefix_get||'==============================================================');
        log_it (l_log_prefix_get||'Deleting files from FTP site');
        log_it (l_log_prefix_get||'==============================================================');
        FOR d IN 1..ftplist.COUNT 
        LOOP
        --
          l_filename2 := ltrim(substr(ftplist(d), instr(ftplist(d),chr(32),-1,1),length(ftplist(d))));
        --
          BEGIN
            l_conn2 := nm3ftp.login( l_rec_xtfd.hfc_ftp_host
                                   , l_rec_xtfd.hfc_ftp_port
                                   , l_rec_xtfd.hfc_ftp_username
                                   , l_rec_xtfd.hfc_ftp_password);
            nm3ftp.delete(p_conn   => l_conn2,
                              p_file   => l_rec_xtfd.hfc_ftp_in_dir||c_dir_sep||l_filename2);
            l_delete_count := l_delete_count + 1;
          EXCEPTION
            WHEN OTHERS
            THEN
            -- close and clear connections
              nm3ftp.logout(l_conn2);
            --
              utl_tcp.close_all_connections;
              log_it (l_log_prefix_get||'Delete file error : '||l_filename2||' - '||SQLERRM);
              
          END;
        --
        END LOOP;
      --
        log_it (l_log_prefix_get||'Finished running deletion from FTP site');
      --
      EXCEPTION
        WHEN OTHERS
        THEN log_it (l_log_prefix_get||'Delete file error : '||l_filename2||' - '||SQLERRM);
      END;
    --
    END IF; 
  --
  END IF;
--
  log_it (l_log_prefix_get||'==============================================================');
  log_it (l_log_prefix_get||'Finish TMA Inspection File Get Process performed by '||USER||' at '||to_char(SYSDATE,'DD-MON-YYYY HH24:MI:SS'));
  log_it (l_log_prefix_get||'Total of '||l_count||' files out of '||l_total||' processed without error to directory '||l_in_dir );
  IF pi_delete_files
  THEN
    log_it (l_log_prefix_get||'Deleted '||l_delete_count||' files out of '||l_total||' from the FTP site');
  END IF;
  log_it (l_log_prefix_get||'==============================================================');
--
EXCEPTION
  WHEN TOO_MANY_ROWS
  THEN
  --
    log_it (l_log_prefix_get||'==============================================================');
    log_it (l_log_prefix_get||'FTP Metadata failure : '||l_ftp_type||' returns too many rows from hig_ftp_connections table');
    log_it (l_log_prefix_get||'==============================================================');
    utl_tcp.close_all_connections;
  WHEN ex_no_directory
  THEN
    --
    log_it (l_log_prefix_get||'==============================================================');
    log_it (l_log_prefix_get||'Oracle Directory failure : '||l_directory||' either does not exist or is not set correctly');
    log_it (l_log_prefix_get||'==============================================================');
    utl_tcp.close_all_connections;
  WHEN OTHERS
  THEN
    -- close and clear connections
    --nm3mcp_ftp.logout(l_conn);
    --
    utl_tcp.close_all_connections;
    --
    log_it (l_log_prefix_get||'==============================================================');
    log_it (l_log_prefix_get||'General failure : '||SQLERRM);
    log_it (l_log_prefix_get||'==============================================================');
--
END get_inspection_files;
--
-----------------------------------------------------------------------------
--
END x_tfl_tma_ftp;
/
