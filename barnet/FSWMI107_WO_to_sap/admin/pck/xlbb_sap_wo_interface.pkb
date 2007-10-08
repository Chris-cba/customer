CREATE OR REPLACE PACKAGE BODY xlbb_sap_wo_interface
AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/barnet/xlbb_sap_wo_interface.pkb-arc   2.0   Oct 08 2007 11:41:48   smarshall  $
--       Module Name      : $Workfile:   xlbb_sap_wo_interface.pkb  $
--       Date into PVCS   : $Date:   Oct 08 2007 11:41:48  $
--       Date fetched Out : $Modtime:   Oct 08 2007 10:47:38  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--   xlbb_sap_wo_interface body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
--all global package variables here

  -------
  --types
  -------
  TYPE t_xswl_arr IS TABLE OF xlbb_sap_wo_log%ROWTYPE INDEX BY PLS_INTEGER;
  
  type t_extract_wor_data_rec is record(works_order_no work_orders.wor_works_order_no%type
                                       ,wo_priority         work_orders.wor_priority%type
                                       ,est_cost            number
                                       ,wo_descr            work_orders.wor_descr%type
                                       ,contractor_code     org_units.oun_unit_code%type
                                       ,contract_code       contracts.con_code%type
                                       ,cost_centre         work_orders.wor_coc_cost_centre%type
                                       ,instructed_date     work_orders.wor_date_confirmed%type
                                       ,target_date         work_orders.wor_est_complete%type
                                       ,functional_location road_segs.rse_usrn_no%type
                                       ,activity_code       defects.def_atv_acty_area_code%type
                                       ,icb_work_code       work_order_lines.wol_icb_work_code%TYPE);
  type t_extract_wor_data_arr is table of t_extract_wor_data_rec INDEX BY PLS_INTEGER;

  type t_extract_op_data_rec is record(wol_id         work_order_lines.wol_id%type
                                      ,boq_id         boq_items.boq_id%type
                                      ,operation_no   pls_integer
                                      ,sta_item_code  boq_items.boq_sta_item_code%type
                                      ,sta_item_name  standard_items.sta_item_name%type
                                      ,activity_code  defects.def_atv_acty_area_code%type
                                      ,boq_quantity   boq_items.boq_est_quantity%type
                                      ,boq_cost       number
                                      ,boq_unit       standard_items.sta_unit%type
                                      ,boq_unit_price boq_items.boq_act_rate%type
                                      ,usrn_no        road_segs.rse_usrn_no%type
                                      ,icb_work_code  work_order_lines.wol_icb_work_code%TYPE);
  type t_extract_op_data_arr is table of t_extract_op_data_rec INDEX BY PLS_INTEGER;

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid                CONSTANT varchar2(2000) := '"$Revision:   2.0  $"';

  g_package_name               CONSTANT varchar2(30) := 'xlbb_sap_wo_interface';
  
  c_default_error_code         CONSTANT PLS_INTEGER := -20000;
  
  c_sep                        constant varchar2(1) := '|';
  
  c_file_path                  constant varchar2(100) := hig.get_user_or_sys_opt('INTERPATH');
  
  c_sending_system             constant varchar2(3) := 'ATL';
  c_receiving_system           constant varchar2(3) := 'SAP';
  c_interface_type             constant varchar2(3) := 'WOC';
  
  c_run_no_length              constant pls_integer := 6;
  
  c_file_date_format           CONSTANT varchar2(11) := 'DD.MM.YYYY';
  --c_file_currency_format        CONSTANT varchar2(13) := 'FM99999990.00';
  
  c_record_type_batch_header   constant varchar2(1) := 'B';
  c_record_type_order_header   constant varchar2(1) := '1';
  c_record_type_operation_line constant varchar2(1) := '2';
  c_record_type_batch_trailer  constant varchar2(1) := 'T';
  
  c_dlo_con_code               constant org_units.oun_unit_code%type := 'DLO';
  
  c_op_line_limit              constant pls_integer := 999;
  
  -----------
  --variables
  -----------
  g_grr_job_id gri_report_runs.grr_job_id%TYPE;

  g_debug_on BOOLEAN := FALSe;
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
procedure set_debug(pi_on in boolean default true
                   ) is
begin
  if pi_on
  then
    Nm_Debug.debug_on;
    g_debug_on := TRUE;
  else
    nm_debug.debug_off;
    g_debug_on := FALSE;
  end if;

end set_debug;
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
FUNCTION get_extract_wor_data RETURN t_extract_wor_data_arr IS

  l_retval t_extract_wor_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_extract_wor_data');

  select
    wor.wor_works_order_no,
    wor.wor_priority,
    sum(boq.boq_est_cost),
    wor.wor_descr,
    oun.oun_unit_code,
    con.con_code,
    wor.wor_coc_cost_centre,
    wor.wor_date_confirmed,
    wor.wor_est_complete,
    NULL,
    NULL,
    NULL
  bulk collect into
     l_retval
  from
    work_orders wor,
    work_order_lines wol,
    boq_items   boq,
    org_units   oun,
    contracts   con
  where
    wor.wor_con_id = con.con_id
  and
    con.con_contr_org_id = oun.oun_org_id
  and
    wol.wol_works_order_no = wor.wor_works_order_no
  and
    boq.boq_wol_id = wol.wol_id 
  and
    not exists (select
                  1
                from
                  xlbb_sap_wo_log xswl
                where
                  xswl.xswl_works_order_no = wor.wor_works_order_no)
 group by
   wor.wor_works_order_no,
   wor.wor_priority,
   wor.wor_descr,
   oun.oun_unit_code,
   con.con_code,
   wor.wor_coc_cost_centre,
   wor.wor_date_confirmed,
   wor.wor_est_complete;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_extract_wor_data');

  RETURN l_retval;

END get_extract_wor_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_extract_op_data(pi_works_order_no work_orders.wor_works_order_no%type
                             ) RETURN t_extract_op_data_arr IS

  l_retval t_extract_op_data_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_extract_op_data');

  select
    wol_id,
    boq.boq_id,
    rownum * 10,
    boq.boq_sta_item_code,
    sta.sta_item_name,
    def.def_atv_acty_area_code,
    nvl(boq.boq_act_quantity, boq.boq_est_quantity) quantity,
    nvl(boq.boq_act_cost, boq.boq_est_cost) cost,
    sta.sta_unit,
    nvl(boq.boq_act_rate, boq.boq_est_rate) unit_price,
    case ne.ne_nt_type
      when 'L'    then ne.ne_number
      when 'LLNK' then ne.ne_name_1
    end usrn_no,
    wol.wol_icb_work_code
  bulk collect into
    l_retval
  from
    work_order_lines wol,
    boq_items        boq,
    nm_elements      ne,
    defects          def,
    standard_items   sta
  where
    wol.wol_works_order_no = pi_works_order_no
  and
    wol.wol_id = boq.boq_wol_id (+)
  and
    ne.ne_id (+) = wol.wol_rse_he_id 
  and
    wol.wol_def_defect_id = def.def_defect_id (+)
  and
    sta.sta_item_code = boq.boq_sta_item_code;
    
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_extract_op_data');

  RETURN l_retval;

END get_extract_op_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_all_xswl(pi_xswl_arr IN t_xswl_arr
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ins_all_xswl');

  FORALL i IN 1..pi_xswl_arr.COUNT
    INSERT INTO
      xlbb_sap_wo_log
    VALUES
      pi_xswl_arr(i);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ins_all_xswl');

END ins_all_xswl;
--
-----------------------------------------------------------------------------
--
FUNCTION get_run_number RETURN xlbb_sap_wo_control.xswc_last_run_sequence%type IS

  e_already_locked exception;
  pragma exception_init(e_already_locked, -54);
  
  l_retval xlbb_sap_wo_control.xswc_last_run_sequence%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_run_number');

  select
    xswc.xswc_last_run_sequence + 1
  into
    l_retval
  from
    xlbb_sap_wo_control xswc
  for update nowait;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_run_number');

  RETURN l_retval;

exception
  when too_many_rows
  then
    --more than one control row exists
    log_error(pi_error_msg => 'More than one control row exists (in XLBB_SAP_WO_CONTROL)'
             ,pi_fatal     => TRUE);
    
  when no_data_found
  then
    --no control row exists
    log_error(pi_error_msg => 'No control row exists (in XLBB_SAP_WO_CONTROL)'
             ,pi_fatal     => TRUE);
  
  when e_already_locked
  then
    --another user must be running the extract
    log_error(pi_error_msg => 'another user is running the extract'
             ,pi_fatal     => TRUE);

END get_run_number;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_control_data IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'update_control_data');

  update
    xlbb_sap_wo_control xswc
  set
    xswc.xswc_last_run_sequence = xswc.xswc_last_run_sequence + 1,
    xswc.xswc_last_run_date     = sysdate,
    xswc.xswc_last_run_user     = user;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'update_control_data');

END update_control_data;
--
-----------------------------------------------------------------------------
--
FUNCTION generate_file_name(pi_run_number in xlbb_sap_wo_control.xswc_last_run_sequence%type
                           ) RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_file_name');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_file_name');

  RETURN    c_sending_system
         || '_2_'
         || c_receiving_system
         || '_'
         || c_interface_type
         || '_'
         || lpad(to_char(pi_run_number), c_run_no_length, '0')
         || '.txt';

END generate_file_name;
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
PROCEDURE write_batch_header(pi_file_id in utl_file.file_type
                            ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'write_batch_header');

  nm3file.put_line(FILE   => pi_file_id
                  ,BUFFER => c_record_type_batch_header);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'write_batch_header');

END write_batch_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_batch_trailer(pi_file_id        in utl_file.file_type
                             ,pi_orders_in_file in pls_integer
                             ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'write_batch_trailer');

  nm3file.put_line(FILE   => pi_file_id
                  ,BUFFER =>             c_record_type_batch_trailer
                             || c_sep || to_char(pi_orders_in_file));

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'write_batch_trailer');

END write_batch_trailer;
--
-----------------------------------------------------------------------------
--
FUNCTION get_order_header_line(pi_extract_wor_data_rec t_extract_wor_data_rec
                              ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;
  
  l_desc varchar2(40);
  l_long_desc nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_order_header_line');

  if length(pi_extract_wor_data_rec.wo_descr) > 40
  then
    l_desc      := NULL;
    l_long_desc := pi_extract_wor_data_rec.wo_descr;
  else
    l_desc      := pi_extract_wor_data_rec.wo_descr;
    l_long_desc := NULl;
  end if;

  l_retval :=             c_record_type_order_header                                           --recrod type
              || c_sep || NULL                                                                 --order no
              || c_sep || pi_extract_wor_data_rec.contract_code                                --order type;
              || c_sep || pi_extract_wor_data_rec.wo_priority                                  --priority
              || c_sep || pi_extract_wor_data_rec.works_order_no                               --notification (HAMS Order No)
              || c_sep || pi_extract_wor_data_rec.est_cost                                     --costs
              || c_sep || '1000'                                                               --planning plant
              || c_sep || l_desc                                                               --order description
              || c_sep || l_long_desc                                                          --order long text
              || c_sep || pi_extract_wor_data_rec.contractor_code                               --planner group
              || c_sep || pi_extract_wor_data_rec.cost_centre                                  --main work centre
              || c_sep || pi_extract_wor_data_rec.activity_code                                --pm activity type
              || c_sep || to_char(pi_extract_wor_data_rec.instructed_date, c_file_date_format) --basic start
              || c_sep || to_char(pi_extract_wor_data_rec.target_date, c_file_date_format)     --basic finish
              || c_sep || pi_extract_wor_data_rec.functional_location                          --functional location
              || c_sep || NULL                                                                 --equipment
              || c_sep || pi_extract_wor_data_rec.cost_centre                                  --category
              || c_sep || pi_extract_wor_data_rec.icb_work_code                                --settlement receiver
              || c_sep || '100'                                                                --%
              || c_sep || 'PER'                                                                --settlement type
              || c_sep || '10'                                                                 --source assignment
              || c_sep || '10'                                                                 --no
              || c_sep || pi_extract_wor_data_rec.contractor_code                              --partner type
              || c_sep || pi_extract_wor_data_rec.contractor_code;                             --vendor number

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_order_header_line');

  RETURN l_retval;

END get_order_header_line;
--
-----------------------------------------------------------------------------
--
FUNCTION get_operation_line(pi_extract_op_data_rec t_extract_op_data_rec
                           ,pi_contractor_code     org_units.oun_unit_code%type
                           ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;
  
  l_desc varchar2(40);
  l_long_desc nm3type.max_varchar2;
  
  l_quantity    nm3type.max_varchar2;
  l_unit        nm3type.max_varchar2;
  l_gross_price nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_operation_line');

  if length(pi_extract_op_data_rec.sta_item_name) > 40
  then
    l_desc      := NULL;
    l_long_desc := pi_extract_op_data_rec.sta_item_name;
  else
    l_desc      := pi_extract_op_data_rec.sta_item_name;
    l_long_desc := NULl;
  end if;
  
  --set fields based on contrator
  IF pi_contractor_code = c_dlo_con_code
  then
    l_quantity    := pi_extract_op_data_rec.boq_quantity;
    l_unit        := pi_extract_op_data_rec.boq_unit;
    l_gross_price := pi_extract_op_data_rec.boq_unit_price;
  else
    l_quantity    := pi_extract_op_data_rec.boq_cost;
    l_unit        := 'SUM';
    l_gross_price := '1';
  end if;
  
  l_retval :=             c_record_type_operation_line          --record type
              || c_sep || pi_extract_op_data_rec.operation_no   --operation no
              || c_sep || pi_contractor_code                    --work centre
              || c_sep || '1000'                                --plant
              || c_sep || pi_contractor_code                    --control key
              || c_sep || pi_extract_op_data_rec.sta_item_code  --standard text key
              || c_sep || l_desc                                --operation short text
              || c_sep || l_long_desc                           --operation long text
              || c_sep || pi_extract_op_data_rec.activity_code  --material group
              || c_sep || '231'                                 --purchase group
              || c_sep || '1000'                                --plant
              || c_sep || pi_contractor_code                    --vendor
              || c_sep || l_quantity                            --quantity
              || c_sep || l_unit                                --unit
              || c_sep || l_gross_price;                        --gross price

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_operation_line');

  RETURN l_retval;

END get_operation_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_wo_interface_file(pi_grr_job_id       IN     gri_report_runs.grr_job_id%TYPE
                                    ,po_extract_filename    OUT varchar2
                                    ,po_log_filename        OUT varchar2
                                    ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_wo_interface_file');

  db('generate_wo_interface_file job id = ' || pi_grr_job_id);
  
  g_grr_job_id := pi_grr_job_id;
  
  generate_wo_interface_file(po_extract_filename => po_extract_filename
                            ,po_log_filename     => po_log_filename);

  g_grr_job_id := NULL;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_wo_interface_file');

END generate_wo_interface_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_wo_interface_file(po_extract_filename    OUT varchar2
                                    ,po_log_filename        OUT varchar2
                                    ) IS

  l_extract_wor_data_arr t_extract_wor_data_arr;
  l_extract_op_data_arr t_extract_op_data_arr;

  l_xswl_rec     xlbb_sap_wo_log%rowtype;
  l_xswl_ins_arr t_xswl_arr;
  
  l_run_number xlbb_sap_wo_control.xswc_last_run_sequence%type;
  
  l_file_id utl_file.file_type;
  
  PROCEDURE writeln(pi_text IN varchar2
                   ) IS
  BEGIN
    nm3file.put_line(FILE   => l_file_id
                    ,BUFFER => pi_text);
  
    --l_lines_written_to_file := l_lines_written_to_file + 1;
  
  END writeln;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'generate_wo_interface_file');

  l_extract_wor_data_arr := get_extract_wor_data;
  
  db('found ' || l_extract_wor_data_arr.count || ' orders to extract.');
  
  if l_extract_wor_data_arr.count > 0
  then
    l_run_number := get_run_number;
    
    db('run number = ' || l_run_number);
    
    po_extract_filename := generate_file_name(pi_run_number => l_run_number);
    
    db('file name = ' || po_extract_filename);
    
    --open file
    l_file_id := open_output_file(pi_file_path => c_file_path
                                 ,pi_filename  => po_extract_filename);
  
    write_batch_header(pi_file_id => l_file_id);
  
    for i in 1..l_extract_wor_data_arr.count
    loop
      db('processing wo ' || l_extract_wor_data_arr(i).works_order_no);
      
      --get wol data
      l_extract_op_data_arr := get_extract_op_data(pi_works_order_no => l_extract_wor_data_arr(i).works_order_no);
      
      db('found ' || l_extract_op_data_arr.count || ' operations (wols/boqs).');
      
      --assign some data from first wol to wor data for the order header
      IF l_extract_op_data_arr.count > 0
      then
        l_extract_wor_data_arr(i).functional_location := l_extract_op_data_arr(1).usrn_no;
        l_extract_wor_data_arr(i).activity_code       := l_extract_op_data_arr(1).activity_code;
        l_extract_wor_data_arr(i).icb_work_code       := l_extract_op_data_arr(1).icb_work_code;
      end if;
      
      --write order header
      writeln(get_order_header_line(pi_extract_wor_data_rec => l_extract_wor_data_arr(i)));
    
      --loop wols
      for j in 1..l_extract_op_data_arr.count
      loop
        if j > c_op_line_limit
        THEN
          log_error(pi_error_msg => 'Limit of ' || c_op_line_limit
                                 || ' operation lines reached for works order ' || l_extract_wor_data_arr(i).works_order_no
                   ,pi_fatal     => FALSE);
        
          ExIT;
        END IF;
        
        db('processing op wol_id = ' || l_extract_op_data_arr(j).wol_id || ' boq_id = ' || l_extract_op_data_arr(j).boq_id);
        
        --write op lines 
        writeln(get_operation_line(pi_extract_op_data_rec => l_extract_op_data_arr(j)
                                  ,pi_contractor_code     => l_extract_wor_data_arr(i).contractor_code));
      end loop;
    
      --add new rec to log table insert array
      l_xswl_rec.xswl_works_order_no      := l_extract_wor_data_arr(i).works_order_no;
      l_xswl_rec.xswl_user_last_processed := USER;
      l_xswl_rec.xswl_date_last_processed := SYSDATE;
              
      l_xswl_ins_arr(l_xswl_ins_arr.COUNT + 1) := l_xswl_rec;
    end loop;
    
    write_batch_trailer(pi_file_id        => l_file_id
                       ,pi_orders_in_file => l_extract_wor_data_arr.count);
        
    --update the run control information
    db('updating the run control information');
    update_control_data;

    --insert logs
    db('inserting logs');
    ins_all_xswl(pi_xswl_arr => l_xswl_ins_arr);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'generate_wo_interface_file');

EXCEPTION
  WHEN others
  THEN
    log_error(pi_error_msg => 'Unexpected error: ' || dbms_utility.format_error_stack
             ,pi_fatal     => TRUE);

END generate_wo_interface_file;
--
-----------------------------------------------------------------------------
--
END xlbb_sap_wo_interface;
/

