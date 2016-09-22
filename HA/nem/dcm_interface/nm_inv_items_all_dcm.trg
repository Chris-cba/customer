--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/HA/nem/dcm_interface/nm_inv_items_all_dcm.trg-arc   1.1   Sep 22 2016 13:39:08   Peter.Bibby  $
--       Module Name      : $Workfile:   nm_inv_items_all_dcm.trg  $
--       Date into PVCS   : $Date:   Sep 22 2016 13:39:08  $
--       Date fetched Out : $Modtime:   Sep 22 2016 13:38:00  $
--       PVCS Version     : $Revision:   1.1  $
--       Based on SCCS version :  

/*
||Triggers for Published/Completed Event
*/

CREATE OR REPLACE TRIGGER HIGHWAYS.nm_inv_items_all_dcm
AFTER UPDATE
OF    iit_chr_attrib28
ON HIGHWAYS.nm_inv_items_all
FOR    each row
DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;    
    lv_execution_id  PLS_INTEGER;
    lv_success       nem_action_executions.naex_success%TYPE;
    lv_result        nem_action_executions.naex_summary_result%TYPE;
    lv_error_flag    VARCHAR2(1) := 'N';
    lv_error_text    nm3type.max_varchar2;   
    lv_naex_id       nem_action_executions.naex_id%TYPE;
    --
    lt_ids       nem_actions_api.object_ids_tab;  
    --
BEGIN
  IF :new.iit_inv_type = 'NEVT' THEN
    IF :new.iit_chr_attrib28 != :old.iit_chr_attrib28 
     AND :new.iit_chr_attrib28 IN ('PUBLISHED','COMPLETED') THEN  
      --
      lv_execution_id := nem_execution_api.start_execution(pi_parent_execution_id => null);
      --
      IF :new.iit_chr_attrib28 = 'PUBLISHED' THEN
        --
        nem_execution_api.add_execution_record(pi_execution_id   => lv_execution_id
                                              ,pi_execution_date => SYSDATE + 1/86400
                                              ,pi_nevt_id        => :new.iit_ne_id
                                              ,pi_description    => 'Published DCM'                                              
                                              ,pi_success        => 'Yes'
                                              ,pi_summary_result => 'Queued for DCM, awaiting submission'
                                              ,po_naex_id        => lv_naex_id
                                              ,po_error_flag     => lv_error_flag
                                              ,po_error_text     => lv_error_text);
        --

        nem_dcm_interface.queue_dcm(pi_nevt_id => :new.iit_ne_id
                                   ,pi_naex_id => lv_naex_id);            
        --

      --
      END IF;
      --
      IF :new.iit_chr_attrib28 = 'COMPLETED' THEN
        --
        nem_execution_api.add_execution_record(pi_execution_id   => lv_execution_id
                                              ,pi_execution_date => SYSDATE + 1/86400
                                              ,pi_nevt_id        => :new.iit_ne_id
                                              ,pi_description    => 'Completed DCM'                                              
                                              ,pi_success        => 'Yes'
                                              ,pi_summary_result => 'Queued for DCM, awaiting submission'
                                              ,po_naex_id        => lv_naex_id
                                              ,po_error_flag     => lv_error_flag
                                              ,po_error_text     => lv_error_text);
                                              
        --
        nem_dcm_interface.queue_dcm(pi_nevt_id => :new.iit_ne_id
                                   ,pi_naex_id => lv_naex_id);            
        --   
      END IF;    
      
      IF lv_error_flag = 'N' THEN
        commit;
      END IF;
    END IF;
  END IF;
END;
/