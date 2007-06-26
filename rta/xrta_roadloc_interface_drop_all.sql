--   SCCS Identifiers :-
--
--       sccsid           : @(#)xrta_roadloc_interface_drop_all.sql	1.1 03/15/05
--       Module Name      : xrta_roadloc_interface_drop_all.sql
--       Date into SCCS   : 05/03/15 23:05:28
--       Date fetched Out : 07/06/06 14:39:31
--       SCCS Version     : 1.1
--
--   ROADLOC audit interface code
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
DROP SEQUENCE audit_id_seq;

DROP TABLE rrl_la_aud;
DROP TRIGGER rrl_la_aud_trig;

DROP TABLE rrl_la_rel_aud;
DROP TRIGGER rrl_la_rel_aud_trig;

DROP TABLE rrl_lcwy_aud;
DROP TRIGGER rrl_lcwy_aud_trig;

DROP TABLE rrl_lcwy_in_la_aud;
DROP TRIGGER rrl_lcwy_in_la_mem_trig;
DROP TRIGGER rrl_lcwy_in_la_mem_mnum_trig;
DROP TRIGGER rrl_lcwy_in_la_inv_trig;
DROP TRIGGER rrl_lcwy_in_la_inv_mnum_trig;

DROP TABLE rrl_lcwy_lc_class_aud;
DROP TRIGGER rrl_lcwy_lc_class_aud_trig;

DROP TABLE rrl_rf_on_lcwy_aud;
DROP TRIGGER rrl_rf_on_lcwy_inv_trig;
DROP TRIGGER rrl_rf_on_lcwy_mem_trig;

DROP TABLE rrl_rf_type_aud;
DROP TRIGGER rrl_rf_type_aud_trig;

DROP TABLE rrl_road_aud;
DROP TRIGGER rrl_road_aud_trig;

DROP TABLE rrl_sect_aud;
DROP TRIGGER rrl_sect_aud_trig;
