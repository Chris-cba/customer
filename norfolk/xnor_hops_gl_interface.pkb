CREATE OR REPLACE PACKAGE BODY xnor_hops_gl_interface
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor_hops_gl_interface.pkb-arc   2.2   Oct 15 2007 16:08:50   smarshall  $
--       Module Name      : $Workfile:   xnor_hops_gl_interface.pkb  $
--       Date into PVCS   : $Date:   Oct 15 2007 16:08:50  $
--       Date fetched Out : $Modtime:   Oct 15 2007 15:48:04  $
--       PVCS Version     : $Revision:   2.2  $
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
  TYPE t_commitment_data_rec IS RECORD(transaction_id   interface_wor.iwor_transaction_id%type
                                      ,transaction_type interface_wor.iwor_transaction_type%type
                                      ,works_order_no   interface_wor.iwor_works_order_no%TYPE
                                      ,wol_id           work_order_lines.wol_id%TYPE
                                      ,wol_cost         work_order_lines.wol_act_cost%TYPE
                                      ,road_id          interface_wol.iwol_road_id%type
                                      ,cost_code        interface_wol.iwol_cost_code%TYPE
                                      ,wol_status_code  work_order_lines.wol_status_code%type
                                      ,defect_id        work_order_lines.wol_def_defect_id%type);
  TYPE t_commitment_data_arr IS TABLE OF t_commitment_data_rec INDEX BY pls_integer;

  type t_payment_wols_rec    is record(wol_id                work_order_lines.wol_id%TYPE
                                      ,wor_coc_cost_centre   work_orders.wor_coc_cost_centre%type
                                      ,wol_schd_id           work_order_lines.wol_schd_id%TYPE
                                      ,wol_def_defect_id     work_order_lines.wol_def_defect_id%TYPE
                                      ,wol_siss_id           work_order_lines.wol_siss_id%TYPE
                                      ,wor_job_number        work_orders.wor_job_number%type
                                      ,rse_linkcode          road_segments_all.rse_linkcode%type
                                      ,cp_woc_claim_ref      claim_payments.cp_woc_claim_ref%type
                                      ,cp_claim_value        claim_payments.cp_claim_value%type
                                      ,woc_claim_type        work_order_claims.woc_claim_type%type
                                      ,wol_status_code       work_order_lines.wol_status_code%TYPE
                                      ,wor_act_cost          work_orders.wor_act_cost%type
                                      ,wor_act_balancing_sum work_orders.wor_act_balancing_sum%type);
  type t_payment_wols_arr    is table of t_payment_wols_rec INDEX BY pls_integer;
  
  type t_payment_data_rec    is record(wol_id         work_order_lines.wol_id%TYPE
                                      ,wol_act_cost   work_order_lines.wol_act_cost%TYPE
                                      ,bud_cost_code  budgets.bud_cost_code%TYPE
                                      ,works_order_no work_order_lines.wol_works_order_no%TYPE
                                      ,defect_id      work_order_lines.wol_def_defect_id%type);
  type t_payment_data_arr    is table of t_payment_data_rec INDEX BY pls_integer;
  
  type t_trans_id_arr        is table of interface_wor.iwor_transaction_id%type INDEX BY pls_integer;
  
  ------------
  --exceptions
  ------------
  e_file_seq_exists exception;
  
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.2  $"';

  g_package_name CONSTANT varchar2(30) := 'xnor_hops_gl_interface';
  
  c_file_type_commitment constant varchar2(2) := 'FI';
  c_file_type_payment    constant varchar2(2) := 'FC';
  
  c_seq_exists_error_msg constant varchar2(100) := 'Error: A file with this sequence number already exists.';
  
  c_default_error_code         CONSTANT pls_integer := -20000;
  
  c_user_jre_cat_name_order constant varchar2(30) := 'NCC HMS ORDERS';
  c_user_jre_cat_name_payment constant varchar2(30) := 'NCC HMS PAYMENTS';
  c_encumbrance_type_id    constant varchar2(4)  := '1041';
  c_actual_flag_estimate   constant varchar2(1)  := 'E';
  c_actual_flag_actual     constant varchar2(1)  := 'A';
  
  -----------
  --variables
  -----------
  g_grr_job_id gri_report_runs.grr_job_id%type;
  
  g_debug_on boolean := FALSE;
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
                   ,pi_fatal            IN boolean     DEFAULT FALSE
                   ,pi_fatal_error_code IN pls_integer DEFAULT c_default_error_code
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'log_error');

  DBMS_OUTPUT.ENABLE(4000);
  DBMS_OUTPUT.PUT_LINE(pi_error_msg);
  
  IF g_grr_job_id IS NOT NULL
  THEN
    higgrirp.write_gri_spool(a_job_id  => g_grr_job_id
                            ,a_message => pi_error_msg);
  END IF;
  
  IF pi_fatal
  THEN
    RAISE_APPLICATION_ERROR(c_default_error_code, pi_error_msg);
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
FUNCTION get_commitment_data(pi_contractor_id  in contracts.con_contr_org_id%type
                            ,pi_financial_year in budgets.bud_fyr_id%type
                            ,pi_run_up_to_date in date default Null
                            )RETURN t_commitment_data_arr IS

  l_commitment_data_arr t_commitment_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_commitment_data');

  nm_debug.debug('get_commitment_data ' || pi_contractor_id || ':' || pi_financial_year || ':' || to_char(pi_run_up_to_date));
  
  SELECT
    min(iwor.iwor_transaction_id),
    iwor.iwor_transaction_type,
    iwor.iwor_works_order_no,
    iwol.iwol_id,
    SUM(iboq.iboq_cost) wol_est_cost,
    iwol.iwol_road_id,
    nvl(iwol.iwol_cost_code, bud.bud_cost_code),
    wol.wol_status_code,
    wol.wol_def_defect_id
  bulk collect into
    l_commitment_data_arr
  from
    interface_wor    iwor,
    interface_wol    iwol,
    interface_boq    iboq,
    work_order_lines wol,
    contracts        con,
    budgets          bud
  where
    iwor.iwor_fi_run_number IS null
  and
    (pi_run_up_to_date IS NULL
     OR
     iwor_date_confirmed <= pi_run_up_to_date)
  and
    con.con_contr_org_id = pi_contractor_id
  and
    con.con_code = iwor.iwor_con_code
  and
    iwor.iwor_transaction_id = iwol.iwol_transaction_id
  and
    iwol.iwol_transaction_id = iboq.iboq_transaction_id (+)
  and
    iwol.iwol_id = iboq.iboq_wol_id (+)
  and
    wol.wol_id = iwol.iwol_id
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year
  group by
    iwol.iwol_id,
    iwor.iwor_transaction_id,
    iwor.iwor_transaction_type,
    iwor.iwor_works_order_no,
    iwol.iwol_road_id,
    iwol.iwol_cost_code,
    wol.wol_status_code,
    bud.bud_cost_code,
    wol.wol_def_defect_id
  order by
    iwol.iwol_id,
    iwor.iwor_transaction_id desc;

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
procedure get_last_committed_cost(pi_transaction_id in     interface_wol.iwol_transaction_id%type
                                 ,pi_wol_id         in     interface_wol.iwol_id%type
                                 ,po_cost              out interface_boq.iboq_cost%type
                                 ,po_cost_code         out interface_wol.iwol_cost_code%type
                                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_last_committed_cost');
  
  select
    wol_est_cost,
    cost_code
  into
    po_cost,
    po_cost_code
  from
    (SELECT
      SUM(iboq_cost) wol_est_cost,
      NVL(iwol_cost_code, bud.bud_cost_code) cost_code
    from
      interface_wor    iwor,
      interface_wol    iwol,
      interface_boq    iboq,
      work_order_lines wol,
      budgets          bud
    where
      iwol.iwol_id = pi_wol_id
    and
      (pi_transaction_id is null
       OR iwol_transaction_id < pi_transaction_id)
    AND
      iwol.iwol_transaction_id = iboq.iboq_transaction_id (+)
    AND
      iwol.iwol_id = iboq.iboq_wol_id (+)
    and
      iwor.iwor_transaction_id = iwol.iwol_transaction_id
    and
      iwor.iwor_fi_run_number IS NOT NULL
    and
      iwol.iwol_id = wol.wol_id
    and
      wol.wol_bud_id = bud.bud_id
    group by
      iwol_transaction_id,
      iwol_cost_code,
      bud.bud_cost_code
    having
      SUM(iboq_cost) <> 0
    order by
      iwol.iwol_transaction_id desc)
  where
    rownum = 1;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_last_committed_cost');

exception
  when no_data_found
  then
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
FUNCTION generate_file_name(pi_file_type         in varchar2
                           ,pi_seq_no            in pls_integer
                           ,pi_oun_contractor_id in org_units.oun_contractor_id%type
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
function generate_commitment_file(pi_grr_job_id IN gri_report_runs.grr_job_id%TYPE
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

  return l_filename;

END generate_commitment_file;
--
-----------------------------------------------------------------------------
--
function generate_commitment_file(pi_seq_no         in interface_run_log.irl_run_number%type
                                 ,pi_contractor_id  IN org_units.oun_org_id%TYPE
                                 ,pi_financial_year IN financial_years.fyr_id%TYPE
                                 ,pi_end_date       IN date
                                 ,pi_file_path      IN varchar2
                                 ,pi_period_13      in boolean
                                 ) RETURN varchar2 IS

  c_seq_no   constant interface_run_log.irl_run_number%type := file_seq(p_job_id        => g_grr_job_id
                                                                       ,p_contractor_id => pi_contractor_id
                                                                       ,p_seq_no        => pi_seq_no
                                                                       ,p_file_type     => c_file_type_commitment);
  
  c_filename constant varchar2(100) := generate_file_name(pi_file_type         => c_file_type_commitment
                                                         ,pi_seq_no            => pi_seq_no
                                                         ,pi_oun_contractor_id => interfaces.get_oun_id(p_contractor_id => pi_contractor_id));
  
  l_commitment_data_arr t_commitment_data_arr;
  
  l_output_date date;
  
  l_transactions_processed_arr t_trans_id_arr;

  l_file_id utl_file.file_type;
  
  l_line_descr varchar2(4000);
  
  l_last_wol_id work_order_lines.wol_id%TYPE := NULL;
  
  l_new_commitment    boolean;
  l_reversal_required boolean;
  
  l_last_sent_cost      interface_boq.iboq_cost%type;
  l_last_sent_cost_code interface_wol.iwol_cost_code%type;
  
  l_credit_cost_code interface_wol.iwol_cost_code%type;
  l_debit_cost_code  interface_wol.iwol_cost_code%type;
  
  l_lines_written_to_file pls_integer := 0;
  
  l_total_credits number := 0;
  l_total_debits  number := 0;
  
  PROCEDURE writeln(pi_text IN varchar2
                   ) IS
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,buffer => pi_text);
  
    l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;
  
  PROCEDURE log_ctrl_data(pi_credit in number DEFAULT 0
                         ,pi_debit  in number DEFAULT 0
                         ) is
  begin    
    l_total_credits := l_total_credits + nvl(abs(pi_credit), 0);
    
    l_total_debits  := l_total_debits + NVL(abs(pi_debit), 0);
  
  end log_ctrl_data;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_commitment_file');

  nm_debug.debug('main generate_commitment_file');
  
  l_commitment_data_arr := get_commitment_data(pi_contractor_id  => pi_contractor_id
                                              ,pi_financial_year => pi_financial_year
                                              ,pi_run_up_to_date => pi_end_date);

  nm_debug.debug('got ' || l_commitment_data_arr.count || ' rows to process' );

  if l_commitment_data_arr.count > 0
  then
    --which date do we use in the output file?
    l_output_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
    
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => c_filename);
  
    for i in 1..l_commitment_data_arr.count
    loop
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
      IF (l_last_wol_id IS NULL or l_commitment_data_arr(i).wol_id <> l_last_wol_id)
        AND l_commitment_data_arr(i).wol_cost <> 0
        and l_commitment_data_arr(i).wol_status_code <> xnor_financial_interface.c_wol_status_paid
      then
        --this wol neither zero cost nor already processed nor already paid...so process
      
        case
          l_commitment_data_arr(i).transaction_type
          
        when 'C'
        then
          --'C'reated
          l_new_commitment    := TRUE;
          l_reversal_required := FALSE;
        
        WHEN 'A'
        then
          --'A'mendment
          l_new_commitment    := TRUE;
          l_reversal_required := TRUE;
        
        WHEN 'D'
        then
          --'D'eleted
          l_new_commitment    := FALSE;
          l_reversal_required := true;
        
        ELSE
          raise_application_error(-20001, 'Unknown transaction type: ' || l_commitment_data_arr(i).transaction_type
                                          || ' for WOL ' || l_commitment_data_arr(i).wol_id);
        
        end case;
 
        --get description for file lines
        l_line_descr := get_line_description(pi_works_order_no => l_commitment_data_arr(i).works_order_no
                                            ,pi_wol_id         => l_commitment_data_arr(i).wol_id
                                            ,pi_defect_id      => l_commitment_data_arr(i).defect_id);  

        if l_reversal_required
        then
          db('potential reversal required');
          --get last committed value
          get_last_committed_cost(pi_transaction_id => l_commitment_data_arr(i).transaction_id
                                 ,pi_wol_id         => l_commitment_data_arr(i).wol_id
                                 ,po_cost           => l_last_sent_cost
                                 ,po_cost_code      => l_last_sent_cost_code);
          
          if l_last_sent_cost IS not NULL
          then
            IF l_last_sent_cost <> l_commitment_data_arr(i).wol_cost
              or l_last_sent_cost_code <> l_commitment_data_arr(i).cost_code
            then
              db('found a previously sent value ' || l_last_sent_cost || ':' || l_last_sent_cost_code);
              l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_last_sent_cost_code
                                                                                                           ,p_number    => 1));
              l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_last_sent_cost_code
                                                                                                           ,p_number    => 3));
              
              --write reversal for last if nec
              writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                  ,pi_cost                  => l_last_sent_cost
                                                                  ,pi_descr                 => l_line_descr
                                                                  ,pi_cost_code             => l_debit_cost_code
                                                                  ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                  ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                  ,pi_actual_flag           => c_actual_flag_estimate
                                                                  ,pi_part_cost_code        => FALSE));
              writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                                  ,pi_cost                  => -l_last_sent_cost
                                                                  ,pi_descr                 => l_line_descr
                                                                  ,pi_cost_code             => l_credit_cost_code
                                                                  ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                                  ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                  ,pi_actual_flag           => c_actual_flag_estimate
                                                                  ,pi_part_cost_code        => FALSE));
              

              log_ctrl_data(pi_credit => l_last_sent_cost
                           ,pi_debit  => l_last_sent_cost);
            else
              --both new cost and cost code are same as last so neither reversal nor new commitment required
              l_new_commitment := FALSE;
            end if;
          end if;
        end if;

        --write for this val
        if l_new_commitment
        then
          db('New commitment value');
          l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_commitment_data_arr(i).cost_code
                                                                                                       ,p_number    => 3));
          l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_commitment_data_arr(i).cost_code
                                                                                                       ,p_number    => 1));
            
          --write reversal for last if nec
          writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                              ,pi_cost                  => l_commitment_data_arr(i).wol_cost
                                                              ,pi_descr                 => l_line_descr
                                                              ,pi_cost_code             => l_debit_cost_code
                                                              ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                              ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                              ,pi_actual_flag           => c_actual_flag_estimate
                                                              ,pi_part_cost_code        => FALSE));
          writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                              ,pi_cost                  => -l_commitment_data_arr(i).wol_cost
                                                              ,pi_descr                 => l_line_descr
                                                              ,pi_cost_code             => l_credit_cost_code
                                                              ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                              ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                              ,pi_actual_flag           => c_actual_flag_estimate
                                                              ,pi_part_cost_code        => FALSE));
          
        
          log_ctrl_data(pi_credit => l_commitment_data_arr(i).wol_cost
                       ,pi_debit  => l_commitment_data_arr(i).wol_cost);
        END IF;
      
        l_last_wol_id := l_commitment_data_arr(i).wol_id;
      end if;
      
      --record transaction id
      l_transactions_processed_arr(l_transactions_processed_arr.count + 1) := l_commitment_data_arr(i).transaction_id;
    end loop;

    -------------------------------------
    --set these transactions as processed
    -------------------------------------
    db('setting run numer to ' || c_seq_no || ' for ' || l_transactions_processed_arr.count || ' transactions');
    forall i in 1..l_transactions_processed_arr.count
      update
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
  
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_commitment_file');

  RETURN c_filename;

exception
  WHEN e_file_seq_exists
  THEN
    log_error(pi_error_msg => c_seq_exists_error_msg);
      
    RETURN NULL;
    
  WHEN others
  THEN
    log_error(pi_error_msg => dbms_utility.format_error_stack
             ,pi_fatal     => TRUE);

END generate_commitment_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_file_data(pi_contractor_id  in contracts.con_contr_org_id%type
                              ,pi_cnp_id         in claim_payments.cp_payment_id%type
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
  bulk collect into
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

  db('got ' || l_retval.count || ' rows.');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_file_data');

  RETURN l_retval;

END get_payment_file_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_payment_file(pi_contractor_id  IN     contracts.con_contr_org_id%type
                               ,pi_cnp_id         in     claim_payments.cp_payment_id%type
                               ,pi_financial_year IN     financial_years.fyr_id%TYPE
                               ,pi_start_date     IN     date
                               ,pi_end_date       IN     date
                               ,pi_file_path      IN     varchar2
                               ,pi_period_13      in     boolean
                               ,po_filename          OUT varchar2
                               ) IS

  c_seq_no   constant interface_run_log.irl_run_number%type := file_seq(p_job_id        => g_grr_job_id
                                                                       ,p_contractor_id => pi_contractor_id
                                                                       ,p_seq_no        => NULL
                                                                       ,p_file_type     => c_file_type_payment);
  
  c_filename constant varchar2(100) := generate_file_name(pi_file_type         => c_file_type_payment
                                                         ,pi_seq_no            => c_seq_no
                                                         ,pi_oun_contractor_id => interfaces.get_oun_id(p_contractor_id => pi_contractor_id));  
  
  l_payment_data_arr t_payment_data_arr;
  
  l_file_id  utl_file.file_type;
  
  l_lines_written_to_file pls_integer := 0;

  l_total_credits number := 0;
  l_total_debits  number := 0;
  
  l_reversal_cost      interface_boq.iboq_cost%type;
  l_reversal_cost_code interface_wol.iwol_cost_code%type;
  
  l_credit_cost_code interface_wol.iwol_cost_code%type;
  l_debit_cost_code  interface_wol.iwol_cost_code%type;
  
  l_output_date date;
  
  l_line_descr varchar2(4000);
  
  PROCEDURE writeln(pi_text IN varchar2
                       ) IS
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,buffer => pi_text);
  
    l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;
  
  PROCEDURE log_ctrl_data(pi_credit in number DEFAULT 0
                         ,pi_debit  in number DEFAULT 0
                         ) is
  begin    
    l_total_credits := l_total_credits + nvl(pi_credit, 0);
    
    l_total_debits  := l_total_debits + NVL(pi_debit, 0);
  
  end log_ctrl_data;

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

  if l_payment_data_arr.count > 0
  then
    db('which date do we use in the output file?');
    --which date do we use in the output file?
    l_output_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
    
    db('opening file ' || pi_file_path || ' ' || c_filename);
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => c_filename);
  
  
    for i in 1..l_payment_data_arr.count
    loop
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
    
      if l_reversal_cost is not null
      then
        db('found a previously sent value ' || l_reversal_cost || ':' || l_reversal_cost_code);
        l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_reversal_cost_code
                                                                                                     ,p_number    => 1));
        l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_reversal_cost_code
                                                                                                     ,p_number    => 3));
              
        --write reversal for last if nec
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => l_reversal_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_debit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                            ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                            ,pi_actual_flag           => c_actual_flag_estimate
                                                            ,pi_part_cost_code        => FALSE));
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => -l_reversal_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_credit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_order
                                                            ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                            ,pi_actual_flag           => c_actual_flag_estimate
                                                            ,pi_part_cost_code        => FALSE));
            
        log_ctrl_data(pi_credit => l_reversal_cost
                     ,pi_debit  => l_reversal_cost);
      end if;
      
      ---------------
      --payment lines
      ---------------
      IF l_payment_data_arr(i).wol_act_cost <> 0
      then
        db('writing payemnt lines');
        l_credit_cost_code := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).bud_cost_code
                                                                                                     ,p_number    => 2));
        l_debit_cost_code  := interfaces.reformat_cost_code(p_cost_code => interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).bud_cost_code
                                                                                                     ,p_number    => 1));
                
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => l_payment_data_arr(i).wol_act_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_debit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_payment
                                                            ,pi_encumbrance_type_id   => NULL
                                                            ,pi_actual_flag           => c_actual_flag_actual
                                                            ,pi_part_cost_code        => FALSE));
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_output_date
                                                            ,pi_cost                  => -l_payment_data_arr(i).wol_act_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_credit_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_cat_name_payment
                                                            ,pi_encumbrance_type_id   => NULL
                                                            ,pi_actual_flag           => c_actual_flag_actual
                                                            ,pi_part_cost_code        => FALSE));      
        
        log_ctrl_data(pi_credit => l_payment_data_arr(i).wol_act_cost
                     ,pi_debit  => l_payment_data_arr(i).wol_act_cost);
      END IF;
    end loop;
  
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
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_payment_file');

exception
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
FUNCTION get_payment_wols(pi_con_id         in contracts.con_id%type
                         ,pi_start_date     in date
                         ,pi_end_date       in date
                         ,pi_financial_year in financial_years.fyr_id%TYPE
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
  
  select wol_id
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
        ,nvl(wor_act_cost,0) wor_act_cost
        ,nvl(wor_act_balancing_sum,0) wor_act_balancing_sum
  bulk collect into
    l_retval
  from   work_orders         wor
        ,work_order_lines    wol
        ,claim_payments
        ,work_order_claims
        ,road_segments_all
        ,contracts
        ,hig_status_codes
        ,budgets             bud
  where  wor_con_id = con_id
  and    con_id = pi_con_id
  and    wor_works_order_no = wol_works_order_no
  and    hsc_domain_code    = 'WORK_ORDER_LINES'
  and    (hsc_allow_feature3 = 'Y' or (hsc_allow_feature9 = 'Y' and hsc_allow_feature4 = 'N'))
  and    wol_status_code    = hsc_status_code
  and    sysdate between nvl(hsc_start_date, sysdate) and nvl(hsc_end_date, sysdate)
  and    wol_id = cp_wol_id
  and    cp_payment_id is null
  and    exists (select 1
                 from hig_status_codes hsc
                 where hsc.hsc_domain_code = 'CLAIM STATUS'
                 and    hsc.hsc_allow_feature1 = 'Y'
                 and    cp_status = hsc.hsc_status_code)
  and    cp_woc_claim_ref = woc_claim_ref
  and    cp_woc_con_id = woc_con_id
  and    rse_he_id = wol_rse_he_id
  AND
    wor.wor_date_confirmed BETWEEN pi_start_date AND pi_end_date
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year;

  db('got ' || l_retval.count || ' rows');
  
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
                              ) return varchar2 IS

  l_error_code hig_errors.her_no%type;
  l_error_appl hig_errors.her_appl%type;
  
  l_cnp_id work_order_lines.wol_cnp_id%type;

  l_oun_org_id org_units.oun_org_id%type;
  
  l_con_rec contracts%rowtype;
  
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
  
  if l_error_code is not null
  then
    log_error(pi_error_msg => l_error_appl || ': ' || l_error_code);
  end if;
  
  g_grr_job_id := NULL;
  

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_payment_run');

  return l_filename;

END process_payment_run;
--
-----------------------------------------------------------------------------
--
--Based on maiwo.process_payment_run
--
PROCEDURE process_payment_run(pi_con_id         in     contracts.con_id%type
                             ,pi_apply_vat      in     boolean
                             ,pi_oun_ord_id     in     org_units.oun_org_id%type
                             ,pi_start_date     in     date
                             ,pi_end_date       in     date
                             ,pi_financial_year in     financial_years.fyr_id%TYPE
                             ,pi_file_path      in     varchar2
                             ,pi_period_13      in     boolean
                             ,po_cnp_id            out work_order_lines.wol_cnp_id%type
                             ,po_error_code        out hig_errors.her_no%type
                             ,po_error_appl        out hig_errors.her_appl%type
                             ,po_filename          out varchar2
                             ) is
   
  contract_is_locked exception;
  pragma exception_init ( contract_is_locked,-0054 );
  
  payment_seq_missing exception;
  pragma exception_init ( payment_seq_missing,-2289);
  
  no_items_for_payment exception;
  credit_file_error exception;

  v_rechar             org_units.oun_org_id%type;
  v_payment_code       work_order_lines.wol_payment_code%type;
  v_cost_code          contracts.con_cost_code%type;
  v_total_value        contract_payments.cnp_total_value%type:=0;
  v_cnp_id             contract_payments.cnp_id%type:=0;
  v_payment_no         contract_payments.cnp_first_payment_no%type:=0;
  v_first_payment      contract_payments.cnp_first_payment_no%type:=0;
  v_retention_rate     contracts.con_retention_rate%type:=0;
  v_retention_amount   contracts.con_retention_to_date%type:=0;
  v_vat_rate           vat_rates.vat_rate%type:=0;
  v_vat_amount         contract_payments.cnp_vat_amount%type:=0;
  v_cnp_amount         contract_payments.cnp_amount%type:=0;
  v_last_run_date      date;
  v_retention_to_date  contracts.con_retention_to_date%type:=0;
  v_max_retention      contracts.con_max_retention%type:=0;
  v_use_interfaces     org_units.oun_electronic_orders_flag%type;
  v_functional_act     char(1);
  v_payment_value      number(11,2);
  l_previous_payment   claim_payments.cp_claim_value%type := 0;
  l_file               varchar2(255);
  v_same_year          char(1);
  l_inv_status         work_order_lines.wol_invoice_status%type;
  l_paid_status        work_order_lines.wol_status_code%type;
  l_part_paid_status   work_order_lines.wol_status_code%type;
  l_claim_paid_status  hig_status_codes.hsc_status_code%type;
  dummy                number;

  l_payment_wols_arr t_payment_wols_arr;

  cursor c_elec_interface (v_con_id contracts.con_id%type) is
     select oun_electronic_orders_flag
     from   contracts, org_units
     where  con_id = v_con_id
     and    con_contr_org_id = oun_org_id;

  cursor c_next_payment is
     select cnp_id_seq.nextval
     from   dual;

  cursor c_last_payment_details (v_con_id contracts.con_id%type) is
     select nvl(con_last_payment_no,0)
           ,nvl(con_retention_rate,0)
           ,nvl(con_cost_code,' ')
     from    contracts
     where   con_id = v_con_id;

  cursor c_first_payment_details(v_con_id contracts.con_id%type) is
    select min(cnp_first_payment_no)
    from   contract_payments
    where  cnp_con_id = v_con_id;

  cursor c_get_rechar (v_defect defects.def_defect_id%type) is
     select def_rechar_org_id
     from   defects
     where  def_defect_id = v_defect;

  cursor c_retention_to_date (v_con_id contracts.con_id%type) is
     select con_retention_to_date, con_max_retention
     from   contracts
     where  con_id = v_con_id;

  cursor c_vat_rate is
     select vat_rate
     from   vat_rates
     where  vat_effective_date = (select max(vat_effective_date)
                                  from vat_rates
                                  where vat_effective_date <= sysdate)
     and    vat_effective_date <= sysdate;

  cursor c_last_run_date (v_con_id contracts.con_id%type) is
     select max(cnp_run_date)
     from   contract_payments
     where  cnp_con_id = v_con_id;

  cursor c_run_this_year(v_last_run_date date) is
     select 'Y'
     from   financial_years
     where  v_last_run_date > fyr_start_date
     and    v_last_run_date < fyr_end_date
     and    sysdate > fyr_start_date
     and    sysdate < fyr_end_date;

  cursor wol_paid_status is
     select hsc_status_code
     from   hig_status_codes
     where  hsc_domain_code = 'WORK_ORDER_LINES'
     and    hsc_allow_feature4 = 'Y' and hsc_allow_feature9 = 'N';

  cursor wol_part_paid_status is
     select hsc_status_code
     from   hig_status_codes
     where  hsc_domain_code = 'WORK_ORDER_LINES'
     and    hsc_allow_feature4 = 'Y'
     and    hsc_allow_feature9 = 'Y';

  cursor is_complete(c_code in hig_status_codes.hsc_status_code%type) is
     select 1
     from   hig_status_codes
     where  hsc_allow_feature3 = 'Y'
     and    hsc_domain_code = 'WORK_ORDER_LINES'
     and    hsc_status_code = c_code;

  cursor claim_paid_status is
     select hsc_status_code
     from   hig_status_codes
     where  hsc_domain_code = 'CLAIM STATUS'
     and    hsc_allow_feature3 = 'Y';


begin
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

  open c_elec_interface(pi_con_id);
  fetch c_elec_interface into v_use_interfaces;
  close c_elec_interface;

  dbms_output.put_line('Contract locked');
  --
  -- do not close the cursor we want to keep the lock on the contract right through the procedure!
  --
  dbms_output.put_line('Obtaining new payment id from sequence');
  --
  open c_next_payment;
  fetch c_next_payment into v_cnp_id;
  close c_next_payment;

  dbms_output.put_line('Got next payment id');
  --
  dbms_output.put_line('CNP    : '||to_char(v_cnp_id)||' Con: '||to_char(pi_con_id));
  --
  open c_last_payment_details (pi_con_id);
  fetch c_last_payment_details into v_payment_no, v_retention_rate, v_cost_code;
  close c_last_payment_details;

  open c_first_payment_details(pi_con_id);
  fetch c_first_payment_details into v_first_payment;
  close c_first_payment_details;

  if v_first_payment is null then
     v_first_payment := v_cnp_id;
  end if;

  dbms_output.put_line('Obtaining work order lines for contract : '||to_char(pi_con_id));

  open wol_paid_status;
  fetch wol_paid_status into l_paid_status;
  close wol_paid_status;

  open wol_part_paid_status;
  fetch wol_part_paid_status into l_part_paid_status;
  close wol_part_paid_status;

  open claim_paid_status;
  fetch claim_paid_status into l_claim_paid_status;
  close claim_paid_status;

  dbms_output.put_line('Setting Work Order lines to PAID');
  dbms_output.put_line('Updating Work Order Lines');
  --
  
  l_payment_wols_arr := get_payment_wols(pi_con_id         => pi_con_id
                                        ,pi_start_date     => pi_start_date
                                        ,pi_end_date       => pi_end_date
                                        ,pi_financial_year => pi_financial_year);
  
  for i in 1..l_payment_wols_arr.count
  loop
    db('processing wol ' || l_payment_wols_arr(i).wol_id);
    
    if l_payment_wols_arr(i).woc_claim_type in ('I', 'F') and
       maiwo.final_already_paid(l_payment_wols_arr(i).wol_id) = 'TRUE' then

         null; -- don't process an Interim or Final invoice
                 -- if a final has already been paid

    else

     if l_payment_wols_arr(i).wol_def_defect_id is not null then
        open c_get_rechar (l_payment_wols_arr(i).wol_def_defect_id);
        fetch c_get_rechar into v_rechar;
        close c_get_rechar;
     end if;

     if v_rechar is null then
        v_functional_act := '3';
     else
        v_functional_act := '4';
     end if;
     v_rechar := null;

     v_payment_code := rpad(nvl(l_payment_wols_arr(i).wor_coc_cost_centre,' '),3)||
                       v_functional_act||
                       rpad(nvl(l_payment_wols_arr(i).wol_siss_id,' '),3)||
                       rpad(v_cost_code,4)||
                       rpad(nvl(l_payment_wols_arr(i).wor_job_number,' '),5)||
                       rpad(substr(nvl(l_payment_wols_arr(i).rse_linkcode,' '),1,1),1);

 -- do not need this call as it is the extra to pay that is
 -- sent to claim_payments and not the total cost.

 --      if l_payment_wols_arr(i).woc_claim_type != 'P' then
 --        l_previous_payment := maiwo.previous_payment(l_payment_wols_arr(i).wol_id, l_payment_wols_arr(i).cp_woc_claim_ref);
 --      end if;

     update work_order_lines
     set    wol_payment_code = v_payment_code,
            wol_cnp_id = v_cnp_id
     where  wol_id = l_payment_wols_arr(i).wol_id;

     select decode(l_payment_wols_arr(i).woc_claim_type, l_claim_paid_status,
            l_payment_wols_arr(i).cp_claim_value,
            cp_claim_value - l_previous_payment)
     into   v_payment_value
     from   claim_payments
     where  cp_wol_id = l_payment_wols_arr(i).wol_id
     and    cp_woc_claim_ref = l_payment_wols_arr(i).cp_woc_claim_ref
     and    cp_woc_con_id = pi_con_id;

     -- apply discount if there is one
     if (l_payment_wols_arr(i).wor_act_balancing_sum != 0 and l_payment_wols_arr(i).wor_act_cost != 0) then
       v_payment_value := v_payment_value + v_payment_value * (l_payment_wols_arr(i).wor_act_balancing_sum / l_payment_wols_arr(i).wor_act_cost);
     end if;

     update claim_payments
     set    cp_payment_date = sysdate
           ,cp_payment_id = v_cnp_id
           ,cp_status = l_claim_paid_status
           ,cp_payment_value = v_payment_value
     where  cp_wol_id = l_payment_wols_arr(i).wol_id
     and    cp_woc_claim_ref = l_payment_wols_arr(i).cp_woc_claim_ref
     and    cp_woc_con_id = pi_con_id;

     -- update the interim_payments table in case the wol has interim payments
     update wol_interim_payments
     set    wip_status = 'P'
           ,wip_date   = sysdate
     where  wip_wol_id = l_payment_wols_arr(i).wol_id;

     v_total_value := v_total_value + nvl(v_payment_value, 0);

     l_inv_status := maiwo.wol_invoice_status(l_payment_wols_arr(i).wol_id);

     open is_complete(l_payment_wols_arr(i).wol_status_code);
     fetch is_complete into dummy;
     if is_complete%found then

       close is_complete;
       update work_order_lines
       set    wol_invoice_status = l_inv_status,
              wol_status_code = l_paid_status,
              wol_date_paid = sysdate
       where  wol_id =  l_payment_wols_arr(i).wol_id;
     else
       close is_complete;
       update work_order_lines
       set    wol_invoice_status = l_inv_status,
              wol_status_code = l_part_paid_status
       where  wol_id =  l_payment_wols_arr(i).wol_id;
     end if;

   end if;

  end loop;
  --
  dbms_output.put_line('Work Order Lines Updated');
  --
  v_retention_amount := round((v_total_value * v_retention_rate / 100),2);
  --
  dbms_output.put_line('Obtaining Contract Extentions');
  --
  open c_retention_to_date(pi_con_id);
  fetch c_retention_to_date into v_retention_to_date, v_max_retention;
  close c_retention_to_date;
  --
  dbms_output.put_line('Contract Retentions Obtained');
  --
  if v_retention_amount + v_retention_to_date >= v_max_retention then
     dbms_output.put_line('Recalculating retention rate');
     v_retention_rate :=
     round (((v_max_retention - v_retention_to_date)/nvl(v_total_value,1))*100,2);
     v_retention_amount := round((v_total_value * v_retention_rate / 100),2);
  end if;

  if pi_apply_vat
  then
     dbms_output.put_line('Obtaining VAT rate');
     open c_vat_rate;
     fetch c_vat_rate into v_vat_rate;
     close c_vat_rate;

     v_vat_amount := round(((v_total_value - v_retention_amount) * v_vat_rate / 100),2);
  else
     v_vat_amount := 0.00;
  end if;
  v_cnp_amount := (v_total_value - v_retention_amount + v_vat_amount);
  --
  dbms_output.put_line('Inserting into Contract Payments'||to_char(v_total_value)||' total ');
  --

  insert into contract_payments
     (cnp_id, cnp_con_id, cnp_run_date, cnp_username,
      cnp_first_payment_no, cnp_last_payment_no, cnp_total_value,
      cnp_retention_amount, cnp_vat_amount, cnp_amount)
     values
     (v_cnp_id, pi_con_id, sysdate, user,
      v_first_payment, v_payment_no, v_total_value,
      v_retention_amount, v_vat_amount, v_cnp_amount);

  if v_use_interfaces = 'Y'
  then
    begin
      generate_payment_file(pi_contractor_id  => pi_oun_ord_id
                           ,pi_cnp_id         => v_cnp_id
                           ,pi_financial_year => pi_financial_year
                           ,pi_start_date     => pi_start_date
                           ,pi_end_date       => pi_end_date
                           ,pi_file_path      => pi_file_path
                           ,pi_period_13      => pi_period_13
                           ,po_filename       => po_filename);
    exception
      when others then
        raise credit_file_error;
    end;

  end if;

  open c_last_run_date(pi_con_id);
  fetch c_last_run_date into v_last_run_date;
  close c_last_run_date;


  if v_last_run_date is not null then

     open c_run_this_year(v_last_run_date);
     fetch c_run_this_year into v_same_year;
     close c_run_this_year;

  end if;

-- from post
  dbms_output.put_line('Updating contract');

  if v_same_year = 'Y' then
     update contracts
     set con_spend_to_date = nvl(con_spend_to_date,0) + v_total_value,
         con_spend_ytd = nvl(con_spend_ytd,0) + v_total_value,
         con_last_payment_no = v_cnp_id
     where con_id = pi_con_id;
  else
     update contracts
     set con_spend_to_date = nvl(con_spend_to_date,0) + v_total_value,
         con_spend_ytd = v_total_value,
         con_last_payment_no = v_cnp_id
     where con_id = pi_con_id;
  end if;

  if v_retention_amount + v_retention_to_date >= v_max_retention then
    update contracts
    set    con_retention_to_date = nvl(v_max_retention,0)
    where  con_id = pi_con_id;
  else
    update contracts
    set    con_retention_to_date = nvl(v_retention_to_date,0) + nvl(v_retention_amount,0)
    where  con_id = pi_con_id;
  end if;

  dbms_output.put_line('Transaction Completed and Committed');

 -- got to here O.K return cnp_id for reports and TRUE
  po_cnp_id     := v_cnp_id;
  po_error_code := null;
  po_error_appl := null;
 
exception
  when contract_is_locked
  then
    po_cnp_id     := null;
    po_error_code := 885;
    po_error_appl := 'M_MGR';

  when payment_seq_missing
  then
    po_cnp_id     := null;
    po_error_code := 83;
    po_error_appl := 'HWAYS';

  when no_items_for_payment
  then
    po_cnp_id     := null;
    po_error_code := 887;
    po_error_appl := 'M_MGR';

  when credit_file_error
  then
    po_cnp_id     := null;
    po_error_code := 888; -- other problem
    po_error_appl := 'M_MGR';

  when DUP_VAL_ON_INDEX then
    po_cnp_id     := null;
    po_error_code := 885;
    po_error_appl := 'M_MGR';

  when others
  then
    po_cnp_id     := null;
    po_error_code := 888; -- other problem
    po_error_appl := 'M_MGR';

end;
--
-----------------------------------------------------------------------------
--
END xnor_hops_gl_interface;
/
