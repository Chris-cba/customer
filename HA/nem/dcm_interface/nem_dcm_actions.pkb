CREATE OR REPLACE PACKAGE BODY nem_dcm_actions
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/dcm_interface/nem_dcm_actions.pkb-arc   1.1   Sep 22 2016 13:18:04   Peter.Bibby  $
  --       Module Name      : $Workfile:   nem_dcm_actions.pkb  $
  --       Date into PVCS   : $Date:   Sep 22 2016 13:18:04  $
  --       Date fetched Out : $Modtime:   Aug 17 2016 13:30:18  $
  --       Version          : $Revision:   1.1  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.1  $';
  g_package_name   CONSTANT VARCHAR2 (30) := 'nem_create_dcminput_file';

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION can_execute_action(pi_ids IN nm3type.tab_number)
    RETURN BOOLEAN IS
    --
    lv_retval                  BOOLEAN := TRUE;
    lv_user_has_normal_access  BOOLEAN := FALSE;
    --
    lr_na     nem_actions%ROWTYPE;
    lr_event  nem_api.event_rec;
    --
    lt_admin_unit_tab  nem_util.admin_unit_tab;
    --
  BEGIN
    --
    lr_na := nem_actions_api.get_na(pi_label   => 'Manual DCM'
                                   ,pi_context => 'NEM_EVENTS');
    --
    lv_retval := nem_actions_api.check_event_id_count(pi_na_id => lr_na.na_id
                                                     ,pi_ids   => pi_ids);
    --
    IF lv_retval
     AND pi_ids.COUNT = 0
     THEN
        lv_retval := FALSE;
    END IF;
    --
    IF lv_retval
     THEN
        FOR i IN 1..pi_ids.COUNT LOOP
          --
          lr_event := nem_api.get_event(pi_nevt_id => pi_ids(i));
          /*
          ||Return false if the event was not found.
          */
          IF lr_event.event_id IS NULL
           THEN
              --
              lv_retval := FALSE;
              EXIT;
              --
          END IF;
          /*
          ||Check the Event Status.
          */
          IF NOT nem_actions_api.check_event_status(pi_na_id  => lr_na.na_id
                                                   ,pi_status => lr_event.event_status)
           THEN
              --
              lv_retval := FALSE;
              EXIT;
              --
          END IF;        
          --
        END LOOP;
    END IF;
    /*
    ||Check the validation state.
    */
    IF lv_retval AND lr_event.validation_state = nem_util.c_requires_validation THEN
      lv_retval := FALSE;
    END IF;    
    
    --
    RETURN lv_retval;
    --
  END can_execute_action;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE execute_script_manual
    IS
    --
    lv_error_flag       nm3type.max_varchar2;
    lv_error_text       nm3type.max_varchar2;
    lv_execution_id     PLS_INTEGER;
    lv_naex_id          nem_action_executions.naex_id%TYPE;
    --
    lt_admin_unit_tab   nem_util.admin_unit_tab;
    --
  BEGIN
    /*
    ||Set a save point.
    */
    SAVEPOINT exec_create_dcminput_file_sp;
    --
    FOR i IN 1.. nem_actions_api.g_object_ids_tab.COUNT LOOP
      /*
      ||Start an execution for logging.
      */
      IF nem_actions_api.g_object_ids_tab(i) IS NOT NULL
       THEN
          --
          lv_execution_id := nem_execution_api.start_execution(pi_parent_execution_id => nem_actions_api.g_parent_execution_id);
          --
          nem_execution_api.add_execution_record(pi_execution_id   => lv_execution_id
                                                ,pi_na_id          => nem_actions_api.g_na_id
                                                ,pi_nevt_id        => nem_actions_api.g_object_ids_tab(i)
                                                ,pi_success        => 'Yes'
                                                ,pi_summary_result => 'Queued for DCM, awaiting submission'
                                                ,po_naex_id        => lv_naex_id
                                                ,po_error_flag     => lv_error_flag
                                                ,po_error_text     => lv_error_text);
      END IF;
      --
      nem_dcm_interface.queue_dcm(pi_nevt_id => nem_actions_api.g_object_ids_tab(i)
                                 ,pi_naex_id => lv_naex_id);                                   
      --
    END LOOP;
    --
    IF lv_error_flag = 'N'
     THEN
        COMMIT;
    ELSE
        nem_actions_api.add_message(1,lv_error_text);
        ROLLBACK TO exec_create_dcminput_file_sp;
    END IF;
    --
  EXCEPTION
    WHEN others
     THEN
        nem_actions_api.add_message(1,SQLERRM);
        ROLLBACK TO exec_create_dcminput_file_sp;
  END execute_script_manual;
  --  
END nem_dcm_actions;
/