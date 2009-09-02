------------------------------------------------------------------------------
--
--  THIS SCRIPT WAS WRITTEN AS PART OF SoW 10521 REQUIREMENT REF: 12.1.3.1
--  by Aileen Heal
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/tma_works_point.sql-arc   3.0   Sep 02 2009 11:58:22   Ian Turnbull  $
--       Module Name      : $Workfile:   tma_works_point.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:22  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
CREATE OR REPLACE VIEW X_V_TMA_WORKS_POINT
AS 
SELECT 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN AS PART OF SoW 10521 by Aileen Heal
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/tma_works_point.sql-arc   3.0   Sep 02 2009 11:58:22   Ian Turnbull  $
--       Module Name      : $Workfile:   tma_works_point.sql  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:22  $
--       Date fetched Out : $Modtime:   Sep 02 2009 11:33:00  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
        a.*, b.geometry
   FROM v_tma_works_active_phase_dets a, X_V_TMA_PHASES_POINTS b
 WHERE a.tphs_phase_id = b.tphs_id
 and tphs_phase_status in ('ADV_PLAN', 'ACCEPTED', 'AWAIT_RESPONSE', 'UNASSIGNED', 'CREATED', 'FWD_PLAN', 'WIP', 'ABOUT_TO_START');


insert into user_sdo_geom_metadata
select 'X_V_TMA_WORKS_POINT', column_name, diminfo, srid
from user_sdo_geom_metadata where table_name = 'X_V_TMA_PHASES_POINTS'
and not exists (select 'x' from USER_SDO_GEOM_METADATA WHERE TABLE_NAME = 'X_V_TMA_WORKS_POINT'); 

commit;
/    