CREATE OR REPLACE PACKAGE BODY mai_api AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/hillingdon/mai_webservice/pck/pck/mai_api.pkb-arc   1.1   Aug 05 2008 15:26:50   mhuitson  $
--       Module Name      : $Workfile:   mai_api.pkb  $
--       Date into PVCS   : $Date:   Aug 05 2008 15:26:50  $
--       Date fetched Out : $Modtime:   Aug 05 2008 14:53:34  $
--       PVCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_body_sccsid   CONSTANT  varchar2(2000) := '$Revision:   1.1  $';
  g_package_name  CONSTANT  varchar2(30)   := 'mai_api';
  --
  insert_error  EXCEPTION;
  --
/*
|| Errors Raised.
||
|| -20001,'Invalid Asset Id Supplied.'
|| -20002,'No Asset Type Supplied.'
|| -20003,'Cannot Translate Asset Type.'
|| -20004,'No Section Supplied.'
|| -20005,'Invalid Section Specified.'
|| -20006,'Value Is Less Than Zero.'
|| -20007,'Value Is Greater Than Section Length.'
|| -20008,'No Inspection Date Supplied.'
|| -20009,'Inspection Date May Not Be Later Than Today.'
|| -20010,'Invalid User Id Specified For Inspector..'
|| -20011,'Invalid User Id Specified For Second Inspector.'
|| -20012,'Invalid Initiation Type Specified.'
|| -20013,'Invalid Safety/Detailed Flag Specified.'
|| -20014,'Invalid Weather Condition Specified.'
|| -20015,'Invalid Road Surface Condition Specified.'
|| -20016,'No Activity Supplied.'
|| -20017,'Invalid Asset Activity Code Supplied.'
|| -20018,'Invalid Network Activity Code Supplied.'
|| -20019,'No Sys Flag Supplied.'
|| -20020,'Cannot Find Initial Defect Status.'
|| -20021,'Cannot Find Complete Defect Status.'
|| -20022,'Invalid Defect Status Specified.'
|| -20023,'No Effective Date Supplied.'
|| -20024,'No Defect Type Supplied.'
|| -20025,'Invalid Defect Type Supplied.'
|| -20026,'No Priority Specified.'
|| -20027,'Invalid Priority Specified.'
|| -20028,'Invalid SISS Id Specified.'
|| -20029,'No Repair Action Category Specified.'
|| -20030,'Invalid Repair Action Category Specified.'
|| -20031,'Invalid Treatment Specified.'
|| -20032,'No Standard Item Code Specified.'
|| -20033,'Cannot Find Specfied Standard Item.'
|| -20034,'No BOQ Repair Action Category Specified.'
|| -20035,'Estimated Quantity Is Below The Minimum Quantity.'
|| -20036,'Estimated Quantity Is Above The Maximum Quantity.')
|| -20037,'Cannot Find Specfied Inspection.'
|| -20038,'Defect Section Must Match The Inspection Section.'
|| -20039,'Error occured while Creating Activities Report.'
|| -20040,'Error Occured While Creating Activities Report Line : '
|| -20041,'Error Occured While Creating Repair(s) : '
|| -20042,'Error Occured While Creating BOQs : '
|| -20044,'Cannot Create More Than One Repair Of Each Repair Type'
|| -20045,'Invalid Defect Attribute Value Specified. ['||lv_attr||']'
*/
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
PROCEDURE check_network_security(pi_ne_id IN nm_elements.ne_id%TYPE) IS
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
  --
BEGIN
  --
  lt_boq_tab := pio_boq_tab;
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
        ELSE
            raise_application_error(-20032,'No Standard Item Code Specified.');
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
         THEN
            raise_application_error(-20035,'Estimated Quantity Is Below The Minimum Quantity.');
        END IF;
        --
        IF lt_boq_tab(i).boq_est_quantity > lr_sta.sta_max_quantity
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
            lt_boq_tab(i).boq_rep_action_cat := pi_rep_action_cat;
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
FUNCTION create_defect(pi_insp_rec           IN activities_report%ROWTYPE
                      ,pi_defect_rec         IN defects%ROWTYPE
                      ,pi_def_attr_tab       IN def_attr_tab
                      ,pi_repair_tab         IN rep_tab
                      ,pi_boq_tab            IN boq_tab
                      ,pi_commit             IN VARCHAR2)
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
  --nm_debug.debug_on;
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
      ins_boqs(pi_boq_tab   => lt_boq_tab);
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
  --nm_debug.debug_off;
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
END mai_api;
/
