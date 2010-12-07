CREATE OR REPLACE FORCE VIEW X_NHCC_TMA_SITES_PERMIT_SDO AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/northants/permiting_themes/X_NHCC_TMA_SITES_PERMIT_SDO.vw-arc   1.0   Dec 07 2010 08:41:48   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_NHCC_TMA_SITES_PERMIT_SDO.vw  $
--       Date into PVCS   : $Date:   Dec 07 2010 08:41:48  $
--       Date fetched Out : $Modtime:   Dec 07 2010 08:40:16  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
--
-- View created for Northants as part of BRS 3384 for Northants (NHSWM)
-- this views contains all the sites that are permited.
--
-----------------------------------------------------------------------------
     a.*, b.tsit_geometry
     FROM v_tma_sites a, tma_sites_sdo b 
  WHERE a.tsit_id = b.tsit_id
       AND x_nhswm_phase_permited(tsit_works_id,tsit_phase_no ) = 1;

delete from user_sdo_geom_metadata 
   where table_name = 'X_NHCC_TMA_SITES_PERMIT_SDO';
   
insert into user_sdo_geom_metadata
   select 'X_NHCC_TMA_SITES_PERMIT_SDO', column_name, diminfo, SRID
    from user_sdo_geom_metadata 
  where table_name = 'TMA_SITES_SDO';
  
commit; 
 
