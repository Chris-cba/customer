-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/customer/HA/nem/srw_data_migration/srw_tabs.sql-arc   3.1   Oct 05 2015 19:28:28   Mike.Huitson  $
--       Module Name      : $Workfile:   srw_tabs.sql  $
--       Date into PVCS   : $Date:   Oct 05 2015 19:28:28  $
--       Date fetched Out : $Modtime:   Oct 05 2015 19:24:32  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version :
------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
CREATE TABLE srw_closures
(closure                        NUMBER
,start_date                     DATE
,end_date                       DATE
,road                           VARCHAR2 (50)
,operational_area               VARCHAR2 (6)
,notes                          VARCHAR2 (2000)
,description                    VARCHAR2 (2000)
,login                          VARCHAR2 (20)
,modified                       DATE
,expected_delay                 VARCHAR2 (2)
,historic_closure_type          VARCHAR2 (5)
,project_manager                VARCHAR2 (50)
,project_manager_tel            VARCHAR2 (30)
,contractor_name                VARCHAR2 (50)
,contractor_tel                 VARCHAR2 (30)
,activity                       VARCHAR2 (10)
,reference_number               VARCHAR2 (30)
,traffic_management             VARCHAR2 (10)
,client                         VARCHAR2 (10)
,nature_of_works                VARCHAR2 (10)
,contract_number                VARCHAR2 (30)
,location_textual               VARCHAR2 (70)
,record_visible_to_public       VARCHAR2 (3)
,summary_or_detail              VARCHAR2 (10)
,hardshoulder_only              VARCHAR2 (3)
,closed_lanes                   VARCHAR2 (10)
,added_lanes                    VARCHAR2 (10)
,times_peak                     VARCHAR2 (3)
,times_offpeak                  VARCHAR2 (3)
,times_night                    VARCHAR2 (3)
,temporary_speed_limit          VARCHAR2 (10)
,narrow_lanes                   VARCHAR2 (3)
,closure_status                 VARCHAR2 (10)
,closure_parent                 NUMBER
,published                      VARCHAR2 (1)
,published_date                 DATE
,published_end_date             DATE
,escalation                     VARCHAR2 (10)
,dcm_status                     VARCHAR2 (50)
,dcm_delay_time_in_veh_hrs      NUMBER (12,2)
,dcm_delay_cost                 NUMBER (12,2)
,dcm_time_per_veh_in_mins       NUMBER (12,2)
,dcm_cost_per_veh               NUMBER (12,2)
,dcm_psa_delay_time_in_veh_hrs  NUMBER (12,2)
,dcm_psa_delay_cost             NUMBER (12,2)
,dcm_psa_time_per_veh_in_mins   NUMBER (12,2)
,dcm_psa_cost_per_veh           NUMBER (12,2)
,dcm_contraflow                 VARCHAR2 (3)
,dcm_calculation_date           DATE
,closure_type                   VARCHAR2 (50)
,eton_reference                 VARCHAR2 (30)
,eton_filename                  VARCHAR2 (100))
/

CREATE TABLE srw_components
(component_key     NUMBER
,closure           NUMBER
,component_length  NUMBER(12,3)
,name              VARCHAR2(50))
/

CREATE TABLE srw_sections
(component_key       NUMBER 
,component_start     NUMBER(12,3)
,component_end       NUMBER(12,3)
,label               VARCHAR2(20)
,section_start_date  DATE
,start_offset        NUMBER(12,3)
,end_offset          NUMBER(12,3))
/

CREATE TABLE srw_layouts
(layout_key  NUMBER
,closure     NUMBER
,name        VARCHAR2(50))
/

CREATE TABLE srw_lanes
(layout_key     NUMBER
,component_key  NUMBER
,lane           VARCHAR2(3)
,from_offset    NUMBER(12,3)
,to_offset      NUMBER(12,3)
,lane_status    VARCHAR2(10))
/

CREATE TABLE srw_diary
(closure     NUMBER
,start_date  DATE
,end_date    DATE
,layout_key  NUMBER)
/

CREATE TABLE srw_documents
(closure        NUMBER
,description    VARCHAR2(2000)
,document       VARCHAR2(200)
,document_size  NUMBER
,submitted_by   VARCHAR2(20)
,submitted_on   DATE
,document_name  VARCHAR2(2000))
/

CREATE TABLE srw_dcm_daily
(closure            NUMBER
,delay_day          DATE
,delay_time         NUMBER(15,6)
,delay_cost         NUMBER(15,6)
,vehicle_count      NUMBER(15,6)
,psa_delay_time     NUMBER(15,6)
,psa_delay_cost     NUMBER(15,6)
,psa_vehicle_count  NUMBER(15,6))
/

CREATE TABLE srw_to_nem_log
(stn_id           NUMBER(30)
,stn_timestamp    TIMESTAMP
,stn_closure      NUMBER
,stn_message_type VARCHAR2(20)
,stn_message      VARCHAR2(1000))
/

CREATE SEQUENCE stn_id_seq
/
