CREATE OR REPLACE FORCE VIEW v_mai3806_def(are_date_work_done
                                          ,are_batch_id
                                          ,are_initiation_type
                                          ,hus_initials
                                          ,are_maint_insp_flag
                                          ,rse_admin_unit
                                          ,are_st_chain
                                          ,are_end_chain
                                          ,def_defect_id
                                          ,def_rse_he_id
                                          ,def_iit_item_id
                                          ,def_st_chain
                                          ,def_are_report_id
                                          ,def_atv_acty_area_code
                                          ,def_siss_id
                                          ,def_works_order_no
                                          ,def_created_date
                                          ,def_defect_code
                                          ,def_last_updated_date
                                          ,def_orig_priority
                                          ,def_priority
                                          ,def_status_code
                                          ,def_superseded_flag
                                          ,def_area
                                          ,def_are_id_not_found
                                          ,def_coord_flag
                                          ,def_date_compl
                                          ,def_date_not_found
                                          ,def_defect_class
                                          ,def_defect_descr
                                          ,def_defect_type_descr
                                          ,def_diagram_no
                                          ,def_height
                                          ,def_ident_code
                                          ,def_ity_inv_code
                                          ,def_ity_sys_flag
                                          ,def_length
                                          ,def_locn_descr
                                          ,def_maint_wo
                                          ,def_mand_adv
                                          ,def_notify_org_id
                                          ,def_number
                                          ,def_per_cent
                                          ,def_per_cent_orig
                                          ,def_per_cent_rem
                                          ,def_rechar_org_id
                                          ,def_serial_no
                                          ,def_skid_coeff
                                          ,def_special_instr
                                          ,def_superseded_id
                                          ,def_time_hrs
                                          ,def_time_mins
                                          ,def_update_inv
                                          ,def_x_sect
                                          ,def_easting
                                          ,def_northing
                                          ,def_response_category
                                          ,def_rowid
                                          ,rep_def_defect_id
                                          ,rep_date_due
                                          ,rep_date_completed
                                          ,rep_descr
                                          ,rep_tre_treat_code
                                          ,rep_action_cat
) AS
SELECT  /*+ FIRST_ROWS_N */
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/tfl/aims/tfl_v_mai3806_def.sql-arc   3.0   May 18 2010 14:15:22   malexander  $
--       Module Name      : $Workfile:   tfl_v_mai3806_def.sql  $
--       Date into PVCS   : $Date:   May 18 2010 14:15:22  $
--       Date fetched Out : $Modtime:   May 18 2010 14:15:10  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
       are_date_work_done
      ,are_batch_id
      ,are_initiation_type
      ,(select hus_initials
        from   hig_users
        where  are_peo_person_id_actioned = hus_user_id) hus_initials 
      ,are_maint_insp_flag
      ,ne_admin_unit
      ,are_st_chain
      ,are_end_chain
      ,def.def_defect_id
      ,def.def_rse_he_id
      ,def.def_iit_item_id
      ,def.def_st_chain
      ,def.def_are_report_id
      ,def.def_atv_acty_area_code
      ,def.def_siss_id
      ,def.def_works_order_no
      ,def.def_created_date
      ,def.def_defect_code
      ,def.def_last_updated_date
      ,def.def_orig_priority
      ,def.def_priority
      ,def.def_status_code
      ,def.def_superseded_flag
      ,def.def_area
      ,def.def_are_id_not_found
      ,def.def_coord_flag
      ,def.def_date_compl
      ,def.def_date_not_found
      ,def.def_defect_class
      ,def.def_defect_descr
      ,def.def_defect_type_descr
      ,def.def_diagram_no
      ,def.def_height
      ,def.def_ident_code
      ,def.def_ity_inv_code
      ,def.def_ity_sys_flag
      ,def.def_length
      ,def.def_locn_descr
      ,def.def_maint_wo
      ,def.def_mand_adv
      ,def.def_notify_org_id
      ,def.def_number
      ,def.def_per_cent
      ,def.def_per_cent_orig
      ,def.def_per_cent_rem
      ,def.def_rechar_org_id
      ,def.def_serial_no
      ,def.def_skid_coeff
      ,def.def_special_instr
      ,def.def_superseded_id
      ,def.def_time_hrs
      ,def.def_time_mins
      ,def.def_update_inv
      ,def.def_x_sect
      ,def.def_easting
      ,def.def_northing
      ,def.def_response_category
      ,def.ROWID def_rowid
      ,rep_def_defect_id
      ,rep_date_due
      ,rep_date_completed
      ,rep_descr
      ,rep_tre_treat_code
      ,rep_action_cat
  FROM nm_elements
      ,repairs
      ,defects def
      ,activities_report
      ,hig_users hus2
 WHERE are_report_id = def_are_report_id
   AND def_defect_id = rep_def_defect_id
   AND def_rse_he_id = ne_id
   and hus2.hus_username = user 
   and ne_admin_unit = decode(hus2.hus_admin_unit,1,ne_admin_unit,hus2.hus_admin_unit) 
/