CREATE OR REPLACE PACKAGE BODY xnor_hops_gl_interface
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor_hops_gl_interface.pkb-arc   2.4   Mar 25 2008 10:46:46   smarshall  $
--       Module Name      : $Workfile:   xnor_hops_gl_interface.pkb  $
--       Date into PVCS   : $Date:   Mar 25 2008 10:46:46  $
--       Date fetched Out : $Modtime:   Mar 25 2008 08:29:44  $
--       PVCS Version     : $Revision:   2.4  $
--
--
--   Author : Kevin Angus
--
--   xnor_hops_gl_interface body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  -------
  --types
  -------
  TYPE t_commitment_data_rec IS RECORD(transaction_id   interface_wor.iwor_transaction_id%TYPE
                                      ,transaction_type interface_wor.iwor_transaction_type%TYPE
                                      ,works_order_no   interface_wor.iwor_works_order_no%TYPE
                                      ,wol_id           work_order_lines.wol_id%TYPE
                                      ,wol_cost         work_order_lines.wol_act_cost%TYPE
                                      ,road_id          interface_wol.iwol_road_id%TYPE
                                      ,cost_code        interface_wol.iwol_cost_code%TYPE
                                      ,wol_status_code  work_order_lines.wol_status_code%TYPE
                                      ,defect_id        work_order_lines.wol_def_defect_id%TYPE);
  TYPE t_commitment_data_arr IS TABLE OF t_commitment_data_rec INDEX BY PLS_INTEGER;

  TYPE t_payment_wols_rec    IS RECORD(wol_id                work_order_lines.wol_id%TYPE
                                      ,wor_coc_cost_centre   work_orders.wor_coc_cost_centre%TYPE
                                      ,wol_schd_id           work_order_lines.wol_schd_id%TYPE
                                      ,wol_def_defect_id     work_order_lines.wol_def_defect_id%TYPE
                                      ,wol_siss_id           work_order_lines.wol_siss_id%TYPE
                                      ,wor_job_number        work_orders.wor_job_number%TYPE
                                      ,rse_linkcode          road_segments_all.rse_linkcode%TYPE
                                      ,cp_woc_claim_ref      claim_payments.cp_woc_claim_ref%TYPE
                                      ,cp_claim_value        claim_payments.cp_claim_value%TYPE
                                      ,woc_claim_type        work_order_claims.woc_claim_type%TYPE
                                      ,wol_status_code       work_order_lines.wol_status_code%TYPE
                                      ,wor_act_cost          work_orders.wor_act_cost%TYPE
                                      ,wor_act_balancing_sum work_orders.wor_act_balancing_sum%TYPE);
  TYPE t_payment_wols_arr    IS TABLE OF t_payment_wols_rec INDEX BY PLS_INTEGER;
  
  TYPE t_payment_data_rec    IS RECORD(wol_id         work_order_lines.wol_id%TYPE
                                      ,wol_act_cost   work_order_lines.wol_act_cost%TYPE
                                      ,bud_cost_code  budgets.bud_cost_code%TYPE
                                      ,works_order_no work_order_lines.wol_works_order_no%TYPE
                                      ,defect_id      work_order_lines.wol_def_defect_id%TYPE);
  TYPE t_payment_data_arr    IS TABLE OF t_payment_data_rec INDEX BY PLS_INTEGER;
  
  TYPE t_trans_id_arr        IS TABLE OF interface_wor.iwor_transaction_id%TYPE INDEX BY PLS_INTEGER;
  
  ------------
  --exceptions
  ------------
  e_file_seq_exists EXCEPTION;
  
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.4  $"';

  g_package_name CONSTANT varchar2(30) := 'xnor_hops_gl_interface';
  
  c_file_type_commitment CONSTANT varchar2(2) := 'FI';
  c_file_type_payment    CONSTANT varchar2(2) := 'FC';
  
  c_seq_exists_error_msg CONSTANT varchar2(100) := 'Error: A file with this sequence number already exists.';
  
  c_default_error_code         CONSTANT PLS_INTEGER := -20000;
  
  c_user_jre_cat_name_order CONSTANT varchar2(30) := 'NCC HMS ORDERS';
  c_user_jre_cat_name_payment CONSTANT varchar2(30) := 'NCC HMS PAYMENTS';
  c_encumbrance_type_id    CONSTANT varchar2(4)  := '1041';
  c_actual_flag_estimate   CONSTANT varchar2(1)  := 'E';
  c_actual_flag_actual     CONSTANT varchar2(1)  := 'A';
  
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
FUNCTION get_commitment_data(pi_contractor_id  IN contracts.con_contr_org_id%TYPE
                            ,pi_financial_year IN budgets.bud_fyr_id%TYPE
                            ,pi_run_up_to_date IN date DEFAULT NULL
                            )RETURN t_commitment_data_arr IS

  l_commitment_data_arr t_commitment_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_commitment_data');

  nm_debug.DEBUG('get_commitment_data ' || pi_contractor_id || ':' || pi_financial_year || ':' || TO_CHAR(pi_run_up_to_date));
  
  SELECT
    MIN(iwor.iwor_transaction_id),
    iwor.iwor_transaction_type,
    iwor.iwor_works_order_no,
    iwol.iwol_id,
    SUM(iboq.iboq_cost) wol_est_cost,
    iwol.iwol_road_id,
    NVL(iwol.iwol_cost_code, bud.bud_cost_code),
    wol.wol_status_code,
    wol.wol_def_defect_id
  BULK COLLECT INTO
    l_commitment_data_arr
  FROM
    interface_wor    iwor,
    interface_wol    iwol,
    interface_boq    iboq,
    work_order_lines wol,
    contracts        con,
    budgets          bud
  WHERE
    iwor.iwor_fi_run_number IS NULL
  AND
    (pi_run_up_to_date IS NULL
     OR
     iwor_date_confirmed <= pi_run_up_to_date)
  AND
    con.con_contr_org_id = pi_contractor_id
  AND
    con.con_code = iwor.iwor_con_code
  AND
    iwor.iwor_transaction_id = iwol.iwol_transaction_id
  AND
    iwol.iwol_transaction_id = iboq.iboq_transaction_id (+)
  AND
    iwol.iwol_id = iboq.iboq_wol_id (+)
  AND
    wol.wol_id = iwol.iwol_id
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year
  GROUP BY
    iwol.iwol_id,
    iwor.iwor_transaction_id,
    iwor.iwor_transaction_type,
    iwor.iwor_works_order_no,
    iwol.iwol_road_id,
    iwol.iwol_cost_code,
    wol.wol_status_code,
    bud.bud_cost_code,
    wol.wol_def_defect_id
  ORDER BY
    iwol.iwol_id,
    iwor.iwor_transaction_id DESC;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_commitment_data');

  RETURN l_commitment_data_arr;

END get_commitment_data;
--
-----------------------------------------------------------------------------
--
-- Returns the next sequencial file number for a particular type of
-- file and for a particular contractor where applicable. This is
-- determined from the highest number used, as logged in the
-- Interface_Run_Log table. If a sequence number is supplied to the
-- function it verifies that a file with this number does not already
-- exist.
--
--  Copied from interface.pkb
--
FUNCTION file_seq( p_job_id IN number,
             p_contractor_id	IN varchar2
			,p_seq_no		IN number
			,p_file_type	IN varchar2) RETURN number IS

  CURSOR irl IS
    SELECT MAX(irl_run_number) + 1
    FROM   interface_run_log
    WHERE  NVL(irl_con_id, 'XXX') = NVL(p_contractor_id, 'XXX')
    AND    irl_file_type = p_file_type;

  CURSOR irl_exists IS
    SELECT 1
    FROM   interface_run_log
    WHERE  NVL(irl_con_id, 'XXX') = NVL(p_contractor_id, 'XXX')
    AND    irl_run_number = p_seq_no
    AND    irl_file_type = p_file_type;

  l_seq_no number;
  l_dummy  number(1);

BEGIN

  IF NVL(p_seq_no, -1) = -1 THEN  -- no seq no provided get default
    OPEN irl;
    FETCH irl INTO l_seq_no;
    CLOSE irl;
  ELSE
    OPEN irl_exists;
    FETCH irl_exists INTO l_dummy;
    IF irl_exists%FOUND AND p_file_type IN ('WO', 'FI', 'FD', 'FC') THEN -- a file with this seq no lready exists
      CLOSE irl_exists;
      RAISE e_file_seq_exists;
    ELSE
      CLOSE irl_exists;
      l_seq_no := p_seq_no;
    END IF;
  END IF;

  INSERT INTO interface_run_log
		( irl_file_type
		 ,irl_run_date
		 ,irl_run_number
		 ,irl_con_id
         ,irl_grr_job_id)
  VALUES    ( p_file_type
		 ,SYSDATE
		 ,NVL(l_seq_no, 1)
		 ,p_contractor_id
         ,p_job_id);

  COMMIT;

  RETURN NVL(l_seq_no, 1);
  
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_last_committed_cost(pi_transaction_id IN     interface_wol.iwol_transaction_id%TYPE
                                 ,pi_wol_id         IN     interface_wol.iwol_id%TYPE
                                 ,po_cost              OUT interface_boq.iboq_cost%TYPE
                                 ,po_cost_code         OUT interface_wol.iwol_cost_code%TYPE
                                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_last_committed_cost');
  
  SELECT
    wol_est_cost,
    cost_code
  INTO
    po_cost,
    po_cost_code
  FROM
    (SELECT
      SUM(iboq_cost) wol_est_cost,
      NVL(iwol_cost_code, bud.bud_cost_code) cost_code
    FROM
      interface_wor    iwor,
      interface_wol    iwol,
      interface_boq    iboq,
      work_order_lines wol,
      budgets          bud
    WHERE
      iwol.iwol_id = pi_wol_id
    AND
      (pi_transaction_id IS NULL
       OR iwol_transaction_id < pi_transaction_id)
    AND
      iwol.iwol_transaction_id = iboq.iboq_transaction_id (+)
    AND
      iwol.iwol_id = iboq.iboq_wol_id (+)
    AND
      iwor.iwor_transaction_id = iwol.iwol_transaction_id
    AND
      iwor.iwor_fi_run_number IS NOT NULL
    AND
      iwol.iwol_id = wol.wol_id
    AND
      wol.wol_bud_id = bud.bud_id
    GROUP BY
      iwol_transaction_id,
      iwol_cost_code,
      bud.bud_cost_code
    HAVING
      SUM(iboq_cost) <> 0
    ORDER BY
      iwol.iwol_transaction_id DESC)
  WHERE
    ROWNUM = 1;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_last_committed_cost');

EXCEPTION
  WHEN no_data_found
  THEN
    po_cost      := NULL;
    po_cost_code := NULL;

END get_last_committed_cost;
--
-----------------------------------------------------------------------------
--
FUNCTION get_line_description(pi_works_order_no IN work_orders.wor_works_order_no%TYPE
                             ,pi_wol_id         IN work_order_lines.wol_id%TYPE
                             ,pi_defect_id      IN work_order_lines.wol_def_defect_id%TYPE
                             ) RETURN varchar2 IS

  c_descr_sep CONSTANT varchar2(1) := '~';
  
  l_retval varchar2(4000);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_line_description');

  l_retval :=                   pi_works_order_no
              || c_descr_sep || pi_wol_id;

  IF pi_defect_id IS NOT NULL
  THEN
    l_retval := l_retval || c_descr_sep || pi_defect_id;
  END IF;
              
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_line_description');

  RETURN l_retval;

END get_line_description;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_file_name(pi_file_type         IN varchar2
                           ,pi_seq_no            IN PLS_INTEGER
                           ,pi_oun_contractor_id IN org_units.oun_contractor_id%TYPE
                           ) RETURN varchar2 IS

  l_filename varchar2(100);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_file_name');

  l_filename := pi_file_type || TO_CHAR(pi_seq_no) || TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS') || '.' || pi_oun_contractor_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_file_name');

  RETURN l_filename;

END generate_file_name;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_commitment_file(pi_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                                 ) RETURN varchar2 IS

  l_filename varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_commitment_file');
  
  g_grr_job_id := pi_grr_job_id;
  
  l_filename := generate_commitment_file(pi_seq_no         => NULL
                                        ,pi_contractor_id  => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                          ,a_param  => 'CONTRACTOR_ID')
                                        ,pi_financial_year => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                          ,a_param  => 'FINANCIAL_YEAR')
                                        ,pi_end_date       => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                          ,a_param  => 'TO_DATE')
                                        ,pi_file_path      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                          ,a_param  => 'TEXT')
                                        ,pi_period_13      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                                          ,a_param  => 'PERIOD_13') = 'Y');

  g_grr_job_id := NULL;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_commitment_file');

  RETURN l_filename;

END generate_commitment_file;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_commitment_file(pi_seq_no         IN interface_run_log.irl_run_number%TYPE
                                 ,pi_contractor_id  IN org_units.oun_org_id%TYPE
                                 ,pi_financial_year IN financial_years.fyr_id%TYPE
                                 ,pi_end_date       IN date
                                 ,pi_file_path      IN varchar2
                                 ,pi_period_13      IN BOOLEAN
                                 ) RETURN varchar2 IS

  c_seq_no   CONSTANT interface_run_log.irl_run_number%TYPE := file_seq(p_job_id        => g_grr_job_id
                                                                       ,p_contractor_id => pi_contractor_id
                                                                       ,p_seq_no        => pi_seq_no
                                                                       ,p_file_type     => c_file_type_commitment);
  
  c_filename CONSTANT varchar2(100) := generate_file_name(pi_file_type         => c_file_type_commitment
                                                         ,pi_seq_no            => pi_seq_no
                                                         ,pi_oun_contractor_id => interfaces.get_oun_id(p_contractor_id => pi_contractor_id));
  
  l_commitment_data_arr t_commitment_data_arr;
  
  l_output_date date;
  
  l_transactions_processed_arr t_trans_id_arr;

  l_file_id utl_file.file_type;
  
  l_line_descr varchar2(4000);
  
  l_last_wol_id work_order_lines.wol_id%TYPE := NULL;
  
  l_new_commitment    BOOLEAN;
  l_reversal_required BOOLEAN;
  
  l_last_sent_cost      interface_boq.iboq_cost%TYPE;
  l_last_sent_cost_code interface_wol.iwol_cost_code%TYPE;
  
  l_credit_cost_code interface_wol.iwol_cost_code%TYPE;
  l_debit_cost_code  interface_wol.iwol_cost_code%TYPE;
  
  l_lines_written_to_file PLS_INTEGER := 0;
  
  l_total_credits number := 0;
  l_total_debits  number := 0;
  
  PROCEDURE writeln(pi_text IN varchar2
                   ,pi_cost IN number
                   ) IS
  
    l_cr number;
    l_dr number;
  
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,BUFFER => pi_text);
  
    IF pi_cost > 0
    THEN
      l_dr := pi_cost;
      l_cr := 0;
    ELSE
      l_dr := 0;
      l_cr := pi_cost;
    END IF;
  
    xnor_journals_interface.log_line_for_journal(pi_line   => pi_text
                                                ,pi_cr     => l_cr
                                                ,pi_dr     => l_dr
                                                ,pi_source => xnor_financial_interface.c_line_source_hops_commitment);
  
    l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;
  
  PROCEDURE log_ctrl_data(pi_credit IN number DEFAULT 0
                         ,pi_debit  IN number DEFAULT 0
                         ) IS
  BEGIN    
    l_total_credits := l_total_credits + NVL(ABS(pi_credit), 0);
    
    l_total_debits  := l_total_debits + NVL(ABS(pi_debit), 0);
  
  END log_ctrl_data;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_commitment_file');

  nm_debug.DEBUG('main generate_commitment_file');
  
  l_commitment_data_arr := get_commitment_data(pi_contractor_id  => pi_contractor_id
                                              ,pi_financial_year => pi_financial_year
                                              ,pi_run_up_to_date => pi_end_date);

  nm_debug.DEBUG('got ' || l_commitment_data_arr.COUNT || ' rows to process' );

  IF l_commitment_data_arr.COUNT > 0
  THEN
    --which date do we use in the output file?
    l_output_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
    
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => c_filename);
  
    FOR i IN 1..l_commitment_data_arr.COUNT
    LOOP
      db('loop ' || i);
      db('last wol_id      = ' || l_last_wol_id);
      db('wol_id           = ' || l_commitment_data_arr(i).wol_id); 
      db('wol_cost         = ' || l_commitment_data_arr(i).wol_cost);
      db('works_order_no   = ' || l_commitment_data_arr(i).works_order_no);
      db('road_id          = ' || l_commitment_data_arr(i).road_id);
      db('cost_code        = ' || l_commitment_data_arr(i).cost_code);
      db('transaction_type = ' || l_commitment_data_arr(i).transaction_type);
      db('wol_status_code  = ' || l_commitment_data_arr(i).wol_status_code);
      
      --do we need to process this record?
      IF (l_last_wol_id IS NULL OR l_commitment_data_arr(i).wol_id <> l_last_wol_id)
        AND l_commitment_data_arr(i).wol_cost <> 0
        AND l_commitment_data_arr(i).wol_status_code <> xnor_financial_interface.c_wol_status_paid
      THEN
        --this wol neither zero cost nor already processed nor already paid...so process
      
        CASE
          l_commitment_data_arr(i).transaction_type
          
        WHEN 'C'
        THEN
          --'C'reated
          l_new_commitment    := TRUE;
          l_reversal_required := FALSE;
        
        WHEN 'A'
        THEN
          --'A'mendment
          l_new_commitment    := TRUE;
          l_reversal_required := TRUE;
        
        WHEN 'D'
        THEN
          --'D'eleted
          l_new_commitment    := FALSE;
          l_reversal_required := TRUE;
        
        ELSE
          raise_application_error(-20001, 'Unknown transaction type: ' || l_commitment_data_arr(i).transaction_type
                                          || ' for WOL ' || l_commitment_data_arr(i).wol_id);
        
        END CASE;
 
        --get description for file lines
        l_line_descr := get_line_description(pi_works_order_no => l_commitment_data_arr(i).works_order_no
                                            ,pi_wol_id         => l_commitment_data_arr(i).wol_id
                                            ,pi_defect_id      => l_commitment_data_arr(i).defect_id);  

        IF l_reversal_required
        THEN
          db('potential reversal required');
          --get last committed value
          get_last_committed_cost(pi_transaction_id => l_commitment_data_arr(i).transaction_id
                                 ,pi_wol_id         => l_commitment_data_arr(i).wol_id
                                 ,po_cost           => l_last_sent_cost
                                 ,po_cost_code      => l_last_sent_cost_code);
          
          IF l_last_sent_cost IS NOT NULL
          THEN
            IF l_last_sent_cost <> l_commitment_data_arr(i).wol_cost
              OR l_last_sent_cost_code <> l_commitment_data_arr(i).cost_code
            THEN
              db('found a previously sent value ' || l_last_sent_cost || ':' || l_last_sent_cost_code);
              l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_last_sent_cost_code
                                                                                                           ,p_number    => 1));
              l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_last_sent_cost_code
                                                                                                           ,p_number    => 3));
              
              --write reversal for last if nec
              writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                             ,pi_cost                  => l_last_sent_cost
                                                                             ,pi_descr                 => l_line_descr
                                                                             ,pi_cost_code             => l_debit_cost_code
                                                                             ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                             ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                             ,pi_actual_flag           => c_actual_flag_estimate
                                                                             ,pi_period_13             => pi_period_13
                                                                             ,pi_part_cost_code        => FALSE)
                     ,pi_cost => l_last_sent_cost);
              writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                             ,pi_cost                  => -l_last_sent_cost
                                                                             ,pi_descr                 => l_line_descr
                                                                             ,pi_cost_code             => l_credit_cost_code
                                                                             ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                             ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                             ,pi_actual_flag           => c_actual_flag_estimate
                                                                             ,pi_period_13             => pi_period_13
                                                                             ,pi_part_cost_code        => FALSE)
                     ,pi_cost => -l_last_sent_cost);
              

              log_ctrl_data(pi_credit => l_last_sent_cost
                           ,pi_debit  => l_last_sent_cost);
            ELSE
              --both new cost and cost code are same as last so neither reversal nor new commitment required
              l_new_commitment := FALSE;
            END IF;
          END IF;
        END IF;

        --write for this val
        IF l_new_commitment
        THEN
          db('New commitment value');
          l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_commitment_data_arr(i).cost_code
                                                                                                       ,p_number    => 3));
          l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_commitment_data_arr(i).cost_code
                                                                                                       ,p_number    => 1));
            
          --write reversal for last if nec
          writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                         ,pi_cost                  => l_commitment_data_arr(i).wol_cost
                                                                         ,pi_descr                 => l_line_descr
                                                                         ,pi_cost_code             => l_debit_cost_code
                                                                         ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                         ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                         ,pi_actual_flag           => c_actual_flag_estimate
                                                                         ,pi_period_13             => pi_period_13
                                                                         ,pi_part_cost_code        => FALSE)
                 ,pi_cost => l_commitment_data_arr(i).wol_cost);
          writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                         ,pi_cost                  => -l_commitment_data_arr(i).wol_cost
                                                                         ,pi_descr                 => l_line_descr
                                                                         ,pi_cost_code             => l_credit_cost_code
                                                                         ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                         ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                         ,pi_actual_flag           => c_actual_flag_estimate
                                                                         ,pi_period_13             => pi_period_13
                                                                         ,pi_part_cost_code        => FALSE)
                 ,pi_cost => -l_commitment_data_arr(i).wol_cost);
          
        
          log_ctrl_data(pi_credit => l_commitment_data_arr(i).wol_cost
                       ,pi_debit  => l_commitment_data_arr(i).wol_cost);
        END IF;
      
        l_last_wol_id := l_commitment_data_arr(i).wol_id;
      END IF;
      
      --record transaction id
      l_transactions_processed_arr(l_transactions_processed_arr.COUNT + 1) := l_commitment_data_arr(i).transaction_id;
    END LOOP;

    -------------------------------------
    --set these transactions as processed
    -------------------------------------
    db('setting run numer to ' || c_seq_no || ' for ' || l_transactions_processed_arr.COUNT || ' transactions');
    FORALL i IN 1..l_transactions_processed_arr.COUNT
      UPDATE
        interface_wor iwor
      SET
        iwor.iwor_fi_run_number = c_seq_no
      WHERE
        iwor.iwor_transaction_id = l_transactions_processed_arr(i);
  
    ------------
    --close file
    ------------
    db('Closing file');
    nm3file.fclose(FILE => l_file_id);

    xnor_financial_interface.write_ctrl_file(pi_filename      => c_filename
                                            ,pi_filepath      => pi_file_path
                                            ,pi_total_lines   => l_lines_written_to_file
                                            ,pi_total_credits => l_total_credits
                                            ,pi_total_debits  => l_total_debits);
  
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_commitment_file');

  RETURN c_filename;

EXCEPTION
  WHEN e_file_seq_exists
  THEN
    log_error(pi_error_msg => c_seq_exists_error_msg);
      
    RETURN NULL;
    
  WHEN others
  THEN
    log_error(pi_error_msg => SUBSTR(SQLERRM || dbms_utility.format_error_stack, 1, 255)
             ,pi_fatal     => TRUE);

END generate_commitment_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_file_data(pi_contractor_id  IN contracts.con_contr_org_id%TYPE
                              ,pi_cnp_id         IN claim_payments.cp_payment_id%TYPE
                              ,pi_financial_year IN     financial_years.fyr_id%TYPE
                              ,pi_start_date     IN     date
                              ,pi_end_date       IN     date
                              ) RETURN t_payment_data_arr IS

  l_retval t_payment_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_file_data');

  db('getting payment file data...');
  
  nm_debug.debug_sql_string('select count(*) wol_count from work_order_lines where wol_cnp_id = ' || pi_cnp_id);
  
  SELECT
    wol.wol_id,
    wol.wol_act_cost,
    bud.bud_cost_code,
    wol.wol_works_order_no,
    wol.wol_def_defect_id
  BULK COLLECT INTO
    l_retval
  FROM  org_units,
        contracts,
        work_order_claims,
        work_orders       wor,
        claim_payments,
        work_order_lines  wol,
        budgets           bud
  WHERE con_id = woc_con_id
    AND con_contr_org_id = oun_org_id
    AND wol_works_order_no = wor_works_order_no
    AND wol_works_order_no = woc_works_order_no
    AND woc_claim_ref = cp_woc_claim_ref
    AND woc_con_id = cp_woc_con_id
    AND wol_id = cp_wol_id
    AND wol_cnp_id = cp_payment_id
    AND wol_cnp_id = pi_cnp_id
    AND con_contr_org_id = pi_contractor_id
    AND wol_bud_id = bud_id
    AND
      wor.wor_date_confirmed BETWEEN pi_start_date AND pi_end_date
    AND
      bud.bud_fyr_id = pi_financial_year;

  db('got ' || l_retval.COUNT || ' rows.');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_file_data');

  RETURN l_retval;

END get_payment_file_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_payment_file(pi_contractor_id  IN     contracts.con_contr_org_id%TYPE
                               ,pi_cnp_id         IN     claim_payments.cp_payment_id%TYPE
                               ,pi_financial_year IN     financial_years.fyr_id%TYPE
                               ,pi_start_date     IN     date
                               ,pi_end_date       IN     date
                               ,pi_file_path      IN     varchar2
                               ,pi_period_13      IN     BOOLEAN
                               ,po_filename          OUT varchar2
                               ) IS

  c_seq_no   CONSTANT interface_run_log.irl_run_number%TYPE := file_seq(p_job_id        => g_grr_job_id
                                                                       ,p_contractor_id => pi_contractor_id
                                                                       ,p_seq_no        => NULL
                                                                       ,p_file_type     => c_file_type_payment);

  l_payment_data_arr t_payment_data_arr;
  
  l_file_id  utl_file.file_type;
  
  l_lines_written_to_file PLS_INTEGER := 0;

  l_total_credits number := 0;
  l_total_debits  number := 0;
  
  l_reversal_cost      interface_boq.iboq_cost%TYPE;
  l_reversal_cost_code interface_wol.iwol_cost_code%TYPE;
  
  l_credit_cost_code interface_wol.iwol_cost_code%TYPE;
  l_debit_cost_code  interface_wol.iwol_cost_code%TYPE;
  
  l_output_date date;
  
  l_line_descr varchar2(4000);
  
  PROCEDURE writeln(pi_text IN varchar2
                   ,pi_cost IN number
                   ) IS
  
    l_cr number;
    l_dr number;
  
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,BUFFER => pi_text);
  
    IF pi_cost > 0
    THEN
      l_dr := pi_cost;
      l_cr := 0;
    ELSE
      l_dr := 0;
      l_cr := pi_cost;
    END IF;
  
    xnor_journals_interface.log_line_for_journal(pi_line   => pi_text
                                                ,pi_cr     => l_cr
                                                ,pi_dr     => l_dr
                                                ,pi_source => xnor_financial_interface.c_line_source_hops_payment);
  
    l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;
  
  PROCEDURE log_ctrl_data(pi_credit IN number DEFAULT 0
                         ,pi_debit  IN number DEFAULT 0
                         ) IS
  BEGIN    
    l_total_credits := l_total_credits + NVL(pi_credit, 0);
    
    l_total_debits  := l_total_debits + NVL(pi_debit, 0);
  
  END log_ctrl_data;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_payment_file');

  db(g_package_name || '.generate_payment_file');
  db('  pi_contractor_id  = ' || pi_contractor_id);
  db('  pi_cnp_id         = ' || pi_cnp_id);
  db('  pi_financial_year = ' || pi_financial_year);
  db('  pi_start_date     = ' || TO_CHAR(pi_start_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_end_date       = ' || TO_CHAR(pi_end_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_file_path      = ' || pi_file_path);

  l_payment_data_arr := get_payment_file_data(pi_contractor_id  => pi_contractor_id
                                             ,pi_cnp_id         => pi_cnp_id
                                             ,pi_financial_year => pi_financial_year
                                             ,pi_start_date     => pi_start_date
                                             ,pi_end_date       => pi_end_date);

  IF l_payment_data_arr.COUNT > 0
  THEN
    po_filename := generate_file_name(pi_file_type         => c_file_type_payment
                                     ,pi_seq_no            => c_seq_no
                                     ,pi_oun_contractor_id => interfaces.get_oun_id(p_contractor_id => pi_contractor_id));
    
    db('which date do we use in the output file?');
    --which date do we use in the output file?
    l_output_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
    
    db('opening file ' || pi_file_path || ' ' || po_filename);
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => po_filename);
  
  
    FOR i IN 1..l_payment_data_arr.COUNT
    LOOP
      db('loop ' || i);
      db('wol_id           = ' || l_payment_data_arr(i).wol_id); 
      db('wol_act_cost         = ' || l_payment_data_arr(i).wol_act_cost);
      db('bud_cost_code        = ' || l_payment_data_arr(i).bud_cost_code);
      
      l_line_descr := get_line_description(pi_works_order_no => l_payment_data_arr(i).works_order_no
                                          ,pi_wol_id         => l_payment_data_arr(i).wol_id
                                          ,pi_defect_id      => l_payment_data_arr(i).defect_id);
      
      --------------------
      --reversal required?
      --------------------
      get_last_committed_cost(pi_transaction_id => NULL
                             ,pi_wol_id         => l_payment_data_arr(i).wol_id
                             ,po_cost           => l_reversal_cost
                             ,po_cost_code      => l_reversal_cost_code);
    
      IF l_reversal_cost IS NOT NULL
      THEN
        db('found a previously sent value ' || l_reversal_cost || ':' || l_reversal_cost_code);
        l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_reversal_cost_code
                                                                                                     ,p_number    => 1));
        l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_reversal_cost_code
                                                                                                     ,p_number    => 3));
              
        --write reversal for last if nec
        writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                       ,pi_cost                  => l_reversal_cost
                                                                       ,pi_descr                 => l_line_descr
                                                                       ,pi_cost_code             => l_debit_cost_code
                                                                       ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                       ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                       ,pi_actual_flag           => c_actual_flag_estimate
                                                                       ,pi_period_13             => pi_period_13
                                                                       ,pi_part_cost_code        => FALSE)
               ,pi_cost => l_reversal_cost);
        writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                       ,pi_cost                  => -l_reversal_cost
                                                                       ,pi_descr                 => l_line_descr
                                                                       ,pi_cost_code             => l_credit_cost_code
                                                                       ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                       ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                       ,pi_actual_flag           => c_actual_flag_estimate
                                                                       ,pi_period_13             => pi_period_13
                                                                       ,pi_part_cost_code        => FALSE)
               ,pi_cost => -l_reversal_cost);

        log_ctrl_data(pi_credit => l_reversal_cost
                     ,pi_debit  => l_reversal_cost);
      END IF;
      
      ---------------
      --payment lines
      ---------------
      IF l_payment_data_arr(i).wol_act_cost <> 0
      THEN
        db('writing payemnt lines');
        l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).bud_cost_code
                                                                                                     ,p_number    => 2));
        l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).bud_cost_code
                                                                                                     ,p_number    => 1));
                
        writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => l_payment_data_arr(i).wol_act_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_debit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_payment
                                                            ,pi_encumbrance_type_id   => NULL
                                                            ,pi_actual_flag           => c_actual_flag_actual
                                                            ,pi_period_13             => pi_period_13
                                                            ,pi_part_cost_code        => FALSE)
               ,pi_cost => l_payment_data_arr(i).wol_act_cost);
        writeln(pi_text => xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => -l_payment_data_arr(i).wol_act_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_credit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_payment
                                                            ,pi_encumbrance_type_id   => NULL
                                                            ,pi_actual_flag           => c_actual_flag_actual
                                                            ,pi_period_13             => pi_period_13
                                                            ,pi_part_cost_code        => FALSE)
               ,pi_cost => l_payment_data_arr(i).wol_act_cost);
        
        log_ctrl_data(pi_credit => l_payment_data_arr(i).wol_act_cost
                     ,pi_debit  => l_payment_data_arr(i).wol_act_cost);
      END IF;
    END LOOP;
  
    ------------
    --close file
    ------------
    db('Closing file');
    nm3file.fclose(FILE => l_file_id);

    xnor_financial_interface.write_ctrl_file(pi_filename      => po_filename
                                            ,pi_filepath      => pi_file_path
                                            ,pi_total_lines   => l_lines_written_to_file
                                            ,pi_total_credits => l_total_credits
                                            ,pi_total_debits  => l_total_debits);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_payment_file');

EXCEPTION
  WHEN e_file_seq_exists
  THEN
    log_error(pi_error_msg => c_seq_exists_error_msg);
    
  WHEN others
  THEN
    log_error(pi_error_msg => dbms_utility.format_error_stack
             ,pi_fatal     => TRUE);

END generate_payment_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_wols(pi_con_id         IN contracts.con_id%TYPE
                         ,pi_start_date     IN date
                         ,pi_end_date       IN date
                         ,pi_financial_year IN financial_years.fyr_id%TYPE
                         ) RETURN t_payment_wols_arr IS

  l_retval t_payment_wols_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_wols');

  db('getting payment wols...');
  db('pi_con_id = ' || pi_con_id);
  db('pi_start_date = ' || pi_start_date);
  db('pi_end_date = ' || pi_end_date);
  db('pi_financial_year = ' || pi_financial_year);
  
  SELECT wol_id
        ,wor_coc_cost_centre
        ,wol_schd_id
        ,wol_def_defect_id
        ,wol_siss_id
        ,wor_job_number
        ,rse_linkcode
        ,cp_woc_claim_ref
        ,cp_claim_value
        ,woc_claim_type
        ,wol_status_code
        ,NVL(wor_act_cost,0) wor_act_cost
        ,NVL(wor_act_balancing_sum,0) wor_act_balancing_sum
  BULK COLLECT INTO
    l_retval
  FROM   work_orders         wor
        ,work_order_lines    wol
        ,claim_payments
        ,work_order_claims
        ,road_segments_all
        ,contracts
        ,hig_status_codes
        ,budgets             bud
  WHERE  wor_con_id = con_id
  AND    con_id = pi_con_id
  AND    wor_works_order_no = wol_works_order_no
  AND    hsc_domain_code    = 'WORK_ORDER_LINES'
  AND    (hsc_allow_feature3 = 'Y' OR (hsc_allow_feature9 = 'Y' AND hsc_allow_feature4 = 'N'))
  AND    wol_status_code    = hsc_status_code
  AND    SYSDATE BETWEEN NVL(hsc_start_date, SYSDATE) AND NVL(hsc_end_date, SYSDATE)
  AND    wol_id = cp_wol_id
  AND    cp_payment_id IS NULL
  AND    EXISTS (SELECT 1
                 FROM hig_status_codes hsc
                 WHERE hsc.hsc_domain_code = 'CLAIM STATUS'
                 AND    hsc.hsc_allow_feature1 = 'Y'
                 AND    cp_status = hsc.hsc_status_code)
  AND    cp_woc_claim_ref = woc_claim_ref
  AND    cp_woc_con_id = woc_con_id
  AND    rse_he_id = wol_rse_he_id
  AND
    wor.wor_date_confirmed BETWEEN pi_start_date AND pi_end_date
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year;

  db('got ' || l_retval.COUNT || ' rows');
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_wols');

  RETURN l_retval;

END get_payment_wols;
--
-----------------------------------------------------------------------------
--
FUNCTION get_con(pi_contract_id contracts.con_id%TYPE
                ) RETURN contracts%ROWTYPE IS

  l_retval contracts%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_con');

  SELECT
    con.*
  INTO
    l_retval
  FROM
    contracts con
  WHERE
    con.con_id = pi_contract_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_con');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    log_error(pi_error_msg => 'Specified contract not found (contracts.con_id = ' || pi_contract_id || ')'
             ,pi_fatal     => TRUE);
  
  WHEN too_many_rows
  THEN
    log_error(pi_error_msg => 'Found more than one record on unique lookup contracts.con_id = ' || pi_contract_id
             ,pi_fatal     => TRUE);
  
END get_con;
--
-----------------------------------------------------------------------------
--
FUNCTION process_payment_run(pi_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                              ) RETURN varchar2 IS

  l_error_code hig_errors.her_no%TYPE;
  l_error_appl hig_errors.her_appl%TYPE;
  
  l_cnp_id work_order_lines.wol_cnp_id%TYPE;

  l_oun_org_id org_units.oun_org_id%TYPE;
  
  l_con_rec contracts%ROWTYPE;
  
  l_filename varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_payment_run');
  
  g_grr_job_id := pi_grr_job_id;  

  l_con_rec := get_con(pi_contract_id => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                     ,a_param  => 'CONTRACT_ID')); 
  
  process_payment_run(pi_con_id         => l_con_rec.con_id
                     ,pi_apply_vat      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'CONTRACT_ID') = 'Y'
                     ,pi_oun_ord_id     => l_con_rec.con_contr_org_id
                     ,pi_start_date     => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'FROM_DATE')
                     ,pi_end_date       => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'TO_DATE')
                     ,pi_financial_year => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'FINANCIAL_YEAR')
                     ,pi_file_path      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'TEXT')
                     ,pi_period_13      => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                       ,a_param  => 'PERIOD_13') = 'Y'
                     ,po_cnp_id         => l_cnp_id
                     ,po_error_code     => l_error_code
                     ,po_error_appl     => l_error_appl
                     ,po_filename       => l_filename); 
  
  IF l_error_code IS NOT NULL
  THEN
    log_error(pi_error_msg => l_error_appl || ': ' || l_error_code);
  END IF;
  
  g_grr_job_id := NULL;
  

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_payment_run');

  RETURN l_filename;

END process_payment_run;
--
-----------------------------------------------------------------------------
--
--Based on maiwo.process_payment_run
--
PROCEDURE process_payment_run(pi_con_id         IN     contracts.con_id%TYPE
                             ,pi_apply_vat      IN     BOOLEAN
                             ,pi_oun_ord_id     IN     org_units.oun_org_id%TYPE
                             ,pi_start_date     IN     date
                             ,pi_end_date       IN     date
                             ,pi_financial_year IN     financial_years.fyr_id%TYPE
                             ,pi_file_path      IN     varchar2
                             ,pi_period_13      IN     BOOLEAN
                             ,po_cnp_id            OUT work_order_lines.wol_cnp_id%TYPE
                             ,po_error_code        OUT hig_errors.her_no%TYPE
                             ,po_error_appl        OUT hig_errors.her_appl%TYPE
                             ,po_filename          OUT varchar2
                             ) IS
   
  contract_is_locked EXCEPTION;
  PRAGMA EXCEPTION_INIT ( contract_is_locked,-0054 );
  
  payment_seq_missing EXCEPTION;
  PRAGMA EXCEPTION_INIT ( payment_seq_missing,-2289);
  
  no_items_for_payment EXCEPTION;
  credit_file_error EXCEPTION;

  v_rechar             org_units.oun_org_id%TYPE;
  v_payment_code       work_order_lines.wol_payment_code%TYPE;
  v_cost_code          contracts.con_cost_code%TYPE;
  v_total_value        contract_payments.cnp_total_value%TYPE:=0;
  v_cnp_id             contract_payments.cnp_id%TYPE:=0;
  v_payment_no         contract_payments.cnp_first_payment_no%TYPE:=0;
  v_first_payment      contract_payments.cnp_first_payment_no%TYPE:=0;
  v_retention_rate     contracts.con_retention_rate%TYPE:=0;
  v_retention_amount   contracts.con_retention_to_date%TYPE:=0;
  v_vat_rate           vat_rates.vat_rate%TYPE:=0;
  v_vat_amount         contract_payments.cnp_vat_amount%TYPE:=0;
  v_cnp_amount         contract_payments.cnp_amount%TYPE:=0;
  v_last_run_date      date;
  v_retention_to_date  contracts.con_retention_to_date%TYPE:=0;
  v_max_retention      contracts.con_max_retention%TYPE:=0;
  v_use_interfaces     org_units.oun_electronic_orders_flag%TYPE;
  v_functional_act     char(1);
  v_payment_value      number(11,2);
  l_previous_payment   claim_payments.cp_claim_value%TYPE := 0;
  l_file               varchar2(255);
  v_same_year          char(1);
  l_inv_status         work_order_lines.wol_invoice_status%TYPE;
  l_paid_status        work_order_lines.wol_status_code%TYPE;
  l_part_paid_status   work_order_lines.wol_status_code%TYPE;
  l_claim_paid_status  hig_status_codes.hsc_status_code%TYPE;
  dummy                number;

  l_payment_wols_arr t_payment_wols_arr;

  CURSOR c_elec_interface (v_con_id contracts.con_id%TYPE) IS
     SELECT oun_electronic_orders_flag
     FROM   contracts, org_units
     WHERE  con_id = v_con_id
     AND    con_contr_org_id = oun_org_id;

  CURSOR c_next_payment IS
     SELECT cnp_id_seq.NEXTVAL
     FROM   dual;

  CURSOR c_last_payment_details (v_con_id contracts.con_id%TYPE) IS
     SELECT NVL(con_last_payment_no,0)
           ,NVL(con_retention_rate,0)
           ,NVL(con_cost_code,' ')
     FROM    contracts
     WHERE   con_id = v_con_id;

  CURSOR c_first_payment_details(v_con_id contracts.con_id%TYPE) IS
    SELECT MIN(cnp_first_payment_no)
    FROM   contract_payments
    WHERE  cnp_con_id = v_con_id;

  CURSOR c_get_rechar (v_defect defects.def_defect_id%TYPE) IS
     SELECT def_rechar_org_id
     FROM   defects
     WHERE  def_defect_id = v_defect;

  CURSOR c_retention_to_date (v_con_id contracts.con_id%TYPE) IS
     SELECT con_retention_to_date, con_max_retention
     FROM   contracts
     WHERE  con_id = v_con_id;

  CURSOR c_vat_rate IS
     SELECT vat_rate
     FROM   vat_rates
     WHERE  vat_effective_date = (SELECT MAX(vat_effective_date)
                                  FROM vat_rates
                                  WHERE vat_effective_date <= SYSDATE)
     AND    vat_effective_date <= SYSDATE;

  CURSOR c_last_run_date (v_con_id contracts.con_id%TYPE) IS
     SELECT MAX(cnp_run_date)
     FROM   contract_payments
     WHERE  cnp_con_id = v_con_id;

  CURSOR c_run_this_year(v_last_run_date date) IS
     SELECT 'Y'
     FROM   financial_years
     WHERE  v_last_run_date > fyr_start_date
     AND    v_last_run_date < fyr_end_date
     AND    SYSDATE > fyr_start_date
     AND    SYSDATE < fyr_end_date;

  CURSOR wol_paid_status IS
     SELECT hsc_status_code
     FROM   hig_status_codes
     WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
     AND    hsc_allow_feature4 = 'Y' AND hsc_allow_feature9 = 'N';

  CURSOR wol_part_paid_status IS
     SELECT hsc_status_code
     FROM   hig_status_codes
     WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
     AND    hsc_allow_feature4 = 'Y'
     AND    hsc_allow_feature9 = 'Y';

  CURSOR is_complete(c_code IN hig_status_codes.hsc_status_code%TYPE) IS
     SELECT 1
     FROM   hig_status_codes
     WHERE  hsc_allow_feature3 = 'Y'
     AND    hsc_domain_code = 'WORK_ORDER_LINES'
     AND    hsc_status_code = c_code;

  CURSOR claim_paid_status IS
     SELECT hsc_status_code
     FROM   hig_status_codes
     WHERE  hsc_domain_code = 'CLAIM STATUS'
     AND    hsc_allow_feature3 = 'Y';


BEGIN
  db('***process payment run');
  db('pi_con_id = ' || pi_con_id);
  db('pi_oun_ord_id = ' || pi_oun_ord_id);
  db('pi_start_date = ' || pi_start_date);
  db('pi_end_date = ' || pi_end_date);
  db('pi_financial_year = ' || pi_financial_year);
  db('pi_file_path = ' || pi_file_path);

  --
  dbms_output.put_line('PRE_RUN_SQL entry, Obtaining Contract Id');
  --
  -- Procedure log entry conrols the locking of the contract
  --
  dbms_output.put_line('Obtaining items for payment');
  --

  OPEN c_elec_interface(pi_con_id);
  FETCH c_elec_interface INTO v_use_interfaces;
  CLOSE c_elec_interface;

  dbms_output.put_line('Contract locked');
  --
  -- do not close the cursor we want to keep the lock on the contract right through the procedure!
  --
  dbms_output.put_line('Obtaining new payment id from sequence');
  --
  OPEN c_next_payment;
  FETCH c_next_payment INTO v_cnp_id;
  CLOSE c_next_payment;

  dbms_output.put_line('Got next payment id');
  --
  dbms_output.put_line('CNP    : '||TO_CHAR(v_cnp_id)||' Con: '||TO_CHAR(pi_con_id));
  --
  OPEN c_last_payment_details (pi_con_id);
  FETCH c_last_payment_details INTO v_payment_no, v_retention_rate, v_cost_code;
  CLOSE c_last_payment_details;

  OPEN c_first_payment_details(pi_con_id);
  FETCH c_first_payment_details INTO v_first_payment;
  CLOSE c_first_payment_details;

  IF v_first_payment IS NULL THEN
     v_first_payment := v_cnp_id;
  END IF;

  dbms_output.put_line('Obtaining work order lines for contract : '||TO_CHAR(pi_con_id));

  OPEN wol_paid_status;
  FETCH wol_paid_status INTO l_paid_status;
  CLOSE wol_paid_status;

  OPEN wol_part_paid_status;
  FETCH wol_part_paid_status INTO l_part_paid_status;
  CLOSE wol_part_paid_status;

  OPEN claim_paid_status;
  FETCH claim_paid_status INTO l_claim_paid_status;
  CLOSE claim_paid_status;

  dbms_output.put_line('Setting Work Order lines to PAID');
  dbms_output.put_line('Updating Work Order Lines');
  --
  
  l_payment_wols_arr := get_payment_wols(pi_con_id         => pi_con_id
                                        ,pi_start_date     => pi_start_date
                                        ,pi_end_date       => pi_end_date
                                        ,pi_financial_year => pi_financial_year);
  
  FOR i IN 1..l_payment_wols_arr.COUNT
  LOOP
    db('processing wol ' || l_payment_wols_arr(i).wol_id);
    
    IF l_payment_wols_arr(i).woc_claim_type IN ('I', 'F') AND
       maiwo.final_already_paid(l_payment_wols_arr(i).wol_id) = 'TRUE' THEN

         NULL; -- don't process an Interim or Final invoice
                 -- if a final has already been paid

    ELSE

     IF l_payment_wols_arr(i).wol_def_defect_id IS NOT NULL THEN
        OPEN c_get_rechar (l_payment_wols_arr(i).wol_def_defect_id);
        FETCH c_get_rechar INTO v_rechar;
        CLOSE c_get_rechar;
     END IF;

     IF v_rechar IS NULL THEN
        v_functional_act := '3';
     ELSE
        v_functional_act := '4';
     END IF;
     v_rechar := NULL;

     v_payment_code := RPAD(NVL(l_payment_wols_arr(i).wor_coc_cost_centre,' '),3)||
                       v_functional_act||
                       RPAD(NVL(l_payment_wols_arr(i).wol_siss_id,' '),3)||
                       RPAD(v_cost_code,4)||
                       RPAD(NVL(l_payment_wols_arr(i).wor_job_number,' '),5)||
                       RPAD(SUBSTR(NVL(l_payment_wols_arr(i).rse_linkcode,' '),1,1),1);

 -- do not need this call as it is the extra to pay that is
 -- sent to claim_payments and not the total cost.

 --      if l_payment_wols_arr(i).woc_claim_type != 'P' then
 --        l_previous_payment := maiwo.previous_payment(l_payment_wols_arr(i).wol_id, l_payment_wols_arr(i).cp_woc_claim_ref);
 --      end if;

     UPDATE work_order_lines
     SET    wol_payment_code = v_payment_code,
            wol_cnp_id = v_cnp_id
     WHERE  wol_id = l_payment_wols_arr(i).wol_id;

     SELECT DECODE(l_payment_wols_arr(i).woc_claim_type, l_claim_paid_status,
            l_payment_wols_arr(i).cp_claim_value,
            cp_claim_value - l_previous_payment)
     INTO   v_payment_value
     FROM   claim_payments
     WHERE  cp_wol_id = l_payment_wols_arr(i).wol_id
     AND    cp_woc_claim_ref = l_payment_wols_arr(i).cp_woc_claim_ref
     AND    cp_woc_con_id = pi_con_id;

     -- apply discount if there is one
     IF (l_payment_wols_arr(i).wor_act_balancing_sum != 0 AND l_payment_wols_arr(i).wor_act_cost != 0) THEN
       v_payment_value := v_payment_value + v_payment_value * (l_payment_wols_arr(i).wor_act_balancing_sum / l_payment_wols_arr(i).wor_act_cost);
     END IF;

     UPDATE claim_payments
     SET    cp_payment_date = SYSDATE
           ,cp_payment_id = v_cnp_id
           ,cp_status = l_claim_paid_status
           ,cp_payment_value = v_payment_value
     WHERE  cp_wol_id = l_payment_wols_arr(i).wol_id
     AND    cp_woc_claim_ref = l_payment_wols_arr(i).cp_woc_claim_ref
     AND    cp_woc_con_id = pi_con_id;

     -- update the interim_payments table in case the wol has interim payments
     UPDATE wol_interim_payments
     SET    wip_status = 'P'
           ,wip_date   = SYSDATE
     WHERE  wip_wol_id = l_payment_wols_arr(i).wol_id;

     v_total_value := v_total_value + NVL(v_payment_value, 0);

     l_inv_status := maiwo.wol_invoice_status(l_payment_wols_arr(i).wol_id);

     OPEN is_complete(l_payment_wols_arr(i).wol_status_code);
     FETCH is_complete INTO dummy;
     IF is_complete%FOUND THEN

       CLOSE is_complete;
       UPDATE work_order_lines
       SET    wol_invoice_status = l_inv_status,
              wol_status_code = l_paid_status,
              wol_date_paid = SYSDATE
       WHERE  wol_id =  l_payment_wols_arr(i).wol_id;
     ELSE
       CLOSE is_complete;
       UPDATE work_order_lines
       SET    wol_invoice_status = l_inv_status,
              wol_status_code = l_part_paid_status
       WHERE  wol_id =  l_payment_wols_arr(i).wol_id;
     END IF;

   END IF;

  END LOOP;
  --
  dbms_output.put_line('Work Order Lines Updated');
  --
  v_retention_amount := ROUND((v_total_value * v_retention_rate / 100),2);
  --
  dbms_output.put_line('Obtaining Contract Extentions');
  --
  OPEN c_retention_to_date(pi_con_id);
  FETCH c_retention_to_date INTO v_retention_to_date, v_max_retention;
  CLOSE c_retention_to_date;
  --
  dbms_output.put_line('Contract Retentions Obtained');
  --
  IF v_retention_amount + v_retention_to_date >= v_max_retention THEN
     dbms_output.put_line('Recalculating retention rate');
     v_retention_rate :=
     ROUND (((v_max_retention - v_retention_to_date)/NVL(v_total_value,1))*100,2);
     v_retention_amount := ROUND((v_total_value * v_retention_rate / 100),2);
  END IF;

  IF pi_apply_vat
  THEN
     dbms_output.put_line('Obtaining VAT rate');
     OPEN c_vat_rate;
     FETCH c_vat_rate INTO v_vat_rate;
     CLOSE c_vat_rate;

     v_vat_amount := ROUND(((v_total_value - v_retention_amount) * v_vat_rate / 100),2);
  ELSE
     v_vat_amount := 0.00;
  END IF;
  v_cnp_amount := (v_total_value - v_retention_amount + v_vat_amount);
  --
  dbms_output.put_line('Inserting into Contract Payments'||TO_CHAR(v_total_value)||' total ');
  --

  INSERT INTO contract_payments
     (cnp_id, cnp_con_id, cnp_run_date, cnp_username,
      cnp_first_payment_no, cnp_last_payment_no, cnp_total_value,
      cnp_retention_amount, cnp_vat_amount, cnp_amount)
     VALUES
     (v_cnp_id, pi_con_id, SYSDATE, USER,
      v_first_payment, v_payment_no, v_total_value,
      v_retention_amount, v_vat_amount, v_cnp_amount);

  IF v_use_interfaces = 'Y'
  THEN
    BEGIN
      generate_payment_file(pi_contractor_id  => pi_oun_ord_id
                           ,pi_cnp_id         => v_cnp_id
                           ,pi_financial_year => pi_financial_year
                           ,pi_start_date     => pi_start_date
                           ,pi_end_date       => pi_end_date
                           ,pi_file_path      => pi_file_path
                           ,pi_period_13      => pi_period_13
                           ,po_filename       => po_filename);
    EXCEPTION
      WHEN others THEN
        RAISE credit_file_error;
    END;

  END IF;

  OPEN c_last_run_date(pi_con_id);
  FETCH c_last_run_date INTO v_last_run_date;
  CLOSE c_last_run_date;


  IF v_last_run_date IS NOT NULL THEN

     OPEN c_run_this_year(v_last_run_date);
     FETCH c_run_this_year INTO v_same_year;
     CLOSE c_run_this_year;

  END IF;

-- from post
  dbms_output.put_line('Updating contract');

  IF v_same_year = 'Y' THEN
     UPDATE contracts
     SET con_spend_to_date = NVL(con_spend_to_date,0) + v_total_value,
         con_spend_ytd = NVL(con_spend_ytd,0) + v_total_value,
         con_last_payment_no = v_cnp_id
     WHERE con_id = pi_con_id;
  ELSE
     UPDATE contracts
     SET con_spend_to_date = NVL(con_spend_to_date,0) + v_total_value,
         con_spend_ytd = v_total_value,
         con_last_payment_no = v_cnp_id
     WHERE con_id = pi_con_id;
  END IF;

  IF v_retention_amount + v_retention_to_date >= v_max_retention THEN
    UPDATE contracts
    SET    con_retention_to_date = NVL(v_max_retention,0)
    WHERE  con_id = pi_con_id;
  ELSE
    UPDATE contracts
    SET    con_retention_to_date = NVL(v_retention_to_date,0) + NVL(v_retention_amount,0)
    WHERE  con_id = pi_con_id;
  END IF;

  dbms_output.put_line('Transaction Completed and Committed');

 -- got to here O.K return cnp_id for reports and TRUE
  po_cnp_id     := v_cnp_id;
  po_error_code := NULL;
  po_error_appl := NULL;
 
EXCEPTION
  WHEN contract_is_locked
  THEN
    po_cnp_id     := NULL;
    po_error_code := 885;
    po_error_appl := 'M_MGR';

  WHEN payment_seq_missing
  THEN
    po_cnp_id     := NULL;
    po_error_code := 83;
    po_error_appl := 'HWAYS';

  WHEN no_items_for_payment
  THEN
    po_cnp_id     := NULL;
    po_error_code := 887;
    po_error_appl := 'M_MGR';

  WHEN credit_file_error
  THEN
    po_cnp_id     := NULL;
    po_error_code := 888; -- other problem
    po_error_appl := 'M_MGR';

  WHEN dup_val_on_index THEN
    po_cnp_id     := NULL;
    po_error_code := 885;
    po_error_appl := 'M_MGR';

  WHEN others
  THEN
    po_cnp_id     := NULL;
    po_error_code := 888; -- other problem
    po_error_appl := 'M_MGR';

END;
--
-----------------------------------------------------------------------------
--
END xnor_hops_gl_interface;
/
