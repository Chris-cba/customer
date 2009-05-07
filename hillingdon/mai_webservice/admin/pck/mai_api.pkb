CREATE OR REPLACE PACKAGE BODY mai_api AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/pck/pck/mai_api.pkb-arc   1.4   May 07 2009 17:29:48   mhuitson  $
--       Module Name      : $Workfile:   mai_api.pkb  $
--       Date into PVCS   : $Date:   May 07 2009 17:29:48  $
--       Date fetched Out : $Modtime:   May 06 2009 17:42:08  $
--       PVCS Version     : $Revision:   1.4  $
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_body_sccsid   CONSTANT  varchar2(2000) := '$Revision:   1.4  $';
  g_package_name  CONSTANT  varchar2(30)   := 'mai_api';
  --
  insert_error  EXCEPTION;
  --
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
FUNCTION get_next_id(pi_seq_name IN VARCHAR2)
  RETURN NUMBER IS
  --
  lv_query   varchar2(100) := 'select '||pi_seq_name||'.nextval from dual';
  lv_retval  number;
  --
BEGIN
  --
  EXECUTE IMMEDIATE lv_query
     INTO lv_retval;
  --
  RETURN lv_retval;
  --
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_defect(pi_defect_id IN defects.def_defect_id%TYPE)
  RETURN defects%ROWTYPE IS
  --
  lr_retval defects%ROWTYPE;
  --
BEGIN
  /*
  ||Get Defects Record.
  */
  SELECT *
    INTO lr_retval
    FROM defects
   WHERE def_defect_id = pi_defect_id
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20065,'Invalid Defect Id Supplied.');
  WHEN others
   THEN
      RAISE;
END get_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wol(pi_wol_id IN work_order_lines.wol_id%TYPE)
  RETURN work_order_lines%ROWTYPE IS
  --
  lr_retval  work_order_lines%ROWTYPE;
  --
BEGIN
  /*
  ||Get Work Order Line Record.
  */
  SELECT *
    INTO lr_retval
    FROM work_order_lines
   WHERE wol_id = pi_wol_id
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20096,'Invalid Work Order Line Id Supplied.');
  WHEN others
   THEN
      RAISE;
END get_wol;
--
-----------------------------------------------------------------------------
--
FUNCTION get_and_lock_wol(pi_wol_id IN work_order_lines.wol_id%TYPE)
  RETURN work_order_lines%ROWTYPE IS
  --
  lr_retval  work_order_lines%ROWTYPE;
  --
BEGIN
  /*
  ||Get Work Order Line Record.
  */
  SELECT *
    INTO lr_retval
    FROM work_order_lines
   WHERE wol_id = pi_wol_id
     FOR UPDATE NOWAIT
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20096,'Invalid Work Order Line Id Supplied.');
  WHEN others
   THEN
      RAISE;
END get_and_lock_wol;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wo(pi_works_order_no IN work_orders.wor_works_order_no%TYPE)
  RETURN work_orders%ROWTYPE IS
  --
  lr_retval  work_orders%ROWTYPE;
  --
BEGIN
  /*
  ||Get The Work Order Record.
  */
  SELECT *
    INTO lr_retval
    FROM work_orders
   WHERE wor_works_order_no = pi_works_order_no
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20068,'Invalid Work Order Number Supplied');
  WHEN others
   THEN
      RAISE;
END get_wo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_and_lock_wo(pi_works_order_no IN work_orders.wor_works_order_no%TYPE)
  RETURN work_orders%ROWTYPE IS
  --
  lr_retval  work_orders%ROWTYPE;
  --
BEGIN
  /*
  ||Get And Lock The Work Order Record.
  */
  SELECT *
    INTO lr_retval
    FROM work_orders
   WHERE wor_works_order_no = pi_works_order_no
     FOR UPDATE NOWAIT
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20068,'Invalid Work Order Number Supplied');
  WHEN others
   THEN
      RAISE;
END get_and_lock_wo;
--
-----------------------------------------------------------------------------
--
FUNCTION interfaces_used(pi_con_id IN contracts.con_id%TYPE)
  RETURN BOOLEAN IS
  --
  lv_retval BOOLEAN := FALSE;
  lv_flag   org_units.oun_electronic_orders_flag%TYPE;
  --
BEGIN
  --
  SELECT NVL(oun_electronic_orders_flag,'N')
    INTO lv_flag
    FROM contracts
        ,org_units
   WHERE oun_org_id = con_contr_org_id
     AND con_id = pi_con_id
       ;
  --
  IF lv_flag = 'Y'
   THEN
      lv_retval := TRUE;
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20064,'Invalid Contract On Work Order.');
  WHEN others
   THEN
      RAISE;
END interfaces_used;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_asset_security(pi_inv_type  IN nm_inv_types.nit_inv_type%TYPE
                              ,pi_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE
                              ,pi_user_id   IN hig_users.hus_user_id%TYPE) IS
  --
  ex_security  EXCEPTION;
  --
  lv_nm3_inv_type  nm_inv_types_all.nit_inv_type%TYPE;
  lr_inv_type      nm_inv_types_all%ROWTYPE;
  --
  FUNCTION check_asset_admin_unit
    RETURN BOOLEAN IS
    --
    lv_dummy NUMBER;
    --
  BEGIN
    --
    SELECT iit_ne_id
      INTO lv_dummy
      FROM nm_inv_items
     WHERE iit_ne_id = pi_iit_ne_id
       AND EXISTS(SELECT 1
                    FROM nm_admin_groups
                        ,nm_user_aus
                   WHERE nua_user_id          = pi_user_id
                     AND nua_mode             = nm3type.get_constant('c_normal')
                     AND nua_admin_unit       = nag_parent_admin_unit
                     AND nag_child_admin_unit = iit_admin_unit)
         ;
    --
    RETURN TRUE;
    --
  EXCEPTION
    WHEN others
     THEN
        RETURN FALSE;
  END;
  --
  FUNCTION check_inv_type_role
    RETURN BOOLEAN IS
    --
    lv_dummy NUMBER;
    --
  BEGIN
    --
    SELECT 1
      INTO lv_dummy
      FROM hig_users
          ,hig_user_roles
          ,nm_inv_type_roles
     WHERE itr_inv_type = lv_nm3_inv_type
       AND itr_mode     = nm3type.get_constant('c_normal')
       AND itr_hro_role = hur_role
       AND hur_username = hus_username
       AND hus_user_id  = pi_user_id
         ;
    --
    RETURN TRUE;
    --
  EXCEPTION
    WHEN others
     THEN
        RETURN FALSE;
  END check_inv_type_role;
  --
BEGIN
  /*
  ||Can't use nm3lock as the Web Service logs on as the
  ||Highways Owner so need to make sure the specified
  ||Inspector can update the asset.
  nm3lock.lock_asset_item(pi_nit_id          => pi_inv_type
                         ,pi_pk_id           => pi_iit_ne_id
                         ,pi_lock_for_update => TRUE
                         ,pi_updrdonly       => nm3lock.get_updrdonly);
  */
  /*
  ||Translate The Two Character MAI Inv Code
  ||Into a 4 Character NM3 Asset Type.
  */
  BEGIN
    lv_nm3_inv_type := mai.translate_mai_inv_type(pi_inv_type);
  EXCEPTION
    WHEN others
     THEN
        raise_application_error(-20003,'Cannot Translate Asset Type.');
  END;
  /*
  ||Get The Asset Type Details.
  */
  lr_inv_type := nm3get.get_nit(lv_nm3_inv_type);
  /*
  ||Check Inspector Security.
  */
  IF NOT check_inv_type_role
   THEN
      raise ex_security;
  END IF;
  --
  IF lr_inv_type.nit_table_name IS NULL
   THEN
      IF NOT check_asset_admin_unit
       THEN
          raise ex_security;
      END IF;
  END IF;
  --
EXCEPTION
  WHEN ex_security
   THEN
      hig.raise_ner(pi_appl => 'HIG'
                   ,pi_id   => 437);
  WHEN others
   THEN
      RAISE;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_network_security(pi_ne_id IN nm_elements_all.ne_id%TYPE) IS
  --
  ex_security  EXCEPTION;
  PRAGMA       exception_init(ex_security,-20000);
  --
BEGIN
  --
  nm3lock.lock_element(p_ne_id               => pi_ne_id
                      ,p_lock_ele_for_update => TRUE
                      ,p_updrdonly           => nm3lock.get_updrdonly);
  --
EXCEPTION
  WHEN ex_security
   THEN
      hig.raise_ner(pi_appl => 'HIG'
                   ,pi_id   => 436);
  WHEN others
   THEN
      RAISE;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_asset(pi_item_type defects.def_ity_inv_code%TYPE
                       ,pi_item_id   nm_inv_items_all.iit_ne_id%TYPE)
  RETURN BOOLEAN IS
  --
  lv_nm3_inv_type  nm_inv_types_all.nit_inv_type%TYPE;
  lv_ft_id         NUMBER;
  lv_retval        BOOLEAN;
  lv_sql           nm3type.max_varchar2;
  --
  lr_inv_type  nm_inv_types_all%ROWTYPE;
  lr_nm3_asset nm_inv_items_all%ROWTYPE;
  --
BEGIN
  /*
  ||Translate The Two Character MAI Inv Code
  ||Into a 4 Character NM3 Asset Type.
  */
  BEGIN
    lv_nm3_inv_type := mai.translate_mai_inv_type(pi_item_type);
  EXCEPTION
    WHEN others
     THEN
        raise_application_error(-20003,'Cannot Translate Asset Type.');
  END;
  /*
  ||Get The Asset Type Details.
  */
  lr_inv_type := nm3get.get_nit(lv_nm3_inv_type);
  /*
  ||Check The Asset Exists.
  */
  IF lr_inv_type.nit_table_name IS NOT NULL
   THEN
      /*
      ||Build SQL To Check FT Asset.
      */
      lv_sql := 'SELECT '||lr_inv_type.nit_lr_ne_column_name
              ||'  FROM '||lr_inv_type.nit_table_name
              ||' WHERE '||lr_inv_type.nit_lr_ne_column_name||'='||pi_item_id;
      /*
      ||Execute SQL.
      */
      EXECUTE IMMEDIATE(lv_sql) INTO lv_ft_id;
      /*
      ||Check The Value Returned.
      */
      IF lv_ft_id IS NOT NULL
       THEN
          lv_retval := TRUE;
      ELSE
          lv_retval := FALSE;
      END IF;
      --
  ELSE
      /*
      ||Check nm3 Asset.
      */
      lr_nm3_asset := nm3inv.get_inv_item_all(pi_item_id);
      lv_retval := TRUE;
  END IF;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN others
   THEN
     RETURN FALSE;
END validate_asset;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_section(pi_rse_he_id IN nm_elements_all.ne_id%TYPE)
  RETURN road_sections%ROWTYPE IS
  --
  lv_retval road_sections%ROWTYPE;
  --
BEGIN
  --
  check_network_security(pi_ne_id => pi_rse_he_id);
  --
  SELECT rse.*
    INTO lv_retval
    FROM road_sections rse
   WHERE rse.rse_he_id = pi_rse_he_id
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20005,'Invalid Section Specified.');
  WHEN others
   THEN
      RAISE;
END validate_section;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_chainage(pi_chainage   IN NUMBER
                           ,pi_rse_length IN NUMBER) IS
BEGIN
  --
  IF pi_chainage < 0
   THEN
      --
      raise_application_error(-20006,'Value Is Less Than Zero.');
      --
  ELSIF pi_chainage > pi_rse_length
   THEN
      --
      raise_application_error(-20007,'Value Is Greater Than Section Length.');
      --
  END IF;
  --
END validate_chainage;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_user_id(pi_user_id        IN hig_users.hus_user_id%TYPE
                         ,pi_effective_date IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy NUMBER;
  --
BEGIN
  --
  SELECT 1
    INTO lv_dummy
    FROM hig_users
   WHERE pi_effective_date BETWEEN NVL(hus_start_date,pi_effective_date)
                               AND NVL(hus_end_date-1,pi_effective_date)
     AND hus_user_id = pi_user_id
       ;
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_user_id;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_initiation_type(pi_initiation_type IN activities_report.are_initiation_type%TYPE
                                 ,pi_effective_date  IN DATE)
  RETURN BOOLEAN IS
BEGIN
  --
  hig.valid_fk_hco(pi_hco_domain     => 'INITIATION_TYPE'
                  ,pi_hco_code       => pi_initiation_type
                  ,pi_effective_date => pi_effective_date);
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN FALSE;
END validate_initiation_type;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_asset_activity(pi_inv_type        IN defects.def_ity_inv_code%TYPE
                                ,pi_maint_insp_flag IN activities.atv_maint_insp_flag%TYPE
                                ,pi_sys_flag        IN VARCHAR2
                                ,pi_activity        IN activities.atv_acty_area_code%TYPE)
  RETURN BOOLEAN IS
  --
  lv_dummy  NUMBER;
  lv_retval BOOLEAN := TRUE;
  --
BEGIN
  --
  SELECT 1
    INTO lv_dummy
    FROM activities
        ,mai_inv_activities
   WHERE mia_sys_flag           = pi_sys_flag
     AND mia_nit_inv_type       = pi_inv_type
     AND mia_atv_acty_area_code = pi_activity
     AND mia_sys_flag           = atv_dtp_flag
     AND mia_atv_acty_area_code = atv_acty_area_code
     AND atv_maint_insp_flag    = pi_maint_insp_flag
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_asset_activity;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_network_activity(pi_maint_insp_flag IN activities.atv_maint_insp_flag%TYPE
                                  ,pi_sys_flag        IN VARCHAR2
                                  ,pi_activity        IN activities.atv_acty_area_code%TYPE
                                  ,pi_effective_date  IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy  NUMBER;
  lv_retval BOOLEAN := TRUE;
  --
BEGIN
  --
  SELECT 1
    INTO lv_dummy
    FROM activities
   WHERE atv_dtp_flag        = pi_sys_flag
     AND atv_maint_insp_flag = pi_maint_insp_flag
     AND atv_acty_area_code  = pi_activity
     AND pi_effective_date BETWEEN NVL(atv_start_date,pi_effective_date)
                               AND NVL(atv_end_date  ,pi_effective_date)
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_network_activity;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_weather_condition(pi_weather_condition IN activities_report.are_weather_condition%TYPE
                                   ,pi_effective_date    IN DATE)
  RETURN BOOLEAN IS
BEGIN
  --
  hig.valid_fk_hco(pi_hco_domain     => 'WEATHER_CONDITION'
                  ,pi_hco_code       => pi_weather_condition
            ,pi_effective_date => pi_effective_date);
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN FALSE;
END validate_weather_condition;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_surface_condition(pi_surface_condition IN activities_report.are_surface_condition%TYPE
                                   ,pi_effective_date    IN DATE)
  RETURN BOOLEAN IS
BEGIN
  --
  hig.valid_fk_hco(pi_hco_domain     => 'SURFACE_CONDITION'
                  ,pi_hco_code       => pi_surface_condition
            ,pi_effective_date => pi_effective_date);
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN others
   THEN
      RETURN FALSE;
END validate_surface_condition;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_maint_insp_flag(pi_maint_insp_flag IN VARCHAR2)
  RETURN BOOLEAN IS
BEGIN
  --
  IF pi_maint_insp_flag IN('S','D')
   THEN
      RETURN TRUE;
  ELSE
      RETURN FALSE;
  END IF;
  --
END validate_maint_insp_flag;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_defect_type(pi_activity       IN activities.atv_acty_area_code%TYPE
                             ,pi_sys_flag       IN VARCHAR2
                             ,pi_defect_type    IN def_types.dty_defect_code%TYPE
                             ,pi_effective_date IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy  NUMBER;
  --
BEGIN
  /*
  ||Check The Parameters.
  */
  IF pi_activity IS NULL
   THEN
      --
      raise_application_error(-20016,'No Activity Supplied.');
      --
  ELSIF pi_sys_flag IS NULL
   THEN
      --
      raise_application_error(-20019,'No Sys Flag Supplied.');
      --
  ELSIF pi_effective_date IS NULL
   THEN
      --
      raise_application_error(-20008,'No Inspection Date Supplied.');
      --
  END IF;
  /*
  ||Check The Defect Type.
  */
  SELECT 1
    INTO lv_dummy
    FROM def_types
   WHERE dty_defect_code = pi_defect_type
     AND dty_dtp_flag    = pi_sys_flag
     AND dty_atv_acty_area_code = pi_activity
     AND pi_effective_date BETWEEN NVL(dty_start_date,pi_effective_date)
                               AND NVL(dty_end_date  ,pi_effective_date)
       ;
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_defect_type;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_priority(pi_priority           IN defects.def_priority%TYPE
                          ,pi_atv_acty_area_code IN activities.atv_acty_area_code%TYPE
                          ,pi_action_cat         IN repairs.rep_action_cat%TYPE DEFAULT 'P'
                          ,pi_effective_date     IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy NUMBER;
  --
BEGIN
  --
  SELECT 1
    INTO lv_dummy
    FROM hig_codes
        ,defect_priorities
   WHERE dpr_priority           = pi_priority
     AND dpr_atv_acty_area_code = pi_atv_acty_area_code
     AND dpr_action_cat         = pi_action_cat
     AND dpr_priority           = hco_code
     AND hco_domain             = 'DEFECT_PRIORITIES'
     AND pi_effective_date BETWEEN NVL(hco_start_date,pi_effective_date)
                               AND NVL(hco_end_date  ,pi_effective_date)
       ;
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_priority;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_siss_id(pi_siss_id        IN standard_item_sub_sections.siss_id%TYPE
                         ,pi_effective_date IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy NUMBER;
  --
BEGIN
  --
  SELECT 1
    INTO lv_dummy
    FROM standard_item_sub_sections
   WHERE pi_effective_date BETWEEN NVL(siss_start_date,pi_effective_date)
                               AND NVL(siss_end_date,pi_effective_date)
     AND siss_id = pi_siss_id
       ;
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_siss_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_defect_priority(pi_rep_action_cat     IN repairs.rep_action_cat%TYPE
                            ,pi_atv_acty_area_code IN activities.atv_acty_area_code%TYPE
                            ,pi_def_priority       IN defects.def_priority%TYPE
                            ,pi_effective_date     IN DATE)
  RETURN defect_priorities%ROWTYPE IS
  --
  lr_retval defect_priorities%ROWTYPE;
  --
BEGIN
  --
  SELECT dpr.*
    INTO lr_retval
    FROM hig_codes
        ,defect_priorities dpr
   WHERE dpr.dpr_priority           = pi_def_priority
     AND dpr.dpr_atv_acty_area_code = pi_atv_acty_area_code
     AND dpr.dpr_action_cat         = hco_code
     AND hco_code                   = pi_rep_action_cat
     AND hco_domain                 = 'REPAIR_TYPE'
     AND pi_effective_date BETWEEN NVL(hco_start_date,pi_effective_date)
                               AND NVL(hco_end_date  ,pi_effective_date)
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN lr_retval;
  WHEN others
   THEN
      RAISE;
END get_defect_priority;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_treatment(pi_treatment          IN treatments.tre_treat_code%TYPE
                           ,pi_sys_flag           IN VARCHAR2
                           ,pi_atv_acty_area_code IN activities.atv_acty_area_code%TYPE
                           ,pi_defect_type        IN def_types.dty_defect_code%TYPE
                           ,pi_effective_date     IN DATE)
  RETURN BOOLEAN IS
  --
  lv_dummy  NUMBER;
  --
BEGIN
  /*
  ||Check The Parameters.
  */
  IF pi_defect_type IS NULL
   THEN
      --
      raise_application_error(-20024,'No Defect Type Supplied.');
      --
  ELSIF pi_atv_acty_area_code IS NULL
   THEN
      --
      raise_application_error(-20016,'No Activity Supplied.');
      --
  ELSIF pi_sys_flag IS NULL
   THEN
      --
      raise_application_error(-20019,'No Sys Flag Supplied.');
      --
  ELSIF pi_effective_date IS NULL
   THEN
      --
      raise_application_error(-20008,'No Inspection Date Supplied.');
      --
  END IF;
  /*
  ||Check The Treatment.
  */
  SELECT 1
    INTO lv_dummy
    FROM def_treats
        ,treatments
   WHERE tre_treat_code         = pi_treatment
     AND tre_treat_code         = dtr_tre_treat_code
     AND dtr_sys_flag           = pi_sys_flag
     AND dtr_dty_acty_area_code = pi_atv_acty_area_code
     AND dtr_dty_defect_code    = pi_defect_type
     AND pi_effective_date BETWEEN NVL(tre_start_date,pi_effective_date)
                               AND NVL(tre_end_date  ,pi_effective_date)
       ;
  --
  RETURN TRUE;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN FALSE;
  WHEN others
   THEN
      RAISE;
END validate_treatment;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_insp(pio_insp_rec IN OUT activities_report%ROWTYPE)
  IS
  --
  lr_insp_rec  activities_report%ROWTYPE;
  lr_rse       road_sections%ROWTYPE;
  --
  lv_insp_init    hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_INIT'),'DUM');
  lv_insp_sdf     hig_options.hop_value%TYPE := NVL(hig.get_sysopt('INSP_SDF'),'D');
  --
BEGIN
  --
  lr_insp_rec := pio_insp_rec;
  /*
  ||Validate The Section.
  */
  IF lr_insp_rec.are_rse_he_id IS NULL
   THEN
      raise_application_error(-20004,'No Section Supplied.');
  ELSE
      lr_rse := validate_section(lr_insp_rec.are_rse_he_id);
  END IF;
  /*
  ||Default Or Validate The Start Chainage.
  */
  IF lr_insp_rec.are_st_chain IS NULL
   THEN
      lr_insp_rec.are_st_chain := 0;
  ELSE
      validate_chainage(pi_chainage   => lr_insp_rec.are_st_chain
                       ,pi_rse_length => lr_rse.rse_length);
  END IF;
  /*
  ||Default Or Validate The End Chainage.
  */
  IF lr_insp_rec.are_end_chain IS NULL
   THEN
      lr_insp_rec.are_end_chain := lr_rse.rse_length;
  ELSE
      validate_chainage(pi_chainage   => lr_insp_rec.are_end_chain
                       ,pi_rse_length => lr_rse.rse_length);
  END IF;
  /*
  ||Check Scheduled Activity Flag
  */
  IF lr_insp_rec.are_sched_act_flag IS NULL
   THEN
      lr_insp_rec.are_sched_act_flag := 'Y';
  END IF;
  /*
  ||Validate Inspection Date.
  */
  IF lr_insp_rec.are_date_work_done IS NULL
   THEN
      --
      raise_application_error(-20008,'No Inspection Date Supplied.');
      --
  ELSIF lr_insp_rec.are_date_work_done >= SYSDATE
   THEN
      --
      raise_application_error(-20009,'Inspection Date May Not Be Later Than Today.'); --(843,'M_MGR')
      --
  end if;
  /*
  ||Validate Inspectors User Id.
  */
  IF NOT validate_user_id(pi_user_id        => lr_insp_rec.are_peo_person_id_actioned
                         ,pi_effective_date => lr_insp_rec.are_date_work_done)
   THEN
      --
      raise_application_error(-20010,'Invalid User Id Specified For Inspector.');
      --
  END IF;
  /*
  ||Validate Second Inspectors User Id.
  */
  IF lr_insp_rec.are_peo_person_id_insp2 IS NOT NULL
   AND NOT validate_user_id(pi_user_id        => lr_insp_rec.are_peo_person_id_insp2
                           ,pi_effective_date => lr_insp_rec.are_date_work_done)
   THEN
      --
      raise_application_error(-20011,'Invalid User Id Specified For Second Inspector.');
      --
  END IF;
  /*
  ||Validate Or Default The Initiation Type.
  */
  IF lr_insp_rec.are_initiation_type IS NULL
   THEN
      lr_insp_rec.are_initiation_type := lv_insp_init;
  END IF;
  --
  IF NOT validate_initiation_type(pi_initiation_type => lr_insp_rec.are_initiation_type
                                 ,pi_effective_date  => lr_insp_rec.are_date_work_done)
   THEN
      raise_application_error(-20012,'Invalid Initiation Type Specified.');
  END IF;
  --
  /*
  ||Validate Or Default The Safety/Detailed Flag.
  */
  IF lr_insp_rec.are_maint_insp_flag IS NULL
   THEN
      lr_insp_rec.are_maint_insp_flag := lv_insp_sdf;
  END IF;
  --
  IF NOT validate_maint_insp_flag(lr_insp_rec.are_maint_insp_flag)
   THEN
      raise_application_error(-20013,'Invalid Safety/Detailed Flag Specified.');
  END IF;
  /*
  ||Validate Weather Condition.
  */
  IF lr_insp_rec.are_weather_condition IS NOT NULL
   THEN
      IF NOT validate_weather_condition(pi_weather_condition => lr_insp_rec.are_weather_condition
                                       ,pi_effective_date    => lr_insp_rec.are_date_work_done)
       THEN
          raise_application_error(-20015,'Invalid Weather Condition Specified.');
      END IF;
  END IF;
  /*
  ||Validate Surface Condition.
  */
  IF lr_insp_rec.are_surface_condition IS NOT NULL
   THEN
      IF NOT validate_surface_condition(pi_surface_condition => lr_insp_rec.are_surface_condition
                                       ,pi_effective_date    => lr_insp_rec.are_date_work_done)
       THEN
          raise_application_error(-20015,'Invalid Road Surface Condition Specified.');
      END IF;
  END IF;
  /*
  ||Assign The Validated Record To The Output Record.
  */
  pio_insp_rec := lr_insp_rec;
  --
END validate_insp;
--
-----------------------------------------------------------------------------
--
FUNCTION check_for_insp(pi_insp_rec activities_report%ROWTYPE )
  RETURN activities_report.are_report_id%TYPE IS
  --
  lv_retval activities_report.are_report_id%TYPE;
  --
BEGIN
  --
  SELECT are_report_id
    INTO lv_retval
    FROM activities_report
   WHERE are_rse_he_id              = pi_insp_rec.are_rse_he_id
     AND are_initiation_type        = pi_insp_rec.are_initiation_type
     AND are_maint_insp_flag        = pi_insp_rec.are_maint_insp_flag
     AND are_date_work_done         = pi_insp_rec.are_date_work_done
     AND are_peo_person_id_actioned = pi_insp_rec.are_peo_person_id_actioned
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      RETURN NULL;
  WHEN others
   THEN
      RAISE;
END check_for_insp;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sta(pi_sta_item_code IN standard_items.sta_item_code%TYPE)
  RETURN standard_items%ROWTYPE IS
  --
  lr_retval standard_items%ROWTYPE;
  --
BEGIN
  --
  SELECT *
    INTO lr_retval
    FROM standard_items
   WHERE sta_item_code = pi_sta_item_code
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20033,'Cannot Find Specfied Standard Item.');
  WHEN others
   THEN
      RAISE;
END get_sta;
--
-----------------------------------------------------------------------------
--
FUNCTION get_insp(pi_insp_id IN activities_report.are_report_id%TYPE)
  RETURN activities_report%ROWTYPE IS
  --
  lr_retval activities_report%ROWTYPE;
  --
BEGIN
  --
  SELECT *
    INTO lr_retval
    FROM activities_report
   WHERE are_report_id = pi_insp_id
       ;
  --
  RETURN lr_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20037,'Cannot Find Specfied Inspection.');
  WHEN others
   THEN
      RAISE;
END get_insp;
--
-----------------------------------------------------------------------------
--
FUNCTION get_initial_defect_status
  RETURN hig_status_codes.hsc_status_code%TYPE IS
  --
  lv_retval  hig_status_codes.hsc_status_code%TYPE;
  --
BEGIN
  --
  SELECT hsc_status_code
    INTO lv_retval
    FROM hig_status_codes
   WHERE hsc_domain_code = 'DEFECTS'
     AND hsc_allow_feature1 = 'Y'
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20020,'Cannot Find Initial Defect Status.');
  WHEN others
   THEN
      RAISE;
END get_initial_defect_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_complete_defect_status
  RETURN hig_status_codes.hsc_status_code%TYPE IS
  --
  lv_retval  hig_status_codes.hsc_status_code%TYPE;
  --
BEGIN
  --
  SELECT hsc_status_code
    INTO lv_retval
    FROM hig_status_codes
   WHERE hsc_domain_code = 'DEFECTS'
     AND hsc_allow_feature4 = 'Y'
       ;
  --
  RETURN lv_retval;
  --
EXCEPTION
  WHEN no_data_found
   THEN
      raise_application_error(-20021,'Cannot Find Complete Defect Status.');
  WHEN others
   THEN
      RAISE;
END get_complete_defect_status;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_defect_status(pi_defect_rec     IN defects%ROWTYPE
                               ,pi_effective_date IN DATE)
  RETURN BOOLEAN IS
  --
  lv_retval  BOOLEAN := FALSE;
  --
BEGIN
  /*
  ||Defects Can Be Created With Either
  ||The Initial Or Completed Status Code.
  */
  IF pi_defect_rec.def_status_code = get_initial_defect_status
   OR pi_defect_rec.def_status_code = get_complete_defect_status
   THEN
      lv_retval := TRUE;
  END IF;
  --
  RETURN lv_retval;
  --
END validate_defect_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_defect(pi_are_report_id       IN     activities_report.are_report_id%TYPE
                         ,pi_are_rse_he_id       IN     activities_report.are_rse_he_id%TYPE
                         ,pi_are_date_work_done  IN     activities_report.are_date_work_done%TYPE
                         ,pi_are_maint_insp_flag IN     activities_report.are_maint_insp_flag%TYPE
                         ,pi_def_attr_tab        IN     def_attr_tab)
  IS
  --
  lr_rse         road_sections%ROWTYPE;
  --
  lv_siss  hig_options.hop_value%TYPE := NVL(hig.get_sysopt('DEF_SISS'),'ALL');
  --
  lv_def_attr1 VARCHAR2(254);
  lv_def_attr2 VARCHAR2(254);
  lv_def_attr3 VARCHAR2(254);
  lv_def_attr4 VARCHAR2(254);
  --
  PROCEDURE process_def_attr(pi_def_type  IN def_types.dty_defect_code%TYPE
                            ,pi_activity  IN def_types.dty_atv_acty_area_code%TYPE
                            ,pi_sys_flag  IN def_types.dty_dtp_flag%TYPE
                            ,pi_def_attr1 IN VARCHAR2
                            ,pi_def_attr2 IN VARCHAR2
                            ,pi_def_attr3 IN VARCHAR2
                            ,pi_def_attr4 IN VARCHAR2) IS
    --
    lr_def_types  def_types%ROWTYPE;
    lv_attr       VARCHAR2(20);
    --
    PROCEDURE set_attribute(pi_column IN VARCHAR2
                           ,pi_value  IN VARCHAR2)
      IS
      --
      lv_data_type  all_tab_columns.data_type%TYPE;
      lv_column_assign VARCHAR2(100) := 'BEGIN mai_api.gr_defect_rec.'||pi_column||' := ';
      --
    BEGIN
      nm_debug.debug('ATTR Column = '||pi_column);
      nm_debug.debug('ATTR Value = '||pi_value);
      /*
      ||Get The Datatype Of The Column.
      */
      SELECT data_type
        INTO lv_data_type
        FROM all_tab_columns
       WHERE table_name  = 'DEFECTS'
         AND column_name = pi_column
         AND owner = hig.get_application_owner
           ;
      /*
      ||Set The Value.
      */
      nm_debug.debug('ATTR Datatype = '||lv_data_type);

      IF lv_data_type = 'NUMBER'
       THEN
          --
          EXECUTE IMMEDIATE lv_column_assign||'TO_NUMBER('||pi_value||'); END;';
          --
      ELSIF lv_data_type = 'DATE'
       THEN
          --
          EXECUTE IMMEDIATE lv_column_assign||'TO_DATE('||nm3flx.string(pi_value)
                                                   ||','||nm3flx.string('DD-MON-YYYY')||');';
          --
      ELSE
          --
          EXECUTE IMMEDIATE lv_column_assign||pi_value||';';
          --
      END IF;
      --
    EXCEPTION
      WHEN others
       THEN
          raise_application_error(-20045,'Invalid Defect Attribute Value Specified. ['||lv_attr||']');
    END set_attribute;
  BEGIN
    /*
    ||Get Attribute Details
    */
    SELECT *
      INTO lr_def_types
      FROM def_types
     WHERE dty_defect_code        = pi_def_type
       AND dty_atv_acty_area_code = pi_activity
       AND dty_dtp_flag           = pi_sys_flag
         ;
    /*
    ||Validate The Attributes
    ||And Assign To Defect Record.
    */
    IF lr_def_types.dty_hh_attribute_1 IS NOT NULL
     AND pi_def_attr1 IS NOT NULL
     THEN
        lv_attr := 'Attribute 1';
        set_attribute(pi_column => lr_def_types.dty_hh_attribute_1
                     ,pi_value  => pi_def_attr1);
    END IF;
    --
    IF lr_def_types.dty_hh_attribute_2 IS NOT NULL
     AND pi_def_attr2 IS NOT NULL
     THEN
        lv_attr := 'Attribute 2';
        set_attribute(pi_column => lr_def_types.dty_hh_attribute_2
                     ,pi_value  => pi_def_attr2);
    END IF;
    --
    IF lr_def_types.dty_hh_attribute_3 IS NOT NULL
     AND pi_def_attr3 IS NOT NULL
     THEN
        lv_attr := 'Attribute 3';
        set_attribute(pi_column => lr_def_types.dty_hh_attribute_3
                     ,pi_value  => pi_def_attr3);
    END IF;
    --
    IF lr_def_types.dty_hh_attribute_4 IS NOT NULL
     AND pi_def_attr4 IS NOT NULL
     THEN
        lv_attr := 'Attribute 4';
        set_attribute(pi_column => lr_def_types.dty_hh_attribute_4
                     ,pi_value  => pi_def_attr4);
    END IF;
  END process_def_attr;
BEGIN
  --
  nm_debug.debug('Validate Defect');
  /*
  ||Validate/Default The Inspection Id.
  */
  nm_debug.debug('Insp Id');
  IF gr_defect_rec.def_are_report_id IS NULL
   OR gr_defect_rec.def_are_report_id != pi_are_report_id
   THEN
      gr_defect_rec.def_are_report_id := pi_are_report_id;
  END IF;
  /*
  ||Validate The Section.
  */
  nm_debug.debug('Section');
  IF gr_defect_rec.def_rse_he_id IS NULL
   THEN
      --
      raise_application_error(-20004,'No Section Supplied.');
      --
  ELSIF gr_defect_rec.def_rse_he_id != pi_are_rse_he_id
   THEN
      --
      raise_application_error(-20038,'Defect Section Must Match The Inspection Section.');
      --
  ELSE
      --
      lr_rse := validate_section(gr_defect_rec.def_rse_he_id);
      gr_defect_rec.def_ity_sys_flag := lr_rse.rse_sys_flag;
      --
  END IF;
  /*
  ||Validate Activity Code.
  */
  nm_debug.debug('Activity');
  IF gr_defect_rec.def_iit_item_id IS NOT NULL
   THEN
      IF NOT validate_asset_activity(pi_inv_type        => gr_defect_rec.def_ity_inv_code
                                    ,pi_maint_insp_flag => pi_are_maint_insp_flag
                                    ,pi_sys_flag        => lr_rse.rse_sys_flag
                                    ,pi_activity        => gr_defect_rec.def_atv_acty_area_code)
       THEN
          raise_application_error(-20017,'Invalid Asset Activity Code Supplied.');
      END IF;
  ELSE
      IF NOT validate_network_activity(pi_maint_insp_flag => pi_are_maint_insp_flag
                                      ,pi_sys_flag        => lr_rse.rse_sys_flag
                                      ,pi_activity        => gr_defect_rec.def_atv_acty_area_code
                                      ,pi_effective_date  => pi_are_date_work_done)
       THEN
          raise_application_error(-20018,'Invalid Network Activity Code Supplied.');
      END IF;
  END IF;
  /*
  ||Validate Defect Type.
  */
  nm_debug.debug('Defect Type');
  IF gr_defect_rec.def_defect_code IS NULL
   THEN
      raise_application_error(-20024,'No Defect Type Supplied.');
  ELSE
     IF NOT validate_defect_type(pi_activity       => gr_defect_rec.def_atv_acty_area_code
                                ,pi_sys_flag       => lr_rse.rse_sys_flag
                                ,pi_defect_type    => gr_defect_rec.def_defect_code
                                ,pi_effective_date => pi_are_date_work_done)
      THEN
         raise_application_error(-20025,'Invalid Defect Type Supplied.');
     END IF;
  END IF;
  /*
  ||Default  SISS Code.
  */
  nm_debug.debug('SISS');
  IF gr_defect_rec.def_siss_id IS NULL
   THEN
      gr_defect_rec.def_siss_id := lv_siss;
  END IF;
  --
  IF NOT validate_siss_id(pi_siss_id        => gr_defect_rec.def_siss_id
                         ,pi_effective_date => pi_are_date_work_done)
   THEN
      --
      raise_application_error(-20028,'Invalid SISS Id Specified.');
      --
  END IF;
  /*
  ||Validate Priority.
  */
  nm_debug.debug('Priority');
  IF gr_defect_rec.def_priority IS NULL
   THEN
      --
      raise_application_error(-20026,'No Priority Specified.');
      --
  END IF;
  --
  IF NOT validate_priority(pi_priority           => gr_defect_rec.def_priority
                          ,pi_atv_acty_area_code => gr_defect_rec.def_atv_acty_area_code
                          ,pi_effective_date     => pi_are_date_work_done)
   THEN
      --
      raise_application_error(-20027,'Invalid Priority Specified. Priority ['||gr_defect_rec.def_priority
                                   ||'] Activity ['||gr_defect_rec.def_atv_acty_area_code||']');
      --
  END IF;
  gr_defect_rec.def_orig_priority := gr_defect_rec.def_priority;
  /*
  ||Set The Created Date Fields
  */
  nm_debug.debug('Dates');
  IF gr_defect_rec.def_created_date IS NULL
   THEN
      gr_defect_rec.def_created_date := TRUNC(pi_are_date_work_done);
      gr_defect_rec.def_time_hrs     := 0;
      gr_defect_rec.def_time_mins    := 0;
  END IF;
  /*
  ||Default / Validate Defect Status.
  */
  nm_debug.debug('Status');
  IF gr_defect_rec.def_status_code IS NULL
   THEN
      /*
      ||If A Completion Date Has Been Supplied
      ||Set The Status To Complete, Otherwise
      ||Set The Status To Available.
      */
      IF gr_defect_rec.def_date_compl IS NULL
       THEN
          gr_defect_rec.def_status_code := get_initial_defect_status;
      ELSE
          gr_defect_rec.def_status_code := get_complete_defect_status;
      END IF;
  END IF;
  --
  IF gr_defect_rec.def_status_code = get_complete_defect_status
   AND gr_defect_rec.def_date_compl IS NULL
   THEN
      gr_defect_rec.def_date_compl := gr_defect_rec.def_created_date;
  END IF;
  --
  IF NOT validate_defect_status(pi_defect_rec     => gr_defect_rec
                               ,pi_effective_date => pi_are_date_work_done)
   THEN
      --
      raise_application_error(-20022,'Invalid Defect Status Specified.');
      --
  END IF;
  /*
  ||Assign The Attributes.
  */
  CASE
    WHEN pi_def_attr_tab.count = 1
     THEN
        lv_def_attr1 := pi_def_attr_tab(1);
    WHEN pi_def_attr_tab.count = 2
     THEN
        lv_def_attr1 := pi_def_attr_tab(1);
        lv_def_attr2 := pi_def_attr_tab(2);
    WHEN pi_def_attr_tab.count = 3
     THEN
        lv_def_attr1 := pi_def_attr_tab(1);
        lv_def_attr2 := pi_def_attr_tab(2);
        lv_def_attr3 := pi_def_attr_tab(3);
    WHEN pi_def_attr_tab.count >= 4
     THEN
        lv_def_attr1 := pi_def_attr_tab(1);
        lv_def_attr2 := pi_def_attr_tab(2);
        lv_def_attr3 := pi_def_attr_tab(3);
        lv_def_attr4 := pi_def_attr_tab(4);
  END CASE;
  --
  process_def_attr(pi_def_type  => gr_defect_rec.def_defect_code
                  ,pi_activity  => gr_defect_rec.def_atv_acty_area_code
                  ,pi_sys_flag  => lr_rse.rse_sys_flag
                  ,pi_def_attr1 => lv_def_attr1
                  ,pi_def_attr2 => lv_def_attr2
                  ,pi_def_attr3 => lv_def_attr3
                  ,pi_def_attr4 => lv_def_attr4);
  nm_debug.debug('Defect Validation Complete');
  --
END validate_defect;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_repair_boqs(pi_def_defect_id      IN     defects.def_defect_id%TYPE
                              ,pi_rep_action_cat     IN     repairs.rep_action_cat%TYPE
                              ,pi_rep_created_date   IN     repairs.rep_created_date%TYPE
                              ,pi_admin_unit         IN     nm_admin_units.nau_admin_unit%TYPE
                              ,pi_rep_tre_treat_code IN     treatments.tre_treat_code%TYPE
                              ,pi_atv_acty_area_code IN     activities.atv_acty_area_code%TYPE
                              ,pi_def_defect_code    IN     defects.def_defect_code%TYPE
                              ,pi_sys_flag           IN     VARCHAR2
                              ,pio_boq_tab           IN OUT boq_tab)
  IS
  --
  lt_boq_tab       boq_tab;
  lt_tre_boqs_tab  mai.tre_boqs_tab;
  --
  lr_sta  standard_items%ROWTYPE;
  --
  lv_usetremodd   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODD');
  lv_usetremodl   hig_options.hop_value%TYPE := hig.GET_SYSOPT('USETREMODL');
  lv_tremodlev    hig_options.hop_value%TYPE := hig.get_sysopt('TREMODLEV');
  lv_perc_item    hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
  --
BEGIN
  /*
  ||If BOQs Have Been Provided Then Validate Them
  ||Otherwise If The System Is Configured To Enforce
  ||Treatment Models Check For A Valid Model And
  ||Apply It.
  */
  IF pio_boq_tab.count > 0
   THEN
      --
      lt_boq_tab := pio_boq_tab;
      --
      FOR i IN 1..lt_boq_tab.COUNT LOOP
        --
        lt_boq_tab(i).boq_work_flag      := 'D';
        lt_boq_tab(i).boq_defect_id      := pi_def_defect_id;
        lt_boq_tab(i).boq_wol_id         := 0;
        lt_boq_tab(i).boq_date_created   := pi_rep_created_date;
        /*
        ||Validate Standard Item Code.
        */
        IF lt_boq_tab(i).boq_sta_item_code IS NOT NULL
         THEN
            lr_sta := get_sta(pi_sta_item_code => lt_boq_tab(i).boq_sta_item_code);
            IF lr_sta.sta_unit = lv_perc_item
             THEN
                raise_application_error(-20099,'Parent BOQs Based On Percentage Items Codes Are Not Supported.');
            END IF;
        ELSE
            raise_application_error(-20032,'Invalid Standard Item Code Specified.');
        END IF;
        lt_boq_tab(i).boq_item_name := lr_sta.sta_item_name;
        /*
        ||Check/Default Dimentions.
        */
        IF lt_boq_tab(i).boq_est_dim1 IS NULL
         THEN
            lt_boq_tab(i).boq_est_dim1 := 0;
        END IF;
        --
        IF lr_sta.sta_dim2_text IS NOT NULL
         AND lt_boq_tab(i).boq_est_dim2 IS NULL
         THEN
            lt_boq_tab(i).boq_est_dim2 := 1;
        END IF;
        --
        IF lr_sta.sta_dim3_text IS NOT NULL
         AND lt_boq_tab(i).boq_est_dim3 IS NULL
         THEN
            lt_boq_tab(i).boq_est_dim3 := 1;
        END IF;
        --
        /*
        ||Set Estimated Quantity.
        */
        lt_boq_tab(i).boq_est_quantity := lt_boq_tab(i).boq_est_dim1
                                          * NVL(lt_boq_tab(i).boq_est_dim2,1)
                                          * NVL(lt_boq_tab(i).boq_est_dim3,1);
        /*
        ||Check Quantity.
        */
        IF lt_boq_tab(i).boq_est_quantity < lr_sta.sta_min_quantity
         AND lt_boq_tab(i).boq_est_quantity != 0
         THEN
            raise_application_error(-20035,'Estimated Quantity Is Below The Minimum Quantity.');
        END IF;
        --
        IF lt_boq_tab(i).boq_est_quantity > lr_sta.sta_max_quantity
         AND lt_boq_tab(i).boq_est_quantity != 0
         THEN
            raise_application_error(-20036,'Estimated Quantity Is Above The Maximum Quantity.');
        END IF;
        /*
        ||Calculate Estimated Labour
        */
        lt_boq_tab(i).boq_est_labour := lt_boq_tab(i).boq_est_quantity * NVL(lr_sta.sta_labour_units,0);
        /*
        ||Validate Estimated Rate.
        */
        lt_boq_tab(i).boq_est_rate := lr_sta.sta_rate;
        /*
        ||Validate Estimated Cost.
        */
        IF lt_boq_tab(i).boq_est_cost IS NULL
         OR lt_boq_tab(i).boq_est_cost != ROUND((lt_boq_tab(i).boq_est_rate * lt_boq_tab(i).boq_est_quantity),2)
         THEN
            lt_boq_tab(i).boq_est_cost := ROUND((lt_boq_tab(i).boq_est_rate * lt_boq_tab(i).boq_est_quantity),2);
        END IF;
        --
      END LOOP;
      --
  ELSE
      IF((pi_sys_flag = 'D' and lv_usetremodd = 'Y') OR
         (pi_sys_flag = 'L' and lv_usetremodl = 'Y'))
       THEN
          --
          mai.get_tre_boqs(pi_admin_unit         => pi_admin_unit
                          ,pi_treat_code         => pi_rep_tre_treat_code
                          ,pi_atv_acty_area_code => pi_atv_acty_area_code
                          ,pi_defect_code        => pi_def_defect_code
                          ,pi_sys_flag           => pi_sys_flag
                          ,po_results            => lt_tre_boqs_tab);
          --
          FOR i IN 1..lt_tre_boqs_tab.count LOOP
            --
            lt_boq_tab(i).boq_work_flag      := 'D';
            lt_boq_tab(i).boq_defect_id      := pi_def_defect_id;
            lt_boq_tab(i).boq_rep_action_cat := pi_rep_action_cat;
            lt_boq_tab(i).boq_wol_id         := 0;
            lt_boq_tab(i).boq_date_created   := pi_rep_created_date;
            lt_boq_tab(i).boq_sta_item_code  := lt_tre_boqs_tab(i).boq_sta_item_code;
            lt_boq_tab(i).boq_item_name      := lt_tre_boqs_tab(i).sta_item_name;
            lt_boq_tab(i).boq_est_dim1       := lt_tre_boqs_tab(i).boq_est_dim1;
            lt_boq_tab(i).boq_est_dim2       := lt_tre_boqs_tab(i).boq_est_dim2;
            lt_boq_tab(i).boq_est_dim3       := lt_tre_boqs_tab(i).boq_est_dim3;
            lt_boq_tab(i).boq_est_quantity   := lt_tre_boqs_tab(i).boq_est_quantity;
            lt_boq_tab(i).boq_est_rate       := lt_tre_boqs_tab(i).boq_est_rate;
            lt_boq_tab(i).boq_est_cost       := lt_tre_boqs_tab(i).boq_est_cost;
            lt_boq_tab(i).boq_est_labour     := lt_tre_boqs_tab(i).boq_est_labour;
            --
          END LOOP;
      END IF;
  END IF;
  /*
  ||Assign The Validated Table To The Output Table.
  */
  pio_boq_tab := lt_boq_tab;
  --
END validate_repair_boqs;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_repairs(pi_insp_rec    IN     activities_report%ROWTYPE
                          ,pi_defect_rec  IN     defects%ROWTYPE
                          ,pi_admin_unit  IN     hig_admin_units.hau_admin_unit%TYPE
                          ,pio_repair_tab IN OUT rep_tab
                          ,pio_boq_tab    IN OUT boq_tab)
  IS
  --
  lt_rep_tab   rep_tab;
  lt_boq_tab   boq_tab;
  lt_rep_boqs  boq_tab;
  lt_all_boqs  boq_tab;
  --
  lr_defect_priorities  defect_priorities%ROWTYPE;
  lr_rse                road_sections%ROWTYPE;
  --
  lv_action_cat  repairs.rep_action_cat%TYPE;
  lv_repsetperd  hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERD');
  lv_repsetperl  hig_options.hop_value%TYPE := hig.GET_SYSOPT('REPSETPERL');
  lv_dummy       NUMBER;
  k              PLS_INTEGER := 0;
  l              PLS_INTEGER := 0;
  --
BEGIN
  --
  lt_rep_tab := pio_repair_tab;
  lt_boq_tab := pio_boq_tab;
  --
  FOR i IN 1..lt_rep_tab.count LOOP
    /*
    ||Default The Section.
    */
    --
    lt_rep_tab(i).rep_rse_he_id := pi_defect_rec.def_rse_he_id;
    --
    lr_rse := validate_section(lt_rep_tab(i).rep_rse_he_id);
    /*
    ||Default Defect Id.
    */
    lt_rep_tab(i).rep_def_defect_id := pi_defect_rec.def_defect_id;
    /*
    ||Default Activity Code.
    */
    lt_rep_tab(i).rep_atv_acty_area_code := pi_defect_rec.def_atv_acty_area_code;
    /*
    ||Default Date Created And Date Updated.
    */
    lt_rep_tab(i).rep_created_date      := pi_defect_rec.def_created_date;
    lt_rep_tab(i).rep_last_updated_date := pi_defect_rec.def_created_date;
    /*
    ||Default Superceded Flag.
    */
    lt_rep_tab(i).rep_superseded_flag   := 'N';
    /*
    ||Validate Action Category.
    */
    IF lt_rep_tab(i).rep_action_cat IS NULL
     THEN
        raise_application_error(-20029,'No Repair Action Category Specified.');
    END IF;
    --
    lr_defect_priorities := get_defect_priority(pi_rep_action_cat     => lt_rep_tab(i).rep_action_cat
                                               ,pi_atv_acty_area_code => lt_rep_tab(i).rep_atv_acty_area_code
                                               ,pi_def_priority       => pi_defect_rec.def_priority
                                               ,pi_effective_date     => pi_insp_rec.are_date_work_done);
    --
    IF lr_defect_priorities.dpr_action_cat IS NULL
     THEN
        raise_application_error(-20030,'Invalid Repair Action Category Specified.');
    END IF;
    /*
    ||Validate Treatment.
    */
    IF lt_rep_tab(i).rep_tre_treat_code IS NOT NULL
     THEN
        IF NOT validate_treatment(pi_treatment          => lt_rep_tab(i).rep_tre_treat_code
                                 ,pi_sys_flag           => lr_rse.rse_sys_flag
                                 ,pi_atv_acty_area_code => lt_rep_tab(i).rep_atv_acty_area_code
                                 ,pi_defect_type        => pi_defect_rec.def_defect_code
                                 ,pi_effective_date     => pi_insp_rec.are_date_work_done)
         THEN
            raise_application_error(-20031,'Invalid Treatment Specified.');
        END IF;
    END IF;
    /*
    ||Calculate Date Due.
    */
    IF((lr_rse.rse_sys_flag = 'D' and lv_repsetperd = 'Y')
       OR(lr_rse.rse_sys_flag = 'L' and lv_repsetperl = 'Y'))
      AND lt_rep_tab(i).rep_action_cat = 'P'
      AND pi_defect_rec.def_priority = '1'
      AND lt_rep_tab.COUNT = 1  -- ie. No Other Repairs To Be Created.
     THEN
       lv_action_cat := 'T';
    ELSE
       lv_action_cat := lt_rep_tab(i).rep_action_cat;
    END IF;
    --
    mai.rep_date_due(pi_defect_rec.def_created_date
                    ,lt_rep_tab(i).rep_atv_acty_area_code
                    ,pi_defect_rec.def_priority
                    ,lv_action_cat
                    ,lt_rep_tab(i).rep_rse_he_id
                    ,lt_rep_tab(i).rep_date_due
                    ,lv_dummy);
    IF lv_dummy <> 0
     THEN
        IF lv_dummy = 8509
         THEN
            hig.raise_ner(nm3type.c_mai,904); --Cannot Find Interval For Priority/Repair Category
        ELSIF lv_dummy = 8213
         THEN
            hig.raise_ner(nm3type.c_mai,905); --Cannot Find Interval For Road
        ELSE
            hig.raise_ner(nm3type.c_mai,906); --Cannot Find Due Date From Interval
        END IF;
    END IF;
    /*
    ||Default Local Date Due.
    */
    lt_rep_tab(i).rep_local_date_due := lt_rep_tab(i).rep_date_due;
    /*
    ||Nullify Old Date Due.
    */
    lt_rep_tab(i).rep_local_date_due := NULL;
    /*
    ||Build A Table Of BOQs
    ||Related To This Repair
    ||For Validation.
    */
    FOR j IN 1..lt_boq_tab.count LOOP
      --
      IF lt_boq_tab(j).boq_rep_action_cat IS NULL
       THEN
          raise_application_error(-20034,'No BOQ Repair Action Category Specified.');
      END IF;
      --
      IF lt_boq_tab(j).boq_rep_action_cat = lt_rep_tab(i).rep_action_cat
       THEN
          k := k+1;
          lt_rep_boqs(k) := lt_boq_tab(j);
      END IF;
      --
    END LOOP;
    /*
    ||Validate The BOQs Or
    ||Apply A Treatment Model.
    */
    validate_repair_boqs(pi_def_defect_id      => pi_defect_rec.def_defect_id
                        ,pi_rep_action_cat     => lt_rep_tab(i).rep_action_cat
                        ,pi_rep_created_date   => lt_rep_tab(i).rep_created_date
                        ,pi_admin_unit         => pi_admin_unit
                        ,pi_rep_tre_treat_code => lt_rep_tab(i).rep_tre_treat_code
                        ,pi_atv_acty_area_code => lt_rep_tab(i).rep_atv_acty_area_code
                        ,pi_def_defect_code    => pi_defect_rec.def_defect_code
                        ,pi_sys_flag           => lr_rse.rse_sys_flag
                        ,pio_boq_tab           => lt_rep_boqs);
    /*
    ||Assign Any BOQs Returned To
    ||The Validated BOQs Table.
    */
    FOR j IN 1..lt_rep_boqs.count LOOP
      l := l+1;
      lt_all_boqs(l) := lt_rep_boqs(j);
    END LOOP;
    /*
    ||Reset The Validation BOQs Table.
    */
    k := 0;
    lt_rep_boqs.delete;
    --
  END LOOP;
  /*
  ||Assign The Validated Table To The Output Table.
  */
  pio_repair_tab := lt_rep_tab;
  pio_boq_tab    := lt_all_boqs;
  --
END validate_repairs;
--
-----------------------------------------------------------------------------
--
FUNCTION ins_insp(pi_insp_rec activities_report%ROWTYPE)
  RETURN activities_report.are_report_id%TYPE IS
  --
  lv_report_id activities_report.are_report_id%TYPE;
  --
BEGIN
  /*
  ||Check The Report Id (Primary Key).
  */
  IF pi_insp_rec.are_report_id IS NULL
   THEN
      lv_report_id := get_next_id('are_report_id_seq');
  ELSE
      lv_report_id := pi_insp_rec.are_report_id;
  END IF;
  /*
  ||Insert The Inspection.
  */
  INSERT
    INTO activities_report
        (are_report_id
        ,are_rse_he_id
        ,are_batch_id
        ,are_created_date
        ,are_last_updated_date
        ,are_maint_insp_flag
        ,are_sched_act_flag
        ,are_date_work_done
        ,are_end_chain
        ,are_initiation_type
        ,are_insp_load_date
        ,are_peo_person_id_actioned
        ,are_peo_person_id_insp2
        ,are_st_chain
        ,are_surface_condition
        ,are_weather_condition
        ,are_wol_works_order_no)
  VALUES(lv_report_id
        ,pi_insp_rec.are_rse_he_id
        ,pi_insp_rec.are_batch_id
        ,pi_insp_rec.are_created_date
        ,pi_insp_rec.are_last_updated_date
        ,pi_insp_rec.are_maint_insp_flag
        ,pi_insp_rec.are_sched_act_flag
        ,pi_insp_rec.are_date_work_done
        ,pi_insp_rec.are_end_chain
        ,pi_insp_rec.are_initiation_type
        ,pi_insp_rec.are_insp_load_date
        ,pi_insp_rec.are_peo_person_id_actioned
        ,pi_insp_rec.are_peo_person_id_insp2
        ,pi_insp_rec.are_st_chain
        ,pi_insp_rec.are_surface_condition
        ,pi_insp_rec.are_weather_condition
        ,NULL);
  --
  IF SQL%rowcount != 1 THEN
    RAISE insert_error;
  END IF;
  --
  RETURN lv_report_id;
  --
EXCEPTION
  WHEN insert_error
   THEN
      raise_application_error(-20039, 'Error occured while creating Activities Report.');
  WHEN others
   THEN
      RAISE;
END ins_insp;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_insp_line(pi_report_id          IN activities_report.are_report_id%TYPE
                       ,pi_report_date        IN activities_report.are_created_date%TYPE
                       ,pi_atv_acty_area_code IN activities.atv_acty_area_code%TYPE) IS
BEGIN
  --
  INSERT
    INTO act_report_lines
        (arl_act_status
        ,arl_are_report_id
        ,arl_atv_acty_area_code
        ,arl_created_date
        ,arl_last_updated_date
        ,arl_not_seq_flag
        ,arl_report_id_part_of)
  SELECT 'C'
        ,pi_report_id
        ,pi_atv_acty_area_code
        ,pi_report_date
        ,pi_report_date
        ,NULL
        ,NULL
    FROM dual
   WHERE NOT EXISTS(SELECT 'x'
                      FROM act_report_lines
                     WHERE arl_are_report_id      = pi_report_id
                       AND arl_atv_acty_area_code = pi_atv_acty_area_code)
       ;
  --
EXCEPTION
  WHEN others
   THEN
      raise_application_error(-20041, 'Error Occured While Creating Activities Report Line : '||SQLERRM);
END ins_insp_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_repairs(pi_repair_tab IN rep_tab) IS
  --
BEGIN
  /*
  ||Insert The Repairs.
  */
  FORALL i IN 1 .. pi_repair_tab.COUNT
    INSERT
      INTO repairs
    VALUES pi_repair_tab(i)
         ;
  --
EXCEPTION
  WHEN DUP_VAL_ON_INDEX
   THEN
      raise_application_error(-20044,'Cannot Create More Than One Repair Of Each Repair Type');
  WHEN others
   THEN
      raise_application_error(-20041, 'Error Occured While Creating Repair(s) : '||SQLERRM);
END ins_repairs;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_boqs(pi_boq_tab IN boq_tab) IS
  --
  lt_boq_tab  boq_tab;
  --
BEGIN
  --
  lt_boq_tab := pi_boq_tab;
  /*
  ||Check The BOQ Id (Primary Key).
  */
  FOR i IN 1..lt_boq_tab.count LOOP
    --
    IF lt_boq_tab(i).boq_id IS NULL
     THEN
        lt_boq_tab(i).boq_id := get_next_id('boq_id_seq');
    END IF;
    --
  END LOOP;
  /*
  ||Insert The BOQs.
  */
  FORALL i IN 1 .. lt_boq_tab.COUNT
    INSERT
      INTO boq_items
    VALUES lt_boq_tab(i)
         ;
  --
EXCEPTION
  WHEN others
   THEN
      raise_application_error(-20042, 'Error Occured While Creating BOQs : '||SQLERRM);
END ins_boqs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_admin_unit(pi_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE
                       ,pi_rse_he_id IN nm_elements_all.ne_id%TYPE)
  RETURN nm_admin_units.nau_admin_unit%TYPE IS
  --
  lv_retval nm_admin_units.nau_admin_unit%TYPE;
  --
BEGIN
  IF pi_iit_ne_id IS NOT NULL
   THEN
      --
      lv_retval := nm3inv.get_inv_item_all(pi_iit_ne_id).iit_admin_unit;
      --
  ELSIF pi_rse_he_id IS NOT NULL
   THEN
      --
      lv_retval := nm3net.get_ne(pi_rse_he_id).ne_admin_unit;
      --
  END IF;
  --
  RETURN lv_retval;
  --
END get_admin_unit;
--
-----------------------------------------------------------------------------
--
FUNCTION create_defect(pi_insp_rec     IN activities_report%ROWTYPE
                      ,pi_defect_rec   IN defects%ROWTYPE
                      ,pi_def_attr_tab IN def_attr_tab
                      ,pi_repair_tab   IN rep_tab
                      ,pi_boq_tab      IN boq_tab
                      ,pi_commit       IN VARCHAR2)
  RETURN defects.def_defect_id%TYPE IS
  --
  lv_insp_id      activities_report.are_report_id%TYPE;
  lv_defect_id    defects.def_defect_id%TYPE;
  lv_action_cat   repairs.rep_action_cat%TYPE;
  lv_admin_unit   hig_admin_units.hau_admin_unit%TYPE;
  lv_asset_type   defects.def_ity_inv_code%TYPE;
  --
  lv_entity_type   VARCHAR2(10);
  lv_boqs_created  NUMBER;
  lv_dummy         NUMBER;
  lv_iit_rse_he_id nm_elements_all.ne_id%TYPE;
  --
  lr_insp_rec     activities_report%ROWTYPE;
  --lr_defect_rec   defects%ROWTYPE;
  lt_repair_tab   rep_tab;
  lr_repair_rec   repairs%ROWTYPE;
  lr_rse          road_sections%ROWTYPE;
  lt_boq_tab      boq_tab;
  --
BEGIN
  --
  nm_debug.debug_on;
  /*
  ||Assign Input Parameters To Local Parameters
  */
  nm_debug.debug('create_defect, assigning input to local params');
  lr_insp_rec   := pi_insp_rec;
  gr_defect_rec := pi_defect_rec;
  lt_repair_tab := pi_repair_tab;
  lt_boq_tab    := pi_boq_tab;
  nm_debug.debug('create_defect, local params assigned');
  /*
  ||Check/Validate The Asset Id.
  */
  IF gr_defect_rec.def_iit_item_id IS NOT NULL
   THEN
      /*
      ||Asset Id Supplied So Make Sure
      ||The Asset Type Has Also Been Given.
      */
      IF gr_defect_rec.def_ity_inv_code IS NOT NULL
       THEN
          /*
          ||Check That The Asset Exists.
          */
          IF NOT validate_asset(pi_item_type => gr_defect_rec.def_ity_inv_code
                               ,pi_item_id   => gr_defect_rec.def_iit_item_id)
           THEN
              raise_application_error(-20001,'Invalid Asset Id Supplied.');
          END IF;
          /*
          ||Asset exists but can we work with it?
          */
          check_asset_security(pi_inv_type  => gr_defect_rec.def_ity_inv_code
                              ,pi_iit_ne_id => gr_defect_rec.def_iit_item_id
                              ,pi_user_id   => pi_insp_rec.are_peo_person_id_actioned);
      ELSE
         raise_application_error(-20002,'No Asset Type Supplied.');
      END IF;
      /*
      ||Get The Maintainance Section Associated With The Asset Or
      ||The Relevant Dummy Section For Off Network Assets.
      */
      lv_iit_rse_he_id := mai.get_budget_allocation(p_inv_type  => gr_defect_rec.def_ity_inv_code
                                                   ,p_iit_ne_id => gr_defect_rec.def_iit_item_id);
      --
      lr_insp_rec.are_rse_he_id := lv_iit_rse_he_id;
      gr_defect_rec.def_rse_he_id := lv_iit_rse_he_id;
      FOR I IN 1..lt_repair_tab.count LOOP
        lt_repair_tab(i).rep_rse_he_id := lv_iit_rse_he_id;
      END LOOP;
      --
  ELSE
      /*
      ||No Asset Id Supplied So Make Sure
      ||The Asset Type Is Also NULL.
      */
      gr_defect_rec.def_ity_inv_code := NULL;
  END IF;
  /*
  ||Validate The Inspection.
  */
  validate_insp(pio_insp_rec => lr_insp_rec);
  /*
  ||Check For A Similar Inspection, If Found Use It
  ||Otherwise Create A New Inspection.
  */
  lv_insp_id := check_for_insp(pi_insp_rec => lr_insp_rec);
  IF lv_insp_id IS NOT NULL
   THEN
      nm_debug.debug('Getting Inspection Details ['||lv_insp_id ||']');
      lr_insp_rec := get_insp(pi_insp_id => lv_insp_id);
  ELSE
      lv_insp_id := ins_insp(pi_insp_rec => lr_insp_rec);
      lr_insp_rec.are_report_id := lv_insp_id;
      nm_debug.debug('Inspection Created ['||lv_insp_id ||']');
  END IF;
  /*
  ||Validate The Defect.
  */
  nm_debug.debug('Validating Defect.');
  validate_defect(pi_are_report_id       => lr_insp_rec.are_report_id
                 ,pi_are_rse_he_id       => lr_insp_rec.are_rse_he_id
                 ,pi_are_date_work_done  => lr_insp_rec.are_date_work_done
                 ,pi_are_maint_insp_flag => lr_insp_rec.are_maint_insp_flag
                 ,pi_def_attr_tab        => pi_def_attr_tab);
  /*
  ||Process The Defect.
  */
  nm_debug.debug('Processing Defect.');
  ins_insp_line(pi_report_id          => lr_insp_rec.are_report_id
               ,pi_report_date        => lr_insp_rec.are_created_date
               ,pi_atv_acty_area_code => gr_defect_rec.def_atv_acty_area_code);
  --
  gr_defect_rec.def_are_report_id := lr_insp_rec.are_report_id;
  --
  /*
  || Create The Defect.
  */
  nm_debug.debug('Creating Defect.');
  lv_defect_id := mai.create_defect(gr_defect_rec);
  gr_defect_rec.def_defect_id := lv_defect_id;
  /*
  ||Validate The Repairs.
  */
  nm_debug.debug('Getting Admin Unit.');
  lv_admin_unit := mai_api.get_admin_unit(gr_defect_rec.def_iit_item_id
                                         ,gr_defect_rec.def_rse_he_id);
  --
  nm_debug.debug('Validating Repairs.');
  validate_repairs(pi_insp_rec    => lr_insp_rec
                  ,pi_defect_rec  => gr_defect_rec
                  ,pi_admin_unit  => lv_admin_unit
                  ,pio_repair_tab => lt_repair_tab
                  ,pio_boq_tab    => lt_boq_tab);
  /*
  ||Create The Repairs.
  */
  nm_debug.debug('Creating '||lt_repair_tab.count||' repairs.');
  ins_repairs(pi_repair_tab => lt_repair_tab);
  /*
  ||Create The BOQs.
  */
  nm_debug.debug('Creating '||lt_boq_tab.count||' BOQs.');
  IF lt_boq_tab.count > 0
   THEN
      ins_boqs(pi_boq_tab => lt_boq_tab);
  END IF;
  /*
  ||Commit If Required.
  */
  IF NVL(pi_commit,'Y') = 'Y'
   THEN
   nm_debug.debug('Commit.');
      COMMIT;
  END IF;
  --
  nm_debug.debug_off;
  --
  RETURN lv_defect_id;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END create_defect;
--
-----------------------------------------------------------------------------
--
FUNCTION get_balancing_sum(pi_con_id IN contracts.con_id%TYPE
                          ,pi_value  IN work_order_lines.wol_act_cost%TYPE)
  RETURN NUMBER IS
  --
  CURSOR c1(cp_con_id contracts.con_id%TYPE)
      IS
  SELECT oun_cng_disc_group
    FROM org_units
        ,contracts
   WHERE con_contr_org_id = oun_org_id
     AND con_id = cp_con_id
       ;
  --
  lv_retval     NUMBER := 0;
  lv_disc_group org_units.oun_cng_disc_group%type;
  --
BEGIN
  OPEN  c1(pi_con_id);
  FETCH c1 into lv_disc_group;
  CLOSE c1;

  IF lv_disc_group IS NOT NULL
   AND pi_value != 0
   THEN
      IF (pi_value < 0)
       THEN
          lv_retval := -maiwo.bal_sum(p_cost           => ABS(pi_value)
                                     ,p_cng_disc_group => lv_disc_group);
      ELSE
          lv_retval := maiwo.bal_sum(p_cost           => ABS(pi_value)
                                    ,p_cng_disc_group => lv_disc_group);
      END IF;
  END IF;
  --
  RETURN lv_retval;
  --
END get_balancing_sum;
--
-----------------------------------------------------------------------------
--
FUNCTION apply_balancing_sum(pi_con_id IN contracts.con_id%TYPE
                            ,pi_value  IN work_order_lines.wol_act_cost%TYPE)
  RETURN NUMBER IS
  --
  lv_retval NUMBER;
  --
BEGIN
  --
  lv_retval := pi_value + get_balancing_sum(pi_con_id => pi_con_id
                                           ,pi_value  => pi_value);
  --
  RETURN lv_retval;
  --
END apply_balancing_sum;
--
-----------------------------------------------------------------------------
--
FUNCTION within_budget(pi_bud_id IN work_order_lines.wol_bud_id%TYPE
                      ,pi_con_id IN contracts.con_id%TYPE
                      ,pi_est    IN work_order_lines.wol_est_cost%TYPE DEFAULT 0
                      ,pi_act    IN work_order_lines.wol_act_cost%TYPE DEFAULT 0
                      ,pi_wol_id IN work_order_lines.wol_id%TYPE DEFAULT NULL)
  RETURN BOOLEAN IS
  --
  lv_retval BOOLEAN;
  --
BEGIN
  /*
  ||Check That The Values Supplied Can Be Added
  ||To The Budget Without Going Over It.
  */
  IF mai_budgets.check_budget(p_bud_id        => pi_bud_id
                             ,p_bud_committed => apply_balancing_sum(pi_con_id,NVL(pi_est,0))
                             ,p_bud_actual    => apply_balancing_sum(pi_con_id,NVL(pi_act,0))
                             ,p_wol_id        => pi_wol_id)
   THEN
      /*
      ||Value Will Exceed The Budget.
      ||See If The User Has The OVER_BUDGET role.
      */
      IF mai_budgets.allow_over_budget
       THEN
          lv_retval := TRUE;
      ELSE
          lv_retval := FALSE;
      END IF;
  ELSE
      lv_retval := TRUE;
  END IF;
  --
  RETURN lv_retval;
  --
END within_budget;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_budget(pi_wol_id in work_order_lines.wol_id%TYPE
                       ,pi_bud_id in work_order_lines.wol_bud_id%TYPE
                       ,pi_con_id in contracts.con_id%TYPE
                       ,pi_est    in work_order_lines.wol_est_cost%TYPE DEFAULT 0
                       ,pi_act    in work_order_lines.wol_act_cost%TYPE DEFAULT 0)
  IS
  --
  lv_success BOOLEAN := TRUE;
  --
BEGIN
  --
  IF NVL(pi_est,0) != 0
   THEN
      --
      lv_success := mai_budgets.update_budget_committed(p_wol_id => pi_wol_id
                                                       ,p_bud_id => pi_bud_id
                                                       ,p_bud_committed => apply_balancing_sum(pi_con_id => pi_con_id
                                                                                              ,pi_value  => pi_est));
  END IF;
  --
  IF NVL(pi_act,0) != 0
   AND lv_success
   THEN
      lv_success := mai_budgets.update_budget_actual(p_wol_id     => pi_wol_id
                                                    ,p_bud_id     => pi_bud_id
                                                    ,p_bud_actual => apply_balancing_sum(pi_con_id => pi_con_id
                                                                                        ,pi_value  => pi_act));
  END IF;
  --
  IF NOT lv_success
   THEN
      raise_application_error(-20047,'Budget Exceeded.');
  END IF;
  --
END add_to_budget;
--
-----------------------------------------------------------------------------
--This Procedure Is Intended To Emulate The Form mai3801.
--
PROCEDURE create_defect_work_order(pi_user_id           IN  hig_users.hus_user_id%TYPE
                                  ,pi_wo_descr          IN  work_orders.wor_descr%TYPE
                                  ,pi_scheme_type       IN  work_orders.wor_scheme_type%TYPE
                                  ,pi_con_id            IN  contracts.con_id%TYPE
                                  ,pi_interim_payment   IN  work_orders.wor_interim_payment_flag%TYPE
                                  ,pi_priority          IN  work_orders.wor_priority%TYPE
                                  ,pi_cost_centre       IN  work_orders.wor_coc_cost_centre%TYPE
                                  ,pi_road_group_id     IN  nm_elements_all.ne_id%TYPE
                                  ,pi_tma_register_flag IN  work_orders.wor_register_flag%TYPE
                                  ,pi_contact           IN  work_orders.wor_contact%TYPE
                                  ,pi_job_number        IN  work_orders.wor_job_number%TYPE
                                  ,pi_rechargeable      IN  work_orders.wor_rechargeable%TYPE
                                  ,pi_date_raised       IN  work_orders.wor_date_raised%TYPE
                                  ,pi_target_date       IN  work_orders.wor_est_complete%TYPE
                                  ,pi_defects           IN  def_rep_list_in_tab
                                  ,pi_defect_boqs       IN  boq_tab
                                  ,pi_commit            IN  VARCHAR2
                                  ,po_work_order_no     OUT work_orders.wor_works_order_no%TYPE
                                  ,po_defects_on_wo     OUT def_rep_list_on_wo_tab
                                  ,po_defects_not_on_wo OUT def_rep_list_not_on_wo_tab)
  IS
  --
  lv_work_order_no  work_orders.wor_works_order_no%TYPE;
  --
  lv_sys_flag           VARCHAR2(1);
  lv_worrefgen          hig_option_values.hov_value%TYPE := hig.get_sysopt('WORREFGEN');
  lv_gisgrptyp          hig_option_values.hov_value%TYPE := hig.get_sysopt('GISGRPTYP');
  lv_gisgrpl            hig_option_values.hov_value%TYPE := hig.get_sysopt('GISGRPL');
  lv_gisgrpd            hig_option_values.hov_value%TYPE := hig.get_sysopt('GISGRPD');
  lv_dumconcode         hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('DUMCONCODE'),'DEFAULT');
  lv_scheme_type_upd    hig_option_values.hov_value%TYPE := NVL(hig.get_user_or_sys_opt('DEFSCHTYPU'),'Y');
  lv_def_scheme_type_l  hig_option_values.hov_value%TYPE := NVL(hig.get_user_or_sys_opt('DEFSCHTYPL'),'LR');
  lv_def_scheme_type_d  hig_option_values.hov_value%TYPE := NVL(hig.get_user_or_sys_opt('DEFSCHTYPD'),'RD');
  lv_user_admin_unit    nm_admin_units_all.nau_admin_unit%TYPE;
  lv_road_group_id      nm_elements_all.ne_id%TYPE;
  lv_rse_admin_unit     nm_admin_units_all.nau_admin_unit%TYPE;
  lv_rse_sys_flag       VARCHAR2(1);
  lv_work_code          item_code_breakdowns.icb_work_code%TYPE;
  lv_scheme_type        work_orders.wor_scheme_type%TYPE;
  lv_con_admin_unit     nm_admin_units_all.nau_admin_unit%TYPE;
  lv_discount_group     org_units.oun_cng_disc_group%TYPE;
  lv_wor_admin_unit     nm_admin_units_all.nau_admin_unit%TYPE;
  lv_bud_rse_he_id      nm_elements_all.ne_id%TYPE;
  lv_icb_id             item_code_breakdowns.icb_id%TYPE;
  lv_date_raised        work_orders.wor_date_raised%TYPE;
  --
  lv_wor_est_cost          work_orders.wor_est_cost%TYPE := 0;
  lv_wor_est_labour        work_orders.wor_est_labour%TYPE := 0;
  lv_wor_est_balancing_sum work_orders.wor_est_balancing_sum%TYPE := 0;
  --
  lv_wol_not_done    hig_status_codes.hsc_status_code%TYPE;
  lv_wol_instructed  hig_status_codes.hsc_status_code%TYPE;
  lv_def_instructed  hig_status_codes.hsc_status_code%TYPE;
  lv_def_available   hig_status_codes.hsc_status_code%TYPE;
  --
  lv_wol_null_boq_exists BOOLEAN := FALSE;
  lv_wor_null_boq_exists BOOLEAN := FALSE;
  --
  TYPE wol_rec IS RECORD(wol_id              work_order_lines.wol_id%TYPE
                        ,wol_works_order_no  work_order_lines.wol_works_order_no%TYPE
                        ,wol_rse_he_id       work_order_lines.wol_rse_he_id%TYPE
                        ,wol_siss_id         work_order_lines.wol_siss_id%TYPE
                        ,wol_icb_work_code   work_order_lines.wol_icb_work_code%TYPE
                        ,wol_act_area_code   work_order_lines.wol_act_area_code%TYPE
                        ,wol_def_defect_id   work_order_lines.wol_def_defect_id%TYPE
                        ,wol_rep_action_cat  work_order_lines.wol_rep_action_cat%TYPE
                        ,wol_flag            work_order_lines.wol_flag%TYPE
                        ,wol_status_code     work_order_lines.wol_status_code%TYPE
                        ,wol_wor_flag        work_order_lines.wol_wor_flag%TYPE
                        ,wol_date_created    work_order_lines.wol_date_created%TYPE
                        ,wol_bud_id          work_order_lines.wol_bud_id%TYPE
                        ,wol_est_cost        work_order_lines.wol_est_cost%TYPE
                        ,wol_est_labour      work_order_lines.wol_est_labour%TYPE);
  TYPE wol_tab IS TABLE OF wol_rec INDEX BY BINARY_INTEGER;
  lt_wol wol_tab;
  --
  lt_boq boq_tab;
  lv_boq_tab_ind PLS_INTEGER := 1;
  --
  TYPE selected_repairs_rec IS RECORD(rep_rse_he_id          repairs.rep_rse_he_id%TYPE
                                     ,def_siss_id            defects.def_siss_id%TYPE
                                     ,def_priority           defects.def_priority%TYPE
                                     ,rep_atv_acty_area_code repairs.rep_atv_acty_area_code%TYPE
                                     ,rep_def_defect_id      repairs.rep_def_defect_id%TYPE
                                     ,rep_action_cat         repairs.rep_action_cat%TYPE
                                     ,bud_id                 budgets.bud_id%TYPE
                                     ,work_code              item_code_breakdowns.icb_work_code%TYPE);
  TYPE selected_repairs_tab IS TABLE OF selected_repairs_rec INDEX BY BINARY_INTEGER;
  lt_selected_repairs selected_repairs_tab;
  --
  TYPE repair_boqs_rec IS RECORD(boq_id            boq_items.boq_id%TYPE
                                ,boq_sta_item_code boq_items.boq_sta_item_code%TYPE
                                ,boq_est_quantity  boq_items.boq_est_quantity%TYPE
                                ,boq_est_labour    boq_items.boq_est_labour%TYPE
                                ,sta_rogue_flag    standard_items.sta_rogue_flag%TYPE);
  TYPE repair_boqs_tab IS TABLE OF repair_boqs_rec INDEX BY BINARY_INTEGER;
  lt_repair_boqs repair_boqs_tab;
  --
  PROCEDURE init_defaults
    IS
    --
    PROCEDURE set_date_raised
      IS
    BEGIN
      IF pi_date_raised IS NOT NULL
       THEN
          IF pi_date_raised > TRUNC(SYSDATE)
           THEN
              raise_application_error(-20084,'Date Raised Must Be Less Than Or Equal To Todays Date.');
          ELSE
              lv_date_raised := pi_date_raised;
          END IF;
      ELSE
          lv_date_raised := TRUNC(SYSDATE);
      END IF;
    END set_date_raised;
    --
    PROCEDURE ins_defect_list_temp
      IS
      --
      lv_matching_defects NUMBER;
      --
    BEGIN
      /*
      ||If pi_commit wasn't 'Y' the last time
      ||the procedure was called there may still
      ||be records in the temp table.
      */
      DELETE
        FROM defect_list_temp;
      /*
      ||Insert the supplied Defect Ids
      ||into the temp table.
      */
      FORALL i IN 1..pi_defects.count
      INSERT
        INTO defect_list_temp
      VALUES pi_defects(i)
           ;
      /*
      ||Make sure all supplied Defect Ids exist.
      */
      SELECT count(*)
        INTO lv_matching_defects
        FROM defects
            ,repairs
       WHERE rep_def_defect_id = def_defect_id
         AND (def_defect_id,rep_action_cat) IN(SELECT dlt_defect_id
                                                     ,dlt_rep_action_cat
                                                 FROM defect_list_temp)
           ;
      --
      IF lv_matching_defects != pi_defects.count
       THEN
          raise_application_error(-20072,'Supplied List Of Defects Contains Invalid Ids');
      END IF;
      --
    EXCEPTION
      WHEN dup_val_on_index
       THEN
          raise_application_error(-20071,'Supplied List Of Defects Contains Duplicates');
      WHEN others
       THEN
          RAISE;
    END ins_defect_list_temp;
    --
    PROCEDURE validate_user
      IS
    BEGIN
      SELECT hus_admin_unit
        INTO lv_user_admin_unit
        FROM hig_users
       WHERE hus_user_id = pi_user_id
           ;
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
      WHEN others
       THEN
          RAISE;
    END validate_user;
    --
    PROCEDURE validate_contract
      IS
      --
      lv_con_code contracts.con_code%TYPE;
      --
    BEGIN
      SELECT con_code
            ,con_admin_org_id
            ,oun_cng_disc_group
        INTO lv_con_code
            ,lv_con_admin_unit
            ,lv_discount_group
        FROM org_units
            ,contracts
       WHERE con_id = pi_con_id
         AND lv_date_raised BETWEEN NVL(con_start_date, lv_date_raised)
                                AND NVL(con_end_date  , lv_date_raised)
         AND ((con_admin_org_id IN(SELECT hag_child_admin_unit
                                     FROM hig_admin_groups
                                    WHERE hag_parent_admin_unit = lv_user_admin_unit))
              OR con_code = lv_dumconcode)
         AND con_contr_org_id = oun_org_id
           ;
      --
      IF lv_con_code = lv_dumconcode
       THEN
          lv_wor_admin_unit := lv_con_admin_unit;
      ELSE
          lv_wor_admin_unit := lv_user_admin_unit;
      END IF;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20063,'Invalid Contract Id Supplied.');
      WHEN others
       THEN
          RAISE;
    END validate_contract;
    --
    PROCEDURE validate_interim_flag
      IS
    BEGIN
      --
      IF pi_interim_payment IS NOT NULL
       AND pi_interim_payment NOT IN ('Y', 'N')
       THEN
          raise_application_error(-20081,'Invalid Interim Flag Supplied.');
      END IF;
      --
    END validate_interim_flag;
    --
    PROCEDURE validate_rechargeable
      IS
    BEGIN
      --
      IF pi_rechargeable IS NOT NULL
       AND pi_rechargeable NOT IN ('Y', 'N')
       THEN
          raise_application_error(-20089,'Invalid Rechargeable Flag Supplied.');
      END IF;
      --
    END validate_rechargeable;
    --
    PROCEDURE validate_tma_register_flag(pi_flag IN VARCHAR2)
      IS
    BEGIN
      --
      IF pi_flag IS NOT NULL
       AND pi_flag NOT IN ('Y', 'N')
       THEN
          raise_application_error(-20088,'Invalid TMA Register Flag Supplied.');
      END IF;
      --
    END validate_tma_register_flag;
    --
    PROCEDURE validate_wo_priority
      IS
      --
      lv_dummy NUMBER;
      --
    BEGIN
      --
      IF pi_priority IS NOT NULL
       THEN
          SELECT 1
            INTO lv_dummy
            FROM hig_codes
           WHERE hco_domain = 'WOR_PRIORITY'
             AND hco_code   = pi_priority
             AND lv_date_raised BETWEEN NVL(hco_start_date, lv_date_raised)
                                    AND NVL(hco_end_date, lv_date_raised)
               ;
      END IF;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20082,'Invalid Work Order Priority Supplied.');
      WHEN others
       THEN
          RAISE;
    END validate_wo_priority;
    --
    PROCEDURE validate_cost_centre
      IS
      --
      lv_dummy NUMBER;
      --
    BEGIN
      --
      IF pi_cost_centre IS NOT NULL
       THEN
          SELECT 1
            INTO lv_dummy
            FROM cost_centres
                ,hig_admin_groups
           WHERE hag_parent_admin_unit = lv_user_admin_unit
             AND hag_child_admin_unit  = coc_org_id
             AND coc_cost_centre       = pi_cost_centre
             AND lv_date_raised BETWEEN NVL(coc_start_date, lv_date_raised)
                                    AND NVL(coc_end_date, lv_date_raised)
               ;
      END IF;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20080,'Invalid Cost Centre Supplied.');
      WHEN others
       THEN
          RAISE;
    END validate_cost_centre;
    --
    PROCEDURE validate_target_complete
      IS
      --
      lv_dummy NUMBER;
      --
    BEGIN
      --
      IF pi_target_date IS NOT NULL
       AND pi_target_date < lv_date_raised
       THEN
          raise_application_error(-20086,'Target Complete Date Should Not Be Before The Date Raised.');
      END IF;
      --
    END validate_target_complete;
    --
    PROCEDURE validate_road_group(pi_group_id IN nm_elements_all.ne_id%TYPE)
      IS
    BEGIN
      --
      SELECT rse_he_id
            ,rse_admin_unit
            ,rse_sys_flag
        INTO lv_road_group_id
            ,lv_rse_admin_unit
            ,lv_sys_flag
        FROM road_groups
       WHERE rse_he_id = pi_group_id
           ;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20087,'Invalid Road Group Id Supplied.');
      WHEN others
       THEN
          RAISE;
    END validate_road_group;
    --
    PROCEDURE set_sys_flag(pi_defect_id IN defects.def_defect_id%TYPE
                          ,pi_rse_he_id IN nm_elements_all.ne_id%TYPE)
      IS
      --
      lv_def_he_id nm_elements_all.ne_id%TYPE;
      --
    BEGIN
      --
      IF pi_rse_he_id IS NOT NULL
       THEN
          validate_road_group(pi_rse_he_id);
      ELSE
          SELECT def_ity_sys_flag
                ,def_rse_he_id
            INTO lv_sys_flag
                ,lv_def_he_id
            FROM defects
           WHERE def_defect_id = pi_defect_id
               ;
          --
          BEGIN
            IF lv_sys_flag IS NULL
             THEN
                SELECT rse_sys_flag
                  INTO lv_sys_flag
                  FROM road_sections
                 WHERE rse_he_id = lv_def_he_id
                     ;
            END IF;
          EXCEPTION
           WHEN others
            THEN
               null;
          END;
      END IF;
      --
      IF lv_sys_flag IS NULL
       THEN
          raise_application_error(-20074,'Unable To Obtain sys_flag.');
      END IF;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20065,'Invalid Defect Id Supplied.');
      WHEN others
       THEN
          RAISE;
    END set_sys_flag;
    --
    PROCEDURE set_road_group(pi_group_name IN VARCHAR2)
      IS
    BEGIN
      --
      SELECT rse_he_id
            ,rse_admin_unit
        INTO lv_road_group_id
            ,lv_rse_admin_unit
        FROM road_groups
       WHERE rse_unique = pi_group_name
           ;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20060,'Cannot Set Road Group. Please Check Product Options GISGRPTYP, GISGRPL and GISGRPD');
      WHEN others
       THEN
          RAISE;
    END set_road_group;
    --
    PROCEDURE get_wol_not_done
      IS
    BEGIN
      SELECT hsc_status_code
        INTO lv_wol_not_done
        FROM hig_status_codes
       WHERE hsc_domain_code = 'WORK_ORDER_LINES'
         AND hsc_allow_feature5 = 'Y'
         AND lv_date_raised BETWEEN NVL(hsc_start_date,lv_date_raised)
                                AND NVL(hsc_end_date  ,lv_date_raised)
           ;
    EXCEPTION
      WHEN too_many_rows
       THEN
          raise_application_error(-20059,'Too Many Values Defined For Work Order Line NOT_DONE Status');
      WHEN no_data_found
       THEN
          raise_application_error(-20055,'Cannot Obtain Value For Work Order Line NOT_DONE Status');
      WHEN others
       THEN
          RAISE;
    END get_wol_not_done;
    --
    PROCEDURE get_wol_instructed
      IS
    BEGIN
      SELECT hsc_status_code
        INTO lv_wol_instructed
        FROM hig_status_codes
       WHERE hsc_domain_code = 'WORK_ORDER_LINES'
         AND hsc_allow_feature1 = 'Y'
         AND lv_date_raised BETWEEN NVL(hsc_start_date,lv_date_raised)
                                AND NVL(hsc_end_date  ,lv_date_raised)
           ;
    EXCEPTION
      WHEN too_many_rows
       THEN
          raise_application_error(-20058,'Too Many Values Defined For Work Order Line INSTRUCTED Status');
      WHEN no_data_found
       THEN
          raise_application_error(-20054,'Cannot Obtain Value For Work Order Line INSTRUCTED Status');
      WHEN others
       THEN
          RAISE;
    END get_wol_instructed;
    --
    PROCEDURE get_def_instructed
      IS
    BEGIN
      SELECT hsc_status_code
        INTO lv_def_instructed
        FROM hig_status_codes
       WHERE hsc_domain_code = 'DEFECTS'
         AND hsc_allow_feature3 = 'Y'
         AND lv_date_raised BETWEEN NVL(hsc_start_date,lv_date_raised)
                                AND NVL(hsc_end_date  ,lv_date_raised)
           ;
    EXCEPTION
      WHEN too_many_rows
       THEN
          raise_application_error(-20057,'Too Many Values Defined For Defect INSTRUCTED Status');
      WHEN no_data_found
       THEN
          raise_application_error(-20053,'Cannot Obtain Value For Defect INSTRUCTED Status');
      WHEN others
       THEN
          RAISE;
    END get_def_instructed;
    --
    PROCEDURE get_def_available
      IS
    BEGIN
      SELECT hsc_status_code
        INTO lv_def_available
        FROM hig_status_codes
       WHERE hsc_domain_code = 'DEFECTS'
         AND hsc_allow_feature2 = 'Y'
         AND lv_date_raised BETWEEN NVL(hsc_start_date,lv_date_raised)
                                AND NVL(hsc_end_date  ,lv_date_raised)
           ;
    EXCEPTION
      WHEN too_many_rows
       THEN
          raise_application_error(-20056,'Too Many Values Defined For Defect AVAILABLE Status');
      WHEN no_data_found
       THEN
          raise_application_error(-20052,'Cannot Obtain Value For Defect AVAILABLE Status');
      WHEN others
       THEN
          RAISE;
    END get_def_available;
    --
    PROCEDURE set_scheme_type
      IS
      --
      PROCEDURE validate_scheme_type
        IS
      BEGIN
        SELECT icb_work_code
          INTO lv_work_code
          FROM item_code_breakdowns
         WHERE icb_type_of_scheme = lv_scheme_type
           AND icb_dtp_flag       = lv_sys_flag
             ;
      EXCEPTION
        WHEN no_data_found
         THEN
            raise_application_error(-20066,'Invalid Scheme Type');
        WHEN too_many_rows
         THEN
            lv_work_code := NULL;
        WHEN others
         THEN
            RAISE;
      END validate_scheme_type;
      --
    BEGIN
      /*
      ||Determine The Scheme Type To Use.
      */
      IF lv_scheme_type_upd = 'Y'
       AND pi_scheme_type IS NOT NULL
       THEN
          lv_scheme_type := pi_scheme_type;
      ELSE
          IF lv_sys_flag = 'L'
           THEN
              lv_scheme_type := lv_def_scheme_type_l;
          ELSE
              lv_scheme_type := lv_def_scheme_type_d;
          END IF;
      END IF;
      /*
      ||Now Validate The Scheme Type
      ||And Set The Work Code.
      */
      validate_scheme_type;
      --
    END set_scheme_type;
    --
  BEGIN
    /*
    ||Validate/Default the Date Raised.
    */
    set_date_raised;
    /*
    ||If No Defects Have Been Specified Raise An Error.
    */
    IF pi_defects.count = 0
     THEN
        raise_application_error(-20070,'Please Specify At Least One Defect For The Work Order.');
    END IF;
    /*
    ||Insert The Defect Ids Into Temp Table
    ||And Validate Against The Defects Table.
    */
    nm_debug.debug('ins_defect_list_temp');
    ins_defect_list_temp;
    /*
    ||Get The Sys Flag For The Work Order
    ||And Validate The Supplied Road Group Id.
    */
    nm_debug.debug('set_sys_flag');
    set_sys_flag(pi_defect_id => pi_defects(1).dlt_defect_id
                ,pi_rse_he_id => pi_road_group_id);
    /*
    ||Default The Road Group For The Work Order
    ||If Not Suppled.
    */
    nm_debug.debug('set_road_group');
    IF lv_road_group_id IS NULL
     THEN
        IF lv_sys_flag = 'L'
         THEN
            set_road_group(lv_gisgrpl);
        ELSE
            set_road_group(lv_gisgrpd);
        END IF;
    END IF;
    /*
    ||Get The Users Admin Unit.
    */
    nm_debug.debug('validate_user');
    validate_user;
    /*
    ||Get The Contracts Admin Unit.
    */
    nm_debug.debug('validate_contract');
    validate_contract;
    /*
    ||Validate/Default Scheme Type.
    */
    nm_debug.debug('set_scheme_type');
    set_scheme_type;
    /*
    ||Validate The Interim Flag Supplied.
    */
    validate_interim_flag;
    /*
    ||Validate The Work Order Priority Supplied.
    */
    validate_wo_priority;
    /*
    ||Validate The Cost Centre Supplied.
    */
    validate_cost_centre;
    /*
    ||Validate The WO TMA Register Flag.
    */
    validate_tma_register_flag(pi_tma_register_flag);
    /*
    ||Validate The Rechargeable Flag.
    */
    validate_rechargeable;
    /*
    ||Validate The Target Complete Date Supplied.
    */
    validate_target_complete;
    /*
    ||Get Status Codes.
    */
    nm_debug.debug('get_wol_not_done');
    get_wol_not_done;
    nm_debug.debug('get_wol_instructed');
    get_wol_instructed;
    nm_debug.debug('get_def_instructed');
    get_def_instructed;
    nm_debug.debug('get_def_available');
    get_def_available;
    --
  END init_defaults;
  --
  FUNCTION validate_budget(pi_budget_id   IN budgets.bud_id%TYPE
                          ,pi_defect_id   IN defects.def_defect_id%TYPE)
    RETURN BOOLEAN IS
    --
    lv_retval BOOLEAN := FALSE;
    --
  BEGIN
    /*
    ||Init Variables.
    */
    lv_bud_rse_he_id := NULL;
    lv_icb_id        := NULL;
    lv_work_code     := NULL;
    --
    SELECT bud_rse_he_id
          ,icb_id
          ,icb_work_code
      INTO lv_bud_rse_he_id
          ,lv_icb_id
          ,lv_work_code
      FROM item_code_breakdowns
          ,budgets
          ,financial_years
     WHERE TRUNC(fyr_end_date) >= lv_date_raised
       AND fyr_id = bud_fyr_id
       AND bud_id = pi_budget_id
       AND bud_icb_item_code = icb_item_code
       AND bud_icb_sub_item_code = icb_sub_item_code
       AND bud_icb_sub_sub_item_code = icb_sub_sub_item_code
       AND bud_sys_flag = icb_dtp_flag
       AND icb_type_of_scheme = lv_scheme_type
       AND EXISTS(SELECT 1
                    FROM defects
                   WHERE def_defect_id = pi_defect_id
                     AND (def_rse_he_id IN(SELECT nm_ne_id_of
                                             FROM nm_members
                                            WHERE nm_type = 'G'
                                          CONNECT BY
                                            PRIOR nm_ne_id_of = nm_ne_id_in
                                            START
                                             WITH nm_ne_id_in = bud_rse_he_id)
                          OR def_rse_he_id = NVL(bud_rse_he_id,def_rse_he_id)))
         ;
    --
    RETURN TRUE;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        RETURN FALSE;
    WHEN others
     THEN
        RAISE;
  END validate_budget;
  --
  PROCEDURE validate_and_replace_boqs(pi_defect_id      IN defects.def_defect_id%TYPE
                                     ,pi_rep_action_cat IN repairs.rep_action_cat%TYPE
                                     ,pi_boqs_tab       IN boq_tab)
    IS
    --
    lv_dummy boq_items.boq_id%TYPE;
    --
    lt_boqs boq_tab;
    --
  BEGIN
    /*
    ||Build A Table Of Supplied BOQs Related To This Defect/Repair For Validation.
    */
    FOR i IN 1..pi_boqs_tab.count LOOP
      --
      IF pi_boqs_tab(i).boq_rep_action_cat IS NULL
       OR pi_boqs_tab(i).boq_defect_id IS NULL
       THEN
          raise_application_error(-20090,'No BOQ Defect Id or Repair Action Category Specified.');
      END IF;
      --
      IF pi_boqs_tab(i).boq_defect_id = pi_defect_id
       AND pi_boqs_tab(i).boq_rep_action_cat = pi_rep_action_cat
       THEN
          lt_boqs(lt_boqs.count+1) := pi_boqs_tab (i);
      END IF;
      --
    END LOOP;
    --
    IF lt_boqs.count > 0
     THEN
        /*
        ||Make Sure The BOQs Specified With A BOQ_ID
        ||Belong To The Specified Defect/Repair.
        */
        FOR i IN 1..lt_boqs.count LOOP
          --
          IF lt_boqs(i).boq_id IS NOT NULL
           THEN
              --
              BEGIN
                SELECT boq_id
                  INTO lv_dummy
                  FROM boq_items
                 WHERE boq_id = lt_boqs(i).boq_id
                   AND boq_defect_id = pi_defect_id
                   AND boq_rep_action_cat = pi_rep_action_cat
                     ;
              EXCEPTION
                WHEN no_data_found
                 THEN
                    raise_application_error(-20091,'BOQ_ID ['||TO_CHAR(lt_boqs(i).boq_id)
                                                 ||'] Is Not A Child Of The Specified Parent - Defect ['
                                                 ||TO_CHAR(pi_defect_id)||'] Repair Type ['||pi_rep_action_cat||'].');
                WHEN others
                 THEN
                    RAISE;
              END;
              --
          END IF;
          --
        END LOOP;
        /*
        ||Validate And Build The New BOQs.
        */
        validate_repair_boqs(pi_def_defect_id      => pi_defect_id
                            ,pi_rep_action_cat     => pi_rep_action_cat
                            ,pi_rep_created_date   => TRUNC(SYSDATE)
                            ,pi_admin_unit         => NULL
                            ,pi_rep_tre_treat_code => NULL
                            ,pi_atv_acty_area_code => NULL
                            ,pi_def_defect_code    => NULL
                            ,pi_sys_flag           => NULL
                            ,pio_boq_tab           => lt_boqs);
        /*
        ||Remove The Old BOQs.
        */
        DELETE boq_items
         WHERE boq_defect_id = pi_defect_id
           AND boq_rep_action_cat = pi_rep_action_cat
             ;
        /*
        ||Insert The New BOQs.
        */
        ins_boqs(pi_boq_tab => lt_boqs);
        --
    END IF;
    --
  END validate_and_replace_boqs;
  --
  PROCEDURE select_defects
    IS
    --
    lt_defect_repairs     mai_api.def_rep_list_in_tab;
    lr_selected_repair    selected_repairs_rec;
    lt_defect_repair_boqs boq_tab;
    --
    PROCEDURE check_defect(pi_budget_id   IN budgets.bud_id%TYPE
                          ,pi_defect_id   IN defects.def_defect_id%TYPE
                          ,pi_repair_type IN repairs.rep_action_cat%TYPE
                          ,pi_work_code   IN item_code_breakdowns.icb_work_code%TYPE)
      IS
      --
      lv_reason VARCHAR2(500);
      --
    BEGIN
      /*
      ||Check The Defect/Repair Against The Selection Criteria.
      */
      SELECT CASE WHEN def_status_code NOT IN(lv_def_available,lv_def_instructed)
                    OR def_date_compl IS NOT NULL
                    OR rep_date_completed IS NOT NULL
                   THEN 'Defect/Repair Is Already Complete.'
                  WHEN NVL(rep_superseded_flag,'N') = 'Y'
                   THEN 'Repair Has Been Superseded.'
                  WHEN rep_action_cat NOT IN('P','T')
                   THEN 'Invalid Repair Type.'
                  WHEN def_notify_org_id IS NOT NULL
                   AND def_rechar_org_id IS NULL
                   THEN 'Notifiable Organisation Specifed On Defect But No Rechargeable Organisation Specified.'
                  WHEN def_rse_he_id != rep_rse_he_id
                   THEN 'Repair And Defect Are On Different Sections.'
                  WHEN EXISTS(SELECT 1
                                FROM work_order_lines
                               WHERE wol_def_defect_id  = rep_def_defect_id
                                 AND wol_rep_action_cat = rep_action_cat
                                 AND wol_status_code   != lv_wol_not_done)
                   THEN 'Repair Is Already On A Work Order.'
                  WHEN NOT EXISTS(SELECT 1
                                    FROM ihms_conversions
                                   WHERE ihc_atv_acty_area_code = rep_atv_acty_area_code
                                     AND ihc_atv_acty_area_code = def_atv_acty_area_code
                                     AND ihc_icb_id = lv_icb_id)
                   THEN 'Defect Activity Code Is Invalid For The Budget Specified.'
                  WHEN NOT EXISTS(SELECT 1
                                    FROM hig_admin_groups
                                        ,road_sections
                                   WHERE hag_parent_admin_unit = lv_con_admin_unit
                                     AND hag_child_admin_unit  = rse_admin_unit
                                     AND rse_he_id             = def_rse_he_id)
                   THEN 'Defect Is On A Section Outside Of The Admin Unit Of The Specified Contract.'
                  WHEN def_rse_he_id NOT IN((SELECT nm_ne_id_of
                                               FROM nm_members
                                              WHERE nm_type = 'G'
                                            CONNECT BY
                                              PRIOR nm_ne_id_of = nm_ne_id_in
                                                AND nm_end_date IS NULL
                                              START
                                               WITH nm_ne_id_in = lv_road_group_id
                                              UNION
                                             SELECT ne_id
                                               FROM nm_elements
                                              WHERE ne_id = lv_road_group_id)
                                          INTERSECT
                                             SELECT nm_ne_id_of
                                               FROM nm_members
                                              WHERE nm_type = 'G'
                                            CONNECT BY
                                              PRIOR nm_ne_id_of = nm_ne_id_in
                                                AND nm_end_date IS NULL
                                              START
                                               WITH nm_ne_id_in = NVL(lv_bud_rse_he_id,lv_road_group_id))
                   THEN 'Defect Is On A Section That Is Not A Member Of The Specified Work Order Road Group.'
                  WHEN lv_sys_flag != 'L'
                   AND NOT EXISTS(SELECT 1
                                    FROM road_segments_all
                                        ,item_code_breakdowns
                                   WHERE icb_id = lv_icb_id
                                     AND DECODE(icb_rse_road_environment,null,rse_road_environment
                                                                        , 'R',DECODE(rse_road_environment,'S','S'
                                                                                                             ,'R')
                                                                        , 'S',DECODE(rse_road_environment,'R','R'
                                                                                                             ,'S')
                                                                             ,icb_rse_road_environment)
                                          = rse_road_environment
                                     AND rse_he_id = def_rse_he_id)
                   THEN 'Defect Is On A Section With An Invalid Environment Type For The Budget Specified.'
                  ELSE NULL
             END reason
        INTO lv_reason
        FROM repairs
            ,defects
       WHERE def_defect_id = pi_defect_id
         AND def_defect_id = rep_def_defect_id
         AND rep_action_cat = pi_repair_type
           ;
      --
      IF lv_reason IS NULL
       THEN
          /*
          ||The Repair Has Passed The Checks So Lock The Defect/Repair
          ||Records And Add It To The List To Go On The Work Order.
          */
          SELECT rep_rse_he_id
                ,def_siss_id
                ,def_priority
                ,rep_atv_acty_area_code
                ,rep_def_defect_id
                ,rep_action_cat
                ,pi_budget_id
                ,pi_work_code
            INTO lr_selected_repair
            FROM repairs
                ,defects
           WHERE def_defect_id  = pi_defect_id
             AND def_defect_id  = rep_def_defect_id
             AND rep_action_cat = pi_repair_type
             FOR UPDATE
              OF def_status_code
                 NOWAIT
               ;
          --
          lt_selected_repairs(lt_selected_repairs.count+1) := lr_selected_repair;
          po_defects_on_wo(po_defects_on_wo.count+1).defect_id    := pi_defect_id;
          po_defects_on_wo(po_defects_on_wo.count).rep_action_cat := pi_repair_type;
          --
      ELSE
          /*
          ||Repair Failed Checks So Add It To The List
          ||Of Defect/Repairs Not On The Work Order.
          */
          po_defects_not_on_wo(po_defects_not_on_wo.count+1).defect_id    := pi_defect_id;
          po_defects_not_on_wo(po_defects_not_on_wo.count).rep_action_cat := pi_repair_type;
          po_defects_not_on_wo(po_defects_not_on_wo.count).reason         := lv_reason;
      END IF;
    END check_defect;
    --
  BEGIN
    --
    nm_debug.debug('Fetching Defects');
    /*
    ||Get The Supplied Defects From
    ||The Temp Table.
    */
    SELECT *
      BULK COLLECT
      INTO lt_defect_repairs
      FROM defect_list_temp
         ;
    --
    FOR i IN 1..lt_defect_repairs.count LOOP
      /*
      ||Validate The Budget.
      */
      IF validate_budget(pi_budget_id   => lt_defect_repairs(i).dlt_budget_id
                        ,pi_defect_id   => lt_defect_repairs(i).dlt_defect_id)
       THEN
          /*
          ||Budget Is Valid So Check That The
          ||Defect Is Valid For The Work Order.
          */
          check_defect(pi_budget_id   => lt_defect_repairs(i).dlt_budget_id
                      ,pi_defect_id   => lt_defect_repairs(i).dlt_defect_id
                      ,pi_repair_type => lt_defect_repairs(i).dlt_rep_action_cat
                      ,pi_work_code   => lv_work_code);
      ELSE
          /*
          ||Repair Failed Budget Check So Add It
          ||To The List Of Defect/Repairs Not On
          ||The Work Order.
          */
          po_defects_not_on_wo(po_defects_not_on_wo.count+1).defect_id    := lt_defect_repairs(i).dlt_defect_id;
          po_defects_not_on_wo(po_defects_not_on_wo.count).rep_action_cat := lt_defect_repairs(i).dlt_rep_action_cat;
          po_defects_not_on_wo(po_defects_not_on_wo.count).reason         := 'Invalid Budget Supplied.';
      END IF;
      --
    END LOOP;
    /*
    ||Generate The Work Order Lines For The Selected Defects.
    */
    FOR i IN 1..lt_selected_repairs.count LOOP
      nm_debug.debug('Setting WOL Fields');
      /*
      ||Set The Work Order Line Columns.
      */
      lt_wol(i).wol_works_order_no := lv_work_order_no;
      lt_wol(i).wol_rse_he_id      := lt_selected_repairs(i).rep_rse_he_id;
      lt_wol(i).wol_siss_id        := lt_selected_repairs(i).def_siss_id;
      lt_wol(i).wol_icb_work_code  := lt_selected_repairs(i).work_code;
      lt_wol(i).wol_act_area_code  := lt_selected_repairs(i).rep_atv_acty_area_code;
      lt_wol(i).wol_def_defect_id  := lt_selected_repairs(i).rep_def_defect_id;
      lt_wol(i).wol_rep_action_cat := lt_selected_repairs(i).rep_action_cat;
      lt_wol(i).wol_flag           := 'D';
      lt_wol(i).wol_status_code    := lv_wol_instructed;
      lt_wol(i).wol_wor_flag       := 'D';
      lt_wol(i).wol_date_created   := SYSDATE;
      lt_wol(i).wol_bud_id         := lt_selected_repairs(i).bud_id;
      lt_wol(i).wol_est_cost       := 0;
      lt_wol(i).wol_est_labour     := 0;
      /*
      ||Reset The Null BOQ Cost WOL Level Flag.
      */
      lv_wol_null_boq_exists := FALSE;
      --
      /*
      ||Process BOQs.
      */
      /*
      ||Validate Any Supplied BOQs And Use Them To Replace The Existing Ones.
      */
      IF pi_defect_boqs.count > 0
       THEN
         validate_and_replace_boqs(pi_defect_id      => lt_selected_repairs(i).rep_def_defect_id
                                  ,pi_rep_action_cat => lt_selected_repairs(i).rep_action_cat
                                  ,pi_boqs_tab       => pi_defect_boqs);
      END IF;
      /*
      ||Get Any Boq's For The Repair.
      */
      nm_debug.debug('Fetching BOQs');
      SELECT boq_id
            ,boq_sta_item_code
            ,boq_est_quantity
            ,boq_est_labour
            ,sta_rogue_flag
        BULK COLLECT
        INTO lt_repair_boqs
        FROM boq_items
            ,standard_items
       WHERE sta_item_code      = boq_sta_item_code
         AND boq_rep_action_cat = lt_selected_repairs(i).rep_action_cat
         AND boq_defect_id      = lt_selected_repairs(i).rep_def_defect_id
         FOR UPDATE
          OF boq_est_rate
             NOWAIT
             ;
      --
      FOR j IN 1..lt_repair_boqs.count LOOP
        /*
        ||Set The Identifiers For The BOQ Table.
        */
        nm_debug.debug('Setting BOQ Fields');
        lt_boq(lv_boq_tab_ind).boq_id             := lt_repair_boqs(j).boq_id;
        lt_boq(lv_boq_tab_ind).boq_rep_action_cat := lt_selected_repairs(i).rep_action_cat;
        lt_boq(lv_boq_tab_ind).boq_defect_id      := lt_selected_repairs(i).rep_def_defect_id;
        /*
        ||Update Work Order and Work Order Line Labour Units.
        */
        nm_debug.debug('Calc Labour Units');
        IF lt_repair_boqs(j).boq_est_labour IS NOT NULL
         THEN
            lt_wol(i).wol_est_labour := lt_wol(i).wol_est_labour + lt_repair_boqs(j).boq_est_labour;
            lv_wor_est_labour := lv_wor_est_labour + lt_repair_boqs(j).boq_est_labour;
        END IF;
        /*
        ||Set The Rate For The BOQ From The Contract Item.
        */
        nm_debug.debug('Set BOQ Rate');
        IF lt_repair_boqs(j).sta_rogue_flag != 'Y'
         THEN
            lt_boq(lv_boq_tab_ind).boq_est_rate := maiwo.reprice_item(p_item_code => lt_repair_boqs(j).boq_sta_item_code
                                                                     ,p_con_id    => pi_con_id
                                                                     ,p_rse_he_id => lt_selected_repairs(i).rep_rse_he_id
                                                                     ,p_priority  => lt_selected_repairs(i).def_priority);
        END IF;
        /*
        ||Calculate The Estimated Cost.
        */
        nm_debug.debug('Calc Costs');
        IF lt_boq(lv_boq_tab_ind).boq_est_rate IS NOT NULL
         THEN
            BEGIN
              /*
              ||Update The BOQ Estimated Cost.
              */
              lt_boq(lv_boq_tab_ind).boq_est_cost := ROUND(lt_boq(lv_boq_tab_ind).boq_est_rate*lt_repair_boqs(j).boq_est_quantity,2);
              --
              IF NOT lv_wol_null_boq_exists
               THEN
                  /*
                  ||No Null BOQ Rates Detected So Far
                  ||On This WOL So Add The BOQ Estimated
                  ||Cost To The WOL Total Estimated Cost.
                  */
                  BEGIN
                  /*
                  ||Update Work Order Line Total.
                  */
                  lt_wol(i).wol_est_cost := lt_wol(i).wol_est_cost + lt_boq(lv_boq_tab_ind).boq_est_cost;
                  EXCEPTION
                    /*
                    ||Trap The Possibility Of The Value
                    ||Being Too Large For The Column.
                    */
                    WHEN value_error
                     THEN
                        raise_application_error(-20077,'Value Too Large For Work Order Line Estimated Cost');
                    WHEN others
                     THEN
                        RAISE;
                  END;
                  --
              END IF;
                --
              IF NOT lv_wor_null_boq_exists
               THEN
                  /*
                  ||No Null BOQ Rates Detected So Far
                  ||On This WO So Add The BOQ Estimated
                  ||Cost To The WO Total Estimated Cost.
                  */
                  BEGIN
                    /*
                    ||Update Work Order Total.
                    */
                    lv_wor_est_cost := lv_wor_est_cost + lt_boq(lv_boq_tab_ind).boq_est_cost;
                  EXCEPTION
                    /*
                    ||Trap The Possibility Of The Value
                    ||Being Too Large For The Column.
                    */
                    WHEN value_error
                     THEN
                        raise_application_error(-20076,'Value Too Large For Work Order Estimated Cost');
                    WHEN others
                     THEN
                        RAISE;
                  END;
                  --
              END IF;
              --
            EXCEPTION
              /*
              ||Trap The Possibility Of The Value
              ||Being Too Large For The Column.
              */
              WHEN value_error
               THEN
                  lt_boq(lv_boq_tab_ind).boq_est_cost := NULL;
                  lv_wol_null_boq_exists := TRUE;
                  lv_wor_null_boq_exists := TRUE;
              WHEN others
               THEN
                  RAISE;
            END;
        ELSE
            lt_boq(lv_boq_tab_ind).boq_est_cost := NULL;
            lv_wol_null_boq_exists := TRUE;
            lv_wor_null_boq_exists := TRUE;
        END IF;
        --
        lv_boq_tab_ind := lv_boq_tab_ind+1;
        --
      END LOOP; --lt_repair_boqs
      /*
      ||If Null BOQ Estimated Cost Detected
      ||At WOL Level Nullify The WOL Estimated Cost.
      */
      IF lv_wol_null_boq_exists
       THEN
          lt_wol(i).wol_est_cost := NULL;
      END IF;
      --
    END LOOP; --lt_selected_repairs
    /*
    ||If Null BOQ Estimated Cost Detected
    ||At WO Level Nullify The WO Estimated Cost.
    */
    IF lv_wor_null_boq_exists
     THEN
        lv_wor_est_cost := NULL;
    END IF;
    /*
    ||Repricing Caused No Errors So Get The WOL_IDs.
    */
    FOR i IN 1..lt_wol.count LOOP
      --
      lt_wol(i).wol_id := get_next_id('wol_id_seq');
      --
    END LOOP;
    /*
    ||Set The WOL_ID On The BOQs.
    */
    FOR i IN 1..lt_boq.count LOOP
      --
      FOR j IN 1..lt_wol.count LOOP
        IF lt_wol(j).wol_def_defect_id = lt_boq(i).boq_defect_id
         AND lt_wol(j).wol_rep_action_cat = lt_boq(i).boq_rep_action_cat
         THEN
            lt_boq(i).boq_wol_id := lt_wol(j).wol_id;
            exit;
        END IF;
      END LOOP;
      --
    END LOOP;
    --
  END select_defects;
  --
BEGIN
  --
  nm_debug.debug_on;
  /*
  ||Initialise Defaults.
  */
  init_defaults;
  /*
  ||Generate Work Order No.
  */
  lv_work_order_no := mai.generate_works_order_no(p_con_id     => pi_con_id
                                                 ,p_admin_unit => lv_wor_admin_unit);
  /*
  ||Determine Which Defects Will Go On The WO.
  */
  select_defects;
  /*
  ||Create The Work Order.
  */
  IF lt_wol.count > 0
   THEN
      /*
      ||Calaculate The Estmated Balancing Sum.
      */
      lv_wor_est_balancing_sum := get_balancing_sum(pi_con_id,lv_wor_est_cost);
      /*
      ||Insert The Work Order.
      */
      INSERT
        INTO work_orders
            (wor_scheme_type
            ,wor_works_order_no
            ,wor_descr
            ,wor_sys_flag
            ,wor_rse_he_id_group
            ,wor_flag
            ,wor_con_id
            ,wor_date_raised
            ,wor_est_complete
            ,wor_job_number
            ,wor_peo_person_id
            ,wor_icb_item_code
            ,wor_icb_sub_item_code
            ,wor_icb_sub_sub_item_code
            ,wor_interim_payment_flag
            ,wor_priority
            ,wor_coc_cost_centre
            ,wor_register_flag
            ,wor_contact
            ,wor_rechargeable
            ,wor_est_cost
            ,wor_est_labour
            ,wor_est_balancing_sum
            )
      VALUES(lv_scheme_type
            ,lv_work_order_no
            ,pi_wo_descr
            ,lv_sys_flag
            ,lv_road_group_id
            ,'D'
            ,pi_con_id
            ,lv_date_raised
            ,pi_target_date
            ,NVL(pi_job_number,'00000')
            ,pi_user_id
            ,substr(lv_work_code,1,2)
            ,substr(lv_work_code,3,2)
            ,substr(lv_work_code,5,2)
            ,pi_interim_payment
            ,pi_priority
            ,pi_cost_centre
            ,NVL(pi_tma_register_flag,'N')
            ,pi_contact
            ,pi_rechargeable
            ,lv_wor_est_cost
            ,lv_wor_est_labour
            ,lv_wor_est_balancing_sum
            )
            ;
      /*
      ||Insert The Work Order Lines.
      */
      FORALL i IN 1..lt_wol.count
      INSERT
        INTO(SELECT wol_id
                   ,wol_works_order_no
                   ,wol_rse_he_id
                   ,wol_siss_id
                   ,wol_icb_work_code
                   ,wol_act_area_code
                   ,wol_def_defect_id
                   ,wol_rep_action_cat
                   ,wol_flag
                   ,wol_status_code
                   ,wol_wor_flag
                   ,wol_date_created
                   ,wol_bud_id
                   ,wol_est_cost
                   ,wol_est_labour
               FROM work_order_lines)
      VALUES lt_wol(i)
           ;
      /*
      ||Update Defects.
      */
      FOR i IN 1..lt_wol.count LOOP
        UPDATE defects
           SET def_status_code       = lv_def_instructed
              ,def_last_updated_date = SYSDATE
              ,def_works_order_no    = lv_work_order_no
         WHERE def_defect_id = lt_wol(i).wol_def_defect_id
             ;
      END LOOP;
      /*
      ||Update BOQs.
      */
      FOR i IN 1..lt_boq.count LOOP
        UPDATE boq_items
           SET boq_wol_id   = lt_boq(i).boq_wol_id
              ,boq_est_rate = lt_boq(i).boq_est_rate
              ,boq_est_cost = lt_boq(i).boq_est_cost
         WHERE boq_id = lt_boq(i).boq_id
             ;
      END LOOP;
      /*
      ||Set The Output Parameters.
      */
      po_work_order_no := lv_work_order_no;
      --
  END IF;
  /*
  ||Commit If Required.
  */
  IF lt_wol.count > 0
   THEN
      IF NVL(pi_commit,'Y') = 'Y'
       THEN
          nm_debug.debug('Commit.');
          COMMIT;
      END IF;
  ELSE
      /*
      ||No WO created so rollback to ensure
      ||any updates (e.g. last wo number)
      ||are undone.
      */
      ROLLBACK;
  END IF;
  --
  nm_debug.debug_off;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      --
      nm_debug.debug_off;
      --
      RAISE;
END create_defect_work_order;
--
-----------------------------------------------------------------------------
--
PROCEDURE instruct_work_order(pi_user_id         IN hig_users.hus_user_id%TYPE
                             ,pi_works_order_no  IN work_orders.wor_works_order_no%TYPE
                             ,pi_date_instructed IN work_orders.wor_date_confirmed%TYPE
                             ,pi_commit          IN VARCHAR2)
  IS
  --
  lr_user hig_users%ROWTYPE;
  lr_wo   work_orders%ROWTYPE;
  lr_con  contracts%ROWTYPE;
  lr_org  org_units%ROWTYPE;
  --
  TYPE wol_tab IS TABLE OF work_order_lines%ROWTYPE INDEX BY BINARY_INTEGER;
  lt_wols wol_tab;
  --
  PROCEDURE get_user
    IS
  BEGIN
    --
    SELECT *
      INTO lr_user
      FROM hig_users
     WHERE hus_user_id = pi_user_id
         ;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
    WHEN others
     THEN
        RAISE;
  END get_user;
  --
  PROCEDURE get_wols
    IS
  BEGIN
    /*
    ||Get And Lock The Work Order Lines Records.
    */
    SELECT *
      BULK COLLECT
      INTO lt_wols
      FROM work_order_lines
     WHERE wol_works_order_no = pi_works_order_no
       FOR UPDATE
        OF wol_est_cost
           NOWAIT
         ;
    /*
    ||Currently BULK COLLECT Doesn't Raise no_data_found
    ||So Check The Number Of Rows Returned.
    */
    IF lt_wols.count = 0
     THEN
        raise_application_error(-20051,'Cannot Instruct A Work Order With No Lines.');
    END IF;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20051,'Cannot Instruct A Work Order With No Lines.');
    WHEN others
     THEN
        RAISE;
  END get_wols;
  --
  FUNCTION all_lines_priced
    RETURN BOOLEAN IS
    --
    lv_retval BOOLEAN := TRUE;
    --
  BEGIN
    FOR i IN 1..lt_wols.count LOOP
      --
      IF lt_wols(i).wol_est_cost IS NULL
       THEN
          lv_retval := FALSE;
          exit;
      END IF;
      --
    END LOOP;
    --
    RETURN lv_retval;
    --
  END all_lines_priced;
  --
  PROCEDURE check_contract
    IS
    --
    lv_dumconcode  hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('DUMCONCODE'),'DEFAULT');
    --
    PROCEDURE get_contract
      IS
    BEGIN
      --
      SELECT *
        INTO lr_con
        FROM contracts
       WHERE con_id = lr_wo.wor_con_id
           ;
      --
      SELECT *
        INTO lr_org
        FROM org_units
       WHERE oun_org_id = lr_con.con_contr_org_id
           ;
      --
    EXCEPTION
      WHEN no_data_found
       THEN
          raise_application_error(-20064,'Invalid Contract On Work Order.');
      WHEN others
       THEN
          RAISE;
    END get_contract;
    --
  BEGIN
    IF lr_wo.wor_con_id IS NULL
     THEN
        raise_application_error(-20069,'No Contract On Work Order.');
    ELSE
        --
        get_contract;
        --
        IF lv_dumconcode IS NOT NULL
         AND lv_dumconcode = lr_con.con_code
         THEN
            raise_application_error(-20050,'Cannot Instruct A Work Order That Is Using The Dummy Contract.');
        END IF;
        --
        IF pi_date_instructed NOT BETWEEN lr_con.con_start_date
                                      AND NVL(lr_con.con_year_end_date,lr_con.con_end_date)
         THEN
            raise_application_error(-20061,'Contract On Work Order Is Out Of Date.');
        END IF;
        --
    END IF;
    --
  END check_contract;
  --
  PROCEDURE authorise_wo
    IS
    --
    lv_auth_own hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('AUTH_OWN'),'Y');
    --
  BEGIN
    /*
    ||Make Sure User Can Authorise.
    */
    IF NOT (lr_wo.wor_date_raised between nvl(lr_user.hus_start_date, lr_wo.wor_date_raised)
                                      and nvl(lr_user.hus_end_date-1, lr_wo.wor_date_raised))
     THEN
        raise_application_error(-20078,'Work Order Date Raised Is Outside Users Start/End Dates.');
    END IF;
    --
    IF lr_wo.wor_est_cost IS NOT NULL
     AND apply_balancing_sum(pi_con_id => lr_wo.wor_con_id
                            ,pi_value  => lr_wo.wor_est_cost)
         BETWEEN nvl(lr_user.hus_wor_aur_min,0)
             AND nvl(lr_user.hus_wor_aur_max,999999999)
     THEN
        /*
        ||Okay So Far
        */
        NULL;
    ELSE
        raise_application_error(-20049,'Cannot Authorise Works Order, Cost Is Outside User Limits.');
    END IF;
    --
    IF pi_user_id = lr_wo.wor_peo_person_id
     AND lv_auth_own != 'Y'
     THEN
        raise_application_error(-20075,'Users Are Not Allowed To Authorise Work Orders They Have Raised.');
    END IF;
    /*
    ||All Okay So Authorise.
    */
    lr_wo.wor_mod_by_id := pi_user_id;
    --
  END authorise_wo;
  --
  PROCEDURE update_budgets
    IS
  BEGIN
    --
    FOR i IN 1..lt_wols.count LOOP
      --
      IF within_budget(pi_bud_id => lt_wols(i).wol_bud_id
                      ,pi_con_id => lr_wo.wor_con_id
                      ,pi_est    => lt_wols(i).wol_est_cost
                      ,pi_act    => lt_wols(i).wol_act_cost
                      ,pi_wol_id => lt_wols(i).wol_id)
       THEN
          add_to_budget(pi_wol_id => lt_wols(i).wol_id
                       ,pi_bud_id => lt_wols(i).wol_bud_id
                       ,pi_con_id => lr_wo.wor_con_id
                       ,pi_est    => lt_wols(i).wol_est_cost
                       ,pi_act    => lt_wols(i).wol_act_cost);
      ELSE
          raise_application_error(-20047,'Budget Exceeded.');
      END IF;
      --
    END LOOP;
    --
  END update_budgets;
  --
  PROCEDURE update_interfaces
    IS
    --
    lr_ne nm_elements_all%ROWTYPE;
    --
    lv_originator hig_users.hus_name%TYPE;
    --
  BEGIN
    --
    IF interfaces_used(pi_con_id => lr_wo.wor_con_id)
     THEN
        --
        lv_originator := nm3get.get_hus(pi_hus_user_id => lr_wo.wor_peo_person_id).hus_name;
        --
        interfaces.add_wor_to_list(p_trans_type   => 'C'
                                  ,p_wor_no       => lr_wo.wor_works_order_no                 
                                  ,p_wor_flag     => lr_wo.wor_flag                           
                                  ,p_scheme_type  => lr_wo.wor_scheme_type                    
                                  ,p_con_code     => lr_con.con_code                           
                                  ,p_originator   => lv_originator                           
                                  ,p_confirmed    => pi_date_instructed                 
                                  ,p_est_complete => lr_wo.wor_est_complete                   
                                  ,p_cost         => lr_wo.wor_est_cost
                                  ,p_labour       => lr_wo.wor_est_labour                     
                                  ,p_ip_flag      => lr_wo.wor_interim_payment_flag           
                                  ,p_ra_flag      => lr_wo.wor_risk_assessment_flag           
                                  ,p_ms_flag      => lr_wo.wor_method_statement_flag          
                                  ,p_wp_flag      => lr_wo.wor_works_programme_flag           
                                  ,p_as_flag      => lr_wo.wor_additional_safety_flag         
                                  ,p_commence_by  => lr_wo.wor_commence_by                    
                                  ,p_descr        => lr_wo.wor_descr);
        --
        FOR i IN 1..lt_wols.count LOOP
          --
          lr_ne := nm3get.get_ne(pi_ne_id => lt_wols(i).wol_rse_he_id);
          --
          interfaces.add_wol_to_list(lt_wols(i).wol_id
                                    ,lt_wols(i).wol_works_order_no
                                    ,lt_wols(i).wol_def_defect_id
                                    ,lt_wols(i).wol_schd_id
                                    ,lt_wols(i).wol_icb_work_code
                                    ,lr_ne.ne_unique
                                    ,lr_ne.ne_descr);
          --
        END LOOP;
        --
        interfaces.copy_data_to_interface;
        --
    END IF;
    --
  END update_interfaces;
  --
BEGIN
  --
  nm_debug.debug_on;
  /*
  ||Get User Details.
  */
  get_user;
  /*
  ||Get The Work Order Details.
  */
  lr_wo := get_and_lock_wo(pi_works_order_no => pi_works_order_no);
  get_wols;
  /*
  ||Make Sure This Isn't A Cyclic Work Order
  */
  IF lr_wo.wor_flag = 'M'
   THEN
      raise_application_error(-20073,'This API Does Not Support Cyclic Work Orders. Please Use The Forms Application To Instruct Cyclic Work Orders.');
  END IF;
  /*
  ||Make Sure The Work Order Hasn't Already Been Instructed.
  */
  IF lr_wo.wor_date_confirmed IS NOT NULL
   THEN
      raise_application_error(-20079,'Work Order Has Already Been Instructed');
  END IF;
  /*
  ||Check Closure Date, the Work Order May have been Cancelled.
  */
  IF lr_wo.wor_date_closed IS NOT NULL
   THEN
      raise_application_error(-20083,'Work Order Has Been Cancelled.');
  END IF;
  /*
  ||Check The Date Confirmed Provided.
  */
  IF pi_date_instructed < lr_wo.wor_date_raised
   THEN
      raise_application_error(-20085,'Date Confirmed Must Be On Or Later Than The Date Raised ['
                                     ||TO_CHAR(lr_wo.wor_date_raised,'DD-MON-RRRR')||'].');
  END IF;
  /*
  ||Check The Contract.
  */
  check_contract;
  /*
  ||Make Sure All Lines Are Priced.
  */
  IF NOT all_lines_priced
   THEN
      raise_application_error(-20048,'All Work Order Lines Must Be Priced.');
  END IF;
  /*
  ||If The Work Order Has Not Been Authorised
  ||Check Whether The User Can Do So. If They
  ||Can Then Authorise It.
  */
  IF lr_wo.wor_mod_by_id IS NULL
   THEN
      authorise_wo;
  END IF;
  /*
  ||Instruct The Work Order.
  */
  UPDATE work_orders
     SET wor_mod_by_id      = lr_wo.wor_mod_by_id
        ,wor_date_confirmed = pi_date_instructed
   WHERE wor_works_order_no = pi_works_order_no
       ;
  /*
  ||Update The Budgets.
  */
  update_budgets;
  /*
  ||Update Interfaces If Required.
  */
  update_interfaces;
  /*
  ||Commit If Required.
  */
  IF NVL(pi_commit,'Y') = 'Y'
   THEN
      nm_debug.debug('Commit.');
      COMMIT;
  END IF;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      --
      nm_debug.debug(SUBSTR('instruct_work_order raised : '||SQLERRM,1,4000));
      nm_debug.debug_off;
      --
      RAISE;
END instruct_work_order;
--
-----------------------------------------------------------------------------
--
PROCEDURE receive_work_order(pi_user_id        IN hig_users.hus_user_id%TYPE
                            ,pi_works_order_no IN work_orders.wor_works_order_no%TYPE
                            ,pi_date_received  IN work_orders.wor_date_received%TYPE
                            ,pi_commit         IN VARCHAR2)
  IS
  --
  lr_wo  work_orders%ROWTYPE;
  --
BEGIN
  nm_debug.debug_on;
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Get The Work Order Details
  ||And Lock The Record For Update.
  */
  lr_wo := get_and_lock_wo(pi_works_order_no => pi_works_order_no);
  /*
  ||Make Sure The WO Can Be Received.
  */
  IF lr_wo.wor_date_confirmed IS NULL
   THEN
      raise_application_error(-20092,'Cannot Set A Works Order That Has Not Been Instructed As Received.');
  END IF;
  /*
  ||Check The Date Received.
  */
  IF pi_date_received < lr_wo.wor_date_confirmed
   THEN
      raise_application_error(-20093,'Date Received ['||TO_CHAR(pi_date_received,'DD-MON-RRRR')
                                   ||']Must Not Be Less Than The Date Instructed ['||TO_CHAR(lr_wo.wor_date_confirmed,'DD-MON-RRRR')||'].');
  END IF;
  /*
  ||Update The Work Order.
  */
  UPDATE work_orders
     SET wor_received_by = pi_user_id
        ,wor_date_received = pi_date_received
   WHERE wor_works_order_no = pi_works_order_no
       ;
  /*
  ||Commit If Required.
  */
  IF NVL(pi_commit,'Y') = 'Y'
   THEN
      nm_debug.debug('Commit.');
      COMMIT;
  END IF;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      --
      nm_debug.debug(SUBSTR('receive_work_order raised : '||SQLERRM,1,4000));
      nm_debug.debug_off;
      --
      RAISE;
END receive_work_order;
--
-----------------------------------------------------------------------------
--
FUNCTION get_wol_status_flags(pi_status_code work_order_lines.wol_status_code%TYPE
                             ,pi_date_raised work_orders.wor_date_raised%TYPE)
  RETURN flags_rec IS
  --
  lr_retval flags_rec;
  --
BEGIN
  /*
  ||Get The Flags.
  */
  SELECT hsc_allow_feature1 feature1
        ,hsc_allow_feature2 feature2
        ,hsc_allow_feature3 feature3
        ,hsc_allow_feature4 feature4
        ,hsc_allow_feature5 feature5
        ,hsc_allow_feature6 feature6
        ,hsc_allow_feature7 feature7
        ,hsc_allow_feature8 feature8
        ,hsc_allow_feature9 feature9
   INTO lr_retval
   FROM hig_status_codes
  WHERE hsc_domain_code = 'WORK_ORDER_LINES'
    AND hsc_status_code = pi_status_code
    AND (pi_date_raised BETWEEN NVL(hsc_start_date,pi_date_raised)
                            AND NVL(hsc_end_date, pi_date_raised)
         OR pi_date_raised IS NULL)
      ;
  /*
  ||Return The Flags.
  */
  RETURN lr_retval;
  --
END get_wol_status_flags;
--
-----------------------------------------------------------------------------
--
FUNCTION wol_status_is_actual(pi_flags IN flags_rec)
  RETURN BOOLEAN IS
  --
  lv_retval BOOLEAN := FALSE;
  --
BEGIN
  /*
  ||Get The Status Code Flags.
  */
  IF (pi_flags.feature3 = 'Y'
      OR pi_flags.feature8 = 'Y'
      OR pi_flags.feature9 = 'Y')
   THEN
      lv_retval := TRUE;
  END IF;
  --
  RETURN lv_retval;
  --
END wol_status_is_actual;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_wol_status(pi_user_id       IN hig_users.hus_user_id%TYPE
                           ,pi_wol_id        IN work_order_lines.wol_id%TYPE
                           ,pi_new_status    IN work_order_lines.wol_status_code%TYPE
                           ,pi_date_complete IN work_order_lines.wol_date_complete%TYPE
                           ,pi_boq_tab       IN act_boq_tab
                           ,pi_commit        IN VARCHAR2)
  IS
  --
  lr_old_status flags_rec;
  lr_new_status flags_rec;
  --
  lr_wo     work_orders%ROWTYPE;
  lr_wol    work_order_lines%ROWTYPE;
  lr_defect defects%ROWTYPE;
  --
  lv_complete_status  BOOLEAN := FALSE;
  lv_interim_status   BOOLEAN := FALSE;
  lv_not_done_status  BOOLEAN := FALSE;
  lv_valid_transition BOOLEAN := TRUE;
  lv_reason           VARCHAR2(200);
  lv_actual_costs     BOOLEAN := FALSE;
  --
  lv_wor_est_cost           work_orders.wor_est_cost%TYPE;
  lv_wor_est_balancing_sum  work_orders.wor_est_balancing_sum%TYPE;
  lv_wor_est_labour         work_orders.wor_est_labour%TYPE;
  lv_wor_act_cost           work_orders.wor_act_cost%TYPE;
  lv_wor_act_balancing_sum  work_orders.wor_act_balancing_sum%TYPE;
  lv_wor_act_labour         work_orders.wor_act_labour%TYPE;
  lv_wor_date_closed        work_orders.wor_date_closed%TYPE;
  --
  lv_def_status_code  defects.def_status_code%TYPE;
  --
  PROCEDURE validate_date_complete
    IS
  BEGIN
    --
    IF pi_date_complete IS NOT NULL
     THEN
        --
        IF pi_date_complete > SYSDATE
         THEN
            raise_application_error(-20105,'Date Complete Must Be Less Than Or Equal To Todays Date.');
        END IF;
        --
        IF pi_date_complete < lr_wo.wor_date_confirmed
         OR lr_wo.wor_date_confirmed IS NULL
         THEN
            raise_application_error(-20106,'Date Complete Must Be On Or Later Than The Date Raised ['
                                           ||TO_CHAR(lr_wo.wor_date_raised,'DD-MON-RRRR')||'].');
        END IF;
        --
    END IF;
    --
  END validate_date_complete;
  --
  PROCEDURE validate_wol_status_change
    IS
    --
    PROCEDURE set_defect_status
      IS
      --
      lv_def_feature2 hig_status_codes.hsc_allow_feature2%TYPE := 'N';
      lv_def_feature3 hig_status_codes.hsc_allow_feature3%TYPE := 'N';
      lv_def_feature4 hig_status_codes.hsc_allow_feature4%TYPE := 'N';
      lv_dummy        NUMBER;
      --
      PROCEDURE get_def_status
        IS
      BEGIN
        --
        SELECT hsc_status_code
          INTO lv_def_status_code
          FROM hig_status_codes
         WHERE hsc_domain_code = 'DEFECTS'
           AND hsc_allow_feature2 = lv_def_feature2
           AND hsc_allow_feature3 = lv_def_feature3
           AND hsc_allow_feature4 = lv_def_feature4
             ;
        --
      EXCEPTION
        WHEN too_many_rows
         THEN
            raise_application_error(-20108,'Too Many Values Defined For Defect Status.');
        WHEN no_data_found
         THEN
            raise_application_error(-20109,'Cannot Obtain Value For Defect Status.');
        WHEN others
         THEN
            RAISE;
      END get_def_status;
      --
      FUNCTION other_repair_assigned
        RETURN BOOLEAN IS
        --
        lv_dummy  NUMBER;
        lv_retval BOOLEAN := FALSE;
        --
        CURSOR chk_reps(cp_defect_id  defects.def_defect_id%TYPE
                       ,cp_wol_id     work_order_lines.wol_id%TYPE)
            IS
        SELECT 1
          FROM work_order_lines
              ,hig_status_codes
         WHERE wol_def_defect_id = cp_defect_id
           AND wol_status_code != hsc_status_code
           AND wol_id != cp_wol_id
           AND hsc_domain_code = 'WORK_ORDER_LINES'
           AND hsc_allow_feature5 = 'Y'
             ;
      BEGIN
        --
        OPEN  chk_reps(lr_wol.wol_def_defect_id
                      ,lr_wol.wol_id);
        FETCH chk_reps
         INTO lv_dummy;
        lv_retval := chk_reps%FOUND;
        CLOSE chk_reps;
        --
        RETURN lv_retval;
        --
      EXCEPTION
        WHEN no_data_found
         THEN
            RETURN FALSE;
        WHEN others
         THEN
            RAISE;
      END other_repair_assigned;
    BEGIN
      --
      IF lr_new_status.feature2 = 'Y'
       OR lr_new_status.feature3 = 'Y'
       THEN
          /*
          ||WOL Is Held Or Complete
          ||So Defect Is Complete.
          */
          lv_def_feature4 := 'Y';
          --
      ELSIF lr_new_status.feature5 = 'Y'
       THEN
          /*
          ||WOL Is Not Done.
          */
          IF other_repair_assigned
           THEN
              /*
              ||Defect Is Instructed.
              */
              lv_def_feature3 := 'Y';
              --
          ELSE
              /*
              ||Defect Is Available.
              */
              lv_def_feature2 := 'Y';
              --
          END IF;
          --
      ELSE
          /*
          ||Defect Is Instructed.
          */
          lv_def_feature3 := 'Y';
          --
      END IF;
      /*
      ||Now Get Defect Status Code
      ||Based On The Flags Set.
      */
      get_def_status;
      --
    END set_defect_status;
    --
  BEGIN
    /*
    ||Make Sure Status Change Is Allowed.
    */
--    IF NVL(lr_wol.wol_status_code,'@') = NVL(pi_new_status, '@')
--     THEN
--        /*
--        ||No Change In Status So No Need To Do Anything.
--        */
--        lv_valid_transition := FALSE;
--        lv_reason := 'Works Order Line Status Is Already Set To '||pi_new_status;
--    END IF;
    --
    IF lr_wo.wor_date_confirmed IS NULL
     THEN
        /*
        ||Cannot Amend Status On Unconfirmed Works Order.
        */
        lv_valid_transition := FALSE;
        lv_reason := 'Cannot Amend Status On Unconfirmed Works Order.';
    END IF;
    /*
    ||Check That The Transition From The
    ||Old Status To The New Status Is Valid.
    */
    IF lv_valid_transition
     THEN
        /*
        ||Get The Flags.
        */
        BEGIN
          lr_old_status := get_wol_status_flags(pi_status_code => lr_wol.wol_status_code
                                               ,pi_date_raised => NULL);
        EXCEPTION
          WHEN no_data_found
           THEN
              lv_valid_transition:= FALSE;
              lv_reason := 'Old Status Code Does Not Exist.';
          WHEN others
           THEN
              RAISE;
        END;
        --
        BEGIN
          lr_new_status := get_wol_status_flags(pi_status_code => pi_new_status
                                               ,pi_date_raised => lr_wo.wor_date_raised);
        EXCEPTION
          WHEN no_data_found
           THEN
              lv_valid_transition:= FALSE;
              lv_reason := 'New Status Code Does Not Exist.';
          WHEN others
           THEN
              RAISE;
        END;
        --
        IF lv_valid_transition
         THEN
            CASE
              WHEN lr_new_status.feature4 = 'Y'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'User Cannot Set Status To PAID or PART PAID.';
              WHEN lr_new_status.feature2 = 'Y'
               AND lr_old_status.feature2 = 'Y'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Is Already At HELD.';                  
              WHEN lr_new_status.feature5 = 'Y'
               AND lr_old_status.feature5 = 'Y'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Is Already At NOT_DONE.';                  
              WHEN lr_new_status.feature1 = 'Y'
               AND lr_old_status.feature1 = 'Y'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Is Already At INSTRUCTED.';                  
              WHEN (lr_new_status.feature3 = 'Y'
                    AND lr_old_status.feature3 = 'Y')
               OR (lr_new_status.feature5 = 'Y'
                   AND lr_wol.wol_date_complete IS NOT NULL)
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Work Order Line Has Already Been Completed.';
              WHEN lr_new_status.feature3 = 'Y'
               AND NOT mai.contract_still_in_date(p_wo_no => lr_wol.wol_id)
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Work Order Line Cannot Be Completed, Contract Is Out Of Date.';               
              WHEN (lr_old_status.feature2 = 'Y'
                    OR lr_old_status.feature3 = 'Y')
               AND lr_new_status.feature9 = 'Y'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Change From HELD Or COMPLETE To INTERIM Is Not Allowed.';
              --WHEN lr_old_status.feature8 != 'Y'
              -- AND lr_new_status.feature9 = 'Y'
              -- THEN
              --    lv_valid_transition := FALSE;
              --    lv_reason := 'Status Can Only Be Changed To INTERIM From VALUATION.';
              WHEN lr_old_status.feature4 = 'Y'
               AND (lr_new_status.feature2 = 'Y'
                    OR lr_new_status.feature5 = 'Y')
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Cannot Be Changed From PAID Or PART PAID To HELD Or NOT DONE.';
              WHEN lr_new_status.feature3 = 'Y'
               AND maiwo.can_complete_wol(p_works_order_no => lr_wo.wor_works_order_no) = 'FALSE'
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'User Is Not Allowed To Complete The Line When The Contractor Interface Is In Use.';
              WHEN NVL(lr_wo.wor_interim_payment_flag,'N') != 'Y'
               AND (lr_new_status.feature8 = 'Y'
                    OR lr_new_status.feature9  = 'Y')
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Works Order Interim Payment Flag Must Be Set Before INTERIM and VALUATION Are Allowed.';
              WHEN ((lr_new_status.feature9 = 'Y' and lr_new_status.feature4 != 'Y')
                    OR lr_new_status.feature8 = 'Y')
               AND maiwo.final_claim_exists(p_wol_id => lr_wol.wol_id)
               THEN
                  lv_valid_transition := FALSE;
                  lv_reason := 'Status Of INTERIM Or VALUATION Is Not Allowed Once A Final Claim Has Been Made.';
              ELSE
                  NULL;
            END CASE;
            --
        END IF;
    END IF;
    --
    IF lv_valid_transition
     THEN
        /*
        ||Determine Whether Any Boq Calculations
        ||Should Be Estimates Or Actuals.
        */
        lv_actual_costs := wol_status_is_actual(pi_flags => lr_new_status);
        /*
        ||Determine Whether New Status
        ||Requires An Interim Payment.
        */
        IF lr_new_status.feature9 = 'Y'
         AND lr_new_status.feature4 != 'Y'
         THEN
            lv_interim_status := TRUE;
        END IF;
        /*
        ||Determine Whether The New Status
        ||Is Completing The Work Order Line.
        */
        lv_complete_status := maiwo.complete_status(p_status => pi_new_status);
        /*
        ||Determine Whether The New Status
        ||Is Marking The Work Order Line As Not Done.
        */
        IF lr_new_status.feature5 = 'Y'
         THEN
            lv_not_done_status := TRUE;
        END IF;
        /*
        ||If The Work Order Line Has A Defect
        ||Associated Determine The Defect Status.
        */
        set_defect_status;
        --
    END IF;
    --
  END validate_wol_status_change;
  --
  PROCEDURE process_boqs
    IS
    --
    lr_sta            standard_items%ROWTYPE;
    lr_blank_boq      boq_items%ROWTYPE;
    lr_new_boq        boq_items%ROWTYPE;
    lr_upd_boq        boq_items%ROWTYPE;
    lr_new_perc_item  boq_items%ROWTYPE;
    --
    lv_perc_item_unit hig_option_values.hov_value%TYPE := hig.get_sysopt('PERC_ITEM');
    --
    PROCEDURE insert_new_perc_item(pi_parent_id IN boq_items.boq_parent_id%TYPE
                                  ,pi_item_code IN standard_items.sta_item_code%TYPE)
      IS
      --
      lr_sta_perc   standard_items%ROWTYPE;
      lr_perc_item  boq_items%ROWTYPE;
      --
      lv_rate  boq_items.boq_act_rate%TYPE;
      --
    BEGIN
      --
      lr_sta_perc := get_sta(pi_sta_item_code => pi_item_code);
      --
      lv_rate := maiwo.reprice_item(p_item_code => pi_item_code
                                   ,p_con_id    => lr_wo.wor_con_id
                                   ,p_rse_he_id => lr_wol.wol_rse_he_id
                                   ,p_priority  => lr_defect.def_priority);
      IF lv_rate IS NULL
       THEN
          raise_application_error(-20101,'Item Code ['||lr_new_boq.boq_sta_item_code||'] Is Not A Valid Contract Item.');
      END IF;
      --
      lr_perc_item.boq_id             := get_next_id('BOQ_ID_SEQ');
      lr_perc_item.boq_parent_id      := pi_parent_id;
      lr_perc_item.boq_sta_item_code  := pi_item_code;
      lr_perc_item.boq_item_name      := lr_sta_perc.sta_item_name;
      lr_perc_item.boq_work_flag      := lr_wol.wol_flag;
      lr_perc_item.boq_defect_id      := NVL(lr_wol.wol_def_defect_id,0);
      lr_perc_item.boq_rep_action_cat := NVL(lr_wol.wol_rep_action_cat,'X');
      lr_perc_item.boq_wol_id         := lr_wol.wol_id;
      lr_perc_item.boq_date_created   := sysdate;
      lr_perc_item.boq_est_dim1       := 0;
      lr_perc_item.boq_est_dim2       := NULL;
      lr_perc_item.boq_est_dim3       := NULL;
      lr_perc_item.boq_est_quantity   := 0;
      lr_perc_item.boq_est_cost       := 0;
      lr_perc_item.boq_est_rate       := 0;
      lr_perc_item.boq_act_dim1       := 1;
      lr_perc_item.boq_act_dim2       := NULL;
      lr_perc_item.boq_act_dim3       := NULL;
      lr_perc_item.boq_act_quantity   := 1;
      lr_perc_item.boq_act_rate       := lv_rate;
      lr_perc_item.boq_act_cost       := 0;
      --
      INSERT
        INTO boq_items
      VALUES lr_perc_item
           ;
      --
    END insert_new_perc_item;
    --
    PROCEDURE recalc_percent_items
      IS
      --
      TYPE perc_item_rec IS RECORD(child_id  boq_items.boq_id%TYPE
                                  ,parent_id boq_items.boq_id%TYPE);
      TYPE perc_item_tab IS TABLE OF perc_item_rec INDEX BY BINARY_INTEGER;
      lt_perc_items perc_item_tab;
      --
      lv_dummy NUMBER;
      --
      PROCEDURE get_perc_items
        IS
      BEGIN
        SELECT boq_id        child_id
              ,boq_parent_id parent_id
          BULK COLLECT
          INTO lt_perc_items
          FROM boq_items
         WHERE boq_wol_id = lr_wol.wol_id
           AND boq_parent_id IS NOT NULL
             ;
      EXCEPTION
        WHEN no_data_found
         THEN
            NULL;
        WHEN others
         THEN
            RAISE;
      END get_perc_items;
      --
    BEGIN
      get_perc_items;
      FOR i IN 1..lt_perc_items.count LOOP
        lv_dummy := maiwo.recalc_percent_item(p_boq_item    => lt_perc_items(i).parent_id
                                             ,p_comp_method => lr_wo.wor_perc_item_comp);
        IF lv_dummy != -1
         THEN
            raise_application_error(-20103,'An Error Occured Whilst Recalculating Percent Items.');
        END IF;
      END LOOP;
    END recalc_percent_items;
    --
  BEGIN
    /*
    ||Process Any BOQs Passed In.
    */
    IF pi_boq_tab.count > 0
     THEN
        IF NOT lv_actual_costs
         THEN
            raise_application_error(-20100,'Update Of BOQs Is Only Supported For Actual Costs.');
        END IF;
        --
        FOR i IN 1..pi_boq_tab.count LOOP
          /*
          ||Validate Standard Item Code.
          */
          IF pi_boq_tab(i).boq_sta_item_code IS NOT NULL
           THEN
              lr_sta := get_sta(pi_sta_item_code => pi_boq_tab(i).boq_sta_item_code);
              IF lr_sta.sta_unit = lv_perc_item_unit
               THEN
                  raise_application_error(-20099,'Parent BOQs Based On Percentage Items Codes Are Not Supported.');
              END IF;
          ELSE
              raise_application_error(-20032,'Invalid Standard Item Code Specified.');
          END IF;
          --
          IF pi_boq_tab(i).boq_id IS NOT NULL
           THEN
              /*
              ||Existing BOQ So Get The Record From The Database.
              */
              lr_upd_boq := lr_blank_boq;
              --
              BEGIN
                SELECT *
                  INTO lr_upd_boq
                  FROM boq_items
                 WHERE boq_id = pi_boq_tab(i).boq_id
                   AND boq_wol_id = lr_wol.wol_id
                     ;
              EXCEPTION
                WHEN no_data_found
                 THEN
                    raise_application_error(-20091,'BOQ_ID ['||TO_CHAR(pi_boq_tab(i).boq_id)
                                                 ||'] Is Not A Child Of The Specified Parent - Work Order Line ['
                                                 ||TO_CHAR(lr_wol.wol_id)||'].');
                WHEN others
                 THEN
                    RAISE;
              END;
              /*
              ||Update Actual Dimensions etc.
              */
              lr_upd_boq.boq_act_dim1 := NVL(pi_boq_tab(i).boq_act_dim1,NVL(lr_upd_boq.boq_act_dim1,0));
              --
              IF lr_sta.sta_dim2_text IS NOT NULL
               THEN
                  lr_upd_boq.boq_act_dim2 := NVL(pi_boq_tab(i).boq_act_dim2,NVL(lr_upd_boq.boq_act_dim2,1));
              END IF;
              --
              IF lr_sta.sta_dim3_text IS NOT NULL
               THEN
                  lr_upd_boq.boq_act_dim3 := NVL(pi_boq_tab(i).boq_act_dim3,NVL(lr_upd_boq.boq_act_dim3,1));
              END IF;
              /*
              ||Set Actual Quantity.
              */
              lr_upd_boq.boq_act_quantity := lr_upd_boq.boq_act_dim1
                                             * NVL(lr_upd_boq.boq_act_dim2,1)
                                             * NVL(lr_upd_boq.boq_act_dim3,1);
              /*
              ||Check Quantity.
              */
              IF lr_upd_boq.boq_act_quantity < lr_sta.sta_min_quantity
               AND lr_upd_boq.boq_act_quantity != 0
               THEN
                  raise_application_error(-20035,'Actual Quantity Is Below The Minimum Quantity.');
              END IF;
              --
              IF lr_upd_boq.boq_act_quantity > lr_sta.sta_max_quantity
               AND lr_upd_boq.boq_act_quantity != 0
               THEN
                  raise_application_error(-20036,'Actual Quantity Is Above The Maximum Quantity.');
              END IF;
              /*
              ||Set Actual Labour
              */
              lr_upd_boq.boq_act_labour := lr_upd_boq.boq_act_quantity * NVL(lr_sta.sta_labour_units,0);
              /*
              ||Set Actual Rate.
              */
              IF lr_upd_boq.boq_sta_item_code != pi_boq_tab(i).boq_sta_item_code
               OR lr_upd_boq.boq_act_rate IS NULL
               THEN
                  lr_upd_boq.boq_sta_item_code := pi_boq_tab(i).boq_sta_item_code;
                  lr_upd_boq.boq_act_rate := maiwo.reprice_item(p_item_code => lr_upd_boq.boq_sta_item_code
                                                               ,p_con_id    => lr_wo.wor_con_id
                                                               ,p_rse_he_id => lr_wol.wol_rse_he_id
                                                               ,p_priority  => lr_defect.def_priority);
                  IF lr_upd_boq.boq_act_rate IS NULL
                   THEN
                      raise_application_error(-20101,'Item Code ['||lr_new_boq.boq_sta_item_code||'] Is Not A Valid Contract Item.');
                  END IF;
                  --
              END IF;
              /*
              ||Set Actual Cost.
              */
              lr_upd_boq.boq_act_cost := ROUND((lr_upd_boq.boq_act_rate * lr_upd_boq.boq_act_quantity),2);
              --
              UPDATE boq_items
                 SET ROW = lr_upd_boq
               WHERE boq_id = pi_boq_tab(i).boq_id
                   ;
              /*
              ||Check To See If A New Percent Item Has Been Specified.
              */
              IF pi_boq_tab(i).add_percent_item = 'Y'
               AND pi_boq_tab(i).percent_item_code IS NOT NULL
               THEN
                  /*
                  ||Check The Parent Is Allowed To Have A Child.
                  */
                  IF lr_sta.sta_allow_percent = 'Y'
                   THEN
                      insert_new_perc_item(pi_parent_id => lr_upd_boq.boq_id
                                          ,pi_item_code => pi_boq_tab(i).percent_item_code);
                  ELSE
                      raise_application_error(-20102,'Percent Items Cannot Be Added To Item Code ['||lr_sta.sta_item_code||'].');
                  END IF;
              END IF;
              --
          ELSE
              lr_new_boq := lr_blank_boq;
              /*
              ||New Boq So Set Some Default Fields.
              */
              lr_new_boq.boq_id             := get_next_id('BOQ_ID_SEQ');
              lr_new_boq.boq_sta_item_code  := pi_boq_tab(i).boq_sta_item_code;
              lr_new_boq.boq_work_flag      := lr_wol.wol_flag;
              lr_new_boq.boq_defect_id      := NVL(lr_wol.wol_def_defect_id,0);
              lr_new_boq.boq_rep_action_cat := NVL(lr_wol.wol_rep_action_cat,'X');
              lr_new_boq.boq_wol_id         := lr_wol.wol_id;
              lr_new_boq.boq_date_created   := SYSDATE;
              lr_new_boq.boq_item_name      := lr_sta.sta_item_name;
              lr_new_boq.boq_est_dim1       := 0;
              lr_new_boq.boq_est_dim2       := NULL;
              lr_new_boq.boq_est_dim3       := NULL;
              lr_new_boq.boq_est_quantity   := 0;
              lr_new_boq.boq_est_cost       := 0;
              lr_new_boq.boq_est_rate       := 0;
              /*
              ||Check/Default Dimentions.
              */
              lr_new_boq.boq_act_dim1 := NVL(pi_boq_tab(i).boq_act_dim1,0);
              --
              IF lr_sta.sta_dim2_text IS NOT NULL
               THEN
                  lr_new_boq.boq_act_dim2 := NVL(pi_boq_tab(i).boq_act_dim2,1);
              END IF;
              --
              IF lr_sta.sta_dim3_text IS NOT NULL
               THEN
                  lr_new_boq.boq_act_dim3 := NVL(pi_boq_tab(i).boq_act_dim3,1);
              END IF;
              /*
              ||Set Actual Quantity.
              */
              lr_new_boq.boq_act_quantity := lr_new_boq.boq_act_dim1
                                             * NVL(lr_new_boq.boq_act_dim2,1)
                                             * NVL(lr_new_boq.boq_act_dim3,1);
              /*
              ||Check Quantity.
              */
              IF lr_new_boq.boq_act_quantity < lr_sta.sta_min_quantity
               AND lr_new_boq.boq_act_quantity != 0
               THEN
                  raise_application_error(-20035,'Actual Quantity Is Below The Minimum Quantity.');
              END IF;
              --
              IF lr_new_boq.boq_act_quantity > lr_sta.sta_max_quantity
               AND lr_new_boq.boq_act_quantity != 0
               THEN
                  raise_application_error(-20036,'Actual Quantity Is Above The Maximum Quantity.');
              END IF;
              /*
              ||Set Actual Labour
              */
              lr_new_boq.boq_act_labour := lr_new_boq.boq_act_quantity * NVL(lr_sta.sta_labour_units,0);
              /*
              ||Set Actual Rate.
              */
              lr_new_boq.boq_act_rate := maiwo.reprice_item(p_item_code => lr_new_boq.boq_sta_item_code
                                                           ,p_con_id    => lr_wo.wor_con_id
                                                           ,p_rse_he_id => lr_wol.wol_rse_he_id
                                                           ,p_priority  => lr_defect.def_priority);
              IF lr_new_boq.boq_act_rate IS NULL
               THEN
                  raise_application_error(-20101,'Item Code ['||lr_new_boq.boq_sta_item_code||'] Is Not A Valid Contract Item.');
              END IF;
              /*
              ||Set Actual Cost.
              */
              lr_new_boq.boq_act_cost := ROUND((lr_new_boq.boq_act_rate * lr_new_boq.boq_act_quantity),2);
              --
              INSERT
                INTO boq_items
              VALUES lr_new_boq
                   ;
              /*
              ||Check To See If A New Percent Item Has Been Specified.
              */
              IF pi_boq_tab(i).add_percent_item = 'Y'
               AND pi_boq_tab(i).percent_item_code IS NOT NULL
               THEN
                  /*
                  ||Check The Parent Is Allowd To Have A Child.
                  */
                  IF lr_sta.sta_allow_percent = 'Y'
                   THEN
                      insert_new_perc_item(pi_parent_id => lr_new_boq.boq_id
                                          ,pi_item_code => pi_boq_tab(i).percent_item_code);
                  ELSE
                      raise_application_error(-20102,'Percent Items Cannot Be Added To Item Code ['||lr_sta.sta_item_code||'].');
                  END IF;
              END IF;
          END IF;
          --
        END LOOP;
    END IF;
    /*
    ||Set Actuals For Any BOQs That Haven't Been Updated.
    */
    IF lv_actual_costs
     OR lv_complete_status
     THEN
        UPDATE boq_items
           SET boq_act_dim1     = NVL(boq_act_dim1, boq_est_dim1)
              ,boq_act_dim2     = NVL(boq_act_dim2, boq_est_dim2)
              ,boq_act_dim3     = NVL(boq_act_dim3, boq_est_dim3)
              ,boq_act_rate     = NVL(boq_act_rate, boq_est_rate)
              ,boq_act_quantity = NVL(boq_act_quantity, boq_est_quantity)
              ,boq_act_cost     = NVL(boq_act_cost, boq_est_cost)
              ,boq_act_labour   = NVL(boq_act_labour, boq_est_labour)
              ,boq_act_discount = NVL(boq_act_discount, boq_est_discount)
         WHERE boq_wol_id = lr_wol.wol_id
             ;
    ELSIF lv_not_done_status
     THEN
        UPDATE boq_items
           SET boq_act_dim1     = NULL
              ,boq_act_dim2     = NULL
              ,boq_act_dim3     = NULL
              ,boq_act_rate     = NULL
              ,boq_act_quantity = NULL
              ,boq_act_cost     = NULL
              ,boq_act_labour   = NULL
              ,boq_act_discount = NULL
         WHERE boq_wol_id = lr_wol.wol_id
             ;
    END IF;
    /*
    ||Recalc Perc Items.
    */
    recalc_percent_items;
    /*
    ||Update Contract Item Usage.
    */
    IF lv_complete_status
     THEN
        maiwo.adjust_contract_figures(p_wol_id    => lr_wol.wol_id
                                     ,p_con_id    => lr_wo.wor_con_id
                                     ,p_operation => '+');
    ELSIF lv_not_done_status
     THEN
        maiwo.adjust_contract_figures(p_wol_id    => lr_wol.wol_id
                                     ,p_con_id    => lr_wo.wor_con_id
                                     ,p_operation => '-');
    END IF;
    --
  END process_boqs;
  --
  PROCEDURE update_wol
    IS
    --
    lv_wol_est_cost    work_order_lines.wol_est_cost%TYPE;
    lv_wol_est_labour  work_order_lines.wol_est_labour%TYPE;
    lv_wol_act_cost    work_order_lines.wol_act_cost%TYPE;
    lv_wol_act_labour  work_order_lines.wol_act_labour%TYPE;
    lv_invoice_status  work_order_lines.wol_invoice_status%TYPE;
    lv_date_complete   work_order_lines.wol_date_complete%TYPE;
    --
    PROCEDURE update_defect
      IS
      CURSOR c1(cp_defect_id       defects.def_defect_id%TYPE
               ,cp_rep_action_cat  repairs.rep_action_cat%TYPE)
          IS
      SELECT 1
        FROM repairs
       WHERE rep_def_defect_id = cp_defect_id
         AND rep_date_completed IS NULL
         AND rep_action_cat != cp_rep_action_cat;
      --
      lv_defect_complete  BOOLEAN;
      lv_dummy            NUMBER;
      --
    BEGIN
      /*
      ||Set The Completion Date On The Repair And The
      ||Defect (If There Are No Outstanding Repairs).
      */
      maiwo.update_defect_date(p_def_id         => lr_wol.wol_def_defect_id
                              ,p_date_compl     => lv_date_complete
                              ,p_works_order_no => lr_wol.wol_works_order_no
                              ,p_wol_id         => lr_wol.wol_id
                              ,p_hour_compl     => TO_NUMBER(TO_CHAR(lv_date_complete,'HH24'))
                              ,p_mins_compl     => TO_NUMBER(TO_CHAR(lv_date_complete,'MI')));
      /*
      ||Check Whether There Are Other Repairs For
      ||This Defect That Are Not Yet Complete.
      ||If All Are Complete Set The Status Of
      ||The Defect To Complete.
      */
      OPEN  c1(lr_wol.wol_def_defect_id
              ,lr_wol.wol_rep_action_cat);
      FETCH c1
       INTO lv_dummy;
      /*
      ||If No Other Repairs Found
      ||The Defect Is Complete.
      */
      lv_defect_complete := c1%NOTFOUND;
      CLOSE c1;
      --
      IF (lv_date_complete IS NOT NULL
          AND lv_defect_complete)
       OR lv_not_done_status
       THEN
          --
          UPDATE defects
             SET def_status_code = lv_def_status_code
                ,def_last_updated_date = SYSDATE
           WHERE def_defect_id = lr_wol.wol_def_defect_id
               ;
          --
      END IF;
      --
    END update_defect;
    --
  BEGIN
    --
    IF lv_complete_status
     THEN
        lv_date_complete := NVL(pi_date_complete,nvl(lr_wol.wol_date_repaired,sysdate));
    END IF;
    --
    SELECT SUM(NVL(boq_est_cost,0))   est_cost
          ,SUM(NVL(boq_est_labour,0)) est_labour
          ,SUM(boq_act_cost)   act_cost
          ,SUM(boq_est_labour) est_labour
      INTO lv_wol_est_cost
          ,lv_wol_est_labour
          ,lv_wol_act_cost
          ,lv_wol_act_labour
      FROM boq_items
     WHERE boq_wol_id = lr_wol.wol_id
         ;
    /*
    ||Update The Work Order Line.
    */
    UPDATE work_order_lines
       SET wol_status_code   = pi_new_status
          ,wol_est_cost      = lv_wol_est_cost
          ,wol_est_labour    = lv_wol_est_labour
          ,wol_act_cost      = lv_wol_act_cost
          ,wol_act_labour    = lv_wol_est_labour
          ,wol_date_complete = lv_date_complete
     WHERE wol_id = lr_wol.wol_id
         ;
    /*
    ||wo claims trigger will fire after this update creating a claim_payment
    ||record. Now then entry has been made we can set the invoice status
    */
    lv_invoice_status := maiwo.wol_invoice_status(p_wol_id => lr_wol.wol_id);
    --
    UPDATE work_order_lines
       SET wol_invoice_status = lv_invoice_status
     WHERE wol_id = lr_wol.wol_id;
    /*
    ||Update The Budget.
    */
    IF lv_not_done_status
     OR (lv_wol_act_cost IS NULL and lr_wol.wol_act_cost IS NOT NULL)
     THEN
        /*
        ||Work Has Not Been Done So Needs
        ||To Be Removed From The Budget.
        */
        IF NOT mai_budgets.budget_reversal(p_wol_id  => lr_wol.wol_id
                                          ,p_bud_id  => lr_wol.wol_bud_id
                                          ,p_wol_act => apply_balancing_sum(pi_con_id => lr_wo.wor_con_id
                                                                           ,pi_value  => (NVL(lv_wol_act_cost,0) - NVL(lr_wol.wol_act_cost,0)))
                                          ,p_wol_est => 0)
         THEN
            raise_application_error(-20047,'Budget Exceeded.');
        END IF;
    ELSE
        IF within_budget(pi_bud_id => lr_wol.wol_bud_id
                        ,pi_con_id => lr_wo.wor_con_id
                        ,pi_est    => lv_wol_est_cost - NVL(lr_wol.wol_est_cost,0)
                        ,pi_act    => lv_wol_act_cost - NVL(lr_wol.wol_act_cost,0)
                        ,pi_wol_id => lr_wol.wol_id)
         THEN
            add_to_budget(pi_wol_id => lr_wol.wol_id
                         ,pi_bud_id => lr_wol.wol_bud_id
                         ,pi_con_id => lr_wo.wor_con_id
                         ,pi_est    => lv_wol_est_cost - NVL(lr_wol.wol_est_cost,0)
                         ,pi_act    => lv_wol_act_cost - NVL(lr_wol.wol_act_cost,0));
        ELSE
            raise_application_error(-20047,'Budget Exceeded.');
        END IF;
    END IF;
    /*
    ||Create Interim Payment Records If Required.
    */
    IF lv_interim_status
     THEN
        IF NOT maiwo.create_interim_payment(p_wol_id   => lr_wol.wol_id
                                           ,p_act_cost => lv_wol_act_cost)
         THEN
            raise_application_error(-20107,'Cannot Enter A Valuation Less Than Previously Paid.');
        END IF;
    ELSIF lv_not_done_status
     THEN
        /*
        ||Work Not Done So Remove Any Unpaid Iterim Payments.
        */
        maiwo.clear_interim_payment(p_wol_id => lr_wol.wol_id);
    END IF;
    /*
    ||Where Appropriate Complete Any Defect/Repair Associated With The Line.
    */
    IF lr_wol.wol_def_defect_id IS NOT NULL
     THEN
        update_defect;
    END IF;
    --
  EXCEPTION
    WHEN value_error
     THEN
        raise_application_error(-20104,'Value Too Large When Calculating Work Order Line Totals.');
    WHEN others
     THEN
        RAISE;
  END update_wol;
  --
  PROCEDURE update_wor
    IS
    --
    PROCEDURE set_date_wor_closed
      IS
    BEGIN
      --
      SELECT MAX(wol_date_complete)
        INTO lv_wor_date_closed
        FROM work_order_lines
       WHERE wol_works_order_no = lr_wo.wor_works_order_no
           ;
      --
    END set_date_wor_closed;
    --
  BEGIN
    --
    SELECT SUM(wol_est_cost)   est_cost
          ,SUM(wol_est_labour) est_labour
          ,SUM(wol_act_cost)   act_cost
          ,SUM(wol_act_labour) act_labour
      INTO lv_wor_est_cost
          ,lv_wor_est_labour
          ,lv_wor_act_cost
          ,lv_wor_act_labour
      FROM work_order_lines
     WHERE wol_works_order_no = lr_wo.wor_works_order_no
         ;
    /*
    ||Get The Balancing Sums.
    */
    lv_wor_est_balancing_sum := get_balancing_sum(lr_wo.wor_con_id,lv_wor_est_cost);
    lv_wor_act_balancing_sum := get_balancing_sum(lr_wo.wor_con_id,lv_wor_act_cost);
    /*
    ||If This Is The Last Line On The Work Order
    ||To Be Completed Then Close The Work Order.
    */
    IF (pi_date_complete IS NOT NULL
        OR lv_not_done_status)
     AND maiwo.works_order_complete(p_works_order_no => lr_wo.wor_works_order_no) = 'TRUE'
     THEN
        set_date_wor_closed;
    END IF;
    /*
    ||Update The Work Order.
    */
    UPDATE work_orders
       SET wor_est_cost          = lv_wor_est_cost
          ,wor_est_balancing_sum = lv_wor_est_balancing_sum
          ,wor_est_labour        = lv_wor_est_labour
          ,wor_act_cost          = lv_wor_act_cost
          ,wor_act_balancing_sum = lv_wor_act_balancing_sum
          ,wor_act_labour        = lv_wor_act_labour
          ,wor_date_closed       = lv_wor_date_closed
          ,wor_closed_by_id      = DECODE(lv_wor_date_closed,NULL,NULL,pi_user_id)
     WHERE wor_works_order_no = lr_wo.wor_works_order_no
         ;
    --
  EXCEPTION
    WHEN value_error
     THEN
        raise_application_error(-20104,'Value Too Large When Calculating Work Order Totals.');
    WHEN others
     THEN
        RAISE;
  END update_wor;
  --
  PROCEDURE update_interfaces
    IS
    --
    lr_ne nm_elements_all%ROWTYPE;
    --
    lv_originator hig_users.hus_name%TYPE;
    lv_con_code   contracts.con_code%TYPE;
    --
    PROCEDURE get_con_code
      IS
    BEGIN
      SELECT con_code
        INTO lv_con_code
        FROM contracts
       WHERE con_id = lr_wo.wor_con_id
           ;
    END get_con_code;
    --
  BEGIN
    --
    IF interfaces_used(pi_con_id => lr_wo.wor_con_id)
     THEN
        --
        lv_originator := nm3get.get_hus(pi_hus_user_id => lr_wo.wor_peo_person_id).hus_name;
        --
        get_con_code;
        --
        interfaces.add_wor_to_list(p_trans_type   => 'A'
                                  ,p_wor_no       => lr_wo.wor_works_order_no                 
                                  ,p_wor_flag     => lr_wo.wor_flag                           
                                  ,p_scheme_type  => lr_wo.wor_scheme_type                    
                                  ,p_con_code     => lv_con_code                           
                                  ,p_originator   => lv_originator                           
                                  ,p_confirmed    => lr_wo.wor_date_confirmed                 
                                  ,p_est_complete => lr_wo.wor_est_complete                   
                                  ,p_cost         => NVL(lv_wor_act_cost,lv_wor_est_cost)
                                  ,p_labour       => lr_wo.wor_est_labour                     
                                  ,p_ip_flag      => lr_wo.wor_interim_payment_flag           
                                  ,p_ra_flag      => lr_wo.wor_risk_assessment_flag           
                                  ,p_ms_flag      => lr_wo.wor_method_statement_flag          
                                  ,p_wp_flag      => lr_wo.wor_works_programme_flag           
                                  ,p_as_flag      => lr_wo.wor_additional_safety_flag         
                                  ,p_commence_by  => lr_wo.wor_commence_by                    
                                  ,p_descr        => lr_wo.wor_descr);
        --
        lr_ne := nm3get.get_ne(pi_ne_id => lr_wol.wol_rse_he_id);
        --
        interfaces.add_wol_to_list(lr_wol.wol_id
                                  ,lr_wol.wol_works_order_no
                                  ,lr_wol.wol_def_defect_id
                                  ,lr_wol.wol_schd_id
                                  ,lr_wol.wol_icb_work_code
                                  ,lr_ne.ne_unique
                                  ,lr_ne.ne_descr);
        --
        interfaces.copy_data_to_interface;
        --
    END IF;
    --
  END update_interfaces;
  --
BEGIN
  /*
  ||Get Details Of The Work Order and Work Order Line
  ||And Lock The Records For Update.
  */
  lr_wol := get_and_lock_wol(pi_wol_id => pi_wol_id);
  lr_wo := get_and_lock_wo(pi_works_order_no => lr_wol.wol_works_order_no);
  IF lr_wol.wol_def_defect_id IS NOT NULL
   THEN
      lr_defect := get_defect(pi_defect_id => lr_wol.wol_def_defect_id);
  END IF;
  /*
  ||For The Moment This Procedure Doesn't
  ||Support Cyclic Maintenance Work Orders.
  */
  IF lr_wo.wor_flag = 'M'
   THEN
      raise_application_error(-20073,'This API Does Not Support Cyclic Work Orders. Please Use The Forms Application To Work With Cyclic Work Orders.');
  END IF;
  /*
  ||If pi_date_complete Is Populated Check It.
  */
  validate_date_complete;
  /*
  ||Validate The Status Transition.
  */
  validate_wol_status_change;
  IF NOT lv_valid_transition
   THEN
      raise_application_error(-20097,'Invalid Status Transition : '||lv_reason);
  END IF;
  /*
  ||Process Any BOQs Supplied.
  */
  process_boqs;
  /*
  ||Update The Work Order Line.
  */
  update_wol;
  /*
  ||Update The Work Order.
  */
  update_wor;
  /*
  ||Update Interfaces If Required.
  */
  update_interfaces;
  /*
  ||Commit If Required.
  */
  IF NVL(pi_commit,'Y') = 'Y'
   THEN
      nm_debug.debug('Commit.');
      COMMIT;
  END IF;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END update_wol_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_wol_held(pi_user_id       IN hig_users.hus_user_id%TYPE
                      ,pi_wol_id        IN work_order_lines.wol_id%TYPE
                      ,pi_date_complete IN work_order_lines.wol_date_complete%TYPE
                      ,pi_commit        IN VARCHAR2)
  IS
  --
  lv_held_status  hig_status_codes.hsc_status_code%TYPE;
  --
  lt_boqs act_boq_tab;
  --
  PROCEDURE get_held_status
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_held_status
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature2 = 'Y'
       AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                              AND NVL(hsc_end_date  ,TRUNC(SYSDATE))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20094,'Too Many Values Defined For Work Order Line HELD Status.');
    WHEN no_data_found
     THEN
        raise_application_error(-20095,'Cannot Obtain Value For Work Order Line HELD Status.');
    WHEN others
     THEN
        RAISE;
  END get_held_status;
  --
BEGIN
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Update The WOL Status To HELD.
  */
  get_held_status;
  --
  update_wol_status(pi_user_id       => pi_user_id
                   ,pi_wol_id        => pi_wol_id
                   ,pi_new_status    => lv_held_status
                   ,pi_date_complete => pi_date_complete
                   ,pi_boq_tab       => lt_boqs
                   ,pi_commit        => pi_commit);
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE;
END set_wol_held;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_wol_not_done(pi_user_id       IN hig_users.hus_user_id%TYPE
                          ,pi_wol_id        IN work_order_lines.wol_id%TYPE
                          ,pi_commit        IN VARCHAR2)
  IS
  --
  lv_not_done_status  hig_status_codes.hsc_status_code%TYPE;
  --
  lt_boqs act_boq_tab;
  --
  PROCEDURE get_not_done_status
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_not_done_status
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature5 = 'Y'
       AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                              AND NVL(hsc_end_date  ,TRUNC(SYSDATE))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20094,'Too Many Values Defined For Work Order Line NOT_DONE Status.');
    WHEN no_data_found
     THEN
        raise_application_error(-20095,'Cannot Obtain Value For Work Order Line NOT_DONE Status.');
    WHEN others
     THEN
        RAISE;
  END get_not_done_status;
  --
BEGIN
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Update The WOL Status To NOT_DONE.
  */
  get_not_done_status;
  --
  update_wol_status(pi_user_id       => pi_user_id
                   ,pi_wol_id        => pi_wol_id
                   ,pi_new_status    => lv_not_done_status
                   ,pi_date_complete => NULL
                   ,pi_boq_tab       => lt_boqs
                   ,pi_commit        => pi_commit);
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE;
END set_wol_not_done;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_interim_payment(pi_user_id       IN hig_users.hus_user_id%TYPE
                                ,pi_wol_id  IN work_order_lines.wol_id%TYPE
                                ,pi_boq_tab IN act_boq_tab
                                ,pi_commit  IN VARCHAR2)
  IS
  --
  lv_interim_status  hig_status_codes.hsc_status_code%TYPE;
  --
  PROCEDURE get_interim_status
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_interim_status
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature9 = 'Y'
       AND hsc_allow_feature4 != 'Y'
       AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                              AND NVL(hsc_end_date  ,TRUNC(SYSDATE))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20094,'Too Many Values Defined For Work Order Line INTERIM Status.');
    WHEN no_data_found
     THEN
        raise_application_error(-20095,'Cannot Obtain Value For Work Order Line INTERIM Status.');
    WHEN others
     THEN
        RAISE;
  END get_interim_status;
  --
BEGIN
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Update The WOL Status To INTERIM.
  */
  get_interim_status;
  --
  update_wol_status(pi_user_id       => pi_user_id
                   ,pi_wol_id        => pi_wol_id
                   ,pi_new_status    => lv_interim_status
                   ,pi_date_complete => NULL
                   ,pi_boq_tab       => pi_boq_tab
                   ,pi_commit        => pi_commit);
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE;
END create_interim_payment;
--
-----------------------------------------------------------------------------
--
PROCEDURE complete_wol(pi_user_id       IN hig_users.hus_user_id%TYPE
                      ,pi_wol_id        IN work_order_lines.wol_id%TYPE
                      ,pi_date_complete IN work_order_lines.wol_date_complete%TYPE
                      ,pi_boq_tab       IN act_boq_tab
                      ,pi_commit        IN VARCHAR2)
  IS
  --
  lv_complete_status  hig_status_codes.hsc_status_code%TYPE;
  --
  PROCEDURE get_complete_status
    IS
  BEGIN
    SELECT hsc_status_code
      INTO lv_complete_status
      FROM hig_status_codes
     WHERE hsc_domain_code = 'WORK_ORDER_LINES'
       AND hsc_allow_feature3 = 'Y'
       AND TRUNC(SYSDATE) BETWEEN NVL(hsc_start_date,TRUNC(SYSDATE))
                              AND NVL(hsc_end_date  ,TRUNC(SYSDATE))
         ;
  EXCEPTION
    WHEN too_many_rows
     THEN
        raise_application_error(-20094,'Too Many Values Defined For Work Order Line COMPLETE Status.');
    WHEN no_data_found
     THEN
        raise_application_error(-20095,'Cannot Obtain Value For Work Order Line COMPLETE Status.');
    WHEN others
     THEN
        RAISE;
  END get_complete_status;
  --
BEGIN
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Update The WOL Status To INTERIM.
  */
  get_complete_status;
  --
  update_wol_status(pi_user_id       => pi_user_id
                   ,pi_wol_id        => pi_wol_id
                   ,pi_new_status    => lv_complete_status
                   ,pi_date_complete => NVL(pi_date_complete,SYSDATE)
                   ,pi_boq_tab       => pi_boq_tab
                   ,pi_commit        => pi_commit);
  --
EXCEPTION
  WHEN OTHERS
   THEN
      RAISE;
END complete_wol;
--
-----------------------------------------------------------------------------
--
PROCEDURE complete_wor(pi_user_id       IN hig_users.hus_user_id%TYPE
                      ,pi_works_order_no IN work_orders.wor_works_order_no%TYPE
                      ,pi_date_complete  IN work_order_lines.wol_date_complete%TYPE
                      ,pi_commit         IN VARCHAR2)
  IS
  --
  TYPE wol_id_tab IS TABLE OF work_order_lines.wol_id%TYPE;
  lt_wols wol_id_tab;
  --
  lt_boqs act_boq_tab;
  --
  PROCEDURE get_wols
    IS
  BEGIN
    SELECT wol_id
      BULK COLLECT
      INTO lt_wols
      FROM work_order_lines w
     WHERE w.wol_works_order_no = pi_works_order_no
       AND NOT EXISTS(SELECT 'x'
                        FROM hig_status_codes h
                       WHERE h.hsc_domain_code = 'WORK_ORDER_LINES'
                         AND (h.hsc_allow_feature2 = 'Y'
                              OR h.hsc_allow_feature3 = 'Y'
                              OR (h.hsc_allow_feature4 = 'Y' AND h.hsc_allow_feature9 = 'N')
                              OR h.hsc_allow_feature5 = 'Y')
                         AND h.hsc_status_code = w.wol_status_code
                         AND SYSDATE BETWEEN NVL(h.hsc_start_date, SYSDATE)
                                         AND NVL(h.hsc_end_date, SYSDATE))
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20110,'Work Order Is Already Complete.');
    WHEN others
     THEN
        RAISE;
  END get_wols;
  --
BEGIN
  /*
  ||Validate The User ID.
  */
  IF NOT validate_user_id(pi_user_id        => pi_user_id
                         ,pi_effective_date => TRUNC(SYSDATE))
   THEN
      raise_application_error(-20067,'Invalid User Id Supplied ['||TO_CHAR(pi_user_id)||'].');
  END IF;
  /*
  ||Make Sure Work Order Is
  ||Not Already Complete.
  */
  IF maiwo.works_order_complete(p_works_order_no => pi_works_order_no) = 'TRUE'
   THEN
      raise_application_error(-20110,'Work Order Is Already Complete.');
  END IF;
  /*
  ||Get WOLs To Complete.
  */
  get_wols;
  /*
  ||Complete The WOLs.
  ||Completion Of The Last WOL Will Complete The Work Order.
  */
  FOR i IN 1..lt_wols.count LOOP
    --
    complete_wol(pi_user_id       => pi_user_id
                ,pi_wol_id        => lt_wols(i)
                ,pi_date_complete => pi_date_complete
                ,pi_boq_tab       => lt_boqs
                ,pi_commit        => 'N');
    --
  END LOOP;
  /*
  ||Now That All WOLs Have
  ||Been Completed Without
  ||Error Commit If Required
  */
  IF NVL(pi_commit,'Y') = 'Y'
   THEN
      COMMIT;
  END IF;
  --
EXCEPTION
  WHEN OTHERS
   THEN
      ROLLBACK;
      RAISE;
END complete_wor;
--
-----------------------------------------------------------------------------
--
END mai_api;
/
