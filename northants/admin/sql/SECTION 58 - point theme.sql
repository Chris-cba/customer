  ------------------------------------------------------------------------------
  --
  --  THIS SCRIPT WAS WRITTEN by Aileen Heal for Northants as part of SoW 10621
  --
  --   This script create a theme to show TMA restrictions where the restriction status
  --   is IN FORCE or PROPOSED. The theme is colour coded by status i.e. Proposed or In FORCE
  --
  --   N.B. REQUIRE the following STYLES
  --   M.TFL.RESTRICTIONS.PROPOSED
  --   M.TFL.RESTRICTIONS.IN FORCE
  --   V.TFL.RESTRICTIONS - POINT
  --
  -----------------------------------------------------------------------------
  --
  --   PVCS Identifiers :-
  --
  --       pvcsid           : $Header:   //vm_latest/archives/customer/northants/admin/sql/SECTION 58 - point theme.sql-arc   3.0   Sep 17 2009 14:10:12   Ian Turnbull  $
  --       Module Name      : $Workfile:   SECTION 58 - point theme.sql  $
  --       Date into PVCS   : $Date:   Sep 17 2009 14:10:12  $
  --       Date fetched Out : $Modtime:   Sep 17 2009 12:34:28  $
  --       PVCS Version     : $Revision:   3.0  $
  --
  --
  --   Author : Aileen Heal
  --
  -----------------------------------------------------------------------------
  --	Copyright (c) exor corporation ltd, 2004
  -----------------------------------------------------------------------------
  --

INSERT INTO USER_SDO_GEOM_METADATA
   ( select TABLE_NAME, USER ||'.X_GET_MID_POINT(TRES_GEOMETRY)', diminfo, srid
       from user_sdo_geom_metadata 
      where table_name = 'TMA_RESTRICTIONS_SDO' AND ROWNUM = 1
    );
    
create index tma_restrictions_sdo_fun_indx on TMA_RESTRICTIONS_SDO(NORTHANTS.X_GET_MID_POINT(TRES_GEOMETRY))
indextype is mdsys.spatial_index parameters('LAYER_GTYPE=POINT');

create or replace view X_V_TMA_RESTRICTIONS_PT_SDO 
as select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN by Aileen Heal for Northants as part of SoW 10621
--
--   This view is based upon the base theme (TMA_RESTRICTIONS_SDO) but 
--   converts the lines to points
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/admin/sql/SECTION 58 - point theme.sql-arc   3.0   Sep 17 2009 14:10:12   Ian Turnbull  $
--       Module Name      : $Workfile:   SECTION 58 - point theme.sql  $
--       Date into PVCS   : $Date:   Sep 17 2009 14:10:12  $
--       Date fetched Out : $Modtime:   Sep 17 2009 12:34:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
            TRES_RESTRICTION_ID, 
            NORTHANTS.X_GET_MID_POINT(TRES_GEOMETRY) tres_pt_geometry  
       from TMA_RESTRICTIONS_SDO;

insert into user_sdo_geom_metadata
   select 'X_V_TMA_RESTRICTIONS_PT_SDO', 
          'TRES_PT_GEOMETRY', 
          diminfo, 
          srid
     from user_sdo_geom_metadata 
    where table_name = 'TMA_RESTRICTIONS_SDO'
      and rownum = 1;

create or replace view X_V_S58_POINT as
select 
------------------------------------------------------------------------------
--  THIS VIEW WAS WRITTEN by Aileen Heal for Northants as part of SoW 10621
--
--   This view displays all the TMA restrictions where the restriction status
--   is IN FORCE or PROPOSED AS A POINT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/northants/admin/sql/SECTION 58 - point theme.sql-arc   3.0   Sep 17 2009 14:10:12   Ian Turnbull  $
--       Module Name      : $Workfile:   SECTION 58 - point theme.sql  $
--       Date into PVCS   : $Date:   Sep 17 2009 14:10:12  $
--       Date fetched Out : $Modtime:   Sep 17 2009 12:34:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
     a.*, b.TRES_PT_GEOMETRY
     FROM v_tma_restrictions a, X_V_TMA_RESTRICTIONS_PT_SDO b
    WHERE a.tres_restriction_id = b.tres_restriction_id
    AND TRES_RESTRICTION_STATUS IN ('PROPOSED', 'IN_FORCE');
     
     
insert into user_sdo_geom_metadata
   select 'X_V_S58_POINT', 
          'TRES_PT_GEOMETRY', 
          diminfo, 
          srid
     from user_sdo_geom_metadata 
    where table_name = 'TMA_RESTRICTIONS_SDO'
      and rownum = 1;

     
COMMIT;
/
  
  