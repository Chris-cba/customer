
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_acc_reports_cr8tab.sql	1.1 03/15/05
--       Module Name      : xact_acc_reports_cr8tab.sql
--       Date into SCCS   : 05/03/15 03:47:20
--       Date fetched Out : 07/06/06 14:33:37
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
SET FEEDBACK OFF


DROP TABLE xact_acc_intx_ranking
/

CREATE TABLE xact_acc_intx_ranking
   (gri_job_id    NUMBER NOT NULL
   ,ranking       NUMBER
   ,site_id       NUMBER        NOT NULL
   ,site_name     VARCHAR2(30)  NOT NULL
   ,site_descr    VARCHAR2(80)  NOT NULL
   ,score         NUMBER        NOT NULL
   ,fatal_dets    VARCHAR2(240)
   ,serious_dets  VARCHAR2(240)
   ,minor_dets    VARCHAR2(240)
   ,property_dets VARCHAR2(240)
   )
/

CREATE INDEX xair_gri_job_id_ix ON xact_acc_intx_ranking (gri_job_id)
/

DROP TABLE xact_acc_intx_ranking_temp
/

CREATE GLOBAL TEMPORARY TABLE xact_acc_intx_ranking_temp
   (acc_id           NUMBER NOT NULL PRIMARY KEY
   ,acc_intersection NUMBER
   ,alo_ne_id        NUMBER
   )
ON COMMIT DELETE ROWS
/
CREATE INDEX xact_acc_intx_ranking_temp_ix1 ON xact_acc_intx_ranking_temp (acc_intersection)
/

CREATE INDEX xact_acc_intx_ranking_temp_ix2 ON xact_acc_intx_ranking_temp (alo_ne_id)
/

DROP TABLE xact_acc_history_header CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE xact_acc_history_header
   (gri_job_id     NUMBER NOT NULL PRIMARY KEY
   ,module_title   VARCHAR2(80)  NOT NULL
   ,location_descr VARCHAR2(120) NOT NULL
   ,start_date     DATE
   ,end_date       DATE
   ,run_time       NUMBER
   ,run_for        VARCHAR2(80)
   ,run_date       DATE
   )
ON COMMIT DELETE ROWS
/

DROP TABLE xact_acc_history_locations CASCADE CONSTRAINTS;

CREATE GLOBAL TEMPORARY TABLE xact_acc_history_locations
   (gri_job_id     NUMBER NOT NULL
   ,seq_no         NUMBER NOT NULL
   ,location_type  VARCHAR2(30) NOT NULL
   ,location_id    NUMBER NOT NULL
   ,location_descr VARCHAR2(80) NOT NULL
   ,accident_count NUMBER NOT NULL
   )
ON COMMIT DELETE ROWS
/

ALTER TABLE xact_acc_history_locations
 ADD CONSTRAINT xahl_pk PRIMARY KEY (gri_job_id,seq_no)
/


--ALTER TABLE xact_acc_history_locations
-- ADD CONSTRAINT xahl_xahh_fk
-- FOREIGN KEY (gri_job_id)
-- REFERENCES xact_acc_history_header (gri_job_id)
-- ON DELETE CASCADE
--/


DROP TABLE xact_acc_history_accidents CASCADE CONSTRAINTS
/



CREATE GLOBAL TEMPORARY TABLE xact_acc_history_accidents
   (gri_job_id       NUMBER       NOT NULL
   ,xahl_seq_no      NUMBER DEFAULT 1  NOT NULL
   ,acc_id           NUMBER       NOT NULL
   ,police_reference VARCHAR2(30) NOT NULL
   ,acc_date_time    DATE         NOT NULL
   ,acc_severity     VARCHAR2(80)
   ,acc_injury_type  VARCHAR2(80)
   ,acc_type         VARCHAR2(80)
   ,num_cas          NUMBER
   ,num_veh          NUMBER
   ,primary_street   VARCHAR2(80)
   ,road_surface     VARCHAR2(80)
   ,weather          VARCHAR2(80)
   ,rum_code         VARCHAR2(80)
   )
ON COMMIT DELETE ROWS
/

ALTER TABLE xact_acc_history_accidents
 ADD CONSTRAINT xaha_pk PRIMARY KEY (gri_job_id,acc_id)
/

CREATE INDEX xaha_xahl_fk_ix ON xact_acc_history_accidents(gri_job_id, xahl_seq_no)
/


--ALTER TABLE xact_acc_history_accidents
-- ADD CONSTRAINT xaha_xahl_fk
-- FOREIGN KEY (gri_job_id, xahl_seq_no)
-- REFERENCES xact_acc_history_locations (gri_job_id, seq_no)
-- ON DELETE CASCADE
--/

DROP TABLE xact_acc_history_vehicles CASCADE CONSTRAINTS
/

CREATE GLOBAL TEMPORARY TABLE xact_acc_history_vehicles
   (gri_job_id             NUMBER       NOT NULL
   ,acc_id_veh             NUMBER       NOT NULL
   ,acc_id_acc             NUMBER       NOT NULL
   ,vehicle_num            NUMBER       NOT NULL
   ,direction              VARCHAR2(80)
   ,lane                   VARCHAR2(80)
   ,position               VARCHAR2(80)
   ,movement               VARCHAR2(80)
   ,visibility_restriction VARCHAR2(80)
   )
ON COMMIT DELETE ROWS
/

ALTER TABLE xact_acc_history_vehicles
 ADD CONSTRAINT xahv_pk PRIMARY KEY (gri_job_id,acc_id_veh)
/
--ALTER TABLE xact_acc_history_vehicles
-- ADD CONSTRAINT xahv_xaha_fk
-- FOREIGN KEY (gri_job_id,acc_id_acc)
-- REFERENCES xact_acc_history_accidents (gri_job_id,acc_id)
-- ON DELETE CASCADE
--/
CREATE INDEX xahv_xaha_fk_ind ON xact_acc_history_vehicles (gri_job_id,acc_id_acc)
/


SET FEEDBACK ON

