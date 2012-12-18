CREATE OR REPLACE VIEW X_VM_V_ADDLYR2_PRIMARY_ADDS
(
   ADDRESS,
   STREET,
   LOCALITY,
   TOWN,
   POST_TOWN,
   POST_CODE,
   ADMINISTRATIVE_AREA,
   EASTING,
   NORTHING
)
AS
SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/Virgin/VirginMediaAddressLayer2Update/X_VM_V_ADDLYR2_PRIMARY_ADDS.vw-arc   1.0   Dec 18 2012 12:21:34   Ian.Turnbull  $
--       Module Name      : $Workfile:   X_VM_V_ADDLYR2_PRIMARY_ADDS.vw  $
--       Date into PVCS   : $Date:   Dec 18 2012 12:21:34  $
--       Date fetched Out : $Modtime:   Dec 18 2012 11:56:52  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2012
-----------------------------------------------------------------------------
--
-- view created by Aileen Heal for Virgin Mediato to identify all unique postal addresses in Virgin Media
--
            OS_BS7666_PRIMARY_ADD_OBJ_NAME,
            OS_BS7666_STREET,
            OS_BS7666_LOCALITY,
            OS_BS7666_TOWN,
            RM_DP_POST_TOWN,
            OS_BS7666_POSTCODE,
            OS_BS7666_ADMINISTRATIVE_AREA,
            OS_EASTING,
            OS_NORTHING
       FROM X_VM_ADDRESSLAYER2
      WHERE     OS_THEME = 'Postal'
            AND OS_BS7666_PRIMARY_ADD_OBJ_NAME IS NOT NULL
            AND OS_BS7666_PRIMARY_ADD_OBJ_NAME != '0'
   GROUP BY OS_BS7666_PRIMARY_ADD_OBJ_NAME,
            OS_BS7666_STREET,
            OS_BS7666_LOCALITY,
            OS_BS7666_TOWN,
            OS_BS7666_ADMINISTRATIVE_AREA,
            RM_DP_POST_TOWN,
            OS_BS7666_POSTCODE,
            OS_EASTING,
            OS_NORTHING
/            