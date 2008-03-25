CREATE OR REPLACE PACKAGE BODY xnor_journals_interface AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor_journals_interface.pkb-arc   2.0   Mar 25 2008 10:50:28   smarshall  $
--       Module Name      : $Workfile:   xnor_journals_interface.pkb  $
--       Date into PVCS   : $Date:   Mar 25 2008 10:50:28  $
--       Date fetched Out : $Modtime:   Mar 25 2008 10:50:04  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--   xnor_journals_interface body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.0  $"';

  g_package_name CONSTANT varchar2(30) := 'xnor_journals_interface';
  
  c_filename     CONSTANT varchar2(255) := 'NCCGLJRNLHMS.dat';
  
  c_default_error_code         CONSTANT PLS_INTEGER := -20000;
  
  -----------
  --variables
  -----------
  g_grr_job_id gri_report_runs.grr_job_id%TYPE;
  
  g_debug_on BOOLEAN := FALSE;
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
PROCEDURE set_debug(pi_debug_on IN BOOLEAN DEFAULT TRUE
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_debug');

  IF pi_debug_on
  THEN
    g_debug_on := TRUE;
    nm_debug.debug_on;
  ELSE
    g_debug_on := FALSE;
    nm_debug.debug_off;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_debug');

END set_debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE db(pi_text IN varchar2
            ) IS
BEGIN
  IF g_debug_on
  THEN
    nm_debug.DEBUG(pi_text);
  END IF;
END db;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_error(pi_error_msg        IN varchar2
                   ,pi_fatal            IN BOOLEAN     DEFAULT FALSE
                   ,pi_fatal_error_code IN PLS_INTEGER DEFAULT c_default_error_code
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'log_error');

  dbms_output.enable(4000);
  dbms_output.put_line(pi_error_msg);
  
  IF g_grr_job_id IS NOT NULL
  THEN
    higgrirp.write_gri_spool(a_job_id  => g_grr_job_id
                            ,a_message => pi_error_msg);
  END IF;
  
  IF pi_fatal
  THEN
    raise_application_error(c_default_error_code, pi_error_msg);
  END IF;
  
                           
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'log_error');

END log_error;
--
-----------------------------------------------------------------------------
--
FUNCTION open_output_file(pi_file_path IN varchar2
                         ,pi_filename  IN varchar2
                         ) RETURN utl_file.file_type IS

  l_retval utl_file.file_type;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'open_output_file');
  
  --check if file already exists
  IF nm3file.file_exists(LOCATION => pi_file_path
                        ,filename => pi_filename) = 'Y'
  THEN
    log_error(pi_error_msg => 'File "' || pi_file_path || pi_filename || '" already exists.'
             ,pi_fatal     => TRUE);
  END IF;
  
  --open the file
  l_retval := nm3file.fopen(LOCATION  => pi_file_path
                           ,filename  => pi_filename
                           ,open_mode => nm3file.c_write_mode);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'open_output_file');

  RETURN l_retval;

END open_output_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_line_for_journal(pi_line   IN xnor_journal_lines.xjl_line%TYPE
                              ,pi_cr     IN xnor_journal_lines.xjl_line_cr%TYPE
                              ,pi_dr     IN xnor_journal_lines.xjl_line_dr%TYPE
                              ,pi_source IN xnor_journal_lines.xjl_extract_source%TYPE
                              ) IS
                              
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'log_line_for_journal');
  
  INSERT INTO
    xnor_journal_lines(xjl_line_seq
                      ,xjl_line
                      ,xjl_line_cr
                      ,xjl_line_dr
                      ,xjl_extract_source
                      ,xjl_extract_date
                      ,xjl_extract_user)
  VALUES(xjl_line_seq.NEXTVAL
        ,pi_line
        ,ABS(pi_cr)
        ,ABS(pi_dr)
        ,pi_source
        ,SYSDATE
        ,USER);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'log_line_for_journal');

END log_line_for_journal;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_journal_lines(pi_run_up_to_date IN     date
                           ,po_lines_arr         OUT t_lines_arr
                           ,po_cr_arr            OUT t_line_cr_arr 
                           ,po_dr_arr            OUT t_line_dr_arr 
                           ,po_rowid_arr         OUT t_rowid_arr
                           ) IS

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_journal_lines');

  SELECT
    xjl.xjl_line,
    xjl.xjl_line_cr,
    xjl.xjl_line_dr,
    xjl.rowid
  BULK COLLECT INTO
    po_lines_arr,
    po_cr_arr,
    po_dr_arr,
    po_rowid_arr
  FROM
    xnor_journal_lines xjl
  WHERE
    xjl.xjl_journal_output_date IS NULL
  AND
    (pi_run_up_to_date IS NULL
     OR
     xjl.xjl_extract_date <= pi_run_up_to_date)
  ORDER BY
    xjl.xjl_line_seq
  FOR UPDATE OF
    xjl.xjl_journal_output_date,
    xjl.xjl_journal_output_user
  NOWAIT;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_journal_lines');

END get_journal_lines;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_journal_file(pi_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                              ) RETURN varchar2 IS

  l_filename varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_commitment_file');
  
  g_grr_job_id := pi_grr_job_id;
  
  l_filename := generate_journal_file(pi_file_path      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                       ,a_param  => 'TEXT')
                                     ,pi_run_up_to_date => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                       ,a_param  => 'TO_DATE'));

  g_grr_job_id := NULL;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_commitment_file');

  RETURN l_filename;

END generate_journal_file;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_journal_file(pi_file_path      IN varchar2
                              ,pi_run_up_to_date IN date
                              ) RETURN varchar2 IS

  l_filename varchar2(255);
  
  l_lines_arr t_lines_arr;
  l_cr_arr    t_line_cr_arr;
  l_dr_arr    t_line_dr_arr;
  l_rowid_arr t_rowid_arr;
  
  l_lines_written_to_file PLS_INTEGER := 0;
  
  l_total_credits number := 0;
  l_total_debits  number := 0;
  
  l_file_id utl_file.file_type;
  
  PROCEDURE writeln(pi_text IN varchar2
                   ) IS
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,BUFFER => pi_text);
  
    l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_journal_file');
  
  db('pi_file_path = ' || pi_file_path);
  db('pi_run_up_to_date = ' || TO_CHAR(pi_run_up_to_date));
  
  get_journal_lines(pi_run_up_to_date => pi_run_up_to_date
                   ,po_lines_arr      => l_lines_arr
                   ,po_cr_arr         => l_cr_arr
                   ,po_dr_arr         => l_dr_arr
                   ,po_rowid_arr      => l_rowid_arr);

  db(l_lines_arr.COUNT || ' lines to output');

  IF l_lines_arr.COUNT > 0
  THEN
    l_filename := c_filename;
    
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => c_filename);
  
    --output the lines
    FOR i IN 1..l_lines_arr.COUNT
    LOOP
      db('loop ' || i);
      db('line =      = ' || l_lines_arr(i));
      
      writeln(l_lines_arr(i));
      
      l_total_credits := l_total_credits + l_cr_arr(i);
      l_total_debits  := l_total_debits + l_dr_arr(i);
    END LOOP;
    
    --record the time and user of this extract for each line
    db('updating xjl recs');
    FORALL i IN 1..l_rowid_arr.COUNT
      UPDATE
        xnor_journal_lines xjl
      SET
        xjl.xjl_journal_output_date = SYSDATE,
        xjl.xjl_journal_output_user = USER
      WHERE
        xjl.rowid = l_rowid_arr(i);
  
    db(SQL%ROWCOUNT || ' rows updated');
  
    ------------
    --close file
    ------------
    db('Closing file');
    nm3file.fclose(FILE => l_file_id);

    db('writing ctrl file');
    xnor_financial_interface.write_ctrl_file(pi_filename      => c_filename
                                            ,pi_filepath      => pi_file_path
                                            ,pi_total_lines   => l_lines_written_to_file
                                            ,pi_total_credits => l_total_credits
                                            ,pi_total_debits  => l_total_debits);
  
  ELSE
    --no lines to output
    log_error('No journal entries to extract.');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_journal_file');

  RETURN l_filename;

EXCEPTION
  WHEN others
  THEN
    db('when others: ' || SQLERRM);
    log_error(pi_error_msg => dbms_utility.format_error_stack
             ,pi_fatal     => TRUE);  

END generate_journal_file;
--
-----------------------------------------------------------------------------
--
END xnor_journals_interface;
/
