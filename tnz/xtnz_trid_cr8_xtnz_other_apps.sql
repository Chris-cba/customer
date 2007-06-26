
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_cr8_xtnz_other_apps.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_cr8_xtnz_other_apps.sql
--       Date into SCCS   : 05/03/15 03:46:15
--       Date fetched Out : 07/06/06 14:40:35
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------
DROP TABLE xtnz_other_apps
/

CREATE TABLE xtnz_other_apps
     (xoa_hmo_module    VARCHAR2(30) NOT NULL
     )
/



ALTER TABLE xtnz_other_apps
 ADD CONSTRAINT xoa_pk
 PRIMARY KEY (xoa_hmo_module)
/


ALTER TABLE xtnz_other_apps
 ADD CONSTRAINT xoa_hmo_fk
 FOREIGN KEY (xoa_hmo_module)
 REFERENCES hig_modules (hmo_module)
 ON DELETE CASCADE
/

