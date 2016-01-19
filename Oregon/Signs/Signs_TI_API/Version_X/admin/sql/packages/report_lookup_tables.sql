/*
	The contents of this document, including system ideas and concepts, 
	are confidential and proprietary in nature and are not to be distributed 
	in any form without the prior written consent of Bentley Systems.
	
	file: report_lookup_tables
	Author: JMM
	UPDATE01:	Original, 2015.06.05, JMM
*/

/* ************************************************************
	Object:		REPORTS.X_SIGNS_TBLHWYLKUP_IN, REPORTS.X_SIGNS_TBLHWYLKUP_OUT
	Purpose:	Temporary tables used by the reports.xodot_rollup_mp package for mile point roll-up of the SFA lookup table: TBLHWYLKUP
	Notes:	
	Created:	2015.06.05	J.Mendoza
************************************************************* */

--DROP TABLE REPORTS.X_SIGNS_TBLHWYLKUP_IN CASCADE CONSTRAINTS;

CREATE GLOBAL TEMPORARY TABLE REPORTS.X_SIGNS_TBLHWYLKUP_IN
(
  LRM_KEY    CHAR(8 BYTE)                       NOT NULL,
  BEG_MP_NO  NUMBER(7,2)                        NOT NULL,
  END_MP_NO  NUMBER(7,2)                        NOT NULL,
  HWY_NO     CHAR(5 BYTE)                       NOT NULL,
  IS_RTE     CHAR(5 BYTE),
  US_RTE_1   CHAR(7 BYTE),
  OR_RTE_1   CHAR(7 BYTE),
  DIST       CHAR(3 BYTE)                       NOT NULL,
  CREW       CHAR(4 BYTE)                       NOT NULL,
  EA_NO      CHAR(8 BYTE)                       NOT NULL
)
ON COMMIT PRESERVE ROWS
RESULT_CACHE (MODE DEFAULT)
NOCACHE;

--DROP TABLE REPORTS.X_SIGNS_TBLHWYLKUP_OUT CASCADE CONSTRAINTS;

CREATE GLOBAL TEMPORARY TABLE REPORTS.X_SIGNS_TBLHWYLKUP_OUT
(
  LRM_KEY    CHAR(8 BYTE)                       NOT NULL,
  BEG_MP_NO  NUMBER(7,2)                        NOT NULL,
  END_MP_NO  NUMBER(7,2)                        NOT NULL,
  HWY_NO     CHAR(5 BYTE)                       NOT NULL,
  IS_RTE     CHAR(5 BYTE),
  US_RTE_1   CHAR(7 BYTE),
  OR_RTE_1   CHAR(7 BYTE),
  DIST       CHAR(3 BYTE)                       NOT NULL,
  CREW       CHAR(4 BYTE)                       NOT NULL,
  EA_NO      CHAR(8 BYTE)                       NOT NULL
)
ON COMMIT PRESERVE ROWS
RESULT_CACHE (MODE DEFAULT)
NOCACHE;
