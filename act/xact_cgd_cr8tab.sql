--   SCCS Identifiers :-
--
--       sccsid           : @(#)xact_cgd_cr8tab.sql	1.1 03/14/05
--       Module Name      : xact_cgd_cr8tab.sql
--       Date into SCCS   : 05/03/14 23:10:49
--       Date fetched Out : 07/06/06 14:33:40
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   ACT CGD Interface table
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
DROP TABLE xact_cgd_tables
/

CREATE TABLE xact_cgd_tables
   (xct_table_name        VARCHAR2(30) NOT NULL PRIMARY KEY
   ,xct_nit_inv_type      VARCHAR2(4)
   ,xct_last_refresh_date DATE         DEFAULT TO_DATE('01011901','DDMMYYYY') NOT NULL
   )
/

