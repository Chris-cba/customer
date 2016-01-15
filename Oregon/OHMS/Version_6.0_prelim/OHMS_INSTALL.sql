-- install OHMS

-- This application requires HPMS to be installed first.

set sqlblanklines on

@ OHMS_TABLES.sql

--  HPMS Prereqs
@OHMS_OHMS_MV_CREATE.sql
@OHMS_OHMS_7_Views.sql
@OHMS_OHMS_7_Final_views.sql



-- OHMS
@ OHMS_SECURITY.sql

@ ohms_menus.sql

@V_NM_SECW.vw

@ Create_OHMS_merge.sql

@XODOT_POPULATE_OHMS_SECTIONS.prc

@ xodot_OHMS.pks

@ xodot_OHMS.pkb

/