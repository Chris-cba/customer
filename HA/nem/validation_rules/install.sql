--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/customer/HA/nem/validation_rules/install.sql-arc   1.1   27 Sep 2016 14:33:56   Mike.Huitson  $
--       Module Name      : $Workfile:   install.sql  $
--       Date into PVCS   : $Date:   27 Sep 2016 14:33:56  $
--       Date fetched Out : $Modtime:   27 Sep 2016 14:33:16  $
--       PVCS Version     : $Revision:   1.1  $

INSERT
  INTO nem_validation_rules
      (nvr_id
      ,nvr_descr
      ,nvr_execution_order
      ,nvr_execution_level
      ,nvr_execute
      ,nvr_report_failure_as
      ,nvr_proc_name)
SELECT nvr_id_seq.NEXTVAL
      ,'Check for Impact Groups where all available lanes are closed and the Carriageway Closure flag is set to "No".'
      ,320
      ,'EVENT'
      ,'Y'
      ,'WARNING'
      ,'nem_custom_validation_rules.all_available_lanes_closed'
  FROM dual
 WHERE NOT EXISTS(SELECT 1
                    FROM nem_validation_rules
                   WHERE nvr_proc_name = 'nem_custom_validation_rules.all_available_lanes_closed')
/

COMMIT
/
