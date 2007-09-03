CREATE OR REPLACE PACKAGE BODY xnor_may_gurney_interface AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor_may_gurney_interface.pkb-arc   2.2   Sep 03 2007 10:10:54   aedwards  $
--       Module Name      : $Workfile:   xnor_may_gurney_interface.pkb  $
--       Date into SCCS   : $Date:   Sep 03 2007 10:10:54  $
--       Date fetched Out : $Modtime:   Sep 03 2007 09:09:54  $
--       PVCS Version     : $Revision:   2.2  $
--       Originally based on SCCS version 1.6
--
--
--   Author : Kevin Angus
--
--   xnor_may_gurney_interface body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
--
  -------
  --types
  -------
  TYPE t_xmgw_arr                  IS TABLE OF xnor_may_gurney_wols%ROWTYPE INDEX BY pls_integer;
  TYPE t_xmgw_wol_id_arr           IS TABLE OF xnor_may_gurney_wols.xmgw_wol_id%TYPE INDEX BY pls_integer;
  TYPE t_xmgw_commitment_value_arr IS TABLE OF xnor_may_gurney_wols.xmgw_commitment_value%TYPE INDEX BY pls_integer;
  TYPE t_xmgw_payment_value_arr    IS TABLE OF xnor_may_gurney_wols.xmgw_payment_value%TYPE INDEX BY pls_integer;
  
  TYPE t_wol_id_arr                IS TABLE OF work_order_lines.wol_id%TYPE INDEX BY pls_integer;
  TYPE t_claim_ref_arr             IS TABLE OF claim_payments.cp_woc_claim_ref%TYPE INDEX BY pls_integer;
  TYPE t_payment_code_arr          IS TABLE OF work_order_lines.wol_payment_code%TYPE INDEX BY pls_integer;
  
  TYPE t_commitment_data_rec       IS RECORD(works_order_no     work_orders.wor_works_order_no%TYPE
                                            ,wor_date_confirmed work_orders.wor_date_confirmed%TYPE
                                            ,wol_id             work_order_lines.wol_id%TYPE
                                            ,defect_id          work_order_lines.wol_def_defect_id%TYPE
                                            ,wol_cost           work_order_lines.wol_act_cost%TYPE
                                            ,bud_id             work_order_lines.wol_bud_id%TYPE
                                            ,budget_cost_code   budgets.bud_cost_code%TYPE);
  TYPE t_commitment_data_arr       IS TABLE OF t_commitment_data_rec INDEX BY pls_integer;
  
  TYPE t_payment_data_rec          IS RECORD(works_order_no      work_orders.wor_works_order_no%TYPE
                                            ,wor_date_closed     work_orders.wor_date_closed%TYPE
                                            ,wol_id              work_order_lines.wol_id%TYPE
                                            ,defect_id           work_order_lines.wol_def_defect_id%TYPE
                                            ,wol_act_cost        work_order_lines.wol_act_cost%TYPE
                                            ,bud_id              work_order_lines.wol_bud_id%TYPE
                                            ,wol_siss_id         work_order_lines.wol_siss_id%TYPE
                                            ,wor_coc_cost_centre work_orders.wor_coc_cost_centre%TYPE
                                            ,wor_job_number      work_orders.wor_job_number%TYPE
                                            ,budget_cost_code    budgets.bud_cost_code%TYPE
                                            ,def_rechar_org_id   defects.def_rechar_org_id%TYPE
                                            ,woc_claim_ref       claim_payments.cp_woc_claim_ref%TYPE
                                            ,rse_link_code       road_segments_all.rse_linkcode%TYPE);
  TYPE t_payment_data_arr          IS TABLE OF t_payment_data_rec INDEX BY pls_integer;
  
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid                CONSTANT varchar2(2000) := '$Revision:   2.2  $';

  g_package_name               CONSTANT varchar2(30) := 'xnor_may_gurney_interface';
  
  c_y                          CONSTANT varchar2(1) := 'Y';
  
  c_ampersand                  CONSTANT varchar2(1) := CHR(38);
  
  c_default_error_code         CONSTANT pls_integer := -20000;
  
  c_commitments_file_type      CONSTANT varchar2(3) := 'COM';
  c_payments_file_type         CONSTANT varchar2(3) := 'PAY';
  c_reversal_file_type         CONSTANT varchar2(3) := 'REV';
  c_control_file_type          CONSTANT varchar2(3) := 'CTL';
  
  c_payment_line_type_item     CONSTANT varchar2(4) := 'ITEM';
  c_payment_line_type_tax      CONSTANT varchar2(3) := 'TAX';
  
  c_mag_encumb_cost_code_opt   CONSTANT hig_options.hop_id%TYPE := 'FIMREVCODE';
  c_mag_encumb_cost_code       CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt(p_option_id => c_mag_encumb_cost_code_opt);
  
  c_vat_cost_code_opt          CONSTANT hig_options.hop_id%TYPE := 'NCCVATCODE';
  c_vat_cost_code              CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt(p_option_id => c_vat_cost_code_opt);
  
  c_vat_rate_opt               CONSTANT hig_options.hop_id%TYPE := 'NCCVATRATE';
  c_vat_rate                   CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt(p_option_id => c_vat_rate_opt);
    
  c_vat_tax_code               CONSTANT varchar2(11) := 'NCC P' || c_ampersand || 'T CAR';
    
  c_sep                        CONSTANT varchar2(1) := ',';
  
  c_csv_date_format            CONSTANT varchar2(11) := 'DD-MON-YYYY';
  c_csv_currency_format        CONSTANT varchar2(13) := 'FM99999990.00';

  c_currency_code              CONSTANT varchar2(3) := 'GBP';
  
  c_wol_status_completed       CONSTANT work_order_lines.wol_status_code%TYPE := 'COMPLETED';
  c_wol_status_paid            CONSTANT work_order_lines.wol_status_code%TYPE := 'PAID';
  
  c_claim_domain               CONSTANT hig_status_codes.hsc_domain_code%TYPE := 'CLAIM STATUS';
  
  --position of relevant cost codes in budget cost code field
  c_pandt_cost_code_pos        CONSTANT pls_integer := 1;
  
  c_user_jre_category_name constant varchar2(30) := 'NCC HMS MAY GURNEY';
  c_encumbrance_type_id    constant varchar2(4)  := '1042';
  c_actual_flag            constant varchar2(1)  := 'E';
  
  -----------
  --variables
  -----------
  g_grr_job_id gri_report_runs.grr_job_id%TYPE;
  
  g_debug_on boolean := false;
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
PROCEDURE set_debug(pi_debug_on IN boolean DEFAULT TRUE
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
                   ,pi_fatal            IN boolean     DEFAULT FALSE
                   ,pi_fatal_error_code IN pls_integer DEFAULT c_default_error_code
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'log_error');

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
FUNCTION write_control_file(pi_file_path     IN varchar2
                           ,pi_file_name     IN varchar2
                           ,pi_total_lines   IN pls_integer
                           ,pi_total_credits IN number
                           ,pi_total_debits  IN number
                           ) RETURN varchar2 IS

  l_control_filename varchar2(500);
  
  l_file_id utl_file.file_type;
  
  PROCEDURE writeln(pi_text IN varchar2
                   ) IS
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,buffer => pi_text);
  END writeln;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'write_control_file');

  l_control_filename := pi_file_name || '.' || c_control_file_type;
  db('Writing control file ' || l_control_filename);
  
  l_file_id := open_output_file(pi_file_path => pi_file_path
                               ,pi_filename  => l_control_filename);

  writeln('HMS May Gurney Interface');
  writeln('Control information for file ' || pi_file_name);
  writeln('======================================================================');
  writeln('Lines in file: ' || TO_CHAR(pi_total_lines));
  writeln('Total credits: ' || TO_CHAR(pi_total_credits, c_csv_currency_format));
  writeln('Total debits : ' || TO_CHAR(pi_total_debits, c_csv_currency_format));
  writeln('======================================================================');
  
  nm3file.fclose(FILE => l_file_id);
                               
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'write_control_file');

  RETURN l_control_filename;

END write_control_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_oun(pi_oun_org_id org_units.oun_org_id%TYPE
                 ) RETURN org_units%ROWTYPE IS

  l_retval org_units%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_oun');

  SELECT
    oun.*
  INTO
    l_retval
  FROM
    org_units oun
  WHERE
    oun.oun_org_id = pi_oun_org_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_oun');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    log_error(pi_error_msg => 'Specified contractor not found (org_units.oun_org_id = ' || pi_oun_org_id || ')'
             ,pi_fatal     => TRUE);
  
  WHEN too_many_rows
  THEN
    log_error(pi_error_msg => 'Found more than one record on unique lookup org_units.oun_org_id = ' || pi_oun_org_id
             ,pi_fatal     => TRUE);
  
END get_oun;
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
FUNCTION running_for_current_year(pi_financial_year IN financial_years.fyr_id%TYPE
                                 ) RETURN boolean IS

  l_retval boolean;
  
  l_dummy pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'running_for_current_year');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      financial_years fy
    WHERE
      fy.fyr_id = pi_financial_year
    AND
      SYSDATE BETWEEN fy.fyr_start_date AND fy.fyr_end_date;
  
    l_retval := TRUE;
  
  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;
      
  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'running_for_current_year');

  RETURN l_retval;

END running_for_current_year;
--
-----------------------------------------------------------------------------
--
FUNCTION payment_on_contract_this_year(pi_contract_id    IN contracts.con_id%TYPE
                                      ,pi_financial_year IN financial_years.fyr_id%TYPE
                                      ) RETURN boolean IS

  l_retval boolean;
  
  l_dummy pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'payment_on_contract_this_year');
  
  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  --check if there has already been a payment on the contract this year
  
  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      financial_years fy,
      (SELECT
         MAX(cnp_run_date) last_run
       FROM
         contract_payments
       WHERE
         cnp_con_id = pi_contract_id) cnp
    WHERE
      fy.fyr_id = pi_financial_year
    AND
      cnp.last_run BETWEEN fy.fyr_start_date AND fy.fyr_end_date;
    
    l_retval := TRUE;
    
  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;
      
  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'payment_on_contract_this_year');

  RETURN l_retval;

END payment_on_contract_this_year;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_contract_details(pi_con_rec          IN contracts%ROWTYPE
                                 ,pi_financial_year   IN financial_years.fyr_id%TYPE
                                 ,pi_run_id           IN contract_payments.cnp_id%TYPE
                                 ,pi_invoice_value    IN number
                                 ,pi_retention_amount IN number
                                 ) IS

  l_retention_to_date contracts.con_retention_to_date%TYPE;
  
  l_ytd_spend contracts.con_spend_ytd%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'update_contract_details');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  --Update the contract following the generation of the payment file 
  
  IF pi_retention_amount + pi_con_rec.con_retention_to_date >= pi_con_rec.con_max_retention
  THEN
    l_retention_to_date := NVL(pi_con_rec.con_max_retention, 0);
  ELSE
    l_retention_to_date := NVL(pi_con_rec.con_retention_to_date, 0) + NVL(pi_retention_amount,0);
  END IF;
  
  IF running_for_current_year(pi_financial_year => pi_financial_year)
  THEN
    --current year so work out year to date spend
    IF payment_on_contract_this_year(pi_contract_id    => pi_con_rec.con_id
                                    ,pi_financial_year => pi_financial_year)
    THEN
      l_ytd_spend := NVL(pi_con_rec.con_spend_ytd, 0) + pi_invoice_value;
    ELSE
      l_ytd_spend := pi_invoice_value;
    END IF;
    
    UPDATE
      contracts con
    SET
      con_spend_to_date     = NVL(con_spend_to_date, 0) + pi_invoice_value,
      con_last_payment_no   = pi_run_id,
      con_retention_to_date = l_retention_to_date,
      con_spend_ytd         = l_ytd_spend
    WHERE
      con.con_id = pi_con_rec.con_id;
  ELSE
    --not current year so do not update year to date column
    UPDATE
      contracts con
    SET
      con_spend_to_date     = NVL(con_spend_to_date, 0) + pi_invoice_value,
      con_last_payment_no   = pi_run_id,
      con_retention_to_date = l_retention_to_date
    WHERE
      con.con_id = pi_con_rec.con_id;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'update_contract_details');

END update_contract_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_claim_status_approved_code RETURN hig_status_codes.hsc_status_code%TYPE IS
  
  l_retval hig_status_codes.hsc_status_code%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_claim_status_approved_code');
  
  SELECT
    hsc.hsc_status_code
  INTO
    l_retval
  FROM
    hig_status_codes hsc
  WHERE
    hsc.hsc_domain_code = c_claim_domain
  AND
    hsc.hsc_allow_feature1 = c_y;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_claim_status_approved_code');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    log_error(pi_error_msg => 'Approved claim status code not found.'
             ,pi_fatal     => TRUE);
  
  WHEN too_many_rows
  THEN
    log_error(pi_error_msg => 'Found more than one Approved claim status code.'
             ,pi_fatal     => TRUE);
  
END get_claim_status_approved_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_claim_status_paid_code RETURN hig_status_codes.hsc_status_code%TYPE IS
  
  l_retval hig_status_codes.hsc_status_code%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_claim_status_paid_code');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  SELECT
    hsc.hsc_status_code
  INTO
    l_retval
  FROM
    hig_status_codes hsc
  WHERE
    hsc.hsc_domain_code = c_claim_domain
  AND
    hsc.hsc_allow_feature3 = c_y;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_claim_status_paid_code');

  RETURN l_retval;

EXCEPTION
  WHEN no_data_found
  THEN
    log_error(pi_error_msg => 'Approved claim status code not found.'
             ,pi_fatal     => TRUE);
  
  WHEN too_many_rows
  THEN
    log_error(pi_error_msg => 'Found more than one Approved claim status code.'
             ,pi_fatal     => TRUE);
  
END get_claim_status_paid_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_functional_act(pi_rechar IN defects.def_rechar_org_id%TYPE
                           ) RETURN pls_integer IS

BEGIN
  --this is part of the standard payment run functionality based 
  --on the logic in maiwo.process_payment_run.
  
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_functional_act');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_functional_act');
                   
  RETURN CASE pi_rechar WHEN NULL THEN '3' ELSE '4' END;

END get_functional_act;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_code(pi_wor_coc_cost_centre IN work_orders.wor_coc_cost_centre%TYPE
                         ,pi_functional_act      IN pls_integer
                         ,pi_wol_siss_id         IN work_order_lines.wol_siss_id%TYPE
                         ,pi_cost_code           IN contracts.con_cost_code%TYPE
                         ,pi_wor_job_number      IN work_orders.wor_job_number%TYPE
                         ,pi_rse_link_code       IN road_segments_all.rse_linkcode%TYPE
                         ) RETURN work_order_lines.wol_payment_code%TYPE IS

  l_retval work_order_lines.wol_payment_code%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_code');

  --this is part of the standard payment run functionality based 
  --on the logic in maiwo.process_payment_run.
  
  l_retval := RPAD(NVL(pi_wor_coc_cost_centre,' '),3)||
              pi_functional_act||
              RPAD(NVL(pi_wol_siss_id,' '),3)||
              RPAD(pi_cost_code,4)||
              RPAD(NVL(pi_wor_job_number,' '),5)||
              RPAD(SUBSTR(NVL(pi_rse_link_code,' '),1,1),1);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_code');

  RETURN l_retval;

END get_payment_code;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_run_name(pi_run_subject IN varchar2
                          ) RETURN varchar2 IS

  l_retval varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_run_name');

  l_retval :=   'HMS'
              || REPLACE(pi_run_subject, ' ', '_')
              || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_run_name');

  RETURN l_retval;

END generate_run_name;
--
-----------------------------------------------------------------------------
-- 
FUNCTION generate_filename(pi_run_name  IN varchar2
                          ,pi_file_type IN varchar2
                          ) RETURN varchar2 IS

  l_retval varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_filename');

  l_retval := pi_run_name || '.' || pi_file_type;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_filename');

  RETURN l_retval;

END generate_filename;
--
-----------------------------------------------------------------------------
--
FUNCTION get_commitment_data(pi_oun_id         IN contracts.con_contr_org_id%TYPE
                            ,pi_financial_year IN financial_years.fyr_id%TYPE
                            --,pi_start_date     IN date
                            ,pi_end_date       IN date
                            ) RETURN t_commitment_data_arr IS 

  l_commitment_data_arr t_commitment_data_arr;
                         
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_commitment_data');
  
  --selecting where
  --  contractor = specified
  --  work order is instructed (wor.wor_date_confirmed IS NOT NULL)
  --  instructed between start and end dates
  --  work order is not completed (wor.wor_date_closed IS NULL)
  --  line budget is in specified financial year
  
  --we are selecting the actual cost if it is available and the estimated
  --cost if it is not.
  
  SELECT
    wol.wol_works_order_no,
    wor.wor_date_confirmed,
    wol.wol_id,
    wol.wol_def_defect_id,
    NVL(wol.wol_act_cost, wol.wol_est_cost),
    wol.wol_bud_id,
    bud.bud_cost_code
  BULK COLLECT INTO
    l_commitment_data_arr
  FROM
    work_orders          wor,
    work_order_lines     wol,
    contracts            con,
    budgets              bud
  WHERE
    con.con_contr_org_id = pi_oun_id
  AND
    con.con_id = wor.wor_con_id
  AND
    wor.wor_date_confirmed IS NOT NULL
  AND
    (pi_end_date IS NULL
     OR
     wor.wor_date_confirmed <= pi_end_date)
  AND  
    wor.wor_date_closed IS NULL
  AND
    wor.wor_works_order_no = wol.wol_works_order_no
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year
  order by
    wol.wol_id;
    
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_commitment_data');
    
  RETURN l_commitment_data_arr;

END get_commitment_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_data(pi_contract_id    IN contracts.con_id%TYPE
                         ,pi_financial_year IN financial_years.fyr_id%TYPE
                         ,pi_start_date     IN date
                         ,pi_end_date       IN date
                         ) RETURN t_payment_data_arr IS

  c_approved_satus CONSTANT hig_status_codes.hsc_status_code%TYPE := get_claim_status_approved_code;
  
  l_payment_data_arr t_payment_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_data');

  --selecting where
  --  contract = contract specified
  --  instructed between start and end date (wor.wor_date_confirmed)
  --  wor is complete (wor.wor_date_closed IS NOT NULL)
  --  budget within specified financial year

  SELECT
    wol.wol_works_order_no,
    wor.wor_date_closed,
    wol.wol_id,
    wol.wol_def_defect_id,
    wol.wol_act_cost,
    wol.wol_bud_id,
    wol.wol_siss_id,
    wor.wor_coc_cost_centre,
    wor.wor_job_number,
    bud.bud_cost_code,
    def.def_rechar_org_id,
    cp.cp_woc_claim_ref,
    rse.rse_linkcode    
  BULK COLLECT INTO
    l_payment_data_arr
  FROM
    work_orders       wor,
    work_order_lines  wol,
    budgets           bud,
    defects           def,
    road_segments_all rse,
    claim_payments    cp
  WHERE
    wor.wor_con_id = pi_contract_id
  AND
    wor.wor_date_confirmed IS NOT NULL
  AND
    wor.wor_date_confirmed BETWEEN pi_start_date AND pi_end_date
  AND
    wor.wor_works_order_no = wol.wol_works_order_no
  AND
    wol.wol_status_code = c_wol_status_completed
  AND
    wol.wol_bud_id = bud.bud_id
  AND
    bud.bud_fyr_id = pi_financial_year
  AND
    def.def_defect_id  (+) = wol.wol_def_defect_id
  AND
    rse.rse_he_id = wol.wol_rse_he_id
  AND
    cp.cp_wol_id = wol.wol_id
  AND
    cp.cp_status = c_approved_satus;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_data');

  RETURN l_payment_data_arr;

END get_payment_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xmgw(pi_wol_id IN xnor_may_gurney_wols.xmgw_wol_id%TYPE
                 ) RETURN xnor_may_gurney_wols%ROWTYPE IS

  l_retval xnor_may_gurney_wols%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_xmgw');

  SELECT
    xmgw.*
  INTO
    l_retval
  FROM
    xnor_may_gurney_wols xmgw
  WHERE
    xmgw.xmgw_wol_id = pi_wol_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_xmgw');

  RETURN l_retval;

EXCEPTION
  WHEN too_many_rows
  THEN
    log_error(pi_error_msg => 'Found more than one record on primary key lookup xnor_may_gurney_wols.xmgw_wol_id = ' || pi_wol_id);
 
END get_xmgw;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_all_xmgw(pi_xmgw_arr IN t_xmgw_arr
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ins_all_xmgw');

  FORALL i IN 1..pi_xmgw_arr.COUNT
    INSERT INTO
      xnor_may_gurney_wols
    VALUES
      pi_xmgw_arr(i);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ins_all_xmgw');

END ins_all_xmgw;
--
-----------------------------------------------------------------------------
--
PROCEDURE upd_all_xmgw_commitments(pi_xmgw_wol_id_arr           IN t_xmgw_wol_id_arr
                                  ,pi_xmgw_commitment_value_arr IN t_xmgw_commitment_value_arr
                                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'upd_all_xmgw_commitments');

  FORALL i IN 1..pi_xmgw_wol_id_arr.COUNT
    UPDATE
      xnor_may_gurney_wols xmgw
    SET
      xmgw.xmgw_commitment_value    = pi_xmgw_commitment_value_arr(i),
      xmgw.xmgw_user_last_processed = USER,
      xmgw.xmgw_date_last_processed = SYSDATE
    WHERE
      xmgw.xmgw_wol_id = pi_xmgw_wol_id_arr(i);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'upd_all_xmgw_commitments');

END upd_all_xmgw_commitments;
--
-----------------------------------------------------------------------------
--
PROCEDURE upd_all_xmgw_payments(pi_xmgw_wol_id_arr        IN t_xmgw_wol_id_arr
                               ,pi_xmgw_payment_value_arr IN t_xmgw_payment_value_arr
                               ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'upd_all_xmgw_payments');

  FORALL i IN 1..pi_xmgw_wol_id_arr.COUNT
    UPDATE
      xnor_may_gurney_wols xmgw
    SET
      xmgw.xmgw_payment_value       = pi_xmgw_payment_value_arr(i),
      xmgw.xmgw_user_last_processed = USER,
      xmgw.xmgw_date_last_processed = SYSDATE
    WHERE
      xmgw.xmgw_wol_id = pi_xmgw_wol_id_arr(i);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'upd_all_xmgw_payments');

END upd_all_xmgw_payments;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_cnp(pi_cnp_rec contract_payments%ROWTYPE
                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ins_cnp');

  INSERT INTO
    contract_payments
  VALUES
    pi_cnp_rec;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ins_cnp');

END ins_cnp;
--
-----------------------------------------------------------------------------
--
FUNCTION get_accounting_date(pi_date_order_raised    IN date
                            ,pi_order_financial_year IN financial_years.fyr_id%TYPE
                            ) RETURN date IS

  c_fin_year_start CONSTANT date := TO_DATE('01-APR-' || TO_CHAR(pi_order_financial_year), 'DD-MON-YYYY');
  c_extract_date   CONSTANT date := TRUNC(SYSDATE);
  
  l_retval date;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_accounting_date');

  IF pi_date_order_raised < c_fin_year_start
  THEN
    l_retval := c_fin_year_start;
  ELSE
    l_retval := c_extract_date;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_accounting_date');

  RETURN l_retval;

END get_accounting_date;
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
FUNCTION get_next_pay_run_id RETURN number IS

  l_retval number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_next_pay_run_id');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  SELECT
    cnp_id_seq.NEXTVAL
  INTO
    l_retval
  FROM
    dual;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_next_pay_run_id');

  RETURN l_retval;

END get_next_pay_run_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_retention_amount(pi_con_rec       IN contracts%ROWTYPE
                             ,pi_invoice_total IN number
                             ) RETURN contract_payments.cnp_retention_amount%TYPE IS
 
  l_retention_amount contract_payments.cnp_retention_amount%TYPE;
  
  l_retention_rate contracts.con_retention_rate%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_retention_amount');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  l_retention_rate := NVL(pi_con_rec.con_retention_rate, 0);
  
  l_retention_amount := ROUND((pi_invoice_total * l_retention_rate / 100), 2);
  
  IF l_retention_amount + pi_con_rec.con_retention_to_date >= pi_con_rec.con_max_retention
  THEN
    l_retention_rate
      := ROUND(((pi_con_rec.con_max_retention - pi_con_rec.con_retention_to_date) / NVL(pi_invoice_total,1)) * 100, 2);
    l_retention_amount := ROUND((pi_invoice_total * l_retention_rate / 100), 2);
  END IF;

  db('Retention rate   = ' || l_retention_rate);
  db('Retention amount = ' || l_retention_amount);
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_retention_amount');

  RETURN l_retention_amount;
                   
END get_retention_amount;
--
-----------------------------------------------------------------------------
--
FUNCTION get_first_payment_details(pi_contract_id IN contracts.con_id%TYPE
                                  ,pi_pay_run_id  IN contract_payments.cnp_id%TYPE
                                  ) RETURN contract_payments.cnp_first_payment_no%TYPE IS

  l_retval contract_payments.cnp_first_payment_no%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_first_payment_details');

  --Part of standard payment run processing
  --This is based on the functionality in maiwo.process_payment_run
  
  SELECT
    MIN(cnp_first_payment_no)
  INTO
    l_retval
  FROM
    contract_payments
  WHERE
    cnp_con_id = pi_contract_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_first_payment_details');

  RETURN NVL(l_retval, pi_pay_run_id);

END get_first_payment_details;
--
-----------------------------------------------------------------------------
--
--FUNCTION get_encumbrance_line(pi_accounting_date IN date
--                             ,pi_cost            IN work_order_lines.wol_est_cost%TYPE
--                             ,pi_descr           IN varchar2
--                             ,pi_cost_code       IN varchar2
--                             ) RETURN varchar2 IS

--  l_retval nm3type.max_varchar2;
--  
--  l_entered_cr work_order_lines.wol_est_cost%TYPE;
--  l_entered_dr work_order_lines.wol_est_cost%TYPE;
--  
--  l_accounting_code varchar2(4000);

--BEGIN
--  nm_debug.proc_start(p_package_name   => g_package_name
--                     ,p_procedure_name => 'get_encumbrance_line');

--  IF pi_cost > 0
--  THEN
--    l_entered_dr := pi_cost;
--  ELSE
--    l_entered_cr := -pi_cost;
--  END IF;
--  
--  l_accounting_code := get_full_accounting_code(pi_cost_code => pi_cost_code);
--  
--  l_retval :=             'GLJEH01'                                       --record_type
--              || c_sep || 'NEW'                                           --status
--              || c_sep || '1'                                             --set_of_books_id
--              || c_sep || TO_CHAR(pi_accounting_date, c_csv_date_format)  --accounting_date
--              || c_sep || c_currency_code                                 --curreny_code
--              || c_sep || NULL                                            --date_created
--              || c_sep || NULL                                            --created_by
--              || c_sep || 'E'                                             --actual_flag
--              || c_sep || 'NCC HMS MAY GURNEY'                            --user_je_category_name
--              || c_sep || 'NCC HMS'                                       --user_je_source_name
--              || c_sep || NULL                                            --currency_conversion_date
--              || c_sep || '1042'                                          --encumbrance_type_id
--              || c_sep || NULL                                            --budget_version_id
--              || c_sep || NULL                                            --user_currency_conversion_type
--              || c_sep || NULL                                            --currency_conversion_rate
--              || c_sep || NULL                                            --average_journal_flag
--              || c_sep || NULL                                            --originating_bal_seg_value
--              || c_sep || NULL                                            --segment1
--              || c_sep || NULL                                            --segment2
--              || c_sep || NULL                                            --segment3
--              || c_sep || NULL                                            --segment4
--              || c_sep || NULL                                            --segment5
--              || c_sep || NULL                                            --segment6
--              || c_sep || NULL                                            --segment7
--              || c_sep || TO_CHAR(l_entered_dr, c_csv_currency_format)    --entered_dr
--              || c_sep || TO_CHAR(l_entered_cr, c_csv_currency_format)    --entered_cr
--              || c_sep || NULL                                            --accounted_dr
--              || c_sep || NULL                                            --accounted_cr
--              || c_sep || NULL                                            --transaction_date
--              || c_sep || NULL                                            --reference1
--              || c_sep || NULL                                            --reference2
--              || c_sep || NULL                                            --reference4
--              || c_sep || NULL                                            --reference5
--              || c_sep || NULL                                            --reference6
--              || c_sep || NULL                                            --reference7
--              || c_sep || NULL                                            --reference8
--              || c_sep || pi_descr                                        --reference10
--              || c_sep || NULL                                            --reference11
--              || c_sep || NULL                                            --reference12
--              || c_sep || NULL                                            --reference13
--              || c_sep || NULL                                            --reference14
--              || c_sep || NULL                                            --reference15
--              || c_sep || NULL                                            --reference16
--              || c_sep || NULL                                            --reference17
--              || c_sep || NULL                                            --reference18
--              || c_sep || NULL                                            --reference19
--              || c_sep || NULL                                            --reference20
--              || c_sep || NULL                                            --period_name
--              || c_sep || NULL                                            --je_line_num
--              || c_sep || NULL                                            --chart_of_accounts_id
--              || c_sep || NULL                                            --code_combination_id
--              || c_sep || NULL                                            --stat_amount
--              || c_sep || NULL                                            --group_id
--              || c_sep || l_accounting_code;                              --attribute1

--  nm_debug.proc_end(p_package_name   => g_package_name
--                   ,p_procedure_name => 'get_encumbrance_line');

--  RETURN l_retval;

--END get_encumbrance_line;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_header_line(pi_invoice_no            IN varchar2
                                ,pi_invoice_amount        IN number
                                ,pi_invoice_date          IN date
                                ,pi_invoice_received_date IN date
                                ,pi_gl_date               IN date
                                ,pi_invoice_descr         IN varchar2
                                ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;
  
  l_invoice_type varchar2(8);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_header_line');

  IF pi_invoice_amount >= 0
  THEN
    l_invoice_type := 'STANDARD';
  ELSE
    l_invoice_type := 'CREDIT';
  END IF;
  
  l_retval :=             'APINVH02'                                            --record_type
              || c_sep || pi_invoice_no                                         --invoice_num
              || c_sep || l_invoice_type                                        --invoice_type_lookup_code
              || c_sep || TO_CHAR(pi_invoice_date, c_csv_date_format)           --invoice_date
              || c_sep || NULL                                                  --po_number
              || c_sep || '71794'                                               --vendor_id
              || c_sep || '96794'                                               --vendor_site_id
              || c_sep || TO_CHAR(pi_invoice_amount, c_csv_currency_format)     --invoice_amount
              || c_sep || c_currency_code                                       --invoice_currency_code
              || c_sep || 'Immediate'                                           --terms_name
              || c_sep || pi_invoice_descr                                      --description
              || c_sep || NULL                                                  --attribute1
              || c_sep || 'NCC_HMS'                                             --source
              || c_sep || pi_invoice_no                                         --group_id
              || c_sep || NULL                                                  --payment_cross_rate_type
              || c_sep || NULL                                                  --payment_cross_rate_date
              || c_sep || NULL                                                  --payment_cross_rate
              || c_sep || NULL                                                  --payment_currency_code
              || c_sep || NULL                                                  --workflow_flag
              || c_sep || NULL                                                  --doc_category_code
              || c_sep || NULL                                                  --voucher_num
              || c_sep || NULL                                                  --goods_received_date
              || c_sep || NULL                                                  --not used
              || c_sep || to_char(pi_invoice_received_date, c_csv_date_format)  --invoice_received_date
              || c_sep || to_char(pi_gl_date, c_csv_date_format)                --gl_date
              || c_sep || NULL                                                  --accts_pay_code_combination
              || c_sep || NULL                                                  --ussgl_transaction_code
              || c_sep || TO_CHAR(pi_invoice_amount, c_csv_currency_format);    --amount_applicable_to_discount


  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_header_line');

  RETURN l_retval;

END get_payment_header_line;
--
-----------------------------------------------------------------------------
--
FUNCTION get_payment_line(pi_invoice_no      IN varchar2
                         ,pi_line_no         IN varchar2
                         ,pi_line_type       IN varchar2
                         ,pi_invoice_amount  IN number
                         ,pi_accounting_date IN date
                         ,pi_line_descr      IN varchar2
                         ,pi_tax_code        IN varchar2
                         ,pi_cost_code       IN varchar2
                         ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_payment_line');
  
  l_retval :=             'APINVL02'                                         --record_type
              || c_sep || pi_invoice_no                                      --invoice_num
              || c_sep || pi_line_no                                         --line_number
              || c_sep || pi_line_type                                       --line_type_lookup_code
              || c_sep || NULL                                               --line_group_number
              || c_sep || NULL                                               --
              || c_sep || '71794'                                            --vendor_id
              || c_sep || '96794'                                            --vendor_site_id
              || c_sep || TO_CHAR(pi_invoice_amount, c_csv_currency_format)  --amount
              || c_sep || TO_CHAR(pi_accounting_date, c_csv_date_format)     --accounting_date
              || c_sep || pi_line_descr                                      --description
              || c_sep || 'N'                                                --amount_includes_tax_flag
              || c_sep || NULL                                               --prorate_across_flag
              || c_sep || pi_tax_code                                        --tax_code
              || c_sep || NULL                                               --final_match_flag
              || c_sep || NULL                                               --po_header_id
              || c_sep || NULL                                               --legacy_po_number
              || c_sep || NULL                                               --po_vendor_id
              || c_sep || NULL                                               --po_vendor_site_id
              || c_sep || NULL                                               --po_number
              || c_sep || NULL                                               --po_line_id
              || c_sep || NULL                                               --po_line_number
              || c_sep || NULL                                               --po_line_location_id
              || c_sep || NULL                                               --po_shipment_num
              || c_sep || NULL                                               --po_distribution_id
              || c_sep || pi_cost_code                                       --dist_code_concatenated
              || c_sep || NULL                                               --attribute1
              || c_sep || NULL                                               --po_release_id
              || c_sep || NULL                                               --release_num
              || c_sep || NULL                                               --account_segment
              || c_sep || NULL                                               --balancing_segment
              || c_sep || NULL                                               --cost_center_segment
              || c_sep || NULL                                               --project_id
              || c_sep || NULL                                               --task_id
              || c_sep || NULL                                               --expenditure_type
              || c_sep || NULL                                               --expenditure_item_date
              || c_sep || NULL                                               --expenditure_organization_id
              || c_sep || NULL                                               --project_accounting_context
              || c_sep || NULL                                               --pa_addition_flag
              || c_sep || NULL                                               --pa_quantity
              || c_sep || NULL                                               --ussgl_transaction_code
              || c_sep || NULL                                               --stat_amount
              || c_sep || NULL                                               --type_1099
              || c_sep || NULL                                               --income_tax_region
              || c_sep || 'N';                                               --assets_tracking_flag

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_payment_line');

  RETURN l_retval;

END get_payment_line;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_order_file(pi_grr_job_id IN gri_report_runs.grr_job_id%TYPE
                            ) RETURN varchar2 IS

  l_filename varchar2(255);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_order_file');

  g_grr_job_id := pi_grr_job_id;
  
  l_filename := generate_order_file(pi_contractor_id  => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
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
                   ,p_procedure_name => 'generate_order_file');

  RETURN l_filename;

END generate_order_file;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_order_file(pi_contractor_id  IN org_units.oun_org_id%TYPE
                            ,pi_financial_year IN financial_years.fyr_id%TYPE
                            ,pi_end_date       IN date
                            ,pi_file_path      IN varchar2
                            ,pi_period_13      in boolean
                            ) RETURN varchar2 IS
  
  l_oun_rec org_units%ROWTYPE;
  
  l_run_name varchar2(4000);
  l_filename varchar2(4000);
  
  l_control_file_name varchar2(4000);
  
  l_commitment_data_arr t_commitment_data_arr;
  
  l_accounting_date date;
  
  l_line_descr varchar2(4000);
  
  l_xmgw_ins_arr t_xmgw_arr;
  
  l_xmgw_upd_wol_id_arr          t_xmgw_wol_id_arr;
  l_xmgw_upd_commitmnt_value_arr t_xmgw_commitment_value_arr;
  
  l_xmgw_rec xnor_may_gurney_wols%ROWTYPE;
  
  l_file_id utl_file.file_type;
  l_control_file_id utl_file.file_type;
  
  l_write_wol_to_file boolean;
  
  l_commitment_cost_code budgets.bud_cost_code%TYPE;
  
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

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_order_file');
  
  db(g_package_name || '.generate_order_file');
  db('  pi_contractor_id  = ' || pi_contractor_id);
  db('  pi_financial_year = ' || pi_financial_year);
  --db('  pi_start_date     = ' || TO_CHAR(pi_start_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_end_date       = ' || TO_CHAR(pi_end_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_file_path      = ' || pi_file_path);

  --check contractor exists and get details
  l_oun_rec := get_oun(pi_oun_org_id => pi_contractor_id);
  db('Contractor Name = ' || l_oun_rec.oun_name);
  
  l_commitment_data_arr := get_commitment_data(pi_oun_id         => pi_contractor_id
                                              ,pi_financial_year => pi_financial_year
                                              --,pi_start_date     => pi_start_date
                                              ,pi_end_date       => pi_end_date);
                                   
  db('Found ' || l_commitment_data_arr.COUNT || ' work order lines');
  
  IF l_commitment_data_arr.COUNT > 0
  THEN
    --we have records to process
    --open the file

    l_run_name := generate_run_name(pi_run_subject=> l_oun_rec.oun_name);
    db('Run Name = ' || l_run_name);
    
    l_filename := generate_filename(pi_run_name  => l_run_name
                                   ,pi_file_type => c_commitments_file_type);
    db('Filename = ' || l_filename);
    
    l_file_id := open_output_file(pi_file_path => pi_file_path
                                 ,pi_filename  => l_filename);
  
    --which date do we use in the output file?
    l_accounting_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
  
    -------------------------
    --process the wol records
    -------------------------
    FOR i IN 1..l_commitment_data_arr.COUNT
    LOOP
    db('processing wol ' || l_commitment_data_arr(i).wol_id || ' with cost ' || l_commitment_data_arr(i).wol_cost);  
    
      l_write_wol_to_file := FALSE;
      
      --accounting date now set above for whole file
        --get accounting date for this works order
        --l_accounting_date := get_accounting_date(pi_date_order_raised    => l_commitment_data_arr(i).wor_date_confirmed
        --                                        ,pi_order_financial_year => pi_financial_year);
      
      l_line_descr := get_line_description(pi_works_order_no => l_commitment_data_arr(i).works_order_no
                                          ,pi_wol_id         => l_commitment_data_arr(i).wol_id
                                          ,pi_defect_id      => l_commitment_data_arr(i).defect_id);
      
      l_commitment_cost_code := interfaces.split_cost_code(p_cost_code => l_commitment_data_arr(i).budget_cost_code
                                                          ,p_number    => c_pandt_cost_code_pos);
      
      --get log record for this wol
      BEGIN
        l_xmgw_rec := get_xmgw(pi_wol_id => l_commitment_data_arr(i).wol_id);
        
        db('found xmgw record');
        
        ---------------------------------
        --check values against log record
        ---------------------------------
        IF l_commitment_data_arr(i).wol_cost <> l_xmgw_rec.xmgw_commitment_value
        THEN
          db('writing reversal');
          --we need to generate a reversal record for the original value in the file
          --PandT line
          writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                              ,pi_cost                  => -l_xmgw_rec.xmgw_commitment_value
                                                              ,pi_descr                 => l_line_descr
                                                              ,pi_cost_code             => l_commitment_cost_code
                                                              ,pi_user_je_category_name => c_user_jre_category_name
                                                              ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                              ,pi_actual_flag           => c_actual_flag));
        
          --commitment line
          writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                              ,pi_cost                  => l_xmgw_rec.xmgw_commitment_value
                                                              ,pi_descr                 => l_line_descr
                                                              ,pi_cost_code             => c_mag_encumb_cost_code
                                                              ,pi_user_je_category_name => c_user_jre_category_name
                                                              ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                              ,pi_actual_flag           => c_actual_flag));
          
          --we also need to update the log file with the new value
          --add data to log table update arrays
          l_xmgw_upd_wol_id_arr(l_xmgw_upd_wol_id_arr.COUNT + 1)      := l_commitment_data_arr(i).wol_id;
          l_xmgw_upd_commitmnt_value_arr(l_xmgw_upd_wol_id_arr.COUNT) := l_commitment_data_arr(i).wol_cost;
          
          --record credits/debits in file
          l_total_credits := l_total_credits + l_xmgw_rec.xmgw_commitment_value;
          l_total_debits  := l_total_debits + l_xmgw_rec.xmgw_commitment_value;
        
          l_write_wol_to_file := TRUE;
        END IF;
        
      EXCEPTION
        WHEN no_data_found
        THEN
          db('xmgw not found');
          --if we have a non-zero cost then add it to the log
          IF l_commitment_data_arr(i).wol_cost <> 0
          THEN
            --add new rec to log table insert array
            l_xmgw_rec.xmgw_wol_id              := l_commitment_data_arr(i).wol_id;
            l_xmgw_rec.xmgw_commitment_value    := l_commitment_data_arr(i).wol_cost;
            l_xmgw_rec.xmgw_user_last_processed := USER;
            l_xmgw_rec.xmgw_date_last_processed := SYSDATE;
            
            l_xmgw_ins_arr(l_xmgw_ins_arr.COUNT + 1) := l_xmgw_rec;
            
            l_write_wol_to_file := TRUE;
          END IF;
      END;
      
      -------------------------
      --write line for this wol
      -------------------------
      IF l_write_wol_to_file
        AND l_commitment_data_arr(i).wol_cost <> 0
      THEN
        db('writing lines');
        --write PandT line
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                            ,pi_cost                  => l_commitment_data_arr(i).wol_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => l_commitment_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_category_name
                                                            ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                            ,pi_actual_flag           => c_actual_flag));
        --write commitment line
        writeln(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                            ,pi_cost                  => -l_commitment_data_arr(i).wol_cost
                                                            ,pi_descr                 => l_line_descr
                                                            ,pi_cost_code             => c_mag_encumb_cost_code
                                                            ,pi_user_je_category_name => c_user_jre_category_name
                                                            ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                            ,pi_actual_flag           => c_actual_flag));
      
        --record credits/debits in file
        l_total_credits := l_total_credits + l_commitment_data_arr(i).wol_cost;
        l_total_debits  := l_total_debits + l_commitment_data_arr(i).wol_cost;
      END IF;
    END LOOP;

    -----------------
    --process inserts
    -----------------
    db('Inserting ' || l_xmgw_ins_arr.COUNT || ' records into xnor_may_gurney_wols');
    ins_all_xmgw(pi_xmgw_arr => l_xmgw_ins_arr);

    -----------------
    --process updates
    -----------------
    db('Updating ' || l_xmgw_upd_wol_id_arr.COUNT || ' records in xnor_may_gurney_wols');
    upd_all_xmgw_commitments(pi_xmgw_wol_id_arr           => l_xmgw_upd_wol_id_arr
                            ,pi_xmgw_commitment_value_arr => l_xmgw_upd_commitmnt_value_arr);

    ------------
    --close file
    ------------
    db('Closing file');
    nm3file.fclose(FILE => l_file_id);
    
    --------------------
    --write control file
    --------------------
    IF l_lines_written_to_file > 0
    THEN
      l_control_file_name := write_control_file(pi_file_path     => pi_file_path
                                               ,pi_file_name     => l_filename
                                               ,pi_total_lines   => l_lines_written_to_file
                                               ,pi_total_credits => l_total_credits
                                               ,pi_total_debits  => l_total_debits);
    END IF;
  ELSE
    l_filename := NULL;
    log_error('No work order lines match the report parameters so no file has been generated.');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_order_file');

  db('Returning ' || l_filename);
  
  RETURN l_filename;

EXCEPTION
  WHEN others
  THEN
    log_error(pi_error_msg => 'Unexpected error: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
             ,pi_fatal     => TRUE);
  
END generate_order_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_payment_file(pi_grr_job_id        IN     gri_report_runs.grr_job_id%TYPE
                               ,po_payment_filename     OUT varchar2
                               ,po_reversal_filename    OUT varchar2
                               ) IS

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_order_file');

  g_grr_job_id := pi_grr_job_id;
  
  generate_payment_file(pi_contract_id       => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'CONTRACT_ID')
                       ,pi_financial_year    => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'FINANCIAL_YEAR')
                       ,pi_start_date        => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'FROM_DATE')
                       ,pi_end_date          => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'TO_DATE')
                       ,pi_file_path         => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'TEXT')
                       ,pi_period_13         => higgrirp.get_parameter_value(a_job_id => pi_grr_job_id
                                                                            ,a_param  => 'PERIOD_13') = 'Y'
                       ,po_payment_filename  => po_payment_filename
                       ,po_reversal_filename => po_reversal_filename);
  
  g_grr_job_id := NULL;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_order_file');

END generate_payment_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_payment_file(pi_contract_id       IN     contracts.con_id%TYPE
                               ,pi_financial_year    IN     financial_years.fyr_id%TYPE
                               ,pi_start_date        IN     date
                               ,pi_end_date          IN     date
                               ,pi_file_path         IN     varchar2
                               ,pi_period_13         in     boolean
                               ,po_payment_filename     OUT varchar2
                               ,po_reversal_filename    OUT varchar2
                               ) IS
                               
  c_pay_run_id             CONSTANT work_order_lines.wol_cnp_id%TYPE := get_next_pay_run_id;
  
  c_claim_paid_status_code CONSTANT hig_status_codes.hsc_status_code%TYPE := get_claim_status_paid_code;
  
  c_tax_line_number constant varchar2(15) := to_char(sysdate, 'YYYYMMDDHH24MI');
  
  l_con_rec contracts%ROWTYPE;
  l_cnp_rec contract_payments%ROWTYPE;
  
  l_run_name varchar2(4000);
  
  l_payment_file_id  utl_file.file_type;
  l_reversal_file_id utl_file.file_type;
  
  l_reversal_control_filename varchar2(500);
  l_payment_control_filename  varchar2(500);
  
  l_payment_data_arr t_payment_data_arr;
  
  l_wols_to_set_paid_arr  t_wol_id_arr;
  l_claim_refs_to_upd_arr t_claim_ref_arr;
  l_values_paid_arr       nm3type.tab_number;
  l_payment_code_arr      t_payment_code_arr;
  
  l_write_wol_to_file boolean;
  
  l_accounting_date date;
  
  l_line_descr varchar2(4000);
  
  l_xmgw_rec xnor_may_gurney_wols%ROWTYPE;
  
  l_xmgw_ins_arr t_xmgw_arr;
  
  l_xmgw_upd_wol_id_arr        t_xmgw_wol_id_arr;
  l_xmgw_upd_payment_value_arr t_xmgw_payment_value_arr;
  
  l_payment_file_lines_arr nm3type.tab_varchar32767;

  l_payment_cost_code    budgets.bud_cost_code%TYPE;
  l_commitment_cost_code budgets.bud_cost_code%TYPE;
  
  l_lines_written_to_pay_file pls_integer := 0;
  l_lines_written_to_rev_file pls_integer := 0;
  
  l_total_invoice_amount number := 0;
  l_total_tax_amount     number := 0;
  
  l_pay_total_credits number := 0;
  l_pay_total_debits  number := 0;
  
  l_rev_total_credits number := 0;
  l_rev_total_debits  number := 0;
  
  PROCEDURE writeln_pay(pi_text IN varchar2
                       ) IS
  BEGIN
    nm3file.put_line(FILE   => l_payment_file_id
                    ,buffer => pi_text);
  
    l_lines_written_to_pay_file := l_lines_written_to_pay_file + 1;
  
  END writeln_pay;
  
  PROCEDURE writeln_rev(pi_text IN varchar2
                       ) IS
  BEGIN
    nm3file.put_line(FILE   => l_reversal_file_id
                    ,buffer => pi_text);
  
    l_lines_written_to_rev_file := l_lines_written_to_rev_file + 1;
  
  END writeln_rev;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_payment_file');
  
  db(g_package_name || '.generate_payment_file');
  db('  pi_contract_id    = ' || pi_contract_id);
  db('  pi_financial_year = ' || pi_financial_year);
  db('  pi_start_date     = ' || TO_CHAR(pi_start_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_end_date       = ' || TO_CHAR(pi_end_date, 'dd-mon-yyyy hh24:mi:ss'));
  db('  pi_file_path      = ' || pi_file_path);

  --check contract exists and get details
  l_con_rec := get_con(pi_contract_id => pi_contract_id);
  db('Contract Code = ' || l_con_rec.con_code);
  
  --get the relavant data
  l_payment_data_arr := get_payment_data(pi_contract_id    => pi_contract_id
                                        ,pi_financial_year => pi_financial_year
                                        ,pi_start_date     => pi_start_date
                                        ,pi_end_date       => pi_end_date);
  
  db('Found ' || l_payment_data_arr.COUNT || ' records to process.');
  
  IF l_payment_data_arr.COUNT > 0
  THEN
    --we have records to process
    
    l_run_name := generate_run_name(pi_run_subject=> l_con_rec.con_code);
    db('Run Name = ' || l_run_name);
    
    --open the payment file
    po_payment_filename := generate_filename(pi_run_name  => l_run_name
                                            ,pi_file_type => c_payments_file_type);
    db('Payment filename = ' || po_payment_filename);
    
    l_payment_file_id := open_output_file(pi_file_path => pi_file_path
                                         ,pi_filename  => po_payment_filename);
  
    --open the reversal file
    po_reversal_filename := generate_filename(pi_run_name  => l_run_name
                                             ,pi_file_type => c_reversal_file_type);
    db('Reversal filename = ' || po_reversal_filename);
    
    l_reversal_file_id := open_output_file(pi_file_path => pi_file_path
                                          ,pi_filename  => po_reversal_filename);
  
    --which date do we use in the output file?
    l_accounting_date := xnor_financial_interface.get_accounting_date(pi_period_13 => pi_period_13);
    
    -------------------------
    --process the wol records
    -------------------------
    FOR i IN 1..l_payment_data_arr.COUNT
    LOOP
      db('Record ' || i || ' = ' ||        l_payment_data_arr(i).wol_act_cost
                                 || ':' || l_payment_data_arr(i).wol_id
                                 || ':' || l_payment_data_arr(i).works_order_no
                                 || ':' || TO_CHAR(l_payment_data_arr(i).wor_date_closed, 'dd-mon-yyyy hh24:mi:ss')
                                 || ':' || l_payment_data_arr(i).budget_cost_code
                                 || ':' || l_payment_data_arr(i).bud_id
                                 || ':' || l_payment_data_arr(i).defect_id);
      
      l_write_wol_to_file := FALSE;
      
      ------------------------------------
      --get some information for this line
      ------------------------------------
      --accounting date now set above for whole file
        --l_accounting_date := get_accounting_date(pi_date_order_raised    => SYSDATE
        --                                        ,pi_order_financial_year => pi_financial_year);
      
      l_line_descr := get_line_description(pi_works_order_no => l_payment_data_arr(i).works_order_no
                                          ,pi_wol_id         => l_payment_data_arr(i).wol_id
                                          ,pi_defect_id      => l_payment_data_arr(i).defect_id);
      
      l_payment_cost_code := interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).budget_cost_code
                                                       ,p_number    => c_pandt_cost_code_pos);
      
      l_commitment_cost_code := interfaces.split_cost_code(p_cost_code => l_payment_data_arr(i).budget_cost_code
                                                          ,p_number    => c_pandt_cost_code_pos);
      
      --get log record for this wol
      BEGIN
        l_xmgw_rec := get_xmgw(pi_wol_id => l_payment_data_arr(i).wol_id);
        
        db('Found log record for wol_id ' || l_payment_data_arr(i).wol_id
           || ', comitment value = ' || l_xmgw_rec.xmgw_commitment_value);
        
        ---------------------------------
        --check values against log record
        ---------------------------------
        IF NVL(l_xmgw_rec.xmgw_commitment_value, 0) <> 0
        THEN
          --we need to generate a reversal record for the commitment value
          writeln_rev(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                                  ,pi_cost                  => -l_xmgw_rec.xmgw_commitment_value
                                                                  ,pi_descr                 => l_line_descr
                                                                  ,pi_cost_code             => l_commitment_cost_code
                                                                  ,pi_user_je_category_name => c_user_jre_category_name
                                                                  ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                  ,pi_actual_flag           => c_actual_flag));
          writeln_rev(xnor_financial_interface.get_commitment_line(pi_accounting_date       => l_accounting_date
                                                                  ,pi_cost                  => l_xmgw_rec.xmgw_commitment_value
                                                                  ,pi_descr                 => l_line_descr
                                                                  ,pi_cost_code             => c_mag_encumb_cost_code
                                                                  ,pi_user_je_category_name => c_user_jre_category_name
                                                                  ,pi_encumbrance_type_id   => c_encumbrance_type_id
                                                                  ,pi_actual_flag           => c_actual_flag));
        
          --record credits/debits in reversal file
          l_rev_total_credits := l_rev_total_credits + l_xmgw_rec.xmgw_commitment_value;
          l_rev_total_debits  := l_rev_total_debits + l_xmgw_rec.xmgw_commitment_value;
        END IF;                                                            
        
        --update the log file with the payment value
        --add data to log table update arrays
        l_xmgw_upd_wol_id_arr(l_xmgw_upd_wol_id_arr.COUNT + 1)    := l_payment_data_arr(i).wol_id;
        l_xmgw_upd_payment_value_arr(l_xmgw_upd_wol_id_arr.COUNT) := l_payment_data_arr(i).wol_act_cost;
        
      EXCEPTION
        WHEN no_data_found
        THEN
          --if we have a non-zero cost then add it to the log
          db('WOL ID not alredy logged - ' || l_payment_data_arr(i).wol_id);
          IF l_payment_data_arr(i).wol_act_cost <> 0
          THEN
            --add new rec to log table insert array
            l_xmgw_rec.xmgw_wol_id              := l_payment_data_arr(i).wol_id;
            l_xmgw_rec.xmgw_payment_value       := l_payment_data_arr(i).wol_act_cost;
            l_xmgw_rec.xmgw_user_last_processed := USER;
            l_xmgw_rec.xmgw_date_last_processed := SYSDATE;
            
            l_xmgw_ins_arr(l_xmgw_ins_arr.COUNT + 1) := l_xmgw_rec;
          END IF;      
      END;

      ----------------------
      --generate a file line
      ----------------------
      IF l_payment_data_arr(i).wol_act_cost > 0
      THEN
        --keep track of the total invoice amount
        l_total_invoice_amount := l_total_invoice_amount + l_payment_data_arr(i).wol_act_cost;

        --write invoice line to array
        l_payment_file_lines_arr(l_payment_file_lines_arr.COUNT + 1)                          
            := get_payment_line(pi_invoice_no      => l_run_name
                               ,pi_line_no         => l_payment_data_arr(i).wol_id
                               ,pi_line_type       => c_payment_line_type_item
                               ,pi_invoice_amount  => l_payment_data_arr(i).wol_act_cost
                               ,pi_accounting_date => SYSDATE
                               ,pi_line_descr      => l_line_descr
                               ,pi_tax_code        => c_vat_tax_code
                               ,pi_cost_code       => xnor_financial_interface.get_full_accounting_code(pi_cost_code => l_payment_cost_code));
      END IF;
      
      --set values which will be used to update the work order/claim/payment details
      l_wols_to_set_paid_arr(l_wols_to_set_paid_arr.COUNT + 1)   := l_payment_data_arr(i).wol_id;
      l_claim_refs_to_upd_arr(l_claim_refs_to_upd_arr.COUNT + 1) := l_payment_data_arr(i).woc_claim_ref;
      l_values_paid_arr(l_values_paid_arr.COUNT + 1)             := l_payment_data_arr(i).wol_act_cost;
      l_payment_code_arr(l_payment_code_arr.COUNT + 1)
        := get_payment_code(pi_wor_coc_cost_centre => l_payment_data_arr(i).wor_coc_cost_centre
                           ,pi_functional_act      => get_functional_act(pi_rechar => l_payment_data_arr(i).def_rechar_org_id)
                           ,pi_wol_siss_id         => l_payment_data_arr(i).wol_siss_id
                           ,pi_cost_code           => l_con_rec.con_cost_code
                           ,pi_wor_job_number      => l_payment_data_arr(i).wor_job_number
                           ,pi_rse_link_code       => l_payment_data_arr(i).rse_link_code);
      
    END LOOP;
  
    -----------------
    --process inserts
    -----------------
    db('Inserting ' || l_xmgw_ins_arr.COUNT || ' records into xnor_may_gurney_wols');
    ins_all_xmgw(pi_xmgw_arr => l_xmgw_ins_arr);

    -----------------
    --process updates
    -----------------
    db('Updating ' || l_xmgw_upd_wol_id_arr.COUNT || ' records in xnor_may_gurney_wols');
    upd_all_xmgw_payments(pi_xmgw_wol_id_arr        => l_xmgw_upd_wol_id_arr
                         ,pi_xmgw_payment_value_arr => l_xmgw_upd_payment_value_arr);
  
    -------------------------------------------------------------------
    --standard payment run processing
    --  This is based on the functionality in maiwo.process_payment_run
    -------------------------------------------------------------------
    db('Setting claim payments to ' || c_claim_paid_status_code);
    FORALL i IN 1..l_wols_to_set_paid_arr.COUNT
      UPDATE
        claim_payments cp
      SET
        cp.cp_payment_date  = SYSDATE,
        cp.cp_payment_id    = c_pay_run_id,
        cp.cp_status        = c_claim_paid_status_code,
        cp.cp_payment_value = l_values_paid_arr(i)
      WHERE
        cp.cp_wol_id = l_wols_to_set_paid_arr(i)
      AND
        cp.cp_woc_claim_ref = l_claim_refs_to_upd_arr(i)
      AND
        cp.cp_woc_con_id = pi_contract_id;  
    
    db('Setting ' || l_wols_to_set_paid_arr.COUNT || ' wols to ' || c_wol_status_paid);
    FORALL i IN 1..l_wols_to_set_paid_arr.COUNT
      UPDATE
        work_order_lines wol
      SET
        wol.wol_cnp_id         = c_pay_run_id,
        wol.wol_status_code    = c_wol_status_paid,
        wol.wol_invoice_status = maiwo.wol_invoice_status(l_wols_to_set_paid_arr(i)),
        wol.wol_date_paid      = SYSDATE,
        wol_payment_code       = l_payment_code_arr(i)
      WHERE
        wol.wol_id = l_wols_to_set_paid_arr(i);
    
    l_total_tax_amount := l_total_invoice_amount * (c_vat_rate / 100);
    db('l_total_invoice_amount = ' || l_total_invoice_amount);
    db('l_total_tax_amount     = ' || l_total_tax_amount);
    
    --create a claim_payments record
    db('Creating contract_payments record cnp_id = ' || c_pay_run_id);
    l_cnp_rec.cnp_id               := c_pay_run_id;
    l_cnp_rec.cnp_con_id           := pi_contract_id;
    l_cnp_rec.cnp_run_date         := SYSDATE;
    l_cnp_rec.cnp_username         := USER;
    l_cnp_rec.cnp_first_payment_no := get_first_payment_details(pi_contract_id => pi_contract_id
                                                               ,pi_pay_run_id  => c_pay_run_id);
    l_cnp_rec.cnp_last_payment_no  := NVL(l_con_rec.con_last_payment_no, 0);
    l_cnp_rec.cnp_total_value      := l_total_invoice_amount;
    l_cnp_rec.cnp_vat_amount       := l_total_tax_amount;
    l_cnp_rec.cnp_retention_amount := get_retention_amount(pi_con_rec       => l_con_rec
                                                          ,pi_invoice_total => l_total_invoice_amount);
    l_cnp_rec.cnp_amount           := l_total_invoice_amount - l_cnp_rec.cnp_retention_amount + l_total_tax_amount;
    
    ins_cnp(pi_cnp_rec => l_cnp_rec);

    --update the contract
    update_contract_details(pi_con_rec          => l_con_rec
                           ,pi_financial_year   => pi_financial_year
                           ,pi_run_id           => c_pay_run_id
                           ,pi_invoice_value    => l_total_invoice_amount
                           ,pi_retention_amount => l_cnp_rec.cnp_retention_amount);
    
    ------------------------------
    --write the payment file lines
    ------------------------------
    db('Writing ' || l_payment_file_lines_arr.COUNT || ' lines to the payment file');
    IF l_payment_file_lines_arr.COUNT > 0
    THEN
      --write header
      writeln_pay(get_payment_header_line(pi_invoice_no            => l_run_name
                                         ,pi_invoice_amount        => l_total_invoice_amount + l_total_tax_amount
                                         ,pi_invoice_date          => SYSDATE
                                         ,pi_invoice_received_date => SYSDATE
                                         ,pi_gl_date               => SYSDATE
                                         ,pi_invoice_descr         => l_run_name));
    
      --write lines
      FOR i IN 1..l_payment_file_lines_arr.COUNT
      LOOP
        writeln_pay(l_payment_file_lines_arr(i));
      END LOOP;
      
      --write tax line
      writeln_pay(get_payment_line(pi_invoice_no      => l_run_name
                                  ,pi_line_no         => c_tax_line_number
                                  ,pi_line_type       => c_payment_line_type_tax
                                  ,pi_invoice_amount  => l_total_tax_amount
                                  ,pi_accounting_date => SYSDATE
                                  ,pi_line_descr      => l_line_descr
                                  ,pi_tax_code        => c_vat_tax_code
                                  ,pi_cost_code       => xnor_financial_interface.get_full_accounting_code(pi_cost_code => c_vat_cost_code)));
    END IF;

    -------------
    --close files
    -------------
    db('Closing files');
    nm3file.fclose(FILE => l_payment_file_id);
    nm3file.fclose(FILE => l_reversal_file_id);
    
    ---------------------
    --write control files
    ---------------------
    IF l_lines_written_to_rev_file > 0
    THEN
      l_reversal_control_filename := write_control_file(pi_file_path     => pi_file_path
                                                       ,pi_file_name     => po_reversal_filename
                                                       ,pi_total_lines   => l_lines_written_to_rev_file
                                                       ,pi_total_credits => l_rev_total_credits
                                                       ,pi_total_debits  => l_rev_total_debits);
    END IF;
    
    IF l_lines_written_to_pay_file > 0
    THEN
      l_payment_control_filename := write_control_file(pi_file_path     => pi_file_path
                                                      ,pi_file_name     => po_payment_filename
                                                      ,pi_total_lines   => l_lines_written_to_pay_file
                                                      ,pi_total_credits => 0
                                                      ,pi_total_debits  => l_total_invoice_amount + l_total_tax_amount);
    END IF;
  ELSE
    log_error('No work order lines match the report parameters so no file has been generated.');
  END IF;
    
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_payment_file');

EXCEPTION
  WHEN others
  THEN
    log_error(pi_error_msg => 'Unexpected error: ' || DBMS_UTILITY.FORMAT_ERROR_STACK
             ,pi_fatal     => TRUE);
  
END generate_payment_file;
--
-----------------------------------------------------------------------------
--
END xnor_may_gurney_interface;
/

