CREATE OR REPLACE PACKAGE BODY xnhcc_interfaces IS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/customer/northants/DCI/admin/pck/xnhcc_interfaces.pkb-arc   1.0   May 01 2014 09:59:00   Mike.Huitson  $
--       Module Name      : $Workfile:   xnhcc_interfaces.pkb  $
--       Date into SCCS   : $Date:   May 01 2014 09:59:00  $
--       Date fetched Out : $Modtime:   Apr 24 2014 15:05:52  $
--       SCCS Version     : $Revision:   1.0  $
--       Based on SCCS Version     : 
--
--
-----------------------------------------------------------------------------
--   Originally taken from '@(#)interfaces.pck    1.26 08/19/03'
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- global, private variables
--

  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.0  $';

  c_csv_currency_format CONSTANT varchar2(13) := 'FM99999990.00';

g_filepath  varchar2(250) := 'CIM_DIR'; --hig.get_useopt('INTERPATH', USER);
g_multifinal   varchar2(250) := hig.get_sysopt('CIMMULTIF');
g_wol_index integer;
g_wor_index integer;
--
g_job_id            number := NULL;
g_boq_id            number := NULL;
g_parent_boq_id_seq number := NULL;
g_boq_id_seq        number := NULL;
g_separator         varchar2(1) := '~';
g_count number := 0;

--
TYPE wol_rec IS RECORD ( r_wol_id        work_order_lines.wol_id%TYPE
                ,r_wor_no        work_order_lines.wol_works_order_no%TYPE
                ,r_defect_id    work_order_lines.wol_def_defect_id%TYPE
                ,r_schd_id        work_order_lines.wol_schd_id%TYPE
                ,r_work_code    work_order_lines.wol_icb_work_code%TYPE
                ,r_road_id        road_segs.rse_unique%TYPE
                ,r_road_descr    road_segs.rse_descr%TYPE
                ,r_wol_descr     work_order_lines.wol_descr%TYPE);

TYPE wol_tab IS TABLE OF wol_rec INDEX BY binary_integer;
TYPE wor_tab IS TABLE OF interface_wor%ROWTYPE INDEX BY binary_integer;

g_wol_tab        wol_tab;
g_wor_tab        wor_tab;
g_date_format    varchar2(20) := 'DDMMRRRR';
g_time_format    varchar2(20) := 'HH24:MI:SS';
g_today        date    := SYSDATE;
g_wol_comp_status    hig_status_codes.hsc_status_code%TYPE;
g_file_exists    EXCEPTION;
g_file_exists_err varchar2(55) := 'Error: A file with this sequence number already exists.';

-- global cursors
--
  CURSOR cost_code(c_wol_id work_order_lines.wol_id%TYPE) IS
/* completely unneccessary since bud_id included on wols
    SELECT bud_cost_code
    FROM   job_sizes job,
           work_order_lines wol,
           financial_years fyr,
           work_orders wor,
           road_segments_all rse2,
           road_segments_all rse1,
           budgets
    WHERE  wol.wol_works_order_no||'' = wor.wor_works_order_no
    AND    wol.wol_rse_he_id = rse1.rse_he_id
    AND    rse1.rse_he_id IN (SELECT rsm_rse_he_id_of
                    FROM   road_seg_membs
                    WHERE  wor.wor_date_confirmed BETWEEN rsm_start_date
                    AND    NVL(rsm_end_date, SYSDATE)
                    CONNECT BY PRIOR rsm_rse_he_id_of = rsm_rse_he_id_in
                    START WITH rsm_rse_he_id_in = rse2.rse_he_id)
    AND    rse2.rse_gty_group_type = (SELECT hop_value
                          FROM   hig_options
                              WHERE  hop_id = DECODE(wor.wor_sys_flag,'L',
                                           'BUDGRPTYPL','BUDGRPTYPD'))
    AND    job.job_code BETWEEN DECODE(wor.wor_sys_flag,'L','1','0')
                            AND DECODE(wor.wor_sys_flag,'L','9','0')
    AND    wor.wor_est_cost BETWEEN job.job_min_size AND job.job_max_size
    AND    wor.wor_date_confirmed BETWEEN fyr.fyr_start_date
                                      AND fyr.fyr_end_date
    AND    bud_icb_item_code||bud_icb_sub_item_code||
           bud_icb_sub_sub_item_code = wol_icb_work_code
    AND    bud_rse_he_id = rse2.rse_he_id
    AND    job_code = bud_job_code
    AND    fyr_id = bud_fyr_id
    AND    wol_id = c_wol_id; */

    SELECT bud_cost_code
    FROM   budgets
    ,      work_order_lines
    WHERE  bud_id = wol_bud_id
    AND    wol_id = c_wol_id;


  FUNCTION get_version RETURN varchar2 IS
  BEGIN
     RETURN g_sccsid;
  END;
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
FUNCTION check_filename(filename VARCHAR2)
  RETURN BOOLEAN IS
  --
  lv_retval BOOLEAN := TRUE;
  --
BEGIN
  --
  IF hig.get_user_or_sys_opt('ZEROPAD')='Y'
   THEN
      nm_debug.debug(length(filename));
      IF LENGTH(filename) < 12
       THEN
          lv_retval := FALSE;
      END IF;
  END IF;
  --
  RETURN lv_retval;
  --
end check_filename;
---------------------------------------------------------------------
PROCEDURE update_defect_date(p_def_id         IN defects.def_defect_id%TYPE
                            ,p_date_compl     IN defects.def_date_compl%TYPE
                            ,p_works_order_no IN work_orders.wor_works_order_no%TYPE
                            ,p_wol_id         IN work_order_lines.wol_id%TYPE DEFAULT 0
                            ,p_hour_compl     IN NUMBER DEFAULT 0
                            ,p_mins_compl     IN NUMBER DEFAULT 0)
  IS
  /*
  ||Local copy of maiwo.update_defect_date that prevents
  ||the repair_date_complete being overwriten (717676).
  ||This was originaly changed in maiwo but unfortunately
  ||there are other modules (mai3800,mai3802 and mai3842)
  ||that use the same procedure and rely on being able to
  ||update the repair date regardless of whether it is
  ||already populated.
  ||
  ||Idealy the procedure in maiwo would be changed to cater
  ||for all modules that call it however this would probably
  ||involve a new parameter and we need to send a fix out
  ||without having to recompile the calling modules.
  */
  l_today date := SYSDATE;
  --
  CURSOR c1(cp_def_id defects.def_defect_id%TYPE)
      IS
  SELECT MAX(rep_date_completed)
    FROM repairs
   WHERE rep_def_defect_id = cp_def_id
       ;
  --
  ldate repairs.rep_date_completed%TYPE;
  --
BEGIN
  --
  IF (p_wol_id is not null and p_wol_id <> 0)
   THEN
      UPDATE repairs
         SET rep_date_completed = p_date_compl
            ,rep_completed_hrs  = DECODE(p_date_compl,NULL,NULL,p_hour_compl)
            ,rep_completed_mins = DECODE(p_date_compl,NULL,NULL,p_mins_compl)
            ,rep_last_updated_date = l_today
       WHERE rep_def_defect_id IN(SELECT wol.wol_def_defect_id
                                    FROM work_order_lines wol
                                   WHERE wol.wol_def_defect_id = p_def_id
                                     AND wol.wol_def_defect_id = rep_def_defect_id
                                     AND wol.wol_rep_action_cat = rep_action_cat
                                     AND wol.wol_id = p_wol_id)
         AND rep_date_completed IS NULL -- SM 06012009 717676 repair may have already been completed by WC file. If so, shouldn't be updated by WI file
           ;
  ELSE
      UPDATE repairs
         SET rep_date_completed = p_date_compl
            ,rep_completed_hrs  = decode(p_date_compl,null,null,p_hour_compl)
            ,rep_completed_mins = decode(p_date_compl,null,null,p_mins_compl)
            ,rep_last_updated_date = l_today
       WHERE rep_def_defect_id IN(SELECT wol.wol_def_defect_id
                                    FROM work_order_lines wol
                                   WHERE wol.wol_def_defect_id = p_def_id
                                     AND wol.wol_works_order_no = p_works_order_no
                                     AND wol.wol_def_defect_id = rep_def_defect_id
                                     AND wol.wol_rep_action_cat = rep_action_cat)
         AND rep_date_completed IS NULL -- SM 06012009 717676 repair may have already been completed by WC file. If so, shouldn't be updated by WI file
           ;
  END IF;
  --
  IF p_date_compl IS NOT NULL
   THEN
      OPEN  c1(p_def_id);
      FETCH c1
       INTO ldate;
      CLOSE c1;
      --
      UPDATE defects
         SET def_date_compl = ldate
            ,def_last_updated_date = l_today
       WHERE def_defect_id = p_def_id
         AND NOT EXISTS(SELECT 1
                          FROM repairs
                         WHERE rep_def_defect_id = def_defect_id
                           AND rep_date_completed is null)
           ;
  ELSE
      UPDATE defects
         SET def_date_compl = p_date_compl
            ,def_last_updated_date = l_today
       WHERE def_defect_id = p_def_id
           ;
  END IF;
  --
END update_defect_date;
---------------------------------------------------------------------
-- reformat_cost_code function
-- reformats cost centre code for Norfolk's May Gurney interface
--
-- Supplied cost code should be of the format:
--
--   cccccc-ssss0-pppppp
--
-- Final cost code will be of the following format:
--
--   10-cccccc-ssss0-pppppp-ffffff-000000-000000
--
  FUNCTION reformat_cost_code (p_cost_code IN interface_wol.iwol_cost_code%TYPE) RETURN varchar2
  IS

    c_cccccc             constant varchar2(6) := substr(p_cost_code, 1, 6);
    c_ssss0              constant varchar2(5) := substr(p_cost_code, 8, 5);
    c_pppppp             constant varchar2(6) := substr(p_cost_code, 14, 6);

    c_1st_char_of_s_part constant varchar2(1):= substr(c_ssss0, 1, 1);

    c_sep                constant varchar2(1) := '-';

    c_zeros              constant varchar2(6) := '000000';

    l_retval varchar2(43);

    l_pppppp varchar2(6);
    l_ffffff varchar2(6);

  BEGIN
    IF p_cost_code IS NULL
      THEN
        l_retval := NULL;
    ELSe
      if c_1st_char_of_s_part <> 'C'
      then
        l_pppppp := c_zeros;
        l_ffffff := c_pppppp;
      else
        l_pppppp := c_pppppp;
        l_ffffff := c_zeros;
      END IF;

      l_retval := 10 || c_sep || c_cccccc || c_sep || c_ssss0
                     || c_sep || l_pppppp || c_sep || l_ffffff
                     || c_sep || c_zeros  || c_sep || c_zeros;
    end if;

    return l_retval;

  END reformat_cost_code;

---------------------------------------------------------------------
-- Budget Audit Trail procedure.
-- It populates the BAT table with a record each time the budget updated.
--

  PROCEDURE write_bat( p_bud_id       IN budgets.bud_id%TYPE
                     , p_wor_no       IN work_orders.wor_works_order_no%TYPE
                     , p_wol_id       IN work_order_lines.wol_id%TYPE
                     , p_date         IN date
                     , p_value        IN budgets.bud_value%TYPE
                     , p_bud_value    IN budgets.bud_value%TYPE
                     , p_bud_commited IN budgets.bud_committed%TYPE
                     , p_bud_actual   IN budgets.bud_actual%TYPE
                     ) IS

  l_bat_id number := 0;

  BEGIN
    SELECT bat_id_seq.NEXTVAL
    INTO   l_bat_id
    FROM dual;

    INSERT INTO budget_audit_trail
    VALUES ( l_bat_id
           , p_bud_id
           , p_wor_no
           , p_wol_id
           , p_date
           , p_value
           , p_bud_value
           , p_bud_commited
           , p_bud_actual
           );
    COMMIT;
  END;
---------------------------------------------------------------------
--returns the fyr_id when given the wol_id. Part of 717549 (SM 26112008). 
--Called from claim_file_ph2.
function get_fyr_id (pi_wol_id work_order_lines.wol_id%TYPE) RETURN varchar2 is
  cursor c1 (p_wol_id work_order_lines.wol_id%TYPE) is
  select fyr_id
  from financial_years
     , budgets
     , work_order_lines
  where fyr_id = bud_fyr_id
  and bud_id = wol_bud_id
  and wol_id = p_wol_id;
  
  l_fyr_id financial_years.fyr_id%TYPE := '-1'; 
begin
    open c1(pi_wol_id);
    fetch c1 into l_fyr_id;
    close c1;
    return l_fyr_id;
end get_fyr_id;
---------------------------------------------------------------------
-- Called from the copy_data_to_interface procedure.
-- It populates the Interface_WOL and Interface_BOQ tables.
--
  FUNCTION get_woc_claim_type( p_woc_claim_ref    IN varchar2
                 , p_woc_con_id    IN number
                 ) RETURN varchar2 IS

    CURSOR c1 ( l_woc_claim_ref work_order_claims.woc_claim_ref%TYPE
              , l_woc_con_id    work_order_claims.woc_con_id%TYPE
              ) IS
    SELECT woc_claim_type
    FROM work_order_claims
    WHERE woc_claim_ref = l_woc_claim_ref
    AND   woc_con_id    = l_woc_con_id;
    --
    l_woc_claim_type work_order_claims.woc_claim_type%TYPE;
    --
  BEGIN

    OPEN c1( p_woc_claim_ref
           , p_woc_con_id
           );
    FETCH c1 INTO l_woc_claim_type;
    IF c1%NOTFOUND
      THEN
        l_woc_claim_type := '1';
    END IF;

    RETURN l_woc_claim_type;
  END get_woc_claim_type;
---------------------------------------------------------------------
-- Called from the copy_data_to_interface procedure.
-- It populates the Interface_WOL and Interface_BOQ tables.
--

  PROCEDURE pop_wor_file_tabs(p_trans_id    IN interface_wor.iwor_transaction_id%TYPE
                             ,p_wor_no         IN work_orders.wor_works_order_no%TYPE) IS

    CURSOR wols IS
      SELECT wol_id
            ,wol_def_defect_id
            ,wol_schd_id
            ,wol_rse_he_id
            ,wol_icb_work_code
            ,rse_unique
            ,rse_descr
            ,wol_descr
      FROM   road_segs
        ,work_order_lines
      WHERE  wol_rse_he_id = rse_he_id
    AND    wol_works_order_no = p_wor_no;

    CURSOR boq (c_wol_id     work_order_lines.wol_id%TYPE
	           ,p_cimallest  hig_option_values.hov_value%TYPE) IS
      SELECT boq_sta_item_code
            ,DECODE(p_cimallest, 'Y', boq_est_dim1, NVL(boq_act_dim1, boq_est_dim1)) dim1 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_dim2, NVL(boq_act_dim2, boq_est_dim2)) dim2 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_dim3, NVL(boq_act_dim3, boq_est_dim3)) dim3 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_quantity, NVL(boq_act_quantity, boq_est_quantity)) quantity --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_rate, NVL(boq_act_rate, boq_est_rate)) rate --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_cost, NVL(boq_act_cost, boq_est_cost)) COST --Task 0109080
      FROM   boq_items
      WHERE  boq_wol_id = c_wol_id;

    CURSOR boq2 (c_wol_id work_order_lines.wol_id%TYPE
	            ,p_cimallest  hig_option_values.hov_value%TYPE) IS
      SELECT boq_sta_item_code
            ,DECODE(p_cimallest, 'Y', boq_est_dim1, NVL(boq_act_dim1, boq_est_dim1)) dim1 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_dim2, NVL(boq_act_dim2, boq_est_dim2)) dim2 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_dim3, NVL(boq_act_dim3, boq_est_dim3)) dim3 --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_quantity, NVL(boq_act_quantity, boq_est_quantity)) quantity
            ,DECODE(p_cimallest, 'Y', boq_est_rate, NVL(boq_act_rate, boq_est_rate)) rate --Task 0109080
            ,DECODE(p_cimallest, 'Y', boq_est_cost, NVL(boq_act_cost, boq_est_cost)) COST --Task 0109080 COST
            ,boq_id
            ,boq_parent_id
            ,boq_item_name
            ,sta_rogue_flag
      FROM   boq_items, standard_items
      WHERE  boq_wol_id = c_wol_id
        AND  boq_sta_item_code = sta_item_code;

    CURSOR def (c_defect_id defects.def_defect_id%TYPE) IS
      SELECT def_locn_descr
            ,def_defect_descr
            ,def_special_instr
            ,def_priority
            ,def_defect_code
            ,def_st_chain
            ,def_x_sect
      FROM   defects
      WHERE  def_defect_id = c_defect_id;

  l_def_rec        def%ROWTYPE;
  l_cost_code      budgets.bud_cost_code%TYPE;
  l_cimallest      hig_option_values.hov_value%TYPE := hig.get_sysopt('CIMALLEST');

  BEGIN

    FOR l_wol_rec IN wols LOOP

      IF l_wol_rec.wol_def_defect_id IS NOT NULL THEN
        OPEN def(l_wol_rec.wol_def_defect_id);
        FETCH def INTO l_def_rec;
        CLOSE def;
      ELSE
        l_def_rec.def_locn_descr := NULL;
        l_def_rec.def_defect_descr := NULL;
        l_def_rec.def_special_instr := NULL;
        l_def_rec.def_priority := NULL;
        l_def_rec.def_defect_code := NULL;
        l_def_rec.def_st_chain := NULL;
        l_def_rec.def_x_sect := NULL;
      END IF;

    OPEN cost_code(l_wol_rec.wol_id);
      FETCH cost_code INTO l_cost_code;
      CLOSE cost_code;

 -- 719274 DY 16-MAR-2009 restricted the rse_descr below to 80 chars as per GNA's instructions.  Anything higher is more than interface_wol can handle.  
 -- This is a temporary measure until an impact anlysis of increasing the rse_descr from 80 to 240 is undertaken and the changes to the relevant 
 -- forms/reports made. 
 
      INSERT INTO interface_wol (
         iwol_transaction_id
        ,iwol_id
        ,iwol_works_order_no
        ,iwol_road_id
        ,iwol_road_descr
        ,iwol_def_defect_id
        ,iwol_schd_id
        ,iwol_def_locn_descr
        ,iwol_def_defect_descr
        ,iwol_def_special_instr
        ,iwol_def_priority
        ,iwol_def_defect_code
        ,iwol_def_st_chain
        ,iwol_def_x_sect
        ,iwol_percent_adjust
        ,iwol_percent_adjust_code
        ,iwol_work_cat
        ,iwol_cost_code
        ,iwol_descr)
      VALUES (
         p_trans_id
        ,l_wol_rec.wol_id
        ,p_wor_no
        ,l_wol_rec.rse_unique
        ,REPLACE(SUBSTR(l_wol_rec.rse_descr,1,80),',','~')  -- 719274 REPLACE(l_wol_rec.rse_descr,',','~')
        ,l_wol_rec.wol_def_defect_id
        ,l_wol_rec.wol_schd_id
        ,REPLACE(l_def_rec.def_locn_descr,',','~')
        ,REPLACE(l_def_rec.def_defect_descr,',','~')
        ,REPLACE(l_def_rec.def_special_instr,',','~')
        ,l_def_rec.def_priority
        ,l_def_rec.def_defect_code
        ,l_def_rec.def_st_chain
        ,l_def_rec.def_x_sect
        ,NULL
        ,NULL
        ,l_wol_rec.wol_icb_work_code
        ,l_cost_code
        ,REPLACE(l_wol_rec.wol_descr, ',','~'));

      IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3', '2-4-0') THEN
      FOR boq_rec IN boq(l_wol_rec.wol_id,
	                     l_cimallest) LOOP

        INSERT INTO interface_boq (
         iboq_transaction_id
        ,iboq_wol_id
        ,iboq_sta_item_code
        ,iboq_dim1
        ,iboq_dim2
        ,iboq_dim3
        ,iboq_quantity
        ,iboq_rate
        ,iboq_cost
        ,iboq_percent_adjust
        ,iboq_percent_adjust_code)
        VALUES (
         p_trans_id
        ,l_wol_rec.wol_id
        ,boq_rec.boq_sta_item_code
        ,boq_rec.dim1
        ,boq_rec.dim2
        ,boq_rec.dim3
        ,boq_rec.quantity
        ,boq_rec.rate
        ,boq_rec.COST
        ,NULL
        ,NULL);

      END LOOP;
      ELSE
      FOR boq_rec IN boq2(l_wol_rec.wol_id,
	                      l_cimallest) LOOP

        INSERT INTO interface_boq (
         iboq_transaction_id
        ,iboq_wol_id
        ,iboq_sta_item_code
        ,iboq_dim1
        ,iboq_dim2
        ,iboq_dim3
        ,iboq_quantity
        ,iboq_rate
        ,iboq_cost
        ,iboq_percent_adjust
        ,iboq_percent_adjust_code
        ,iboq_boq_id
          ,iboq_parent_boq_id
          ,iboq_percent_band_comp
          ,iboq_rogue_item
          ,iboq_rogue_item_desc
)
        VALUES (
         p_trans_id
        ,l_wol_rec.wol_id
        ,boq_rec.boq_sta_item_code
        ,boq_rec.dim1
        ,boq_rec.dim2
        ,boq_rec.dim3
        ,boq_rec.quantity
        ,boq_rec.rate
        ,boq_rec.COST
        ,NULL
        ,NULL
        ,boq_rec.boq_id
        ,boq_rec.boq_parent_id
        ,DECODE(boq_rec.boq_parent_id, NULL, NULL, SUBSTR(hig.get_sysopt('CUM_PERC'),1,1))
        ,DECODE(boq_rec.sta_rogue_flag, 'Y', 'R', NULL)
        ,DECODE(boq_rec.sta_rogue_flag, 'Y', REPLACE(boq_rec.boq_item_name,',','~'), NULL));

      END LOOP;
      END IF;
    END LOOP;

  END;


---------------------------------------------------------------------
-- Returns the next sequencial file number for a particular type of
-- file and for a particular contractor where applicable. This is
-- determined from the highest number used, as logged in the
-- Interface_Run_Log table. If a sequence number is supplied to the
-- function it verifies that a file with this number does not already
-- exist.

FUNCTION file_seq( p_job_id IN number,
             p_contractor_id    IN varchar2
            ,p_seq_no        IN number
            ,p_file_type    IN varchar2) RETURN varchar IS

  PRAGMA AUTONOMOUS_TRANSACTION;-- clb 02082010 Task 0109818

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

  l_seq_no varchar(8);
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
      RAISE g_file_exists;
    ELSE
      CLOSE irl_exists;
      l_seq_no := p_seq_no;
    END IF;
  END IF;
/*****************************************************************************************************************
** SM 03062008 714051
** New product option ZEROPAD to pad out the filenames with zeros. Meant changing the file_seq output from a 
** number to a varchar2 and thus changing all the variables in this package that call file_seq.
*****************************************************************************************************************/
  IF hig.get_user_or_sys_opt('ZEROPAD')='Y' THEN
    l_seq_no := lpad(NVL(l_seq_no, 1),6,'0');--SM 26112008 717549 (if l_seq_no was null wasn't using ZEROPAD)
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
         ,decode(length(p_contractor_id),4,get_oun_id(p_contractor_id),p_contractor_id)--SM 26112008 717549 (Was returning 4 digit contractor id rather than 3 digit elect_orders id)
         ,p_job_id);

  COMMIT;

  RETURN NVL(l_seq_no, 1);

EXCEPTION
  WHEN g_file_exists THEN
    RETURN -1;

  WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001, SQLERRM);

END;

--
-------------------------------------------------------------------------------
--
-- Writes a Works Order file from the data in the Interface_wor/wol/boq
-- tables populated by mai3800 when WO amendments are made. Returns the
-- name of that file.
--
FUNCTION write_wor_file(p_contractor_id IN varchar2
                       ,p_seq_no        IN number
                       ,p_filepath      IN varchar2) RETURN varchar2 IS
  --
  l_today            date      := SYSDATE;
  l_no_of_recs       number(7) := 0;
  l_total_cost       number    := 0;
  l_char_pos         number;
  l_descr_length     number    := 110;
  l_fhand            utl_file.file_type;
  l_seq_no           varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,p_contractor_id
                                          ,p_seq_no
                                          ,'WO');
  l_filename         varchar2(12) := 'WO'||TO_CHAR(l_seq_no)||'.'||p_contractor_id;
  l_header_record    varchar2(31) := '00,'||p_contractor_id||','
                                          ||TO_CHAR(l_seq_no)||','
                                          ||TO_CHAR(l_today, g_date_format)||','
                                          ||TO_CHAR(l_today, g_time_format);
  l_file_not_found   varchar2(250) := 'Error: Unable to write Works Order File. Path: '
                                     ||NVL(p_filepath, g_filepath)||'  File: '||l_filename;
  l_file_not_written varchar2(250) := 'Error: There was an error writing the Works Order File. Path: '
                                     ||NVL(p_filepath, g_filepath)||'  File: '||l_filename;
  --
  l_use_def_x_y      hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('IFUSEDEFXY'),'N');
  l_add_rmks         hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('CIMINCRMKS'),'N');
  --
  CURSOR wor
      IS
  SELECT '05,'||iwor_transaction_type||','||DECODE(hig.get_sysopt('CPAFORMAT'),1,SUBSTR(REPLACE(iwor_works_order_no,'/'),1,8)||'/'||iwor_con_code,iwor_works_order_no)||','||
           iwor_scheme_type||','||iwor_con_code||','||iwor_originator||','||
           DECODE(hig.get_sysopt('XTRIFLDS'), '2-1-3'
                                            , DECODE(TO_CHAR(iwor_date_confirmed, g_date_format),NVL(TO_CHAR(iwor_date_confirmed, g_date_format),1)
                                                                                                ,TO_CHAR(iwor_date_confirmed, g_date_format)||' '||NVL(TO_CHAR(iwor_date_confirmed, g_time_format),'00:00:01'))
                                            , '2-4-0'
                                            , DECODE(TO_CHAR(iwor_date_confirmed, g_date_format),NVL(TO_CHAR(iwor_date_confirmed, g_date_format),1)
                                                                                                ,TO_CHAR(iwor_date_confirmed, g_date_format)||' '||NVL(TO_CHAR(iwor_date_confirmed, g_time_format),'00:00:01'))
                                            ,DECODE(TO_CHAR(iwor_date_confirmed, g_date_format),NVL(TO_CHAR(iwor_date_confirmed, g_date_format),1),TO_CHAR(iwor_date_confirmed, g_date_format)))||','||
           DECODE(hig.get_sysopt('XTRIFLDS'), '2-1-3'
                                            ,DECODE(TO_CHAR(iwor_est_complete, g_date_format),NVL(TO_CHAR(iwor_est_complete, g_date_format),1)
                                                                                             ,TO_CHAR(iwor_est_complete, g_date_format)||' '||NVL(TO_CHAR(iwor_est_complete, g_time_format),'00:00:01'))
                                            , '2-4-0'
                                            ,DECODE(TO_CHAR(iwor_est_complete, g_date_format),NVL(TO_CHAR(iwor_est_complete, g_date_format),1)
                                                                                             ,TO_CHAR(iwor_est_complete, g_date_format)||' '||NVL(TO_CHAR(iwor_est_complete, g_time_format),'00:00:01'))
                                            ,DECODE(TO_CHAR(iwor_est_complete, g_date_format),NVL(TO_CHAR(iwor_est_complete, g_date_format),1),TO_CHAR(iwor_est_complete, g_date_format)))||','||
           LTRIM(TO_CHAR(iwor_cost,'9999999990.00'))||','||LTRIM(TO_CHAR(iwor_est_labour,'9999999990.00'))||
           ','||iwor_interim_payment_flag||','||iwor_risk_assessment_flag||
           ','||iwor_method_statement_flag||','||iwor_works_programme_flag||
           ','||iwor_additional_safety_flag||','||
           DECODE(hig.get_sysopt('XTRIFLDS'), '2-1-3'
                                            ,DECODE(TO_CHAR(iwor_commence_by, g_date_format),NVL(TO_CHAR(iwor_commence_by, g_date_format),1)
                                                                                            ,TO_CHAR(iwor_commence_by, g_date_format)||' '||NVL(TO_CHAR(iwor_commence_by, g_time_format),'00:00:01'))
                                            , '2-4-0'
                                            ,DECODE(TO_CHAR(iwor_commence_by, g_date_format),NVL(TO_CHAR(iwor_commence_by, g_date_format),1)
                                                                                            ,TO_CHAR(iwor_commence_by, g_date_format)||' '||NVL(TO_CHAR(iwor_commence_by, g_time_format),'00:00:01'))
                                            ,DECODE(TO_CHAR(iwor_commence_by, g_date_format),NVL(TO_CHAR(iwor_commence_by, g_date_format),1),TO_CHAR(iwor_commence_by, g_date_format)))||','||iwor_fyr_id
        order_record
       ,Replace(Replace(iwor_descr,Chr(10),' '),Chr(13),' ') iwor_descr
       ,LTRIM(TO_CHAR(iwor_cost,'9999999990.00')) iwor_cost
       ,iwor_transaction_id
       ,iwor_works_order_no
       ,Replace(Replace(iwor_remarks,Chr(10),' '),Chr(13),' ') iwor_remarks 
       ,NVL(con_include_in_cim, 'N') con_include_in_cim
   FROM interface_wor
       ,contracts
       ,org_units
  WHERE iwor_con_code = con_code
    AND iwor_wo_run_number IS NULL
    AND con_contr_org_id = oun_org_id
    AND oun_contractor_id = p_contractor_id
  ORDER
     BY iwor_transaction_id
    ;
  --
  CURSOR wol(c_transaction_id interface_wol.iwol_transaction_id%TYPE
            ,c_wor_no         interface_wol.iwol_works_order_no%TYPE)
      IS
  SELECT '10,'||TO_CHAR(iwol_id)||','||TO_CHAR(iwol_def_defect_id)||
           ','||TO_CHAR(iwol_schd_id)||
           ','||iwol_road_id||','||Replace(Replace(Replace(REPLACE(iwol_road_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||
           ','||Replace(Replace(Replace(REPLACE(iwol_def_locn_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||
           ','||Replace(Replace(Replace(REPLACE(iwol_def_defect_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||
           ','||Replace(Replace(Replace(REPLACE(iwol_def_special_instr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||
           ','||iwol_def_priority||','||iwol_def_defect_code||
           ','||TO_CHAR(iwol_def_st_chain)||','||iwol_def_x_sect||
           ','||TO_CHAR(iwol_percent_adjust)||
           ','||TO_CHAR(iwol_percent_adjust_code)||
           ','||DECODE(hig.get_sysopt('LZSUBCODE'), 'Y', iwol_work_cat, DECODE(SUBSTR(iwol_work_cat,1,1),'0',SUBSTR(iwol_work_cat,2,LENGTH(iwol_work_cat)),iwol_work_cat))||','||iwol_cost_code wol_record
        ,iwol_id
        ,iwol_def_defect_id
        ,Replace(Replace(Replace(REPLACE(iwol_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ') iwol_descr
    FROM interface_wol
   WHERE iwol_transaction_id = c_transaction_id
     AND iwol_works_order_no = c_wor_no
       ;
  --
  CURSOR def(c_defect_id defects.def_defect_id%TYPE
            ,c_wol_id    work_order_lines.wol_id%TYPE)
      IS
  SELECT ','||def_atv_acty_area_code||','||def_ity_inv_code||
         ','||TO_CHAR(def_iit_item_id)||
         ','||DECODE(hig.get_sysopt('XTRIFLDS'), '2-1-3'
                                               ,DECODE(TO_CHAR(are_date_work_done, g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1)
                                                                                               ,TO_CHAR(are_date_work_done, g_date_format)||' '||NVL(TO_CHAR(TO_DATE(TO_CHAR(def_time_hrs,'00')||TO_CHAR(def_time_mins,'00'), g_time_format), g_time_format), '00:00:01'))
                                             , '2-4-0'
                                             ,DECODE(TO_CHAR(are_date_work_done, g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1)
                                                                                               ,TO_CHAR(are_date_work_done, g_date_format)||' '||NVL(TO_CHAR(TO_DATE(TO_CHAR(def_time_hrs,'00')||TO_CHAR(def_time_mins,'00'), g_time_format), g_time_format), '00:00:01'))
                                             ,DECODE(TO_CHAR(are_date_work_done, g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1),TO_CHAR(are_date_work_done, g_date_format)))||
         ','||rep_action_cat||','||Replace(Replace(Replace(REPLACE(rep_descr,',','~'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||','||rep_tre_treat_code||
         ','||DECODE(hig.get_sysopt('XTRIFLDS'),'2-1-3',TO_CHAR(rep_date_due, g_date_format)||' '||NVL(TO_CHAR(rep_date_due, g_time_format),'00:00:01')
                                               ,'2-4-0',TO_CHAR(rep_date_due, g_date_format)||' '||NVL(TO_CHAR(rep_date_due, g_time_format),'00:00:01')
                                                       ,TO_CHAR(rep_date_due, g_date_format))
         ||DECODE(l_use_def_x_y,'Y',','||TO_CHAR(def_easting)||','||TO_CHAR(def_northing),NULL) details
    FROM defects
        ,repairs
        ,activities_report
   WHERE def_defect_id = c_defect_id
     AND rep_def_defect_id = def_defect_id
     AND are_report_id = def_are_report_id
     AND (rep_def_defect_id,rep_action_cat) IN(SELECT wol_def_defect_id
                                                     ,wol_rep_action_cat
                                                 FROM work_order_lines
                                                WHERE wol_def_defect_id  = c_defect_id
                                                  AND wol_id = c_wol_id)
       ;
  --
  CURSOR bud_bid_id(c_wol_id work_order_lines.wol_id%TYPE)
      IS
  SELECT ','||TO_CHAR(bud_bid_id)
    FROM work_order_lines
        ,budgets
   WHERE bud_bid_id IS NOT NULL
     AND wol_bud_id = bud_id
     AND wol_id = c_wol_id
       ;
  --
  CURSOR boq(c_transaction_id interface_boq.iboq_transaction_id%TYPE
            ,c_wol_id         interface_boq.iboq_wol_id%TYPE)
      IS
  SELECT '15,'||TO_CHAR(iboq_wol_id)||','||iboq_sta_item_code||
           ','||TO_CHAR(iboq_dim1)||','||TO_CHAR(iboq_dim2)||
           ','||TO_CHAR(iboq_dim3)||','||TO_CHAR(iboq_quantity)||
           ','||LTRIM(TO_CHAR(iboq_rate,'B999999990.00'))||','||LTRIM(TO_CHAR(iboq_cost,'999999990.00'))||
           ','||TO_CHAR(iboq_percent_adjust)||
           ','||TO_CHAR(iboq_percent_adjust_code) boq_record
    FROM interface_boq
   WHERE iboq_transaction_id = c_transaction_id
     AND iboq_wol_id = c_wol_id
       ;
  --
  CURSOR woldef(c_transaction_id interface_wol.iwol_transaction_id%TYPE
               ,c_wor_no         interface_wol.iwol_works_order_no%TYPE)
      IS
  SELECT '10,'||TO_CHAR(iwol_id)||','||TO_CHAR(iwol_def_defect_id)||
           ','||TO_CHAR(iwol_schd_id)||
           ','||iwol_road_id||','||REPLACE(iwol_road_descr,',',':')||
           ','||Replace(Replace(Replace(REPLACE(iwol_def_locn_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||
           ','||Replace(Replace(Replace(Replace(DECODE(hig.get_sysopt('CPAFORMAT'), '1',SUBSTR(iwol_def_defect_descr||' : '||REPLACE(rep_descr,',','~')||' : '||iwol_def_special_instr,1,254),iwol_def_defect_descr),Chr(10),' '),Chr(13),' '),Chr(1),' '),',','~')||
           ','||Replace(Replace(Replace(Replace(DECODE(hig.get_sysopt('CPAFORMAT'), '1',NULL,iwol_def_special_instr),Chr(10),' '),Chr(13),' '),Chr(1),' '),',','~')||
           ','||iwol_def_priority||','||iwol_def_defect_code||
           ','||TO_CHAR(iwol_def_st_chain)||','||iwol_def_x_sect||
           ','||TO_CHAR(iwol_percent_adjust)||
           ','||TO_CHAR(iwol_percent_adjust_code)||
           ','||DECODE(hig.get_sysopt('LZSUBCODE'), 'Y', iwol_work_cat, DECODE(SUBSTR(iwol_work_cat,1,1),'0',SUBSTR(iwol_work_cat,2,LENGTH(iwol_work_cat)),iwol_work_cat))||','||iwol_cost_code wol_record
        ,iwol_id
        ,iwol_def_defect_id
        ,','||def_atv_acty_area_code||','||def_ity_inv_code||
         ','||TO_CHAR(def_iit_item_id)||
         ','||DECODE(hig.get_sysopt('XTRIFLDS'),'2-1-3' ,DECODE(TO_CHAR(are_date_work_done,g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1)
                                                                                               ,TO_CHAR(are_date_work_done, g_date_format)||' '||NVL(TO_CHAR(TO_DATE(TO_CHAR(def_time_hrs,'00')||TO_CHAR(def_time_mins,'00'), g_time_format), g_time_format), '00:00:01'))
                                               ,'2-4-0' ,DECODE(TO_CHAR(are_date_work_done,g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1)
,TO_CHAR(are_date_work_done, g_date_format)||' '||NVL(TO_CHAR(TO_DATE(TO_CHAR(def_time_hrs,'00')||TO_CHAR(def_time_mins,'00'), g_time_format), g_time_format), '00:00:01'))
                                             ,DECODE(TO_CHAR(are_date_work_done, g_date_format),NVL(TO_CHAR(are_date_work_done, g_date_format),1),TO_CHAR(are_date_work_done, g_date_format)))||
         
         ','||rep_action_cat||','||Replace(Replace(Replace(REPLACE(rep_descr,',','~'),Chr(10),' '),Chr(13),' '),Chr(1),' ')||','||rep_tre_treat_code||
         ','||DECODE(hig.get_sysopt('XTRIFLDS'), '2-1-3'
                                             , TO_CHAR(rep_date_due, g_date_format)||' '||NVL(TO_CHAR(rep_date_due, g_time_format),'00:00:01')
--                                             , TO_CHAR(rep_date_due, g_date_format)
                                             , '2-4-0'
                                             , TO_CHAR(rep_date_due, g_date_format)||' '||NVL(TO_CHAR(rep_date_due, g_time_format),'00:00:01')
                                             , TO_CHAR(rep_date_due, g_date_format)
                                             )
         ||DECODE(l_use_def_x_y,'Y',','||TO_CHAR(def_easting)||','||TO_CHAR(def_northing),NULL) details
         ,Replace(Replace(Replace(REPLACE(iwol_descr,',',':'),Chr(10),' '),Chr(13),' '),Chr(1),' ') iwol_descr
    FROM interface_wol
        ,defects
        ,repairs
        ,activities_report
   WHERE iwol_transaction_id = c_transaction_id
     AND iwol_works_order_no = c_wor_no
     AND def_defect_id(+) = iwol_def_defect_id
     AND rep_def_defect_id(+) = def_defect_id
     AND are_report_id(+) = def_are_report_id
       ;
  --
  CURSOR boq2(c_transaction_id interface_boq.iboq_transaction_id%TYPE
             ,c_wol_id         interface_boq.iboq_wol_id%TYPE)
      IS
  SELECT '15,'||TO_CHAR(iboq_wol_id)||','||iboq_sta_item_code||
           ','||TO_CHAR(iboq_dim1)||','||TO_CHAR(iboq_dim2)||
           ','||TO_CHAR(iboq_dim3)||','||TO_CHAR(iboq_quantity)||
           ','||LTRIM(TO_CHAR(iboq_rate,'999999990.00'))||','||LTRIM(TO_CHAR(iboq_cost,'999999990.00'))||
           ','||TO_CHAR(iboq_percent_adjust)||
           ','||TO_CHAR(iboq_percent_adjust_code)||
           ','||TO_CHAR(iboq_boq_id)||
           ','||TO_CHAR(iboq_parent_boq_id)||
           ','||iboq_percent_band_comp||
           ','||iboq_rogue_item||
           ','||Replace(Replace(Replace(Replace(iboq_rogue_item_desc,Chr(10),' '),Chr(13),' '),Chr(1),' '),',','~') boq_record
    FROM interface_boq
   WHERE iboq_transaction_id = c_transaction_id
     AND iboq_wol_id = c_wol_id
       ;
  --
  l_def_details def%ROWTYPE;
  l_bud_bid varchar2(20); 
  l_cnt     Number ;
  l_clm_rec Number ;
  l_clm_tot Number ;
  CURSOR   c_get_oun
  IS
  SELECT  *
  FROM    org_units
  WHERE   oun_contractor_id = p_contractor_id ;
  l_oun_rec org_units%ROWTYPE;
  --
  CURSOR c_boq_perc_uplift(c_wol_id work_order_lines.wol_id%TYPE)
      IS
  SELECT ','||wol_boq_perc_item_code||','||sta_item_name
    FROM work_order_lines
            ,standard_items
   WHERE  wol_id = c_wol_id
       AND sta_item_code = wol_boq_perc_item_code
       ;
   --
  CURSOR c_wol_perc_uplift(c_wol_id work_order_lines.wol_id%TYPE)
      IS
  SELECT ','||wol_wol_perc_item_code||','||sta_item_name
    FROM work_order_lines
            ,standard_items
   WHERE  wol_id = c_wol_id
       AND sta_item_code = wol_wol_perc_item_code
       ;
   --
   lv_wol_boq_perc_item_code   varchar2(300);
   lv_wol_wol_perc_item_code   varchar2(300);
  --
BEGIN
  --
  nm3ctx.set_context('CIM_ERROR_TEXT',Null);
  IF l_seq_no = -1
   THEN
      RAISE g_file_exists;
  END IF;
  --
  --SM 09/04/2008 log712203
  --Removed reference to extract_filename as no longer required for forms9. Used to be required to create a 
  --*.lis file.
  
  -- CLB 06122010 Task 0107258 - changed to use overloaded FOPEN to allow for rec size > 1023 bytes
  l_fhand := UTL_FILE.FOPEN(NVL(p_filepath,g_filepath),/*NVL(interfaces.extract_filename,*/l_filename/*)*/,'w', 32767); 
  --
  IF UTL_FILE.IS_OPEN(l_fhand)
   THEN
      UTL_FILE.PUT_LINE(l_fhand, l_header_record);
      FOR l_wor_rec IN wor LOOP
        UTL_FILE.PUT_LINE(l_fhand, l_wor_rec.order_record);
        l_no_of_recs := l_no_of_recs + 1;
        l_total_cost := l_total_cost + l_wor_rec.iwor_cost;
        --
        l_char_pos := 1;
        WHILE SUBSTR(l_wor_rec.iwor_descr, l_char_pos) IS NOT NULL LOOP
          UTL_FILE.PUT_LINE(l_fhand, '06,'||SUBSTR(REPLACE(l_wor_rec.iwor_descr,',','~'), l_char_pos, l_descr_length));
          l_char_pos := l_char_pos + l_descr_length;
          l_no_of_recs := l_no_of_recs + 1;
        END LOOP;
        IF l_wor_rec.iwor_remarks IS NOT NULL AND
           l_add_rmks = 'Y'
         THEN
            UTL_FILE.PUT_LINE(l_fhand, '07,'||REPLACE(l_wor_rec.iwor_remarks,',','~'));
            l_no_of_recs := l_no_of_recs + 1;
        END IF;
        IF hig.get_sysopt('CPAFORMAT') = '1'
         THEN
            FOR l_wol_rec IN woldef(l_wor_rec.iwor_transaction_id
                                   ,l_wor_rec.iwor_works_order_no) LOOP
              l_wol_rec.wol_record := l_wol_rec.wol_record||l_wol_rec.details;
              
              IF l_wor_rec.con_include_in_cim = 'Y'
               THEN
                  open c_boq_perc_uplift(l_wol_rec.iwol_id);
                  fetch c_boq_perc_uplift into lv_wol_boq_perc_item_code;
                  close c_boq_perc_uplift;
                  
                   open c_wol_perc_uplift(l_wol_rec.iwol_id);
                  fetch c_wol_perc_uplift into lv_wol_wol_perc_item_code;
                  close c_wol_perc_uplift;
                  
                  l_wol_rec.wol_record := l_wol_rec.wol_record||lv_wol_boq_perc_item_code||lv_wol_wol_perc_item_code;
             END IF;
              
              UTL_FILE.PUT_LINE(l_fhand, l_wol_rec.wol_record);
              l_no_of_recs := l_no_of_recs + 1;
              --
              IF l_wol_rec.iwol_descr IS NOT NULL AND
                 l_add_rmks = 'Y'
               THEN
                   --
                    UTL_FILE.PUT_LINE(l_fhand, '11,'||l_wol_rec.iwol_descr);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
              END IF;                
              --
              IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3','2-4-0')
               THEN
                  FOR l_boq_rec IN boq(l_wor_rec.iwor_transaction_id
                                      ,l_wol_rec.iwol_id) LOOP
                    --
                    UTL_FILE.PUT_LINE(l_fhand, l_boq_rec.boq_record);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
                  END LOOP;
              ELSE
                  FOR l_boq_rec IN boq2(l_wor_rec.iwor_transaction_id
                                       ,l_wol_rec.iwol_id) LOOP
                    --
                    UTL_FILE.PUT_LINE(l_fhand, l_boq_rec.boq_record);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
                  END LOOP;
              END IF;
              --
            END LOOP;
        ELSE
            FOR l_wol_rec IN wol(l_wor_rec.iwor_transaction_id
                                ,l_wor_rec.iwor_works_order_no) LOOP
              --
              IF l_use_def_x_y = 'Y'
               THEN
                  l_def_details.details := ',,,,,,,,,,';
              ELSE
                  l_def_details.details := ',,,,,,,,';
              END IF;
              --
              IF l_wol_rec.iwol_def_defect_id IS NOT NULL
               THEN
                  OPEN  def( l_wol_rec.iwol_def_defect_id,l_wol_rec.iwol_id);
                  FETCH def
                   INTO l_def_details;
                  CLOSE def;
              END IF;
              --
              l_wol_rec.wol_record := l_wol_rec.wol_record||l_def_details.details;
              --
              IF hig.get_sysopt('XTRIFLDS') = '2-4-0'
               THEN
                  OPEN  bud_bid_id(l_wol_rec.iwol_id);
                  FETCH bud_bid_id
                   INTO l_bud_bid;
                  CLOSE bud_bid_id;
                  l_wol_rec.wol_record := l_wol_rec.wol_record||l_bud_bid;
              END IF;
              --
             IF l_wor_rec.con_include_in_cim = 'Y'
               THEN
                  open c_boq_perc_uplift(l_wol_rec.iwol_id);
                  fetch c_boq_perc_uplift into lv_wol_boq_perc_item_code;
                  close c_boq_perc_uplift;
                  
                   open c_wol_perc_uplift(l_wol_rec.iwol_id);
                  fetch c_wol_perc_uplift into lv_wol_wol_perc_item_code;
                  close c_wol_perc_uplift;
                  
                  l_wol_rec.wol_record := l_wol_rec.wol_record||lv_wol_boq_perc_item_code||lv_wol_wol_perc_item_code;
             END IF;

              UTL_FILE.PUT_LINE(l_fhand, l_wol_rec.wol_record);
              l_no_of_recs := l_no_of_recs + 1;
              --
              IF l_wol_rec.iwol_descr IS NOT NULL AND
                 l_add_rmks = 'Y'
               THEN
                   --
                    UTL_FILE.PUT_LINE(l_fhand, '11,'||l_wol_rec.iwol_descr);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
              END IF;
              --               
              IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3', '2-4-0')
               THEN
                  FOR l_boq_rec IN boq(l_wor_rec.iwor_transaction_id
                                      ,l_wol_rec.iwol_id) LOOP
                    --
                    UTL_FILE.PUT_LINE(l_fhand, l_boq_rec.boq_record);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
                  END LOOP;
              ELSE
                  FOR l_boq_rec IN boq2(l_wor_rec.iwor_transaction_id
                                       ,l_wol_rec.iwol_id) LOOP
                    --
                    UTL_FILE.PUT_LINE(l_fhand, l_boq_rec.boq_record);
                    l_no_of_recs := l_no_of_recs + 1;
                    --
                  END LOOP;
              END IF;
            END LOOP;
        END IF;
        --
        UPDATE interface_wor
           SET iwor_wo_run_number = l_seq_no
         WHERE iwor_transaction_id = l_wor_rec.iwor_transaction_id
           AND iwor_works_order_no = l_wor_rec.iwor_works_order_no
             ;
      END LOOP;
      IF hig.is_product_licensed('CLM')
      THEN
          interfaces.g_file_handle := l_fhand ;      
          Execute Immediate ' SELECT Count(0) '||                             
                            ' FROM   clm_contractor_interface '||
                            ' WHERE  cci_oun_id IN (SELECT oun.oun_id  '||
                            '                       FROM   clm_org_units oun '||
                            '                             ,org_units     mm_oun '||
                            '                       WHERE  oun_contractor_id = :1 '||
                            '                       AND    oun_org_id = oun.oun_mai_oun_id )    '||
                            ' AND    cci_status != ''P'' '  INTO l_cnt Using p_contractor_id ;

          IF l_cnt > 0
          THEN
              OPEN  c_get_oun;
              FETCH c_get_oun INTO l_oun_rec ;
              CLOSE c_get_oun;
              Execute Immediate 'BEGIN '||  
                                '   clm_cim_interface.generate_wor_file(pi_oun_mai_id  => :1   '||
                                '                                      ,pi_file_handle => interfaces.g_file_handle '||
                                '                                      ,pi_seq_no      => :2   '||
                                '                                      ,po_tot_rec     => :3   '||
                                '                                      ,po_tot_amt     => :4); '||
                                'END; ' Using l_oun_rec.oun_org_id,p_seq_no, Out l_clm_rec,Out l_clm_tot ;
          END IF ;
      END IF ;
      --
      COMMIT;
      -- write a check record
      UTL_FILE.PUT_LINE(l_fhand, '20,'||TO_CHAR(l_no_of_recs+Nvl(l_clm_rec,0))||','
                                      ||LTRIM(TO_CHAR(l_total_cost+Nvl(l_clm_tot,0),'9999999990.00')));
      UTL_FILE.FFLUSH(l_fhand);
      --
  END IF;
  --
  UTL_FILE.FCLOSE(l_fhand);
  RETURN l_filename;
  --
EXCEPTION
  WHEN utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation
   THEN
      DBMS_OUTPUT.ENABLE(300);
      DBMS_OUTPUT.PUT_LINE(l_file_not_found);
      nm3ctx.set_context('CIM_ERROR_TEXT','Error: Unable to create WO File. The path for the Oracle Directory CIM_DIR is invalid or not specified.');
      --
      IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
        higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,l_file_not_found);
      END IF;
      --
      RETURN NULL;
      --
  WHEN g_file_exists
   THEN
      DBMS_OUTPUT.ENABLE(300);
      DBMS_OUTPUT.PUT_LINE(g_file_exists_err);
      nm3ctx.set_context('CIM_ERROR_TEXT',g_file_exists_err);
      --
      IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
        higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,g_file_exists_err);
      END IF;
      --
      RETURN NULL;
      --
  WHEN utl_file.invalid_filehandle OR utl_file.write_error
   THEN
      DBMS_OUTPUT.ENABLE(300);
      DBMS_OUTPUT.PUT_LINE(l_file_not_written);
      nm3ctx.set_context('CIM_ERROR_TEXT','Error: There was an error writing the WO File in Oracle Directory CIM_DIR.');
      --
      IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
        higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,l_file_not_written);
      END IF;
      --
      RETURN NULL;
      --
  WHEN others
   THEN
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);      
END write_wor_file;
--
-------------------------------------------------------------------------------
--
FUNCTION write_wor_file(p_job_id IN number) RETURN varchar2 IS
  --
  CURSOR gri_report_run(cp_job_id IN NUMBER)
      IS
  SELECT 'x'
    FROM gri_report_runs
   WHERE grr_job_id = cp_job_id
     AND grr_mode = 'WEB'
       ;
  --
  lc_dummy varchar2(1);
  --
BEGIN
  --
  xnhcc_interfaces.g_job_id := p_job_id;
  --
  OPEN  gri_report_run(p_job_id);
  FETCH gri_report_run
   INTO lc_dummy;
  IF gri_report_run%FOUND
   THEN
      interfaces.extract_filename := higgrirp.get_module_spoolpath(p_job_id,USER)
                                   ||higgrirp.get_module_spoolfile(p_job_id);
  END IF;
  CLOSE gri_report_run;
  --
  RETURN interfaces.write_wor_file(higgrirp.get_parameter_value(p_job_id,'CONTRACTOR_CODE')
                                  ,higgrirp.get_parameter_value(p_job_id,'A_NUMBER')
                                  ,higgrirp.get_parameter_value(p_job_id,'TEXT'));
  --
END write_wor_file;
--
-------------------------------------------------------------------------------
--
PROCEDURE validate_contractor
(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_headers
  SET    ih_error = 'Invalid Contractor Id'
        ,ih_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   org_units
                     WHERE  oun_contractor_id = ih_contractor_id)
  AND    ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_post_paid
(p_ih_id IN interface_claims_wol.icwol_ih_id%TYPE
,p_wol_id IN interface_claims_wol.icwol_wol_id%TYPE) IS
BEGIN
      COMMIT;
      UPDATE interface_claims_wol
      SET    icwol_error = 'WOL has already been PAID'
            ,icwol_status = 'R'
      WHERE  icwol_ih_id = p_ih_id
        AND  icwol_wol_id = p_wol_id
        AND  icwol_status != 'R';
      COMMIT;
END;

---------------------------------------------------------------------
PROCEDURE validate_check_rec(p_ih_id IN interface_headers.ih_id%TYPE) IS

  l_count_1    number;
  l_count_2    number;

BEGIN

  SELECT COUNT(0)
  INTO   l_count_1
  FROM   interface_completions
  WHERE  ic_ih_id = p_ih_id;

  SELECT COUNT(0)
  INTO   l_count_2
  FROM   interface_erroneous_records
  WHERE  ier_ih_id = p_ih_id
  AND    ier_record_type = '10';

  UPDATE interface_headers
  SET    ih_error = 'Warning: Check record totals do not tally.'
  WHERE  ih_no_of_recs != l_count_1 + l_count_2
  AND    ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_wor_no(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Invalid Works Order Number. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_orders
                     WHERE  wor_works_order_no =  ic_works_order_no)
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_wor_con(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Works Order has not been issued to this Contractor. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_orders
                           ,org_units
                           ,contracts
                           ,interface_headers
                     WHERE  wor_works_order_no = ic_works_order_no
                     AND    wor_con_id = con_id
                     AND    con_contr_org_id = oun_org_id
                     AND    oun_contractor_id = ih_contractor_id
                     AND    ih_id = ic_ih_id)
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_wol_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Invalid Work Order Line. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                     WHERE  wol_id =  ic_wol_id)
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_defect_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Invalid Defect. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   defects
                     WHERE  def_defect_id = ic_defect_id)
  AND    ic_defect_id IS NOT NULL
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_schd_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Invalid Schedule. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   schedules
                     WHERE  schd_id = ic_schd_id)
  AND    ic_schd_id IS NOT NULL
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_def_wol(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Defect not on this Work Order Line. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                     WHERE  wol_id = ic_wol_id
                     AND    wol_def_defect_id = ic_defect_id)
  AND    ic_defect_id IS NOT NULL
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_wor_wol(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Work Order Line not on this Work Order. ', 1, 254)
        ,ic_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                     WHERE  wol_id = ic_wol_id
                     AND    wol_works_order_no = ic_works_order_no)
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_not_complete(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'Work already complete. ', 1, 254)
        ,ic_status = 'R'
  WHERE  EXISTS (SELECT 1
                 FROM   work_order_lines
                 WHERE  wol_id = ic_wol_id
                 AND    wol_date_repaired IS NOT NULL/*= g_wol_comp_status*/)
  AND    ic_ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_status_codes(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN
  UPDATE interface_completions
  SET    ic_error = SUBSTR(ic_error||'More than one (WORK_ORDER_LINES) status code with feature 7 ', 1, 254)
        ,ic_status = 'R'
  WHERE  1 < (SELECT COUNT(1)
                 FROM   hig_status_codes
                 WHERE  hsc_allow_feature7 = 'Y'
                 AND    hsc_domain_code = 'WORK_ORDER_LINES')
  AND    ic_ih_id = p_ih_id;
END;

---------------------------------------------------------------------

PROCEDURE validate_date_complete(p_ih_id IN interface_headers.ih_id%TYPE) IS

  l_option hig_options.hop_value%TYPE;

BEGIN

  l_option := hig.get_sysopt('COMPLEDATE');

  IF l_option = 'N' then

     UPDATE interface_completions
     SET    ic_error = SUBSTR(ic_error||'Completed date must be >= Instructed Date and not in the future. ', 1, 254)
           ,ic_status = 'R'
     WHERE (EXISTS (SELECT 1
                      FROM  work_orders
                     WHERE  wor_works_order_no = ic_works_order_no
                       AND  NVL(wor_date_confirmed, ic_date_completed + 1) > ic_date_completed)
       OR    ic_date_completed > SYSDATE)
      AND    ic_ih_id = p_ih_id;
 
  END IF;

END;

---------------------------------------------------------------------

PROCEDURE validate_wo_item(p_ih_id IN interface_headers.ih_id%TYPE, p_type varchar2, p_from number) IS
  CURSOR c1 IS
  SELECT icboq_wol_id, icboq_con_claim_ref
  FROM interface_claims_boq
  WHERE icboq_status = 'R'
    AND icboq_ih_id = p_ih_id;
  CURSOR c2 IS
  SELECT COUNT(1)
  FROM interface_claims_wor
  WHERE icwor_status = 'R'
    AND icwor_ih_id = p_ih_id;
  CURSOR c3 IS
  SELECT icwol_wol_id, icwol_con_claim_ref
  FROM interface_claims_wol
  WHERE icwol_status = 'R'
    AND icwol_ih_id = p_ih_id;
  CURSOR c4 IS
  SELECT COUNT(1)
  FROM interface_claims_wor
  WHERE icwor_status != 'R'
    AND icwor_ih_id = p_ih_id;
  l_count number;
  l_error varchar2(1000);
BEGIN
IF p_type = 'BOQ'
  THEN
    l_error := 'A Bill Item line has been rejected. ';
    FOR c1rec IN c1 LOOP
      UPDATE interface_claims_wol
      SET    icwol_error = SUBSTR(icwol_error||l_error, 1, 254)
            ,icwol_status = 'R'
      WHERE  icwol_ih_id = p_ih_id
        AND  icwol_wol_id = c1rec.icboq_wol_id
        AND  icwol_con_claim_ref = c1rec.icboq_con_claim_ref
        AND  icwol_status != 'R';
    END LOOP;
ELSIF p_type = 'WOL'
     THEN
       l_error := 'A Works Order line has been rejected. ';
   ELSIF p_type = 'WOR'
        THEN
          l_error := 'The Works Order has been rejected. ';
END IF;
IF p_type IN ('BOQ','WOL')
  THEN
    FOR c3rec IN c3 LOOP
    UPDATE interface_claims_wor
    SET    icwor_error = SUBSTR(icwor_error||l_error, 1, 254)
          ,icwor_status = 'R'
    WHERE  icwor_ih_id = p_ih_id
      AND  icwor_con_claim_ref = c3rec.icwol_con_claim_ref
      AND  icwor_status != 'R';
      END LOOP;
END IF;
    OPEN c2;
    FETCH c2 INTO l_count;
    IF l_count = 1
      THEN
        CLOSE c2;
        OPEN c4;
        FETCH c4 INTO l_count;
        IF l_count = 0 THEN
          CLOSE c4;
          UPDATE interface_headers
          SET    ih_error = SUBSTR(ih_error||l_error, 1, 254)
                ,ih_status = 'R'
          WHERE  ih_id = p_ih_id
            AND  ih_status != 'R';
        ELSE
          CLOSE c4;
          l_error := 'Warning: '||l_error;
          UPDATE interface_headers
          SET    ih_error = SUBSTR(ih_error||l_error, 1, 254)
  --              ,ih_status = 'R'
          WHERE  ih_id = p_ih_id
            AND  ih_status != 'R';
        END IF;
    ELSIF l_count > 1 THEN
        CLOSE c2;
        OPEN c4;
        FETCH c4 INTO l_count;
        IF l_count > 0 THEN
          UPDATE interface_headers
          SET    ih_error = SUBSTR('Warning: '||ih_error||l_error, 1, 254)
  --              ,ih_status = 'R'
          WHERE  ih_id = p_ih_id
            AND  ih_status != 'R';
        END IF;
        CLOSE c4;
    END IF;
END;
---------------------------------------------------------------------
PROCEDURE validate_wo_item_warnings(p_ih_id IN interface_headers.ih_id%TYPE, p_type varchar2, p_from number) IS
  CURSOR c1 IS
  SELECT icboq_wol_id, icboq_con_claim_ref
  FROM interface_claims_boq
  WHERE icboq_error IS NOT NULL
    AND icboq_status != 'R'
    AND icboq_ih_id = p_ih_id;
  CURSOR c2 IS
  SELECT COUNT(1)
  FROM interface_claims_wor
  WHERE icwor_error IS NOT NULL
    AND icwor_status != 'R'
    AND icwor_ih_id = p_ih_id;
  CURSOR c3 IS
  SELECT icwol_wol_id, icwol_con_claim_ref
  FROM interface_claims_wol
  WHERE icwol_error IS NOT NULL
    AND icwol_status != 'R'
    AND icwol_ih_id = p_ih_id;
  CURSOR c4 IS
  SELECT COUNT(1)
  FROM interface_claims_wor
  WHERE icwor_status != 'R'
    AND icwor_ih_id = p_ih_id;
  l_count number;
  l_error varchar2(1000);
BEGIN
IF p_type = 'BOQ'
  THEN
    l_error := 'Warning: A Bill Item line has a warning. ';
    FOR c1rec IN c1 LOOP
      UPDATE interface_claims_wol
      SET    icwol_error = SUBSTR(icwol_error||l_error, 1, 254)
      WHERE  icwol_ih_id = p_ih_id
        AND  icwol_wol_id = c1rec.icboq_wol_id
        AND  icwol_con_claim_ref = c1rec.icboq_con_claim_ref
        AND  icwol_status != 'R';
    END LOOP;
ELSIF p_type = 'WOL'
     THEN
       l_error := 'Warning: A Works Order line has has a warning. ';
   ELSIF p_type = 'WOR'
        THEN
          l_error := 'Warning: The Works Order has has a warning. ';
END IF;
IF p_type IN ('BOQ','WOL')
  THEN
    FOR c3rec IN c3 LOOP
    UPDATE interface_claims_wor
    SET    icwor_error = SUBSTR(icwor_error||l_error, 1, 254)
    WHERE  icwor_ih_id = p_ih_id
      AND  icwor_con_claim_ref = c3rec.icwol_con_claim_ref
      AND  icwor_status != 'R';
      END LOOP;
END IF;
    OPEN c2;
    FETCH c2 INTO l_count;
    IF l_count > 0
      THEN
        CLOSE c2;
          UPDATE interface_headers
          SET    ih_error = SUBSTR(ih_error||l_error, 1, 254)
          WHERE  ih_id = p_ih_id
            AND  ih_status != 'R';
    END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_check_rec(p_ih_id IN interface_headers.ih_id%TYPE) IS

  l_total_value    number;
  l_count_1        number;
  l_count_2        number;
  l_count_3        number;
  l_count_4        number;

BEGIN

  SELECT COUNT(0)
      ,SUM(icwor_claim_value)
  INTO   l_count_1
      ,l_total_value
  FROM   interface_claims_wor_all
  WHERE  NVL(icwor_status,'R') != 'D'
  AND    icwor_ih_id = p_ih_id;

  SELECT COUNT(0)
  INTO   l_count_2
  FROM   interface_claims_wol_all
  WHERE  NVL(icwol_status,'R') != 'D'
  AND    icwol_ih_id = p_ih_id;

  SELECT COUNT(0)
  INTO   l_count_3
  FROM   interface_claims_boq_all
  WHERE  NVL(icboq_status,'R') != 'D'
  AND    icboq_ih_id = p_ih_id;

  SELECT COUNT(0)
  INTO   l_count_4
  FROM   interface_erroneous_records
  WHERE  ier_ih_id = p_ih_id
  AND    ier_record_type IN ('05', '10', '15');

  UPDATE interface_headers
  SET    ih_error = 'Warning: Either the total records ('||TO_CHAR(l_count_1 + l_count_2 + l_count_3 + l_count_4)||') or total value ('||TO_CHAR(l_total_value)||') on line 20 ('||ih_no_of_recs||', '||ih_total_value||') fails to match'
  WHERE (ih_no_of_recs != l_count_1 + l_count_2 + l_count_3 + l_count_4
   OR    ih_total_value != l_total_value)
  AND    ih_id = p_ih_id;

END;

---------------------------------------------------------------------

PROCEDURE validate_claim_type(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Invalid Claim Type. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  icwor_claim_type NOT IN ('F','P','I')
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',1);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_unique(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'A Claim with this reference already exists for this contractor. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  EXISTS ( SELECT 1
            FROM     work_order_claims
            WHERE     woc_con_id = icwor_con_id
            AND    woc_claim_ref = icwor_con_claim_ref )
  AND    icwor_ih_id = p_ih_id;

  IF SQL%rowcount > 0 THEN
    validate_wo_item(p_ih_id,'WOR',2);
  END IF;

  -- D-125250
  if g_multifinal = 'N'
  then

     UPDATE interface_claims_wol
     SET    icwol_error = SUBSTR(icwol_error||'A Final Claim has already been processed for this work order line. ', 1, 254)
           ,icwol_status = 'R'
     WHERE  EXISTS ( SELECT 1
               FROM     claim_payments
                   ,work_order_claims
                   ,interface_claims_wor
               WHERE     woc_con_id = cp_woc_con_id
               AND    woc_claim_ref = cp_woc_claim_ref
               AND    woc_claim_type = 'F'
               AND     cp_wol_id = icwol_wol_id
               AND    icwol_con_claim_ref = icwor_con_claim_ref
               AND     icwol_con_id = icwor_con_id
               AND    icwol_ih_id = icwor_ih_id
               AND    icwor_claim_type != 'P' ) -- only perform check for non-post invoices
     AND    icwol_ih_id = p_ih_id;
  end if;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_date(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Claim date must be > Instructed Date. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  icwor_date_confirmed > icwor_claim_date
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',3);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_wor_no(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Invalid Works Order Number. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_orders
                     WHERE  wor_works_order_no = icwor_works_order_no)
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',4);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_wor_con(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Works Order has not been issued to this Contractor. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_orders
                           ,org_units
                           ,contracts
                           ,interface_headers
                     WHERE  wor_works_order_no = icwor_works_order_no
                     AND    wor_con_id = con_id
                     AND    con_contr_org_id = oun_org_id
                     AND    oun_contractor_id = ih_contractor_id
                     AND    ih_id = icwor_ih_id)
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',5);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_originator(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Invalid Originator. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   hig_users
                     WHERE  hus_name = icwor_originator)
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',6);
END IF;
END;

---------------------------------------------------------------------
-- Is this check required???
--
PROCEDURE validate_claim_value(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'The total order claim value does not equal the sum of the line claim values. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  icwor_claim_value != (  SELECT SUM(icwol_claim_value)
                             FROM   interface_claims_wol
                             WHERE  icwol_ih_id = icwor_ih_id
                       AND    icwol_con_claim_ref = icwor_con_claim_ref
                       AND    icwol_con_id = icwor_con_id )
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',7);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_commence_date(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Commence By Date must be < Claim Date and not in the future. ', 1, 254)
        ,icwor_status = 'R'
  WHERE (icwor_commence_by > icwor_claim_date
   OR    icwor_commence_by > SYSDATE)
  AND    icwor_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',8);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_completed_date(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN
    
IF hig.get_sysopt('COMPLEDATE') = 'N' THEN
  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Completed Date must be > Commence By Date and > Instructed Date. ', 1, 254)
        ,icwor_status = 'R'
  WHERE (icwor_date_closed < icwor_commence_by
   OR    icwor_date_closed < icwor_date_confirmed)
  AND    icwor_ih_id = p_ih_id;
END IF;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOR',9);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_wol_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Invalid Work Order Line. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                     WHERE  wol_id =  icwol_wol_id)
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',24);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_defect_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Invalid Defect. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   defects
                     WHERE  def_defect_id = icwol_defect_id)
  AND    icwol_defect_id IS NOT NULL
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',23);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_schd_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Invalid Schedule. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   schedules
                     WHERE  schd_id = icwol_schd_id)
  AND    icwol_schd_id IS NOT NULL
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',22);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_def_wol(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Defect not on this Work Order Line. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                     WHERE  wol_id = icwol_wol_id
                     AND    wol_def_defect_id = icwol_defect_id)
  AND    icwol_defect_id IS NOT NULL
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',21);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_wor_wol(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Work Order Line not on this Work Order. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                     FROM   work_order_lines
                   ,interface_claims_wor
                     WHERE  wol_id = icwol_wol_id
                     AND    wol_works_order_no = icwor_works_order_no
               AND    icwol_con_claim_ref = icwor_con_claim_ref
               AND    icwol_con_id = icwor_con_id
               AND    icwol_ih_id = icwor_ih_id)
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',20);
END IF;
END;

---------------------------------------------------------------------
-- Is this check required???
--
PROCEDURE validate_wol_claim_value(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'The order line claim value does not equal the sum of the bill item costs. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  icwol_claim_value != (  SELECT SUM(icboq_cost)
                             FROM   interface_claims_boq
                             WHERE  icboq_ih_id = icwol_ih_id
                       AND    icboq_con_claim_ref = icwol_con_claim_ref
                       AND    icboq_con_id = icwol_con_id
                       AND    icboq_wol_id = icwol_wol_id )
  AND    icwol_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',21);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_date_complete(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN
IF hig.get_sysopt('COMPLEDATE') = 'N' THEN
  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Completed date must be >= Order Instructed Date and not in the future. ', 1, 254)
        ,icwol_status = 'R'
  WHERE (EXISTS ( SELECT 1
            FROM   work_orders
                ,interface_claims_wor
            WHERE  wor_works_order_no = icwor_works_order_no
            AND     icwol_con_claim_ref = icwor_con_claim_ref
            AND    icwol_con_id = icwor_con_id
            AND    icwol_ih_id = icwor_ih_id
            AND    NVL(wor_date_confirmed, icwol_date_complete + 1) > icwol_date_complete)
   OR    icwol_date_complete > SYSDATE)
  AND    icwol_ih_id = p_ih_id;
END IF;  
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',20);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_item_code(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Invalid Bill Item Code. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  NOT EXISTS (SELECT 1
                        FROM   standard_items
                     WHERE  icboq_sta_item_code = sta_item_code)
  AND    icboq_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',10);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_quantity(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Bill Item quantity does not equal the product of its dimensions. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  icboq_quantity != ROUND((icboq_dim1 * NVL(icboq_dim2, 1) * NVL(icboq_dim3, 1)), 2)
  AND    icboq_ih_id = p_ih_id;

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Credit quantity exceeds the total actual quantity. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  icboq_quantity < 0
  AND    ABS(icboq_quantity) > (SELECT SUM(boq_act_quantity)
                      FROM   boq_items
                      WHERE  boq_wol_id = icboq_wol_id
                      AND    boq_sta_item_code = icboq_sta_item_code)
  AND    icboq_ih_id = p_ih_id;

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Bill Item quantity does not fall between the min and max values for this item. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  (icboq_quantity < (SELECT sta_min_quantity
                           FROM standard_items
                           WHERE sta_item_code = icboq_sta_item_code)
  OR     icboq_quantity > (SELECT sta_max_quantity
                           FROM standard_items
                           WHERE sta_item_code = icboq_sta_item_code))
  AND    icboq_ih_id = p_ih_id
  AND    icboq_ih_id IN (SELECT icwor_ih_id
                         FROM interface_claims_wor
                         WHERE icwor_claim_type != 'P');

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',11);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_cost(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN
IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3', '2-4-0') THEN
  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Bill Item cost does not equal the product of its quantity and rate. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  icboq_cost != ROUND((icboq_dim1 * NVL(icboq_dim2, 1) * NVL(icboq_dim3, 1) * icboq_rate), 2)
  AND    icboq_ih_id = p_ih_id;
ELSE
  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Bill Item cost does not equal the product of its quantity and rate. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  icboq_cost != ROUND((icboq_dim1 * NVL(icboq_dim2, 1) * NVL(icboq_dim3, 1) * icboq_rate), 2)
  AND    icboq_ih_id = p_ih_id
  AND    icboq_parent_boq_id IS NULL
  AND    icboq_percent_band_comp IS NULL;
END IF;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',12);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_claim_cost_percent(p_ih_id IN interface_headers.ih_id%TYPE) IS
CURSOR boq1_n IS
SELECT *
FROM interface_claims_boq
WHERE icboq_ih_id = p_ih_id
  AND icboq_parent_boq_id IS NULL;
CURSOR percentage1_n(p_boq_id interface_claims_boq.icboq_boq_id%TYPE) IS
SELECT *
FROM interface_claims_boq
WHERE icboq_ih_id = p_ih_id
  AND icboq_parent_boq_id = p_boq_id;
/*  AND icboq_percent_band_comp = 'N'*/
CURSOR boq1_c IS
SELECT *
FROM interface_claims_boq
WHERE icboq_ih_id = p_ih_id
  AND icboq_parent_boq_id IS NULL;
CURSOR boq2_c(p_boq_id interface_claims_boq.icboq_boq_id%TYPE) IS
SELECT *
FROM interface_claims_boq
WHERE icboq_ih_id = p_ih_id
--  AND icboq_parent_boq_id IS NULL
  AND icboq_boq_id = p_boq_id
  AND icboq_percent_band_comp = 'C';
CURSOR percentage1_c(p_boq_id interface_claims_boq.icboq_boq_id%TYPE) IS
SELECT *
FROM interface_claims_boq
WHERE icboq_ih_id = p_ih_id
  AND icboq_parent_boq_id = p_boq_id
  AND icboq_percent_band_comp = 'C';
l_cumulative_total number := 0;
l_count number := 0;
BEGIN
FOR c1rec IN boq1_n LOOP --all the parent boq items for this wol
  l_cumulative_total := c1rec.icboq_cost;
  FOR c2rec IN percentage1_n(c1rec.icboq_boq_id) LOOP --all the children of each parent
    l_count := l_count + 1;
    IF c2rec.icboq_percent_band_comp = 'N' THEN
      UPDATE interface_claims_boq
      SET    icboq_error = SUBSTR(icboq_error||'1) Bill Item cost does not equal the product of its quantity and rate. '||c2rec.icboq_boq_id||c2rec.icboq_percent_band_comp, 1, 254)
            ,icboq_status = 'R'
      WHERE  0.03 <= abs(icboq_cost - ROUND((icboq_rate/100)*(c1rec.icboq_percent_adjust),2))--SM 13082008 715407 introduced a 0.03 tolerance
      AND    icboq_ih_id = p_ih_id
      AND    icboq_boq_id = c2rec.icboq_boq_id
      AND    icboq_percent_band_comp = c2rec.icboq_percent_band_comp
      AND    icboq_wol_id = c1rec.icboq_wol_id --SM - 12122006 - 706220 - Was displaying error incorrectly in files with multiple WORS
      AND    icboq_parent_boq_id IS NOT NULL;
      l_cumulative_total := l_cumulative_total + c2rec.icboq_cost;
    ELSE
      IF l_count = 1 THEN
       --the 1st % item is calculated against the item cost regardless.
        UPDATE interface_claims_boq
        SET    icboq_error = SUBSTR(icboq_error||'2) Bill Item cost does not equal the product of its quantity and rate. '||c2rec.icboq_boq_id||c2rec.icboq_percent_band_comp, 1, 254)
              ,icboq_status = 'R'
        WHERE  0.03 <= abs(icboq_cost - ROUND((icboq_rate/100)*(c1rec.icboq_percent_adjust),2))--SM 13082008 715407 introduced a 0.03 tolerance
        AND    icboq_ih_id = p_ih_id
    AND    icboq_boq_id = c2rec.icboq_boq_id
        AND    icboq_percent_band_comp = c2rec.icboq_percent_band_comp
        AND    icboq_wol_id = c1rec.icboq_wol_id --SM - 12122006 - 706220 - Was displaying error incorrectly in files with multiple WORS
        AND    icboq_parent_boq_id IS NOT NULL;
        l_cumulative_total := l_cumulative_total + c2rec.icboq_cost;
      ELSE
      --% items other than the 1st are calculated against the item cost plus the previous % costs.
        UPDATE interface_claims_boq
        SET    icboq_error = SUBSTR(icboq_error||'3) Bill Item cost does not equal the product of its quantity and rate. ', 1, 254)
              ,icboq_status = 'R'
        WHERE  0.03 <= abs(icboq_cost - ROUND((icboq_rate/100)*(c1rec.icboq_percent_adjust),2))--SM 13082008 715407 introduced a 0.03 tolerance
        AND    icboq_ih_id = p_ih_id
    AND    icboq_boq_id = c2rec.icboq_boq_id
      AND    icboq_percent_band_comp = c2rec.icboq_percent_band_comp
        AND    icboq_wol_id = c1rec.icboq_wol_id --SM - 12122006 - 706220 - Was displaying error incorrectly in files with multiple WORS
        AND    icboq_parent_boq_id IS NOT NULL;
        l_cumulative_total := l_cumulative_total + c2rec.icboq_cost;
      END IF;
    END IF;
  END LOOP;
END LOOP;
/*
FOR c1rec IN boq1_C LOOP --all the parent boq items for this wol (cumulative)
  l_cumulative_total := c1rec.icboq_cost;
  FOR c2rec IN percentage1_C(c1rec.icboq_boq_id) LOOP --all the children % items of each parent
    --for each child use the parent boq to total up the costs of all the parents to enable validation of the cumulative % items
    l_count := l_count + 1;
    IF l_count = 1 THEN
    --the 1st % item is calculated against the item cost regardless.
      UPDATE interface_claims_boq
      SET    icboq_error = SUBSTR(icboq_error||'Bill Item cost does not equal the product of its quantity and rate. ', 1, 254)
            ,icboq_status = 'R'
      WHERE  icboq_cost != ROUND((icboq_rate/100)*(c1rec.icboq_cost),2)
      AND    icboq_ih_id = p_ih_id
      AND    icboq_boq_id = c1rec.icboq_boq_id
      AND    icboq_parent_boq_id IS NOT NULL;
        l_cumulative_total := l_cumulative_total + c2rec.icboq_cost;
    ELSE
    --% items other than the 1st are calculated against the item cost plus the previous % costs.
      UPDATE interface_claims_boq
      SET    icboq_error = SUBSTR(icboq_error||'Bill Item cost does not equal the product of its quantity and rate. ', 1, 254)
            ,icboq_status = 'R'
      WHERE  icboq_cost != ROUND((icboq_rate/100)*(l_cumulative_total),2)
      AND    icboq_ih_id = p_ih_id
      AND    icboq_boq_id = c1rec.icboq_boq_id
      AND    icboq_parent_boq_id IS NOT NULL;
      l_cumulative_total := l_cumulative_total + c2rec.icboq_cost;
    END IF;
  END LOOP;
END LOOP;*/
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',12);
END IF;
END;
---------------------------------------------------------------------
PROCEDURE validate_percent_band_comp(p_ih_id IN interface_headers.ih_id%TYPE) IS
cum_perc varchar2(1);
BEGIN
  cum_perc := SUBSTR(hig.get_sysopt('CUM_PERC'),1,1);
  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'Warning: The % flag in the Invoice file differs to the CUM_PERC product option. ', 1, 254)
  WHERE  icboq_percent_band_comp != cum_perc
  AND    icboq_ih_id = p_ih_id;
IF SQL%rowcount > 0 THEN
  validate_wo_item_warnings(p_ih_id,'BOQ',13);
  validate_wo_item(p_ih_id,'BOQ',13);
END IF;
END;
---------------------------------------------------------------------

PROCEDURE validate_claim_rate(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'This Bill Items Rate does not match its rate on the Works Order. ', 1, 254)
        ,icboq_status = 'R'
  WHERE  NOT EXISTS ( SELECT 1
                FROM  boq_items
                WHERE boq_sta_item_code = icboq_sta_item_code
                AND    boq_wol_id = icboq_wol_id
                AND    icboq_rate = NVL(boq_act_rate, boq_est_rate) )
  AND    EXISTS( SELECT 1
                   FROM standard_items
                  WHERE sta_item_code = icboq_sta_item_code
                    AND NVL(sta_rogue_flag, 'N') = 'N')           
  AND    EXISTS ( SELECT 1
            FROM   boq_items
            WHERE  boq_sta_item_code = icboq_sta_item_code
            AND    boq_wol_id = icboq_wol_id )
  AND    icboq_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',13);
END IF;
END;

---------------------------------------------------------------------
PROCEDURE validate_claim_rogue(p_ih_id IN interface_headers.ih_id%TYPE) IS
CURSOR c1 IS
  SELECT icboq_rogue_item
  FROM interface_claims_boq
  WHERE icboq_ih_id = p_ih_id;

  l_rogue_item interface_claims_boq.icboq_rogue_item%TYPE := 'N';

BEGIN

  UPDATE interface_claims_boq
  SET    icboq_error = SUBSTR(icboq_error||'This Bill Item has an invalid option for the Rogue field (must be R, N or NULL) ', 1, 254)
         ,icboq_status = 'R'  -- Task 0108536 rejected the BOQ if the rates does not match 
  WHERE  icboq_rogue_item NOT IN ('R', 'N', 'NULL', '')
  AND    icboq_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',13);
ELSE
--if the rogue item flag is R
  OPEN c1;
  FETCH c1 INTO l_rogue_item;
  CLOSE c1;
  IF l_rogue_item != 'R' THEN
    validate_claim_rate(p_ih_id);
  END IF;
END IF;
END;

---------------------------------------------------------------------
-- Final and Interim claims are not valid for completed WOLs and must
-- include a completed date.

PROCEDURE validate_claim_not_complete(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Work already complete. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  EXISTS (SELECT 1
                 FROM   work_order_lines
                 ,interface_claims_wor
                 WHERE  wol_id = icwol_wol_id
                 AND    wol_status_code = g_wol_comp_status
             AND    icwor_works_order_no = wol_works_order_no
             AND    icwor_claim_type IN ('F', 'I')
             AND    icwor_con_claim_ref = icwol_con_claim_ref
             AND    icwor_con_id = icwol_con_id
             AND    icwor_ih_id = p_ih_id)
  AND    icwol_ih_id = p_ih_id;

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Date complete cannot be null for final invoices. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  EXISTS (SELECT 1
                 FROM   interface_claims_wor
                 WHERE  icwor_claim_type IN ('F')
             AND    icwol_date_complete IS NULL
             AND    icwor_con_claim_ref = icwol_con_claim_ref
             AND    icwor_con_id = icwol_con_id
             AND    icwor_ih_id = p_ih_id)
  AND    icwol_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',14);
END IF;
END;


---------------------------------------------------------------------
-- Interim claims are not valid if another interim claim with a higher
-- invoice number has/is been/being made.

PROCEDURE validate_interim_no(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor icwor1
  SET    icwor_error = SUBSTR(icwor_error||DECODE(icwor_claim_type, 'I','An interim', 'A Final')|| 
                              ' invoice with a higher or equal number exists for at least one WOL on this invoice. ', 1, 254)
        ,icwor_status = 'R'
  WHERE  EXISTS (SELECT 1    -- an interim invoice with a higher no. has already been processed for this WOL
                 FROM   work_order_claims
                 ,claim_payments
                 ,interface_claims_wol
                 WHERE  woc_claim_type = icwor_claim_type
             AND    woc_interim_no >= NVL(icwor1.icwor_interim_no,0)
             AND    cp_woc_claim_ref = woc_claim_ref
             AND    cp_woc_con_id = woc_con_id
             AND    icwol_wol_id = cp_wol_id
             AND    icwol_con_claim_ref = icwor1.icwor_con_claim_ref
             AND    icwol_con_id = icwor1.icwor_con_id
             AND    icwol_ih_id = icwor1.icwor_ih_id
             UNION
             SELECT 1    -- the file contains two interim invoices for the same WOL
             FROM   interface_claims_wor icwor2
                 ,interface_claims_wol icwol1
                 ,interface_claims_wol icwol2
             WHERE  icwor1.icwor_con_claim_ref = icwol1.icwol_con_claim_ref
             AND    icwor1.icwor_con_id = icwol1.icwol_con_id
             AND    icwor2.icwor_con_claim_ref = icwol2.icwol_con_claim_ref
             AND    icwor2.icwor_con_id = icwol2.icwol_con_id
             AND    icwol1.icwol_wol_id = icwol2.icwol_wol_id
             AND    icwor1.icwor_works_order_no = icwor2.icwor_works_order_no
             AND    icwor1.icwor_claim_type = icwor2.icwor_claim_type
             AND    icwor1.icwor_ih_id = icwor2.icwor_ih_id
             AND    icwor2.icwor_interim_no >= NVL(icwor1.icwor_interim_no,0)
             AND    icwor2.icwor_con_claim_ref != icwor1.icwor_con_claim_ref)
  AND    icwor_claim_type IN ('I', 'F')
  AND    icwor_ih_id = p_ih_id;

END;


---------------------------------------------------------------------
-- Post claims are only valid for completed WOLs
--

PROCEDURE validate_claim_complete(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Work not complete. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  EXISTS (SELECT 1
                 FROM   work_order_lines
                 ,interface_claims_wor
                 WHERE  wol_id = icwol_wol_id
         AND    wol_date_complete IS NULL
             AND    icwor_works_order_no = wol_works_order_no
             AND    icwor_claim_type = 'P'
             AND    icwor_con_claim_ref = icwol_con_claim_ref
             AND    icwor_con_id = icwol_con_id
             AND    icwor_ih_id = p_ih_id)
  AND    icwol_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',15);
END IF;
END;

---------------------------------------------------------------------

PROCEDURE validate_completed_dates(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wor
  SET    icwor_error = SUBSTR(icwor_error||'Warning: Date complete does not match that on Works Order. ', 1, 254)
  WHERE  icwor_claim_type = 'P'
  AND    NVL(icwor_date_closed, TO_DATE('01-JAN-0001', 'DD-MON-YYYY')) !=
        (SELECT NVL(wor_date_closed, TO_DATE('01-JAN-0001', 'DD-MON-YYYY'))
         FROM   work_orders
         WHERE  wor_works_order_no = icwor_works_order_no)
  AND    icwor_ih_id = p_ih_id;

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Warning: Date complete does not match that on Works Order Line. ', 1, 254)
  WHERE  EXISTS ( SELECT 1
            FROM   interface_claims_wor
            WHERE  icwor_claim_type = 'P'
            AND    icwor_con_claim_ref = icwol_con_claim_ref
            AND    icwor_con_id = icwol_con_id
            AND    icwor_ih_id = p_ih_id )
  AND    icwol_date_complete != (SELECT wol_date_complete
                       FROM   work_order_lines
                       WHERE  wol_id = icwol_wol_id)
  AND    icwol_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item_warnings(p_ih_id,'WOL',16);
  validate_wo_item(p_ih_id,'WOL',16);
END IF;
END;

---------------------------------------------------------------------
-- Reject work order lines that have invalid BoQs
--

PROCEDURE validate_claim_boqs(p_ih_id IN interface_headers.ih_id%TYPE) IS
BEGIN

  UPDATE interface_claims_wol
  SET    icwol_error = SUBSTR(icwol_error||'Invalid Bill Items exist. ', 1, 254)
        ,icwol_status = 'R'
  WHERE  EXISTS ( SELECT 1
            FROM   interface_claims_boq
            WHERE  icwol_con_claim_ref = icboq_con_claim_ref
            AND    icwol_con_id = icboq_con_id
            AND    icwol_ih_id = icboq_ih_id
            AND    icwol_wol_id = icboq_wol_id
            AND    icboq_status != 'P' )
  AND    icwol_ih_id = p_ih_id;

IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',17);
END IF;
END;
---------------------------------------------------------------------
-- Reject boq items with id that isn't on the wol
--
PROCEDURE validate_boq_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
CURSOR c1 IS
  SELECT *
  FROM   interface_claims_boq
  WHERE  icboq_ih_id = p_ih_id;
CURSOR c2 (l_sta_item_code interface_claims_boq.icboq_sta_item_code%TYPE,
          l_wol_id interface_claims_boq.icboq_wol_id%TYPE
          )IS
  SELECT COUNT(1)
  FROM   boq_items
  WHERE  boq_sta_item_code = l_sta_item_code
  AND    boq_wol_id = l_wol_id;

CURSOR c3 (l_sta_item_code interface_claims_boq.icboq_sta_item_code%TYPE,
          l_wol_id interface_claims_boq.icboq_wol_id%TYPE
          )IS
  SELECT boq_id
  FROM   boq_items
  WHERE  boq_sta_item_code = l_sta_item_code
  AND    boq_wol_id = l_wol_id;
l_count number;
l_boq_id boq_items.boq_id%TYPE;
l_row_count number;
BEGIN
  FOR c1rec IN c1 LOOP
    IF c1rec.icboq_boq_id IS NOT NULL THEN

      IF SIGN(c1rec.icboq_boq_id) != -1 THEN
        UPDATE interface_claims_boq
        SET    icboq_error = SUBSTR(icboq_error||'Invalid boq_id for this item. ('||c1rec.icboq_boq_id||')', 1, 254)
              ,icboq_status = 'R'
        WHERE  NOT EXISTS (SELECT 1
                               FROM   boq_items
                            WHERE  icboq_boq_id = boq_id
                            AND    icboq_wol_id = boq_wol_id)
        AND    icboq_ih_id = p_ih_id
        AND    icboq_boq_id = c1rec.icboq_boq_id;
        l_row_count := l_row_count + SQL%rowcount;
      END IF;
    ELSE
      OPEN c2(c1rec.icboq_sta_item_code, c1rec.icboq_wol_id);
      FETCH c2 INTO l_count;
      IF l_count = 1 THEN
        CLOSE c2;
        OPEN c3(c1rec.icboq_sta_item_code, c1rec.icboq_wol_id);
        FETCH c3 INTO l_boq_id;
        UPDATE interface_claims_boq
            SET    icboq_boq_id = l_boq_id
            WHERE  icboq_sta_item_code = c1rec.icboq_sta_item_code
            AND    icboq_ih_id = p_ih_id
        AND    icboq_wol_id = c1rec.icboq_wol_id;
        l_row_count := l_row_count - SQL%rowcount;
        CLOSE c3;
      ELSE
        CLOSE c2;
        UPDATE interface_claims_boq
            SET    icboq_error = SUBSTR(icboq_error||'No boq_id supplied and more than one boq items matched. ', 1, 254)
                  ,icboq_status = 'R'
            WHERE  icboq_sta_item_code = c1rec.icboq_sta_item_code
            AND    icboq_ih_id = p_ih_id
        AND    icboq_wol_id = c1rec.icboq_wol_id
        AND    icboq_boq_id IS NULL;
        l_row_count := l_row_count + SQL%rowcount;
      END IF;
    END IF;
IF l_row_count > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',10);
END IF;
  END LOOP;

END;
---------------------------------------------------------------------
-- Reject parent boq items with id that isn't on the wol
--
PROCEDURE validate_parent_boq_id(p_ih_id IN interface_headers.ih_id%TYPE) IS
CURSOR c1 IS
  SELECT *
  FROM   interface_claims_boq
  WHERE  icboq_ih_id = p_ih_id;
l_row_count number;
BEGIN
  FOR c1rec IN c1 LOOP
    IF c1rec.icboq_parent_boq_id IS NOT NULL THEN
      IF SIGN(c1rec.icboq_parent_boq_id) != -1 THEN
        UPDATE interface_claims_boq
        SET    icboq_error = SUBSTR(icboq_error||'Invalid parent_boq_id for this item. ', 1, 254)
              ,icboq_status = 'R'
        WHERE  NOT EXISTS (SELECT 1
                               FROM   boq_items
                            WHERE  icboq_parent_boq_id = boq_id
                            AND    icboq_wol_id = boq_wol_id)
        AND    icboq_ih_id = p_ih_id
        AND    icboq_parent_boq_id = c1rec.icboq_parent_boq_id;
        l_row_count := l_row_count + SQL%rowcount;
      END IF;
    ELSE
      UPDATE interface_claims_boq
      SET    icboq_error = SUBSTR(icboq_error||'Parent_boq_id is null. ', 1, 254)
            ,icboq_status = 'R'
      WHERE  NOT EXISTS (SELECT 1
                     FROM   boq_items
                         WHERE  icboq_parent_boq_id = boq_id
             AND    icboq_wol_id = boq_wol_id)
      AND    icboq_ih_id = p_ih_id
      AND    icboq_sta_item_code = c1rec.icboq_sta_item_code
      AND    icboq_wol_id = c1rec.icboq_wol_id
      AND    icboq_boq_id = c1rec.icboq_boq_id
      AND    icboq_percent_band_comp IS NOT NULL;
      l_row_count := l_row_count + SQL%rowcount;
    END IF;
IF l_row_count > 0 THEN
  validate_wo_item(p_ih_id,'BOQ',10);
END IF;

  END LOOP;
END;
---------------------------------------------------------------------
-- Validates all data processed in a Completion file. Called from
-- the completion_file_ph1 procedure and from the claims form (when
-- validating a completion record).
--

PROCEDURE validate_completion_data(p_ih_id IN interface_headers.ih_id%TYPE) 
IS
--
   l_option hig_options.hop_value%TYPE := hig.get_sysopt('COMPLEDATE');
--
BEGIN

  UPDATE interface_headers
  SET    ih_error = NULL
        ,ih_status = DECODE(ih_status, 'R', 'P', ih_status)
  WHERE  ih_id = p_ih_id;

  UPDATE interface_completions
  SET    ic_error = NULL
        ,ic_status = DECODE(ic_status, 'R', 'P', ic_status)
  WHERE ic_ih_id = p_ih_id;
  

  validate_contractor(p_ih_id);
  validate_check_rec(p_ih_id);

  FOR ic IN (SELECT ic.rowid ic_rowid
             FROM   interface_completions ic
             WHERE  ic_ih_id = p_ih_id
             AND    NOT  (ic_works_order_no like 'FAU%CLM' OR
                          ic_works_order_no  like 'WOR%CLM') 
            )
  LOOP
      --Validate the defect
      UPDATE interface_completions
      SET    ic_error = SUBSTR(ic_error||'Invalid Defect. ', 1, 254)
            ,ic_status = 'R'
      WHERE  NOT EXISTS (SELECT 1
                         FROM   defects
                         WHERE  def_defect_id = ic_defect_id)
      AND    ic_defect_id IS NOT NULL
      AND    rowid = ic.ic_rowid;
      --Check if Defect already complete
      UPDATE interface_completions
      SET    ic_error = SUBSTR(ic_error||'Defect already complete. ', 1, 254)
            ,ic_status = 'R'
      WHERE  EXISTS (SELECT 1
                     FROM   defects
                     WHERE  def_defect_id = ic_defect_id
                     AND    def_status_code = 'COMPLETED')
      AND    ic_defect_id IS NOT NULL
      AND    rowid = ic.ic_rowid;
  END LOOP ;
  IF hig.is_product_licensed('CLM')
  THEN      
      Execute Immediate 'BEGIN '||
                        '   clm_cim_interface.validate_completion_data(:1); '||
                        'END; ' Using p_ih_id ;
  END IF ;
END;

---------------------------------------------------------------------
-- Populates interface tables with data read in from a Completion file.
-- Called from the completion_file_ph1 procedure and from the claims
-- form (when validating an erroneous completion record).
--

PROCEDURE populate_wc_interface_tables(p_ih_id    IN OUT interface_headers.ih_id%TYPE
                          ,p_record IN     varchar2
                          ,p_error    IN OUT varchar2) IS

  l_record_type    varchar2(2) := int_utility.get_field(p_record, 1);

BEGIN
  IF l_record_type = '10' THEN -- completion record

    INSERT INTO interface_completions (
             ic_ih_id
            ,ic_works_order_no
            ,ic_wol_id
            ,ic_defect_id
            ,ic_schd_id
            ,ic_date_completed
            ,ic_fyr_id
            ,ic_comments
            ,ic_status
            ,ic_error)
    VALUES (
             p_ih_id
                        ,'XNHCC'||int_utility.get_field(p_record, 4)
            ,int_utility.get_field(p_record, 4)
            ,int_utility.get_field(p_record, 4)
            ,int_utility.get_field(p_record, 5)
            ,TO_DATE(TO_CHAR(check_date_format(int_utility.get_field(p_record, 6)), 'dd-mon-yyyy')
            ||' '||TO_CHAR(TO_DATE(NVL(int_utility.get_field(p_record, 7),'00:00:01')
            ,'HH24:MI:SS'),'HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
            ,int_utility.get_field(p_record, 8)
            ,int_utility.get_field(p_record, 9)
            ,'P'
            ,NULL);
    COMMIT;

  ELSIF l_record_type = '00' THEN -- header record

    IF p_ih_id IS NULL THEN

      SELECT ih_id_seq.NEXTVAL
      INTO   p_ih_id
      FROM   dual;

    END IF;

    INSERT INTO interface_headers (
             ih_id
            ,ih_file_type
            ,ih_contractor_id
            ,ih_seq_no
            ,ih_created_date
            ,ih_status
            ,ih_error)
    VALUES (
             p_ih_id
            ,'WC'
            ,UPPER(int_utility.get_field(p_record, 2))
            ,int_utility.get_field(p_record, 3)
            ,TO_DATE(check_date_format(int_utility.get_field(p_record, 4)/*, g_date_format*/)||
             TO_CHAR(TO_DATE(int_utility.get_field(p_record, 5), 'HH24:MI:SS')
            ,'HH24:MI:SS'),'DD-MON-YYHH24:MI:SS')
            ,'P'
            ,NULL);

  ELSIF p_ih_id IS NOT NULL AND l_record_type = '15' THEN -- check record

    UPDATE interface_headers
    SET    ih_no_of_recs = int_utility.get_field(p_record, 2)
    WHERE  ih_id = p_ih_id;

  END IF;

  p_error := NULL;    -- no errors occured

EXCEPTION
  WHEN others THEN

    IF p_error IS NULL THEN    -- new error

      p_error := SQLERRM;

      INSERT INTO interface_erroneous_records (
             ier_ih_id
            ,ier_record_type
            ,ier_record_text
            ,ier_error)
      VALUES (
             p_ih_id
            ,l_record_type
            ,p_record
            ,p_error);

    ELSE  -- validating existing error (from form)

      p_error := SQLERRM;    -- don't create an error record
                    -- one already exists
    END IF;

    IF l_record_type = '00' THEN    -- error with the header record
      p_ih_id := NULL;            -- mark for process halting
    END IF;

END;

---------------------------------------------------------------------
-- Automatically submits the current header if it passes validation.
-- Called from the completion_file_ph1 procedure.
--
PROCEDURE submit_record( p_ih_id    IN OUT interface_headers.ih_id%TYPE
                       , p_icwor_works_order_no interface_claims_wor_all.icwor_works_order_no%TYPE
                       , p_icwor_claim_value interface_claims_wor_all.icwor_claim_value%TYPE
                       ) IS

  l_response         number;
  l_file        varchar2(255);
  l_error        varchar2(500);

  CURSOR c1 (p_works_order_no work_order_lines.wol_works_order_no%TYPE) IS
    SELECT wol_rse_he_id
          ,wol_id
          ,wol_def_defect_id
          ,wol_act_cost
            ,wol_est_cost
          ,wol_bud_id
    FROM   work_order_lines
    WHERE  wol_works_order_no = p_works_order_no;

  CURSOR c2 (p_ih_id interface_headers.ih_id%TYPE) IS
    SELECT *
    FROM   interface_headers
    WHERE  ih_id = p_ih_id;

  l_works_order_no interface_claims_wor_all.icwor_works_order_no%TYPE;
  l_interface_header interface_headers%ROWTYPE;
  process_failure EXCEPTION;
  invalid_file EXCEPTION;
  --mandatory_is_null EXCEPTION;
  --PRAGMA EXCEPTION_INIT(mandatory_is_null, -01400);
BEGIN
IF p_ih_id IS NOT NULL
  THEN
    OPEN c2(p_ih_id);
    FETCH c2 INTO l_interface_header;
    CLOSE c2;
    IF l_interface_header.ih_file_type = 'WC'
      THEN
        xnhcc_interfaces.validate_completion_data(p_ih_id);--validate_completion;
    ELSE
      --validate_claim;--SM - NOT A WC FILE
      RAISE invalid_file;
    END IF;
    --
    OPEN c2(p_ih_id);
    FETCH c2 INTO l_interface_header;
    CLOSE c2;
      --
      IF l_interface_header.ih_status = 'P'
          THEN
          --
          IF l_interface_header.ih_file_type = 'WC'
            THEN
              xnhcc_interfaces.completion_file_ph2(p_ih_id);
          ELSIF l_interface_header.ih_file_type IN ('WI', 'M')
               THEN
                 RAISE invalid_file;
          END IF;
          --
      END IF;
END IF;
--
EXCEPTION
  WHEN invalid_file THEN
    NULL;
  WHEN others THEN
    NULL;
END;
------------------------------------------------------------------------------
PROCEDURE auto_load_file(p_ih_id    IN OUT interface_headers.ih_id%TYPE
                        ,p_record IN     varchar2
                        ,p_error    IN OUT varchar2) IS

  l_record_type    varchar2(2) := int_utility.get_field(p_record, 1);
  l_response         number;
  l_file        varchar2(255);
  l_error        varchar2(500);

  l_count number;

BEGIN
IF p_ih_id IS NOT NULL
  THEN
      submit_record ( p_ih_id, NULL, NULL );
END IF;

EXCEPTION
  WHEN others THEN
    NULL;
END;
---------------------------------------------------------------------
-- Checks the validation if the WC file and returns a Y or N accordingly.
--
PROCEDURE check_details_ok (p_ih_id IN interface_headers.ih_id%TYPE
                           ,p_file_type IN interface_headers.ih_file_type%TYPE
                           ,p_details_ok OUT varchar2
                           ) IS

  l_count_errors  number;
  l_count_errors2 number;
  l_count_errors3 number;
  l_count_records number;

BEGIN
  IF p_file_type IN ('WI', 'M') THEN

    SELECT COUNT(0)
    INTO   l_count_errors
    FROM   interface_claims_wor
      ,interface_claims_wol
      ,interface_claims_boq
    WHERE (icwor_ih_id = p_ih_id
    AND    icwor_status != 'P')
    OR    (icwol_ih_id = p_ih_id
    AND    icwol_status != 'P')
    OR    (icboq_ih_id = p_ih_id
    AND    icboq_status != 'P');

/*    select count(0)
    into   l_count_errors2
    from   dual
    where (:b1.ih_id = p_ih_id
    and    :b1.ih_status != 'P'
    and    :b1.ih_error is not null)
    or    (:b3.ic_ih_id = p_ih_id
    and    :b3.ic_status != 'P'
    and    :b3.ic_error is not null)
    or    (:b4.icwor_ih_id = p_ih_id
    and    :b4.icwor_status != 'P'
    and    :b4.icwor_error is not null)
    or    (:b5.icwol_ih_id = p_ih_id
    and    :b5.icwol_status != 'P'
    and    :b5.icwol_error is not null)
    or    (:b6.icboq_ih_id = p_ih_id
    and    :b6.icboq_status != 'P'
    and    :b6.icboq_error is not null);
*/
    l_count_errors := l_count_errors + l_count_errors2;

    IF l_count_errors > 0 THEN

      p_details_ok := 'N';

    ELSE

      SELECT COUNT(0)
      INTO   l_count_records
      FROM   interface_claims_wor
      WHERE  icwor_ih_id = p_ih_id;

      IF l_count_records = 0 THEN
        p_details_ok := 'N';
      ELSE
        p_details_ok := 'Y';
      END IF;
    END IF;

  ELSE

    SELECT COUNT(0)
    INTO   l_count_errors
    FROM   interface_completions
    WHERE  ic_ih_id = p_ih_id
    AND    ic_status != 'P';

    SELECT COUNT(0)
    INTO   l_count_errors2
    FROM   interface_headers
    WHERE  ih_id = p_ih_id
    AND    ih_status != 'P';

    SELECT COUNT(0)
    INTO   l_count_errors3
    FROM   interface_erroneous_records
    WHERE  ier_ih_id = p_ih_id
    AND    ier_error IS NOT NULL;

    l_count_errors := l_count_errors + l_count_errors2 + l_count_errors3;

    IF l_count_errors > 0 THEN

      p_details_ok := 'N';

    ELSE

      SELECT COUNT(0)
      INTO   l_count_records
      FROM   interface_completions
      WHERE  ic_ih_id = p_ih_id;

      IF l_count_records = 0 THEN
        p_details_ok := 'Y';--SM 17022009 705548 Changed from 'N' as it no error records then details are ok
      ELSE
        p_details_ok := 'N';
      END IF;
    END IF;
  END IF;

END check_details_ok;
---------------------------------------------------------------------
-- Processes a Completion file into oracle interface tables and
-- validates the contents.
--
PROCEDURE email_errors (p_ih_id IN interface_headers.ih_id%TYPE
                       ,p_file_type IN interface_headers.ih_file_type%TYPE
                       ) IS

   l_details_ok varchar2(1);
   l_from_user_id number := To_Number(Sys_Context('NM3CORE','USER_ID'));
   l_tab_to nm3mail.tab_recipient;
   l_tab_cc nm3mail.tab_recipient;
   l_tab_bcc nm3mail.tab_recipient;
   l_msg nm3type.tab_varchar32767;
   l_subject varchar2(100);

   CURSOR c1 (l_ih_id interface_headers.ih_id%TYPE) IS
   SELECT ih_seq_no, ih_created_date, ih_file_type, ih_contractor_id
   FROM   interface_headers
   WHERE  ih_id = l_ih_id;

   CURSOR c2 ( p_nmg_name nm_mail_groups.nmg_name%TYPE ) IS
   SELECT nmg_id
   FROM nm_mail_groups
   WHERE UPPER(nmg_name) = p_nmg_name;

   CURSOR c3 ( p_nmu_name nm_mail_users.nmu_name%TYPE ) IS
   SELECT nmu_id
   FROM nm_mail_users
   WHERE UPPER(nmu_name) = p_nmu_name;

   l_seq_no interface_headers.ih_seq_no%TYPE;
   l_created_date interface_headers.ih_created_date%TYPE;
   l_file_type interface_headers.ih_file_type%TYPE;
   l_contractor_id interface_headers.ih_contractor_id%TYPE;
   b_invalid_email boolean := TRUE;

   l_counter number := 0;

   e_invalid_email EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_invalid_email, -20001);

BEGIN
  check_details_ok(p_ih_id, p_file_type, l_details_ok);
  IF l_details_ok = 'Y'
    THEN
      NULL;
  ELSE
    OPEN c1(p_ih_id);
    FETCH c1 INTO l_seq_no, l_created_date, l_file_type, l_contractor_id;
    CLOSE c1;

    l_subject := 'Interface file in error. ';
    l_msg(1) := l_subject||CHR(10);
    l_msg(2) := '<HTML>';
    l_msg(3) := '<BODY>';
    l_msg(4) := '<BR>';
    l_msg(5) := '<B>Interface file in error.</B><BR>';
    l_msg(6) := '<BR>';
    l_msg(7) := 'Please check the Invoice Verification form for the following file: <BR>';
    l_msg(8) := '<BR>';
    l_msg(9) := l_file_type||l_seq_no||'.'||l_contractor_id;
    l_msg(10) := ' (created on '||l_created_date||'). ';
    l_msg(11) := '<BR>';
    l_msg(12) := '<BR>';
    l_msg(13) := 'This file has not been fully processed.';
    l_msg(14) := '<BR><BR><BR><BR>';
    l_msg(15) := 'Exor Leading the way in Infrastructure Asset Management Solutions';
    l_msg(16) := '<BR>';
    l_msg(17) := '<a href="http://www.exor.co.uk/"><exor_ref></a><BR>';
    l_msg(18) := '<BR>';
    l_msg(19) := 'phone : +(44) 1925 839001';
    l_msg(20) := '<BR>';
    l_msg(21) := 'fax : +(44) 1925 839010';
    l_msg(22) := '<BR><BR>';
    l_msg(23) := '</BODY>';
    l_msg(24) := '</HTML>';

    FOR c2rec IN c2( hig.get_sysopt('INTMAIL') ) LOOP
      l_counter := l_counter + 1;
      l_tab_to(1).rcpt_id := c2rec.nmg_id;
      l_tab_to(1).rcpt_type := nm3mail.c_group;
    END LOOP;

    IF l_counter < 1 THEN
      OPEN c3( hig.get_sysopt('INTMAIL') );
      FETCH c3 INTO l_tab_to(1).rcpt_id;
      IF c3%NOTFOUND THEN
        b_invalid_email := FALSE;
      END IF;
      CLOSE c3;
      l_tab_to(1).rcpt_type := nm3mail.c_user;
    END IF;

    IF b_invalid_email THEN
      nm3mail.write_mail_complete (p_from_user        => l_from_user_id
                                  ,p_subject          => l_subject
                                  ,p_tab_to           => l_tab_to
                                  ,p_tab_cc           => l_tab_cc
                                  ,p_tab_bcc          => l_tab_bcc
                                  ,p_tab_message_text => l_msg
                                  );
      COMMIT;
      nm3mail.send_stored_mail;
    END IF;
  END IF;
EXCEPTION
  WHEN e_invalid_email THEN
    RAISE_APPLICATION_ERROR(-20001,'Email address is invalid. Must be in either nm_mail_users or nm_mail_groups');
END email_errors;
---------------------------------------------------------------------
-- Completes work order lines
--
PROCEDURE close_lines( p_ih_id IN  interface_headers.ih_id%TYPE
             ) IS

  CURSOR c1 ( l_ih_id interface_completions.ic_ih_id%TYPE ) IS
    SELECT wol_def_defect_id
          ,wol_id
          ,wol_est_cost
          ,wol_act_cost
          ,wol_date_repaired
          ,wol_works_order_no
    FROM   work_order_lines
    WHERE  wol_date_repaired IS NOT NULL
  AND   wol_id IN (
                   SELECT ic_wol_id
                   FROM   interface_completions_all
                   WHERE  ic_status IS NULL
                   AND    ic_ih_id = l_ih_id
                  )
  AND   wol_status_code IN (
                            SELECT hsc_status_code
                            FROM   hig_status_codes
                            WHERE  hsc_allow_feature7 = 'Y'
                            AND    hsc_domain_code = 'WORK_ORDER_LINES'
                            AND    g_today BETWEEN NVL(hsc_start_date, g_today) AND NVL(hsc_end_date, g_today))
    AND    wol_date_complete IS NULL;

  CURSOR c1count ( l_ih_id interface_completions.ic_ih_id%TYPE ) IS
    SELECT COUNT(1)
    FROM   work_order_lines
    WHERE  wol_date_repaired IS NOT NULL
  AND   wol_id IN (
                   SELECT ic_wol_id
                   FROM   interface_completions_all
                   WHERE  ic_status IS NULL
                   AND    ic_ih_id = l_ih_id
                  )
  AND   wol_status_code IN (
                            SELECT hsc_status_code
                            FROM   hig_status_codes
                            WHERE  hsc_allow_feature7 = 'Y'
                            AND    hsc_domain_code = 'WORK_ORDER_LINES'
                            AND    g_today BETWEEN NVL(hsc_start_date, g_today) AND NVL(hsc_end_date, g_today));

  CURSOR c2 ( l_wol_id work_order_lines.wol_id%TYPE
            ) IS
  SELECT wol_id, wol_works_order_no
  FROM work_order_lines
  WHERE wol_date_complete IS NULL
  AND wol_works_order_no IN ( SELECT wol_works_order_no
                              FROM   work_order_lines
                              WHERE  wol_id = l_wol_id
                            );

  CURSOR c2count ( l_wol_id work_order_lines.wol_id%TYPE
            ) IS
  SELECT COUNT(1)
  FROM work_order_lines
  WHERE wol_date_complete IS NULL
  AND wol_works_order_no IN ( SELECT wol_works_order_no
                              FROM   work_order_lines
                              WHERE  wol_id = l_wol_id
                            );

  CURSOR c3 ( l_works_order_no work_order_lines.wol_works_order_no%TYPE
            ) IS
  SELECT SUM(wol_act_cost)
  FROM   work_order_lines
  WHERE  wol_works_order_no = l_works_order_no;

  CURSOR c4 ( l_works_order_no work_order_lines.wol_works_order_no%TYPE
            ) IS
  SELECT wol_act_cost, wol_est_cost
  FROM   work_order_lines
  WHERE  wol_works_order_no = l_works_order_no;

  CURSOR c5 ( l_wol_def_defect_id work_order_lines.wol_def_defect_id%TYPE
            ) IS
  SELECT COUNT(1)
  FROM repairs
  WHERE  (rep_def_defect_id,rep_action_cat) IN
            (SELECT wol_def_defect_id,wol_rep_action_cat
             FROM   work_order_lines
             WHERE  wol_def_defect_id  = l_wol_def_defect_id)
  AND    rep_date_completed IS NULL;

  l_def_id              work_order_lines.wol_def_defect_id%TYPE;
  l_wol_id              work_order_lines.wol_id%TYPE;
  l_wol_est_cost        work_order_lines.wol_est_cost%TYPE;
  l_wol_act_cost        work_order_lines.wol_act_cost%TYPE;
  l_wol_works_order_no  work_order_lines.wol_works_order_no%TYPE;
  l_date_repaired       work_order_lines.wol_date_repaired%TYPE;
  l_flag                varchar2(7);
  l_c2rec_count         number := 0;
  l_c1rec_count         number := 0;
  l_c2count             number := 0;
  l_c5count             number := 0;
  l_c3act               work_order_lines.wol_act_cost%TYPE;

  l_counter number := 0;
BEGIN
  FOR c1rec IN c1( p_ih_id ) LOOP
  l_c1rec_count := l_c1rec_count + 1;
    IF c1rec.wol_id IS NOT NULL THEN

      --
      --Update the Works Order Line (set the status code, the date completed, the cost and the invoice status)
      --
      UPDATE work_order_lines
      SET    wol_status_code = g_wol_comp_status
           , wol_date_complete = c1rec.wol_date_repaired
       , (wol_act_cost, wol_est_labour) = (SELECT SUM(boq_act_cost)
                            , SUM(boq_act_labour)
                           FROM   boq_items
                               WHERE  boq_wol_id = wol_id)
       , wol_invoice_status = 'O' -- db trigger with create an invoice Maiwo.wol_invoice_status(wol_id)
      WHERE  wol_id = c1rec.wol_id;
      --
      --Update the repair
      --
      UPDATE repairs
      SET    rep_date_completed = c1rec.wol_date_repaired
            ,rep_completed_hrs  = TO_NUMBER(TO_CHAR(c1rec.wol_date_repaired,'HH24'))
            ,rep_completed_mins = TO_NUMBER(TO_CHAR(c1rec.wol_date_repaired,'MI'))
            ,rep_last_updated_date = SYSDATE
      WHERE  (rep_def_defect_id,rep_action_cat) IN
            (SELECT wol_def_defect_id,wol_rep_action_cat
             FROM   work_order_lines
             WHERE  wol_def_defect_id  = c1rec.wol_def_defect_id
             AND    wol_id = c1rec.wol_id)
        AND  rep_date_completed IS NULL;
      --
      --Update the defect
      --
      IF hig.get_sysopt('REPAIRS') IN ('1') THEN
        --
        -- If the REPAIRS product option is set to 1 then over write the defect compl date
        --
        UPDATE defects
        SET    def_date_compl = c1rec.wol_date_repaired
              ,def_last_updated_date = SYSDATE
              ,def_status_code = g_wol_comp_status
        WHERE  def_defect_id  = c1rec.wol_def_defect_id
/*        and    not exists (select 1
                           from   repairs
                           where  rep_def_defect_id = def_defect_id
                           and    rep_date_completed is null)*/;
      ELSE
        --
        -- If the REPAIRS product option is not set to 1 then don't over write the defect compl date
        --
        OPEN c5( c1rec.wol_def_defect_id );-- counts the number of repairs
        FETCH c5 INTO l_c5count;
        CLOSE c5;

        IF l_c5count > 1 THEN
          NULL;-- if there are more than 1 repair then don't complete the defect.
        ELSE
        -- if there is only one repair left
          UPDATE defects
          SET    def_date_compl = c1rec.wol_date_repaired
                ,def_last_updated_date = SYSDATE
                ,def_status_code = g_wol_comp_status
          WHERE  def_defect_id  = c1rec.wol_def_defect_id
          AND    NOT EXISTS (SELECT 1
                             FROM   repairs
                             WHERE  rep_def_defect_id = def_defect_id
                             AND    rep_date_completed IS NULL);
        END IF;
      END IF;
--
    UPDATE boq_items
    SET    boq_act_dim1     = NVL(boq_act_dim1, boq_est_dim1)
          ,boq_act_dim2     = NVL(boq_act_dim2, boq_est_dim2)
          ,boq_act_dim3     = NVL(boq_act_dim3, boq_est_dim3)
          ,boq_act_rate     = NVL(boq_act_rate, boq_est_rate)
          ,boq_act_quantity = NVL(boq_act_quantity, boq_est_quantity)
          ,boq_act_cost     = NVL(boq_act_cost, boq_est_cost)
          ,boq_act_labour   = NVL(boq_act_labour, boq_est_labour)
          ,boq_act_discount = NVL(boq_act_discount, boq_est_discount)
    WHERE  boq_wol_id = c1rec.wol_id;
--

END IF;

OPEN c2count( c1rec.wol_id );
FETCH c2count INTO l_c2count;
CLOSE c2count;
  IF l_c2count = 0 THEN
    OPEN c4 ( c1rec.wol_works_order_no );
    FETCH c4 INTO l_wol_act_cost, l_wol_est_cost;
    CLOSE c4;

    UPDATE work_order_lines
    SET wol_act_cost = NVL(wol_act_cost, wol_est_cost)
    WHERE c1rec.wol_works_order_no = wol_works_order_no;

    OPEN c3 ( c1rec.wol_works_order_no );
    FETCH c3 INTO l_c3act;
    CLOSE c3;

    UPDATE work_orders
    SET wor_act_cost = l_c3act
      , wor_date_closed = c1rec.wol_date_repaired
      , wor_act_balancing_sum = 0
    WHERE  wor_works_order_no = c1rec.wol_works_order_no;
  END IF;
END LOOP;--c1rec
END close_lines;
---------------------------------------------------------------------
-- Processes a Completion file into oracle interface tables and
-- validates the contents.
--

PROCEDURE completion_file_ph1( p_job_id IN number
                    ,p_contractor_id    IN varchar2
                    ,p_seq_no        IN number
                    ,p_filepath        IN varchar2
                    ,p_filename     IN varchar2
                    ,p_error        OUT varchar2 ) IS
BEGIN
  xnhcc_interfaces.g_job_id := p_job_id;
  higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,'Point 1');
  --
  xnhcc_interfaces.completion_file_ph1(p_contractor_id
                                 ,p_seq_no
                                 ,p_filepath
                                 ,p_filename
                                 ,p_error);
END;
--
PROCEDURE completion_file_ph1( p_contractor_id    IN varchar2
                    ,p_seq_no        IN number
                    ,p_filepath        IN varchar2
                    ,p_filename     IN varchar2
                    ,p_error        OUT varchar2 ) IS

  l_fhand         utl_file.file_type;
  l_seq_no         varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,
                                       p_contractor_id
                                      ,p_seq_no
                             ,'WC');
  l_filename     varchar2(12) := NVL(p_filename,'WC'||TO_CHAR(l_seq_no)||'.'||p_contractor_id);
  l_record         interface_erroneous_records.ier_record_text%TYPE;
  l_error         interface_erroneous_records.ier_error%TYPE;
  l_ih_id         interface_headers.ih_id%TYPE;
  l_file_not_found varchar2(250) := 'Error: Unable to open file. Path: '||NVL(p_filepath, g_filepath)||'  File: '||l_filename;
  l_invalid_filename varchar2(250) := 'Error: Filename invalid. Check the ZEROPAD product option. File: '||l_filename;
  invalid_file     EXCEPTION;
  invalid_filename EXCEPTION;
  l_details_ok     VARCHAR2(1);

  
l_count number := 0;
l_auto_load    Boolean := FALSE;
BEGIN

  BEGIN
    --
    if check_filename(l_filename) then
      l_fhand := UTL_FILE.FOPEN(NVL(p_filepath, g_filepath), l_filename, 'r');
      IF UTL_FILE.IS_OPEN(l_fhand) THEN
        LOOP
          UTL_FILE.GET_LINE(l_fhand, l_record);
          --
          l_error := NULL;
          --
          populate_wc_interface_tables(l_ih_id
                                      ,l_record
                                      ,l_error);
          IF l_ih_id IS NULL THEN    -- error in header record
            EXIT;                -- halt processing
          END IF;
          --
        END LOOP;
        --
      ELSE
        RAISE invalid_file;
      END IF;
    else
        raise invalid_filename;
    end if;
    EXCEPTION
      WHEN invalid_file OR utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
        p_error := l_file_not_found;
      WHEN invalid_filename THEN
        p_error := l_invalid_filename;
      WHEN no_data_found THEN  --end of file
        UTL_FILE.FCLOSE(l_fhand);
            IF hig.get_sysopt('XTRIFLDS') IN ('2-4-0')
              THEN
               l_auto_load := TRUE;
                auto_load_file(l_ih_id
                              ,l_record
                              ,l_error);

                -- emailing now covered by alerts clb 24062013 email_errors(l_ih_id,'WC');--email section for future use
   			    check_details_ok(l_ih_id, 'WC', l_details_ok);
                IF l_details_ok != 'Y'
				THEN
				   p_error := 'Errors encountered';
				END IF;
                close_lines(l_ih_id);--complete work order lines
            END IF;

      WHEN others THEN
        p_error := SQLERRM;

  END;
  IF NOT l_auto_load 
  THEN
      nm3ctx.set_context('CIM_IH_ID',l_ih_id); 
      validate_completion_data(l_ih_id);
  END IF ;
  COMMIT;

END;


---------------------------------------------------------------------
-- Processes valid Completion data into Highways Maintenance Manager
-- tables.
--

PROCEDURE completion_file_ph2(p_ih_id IN interface_headers.ih_id%TYPE) IS

  l_count number;
  l_wol_id work_order_lines.wol_id%TYPE;
  l_ih_id interface_completions.ic_ih_id%TYPE;
  l_number_of_repairs number;

  cursor c_interface_completions_all ( pi_ih_id IN interface_headers.ih_id%TYPE
              ) is 
  select * 
      from interface_completions_all,repairs
      where ic_ih_id = pi_ih_id
      and ic_defect_id = rep_def_defect_id;

  cursor c_defects ( pi_def_defect_id repairs.rep_def_defect_id%TYPE ) is
  select * 
     from defects
     where def_defect_id = pi_def_defect_id
     	and def_date_compl is null;
      
    cursor c_repairs ( pi_def_defect_id repairs.rep_def_defect_id%TYPE 
                     , pi_rep_action_cat repairs.rep_action_cat%TYPE
                     ) is
     select * 
     from repairs
     where rep_def_defect_id = pi_def_defect_id
       and rep_action_cat = pi_rep_action_cat;      
          
  r_repairs repairs%rowtype;
  r_defects defects%rowtype;
  
function check_defect_repairs ( pi_def_defect_id repairs.rep_def_defect_id%TYPE
                              ) return number is
  l_count number;
begin
  select count(1)
  into l_count
  from repairs
  where rep_def_defect_id = pi_def_defect_id
  and rep_date_completed is null;
  
  return l_count;

end check_defect_repairs;

function complete_repair ( pi_def_defect_id repairs.rep_def_defect_id%TYPE
                         , pi_rep_action_cat repairs.rep_action_cat%TYPE
                         , pi_complete_date repairs.rep_date_completed%TYPE
                         ) return boolean is

begin
  update repairs
  set rep_date_completed    = pi_complete_date
     ,rep_last_updated_date = Sysdate
     ,rep_completed_hrs     = TO_NUMBER(TO_CHAR(pi_complete_date,'HH24'))
     ,rep_completed_mins    = TO_NUMBER(TO_CHAR(pi_complete_date,'MI'))
  where rep_def_defect_id = pi_def_defect_id
  and rep_action_cat = pi_rep_action_cat;
  return TRUE;
end complete_repair;

function complete_defect ( pi_def_defect_id defects.def_defect_id%TYPE
                         , pi_complete_date defects.def_date_compl%TYPE
                         ) return boolean is

begin
  update defects
  set def_status_code=(SELECT MAX(hsc_status_code)
                       FROM   hig_status_codes
                       WHERE  hsc_allow_feature4 = 'Y'
                       AND    hsc_domain_code = 'DEFECTS'
                       AND    g_today BETWEEN NVL(hsc_start_date, g_today)
                       AND NVL(hsc_end_date, g_today))
    , def_date_compl = pi_complete_date
    , def_last_updated_date = SYSDATE
  where def_defect_id = pi_def_defect_id;
  return TRUE;
end complete_defect;

BEGIN
/******************************************************************************************************************
** SM 06012009 717676
** Checks the repairs and defects and if the WCCOMPLETE product option is set then completes them with teh loading 
** of the WC file.
** 1) If defect has one repair then complete both repair and defect.
** 2) If defect has two repairs and wol has P repair then complete P repair only.
** 3) If defect has two repairs and wol has T repair then complete T repair only.
******************************************************************************************************************/
--check product option WCCOMPLETE
IF hig.get_user_or_sys_opt('WCCOMPLETE')='Y' THEN -- SM 06012009 717676
  for c_interface_completions_allrec in c_interface_completions_all(p_ih_id) loop
-- if set then check number of repairs
    l_number_of_repairs := check_defect_repairs(c_interface_completions_allrec.ic_defect_id);

    open c_repairs(c_interface_completions_allrec.ic_defect_id, c_interface_completions_allrec.rep_action_cat);
    fetch c_repairs into r_repairs;
    close c_repairs;
    if complete_repair ( r_repairs.rep_def_defect_id
                       , r_repairs.rep_action_cat
                       , c_interface_completions_allrec.ic_date_completed
                       ) then
      if l_number_of_repairs = 1 then  
        open c_defects(c_interface_completions_allrec.ic_defect_id);
        fetch c_defects into r_defects;
        close c_defects;
        if complete_defect ( r_defects.def_defect_id 
                           , c_interface_completions_allrec.ic_date_completed
                           ) then
              --success
              null;
        end if;
      end if;
    end if;        
-- if multiple then complete repair only        
  end loop;
END IF;
  -- Amend the status code of the WOL to indicate that work is completed
  -- on site. Only do this if the repaired date is null and the WOL has
  -- been assigned for work (ie INSTRUCTED).
  -----------------------------------------------------------------------

FOR ic IN (SELECT ic.rowid ic_rowid,ic.*
           FROM   interface_completions_all ic
           WHERE  ic_ih_id = p_ih_id
           AND    ic_status = 'P'
          )  
LOOP

    UPDATE interface_completions
    SET    ic_status = NULL
    WHERE  ic_status = 'P'
    AND    rowid = ic.ic_rowid ;
END LOOP;
 

    -- Add error message to any of the Defects that were not processed.
    -------------------------------------------------------------
    UPDATE interface_completions
    SET    ic_error = SUBSTR(ic_error||'Defect Date already set. ', 1, 254)
          ,ic_status = 'R'
    WHERE  ic_status = 'P'
    AND    ic_ih_id = p_ih_id;

    -- Archive the header record if no child records exist.
    -------------------------------------------------------
   UPDATE interface_headers
   SET    ih_status = NULL
   WHERE  ih_id = p_ih_id
   AND NOT EXISTS (
                  SELECT 1
                  FROM   interface_completions
                  WHERE  ic_ih_id = p_ih_id
                  UNION ALL
                  SELECT 1
                  FROM   interface_erroneous_records
                  WHERE  ier_ih_id = p_ih_id
                 );

  COMMIT;
Exception
   WHEN no_data_found
   THEN
       Null;
END;
---------------------------------------------------------------------
-- Validates all data processed in a Claim file. Called from the
-- claim_file_ph1 procedure and from the claims form (when validating
-- a claim record).
--
PROCEDURE validate_claim_data(p_ih_id IN interface_headers.ih_id%TYPE) IS
  l_cps_wol_id interface_claims_wol.icwol_wol_id%TYPE;
    CURSOR c1 IS
    SELECT icwol_error
    FROM interface_claims_wol
    WHERE icwol_ih_id = p_ih_id;
  l_error interface_claims_wol.icwol_error%TYPE;
BEGIN
  OPEN c1;
  FETCH c1 INTO l_error;
  IF c1%NOTFOUND THEN
    l_error := NULL;
    CLOSE c1;
  ELSE
    IF INSTR(l_error, 'Tolerance exceeded.') = 0 THEN
      l_error := SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),(INSTR(l_error,')')-(INSTR(l_error, 'Tolerance exceeded. '))));
    ELSE
      l_error := SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),(INSTR(l_error,')')-(INSTR(l_error, 'Tolerance exceeded. '))-1));
    END IF;
    CLOSE c1;
  END IF;
  l_cps_wol_id := check_paid_status(p_ih_id);
  IF l_cps_wol_id IS NOT NULL THEN
    validate_post_paid(p_ih_id,l_cps_wol_id);
    validate_wo_item(p_ih_id,'WOL',25);
  ELSE
  UPDATE interface_headers
  SET    ih_error = NULL
        ,ih_status = DECODE(ih_status, 'R', 'P', ih_status)
  WHERE  ih_id = p_ih_id;
  UPDATE interface_claims_wor
  SET    icwor_error = NULL
        ,icwor_status = DECODE(icwor_status, 'R', 'P', icwor_status)
  WHERE  icwor_ih_id = p_ih_id;
    UPDATE interface_claims_wol
  SET    icwol_error = DECODE(INSTR(NVL(icwol_error,'@'), l_error), 0, NULL, l_error)
        ,icwol_status = DECODE(icwol_status, 'R', 'P', icwol_status)
  WHERE  icwol_ih_id = p_ih_id;
/*
  Update interface_claims_wol
  Set    icwol_error = Decode(Instr(Nvl(icwol_error,'@'),l_error ), 0, Null, l_error)
        ,icwol_status = Decode(icwol_status, 'R', 'P', icwol_status)
  Where  icwol_ih_id = p_ih_id;
*/
  UPDATE interface_claims_boq
  SET    icboq_error = NULL
        ,icboq_status = DECODE(icboq_status, 'R', 'P', icboq_status)
  WHERE  icboq_ih_id = p_ih_id;
  validate_contractor(p_ih_id);
  validate_claim_check_rec(p_ih_id);
  validate_claim_type(p_ih_id);
  validate_claim_unique(p_ih_id);
  validate_claim_date(p_ih_id);
  validate_claim_wor_no(p_ih_id);
  validate_claim_wor_con(p_ih_id);
  validate_originator(p_ih_id);
  validate_claim_value(p_ih_id);
  validate_commence_date(p_ih_id);
  validate_completed_date(p_ih_id);
  validate_claim_wol_id(p_ih_id);
  validate_claim_defect_id(p_ih_id);
  validate_claim_schd_id(p_ih_id);
  validate_claim_def_wol(p_ih_id);
  validate_claim_wor_wol(p_ih_id);
  validate_wol_claim_value(p_ih_id);
  validate_claim_date_complete(p_ih_id);
  validate_claim_item_code(p_ih_id);
  validate_claim_quantity(p_ih_id);
  validate_claim_cost(p_ih_id);
IF hig.get_sysopt('XTRIFLDS') IN ('2-1-3', '2-4-0') THEN
  validate_percent_band_comp(p_ih_id);
  validate_claim_cost_percent(p_ih_id);
  validate_claim_rogue(p_ih_id);
  validate_boq_id(p_ih_id);
  validate_parent_boq_id(p_ih_id);
  validate_claim_rate(p_ih_id);
ELSE
  validate_claim_rate(p_ih_id);
END IF;
  -- D-125250 
  if g_multifinal = 'N'
  then
     validate_claim_not_complete(p_ih_id);
  end if;
  validate_interim_no(p_ih_id);
  validate_claim_complete(p_ih_id);
  validate_completed_dates(p_ih_id);
  validate_claim_boqs(p_ih_id);
END IF;
END;
---------------------------------------------------------------------
-- Populates interface tables with data read in from a Claim file.
-- Called from the claim_file_ph1 procedure and from the claims
-- form via the reinsert_wi_record procedure (when validating an
-- erroneous claim record).
--

PROCEDURE populate_wi_interface_tables(p_ih_id       IN OUT interface_headers.ih_id%TYPE
                          ,p_wor_no      IN OUT interface_claims_wor.icwor_works_order_no%TYPE
                          ,p_wol_id         IN OUT interface_claims_wol.icwol_wol_id%TYPE
                          ,p_claim_date  IN OUT interface_claims_wor.icwor_claim_date%TYPE
                          ,p_claim_ref   IN OUT interface_claims_wor.icwor_con_claim_ref%TYPE
                          ,p_con_id         IN OUT interface_claims_wor.icwor_con_id%TYPE
                          ,p_record      IN     varchar2
                          ,p_error         IN OUT varchar2) IS

  l_record_type    interface_erroneous_records.ier_record_type%TYPE := int_utility.get_field(p_record, 1);
  l_con_code    contracts.con_code%TYPE;
  l_con_id      interface_claims_wor.icwor_con_id%TYPE;
  invalid_contract EXCEPTION;
  mandatory_is_null EXCEPTION;
  PRAGMA EXCEPTION_INIT(mandatory_is_null, -01400);


  CURSOR c1 IS
    SELECT con_id
    FROM   contracts
    WHERE  con_code = l_con_code;


  CURSOR c2 (l_ih_id interface_claims_wor.icwor_ih_id%TYPE) IS
    SELECT icwor_con_id
    FROM   interface_claims_wor
    WHERE icwor_ih_id = l_ih_id;

  CURSOR c3 (p_sta_item_code standard_items.sta_item_code%TYPE) IS
    SELECT 1
    FROM standard_items
    WHERE sta_unit = hig.get_sysopt('PERC_ITEM')
    AND sta_item_code = p_sta_item_code;

  CURSOR c4 IS
    SELECT neg_boq_id_seq.NEXTVAL
    FROM dual;

  l_boq_id number;
  l_parent_boq_id number;
  l_temp number;
  l_p_record4 date;
  l_p_record5 date;
  l_p_record8 date;
  l_p_record9 date;
  l_p_record10 date;
  l_p_record12 date;
  l_p_record13 date;

BEGIN

  IF l_record_type = '15' THEN -- BOQ record

DBMS_OUTPUT.PUT_LINE('15');
    --
/*    IF interfaces.g_job_id IS NOT NULL THEN
      higgrirp.write_gri_spool(interfaces.g_job_id,'Processing type 15');
    END IF;
*/    --
    IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3', '2-4-0') THEN
    INSERT INTO interface_claims_boq (
                 icboq_ih_id
                ,icboq_con_claim_ref
                ,icboq_con_id
                ,icboq_wol_id
                ,icboq_sta_item_code
                ,icboq_dim1
                ,icboq_dim2
                ,icboq_dim3
                ,icboq_quantity
                ,icboq_rate
                ,icboq_cost
                ,icboq_percent_adjust
                ,icboq_percent_adjust_code
                ,icboq_status
                ,icboq_error)
    VALUES (
                 p_ih_id
                ,p_claim_ref
                ,p_con_id
                ,p_wol_id
                ,int_utility.get_field(p_record, 2)
                ,int_utility.get_field(p_record, 3)
                ,int_utility.get_field(p_record, 4)
                ,int_utility.get_field(p_record, 5)
                ,int_utility.get_field(p_record, 6)
                ,int_utility.get_field(p_record, 7)
                ,int_utility.get_field(p_record, 8)
                ,int_utility.get_field(p_record, 9)
                ,int_utility.get_field(p_record, 10)
                ,'P'
                ,'');
   ELSE
   OPEN c3(int_utility.get_field(p_record, 2));
   FETCH c3 INTO l_temp;
   IF c3%NOTFOUND THEN
     IF int_utility.get_field(p_record, 11) IS NULL THEN
       CLOSE c3;
       OPEN c4;
       FETCH c4 INTO g_boq_id;
       CLOSE c4;
     END IF;
   ELSE
     IF int_utility.get_field(p_record, 12) IS NULL THEN
       CLOSE c3;
       l_parent_boq_id := g_boq_id;
       OPEN c4;
       FETCH c4 INTO g_boq_id;
       CLOSE c4;
     END IF;
   END IF;

   INSERT INTO interface_claims_boq (
                 icboq_ih_id
                ,icboq_con_claim_ref
                ,icboq_con_id
                ,icboq_wol_id
                ,icboq_sta_item_code
                ,icboq_dim1
                ,icboq_dim2
                ,icboq_dim3
                ,icboq_quantity
                ,icboq_rate
                ,icboq_cost
                ,icboq_percent_adjust
                ,icboq_percent_adjust_code
                ,icboq_status
                ,icboq_error
                ,icboq_boq_id
                ,icboq_parent_boq_id
                ,icboq_percent_band_comp
                ,icboq_rogue_item
                ,icboq_rogue_item_desc)
    VALUES (
                 p_ih_id
                ,p_claim_ref
                ,p_con_id
                ,p_wol_id
                ,int_utility.get_field(p_record, 2)
                ,int_utility.get_field(p_record, 3)
                ,int_utility.get_field(p_record, 4)
                ,int_utility.get_field(p_record, 5)
                ,int_utility.get_field(p_record, 6)
                ,int_utility.get_field(p_record, 7)
                ,int_utility.get_field(p_record, 8)
                ,int_utility.get_field(p_record, 9)
                ,int_utility.get_field(p_record, 10)
                ,'P'
                ,''
                ,int_utility.get_field(p_record, 11)--NVL(Int_Utility.get_field(p_record, 11),g_boq_id)
                ,int_utility.get_field(p_record, 12)--NVL(Int_Utility.get_field(p_record, 12),l_parent_boq_id)
                ,int_utility.get_field(p_record, 13)
                ,int_utility.get_field(p_record, 14)
                ,int_utility.get_field(REPLACE(SUBSTR(p_record,INSTR(p_record,',',1,14)+1,LENGTH(p_record)-INSTR(p_record,',',1,14)),',','~'), 15));

   END IF;

  ELSIF l_record_type = '10' THEN -- WOL record

DBMS_OUTPUT.PUT_LINE('10');

    --
/*    IF interfaces.g_job_id IS NOT NULL THEN
      higgrirp.write_gri_spool(interfaces.g_job_id,'Processing type 10');
    END IF;
*/    --
    l_p_record8 := check_date_format(int_utility.get_field(p_record, 8));
    p_wol_id := int_utility.get_field(p_record, 2);

    INSERT INTO interface_claims_wol (
                 icwol_ih_id
                ,icwol_con_claim_ref
                ,icwol_con_id
                ,icwol_wol_id
                ,icwol_defect_id
                ,icwol_schd_id
                ,icwol_claim_value
                ,icwol_percent_adjust
                ,icwol_percent_adjust_code
                ,icwol_date_complete
                ,icwol_status
                ,icwol_error)
    VALUES (
                 p_ih_id
                ,p_claim_ref
                ,p_con_id
                ,p_wol_id
                ,int_utility.get_field(p_record, 3) --l_defect_id
                ,int_utility.get_field(p_record, 4) --l_schd_id
                ,int_utility.get_field(p_record, 5) --l_claim_value
                ,int_utility.get_field(p_record, 6)
                ,int_utility.get_field(p_record, 7)
                ,DECODE( GREATEST ( LENGTH(int_utility.get_field(p_record, 8)) , /*LENGTH(g_date_format)*/ 12), /*LENGTH(g_date_format)*/ 12, TO_DATE(TO_CHAR(l_p_record8,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record8,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
                ,'P'
                ,'');

  ELSIF l_record_type = '05' THEN -- claim record

DBMS_OUTPUT.PUT_LINE('05');
    --
/*    IF interfaces.g_job_id IS NOT NULL THEN
      higgrirp.write_gri_spool(interfaces.g_job_id,'Processing type 05');
    END IF;
*/    --
    l_p_record5 := check_date_format(int_utility.get_field(p_record, 5));
    l_p_record9 := check_date_format(int_utility.get_field(p_record, 9));
    l_p_record10 := check_date_format(int_utility.get_field(p_record, 10));
    l_p_record12 := check_date_format(int_utility.get_field(p_record, 12));
    l_p_record13 := check_date_format(int_utility.get_field(p_record, 13));
    p_wor_no := UPPER(int_utility.get_field(p_record, 6));
    IF LENGTH(int_utility.get_field(p_record, 5)) > /*LENGTH(G_DATE_FORMAT)*/ 12
      THEN
        p_claim_date := TO_DATE(TO_CHAR(l_p_record5,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format);
    ELSE
      p_claim_date := TO_DATE(TO_CHAR(l_p_record5,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format);
    END IF;
    p_claim_ref := UPPER(int_utility.get_field(p_record, 4));
    l_con_code := UPPER(int_utility.get_field(p_record, 7));

/********************************************************************************************************
** SM - 11122006 - 706345
** Commented out the following section as it seemed to be getting the con_id from the first record in
** interface_claims_wor with a matching ih_id which isn't the same for all the records.
********************************************************************************************************/
/*    Open c2(p_ih_id);
    FETCH c2 INTO l_con_id;
    IF c2%FOUND THEN
      CLOSE c2;
      IF l_con_id = -1 THEN
        OPEN c1;
        FETCH c1 INTO p_con_id;
        IF c1%NOTFOUND THEN
          p_con_id := -1;
          RAISE invalid_contract;
        END IF;
        UPDATE interface_claims_wor SET icwor_con_id = p_con_id WHERE icwor_ih_id = p_ih_id;
        UPDATE interface_claims_wol SET icwol_con_id = p_con_id WHERE icwol_ih_id = p_ih_id;
        UPDATE interface_claims_boq SET icboq_con_id = p_con_id WHERE icboq_ih_id = p_ih_id;
      END IF;
      INSERT INTO interface_claims_wor (
                    icwor_ih_id
                 ,icwor_claim_type
                 ,icwor_con_claim_ref
                 ,icwor_con_id
                 ,icwor_claim_date
                 ,icwor_works_order_no
                 ,icwor_interim_no
                 ,icwor_originator
                 ,icwor_date_confirmed
                 ,icwor_est_complete
                 ,icwor_claim_value
                 ,icwor_commence_by
                 ,icwor_date_closed
                 ,icwor_status
                 ,icwor_error)
      VALUES (
                  p_ih_id
                 ,UPPER(int_utility.get_field(p_record, 2))
                 ,p_claim_ref
                 ,p_con_id
                 ,p_claim_date
                 ,DECODE(hig.get_sysopt('CPAFORMAT'),'1',
                                  SUBSTR(UPPER(p_wor_no),1,3)||'/'||
                                  SUBSTR(UPPER(p_wor_no),4,(LENGTH(SUBSTR(UPPER(p_wor_no),1,INSTR(UPPER(p_wor_no),'/',1)-1))-3)),
                                  UPPER(p_wor_no))
                 ,int_utility.get_field(p_record, 3)
                 ,int_utility.get_field(p_record, 8)*/
--                         ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 9)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record9,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record9,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
--                 ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 10)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record10,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record10,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
--                 ,int_utility.get_field(p_record, 11)
--                 ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 12)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record12,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record12,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
--                 ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 13)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record13,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record13,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
--                 ,'P'
--                 ,'');
--        IF p_con_id = -1 THEN
--          RAISE invalid_contract;
--        END IF;
--    ELSE
--      CLOSE c2;
      OPEN c1;
      FETCH c1 INTO p_con_id;
      IF c1%NOTFOUND THEN
        p_con_id := -1;
       END IF;
      CLOSE c1;

    INSERT INTO interface_claims_wor (
                 icwor_ih_id
                ,icwor_claim_type
                ,icwor_con_claim_ref
                ,icwor_con_id
                ,icwor_claim_date
                ,icwor_works_order_no
                ,icwor_interim_no
                ,icwor_originator
                ,icwor_date_confirmed
                ,icwor_est_complete
                ,icwor_claim_value
                ,icwor_commence_by
                ,icwor_date_closed
                ,icwor_status
                ,icwor_error)
    VALUES (
                 p_ih_id
                ,UPPER(int_utility.get_field(p_record, 2))
                ,p_claim_ref
                ,p_con_id
                ,p_claim_date
                ,DECODE(hig.get_sysopt('CPAFORMAT'),'1',
                                 SUBSTR(UPPER(p_wor_no),1,3)||'/'||
                                 SUBSTR(UPPER(p_wor_no),4,(LENGTH(SUBSTR(UPPER(p_wor_no),1,INSTR(UPPER(p_wor_no),'/',1)-1))-3)),
                                 UPPER(p_wor_no))
                ,int_utility.get_field(p_record, 3)
                ,int_utility.get_field(p_record, 8)
                ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 9)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record9,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record9,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
                ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 10)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record10,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record10,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
                ,int_utility.get_field(p_record, 11)
                ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 12)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record12,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record12,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
                ,DECODE(GREATEST(LENGTH(int_utility.get_field(p_record, 13)),/*LENGTH(g_date_format)*/ 12),/*LENGTH(g_date_format)*/ 12,TO_DATE(TO_CHAR(l_p_record13,'DDMMYYYY')||' 00:00:01', g_date_format||' '||g_time_format), TO_DATE(TO_CHAR(l_p_record13,'DDMMYYYY HH24:MI:SS'), g_date_format||' '||g_time_format))
                ,'P'
                ,'');
      IF p_con_id = -1 THEN
        RAISE invalid_contract;
      END IF;
--    END IF;
  ELSIF l_record_type = '00' THEN -- header record

DBMS_OUTPUT.PUT_LINE('00');
    --
/*    IF interfaces.g_job_id IS NOT NULL THEN
      higgrirp.write_gri_spool(interfaces.g_job_id,'Processing type 00');
    END IF;
*/    --

    SELECT ih_id_seq.NEXTVAL
    INTO   p_ih_id
    FROM   dual;
    l_p_record4 := check_date_format(int_utility.get_field(p_record, 4));
    INSERT INTO interface_headers (
             ih_id
            ,ih_file_type
            ,ih_contractor_id
            ,ih_seq_no
            ,ih_created_date
            ,ih_status
            ,ih_error)
    VALUES (
             p_ih_id
            ,'WI'
            ,UPPER(int_utility.get_field(p_record, 2))
            ,int_utility.get_field(p_record, 3)
            ,TO_DATE(TO_CHAR(l_p_record4, g_date_format)||
             TO_CHAR(TO_DATE(int_utility.get_field(p_record, 5), 'HH24:MI:SS')
            ,'HH24:MI:SS'),g_date_format||'HH24:MI:SS')
            ,'P'
            ,NULL);

  ELSIF p_ih_id IS NOT NULL AND l_record_type = '20' THEN -- Check record

DBMS_OUTPUT.PUT_LINE('20');
    --
/*    IF interfaces.g_job_id IS NOT NULL THEN
      higgrirp.write_gri_spool(interfaces.g_job_id,'Processing type 20');
    END IF;
*/    --
    UPDATE interface_headers
    SET    ih_no_of_recs = int_utility.get_field(p_record, 2)
         ,ih_total_value = int_utility.get_field(p_record, 3)
    WHERE  ih_id = p_ih_id;

  END IF;

  p_error := NULL;    -- no errors occured

  EXCEPTION
    WHEN invalid_contract THEN
      IF p_error IS NULL THEN    -- new error
        p_error := 'Invalid Contract Reference';
        INSERT INTO interface_erroneous_records (
             ier_ih_id
            ,ier_record_type
            ,ier_record_text
            ,ier_error)
        VALUES (
             p_ih_id
            ,int_utility.get_field(p_record, 1)  -- l_record_type
            ,p_record
            ,p_error);
        IF l_record_type = '05' THEN    -- nullify mandatory fields
--        p_claim_ref := Null;        -- to ensure child records
        NULL;
        ELSIF l_record_type = '10' THEN    -- fail and do not get
        p_wol_id := NULL;            -- inserted under incorrect
        END IF;                    -- parent
      ELSE  -- validating existing error (from form)
        p_error := 'Invalid Contract Reference';    -- don't create an error record
                    -- one already exists
      END IF;
      IF l_record_type = '00' THEN    -- error with the header record
        p_ih_id := NULL;        -- mark for process halting
      END IF;
    WHEN mandatory_is_null THEN
      IF p_error IS NULL THEN    -- new error
        p_error := 'Mandatory field is null';
        INSERT INTO interface_erroneous_records (
             ier_ih_id
            ,ier_record_type
            ,ier_record_text
            ,ier_error)
        VALUES (
             p_ih_id
            ,int_utility.get_field(p_record, 1)  -- l_record_type
            ,p_record
            ,p_error);
        IF l_record_type = '05' THEN    -- nullify mandatory fields
        p_claim_ref := NULL;        -- to ensure child records
        ELSIF l_record_type = '10' THEN    -- fail and do not get
        p_wol_id := NULL;            -- inserted under incorrect
        END IF;                    -- parent
      ELSE  -- validating existing error (from form)
        p_error := 'Mandatory field is null';    -- don't create an error record
                    -- one already exists
      END IF;
      IF l_record_type = '00' THEN    -- error with the header record
        p_ih_id := NULL;        -- mark for process halting
      END IF;
    WHEN others THEN

      IF p_error IS NULL THEN    -- new error

        p_error := SQLERRM;

        INSERT INTO interface_erroneous_records (
             ier_ih_id
            ,ier_record_type
            ,ier_record_text
            ,ier_error)
        VALUES (
             p_ih_id
            ,int_utility.get_field(p_record, 1)  -- l_record_type
            ,p_record
            ,p_error);

        IF l_record_type = '05' THEN    -- nullify mandatory fields
        p_claim_ref := NULL;        -- to ensure child records
        ELSIF l_record_type = '10' THEN    -- fail and do not get
        p_wol_id := NULL;            -- inserted under incorrect
        END IF;                    -- parent

      ELSE  -- validating existing error (from form)

        p_error := SQLERRM;    -- don't create an error record
                    -- one already exists
      END IF;

      IF l_record_type = '00' THEN    -- error with the header record
        p_ih_id := NULL;        -- mark for process halting
      END IF;

END;

---------------------------------------------------------------------
-- Using the WOL_ID check the status is paid and returns 'PAID' or
-- 'UNPAID'.
--
FUNCTION check_paid_status(p_ih_id IN interface_headers.ih_id%TYPE
                          ) RETURN number IS

CURSOR c1 (l_wol_id work_order_lines.wol_id%TYPE) IS
  SELECT wol_status_code
  FROM   work_order_lines
  WHERE  wol_id = l_wol_id;

CURSOR c2 IS
  SELECT hsc_status_code
  FROM   hig_status_codes
  WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
  AND    hsc_allow_feature4 = 'Y'
  AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

CURSOR c3 IS
  SELECT icwor_claim_type, icwol_wol_id
  FROM   interface_claims_wol
        ,interface_claims_wor
  WHERE  p_ih_id = icwor_ih_id
  AND    icwol_ih_id = icwor_ih_id;

l_icwol_wol_id interface_claims_wol.icwol_wol_id%TYPE;
l_wol_status_code work_order_lines.wol_status_code%TYPE;

BEGIN
  FOR c3rec IN c3 LOOP
    OPEN c1(c3rec.icwol_wol_id);
    FETCH c1 INTO l_wol_status_code;
    CLOSE c1;

    FOR c2rec IN c2 LOOP
      IF l_wol_status_code = c2rec.hsc_status_code THEN
        IF c3rec.icwor_claim_type = 'P' THEN
          l_icwol_wol_id := c3rec.icwol_wol_id;
        END IF;
      END IF;
    END LOOP;
  END LOOP;
  RETURN l_icwol_wol_id;
END;
---------------------------------------------------------------------
-- updates an interface_erroneous_records entry to change the sign of
-- the p_ih_id
--
PROCEDURE update_ier(p_ih_id IN interface_headers.ih_id%TYPE
                          ) IS

BEGIN
  UPDATE interface_erroneous_records
  SET ier_ih_id = (p_ih_id*-1)
  WHERE ier_ih_id = p_ih_id;
  COMMIT;
END;
---------------------------------------------------------------------
-- Processes a Claim file into oracle interface tables and
-- validates the contents. Also writes a Financial Debit Transaction
-- file.
--

PROCEDURE claim_file_ph1(p_job_id IN number
                ,p_contractor_id    IN varchar2
                ,p_seq_no        IN number
                ,p_filepath        IN varchar2
                ,p_filename     IN varchar2
                ,p_error        OUT varchar2) IS
BEGIN
  xnhcc_interfaces.g_job_id := p_job_id;
  --
  interfaces.claim_file_ph1(p_contractor_id
                           ,p_seq_no
                           ,p_filepath
                           ,p_filename
                           ,p_error);
END;
--
PROCEDURE claim_file_ph1(p_contractor_id    IN varchar2
                ,p_seq_no        IN number
                ,p_filepath        IN varchar2
                ,p_filename     IN varchar2
                ,p_error        OUT varchar2) IS

  l_today            date := SYSDATE;
  l_fhand            utl_file.file_type;        -- claim file
  l_seq_no            varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,p_contractor_id, p_seq_no, 'WI');
  l_filename        varchar2(12) := NVL(p_filename,'WI'||TO_CHAR(l_seq_no)||'.'||p_contractor_id);
  l_record            interface_erroneous_records.ier_record_text%TYPE;
  l_error            interface_erroneous_records.ier_error%TYPE;
  l_ih_id            interface_headers.ih_id%TYPE;
  l_wor_no            interface_claims_wor.icwor_works_order_no%TYPE;
  l_wol_id            interface_claims_wol.icwol_wol_id%TYPE;
  l_claim_date        interface_claims_wor.icwor_claim_date%TYPE;
  l_claim_ref         interface_claims_wor.icwor_con_claim_ref%TYPE;
  l_con_id              interface_claims_wor.icwor_con_id%TYPE;
  l_file_not_found     varchar2(250) := 'Error: Unable to open file. Path: '||NVL(p_filepath, g_filepath)||'  File: '||l_filename;
  l_invalid_filename varchar2(250) := 'Error: Filename invalid. Check the ZEROPAD product option. File: '||l_filename;
  invalid_file     EXCEPTION;
  invalid_filename EXCEPTION;

BEGIN

  BEGIN
    if check_filename(l_filename) then
    	
      l_fhand := UTL_FILE.FOPEN(NVL(p_filepath, g_filepath), l_filename, 'r');

      IF UTL_FILE.IS_OPEN(l_fhand) THEN

        LOOP
        
          UTL_FILE.GET_LINE(l_fhand, l_record);
          l_error := NULL;

          populate_wi_interface_tables(l_ih_id
                                      ,l_wor_no
                                      ,l_wol_id
                                      ,l_claim_date
                                      ,l_claim_ref
                                      ,l_con_id
                                      ,l_record
                                      ,l_error);

          IF l_ih_id IS NULL THEN    -- error in header record
            EXIT;                -- halt processing
          END IF;
        
        END LOOP;

      ELSE
        RAISE invalid_file;
      END IF;
    else
      raise invalid_filename;
    end if;
    EXCEPTION
      WHEN invalid_file OR utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
        p_error := l_file_not_found;
      WHEN invalid_filename THEN
        p_error := l_invalid_filename;
        WHEN no_data_found THEN  -- end of file
        UTL_FILE.FCLOSE(l_fhand);

      WHEN others THEN
        p_error := SQLERRM;

  END;

  validate_claim_data(l_ih_id);
  nm3ctx.set_context('CIM_WI_IH_ID',l_ih_id);
  COMMIT;

END;

---------------------------------------------------------------------
--Checks the format of two date formats in a char and returns it as a
--date.
--
FUNCTION check_date_format (p_datechar IN varchar2) RETURN date IS
  l_date date;
BEGIN

IF LENGTH(p_datechar) < 12 THEN
   l_date := TO_DATE(p_datechar, 'DD-MON-YYYY');
ELSE
   l_date := TO_DATE(p_datechar, 'DD-MON-YYYY HH24:MI:SS');
END IF;
RETURN l_date;
EXCEPTION
  WHEN others THEN
    IF LENGTH(p_datechar) < 12 THEN
       l_date := TO_DATE(p_datechar, 'DDMMYYYY');
    ELSE
       l_date := TO_DATE(p_datechar, 'DDMMYYYY HH24:MI:SS');
    END IF;
    RETURN l_date;
END;
---------------------------------------------------------------------
-- Processes valid Claim data into Highways Maintenance Manager
-- tables.
--

--
PROCEDURE claim_file_ph2(p_ih_id IN  interface_headers.ih_id%TYPE
                ,p_file  OUT varchar2
                ,p_error OUT varchar2) IS

  CURSOR usr_id IS
    SELECT hus_user_id
    FROM   hig_users
    WHERE  hus_username = USER;

  CURSOR wols IS
    SELECT icwol_defect_id
        ,icwol_schd_id
        ,icwol_wol_id
        ,icwol_date_complete
        ,icwor_works_order_no
        ,icwor_claim_type
        ,icwor_claim_date
        ,icwor_con_claim_ref
        ,icwor_con_id
        ,icwol_claim_value
        ,oun_unit_code
        ,wol_icb_work_code
    FROM   interface_claims_wol
        ,interface_claims_wor
        ,contracts
        ,org_units
        ,work_order_lines
    WHERE  oun_org_id = con_contr_org_id
    AND    con_id = icwor_con_id
    AND    icwol_wol_id = wol_id
    AND    icwol_status = 'P'
    AND    icwol_ih_id = p_ih_id
    AND    icwor_ih_id = icwol_ih_id
    AND    icwor_con_claim_ref = icwol_con_claim_ref
    AND    icwor_con_id = icwol_con_id
    AND    icwor_status = 'P';

  CURSOR boqs (p_wol_id         interface_claims_wol.icwol_wol_id%TYPE
          ,p_con_claim_ref interface_claims_wol.icwol_con_claim_ref%TYPE
          ,p_con_id         interface_claims_wol.icwol_con_id%TYPE) IS
    SELECT *
    FROM   interface_claims_boq
    WHERE  icboq_ih_id = p_ih_id
    AND    icboq_con_claim_ref = p_con_claim_ref
    AND    icboq_con_id = p_con_id
    AND    icboq_wol_id = p_wol_id
    AND    icboq_status = 'P';

  CURSOR neg_boqs (p_wol_id    boq_items.boq_wol_id%TYPE
            ,p_item_code boq_items.boq_sta_item_code%TYPE) IS
    SELECT boq_act_quantity
        ,ROWID
    FROM   boq_items
    WHERE  boq_wol_id = p_wol_id
    AND    boq_sta_item_code = p_item_code;

  CURSOR boq_id IS
    SELECT boq_id_seq.NEXTVAL
    FROM dual;

  cursor c_defects ( pi_def_defect_id repairs.rep_def_defect_id%TYPE ) is
  select * 
     from defects
     where def_defect_id = pi_def_defect_id
     	 and def_date_compl is null;

  l_boq_id_seq             number;
  l_user_id                hig_users.hus_user_id%TYPE;
  l_wol_not_done_status    hig_status_codes.hsc_status_code%TYPE;
  l_wol_interim_status     hig_status_codes.hsc_status_code%TYPE;
  l_count                  number;
  l_quantity               boq_items.boq_act_quantity%TYPE;
  l_rowid                  ROWID;
  l_no_of_recs             number(7) := 0;
  l_total_value            number := 0;
  l_cost_code              budgets.bud_cost_code%TYPE;
  l_fhand                  utl_file.file_type;        -- financial debit file
  l_seq_no                 varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,'', '', 'FD');
  l_filename               varchar2(12) := 'FD'||TO_CHAR(l_seq_no)||'.'||'DAT';
  l_today                  date := SYSDATE;
  l_header_record          varchar2(30) := '00,'||TO_CHAR(l_seq_no)||','||
                                           TO_CHAR(l_today, g_date_format)||','||TO_CHAR(l_today, g_time_format);
  l_file_not_found         varchar2(250) := 'Error: Unable to write Financial Debit File. Path: '||g_filepath||'  File: '||l_filename;
  invalid_file             EXCEPTION;
  l_fyr_id                 financial_years.fyr_id%TYPE; 
  l_wol_date_complete      work_order_lines.wol_date_complete%TYPE;
  lv_row_found             BOOLEAN;
  lv_claim_value           work_order_lines.wol_act_cost%TYPE;
  
  TYPE wol_over_budget_tab IS TABLE OF work_order_lines.wol_id%type INDEX BY BINARY_INTEGER;
  
  lt_wol_over_budget   wol_over_budget_tab;
  
  /*---------------------------------------------------
  || Apply any % uplifts 
  ----------------------------------------------------*/
  FUNCTION apply_perc_uplift(p_ih_id       interface_headers.ih_id%TYPE
                            ,p_wol_id      work_order_lines.wol_id%TYPE
							,p_claim_ref   interface_claims_boq_all.icboq_con_claim_ref%TYPE
							,p_num         work_order_lines.wol_act_cost%TYPE)
    RETURN NUMBER IS
    --
    CURSOR c1 IS
    SELECT wol_boq_perc_item_code,
	       wol_wol_perc_item_code
	  FROM work_order_lines
     WHERE wol_id = p_wol_id;
    --
    CURSOR boq_uplift_rate(p_sta_item_code   standard_items.sta_item_code%TYPE) IS
    SELECT sta_rate
      FROM standard_items
     WHERE sta_item_code = p_sta_item_code;
    --
	CURSOR wol_boq_uplift_totals(p_boq_uplift_rate   standard_items.sta_rate%TYPE) is
    SELECT NVL(sum(icboq_cost) * (p_boq_uplift_rate / 100),0)
     FROM standard_items,
          interface_claims_boq_all
    WHERE icboq_sta_item_code = sta_item_code
      AND NVL(sta_allow_percent, 'Y') = 'Y'
      AND icboq_ih_id = p_ih_id
	  AND icboq_con_claim_ref = p_claim_ref
	  AND icboq_wol_id = p_wol_id;

	lv_retval                   NUMBER;
    lv_wol_boq_perc_item_code   work_order_lines.wol_boq_perc_item_code%TYPE := NULL;
    lv_wol_wol_perc_item_code   work_order_lines.wol_wol_perc_item_code%TYPE := NULL;
    lv_boq_uplift_rate          standard_items.sta_rate%TYPE;
    lv_wol_uplift_rate          standard_items.sta_rate%TYPE;
	lv_wol_act_uplift           NUMBER := 0;
	lv_wol_act_cost             work_order_lines.wol_act_cost%TYPE;
    --
  BEGIN
	nm_debug.debug_on;
	--
	nm_debug.debug('-->p_ih_id='||p_ih_id||' p_claim_ref='||p_claim_ref||' p_wol_id='||p_wol_id);
	--
	OPEN  c1;
	FETCH c1 INTO lv_wol_boq_perc_item_code,
	              lv_wol_wol_perc_item_code;
	CLOSE c1;
	--
    nm_debug.debug('--> boq_uplift='||lv_wol_boq_perc_item_code||' wol_uplift='||lv_wol_wol_perc_item_code);

	--
	IF lv_wol_boq_perc_item_code IS NULL AND
	   lv_wol_wol_perc_item_code IS NULL
	THEN
	  lv_retval :=  p_num;
	ELSE
	  /*
	  || Get WOL percent Uplift Item Codes rates
	  */
	  lv_wol_act_cost := p_num;
	  --
	  IF lv_wol_boq_perc_item_code IS NOT NULL
	  THEN
		OPEN boq_uplift_rate(lv_wol_boq_perc_item_code);
		FETCH boq_uplift_rate into lv_boq_uplift_rate;
		CLOSE boq_uplift_rate;
		--
		nm_debug.debug('-->BOQ Uplift rate ='||lv_boq_uplift_rate);
		--
        OPEN wol_boq_uplift_totals(lv_boq_uplift_rate);
        FETCH wol_boq_uplift_totals into lv_wol_act_uplift;
		if wol_boq_uplift_totals%NOTFOUND
		then
		   nm_debug.debug('--> NOTFOUND');
		end if;
        CLOSE wol_boq_uplift_totals;
        --
		nm_debug.debug('-->BOQ Uplift total ='||lv_wol_act_uplift);
		--
        lv_wol_act_cost := lv_wol_act_cost + lv_wol_act_uplift;
		--
		nm_debug.debug('-->Act cost ='||lv_wol_act_cost);
		
	  END IF;
	  
	  IF lv_wol_wol_perc_item_code IS NOT NULL
	  THEN
		OPEN boq_uplift_rate(lv_wol_wol_perc_item_code);
		FETCH boq_uplift_rate into lv_wol_uplift_rate;
		CLOSE boq_uplift_rate;
		--
		nm_debug.debug('-->WOL Uplift rate ='||lv_wol_uplift_rate);
		--
		lv_wol_act_cost := lv_wol_act_cost + (lv_wol_act_cost * (lv_wol_uplift_rate / 100));
		--
		nm_debug.debug('-->Act cost ='||lv_wol_act_cost);
		
	  END IF;
	  --
      nm_debug.debug('-->Return Value ='||lv_wol_act_cost);

	  lv_retval := lv_wol_act_cost;

	END IF;
	--
	RETURN lv_retval;
	--
  END apply_perc_uplift;

  /*---------------------------------------------------
  || Apply any discount group values 
  ----------------------------------------------------*/
  FUNCTION apply_balancing_sum(p_con_id            contracts.con_id%TYPE 
                              ,p_wor_date_raised   work_orders.wor_date_raised%TYPE
                              ,p_num               work_order_lines.wol_act_cost%TYPE)
    RETURN NUMBER IS
    --
    CURSOR c1 IS
    SELECT oun_cng_disc_group
	  FROM org_units
		  ,contracts
     WHERE con_contr_org_id = oun_org_id
	   AND con_id = p_con_id
	   AND (p_wor_date_raised BETWEEN NVL(con_start_date,p_wor_date_raised)
		   					      AND NVL(con_end_date,  p_wor_date_raised));
    --
    lv_retval     NUMBER;
    l_disc_group  org_units.oun_cng_disc_group%type;
          --
  BEGIN
	--
	OPEN  c1;
	FETCH c1 INTO l_disc_group;
	CLOSE c1;
	--
	IF l_disc_group IS NULL
	THEN
	  lv_retval :=  p_num;
	ELSE
	  IF p_num < 0
	   THEN
		  lv_retval := p_num - maiwo.bal_sum(abs(p_num), l_disc_group);
	  ELSE
		  lv_retval := p_num + maiwo.bal_sum(abs(p_num), l_disc_group);
	  END IF;
	END IF;
	--
	RETURN lv_retval;
	--
  END apply_balancing_sum;
  
  /*---------------------------------------------------
  || Update Budget Actual details 
  ----------------------------------------------------*/
  FUNCTION update_budget_actual(p_wol_id         work_order_lines.wol_id%TYPE,
                                p_bud_id         budgets.bud_id%TYPE,
                                p_bud_actual     budgets.bud_actual%TYPE,
                                p_claim_type     VARCHAR2 DEFAULT NULL) 
	RETURN BOOLEAN IS
    --   
    rtrn               BOOLEAN := TRUE;

    cursor c_wol (lp_wol_id WORK_ORDER_LINES.wol_id%TYPE) is
    select  NVL(wol_est_cost,0) wol_est_cost
           ,NVL(wol_act_cost,0) wol_act_cost
           ,NVL(wol_unposted_est,0) wol_unposted_est
      from  work_order_lines
     where  wol_id = lp_wol_id;

    cursor c_bud (lp_bud_id budgets.bud_id%TYPE) is
    select  bud_value
           ,bud_actual
           ,bud_committed
     from   budgets
     where  bud_id = lp_bud_id;
     
    cursor c_discount_group(lp_wol_id WORK_ORDER_LINES.wol_id%TYPE) is
    select wor_con_id,
           wor_date_raised
      from work_orders,
           work_order_lines
     where wor_works_order_no = wol_works_order_no
       and wol_Id = lp_wol_id;
    
    lv_wol_rec       c_wol%ROWTYPE;
      
    lv_committed         budgets.bud_actual%TYPE;
    lv_actual            budgets.bud_actual%TYPE;
    lv_unposted          work_order_lines.wol_unposted_est%TYPE;
    lv_bud_value         budgets.bud_value%TYPE;
    lv_bud_actual        budgets.bud_actual%TYPE;
    lv_bud_committed     budgets.bud_committed%TYPE;
    lv_con_id            contracts.con_id%TYPE;
    lv_wor_date_raised   work_orders.wor_date_raised%TYPE;
   
  BEGIN

     /*
     || Get current WOL details (ie before update due to Invoice)
     */
     OPEN c_wol(p_wol_id);
     FETCH c_wol INTO lv_wol_rec;
     CLOSE c_wol;

     nm_debug.debug('--> Est='||lv_wol_rec.wol_est_cost||' Act='||lv_wol_rec.wol_act_cost||' Unposted='||lv_wol_rec.wol_unposted_est);
     /*
     || New Unposted = WOL estimated cost - Invoice value (if Invoice > Estimated, unposted = 0)
     */
     lv_unposted := GREATEST((lv_wol_rec.wol_est_cost - p_bud_actual), 0);

     /* 
     || Value to substract from Budget Committed = WOL unposted estimate - newly calculated unposted estimate
     */
     lv_committed := lv_wol_rec.wol_unposted_est - lv_unposted;
     
     /*
     || Value to add to Budget Actual = Invoice value - WOL actual cost
     */
     OPEN c_discount_group(p_wol_id);
     FETCH c_discount_group INTO lv_con_id,
                                                  lv_wor_date_raised;
     CLOSE c_discount_group;

     lv_actual   := apply_balancing_sum(lv_con_id,
                                        lv_wor_date_raised,
                                        p_bud_actual - lv_wol_rec.wol_act_cost);

     /*
     || If not allowing over budget, check the budget hasn't been blown
     */
     IF Maiwo.has_role('OVER_BUDGET') != 'TRUE'
     THEN
     
       /*
       || Get current budget details
       */
       OPEN c_bud(p_bud_id);
       FETCH c_bud INTO lv_bud_value,
                        lv_bud_actual,
                        lv_bud_committed;
       CLOSE c_bud;

       nm_debug.debug('--> lv_unposted='||lv_unposted||' lv_committed='||lv_committed||' lv_actual='||lv_actual);
  
       -- Is budget unlimmited (ie value = -1) 
       IF lv_bud_value != -1 
       THEN
       
         -- Calculate new budget value, depending on whether this a final claim
         IF p_claim_type = 'F'
         THEN
            lv_bud_value := lv_bud_value - (NVL(lv_bud_actual,0) + NVL(lv_actual,0));
         ELSE
            lv_bud_value := lv_bud_value - (NVL(lv_bud_actual,0) + NVL(lv_actual,0) + NVL(lv_bud_committed,0) - NVL(lv_committed,0));
         END IF;
         
         -- If lv_bud_value <0, budget has been blown
         IF lv_bud_value < 0
         THEN         
            rtrn := FALSE;
         END IF;
         
       END IF;
       
     END IF;
    
     IF rtrn
     THEN

       UPDATE BUDGETS
       SET bud_committed = DECODE(p_claim_type, 'F', NVL(bud_committed,0) - lv_wol_rec.wol_unposted_est, NVL(bud_committed,0) - NVL(lv_committed,0)),
              bud_actual = NVL(bud_actual,0) + NVL(lv_actual,0)
       WHERE bud_id = p_bud_id;

       UPDATE WORK_ORDER_LINES
       SET wol_unposted_est = DECODE(p_claim_type , 'F', 0, lv_unposted)
       WHERE wol_id = p_wol_id;
       
     END IF;

     RETURN rtrn;

   END update_budget_actual;
   
  PROCEDURE add_to_budget (v_wol_id        IN work_order_lines.wol_id%type
                          ,v_bud_id        IN work_order_lines.wol_bud_id%type
                          ,v_act           IN work_order_lines.wol_act_cost%type default 0
                          ,v_claim_type    IN VARCHAR2 DEFAULT NULL)
   IS
      CURSOR c1 (p_wol_id WORK_ORDER_LINES.wol_id%TYPE) is 
      SELECT wol_status_code
      FROM   WORK_ORDER_LINES
      WHERE  wol_id = p_wol_id;
      
      l_status_code    WORK_ORDER_LINES.wol_status_code%type;
      lv_row_found     boolean := FALSE;
      v_retval         boolean := TRUE;
   --
   BEGIN
   --
       OPEN c1(v_wol_id);
       FETCH c1 INTO l_status_code;
       CLOSE c1;
       
       UPDATE work_order_lines
       SET    wol_status_code = null
       WHERE  wol_id = v_wol_id;
          
       v_retval := update_budget_actual(v_wol_id, 
                                        v_bud_id, 
                                        v_act,
                                        v_claim_type);
          
       UPDATE work_order_lines
       SET    wol_status_code = l_status_code
       WHERE  wol_id = v_wol_id;

       if not v_retval then

           lt_wol_over_budget(lt_wol_over_budget.count+1) := v_wol_id;

       end if;
   --  
   END add_to_budget;

BEGIN

  OPEN usr_id;
  FETCH usr_id INTO l_user_id;
  CLOSE usr_id;

  BEGIN

    SELECT hsc_status_code
    INTO   l_wol_not_done_status
    FROM   hig_status_codes
    WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
    AND    hsc_allow_feature5 = 'Y'
    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

    EXCEPTION
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 275));
      WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 276));

  END;

  BEGIN

    SELECT hsc_status_code
    INTO   l_wol_interim_status
    FROM   hig_status_codes
    WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
--    And    hsc_allow_feature6 = 'Y'
--removal of interface only status codes. Trying to bring interfaces inline with MM.-sm 14-01-03
    AND    hsc_allow_feature9 = 'Y'
    AND    hsc_allow_feature4 = 'N'
    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

    EXCEPTION        -- need to add these messages to errors table
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001, '> 1 interim work order line status code exists');
      WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20001, 'No interim work order line status code exists');

  END;

  nm_debug.debug_on;
 /*---------------------------------------------------
  || Update Budget details, and check for over budget
  ----------------------------------------------------*/
  FOR c2rec IN (SELECT icwor_works_order_no, 
                       icwor_claim_value,
                       icwor_claim_type,  
                       icwor_con_claim_ref
                FROM   interface_claims_wor_all
               WHERE   icwor_ih_id =  p_ih_id
               AND     icwor_error IS NULL) 
  LOOP
      lt_wol_over_budget.DELETE;
      SAVEPOINT wo_claim;
            
      FOR wol_rec IN (SELECT wol_rse_he_id
                            ,wol_id
                            ,wol_def_defect_id
                            ,NVL(wol_act_cost,0) wol_act_cost
                            ,NVL(wol_est_cost,0) wol_est_cost
                            ,wol_bud_id
                            ,icwol_claim_value
                      FROM  work_order_lines,
					        interface_claims_wol_all
                    WHERE  icwol_wol_id = wol_id
                        AND  icwol_ih_id = p_ih_id
						AND  icwol_status = 'P'
                        AND  icwol_con_claim_ref = c2rec.icwor_con_claim_ref
                        AND  wol_works_order_no = c2rec.icwor_works_order_no ) 
      LOOP
	      lv_claim_value := apply_perc_uplift(p_ih_id
											 ,wol_rec.wol_id
											 ,c2rec.icwor_con_claim_ref
											 ,wol_rec.icwol_claim_value);
		  --				   
          add_to_budget(wol_rec.wol_id
                       ,wol_rec.wol_bud_id
                       ,lv_claim_value
					   ,c2rec.icwor_claim_type);  
      END LOOP;
      
      IF lt_wol_over_budget.count > 0 
      THEN
         ROLLBACK TO SAVEPOINT wo_claim;
         
      
         FOR i IN 1 .. lt_wol_over_budget.count LOOP

            UPDATE interface_claims_wol
            SET    icwol_error = 'Cannot complete operation. Budget limit exceeded.'
                  ,icwol_status = 'R'
            WHERE  icwol_ih_id = p_ih_id
              AND  icwol_wol_id = lt_wol_over_budget(i)
              AND  icwol_status != 'R';       

            IF SQL%rowcount > 0 THEN
              validate_wo_item(p_ih_id,'WOL',1);
            END IF;
         END LOOP;
         
      END IF;
      
  END LOOP;
  ----------------------------------------------------------------------------------------

 -- write financial debit transaction header record
  l_fhand := UTL_FILE.FOPEN(g_filepath, l_filename, 'w');
  IF UTL_FILE.IS_OPEN(l_fhand) THEN
    UTL_FILE.PUT_LINE(l_fhand, l_header_record);
    p_file := 'Financial Debit File '||l_filename||' created in '||g_filepath;
  ELSE
    RAISE invalid_file;
  END IF;

  INSERT INTO work_order_claims (
         woc_claim_ref
        ,woc_con_id
        ,woc_claim_type
        ,woc_claim_date
        ,woc_claim_value
        ,woc_works_order_no
        ,woc_interim_no)
  SELECT     icwor_con_claim_ref
        ,icwor_con_id
        ,icwor_claim_type
        ,icwor_claim_date
        ,icwor_claim_value
        ,icwor_works_order_no
        ,icwor_interim_no
  FROM     interface_claims_wor
  WHERE      icwor_status = 'P'
  AND         icwor_ih_id = p_ih_id
  AND         NOT EXISTS (SELECT 1                -- for when reprocessing existing invoices
                 FROM   work_order_claims    -- ie. for previously held or rejected records
                 WHERE  woc_claim_ref = icwor_con_claim_ref
                 AND    woc_con_id = icwor_con_id);

  INSERT INTO claim_payments (
         cp_woc_claim_ref
        ,cp_woc_con_id
        ,cp_wol_id
        ,cp_status
        ,cp_claim_value)
  SELECT     icwor_con_claim_ref
        ,icwor_con_id
        ,icwol_wol_id
        ,DECODE(get_woc_claim_type(icwor_con_claim_ref, icwor_con_id),'P','H',hop_value)
        ,icwol_claim_value
  FROM     hig_options
        ,interface_claims_wol
        ,interface_claims_wor
  WHERE     hop_id = 'CLAIMDEF'
  AND     icwor_ih_id = p_ih_id
  AND     icwor_status = 'P'
  AND     icwor_con_claim_ref = icwol_con_claim_ref
  AND      icwor_con_id = icwol_con_id
  AND     icwol_ih_id = icwor_ih_id
  AND     icwol_status = 'P';

  IF hig.get_sysopt('CPAINTERIM') = '1'
    THEN
      UPDATE claim_payments SET cp_status = 'H'
       WHERE cp_status = 'A'
     AND cp_wol_id IN
      (SELECT icwol_wol_id
      FROM interface_claims_wor
         , interface_claims_wol
         , claim_payments
      WHERE icwor_ih_id = p_ih_id
      AND icwor_status = 'P'
      AND icwor_con_claim_ref = icwol_con_claim_ref
      AND icwor_con_id = icwol_con_id
      AND icwol_ih_id = icwor_ih_id
      AND icwol_status = 'P'
      AND icwol_wol_id = cp_wol_id
      AND cp_status = 'A');
  END IF;

  FOR wol_rec IN wols LOOP

-- write financial debit transaction debit record
      IF UTL_FILE.IS_OPEN(l_fhand) THEN

      OPEN cost_code(wol_rec.icwol_wol_id);
      FETCH cost_code INTO l_cost_code;
      CLOSE cost_code;

    l_fyr_id := get_fyr_id(wol_rec.icwol_wol_id);--SM 26112008 717549
    if l_fyr_id = '-1' then
        l_fyr_id := null;
    end if;

        UTL_FILE.PUT_LINE(l_fhand, '05,'||TO_CHAR(wol_rec.icwor_claim_date, g_date_format)||','||
                  wol_rec.icwor_con_claim_ref||','||wol_rec.icwor_works_order_no||','||
                  TO_CHAR(wol_rec.icwol_wol_id)||','||TO_CHAR(wol_rec.icwol_defect_id)||','||
                  TO_CHAR(wol_rec.icwol_schd_id)||','||wol_rec.oun_unit_code||','||
                  LTRIM(TO_CHAR(wol_rec.icwol_claim_value,'9999999990.00'))||','||wol_rec.wol_icb_work_code||','||
                  l_cost_code||','||l_fyr_id);

        l_no_of_recs := l_no_of_recs + 1;
        l_total_value := l_total_value + wol_rec.icwol_claim_value;

      ELSE
        RAISE invalid_file;
      END IF;
/*************************************************************************************************
** SM 19032009 718508
** Added the wol_id into the call of maiwo.update_defect_date as when the defect had both a T and 
** a P repair it was using the first repair complete date to complete both repairs even when they
** were different. 
*************************************************************************************************/
      IF wol_rec.icwor_claim_type = 'F' AND  -- not necessary for Post or Interim claims
         wol_rec.icwol_defect_id IS NOT NULL THEN -- skip for non defect WOLs
        IF hig.get_user_or_sys_opt('WCCOMPLETE')='Y' then -- SM 06012009 717676
          --check to see if defect is complete already
          for c_defectsrec in c_defects(wol_rec.icwol_defect_id) loop
            --maiwo.update_defect_date( wol_rec.icwol_defect_id
            update_defect_date( wol_rec.icwol_defect_id
                              , wol_rec.icwol_date_complete
                              , wol_rec.icwor_works_order_no  
                              , wol_rec.icwol_wol_id); -- SM 19032009 718508

            UPDATE defects
            SET    def_status_code = (SELECT MAX(hsc_status_code)
            FROM   hig_status_codes
            WHERE  hsc_allow_feature4 = 'Y'
            AND    hsc_domain_code = 'DEFECTS'
            AND    g_today BETWEEN NVL(hsc_start_date, g_today)
            AND NVL(hsc_end_date, g_today))
            ,def_last_updated_date = SYSDATE
            WHERE  NOT EXISTS (SELECT 1
                             FROM   repairs
                             WHERE  rep_def_defect_id = def_defect_id
                             AND    rep_date_completed IS NULL)
          AND       def_defect_id = wol_rec.icwol_defect_id;          
          end loop;
        else
          --maiwo.update_defect_date( wol_rec.icwol_defect_id
          update_defect_date( wol_rec.icwol_defect_id
                            , wol_rec.icwol_date_complete
                            , wol_rec.icwor_works_order_no  
                            , wol_rec.icwol_wol_id); -- SM 19032009 718508
          UPDATE defects
          SET    def_status_code = (SELECT MAX(hsc_status_code)
                                    FROM   hig_status_codes
                                    WHERE  hsc_allow_feature4 = 'Y'
                                    AND    hsc_domain_code = 'DEFECTS'
                                    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
                                                       AND NVL(hsc_end_date, g_today))
                ,def_last_updated_date = SYSDATE
          WHERE  NOT EXISTS (SELECT 1
                             FROM   repairs
                             WHERE  rep_def_defect_id = def_defect_id
                             AND    rep_date_completed IS NULL)
          AND       def_defect_id = wol_rec.icwol_defect_id;
        end if;

      END IF;

      IF wol_rec.icwor_claim_type IN ('F', 'I') THEN -- not necessariy for Post claims

      -- set the actuals of all BoQs on current WOL to zero

        UPDATE boq_items
        SET    boq_act_dim1 = 0
              ,boq_act_dim2 = DECODE(boq_est_dim2, NULL, NULL, 0)
              ,boq_act_dim3 = DECODE(boq_est_dim3, NULL, NULL, 0)
              --,boq_act_rate = 0                            -- Task 0109687 
              ,boq_act_rate = NVL(boq_act_rate,boq_est_rate) -- Task 0109687 copied the estimated rate into the actual if actual is null, instead of zero
              ,boq_act_quantity = 0
              ,boq_act_cost = 0
              ,boq_act_labour = 0
              ,boq_act_discount = 0
        WHERE  boq_wol_id = wol_rec.icwol_wol_id;

      END IF;

      FOR boq_rec IN boqs(wol_rec.icwol_wol_id
                         ,wol_rec.icwor_con_claim_ref
                         ,wol_rec.icwor_con_id) LOOP

        IF wol_rec.icwor_claim_type IN ('F', 'I') THEN -- not necessariy for Post claims

      -- set actuals of first matching BoQ that hasn't already been updated
       IF hig.get_sysopt('XTRIFLDS') IN ('2-1-3', '2-4-0') THEN
          UPDATE boq_items
          SET    (boq_act_dim1
                 ,boq_act_dim2
                 ,boq_act_dim3) = (SELECT NVL(boq_rec.icboq_dim1, DECODE(sta_dim1_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, NULL, 1))
                                          FROM standard_items
                                              ,boq_items
                                          WHERE sta_item_code = boq_rec.icboq_sta_item_code
                                          AND boq_sta_item_code = sta_item_code
                                          AND boq_act_cost = 0
                                          AND boq_wol_id = wol_rec.icwol_wol_id
                                          AND ROWNUM = 1)
                ,boq_act_rate = boq_rec.icboq_rate
                ,boq_act_quantity = boq_rec.icboq_quantity
                ,boq_act_cost = boq_rec.icboq_cost
                ,boq_act_labour = (SELECT ROUND(MAX(boq_rec.icboq_quantity * sta_labour_units), 2)
                                   FROM   standard_items
                                   WHERE  sta_item_code = boq_rec.icboq_sta_item_code)
                ,boq_act_discount = boq_est_discount
                ,boq_item_name = DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc)
          WHERE  boq_wol_id = wol_rec.icwol_wol_id
          AND    boq_sta_item_code = boq_rec.icboq_sta_item_code
          AND    boq_id = boq_rec.icboq_boq_id
          AND    boq_act_cost = 0
          AND    ROWNUM = 1;
        ELSE
          UPDATE boq_items
          SET    (boq_act_dim1
                 ,boq_act_dim2
                 ,boq_act_dim3) = (SELECT NVL(boq_rec.icboq_dim1, DECODE(sta_dim1_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, NULL, 1))
                                          FROM standard_items
                                              ,boq_items
                                          WHERE sta_item_code = boq_rec.icboq_sta_item_code
                                          AND boq_sta_item_code = sta_item_code
                                          AND boq_act_cost = 0
                                          AND boq_wol_id = wol_rec.icwol_wol_id
                                          AND ROWNUM = 1)
                ,boq_act_rate = boq_rec.icboq_rate
                ,boq_act_quantity = boq_rec.icboq_quantity
                ,boq_act_cost = boq_rec.icboq_cost
                ,boq_act_labour = (SELECT ROUND(MAX(boq_rec.icboq_quantity * sta_labour_units), 2)
                                   FROM   standard_items
                                   WHERE  sta_item_code = boq_rec.icboq_sta_item_code)
                ,boq_act_discount = boq_est_discount
          WHERE  boq_wol_id = wol_rec.icwol_wol_id
          AND    boq_sta_item_code = boq_rec.icboq_sta_item_code
          AND    boq_act_cost = 0
          AND    ROWNUM = 1;
        END IF;
--
        END IF;

      -- if no matching item exists or claim type is Post (and not a credit) then create one

        IF SQL%rowcount = 0 OR (wol_rec.icwor_claim_type = 'P' AND boq_rec.icboq_quantity >= 0) THEN
       IF hig.get_sysopt('XTRIFLDS') IN ('2-1-3', '2-4-0') THEN
        IF SIGN(boq_rec.icboq_boq_id) = -1 THEN
          IF boq_rec.icboq_parent_boq_id IS NOT NULL THEN
            g_parent_boq_id_seq := g_boq_id_seq;
          ELSE
            g_parent_boq_id_seq := NULL;
          END IF;
            OPEN boq_id;
            FETCH boq_id INTO g_boq_id_seq;
            CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id
            ,boq_parent_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc, sta_item_name),',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
                    ,g_boq_id_seq
            ,g_parent_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
        ELSE
        OPEN boq_id;
        FETCH boq_id INTO l_boq_id_seq;
        CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc, sta_item_name),',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
            ,l_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
        END IF;
        ELSE
        OPEN boq_id;
        FETCH boq_id INTO l_boq_id_seq;
        CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(sta_item_name,',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
            ,l_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
          END IF;
    -- handle negative claims ie. credits
        ELSIF wol_rec.icwor_claim_type = 'P' AND boq_rec.icboq_quantity < 0 THEN

        OPEN neg_boqs(wol_rec.icwol_wol_id
                 ,boq_rec.icboq_sta_item_code);
        LOOP

          FETCH neg_boqs INTO l_quantity
                       ,l_rowid;
          EXIT WHEN neg_boqs%NOTFOUND;

          IF l_quantity + boq_rec.icboq_quantity < 0 THEN
          boq_rec.icboq_quantity := boq_rec.icboq_quantity + l_quantity;
          l_quantity := 0;
          ELSE
          l_quantity := l_quantity + boq_rec.icboq_quantity;
          boq_rec.icboq_quantity := 0;
          END IF;

          UPDATE boq_items
          SET    boq_act_dim1 = l_quantity
               ,(boq_act_dim2
                ,boq_act_dim3) = (SELECT DECODE(sta_dim2_text, NULL, NULL, DECODE(l_quantity, 0, 0, 1))
                                        ,DECODE(sta_dim3_text, NULL, NULL, DECODE(l_quantity, 0, 0, 1))
                                         FROM standard_items sta,
                                              boq_items boq
                                         WHERE boq.boq_sta_item_code = sta.sta_item_code
                                         AND boq.ROWID = l_rowid)
                ,boq_act_quantity = l_quantity
                ,boq_act_rate = DECODE(l_quantity, 0, 0, boq_act_rate)
                ,boq_act_cost = ROUND((l_quantity * boq_act_rate), 2)
                 WHERE  ROWID = l_rowid;

          EXIT WHEN boq_rec.icboq_quantity = 0;

        END LOOP;
        CLOSE neg_boqs;

        END IF;

      END LOOP;

      maiwo.adjust_contract_figures(wol_rec.icwol_wol_id
                         ,wol_rec.icwor_con_id
                         ,'+');

IF wol_rec.icwor_claim_type != 'I' THEN
  l_wol_date_complete := TO_DATE(TO_CHAR(wol_rec.icwol_date_complete, 'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS');
ELSE
  l_wol_date_complete := null;  --SM 15042998 - 707188 - Resetting the l_wol_date_complete to null should mean that the completion date doesn't get updated if the file contains both I and F files.
END IF;

	  /*
	  || apply any percent uplifts to wol_act_cost
	  */
	  lv_claim_value := apply_perc_uplift(p_ih_id
									     ,wol_rec.icwol_wol_id
									     ,wol_rec.icwor_con_claim_ref
									     ,wol_rec.icwol_claim_value);

      UPDATE work_order_lines
      SET    wol_status_code = DECODE(wol_rec.icwor_claim_type, 'F',
                          g_wol_comp_status, 'I',
                          l_wol_interim_status, wol_status_code)
            ,wol_date_complete = DECODE(wol_rec.icwor_claim_type, 'P',TO_DATE(TO_CHAR(wol_date_complete, 'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
                                       ,l_wol_date_complete/*Decode(wol_rec.icwor_claim_type,'I',null,to_date(to_char(wol_rec.icwol_date_complete, 'DD-MON-YYYY HH:MI:SS'),'DD-MON-YYYY HH:MI:SS'))*/)
          ,wol_act_cost = lv_claim_value
          ,wol_est_labour = (SELECT  SUM(boq_act_labour)
                               FROM  boq_items
                              WHERE  boq_wol_id = wol_id)
          ,wol_invoice_status = maiwo.wol_invoice_status(wol_id)
      WHERE  wol_id = wol_rec.icwol_wol_id;

      UPDATE interface_claims_boq
      SET    icboq_status = NULL
      WHERE  icboq_status = 'P'
      AND    icboq_wol_id = wol_rec.icwol_wol_id
    AND    icboq_con_claim_ref = wol_rec.icwor_con_claim_ref
    AND    icboq_con_id = wol_rec.icwor_con_id
      AND    icboq_ih_id = p_ih_id;

      UPDATE interface_claims_wol
      SET    icwol_status = NULL
      WHERE  icwol_wol_id = wol_rec.icwol_wol_id
      AND    icwol_con_claim_ref = wol_rec.icwor_con_claim_ref
    AND    icwol_con_id = wol_rec.icwor_con_id
      AND    icwol_ih_id = p_ih_id
      AND    icwol_status = 'P'
      AND    NOT EXISTS ( SELECT 1
                  FROM   interface_claims_boq
                  WHERE  icboq_wol_id = icwol_wol_id
                  AND    icboq_con_claim_ref = icwol_con_claim_ref
                  AND    icboq_con_id = icwol_con_id
                  AND    icboq_ih_id = p_ih_id );

    END LOOP;

-- write financial debit transaction check record
    IF UTL_FILE.IS_OPEN(l_fhand) THEN

      UTL_FILE.PUT_LINE(l_fhand, '10,'||TO_CHAR(l_no_of_recs)||','||LTRIM(TO_CHAR(l_total_value,'9999999990.00')));
      UTL_FILE.FFLUSH(l_fhand);
      UTL_FILE.FCLOSE(l_fhand);

    ELSE
      RAISE invalid_file;
    END IF;

    UPDATE work_orders
    SET   (wor_est_labour
        ,wor_act_cost
        ,wor_act_balancing_sum
        ,wor_date_closed
        ,wor_closed_by_id) = (SELECT DISTINCT        -- incase duplicate WOs in file
                           SUM(wol_est_labour)
                          ,SUM(wol_act_cost)
                          ,maiwo.bal_sum(SUM(wol_act_cost), oun_cng_disc_group)
                          ,DECODE(g_multifinal, 'N', DECODE(wor_date_closed, NULL, DECODE(maiwo.works_order_complete(wor_works_order_no),
                                                                                          'TRUE', NVL(MAX(wol_date_complete), SYSDATE), NULL), 
																				   wor_date_closed)
                                                   , DECODE(maiwo.works_order_complete(wor_works_order_no),
                                                            'TRUE', NVL(MAX(wol_date_complete), SYSDATE), NULL) )      
                          ,DECODE(wor_date_closed, NULL, l_user_id, wor_closed_by_id)
                      FROM   work_order_lines
                          ,interface_claims_wor
                          ,org_units
                          ,contracts
                      WHERE  wol_works_order_no = wor_works_order_no
                      AND    icwor_works_order_no = wor_works_order_no
                      AND    icwor_ih_id = p_ih_id
                      AND       icwor_status = 'P'
                      AND    con_id = wor_con_id
                      AND    con_contr_org_id = oun_org_id
                      GROUP BY
                           oun_cng_disc_group
                          ,icwor_con_claim_ref
                          ,icwor_con_id)
    WHERE  wor_works_order_no IN (SELECT icwor_works_order_no
                         FROM   interface_claims_wor
                        WHERE  icwor_ih_id = p_ih_id
                        AND    icwor_status = 'P');

    UPDATE interface_claims_wor
    SET    icwor_status = NULL
    WHERE  icwor_status = 'P'
    AND    icwor_ih_id = p_ih_id
    AND    NOT EXISTS ( SELECT 1
                  FROM   interface_claims_wol
                  WHERE  icwol_con_claim_ref = icwor_con_claim_ref
                AND    icwol_con_id = icwor_con_id
                  AND    icwol_ih_id = p_ih_id );

    SELECT COUNT(0)
    INTO   l_count
    FROM   interface_claims_wor
    WHERE  icwor_ih_id = p_ih_id;

    IF l_count = 0 THEN
      SELECT COUNT(0)
      INTO   l_count
      FROM   interface_erroneous_records
      WHERE  ier_ih_id = p_ih_id;
    END IF;

    IF l_count = 0 THEN            -- if no child records exist
      UPDATE interface_headers    -- archive the header record
      SET    ih_status = NULL
      WHERE  ih_id = p_ih_id;
    END IF;

    COMMIT;

    EXCEPTION

      WHEN invalid_file OR utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
        p_error := l_file_not_found;

      WHEN no_data_found THEN  -- end of file
        UTL_FILE.FCLOSE(l_fhand);

      WHEN others THEN
        p_error := SQLERRM;

END;

---------------------------------------------------------------------
-- Processes valid Claim data into Highways Maintenance Manager
-- tables.
-- same as claim_file_ph2 but doesn't write a file out.
--

PROCEDURE claim_file_ph3(p_ih_id IN  interface_headers.ih_id%TYPE
                ,p_file  OUT varchar2
                ,p_error OUT varchar2) IS

  CURSOR usr_id IS
    SELECT hus_user_id
    FROM   hig_users
    WHERE  hus_username = USER;

  CURSOR wols IS
    SELECT icwol_defect_id
        ,icwol_schd_id
        ,icwol_wol_id
        ,icwol_date_complete
        ,icwor_works_order_no
        ,icwor_claim_type
        ,icwor_claim_date
        ,icwor_con_claim_ref
        ,icwor_con_id
        ,icwol_claim_value
        ,oun_unit_code
        ,wol_icb_work_code
    FROM   interface_claims_wol
        ,interface_claims_wor
        ,contracts
        ,org_units
        ,work_order_lines
    WHERE  oun_org_id = con_contr_org_id
    AND    con_id = icwor_con_id
    AND    icwol_wol_id = wol_id
    AND    icwol_status = 'P'
    AND    icwol_ih_id = p_ih_id
    AND    icwor_ih_id = icwol_ih_id
    AND    icwor_con_claim_ref = icwol_con_claim_ref
    AND    icwor_con_id = icwol_con_id
    AND    icwor_status = 'P';

  CURSOR boqs (p_wol_id         interface_claims_wol.icwol_wol_id%TYPE
          ,p_con_claim_ref interface_claims_wol.icwol_con_claim_ref%TYPE
          ,p_con_id         interface_claims_wol.icwol_con_id%TYPE) IS
    SELECT *
    FROM   interface_claims_boq
    WHERE  icboq_ih_id = p_ih_id
    AND    icboq_con_claim_ref = p_con_claim_ref
    AND    icboq_con_id = p_con_id
    AND    icboq_wol_id = p_wol_id
    AND    icboq_status = 'P';

  CURSOR neg_boqs (p_wol_id    boq_items.boq_wol_id%TYPE
            ,p_item_code boq_items.boq_sta_item_code%TYPE) IS
    SELECT boq_act_quantity
        ,ROWID
    FROM   boq_items
    WHERE  boq_wol_id = p_wol_id
    AND    boq_sta_item_code = p_item_code;

  CURSOR boq_id IS
    SELECT boq_id_seq.NEXTVAL
    FROM dual;

  l_boq_id_seq        number;
  l_user_id            hig_users.hus_user_id%TYPE;
  l_wol_not_done_status    hig_status_codes.hsc_status_code%TYPE;
  l_wol_interim_status    hig_status_codes.hsc_status_code%TYPE;
  l_count            number;
  l_quantity        boq_items.boq_act_quantity%TYPE;
  l_rowid            ROWID;
  l_no_of_recs        number(7) := 0;
  l_total_value        number := 0;
  l_cost_code        budgets.bud_cost_code%TYPE;
  l_fhand            utl_file.file_type;        -- financial debit file
  l_seq_no            varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,'', '', 'FD');
  l_filename        varchar2(12) := 'FD'||TO_CHAR(l_seq_no)||'.'||'DAT';
  l_today            date := SYSDATE;
  l_header_record        varchar2(30) := '00,'||TO_CHAR(l_seq_no)||','||
                        TO_CHAR(l_today, g_date_format)||','||TO_CHAR(l_today, g_time_format);
  l_file_not_found     varchar2(250) := 'Error: Unable to write Financial Debit File. Path: '||g_filepath||'  File: '||l_filename;
  invalid_file        EXCEPTION;
  l_fyr_id            financial_years.fyr_id%TYPE; 
  l_wol_date_complete   work_order_lines.wol_date_complete%TYPE;

BEGIN

  OPEN usr_id;
  FETCH usr_id INTO l_user_id;
  CLOSE usr_id;

  BEGIN

    SELECT hsc_status_code
    INTO   l_wol_not_done_status
    FROM   hig_status_codes
    WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
    AND    hsc_allow_feature5 = 'Y'
    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

    EXCEPTION
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 275));
      WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 276));

  END;

  BEGIN

    SELECT hsc_status_code
    INTO   l_wol_interim_status
    FROM   hig_status_codes
    WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
--    And    hsc_allow_feature6 = 'Y'
--removal of interface only status codes. Trying to bring interfaces inline with MM.-sm 14-01-03
    AND    hsc_allow_feature9 = 'Y'
    AND    hsc_allow_feature4 = 'N'
    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

    EXCEPTION        -- need to add these messages to errors table
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001, '> 1 interim work order line status code exists');
      WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20001, 'No interim work order line status code exists');

  END;

-- write financial debit transaction header record
--   l_fhand := UTL_FILE.FOPEN(g_filepath, l_filename, 'w');
--   IF UTL_FILE.IS_OPEN(l_fhand) THEN
--     UTL_FILE.PUT_LINE(l_fhand, l_header_record);
--     p_file := 'Financial Debit File '||l_filename||' created in '||g_filepath;
--   ELSE
--     RAISE invalid_file;
--   END IF;

  INSERT INTO work_order_claims (
         woc_claim_ref
        ,woc_con_id
        ,woc_claim_type
        ,woc_claim_date
        ,woc_claim_value
        ,woc_works_order_no
        ,woc_interim_no)
  SELECT     icwor_con_claim_ref
        ,icwor_con_id
        ,icwor_claim_type
        ,icwor_claim_date
        ,icwor_claim_value
        ,icwor_works_order_no
        ,icwor_interim_no
  FROM     interface_claims_wor
  WHERE      icwor_status = 'P'
  AND         icwor_ih_id = p_ih_id
  AND         NOT EXISTS (SELECT 1                -- for when reprocessing existing invoices
                 FROM   work_order_claims    -- ie. for previously held or rejected records
                 WHERE  woc_claim_ref = icwor_con_claim_ref
                 AND    woc_con_id = icwor_con_id);

  INSERT INTO claim_payments (
         cp_woc_claim_ref
        ,cp_woc_con_id
        ,cp_wol_id
        ,cp_status
        ,cp_claim_value)
  SELECT     icwor_con_claim_ref
        ,icwor_con_id
        ,icwol_wol_id
        ,DECODE(get_woc_claim_type(icwor_con_claim_ref, icwor_con_id),'P','H',hop_value)
        ,icwol_claim_value
  FROM     hig_options
        ,interface_claims_wol
        ,interface_claims_wor
  WHERE     hop_id = 'CLAIMDEF'
  AND     icwor_ih_id = p_ih_id
  AND     icwor_status = 'P'
  AND     icwor_con_claim_ref = icwol_con_claim_ref
  AND      icwor_con_id = icwol_con_id
  AND     icwol_ih_id = icwor_ih_id
  AND     icwol_status = 'P';

  FOR wol_rec IN wols LOOP

-- write financial debit transaction debit record
--       IF UTL_FILE.IS_OPEN(l_fhand) THEN
--
--       OPEN cost_code(wol_rec.icwol_wol_id);
--       FETCH cost_code INTO l_cost_code;
--       CLOSE cost_code;
--
--         UTL_FILE.PUT_LINE(l_fhand, '05,'||TO_CHAR(wol_rec.icwor_claim_date, g_date_format)||','||
--                   wol_rec.icwor_con_claim_ref||','||wol_rec.icwor_works_order_no||','||
--                   TO_CHAR(wol_rec.icwol_wol_id)||','||TO_CHAR(wol_rec.icwol_defect_id)||','||
--                   TO_CHAR(wol_rec.icwol_schd_id)||','||wol_rec.oun_unit_code||','||
--                   LTRIM(TO_CHAR(wol_rec.icwol_claim_value,'9999999990.00'))||','||wol_rec.wol_icb_work_code||','||
--                   l_cost_code||','||l_fyr_id);
--
--         l_no_of_recs := l_no_of_recs + 1;
--         l_total_value := l_total_value + wol_rec.icwol_claim_value;
--
--       ELSE
--         RAISE invalid_file;
--       END IF;

      IF wol_rec.icwor_claim_type = 'F' AND  -- not necessary for Post or Interim claims
         wol_rec.icwol_defect_id IS NOT NULL THEN -- skip for non defect WOLs

        --maiwo.update_defect_date(  wol_rec.icwol_defect_id
        update_defect_date(wol_rec.icwol_defect_id
                          ,wol_rec.icwol_date_complete
                          ,wol_rec.icwor_works_order_no);

      UPDATE defects
      SET    def_status_code = (SELECT MAX(hsc_status_code)
                        FROM   hig_status_codes
                                  WHERE  hsc_allow_feature4 = 'Y'
                                  AND    hsc_domain_code = 'DEFECTS'
                        AND    g_today BETWEEN NVL(hsc_start_date, g_today)
                             AND NVL(hsc_end_date, g_today))
          ,def_last_updated_date = SYSDATE
      WHERE  NOT EXISTS (SELECT 1
                           FROM   repairs
                           WHERE  rep_def_defect_id = def_defect_id
                           AND    rep_date_completed IS NULL)
      AND       def_defect_id = wol_rec.icwol_defect_id;

      END IF;

      IF wol_rec.icwor_claim_type IN ('F', 'I') THEN -- not necessariy for Post claims

      -- set the actuals of all BoQs on current WOL to zero

        UPDATE boq_items
        SET    boq_act_dim1 = 0
              ,boq_act_dim2 = DECODE(boq_est_dim2, NULL, NULL, 0)
              ,boq_act_dim3 = DECODE(boq_est_dim3, NULL, NULL, 0)
              --,boq_act_rate = 0                            -- Task 0109687 
              ,boq_act_rate = NVL(boq_act_rate,boq_est_rate) -- Task 0109687 copied the estimated rate into the actual if actual is null, instead of zero
              ,boq_act_quantity = 0
              ,boq_act_cost = 0
              ,boq_act_labour = 0
              ,boq_act_discount = 0
        WHERE  boq_wol_id = wol_rec.icwol_wol_id;

      END IF;

      FOR boq_rec IN boqs(wol_rec.icwol_wol_id
                         ,wol_rec.icwor_con_claim_ref
                         ,wol_rec.icwor_con_id) LOOP

        IF wol_rec.icwor_claim_type IN ('F', 'I') THEN -- not necessariy for Post claims

      -- set actuals of first matching BoQ that hasn't already been updated
       IF hig.get_sysopt('XTRIFLDS') IN ('2-1-3', '2-4-0') THEN
          UPDATE boq_items
          SET    (boq_act_dim1
                 ,boq_act_dim2
                 ,boq_act_dim3) = (SELECT NVL(boq_rec.icboq_dim1, DECODE(sta_dim1_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, NULL, 1))
                                          FROM standard_items
                                              ,boq_items
                                          WHERE sta_item_code = boq_rec.icboq_sta_item_code
                                          AND boq_sta_item_code = sta_item_code
                                          AND boq_act_cost = 0
                                          AND boq_wol_id = wol_rec.icwol_wol_id
                                          AND ROWNUM = 1)
                ,boq_act_rate = boq_rec.icboq_rate
                ,boq_act_quantity = boq_rec.icboq_quantity
                ,boq_act_cost = boq_rec.icboq_cost
                ,boq_act_labour = (SELECT ROUND(MAX(boq_rec.icboq_quantity * sta_labour_units), 2)
                                   FROM   standard_items
                                   WHERE  sta_item_code = boq_rec.icboq_sta_item_code)
                ,boq_act_discount = boq_est_discount
                ,boq_item_name = DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc)
          WHERE  boq_wol_id = wol_rec.icwol_wol_id
          AND    boq_sta_item_code = boq_rec.icboq_sta_item_code
          AND    boq_id = boq_rec.icboq_boq_id
          AND    boq_act_cost = 0
          AND    ROWNUM = 1;
        ELSE
          UPDATE boq_items
          SET    (boq_act_dim1
                 ,boq_act_dim2
                 ,boq_act_dim3) = (SELECT NVL(boq_rec.icboq_dim1, DECODE(sta_dim1_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, NULL, 1))
                                         ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, NULL, 1))
                                          FROM standard_items
                                              ,boq_items
                                          WHERE sta_item_code = boq_rec.icboq_sta_item_code
                                          AND boq_sta_item_code = sta_item_code
                                          AND boq_act_cost = 0
                                          AND boq_wol_id = wol_rec.icwol_wol_id
                                          AND ROWNUM = 1)
                ,boq_act_rate = boq_rec.icboq_rate
                ,boq_act_quantity = boq_rec.icboq_quantity
                ,boq_act_cost = boq_rec.icboq_cost
                ,boq_act_labour = (SELECT ROUND(MAX(boq_rec.icboq_quantity * sta_labour_units), 2)
                                   FROM   standard_items
                                   WHERE  sta_item_code = boq_rec.icboq_sta_item_code)
                ,boq_act_discount = boq_est_discount
          WHERE  boq_wol_id = wol_rec.icwol_wol_id
          AND    boq_sta_item_code = boq_rec.icboq_sta_item_code
          AND    boq_act_cost = 0
          AND    ROWNUM = 1;
        END IF;
--
        END IF;

      -- if no matching item exists or claim type is Post (and not a credit) then create one

        IF SQL%rowcount = 0 OR (wol_rec.icwor_claim_type = 'P' AND boq_rec.icboq_quantity >= 0) THEN
       IF hig.get_sysopt('XTRIFLDS') IN ('2-1-3', '2-4-0') THEN
        IF SIGN(boq_rec.icboq_boq_id) = -1 THEN
          IF boq_rec.icboq_parent_boq_id IS NOT NULL THEN
            g_parent_boq_id_seq := g_boq_id_seq;
          ELSE
            g_parent_boq_id_seq := NULL;
          END IF;
            OPEN boq_id;
            FETCH boq_id INTO g_boq_id_seq;
            CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id
            ,boq_parent_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc, sta_item_name),',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
                    ,g_boq_id_seq
            ,g_parent_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
        ELSE
        OPEN boq_id;
        FETCH boq_id INTO l_boq_id_seq;
        CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(DECODE(boq_rec.icboq_rogue_item, 'R', boq_rec.icboq_rogue_item_desc, sta_item_name),',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
            ,l_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
        END IF;
        ELSE
        OPEN boq_id;
        FETCH boq_id INTO l_boq_id_seq;
        CLOSE boq_id;
          INSERT INTO boq_items (
             boq_work_flag
            ,boq_defect_id
            ,boq_rep_action_cat
            ,boq_wol_id
            ,boq_sta_item_code
            ,boq_item_name
            ,boq_date_created
            ,boq_icb_work_code
            ,boq_est_dim1
            ,boq_est_dim2
            ,boq_est_dim3
            ,boq_est_quantity
            ,boq_est_rate
            ,boq_est_discount
            ,boq_est_cost
            ,boq_est_labour
            ,boq_act_dim1
            ,boq_act_dim2
            ,boq_act_dim3
            ,boq_act_quantity
            ,boq_act_cost
            ,boq_act_labour
            ,boq_act_rate
            ,boq_act_discount
            ,boq_id)
          SELECT      DECODE(wol_def_defect_id, NULL, 'O', 'D')
            ,DECODE(wol_def_defect_id, NULL, 0, wol_def_defect_id)
            ,DECODE(wol_rep_action_cat, NULL, 'X', wol_rep_action_cat)
            ,wol_id
            ,boq_rec.icboq_sta_item_code
            ,REPLACE(sta_item_name,',','~')
            ,SYSDATE
            ,''
            ,0
            ,DECODE(sta_dim2_text, NULL, '', 0)
            ,DECODE(sta_dim3_text, NULL, '', 0)
            ,0
            ,0
            ,''
            ,0
            ,0
            ,boq_rec.icboq_dim1
            ,NVL(boq_rec.icboq_dim2, DECODE(sta_dim2_text, NULL, '', 1))
            ,NVL(boq_rec.icboq_dim3, DECODE(sta_dim3_text, NULL, '', 1))
            ,boq_rec.icboq_quantity
            ,boq_rec.icboq_cost
            ,ROUND((boq_rec.icboq_quantity * sta_labour_units), 2)
            ,boq_rec.icboq_rate
            ,''
            ,l_boq_id_seq
          FROM     standard_items
            ,work_order_lines
          WHERE     sta_item_code = boq_rec.icboq_sta_item_code
          AND       wol_id = wol_rec.icwol_wol_id;
          END IF;
    -- handle negative claims ie. credits
        ELSIF wol_rec.icwor_claim_type = 'P' AND boq_rec.icboq_quantity < 0 THEN

        OPEN neg_boqs(wol_rec.icwol_wol_id
                 ,boq_rec.icboq_sta_item_code);
        LOOP

          FETCH neg_boqs INTO l_quantity
                       ,l_rowid;
          EXIT WHEN neg_boqs%NOTFOUND;

          IF l_quantity + boq_rec.icboq_quantity < 0 THEN
          boq_rec.icboq_quantity := boq_rec.icboq_quantity + l_quantity;
          l_quantity := 0;
          ELSE
          l_quantity := l_quantity + boq_rec.icboq_quantity;
          boq_rec.icboq_quantity := 0;
          END IF;

          UPDATE boq_items
          SET    boq_act_dim1 = l_quantity
               ,(boq_act_dim2
                ,boq_act_dim3) = (SELECT DECODE(sta_dim2_text, NULL, NULL, DECODE(l_quantity, 0, 0, 1))
                                        ,DECODE(sta_dim3_text, NULL, NULL, DECODE(l_quantity, 0, 0, 1))
                                         FROM standard_items sta,
                                              boq_items boq
                                         WHERE boq.boq_sta_item_code = sta.sta_item_code
                                         AND boq.ROWID = l_rowid)
                ,boq_act_quantity = l_quantity
                ,boq_act_rate = DECODE(l_quantity, 0, 0, boq_act_rate)
                ,boq_act_cost = ROUND((l_quantity * boq_act_rate), 2)
                 WHERE  ROWID = l_rowid;

          EXIT WHEN boq_rec.icboq_quantity = 0;

        END LOOP;
        CLOSE neg_boqs;

        END IF;

      END LOOP;

      maiwo.adjust_contract_figures(wol_rec.icwol_wol_id
                         ,wol_rec.icwor_con_id
                         ,'+');

IF wol_rec.icwor_claim_type != 'I' THEN
  l_wol_date_complete := TO_DATE(TO_CHAR(wol_rec.icwol_date_complete, 'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS');
ELSE
  l_wol_date_complete := null;  --SM 15042998 - 707188 - Resetting the l_wol_date_complete to null should mean that the completion date doesn't get updated if the file contains both I and F files.  
END IF;

      UPDATE work_order_lines
      SET    wol_status_code = DECODE(wol_rec.icwor_claim_type, 'F',
                          g_wol_comp_status, 'I',
                          l_wol_interim_status, wol_status_code)
            ,wol_date_complete = DECODE(wol_rec.icwor_claim_type, 'P',TO_DATE(TO_CHAR(wol_date_complete, 'DD-MON-YYYY HH24:MI:SS'),'DD-MON-YYYY HH24:MI:SS')
                                       ,l_wol_date_complete/*Decode(wol_rec.icwor_claim_type,'I',null,to_date(to_char(wol_rec.icwol_date_complete, 'DD-MON-YYYY HH:MI:SS'),'DD-MON-YYYY HH:MI:SS'))*/)
          ,(wol_act_cost
          ,wol_est_labour) = (SELECT SUM(boq_act_cost)
                          ,SUM(boq_act_labour)
                      FROM   boq_items
                        WHERE  boq_wol_id = wol_id)
          ,wol_invoice_status = maiwo.wol_invoice_status(wol_id)
      WHERE  wol_id = wol_rec.icwol_wol_id;

      UPDATE interface_claims_boq
      SET    icboq_status = NULL
      WHERE  icboq_status = 'P'
      AND    icboq_wol_id = wol_rec.icwol_wol_id
    AND    icboq_con_claim_ref = wol_rec.icwor_con_claim_ref
    AND    icboq_con_id = wol_rec.icwor_con_id
      AND    icboq_ih_id = p_ih_id;

      UPDATE interface_claims_wol
      SET    icwol_status = NULL
      WHERE  icwol_wol_id = wol_rec.icwol_wol_id
      AND    icwol_con_claim_ref = wol_rec.icwor_con_claim_ref
    AND    icwol_con_id = wol_rec.icwor_con_id
      AND    icwol_ih_id = p_ih_id
      AND    icwol_status = 'P'
      AND    NOT EXISTS ( SELECT 1
                  FROM   interface_claims_boq
                  WHERE  icboq_wol_id = icwol_wol_id
                  AND    icboq_con_claim_ref = icwol_con_claim_ref
                  AND    icboq_con_id = icwol_con_id
                  AND    icboq_ih_id = p_ih_id );

    END LOOP;

-- write financial debit transaction check record
--     IF UTL_FILE.IS_OPEN(l_fhand) THEN
--
--       UTL_FILE.PUT_LINE(l_fhand, '10,'||TO_CHAR(l_no_of_recs)||','||LTRIM(TO_CHAR(l_total_value,'9999999990.00')));
--       UTL_FILE.FFLUSH(l_fhand);
--       UTL_FILE.FCLOSE(l_fhand);
--
--     ELSE
--       RAISE invalid_file;
--     END IF;

    UPDATE work_orders
    SET   (wor_est_labour
        ,wor_act_cost
        ,wor_act_balancing_sum
        ,wor_date_closed
        ,wor_closed_by_id) = (SELECT DISTINCT        -- incase duplicate WOs in file
                           SUM(wol_est_labour)
                          ,SUM(wol_act_cost)
                          ,maiwo.bal_sum(SUM(wol_act_cost), oun_cng_disc_group)
                          ,DECODE(wor_date_closed, NULL,
                           DECODE(maiwo.works_order_complete(wor_works_order_no),
                          'TRUE', NVL(MAX(wol_date_complete), SYSDATE), NULL), wor_date_closed)
                          ,DECODE(wor_date_closed, NULL, l_user_id, wor_closed_by_id)
                      FROM   work_order_lines
                          ,interface_claims_wor
                          ,org_units
                          ,contracts
                      WHERE  wol_works_order_no = wor_works_order_no
                      AND    icwor_works_order_no = wor_works_order_no
                      AND    icwor_ih_id = p_ih_id
                      AND       icwor_status = 'P'
                      AND    con_id = wor_con_id
                      AND    con_contr_org_id = oun_org_id
                      GROUP BY
                           oun_cng_disc_group
                          ,icwor_con_claim_ref
                          ,icwor_con_id)
    WHERE  wor_works_order_no IN (SELECT icwor_works_order_no
                         FROM   interface_claims_wor
                        WHERE  icwor_ih_id = p_ih_id
                        AND    icwor_status = 'P');

    UPDATE interface_claims_wor
    SET    icwor_status = NULL
    WHERE  icwor_status = 'P'
    AND    icwor_ih_id = p_ih_id
    AND    NOT EXISTS ( SELECT 1
                  FROM   interface_claims_wol
                  WHERE  icwol_con_claim_ref = icwor_con_claim_ref
                AND    icwol_con_id = icwor_con_id
                  AND    icwol_ih_id = p_ih_id );

    SELECT COUNT(0)
    INTO   l_count
    FROM   interface_claims_wor
    WHERE  icwor_ih_id = p_ih_id;

    IF l_count = 0 THEN
      SELECT COUNT(0)
      INTO   l_count
      FROM   interface_erroneous_records
      WHERE  ier_ih_id = p_ih_id;
    END IF;

    IF l_count = 0 THEN            -- if no child records exist
      UPDATE interface_headers    -- archive the header record
      SET    ih_status = NULL
      WHERE  ih_id = p_ih_id;
    END IF;

    COMMIT;

    EXCEPTION

      WHEN invalid_file OR utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
        p_error := l_file_not_found;

      WHEN no_data_found THEN  -- end of file
        UTL_FILE.FCLOSE(l_fhand);

      WHEN others THEN
        p_error := SQLERRM;

END;


---------------------------------------------------------------------
-- Check claimed values of all WOLs on a Final or Interim claims
-- against any tolerance entered

FUNCTION tolerance_exceeded(p_ih_id        IN interface_headers.ih_id%TYPE
                   ,p_tol_percent    IN number
                   ,p_tol_value    IN number) RETURN boolean IS

  CURSOR c1 IS
  SELECT icwol_error, wol_act_cost, wol_est_cost
  FROM   interface_claims_wol,
           work_order_lines
  WHERE  EXISTS ( SELECT 1
              FROM   work_order_lines
                  ,interface_claims_wor
              WHERE  ABS((icwol_claim_value + DECODE(icwor_claim_type, 'P', NVL(wol_act_cost, 0), 0))
                 - NVL(wol_act_cost, DECODE(icwor_claim_type, 'P', 0, wol_est_cost))) >
                   GREATEST(NVL(p_tol_value, (NVL(wol_act_cost, wol_est_cost) * (p_tol_percent/100))),
                          NVL((NVL(wol_act_cost, wol_est_cost) * (p_tol_percent/100)), p_tol_value))
              AND       wol_id = icwol_wol_id
              AND       wol_works_order_no = icwor_works_order_no
              AND    icwor_con_claim_ref = icwol_con_claim_ref
              AND    icwor_con_id = icwol_con_id
              AND       icwor_ih_id = p_ih_id )
  AND    icwol_ih_id = p_ih_id
  AND    icwol_wol_id = wol_id;

  CURSOR c2 IS
  SELECT icwol_error
  FROM interface_claims_wol
  WHERE icwol_ih_id = p_ih_id;

  l_error interface_claims_wol.icwol_error%TYPE;
  l_error_percent varchar2(20);
  l_error_value varchar2(20);
  l_wol_act_cost work_order_lines.wol_act_cost%TYPE;
  l_wol_est_cost work_order_lines.wol_est_cost%TYPE;
  l_return boolean;

BEGIN
  OPEN c2;
  FETCH c2 INTO l_error;
  IF INSTR(l_error, 'Tolerance exceeded.') = 0 THEN
    UPDATE interface_claims_wol
    SET    icwol_error = REPLACE(icwol_error, SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),(INSTR(l_error,')')-(INSTR(l_error, 'Tolerance exceeded. ')))),'')
          ,icwol_status = 'P'
    WHERE  icwol_ih_id = p_ih_id;
  ELSE
    UPDATE interface_claims_wol
    SET    icwol_error = REPLACE(icwol_error, SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),(INSTR(l_error,')')-(INSTR(l_error, 'Tolerance exceeded. ')-1))),'')
          ,icwol_status = 'P'
    WHERE  icwol_ih_id = p_ih_id;
  END IF;
IF SQL%rowcount > 0 THEN
  validate_wo_item(p_ih_id,'WOL',18);
END IF;
/*
  Update interface_claims_wol
  Set    icwol_error = Replace(icwol_error, 'Tolerance exceeded. ','')
  Where  icwol_ih_id = p_ih_id;
*/
  COMMIT;
  CLOSE c2;

  IF p_tol_percent IS NOT NULL OR p_tol_value IS NOT NULL THEN

    UPDATE interface_claims_wol
    SET    icwol_error = SUBSTR(icwol_error||'Tolerance exceeded.', 1, 254)
          ,icwol_status = DECODE(icwol_status, 'R', 'R', 'R')
    WHERE  EXISTS ( SELECT 1
              FROM   work_order_lines
                  ,interface_claims_wor
              WHERE  ABS((icwol_claim_value + DECODE(icwor_claim_type, 'P', NVL(wol_act_cost, 0), 0))
                 - NVL(wol_act_cost, DECODE(icwor_claim_type, 'P', 0, wol_est_cost))) >
                   GREATEST(NVL(p_tol_value, (NVL(wol_act_cost, wol_est_cost) * (p_tol_percent/100))),
                          NVL((NVL(wol_act_cost, wol_est_cost) * (p_tol_percent/100)), p_tol_value))
              AND       wol_id = icwol_wol_id
              AND       wol_works_order_no = icwor_works_order_no
              AND    icwor_con_claim_ref = icwol_con_claim_ref
              AND    icwor_con_id = icwol_con_id
              AND       icwor_ih_id = p_ih_id )
    AND    icwol_ih_id = p_ih_id;

    IF SQL%rowcount > 0 THEN
      validate_wo_item(p_ih_id,'WOL',19);
      COMMIT;
      l_return := TRUE;
    ELSE
      validate_claim_data(p_ih_id);--validate other records because tolerance was not exceeded and did not fail.
      l_return := FALSE;
    END IF;

  OPEN c1;
  FETCH c1 INTO l_error, l_wol_act_cost, l_wol_est_cost;
    IF c1%NOTFOUND THEN
      NULL;
    ELSE
    IF NVL(p_tol_value,0)
     > NVL(NVL(l_wol_act_cost, l_wol_est_cost) * (p_tol_percent/100),0) THEN
       IF INSTR(l_error, 'Tolerance exceeded.') > 0 THEN
        IF INSTR(l_error, 'Tolerance exceeded.(') > 0 THEN --tolerance has been exceeded and a value is displayed
          IF INSTR(l_error, '%') > 0 THEN --tolerance currently displayed is percentage
            l_error_percent := SUBSTR(l_error, '(',(INSTR(l_error, '%')-1));
              UPDATE interface_claims_wol
              SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')-1)||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),20)||
                                '('||p_tol_value||') '||
                                SUBSTR(l_error,INSTR(l_error, '%')+1,LENGTH(l_error)))

              WHERE icwol_ih_id = p_ih_id;
          ELSE --tolerance currently displayed is a value
            l_error_value := SUBSTR(l_error, '(',(INSTR(l_error, ')')-1));
            IF l_error_value != p_tol_value THEN
              UPDATE interface_claims_wol
              SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')-1)||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),20)||
                                '('||p_tol_value||') '||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.')+20,LENGTH(l_error)))
              WHERE icwol_ih_id = p_ih_id;
            END IF;
          END IF;
        ELSE --tolerance has been exceeded but the value has not been displayed.
          UPDATE interface_claims_wol
          SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')-1)||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),20)||
                                '('||p_tol_value||') '||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.')+20,LENGTH(l_error)))
          WHERE icwol_ih_id = p_ih_id;
        END IF;
      END IF;
    ELSE
       IF INSTR(l_error, 'Tolerance exceeded.') > 0 THEN
        IF INSTR(l_error, 'Tolerance exceeded.(') > 0 THEN --tolerance has been exceeded and a value is displayed
          IF INSTR(l_error, '%') > 0 THEN --tolerance currently displayed is percentage
            l_error_percent := SUBSTR(l_error, '(',(INSTR(l_error, '%')-1));
            IF l_error_percent != p_tol_percent THEN
              UPDATE interface_claims_wol
              SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')+20)||
                                '('||p_tol_percent||'%) '||
                                SUBSTR(l_error,INSTR(l_error, '%')+1,LENGTH(l_error)))
              WHERE icwol_ih_id = p_ih_id;
            END IF;
          ELSE --tolerance currently displayed is a value
            l_error_value := SUBSTR(l_error, '(',(INSTR(l_error, ')')-1));
            IF l_error_value != p_tol_value THEN
              UPDATE interface_claims_wol
              SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')-1)||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.'),20)||
                                '('||p_tol_percent||'%) '||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.')+20,LENGTH(l_error)))
              WHERE icwol_ih_id = p_ih_id;
            END IF;
          END IF;
        ELSE --tolerance has been exceeded but the value has not been displayed.
          UPDATE interface_claims_wol
          SET icwol_error = (SUBSTR(l_error,1,INSTR(l_error, 'Tolerance exceeded.')+20)||
                                '('||p_tol_percent||'%) '||
                                SUBSTR(l_error,INSTR(l_error, 'Tolerance exceeded.')+20,LENGTH(l_error)))
          WHERE icwol_ih_id = p_ih_id;
        END IF;
      END IF;
    END IF;
    END IF;
    CLOSE c1;

    IF SQL%rowcount > 0 THEN
      validate_wo_item(p_ih_id,'WOL',19);
      COMMIT;
    END IF;

    IF l_return THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;

  ELSE
    RETURN FALSE;
  END IF;

END;
---------------------------------------------------------------------
-- Called from the claims form. This procedure creates a file
-- containing all the Held and Rejected records for a particular
-- claim or completion file.
--

PROCEDURE create_referral_file(p_ih_id     IN interface_headers.ih_id%TYPE
                    ,p_filename IN OUT varchar2
                  ,p_error IN OUT varchar2) IS

  CURSOR c1 IS
    SELECT ih_contractor_id
        ,ih_status
    FROM   interface_headers
    WHERE  ih_id = p_ih_id;

  CURSOR HEADER IS
    SELECT '05,'||ih_status||','||icwor_con_claim_ref||','||
        icwor_works_order_no||','||TO_CHAR(icwol_wol_id)||','||
        icwol_defect_id||','||icwol_schd_id||','||
        LTRIM(TO_CHAR(icwol_claim_value,'9999999990.00'))||','||
        ih_error referred_record
           ,icwor.ROWID icwor_rowid
         ,icwor_con_claim_ref
         ,icwor_con_id
           ,icwol_wol_id
         ,icwol_claim_value
         ,ih_status
    FROM    interface_headers
         ,interface_claims_wor icwor
         ,interface_claims_wol
    WHERE   ih_status IN ('R','H')
    AND     ih_id = p_ih_id
    AND     icwor_ih_id = ih_id
    AND     icwol_ih_id = icwor_ih_id
    AND     icwol_con_claim_ref = icwor_con_claim_ref
    AND     icwol_con_id = icwor_con_id;

  CURSOR icwor IS
    SELECT '05,'||icwor_status||','||icwor_con_claim_ref||','||
        icwor_works_order_no||','||TO_CHAR(icwol_wol_id)||','||
        icwol_defect_id||','||icwol_schd_id||','||
        LTRIM(TO_CHAR(icwol_claim_value,'9999999990.00'))||','||
        icwor_error referred_record
           ,icwor.ROWID icwor_rowid
         ,icwor_con_claim_ref
         ,icwor_con_id
           ,icwol_wol_id
         ,icwol_claim_value
         ,icwor_status
    FROM    interface_claims_wor icwor
         ,interface_claims_wol
    WHERE   icwor_status IN ('R','H')
    AND     icwor_ih_id = p_ih_id
    AND     icwol_ih_id = icwor_ih_id
    AND     icwol_con_claim_ref = icwor_con_claim_ref
    AND     icwol_con_id = icwor_con_id;

  CURSOR icwol IS
    SELECT '05,'||icwol_status||','||icwor_con_claim_ref||','||
        icwor_works_order_no||','||TO_CHAR(icwol_wol_id)||','||
        icwol_defect_id||','||icwol_schd_id||','||
        LTRIM(TO_CHAR(icwol_claim_value,'9999999990.00'))||','||
        icwol_error referred_record
           ,icwor.ROWID icwor_rowid
         ,icwor_con_claim_ref
         ,icwor_con_id
           ,icwol_wol_id
         ,icwol_claim_value
         ,icwol_status
    FROM    interface_claims_wor icwor
         ,interface_claims_wol
    WHERE   icwol_status IN ('R','H')
    AND     icwor_status = 'P'
    AND     icwor_ih_id = p_ih_id
    AND     icwol_ih_id = icwor_ih_id
    AND     icwol_con_claim_ref = icwor_con_claim_ref
    AND     icwol_con_id = icwor_con_id;

  CURSOR icboq IS
    SELECT '05,'||icboq_status||','||icwor_con_claim_ref||','||
        icwor_works_order_no||','||TO_CHAR(icwol_wol_id)||','||
        icwol_defect_id||','||icwol_schd_id||','||
        LTRIM(TO_CHAR(icwol_claim_value,'9999999990.00'))||','||
        icboq_error referred_record
           ,icwor.ROWID icwor_rowid
         ,icwor_con_claim_ref
         ,icwor_con_id
           ,icwol_wol_id
         ,icwol_claim_value
         ,icboq_status
    FROM    interface_claims_wor icwor
         ,interface_claims_wol
         ,interface_claims_boq
    WHERE   icwol_status = 'P'
    AND     icwor_status = 'P'
    AND     icboq_status IN ('R', 'H')
    AND     icwor_ih_id = p_ih_id
    AND     icwol_ih_id = icwor_ih_id
    AND     icwol_con_claim_ref = icwor_con_claim_ref
    AND     icwol_con_id = icwor_con_id
    AND     icboq_ih_id = icwol_ih_id
    AND     icboq_con_claim_ref = icwol_con_claim_ref
    AND    icboq_con_id = icwol_con_id
    AND     icboq_wol_id = icwol_wol_id;

  TYPE referral_record IS REF CURSOR RETURN HEADER%ROWTYPE;
  l_referral_rec    referral_record;
  l_today        date := SYSDATE;
  l_fhand        utl_file.file_type;
  l_no_of_recs    number(7) := 0;
  l_total_value    number := 0;
  l_seq_no        varchar2(6);
  l_header_record    varchar2(31);
  l_contractor_id    interface_headers.ih_contractor_id%TYPE;
  l_status        interface_headers.ih_status%TYPE;
  l_rowid_copy    ROWID;
  l_wor_rowid    ROWID;
  l_file_not_found varchar2(250);

  PROCEDURE write_and_delete_record( p_referred_rec    IN varchar2
                        ,p_claim_ref    IN interface_claims_wor.icwor_con_claim_ref%TYPE
                        ,p_con_id        IN interface_claims_wol.icwol_con_id%TYPE
                        ,p_wol_id        IN interface_claims_wol.icwol_wol_id%TYPE
                        ,p_status        IN interface_claims_wor.icwor_status%TYPE) IS
  BEGIN

    UTL_FILE.PUT_LINE(l_fhand, p_referred_rec);

    IF p_status = 'R' THEN
      -- if record is Rejected then mark as Deleted
      UPDATE interface_claims_boq
      SET    icboq_status = 'D'
      WHERE  icboq_ih_id = p_ih_id
    AND    icboq_con_claim_ref = p_claim_ref
    AND    icboq_con_id = p_con_id
      AND    icboq_wol_id = p_wol_id;

      UPDATE interface_claims_wol
      SET    icwol_status = 'D'
      WHERE  icwol_ih_id = p_ih_id
      AND    icwol_con_claim_ref = p_claim_ref
    AND    icwol_con_id = p_con_id
      AND    icwol_wol_id = p_wol_id;
    END IF;

  END;

BEGIN

  OPEN c1;
  FETCH c1 INTO l_contractor_id
           ,l_status;
  CLOSE c1;

  l_seq_no := file_seq(xnhcc_interfaces.g_job_id,l_contractor_id, '', 'WR');

  p_filename := 'WR'||TO_CHAR(l_seq_no)||'.'||l_contractor_id;

  l_file_not_found := 'Error: Unable to write Referral File. Path: '||g_filepath||'  File: '||p_filename;

  l_header_record    := '00,'||l_contractor_id||','||TO_CHAR(l_seq_no)||','||
               TO_CHAR(l_today, g_date_format)||','||TO_CHAR(l_today, g_time_format);

  l_fhand := UTL_FILE.FOPEN(g_filepath, p_filename, 'w');

  IF UTL_FILE.IS_OPEN(l_fhand) THEN

    UTL_FILE.PUT_LINE(l_fhand, l_header_record);

    IF l_status IN ('H', 'R') THEN

      FOR l_referral_rec IN HEADER LOOP
        UTL_FILE.PUT_LINE(l_fhand, l_referral_rec.referred_record);
      l_no_of_recs := l_no_of_recs + 1;
        l_total_value := l_total_value + l_referral_rec.icwol_claim_value;
      END LOOP;

      IF l_status = 'R' THEN

      UPDATE interface_claims_boq
      SET    icboq_status = 'D'
      WHERE  icboq_ih_id = p_ih_id;

        UPDATE interface_claims_wol
      SET    icwol_status = 'D'
      WHERE  icwol_ih_id = p_ih_id;

        UPDATE interface_claims_wor
      SET    icwor_status = 'D'
      WHERE  icwor_ih_id = p_ih_id;

        UPDATE interface_headers
      SET    ih_status = 'D'
      WHERE  ih_id = p_ih_id;

    END IF;

    ELSE

    l_rowid_copy := NULL;

      FOR l_referral_rec IN icwor LOOP

      l_wor_rowid := l_referral_rec.icwor_rowid;

        write_and_delete_record (l_referral_rec.referred_record
                      ,l_referral_rec.icwor_con_claim_ref
                      ,l_referral_rec.icwor_con_id
                      ,l_referral_rec.icwol_wol_id
                      ,l_referral_rec.icwor_status);

        l_total_value := l_total_value + l_referral_rec.icwol_claim_value;
      l_no_of_recs := l_no_of_recs + 1;

      IF l_rowid_copy IS NULL THEN

        l_rowid_copy := l_wor_rowid;

      ELSIF l_rowid_copy != l_wor_rowid THEN

        UPDATE interface_claims_wor
        SET    icwor_status = DECODE(icwor_status, 'R', 'D', icwor_status)
        WHERE  ROWID = l_rowid_copy;

        l_rowid_copy := l_wor_rowid;

      END IF;

      END LOOP;

      UPDATE interface_claims_wor
      SET    icwor_status = DECODE(icwor_status, 'R', 'D', icwor_status)
      WHERE  ROWID = l_rowid_copy;

      FOR l_referral_rec IN icwol LOOP

        write_and_delete_record (l_referral_rec.referred_record
                      ,l_referral_rec.icwor_con_claim_ref
                      ,l_referral_rec.icwor_con_id
                      ,l_referral_rec.icwol_wol_id
                      ,l_referral_rec.icwol_status);

        l_total_value := l_total_value + l_referral_rec.icwol_claim_value;
      l_no_of_recs := l_no_of_recs + 1;

      END LOOP;

      FOR l_referral_rec IN icboq LOOP

        write_and_delete_record (l_referral_rec.referred_record
                      ,l_referral_rec.icwor_con_claim_ref
                      ,l_referral_rec.icwor_con_id
                      ,l_referral_rec.icwol_wol_id
                      ,l_referral_rec.icboq_status);

        l_total_value := l_total_value + l_referral_rec.icwol_claim_value;
      l_no_of_recs := l_no_of_recs + 1;

      END LOOP;

    END IF;

    UTL_FILE.PUT_LINE(l_fhand, '10,'||TO_CHAR(l_no_of_recs)||','||
                TO_CHAR(l_total_value));
    UTL_FILE.FFLUSH(l_fhand);
    UTL_FILE.FCLOSE(l_fhand);

    COMMIT;

    p_error := NULL;

  ELSE

    p_error := l_file_not_found;

  END IF;
  update_ier(p_ih_id);--templine
  COMMIT;
  EXCEPTION
    WHEN utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
      p_error := l_file_not_found;

    WHEN others THEN
      p_error := SQLERRM;

END;

FUNCTION get_oun_id(p_contractor_id IN varchar2) RETURN varchar2 IS
    CURSOR c1 IS
    SELECT oun_contractor_id
    FROM org_units
    WHERE oun_org_id = p_contractor_id;
    l_id org_units.oun_contractor_id%TYPE;
  BEGIN
    OPEN c1;
    FETCH c1 INTO l_id;
    CLOSE c1;
    RETURN l_id;
  END get_oun_id;
/******************************************************************************
** SM - 03102004
** split_cost_code function accepts the cost code from the contract from and
** dependent on what the global seperator is it seperates the values.
******************************************************************************/
  FUNCTION split_cost_code ( p_cost_code IN interface_wol.iwol_cost_code%TYPE
                           , p_number IN number
                           ) RETURN varchar2 IS
    l_cost_code        interface_wol.iwol_cost_code%TYPE;
    invalid_value EXCEPTION;
  BEGIN
    --check that the last digit is a g_seperator and if not then add it
    IF INSTR(p_cost_code,g_separator,LENGTH(p_cost_code),1) = 0
      THEN
        l_cost_code := p_cost_code||g_separator;
    ELSE
      l_cost_code := p_cost_code;
    END IF;
    --
    -- do the actual splitting
    IF p_number = 1
      THEN
        l_cost_code := SUBSTR(l_cost_code,1,INSTR(l_cost_code,g_separator,p_number)-1);
    ELSIF p_number > 1
         THEN
         l_cost_code := SUBSTR(l_cost_code
                         ,INSTR(l_cost_code
                               ,g_separator
                               ,1
                               ,p_number-1)+1
                         ,INSTR(l_cost_code
                               ,g_separator
                               ,1
                               ,p_number)-INSTR(l_cost_code
                                               ,g_separator
                                               ,1
                                               ,p_number-1)-1);
       ELSE
         RAISE invalid_value; --value must be greater than 0
    END IF;
    --
    RETURN l_cost_code;
    --
  EXCEPTION
      WHEN invalid_value THEN
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);
  END split_cost_code;
--
---------------------------------------------------------------------
--
procedure write_ctrl_file(pi_filename      in varchar2
                         ,pi_filepath      in varchar2
                         ,pi_total_lines   in pls_integer
                         ,pi_total_credits in number
                         ,pi_total_debits  in number
                         ) IS

  c_ctrl_filepath constant varchar2(2000) := NVL(pi_filepath, g_filepath);
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
---------------------------------------------------------------------
-- Writes a Financial Commitment file from the data in the
-- Interface_wor/wol/boq tables populated by mai3800 when WO
-- amendments are made.
--
FUNCTION financial_commitment_file(p_job_id number) RETURN varchar2 IS

  CURSOR gri_report_run IS
    SELECT 'x'
    FROM gri_report_runs
    WHERE grr_job_id = p_job_id
    AND   grr_mode = 'WEB';
  --
  lc_dummy varchar2(1);
  --
  BEGIN
    --
    xnhcc_interfaces.g_job_id := p_job_id;
    --
    OPEN gri_report_run;
    FETCH gri_report_run
    INTO lc_dummy;

    IF gri_report_run%FOUND THEN
      interfaces.extract_filename := higgrirp.get_module_spoolpath(p_job_id,USER)||higgrirp.get_module_spoolfile(p_job_id);
    END IF;
    --
    CLOSE gri_report_run;
    --
    RETURN interfaces.financial_commitment_file(higgrirp.get_parameter_value(p_job_id, 'A_NUMBER')
                                               ,higgrirp.get_parameter_value(p_job_id, 'TEXT')
                                               ,higgrirp.get_parameter_value(p_job_id, 'CONTRACTOR_ID')
                                               ,higgrirp.get_parameter_value(p_job_id, 'TO_DATE'));
  END;

FUNCTION financial_commitment_file(p_seq_no        IN number
                                  ,p_filepath      IN varchar2
                                  ,p_contractor_id IN varchar2
                                  ,pi_end_date     IN date
                                  ) RETURN varchar2 IS

  l_today         date := SYSDATE;
  l_no_of_recs     number(7) := 0;
  l_total_value     number := 0;
  l_fhand         utl_file.file_type;
  l_seq_no         varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,p_contractor_id, p_seq_no, 'FI');
--
  l_filename     varchar2(50) := 'FI'||TO_CHAR(l_seq_no)||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')||'.'||get_oun_id(p_contractor_id);
  l_filename2     varchar2(50) := 'FI'||TO_CHAR(l_seq_no)||'.DAT';
  l_header_record     varchar2(31) := '00,'||TO_CHAR(l_seq_no)||','||
                        TO_CHAR(l_today, g_date_format)
                        ||','||TO_CHAR(l_today, g_time_format);
  l_file_not_found varchar2(250) := 'Error: Unable to write Financial Commitment File. Path: '||NVL(p_filepath, g_filepath)||'  File: '||l_filename;

--
-- The outer join to interface_boq is required here for when a WOL has been deleted.
-- In this case the boqs will no longer exist but the record should still be
-- included in the commitment file.
--
  CURSOR commitment(p_end_date date                        --KA: added 05/10/2006
                   ) IS
    SELECT '05,'||iwor_transaction_type||','||TO_CHAR(iwor_date_confirmed, g_date_format)||
        ','||iwor_works_order_no||','||TO_CHAR(iwol_id)||','||
        TO_CHAR(iwol_def_defect_id)||','||TO_CHAR(iwol_schd_id)||','||
        iwol_def_priority||','||oun_unit_code||','||iwor_con_code||','||
        LTRIM(TO_CHAR(NVL(SUM(iboq_cost), 0),'9999999990.00'))||','||iwol_work_cat||','||iwol_cost_code||
        ','||bud_fyr_id commitment_record --SM 26112008 717549 added budget year
          ,iwor_transaction_id
        ,NVL(SUM(iboq_cost), 0) VALUE
    FROM   contracts
        ,org_units
        ,interface_wor
        ,interface_wol
        ,interface_boq
        ,work_order_lines
        ,budgets
    WHERE  con_code = iwor_con_code
    AND    con_contr_org_id = oun_org_id
    AND    iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
    AND    iwor_fi_run_number IS NULL
    AND    (p_end_date IS NULL
            OR
            iwor_date_confirmed <= p_end_date)
    AND    wol_bud_id = bud_id
    AND    wol_id = iwol_id
    GROUP BY iwor_transaction_type, TO_CHAR(iwor_date_confirmed, g_date_format)
        ,iwor_works_order_no, iwol_id, iwol_def_defect_id
        ,iwol_schd_id, iwol_def_priority, oun_unit_code
        ,iwor_con_code, iwol_work_cat
        ,iwol_cost_code, iwor_transaction_id, bud_fyr_id
    ORDER BY iwor_transaction_id;
--
  --KA 13/11/2006: Added transaction ID parameter.
  --               Added filter by transaction ID.
  --               Removed order by transaction ID.
  --               Removed p_cost parameter.
  CURSOR ncc_commitment ( p_entered_cr varchar2
                        , p_entered_dr varchar2
                        , p_glsv_cr varchar2
                        , p_glsv_dr varchar2
                        , p_wol_id interface_wol.iwol_id%TYPE
                        , p_hig_id hig_users.hus_user_id%TYPE
                        , p_transaction_type interface_wor.iwor_transaction_type%TYPE
                        , p_account_date work_order_lines.wol_date_created%TYPE
                        , p_cost_code interface_wol.iwol_cost_code%TYPE
                        , p_end_date date                                  --KA: added 05/10/2006
                        , p_transaction_id interface_wor.iwor_transaction_id%type  --KA: added 13/11/2006
            ) IS
    SELECT 'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(p_account_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           LTRIM(TO_CHAR(TO_NUMBER(p_entered_dr),'999999990.00'))||','||--ENTERED_DR
           ','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),1)) commitment_record --ATTRIBUTE1
           --interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),1) commitment_record --ATTRIBUTE1
           --NVL(p_cost_code,iwol_cost_code) commitment_record--ATTRIBUTE1
           --'commitment_record cost code 1 debit' commitment_record--ATTRIBUTE1
           ,'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(p_account_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(p_entered_cr),'999999990.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),3)) commitment_record2--ATTRIBUTE1
           --interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),3) commitment_record2--ATTRIBUTE1
           --NVL(p_cost_code,iwol_cost_code) commitment_record2--ATTRIBUTE1
           --'commitment_record2 cost code 3 credit' commitment_record2--ATTRIBUTE1
,'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(p_account_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(p_glsv_cr),'999999990.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),1)) commitment_record3--cost code 1 CREDIT
           --interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),1) commitment_record3--cost code 1 CREDIT
           --NVL(p_cost_code,iwol_cost_code) commitment_record3--cost code 1 CREDIT
           --'commitment_record3 cost code 1 CREDIT' commitment_record3--cost code 1 CREDIT
,'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(p_account_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           LTRIM(TO_CHAR(TO_NUMBER(p_glsv_dr),'999999990.00'))||','||--ENTERED_DR
           ','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),3)) commitment_record4--cost code 3 DEBIT
           --interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),3) commitment_record4--cost code 3 DEBIT
           --NVL(p_cost_code,iwol_cost_code) commitment_record4--cost code 3 DEBIT
           --'commitment_record4 cost code 3 DEBIT' commitment_record4--cost code 3 DEBIT
,'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(p_account_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(p_entered_cr),'999999990.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),2)) commitment_record5 --cost code 2 CREDIT
           --interfaces.split_cost_code(NVL(p_cost_code,iwol_cost_code),2) commitment_record5--cost code 2 CREDIT
           --NVL(p_cost_code,iwol_cost_code) commitment_record5--cost code 2 CREDIT
           --'commitment_record5 cost code 2 CREDIT' commitment_record5--cost code 2 CREDIT
           ,iwor_transaction_id
        ,NVL(SUM(iboq_cost), 0) VALUE
    FROM contracts
        ,org_units
        ,interface_wor
        ,interface_wol
        ,interface_boq
--        ,budgets
--        ,work_order_lines
    WHERE  con_code = iwor_con_code
    AND    con_contr_org_id = oun_org_id
    AND    iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
    AND    iwor_fi_run_number IS NULL
    AND    (p_end_date IS NULL
            OR
            iwor_date_confirmed <= p_end_date)
    AND    iwol_id = p_wol_id
--    and    wol_id = iwol_id
--    and    bud_id = wol_bud_id
    AND    con_contr_org_id = p_contractor_id
    AND    iwor_transaction_type = p_transaction_type
  and    iwor_transaction_id = p_transaction_id
    GROUP BY iwor_transaction_type, TO_CHAR(iwor_date_confirmed, g_date_format)
        ,iwor_works_order_no, iwol_id, iwol_def_defect_id
        ,iwol_schd_id, iwol_def_priority, oun_unit_code
        ,iwor_con_code, iwol_work_cat
        ,iwol_cost_code, iwor_transaction_id, iwol_cost_code;
--
TYPE trans_type IS TABLE OF interface_boq.iboq_transaction_id%TYPE INDEX BY binary_integer;
transaction_id_tab trans_type;
transaction_id_tab2 trans_type;
--
--KA 13/11/2006: Added transaction ID as a param and filter to return only transactions
--               previous to the current (i.e. lower trans IDs).
CURSOR trans_id ( p_wol_id         interface_wol.iwol_id%TYPE
                , p_transaction_id interface_wor.iwor_transaction_id%type
                ) IS
SELECT UNIQUE iboq_transaction_id
FROM interface_boq
WHERE iboq_wol_id = p_wol_id
and  iboq_transaction_id < p_transaction_id
ORDER BY iboq_transaction_id DESC;
--
CURSOR c1 ( p_iboq_transaction_id interface_boq.iboq_transaction_id%TYPE
          , p_wol_id interface_wol.iwol_id%TYPE
          ) IS
SELECT SUM(iboq_cost) iwol_cost
FROM interface_wor
    ,interface_wol
    ,interface_boq
    ,work_order_lines
WHERE iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
--    And    iwor_fi_run_number Is Null
    AND    wol_id = iwol_id
    AND    wol_id = p_wol_id
    AND    wol_works_order_no = iwol_works_order_no
--    and    wol_act_cost is null
AND iboq_transaction_id = p_iboq_transaction_id;
--
--KA 13/11/2006: Added transaction ID to the select list
CURSOR c2(p_end_date date                                  --KA: added 05/10/2006
         ) IS
  SELECT
    iwor_transaction_id,
    iwor_transaction_type
         , iwor_works_order_no
         , iwol_id
         , SUM(iboq_cost) wol_est_cost
         , iwol_road_id
    FROM   contracts
        ,org_units
        ,interface_wor
        ,interface_wol
        ,interface_boq
--        ,work_order_lines
    WHERE  con_code = iwor_con_code
    AND    con_contr_org_id = oun_org_id
    AND    iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
    AND    iwor_fi_run_number IS NULL
    AND    (p_end_date IS NULL
            OR
            iwor_date_confirmed <= p_end_date)
--    and    wol_id = iwol_id
--    and    wol_works_order_no = iwol_works_order_no
    AND    con_contr_org_id = p_contractor_id
--    and    wol_act_cost is null
    GROUP BY iwor_transaction_type, TO_CHAR(iwor_date_confirmed, g_date_format)
        ,iwor_works_order_no, iwol_id, iwol_def_defect_id
        ,iwol_schd_id, iwol_def_priority, oun_unit_code
        ,iwor_con_code, iwol_work_cat
        ,iwol_cost_code, iwor_transaction_id,
        --wol_est_cost,
        iwol_id, iwol_road_id
    ORDER BY iwor_transaction_id;
--
CURSOR c3 IS
SELECT hus_user_id
FROM hig_users
WHERE hus_username = USER;
--
--KA 13/11/2006: removed restriction on run number as last applied transaction may be
--               being processed in the current run.
--               Added transaction ID as a param and filter to return only transactions
--               previous to the current (i.e. lower trans IDs).
--               Changed ordering to return the last transaction first.
CURSOR get_last_sent_val ( p_wol_id         interface_wol.iwol_id%TYPE
                         , p_transaction_id interface_wor.iwor_transaction_id%type
                         ) IS
    SELECT iwor_transaction_type
         , iwor_works_order_no
         , iwol_id
         , SUM(iboq_cost) wol_est_cost
         , iwor_fi_run_number
         , iwol_cost_code
    FROM   contracts
        ,org_units
        ,interface_wor
        ,interface_wol
        ,interface_boq
--        ,work_order_lines
    WHERE  con_code = iwor_con_code
    AND    con_contr_org_id = oun_org_id
    AND    iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
    --AND    iwor_fi_run_number IS NOT NULL
--    and    wol_id = iwol_id
    AND    iwol_id = p_wol_id
--    and    wol_works_order_no = iwol_works_order_no
    AND    con_contr_org_id = p_contractor_id
  and iwor_transaction_id < p_transaction_id
        GROUP BY iwor_transaction_type, TO_CHAR(iwor_date_confirmed, g_date_format)
        ,iwor_works_order_no, iwol_id, iwol_def_defect_id
        ,iwol_schd_id, iwol_def_priority, oun_unit_code
        ,iwor_con_code, iwol_work_cat
        ,iwol_cost_code, iwor_transaction_id
--        ,wol_est_cost
        ,iwol_id
        ,iwol_cost_code
--        ,wol_act_cost
        ,iwor_fi_run_number
    ORDER BY iwor_transaction_id DESC;
--
CURSOR get_wol_date_created ( p_wol_id work_order_lines.wol_id%TYPE
          ) IS
SELECT wol_date_created
FROM work_order_lines
WHERE wol_id = p_wol_id;
--
CURSOR get_wor_date_comp ( p_wor_works_order_no work_orders.wor_works_order_no%TYPE
          ) IS
SELECT wor_date_closed
FROM work_orders
WHERE wor_works_order_no = p_wor_works_order_no;
--
l_entered_dr varchar2(10);
l_entered_cr varchar2(10);
l_glsv_cr varchar2(10);
l_glsv_dr varchar2(10);
l_transaction_id interface_wor.iwor_transaction_id%TYPE;
l_transaction_type interface_wor.iwor_transaction_type%TYPE;
l_account_date date;
l_cost_code interface_wol.iwol_cost_code%TYPE;
--
l_dynamic_cursor varchar2(3000);
l_num number := 0;
l_count number := 0;
l_user_id hig_users.hus_user_id%TYPE;
--
  l_lines_in_file pls_integer := 0;
  l_total_credits number := 0;
  l_total_debits  number := 0;

  PROCEDURE log_ctrl_data(pi_credit in number DEFAULT 0
                         ,pi_debit  in number DEFAULT 0
                         ,pi_lines  in pls_integer default 2
                         ) is
  begin
    l_lines_in_file := l_lines_in_file + nvl(pi_lines, 0);

    l_total_credits := l_total_credits + nvl(pi_credit, 0);

    l_total_debits  := l_total_debits + NVL(pi_debit, 0);

    nm_debug.debug('after: ' || l_lines_in_file || ':' || l_total_credits || ':' || l_total_debits);

  end log_ctrl_data;

BEGIN
--get user id from hig_users
  OPEN c3;
  FETCH c3 INTO l_user_id;
  CLOSE c3;
--
  IF l_seq_no = -1 THEN
    RAISE g_file_exists;
  END IF;
--  l_fhand := utl_file.fopen(Nvl(p_filepath, g_filepath), l_filename, 'w');

IF hig.get_user_or_sys_opt('FCFORMAT')='Y' THEN
  --SM 09/04/2008 log712203
  --Removed reference to extract_filename as no longer required for forms9. Used to be required to create a 
  --*.lis file.    
  l_fhand := UTL_FILE.FOPEN(NVL(p_filepath, g_filepath), /*NVL(interfaces.extract_filename,*/l_filename/*)*/, 'w');
ELSE
  l_fhand := UTL_FILE.FOPEN(NVL(p_filepath, g_filepath), /*NVL(interfaces.extract_filename,*/l_filename2/*)*/, 'w');
END IF;
  IF UTL_FILE.IS_OPEN(l_fhand) THEN
    IF hig.get_user_or_sys_opt('FCFORMAT') = 'Y' THEN
    -- If NCC FIMS format is required
      FOR l_com_rec IN c2(p_end_date => pi_end_date)
      LOOP
        l_glsv_dr := NULL;
        l_glsv_cr := NULL;
        l_entered_dr := NULL;
        l_entered_cr := NULL;
        l_cost_code := NULL;   --KA: added 13/11/2006. If not reset here potentially
                               --picks up value from previous iteration of the loop

      -- return the transaction type, works order no and wol cost
      -- for all order lines not processed.
    l_transaction_type := l_com_rec.iwor_transaction_type;
        IF l_com_rec.iwor_transaction_type = 'C'
          THEN
            -- if transaction type is (C)reate
            l_entered_dr := l_com_rec.wol_est_cost;
            l_entered_cr := l_com_rec.wol_est_cost;
                        -- gets the wol_date_created for teh account_date
            OPEN get_wol_date_created( l_com_rec.iwol_id );
            FETCH get_wol_date_created INTO l_account_date;
            CLOSE get_wol_date_created;
            --
        ELSIF l_com_rec.iwor_transaction_type = 'A'
          THEN
          -- if transaction type is (A)mend
            IF l_com_rec.iwol_road_id IS NULL OR l_com_rec.iwol_road_id = ' '
              THEN
                --assume record is deleted
                    --KA 13/11/2006 added transaction ID param
                    FOR glsv IN get_last_sent_val(p_wol_id         => l_com_rec.iwol_id
                                             ,p_transaction_id => l_com_rec.iwor_transaction_id)
                LOOP
/*******************************************************************************************************************
** SM - 21092004 - Commented out the following because when a value is to be deleted it is to be set to zero and
**                 sent.
********************************************************************************************************************
                                  l_entered_cr := to_char(glsv.wol_est_cost);
*******************************************************************************************************************/
                                  l_glsv_cr := TO_CHAR(glsv.wol_est_cost);-- SM - 04112004
                                  l_glsv_dr := TO_CHAR(glsv.wol_est_cost);-- SM - 04112004
                  l_cost_code := glsv.iwol_cost_code;
                  EXIT;
                END LOOP;
                          OPEN get_wol_date_created( l_com_rec.iwol_id );
              FETCH get_wol_date_created INTO l_account_date;
              CLOSE get_wol_date_created;
            ELSE
              --get all the transaction_ids for this wol_id into a table in desc order.
        --KA 13/11/2006 added transaction ID param
              OPEN trans_id (p_wol_id         => l_com_rec.iwol_id
                      ,p_transaction_id => l_com_rec.iwor_transaction_id);
              FETCH trans_id BULK COLLECT INTO transaction_id_tab;
              CLOSE trans_id;
              --
                          --takes the latest trasaction id and gets the cost for it.
              IF transaction_id_tab.COUNT > 1 THEN
                  FOR c1rec IN c1( transaction_id_tab(2)
                               , l_com_rec.iwol_id
                                   ) LOOP
                  --
                    l_entered_cr := TO_CHAR(c1rec.iwol_cost);
                    EXIT;
                  --
                          END LOOP;
              END IF;
              --
              OPEN get_wol_date_created( l_com_rec.iwol_id );
              FETCH get_wol_date_created INTO l_account_date;
              CLOSE get_wol_date_created;
              --
                          l_entered_dr := l_com_rec.wol_est_cost;
              --if l_entered_cr is null and l_entered_dr is null --SM - 05112004 - commented out and replaced with new glsv values
              IF l_glsv_cr IS NULL AND l_glsv_dr IS NULL
                    THEN --assume an instructed line deleted
                  --KA 13/11/2006 added transaction ID param
                FOR glsv IN get_last_sent_val(p_wol_id         => l_com_rec.iwol_id
                                         ,p_transaction_id => l_com_rec.iwor_transaction_id)
            LOOP
                                l_glsv_cr := TO_CHAR(glsv.wol_est_cost);
                                l_glsv_dr := TO_CHAR(glsv.wol_est_cost);
                    EXIT;
                  END LOOP;
                  END IF;
            END IF;
        ELSIF l_com_rec.iwor_transaction_type = 'D'
          THEN
            -- if transaction type is (D)elete
                    l_entered_cr := l_com_rec.wol_est_cost;
                    l_entered_dr := l_com_rec.wol_est_cost;
            --
--            if l_com_rec.iwol_road_id is null or l_com_rec.iwol_road_id = ' '
--              then
                --assume record is cancelled
              --KA 13/11/2006 added transaction ID param
              FOR glsv IN get_last_sent_val(p_wol_id         => l_com_rec.iwol_id
                                       ,p_transaction_id => l_com_rec.iwor_transaction_id)
          LOOP
                                  l_glsv_cr := TO_CHAR(glsv.wol_est_cost);-- SM - 04112004
                                  l_glsv_dr := TO_CHAR(glsv.wol_est_cost);-- SM - 04112004
                  l_cost_code := glsv.iwol_cost_code;
                  EXIT;
                END LOOP;
--            end if;
            OPEN get_wor_date_comp( l_com_rec.iwor_works_order_no );
            FETCH get_wor_date_comp INTO l_account_date;
            CLOSE get_wor_date_comp;
            --
        END IF;
        --
        FOR l_com_rec_fc IN ncc_commitment( l_entered_dr                    --l_entered_cr --SM - 21092004
                                          , l_entered_dr
                                          , l_glsv_cr                       --SM - 04112004 -- Added these two values to allow for teh splitting of the cost code.
                                          , l_glsv_dr                       --SM - 04112004 -- Should the cost code be split into more than 3 values then the main
                                          , l_com_rec.iwol_id                               -- query that the file is written from should probably be reworked.
                      , l_user_id
                      , l_com_rec.iwor_transaction_type
                      , l_account_date
                      , l_cost_code
            , pi_end_date
            , l_com_rec.iwor_transaction_id) LOOP
          --
/*******************************************************************************************************************
** SM - 21092004 - Commented out the following because when a value is to be deleted it is to be set to zero and
**                 sent. Also added the CR line to balance the DR line.
*******************************************************************************************************************/
     --
     -- SM - 05112004 - commented out teh following two lines that I'd originally added due to changes made to the
     --                 spec.
     --
--utl_file.put_line(l_fhand, l_com_rec_FC.commitment_record); -- credit file
--utl_file.put_line(l_fhand, l_com_rec_FC.commitment_record2); -- debit file
/*******************************************************************************************************************
          if l_entered_cr is not null
             then
            --must be an A or D.
              utl_file.put_line(l_fhand, l_com_rec_FC.commitment_record2);
          end if;
          --
          if l_entered_dr is not null
             then
            --must be an A or C.
              utl_file.put_line(l_fhand, l_com_rec_FC.commitment_record);
        end if;
*******************************************************************************************************************/
          --
          IF l_com_rec.iwor_transaction_type = 'C'
            THEN
              UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record);
              UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record2);

              log_ctrl_data(pi_credit      => l_entered_dr  --dr is used for the credit record
                           ,pi_debit       => l_entered_dr);
            ELSIF l_com_rec.iwor_transaction_type = 'A'
                 THEN
                   IF l_glsv_cr IS NOT NULL AND l_glsv_dr IS NOT NULL
                     THEN
                       UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record3); -- credit file
                       UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record4); -- debit file

                       log_ctrl_data(pi_credit      => l_glsv_cr
                                    ,pi_debit       => l_glsv_dr);
                   END IF;

                   IF l_entered_cr IS NOT NULL OR l_entered_dr IS NOT NULL
                     THEN
                       UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record); -- credit file
                       UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record2); -- debit file

                       log_ctrl_data(pi_credit      => l_entered_dr --dr is used for the credit record
                                    ,pi_debit       => l_entered_dr);
                   END IF;
                 ELSIF l_com_rec.iwor_transaction_type = 'D'
                      THEN
                        IF l_glsv_cr IS NOT NULL AND l_glsv_dr IS NOT NULL
                          THEN
                            UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record3); -- credit file
                            UTL_FILE.PUT_LINE(l_fhand, l_com_rec_fc.commitment_record4); -- debit file

                            log_ctrl_data(pi_credit      => l_glsv_cr
                                          ,pi_debit       => l_glsv_dr);
                        END IF;
          END IF;
          --
          l_no_of_recs := l_no_of_recs + 1;
          l_total_value := l_total_value + l_com_rec_fc.VALUE;
          l_transaction_id := l_com_rec_fc.iwor_transaction_id;
          --
          l_count := l_count+1;
          transaction_id_tab2(l_count) := l_transaction_id;
          --
        END LOOP;--l_com_rec_FC
    END LOOP;--l_com_rec
    FOR i IN 1..transaction_id_tab2.COUNT LOOP
          UPDATE interface_wor
            SET    iwor_fi_run_number = l_seq_no
          WHERE  iwor_transaction_id = transaction_id_tab2(i);
    END LOOP;
    --
    write_ctrl_file(pi_filename      => l_filename
                   ,pi_filepath      => p_filepath
                   ,pi_total_lines   => l_lines_in_file
                   ,pi_total_credits => l_total_credits
                   ,pi_total_debits  => l_total_debits);

    COMMIT;
    --
    ELSE
    nm_debug.debug('1)');--templine
      UTL_FILE.PUT_LINE(l_fhand, l_header_record);
      FOR l_com_rec IN commitment(p_end_date => pi_end_date)
      LOOP
      nm_debug.debug('2)l_no_of_recs - '||l_no_of_recs);--templine
        UTL_FILE.PUT_LINE(l_fhand, l_com_rec.commitment_record);
      l_no_of_recs := l_no_of_recs + 1;
      l_total_value := l_total_value + l_com_rec.VALUE;

        UPDATE interface_wor
        SET    iwor_fi_run_number = l_seq_no
      WHERE  iwor_transaction_id = l_com_rec.iwor_transaction_id;
      END LOOP;
      COMMIT;
      UTL_FILE.PUT_LINE(l_fhand, '10,'||TO_CHAR(l_no_of_recs)||','||
                  LTRIM(TO_CHAR(l_total_value,'9999999990.00')));
      UTL_FILE.FFLUSH(l_fhand);
      UTL_FILE.FCLOSE(l_fhand);
    END IF;
  END IF;
  IF hig.get_user_or_sys_opt('FCFORMAT')='Y' THEN
    RETURN l_filename;
  ELSE
    RETURN l_filename2;
END IF;
  EXCEPTION
    WHEN utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
      DBMS_OUTPUT.ENABLE(300);
      DBMS_OUTPUT.PUT_LINE(l_file_not_found);
      --
      IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
        higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,l_file_not_found);
      END IF;
      --
      RETURN NULL;

    WHEN g_file_exists THEN
      DBMS_OUTPUT.ENABLE(300);
      DBMS_OUTPUT.PUT_LINE(g_file_exists_err);
      --
      IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
        higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,g_file_exists_err);
      END IF;
      --
      RETURN NULL;

    WHEN others THEN
      RAISE_APPLICATION_ERROR(-20001, SQLERRM);

END;
---------------------------------------------------------------------
-- Writes a Financial Credit file. Called from the Payment Run process
-- (mai3840)
--

PROCEDURE financial_credit_file(p_cnp_id IN  contract_payments.cnp_id%TYPE
                     ,p_file   OUT varchar2
                     ,p_contractor_id IN varchar2) IS

  l_today         date := SYSDATE;
  l_wol_id         work_order_lines.wol_id%TYPE;
  l_cost_code     budgets.bud_cost_code%TYPE;
  l_no_of_recs     number(7) := 0;
  l_total_value     number := 0;
  l_fhand         utl_file.file_type;
  l_seq_no         varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,p_contractor_id, '', 'FC');
  l_filename     varchar2(50) := 'FC'||TO_CHAR(l_seq_no)||TO_CHAR(SYSDATE,'YYYYMMDDHH24MMSS')||'.'||get_oun_id(p_contractor_id);
  l_filename2     varchar2(12) := 'FC'||TO_CHAR(l_seq_no)||'.DAT';
  l_header_record     varchar2(30) := '00,'||TO_CHAR(l_seq_no)||','||
                        TO_CHAR(l_today, g_date_format)
                        ||','||TO_CHAR(l_today, g_time_format);
  l_file_not_found varchar2(250) := 'Error: Unable to write Financial Credit File. Path: '||g_filepath||'  File: '||l_filename;

  CURSOR credit IS
    SELECT '05,'||TO_CHAR(woc_claim_date, g_date_format)||','||
           TO_CHAR(p_cnp_id)||','||woc_claim_ref||','||
         wol_works_order_no||','||
         TO_CHAR(wol_id)||','||
         TO_CHAR(wol_def_defect_id)||','||
         TO_CHAR(wol_schd_id)||','||
         oun_unit_code||','||
         oun_comments||','||
         LTRIM(TO_CHAR(cp_payment_value,'9999999990.00'))||','||
         wol_icb_work_code||','||bud_cost_code||','||bud_fyr_id credit_record --SM 26112008 727549 Added budgey financial year
          ,LTRIM(TO_CHAR(cp_payment_value,'9999999990.00')) VALUE
        ,wol_id
    FROM   org_units
        ,contracts
        ,work_order_claims
        ,work_orders
        ,claim_payments
        ,work_order_lines
          ,budgets
    WHERE  con_id = woc_con_id
    AND    con_contr_org_id = oun_org_id
    AND    wol_works_order_no = wor_works_order_no
    AND    wol_works_order_no = woc_works_order_no
    AND    wol_bud_id = bud_id
    AND    woc_claim_ref = cp_woc_claim_ref
    AND    woc_con_id = cp_woc_con_id
    AND    wol_id = cp_wol_id
    AND    wol_cnp_id = cp_payment_id
    AND    wol_cnp_id = p_cnp_id;

  CURSOR ncc_commitment ( p_wol_id interface_wol.iwol_id%TYPE
                        , p_user_id hig_users.hus_user_id%TYPE
                        ) IS
    SELECT 'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(cp_payment_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'A,'||--ACTUAL_FLAG
           'NCC HMS PAYMENTS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           ','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_DR
           ','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           wol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,3)) actual_record,--cost code 3 DR
           --interfaces.split_cost_code(bud_cost_code,3) actual_record,--cost code 3 DR
           'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(cp_payment_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'A,'||--ACTUAL_FLAG
           'NCC HMS PAYMENTS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           ','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           wol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,1)) actual_record2,--cost code 1 CR
           --interfaces.split_cost_code(bud_cost_code,1) actual_record2,--cost code 1 CR
           'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(cp_payment_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'A,'||--ACTUAL_FLAG
           'NCC HMS PAYMENTS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           ','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_DR
           ','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           wol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
          interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,1)) actual_record3,--cost code 1 DR
           --interfaces.split_cost_code(bud_cost_code,1) actual_record3,--cost code 1 DR
           'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(cp_payment_date,'DD-MON-YYYY')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           ','||--CREATED_BY
           'A,'||--ACTUAL_FLAG
           'NCC HMS PAYMENTS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           ','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           wol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,2)) actual_record4--cost code 2 CR
           --interfaces.split_cost_code(bud_cost_code,2) actual_record4--cost code 2 CR
           ,wol_act_cost line_value
    FROM   org_units
        ,contracts
        ,work_order_claims
        ,work_orders
        ,claim_payments
        ,work_order_lines
        ,budgets
    WHERE  con_id = woc_con_id
    AND    con_contr_org_id = oun_org_id
    AND    wol_works_order_no = wor_works_order_no
    AND    wol_works_order_no = woc_works_order_no
    AND    woc_claim_ref = cp_woc_claim_ref
    AND    woc_con_id = cp_woc_con_id
    AND    wol_id = cp_wol_id
    AND    p_wol_id = wol_id
    AND    wol_cnp_id = cp_payment_id
    AND    wol_cnp_id = p_cnp_id
    AND    con_contr_org_id = p_contractor_id
    AND    wol_bud_id = bud_id;
--
CURSOR ncc_commitment_2 ( p_wol_id interface_wol.iwol_id%TYPE
                        , p_user_id hig_users.hus_user_id%TYPE
                        ) IS
    SELECT 'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(wol_date_created,'DD-MON-RRRR')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           /*p_user_id||*/','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           ','||--ENTERED_DR
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,1)) commitment_record,--cost code 3 DR
           --interfaces.split_cost_code(bud_cost_code,1) commitment_record,--cost code 3 DR
           'GLJEH01,'||--RECORD_TYPE
           'NEW,'||--STATUS
           1||','||--SET_OF_BOOKS_ID
           TO_CHAR(wol_date_created,'DD-MON-RRRR')||','||--ACCOUNTING_DATE
           'GBP,'||--CURRENCY_CODE
           ','||--DATE_CREATED
           /*p_user_id||*/','||--CREATED_BY
           'E,'||--ACTUAL_FLAG
           'NCC HMS ORDERS,'||--USER_JE_CATEGORY
           'NCC HMS,'||--USER_JE_SOURCE_NAME
           ','||--CURRENCY_CONVERSION_DATE
           1041||','||--ENCUMBRANCE_TYPE_ID
           ','||--BUDGET_VERSION_ID
           ','||--USER_CURRENCY_CONVERSION_TYPE
           ','||--CURRENCY_CONVERSION_RATE
           ','||--AVERAGE_JOURNAL_FLAG
           ','||--ORIGINATING_BAL_SEG_VALUE
           ','||--SEGMENT1
           ','||--SEGMENT2
           ','||--SEGMENT3
           ','||--SEGMENT4
           ','||--SEGMENT5
           ','||--SEGMENT6
           ','||--SEGMENT7
           LTRIM(TO_CHAR(TO_NUMBER(wol_act_cost),'999999999.00'))||','||--ENTERED_DR
           ','||--ENTERED_CR
           ','||--ACCOUNTED_DR
           ','||--ACCOUNTED_CR
           ','||--TRANSACTION_DATE
           ','||--REFERENCE1
           ','||--REFERENCE2
           ','||--REFERENCE4
           ','||--REFERENCE5
           ','||--REFERENCE6
           ','||--REFERENCE7
           ','||--REFERENCE8
           iwol_id||','||--REFERENCE10
           ','||--REFERENCE11
           ','||--REFERENCE12
           ','||--REFERENCE13
           ','||--REFERENCE14
           ','||--REFERENCE15
           ','||--REFERENCE16
           ','||--REFERENCE17
           ','||--REFERENCE18
           ','||--REFERENCE19
           ','||--REFERENCE20
           ','||--PERIOD_NAME
           ','||--JE_LINE_NUM
           ','||--CHART_OF_ACCOUNTS_ID
           ','||--CODE_COMBINATION_ID
           ','||--STST_SCOUNT
           ','||--GROUP_ID
           -- IFB 30.09.2005
           interfaces.reformat_cost_code(interfaces.split_cost_code(bud_cost_code,3)) commitment_record2--cost code 1 CR
           --interfaces.split_cost_code(bud_cost_code,3) commitment_record2--cost code 1 CR
           ,iwor_transaction_id
        ,NVL(SUM(iboq_cost), 0) VALUE
      ,wol_act_cost line_value
    FROM contracts
        ,org_units
        ,interface_wor
        ,interface_wol
        ,interface_boq
        ,budgets
        ,work_order_lines
    WHERE  con_code = iwor_con_code
    AND    con_contr_org_id = oun_org_id
    AND    iwor_works_order_no = iwol_works_order_no
    AND    iwor_transaction_id = iwol_transaction_id
    AND    iwol_transaction_id = iboq_transaction_id(+)
    AND    iwol_id = iboq_wol_id(+)
    AND    iwor_fi_run_number IS NOT NULL
    AND    iwol_id = p_wol_id
    AND    wol_id = iwol_id
    AND    bud_id = wol_bud_id
    AND    con_contr_org_id = p_contractor_id
    GROUP BY iwor_transaction_type, TO_CHAR(iwor_date_confirmed, g_date_format)
        ,iwor_works_order_no, iwol_id, iwol_def_defect_id
        ,iwol_schd_id, iwol_def_priority, oun_unit_code
        ,iwor_con_code, iwol_work_cat
        ,iwol_cost_code, iwor_transaction_id, bud_cost_code
        ,wol_date_created, wol_act_cost
    ORDER BY iwor_transaction_id DESC;
--
    CURSOR c1 IS
    SELECT hus_user_id
    FROM hig_users
    WHERE hus_username = USER;
--
    CURSOR get_wol_id IS
    SELECT wol_id
    FROM   org_units
          ,contracts
          ,work_order_claims
          ,work_orders
          ,claim_payments
          ,work_order_lines
          ,budgets
    WHERE  con_id = woc_con_id
    AND    con_contr_org_id = oun_org_id
    AND    wol_works_order_no = wor_works_order_no
    AND    wol_works_order_no = woc_works_order_no
    AND    woc_claim_ref = cp_woc_claim_ref
    AND    woc_con_id = cp_woc_con_id
    AND    wol_id = cp_wol_id
    AND    wol_cnp_id = cp_payment_id
    AND    wol_cnp_id = p_cnp_id
    AND    con_contr_org_id = p_contractor_id
    AND    wol_bud_id = bud_id;
--
    l_user_id hig_users.hus_user_id%TYPE;

  l_lines_in_file pls_integer := 0;
  l_total_credits number := 0;
  l_total_debits  number := 0;

  PROCEDURE log_ctrl_data(pi_credit in number DEFAULT 0
                         ,pi_debit  in number DEFAULT 0
                         ,pi_lines  in pls_integer default 2
                         ) is
  begin
    l_lines_in_file := l_lines_in_file + nvl(pi_lines, 0);

    l_total_credits := l_total_credits + nvl(pi_credit, 0);

    l_total_debits  := l_total_debits + NVL(pi_debit, 0);

  end log_ctrl_data;

BEGIN
IF hig.get_user_or_sys_opt('FCFORMAT')='Y' THEN
  l_fhand := UTL_FILE.FOPEN(g_filepath, l_filename, 'w');
ELSE
  l_fhand := UTL_FILE.FOPEN(g_filepath, l_filename2, 'w');
END IF;
  IF UTL_FILE.IS_OPEN(l_fhand) THEN
    IF hig.get_user_or_sys_opt('FCFORMAT') = 'Y'
      THEN
        OPEN c1;
        FETCH c1 INTO l_user_id;
        CLOSE c1;
        -- If NCC FIMS format is required
        FOR wolrec IN get_wol_id LOOP --lists all the wol_ids for payments due
/**********************************************************************************************************************
** SM - 21092004 - Removed lines to prevent the estimate getting balanced. Need to replace with balancing debit line.
***********************************************************************************************************************
               for ncc2rec in ncc_commitment_2( wolrec.wol_id, l_user_id ) loop --gets the payment for that wol_id
                          utl_file.put_line(l_fhand, ncc2rec.commitment_record2);--writes the estimate
              exit;
            end loop;
**********************************************************************************************************************/
             FOR ncc2rec IN ncc_commitment_2( wolrec.wol_id, l_user_id ) LOOP --gets the payment for that wol_id
                    UTL_FILE.PUT_LINE(l_fhand, ncc2rec.commitment_record);--writes the estimate (CR)
                    UTL_FILE.PUT_LINE(l_fhand, ncc2rec.commitment_record2);--writes the estimate (DR)

          log_ctrl_data(pi_credit => ncc2rec.line_value
                       ,pi_debit  => ncc2rec.line_value);

            EXIT;
          END LOOP;
          --
          FOR nccrec IN ncc_commitment( wolrec.wol_id, l_user_id ) LOOP --gets the last transaction value for that wol_id
                    --utl_file.put_line(l_fhand, nccrec.actual_record2);--writes the actual (CR)E
                    --utl_file.put_line(l_fhand, nccrec.actual_record);--writes the actual (DR)E
                    UTL_FILE.PUT_LINE(l_fhand, nccrec.actual_record3);--writes the actual (DR)A
                    UTL_FILE.PUT_LINE(l_fhand, nccrec.actual_record4);--writes the actual (CR)A

        log_ctrl_data(pi_credit => nccrec.line_value
                     ,pi_debit  => nccrec.line_value);
          END LOOP;
        END LOOP;
        --
        UTL_FILE.FFLUSH(l_fhand);
        UTL_FILE.FCLOSE(l_fhand);

      write_ctrl_file(pi_filename      => l_filename
                     ,pi_filepath      => g_filepath
                     ,pi_total_lines   => l_lines_in_file
                     ,pi_total_credits => l_total_credits
                     ,pi_total_debits  => l_total_debits);
    ELSE
      UTL_FILE.PUT_LINE(l_fhand, l_header_record);
      p_file := 'File '||l_filename||' created in '||g_filepath;

      FOR l_credit_rec IN credit LOOP

--
--      NM 20-JUL-2005: Commented out fetch of cost_code as cost_code is now retrieved from the cursor above (credit)
--      and tagged on the end of the Credit_record value.
--
--      Open cost_code(l_credit_rec.wol_id);
--      Fetch cost_code Into l_cost_code;
--      Close cost_code;

      l_credit_rec.credit_record := l_credit_rec.credit_record;
       UTL_FILE.PUT_LINE(l_fhand, l_credit_rec.credit_record);
      l_no_of_recs := l_no_of_recs + 1;
      l_total_value := l_total_value + l_credit_rec.VALUE;

      END LOOP;

      UTL_FILE.PUT_LINE(l_fhand, '10,'||TO_CHAR(l_no_of_recs)||','||
                LTRIM(TO_CHAR(l_total_value,'9999999990.00')));

      UTL_FILE.FFLUSH(l_fhand);
      UTL_FILE.FCLOSE(l_fhand);
    END IF;
  END IF;

  EXCEPTION
    WHEN utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
      RAISE_APPLICATION_ERROR(-20001, l_file_not_found);
END;


---------------------------------------------------------------------
-- Processes a Payment Transaction file into Highways Maintenance
-- Manager tables.
--

PROCEDURE payment_transaction_file(p_job_id IN number
                        ,p_seq_no   IN number
                        ,p_filepath IN varchar2
                        ,p_filename IN varchar2
                        ,p_error OUT varchar2) IS
BEGIN
  xnhcc_interfaces.g_job_id := p_job_id;
  --
  interfaces.payment_transaction_file(p_seq_no
                                     ,p_filepath
                                     ,p_filename
                                     ,p_error);
END;
--
PROCEDURE payment_transaction_file(p_seq_no   IN number
                        ,p_filepath IN varchar2
                        ,p_filename IN varchar2
                        ,p_error OUT varchar2) IS

  l_fhand            utl_file.file_type;
  l_no_of_recs        number := 0;
  l_total_value        number := 0;
  l_seq_no            varchar2(6) := file_seq(xnhcc_interfaces.g_job_id,'', p_seq_no, 'FP');
  l_filename        varchar2(12) := NVL(p_filename,'FP'||TO_CHAR(l_seq_no)||'.DAT');
  l_record            varchar2(255);
  l_wol_id            work_order_lines.wol_id%TYPE;
  l_claim_ref        claim_payments.cp_woc_claim_ref%TYPE;
  l_approved        claim_payments.cp_claim_value%TYPE;
  l_payment            claim_payments.cp_claim_value%TYPE;
  l_record_type        interface_erroneous_records.ier_record_type%TYPE;
  invalid_file        EXCEPTION;
  l_file_not_found    varchar2(250) := 'Error: Unable to read Payment Transaction File. Path: '||NVL(p_filepath, g_filepath)||'  File: '||l_filename;

  CURSOR approved IS
    SELECT cp_claim_value
    FROM   claim_payments
    WHERE  cp_wol_id = l_wol_id
    AND    cp_woc_claim_ref = l_claim_ref;

BEGIN

  l_fhand := UTL_FILE.FOPEN(p_filepath, l_filename, 'r');
  IF UTL_FILE.IS_OPEN(l_fhand) THEN
    LOOP
      UTL_FILE.GET_LINE(l_fhand, l_record);

      l_record_type := int_utility.get_field(l_record, 1);

      IF l_record_type = '05' THEN

      l_no_of_recs := l_no_of_recs + 1;
        l_wol_id := int_utility.get_field(l_record, 7);
      l_claim_ref := UPPER(int_utility.get_field(l_record, 4));
        l_payment := int_utility.get_field(l_record, 11);
      l_total_value := l_total_value + l_payment;

        UPDATE claim_payments
        SET       cp_fis_payment_ref = int_utility.get_field(l_record, 5)
      WHERE  cp_woc_claim_ref = l_claim_ref
      AND    cp_wol_id = l_wol_id
      AND    cp_payment_id = int_utility.get_field(l_record, 3);

        OPEN approved;
        FETCH approved INTO l_approved;
        CLOSE approved;

        IF NVL(l_approved,0) != NVL(l_payment,0) THEN
          DBMS_OUTPUT.PUT_LINE('WARNING: The payment value and approved value are not the same for claim '||
                      l_claim_ref);
          --
          IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
            higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,'WARNING: The payment value and approved value are not the same for claim '||
                      l_claim_ref);
          END IF;
          --
        END IF;

      ELSIF l_record_type = '10' THEN

      IF l_no_of_recs != int_utility.get_field(l_record, 2) OR
         l_total_value != int_utility.get_field(l_record, 3) THEN

          DBMS_OUTPUT.PUT_LINE('WARNING: Check record totals do not tally.');
          --
          IF xnhcc_interfaces.g_job_id IS NOT NULL THEN
            higgrirp.write_gri_spool(xnhcc_interfaces.g_job_id,'WARNING: Check record totals do not tally.');
          END IF;
          --
        END IF;

    END IF;
    END LOOP;
  ELSE
    RAISE invalid_file;
  END IF;

  EXCEPTION
    WHEN invalid_file OR utl_file.invalid_path OR utl_file.invalid_mode OR utl_file.invalid_operation THEN
      p_error := l_file_not_found;

      WHEN no_data_found THEN  --end of file
        UTL_FILE.FCLOSE(l_fhand);

      WHEN others THEN
        p_error := SQLERRM;

END;


---------------------------------------------------------------------
-- Populate the Interface_Wol/Boq tables
--
PROCEDURE pop_wol_and_boq_tabs(p_wol_rec  IN wol_rec
                    ,p_trans_id    IN interface_wor.iwor_transaction_id%TYPE) IS
  --
  CURSOR boq (p_cimallest  hig_option_values.hov_value%TYPE)
      IS
  SELECT boq_sta_item_code
        ,DECODE(p_cimallest, 'Y', boq_est_dim1, NVL(boq_act_dim1, boq_est_dim1)) dim1 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_dim2, NVL(boq_act_dim2, boq_est_dim2)) dim2 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_dim3, NVL(boq_act_dim3, boq_est_dim3)) dim3 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_quantity, NVL(boq_act_quantity, boq_est_quantity)) quantity -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_rate, NVL(boq_act_rate, boq_est_rate)) rate -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_cost, NVL(boq_act_cost, boq_est_cost)) COST -- Task 0109080
    FROM boq_items
   WHERE boq_wol_id = p_wol_rec.r_wol_id
       ;
  --
  CURSOR boq2 (p_cimallest  hig_option_values.hov_value%TYPE)
      IS
  SELECT boq_sta_item_code
        ,DECODE(p_cimallest, 'Y', boq_est_dim1, NVL(boq_act_dim1, boq_est_dim1)) dim1 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_dim2, NVL(boq_act_dim2, boq_est_dim2)) dim2 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_dim3, NVL(boq_act_dim3, boq_est_dim3)) dim3 -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_quantity, NVL(boq_act_quantity, boq_est_quantity)) quantity -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_rate, NVL(boq_act_rate, boq_est_rate)) rate -- Task 0109080
        ,DECODE(p_cimallest, 'Y', boq_est_cost, NVL(boq_act_cost, boq_est_cost)) COST -- Task 0109080
        ,boq_id
        ,boq_parent_id
        ,boq_item_name
        ,sta_rogue_flag
    FROM boq_items, standard_items
   WHERE boq_wol_id = p_wol_rec.r_wol_id
     AND boq_sta_item_code = sta_item_code
       ;
  --
  CURSOR def(cp_defect_id defects.def_defect_id%TYPE)
      IS
  SELECT def_locn_descr
        ,def_defect_descr
        ,def_special_instr
        ,def_priority
        ,def_defect_code
        ,def_st_chain
        ,def_x_sect
    FROM defects
   WHERE def_defect_id = cp_defect_id
       ;
  --
  l_def_rec        def%ROWTYPE;
  l_cost_code      budgets.bud_cost_code%TYPE;
  l_cimallest      hig_option_values.hov_value%TYPE := hig.get_sysopt('CIMALLEST');
  --
BEGIN
  --
  IF p_wol_rec.r_defect_id IS NOT NULL
   THEN
      OPEN  def(p_wol_rec.r_defect_id);
      FETCH def
       INTO l_def_rec;
      CLOSE def;
  END IF;
  --
  OPEN  cost_code(p_wol_rec.r_wol_id);
  FETCH cost_code
   INTO l_cost_code;
  CLOSE cost_code;
  --
  INSERT
    INTO interface_wol
        (iwol_transaction_id
          ,iwol_id
          ,iwol_works_order_no
          ,iwol_road_id
          ,iwol_road_descr
          ,iwol_def_defect_id
          ,iwol_schd_id
          ,iwol_def_locn_descr
          ,iwol_def_defect_descr
          ,iwol_def_special_instr
          ,iwol_def_priority
          ,iwol_def_defect_code
          ,iwol_def_st_chain
          ,iwol_def_x_sect
          ,iwol_percent_adjust
          ,iwol_percent_adjust_code
          ,iwol_work_cat
          ,iwol_cost_code
          ,iwol_descr
        )
  VALUES(p_trans_id
            ,p_wol_rec.r_wol_id
            ,p_wol_rec.r_wor_no
            ,p_wol_rec.r_road_id
        ,REPLACE(SUBSTR(p_wol_rec.r_road_descr,1,80),',','~') -- 719274 DY 16-MAR-2009 -- REPLACE(p_wol_rec.r_road_descr,',','~')
            ,p_wol_rec.r_defect_id
            ,p_wol_rec.r_schd_id
        ,REPLACE(l_def_rec.def_locn_descr,',','~')
        ,REPLACE(l_def_rec.def_defect_descr,',','~')
        ,REPLACE(l_def_rec.def_special_instr,',','~')
        ,l_def_rec.def_priority
        ,l_def_rec.def_defect_code
        ,l_def_rec.def_st_chain
        ,l_def_rec.def_x_sect
        ,NULL
        ,NULL
        ,p_wol_rec.r_work_code
        ,l_cost_code
        ,REPLACE(p_wol_rec.r_wol_descr,',','~')
        )
       ;
  --
  IF hig.get_sysopt('XTRIFLDS') NOT IN ('2-1-3', '2-4-0')
   THEN
      FOR boq_rec IN boq (l_cimallest) LOOP
        --
        INSERT
          INTO interface_boq
              (iboq_transaction_id
                  ,iboq_wol_id
                  ,iboq_sta_item_code
                  ,iboq_dim1
                  ,iboq_dim2
                  ,iboq_dim3
                  ,iboq_quantity
                  ,iboq_rate
                  ,iboq_cost
                  ,iboq_percent_adjust
                  ,iboq_percent_adjust_code)
        VALUES(p_trans_id
                  ,p_wol_rec.r_wol_id
                  ,boq_rec.boq_sta_item_code
                  ,boq_rec.dim1
                  ,boq_rec.dim2
                  ,boq_rec.dim3
                  ,boq_rec.quantity
                  ,boq_rec.rate
                  ,boq_rec.COST
                  ,NULL
                  ,NULL);
        --
      END LOOP;
  ELSE
      FOR boq_rec IN boq2 (l_cimallest) LOOP
        --
        INSERT
          INTO interface_boq
              (iboq_transaction_id
              ,iboq_wol_id
                ,iboq_sta_item_code
                ,iboq_dim1
                ,iboq_dim2
                ,iboq_dim3
                ,iboq_quantity
                ,iboq_rate
                ,iboq_cost
                ,iboq_percent_adjust
                ,iboq_percent_adjust_code
                ,iboq_boq_id
                  ,iboq_parent_boq_id
                  ,iboq_percent_band_comp
                  ,iboq_rogue_item
                  ,iboq_rogue_item_desc)
        VALUES(p_trans_id
                  ,p_wol_rec.r_wol_id
                  ,boq_rec.boq_sta_item_code
                  ,boq_rec.dim1
                  ,boq_rec.dim2
                  ,boq_rec.dim3
                  ,boq_rec.quantity
                  ,boq_rec.rate
                  ,boq_rec.COST
                  ,NULL
                  ,NULL
                  ,boq_rec.boq_id
                  ,boq_rec.boq_parent_id
                  ,DECODE(boq_rec.boq_parent_id, NULL, NULL, SUBSTR(hig.get_sysopt('CUM_PERC'),1,1))
                  ,DECODE(boq_rec.sta_rogue_flag, 'Y', 'R', NULL)
                  ,DECODE(boq_rec.sta_rogue_flag, 'Y', REPLACE(boq_rec.boq_item_name,',','~'), NULL))
             ;
        --
      END LOOP;
  END IF;
END;

---------------------------------------------------------------------
-- Add work order to the list of those to be inserted into the
-- interface tables by the copy_data_to_interface procedure.
--
PROCEDURE add_wor_to_list(p_trans_type    IN interface_wor.iwor_transaction_type%TYPE
                 ,p_wor_no         IN interface_wor.iwor_works_order_no%TYPE
                 ,p_wor_flag       IN interface_wor.iwor_flag%TYPE
                 ,p_scheme_type    IN interface_wor.iwor_scheme_type%TYPE
                 ,p_con_code       IN interface_wor.iwor_con_code%TYPE
                 ,p_originator     IN interface_wor.iwor_originator%TYPE
                 ,p_confirmed      IN interface_wor.iwor_date_confirmed%TYPE
                 ,p_est_complete   IN interface_wor.iwor_est_complete%TYPE
                 ,p_est_cost       IN interface_wor.iwor_cost%TYPE
				     ,p_act_cost       IN interface_wor.iwor_cost%TYPE
                 ,p_labour         IN interface_wor.iwor_est_labour%TYPE
                 ,p_ip_flag        IN interface_wor.iwor_interim_payment_flag%TYPE
                 ,p_ra_flag        IN interface_wor.iwor_risk_assessment_flag%TYPE
                 ,p_ms_flag        IN interface_wor.iwor_method_statement_flag%TYPE
                 ,p_wp_flag        IN interface_wor.iwor_works_programme_flag%TYPE
                 ,p_as_flag        IN interface_wor.iwor_additional_safety_flag%TYPE
                 ,p_commence_by    IN interface_wor.iwor_commence_by%TYPE
                 ,p_descr          IN interface_wor.iwor_descr%TYPE
                 ,p_remarks        IN interface_wor.iwor_remarks%TYPE) IS

  l_index integer;

  FUNCTION position_in_list RETURN integer IS
  BEGIN

    FOR t_index IN 0..g_wor_index - 1 LOOP
      IF g_wor_tab(t_index).iwor_works_order_no = p_wor_no AND
       g_wor_tab(t_index).iwor_transaction_type = p_trans_type THEN
        RETURN t_index;
      END IF;
    END LOOP;

    RETURN g_wor_index;

  END;


/* This procedure is now redundant as electronic orders can no
   longer be deinstructed. Orders must now be cancelled.
  procedure delete_previous_amendments is
  begin

    for t_index in 0..g_wor_index - 1 loop

      if g_wor_tab(t_index).iwor_works_order_no = p_wor_no and
       g_wor_tab(t_index).iwor_transaction_type = 'A' then

        g_wor_index := g_wor_index - 1;    -- remove record from table
        for t_index2 in t_index..g_wor_index - 1 loop
          g_wor_tab(t_index2) := g_wor_tab(t_index2 + 1);
        end loop;

      end if;

    end loop;


    for t_index in 0..g_wol_index - 1 loop

      if g_wol_tab(t_index).r_wor_no = p_wor_no then

        g_wol_index := g_wol_index - 1;    -- remove record from table
      for t_index2 in t_index..g_wol_index - 1 loop
        g_wol_tab(t_index2) := g_wol_tab(t_index2 + 1);
      end loop;

    end if;

    end loop;

  end;
*/

BEGIN

  l_index := position_in_list;

  g_wor_tab(l_index).iwor_transaction_type := p_trans_type;
  g_wor_tab(l_index).iwor_works_order_no := p_wor_no;
  g_wor_tab(l_index).iwor_flag := p_wor_flag;
  g_wor_tab(l_index).iwor_scheme_type := p_scheme_type;
  g_wor_tab(l_index).iwor_con_code := p_con_code;
  g_wor_tab(l_index).iwor_originator := p_originator;
  g_wor_tab(l_index).iwor_date_confirmed := p_confirmed;
  g_wor_tab(l_index).iwor_est_complete := p_est_complete;
  if hig.get_sysopt('CIMALLEST') = 'Y' 
  then
     g_wor_tab(l_index).iwor_cost := p_est_cost;
  else
	 g_wor_tab(l_index).iwor_cost := NVL(p_act_cost, p_est_cost);
  end if;
  g_wor_tab(l_index).iwor_est_labour := p_labour;
  g_wor_tab(l_index).iwor_interim_payment_flag := p_ip_flag;
  g_wor_tab(l_index).iwor_risk_assessment_flag := p_ra_flag;
  g_wor_tab(l_index).iwor_method_statement_flag := p_ms_flag;
  g_wor_tab(l_index).iwor_works_programme_flag := p_wp_flag;
  g_wor_tab(l_index).iwor_additional_safety_flag := p_as_flag;
  g_wor_tab(l_index).iwor_commence_by := p_commence_by;
  g_wor_tab(l_index).iwor_descr := p_descr;
  g_wor_tab(l_index).iwor_remarks := p_remarks;

  IF l_index = g_wor_index THEN
    g_wor_index := g_wor_index + 1;

-- RAC - Initialis the transaction id prior to any test on its value.
  g_wor_tab(g_wor_index).iwor_transaction_id := NULL;

  END IF;

/* This no longer required as electronic orders can no
   longer be deinstructed.
  if p_trans_type = 'D' then
    delete_previous_amendments;
  end if;
*/

END;


---------------------------------------------------------------------
-- Add work order line to the list of those to be inserted into the
-- interface tables by the copy_data_to_interface procedure.
--
PROCEDURE add_wol_to_list(p_wol_id        IN work_order_lines.wol_id%TYPE
                 ,p_wor_no        IN work_order_lines.wol_works_order_no%TYPE
                 ,p_defect_id    IN work_order_lines.wol_def_defect_id%TYPE
                 ,p_schd_id        IN work_order_lines.wol_schd_id%TYPE
                 ,p_work_code    IN work_order_lines.wol_icb_work_code%TYPE
                 ,p_road_id        IN road_segs.rse_unique%TYPE
                 ,p_road_descr    IN road_segs.rse_descr%TYPE
                 ,p_wol_descr     IN work_order_lines.wol_descr%TYPE) IS


  l_index integer;

  FUNCTION position_in_list RETURN integer IS
  BEGIN

    FOR t_index IN 0..g_wol_index - 1 LOOP

      IF g_wol_tab(t_index).r_wol_id = p_wol_id THEN

        RETURN t_index;

      END IF;

    END LOOP;

    RETURN g_wol_index;

  END;

BEGIN

  l_index := position_in_list;

  g_wol_tab(l_index).r_wol_id := p_wol_id;
  g_wol_tab(l_index).r_wor_no := p_wor_no;
  g_wol_tab(l_index).r_defect_id := p_defect_id;
  g_wol_tab(l_index).r_schd_id := p_schd_id;
  g_wol_tab(l_index).r_work_code := p_work_code;
  g_wol_tab(l_index).r_road_id := p_road_id;
  g_wol_tab(l_index).r_road_descr := p_road_descr;
  g_wol_tab(l_index).r_wol_descr := p_wol_descr;

  IF l_index = g_wol_index THEN
    g_wol_index := g_wol_index + 1;
  END IF;

END;


---------------------------------------------------------------------
-- Inserts a work order header record into the Interface_Wor table.
--
FUNCTION create_header(p_wor_rec interface_wor%ROWTYPE) RETURN integer IS

  l_trans_id        interface_wor.iwor_transaction_id%TYPE;
  -- TASK 0108810
  -- get the earliest financial year against the Work Order
  CURSOR  c_get_fyr_id (qp_work_order_no work_orders.wor_works_order_no%TYPE)
  IS
  SELECT  bud_fyr_id
  FROM    work_order_lines
         ,budgets
  WHERE   wol_works_order_no = qp_work_order_no
  AND     wol_bud_id = bud_id
  ORDER BY 1;
  l_bud_fyr_id budgets.bud_fyr_id%TYPE ;
  -- TASK 0108810
--
BEGIN

  SELECT iwor_id_seq.NEXTVAL
  INTO   l_trans_id    
  FROM   dual;

  -- TASK 0108810
  OPEN  c_get_fyr_id(p_wor_rec.iwor_works_order_no);
  FETCH c_get_fyr_id INTO l_bud_fyr_id;
  CLOSE c_get_fyr_id ; 
  -- TASK 0108810

  INSERT INTO interface_wor (
          iwor_transaction_id
        ,iwor_transaction_type
        ,iwor_works_order_no
        ,iwor_flag
        ,iwor_scheme_type
        ,iwor_con_code
        ,iwor_originator
        ,iwor_date_confirmed
        ,iwor_est_complete
        ,iwor_cost
        ,iwor_est_labour
        ,iwor_interim_payment_flag
        ,iwor_risk_assessment_flag
        ,iwor_method_statement_flag
        ,iwor_works_programme_flag
        ,iwor_additional_safety_flag
        ,iwor_commence_by
        ,iwor_fyr_id
        ,iwor_descr
        ,iwor_wo_run_number
        ,iwor_fi_run_number
        ,iwor_remarks)
  VALUES  (  l_trans_id
        ,p_wor_rec.iwor_transaction_type
        ,p_wor_rec.iwor_works_order_no
        ,p_wor_rec.iwor_flag
        ,p_wor_rec.iwor_scheme_type
        ,p_wor_rec.iwor_con_code
        ,p_wor_rec.iwor_originator
        ,p_wor_rec.iwor_date_confirmed
        ,p_wor_rec.iwor_est_complete
        ,p_wor_rec.iwor_cost
        ,p_wor_rec.iwor_est_labour
        ,p_wor_rec.iwor_interim_payment_flag
        ,p_wor_rec.iwor_risk_assessment_flag
        ,p_wor_rec.iwor_method_statement_flag
        ,p_wor_rec.iwor_works_programme_flag
        ,p_wor_rec.iwor_additional_safety_flag
        ,p_wor_rec.iwor_commence_by
        ,l_bud_fyr_id                        -- TASK 0108810    
        ,p_wor_rec.iwor_descr
        ,''
        ,''
        ,p_wor_rec.iwor_remarks);

  RETURN l_trans_id;

END;


---------------------------------------------------------------------
-- Clear all data stored in the PL/SQL tables and reset the indexes
--
PROCEDURE clear_tables IS
BEGIN

  FOR l_index IN 0..g_wor_index LOOP

    g_wor_tab(l_index).iwor_transaction_id := NULL;
    g_wor_tab(l_index).iwor_transaction_type := NULL;
    g_wor_tab(l_index).iwor_works_order_no := NULL;
    g_wor_tab(l_index).iwor_flag := NULL;
    g_wor_tab(l_index).iwor_scheme_type := NULL;
    g_wor_tab(l_index).iwor_con_code := NULL;
    g_wor_tab(l_index).iwor_originator := NULL;
    g_wor_tab(l_index).iwor_date_confirmed := NULL;
    g_wor_tab(l_index).iwor_est_complete := NULL;
    g_wor_tab(l_index).iwor_cost := NULL;
    g_wor_tab(l_index).iwor_est_labour := NULL;
    g_wor_tab(l_index).iwor_interim_payment_flag := NULL;
    g_wor_tab(l_index).iwor_risk_assessment_flag := NULL;
    g_wor_tab(l_index).iwor_method_statement_flag := NULL;
    g_wor_tab(l_index).iwor_works_programme_flag := NULL;
    g_wor_tab(l_index).iwor_additional_safety_flag := NULL;
    g_wor_tab(l_index).iwor_commence_by := NULL;
    g_wor_tab(l_index).iwor_descr := NULL;
    g_wor_tab(l_index).iwor_remarks := NULL;

  END LOOP;

  FOR l_index IN 0..g_wol_index LOOP

    g_wol_tab(l_index).r_wol_id := NULL;
    g_wol_tab(l_index).r_wor_no := NULL;
    g_wol_tab(l_index).r_defect_id := NULL;
    g_wol_tab(l_index).r_schd_id := NULL;
    g_wol_tab(l_index).r_work_code := NULL;
    g_wol_tab(l_index).r_road_id := NULL;
    g_wol_tab(l_index).r_road_descr := NULL;
    g_wol_tab(l_index).r_wol_descr := NULL;

  END LOOP;

  g_wol_index := 0;
  g_wor_index := 0;

END;


---------------------------------------------------------------------
-- Copy the data in the PL/SQL tables to the interface tables creating
-- header records where necessary.
--
PROCEDURE copy_data_to_interface IS

  CURSOR c1(p_wor_no work_orders.wor_works_order_no%TYPE) IS
    SELECT wor_flag
        ,wor_scheme_type
        ,con_code
        ,hus_name
        ,wor_date_confirmed
        ,wor_est_complete
        ,DECODE(hig.get_sysopt('CIMALLEST'), 'Y', wor_est_cost, NVL(wor_act_cost, wor_est_cost)) -- Task 0109080
        ,wor_est_labour
        ,wor_interim_payment_flag
        ,wor_risk_assessment_flag
        ,wor_method_statement_flag
        ,wor_works_programme_flag
        ,wor_additional_safety_flag
        ,wor_commence_by
        ,wor_descr
        ,wor_remarks
    FROM   contracts
        ,hig_users
        ,work_orders
    WHERE  wor_peo_person_id = hus_user_id
    AND    wor_con_id = con_id
    AND    wor_works_order_no = p_wor_no;

  l_header_found    boolean := FALSE;
  l_trans_id    interface_wor.iwor_transaction_id%TYPE;

BEGIN

  FOR l_index IN 0..g_wor_index - 1 LOOP

    IF g_wor_tab(l_index).iwor_transaction_type IN ('C', 'D') THEN

      l_trans_id := create_header(g_wor_tab(l_index));
      pop_wor_file_tabs(l_trans_id
                 ,g_wor_tab(l_index).iwor_works_order_no);
    END IF;

  END LOOP;

  FOR l_wol_index IN 0..g_wol_index - 1 LOOP

    l_header_found := FALSE;
    FOR l_wor_index IN 0..g_wor_index - 1 LOOP

      IF g_wor_tab(l_wor_index).iwor_works_order_no = g_wol_tab(l_wol_index).r_wor_no AND
         g_wor_tab(l_wor_index).iwor_transaction_type = 'A' THEN

        l_header_found := TRUE;
        EXIT;

      END IF;

    END LOOP;

    IF NOT l_header_found THEN
    OPEN c1(g_wol_tab(l_wol_index).r_wor_no);
    FETCH c1 INTO g_wor_tab(g_wor_index).iwor_flag
             ,g_wor_tab(g_wor_index).iwor_scheme_type
             ,g_wor_tab(g_wor_index).iwor_con_code
             ,g_wor_tab(g_wor_index).iwor_originator
             ,g_wor_tab(g_wor_index).iwor_date_confirmed
             ,g_wor_tab(g_wor_index).iwor_est_complete
             ,g_wor_tab(g_wor_index).iwor_cost
             ,g_wor_tab(g_wor_index).iwor_est_labour
             ,g_wor_tab(g_wor_index).iwor_interim_payment_flag
             ,g_wor_tab(g_wor_index).iwor_risk_assessment_flag
             ,g_wor_tab(g_wor_index).iwor_method_statement_flag
             ,g_wor_tab(g_wor_index).iwor_works_programme_flag
             ,g_wor_tab(g_wor_index).iwor_additional_safety_flag
             ,g_wor_tab(g_wor_index).iwor_commence_by
             ,g_wor_tab(g_wor_index).iwor_descr
             ,g_wor_tab(g_wor_index).iwor_remarks;
    IF c1%FOUND THEN
      g_wor_tab(g_wor_index).iwor_works_order_no := g_wol_tab(l_wol_index).r_wor_no;
      g_wor_tab(g_wor_index).iwor_transaction_type := 'A';
        g_wor_tab(g_wor_index).iwor_transaction_id := create_header(g_wor_tab(g_wor_index));
      g_wor_index := g_wor_index + 1;

--        RAC - Initialis the transaction id prior to any test on its value.
          g_wor_tab(g_wor_index).iwor_transaction_id := NULL;

      END IF;
    CLOSE c1;

    END IF;
  END LOOP;

  FOR l_wor_index IN 0..g_wor_index - 1 LOOP

    IF g_wor_tab(l_wor_index).iwor_transaction_type = 'A' THEN

    IF g_wor_tab(l_wor_index).iwor_transaction_id IS NULL THEN
        g_wor_tab(l_wor_index).iwor_transaction_id := create_header(g_wor_tab(l_wor_index));
    END IF;

    FOR l_wol_index IN 0..g_wol_index - 1 LOOP

      IF g_wol_tab(0).r_wor_no = g_wor_tab(l_wor_index).iwor_works_order_no THEN

        pop_wol_and_boq_tabs(g_wol_tab(0), g_wor_tab(l_wor_index).iwor_transaction_id);
        g_wol_index := g_wol_index - 1;    -- remove entry from table

        FOR l_del_index IN 0..g_wol_index - 1 LOOP
        g_wol_tab(l_del_index) := g_wol_tab(l_del_index + 1);
        END LOOP;

      END IF;

    END LOOP;

    END IF;

  END LOOP;

  clear_tables;

END;

/* Main */
BEGIN

  BEGIN

    SELECT hsc_status_code
    INTO   g_wol_comp_status
    FROM   hig_status_codes
    WHERE  hsc_domain_code = 'WORK_ORDER_LINES'
    AND    hsc_allow_feature3 = 'Y'
    AND    g_today BETWEEN NVL(hsc_start_date, g_today)
         AND NVL(hsc_end_date, g_today);

    EXCEPTION
      WHEN too_many_rows THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 241));
      WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20001, hig.get_error_message('M_MGR', 242));
  END;

  g_wol_index := 0;
  g_wor_index := 0;

END xnhcc_interfaces;
/
