CREATE OR REPLACE FORCE VIEW X_VM_V_ADDRESSLAYER2_SDO
AS   SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid             $Header:   //vm_latest/archives/customer/Virgin/VirginMediaAddressLayer2Update/X_VM_V_ADDRESSLAYER2_SDO.vw-arc   1.0   Dec 18 2012 12:21:36   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_VM_V_ADDRESSLAYER2_SDO.vw  $
--       Date into PVCS   : $Date:   Dec 18 2012 12:21:36  $
--       Date fetched Out : $Modtime:   Dec 18 2012 11:14:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
-----------------------------------------------------------------------------
--
-- written by Aileen Heal for the AddressLayer theme
--
          ADDRESS,
          STREET,
          LOCALITY,
          TOWN,
          POST_TOWN,
          POST_CODE,
          ADMINISTRATIVE_AREA,
          EASTING,
          NORTHING,
          GEOMETRY,
          OBJECTID
     FROM X_VM_ADDRESSLAYER2_SDO_A
/

insert into user_sdo_geom_metadata 
 (  select 'X_VM_V_ADDRESSLAYER2_SDO', column_name,diminfo,srid 
   from user_sdo_geom_metadata where table_name = 'X_VM_ADDRESSLAYER2_SDO_A' )
/     