CREATE OR REPLACE FORCE VIEW HA_NETWORK_SDO (LABEL, NE_ID,NE_SUB_TYPE, SHAPE)
AS SELECT
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/HA/themes/HA_NETWORK_SDO.vw-arc   1.0   Jun 26 2012 11:46:28   Ian.Turnbull  $
--       Module Name      : $Workfile:   HA_NETWORK_SDO.vw  $
--       Date into PVCS   : $Date:   Jun 26 2012 11:46:28  $
--       Date fetched Out : $Modtime:   Jun 18 2012 13:35:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Aileen Heal
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Systems (UK) ltd, 2012
-----------------------------------------------------------------------------
--
    sdo.LABEL,
    sdo.NE_ID,
    ne.NE_SUB_TYPE,
    sdo.SHAPE
  FROM
    HA_NETWORK_SDO_TABLE sdo, nm_elements ne
  WHERE sdo.ne_id = ne.ne_id
/

