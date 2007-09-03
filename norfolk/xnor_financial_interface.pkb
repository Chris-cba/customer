CREATE OR REPLACE PACKAGE BODY xnor_financial_interface
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/norfolk/xnor_financial_interface.pkb-arc   2.0   Sep 03 2007 10:30:10   dyounger  $
--       Module Name      : $Workfile:   xnor_financial_interface.pkb  $
--       Date into PVCS   : $Date:   Sep 03 2007 10:30:10  $
--       Date fetched Out : $Modtime:   Sep 02 2007 10:53:56  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--   xnor_financial_interface body
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

  g_package_name CONSTANT varchar2(30) := 'xnor_financial_interface';

  c_sep                        CONSTANT varchar2(1) := ',';
  
  c_csv_date_format            CONSTANT varchar2(11) := 'DD-MON-YYYY';
  
  c_currency_code              CONSTANT varchar2(3) := 'GBP';
  
  c_csv_currency_format        CONSTANT varchar2(13) := 'FM99999990.00';

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
FUNCTION get_full_accounting_code(pi_cost_code IN varchar2
                                 ) RETURN varchar2 IS

  l_cost_code varchar2(4000) := pi_cost_code;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_full_accounting_code');

  IF SUBSTR(l_cost_code, 1, 3) = '10-'
  THEN
    l_cost_code :=substr(l_cost_code, 4);
  END IF;
  
  IF SUBSTR(l_cost_code, LENGTH(l_cost_code), 1) = '-'
  THEN
    l_cost_code := substr(l_cost_code, 1, length(l_cost_code) - 1);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_full_accounting_code');

  RETURN interfaces.reformat_cost_code(p_cost_code => l_cost_code);

END get_full_accounting_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_commitment_line(pi_accounting_date       IN date
                            ,pi_cost                  IN work_order_lines.wol_est_cost%TYPE
                            ,pi_descr                 IN varchar2
                            ,pi_cost_code             IN varchar2
                            ,pi_user_je_category_name in varchar2
                            ,pi_encumbrance_type_id   in number
                            ,pi_actual_flag           in varchar2
                            ,pi_part_cost_code        in boolean default true
                            ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;
  
  l_entered_cr work_order_lines.wol_est_cost%TYPE;
  l_entered_dr work_order_lines.wol_est_cost%TYPE;
  
  l_accounting_code varchar2(4000);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_commitment_line');

  IF pi_cost > 0
  THEN
    l_entered_dr := pi_cost;
  ELSE
    l_entered_cr := -pi_cost;
  END IF;
  
  if pi_part_cost_code
  then
    l_accounting_code := get_full_accounting_code(pi_cost_code => pi_cost_code);
  else
    l_accounting_code := pi_cost_code;
  end if;
  
  l_retval :=             'GLJEH01'                                       --record_type
              || c_sep || 'NEW'                                           --status
              || c_sep || '1'                                             --set_of_books_id
              || c_sep || TO_CHAR(pi_accounting_date, c_csv_date_format)  --accounting_date
              || c_sep || c_currency_code                                 --curreny_code
              || c_sep || NULL                                            --date_created
              || c_sep || NULL                                            --created_by
              || c_sep || pi_actual_flag                                  --actual_flag
              || c_sep || pi_user_je_category_name                        --user_je_category_name
              || c_sep || 'NCC HMS'                                       --user_je_source_name
              || c_sep || NULL                                            --currency_conversion_date
              || c_sep || pi_encumbrance_type_id                          --encumbrance_type_id
              || c_sep || NULL                                            --budget_version_id
              || c_sep || NULL                                            --user_currency_conversion_type
              || c_sep || NULL                                            --currency_conversion_rate
              || c_sep || NULL                                            --average_journal_flag
              || c_sep || NULL                                            --originating_bal_seg_value
              || c_sep || NULL                                            --segment1
              || c_sep || NULL                                            --segment2
              || c_sep || NULL                                            --segment3
              || c_sep || NULL                                            --segment4
              || c_sep || NULL                                            --segment5
              || c_sep || NULL                                            --segment6
              || c_sep || NULL                                            --segment7
              || c_sep || TO_CHAR(l_entered_dr, c_csv_currency_format)    --entered_dr
              || c_sep || TO_CHAR(l_entered_cr, c_csv_currency_format)    --entered_cr
              || c_sep || NULL                                            --accounted_dr
              || c_sep || NULL                                            --accounted_cr
              || c_sep || NULL                                            --transaction_date
              || c_sep || NULL                                            --reference1
              || c_sep || NULL                                            --reference2
              || c_sep || NULL                                            --reference4
              || c_sep || NULL                                            --reference5
              || c_sep || NULL                                            --reference6
              || c_sep || NULL                                            --reference7
              || c_sep || NULL                                            --reference8
              || c_sep || pi_descr                                        --reference10
              || c_sep || NULL                                            --reference11
              || c_sep || NULL                                            --reference12
              || c_sep || NULL                                            --reference13
              || c_sep || NULL                                            --reference14
              || c_sep || NULL                                            --reference15
              || c_sep || NULL                                            --reference16
              || c_sep || NULL                                            --reference17
              || c_sep || NULL                                            --reference18
              || c_sep || NULL                                            --reference19
              || c_sep || NULL                                            --reference20
              || c_sep || NULL                                            --period_name
              || c_sep || NULL                                            --je_line_num
              || c_sep || NULL                                            --chart_of_accounts_id
              || c_sep || NULL                                            --code_combination_id
              || c_sep || NULL                                            --stat_amount
              || c_sep || NULL                                            --group_id
              || c_sep || l_accounting_code;                              --attribute1

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_commitment_line');

  RETURN l_retval;

END get_commitment_line;
--
-----------------------------------------------------------------------------
--
procedure write_ctrl_file(pi_filename      in varchar2
                         ,pi_filepath      in varchar2
                         ,pi_total_lines   in pls_integer
                         ,pi_total_credits in number
                         ,pi_total_debits  in number
                         ) IS
  
  c_ctrl_filepath constant varchar2(2000) := pi_filepath;
  c_ctrl_filename constant varchar2(2000) := pi_filename || '.CTL';

  l_lines nm3type.tab_varchar32767;
        
begin
 l_lines(l_lines.count + 1) := 'Highways Financial Interface';
 l_lines(l_lines.count + 1) := '';
 l_lines(l_lines.count + 1) := 'Control information for file ' || pi_filename;
 l_lines(l_lines.count + 1) := '';
 l_lines(l_lines.count + 1) := '================================================================';
 l_lines(l_lines.count + 1) := 'Lines in file: ' || to_char(pi_total_lines);
 l_lines(l_lines.count + 1) := '';
 l_lines(l_lines.count + 1) := 'Total credits: ' || to_char(pi_total_credits, c_csv_currency_format);
 l_lines(l_lines.count + 1) := '';
 l_lines(l_lines.count + 1) := 'Total debits : ' || to_char(pi_total_debits, c_csv_currency_format);
 l_lines(l_lines.count + 1) := '';
 l_lines(l_lines.count + 1) := '================================================================';

  nm3file.write_file(location  => c_ctrl_filepath
                    ,filename  => c_ctrl_filename
                    ,all_lines => l_lines);
                              
end write_ctrl_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_accounting_date(pi_period_13 in boolean
                            ) RETURN date IS

  l_retval date;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_accounting_date');

  if pi_period_13
  then
    --period 13 option set so use end of March this year
    l_retval := to_date('31-MAR-' || to_char(sysdate, 'YYYY'), 'DD-MON-YYYY');
  else
    --otherwise use current date
    l_retval := sysdate;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_accounting_date');

  RETURN l_retval;

END get_accounting_date;

    

END xnor_financial_interface;
/
