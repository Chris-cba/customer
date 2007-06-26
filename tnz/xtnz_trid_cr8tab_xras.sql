
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xtnz_trid_cr8tab_xras.sql	1.1 03/15/05
--       Module Name      : xtnz_trid_cr8tab_xras.sql
--       Date into SCCS   : 05/03/15 03:46:14
--       Date fetched Out : 07/06/06 14:40:36
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd
-----------------------------------------------------------------------------

DROP TABLE xtnz_role_user_assocs
/

CREATE TABLE  xtnz_role_user_assocs
    (xras_role     VARCHAR2(30) NOT NULL PRIMARY KEY
    ,xras_username VARCHAR2(30) NOT NULL UNIQUE
    ,xras_password VARCHAR2(30) NOT NULL
    )
/

