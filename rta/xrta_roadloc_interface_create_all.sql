--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_create_all.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_create_all.sql
--       Date into SCCS   : 05/03/15 23:05:25
--       Date fetched Out : 07/06/06 14:39:30
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
@drop_all

CREATE SEQUENCE audit_id_seq;

@create_all_tables

@create_all_triggers

@grants
