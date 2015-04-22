-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/srw_indexes.sql-arc   3.0   Apr 22 2015 13:54:34   Mike.Huitson  $
--       Module Name      : $Workfile:   srw_indexes.sql  $
--       Date into PVCS   : $Date:   Apr 22 2015 13:54:34  $
--       Date fetched Out : $Modtime:   Apr 22 2015 14:56:30  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
/*
||SRW_CLOSURES
*/
ALTER TABLE srw_closures
 ADD (CONSTRAINT srw_closures_pk PRIMARY KEY 
  (closure))
/

/*
||SRW_COMPONENTS
*/
ALTER TABLE srw_components
 ADD (CONSTRAINT srw_components_pk PRIMARY KEY 
  (component_key))
/

CREATE INDEX srw_components_fk_closure_ind ON srw_components
 (closure)
/

ALTER TABLE srw_components ADD (CONSTRAINT
 srw_components_fk_closure FOREIGN KEY 
  (closure) REFERENCES srw_closures
  (closure))
/

/*
||SRW_SECTIONS
*/
CREATE INDEX srw_sections_fk_comp_key_ind ON srw_sections
 (component_key)
/

ALTER TABLE srw_sections ADD (CONSTRAINT
 srw_sections_fk_component_key FOREIGN KEY 
  (component_key) REFERENCES srw_components
  (component_key))
/

/*
||SRW_LAYOUTS
*/
ALTER TABLE srw_layouts
 ADD (CONSTRAINT srw_layouts_pk PRIMARY KEY 
  (layout_key))
/

CREATE INDEX srw_layouts_fk_closure_ind ON srw_layouts
 (closure)
/

ALTER TABLE srw_layouts ADD (CONSTRAINT
 srw_layouts_fk_closure FOREIGN KEY 
  (closure) REFERENCES srw_closures
  (closure))
/

/*
||SRW_LANES
*/
CREATE INDEX srw_lanes_fk_layout_key_ind ON srw_lanes
 (layout_key)
/

ALTER TABLE srw_lanes ADD (CONSTRAINT
 srw_lanes_fk_layout_key FOREIGN KEY 
  (layout_key) REFERENCES srw_layouts
  (layout_key))
/

CREATE INDEX srw_lanes_fk_component_key_ind ON srw_lanes
 (component_key)
/

ALTER TABLE srw_lanes ADD (CONSTRAINT
 srw_lanes_fk_component_key FOREIGN KEY 
  (component_key) REFERENCES srw_components
  (component_key))
/

/*
||SRW_DIARY
*/
CREATE INDEX srw_diary_fk_layout_key_ind ON srw_diary
 (layout_key)
/

ALTER TABLE srw_diary ADD (CONSTRAINT
 srw_diary_fk_layout_key FOREIGN KEY 
  (layout_key) REFERENCES srw_layouts
  (layout_key))
/

CREATE INDEX srw_diary_fk_closure_ind ON srw_diary
 (closure)
/

ALTER TABLE srw_diary ADD (CONSTRAINT
 srw_diary_fk_closure FOREIGN KEY 
  (closure) REFERENCES srw_closures
  (closure))
/

/*
||SRW_DOCUMENTS
*/
CREATE INDEX srw_documents_fk_closure_ind ON srw_documents
 (closure)
/

ALTER TABLE srw_documents ADD (CONSTRAINT
 srw_documents_fk_closure FOREIGN KEY 
  (closure) REFERENCES srw_closures
  (closure))
/

/*
||SRW_DCM_DAILY
*/
CREATE INDEX srw_dcm_daily_fk_closure_ind ON srw_dcm_daily
 (closure)
/

ALTER TABLE srw_dcm_daily ADD (CONSTRAINT
 srw_dcm_daily_fk_closure FOREIGN KEY 
  (closure) REFERENCES srw_closures
  (closure))
/
