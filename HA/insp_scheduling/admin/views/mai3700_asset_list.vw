DROP VIEW mai3700_asset_list
/

CREATE OR REPLACE FORCE VIEW mai3700_asset_list
(
   NIT_INV_TYPE,
   NIT_DESCR
)
AS
   SELECT 
   --
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/customer/HA/insp_scheduling/admin/views/mai3700_asset_list.vw-arc   1.0   Jun 06 2012 16:20:12   Ian.Turnbull  $
--       Module Name      : $Workfile:   mai3700_asset_list.vw  $
--       Date into PVCS   : $Date:   Jun 06 2012 16:20:12  $
--       Date fetched Out : $Modtime:   Jun 06 2012 14:33:54  $
--       PVCS Version     : $Revision:   1.0  $
--
--
--   Author : Paul Stanton
--
-----------------------------------------------------------------------------
--	Copyright (c) Bentley Ltd, 2012
-----------------------------------------------------------------------------
--
   nit_inv_type, nit_descr
     FROM nm_inv_types
    WHERE NIT_INV_TYPE IN
             (SELECT ITG_PARENT_INV_TYPE
                FROM NM_INV_TYPE_GROUPINGS_ALL
               WHERE ITG_INV_TYPE = 'INSP' AND ITG_END_DATE IS NULL)
   UNION
   SELECT 'ALL', 'All Inspectable Asset Types' FROM DUAL
   ORDER BY 1 ASC
/   