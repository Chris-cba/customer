CREATE OR REPLACE FORCE VIEW x_dcc_tma_phases_pt_sdo 
AS 
   SELECT 
   ------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/customer/Derby City/BRS7966/x_dcc_tma_phases_pt_sdo.vw-arc   1.0   Apr 20 2012 08:18:26   Ian.Turnbull  $
--       Module Name      : $Workfile:   x_dcc_tma_phases_pt_sdo.vw  $
--       Date into PVCS   : $Date:   Apr 20 2012 08:18:26  $
--       Date fetched Out : $Modtime:   Apr 18 2012 17:42:04  $
--       Version          : $Revision:   1.0  $
--   :
-------------------------------------------------------------------------
--
-- writen by Aileen Heal for DCC as parot of BRS 7966 in April 2012
--  
          a.*,
          b.TPPS_TPHS_ID, b.TPPS_TPHS_GEOMETRY,
          b.TPPS_TPHS_FEATURE_TYPE
     FROM x_dcc_tma_wks_active_phs_dets a, tma_phases_point_sdo b
    WHERE a.tphs_phase_id = b.tpps_tphs_id
/    
    
insert into user_sdo_geom_metadata 
select 'X_DCC_TMA_PHASES_PT_SDO', COLUMN_NAME, DIMINFO, SRID
from user_sdo_geom_metadata where table_name = 'TMA_PHASES_POINT_SDO'
/