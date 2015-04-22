-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nem/admin/pck/nem_get_roads.fnc-arc   3.0   Jan 22 2015 10:17:48   Mike.Huitson  $
--       Module Name      : $Workfile:   nem_get_roads.fnc  $
--       Date into PVCS   : $Date:   Jan 22 2015 10:17:48  $
--       Date fetched Out : $Modtime:   Jan 22 2015 10:13:04  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
OPTIONS (DIRECT=TRUE, PARALLEL=TRUE, DATE_CACHE=0)
UNRECOVERABLE LOAD DATA
LENGTH SEMANTICS CHARACTER
DISCARDMAX 100

APPEND
INTO TABLE srw_closures
  WHEN rectype = 'CLOSURE'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER
  ,closure
  ,start_date DATE "DD-MON-YYYY HH24:MI:SS"
  ,end_date   DATE "DD-MON-YYYY HH24:MI:SS"
  ,road
  ,operational_area
  ,notes CHAR(2000)
  ,description CHAR(2000)
  ,login
  ,modified DATE "DD-MON-YYYY HH24:MI:SS"
  ,expected_delay
  ,historic_closure_type
  ,project_manager
  ,project_manager_tel
  ,contractor_name
  ,contractor_tel
  ,activity
  ,reference_number
  ,traffic_management
  ,client
  ,nature_of_works
  ,contract_number
  ,location_textual
  ,record_visible_to_public
  ,summary_or_detail
  ,hardshoulder_only
  ,closed_lanes
  ,added_lanes
  ,times_peak
  ,times_offpeak
  ,times_night
  ,temporary_speed_limit
  ,narrow_lanes
  ,closure_status
  ,closure_parent
  ,published
  ,published_date     DATE "DD-MON-YYYY HH24:MI:SS"
  ,published_end_date DATE "DD-MON-YYYY HH24:MI:SS"
  ,escalation
  ,dcm_status
  ,dcm_delay_time_in_veh_hrs
  ,dcm_delay_cost
  ,dcm_time_per_veh_in_mins
  ,dcm_cost_per_veh
  ,dcm_psa_delay_time_in_veh_hrs
  ,dcm_psa_delay_cost
  ,dcm_psa_time_per_veh_in_mins
  ,dcm_psa_cost_per_veh
  ,dcm_contraflow
  ,dcm_calculation_date DATE "DD-MON-YYYY HH24:MI:SS"
  ,closure_type
  ,eton_reference
  ,eton_filename)
INTO TABLE srw_components
  WHEN rectype = 'COMPONENT'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,component_key
  ,closure
  ,component_length
  ,name)
INTO TABLE srw_sections
  WHEN rectype = 'SECTION'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,component_key      
  ,component_start    
  ,component_end      
  ,label              
  ,section_start_date 
  ,start_offset       
  ,end_offset)
INTO TABLE srw_layouts
  WHEN rectype = 'LAYOUT'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,layout_key
  ,closure   
  ,name)
INTO TABLE srw_lanes
  WHEN rectype = 'LANE'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,layout_key    
  ,component_key 
  ,lane          
  ,from_offset   
  ,to_offset     
  ,lane_status)
INTO TABLE srw_diary
  WHEN rectype = 'DIARY'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype    FILLER POSITION(1)
  ,closure    
  ,start_date DATE "DD-MON-YYYY HH24:MI:SS"
  ,end_date   DATE "DD-MON-YYYY HH24:MI:SS"
  ,layout_key)
INTO TABLE srw_documents
  WHEN rectype = 'DOCUMENT'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,closure      
  ,description  
  ,document     
  ,document_size
  ,submitted_by 
  ,submitted_on DATE "DD-MON-YYYY HH24:MI:SS"
  ,document_name)
INTO TABLE srw_dcm_daily
  WHEN rectype = 'DCM_DAILY'
  FIELDS TERMINATED BY ','
  TRAILING NULLCOLS
  (rectype  FILLER POSITION(1)
  ,closure          
  ,delay_day        
  ,delay_time       
  ,delay_cost       
  ,vehicle_count    
  ,psa_delay_time   
  ,psa_delay_cost   
  ,psa_vehicle_count)