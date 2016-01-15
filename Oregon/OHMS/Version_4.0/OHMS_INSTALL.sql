-- install OHMS

-- This application requires HPMS to be installed first.

set sqlblanklines on

@ OHMS_SECURITY.sql

@ ohms_menus.sql

@ Create_OHMS_merge.sql



@ OHMS_TABLES.sql

				 --@ OHMS_CREATE_VIEWS.sql  -- Unneeded   Now done in prereq install

				/* ---------- JM, 2011.07.29,13:59
				@ V_NM_CURB137_OUTER_MV_NW.vw
				@ V_NM_NBI104_OUTER_MV_NW.vw
				@ V_NM_RDGM107_COUNT_MV_NW.vw
				@ V_NM_RDGM109_COUNT_MV_NW.vw
				@ V_NM_RDGM110_COUNT_MV_NW.vw
				@ V_NM_RDGM111_COUNT_MV_NW.vw
				@ V_NM_RDGM137_OUTER_MV_NW.vw
				@ V_NM_RDGM138_SUM_MV_NW.vw
				@ V_NM_RDGM139_SUM_MV_NW.vw

				@ V_NM_ROAD131_COUNT_MV_NW.vw

				@ V_NM_ROAD133_COUNT_MV_NW.vw

				@ V_NM_SHLD137_OUTER_MV_NW.vw
				@ V_NM_SPZN114_OUTER_MV_NW.vw
				@ V_NM_TUNL104_OUTER_MV_NW.vw
				@ V_NM_URBN114_OUTER_MV_NT.vw
				---------- */

--@ XODOT_POPULATE_OHMS_SECTIONS.prc  -- changed to use HPMS   XNA_HPMS_POPULATE_7

@ xodot_OHMS.pks

@ xodot_OHMS.pkb

